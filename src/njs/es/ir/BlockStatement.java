package es.ir;

import java.util.List;

import es.ir.visitor.NodeVisitor;

/**
 * Represents a block used as a statement.
 */
public class BlockStatement extends Statement {

  // Block to execute.
  private final Block block;

  /**
   * Constructor
   *
   * @param block the block to execute
   */
  public BlockStatement(Block block) {
    this(block.getFirstStatementLineNumber(), block);
  }

  /**
   * Constructor
   *
   * @param lineNumber line number
   * @param block the block to execute
   */
  public BlockStatement(int lineNumber, Block block) {
    super(lineNumber, block.getToken(), block.getFinish());
    this.block = block;
  }

  BlockStatement(BlockStatement blockStatement, Block block) {
    super(blockStatement);
    this.block = block;
  }

  /**
   * Use this method to create a block statement meant to replace a single statement.
   * @param stmt the statement to replace
   * @param newStmts the statements for the new block statement
   * @return a block statement with the new statements. It will have the line number, token, and finish of the original statement.
   */
  public static BlockStatement createReplacement(Statement stmt, List<Statement> newStmts) {
    return createReplacement(stmt, stmt.getFinish(), newStmts);
  }

  /**
   * Use this method to create a block statement meant to replace a single statement.
   * @param stmt the statement to replace
   * @param finish the new finish for the block
   * @param newStmts the statements for the new block statement
   * @return a block statement with the new statements. It will have the line number, and token of the original statement.
   */
  public static BlockStatement createReplacement(Statement stmt, int finish, List<Statement> newStmts) {
    return new BlockStatement(stmt.getLineNumber(), new Block(stmt.getToken(), finish, newStmts));
  }

  @Override
  public boolean isTerminal() {
    return block.isTerminal();
  }

  /**
   * Tells if this is a synthetic block statement or not.
   * @return true if this is a synthetic statement
   */
  public boolean isSynthetic() {
    return block.isSynthetic();
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterBlockStatement(this)) ? visitor.leaveBlockStatement(setBlock((Block) block.accept(visitor))) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    block.toString(sb, printType);
  }

  /**
   * Return the block to be executed
   * @return the block
   */
  public Block getBlock() {
    return block;
  }

  /**
   * Reset the block to be executed
   * @param block the block
   * @return new or same execute node
   */
  public BlockStatement setBlock(Block block) {
    return (this.block == block) ? this : new BlockStatement(this, block);
  }

}
