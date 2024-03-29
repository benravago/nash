package es.parser;

import java.util.ArrayList;
import java.util.List;

import es.ir.Statement;

/**
 * Base class for parser context nodes
 */
abstract class ParserContextBaseNode implements ParserContextNode {

  /**
   * Flags for this node
   */
  protected int flags;

  private List<Statement> statements;

  /**
   * Constructor
   */
  public ParserContextBaseNode() {
    this.statements = new ArrayList<>();
  }

  /**
   * @return The flags for this node
   */
  @Override
  public int getFlags() {
    return flags;
  }

  /**
   * Returns a single flag
   * @param flag flag
   * @return A single flag
   */
  protected int getFlag(int flag) {
    return (flags & flag);
  }

  /**
   * @param flag flag
   * @return the new flags
   */
  @Override
  public int setFlag(int flag) {
    flags |= flag;
    return flags;
  }

  /**
   * @return The list of statements that belongs to this node
   */
  @Override
  public List<Statement> getStatements() {
    return statements;
  }

  /**
   * @param statements statements
   */
  @Override
  public void setStatements(List<Statement> statements) {
    this.statements = statements;
  }

  /**
   * Adds a statement at the end of the statement list
   * @param statement The statement to add
   */
  @Override
  public void appendStatement(Statement statement) {
    this.statements.add(statement);
  }

  /**
   * Adds a statement at the beginning of the statement list
   * @param statement The statement to add
   */
  @Override
  public void prependStatement(Statement statement) {
    this.statements.add(0, statement);
  }

}
