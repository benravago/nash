package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;
import static es.parser.TokenType.*;

/**
 * IR representation for RETURN or YIELD statements.
 */
@Immutable
public class ReturnNode extends Statement {

  // Optional expression.
  private final Expression expression;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param expression expression to return
   */
  public ReturnNode(int lineNumber, long token, int finish, Expression expression) {
    super(lineNumber, token, finish);
    this.expression = expression;
  }

  private ReturnNode(ReturnNode returnNode, Expression expression) {
    super(returnNode);
    this.expression = expression;
  }

  @Override
  public boolean isTerminal() {
    return true;
  }

  /**
   * Return true if is a RETURN node.
   * @return true if is RETURN node.
   */
  public boolean isReturn() {
    return isTokenType(RETURN);
  }

  /**
   * Check if this return node has an expression
   * @return true if not a void return
   */
  public boolean hasExpression() {
    return expression != null;
  }

  /**
   * Return true if is a YIELD node.
   * @return TRUE if is YIELD node.
   */
  public boolean isYield() {
    return isTokenType(YIELD);
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterReturnNode(this)) {
      if (expression != null) {
        return visitor.leaveReturnNode(setExpression((Expression) expression.accept(visitor)));
      }
      return visitor.leaveReturnNode(this);
    }
    return this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append(isYield() ? "yield" : "return");
    if (expression != null) {
      sb.append(' ');
      expression.toString(sb, printType);
    }
  }

  /**
   * Get the expression this node returns
   * @return return expression, or null if void return
   */
  public Expression getExpression() {
    return expression;
  }

  /**
   * Reset the expression this node returns
   * @param expression new expression, or null if void return
   * @return new or same return node
   */
  public ReturnNode setExpression(Expression expression) {
    return (this.expression == expression) ? this : new ReturnNode(this, expression);
  }

  private static final long serialVersionUID = 1;
}
