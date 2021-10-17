package es.ir;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import es.codegen.types.Type;
import es.ir.annotations.Ignore;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;
import es.parser.Token;
import es.parser.TokenType;
import static es.parser.TokenType.*;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;

/**
 * UnaryNode nodes represent single operand operations.
 */
@Immutable
public final class UnaryNode extends Expression implements Assignment<Expression>, Optimistic {

  // Right hand side argument.
  private final Expression expression;

  private final int programPoint;

  private final Type type;

  @Ignore
  private static final List<TokenType> CAN_OVERFLOW = List.of(
    TokenType.POS,
    TokenType.NEG, //negate
    TokenType.DECPREFIX,
    TokenType.DECPOSTFIX,
    TokenType.INCPREFIX,
    TokenType.INCPOSTFIX
  );

  /**
   * Constructor
   *
   * @param token  token
   * @param rhs    expression
   */
  public UnaryNode(long token, Expression rhs) {
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
  public UnaryNode(long token, int start, int finish, Expression expression) {
    super(token, start, finish);
    this.expression = expression;
    this.programPoint = INVALID_PROGRAM_POINT;
    this.type = null;
  }

  UnaryNode(UnaryNode unaryNode, Expression expression, Type type, int programPoint) {
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
    return switch (tokenType()) {
      case DECPOSTFIX, DECPREFIX, INCPOSTFIX, INCPREFIX -> true;
      default -> false;
    };
  }

  @Override
  public boolean isSelfModifying() {
    return isAssignment();
  }

  @Override
  public Type getWidestOperationType() {
    return switch (tokenType()) {
      case POS -> {
        var operandType = getExpression().getType();
        if (operandType == Type.BOOLEAN) {
          yield Type.INT;
        } else if (operandType.isObject()) {
          yield Type.NUMBER;
        }
        assert operandType.isNumeric();
        yield operandType;
      }

      // This might seems overly conservative until you consider that -0 can only be represented as a double.
      case NEG -> Type.NUMBER;

      case NOT, DELETE -> Type.BOOLEAN;
      case BIT_NOT -> Type.INT;
      case VOID -> Type.UNDEFINED;

      default -> {
        yield isAssignment() ? Type.NUMBER : Type.OBJECT;
      }
    };
  }

  @Override
  public Expression getAssignmentDest() {
    return isAssignment() ? getExpression() : null;
  }

  @Override
  public UnaryNode setAssignmentDest(Expression n) {
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
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterUnaryNode(this)) ? visitor.leaveUnaryNode(setExpression((Expression) expression.accept(visitor))) : this;
  }

  @Override
  public boolean isLocal() {
    return switch (tokenType()) {
      case NEW -> false;
      case POS, NEG, NOT, BIT_NOT -> expression.isLocal() && expression.getType().isJSPrimitive();
      case DECPOSTFIX, DECPREFIX, INCPOSTFIX, INCPREFIX -> expression instanceof IdentNode && expression.isLocal() && expression.getType().isJSPrimitive();
      default -> expression.isLocal();
    };
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    toString(sb, () -> getExpression().toString(sb, printType), printType);
  }

  /**
   * Creates the string representation of this unary node, delegating the creation of the string representation of its operand to a specified runnable.
   * @param sb the string builder to use
   * @param rhsStringBuilder the runnable that appends the string representation of the operand to the string builder
   * @param printType should we print type when invoked.
   */
  public void toString(StringBuilder sb, Runnable rhsStringBuilder, boolean printType) {
    var tokenType = tokenType();
    var name = tokenType.getName();
    var isPostfix = tokenType == DECPOSTFIX || tokenType == INCPOSTFIX;
    if (isOptimistic()) {
      sb.append(Expression.OPT_IDENTIFIER);
    }
    var rhsParen = tokenType.needsParens(getExpression().tokenType(), false);
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
   * Get the right hand side of this if it is inherited by a binary expression, or just the expression itself if still Unary
   * @see BinaryNode
   * @return right hand side or expression node
   */
  public Expression getExpression() {
    return expression;
  }

  /**
   * Reset the right hand side of this if it is inherited by a binary expression, or just the expression itself if still Unary
   * @see BinaryNode
   * @param expression right hand side or expression node
   * @return a node equivalent to this one except for the requested change.
   */
  public UnaryNode setExpression(Expression expression) {
    return (this.expression == expression) ? this : new UnaryNode(this, expression, type, programPoint);
  }

  @Override
  public int getProgramPoint() {
    return programPoint;
  }

  @Override
  public UnaryNode setProgramPoint(int programPoint) {
    return (this.programPoint == programPoint) ? this : new UnaryNode(this, expression, type, programPoint);
  }

  @Override
  public boolean canBeOptimistic() {
    return getMostOptimisticType() != getMostPessimisticType();
  }

  @Override
  public Type getMostOptimisticType() {
    return (CAN_OVERFLOW.contains(tokenType())) ? Type.INT : getMostPessimisticType();
  }

  @Override
  public Type getMostPessimisticType() {
    return getWidestOperationType();
  }

  @Override
  public Type getType() {
    var widest = getWidestOperationType();
    return (type == null) ? widest : Type.narrowest(widest, Type.widest(type, expression.getType()));
  }

  @Override
  public UnaryNode setType(Type type) {
    return (this.type == type) ? this : new UnaryNode(this, expression, type, programPoint);
  }

}
