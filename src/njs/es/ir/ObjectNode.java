package es.ir;

import java.util.Collections;
import java.util.List;
import java.util.RandomAccess;

import es.codegen.types.Type;
import es.ir.annotations.Ignore;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation of an object literal.
 */
@Immutable
public final class ObjectNode extends Expression implements LexicalContextNode, Splittable {

  // Literal elements.
  private final List<PropertyNode> elements;

  // Ranges for splitting large literals over multiple compile units in codegen.
  @Ignore
  private final List<Splittable.SplitRange> splitRanges;

  /**
   * Constructor
   *
   * @param token    token
   * @param finish   finish
   * @param elements the elements used to initialize this ObjectNode
   */
  public ObjectNode(long token, int finish, List<PropertyNode> elements) {
    super(token, finish);
    this.elements = elements;
    this.splitRanges = null;
    assert elements instanceof RandomAccess : "Splitting requires random access lists";
  }

  private ObjectNode(ObjectNode objectNode, List<PropertyNode> elements, List<Splittable.SplitRange> splitRanges) {
    super(objectNode);
    this.elements = elements;
    this.splitRanges = splitRanges;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return Acceptor.accept(this, visitor);
  }

  @Override
  public Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterObjectNode(this)) ? visitor.leaveObjectNode(setElements(lc, Node.accept(visitor, elements))) : this;
  }

  @Override
  public Type getType() {
    return Type.OBJECT;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append('{');
    if (!elements.isEmpty()) {
      sb.append(' ');
      var first = true;
      for (var element : elements) {
        if (!first) {
          sb.append(", ");
        }
        first = false;
        element.toString(sb, printType);
      }
      sb.append(' ');
    }
    sb.append('}');
  }

  /**
   * Get the elements of this literal node
   * @return a list of elements
   */
  public List<PropertyNode> getElements() {
    return Collections.unmodifiableList(elements);
  }

  ObjectNode setElements(LexicalContext lc, List<PropertyNode> elements) {
    return (this.elements == elements) ? this : Node.replaceInLexicalContext(lc, this, new ObjectNode(this, elements, this.splitRanges));
  }

  /**
   * Set the split ranges for this ObjectNode
   * @see Splittable.SplitRange
   * @param lc the lexical context
   * @param splitRanges list of split ranges
   * @return new or changed object node
   */
  public ObjectNode setSplitRanges(LexicalContext lc, List<Splittable.SplitRange> splitRanges) {
    return (this.splitRanges == splitRanges) ? this : Node.replaceInLexicalContext(lc, this, new ObjectNode(this, elements, splitRanges));
  }

  /**
   * Get the split ranges for this ObjectNode, or null if the object is not split.
   * @see Splittable.SplitRange
   * @return list of split ranges
   */
  @Override
  public List<Splittable.SplitRange> getSplitRanges() {
    return splitRanges == null ? null : Collections.unmodifiableList(splitRanges);
  }

}
