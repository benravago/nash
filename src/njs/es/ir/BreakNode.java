package es.ir;

import es.codegen.Label;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for {@code break} statements.
 */
@Immutable
public final class BreakNode extends JumpStatement {

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param labelName  label name for break or null if none
   */
  public BreakNode(int lineNumber, long token, int finish, String labelName) {
    super(lineNumber, token, finish, labelName);
  }

  BreakNode(BreakNode breakNode, LocalVariableConversion conversion) {
    super(breakNode, conversion);
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterBreakNode(this)) ? visitor.leaveBreakNode(this) : this;
  }

  @Override
  JumpStatement createNewJumpStatement(LocalVariableConversion conversion) {
    return new BreakNode(this, conversion);
  }

  @Override
  String getStatementName() {
    return "break";
  }

  @Override
  public BreakableNode getTarget(LexicalContext lc) {
    return lc.getBreakable(getLabelName());
  }

  @Override
  Label getTargetLabel(BreakableNode target) {
    return target.getBreakLabel();
  }

}
