package es.codegen;

import static es.runtime.UnwarrantedOptimismException.isValid;

import java.util.ArrayDeque;
import java.util.BitSet;
import java.util.Deque;
import es.ir.AccessNode;
import es.ir.BinaryNode;
import es.ir.CallNode;
import es.ir.CatchNode;
import es.ir.Expression;
import es.ir.ExpressionStatement;
import es.ir.ForNode;
import es.ir.FunctionNode;
import es.ir.IdentNode;
import es.ir.IfNode;
import es.ir.IndexNode;
import es.ir.JoinPredecessorExpression;
import es.ir.LiteralNode;
import es.ir.LoopNode;
import es.ir.Node;
import es.ir.ObjectNode;
import es.ir.Optimistic;
import es.ir.PropertyNode;
import es.ir.Symbol;
import es.ir.TernaryNode;
import es.ir.UnaryNode;
import es.ir.VarNode;
import es.ir.WhileNode;
import es.ir.visitor.SimpleNodeVisitor;
import es.parser.TokenType;
import es.runtime.ScriptObject;

/**
 * Assigns optimistic types to expressions that can have them. This class mainly contains logic for which expressions
 * must not ever be marked as optimistic, assigning narrowest non-invalidated types to program points from the
 * compilation environment, as well as initializing optimistic types of global properties for scripts.
 */
final class OptimisticTypesCalculator extends SimpleNodeVisitor {

  final Compiler compiler;

  // Per-function bit set of program points that must never be optimistic.
  final Deque<BitSet> neverOptimistic = new ArrayDeque<>();

  OptimisticTypesCalculator(final Compiler compiler) {
    this.compiler = compiler;
  }

  @Override
  public boolean enterAccessNode(final AccessNode accessNode) {
    tagNeverOptimistic(accessNode.getBase());
    return true;
  }

  @Override
  public boolean enterPropertyNode(final PropertyNode propertyNode) {
    if (ScriptObject.PROTO_PROPERTY_NAME.equals(propertyNode.getKeyName())) {
      tagNeverOptimistic(propertyNode.getValue());
    }
    return super.enterPropertyNode(propertyNode);
  }

  @Override
  public boolean enterBinaryNode(final BinaryNode binaryNode) {
    if (binaryNode.isAssignment()) {
      final Expression lhs = binaryNode.lhs();
      if (!binaryNode.isSelfModifying()) {
        tagNeverOptimistic(lhs);
      }
      if (lhs instanceof IdentNode) {
        final Symbol symbol = ((IdentNode) lhs).getSymbol();
        // Assignment to internal symbols is never optimistic, except for self-assignment expressions
        if (symbol.isInternal() && !binaryNode.rhs().isSelfModifying()) {
          tagNeverOptimistic(binaryNode.rhs());
        }
      }
    } else if (binaryNode.isTokenType(TokenType.INSTANCEOF)
            || binaryNode.isTokenType(TokenType.EQU)
            || binaryNode.isTokenType(TokenType.NEQU)) {
      tagNeverOptimistic(binaryNode.lhs());
      tagNeverOptimistic(binaryNode.rhs());
    }
    return true;
  }

  @Override
  public boolean enterCallNode(final CallNode callNode) {
    tagNeverOptimistic(callNode.getFunction());
    return true;
  }

  @Override
  public boolean enterCatchNode(final CatchNode catchNode) {
    // Condition is never optimistic (always coerced to boolean).
    tagNeverOptimistic(catchNode.getExceptionCondition());
    return true;
  }

  @Override
  public boolean enterExpressionStatement(final ExpressionStatement expressionStatement) {
    final Expression expr = expressionStatement.getExpression();
    if (!expr.isSelfModifying()) {
      tagNeverOptimistic(expr);
    }
    return true;
  }

  @Override
  public boolean enterForNode(final ForNode forNode) {
    if (forNode.isForInOrOf()) {
      // for..in has the iterable in its "modify"
      tagNeverOptimistic(forNode.getModify());
    } else {
      // Test is never optimistic (always coerced to boolean).
      tagNeverOptimisticLoopTest(forNode);
    }
    return true;
  }

  @Override
  public boolean enterFunctionNode(final FunctionNode functionNode) {
    if (!neverOptimistic.isEmpty() && compiler.isOnDemandCompilation()) {
      // This is a nested function, and we're doing on-demand compilation. In these compilations, we never descend
      // into nested functions.
      return false;
    }
    neverOptimistic.push(new BitSet());
    return true;
  }

  @Override
  public boolean enterIfNode(final IfNode ifNode) {
    // Test is never optimistic (always coerced to boolean).
    tagNeverOptimistic(ifNode.getTest());
    return true;
  }

  @Override
  public boolean enterIndexNode(final IndexNode indexNode) {
    tagNeverOptimistic(indexNode.getBase());
    return true;
  }

  @Override
  public boolean enterTernaryNode(final TernaryNode ternaryNode) {
    // Test is never optimistic (always coerced to boolean).
    tagNeverOptimistic(ternaryNode.getTest());
    return true;
  }

  @Override
  public boolean enterUnaryNode(final UnaryNode unaryNode) {
    if (unaryNode.isTokenType(TokenType.NOT) || unaryNode.isTokenType(TokenType.NEW)) {
      // Operand of boolean negation is never optimistic (always coerced to boolean).
      // Operand of "new" is never optimistic (always coerced to Object).
      tagNeverOptimistic(unaryNode.getExpression());
    }
    return true;
  }

  @Override
  public boolean enterVarNode(final VarNode varNode) {
    tagNeverOptimistic(varNode.getName());
    return true;
  }

  @Override
  public boolean enterObjectNode(ObjectNode objectNode) {
    if (objectNode.getSplitRanges() != null) {
      return false;
    }
    return super.enterObjectNode(objectNode);
  }

  @Override
  public boolean enterLiteralNode(LiteralNode<?> literalNode) {
    if (literalNode.isArray() && ((LiteralNode.ArrayLiteralNode) literalNode).getSplitRanges() != null) {
      return false;
    }

    return super.enterLiteralNode(literalNode);
  }

  @Override
  public boolean enterWhileNode(final WhileNode whileNode) {
    // Test is never optimistic (always coerced to boolean).
    tagNeverOptimisticLoopTest(whileNode);
    return true;
  }

  @Override
  protected Node leaveDefault(final Node node) {
    if (node instanceof Optimistic) {
      return leaveOptimistic((Optimistic) node);
    }
    return node;
  }

  @Override
  public Node leaveFunctionNode(final FunctionNode functionNode) {
    neverOptimistic.pop();
    return functionNode;
  }

  @Override
  public Node leaveIdentNode(final IdentNode identNode) {
    final Symbol symbol = identNode.getSymbol();
    if (symbol == null) {
      assert identNode.isPropertyName();
      return identNode;
    } else if (symbol.isBytecodeLocal()) {
      // Identifiers accessing bytecode local variables will never be optimistic, as type calculation phase over
      // them will always assign them statically provable types. Note that access to function parameters can still
      // be optimistic if the parameter needs to be in scope as it's used by a nested function.
      return identNode;
    } else if (symbol.isParam() && lc.getCurrentFunction().isVarArg()) {
      // Parameters in vararg methods are not optimistic; we always access them using Object getters.
      return identNode.setType(identNode.getMostPessimisticType());
    } else {
      assert symbol.isScope();
      return leaveOptimistic(identNode);
    }
  }

  private Expression leaveOptimistic(final Optimistic opt) {
    final int pp = opt.getProgramPoint();
    if (isValid(pp) && !neverOptimistic.peek().get(pp)) {
      return (Expression) opt.setType(compiler.getOptimisticType(opt));
    }
    return (Expression) opt;
  }

  private void tagNeverOptimistic(final Expression expr) {
    if (expr instanceof Optimistic) {
      final int pp = ((Optimistic) expr).getProgramPoint();
      if (isValid(pp)) {
        neverOptimistic.peek().set(pp);
      }
    }
  }

  private void tagNeverOptimisticLoopTest(final LoopNode loopNode) {
    final JoinPredecessorExpression test = loopNode.getTest();
    if (test != null) {
      tagNeverOptimistic(test.getExpression());
    }
  }
}
