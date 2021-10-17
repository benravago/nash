package es.ir;

import es.codegen.Label;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for CONTINUE statements.
 */
@Immutable
public class ContinueNode extends JumpStatement {

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param labelName  label name for continue or null if none
   */
  public ContinueNode(int lineNumber, long token, int finish, String labelName) {
    super(lineNumber, token, finish, labelName);
  }

  ContinueNode(ContinueNode continueNode, LocalVariableConversion conversion) {
    super(continueNode, conversion);
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterContinueNode(this)) ? visitor.leaveContinueNode(this) : this;
  }

  @Override
  JumpStatement createNewJumpStatement(LocalVariableConversion conversion) {
    return new ContinueNode(this, conversion);
  }

  @Override
  String getStatementName() {
    return "continue";
  }

  @Override
  public BreakableNode getTarget(LexicalContext lc) {
    return lc.getContinueTo(getLabelName());
  }

  @Override
  Label getTargetLabel(BreakableNode target) {
    return ((LoopNode) target).getContinueLabel();
  }

}
