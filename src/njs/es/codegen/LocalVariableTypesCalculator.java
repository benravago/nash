package es.codegen;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Deque;
import java.util.HashMap;
import java.util.HashSet;
import java.util.IdentityHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import es.codegen.types.Type;
import es.ir.AccessNode;
import es.ir.BinaryNode;
import es.ir.Block;
import es.ir.BreakNode;
import es.ir.BreakableNode;
import es.ir.CallNode;
import es.ir.ContinueNode;
import es.ir.Expression;
import es.ir.ExpressionStatement;
import es.ir.ForNode;
import es.ir.FunctionNode;
import es.ir.GetSplitState;
import es.ir.IdentNode;
import es.ir.IfNode;
import es.ir.IndexNode;
import es.ir.JoinPredecessor;
import es.ir.JoinPredecessorExpression;
import es.ir.JumpStatement;
import es.ir.JumpToInlinedFinally;
import es.ir.LexicalContext;
import es.ir.LexicalContextNode;
import es.ir.LiteralNode;
import es.ir.LiteralNode.ArrayLiteralNode;
import es.ir.LocalVariableConversion;
import es.ir.LoopNode;
import es.ir.Node;
import es.ir.ObjectNode;
import es.ir.PropertyNode;
import es.ir.ReturnNode;
import es.ir.RuntimeNode;
import es.ir.RuntimeNode.Request;
import es.ir.SplitReturn;
import es.ir.Statement;
import es.ir.SwitchNode;
import es.ir.Symbol;
import es.ir.TernaryNode;
import es.ir.ThrowNode;
import es.ir.TryNode;
import es.ir.UnaryNode;
import es.ir.VarNode;
import es.ir.WhileNode;
import es.ir.visitor.NodeVisitor;
import es.ir.visitor.SimpleNodeVisitor;
import es.parser.TokenType;
import static es.codegen.CompilerConstants.RETURN;
import static es.ir.Expression.isAlwaysFalse;
import static es.ir.Expression.isAlwaysTrue;

/**
 * Calculates types for local variables.
 *
 * For purposes of local variable type calculation, the only types used are Undefined, boolean, int, long, double, and Object.
 * The calculation eagerly widens types of local variable to their widest at control flow join points.
 *
 * TODO: investigate a more sophisticated solution that uses use/def information to only widens the type of a local variable to its widest used type after the join point.
 * That would eliminate some widenings of undefined variables to object, most notably those used only in loops.
 * We need a full liveness analysis for that. Currently, we can establish per-type liveness, which eliminates most of unwanted dead widenings.
 *
 * NOTE: the way this class is implemented, it actually processes the AST in two passes.
 * The first pass is top-down and implemented in {@code enterXxx} methods.
 * This pass does not mutate the AST (except for one occurrence, noted below), as being able to find relevant labels for control flow joins is sensitive to their reference identity, and mutated label-carrying nodes will create copies of their labels.
 * A second bottom-up pass applying the changes is implemented in the separate visitor sitting in {@link #leaveFunctionNode(FunctionNode)}.
 * This visitor will also instantiate new instances of the calculator to be run on nested functions (when not lazy compiling).
 */
final class LocalVariableTypesCalculator extends SimpleNodeVisitor {

  static class JumpOrigin {

    final JoinPredecessor node;
    final Map<Symbol, LvarType> types;

    JumpOrigin(JoinPredecessor node, Map<Symbol, LvarType> types) {
      this.node = node;
      this.types = types;
    }
  }

  static class JumpTarget {

    private final List<JumpOrigin> origins = new LinkedList<>();
    private Map<Symbol, LvarType> types = Collections.emptyMap();

    void addOrigin(JoinPredecessor originNode, Map<Symbol, LvarType> originTypes, LocalVariableTypesCalculator calc) {
      origins.add(new JumpOrigin(originNode, originTypes));
      this.types = calc.getUnionTypes(this.types, originTypes);
    }
  }

  enum LvarType {
    UNDEFINED(Type.UNDEFINED),
    BOOLEAN(Type.BOOLEAN),
    INT(Type.INT),
    DOUBLE(Type.NUMBER),
    OBJECT(Type.OBJECT);

    private final Type type;
    private final TypeHolderExpression typeExpression;

    LvarType(Type type) {
      this.type = type;
      this.typeExpression = new TypeHolderExpression(type);
    }
  }

  /**
   * A bogus Expression subclass that only reports its type.
   * Used to interrogate BinaryNode and UnaryNode about their types by creating temporary copies of them and replacing their operands with instances of these.
   * An alternative solution would be to add BinaryNode.getType(Type lhsType, Type rhsType) and UnaryNode.getType(Type exprType) methods.
   * For the time being though, this is easier to implement and is in fact fairly clean.
   * It does result in generation of higher number of temporary short lived nodes, though.
   */
  static class TypeHolderExpression extends Expression {

    private final Type type;

    TypeHolderExpression(Type type) {
      super(0L, 0, 0);
      this.type = type;
    }

    @Override
    public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
      throw new AssertionError();
    }

    @Override
    public Type getType() {
      return type;
    }

    @Override
    public void toString(StringBuilder sb, boolean printType) {
      throw new AssertionError();
    }

    private static final long serialVersionUID = 1;
  }

  private static final Map<Type, LvarType> TO_LVAR_TYPE = new IdentityHashMap<>();

  static /*<init>*/ {
    for (var lvarType : LvarType.values()) {
      TO_LVAR_TYPE.put(lvarType.type, lvarType);
    }
  }

  @SuppressWarnings("unchecked")
  static HashMap<Symbol, LvarType> cloneMap(Map<Symbol, LvarType> map) {
    return (HashMap<Symbol, LvarType>) ((HashMap<?, ?>) map).clone();
  }

  LocalVariableConversion createConversion(Symbol symbol, LvarType branchLvarType, Map<Symbol, LvarType> joinLvarTypes, LocalVariableConversion next) {
    if (invalidatedSymbols.contains(symbol)) {
      return next;
    }
    var targetType = joinLvarTypes.get(symbol);
    assert targetType != null;
    if (targetType == branchLvarType) {
      return next;
    }
    // NOTE: we could naively just use symbolIsUsed(symbol, branchLvarType) here, but that'd be wrong.
    // While technically a conversion will read the value of the symbol with that type, but it will also write it to a new type, and that type might be dead (we can't know yet).
    // For this reason, we don't treat conversion reads as real uses until we know their target type is live.
    // If we didn't do this, and just did a symbolIsUsed here, we'd introduce false live variables which could nevertheless turn into dead ones in a subsequent deoptimization, causing a shift in the list of live locals that'd cause erroneous restoration of continuations (since RewriteException's byteCodeSlots carries an array and not a name-value map).
    symbolIsConverted(symbol, branchLvarType, targetType);
    return new LocalVariableConversion(symbol, branchLvarType.type, targetType.type, next);
  }

  Map<Symbol, LvarType> getUnionTypes(Map<Symbol, LvarType> types1, Map<Symbol, LvarType> types2) {
    if (types1 == types2 || types1.isEmpty()) {
      return types2;
    } else if (types2.isEmpty()) {
      return types1;
    }
    var commonSymbols = new HashSet<Symbol>(types1.keySet());
    commonSymbols.retainAll(types2.keySet());
    // We have a chance of returning an unmodified set if both sets have the same keys and one is strictly wider than the other.
    var commonSize = commonSymbols.size();
    var types1Size = types1.size();
    var types2Size = types2.size();
    if (commonSize == types1Size && commonSize == types2Size) {
      boolean matches1 = true, matches2 = true;
      Map<Symbol, LvarType> union = null;
      for (var symbol : commonSymbols) {
        var type1 = types1.get(symbol);
        var type2 = types2.get(symbol);
        var widest = widestLvarType(type1, type2);
        if (widest != type1 && matches1) {
          matches1 = false;
          if (!matches2) {
            union = cloneMap(types1);
          }
        }
        if (widest != type2 && matches2) {
          matches2 = false;
          if (!matches1) {
            union = cloneMap(types2);
          }
        }
        if (!(matches1 || matches2)) {
          assert union != null;
          union.put(symbol, widest);
        }
      }
      return matches1 ? types1 : matches2 ? types2 : union;
    }
    // General case
    Map<Symbol, LvarType> union;
    if (types1Size > types2Size) {
      union = cloneMap(types1);
      union.putAll(types2);
    } else {
      union = cloneMap(types2);
      union.putAll(types1);
    }
    for (var symbol : commonSymbols) {
      var type1 = types1.get(symbol);
      var type2 = types2.get(symbol);
      union.put(symbol, widestLvarType(type1, type2));
    }
    // If the two sets of symbols differ, there's a good chance that some of symbols only appearing in one of the sets are lexically invalidated, so we remove them from further consideration.
    // This is not strictly necessary, just a working set size optimization.
    union.keySet().removeAll(invalidatedSymbols);
    return union;
  }

  static void symbolIsUsed(Symbol symbol, LvarType type) {
    if (type != LvarType.UNDEFINED) {
      symbol.setHasSlotFor(type.type);
    }
  }

  static class SymbolConversions {

    private static final byte I2D = 1 << 0;
    private static final byte I2O = 1 << 1;
    private static final byte D2O = 1 << 2;

    private byte conversions;

    void recordConversion(LvarType from, LvarType to) {
      switch (from) {
        case UNDEFINED -> {
          return;
        }
        case INT, BOOLEAN -> {
          switch (to) {
            case DOUBLE -> {
              recordConversion(I2D);
              return;
            }
            case OBJECT -> {
              recordConversion(I2O);
              return;
            }
            default -> {
              illegalConversion(from, to);
              return;
            }
          }
        }
        case DOUBLE -> {
          if (to == LvarType.OBJECT) {
            recordConversion(D2O);
          }
          return;
        }
        default -> {
          illegalConversion(from, to);
        }
      }
    }

    static void illegalConversion(LvarType from, LvarType to) {
      throw new AssertionError("Invalid conversion from " + from + " to " + to);
    }

    void recordConversion(byte convFlag) {
      conversions = (byte) (conversions | convFlag);
    }

    boolean hasConversion(byte convFlag) {
      return (conversions & convFlag) != 0;
    }

    void calculateTypeLiveness(Symbol symbol) {
      if (symbol.hasSlotFor(Type.OBJECT)) {
        if (hasConversion(D2O)) {
          symbol.setHasSlotFor(Type.NUMBER);
        }
        if (hasConversion(I2O)) {
          symbol.setHasSlotFor(Type.INT);
        }
      }
      if (symbol.hasSlotFor(Type.NUMBER)) {
        if (hasConversion(I2D)) {
          symbol.setHasSlotFor(Type.INT);
        }
      }
    }
  }

  void symbolIsConverted(Symbol symbol, LvarType from, LvarType to) {
    var conversions = symbolConversions.get(symbol);
    if (conversions == null) {
      conversions = new SymbolConversions();
      symbolConversions.put(symbol, conversions);
    }
    conversions.recordConversion(from, to);
  }

  static LvarType toLvarType(Type type) {
    assert type != null;
    var lvarType = TO_LVAR_TYPE.get(type);
    if (lvarType != null) {
      return lvarType;
    }
    assert type.isObject() : "Unsupported primitive type: " + type;
    return LvarType.OBJECT;
  }

  static LvarType widestLvarType(LvarType t1, LvarType t2) {
    if (t1 == t2) {
      return t1;
    }
    // Undefined or boolean to anything always widens to object.
    if (t1.ordinal() < LvarType.INT.ordinal() || t2.ordinal() < LvarType.INT.ordinal()) {
      return LvarType.OBJECT;
    }
    return LvarType.values()[Math.max(t1.ordinal(), t2.ordinal())];
  }

  private final Compiler compiler;
  private final Map<Label, JumpTarget> jumpTargets = new IdentityHashMap<>();

  // Local variable type mapping at the currently evaluated point.
  // No map instance is ever modified; setLvarType() always allocates a new map.
  // Immutability of maps allows for cheap snapshots by just keeping the reference to the current value.
  private Map<Symbol, LvarType> localVariableTypes = Collections.emptyMap();

  // Set of symbols whose lexical scope has already ended.
  private final Set<Symbol> invalidatedSymbols = new HashSet<>();

  // Stack for evaluated expression types.
  private final Deque<LvarType> typeStack = new ArrayDeque<>();

  // Whether the current point in the AST is reachable code
  private boolean reachable = true;

  // Return type of the function
  private Type returnType = Type.UNKNOWN;

  // Synthetic return node that we must insert at the end of the function if it's end is reachable.
  private ReturnNode syntheticReturn;

  private boolean alreadyEnteredTopLevelFunction;

  // LvarType and conversion information gathered during the top-down pass; applied to nodes in the bottom-up pass.
  private final Map<JoinPredecessor, LocalVariableConversion> localVariableConversions = new IdentityHashMap<>();

  private final Map<IdentNode, LvarType> identifierLvarTypes = new IdentityHashMap<>();
  private final Map<Symbol, SymbolConversions> symbolConversions = new IdentityHashMap<>();

  // Stack of open labels for starts of catch blocks, one for every currently traversed try block; for inserting control flow edges to them.
  // Note that we currently don't insert actual control flow edges, but instead edges that help us with type calculations.
  // This means that some operations that can result in an exception being thrown aren't considered (function calls, side effecting property getters and setters etc.), while some operations that don't result in control flow transfers do originate an edge to the catch blocks (namely, assignments to local variables).
  private final Deque<Label> catchLabels = new ArrayDeque<>();

  private LocalVariableTypesCalculator(Compiler compiler) {
    this.compiler = compiler;
  }

  LocalVariableTypesCalculator(Compiler compiler, Type returnType) {
    this(compiler);
    this.returnType = returnType;
  }

  JumpTarget createJumpTarget(Label label) {
    assert !jumpTargets.containsKey(label);
    var jumpTarget = new JumpTarget();
    jumpTargets.put(label, jumpTarget);
    return jumpTarget;
  }

  void doesNotContinueSequentially() {
    reachable = false;
    localVariableTypes = Collections.emptyMap();
    assertTypeStackIsEmpty();
  }

  boolean pushExpressionType(Expression expr) {
    typeStack.push(toLvarType(expr.getType()));
    return false;
  }

  @Override
  public boolean enterAccessNode(AccessNode accessNode) {
    visitExpression(accessNode.getBase());
    return pushExpressionType(accessNode);
  }

  @Override
  public boolean enterBinaryNode(BinaryNode binaryNode) {
    // NOTE: regardless of operator's lexical associativity, lhs is always evaluated first.
    var lhs = binaryNode.lhs();
    LvarType lhsType;
    if (!(lhs instanceof IdentNode && binaryNode.isTokenType(TokenType.ASSIGN))) {
      lhsType = visitExpression(lhs);
    } else {
      // Can't visit IdentNode on LHS of a simple assignment, as visits imply use, and this is def.
      // The type is irrelevant, as only RHS is used to determine the type anyway.
      lhsType = LvarType.UNDEFINED;
    }
    var isLogical = binaryNode.isLogical();
    var joinLabel = isLogical ? new Label("") : null;
    if (isLogical) {
      jumpToLabel((JoinPredecessor) lhs, joinLabel);
    }
    var rhs = binaryNode.rhs();
    var rhsType = visitExpression(rhs);
    if (isLogical) {
      jumpToLabel((JoinPredecessor) rhs, joinLabel);
    }
    joinOnLabel(joinLabel);
    var type = toLvarType(binaryNode.setOperands(lhsType.typeExpression, rhsType.typeExpression).getType());
    if (binaryNode.isAssignment() && lhs instanceof IdentNode) {
      if (binaryNode.isSelfModifying()) {
        onSelfAssignment((IdentNode) lhs, type);
      } else {
        onAssignment((IdentNode) lhs, type);
      }
    }
    typeStack.push(type);
    return false;
  }

  @Override
  public boolean enterBlock(Block block) {
    var cloned = false;
    for (var symbol : block.getSymbols()) {
      if (symbol.isBytecodeLocal()) {
        if (getLocalVariableTypeOrNull(symbol) == null) {
          if (!cloned) {
            cloneOrNewLocalVariableTypes();
            cloned = true;
          }
          localVariableTypes.put(symbol, LvarType.UNDEFINED);
        }
        // In case we're repeating analysis of a lexical scope (e.g. it's in a loop), make sure all symbols lexically scoped by the block become valid again.
        invalidatedSymbols.remove(symbol);
      }
    }
    return true;
  }

  @Override
  public boolean enterBreakNode(BreakNode breakNode) {
    return enterJumpStatement(breakNode);
  }

  @Override
  public boolean enterCallNode(CallNode callNode) {
    visitExpression(callNode.getFunction());
    visitExpressions(callNode.getArgs());
    var evalArgs = callNode.getEvalArgs();
    if (evalArgs != null) {
      visitExpressions(evalArgs.getArgs());
    }
    return pushExpressionType(callNode);
  }

  @Override
  public boolean enterContinueNode(ContinueNode continueNode) {
    return enterJumpStatement(continueNode);
  }

  boolean enterJumpStatement(JumpStatement jump) {
    if (!reachable) {
      return false;
    }
    assertTypeStackIsEmpty();
    jumpToLabel(jump, jump.getTargetLabel(lc), getBreakTargetTypes(jump.getPopScopeLimit(lc)));
    doesNotContinueSequentially();
    return false;
  }

  @Override
  protected boolean enterDefault(Node node) {
    return reachable;
  }

  private void enterDoWhileLoop(WhileNode loopNode) {
    assertTypeStackIsEmpty();
    var test = loopNode.getTest();
    var body = loopNode.getBody();
    var continueLabel = loopNode.getContinueLabel();
    var breakLabel = loopNode.getBreakLabel();
    var beforeLoopTypes = localVariableTypes;
    var repeatLabel = new Label("");
    for (;;) {
      jumpToLabel(loopNode, repeatLabel, beforeLoopTypes);
      var beforeRepeatTypes = localVariableTypes;
      body.accept(this);
      if (reachable) {
        jumpToLabel(body, continueLabel);
      }
      joinOnLabel(continueLabel);
      if (!reachable) {
        break;
      }
      visitExpressionOnEmptyStack(test);
      jumpToLabel(test, breakLabel);
      if (isAlwaysFalse(test)) {
        break;
      }
      jumpToLabel(test, repeatLabel);
      joinOnLabel(repeatLabel);
      if (localVariableTypes.equals(beforeRepeatTypes)) {
        break;
      }
      resetJoinPoint(continueLabel);
      resetJoinPoint(breakLabel);
      resetJoinPoint(repeatLabel);
    }
    if (isAlwaysTrue(test)) {
      doesNotContinueSequentially();
    }
    leaveBreakable(loopNode);
  }

  @Override
  public boolean enterExpressionStatement(ExpressionStatement expressionStatement) {
    if (reachable) {
      visitExpressionOnEmptyStack(expressionStatement.getExpression());
    }
    return false;
  }

  void assertTypeStackIsEmpty() {
    assert typeStack.isEmpty();
  }

  @Override
  protected Node leaveDefault(Node node) {
    assert !(node instanceof Expression); // All expressions were handled
    assert !(node instanceof Statement) || typeStack.isEmpty(); // No statements leave with a non-empty stack
    return node;
  }

  LvarType visitExpressionOnEmptyStack(Expression expr) {
    assertTypeStackIsEmpty();
    return visitExpression(expr);
  }

  LvarType visitExpression(Expression expr) {
    var stackSize = typeStack.size();
    expr.accept(this);
    assert typeStack.size() == stackSize + 1;
    return typeStack.pop();
  }

  void visitExpressions(List<Expression> exprs) {
    for (var expr : exprs) {
      if (expr != null) {
        visitExpression(expr);
      }
    }
  }

  @Override
  public boolean enterForNode(ForNode forNode) {
    if (!reachable) {
      return false;
    }
    var init = forNode.getInit();
    if (forNode.isForInOrOf()) {
      var iterable = forNode.getModify();
      visitExpression(iterable);
      enterTestFirstLoop(forNode, null, init,
        // If we're iterating over property names, and we can discern from the runtime environment of the compilation that the object being iterated over must use strings for property names (e.g., it is a native JS object or array), then we'll not bother trying to treat the property names optimistically.
        !compiler.useOptimisticTypes() || (!forNode.isForEach() && compiler.hasStringPropertyIterator(iterable.getExpression())));
    } else {
      if (init != null) {
        visitExpressionOnEmptyStack(init);
      }
      enterTestFirstLoop(forNode, forNode.getModify(), null, false);
    }
    assertTypeStackIsEmpty();
    return false;
  }

  @Override
  public boolean enterFunctionNode(FunctionNode functionNode) {
    if (alreadyEnteredTopLevelFunction) {
      typeStack.push(LvarType.OBJECT);
      return false;
    }
    var pos = 0;
    if (!functionNode.isVarArg()) {
      for (var param : functionNode.getParameters()) {
        var symbol = param.getSymbol();
        // Parameter is not necessarily bytecode local as it can be scoped due to nested context use, but it must have a slot if we aren't in a function with vararg signature.
        assert symbol.hasSlot();
        var callSiteParamType = compiler.getParamType(functionNode, pos);
        var paramType = callSiteParamType == null ? LvarType.OBJECT : toLvarType(callSiteParamType);
        setType(symbol, paramType);
        // Make sure parameter slot for its incoming value is not marked dead. NOTE: this is a heuristic.
        // Right now, CodeGenerator.expandParameters() relies on the fact that every parameter's final slot width will be at least the same as incoming width, therefore even if a parameter is never read, we'll still keep its slot.
        symbolIsUsed(symbol);
        setIdentifierLvarType(param, paramType);
        pos++;
      }
    }
    setCompilerConstantAsObject(functionNode, CompilerConstants.THIS);
    // TODO: coarse-grained.
    // If we wanted to solve it completely precisely, we'd also need to push/pop its type when handling WithNode (so that it can go back to undefined after a 'with' block.
    if (functionNode.hasScopeBlock() || functionNode.needsParentScope()) {
      setCompilerConstantAsObject(functionNode, CompilerConstants.SCOPE);
    }
    if (functionNode.needsCallee()) {
      setCompilerConstantAsObject(functionNode, CompilerConstants.CALLEE);
    }
    if (functionNode.needsArguments()) {
      setCompilerConstantAsObject(functionNode, CompilerConstants.ARGUMENTS);
    }
    alreadyEnteredTopLevelFunction = true;
    return true;
  }

  @Override
  public boolean enterGetSplitState(GetSplitState getSplitState) {
    return pushExpressionType(getSplitState);
  }

  @Override
  public boolean enterIdentNode(IdentNode identNode) {
    var symbol = identNode.getSymbol();
    if (symbol.isBytecodeLocal()) {
      symbolIsUsed(symbol);
      var type = getLocalVariableType(symbol);
      setIdentifierLvarType(identNode, type);
      typeStack.push(type);
    } else {
      pushExpressionType(identNode);
    }
    return false;
  }

  @Override
  public boolean enterIfNode(IfNode ifNode) {
    processIfNode(ifNode);
    return false;
  }

  void processIfNode(IfNode ifNode) {
    if (!reachable) {
      return;
    }
    var test = ifNode.getTest();
    var pass = ifNode.getPass();
    var fail = ifNode.getFail();
    visitExpressionOnEmptyStack(test);
    Map<Symbol, LvarType> passLvarTypes;
    boolean reachableFromPass;
    var isTestAlwaysTrue = isAlwaysTrue(test);
    if (isAlwaysFalse(test)) {
      passLvarTypes = null;
      reachableFromPass = false;
    } else {
      var afterTestLvarTypes = localVariableTypes;
      pass.accept(this);
      assertTypeStackIsEmpty();
      if (isTestAlwaysTrue) {
        return;
      }
      passLvarTypes = localVariableTypes;
      reachableFromPass = reachable;
      localVariableTypes = afterTestLvarTypes;
      reachable = true;
    }
    // If we get here, then we need to consider the case where pass block is not executed
    assert !isTestAlwaysTrue;
    if (fail != null) {
      fail.accept(this);
      assertTypeStackIsEmpty();
    }
    if (reachable) {
      if (reachableFromPass) {
        var failLvarTypes = localVariableTypes;
        localVariableTypes = getUnionTypes(passLvarTypes, failLvarTypes);
        setConversion(pass, passLvarTypes, localVariableTypes);
        // IfNode itself is associated with conversions that might need to be performed after the test if there's no else branch.
        // E.g. if(x = 1, cond) { x = 1.0 } must widen "x = 1" to a double.
        setConversion(fail != null ? fail : ifNode, failLvarTypes, localVariableTypes);
      }
    } else if (reachableFromPass) {
      assert passLvarTypes != null;
      localVariableTypes = passLvarTypes;
      reachable = true;
    }
  }

  @Override
  public boolean enterIndexNode(IndexNode indexNode) {
    visitExpression(indexNode.getBase());
    visitExpression(indexNode.getIndex());
    return pushExpressionType(indexNode);
  }

  @Override
  public boolean enterJoinPredecessorExpression(JoinPredecessorExpression joinExpr) {
    var expr = joinExpr.getExpression();
    if (expr != null) {
      expr.accept(this);
    } else {
      typeStack.push(LvarType.UNDEFINED);
    }
    return false;
  }

  @Override
  public boolean enterJumpToInlinedFinally(JumpToInlinedFinally jumpToInlinedFinally) {
    return enterJumpStatement(jumpToInlinedFinally);
  }

  @Override
  public boolean enterLiteralNode(LiteralNode<?> literalNode) {
    if (literalNode instanceof ArrayLiteralNode a) {
      var expressions = a.getElementExpressions();
      if (expressions != null) {
        visitExpressions(expressions);
      }
    }
    pushExpressionType(literalNode);
    return false;
  }

  @Override
  public boolean enterObjectNode(ObjectNode objectNode) {
    for (var propertyNode : objectNode.getElements()) {
      // Avoid falsely adding property keys to the control flow graph
      var value = propertyNode.getValue();
      if (value != null) {
        visitExpression(value);
      }
    }
    return pushExpressionType(objectNode);
  }

  @Override
  public boolean enterPropertyNode(PropertyNode propertyNode) {
    // Property nodes are only accessible through object literals, and we handled that case above
    throw new AssertionError();
  }

  @Override
  public boolean enterReturnNode(ReturnNode returnNode) {
    if (!reachable) {
      return false;
    }
    var returnExpr = returnNode.getExpression();
    Type returnExprType;
    if (returnExpr != null) {
      returnExprType = visitExpressionOnEmptyStack(returnExpr).type;
    } else {
      assertTypeStackIsEmpty();
      returnExprType = Type.UNDEFINED;
    }
    returnType = Type.widestReturnType(returnType, returnExprType);
    doesNotContinueSequentially();
    return false;
  }

  @Override
  public boolean enterRuntimeNode(RuntimeNode runtimeNode) {
    visitExpressions(runtimeNode.getArgs());
    return pushExpressionType(runtimeNode);
  }

  @Override
  public boolean enterSplitReturn(SplitReturn splitReturn) {
    doesNotContinueSequentially();
    return false;
  }

  @Override
  public boolean enterSwitchNode(SwitchNode switchNode) {
    if (!reachable) {
      return false;
    }
    visitExpressionOnEmptyStack(switchNode.getExpression());
    var cases = switchNode.getCases();
    if (cases.isEmpty()) {
      return false;
    }
    // Control flow is different for all-integer cases where we dispatch by switch table, and for all other cases where we do sequential comparison.
    // Note that CaseNode objects act as join points.
    var isInteger = switchNode.isUniqueInteger();
    var breakLabel = switchNode.getBreakLabel();
    var hasDefault = switchNode.getDefaultCase() != null;
    var tagUsed = false;
    for (var caseNode : cases) {
      var test = caseNode.getTest();
      if (!isInteger && test != null) {
        visitExpressionOnEmptyStack(test);
        if (!tagUsed) {
          symbolIsUsed(switchNode.getTag(), LvarType.OBJECT);
          tagUsed = true;
        }
      }
      // CaseNode carries the conversions that need to be performed on its entry from the test.
      // CodeGenerator ensures these are only emitted when arriving on the branch and not through a fallthrough.
      jumpToLabel(caseNode, caseNode.getBody().getEntryLabel());
    }
    if (!hasDefault) {
      // No default case means we can arrive at the break label without entering any cases.
      // In that case SwitchNode will carry the conversions that need to be performed before it does that jump.
      jumpToLabel(switchNode, breakLabel);
    }
    // All cases are arrived at through jumps
    doesNotContinueSequentially();
    Block previousBlock = null;
    for (var caseNode : cases) {
      var body = caseNode.getBody();
      var entryLabel = body.getEntryLabel();
      if (previousBlock != null && reachable) {
        jumpToLabel(previousBlock, entryLabel);
      }
      joinOnLabel(entryLabel);
      assert reachable == true;
      body.accept(this);
      previousBlock = body;
    }
    if (previousBlock != null && reachable) {
      jumpToLabel(previousBlock, breakLabel);
    }
    leaveBreakable(switchNode);
    return false;
  }

  @Override
  public boolean enterTernaryNode(TernaryNode ternaryNode) {
    var test = ternaryNode.getTest();
    var trueExpr = ternaryNode.getTrueExpression();
    var falseExpr = ternaryNode.getFalseExpression();
    visitExpression(test);
    var testExitLvarTypes = localVariableTypes;
    var trueType = isAlwaysFalse(test) ? null : visitExpression(trueExpr);
    var trueExitLvarTypes = localVariableTypes;
    localVariableTypes = testExitLvarTypes;
    var falseType = isAlwaysTrue(test) ? null : visitExpression(falseExpr);
    var falseExitLvarTypes = localVariableTypes;
    localVariableTypes = getUnionTypes(trueExitLvarTypes, falseExitLvarTypes);
    setConversion((JoinPredecessor) trueExpr, trueExitLvarTypes, localVariableTypes);
    setConversion((JoinPredecessor) falseExpr, falseExitLvarTypes, localVariableTypes);
    typeStack.push(trueType != null ? falseType != null ? widestLvarType(trueType, falseType) : trueType : assertNotNull(falseType));
    return false;
  }

  static <T> T assertNotNull(T t) {
    assert t != null;
    return t;
  }

  void enterTestFirstLoop(LoopNode loopNode, JoinPredecessorExpression modify, Expression iteratorValues, boolean iteratorValuesAreObject) {
    var test = loopNode.getTest();
    if (isAlwaysFalse(test)) {
      visitExpressionOnEmptyStack(test);
      return;
    }
    var continueLabel = loopNode.getContinueLabel();
    var breakLabel = loopNode.getBreakLabel();
    var repeatLabel = modify == null ? continueLabel : new Label("");
    var beforeLoopTypes = localVariableTypes;
    for (;;) {
      jumpToLabel(loopNode, repeatLabel, beforeLoopTypes);
      var beforeRepeatTypes = localVariableTypes;
      if (test != null) {
        visitExpressionOnEmptyStack(test);
      }
      if (!isAlwaysTrue(test)) {
        jumpToLabel(test, breakLabel);
      }
      if (iteratorValues instanceof IdentNode ident) {
        // Receives iterator values; the optimistic type of the iterator values is tracked on the identifier, but we override optimism if it's known that the object being iterated over will never have primitive property names.
        onAssignment(ident, iteratorValuesAreObject ? LvarType.OBJECT : toLvarType(compiler.getOptimisticType(ident)));
      }
      var body = loopNode.getBody();
      body.accept(this);
      if (reachable) {
        jumpToLabel(body, continueLabel);
      }
      joinOnLabel(continueLabel);
      if (!reachable) {
        break;
      }
      if (modify != null) {
        visitExpressionOnEmptyStack(modify);
        jumpToLabel(modify, repeatLabel);
        joinOnLabel(repeatLabel);
      }
      if (localVariableTypes.equals(beforeRepeatTypes)) {
        break;
      }
      // Reset the join points and repeat the analysis
      resetJoinPoint(continueLabel);
      resetJoinPoint(breakLabel);
      resetJoinPoint(repeatLabel);
    }
    if (isAlwaysTrue(test) && iteratorValues == null) {
      doesNotContinueSequentially();
    }
    leaveBreakable(loopNode);
  }

  @Override
  public boolean enterThrowNode(ThrowNode throwNode) {
    if (!reachable) {
      return false;
    }
    visitExpressionOnEmptyStack(throwNode.getExpression());
    jumpToCatchBlock(throwNode);
    doesNotContinueSequentially();
    return false;
  }

  @Override
  public boolean enterTryNode(TryNode tryNode) {
    if (!reachable) {
      return false;
    }
    // This is the label for the join point at the entry of the catch blocks.
    var catchLabel = new Label("");
    catchLabels.push(catchLabel);
    // Presume that even the start of the try block can immediately go to the catch
    jumpToLabel(tryNode, catchLabel);
    var body = tryNode.getBody();
    body.accept(this);
    catchLabels.pop();
    // Final exit label for the whole try/catch construct (after the try block and after all catches).
    var endLabel = new Label("");
    boolean canExit = false;
    if (reachable) {
      jumpToLabel(body, endLabel);
      canExit = true;
    }
    doesNotContinueSequentially();
    for (var inlinedFinally : tryNode.getInlinedFinallies()) {
      var finallyBody = TryNode.getLabelledInlinedFinallyBlock(inlinedFinally);
      joinOnLabel(finallyBody.getEntryLabel());
      // NOTE: the jump to inlined finally can end up in dead code, so it is not necessarily reachable.
      if (reachable) {
        finallyBody.accept(this);
        // All inlined finallies end with a jump or a return
        assert !reachable;
      }
    }
    joinOnLabel(catchLabel);
    for (var catchNode : tryNode.getCatches()) {
      var exception = catchNode.getExceptionIdentifier();
      onAssignment(exception, LvarType.OBJECT);
      var condition = catchNode.getExceptionCondition();
      if (condition != null) {
        visitExpression(condition);
      }
      var afterConditionTypes = localVariableTypes;
      var catchBody = catchNode.getBody();
      // TODO: currently, we consider that the catch blocks are always reachable from the try block as currently we lack enough analysis to prove that no statement before a break/continue/return in the try block can throw an exception.
      reachable = true;
      catchBody.accept(this);
      if (reachable) {
        jumpToLabel(catchBody, endLabel);
        canExit = true;
      }
      localVariableTypes = afterConditionTypes;
    }
    // NOTE: if we had one or more conditional catch blocks with no unconditional catch block following them, then there will be an unconditional rethrow, so the join point can never be reached from the last conditionExpression.
    doesNotContinueSequentially();
    if (canExit) {
      joinOnLabel(endLabel);
    }
    return false;
  }

  @Override
  public boolean enterUnaryNode(UnaryNode unaryNode) {
    var expr = unaryNode.getExpression();
    LvarType unaryType;
    if (unaryNode.tokenType() == TokenType.DELETE && expr instanceof IdentNode) {
      // not visiting deleted identifiers; they don't count as use
      unaryType = toLvarType(unaryNode.getType());
    } else {
      unaryType = toLvarType(unaryNode.setExpression(visitExpression(expr).typeExpression).getType());
      if (unaryNode.isSelfModifying() && expr instanceof IdentNode) {
        onSelfAssignment((IdentNode) expr, unaryType);
      }
    }
    typeStack.push(unaryType);
    return false;
  }

  @Override
  public boolean enterVarNode(VarNode varNode) {
    if (!reachable) {
      return false;
    }
    var init = varNode.getInit();
    if (init != null) {
      onAssignment(varNode.getName(), visitExpression(init));
    }
    return false;
  }

  @Override
  public boolean enterWhileNode(WhileNode whileNode) {
    if (!reachable) {
      return false;
    }
    if (whileNode.isDoWhile()) {
      enterDoWhileLoop(whileNode);
    } else {
      enterTestFirstLoop(whileNode, null, null, false);
    }
    return false;
  }

  private Map<Symbol, LvarType> getBreakTargetTypes(LexicalContextNode target) {
    // Remove symbols defined in the the blocks that are being broken out of.
    var types = localVariableTypes;
    for (var it = lc.getAllNodes(); it.hasNext();) {
      var node = it.next();
      if (node instanceof Block b) {
        for (var symbol : b.getSymbols()) {
          if (localVariableTypes.containsKey(symbol)) {
            if (types == localVariableTypes) {
              types = cloneMap(localVariableTypes);
            }
            types.remove(symbol);
          }
        }
      }
      if (node == target) {
        break;
      }
    }
    return types;
  }

  /**
   * Returns the current type of the local variable represented by the symbol.
   * This is the most constrained of all {@code getLocalVariableType*} methods, as it will throw an assertion if the type is null.
   * Therefore, it is only safe to be invoked on symbols known to be bytecode locals, and only after they have been initialized.
   * Regardless, it is recommended to use this method in majority of cases, as because of its strictness it is the best suited for catching missing type calculation bugs early.
   * @param symbol a symbol representing a bytecode local variable.
   * @return the current type of the local variable represented by the symbol
   */
  LvarType getLocalVariableType(Symbol symbol) {
    var type = getLocalVariableTypeOrNull(symbol);
    assert type != null;
    return type;
  }

  /**
   * Gets the type for a variable represented by a symbol, or null if the type is not know.
   * This is the least strict of all local variable type getters, and as such its use is discouraged except in initialization scenarios (where a just-defined symbol might still be null).
   * @param symbol the symbol
   * @return the current type for the symbol, or null if the type is not known either because the symbol has not been initialized, or because the symbol does not represent a bytecode local variable.
   */
  LvarType getLocalVariableTypeOrNull(Symbol symbol) {
    return localVariableTypes.get(symbol);
  }

  JumpTarget getOrCreateJumpTarget(Label label) {
    var jumpTarget = jumpTargets.get(label);
    return (jumpTarget != null) ? jumpTarget : createJumpTarget(label);
  }

  /**
   * If there's a join point associated with a label, insert the join point into the flow.
   * @param label the label to insert a join point for.
   */
  void joinOnLabel(Label label) {
    var jumpTarget = jumpTargets.remove(label);
    if (jumpTarget == null) {
      return;
    }
    assert !jumpTarget.origins.isEmpty();
    reachable = true;
    localVariableTypes = getUnionTypes(jumpTarget.types, localVariableTypes);
    for (var jumpOrigin : jumpTarget.origins) {
      setConversion(jumpOrigin.node, jumpOrigin.types, localVariableTypes);
    }
  }

  /**
   * If we're in a try/catch block, add an edge from the specified node to the try node's pre-catch label.
   */
  void jumpToCatchBlock(JoinPredecessor jumpOrigin) {
    var currentCatchLabel = catchLabels.peek();
    if (currentCatchLabel != null) {
      jumpToLabel(jumpOrigin, currentCatchLabel);
    }
  }

  void jumpToLabel(JoinPredecessor jumpOrigin, Label label) {
    jumpToLabel(jumpOrigin, label, localVariableTypes);
  }

  void jumpToLabel(JoinPredecessor jumpOrigin, Label label, Map<Symbol, LvarType> types) {
    getOrCreateJumpTarget(label).addOrigin(jumpOrigin, types, this);
  }

  @Override
  public Node leaveBlock(Block block) {
    if (lc.isFunctionBody()) {
      if (reachable) {
        // reachable==true means we can reach the end of the function without an explicit return statement.
        // We need to insert a synthetic one then. This logic used to be in Lower.leaveBlock(), but Lower's reachability analysis (through Terminal.isTerminal() flags) is not precise enough so Lower$BlockLexicalContext.afterSetStatements will sometimes think the control flow terminates even when it didn't.
        // Example: function() { switch((z)) { default: {break; } throw x; } }.
        createSyntheticReturn(block);
        assert !reachable;
      }
      // We must calculate the return type here (and not in leaveFunctionNode) as it can affect the liveness of the :return symbol and thus affect conversion type liveness calculations for it.
      calculateReturnType();
    }
    var cloned = false;
    for (var symbol : block.getSymbols()) {
      if (symbol.hasSlot()) {
        // Invalidate the symbol when its defining block ends
        if (symbol.isBytecodeLocal()) {
          if (localVariableTypes.containsKey(symbol)) {
            if (!cloned) {
              localVariableTypes = cloneMap(localVariableTypes);
              cloned = true;
            }
          }
          invalidateSymbol(symbol);
        }
        var conversions = symbolConversions.get(symbol);
        if (conversions != null) {
          // Potentially make some currently dead types live if they're needed as a source of a type
          // conversion at a join.
          conversions.calculateTypeLiveness(symbol);
        }
        if (symbol.slotCount() == 0) {
          // This is a local variable that is never read. It won't need a slot.
          symbol.setNeedsSlot(false);
        }
      }
    }
    if (reachable) {
      // TODO: this is totally backwards. Block should not be breakable, LabelNode should be breakable.
      var labelNode = lc.getCurrentBlockLabelNode();
      if (labelNode != null) {
        jumpToLabel(labelNode, block.getBreakLabel());
      }
    }
    leaveBreakable(block);
    return block;
  }

  void calculateReturnType() {
    // NOTE: if return type is unknown, then the function does not explicitly return a value.
    // Such a function under ECMAScript rules returns Undefined, which has Type.OBJECT.
    // We might consider an optimization in the future where we can return void functions.
    if (returnType.isUnknown()) {
      returnType = Type.OBJECT;
    }
  }

  void createSyntheticReturn(Block body) {
    var functionNode = lc.getCurrentFunction();
    var token = functionNode.getToken();
    var finish = functionNode.getFinish();
    var statements = body.getStatements();
    var lineNumber = statements.isEmpty() ? functionNode.getLineNumber() : statements.get(statements.size() - 1).getLineNumber();
    var returnExpr = functionNode.isProgram() ? new IdentNode(token, finish, RETURN.symbolName()).setSymbol(getCompilerConstantSymbol(functionNode, RETURN)) : null;
    syntheticReturn = new ReturnNode(lineNumber, token, finish, returnExpr);
    syntheticReturn.accept(this);
  }

  /**
   * Leave a breakable node.
   * If there's a join point associated with its break label (meaning there was at least one break statement to the end of the node), insert the join point into the flow.
   * @param breakable the breakable node being left.
   */
  void leaveBreakable(BreakableNode breakable) {
    joinOnLabel(breakable.getBreakLabel());
    assertTypeStackIsEmpty();
  }

  @Override
  public Node leaveFunctionNode(FunctionNode functionNode) {
    // Sets the return type of the function and also performs the bottom-up pass of applying type and conversion information to nodes as well as doing the calculation on nested functions as required.
    var newFunction = functionNode;
    var applyChangesVisitor = new SimpleNodeVisitor() {
      private boolean inOuterFunction = true;
      private final Deque<JoinPredecessor> joinPredecessors = new ArrayDeque<>();

      @Override
      protected boolean enterDefault(Node node) {
        if (!inOuterFunction) {
          return false;
        }
        if (node instanceof JoinPredecessor jp) {
          joinPredecessors.push(jp);
        }
        return inOuterFunction;
      }

      @Override
      public boolean enterFunctionNode(FunctionNode fn) {
        if (compiler.isOnDemandCompilation()) {
          // Only calculate nested function local variable types if we're doing eager compilation
          return false;
        }
        inOuterFunction = false;
        return true;
      }

      @Override
      public boolean enterUnaryNode(UnaryNode unaryNode) {
        // not visiting deleted identifiers; they don't count as use
        return !(unaryNode.tokenType() == TokenType.DELETE && unaryNode.getExpression() instanceof IdentNode);
      }

      @SuppressWarnings("fallthrough") // TODO: review
      @Override
      public Node leaveBinaryNode(BinaryNode binaryNode) {
        if (binaryNode.isComparison()) {
          var lhs = binaryNode.lhs();
          var rhs = binaryNode.rhs();
          var tt = binaryNode.tokenType();
          switch (tt) {
            case EQU:
            case NEQU:
              // Specialize comparison with undefined
              var undefinedNode = createIsUndefined(binaryNode, lhs, rhs, tt == TokenType.EQU ? Request.IS_UNDEFINED : Request.IS_NOT_UNDEFINED);
              if (undefinedNode != binaryNode) {
                return undefinedNode;
              }
              // Specialize comparison of boolean with non-boolean
              if (lhs.getType().isBoolean() != rhs.getType().isBoolean()) {
                return new RuntimeNode(binaryNode);
              }
            // fallthrough
            default:
              if (lhs.getType().isObject() && rhs.getType().isObject()) {
                return new RuntimeNode(binaryNode);
              }
          }
        } else if (binaryNode.isOptimisticUndecidedType()) {
          // At this point, we can assign a static type to the optimistic binary ADD operator as now we know the types of its operands.
          return binaryNode.decideType();
        }
        return binaryNode;
      }
      @Override
      protected Node leaveDefault(Node node) {
        if (node instanceof JoinPredecessor jp) {
          var original = joinPredecessors.pop();
          assert original.getClass() == node.getClass() : original.getClass().getName() + "!=" + node.getClass().getName();
          var newNode = setLocalVariableConversion(original, jp);
          if (newNode instanceof LexicalContextNode lcn) {
            lc.replace((LexicalContextNode) node, lcn);
          }
          return (Node) newNode;
        }
        return node;
      }

      @Override
      public Node leaveBlock(Block block) {
        if (inOuterFunction && syntheticReturn != null && lc.isFunctionBody()) {
          var stmts = new ArrayList<Statement>(block.getStatements());
          stmts.add((ReturnNode) syntheticReturn.accept(this));
          return block.setStatements(lc, stmts);
        }
        return super.leaveBlock(block);
      }

      @Override
      public Node leaveFunctionNode(FunctionNode nestedFunctionNode) {
        inOuterFunction = true;
        var newNestedFunction = (FunctionNode) nestedFunctionNode.accept(new LocalVariableTypesCalculator(compiler));
        lc.replace(nestedFunctionNode, newNestedFunction);
        return newNestedFunction;
      }

      @Override
      public Node leaveIdentNode(IdentNode identNode) {
        var original = (IdentNode) joinPredecessors.pop();
        var symbol = identNode.getSymbol();
        if (symbol == null) {
          assert identNode.isPropertyName();
          return identNode;
        } else if (symbol.hasSlot()) {
          assert !symbol.isScope() || symbol.isParam(); // Only params can be slotted and scoped.
          assert original.getName().equals(identNode.getName());
          var lvarType = identifierLvarTypes.remove(original);
          if (lvarType != null) {
            return setLocalVariableConversion(original, identNode.setType(lvarType.type));
          }
          // If there's no type, then the identifier must've been in unreachable code.
          // In that case, it can't have assigned conversions either.
          assert localVariableConversions.get(original) == null;
        } else {
          assert identIsDeadAndHasNoLiveConversions(original);
        }
        return identNode;
      }

      @Override
      public Node leaveLiteralNode(LiteralNode<?> literalNode) {
        // for e.g. ArrayLiteralNodes the initial types may have been narrowed due to the introduction of optimistic behavior - hence ensure that all literal nodes are reinitialized
        return literalNode.initialize(lc);
      }

      @Override
      public Node leaveRuntimeNode(RuntimeNode runtimeNode) {
        var request = runtimeNode.getRequest();
        var isEquivalentt = request == Request.EQUIV;
        if (isEquivalentt || request == Request.NOT_EQUIV) {
          return createIsUndefined(runtimeNode, runtimeNode.getArgs().get(0), runtimeNode.getArgs().get(1),
            isEquivalentt ? Request.IS_UNDEFINED : Request.IS_NOT_UNDEFINED);
        }
        return runtimeNode;
      }

      @SuppressWarnings("unchecked")
      private <T extends JoinPredecessor> T setLocalVariableConversion(JoinPredecessor original, T jp) {
        // NOTE: can't use Map.remove() as our copy-on-write AST semantics means some nodes appear twice (in finally blocks), so we need to be able to access conversions for them multiple times.
        return (T) jp.setLocalVariableConversion(lc, localVariableConversions.get(original));
      }
    };
    newFunction = newFunction.setBody(lc, (Block) newFunction.getBody().accept(applyChangesVisitor));
    newFunction = newFunction.setReturnType(lc, returnType);
    newFunction = newFunction.setParameters(lc, newFunction.visitParameters(applyChangesVisitor));
    return newFunction;
  }

  static Expression createIsUndefined(Expression parent, Expression lhs, Expression rhs, Request request) {
    return (isUndefinedIdent(lhs) || isUndefinedIdent(rhs)) ? new RuntimeNode(parent, request, lhs, rhs) : parent;
  }

  static boolean isUndefinedIdent(Expression expr) {
    return expr instanceof IdentNode && "undefined".equals(((IdentNode) expr).getName());
  }

  boolean identIsDeadAndHasNoLiveConversions(IdentNode identNode) {
    var conv = localVariableConversions.get(identNode);
    return conv == null || !conv.isLive();
  }

  void onAssignment(IdentNode identNode, LvarType type) {
    var symbol = identNode.getSymbol();
    assert symbol != null : identNode.getName();
    if (!symbol.isBytecodeLocal()) {
      return;
    }
    assert type != null;
    LvarType finalType;
    if (type == LvarType.UNDEFINED && getLocalVariableType(symbol) != LvarType.UNDEFINED) {
      // Explicit assignment of a known undefined local variable to a local variable that is not undefined will materialize that undefined in the assignment target.
      // Note that assigning known undefined to known undefined will *not* initialize the variable, e.g. "var x; var y = x;" compiles to no-op.
      finalType = LvarType.OBJECT;
      symbol.setFlag(Symbol.HAS_OBJECT_VALUE);
    } else {
      finalType = type;
    }
    setType(symbol, finalType);
    // Explicit assignment of an undefined value. Make sure the variable can store an object.
    // TODO: if we communicated the fact to codegen with a flag on the IdentNode that the value was already undefined before the assignment, we could just ignore it.
    // In general, we could ignore an assignment if we know that the value assigned is the same as the current value of the variable, but we'd need constant propagation for that.
    setIdentifierLvarType(identNode, finalType);
    // For purposes of type calculation, we consider an assignment to a local variable to be followed by the catch nodes of the current (if any) try block.
    // This will effectively enforce that narrower assignments to a local variable in a try block will also have to store a widened value as well.
    // Code within the try block will be able to keep loading the narrower value, but after the try block only the widest value will remain live.
    // Rationale for this is that if there's an use for that variable in any of the catch blocks, or following the catch blocks, they must use the widest type.
    /*
       Example:

            Originally:
            ===========
            var x;
            try {
              x = 1; <-- stores into int slot for x
              f(x); <-- loads the int slot for x
              x = 3.14 <-- stores into the double slot for x
              f(x); <-- loads the double slot for x
              x = 1; <-- stores into int slot for x
              f(x); <-- loads the int slot for x
            } finally {
              f(x); <-- loads the double slot for x, but can be reached by a path where x is int, so we need
                           to go back and ensure that double values are also always stored along with int
                           values.
            }

            After correction:
            =================

            var x;
            try {
              x = 1; <-- stores into both int and double slots for x
              f(x); <-- loads the int slot for x
              x = 3.14 <-- stores into the double slot for x
              f(x); <-- loads the double slot for x
              x = 1; <-- stores into both int and double slots for x
              f(x); <-- loads the int slot for x
            } finally {
              f(x); <-- loads the double slot for x
            }
    */
    jumpToCatchBlock(identNode);
  }

  void onSelfAssignment(IdentNode identNode, LvarType type) {
    var symbol = identNode.getSymbol();
    assert symbol != null : identNode.getName();
    if (!symbol.isBytecodeLocal()) {
      return;
    }
    // Self-assignment never produce either a boolean or undefined
    assert type != null && type != LvarType.UNDEFINED && type != LvarType.BOOLEAN;
    setType(symbol, type);
    jumpToCatchBlock(identNode);
  }

  void resetJoinPoint(Label label) {
    jumpTargets.remove(label);
  }

  void setCompilerConstantAsObject(FunctionNode functionNode, CompilerConstants cc) {
    var symbol = getCompilerConstantSymbol(functionNode, cc);
    setType(symbol, LvarType.OBJECT);
    // never mark compiler constants as dead
    symbolIsUsed(symbol);
  }

  static Symbol getCompilerConstantSymbol(FunctionNode functionNode, CompilerConstants cc) {
    return functionNode.getBody().getExistingSymbol(cc.symbolName());
  }

  void setConversion(JoinPredecessor node, Map<Symbol, LvarType> branchLvarTypes, Map<Symbol, LvarType> joinLvarTypes) {
    if (node == null) {
      return;
    }
    if (branchLvarTypes.isEmpty() || joinLvarTypes.isEmpty()) {
      localVariableConversions.remove(node);
    }
    LocalVariableConversion conversion = null;
    if (node instanceof IdentNode i) {
      // conversions on variable assignment in try block are special cases, as they only apply to the variable being assigned and all other conversions should be ignored.
      var symbol = i.getSymbol();
      conversion = createConversion(symbol, branchLvarTypes.get(symbol), joinLvarTypes, null);
    } else {
      for (var entry : branchLvarTypes.entrySet()) {
        var symbol = entry.getKey();
        var branchLvarType = entry.getValue();
        conversion = createConversion(symbol, branchLvarType, joinLvarTypes, conversion);
      }
    }
    if (conversion != null) {
      localVariableConversions.put(node, conversion);
    } else {
      localVariableConversions.remove(node);
    }
  }

  void setIdentifierLvarType(IdentNode identNode, LvarType type) {
    assert type != null;
    identifierLvarTypes.put(identNode, type);
  }

  /**
   * Marks a local variable as having a specific type from this point onward.
   * Invoked by stores to local variables.
   * @param symbol the symbol representing the variable
   * @param type the type
   */
  void setType(Symbol symbol, LvarType type) {
    if (getLocalVariableTypeOrNull(symbol) == type) {
      return;
    }
    assert symbol.hasSlot();
    assert !symbol.isGlobal();
    cloneOrNewLocalVariableTypes();
    localVariableTypes.put(symbol, type);
  }

  void cloneOrNewLocalVariableTypes() {
    localVariableTypes = localVariableTypes.isEmpty() ? new HashMap<Symbol, LvarType>() : cloneMap(localVariableTypes);
  }

  void invalidateSymbol(Symbol symbol) {
    localVariableTypes.remove(symbol);
    invalidatedSymbols.add(symbol);
  }

  /**
   * Set a flag in the symbol marking it as needing to be able to store a value of a particular type.
   * Every symbol for a local variable will be assigned between 1 and 6 local variable slots for storing all types it is known to need to store.
   * @param symbol the symbol
   */
  void symbolIsUsed(Symbol symbol) {
    symbolIsUsed(symbol, getLocalVariableType(symbol));
  }

}
