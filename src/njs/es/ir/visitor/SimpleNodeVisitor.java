package es.ir.visitor;

import es.ir.LexicalContext;

/**
 * Convenience base class for a {@link NodeVisitor} with a plain {@link LexicalContext}.
 */
public abstract class SimpleNodeVisitor extends NodeVisitor<LexicalContext> {

  /**
   * Creates a new simple node visitor.
   */
  public SimpleNodeVisitor() {
    super(new LexicalContext());
  }

}
