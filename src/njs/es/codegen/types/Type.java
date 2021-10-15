package es.codegen.types;

import org.objectweb.asm.MethodVisitor;
import static org.objectweb.asm.Opcodes.*;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.io.Serializable;

import java.util.Collections;
import java.util.Map;
import java.util.TreeMap;
import java.util.WeakHashMap;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import es.codegen.CompilerConstants.Call;
import es.runtime.Context;
import es.runtime.ScriptObject;
import es.runtime.Undefined;

/**
 * This is the representation of a JavaScript type, disassociated from java Classes, with the basis for conversion weight, mapping to ASM types
 * and implementing the ByteCodeOps interface which tells this type how to generate code for various operations.
 *
 * Except for ClassEmitter, this is the only class that has to know about the underlying byte code generation system.
 *
 * The different types know how to generate bytecode for the different operations, inherited from BytecodeOps, that they support.
 * This avoids if/else chains depending on type in several cases and allows for more readable and shorter code
 *
 * The Type class also contains logic used by the type inference and for comparing types against each other, as well as the concepts of narrower to wider types.
 * The widest type is an object. Ideally we would like as narrow types as possible for code to be efficient, e.g INTs rather than OBJECTs
 */
public abstract class Type implements Comparable<Type>, BytecodeOps, Serializable {

  // Human readable name for type
  private transient final String name;

  // Descriptor for type
  private transient final String descriptor;

  // The "weight" of the type. Used for picking widest/least specific common type
  private transient final int weight;

  // How many bytecode slots does this type occupy
  private transient final int slots;

  // The class for this type
  private final Class<?> typeClass;

  // Cache for internal types - this is a query that requires complex stringbuilding inside ASM and it saves startup time to cache the type mappings
  private static final Map<Class<?>, org.objectweb.asm.Type> INTERNAL_TYPE_CACHE = // TODO: review this
    Collections.synchronizedMap(new WeakHashMap<>());

  // Internal ASM type for this Type - computed once at construction
  private transient final org.objectweb.asm.Type internalType;

  // Weights are used to decide which types are "wider" than other types
  protected static final int MIN_WEIGHT = -1;

  // Set way below Integer.MAX_VALUE to prevent overflow when adding weights. Objects are still heaviest.
  protected static final int MAX_WEIGHT = 20;

  /**
   * Constructor
   *
   * @param type       class for type
   * @param weight      weight - higher is more generic
   * @param slots       how many bytecode slots the type takes up
   */
  Type(String name, Class<?> type, int weight, int slots) {
    this.name = name;
    this.typeClass = type;
    this.descriptor = org.objectweb.asm.Type.getDescriptor(type);
    this.weight = weight;
    assert weight >= MIN_WEIGHT && weight <= MAX_WEIGHT : "illegal type weight: " + weight;
    this.slots = slots;
    this.internalType = getInternalType(type);
  }

  /**
   * Get the weight of this type - use this e.g. for sorting method descriptors
   * @return the weight
   */
  public int getWeight() {
    return weight;
  }

  /**
   * Get the Class representing this type
   * @return the class for this type
   */
  public Class<?> getTypeClass() {
    return typeClass;
  }

  /**
   * For specialization, return the next, slightly more difficulty, type
   * to test.
   *
   * @return the next Type
   */
  public Type nextWider() {
    return null;
  }

  /**
   * Get the boxed type for this class
   * @return the boxed version of this type or null if N/A
   */
  public Class<?> getBoxedType() {
    assert !getTypeClass().isPrimitive();
    return null;
  }

  /**
   * Returns the character describing the bytecode type for this value on the stack or local variable,
   * identical to what would be used as the prefix for a bytecode {@code LOAD} or {@code STORE} instruction,
   * therefore it must be one of {@code A, F, D, I, L}.
   *
   * Also, the special value {@code U} is used for local variable slots that haven't been initialized yet
   * (it can't appear for a value pushed to the operand stack, those always have known values).
   *
   * Note that while we allow all JVM internal types, Nashorn doesn't necessarily use them all
   * - currently we don't have floats, only doubles, but that might change in the future.
   *
   * @return the character describing the bytecode type for this value on the stack.
   */
  public abstract char getBytecodeStackType();

  /**
   * Generate a method descriptor given a return type and a param array
   *
   * @param returnType return type
   * @param types      parameters
   * @return a descriptor string
   */
  public static String getMethodDescriptor(Type returnType, Type... types) {
    var itypes = new org.objectweb.asm.Type[types.length];
    for (var i = 0; i < types.length; i++) {
      itypes[i] = types[i].getInternalType();
    }
    return org.objectweb.asm.Type.getMethodDescriptor(returnType.getInternalType(), itypes);
  }

  /**
   * Generate a method descriptor given a return type and a param array
   *
   * @param returnType return type
   * @param types      parameters
   * @return a descriptor string
   */
  public static String getMethodDescriptor(Class<?> returnType, Class<?>... types) {
    var itypes = new org.objectweb.asm.Type[types.length];
    for (var i = 0; i < types.length; i++) {
      itypes[i] = getInternalType(types[i]);
    }
    return org.objectweb.asm.Type.getMethodDescriptor(getInternalType(returnType), itypes);
  }

  /**
   * Return a character representing {@code type} in a method signature.
   *
   * @param type parameter type
   * @return descriptor character
   */
  public static char getShortSignatureDescriptor(Type type) {
    // Use 'Z' for boolean parameters as we need to distinguish from int
    return (type instanceof BooleanType) ? 'Z' : type.getBytecodeStackType();
  }

  /**
   * Return the type for an internal type, package private - do not use* outside code gen
   *
   * @param itype internal type
   * @return Nashorn type
   */
  static Type typeFor(org.objectweb.asm.Type itype) {
    return switch (itype.getSort()) {

      case org.objectweb.asm.Type.BOOLEAN -> Type.BOOLEAN;
      case org.objectweb.asm.Type.INT -> Type.INT;
      case org.objectweb.asm.Type.LONG -> Type.LONG;
      case org.objectweb.asm.Type.DOUBLE -> Type.NUMBER;

      case org.objectweb.asm.Type.VOID -> null;

      case org.objectweb.asm.Type.OBJECT -> {
        var cn = itype.getClassName();
        yield (Context.isStructureClass(cn))
          ? SCRIPT_OBJECT
          : cacheByName.computeIfAbsent(cn, name -> {
              try { return Type.typeFor(Class.forName(name)); }
              catch (ClassNotFoundException e) { throw new AssertionError(e); }
            });
      }
      case org.objectweb.asm.Type.ARRAY -> {
        yield switch (itype.getElementType().getSort()) {
          case org.objectweb.asm.Type.DOUBLE -> NUMBER_ARRAY;
          case org.objectweb.asm.Type.INT -> INT_ARRAY;
          case org.objectweb.asm.Type.LONG -> LONG_ARRAY;
          case org.objectweb.asm.Type.OBJECT -> OBJECT_ARRAY;
          default -> { throw new AssertionError(unknown(itype)); }
        };
      }
      default -> { throw new AssertionError(unknown(itype)); }
    };
  }

  static String unknown(org.objectweb.asm.Type itype) {
    return "Unknown itype : " + itype + " sort " + itype.getSort();
  }

  /**
   * Get the return type for a method
   *
   * @param methodDescriptor method descriptor
   * @return return type
   */
  public static Type getMethodReturnType(String methodDescriptor) {
    return Type.typeFor(org.objectweb.asm.Type.getReturnType(methodDescriptor));
  }

  /**
   * Get type array representing arguments of a method in order
   *
   * @param methodDescriptor method descriptor
   * @return parameter type array
   */
  public static Type[] getMethodArguments(String methodDescriptor) {
    var itypes = org.objectweb.asm.Type.getArgumentTypes(methodDescriptor);
    var types = new Type[itypes.length];
    for (var i = 0; i < itypes.length; i++) {
      types[i] = Type.typeFor(itypes[i]);
    }
    return types;
  }

  /**
   * Write a map of {@code int} to {@code Type} to an output stream. This is used to store deoptimization state.
   *
   * @param typeMap the type map
   * @param output data output
   * @throws IOException if write cannot be completed
   */
  public static void writeTypeMap(Map<Integer, Type> typeMap, DataOutput output) throws IOException {
    if (typeMap == null) {
      output.writeInt(0);
    } else {
      output.writeInt(typeMap.size());
      for (var e : typeMap.entrySet()) {
        output.writeInt(e.getKey());
        byte typeChar;
        var type = e.getValue();
        if (type == Type.OBJECT) {
          typeChar = 'L';
        } else if (type == Type.NUMBER) {
          typeChar = 'D';
        } else if (type == Type.LONG) {
          typeChar = 'J';
        } else {
          throw new AssertionError();
        }
        output.writeByte(typeChar);
      }
    }
  }

  /**
   * Read a map of {@code int} to {@code Type} from an input stream. This is used to store deoptimization state.
   *
   * @param input data input
   * @return type map
   * @throws IOException if read cannot be completed
   */
  public static Map<Integer, Type> readTypeMap(DataInput input) throws IOException {
    var size = input.readInt();
    if (size <= 0) {
      return null;
    }
    var map = new TreeMap<Integer, Type>();
    for (var i = 0; i < size; ++i) {
      var pp = input.readInt();
      var typeChar = input.readByte();
      Type type;
      switch (typeChar) {
        case 'L' -> type = Type.OBJECT;
        case 'D' -> type = Type.NUMBER;
        case 'J' -> type = Type.LONG;
        default -> { continue; }
      }
      map.put(pp, type);
    }
    return map;
  }

  static org.objectweb.asm.Type getInternalType(String className) {
    return org.objectweb.asm.Type.getType(className);
  }

  org.objectweb.asm.Type getInternalType() {
    return internalType;
  }

  static org.objectweb.asm.Type lookupInternalType(Class<?> type) {
    var c = INTERNAL_TYPE_CACHE;
    var itype = c.get(type);
    if (itype != null) {
      return itype;
    }
    itype = org.objectweb.asm.Type.getType(type);
    c.put(type, itype);
    return itype;
  }

  static org.objectweb.asm.Type getInternalType(Class<?> type) {
    return lookupInternalType(type);
  }

  static void invokestatic(MethodVisitor method, Call call) {
    method.visitMethodInsn(INVOKESTATIC, call.className(), call.name(), call.descriptor(), false);
  }

  /**
   * Get the internal JVM name of a type
   *
   * @return the internal name
   */
  public String getInternalName() {
    return org.objectweb.asm.Type.getInternalName(getTypeClass());
  }

  /**
   * Get the internal JVM name of type type represented by a given Java class
   *
   * @param type the class
   * @return the internal name
   */
  public static String getInternalName(Class<?> type) {
    return org.objectweb.asm.Type.getInternalName(type);
  }

  /**
   * Determines whether a type is the UNKNOWN type, i.e. not set yet
   * Used for type inference.
   *
   * @return true if UNKNOWN, false otherwise
   */
  public boolean isUnknown() {
    return this.equals(Type.UNKNOWN);
  }

  /**
   * Determines whether this type represents an primitive type according to the ECMAScript specification, which includes Boolean, Number, and String.
   *
   * @return true if a JavaScript primitive type, false otherwise.
   */
  public boolean isJSPrimitive() {
    return !isObject() || isString();
  }

  /**
   * Determines whether a type is the BOOLEAN type
   *
   * @return true if BOOLEAN, false otherwise
   */
  public boolean isBoolean() {
    return this.equals(Type.BOOLEAN);
  }

  /**
   * Determines whether a type is the INT type
   *
   * @return true if INTEGER, false otherwise
   */
  public boolean isInteger() {
    return this.equals(Type.INT);
  }

  /**
   * Determines whether a type is the LONG type
   *
   * @return true if LONG, false otherwise
   */
  public boolean isLong() {
    return this.equals(Type.LONG);
  }

  /**
   * Determines whether a type is the NUMBER type
   *
   * @return true if NUMBER, false otherwise
   */
  public boolean isNumber() {
    return this.equals(Type.NUMBER);
  }

  /**
   * Determines whether a type is numeric, i.e. NUMBER, INT, LONG.
   *
   * @return true if numeric, false otherwise
   */
  public boolean isNumeric() {
    return this instanceof NumericType;
  }

  /**
   * Determines whether a type is an array type, i.e. OBJECT_ARRAY or NUMBER_ARRAY (for now)
   *
   * @return true if an array type, false otherwise
   */
  public boolean isArray() {
    return this instanceof ArrayType;
  }

  /**
   * Determines if a type takes up two bytecode slots or not
   *
   * @return true if type takes up two bytecode slots rather than one
   */
  public boolean isCategory2() {
    return getSlots() == 2;
  }

  /**
   * Determines whether a type is an OBJECT type, e.g. OBJECT, STRING, NUMBER_ARRAY etc.
   *
   * @return true if object type, false otherwise
   */
  public boolean isObject() {
    return this instanceof ObjectType;
  }

  /**
   * Is this a primitive type (e.g int, long, double, boolean)
   *
   * @return true if primitive
   */
  public boolean isPrimitive() {
    return !isObject();
  }

  /**
   * Determines whether a type is a STRING type
   *
   * @return true if object type, false otherwise
   */
  public boolean isString() {
    return this.equals(Type.STRING);
  }

  /**
   * Determines whether a type is a CHARSEQUENCE type used internally strings
   *
   * @return true if CharSequence (internal string) type, false otherwise
   */
  public boolean isCharSequence() {
    return this.equals(Type.CHARSEQUENCE);
  }

  /**
   * Determine if two types are equivalent, i.e. need no conversion
   *
   * @param type the second type to check
   * @return true if types are equivalent, false otherwise
   */
  public boolean isEquivalentTo(Type type) {
    return this.weight() == type.weight() || isObject() && type.isObject();
  }

  /**
   * Determine if a type can be assigned to from another
   *
   * @param type0 the first type to check
   * @param type1 the second type to check
   * @return true if type1 can be written to type2, false otherwise
   */
  public static boolean isAssignableFrom(Type type0, Type type1) {
    return (type0.isObject() && type1.isObject()) ? type0.weight() >= type1.weight() : type0.weight() == type1.weight();
  }

  /**
   * Determine if this type is assignable from another type
   *
   * @param type the type to check against
   * @return true if "type" can be written to this type, false otherwise
   */
  public boolean isAssignableFrom(Type type) {
    return Type.isAssignableFrom(this, type);
  }

  /**
   * Determines is this type is equivalent to another, i.e. needs no conversion to be assigned to it.
   *
   * @param type0 the first type to check
   * @param type1 the second type to check
   * @return true if this type is equivalent to type, false otherwise
   */
  public static boolean areEquivalent(Type type0, Type type1) {
    return type0.isEquivalentTo(type1);
  }

  /**
   * Determine the number of bytecode slots a type takes up
   *
   * @return the number of slots for this type, 1 or 2.
   */
  public int getSlots() {
    return slots;
  }

  /**
   * Returns the widest or most common of two types
   *
   * @param type0 type one
   * @param type1 type two
   * @return the widest type
   */
  public static Type widest(Type type0, Type type1) {
    if (type0.isArray() && type1.isArray()) {
      return ((ArrayType) type0).getElementType() == ((ArrayType) type1).getElementType() ? type0 : Type.OBJECT;
    } else if (type0.isArray() != type1.isArray()) {
      // array and non array is always object, widest(Object[], int) NEVER returns Object[], which has most weight. that does not make sense
      return Type.OBJECT;
    } else if (type0.isObject() && type1.isObject() && type0.getTypeClass() != type1.getTypeClass()) {
      // Object<type=String> and Object<type=ScriptFunction> will produce Object
      // TODO: maybe find most specific common superclass?
      return Type.OBJECT;
    }
    return type0.weight() > type1.weight() ? type0 : type1;
  }

  /**
   * Returns the widest or most common of two types, given as classes
   *
   * @param type0 type one
   * @param type1 type two
   * @return the widest type
   */
  public static Class<?> widest(Class<?> type0, Class<?> type1) {
    return widest(Type.typeFor(type0), Type.typeFor(type1)).getTypeClass();
  }

  /**
   * When doing widening for return types of a function or a ternary operator, it is not valid to widen a boolean to anything other than object.
   * Note that this wouldn't be necessary if {@code Type.widest} did not allow boolean-to-number widening.
   * Eventually, we should address it there, but it affects too many other parts of the system and is sometimes legitimate (e.g. whenever a boolean value would undergo ToNumber conversion anyway).
   *
   * @param t1 type 1
   * @param t2 type 2
   * @return wider of t1 and t2, except if one is boolean and the other is neither boolean nor unknown, in which case {@code Type.OBJECT} is returned.
   */
  public static Type widestReturnType(Type t1, Type t2) {
    if (t1.isUnknown()) {
      return t2;
    } else if (t2.isUnknown()) {
      return t1;
    } else if (t1.isBoolean() != t2.isBoolean() || t1.isNumeric() != t2.isNumeric()) {
      return Type.OBJECT;
    }
    return Type.widest(t1, t2);
  }

  /**
   * Returns a generic version of the type.
   * Basically, if the type {@link #isObject()}, returns {@link #OBJECT}, otherwise returns the type unchanged.
   *
   * @param type the type to generify
   * @return the generified type
   */
  public static Type generic(Type type) {
    return type.isObject() ? Type.OBJECT : type;
  }

  /**
   * Returns the narrowest or least common of two types
   *
   * @param type0 type one
   * @param type1 type two
   * @return the widest type
   */
  public static Type narrowest(Type type0, Type type1) {
    return type0.narrowerThan(type1) ? type0 : type1;
  }

  /**
   * Check whether this type is strictly narrower than another one
   *
   * @param type type to check against
   * @return true if this type is strictly narrower
   */
  public boolean narrowerThan(Type type) {
    return weight() < type.weight();
  }

  /**
   * Check whether this type is strictly wider than another one
   *
   * @param type type to check against
   * @return true if this type is strictly wider
   */
  public boolean widerThan(Type type) {
    return weight() > type.weight();
  }

  /**
   * Returns the widest or most common of two types, but no wider than "limit"
   *
   * @param type0 type one
   * @param type1 type two
   * @param limit limiting type
   * @return the widest type, but no wider than limit
   */
  public static Type widest(Type type0, Type type1, Type limit) {
    var type = Type.widest(type0, type1);
    return (type.weight() > limit.weight()) ? limit : type;
  }

  /**
   * Returns the widest or most common of two types, but no narrower than "limit"
   *
   * @param type0 type one
   * @param type1 type two
   * @param limit limiting type
   * @return the widest type, but no wider than limit
   */
  public static Type narrowest(Type type0, Type type1, Type limit) {
    var type = type0.weight() < type1.weight() ? type0 : type1;
    return (type.weight() < limit.weight()) ? limit : type;
  }

  /**
   * Returns the narrowest of this type and another
   *
   * @param  other type to compare against
   * @return the widest type
   */
  public Type narrowest(Type other) {
    return Type.narrowest(this, other);
  }

  /**
   * Returns the widest of this type and another
   *
   * @param  other type to compare against
   * @return the widest type
   */
  public Type widest(Type other) {
    return Type.widest(this, other);
  }

  /**
   * Returns the weight of a type, used for type comparison between wider and narrower types
   *
   * @return the weight
   */
  int weight() {
    return weight;
  }

  /**
   * Return the descriptor of a type, used for e.g. signature generation
   *
   * @return the descriptor
   */
  public String getDescriptor() {
    return descriptor;
  }

  /**
   * Return the descriptor of a type, short version.
   * Used mainly for debugging purposes
   *
   * @return the short descriptor
   */
  public String getShortDescriptor() {
    return descriptor;
  }

  @Override
  public String toString() {
    return name;
  }

  /**
   * Return the (possibly cached) Type object for this class
   *
   * @param type the class to check
   * @return the Type representing this class
   */
  public static Type typeFor(Class<?> type) {
    return cache.computeIfAbsent(type, (keyClass) -> {
      assert !keyClass.isPrimitive() || keyClass == void.class;
      return keyClass.isArray() ? new ArrayType(keyClass) : new ObjectType(keyClass);
    });
  }

  @Override
  public int compareTo(Type o) {
    return o.weight() - weight();
  }

  /**
   * Common logic for implementing dup for all types
   *
   * @param method method visitor
   * @param depth dup depth
   *
   * @return the type at the top of the stack afterwards
   */
  @Override
  public Type dup(MethodVisitor method, int depth) {
    return Type.dup(method, this, depth);
  }

  /**
   * Common logic for implementing swap for all types
   *
   * @param method method visitor
   * @param other  the type to swap with
   *
   * @return the type at the top of the stack afterwards, i.e. other
   */
  @Override
  public Type swap(MethodVisitor method, Type other) {
    Type.swap(method, this, other);
    return other;
  }

  /**
   * Common logic for implementing pop for all types
   *
   * @param method method visitor
   * @return the type that was popped
   */
  @Override
  public Type pop(MethodVisitor method) {
    Type.pop(method, this);
    return this;
  }

  @Override
  public Type loadEmpty(MethodVisitor method) {
    assert false : "unsupported operation";
    return null;
  }

  /**
   * Superclass logic for pop for all types
   *
   * @param method method emitter
   * @param type   type to pop
   */
  protected static void pop(MethodVisitor method, Type type) {
    method.visitInsn(type.isCategory2() ? POP2 : POP);
  }

  static Type dup(MethodVisitor method, Type type, int depth) {
    var cat2 = type.isCategory2();

    switch (depth) {
      case 0 -> method.visitInsn(cat2 ? DUP2 : DUP);
      case 1 -> method.visitInsn(cat2 ? DUP2_X1 : DUP_X1);
      case 2 -> method.visitInsn(cat2 ? DUP2_X2 : DUP_X2);
      default -> { return null; } //invalid depth
    }

    return type;
  }

  static void swap(MethodVisitor method, Type above, Type below) {
    if (below.isCategory2()) {
      if (above.isCategory2()) {
        method.visitInsn(DUP2_X2);
        method.visitInsn(POP2);
      } else {
        method.visitInsn(DUP_X2);
        method.visitInsn(POP);
      }
    } else {
      if (above.isCategory2()) {
        method.visitInsn(DUP2_X1);
        method.visitInsn(POP2);
      } else {
        method.visitInsn(SWAP);
      }
    }
  }

  /** Mappings between java classes and their Type singletons */
  private static final ConcurrentMap<Class<?>, Type> cache = new ConcurrentHashMap<>();
  private static final ConcurrentMap<String, Type> cacheByName = new ConcurrentHashMap<>();

  /** This is the boolean singleton, used for all boolean types */
  public static final Type BOOLEAN = putInCache(new BooleanType());

  /** This is an integer type, i.e INT, INT32. */
  public static final BitwiseType INT = putInCache(new IntType());

  /** This is the number singleton, used for all number types */
  public static final NumericType NUMBER = putInCache(new NumberType());

  /** This is the long singleton, used for all long types */
  public static final Type LONG = putInCache(new LongType());

  /** A string singleton */
  public static final Type STRING = putInCache(new ObjectType(String.class));

  /** This is the CharSequence singleton used to represent JS strings internally (either a {@code java.lang.String} or {@code es.runtime.ConsString}. */
  public static final Type CHARSEQUENCE = putInCache(new ObjectType(CharSequence.class));

  /** This is the object singleton, used for all object types */
  public static final Type OBJECT = putInCache(new ObjectType());

  /** A undefined singleton */
  public static final Type UNDEFINED = putInCache(new ObjectType(Undefined.class));

  /** This is the singleton for ScriptObjects */
  public static final Type SCRIPT_OBJECT = putInCache(new ObjectType(ScriptObject.class));

  /** This is the singleton for integer arrays */
  public static final ArrayType INT_ARRAY = putInCache(
    new ArrayType(int[].class) {
      @Override public void astore(MethodVisitor method) { method.visitInsn(IASTORE); }
      @Override public Type aload(MethodVisitor method) { method.visitInsn(IALOAD); return INT; }
      @Override public Type newarray(MethodVisitor method) { method.visitIntInsn(NEWARRAY, T_INT); return this; }
      @Override public Type getElementType() { return INT; }
      private static final long serialVersionUID = 1L;
    });

  /** This is the singleton for long arrays */
  public static final ArrayType LONG_ARRAY = putInCache(
    new ArrayType(long[].class) {
      @Override public void astore(MethodVisitor method) { method.visitInsn(LASTORE); }
      @Override public Type aload(MethodVisitor method) { method.visitInsn(LALOAD); return LONG; }
      @Override public Type newarray(MethodVisitor method) { method.visitIntInsn(NEWARRAY, T_LONG); return this; }
      @Override public Type getElementType() { return LONG; }
      private static final long serialVersionUID = 1L;
    });

  /** This is the singleton for numeric arrays */
  public static final ArrayType NUMBER_ARRAY = putInCache(
    new ArrayType(double[].class) {
      @Override public void astore(MethodVisitor method) { method.visitInsn(DASTORE); }
      @Override public Type aload(MethodVisitor method) { method.visitInsn(DALOAD); return NUMBER; }
      @Override public Type newarray(MethodVisitor method) { method.visitIntInsn(NEWARRAY, T_DOUBLE); return this; }
      @Override public Type getElementType() { return NUMBER; }
      private static final long serialVersionUID = 1L;
    });

  /** This is the singleton for object arrays */
  public static final ArrayType OBJECT_ARRAY = putInCache(
    new ArrayType(Object[].class));

  /** This type, always an object type, just a toString override */
  public static final Type THIS = new ObjectType() {
    @Override public String toString() { return "this"; }
    private static final long serialVersionUID = 1L;
  };

  /** Scope type, always an object type, just a toString override */
  public static final Type SCOPE = new ObjectType() {
    @Override public String toString() { return "scope"; }
    private static final long serialVersionUID = 1L;
  };

  static interface Unknown {
    // EMPTY - used as a class that is absolutely not compatible with a type to represent "unknown"
  }

  abstract static class ValueLessType extends Type {
    ValueLessType(String name) {
      super(name, Unknown.class, MIN_WEIGHT, 1);
    }
    @Override public Type load(MethodVisitor method, int slot) { throw new UnsupportedOperationException("load " + slot); }
    @Override public void store(MethodVisitor method, int slot) { throw new UnsupportedOperationException("store " + slot); }
    @Override public Type ldc(MethodVisitor method, Object c) { throw new UnsupportedOperationException("ldc " + c); }
    @Override public Type loadUndefined(MethodVisitor method) { throw new UnsupportedOperationException("load undefined"); }
    @Override public Type loadForcedInitializer(MethodVisitor method) { throw new UnsupportedOperationException("load forced initializer"); }
    @Override public Type convert(MethodVisitor method, Type to) { throw new UnsupportedOperationException("convert => " + to); }
    @Override public void ret(MethodVisitor method) { throw new UnsupportedOperationException("return"); }
    @Override public Type add(MethodVisitor method, int programPoint) { throw new UnsupportedOperationException("add"); }
    private static final long serialVersionUID = 1L;
  }

  /**
   * This is the unknown type which is used as initial type for type inference.
   * It has the minimum type width
   */
  public static final Type UNKNOWN = new ValueLessType("<unknown>") {
    @Override public String getDescriptor() { return "<unknown>"; }
    @Override public char getBytecodeStackType() { return 'U'; }
    private static final long serialVersionUID = 1L;
  };

  /**
   * This is the unknown type which is used as initial type for type inference.
   * It has the minimum type width
   */
  public static final Type SLOT_2 = new ValueLessType("<slot_2>") {
    @Override public String getDescriptor() { return "<slot_2>"; }
    @Override public char getBytecodeStackType() { throw new UnsupportedOperationException("getBytecodeStackType"); }
    private static final long serialVersionUID = 1L;
  };

  static <T extends Type> T putInCache(T type) {
    cache.put(type.getTypeClass(), type);
    return type;
  }

  /**
   * Read resolve
   * @return resolved type
   */
  protected final Object readResolve() {
    return Type.typeFor(typeClass);
  }

  private static final long serialVersionUID = 1L;
}
