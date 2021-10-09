package es.ir;

import es.codegen.Label;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for {@code break} statements.
 */
@Immutable
public final class BreakNode extends JumpStatement {

  private static final long serialVersionUID = 1L;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param labelName  label name for break or null if none
   */
  public BreakNode(final int lineNumber, final long token, final int finish, final String labelName) {
    super(lineNumber, token, finish, labelName);
  }

  private BreakNode(final BreakNode breakNode, final LocalVariableConversion conversion) {
    super(breakNode, conversion);
  }

  @Override
  public Node accept(final NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterBreakNode(this)) {
      return visitor.leaveBreakNode(this);
    }

    return this;
  }

  @Override
  JumpStatement createNewJumpStatement(final LocalVariableConversion conversion) {
    return new BreakNode(this, conversion);
  }

  @Override
  String getStatementName() {
    return "break";
  }

  @Override
  public BreakableNode getTarget(final LexicalContext lc) {
    return lc.getBreakable(getLabelName());
  }

  @Override
  Label getTargetLabel(final BreakableNode target) {
    return target.getBreakLabel();
  }
}
