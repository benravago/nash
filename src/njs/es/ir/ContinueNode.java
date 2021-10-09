package es.ir;

import es.codegen.Label;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for CONTINUE statements.
 */
@Immutable
public class ContinueNode extends JumpStatement {

  private static final long serialVersionUID = 1L;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param labelName  label name for continue or null if none
   */
  public ContinueNode(final int lineNumber, final long token, final int finish, final String labelName) {
    super(lineNumber, token, finish, labelName);
  }

  private ContinueNode(final ContinueNode continueNode, final LocalVariableConversion conversion) {
    super(continueNode, conversion);
  }

  @Override
  public Node accept(final NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterContinueNode(this)) {
      return visitor.leaveContinueNode(this);
    }

    return this;
  }

  @Override
  JumpStatement createNewJumpStatement(final LocalVariableConversion conversion) {
    return new ContinueNode(this, conversion);
  }

  @Override
  String getStatementName() {
    return "continue";
  }

  @Override
  public BreakableNode getTarget(final LexicalContext lc) {
    return lc.getContinueTo(getLabelName());
  }

  @Override
  Label getTargetLabel(final BreakableNode target) {
    return ((LoopNode) target).getContinueLabel();
  }
}
