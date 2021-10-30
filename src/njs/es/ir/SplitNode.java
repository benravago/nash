package es.ir;

import java.io.IOException;
import java.io.NotSerializableException;
import java.io.ObjectOutputStream;
import es.codegen.CompileUnit;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * Node indicating code is split across classes.
 */
@Immutable
public class SplitNode extends LexicalContextStatement implements CompileUnitHolder {

  // Split node method name.
  private final String name;

  // Compilation unit.
  private final CompileUnit compileUnit;

  // Body of split code.
  private final Block body;

  /**
   * Constructor
   *
   * @param name        name of split node
   * @param body        body of split code
   * @param compileUnit compile unit to use for the body
   */
  public SplitNode(String name, Block body, CompileUnit compileUnit) {
    super(body.getFirstStatementLineNumber(), body.getToken(), body.getFinish());
    this.name = name;
    this.body = body;
    this.compileUnit = compileUnit;
  }

  private SplitNode(SplitNode splitNode, Block body, CompileUnit compileUnit) {
    super(splitNode);
    this.name = splitNode.name;
    this.body = body;
    this.compileUnit = compileUnit;
  }

  /**
   * Get the body for this split node - i.e. the actual code it encloses
   * @return body for split node
   */
  public Block getBody() {
    return body;
  }

  SplitNode setBody(LexicalContext lc, Block body) {
    return (this.body == body) ? this : Node.replaceInLexicalContext(lc, this, new SplitNode(this, body, compileUnit));
  }

  @Override
  public Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterSplitNode(this)) ? visitor.leaveSplitNode(setBody(lc, (Block) body.accept(visitor))) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append("<split>(")
      .append(compileUnit.getClass().getSimpleName())
      .append(") ");
    body.toString(sb, printType);
  }

  /**
   * Get the name for this split node
   * @return name
   */
  public String getName() {
    return name;
  }

  /**
   * Get the compile unit for this split node
   * @return compile unit
   */
  @Override
  public CompileUnit getCompileUnit() {
    return compileUnit;
  }

  /**
   * Set the compile unit for this split node
   * @param lc lexical context
   * @param compileUnit compile unit
   * @return new node if changed, otherwise same node
   */
  public SplitNode setCompileUnit(LexicalContext lc, CompileUnit compileUnit) {
    return (this.compileUnit == compileUnit) ? this : Node.replaceInLexicalContext(lc, this, new SplitNode(this, body, compileUnit));
  }

  private void writeObject(ObjectOutputStream out) throws IOException {
    // We are only serializing the AST after we run SplitIntoFunctions;
    // no SplitNodes can remain for the serialization.
    throw new NotSerializableException(getClass().getName());
  }
  private static final long serialVersionUID = 1;
}
