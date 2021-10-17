package es.ir;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;

/**
 * This is a subclass of lexical context used for filling blocks (and function nodes) with statements.
 *
 * When popping a block from the lexical context, any statements that have been generated in it are committed to the block.
 * This saves unnecessary object mutations and lexical context replacement
 */
public class BlockLexicalContext extends LexicalContext {

  // statement stack, each block on the lexical context maintains one of these, which is committed to the block on pop
  private final Deque<List<Statement>> sstack = new ArrayDeque<>();

  // Last non debug statement emitted in this context
  protected Statement lastStatement;

  @Override
  public <T extends LexicalContextNode> T push(T node) {
    var pushed = super.push(node);
    if (node instanceof Block) {
      sstack.push(new ArrayList<Statement>());
    }
    return pushed;
  }

  /**
   * Get the statement list from the stack, possibly filtered
   * @return statement list
   */
  protected List<Statement> popStatements() {
    return sstack.pop();
  }

  /**
   * Override this method to perform some additional processing on the block after its statements have been set.
   * By default does nothing and returns the original block.
   * @param block the block to operate on
   * @return a modified block.
   */
  protected Block afterSetStatements(Block block) {
    return block;
  }

  @SuppressWarnings("unchecked")
  @Override
  public <T extends Node> T pop(T node) {
    var expected = node;
    if (node instanceof Block block) {
      var newStatements = popStatements();
      expected = (T) block.setStatements(this, newStatements);
      expected = (T) afterSetStatements((Block) expected);
      if (!sstack.isEmpty()) {
        lastStatement = lastStatement(sstack.peek());
      }
    }
    return super.pop(expected);
  }

  /**
   * Append a statement to the block being generated
   * @param statement statement to add
   */
  public void appendStatement(Statement statement) {
    assert statement != null;
    sstack.peek().add(statement);
    lastStatement = statement;
  }

  /**
   * Prepend a statement to the block being generated
   * @param statement statement to prepend
   * @return the prepended statement
   */
  public Node prependStatement(Statement statement) {
    assert statement != null;
    sstack.peek().add(0, statement);
    return statement;
  }

  /**
   * Prepend a list of statement to the block being generated
   * @param statements a list of statements to prepend
   */
  public void prependStatements(List<Statement> statements) {
    assert statements != null;
    sstack.peek().addAll(0, statements);
  }

  /**
   * Get the last statement that was emitted into a block
   * @return the last statement emitted
   */
  public Statement getLastStatement() {
    return lastStatement;
  }

  static Statement lastStatement(List<Statement> statements) {
    var s = statements.size();
    return s == 0 ? null : statements.get(s - 1);
  }

}
