package es.codegen;

import java.util.EnumSet;
import java.util.LinkedList;
import java.util.List;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import es.codegen.ClassEmitter.Flag;
import es.codegen.types.Type;
import es.runtime.AccessorProperty;
import es.runtime.AllocationStrategy;
import es.runtime.Context;
import es.runtime.FunctionScope;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.Undefined;
import es.runtime.UnwarrantedOptimismException;
import es.runtime.logging.DebugLogger;
import es.runtime.logging.Loggable;
import es.runtime.logging.Logger;
import static es.codegen.Compiler.SCRIPTS_PACKAGE;
import static es.codegen.CompilerConstants.*;
import static es.lookup.Lookup.MH;
import static es.runtime.JSType.*;
import static es.runtime.UnwarrantedOptimismException.isValid;

/**
 * Generates the ScriptObject subclass structure with fields for a user objects.
 */
@Logger(name = "fields")
public final class ObjectClassGenerator implements Loggable {

  // Type guard to make sure we don't unnecessarily explode field storages.
  // Rather unbox e.g. a java.lang.Number than blow up the field.
  // Gradually, optimistic types should create almost no boxed types
  private static final MethodHandle IS_TYPE_GUARD = findOwnMH("isType", boolean.class, Class.class, Object.class);

  // Marker for scope parameters
  private static final String SCOPE_MARKER = "P";

  // Minimum number of extra fields in an object.
  static final int FIELD_PADDING = 4;

  // Debug field logger
  // Should we print debugging information for fields when they are generated and getters/setters are called?
  private final DebugLogger log;

  // Field types for object-only fields
  private static final Type[] FIELD_TYPES_OBJECT = new Type[]{Type.OBJECT};

  // Field types for dual primitive/object fields
  private static final Type[] FIELD_TYPES_DUAL = new Type[]{Type.LONG, Type.OBJECT};

  /** What type is the primitive type in dual representation */
  public static final Type PRIMITIVE_FIELD_TYPE = Type.LONG;

  private static final MethodHandle GET_DIFFERENT = findOwnMH("getDifferent", Object.class, Object.class, Class.class, MethodHandle.class, MethodHandle.class, int.class);
  private static final MethodHandle GET_DIFFERENT_UNDEFINED = findOwnMH("getDifferentUndefined", Object.class, int.class);

  private static boolean initialized = false;

  // The context
  private final Context context;

  private final boolean dualFields;

  /**
   * Constructor
   *
   * @param context a context
   * @param dualFields whether to use dual fields representation
   */
  public ObjectClassGenerator(Context context, boolean dualFields) {
    this.context = context;
    this.dualFields = dualFields; // TODO: required; remove this check
    assert context != null;
    this.log = initLogger(context);
    if (!initialized) {
      initialized = true;
      if (!dualFields) {
        log.warning("Running with object fields only - this is a deprecated configuration.");
      }
    }
  }

  @Override
  public DebugLogger getLogger() {
    return log;
  }

  @Override
  public DebugLogger initLogger(Context ctxt) {
    return ctxt.getLogger(this.getClass());
  }

  /**
   * Pack a number into a primitive long field
   * @param n number object
   * @return primitive long value with all the bits in the number
   */
  public static long pack(Number n) {
    if (n instanceof Integer) {
      return n.intValue();
    } else if (n instanceof Long) {
      return n.longValue();
    } else if (n instanceof Double) {
      return Double.doubleToRawLongBits(n.doubleValue());
    }
    throw new AssertionError("cannot pack" + n);
  }

  static String getPrefixName(boolean dualFields) {
    return dualFields ? JS_OBJECT_DUAL_FIELD_PREFIX.symbolName() : JS_OBJECT_SINGLE_FIELD_PREFIX.symbolName();
  }

  static String getPrefixName(String className) {
    if (className.startsWith(JS_OBJECT_DUAL_FIELD_PREFIX.symbolName())) {
      return getPrefixName(true);
    } else if (className.startsWith(JS_OBJECT_SINGLE_FIELD_PREFIX.symbolName())) {
      return getPrefixName(false);
    }
    throw new AssertionError("Not a structure class: " + className);
  }

  /**
   * Returns the class name for JavaScript objects with fieldCount fields.
   * @param fieldCount Number of fields to allocate.
   * @param dualFields whether to use dual fields representation
   * @return The class name.
   */
  public static String getClassName(int fieldCount, boolean dualFields) {
    var prefix = getPrefixName(dualFields);
    return fieldCount != 0 ? SCRIPTS_PACKAGE + '/' + prefix + fieldCount : SCRIPTS_PACKAGE + '/' + prefix;
  }

  /**
   * Returns the class name for JavaScript scope with fieldCount fields and paramCount parameters.
   * @param fieldCount Number of fields to allocate.
   * @param paramCount Number of parameters to allocate
   * @param dualFields whether to use dual fields representation
   * @return The class name.
   */
  public static String getClassName(int fieldCount, int paramCount, boolean dualFields) {
    return SCRIPTS_PACKAGE + '/' + getPrefixName(dualFields) + fieldCount + SCOPE_MARKER + paramCount;
  }

  /**
   * Returns the number of fields in the JavaScript scope class.
   * Its name had to be generated using either {@link #getClassName(int, boolean)} or {@link #getClassName(int, int, boolean)}.
   * @param type the JavaScript scope class.
   * @return the number of fields in the scope class.
   */
  public static int getFieldCount(Class<?> type) {
    var name = type.getSimpleName();
    var prefix = getPrefixName(name);
    if (prefix.equals(name)) {
      return 0;
    }
    var scopeMarker = name.indexOf(SCOPE_MARKER);
    return Integer.parseInt(scopeMarker == -1 ? name.substring(prefix.length()) : name.substring(prefix.length(), scopeMarker));
  }

  /**
   * Returns the name of a field based on number and type.
   * @param fieldIndex Ordinal of field.
   * @param type       Type of field.
   * @return The field name.
   */
  public static String getFieldName(int fieldIndex, Type type) {
    return type.getDescriptor().substring(0, 1) + fieldIndex;
  }

  /**
   * In the world of Object fields, we also have no undefined SwitchPoint, to reduce as much potential MethodHandle overhead as possible.
   * In that case, we explicitly need to assign undefined to fields when we initialize them.
   * @param init       constructor to generate code in
   * @param className  name of class
   * @param fieldNames fields to initialize to undefined, where applicable
   */
  void initializeToUndefined(MethodEmitter init, String className, List<String> fieldNames) {
    if (dualFields) {
      // no need to initialize anything to undefined in the dual field world - then we have a constant getter for undefined for any unknown type
      return;
    }
    if (fieldNames.isEmpty()) {
      return;
    }
    init.load(Type.OBJECT, JAVA_THIS.slot());
    init.loadUndefined(Type.OBJECT);
    var iter = fieldNames.iterator();
    while (iter.hasNext()) {
      var fieldName = iter.next();
      if (iter.hasNext()) {
        init.dup2();
      }
      init.putField(className, fieldName, Type.OBJECT.getDescriptor());
    }
  }

  /**
   * Generate the byte codes for a JavaScript object class or scope.
   * Class name is a function of number of fields and number of param fields
   * @param descriptor Descriptor pulled from class name.
   * @return Byte codes for generated class.
   */
  public byte[] generate(String descriptor) {
    var counts = descriptor.split(SCOPE_MARKER);
    var fieldCount = Integer.valueOf(counts[0]);
    if (counts.length == 1) {
      return generate(fieldCount);
    }
    var paramCount = Integer.valueOf(counts[1]);
    return generate(fieldCount, paramCount);
  }

  /**
   * Generate the byte codes for a JavaScript object class with fieldCount fields.
   * @param fieldCount Number of fields in the JavaScript object.
   * @return Byte codes for generated class.
   */
  public byte[] generate(int fieldCount) {
    var className = getClassName(fieldCount, dualFields);
    var superName = className(ScriptObject.class);
    var classEmitter = newClassEmitter(className, superName);
    addFields(classEmitter, fieldCount);
    var init = newInitMethod(classEmitter);
    init.returnVoid();
    init.end();
    var initWithSpillArrays = newInitWithSpillArraysMethod(classEmitter, ScriptObject.class);
    initWithSpillArrays.returnVoid();
    initWithSpillArrays.end();
    newEmptyInit(className, classEmitter);
    newAllocate(className, classEmitter);
    return toByteArray(className, classEmitter);
  }

  /**
   * Generate the byte codes for a JavaScript scope class with fieldCount fields and paramCount parameters.
   * @param fieldCount Number of fields in the JavaScript scope.
   * @param paramCount Number of parameters in the JavaScript scope
   * @return Byte codes for generated class.
   */
  public byte[] generate(int fieldCount, int paramCount) {
    var className = getClassName(fieldCount, paramCount, dualFields);
    var superName = className(FunctionScope.class);
    var classEmitter = newClassEmitter(className, superName);
    var initFields = addFields(classEmitter, fieldCount);
    var init = newInitScopeMethod(classEmitter);
    initializeToUndefined(init, className, initFields);
    init.returnVoid();
    init.end();
    var initWithSpillArrays = newInitWithSpillArraysMethod(classEmitter, FunctionScope.class);
    initializeToUndefined(initWithSpillArrays, className, initFields);
    initWithSpillArrays.returnVoid();
    initWithSpillArrays.end();
    var initWithArguments = newInitScopeWithArgumentsMethod(classEmitter);
    initializeToUndefined(initWithArguments, className, initFields);
    initWithArguments.returnVoid();
    initWithArguments.end();
    return toByteArray(className, classEmitter);
  }

  /**
   * Generates the needed fields.
   * @param classEmitter Open class emitter.
   * @param fieldCount   Number of fields.
   * @return List fields that need to be initialized.
   */
  List<String> addFields(ClassEmitter classEmitter, int fieldCount) {
    var initFields = new LinkedList<String>();
    var fieldTypes = dualFields ? FIELD_TYPES_DUAL : FIELD_TYPES_OBJECT;
    for (var i = 0; i < fieldCount; i++) {
      for (var type : fieldTypes) {
        var fieldName = getFieldName(i, type);
        classEmitter.field(fieldName, type.getTypeClass());
        if (type == Type.OBJECT) {
          initFields.add(fieldName);
        }
      }
    }
    return initFields;
  }

  /**
   * Allocate and initialize a new class emitter.
   * @param className Name of JavaScript class.
   * @return Open class emitter.
   */
  ClassEmitter newClassEmitter(String className, String superName) {
    var classEmitter = new ClassEmitter(context, className, superName);
    classEmitter.begin();
    return classEmitter;
  }

  /**
   * Allocate and initialize a new <init> method.
   * @param classEmitter  Open class emitter.
   * @return Open method emitter.
   */
  static MethodEmitter newInitMethod(ClassEmitter classEmitter) {
    var init = classEmitter.init(PropertyMap.class);
    init.begin();
    init.load(Type.OBJECT, JAVA_THIS.slot());
    init.load(Type.OBJECT, INIT_MAP.slot());
    init.invoke(constructorNoLookup(ScriptObject.class, PropertyMap.class));
    return init;
  }

  static MethodEmitter newInitWithSpillArraysMethod(ClassEmitter classEmitter, Class<?> superClass) {
    var init = classEmitter.init(PropertyMap.class, long[].class, Object[].class);
    init.begin();
    init.load(Type.OBJECT, JAVA_THIS.slot());
    init.load(Type.OBJECT, INIT_MAP.slot());
    init.load(Type.LONG_ARRAY, 2);
    init.load(Type.OBJECT_ARRAY, 3);
    init.invoke(constructorNoLookup(superClass, PropertyMap.class, long[].class, Object[].class));
    return init;
  }

  /**
   * Allocate and initialize a new <init> method for scopes.
   * @param classEmitter  Open class emitter.
   * @return Open method emitter.
   */
  static MethodEmitter newInitScopeMethod(ClassEmitter classEmitter) {
    var init = classEmitter.init(PropertyMap.class, ScriptObject.class);
    init.begin();
    init.load(Type.OBJECT, JAVA_THIS.slot());
    init.load(Type.OBJECT, INIT_MAP.slot());
    init.load(Type.OBJECT, INIT_SCOPE.slot());
    init.invoke(constructorNoLookup(FunctionScope.class, PropertyMap.class, ScriptObject.class));
    return init;
  }

  /**
   * Allocate and initialize a new <init> method for scopes with arguments.
   * @param classEmitter  Open class emitter.
   * @return Open method emitter.
   */
  static MethodEmitter newInitScopeWithArgumentsMethod(ClassEmitter classEmitter) {
    var init = classEmitter.init(PropertyMap.class, ScriptObject.class, ScriptObject.class);
    init.begin();
    init.load(Type.OBJECT, JAVA_THIS.slot());
    init.load(Type.OBJECT, INIT_MAP.slot());
    init.load(Type.OBJECT, INIT_SCOPE.slot());
    init.load(Type.OBJECT, INIT_ARGUMENTS.slot());
    init.invoke(constructorNoLookup(FunctionScope.class, PropertyMap.class, ScriptObject.class, ScriptObject.class));
    return init;
  }

  /**
   * Add an empty <init> method to the JavaScript class.
   * @param classEmitter Open class emitter.
   * @param className    Name of JavaScript class.
   */
  static void newEmptyInit(String className, ClassEmitter classEmitter) {
    var emptyInit = classEmitter.init();
    emptyInit.begin();
    emptyInit.load(Type.OBJECT, JAVA_THIS.slot());
    emptyInit.loadNull();
    emptyInit.invoke(constructorNoLookup(className, PropertyMap.class));
    emptyInit.returnVoid();
    emptyInit.end();
  }

  /**
   * Add an empty <init> method to the JavaScript class.
   * @param classEmitter Open class emitter.
   * @param className    Name of JavaScript class.
   */
  static void newAllocate(String className, ClassEmitter classEmitter) {
    var allocate = classEmitter.method(EnumSet.of(Flag.PUBLIC, Flag.STATIC), ALLOCATE.symbolName(), ScriptObject.class, PropertyMap.class);
    allocate.begin();
    allocate.new_(className, Type.typeFor(ScriptObject.class));
    allocate.dup();
    allocate.load(Type.typeFor(PropertyMap.class), 0);
    allocate.invoke(constructorNoLookup(className, PropertyMap.class));
    allocate.return_();
    allocate.end();
  }

  /**
   * Collects the byte codes for a generated JavaScript class.
   * @param classEmitter Open class emitter.
   * @return Byte codes for the class.
   */
  byte[] toByteArray(String className, ClassEmitter classEmitter) {
    classEmitter.end();
    var code = classEmitter.toByteArray();
    var env = context.getEnv();
    return code;
  }

  /** Double to long bits, used with --dual-fields for primitive double values */
  public static final MethodHandle PACK_DOUBLE = MH.explicitCastArguments(MH.findStatic(MethodHandles.publicLookup(), Double.class, "doubleToRawLongBits", MH.type(long.class, double.class)), MH.type(long.class, double.class));

  /** double bits to long, used with --dual-fields for primitive double values */
  public static final MethodHandle UNPACK_DOUBLE = MH.findStatic(MethodHandles.publicLookup(), Double.class, "longBitsToDouble", MH.type(double.class, long.class));

  // type != forType, so use the correct getter for forType, box it and throw
  @SuppressWarnings("unused")
  static Object getDifferent(Object receiver, Class<?> forType, MethodHandle primitiveGetter, MethodHandle objectGetter, int programPoint) {
    //create the sametype getter, and upcast to value. no matter what the store format is,
    var sameTypeGetter = getterForType(forType, primitiveGetter, objectGetter);
    var mh = MH.asType(sameTypeGetter, sameTypeGetter.type().changeReturnType(Object.class));
    try {
      var value = mh.invokeExact(receiver);
      throw new UnwarrantedOptimismException(value, programPoint);
    } catch (Error | RuntimeException e) {
      throw e;
    } catch (Throwable e) {
      throw new RuntimeException(e);
    }
  }

  @SuppressWarnings("unused")
  static Object getDifferentUndefined(int programPoint) {
    throw new UnwarrantedOptimismException(Undefined.getUndefined(), programPoint);
  }

  static MethodHandle getterForType(Class<?> forType, MethodHandle primitiveGetter, MethodHandle objectGetter) {
    return switch (getAccessorTypeIndex(forType)) {
      case TYPE_INT_INDEX -> MH.explicitCastArguments(primitiveGetter, primitiveGetter.type().changeReturnType(int.class));
      case TYPE_DOUBLE_INDEX -> MH.filterReturnValue(primitiveGetter, UNPACK_DOUBLE);
      case TYPE_OBJECT_INDEX -> objectGetter;
      default -> throw new AssertionError(forType);
    };
  }

  // no optimism here. we do unconditional conversion to types
  static MethodHandle createGetterInner(Class<?> forType, Class<?> type, MethodHandle primitiveGetter, MethodHandle objectGetter, List<MethodHandle> converters, int programPoint) {
    var fti = forType == null ? TYPE_UNDEFINED_INDEX : getAccessorTypeIndex(forType);
    var ti = getAccessorTypeIndex(type);
    // this means fail if forType != type
    var isOptimistic = converters == CONVERT_OBJECT_OPTIMISTIC;
    var isPrimitiveStorage = forType != null && forType.isPrimitive();
    // which is the primordial getter
    var getter = primitiveGetter == null ? objectGetter : isPrimitiveStorage ? primitiveGetter : objectGetter;
    if (forType == null) {
      if (isOptimistic) {
        // return undefined if asking for object. otherwise throw UnwarrantedOptimismException
        if (ti == TYPE_OBJECT_INDEX) {
          return MH.dropArguments(GET_UNDEFINED.get(TYPE_OBJECT_INDEX), 0, Object.class);
        }
        // throw exception
        return MH.asType(MH.dropArguments(MH.insertArguments(GET_DIFFERENT_UNDEFINED, 0, programPoint), 0, Object.class), getter.type().changeReturnType(type));
      }
      // return an undefined and coerce it to the appropriate type
      return MH.dropArguments(GET_UNDEFINED.get(ti), 0, Object.class);
    }
    assert primitiveGetter != null || forType == Object.class : forType;
    if (isOptimistic) {
      if (fti < ti) {
        // asking for a wider type than currently stored; then it's OK to coerce.
        // e.g. stored as int,  ask for long or double
        // e.g. stored as long, ask for double
        assert fti != TYPE_UNDEFINED_INDEX;
        var tgetter = getterForType(forType, primitiveGetter, objectGetter);
        return MH.asType(tgetter, tgetter.type().changeReturnType(type));
      } else if (fti == ti) {
        // Fast path, never throw exception - exact getter, just unpack if needed
        return getterForType(forType, primitiveGetter, objectGetter);
      } else {
        assert fti > ti;
        // if asking for a narrower type than the storage - throw exception unless FTI is object, in that case we have to go through the converters there is no
        if (fti == TYPE_OBJECT_INDEX) {
          return MH.filterReturnValue(objectGetter, MH.insertArguments(converters.get(ti), 1, programPoint));
        }
        // asking for narrower primitive than we have stored, that is an UnwarrantedOptimismException
        return MH.asType(MH.filterArguments(objectGetter, 0, MH.insertArguments(GET_DIFFERENT, 1, forType, primitiveGetter, objectGetter, programPoint)), objectGetter.type().changeReturnType(type));
      }
    }
    assert !isOptimistic;
    // freely coerce the result to whatever you asked for, this is e.g. Object->int for a & b
    var tgetter = getterForType(forType, primitiveGetter, objectGetter);
    if (fti == TYPE_OBJECT_INDEX) {
      if (fti != ti) {
        return MH.filterReturnValue(tgetter, CONVERT_OBJECT.get(ti));
      }
      return tgetter;
    }
    assert primitiveGetter != null;
    var tgetterType = tgetter.type();
    return switch (fti) {
      case TYPE_INT_INDEX -> MH.asType(tgetter, tgetterType.changeReturnType(type));
      case TYPE_DOUBLE_INDEX -> {
        yield switch (ti) {
          case TYPE_INT_INDEX -> MH.filterReturnValue(tgetter, JSType.TO_INT32_D.methodHandle);
          case TYPE_DOUBLE_INDEX -> {
            assert tgetterType.returnType() == double.class;
            yield tgetter;
          }
          default -> MH.asType(tgetter, tgetterType.changeReturnType(Object.class));
        };
      }
      default -> throw new UnsupportedOperationException(forType + "=>" + type);
    };
  }

  /**
   * Given a primitiveGetter (optional for non dual fields) and an objectSetter that retrieve the primitive and object version of a field respectively, return one with the correct method type and the correct filters.
   * For example, if the value is stored as a double and we want an Object getter, in the dual fields world we'd pick the primitiveGetter, which reads a long, use longBitsToDouble on the result to unpack it, and then change the return type to Object, boxing it.
   * In the objects only world there are only object fields, primitives are boxed when asked for them and we don't need to bother with primitive encoding (or even undefined, which if forType==null) representation, so we just return whatever is in the object field.
   * The object field is always initiated to Undefined, so here, where we have the representation for Undefined in all our bits, this is not a problem.
   * <p>
   * Representing undefined in a primitive is hard, for an int there aren't enough bits, for a long we could limit the width of a representation, and for a double (as long as it is stored as long, as all NaNs will turn into QNaN on ia32, which is one bit pattern, we should use a special NaN).
   * Naturally we could have special undefined values for all types which mean "go look in a wider field", but the guards needed on every getter took too much time.
   * <p>
   * To see how this is used, look for example in {@link AccessorProperty#getGetter}
   * <p>
   * @param forType         representation of the underlying type in the field, null if undefined
   * @param type            type to retrieve it as
   * @param primitiveGetter getter to read the primitive version of this field (null if Objects Only)
   * @param objectGetter    getter to read the object version of this field
   * @param programPoint    program point for getter, if program point is INVALID_PROGRAM_POINT, then this is not an optimistic getter
   * @return getter for the given representation that returns the given type
   */
  public static MethodHandle createGetter(Class<?> forType, Class<?> type, MethodHandle primitiveGetter, MethodHandle objectGetter, int programPoint) {
    return createGetterInner(forType, type, primitiveGetter, objectGetter, isValid(programPoint) ? CONVERT_OBJECT_OPTIMISTIC : CONVERT_OBJECT, programPoint);
  }

  /**
   * This is similar to the {@link ObjectClassGenerator#createGetter} function.
   * Performs the necessary operations to massage a setter operand of type {@code type} to fit into the primitive field (if primitive and dual fields is enabled) or into the object field (box if primitive and dual fields is disabled)
   * @param forType         representation of the underlying object
   * @param type            representation of field to write, and setter signature
   * @param primitiveSetter setter that writes to the primitive field (null if Objects Only)
   * @param objectSetter    setter that writes to the object field
   * @return the setter for the given representation that takes a {@code type}
   */
  public static MethodHandle createSetter(Class<?> forType, Class<?> type, MethodHandle primitiveSetter, MethodHandle objectSetter) {
    assert forType != null;
    var fti = getAccessorTypeIndex(forType);
    var ti = getAccessorTypeIndex(type);
    if (fti == TYPE_OBJECT_INDEX || primitiveSetter == null) {
      return (ti == TYPE_OBJECT_INDEX) ? objectSetter : MH.asType(objectSetter, objectSetter.type().changeParameterType(1, type));
    }
    var pmt = primitiveSetter.type();
    return switch (fti) {
      case TYPE_INT_INDEX -> {
        yield switch (ti) {
          case TYPE_INT_INDEX -> MH.asType(primitiveSetter, pmt.changeParameterType(1, int.class));
          case TYPE_DOUBLE_INDEX -> MH.filterArguments(primitiveSetter, 1, PACK_DOUBLE);
          default -> objectSetter;
        };
      }
      case TYPE_DOUBLE_INDEX -> {
        yield (ti == TYPE_OBJECT_INDEX) ? objectSetter : MH.asType(MH.filterArguments(primitiveSetter, 1, PACK_DOUBLE), pmt.changeParameterType(1, type));
      }
      default -> throw new UnsupportedOperationException(forType + "=>" + type);
    };
  }

  @SuppressWarnings("unused")
  static boolean isType(Class<?> boxedForType, Object x) {
    return x != null && x.getClass() == boxedForType;
  }

  static Class<? extends Number> getBoxedType(Class<?> forType) {
    if (forType == int.class) {
      return Integer.class;
    }
    if (forType == long.class) {
      return Long.class;
    }
    if (forType == double.class) {
      return Double.class;
    }
    assert false;
    return null;
  }

  /**
   * If we are setting boxed types (because the compiler couldn't determine which they were) to a primitive field, we can reuse the primitive field getter, as long as we are setting an element of the same boxed type as the primitive type representation.
   * @param forType           the current type
   * @param primitiveSetter   primitive setter for the current type with an element of the current type
   * @param objectSetter      the object setter
   * @return method handle that checks if the element to be set is of the current type, even though it's boxed and instead of using the generic object setter, that would blow up the type and invalidate the map, unbox it and call the primitive setter instead
   */
  public static MethodHandle createGuardBoxedPrimitiveSetter(Class<?> forType, MethodHandle primitiveSetter, MethodHandle objectSetter) {
    var boxedForType = getBoxedType(forType);
    // object setter that checks for primitive if current type is primitive
    return MH.guardWithTest(MH.insertArguments(MH.dropArguments(IS_TYPE_GUARD, 1, Object.class), 0, boxedForType), MH.asType(primitiveSetter, objectSetter.type()), objectSetter);
  }

  /**
   * Add padding to field count to avoid creating too many classes and have some spare fields
   * @param count the field count
   * @return the padded field count
   */
  static int getPaddedFieldCount(int count) {
    return count / FIELD_PADDING * FIELD_PADDING + FIELD_PADDING;
  }

  static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), ObjectClassGenerator.class, name, MH.type(rtype, types));
  }

  /**
   * Creates the allocator class name and property map for a constructor function with the specified number of "this" properties that it initializes.
   * @param thisProperties number of properties assigned to "this"
   * @return the allocation strategy
   */
  static AllocationStrategy createAllocationStrategy(int thisProperties, boolean dualFields) {
    var paddedFieldCount = getPaddedFieldCount(thisProperties);
    return new AllocationStrategy(paddedFieldCount, dualFields);
  }

}
