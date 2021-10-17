package es.ir;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import es.codegen.types.Type;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;
import es.parser.TokenType;

/**
 * IR representation for a runtime call.
 */
@Immutable
public class RuntimeNode extends Expression {

  /**
   * Request enum used for meta-information about the runtime request
   */
  public enum Request {
    /** An addition with at least one object */
    ADD(TokenType.ADD, Type.OBJECT, 2, true),
    /** Request to enter debugger */
    DEBUGGER,
    /** New operator */
    NEW,
    /** Typeof operator */
    TYPEOF,
    /** Reference error type */
    REFERENCE_ERROR,
    /** === operator with at least one object */
    EQUIV(TokenType.EQU, Type.BOOLEAN, 2, true),
    /** == operator with at least one object */
    EQ(TokenType.EQ, Type.BOOLEAN, 2, true),
    /** {@literal >=} operator with at least one object */
    GE(TokenType.GE, Type.BOOLEAN, 2, true),
    /** {@literal >} operator with at least one object */
    GT(TokenType.GT, Type.BOOLEAN, 2, true),
    /** in operator */
    IN(TokenType.IN, Type.BOOLEAN, 2),
    /** instanceof operator */
    INSTANCEOF(TokenType.INSTANCEOF, Type.BOOLEAN, 2),
    /** {@literal <=} operator with at least one object */
    LE(TokenType.LE, Type.BOOLEAN, 2, true),
    /** {@literal <} operator with at least one object */
    LT(TokenType.LT, Type.BOOLEAN, 2, true),
    /** !== operator with at least one object */
    NOT_EQUIV(TokenType.NEQU, Type.BOOLEAN, 2, true),
    /** != operator with at least one object */
    NE(TokenType.NE, Type.BOOLEAN, 2, true),
    /** is undefined */
    IS_UNDEFINED(TokenType.EQU, Type.BOOLEAN, 2),
    /** is not undefined */
    IS_NOT_UNDEFINED(TokenType.NEQU, Type.BOOLEAN, 2),
    /** Get template object from raw and cooked string arrays. */
    GET_TEMPLATE_OBJECT(TokenType.TEMPLATE, Type.SCRIPT_OBJECT, 2);

    // token type
    private final TokenType tokenType;

    // return type for request
    private final Type returnType;

    // arity of request
    private final int arity;

    // Can the specializer turn this into something that works with 1 or more primitives?
    private final boolean canSpecialize;

    Request() {
      this(TokenType.VOID, Type.OBJECT, 0);
    }

    Request(TokenType tokenType, Type returnType, int arity) {
      this(tokenType, returnType, arity, false);
    }

    Request(TokenType tokenType, Type returnType, int arity, boolean canSpecialize) {
      this.tokenType = tokenType;
      this.returnType = returnType;
      this.arity = arity;
      this.canSpecialize = canSpecialize;
    }

    /**
     * Can this request type be specialized?
     * @return true if request can be specialized
     */
    public boolean canSpecialize() {
      return canSpecialize;
    }

    /**
     * Get arity
     * @return the arity of the request
     */
    public int getArity() {
      return arity;
    }

    /**
     * Get the return type
     * @return return type for request
     */
    public Type getReturnType() {
      return returnType;
    }

    /**
     * Get token type
     * @return token type for request
     */
    public TokenType getTokenType() {
      return tokenType;
    }

    /**
     * Derive a runtime node request type for a node
     * @param node the node
     * @return request type
     */
    public static Request requestFor(Expression node) {
      return switch (node.tokenType()) {
        case TYPEOF -> Request.TYPEOF;
        case IN -> Request.IN;
        case INSTANCEOF -> Request.INSTANCEOF;
        case EQU -> Request.EQUIV;
        case NEQU -> Request.NOT_EQUIV;
        case EQ -> Request.EQ;
        case NE -> Request.NE;
        case LT -> Request.LT;
        case LE -> Request.LE;
        case GT -> Request.GT;
        case GE -> Request.GE;
        default -> null; // assert false; should not occur
      };
    }

    /**
     * Is this an undefined check?
     * @param request request
     * @return true if undefined check
     */
    public static boolean isUndefinedCheck(Request request) {
      return request == IS_UNDEFINED || request == IS_NOT_UNDEFINED;
    }

    /**
     * Is this an EQ
     * @param request a request
     * @return true if '==' or '==='?
     */
    public static boolean isEQ(Request request) {
      return request == EQ || request == EQUIV;
    }

    /**
     * Is this an NE ?
     * @param request a request
     * @return true if '!=' or '!=='
     */
    public static boolean isNE(Request request) {
      return request == NE || request == NOT_EQUIV;
    }

    /**
     * Is this equivalence? '===' or '!==='
     * @param request a request
     * @return true if script
     */
    public static boolean isEquiv(Request request) {
      return request == EQUIV || request == NOT_EQUIV;
    }

    /**
     * If this request can be reversed, return the reverse request; eg. EQ {@literal ->} NE.
     * @param request request to reverse
     * @return reversed request or null if not applicable
     */
    public static Request reverse(Request request) {
      return switch (request) {
        case EQ, EQUIV, NE, NOT_EQUIV -> request;
        case LE -> GE;
        case LT -> GT;
        case GE -> LE;
        case GT -> LT;
        default -> null;
      };
    }

    /**
     * Invert the request, only for non equals comparisons.
     * @param request a request
     * @return the inverted request, or null if not applicable
     */
    public static Request invert(Request request) {
      return switch (request) {
        case EQ -> NE;
        case EQUIV -> NOT_EQUIV;
        case NE -> EQ;
        case NOT_EQUIV -> EQUIV;
        case LE -> GT;
        case LT -> GE;
        case GE -> LT;
        case GT -> LE;
        default -> null;
      };
    }

    /**
     * Check if this is a comparison
     * @param request a request
     * @return true if this is a comparison, null otherwise
     */
    public static boolean isComparison(Request request) {
      return switch (request) {
        case EQ, EQUIV, NE, NOT_EQUIV, LE, LT, GE, GT, IS_UNDEFINED, IS_NOT_UNDEFINED -> true;
        default -> false;
      };
    }
  }

  // Runtime request.
  private final Request request;

  // Call arguments.
  private final List<Expression> args;

  /**
   * Constructor
   *
   * @param token   token
   * @param finish  finish
   * @param request the request
   * @param args    arguments to request
   */
  public RuntimeNode(long token, int finish, Request request, List<Expression> args) {
    super(token, finish);
    this.request = request;
    this.args = args;
  }

  RuntimeNode(RuntimeNode runtimeNode, Request request, List<Expression> args) {
    super(runtimeNode);
    this.request = request;
    this.args = args;
  }

  /**
   * Constructor
   *
   * @param token   token
   * @param finish  finish
   * @param request the request
   * @param args    arguments to request
   */
  public RuntimeNode(long token, int finish, Request request, Expression... args) {
    this(token, finish, request, Arrays.asList(args));
  }

  /**
   * Constructor
   *
   * @param parent  parent node from which to inherit source, token, finish
   * @param request the request
   * @param args    arguments to request
   */
  public RuntimeNode(Expression parent, Request request, Expression... args) {
    this(parent, request, Arrays.asList(args));
  }

  /**
   * Constructor
   *
   * @param parent  parent node from which to inherit source, token, finish
   * @param request the request
   * @param args    arguments to request
   */
  public RuntimeNode(Expression parent, Request request, List<Expression> args) {
    super(parent);
    this.request = request;
    this.args = args;
  }

  /**
   * Constructor
   *
   * @param parent  parent node from which to inherit source, token, finish and arguments
   * @param request the request
   */
  public RuntimeNode(UnaryNode parent, Request request) {
    this(parent, request, parent.getExpression());
  }

  /**
   * Constructor used to replace a binary node with a runtime request.
   *
   * @param parent  parent node from which to inherit source, token, finish and arguments
   */
  public RuntimeNode(BinaryNode parent) {
    this(parent, Request.requestFor(parent), parent.lhs(), parent.rhs());
  }

  /**
   * Reset the request for this runtime node
   * @param request request
   * @return new runtime node or same if same request
   */
  public RuntimeNode setRequest(Request request) {
    return (this.request == request) ? this : new RuntimeNode(this, request, args);
  }

  /**
   * Return type for the ReferenceNode
   */
  @Override
  public Type getType() {
    return request.getReturnType();
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterRuntimeNode(this)) ? visitor.leaveRuntimeNode(setArgs(Node.accept(visitor, args))) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append("ScriptRuntime.");
    sb.append(request);
    sb.append('(');
    var first = true;
    for (var arg : args) {
      if (!first) {
        sb.append(", ");
      } else {
        first = false;
      }
      arg.toString(sb, printType);
    }
    sb.append(')');
  }

  /**
   * Get the arguments for this runtime node
   * @return argument list
   */
  public List<Expression> getArgs() {
    return Collections.unmodifiableList(args);
  }

  /**
   * Set the arguments of this runtime node
   * @param args new arguments
   * @return new runtime node, or identical if no change
   */
  public RuntimeNode setArgs(List<Expression> args) {
    return (this.args == args) ? this : new RuntimeNode(this, request, args);
  }

  /**
   * Get the request that this runtime node implements
   * @return the request
   */
  public Request getRequest() {
    return request;
  }

  /**
   * Is this runtime node, engineered to handle the "at least one object" case of the defined requests and specialize on demand, really primitive.
   * This can happen e.g. after AccessSpecializer
   * In that case it can be turned into a simpler primitive form in CodeGenerator
   * @return true if all arguments now are primitive
   */
  public boolean isPrimitive() {
    for (var arg : args) {
      if (arg.getType().isObject()) {
        return false;
      }
    }
    return true;
  }

}
