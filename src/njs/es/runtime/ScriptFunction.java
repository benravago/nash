package es.runtime;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodHandles.Lookup;
import java.lang.invoke.MethodType;
import java.lang.invoke.SwitchPoint;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.support.Guards;

import es.codegen.ApplySpecialization;
import es.codegen.Compiler;
import es.codegen.CompilerConstants.Call;
import es.ir.FunctionNode;
import es.objects.Global;
import es.objects.NativeFunction;
import es.objects.annotations.SpecializedFunction.LinkLogic;
import es.runtime.linker.Bootstrap;
import es.runtime.linker.NashornCallSiteDescriptor;
import static es.codegen.CompilerConstants.virtualCallNoLookup;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.ScriptRuntime.UNDEFINED;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;

/**
 * Runtime representation of a JavaScript function.
 *
 * This class has only private and protected constructors.
 * There are no *public* constructors - but only factory methods that follow the naming pattern "createXYZ".
 */
public class ScriptFunction extends ScriptObject {

  /** Method handle for proto getter for this ScriptFunction */
  public static final MethodHandle G$PROTOTYPE = findOwnMH_S("G$prototype", Object.class, Object.class);

  /** Method handle for proto setter for this ScriptFunction */
  public static final MethodHandle S$PROTOTYPE = findOwnMH_S("S$prototype", void.class, Object.class, Object.class);

  /** Method handle for length getter for this ScriptFunction */
  public static final MethodHandle G$LENGTH = findOwnMH_S("G$length", int.class, Object.class);

  /** Method handle for name getter for this ScriptFunction */
  public static final MethodHandle G$NAME = findOwnMH_S("G$name", Object.class, Object.class);

  /** Method handle used for implementing sync() in mozilla_compat */
  public static final MethodHandle INVOKE_SYNC = findOwnMH_S("invokeSync", Object.class, ScriptFunction.class, Object.class, Object.class, Object[].class);

  /** Method handle for allocate function for this ScriptFunction */
  static final MethodHandle ALLOCATE = findOwnMH_V("allocate", Object.class);

  private static final MethodHandle WRAPFILTER = findOwnMH_S("wrapFilter", Object.class, Object.class);

  private static final MethodHandle SCRIPTFUNCTION_GLOBALFILTER = findOwnMH_S("globalFilter", Object.class, Object.class);

  /** method handle to scope getter for this ScriptFunction */
  public static final Call GET_SCOPE = virtualCallNoLookup(ScriptFunction.class, "getScope", ScriptObject.class);

  private static final MethodHandle IS_FUNCTION_MH = findOwnMH_S("isFunctionMH", boolean.class, Object.class, ScriptFunctionData.class);

  private static final MethodHandle IS_APPLY_FUNCTION = findOwnMH_S("isApplyFunction", boolean.class, boolean.class, Object.class, Object.class);

  private static final MethodHandle IS_WRAPPED_FUNCTION = findOwnMH_S("isWrappedFunction", boolean.class, Object.class, Object.class, ScriptFunctionData.class);

  private static final MethodHandle ADD_ZEROTH_ELEMENT = findOwnMH_S("addZerothElement", Object[].class, Object[].class, Object.class);

  private static final MethodHandle WRAP_THIS = MH.findStatic(MethodHandles.lookup(), ScriptFunctionData.class, "wrapThis", MH.type(Object.class, Object.class));

  // various property maps used for different kinds of functions
  
  // property map for anonymous function that serves as Function.proto
  private static final PropertyMap anonmap$;
  // property map for plain functions
  private static final PropertyMap functionmap$;
  // property map for bound functions
  private static final PropertyMap boundfunctionmap$;
  // property map for functions.
  private static final PropertyMap map$;

  // Marker object for lazily initialized proto object
  private static final Object LAZY_PROTOTYPE = new Object();

  static PropertyMap createFunctionMap(PropertyMap map) {
    var flags = Property.NOT_ENUMERABLE | Property.NOT_CONFIGURABLE;
    PropertyMap newMap = map;
    // Need to add properties directly to map since slots are assigned speculatively by newUserAccessors.
    newMap = newMap.addPropertyNoHistory(newMap.newUserAccessors("arguments", flags));
    newMap = newMap.addPropertyNoHistory(newMap.newUserAccessors("caller", flags));
    return newMap;
  }

  static PropertyMap createBoundFunctionMap(PropertyMap propertyMap) {
    // Bound function map is same as plain function map, but additionally lacks the "proto" property,
    // see ECMAScript 5.1 section 15.3.4.5
    return propertyMap.deleteProperty(propertyMap.findProperty("prototype"));
  }

  static /*<init>*/ {
    anonmap$ = PropertyMap.newMap();
    var properties = new ArrayList<Property>(3);
    properties.add(AccessorProperty.create("prototype", Property.NOT_ENUMERABLE | Property.NOT_CONFIGURABLE, G$PROTOTYPE, S$PROTOTYPE));
    properties.add(AccessorProperty.create("length", Property.NOT_ENUMERABLE | Property.NOT_CONFIGURABLE | Property.NOT_WRITABLE, G$LENGTH, null));
    properties.add(AccessorProperty.create("name", Property.NOT_ENUMERABLE | Property.NOT_CONFIGURABLE | Property.NOT_WRITABLE, G$NAME, null));
    map$ = PropertyMap.newMap(properties);
    functionmap$ = createFunctionMap(map$);
    boundfunctionmap$ = createBoundFunctionMap(functionmap$);
  }

  // The parent scope.
  private final ScriptObject scope;

  private final ScriptFunctionData data;

  /** The property map used for newly allocated object when function is used as constructor. */
  protected PropertyMap allocatorMap;

  /** Reference to constructor proto. */
  protected Object prototype;

  /**
   * Constructor
   *
   * @param data static function data
   * @param map property map
   * @param scope scope
   */
  ScriptFunction(ScriptFunctionData data, PropertyMap map, ScriptObject scope, Global global) {
    super(map);
    this.data = data;
    this.scope = scope;
    this.setInitialProto(global.getFunctionPrototype());
    this.prototype = LAZY_PROTOTYPE;
    // We have to fill user accessor functions late as these are stored in this object rather than in the PropertyMap of this object.
    assert objectSpill == null;
    if (isBoundFunction()) {
      var typeErrorThrower = global.getTypeErrorThrower();
      initUserAccessors("arguments", typeErrorThrower, typeErrorThrower);
      initUserAccessors("caller", typeErrorThrower, typeErrorThrower);
    }
  }

  /**
   * Constructor
   *
   * @param name function name
   * @param methodHandle method handle to function (if specializations are present, assumed to be most generic)
   * @param map property map
   * @param scope scope
   * @param specs specialized version of this function - other method handles
   * @param flags {@link ScriptFunctionData} flags
   */
  ScriptFunction(String name, MethodHandle methodHandle, PropertyMap map, ScriptObject scope, Specialization[] specs, int flags, Global global) {
    this(new FinalScriptFunctionData(name, methodHandle, specs, flags), map, scope, global);
  }

  /**
   * Constructor
   *
   * @param name name of function
   * @param methodHandle handle for invocation
   * @param scope scope object
   * @param specs specialized versions of this method, if available, null otherwise
   * @param flags {@link ScriptFunctionData} flags
   */
  ScriptFunction(String name, MethodHandle methodHandle, ScriptObject scope, Specialization[] specs, int flags) {
    this(name, methodHandle, functionmap$, scope, specs, flags, Global.instance());
  }

  /**
   * Constructor called by Nasgen generated code, zero added members, use the default map.
   * Creates builtin functions only.
   * @param name name of function
   * @param invokeHandle handle for invocation
   * @param specs specialized versions of this method, if available, null otherwise
   */
  protected ScriptFunction(String name, MethodHandle invokeHandle, Specialization[] specs) {
    this(name, invokeHandle, map$, null, specs, ScriptFunctionData.IS_BUILTIN_CONSTRUCTOR, Global.instance());
  }

  /**
   * Constructor called by Nasgen generated code, non zero member count, use the map passed as argument.
   * Creates builtin functions only.
   * @param name name of function
   * @param invokeHandle handle for invocation
   * @param map initial property map
   * @param specs specialized versions of this method, if available, null
   * otherwise
   */
  protected ScriptFunction(String name, MethodHandle invokeHandle, PropertyMap map, Specialization[] specs) {
    this(name, invokeHandle, map.addAll(map$), null, specs, ScriptFunctionData.IS_BUILTIN_CONSTRUCTOR, Global.instance());
  }

  // Factory methods to create various functions

  /**
   * Factory method called by compiler generated code for functions that need parent scope.
   * @param constants the generated class' constant array
   * @param index the index of the {@code RecompilableScriptFunctionData} object in the constants array.
   * @param scope the parent scope object
   * @return a newly created function object
   */
  public static ScriptFunction create(Object[] constants, int index, ScriptObject scope) {
    var data = (RecompilableScriptFunctionData) constants[index];
    return new ScriptFunction(data, functionmap$, scope, Global.instance());
  }

  /**
   * Factory method called by compiler generated code for functions that don't need parent scope.
   * @param constants the generated class' constant array
   * @param index the index of the {@code RecompilableScriptFunctionData} object in the constants array.
   * @return a newly created function object
   */
  public static ScriptFunction create(Object[] constants, int index) {
    return create(constants, index, null);
  }

  /**
   * Create anonymous function that serves as Function.proto
   * @return anonymous function object
   */
  public static ScriptFunction createAnonymous() {
    return new ScriptFunction("", GlobalFunctions.ANONYMOUS, anonmap$, null);
  }

  // builtin function create helper factory
  static ScriptFunction createBuiltin(String name, MethodHandle methodHandle, Specialization[] specs, int flags) {
    var func = new ScriptFunction(name, methodHandle, null, specs, flags);
    func.setPrototype(UNDEFINED);
    // Non-constructor built-in functions do not have "proto" property
    func.deleteOwnProperty(func.getMap().findProperty("prototype"));
    return func;
  }

  /**
   * Factory method for non-constructor built-in functions
   * @param name function name
   * @param methodHandle handle for invocation
   * @param specs specialized versions of function if available, null otherwise
   * @return new ScriptFunction
   */
  public static ScriptFunction createBuiltin(String name, MethodHandle methodHandle, Specialization[] specs) {
    return ScriptFunction.createBuiltin(name, methodHandle, specs, ScriptFunctionData.IS_BUILTIN);
  }

  /**
   * Factory method for non-constructor built-in functions
   * @param name function name
   * @param methodHandle handle for invocation
   * @return new ScriptFunction
   */
  public static ScriptFunction createBuiltin(String name, MethodHandle methodHandle) {
    return ScriptFunction.createBuiltin(name, methodHandle, null);
  }

  // Subclass to represent bound functions
  static class Bound extends ScriptFunction {

    private final ScriptFunction target;

    Bound(ScriptFunctionData boundData, ScriptFunction target) {
      super(boundData, boundfunctionmap$, null, Global.instance());
      setPrototype(ScriptRuntime.UNDEFINED);
      this.target = target;
    }

    @Override
    protected ScriptFunction getTargetFunction() {
      return target;
    }
  }

  /**
   * Creates a version of this function bound to a specific "self" and other arguments, as per {@code Function.proto.bind} functionality in ECMAScript 5.1 section 15.3.4.5.
   * @param self the self to bind to this function. Can be null (in which case, null is bound as this).
   * @param args additional arguments to bind to this function. Can be null or empty to not bind additional arguments.
   * @return a function with the specified self and parameters bound.
   */
  public final ScriptFunction createBound(Object self, Object[] args) {
    return new Bound(data.makeBoundFunctionData(this, self, args), getTargetFunction());
  }

  /**
   * Create a function that invokes this function synchronized on {@code sync} or the self object of the invocation.
   * @param sync the Object to synchronize on, or undefined
   * @return synchronized function
   */
  public final ScriptFunction createSynchronized(Object sync) {
    var mh = MH.insertArguments(ScriptFunction.INVOKE_SYNC, 0, this, sync);
    return createBuiltin(getName(), mh);
  }

  @Override
  public String getClassName() {
    return "Function";
  }

  /**
   * ECMA 15.3.5.3 [[HasInstance]] (V)
 Step 3 if "proto" value is not an Object, throw TypeError
   */
  @Override
  public boolean isInstance(ScriptObject instance) {
    var basePrototype = getTargetFunction().getPrototype();
    if (!(basePrototype instanceof ScriptObject)) {
      throw typeError("prototype.not.an.object", ScriptRuntime.safeToString(getTargetFunction()), ScriptRuntime.safeToString(basePrototype));
    }
    for (var proto = instance.getProto(); proto != null; proto = proto.getProto()) {
      if (proto == basePrototype) {
        return true;
      }
    }
    return false;
  }

  /**
   * Returns the target function for this function.
   * If the function was not created using {@link #createBound(Object, Object[])}, its target function is itself.
   * If it is bound, its target function is the target function of the function it was made from (therefore, the target function is always the final, unbound recipient of the calls).
   * @return the target function for this function.
   */
  protected ScriptFunction getTargetFunction() {
    return this;
  }

  final boolean isBoundFunction() {
    return getTargetFunction() != this;
  }

  /**
   * Set the arity of this ScriptFunction
   * @param arity arity
   */
  public final void setArity(int arity) {
    data.setArity(arity);
  }

  /**
   * Is this is a function with all variables in scope?
   * @return true if function has all
   */
  public boolean hasAllVarsInScope() {
    return data instanceof RecompilableScriptFunctionData fd && (fd.getFunctionFlags() & FunctionNode.HAS_ALL_VARS_IN_SCOPE) != 0;
  }

  /**
   * Returns true if this is a non-strict, non-built-in function that requires non-primitive this argument according to ECMA 10.4.3.
   * @return true if this argument must be an object
   */
  public final boolean needsWrappedThis() {
    return data.needsWrappedThis();
  }

  static boolean needsWrappedThis(Object fn) {
    return fn instanceof ScriptFunction ? ((ScriptFunction) fn).needsWrappedThis() : false;
  }

  /**
   * Execute this script function.
   * @param self Target object.
   * @param arguments Call arguments.
   * @return ScriptFunction result.
   * @throws Throwable if there is an exception/error with the invocation or
   * thrown from it
   */
  final Object invoke(Object self, Object... arguments) throws Throwable {
    return data.invoke(this, self, arguments);
  }

  /**
   * Execute this script function as a constructor.
   * @param arguments Call arguments.
   * @return Newly constructed result.
   * @throws Throwable if there is an exception/error with the invocation or thrown from it
   */
  final Object construct(Object... arguments) throws Throwable {
    return data.construct(this, arguments);
  }

  /**
   * Allocate function.
   * Called from generated {@link ScriptObject} code for allocation as a factory method
   * @return a new instance of the {@link ScriptObject} whose proto this is
   */
  @SuppressWarnings("unused")
  Object allocate() {
    assert !isBoundFunction(); // allocate never invoked on bound functions
    var proto = getAllocatorPrototype();
    var object = data.allocate(getAllocatorMap(proto));
    if (object != null) {
      object.setInitialProto(proto);
    }
    return object;
  }

  /**
   * Get the property map used by "allocate"
   * @param prototype actual proto object
   * @return property map
   */
  PropertyMap getAllocatorMap(ScriptObject prototype) {
    if (allocatorMap == null || allocatorMap.isInvalidSharedMapFor(prototype)) {
      // The proto map has changed since this function was last used as constructor.
      // Get a new proto map.
      allocatorMap = data.getAllocatorMap(prototype);
    }
    return allocatorMap;
  }

  /**
   * Return the actual proto used by "allocate"
   * @return proto proto
   */
  ScriptObject getAllocatorPrototype() {
    var proto = getPrototype();
    return (proto instanceof ScriptObject so) ? so : Global.objectPrototype();
  }

  @Override
  public final String safeToString() {
    return toSource();
  }

  @Override
  public final String toString() {
    return data.toString();
  }

  /**
   * Get this function as a String containing its source code.
   * If no source code exists in this ScriptFunction, its contents will be displayed as {@code [native code]}
   * @return string representation of this function's source
   */
  public final String toSource() {
    return data.toSource();
  }

  /**
   * Get the proto object for this function
   * @return proto
   */
  public final Object getPrototype() {
    if (prototype == LAZY_PROTOTYPE) {
      prototype = new PrototypeObject(this);
    }
    return prototype;
  }

  /**
   * Set the proto object for this function
   * @param newPrototype new proto object
   */
  public final void setPrototype(Object newPrototype) {
    if (newPrototype instanceof ScriptObject && newPrototype != this.prototype && allocatorMap != null) {
      // Unset proto map to be replaced with one matching the new proto.
      allocatorMap = null;
    }
    this.prototype = newPrototype;
  }

  /**
   * Return the invoke handle bound to a given ScriptObject self reference.
   * If callee parameter is required result is rebound to this.
   * @param self self reference
   * @return bound invoke handle
   */
  public final MethodHandle getBoundInvokeHandle(Object self) {
    return MH.bindTo(bindToCalleeIfNeeded(data.getGenericInvoker(scope)), self);
  }

  /**
   * Bind the method handle to this {@code ScriptFunction} instance if it needs a callee parameter.
   * If this function's method handles don't have a callee parameter, the handle is returned unchanged.
   * @param methodHandle the method handle to potentially bind to this function instance.
   * @return the potentially bound method handle
   */
  MethodHandle bindToCalleeIfNeeded(MethodHandle methodHandle) {
    return ScriptFunctionData.needsCallee(methodHandle) ? MH.bindTo(methodHandle, this) : methodHandle;
  }

  /**
   * Get the documentation for this function
   * @return the documentation
   */
  public final String getDocumentation() {
    return data.getDocumentation();
  }

  /**
   * Get the documentation key for this function
   * @return the documentation key
   */
  public final String getDocumentationKey() {
    return data.getDocumentationKey();
  }

  /**
   * Set the documentation key for this function
   * @param docKey documentation key String for this function
   */
  public final void setDocumentationKey(String docKey) {
    data.setDocumentationKey(docKey);
  }

  /**
   * Get the name for this function
   * @return the name
   */
  public final String getName() {
    return data.getName();
  }

  /**
   * Get the scope for this function
   * @return the scope
   */
  public final ScriptObject getScope() {
    return scope;
  }

  /**
   * Prototype getter for this ScriptFunction - follows the naming convention used by Nasgen and the code generator
   * @param self self reference
   * @return self's proto
   */
  public static Object G$prototype(Object self) {
    return self instanceof ScriptFunction sf  ? sf.getPrototype() : UNDEFINED;
  }

  /**
   * Prototype setter for this ScriptFunction - follows the naming convention used by Nasgen and the code generator
   * @param self self reference
   * @param prototype proto to set
   */
  public static void S$prototype(Object self, Object prototype) {
    if (self instanceof ScriptFunction sf) {
      sf.setPrototype(prototype);
    }
  }

  /**
   * Length getter - ECMA 15.3.3.2: Function.length
   * @param self self reference
   * @return length
   */
  public static int G$length(Object self) {
    return (self instanceof ScriptFunction sf) ? sf.data.getArity() : 0;
  }

  /**
   * Name getter - ECMA Function.name
   * @param self self reference
   * @return the name, or undefined if none
   */
  public static Object G$name(Object self) {
    return (self instanceof ScriptFunction sf) ? sf.getName() : UNDEFINED;
  }

  /**
   * Get the proto for this ScriptFunction
   * @param constructor constructor
   * @return proto, or null if given constructor is not a ScriptFunction
   */
  public static ScriptObject getPrototype(ScriptFunction constructor) {
    if (constructor != null) {
      var proto = constructor.getPrototype();
      if (proto instanceof ScriptObject so) {
        return so;
      }
    }
    return null;
  }

  @Override
  protected GuardedInvocation findNewMethod(CallSiteDescriptor desc, LinkRequest request) {
    var type = desc.getMethodType();
    assert desc.getMethodType().returnType() == Object.class && !NashornCallSiteDescriptor.isOptimistic(desc);
    var cf = data.getBestConstructor(type, scope, CompiledFunction.NO_FUNCTIONS);
    var bestCtorInv = cf.createConstructorInvocation();
    // TODO - ClassCastException
    return new GuardedInvocation(pairArguments(bestCtorInv.getInvocation(), type), getFunctionGuard(this, cf.getFlags()), bestCtorInv.getSwitchPoints(), null);
  }

  static Object wrapFilter(Object obj) {
    return (obj instanceof ScriptObject || !ScriptFunctionData.isPrimitiveThis(obj)) ? obj : Context.getGlobal().wrapAsObject(obj);
  }

  @SuppressWarnings("unused")
  static Object globalFilter(Object object) {
    // replace whatever we get with the current global object
    return Context.getGlobal();
  }

  /**
   * Some receivers are primitive, in that case, according to the Spec we create a new native object per callsite with the wrap filter.
   * We can only apply optimistic builtins if there is no per instance state saved for these wrapped objects (e.g. currently NativeStrings), otherwise we can't create optimistic versions
   * @param self receiver
   * @param linkLogicClass linkLogicClass, or null if no link logic exists
   * @return link logic instance, or null if one could not be constructed for this receiver
   */
  static LinkLogic getLinkLogic(Object self, Class<? extends LinkLogic> linkLogicClass) {
    if (linkLogicClass == null) {
      return LinkLogic.EMPTY_INSTANCE; //always OK to link this, specialization but without special linking logic
    }
    if (!Context.getContextTrusted().getEnv()._optimistic_types) {
      return null; //if optimistic types are off, optimistic builtins are too
    }
    var wrappedSelf = wrapFilter(self);
    if (wrappedSelf instanceof OptimisticBuiltins ob) {
      if (wrappedSelf != self && ob.hasPerInstanceAssumptions()) {
        return null; //pessimistic - we created a wrapped object different from the primitive, but the assumptions have instance state
      }
      return ob.getLinkLogic(linkLogicClass);
    }
    return null;
  }

  /**
   * StandardOperation.CALL call site signature: (callee, thiz, [args...]) generated method signature: (callee, thiz, [args...])
   *
   * cases:
   * (a) method has callee parameter
   *     (1) for local/scope calls, we just bind thiz and drop the second argument.
   *     (2) for normal this-calls, we have to swap thiz and callee to get matching signatures.
   * (b) method doesn't have callee parameter (builtin functions)
   *     (3) for local/scope calls, bind thiz and drop both callee and thiz.
   *     (4) for normal this-calls, drop callee.
   *
   * @return guarded invocation for call
   */
  @Override
  protected GuardedInvocation findCallMethod(CallSiteDescriptor desc, LinkRequest request) {
    var type = desc.getMethodType();
    var name = getName();
    var isUnstable = request.isCallSiteUnstable();
    var scopeCall = NashornCallSiteDescriptor.isScope(desc);
    var isCall = !scopeCall && data.isBuiltin() && "call".equals(name);
    var isApply = !scopeCall && data.isBuiltin() && "apply".equals(name);
    var isApplyOrCall = isCall | isApply;
    if (isUnstable && !isApplyOrCall) {
      // megamorphic - replace call with apply
      MethodHandle handle;
      // ensure that the callsite is vararg so apply can consume it
      if (type.parameterCount() == 3 && type.parameterType(2) == Object[].class) {
        // Vararg call site
        handle = ScriptRuntime.APPLY.methodHandle();
      } else {
        // (callee, this, args...) => (callee, this, args[])
        handle = MH.asCollector(ScriptRuntime.APPLY.methodHandle(), Object[].class, type.parameterCount() - 2);
      }
      // If call site is statically typed to take a ScriptFunction, we don't need a guard, otherwise we need a generic "is this a ScriptFunction?" guard.
      return new GuardedInvocation(handle, null, (SwitchPoint) null, ClassCastException.class);
    }
    MethodHandle boundHandle;
    MethodHandle guard = null;
    // Special handling of Function.apply and Function.call. Note we must be invoking
    if (isApplyOrCall && !isUnstable) {
      var args = request.getArguments();
      if (Bootstrap.isCallable(args[1])) {
        return createApplyOrCallCall(isApply, desc, request, args);
      }
    } // else just fall through and link as ordinary function or unstable apply
    var programPoint = INVALID_PROGRAM_POINT;
    if (NashornCallSiteDescriptor.isOptimistic(desc)) {
      programPoint = NashornCallSiteDescriptor.getProgramPoint(desc);
    }
    CompiledFunction cf = data.getBestInvoker(type, scope, CompiledFunction.NO_FUNCTIONS);
    var self = request.getArguments()[1];
    var forbidden = new HashSet<CompiledFunction>();

    // check for special fast versions of the compiled function
    var sps = new ArrayList<SwitchPoint>();
    Class<? extends Throwable> exceptionGuard = null;
    while (cf.isSpecialization()) {
      var linkLogicClass = cf.getLinkLogicClass();
      // if linklogic is null, we can always link with the standard mechanism, it's still a specialization
      var linkLogic = getLinkLogic(self, linkLogicClass);
      if (linkLogic != null && linkLogic.checkLinkable(self, desc, request)) {
        var log = Context.getContextTrusted().getLogger(Compiler.class);
        if (log.isEnabled()) {
          log.info("Linking optimistic builtin function: '", name, "' args=", Arrays.toString(request.getArguments()), " desc=", desc);
        }
        exceptionGuard = linkLogic.getRelinkException();
        break;
      }
      // could not link this specialization because link check failed
      forbidden.add(cf);
      CompiledFunction oldCf = cf;
      cf = data.getBestInvoker(type, scope, forbidden);
      assert oldCf != cf;
    }
    var bestInvoker = cf.createFunctionInvocation(type.returnType(), programPoint);
    var callHandle = bestInvoker.getInvocation();
    if (data.needsCallee()) {
      if (scopeCall && needsWrappedThis()) {
        // (callee, this, args...) => (callee, [this], args...)
        boundHandle = MH.filterArguments(callHandle, 1, SCRIPTFUNCTION_GLOBALFILTER);
      } else {
        // It's already (callee, this, args...), just what we need
        boundHandle = callHandle;
      }
    } else if (data.isBuiltin() && Global.isBuiltInJavaExtend(this)) {
      // We're binding the current lookup as "self" so the function can do security-sensitive creation of adapter classes.
      boundHandle = MH.dropArguments(MH.bindTo(callHandle, getLookupPrivileged(desc)), 0, type.parameterType(0), type.parameterType(1));
    } else if (data.isBuiltin() && Global.isBuiltInJavaTo(this)) {
      // We're binding the current call site descriptor as "self" so the function can do security-sensitive creation of adapter classes.
      boundHandle = MH.dropArguments(MH.bindTo(callHandle, desc), 0, type.parameterType(0), type.parameterType(1));
    } else if (scopeCall && needsWrappedThis()) {
      // Make a handle that drops the passed "this" argument and substitutes either Global or Undefined (this, args...) => ([this], args...)
      boundHandle = MH.filterArguments(callHandle, 0, SCRIPTFUNCTION_GLOBALFILTER);
      // ([this], args...) => ([callee], [this], args...)
      boundHandle = MH.dropArguments(boundHandle, 0, type.parameterType(0));
    } else {
      // (this, args...) => ([callee], this, args...)
      boundHandle = MH.dropArguments(callHandle, 0, type.parameterType(0));
    }
    // For non-strict functions, check whether this-object is primitive type.
    // If so add a to-object-wrapper argument filter.
    // Else install a guard that will trigger a relink when the argument becomes primitive.
    if (!scopeCall && needsWrappedThis()) {
      if (ScriptFunctionData.isPrimitiveThis(request.getArguments()[1])) {
        boundHandle = MH.filterArguments(boundHandle, 1, WRAPFILTER);
      } else {
        guard = getWrappedFunctionGuard(this);
      }
    }
    // Is this an unstable callsite which was earlier apply-to-call optimized?
    // If so, earlier apply2call would have exploded arguments.
    // We have to convert that as an array again!
    if (isUnstable && NashornCallSiteDescriptor.isApplyToCall(desc)) {
      boundHandle = MH.asCollector(boundHandle, Object[].class, type.parameterCount() - 2);
    }
    boundHandle = pairArguments(boundHandle, type);
    if (bestInvoker.getSwitchPoints() != null) {
      sps.addAll(Arrays.asList(bestInvoker.getSwitchPoints()));
    }
    var spsArray = sps.isEmpty() ? null : sps.toArray(new SwitchPoint[0]);
    return new GuardedInvocation(boundHandle, guard == null ? getFunctionGuard(this, cf.getFlags()) : guard, spsArray, exceptionGuard);
  }

  static Lookup getLookupPrivileged(CallSiteDescriptor desc) {
    // NOTE: we'd rather not make NashornCallSiteDescriptor.getLookupPrivileged public.
    return desc.getLookup();
  }

  GuardedInvocation createApplyOrCallCall(boolean isApply, CallSiteDescriptor desc, LinkRequest request, Object[] args) {
    var descType = desc.getMethodType();
    var paramCount = descType.parameterCount();
    if (descType.parameterType(paramCount - 1).isArray()) {
      // This is vararg invocation of apply or call.
      // This can normally only happen when we do a recursive invocation of createApplyOrCallCall (because we're doing apply-of-apply).
      // In this case, create delegate linkage by unpacking the vararg invocation and use pairArguments to introduce the necessary spreader.
      return createVarArgApplyOrCallCall(isApply, desc, request, args);
    }
    var passesThis = paramCount > 2;
    var passesArgs = paramCount > 3;
    var realArgCount = passesArgs ? paramCount - 3 : 0;
    var appliedFn = args[1];
    var appliedFnNeedsWrappedThis = needsWrappedThis(appliedFn);
    // box call back to apply
    var appliedDesc = desc;
    var applyToCallSwitchPoint = Global.getBuiltinFunctionApplySwitchPoint();
    // enough to change the proto switchPoint here
    var isApplyToCall = NashornCallSiteDescriptor.isApplyToCall(desc);
    var isFailedApplyToCall = isApplyToCall && applyToCallSwitchPoint.hasBeenInvalidated();
    // R(apply|call, ...) => R(...)
    var appliedType = descType.dropParameterTypes(0, 1);
    if (!passesThis) {
      // R() => R(this)
      appliedType = appliedType.insertParameterTypes(1, Object.class);
    } else if (appliedFnNeedsWrappedThis) {
      appliedType = appliedType.changeParameterType(1, Object.class);
    }
    // dropArgs is a synthetic method handle that contains any args that we need to get rid of that come after the arguments array in the apply case.
    // We adapt the callsite to ask for 3 args only and then dropArguments on the method handle to make it fit the extraneous args.
    var dropArgs = MH.type(void.class);
    if (isApply && !isFailedApplyToCall) {
      var pc = appliedType.parameterCount();
      for (var i = 3; i < pc; i++) {
        dropArgs = dropArgs.appendParameterTypes(appliedType.parameterType(i));
      }
      if (pc > 3) {
        appliedType = appliedType.dropParameterTypes(3, pc);
      }
    }
    if (isApply || isFailedApplyToCall) {
      if (passesArgs) {
        // R(this, args) => R(this, Object[])
        appliedType = appliedType.changeParameterType(2, Object[].class);
        // drop any extraneous arguments for the apply fail case
        if (isFailedApplyToCall) {
          appliedType = appliedType.dropParameterTypes(3, paramCount - 1);
        }
      } else {
        // R(this) => R(this, Object[])
        appliedType = appliedType.insertParameterTypes(2, Object[].class);
      }
    }
    appliedDesc = appliedDesc.changeMethodType(appliedType); //no extra args
    // Create the same arguments for the delegate linking request that would be passed in an actual apply'd invocation
    var appliedArgs = new Object[isApply ? 3 : appliedType.parameterCount()];
    appliedArgs[0] = appliedFn;
    appliedArgs[1] = passesThis ? appliedFnNeedsWrappedThis ? ScriptFunctionData.wrapThis(args[2]) : args[2] : ScriptRuntime.UNDEFINED;
    if (isApply && !isFailedApplyToCall) {
      appliedArgs[2] = passesArgs ? NativeFunction.toApplyArgs(args[3]) : ScriptRuntime.EMPTY_ARRAY;
    } else {
      if (passesArgs) {
        if (isFailedApplyToCall) {
          var tmp = new Object[args.length - 3];
          System.arraycopy(args, 3, tmp, 0, tmp.length);
          appliedArgs[2] = NativeFunction.toApplyArgs(tmp);
        } else {
          assert !isApply;
          System.arraycopy(args, 3, appliedArgs, 2, args.length - 3);
        }
      } else if (isFailedApplyToCall) {
        appliedArgs[2] = ScriptRuntime.EMPTY_ARRAY;
      }
    }

    // Ask the linker machinery for an invocation of the target function
    var appliedRequest = request.replaceArguments(appliedDesc, appliedArgs);
    GuardedInvocation appliedInvocation;
    try {
      appliedInvocation = Bootstrap.getLinkerServices().getGuardedInvocation(appliedRequest);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
    assert appliedRequest != null; // Bootstrap.isCallable() returned true for args[1], so it must produce a linkage.
    var applyFnType = descType.parameterType(0);
    // Invocation and guard handles from apply invocation.
    var inv = appliedInvocation.getInvocation();
    var guard = appliedInvocation.getGuard();
    if (isApply && !isFailedApplyToCall) {
      if (passesArgs) {
        // Make sure that the passed argArray is converted to Object[] the same way NativeFunction.apply() would do it.
        inv = MH.filterArguments(inv, 2, NativeFunction.TO_APPLY_ARGS);
        // Some guards (non-strict functions with non-primitive this) have a this-object parameter, so we
        // need to apply this transformations to them as well.
        if (guard.type().parameterCount() > 2) {
          guard = MH.filterArguments(guard, 2, NativeFunction.TO_APPLY_ARGS);
        }
      } else {
        // If the original call site doesn't pass argArray, pass in an empty array
        inv = MH.insertArguments(inv, 2, (Object) ScriptRuntime.EMPTY_ARRAY);
      }
    }
    if (isApplyToCall) {
      if (isFailedApplyToCall) {
        // take the real arguments that were passed to a call and force them into the apply instead
        Context.getContextTrusted().getLogger(ApplySpecialization.class).info("Collection arguments to revert call to apply in " + appliedFn);
        inv = MH.asCollector(inv, Object[].class, realArgCount);
      } else {
        appliedInvocation = appliedInvocation.addSwitchPoint(applyToCallSwitchPoint);
      }
    }
    if (!passesThis) {
      // If the original call site doesn't pass in a thisArg, pass in Global/undefined as needed
      inv = bindImplicitThis(appliedFnNeedsWrappedThis, inv);
      // guard may have this-parameter that needs to be inserted
      if (guard.type().parameterCount() > 1) {
        guard = bindImplicitThis(appliedFnNeedsWrappedThis, guard);
      }
    } else if (appliedFnNeedsWrappedThis) {
      // target function needs a wrapped this, so make sure we filter for that
      inv = MH.filterArguments(inv, 1, WRAP_THIS);
      // guard may have this-parameter that needs to be wrapped
      if (guard.type().parameterCount() > 1) {
        guard = MH.filterArguments(guard, 1, WRAP_THIS);
      }
    }
    var guardType = guard.type(); // Needed for combining guards below
    // We need to account for the dropped (apply|call) function argument.
    inv = MH.dropArguments(inv, 0, applyFnType);
    guard = MH.dropArguments(guard, 0, applyFnType);
    // Dropargs can only be non-()V in the case of isApply && !isFailedApplyToCall, which is when we need to add arguments to the callsite to catch and ignore the synthetic extra args that someone has added to the command line.
    for (var i = 0; i < dropArgs.parameterCount(); i++) {
      inv = MH.dropArguments(inv, 4 + i, dropArgs.parameterType(i));
    }
    // Take the "isApplyFunction" guard, and bind it to this function.
    var applyFnGuard = MH.insertArguments(IS_APPLY_FUNCTION, 2, this); //TODO replace this with switchpoint
    // Adapt the guard to receive all the arguments that the original guard does.
    applyFnGuard = MH.dropArguments(applyFnGuard, 2, guardType.parameterArray());
    // Fold the original function guard into our apply guard.
    guard = MH.foldArguments(applyFnGuard, guard);
    return appliedInvocation.replaceMethods(inv, guard);
  }

  /*
     * This method is used for linking nested apply. Specialized apply and call linking will create a variable arity
     * call site for an apply call; when createApplyOrCallCall sees a linking request for apply or call with
     * Nashorn-style variable arity call site (last argument type is Object[]) it'll delegate to this method.
     * This method converts the link request from a vararg to a non-vararg one (unpacks the array), then delegates back
     * to createApplyOrCallCall (with which it is thus mutually recursive), and adds appropriate argument spreaders to
     * invocation and the guard of whatever createApplyOrCallCall returned to adapt it back into a variable arity
     * invocation. It basically reduces the problem of vararg call site linking of apply and call back to the (already
     * solved by createApplyOrCallCall) non-vararg call site linking.
   */
  private GuardedInvocation createVarArgApplyOrCallCall(boolean isApply, CallSiteDescriptor desc,
          final LinkRequest request, Object[] args) {
    final MethodType descType = desc.getMethodType();
    final int paramCount = descType.parameterCount();
    final Object[] varArgs = (Object[]) args[paramCount - 1];
    // -1 'cause we're not passing the vararg array itself
    final int copiedArgCount = args.length - 1;
    final int varArgCount = varArgs.length;

    // Spread arguments for the delegate createApplyOrCallCall invocation.
    final Object[] spreadArgs = new Object[copiedArgCount + varArgCount];
    System.arraycopy(args, 0, spreadArgs, 0, copiedArgCount);
    System.arraycopy(varArgs, 0, spreadArgs, copiedArgCount, varArgCount);

    // Spread call site descriptor for the delegate createApplyOrCallCall invocation. We drop vararg array and
    // replace it with a list of Object.class.
    final MethodType spreadType = descType.dropParameterTypes(paramCount - 1, paramCount).appendParameterTypes(
            Collections.<Class<?>>nCopies(varArgCount, Object.class));
    final CallSiteDescriptor spreadDesc = desc.changeMethodType(spreadType);

    // Delegate back to createApplyOrCallCall with the spread (that is, reverted to non-vararg) request/
    final LinkRequest spreadRequest = request.replaceArguments(spreadDesc, spreadArgs);
    final GuardedInvocation spreadInvocation = createApplyOrCallCall(isApply, spreadDesc, spreadRequest, spreadArgs);

    // Add spreader combinators to returned invocation and guard.
    return spreadInvocation.replaceMethods(
            // Use standard ScriptObject.pairArguments on the invocation
            pairArguments(spreadInvocation.getInvocation(), descType),
            // Use our specialized spreadGuardArguments on the guard (see below).
            spreadGuardArguments(spreadInvocation.getGuard(), descType));
  }

  static MethodHandle spreadGuardArguments(MethodHandle guard, MethodType descType) {
    var guardType = guard.type();
    var guardParamCount = guardType.parameterCount();
    var descParamCount = descType.parameterCount();
    var spreadCount = guardParamCount - descParamCount + 1;
    if (spreadCount <= 0) {
      // Guard doesn't dip into the varargs
      return guard;
    }
    MethodHandle arrayConvertingGuard;
    // If the last parameter type of the guard is an array, then it is already itself a guard for a vararg apply invocation.
    // We must filter the last argument with toApplyArgs otherwise deeper levels of nesting will fail with ClassCastException of NativeArray to Object[].
    if (guardType.parameterType(guardParamCount - 1).isArray()) {
      arrayConvertingGuard = MH.filterArguments(guard, guardParamCount - 1, NativeFunction.TO_APPLY_ARGS);
    } else {
      arrayConvertingGuard = guard;
    }
    return ScriptObject.adaptHandleToVarArgCallSite(arrayConvertingGuard, descParamCount);
  }

  static MethodHandle bindImplicitThis(boolean needsWrappedThis, MethodHandle mh) {
    var bound = needsWrappedThis ? MH.filterArguments(mh, 1, SCRIPTFUNCTION_GLOBALFILTER) : mh;
    return MH.insertArguments(bound, 1, ScriptRuntime.UNDEFINED);
  }

  /**
   * Used for noSuchMethod/noSuchProperty and JSAdapter hooks.
   * These don't want a callee parameter, so bind that. Name binding is optional.
   */
  MethodHandle getCallMethodHandle(MethodType type, String bindName) {
    return pairArguments(bindToNameIfNeeded(bindToCalleeIfNeeded(data.getGenericInvoker(scope)), bindName), type);
  }

  static MethodHandle bindToNameIfNeeded(MethodHandle methodHandle, String bindName) {
    if (bindName == null) {
      return methodHandle;
    }
    // if it is vararg method, we need to extend argument array with a new zeroth element that is set to bindName value.
    var methodType = methodHandle.type();
    var parameterCount = methodType.parameterCount();
    if (parameterCount < 2) {
      return methodHandle; // method does not have enough parameters
    }
    var isVarArg = methodType.parameterType(parameterCount - 1).isArray();
    return isVarArg ? MH.filterArguments(methodHandle, 1, MH.insertArguments(ADD_ZEROTH_ELEMENT, 1, bindName)) : MH.insertArguments(methodHandle, 1, bindName);
  }

  /**
   * Get the guard that checks if a {@link ScriptFunction} is equal to a known ScriptFunction, using reference comparison
   * @param function The ScriptFunction to check against. This will be bound to the guard method handle
   * @return method handle for guard
   */
  static MethodHandle getFunctionGuard(ScriptFunction function, int flags) {
    assert function.data != null;
    // Built-in functions have a 1-1 correspondence to their ScriptFunctionData, so we can use a cheaper identity comparison for them.
    return function.data.isBuiltin() ? Guards.getIdentityGuard(function) : MH.insertArguments(IS_FUNCTION_MH, 1, function.data);
  }

  /**
   * Get a guard that checks if a {@link ScriptFunction} is equal to a known ScriptFunction using reference comparison, and whether the type of the second argument (this-object) is not a JavaScript primitive type.
   * @param function The ScriptFunction to check against. This will be bound to the guard method handle
   * @return method handle for guard
   */
  static MethodHandle getWrappedFunctionGuard(ScriptFunction function) {
    assert function.data != null;
    return MH.insertArguments(IS_WRAPPED_FUNCTION, 2, function.data);
  }

  @SuppressWarnings("unused")
  static boolean isFunctionMH(Object self, ScriptFunctionData data) {
    return self instanceof ScriptFunction && ((ScriptFunction) self).data == data;
  }

  @SuppressWarnings("unused")
  static boolean isWrappedFunction(Object self, Object arg, ScriptFunctionData data) {
    return self instanceof ScriptFunction && ((ScriptFunction) self).data == data && arg instanceof ScriptObject;
  }

  // TODO: this can probably be removed given that we have builtin switchpoints in the context
  @SuppressWarnings("unused")
  static boolean isApplyFunction(boolean appliedFnCondition, Object self, Object expectedSelf) {
    // NOTE: we're using self == expectedSelf as we're only using this with built-in functions apply() and call()
    return appliedFnCondition && self == expectedSelf;
  }

  @SuppressWarnings("unused")
  static Object[] addZerothElement(Object[] args, Object value) {
    // extends input array with by adding new zeroth element
    var src = args == null ? ScriptRuntime.EMPTY_ARRAY : args;
    var result = new Object[src.length + 1];
    System.arraycopy(src, 0, result, 1, src.length);
    result[0] = value;
    return result;
  }

  @SuppressWarnings("unused")
  static Object invokeSync(ScriptFunction func, Object sync, Object self, Object... args) throws Throwable {
    var syncObj = sync == UNDEFINED ? self : sync;
    synchronized (syncObj) {
      return func.invoke(self, args);
    }
  }

  static MethodHandle findOwnMH_S(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), ScriptFunction.class, name, MH.type(rtype, types));
  }

  static MethodHandle findOwnMH_V(String name, Class<?> rtype, Class<?>... types) {
    return MH.findVirtual(MethodHandles.lookup(), ScriptFunction.class, name, MH.type(rtype, types));
  }

}
