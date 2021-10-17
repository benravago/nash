package es.ir;

import es.ir.visitor.NodeVisitor;

abstract class LexicalContextStatement extends Statement implements LexicalContextNode {

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   */
  protected LexicalContextStatement(int lineNumber, long token, int finish) {
    super(lineNumber, token, finish);
  }

  /**
   * Copy constructor
   *
   * @param node source node
   */
  protected LexicalContextStatement(LexicalContextStatement node) {
    super(node);
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return Acceptor.accept(this, visitor);
  }

}
