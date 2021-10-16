package es.parser;

/**
 * ParserContextNode that represents a LabelNode
 */
class ParserContextLabelNode extends ParserContextBaseNode {

  // Name for label
  private final String name;

  /**
   * Constructor
   * @param name The name of the label
   */
  public ParserContextLabelNode(String name) {
    this.name = name;
  }

  /**
   * Returns the name of the label
   * @return name of label
   */
  public String getLabelName() {
    return name;
  }

}
