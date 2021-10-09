package es.parser;

import es.ir.BreakNode;

/**
 * An interface that is implemented by ParserContextNodes that can
 * contain a {@link BreakNode}
 */
interface ParserContextBreakableNode extends ParserContextNode {

  /**
   * Returns true if not i breakable without label, false otherwise
   * @return Returns true if not i breakable without label, false otherwise
   */
  boolean isBreakableWithoutLabel();
}
