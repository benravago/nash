package es.parser;

/**
 * A ParserContextNode that represents a loop that is being parsed
 */
class ParserContextLoopNode extends ParserContextBaseNode implements ParserContextBreakableNode {

  @Override
  public boolean isBreakableWithoutLabel() {
    return true;
  }

}
