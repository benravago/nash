package es.codegen;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import es.ir.AccessNode;
import es.ir.BinaryNode;
import es.ir.Block;
import es.ir.CatchNode;
import es.ir.Expression;
import es.ir.ForNode;
import es.ir.FunctionNode;
import es.ir.IdentNode;
import es.ir.LexicalContextNode;
import es.ir.LiteralNode;
import es.ir.Node;
import es.ir.RuntimeNode;
import es.ir.RuntimeNode.Request;
import es.ir.Splittable;
import es.ir.Statement;
import es.ir.SwitchNode;
import es.ir.Symbol;
import es.ir.TryNode;
import es.ir.UnaryNode;
import es.ir.VarNode;
import es.ir.WithNode;
import es.ir.visitor.SimpleNodeVisitor;
import es.parser.TokenType;
import es.runtime.ECMAErrors;
import es.runtime.ErrorManager;
import es.runtime.JSErrorType;
import es.runtime.ParserException;
import static es.codegen.CompilerConstants.*;
import static es.ir.Symbol.*;

/**
 * This visitor assigns symbols to identifiers denoting variables.
 * It does few more minor calculations that are only possible after symbols have been assigned; such is the transformation of "delete" and "typeof" operators into runtime nodes and counting of number of properties assigned to "this" in constructor functions.
 * This visitor is also notable for what it doesn't do, most significantly it does no type calculations as in JavaScript variables can change types during runtime and as such symbols don't have types.
 * Calculation of expression types is performed by a separate visitor.
 */
final class AssignSymbols extends SimpleNodeVisitor{

  static boolean isParamOrVar(IdentNode identNode) {
    var symbol = identNode.getSymbol();
    return symbol.isParam() || symbol.isVar();
  }

  static String name(Node node) {
    var cn = node.getClass().getName();
    var lastDot = cn.lastIndexOf('.');
    return (lastDot == -1) ? cn : cn.substring(lastDot + 1);
  }

  /**
   * Checks if various symbols that were provisionally marked as needing a slot ended up unused, and marks them as not needing a slot after all.
   * @param functionNode the function node
   * @return the passed in node, for easy chaining
   */
  static FunctionNode removeUnusedSlots(FunctionNode functionNode) {
    if (!functionNode.needsCallee()) {
      functionNode.compilerConstant(CALLEE).setNeedsSlot(false);
    }
    if (!(functionNode.hasScopeBlock() || functionNode.needsParentScope())) {
      functionNode.compilerConstant(SCOPE).setNeedsSlot(false);
    }
    // Named function expressions that end up not referencing themselves won't need a local slot for the self symbol.
    if (functionNode.isNamedFunctionExpression() && !functionNode.usesSelfSymbol()) {
      var selfSymbol = functionNode.getBody().getExistingSymbol(functionNode.getIdent().getName());
      if (selfSymbol != null && selfSymbol.isFunctionSelf()) {
        selfSymbol.setNeedsSlot(false);
        selfSymbol.clearFlag(Symbol.IS_VAR);
      }
    }
    return functionNode;
  }

  private final Deque<Set<String>> thisProperties = new ArrayDeque<>();
  private final Map<String, Symbol> globalSymbols = new HashMap<>(); //reuse the same global symbol
  private final Compiler compiler;
  private final boolean isOnDemand;

  public AssignSymbols(Compiler compiler) {
    this.compiler = compiler;
    this.isOnDemand = compiler.isOnDemandCompilation();
  }

  /**
   * Define symbols for all variable declarations at the top of the function scope.
   * This way we can get around problems like
   * <pre>
   * while (true) {
   *   break;
   *   if (true) {
   *     var s;
   *   }
   * }
   * </pre>
   * to an arbitrary nesting depth.
   * see NASHORN-73
   * @param functionNode the FunctionNode we are entering
   * @param body the body of the FunctionNode we are entering
   */
  void acceptDeclarations(FunctionNode functionNode, Block body) {
    // This visitor will assign symbol to all declared variables.
    body.accept(new SimpleNodeVisitor() {
      @Override
      protected boolean enterDefault(Node node) {
        // Don't bother visiting expressions; var is a statement, it can't be inside an expression.
        // This will also prevent visiting nested functions (as FunctionNode is an expression).
        return !(node instanceof Expression);
      }
      @Override
      public Node leaveVarNode(VarNode varNode) {
        var ident = varNode.getName();
        var blockScoped = varNode.isBlockScoped();
        if (blockScoped && lc.inUnprotectedSwitchContext()) {
          throwUnprotectedSwitchError(varNode);
        }
        var block = blockScoped ? lc.getCurrentBlock() : body;
        var symbol = defineSymbol(block, ident.getName(), ident, varNode.getSymbolFlags());
        if (varNode.isFunctionDeclaration()) {
          symbol.setIsFunctionDeclaration();
        }
        return varNode.setName(ident.setSymbol(symbol));
      }
    });
  }

  IdentNode compilerConstantIdentifier(CompilerConstants cc) {
    return createImplicitIdentifier(cc.symbolName()).setSymbol(lc.getCurrentFunction().compilerConstant(cc));
  }

  /**
   * Creates an ident node for an implicit identifier within the function (one not declared in the script source code).
   * These identifiers are defined with function's token and finish.
   * @param name the name of the identifier
   * @return an ident node representing the implicit identifier.
   */
  IdentNode createImplicitIdentifier(String name) {
    var fn = lc.getCurrentFunction();
    return new IdentNode(fn.getToken(), fn.getFinish(), name);
  }

  Symbol createSymbol(String name, int flags) {
    if ((flags & Symbol.KINDMASK) == IS_GLOBAL) {
      // reuse global symbols so they can be hashed
      var global = globalSymbols.get(name);
      if (global == null) {
        global = new Symbol(name, flags);
        globalSymbols.put(name, global);
      }
      return global;
    }
    return new Symbol(name, flags);
  }

  /**
   * Creates a synthetic initializer for a variable (a var statement that doesn't occur in the source code).
   * Typically used to create assignment of {@code :callee} to the function name symbol in self-referential function expressions as well as for assignment of {@code :arguments} to {@code arguments}.
   * @param name the ident node identifying the variable to initialize
   * @param initConstant the compiler constant it is initialized to
   * @param fn the function node the assignment is for
   * @return a var node with the appropriate assignment
   */
  VarNode createSyntheticInitializer(IdentNode name, CompilerConstants initConstant, FunctionNode fn) {
    var init = compilerConstantIdentifier(initConstant);
    assert init.getSymbol() != null && init.getSymbol().isBytecodeLocal();
    var synthVar = new VarNode(fn.getLineNumber(), fn.getToken(), fn.getFinish(), name, init);
    var nameSymbol = fn.getBody().getExistingSymbol(name.getName());
    assert nameSymbol != null;
    return (VarNode) synthVar.setName(name.setSymbol(nameSymbol)).accept(this);
  }

  FunctionNode createSyntheticInitializers(FunctionNode functionNode) {
    var syntheticInitializers = new ArrayList<VarNode>(2);
    // Must visit the new var nodes in the context of the body.
    // We could also just set the new statements into the block and then revisit the entire block, but that seems to be too much double work.
    var body = functionNode.getBody();
    lc.push(body);
    try {
      if (functionNode.usesSelfSymbol()) {
        // "var fn = :callee"
        syntheticInitializers.add(createSyntheticInitializer(functionNode.getIdent(), CALLEE, functionNode));
      }
      if (functionNode.needsArguments()) {
        // "var arguments = :arguments"
        syntheticInitializers.add(createSyntheticInitializer(createImplicitIdentifier(ARGUMENTS_VAR.symbolName()), ARGUMENTS, functionNode));
      }
      if (syntheticInitializers.isEmpty()) {
        return functionNode;
      }
      for (var it = syntheticInitializers.listIterator(); it.hasNext();) {
        it.set((VarNode) it.next().accept(this));
      }
    } finally {
      lc.pop(body);
    }
    var stmts = body.getStatements();
    var newStatements = new ArrayList<Statement>(stmts.size() + syntheticInitializers.size());
    newStatements.addAll(syntheticInitializers);
    newStatements.addAll(stmts);
    return functionNode.setBody(lc, body.setStatements(lc, newStatements));
  }

  /**
   * Defines a new symbol in the given block.
   * @param block        the block in which to define the symbol
   * @param name         name of symbol.
   * @param origin       origin node
   * @param symbolFlags  Symbol flags.
   * @return Symbol for given name or null for redefinition.
   */
  Symbol defineSymbol(Block block, String name, Node origin, int symbolFlags) {
    var flags = symbolFlags;
    var isBlockScope = (flags & IS_LET) != 0 || (flags & IS_CONST) != 0;
    var isGlobal = (flags & KINDMASK) == IS_GLOBAL;
    Symbol symbol;
    FunctionNode function;
    if (isBlockScope) {
      // block scoped variables always live in current block, no need to look for existing symbols in parent blocks.
      symbol = block.getExistingSymbol(name);
      function = lc.getCurrentFunction();
    } else {
      symbol = findSymbol(block, name);
      function = lc.getFunction(block);
    }
    // Global variables are implicitly always scope variables too.
    if (isGlobal) {
      flags |= IS_SCOPE;
    }
    if (lc.getCurrentFunction().isProgram()) {
      flags |= IS_PROGRAM_LEVEL;
    }
    var isParam = (flags & KINDMASK) == IS_PARAM;
    var isVar = (flags & KINDMASK) == IS_VAR;
    if (symbol != null) {
      // Symbol was already defined. Check if it needs to be redefined.
      if (isParam) {
        if (!isLocal(function, symbol)) {
          // Not defined in this function. Create a new definition.
          symbol = null;
        } else if (symbol.isParam()) {
          // Duplicate parameter. Null return will force an error.
          throwParserException(ECMAErrors.getMessage("syntax.error.duplicate.parameter", name), origin);
        }
      } else if (isVar) {
        if (isBlockScope) {
          // Check redeclaration in same block
          if (symbol.hasBeenDeclared()) {
            throwParserException(ECMAErrors.getMessage("syntax.error.redeclare.variable", name), origin);
          } else {
            symbol.setHasBeenDeclared();
            // Set scope flag on top-level block scoped symbols
            if (function.isProgram() && function.getBody() == block) {
              symbol.setIsScope();
            }
          }
        } else if ((flags & IS_INTERNAL) != 0) {
          // Always create a new definition.
          symbol = null;
        } else {
          // Found LET or CONST in parent scope of same function - s SyntaxError
          if (symbol.isBlockScoped() && isLocal(lc.getCurrentFunction(), symbol)) {
            throwParserException(ECMAErrors.getMessage("syntax.error.redeclare.variable", name), origin);
          }
          // Not defined in this function. Create a new definition.
          if (!isLocal(function, symbol) || symbol.less(IS_VAR)) {
            symbol = null;
          }
        }
      }
    }
    if (symbol == null) {
      // If not found, then create a new one.
      Block symbolBlock;
      // Determine where to create it.
      if (isVar && ((flags & IS_INTERNAL) != 0 || isBlockScope)) {
        symbolBlock = block; //internal vars are always defined in the block closest to them
      } else if (isGlobal) {
        symbolBlock = lc.getOutermostFunction().getBody();
      } else {
        symbolBlock = lc.getFunctionBody(function);
      }
      // Create and add to appropriate block.
      symbol = createSymbol(name, flags);
      symbolBlock.putSymbol(symbol);
      if ((flags & IS_SCOPE) == 0) {
        // Initial assumption; symbol can lose its slot later
        symbol.setNeedsSlot(true);
      }
    } else if (symbol.less(flags)) {
      symbol.setFlags(flags);
    }
    return symbol;
  }

  <T extends Node> T end(T node) {
    return end(node, true);
  }

  <T extends Node> T end(T node, boolean printNode) {
    return node;
  }

  @Override
  public boolean enterBlock(Block block) {
    start(block);
    if (lc.isFunctionBody()) {
      assert !block.hasSymbols();
      var fn = lc.getCurrentFunction();
      if (isUnparsedFunction(fn)) {
        // It's a skipped nested function. Just mark the symbols being used by it as being in use.
        for (var name : compiler.getScriptFunctionData(fn.getId()).getExternalSymbolNames()) {
          nameIsUsed(name, null);
        }
        // Don't bother descending into it, it must be empty anyway.
        assert block.getStatements().isEmpty();
        return false;
      }
      enterFunctionBody();
    }
    return true;
  }

  boolean isUnparsedFunction(FunctionNode fn) {
    return isOnDemand && fn != lc.getOutermostFunction();
  }

  @Override
  public boolean enterCatchNode(CatchNode catchNode) {
    var exception = catchNode.getExceptionIdentifier();
    var block = lc.getCurrentBlock();
    start(catchNode);
    // define block-local exception variable
    var exname = exception.getName();
    // If the name of the exception starts with ":e", this is a synthetic catch block, likely a catch-all.
    // Its symbol is naturally internal, and should be treated as such.
    var isInternal = exname.startsWith(EXCEPTION_PREFIX.symbolName());
    // IS_LET flag is required to make sure symbol is not visible outside catch block.
    // However, we need to clear the IS_LET flag after creation to allow redefinition of symbol inside the catch block.
    var symbol = defineSymbol(block, exname, catchNode, IS_VAR | IS_LET | (isInternal ? IS_INTERNAL : 0) | HAS_OBJECT_VALUE);
    symbol.clearFlag(IS_LET);
    return true;
  }

  void enterFunctionBody() {
    var functionNode = lc.getCurrentFunction();
    var body = lc.getCurrentBlock();
    initFunctionWideVariables(functionNode, body);
    acceptDeclarations(functionNode, body);
    defineFunctionSelfSymbol(functionNode, body);
  }

  void defineFunctionSelfSymbol(FunctionNode functionNode, Block body) {
    // Function self-symbol is only declared as a local variable for named function expressions.
    // Declared functions don't need it as they are local variables in their declaring scope.
    if (!functionNode.isNamedFunctionExpression()) {
      return;
    }
    var name = functionNode.getIdent().getName();
    assert name != null; // As it's a named function expression.
    if (body.getExistingSymbol(name) != null) {
      // Body already has a declaration for the name. It's either a parameter "function x(x)" or a top-level variable "function x() { ... var x; ... }".
      return;
    }
    defineSymbol(body, name, functionNode, IS_VAR | IS_FUNCTION_SELF | HAS_OBJECT_VALUE);
    if (functionNode.allVarsInScope()) { // basically, has deep eval
      // We must conservatively presume that eval'd code can dynamically use the function symbol.
      lc.setFlag(functionNode, FunctionNode.USES_SELF_SYMBOL);
    }
  }

  @Override
  public boolean enterFunctionNode(FunctionNode functionNode) {
    start(functionNode, false);
    thisProperties.push(new HashSet<String>());
    // Every function has a body, even the ones skipped on reparse (they have an empty one).
    // We're asserting this as even for those, enterBlock() must be invoked to correctly process symbols that are used in them.
    assert functionNode.getBody() != null;
    return true;
  }

  @Override
  public boolean enterVarNode(VarNode varNode) {
    start(varNode);
    // Normally, a symbol assigned in a var statement is not live for its RHS.
    // Since we also represent function declarations as VarNodes, they are exception to the rule, as they need to have the symbol visible to the body of the declared function for self-reference.
    if (varNode.isFunctionDeclaration()) {
      defineVarIdent(varNode);
    }
    return true;
  }

  @Override
  public Node leaveVarNode(VarNode varNode) {
    if (!varNode.isFunctionDeclaration()) {
      defineVarIdent(varNode);
    }
    return super.leaveVarNode(varNode);
  }

  void defineVarIdent(VarNode varNode) {
    var ident = varNode.getName();
    var flags = (!varNode.isBlockScoped() && lc.getCurrentFunction().isProgram()) ? IS_SCOPE : 0;
    defineSymbol(lc.getCurrentBlock(), ident.getName(), ident, varNode.getSymbolFlags() | flags);
  }

  Symbol exceptionSymbol() {
    return newObjectInternal(EXCEPTION_PREFIX);
  }

  /**
   * This has to run before fix assignment types, store any type specializations for parameters, then turn them into objects for the generic version of this method.
   * @param functionNode functionNode
   */
  FunctionNode finalizeParameters(FunctionNode functionNode) {
    var newParams = new ArrayList<IdentNode>();
    var isVarArg = functionNode.isVarArg();
    var body = functionNode.getBody();
    for (var param : functionNode.getParameters()) {
      var paramSymbol = body.getExistingSymbol(param.getName());
      assert paramSymbol != null;
      assert paramSymbol.isParam() : paramSymbol + " " + paramSymbol.getFlags();
      newParams.add(param.setSymbol(paramSymbol));
      // parameters should not be slots for a function that uses variable arity signature
      if (isVarArg) {
        paramSymbol.setNeedsSlot(false);
      }
    }
    return functionNode.setParameters(lc, newParams);
  }

  /**
   * Search for symbol in the lexical context starting from the given block.
   * @param name Symbol name.
   * @return Found symbol or null if not found.
   */
  Symbol findSymbol(Block block, String name) {
    for (var blocks = lc.getBlocks(block); blocks.hasNext();) {
      var symbol = blocks.next().getExistingSymbol(name);
      if (symbol != null) {
        return symbol;
      }
    }
    return null;
  }

  /**
   * Marks the current function as one using any global symbol.
   * The function and all its parent functions will all be marked as needing parent scope.
   * @see FunctionNode#needsParentScope()
   */
  void functionUsesGlobalSymbol() {
    for (var fns = lc.getFunctions(); fns.hasNext();) {
      lc.setFlag(fns.next(), FunctionNode.USES_ANCESTOR_SCOPE);
    }
  }

  /**
   * Marks the current function as one using a scoped symbol.
   * The block defining the symbol will be marked as needing its own scope to hold the variable.
   * If the symbol is defined outside of the current function, it and all functions up to (but not including) the function containing the defining block will be marked as needing parent function scope.
   * @see FunctionNode#needsParentScope()
   */
  void functionUsesScopeSymbol(Symbol symbol) {
    var name = symbol.getName();
    for (var contextNodeIter = lc.getAllNodes(); contextNodeIter.hasNext();) {
      var node = contextNodeIter.next();
      if (node instanceof Block block) {
        if (block.getExistingSymbol(name) != null) {
          assert lc.contains(block);
          lc.setBlockNeedsScope(block);
          break;
        }
      } else if (node instanceof FunctionNode) {
        lc.setFlag(node, FunctionNode.USES_ANCESTOR_SCOPE);
      }
    }
  }

  /**
   * Declares that the current function is using the symbol.
   * @param symbol the symbol used by the current function.
   */
  void functionUsesSymbol(Symbol symbol) {
    assert symbol != null;
    if (symbol.isScope()) {
      if (symbol.isGlobal()) {
        functionUsesGlobalSymbol();
      } else {
        functionUsesScopeSymbol(symbol);
      }
    } else {
      assert !symbol.isGlobal(); // Every global is also scope
    }
  }

  void initCompileConstant(CompilerConstants cc, Block block, int flags) {
    defineSymbol(block, cc.symbolName(), null, flags).setNeedsSlot(true);
  }

  void initFunctionWideVariables(FunctionNode functionNode, Block body) {
    initCompileConstant(CALLEE, body, IS_PARAM | IS_INTERNAL | HAS_OBJECT_VALUE);
    initCompileConstant(THIS, body, IS_PARAM | IS_THIS | HAS_OBJECT_VALUE);
    if (functionNode.isVarArg()) {
      initCompileConstant(VARARGS, body, IS_PARAM | IS_INTERNAL | HAS_OBJECT_VALUE);
      if (functionNode.needsArguments()) {
        initCompileConstant(ARGUMENTS, body, IS_VAR | IS_INTERNAL | HAS_OBJECT_VALUE);
        defineSymbol(body, ARGUMENTS_VAR.symbolName(), null, IS_VAR | HAS_OBJECT_VALUE);
      }
    }
    initParameters(functionNode, body);
    initCompileConstant(SCOPE, body, IS_VAR | IS_INTERNAL | HAS_OBJECT_VALUE);
    initCompileConstant(RETURN, body, IS_VAR | IS_INTERNAL);
  }

  /**
   * Initialize parameters for function node.
   * @param functionNode the function node
   */
  void initParameters(FunctionNode functionNode, Block body) {
    var isVarArg = functionNode.isVarArg();
    var scopeParams = functionNode.allVarsInScope() || isVarArg;
    for (var param : functionNode.getParameters()) {
      var symbol = defineSymbol(body, param.getName(), param, IS_PARAM);
      if (scopeParams) {
        // NOTE: this "set is scope" is a poor substitute for clear expression of where the symbol is stored.
        // It will force creation of scopes where they would otherwise not necessarily be needed (functions using arguments object and other variable arity functions). Tracked by JDK-8038942.
        symbol.setIsScope();
        assert symbol.hasSlot();
        if (isVarArg) {
          symbol.setNeedsSlot(false);
        }
      }
    }
  }

  /**
   * Is the symbol local to (that is, defined in) the specified function?
   * @param function the function
   * @param symbol the symbol
   * @return true if the symbol is defined in the specified function
   */
  boolean isLocal(FunctionNode function, Symbol symbol) {
    var definingFn = lc.getDefiningFunction(symbol);
    assert definingFn != null;
    return definingFn == function;
  }

  @Override
  public Node leaveBinaryNode(BinaryNode binaryNode) {
    return (binaryNode.isTokenType(TokenType.ASSIGN)) ? leaveASSIGN(binaryNode) : super.leaveBinaryNode(binaryNode);
  }

  Node leaveASSIGN(BinaryNode binaryNode) {
    // If we're assigning a property of the this object ("this.foo = ..."), record it.
    var lhs = binaryNode.lhs();
    if (lhs instanceof AccessNode accessNode) {
      var base = accessNode.getBase();
      if (base instanceof IdentNode i) {
        var symbol = i.getSymbol();
        if (symbol.isThis()) {
          thisProperties.peek().add(accessNode.getProperty());
        }
      }
    }
    return binaryNode;
  }

  @Override
  public Node leaveUnaryNode(UnaryNode unaryNode) {
    return (unaryNode.tokenType() == TokenType.TYPEOF) ? leaveTYPEOF(unaryNode) : super.leaveUnaryNode(unaryNode);
  }

  @Override
  public Node leaveForNode(ForNode forNode) {
    return (forNode.isForInOrOf()) ? forNode.setIterator(lc, newObjectInternal(ITERATOR_PREFIX)) /*NASHORN-73*/ : end(forNode);
  }

  @Override
  public Node leaveFunctionNode(FunctionNode functionNode) {
    return (isUnparsedFunction(functionNode)) ? functionNode
      : markProgramBlock(removeUnusedSlots(createSyntheticInitializers(finalizeParameters(lc.applyTopFlags(functionNode)))).setThisProperties(lc, thisProperties.pop().size()));
  }

  @Override
  public Node leaveIdentNode(IdentNode identNode) {
    if (identNode.isPropertyName()) {
      return identNode;
    }
    var symbol = nameIsUsed(identNode.getName(), identNode);
    if (!identNode.isInitializedHere()) {
      symbol.increaseUseCount();
    }
    var newIdentNode = identNode.setSymbol(symbol);
    // If a block-scoped var is used before its declaration mark it as dead.
    // We can only statically detect this for local vars, cross-function symbols require runtime checks.
    if (symbol.isBlockScoped() && !symbol.hasBeenDeclared() && !identNode.isDeclaredHere() && isLocal(lc.getCurrentFunction(), symbol)) {
      newIdentNode = newIdentNode.markDead();
    }
    return end(newIdentNode);
  }

  Symbol nameIsUsed(String name, IdentNode origin) {
    var block = lc.getCurrentBlock();
    var symbol = findSymbol(block, name);
    //If an existing symbol with the name is found, use that otherwise, declare a new one
    if (symbol != null) {
      if (symbol.isFunctionSelf()) {
        var functionNode = lc.getDefiningFunction(symbol);
        assert functionNode != null;
        assert lc.getFunctionBody(functionNode).getExistingSymbol(CALLEE.symbolName()) != null;
        lc.setFlag(functionNode, FunctionNode.USES_SELF_SYMBOL);
      }
      // if symbol is non-local or we're in a with block, we need to put symbol in scope (if it isn't already)
      maybeForceScope(symbol);
    } else {
      symbol = defineSymbol(block, name, origin, IS_GLOBAL | IS_SCOPE);
    }
    functionUsesSymbol(symbol);
    return symbol;
  }

  @Override
  public Node leaveSwitchNode(SwitchNode switchNode) {
    // We only need a symbol for the tag if it's not an integer switch node
    return switchNode.isUniqueInteger() ? switchNode : switchNode.setTag(lc, newObjectInternal(SWITCH_TAG_PREFIX));
  }

  @Override
  public Node leaveTryNode(TryNode tryNode) {
    assert tryNode.getFinallyBody() == null;
    end(tryNode);
    return tryNode.setException(lc, exceptionSymbol());
  }

  Node leaveTYPEOF(UnaryNode unaryNode) {
    var rhs = unaryNode.getExpression();
    var args = new ArrayList<Expression>();
    if (rhs instanceof IdentNode && !isParamOrVar((IdentNode) rhs)) {
      args.add(compilerConstantIdentifier(SCOPE));
      args.add(LiteralNode.newInstance(rhs, ((IdentNode) rhs).getName())); //null
    } else {
      args.add(rhs);
      args.add(LiteralNode.newInstance(unaryNode)); //null, do not reuse token of identifier rhs, it can be e.g. 'this'
    }
    var runtimeNode = new RuntimeNode(unaryNode, Request.TYPEOF, args);
    end(unaryNode);
    return runtimeNode;
  }

  FunctionNode markProgramBlock(FunctionNode functionNode) {
    return (isOnDemand || !functionNode.isProgram()) ? functionNode : functionNode.setBody(lc, functionNode.getBody().setFlag(lc, Block.IS_GLOBAL_SCOPE));
  }

  /**
   * If the symbol isn't already a scope symbol, but it needs to be (see {@link #symbolNeedsToBeScope(Symbol)}, it is promoted to a scope symbol and its block marked as needing a scope.
   * @param symbol the symbol that might be scoped
   */
  void maybeForceScope(Symbol symbol) {
    if (!symbol.isScope() && symbolNeedsToBeScope(symbol)) {
      Symbol.setSymbolIsScope(lc, symbol);
    }
  }

  Symbol newInternal(CompilerConstants cc, int flags) {
    return defineSymbol(lc.getCurrentBlock(), lc.getCurrentFunction().uniqueName(cc.symbolName()), null, IS_VAR | IS_INTERNAL | flags); //NASHORN-73
  }

  Symbol newObjectInternal(CompilerConstants cc) {
    return newInternal(cc, HAS_OBJECT_VALUE);
  }

  boolean start(Node node) {
    return start(node, true);
  }

  boolean start(Node node, boolean printNode) {
    return true;
  }

  /**
   * Determines if the symbol has to be a scope symbol.
   * In general terms, it has to be a scope symbol if it can only be reached from the current block by traversing a function node, a split node, or a with node.
   * @param symbol the symbol checked for needing to be a scope symbol
   * @return true if the symbol has to be a scope symbol.
   */
  boolean symbolNeedsToBeScope(Symbol symbol) {
    if (symbol.isThis() || symbol.isInternal()) {
      return false;
    }
    var func = lc.getCurrentFunction();
    if (func.allVarsInScope() || (!symbol.isBlockScoped() && func.isProgram())) {
      return true;
    }
    var previousWasBlock = false;
    for (var it = lc.getAllNodes(); it.hasNext();) {
      var node = it.next();
      if (node instanceof FunctionNode || isSplitLiteral(node)) {
        // We reached the function boundary or a splitting boundary without seeing a definition for the symbol.
        // It needs to be in scope.
        return true;
      } else if (node instanceof WithNode) {
        if (previousWasBlock) {
          // We reached a WithNode; the symbol must be scoped.
          // Note that if the WithNode was not immediately preceded by a block, this means we're currently processing its expression, not its body, therefore it doesn't count.
          return true;
        }
        previousWasBlock = false;
      } else if (node instanceof Block b) {
        if (b.getExistingSymbol(symbol.getName()) == symbol) {
          // We reached the block that defines the symbol without reaching either the function boundary, or a
          // WithNode. The symbol need not be scoped.
          return false;
        }
        previousWasBlock = true;
      } else {
        previousWasBlock = false;
      }
    }
    throw new AssertionError();
  }

  static boolean isSplitLiteral(LexicalContextNode expr) {
    return expr instanceof Splittable && ((Splittable) expr).getSplitRanges() != null;
  }

  void throwUnprotectedSwitchError(VarNode varNode) {
    // Block scoped declarations in switch statements without explicit blocks should be declared in a common block that contains all the case clauses.
    // We cannot support this without a fundamental rewrite of how switch statements are handled (case nodes contain blocks and are directly contained by switch node).
    // As a temporary solution we throw a reference error here.
    var msg = ECMAErrors.getMessage("syntax.error.unprotected.switch.declaration", varNode.isLet() ? "let" : "const");
    throwParserException(msg, varNode);
  }

  void throwParserException(String message, Node origin) {
    if (origin == null) {
      throw new ParserException(message);
    }
    var source = compiler.getSource();
    var token = origin.getToken();
    var line = source.getLine(origin.getStart());
    var column = source.getColumn(origin.getStart());
    var formatted = ErrorManager.format(message, source, line, column, token);
    throw new ParserException(JSErrorType.SYNTAX_ERROR, formatted, source, line, column, token);
  }

}
