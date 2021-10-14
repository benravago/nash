package nash.scripting;

import es.runtime.JSType;

/**
 * Default implementation of {@link JSObject#getDefaultValue(Class)}.
 *
 * Isolated into a separate class mostly so that we can have private static instances of function name arrays,
 * something we couldn't declare without it being visible in {@link JSObject} interface.
 */
class DefaultValue {

  private static final String[] DEFAULT_VALUE_FNS_NUMBER = {"valueOf", "toString"};
  private static final String[] DEFAULT_VALUE_FNS_STRING = {"toString", "valueOf"};

  static Object get(JSObject jsobj, Class<?> hint) throws UnsupportedOperationException {
    var isNumber = hint == null || hint == Number.class;
    for (var methodName : isNumber ? DEFAULT_VALUE_FNS_NUMBER : DEFAULT_VALUE_FNS_STRING) {
      var objMember = jsobj.getMember(methodName);
      if (objMember instanceof JSObject member) {
        if (member.isFunction()) {
          var value = member.call(jsobj);
          if (JSType.isPrimitive(value)) {
            return value;
          }
        }
      }
    }
    throw new UnsupportedOperationException(isNumber ? "cannot.get.default.number" : "cannot.get.default.string");
  }

}
