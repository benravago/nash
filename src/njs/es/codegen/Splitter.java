package es.codegen;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.ir.Block;
import es.ir.FunctionNode;
import es.ir.LiteralNode;
import es.ir.LiteralNode.ArrayLiteralNode;
import es.ir.Node;
import es.ir.ObjectNode;
import es.ir.PropertyNode;
import es.ir.SplitNode;
import es.ir.Splittable;
import es.ir.Statement;
import es.ir.VarNode;
import es.ir.visitor.SimpleNodeVisitor;
import es.runtime.Context;
import es.runtime.logging.DebugLogger;
import es.runtime.logging.Loggable;
import es.runtime.logging.Logger;
import es.runtime.options.Options;
import static es.codegen.CompilerConstants.SPLIT_PREFIX;

/**
 * Split the IR into smaller compile units.
 */
@Logger(name = "splitter")
final class Splitter extends SimpleNodeVisitor implements Loggable {

  // Current compiler.
  private final Compiler compiler;

  // IR to be broken down.
  private final FunctionNode outermost;

  // Compile unit for the main script.
  private final CompileUnit outermostCompileUnit;

  // Cache for calculated block weights.
  private final Map<Node, Long> weightCache = new HashMap<>();

  // Weight threshold for when to start a split.
  public static final long SPLIT_THRESHOLD = Options.getIntProperty("nashorn.compiler.splitter.threshold", 32 * 1024);

  private final DebugLogger log;

  /**
   * Constructor.
   *
   * @param compiler              the compiler
   * @param functionNode          function node to split
   * @param outermostCompileUnit  compile unit for outermost function, if non-lazy this is the script's compile unit
   */
  public Splitter(Compiler compiler, FunctionNode functionNode, CompileUnit outermostCompileUnit) {
    this.compiler = compiler;
    this.outermost = functionNode;
    this.outermostCompileUnit = outermostCompileUnit;
    this.log = initLogger(compiler.getContext());
  }

  @Override
  public DebugLogger initLogger(Context context) {
    return context.getLogger(this.getClass());
  }

  @Override
  public DebugLogger getLogger() {
    return log;
  }

  /**
   * Execute the split.
   * @param fn the function to split
   * @param top whether this is the topmost compiled function (it's either a program, or we're doing a recompilation).
   */
  FunctionNode split(FunctionNode fn, boolean top) {
    var functionNode = fn;
    log.fine("Initiating split of '", functionNode.getName(), "'");
    var weight = WeighNodes.weigh(functionNode);
    // We know that our LexicalContext is empty outside the call to functionNode.accept(this) below, so we can pass null to all methods expecting a LexicalContext parameter.
    assert lc.isEmpty() : "LexicalContext not empty";
    if (weight >= SPLIT_THRESHOLD) {
      log.info("Splitting function '", functionNode.getName(), "' as its weight ", weight, " exceeds split threshold ", SPLIT_THRESHOLD);
      functionNode = (FunctionNode) functionNode.accept(this);
      if (functionNode.isSplit()) {
        // Weight has changed so weigh again, this time using block weight cache
        weight = WeighNodes.weigh(functionNode, weightCache);
        functionNode = functionNode.setBody(null, functionNode.getBody().setNeedsScope(null));
      }
      if (weight >= SPLIT_THRESHOLD) {
        functionNode = functionNode.setBody(null, splitBlock(functionNode.getBody(), functionNode));
        functionNode = functionNode.setFlag(null, FunctionNode.IS_SPLIT);
        weight = WeighNodes.weigh(functionNode.getBody(), weightCache);
      }
    }
    assert functionNode.getCompileUnit() == null : "compile unit already set for " + functionNode.getName();
    if (top) {
      assert outermostCompileUnit != null : "outermost compile unit is null";
      functionNode = functionNode.setCompileUnit(null, outermostCompileUnit);
      outermostCompileUnit.addWeight(weight + WeighNodes.FUNCTION_WEIGHT);
    } else {
      functionNode = functionNode.setCompileUnit(null, findUnit(weight));
    }
    var body = functionNode.getBody();
    var dc = directChildren(functionNode);
    var newBody = (Block) body.accept(new SimpleNodeVisitor() {
      @Override
      public boolean enterFunctionNode(FunctionNode nestedFunction) {
        return dc.contains(nestedFunction);
      }
      @Override
      public Node leaveFunctionNode(FunctionNode nestedFunction) {
        var split = new Splitter(compiler, nestedFunction, outermostCompileUnit).split(nestedFunction, false);
        lc.replace(nestedFunction, split);
        return split;
      }
    });
    functionNode = functionNode.setBody(null, newBody);
    assert functionNode.getCompileUnit() != null;
    return functionNode;
  }

  static List<FunctionNode> directChildren(FunctionNode functionNode) {
    var dc = new ArrayList<FunctionNode>();
    functionNode.accept(new SimpleNodeVisitor() {
      @Override
      public boolean enterFunctionNode(FunctionNode child) {
        if (child == functionNode) {
          return true;
        }
        if (lc.getParentFunction(child) == functionNode) {
          dc.add(child);
        }
        return false;
      }
    });
    return dc;
  }

  /**
   * Override this logic to look up compile units in a different way
   * @param weight weight needed
   * @return compile unit
   */
  protected CompileUnit findUnit(long weight) {
    return compiler.findUnit(weight);
  }

  /**
   * Split a block into sub methods.
   * @param block Block or function to split.
   * @return new weight for the resulting block.
   */
  Block splitBlock(Block block, FunctionNode function) {
    var splits = new ArrayList<Statement>();
    var statements = new ArrayList<Statement>();
    var statementsWeight = 0L;
    for (var statement : block.getStatements()) {
      var weight = WeighNodes.weigh(statement, weightCache);
      var isBlockScopedVarNode = isBlockScopedVarNode(statement);
      if (statementsWeight + weight >= SPLIT_THRESHOLD || statement.isTerminal() || isBlockScopedVarNode) {
        if (!statements.isEmpty()) {
          splits.add(createBlockSplitNode(block, function, statements, statementsWeight));
          statements = new ArrayList<>();
          statementsWeight = 0;
        }
      }
      if (statement.isTerminal() || isBlockScopedVarNode) {
        splits.add(statement);
      } else {
        statements.add(statement);
        statementsWeight += weight;
      }
    }
    if (!statements.isEmpty()) {
      splits.add(createBlockSplitNode(block, function, statements, statementsWeight));
    }
    return block.setStatements(lc, splits);
  }

  /**
   * Create a new split node from statements contained in a parent block.
   * @param parent     Parent block.
   * @param statements Statements to include.
   * @return New split node.
   */
  SplitNode createBlockSplitNode(Block parent, FunctionNode function, List<Statement> statements, long weight) {
    var token = parent.getToken();
    var finish = parent.getFinish();
    var name = function.uniqueName(SPLIT_PREFIX.symbolName());
    var newBlock = new Block(token, finish, statements);
    return new SplitNode(name, newBlock, compiler.findUnit(weight + WeighNodes.FUNCTION_WEIGHT));
  }

  boolean isBlockScopedVarNode(Statement statement) {
    return statement instanceof VarNode && ((VarNode) statement).isBlockScoped();
  }

  @Override
  public boolean enterBlock(Block block) {
    if (block.isCatchBlock()) {
      return false;
    }
    var weight = WeighNodes.weigh(block, weightCache);
    if (weight < SPLIT_THRESHOLD) {
      weightCache.put(block, weight);
      return false;
    }
    return true;
  }

  @Override
  public Node leaveBlock(Block block) {
    assert !block.isCatchBlock();
    var newBlock = block;
    // Block was heavier than SLIT_THRESHOLD in enter, but a sub-block may have been split already, so weigh again before splitting.
    var weight = WeighNodes.weigh(block, weightCache);
    if (weight >= SPLIT_THRESHOLD) {
      var currentFunction = lc.getCurrentFunction();
      newBlock = splitBlock(block, currentFunction);
      weight = WeighNodes.weigh(newBlock, weightCache);
      lc.setFlag(currentFunction, FunctionNode.IS_SPLIT);
    }
    weightCache.put(newBlock, weight);
    return newBlock;
  }

  @SuppressWarnings("rawtypes")
  @Override
  public Node leaveLiteralNode(LiteralNode literal) {
    var weight = WeighNodes.weigh(literal);
    if (weight < SPLIT_THRESHOLD) {
      return literal;
    }
    var functionNode = lc.getCurrentFunction();
    lc.setFlag(functionNode, FunctionNode.IS_SPLIT);
    if (literal instanceof ArrayLiteralNode arrayLiteralNode) {
      var value = arrayLiteralNode.getValue();
      var postsets = arrayLiteralNode.getPostsets();
      var ranges = new ArrayList<Splittable.SplitRange>();
      var totalWeight = 0L;
      var lo = 0;
      for (var i = 0; i < postsets.length; i++) {
        var postset = postsets[i];
        var element = value[postset];
        var elementWeight = WeighNodes.weigh(element);
        totalWeight += WeighNodes.AASTORE_WEIGHT + elementWeight;
        if (totalWeight >= SPLIT_THRESHOLD) {
          var unit = compiler.findUnit(totalWeight - elementWeight);
          ranges.add(new Splittable.SplitRange(unit, lo, i));
          lo = i;
          totalWeight = elementWeight;
        }
      }
      if (lo != postsets.length) {
        final CompileUnit unit = compiler.findUnit(totalWeight);
        ranges.add(new Splittable.SplitRange(unit, lo, postsets.length));
      }
      log.info("Splitting array literal in '", functionNode.getName(), "' as its weight ", weight, " exceeds split threshold ", SPLIT_THRESHOLD);
      return arrayLiteralNode.setSplitRanges(lc, ranges);
    }
    return literal;
  }

  @Override
  public Node leaveObjectNode(ObjectNode objectNode) {
    var weight = WeighNodes.weigh(objectNode);
    if (weight < SPLIT_THRESHOLD) {
      return objectNode;
    }
    var functionNode = lc.getCurrentFunction();
    lc.setFlag(functionNode, FunctionNode.IS_SPLIT);
    var ranges = new ArrayList<Splittable.SplitRange>();
    var properties = objectNode.getElements();
    var isSpillObject = properties.size() > CodeGenerator.OBJECT_SPILL_THRESHOLD;
    var totalWeight = 0L;
    var lo = 0;
    for (var i = 0; i < properties.size(); i++) {
      var property = properties.get(i);
      var isConstant = LiteralNode.isConstant(property.getValue());
      if (!isConstant || !isSpillObject) {
        var propertyWeight = isConstant ? 0 : WeighNodes.weigh(property.getValue());
        totalWeight += WeighNodes.AASTORE_WEIGHT + propertyWeight;
        if (totalWeight >= SPLIT_THRESHOLD) {
          var unit = compiler.findUnit(totalWeight - propertyWeight);
          ranges.add(new Splittable.SplitRange(unit, lo, i));
          lo = i;
          totalWeight = propertyWeight;
        }
      }
    }
    if (lo != properties.size()) {
      var unit = compiler.findUnit(totalWeight);
      ranges.add(new Splittable.SplitRange(unit, lo, properties.size()));
    }
    log.info("Splitting object node in '", functionNode.getName(), "' as its weight ", weight, " exceeds split threshold ", SPLIT_THRESHOLD);
    return objectNode.setSplitRanges(lc, ranges);
  }

  @Override
  public boolean enterFunctionNode(FunctionNode node) {
    //only go into the function node for this splitter. any subfunctions are rejected
    return node == outermost;
  }

}
