package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation of a catch clause.
 */
@Immutable
public final class CatchNode extends Statement {

  // Exception binding identifier or binding pattern.
  private final Expression exception;

  // Exception condition.
  private final Expression exceptionCondition;

  // Catch body.
  private final Block body;

  private final boolean isSyntheticRethrow;

  /**
   * Constructors
   *
   * @param lineNumber         lineNumber
   * @param token              token
   * @param finish             finish
   * @param exception          variable name or pattern of exception
   * @param exceptionCondition exception condition
   * @param body               catch body
   * @param isSyntheticRethrow true if this node is a synthetically generated rethrow node.
   */
  public CatchNode(int lineNumber, long token, int finish, Expression exception, Expression exceptionCondition, Block body, boolean isSyntheticRethrow) {
    super(lineNumber, token, finish);
    if (exception instanceof IdentNode ident) {
      this.exception = ident.setIsInitializedHere();
    } else if ((exception instanceof LiteralNode.ArrayLiteralNode) || (exception instanceof ObjectNode)) {
      this.exception = exception;
    } else {
      throw new IllegalArgumentException("invalid catch parameter");
    }
    this.exceptionCondition = exceptionCondition;
    this.body = body;
    this.isSyntheticRethrow = isSyntheticRethrow;
  }

  CatchNode(CatchNode catchNode, Expression exception, Expression exceptionCondition, Block body, boolean isSyntheticRethrow) {
    super(catchNode);
    this.exception = exception;
    this.exceptionCondition = exceptionCondition;
    this.body = body;
    this.isSyntheticRethrow = isSyntheticRethrow;
  }

  /**
   * Assist in IR navigation.
   * @param visitor IR navigating visitor.
   */
  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterCatchNode(this)) {
      return visitor.leaveCatchNode(
        setException((Expression) exception.accept(visitor))
        .setExceptionCondition(exceptionCondition == null ? null : (Expression) exceptionCondition.accept(visitor))
        .setBody((Block) body.accept(visitor)));
    }
    return this;
  }

  @Override
  public boolean isTerminal() {
    return body.isTerminal();
  }

  @Override
  public void toString(StringBuilder sb, boolean printTypes) {
    sb.append(" catch (");
    exception.toString(sb, printTypes);
    if (exceptionCondition != null) {
      sb.append(" if ");
      exceptionCondition.toString(sb, printTypes);
    }
    sb.append(')');
  }

  /**
   * Get the binding pattern representing the exception thrown
   * @return the exception binding pattern
   */
  public Expression getException() {
    return exception;
  }

  /**
   * Get the identifier representing the exception thrown
   *
   * @return the exception identifier
   * @throws ClassCastException if exception set is not binding identifier
   */
  public IdentNode getExceptionIdentifier() {
    return (IdentNode) exception;
  }

  /**
   * Get the exception condition for this catch block
   * @return the exception condition
   */
  public Expression getExceptionCondition() {
    return exceptionCondition;
  }

  /**
   * Reset the exception condition for this catch block
   * @param exceptionCondition the new exception condition
   * @return new or same CatchNode
   */
  public CatchNode setExceptionCondition(Expression exceptionCondition) {
    return (this.exceptionCondition == exceptionCondition) ? this : new CatchNode(this, exception, exceptionCondition, body, isSyntheticRethrow);
  }

  /**
   * Get the body for this catch block
   * @return the catch block body
   */
  public Block getBody() {
    return body;
  }

  /**
   * Resets the exception of a catch block
   * @param exception new exception which can be binding identifier or binding pattern
   * @return new catch node if changed, same otherwise
   */
  public CatchNode setException(Expression exception) {
    if (this.exception == exception) {
      return this;
    }
    // check if exception is legitimate
    if (!((exception instanceof IdentNode) || (exception instanceof LiteralNode.ArrayLiteralNode) || (exception instanceof ObjectNode))) {
      throw new IllegalArgumentException("invalid catch parameter");
    }
    return new CatchNode(this, exception, exceptionCondition, body, isSyntheticRethrow);
  }

  CatchNode setBody(Block body) {
    return (this.body == body) ? this : new CatchNode(this, exception, exceptionCondition, body, isSyntheticRethrow);
  }

  /**
   * Is this catch block a non-JavaScript constructor, for example created as part of the rethrow mechanism of a finally block in Lower?
   * Then we just pass the exception on and need not unwrap whatever is in the ECMAException
   * object catch symbol
   * @return true if a finally synthetic rethrow
   */
  public boolean isSyntheticRethrow() {
    return isSyntheticRethrow;
  }

}
