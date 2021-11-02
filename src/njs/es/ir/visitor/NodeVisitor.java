package es.ir.visitor;

import es.ir.AccessNode;
import es.ir.BinaryNode;
import es.ir.Block;
import es.ir.BlockStatement;
import es.ir.BreakNode;
import es.ir.CallNode;
import es.ir.CaseNode;
import es.ir.CatchNode;
import es.ir.ClassNode;
import es.ir.ContinueNode;
import es.ir.DebuggerNode;
import es.ir.EmptyNode;
import es.ir.ErrorNode;
import es.ir.ExpressionStatement;
import es.ir.ForNode;
import es.ir.FunctionNode;
import es.ir.GetSplitState;
import es.ir.IdentNode;
import es.ir.IfNode;
import es.ir.IndexNode;
import es.ir.JoinPredecessorExpression;
import es.ir.JumpToInlinedFinally;
import es.ir.LabelNode;
import es.ir.LexicalContext;
import es.ir.LiteralNode;
import es.ir.Node;
import es.ir.ObjectNode;
import es.ir.PropertyNode;
import es.ir.ReturnNode;
import es.ir.RuntimeNode;
import es.ir.SetSplitState;
import es.ir.SplitNode;
import es.ir.SplitReturn;
import es.ir.SwitchNode;
import es.ir.TemplateLiteral;
import es.ir.TernaryNode;
import es.ir.ThrowNode;
import es.ir.TryNode;
import es.ir.UnaryNode;
import es.ir.VarNode;
import es.ir.WhileNode;

/**
 * Visitor used to navigate the IR.
 *
 * @param <T> lexical context class used by this visitor
 */
public abstract class NodeVisitor<T extends LexicalContext> {

  // lexical context in use
  protected final T lc;

  /**
   * Constructor
   *
   * @param lc a custom lexical context
   */
  public NodeVisitor(T lc) {
    this.lc = lc;
  }

  /**
   * Get the lexical context of this node visitor
   *
   * @return lexical context
   */
  public T getLexicalContext() {
    return lc;
  }

  /**
   * Override this method to do a double inheritance pattern,
   * e.g. avoid using
   * <p>
   * if (x instanceof NodeTypeA) {
   *    ...
   * } else if (x instanceof NodeTypeB) {
   *    ...
   * } else {
   *    ...
   * }
   * <p>
   * Use a NodeVisitor instead, and this method contents forms the else case.
   *
   * @see NodeVisitor#leaveDefault(Node)
   * @param node the node to visit
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  protected boolean enterDefault(Node node) {
    return true;
  }

  /**
   * Override this method to do a double inheritance pattern,
   * e.g. avoid using
   * <p>
   * if (x instanceof NodeTypeA) {
   *    ...
   * } else if (x instanceof NodeTypeB) {
   *    ...
   * } else {
   *    ...
   * }
   * <p>
   * Use a NodeVisitor instead, and this method contents forms the else case.
   *
   * @see NodeVisitor#enterDefault(Node)
   * @param node the node to visit
   * @return the node
   */
  protected Node leaveDefault(Node node) {
    return node;
  }

  /**
   * Callback for entering an AccessNode
   *
   * @param  accessNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterAccessNode(AccessNode accessNode) {
    return enterDefault(accessNode);
  }

  /**
   * Callback for entering an AccessNode
   *
   * @param  accessNode the node
   * @return processed node, null if traversal should end
   */
  public Node leaveAccessNode(AccessNode accessNode) {
    return leaveDefault(accessNode);
  }

  /**
   * Callback for entering a Block
   *
   * @param  block     the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterBlock(Block block) {
    return enterDefault(block);
  }

  /**
   * Callback for leaving a Block
   *
   * @param  block the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveBlock(Block block) {
    return leaveDefault(block);
  }

  /**
   * Callback for entering a BinaryNode
   *
   * @param  binaryNode  the node
   * @return processed   node
   */
  public boolean enterBinaryNode(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Callback for leaving a BinaryNode
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveBinaryNode(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Callback for entering a BreakNode
   *
   * @param  breakNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterBreakNode(BreakNode breakNode) {
    return enterDefault(breakNode);
  }

  /**
   * Callback for leaving a BreakNode
   *
   * @param  breakNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveBreakNode(BreakNode breakNode) {
    return leaveDefault(breakNode);
  }

  /**
   * Callback for entering a CallNode
   *
   * @param  callNode  the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterCallNode(CallNode callNode) {
    return enterDefault(callNode);
  }

  /**
   * Callback for leaving a CallNode
   *
   * @param  callNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveCallNode(CallNode callNode) {
    return leaveDefault(callNode);
  }

  /**
   * Callback for entering a CaseNode
   *
   * @param  caseNode  the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterCaseNode(CaseNode caseNode) {
    return enterDefault(caseNode);
  }

  /**
   * Callback for leaving a CaseNode
   *
   * @param  caseNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveCaseNode(CaseNode caseNode) {
    return leaveDefault(caseNode);
  }

  /**
   * Callback for entering a CatchNode
   *
   * @param  catchNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterCatchNode(CatchNode catchNode) {
    return enterDefault(catchNode);
  }

  /**
   * Callback for leaving a CatchNode
   *
   * @param  catchNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveCatchNode(CatchNode catchNode) {
    return leaveDefault(catchNode);
  }

  /**
   * Callback for entering a ContinueNode
   *
   * @param  continueNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterContinueNode(ContinueNode continueNode) {
    return enterDefault(continueNode);
  }

  /**
   * Callback for leaving a ContinueNode
   *
   * @param  continueNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveContinueNode(ContinueNode continueNode) {
    return leaveDefault(continueNode);
  }

  /**
   * Callback for entering a DebuggerNode
   *
   * @param  debuggerNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterDebuggerNode(DebuggerNode debuggerNode) {
    return enterDefault(debuggerNode);
  }

  /**
   * Callback for leaving a DebuggerNode
   *
   * @param  debuggerNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveDebuggerNode(DebuggerNode debuggerNode) {
    return leaveDefault(debuggerNode);
  }

  /**
   * Callback for entering an EmptyNode
   *
   * @param  emptyNode   the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterEmptyNode(EmptyNode emptyNode) {
    return enterDefault(emptyNode);
  }

  /**
   * Callback for leaving an EmptyNode
   *
   * @param  emptyNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveEmptyNode(EmptyNode emptyNode) {
    return leaveDefault(emptyNode);
  }

  /**
   * Callback for entering an ErrorNode
   *
   * @param  errorNode   the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterErrorNode(ErrorNode errorNode) {
    return enterDefault(errorNode);
  }

  /**
   * Callback for leaving an ErrorNode
   *
   * @param  errorNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveErrorNode(ErrorNode errorNode) {
    return leaveDefault(errorNode);
  }

  /**
   * Callback for entering an ExpressionStatement
   *
   * @param  expressionStatement the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterExpressionStatement(ExpressionStatement expressionStatement) {
    return enterDefault(expressionStatement);
  }

  /**
   * Callback for leaving an ExpressionStatement
   *
   * @param  expressionStatement the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveExpressionStatement(ExpressionStatement expressionStatement) {
    return leaveDefault(expressionStatement);
  }

  /**
   * Callback for entering a BlockStatement
   *
   * @param  blockStatement the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterBlockStatement(BlockStatement blockStatement) {
    return enterDefault(blockStatement);
  }

  /**
   * Callback for leaving a BlockStatement
   *
   * @param  blockStatement the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveBlockStatement(BlockStatement blockStatement) {
    return leaveDefault(blockStatement);
  }

  /**
   * Callback for entering a ForNode
   *
   * @param  forNode   the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterForNode(ForNode forNode) {
    return enterDefault(forNode);
  }

  /**
   * Callback for leaving a ForNode
   *
   * @param  forNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveForNode(ForNode forNode) {
    return leaveDefault(forNode);
  }

  /**
   * Callback for entering a FunctionNode
   *
   * @param  functionNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterFunctionNode(FunctionNode functionNode) {
    return enterDefault(functionNode);
  }

  /**
   * Callback for leaving a FunctionNode
   *
   * @param  functionNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveFunctionNode(FunctionNode functionNode) {
    return leaveDefault(functionNode);
  }

  /**
   * Callback for entering a {@link GetSplitState}.
   *
   * @param  getSplitState the get split state expression
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterGetSplitState(GetSplitState getSplitState) {
    return enterDefault(getSplitState);
  }

  /**
   * Callback for leaving a {@link GetSplitState}.
   *
   * @param  getSplitState the get split state expression
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveGetSplitState(GetSplitState getSplitState) {
    return leaveDefault(getSplitState);
  }

  /**
   * Callback for entering an IdentNode
   *
   * @param  identNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterIdentNode(IdentNode identNode) {
    return enterDefault(identNode);
  }

  /**
   * Callback for leaving an IdentNode
   *
   * @param  identNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveIdentNode(IdentNode identNode) {
    return leaveDefault(identNode);
  }

  /**
   * Callback for entering an IfNode
   *
   * @param  ifNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterIfNode(IfNode ifNode) {
    return enterDefault(ifNode);
  }

  /**
   * Callback for leaving an IfNode
   *
   * @param  ifNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveIfNode(IfNode ifNode) {
    return leaveDefault(ifNode);
  }

  /**
   * Callback for entering an IndexNode
   *
   * @param  indexNode  the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterIndexNode(IndexNode indexNode) {
    return enterDefault(indexNode);
  }

  /**
   * Callback for leaving an IndexNode
   *
   * @param  indexNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveIndexNode(IndexNode indexNode) {
    return leaveDefault(indexNode);
  }

  /**
   * Callback for entering a JumpToInlinedFinally
   *
   * @param  jumpToInlinedFinally the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterJumpToInlinedFinally(JumpToInlinedFinally jumpToInlinedFinally) {
    return enterDefault(jumpToInlinedFinally);
  }

  /**
   * Callback for leaving a JumpToInlinedFinally
   *
   * @param  jumpToInlinedFinally the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveJumpToInlinedFinally(JumpToInlinedFinally jumpToInlinedFinally) {
    return leaveDefault(jumpToInlinedFinally);
  }

  /**
   * Callback for entering a LabelNode
   *
   * @param  labelNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterLabelNode(LabelNode labelNode) {
    return enterDefault(labelNode);
  }

  /**
   * Callback for leaving a LabelNode
   *
   * @param  labelNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveLabelNode(LabelNode labelNode) {
    return leaveDefault(labelNode);
  }

  /**
   * Callback for entering a LiteralNode
   *
   * @param  literalNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterLiteralNode(LiteralNode<?> literalNode) {
    return enterDefault(literalNode);
  }

  /**
   * Callback for leaving a LiteralNode
   *
   * @param  literalNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveLiteralNode(LiteralNode<?> literalNode) {
    return leaveDefault(literalNode);
  }

  /**
   * Callback for entering an ObjectNode
   *
   * @param  objectNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterObjectNode(ObjectNode objectNode) {
    return enterDefault(objectNode);
  }

  /**
   * Callback for leaving an ObjectNode
   *
   * @param  objectNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveObjectNode(ObjectNode objectNode) {
    return leaveDefault(objectNode);
  }

  /**
   * Callback for entering a PropertyNode
   *
   * @param  propertyNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterPropertyNode(PropertyNode propertyNode) {
    return enterDefault(propertyNode);
  }

  /**
   * Callback for leaving a PropertyNode
   *
   * @param  propertyNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leavePropertyNode(PropertyNode propertyNode) {
    return leaveDefault(propertyNode);
  }

  /**
   * Callback for entering a ReturnNode
   *
   * @param  returnNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterReturnNode(ReturnNode returnNode) {
    return enterDefault(returnNode);
  }

  /**
   * Callback for leaving a ReturnNode
   *
   * @param  returnNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveReturnNode(ReturnNode returnNode) {
    return leaveDefault(returnNode);
  }

  /**
   * Callback for entering a RuntimeNode
   *
   * @param  runtimeNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterRuntimeNode(RuntimeNode runtimeNode) {
    return enterDefault(runtimeNode);
  }

  /**
   * Callback for leaving a RuntimeNode
   *
   * @param  runtimeNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveRuntimeNode(RuntimeNode runtimeNode) {
    return leaveDefault(runtimeNode);
  }

  /**
   * Callback for entering a {@link SetSplitState}.
   *
   * @param  setSplitState the set split state statement
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterSetSplitState(SetSplitState setSplitState) {
    return enterDefault(setSplitState);
  }

  /**
   * Callback for leaving a {@link SetSplitState}.
   *
   * @param  setSplitState the set split state expression
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveSetSplitState(SetSplitState setSplitState) {
    return leaveDefault(setSplitState);
  }

  /**
   * Callback for entering a SplitNode
   *
   * @param  splitNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterSplitNode(SplitNode splitNode) {
    return enterDefault(splitNode);
  }

  /**
   * Callback for leaving a SplitNode
   *
   * @param  splitNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveSplitNode(SplitNode splitNode) {
    return leaveDefault(splitNode);
  }

  /**
   * Callback for entering a SplitReturn
   *
   * @param  splitReturn the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterSplitReturn(SplitReturn splitReturn) {
    return enterDefault(splitReturn);
  }

  /**
   * Callback for leaving a SplitReturn
   *
   * @param  splitReturn the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveSplitReturn(SplitReturn splitReturn) {
    return leaveDefault(splitReturn);
  }

  /**
   * Callback for entering a SwitchNode
   *
   * @param  switchNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterSwitchNode(SwitchNode switchNode) {
    return enterDefault(switchNode);
  }

  /**
   * Callback for leaving a SwitchNode
   *
   * @param  switchNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveSwitchNode(SwitchNode switchNode) {
    return leaveDefault(switchNode);
  }

  /**
   * Callback for entering a TemplateLiteral (used only in --parse-only mode)
   *
   * @param  templateLiteral the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterTemplateLiteral(TemplateLiteral templateLiteral) {
    return enterDefault(templateLiteral);
  }

  /**
   * Callback for leaving a TemplateLiteral (used only in --parse-only mode)
   *
   * @param  templateLiteral the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveTemplateLiteral(TemplateLiteral templateLiteral) {
    return leaveDefault(templateLiteral);
  }

  /**
   * Callback for entering a TernaryNode
   *
   * @param  ternaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterTernaryNode(TernaryNode ternaryNode) {
    return enterDefault(ternaryNode);
  }

  /**
   * Callback for leaving a TernaryNode
   *
   * @param  ternaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveTernaryNode(TernaryNode ternaryNode) {
    return leaveDefault(ternaryNode);
  }

  /**
   * Callback for entering a ThrowNode
   *
   * @param  throwNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterThrowNode(ThrowNode throwNode) {
    return enterDefault(throwNode);
  }

  /**
   * Callback for leaving a ThrowNode
   *
   * @param  throwNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveThrowNode(ThrowNode throwNode) {
    return leaveDefault(throwNode);
  }

  /**
   * Callback for entering a TryNode
   *
   * @param  tryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterTryNode(TryNode tryNode) {
    return enterDefault(tryNode);
  }

  /**
   * Callback for leaving a TryNode
   *
   * @param  tryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveTryNode(TryNode tryNode) {
    return leaveDefault(tryNode);
  }

  /**
   * Callback for entering a UnaryNode
   *
   * @param  unaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterUnaryNode(UnaryNode unaryNode) {
    return enterDefault(unaryNode);
  }

  /**
   * Callback for leaving a UnaryNode
   *
   * @param  unaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveUnaryNode(UnaryNode unaryNode) {
    return leaveDefault(unaryNode);
  }

  /**
   * Callback for entering a {@link JoinPredecessorExpression}.
   *
   * @param  expr the join predecessor expression
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterJoinPredecessorExpression(JoinPredecessorExpression expr) {
    return enterDefault(expr);
  }

  /**
   * Callback for leaving a {@link JoinPredecessorExpression}.
   *
   * @param  expr the join predecessor expression
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveJoinPredecessorExpression(JoinPredecessorExpression expr) {
    return leaveDefault(expr);
  }

  /**
   * Callback for entering a VarNode
   *
   * @param  varNode   the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterVarNode(VarNode varNode) {
    return enterDefault(varNode);
  }

  /**
   * Callback for leaving a VarNode
   *
   * @param  varNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveVarNode(VarNode varNode) {
    return leaveDefault(varNode);
  }

  /**
   * Callback for entering a WhileNode
   *
   * @param  whileNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterWhileNode(WhileNode whileNode) {
    return enterDefault(whileNode);
  }

  /**
   * Callback for leaving a WhileNode
   *
   * @param  whileNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveWhileNode(WhileNode whileNode) {
    return leaveDefault(whileNode);
  }

  /**
   * Callback for entering a ClassNode
   *
   * @param  classNode  the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterClassNode(ClassNode classNode) {
    return enterDefault(classNode);
  }

  /**
   * Callback for leaving a ClassNode
   *
   * @param  classNode  the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveClassNode(ClassNode classNode) {
    return leaveDefault(classNode);
  }

}
