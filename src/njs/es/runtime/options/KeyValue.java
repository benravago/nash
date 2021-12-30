package es.runtime.options;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.StringTokenizer;

/**
 * Key Value option such as logger.
 *
 * It comes on the format such as:
 * {@code --log=module1:level1,module2:level2... }
 */
class KeyValue extends Value<String> {

  /**
   * Map of keys given
   */
  protected Map<String, String> map;

  KeyValue(String value) {
    super(value);
    initialize();
  }

  Map<String, String> getValues() {
    return Collections.unmodifiableMap(map);
  }

  /**
   * Check if the key value option has a value or if it has not been initialized
   *
   * @param key the key
   * @return value, or null if not initialized
   */
  public boolean hasValue(String key) {
    return map != null && map.get(key) != null;
  }

  String getValue(String key) {
    if (map == null) {
      return null;
    }
    var val = map.get(key);
    return "".equals(val) ? null : val;
  }

  void initialize() {
    if (getValue() == null) {
      return;
    }

    map = new LinkedHashMap<>();

    var st = new StringTokenizer(getValue(), ",");
    while (st.hasMoreElements()) {
      var token = st.nextToken();
      var keyValue = token.split(":");

      if (keyValue.length == 1) {
        map.put(keyValue[0], "");
      } else if (keyValue.length == 2) {
        map.put(keyValue[0], keyValue[1]);
      } else {
        throw new IllegalArgumentException(token);
      }
    }
  }

}
