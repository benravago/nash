package es.ir;

import es.codegen.types.Type;
import es.ir.annotations.Immutable;
import es.parser.TokenType;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;

/**
 * IR base for accessing/indexing nodes.
 *
 * @see AccessNode
 * @see IndexNode
 */
@Immutable
public abstract class BaseNode extends Expression implements FunctionCall, Optimistic {

  // Base Node.
  protected final Expression base;

  private final boolean isFunction;

  // Callsite type for this node, if overridden optimistically or conservatively depending on coercion
  protected final Type type;

  // Program point id
  protected final int programPoint;

  // Super property access.
  private final boolean isSuper;

  /**
   * Constructor
   *
   * @param token  token
   * @param finish finish
   * @param base   base node
   * @param isFunction is this a function
   * @param isSuper is this a super property access
   */
  public BaseNode(long token, int finish, Expression base, boolean isFunction, boolean isSuper) {
    super(token, base.getStart(), finish);
    this.base = base;
    this.isFunction = isFunction;
    this.type = null;
    this.programPoint = INVALID_PROGRAM_POINT;
    this.isSuper = isSuper;
  }

  /**
   * Copy constructor for immutable nodes
   * @param baseNode node to inherit from
   * @param base base
   * @param isFunction is this a function
   * @param callSiteType  the callsite type for this base node, either optimistic or conservative
   * @param programPoint  program point id
   * @param isSuper is this a super property access
   */
  BaseNode(BaseNode baseNode, Expression base, boolean isFunction, Type callSiteType, int programPoint, boolean isSuper) {
    super(baseNode);
    this.base = base;
    this.isFunction = isFunction;
    this.type = callSiteType;
    this.programPoint = programPoint;
    this.isSuper = isSuper;
  }

  /**
   * Get the base node for this access
   * @return the base node
   */
  public Expression getBase() {
    return base;
  }

  @Override
  public boolean isFunction() {
    return isFunction;
  }

  @Override
  public Type getType() {
    return type == null ? getMostPessimisticType() : type;
  }

  @Override
  public int getProgramPoint() {
    return programPoint;
  }

  @Override
  public Type getMostOptimisticType() {
    return Type.INT;
  }

  @Override
  public Type getMostPessimisticType() {
    return Type.OBJECT;
  }

  @Override
  public boolean canBeOptimistic() {
    return true;
  }

  /**
   * Return true if this node represents an index operation normally represented as {@link IndexNode}.
   * @return true if an index access.
   */
  public boolean isIndex() {
    return isTokenType(TokenType.LBRACKET);
  }

  /**
   * Mark this node as being the callee operand of a {@link CallNode}.
   * @return a base node identical to this one in all aspects except with its function flag set.
   */
  public abstract BaseNode setIsFunction();

  /**
   * @return {@code true} if a SuperProperty access.
   */
  public boolean isSuper() {
    return isSuper;
  }

  /**
   * Mark this node as being a SuperProperty access.
   * @return  a base node identical to this one in all aspects except with its super flag set.
   */
  public abstract BaseNode setIsSuper();

  private static final long serialVersionUID = 1;
}
