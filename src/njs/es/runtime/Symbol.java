package es.runtime;

import java.io.Serializable;
import es.objects.NativeSymbol;

/**
 * This class represents a unique, non-String Object property key as defined in ECMAScript 6.
 */
public final class Symbol implements Serializable {

  private final String name;

  /**
   * Symbol constructor
   * @param name symbol name
   */
  public Symbol(String name) {
    this.name = name;
  }

  @Override
  public String toString() {
    return "Symbol(" + name + ")";
  }

  /**
   * Return the symbol's name
   * @return the name
   */
  public final String getName() {
    return name;
  }

  Object writeReplace() {
    // If this symbol is a globally registered one, replace it with a GlobalSymbol in serialized stream.
    return NativeSymbol.keyFor(null, this) == name ? new GlobalSymbol(name) : this;
  }

  /**
   * Represents a globally registered (with NativeSymbol._for) symbol in the serialized stream.
   * Upon deserialization, it resolves to the globally registered symbol.
   */
  static class GlobalSymbol implements Serializable {

    private final String name;

    GlobalSymbol(String name) {
      this.name = name;
    }

    Object readResolve() {
      return NativeSymbol.from(null, name);
    }

    private static final long serialVersionUID = 1;
  }
  
  private static final long serialVersionUID = 1;
}
