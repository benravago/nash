package es.parser;

import java.util.List;

import es.ir.Statement;

/**
 * Used for keeping state when needed in the parser.
 */
interface ParserContextNode {

  /**
   * @return The flags for this node
   */
  public int getFlags();

  /**
   * @param flag The flag to set
   * @return All current flags after update
   */
  public int setFlag(int flag);

  /**
   * @return The list of statements that belongs to this node
   */
  public List<Statement> getStatements();

  /**
   * @param statements The statement list
   */
  public void setStatements(List<Statement> statements);

  /**
   * Adds a statement at the end of the statement list
   * @param statement The statement to add
   */
  public void appendStatement(Statement statement);

  /**
   * Adds a statement at the beginning of the statement list
   * @param statement The statement to add
   */
  public void prependStatement(Statement statement);

}
