package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for an empty statement.
 */
@Immutable
public final class EmptyNode extends Statement {

  private static final long serialVersionUID = 1L;

  /**
   * Constructor
   *
   * @param node node to wrap
   */
  public EmptyNode(final Statement node) {
    super(node);
  }

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   */
  public EmptyNode(final int lineNumber, final long token, final int finish) {
    super(lineNumber, token, finish);
  }

  @Override
  public Node accept(final NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterEmptyNode(this)) {
      return visitor.leaveEmptyNode(this);
    }
    return this;
  }

  @Override
  public void toString(final StringBuilder sb, final boolean printTypes) {
    sb.append(';');
  }

}
