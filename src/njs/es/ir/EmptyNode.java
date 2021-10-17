package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for an empty statement.
 */
@Immutable
public final class EmptyNode extends Statement {

  /**
   * Constructor
   *
   * @param node node to wrap
   */
  public EmptyNode(Statement node) {
    super(node);
  }

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   */
  public EmptyNode(int lineNumber, long token, int finish) {
    super(lineNumber, token, finish);
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterEmptyNode(this)) ? visitor.leaveEmptyNode(this) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printTypes) {
    sb.append(';');
  }

}
