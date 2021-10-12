package es.codegen;

import static es.codegen.Condition.EQ;
import static es.codegen.Condition.GE;
import static es.codegen.Condition.GT;
import static es.codegen.Condition.LE;
import static es.codegen.Condition.LT;
import static es.codegen.Condition.NE;
import static es.parser.TokenType.NOT;

import es.ir.BinaryNode;
import es.ir.Expression;
import es.ir.JoinPredecessorExpression;
import es.ir.LocalVariableConversion;
import es.ir.UnaryNode;

/**
 * Branch optimizer for CodeGenerator. Given a jump condition this helper
 * class attempts to simplify the control flow
 */
final class BranchOptimizer {

  private final CodeGenerator codegen;
  private final MethodEmitter method;

  BranchOptimizer(final CodeGenerator codegen, final MethodEmitter method) {
    this.codegen = codegen;
    this.method = method;
  }

  void execute(final Expression node, final Label label, final boolean state) {
    branchOptimizer(node, label, state);
  }

  private void branchOptimizer(final UnaryNode unaryNode, final Label label, final boolean state) {
    if (unaryNode.isTokenType(NOT)) {
      branchOptimizer(unaryNode.getExpression(), label, !state);
    } else {
      loadTestAndJump(unaryNode, label, state);
    }
  }

  private void branchOptimizer(final BinaryNode binaryNode, final Label label, final boolean state) {
    final Expression lhs = binaryNode.lhs();
    final Expression rhs = binaryNode.rhs();

    switch (binaryNode.tokenType()) {
      case AND:
        if (state) {
          final Label skip = new Label("skip");
          optimizeLogicalOperand(lhs, skip, false, false);
          optimizeLogicalOperand(rhs, label, true, true);
          method.label(skip);
        } else {
          optimizeLogicalOperand(lhs, label, false, false);
          optimizeLogicalOperand(rhs, label, false, true);
        }
        return;

      case OR:
        if (state) {
          optimizeLogicalOperand(lhs, label, true, false);
          optimizeLogicalOperand(rhs, label, true, true);
        } else {
          final Label skip = new Label("skip");
          optimizeLogicalOperand(lhs, skip, true, false);
          optimizeLogicalOperand(rhs, label, false, true);
          method.label(skip);
        }
        return;

      case EQ:
      case EQU:
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? EQ : NE, true, label);
        return;

      case NE:
      case NEQU:
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? NE : EQ, true, label);
        return;

      case GE:
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? GE : LT, false, label);
        return;

      case GT:
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? GT : LE, false, label);
        return;

      case LE:
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? LE : GT, true, label);
        return;

      case LT:
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? LT : GE, true, label);
        return;

      default:
        break;
    }

    loadTestAndJump(binaryNode, label, state);
  }

  private void optimizeLogicalOperand(final Expression expr, final Label label, final boolean state, final boolean isRhs) {
    final JoinPredecessorExpression jpexpr = (JoinPredecessorExpression) expr;
    if (LocalVariableConversion.hasLiveConversion(jpexpr)) {
      final Label after = new Label("after");
      branchOptimizer(jpexpr.getExpression(), after, !state);
      method.beforeJoinPoint(jpexpr);
      method._goto(label);
      method.label(after);
      if (isRhs) {
        method.beforeJoinPoint(jpexpr);
      }
    } else {
      branchOptimizer(jpexpr.getExpression(), label, state);
    }
  }

  private void branchOptimizer(final Expression node, final Label label, final boolean state) {
    if (node instanceof BinaryNode) {
      branchOptimizer((BinaryNode) node, label, state);
      return;
    }

    if (node instanceof UnaryNode) {
      branchOptimizer((UnaryNode) node, label, state);
      return;
    }

    loadTestAndJump(node, label, state);
  }

  private void loadTestAndJump(final Expression node, final Label label, final boolean state) {
    codegen.loadExpressionAsBoolean(node);
    if (state) {
      method.ifne(label);
    } else {
      method.ifeq(label);
    }
  }
}
