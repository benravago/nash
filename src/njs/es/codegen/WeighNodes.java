package es.codegen;

import java.util.List;
import java.util.Map;

import es.ir.AccessNode;
import es.ir.BinaryNode;
import es.ir.Block;
import es.ir.BreakNode;
import es.ir.CallNode;
import es.ir.CatchNode;
import es.ir.ContinueNode;
import es.ir.ExpressionStatement;
import es.ir.ForNode;
import es.ir.FunctionNode;
import es.ir.IdentNode;
import es.ir.IfNode;
import es.ir.IndexNode;
import es.ir.JumpToInlinedFinally;
import es.ir.LexicalContext;
import es.ir.LiteralNode;
import es.ir.LiteralNode.ArrayLiteralNode;
import es.ir.Node;
import es.ir.ObjectNode;
import es.ir.PropertyNode;
import es.ir.ReturnNode;
import es.ir.RuntimeNode;
import es.ir.SplitNode;
import es.ir.Splittable;
import es.ir.SwitchNode;
import es.ir.ThrowNode;
import es.ir.TryNode;
import es.ir.UnaryNode;
import es.ir.VarNode;
import es.ir.WhileNode;
import es.ir.WithNode;
import es.ir.visitor.NodeOperatorVisitor;

/**
 * Computes the "byte code" weight of an AST segment.
 * This is used for Splitting too large class files
 */
final class WeighNodes extends NodeOperatorVisitor<LexicalContext> {

  // Weight constants.
  static final long FUNCTION_WEIGHT = 40;
  static final long AASTORE_WEIGHT = 2;
  static final long ACCESS_WEIGHT = 4;
  static final long ADD_WEIGHT = 10;
  static final long BREAK_WEIGHT = 1;
  static final long CALL_WEIGHT = 10;
  static final long CATCH_WEIGHT = 10;
  static final long COMPARE_WEIGHT = 6;
  static final long CONTINUE_WEIGHT = 1;
  static final long IF_WEIGHT = 2;
  static final long LITERAL_WEIGHT = 10;
  static final long LOOP_WEIGHT = 4;
  static final long NEW_WEIGHT = 6;
  static final long FUNC_EXPR_WEIGHT = 20;
  static final long RETURN_WEIGHT = 2;
  static final long SPLIT_WEIGHT = 40;
  static final long SWITCH_WEIGHT = 8;
  static final long THROW_WEIGHT = 2;
  static final long VAR_WEIGHT = 40;
  static final long WITH_WEIGHT = 8;
  static final long OBJECT_WEIGHT = 16;
  static final long SETPROP_WEIGHT = 5;

  // Accumulated weight.
  private long weight;

  // Optional cache for weight of block nodes.
  private final Map<Node, Long> weightCache;

  private final FunctionNode topFunction;

  /**
   * Constructor
   * @param weightCache cache of already calculated block weights
   */
  WeighNodes(FunctionNode topFunction, Map<Node, Long> weightCache) {
    super(new LexicalContext());
    this.topFunction = topFunction;
    this.weightCache = weightCache;
  }

  static long weigh(Node node) {
    return weigh(node, null);
  }

  static long weigh(Node node, Map<Node, Long> weightCache) {
    var weighNodes = new WeighNodes(node instanceof FunctionNode fn ? fn : null, weightCache);
    node.accept(weighNodes);
    return weighNodes.weight;
  }

  @Override
  public Node leaveAccessNode(AccessNode accessNode) {
    weight += ACCESS_WEIGHT;
    return accessNode;
  }

  @Override
  public boolean enterBlock(Block block) {
    if (weightCache != null && weightCache.containsKey(block)) {
      weight += weightCache.get(block);
      return false;
    }
    return true;
  }

  @Override
  public Node leaveBreakNode(BreakNode breakNode) {
    weight += BREAK_WEIGHT;
    return breakNode;
  }

  @Override
  public Node leaveCallNode(CallNode callNode) {
    weight += CALL_WEIGHT;
    return callNode;
  }

  @Override
  public Node leaveCatchNode(CatchNode catchNode) {
    weight += CATCH_WEIGHT;
    return catchNode;
  }

  @Override
  public Node leaveContinueNode(ContinueNode continueNode) {
    weight += CONTINUE_WEIGHT;
    return continueNode;
  }

  @Override
  public Node leaveExpressionStatement(ExpressionStatement expressionStatement) {
    return expressionStatement;
  }

  @Override
  public Node leaveForNode(ForNode forNode) {
    weight += LOOP_WEIGHT;
    return forNode;
  }

  @Override
  public boolean enterFunctionNode(FunctionNode functionNode) {
    if (functionNode == topFunction) {
      // the function being weighted; descend into its statements
      return true;
    }
    // just a reference to inner function from outer function
    weight += FUNC_EXPR_WEIGHT;
    return false;
  }

  @Override
  public Node leaveIdentNode(IdentNode identNode) {
    weight += ACCESS_WEIGHT;
    return identNode;
  }

  @Override
  public Node leaveIfNode(IfNode ifNode) {
    weight += IF_WEIGHT;
    return ifNode;
  }

  @Override
  public Node leaveIndexNode(IndexNode indexNode) {
    weight += ACCESS_WEIGHT;
    return indexNode;
  }

  @Override
  public Node leaveJumpToInlinedFinally(JumpToInlinedFinally jumpToInlinedFinally) {
    weight += BREAK_WEIGHT;
    return jumpToInlinedFinally;
  }

  @SuppressWarnings("rawtypes")
  @Override
  public boolean enterLiteralNode(LiteralNode literalNode) {
    weight += LITERAL_WEIGHT;
    if (literalNode instanceof ArrayLiteralNode arrayLiteralNode) {
      var value = arrayLiteralNode.getValue();
      var postsets = arrayLiteralNode.getPostsets();
      var units = arrayLiteralNode.getSplitRanges();
      if (units == null) {
        for (var postset : postsets) {
          weight += AASTORE_WEIGHT;
          var element = value[postset];
          if (element != null) {
            element.accept(this);
          }
        }
      }
      return false;
    }
    return true;
  }

  @Override
  public boolean enterObjectNode(ObjectNode objectNode) {
    weight += OBJECT_WEIGHT;
    var properties = objectNode.getElements();
    var isSpillObject = properties.size() > CodeGenerator.OBJECT_SPILL_THRESHOLD;
    for (var property : properties) {
      if (!LiteralNode.isConstant(property.getValue())) {
        weight += SETPROP_WEIGHT;
        property.getValue().accept(this);
      } else if (!isSpillObject) {
        // constants in spill object are set via preset spill array, but fields objects need to set constants.
        weight += SETPROP_WEIGHT;
      }
    }
    return false;
  }

  @Override
  public Node leavePropertyNode(PropertyNode propertyNode) {
    weight += LITERAL_WEIGHT;
    return propertyNode;
  }

  @Override
  public Node leaveReturnNode(ReturnNode returnNode) {
    weight += RETURN_WEIGHT;
    return returnNode;
  }

  @Override
  public Node leaveRuntimeNode(RuntimeNode runtimeNode) {
    weight += CALL_WEIGHT;
    return runtimeNode;
  }

  @Override
  public boolean enterSplitNode(SplitNode splitNode) {
    weight += SPLIT_WEIGHT;
    return false;
  }

  @Override
  public Node leaveSwitchNode(SwitchNode switchNode) {
    weight += SWITCH_WEIGHT;
    return switchNode;
  }

  @Override
  public Node leaveThrowNode(ThrowNode throwNode) {
    weight += THROW_WEIGHT;
    return throwNode;
  }

  @Override
  public Node leaveTryNode(TryNode tryNode) {
    weight += THROW_WEIGHT;
    return tryNode;
  }

  @Override
  public Node leaveVarNode(VarNode varNode) {
    weight += VAR_WEIGHT;
    return varNode;
  }

  @Override
  public Node leaveWhileNode(WhileNode whileNode) {
    weight += LOOP_WEIGHT;
    return whileNode;
  }

  @Override
  public Node leaveWithNode(WithNode withNode) {
    weight += WITH_WEIGHT;
    return withNode;
  }

  @Override
  public Node leavePOS(UnaryNode unaryNode) {
    return unaryNodeWeight(unaryNode);
  }

  @Override
  public Node leaveBIT_NOT(UnaryNode unaryNode) {
    return unaryNodeWeight(unaryNode);
  }

  @Override
  public Node leaveDECINC(UnaryNode unaryNode) {
    return unaryNodeWeight(unaryNode);
  }

  @Override
  public Node leaveDELETE(UnaryNode unaryNode) {
    return runtimeNodeWeight(unaryNode);
  }

  @Override
  public Node leaveNEW(UnaryNode unaryNode) {
    weight += NEW_WEIGHT;
    return unaryNode;
  }

  @Override
  public Node leaveNOT(UnaryNode unaryNode) {
    return unaryNodeWeight(unaryNode);
  }

  @Override
  public Node leaveNEG(UnaryNode unaryNode) {
    return unaryNodeWeight(unaryNode);
  }

  @Override
  public Node leaveTYPEOF(UnaryNode unaryNode) {
    return runtimeNodeWeight(unaryNode);
  }

  @Override
  public Node leaveVOID(UnaryNode unaryNode) {
    return unaryNodeWeight(unaryNode);
  }

  @Override
  public Node leaveADD(BinaryNode binaryNode) {
    weight += ADD_WEIGHT;
    return binaryNode;
  }

  @Override
  public Node leaveAND(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN_ADD(BinaryNode binaryNode) {
    weight += ADD_WEIGHT;
    return binaryNode;
  }

  @Override
  public Node leaveASSIGN_BIT_AND(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN_BIT_OR(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN_BIT_XOR(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN_DIV(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN_MOD(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN_MUL(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN_SAR(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN_SHL(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN_SHR(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveASSIGN_SUB(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveARROW(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveBIT_AND(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveBIT_OR(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveBIT_XOR(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveCOMMARIGHT(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveDIV(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveEQ(BinaryNode binaryNode) {
    return compareWeight(binaryNode);
  }

  @Override
  public Node leaveEQUIV(BinaryNode binaryNode) {
    return compareWeight(binaryNode);
  }

  @Override
  public Node leaveGE(BinaryNode binaryNode) {
    return compareWeight(binaryNode);
  }

  @Override
  public Node leaveGT(BinaryNode binaryNode) {
    return compareWeight(binaryNode);
  }

  @Override
  public Node leaveIN(BinaryNode binaryNode) {
    weight += CALL_WEIGHT;
    return binaryNode;
  }

  @Override
  public Node leaveINSTANCEOF(BinaryNode binaryNode) {
    weight += CALL_WEIGHT;
    return binaryNode;
  }

  @Override
  public Node leaveLE(BinaryNode binaryNode) {
    return compareWeight(binaryNode);
  }

  @Override
  public Node leaveLT(BinaryNode binaryNode) {
    return compareWeight(binaryNode);
  }

  @Override
  public Node leaveMOD(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveMUL(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveNE(BinaryNode binaryNode) {
    return compareWeight(binaryNode);
  }

  @Override
  public Node leaveNOT_EQUIV(BinaryNode binaryNode) {
    return compareWeight(binaryNode);
  }

  @Override
  public Node leaveOR(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveSAR(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveSHL(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveSHR(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  @Override
  public Node leaveSUB(BinaryNode binaryNode) {
    return binaryNodeWeight(binaryNode);
  }

  Node unaryNodeWeight(UnaryNode unaryNode) {
    weight += 1;
    return unaryNode;
  }

  Node binaryNodeWeight(BinaryNode binaryNode) {
    weight += 1;
    return binaryNode;
  }

  Node runtimeNodeWeight(UnaryNode unaryNode) {
    weight += CALL_WEIGHT;
    return unaryNode;
  }

  Node compareWeight(BinaryNode binaryNode) {
    weight += COMPARE_WEIGHT;
    return binaryNode;
  }

}
