package es.ir;

import es.codegen.types.Type;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for an error expression.
 */
@Immutable
public final class ErrorNode extends Expression {

  /**
   * Constructor
   *
   * @param token      token
   * @param finish     finish
   */
  public ErrorNode(long token, int finish) {
    super(token, finish);
  }

  @Override
  public Type getType() {
    return Type.OBJECT;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterErrorNode(this)) ? visitor.leaveErrorNode(this) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append("<error>");
  }

  private static final long serialVersionUID = 1;
}
