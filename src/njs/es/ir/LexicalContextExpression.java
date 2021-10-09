package es.ir;

import es.ir.visitor.NodeVisitor;

abstract class LexicalContextExpression extends Expression implements LexicalContextNode {

  private static final long serialVersionUID = 1L;

  LexicalContextExpression(final LexicalContextExpression expr) {
    super(expr);
  }

  LexicalContextExpression(final long token, final int start, final int finish) {
    super(token, start, finish);
  }

  LexicalContextExpression(final long token, final int finish) {
    super(token, finish);
  }

  @Override
  public Node accept(final NodeVisitor<? extends LexicalContext> visitor) {
    return Acceptor.accept(this, visitor);
  }
}
