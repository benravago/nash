package es.ir;

import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representing a FOR statement.
 */
@Immutable
public final class ForNode extends LoopNode {

  // Initialize expression for an ordinary for statement, or the LHS expression receiving iterated-over values in a for-in statement.
  private final Expression init;

  // Modify expression for an ordinary statement, or the source of the iterator in the for-in statement.
  private final JoinPredecessorExpression modify;

  // Iterator symbol.
  private final Symbol iterator;

  /** Is this a normal for in loop? */
  public static final int IS_FOR_IN = 1 << 0;

  /** Is this a normal for each in loop? */
  public static final int IS_FOR_EACH = 1 << 1;

  /** Is this a ES6 for-of loop? */
  public static final int IS_FOR_OF = 1 << 2;

  /** Does this loop need a per-iteration scope because its init contain a LET declaration? */
  public static final int PER_ITERATION_SCOPE = 1 << 3;

  private final int flags;

  /**
   * Constructs a ForNode
   *
   * @param lineNumber The line number of header
   * @param token      The for token
   * @param finish     The last character of the for node
   * @param body       The body of the for node
   * @param flags      The flags
   */
  public ForNode(int lineNumber, long token, int finish, Block body, int flags) {
    this(lineNumber, token, finish, body, flags, null, null, null);
  }

  /**
   * Constructor
   *
   * @param lineNumber The line number of header
   * @param token      The for token
   * @param finish     The last character of the for node
   * @param body       The body of the for node
   * @param flags      The flags
   * @param init       The initial expression
   * @param test       The test expression
   * @param modify     The modify expression
   */
  public ForNode(int lineNumber, long token, int finish, Block body, int flags, Expression init, JoinPredecessorExpression test, JoinPredecessorExpression modify) {
    super(lineNumber, token, finish, body, test, false);
    this.flags = flags;
    this.init = init;
    this.modify = modify;
    this.iterator = null;
  }

  ForNode(ForNode forNode, Expression init, JoinPredecessorExpression test, Block body, JoinPredecessorExpression modify, int flags, boolean controlFlowEscapes, LocalVariableConversion conversion, Symbol iterator) {
    super(forNode, test, body, controlFlowEscapes, conversion);
    this.init = init;
    this.modify = modify;
    this.flags = flags;
    this.iterator = iterator;
  }

  @Override
  public Node ensureUniqueLabels(LexicalContext lc) {
    return Node.replaceInLexicalContext(lc, this, new ForNode(this, init, test, body, modify, flags, controlFlowEscapes, conversion, iterator));
  }

  @Override
  public Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterForNode(this)) {
      return visitor.leaveForNode(
        setInit(lc, init == null ? null : (Expression) init.accept(visitor))
        .setTest(lc, test == null ? null : (JoinPredecessorExpression) test.accept(visitor))
        .setModify(lc, modify == null ? null : (JoinPredecessorExpression) modify.accept(visitor))
        .setBody(lc, (Block) body.accept(visitor))
      );
    }
    return this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printTypes) {
    sb.append("for");
    LocalVariableConversion.toString(conversion, sb).append(' ');
    if (isForIn()) {
      init.toString(sb, printTypes);
      sb.append(" in ");
      modify.toString(sb, printTypes);
    } else if (isForOf()) {
      init.toString(sb, printTypes);
      sb.append(" of ");
      modify.toString(sb, printTypes);
    } else {
      if (init != null) {
        init.toString(sb, printTypes);
      }
      sb.append("; ");
      if (test != null) {
        test.toString(sb, printTypes);
      }
      sb.append("; ");
      if (modify != null) {
        modify.toString(sb, printTypes);
      }
    }
    sb.append(')');
  }

  @Override
  public boolean hasGoto() {
    return !isForInOrOf() && test == null;
  }

  @Override
  public boolean mustEnter() {
    return isForInOrOf() ? false : (test == null);
    // may be an empty set to iterate over, then we skip the loop
  }

  /**
   * Get the initialization expression for this for loop
   * @return the initialization expression
   */
  public Expression getInit() {
    return init;
  }

  /**
   * Reset the initialization expression for this for loop
   * @param lc lexical context
   * @param init new initialization expression
   * @return new for node if changed or existing if not
   */
  public ForNode setInit(LexicalContext lc, Expression init) {
    return (this.init == init) ? this : Node.replaceInLexicalContext(lc, this, new ForNode(this, init, test, body, modify, flags, controlFlowEscapes, conversion, iterator));
  }

  /**
   * Is this a for in construct rather than a standard init;condition;modification one
   * @return true if this is a for in constructor
   */
  public boolean isForIn() {
    return (flags & IS_FOR_IN) != 0;
  }

  /**
   * Is this a for-of loop?
   * @return true if this is a for-of loop
   */
  public boolean isForOf() {
    return (flags & IS_FOR_OF) != 0;
  }

  /**
   * Is this a for-in or for-of statement?
   * @return true if this is a for-in or for-of loop
   */
  public boolean isForInOrOf() {
    return isForIn() || isForOf();
  }

  /**
   * Is this a for each construct, known from e.g. Rhino. This will be a for of construct in ECMAScript 6
   * @return true if this is a for each construct
   */
  public boolean isForEach() {
    return (flags & IS_FOR_EACH) != 0;
  }

  /**
   * If this is a for in or for each construct, there is an iterator symbol
   * @return the symbol for the iterator to be used, or null if none exists
   */
  public Symbol getIterator() {
    return iterator;
  }

  /**
   * Assign an iterator symbol to this ForNode. Used for for in and for each constructs
   * @param lc the current lexical context
   * @param iterator the iterator symbol
   * @return a ForNode with the iterator set
   */
  public ForNode setIterator(LexicalContext lc, Symbol iterator) {
    return (this.iterator == iterator) ? this : Node.replaceInLexicalContext(lc, this, new ForNode(this, init, test, body, modify, flags, controlFlowEscapes, conversion, iterator));
  }

  /**
   * Get the modification expression for this ForNode
   * @return the modification expression
   */
  public JoinPredecessorExpression getModify() {
    return modify;
  }

  /**
   * Reset the modification expression for this ForNode
   * @param lc lexical context
   * @param modify new modification expression
   * @return new for node if changed or existing if not
   */
  public ForNode setModify(LexicalContext lc, JoinPredecessorExpression modify) {
    return (this.modify == modify) ? this : Node.replaceInLexicalContext(lc, this, new ForNode(this, init, test, body, modify, flags, controlFlowEscapes, conversion, iterator));
  }

  @Override
  public ForNode setTest(LexicalContext lc, JoinPredecessorExpression test) {
    return (this.test == test) ? this : Node.replaceInLexicalContext(lc, this, new ForNode(this, init, test, body, modify, flags, controlFlowEscapes, conversion, iterator));
  }

  @Override
  public Block getBody() {
    return body;
  }

  @Override
  public ForNode setBody(LexicalContext lc, Block body) {
    return (this.body == body) ? this : Node.replaceInLexicalContext(lc, this, new ForNode(this, init, test, body, modify, flags, controlFlowEscapes, conversion, iterator));
  }

  @Override
  public ForNode setControlFlowEscapes(LexicalContext lc, boolean controlFlowEscapes) {
    return (this.controlFlowEscapes == controlFlowEscapes) ? this : Node.replaceInLexicalContext(lc, this, new ForNode(this, init, test, body, modify, flags, controlFlowEscapes, conversion, iterator));
  }

  @Override
  JoinPredecessor setLocalVariableConversionChanged(LexicalContext lc, LocalVariableConversion conversion) {
    return Node.replaceInLexicalContext(lc, this, new ForNode(this, init, test, body, modify, flags, controlFlowEscapes, conversion, iterator));
  }

  @Override
  public boolean hasPerIterationScope() {
    return (flags & PER_ITERATION_SCOPE) != 0;
  }

  /**
   * Returns true if this for-node needs the scope creator of its containing block to create per-iteration scope.
   * This is only true for for-in loops with lexical declarations.
   * @see Block#providesScopeCreator()
   * @return true if the containing block's scope object creator is required in codegen
   */
  public boolean needsScopeCreator() {
    return isForInOrOf() && hasPerIterationScope();
  }

  private static final long serialVersionUID = 1;
}
