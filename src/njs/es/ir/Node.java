package es.ir;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import es.ir.visitor.NodeVisitor;
import es.parser.Token;
import es.parser.TokenType;

/**
 * Nodes are used to compose Abstract Syntax Trees.
 */
public abstract class Node implements Cloneable, Serializable {

  /** Constant used for synthetic AST nodes that have no line number. */
  public static final int NO_LINE_NUMBER = -1;

  /** Constant used for synthetic AST nodes that have no token. */
  public static final long NO_TOKEN = 0L;

  /** Constant used for synthetic AST nodes that have no finish. */
  public static final int NO_FINISH = 0;

  // Start of source range.
  protected final int start;

  // End of source range.
  protected final int finish;

  // Token descriptor.
  private final long token;

  /**
   * Constructor
   *
   * @param token  token
   * @param finish finish
   */
  public Node(long token, int finish) {
    this.token = token;
    this.start = Token.descPosition(token);
    this.finish = finish;
  }

  /**
   * Constructor
   *
   * @param token   token
   * @param start   start
   * @param finish  finish
   */
  protected Node(long token, int start, int finish) {
    this.start = start;
    this.finish = finish;
    this.token = token;
  }

  /**
   * Copy constructor
   *
   * @param node source node
   */
  protected Node(Node node) {
    this.token = node.token;
    this.start = node.start;
    this.finish = node.finish;
  }

  /**
   * Copy constructor that overrides finish
   *
   * @param node source node
   * @param finish Last character
   */
  protected Node(Node node, int finish) {
    this.token = node.token;
    this.start = node.start;
    this.finish = finish;
  }

  /**
   * Is this a loop node?
   * @return true if atom
   */
  public boolean isLoop() {
    return false;
  }

  /**
   * Is this an assignment node - for example a var node with an init or a binary node that writes to a destination
   * @return true if assignment
   */
  public boolean isAssignment() {
    return false;
  }

  /**
   * For reference copies - ensure that labels in the copy node are unique using an appropriate copy constructor
   * @param lc lexical context
   * @return new node or same of no labels
   */
  public Node ensureUniqueLabels(LexicalContext lc) {
    return this;
  }

  /**
   * Provides a means to navigate the IR.
   * @param visitor Node visitor.
   * @return node the node or its replacement after visitation, null if no further visitations are required
   */
  public abstract Node accept(NodeVisitor<? extends LexicalContext> visitor);

  @Override
  public final String toString() {
    return toString(true);
  }

  /**
   * Return String representation of this Node.
   * @param includeTypeInfo include type information or not
   */
  public final String toString(boolean includeTypeInfo) {
    var sb = new StringBuilder();
    toString(sb, includeTypeInfo);
    return sb.toString();
  }

  /**
   * String conversion helper. Fills a {@link StringBuilder} with the string version of this node
   * @param sb a StringBuilder
   */
  public void toString(StringBuilder sb) {
    toString(sb, true);
  }

  /**
   * Print logic that decides whether to show the optimistic type or not
   * - for example it should not be printed after just parse, when it hasn't been computed, or has been set to a trivially provable value
   * @param sb   string builder
   * @param printType print type?
   */
  public abstract void toString(StringBuilder sb, boolean printType);

  /**
   * Get the finish position for this node in the source string
   * @return finish
   */
  public int getFinish() {
    return finish;
  }

  /**
   * Get start position for node
   * @return start position
   */
  public int getStart() {
    return start;
  }

  /**
   * Integer to sort nodes in source order.
   * This order is used by parser API to sort statements in correct order.
   * By default, this is the start position of this node.
   * @return int code to sort this node.
   */
  public int getSourceOrder() {
    return getStart();
  }

  @Override
  protected Object clone() {
    try {
      return super.clone();
    }
    catch (CloneNotSupportedException e) {
      throw new AssertionError(e); // TODO: use uncheck()
    }
  }

  @Override
  public final boolean equals(Object other) {
    return this == other;
  }

  @Override
  public final int hashCode() {
    // NOTE: we aren't delegating to Object.hashCode as it still requires trip to the VM for initializing,
    // it touches the object header and/or stores the identity hashcode somewhere, etc.
    // There's several places in the compiler pipeline that store nodes in maps, so this can get hot.
    return Long.hashCode(token);
  }

  /**
   * Return token position from a token descriptor.
   * @return Start position of the token in the source.
   */
  public int position() {
    return Token.descPosition(token);
  }

  /**
   * Return token length from a token descriptor.
   * @return Length of the token.
   */
  public int length() {
    return Token.descLength(token);
  }

  /**
   * Returns this node's token's type.
   * If you want to check for the node having a specific token type, consider using {@link #isTokenType(TokenType)} instead.
   * @return type of token.
   */
  public TokenType tokenType() {
    return Token.descType(token);
  }

  /**
   * Tests if this node has the specific token type.
   * @param type a token type to check this node's token type against
   * @return true if token types match.
   */
  public boolean isTokenType(TokenType type) {
    return tokenType() == type;
  }

  /**
   * Get the token for this node.
   * If you want to retrieve the token's type, consider using {@link #tokenType()} or {@link #isTokenType(TokenType)} instead.
   * @return the token
   */
  public long getToken() {
    return token;
  }

  //on change, we have to replace the entire list, that's we can't simple do ListIterator.set
  static <T extends Node> List<T> accept(NodeVisitor<? extends LexicalContext> visitor, List<T> list) {
    var size = list.size();
    if (size == 0) {
      return list;
    }
    List<T> newList = null;
    for (var i = 0; i < size; i++) {
      var node = list.get(i);
      @SuppressWarnings("unchecked")
      var newNode = node == null ? null : (T) node.accept(visitor);
      if (newNode != node) {
        if (newList == null) {
          newList = new ArrayList<>(size);
          for (var j = 0; j < i; j++) {
            newList.add(list.get(j));
          }
        }
        newList.add(newNode);
      } else {
        if (newList != null) {
          newList.add(node);
        }
      }
    }
    return newList == null ? list : newList;
  }

  static <T extends LexicalContextNode> T replaceInLexicalContext(LexicalContext lc, T oldNode, T newNode) {
    if (lc != null) {
      lc.replace(oldNode, newNode);
    }
    return newNode;
  }

  private static final long serialVersionUID = 1;
}
