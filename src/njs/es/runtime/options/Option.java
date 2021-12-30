package es.runtime.options;

/**
 * A simple facade for System.getProperties().
 * It's main function is to add a standard prefix to the supplied key and require a default value.
 */
public interface Option {
  
  static final String prefix = "nash.";
  
  static boolean get(String key, boolean def) {
    key = prefix+key;
    return System.getProperties().contains(key) ? Boolean.getBoolean(key) : def;
  }
  
  static int get(String key, int def) {
    return Integer.getInteger(prefix+key, def);
  }

  static long get(String key, long def) {
    return Long.getLong(prefix+key, def);
  }

  static String get(String key, String def) {
    return System.getProperty(prefix+key, def);
  }
  
}
