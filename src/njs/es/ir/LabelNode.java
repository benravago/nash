package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for a labeled statement.
 *
 * It implements JoinPredecessor to hold conversions that need to be effected when the block exits normally,
 * but is also targeted by a break statement that might bring different local variable types to the join at the break point.
 */
@Immutable
public final class LabelNode extends LexicalContextStatement implements JoinPredecessor {

  // Label ident.
  private final String labelName;

  // Statements.
  private final Block body;

  private final LocalVariableConversion localVariableConversion;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param labelName  label name
   * @param body       body of label node
   */
  public LabelNode(int lineNumber, long token, int finish, String labelName, Block body) {
    super(lineNumber, token, finish);
    this.labelName = labelName;
    this.body = body;
    this.localVariableConversion = null;
  }

  LabelNode(LabelNode labelNode, String labelName, Block body, LocalVariableConversion localVariableConversion) {
    super(labelNode);
    this.labelName = labelName;
    this.body = body;
    this.localVariableConversion = localVariableConversion;
  }

  @Override
  public boolean isTerminal() {
    return body.isTerminal();
  }

  @Override
  public Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterLabelNode(this)) ? visitor.leaveLabelNode(setBody(lc, (Block) body.accept(visitor))) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append(labelName).append(':');
  }

  /**
   * Get the body of the node
   * @return the body
   */
  public Block getBody() {
    return body;
  }

  /**
   * Reset the body of the node
   * @param lc lexical context
   * @param body new body
   * @return new for node if changed or existing if not
   */
  public LabelNode setBody(LexicalContext lc, Block body) {
    return (this.body == body) ? this : Node.replaceInLexicalContext(lc, this, new LabelNode(this, labelName, body, localVariableConversion));
  }

  /**
   * Get the label name
   * @return the label
   */
  public String getLabelName() {
    return labelName;
  }

  @Override
  public LocalVariableConversion getLocalVariableConversion() {
    return localVariableConversion;
  }

  @Override
  public LabelNode setLocalVariableConversion(LexicalContext lc, LocalVariableConversion localVariableConversion) {
    return (this.localVariableConversion == localVariableConversion) ? this : Node.replaceInLexicalContext(lc, this, new LabelNode(this, labelName, body, localVariableConversion));
  }

}
