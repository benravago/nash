package es.codegen;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import static es.lookup.Lookup.MH;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import es.codegen.asm.MethodVisitor;
import es.codegen.asm.Opcodes;

import es.codegen.types.Type;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.Source;

/**
 * This class represents constant names of variables, methods and fields in  the compiler
 */
public enum CompilerConstants {
  /** the __FILE__ variable */
  __FILE__,
  /** the __DIR__ variable */
  __DIR__,
  /** the __LINE__ variable */
  __LINE__,
  /** constructor name */
  INIT("<init>"),
  /** static initializer name */
  CLINIT("<clinit>"),
  /** eval name */
  EVAL("eval"),
  /** source name and class */
  SOURCE("source", Source.class),
  /** constants name and class */
  CONSTANTS("constants", Object[].class),
  /** default script name */
  DEFAULT_SCRIPT_NAME("Script"),
  /** function prefix for anonymous functions */
  ANON_FUNCTION_PREFIX("L:"),
  /** separator for method names of nested functions */
  NESTED_FUNCTION_SEPARATOR("#"),
  /** separator for making method names unique by appending numeric ids */
  ID_FUNCTION_SEPARATOR("-"),
  /** method name for Java method that is the program entry point */
  PROGRAM(":program"),
  /** method name for Java method that creates the script function for the program */
  CREATE_PROGRAM_FUNCTION(":createProgramFunction"),
  /**
   * "this" name symbol for a parameter representing ECMAScript "this" in static methods that are compiled representations of ECMAScript functions.
   * It is not assigned a slot, as its position in the method signature is dependent on other factors (most notably, callee can precede it).
   */
  THIS("this", Object.class),
  /** this debugger symbol */
  THIS_DEBUGGER(":this"),
  /** scope name, type and slot */
  SCOPE(":scope", ScriptObject.class, 2),
  /** the return value variable name were intermediate results are stored for scripts */
  RETURN(":return"),
  /** the callee value variable when necessary */
  CALLEE(":callee", ScriptFunction.class),
  /** the varargs variable when necessary */
  VARARGS(":varargs", Object[].class),
  /** the arguments variable (visible to function body). Initially set to ARGUMENTS, but can be reassigned by code in
   * the function body.*/
  ARGUMENTS_VAR("arguments", Object.class),
  /** the internal arguments object, when necessary (not visible to scripts, can't be reassigned). */
  ARGUMENTS(":arguments", ScriptObject.class),
  /** prefix for apply-to-call exploded arguments */
  EXPLODED_ARGUMENT_PREFIX(":xarg"),
  /** prefix for iterators for for (x in ...) */
  ITERATOR_PREFIX(":i", Iterator.class),
  /** prefix for tag variable used for switch evaluation */
  SWITCH_TAG_PREFIX(":s"),
  /** prefix for JVM exceptions */
  EXCEPTION_PREFIX(":e", Throwable.class),
  /** prefix for quick slots generated in Store */
  QUICK_PREFIX(":q"),
  /** prefix for temporary variables */
  TEMP_PREFIX(":t"),
  /** prefix for literals */
  LITERAL_PREFIX(":l"),
  /** prefix for regexps */
  REGEX_PREFIX(":r"),
  /** "this" used in non-static Java methods; always in slot 0 */
  JAVA_THIS(null, 0),
  /** Map parameter in scope object constructors; always in slot 1 */
  INIT_MAP(null, 1),
  /** Parent scope parameter in scope object constructors; always in slot 2 */
  INIT_SCOPE(null, 2),
  /** Arguments parameter in scope object constructors; in slot 3 when present */
  INIT_ARGUMENTS(null, 3),
  /** prefix for all ScriptObject subclasses with dual object/primitive fields, see {@link ObjectClassGenerator} */
  JS_OBJECT_DUAL_FIELD_PREFIX("JD"),
  /** prefix for all ScriptObject subclasses with object fields only, see {@link ObjectClassGenerator} */
  JS_OBJECT_SINGLE_FIELD_PREFIX("JO"),
  /** name for allocate method in JO objects */
  ALLOCATE("allocate"),
  /** prefix for split methods, @see Splitter */
  SPLIT_PREFIX(":split"),
  /** prefix for split array method and slot */
  SPLIT_ARRAY_ARG(":split_array", 3),
  /** get string from constant pool */
  GET_STRING(":getString"),
  /** get map */
  GET_MAP(":getMap"),
  /** set map */
  SET_MAP(":setMap"),
  /** get array prefix */
  GET_ARRAY_PREFIX(":get"),
  /** get array suffix */
  GET_ARRAY_SUFFIX("$array");

  /** To save memory - intern the compiler constant symbol names, as they are frequently reused */
  static /*<init>*/ {
    for (var c : values()) {
      var symbolName = c.symbolName();
      if (symbolName != null) {
        symbolName.intern();
      }
    }
  }

  private static Set<String> symbolNames;

  // Prefix used for internal methods generated in script classes.
  private static final String INTERNAL_METHOD_PREFIX = ":";

  private final String symbolName;
  private final Class<?> type;
  private final int slot;

  CompilerConstants() {
    this.symbolName = name();
    this.type = null;
    this.slot = -1;
  }

  CompilerConstants(String symbolName) {
    this(symbolName, -1);
  }

  CompilerConstants(String symbolName, int slot) {
    this(symbolName, null, slot);
  }

  CompilerConstants(String symbolName, Class<?> type) {
    this(symbolName, type, -1);
  }

  CompilerConstants(String symbolName, Class<?> type, int slot) {
    this.symbolName = symbolName;
    this.type = type;
    this.slot = slot;
  }

  /**
   * Check whether a name is that of a reserved compiler constant
   * @param name name
   * @return true if compiler constant name
   */
  public static boolean isCompilerConstant(String name) {
    ensureSymbolNames();
    return symbolNames.contains(name);
  }

  static void ensureSymbolNames() {
    if (symbolNames == null) {
      symbolNames = new HashSet<>();
      for (var cc : CompilerConstants.values()) {
        symbolNames.add(cc.symbolName);
      }
    }
  }

  /**
   * Return the tag for this compile constant.
   * Deliberately avoiding "name" here not to conflate with enum implementation.
   * This is the master string for the constant - every constant has one.
   * @return the tag
   */
  public final String symbolName() {
    return symbolName;
  }

  /**
   * Return the type for this compile constant
   * @return type for this constant's instances, or null if N/A
   */
  public final Class<?> type() {
    return type;
  }

  /**
   * Return the slot for this compile constant
   * @return byte code slot where constant is stored or -1 if N/A
   */
  public final int slot() {
    return slot;
  }

  /**
   * Return a descriptor for this compile constant.
   * Only relevant if it has a type
   * @return descriptor the descriptor
   */
  public final String descriptor() {
    assert type != null : " asking for descriptor of typeless constant";
    return typeDescriptor(type);
  }

  /**
   * Get the internal class name for a type
   * @param type a type
   * @return  the internal name for this type
   */
  public static String className(Class<?> type) {
    return Type.getInternalName(type);
  }

  /**
   * Get the method descriptor for a given method type collection
   * @param rtype  return type
   * @param ptypes parameter types
   * @return internal descriptor for this method
   */
  public static String methodDescriptor(Class<?> rtype, Class<?>... ptypes) {
    return Type.getMethodDescriptor(rtype, ptypes);
  }

  /**
   * Get the type descriptor for a type
   * @param type a type
   * @return the internal descriptor for this type
   */
  public static String typeDescriptor(Class<?> type) {
    return Type.typeFor(type).getDescriptor();
  }

  /**
   * Create a call representing a void constructor for a given type.
   * Don't attempt to look this up at compile time
   * @param type the class
   * @return Call representing void constructor for type
   */
  public static Call constructorNoLookup(Class<?> type) {
    return specialCallNoLookup(type, INIT.symbolName(), void.class);
  }

  /**
   * Create a call representing a constructor for a given type.
   * Don't attempt to look this up at compile time
   * @param className the type class name
   * @param ptypes    the parameter types for the constructor
   * @return Call representing constructor for type
   */
  public static Call constructorNoLookup(String className, Class<?>... ptypes) {
    return specialCallNoLookup(className, INIT.symbolName(), methodDescriptor(void.class, ptypes));
  }

  /**
   * Create a call representing a constructor for a given type.
   * Don't attempt to look this up at compile time
   * @param type  the class name
   * @param ptypes the parameter types for the constructor
   * @return Call representing constructor for type
   */
  public static Call constructorNoLookup(Class<?> type, Class<?>... ptypes) {
    return specialCallNoLookup(type, INIT.symbolName(), void.class, ptypes);
  }

  /**
   * Create a call representing an invokespecial to a given method.
   * Don't attempt to look this up at compile time
   * @param className the class name
   * @param name      the method name
   * @param desc      the descriptor
   * @return Call representing specified invokespecial call
   */
  public static Call specialCallNoLookup(String className, String name, String desc) {
    return new Call(null, className, name, desc) {
      @Override
      MethodEmitter invoke(MethodEmitter method) {
        return method.invokespecial(className, name, descriptor);
      }
      @Override
      public void invoke(MethodVisitor mv) {
        mv.visitMethodInsn(Opcodes.INVOKESPECIAL, className, name, desc, false);
      }
    };
  }

  /**
   * Create a call representing an invokespecial to a given method.
   * Don't attempt to look this up at compile time
   * @param type  the class
   * @param name   the method name
   * @param rtype  the return type
   * @param ptypes the parameter types
   * @return Call representing specified invokespecial call
   */
  public static Call specialCallNoLookup(Class<?> type, String name, Class<?> rtype, Class<?>... ptypes) {
    return specialCallNoLookup(className(type), name, methodDescriptor(rtype, ptypes));
  }

  /**
   * Create a call representing an invokestatic to a given method.
   * Don't attempt to look this up at compile time
   * @param className the class name
   * @param name      the method name
   * @param desc      the descriptor
   * @return Call representing specified invokestatic call
   */
  public static Call staticCallNoLookup(String className, String name, String desc) {
    return new Call(null, className, name, desc) {
      @Override
      MethodEmitter invoke(MethodEmitter method) {
        return method.invokestatic(className, name, descriptor);
      }
      @Override
      public void invoke(MethodVisitor mv) {
        mv.visitMethodInsn(Opcodes.INVOKESTATIC, className, name, desc, false);
      }
    };
  }

  /**
   * Create a call representing an invokestatic to a given method.
   * Don't attempt to look this up at compile time
   * @param type  the class
   * @param name   the method name
   * @param rtype  the return type
   * @param ptypes the parameter types
   * @return Call representing specified invokestatic call
   */
  public static Call staticCallNoLookup(Class<?> type, String name, Class<?> rtype, Class<?>... ptypes) {
    return staticCallNoLookup(className(type), name, methodDescriptor(rtype, ptypes));
  }

  /**
   * Create a call representing an invokevirtual to a given method.
   * Don't attempt to look this up at compile time
   * @param type  the class
   * @param name   the method name
   * @param rtype  the return type
   * @param ptypes the parameter types
   * @return Call representing specified invokevirtual call
   */
  public static Call virtualCallNoLookup(Class<?> type, String name, Class<?> rtype, Class<?>... ptypes) {
    return new Call(null, className(type), name, methodDescriptor(rtype, ptypes)) {
      @Override
      MethodEmitter invoke(MethodEmitter method) {
        return method.invokevirtual(className, name, descriptor);
      }
      @Override
      public void invoke(MethodVisitor mv) {
        mv.visitMethodInsn(Opcodes.INVOKEVIRTUAL, className, name, descriptor, false);
      }
    };
  }

  /**
   * Create a call representing an invokeinterface to a given method.
   * Don't attempt to look this up at compile time
   * @param type  the class
   * @param name   the method name
   * @param rtype  the return type
   * @param ptypes the parameter types
   *
   * @return Call representing specified invokeinterface call
   */
  public static Call interfaceCallNoLookup(Class<?> type, String name, Class<?> rtype, Class<?>... ptypes) {
    return new Call(null, className(type), name, methodDescriptor(rtype, ptypes)) {
      @Override
      MethodEmitter invoke(MethodEmitter method) {
        return method.invokeinterface(className, name, descriptor);
      }
      @Override
      public void invoke(MethodVisitor mv) {
        mv.visitMethodInsn(Opcodes.INVOKEINTERFACE, className, name, descriptor, true);
      }
    };
  }

  /**
   * Create a FieldAccess representing a virtual field, that can be subject to put or get operations
   * @param className name of the class where the field is a member
   * @param name      name of the field
   * @param desc      type descriptor of the field
   * @return a field access object giving access code generation method for the virtual field
   */
  public static FieldAccess virtualField(String className, String name, String desc) {
    return new FieldAccess(className, name, desc) {
      @Override
      public MethodEmitter get(MethodEmitter method) {
        return method.getField(className, name, descriptor);
      }
      @Override
      public void put(MethodEmitter method) {
        method.putField(className, name, descriptor);
      }
    };
  }

  /**
   * Create a FieldAccess representing a virtual field, that can be subject to put or get operations
   * @param type class where the field is a member
   * @param name  name of the field
   * @param ftype  ftype of the field
   * @return a field access object giving access code generation method for the virtual field
   */
  public static FieldAccess virtualField(Class<?> type, String name, Class<?> ftype) {
    return virtualField(className(type), name, typeDescriptor(ftype));
  }

  /**
   * Create a FieldAccess representing a static field, that can be subject to put or get operations
   * @param className name of the class where the field is a member
   * @param name      name of the field
   * @param desc      type descriptor of the field
   * @return a field access object giving access code generation method for the static field
   */
  public static FieldAccess staticField(String className, String name, String desc) {
    return new FieldAccess(className, name, desc) {
      @Override
      public MethodEmitter get(MethodEmitter method) {
        return method.getStatic(className, name, descriptor);
      }
      @Override
      public void put(MethodEmitter method) {
        method.putStatic(className, name, descriptor);
      }
    };
  }

  /**
   * Create a FieldAccess representing a static field, that can be subject to put or get operations
   * @param type class where the field is a member
   * @param name  name of the field
   * @param ftype  ftype of the field
   * @return a field access object giving access code generation method for the virtual field
   */
  public static FieldAccess staticField(Class<?> type, String name, Class<?> ftype) {
    return staticField(className(type), name, typeDescriptor(ftype));
  }

  /**
   * Create a static call, given an explicit lookup, looking up the method handle for it at the same time
   * @param lookup the lookup
   * @param type  the class
   * @param name   the name of the method
   * @param rtype  the return type
   * @param ptypes the parameter types
   * @return the call object representing the static call
   */
  public static Call staticCall(MethodHandles.Lookup lookup, Class<?> type, String name, Class<?> rtype, Class<?>... ptypes) {
    return new Call(MH.findStatic(lookup, type, name, MH.type(rtype, ptypes)), className(type), name, methodDescriptor(rtype, ptypes)) {
      @Override
      MethodEmitter invoke(MethodEmitter method) {
        return method.invokestatic(className, name, descriptor);
      }
      @Override
      public void invoke(MethodVisitor mv) {
        mv.visitMethodInsn(Opcodes.INVOKESTATIC, className, name, descriptor, false);
      }
    };
  }

  /**
   * Create a virtual call, given an explicit lookup, looking up the method handle for it at the same time
   * @param lookup the lookup
   * @param type  the class
   * @param name   the name of the method
   * @param rtype  the return type
   * @param ptypes the parameter types
   * @return the call object representing the virtual call
   */
  public static Call virtualCall(MethodHandles.Lookup lookup, Class<?> type, String name, Class<?> rtype, Class<?>... ptypes) {
    return new Call(MH.findVirtual(lookup, type, name, MH.type(rtype, ptypes)), className(type), name, methodDescriptor(rtype, ptypes)) {
      @Override
      MethodEmitter invoke(MethodEmitter method) {
        return method.invokevirtual(className, name, descriptor);
      }
      @Override
      public void invoke(MethodVisitor mv) {
        mv.visitMethodInsn(Opcodes.INVOKEVIRTUAL, className, name, descriptor, false);
      }
    };
  }

  /**
   * Create a special call, given an explicit lookup, looking up the method handle for it at the same time.
   * clazz is used as this class
   * @param lookup    the lookup
   * @param type     the class
   * @param name      the name of the method
   * @param rtype     the return type
   * @param ptypes    the parameter types
   * @return the call object representing the virtual call
   */
  public static Call specialCall(MethodHandles.Lookup lookup, Class<?> type, String name, Class<?> rtype, Class<?>... ptypes) {
    return new Call(MH.findSpecial(lookup, type, name, MH.type(rtype, ptypes), type), className(type), name, methodDescriptor(rtype, ptypes)) {
      @Override
      MethodEmitter invoke(MethodEmitter method) {
        return method.invokespecial(className, name, descriptor);
      }
      @Override
      public void invoke(MethodVisitor mv) {
        mv.visitMethodInsn(Opcodes.INVOKESPECIAL, className, name, descriptor, false);
      }
    };
  }

  /**
   * Returns true if the passed string looks like a method name of an internally generated Nashorn method.
   * Basically, if it starts with a colon character {@code :} but is not the name of the program method {@code :program}.
   * Program function is not considered internal as we want it to show up in exception stack traces.
   * @param methodName the name of a method
   * @return true if it looks like an internal Nashorn method name.
   * @throws NullPointerException if passed null
   */
  public static boolean isInternalMethodName(String methodName) {
    return methodName.startsWith(INTERNAL_METHOD_PREFIX) && !methodName.equals(PROGRAM.symbolName);
  }

  /**
   * Private class representing an access.
   * This can generate code into a method code or a field access.
   */
  abstract static class Access {

    protected final MethodHandle methodHandle;
    protected final String className;
    protected final String name;
    protected final String descriptor;

    /**
     * Constructor
     * @param methodHandle methodHandle or null if none
     * @param className    class name for access
     * @param name         field or method name for access
     * @param descriptor   descriptor for access field or method
     */
    protected Access(MethodHandle methodHandle, String className, String name, String descriptor) {
      this.methodHandle = methodHandle;
      this.className = className;
      this.name = name;
      this.descriptor = descriptor;
    }

    /**
     * Get the method handle, or null if access hasn't been looked up
     * @return method handle
     */
    public MethodHandle methodHandle() {
      return methodHandle;
    }

    /**
     * Get the class name of the access
     * @return the class name
     */
    public String className() {
      return className;
    }

    /**
     * Get the field name or method name of the access
     * @return the name
     */
    public String name() {
      return name;
    }

    /**
     * Get the descriptor of the method or field of the access
     * @return the descriptor
     */
    public String descriptor() {
      return descriptor;
    }
  }

  /**
   * Field access - this can be used for generating code for static or virtual field accesses
   */
  public abstract static class FieldAccess extends Access {

    /**
     * Constructor
     * @param className  name of the class where the field is
     * @param name       name of the field
     * @param descriptor descriptor of the field
     */
    protected FieldAccess(String className, String name, String descriptor) {
      super(null, className, name, descriptor);
    }

    /**
     * Generate get code for the field
     * @param emitter a method emitter
     * @return the method emitter
     */
    protected abstract MethodEmitter get(MethodEmitter emitter);

    /**
     * Generate put code for the field
     * @param emitter a method emitter
     */
    protected abstract void put(MethodEmitter emitter);
  }

  /**
   * Call - this can be used for generating code for different types of calls
   */
  public abstract static class Call extends Access {

    /**
     * Constructor
     * @param className  class name for the method of the call
     * @param name       method name
     * @param descriptor method descriptor
     */
    protected Call(String className, String name, String descriptor) {
      super(null, className, name, descriptor);
    }

    /**
     * Constructor
     * @param methodHandle method handle for the call if resolved
     * @param className    class name for the method of the call
     * @param name         method name
     * @param descriptor   method descriptor
     */
    protected Call(MethodHandle methodHandle, String className, String name, String descriptor) {
      super(methodHandle, className, name, descriptor);
    }

    /**
     * Generate invocation code for the method
     * @param emitter a method emitter
     * @return the method emitter
     */
    abstract MethodEmitter invoke(MethodEmitter emitter);

    /**
     * Generate invocation code for the method
     * @param mv a method visitor
     */
    public abstract void invoke(MethodVisitor mv);
  }

}
