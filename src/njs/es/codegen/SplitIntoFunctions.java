package es.codegen;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Deque;
import java.util.List;
import java.util.Objects;

import es.ir.AccessNode;
import es.ir.BinaryNode;
import es.ir.Block;
import es.ir.BlockLexicalContext;
import es.ir.BreakNode;
import es.ir.CallNode;
import es.ir.CaseNode;
import es.ir.ContinueNode;
import es.ir.Expression;
import es.ir.ExpressionStatement;
import es.ir.FunctionNode;
import es.ir.GetSplitState;
import es.ir.IdentNode;
import es.ir.IfNode;
import es.ir.JumpStatement;
import es.ir.JumpToInlinedFinally;
import es.ir.LiteralNode;
import es.ir.Node;
import es.ir.ReturnNode;
import es.ir.SetSplitState;
import es.ir.SplitNode;
import es.ir.SplitReturn;
import es.ir.Statement;
import es.ir.SwitchNode;
import es.ir.VarNode;
import es.ir.visitor.NodeVisitor;
import es.parser.Token;
import es.parser.TokenType;
import static es.ir.Node.*;

/**
 * A node visitor that replaces {@link SplitNode}s with anonymous function invocations and some additional constructs to support control flow across splits.
 *
 * By using this transformation, split functions are translated into ordinary JavaScript functions with nested anonymous functions.
 * The transformations however introduce several AST nodes that have no JavaScript source representations ({@link GetSplitState}, {@link SetSplitState}, and {@link SplitReturn}), and therefore such function is no longer reparseable from its source.
 * For that reason, split functions and their fragments are serialized in-memory and deserialized when they need to be recompiled either for deoptimization or for type specialization.
 *
 * NOTE: all {@code leave*()} methods for statements are returning their input nodes.
 * That way, they will not mutate the original statement list in the block containing the statement, which is fine, as it'll be replaced by the lexical context when the block is left.
 * If we returned something else (e.g. null), we'd cause a mutation in the enclosing block's statement list that is otherwise overwritten later anyway.
 */
final class SplitIntoFunctions extends NodeVisitor<BlockLexicalContext> {

  private static final int FALLTHROUGH_STATE = -1;
  private static final int RETURN_STATE = 0;
  private static final int BREAK_STATE = 1;
  private static final int FIRST_JUMP_STATE = 2;

  private static final String THIS_NAME = CompilerConstants.THIS.symbolName();
  private static final String RETURN_NAME = CompilerConstants.RETURN.symbolName();
  // Used as the name of the formal parameter for passing the current value of :return symbol into a split fragment.
  private static final String RETURN_PARAM_NAME = RETURN_NAME + "-in";

  private final Deque<FunctionState> functionStates = new ArrayDeque<>();
  private final Deque<SplitState> splitStates = new ArrayDeque<>();
  private final Namespace namespace;

  private boolean artificialBlock = false;

  // -1 is program; we need to use negative ones
  private int nextFunctionId = -2;

  public SplitIntoFunctions(Compiler compiler) {
    super(new BlockLexicalContext() {
      @Override
      protected Block afterSetStatements(Block block) {
        for (var stmt : block.getStatements()) {
          assert !(stmt instanceof SplitNode);
        }
        return block;
      }
    });
    namespace = new Namespace(compiler.getScriptEnvironment().getNamespace());
  }

  @Override
  public boolean enterFunctionNode(FunctionNode functionNode) {
    functionStates.push(new FunctionState(functionNode));
    return true;
  }

  @Override
  public Node leaveFunctionNode(FunctionNode functionNode) {
    functionStates.pop();
    return functionNode;
  }

  @Override
  protected Node leaveDefault(Node node) {
    if (node instanceof Statement s) {
      appendStatement(s);
    }
    return node;
  }

  @Override
  public boolean enterSplitNode(SplitNode splitNode) {
    getCurrentFunctionState().splitDepth++;
    splitStates.push(new SplitState(splitNode));
    return true;
  }

  @Override
  public Node leaveSplitNode(SplitNode splitNode) {
    // Replace the split node with an anonymous function expression call.
    var fnState = getCurrentFunctionState();
    var name = splitNode.getName();
    var body = splitNode.getBody();
    var firstLineNumber = body.getFirstStatementLineNumber();
    var token = body.getToken();
    var finish = body.getFinish();
    var originalFn = fnState.fn;
    assert originalFn == lc.getCurrentFunction();
    var isProgram = originalFn.isProgram();
    // Change SplitNode({...}) into "function () { ... }", or "function (:return-in) () { ... }" (for program)
    var newFnToken = Token.toDesc(TokenType.FUNCTION, nextFunctionId--, 0);
    var fn = new FunctionNode(
      originalFn.getSource(),
      body.getFirstStatementLineNumber(),
      newFnToken,
      finish,
      newFnToken,
      NO_TOKEN,
      namespace,
      createIdent(name),
      originalFn.getName() + "$" + name,
      isProgram ? Collections.singletonList(createReturnParamIdent()) : Collections.<IdentNode>emptyList(),
      null,
      FunctionNode.Kind.NORMAL,
      // We only need IS_SPLIT conservatively, in case it contains any array units so that we force the :callee's existence, to force :scope to never be in a slot lower than 2.
      // This is actually quite a horrible hack to do with CodeGenerator.fixScopeSlot not trampling other parameters and should go away once we no longer have array unit handling in codegen.
      // Note however that we still use IS_SPLIT as the criteria in CompilationPhase.SERIALIZE_SPLIT_PHASE.
      FunctionNode.IS_ANONYMOUS | FunctionNode.USES_ANCESTOR_SCOPE | FunctionNode.IS_SPLIT,
      body,
      null,
      originalFn.getModule()
    ).setCompileUnit(lc, splitNode.getCompileUnit());

    // Call the function:
    //   either "(function () { ... }).call(this)"
    //   or     "(function (:return-in) { ... }).call(this, :return)"
    // NOTE: Function.call() has optimized linking that basically does a pass-through to the function being invoked.
    // NOTE: CompilationPhase.PROGRAM_POINT_PHASE happens after this, so these calls are subject to optimistic assumptions on their return value (when they return a value), as they should be.
    var thisIdent = createIdent(THIS_NAME);
    var callNode = new CallNode(firstLineNumber, token, finish, new AccessNode(NO_TOKEN, NO_FINISH, fn, "call"),
      isProgram ? Arrays.<Expression>asList(thisIdent, createReturnIdent())
                : Collections.<Expression>singletonList(thisIdent),
      false);
    var splitState = splitStates.pop();
    fnState.splitDepth--;
    Expression callWithReturn;
    var hasReturn = splitState.hasReturn;
    if (hasReturn && fnState.splitDepth > 0) {
      var parentSplit = splitStates.peek();
      if (parentSplit != null) {
        // Propagate hasReturn to parent split
        parentSplit.hasReturn = true;
      }
    }
    if (hasReturn || isProgram) {
      // capture return value: ":return = (function () { ... })();"
      callWithReturn = new BinaryNode(Token.recast(token, TokenType.ASSIGN), createReturnIdent(), callNode);
    } else {
      // no return value, just call : "(function () { ... })();"
      callWithReturn = callNode;
    }
    appendStatement(new ExpressionStatement(firstLineNumber, token, finish, callWithReturn));
    Statement splitStateHandler;
    var jumpStatements = splitState.jumpStatements;
    var jumpCount = jumpStatements.size();
    // There are jumps (breaks or continues) that need to be propagated outside the split node.
    // We need to set up a switch statement for them:
    //   switch(:scope.getScopeState()) { ... }
    if (jumpCount > 0) {
      var cases = new ArrayList<CaseNode>(jumpCount + (hasReturn ? 1 : 0));
      if (hasReturn) {
        // If the split node also contained a return, we'll slip it as a case in the switch statement
        addCase(cases, RETURN_STATE, createReturnFromSplit());
      }
      var i = FIRST_JUMP_STATE;
      for (var jump : jumpStatements) {
        addCase(cases, i++, enblockAndVisit(jump));
      }
      splitStateHandler = new SwitchNode(NO_LINE_NUMBER, token, finish, GetSplitState.INSTANCE, cases, null);
    } else {
      splitStateHandler = null;
    }
    // As the switch statement itself is breakable, an unlabelled break can't be in the switch statement, so we need to test for it separately.
    if (splitState.hasBreak) {
      // if(:scope.getScopeState() == Scope.BREAK) { break; }
      splitStateHandler = makeIfStateEquals(firstLineNumber, token, finish, BREAK_STATE, enblockAndVisit(new BreakNode(NO_LINE_NUMBER, token, finish, null)), splitStateHandler);
    }
    // Finally, if the split node had a return statement, but there were no external jumps, we didn't have the switch statement to handle the return, so we need a separate if for it.
    if (hasReturn && jumpCount == 0) {
      // if (:scope.getScopeState() == Scope.RETURN) { return :return; }
      splitStateHandler = makeIfStateEquals(NO_LINE_NUMBER, token, finish, RETURN_STATE, createReturnFromSplit(), splitStateHandler);
    }
    if (splitStateHandler != null) {
      appendStatement(splitStateHandler);
    }
    return splitNode;
  }

  static void addCase(List<CaseNode> cases, int i, Block body) {
    cases.add(new CaseNode(NO_TOKEN, NO_FINISH, intLiteral(i), body));
  }

  static LiteralNode<Number> intLiteral(int i) {
    return LiteralNode.newInstance(NO_TOKEN, NO_FINISH, i);
  }

  static Block createReturnFromSplit() {
    return new Block(NO_TOKEN, NO_FINISH, createReturnReturn());
  }

  static ReturnNode createReturnReturn() {
    return new ReturnNode(NO_LINE_NUMBER, NO_TOKEN, NO_FINISH, createReturnIdent());
  }

  static IdentNode createReturnIdent() {
    return createIdent(RETURN_NAME);
  }

  static IdentNode createReturnParamIdent() {
    return createIdent(RETURN_PARAM_NAME);
  }

  static IdentNode createIdent(String name) {
    return new IdentNode(NO_TOKEN, NO_FINISH, name);
  }

  Block enblockAndVisit(JumpStatement jump) {
    artificialBlock = true;
    Block block = (Block) new Block(NO_TOKEN, NO_FINISH, jump).accept(this);
    artificialBlock = false;
    return block;
  }

  static IfNode makeIfStateEquals(int lineNumber, long token, int finish, int value, Block pass, Statement fail) {
    return new IfNode(lineNumber, token, finish, new BinaryNode(Token.recast(token, TokenType.EQU), GetSplitState.INSTANCE, intLiteral(value)), pass, fail == null ? null : new Block(NO_TOKEN, NO_FINISH, fail));
  }

  @Override
  public boolean enterVarNode(VarNode varNode) {
    // ES6 block scoped declarations are already placed at their proper position by splitter
    if (!inSplitNode() || varNode.isBlockScoped()) {
      return super.enterVarNode(varNode);
    }
    var init = varNode.getInit();
    // Move a declaration-only var statement to the top of the outermost function.
    getCurrentFunctionState().varStatements.add(varNode.setInit(null));
    // If it had an initializer, replace it with an assignment expression statement.
    // Note that "var" is a statement, so it doesn't contribute to :return of the programs, therefore we are _not_ adding a ":return = ..." assignment around the original assignment.
    if (init != null) {
      var token = Token.recast(varNode.getToken(), TokenType.ASSIGN);
      new ExpressionStatement(varNode.getLineNumber(), token, varNode.getFinish(), new BinaryNode(token, varNode.getName(), varNode.getInit())).accept(this);
    }
    return false;
  }

  @Override
  public Node leaveBlock(Block block) {
    if (!artificialBlock) {
      if (lc.isFunctionBody()) {
        // Prepend declaration-only var statements to the top of the statement list.
        lc.prependStatements(getCurrentFunctionState().varStatements);
      } else if (lc.isSplitBody()) {
        appendSplitReturn(FALLTHROUGH_STATE, NO_LINE_NUMBER);
        if (getCurrentFunctionState().fn.isProgram()) {
          // If we're splitting the program, make sure every shard ends with "return :return" and begins with ":return = :return-in;".
          lc.prependStatement(new ExpressionStatement(NO_LINE_NUMBER, NO_TOKEN, NO_FINISH, new BinaryNode(Token.toDesc(TokenType.ASSIGN, 0, 0), createReturnIdent(), createReturnParamIdent())));
        }
      }
    }
    return block;
  }

  @Override
  public Node leaveBreakNode(BreakNode breakNode) {
    return leaveJumpNode(breakNode);
  }

  @Override
  public Node leaveContinueNode(ContinueNode continueNode) {
    return leaveJumpNode(continueNode);
  }

  @Override
  public Node leaveJumpToInlinedFinally(JumpToInlinedFinally jumpToInlinedFinally) {
    return leaveJumpNode(jumpToInlinedFinally);
  }

  JumpStatement leaveJumpNode(JumpStatement jump) {
    if (inSplitNode()) {
      var splitState = getCurrentSplitState();
      var splitNode = splitState.splitNode;
      if (lc.isExternalTarget(splitNode, jump.getTarget(lc))) {
        appendSplitReturn(splitState.getSplitStateIndex(jump), jump.getLineNumber());
        return jump;
      }
    }
    appendStatement(jump);
    return jump;
  }

  void appendSplitReturn(int splitState, int lineNumber) {
    appendStatement(new SetSplitState(splitState, lineNumber));
    if (getCurrentFunctionState().fn.isProgram()) {
      // If we're splitting the program, make sure every fragment passes back :return
      appendStatement(createReturnReturn());
    } else {
      appendStatement(SplitReturn.INSTANCE);
    }
  }

  @Override
  public Node leaveReturnNode(ReturnNode returnNode) {
    if (inSplitNode()) {
      appendStatement(new SetSplitState(RETURN_STATE, returnNode.getLineNumber()));
      getCurrentSplitState().hasReturn = true;
    }
    appendStatement(returnNode);
    return returnNode;
  }

  void appendStatement(Statement statement) {
    lc.appendStatement(statement);
  }

  boolean inSplitNode() {
    return getCurrentFunctionState().splitDepth > 0;
  }

  FunctionState getCurrentFunctionState() {
    return functionStates.peek();
  }

  SplitState getCurrentSplitState() {
    return splitStates.peek();
  }

  static class FunctionState {

    final FunctionNode fn;
    final List<Statement> varStatements = new ArrayList<>();
    int splitDepth;

    FunctionState(FunctionNode fn) {
      this.fn = fn;
    }
  }

  static class SplitState {

    final SplitNode splitNode;
    boolean hasReturn;
    boolean hasBreak;

    final List<JumpStatement> jumpStatements = new ArrayList<>();

    int getSplitStateIndex(JumpStatement jump) {
      if (jump instanceof BreakNode && jump.getLabelName() == null) {
        // Unlabelled break is a special case
        hasBreak = true;
        return BREAK_STATE;
      }
      var i = 0;
      for (var exJump : jumpStatements) {
        if (jump.getClass() == exJump.getClass() && Objects.equals(jump.getLabelName(), exJump.getLabelName())) {
          return i + FIRST_JUMP_STATE;
        }
        ++i;
      }
      jumpStatements.add(jump);
      return i + FIRST_JUMP_STATE;
    }

    SplitState(SplitNode splitNode) {
      this.splitNode = splitNode;
    }
  }

}
