package es.ir;

import es.codegen.types.Type;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation of an indexed access (brackets operator.)
 */
@Immutable
public final class IndexNode extends BaseNode {

  // Property index.
  private final Expression index;

  /**
   * Constructors
   *
   * @param token   token
   * @param finish  finish
   * @param base    base node for access
   * @param index   index for access
   */
  public IndexNode(long token, int finish, Expression base, Expression index) {
    super(token, finish, base, false, false);
    this.index = index;
  }

  IndexNode(IndexNode indexNode, Expression base, Expression index, boolean isFunction, Type type, int programPoint, boolean isSuper) {
    super(indexNode, base, isFunction, type, programPoint, isSuper);
    this.index = index;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterIndexNode(this)) ?
      visitor.leaveIndexNode(
        setBase((Expression) base.accept(visitor))
        .setIndex((Expression) index.accept(visitor))) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    var needsParen = tokenType().needsParens(base.tokenType(), true);
    if (needsParen) {
      sb.append('(');
    }
    if (printType) {
      optimisticTypeToString(sb);
    }
    base.toString(sb, printType);
    if (needsParen) {
      sb.append(')');
    }
    sb.append('[');
    index.toString(sb, printType);
    sb.append(']');
  }

  /**
   * Get the index expression for this IndexNode
   * @return the index
   */
  public Expression getIndex() {
    return index;
  }

  IndexNode setBase(Expression base) {
    return (this.base == base) ? this : new IndexNode(this, base, index, isFunction(), type, programPoint, isSuper());
  }

  /**
   * Set the index expression for this node
   * @param index new index expression
   * @return a node equivalent to this one except for the requested change.
   */
  public IndexNode setIndex(Expression index) {
    return (this.index == index) ? this : new IndexNode(this, base, index, isFunction(), type, programPoint, isSuper());
  }

  @Override
  public IndexNode setType(Type type) {
    return (this.type == type) ? this : new IndexNode(this, base, index, isFunction(), type, programPoint, isSuper());
  }

  @Override
  public IndexNode setIsFunction() {
    return isFunction() ? this : new IndexNode(this, base, index, true, type, programPoint, isSuper());
  }

  @Override
  public IndexNode setProgramPoint(int programPoint) {
    return (this.programPoint == programPoint) ? this : new IndexNode(this, base, index, isFunction(), type, programPoint, isSuper());
  }

  @Override
  public IndexNode setIsSuper() {
    return isSuper() ? this : new IndexNode(this, base, index, isFunction(), type, programPoint, true);
  }

  private static final long serialVersionUID = 1;
}
