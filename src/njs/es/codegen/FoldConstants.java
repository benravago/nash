package es.codegen;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import es.codegen.types.Type;
import es.ir.BinaryNode;
import es.ir.BlockStatement;
import es.ir.EmptyNode;
import es.ir.Expression;
import es.ir.FunctionNode;
import es.ir.IfNode;
import es.ir.LiteralNode;
import es.ir.LiteralNode.ArrayLiteralNode;
import es.ir.Node;
import es.ir.Statement;
import es.ir.SwitchNode;
import es.ir.TernaryNode;
import es.ir.UnaryNode;
import es.ir.VarNode;
import es.ir.visitor.SimpleNodeVisitor;
import es.runtime.Context;
import es.runtime.JSType;
import es.runtime.ScriptRuntime;
import es.runtime.logging.DebugLogger;
import es.runtime.logging.Loggable;
import es.runtime.logging.Logger;

/**
 * Simple constant folding pass, executed before IR is starting to be lowered.
 */
@Logger(name = "fold")
final class FoldConstants extends SimpleNodeVisitor implements Loggable {

  private final DebugLogger log;

  FoldConstants(Compiler compiler) {
    this.log = initLogger(compiler.getContext());
  }

  @Override
  public DebugLogger getLogger() {
    return log;
  }

  @Override
  public DebugLogger initLogger(Context context) {
    return context.getLogger(this.getClass());
  }

  @Override
  public Node leaveUnaryNode(UnaryNode unaryNode) {
    var literalNode = new UnaryNodeConstantEvaluator(unaryNode).eval();
    if (literalNode != null) {
      log.info("Unary constant folded ", unaryNode, " to ", literalNode);
      return literalNode;
    }
    return unaryNode;
  }

  @Override
  public Node leaveBinaryNode(BinaryNode binaryNode) {
    var literalNode = new BinaryNodeConstantEvaluator(binaryNode).eval();
    if (literalNode != null) {
      log.info("Binary constant folded ", binaryNode, " to ", literalNode);
      return literalNode;
    }
    return binaryNode;
  }

  @Override
  public Node leaveFunctionNode(FunctionNode functionNode) {
    return functionNode;
  }

  @Override
  public Node leaveIfNode(IfNode ifNode) {
    var test = ifNode.getTest();
    if (test instanceof LiteralNode.PrimitiveLiteralNode n) {
      var isTrue = n.isTrue();
      var executed = isTrue ? ifNode.getPass() : ifNode.getFail();
      var dropped = isTrue ? ifNode.getFail() : ifNode.getPass();
      var statements = new ArrayList<Statement>();
      if (executed != null) {
        statements.addAll(executed.getStatements()); // Get statements form executed branch
      }
      if (dropped != null) {
        extractVarNodesFromDeadCode(dropped, statements); // Get var-nodes from non-executed branch
      }
      if (statements.isEmpty()) {
        return new EmptyNode(ifNode);
      }
      return BlockStatement.createReplacement(ifNode, ifNode.getFinish(), statements);
    }
    return ifNode;
  }

  @Override
  public Node leaveTernaryNode(TernaryNode ternaryNode) {
    var test = ternaryNode.getTest();
    if (test instanceof LiteralNode.PrimitiveLiteralNode<?> n) {
      return (n.isTrue() ? ternaryNode.getTrueExpression() : ternaryNode.getFalseExpression()).getExpression();
    }
    return ternaryNode;
  }

  @Override
  public Node leaveSwitchNode(SwitchNode switchNode) {
    return switchNode.setUniqueInteger(lc, isUniqueIntegerSwitchNode(switchNode));
  }

  static boolean isUniqueIntegerSwitchNode(SwitchNode switchNode) {
    var alreadySeen = new HashSet<Integer>();
    for (var caseNode : switchNode.getCases()) {
      var test = caseNode.getTest();
      if (test != null && !isUniqueIntegerLiteral(test, alreadySeen)) {
        return false;
      }
    }
    return true;
  }

  static boolean isUniqueIntegerLiteral(Expression expr, Set<Integer> alreadySeen) {
    if (expr instanceof LiteralNode<?> n) {
      var value = n.getValue();
      if (value instanceof Integer i) {
        return alreadySeen.add(i);
      }
    }
    return false;
  }

  /**
   * Helper class to evaluate constant expressions at compile time.
   * This is also a simplifier used by BinaryNode visits, UnaryNode visits and conversions.
   */
  abstract static class ConstantEvaluator<T extends Node> {

    protected T parent;
    protected final long token;
    protected final int finish;

    protected ConstantEvaluator(T parent) {
      this.parent = parent;
      this.token = parent.getToken();
      this.finish = parent.getFinish();
    }

    /**
     * Returns a literal node that replaces the given parent node, or null if replacement is impossible
     * @return the literal node
     */
    protected abstract LiteralNode<?> eval();
  }

  /**
   * When we eliminate dead code, we must preserve var declarations as they are scoped to the whole function.
   * This method gathers var nodes from code passed to it, removing their initializers.
   * @param deadCodeRoot the root node of eliminated dead code
   * @param statements a list that will be receiving the var nodes from the dead code, with their initializers removed.
   */
  static void extractVarNodesFromDeadCode(Node deadCodeRoot, List<Statement> statements) {
    deadCodeRoot.accept(new SimpleNodeVisitor() {
      @Override
      public boolean enterVarNode(VarNode varNode) {
        statements.add(varNode.setInit(null));
        return false;
      }
      @Override
      public boolean enterFunctionNode(FunctionNode functionNode) {
        // Don't descend into nested functions
        return false;
      }
    });
  }

  static class UnaryNodeConstantEvaluator extends ConstantEvaluator<UnaryNode> {

    UnaryNodeConstantEvaluator(UnaryNode parent) {
      super(parent);
    }

    @Override
    protected LiteralNode<?> eval() {
      var rhsNode = parent.getExpression();
      if (!(rhsNode instanceof LiteralNode)) {
        return null;
      }
      if (rhsNode instanceof ArrayLiteralNode) {
        return null;
      }
      var rhs = (LiteralNode<?>) rhsNode;
      var rhsType = rhs.getType();
      var rhsInteger = rhsType.isInteger() || rhsType.isBoolean();
      var literalNode = switch (parent.tokenType()) {
        case POS -> (rhsInteger) ? LiteralNode.newInstance(token, finish, rhs.getInt32())
                  : (rhsType.isLong()) ? LiteralNode.newInstance(token, finish, rhs.getLong())
                  : LiteralNode.newInstance(token, finish, rhs.getNumber());
        case NEG -> (rhsInteger && rhs.getInt32() != 0) ? LiteralNode.newInstance(token, finish, -rhs.getInt32()) // @see test/script/basic/minuszero.js
                  : (rhsType.isLong() && rhs.getLong() != 0L) ? LiteralNode.newInstance(token, finish, -rhs.getLong())
                  : LiteralNode.newInstance(token, finish, -rhs.getNumber());
        case NOT -> LiteralNode.newInstance(token, finish, !rhs.getBoolean());
        case BIT_NOT -> LiteralNode.newInstance(token, finish, ~rhs.getInt32());
        default -> null;
      };
      return literalNode;
    }
  }

  // TODO add AND and OR with one constant parameter (bitwise)
  static class BinaryNodeConstantEvaluator extends ConstantEvaluator<BinaryNode> {

    BinaryNodeConstantEvaluator(BinaryNode parent) {
      super(parent);
    }

    @Override
    protected LiteralNode<?> eval() {
      LiteralNode<?> result;
      result = reduceTwoLiterals();
      if (result != null) {
        return result;
      }
      result = reduceOneLiteral();
      if (result != null) {
        return result;
      }
      return null;
    }

    @SuppressWarnings("static-method")
    LiteralNode<?> reduceOneLiteral() {
      // TODO handle patterns like AND, OR, numeric ops that can be strength reduced but not replaced by a single literal node etc
      return null;
    }

    LiteralNode<?> reduceTwoLiterals() {
      if (!(parent.lhs() instanceof LiteralNode && parent.rhs() instanceof LiteralNode)) {
        return null;
      }
      var lhs = (LiteralNode<?>) parent.lhs();
      var rhs = (LiteralNode<?>) parent.rhs();
      if (lhs instanceof ArrayLiteralNode || rhs instanceof ArrayLiteralNode) {
        return null;
      }
      var widest = Type.widest(lhs.getType(), rhs.getType());
      var isInteger = widest.isInteger();
      double value;

      switch (parent.tokenType()) {
        case DIV -> value = lhs.getNumber() / rhs.getNumber();
        case ADD -> {
          if ((lhs.isString() || rhs.isNumeric()) && (rhs.isString() || rhs.isNumeric())) {
            var res = ScriptRuntime.ADD(lhs.getObject(), rhs.getObject());
            if (res instanceof Number n) {
              value = n.doubleValue();
              break;
            }
            assert res instanceof CharSequence : res + " was not a CharSequence, it was a " + res.getClass();
            return LiteralNode.newInstance(token, finish, res.toString());
          }
          return null;
        }
        case MUL -> value = lhs.getNumber() * rhs.getNumber();
        case MOD -> value = lhs.getNumber() % rhs.getNumber();
        case SUB -> value = lhs.getNumber() - rhs.getNumber();
        case SHR -> {
          var result = JSType.toUint32(lhs.getInt32() >>> rhs.getInt32());
          return LiteralNode.newInstance(token, finish, JSType.toNarrowestNumber(result));
        }
        case SAR -> {
          return LiteralNode.newInstance(token, finish, lhs.getInt32() >> rhs.getInt32());
        }
        case SHL -> {
          return LiteralNode.newInstance(token, finish, lhs.getInt32() << rhs.getInt32());
        }
        case BIT_XOR -> {
          return LiteralNode.newInstance(token, finish, lhs.getInt32() ^ rhs.getInt32());
        }
        case BIT_AND -> {
          return LiteralNode.newInstance(token, finish, lhs.getInt32() & rhs.getInt32());
        }
        case BIT_OR -> {
          return LiteralNode.newInstance(token, finish, lhs.getInt32() | rhs.getInt32());
        }
        case GE -> {
          return LiteralNode.newInstance(token, finish, ScriptRuntime.GE(lhs.getObject(), rhs.getObject()));
        }
        case LE -> {
          return LiteralNode.newInstance(token, finish, ScriptRuntime.LE(lhs.getObject(), rhs.getObject()));
        }
        case GT -> {
          return LiteralNode.newInstance(token, finish, ScriptRuntime.GT(lhs.getObject(), rhs.getObject()));
        }
        case LT -> {
          return LiteralNode.newInstance(token, finish, ScriptRuntime.LT(lhs.getObject(), rhs.getObject()));
        }
        case NE -> {
          return LiteralNode.newInstance(token, finish, ScriptRuntime.NE(lhs.getObject(), rhs.getObject()));
        }
        case NEQU -> {
          return LiteralNode.newInstance(token, finish, ScriptRuntime.NOT_EQUIV(lhs.getObject(), rhs.getObject()));
        }
        case EQ -> {
          return LiteralNode.newInstance(token, finish, ScriptRuntime.EQ(lhs.getObject(), rhs.getObject()));
        }
        case EQU -> {
          return LiteralNode.newInstance(token, finish, ScriptRuntime.EQUIV(lhs.getObject(), rhs.getObject()));
        }
        default -> {
          return null;
        }
      }
      isInteger &= JSType.isNonNegativeZeroInt(value);
      return (isInteger) ? LiteralNode.newInstance(token, finish, (int) value) : LiteralNode.newInstance(token, finish, value);
    }
  }

}
