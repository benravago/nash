package es.runtime;

import java.util.Collection;
import java.util.LinkedList;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.Serializable;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import es.runtime.linker.LinkerCallSite;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.ScriptRuntime.UNDEFINED;


/**
 * A container for data needed to instantiate a specific {@link ScriptFunction} at runtime.
 *
 * Instances of this class are created during codegen and stored in script classes'
 * constants array to reduce function instantiation overhead during runtime.
 */
public abstract class ScriptFunctionData implements Serializable {

  static final int MAX_ARITY = LinkerCallSite.ARGLIMIT;

  static /*<init>*/ {
    // Assert it fits in a byte, as that's what we store it in.
    // It's just a size optimization though, so if needed "byte arity" field can be widened.
    assert MAX_ARITY < 256;
  }

  /** Name of the function or "" for anonymous functions */
  protected final String name;

  /** A list of code versions of a function sorted in ascending order of generic descriptors. */
  protected transient LinkedList<CompiledFunction> code = new LinkedList<>();

  /** Function flags */
  protected int flags;

  // Parameter arity of the function, corresponding to "f.length".
  // E.g. "function f(a, b, c) { ... }" arity is 3, and some built-in ECMAScript functions have their arity declared by the specification.
  // Note that regardless of this value, the function might still be capable of receiving variable number of arguments, see isVariableArity.
  private int arity;

  // A pair of method handles used for generic invoker and constructor.
  // Field is volatile as it can be initialized by multiple threads concurrently, but we still tolerate a race condition in it as all values stored into it are idempotent.
  private volatile transient GenericInvokers genericInvokers;

  private static final MethodHandle BIND_VAR_ARGS = findOwnMH("bindVarArgs", Object[].class, Object[].class, Object[].class);

  /** Is this a built-in function? */
  public static final int IS_BUILTIN = 1 << 1;
  /** Is this a constructor function? */
  public static final int IS_CONSTRUCTOR = 1 << 2;
  /** Does this function expect a callee argument? */
  public static final int NEEDS_CALLEE = 1 << 3;
  /** Does this function make use of the this-object argument? */
  public static final int USES_THIS = 1 << 4;
  /** Is this a variable arity function? */
  public static final int IS_VARIABLE_ARITY = 1 << 5;
  /** Is this a object literal property getter or setter? */
  public static final int IS_PROPERTY_ACCESSOR = 1 << 6;
  /** Is this an ES6 method? */
  public static final int IS_ES6_METHOD = 1 << 7;

  /** Flag for built-in constructors */
  public static final int IS_BUILTIN_CONSTRUCTOR = IS_BUILTIN | IS_CONSTRUCTOR;

  private static final long serialVersionUID = 4252901245508769114L;

  /**
   * Constructor
   *
   * @param name  script function name
   * @param arity arity
   * @param flags the function flags
   */
  ScriptFunctionData(String name, int arity, int flags) {
    this.name = name;
    this.flags = flags;
    setArity(arity);
  }

  final int getArity() {
    return arity;
  }

  String getDocumentation() {
    return toSource();
  }

  String getDocumentationKey() {
    return null;
  }

  final boolean isVariableArity() {
    return (flags & IS_VARIABLE_ARITY) != 0;
  }

  /**
   * Used from e.g. Native*$Constructors as an explicit call. TODO - make arity immutable and final
   * @param arity new arity
   */
  void setArity(int arity) {
    if (arity < 0 || arity > MAX_ARITY) {
      throw new IllegalArgumentException(String.valueOf(arity));
    }
    this.arity = arity;
  }

  /**
   * Used from nasgen generated code.
   * @param docKey documentation key for this function
   */
  void setDocumentationKey(String docKey) {
    // empty
  }

  CompiledFunction bind(CompiledFunction originalInv, ScriptFunction fn, Object self, Object[] args) {
    var boundInvoker = bindInvokeHandle(originalInv.createComposableInvoker(), fn, self, args);
    return isConstructor() ? new CompiledFunction(boundInvoker, bindConstructHandle(originalInv.createComposableConstructor(), fn, args), null) : new CompiledFunction(boundInvoker);
  }

  /**
   * Return the complete internal function name for this data, not anonymous or similar; may be identical.
   * @return internal function name
   */
  protected String getFunctionName() {
    return getName();
  }

  final boolean isBuiltin() {
    return (flags & IS_BUILTIN) != 0;
  }

  final boolean isConstructor() {
    return (flags & IS_CONSTRUCTOR) != 0;
  }

  abstract boolean needsCallee();

  /**
   * Returns true if this is a non-strict, non-built-in function that requires non-primitive this argument according to ECMA 10.4.3.
   * @return true if this argument must be an object
   */
  final boolean needsWrappedThis() { // TODO: maybe remove
    return (flags & USES_THIS) != 0 && (flags & IS_BUILTIN) == 0;
  }

  String toSource() {
    return "function " + (name == null ? "" : name) + "() { [native code] }";
  }

  String getName() {
    return name;
  }

  /**
   * Get this function as a String containing its source code.
   * If no source code exists in this ScriptFunction, its contents will be displayed as {@code [native code]}
   * @return string representation of this function
   */
  @Override
  public String toString() {
    return name.isEmpty() ? "<anonymous>" : name;
  }

  /**
   * Verbose description of data
   * @return verbose description
   */
  public String toStringVerbose() {
    return "name='" + (name.isEmpty() ? "<anonymous>" : name) + "' " + code.size() + " invokers=" + code;
  }

  /**
   * Pick the best invoker, i.e. the one version of this method with as narrow and specific types as possible.
   * If the call site arguments are objects, but boxed primitives we can also try to get a primitive version of the method and do an unboxing filter, but then we need to insert a guard that checks the argument is really always a boxed primitive and not suddenly a "real" object
   * @param callSiteType callsite type
   * @return compiled function object representing the best invoker.
   */
  final CompiledFunction getBestInvoker(MethodType callSiteType, ScriptObject runtimeScope) {
    return getBestInvoker(callSiteType, runtimeScope, CompiledFunction.NO_FUNCTIONS);
  }

  final CompiledFunction getBestInvoker(MethodType callSiteType, ScriptObject runtimeScope, Collection<CompiledFunction> forbidden) {
    var cf = getBest(callSiteType, runtimeScope, forbidden);
    assert cf != null;
    return cf;
  }

  final CompiledFunction getBestConstructor(MethodType callSiteType, ScriptObject runtimeScope, Collection<CompiledFunction> forbidden) {
    if (!isConstructor()) {
      throw typeError("not.a.constructor", toSource());
    }
    // Constructor call sites don't have a "this", but getBest is meant to operate on "callee, this, ..." style
    var cf = getBest(callSiteType.insertParameterTypes(1, Object.class), runtimeScope, forbidden);
    return cf;
  }

  /**
   * If we can have lazy code generation, this is a hook to ensure that the code has been compiled.
   * This does not guarantee the code been installed in this {@code ScriptFunctionData} instance
   */
  protected void ensureCompiled() {
    // empty
  }

  /**
   * Return a generic Object/Object invoker for this method.
   * It will ensure code is generated, get the most generic of all versions of this function and adapt it to Objects.
   * @param runtimeScope the runtime scope. It can be used to evaluate types of scoped variables to guide the optimistic compilation, should the call to this method trigger code compilation. Can be null if current runtime scope is not known, but that might cause compilation of code that will need more deoptimization passes.
   * @return generic invoker of this script function
   */
  final MethodHandle getGenericInvoker(ScriptObject runtimeScope) {
    // This method has race conditions both on genericsInvoker and genericsInvoker.invoker, but even if invoked concurrently, they'll create idempotent results, so it doesn't matter.
    // We could alternatively implement this using java.util.concurrent.AtomicReferenceFieldUpdater, but it's hardly worth it.
    var lgenericInvokers = ensureGenericInvokers();
    var invoker = lgenericInvokers.invoker;
    if (invoker == null) {
      lgenericInvokers.invoker = invoker = createGenericInvoker(runtimeScope);
    }
    return invoker;
  }

  MethodHandle createGenericInvoker(ScriptObject runtimeScope) {
    return makeGenericMethod(getGeneric(runtimeScope).createComposableInvoker());
  }

  final MethodHandle getGenericConstructor(ScriptObject runtimeScope) {
    // This method has race conditions both on genericsInvoker and genericsInvoker.constructor, but even if invoked concurrently, they'll create idempotent results, so it doesn't matter. We could alternatively implement this using java.util.concurrent.AtomicReferenceFieldUpdater, but it's hardly worth it.
    var lgenericInvokers = ensureGenericInvokers();
    var constructor = lgenericInvokers.constructor;
    if (constructor == null) {
      lgenericInvokers.constructor = constructor = createGenericConstructor(runtimeScope);
    }
    return constructor;
  }

  MethodHandle createGenericConstructor(ScriptObject runtimeScope) {
    return makeGenericMethod(getGeneric(runtimeScope).createComposableConstructor());
  }

  GenericInvokers ensureGenericInvokers() {
    var lgenericInvokers = genericInvokers;
    if (lgenericInvokers == null) {
      genericInvokers = lgenericInvokers = new GenericInvokers();
    }
    return lgenericInvokers;
  }

  static MethodType widen(MethodType cftype) {
    var paramTypes = new Class<?>[cftype.parameterCount()];
    for (var i = 0; i < cftype.parameterCount(); i++) {
      paramTypes[i] = cftype.parameterType(i).isPrimitive() ? cftype.parameterType(i) : Object.class;
    }
    return MH.type(cftype.returnType(), paramTypes);
  }

  /**
   * Used to find an apply to call version that fits this callsite.
   * We cannot just, as in the normal matcher case, return e.g. (Object, Object, int) for (Object, Object, int, int, int) or we will destroy the semantics and get a function that, when padded with undefined values, behaves differently
   * @param type actual call site type
   * @return apply to call that perfectly fits this callsite or null if none found
   */
  CompiledFunction lookupExactApplyToCall(MethodType type) {
    // Callsite type always has callee, drop it if this function doesn't need it.
    var adaptedType = needsCallee() ? type : type.dropParameterTypes(0, 1);
    for (var cf : code) {
      if (!cf.isApplyToCall()) {
        continue;
      }
      var cftype = cf.type();
      if (cftype.parameterCount() != adaptedType.parameterCount()) {
        continue;
      }
      if (widen(cftype).equals(widen(adaptedType))) {
        return cf;
      }
    }
    return null;
  }

  CompiledFunction pickFunction(MethodType callSiteType, boolean canPickVarArg) {
    for (var candidate : code) {
      if (candidate.matchesCallSite(callSiteType, canPickVarArg)) {
        return candidate;
      }
    }
    return null;
  }

  /**
   * Returns the best function for the specified call site type.
   * @param callSiteType The call site type. Call site types are expected to have the form {@code (callee, this[, args...])}.
   * @param runtimeScope the runtime scope. It can be used to evaluate types of scoped variables to guide the optimistic compilation, should the call to this method trigger code compilation. Can be null if current runtime scope is not known, but that might cause compilation of code that will need more deoptimization passes.
   * @param linkLogicOkay is a CompiledFunction with a LinkLogic acceptable?
   * @return the best function for the specified call site type.
   */
  abstract CompiledFunction getBest(MethodType callSiteType, ScriptObject runtimeScope, Collection<CompiledFunction> forbidden, boolean linkLogicOkay);

  /**
   * Returns the best function for the specified call site type.
   * @param callSiteType The call site type. Call site types are expected to have the form {@code (callee, this[, args...])}.
   * @param runtimeScope the runtime scope. It can be used to evaluate types of scoped variables to guide the optimistic compilation, should the call to this method trigger code compilation. Can be null if current runtime scope is not known, but that might cause compilation of code that will need more deoptimization passes.
   * @return the best function for the specified call site type.
   */
  final CompiledFunction getBest(MethodType callSiteType, ScriptObject runtimeScope, Collection<CompiledFunction> forbidden) {
    return getBest(callSiteType, runtimeScope, forbidden, true);
  }

  boolean isValidCallSite(MethodType callSiteType) {
    // Must have at least (callee, this)
    return callSiteType.parameterCount() >= 2 && callSiteType.parameterType(0).isAssignableFrom(ScriptFunction.class); // Callee must be assignable from script function
  }

  CompiledFunction getGeneric(ScriptObject runtimeScope) {
    return getBest(getGenericType(), runtimeScope, CompiledFunction.NO_FUNCTIONS, false);
  }

  /**
   * Get a method type for a generic invoker.
   * @return the method type for the generic invoker
   */
  abstract MethodType getGenericType();

  /**
   * Allocates an object using this function's allocator.
   * @param map the property map for the allocated object.
   * @return the object allocated using this function's allocator, or null if the function doesn't have an allocator.
   */
  ScriptObject allocate(PropertyMap map) {
    return null;
  }

  /**
   * Get the property map to use for objects allocated by this function.
   * @param prototype the prototype of the allocated object
   * @return the property map for allocated objects.
   */
  PropertyMap getAllocatorMap(ScriptObject prototype) {
    return null;
  }

  /**
   * This method is used to create the immutable portion of a bound function.
   * See {@link ScriptFunction#createBound(Object, Object[])}
   * @param fn the original function being bound
   * @param self this reference to bind. Can be null.
   * @param args additional arguments to bind. Can be null.
   */
  ScriptFunctionData makeBoundFunctionData(ScriptFunction fn, Object self, Object[] args) {
    var allArgs = args == null ? ScriptRuntime.EMPTY_ARRAY : args;
    var length = args == null ? 0 : args.length;
    // Clear the callee and this flags
    var boundFlags = flags & ~NEEDS_CALLEE & ~USES_THIS;
    var boundList = new LinkedList<CompiledFunction>();
    var runtimeScope = fn.getScope();
    var bindTarget = new CompiledFunction(getGenericInvoker(runtimeScope), getGenericConstructor(runtimeScope), null);
    boundList.add(bind(bindTarget, fn, self, allArgs));
    return new FinalScriptFunctionData(name, Math.max(0, getArity() - length), boundList, boundFlags);
  }

  /**
   * Convert this argument for non-strict functions according to ES 10.4.3
   * @param self the this argument
   * @return the converted this object
   */
  Object convertThisObject(Object self) {
    return needsWrappedThis() ? wrapThis(self) : self;
  }

  static Object wrapThis(Object self) {
    if (self instanceof ScriptObject) {
      return self;
    } else {
      if (JSType.nullOrUndefined(self)) {
        return Context.getGlobal();
      }
      if (isPrimitiveThis(self)) {
        return Context.getGlobal().wrapAsObject(self);
      }
      return self;
    }

  }

  static boolean isPrimitiveThis(Object obj) {
    return JSType.isString(obj) || obj instanceof Number || obj instanceof Boolean;
  }

  /**
   * Creates an invoker method handle for a bound function.
   * @param targetFn the function being bound
   * @param originalInvoker an original invoker method handle for the function. This can be its generic invoker or any of its specializations.
   * @param self the "this" value being bound
   * @param args additional arguments being bound
   * @return a bound invoker method handle that will bind the self value and the specified arguments. The resulting invoker never needs a callee; if the original invoker needed it, it will be bound to {@code fn}. The resulting invoker still takes an initial {@code this} parameter, but it is always dropped and the bound {@code self} passed to the original invoker on invocation.
   */
  MethodHandle bindInvokeHandle(MethodHandle originalInvoker, ScriptFunction targetFn, Object self, Object[] args) {
    // Is the target already bound?
    // If it is, we won't bother binding either callee or self as they're already bound in the target and will be ignored anyway.
    var isTargetBound = targetFn.isBoundFunction();
    var needsCallee = needsCallee(originalInvoker);
    assert needsCallee == needsCallee() : "callee contract violation 2";
    assert !(isTargetBound && needsCallee); // already bound functions don't need a callee
    var boundSelf = isTargetBound ? null : convertThisObject(self);
    MethodHandle boundInvoker;
    if (isVarArg(originalInvoker)) {
      // First, bind callee and this without arguments
      MethodHandle noArgBoundInvoker;
      if (isTargetBound) {
        // Don't bind either callee or this
        noArgBoundInvoker = originalInvoker;
      } else if (needsCallee) {
        // Bind callee and this
        noArgBoundInvoker = MH.insertArguments(originalInvoker, 0, targetFn, boundSelf);
      } else {
        // Only bind this
        noArgBoundInvoker = MH.bindTo(originalInvoker, boundSelf);
      }
      // Now bind arguments
      if (args.length > 0) {
        boundInvoker = varArgBinder(noArgBoundInvoker, args);
      } else {
        boundInvoker = noArgBoundInvoker;
      }
    } else {
      // If target is already bound, insert additional bound arguments after "this" argument, at position 1.
      var argInsertPos = isTargetBound ? 1 : 0;
      var boundArgs = new Object[Math.min(originalInvoker.type().parameterCount() - argInsertPos, args.length + (isTargetBound ? 0 : needsCallee ? 2 : 1))];
      var next = 0;
      if (!isTargetBound) {
        if (needsCallee) {
          boundArgs[next++] = targetFn;
        }
        boundArgs[next++] = boundSelf;
      }
      // If more bound args were specified than the function can take, we'll just drop those.
      System.arraycopy(args, 0, boundArgs, next, boundArgs.length - next);
      // If target is already bound, insert additional bound arguments after "this" argument, at position 1; "this" will get dropped anyway by the target invoker.
      // We previously asserted that already bound functions don't take a callee parameter, so we can know that the signature is (this[, args...]) therefore args start at position 1.
      // If the function is not bound, we start inserting arguments at position 0.
      boundInvoker = MH.insertArguments(originalInvoker, argInsertPos, boundArgs);
    }
    if (isTargetBound) {
      return boundInvoker;
    }
    // If the target is not already bound, add a dropArguments that'll throw away the passed this
    return MH.dropArguments(boundInvoker, 0, Object.class);
  }

  /**
   * Creates a constructor method handle for a bound function using the passed constructor handle.
   * @param originalConstructor the constructor handle to bind. It must be a composed constructor.
   * @param fn the function being bound
   * @param args arguments being bound
   * @return a bound constructor method handle that will bind the specified arguments. The resulting constructor never needs a callee; if the original constructor needed it, it will be bound to {@code fn}. The resulting constructor still takes an initial {@code this} parameter and passes it to the underlying original constructor. Finally, if this script function data object has no constructor handle, null is returned.
   */
  static MethodHandle bindConstructHandle(MethodHandle originalConstructor, ScriptFunction fn, Object[] args) {
    assert originalConstructor != null;
    // If target function is already bound, don't bother binding the callee.
    var calleeBoundConstructor = fn.isBoundFunction() ? originalConstructor : MH.dropArguments(MH.bindTo(originalConstructor, fn), 0, ScriptFunction.class);
    if (args.length == 0) {
      return calleeBoundConstructor;
    }
    if (isVarArg(calleeBoundConstructor)) {
      return varArgBinder(calleeBoundConstructor, args);
    }
    Object[] boundArgs;
    var maxArgCount = calleeBoundConstructor.type().parameterCount() - 1;
    if (args.length <= maxArgCount) {
      boundArgs = args;
    } else {
      boundArgs = new Object[maxArgCount];
      System.arraycopy(args, 0, boundArgs, 0, maxArgCount);
    }
    return MH.insertArguments(calleeBoundConstructor, 1, boundArgs);
  }

  /**
   * Takes a method handle, and returns a potentially different method handle that can be used in {@code ScriptFunction#invoke(Object, Object...)} or {code ScriptFunction#construct(Object, Object...)}.
   * The returned method handle will be sure to return {@code Object}, and will have all its parameters turned into {@code Object} as well, except for the following ones:
   * <ul>
   *   <li>a last parameter of type {@code Object[]} which is used for vararg functions,
   *   <li>the first argument, which is forced to be {@link ScriptFunction}, in case the function receives itself (callee) as an argument.
   * </ul>
   * @param mh the original method handle
   * @return the new handle, conforming to the rules above.
   */
  static MethodHandle makeGenericMethod(MethodHandle mh) {
    var type = mh.type();
    var newType = makeGenericType(type);
    return type.equals(newType) ? mh : mh.asType(newType);
  }

  static MethodType makeGenericType(MethodType type) {
    var newType = type.generic();
    if (isVarArg(type)) {
      newType = newType.changeParameterType(type.parameterCount() - 1, Object[].class);
    }
    if (needsCallee(type)) {
      newType = newType.changeParameterType(0, ScriptFunction.class);
    }
    return newType;
  }

  /**
   * Execute this script function.
   * @param self  Target object.
   * @param arguments  Call arguments.
   * @return ScriptFunction result.
   * @throws Throwable if there is an exception/error with the invocation or thrown from it
   */
  Object invoke(ScriptFunction fn, Object self, Object... arguments) throws Throwable {
    var mh = getGenericInvoker(fn.getScope());
    var selfObj = convertThisObject(self);
    var args = arguments == null ? ScriptRuntime.EMPTY_ARRAY : arguments;
    if (isVarArg(mh)) {
      return needsCallee(mh) ? mh.invokeExact(fn, selfObj, args) : mh.invokeExact(selfObj, args);
    }
    var paramCount = mh.type().parameterCount();
    if (needsCallee(mh)) {
      return switch (paramCount) {
        case 2 -> mh.invokeExact(fn, selfObj);
        case 3 -> mh.invokeExact(fn, selfObj, get(args, 0));
        case 4 -> mh.invokeExact(fn, selfObj, get(args, 0), get(args, 1));
        case 5 -> mh.invokeExact(fn, selfObj, get(args, 0), get(args, 1), get(args, 2));
        case 6 -> mh.invokeExact(fn, selfObj, get(args, 0), get(args, 1), get(args, 2), get(args, 3));
        case 7 -> mh.invokeExact(fn, selfObj, get(args, 0), get(args, 1), get(args, 2), get(args, 3), get(args, 4));
        case 8 -> mh.invokeExact(fn, selfObj, get(args, 0), get(args, 1), get(args, 2), get(args, 3), get(args, 4), get(args, 5));
        default -> mh.invokeWithArguments(withArguments(fn, selfObj, paramCount, args));
      };
    }
    return switch (paramCount) {
      case 1 -> mh.invokeExact(selfObj);
      case 2 -> mh.invokeExact(selfObj, get(args, 0));
      case 3 -> mh.invokeExact(selfObj, get(args, 0), get(args, 1));
      case 4 -> mh.invokeExact(selfObj, get(args, 0), get(args, 1), get(args, 2));
      case 5 -> mh.invokeExact(selfObj, get(args, 0), get(args, 1), get(args, 2), get(args, 3));
      case 6 -> mh.invokeExact(selfObj, get(args, 0), get(args, 1), get(args, 2), get(args, 3), get(args, 4));
      case 7 -> mh.invokeExact(selfObj, get(args, 0), get(args, 1), get(args, 2), get(args, 3), get(args, 4), get(args, 5));
      default -> mh.invokeWithArguments(withArguments(null, selfObj, paramCount, args));
    };
  }

  Object construct(ScriptFunction fn, Object... arguments) throws Throwable {
    var mh = getGenericConstructor(fn.getScope());
    var args = arguments == null ? ScriptRuntime.EMPTY_ARRAY : arguments;
    if (isVarArg(mh)) {
      return needsCallee(mh) ? mh.invokeExact(fn, args) : mh.invokeExact(args);
    }
    var paramCount = mh.type().parameterCount();
    if (needsCallee(mh)) {
      return switch (paramCount) {
        case 1 -> mh.invokeExact(fn);
        case 2 -> mh.invokeExact(fn, get(args, 0));
        case 3 -> mh.invokeExact(fn, get(args, 0), get(args, 1));
        case 4 -> mh.invokeExact(fn, get(args, 0), get(args, 1), get(args, 2));
        case 5 -> mh.invokeExact(fn, get(args, 0), get(args, 1), get(args, 2), get(args, 3));
        case 6 -> mh.invokeExact(fn, get(args, 0), get(args, 1), get(args, 2), get(args, 3), get(args, 4));
        case 7 -> mh.invokeExact(fn, get(args, 0), get(args, 1), get(args, 2), get(args, 3), get(args, 4), get(args, 5));
        default -> mh.invokeWithArguments(withArguments(fn, paramCount, args));
      };
    }
    return switch (paramCount) {
      case 0 -> mh.invokeExact();
      case 1 -> mh.invokeExact(get(args, 0));
      case 2 -> mh.invokeExact(get(args, 0), get(args, 1));
      case 3 -> mh.invokeExact(get(args, 0), get(args, 1), get(args, 2));
      case 4 -> mh.invokeExact(get(args, 0), get(args, 1), get(args, 2), get(args, 3));
      case 5 -> mh.invokeExact(get(args, 0), get(args, 1), get(args, 2), get(args, 3), get(args, 4));
      case 6 -> mh.invokeExact(get(args, 0), get(args, 1), get(args, 2), get(args, 3), get(args, 4), get(args, 5));
      default -> mh.invokeWithArguments(withArguments(null, paramCount, args));
    };
  }

  private static Object get(Object[] args, int i) {
    return i < args.length ? args[i] : UNDEFINED;
  }

  static Object[] withArguments(ScriptFunction fn, int argCount, Object[] args) {
    var finalArgs = new Object[argCount];
    var nextArg = 0;
    if (fn != null) {
      //needs callee
      finalArgs[nextArg++] = fn;
    }
    // Don't add more args that there is argCount in the handle (including self and callee).
    for (var i = 0; i < args.length && nextArg < argCount;) {
      finalArgs[nextArg++] = args[i++];
    }
    // If we have fewer args than argCount, pad with undefined.
    while (nextArg < argCount) {
      finalArgs[nextArg++] = UNDEFINED;
    }
    return finalArgs;
  }

  static Object[] withArguments(ScriptFunction fn, Object self, int argCount, Object[] args) {
    var finalArgs = new Object[argCount];
    var nextArg = 0;
    if (fn != null) {
      //needs callee
      finalArgs[nextArg++] = fn;
    }
    finalArgs[nextArg++] = self;
    // Don't add more args that there is argCount in the handle (including self and callee).
    for (var i = 0; i < args.length && nextArg < argCount;) {
      finalArgs[nextArg++] = args[i++];
    }
    // If we have fewer args than argCount, pad with undefined.
    while (nextArg < argCount) {
      finalArgs[nextArg++] = UNDEFINED;
    }
    return finalArgs;
  }

  /**
   * Takes a variable-arity method and binds a variable number of arguments in it.
   * The returned method will filter the vararg array and pass a different array that prepends the bound arguments in front of the arguments passed on invocation
   * @param mh the handle
   * @param args the bound arguments
   * @return the bound method handle
   */
  static MethodHandle varArgBinder(MethodHandle mh, Object[] args) {
    assert args != null;
    assert args.length > 0;
    return MH.filterArguments(mh, mh.type().parameterCount() - 1, MH.bindTo(BIND_VAR_ARGS, args));
  }

  /**
   * Heuristic to figure out if the method handle has a callee argument.
   * If it's type is {@code (ScriptFunction, ...)}, then we'll assume it has a callee argument.
   * We need this as the constructor above is not passed this information, and can't just blindly assume it's false (notably, it's being invoked for creation of new scripts, and scripts have scopes, therefore they also always receive a callee).
   * @param mh the examined method handle
   * @return true if the method handle expects a callee, false otherwise
   */
  protected static boolean needsCallee(MethodHandle mh) {
    return needsCallee(mh.type());
  }

  static boolean needsCallee(MethodType type) {
    var length = type.parameterCount();
    if (length == 0) {
      return false;
    }
    var param0 = type.parameterType(0);
    return param0 == ScriptFunction.class || param0 == boolean.class && length > 1 && type.parameterType(1) == ScriptFunction.class;
  }

  /**
   * Check if a javascript function methodhandle is a vararg handle
   * @param mh method handle to check
   * @return true if vararg
   */
  protected static boolean isVarArg(MethodHandle mh) {
    return isVarArg(mh.type());
  }

  static boolean isVarArg(MethodType type) {
    return type.parameterType(type.parameterCount() - 1).isArray();
  }

  /**
   * Is this ScriptFunction declared in a dynamic context
   * @return true if in dynamic context, false if not or irrelevant
   */
  public boolean inDynamicContext() {
    return false;
  }

  @SuppressWarnings("unused")
  static Object[] bindVarArgs(Object[] array1, Object[] array2) {
    if (array2 == null) {
      // Must clone it, as we can't allow the receiving method to alter the array
      return array1.clone();
    }
    var l2 = array2.length;
    if (l2 == 0) {
      return array1.clone();
    }
    var l1 = array1.length;
    var concat = new Object[l1 + l2];
    System.arraycopy(array1, 0, concat, 0, l1);
    System.arraycopy(array2, 0, concat, l1, l2);
    return concat;
  }

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), ScriptFunctionData.class, name, MH.type(rtype, types));
  }

  /**
   * This class is used to hold the generic invoker and generic constructor pair.
   * It is structured in this way since most functions will never use them, so this way ScriptFunctionData only pays storage cost for one null reference to the GenericInvokers object, instead of two null references for the two method handles.
   */
  static final class GenericInvokers {
    volatile MethodHandle invoker;
    volatile MethodHandle constructor;
  }

  void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException {
    in.defaultReadObject();
    code = new LinkedList<>();
  }

}
