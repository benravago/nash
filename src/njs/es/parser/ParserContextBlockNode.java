package es.parser;

/**
 * A ParserContextNode that represents a block that is currently being parsed
 */
class ParserContextBlockNode extends ParserContextBaseNode implements ParserContextBreakableNode {

  private final long token;

  /**
   * Constructs a ParserContextBlockNode
   *
   * @param token The first token of the block
   */
  public ParserContextBlockNode(final long token) {
    this.token = token;
  }

  @Override
  public boolean isBreakableWithoutLabel() {
    return false;
  }

  /**
   * Get token
   * @return The first token of the block
   */
  public long getToken() {
    return token;
  }

}
