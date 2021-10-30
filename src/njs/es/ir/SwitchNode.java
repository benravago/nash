package es.ir;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import es.codegen.Label;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;

/**
 * IR representation of a SWITCH statement.
 */
@Immutable
public final class SwitchNode extends BreakableStatement {

  // Switch expression.
  private final Expression expression;

  // Switch cases.
  private final List<CaseNode> cases;

  // Switch default index.
  private final int defaultCaseIndex;

  // True if all cases are 32-bit signed integer constants, without repetitions.
  // It's a prerequisite for   * using a tableswitch/lookupswitch when generating code.
  private final boolean uniqueInteger;

  // Tag symbol.
  private final Symbol tag;

  /**
   * Constructor
   *
   * @param lineNumber  lineNumber
   * @param token       token
   * @param finish      finish
   * @param expression  switch expression
   * @param cases       cases
   * @param defaultCase the default case node - null if none, otherwise has to be present in cases list
   */
  public SwitchNode(int lineNumber, long token, int finish, Expression expression, List<CaseNode> cases, CaseNode defaultCase) {
    super(lineNumber, token, finish, new Label("switch_break"));
    this.expression = expression;
    this.cases = cases;
    this.defaultCaseIndex = defaultCase == null ? -1 : cases.indexOf(defaultCase);
    this.uniqueInteger = false;
    this.tag = null;
  }

  SwitchNode(SwitchNode switchNode, Expression expression, List<CaseNode> cases, int defaultCaseIndex, LocalVariableConversion conversion, boolean uniqueInteger, Symbol tag) {
    super(switchNode, conversion);
    this.expression = expression;
    this.cases = cases;
    this.defaultCaseIndex = defaultCaseIndex;
    this.tag = tag;
    this.uniqueInteger = uniqueInteger;
  }

  @Override
  public Node ensureUniqueLabels(LexicalContext lc) {
    var newCases = new ArrayList<CaseNode>();
    for (var caseNode : cases) {
      newCases.add(new CaseNode(caseNode, caseNode.getTest(), caseNode.getBody(), caseNode.getLocalVariableConversion()));
    }
    return Node.replaceInLexicalContext(lc, this, new SwitchNode(this, expression, newCases, defaultCaseIndex, conversion, uniqueInteger, tag));
  }

  @Override
  public boolean isTerminal() {
    //there must be a default case, and that including all other cases must terminate
    if (!cases.isEmpty() && defaultCaseIndex != -1) {
      for (var caseNode : cases) {
        if (!caseNode.isTerminal()) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  @Override
  public Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterSwitchNode(this)) ?
      visitor.leaveSwitchNode(
        setExpression(lc, (Expression) expression.accept(visitor))
        .setCases(lc, Node.accept(visitor, cases), defaultCaseIndex)) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    sb.append("switch (");
    expression.toString(sb, printType);
    sb.append(')');
  }

  /**
   * Return the case node that is default case
   * @return default case or null if none
   */
  public CaseNode getDefaultCase() {
    return defaultCaseIndex == -1 ? null : cases.get(defaultCaseIndex);
  }

  /**
   * Get the cases in this switch
   * @return a list of case nodes
   */
  public List<CaseNode> getCases() {
    return Collections.unmodifiableList(cases);
  }

  /**
   * Replace case nodes with new list.
   * The cases have to be the same and the default case index the same.
   * This is typically used by NodeVisitors who perform operations on every case node
   * @param lc    lexical context
   * @param cases list of cases
   * @return new switch node or same if no state was changed
   */
  public SwitchNode setCases(LexicalContext lc, List<CaseNode> cases) {
    return setCases(lc, cases, defaultCaseIndex);
  }

  SwitchNode setCases(LexicalContext lc, List<CaseNode> cases, int defaultCaseIndex) {
    return (this.cases == cases) ? this : Node.replaceInLexicalContext(lc, this, new SwitchNode(this, expression, cases, defaultCaseIndex, conversion, uniqueInteger, tag));
  }

  /**
   * Set or reset the list of cases in this switch
   * @param lc lexical context
   * @param cases a list of cases, case nodes
   * @param defaultCase a case in the list that is the default - must be in the list or class will assert
   * @return new switch node or same if no state was changed
   */
  public SwitchNode setCases(LexicalContext lc, List<CaseNode> cases, CaseNode defaultCase) {
    return setCases(lc, cases, defaultCase == null ? -1 : cases.indexOf(defaultCase));
  }

  /**
   * Return the expression to switch on
   * @return switch expression
   */
  public Expression getExpression() {
    return expression;
  }

  /**
   * Set or reset the expression to switch on
   * @param lc lexical context
   * @param expression switch expression
   * @return new switch node or same if no state was changed
   */
  public SwitchNode setExpression(LexicalContext lc, Expression expression) {
    return (this.expression == expression) ? this : Node.replaceInLexicalContext(lc, this, new SwitchNode(this, expression, cases, defaultCaseIndex, conversion, uniqueInteger, tag));
  }

  /**
   * Get the tag symbol for this switch.
   * The tag symbol is where the switch expression result is stored
   * @return tag symbol
   */
  public Symbol getTag() {
    return tag;
  }

  /**
   * Set the tag symbol for this switch.
   * The tag symbol is where the switch expression result is stored
   * @param lc lexical context
   * @param tag a symbol
   * @return a switch node with the symbol set
   */
  public SwitchNode setTag(LexicalContext lc, Symbol tag) {
    return (this.tag == tag) ? this : Node.replaceInLexicalContext(lc, this, new SwitchNode(this, expression, cases, defaultCaseIndex, conversion, uniqueInteger, tag));
  }

  /**
   * Returns true if all cases of this switch statement are 32-bit signed integer constants, without repetitions.
   * @return true if all cases of this switch statement are 32-bit signed integer constants, without repetitions.
   */
  public boolean isUniqueInteger() {
    return uniqueInteger;
  }

  /**
   * Sets whether all cases of this switch statement are 32-bit signed integer constants, without repetitions.
   * @param lc lexical context
   * @param uniqueInteger if true, all cases of this switch statement have been determined to be 32-bit signed integer constants, without repetitions.
   * @return this switch node, if the value didn't change, or a new switch node with the changed value
   */
  public SwitchNode setUniqueInteger(LexicalContext lc, boolean uniqueInteger) {
    return (this.uniqueInteger == uniqueInteger) ? this : Node.replaceInLexicalContext(lc, this, new SwitchNode(this, expression, cases, defaultCaseIndex, conversion, uniqueInteger, tag));
  }

  @Override
  JoinPredecessor setLocalVariableConversionChanged(LexicalContext lc, LocalVariableConversion conversion) {
    return Node.replaceInLexicalContext(lc, this, new SwitchNode(this, expression, cases, defaultCaseIndex, conversion, uniqueInteger, tag));
  }

  private static final long serialVersionUID = 1;
}
