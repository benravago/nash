package nash.scripting;

import es.runtime.JSType;

/**
 * Default implementation of {@link JSObject#getDefaultValue(Class)}. Isolated into a separate class mostly so
 * that we can have private static instances of function name arrays, something we couldn't declare without it
 * being visible in {@link JSObject} interface.
 */
class DefaultValueImpl {

  private static final String[] DEFAULT_VALUE_FNS_NUMBER = new String[]{"valueOf", "toString"};
  private static final String[] DEFAULT_VALUE_FNS_STRING = new String[]{"toString", "valueOf"};

  static Object getDefaultValue(final JSObject jsobj, final Class<?> hint) throws UnsupportedOperationException {
    final boolean isNumber = hint == null || hint == Number.class;
    for (final String methodName : isNumber ? DEFAULT_VALUE_FNS_NUMBER : DEFAULT_VALUE_FNS_STRING) {
      final Object objMember = jsobj.getMember(methodName);
      if (objMember instanceof JSObject) {
        final JSObject member = (JSObject) objMember;
        if (member.isFunction()) {
          final Object value = member.call(jsobj);
          if (JSType.isPrimitive(value)) {
            return value;
          }
        }
      }
    }
    throw new UnsupportedOperationException(isNumber ? "cannot.get.default.number" : "cannot.get.default.string");
  }
}
