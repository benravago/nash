package es.ir;

import es.codegen.types.Type;
import es.ir.visitor.NodeVisitor;

/**
 * A wrapper for an expression that is in a position to be a join predecessor.
 */
public class JoinPredecessorExpression extends Expression implements JoinPredecessor {

  private final Expression expression;
  private final LocalVariableConversion conversion;

  /**
   * A no-arg constructor does not wrap any expression on its own,
   * but can be used as a place to contain a local variable conversion in a place where an expression can otherwise stand.
   */
  public JoinPredecessorExpression() {
    this(null);
  }

  /**
   * A constructor for wrapping an expression and making it a join predecessor.
   * Typically used on true and false subexpressions of the ternary node as well as on the operands of short-circuiting logical expressions {@code &&} and {@code ||}.
   * @param expression the expression to wrap
   */
  public JoinPredecessorExpression(Expression expression) {
    this(expression, null);
  }

  JoinPredecessorExpression(Expression expression, LocalVariableConversion conversion) {
    super(expression == null ? 0L : expression.getToken(), expression == null ? 0 : expression.getStart(), expression == null ? 0 : expression.getFinish());
    this.expression = expression;
    this.conversion = conversion;
  }

  @Override
  public JoinPredecessor setLocalVariableConversion(LexicalContext lc, LocalVariableConversion conversion) {
    return (conversion == this.conversion) ? this : new JoinPredecessorExpression(expression, conversion);
  }

  @Override
  public Type getType() {
    return expression.getType();
  }

  @Override
  public boolean isAlwaysFalse() {
    return expression != null && expression.isAlwaysFalse();
  }

  @Override
  public boolean isAlwaysTrue() {
    return expression != null && expression.isAlwaysTrue();
  }

  /**
   * Returns the underlying expression.
   * @return the underlying expression.
   */
  public Expression getExpression() {
    return expression;
  }

  /**
   * Sets the underlying expression.
   * @param expression the new underlying expression
   * @return this or modified join predecessor expression object.
   */
  public JoinPredecessorExpression setExpression(Expression expression) {
    return (expression == this.expression) ? this : new JoinPredecessorExpression(expression, conversion);
  }

  @Override
  public LocalVariableConversion getLocalVariableConversion() {
    return conversion;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterJoinPredecessorExpression(this)) {
      var  expr = getExpression();
      return visitor.leaveJoinPredecessorExpression(expr == null ? this : setExpression((Expression) expr.accept(visitor)));
    }
    return this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    if (expression != null) {
      expression.toString(sb, printType);
    }
    if (conversion != null) {
      conversion.toString(sb);
    }
  }

}
