package es.ir;

import static es.parser.TokenType.BIT_NOT;
import static es.parser.TokenType.DECPOSTFIX;
import static es.parser.TokenType.INCPOSTFIX;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import es.codegen.types.Type;
import es.ir.annotations.Ignore;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;
import es.parser.Token;
import es.parser.TokenType;

/**
 * UnaryNode nodes represent single operand operations.
 */
@Immutable
public final class UnaryNode extends Expression implements Assignment<Expression>, Optimistic {

  private static final long serialVersionUID = 1L;

  /** Right hand side argument. */
  private final Expression expression;

  private final int programPoint;

  private final Type type;

  @Ignore
  private static final List<TokenType> CAN_OVERFLOW
          = Collections.unmodifiableList(
                  Arrays.asList(new TokenType[]{
            TokenType.POS,
            TokenType.NEG, //negate
            TokenType.DECPREFIX,
            TokenType.DECPOSTFIX,
            TokenType.INCPREFIX,
            TokenType.INCPOSTFIX,}));

  /**
   * Constructor
   *
   * @param token  token
   * @param rhs    expression
   */
  public UnaryNode(final long token, final Expression rhs) {
    this(token, Math.min(rhs.getStart(), Token.descPosition(token)), Math.max(Token.descPosition(token) + Token.descLength(token), rhs.getFinish()), rhs);
  }

  /**
   * Constructor
   *
   * @param token      token
   * @param start      start
   * @param finish     finish
   * @param expression expression
   */
  public UnaryNode(final long token, final int start, final int finish, final Expression expression) {
    super(token, start, finish);
    this.expression = expression;
    this.programPoint = INVALID_PROGRAM_POINT;
    this.type = null;
  }

  private UnaryNode(final UnaryNode unaryNode, final Expression expression, final Type type, final int programPoint) {
    super(unaryNode);
    this.expression = expression;
    this.programPoint = programPoint;
    this.type = type;
  }

  /**
   * Is this an assignment - i.e. that mutates something such as a++
   *
   * @return true if assignment
   */
  @Override
  public boolean isAssignment() {
    switch (tokenType()) {
      case DECPOSTFIX:
      case DECPREFIX:
      case INCPOSTFIX:
      case INCPREFIX:
        return true;
      default:
        return false;
    }
  }

  @Override
  public boolean isSelfModifying() {
    return isAssignment();
  }

  @Override
  public Type getWidestOperationType() {
    switch (tokenType()) {
      case POS:
        final Type operandType = getExpression().getType();
        if (operandType == Type.BOOLEAN) {
          return Type.INT;
        } else if (operandType.isObject()) {
          return Type.NUMBER;
        }
        assert operandType.isNumeric();
        return operandType;
      case NEG:
        // This might seems overly conservative until you consider that -0 can only be represented as a double.
        return Type.NUMBER;
      case NOT:
      case DELETE:
        return Type.BOOLEAN;
      case BIT_NOT:
        return Type.INT;
      case VOID:
        return Type.UNDEFINED;
      default:
        return isAssignment() ? Type.NUMBER : Type.OBJECT;
    }
  }

  @Override
  public Expression getAssignmentDest() {
    return isAssignment() ? getExpression() : null;
  }

  @Override
  public UnaryNode setAssignmentDest(final Expression n) {
    return setExpression(n);
  }

  @Override
  public Expression getAssignmentSource() {
    return getAssignmentDest();
  }

  /**
   * Assist in IR navigation.
   * @param visitor IR navigating visitor.
   */
  @Override
  public Node accept(final NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterUnaryNode(this)) {
      return visitor.leaveUnaryNode(setExpression((Expression) expression.accept(visitor)));
    }

    return this;
  }

  @Override
  public boolean isLocal() {
    switch (tokenType()) {
      case NEW:
        return false;
      case POS:
      case NEG:
      case NOT:
      case BIT_NOT:
        return expression.isLocal() && expression.getType().isJSPrimitive();
      case DECPOSTFIX:
      case DECPREFIX:
      case INCPOSTFIX:
      case INCPREFIX:
        return expression instanceof IdentNode && expression.isLocal() && expression.getType().isJSPrimitive();
      default:
        return expression.isLocal();
    }
  }

  @Override
  public void toString(final StringBuilder sb, final boolean printType) {
    toString(sb,
            new Runnable() {
      @Override
      public void run() {
        getExpression().toString(sb, printType);
      }
    },
            printType);
  }

  /**
   * Creates the string representation of this unary node, delegating the creation of the string representation of its
   * operand to a specified runnable.
   * @param sb the string builder to use
   * @param rhsStringBuilder the runnable that appends the string representation of the operand to the string builder
   * @param printType should we print type
   * when invoked.
   */
  public void toString(final StringBuilder sb, final Runnable rhsStringBuilder, final boolean printType) {
    final TokenType tokenType = tokenType();
    final String name = tokenType.getName();
    final boolean isPostfix = tokenType == DECPOSTFIX || tokenType == INCPOSTFIX;

    if (isOptimistic()) {
      sb.append(Expression.OPT_IDENTIFIER);
    }
    boolean rhsParen = tokenType.needsParens(getExpression().tokenType(), false);

    if (!isPostfix) {
      if (name == null) {
        sb.append(tokenType.name());
        rhsParen = true;
      } else {
        sb.append(name);

        if (tokenType.ordinal() > BIT_NOT.ordinal()) {
          sb.append(' ');
        }
      }
    }

    if (rhsParen) {
      sb.append('(');
    }
    rhsStringBuilder.run();
    if (rhsParen) {
      sb.append(')');
    }

    if (isPostfix) {
      sb.append(tokenType == DECPOSTFIX ? "--" : "++");
    }
  }

  /**
   * Get the right hand side of this if it is inherited by a binary expression,
   * or just the expression itself if still Unary
   *
   * @see BinaryNode
   *
   * @return right hand side or expression node
   */
  public Expression getExpression() {
    return expression;
  }

  /**
   * Reset the right hand side of this if it is inherited by a binary expression,
   * or just the expression itself if still Unary
   *
   * @see BinaryNode
   *
   * @param expression right hand side or expression node
   * @return a node equivalent to this one except for the requested change.
   */
  public UnaryNode setExpression(final Expression expression) {
    if (this.expression == expression) {
      return this;
    }
    return new UnaryNode(this, expression, type, programPoint);
  }

  @Override
  public int getProgramPoint() {
    return programPoint;
  }

  @Override
  public UnaryNode setProgramPoint(final int programPoint) {
    if (this.programPoint == programPoint) {
      return this;
    }
    return new UnaryNode(this, expression, type, programPoint);
  }

  @Override
  public boolean canBeOptimistic() {
    return getMostOptimisticType() != getMostPessimisticType();
  }

  @Override
  public Type getMostOptimisticType() {
    if (CAN_OVERFLOW.contains(tokenType())) {
      return Type.INT;
    }
    return getMostPessimisticType();
  }

  @Override
  public Type getMostPessimisticType() {
    return getWidestOperationType();
  }

  @Override
  public Type getType() {
    final Type widest = getWidestOperationType();
    if (type == null) {
      return widest;
    }
    return Type.narrowest(widest, Type.widest(type, expression.getType()));
  }

  @Override
  public UnaryNode setType(final Type type) {
    if (this.type == type) {
      return this;
    }
    return new UnaryNode(this, expression, type, programPoint);
  }

}
