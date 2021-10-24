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
 * Branch optimizer for CodeGenerator.
 * Given a jump condition this helper class attempts to simplify the control flow
 */
final class BranchOptimizer {

  private final CodeGenerator codegen;
  private final MethodEmitter method;

  BranchOptimizer(CodeGenerator codegen, MethodEmitter method) {
    this.codegen = codegen;
    this.method = method;
  }

  void execute(Expression node, Label label, boolean state) {
    branchOptimizer(node, label, state);
  }

  void branchOptimizer(UnaryNode unaryNode, Label label, boolean state) {
    if (unaryNode.isTokenType(NOT)) {
      branchOptimizer(unaryNode.getExpression(), label, !state);
    } else {
      loadTestAndJump(unaryNode, label, state);
    }
  }

  void branchOptimizer(BinaryNode binaryNode, Label label, boolean state) {
    var lhs = binaryNode.lhs();
    var rhs = binaryNode.rhs();
    switch (binaryNode.tokenType()) {
      case AND -> {
        if (state) {
          var skip = new Label("skip");
          optimizeLogicalOperand(lhs, skip, false, false);
          optimizeLogicalOperand(rhs, label, true, true);
          method.label(skip);
        } else {
          optimizeLogicalOperand(lhs, label, false, false);
          optimizeLogicalOperand(rhs, label, false, true);
        }
      }
      case OR -> {
        if (state) {
          optimizeLogicalOperand(lhs, label, true, false);
          optimizeLogicalOperand(rhs, label, true, true);
        } else {
          var skip = new Label("skip");
          optimizeLogicalOperand(lhs, skip, true, false);
          optimizeLogicalOperand(rhs, label, false, true);
          method.label(skip);
        }
      }
      case EQ, EQU -> {
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? EQ : NE, true, label);
      }
      case NE, NEQU -> {
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? NE : EQ, true, label);
      }
      case GE -> {
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? GE : LT, false, label);
      }
      case GT -> {
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? GT : LE, false, label);
      }
      case LE -> {
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? LE : GT, true, label);
      }
      case LT -> {
        codegen.loadComparisonOperands(binaryNode);
        method.conditionalJump(state ? LT : GE, true, label);
      }
      default -> {
        loadTestAndJump(binaryNode, label, state);
      }
    }
  }

  void optimizeLogicalOperand(Expression expr, Label label, boolean state, boolean isRhs) {
    var jpexpr = (JoinPredecessorExpression) expr;
    if (LocalVariableConversion.hasLiveConversion(jpexpr)) {
      var after = new Label("after");
      branchOptimizer(jpexpr.getExpression(), after, !state);
      method.beforeJoinPoint(jpexpr);
      method.goto_(label);
      method.label(after);
      if (isRhs) {
        method.beforeJoinPoint(jpexpr);
      }
    } else {
      branchOptimizer(jpexpr.getExpression(), label, state);
    }
  }

  void branchOptimizer(Expression node, Label label, boolean state) {
    if (node instanceof BinaryNode binaryNode) {
      branchOptimizer(binaryNode, label, state);
    } else if (node instanceof UnaryNode unaryNode) {
      branchOptimizer(unaryNode, label, state);
    } else {
      loadTestAndJump(node, label, state);
    }
  }

  void loadTestAndJump(Expression node, Label label, boolean state) {
    codegen.loadExpressionAsBoolean(node);
    if (state) {
      method.ifne(label);
    } else {
      method.ifeq(label);
    }
  }

}
