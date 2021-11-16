package es.codegen;

import java.util.Collections;
import java.util.EnumSet;
import java.util.HashSet;
import java.util.Set;

import es.codegen.asm.ClassWriter;
import es.codegen.asm.MethodVisitor;
import static es.codegen.asm.Opcodes.*;

import es.codegen.types.Type;
import es.ir.FunctionNode;
import es.runtime.Context;
import es.runtime.PropertyMap;
import es.runtime.RewriteException;
import es.runtime.ScriptObject;
import es.runtime.Source;
import static es.codegen.CompilerConstants.*;

/**
 * The interface responsible for speaking to ASM, emitting classes, fields and methods.
 * <p>
 * This file contains the ClassEmitter, which is the master object responsible for writing byte codes.
 * It utilizes a MethodEmitter for method generation, which also the NodeVisitors own, to keep track of the current code generator and what it is doing.
 * <p>
 * There is, however, nothing stopping you from using this in a completely self contained environment, for example in ObjectGenerator where there are no visitors or external hooks.
 * <p>
 * MethodEmitter makes it simple to generate code for methods without having to do arduous type checking.
 * It maintains a type stack and will pick the appropriate operation for all operations sent to it.
 * We also allow chained called to a MethodEmitter for brevity, e.g. it is legal to write new_(className).dup() or load(slot).load(slot2).xor().store(slot3);
 * <p>
 * If running with assertions enabled, any type conflict, such as different bytecode stack sizes or operating on the wrong type will be detected and an error thrown.
 * <p>
 * There is also a very nice debug interface that can emit formatted bytecodes that have been written.
 * This is enabled by setting the environment "nashorn.codegen.debug" to true, or --log=codegen:{@literal <level>}
 *
 * @see Compiler
 */
public class ClassEmitter {

  // Default flags for class generation - public class
  private static final EnumSet<Flag> DEFAULT_METHOD_FLAGS = EnumSet.of(Flag.PUBLIC);

  // Sanity check flag - have we started on a class?
  private boolean classStarted;

  // Sanity check flag - have we ended this emission?
  private boolean classEnded;

  // Sanity checks - which methods have we currently started for generation in this class?
  private final HashSet<MethodEmitter> methodsStarted;

  // The ASM classwriter that we use for all bytecode operations
  protected final ClassWriter cw;

  // The script environment
  protected final Context context;

  // Compile unit class name.
  private String unitClassName;

  // Set of constants access methods required.
  private Set<Class<?>> constantMethodNeeded;

  private int methodCount;

  private int initCount;

  private int clinitCount;

  private int fieldCount;

  private final Set<String> methodNames;

  /**
   * Constructor - only used internally in this class as it breaks abstraction towards ASM or other code generator below.
   * @param env script environment
   * @param cw  ASM classwriter
   */
  ClassEmitter(Context context, ClassWriter cw) {
    this.context = context;
    this.cw = cw;
    this.methodsStarted = new HashSet<>();
    this.methodNames = new HashSet<>();
  }

  /**
   * Return the method names encountered.
   * @return method names
   */
  public Set<String> getMethodNames() {
    return Collections.unmodifiableSet(methodNames);
  }

  /**
   * Constructor.
   * @param env             script environment
   * @param className       name of class to weave
   * @param superClassName  super class name for class
   * @param interfaceNames  names of interfaces implemented by this class, or
   *        {@code null} if none
   */
  ClassEmitter(Context context, String className, String superClassName, String... interfaceNames) {
    this(context, new ClassWriter());
    cw.visit(ACC_PUBLIC | ACC_SUPER, className, null, superClassName, interfaceNames);
  }

  /**
   * Constructor from the compiler.
   * @param env           Script environment
   * @param sourceName    Source name
   * @param unitClassName Compile unit class name.
   */
  ClassEmitter(String sourceName, String unitClassName, Context context) {
    this(context, new ClassWriter() {
      private static final String OBJECT_CLASS = "java/lang/Object";
      @Override
      protected String getCommonSuperClass(String type1, String type2) {
        try {
          return super.getCommonSuperClass(type1, type2);
        } catch (RuntimeException e) {
          if (isScriptObject(Compiler.SCRIPTS_PACKAGE, type1) && isScriptObject(Compiler.SCRIPTS_PACKAGE, type2)) {
            return className(ScriptObject.class);
          }
          return OBJECT_CLASS;
        }
      }
    });
    this.unitClassName = unitClassName;
    this.constantMethodNeeded = new HashSet<>();
    cw.visit(ACC_PUBLIC | ACC_SUPER, unitClassName, null, pathName(es.scripts.JS.class.getName()), null);
    cw.visitSource(sourceName, null);
    defineCommonStatics();
  }

  Context getContext() {
    return context;
  }

  /**
   * @return the name of the compile unit class name.
   */
  String getUnitClassName() {
    return unitClassName;
  }

  /**
   * Get the method count, including init and clinit methods.
   * @return method count
   */
  public int getMethodCount() {
    return methodCount;
  }

  /**
   * Get the clinit count.
   * @return clinit count
   */
  public int getClinitCount() {
    return clinitCount;
  }

  /**
   * Get the init count.
   * @return init count
   */
  public int getInitCount() {
    return initCount;
  }

  /**
   * Get the field count.
   * @return field count
   */
  public int getFieldCount() {
    return fieldCount;
  }

  /**
   * Convert a binary name to a package/class name.
   * @param name Binary name.
   * @return Package/class name.
   */
  static String pathName(String name) {
    return name.replace('.', '/');
  }

  /**
   * Define the static fields common in all scripts.
   */
  void defineCommonStatics() {
    // source - used to store the source data (text) for this script.
    // Shared across compile units.  Set externally by the compiler.
    field(EnumSet.of(Flag.PRIVATE, Flag.STATIC), SOURCE.symbolName(), Source.class);
    // constants - used to the constants array for this script.
    // Shared across compile units.  Set externally by the compiler.
    field(EnumSet.of(Flag.PRIVATE, Flag.STATIC), CONSTANTS.symbolName(), Object[].class);
  }

  /**
   * Define static utilities common needed in scripts.
   * These are per compile unit and therefore have to be defined here and not in code gen.
   */
  void defineCommonUtilities() {
    assert unitClassName != null;
    if (constantMethodNeeded.contains(String.class)) {
      // $getString - get the ith entry from the constants table and cast to String.
      var getStringMethod = method(EnumSet.of(Flag.PRIVATE, Flag.STATIC), GET_STRING.symbolName(), String.class, int.class);
      getStringMethod.begin();
      getStringMethod.getStatic(unitClassName, CONSTANTS.symbolName(), CONSTANTS.descriptor())
        .load(Type.INT, 0)
        .arrayload()
        .checkcast(String.class)
        .return_();
      getStringMethod.end();
    }

    if (constantMethodNeeded.contains(PropertyMap.class)) {
      // $getMap - get the ith entry from the constants table and cast to PropertyMap.
      var getMapMethod = method(EnumSet.of(Flag.PUBLIC, Flag.STATIC), GET_MAP.symbolName(), PropertyMap.class, int.class);
      getMapMethod.begin();
      getMapMethod.loadConstants()
        .load(Type.INT, 0)
        .arrayload()
        .checkcast(PropertyMap.class)
        .return_();
      getMapMethod.end();
      // $setMap - overwrite an existing map.
      var setMapMethod = method(EnumSet.of(Flag.PUBLIC, Flag.STATIC), SET_MAP.symbolName(), void.class, int.class, PropertyMap.class);
      setMapMethod.begin();
      setMapMethod.loadConstants()
        .load(Type.INT, 0)
        .load(Type.OBJECT, 1)
        .arraystore();
      setMapMethod.returnVoid();
      setMapMethod.end();
    }
    // $getXXXX$array - get the ith entry from the constants table and cast to XXXX[].
    for (var type : constantMethodNeeded) {
      if (type.isArray()) {
        defineGetArrayMethod(type);
      }
    }
  }

  /**
   * Constructs a primitive specific method for getting the ith entry from the constants table as an array.
   * @param type Array class.
   */
  void defineGetArrayMethod(Class<?> type) {
    assert unitClassName != null;
    var methodName = getArrayMethodName(type);
    var getArrayMethod = method(EnumSet.of(Flag.PRIVATE, Flag.STATIC), methodName, type, int.class);
    getArrayMethod.begin();
    getArrayMethod.getStatic(unitClassName, CONSTANTS.symbolName(), CONSTANTS.descriptor())
      .load(Type.INT, 0)
      .arrayload()
      .checkcast(type)
      .invoke(virtualCallNoLookup(type, "clone", Object.class))
      .checkcast(type)
      .return_();
    getArrayMethod.end();
  }

  /**
   * Generate the name of a get array from constant pool method.
   * @param type Name of array class.
   * @return Method name.
   */
  static String getArrayMethodName(Class<?> type) {
    assert type.isArray();
    return GET_ARRAY_PREFIX.symbolName() + type.getComponentType().getSimpleName() + GET_ARRAY_SUFFIX.symbolName();
  }

  /**
   * Ensure a get constant method is issued for the class.
   * @param type Class of constant.
   */
  void needGetConstantMethod(Class<?> type) {
    constantMethodNeeded.add(type);
  }

  /**
   * Inspect class name and decide whether we are generating a ScriptObject class.
   * @param scriptPrefix the script class prefix for the current script
   * @param type         the type to check
   * @return {@code true} if type is ScriptObject
   */
  static boolean isScriptObject(String scriptPrefix, String type) {
    return type.startsWith(scriptPrefix) || type.equals(CompilerConstants.className(ScriptObject.class)) ||type.startsWith(Compiler.OBJECTS_PACKAGE);
  }

  /**
   * Call at beginning of class emission.
   */
  public void begin() {
    classStarted = true;
  }

  /**
   * Call at end of class emission.
   */
  public void end() {
    assert classStarted : "class not started for " + unitClassName;
    if (unitClassName != null) {
      var initMethod = init(EnumSet.of(Flag.PRIVATE));
      initMethod.begin();
      initMethod.load(Type.OBJECT, 0);
      initMethod.newInstance(es.scripts.JS.class);
      initMethod.returnVoid();
      initMethod.end();
      defineCommonUtilities();
    }
    cw.visitEnd();
    classStarted = false;
    classEnded = true;
    assert methodsStarted.isEmpty() : "methodsStarted not empty " + methodsStarted;
  }

  // static String disassemble(byte[] bytecode)

  /**
   * Call back from MethodEmitter for method start.
   * @see MethodEmitter
   * @param method method emitter.
   */
  void beginMethod(MethodEmitter method) {
    assert !methodsStarted.contains(method);
    methodsStarted.add(method);
  }

  /**
   * Call back from MethodEmitter for method end.
   * @see MethodEmitter
   * @param method
   */
  void endMethod(MethodEmitter method) {
    assert methodsStarted.contains(method);
    methodsStarted.remove(method);
  }

  /**
   * Add a new method to the class - defaults to public method.
   * @param methodName name of method
   * @param rtype      return type of the method
   * @param ptypes     parameter types the method
   * @return method emitter to use for weaving this method
   */
  MethodEmitter method(String methodName, Class<?> rtype, Class<?>... ptypes) {
    return method(DEFAULT_METHOD_FLAGS, methodName, rtype, ptypes); //TODO why public default ?
  }

  /**
   * Add a new method to the class - defaults to public method.
   * @param methodFlags access flags for the method
   * @param methodName  name of method
   * @param rtype       return type of the method
   * @param ptypes      parameter types the method
   * @return method emitter to use for weaving this method
   */
  MethodEmitter method(EnumSet<Flag> methodFlags, String methodName, Class<?> rtype, Class<?>... ptypes) {
    methodCount++;
    methodNames.add(methodName);
    return new MethodEmitter(this, methodVisitor(methodFlags, methodName, rtype, ptypes));
  }

  /**
   * Add a new method to the class - defaults to public method.
   * @param methodName name of method
   * @param descriptor descriptor of method
   * @return method emitter to use for weaving this method
   */
  MethodEmitter method(String methodName, String descriptor) {
    return method(DEFAULT_METHOD_FLAGS, methodName, descriptor);
  }

  /**
   * Add a new method to the class - defaults to public method.
   * @param methodFlags access flags for the method
   * @param methodName  name of method
   * @param descriptor  descriptor of method
   * @return method emitter to use for weaving this method
   */
  MethodEmitter method(EnumSet<Flag> methodFlags, String methodName, String descriptor) {
    methodCount++;
    methodNames.add(methodName);
    return new MethodEmitter(this, cw.visitMethod(Flag.getValue(methodFlags), methodName, descriptor, null, null));
  }

  /**
   * Add a new method to the class, representing a function node.
   * @param functionNode the function node to generate a method for
   * @return method emitter to use for weaving this method
   */
  MethodEmitter method(FunctionNode functionNode) {
    methodCount++;
    methodNames.add(functionNode.getName());
    var signature = new FunctionSignature(functionNode);
    var mv = cw.visitMethod(ACC_PUBLIC | ACC_STATIC | (functionNode.isVarArg() ? ACC_VARARGS : 0), functionNode.getName(), signature.toString(), null, null);
    return new MethodEmitter(this, mv, functionNode);
  }

  /**
   * Add a new method to the class, representing a rest-of version of the function node.
   * @param functionNode the function node to generate a method for
   * @return method emitter to use for weaving this method
   */
  MethodEmitter restOfMethod(FunctionNode functionNode) {
    methodCount++;
    methodNames.add(functionNode.getName());
    var mv = cw.visitMethod(ACC_PUBLIC | ACC_STATIC, functionNode.getName(), Type.getMethodDescriptor(functionNode.getReturnType().getTypeClass(), RewriteException.class), null, null);
    return new MethodEmitter(this, mv, functionNode);
  }

  /**
   * Start generating the <clinit> method in the class.
   * @return method emitter to use for weaving <clinit>
   */
  MethodEmitter clinit() {
    clinitCount++;
    return method(EnumSet.of(Flag.STATIC), CLINIT.symbolName(), void.class);
  }

  /**
   * Start generating an <init>()V method in the class.
   * @return method emitter to use for weaving <init>()V
   */
  MethodEmitter init() {
    initCount++;
    return method(INIT.symbolName(), void.class);
  }

  /**
   * Start generating an <init>()V method in the class.
   * @param ptypes parameter types for constructor
   * @return method emitter to use for weaving <init>()V
   */
  MethodEmitter init(Class<?>... ptypes) {
    initCount++;
    return method(INIT.symbolName(), void.class, ptypes);
  }

  /**
   * Start generating an <init>(...)V method in the class.
   * @param flags  access flags for the constructor
   * @param ptypes parameter types for the constructor
   * @return method emitter to use for weaving <init>(...)V
   */
  MethodEmitter init(EnumSet<Flag> flags, Class<?>... ptypes) {
    initCount++;
    return method(flags, INIT.symbolName(), void.class, ptypes);
  }

  /**
   * Add a field to the class, initialized to a value.
   * @param fieldFlags flags, e.g. should it be static or public etc
   * @param fieldName  name of field
   * @param fieldType  the type of the field
   * @param value      the value
   * @see ClassEmitter.Flag
   */
  final void field(EnumSet<Flag> fieldFlags, String fieldName, Class<?> fieldType, Object value) {
    fieldCount++;
    cw.visitField(Flag.getValue(fieldFlags), fieldName, typeDescriptor(fieldType), null, value).visitEnd();
  }

  /**
   * Add a field to the class.
   * @param fieldFlags access flags for the field
   * @param fieldName  name of field
   * @param fieldType  type of the field
   * @see ClassEmitter.Flag
   */
  final void field(EnumSet<Flag> fieldFlags, String fieldName, Class<?> fieldType) {
    field(fieldFlags, fieldName, fieldType, null);
  }

  /**
   * Add a field to the class - defaults to public.
   * @param fieldName  name of field
   * @param fieldType  type of field
   */
  final void field(String fieldName, Class<?> fieldType) {
    field(EnumSet.of(Flag.PUBLIC), fieldName, fieldType, null);
  }

  /**
   * Return a bytecode array from this ClassEmitter.
   * The ClassEmitter must have been ended (having its end function called) for this to work.
   * @return byte code array for generated class, {@code null} if class generation hasn't been ended with {@link ClassEmitter#end()}.
   */
  byte[] toByteArray() {
    assert classEnded;
    if (!classEnded) {
      return null;
    }
    return cw.toByteArray();
  }

  /**
   * Abstraction for flags used in class emission.
   * We provide abstraction separating these from the underlying bytecode emitter.
   * Flags are provided for method handles, protection levels, static/virtual fields/methods.
   */
  static enum Flag {
    /** method handle with static access */
    HANDLE_STATIC(H_INVOKESTATIC),
    /** method handle with new invoke special access */
    HANDLE_NEWSPECIAL(H_NEWINVOKESPECIAL),
    /** method handle with invoke special access */
    HANDLE_SPECIAL(H_INVOKESPECIAL),
    /** method handle with invoke virtual access */
    HANDLE_VIRTUAL(H_INVOKEVIRTUAL),
    /** method handle with invoke interface access */
    HANDLE_INTERFACE(H_INVOKEINTERFACE),
    /** final access */
    FINAL(ACC_FINAL),
    /** static access */
    STATIC(ACC_STATIC),
    /** public access */
    PUBLIC(ACC_PUBLIC),
    /** private access */
    PRIVATE(ACC_PRIVATE);

    final int value;

    Flag(int value) {
      this.value = value;
    }

    /**
     * Get the value of this flag
     * @return the int value
     */
    int getValue() {
      return value;
    }

    /**
     * Return the corresponding ASM flag value for an enum set of flags.
     * @param flags enum set of flags
     * @return an integer value representing the flags intrinsic values or'ed together
     */
    static int getValue(EnumSet<Flag> flags) {
      var v = 0;
      for (var flag : flags) {
        v |= flag.getValue();
      }
      return v;
    }
  }

  MethodVisitor methodVisitor(EnumSet<Flag> flags, String methodName, Class<?> rtype, Class<?>... ptypes) {
    return cw.visitMethod(Flag.getValue(flags), methodName, methodDescriptor(rtype, ptypes), null, null);
  }

}
