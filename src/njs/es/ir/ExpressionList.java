package es.ir;

import java.util.Collections;
import java.util.List;

import es.codegen.types.Type;
import es.ir.visitor.NodeVisitor;

/**
 * IR for CoverParenthesizedExpressionAndArrowParameterList, used only during parsing.
 */
public final class ExpressionList extends Expression {

  private final List<Expression> expressions;

  /**
   * Constructor.
   *
   * @param token token
   * @param finish finish
   * @param expressions expression
   */
  public ExpressionList(long token, int finish, List<Expression> expressions) {
    super(token, finish);
    this.expressions = expressions;
  }

  /**
   * Get the list of expressions.
   * @return the list of expressions
   */
  public List<Expression> getExpressions() {
    return Collections.unmodifiableList(expressions);
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    throw new UnsupportedOperationException();
  }

  @Override
  public Type getType() {
    return null;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append("(");
    var first = true;
    for (var expression : expressions) {
      if (first) {
        first = false;
      } else {
        sb.append(", ");
      }
      expression.toString(sb, printType);
    }
    sb.append(")");
  }

  private static final long serialVersionUID = 1;
}
