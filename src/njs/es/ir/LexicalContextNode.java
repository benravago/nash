package es.ir;

import es.ir.visitor.NodeVisitor;

/**
 * Interface for nodes that can be part of the lexical context.
 * @see LexicalContext
 */
public interface LexicalContextNode {

  /**
   * Accept function for the node given a lexical context.
   * It must be prepared to replace itself if present in the lexical context
   *
   * @param lc      lexical context
   * @param visitor node visitor
   * @return new node or same node depending on state change
   */
  Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor);

  // Would be a default method on Java 8

  /**
   * Helper class for accept for items of this lexical context,
   * delegates to the subclass accept and makes sure that the node is on the context before accepting
   * and gets popped after accepting (and that the stack is consistent in that the node has been replaced with the possible new node resulting in visitation)
   */
  static class Acceptor {

    static Node accept(LexicalContextNode node, NodeVisitor<? extends LexicalContext> visitor) {
      var lc = visitor.getLexicalContext();
      lc.push(node);
      var newNode = node.accept(lc, visitor);
      return lc.pop(newNode);
    }
  }

}
