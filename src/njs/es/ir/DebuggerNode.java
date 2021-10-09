package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for a debugger statement.
 */
@Immutable
public final class DebuggerNode extends Statement {

  private static final long serialVersionUID = 1L;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   */
  public DebuggerNode(final int lineNumber, final long token, final int finish) {
    super(lineNumber, token, finish);
  }

  @Override
  public Node accept(final NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterDebuggerNode(this)) {
      return visitor.leaveDebuggerNode(this);
    }

    return this;
  }

  @Override
  public void toString(final StringBuilder sb, final boolean printType) {
    sb.append("debugger");
  }
}
