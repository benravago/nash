package es.util;

public interface Hex {

  /**
   * Return the system identity hashcode for an object as a human readable string.
   */
  static String id(Object x) {
    return String.format("0x%08x", System.identityHashCode(x));
  }

  /**
   * Add quotes around a string
   *
   * @param str string
   * @return quoted string
   */
  public static String quote(String str) {
    if (str.isEmpty()) {
      return "''";
    }

    var startQuote = '\0';
    var endQuote = '\0';
    var quote = '\0';

    if (str.startsWith("\\") || str.startsWith("\"")) {
      startQuote = str.charAt(0);
    }
    if (str.endsWith("\\") || str.endsWith("\"")) {
      endQuote = str.charAt(str.length() - 1);
    }

    if (startQuote == '\0' || endQuote == '\0') {
      quote = startQuote == '\0' ? endQuote : startQuote;
    }
    if (quote == '\0') {
      quote = '\'';
    }

    return (startQuote == '\0' ? quote : startQuote) + str + (endQuote == '\0' ? quote : endQuote);
  }

  
  /**
   * Make an Exception look like a RuntimeException for the compiler.
   */
  @SuppressWarnings("unchecked")
  static <T extends Throwable, V> V uncheck(Throwable e) throws T {
    throw (T) e;
  }

}
