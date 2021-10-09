package es.parser;

/**
 * A ParserContextNode that represents a SwitchNode that is currently being parsed
 */
class ParserContextSwitchNode extends ParserContextBaseNode implements ParserContextBreakableNode {

  @Override
  public boolean isBreakableWithoutLabel() {
    return true;
  }
}
