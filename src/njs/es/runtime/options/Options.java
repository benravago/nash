package es.runtime.options;

import java.util.function.Function;

/**
 * A simple option value provider.
 * Similar to Option but uses a Function to supply string value's for a given key.
 */
public class Options {

  final Function<String,String> src;
  
  public Options(Function<String,String> src) {
    this.src = src;
  }

  public String get(String key, String def) {
    var value = src.apply(key);
    return value != null ? value : def;
  }

  public boolean get(String key, boolean def) {
    var value = src.apply(key);
    return value != null ? Boolean.parseBoolean(value) : def;
  }
  
  public int get(String key, int def) {
    var value = src.apply(key);
    if (value != null) {
      try { return Integer.parseInt(value); }
      catch (NumberFormatException ignore) {}
    }
    return def;
  }
  
}
