package es.ir;

import es.codegen.types.Type;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for an error expression.
 */
@Immutable
public final class ErrorNode extends Expression {

  private static final long serialVersionUID = 1L;

  /**
   * Constructor
   *
   * @param token      token
   * @param finish     finish
   */
  public ErrorNode(final long token, final int finish) {
    super(token, finish);
  }

  @Override
  public Type getType() {
    return Type.OBJECT;
  }

  @Override
  public Node accept(final NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterErrorNode(this)) {
      return visitor.leaveErrorNode(this);
    }

    return this;
  }

  @Override
  public void toString(final StringBuilder sb, final boolean printType) {
    sb.append("<error>");
  }
}
