package es.runtime.linker;

import java.util.HashMap;
import java.util.Map;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import jdk.dynalink.linker.support.TypeUtilities;

import es.runtime.ConsString;
import es.runtime.JSType;
import es.runtime.ScriptObject;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.JSType.isString;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * Utility class shared by {@code NashornLinker} and {@code NashornPrimitiveLinker} for converting JS values to Java types.
 */
final class JavaArgumentConverters {

  private static final MethodHandle TO_BOOLEAN = findOwnMH("toBoolean", Boolean.class, Object.class);
  private static final MethodHandle TO_STRING = findOwnMH("toString", String.class, Object.class);
  private static final MethodHandle TO_DOUBLE = findOwnMH("toDouble", Double.class, Object.class);
  private static final MethodHandle TO_NUMBER = findOwnMH("toNumber", Number.class, Object.class);
  private static final MethodHandle TO_LONG = findOwnMH("toLong", Long.class, Object.class);
  private static final MethodHandle TO_LONG_PRIMITIVE = findOwnMH("toLongPrimitive", long.class, Object.class);
  private static final MethodHandle TO_CHAR = findOwnMH("toChar", Character.class, Object.class);
  private static final MethodHandle TO_CHAR_PRIMITIVE = findOwnMH("toCharPrimitive", char.class, Object.class);

  static MethodHandle getConverter(Class<?> targetType) {
    return CONVERTERS.get(targetType);
  }

  @SuppressWarnings("unused")
  static Boolean toBoolean(Object obj) {
    if (obj instanceof Boolean b) {
      return b;
    }
    if (obj == null) {
      // NOTE: FindBugs complains here about the NP_BOOLEAN_RETURN_NULL pattern: we're returning null from a method that has a return type of Boolean, as it is worried about a NullPointerException if there's a conversion to a primitive boolean.
      // We know what we're doing, though.
      // We're using a separate method when we're converting Object to a primitive boolean - see how the CONVERTERS map is populated.
      // We specifically want to have null and Undefined to be converted to a (Boolean)null when being passed to a Java method that expects a Boolean argument.
      // TODO: if/when we're allowed to use FindBugs at build time, we can use annotations to disable this warning
      return null;
    }
    if (obj == UNDEFINED) {
      // NOTE: same reasoning for FindBugs NP_BOOLEAN_RETURN_NULL warning as in the preceding comment.
      return null;
    }
    if (obj instanceof Number n) {
      var num = n.doubleValue();
      return num != 0 && !Double.isNaN(num);
    }
    if (isString(obj)) {
      return ((CharSequence) obj).length() > 0;
    }
    if (obj instanceof ScriptObject) {
      return true;
    }
    throw assertUnexpectedType(obj);
  }

  static Character toChar(Object o) {
    if (o == null) {
      return null;
    }
    if (o instanceof Number n) {
      var ival = n.intValue();
      if (ival >= Character.MIN_VALUE && ival <= Character.MAX_VALUE) {
        return (char) ival;
      }
      throw typeError("cant.convert.number.to.char");
    }
    var s = toString(o);
    if (s == null) {
      return null;
    }
    if (s.length() != 1) {
      throw typeError("cant.convert.string.to.char");
    }
    return s.charAt(0);
  }

  static char toCharPrimitive(Object obj0) {
    var c = toChar(obj0);
    return c == null ? (char) 0 : c;
  }

  // Almost identical to ScriptRuntime.toString, but returns null for null instead of the string "null".
  static String toString(Object obj) {
    return obj == null ? null : JSType.toString(obj);
  }

  @SuppressWarnings("unused")
  static Double toDouble(Object obj0) {
    // TODO - Order tests for performance.
    for (var obj = obj0;;) {
      if (obj == null) {
        return null;
      } else if (obj instanceof Double d) {
        return d;
      } else if (obj instanceof Number n) {
        return n.doubleValue();
      } else if (obj instanceof String s) {
        return JSType.toNumber(s);
      } else if (obj instanceof ConsString cs) {
        return JSType.toNumber(cs);
      } else if (obj instanceof Boolean b) {
        return b ? 1 : +0.0;
      } else if (obj instanceof ScriptObject) {
        obj = JSType.toPrimitive(obj, Number.class);
        continue;
      } else if (obj == UNDEFINED) {
        return Double.NaN;
      }
      throw assertUnexpectedType(obj);
    }
  }

  @SuppressWarnings("unused")
  static Number toNumber(Object obj0) {
    // TODO - Order tests for performance.
    for (var obj = obj0;;) {
      if (obj == null) {
        return null;
      } else if (obj instanceof Number n) {
        return n;
      } else if (obj instanceof String s) {
        return JSType.toNumber(s);
      } else if (obj instanceof ConsString cs) {
        return JSType.toNumber(cs);
      } else if (obj instanceof Boolean b) {
        return b ? 1 : +0.0;
      } else if (obj instanceof ScriptObject) {
        obj = JSType.toPrimitive(obj, Number.class);
        continue;
      } else if (obj == UNDEFINED) {
        return Double.NaN;
      }
      throw assertUnexpectedType(obj);
    }
  }

  private static Long toLong(Object obj0) {
    // TODO - Order tests for performance.
    for (Object obj = obj0;;) {
      if (obj == null) {
        return null;
      } else if (obj instanceof Long l) {
        return l;
      } else if (obj instanceof Integer i) {
        return i.longValue();
      } else if (obj instanceof Double d) {
        if (Double.isInfinite(d)) {
          return 0L;
        }
        return d.longValue();
      } else if (obj instanceof Float f) {
        if (Float.isInfinite(f)) {
          return 0L;
        }
        return f.longValue();
      } else if (obj instanceof Number n) {
        return n.longValue();
      } else if (isString(obj)) {
        return JSType.toLong(obj);
      } else if (obj instanceof Boolean b) {
        return b ? 1L : 0L;
      } else if (obj instanceof ScriptObject) {
        obj = JSType.toPrimitive(obj, Number.class);
        continue;
      } else if (obj == UNDEFINED) {
        return null; // null or 0L?
      }
      throw assertUnexpectedType(obj);
    }
  }

  static AssertionError assertUnexpectedType(Object obj) {
    return new AssertionError("Unexpected type" + obj.getClass().getName() + ". Guards should have prevented this");
  }

  @SuppressWarnings("unused")
  static long toLongPrimitive(Object obj0) {
    var l = toLong(obj0);
    return l == null ? 0L : l;
  }

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), JavaArgumentConverters.class, name, MH.type(rtype, types));
  }

  private static final Map<Class<?>, MethodHandle> CONVERTERS = new HashMap<>();

  static {
    CONVERTERS.put(Number.class, TO_NUMBER);
    CONVERTERS.put(String.class, TO_STRING);
    CONVERTERS.put(boolean.class, JSType.TO_BOOLEAN.methodHandle());
    CONVERTERS.put(Boolean.class, TO_BOOLEAN);
    CONVERTERS.put(char.class, TO_CHAR_PRIMITIVE);
    CONVERTERS.put(Character.class, TO_CHAR);
    CONVERTERS.put(double.class, JSType.TO_NUMBER.methodHandle());
    CONVERTERS.put(Double.class, TO_DOUBLE);
    CONVERTERS.put(long.class, TO_LONG_PRIMITIVE);
    CONVERTERS.put(Long.class, TO_LONG);
    putLongConverter(Byte.class);
    putLongConverter(Short.class);
    putLongConverter(Integer.class);
    putDoubleConverter(Float.class);
  }

  static void putDoubleConverter(Class<?> targetType) {
    var primitive = TypeUtilities.getPrimitiveType(targetType);
    CONVERTERS.put(primitive, MH.explicitCastArguments(JSType.TO_NUMBER.methodHandle(), JSType.TO_NUMBER.methodHandle().type().changeReturnType(primitive)));
    CONVERTERS.put(targetType, MH.filterReturnValue(TO_DOUBLE, findOwnMH(primitive.getName() + "Value", targetType, Double.class)));
  }

  static void putLongConverter(Class<?> targetType) {
    var primitive = TypeUtilities.getPrimitiveType(targetType);
    CONVERTERS.put(primitive, MH.explicitCastArguments(TO_LONG_PRIMITIVE, TO_LONG_PRIMITIVE.type().changeReturnType(primitive)));
    CONVERTERS.put(targetType, MH.filterReturnValue(TO_LONG, findOwnMH(primitive.getName() + "Value", targetType, Long.class)));
  }

  @SuppressWarnings("unused")
  static Byte byteValue(Long l) {
    return l == null ? null : l.byteValue();
  }

  @SuppressWarnings("unused")
  static Short shortValue(Long l) {
    return l == null ? null : l.shortValue();
  }

  @SuppressWarnings("unused")
  static Integer intValue(Long l) {
    return l == null ? null : l.intValue();
  }

  @SuppressWarnings("unused")
  static Float floatValue(Double d) {
    return d == null ? null : d.floatValue();
  }

}
