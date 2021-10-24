package es.codegen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.regex.Pattern;

import es.ir.AccessNode;
import es.ir.BaseNode;
import es.ir.BinaryNode;
import es.ir.Block;
import es.ir.BlockLexicalContext;
import es.ir.BlockStatement;
import es.ir.BreakNode;
import es.ir.CallNode;
import es.ir.CaseNode;
import es.ir.CatchNode;
import es.ir.ClassNode;
import es.ir.ContinueNode;
import es.ir.DebuggerNode;
import es.ir.EmptyNode;
import es.ir.Expression;
import es.ir.ExpressionStatement;
import es.ir.ForNode;
import es.ir.FunctionNode;
import es.ir.IdentNode;
import es.ir.IfNode;
import es.ir.IndexNode;
import es.ir.JumpStatement;
import es.ir.JumpToInlinedFinally;
import es.ir.LabelNode;
import es.ir.LexicalContext;
import es.ir.LiteralNode;
import es.ir.LiteralNode.ArrayLiteralNode;
import es.ir.LiteralNode.PrimitiveLiteralNode;
import es.ir.LoopNode;
import es.ir.Node;
import es.ir.ObjectNode;
import es.ir.ReturnNode;
import es.ir.RuntimeNode;
import es.ir.Statement;
import es.ir.SwitchNode;
import es.ir.ThrowNode;
import es.ir.TryNode;
import es.ir.UnaryNode;
import es.ir.VarNode;
import es.ir.WhileNode;
import es.ir.WithNode;
import es.ir.visitor.NodeOperatorVisitor;
import es.ir.visitor.SimpleNodeVisitor;
import es.parser.Token;
import es.parser.TokenType;
import es.runtime.Context;
import es.runtime.ECMAErrors;
import es.runtime.ErrorManager;
import es.runtime.JSType;
import es.runtime.Source;
import es.runtime.logging.DebugLogger;
import es.runtime.logging.Loggable;
import es.runtime.logging.Logger;
import static es.codegen.CompilerConstants.*;
import static es.ir.Expression.isAlwaysTrue;

/**
 * Lower to more primitive operations.
 *
 * After lowering, an AST still has no symbols and types, but several nodes have been turned into more low level constructs and control flow termination criteria have been computed.
 *
 * We do things like code copying/inlining of finallies here, as it is much harder and context dependent to do any code copying after symbols have been finalized.
 */
@Logger(name = "lower")
final class Lower extends NodeOperatorVisitor<BlockLexicalContext> implements Loggable {

  private final DebugLogger log;
  private final Source source;

  // Conservative pattern to test if element names consist of characters valid for identifiers.
  // This matches any non-zero length alphanumeric string including _ and $ and not starting with a digit.
  private static final Pattern SAFE_PROPERTY_NAME = Pattern.compile("[a-zA-Z_$][\\w$]*");

  /**
   * Constructor.
   */
  Lower(Compiler compiler) {
    super(new BlockLexicalContext() {

      @Override
      public List<Statement> popStatements() {
        var newStatements = new ArrayList<Statement>();
        boolean terminated = false;
        var statements = super.popStatements();
        for (var statement : statements) {
          if (!terminated) {
            newStatements.add(statement);
            if (statement.isTerminal() || statement instanceof JumpStatement) { //TODO hasGoto? But some Loops are hasGoto too - why?
              terminated = true;
            }
          } else {
            FoldConstants.extractVarNodesFromDeadCode(statement, newStatements);
          }
        }
        return newStatements;
      }

      @Override
      protected Block afterSetStatements(Block block) {
        var stmts = block.getStatements();
        for (var li = stmts.listIterator(stmts.size()); li.hasPrevious();) {
          var stmt = li.previous();
          // popStatements() guarantees that the only thing after a terminal statement are uninitialized VarNodes.
          // We skip past those, and set the terminal state of the block to the value of the terminal state of the first statement that is not an uninitialized VarNode.
          if (!(stmt instanceof VarNode && ((VarNode) stmt).getInit() == null)) {
            return block.setIsTerminal(this, stmt.isTerminal());
          }
        }
        return block.setIsTerminal(this, false);
      }
    });

    this.log = initLogger(compiler.getContext());
    this.source = compiler.getSource();
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
  public boolean enterBreakNode(BreakNode breakNode) {
    addStatement(breakNode);
    return false;
  }

  @Override
  public Node leaveCallNode(CallNode callNode) {
    return checkEval(callNode.setFunction(markerFunction(callNode.getFunction())));
  }

  @Override
  public boolean enterCatchNode(CatchNode catchNode) {
    var exception = catchNode.getException();
    if ((exception != null) && !(exception instanceof IdentNode)) {
      throwNotImplementedYet("es6.destructuring", exception);
    }
    return true;
  }

  @Override
  public Node leaveCatchNode(CatchNode catchNode) {
    return addStatement(catchNode);
  }

  @Override
  public boolean enterContinueNode(ContinueNode continueNode) {
    addStatement(continueNode);
    return false;
  }

  @Override
  public boolean enterDebuggerNode(DebuggerNode debuggerNode) {
    var line = debuggerNode.getLineNumber();
    var token = debuggerNode.getToken();
    var finish = debuggerNode.getFinish();
    addStatement(new ExpressionStatement(line, token, finish, new RuntimeNode(token, finish, RuntimeNode.Request.DEBUGGER, new ArrayList<Expression>())));
    return false;
  }

  @Override
  public boolean enterJumpToInlinedFinally(JumpToInlinedFinally jumpToInlinedFinally) {
    addStatement(jumpToInlinedFinally);
    return false;
  }

  @Override
  public boolean enterEmptyNode(EmptyNode emptyNode) {
    return false;
  }

  @Override
  public Node leaveIndexNode(IndexNode indexNode) {
    var name = getConstantPropertyName(indexNode.getIndex());
    if (name != null) {
      // If index node is a constant property name convert index node to access node.
      assert indexNode.isIndex();
      return new AccessNode(indexNode.getToken(), indexNode.getFinish(), indexNode.getBase(), name);
    }
    return super.leaveIndexNode(indexNode);
  }

  @Override
  public Node leaveDELETE(UnaryNode delete) {
    var expression = delete.getExpression();
    return (expression instanceof IdentNode || expression instanceof BaseNode) ? delete
      : new BinaryNode(Token.recast(delete.getToken(), TokenType.COMMARIGHT), expression, LiteralNode.newInstance(delete.getToken(), delete.getFinish(), true));
  }

  // If expression is a primitive literal that is not an array index and does return its string value. Else return null.
  static String getConstantPropertyName(Expression expression) {
    if (expression instanceof LiteralNode.PrimitiveLiteralNode n) {
      var value = n.getValue();
      if (value instanceof String s && SAFE_PROPERTY_NAME.matcher(s).matches()) {
        return s;
      }
    }
    return null;
  }

  @Override
  public Node leaveExpressionStatement(ExpressionStatement expressionStatement) {
    var expr = expressionStatement.getExpression();
    var node = expressionStatement;
    var currentFunction = lc.getCurrentFunction();
    if (currentFunction.isProgram()) {
      if (!isInternalExpression(expr) && !isEvalResultAssignment(expr)) {
        node = expressionStatement.setExpression(new BinaryNode(Token.recast(expressionStatement.getToken(), TokenType.ASSIGN), compilerConstant(RETURN), expr));
      }
    }
    if (expressionStatement.destructuringDeclarationType() != null) {
      throwNotImplementedYet("es6.destructuring", expressionStatement);
    }
    return addStatement(node);
  }

  @Override
  public Node leaveBlockStatement(BlockStatement blockStatement) {
    return addStatement(blockStatement);
  }

  @Override
  public boolean enterForNode(ForNode forNode) {
    if ((forNode.getInit() instanceof ObjectNode || forNode.getInit() instanceof ArrayLiteralNode)) {
      throwNotImplementedYet("es6.destructuring", forNode);
    }
    return super.enterForNode(forNode);
  }

  @Override
  public Node leaveForNode(ForNode forNode) {
    var newForNode = forNode;
    var test = forNode.getTest();
    if (!forNode.isForInOrOf() && isAlwaysTrue(test)) {
      newForNode = forNode.setTest(lc, null);
    }
    newForNode = checkEscape(newForNode);
    addStatement(newForNode);
    return newForNode;
  }

  @Override
  public boolean enterFunctionNode(FunctionNode functionNode) {
    if (functionNode.getKind() == FunctionNode.Kind.MODULE) {
      throwNotImplementedYet("es6.module", functionNode);
    }
    if (functionNode.getKind() == FunctionNode.Kind.GENERATOR) {
      throwNotImplementedYet("es6.generator", functionNode);
    }
    if (functionNode.usesSuper()) {
      throwNotImplementedYet("es6.super", functionNode);
    }
    var numParams = functionNode.getNumOfParams();
    if (numParams > 0) {
      var lastParam = functionNode.getParameter(numParams - 1);
      if (lastParam.isRestParameter()) {
        throwNotImplementedYet("es6.rest.param", lastParam);
      }
    }
    for (var param : functionNode.getParameters()) {
      if (param.isDestructuredParameter()) {
        throwNotImplementedYet("es6.destructuring", functionNode);
      }
    }
    return super.enterFunctionNode(functionNode);
  }

  @Override
  public Node leaveFunctionNode(FunctionNode functionNode) {
    log.info("END FunctionNode: ", functionNode.getName());
    return functionNode;
  }

  @Override
  public Node leaveIfNode(IfNode ifNode) {
    return addStatement(ifNode);
  }

  @Override
  public Node leaveIN(BinaryNode binaryNode) {
    return new RuntimeNode(binaryNode);
  }

  @Override
  public Node leaveINSTANCEOF(BinaryNode binaryNode) {
    return new RuntimeNode(binaryNode);
  }

  @Override
  public Node leaveLabelNode(LabelNode labelNode) {
    return addStatement(labelNode);
  }

  @Override
  public Node leaveReturnNode(ReturnNode returnNode) {
    addStatement(returnNode); //ReturnNodes are always terminal, marked as such in constructor
    return returnNode;
  }

  @Override
  public Node leaveCaseNode(CaseNode caseNode) {
    // Try to represent the case test as an integer
    var test = caseNode.getTest();
    if (test instanceof LiteralNode) {
      var lit = (LiteralNode<?>) test;
      if (lit.isNumeric() && !(lit.getValue() instanceof Integer)) {
        if (JSType.isRepresentableAsInt(lit.getNumber())) {
          return caseNode.setTest((Expression) LiteralNode.newInstance(lit, lit.getInt32()).accept(this));
        }
      }
    }
    return caseNode;
  }

  @Override
  public Node leaveSwitchNode(SwitchNode switchNode) {
    if (!switchNode.isUniqueInteger()) {
      // Wrap it in a block so its internally created tag is restricted in scope
      addStatementEnclosedInBlock(switchNode);
    } else {
      addStatement(switchNode);
    }
    return switchNode;
  }

  @Override
  public Node leaveThrowNode(ThrowNode throwNode) {
    return addStatement(throwNode); //ThrowNodes are always terminal, marked as such in constructor
  }

  @SuppressWarnings("unchecked")
  static <T extends Node> T ensureUniqueNamesIn(T node) {
    return (T) node.accept(new SimpleNodeVisitor() {
      @Override
      public Node leaveFunctionNode(FunctionNode functionNode) {
        var name = functionNode.getName();
        return functionNode.setName(lc, lc.getCurrentFunction().uniqueName(name));
      }
      @Override
      public Node leaveDefault(Node labelledNode) {
        return labelledNode.ensureUniqueLabels(lc);
      }
    });
  }

  static Block createFinallyBlock(Block finallyBody) {
    var newStatements = new ArrayList<Statement>();
    for (var statement : finallyBody.getStatements()) {
      newStatements.add(statement);
      if (statement.hasTerminalFlags()) {
        break;
      }
    }
    return finallyBody.setStatements(null, newStatements);
  }

  Block catchAllBlock(TryNode tryNode) {
    var lineNumber = tryNode.getLineNumber();
    var token = tryNode.getToken();
    var finish = tryNode.getFinish();
    var exception = new IdentNode(token, finish, lc.getCurrentFunction().uniqueName(CompilerConstants.EXCEPTION_PREFIX.symbolName()));
    var catchBody = new Block(token, finish, new ThrowNode(lineNumber, token, finish, new IdentNode(exception), true));
    assert catchBody.isTerminal(); //ends with throw, so terminal
    var catchAllNode = new CatchNode(lineNumber, token, finish, new IdentNode(exception), null, catchBody, true);
    var catchAllBlock = new Block(token, finish, catchAllNode);
    // catchallblock -> catchallnode (catchnode) -> exception -> throw
    return (Block) catchAllBlock.accept(this); //not accepted. has to be accepted by lower
  }

  IdentNode compilerConstant(CompilerConstants cc) {
    var functionNode = lc.getCurrentFunction();
    return new IdentNode(functionNode.getToken(), functionNode.getFinish(), cc.symbolName());
  }

  static boolean isTerminalFinally(Block finallyBlock) {
    return finallyBlock.getLastStatement().hasTerminalFlags();
  }

  /**
   * Splice finally code into all endpoints of a trynode
   * @param tryNode the try node
   * @param rethrow the rethrowing throw nodes from the synthetic catch block
   * @param finallyBody the code in the original finally block
   * @return new try node after splicing finally code (same if nop)
   */
  TryNode spliceFinally(TryNode tryNode, ThrowNode rethrow, Block finallyBody) {
    assert tryNode.getFinallyBody() == null;
    var finallyBlock = createFinallyBlock(finallyBody);
    var inlinedFinallies = new ArrayList<Block>();
    var fn = lc.getCurrentFunction();
    var newTryNode = (TryNode) tryNode.accept(new SimpleNodeVisitor() {

      @Override
      public boolean enterFunctionNode(FunctionNode functionNode) {
        // do not enter function nodes - finally code should not be inlined into them
        return false;
      }

      @Override
      public Node leaveThrowNode(ThrowNode throwNode) {
        return (rethrow == throwNode) ? new BlockStatement(prependFinally(finallyBlock, throwNode)) : throwNode;
      }

      @Override
      public Node leaveBreakNode(BreakNode breakNode) {
        return leaveJumpStatement(breakNode);
      }

      @Override
      public Node leaveContinueNode(ContinueNode continueNode) {
        return leaveJumpStatement(continueNode);
      }

      // NOTE: leaveJumpToInlinedFinally deliberately does not delegate to this method, only break and continue are edited.
      // JTIF nodes should not be changed, rather the surroundings of break/continue/return that were moved into the inlined finally block itself will be changed.
      Node leaveJumpStatement(JumpStatement jump) {
        // If this visitor's lc doesn't find the target of the jump, it means it's external to the try block.
        return (jump.getTarget(lc) == null) ? createJumpToInlinedFinally(fn, inlinedFinallies, prependFinally(finallyBlock, jump)) : jump;
      }

      @Override
      public Node leaveReturnNode(ReturnNode returnNode) {
        var expr = returnNode.getExpression();
        if (isTerminalFinally(finallyBlock)) {
          if (expr == null) {
            // Terminal finally; no return expression.
            return createJumpToInlinedFinally(fn, inlinedFinallies, ensureUniqueNamesIn(finallyBlock));
          }
          // Terminal finally; has a return expression.
          var newStatements = new ArrayList<Statement>(2);
          var retLineNumber = returnNode.getLineNumber();
          var retToken = returnNode.getToken();
          // Expression is evaluated for side effects.
          newStatements.add(new ExpressionStatement(retLineNumber, retToken, returnNode.getFinish(), expr));
          newStatements.add(createJumpToInlinedFinally(fn, inlinedFinallies, ensureUniqueNamesIn(finallyBlock)));
          return new BlockStatement(retLineNumber, new Block(retToken, finallyBlock.getFinish(), newStatements));
        } else if (expr == null || expr instanceof PrimitiveLiteralNode<?> || (expr instanceof IdentNode && RETURN.symbolName().equals(((IdentNode) expr).getName()))) {
          // Nonterminal finally; no return expression, or returns a primitive literal, or returns :return.
          // Just move the return expression into the finally block.
          return createJumpToInlinedFinally(fn, inlinedFinallies, prependFinally(finallyBlock, returnNode));
        } else {
          // We need to evaluate the result of the return in case it is complex while still in the try block, store it in :return, and return it afterwards.
          var newStatements = new ArrayList<Statement>();
          var retLineNumber = returnNode.getLineNumber();
          var retToken = returnNode.getToken();
          var retFinish = returnNode.getFinish();
          var resultNode = new IdentNode(expr.getToken(), expr.getFinish(), RETURN.symbolName());
          // ":return = <expr>;"
          newStatements.add(new ExpressionStatement(retLineNumber, retToken, retFinish, new BinaryNode(Token.recast(returnNode.getToken(), TokenType.ASSIGN), resultNode, expr)));
          // inline finally and end it with "return :return;"
          newStatements.add(createJumpToInlinedFinally(fn, inlinedFinallies, prependFinally(finallyBlock, returnNode.setExpression(resultNode))));
          return new BlockStatement(retLineNumber, new Block(retToken, retFinish, newStatements));
        }
      }
    });
    addStatement(inlinedFinallies.isEmpty() ? newTryNode : newTryNode.setInlinedFinallies(lc, inlinedFinallies));
    // TODO: if finallyStatement is terminal, we could just have sites of inlined finallies jump here.
    addStatement(new BlockStatement(finallyBlock));
    return newTryNode;
  }

  static JumpToInlinedFinally createJumpToInlinedFinally(FunctionNode fn, List<Block> inlinedFinallies, Block finallyBlock) {
    var labelName = fn.uniqueName(":finally");
    var token = finallyBlock.getToken();
    var finish = finallyBlock.getFinish();
    inlinedFinallies.add(new Block(token, finish, new LabelNode(finallyBlock.getFirstStatementLineNumber(), token, finish, labelName, finallyBlock)));
    return new JumpToInlinedFinally(labelName);
  }

  static Block prependFinally(Block finallyBlock, Statement statement) {
    var inlinedFinally = ensureUniqueNamesIn(finallyBlock);
    if (isTerminalFinally(finallyBlock)) {
      return inlinedFinally;
    }
    var stmts = inlinedFinally.getStatements();
    var newStmts = new ArrayList<Statement>(stmts.size() + 1);
    newStmts.addAll(stmts);
    newStmts.add(statement);
    return new Block(inlinedFinally.getToken(), statement.getFinish(), newStmts);
  }

  @Override
  public Node leaveTryNode(TryNode tryNode) {
    var finallyBody = tryNode.getFinallyBody();
    var newTryNode = tryNode.setFinallyBody(lc, null);
    // No finally or empty finally
    if (finallyBody == null || finallyBody.getStatementCount() == 0) {
      var catches = newTryNode.getCatches();
      if (catches == null || catches.isEmpty()) {
        // A completely degenerate try block: empty finally, no catches. Replace it with try body.
        return addStatement(new BlockStatement(tryNode.getBody()));
      }
      return addStatement(ensureUnconditionalCatch(newTryNode));
    }

    /**
     * create a new try node
     *    if we have catches:
     *
     *    try            try
     *       x              try
     *    catch               x
     *       y              catch
     *    finally z           y
     *                   catchall
     *                        rethrow
     *
     *   otherwise
     *
     *   try              try
     *      x               x
     *   finally          catchall
     *      y               rethrow
     *
     *   now splice in finally code wherever needed
     */
    var catchAll = catchAllBlock(tryNode);
    var rethrows = new ArrayList<ThrowNode>(1);
    catchAll.accept(new SimpleNodeVisitor() {
      @Override
      public boolean enterThrowNode(ThrowNode throwNode) {
        rethrows.add(throwNode);
        return true;
      }
    });
    assert rethrows.size() == 1;
    if (!tryNode.getCatchBlocks().isEmpty()) {
      var outerBody = new Block(newTryNode.getToken(), newTryNode.getFinish(), ensureUnconditionalCatch(newTryNode));
      newTryNode = newTryNode.setBody(lc, outerBody).setCatchBlocks(lc, null);
    }
    newTryNode = newTryNode.setCatchBlocks(lc, Arrays.asList(catchAll));
    // Now that the transform is done, we have to go into the try and splice the finally block in front of any statement that is outside the try
    return (TryNode) lc.replace(tryNode, spliceFinally(newTryNode, rethrows.get(0), finallyBody));
  }

  TryNode ensureUnconditionalCatch(TryNode tryNode) {
    var catches = tryNode.getCatches();
    if (catches == null || catches.isEmpty() || catches.get(catches.size() - 1).getExceptionCondition() == null) {
      return tryNode;
    }
    // If the last catch block is conditional, add an unconditional rethrow block
    var newCatchBlocks = new ArrayList<Block>(tryNode.getCatchBlocks());
    newCatchBlocks.add(catchAllBlock(tryNode));
    return tryNode.setCatchBlocks(lc, newCatchBlocks);
  }

  @Override
  public boolean enterUnaryNode(UnaryNode unaryNode) {
    if (unaryNode.isTokenType(TokenType.YIELD) || unaryNode.isTokenType(TokenType.YIELD_STAR)) {
      throwNotImplementedYet("es6.yield", unaryNode);
    } else if (unaryNode.isTokenType(TokenType.SPREAD_ARGUMENT) || unaryNode.isTokenType(TokenType.SPREAD_ARRAY)) {
      throwNotImplementedYet("es6.spread", unaryNode);
    }
    return super.enterUnaryNode(unaryNode);
  }

  @Override
  public boolean enterASSIGN(BinaryNode binaryNode) {
    if ((binaryNode.lhs() instanceof ObjectNode || binaryNode.lhs() instanceof ArrayLiteralNode)) {
      throwNotImplementedYet("es6.destructuring", binaryNode);
    }
    return super.enterASSIGN(binaryNode);
  }

  @Override
  public Node leaveVarNode(VarNode varNode) {
    addStatement(varNode);
    if (varNode.getFlag(VarNode.IS_LAST_FUNCTION_DECLARATION) && lc.getCurrentFunction().isProgram() && ((FunctionNode) varNode.getInit()).isAnonymous()) {
      new ExpressionStatement(varNode.getLineNumber(), varNode.getToken(), varNode.getFinish(), new IdentNode(varNode.getName())).accept(this);
    }
    return varNode;
  }

  @Override
  public Node leaveWhileNode(WhileNode whileNode) {
    var test = whileNode.getTest();
    var body = whileNode.getBody();
    if (isAlwaysTrue(test)) {
      // turn it into a for node without a test.
      var forNode = (ForNode) new ForNode(whileNode.getLineNumber(), whileNode.getToken(), whileNode.getFinish(), body, 0).accept(this);
      lc.replace(whileNode, forNode);
      return forNode;
    }
    return addStatement(checkEscape(whileNode));
  }

  @Override
  public Node leaveWithNode(WithNode withNode) {
    return addStatement(withNode);
  }

  @Override
  public boolean enterClassNode(ClassNode classNode) {
    throwNotImplementedYet("es6.class", classNode);
    return super.enterClassNode(classNode);
  }

  /**
   * Given a function node that is a callee in a CallNode, replace it with the appropriate marker function.
   * This is used by {@link CodeGenerator} for fast scope calls
   * @param function function called by a CallNode
   * @return transformed node to marker function or identity if not ident/access/indexnode
   */
  static Expression markerFunction(Expression function) {
    return (function instanceof IdentNode i) ? i.setIsFunction()
         : (function instanceof BaseNode b) ? b.setIsFunction()
         : function;
  }

  /**
   * Calculate a synthetic eval location for a node for the stacktrace, for example src#17<eval>
   * @param node a node
   * @return eval location
   */
  String evalLocation(IdentNode node) {
    var s = lc.getCurrentFunction().getSource();
    var pos = node.position();
    return s.getName() + '#' + s.getLine(pos) + ':' + s.getColumn(pos) + "<eval>";
  }

  /**
   * Check whether a call node may be a call to eval.
   * In that case we clone the args in order to create the following construct in {@link CodeGenerator}
   *
   * <pre>
   * if (calledFuntion == buildInEval) {
   *    eval(cloned arg);
   * } else {
   *    cloned arg;
   * }
   * </pre>
   *
   * @param callNode call node to check if it's an eval
   */
  CallNode checkEval(CallNode callNode) {
    if (callNode.getFunction() instanceof IdentNode callee) {
      var args = callNode.getArgs();
      // 'eval' call with at least one argument
      if (args.size() >= 1 && EVAL.symbolName().equals(callee.getName())) {
        var evalArgs = new ArrayList<Expression>(args.size());
        for (var arg : args) {
          evalArgs.add((Expression) ensureUniqueNamesIn(arg).accept(this));
        }
        return callNode.setEvalArgs(new CallNode.EvalArgs(evalArgs, evalLocation(callee)));
      }
    }
    return callNode;
  }

  /**
   * Helper that given a loop body makes sure that it is not terminal if it has a continue that leads to the loop header or to outer loops' loop headers.
   * This means that, even if the body ends with a terminal statement, we cannot tag it as terminal
   * @param loopBody the loop body to check
   * @return true if control flow may escape the loop
   */
  static boolean controlFlowEscapes(LexicalContext lex, Block loopBody) {
    var escapes = new ArrayList<Node>();
    loopBody.accept(new SimpleNodeVisitor() {
      @Override
      public Node leaveBreakNode(BreakNode node) {
        escapes.add(node);
        return node;
      }
      @Override
      public Node leaveContinueNode(ContinueNode node) {
        // all inner loops have been popped.
        if (lex.contains(node.getTarget(lex))) {
          escapes.add(node);
        }
        return node;
      }
    });
    return !escapes.isEmpty();
  }

  @SuppressWarnings("unchecked")
  <T extends LoopNode> T checkEscape(T loopNode) {
    var escapes = controlFlowEscapes(lc, loopNode.getBody());
    return escapes ? (T) loopNode.setBody(lc, loopNode.getBody().setIsTerminal(lc, false)).setControlFlowEscapes(lc, escapes) : loopNode;
  }

  Node addStatement(Statement statement) {
    lc.appendStatement(statement);
    return statement;
  }

  void addStatementEnclosedInBlock(Statement stmt) {
    var b = BlockStatement.createReplacement(stmt, Collections.<Statement>singletonList(stmt));
    if (stmt.isTerminal()) {
      b = b.setBlock(b.getBlock().setIsTerminal(null, true));
    }
    addStatement(b);
  }

  /**
   * An internal expression has a symbol that is tagged internal.
   * Check if this is such a node
   * @param expression expression to check for internal symbol
   * @return true if internal, false otherwise
   */
  static boolean isInternalExpression(Expression expression) {
    if (!(expression instanceof IdentNode)) {
      return false;
    }
    var symbol = ((IdentNode) expression).getSymbol();
    return symbol != null && symbol.isInternal();
  }

  /**
   * Is this an assignment to the special variable that hosts scripting eval results, i.e. __return__?
   * @param expression expression to check whether it is $evalresult = X
   * @return true if an assignment to eval result, false otherwise
   */
  static boolean isEvalResultAssignment(Node expression) {
    var e = expression;
    if (e instanceof BinaryNode b) {
      var lhs = b.lhs();
      if (lhs instanceof IdentNode i) {
        return i.getName().equals(RETURN.symbolName());
      }
    }
    return false;
  }

  void throwNotImplementedYet(String msgId, Node node) {
    var token = node.getToken();
    var line = source.getLine(node.getStart());
    var column = source.getColumn(node.getStart());
    var message = ECMAErrors.getMessage("unimplemented." + msgId);
    var formatted = ErrorManager.format(message, source, line, column, token);
    throw new RuntimeException(formatted);
  }

}
