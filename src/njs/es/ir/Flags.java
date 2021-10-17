package es.ir;

/**
 * Interface implemented by all nodes that have flags in a lexical context.
 *
 * This is needed as we sometimes have to save the setting of flags in the lexical context until a block is completely finished
 * and its final version (after multiple copy on writes) is placed in the lexical context
 *
 * @param <T> lexical context node that can have flags set during code generation
 */
public interface Flags<T extends LexicalContextNode> {

  /**
   * Get all flags of a LexicalContextNode
   * @return flags
   */
  int getFlags();

  /**
   * Check if a flag is set in a lexical context node
   * @param flag flag to check
   * @return flags
   */
  boolean getFlag(int flag);

  /**
   * Clear a flag of a LexicalContextNode
   * @param lc lexical context
   * @param flag flag to clear
   * @return the new LexicalContext node if flags were changed, same otherwise
   */
  T clearFlag(LexicalContext lc, int flag);

  /**
   * Set a flag of a LexicalContextNode
   * @param lc lexical context
   * @param flag flag to set
   * @return the new LexicalContext node if flags were changed, same otherwise
   */
  T setFlag(LexicalContext lc, int flag);

  /**
   * Set all flags of a LexicalContextNode, overwriting previous flags
   * @param lc lexical context
   * @param flags new flags value
   * @return the new LexicalContext node if flags were changed, same otherwise
   */
  T setFlags(LexicalContext lc, int flags);

}
