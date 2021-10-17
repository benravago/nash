package es.ir;

/**
 * Interface for AST nodes that can have a flag determining if they can terminate function control flow.
 */
public interface Terminal {

  /**
   * Returns true if this AST node is (or contains) a statement that terminates function control flow.
   * @return true if this AST node is (or contains) a statement that terminates function control flow.
   */
  boolean isTerminal();

}
