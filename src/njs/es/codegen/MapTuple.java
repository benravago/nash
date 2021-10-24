package es.codegen;

import es.codegen.types.Type;
import es.ir.Symbol;

/**
 * A tuple of values used for map creation
 * @param <T> value type
 */
class MapTuple<T> {

  final String key;
  final Symbol symbol;
  final Type type;
  final T value;

  MapTuple(String key, Symbol symbol, Type type) {
    this(key, symbol, type, null);
  }

  MapTuple(String key, Symbol symbol, Type type, T value) {
    this.key = key;
    this.symbol = symbol;
    this.type = type;
    this.value = value;
  }

  public Class<?> getValueType() {
    return null; //until proven otherwise we are undefined, see NASHORN-592 int.class;
  }

  boolean isPrimitive() {
    return getValueType() != null && getValueType().isPrimitive() && getValueType() != boolean.class;
  }

  @Override
  public String toString() {
    return "[key=" + key + ", symbol=" + symbol + ", value=" + value + " (" + (value == null ? "null" : value.getClass().getSimpleName()) + ")]";
  }

}
