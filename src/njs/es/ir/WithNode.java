package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for {@code with} statements.
 */
@Immutable
public final class WithNode extends LexicalContextStatement {

  // This expression.
  private final Expression expression;

  // Statements.
  private final Block body;

  /**
   * Constructor
   *
   * @param lineNumber Line number of the header
   * @param token      First token
   * @param finish     Character index of the last token
   * @param expression With expression
   * @param body       Body of with node
   */
  public WithNode(int lineNumber, long token, int finish, Expression expression, Block body) {
    super(lineNumber, token, finish);
    this.expression = expression;
    this.body = body;
  }

  WithNode(WithNode node, Expression expression, Block body) {
    super(node);
    this.expression = expression;
    this.body = body;
  }

  /**
   * Assist in IR navigation.
   * @param visitor IR navigating visitor.
   */
  @Override
  public Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterWithNode(this)) ?
      visitor.leaveWithNode(
        setExpression(lc, (Expression) expression.accept(visitor))
        .setBody(lc, (Block) body.accept(visitor))) : this;
  }

  @Override
  public boolean isTerminal() {
    return body.isTerminal();
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append("with (");
    expression.toString(sb, printType);
    sb.append(')');
  }

  /**
   * Get the body of this WithNode
   * @return the body
   */
  public Block getBody() {
    return body;
  }

  /**
   * Reset the body of this with node
   * @param lc lexical context
   * @param body new body
   * @return new or same withnode
   */
  public WithNode setBody(LexicalContext lc, Block body) {
    return (this.body == body) ? this : Node.replaceInLexicalContext(lc, this, new WithNode(this, expression, body));
  }

  /**
   * Get the expression of this WithNode
   * @return the expression
   */
  public Expression getExpression() {
    return expression;
  }

  /**
   * Reset the expression of this with node
   * @param lc lexical context
   * @param expression new expression
   * @return new or same withnode
   */
  public WithNode setExpression(LexicalContext lc, Expression expression) {
    return (this.expression == expression) ? this : Node.replaceInLexicalContext(lc, this, new WithNode(this, expression, body));
  }

  private static final long serialVersionUID = 1;
}
