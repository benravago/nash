package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for a debugger statement.
 */
@Immutable
public final class DebuggerNode extends Statement {

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   */
  public DebuggerNode(int lineNumber, long token, int finish) {
    super(lineNumber, token, finish);
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterDebuggerNode(this)) ? visitor.leaveDebuggerNode(this) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append("debugger");
  }

  private static final long serialVersionUID = 1;
}
