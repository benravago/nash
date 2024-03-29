package es.runtime;

import java.util.Locale;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import static es.lookup.Lookup.MH;

/**
 * Utilities used by Global class.
 */
public final class GlobalFunctions {

  /** Methodhandle to implementation of ECMA 15.1.2.2, parseInt */
  public static final MethodHandle PARSEINT = findOwnMH("parseInt", double.class, Object.class, Object.class, Object.class);

  /** Methodhandle (specialized) to implementation of ECMA 15.1.2.2, parseInt */
  public static final MethodHandle PARSEINT_OI = findOwnMH("parseInt", double.class, Object.class, Object.class, int.class);

  /** ParseInt - NaN for booleans (thru string conversion to number conversion) */
  public static final MethodHandle PARSEINT_Z = MH.dropArguments(MH.dropArguments(MH.constant(double.class, Double.NaN), 0, boolean.class), 0, Object.class);

  /** ParseInt - identity for ints */
  public static final MethodHandle PARSEINT_I = MH.dropArguments(MH.identity(int.class), 0, Object.class);

  /** Methodhandle (specialized) to implementation of ECMA 15.1.2.2, parseInt */
  public static final MethodHandle PARSEINT_O = findOwnMH("parseInt", double.class, Object.class, Object.class);

  /** Methodhandle to implementation of ECMA 15.1.2.3, parseFloat */
  public static final MethodHandle PARSEFLOAT = findOwnMH("parseFloat", double.class, Object.class, Object.class);

  /** isNan for integers - always false */
  public static final MethodHandle IS_NAN_I = MH.dropArguments(MH.constant(boolean.class, false), 0, Object.class);

  /** isNan for longs - always false */
  public static final MethodHandle IS_NAN_J = MH.dropArguments(MH.constant(boolean.class, false), 0, Object.class);

  /** IsNan for doubles - use Double.isNaN */
  public static final MethodHandle IS_NAN_D = MH.dropArguments(MH.findStatic(MethodHandles.lookup(), Double.class, "isNaN", MH.type(boolean.class, double.class)), 0, Object.class);

  /** Methodhandle to implementation of ECMA 15.1.2.4, isNaN */
  public static final MethodHandle IS_NAN = findOwnMH("isNaN", boolean.class, Object.class, Object.class);

  /** Methodhandle to implementation of ECMA 15.1.2.5, isFinite */
  public static final MethodHandle IS_FINITE = findOwnMH("isFinite", boolean.class, Object.class, Object.class);

  /** Methodhandle to implementation of ECMA 15.1.3.3, encodeURI */
  public static final MethodHandle ENCODE_URI = findOwnMH("encodeURI", Object.class, Object.class, Object.class);

  /** Methodhandle to implementation of ECMA 15.1.3.4, encodeURIComponent */
  public static final MethodHandle ENCODE_URICOMPONENT = findOwnMH("encodeURIComponent", Object.class, Object.class, Object.class);

  /** Methodhandle to implementation of ECMA 15.1.3.1, decodeURI */
  public static final MethodHandle DECODE_URI = findOwnMH("decodeURI", Object.class, Object.class, Object.class);

  /** Methodhandle to implementation of ECMA 15.1.3.2, decodeURIComponent */
  public static final MethodHandle DECODE_URICOMPONENT = findOwnMH("decodeURIComponent", Object.class, Object.class, Object.class);

  /** Methodhandle to implementation of ECMA B.2.1, escape */
  public static final MethodHandle ESCAPE = findOwnMH("escape", String.class, Object.class, Object.class);

  /** Methodhandle to implementation of ECMA B.2.2, unescape */
  public static final MethodHandle UNESCAPE = findOwnMH("unescape", String.class, Object.class, Object.class);

  /** Methodhandle to implementation of ECMA 15.3.4, "anonymous" - Properties of the Function Prototype Object. */
  public static final MethodHandle ANONYMOUS = findOwnMH("anonymous", Object.class, Object.class);

  private static final String UNESCAPED = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@*_+-./";


  /**
   * ECMA 15.1.2.2 parseInt implementation
   * @param self   self reference
   * @param string string to parse
   * @param rad    radix
   * @return numeric type representing string contents as an int
   */
  public static double parseInt(Object self, Object string, Object rad) {
    return parseIntInternal(JSType.trimLeft(JSType.toString(string)), JSType.toInt32(rad));
  }

  /**
   * ECMA 15.1.2.2 parseInt implementation specialized for int radix
   * @param self   self reference
   * @param string string to parse
   * @param rad    radix
   * @return numeric type representing string contents as an int
   */
  public static double parseInt(Object self, Object string, int rad) {
    return parseIntInternal(JSType.trimLeft(JSType.toString(string)), rad);
  }

  /**
   * ECMA 15.1.2.2 parseInt implementation specialized for no radix argument
   * @param self   self reference
   * @param string string to parse
   * @return numeric type representing string contents as an int
   */
  public static double parseInt(Object self, Object string) {
    return parseIntInternal(JSType.trimLeft(JSType.toString(string)), 0);
  }

  static double parseIntInternal(String str, int rad) {
    var length = str.length();
    var radix = rad;
    // empty string is not valid
    if (length == 0) {
      return Double.NaN;
    }
    var negative = false;
    int idx = 0;
    // checking for the sign character
    var firstChar = str.charAt(idx);
    if (firstChar < '0') {
      // Possible leading "+" or "-"
      if (firstChar == '-') {
        negative = true;
      } else if (firstChar != '+') {
        return Double.NaN;
      }
      // skip the sign character
      idx++;
    }
    var stripPrefix = true;
    if (radix != 0) {
      if (radix < 2 || radix > 36) {
        return Double.NaN;
      }
      if (radix != 16) {
        stripPrefix = false;
      }
    } else {
      // default radix
      radix = 10;
    }
    // strip "0x" or "0X" and treat radix as 16
    if (stripPrefix && ((idx + 1) < length)) {
      var c1 = str.charAt(idx);
      var c2 = str.charAt(idx + 1);
      if (c1 == '0' && (c2 == 'x' || c2 == 'X')) {
        radix = 16;
        // skip "0x" or "0X"
        idx += 2;
      }
    }
    var result = 0.0;
    int digit;
    // we should see at least one valid digit
    var entered = false;
    while (idx < length) {
      digit = fastDigit(str.charAt(idx++), radix);
      if (digit < 0) {
        break;
      }
      // we have seen at least one valid digit in the specified radix
      entered = true;
      result *= radix;
      result += digit;
    }
    return entered ? (negative ? -result : result) : Double.NaN;
  }

  /**
   * ECMA 15.1.2.3 parseFloat implementation
   * @param self   self reference
   * @param string string to parse
   * @return numeric type representing string contents
   */
  public static double parseFloat(Object self, Object string) {
    var str = JSType.trimLeft(JSType.toString(string));
    var length = str.length();
    // empty string is not valid
    if (length == 0) {
      return Double.NaN;
    }
    var start = 0;
    var negative = false;
    var ch = str.charAt(0);
    if (ch == '-') {
      start++;
      negative = true;
    } else if (ch == '+') {
      start++;
    } else if (ch == 'N') {
      if (str.startsWith("NaN")) {
        return Double.NaN;
      }
    }
    if (start == length) {
      // just the sign character
      return Double.NaN;
    }
    ch = str.charAt(start);
    if (ch == 'I') {
      if (str.substring(start).startsWith("Infinity")) {
        return negative ? Double.NEGATIVE_INFINITY : Double.POSITIVE_INFINITY;
      }
    }
    var dotSeen = false;
    var exponentOk = false;
    var exponentOffset = -1;
    int end;
    loop:
    for (end = start; end < length; end++) {
      ch = str.charAt(end);
      switch (ch) {
        case '.' -> {
          // dot allowed only once
          if (exponentOffset != -1 || dotSeen) {
            break loop;
          }
          dotSeen = true;
        }
        case 'e', 'E' -> {
          // 'e'/'E' allow only once
          if (exponentOffset != -1) {
            break loop;
          }
          exponentOffset = end;
        }
        case '+', '-' -> {
          // Sign of the exponent.
          // But allowed only if the previous char in the string was 'e' or 'E'.
          if (exponentOffset != end - 1) {
            break loop;
          }
        }
        case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' -> {
          if (exponentOffset != -1) {
            // seeing digit after 'e' or 'E'
            exponentOk = true;
          }
        }
        default -> {
          // ignore garbage at the end
          break loop;
        }
      }
    }
    // ignore 'e'/'E' followed by '+/-' if not real exponent found
    if (exponentOffset != -1 && !exponentOk) {
      end = exponentOffset;
    }
    if (start == end) {
      return Double.NaN;
    }
    try {
      var result = Double.valueOf(str.substring(start, end));
      return negative ? -result : result;
    } catch (NumberFormatException e) {
      return Double.NaN;
    }
  }

  /**
   * ECMA 15.1.2.4, isNaN implementation
   * @param self    self reference
   * @param number  number to check
   * @return true if number is NaN
   */
  public static boolean isNaN(Object self, Object number) {
    return Double.isNaN(JSType.toNumber(number));
  }

  /**
   * ECMA 15.1.2.5, isFinite implementation
   * @param self   self reference
   * @param number number to check
   * @return true if number is infinite
   */
  public static boolean isFinite(Object self, Object number) {
    var value = JSType.toNumber(number);
    return !(Double.isInfinite(value) || Double.isNaN(value));
  }

  /**
   * ECMA 15.1.3.3, encodeURI implementation
   * @param self  self reference
   * @param uri   URI to encode
   * @return encoded URI
   */
  public static Object encodeURI(Object self, Object uri) {
    return URIUtils.encodeURI(self, JSType.toString(uri));
  }

  /**
   * ECMA 15.1.3.4, encodeURIComponent implementation
   * @param self  self reference
   * @param uri   URI component to encode
   * @return encoded URIComponent
   */
  public static Object encodeURIComponent(Object self, Object uri) {
    return URIUtils.encodeURIComponent(self, JSType.toString(uri));
  }

  /**
   * ECMA 15.1.3.1, decodeURI implementation
   * @param self  self reference
   * @param uri   URI to decode
   * @return decoded URI
   */
  public static Object decodeURI(Object self, Object uri) {
    return URIUtils.decodeURI(self, JSType.toString(uri));
  }

  /**
   * ECMA 15.1.3.2, decodeURIComponent implementation
   * @param self  self reference
   * @param uri   URI component to encode
   * @return decoded URI
   */
  public static Object decodeURIComponent(Object self, Object uri) {
    return URIUtils.decodeURIComponent(self, JSType.toString(uri));
  }

  /**
   * ECMA B.2.1, escape implementation
   * @param self    self reference
   * @param string  string to escape
   * @return escaped string
   */
  public static String escape(Object self, Object string) {
    var str = JSType.toString(string);
    var length = str.length();
    if (length == 0) {
      return str;
    }
    var sb = new StringBuilder();
    for (var k = 0; k < length; k++) {
      var ch = str.charAt(k);
      if (UNESCAPED.indexOf(ch) != -1) {
        sb.append(ch);
      } else if (ch < 256) {
        sb.append('%');
        if (ch < 16) {
          sb.append('0');
        }
        sb.append(Integer.toHexString(ch).toUpperCase(Locale.ENGLISH));
      } else {
        sb.append("%u");
        if (ch < 4096) {
          sb.append('0');
        }
        sb.append(Integer.toHexString(ch).toUpperCase(Locale.ENGLISH));
      }
    }
    return sb.toString();
  }

  /**
   * ECMA B.2.2, unescape implementation
   * @param self    self reference
   * @param string  string to unescape
   * @return unescaped string
   */
  public static String unescape(Object self, Object string) {
    var str = JSType.toString(string);
    var length = str.length();
    if (length == 0) {
      return str;
    }
    var sb = new StringBuilder();
    for (var k = 0; k < length; k++) {
      var ch = str.charAt(k);
      if (ch != '%') {
        sb.append(ch);
      } else {
        if (k < (length - 5)) {
          if (str.charAt(k + 1) == 'u') {
            try {
              ch = (char) Integer.parseInt(str.substring(k + 2, k + 6), 16);
              sb.append(ch);
              k += 5;
              continue;
            } catch (NumberFormatException e) {
              //ignored
            }
          }
        }
        if (k < (length - 2)) {
          try {
            ch = (char) Integer.parseInt(str.substring(k + 1, k + 3), 16);
            sb.append(ch);
            k += 2;
            continue;
          } catch (NumberFormatException e) {
            //ignored
          }
        }
        // everything fails
        sb.append(ch);
      }
    }
    return sb.toString();
  }

  /**
   * ECMA 15.3.4 Properties of the Function Prototype Object.
   * The Function prototype object is itself a Function object (its [[Class]] is "Function") that, when invoked, accepts any arguments and returns undefined.
   * This method is used to implement that anonymous function.
   * @param self  self reference
   * @return undefined
   */
  public static Object anonymous(Object self) {
    return ScriptRuntime.UNDEFINED;
  }

  static int fastDigit(int ch, int radix) {
    var n = -1;
    if (ch >= '0' && ch <= '9') {
      n = ch - '0';
    } else if (radix > 10) {
      if (ch >= 'a' && ch <= 'z') {
        n = ch - 'a' + 10;
      } else if (ch >= 'A' && ch <= 'Z') {
        n = ch - 'A' + 10;
      }
    }
    return n < radix ? n : -1;
  }

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), GlobalFunctions.class, name, MH.type(rtype, types));
  }

}
