package es.ir;

import es.ir.visitor.NodeVisitor;

abstract class LexicalContextStatement extends Statement implements LexicalContextNode {

  private static final long serialVersionUID = 1L;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   */
  protected LexicalContextStatement(final int lineNumber, final long token, final int finish) {
    super(lineNumber, token, finish);
  }

  /**
   * Copy constructor
   *
   * @param node source node
   */
  protected LexicalContextStatement(final LexicalContextStatement node) {
    super(node);
  }

  @Override
  public Node accept(final NodeVisitor<? extends LexicalContext> visitor) {
    return Acceptor.accept(this, visitor);
  }
}
