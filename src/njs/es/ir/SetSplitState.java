package es.ir;

import es.codegen.CompilerConstants;
import es.ir.visitor.NodeVisitor;
import es.runtime.Scope;

/**
 * Synthetic AST node that represents loading of the scope object and invocation of the {@link Scope#setSplitState(int)} method on it.
 *
 * It has no JavaScript source representation and only occurs in synthetic functions created by the split-into-functions transformation.
 */
public final class SetSplitState extends Statement {

  private final int state;

  /**
   * Creates a new split state setter
   * @param state the state to set
   * @param lineNumber the line number where it is inserted
   */
  public SetSplitState(int state, int lineNumber) {
    super(lineNumber, NO_TOKEN, NO_FINISH);
    this.state = state;
  }

  /**
   * Returns the state this setter sets.
   * @return the state this setter sets.
   */
  public int getState() {
    return state;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return visitor.enterSetSplitState(this) ? visitor.leaveSetSplitState(this) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append(CompilerConstants.SCOPE.symbolName())
      .append('.').append(Scope.SET_SPLIT_STATE.name())
      .append('(').append(state).append(");");
  }

}
