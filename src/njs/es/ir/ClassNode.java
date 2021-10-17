package es.ir;

import java.util.Collections;
import java.util.List;

import es.codegen.types.Type;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation for class definitions.
 */
public class ClassNode extends Expression {

  private final IdentNode ident;
  private final Expression classHeritage;
  private final PropertyNode constructor;
  private final List<PropertyNode> classElements;
  private final int line;
  private final boolean isStatement;

  /**
   * Constructor.
   *
   * @param line line number
   * @param token token
   * @param finish finish
   * @param ident ident
   * @param classHeritage class heritage
   * @param constructor constructor
   * @param classElements class elements
   * @param isStatement is this a statement or an expression?
   */
  public ClassNode(int line, long token, int finish, IdentNode ident, Expression classHeritage, PropertyNode constructor, List<PropertyNode> classElements, boolean isStatement) {
    super(token, finish);
    this.line = line;
    this.ident = ident;
    this.classHeritage = classHeritage;
    this.constructor = constructor;
    this.classElements = classElements;
    this.isStatement = isStatement;
  }

  /**
   * Class identifier. Optional.
   * @return the class identifier
   */
  public IdentNode getIdent() {
    return ident;
  }

  /**
   * The expression of the {@code extends} clause. Optional.
   * @return the class heritage
   */
  public Expression getClassHeritage() {
    return classHeritage;
  }

  /**
   * Get the constructor method definition.
   * @return the constructor
   */
  public PropertyNode getConstructor() {
    return constructor;
  }

  /**
   * Get method definitions except the constructor.
   * @return the class elements
   */
  public List<PropertyNode> getClassElements() {
    return Collections.unmodifiableList(classElements);
  }

  /**
   * Returns if this class was a statement or an expression
   * @return true if this class was a statement
   */
  public boolean isStatement() {
    return isStatement;
  }

  /**
   * Returns the line number.
   * @return the line number
   */
  public int getLineNumber() {
    return line;
  }

  @Override
  public Type getType() {
    return Type.OBJECT;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterClassNode(this)) ? visitor.leaveClassNode(this) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append("class");
    if (ident != null) {
      sb.append(' ');
      ident.toString(sb, printType);
    }
    if (classHeritage != null) {
      sb.append(" extends");
      classHeritage.toString(sb, printType);
    }
    sb.append(" {");
    if (constructor != null) {
      constructor.toString(sb, printType);
    }
    for (var classElement : classElements) {
      sb.append(" ");
      classElement.toString(sb, printType);
    }
    sb.append("}");
  }

}
