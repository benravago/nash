package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for THROW statements.
 */
@Immutable
public final class ThrowNode extends Statement implements JoinPredecessor {

  // Exception expression.
  private final Expression expression;

  private final LocalVariableConversion conversion;

  private final boolean isSyntheticRethrow;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param expression expression to throw
   * @param isSyntheticRethrow true if this throw node is part of a synthetic rethrow.
   */
  public ThrowNode(int lineNumber, long token, int finish, Expression expression, boolean isSyntheticRethrow) {
    super(lineNumber, token, finish);
    this.expression = expression;
    this.isSyntheticRethrow = isSyntheticRethrow;
    this.conversion = null;
  }

  ThrowNode(ThrowNode node, Expression expression, boolean isSyntheticRethrow, LocalVariableConversion conversion) {
    super(node);
    this.expression = expression;
    this.isSyntheticRethrow = isSyntheticRethrow;
    this.conversion = conversion;
  }

  @Override
  public boolean isTerminal() {
    return true;
  }

  /**
   * Assist in IR navigation.
   * @param visitor IR navigating visitor.
   */
  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterThrowNode(this)) ? visitor.leaveThrowNode(setExpression((Expression) expression.accept(visitor))) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append("throw ");
    if (expression != null) {
      expression.toString(sb, printType);
    }
    if (conversion != null) {
      conversion.toString(sb);
    }
  }

  /**
   * Get the expression that is being thrown by this node
   * @return expression
   */
  public Expression getExpression() {
    return expression;
  }

  /**
   * Reset the expression being thrown by this node
   * @param expression new expression
   * @return new or same thrownode
   */
  public ThrowNode setExpression(Expression expression) {
    return (this.expression == expression) ? this : new ThrowNode(this, expression, isSyntheticRethrow, conversion);
  }

  /**
   * Is this a throw a synthetic rethrow in a synthetic catch-all block created when inlining finally statements?
   * In that case we never wrap whatever is thrown into an ECMAException, just rethrow it.
   * @return true if synthetic throw node
   */
  public boolean isSyntheticRethrow() {
    return isSyntheticRethrow;
  }

  @Override
  public JoinPredecessor setLocalVariableConversion(LexicalContext lc, LocalVariableConversion conversion) {
    return (this.conversion == conversion) ? this : new ThrowNode(this, expression, isSyntheticRethrow, conversion);
  }

  @Override
  public LocalVariableConversion getLocalVariableConversion() {
    return conversion;
  }

}
