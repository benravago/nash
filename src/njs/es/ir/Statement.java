package es.ir;

/**
 * Statement is something that becomes code and can be stepped past.
 * A block is made up of statements.
 * The only node subclass that needs to keep token and location information is the Statement
 */
public abstract class Statement extends Node implements Terminal {

  private final int lineNumber;

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   */
  public Statement(int lineNumber, long token, int finish) {
    super(token, finish);
    this.lineNumber = lineNumber;
  }

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param token      token
   * @param start      start
   * @param finish     finish
   */
  protected Statement(int lineNumber, long token, int start, int finish) {
    super(token, start, finish);
    this.lineNumber = lineNumber;
  }

  /**
   * Copy constructor
   *
   * @param node source node
   */
  protected Statement(Statement node) {
    super(node);
    this.lineNumber = node.lineNumber;
  }

  /**
   * Return the line number
   * @return line number
   */
  public int getLineNumber() {
    return lineNumber;
  }

  /**
   * Is this a terminal statement, i.e. does it end control flow like a throw or return?
   * @return true if this node statement is terminal
   */
  @Override
  public boolean isTerminal() {
    return false;
  }

  /**
   * Check if this statement repositions control flow with goto like semantics, for example {@link BreakNode} or a {@link ForNode} with no test
   * @return true if statement has goto semantics
   */
  public boolean hasGoto() {
    return false;
  }

  /**
   * Check if this statement has terminal flags, i.e. ends or breaks control flow
   * @return true if has terminal flags
   */
  public final boolean hasTerminalFlags() {
    return isTerminal() || hasGoto();
  }

}
