package es.ir;

import java.util.Collections;
import java.util.List;

import es.codegen.Label;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation of CASE clause.
 *
 * Case nodes are not BreakableNodes, but the SwitchNode is
 */
@Immutable
public final class CaseNode extends Node implements JoinPredecessor, Labels, Terminal {

  // Test expression.
  private final Expression test;

  // Statements.
  private final Block body;

  // Case entry label.
  private final Label entry;

  // see JoinPredecessor
  private final LocalVariableConversion conversion;

  /**
   * Constructors
   *
   * @param token    token
   * @param finish   finish
   * @param test     case test node, can be any node in JavaScript
   * @param body     case body
   */
  public CaseNode(long token, int finish, Expression test, Block body) {
    super(token, finish);
    this.test = test;
    this.body = body;
    this.entry = new Label("entry");
    this.conversion = null;
  }

  CaseNode(CaseNode caseNode, Expression test, Block body, LocalVariableConversion conversion) {
    super(caseNode);
    this.test = test;
    this.body = body;
    this.entry = new Label(caseNode.entry);
    this.conversion = conversion;
  }

  /**
   * Is this a terminal case node, i.e. does it end control flow like having a throw or return?
   * @return true if this node statement is terminal
   */
  @Override
  public boolean isTerminal() {
    return body.isTerminal();
  }

  /**
   * Assist in IR navigation.
   * @param visitor IR navigating visitor.
   */
  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterCaseNode(this)) {
      var newTest = test == null ? null : (Expression) test.accept(visitor);
      var newBody = body == null ? null : (Block) body.accept(visitor);
      return visitor.leaveCaseNode(setTest(newTest).setBody(newBody));
    }
    return this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printTypes) {
    if (test != null) {
      sb.append("case ");
      test.toString(sb, printTypes);
      sb.append(':');
    } else {
      sb.append("default:");
    }
  }

  /**
   * Get the body for this case node
   * @return the body
   */
  public Block getBody() {
    return body;
  }

  /**
   * Get the entry label for this case node
   * @return the entry label
   */
  public Label getEntry() {
    return entry;
  }

  /**
   * Get the test expression for this case node
   * @return the test
   */
  public Expression getTest() {
    return test;
  }

  /**
   * Reset the test expression for this case node
   * @param test new test expression
   * @return new or same CaseNode
   */
  public CaseNode setTest(Expression test) {
    return (this.test == test) ? this : new CaseNode(this, test, body, conversion);
  }

  @Override
  public JoinPredecessor setLocalVariableConversion(LexicalContext lc, LocalVariableConversion conversion) {
    return (this.conversion == conversion) ? this : new CaseNode(this, test, body, conversion);
  }

  @Override
  public LocalVariableConversion getLocalVariableConversion() {
    return conversion;
  }

  CaseNode setBody(Block body) {
    return (this.body == body) ? this : new CaseNode(this, test, body, conversion);
  }

  @Override
  public List<Label> getLabels() {
    return Collections.unmodifiableList(Collections.singletonList(entry));
  }

}
