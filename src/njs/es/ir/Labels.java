package es.ir;

import java.util.List;

import es.codegen.Label;

/**
 * Interface that can be used to get a list of all labels in a node
 */
public interface Labels {

  /**
   * Return the labels associated with this node.
   * Breakable nodes that aren't LoopNodes only have a break label - the location immediately afterwards the node in code
   * @return list of labels representing locations around this node
   */
  List<Label> getLabels();

}
