package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for an IF statement.
 */
@Immutable
public final class IfNode extends Statement implements JoinPredecessor {

  // Test expression.
  private final Expression test;

  // Pass statements.
  private final Block pass;

  // Fail statements.
  private final Block fail;

  // Local variable conversions that need to be performed after test if it evaluates to false, and there's no else branch.
  private final LocalVariableConversion conversion;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param test       test
   * @param pass       block to execute when test passes
   * @param fail       block to execute when test fails or null
   */
  public IfNode(int lineNumber, long token, int finish, Expression test, Block pass, Block fail) {
    super(lineNumber, token, finish);
    this.test = test;
    this.pass = pass;
    this.fail = fail;
    this.conversion = null;
  }

  IfNode(IfNode ifNode, Expression test, Block pass, Block fail, LocalVariableConversion conversion) {
    super(ifNode);
    this.test = test;
    this.pass = pass;
    this.fail = fail;
    this.conversion = conversion;
  }

  @Override
  public boolean isTerminal() {
    return pass.isTerminal() && fail != null && fail.isTerminal();
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterIfNode(this)) ?
      visitor.leaveIfNode(
        setTest((Expression) test.accept(visitor))
        .setPass((Block) pass.accept(visitor))
        .setFail(fail == null ? null : (Block) fail.accept(visitor))) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printTypes) {
    sb.append("if (");
    test.toString(sb, printTypes);
    sb.append(')');
  }

  /**
   * Get the else block of this IfNode
   * @return the else block, or null if none exists
   */
  public Block getFail() {
    return fail;
  }

  IfNode setFail(Block fail) {
    return (this.fail == fail) ? this : new IfNode(this, test, pass, fail, conversion);
  }

  /**
   * Get the then block for this IfNode
   * @return the then block
   */
  public Block getPass() {
    return pass;
  }

  IfNode setPass(Block pass) {
    return (this.pass == pass) ? this : new IfNode(this, test, pass, fail, conversion);
  }

  /**
   * Get the test expression for this IfNode
   * @return the test expression
   */
  public Expression getTest() {
    return test;
  }

  /**
   * Reset the test expression for this IfNode
   * @param test a new test expression
   * @return new or same IfNode
   */
  public IfNode setTest(Expression test) {
    return (this.test == test) ? this : new IfNode(this, test, pass, fail, conversion);
  }

  @Override
  public IfNode setLocalVariableConversion(LexicalContext lc, LocalVariableConversion conversion) {
    return (this.conversion == conversion) ? this : new IfNode(this, test, pass, fail, conversion);
  }

  @Override
  public LocalVariableConversion getLocalVariableConversion() {
    return conversion;
  }

  private static final long serialVersionUID = 1;
}
