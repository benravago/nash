package es.codegen;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import es.ir.Block;
import es.ir.FunctionNode;
import es.ir.IdentNode;
import es.ir.LexicalContext;
import es.ir.Node;
import es.ir.Symbol;
import es.ir.visitor.SimpleNodeVisitor;
import es.runtime.RecompilableScriptFunctionData;

/**
 * Establishes depth of scope for non local symbols at the start of method.
 * If this is a recompilation, the previous data from eager compilation is stored in the RecompilableScriptFunctionData and is transferred to the FunctionNode being compiled
 */
final class FindScopeDepths extends SimpleNodeVisitor {

  private final Compiler compiler;
  private final Map<Integer, Map<Integer, RecompilableScriptFunctionData>> fnIdToNestedFunctions = new HashMap<>();
  private final Map<Integer, Map<String, Integer>> externalSymbolDepths = new HashMap<>();
  private final Map<Integer, Set<String>> internalSymbols = new HashMap<>();
  private final Set<Block> withBodies = new HashSet<>();

  private int dynamicScopeCount;

  FindScopeDepths(Compiler compiler) {
    this.compiler = compiler;
  }

  static int findScopesToStart(LexicalContext lc, FunctionNode fn, Block block) {
    var bodyBlock = findBodyBlock(lc, fn, block);
    var iter = lc.getBlocks(block);
    var b = iter.next();
    var scopesToStart = 0;
    for (;;) {
      if (b.needsScope()) {
        scopesToStart++;
      }
      if (b == bodyBlock) {
        break;
      }
      b = iter.next();
    }
    return scopesToStart;
  }

  static int findInternalDepth(LexicalContext lc, FunctionNode fn, Block block, Symbol symbol) {
    var bodyBlock = findBodyBlock(lc, fn, block);
    var iter = lc.getBlocks(block);
    var b = iter.next();
    var scopesToStart = 0;
    for (;;) {
      if (definedInBlock(b, symbol)) {
        return scopesToStart;
      }
      if (b.needsScope()) {
        scopesToStart++;
      }
      if (b == bodyBlock) {
        break; //don't go past body block, but process it
      }
      b = iter.next();
    }
    return -1;
  }

  static boolean definedInBlock(Block block, Symbol symbol) {
    // globals cannot be defined anywhere else
    return (symbol.isGlobal()) ? block.isGlobalScope() : block.getExistingSymbol(symbol.getName()) == symbol;
  }

  static Block findBodyBlock(LexicalContext lc, FunctionNode fn, Block block) {
    var iter = lc.getBlocks(block);
    while (iter.hasNext()) {
      var next = iter.next();
      if (fn.getBody() == next) {
        return next;
      }
    }
    return null;
  }

  static Block findGlobalBlock(LexicalContext lc, Block block) {
    var iter = lc.getBlocks(block);
    Block globalBlock = null;
    while (iter.hasNext()) {
      globalBlock = iter.next();
    }
    return globalBlock;
  }

  boolean isDynamicScopeBoundary(Block block) {
    return withBodies.contains(block);
  }

  @Override
  public boolean enterFunctionNode(FunctionNode functionNode) {
    if (compiler.isOnDemandCompilation()) {
      return true;
    }
    var fnId = functionNode.getId();
    var nestedFunctions = fnIdToNestedFunctions.get(fnId);
    if (nestedFunctions == null) {
      nestedFunctions = new HashMap<>();
      fnIdToNestedFunctions.put(fnId, nestedFunctions);
    }
    return true;
  }

  //external symbols hold the scope depth of sc11 from global at the start of the method
  @Override
  public Node leaveFunctionNode(FunctionNode functionNode) {
    var name = functionNode.getName();
    var newFunctionNode = functionNode;
    if (compiler.isOnDemandCompilation()) {
      var data = compiler.getScriptFunctionData(newFunctionNode.getId());
      if (data.inDynamicContext()) {
        newFunctionNode = newFunctionNode.setInDynamicContext(lc);
      }
      if (newFunctionNode == lc.getOutermostFunction() && !newFunctionNode.hasApplyToCallSpecialization()) {
        data.setCachedAst(newFunctionNode);
      }
      return newFunctionNode;
    }
    if (inDynamicScope()) {
      newFunctionNode = newFunctionNode.setInDynamicContext(lc);
    }
    // create recompilable scriptfunctiondata
    var fnId = newFunctionNode.getId();
    var nestedFunctions = fnIdToNestedFunctions.remove(fnId);
    assert nestedFunctions != null;
    // Generate the object class and property map in case this function is ever used as constructor
    var data = new RecompilableScriptFunctionData(newFunctionNode, compiler.getCodeInstaller(), ObjectClassGenerator.createAllocationStrategy(newFunctionNode.getThisProperties(), compiler.getContext().useDualFields()), nestedFunctions, externalSymbolDepths.get(fnId), internalSymbols.get(fnId));
    if (lc.getOutermostFunction() != newFunctionNode) {
      var parentFn = lc.getParentFunction(newFunctionNode);
      if (parentFn != null) {
        fnIdToNestedFunctions.get(parentFn.getId()).put(fnId, data);
      }
    } else {
      compiler.setData(data);
    }
    return newFunctionNode;
  }

  boolean inDynamicScope() {
    return dynamicScopeCount > 0;
  }

  void increaseDynamicScopeCount(Node node) {
    assert dynamicScopeCount >= 0;
    ++dynamicScopeCount;
  }

  void decreaseDynamicScopeCount(Node node) {
    --dynamicScopeCount;
    assert dynamicScopeCount >= 0;
  }

  @Override
  public boolean enterBlock(Block block) {
    if (compiler.isOnDemandCompilation()) {
      return true;
    }
    if (isDynamicScopeBoundary(block)) {
      increaseDynamicScopeCount(block);
    }
    if (!lc.isFunctionBody()) {
      return true;
    }
    // the below part only happens on eager compilation when we have the entire hierarchy block is a function body
    var fn = lc.getCurrentFunction();
    // get all symbols that are referenced inside this function body
    var symbols = new HashSet<Symbol>();
    block.accept(new SimpleNodeVisitor() {
      @Override
      public boolean enterIdentNode(IdentNode identNode) {
        var symbol = identNode.getSymbol();
        if (symbol != null && symbol.isScope()) {
          //if this is an internal symbol, skip it.
          symbols.add(symbol);
        }
        return true;
      }
    });
    var internals = new HashMap<String, Integer>();
    var globalBlock = findGlobalBlock(lc, block);
    var bodyBlock = findBodyBlock(lc, fn, block);
    assert globalBlock != null;
    assert bodyBlock != null;
    for (var symbol : symbols) {
      Iterator<Block> iter;
      var internalDepth = findInternalDepth(lc, fn, block, symbol);
      var internal = internalDepth >= 0;
      if (internal) {
        internals.put(symbol.getName(), internalDepth);
      }
      // if not internal, we have to continue walking until we reach the top.
      // We start outside the body and each new scope adds a depth count.
      // When we find the symbol, we store its depth count
      if (!internal) {
        var depthAtStart = 0;
        // not internal - keep looking.
        iter = lc.getAncestorBlocks(bodyBlock);
        while (iter.hasNext()) {
          var b2 = iter.next();
          if (definedInBlock(b2, symbol)) {
            addExternalSymbol(fn, symbol, depthAtStart);
            break;
          }
          if (b2.needsScope()) {
            depthAtStart++;
          }
        }
      }
    }
    addInternalSymbols(fn, internals.keySet());
    return true;
  }

  @Override
  public Node leaveBlock(Block block) {
    if (compiler.isOnDemandCompilation()) {
      return block;
    }
    if (isDynamicScopeBoundary(block)) {
      decreaseDynamicScopeCount(block);
    }
    return block;
  }

  void addInternalSymbols(FunctionNode functionNode, Set<String> symbols) {
    var fnId = functionNode.getId();
    assert internalSymbols.get(fnId) == null || internalSymbols.get(fnId).equals(symbols); //e.g. cloned finally block
    internalSymbols.put(fnId, symbols);
  }

  void addExternalSymbol(FunctionNode functionNode, Symbol symbol, int depthAtStart) {
    var fnId = functionNode.getId();
    var depths = externalSymbolDepths.get(fnId);
    if (depths == null) {
      depths = new HashMap<>();
      externalSymbolDepths.put(fnId, depths);
    }
    depths.put(symbol.getName(), depthAtStart);
  }

}
