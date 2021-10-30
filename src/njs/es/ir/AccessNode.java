package es.ir;

import es.codegen.types.Type;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation of a property access (period operator.)
 */
@Immutable
public final class AccessNode extends BaseNode {

  // Property name.
  private final String property;

  /**
   * Constructor
   *
   * @param token     token
   * @param finish    finish
   * @param base      base node
   * @param property  property
   */
  public AccessNode(long token, int finish, Expression base, String property) {
    super(token, finish, base, false, false);
    this.property = property;
  }

  AccessNode(AccessNode accessNode, Expression base, String property, boolean isFunction, Type type, int id, boolean isSuper) {
    super(accessNode, base, isFunction, type, id, isSuper);
    this.property = property;
  }

  /**
   * Assist in IR navigation.
   * @param visitor IR navigating visitor.
   */
  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterAccessNode(this))
      ? visitor.leaveAccessNode(setBase((Expression) base.accept(visitor)))
      : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    var needsParen = tokenType().needsParens(getBase().tokenType(), true);
    if (printType) {
      optimisticTypeToString(sb);
    }
    if (needsParen) {
      sb.append('(');
    }
    base.toString(sb, printType);
    if (needsParen) {
      sb.append(')');
    }
    sb.append('.');
    sb.append(property);
  }

  /**
   * Get the property name
   * @return the property name
   */
  public String getProperty() {
    return property;
  }

  AccessNode setBase(Expression base) {
    return (this.base == base) ? this : new AccessNode(this, base, property, isFunction(), type, programPoint, isSuper());
  }

  @Override
  public AccessNode setType(Type type) {
    return (this.type == type) ? this : new AccessNode(this, base, property, isFunction(), type, programPoint, isSuper());
  }

  @Override
  public AccessNode setProgramPoint(int programPoint) {
    return (this.programPoint == programPoint) ? this : new AccessNode(this, base, property, isFunction(), type, programPoint, isSuper());
  }

  @Override
  public AccessNode setIsFunction() {
    return isFunction() ? this : new AccessNode(this, base, property, true, type, programPoint, isSuper());
  }

  @Override
  public AccessNode setIsSuper() {
    return isSuper() ? this : new AccessNode(this, base, property, isFunction(), type, programPoint, true);
  }

  private static final long serialVersionUID = 1;
}
