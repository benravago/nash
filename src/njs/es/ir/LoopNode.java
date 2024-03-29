package es.ir;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import es.codegen.Label;

/**
 * A loop node, for example a while node, do while node or for node
 */
public abstract class LoopNode extends BreakableStatement {

  // loop continue label.
  protected final Label continueLabel;

  // Loop test node, null if infinite
  protected final JoinPredecessorExpression test;

  // Loop body
  protected final Block body;

  // Can control flow escape from loop, e.g. through breaks or continues to outer loops?
  protected final boolean controlFlowEscapes;

  /**
   * Constructor
   *
   * @param lineNumber         lineNumber
   * @param token              token
   * @param finish             finish
   * @param body               loop body
   * @param test               test
   * @param controlFlowEscapes controlFlowEscapes
   */
  protected LoopNode(int lineNumber, long token, int finish, Block body, JoinPredecessorExpression test, boolean controlFlowEscapes) {
    super(lineNumber, token, finish, new Label("while_break"));
    this.continueLabel = new Label("while_continue");
    this.body = body;
    this.controlFlowEscapes = controlFlowEscapes;
    this.test = test;
  }

  /**
   * Constructor
   *
   * @param loopNode loop node
   * @param test     new test
   * @param body     new body
   * @param controlFlowEscapes controlFlowEscapes
   * @param conversion the local variable conversion carried by this loop node.
   */
  protected LoopNode(LoopNode loopNode, JoinPredecessorExpression test, Block body, boolean controlFlowEscapes, LocalVariableConversion conversion) {
    super(loopNode, conversion);
    this.continueLabel = new Label(loopNode.continueLabel);
    this.test = test;
    this.body = body;
    this.controlFlowEscapes = controlFlowEscapes;
  }

  @Override
  public abstract Node ensureUniqueLabels(LexicalContext lc);

  /**
   * Does the control flow escape from this loop, i.e. through breaks or continues to outer loops?
   * @return true if control flow escapes
   */
  public boolean controlFlowEscapes() {
    return controlFlowEscapes;
  }

  @Override
  public boolean isTerminal() {
    if (!mustEnter()) {
      return false;
    }
    // must enter but control flow may escape - then not terminal
    if (controlFlowEscapes) {
      return false;
    }
    // must enter, but body ends with return - then terminal
    if (body.isTerminal()) {
      return true;
    }
    // no breaks or returns, it is still terminal if we can never exit
    return test == null;
  }

  /**
   * Conservative check: does this loop have to be entered?
   * @return true if body will execute at least once
   */
  public abstract boolean mustEnter();

  /**
   * Get the continue label for this while node, i.e. location to go to on continue
   * @return continue label
   */
  public Label getContinueLabel() {
    return continueLabel;
  }

  @Override
  public List<Label> getLabels() {
    return Collections.unmodifiableList(Arrays.asList(breakLabel, continueLabel));
  }

  @Override
  public boolean isLoop() {
    return true;
  }

  /**
   * Get the body for this for node
   * @return the body
   */
  public abstract Block getBody();

  /**
   * @param lc   lexical context
   * @param body new body
   * @return new for node if changed or existing if not
   */
  public abstract LoopNode setBody(LexicalContext lc, Block body);

  /**
   * Get the test for this for node
   * @return the test
   */
  public final JoinPredecessorExpression getTest() {
    return test;
  }

  /**
   * Set the test for this for node
   * @param lc lexical context
   * @param test new test
   * @return same or new node depending on if test was changed
   */
  public abstract LoopNode setTest(LexicalContext lc, JoinPredecessorExpression test);

  /**
   * Set the control flow escapes flag for this node.
   * TODO  - integrate this with Lowering in a better way
   * @param lc lexical context
   * @param controlFlowEscapes control flow escapes value
   * @return new loop node if changed otherwise the same
   */
  public abstract LoopNode setControlFlowEscapes(LexicalContext lc, boolean controlFlowEscapes);

  /**
   * Does this loop have a LET declaration and hence require a per-iteration scope?
   * @return true if a per-iteration scope is required.
   */
  public abstract boolean hasPerIterationScope();

  private static final long serialVersionUID = 1;
}
