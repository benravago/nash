package es.ir;

import java.util.Collections;
import java.util.List;
import es.codegen.types.Type;
import es.ir.visitor.NodeVisitor;

/**
 * Represents ES6 template string expression.
 *
 * Note that this Node class is used only in "parse only" mode.
 * In evaluation mode, Parser directly folds template literal as string concatenation.
 * Parser API uses this node to represent ES6 template literals "as is" rather than as a String concatenation.
 */
public final class TemplateLiteral extends Expression {

  private final List<Expression> exprs;

  public TemplateLiteral(List<Expression> exprs) {
    super(exprs.get(0).getToken(), exprs.get(exprs.size() - 1).finish);
    this.exprs = exprs;
  }

  @Override
  public Type getType() {
    return Type.STRING;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterTemplateLiteral(this)) ? visitor.leaveTemplateLiteral(this) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    for (var expr : exprs) {
      sb.append(expr);
    }
  }

  /**
   * The list of expressions that are part of this template literal.
   * @return the list of expressions that are part of this template literal.
   */
  public List<Expression> getExpressions() {
    return Collections.unmodifiableList(exprs);
  }

}
