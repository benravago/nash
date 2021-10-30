package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for a WHILE statement.
 *
 * This is the superclass of all loop nodes
 */
@Immutable
public final class WhileNode extends LoopNode {

  // is this a do while node ?
  private final boolean isDoWhile;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param isDoWhile  is this a do while loop?
   * @param test       test expression
   * @param body       body of the while loop
   */
  public WhileNode(int lineNumber, long token, int finish, boolean isDoWhile, JoinPredecessorExpression test, Block body) {
    super(lineNumber, token, finish, body, test, false);
    this.isDoWhile = isDoWhile;
  }

  /**
   * Internal copy constructor
   *
   * @param whileNode while node
   * @param test      Test expression
   * @param body      body of the while loop
   * @param controlFlowEscapes control flow escapes?
   * @param conversion local variable conversion info
   */
  WhileNode(WhileNode whileNode, JoinPredecessorExpression test, Block body, boolean controlFlowEscapes, LocalVariableConversion conversion) {
    super(whileNode, test, body, controlFlowEscapes, conversion);
    this.isDoWhile = whileNode.isDoWhile;
  }

  @Override
  public Node ensureUniqueLabels(LexicalContext lc) {
    return Node.replaceInLexicalContext(lc, this, new WhileNode(this, test, body, controlFlowEscapes, conversion));
  }

  @Override
  public boolean hasGoto() {
    return test == null;
  }

  @Override
  public Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterWhileNode(this)) {
      if (isDoWhile()) {
        return visitor.leaveWhileNode(
          setBody(lc, (Block) body.accept(visitor))
          .setTest(lc, (JoinPredecessorExpression) test.accept(visitor)));
      }
      return visitor.leaveWhileNode(
        setTest(lc, (JoinPredecessorExpression) test.accept(visitor))
        .setBody(lc, (Block) body.accept(visitor)));
    }
    return this;
  }

  @Override
  public WhileNode setTest(LexicalContext lc, JoinPredecessorExpression test) {
    return (this.test == test) ? this : Node.replaceInLexicalContext(lc, this, new WhileNode(this, test, body, controlFlowEscapes, conversion));
  }

  @Override
  public Block getBody() {
    return body;
  }

  @Override
  public WhileNode setBody(LexicalContext lc, Block body) {
    return (this.body == body) ? this : Node.replaceInLexicalContext(lc, this, new WhileNode(this, test, body, controlFlowEscapes, conversion));
  }

  @Override
  public WhileNode setControlFlowEscapes(LexicalContext lc, boolean controlFlowEscapes) {
    return (this.controlFlowEscapes == controlFlowEscapes) ? this : Node.replaceInLexicalContext(lc, this, new WhileNode(this, test, body, controlFlowEscapes, conversion));
  }

  @Override
  JoinPredecessor setLocalVariableConversionChanged(LexicalContext lc, LocalVariableConversion conversion) {
    return Node.replaceInLexicalContext(lc, this, new WhileNode(this, test, body, controlFlowEscapes, conversion));
  }

  /**
   * Check if this is a do while loop or a normal while loop
   * @return true if do while
   */
  public boolean isDoWhile() {
    return isDoWhile;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append("while (");
    test.toString(sb, printType);
    sb.append(')');
  }

  @Override
  public boolean mustEnter() {
    return isDoWhile() || (test == null);
  }

  @Override
  public boolean hasPerIterationScope() {
    return false;
  }

  private static final long serialVersionUID = 1;
}
