package es.ir;

import java.util.Objects;

import es.codegen.Label;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for synthetic jump into an inlined finally statement.
 */
@Immutable
public final class JumpToInlinedFinally extends JumpStatement {

  /**
   * Constructor
   *
   * @param labelName  label name for inlined finally block
   */
  public JumpToInlinedFinally(String labelName) {
    super(NO_LINE_NUMBER, NO_TOKEN, NO_FINISH, Objects.requireNonNull(labelName));
  }

  JumpToInlinedFinally(JumpToInlinedFinally breakNode, LocalVariableConversion conversion) {
    super(breakNode, conversion);
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterJumpToInlinedFinally(this)) ? visitor.leaveJumpToInlinedFinally(this) : this;
  }

  @Override
  JumpStatement createNewJumpStatement(LocalVariableConversion conversion) {
    return new JumpToInlinedFinally(this, conversion);
  }

  @Override
  String getStatementName() {
    return ":jumpToInlinedFinally";
  }

  @Override
  public Block getTarget(LexicalContext lc) {
    return lc.getInlinedFinally(getLabelName());
  }

  @Override
  public TryNode getPopScopeLimit(LexicalContext lc) {
    // Returns the try node to which this jump's target belongs.
    // This will make scope popping also pop the scope for the body of the try block, if it needs scope.
    return lc.getTryNodeForInlinedFinally(getLabelName());
  }

  @Override
  Label getTargetLabel(BreakableNode target) {
    assert target != null;
    // We're jumping to the entry of the inlined finally block
    return ((Block) target).getEntryLabel();
  }

}
