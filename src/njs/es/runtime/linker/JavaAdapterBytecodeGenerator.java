package es.runtime.linker;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.security.ProtectionDomain;

import java.lang.invoke.CallSite;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles.Lookup;
import java.lang.invoke.MethodType;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

import es.codegen.asm.ClassWriter;
import es.codegen.asm.Handle;
import es.codegen.asm.Label;
import es.codegen.asm.Opcodes;
import es.codegen.asm.Type;
import es.codegen.asm.InstructionAdapter;
import static es.codegen.asm.Opcodes.*;

import nash.scripting.ScriptObjectMirror;
import nash.scripting.ScriptUtils;

import es.codegen.CompilerConstants.Call;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.linker.AdaptationResult.Outcome;
import static es.codegen.CompilerConstants.interfaceCallNoLookup;
import static es.codegen.CompilerConstants.staticCallNoLookup;
import static es.lookup.Lookup.MH;
import static es.runtime.linker.AdaptationResult.Outcome.ERROR_NO_ACCESSIBLE_CONSTRUCTOR;

/**
 * Generates bytecode for a Java adapter class.
 * Used by the {@link JavaAdapterFactory}.
 * <p>
 * For every protected or public constructor in the extended class, the adapter class will have either one or two public constructors (visibility of protected constructors in the extended class is promoted to public).
 * <ul>
 * <li>For adapter classes with instance-level overrides, a constructor taking a trailing ScriptObject argument preceded by original constructor arguments is always created on the adapter class.
 * When such a constructor is invoked, the passed ScriptObject's member functions are used to implement and/or override methods on the original class, dispatched by name.
 * A single JavaScript function will act as the implementation for all overloaded methods of the same name.
 * When methods on an adapter instance are invoked, the functions are invoked having the ScriptObject passed in the instance constructor as their "this".
 * Subsequent changes to the ScriptObject (reassignment or removal of its functions) will be reflected in the adapter instance as it is live dispatching to its members on every method invocation.
 * {@code java.lang.Object} methods {@code equals}, {@code hashCode}, and {@code toString} can also be overridden.
 * The only restriction is that since every JavaScript object already has a {@code toString} function through the {@code Object.prototype}, the {@code toString} in the adapter is only overridden if the passed ScriptObject has a {@code toString} function as its own property, and not inherited from a prototype.
 * All other adapter methods can be implemented or overridden through a prototype-inherited function of the ScriptObject passed to the constructor too.
 * <li>
 * If the original types collectively have only one abstract method, or have several of them, but all share the same name, an additional constructor for instance-level override adapter is provided for every original constructor; this one takes a ScriptFunction as its last argument preceded by original constructor arguments.
 * This constructor will use the passed function as the implementation for all abstract methods.
 * For consistency, any concrete methods sharing the single abstract method name will also be overridden by the function. When methods on the adapter instance are invoked, the ScriptFunction is invoked with UNDEFINED as its "this".
 * <li>
 * If the adapter being generated has class-level overrides, constructors taking same arguments as the superclass constructors are created.
 * These constructors simply delegate to the superclass constructor.
 * They are simply used to create instances of the adapter class, with no instance-level overrides, as they don't have them.
 * If the original class' constructor was variable arity, the adapter constructor will also be variable arity.
 * Protected constructors are exposed as public.
 * </ul>
 * <p>
 * For adapter methods that return values, all the JavaScript-to-Java conversions supported by Nashorn will be in effect to coerce the JavaScript function return value to the expected Java return type.
 * <p>
 * Since we are adding a trailing argument to the generated constructors in the adapter class with instance-level overrides, they will never be declared as variable arity, even if the original constructor in the superclass was declared as variable arity.
 * The reason we are passing the additional argument at the end of the argument list instead at the front is that the source-level script expression <code>new X(a, b) { ... }</code> (which is a proprietary syntax extension Nashorn uses to resemble Java anonymous classes) is actually equivalent to <code>new X(a, b, { ... })</code>.
 * <p>
 * It is possible to create two different adapter classes: those that can have class-level overrides, and those that can have instance-level overrides.
 * When {@link JavaAdapterFactory#getAdapterClassFor(Class[], ScriptObject, ProtectionDomain)} or {@link JavaAdapterFactory#getAdapterClassFor(Class[], ScriptObject, Lookup)} is invoked
 * with non-null {@code classOverrides} parameter, an adapter class is created that can have class-level overrides, and the passed script object will be used as the implementations for its methods, just as in the above case of the constructor taking a script object.
 * Note that in the case of class-level overrides, a new adapter class is created on every invocation, and the implementation object is bound to the class, not to any instance.
 * All created instances will share these functions.
 * If it is required to have both class-level overrides and instance-level overrides, the class-level override adapter class should be subclassed with an instance-override adapter.
 * Since adapters delegate to super class when an overriding method handle is not specified, this will behave as expected.
 * <p>
 * It is not possible to have both class-level and instance-level overrides in the same class for security reasons:
 * adapter classes are defined with a protection domain of their creator code, and an adapter class that has both class and instance level overrides would need to have two potentially different protection domains:
 * one for class-based behavior and one for instance-based behavior; since Java classes can only belong to a single protection domain, this could not be implemented securely.
 */
final class JavaAdapterBytecodeGenerator {

  // Field names in adapters
  private static final String GLOBAL_FIELD_NAME = "global";
  private static final String DELEGATE_FIELD_NAME = "delegate";
  private static final String IS_FUNCTION_FIELD_NAME = "isFunction";
  private static final String CALL_THIS_FIELD_NAME = "callThis";

  // Initializer names
  private static final String INIT = "<init>";
  private static final String CLASS_INIT = "<clinit>";

  // Types often used in generated bytecode
  private static final Type OBJECT_TYPE = Type.getType(Object.class);
  private static final Type SCRIPT_OBJECT_TYPE = Type.getType(ScriptObject.class);
  private static final Type SCRIPT_FUNCTION_TYPE = Type.getType(ScriptFunction.class);
  private static final Type SCRIPT_OBJECT_MIRROR_TYPE = Type.getType(ScriptObjectMirror.class);

  // JavaAdapterServices methods used in generated bytecode
  private static final Call CHECK_FUNCTION = lookupServiceMethod("checkFunction", ScriptFunction.class, Object.class, String.class);
  private static final Call EXPORT_RETURN_VALUE = lookupServiceMethod("exportReturnValue", Object.class, Object.class);
  private static final Call GET_CALL_THIS = lookupServiceMethod("getCallThis", Object.class, ScriptFunction.class, Object.class);
  private static final Call GET_CLASS_OVERRIDES = lookupServiceMethod("getClassOverrides", ScriptObject.class);
  private static final Call GET_NON_NULL_GLOBAL = lookupServiceMethod("getNonNullGlobal", ScriptObject.class);
  private static final Call HAS_OWN_TO_STRING = lookupServiceMethod("hasOwnToString", boolean.class, ScriptObject.class);
  private static final Call INVOKE_NO_PERMISSIONS = lookupServiceMethod("invokeNoPermissions", void.class, MethodHandle.class, Object.class);
  private static final Call NOT_AN_OBJECT = lookupServiceMethod("notAnObject", void.class, Object.class);
  private static final Call SET_GLOBAL = lookupServiceMethod("setGlobal", Runnable.class, ScriptObject.class);
  private static final Call TO_CHAR_PRIMITIVE = lookupServiceMethod("toCharPrimitive", char.class, Object.class);
  private static final Call UNSUPPORTED = lookupServiceMethod("unsupported", UnsupportedOperationException.class);
  private static final Call WRAP_THROWABLE = lookupServiceMethod("wrapThrowable", RuntimeException.class, Throwable.class);
  private static final Call UNWRAP_MIRROR = lookupServiceMethod("unwrapMirror", ScriptObject.class, Object.class, boolean.class);

  // Other methods invoked by the generated bytecode
  private static final Call UNWRAP = staticCallNoLookup(ScriptUtils.class, "unwrap", Object.class, Object.class);
  private static final Call CHAR_VALUE_OF = staticCallNoLookup(Character.class, "valueOf", Character.class, char.class);
  private static final Call DOUBLE_VALUE_OF = staticCallNoLookup(Double.class, "valueOf", Double.class, double.class);
  private static final Call LONG_VALUE_OF = staticCallNoLookup(Long.class, "valueOf", Long.class, long.class);
  private static final Call RUN = interfaceCallNoLookup(Runnable.class, "run", void.class);

  // ASM handle to the bootstrap method
  private static final Handle BOOTSTRAP_HANDLE = new Handle(H_INVOKESTATIC,
    Type.getInternalName(JavaAdapterServices.class),
    "bootstrap",
    MethodType.methodType(CallSite.class, Lookup.class, String.class, MethodType.class, int.class)
              .toMethodDescriptorString(),
    false);

  // ASM handle to the bootstrap method for array populator
  private static final Handle CREATE_ARRAY_BOOTSTRAP_HANDLE = new Handle(H_INVOKESTATIC,
    Type.getInternalName(JavaAdapterServices.class),
    "createArrayBootstrap",
    MethodType.methodType(CallSite.class, Lookup.class, String.class, MethodType.class)
              .toMethodDescriptorString(),
    false);

  // Field type names used in the generated bytecode
  private static final String SCRIPT_OBJECT_TYPE_DESCRIPTOR = SCRIPT_OBJECT_TYPE.getDescriptor();
  private static final String OBJECT_TYPE_DESCRIPTOR = OBJECT_TYPE.getDescriptor();
  private static final String BOOLEAN_TYPE_DESCRIPTOR = Type.BOOLEAN_TYPE.getDescriptor();

  // Throwable names used in the generated bytecode
  private static final String RUNTIME_EXCEPTION_TYPE_NAME = Type.getInternalName(RuntimeException.class);
  private static final String ERROR_TYPE_NAME = Type.getInternalName(Error.class);
  private static final String THROWABLE_TYPE_NAME = Type.getInternalName(Throwable.class);

  // Some more frequently used method descriptors
  private static final String GET_METHOD_PROPERTY_METHOD_DESCRIPTOR = Type.getMethodDescriptor(OBJECT_TYPE, SCRIPT_OBJECT_TYPE);
  private static final String VOID_METHOD_DESCRIPTOR = Type.getMethodDescriptor(Type.VOID_TYPE);

  private static final String ADAPTER_PACKAGE_INTERNAL = "nash/javaadapters/";
  private static final int MAX_GENERATED_TYPE_NAME_LENGTH = 255;

  // Method name prefix for invoking super-methods
  static final String SUPER_PREFIX = "super$";

  // Method name and type for the no-privilege finalizer delegate
  private static final String FINALIZER_DELEGATE_NAME = "$$nashornFinalizerDelegate";
  private static final String FINALIZER_DELEGATE_METHOD_DESCRIPTOR = Type.getMethodDescriptor(Type.VOID_TYPE, OBJECT_TYPE);

  // Collection of methods we never override: Object.clone(), Object.finalize().
  private static final Collection<MethodInfo> EXCLUDED = getExcludedMethods();

  // This is the superclass for our generated adapter.
  private final Class<?> superClass;

  // Interfaces implemented by our generated adapter.
  private final List<Class<?>> interfaces;

  // Class loader used as the parent for the class loader we'll create to load the generated class.
  // It will be a class loader that has the visibility of all original types (class to extend and interfaces to implement) and of the Nashorn classes.
  private final ClassLoader commonLoader;

  // Is this a generator for the version of the class that can have overrides on the class level?
  private final boolean classOverride;

  // Binary name of the superClass
  private final String superClassName;

  // Binary name of the generated class.
  private final String generatedClassName;
  private final Set<String> abstractMethodNames = new HashSet<>();
  private final String samName;
  private final Set<MethodInfo> finalMethods = new HashSet<>(EXCLUDED);
  private final Set<MethodInfo> methodInfos = new HashSet<>();
  private final boolean autoConvertibleFromFunction;
  private boolean hasExplicitFinalizer = false;

  private final ClassWriter cw;

  /**
   * Creates a generator for the bytecode for the adapter for the specified superclass and interfaces.
   *
   * @param superClass the superclass the adapter will extend.
   * @param interfaces the interfaces the adapter will implement.
   * @param commonLoader the class loader that can see all of superClass, interfaces, and Nashorn classes.
   * @param classOverride true to generate the bytecode for the adapter that has class-level overrides, false to generate the bytecode for the adapter that has instance-level overrides.
   * @throws AdaptationException if the adapter can not be generated for some reason.
   */
  JavaAdapterBytecodeGenerator(Class<?> superClass, List<Class<?>> interfaces,       final ClassLoader commonLoader, boolean classOverride) throws AdaptationException {
    assert superClass != null && !superClass.isInterface();
    assert interfaces != null;
    this.superClass = superClass;
    this.interfaces = interfaces;
    this.classOverride = classOverride;
    this.commonLoader = commonLoader;
    cw = new ClassWriter() {
      @Override
      protected String getCommonSuperClass(String type1, String type2) {
        // We need to override ClassWriter.getCommonSuperClass to use this factory's commonLoader
        // as a class loader to find the common superclass of two types when needed.
        return JavaAdapterBytecodeGenerator.this.getCommonSuperClass(type1, type2);
      }
    };
    superClassName = Type.getInternalName(superClass);
    generatedClassName = getGeneratedClassName(superClass, interfaces);
    cw.visit(ACC_PUBLIC | ACC_SUPER, generatedClassName, null, superClassName, getInternalTypeNames(interfaces));
    generateField(GLOBAL_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    generateField(DELEGATE_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    gatherMethods(superClass);
    gatherMethods(interfaces);
    if (abstractMethodNames.size() == 1) {
      samName = abstractMethodNames.iterator().next();
      generateField(CALL_THIS_FIELD_NAME, OBJECT_TYPE_DESCRIPTOR);
      generateField(IS_FUNCTION_FIELD_NAME, BOOLEAN_TYPE_DESCRIPTOR);
    } else {
      samName = null;
    }
    if (classOverride) {
      generateClassInit();
    }
    autoConvertibleFromFunction = generateConstructors();
    generateMethods();
    generateSuperMethods();
    if (hasExplicitFinalizer) {
      generateFinalizerMethods();
    }
    cw.visitEnd();
  }

  void generateField(String name, String fieldDesc) {
    cw.visitField(ACC_PRIVATE | ACC_FINAL | (classOverride ? ACC_STATIC : 0), name, fieldDesc, null, null).visitEnd();
  }

  JavaAdapterClassLoader createAdapterClassLoader() {
    return new JavaAdapterClassLoader(generatedClassName, cw.toByteArray());
  }

  boolean isAutoConvertibleFromFunction() {
    return autoConvertibleFromFunction;
  }

  static String getGeneratedClassName(Class<?> superType, List<Class<?>> interfaces) {
    // The class we use to primarily name our adapter is either the superclass,
    // or if it is Object (meaning we're just implementing interfaces or extending Object),
    // then the first implemented interface or Object.
    var namingType = superType == Object.class ? (interfaces.isEmpty() ? Object.class : interfaces.get(0)) : superType;
    // var pkg = namingType.getPackage();
    var namingTypeName = Type.getInternalName(namingType);
    var buf = new StringBuilder();
    buf.append(ADAPTER_PACKAGE_INTERNAL).append(namingTypeName.replace('/', '_'));
    var it = interfaces.iterator();
    if (superType == Object.class && it.hasNext()) {
      it.next(); // Skip first interface, it was used to primarily name the adapter
    }
    // Append interface names to the adapter name
    while (it.hasNext()) {
      buf.append("$$").append(it.next().getSimpleName());
    }
    return buf.toString().substring(0, Math.min(MAX_GENERATED_TYPE_NAME_LENGTH, buf.length()));
  }

  /**
   * Given a list of class objects, return an array with their binary names.
   * Used to generate the array of interface names to implement.
   * @param classes the classes
   * @return an array of names
   */
  static String[] getInternalTypeNames(List<Class<?>> classes) {
    var interfaceCount = classes.size();
    var interfaceNames = new String[interfaceCount];
    for (var i = 0; i < interfaceCount; ++i) {
      interfaceNames[i] = Type.getInternalName(classes.get(i));
    }
    return interfaceNames;
  }

  void generateClassInit() {
    var mv = new InstructionAdapter(cw.visitMethod(ACC_STATIC, CLASS_INIT, VOID_METHOD_DESCRIPTOR, null, null));
    // Assign "global = Context.getGlobal()"
    GET_NON_NULL_GLOBAL.invoke(mv);
    mv.putstatic(generatedClassName, GLOBAL_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    GET_CLASS_OVERRIDES.invoke(mv);
    if (samName != null) {
      // If the class is a SAM, allow having ScriptFunction passed as class overrides
      mv.dup();
      mv.instanceOf(SCRIPT_FUNCTION_TYPE);
      mv.dup();
      mv.putstatic(generatedClassName, IS_FUNCTION_FIELD_NAME, BOOLEAN_TYPE_DESCRIPTOR);
      var  notFunction = new Label();
      mv.ifeq(notFunction);
      mv.dup();
      mv.checkcast(SCRIPT_FUNCTION_TYPE);
      emitInitCallThis(mv);
      mv.visitLabel(notFunction);
    }
    mv.putstatic(generatedClassName, DELEGATE_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    endInitMethod(mv);
  }

  /**
   * Emit bytecode for initializing the "callThis" field.
   */
  void emitInitCallThis(InstructionAdapter mv) {
    loadField(mv, GLOBAL_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    GET_CALL_THIS.invoke(mv);
    if (classOverride) {
      mv.putstatic(generatedClassName, CALL_THIS_FIELD_NAME, OBJECT_TYPE_DESCRIPTOR);
    } else {
      // It is presumed ALOAD 0 was already executed
      mv.putfield(generatedClassName, CALL_THIS_FIELD_NAME, OBJECT_TYPE_DESCRIPTOR);
    }
  }

  boolean generateConstructors() throws AdaptationException {
    var gotCtor = false;
    var canBeAutoConverted = false;
    for (var ctor : superClass.getDeclaredConstructors()) {
      var modifier = ctor.getModifiers();
      if ((modifier & (Modifier.PUBLIC | Modifier.PROTECTED)) != 0) {
        canBeAutoConverted = generateConstructors(ctor) | canBeAutoConverted;
        gotCtor = true;
      }
    }
    if (!gotCtor) {
      throw new AdaptationException(ERROR_NO_ACCESSIBLE_CONSTRUCTOR, superClass.getCanonicalName());
    }
    return canBeAutoConverted;
  }

  boolean generateConstructors(Constructor<?> ctor) {
    if (classOverride) {
      // Generate a constructor that just delegates to ctor.
      // This is used with class-level overrides, when we want to create instances without further per-instance overrides.
      generateDelegatingConstructor(ctor);
      return false;
    }
    // Generate a constructor that delegates to ctor,
    // but takes an additional ScriptObject parameter at the beginning of its parameter list.
    generateOverridingConstructor(ctor, false);
    if (samName == null) {
      return false;
    }
    // If all our abstract methods have a single name, generate an additional constructor,
    // one that takes a ScriptFunction as its first parameter and assigns it as the implementation for all abstract methods.
    generateOverridingConstructor(ctor, true);
    // If the original type only has a single abstract method name, as well as a default ctor, then it can
    // be automatically converted from JS function.
    return ctor.getParameterTypes().length == 0;
  }

  void generateDelegatingConstructor(Constructor<?> ctor) {
    var originalCtorType = Type.getType(ctor);
    var argTypes = originalCtorType.getArgumentTypes();
    // All constructors must be public, even if in the superclass they were protected.
    var mv = new InstructionAdapter(cw.visitMethod(ACC_PUBLIC | (ctor.isVarArgs() ? ACC_VARARGS : 0),
      INIT, Type.getMethodDescriptor(originalCtorType.getReturnType(), argTypes), null, null));
    mv.visitCode();
    emitSuperConstructorCall(mv, originalCtorType.getDescriptor());
    endInitMethod(mv);
  }

  /**
   * Generates a constructor for the instance adapter class.
   * This constructor will take the same arguments as the supertype constructor passed as the argument here, and delegate to it.
   * However, it will take an additional argument of either ScriptObject or ScriptFunction type (based on the value of the "fromFunction" parameter), and initialize all the method handle fields of the adapter instance with functions from the script object (or the script function itself, if that's what's passed).
   * Additionally, it will create another constructor with an additional Object type parameter that can be used for ScriptObjectMirror objects.
   * The constructor will also store the Nashorn global that was current at the constructor invocation time in a field named "global".
   * The generated constructor will be public, regardless of whether the supertype constructor was public or protected.
   * The generated constructor will not be variable arity, even if the supertype constructor was.
   * @param ctor the supertype constructor that is serving as the base for the generated constructor.
   * @param fromFunction true if we're generating a constructor that initializes SAM types from a single ScriptFunction passed to it, false if we're generating a constructor that initializes an arbitrary type from a ScriptObject passed to it.
   */
  void generateOverridingConstructor(Constructor<?> ctor, boolean fromFunction) {
    var originalCtorType = Type.getType(ctor);
    var originalArgTypes = originalCtorType.getArgumentTypes();
    var argLen = originalArgTypes.length;
    var newArgTypes = new Type[argLen + 1];
    // Insert ScriptFunction|ScriptObject as the last argument to the constructor
    var extraArgumentType = fromFunction ? SCRIPT_FUNCTION_TYPE : SCRIPT_OBJECT_TYPE;
    newArgTypes[argLen] = extraArgumentType;
    System.arraycopy(originalArgTypes, 0, newArgTypes, 0, argLen);
    // All constructors must be public, even if in the superclass they were protected.
    // Existing super constructor <init>(this, args...) triggers generating <init>(this, args..., delegate).
    // Any variable arity constructors become fixed-arity with explicit array arguments.
    var mv = new InstructionAdapter(cw.visitMethod(ACC_PUBLIC, INIT,
      Type.getMethodDescriptor(originalCtorType.getReturnType(), newArgTypes), null, null));
    mv.visitCode();
    // First, invoke super constructor with original arguments.
    var extraArgOffset = emitSuperConstructorCall(mv, originalCtorType.getDescriptor());
    // Assign "this.global = Context.getGlobal()"
    mv.visitVarInsn(ALOAD, 0);
    GET_NON_NULL_GLOBAL.invoke(mv);
    mv.putfield(generatedClassName, GLOBAL_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    // Assign "this.delegate = delegate"
    mv.visitVarInsn(ALOAD, 0);
    mv.visitVarInsn(ALOAD, extraArgOffset);
    mv.putfield(generatedClassName, DELEGATE_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    if (fromFunction) {
      // Assign "isFunction = true"
      mv.visitVarInsn(ALOAD, 0);
      mv.iconst(1);
      mv.putfield(generatedClassName, IS_FUNCTION_FIELD_NAME, BOOLEAN_TYPE_DESCRIPTOR);
      mv.visitVarInsn(ALOAD, 0);
      mv.visitVarInsn(ALOAD, extraArgOffset);
      emitInitCallThis(mv);
    }
    endInitMethod(mv);
    if (!fromFunction) {
      newArgTypes[argLen] = OBJECT_TYPE;
      var mv2 = new InstructionAdapter(cw.visitMethod(ACC_PUBLIC, INIT,
        Type.getMethodDescriptor(originalCtorType.getReturnType(), newArgTypes), null, null));
      generateOverridingConstructorWithObjectParam(mv2, originalCtorType.getDescriptor());
    }
  }

  // Object additional param accepting constructor for handling ScriptObjectMirror objects, which are unwrapped to work as ScriptObjects or ScriptFunctions.
  // This also handles null and undefined values for script adapters by throwing TypeError on such script adapters.
  void generateOverridingConstructorWithObjectParam(InstructionAdapter mv, String ctorDescriptor) {
    mv.visitCode();
    var extraArgOffset = emitSuperConstructorCall(mv, ctorDescriptor);
    // Check for ScriptObjectMirror
    mv.visitVarInsn(ALOAD, extraArgOffset);
    mv.instanceOf(SCRIPT_OBJECT_MIRROR_TYPE);
    var notMirror = new Label();
    mv.ifeq(notMirror);
    mv.visitVarInsn(ALOAD, 0);
    mv.visitVarInsn(ALOAD, extraArgOffset);
    mv.iconst(0);
    UNWRAP_MIRROR.invoke(mv);
    mv.putfield(generatedClassName, DELEGATE_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    mv.visitVarInsn(ALOAD, 0);
    mv.visitVarInsn(ALOAD, extraArgOffset);
    mv.iconst(1);
    UNWRAP_MIRROR.invoke(mv);
    mv.putfield(generatedClassName, GLOBAL_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    var done = new Label();
    if (samName != null) {
      mv.visitVarInsn(ALOAD, 0);
      mv.getfield(generatedClassName, DELEGATE_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
      mv.instanceOf(SCRIPT_FUNCTION_TYPE);
      mv.ifeq(done);
      // Assign "isFunction = true"
      mv.visitVarInsn(ALOAD, 0);
      mv.iconst(1);
      mv.putfield(generatedClassName, IS_FUNCTION_FIELD_NAME, BOOLEAN_TYPE_DESCRIPTOR);
      mv.visitVarInsn(ALOAD, 0);
      mv.dup();
      mv.getfield(generatedClassName, DELEGATE_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
      mv.checkcast(SCRIPT_FUNCTION_TYPE);
      emitInitCallThis(mv);
      mv.goTo(done);
    }
    mv.visitLabel(notMirror);
    // Throw error if not a ScriptObject
    mv.visitVarInsn(ALOAD, extraArgOffset);
    NOT_AN_OBJECT.invoke(mv);
    mv.visitLabel(done);
    endInitMethod(mv);
  }

  static void endInitMethod(InstructionAdapter mv) {
    mv.visitInsn(RETURN);
    endMethod(mv);
  }

  static void endMethod(InstructionAdapter mv) {
    mv.visitMaxs(0, 0);
    mv.visitEnd();
  }

  /**
   * Encapsulation of the information used to generate methods in the adapter classes.
   * Basically, a wrapper around the reflective Method object, a cached MethodType, and the name of the field in the adapter class that will hold the method handle serving as the implementation of this method in adapter instances.
   */
  static class MethodInfo {

    private final Method method;
    private final MethodType type;

    MethodInfo(Class<?> cl, String name, Class<?>... argTypes) throws NoSuchMethodException {
      this(cl.getDeclaredMethod(name, argTypes));
    }

    MethodInfo(Method method) {
      this.method = method;
      this.type = MH.type(method.getReturnType(), method.getParameterTypes());
    }

    @Override
    public boolean equals(Object obj) {
      return obj instanceof MethodInfo mi && equals(mi);
    }

    private boolean equals(MethodInfo other) {
      // Only method name and type are used for comparison; method handle field name is not.
      return getName().equals(other.getName()) && type.equals(other.type);
    }

    String getName() {
      return method.getName();
    }

    @Override
    public int hashCode() {
      return getName().hashCode() ^ type.hashCode();
    }
  }

  void generateMethods() {
    for (var mi : methodInfos) {
      generateMethod(mi);
    }
  }

  /**
   * Generates a method in the adapter class that adapts a method from the original class.
   * The generated method will either invoke the delegate using a CALL dynamic operation call site (if it is a SAM method and the delegate is a ScriptFunction), or invoke GET_METHOD_PROPERTY dynamic operation with the method name as the argument and then invoke the returned ScriptFunction using the CALL dynamic operation.
   * If GET_METHOD_PROPERTY returns null or undefined (that is, the JS object doesn't provide an implementation for the method) then the method will either do a super invocation to base class, or if the method is abstract, throw an {@link UnsupportedOperationException}.
   * Finally, if GET_METHOD_PROPERTY returns something other than a ScriptFunction, null, or undefined, a TypeError is thrown.
   * The current Global is checked before the dynamic operations, and if it is different than the Global used to create the adapter, the creating Global is set to be the current Global.
   * In this case, the previously current Global is restored after the invocation.
   * If CALL results in a Throwable that is not one of the method's declared exceptions, and is not an unchecked throwable, then it is wrapped into a {@link RuntimeException} and the runtime exception is thrown.
   * @param mi the method info describing the method to be generated.
   */
  void generateMethod(MethodInfo mi) {
    var method = mi.method;
    var exceptions = method.getExceptionTypes();
    var exceptionNames = getExceptionNames(exceptions);
    var type = mi.type;
    var methodDesc = type.toMethodDescriptorString();
    var name = mi.getName();
    var asmType = Type.getMethodType(methodDesc);
    var asmArgTypes = asmType.getArgumentTypes();
    var mv = new InstructionAdapter(cw.visitMethod(getAccessModifiers(method), name, methodDesc, null, exceptionNames));
    mv.visitCode();
    var returnType = type.returnType();
    var asmReturnType = Type.getType(returnType);
    // Determine the first index for a local variable
    var nextLocalVar = 1; // "this" is at 0
    for (var t : asmArgTypes) {
      nextLocalVar += t.getSize();
    }
    // Set our local variable index
    var globalRestoringRunnableVar = nextLocalVar++;
    // Load the creatingGlobal object
    loadField(mv, GLOBAL_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    // stack: [creatingGlobal]
    SET_GLOBAL.invoke(mv);
    // stack: [runnable]
    mv.visitVarInsn(ASTORE, globalRestoringRunnableVar);
    // stack: []
    var tryBlockStart = new Label();
    mv.visitLabel(tryBlockStart);
    var callCallee = new Label();
    var defaultBehavior = new Label();
    // If this is a SAM type...
    if (samName != null) {
      // ...every method will be checking whether we're initialized with a function.
      loadField(mv, IS_FUNCTION_FIELD_NAME, BOOLEAN_TYPE_DESCRIPTOR);
      // stack: [isFunction]
      if (name.equals(samName)) {
        var notFunction = new Label();
        mv.ifeq(notFunction);
        // stack: []
        // If it's a SAM method, it'll load delegate as the "callee" and "callThis" as "this" for the call if delegate is a function.
        loadField(mv, DELEGATE_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
        // NOTE: if we added "mv.checkcast(SCRIPT_FUNCTION_TYPE);" here we could emit the invokedynamic CALL instruction with signature (ScriptFunction, Object, ...) instead of (Object, Object, ...).
        // We could combine this with an optimization in ScriptFunction.findCallMethod where it could link a call with a thinner guard when the call site statically guarantees that the callee argument is a ScriptFunction.
        // Additionally, we could use a "ScriptFunction function" field in generated classes instead of a "boolean isFunction" field to avoid the checkcast.
        loadField(mv, CALL_THIS_FIELD_NAME, OBJECT_TYPE_DESCRIPTOR);
        // stack: [callThis, delegate]
        mv.goTo(callCallee);
        mv.visitLabel(notFunction);
      } else {
        // If it's not a SAM method, and the delegate is a function, it'll fall back to default behavior
        mv.ifne(defaultBehavior);
        // stack: []
      }
    }

    // At this point, this is either not a SAM method or the delegate is not a ScriptFunction.
    // We need to emit a GET_METHOD_PROPERTY Nashorn invokedynamic.
    if (name.equals("toString")) {
      // Since every JS Object has a toString, we only override "String toString()" it if it's explicitly specified on the object.
      loadField(mv, DELEGATE_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
      // stack: [delegate]
      HAS_OWN_TO_STRING.invoke(mv);
      // stack: [hasOwnToString]
      mv.ifeq(defaultBehavior);
    }

    loadField(mv, DELEGATE_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    // For the cases like scripted overridden methods invoked from super constructors get adapter global/delegate fields as null, since we cannot set these fields before invoking super constructor better solution is opt out of scripted overridden method if global/delegate fields are null and invoke super method instead
    mv.ifnull(defaultBehavior);
    loadField(mv, DELEGATE_FIELD_NAME, SCRIPT_OBJECT_TYPE_DESCRIPTOR);
    mv.dup();
    // stack: [delegate, delegate]
    final String encodedName = NameCodec.encode(name);
    mv.visitInvokeDynamicInsn(encodedName, GET_METHOD_PROPERTY_METHOD_DESCRIPTOR, BOOTSTRAP_HANDLE, NashornCallSiteDescriptor.GET_METHOD_PROPERTY);
    // stack: [callee, delegate]
    mv.visitLdcInsn(name);
    // stack: [name, callee, delegate]
    CHECK_FUNCTION.invoke(mv);
    // stack: [fnCalleeOrNull, delegate]
    var hasFunction = new Label();
    mv.dup();
    // stack: [fnCalleeOrNull, fnCalleeOrNull, delegate]
    mv.ifnonnull(hasFunction);
    // stack: [null, delegate]
    // If it's null or undefined, clear stack and fall back to default behavior.
    mv.pop2();
    // stack: []
    // We can also arrive here from check for "delegate instanceof ScriptFunction" in a non-SAM method as well as from a check for "hasOwnToString(delegate)" for a toString delegate.
    mv.visitLabel(defaultBehavior);
    Runnable emitFinally = () -> emitFinally(mv, globalRestoringRunnableVar);
    var normalFinally = new Label();
    if (Modifier.isAbstract(method.getModifiers())) {
      // If the super method is abstract, throw UnsupportedOperationException
      UNSUPPORTED.invoke(mv);
      // NOTE: no need to invoke emitFinally.run() as we're inside the tryBlockStart/tryBlockEnd range, so throwing this exception will transfer control to the rethrow handler and the finally block in it will execute.
      mv.athrow();
    } else {
      // If the super method is not abstract, delegate to it.
      emitSuperCall(mv, method.getDeclaringClass(), name, methodDesc);
      mv.goTo(normalFinally);
    }
    mv.visitLabel(hasFunction);
    // stack: [callee, delegate]
    mv.swap();
    // stack [delegate, callee]
    mv.visitLabel(callCallee);
    // Load all parameters back on stack for dynamic invocation.
    var varOffset = 1;
    // If the param list length is more than 253 slots, we can't invoke it directly as with (callee, this) it'll exceed 255.
    var isVarArgCall = getParamListLengthInSlots(asmArgTypes) > 253;
    for (var t : asmArgTypes) {
      mv.load(varOffset, t);
      convertParam(mv, t, isVarArgCall);
      varOffset += t.getSize();
    }
    // stack: [args..., callee, delegate]
    // If the resulting parameter list length is too long...
    if (isVarArgCall) {
      // ... we pack the parameters (except callee and this) into an array and use Nashorn vararg invocation.
      mv.visitInvokeDynamicInsn(NameCodec.EMPTY_NAME, getArrayCreatorMethodType(type).toMethodDescriptorString(), CREATE_ARRAY_BOOTSTRAP_HANDLE);
    }
    // Invoke the target method handle
    mv.visitInvokeDynamicInsn(encodedName, getCallMethodType(isVarArgCall, type).toMethodDescriptorString(), BOOTSTRAP_HANDLE, NashornCallSiteDescriptor.CALL);
    // stack: [returnValue]
    convertReturnValue(mv, returnType);
    mv.visitLabel(normalFinally);
    emitFinally.run();
    mv.areturn(asmReturnType);
    // If Throwable is not declared, we need an adapter from Throwable to RuntimeException
    var throwableDeclared = isThrowableDeclared(exceptions);
    Label throwableHandler;
    if (!throwableDeclared) {
      // Add "throw new RuntimeException(Throwable)" handler for Throwable
      throwableHandler = new Label();
      mv.visitLabel(throwableHandler);
      WRAP_THROWABLE.invoke(mv);
      // Fall through to rethrow handler
    } else {
      throwableHandler = null;
    }
    var rethrowHandler = new Label();
    mv.visitLabel(rethrowHandler);
    // Rethrow handler for RuntimeException, Error, and all declared exception types
    emitFinally.run();
    mv.athrow();
    if (throwableDeclared) {
      mv.visitTryCatchBlock(tryBlockStart, normalFinally, rethrowHandler, THROWABLE_TYPE_NAME);
      assert throwableHandler == null;
    } else {
      mv.visitTryCatchBlock(tryBlockStart, normalFinally, rethrowHandler, RUNTIME_EXCEPTION_TYPE_NAME);
      mv.visitTryCatchBlock(tryBlockStart, normalFinally, rethrowHandler, ERROR_TYPE_NAME);
      for (var excName : exceptionNames) {
        mv.visitTryCatchBlock(tryBlockStart, normalFinally, rethrowHandler, excName);
      }
      mv.visitTryCatchBlock(tryBlockStart, normalFinally, throwableHandler, THROWABLE_TYPE_NAME);
    }
    endMethod(mv);
  }

  static MethodType getCallMethodType(boolean isVarArgCall, MethodType type) {
    Class<?>[] callParamTypes;
    if (isVarArgCall) {
      // Variable arity calls are always (Object callee, Object this, Object[] params)
      callParamTypes = new Class<?>[]{Object.class, Object.class, Object[].class};
    } else {
      // Adjust invocation type signature for conversions we instituted in convertParam; also, byte and short get passed as ints.
      var origParamTypes = type.parameterArray();
      callParamTypes = new Class<?>[origParamTypes.length + 2];
      callParamTypes[0] = Object.class; // callee; could be ScriptFunction.class ostensibly
      callParamTypes[1] = Object.class; // this
      for (var i = 0; i < origParamTypes.length; ++i) {
        callParamTypes[i + 2] = getNashornParamType(origParamTypes[i], false);
      }
    }
    return MethodType.methodType(getNashornReturnType(type.returnType()), callParamTypes);
  }

  static MethodType getArrayCreatorMethodType(MethodType type) {
    var callParamTypes = type.parameterArray();
    for (var i = 0; i < callParamTypes.length; ++i) {
      callParamTypes[i] = getNashornParamType(callParamTypes[i], true);
    }
    return MethodType.methodType(Object[].class, callParamTypes);
  }

  static Class<?> getNashornParamType(Class<?> cl, boolean varArg) {
    if (cl == byte.class || cl == short.class) {
      return int.class;
    } else if (cl == float.class) {
      // If using variable arity, we'll pass a Double instead of double so that floats don't extend the length of the parameter list.
      // We return Object.class instead of Double.class though as the array collector will anyway operate on Object.
      return varArg ? Object.class : double.class;
    } else if (!cl.isPrimitive() || cl == long.class || cl == char.class) {
      return Object.class;
    }
    return cl;
  }

  static Class<?> getNashornReturnType(Class<?> cl) {
    if (cl == byte.class || cl == short.class) {
      return int.class;
    } else if (cl == float.class) {
      return double.class;
    } else if (cl == void.class || cl == char.class) {
      return Object.class;
    }
    return cl;
  }

  void loadField(InstructionAdapter mv, String name, String desc) {
    if (classOverride) {
      mv.getstatic(generatedClassName, name, desc);
    } else {
      mv.visitVarInsn(ALOAD, 0);
      mv.getfield(generatedClassName, name, desc);
    }
  }

  static void convertReturnValue(InstructionAdapter mv, Class<?> origReturnType) {
    if (origReturnType == void.class) {
      mv.pop();
    } else if (origReturnType == Object.class) {
      // Must hide ConsString (and potentially other internal Nashorn types) from callers
      EXPORT_RETURN_VALUE.invoke(mv);
    } else if (origReturnType == byte.class) {
      mv.visitInsn(I2B);
    } else if (origReturnType == short.class) {
      mv.visitInsn(I2S);
    } else if (origReturnType == float.class) {
      mv.visitInsn(D2F);
    } else if (origReturnType == char.class) {
      TO_CHAR_PRIMITIVE.invoke(mv);
    }
  }

  /**
   * Emits instruction for converting a parameter on the top of the stack to a type that is understood by Nashorn.
   * @param mv the current method visitor
   * @param t the type on the top of the stack
   * @param varArg if the invocation will be variable arity
   */
  static void convertParam(InstructionAdapter mv, Type t, boolean varArg) {
    // We perform conversions of some primitives to accommodate types that Nashorn can handle.
    switch (t.getSort()) {
      case Type.CHAR -> {
        // Chars are boxed, as we don't know if the JS code wants to treat them as an effective "unsigned short" or as a single-char string.
        CHAR_VALUE_OF.invoke(mv);
      }
      case Type.FLOAT -> {
        // Floats are widened to double.
        mv.visitInsn(Opcodes.F2D);
        if (varArg) {
          // We'll be boxing everything anyway for the vararg invocation, so we might as well do it proactively here and thus not cause a widening in the number of slots, as that could even make the array creation invocation go over 255 param slots.
          DOUBLE_VALUE_OF.invoke(mv);
        }
      }
      case Type.LONG -> {
        // Longs are boxed as Nashorn can't represent them precisely as a primitive number.
        LONG_VALUE_OF.invoke(mv);
      }
      case Type.OBJECT -> {
        if (t.equals(OBJECT_TYPE)) {
          // Object can carry a ScriptObjectMirror and needs to be unwrapped before passing into a Nashorn function.
          UNWRAP.invoke(mv);
        }
      }
    }
  }

  static int getParamListLengthInSlots(Type[] paramTypes) {
    var len = paramTypes.length;
    for (var t : paramTypes) {
      var sort = t.getSort();
      if (sort == Type.FLOAT || sort == Type.DOUBLE) {
        // Floats are widened to double, so they'll take up two slots.
        // Longs on the other hand are always boxed, so their width becomes 1 and thus they don't contribute an extra slot here.
        ++len;
      }
    }
    return len;
  }

  /**
   * Emit code to restore the previous Nashorn Context when needed.
   * @param mv the instruction adapter
   * @param globalRestoringRunnableVar index of the local variable holding the reference to the global restoring Runnable
   */
  static void emitFinally(InstructionAdapter mv, int globalRestoringRunnableVar) {
    mv.visitVarInsn(ALOAD, globalRestoringRunnableVar);
    RUN.invoke(mv);
  }

  static boolean isThrowableDeclared(Class<?>[] exceptions) {
    for (var exception : exceptions) {
      if (exception == Throwable.class) {
        return true;
      }
    }
    return false;
  }

  void generateSuperMethods() {
    for (var mi : methodInfos) {
      if (!Modifier.isAbstract(mi.method.getModifiers())) {
        generateSuperMethod(mi);
      }
    }
  }

  void generateSuperMethod(MethodInfo mi) {
    var method = mi.method;
    var methodDesc = mi.type.toMethodDescriptorString();
    var name = mi.getName();
    var mv = new InstructionAdapter(cw.visitMethod(getAccessModifiers(method), SUPER_PREFIX + name, methodDesc, null, getExceptionNames(method.getExceptionTypes())));
    mv.visitCode();
    emitSuperCall(mv, method.getDeclaringClass(), name, methodDesc);
    mv.areturn(Type.getType(mi.type.returnType()));
    endMethod(mv);
  }

  // find the appropriate super type to use for invokespecial on the given interface
  Class<?> findInvokespecialOwnerFor(Class<?> cl) {
    assert Modifier.isInterface(cl.getModifiers()) : cl + " is not an interface";
    if (cl.isAssignableFrom(superClass)) {
      return superClass;
    }
    for (var iface : interfaces) {
      if (cl.isAssignableFrom(iface)) {
        return iface;
      }
    }
    // we better that interface that extends the given interface!
    throw new AssertionError("can't find the class/interface that extends " + cl);
  }

  int emitSuperConstructorCall(InstructionAdapter mv, String methodDesc) {
    return emitSuperCall(mv, null, INIT, methodDesc, true);
  }

  int emitSuperCall(InstructionAdapter mv, Class<?> owner, String name, String methodDesc) {
    return emitSuperCall(mv, owner, name, methodDesc, false);
  }

  int emitSuperCall(InstructionAdapter mv, Class<?> owner, String name, String methodDesc, boolean constructor) {
    mv.visitVarInsn(ALOAD, 0);
    var nextParam = 1;
    var methodType = Type.getMethodType(methodDesc);
    for (var t : methodType.getArgumentTypes()) {
      mv.load(nextParam, t);
      nextParam += t.getSize();
    }
    // default method - non-abstract, interface method
    if (!constructor && Modifier.isInterface(owner.getModifiers())) {
      // we should call default method on the immediate "super" type - not on (possibly) the indirectly inherited interface class!
      var superType = findInvokespecialOwnerFor(owner);
      mv.visitMethodInsn(INVOKESPECIAL, Type.getInternalName(superType), name, methodDesc, Modifier.isInterface(superType.getModifiers()));
    } else {
      mv.invokespecial(superClassName, name, methodDesc, false);
    }
    return nextParam;
  }

  void generateFinalizerMethods() {
    generateFinalizerDelegate();
    generateFinalizerOverride();
  }

  void generateFinalizerDelegate() {
    // Generate a delegate that will be invoked from the no-permission trampoline.
    // Note it can be private, as we'll refer to it with a MethodHandle constant pool entry in the overridden finalize() method (see generateFinalizerOverride()).
    var mv = new InstructionAdapter(cw.visitMethod(ACC_PRIVATE | ACC_STATIC, FINALIZER_DELEGATE_NAME, FINALIZER_DELEGATE_METHOD_DESCRIPTOR, null, null));
    // Simply invoke super.finalize()
    mv.visitVarInsn(ALOAD, 0);
    mv.checkcast(Type.getType('L' + generatedClassName + ';'));
    mv.invokespecial(superClassName, "finalize", VOID_METHOD_DESCRIPTOR, false);
    mv.visitInsn(RETURN);
    endMethod(mv);
  }

  void generateFinalizerOverride() {
    var mv = new InstructionAdapter(cw.visitMethod(ACC_PUBLIC, "finalize", VOID_METHOD_DESCRIPTOR, null, null));
    // Overridden finalizer will take a MethodHandle to the finalizer delegating method, ...
    mv.aconst(new Handle(Opcodes.H_INVOKESTATIC, generatedClassName, FINALIZER_DELEGATE_NAME, FINALIZER_DELEGATE_METHOD_DESCRIPTOR, false));
    mv.visitVarInsn(ALOAD, 0);
    // ...and invoke it through JavaAdapterServices.invokeNoPermissions
    INVOKE_NO_PERMISSIONS.invoke(mv);
    mv.visitInsn(RETURN);
    endMethod(mv);
  }

  static String[] getExceptionNames(Class<?>[] exceptions) {
    var exceptionNames = new String[exceptions.length];
    for (var i = 0; i < exceptions.length; ++i) {
      exceptionNames[i] = Type.getInternalName(exceptions[i]);
    }
    return exceptionNames;
  }

  static int getAccessModifiers(Method method) {
    return ACC_PUBLIC | (method.isVarArgs() ? ACC_VARARGS : 0);
  }

  /**
   * Gathers methods that can be implemented or overridden from the specified cl into this factory's {@link #methodInfos} set.
   * It will add all non-final, non-static methods that are either public or protected from the type if the type itself is public.
   * If the type is a class, the method will recursively invoke itself for its superclass and the interfaces it implements, and add further methods that were not directly declared on the class.
   * @param cl the cl defining the methods.
   */
  void gatherMethods(Class<?> cl) throws AdaptationException {
    if (Modifier.isPublic(cl.getModifiers())) {
      var typeMethods = cl.isInterface() ? cl.getMethods() : cl.getDeclaredMethods();
      for (var typeMethod : typeMethods) {
        var name = typeMethod.getName();
        if (name.startsWith(SUPER_PREFIX)) {
          continue;
        }
        var m = typeMethod.getModifiers();
        if (Modifier.isStatic(m)) {
          continue;
        }
        if (Modifier.isPublic(m) || Modifier.isProtected(m)) {
          // Is it a "finalize()"?
          if (name.equals("finalize") && typeMethod.getParameterCount() == 0) {
            if (cl != Object.class) {
              hasExplicitFinalizer = true;
              if (Modifier.isFinal(m)) {
                // Must be able to override an explicit finalizer
                throw new AdaptationException(Outcome.ERROR_FINAL_FINALIZER, cl.getCanonicalName());
              }
            }
            continue;
          }
          var mi = new MethodInfo(typeMethod);
          if (Modifier.isFinal(m)) {
            finalMethods.add(mi);
          } else if (!finalMethods.contains(mi) && methodInfos.add(mi) && Modifier.isAbstract(m)) {
            abstractMethodNames.add(mi.getName());
          }
        }
      }
    }
    // If the cl is a class, visit its superclasses and declared interfaces.
    // If it's an interface, we're done.
    // Needing to invoke the method recursively for a non-interface Class object is the consequence of needing to see all declared protected methods, and Class.getDeclaredMethods() doesn't provide those declared in a superclass.
    // For interfaces, we used Class.getMethods(), as we're only interested in public ones there, and getMethods() does provide those declared in a superinterface.
    if (!cl.isInterface()) {
      var superType = cl.getSuperclass();
      if (superType != null) {
        gatherMethods(superType);
      }
      for (var itf : cl.getInterfaces()) {
        gatherMethods(itf);
      }
    }
  }

  void gatherMethods(List<Class<?>> classes) throws AdaptationException {
    for (var c : classes) {
      gatherMethods(c);
    }
  }

  /**
   * Creates a collection of methods that are not final, but we still never allow them to be overridden in adapters, as explicitly declaring them automatically is a bad idea.
   * Currently, this means {@code Object.finalize()} and {@code Object.clone()}.
   * @return a collection of method infos representing those methods that we never override in adapter classes.
   */
  static Collection<MethodInfo> getExcludedMethods() {
    try {
      return List.of(
        new MethodInfo(Object.class, "finalize"),
        new MethodInfo(Object.class, "clone"));
    } catch (NoSuchMethodException e) {
      throw new AssertionError(e);
    }
  }

  String getCommonSuperClass(String type1, String type2) {
    try {
      var c1 = Class.forName(type1.replace('/', '.'), false, commonLoader);
      var c2 = Class.forName(type2.replace('/', '.'), false, commonLoader);
      if (c1.isAssignableFrom(c2)) {
        return type1;
      }
      if (c2.isAssignableFrom(c1)) {
        return type2;
      }
      if (c1.isInterface() || c2.isInterface()) {
        return OBJECT_TYPE.getInternalName();
      }
      return assignableSuperClass(c1, c2).getName().replace('.', '/');
    } catch (ClassNotFoundException e) {
      throw new RuntimeException(e);
    }
  }

  static Class<?> assignableSuperClass(Class<?> c1, Class<?> c2) {
    var superClass = c1.getSuperclass();
    return superClass.isAssignableFrom(c2) ? superClass : assignableSuperClass(superClass, c2);
  }

  static Call lookupServiceMethod(String name, Class<?> rtype, Class<?>... ptypes) {
    return staticCallNoLookup(JavaAdapterServices.class, name, rtype, ptypes);
  }

}
