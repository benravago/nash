package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;
import es.parser.TokenType;

/**
 * IR representation for executing bare expressions.
 *
 * Basically, an expression node means "this code will be executed" and evaluating it results in statements being added to the IR
 */
@Immutable
public final class ExpressionStatement extends Statement {

  // Expression to execute.
  private final Expression expression;

  private final TokenType destructuringDecl;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param expression the expression to execute
   * @param destructuringDecl does this statement represent a destructuring declaration?
   */
  public ExpressionStatement(int lineNumber, long token, int finish, Expression expression, TokenType destructuringDecl) {
    super(lineNumber, token, finish);
    this.expression = expression;
    this.destructuringDecl = destructuringDecl;
  }

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param expression the expression to execute
   */
  public ExpressionStatement(int lineNumber, long token, int finish, Expression expression) {
    this(lineNumber, token, finish, expression, null);
  }

  ExpressionStatement(ExpressionStatement expressionStatement, Expression expression) {
    super(expressionStatement);
    this.expression = expression;
    this.destructuringDecl = null;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterExpressionStatement(this)) ? visitor.leaveExpressionStatement(setExpression((Expression) expression.accept(visitor))) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printTypes) {
    expression.toString(sb, printTypes);
  }

  /**
   * Return the expression to be executed
   * @return the expression
   */
  public Expression getExpression() {
    return expression;
  }

  /**
   * Return declaration type if this expression statement is a destructuring declaration
   * @return declaration type (LET, VAR, CONST) if destructuring declaration, null otherwise.
   */
  public TokenType destructuringDeclarationType() {
    return destructuringDecl;
  }

  /**
   * Reset the expression to be executed
   * @param expression the expression
   * @return new or same execute node
   */
  public ExpressionStatement setExpression(Expression expression) {
    return (this.expression == expression) ? this : new ExpressionStatement(this, expression);
  }

}
