package es.ir;

import es.codegen.types.Type;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;
import es.parser.Token;
import es.parser.TokenType;
import static es.codegen.CompilerConstants.*;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;

/**
 * IR representation for an identifier.
 */
@Immutable
public final class IdentNode extends Expression implements PropertyKey, FunctionCall, Optimistic, JoinPredecessor {

  private static final int PROPERTY_NAME = 1 << 0;
  private static final int INITIALIZED_HERE = 1 << 1;
  private static final int FUNCTION = 1 << 2;
  private static final int FUTURE_NAME = 1 << 3;
  private static final int IS_DECLARED_HERE = 1 << 4;
  private static final int IS_DEAD = 1 << 5;
  private static final int DIRECT_SUPER = 1 << 6;
  private static final int REST_PARAMETER = 1 << 7;
  private static final int PROTO_PROPERTY = 1 << 8;
  private static final int DEFAULT_PARAMETER = 1 << 9;
  private static final int DESTRUCTURED_PARAMETER = 1 << 10;

  // Identifier.
  private final String name;

  // Optimistic type
  private final Type type;

  private final int flags;

  private final int programPoint;

  private final LocalVariableConversion conversion;

  private Symbol symbol;

  /**
   * Constructor
   *
   * @param token   token
   * @param finish  finish position
   * @param name    name of identifier
   */
  public IdentNode(long token, int finish, String name) {
    super(token, finish);
    this.name = name;
    this.type = null;
    this.flags = 0;
    this.programPoint = INVALID_PROGRAM_POINT;
    this.conversion = null;
  }

  IdentNode(IdentNode identNode, String name, Type type, int flags, int programPoint, LocalVariableConversion conversion) {
    super(identNode);
    this.name = name;
    this.type = type;
    this.flags = flags;
    this.programPoint = programPoint;
    this.conversion = conversion;
    this.symbol = identNode.symbol;
  }

  /**
   * Copy constructor - create a new IdentNode for the same location
   *
   * @param identNode  identNode
   */
  public IdentNode(IdentNode identNode) {
    super(identNode);
    this.name = identNode.getName();
    this.type = identNode.type;
    this.flags = identNode.flags;
    this.conversion = identNode.conversion;
    this.programPoint = INVALID_PROGRAM_POINT;
    this.symbol = identNode.symbol;
  }

  /**
   * Creates an identifier for the symbol. Normally used by code generator for creating temporary storage identifiers
   * that must contain both a symbol and a type.
   * @param symbol the symbol to create a temporary identifier for.
   * @return a temporary identifier for the symbol.
   */
  public static IdentNode createInternalIdentifier(Symbol symbol) {
    return new IdentNode(Token.toDesc(TokenType.IDENT, 0, 0), 0, symbol.getName()).setSymbol(symbol);
  }

  @Override
  public Type getType() {
    return (type != null) ? type
         : (symbol != null && symbol.isScope()) ? Type.OBJECT
         : Type.UNDEFINED;
  }

  /**
   * Assist in IR navigation.
   * @param visitor IR navigating visitor.
   */
  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterIdentNode(this)) ? visitor.leaveIdentNode(this) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    if (printType) {
      optimisticTypeToString(sb, symbol == null || !symbol.hasSlot());
    }
    sb.append(name);
  }

  /**
   * Get the name of the identifier
   * @return  IdentNode name
   */
  public String getName() {
    return name;
  }

  @Override
  public String getPropertyName() {
    return getName();
  }

  @Override
  public boolean isLocal() {
    return !getSymbol().isScope();
  }

  /**
   * Return the Symbol the compiler has assigned to this identifier.
   * The symbol is a description of the storage location for the identifier.
   * @return the symbol
   */
  public Symbol getSymbol() {
    return symbol;
  }

  /**
   * Assign a symbol to this identifier. See {@link IdentNode#getSymbol()} for explanation of what a symbol is.
   * @param symbol the symbol
   * @return new node
   */
  public IdentNode setSymbol(Symbol symbol) {
    if (this.symbol == symbol) {
      return this;
    }
    var newIdent = (IdentNode) clone();
    newIdent.symbol = symbol;
    return newIdent;
  }

  /**
   * Check if this IdentNode is a property name
   * @return true if this is a property name
   */
  public boolean isPropertyName() {
    return (flags & PROPERTY_NAME) == PROPERTY_NAME;
  }

  /**
   * Flag this IdentNode as a property name
   * @return a node equivalent to this one except for the requested change.
   */
  public IdentNode setIsPropertyName() {
    return isPropertyName() ? this : new IdentNode(this, name, type, flags | PROPERTY_NAME, programPoint, conversion);
  }

  /**
   * Check if this IdentNode is a future name
   * @return true if this is a future name
   */
  public boolean isFutureName() {
    return (flags & FUTURE_NAME) == FUTURE_NAME;
  }

  /**
   * Flag this IdentNode as a future name
   * @return a node equivalent to this one except for the requested change.
   */
  public IdentNode setIsFutureName() {
    return isFutureName() ? this : new IdentNode(this, name, type, flags | FUTURE_NAME, programPoint, conversion);
  }

  /**
   * Helper function for local def analysis.
   * @return true if IdentNode is initialized on creation
   */
  public boolean isInitializedHere() {
    return (flags & INITIALIZED_HERE) == INITIALIZED_HERE;
  }

  /**
   * Flag IdentNode to be initialized on creation
   * @return a node equivalent to this one except for the requested change.
   */
  public IdentNode setIsInitializedHere() {
    return isInitializedHere() ? this : new IdentNode(this, name, type, flags | INITIALIZED_HERE, programPoint, conversion);
  }

  /**
   * Is this a LET or CONST identifier used before its declaration?
   * @return true if identifier is dead
   */
  public boolean isDead() {
    return (flags & IS_DEAD) != 0;
  }

  /**
   * Flag this IdentNode as a LET or CONST identifier used before its declaration.
   * @return a new IdentNode equivalent to this but marked as dead.
   */
  public IdentNode markDead() {
    return new IdentNode(this, name, type, flags | IS_DEAD, programPoint, conversion);
  }

  /**
   * Is this IdentNode declared here?
   * @return true if identifier is declared here
   */
  public boolean isDeclaredHere() {
    return (flags & IS_DECLARED_HERE) != 0;
  }

  /**
   * Flag this IdentNode as being declared here.
   * @return a new IdentNode equivalent to this but marked as declared here.
   */
  public IdentNode setIsDeclaredHere() {
    return isDeclaredHere() ? this : new IdentNode(this, name, type, flags | IS_DECLARED_HERE, programPoint, conversion);
  }

  /**
   * Check if the name of this IdentNode is same as that of a compile-time property (currently __DIR__, __FILE__, and __LINE__).
   * @return true if this IdentNode's name is same as that of a compile-time property
   */
  public boolean isCompileTimePropertyName() {
    return name.equals(__DIR__.symbolName()) || name.equals(__FILE__.symbolName()) || name.equals(__LINE__.symbolName());
  }

  @Override
  public boolean isFunction() {
    return (flags & FUNCTION) == FUNCTION;
  }

  @Override
  public IdentNode setType(Type type) {
    return (this.type == type) ? this : new IdentNode(this, name, type, flags, programPoint, conversion);
  }

  /**
   * Mark this node as being the callee operand of a {@link CallNode}.
   * @return an ident node identical to this one in all aspects except with its function flag set.
   */
  public IdentNode setIsFunction() {
    return isFunction() ? this : new IdentNode(this, name, type, flags | FUNCTION, programPoint, conversion);
  }

  /**
   * Mark this node as not being the callee operand of a {@link CallNode}.
   * @return an ident node identical to this one in all aspects except with its function flag unset.
   */
  public IdentNode setIsNotFunction() {
    return isFunction() ? new IdentNode(this, name, type, flags & ~FUNCTION, programPoint, conversion) : this;
  }

  @Override
  public int getProgramPoint() {
    return programPoint;
  }

  @Override
  public Optimistic setProgramPoint(int programPoint) {
    return (this.programPoint == programPoint) ? this : new IdentNode(this, name, type, flags, programPoint, conversion);
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

  @Override
  public JoinPredecessor setLocalVariableConversion(LexicalContext lc, LocalVariableConversion conversion) {
    return (this.conversion == conversion) ? this : new IdentNode(this, name, type, flags, programPoint, conversion);
  }

  /**
   * Is this an internal symbol, i.e. one that starts with ':'. Those can never be optimistic.
   * @return true if internal symbol
   */
  public boolean isInternal() {
    assert name != null;
    return name.charAt(0) == ':';
  }

  @Override
  public LocalVariableConversion getLocalVariableConversion() {
    return conversion;
  }

  /**
   * Checks if this is a direct super identifier
   * @return true if the direct super flag is set
   */
  public boolean isDirectSuper() {
    return (flags & DIRECT_SUPER) != 0;
  }

  /**
   * Return a new identifier with the direct super flag set.
   * @return the new identifier
   */
  public IdentNode setIsDirectSuper() {
    return new IdentNode(this, name, type, flags | DIRECT_SUPER, programPoint, conversion);
  }

  /**
   * Checks if this is a rest parameter
   * @return true if the rest parameter flag is set
   */
  public boolean isRestParameter() {
    return (flags & REST_PARAMETER) != 0;
  }

  /**
   * Return a new identifier with the rest parameter flag set.
   * @return the new identifier
   */
  public IdentNode setIsRestParameter() {
    return new IdentNode(this, name, type, flags | REST_PARAMETER, programPoint, conversion);
  }

  /**
   * Checks if this is a proto property name.
   * @return true if this is the proto property name
   */
  public boolean isProtoPropertyName() {
    return (flags & PROTO_PROPERTY) != 0;
  }

  /**
   * Return a new identifier with the proto property name flag set.
   * @return the new identifier
   */
  public IdentNode setIsProtoPropertyName() {
    return new IdentNode(this, name, type, flags | PROTO_PROPERTY, programPoint, conversion);
  }

  /**
   * Checks whether this is a default parameter.
   * @return true if this is a default parameter
   */
  public boolean isDefaultParameter() {
    return (flags & DEFAULT_PARAMETER) != 0;
  }

  /**
   * Return a new identifier with the default parameter flag set.
   * @return the new identifier
   */
  public IdentNode setIsDefaultParameter() {
    return new IdentNode(this, name, type, flags | DEFAULT_PARAMETER, programPoint, conversion);
  }

  /**
   * Checks whether this is a destructured parameter.
   * @return true if this is a destructured parameter
   */
  public boolean isDestructuredParameter() {
    return (flags & DESTRUCTURED_PARAMETER) != 0;
  }

  /**
   * Return a new identifier with the destructured parameter flag set.
   * @return the new identifier
   */
  public IdentNode setIsDestructuredParameter() {
    return new IdentNode(this, name, type, flags | DESTRUCTURED_PARAMETER, programPoint, conversion);
  }

  /**
   * Checks whether the source code for this ident contains a unicode escape sequence by comparing the length of its name with its length in source code.
   * @return true if ident source contains a unicode escape sequence
   */
  public boolean containsEscapes() {
    return Token.descLength(getToken()) != name.length();
  }

  private static final long serialVersionUID = 1;
}
