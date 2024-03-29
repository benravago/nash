package es.runtime;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.function.Supplier;

import java.lang.invoke.CallSite;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.invoke.MutableCallSite;
import java.lang.invoke.SwitchPoint;

import jdk.dynalink.linker.GuardedInvocation;

import es.codegen.Compiler;
import es.codegen.Compiler.CompilationPhases;
import es.codegen.types.ArrayType;
import es.codegen.types.Type;
import es.ir.FunctionNode;
import es.objects.annotations.SpecializedFunction.LinkLogic;
import es.runtime.linker.Bootstrap;
import static es.lookup.Lookup.MH;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;
import static es.runtime.UnwarrantedOptimismException.isValid;

/**
 * A version of a JavaScript function, native or JavaScript.
 *
 * Supports lazily generating a constructor version of the invocation.
 */
final class CompiledFunction {

  private static final MethodHandle NEWFILTER = findOwnMH("newFilter", Object.class, Object.class, Object.class);
  private static final MethodHandle RELINK_COMPOSABLE_INVOKER = findOwnMH("relinkComposableInvoker", void.class, CallSite.class, CompiledFunction.class, boolean.class);
  private static final MethodHandle HANDLE_REWRITE_EXCEPTION = findOwnMH("handleRewriteException", MethodHandle.class, CompiledFunction.class, OptimismInfo.class, RewriteException.class);
  private static final MethodHandle RESTOF_INVOKER = MethodHandles.exactInvoker(MethodType.methodType(Object.class, RewriteException.class));

  static final Collection<CompiledFunction> NO_FUNCTIONS = Collections.emptySet();

  // The method type may be more specific than the invoker, if. e.g. the invoker is guarded, and a guard with a generic object only fallback, while the target is more specific, we still need the more specific type for sorting
  private MethodHandle invoker;

  private MethodHandle constructor;
  private OptimismInfo optimismInfo;
  private final int flags; // from FunctionNode
  private final MethodType callSiteType;

  private final Specialization specialization;

  CompiledFunction(MethodHandle invoker) {
    this(invoker, null, null);
  }

  static CompiledFunction createBuiltInConstructor(MethodHandle invoker, Specialization specialization) {
    return new CompiledFunction(MH.insertArguments(invoker, 0, false), createConstructorFromInvoker(MH.insertArguments(invoker, 0, true)), specialization);
  }

  CompiledFunction(MethodHandle invoker, MethodHandle constructor, Specialization specialization) {
    this(invoker, constructor, 0, null, specialization);
  }

  CompiledFunction(MethodHandle invoker, MethodHandle constructor, int flags, MethodType callSiteType, Specialization specialization) {
    this.specialization = specialization;
    if (specialization != null && specialization.isOptimistic()) {
      // An optimistic builtin with isOptimistic=true works like any optimistic generated function, i.e. it can throw unwarranted optimism exceptions.
      // As native functions trivially can't have parts of them regenerated as "restOf" methods, this only works if the methods are atomic/functional in their behavior and doesn't modify state before an UOE can be thrown.
      // If they aren't, we can reexecute a wider version of the same builtin in a recompilation handler for FinalScriptFunctionData.
      // There are several candidate methods in Native* that would benefit from this, but I haven't had time to implement any of them currently.
      // In order to fit in with the relinking framework, the current thinking is that the methods still take a program point to fit in with other optimistic functions, but it is set to "first", which is the beginning of the method. The relinker can tell the difference between builtin and JavaScript functions.
      // This might change. TODO
      this.invoker = MH.insertArguments(invoker, invoker.type().parameterCount() - 1, UnwarrantedOptimismException.FIRST_PROGRAM_POINT);
      throw new AssertionError("Optimistic (UnwarrantedOptimismException throwing) builtin functions are currently not in use");
    }
    this.invoker = invoker;
    this.constructor = constructor;
    this.flags = flags;
    this.callSiteType = callSiteType;
  }

  CompiledFunction(MethodHandle invoker, RecompilableScriptFunctionData functionData, Map<Integer, Type> invalidatedProgramPoints, MethodType callSiteType, int flags) {
    this(invoker, null, flags, callSiteType, null);
    optimismInfo = ((flags & FunctionNode.IS_DEOPTIMIZABLE) != 0) ? new OptimismInfo(functionData, invalidatedProgramPoints) :null;
  }

  static CompiledFunction createBuiltInConstructor(MethodHandle invoker) {
    return new CompiledFunction(MH.insertArguments(invoker, 0, false), createConstructorFromInvoker(MH.insertArguments(invoker, 0, true)), null);
  }

  boolean isSpecialization() {
    return specialization != null;
  }

  boolean hasLinkLogic() {
    return getLinkLogicClass() != null;
  }

  Class<? extends LinkLogic> getLinkLogicClass() {
    if (isSpecialization()) {
      var linkLogicClass = specialization.getLinkLogicClass();
      assert !LinkLogic.isEmpty(linkLogicClass) : "empty link logic classes should have been removed by nasgen";
      return linkLogicClass;
    }
    return null;
  }

  boolean convertsNumericArgs() {
    return isSpecialization() && specialization.convertsNumericArgs();
  }

  int getFlags() {
    return flags;
  }

  /**
   * An optimistic specialization is one that can throw UnwarrantedOptimismException.
   * This is allowed for native methods, as long as they are functional, i.e. don't change any state between entering and throwing the UOE.
   * Then we can re-execute a wider version of the method in the continuation.
   * Rest-of method generation for optimistic builtins is of course not possible, but this approach works and fits into the same relinking framework
   * @return true if optimistic builtin
   */
  boolean isOptimistic() {
    return isSpecialization() ? specialization.isOptimistic() : false;
  }

  boolean isApplyToCall() {
    return (flags & FunctionNode.HAS_APPLY_TO_CALL_SPECIALIZATION) != 0;
  }

  boolean isVarArg() {
    return isVarArgsType(invoker.type());
  }

  @Override
  public String toString() {
    var linkLogicClass = getLinkLogicClass();
    return "[invokerType=" + invoker.type() + " ctor=" + constructor + " weight=" + weight() + " linkLogic=" + (linkLogicClass != null ? linkLogicClass.getSimpleName() : "none");
  }

  boolean needsCallee() {
    return ScriptFunctionData.needsCallee(invoker);
  }

  /**
   * Returns an invoker method handle for this function.
   * Note that the handle is safely composable in the sense that you can compose it with other handles using any combinators even if you can't affect call site invalidation.
   * If this compiled function is non-optimistic, then it returns the same value as {@link #getInvokerOrConstructor(boolean)}.
   & However, if the function is optimistic, then this handle will incur an overhead as it will add an intermediate internal call site that can relink itself when the function needs to regenerate its code to always point at the latest generated code version.
   * @return a guaranteed composable invoker method handle for this function.
   */
  MethodHandle createComposableInvoker() {
    return createComposableInvoker(false);
  }

  /**
   * Returns an invoker method handle for this function when invoked as a constructor.
   * Note that the handle should be considered non-composable in the sense that you can only compose it with other handles using any combinators if you can ensure that the composition is guarded by {@link #getOptimisticAssumptionsSwitchPoint()} if it's non-null, and that you can relink the call site it is set into as a target if the switch point is invalidated.
   * In all other cases, use {@link #createComposableConstructor()}.
   * @return a direct constructor method handle for this function.
   */
  MethodHandle getConstructor() {
    if (constructor == null) {
      constructor = createConstructorFromInvoker(createInvokerForPessimisticCaller());
    }
    return constructor;
  }

  /**
   * Creates a version of the invoker intended for a pessimistic caller (return type is Object, no caller optimistic program point available).
   * @return a version of the invoker intended for a pessimistic caller.
   */
  MethodHandle createInvokerForPessimisticCaller() {
    return createInvoker(Object.class, INVALID_PROGRAM_POINT);
  }

  /**
   * Compose a constructor from an invoker.
   * @param invoker         invoker
   * @return the composed constructor
   */
  static MethodHandle createConstructorFromInvoker(MethodHandle invoker) {
    var needsCallee = ScriptFunctionData.needsCallee(invoker);
    // If it was (callee, this, args...), permute it to (this, callee, args...).
    // We're doing this because having "this" in the first argument position is what allows the elegant folded composition of (newFilter x constructor x allocator) further down below in the code.
    // Also, ensure the composite constructor always returns Object.
    var swapped = needsCallee ? swapCalleeAndThis(invoker) : invoker;
    var returnsObject = MH.asType(swapped, swapped.type().changeReturnType(Object.class));
    var ctorType = returnsObject.type();
    // Construct a dropping type list for NEWFILTER, but don't include constructor "this" into it, so it's actually captured as "allocation" parameter of NEWFILTER after we fold the constructor into it.
    // (this, [callee, ]args...) => ([callee, ]args...)
    var ctorArgs = ctorType.dropParameterTypes(0, 1).parameterArray();
    // Fold constructor into newFilter that replaces the return value from the constructor with the originally allocated value when the originally allocated value is a JS primitive (String, Boolean, Number).
    // (result, this, [callee, ]args...) x (this, [callee, ]args...) => (this, [callee, ]args...)
    var filtered = MH.foldArguments(MH.dropArguments(NEWFILTER, 2, ctorArgs), returnsObject);
    // allocate() takes a ScriptFunction and returns a newly allocated ScriptObject...
    if (needsCallee) {
      // ...we either fold it into the previous composition, if we need both the ScriptFunction callee object and the newly allocated object in the arguments,
      // so (this, callee, args...) x (callee) => (callee, args...), or...
      return MH.foldArguments(filtered, ScriptFunction.ALLOCATE);
    }
    // ...replace the ScriptFunction argument with the newly allocated object, if it doesn't need the callee
    // (this, args...) filter (callee) => (callee, args...)
    return MH.filterArguments(filtered, 0, ScriptFunction.ALLOCATE);
  }

  /**
   * Permutes the parameters in the method handle from {@code (callee, this, ...)} to {@code (this, callee, ...)}.
   * Used when creating a constructor handle.
   * @param mh a method handle with order of arguments {@code (callee, this, ...)}
   * @return a method handle with order of arguments {@code (this, callee, ...)}
   */
  static MethodHandle swapCalleeAndThis(MethodHandle mh) {
    var type = mh.type();
    assert type.parameterType(0) == ScriptFunction.class : type;
    assert type.parameterType(1) == Object.class : type;
    var newType = type.changeParameterType(0, Object.class).changeParameterType(1, ScriptFunction.class);
    var reorder = new int[type.parameterCount()];
    reorder[0] = 1;
    assert reorder[1] == 0;
    for (var i = 2; i < reorder.length; ++i) {
      reorder[i] = i;
    }
    return MethodHandles.permuteArguments(mh, newType, reorder);
  }

  /**
   * Returns an invoker method handle for this function when invoked as a constructor.
   * Note that the handle is safely composable in the sense that you can compose it with other handles using any combinators even if you can't affect call site invalidation.
   * If this compiled function is non-optimistic, then it returns the same value as {@link #getConstructor()}.
   * However, if the function is optimistic, then this handle will incur an overhead as it will add an intermediate internal call site that can relink itself when the function needs to regenerate its code to always point at the latest generated code version.
   * @return a guaranteed composable constructor method handle for this function.
   */
  MethodHandle createComposableConstructor() {
    return createComposableInvoker(true);
  }

  boolean hasConstructor() {
    return constructor != null;
  }

  MethodType type() {
    return invoker.type();
  }

  int weight() {
    return weight(type());
  }

  static int weight(MethodType type) {
    if (isVarArgsType(type)) {
      return Integer.MAX_VALUE; //if there is a varargs it should be the heavist and last fallback
    }
    var weight = Type.typeFor(type.returnType()).getWeight();
    for (var i = 0; i < type.parameterCount(); i++) {
      var paramType = type.parameterType(i);
      var pweight = Type.typeFor(paramType).getWeight() * 2; //params are more important than call types as return values are always specialized
      weight += pweight;
    }
    weight += type.parameterCount(); //more params outweigh few parameters
    return weight;
  }

  static boolean isVarArgsType(MethodType type) {
    assert type.parameterCount() >= 1 : type;
    return type.parameterType(type.parameterCount() - 1) == Object[].class;
  }

  static boolean moreGenericThan(MethodType mt0, MethodType mt1) {
    return weight(mt0) > weight(mt1);
  }

  boolean betterThanFinal(CompiledFunction other, MethodType callSiteMethodType) {
    // Prefer anything over nothing, as we can't compile new versions.
    return (other == null) || betterThanFinal(this, other, callSiteMethodType);
  }

  static boolean betterThanFinal(CompiledFunction cf, CompiledFunction other, MethodType callSiteMethodType) {
    var thisMethodType = cf.type();
    var otherMethodType = other.type();
    var thisParamCount = getParamCount(thisMethodType);
    var otherParamCount = getParamCount(otherMethodType);
    var callSiteRawParamCount = getParamCount(callSiteMethodType);
    var csVarArg = callSiteRawParamCount == Integer.MAX_VALUE;
    // Subtract 1 for callee for non-vararg call sites
    var callSiteParamCount = csVarArg ? callSiteRawParamCount : callSiteRawParamCount - 1;
    // Prefer the function that discards less parameters
    var thisDiscardsParams = Math.max(callSiteParamCount - thisParamCount, 0);
    var otherDiscardsParams = Math.max(callSiteParamCount - otherParamCount, 0);
    if (thisDiscardsParams < otherDiscardsParams) {
      return true;
    }
    if (thisDiscardsParams > otherDiscardsParams) {
      return false;
    }
    var thisVarArg = thisParamCount == Integer.MAX_VALUE;
    var otherVarArg = otherParamCount == Integer.MAX_VALUE;
    if (!(thisVarArg && otherVarArg && csVarArg)) {
      // At least one of them isn't vararg
      var thisType = toTypeWithoutCallee(thisMethodType, 0); // Never has callee
      var otherType = toTypeWithoutCallee(otherMethodType, 0); // Never has callee
      var callSiteType = toTypeWithoutCallee(callSiteMethodType, 1); // Always has callee
      var narrowWeightDelta = 0;
      var widenWeightDelta = 0;
      var minParamsCount = Math.min(Math.min(thisParamCount, otherParamCount), callSiteParamCount);
      var convertsNumericArgs = cf.convertsNumericArgs();
      for (var i = 0; i < minParamsCount; ++i) {
        var callSiteParamType = getParamType(i, callSiteType, csVarArg);
        var thisParamType = getParamType(i, thisType, thisVarArg);
        if (!convertsNumericArgs && callSiteParamType.isBoolean() && thisParamType.isNumeric()) {
          // When an argument is converted to number by a function it is safe to "widen" booleans to numeric types.
          // However, we must avoid this conversion for generic functions such as Array.prototype.push.
          return false;
        }
        var callSiteParamWeight = callSiteParamType.getWeight();
        // Delta is negative for narrowing, positive for widening
        var thisParamWeightDelta = thisParamType.getWeight() - callSiteParamWeight;
        var otherParamWeightDelta = getParamType(i, otherType, otherVarArg).getWeight() - callSiteParamWeight;
        // Only count absolute values of narrowings
        narrowWeightDelta += Math.max(-thisParamWeightDelta, 0) - Math.max(-otherParamWeightDelta, 0);
        // Only count absolute values of widenings
        widenWeightDelta += Math.max(thisParamWeightDelta, 0) - Math.max(otherParamWeightDelta, 0);
      }
      // If both functions accept more arguments than what is passed at the call site, account for ability to receive Undefined un-narrowed in the remaining arguments.
      if (!thisVarArg) {
        for (var i = callSiteParamCount; i < thisParamCount; ++i) {
          narrowWeightDelta += Math.max(Type.OBJECT.getWeight() - thisType[i].getWeight(), 0);
        }
      }
      if (!otherVarArg) {
        for (var i = callSiteParamCount; i < otherParamCount; ++i) {
          narrowWeightDelta -= Math.max(Type.OBJECT.getWeight() - otherType[i].getWeight(), 0);
        }
      }
      // Prefer function that narrows less
      if (narrowWeightDelta < 0) {
        return true;
      }
      if (narrowWeightDelta > 0) {
        return false;
      }
      // Prefer function that widens less
      if (widenWeightDelta < 0) {
        return true;
      }
      if (widenWeightDelta > 0) {
        return false;
      }
    }
    // Prefer the function that exactly matches the arity of the call site.
    if (thisParamCount == callSiteParamCount && otherParamCount != callSiteParamCount) {
      return true;
    }
    if (thisParamCount != callSiteParamCount && otherParamCount == callSiteParamCount) {
      return false;
    }
    // Otherwise, neither function matches arity exactly.
    // We also know that at this point, they both can receive more arguments than call site, otherwise we would've already chosen the one that discards less parameters.
    // Note that variable arity methods are preferred, as they actually match the call site arity better, since they really have arbitrary arity.
    if (thisVarArg) {
      if (!otherVarArg) {
        return true; //
      }
    } else if (otherVarArg) {
      return false;
    }
    // Neither is variable arity; chose the one that has less extra parameters.
    var fnParamDelta = thisParamCount - otherParamCount;
    if (fnParamDelta < 0) {
      return true;
    }
    if (fnParamDelta > 0) {
      return false;
    }
    var callSiteRetWeight = Type.typeFor(callSiteMethodType.returnType()).getWeight();
    // Delta is negative for narrower return type, positive for wider return type
    var thisRetWeightDelta = Type.typeFor(thisMethodType.returnType()).getWeight() - callSiteRetWeight;
    var otherRetWeightDelta = Type.typeFor(otherMethodType.returnType()).getWeight() - callSiteRetWeight;
    // Prefer function that returns a less wide return type
    var widenRetDelta = Math.max(thisRetWeightDelta, 0) - Math.max(otherRetWeightDelta, 0);
    if (widenRetDelta < 0) {
      return true;
    }
    if (widenRetDelta > 0) {
      return false;
    }
    // Prefer function that returns a less narrow return type
    var narrowRetDelta = Math.max(-thisRetWeightDelta, 0) - Math.max(-otherRetWeightDelta, 0);
    if (narrowRetDelta < 0) {
      return true;
    }
    if (narrowRetDelta > 0) {
      return false;
    }
    //if they are equal, pick the specialized one first
    if (cf.isSpecialization() != other.isSpecialization()) {
      return cf.isSpecialization(); //always pick the specialized version if we can
    }
    if (cf.isSpecialization() && other.isSpecialization()) {
      return cf.getLinkLogicClass() != null; //pick link logic specialization above generic specializations
    }
    // Signatures are identical
    throw new AssertionError(thisMethodType + " identically applicable to " + otherMethodType + " for " + callSiteMethodType);
  }

  static Type[] toTypeWithoutCallee(MethodType type, int thisIndex) {
    var paramCount = type.parameterCount();
    var t = new Type[paramCount - thisIndex];
    for (var i = thisIndex; i < paramCount; ++i) {
      t[i - thisIndex] = Type.typeFor(type.parameterType(i));
    }
    return t;
  }

  static Type getParamType(int i, Type[] paramTypes, boolean isVarArg) {
    var fixParamCount = paramTypes.length - (isVarArg ? 1 : 0);
    if (i < fixParamCount) {
      return paramTypes[i];
    }
    assert isVarArg;
    return ((ArrayType) paramTypes[paramTypes.length - 1]).getElementType();
  }

  boolean matchesCallSite(MethodType other, boolean pickVarArg) {
    if (other.equals(this.callSiteType)) {
      return true;
    }
    var type = type();
    var fnParamCount = getParamCount(type);
    var isVarArg = fnParamCount == Integer.MAX_VALUE;
    if (isVarArg) {
      return pickVarArg;
    }
    var csParamCount = getParamCount(other);
    var csIsVarArg = csParamCount == Integer.MAX_VALUE;
    if (csIsVarArg && isApplyToCall()) {
      return false; // apply2call function must be called with exact number of parameters
    }
    var thisThisIndex = needsCallee() ? 1 : 0; // Index of "this" parameter in this function's type
    var fnParamCountNoCallee = fnParamCount - thisThisIndex;
    var minParams = Math.min(csParamCount - 1, fnParamCountNoCallee); // callSiteType always has callee, so subtract 1
    // We must match all incoming parameters, including "this". "this" will usually be Object, but there are exceptions, e.g. when calling functions with primitive "this" through call/apply.
    for (var i = 0; i < minParams; ++i) {
      var fnType = Type.typeFor(type.parameterType(i + thisThisIndex));
      var csType = csIsVarArg ? Type.OBJECT : Type.typeFor(other.parameterType(i + 1));
      if (!fnType.isEquivalentTo(csType)) {
        return false;
      }
    }
    // Must match any undefined parameters to Object type.
    for (var i = minParams; i < fnParamCountNoCallee; ++i) {
      if (!Type.typeFor(type.parameterType(i + thisThisIndex)).isEquivalentTo(Type.OBJECT)) {
        return false;
      }
    }
    return true;
  }

  static int getParamCount(MethodType type) {
    var paramCount = type.parameterCount();
    return type.parameterType(paramCount - 1).isArray() ? Integer.MAX_VALUE : paramCount;
  }

  boolean canBeDeoptimized() {
    return optimismInfo != null;
  }

  MethodHandle createComposableInvoker(boolean isConstructor) {
    var handle = getInvokerOrConstructor(isConstructor);
    // If compiled function is not optimistic, it can't ever change its invoker/constructor, so just return them directly.
    if (!canBeDeoptimized()) {
      return handle;
    }
    // Otherwise, we need a new level of indirection; need to introduce a mutable call site that can relink itself to the compiled function's changed target whenever the optimistic assumptions are invalidated.
    var cs = new MutableCallSite(handle.type());
    relinkComposableInvoker(cs, this, isConstructor);
    return cs.dynamicInvoker();
  }

  static class HandleAndAssumptions {

    final MethodHandle handle;
    final SwitchPoint assumptions;

    HandleAndAssumptions(MethodHandle handle, SwitchPoint assumptions) {
      this.handle = handle;
      this.assumptions = assumptions;
    }

    GuardedInvocation createInvocation() {
      return new GuardedInvocation(handle, assumptions);
    }
  }

  /**
   * Returns a pair of an invocation created with a passed-in supplier and a non-invalidated switch point for optimistic assumptions (or null for the switch point if the function can not be deoptimized).
   * While the method makes a best effort to return a non-invalidated switch point (compensating for possible deoptimizing recompilation happening on another thread) it is still possible that by the time this method returns the switchpoint has been invalidated by a {@code RewriteException} triggered on another thread for this function.
   * This is not a problem, though, as these switch points are always used to produce call sites that fall back to relinking when they are invalidated, and in this case the execution will end up here again.
   * What this method basically does is minimize such busy-loop relinking while the function is being recompiled on a different thread.
   * @param invocationSupplier the supplier that constructs the actual invocation method handle; should use the {@code CompiledFunction} method itself in some capacity.
   * @return a tuple object containing the method handle as created by the supplier and an optimistic assumptions switch point that is guaranteed to not have been invalidated before the call to this method (or null if the function can't be further deoptimized).
   */
  synchronized HandleAndAssumptions getValidOptimisticInvocation(Supplier<MethodHandle> invocationSupplier) {
    for (;;) {
      var handle = invocationSupplier.get();
      var assumptions = canBeDeoptimized() ? optimismInfo.optimisticAssumptions : null;
      if (assumptions != null && assumptions.hasBeenInvalidated()) {
        // We can be in a situation where one thread is in the middle of a deoptimizing compilation when we hit this and thus, it has invalidated the old switch point, but hasn't created the new one yet.
        // Note that the behavior of invalidating the old switch point before recompilation, and only creating the new one after recompilation is by design.
        // If we didn't wait here for the recompilation to complete, we would be busy looping through the fallback path of the invalidated switch point, relinking the call site again with the same invalidated switch point, invoking the fallback, etc. stealing CPU cycles from the recompilation task we're dependent on.
        // This can still happen if the switch point gets invalidated after we grabbed it here, in which case we'll indeed do one busy relink immediately.
        try {
          wait();
        } catch (InterruptedException e) {
          // Intentionally ignored. There's nothing meaningful we can do if we're interrupted
        }
      } else {
        return new HandleAndAssumptions(handle, assumptions);
      }
    }
  }

  static void relinkComposableInvoker(CallSite cs, CompiledFunction inv, boolean constructor) {
    var handleAndAssumptions = inv.getValidOptimisticInvocation(() -> inv.getInvokerOrConstructor(constructor));
    var handle = handleAndAssumptions.handle;
    var assumptions = handleAndAssumptions.assumptions;
    MethodHandle target;
    if (assumptions == null) {
      target = handle;
    } else {
      var relink = MethodHandles.insertArguments(RELINK_COMPOSABLE_INVOKER, 0, cs, inv, constructor);
      target = assumptions.guardWithTest(handle, MethodHandles.foldArguments(cs.dynamicInvoker(), relink));
    }
    cs.setTarget(target.asType(cs.type()));
  }

  private MethodHandle getInvokerOrConstructor(boolean selectCtor) {
    return selectCtor ? getConstructor() : createInvokerForPessimisticCaller();
  }

  /**
   * Returns a guarded invocation for this function when not invoked as a constructor.
   * The guarded invocation has no guard but it potentially has an optimistic assumptions switch point.
   * As such, it will probably not be used as a final guarded invocation, but rather as a holder for an invocation handle and switch point to be decomposed and reassembled into a different final invocation by the user of this method.
   * Any recompositions should take care to continue to use the switch point.
   * If that is not possible, use {@link #createComposableInvoker()} instead.
   * @return a guarded invocation for an ordinary (non-constructor) invocation of this function.
   */
  GuardedInvocation createFunctionInvocation(Class<?> callSiteReturnType, int callerProgramPoint) {
    return getValidOptimisticInvocation(() -> createInvoker(callSiteReturnType, callerProgramPoint)).createInvocation();
  }

  /**
   * Returns a guarded invocation for this function when invoked as a constructor.
   * The guarded invocation has no guard but it potentially has an optimistic assumptions switch point.
   * As such, it will probably not be used as a final guarded invocation, but rather as a holder for an invocation handle and switch point to be decomposed and reassembled into a different final invocation by the user of this method.
   * Any recompositions should take care to continue to use the switch point. If that is not possible, use {@link #createComposableConstructor()} instead.
   * @return a guarded invocation for invocation of this function as a constructor.
   */
  GuardedInvocation createConstructorInvocation() {
    return getValidOptimisticInvocation(this::getConstructor).createInvocation();
  }

  MethodHandle createInvoker(Class<?> callSiteReturnType, int callerProgramPoint) {
    var isOptimistic = canBeDeoptimized();
    var handleRewriteException = isOptimistic ? createRewriteExceptionHandler() : null;
    var inv = invoker;
    if (isValid(callerProgramPoint)) {
      inv = OptimisticReturnFilters.filterOptimisticReturnValue(inv, callSiteReturnType, callerProgramPoint);
      inv = changeReturnType(inv, callSiteReturnType);
      if (callSiteReturnType.isPrimitive() && handleRewriteException != null) {
        // because handleRewriteException always returns Object
        handleRewriteException = OptimisticReturnFilters.filterOptimisticReturnValue(handleRewriteException, callSiteReturnType, callerProgramPoint);
      }
    } else if (isOptimistic) {
      // Required so that rewrite exception has the same return type.
      // It'd be okay to do it even if we weren't optimistic, but it isn't necessary as the linker upstream will eventually convert the return type.
      inv = changeReturnType(inv, callSiteReturnType);
    }
    if (isOptimistic) {
      assert handleRewriteException != null;
      var typedHandleRewriteException = changeReturnType(handleRewriteException, inv.type().returnType());
      return MH.catchException(inv, RewriteException.class, typedHandleRewriteException);
    }
    return inv;
  }

  MethodHandle createRewriteExceptionHandler() {
    return MH.foldArguments(RESTOF_INVOKER, MH.insertArguments(HANDLE_REWRITE_EXCEPTION, 0, this, optimismInfo));
  }

  static MethodHandle changeReturnType(MethodHandle mh, Class<?> newReturnType) {
    return Bootstrap.getLinkerServices().asType(mh, mh.type().changeReturnType(newReturnType));
  }

  @SuppressWarnings("unused")
  static MethodHandle handleRewriteException(CompiledFunction function, OptimismInfo oldOptimismInfo, RewriteException re) {
    return function.handleRewriteException(oldOptimismInfo, re);
  }

  /**
   * Debug function for printing out all invalidated program points and their invalidation mapping to next type
   * @param ipp
   * @return string describing the ipp map
   */
  static List<String> toStringInvalidations(Map<Integer, Type> ipp) {
    if (ipp == null) {
      return Collections.emptyList();
    }
    var list = new ArrayList<String>();
    for (var iter = ipp.entrySet().iterator(); iter.hasNext();) {
      var entry = iter.next();
      var bct = entry.getValue().getBytecodeStackType();
      var type = switch (entry.getValue().getBytecodeStackType()) {
        case 'A' -> "object";
        case 'I' -> "int";
        case 'J' -> "long";
        case 'D' -> "double";
        default -> String.valueOf(bct);
      };
      var sb = "[program point: " + entry.getKey() + " -> " + type + ']';
      list.add(sb);
    }
    return list;
  }

  /**
   * Handles a {@link RewriteException} raised during the execution of this function by recompiling (if needed) the function with an optimistic assumption invalidated at the program point indicated by the exception, and then executing a rest-of method to complete the execution with the deoptimized version.
   * @param oldOptInfo the optimism info of this function. We must store it explicitly as a bound argument in the method handle, otherwise it could be null for handling a rewrite exception in an outer invocation of a recursive function when recursive invocations of the function have completely deoptimized it.
   * @param re the rewrite exception that was raised
   * @return the method handle for the rest-of method, for folding composition.
   */
  synchronized MethodHandle handleRewriteException(OptimismInfo oldOptInfo, RewriteException re) {
    var type = type();
    // Compiler needs a call site type as its input, which always has a callee parameter, so we must add it if this function doesn't have a callee parameter.
    var ct = type.parameterType(0) == ScriptFunction.class ? type : type.insertParameterTypes(0, ScriptFunction.class);
    var currentOptInfo = optimismInfo;
    var shouldRecompile = currentOptInfo != null && currentOptInfo.requestRecompile(re);
    // Effective optimism info, for subsequent use. We'll normally try to use the current (latest) one, but if it isn't available, we'll use the old one bound into the call site.
    var effectiveOptInfo = currentOptInfo != null ? currentOptInfo : oldOptInfo;
    var fn = effectiveOptInfo.reparse();
    var cached = fn.isCached();
    var compiler = effectiveOptInfo.getCompiler(fn, ct, re); //set to non rest-of
    if (!shouldRecompile) {
      // It didn't necessarily recompile, e.g. for an outer invocation of a recursive function if we already recompiled a deoptimized version for an inner invocation.
      // We still need to do the rest of from the beginning
      return restOfHandle(effectiveOptInfo, compiler.compile(fn, cached ? CompilationPhases.COMPILE_CACHED_RESTOF : CompilationPhases.COMPILE_ALL_RESTOF), currentOptInfo != null);
    }
    fn = compiler.compile(fn, cached ? CompilationPhases.RECOMPILE_CACHED_UPTO_BYTECODE : CompilationPhases.COMPILE_UPTO_BYTECODE);
    // compile the rest of the function, and install it
    var normalFn = compiler.compile(fn, CompilationPhases.GENERATE_BYTECODE_AND_INSTALL);
    var canBeDeoptimized = normalFn.canBeDeoptimized();
    var newInvoker = effectiveOptInfo.data.lookup(fn);
    invoker = newInvoker.asType(type.changeReturnType(newInvoker.type().returnType()));
    constructor = null; // Will be regenerated when needed
    var restOf = restOfHandle(effectiveOptInfo, compiler.compile(fn, CompilationPhases.GENERATE_BYTECODE_AND_INSTALL_RESTOF), canBeDeoptimized);
    // Note that we only adjust the switch point after we set the invoker/constructor. This is important.
    if (canBeDeoptimized) {
      effectiveOptInfo.newOptimisticAssumptions(); // Otherwise, set a new switch point.
    } else {
      optimismInfo = null; // If we got to a point where we no longer have optimistic assumptions, let the optimism info go.
    }
    notifyAll();
    return restOf;
  }

  MethodHandle restOfHandle(OptimismInfo info, FunctionNode restOfFunction, boolean canBeDeoptimized) {
    assert info != null;
    assert restOfFunction.getCompileUnit().getUnitClassName().contains("restOf");
    var restOf = changeReturnType(info.data.lookupCodeMethod(restOfFunction.getCompileUnit().getCode(), MH.type(restOfFunction.getReturnType().getTypeClass(), RewriteException.class)), Object.class);
    // If rest-of is itself optimistic, we must make sure that we can repeat a deoptimization if it, too hits an exception.
    return canBeDeoptimized ? MH.catchException(restOf, RewriteException.class, createRewriteExceptionHandler()) : restOf;
  }

  static class OptimismInfo {
    // TODO: this is pointing to its owning ScriptFunctionData. Re-evaluate if that's okay.
    private final RecompilableScriptFunctionData data;
    private final Map<Integer, Type> invalidatedProgramPoints;
    private SwitchPoint optimisticAssumptions;

    OptimismInfo(RecompilableScriptFunctionData data, Map<Integer, Type> invalidatedProgramPoints) {
      this.data = data;
      this.invalidatedProgramPoints = invalidatedProgramPoints == null ? new TreeMap<>() : invalidatedProgramPoints;
      newOptimisticAssumptions();
    }

    private void newOptimisticAssumptions() {
      optimisticAssumptions = new SwitchPoint();
    }

    boolean requestRecompile(RewriteException e) {
      var retType = e.getReturnType();
      var previousFailedType = invalidatedProgramPoints.put(e.getProgramPoint(), retType);
      if (previousFailedType != null && !previousFailedType.narrowerThan(retType)) {
        return false;
      }
      SwitchPoint.invalidateAll(new SwitchPoint[]{optimisticAssumptions});
      return true;
    }

    Compiler getCompiler(FunctionNode fn, MethodType actualCallSiteType, RewriteException e) {
      return data.getCompiler(fn, actualCallSiteType, e.getRuntimeScope(), invalidatedProgramPoints, getEntryPoints(e));
    }

    static int[] getEntryPoints(RewriteException e) {
      var prevEntryPoints = e.getPreviousContinuationEntryPoints();
      int[] entryPoints;
      if (prevEntryPoints == null) {
        entryPoints = new int[1];
      } else {
        var l = prevEntryPoints.length;
        entryPoints = new int[l + 1];
        System.arraycopy(prevEntryPoints, 0, entryPoints, 1, l);
      }
      entryPoints[0] = e.getProgramPoint();
      return entryPoints;
    }

    FunctionNode reparse() {
      return data.reparse();
    }
  }

  @SuppressWarnings("unused")
  static Object newFilter(Object result, Object allocation) {
    return (result instanceof ScriptObject || !JSType.isPrimitive(result)) ? result : allocation;
  }

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), CompiledFunction.class, name, MH.type(rtype, types));
  }

}
