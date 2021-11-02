package es.codegen;

import java.util.ArrayDeque;
import java.util.Collection;
import java.util.Collections;
import java.util.Deque;
import java.util.HashMap;
import java.util.Map;
import es.util.IntDeque;

import es.codegen.types.Type;
import es.ir.Block;
import es.ir.Expression;
import es.ir.FunctionNode;
import es.ir.LexicalContext;
import es.ir.LexicalContextNode;
import es.ir.Node;
import es.ir.Symbol;

/**
 * A lexical context that also tracks if we have any dynamic scopes in the context.
 * Such scopes can have new variables introduced into them at run time - a with block or a function directly containing an eval call.
 * Furthermore, this class keeps track of current discard state, which the current method emitter being used is, the current compile unit, and local variable indexes
 */
final class CodeGeneratorLexicalContext extends LexicalContext {

  private int dynamicScopeCount;

  // Map of shared scope call sites
  private final Map<SharedScopeCall, SharedScopeCall> scopeCalls = new HashMap<>();

  // Compile unit stack - every time we start a sub method (e.g. a split) we push one
  private final Deque<CompileUnit> compileUnits = new ArrayDeque<>();

  // Method emitter stack - every time we start a sub method (e.g. a split) we push one
  private final Deque<MethodEmitter> methodEmitters = new ArrayDeque<>();

  // The discard stack - whenever we evaluate an expression that will be discarded, we push it on this stack.
  // Various implementations of expression code emitter can choose to emit code that'll discard the expression themselves, or ignore it in which case CodeGenerator.loadAndDiscard() will explicitly emit a pop instruction.
  private final Deque<Expression> discard = new ArrayDeque<>();

  private final Deque<Map<String, Collection<Label>>> unwarrantedOptimismHandlers = new ArrayDeque<>();
  private final Deque<StringBuilder> slotTypesDescriptors = new ArrayDeque<>();
  private final IntDeque splitLiterals = new IntDeque();

  // A stack tracking the next free local variable slot in the blocks.
  // There's one entry for every block currently on the lexical context stack.
  private int[] nextFreeSlots = new int[16];

  // size of next free slot vector
  private int nextFreeSlotsSize;

  @Override
  public <T extends LexicalContextNode> T push(T node) {
    if (node instanceof FunctionNode fn) {
      if (fn.inDynamicContext()) {
        dynamicScopeCount++;
      }
      splitLiterals.push(0);
    }
    return super.push(node);
  }

  void enterSplitLiteral() {
    splitLiterals.getAndIncrement();
    pushFreeSlots(methodEmitters.peek().getUsedSlotsWithLiveTemporaries());
  }

  void exitSplitLiteral() {
    var count = splitLiterals.decrementAndGet();
    assert count >= 0;
  }

  @Override
  public <T extends Node> T pop(T node) {
    var popped = super.pop(node);
    if (node instanceof FunctionNode fn) {
      if (fn.inDynamicContext()) {
        dynamicScopeCount--;
        assert dynamicScopeCount >= 0;
      }
      assert splitLiterals.peek() == 0;
      splitLiterals.pop();
    }
    return popped;
  }

  boolean inDynamicScope() {
    return dynamicScopeCount > 0;
  }

  boolean inSplitLiteral() {
    return !splitLiterals.isEmpty() && splitLiterals.peek() > 0;
  }

  MethodEmitter pushMethodEmitter(MethodEmitter newMethod) {
    methodEmitters.push(newMethod);
    return newMethod;
  }

  MethodEmitter popMethodEmitter(MethodEmitter oldMethod) {
    assert methodEmitters.peek() == oldMethod;
    methodEmitters.pop();
    return methodEmitters.isEmpty() ? null : methodEmitters.peek();
  }

  void pushUnwarrantedOptimismHandlers() {
    unwarrantedOptimismHandlers.push(new HashMap<>());
    slotTypesDescriptors.push(new StringBuilder());
  }

  Map<String, Collection<Label>> getUnwarrantedOptimismHandlers() {
    return unwarrantedOptimismHandlers.peek();
  }

  Map<String, Collection<Label>> popUnwarrantedOptimismHandlers() {
    slotTypesDescriptors.pop();
    return unwarrantedOptimismHandlers.pop();
  }

  CompileUnit pushCompileUnit(CompileUnit newUnit) {
    compileUnits.push(newUnit);
    return newUnit;
  }

  CompileUnit popCompileUnit(CompileUnit oldUnit) {
    assert compileUnits.peek() == oldUnit;
    var unit = compileUnits.pop();
    assert unit.hasCode() : "compile unit popped without code";
    unit.setUsed();
    return compileUnits.isEmpty() ? null : compileUnits.peek();
  }

  boolean hasCompileUnits() {
    return !compileUnits.isEmpty();
  }

  Collection<SharedScopeCall> getScopeCalls() {
    return Collections.unmodifiableCollection(scopeCalls.values());
  }

  /**
   * Get a shared static method representing a dynamic scope callsite.
   * @param unit current compile unit
   * @param symbol the symbol
   * @param valueType the value type of the symbol
   * @param returnType the return type
   * @param paramTypes the parameter types
   * @param flags the callsite flags
   * @param isOptimistic is this an optimistic call
   * @return an object representing a shared scope call
   */
  SharedScopeCall getScopeCall(CompileUnit unit, Symbol symbol, Type valueType, Type returnType, Type[] paramTypes, int flags, boolean isOptimistic) {
    var scopeCall = new SharedScopeCall(symbol, valueType, returnType, paramTypes, flags, isOptimistic);
    if (scopeCalls.containsKey(scopeCall)) {
      return scopeCalls.get(scopeCall);
    }
    scopeCall.setClassAndName(unit, getCurrentFunction().uniqueName(":scopeCall"));
    scopeCalls.put(scopeCall, scopeCall);
    return scopeCall;
  }

  /**
   * Get a shared static method representing a dynamic scope get access.
   * @param unit current compile unit
   * @param symbol the symbol
   * @param valueType the type of the variable
   * @param flags the callsite flags
   * @param isOptimistic is this an optimistic get
   * @return an object representing a shared scope get
   */
  SharedScopeCall getScopeGet(CompileUnit unit, Symbol symbol, Type valueType, int flags, boolean isOptimistic) {
    return getScopeCall(unit, symbol, valueType, valueType, null, flags, isOptimistic);
  }

  void onEnterBlock(Block block) {
    pushFreeSlots(assignSlots(block, isFunctionBody() ? 0 : getUsedSlotCount()));
  }

  void pushFreeSlots(int freeSlots) {
    if (nextFreeSlotsSize == nextFreeSlots.length) {
      var newNextFreeSlots = new int[nextFreeSlotsSize * 2];
      System.arraycopy(nextFreeSlots, 0, newNextFreeSlots, 0, nextFreeSlotsSize);
      nextFreeSlots = newNextFreeSlots;
    }
    nextFreeSlots[nextFreeSlotsSize++] = freeSlots;
  }

  int getUsedSlotCount() {
    return nextFreeSlots[nextFreeSlotsSize - 1];
  }

  void releaseSlots() {
    --nextFreeSlotsSize;
    var undefinedFromSlot = nextFreeSlotsSize == 0 ? 0 : nextFreeSlots[nextFreeSlotsSize - 1];
    if (!slotTypesDescriptors.isEmpty()) {
      slotTypesDescriptors.peek().setLength(undefinedFromSlot);
    }
    methodEmitters.peek().undefineLocalVariables(undefinedFromSlot, false);
  }

  int assignSlots(Block block, int firstSlot) {
    var fromSlot = firstSlot;
    var method = methodEmitters.peek();
    for (var symbol : block.getSymbols()) {
      if (symbol.hasSlot()) {
        symbol.setFirstSlot(fromSlot);
        var toSlot = fromSlot + symbol.slotCount();
        method.defineBlockLocalVariable(fromSlot, toSlot);
        fromSlot = toSlot;
      }
    }
    return fromSlot;
  }

  static Type getTypeForSlotDescriptor(char typeDesc) {
    // Recognizing both lowercase and uppercase as we're using both to signify symbol boundaries;
    // see MethodEmitter.markSymbolBoundariesInLvarTypesDescriptor().
    return switch (typeDesc) {
      case 'I', 'i' -> Type.INT;
      case 'J', 'j' -> Type.LONG;
      case 'D', 'd' -> Type.NUMBER;
      case 'A', 'a' -> Type.OBJECT;
      case 'U', 'u' -> Type.UNKNOWN;
      default -> throw new AssertionError();
    };
  }

  void pushDiscard(Expression expr) {
    discard.push(expr);
  }

  boolean popDiscardIfCurrent(Expression expr) {
    if (isCurrentDiscard(expr)) {
      discard.pop();
      return true;
    }
    return false;
  }

  boolean isCurrentDiscard(Expression expr) {
    return discard.peek() == expr;
  }

  int quickSlot(Type type) {
    return methodEmitters.peek().defineTemporaryLocalVariable(type.getSlots());
  }

}
