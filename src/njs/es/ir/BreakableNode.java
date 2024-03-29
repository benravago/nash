package es.ir;

import es.codegen.Label;

/**
 * This class represents a node from which control flow can execute a {@code break} statement
 */
public interface BreakableNode extends LexicalContextNode, JoinPredecessor, Labels {

  /**
   * Ensure that any labels in this breakable node are unique so that new jumps won't go to old parts of the tree.
   * Used, for example, for cloning finally blocks
   *
   * @param lc the lexical context
   * @return node after labels have been made unique
   */
  Node ensureUniqueLabels(LexicalContext lc);

  /**
   * Check whether this can be broken out from without using a label, e.g. everything but Blocks, basically
   * @return true if breakable without label
   */
  boolean isBreakableWithoutLabel();

  /**
   * Return the break label, i.e. the location to go to on break.
   * @return the break label
   */
  Label getBreakLabel();

}
