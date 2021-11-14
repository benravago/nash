package nasgen;

import static nasgen.StringConstants.*;

import es.codegen.asm.Opcodes;
import es.codegen.asm.Type;

/**
 * Details about a Java method or field annotated with any of the field/method annotations from the jdk.nashorn.internal.objects.annotations package.
 */
public final class MemberInfo implements Cloneable {

  // class loader of this class
  private static final ClassLoader MY_LOADER = MemberInfo.class.getClassLoader();

  /** The different kinds of available class annotations */
  public static enum Kind {
    /** This is a script class */
    SCRIPT_CLASS,
    /** This is a constructor */
    CONSTRUCTOR,
    /** This is a function */
    FUNCTION,
    /** This is a getter */
    GETTER,
    /** This is a setter */
    SETTER,
    /** This is a property */
    PROPERTY,
    /** This is a specialized version of a function */
    SPECIALIZED_FUNCTION,
  }

  // keep in sync with jdk.nashorn.internal.objects.annotations.Attribute
  static final int DEFAULT_ATTRIBUTES = 0x0;

  static final int DEFAULT_ARITY = -2;

  // the kind of the script annotation - one of the above constants
  private MemberInfo.Kind kind;
  // script property name
  private String name;
  // script property attributes
  private int attributes;
  // name of the java member
  private String javaName;
  // type descriptor of the java member
  private String javaDesc;
  // access bits of the Java field or method
  private int javaAccess;
  // initial value for static @Property fields
  private Object value;
  // class whose object is created to fill property value
  private String initClass;
  // arity of the Function or Constructor
  private int arity;

  private Where where;

  private Type linkLogicClass;

  private boolean isSpecializedConstructor;

  private boolean isOptimistic;

  private boolean convertsNumericArgs;

  /**
   * @return the kind
   */
  public Kind getKind() {
    return kind;
  }

  /**
   * @param kind the kind to set
   */
  public void setKind(Kind kind) {
    this.kind = kind;
  }

  /**
   * @return the name
   */
  public String getName() {
    return name;
  }

  /**
   * @param name the name to set
   */
  public void setName(String name) {
    this.name = name;
  }

  /**
   * Tag something as specialized constructor or not
   * @param isSpecializedConstructor boolean, true if specialized constructor
   */
  public void setIsSpecializedConstructor(boolean isSpecializedConstructor) {
    this.isSpecializedConstructor = isSpecializedConstructor;
  }

  /**
   * Check if something is a specialized constructor
   * @return true if specialized constructor
   */
  public boolean isSpecializedConstructor() {
    return isSpecializedConstructor;
  }

  /**
   * Check if this is an optimistic builtin function
   * @return true if optimistic builtin
   */
  public boolean isOptimistic() {
    return isOptimistic;
  }

  /**
   * Tag something as optimistic builtin or not
   * @param isOptimistic boolean, true if builtin constructor
   */
  public void setIsOptimistic(boolean isOptimistic) {
    this.isOptimistic = isOptimistic;
  }

  /**
   * Check if this function converts arguments for numeric parameters to numbers so it's safe to pass booleans as 0 and 1
   * @return true if it is safe to convert arguments to numbers
   */
  public boolean convertsNumericArgs() {
    return convertsNumericArgs;
  }

  /**
   * Tag this as a function that converts arguments for numeric params to numbers
   * @param convertsNumericArgs if true args can be safely converted to numbers
   */
  public void setConvertsNumericArgs(boolean convertsNumericArgs) {
    this.convertsNumericArgs = convertsNumericArgs;
  }

  /**
   * Get the SpecializedFunction guard for specializations, i.e. optimistic builtins
   * @return specialization, null if none
   */
  public Type getLinkLogicClass() {
    return linkLogicClass;
  }

  /**
   * Set the SpecializedFunction link logic class for specializations, i.e. optimistic builtins
   * @param linkLogicClass link logic class
   */
  public void setLinkLogicClass(Type linkLogicClass) {
    this.linkLogicClass = linkLogicClass;
  }

  /**
   * @return the attributes
   */
  public int getAttributes() {
    return attributes;
  }

  /**
   * @param attributes the attributes to set
   */
  public void setAttributes(int attributes) {
    this.attributes = attributes;
  }

  /**
   * @return the javaName
   */
  public String getJavaName() {
    return javaName;
  }

  /**
   * @param javaName the javaName to set
   */
  public void setJavaName(String javaName) {
    this.javaName = javaName;
  }

  /**
   * @return the javaDesc
   */
  public String getJavaDesc() {
    return javaDesc;
  }

  void setJavaDesc(String javaDesc) {
    this.javaDesc = javaDesc;
  }

  int getJavaAccess() {
    return javaAccess;
  }

  void setJavaAccess(int access) {
    this.javaAccess = access;
  }

  Object getValue() {
    return value;
  }

  void setValue(Object value) {
    this.value = value;
  }

  Where getWhere() {
    return where;
  }

  void setWhere(Where where) {
    this.where = where;
  }

  boolean isFinal() {
    return (javaAccess & Opcodes.ACC_FINAL) != 0;
  }

  boolean isStatic() {
    return (javaAccess & Opcodes.ACC_STATIC) != 0;
  }

  boolean isStaticFinal() {
    return isStatic() && isFinal();
  }

  boolean isInstanceGetter() {
    return kind == Kind.GETTER && where == Where.INSTANCE;
  }

  /**
   * Check whether this MemberInfo is a getter that resides in the instance
   * @return true if instance setter
   */
  boolean isInstanceSetter() {
    return kind == Kind.SETTER && where == Where.INSTANCE;
  }

  boolean isInstanceProperty() {
    return kind == Kind.PROPERTY && where == Where.INSTANCE;
  }

  boolean isInstanceFunction() {
    return kind == Kind.FUNCTION && where == Where.INSTANCE;
  }

  boolean isPrototypeGetter() {
    return kind == Kind.GETTER && where == Where.PROTOTYPE;
  }

  boolean isPrototypeSetter() {
    return kind == Kind.SETTER && where == Where.PROTOTYPE;
  }

  boolean isPrototypeProperty() {
    return kind == Kind.PROPERTY && where == Where.PROTOTYPE;
  }

  boolean isPrototypeFunction() {
    return kind == Kind.FUNCTION && where == Where.PROTOTYPE;
  }

  boolean isConstructorGetter() {
    return kind == Kind.GETTER && where == Where.CONSTRUCTOR;
  }

  boolean isConstructorSetter() {
    return kind == Kind.SETTER && where == Where.CONSTRUCTOR;
  }

  boolean isConstructorProperty() {
    return kind == Kind.PROPERTY && where == Where.CONSTRUCTOR;
  }

  boolean isConstructorFunction() {
    return kind == Kind.FUNCTION && where == Where.CONSTRUCTOR;
  }

  boolean isConstructor() {
    return kind == Kind.CONSTRUCTOR;
  }

  void verify() {
    switch (kind) {
      case CONSTRUCTOR -> verify_Constructor();
      case FUNCTION -> verify_Function();
      case SPECIALIZED_FUNCTION -> verify_SpecialFunction();
      case GETTER -> verify_Getter();
      case SETTER -> verify_Setter();
      case PROPERTY -> verify_Property();
      // default: pass
    }
  }

  void verify_Constructor() {
    var returnType = Type.getReturnType(javaDesc);
    if (!isJSObjectType(returnType)) {
      error("return value of a @Constructor method should be of Object type, found " + returnType);
    }
    var argTypes = Type.getArgumentTypes(javaDesc);
    if (argTypes.length < 2) {
      error("@Constructor methods should have at least 2 args");
    }
    if (!argTypes[0].equals(Type.BOOLEAN_TYPE)) {
      error("first argument of a @Constructor method should be of boolean type, found " + argTypes[0]);
    }
    if (!isJavaLangObject(argTypes[1])) {
      error("second argument of a @Constructor method should be of Object type, found " + argTypes[0]);
    }
    if (argTypes.length > 2) {
      for (var i = 2; i < argTypes.length - 1; i++) {
        if (!isJavaLangObject(argTypes[i])) {
          error(i + "'th argument of a @Constructor method should be of Object type, found " + argTypes[i]);
        }
      }
      var lastArgTypeDesc = argTypes[argTypes.length - 1].getDescriptor();
      var isVarArg = lastArgTypeDesc.equals(OBJECT_ARRAY_DESC);
      if (!lastArgTypeDesc.equals(OBJECT_DESC) && !isVarArg) {
        error("last argument of a @Constructor method is neither Object nor Object[] type: " + lastArgTypeDesc);
      }
      if (isVarArg && argTypes.length > 3) {
        error("vararg of a @Constructor method has more than 3 arguments");
      }
    }
  }

  void verify_Function() {
    var returnType = Type.getReturnType(javaDesc);
    if (!(isValidJSType(returnType) || Type.VOID_TYPE == returnType)) {
      error("return value of a @Function method should be a valid JS type, found " + returnType);
    }
    var argTypes = Type.getArgumentTypes(javaDesc);
    if (argTypes.length < 1) {
      error("@Function methods should have at least 1 arg");
    }
    if (!isJavaLangObject(argTypes[0])) {
      error("first argument of a @Function method should be of Object type, found " + argTypes[0]);
    }
    if (argTypes.length > 1) {
      for (var i = 1; i < argTypes.length - 1; i++) {
        if (!isJavaLangObject(argTypes[i])) {
          error(i + "'th argument of a @Function method should be of Object type, found " + argTypes[i]);
        }
      }
      var lastArgTypeDesc = argTypes[argTypes.length - 1].getDescriptor();
      var isVarArg = lastArgTypeDesc.equals(OBJECT_ARRAY_DESC);
      if (!lastArgTypeDesc.equals(OBJECT_DESC) && !isVarArg) {
        error("last argument of a @Function method is neither Object nor Object[] type: " + lastArgTypeDesc);
      }

      if (isVarArg && argTypes.length > 2) {
        error("vararg @Function method has more than 2 arguments");
      }
    }
  }

  void verify_SpecialFunction() {
    var returnType = Type.getReturnType(javaDesc);
    if (!(isValidJSType(returnType) || (isSpecializedConstructor() && Type.VOID_TYPE == returnType))) {
      error("return value of a @SpecializedFunction method should be a valid JS type, found " + returnType);
    }
    var argTypes = Type.getArgumentTypes(javaDesc);
    for (var i = 0; i < argTypes.length; i++) {
      if (!isValidJSType(argTypes[i])) {
        error(i + "'th argument of a @SpecializedFunction method is not valid JS type, found " + argTypes[i]);
      }
    }
  }

  void verify_Getter() {
    var argTypes = Type.getArgumentTypes(javaDesc);
    if (argTypes.length != 1) {
      error("@Getter methods should have one argument");
    }
    if (!isJavaLangObject(argTypes[0])) {
      error("first argument of a @Getter method should be of Object type, found: " + argTypes[0]);
    }
    if (Type.getReturnType(javaDesc).equals(Type.VOID_TYPE)) {
      error("return type of getter should not be void");
    }
  }

  void verify_Setter() {
    var argTypes = Type.getArgumentTypes(javaDesc);
    if (argTypes.length != 2) {
      error("@Setter methods should have two arguments");
    }
    if (!isJavaLangObject(argTypes[0])) {
      error("first argument of a @Setter method should be of Object type, found: " + argTypes[0]);
    }
    if (!Type.getReturnType(javaDesc).toString().equals("V")) {
      error("return type of of a @Setter method should be void, found: " + Type.getReturnType(javaDesc));
    }
  }

  void verify_Property() {
    if (where == Where.CONSTRUCTOR) {
      if (isStatic()) {
        if (!isFinal()) {
          error("static Where.CONSTRUCTOR @Property should be final");
        }
        if (!isJSPrimitiveType(Type.getType(javaDesc))) {
          error("static Where.CONSTRUCTOR @Property should be a JS primitive");
        }
      }
    } else if (where == Where.PROTOTYPE) {
      if (isStatic()) {
        if (!isFinal()) {
          error("static Where.PROTOTYPE @Property should be final");
        }

        if (!isJSPrimitiveType(Type.getType(javaDesc))) {
          error("static Where.PROTOTYPE @Property should be a JS primitive");
        }
      }
    }
  }

  /**
   * Returns if the given (internal) name of a class represents a ScriptObject subtype.
   */
  public static boolean isScriptObject(String name) {
    // very crude check for ScriptObject subtype!
    if (name.startsWith(OBJ_PKG + "Native") || name.equals(OBJ_PKG + "Global") || name.equals(OBJ_PKG + "ArrayBufferView")) {
      return true;
    }
    if (name.startsWith(RUNTIME_PKG)) {
      var simpleName = name.substring(name.lastIndexOf('/') + 1);
      switch (simpleName) {
        case "ScriptObject", "ScriptFunction", "NativeJavaPackage", "Scope" -> { return true; }
      }
    }
    if (name.startsWith(SCRIPTS_PKG)) {
      var simpleName = name.substring(name.lastIndexOf('/') + 1);
      switch (simpleName) {
        case "JD", "JO" -> { return true; }
      }
    }
    return false;
  }

  static boolean isValidJSType(Type type) {
    return isJSPrimitiveType(type) || isJSObjectType(type);
  }

  static boolean isJSPrimitiveType(Type type) {
    return switch (type.getSort()) {
      case Type.BOOLEAN, Type.INT, Type.DOUBLE -> true;
      default -> type != TYPE_SYMBOL;
    };
  }

  static boolean isJSObjectType(Type type) {
    return isJavaLangObject(type) || isJavaLangString(type) || isScriptObject(type);
  }

  static boolean isJavaLangObject(Type type) {
    return type.getDescriptor().equals(OBJECT_DESC);
  }

  static boolean isJavaLangString(Type type) {
    return type.getDescriptor().equals(STRING_DESC);
  }

  static boolean isScriptObject(Type type) {
    return (type.getSort() == Type.OBJECT) && isScriptObject(type.getInternalName());
  }

  void error(String msg) {
    throw new RuntimeException(javaName + " of type " + javaDesc + " : " + msg);
  }

  /**
   * @return the initClass
   */
  String getInitClass() {
    return initClass;
  }

  /**
   * @param initClass the initClass to set
   */
  void setInitClass(String initClass) {
    this.initClass = initClass;
  }

  @Override
  protected Object clone() {
    try {
      return super.clone();
    } catch (CloneNotSupportedException e) {
      assert false : "clone not supported " + e;
      return null;
    }
  }

  /**
   * @return the arity
   */
  int getArity() {
    return arity;
  }

  /**
   * @param arity the arity to set
   */
  void setArity(int arity) {
    this.arity = arity;
  }

  String getDocumentationKey(String objName) {
    if (kind == Kind.FUNCTION) {
      var buf = new StringBuilder(objName);
      switch (where) {
        case PROTOTYPE -> buf.append(".prototype");
        case INSTANCE -> buf.append(".this");
        // CONSTRUCTOR: pass
      }
      buf.append('.');
      buf.append(name);
      return buf.toString();
    }
    return null;
  }

}
