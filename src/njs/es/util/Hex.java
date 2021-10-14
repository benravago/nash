package es.util;

public interface Hex {

  /**
   * Return the system identity hashcode for an object as a human readable string.
   */
  static String id(Object x) {
    return String.format("0x%08x", System.identityHashCode(x));
  }

  /**
   * Make an Exception look like a RuntimeException for the compiler.
   */
  @SuppressWarnings("unchecked")
  static <T extends Throwable, V> V uncheck(Throwable e) throws T {
    throw (T) e;
  }

}
