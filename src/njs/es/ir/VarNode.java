package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * Node represents a var/let declaration.
 */
@Immutable
public final class VarNode extends Statement implements Assignment<IdentNode> {

  // Var name.
  private final IdentNode name;

  // Initialization expression.
  private final Expression init;

  // Is this a var statement (as opposed to a "var" in a for loop statement)
  private final int flags;

  /**
   * source order id to be used for this node.
   * If this is -1, then we the default which is start position of this node.
   * See also the method Node::getSourceOrder.
   */
  private final int sourceOrder;

  /** Flag for ES6 LET declaration */
  public static final int IS_LET = 1 << 0;

  /** Flag for ES6 CONST declaration */
  public static final int IS_CONST = 1 << 1;

  /**
   * Flag that determines if this is the last function declaration in a function.
   * This is used to micro optimize the placement of return value assignments for a program node */
  public static final int IS_LAST_FUNCTION_DECLARATION = 1 << 2;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param name       name of variable
   * @param init       init node or null if just a declaration
   */
  public VarNode(int lineNumber, long token, int finish, IdentNode name, Expression init) {
    this(lineNumber, token, finish, name, init, 0);
  }

  VarNode(VarNode varNode, IdentNode name, Expression init, int flags) {
    super(varNode);
    this.sourceOrder = -1;
    this.name = init == null ? name : name.setIsInitializedHere();
    this.init = init;
    this.flags = flags;
  }

  /**
   * Constructor
   *
   * @param lineNumber  line number
   * @param token       token
   * @param finish      finish
   * @param name        name of variable
   * @param init        init node or null if just a declaration
   * @param flags       flags
   */
  public VarNode(int lineNumber, long token, int finish, IdentNode name, Expression init, int flags) {
    this(lineNumber, token, -1, finish, name, init, flags);
  }

  /**
   * Constructor
   *
   * @param lineNumber  line number
   * @param token       token
   * @param sourceOrder source order
   * @param finish      finish
   * @param name        name of variable
   * @param init        init node or null if just a declaration
   * @param flags       flags
   */
  public VarNode(int lineNumber, long token, int sourceOrder, int finish, IdentNode name, Expression init, int flags) {
    super(lineNumber, token, finish);
    this.sourceOrder = sourceOrder;
    this.name = init == null ? name : name.setIsInitializedHere();
    this.init = init;
    this.flags = flags;
  }

  @Override
  public int getSourceOrder() {
    return sourceOrder == -1 ? super.getSourceOrder() : sourceOrder;
  }

  @Override
  public boolean isAssignment() {
    return hasInit();
  }

  @Override
  public IdentNode getAssignmentDest() {
    return isAssignment() ? name : null;
  }

  @Override
  public VarNode setAssignmentDest(IdentNode n) {
    return setName(n);
  }

  @Override
  public Expression getAssignmentSource() {
    return isAssignment() ? getInit() : null;
  }

  /**
   * Is this a VAR node block scoped? This returns true for ECMAScript 6 LET and CONST nodes.
   * @return true if an ES6 LET or CONST node
   */
  public boolean isBlockScoped() {
    return getFlag(IS_LET) || getFlag(IS_CONST);
  }

  /**
   * Is this an ECMAScript 6 LET node?
   * @return true if LET node
   */
  public boolean isLet() {
    return getFlag(IS_LET);
  }

  /**
   * Is this an ECMAScript 6 CONST node?
   * @return true if CONST node
   */
  public boolean isConst() {
    return getFlag(IS_CONST);
  }

  /**
   * Return the flags to use for symbols for this declaration.
   * @return the symbol flags
   */
  public int getSymbolFlags() {
    return isLet() ? Symbol.IS_VAR | Symbol.IS_LET
         : isConst() ? Symbol.IS_VAR | Symbol.IS_CONST
         : Symbol.IS_VAR;
  }

  /**
   * Does this variable declaration have an init value
   * @return true if an init exists, false otherwise
   */
  public boolean hasInit() {
    return init != null;
  }

  /**
   * Assist in IR navigation.
   * @param visitor IR navigating visitor.
   */
  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterVarNode(this)) {
      // var is right associative, so visit init before name
      var newInit = init == null ? null : (Expression) init.accept(visitor);
      var newName = (IdentNode) name.accept(visitor);
      VarNode newThis;
      if (name != newName || init != newInit) {
        newThis = new VarNode(this, newName, newInit, flags);
      } else {
        newThis = this;
      }
      return visitor.leaveVarNode(newThis);
    }
    return this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append(tokenType().getName()).append(' ');
    name.toString(sb, printType);
    if (init != null) {
      sb.append(" = ");
      init.toString(sb, printType);
    }
  }

  /**
   * If this is an assignment of the form {@code var x = init;}, get the init part.
   * @return the expression to initialize the variable to, null if just a declaration
   */
  public Expression getInit() {
    return init;
  }

  /**
   * Reset the initialization expression
   * @param init new initialization expression
   * @return a node equivalent to this one except for the requested change.
   */
  public VarNode setInit(Expression init) {
    return (this.init == init) ? this : new VarNode(this, name, init, flags);
  }

  /**
   * Get the identifier for the variable
   * @return IdentNode representing the variable being set or declared
   */
  public IdentNode getName() {
    return name;
  }

  /**
   * Reset the identifier for this VarNode
   * @param name new IdentNode representing the variable being set or declared
   * @return a node equivalent to this one except for the requested change.
   */
  public VarNode setName(IdentNode name) {
    return (this.name == name) ? this : new VarNode(this, name, init, flags);
  }

  private VarNode setFlags(int flags) {
    return (this.flags == flags) ? this : new VarNode(this, name, init, flags);
  }

  /**
   * Check if a flag is set for this var node
   * @param flag flag
   * @return true if flag is set
   */
  public boolean getFlag(int flag) {
    return (flags & flag) == flag;
  }

  /**
   * Set a flag for this var node
   * @param flag flag
   * @return new node if flags changed, same otherwise
   */
  public VarNode setFlag(int flag) {
    return setFlags(flags | flag);
  }

  /**
   * Returns true if this is a function declaration.
   * @return true if this is a function declaration.
   */
  public boolean isFunctionDeclaration() {
    return init instanceof FunctionNode node && node.isDeclared();
  }

  private static final long serialVersionUID = 1;
}
