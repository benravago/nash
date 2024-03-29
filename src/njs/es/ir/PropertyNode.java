package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation of an object literal property.
 */
@Immutable
public final class PropertyNode extends Node {

  // Property key.
  private final Expression key;

  // Property value.
  private final Expression value;

  // Property getter.
  private final FunctionNode getter;

  // Property getter.
  private final FunctionNode setter;

  // static property flag
  private final boolean isStatic;

  // Computed property flag
  private final boolean computed;

  /**
   * Constructor
   *
   * @param token   token
   * @param finish  finish
   * @param key     the key of this property
   * @param value   the value of this property
   * @param getter  getter function body
   * @param setter  setter function body
   * @param isStatic is this a static property?
   * @param computed is this a computed property?
   */
  public PropertyNode(long token, int finish, Expression key, Expression value, FunctionNode getter, FunctionNode setter, boolean isStatic, boolean computed) {
    super(token, finish);
    this.key = key;
    this.value = value;
    this.getter = getter;
    this.setter = setter;
    this.isStatic = isStatic;
    this.computed = computed;
  }

  PropertyNode(PropertyNode propertyNode, Expression key, Expression value, FunctionNode getter, FunctionNode setter, boolean isStatic, boolean computed) {
    super(propertyNode);
    this.key = key;
    this.value = value;
    this.getter = getter;
    this.setter = setter;
    this.isStatic = isStatic;
    this.computed = computed;
  }

  /**
   * Get the name of the property key, or {@code null} if key is a computed name.
   * @return key name or null
   */
  public String getKeyName() {
    return !computed && key instanceof PropertyKey ? ((PropertyKey) key).getPropertyName() : null;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterPropertyNode(this)) ?
      visitor.leavePropertyNode(
        setKey((Expression) key.accept(visitor))
        .setValue(value == null ? null : (Expression) value.accept(visitor))
        .setGetter(getter == null ? null : (FunctionNode) getter.accept(visitor))
        .setSetter(setter == null ? null : (FunctionNode) setter.accept(visitor))) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    if (value instanceof FunctionNode && ((FunctionNode) value).getIdent() != null) {
      value.toString(sb);
    }
    if (value != null) {
      ((Node) key).toString(sb, printType);
      sb.append(": ");
      value.toString(sb, printType);
    }
    if (getter != null) {
      sb.append(' ');
      getter.toString(sb, printType);
    }
    if (setter != null) {
      sb.append(' ');
      setter.toString(sb, printType);
    }
  }

  /**
   * Get the getter for this property
   * @return getter or null if none exists
   */
  public FunctionNode getGetter() {
    return getter;
  }

  /**
   * Set the getter of this property, null if none
   * @param getter getter
   * @return same node or new node if state changed
   */
  public PropertyNode setGetter(FunctionNode getter) {
    return (this.getter == getter) ? this : new PropertyNode(this, key, value, getter, setter, isStatic, computed);
  }

  /**
   * Return the key for this property node
   * @return the key
   */
  public Expression getKey() {
    return key;
  }

  PropertyNode setKey(Expression key) {
    return (this.key == key) ? this : new PropertyNode(this, key, value, getter, setter, isStatic, computed);
  }

  /**
   * Get the setter for this property
   * @return setter or null if none exists
   */
  public FunctionNode getSetter() {
    return setter;
  }

  /**
   * Set the setter for this property, null if none
   * @param setter setter
   * @return same node or new node if state changed
   */
  public PropertyNode setSetter(FunctionNode setter) {
    return (this.setter == setter) ? this : new PropertyNode(this, key, value, getter, setter, isStatic, computed);
  }

  /**
   * Get the value of this property
   * @return property value
   */
  public Expression getValue() {
    return value;
  }

  /**
   * Set the value of this property
   * @param value new value
   * @return same node or new node if state changed
   */
  public PropertyNode setValue(Expression value) {
    return (this.value == value) ? this : new PropertyNode(this, key, value, getter, setter, isStatic, computed);
  }

  /**
   * Returns true if this is a static property.
   * @return true if static flag is set
   */
  public boolean isStatic() {
    return isStatic;
  }

  /**
   * Returns true if this is a computed property.
   * @return true if the computed flag is set
   */
  public boolean isComputed() {
    return computed;
  }

  private static final long serialVersionUID = 1;
}
