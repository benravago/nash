package es.ir;

import es.codegen.Label;

/**
 * Common base class for jump statements (e.g. {@code break} and {@code continue}).
 */
public abstract class JumpStatement extends Statement implements JoinPredecessor {

  private final String labelName;
  private final LocalVariableConversion conversion;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param labelName  label name for break or null if none
   */
  protected JumpStatement(int lineNumber, long token, int finish, String labelName) {
    super(lineNumber, token, finish);
    this.labelName = labelName;
    this.conversion = null;
  }

  /**
   * Copy constructor.
   * @param jumpStatement the original jump statement.
   * @param conversion a new local variable conversion.
   */
  protected JumpStatement(JumpStatement jumpStatement, LocalVariableConversion conversion) {
    super(jumpStatement);
    this.labelName = jumpStatement.labelName;
    this.conversion = conversion;
  }

  @Override
  public boolean hasGoto() {
    return true;
  }

  /**
   * Get the label name for this break node
   * @return label name, or null if none
   */
  public String getLabelName() {
    return labelName;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append(getStatementName());
    if (labelName != null) {
      sb.append(' ').append(labelName);
    }
  }

  abstract String getStatementName();

  /**
   * Finds the target for this jump statement in a lexical context.
   * @param lc the lexical context
   * @return the target, or null if not found
   */
  public abstract BreakableNode getTarget(LexicalContext lc);

  /**
   * Returns the label corresponding to this kind of jump statement (either a break or continue label) in the target.
   * @param target the target.
   *    Note that it need not be the target of this jump statement, as the method can retrieve a label on any passed target as long as the target has a label of the requisite kind.
   *    Of course, it is advisable to invoke the method on a jump statement that targets the breakable.
   * @return the label of the target corresponding to the kind of jump statement.
   * @throws ClassCastException if invoked on the kind of breakable node that this jump statement is not prepared to handle.
   */
  abstract Label getTargetLabel(BreakableNode target);

  /**
   * Returns the label this jump statement targets.
   * @param lc the lexical context
   * @return the label this jump statement targets.
   */
  public Label getTargetLabel(LexicalContext lc) {
    return getTargetLabel(getTarget(lc));
  }

  /**
   * Returns the limit node for popping scopes when this jump statement is effected.
   * @param lc the current lexical context
   * @return the limit node for popping scopes when this jump statement is effected.
   */
  public LexicalContextNode getPopScopeLimit(LexicalContext lc) {
    // In most cases (break and continue) this is equal to the target.
    return getTarget(lc);
  }

  @Override
  public JumpStatement setLocalVariableConversion(LexicalContext lc, LocalVariableConversion conversion) {
    return (this.conversion == conversion) ? this : createNewJumpStatement(conversion);
  }

  abstract JumpStatement createNewJumpStatement(LocalVariableConversion newConversion);

  @Override
  public LocalVariableConversion getLocalVariableConversion() {
    return conversion;
  }

  private static final long serialVersionUID = 1;
}
