package es.ir;

import es.codegen.types.Type;

/**
 * Class describing one or more local variable conversions that needs to be performed on entry to a control flow join point.
 *
 * Note that the class is named as a singular "Conversion" and not a plural "Conversions",
 * but instances of the class have a reference to the next conversion,
 * so multiple conversions are always represented with a single instance that is a head of a linked list of instances.
 * @see JoinPredecessor
 */
public final class LocalVariableConversion {

  private final Symbol symbol;
  
  // TODO: maybe introduce a type pair class? These will often be repeated.
  private final Type from;
  private final Type to;

  private final LocalVariableConversion next;

  /**
   * Creates a new object representing a local variable conversion.
   * @param symbol the symbol representing the local variable whose value is being converted.
   * @param from the type value is being converted from.
   * @param to the type value is being converted to.
   * @param next next conversion at the same join point, if any (the conversion object implements a singly-linked list of conversions).
   */
  public LocalVariableConversion(Symbol symbol, Type from, Type to, LocalVariableConversion next) {
    this.symbol = symbol;
    this.from = from;
    this.to = to;
    this.next = next;
  }

  /**
   * Returns the type being converted from.
   * @return the type being converted from.
   */
  public Type getFrom() {
    return from;
  }

  /**
   * Returns the type being converted to.
   * @return the type being converted to.
   */
  public Type getTo() {
    return to;
  }

  /**
   * Returns the next conversion at the same join point, or null if this is the last one.
   * @return the next conversion at the same join point.
   */
  public LocalVariableConversion getNext() {
    return next;
  }

  /**
   * Returns the symbol representing the local variable whose value is being converted.
   * @return the symbol representing the local variable whose value is being converted.
   */
  public Symbol getSymbol() {
    return symbol;
  }

  /**
   * Returns true if this conversion is live.
   * A conversion is live if the symbol has a slot for the conversion's {@link #getTo() to} type. If a conversion is dead, it can be omitted in code generator.
   * @return true if this conversion is live.
   */
  public boolean isLive() {
    return symbol.hasSlotFor(to);
  }

  /**
   * Returns true if this conversion {@link #isLive()}, or if any of its {@link #getNext()} conversions are live.
   * @return true if this conversion, or any conversion following it, are live.
   */
  public boolean isAnyLive() {
    return isLive() || isAnyLive(next);
  }

  /**
   * Returns true if the passed join predecessor has {@link #isAnyLive()} conversion.
   * @param jp the join predecessor being examined.
   * @return true if the join predecessor conversion is not null and {@link #isAnyLive()}.
   */
  public static boolean hasLiveConversion(JoinPredecessor jp) {
    return isAnyLive(jp.getLocalVariableConversion());
  }

  /**
   * Returns true if the passed conversion is not null, and it {@link #isAnyLive()}.
   * @param conv the conversion being tested for liveness.
   * @return true if the conversion is not null and {@link #isAnyLive()}.
   */
  static boolean isAnyLive(LocalVariableConversion conv) {
    return conv != null && conv.isAnyLive();
  }

  @Override
  public String toString() {
    return toString(new StringBuilder()).toString();
  }

  /**
   * Generates a string representation of this conversion in the passed string builder.
   * @param sb the string builder in which to generate a string representation of this conversion.
   * @return the passed in string builder.
   */
  public StringBuilder toString(StringBuilder sb) {
    if (isLive()) {
      return toStringNext(sb.append('\u27e6'), true).append("\u27e7 ");
    }
    return next == null ? sb : next.toString(sb);
  }

  /**
   * Generates a string representation of the passed conversion in the passed string builder.
   * @param conv the conversion to render in the string builder.
   * @param sb the string builder in which to generate a string representation of this conversion.
   * @return the passed in string builder.
   */
  public static StringBuilder toString(LocalVariableConversion conv, StringBuilder sb) {
    return conv == null ? sb : conv.toString(sb);
  }

  StringBuilder toStringNext(StringBuilder sb, boolean first) {
    if (isLive()) {
      if (!first) {
        sb.append(", ");
      }
      sb.append(symbol.getName()).append(':').append(getTypeChar(from)).append('\u2192').append(getTypeChar(to));
      return next == null ? sb : next.toStringNext(sb, false);
    }
    return next == null ? sb : next.toStringNext(sb, first);
  }

  static char getTypeChar(Type type) {
    return (type == Type.UNDEFINED) ? 'U'
         : (type.isObject()) ? 'O'
         : (type == Type.BOOLEAN) ? 'Z'
         : type.getBytecodeStackType();
  }

}
