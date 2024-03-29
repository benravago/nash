package es.ir;

import es.ir.annotations.Ignore;
import es.ir.visitor.NodeVisitor;

/**
 * Synthetic AST node that represents return from a split fragment of a split function for control flow reasons (break or continue into a target outside the current fragment).
 *
 * It has no JavaScript source representation and only occurs in synthetic functions created by the split-into-functions transformation.
 * It is different from a return node in that the return value is irrelevant, and doesn't affect the function's return type calculation.
 */
public final class SplitReturn extends Statement {

  /** The sole instance of this AST node. */
  @Ignore
  public static final SplitReturn INSTANCE = new SplitReturn();

  SplitReturn() {
    super(NO_LINE_NUMBER, NO_TOKEN, NO_FINISH);
  }

  @Override
  public boolean isTerminal() {
    return true;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return visitor.enterSplitReturn(this) ? visitor.leaveSplitReturn(this) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append(":splitreturn;");
  }

  Object readResolve() {
    return INSTANCE;
  }

  private static final long serialVersionUID = 1;
}
