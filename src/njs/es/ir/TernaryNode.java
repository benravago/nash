package es.ir;

import es.codegen.types.Type;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * TernaryNode represent the ternary operator {@code ?:}.
 *
 * Note that for control-flow calculation reasons its branch expressions (but not its test expression) are always wrapped in instances of {@link JoinPredecessorExpression}.
 */
@Immutable
public final class TernaryNode extends Expression {

  private final Expression test;
  private final JoinPredecessorExpression trueExpr;
  private final JoinPredecessorExpression falseExpr;

  /**
   * Constructor
   *
   * @param token token
   * @param test test expression
   * @param trueExpr expression evaluated when test evaluates to true
   * @param falseExpr expression evaluated when test evaluates to true
   */
  public TernaryNode(long token, Expression test, JoinPredecessorExpression trueExpr, JoinPredecessorExpression falseExpr) {
    super(token, falseExpr.getFinish());
    this.test = test;
    this.trueExpr = trueExpr;
    this.falseExpr = falseExpr;
  }

  TernaryNode(TernaryNode ternaryNode, Expression test, JoinPredecessorExpression trueExpr, JoinPredecessorExpression falseExpr) {
    super(ternaryNode);
    this.test = test;
    this.trueExpr = trueExpr;
    this.falseExpr = falseExpr;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterTernaryNode(this)) ?
      visitor.leaveTernaryNode(
        setTest((Expression) getTest().accept(visitor))
        .setTrueExpression((JoinPredecessorExpression) trueExpr.accept(visitor))
        .setFalseExpression((JoinPredecessorExpression) falseExpr.accept(visitor))) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    var tokenType = tokenType();
    var testParen = tokenType.needsParens(getTest().tokenType(), true);
    var trueParen = tokenType.needsParens(getTrueExpression().tokenType(), false);
    var falseParen = tokenType.needsParens(getFalseExpression().tokenType(), false);
    if (testParen) {
      sb.append('(');
    }
    getTest().toString(sb, printType);
    if (testParen) {
      sb.append(')');
    }
    sb.append(" ? ");
    if (trueParen) {
      sb.append('(');
    }
    getTrueExpression().toString(sb, printType);
    if (trueParen) {
      sb.append(')');
    }
    sb.append(" : ");
    if (falseParen) {
      sb.append('(');
    }
    getFalseExpression().toString(sb, printType);
    if (falseParen) {
      sb.append(')');
    }
  }

  @Override
  public boolean isLocal() {
    return getTest().isLocal() && getTrueExpression().isLocal() && getFalseExpression().isLocal();
  }

  @Override
  public Type getType() {
    return Type.widestReturnType(getTrueExpression().getType(), getFalseExpression().getType());
  }

  /**
   * Get the test expression for this ternary expression, i.e. "x" in x ? y : z
   * @return the test expression
   */
  public Expression getTest() {
    return test;
  }

  /**
   * Get the true expression for this ternary expression, i.e. "y" in x ? y : z
   * @return the true expression
   */
  public JoinPredecessorExpression getTrueExpression() {
    return trueExpr;
  }

  /**
   * Get the false expression for this ternary expression, i.e. "z" in x ? y : z
   * @return the false expression
   */
  public JoinPredecessorExpression getFalseExpression() {
    return falseExpr;
  }

  /**
   * Set the test expression for this node
   * @param test new test expression
   * @return a node equivalent to this one except for the requested change.
   */
  public TernaryNode setTest(Expression test) {
    return (this.test == test) ? this : new TernaryNode(this, test, trueExpr, falseExpr);
  }

  /**
   * Set the true expression for this node
   * @param trueExpr new true expression
   * @return a node equivalent to this one except for the requested change.
   */
  public TernaryNode setTrueExpression(JoinPredecessorExpression trueExpr) {
    return (this.trueExpr == trueExpr) ? this : new TernaryNode(this, test, trueExpr, falseExpr);
  }

  /**
   * Set the false expression for this node
   * @param falseExpr new false expression
   * @return a node equivalent to this one except for the requested change.
   */
  public TernaryNode setFalseExpression(JoinPredecessorExpression falseExpr) {
    return (this.falseExpr == falseExpr) ? this : new TernaryNode(this, test, trueExpr, falseExpr);
  }

  private static final long serialVersionUID = 1;
}
