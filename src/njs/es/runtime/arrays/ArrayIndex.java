package es.runtime.arrays;

import es.runtime.ConsString;
import es.runtime.JSType;
import es.runtime.ScriptObject;

/**
 * Array index computation helpers. that both throw exceptions or return invalid values.
 */
public final class ArrayIndex {

  private static final int INVALID_ARRAY_INDEX = -1;
  private static final long MAX_ARRAY_INDEX = 0xfffffffeL;

  /**
   * Fast conversion of non-negative integer string to long.
   * @param key Key as a string.
   * @return long value of string or {@code -1} if string does not represent a valid index.
   */
  static long fromString(String key) {
    long value = 0;
    var length = key.length();
    // Check for empty string or leading 0
    if (length == 0 || (length > 1 && key.charAt(0) == '0')) {
      return INVALID_ARRAY_INDEX;
    }
    // Fast toNumber.
    for (var i = 0; i < length; i++) {
      var digit = key.charAt(i);
      // If not a digit.
      if (digit < '0' || digit > '9') {
        return INVALID_ARRAY_INDEX;
      }
      // Insert digit.
      value = value * 10 + digit - '0';
      // Check for overflow (need to catch before wrap around.)
      if (value > MAX_ARRAY_INDEX) {
        return INVALID_ARRAY_INDEX;
      }
    }
    return value;
  }

  /**
   * Returns a valid array index in an int, if the object represents one.
   * This routine needs to perform quickly since all keys are tested with it.
   * <p>
   * The {@code key} parameter must be a JavaScript primitive type, i.e. one of {@code String}, {@code Number}, {@code Boolean}, {@code null}, or {@code undefined}.
   * {@code ScriptObject} instances should be converted to primitive with {@code String.class} hint before being passed to this method.
   * <p>
   * @param  key key to check for array index.
   * @return the array index, or {@code -1} if {@code key} does not represent a valid index.
   *   Note that negative return values other than {@code -1} are considered valid and can be converted to the actual index using {@link #toLongIndex(int)}.
   */
  public static int getArrayIndex(Object key) {
    if (key instanceof Integer i) {
      return getArrayIndex(i.intValue());
    } else if (key instanceof Double d) {
      return getArrayIndex(d.doubleValue());
    } else if (key instanceof String s) {
      return (int) fromString(s);
    } else if (key instanceof Long l) {
      return getArrayIndex(l.longValue());
    } else if (key instanceof ConsString) {
      return (int) fromString(key.toString());
    }
    assert !(key instanceof ScriptObject);
    return INVALID_ARRAY_INDEX;
  }

  /**
   * Returns a valid array index in an int, if {@code key} represents one.
   * @param key key to check
   * @return the array index, or {@code -1} if {@code key} is not a valid array index.
   */
  public static int getArrayIndex(int key) {
    return (key >= 0) ? key : INVALID_ARRAY_INDEX;
  }

  /**
   * Returns a valid array index in an int, if the long represents one.
   * @param key key to check
   * @return the array index, or {@code -1} if long is not a valid array index.
   *   Note that negative return values other than {@code -1} are considered valid and can be converted to the actual index using {@link #toLongIndex(int)}.
   */
  public static int getArrayIndex(long key) {
    return (key >= 0 && key <= MAX_ARRAY_INDEX) ? (int) key : INVALID_ARRAY_INDEX;
  }

  /**
   * Return a valid index for this double, if it represents one.
   * Doubles that aren't representable exactly as longs/ints aren't working array indexes, however, array[1.1] === array["1.1"] in JavaScript.
   * @param key the key to check
   * @return the array index this double represents or {@code -1} if this isn't a valid index.
   *   Note that negative return values other than {@code -1} are considered valid and can be converted to the actual index using {@link #toLongIndex(int)}.
   */
  public static int getArrayIndex(double key) {
    return (JSType.isRepresentableAsInt(key)) ? getArrayIndex((int) key)
         : (JSType.isRepresentableAsLong(key)) ? getArrayIndex((long) key)
         : INVALID_ARRAY_INDEX;
  }

  /**
   * Return a valid array index for this string, if it represents one.
   * @param key the key to check
   * @return the array index this string represents or {@code -1} if this isn't a valid index.
   *    Note that negative return values other than {@code -1} are considered valid and can be converted to the actual index using {@link #toLongIndex(int)}.
   */
  public static int getArrayIndex(String key) {
    return (int) fromString(key);
  }

  /**
   * Check whether an index is valid as an array index.
   * This check only tests if it is the special "invalid array index" type, not if it is e.g. less than zero or corrupt in some other way
   * @param index index to test
   * @return true if {@code index} is not the special invalid array index type
   */
  public static boolean isValidArrayIndex(int index) {
    return index != INVALID_ARRAY_INDEX;
  }

  /**
   * Convert an index to a long value.
   * This basically amounts to converting it into a {@link JSType#toUint32(int)} uint32} as the maximum array index in JavaScript is 0xfffffffe
   * @param index index to convert to long form
   * @return index as uint32 in a long
   */
  public static long toLongIndex(int index) {
    return JSType.toUint32(index);
  }

  /**
   * Convert an index to a key string.
   * This is the same as calling {@link #toLongIndex(int)} and converting the result to String.
   * @param index index to convert
   * @return index as string
   */
  public static String toKey(int index) {
    return Long.toString(JSType.toUint32(index));
  }

}
