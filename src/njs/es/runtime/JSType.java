package es.runtime;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.reflect.Array;

import jdk.dynalink.SecureLookupSupplier;
import jdk.dynalink.beans.StaticClass;

import nash.scripting.JSObject;

import es.codegen.CompilerConstants.Call;
import static es.codegen.CompilerConstants.staticCall;
import es.codegen.types.Type;
import static es.lookup.Lookup.MH;
import es.objects.Global;
import es.objects.NativeSymbol;
import es.parser.Lexer;
import static es.runtime.ECMAErrors.typeError;
import es.runtime.arrays.ArrayLikeIterator;
import es.runtime.linker.Bootstrap;

/**
 * Representation for ECMAScript types - this maps directly to the ECMA script standard
 */
public enum JSType {
  /** The undefined type */
  UNDEFINED("undefined"),
  /** The null type */
  NULL("object"),
  /** The boolean type */
  BOOLEAN("boolean"),
  /** The number type */
  NUMBER("number"),
  /** The string type */
  STRING("string"),
  /** The object type */
  OBJECT("object"),
  /** The function type */
  FUNCTION("function"),
  /** The symbol type */
  SYMBOL("symbol");

  // The type name as returned by ECMAScript "typeof" operator
  private final String typeName;

  /** Max value for an uint32 in JavaScript */
  public static final long MAX_UINT = 0xFFFF_FFFFL;

  private static final MethodHandles.Lookup JSTYPE_LOOKUP = MethodHandles.lookup();

  /** JavaScript compliant conversion function from Object to boolean */
  public static final Call TO_BOOLEAN = staticCall(JSTYPE_LOOKUP, JSType.class, "toBoolean", boolean.class, Object.class);

  /** JavaScript compliant conversion function from number to boolean */
  public static final Call TO_BOOLEAN_D = staticCall(JSTYPE_LOOKUP, JSType.class, "toBoolean", boolean.class, double.class);

  /** JavaScript compliant conversion function from int to boolean */
  public static final Call TO_BOOLEAN_I = staticCall(JSTYPE_LOOKUP, JSType.class, "toBoolean", boolean.class, int.class);

  /** JavaScript compliant conversion function from Object to integer */
  public static final Call TO_INTEGER = staticCall(JSTYPE_LOOKUP, JSType.class, "toInteger", int.class, Object.class);

  /** JavaScript compliant conversion function from Object to long */
  public static final Call TO_LONG = staticCall(JSTYPE_LOOKUP, JSType.class, "toLong", long.class, Object.class);

  /** JavaScript compliant conversion function from double to long */
  public static final Call TO_LONG_D = staticCall(JSTYPE_LOOKUP, JSType.class, "toLong", long.class, double.class);

  /** JavaScript compliant conversion function from Object to number */
  public static final Call TO_NUMBER = staticCall(JSTYPE_LOOKUP, JSType.class, "toNumber", double.class, Object.class);

  /** JavaScript compliant conversion function from Object to number with type check */
  public static final Call TO_NUMBER_OPTIMISTIC = staticCall(JSTYPE_LOOKUP, JSType.class, "toNumberOptimistic", double.class, Object.class, int.class);

  /** JavaScript compliant conversion function from Object to String */
  public static final Call TO_STRING = staticCall(JSTYPE_LOOKUP, JSType.class, "toString", String.class, Object.class);

  /** JavaScript compliant conversion function from Object to int32 */
  public static final Call TO_INT32 = staticCall(JSTYPE_LOOKUP, JSType.class, "toInt32", int.class, Object.class);

  /** JavaScript compliant conversion function from Object to int32 */
  public static final Call TO_INT32_L = staticCall(JSTYPE_LOOKUP, JSType.class, "toInt32", int.class, long.class);

  /** JavaScript compliant conversion function from Object to int32 with type check */
  public static final Call TO_INT32_OPTIMISTIC = staticCall(JSTYPE_LOOKUP, JSType.class, "toInt32Optimistic", int.class, Object.class, int.class);

  /** JavaScript compliant conversion function from double to int32 */
  public static final Call TO_INT32_D = staticCall(JSTYPE_LOOKUP, JSType.class, "toInt32", int.class, double.class);

  /** JavaScript compliant conversion function from int to uint32 */
  public static final Call TO_UINT32_OPTIMISTIC = staticCall(JSTYPE_LOOKUP, JSType.class, "toUint32Optimistic", int.class, int.class, int.class);

  /** JavaScript compliant conversion function from int to uint32 */
  public static final Call TO_UINT32_DOUBLE = staticCall(JSTYPE_LOOKUP, JSType.class, "toUint32Double", double.class, int.class);

  /** JavaScript compliant conversion function from Object to uint32 */
  public static final Call TO_UINT32 = staticCall(JSTYPE_LOOKUP, JSType.class, "toUint32", long.class, Object.class);

  /** JavaScript compliant conversion function from number to uint32 */
  public static final Call TO_UINT32_D = staticCall(JSTYPE_LOOKUP, JSType.class, "toUint32", long.class, double.class);

  /** JavaScript compliant conversion function from number to String */
  public static final Call TO_STRING_D = staticCall(JSTYPE_LOOKUP, JSType.class, "toString", String.class, double.class);

  /** Combined call to toPrimitive followed by toString. */
  public static final Call TO_PRIMITIVE_TO_STRING = staticCall(JSTYPE_LOOKUP, JSType.class, "toPrimitiveToString", String.class, Object.class);

  /** Combined call to toPrimitive followed by toCharSequence. */
  public static final Call TO_PRIMITIVE_TO_CHARSEQUENCE = staticCall(JSTYPE_LOOKUP, JSType.class, "toPrimitiveToCharSequence", CharSequence.class, Object.class);

  /** Throw an unwarranted optimism exception */
  public static final Call THROW_UNWARRANTED = staticCall(JSTYPE_LOOKUP, JSType.class, "throwUnwarrantedOptimismException", Object.class, Object.class, int.class);

  /** Add exact wrapper for potentially overflowing integer operations */
  public static final Call ADD_EXACT = staticCall(JSTYPE_LOOKUP, JSType.class, "addExact", int.class, int.class, int.class, int.class);

  /** Sub exact wrapper for potentially overflowing integer operations */
  public static final Call SUB_EXACT = staticCall(JSTYPE_LOOKUP, JSType.class, "subExact", int.class, int.class, int.class, int.class);

  /** Multiply exact wrapper for potentially overflowing integer operations */
  public static final Call MUL_EXACT = staticCall(JSTYPE_LOOKUP, JSType.class, "mulExact", int.class, int.class, int.class, int.class);

  /** Div exact wrapper for potentially integer division that turns into float point */
  public static final Call DIV_EXACT = staticCall(JSTYPE_LOOKUP, JSType.class, "divExact", int.class, int.class, int.class, int.class);

  /** Div zero wrapper for integer division that handles (0/0)|0 == 0 */
  public static final Call DIV_ZERO = staticCall(JSTYPE_LOOKUP, JSType.class, "divZero", int.class, int.class, int.class);

  /** Mod zero wrapper for integer division that handles (0%0)|0 == 0 */
  public static final Call REM_ZERO = staticCall(JSTYPE_LOOKUP, JSType.class, "remZero", int.class, int.class, int.class);

  /** Mod exact wrapper for potentially integer remainders that turns into float point */
  public static final Call REM_EXACT = staticCall(JSTYPE_LOOKUP, JSType.class, "remExact", int.class, int.class, int.class, int.class);

  /** Decrement exact wrapper for potentially overflowing integer operations */
  public static final Call DECREMENT_EXACT = staticCall(JSTYPE_LOOKUP, JSType.class, "decrementExact", int.class, int.class, int.class);

  /** Increment exact wrapper for potentially overflowing integer operations */
  public static final Call INCREMENT_EXACT = staticCall(JSTYPE_LOOKUP, JSType.class, "incrementExact", int.class, int.class, int.class);

  /** Negate exact exact wrapper for potentially overflowing integer operations */
  public static final Call NEGATE_EXACT = staticCall(JSTYPE_LOOKUP, JSType.class, "negateExact", int.class, int.class, int.class);

  /** Method handle to convert a JS Object to a Java array. */
  public static final Call TO_JAVA_ARRAY = staticCall(JSTYPE_LOOKUP, JSType.class, "toJavaArray", Object.class, Object.class, Class.class);

  /** Method handle to convert a JS Object to a Java array. */
  public static final Call TO_JAVA_ARRAY_WITH_LOOKUP = staticCall(JSTYPE_LOOKUP, JSType.class, "toJavaArrayWithLookup", Object.class, Object.class, Class.class, SecureLookupSupplier.class);

  /** Method handle for void returns. */
  public static final Call VOID_RETURN = staticCall(JSTYPE_LOOKUP, JSType.class, "voidReturn", void.class);

  /** Method handle for isString method */
  public static final Call IS_STRING = staticCall(JSTYPE_LOOKUP, JSType.class, "isString", boolean.class, Object.class);

  /** Method handle for isNumber method */
  public static final Call IS_NUMBER = staticCall(JSTYPE_LOOKUP, JSType.class, "isNumber", boolean.class, Object.class);

  // The list of available accessor types in width order.
  // This order is used for type guesses narrow{@literal ->} wide in the dual--fields world
  private static final List<Type> ACCESSOR_TYPES = List.of( Type.INT, Type.NUMBER, Type.OBJECT );

  /** table index for undefined type - hard coded so it can be used in switches at compile time */
  public static final int TYPE_UNDEFINED_INDEX = -1;
  /** table index for integer type - hard coded so it can be used in switches at compile time */
  public static final int TYPE_INT_INDEX = 0; //getAccessorTypeIndex(int.class);
  /** table index for double type - hard coded so it can be used in switches at compile time */
  public static final int TYPE_DOUBLE_INDEX = 1; //getAccessorTypeIndex(double.class);
  /** table index for object type - hard coded so it can be used in switches at compile time */
  public static final int TYPE_OBJECT_INDEX = 2; //getAccessorTypeIndex(Object.class);

  /** Object conversion quickies with JS semantics - used for return value and parameter filter. */
  public static final List<MethodHandle> CONVERT_OBJECT = toUnmodifiableList(
    JSType.TO_INT32.methodHandle(), JSType.TO_NUMBER.methodHandle(), null );

  /**
   * Object conversion quickies with JS semantics - used for return value and parameter filter, optimistic.
   * Throws exception upon incompatible type (asking for a narrower one than the storage)
   */
  public static final List<MethodHandle> CONVERT_OBJECT_OPTIMISTIC = toUnmodifiableList(
    JSType.TO_INT32_OPTIMISTIC.methodHandle(), JSType.TO_NUMBER_OPTIMISTIC.methodHandle(), null );

  /** The value of Undefined cast to an int32 */
  public static final int UNDEFINED_INT = 0;
  /** The value of Undefined cast to a long */
  public static final long UNDEFINED_LONG = 0L;
  /** The value of Undefined cast to a double */
  public static final double UNDEFINED_DOUBLE = Double.NaN;

  // Minimum and maximum range between which every long value can be precisely represented as a double.
  private static final long MAX_PRECISE_DOUBLE = 1L << 53;
  private static final long MIN_PRECISE_DOUBLE = -MAX_PRECISE_DOUBLE;

  /**
   * Method handles for getters that return undefined coerced
   * to the appropriate type
   */
  public static final List<MethodHandle> GET_UNDEFINED = List.of(
    MH.constant(int.class, UNDEFINED_INT),
    MH.constant(double.class, UNDEFINED_DOUBLE),
    MH.constant(Object.class, Undefined.getUndefined())
  );

  private static final double INT32_LIMIT = 4294967296.0;

  /**
   * Constructor
   *
   * @param typeName the type name
   */
  private JSType(String typeName) {
    this.typeName = typeName;
  }

  /**
   * The external type name as returned by ECMAScript "typeof" operator
   * @return type name for this type
   */
  public final String typeName() {
    return this.typeName;
  }

  /**
   * Return the JSType for a given object
   * @param obj an object
   * @return the JSType for the object
   */
  public static JSType of(Object obj) {
    // Order of these statements is tuned for performance (see JDK-8024476)
    return (obj == null) ? JSType.NULL
         : (obj instanceof ScriptObject) ? (obj instanceof ScriptFunction ? JSType.FUNCTION : JSType.OBJECT)
         : (obj instanceof Boolean) ? JSType.BOOLEAN
         : (isString(obj)) ? JSType.STRING
         : (isNumber(obj)) ? JSType.NUMBER
         : (obj instanceof Symbol) ? JSType.SYMBOL
         : (obj == ScriptRuntime.UNDEFINED) ? JSType.UNDEFINED
         : (Bootstrap.isCallable(obj) ? JSType.FUNCTION : JSType.OBJECT);
  }

  /**
   * Similar to {@link #of(Object)}, but does not distinguish between {@link #FUNCTION} and {@link #OBJECT}, returning {@link #OBJECT} in both cases.
   * The distinction is costly, and the EQ '==' and '===' predicates don't care about it so we maintain this version for their use.
   * @param obj an object
   * @return the JSType for the object; returns {@link #OBJECT} instead of {@link #FUNCTION} for functions.
   */
  public static JSType ofNoFunction(Object obj) {
    // Order of these statements is tuned for performance (see JDK-8024476)
    return (obj == null) ? JSType.NULL
         : (obj instanceof ScriptObject) ? JSType.OBJECT
         : (obj instanceof Boolean) ? JSType.BOOLEAN
         : (isString(obj)) ? JSType.STRING
         : (isNumber(obj)) ? JSType.NUMBER
         : (obj == ScriptRuntime.UNDEFINED) ? JSType.UNDEFINED
         : (obj instanceof Symbol) ? JSType.SYMBOL
         : JSType.OBJECT;
  }

  /**
   * Void return method handle glue
   */
  public static void voidReturn() {
    // empty
    // TODO: fix up SetMethodCreator better so we don't need this stupid thing
  }

  /**
   * Returns true if double number can be represented as an int
   * @param number a long to inspect
   * @return true for int representable longs
   */
  public static boolean isRepresentableAsInt(long number) {
    return (int) number == number;
  }

  /**
   * Returns true if double number can be represented as an int.
   * Note that it returns true for negative zero. 
   * If you need to exclude negative zero, use {@link #isNonNegativeZeroInt(double)}.
   * @param number a double to inspect
   * @return true for int representable doubles
   */
  public static boolean isRepresentableAsInt(double number) {
    return (int) number == number;
  }

  /**
   * Returns true if double number can be represented as an int.
   * Note that it returns false for negative zero.
   * If you don't need to distinguish negative zero, use {@link #isRepresentableAsInt(double)}.
   * @param number a double to inspect
   * @return true for int representable doubles
   */
  public static boolean isNonNegativeZeroInt(double number) {
    return isRepresentableAsInt(number) && isNotNegativeZero(number);
  }

  /**
   * Returns true if Object can be represented as an int
   * @param obj an object to inspect
   * @return true for int representable objects
   */
  public static boolean isRepresentableAsInt(Object obj) {
    return (obj instanceof Number n) && isRepresentableAsInt(n.doubleValue());
  }

  /**
   * Returns true if double number can be represented as a long.
   * Note that it returns true for negative zero.
   * @param number a double to inspect
   * @return true for long representable doubles
   */
  public static boolean isRepresentableAsLong(double number) {
    return (long) number == number;
  }

  /**
   * Returns true if long number can be represented as double without loss of precision.
   * @param number a long number
   * @return true if the double representation does not lose precision
   */
  public static boolean isRepresentableAsDouble(long number) {
    return MAX_PRECISE_DOUBLE >= number && number >= MIN_PRECISE_DOUBLE;
  }

  /**
   * Returns true if the number is not the negative zero ({@code -0.0d}).
   * @param number the number to test
   * @return true if it is not the negative zero, false otherwise.
   */
  private static boolean isNotNegativeZero(double number) {
    return Double.doubleToRawLongBits(number) != 0x8000000000000000L;
  }

  /**
   * Check whether an object is primitive
   * @param obj an object
   * @return true if object is primitive (includes null and undefined)
   */
  public static boolean isPrimitive(Object obj) {
    return obj == null || obj == ScriptRuntime.UNDEFINED || isString(obj) || isNumber(obj) || obj instanceof Boolean || obj instanceof Symbol;
  }

  /**
   * Primitive converter for an object
   * @param obj an object
   * @return primitive form of the object
   */
  public static Object toPrimitive(Object obj) {
    return toPrimitive(obj, null);
  }

  /**
   * Primitive converter for an object including type hint
   * See ECMA 9.1 ToPrimitive
   * @param obj  an object
   * @param hint a type hint
   * @return the primitive form of the object
   */
  public static Object toPrimitive(Object obj, Class<?> hint) {
    if (obj instanceof ScriptObject so) {
      return toPrimitive(so, hint);
    } else if (isPrimitive(obj)) {
      return obj;
    } else if (hint == Number.class && obj instanceof Number n) {
      return n.doubleValue();
    } else if (obj instanceof JSObject jso) {
      return toPrimitive(jso, hint);
    } else if (obj instanceof StaticClass sc) {
      var name = sc.getRepresentedClass().getName();
      return new StringBuilder(12 + name.length()).append("[JavaClass ").append(name).append(']').toString();
    }
    return obj.toString();
  }

  static Object toPrimitive(ScriptObject sobj, Class<?> hint) {
    return requirePrimitive(sobj.getDefaultValue(hint));
  }

  static Object requirePrimitive(Object result) {
    if (!isPrimitive(result)) {
      throw typeError("bad.default.value", result.toString());
    }
    return result;
  }

  /**
   * Primitive converter for a {@link JSObject} including type hint.
   * Invokes {@link JSObject#getDefaultValue(Class)} and translates any thrown {@link UnsupportedOperationException} to a ECMAScript {@code TypeError}.
   * See ECMA 9.1 ToPrimitive
   * @param jsobj  a JSObject
   * @param hint a type hint
   * @return the primitive form of the JSObject
   */
  public static Object toPrimitive(JSObject jsobj, Class<?> hint) {
    try {
      return requirePrimitive(jsobj.getDefaultValue(hint));
    } catch (UnsupportedOperationException e) {
      throw new ECMAException(Context.getGlobal().newTypeError(e.getMessage()), e);
    }
  }

  /**
   * Combines a hintless toPrimitive and a toString call.
   * @param obj  an object
   * @return the string form of the primitive form of the object
   */
  public static String toPrimitiveToString(Object obj) {
    return toString(toPrimitive(obj));
  }

  /**
   * Like {@link #toPrimitiveToString(Object)}, but avoids conversion of ConsString to String.
   * @param obj  an object
   * @return the CharSequence form of the primitive form of the object
   */
  public static CharSequence toPrimitiveToCharSequence(Object obj) {
    return toCharSequence(toPrimitive(obj));
  }

  /**
   * JavaScript compliant conversion of number to boolean
   * @param num a number
   * @return a boolean
   */
  public static boolean toBoolean(double num) {
    return num != 0 && !Double.isNaN(num);
  }

  /**
   * JavaScript compliant conversion of int to boolean
   * @param num an int
   * @return a boolean
   */
  public static boolean toBoolean(int num) {
    return num != 0;
  }

  /**
   * JavaScript compliant conversion of Object to boolean
   * See ECMA 9.2 ToBoolean
   * @param obj an object
   * @return a boolean
   */
  public static boolean toBoolean(Object obj) {
    if (obj instanceof Boolean b) {
      return b;
    }
    if (nullOrUndefined(obj)) {
      return false;
    }
    if (obj instanceof Number n) {
      var num = n.doubleValue();
      return num != 0 && !Double.isNaN(num);
    }
    if (isString(obj)) {
      return ((CharSequence) obj).length() > 0;
    }
    return true;
  }

  /**
   * JavaScript compliant converter of Object to String
   * See ECMA 9.8 ToString
   * @param obj an object
   * @return a string
   */
  public static String toString(Object obj) {
    return toStringImpl(obj, false);
  }

  /**
   * See ES6 #7.1.14
   * @param obj key object
   * @return property key
   */
  public static Object toPropertyKey(Object obj) {
    return obj instanceof Symbol ? obj : toStringImpl(obj, false);
  }

  /**
   * If obj is an instance of {@link ConsString} cast to CharSequence, else return result of {@link #toString(Object)}.
   * @param obj an object
   * @return an instance of String or ConsString
   */
  public static CharSequence toCharSequence(Object obj) {
    return (obj instanceof ConsString cs) ? cs : toString(obj);
  }

  /**
   * Returns true if object represents a primitive JavaScript string value.
   * @param obj the object
   * @return true if the object represents a primitive JavaScript string value.
   */
  public static boolean isString(Object obj) {
    return obj instanceof String || obj instanceof ConsString;
  }

  /**
   * Returns true if object represents a primitive JavaScript number value.
   * Note that we only treat wrapper objects of Java primitive number types as objects that can be fully represented as JavaScript numbers (doubles).
   * This means we exclude {@code long} and special purpose Number instances such as {@link java.util.concurrent.atomic.AtomicInteger}, as well as arbitrary precision numbers such as {@link java.math.BigInteger}.
   * @param obj the object
   * @return true if the object represents a primitive JavaScript number value.
   */
  public static boolean isNumber(Object obj) {
    if (obj != null) {
      var c = obj.getClass();
      return c == Integer.class || c == Double.class || c == Float.class || c == Short.class || c == Byte.class;
    }
    return false;
  }

  /**
   * JavaScript compliant conversion of integer to String
   * @param num an integer
   * @return a string
   */
  public static String toString(int num) {
    return Integer.toString(num);
  }

  /**
   * JavaScript compliant conversion of number to String
   * See ECMA 9.8.1
   * @param num a number
   * @return a string
   */
  public static String toString(double num) {
    if (isRepresentableAsInt(num)) {
      return Integer.toString((int) num);
    }
    if (num == Double.POSITIVE_INFINITY) {
      return "Infinity";
    }
    if (num == Double.NEGATIVE_INFINITY) {
      return "-Infinity";
    }
    if (Double.isNaN(num)) {
      return "NaN";
    }
    return Double.toString(num); // DoubleConversion.toShortestString(num);
  }

  /**
   * JavaScript compliant conversion of number to String
   * @param num   a number
   * @param radix a radix for the conversion
   * @return a string
   */
  public static String toString(double num, int radix) {
    assert radix >= 2 && radix <= 36 : "invalid radix";
    if (isRepresentableAsInt(num)) {
      return Integer.toString((int) num, radix);
    }
    if (num == Double.POSITIVE_INFINITY) {
      return "Infinity";
    }
    if (num == Double.NEGATIVE_INFINITY) {
      return "-Infinity";
    }
    if (Double.isNaN(num)) {
      return "NaN";
    }
    if (num == 0.0) {
      return "0";
    }
    var chars = "0123456789abcdefghijklmnopqrstuvwxyz";
    var sb = new StringBuilder();
    var negative = num < 0.0;
    var signedNum = negative ? -num : num;
    var intPart = Math.floor(signedNum);
    var decPart = signedNum - intPart;
    // encode integer part from least significant digit, then reverse
    do {
      var remainder = intPart % radix;
      sb.append(chars.charAt((int) remainder));
      intPart -= remainder;
      intPart /= radix;
    } while (intPart >= 1.0);
    if (negative) {
      sb.append('-');
    }
    sb.reverse();
    // encode decimal part
    if (decPart > 0.0) {
      var dot = sb.length();
      sb.append('.');
      do {
        decPart *= radix;
        var d = Math.floor(decPart);
        sb.append(chars.charAt((int) d));
        decPart -= d;
      } while (decPart > 0.0 && sb.length() - dot < 1100);
      // somewhat arbitrarily use same limit as V8
    }
    return sb.toString();
  }

  /**
   * JavaScript compliant conversion of Object to number
   * See ECMA 9.3 ToNumber
   * @param obj  an object
   * @return a number
   */
  public static double toNumber(Object obj) {
    if (obj instanceof Double d) {
      return d;
    }
    if (obj instanceof Number n) {
      return n.doubleValue();
    }
    return toNumberGeneric(obj);
  }

  /**
   * Converts an object for a comparison with a number.
   * Almost identical to {@link #toNumber(Object)} but converts {@code null} to {@code NaN} instead of zero, so it won't compare equal to zero.
   * @param obj  an object
   * @return a number
   */
  public static double toNumberForEq(Object obj) {
    // we are not able to detect Symbol objects from codegen, so we need to handle them here to avoid throwing an error in toNumber conversion.
    return obj == null || obj instanceof Symbol || obj instanceof NativeSymbol ? Double.NaN : toNumber(obj);
  }

  /**
   * Converts an object for equivalence comparison with a number.
   * Returns {@code NaN} for any object that is not a {@link Number}, so only boxed numerics can compare equivalently to numbers.
   * @param obj  an object
   * @return a number
   */
  public static double toNumberForEquiv(Object obj) {
    if (obj instanceof Double d) {
      return d;
    }
    if (isNumber(obj)) {
      return ((Number) obj).doubleValue();
    }
    return Double.NaN;
  }

  /**
   * Convert a long to the narrowest JavaScript Number type.
   * This returns either a {@link Integer} or {@link Double} depending on the magnitude of {@code l}.
   * @param l a long value
   * @return the value converted to Integer or Double
   */
  public static Number toNarrowestNumber(long l) {
    return isRepresentableAsInt(l) ? Integer.valueOf((int) l) : Double.valueOf(l);
  }

  /**
   * JavaScript compliant conversion of Boolean to number
   * See ECMA 9.3 ToNumber
   * @param b a boolean
   * @return JS numeric value of the boolean: 1.0 or 0.0
   */
  public static double toNumber(Boolean b) {
    return b ? 1d : +0d;
  }

  /**
   * JavaScript compliant conversion of Object to number
   * See ECMA 9.3 ToNumber
   * @param obj  an object
   * @return a number
   */
  public static double toNumber(ScriptObject obj) {
    return toNumber(toPrimitive(obj, Number.class));
  }

  /**
   * Optimistic number conversion - throws UnwarrantedOptimismException if Object
   * @param obj           object to convert
   * @param programPoint  program point
   * @return double
   */
  public static double toNumberOptimistic(Object obj, int programPoint) {
    if (obj != null) {
      var clz = obj.getClass();
      if (clz == Double.class || clz == Integer.class || clz == Long.class) {
        return ((Number) obj).doubleValue();
      }
    }
    throw new UnwarrantedOptimismException(obj, programPoint);
  }

  /**
   * Object to number conversion that delegates to either {@link #toNumber(Object)} or to {@link #toNumberOptimistic(Object, int)} depending on whether the program point is valid or not.
   * @param obj the object to convert
   * @param programPoint the program point; can be invalid.
   * @return the value converted to a number
   * @throws UnwarrantedOptimismException if the value can't be represented as a number and the program point is valid.
   */
  public static double toNumberMaybeOptimistic(Object obj, int programPoint) {
    return UnwarrantedOptimismException.isValid(programPoint) ? toNumberOptimistic(obj, programPoint) : toNumber(obj);
  }

  /**
   * Digit representation for a character
   * @param ch     a character
   * @param radix  radix
   * @return the digit for this character
   */
  public static int digit(char ch, int radix) {
    return digit(ch, radix, false);
  }

  /**
   * Digit representation for a character
   * @param ch             a character
   * @param radix          radix
   * @param onlyIsoLatin1  iso latin conversion only
   * @return the digit for this character
   */
  public static int digit(char ch, int radix, boolean onlyIsoLatin1) {
    var maxInRadix = (char) ('a' + (radix - 1) - 10);
    var c = Character.toLowerCase(ch);
    if (c >= 'a' && c <= maxInRadix) {
      return Character.digit(ch, radix);
    }
    if (Character.isDigit(ch)) {
      if (!onlyIsoLatin1 || ch >= '0' && ch <= '9') {
        return Character.digit(ch, radix);
      }
    }
    return -1;
  }

  /**
   * JavaScript compliant String to number conversion
   * @param str  a string
   * @return a number
   */
  public static double toNumber(String str) {
    var end = str.length();
    if (end == 0) {
      return 0.0; // Empty string
    }
    var start = 0;
    var f = str.charAt(0);
    while (Lexer.isJSWhitespace(f)) {
      if (++start == end) {
        return 0.0d; // All whitespace string
      }
      f = str.charAt(start);
    }
    // Guaranteed to terminate even without start >= end check, as the previous loop found at least one non-whitespace character.
    while (Lexer.isJSWhitespace(str.charAt(end - 1))) {
      end--;
    }
    boolean negative;
    if (f == '-') {
      if (++start == end) {
        return Double.NaN; // Single-char "-" string
      }
      f = str.charAt(start);
      negative = true;
    } else {
      if (f == '+') {
        if (++start == end) {
          return Double.NaN; // Single-char "+" string
        }
        f = str.charAt(start);
      }
      negative = false;
    }
    double value;
    if (start + 1 < end && f == '0' && Character.toLowerCase(str.charAt(start + 1)) == 'x') {
      // decode hex string
      value = parseRadix(str.toCharArray(), start + 2, end, 16);
    } else if (f == 'I' && end - start == 8 && str.regionMatches(start, "Infinity", 0, 8)) {
      return negative ? Double.NEGATIVE_INFINITY : Double.POSITIVE_INFINITY;
    } else {
      // Fast (no NumberFormatException) path to NaN for non-numeric strings.
      for (var i = start; i < end; i++) {
        f = str.charAt(i);
        if ((f < '0' || f > '9') && f != '.' && f != 'e' && f != 'E' && f != '+' && f != '-') {
          return Double.NaN;
        }
      }
      try {
        value = Double.parseDouble(str.substring(start, end));
      } catch (NumberFormatException e) {
        return Double.NaN;
      }
    }
    return negative ? -value : value;
  }

  /**
   * JavaScript compliant Object to integer conversion.
   * See ECMA 9.4 ToInteger
   * Note that this returns {@link java.lang.Integer#MAX_VALUE} or {@link java.lang.Integer#MIN_VALUE} for double values that exceed the int range, including positive and negative Infinity.
   * It is the caller's responsibility to handle such values correctly.
   * @param obj  an object
   * @return an integer
   */
  public static int toInteger(Object obj) {
    return (int) toNumber(obj);
  }

  /**
   * Converts an Object to long.
   * Note that this returns {@link java.lang.Long#MAX_VALUE} or {@link java.lang.Long#MIN_VALUE} for double values that exceed the long range, including positive and negative Infinity.
   * It is the caller's responsibility to handle such values correctly.</p>
   * @param obj  an object
   * @return a long
   */
  public static long toLong(Object obj) {
    return obj instanceof Long ? ((Long) obj) : toLong(toNumber(obj));
  }

  /**
   * Converts a double to long.
   * @param num the double to convert
   * @return the converted long value
   */
  public static long toLong(double num) {
    return (long) num;
  }

  /**
   * JavaScript compliant Object to int32 conversion
   * See ECMA 9.5 ToInt32
   * @param obj an object
   * @return an int32
   */
  public static int toInt32(Object obj) {
    return toInt32(toNumber(obj));
  }

  /**
   * Optimistic int conversion - throws UnwarrantedOptimismException if double, long or Object
   * @param obj           object to convert
   * @param programPoint  program point
   * @return double
   */
  public static int toInt32Optimistic(Object obj, int programPoint) {
    if (obj != null && obj.getClass() == Integer.class) {
      return ((Integer) obj);
    }
    throw new UnwarrantedOptimismException(obj, programPoint);
  }

  /**
   * Object to int conversion that delegates to either {@link #toInt32(Object)} or to {@link #toInt32Optimistic(Object, int)} depending on whether the program point is valid or not.
   * @param obj the object to convert
   * @param programPoint the program point; can be invalid.
   * @return the value converted to int
   * @throws UnwarrantedOptimismException if the value can't be represented as int and the program point is valid.
   */
  public static int toInt32MaybeOptimistic(Object obj, int programPoint) {
    return UnwarrantedOptimismException.isValid(programPoint) ? toInt32Optimistic(obj, programPoint) : toInt32(obj);
  }

  /**
   * JavaScript compliant long to int32 conversion
   * @param num a long
   * @return an int32
   */
  public static int toInt32(long num) {
    return (int) (num >= MIN_PRECISE_DOUBLE && num <= MAX_PRECISE_DOUBLE ? num : (long) (num % INT32_LIMIT));
  }

  /**
   * JavaScript compliant number to int32 conversion
   * @param num a number
   * @return an int32
   */
  public static int toInt32(double num) {
    return (int) doubleToInt32(num);
  }

  /**
   * JavaScript compliant Object to uint32 conversion
   * @param obj an object
   * @return a uint32
   */
  public static long toUint32(Object obj) {
    return toUint32(toNumber(obj));
  }

  /**
   * JavaScript compliant number to uint32 conversion
   * @param num a number
   * @return a uint32
   */
  public static long toUint32(double num) {
    return doubleToInt32(num) & MAX_UINT;
  }

  /**
   * JavaScript compliant int to uint32 conversion
   * @param num an int
   * @return a uint32
   */
  public static long toUint32(int num) {
    return num & MAX_UINT;
  }

  /**
   * Optimistic JavaScript compliant int to uint32 conversion
   * @param num an int
   * @param pp the program point
   * @return the uint32 value if it can be represented by an int
   * @throws UnwarrantedOptimismException if uint32 value cannot be represented by an int
   */
  public static int toUint32Optimistic(int num, int pp) {
    if (num >= 0) {
      return num;
    }
    throw new UnwarrantedOptimismException(toUint32Double(num), pp, Type.NUMBER);
  }

  /**
   * JavaScript compliant int to uint32 conversion with double return type
   * @param num an int
   * @return the uint32 value as double
   */
  public static double toUint32Double(int num) {
    return toUint32(num);
  }

  /**
   * JavaScript compliant Object to uint16 conversion
   * ECMA 9.7 ToUint16: (Unsigned 16 Bit Integer)
   * @param obj an object
   * @return a uint16
   */
  public static int toUint16(Object obj) {
    return toUint16(toNumber(obj));
  }

  /**
   * JavaScript compliant number to uint16 conversion
   * @param num a number
   * @return a uint16
   */
  public static int toUint16(int num) {
    return num & 0xffff;
  }

  /**
   * JavaScript compliant number to uint16 conversion
   * @param num a number
   * @return a uint16
   */
  public static int toUint16(long num) {
    return (int) num & 0xffff;
  }

  /**
   * JavaScript compliant number to uint16 conversion
   * @param num a number
   * @return a uint16
   */
  public static int toUint16(double num) {
    return (int) doubleToInt32(num) & 0xffff;
  }

  static long doubleToInt32(double num) {
    var exponent = Math.getExponent(num);
    if (exponent < 31) {
      return (long) num;  // Fits into 32 bits
    }
    if (exponent >= 84) {
      // Either infinite or NaN or so large that shift / modulo will produce 0
      // (52 bit mantissa + 32 bit target width).
      return 0;
    }
    // This is rather slow and could probably be sped up using bit-fiddling.
    var d = num >= 0 ? Math.floor(num) : Math.ceil(num);
    return (long) (d % INT32_LIMIT);
  }

  /**
   * Check whether a number is finite
   * @param num a number
   * @return true if finite
   */
  public static boolean isFinite(double num) {
    return !Double.isInfinite(num) && !Double.isNaN(num);
  }

  /**
   * Convert a primitive to a double
   * @param num a double
   * @return a boxed double
   */
  public static Double toDouble(double num) {
    return num;
  }

  /**
   * Convert a primitive to a double
   * @param num a long
   * @return a boxed double
   */
  public static Double toDouble(long num) {
    return (double) num;
  }

  /**
   * Convert a primitive to a double
   * @param num an int
   * @return a boxed double
   */
  public static Double toDouble(int num) {
    return (double) num;
  }

  /**
   * Convert a boolean to an Object
   * @param bool a boolean
   * @return a boxed boolean, its Object representation
   */
  public static Object toObject(boolean bool) {
    return bool;
  }

  /**
   * Convert a number to an Object
   * @param num an integer
   * @return the boxed number
   */
  public static Object toObject(int num) {
    return num;
  }

  /**
   * Convert a number to an Object
   * @param num a long
   * @return the boxed number
   */
  public static Object toObject(long num) {
    return num;
  }

  /**
   * Convert a number to an Object
   * @param num a double
   * @return the boxed number
   */
  public static Object toObject(double num) {
    return num;
  }

  /**
   * Identity converter for objects.
   * @param obj an object
   * @return the boxed number
   */
  public static Object toObject(Object obj) {
    return obj;
  }

  /**
   * Object conversion.
   * This is used to convert objects and numbers to their corresponding NativeObject type
   * See ECMA 9.9 ToObject
   * @param obj     the object to convert
   * @return the wrapped object
   */
  public static Object toScriptObject(Object obj) {
    return toScriptObject(Context.getGlobal(), obj);
  }

  /**
   * Object conversion.
   * This is used to convert objects and numbers to their corresponding NativeObject type
   * See ECMA 9.9 ToObject
   * @param global  the global object
   * @param obj     the object to convert
   * @return the wrapped object
   */
  public static Object toScriptObject(Global global, Object obj) {
    if (nullOrUndefined(obj)) {
      throw typeError(global, "not.an.object", ScriptRuntime.safeToString(obj));
    }
    if (obj instanceof ScriptObject) {
      return obj;
    }
    return global.wrapAsObject(obj);
  }

  /**
   * Script object to Java array conversion.
   * @param obj script object to be converted to Java array
   * @param componentType component type of the destination array required
   * @return converted Java array
   */
  public static Object toJavaArray(Object obj, Class<?> componentType) {
    if (obj instanceof ScriptObject so) {
      return so.getArray().asArrayOfType(componentType);
    } else if (obj instanceof JSObject) {
      var itr = ArrayLikeIterator.arrayLikeIterator(obj);
      var len = (int) itr.getLength();
      var res = new Object[len];
      var idx = 0;
      while (itr.hasNext()) {
        res[idx++] = itr.next();
      }
      return convertArray(res, componentType);
    } else if (obj == null) {
      return null;
    } else {
      throw new IllegalArgumentException("not a script object");
    }
  }

  /**
   * Script object to Java array conversion.
   * @param obj script object to be converted to Java array
   * @param componentType component type of the destination array required
   * @param lookupSupplier supplier for the lookup of the class invoking the conversion. Can be used to use protection-domain specific converters if the target type is a SAM.
   * @return converted Java array
   */
  public static Object toJavaArrayWithLookup(Object obj, Class<?> componentType, SecureLookupSupplier lookupSupplier) {
    return Bootstrap.getLinkerServices().getWithLookup(() -> toJavaArray(obj, componentType), lookupSupplier);
  }

  /**
   * Java array to java array conversion - but using type conversions implemented by linker.
   * @param src source array
   * @param componentType component type of the destination array required
   * @return converted Java array
   */
  public static Object convertArray(Object[] src, Class<?> componentType) {
    if (componentType == Object.class) {
      for (var i = 0; i < src.length; ++i) {
        var e = src[i];
        if (e instanceof ConsString) {
          src[i] = e.toString();
        }
      }
    }
    var l = src.length;
    var dst = Array.newInstance(componentType, l);
    var converter = Bootstrap.getLinkerServices().getTypeConverter(Object.class, componentType);
    try {
      for (var i = 0; i < src.length; i++) {
        Array.set(dst, i, invoke(converter, src[i]));
      }
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
    return dst;
  }

  /**
   * Check if an object is null or undefined
   * @param obj object to check
   * @return true if null or undefined
   */
  public static boolean nullOrUndefined(Object obj) {
    return obj == null || obj == ScriptRuntime.UNDEFINED;
  }

  static String toStringImpl(Object obj, boolean safe) {
    if (obj instanceof String s) {
      return s;
    }
    if (obj instanceof ConsString) {
      return obj.toString();
    }
    if (isNumber(obj)) {
      return toString(((Number) obj).doubleValue());
    }
    if (obj == ScriptRuntime.UNDEFINED) {
      return "undefined";
    }
    if (obj == null) {
      return "null";
    }
    if (obj instanceof Boolean) {
      return obj.toString();
    }
    if (obj instanceof Symbol) {
      if (safe) {
        return obj.toString();
      }
      throw typeError("symbol.to.string");
    }
    if (safe && obj instanceof ScriptObject sobj) {
      var gobj = Context.getGlobal();
      return gobj.isError(sobj) ? ECMAException.safeToString(sobj) : sobj.safeToString();
    }
    return toString(toPrimitive(obj, String.class));
  }

  // trim from left for JS whitespaces.
  static String trimLeft(String str) {
    var start = 0;
    while (start < str.length() && Lexer.isJSWhitespace(str.charAt(start))) {
      start++;
    }
    return str.substring(start);
  }

  /**
   * Throw an unwarranted optimism exception for a program point
   * @param value         real return value
   * @param programPoint  program point
   * @return
   */
  @SuppressWarnings("unused")
  static Object throwUnwarrantedOptimismException(Object value, int programPoint) {
    throw new UnwarrantedOptimismException(value, programPoint);
  }

  /**
   * Wrapper for addExact
   * Catches ArithmeticException and rethrows as UnwarrantedOptimismException containing the result and the program point of the failure
   * @param x first term
   * @param y second term
   * @param programPoint program point id
   * @return the result
   * @throws UnwarrantedOptimismException if overflow occurs
   */
  public static int addExact(int x, int y, int programPoint) throws UnwarrantedOptimismException {
    try {
      return Math.addExact(x, y);
    } catch (ArithmeticException e) {
      throw new UnwarrantedOptimismException((double) x + (double) y, programPoint);
    }
  }

  /**
   * Wrapper for subExact
   * Catches ArithmeticException and rethrows as UnwarrantedOptimismException containing the result and the program point of the failure
   * @param x first term
   * @param y second term
   * @param programPoint program point id
   * @return the result
   * @throws UnwarrantedOptimismException if overflow occurs
   */
  public static int subExact(int x, int y, int programPoint) throws UnwarrantedOptimismException {
    try {
      return Math.subtractExact(x, y);
    } catch (ArithmeticException e) {
      throw new UnwarrantedOptimismException((double) x - (double) y, programPoint);
    }
  }

  /**
   * Wrapper for mulExact
   * Catches ArithmeticException and rethrows as UnwarrantedOptimismException containing the result and the program point of the failure
   * @param x first term
   * @param y second term
   * @param programPoint program point id
   * @return the result
   * @throws UnwarrantedOptimismException if overflow occurs
   */
  public static int mulExact(int x, int y, int programPoint) throws UnwarrantedOptimismException {
    try {
      return Math.multiplyExact(x, y);
    } catch (ArithmeticException e) {
      throw new UnwarrantedOptimismException((double) x * (double) y, programPoint);
    }
  }

  /**
   * Wrapper for divExact.
   * Throws UnwarrantedOptimismException if the result of the division can't be represented as int.
   * @param x first term
   * @param y second term
   * @param programPoint program point id
   * @return the result
   * @throws UnwarrantedOptimismException if the result of the division can't be represented as int.
   */
  public static int divExact(int x, int y, int programPoint) throws UnwarrantedOptimismException {
    int res;
    try {
      res = x / y;
    } catch (ArithmeticException e) {
      assert y == 0; // Only div by zero anticipated
      throw new UnwarrantedOptimismException(x > 0 ? Double.POSITIVE_INFINITY : x < 0 ? Double.NEGATIVE_INFINITY : Double.NaN, programPoint);
    }
    int rem = x % y;
    if (rem == 0) {
      return res;
    }
    // go directly to double here, as anything with non zero remainder is a floating point number in JavaScript
    throw new UnwarrantedOptimismException((double) x / (double) y, programPoint);
  }

  /**
   * Implements int division but allows {@code x / 0} to be represented as 0.
   * Basically equivalent to {@code (x / y)|0} JavaScript expression (division of two ints coerced to int).
   * @param x the dividend
   * @param y the divisor
   * @return the result
   */
  public static int divZero(int x, int y) {
    return y == 0 ? 0 : x / y;
  }

  /**
   * Implements int remainder but allows {@code x % 0} to be represented as 0.
   * Basically equivalent to {@code (x % y)|0} JavaScript expression (remainder of two ints coerced to int).
   * @param x the dividend
   * @param y the divisor
   * @return the remainder
   */
  public static int remZero(int x, int y) {
    return y == 0 ? 0 : x % y;
  }

  /**
   * Wrapper for modExact.
   * Throws UnwarrantedOptimismException if the modulo can't be represented as int.
   * @param x first term
   * @param y second term
   * @param programPoint program point id
   * @return the result
   * @throws UnwarrantedOptimismException if the modulo can't be represented as int.
   */
  public static int remExact(int x, int y, int programPoint) throws UnwarrantedOptimismException {
    try {
      return x % y;
    } catch (ArithmeticException e) {
      assert y == 0; // Only mod by zero anticipated
      throw new UnwarrantedOptimismException(Double.NaN, programPoint);
    }
  }

  /**
   * Wrapper for decrementExact
   * Catches ArithmeticException and rethrows as UnwarrantedOptimismException containing the result and the program point of the failure
   * @param x number to negate
   * @param programPoint program point id
   * @return the result
   * @throws UnwarrantedOptimismException if overflow occurs
   */
  public static int decrementExact(int x, int programPoint) throws UnwarrantedOptimismException {
    try {
      return Math.decrementExact(x);
    } catch (ArithmeticException e) {
      throw new UnwarrantedOptimismException((double) x - 1, programPoint);
    }
  }

  /**
   * Wrapper for incrementExact
   * Catches ArithmeticException and rethrows as UnwarrantedOptimismException containing the result and the program point of the failure
   * @param x the number to increment
   * @param programPoint program point id
   * @return the result
   * @throws UnwarrantedOptimismException if overflow occurs
   */
  public static int incrementExact(int x, int programPoint) throws UnwarrantedOptimismException {
    try {
      return Math.incrementExact(x);
    } catch (ArithmeticException e) {
      throw new UnwarrantedOptimismException((double) x + 1, programPoint);
    }
  }

  /**
   * Wrapper for negateExact
   * Catches ArithmeticException and rethrows as UnwarrantedOptimismException containing the result and the program point of the failure
   * @param x the number to negate
   * @param programPoint program point id
   * @return the result
   * @throws UnwarrantedOptimismException if overflow occurs
   */
  public static int negateExact(int x, int programPoint) throws UnwarrantedOptimismException {
    try {
      if (x == 0) {
        throw new UnwarrantedOptimismException(-0.0, programPoint);
      }
      return Math.negateExact(x);
    } catch (ArithmeticException e) {
      throw new UnwarrantedOptimismException(-(double) x, programPoint);
    }
  }

  /**
   * Given a type of an accessor, return its index in [0..getNumberOfAccessorTypes())
   * @param type the type
   * @return the accessor index, or -1 if no accessor of this type exists
   */
  public static int getAccessorTypeIndex(Type type) {
    return getAccessorTypeIndex(type.getTypeClass());
  }

  /**
   * Given a class of an accessor, return its index in [0..getNumberOfAccessorTypes())
   * Note that this is hardcoded with respect to the dynamic contents of the accessor types array for speed.
   * Hotspot got stuck with this as 5% of the runtime in a benchmark when it looped over values and increased an index counter. :-(
   * @param type the type
   * @return the accessor index, or -1 if no accessor of this type exists
   */
  public static int getAccessorTypeIndex(Class<?> type) {
    if (type == null) {
      return TYPE_UNDEFINED_INDEX;
    } else if (type == int.class) {
      return TYPE_INT_INDEX;
    } else if (type == double.class) {
      return TYPE_DOUBLE_INDEX;
    } else if (!type.isPrimitive()) {
      return TYPE_OBJECT_INDEX;
    }
    return -1;
  }

  /**
   * Return the accessor type based on its index in [0..getNumberOfAccessorTypes()).
   * Indexes are ordered narrower{@literal ->}wider / optimistic{@literal ->}pessimistic.
   * Invalidations always go to a type of higher index
   * @param index accessor type index
   * @return a type corresponding to the index.
   */
  public static Type getAccessorType(int index) {
    return ACCESSOR_TYPES.get(index);
  }

  /**
   * Return the number of accessor types available.
   * @return number of accessor types in system
   */
  public static int getNumberOfAccessorTypes() {
    return ACCESSOR_TYPES.size();
  }

  static double parseRadix(char chars[], int start, int length, int radix) {
    var pos = 0;
    for (var i = start; i < length; i++) {
      if (digit(chars[i], radix) == -1) {
        return Double.NaN;
      }
      pos++;
    }
    if (pos == 0) {
      return Double.NaN;
    }
    var value = 0.0;
    for (var i = start; i < start + pos; i++) {
      value *= radix;
      value += digit(chars[i], radix);
    }
    return value;
  }

  static double toNumberGeneric(Object obj) {
    if (obj == null) {
      return +0.0;
    }
    if (obj instanceof String s) {
      return toNumber(s);
    }
    if (obj instanceof ConsString) {
      return toNumber(obj.toString());
    }
    if (obj instanceof Boolean b) {
      return toNumber(b);
    }
    if (obj instanceof ScriptObject so) {
      return toNumber(so);
    }
    if (obj instanceof Undefined) {
      return Double.NaN;
    }
    if (obj instanceof Symbol) {
      throw typeError("symbol.to.number");
    }
    return toNumber(toPrimitive(obj, Number.class));
  }

  private static Object invoke(MethodHandle mh, Object arg) {
    try {
      return mh.invoke(arg);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  /**
   * Create a method handle constant of the correct primitive type
   * for a constant object
   * @param o object
   * @return constant function that returns object
   */
  public static MethodHandle unboxConstant(Object o) {
    if (o != null) {
      if (o.getClass() == Integer.class) {
        return MH.constant(int.class, o);
      } else if (o.getClass() == Double.class) {
        return MH.constant(double.class, o);
      }
    }
    return MH.constant(Object.class, o);
  }

  /**
   * Get the unboxed (primitive) type for an object
   * @param o object
   * @return primitive type or Object.class if not primitive
   */
  public static Class<?> unboxedFieldType(Object o) {
    if (o == null) {
      return Object.class;
    } else if (o.getClass() == Integer.class) {
      return int.class;
    } else if (o.getClass() == Double.class) {
      return double.class;
    } else {
      return Object.class;
    }
  }

  // allows null elements
  static <T> List<T> toUnmodifiableList(T... items) { return Collections.unmodifiableList(Arrays.asList(items)); }
}
