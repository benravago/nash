package es.codegen;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.BitSet;
import java.util.Collection;
import java.util.Collections;
import java.util.Deque;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.function.Supplier;

import es.util.AssertsEnabled;
import es.util.IntDeque;
import es.codegen.ClassEmitter.Flag;
import es.codegen.CompilerConstants.Call;
import es.codegen.types.ArrayType;
import es.codegen.types.Type;
import es.ir.AccessNode;
import es.ir.BaseNode;
import es.ir.BinaryNode;
import es.ir.Block;
import es.ir.BlockStatement;
import es.ir.BreakNode;
import es.ir.CallNode;
import es.ir.CatchNode;
import es.ir.ContinueNode;
import es.ir.EmptyNode;
import es.ir.Expression;
import es.ir.ExpressionStatement;
import es.ir.ForNode;
import es.ir.FunctionNode;
import es.ir.GetSplitState;
import es.ir.IdentNode;
import es.ir.IfNode;
import es.ir.IndexNode;
import es.ir.JoinPredecessorExpression;
import es.ir.JumpStatement;
import es.ir.JumpToInlinedFinally;
import es.ir.LabelNode;
import es.ir.LexicalContext;
import es.ir.LexicalContextNode;
import es.ir.LiteralNode;
import es.ir.LiteralNode.ArrayLiteralNode;
import es.ir.LiteralNode.PrimitiveLiteralNode;
import es.ir.LocalVariableConversion;
import es.ir.LoopNode;
import es.ir.Node;
import es.ir.ObjectNode;
import es.ir.Optimistic;
import es.ir.PropertyNode;
import es.ir.ReturnNode;
import es.ir.RuntimeNode;
import es.ir.RuntimeNode.Request;
import es.ir.SetSplitState;
import es.ir.SplitReturn;
import es.ir.Splittable;
import es.ir.Statement;
import es.ir.SwitchNode;
import es.ir.Symbol;
import es.ir.TernaryNode;
import es.ir.ThrowNode;
import es.ir.TryNode;
import es.ir.UnaryNode;
import es.ir.VarNode;
import es.ir.WhileNode;
import es.ir.WithNode;
import es.ir.visitor.NodeOperatorVisitor;
import es.ir.visitor.SimpleNodeVisitor;
import es.objects.Global;
import es.parser.Lexer.RegexToken;
import es.parser.TokenType;
import es.runtime.Context;
import es.runtime.ECMAException;
import es.runtime.JSType;
import es.runtime.OptimisticReturnFilters;
import es.runtime.PropertyMap;
import es.runtime.RewriteException;
import es.runtime.Scope;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.Source;
import es.runtime.Undefined;
import es.runtime.UnwarrantedOptimismException;
import es.runtime.arrays.ArrayData;
import es.runtime.linker.LinkerCallSite;
import es.runtime.logging.DebugLogger;
import es.runtime.logging.Loggable;
import es.runtime.logging.Logger;
import es.runtime.options.Options;
import es.util.Hex;
import static es.codegen.CompilerConstants.*;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;
import static es.runtime.UnwarrantedOptimismException.isValid;
import static es.runtime.linker.NashornCallSiteDescriptor.*;

/**
 * This is the lowest tier of the code generator.
 * It takes lowered ASTs emitted from Lower and emits Java byte code.
 * The byte code emission logic is broken out into MethodEmitter.
 * MethodEmitter works internally with a type stack, and keeps track of the contents of the byte code stack.
 * This way we avoid a large number of special cases on the form
 * <pre>
 * if (type == INT) {
 *     visitInsn(ILOAD, slot);
 * } else if (type == DOUBLE) {
 *     visitInsn(DOUBLE, slot);
 * }
 * </pre>
 * This quickly became apparent when the code generator was generalized to work with all types, and not just numbers or objects.
 * <p>
 * The CodeGenerator visits nodes only once and emits bytecode for them.
 */
@Logger(name = "codegen")
final class CodeGenerator extends NodeOperatorVisitor<CodeGeneratorLexicalContext> implements Loggable {

  private static final Type SCOPE_TYPE = Type.typeFor(ScriptObject.class);

  private static final String GLOBAL_OBJECT = Type.getInternalName(Global.class);

  private static final Call CREATE_REWRITE_EXCEPTION = CompilerConstants.staticCallNoLookup(RewriteException.class, "create", RewriteException.class, UnwarrantedOptimismException.class, Object[].class, String[].class);
  private static final Call CREATE_REWRITE_EXCEPTION_REST_OF = CompilerConstants.staticCallNoLookup(RewriteException.class, "create", RewriteException.class, UnwarrantedOptimismException.class, Object[].class, String[].class, int[].class);

  private static final Call ENSURE_INT = CompilerConstants.staticCallNoLookup(OptimisticReturnFilters.class, "ensureInt", int.class, Object.class, int.class);
  private static final Call ENSURE_NUMBER = CompilerConstants.staticCallNoLookup(OptimisticReturnFilters.class, "ensureNumber", double.class, Object.class, int.class);

  private static final Call CREATE_FUNCTION_OBJECT = CompilerConstants.staticCallNoLookup(ScriptFunction.class, "create", ScriptFunction.class, Object[].class, int.class, ScriptObject.class);
  private static final Call CREATE_FUNCTION_OBJECT_NO_SCOPE = CompilerConstants.staticCallNoLookup(ScriptFunction.class, "create", ScriptFunction.class, Object[].class, int.class);

  private static final Call TO_NUMBER_FOR_EQ = CompilerConstants.staticCallNoLookup(JSType.class, "toNumberForEq", double.class, Object.class);
  private static final Call TO_NUMBER_FOR_EQUIV = CompilerConstants.staticCallNoLookup(JSType.class, "toNumberForEquiv", double.class, Object.class);

  private static final Class<?> ITERATOR_CLASS = Iterator.class;
  static { assert ITERATOR_CLASS == CompilerConstants.ITERATOR_PREFIX.type(); }

  private static final Type ITERATOR_TYPE = Type.typeFor(ITERATOR_CLASS);
  private static final Type EXCEPTION_TYPE = Type.typeFor(CompilerConstants.EXCEPTION_PREFIX.type());

  private static final Integer INT_ZERO = 0;

  // Constant data & installation.
  // The only reason the compiler keeps this is because it is assigned by reflection in class installation
  private final Compiler compiler;

  // Is the current code submitted by 'eval' call?
  private final boolean evalCode;

  // Call site flags given to the code generator to be used for all generated call sites
  private final int callSiteFlags;

  // How many regexp fields have been emitted
  private int regexFieldCount;

  // Line number for last statement.
  // If we encounter a new line number, line number bytecode information needs to be generated
  private int lastLineNumber = -1;

  // When should we stop caching regexp expressions in fields to limit bytecode size?
  private static final int MAX_REGEX_FIELDS = 2 * 1024;

  // Current method emitter
  private MethodEmitter method;

  // Current compile unit
  private CompileUnit unit;

  private final DebugLogger log;

  // From what size should we use spill instead of fields for JavaScript objects?
  static final int OBJECT_SPILL_THRESHOLD = Options.getIntProperty("nashorn.spill.threshold", 256);

  private final Set<String> emittedMethods = new HashSet<>();

  // Function Id -> ContinuationInfo. Used by compilation of rest-of function only.
  private ContinuationInfo continuationInfo;

  private final Deque<Label> scopeEntryLabels = new ArrayDeque<>();

  private static final Label METHOD_BOUNDARY = new Label("");
  private final Deque<Label> catchLabels = new ArrayDeque<>();

  // Number of live locals on entry to (and thus also break from) labeled blocks.
  private final IntDeque labeledBlockBreakLiveLocals = new IntDeque();

  //is this a rest of compilation
  private final int[] continuationEntryPoints;

  // Scope object creators needed for for-of and for-in loops
  private final Deque<FieldObjectCreator<?>> scopeObjectCreators = new ArrayDeque<>();

  /**
   * Constructor.
   *
   * @param compiler
   */
  CodeGenerator(Compiler compiler, int[] continuationEntryPoints) {
    super(new CodeGeneratorLexicalContext());
    this.compiler = compiler;
    this.evalCode = compiler.getSource().isEvalCode();
    this.continuationEntryPoints = continuationEntryPoints;
    this.callSiteFlags = 0;
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

  /**
   * Gets the call site flags
   * @return the correct flags for a call site in the current function
   */
  int getCallSiteFlags() {
    return lc.getCurrentFunction().getCallSiteFlags() | callSiteFlags;
  }

  /**
   * Gets the flags for a scope call site.
   * @param symbol a scope symbol
   * @return the correct flags for the scope call site
   */
  int getScopeCallSiteFlags(Symbol symbol) {
    assert symbol.isScope();
    var flags = getCallSiteFlags() | CALLSITE_SCOPE;
    // Don't set fast-scope flag on non-declared globals in eval code - see JDK-8077955.
    return (isEvalCode() && symbol.isGlobal()) ? flags
         : isFastScope(symbol) ? flags | CALLSITE_FAST_SCOPE
         : flags;
  }

  /**
   * Are we generating code for 'eval' code?
   * @return true if currently compiled code is 'eval' code.
   */
  boolean isEvalCode() {
    return evalCode;
  }

  /**
   * Are we using dual primitive/object field representation?
   * @return true if using dual field representation, false for object-only fields
   */
  boolean useDualFields() {
    return compiler.getContext().useDualFields();
  }

  /**
   * Load an identity node
   * @param identNode an identity node to load
   * @return the method generator used
   */
  MethodEmitter loadIdent(IdentNode identNode, TypeBounds resultBounds) {
    checkTemporalDeadZone(identNode);
    var symbol = identNode.getSymbol();
    if (!symbol.isScope()) {
      var type = identNode.getType();
      if (type == Type.UNDEFINED) {
        return method.loadUndefined(resultBounds.widest);
      }
      assert symbol.hasSlot() || symbol.isParam();
      return method.load(identNode);
    }
    assert identNode.getSymbol().isScope() : identNode + " is not in scope!";
    var flags = getScopeCallSiteFlags(symbol);
    if (!isFastScope(symbol)) {
      // slow scope load, prototype chain must be inspected at runtime
      new LoadScopeVar(identNode, resultBounds, flags).emit();
    } else if (identNode.isCompileTimePropertyName() || symbol.getUseCount() < SharedScopeCall.SHARED_GET_THRESHOLD) {
      // fast scope load with known prototype depth
      new LoadFastScopeVar(identNode, resultBounds, flags).emit();
    } else {
      // Only generate shared scope getter for often used fast-scope symbols.
      new OptimisticOperation(identNode, resultBounds) {
        @Override
        void loadStack() {
          method.loadCompilerConstant(SCOPE);
          var depth = getScopeProtoDepth(lc.getCurrentBlock(), symbol);
          assert depth >= 0;
          method.load(depth);
          method.load(getProgramPoint());
        }
        @Override
        void consumeStack() {
          var resultType = isOptimistic ? getOptimisticCoercedType() : resultBounds.widest;
          lc.getScopeGet(unit, symbol, resultType, flags, isOptimistic).generateInvoke(method);
        }
      }.emit();
    }
    return method;
  }

  // Any access to LET and CONST variables before their declaration must throw ReferenceError.
  // This is called the temporal dead zone (TDZ). See https://gist.github.com/rwaldron/f0807a758aa03bcdd58a
  void checkTemporalDeadZone(IdentNode identNode) {
    if (identNode.isDead()) {
      method.load(identNode.getSymbol().getName()).invoke(ScriptRuntime.THROW_REFERENCE_ERROR);
    }
  }

  // Runtime check for assignment to ES6 const
  void checkAssignTarget(Expression expression) {
    if (expression instanceof IdentNode && ((IdentNode) expression).getSymbol().isConst()) {
      method.load(((IdentNode) expression).getSymbol().getName()).invoke(ScriptRuntime.THROW_CONST_TYPE_ERROR);
    }
  }

  boolean isRestOf() {
    return continuationEntryPoints != null;
  }

  boolean isCurrentContinuationEntryPoint(int programPoint) {
    return isRestOf() && getCurrentContinuationEntryPoint() == programPoint;
  }

  int[] getContinuationEntryPoints() {
    return isRestOf() ? continuationEntryPoints : null;
  }

  int getCurrentContinuationEntryPoint() {
    return isRestOf() ? continuationEntryPoints[0] : INVALID_PROGRAM_POINT;
  }

  boolean isContinuationEntryPoint(int programPoint) {
    if (isRestOf()) {
      assert continuationEntryPoints != null;
      for (var cep : continuationEntryPoints) {
        if (cep == programPoint) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * Check if this symbol can be accessed directly with a putfield or getfield or dynamic load
   * @param symbol symbol to check for fast scope
   * @return true if fast scope
   */
  boolean isFastScope(Symbol symbol) {
    if (!symbol.isScope()) {
      return false;
    }
    if (!lc.inDynamicScope()) {
      // If there's no with or eval in context, and the symbol is marked as scoped, it is fast scoped. Such a
      // symbol must either be global, or its defining block must need scope.
      assert symbol.isGlobal() || lc.getDefiningBlock(symbol).needsScope() : symbol.getName();
      return true;
    }
    if (symbol.isGlobal()) {
      // Shortcut: if there's a with or eval in context, globals can't be fast scoped
      return false;
    }
    // Otherwise, check if there's a dynamic scope between use of the symbol and its definition
    var name = symbol.getName();
    var previousWasBlock = false;
    for (var it = lc.getAllNodes(); it.hasNext();) {
      var node = it.next();
      if (node instanceof Block block) {
        // If this block defines the symbol, then we can fast scope the symbol.
        if (block.getExistingSymbol(name) == symbol) {
          assert block.needsScope();
          return true;
        }
        previousWasBlock = true;
      } else {
        previousWasBlock = false;
      }
    }
    // Should've found the symbol defined in a block
    throw new AssertionError();
  }

  class LoadScopeVar extends OptimisticOperation {

    final IdentNode identNode;
    private final int flags;

    LoadScopeVar(IdentNode identNode, TypeBounds resultBounds, int flags) {
      super(identNode, resultBounds);
      this.identNode = identNode;
      this.flags = flags;
    }

    @Override
    void loadStack() {
      method.loadCompilerConstant(SCOPE);
      getProto();
    }

    void getProto() {
      //empty
    }

    @Override
    void consumeStack() {
      // If this is either __FILE__, __DIR__, or __LINE__ then load the property initially as Object as we'd convert it anyway for replaceLocationPropertyPlaceholder.
      if (identNode.isCompileTimePropertyName()) {
        method.dynamicGet(Type.OBJECT, identNode.getSymbol().getName(), flags, identNode.isFunction(), false);
        replaceCompileTimeProperty();
      } else {
        dynamicGet(identNode.getSymbol().getName(), flags, identNode.isFunction(), false);
      }
    }
  }

  class LoadFastScopeVar extends LoadScopeVar {

    LoadFastScopeVar(IdentNode identNode, TypeBounds resultBounds, int flags) {
      super(identNode, resultBounds, flags);
    }

    @Override
    void getProto() {
      loadFastScopeProto(identNode.getSymbol(), false);
    }
  }

  MethodEmitter storeFastScopeVar(Symbol symbol, int flags) {
    loadFastScopeProto(symbol, true);
    method.dynamicSet(symbol.getName(), flags, false);
    return method;
  }

  int getScopeProtoDepth(Block startingBlock, Symbol symbol) {
    // walk up the chain from starting block and when we bump into the current function boundary, add the external information.
    var fn = lc.getCurrentFunction();
    var externalDepth = compiler.getScriptFunctionData(fn.getId()).getExternalSymbolDepth(symbol.getName());
    // count the number of scopes from this place to the start of the function
    var internalDepth = FindScopeDepths.findInternalDepth(lc, fn, startingBlock, symbol);
    var scopesToStart = FindScopeDepths.findScopesToStart(lc, fn, startingBlock);
    var depth = 0;
    if (internalDepth == -1) {
      depth = scopesToStart + externalDepth;
    } else {
      assert internalDepth <= scopesToStart;
      depth = internalDepth;
    }
    return depth;
  }

  void loadFastScopeProto(Symbol symbol, boolean swap) {
    var depth = getScopeProtoDepth(lc.getCurrentBlock(), symbol);
    assert depth != -1 : "Couldn't find scope depth for symbol " + symbol.getName() + " in " + lc.getCurrentFunction();
    if (depth > 0) {
      if (swap) {
        method.swap();
      }
      invokeGetProto(depth);
      if (swap) {
        method.swap();
      }
    }
  }

  void invokeGetProto(int depth) {
    assert depth > 0;
    if (depth > 1) {
      method.load(depth);
      method.invoke(ScriptObject.GET_PROTO_DEPTH);
    } else {
      method.invoke(ScriptObject.GET_PROTO);
    }
  }

  /**
   * Generate code that loads this node to the stack, not constraining its type
   * @param expr node to load
   * @return the method emitter used
   */
  MethodEmitter loadExpressionUnbounded(Expression expr) {
    return loadExpression(expr, TypeBounds.UNBOUNDED);
  }

  MethodEmitter loadExpressionAsObject(Expression expr) {
    return loadExpression(expr, TypeBounds.OBJECT);
  }

  MethodEmitter loadExpressionAsBoolean(Expression expr) {
    return loadExpression(expr, TypeBounds.BOOLEAN);
  }

  // Test whether conversion from source to target involves a call of ES 9.1 ToPrimitive with possible side effects from calling an object's toString or valueOf methods.
  static boolean noToPrimitiveConversion(Type source, Type target) {
    // Object to boolean conversion does not cause ToPrimitive call
    return source.isJSPrimitive() || !target.isJSPrimitive() || target.isBoolean();
  }

  MethodEmitter loadBinaryOperands(BinaryNode binaryNode) {
    return loadBinaryOperands(binaryNode.lhs(), binaryNode.rhs(), TypeBounds.UNBOUNDED.notWiderThan(binaryNode.getWidestOperandType()), false, false);
  }

  /**
   * ECMAScript 5.1 specification (sections 11.5-11.11 and 11.13) prescribes that when evaluating a binary expression "LEFT op RIGHT", the order of operations must be: LOAD LEFT, LOAD RIGHT, CONVERT LEFT, CONVERT RIGHT, EXECUTE OP.
   * Unfortunately, doing it in this order defeats potential optimizations that arise when we can combine a LOAD with a CONVERT operation (e.g. use a dynamic getter with the conversion target type as its return value).
   * What we do here is reorder LOAD RIGHT and CONVERT LEFT when possible; it is possible only when we can prove that executing CONVERT LEFT can't have a side effect that changes the value of LOAD RIGHT.
   * Basically, if we know that either LEFT already is a primitive value, or does not have to be converted to a primitive value, or RIGHT is an expression that loads without side effects, then we can do the reordering and collapse LOAD/CONVERT into a single operation; otherwise we need to do the more costly separate operations to preserve specification semantics.
   */
  MethodEmitter loadBinaryOperands(Expression lhs, Expression rhs, TypeBounds explicitOperandBounds, boolean baseAlreadyOnStack, boolean forceConversionSeparation) {
    // Operands' load type should not be narrower than the narrowest of the individual operand types, nor narrower than the lower explicit bound, but it should also not be wider than
    var lhsType = undefinedToNumber(lhs.getType());
    var rhsType = undefinedToNumber(rhs.getType());
    var narrowestOperandType = Type.narrowest(Type.widest(lhsType, rhsType), explicitOperandBounds.widest);
    var operandBounds = explicitOperandBounds.notNarrowerThan(narrowestOperandType);
    if (noToPrimitiveConversion(lhsType, explicitOperandBounds.widest) || rhs.isLocal()) {
      // Can reorder. We might still need to separate conversion, but at least we can do it with reordering
      if (forceConversionSeparation) {
        // Can reorder, but can't move conversion into the operand as the operation depends on operands exact types for its overflow guarantees.
        // E.g. with {L}{%I}expr1 {L}* {L}{%I}expr2 we are not allowed to merge {L}{%I} into {%L}, as that can cause subsequent overflows; test for JDK-8058610 contains concrete cases where this could happen.
        var safeConvertBounds = TypeBounds.UNBOUNDED.notNarrowerThan(narrowestOperandType);
        loadExpression(lhs, safeConvertBounds, baseAlreadyOnStack);
        method.convert(operandBounds.within(method.peekType()));
        loadExpression(rhs, safeConvertBounds, false);
        method.convert(operandBounds.within(method.peekType()));
      } else {
        // Can reorder and move conversion into the operand. Combine load and convert into single operations.
        loadExpression(lhs, operandBounds, baseAlreadyOnStack);
        loadExpression(rhs, operandBounds, false);
      }
    } else {
      // Can't reorder. Load and convert separately.
      var safeConvertBounds = TypeBounds.UNBOUNDED.notNarrowerThan(narrowestOperandType);
      loadExpression(lhs, safeConvertBounds, baseAlreadyOnStack);
      var lhsLoadedType = method.peekType();
      loadExpression(rhs, safeConvertBounds, false);
      var convertedLhsType = operandBounds.within(method.peekType());
      if (convertedLhsType != lhsLoadedType) {
        // Do it conditionally, so that if conversion is a no-op we don't introduce a SWAP, SWAP.
        method.swap().convert(convertedLhsType).swap();
      }
      method.convert(operandBounds.within(method.peekType()));
    }
    assert Type.generic(method.peekType()) == operandBounds.narrowest;
    assert Type.generic(method.peekType(1)) == operandBounds.narrowest;
    return method;
  }

  /**
   * Similar to {@link #loadBinaryOperands(BinaryNode)} but used specifically for loading operands of relational and equality comparison operators where at least one argument is non-object.
   * (When both arguments are objects, we use {@link ScriptRuntime#EQ(Object, Object)}, {@link ScriptRuntime#LT(Object, Object)} etc. methods instead.
   * Additionally, {@code ScriptRuntime} methods are used for (in)equality comparison of a boolean to anything that isn't a boolean.)
   * This method handles the special case where one argument is an object and another is a primitive.
   * Naively, these could also be delegated to {@code ScriptRuntime} methods by boxing the primitive.
   * However, in all such cases the comparison is performed on numeric values, so it is possible to strength-reduce the operation by taking the number value of the object argument instead and comparing that to the primitive value ("primitive" will always be int, long, double, or boolean, and booleans compare as ints in these cases, so they're essentially numbers too).
   * This method will emit code for loading arguments for such strength-reduced comparison.
   * When both arguments are primitives, it just delegates to {@link #loadBinaryOperands(BinaryNode)}.
   * @param cmp the comparison operation for which the operands need to be loaded on stack.
   * @return the current method emitter.
   */
  MethodEmitter loadComparisonOperands(BinaryNode cmp) {
    var lhs = cmp.lhs();
    var rhs = cmp.rhs();
    var lhsType = lhs.getType();
    var rhsType = rhs.getType();
    // Only used when not both are object, for that we have ScriptRuntime.LT etc.
    assert !(lhsType.isObject() && rhsType.isObject());
    if (lhsType.isObject() || rhsType.isObject()) {
      // We can reorder CONVERT LEFT and LOAD RIGHT only if either the left is a primitive, or the right is a local.
      // This is more constrained than loadBinaryNode reorder criteria, as it can allow JS primitive types too (notably: String is a JS primitive, but not a JVM primitive).
      // We disallow String otherwise we would prematurely convert it to number when comparing to an optimistic expression, e.g. in "Hello" === String("Hello") the RHS starts out as an optimistic-int function call.
      // If we allowed reordering, we'd end up with ToNumber("Hello") === {I%}String("Hello") that is obviously incorrect.
      var canReorder = lhsType.isPrimitive() || rhs.isLocal();
      // If reordering is allowed, and we're using a relational operator (that is, <, <=, >, >=) and not an (in)equality operator, then we encourage combining of LOAD and CONVERT into a single operation.
      // This is because relational operators' semantics prescribes vanilla ToNumber() conversion, while (in)equality operators need the specialized JSType.toNumberForEquals.
      // E.g. in the code snippet "i < obj.size" (where i is primitive and obj.size is statically an object), ".size" will thus be allowed to compile as:
      //   invokedynamic GET_PROPERTY:size(Object;)D
      // instead of the more costly:
      //   invokedynamic GET_PROPERTY:size(Object;)Object
      //   invokestatic JSType.toNumber(Object)D
      // Note also that even if this is allowed, we're only using it on operands that are non-optimistic, as otherwise the logic for determining effective optimistic-ness would turn an optimistic double return into a freely coercible one, which would be wrong.
      var canCombineLoadAndConvert = canReorder && cmp.isRelational();
      // LOAD LEFT
      loadExpression(lhs, canCombineLoadAndConvert && !lhs.isOptimistic() ? TypeBounds.NUMBER : TypeBounds.UNBOUNDED);
      var lhsLoadedType = method.peekType();
      var tt = cmp.tokenType();
      if (canReorder) {
        // Can reorder CONVERT LEFT and LOAD RIGHT
        emitObjectToNumberComparisonConversion(method, tt);
        loadExpression(rhs, canCombineLoadAndConvert && !rhs.isOptimistic() ? TypeBounds.NUMBER : TypeBounds.UNBOUNDED);
      } else {
        // Can't reorder CONVERT LEFT and LOAD RIGHT
        loadExpression(rhs, TypeBounds.UNBOUNDED);
        if (lhsLoadedType != Type.NUMBER) {
          method.swap();
          emitObjectToNumberComparisonConversion(method, tt);
          method.swap();
        }
      }
      // CONVERT RIGHT
      emitObjectToNumberComparisonConversion(method, tt);
      return method;
    }
    // For primitive operands, just don't do anything special.
    return loadBinaryOperands(cmp);
  }

  static void emitObjectToNumberComparisonConversion(MethodEmitter method, TokenType tt) {
    switch (tt) {
      case EQ, NE -> {
        if (method.peekType().isObject()) {
          TO_NUMBER_FOR_EQ.invoke(method);
          return;
        }
      }
      case EQU, NEQU -> {
        if (method.peekType().isObject()) {
          TO_NUMBER_FOR_EQUIV.invoke(method);
          return;
        }
      }
      // default: pass
    }
    method.convert(Type.NUMBER);
  }

  static Type undefinedToNumber(Type type) {
    return type == Type.UNDEFINED ? Type.NUMBER : type;
  }

  static final class TypeBounds {

    final Type narrowest;
    final Type widest;

    static final TypeBounds UNBOUNDED = new TypeBounds(Type.UNKNOWN, Type.OBJECT);
    static final TypeBounds INT = exact(Type.INT);
    static final TypeBounds NUMBER = exact(Type.NUMBER);
    static final TypeBounds OBJECT = exact(Type.OBJECT);
    static final TypeBounds BOOLEAN = exact(Type.BOOLEAN);

    static TypeBounds exact(Type type) {
      return new TypeBounds(type, type);
    }

    TypeBounds(Type narrowest, Type widest) {
      assert widest != null && widest != Type.UNDEFINED && widest != Type.UNKNOWN : widest;
      assert narrowest != null && narrowest != Type.UNDEFINED : narrowest;
      assert !narrowest.widerThan(widest) : narrowest + " wider than " + widest;
      assert !widest.narrowerThan(narrowest);
      this.narrowest = Type.generic(narrowest);
      this.widest = Type.generic(widest);
    }

    TypeBounds notNarrowerThan(Type type) {
      return maybeNew(Type.narrowest(Type.widest(narrowest, type), widest), widest);
    }

    TypeBounds notWiderThan(Type type) {
      return maybeNew(Type.narrowest(narrowest, type), Type.narrowest(widest, type));
    }

    boolean canBeNarrowerThan(Type type) {
      return narrowest.narrowerThan(type);
    }

    TypeBounds maybeNew(Type newNarrowest, Type newWidest) {
      return (newNarrowest == narrowest && newWidest == widest) ? this : new TypeBounds(newNarrowest, newWidest);
    }

    TypeBounds booleanToInt() {
      return maybeNew(CodeGenerator.booleanToInt(narrowest), CodeGenerator.booleanToInt(widest));
    }

    TypeBounds objectToNumber() {
      return maybeNew(CodeGenerator.objectToNumber(narrowest), CodeGenerator.objectToNumber(widest));
    }

    Type within(Type type) {
      return (type.narrowerThan(narrowest)) ? narrowest
           : (type.widerThan(widest)) ? widest
           : type;
    }

    @Override
    public String toString() {
      return "[" + narrowest + ", " + widest + "]";
    }
  }

  static Type booleanToInt(Type t) {
    return t == Type.BOOLEAN ? Type.INT : t;
  }

  static Type objectToNumber(Type t) {
    return t.isObject() ? Type.NUMBER : t;
  }

  MethodEmitter loadExpressionAsType(Expression expr, Type type) {
    if (type == Type.BOOLEAN) {
      return loadExpressionAsBoolean(expr);
    } else if (type == Type.UNDEFINED) {
      assert expr.getType() == Type.UNDEFINED;
      return loadExpressionAsObject(expr);
    }
    // having no upper bound preserves semantics of optimistic operations in the expression (by not having them converted early) and then applies explicit conversion afterwards.
    return loadExpression(expr, TypeBounds.UNBOUNDED.notNarrowerThan(type)).convert(type);
  }

  MethodEmitter loadExpression(Expression expr, TypeBounds resultBounds) {
    return loadExpression(expr, resultBounds, false);
  }

  /**
   * Emits code for evaluating an expression and leaving its value on top of the stack, narrowing or widening it if necessary.
   * @param expr the expression to load
   * @param resultBounds the incoming type bounds. The value on the top of the stack is guaranteed to not be of narrower type than the narrowest bound, or wider type than the widest bound after it is loaded.
   * @param baseAlreadyOnStack true if the base of an access or index node is already on the stack. Used to avoid double evaluation of bases in self-assignment expressions to access and index nodes. {@code Type.OBJECT} is used to indicate the widest possible type.
   * @return the method emitter
   */
  private MethodEmitter loadExpression(Expression expr, TypeBounds resultBounds, boolean baseAlreadyOnStack) {
    // The load may be of type IdentNode, e.g. "x", AccessNode, e.g. "x.y" or IndexNode e.g. "x[y]".
    // Both AccessNodes and IndexNodes are BaseNodes and the logic for loading the base object is reused
    var codegen = this;
    var isCurrentDiscard = codegen.lc.isCurrentDiscard(expr);
    expr.accept(new NodeOperatorVisitor<LexicalContext>(new LexicalContext()) {

      @Override
      public boolean enterIdentNode(IdentNode identNode) {
        loadIdent(identNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterAccessNode(AccessNode accessNode) {
        new OptimisticOperation(accessNode, resultBounds) {
          @Override
          void loadStack() {
            if (!baseAlreadyOnStack) {
              loadExpressionAsObject(accessNode.getBase());
            }
            assert method.peekType().isObject();
          }
          @Override
          void consumeStack() {
            var flags = getCallSiteFlags();
            dynamicGet(accessNode.getProperty(), flags, accessNode.isFunction(), accessNode.isIndex());
          }
        }.emit(baseAlreadyOnStack ? 1 : 0);
        return false;
      }

      @Override
      public boolean enterIndexNode(IndexNode indexNode) {
        new OptimisticOperation(indexNode, resultBounds) {
          @Override
          void loadStack() {
            if (!baseAlreadyOnStack) {
              loadExpressionAsObject(indexNode.getBase());
              loadExpressionUnbounded(indexNode.getIndex());
            }
          }
          @Override
          void consumeStack() {
            final int flags = getCallSiteFlags();
            dynamicGetIndex(flags, indexNode.isFunction());
          }
        }.emit(baseAlreadyOnStack ? 2 : 0);
        return false;
      }

      @Override
      public boolean enterFunctionNode(FunctionNode functionNode) {
        // function nodes will always leave a constructed function object on stack, no need to load the symbol separately as in enterDefault()
        lc.pop(functionNode);
        functionNode.accept(codegen);
        // NOTE: functionNode.accept() will produce a different FunctionNode that we discard.
        // This incidentally doesn't cause problems as we're never touching FunctionNode again after it's visited here - codegen is the last element in the compilation pipeline, the AST it produces is not used externally.
        // So, we re-push the original functionNode.
        lc.push(functionNode);
        return false;
      }

      @Override
      public boolean enterASSIGN(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_ADD(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_ADD(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_BIT_AND(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_BIT_AND(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_BIT_OR(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_BIT_OR(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_BIT_XOR(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_BIT_XOR(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_DIV(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_DIV(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_MOD(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_MOD(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_MUL(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_MUL(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_SAR(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_SAR(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_SHL(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_SHL(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_SHR(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_SHR(binaryNode);
        return false;
      }

      @Override
      public boolean enterASSIGN_SUB(BinaryNode binaryNode) {
        checkAssignTarget(binaryNode.lhs());
        loadASSIGN_SUB(binaryNode);
        return false;
      }

      @Override
      public boolean enterCallNode(CallNode callNode) {
        return loadCallNode(callNode, resultBounds);
      }

      @Override
      public boolean enterLiteralNode(LiteralNode<?> literalNode) {
        loadLiteral(literalNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterTernaryNode(TernaryNode ternaryNode) {
        loadTernaryNode(ternaryNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterADD(BinaryNode binaryNode) {
        loadADD(binaryNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterNEG(UnaryNode unaryNode) {
        loadSUB(unaryNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterSUB(BinaryNode binaryNode) {
        loadSUB(binaryNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterMUL(BinaryNode binaryNode) {
        loadMUL(binaryNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterDIV(BinaryNode binaryNode) {
        loadDIV(binaryNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterMOD(BinaryNode binaryNode) {
        loadMOD(binaryNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterSAR(BinaryNode binaryNode) {
        loadSAR(binaryNode);
        return false;
      }

      @Override
      public boolean enterSHL(BinaryNode binaryNode) {
        loadSHL(binaryNode);
        return false;
      }

      @Override
      public boolean enterSHR(BinaryNode binaryNode) {
        loadSHR(binaryNode);
        return false;
      }

      @Override
      public boolean enterCOMMARIGHT(BinaryNode binaryNode) {
        loadCOMMARIGHT(binaryNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterAND(BinaryNode binaryNode) {
        loadAND_OR(binaryNode, resultBounds, true);
        return false;
      }

      @Override
      public boolean enterOR(BinaryNode binaryNode) {
        loadAND_OR(binaryNode, resultBounds, false);
        return false;
      }

      @Override
      public boolean enterNOT(UnaryNode unaryNode) {
        loadNOT(unaryNode);
        return false;
      }

      @Override
      public boolean enterPOS(UnaryNode unaryNode) {
        loadADD(unaryNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterBIT_NOT(UnaryNode unaryNode) {
        loadBIT_NOT(unaryNode);
        return false;
      }

      @Override
      public boolean enterBIT_AND(BinaryNode binaryNode) {
        loadBIT_AND(binaryNode);
        return false;
      }

      @Override
      public boolean enterBIT_OR(BinaryNode binaryNode) {
        loadBIT_OR(binaryNode);
        return false;
      }

      @Override
      public boolean enterBIT_XOR(BinaryNode binaryNode) {
        loadBIT_XOR(binaryNode);
        return false;
      }

      @Override
      public boolean enterVOID(UnaryNode unaryNode) {
        loadVOID(unaryNode, resultBounds);
        return false;
      }

      @Override
      public boolean enterDELETE(UnaryNode unaryNode) {
        loadDELETE(unaryNode);
        return false;
      }

      @Override
      public boolean enterEQ(BinaryNode binaryNode) {
        loadCmp(binaryNode, Condition.EQ);
        return false;
      }

      @Override
      public boolean enterEQUIV(BinaryNode binaryNode) {
        loadCmp(binaryNode, Condition.EQ);
        return false;
      }

      @Override
      public boolean enterGE(BinaryNode binaryNode) {
        loadCmp(binaryNode, Condition.GE);
        return false;
      }

      @Override
      public boolean enterGT(BinaryNode binaryNode) {
        loadCmp(binaryNode, Condition.GT);
        return false;
      }

      @Override
      public boolean enterLE(BinaryNode binaryNode) {
        loadCmp(binaryNode, Condition.LE);
        return false;
      }

      @Override
      public boolean enterLT(BinaryNode binaryNode) {
        loadCmp(binaryNode, Condition.LT);
        return false;
      }

      @Override
      public boolean enterNE(BinaryNode binaryNode) {
        loadCmp(binaryNode, Condition.NE);
        return false;
      }

      @Override
      public boolean enterNOT_EQUIV(BinaryNode binaryNode) {
        loadCmp(binaryNode, Condition.NE);
        return false;
      }

      @Override
      public boolean enterObjectNode(ObjectNode objectNode) {
        loadObjectNode(objectNode);
        return false;
      }

      @Override
      public boolean enterRuntimeNode(RuntimeNode runtimeNode) {
        loadRuntimeNode(runtimeNode);
        return false;
      }

      @Override
      public boolean enterNEW(UnaryNode unaryNode) {
        loadNEW(unaryNode);
        return false;
      }

      @Override
      public boolean enterDECINC(UnaryNode unaryNode) {
        checkAssignTarget(unaryNode.getExpression());
        loadDECINC(unaryNode);
        return false;
      }

      @Override
      public boolean enterJoinPredecessorExpression(JoinPredecessorExpression joinExpr) {
        loadMaybeDiscard(joinExpr, joinExpr.getExpression(), resultBounds);
        return false;
      }

      @Override
      public boolean enterGetSplitState(GetSplitState getSplitState) {
        method.loadScope();
        method.invoke(Scope.GET_SPLIT_STATE);
        return false;
      }

      @Override
      public boolean enterDefault(Node otherNode) {
        // Must have handled all expressions that can legally be encountered.
        throw new AssertionError(otherNode.getClass().getName());
      }
    });
    if (!isCurrentDiscard) {
      coerceStackTop(resultBounds);
    }
    return method;
  }

  MethodEmitter coerceStackTop(TypeBounds typeBounds) {
    return method.convert(typeBounds.within(method.peekType()));
  }

  /**
   * Closes any still open entries for this block's local variables in the bytecode local variable table.
   * @param block block containing symbols.
   */
  void closeBlockVariables(Block block) {
    for (var symbol : block.getSymbols()) {
      if (symbol.isBytecodeLocal()) {
        method.closeLocalVariable(symbol, block.getBreakLabel());
      }
    }
  }

  @Override
  public boolean enterBlock(Block block) {
    var entryLabel = block.getEntryLabel();
    if (entryLabel.isBreakTarget()) {
      // Entry label is a break target only for an inlined finally block.
      assert !method.isReachable();
      method.breakLabel(entryLabel, lc.getUsedSlotCount());
    } else {
      method.label(entryLabel);
    }
    if (!method.isReachable()) {
      return false;
    }
    if (lc.isFunctionBody() && emittedMethods.contains(lc.getCurrentFunction().getName())) {
      return false;
    }
    initLocals(block);
    assert lc.getUsedSlotCount() == method.getFirstTemp();
    return true;
  }

  boolean useOptimisticTypes() {
    return !lc.inSplitLiteral() && compiler.useOptimisticTypes();
  }

  @Override
  public Node leaveBlock(Block block) {
    popBlockScope(block);
    method.beforeJoinPoint(block);
    closeBlockVariables(block);
    lc.releaseSlots();
    assert !method.isReachable() || (lc.isFunctionBody() ? 0 : lc.getUsedSlotCount()) == method.getFirstTemp() :
      "reachable=" + method.isReachable() + " isFunctionBody=" + lc.isFunctionBody() + " usedSlotCount=" + lc.getUsedSlotCount() + " firstTemp=" + method.getFirstTemp();
    return block;
  }

  void popBlockScope(Block block) {
    var breakLabel = block.getBreakLabel();
    if (block.providesScopeCreator()) {
      scopeObjectCreators.pop();
    }
    if (!block.needsScope() || lc.isFunctionBody()) {
      emitBlockBreakLabel(breakLabel);
      return;
    }
    var beginTryLabel = scopeEntryLabels.pop();
    var recoveryLabel = new Label("block_popscope_catch");
    emitBlockBreakLabel(breakLabel);
    var bodyCanThrow = breakLabel.isAfter(beginTryLabel);
    if (bodyCanThrow) {
      method.try_(beginTryLabel, breakLabel, recoveryLabel);
    }
    Label afterCatchLabel = null;
    if (method.isReachable()) {
      popScope();
      if (bodyCanThrow) {
        afterCatchLabel = new Label("block_after_catch");
        method.goto_(afterCatchLabel);
      }
    }
    if (bodyCanThrow) {
      assert !method.isReachable();
      method.catch_(recoveryLabel);
      popScopeException();
      method.athrow();
    }
    if (afterCatchLabel != null) {
      method.label(afterCatchLabel);
    }
  }

  void emitBlockBreakLabel(Label breakLabel) {
    // TODO: this is totally backwards. Block should not be breakable, LabelNode should be breakable.
    var labelNode = lc.getCurrentBlockLabelNode();
    if (labelNode != null) {
      // Only have conversions if we're reachable
      assert labelNode.getLocalVariableConversion() == null || method.isReachable();
      method.beforeJoinPoint(labelNode);
      method.breakLabel(breakLabel, labeledBlockBreakLiveLocals.pop());
    } else {
      method.label(breakLabel);
    }
  }

  void popScope() {
    popScopes(1);
  }

  /**
   * Pop scope as part of an exception handler.
   * Similar to {@code popScope()} but also takes care of adjusting the number of scopes that needs to be popped in case a rest-of continuation handler encounters an exception while performing a ToPrimitive conversion.
   */
  void popScopeException() {
    popScope();
    var ci = getContinuationInfo();
    if (ci != null) {
      var catchLabel = ci.catchLabel;
      if (catchLabel != METHOD_BOUNDARY && catchLabel == catchLabels.peek()) {
        ++ci.exceptionScopePops;
      }
    }
  }

  void popScopesUntil(LexicalContextNode until) {
    popScopes(lc.getScopeNestingLevelTo(until));
  }

  void popScopes(int count) {
    if (count == 0) {
      return;
    }
    assert count > 0; // together with count == 0 check, asserts nonnegative count
    if (!method.hasScope()) {
      // We can sometimes invoke this method even if the method has no slot for the scope object.
      // Typical example: for(;;) { with({}) { break; } }.
      // WithNode normally creates a scope, but if it uses no identifiers and nothing else forces creation of a scope in the method, we just won't have the :scope local variable.
      return;
    }
    method.loadCompilerConstant(SCOPE);
    invokeGetProto(count);
    method.storeCompilerConstant(SCOPE);
  }

  @Override
  public boolean enterBreakNode(BreakNode breakNode) {
    return enterJumpStatement(breakNode);
  }

  @Override
  public boolean enterJumpToInlinedFinally(JumpToInlinedFinally jumpToInlinedFinally) {
    return enterJumpStatement(jumpToInlinedFinally);
  }

  boolean enterJumpStatement(JumpStatement jump) {
    if (!method.isReachable()) {
      return false;
    }
    enterStatement(jump);
    method.beforeJoinPoint(jump);
    popScopesUntil(jump.getPopScopeLimit(lc));
    var targetLabel = jump.getTargetLabel(lc);
    targetLabel.markAsBreakTarget();
    method.goto_(targetLabel);
    return false;
  }

  int loadArgs(List<Expression> args) {
    var argCount = args.size();
    // arg have already been converted to objects here.
    if (argCount > LinkerCallSite.ARGLIMIT) {
      loadArgsArray(args);
      return 1;
    }
    for (var arg : args) {
      assert arg != null;
      loadExpressionUnbounded(arg);
    }
    return argCount;
  }

  boolean loadCallNode(CallNode callNode, TypeBounds resultBounds) {
    lineNumber(callNode.getLineNumber());
    var args = callNode.getArgs();
    var function = callNode.getFunction();
    var currentBlock = lc.getCurrentBlock();
    var codegenLexicalContext = lc;
    function.accept(new SimpleNodeVisitor() {

      MethodEmitter sharedScopeCall(IdentNode identNode, int flags) {
        var symbol = identNode.getSymbol();
        assert isFastScope(symbol);
        new OptimisticOperation(callNode, resultBounds) {
          @Override
          void loadStack() {
            method.loadCompilerConstant(SCOPE);
            var depth = getScopeProtoDepth(currentBlock, symbol);
            assert depth >= 0;
            method.load(depth);
            method.load(getProgramPoint());
            loadArgs(args);
          }
          @Override
          void consumeStack() {
            var paramTypes = method.getTypesFromStack(args.size());
            // We have trouble finding e.g. in Type.typeFor(asm.Type) because it can't see the Context class loader, so we need to weaken reference signatures to Object.
            for (var i = 0; i < paramTypes.length; ++i) {
              paramTypes[i] = Type.generic(paramTypes[i]);
            }
            var resultType = isOptimistic ? getOptimisticCoercedType() : resultBounds.widest;
            var scopeCall = codegenLexicalContext.getScopeCall(unit, symbol, identNode.getType(), resultType, paramTypes, flags, isOptimistic);
            scopeCall.generateInvoke(method);
          }
        }.emit();
        return method;
      }

      void scopeCall(IdentNode ident, int flags) {
        new OptimisticOperation(callNode, resultBounds) {
          int argsCount;
          @Override
          void loadStack() {
            loadExpressionAsObject(ident); // foo() makes no sense if foo == 3
            // ScriptFunction will see CALLSITE_SCOPE and will bind scope accordingly.
            method.loadUndefined(Type.OBJECT); //the 'this'
            argsCount = loadArgs(args);
          }
          @Override
          void consumeStack() {
            dynamicCall(2 + argsCount, flags, ident.getName());
          }
        }.emit();
      }

      void evalCall(IdentNode ident, int flags) {
        var invoke_direct_eval = new Label("invoke_direct_eval");
        var is_not_eval = new Label("is_not_eval");
        var eval_done = new Label("eval_done");
        new OptimisticOperation(callNode, resultBounds) {
          int argsCount;
          // We want to load 'eval' to check if it is indeed global builtin eval.
          // If this eval call is inside a 'with' statement, GET_METHOD_PROPERTY would be generated if ident is a "isFunction".
          // But, that would result in a bound function from WithObject.
          // We don't want that as bound function as that won't be detected as builtin eval.
          // So, we make ident as "not a function" which results in GET_PROPERTY being generated and so WithObject would return unbounded eval function.
          //
          // Example:
          //   var global = this;
          //   function func() {
          //     with({ eval: global.eval) { eval("var x = 10;") }
          //   }
          @Override
          void loadStack() {
            loadExpressionAsObject(ident.setIsNotFunction()); // Type.OBJECT as foo() makes no sense if foo == 3
            globalIsEval();
            method.ifeq(is_not_eval);
            // Load up self (scope).
            method.loadCompilerConstant(SCOPE);
            var evalArgs = callNode.getEvalArgs().getArgs();
            // load evaluated code
            loadExpressionAsObject(evalArgs.get(0));
            // load second and subsequent args for side-effect
            var numArgs = evalArgs.size();
            for (var i = 1; i < numArgs; i++) {
              loadAndDiscard(evalArgs.get(i));
            }
            method.goto_(invoke_direct_eval);
            method.label(is_not_eval);
            // load this time but with GET_METHOD_PROPERTY
            loadExpressionAsObject(ident); // Type.OBJECT as foo() makes no sense if foo == 3
            // This is some scope 'eval' or global eval replaced by user but not the built-in ECMAScript 'eval' function call
            method.loadNull();
            argsCount = loadArgs(callNode.getArgs());
          }
          @Override
          void consumeStack() {
            // Ordinary call
            dynamicCall(2 + argsCount, flags, "eval");
            method.goto_(eval_done);
            method.label(invoke_direct_eval);
            // Special/extra 'eval' arguments.
            // These can be loaded late (in consumeStack) as we know none of them can ever be optimistic.
            method.loadCompilerConstant(THIS);
            method.load(callNode.getEvalArgs().getLocation());
            // direct call to Global.directEval
            globalDirectEval();
            convertOptimisticReturnValue();
            coerceStackTop(resultBounds);
          }
        }.emit();
        method.label(eval_done);
      }

      @Override
      public boolean enterIdentNode(IdentNode node) {
        var symbol = node.getSymbol();
        if (symbol.isScope()) {
          var flags = getScopeCallSiteFlags(symbol);
          var useCount = symbol.getUseCount();
          // We only use shared scope calls for fast scopes
          if (callNode.isEval()) {
            evalCall(node, flags);
          } else if (!isFastScope(symbol) || symbol.getUseCount() < SharedScopeCall.SHARED_CALL_THRESHOLD) {
            scopeCall(node, flags);
          } else {
            sharedScopeCall(node, flags);
          }
          assert method.peekType().equals(resultBounds.within(callNode.getType())) : method.peekType() + " != " + resultBounds + "(" + callNode.getType() + ")";
        } else {
          enterDefault(node);
        }
        return false;
      }
      @Override
      public boolean enterAccessNode(AccessNode node) {
        // check if this is an apply to call node.
        // only real applies, that haven't been shadowed from their way to the global scope counts.
        // call nodes have program points.
        var flags = getCallSiteFlags() | (callNode.isApplyToCall() ? CALLSITE_APPLY_TO_CALL : 0);
        new OptimisticOperation(callNode, resultBounds) {
          int argCount;
          @Override
          void loadStack() {
            loadExpressionAsObject(node.getBase());
            method.dup();
            // NOTE: not using a nested OptimisticOperation on this dynamicGet, as we expect to get back a callable object. Nobody in their right mind would optimistically type this call site.
            assert !node.isOptimistic();
            method.dynamicGet(node.getType(), node.getProperty(), flags, true, node.isIndex());
            method.swap();
            argCount = loadArgs(args);
          }
          @Override
          void consumeStack() {
            dynamicCall(2 + argCount, flags, node.toString(false));
          }
        }.emit();
        return false;
      }

      @Override
      public boolean enterFunctionNode(FunctionNode origCallee) {
        new OptimisticOperation(callNode, resultBounds) {
          FunctionNode callee;
          int argsCount;
          @Override
          void loadStack() {
            callee = (FunctionNode) origCallee.accept(CodeGenerator.this);
            // "this" is undefined
            method.loadUndefined(Type.OBJECT);
            argsCount = loadArgs(args);
          }
          @Override
          void consumeStack() {
            dynamicCall(2 + argsCount, getCallSiteFlags(), null);
          }
        }.emit();
        return false;
      }
      @Override
      public boolean enterIndexNode(IndexNode node) {
        new OptimisticOperation(callNode, resultBounds) {
          int argsCount;
          @Override
          void loadStack() {
            loadExpressionAsObject(node.getBase());
            method.dup();
            var indexType = node.getIndex().getType();
            if (indexType.isObject() || indexType.isBoolean()) {
              loadExpressionAsObject(node.getIndex()); //TODO boolean
            } else {
              loadExpressionUnbounded(node.getIndex());
            }
            // NOTE: not using a nested OptimisticOperation on this dynamicGetIndex, as we expect to get back a callable object.
            // Nobody in their right mind would optimistically type this call site.
            assert !node.isOptimistic();
            method.dynamicGetIndex(node.getType(), getCallSiteFlags(), true);
            method.swap();
            argsCount = loadArgs(args);
          }
          @Override
          void consumeStack() {
            dynamicCall(2 + argsCount, getCallSiteFlags(), node.toString(false));
          }
        }.emit();
        return false;
      }

      @Override
      protected boolean enterDefault(Node node) {
        new OptimisticOperation(callNode, resultBounds) {
          int argsCount;
          @Override
          void loadStack() {
            // Load up function.
            loadExpressionAsObject(function); // TODO, e.g. booleans can be used as functions
            method.loadUndefined(Type.OBJECT); // ScriptFunction will figure out the correct this when it sees CALLSITE_SCOPE
            argsCount = loadArgs(args);
          }
          @Override
          void consumeStack() {
            var flags = getCallSiteFlags() | CALLSITE_SCOPE;
            dynamicCall(2 + argsCount, flags, node.toString(false));
          }
        }.emit();
        return false;
      }
    });
    return false;
  }

  /**
   * Returns the flags with optimistic flag and program point removed.
   * @param flags the flags that need optimism stripped from them.
   * @return flags without optimism
   */
  static int nonOptimisticFlags(int flags) {
    return flags & ~(CALLSITE_OPTIMISTIC | -1 << CALLSITE_PROGRAM_POINT_SHIFT);
  }

  @Override
  public boolean enterContinueNode(ContinueNode continueNode) {
    return enterJumpStatement(continueNode);
  }

  @Override
  public boolean enterEmptyNode(EmptyNode emptyNode) {
    // Don't even record the line number, it's irrelevant as there's no code.
    return false;
  }

  @Override
  public boolean enterExpressionStatement(ExpressionStatement expressionStatement) {
    if (!method.isReachable()) {
      return false;
    }
    enterStatement(expressionStatement);
    loadAndDiscard(expressionStatement.getExpression());
    assert method.getStackSize() == 0 : "stack not empty in " + expressionStatement;
    return false;
  }

  @Override
  public boolean enterBlockStatement(BlockStatement blockStatement) {
    if (!method.isReachable()) {
      return false;
    }
    enterStatement(blockStatement);
    blockStatement.getBlock().accept(this);
    return false;
  }

  @Override
  public boolean enterForNode(ForNode forNode) {
    if (!method.isReachable()) {
      return false;
    }
    enterStatement(forNode);
    if (forNode.isForInOrOf()) {
      enterForIn(forNode);
    } else {
      var init = forNode.getInit();
      if (init != null) {
        loadAndDiscard(init);
      }
      enterForOrWhile(forNode, forNode.getModify());
    }
    return false;
  }

  void enterForIn(ForNode forNode) {
    loadExpression(forNode.getModify(), TypeBounds.OBJECT);
    if (forNode.isForEach()) {
      method.invoke(ScriptRuntime.TO_VALUE_ITERATOR);
    } else if (forNode.isForIn()) {
      method.invoke(ScriptRuntime.TO_PROPERTY_ITERATOR);
    } else if (forNode.isForOf()) {
      method.invoke(ScriptRuntime.TO_ES6_ITERATOR);
    } else {
      throw new IllegalArgumentException("Unexpected for node");
    }
    var iterSymbol = forNode.getIterator();
    var iterSlot = iterSymbol.getSlot(Type.OBJECT);
    method.store(iterSymbol, ITERATOR_TYPE);
    method.beforeJoinPoint(forNode);
    var continueLabel = forNode.getContinueLabel();
    var breakLabel = forNode.getBreakLabel();
    method.label(continueLabel);
    method.load(ITERATOR_TYPE, iterSlot);
    method.invoke(interfaceCallNoLookup(ITERATOR_CLASS, "hasNext", boolean.class));
    var test = forNode.getTest();
    var body = forNode.getBody();
    if (LocalVariableConversion.hasLiveConversion(test)) {
      var afterConversion = new Label("for_in_after_test_conv");
      method.ifne(afterConversion);
      method.beforeJoinPoint(test);
      method.goto_(breakLabel);
      method.label(afterConversion);
    } else {
      method.ifeq(breakLabel);
    }
    new Store<Expression>(forNode.getInit()) {
      @Override
      protected void storeNonDiscard() {
        // This expression is neither part of a discard, nor needs to be left on the stack after it was stored, so we override storeNonDiscard to be a no-op.
      }
      @Override
      protected void evaluate() {
        new OptimisticOperation((Optimistic) forNode.getInit(), TypeBounds.UNBOUNDED) {
          @Override
          void loadStack() {
            method.load(ITERATOR_TYPE, iterSlot);
          }
          @Override
          void consumeStack() {
            method.invoke(interfaceCallNoLookup(ITERATOR_CLASS, "next", Object.class));
            convertOptimisticReturnValue();
          }
        }.emit();
      }
    }.store();
    body.accept(this);
    if (forNode.needsScopeCreator() && lc.getCurrentBlock().providesScopeCreator()) {
      // for-in loops with lexical declaration need a new scope for each iteration.
      var creator = scopeObjectCreators.peek();
      assert creator != null;
      creator.createForInIterationScope(method);
      method.storeCompilerConstant(SCOPE);
    }
    if (method.isReachable()) {
      method.goto_(continueLabel);
    }
    method.label(breakLabel);
  }

  /**
   * Initialize the slots in a frame to undefined.
   * @param block block with local vars.
   */
  void initLocals(Block block) {
    lc.onEnterBlock(block);
    var isFunctionBody = lc.isFunctionBody();
    var function = lc.getCurrentFunction();
    if (isFunctionBody) {
      initializeMethodParameters(function);
      if (!function.isVarArg()) {
        expandParameterSlots(function);
      }
      if (method.hasScope()) {
        if (function.needsParentScope()) {
          method.loadCompilerConstant(CALLEE);
          method.invoke(ScriptFunction.GET_SCOPE);
        } else {
          assert function.hasScopeBlock();
          method.loadNull();
        }
        method.storeCompilerConstant(SCOPE);
      }
      if (function.needsArguments()) {
        initArguments(function);
      }
    }
    // Determine if block needs scope, if not, just do initSymbols for this block.
    if (block.needsScope()) {
      // Determine if function is varargs and consequently variables have to be in the scope.
      var varsInScope = function.allVarsInScope();
      // TODO for LET we can do better: if *block* does not contain any eval/with, we don't need its vars in scope.
      var hasArguments = function.needsArguments();
      var tuples = new ArrayList<MapTuple<Symbol>>();
      var paramIter = function.getParameters().iterator();
      for (var symbol : block.getSymbols()) {
        if (symbol.isInternal() || symbol.isThis()) {
          continue;
        }
        if (symbol.isVar()) {
          assert !varsInScope || symbol.isScope();
          if (varsInScope || symbol.isScope()) {
            assert symbol.isScope() : "scope for " + symbol + " should have been set in Lower already " + function.getName();
            assert !symbol.hasSlot() : "slot for " + symbol + " should have been removed in Lower already" + function.getName();
            // this tuple will not be put fielded, as it has no value, just a symbol
            tuples.add(new MapTuple<Symbol>(symbol.getName(), symbol, null));
          } else {
            assert symbol.hasSlot() || symbol.slotCount() == 0 : symbol + " should have a slot only, no scope";
          }
        } else if (symbol.isParam() && (varsInScope || hasArguments || symbol.isScope())) {
          assert symbol.isScope() : "scope for " + symbol + " should have been set in AssignSymbols already " + function.getName() + " varsInScope=" + varsInScope + " hasArguments=" + hasArguments + " symbol.isScope()=" + symbol.isScope();
          assert !(hasArguments && symbol.hasSlot()) : "slot for " + symbol + " should have been removed in Lower already " + function.getName();
          Type paramType;
          Symbol paramSymbol;
          if (hasArguments) {
            assert !symbol.hasSlot() : "slot for " + symbol + " should have been removed in Lower already ";
            paramSymbol = null;
            paramType = null;
          } else {
            paramSymbol = symbol;
            // NOTE: We're relying on the fact here that Block.symbols is a LinkedHashMap, hence it will return symbols in the order they were defined, and parameters are defined in the same order they appear in the function.
            // That's why we can have a single pass over the parameter list with an iterator, always just scanning forward for the next parameter that matches the symbol name.
            for (;;) {
              var nextParam = paramIter.next();
              if (nextParam.getName().equals(symbol.getName())) {
                paramType = nextParam.getType();
                break;
              }
            }
          }
          tuples.add(new MapTuple<Symbol>(symbol.getName(), symbol, paramType, paramSymbol) {
            // this symbol will be put fielded, we can't initialize it as undefined with a known type
            @Override
            public Class<?> getValueType() {
              return (!useDualFields() || value == null || paramType == null || paramType.isBoolean()) ? Object.class : paramType.getTypeClass();
            }
          });
        }
      }
      // Create a new object based on the symbols and values, generate bootstrap code for object
      var creator = new FieldObjectCreator<Symbol>(this, tuples, true, hasArguments) {
        @Override
        protected void loadValue(Symbol value, Type type) {
          method.load(value, type);
        }
      };
      creator.makeObject(method);
      if (block.providesScopeCreator()) {
        scopeObjectCreators.push(creator);
      }
      // program function: merge scope into global
      if (isFunctionBody && function.isProgram()) {
        method.invoke(ScriptRuntime.MERGE_SCOPE);
      }
      method.storeCompilerConstant(SCOPE);
      if (!isFunctionBody) {
        // Function body doesn't need a try/catch to restore scope, as it'd be a dead store anyway.
        // Allowing it actually causes issues with UnwarrantedOptimismException handlers as ASM will sort this handler to the top of the exception handler table, so it'll be triggered instead of the UOE handlers.
        var scopeEntryLabel = new Label("scope_entry");
        scopeEntryLabels.push(scopeEntryLabel);
        method.label(scopeEntryLabel);
      }
    } else if (isFunctionBody && function.isVarArg()) {
      // Since we don't have a scope, parameters didn't get assigned array indices by the FieldObjectCreator, so we need to assign them separately here.
      var nextParam = 0;
      for (var param : function.getParameters()) {
        param.getSymbol().setFieldIndex(nextParam++);
      }
    }
  }

  /**
   * Incoming method parameters are always declared on method entry; declare them in the local variable table.
   * @param function function for which code is being generated.
   */
  void initializeMethodParameters(FunctionNode function) {
    var functionStart = new Label("fn_start");
    method.label(functionStart);
    var nextSlot = 0;
    if (function.needsCallee()) {
      initializeInternalFunctionParameter(CALLEE, function, functionStart, nextSlot++);
    }
    initializeInternalFunctionParameter(THIS, function, functionStart, nextSlot++);
    if (function.isVarArg()) {
      initializeInternalFunctionParameter(VARARGS, function, functionStart, nextSlot++);
    } else {
      for (var param : function.getParameters()) {
        var symbol = param.getSymbol();
        if (symbol.isBytecodeLocal()) {
          method.initializeMethodParameter(symbol, param.getType(), functionStart);
        }
      }
    }
  }

  void initializeInternalFunctionParameter(CompilerConstants cc, FunctionNode fn, Label functionStart, int slot) {
    var symbol = initializeInternalFunctionOrSplitParameter(cc, fn, functionStart, slot);
    // Internal function params (:callee, this, and :varargs) are never expanded to multiple slots
    assert symbol.getFirstSlot() == slot;
  }

  Symbol initializeInternalFunctionOrSplitParameter(CompilerConstants cc, FunctionNode fn, Label functionStart, int slot) {
    var symbol = fn.getBody().getExistingSymbol(cc.symbolName());
    var type = Type.typeFor(cc.type());
    method.initializeMethodParameter(symbol, type, functionStart);
    method.onLocalStore(type, slot);
    return symbol;
  }

  /**
   * Parameters come into the method packed into local variable slots next to each other.
   * Nashorn on the other hand can use 1-6 slots for a local variable depending on all the types it needs to store.
   * When this method is invoked, the symbols are already allocated such wider slots, but the values are still in tightly packed incoming slots, and we need to spread them into their new locations.
   * @param function the function for which parameter-spreading code needs to be emitted
   */
  void expandParameterSlots(FunctionNode function) {
    var parameters = function.getParameters();
    // Calculate the total number of incoming parameter slots
    var currentIncomingSlot = function.needsCallee() ? 2 : 1;
    for (var parameter : parameters) {
      currentIncomingSlot += parameter.getType().getSlots();
    }
    // Starting from last parameter going backwards, move the parameter values into their new slots.
    for (var i = parameters.size(); i-- > 0;) {
      var parameter = parameters.get(i);
      var parameterType = parameter.getType();
      var typeWidth = parameterType.getSlots();
      currentIncomingSlot -= typeWidth;
      var symbol = parameter.getSymbol();
      var slotCount = symbol.slotCount();
      assert slotCount > 0;
      // Scoped parameters must not hold more than one value
      assert symbol.isBytecodeLocal() || slotCount == typeWidth;
      // Mark it as having its value stored into it by the method invocation.
      method.onLocalStore(parameterType, currentIncomingSlot);
      if (currentIncomingSlot != symbol.getSlot(parameterType)) {
        method.load(parameterType, currentIncomingSlot);
        method.store(symbol, parameterType);
      }
    }
  }

  void initArguments(FunctionNode function) {
    method.loadCompilerConstant(VARARGS);
    if (function.needsCallee()) {
      method.loadCompilerConstant(CALLEE);
    } else {
      // "arguments.callee" is not populated, so we don't necessarily need the caller.
      method.loadNull();
    }
    method.load(function.getParameters().size());
    globalAllocateArguments();
    method.storeCompilerConstant(ARGUMENTS);
  }

  boolean skipFunction(FunctionNode functionNode) {
    var env = compiler.getScriptEnvironment();
    var lazy = env._lazy_compilation;
    var onDemand = compiler.isOnDemandCompilation();
    // If this is on-demand or lazy compilation, don't compile a nested (not topmost) function.
    if ((onDemand || lazy) && lc.getOutermostFunction() != functionNode) {
      return true;
    }
    // If lazy compiling with optimistic types, don't compile the program eagerly either.
    // It will soon be invalidated anyway.
    // In presence of a class cache, this further means that an obsoleted program version lingers around.
    // Also, currently loading previously persisted optimistic types information only works if we're on-demand compiling a function, so with this strategy the :program method can also have the warmup benefit of using previously persisted types.
    // NOTE that this means the first compiled class will effectively just have a :createProgramFunction method, and the RecompilableScriptFunctionData (RSFD) object in its constants array.
    // It won't even have the :program method. This is by design.
    // It does mean that we're wasting one compiler execution (and we could minimize this by just running it up to scope depth calculation, which creates the RSFDs and then this limited codegen).
    // We could emit an initial separate compile unit with the initial version of :program in it to better utilize the compilation pipeline, but that would need more invasive changes, as currently the assumption that :program is emitted into the first compilation unit of the function lives in many places.
    return !onDemand && lazy && env._optimistic_types && functionNode.isProgram();
  }

  @Override
  public boolean enterFunctionNode(FunctionNode functionNode) {
    if (skipFunction(functionNode)) {
      // In case we are not generating code for the function, we must create or retrieve the function object and load it on the stack here.
      newFunctionObject(functionNode, false);
      return false;
    }
    var fnName = functionNode.getName();
    // NOTE: we only emit the method for a function with the given name once.
    // We can have multiple functions with the same name as a result of inlining finally blocks.
    // However, in the future -- with type specialization, notably -- we might need to check for both name *and* signature.
    // Of course, even that might not be sufficient; the function might have a code dependency on the type of the variables in its enclosing scopes, and the type of such a variable can be different in catch and finally blocks.
    // So, in the future we will have to decide to either generate a unique method for each inlined copy of the function, maybe figure out its exact type closure and deduplicate based on that, or just decide that functions in finally blocks aren't worth it, and generate one method with most generic type closure.
    if (!emittedMethods.contains(fnName)) {
      log.info("=== BEGIN ", fnName);
      assert functionNode.getCompileUnit() != null : "no compile unit for " + fnName + " " + Hex.id(functionNode);
      unit = lc.pushCompileUnit(functionNode.getCompileUnit());
      assert lc.hasCompileUnits();
      var classEmitter = unit.getClassEmitter();
      pushMethodEmitter(isRestOf() ? classEmitter.restOfMethod(functionNode) : classEmitter.method(functionNode));
      method.setPreventUndefinedLoad();
      if (useOptimisticTypes()) {
        lc.pushUnwarrantedOptimismHandlers();
      }
      // new method - reset last line number
      lastLineNumber = -1;
      method.begin();
      if (isRestOf()) {
        assert continuationInfo == null;
        continuationInfo = new ContinuationInfo();
        method.gotoLoopStart(continuationInfo.getHandlerLabel());
      }
    }
    return true;
  }

  void pushMethodEmitter(MethodEmitter newMethod) {
    method = lc.pushMethodEmitter(newMethod);
    catchLabels.push(METHOD_BOUNDARY);
  }

  void popMethodEmitter() {
    method = lc.popMethodEmitter(method);
    assert catchLabels.peek() == METHOD_BOUNDARY;
    catchLabels.pop();
  }

  @Override
  public Node leaveFunctionNode(FunctionNode functionNode) {
    try {
      boolean markOptimistic;
      if (emittedMethods.add(functionNode.getName())) {
        markOptimistic = generateUnwarrantedOptimismExceptionHandlers(functionNode);
        generateContinuationHandler();
        method.end(); // wrap up this method
        unit = lc.popCompileUnit(functionNode.getCompileUnit());
        popMethodEmitter();
        log.info("=== END ", functionNode.getName());
      } else {
        markOptimistic = false;
      }
      var newFunctionNode = functionNode;
      if (markOptimistic) {
        newFunctionNode = newFunctionNode.setFlag(lc, FunctionNode.IS_DEOPTIMIZABLE);
      }
      newFunctionObject(newFunctionNode, true);
      return newFunctionNode;
    } catch (Throwable t) {
      Context.printStackTrace(t);
      var e = new VerifyError("Code generation bug in \"" + functionNode.getName() + "\": likely stack misaligned: " + t + " " + functionNode.getSource().getName());
      e.initCause(t);
      throw e;
    }
  }

  @Override
  public boolean enterIfNode(IfNode ifNode) {
    if (!method.isReachable()) {
      return false;
    }
    enterStatement(ifNode);
    var test = ifNode.getTest();
    var pass = ifNode.getPass();
    var fail = ifNode.getFail();
    if (Expression.isAlwaysTrue(test)) {
      loadAndDiscard(test);
      pass.accept(this);
      return false;
    } else if (Expression.isAlwaysFalse(test)) {
      loadAndDiscard(test);
      if (fail != null) {
        fail.accept(this);
      }
      return false;
    }
    var hasFailConversion = LocalVariableConversion.hasLiveConversion(ifNode);
    var failLabel = new Label("if_fail");
    var afterLabel = (fail == null && !hasFailConversion) ? null : new Label("if_done");
    emitBranch(test, failLabel, false);
    pass.accept(this);
    if (method.isReachable() && afterLabel != null) {
      method.goto_(afterLabel); //don't fallthru to fail block
    }
    method.label(failLabel);
    if (fail != null) {
      fail.accept(this);
    } else if (hasFailConversion) {
      method.beforeJoinPoint(ifNode);
    }
    if (afterLabel != null && afterLabel.isReachable()) {
      method.label(afterLabel);
    }
    return false;
  }

  void emitBranch(Expression test, Label label, boolean jumpWhenTrue) {
    new BranchOptimizer(this, method).execute(test, label, jumpWhenTrue);
  }

  void enterStatement(Statement statement) {
    lineNumber(statement);
  }

  void lineNumber(Statement statement) {
    lineNumber(statement.getLineNumber());
  }

  void lineNumber(int lineNumber) {
    if (lineNumber != lastLineNumber && lineNumber != Node.NO_LINE_NUMBER) {
      // method.lineNumber(lineNumber);
      lastLineNumber = lineNumber;
    }
  }

  int getLastLineNumber() {
    return lastLineNumber;
  }

  /**
   * Load a list of nodes as an array of a specific type.
   * The array will contain the visited nodes.
   * @param arrayLiteralNode the array of contents
   * @param arrayType        the type of the array, e.g. ARRAY_NUMBER or ARRAY_OBJECT
   */
  void loadArray(ArrayLiteralNode arrayLiteralNode, ArrayType arrayType) {
    assert arrayType == Type.INT_ARRAY || arrayType == Type.NUMBER_ARRAY || arrayType == Type.OBJECT_ARRAY;
    var nodes = arrayLiteralNode.getValue();
    var presets = arrayLiteralNode.getPresets();
    var postsets = arrayLiteralNode.getPostsets();
    var ranges = arrayLiteralNode.getSplitRanges();
    loadConstant(presets);
    var elementType = arrayType.getElementType();
    if (ranges != null) {
      loadSplitLiteral(ranges, arrayType, (method1, type, slot, start, end) -> {
        for (var i = start; i < end; i++) {
          method1.load(type, slot);
          storeElement(nodes, elementType, postsets[i]);
        }
        method1.load(type, slot);
      });
      return;
    }
    if (postsets.length > 0) {
      var arraySlot = method.getUsedSlotsWithLiveTemporaries();
      method.storeTemp(arrayType, arraySlot);
      for (var postset : postsets) {
        method.load(arrayType, arraySlot);
        storeElement(nodes, elementType, postset);
      }
      method.load(arrayType, arraySlot);
    }
  }

  void storeElement(Expression[] nodes, Type elementType, int index) {
    method.load(index);
    var element = nodes[index];
    if (element == null) {
      method.loadEmpty(elementType);
    } else {
      loadExpressionAsType(element, elementType);
    }
    method.arraystore();
  }

  MethodEmitter loadArgsArray(List<Expression> args) {
    var array = new Object[args.size()];
    loadConstant(array);
    for (var i = 0; i < args.size(); i++) {
      method.dup();
      method.load(i);
      loadExpression(args.get(i), TypeBounds.OBJECT); // variable arity methods always take objects
      method.arraystore();
    }
    return method;
  }

  /**
   * Load a constant from the constant array.
   * This is only public to be callable from the objects subpackage.
   * Do not call directly.
   * @param string string to load
   */
  void loadConstant(String string) {
    var unitClassName = unit.getUnitClassName();
    var classEmitter = unit.getClassEmitter();
    var index = compiler.getConstantData().add(string);
    method.load(index);
    method.invokestatic(unitClassName, GET_STRING.symbolName(), methodDescriptor(String.class, int.class));
    classEmitter.needGetConstantMethod(String.class);
  }

  /**
   * Load a constant from the constant array.
   * This is only public to be callable from the objects subpackage.
   * Do not call directly.
   * @param object object to load
   */
  void loadConstant(Object object) {
    loadConstant(object, unit, method);
  }

  void loadConstant(Object object, CompileUnit compileUnit, MethodEmitter methodEmitter) {
    var unitClassName = compileUnit.getUnitClassName();
    var classEmitter = compileUnit.getClassEmitter();
    var index = compiler.getConstantData().add(object);
    var cls = object.getClass();
    if (cls == PropertyMap.class) {
      methodEmitter.load(index);
      methodEmitter.invokestatic(unitClassName, GET_MAP.symbolName(), methodDescriptor(PropertyMap.class, int.class));
      classEmitter.needGetConstantMethod(PropertyMap.class);
    } else if (cls.isArray()) {
      methodEmitter.load(index);
      var methodName = ClassEmitter.getArrayMethodName(cls);
      methodEmitter.invokestatic(unitClassName, methodName, methodDescriptor(cls, int.class));
      classEmitter.needGetConstantMethod(cls);
    } else {
      methodEmitter.loadConstants().load(index).arrayload();
      if (object instanceof ArrayData) {
        methodEmitter.checkcast(ArrayData.class);
        methodEmitter.invoke(virtualCallNoLookup(ArrayData.class, "copy", ArrayData.class));
      } else if (cls != Object.class) {
        methodEmitter.checkcast(cls);
      }
    }
  }

  void loadConstantsAndIndex(Object object, MethodEmitter methodEmitter) {
    methodEmitter.loadConstants().load(compiler.getConstantData().add(object));
  }

  // literal values
  void loadLiteral(LiteralNode<?> node, TypeBounds resultBounds) {
    var value = node.getValue();
    if (value == null) {
      method.loadNull();
    } else if (value instanceof Undefined) {
      method.loadUndefined(resultBounds.within(Type.OBJECT));
    } else if (value instanceof String string) {
      if (string.length() > MethodEmitter.LARGE_STRING_THRESHOLD / 3) { // 3 == max bytes per encoded char
        loadConstant(string);
      } else {
        method.load(string);
      }
    } else if (value instanceof RegexToken r) {
      loadRegex(r);
    } else if (value instanceof Boolean b) {
      method.load(b);
    } else if (value instanceof Integer i) {
      if (!resultBounds.canBeNarrowerThan(Type.OBJECT)) {
        method.load(i);
        method.convert(Type.OBJECT);
      } else if (!resultBounds.canBeNarrowerThan(Type.NUMBER)) {
        method.load(i.doubleValue());
      } else {
        method.load(i);
      }
    } else if (value instanceof Double d) {
      if (!resultBounds.canBeNarrowerThan(Type.OBJECT)) {
        method.load(d);
        method.convert(Type.OBJECT);
      } else {
        method.load(d);
      }
    } else if (node instanceof ArrayLiteralNode arrayLiteral) {
      var atype = arrayLiteral.getArrayType();
      loadArray(arrayLiteral, atype);
      globalAllocateArray(atype);
    } else {
      throw new UnsupportedOperationException("Unknown literal for " + node.getClass() + " " + value.getClass() + " " + value);
    }
  }

  MethodEmitter loadRegexToken(RegexToken value) {
    method.load(value.getExpression());
    method.load(value.getOptions());
    return globalNewRegExp();
  }

  MethodEmitter loadRegex(RegexToken regexToken) {
    if (regexFieldCount > MAX_REGEX_FIELDS) {
      return loadRegexToken(regexToken);
    }
    // emit field
    var regexName = lc.getCurrentFunction().uniqueName(REGEX_PREFIX.symbolName());
    var classEmitter = unit.getClassEmitter();
    classEmitter.field(EnumSet.of(Flag.PRIVATE, Flag.STATIC), regexName, Object.class);
    regexFieldCount++;
    // get field, if null create new regex, finally clone regex object
    method.getStatic(unit.getUnitClassName(), regexName, typeDescriptor(Object.class));
    method.dup();
    var cachedLabel = new Label("cached");
    method.ifnonnull(cachedLabel);
    method.pop();
    loadRegexToken(regexToken);
    method.dup();
    method.putStatic(unit.getUnitClassName(), regexName, typeDescriptor(Object.class));
    method.label(cachedLabel);
    globalRegExpCopy();
    return method;
  }

  /**
   * Check if a property value contains a particular program point
   * @param value value
   * @param pp    program point
   * @return true if it's there.
   */
  static boolean propertyValueContains(Expression value, int pp) {
    return new Supplier<Boolean>() {
      boolean contains;
      @Override
      public Boolean get() {
        value.accept(new SimpleNodeVisitor() {
          @Override
          public boolean enterFunctionNode(FunctionNode functionNode) {
            return false;
          }
          @Override
          public boolean enterDefault(Node node) {
            if (contains) {
              return false;
            }
            if (node instanceof Optimistic && ((Optimistic) node).getProgramPoint() == pp) {
              contains = true;
              return false;
            }
            return true;
          }
        });
        return contains;
      }
    }.get();
  }

  void loadObjectNode(ObjectNode objectNode) {
    var elements = objectNode.getElements();
    var tuples = new ArrayList<MapTuple<Expression>>();
    // List below will contain getter/setter properties and properties with computed keys (ES6)
    var specialProperties = new ArrayList<PropertyNode>();
    var ccp = getCurrentContinuationEntryPoint();
    var ranges = objectNode.getSplitRanges();
    Expression protoNode = null;
    var restOfProperty = false;
    for (var propertyNode : elements) {
      var value = propertyNode.getValue();
      var key = propertyNode.getKeyName();
      var isComputedOrAccessor = propertyNode.isComputed() || value == null;
      // Just use a pseudo-symbol. We just need something non null; use the name and zero flags.
      var symbol = isComputedOrAccessor ? null : new Symbol(key, 0);
      if (isComputedOrAccessor) {
        // Properties with computed names or getter/setters need special handling.
        specialProperties.add(propertyNode);
      } else if (propertyNode.getKey() instanceof IdentNode && key.equals(ScriptObject.PROTO_PROPERTY_NAME)) {
        // ES6 draft compliant __proto__ inside object literal
        // Identifier key and name is __proto__
        protoNode = value;
        continue;
      }
      restOfProperty |= value != null && isValid(ccp) && propertyValueContains(value, ccp);
      // for literals, a value of null means object type, i.e. the value null or getter setter function (I think)
      var valueType = (!useDualFields() || isComputedOrAccessor || value.getType().isBoolean()) ? Object.class : value.getType().getTypeClass();
      tuples.add(new MapTuple<Expression>(key, symbol, Type.typeFor(valueType), value) {
        @Override
        public Class<?> getValueType() {
          return type.getTypeClass();
        }
      });
    }
    ObjectCreator<?> oc;
    if (elements.size() > OBJECT_SPILL_THRESHOLD) {
      oc = new SpillObjectCreator(this, tuples);
    } else {
      oc = new FieldObjectCreator<Expression>(this, tuples) {
        @Override
        protected void loadValue(Expression node, Type type) {
          // Use generic type in order to avoid conversion between object types
          loadExpressionAsType(node, Type.generic(type));
        }
      };
    }
    if (ranges != null) {
      oc.createObject(method);
      loadSplitLiteral(ranges, Type.typeFor(oc.getAllocatorClass()), oc);
    } else {
      oc.makeObject(method);
    }
    // if this is a rest of method and our continuation point was found as one of the values in the properties above, we need to reset the map to oc.getMap() in the continuation handler
    if (restOfProperty) {
      var ci = getContinuationInfo();
      ci.setObjectLiteralMap(method.getStackSize(), oc.getMap());
    }

    method.dup();
    if (protoNode != null) {
      loadExpressionAsObject(protoNode);
      // take care of { __proto__: 34 } or some such!
      method.convert(Type.OBJECT);
      method.invoke(ScriptObject.SET_PROTO_FROM_LITERAL);
    } else {
      method.invoke(ScriptObject.SET_GLOBAL_OBJECT_PROTO);
    }
    for (var propertyNode : specialProperties) {
      method.dup();
      if (propertyNode.isComputed()) {
        assert propertyNode.getKeyName() == null;
        loadExpressionAsObject(propertyNode.getKey());
      } else {
        method.loadKey(propertyNode.getKey());
      }
      if (propertyNode.getValue() != null) {
        loadExpressionAsObject(propertyNode.getValue());
        method.load(0);
        method.invoke(ScriptObject.GENERIC_SET);
      } else {
        var getter = propertyNode.getGetter();
        var setter = propertyNode.getSetter();
        assert getter != null || setter != null;
        if (getter == null) {
          method.loadNull();
        } else {
          getter.accept(this);
        }
        if (setter == null) {
          method.loadNull();
        } else {
          setter.accept(this);
        }
        method.invoke(ScriptObject.SET_USER_ACCESSORS);
      }
    }
  }

  @Override
  public boolean enterReturnNode(ReturnNode returnNode) {
    if (!method.isReachable()) {
      return false;
    }
    enterStatement(returnNode);
    var returnType = lc.getCurrentFunction().getReturnType();
    var expression = returnNode.getExpression();
    if (expression != null) {
      loadExpressionUnbounded(expression);
    } else {
      method.loadUndefined(returnType);
    }
    method.return_(returnType);
    return false;
  }

  boolean undefinedCheck(RuntimeNode runtimeNode, List<Expression> args) {
    var request = runtimeNode.getRequest();
    if (!Request.isUndefinedCheck(request)) {
      return false;
    }
    var lhs = args.get(0);
    var rhs = args.get(1);
    var lhsSymbol = lhs instanceof IdentNode ? ((IdentNode) lhs).getSymbol() : null;
    var rhsSymbol = rhs instanceof IdentNode ? ((IdentNode) rhs).getSymbol() : null;
    // One must be a "undefined" identifier, otherwise we can't get here
    assert lhsSymbol != null || rhsSymbol != null;
    Symbol undefinedSymbol;
    if (isUndefinedSymbol(lhsSymbol)) {
      undefinedSymbol = lhsSymbol;
    } else {
      assert isUndefinedSymbol(rhsSymbol);
      undefinedSymbol = rhsSymbol;
    }
    assert undefinedSymbol != null; //remove warning
    if (!undefinedSymbol.isScope()) {
      return false; //disallow undefined as local var or parameter
    }
    if (lhsSymbol == undefinedSymbol && lhs.getType().isPrimitive()) {
      // we load the undefined first. never mind, because this will deoptimize anyway
      return false;
    }
    if (containsOptimisticExpression(lhs)) {
      // Any optimistic expression within lhs could be deoptimized and trigger a rest-of compilation.
      // We must not perform undefined check specialization for them, as then we'd violate the basic rule of "Thou shalt not alter the stack shape between a deoptimized method and any of its (transitive) rest-ofs."
      return false;
    }
    // make sure that undefined has not been overridden or scoped as a local var between us and global
    if (!compiler.isGlobalSymbol(lc.getCurrentFunction(), "undefined")) {
      return false;
    }
    var isUndefinedCheck = request == Request.IS_UNDEFINED;
    var expr = undefinedSymbol == lhsSymbol ? rhs : lhs;
    if (expr.getType().isPrimitive()) {
      loadAndDiscard(expr); // throw away lhs, but it still needs to be evaluated for side effects, even if not in scope, as it can be optimistic
      method.load(!isUndefinedCheck);
    } else {
      var checkTrue = new Label("ud_check_true");
      var end = new Label("end");
      loadExpressionAsObject(expr);
      method.loadUndefined(Type.OBJECT);
      method.if_acmpeq(checkTrue);
      method.load(!isUndefinedCheck);
      method.goto_(end);
      method.label(checkTrue);
      method.load(isUndefinedCheck);
      method.label(end);
    }
    return true;
  }

  static boolean isUndefinedSymbol(Symbol symbol) {
    return symbol != null && "undefined".equals(symbol.getName());
  }

  static boolean isNullLiteral(Node node) {
    return node instanceof LiteralNode<?> && ((LiteralNode<?>) node).isNull();
  }

  boolean nullCheck(RuntimeNode runtimeNode, List<Expression> args) {
    var request = runtimeNode.getRequest();
    if (!Request.isEQ(request) && !Request.isNE(request)) {
      return false;
    }
    assert args.size() == 2 : "EQ or NE or TYPEOF need two args";
    var lhs = args.get(0);
    var rhs = args.get(1);
    if (isNullLiteral(lhs)) {
      var tmp = lhs;
      lhs = rhs;
      rhs = tmp;
    }
    if (!isNullLiteral(rhs)) {
      return false;
    }
    if (!lhs.getType().isObject()) {
      return false;
    }
    if (containsOptimisticExpression(lhs)) {
      // Any optimistic expression within lhs could be deoptimized and trigger a rest-of compilation.
      // We must not perform null check specialization for them, as then we'd no longer be loading aconst_null on stack and thus violate the basic rule of "Thou shalt not alter the stack shape between a deoptimized method and any of its (transitive) rest-ofs."
      // NOTE also that if we had a representation for well-known constants (e.g. null, 0, 1, -1, etc.) in Label$Stack.localLoads then this wouldn't be an issue, as we would never (somewhat ridiculously) allocate a temporary local to hold the result of aconst_null before attempting an optimistic operation.
      return false;
    }

    // this is a null literal check, so if there is implicit coercion involved like {D}x=null, we will fail - this is very rare
    var trueLabel = new Label("trueLabel");
    var falseLabel = new Label("falseLabel");
    var endLabel = new Label("end");
    loadExpressionUnbounded(lhs);    //lhs
    Label popLabel;
    if (!Request.isEquiv(request)) {
      method.dup(); // lhs lhs
      popLabel = new Label("pop");
    } else {
      popLabel = null;
    }

    if (Request.isEQ(request)) {
      method.ifnull(!Request.isEquiv(request) ? popLabel : trueLabel);
      if (!Request.isEquiv(request)) {
        method.loadUndefined(Type.OBJECT);
        method.if_acmpeq(trueLabel);
      }
      method.label(falseLabel);
      method.load(false);
      method.goto_(endLabel);
      if (!Request.isEquiv(request)) {
        method.label(popLabel);
        method.pop();
      }
      method.label(trueLabel);
      method.load(true);
      method.label(endLabel);
    } else if (Request.isNE(request)) {
      method.ifnull(!Request.isEquiv(request) ? popLabel : falseLabel);
      if (!Request.isEquiv(request)) {
        method.loadUndefined(Type.OBJECT);
        method.if_acmpeq(falseLabel);
      }
      method.label(trueLabel);
      method.load(true);
      method.goto_(endLabel);
      if (!Request.isEquiv(request)) {
        method.label(popLabel);
        method.pop();
      }
      method.label(falseLabel);
      method.load(false);
      method.label(endLabel);
    }
    assert runtimeNode.getType().isBoolean();
    method.convert(runtimeNode.getType());
    return true;
  }

  /**
   * Is this expression or any of its subexpressions optimistic?
   * This includes formerly optimistic expressions that have been deoptimized in a subsequent compilation.
   * @param rootExpr the expression being tested
   * @return true if the expression or any of its subexpressions is optimistic in the current compilation.
   */
  boolean containsOptimisticExpression(Expression rootExpr) {
    if (!useOptimisticTypes()) {
      return false;
    }
    return new Supplier<Boolean>() {
      boolean contains;
      @Override
      public Boolean get() {
        rootExpr.accept(new SimpleNodeVisitor() {
          @Override
          public boolean enterFunctionNode(FunctionNode functionNode) {
            return false;
          }
          @Override
          public boolean enterDefault(Node node) {
            if (!contains && node instanceof Optimistic) {
              var pp = ((Optimistic) node).getProgramPoint();
              contains = isValid(pp);
            }
            return !contains;
          }
        });
        return contains;
      }
    }.get();
  }

  // TODO: what's the deal with this new Supplier<>().get() idiom?

  void loadRuntimeNode(RuntimeNode runtimeNode) {
    var args = new ArrayList<Expression>(runtimeNode.getArgs());
    if (nullCheck(runtimeNode, args)) {
      return;
    } else if (undefinedCheck(runtimeNode, args)) {
      return;
    }
    // Revert a false undefined check to a proper equality check
    RuntimeNode newRuntimeNode;
    Request request = runtimeNode.getRequest();
    if (Request.isUndefinedCheck(request)) {
      newRuntimeNode = runtimeNode.setRequest(request == Request.IS_UNDEFINED ? Request.EQUIV : Request.NOT_EQUIV);
    } else {
      newRuntimeNode = runtimeNode;
    }
    for (var arg : args) {
      loadExpression(arg, TypeBounds.OBJECT);
    }
    method.invokestatic(CompilerConstants.className(ScriptRuntime.class), newRuntimeNode.getRequest().toString(), new FunctionSignature(false, false, newRuntimeNode.getType(), args.size()).toString());
    method.convert(newRuntimeNode.getType());
  }

  void defineCommonSplitMethodParameters() {
    defineSplitMethodParameter(0, CALLEE);
    defineSplitMethodParameter(1, THIS);
    defineSplitMethodParameter(2, SCOPE);
  }

  void defineSplitMethodParameter(int slot, CompilerConstants cc) {
    defineSplitMethodParameter(slot, Type.typeFor(cc.type()));
  }

  void defineSplitMethodParameter(int slot, Type type) {
    method.defineBlockLocalVariable(slot, slot + type.getSlots());
    method.onLocalStore(type, slot);
  }

  void loadSplitLiteral(List<Splittable.SplitRange> ranges, Type literalType, SplitLiteralCreator creator) {
    assert ranges != null;
    // final Type literalType = Type.typeFor(literalClass);
    var savedMethod = method;
    var currentFunction = lc.getCurrentFunction();
    for (var splitRange : ranges) {
      unit = lc.pushCompileUnit(splitRange.getCompileUnit());
      assert unit != null;
      var className = unit.getUnitClassName();
      var name = currentFunction.uniqueName(SPLIT_PREFIX.symbolName());
      var clazz = literalType.getTypeClass();
      var signature = methodDescriptor(clazz, ScriptFunction.class, Object.class, ScriptObject.class, clazz);
      pushMethodEmitter(unit.getClassEmitter().method(EnumSet.of(Flag.PUBLIC, Flag.STATIC), name, signature));
      method.setFunctionNode(currentFunction);
      method.begin();
      defineCommonSplitMethodParameters();
      defineSplitMethodParameter(CompilerConstants.SPLIT_ARRAY_ARG.slot(), literalType);
      // NOTE: when this is no longer needed, SplitIntoFunctions will no longer have to add IS_SPLIT to synthetic functions, and FunctionNode.needsCallee() will no longer need to test for isSplit().
      var literalSlot = fixScopeSlot(currentFunction, 3);
      lc.enterSplitLiteral();
      creator.populateRange(method, literalType, literalSlot, splitRange.getLow(), splitRange.getHigh());
      method.return_();
      lc.exitSplitLiteral();
      method.end();
      lc.releaseSlots();
      popMethodEmitter();
      assert method == savedMethod;
      method.loadCompilerConstant(CALLEE).swap();
      method.loadCompilerConstant(THIS).swap();
      method.loadCompilerConstant(SCOPE).swap();
      method.invokestatic(className, name, signature);
      unit = lc.popCompileUnit(unit);
    }
  }

  int fixScopeSlot(FunctionNode functionNode, int extraSlot) {
    // TODO hack to move the scope to the expected slot (needed because split methods reuse the same slots as the root method)
    var actualScopeSlot = functionNode.compilerConstant(SCOPE).getSlot(SCOPE_TYPE);
    var defaultScopeSlot = SCOPE.slot();
    var newExtraSlot = extraSlot;
    if (actualScopeSlot != defaultScopeSlot) {
      if (actualScopeSlot == extraSlot) {
        newExtraSlot = extraSlot + 1;
        method.defineBlockLocalVariable(newExtraSlot, newExtraSlot + 1);
        method.load(Type.OBJECT, extraSlot);
        method.storeHidden(Type.OBJECT, newExtraSlot);
      } else {
        method.defineBlockLocalVariable(actualScopeSlot, actualScopeSlot + 1);
      }
      method.load(SCOPE_TYPE, defaultScopeSlot);
      method.storeCompilerConstant(SCOPE);
    }
    return newExtraSlot;
  }

  @Override
  public boolean enterSplitReturn(SplitReturn splitReturn) {
    if (method.isReachable()) {
      method.loadUndefined(lc.getCurrentFunction().getReturnType()).return_();
    }
    return false;
  }

  @Override
  public boolean enterSetSplitState(SetSplitState setSplitState) {
    if (method.isReachable()) {
      method.setSplitState(setSplitState.getState());
    }
    return false;
  }

  @Override
  public boolean enterSwitchNode(SwitchNode switchNode) {
    if (!method.isReachable()) {
      return false;
    }
    enterStatement(switchNode);
    var expression = switchNode.getExpression();
    var cases = switchNode.getCases();
    if (cases.isEmpty()) {
      // still evaluate expression for side-effects.
      loadAndDiscard(expression);
      return false;
    }
    var defaultCase = switchNode.getDefaultCase();
    var breakLabel = switchNode.getBreakLabel();
    var liveLocalsOnBreak = method.getUsedSlotsWithLiveTemporaries();
    if (defaultCase != null && cases.size() == 1) {
      // default case only
      assert cases.get(0) == defaultCase;
      loadAndDiscard(expression);
      defaultCase.getBody().accept(this);
      method.breakLabel(breakLabel, liveLocalsOnBreak);
      return false;
    }
    // NOTE: it can still change in the tableswitch/lookupswitch case if there's no default case but we need to add a synthetic default case for local variable conversions
    var defaultLabel = defaultCase != null ? defaultCase.getEntry() : breakLabel;
    var hasSkipConversion = LocalVariableConversion.hasLiveConversion(switchNode);
    if (switchNode.isUniqueInteger()) {
      // Tree for sorting values.
      var tree = new TreeMap<Integer, Label>();
      // Build up sorted tree.
      for (var caseNode : cases) {
        var test = caseNode.getTest();
        if (test != null) {
          var value = (Integer) ((LiteralNode<?>) test).getValue();
          var entry = caseNode.getEntry();
          // Take first duplicate.
          if (!tree.containsKey(value)) {
            tree.put(value, entry);
          }
        }
      }
      // Copy values and labels to arrays.
      var size = tree.size();
      var values = tree.keySet().toArray(new Integer[0]);
      var labels = tree.values().toArray(new Label[0]);
      // Discern low, high and range.
      var lo = values[0];
      var hi = values[size - 1];
      var range = (long) hi - (long) lo + 1;
      // Find an unused value for default.
      var deflt = Integer.MIN_VALUE;
      for (var value : values) {
        if (deflt == value) {
          deflt++;
        } else if (deflt < value) {
          break;
        }
      }
      // Load switch expression.
      loadExpressionUnbounded(expression);
      var type = expression.getType();
      // If expression not int see if we can convert, if not use deflt to trigger default.
      if (!type.isInteger()) {
        method.load(deflt);
        var exprClass = type.getTypeClass();
        method.invoke(staticCallNoLookup(ScriptRuntime.class, "switchTagAsInt", int.class, exprClass.isPrimitive() ? exprClass : Object.class, int.class));
      }
      if (hasSkipConversion) {
        assert defaultLabel == breakLabel;
        defaultLabel = new Label("switch_skip");
      }
      // TABLESWITCH needs (range + 3) 32-bit values; LOOKUPSWITCH needs ((size * 2) + 2).
      // Choose the one with smaller representation, favor TABLESWITCH when they're equal size.
      if (range + 1 <= (size * 2) && range <= Integer.MAX_VALUE) {
        var table = new Label[(int) range];
        Arrays.fill(table, defaultLabel);
        for (var i = 0; i < size; i++) {
          var value = values[i];
          table[value - lo] = labels[i];
        }
        method.tableswitch(lo, hi, defaultLabel, table);
      } else {
        var ints = new int[size];
        for (var i = 0; i < size; i++) {
          ints[i] = values[i];
        }
        method.lookupswitch(defaultLabel, ints, labels);
      }
      // This is a synthetic "default case" used in absence of actual default case, created if we need to apply local variable conversions if neither case is taken.
      if (hasSkipConversion) {
        method.label(defaultLabel);
        method.beforeJoinPoint(switchNode);
        method.goto_(breakLabel);
      }
    } else {
      var tagSymbol = switchNode.getTag();
      // TODO: we could have non-object tag
      var tagSlot = tagSymbol.getSlot(Type.OBJECT);
      loadExpressionAsObject(expression);
      method.store(tagSymbol, Type.OBJECT);
      for (var caseNode : cases) {
        var test = caseNode.getTest();
        if (test != null) {
          method.load(Type.OBJECT, tagSlot);
          loadExpressionAsObject(test);
          method.invoke(ScriptRuntime.EQUIV);
          method.ifne(caseNode.getEntry());
        }
      }
      if (defaultCase != null) {
        method.goto_(defaultLabel);
      } else {
        method.beforeJoinPoint(switchNode);
        method.goto_(breakLabel);
      }
    }
    // First case is only reachable through jump
    assert !method.isReachable();
    for (var caseNode : cases) {
      Label fallThroughLabel;
      if (caseNode.getLocalVariableConversion() != null && method.isReachable()) {
        fallThroughLabel = new Label("fallthrough");
        method.goto_(fallThroughLabel);
      } else {
        fallThroughLabel = null;
      }
      method.label(caseNode.getEntry());
      method.beforeJoinPoint(caseNode);
      if (fallThroughLabel != null) {
        method.label(fallThroughLabel);
      }
      caseNode.getBody().accept(this);
    }
    method.breakLabel(breakLabel, liveLocalsOnBreak);
    return false;
  }

  @Override
  public boolean enterThrowNode(ThrowNode throwNode) {
    if (!method.isReachable()) {
      return false;
    }
    enterStatement(throwNode);
    if (throwNode.isSyntheticRethrow()) {
      method.beforeJoinPoint(throwNode);
      // do not wrap whatever this is in an ecma exception, just rethrow it
      var exceptionExpr = (IdentNode) throwNode.getExpression();
      var exceptionSymbol = exceptionExpr.getSymbol();
      method.load(exceptionSymbol, EXCEPTION_TYPE);
      method.checkcast(EXCEPTION_TYPE.getTypeClass());
      method.athrow();
      return false;
    }
    var source = getCurrentSource();
    var expression = throwNode.getExpression();
    var position = throwNode.position();
    var line = throwNode.getLineNumber();
    var column = source.getColumn(position);
    // NOTE: we first evaluate the expression, and only after it was evaluated do we create the new ECMAException object and then somewhat cumbersomely move it beneath the evaluated expression on the stack.
    // The reason for this is that if expression is optimistic (or contains an optimistic subexpression), we'd potentially access the not-yet-<init>ialized object on the stack from the UnwarrantedOptimismException handler, and bytecode verifier forbids that.
    loadExpressionAsObject(expression);
    method.load(source.getName());
    method.load(line);
    method.load(column);
    method.invoke(ECMAException.CREATE);
    method.beforeJoinPoint(throwNode);
    method.athrow();
    return false;
  }

  Source getCurrentSource() {
    return lc.getCurrentFunction().getSource();
  }

  @Override
  public boolean enterTryNode(TryNode tryNode) {
    if (!method.isReachable()) {
      return false;
    }
    enterStatement(tryNode);
    var body = tryNode.getBody();
    var catchBlocks = tryNode.getCatchBlocks();
    var vmException = tryNode.getException();
    var entry = new Label("try");
    var recovery = new Label("catch");
    var exit = new Label("end_try");
    var skip = new Label("skip");
    method.canThrow(recovery);
    // Effect any conversions that might be observed at the entry of the catch node before entering the try node.
    // This is because even the first instruction in the try block must be presumed to be able to transfer control to the catch block.
    // Note that this doesn't kill the original values; in this regard it works a lot like conversions of assignments within the try block.
    method.beforeTry(tryNode, recovery);
    method.label(entry);
    catchLabels.push(recovery);
    try {
      body.accept(this);
    } finally {
      assert catchLabels.peek() == recovery;
      catchLabels.pop();
    }
    method.label(exit);
    var bodyCanThrow = exit.isAfter(entry);
    if (!bodyCanThrow) {
      // The body can't throw an exception; don't even bother emitting the catch handlers, they're all dead code.
      return false;
    }
    method.try_(entry, exit, recovery, Throwable.class);
    if (method.isReachable()) {
      method.goto_(skip);
    }
    for (var inlinedFinally : tryNode.getInlinedFinallies()) {
      TryNode.getLabelledInlinedFinallyBlock(inlinedFinally).accept(this);
      // All inlined finallies end with a jump or a return
      assert !method.isReachable();
    }
    method.catch_(recovery);
    method.store(vmException, EXCEPTION_TYPE);
    var catchBlockCount = catchBlocks.size();
    var afterCatch = new Label("after_catch");
    for (var i = 0; i < catchBlockCount; i++) {
      assert method.isReachable();
      var catchBlock = catchBlocks.get(i);
      // Because of the peculiarities of the flow control, we need to use an explicit push/enterBlock/leaveBlock here.
      lc.push(catchBlock);
      enterBlock(catchBlock);
      var catchNode = (CatchNode) catchBlocks.get(i).getStatements().get(0);
      var exception = catchNode.getExceptionIdentifier();
      var exceptionCondition = catchNode.getExceptionCondition();
      var catchBody = catchNode.getBody();
      new Store<IdentNode>(exception) {
        @Override
        protected void storeNonDiscard() {
          // This expression is neither part of a discard, nor needs to be left on the stack after it was stored, so we override storeNonDiscard to be a no-op.
        }
        @Override
        protected void evaluate() {
          if (catchNode.isSyntheticRethrow()) {
            method.load(vmException, EXCEPTION_TYPE);
            return;
          }
          // If caught object is an instance of ECMAException, then bind obj.thrown to the script catch var.
          // Or else bind the caught object itself to the script catch var.
          var notEcmaException = new Label("no_ecma_exception");
          method.load(vmException, EXCEPTION_TYPE).dup().instanceOf(ECMAException.class).ifeq(notEcmaException);
          method.checkcast(ECMAException.class); //TODO is this necessary?
          method.getField(ECMAException.THROWN);
          method.label(notEcmaException);
        }
      }.store();
      var isConditionalCatch = exceptionCondition != null;
      Label nextCatch;
      if (isConditionalCatch) {
        loadExpressionAsBoolean(exceptionCondition);
        nextCatch = new Label("next_catch");
        nextCatch.markAsBreakTarget();
        method.ifeq(nextCatch);
      } else {
        nextCatch = null;
      }
      catchBody.accept(this);
      leaveBlock(catchBlock);
      lc.pop(catchBlock);
      if (nextCatch != null) {
        if (method.isReachable()) {
          method.goto_(afterCatch);
        }
        method.breakLabel(nextCatch, lc.getUsedSlotCount());
      }
    }
    // afterCatch could be the same as skip, except that we need to establish that the vmException is dead.
    method.label(afterCatch);
    if (method.isReachable()) {
      method.markDeadLocalVariable(vmException);
    }
    method.label(skip);
    // Finally body is always inlined elsewhere so it doesn't need to be emitted
    assert tryNode.getFinallyBody() == null;
    return false;
  }

  @Override
  public boolean enterVarNode(VarNode varNode) {
    if (!method.isReachable()) {
      return false;
    }
    var init = varNode.getInit();
    var identNode = varNode.getName();
    var identSymbol = identNode.getSymbol();
    assert identSymbol != null : "variable node " + varNode + " requires a name with a symbol";
    var needsScope = identSymbol.isScope();
    if (init == null) {
      // Block-scoped variables need a DECLARE flag to signal end of temporal dead zone (TDZ).
      // However, don't do this for CONST which always has an initializer except in the special case of for-in/of loops, in which it is initialized in the loop header and should be left untouched here.
      if (needsScope && varNode.isLet()) {
        method.loadCompilerConstant(SCOPE);
        method.loadUndefined(Type.OBJECT);
        var flags = getScopeCallSiteFlags(identSymbol) | CALLSITE_DECLARE;
        assert isFastScope(identSymbol);
        storeFastScopeVar(identSymbol, flags);
      }
      return false;
    }
    enterStatement(varNode);
    assert method != null;
    if (needsScope) {
      method.loadCompilerConstant(SCOPE);
      loadExpressionUnbounded(init);
      // block scoped variables need a DECLARE flag to signal end of temporal dead zone (TDZ)
      var flags = getScopeCallSiteFlags(identSymbol) | (varNode.isBlockScoped() ? CALLSITE_DECLARE : 0);
      if (isFastScope(identSymbol)) {
        storeFastScopeVar(identSymbol, flags);
      } else {
        method.dynamicSet(identNode.getName(), flags, false);
      }
    } else {
      var identType = identNode.getType();
      if (identType == Type.UNDEFINED) {
        // The initializer is either itself undefined (explicit assignment of undefined to undefined), or the left hand side is a dead variable.
        assert init.getType() == Type.UNDEFINED || identNode.getSymbol().slotCount() == 0;
        loadAndDiscard(init);
        return false;
      }
      loadExpressionAsType(init, identType);
      storeIdentWithCatchConversion(identNode, identType);
    }
    return false;
  }

  void storeIdentWithCatchConversion(IdentNode identNode, Type type) {
    // Assignments happening in try/catch blocks need to ensure that they also store a possibly wider typed value that will be live at the exit from the try block
    var conversion = identNode.getLocalVariableConversion();
    var symbol = identNode.getSymbol();
    if (conversion != null && conversion.isLive()) {
      assert symbol == conversion.getSymbol();
      assert symbol.isBytecodeLocal();
      // Only a single conversion from the target type to the join type is expected.
      assert conversion.getNext() == null;
      assert conversion.getFrom() == type;
      // We must propagate potential type change to the catch block
      var catchLabel = catchLabels.peek();
      assert catchLabel != METHOD_BOUNDARY; // ident conversion only exists in try blocks
      assert catchLabel.isReachable();
      var joinType = conversion.getTo();
      var catchStack = catchLabel.getStack();
      var joinSlot = symbol.getSlot(joinType);
      // With nested try/catch blocks (incl. synthetic ones for finally), we can have a supposed conversion for the exception symbol in the nested catch, but it isn't live in the outer catch block, so prevent doing conversions for it.
      // E.g. in "try { try { ... } catch(e) { e = 1; } } catch(e2) { ... }", we must not introduce an I->O conversion on "e = 1" assignment as "e" is not live in "catch(e2)".
      if (catchStack.getUsedSlotsWithLiveTemporaries() > joinSlot) {
        method.dup();
        method.convert(joinType);
        method.store(symbol, joinType);
        catchLabel.getStack().onLocalStore(joinType, joinSlot, true);
        method.canThrow(catchLabel);
        // Store but keep the previous store live too.
        method.store(symbol, type, false);
        return;
      }
    }
    method.store(symbol, type, true);
  }

  @Override
  public boolean enterWhileNode(WhileNode whileNode) {
    if (!method.isReachable()) {
      return false;
    }
    if (whileNode.isDoWhile()) {
      enterDoWhile(whileNode);
    } else {
      enterStatement(whileNode);
      enterForOrWhile(whileNode, null);
    }
    return false;
  }

  void enterForOrWhile(LoopNode loopNode, JoinPredecessorExpression modify) {
    // NOTE: the usual pattern for compiling test-first loops is "GOTO test; body; test; IFNE body".
    // We use the less conventional "test; IFEQ break; body; GOTO test; break;".
    // It has one extra unconditional GOTO in each repeat of the loop, but it's not a problem for modern JIT compilers.
    // We do this because our local variable type tracking is unfortunately not really prepared for out-of-order execution, e.g. compiling the following contrived but legal JavaScript code snippet would fail because the test changes the type of "i" from object to double:
    //   var i = {valueOf: function() { return 1} }; while(--i >= 0) { ... }
    // Instead of adding more complexity to the local variable type tracking, we instead choose to emit this different code shape.
    var liveLocalsOnBreak = method.getUsedSlotsWithLiveTemporaries();
    var test = loopNode.getTest();
    if (Expression.isAlwaysFalse(test)) {
      loadAndDiscard(test);
      return;
    }
    method.beforeJoinPoint(loopNode);
    var continueLabel = loopNode.getContinueLabel();
    var repeatLabel = modify != null ? new Label("for_repeat") : continueLabel;
    method.label(repeatLabel);
    var liveLocalsOnContinue = method.getUsedSlotsWithLiveTemporaries();
    var body = loopNode.getBody();
    var breakLabel = loopNode.getBreakLabel();
    var testHasLiveConversion = test != null && LocalVariableConversion.hasLiveConversion(test);
    if (Expression.isAlwaysTrue(test)) {
      if (test != null) {
        loadAndDiscard(test);
        if (testHasLiveConversion) {
          method.beforeJoinPoint(test);
        }
      }
    } else if (test != null) {
      if (testHasLiveConversion) {
        emitBranch(test.getExpression(), body.getEntryLabel(), true);
        method.beforeJoinPoint(test);
        method.goto_(breakLabel);
      } else {
        emitBranch(test.getExpression(), breakLabel, false);
      }
    }
    body.accept(this);
    if (repeatLabel != continueLabel) {
      emitContinueLabel(continueLabel, liveLocalsOnContinue);
    }
    if (loopNode.hasPerIterationScope() && lc.getCurrentBlock().needsScope()) {
      // ES6 for loops with LET init need a new scope for each iteration. We just create a shallow copy here.
      method.loadCompilerConstant(SCOPE);
      method.invoke(virtualCallNoLookup(ScriptObject.class, "copy", ScriptObject.class));
      method.storeCompilerConstant(SCOPE);
    }
    if (method.isReachable()) {
      if (modify != null) {
        lineNumber(loopNode);
        loadAndDiscard(modify);
        method.beforeJoinPoint(modify);
      }
      method.goto_(repeatLabel);
    }
    method.breakLabel(breakLabel, liveLocalsOnBreak);
  }

  void emitContinueLabel(Label continueLabel, int liveLocals) {
    var reachable = method.isReachable();
    method.breakLabel(continueLabel, liveLocals);
    // If we reach here only through a continue statement (e.g. body does not exit normally) then the continueLabel can have extra non-temp symbols (e.g. exception from a try/catch contained in the body).
    // We must make sure those are thrown away.
    if (!reachable) {
      method.undefineLocalVariables(lc.getUsedSlotCount(), false);
    }
  }

  void enterDoWhile(WhileNode whileNode) {
    var liveLocalsOnContinueOrBreak = method.getUsedSlotsWithLiveTemporaries();
    method.beforeJoinPoint(whileNode);
    var body = whileNode.getBody();
    body.accept(this);
    emitContinueLabel(whileNode.getContinueLabel(), liveLocalsOnContinueOrBreak);
    if (method.isReachable()) {
      lineNumber(whileNode);
      var test = whileNode.getTest();
      var bodyEntryLabel = body.getEntryLabel();
      var testHasLiveConversion = LocalVariableConversion.hasLiveConversion(test);
      if (Expression.isAlwaysFalse(test)) {
        loadAndDiscard(test);
        if (testHasLiveConversion) {
          method.beforeJoinPoint(test);
        }
      } else if (testHasLiveConversion) {
        // If we have conversions after the test in do-while, they need to be effected on both branches.
        var beforeExit = new Label("do_while_preexit");
        emitBranch(test.getExpression(), beforeExit, false);
        method.beforeJoinPoint(test);
        method.goto_(bodyEntryLabel);
        method.label(beforeExit);
        method.beforeJoinPoint(test);
      } else {
        emitBranch(test.getExpression(), bodyEntryLabel, true);
      }
    }
    method.breakLabel(whileNode.getBreakLabel(), liveLocalsOnContinueOrBreak);
  }

  @Override
  public boolean enterWithNode(WithNode withNode) {
    if (!method.isReachable()) {
      return false;
    }
    enterStatement(withNode);
    var expression = withNode.getExpression();
    var body = withNode.getBody();
    // It is possible to have a "pathological" case where the with block does not reference *any* identifiers. It's pointless, but legal.
    // In that case, if nothing else in the method forced the assignment of a slot to the scope object, its' possible that it won't have a slot assigned.
    // In this case we'll only evaluate expression for its side effect and visit the body, and not bother opening and closing a WithObject.
    var hasScope = method.hasScope();
    if (hasScope) {
      method.loadCompilerConstant(SCOPE);
    }
    loadExpressionAsObject(expression);
    Label tryLabel;
    if (hasScope) {
      // Construct a WithObject if we have a scope
      method.invoke(ScriptRuntime.OPEN_WITH);
      method.storeCompilerConstant(SCOPE);
      tryLabel = new Label("with_try");
      method.label(tryLabel);
    } else {
      // We just loaded the expression for its side effect and to check for null or undefined value.
      globalCheckObjectCoercible();
      tryLabel = null;
    }
    // Always process body
    body.accept(this);
    if (hasScope) {
      // Ensure we always close the WithObject
      var endLabel = new Label("with_end");
      var catchLabel = new Label("with_catch");
      var exitLabel = new Label("with_exit");
      method.label(endLabel);
      // Somewhat conservatively presume that if the body is not empty, it can throw an exception.
      // In any case, we must prevent trying to emit a try-catch for empty range, as it causes a verification error.
      var bodyCanThrow = endLabel.isAfter(tryLabel);
      if (bodyCanThrow) {
        method.try_(tryLabel, endLabel, catchLabel);
      }
      var reachable = method.isReachable();
      if (reachable) {
        popScope();
        if (bodyCanThrow) {
          method.goto_(exitLabel);
        }
      }
      if (bodyCanThrow) {
        method.catch_(catchLabel);
        popScopeException();
        method.athrow();
        if (reachable) {
          method.label(exitLabel);
        }
      }
    }
    return false;
  }

  void loadADD(UnaryNode unaryNode, TypeBounds resultBounds) {
    loadExpression(unaryNode.getExpression(), resultBounds.booleanToInt().notWiderThan(Type.NUMBER));
    if (method.peekType() == Type.BOOLEAN) {
      // It's a no-op in bytecode, but we must make sure it is treated as an int for purposes of type signatures
      method.convert(Type.INT);
    }
  }

  void loadBIT_NOT(UnaryNode unaryNode) {
    loadExpression(unaryNode.getExpression(), TypeBounds.INT).load(-1).xor();
  }

  void loadDECINC(UnaryNode unaryNode) {
    var operand = unaryNode.getExpression();
    var type = unaryNode.getType();
    var typeBounds = new TypeBounds(type, Type.NUMBER);
    var tokenType = unaryNode.tokenType();
    var isPostfix = tokenType == TokenType.DECPOSTFIX || tokenType == TokenType.INCPOSTFIX;
    var isIncrement = tokenType == TokenType.INCPREFIX || tokenType == TokenType.INCPOSTFIX;
    assert !type.isObject();
    new SelfModifyingStore<UnaryNode>(unaryNode, operand) {
      void loadRhs() {
        loadExpression(operand, typeBounds, true);
      }

      @Override
      protected void evaluate() {
        if (isPostfix) {
          loadRhs();
        } else {
          new OptimisticOperation(unaryNode, typeBounds) {
            @Override
            void loadStack() {
              loadRhs();
              loadMinusOne();
            }
            @Override
            void consumeStack() {
              doDecInc(getProgramPoint());
            }
          }.emit(getOptimisticIgnoreCountForSelfModifyingExpression(operand));
        }
      }

      @Override
      protected void storeNonDiscard() {
        super.storeNonDiscard();
        if (isPostfix) {
          new OptimisticOperation(unaryNode, typeBounds) {
            @Override
            void loadStack() {
              loadMinusOne();
            }
            @Override
            void consumeStack() {
              doDecInc(getProgramPoint());
            }
          }.emit(1); // 1 for non-incremented result on the top of the stack pushed in evaluate()
        }
      }

      void loadMinusOne() {
        if (type.isInteger()) {
          method.load(isIncrement ? 1 : -1);
        } else {
          method.load(isIncrement ? 1.0 : -1.0);
        }
      }

      void doDecInc(int programPoint) {
        method.add(programPoint);
      }
    }.store();
  }

  static int getOptimisticIgnoreCountForSelfModifyingExpression(Expression target) {
    return target instanceof AccessNode ? 1 : target instanceof IndexNode ? 2 : 0;
  }

  void loadAndDiscard(Expression expr) {
    // TODO: move checks for discarding to actual expression load code (e.g. as we do with void).
    // That way we might be able to eliminate even more checks.
    if (expr instanceof PrimitiveLiteralNode | isLocalVariable(expr)) {
      assert !lc.isCurrentDiscard(expr);
      // Don't bother evaluating expressions without side effects.
      // Typical usage is "void 0" for reliably generating undefined.
      return;
    }
    lc.pushDiscard(expr);
    loadExpression(expr, TypeBounds.UNBOUNDED);
    if (lc.popDiscardIfCurrent(expr)) {
      assert !expr.isAssignment();
      // NOTE: if we had a way to load with type void, we could avoid popping
      method.pop();
    }
  }

  /**
   * Loads the expression with the specified type bounds, but if the parent expression is the current discard, then instead loads and discards the expression.
   * @param parent the parent expression that's tested for being the current discard
   * @param expr the expression that's either normally loaded or discard-loaded
   * @param resultBounds result bounds for when loading the expression normally
   */
  void loadMaybeDiscard(Expression parent, Expression expr, TypeBounds resultBounds) {
    loadMaybeDiscard(lc.popDiscardIfCurrent(parent), expr, resultBounds);
  }

  /**
   * Loads the expression with the specified type bounds, or loads and discards the expression, depending on the value of the discard flag.
   * Useful as a helper for expressions with control flow where you often can't combine testing for being the current discard and loading the subexpressions.
   * @param discard if true, the expression is loaded and discarded
   * @param expr the expression that's either normally loaded or discard-loaded
   * @param resultBounds result bounds for when loading the expression normally
   */
  void loadMaybeDiscard(boolean discard, Expression expr, TypeBounds resultBounds) {
    if (discard) {
      loadAndDiscard(expr);
    } else {
      loadExpression(expr, resultBounds);
    }
  }

  void loadNEW(UnaryNode unaryNode) {
    var callNode = (CallNode) unaryNode.getExpression();
    var args = callNode.getArgs();
    var func = callNode.getFunction();
    // Load function reference.
    loadExpressionAsObject(func); // must detect type error
    method.dynamicNew(1 + loadArgs(args), getCallSiteFlags(), func.toString(false));
  }

  void loadNOT(UnaryNode unaryNode) {
    var expr = unaryNode.getExpression();
    if (expr instanceof UnaryNode && expr.isTokenType(TokenType.NOT)) {
      // !!x is idiomatic boolean cast in JavaScript
      loadExpressionAsBoolean(((UnaryNode) expr).getExpression());
    } else {
      var trueLabel = new Label("true");
      var afterLabel = new Label("after");
      emitBranch(expr, trueLabel, true);
      method.load(true);
      method.goto_(afterLabel);
      method.label(trueLabel);
      method.load(false);
      method.label(afterLabel);
    }
  }

  void loadSUB(UnaryNode unaryNode, TypeBounds resultBounds) {
    var type = unaryNode.getType();
    assert type.isNumeric();
    var numericBounds = resultBounds.booleanToInt();
    new OptimisticOperation(unaryNode, numericBounds) {
      @Override
      void loadStack() {
        var expr = unaryNode.getExpression();
        loadExpression(expr, numericBounds.notWiderThan(Type.NUMBER));
      }
      @Override
      void consumeStack() {
        // Must do an explicit conversion to the operation's type when it's double so that we correctly handle negation of an int 0 to a double -0.
        // With this, we get the correct negation of a local variable after it deoptimized, e.g. "iload_2; i2d; dneg". Without this, we get "iload_2; ineg; i2d".
        if (type.isNumber()) {
          method.convert(type);
        }
        method.neg(getProgramPoint());
      }
    }.emit();
  }

  public void loadVOID(UnaryNode unaryNode, TypeBounds resultBounds) {
    loadAndDiscard(unaryNode.getExpression());
    if (!lc.popDiscardIfCurrent(unaryNode)) {
      method.loadUndefined(resultBounds.widest);
    }
  }

  public void loadDELETE(UnaryNode unaryNode) {
    var expression = unaryNode.getExpression();
    if (expression instanceof IdentNode ident) {
      var symbol = ident.getSymbol();
      var name = ident.getName();
      if (symbol.isThis()) {
        // Can't delete "this", ignore and return true
        if (!lc.popDiscardIfCurrent(unaryNode)) {
          method.load(true);
        }
      } else {
        // All other scope identifier delete attempts fail
        method.load(name);
        method.invoke(ScriptRuntime.FAIL_DELETE);
      }
    } else if (expression instanceof BaseNode b) {
      loadExpressionAsObject(b.getBase());
      if (expression instanceof AccessNode accessNode) {
        method.dynamicRemove(accessNode.getProperty(), getCallSiteFlags(), accessNode.isIndex());
      } else if (expression instanceof IndexNode i) {
        loadExpressionAsObject(i.getIndex());
        method.dynamicRemoveIndex(getCallSiteFlags());
      } else {
        throw new AssertionError(expression.getClass().getName());
      }
    } else {
      throw new AssertionError(expression.getClass().getName());
    }
  }

  public void loadADD(BinaryNode binaryNode, TypeBounds resultBounds) {
    new OptimisticOperation(binaryNode, resultBounds) {
      @Override
      void loadStack() {
        TypeBounds operandBounds;
        var isOptimistic = isValid(getProgramPoint());
        var forceConversionSeparation = false;
        if (isOptimistic) {
          operandBounds = new TypeBounds(binaryNode.getType(), Type.OBJECT);
        } else {
          // Non-optimistic, non-FP +. Allow it to overflow.
          var widestOperationType = binaryNode.getWidestOperationType();
          operandBounds = new TypeBounds(Type.narrowest(binaryNode.getWidestOperandType(), resultBounds.widest), widestOperationType);
          forceConversionSeparation = widestOperationType.narrowerThan(resultBounds.widest);
        }
        loadBinaryOperands(binaryNode.lhs(), binaryNode.rhs(), operandBounds, false, forceConversionSeparation);
      }
      @Override
      void consumeStack() {
        method.add(getProgramPoint());
      }
    }.emit();
  }

  void loadAND_OR(BinaryNode binaryNode, TypeBounds resultBounds, boolean isAnd) {
    var narrowestOperandType = Type.widestReturnType(binaryNode.lhs().getType(), binaryNode.rhs().getType());
    var isCurrentDiscard = lc.popDiscardIfCurrent(binaryNode);
    var skip = new Label("skip");
    if (narrowestOperandType == Type.BOOLEAN) {
      // optimize all-boolean logical expressions
      var onTrue = new Label("andor_true");
      emitBranch(binaryNode, onTrue, true);
      if (isCurrentDiscard) {
        method.label(onTrue);
      } else {
        method.load(false);
        method.goto_(skip);
        method.label(onTrue);
        method.load(true);
        method.label(skip);
      }
      return;
    }
    var outBounds = resultBounds.notNarrowerThan(narrowestOperandType);
    var lhs = (JoinPredecessorExpression) binaryNode.lhs();
    var lhsConvert = LocalVariableConversion.hasLiveConversion(lhs);
    var evalRhs = lhsConvert ? new Label("eval_rhs") : null;
    loadExpression(lhs, outBounds);
    if (!isCurrentDiscard) {
      method.dup();
    }
    method.convert(Type.BOOLEAN);
    if (isAnd) {
      if (lhsConvert) {
        method.ifne(evalRhs);
      } else {
        method.ifeq(skip);
      }
    } else if (lhsConvert) {
      method.ifeq(evalRhs);
    } else {
      method.ifne(skip);
    }
    if (lhsConvert) {
      method.beforeJoinPoint(lhs);
      method.goto_(skip);
      method.label(evalRhs);
    }
    if (!isCurrentDiscard) {
      method.pop();
    }
    var rhs = (JoinPredecessorExpression) binaryNode.rhs();
    loadMaybeDiscard(isCurrentDiscard, rhs, outBounds);
    method.beforeJoinPoint(rhs);
    method.label(skip);
  }

  static boolean isLocalVariable(Expression lhs) {
    return lhs instanceof IdentNode && isLocalVariable((IdentNode) lhs);
  }

  static boolean isLocalVariable(IdentNode lhs) {
    return lhs.getSymbol().isBytecodeLocal();
  }

  // NOTE: does not use resultBounds as the assignment is driven by the type of the RHS
  void loadASSIGN(BinaryNode binaryNode) {
    var lhs = binaryNode.lhs();
    var rhs = binaryNode.rhs();
    var rhsType = rhs.getType();
    // Detect dead assignments
    if (lhs instanceof IdentNode i) {
      var symbol = i.getSymbol();
      if (!symbol.isScope() && !symbol.hasSlotFor(rhsType) && lc.popDiscardIfCurrent(binaryNode)) {
        loadAndDiscard(rhs);
        method.markDeadLocalVariable(symbol);
        return;
      }
    }
    new Store<BinaryNode>(binaryNode, lhs) {
      @Override
      protected void evaluate() {
        // NOTE: we're loading with "at least as wide as" so optimistic operations on the right hand side remain optimistic, and then explicitly convert to the required type if needed.
        loadExpressionAsType(rhs, rhsType);
      }
    }.store();
  }

  /**
   * Binary self-assignment that can be optimistic: +=, -=, *=, and /=.
   */
  abstract class BinaryOptimisticSelfAssignment extends SelfModifyingStore<BinaryNode> {

    /**
     * Constructor
     * @param node the assign op node
     */
    BinaryOptimisticSelfAssignment(BinaryNode node) {
      super(node, node.lhs());
    }

    protected abstract void op(OptimisticOperation oo);

    @Override
    protected void evaluate() {
      var lhs = assignNode.lhs();
      var rhs = assignNode.rhs();
      var widestOperationType = assignNode.getWidestOperationType();
      var bounds = new TypeBounds(assignNode.getType(), widestOperationType);
      new OptimisticOperation(assignNode, bounds) {
        @Override
        void loadStack() {
          boolean forceConversionSeparation;
          if (isValid(getProgramPoint()) || widestOperationType == Type.NUMBER) {
            forceConversionSeparation = false;
          } else {
            var operandType = Type.widest(booleanToInt(objectToNumber(lhs.getType())), booleanToInt(objectToNumber(rhs.getType())));
            forceConversionSeparation = operandType.narrowerThan(widestOperationType);
          }
          loadBinaryOperands(lhs, rhs, bounds, true, forceConversionSeparation);
        }
        @Override
        void consumeStack() {
          op(this);
        }
      }.emit(getOptimisticIgnoreCountForSelfModifyingExpression(lhs));
      method.convert(assignNode.getType());
    }
  }

  /**
   * Non-optimistic binary self-assignment operation.
   * Basically, everything except +=, -=, *=, and /=.
   */
  abstract class BinarySelfAssignment extends SelfModifyingStore<BinaryNode> {

    BinarySelfAssignment(BinaryNode node) {
      super(node, node.lhs());
    }

    protected abstract void op();

    @Override
    protected void evaluate() {
      loadBinaryOperands(assignNode.lhs(), assignNode.rhs(), TypeBounds.UNBOUNDED.notWiderThan(assignNode.getWidestOperandType()), true, false);
      op();
    }
  }

  void loadASSIGN_ADD(BinaryNode binaryNode) {
    new BinaryOptimisticSelfAssignment(binaryNode) {
      @Override
      protected void op(OptimisticOperation oo) {
        assert !(binaryNode.getType().isObject() && oo.isOptimistic);
        method.add(oo.getProgramPoint());
      }
    }.store();
  }

  void loadASSIGN_BIT_AND(BinaryNode binaryNode) {
    new BinarySelfAssignment(binaryNode) {
      @Override
      protected void op() {
        method.and();
      }
    }.store();
  }

  void loadASSIGN_BIT_OR(BinaryNode binaryNode) {
    new BinarySelfAssignment(binaryNode) {
      @Override
      protected void op() {
        method.or();
      }
    }.store();
  }

  void loadASSIGN_BIT_XOR(BinaryNode binaryNode) {
    new BinarySelfAssignment(binaryNode) {
      @Override
      protected void op() {
        method.xor();
      }
    }.store();
  }

  void loadASSIGN_DIV(BinaryNode binaryNode) {
    new BinaryOptimisticSelfAssignment(binaryNode) {
      @Override
      protected void op(OptimisticOperation oo) {
        method.div(oo.getProgramPoint());
      }
    }.store();
  }

  void loadASSIGN_MOD(BinaryNode binaryNode) {
    new BinaryOptimisticSelfAssignment(binaryNode) {
      @Override
      protected void op(OptimisticOperation oo) {
        method.rem(oo.getProgramPoint());
      }
    }.store();
  }

  void loadASSIGN_MUL(BinaryNode binaryNode) {
    new BinaryOptimisticSelfAssignment(binaryNode) {
      @Override
      protected void op(OptimisticOperation oo) {
        method.mul(oo.getProgramPoint());
      }
    }.store();
  }

  void loadASSIGN_SAR(BinaryNode binaryNode) {
    new BinarySelfAssignment(binaryNode) {
      @Override
      protected void op() {
        method.sar();
      }
    }.store();
  }

  void loadASSIGN_SHL(BinaryNode binaryNode) {
    new BinarySelfAssignment(binaryNode) {
      @Override
      protected void op() {
        method.shl();
      }
    }.store();
  }

  void loadASSIGN_SHR(BinaryNode binaryNode) {
    new SelfModifyingStore<BinaryNode>(binaryNode, binaryNode.lhs()) {
      @Override
      protected void evaluate() {
        new OptimisticOperation(assignNode, new TypeBounds(Type.INT, Type.NUMBER)) {
          @Override
          void loadStack() {
            assert assignNode.getWidestOperandType() == Type.INT;
            if (isRhsZero(binaryNode)) {
              loadExpression(binaryNode.lhs(), TypeBounds.INT, true);
            } else {
              loadBinaryOperands(binaryNode.lhs(), binaryNode.rhs(), TypeBounds.INT, true, false);
              method.shr();
            }
          }
          @Override
          void consumeStack() {
            if (isOptimistic(binaryNode)) {
              toUint32Optimistic(binaryNode.getProgramPoint());
            } else {
              toUint32Double();
            }
          }
        }.emit(getOptimisticIgnoreCountForSelfModifyingExpression(binaryNode.lhs()));
        method.convert(assignNode.getType());
      }
    }.store();
  }

  void doSHR(BinaryNode binaryNode) {
    new OptimisticOperation(binaryNode, new TypeBounds(Type.INT, Type.NUMBER)) {
      @Override
      void loadStack() {
        if (isRhsZero(binaryNode)) {
          loadExpressionAsType(binaryNode.lhs(), Type.INT);
        } else {
          loadBinaryOperands(binaryNode);
          method.shr();
        }
      }
      @Override
      void consumeStack() {
        if (isOptimistic(binaryNode)) {
          toUint32Optimistic(binaryNode.getProgramPoint());
        } else {
          toUint32Double();
        }
      }
    }.emit();
  }

  void toUint32Optimistic(int programPoint) {
    method.load(programPoint);
    JSType.TO_UINT32_OPTIMISTIC.invoke(method);
  }

  void toUint32Double() {
    JSType.TO_UINT32_DOUBLE.invoke(method);
  }

  void loadASSIGN_SUB(BinaryNode binaryNode) {
    new BinaryOptimisticSelfAssignment(binaryNode) {
      @Override
      protected void op(OptimisticOperation oo) {
        method.sub(oo.getProgramPoint());
      }
    }.store();
  }

  /**
   * Helper class for binary arithmetic ops
   */
  abstract class BinaryArith {

    protected abstract void op(int programPoint);

    protected void evaluate(BinaryNode node, TypeBounds resultBounds) {
      var numericBounds = resultBounds.booleanToInt().objectToNumber();
      new OptimisticOperation(node, numericBounds) {
        @Override
        void loadStack() {
          TypeBounds operandBounds;
          var forceConversionSeparation = false;
          if (numericBounds.narrowest == Type.NUMBER) {
            // Result should be double always.
            // Propagate it into the operands so we don't have lots of I2D and L2D after operand evaluation.
            assert numericBounds.widest == Type.NUMBER;
            operandBounds = numericBounds;
          } else {
            var isOptimistic = isValid(getProgramPoint());
            if (isOptimistic || node.isTokenType(TokenType.DIV) || node.isTokenType(TokenType.MOD)) {
              operandBounds = new TypeBounds(node.getType(), Type.NUMBER);
            } else {
              // Non-optimistic, non-FP subtraction or multiplication. Allow them to overflow.
              operandBounds = new TypeBounds(Type.narrowest(node.getWidestOperandType(), numericBounds.widest), Type.NUMBER);
              forceConversionSeparation = true;
            }
          }
          loadBinaryOperands(node.lhs(), node.rhs(), operandBounds, false, forceConversionSeparation);
        }
        @Override
        void consumeStack() {
          op(getProgramPoint());
        }
      }.emit();
    }
  }

  void loadBIT_AND(BinaryNode binaryNode) {
    loadBinaryOperands(binaryNode);
    method.and();
  }

  void loadBIT_OR(BinaryNode binaryNode) {
    // Optimize x|0 to (int)x
    if (isRhsZero(binaryNode)) {
      loadExpressionAsType(binaryNode.lhs(), Type.INT);
    } else {
      loadBinaryOperands(binaryNode);
      method.or();
    }
  }

  static boolean isRhsZero(BinaryNode binaryNode) {
    var rhs = binaryNode.rhs();
    return rhs instanceof LiteralNode && INT_ZERO.equals(((LiteralNode<?>) rhs).getValue());
  }

  void loadBIT_XOR(BinaryNode binaryNode) {
    loadBinaryOperands(binaryNode);
    method.xor();
  }

  void loadCOMMARIGHT(BinaryNode binaryNode, TypeBounds resultBounds) {
    loadAndDiscard(binaryNode.lhs());
    loadMaybeDiscard(binaryNode, binaryNode.rhs(), resultBounds);
  }

  void loadDIV(BinaryNode binaryNode, TypeBounds resultBounds) {
    new BinaryArith() {
      @Override
      protected void op(int programPoint) {
        method.div(programPoint);
      }
    }.evaluate(binaryNode, resultBounds);
  }

  void loadCmp(BinaryNode binaryNode, Condition cond) {
    loadComparisonOperands(binaryNode);
    var trueLabel = new Label("trueLabel");
    var afterLabel = new Label("skip");
    method.conditionalJump(cond, trueLabel);
    method.load(Boolean.FALSE);
    method.goto_(afterLabel);
    method.label(trueLabel);
    method.load(Boolean.TRUE);
    method.label(afterLabel);
  }

  void loadMOD(BinaryNode binaryNode, TypeBounds resultBounds) {
    new BinaryArith() {
      @Override
      protected void op(int programPoint) {
        method.rem(programPoint);
      }
    }.evaluate(binaryNode, resultBounds);
  }

  void loadMUL(BinaryNode binaryNode, TypeBounds resultBounds) {
    new BinaryArith() {
      @Override
      protected void op(int programPoint) {
        method.mul(programPoint);
      }
    }.evaluate(binaryNode, resultBounds);
  }

  void loadSAR(BinaryNode binaryNode) {
    loadBinaryOperands(binaryNode);
    method.sar();
  }

  void loadSHL(BinaryNode binaryNode) {
    loadBinaryOperands(binaryNode);
    method.shl();
  }

  void loadSHR(BinaryNode binaryNode) {
    doSHR(binaryNode);
  }

  void loadSUB(BinaryNode binaryNode, TypeBounds resultBounds) {
    new BinaryArith() {
      @Override
      protected void op(int programPoint) {
        method.sub(programPoint);
      }
    }.evaluate(binaryNode, resultBounds);
  }

  @Override
  public boolean enterLabelNode(LabelNode labelNode) {
    labeledBlockBreakLiveLocals.push(lc.getUsedSlotCount());
    return true;
  }

  @Override
  protected boolean enterDefault(Node node) {
    throw new AssertionError("Code generator entered node of type " + node.getClass().getName());
  }

  void loadTernaryNode(TernaryNode ternaryNode, TypeBounds resultBounds) {
    var test = ternaryNode.getTest();
    var trueExpr = ternaryNode.getTrueExpression();
    var falseExpr = ternaryNode.getFalseExpression();
    var falseLabel = new Label("ternary_false");
    var exitLabel = new Label("ternary_exit");
    var outNarrowest = Type.narrowest(resultBounds.widest, Type.generic(Type.widestReturnType(trueExpr.getType(), falseExpr.getType())));
    var outBounds = resultBounds.notNarrowerThan(outNarrowest);
    emitBranch(test, falseLabel, false);
    var isCurrentDiscard = lc.popDiscardIfCurrent(ternaryNode);
    loadMaybeDiscard(isCurrentDiscard, trueExpr.getExpression(), outBounds);
    assert isCurrentDiscard || Type.generic(method.peekType()) == outBounds.narrowest;
    method.beforeJoinPoint(trueExpr);
    method.goto_(exitLabel);
    method.label(falseLabel);
    loadMaybeDiscard(isCurrentDiscard, falseExpr.getExpression(), outBounds);
    assert isCurrentDiscard || Type.generic(method.peekType()) == outBounds.narrowest;
    method.beforeJoinPoint(falseExpr);
    method.label(exitLabel);
  }

  /**
   * Generate all shared scope calls generated during codegen.
   */
  void generateScopeCalls() {
    for (var scopeAccess : lc.getScopeCalls()) {
      scopeAccess.generateScopeCall();
    }
  }

  /**
   * The difference between a store and a self modifying store is that the latter may load part of the target on the stack, e.g. the base of an AccessNode or the base and index of an IndexNode.
   * These are used both as target and as an extra source.
   * Previously it was problematic for self modifying stores if the target/lhs didn't belong to one of three trivial categories: IdentNode, AcessNodes, IndexNodes.
   * In that case it was evaluated and tagged as "resolved", which meant at the second time the lhs of this store was read (e.g. in a = a (second) + b for a += b, it would be evaluated to a nop in the scope and cause stack underflow
   * see NASHORN-703
   * @param <T>
   */
  abstract class SelfModifyingStore<T extends Expression> extends Store<T> {
    protected SelfModifyingStore(T assignNode, Expression target) {
      super(assignNode, target);
    }
    @Override
    protected boolean isSelfModifying() {
      return true;
    }
  }

  /**
   * Helper class to generate stores
   */
  abstract class Store<T extends Expression> {

    // An assignment node, e.g. x += y
    protected final T assignNode;

    // The target node to store to, e.g. x
    private final Expression target;

    // How deep on the stack do the arguments go if this generates an indy call
    private int depth;

    // If we have too many arguments, we need temporary storage, this is stored in 'quick'
    private IdentNode quick;

    /**
     * Constructor
     * @param assignNode the node representing the whole assignment
     * @param target     the target node of the assignment (destination)
     */
    protected Store(T assignNode, Expression target) {
      this.assignNode = assignNode;
      this.target = target;
    }

    /**
     * Constructor
     * @param assignNode the node representing the whole assignment
     */
    protected Store(T assignNode) {
      this(assignNode, assignNode);
    }

    /**
     * Is this a self modifying store operation, e.g. *= or ++
     * @return true if self modifying store
     */
    protected boolean isSelfModifying() {
      return false;
    }

    /**
     * This loads the parts of the target, e.g base and index.
     * they are kept on the stack throughout the store and used at the end to execute it
     */
    void prologue() {
      target.accept(new SimpleNodeVisitor() {
        @Override
        public boolean enterIdentNode(IdentNode node) {
          if (node.getSymbol().isScope()) {
            method.loadCompilerConstant(SCOPE);
            depth += Type.SCOPE.getSlots();
            assert depth == 1;
          }
          return false;
        }

        void enterBaseNode() {
          assert target instanceof BaseNode : "error - base node " + target + " must be instanceof BaseNode";
          var baseNode = (BaseNode) target;
          var base = baseNode.getBase();
          loadExpressionAsObject(base);
          depth += Type.OBJECT.getSlots();
          assert depth == 1;
          if (isSelfModifying()) {
            method.dup();
          }
        }

        @Override
        public boolean enterAccessNode(AccessNode node) {
          enterBaseNode();
          return false;
        }

        @Override
        public boolean enterIndexNode(IndexNode node) {
          enterBaseNode();
          var index = node.getIndex();
          if (!index.getType().isNumeric()) {
            // could be boolean here as well
            loadExpressionAsObject(index);
          } else {
            loadExpressionUnbounded(index);
          }
          depth += index.getType().getSlots();
          if (isSelfModifying()) {
            // convert "base base index" to "base index base index"
            method.dup(1);
          }
          return false;
        }
      });
    }

    /**
     * Generates an extra local variable, always using the same slot, one that is available after the end of the frame.
     * @param type the type of the variable
     * @return the quick variable
     */
    IdentNode quickLocalVariable(Type type) {
      var name = lc.getCurrentFunction().uniqueName(QUICK_PREFIX.symbolName());
      var symbol = new Symbol(name, Symbol.IS_INTERNAL | Symbol.HAS_SLOT);
      symbol.setHasSlotFor(type);
      symbol.setFirstSlot(lc.quickSlot(type));
      var quickIdent = IdentNode.createInternalIdentifier(symbol).setType(type);
      return quickIdent;
    }

    // store the result that "lives on" after the op, e.g. "i" in i++ postfix.
    protected void storeNonDiscard() {
      if (lc.popDiscardIfCurrent(assignNode)) {
        assert assignNode.isAssignment();
        return;
      }
      if (method.dup(depth) == null) {
        method.dup();
        var quickType = method.peekType();
        this.quick = quickLocalVariable(quickType);
        var quickSymbol = quick.getSymbol();
        method.storeTemp(quickType, quickSymbol.getFirstSlot());
      }
    }

    /**
     * Take the original target args from the stack and use them together with the value to be stored to emit the store code.
     * The case that targetSymbol is in scope (!hasSlot) and we actually need to do a conversion on non-equivalent types exists, but is very rare.
     * See for example test/script/basic/access-specializer.js
     */
    void epilogue() {
      target.accept(new SimpleNodeVisitor() {
        @Override
        protected boolean enterDefault(Node node) {
          throw new AssertionError("Unexpected node " + node + " in store epilogue");
        }
        @Override
        public boolean enterIdentNode(IdentNode node) {
          var symbol = node.getSymbol();
          assert symbol != null;
          if (symbol.isScope()) {
            var flags = getScopeCallSiteFlags(symbol) | (node.isDeclaredHere() ? CALLSITE_DECLARE : 0);
            if (isFastScope(symbol)) {
              storeFastScopeVar(symbol, flags);
            } else {
              method.dynamicSet(node.getName(), flags, false);
            }
          } else {
            var storeType = assignNode.getType();
            assert storeType != Type.LONG;
            if (symbol.hasSlotFor(storeType)) {
              // Only emit a convert for a store known to be live; converts for dead stores can give us an unnecessary ClassCastException.
              method.convert(storeType);
            }
            storeIdentWithCatchConversion(node, storeType);
          }
          return false;
        }
        @Override
        public boolean enterAccessNode(AccessNode node) {
          method.dynamicSet(node.getProperty(), getCallSiteFlags(), node.isIndex());
          return false;
        }
        @Override
        public boolean enterIndexNode(IndexNode node) {
          method.dynamicSetIndex(getCallSiteFlags());
          return false;
        }
      });
      // whatever is on the stack now is the final answer
    }

    protected abstract void evaluate();

    void store() {
      if (target instanceof IdentNode i) {
        checkTemporalDeadZone(i);
      }
      prologue();
      evaluate(); // leaves an operation of whatever the operationType was on the stack
      storeNonDiscard();
      epilogue();
      if (quick != null) {
        method.load(quick);
      }
    }
  }

  void newFunctionObject(FunctionNode functionNode, boolean addInitializer) {
    assert lc.peek() == functionNode;
    var data = compiler.getScriptFunctionData(functionNode.getId());
    if (functionNode.isProgram() && !compiler.isOnDemandCompilation()) {
      var createFunction = functionNode.getCompileUnit().getClassEmitter()
        .method(EnumSet.of(Flag.PUBLIC, Flag.STATIC), CREATE_PROGRAM_FUNCTION.symbolName(), ScriptFunction.class, ScriptObject.class);
      createFunction.begin();
      loadConstantsAndIndex(data, createFunction);
      createFunction.load(SCOPE_TYPE, 0);
      createFunction.invoke(CREATE_FUNCTION_OBJECT);
      createFunction.return_();
      createFunction.end();
    }
    if (addInitializer && !compiler.isOnDemandCompilation()) {
      functionNode.getCompileUnit().addFunctionInitializer(data, functionNode);
    }
    // We don't emit a ScriptFunction on stack for the outermost compiled function (as there's no code being generated in its outer context that'd need it as a callee).
    if (lc.getOutermostFunction() == functionNode) {
      return;
    }
    loadConstantsAndIndex(data, method);
    if (functionNode.needsParentScope()) {
      method.loadCompilerConstant(SCOPE);
      method.invoke(CREATE_FUNCTION_OBJECT);
    } else {
      method.invoke(CREATE_FUNCTION_OBJECT_NO_SCOPE);
    }
  }

  // calls on Global class.

  MethodEmitter globalInstance() {
    return method.invokestatic(GLOBAL_OBJECT, "instance", "()L" + GLOBAL_OBJECT + ';');
  }

  MethodEmitter globalAllocateArguments() {
    return method.invokestatic(GLOBAL_OBJECT, "allocateArguments", methodDescriptor(ScriptObject.class, Object[].class, Object.class, int.class));
  }

  MethodEmitter globalNewRegExp() {
    return method.invokestatic(GLOBAL_OBJECT, "newRegExp", methodDescriptor(Object.class, String.class, String.class));
  }

  MethodEmitter globalRegExpCopy() {
    return method.invokestatic(GLOBAL_OBJECT, "regExpCopy", methodDescriptor(Object.class, Object.class));
  }

  MethodEmitter globalAllocateArray(ArrayType type) {
    // make sure the native array is treated as an array type
    return method.invokestatic(GLOBAL_OBJECT, "allocate", "(" + type.getDescriptor() + ")Les/objects/NativeArray;");
  }

  MethodEmitter globalIsEval() {
    return method.invokestatic(GLOBAL_OBJECT, "isEval", methodDescriptor(boolean.class, Object.class));
  }

  MethodEmitter globalReplaceLocationPropertyPlaceholder() {
    return method.invokestatic(GLOBAL_OBJECT, "replaceLocationPropertyPlaceholder", methodDescriptor(Object.class, Object.class, Object.class));
  }

  MethodEmitter globalCheckObjectCoercible() {
    return method.invokestatic(GLOBAL_OBJECT, "checkObjectCoercible", methodDescriptor(void.class, Object.class));
  }

  MethodEmitter globalDirectEval() {
    return method.invokestatic(GLOBAL_OBJECT, "directEval", methodDescriptor(Object.class, Object.class, Object.class, Object.class, Object.class, boolean.class));
  }

  abstract class OptimisticOperation {

    final boolean isOptimistic;

    // expression and optimistic are the same reference
    private final Expression expression;
    private final Optimistic optimistic;

    private final TypeBounds resultBounds;

    OptimisticOperation(Optimistic optimistic, TypeBounds resultBounds) {
      this.optimistic = optimistic;
      this.expression = (Expression) optimistic;
      this.resultBounds = resultBounds;
      // Operation is only effectively optimistic if its type, after being coerced into the result bounds is narrower than the upper bound.
      this.isOptimistic = isOptimistic(optimistic) && resultBounds.within(Type.generic(((Expression) optimistic).getType())).narrowerThan(resultBounds.widest);
      // Optimistic operations need to be executed in optimistic context, else unwarranted optimism will go unnoticed
      assert !this.isOptimistic || useOptimisticTypes();
    }

    MethodEmitter emit() {
      return emit(0);
    }

    MethodEmitter emit(int ignoredArgCount) {
      var programPoint = optimistic.getProgramPoint();
      var optimisticOrContinuation = isOptimistic || isContinuationEntryPoint(programPoint);
      var currentContinuationEntryPoint = isCurrentContinuationEntryPoint(programPoint);
      var stackSizeOnEntry = method.getStackSize() - ignoredArgCount;
      // First store the values on the stack opportunistically into local variables.
      // Doing it before loadStack() allows us to not have to pop/load any arguments that are pushed onto it by loadStack() in the second storeStack().
      storeStack(ignoredArgCount, optimisticOrContinuation);
      // Now, load the stack
      loadStack();
      // Now store the values on the stack ultimately into local variables.
      // In vast majority of cases, this is (aside from creating the local types map) a no-op, as the first opportunistic stack store will already store all variables.
      // However, there can be operations in the loadStack() that invalidate some of the stack stores, e.g. in "x[i] = x[++i]", "++i" will invalidate the already stored value for "i".
      // In such unfortunate cases this second storeStack() will restore the invariant that everything on the stack is stored into a local variable, although at the cost of doing a store/load on the loaded arguments as well.
      var liveLocalsCount = storeStack(method.getStackSize() - stackSizeOnEntry, optimisticOrContinuation);
      assert optimisticOrContinuation == (liveLocalsCount != -1);
      Label beginTry;
      Label catchLabel;
      Label afterConsumeStack = isOptimistic || currentContinuationEntryPoint ? new Label("after_consume_stack") : null;
      if (isOptimistic) {
        beginTry = new Label("try_optimistic");
        var catchLabelName = (afterConsumeStack == null ? "" : afterConsumeStack.toString()) + "_handler";
        catchLabel = new Label(catchLabelName);
        method.label(beginTry);
      } else {
        beginTry = catchLabel = null;
      }
      consumeStack();
      if (isOptimistic) {
        method.try_(beginTry, afterConsumeStack, catchLabel, UnwarrantedOptimismException.class);
      }
      if (isOptimistic || currentContinuationEntryPoint) {
        method.label(afterConsumeStack);
        var localLoads = method.getLocalLoadsOnStack(0, stackSizeOnEntry);
        assert everyStackValueIsLocalLoad(localLoads) : Arrays.toString(localLoads) + ", " + stackSizeOnEntry + ", " + ignoredArgCount;
        var localTypesList = method.getLocalVariableTypes();
        var usedLocals = method.getUsedSlotsWithLiveTemporaries();
        var localTypes = method.getWidestLiveLocals(localTypesList.subList(0, usedLocals));
        assert everyLocalLoadIsValid(localLoads, usedLocals) : Arrays.toString(localLoads) + " ~ " + localTypes;
        if (isOptimistic) {
          addUnwarrantedOptimismHandlerLabel(localTypes, catchLabel);
        }
        if (currentContinuationEntryPoint) {
          var ci = getContinuationInfo();
          assert ci != null : "no continuation info found for " + lc.getCurrentFunction();
          assert !ci.hasTargetLabel(); // No duplicate program points
          ci.setTargetLabel(afterConsumeStack);
          ci.getHandlerLabel().markAsOptimisticContinuationHandlerFor(afterConsumeStack);
          // Can't rely on targetLabel.stack.localVariableTypes.length, as it can be higher due to effectively dead local variables.
          ci.lvarCount = localTypes.size();
          ci.setStackStoreSpec(localLoads);
          ci.setStackTypes(Arrays.copyOf(method.getTypesFromStack(method.getStackSize()), stackSizeOnEntry));
          assert ci.getStackStoreSpec().length == ci.getStackTypes().length;
          ci.setReturnValueType(method.peekType());
          ci.lineNumber = getLastLineNumber();
          ci.catchLabel = catchLabels.peek();
        }
      }
      return method;
    }

    /**
     * Stores the current contents of the stack into local variables so they are not lost before invoking something that can result in an {@code UnwarantedOptimizationException}.
     * @param ignoreArgCount the number of topmost arguments on stack to ignore when deciding on the shape of the catch block.
     *    Those are used in the situations when we could not place the call to {@code storeStack} early enough (before emitting code for pushing the arguments that the optimistic call will pop).
     *    This is admittedly a deficiency in the design of the code generator when it deals with self-assignments and we should probably look into fixing it.
     * @return types of the significant local variables after the stack was stored (types for local variables used for temporary storage of ignored arguments are not returned).
     * @param optimisticOrContinuation if false, this method should not execute a label for a catch block for the {@code UnwarantedOptimizationException}, suitable for capturing the currently live local variables, tailored to their types.
     */
    int storeStack(int ignoreArgCount, boolean optimisticOrContinuation) {
      if (!optimisticOrContinuation) {
        return -1; // NOTE: correct value to return is lc.getUsedSlotCount(), but it wouldn't be used anyway
      }
      var stackSize = method.getStackSize();
      var stackTypes = method.getTypesFromStack(stackSize);
      var localLoadsOnStack = method.getLocalLoadsOnStack(0, stackSize);
      var usedSlots = method.getUsedSlotsWithLiveTemporaries();
      var firstIgnored = stackSize - ignoreArgCount;
      // Find the first value on the stack (from the bottom) that is not a load from a local variable.
      var firstNonLoad = 0;
      while (firstNonLoad < firstIgnored && localLoadsOnStack[firstNonLoad] != Label.Stack.NON_LOAD) {
        firstNonLoad++;
      }
      // Only do the store/load if first non-load is not an ignored argument.
      // Otherwise, do nothing and return the number of used slots as the number of live local variables.
      if (firstNonLoad >= firstIgnored) {
        return usedSlots;
      }
      // Find the number of new temporary local variables that we need; it's the number of values on the stack that are not direct loads of existing local variables.
      var tempSlotsNeeded = 0;
      for (var i = firstNonLoad; i < stackSize; ++i) {
        if (localLoadsOnStack[i] == Label.Stack.NON_LOAD) {
          tempSlotsNeeded += stackTypes[i].getSlots();
        }
      }
      // Ensure all values on the stack that weren't directly loaded from a local variable are stored in a local variable.
      // We're starting from highest local variable index, so that in case ignoreArgCount > 0 the ignored ones end up at the end of the local variable table.
      var lastTempSlot = usedSlots + tempSlotsNeeded;
      var ignoreSlotCount = 0;
      for (var i = stackSize; i-- > firstNonLoad;) {
        var loadSlot = localLoadsOnStack[i];
        if (loadSlot == Label.Stack.NON_LOAD) {
          var type = stackTypes[i];
          var slots = type.getSlots();
          lastTempSlot -= slots;
          if (i >= firstIgnored) {
            ignoreSlotCount += slots;
          }
          method.storeTemp(type, lastTempSlot);
        } else {
          method.pop();
        }
      }
      assert lastTempSlot == usedSlots; // used all temporary locals
      var localTypesList = method.getLocalVariableTypes();
      // Load values back on stack.
      for (var i = firstNonLoad; i < stackSize; ++i) {
        var loadSlot = localLoadsOnStack[i];
        var stackType = stackTypes[i];
        var isLoad = loadSlot != Label.Stack.NON_LOAD;
        var lvarSlot = isLoad ? loadSlot : lastTempSlot;
        var lvarType = localTypesList.get(lvarSlot);
        method.load(lvarType, lvarSlot);
        if (isLoad) {
          // Conversion operators (I2L etc.) preserve "load"-ness of the value despite the fact that, in the proper sense they are creating a derived value from the loaded value.
          // This special behavior of on-stack conversion operators is necessary to accommodate for differences in local variable types after deoptimization; having a conversion operator throw away "load"-ness would create different local variable table shapes between optimism-failed code and its deoptimized rest-of method).
          // After we load the value back, we need to redo the conversion to the stack type if stack type is different.
          // NOTE: this would only strictly be necessary for widening conversions (I2L, L2D, I2D), and not for narrowing ones (L2I, D2L, D2I) as only widening conversions are the ones that can get eliminated in a deoptimized method, as their original input argument got widened.
          // Maybe experiment with throwing away "load"-ness for narrowing conversions in MethodEmitter.convert()?
          method.convert(stackType);
        } else {
          // temporary stores never needs a convert, as their type is always the same as the stack type.
          assert lvarType == stackType;
          lastTempSlot += lvarType.getSlots();
        }
      }
      // used all temporaries
      assert lastTempSlot == usedSlots + tempSlotsNeeded;
      return lastTempSlot - ignoreSlotCount;
    }

    void addUnwarrantedOptimismHandlerLabel(List<Type> localTypes, Label label) {
      var lvarTypesDescriptor = getLvarTypesDescriptor(localTypes);
      var unwarrantedOptimismHandlers = lc.getUnwarrantedOptimismHandlers();
      var labels = unwarrantedOptimismHandlers.get(lvarTypesDescriptor);
      if (labels == null) {
        labels = new LinkedList<>();
        unwarrantedOptimismHandlers.put(lvarTypesDescriptor, labels);
      }
      method.markLabelAsOptimisticCatchHandler(label, localTypes.size());
      labels.add(label);
    }

    abstract void loadStack();

    // Make sure that whatever indy call site you emit from this method uses {@code getCallSiteFlagsOptimistic(node)} or otherwise ensure optimistic flag is correctly set in the call site, otherwise it doesn't make much sense to use OptimisticExpression for emitting it.
    abstract void consumeStack();

    /**
     * Emits the correct dynamic getter code.
     * Normally just delegates to method emitter, except when the target expression is optimistic, and the desired type is narrower than the optimistic type.
     * In that case, it'll emit a dynamic getter with its original optimistic type, and explicitly insert a narrowing conversion.
     * This way we can preserve the optimism of the values even if they're subsequently immediately coerced into a narrower type.
     * This is beneficial because in this case we can still presume that since the original getter was optimistic, the conversion has no side effects.
     * @param name the name of the property being get
     * @param flags call site flags
     * @param isMethod whether we're preferably retrieving a function
     * @return the current method emitter
     */
    MethodEmitter dynamicGet(String name, int flags, boolean isMethod, boolean isIndex) {
      return isOptimistic
           ? method.dynamicGet(getOptimisticCoercedType(), name, getOptimisticFlags(flags), isMethod, isIndex)
           : method.dynamicGet(resultBounds.within(expression.getType()), name, nonOptimisticFlags(flags), isMethod, isIndex);
    }

    MethodEmitter dynamicGetIndex(int flags, boolean isMethod) {
      return isOptimistic
           ? method.dynamicGetIndex(getOptimisticCoercedType(), getOptimisticFlags(flags), isMethod)
           : method.dynamicGetIndex(resultBounds.within(expression.getType()), nonOptimisticFlags(flags), isMethod);
    }

    MethodEmitter dynamicCall(int argCount, int flags, String msg) {
      return isOptimistic
           ? method.dynamicCall(getOptimisticCoercedType(), argCount, getOptimisticFlags(flags), msg)
           : method.dynamicCall(resultBounds.within(expression.getType()), argCount, nonOptimisticFlags(flags), msg);
    }

    int getOptimisticFlags(int flags) {
      return flags | CALLSITE_OPTIMISTIC | (optimistic.getProgramPoint() << CALLSITE_PROGRAM_POINT_SHIFT); //encode program point in high bits
    }

    int getProgramPoint() {
      return isOptimistic ? optimistic.getProgramPoint() : INVALID_PROGRAM_POINT;
    }

    void convertOptimisticReturnValue() {
      if (isOptimistic) {
        var optimisticType = getOptimisticCoercedType();
        if (!optimisticType.isObject()) {
          method.load(optimistic.getProgramPoint());
          if (optimisticType.isInteger()) {
            method.invoke(ENSURE_INT);
          } else if (optimisticType.isNumber()) {
            method.invoke(ENSURE_NUMBER);
          } else {
            throw new AssertionError(optimisticType);
          }
        }
      }
    }

    void replaceCompileTimeProperty() {
      var identNode = (IdentNode) expression;
      var name = identNode.getSymbol().getName();
      if (CompilerConstants.__FILE__.name().equals(name)) {
        replaceCompileTimeProperty(getCurrentSource().getName());
      } else if (CompilerConstants.__DIR__.name().equals(name)) {
        replaceCompileTimeProperty(getCurrentSource().getBase());
      } else if (CompilerConstants.__LINE__.name().equals(name)) {
        replaceCompileTimeProperty(getCurrentSource().getLine(identNode.position()));
      }
    }

    /**
     * When an ident with name __FILE__, __DIR__, or __LINE__ is loaded, we'll try to look it up as any other identifier.
     * However, if it gets all the way up to the Global object, it will send back a special value that represents a placeholder for these compile-time location properties.
     * This method will generate code that loads the value of the compile-time location property and then invokes a method in Global that will replace the placeholder with the value.
     * Effectively, if the symbol for these properties is defined anywhere in the lexical scope, they take precedence, but if they aren't, then they resolve to the compile-time location property.
     * @param propertyValue the actual value of the property
     */
    void replaceCompileTimeProperty(Object propertyValue) {
      assert method.peekType().isObject();
      if (propertyValue instanceof String || propertyValue == null) {
        method.load((String) propertyValue);
      } else if (propertyValue instanceof Integer i) {
        method.load(i);
        method.convert(Type.OBJECT);
      } else {
        throw new AssertionError();
      }
      globalReplaceLocationPropertyPlaceholder();
      convertOptimisticReturnValue();
    }

    /**
     * Returns the type that should be used as the return type of the dynamic invocation that is emitted as the code for the current optimistic operation.
     * If the type bounds is exact boolean or narrower than the expression's optimistic type, then the optimistic type is returned, otherwise the coercing type.
     * Effectively, this method allows for moving the coercion into the optimistic type when it won't adversely affect the optimistic evaluation semantics, and for preserving the optimistic type and doing a separate coercion when it would affect it.
     */
    Type getOptimisticCoercedType() {
      var optimisticType = expression.getType();
      assert resultBounds.widest.widerThan(optimisticType);
      var narrowest = resultBounds.narrowest;
      if (narrowest.isBoolean() || narrowest.narrowerThan(optimisticType)) {
        assert !optimisticType.isObject();
        return optimisticType;
      }
      assert !narrowest.isObject();
      return narrowest;
    }
  }

  static boolean isOptimistic(Optimistic optimistic) {
    if (!optimistic.canBeOptimistic()) {
      return false;
    }
    var expr = (Expression) optimistic;
    return expr.getType().narrowerThan(expr.getWidestOperationType());
  }

  static boolean everyLocalLoadIsValid(int[] loads, int localCount) {
    for (var load : loads) {
      if (load < 0 || load >= localCount) {
        return false;
      }
    }
    return true;
  }

  static boolean everyStackValueIsLocalLoad(int[] loads) {
    for (var load : loads) {
      if (load == Label.Stack.NON_LOAD) {
        return false;
      }
    }
    return true;
  }

  String getLvarTypesDescriptor(List<Type> localVarTypes) {
    var count = localVarTypes.size();
    var desc = new StringBuilder(count);
    for (var i = 0; i < count;) {
      i += appendType(desc, localVarTypes.get(i));
    }
    return method.markSymbolBoundariesInLvarTypesDescriptor(desc.toString());
  }

  static int appendType(StringBuilder b, Type t) {
    b.append(t.getBytecodeStackType());
    return t.getSlots();
  }

  static int countSymbolsInLvarTypeDescriptor(String lvarTypeDescriptor) {
    var count = 0;
    for (var i = 0; i < lvarTypeDescriptor.length(); ++i) {
      if (Character.isUpperCase(lvarTypeDescriptor.charAt(i))) {
        ++count;
      }
    }
    return count;
  }

  /**
   * Generates all the required {@code UnwarrantedOptimismException} handlers for the current function.
   * The employed strategy strives to maximize code reuse.
   * Every handler constructs an array to hold the local variables, then fills in some trailing part of the local variables (those for which it has a unique suffix in the descriptor), then jumps to a handler for a prefix that's shared with other handlers.
   * A handler that fills up locals up to position 0 will not jump to a prefix handler (as it has no prefix), but instead end with constructing and throwing a {@code RewriteException}.
   * Since we lexicographically sort the entries, we only need to check every entry to its immediately preceding one for longest matching prefix.
   * @return true if there is at least one exception handler
   */
  boolean generateUnwarrantedOptimismExceptionHandlers(FunctionNode fn) {
    if (!useOptimisticTypes()) {
      return false;
    }
    // Take the mapping of lvarSpecs -> labels, and turn them into a descending lexicographically sorted list of handler specifications.
    var unwarrantedOptimismHandlers = lc.popUnwarrantedOptimismHandlers();
    if (unwarrantedOptimismHandlers.isEmpty()) {
      return false;
    }
    // method.lineNumber(0);
    var handlerSpecs = new ArrayList<OptimismExceptionHandlerSpec>(unwarrantedOptimismHandlers.size() * 4 / 3);
    for (var spec : unwarrantedOptimismHandlers.keySet()) {
      handlerSpecs.add(new OptimismExceptionHandlerSpec(spec, true));
    }
    Collections.sort(handlerSpecs, Collections.reverseOrder());
    // Map of local variable specifications to labels for populating the array for that local variable spec.
    var delegationLabels = new HashMap<String, Label>();
    // Do everything in a single pass over the handlerSpecs list.
    // Note that the list can actually grow as we're passing through it as we might add new prefix handlers into it, so can't hoist size() outside of the loop.
    for (var handlerIndex = 0; handlerIndex < handlerSpecs.size(); ++handlerIndex) {
      var spec = handlerSpecs.get(handlerIndex);
      var lvarSpec = spec.lvarSpec;
      if (spec.catchTarget) {
        assert !method.isReachable();
        // Start a catch block and assign the labels for this lvarSpec with it.
        method.catch_(unwarrantedOptimismHandlers.get(lvarSpec));
        // This spec is a catch target, so emit array creation code. The length of the array is the number of symbols - the number of uppercase characters.
        method.load(countSymbolsInLvarTypeDescriptor(lvarSpec));
        method.newarray(Type.OBJECT_ARRAY);
      }
      if (spec.delegationTarget) {
        // If another handler can delegate to this handler as its prefix, then put a jump target here for the shared code (after the array creation code, which is never shared).
        method.label(delegationLabels.get(lvarSpec)); // label must exist
      }
      var lastHandler = handlerIndex == handlerSpecs.size() - 1;
      int lvarIndex;
      int firstArrayIndex;
      int firstLvarIndex;
      Label delegationLabel;
      String commonLvarSpec;
      if (lastHandler) {
        // Last handler block, doesn't delegate to anything.
        lvarIndex = 0;
        firstLvarIndex = 0;
        firstArrayIndex = 0;
        delegationLabel = null;
        commonLvarSpec = null;
      } else {
        // Not yet the last handler block, will definitely delegate to another handler; let's figure out which one.
        // It can be an already declared handler further down the list, or it might need to declare a new prefix handler.
        var nextHandlerIndex = handlerIndex + 1;
        var nextLvarSpec = handlerSpecs.get(nextHandlerIndex).lvarSpec;
        // Since we're lexicographically ordered, the common prefix handler is defined by the common prefix of this handler and the next handler on the list.
        commonLvarSpec = commonPrefix(lvarSpec, nextLvarSpec);
        // We don't chop symbols in half
        assert Character.isUpperCase(commonLvarSpec.charAt(commonLvarSpec.length() - 1));
        // Let's find if we already have a declaration for such handler, or we need to insert it.
        {
          var addNewHandler = true;
          var commonHandlerIndex = nextHandlerIndex;
          for (; commonHandlerIndex < handlerSpecs.size(); ++commonHandlerIndex) {
            var forwardHandlerSpec = handlerSpecs.get(commonHandlerIndex);
            var forwardLvarSpec = forwardHandlerSpec.lvarSpec;
            if (forwardLvarSpec.equals(commonLvarSpec)) {
              // We already have a handler for the common prefix.
              addNewHandler = false;
              // Make sure we mark it as a delegation target.
              forwardHandlerSpec.delegationTarget = true;
              break;
            } else if (!forwardLvarSpec.startsWith(commonLvarSpec)) {
              break;
            }
          }
          if (addNewHandler) {
            // We need to insert a common prefix handler.
            // Note handlers created with catchTarget == false will automatically have delegationTarget == true (because that's the only reason for their existence).
            handlerSpecs.add(commonHandlerIndex, new OptimismExceptionHandlerSpec(commonLvarSpec, false));
          }
        }
        firstArrayIndex = countSymbolsInLvarTypeDescriptor(commonLvarSpec);
        lvarIndex = 0;
        for (var j = 0; j < commonLvarSpec.length(); ++j) {
          lvarIndex += CodeGeneratorLexicalContext.getTypeForSlotDescriptor(commonLvarSpec.charAt(j)).getSlots();
        }
        firstLvarIndex = lvarIndex;
        // Create a delegation label if not already present
        delegationLabel = delegationLabels.get(commonLvarSpec);
        if (delegationLabel == null) {
          // uo_pa == "unwarranted optimism, populate array"
          delegationLabel = new Label("uo_pa_" + commonLvarSpec);
          delegationLabels.put(commonLvarSpec, delegationLabel);
        }
      }
      // Load local variables handled by this handler on stack
      var args = 0;
      var symbolHadValue = false;
      for (var typeIndex = commonLvarSpec == null ? 0 : commonLvarSpec.length(); typeIndex < lvarSpec.length(); ++typeIndex) {
        var typeDesc = lvarSpec.charAt(typeIndex);
        var lvarType = CodeGeneratorLexicalContext.getTypeForSlotDescriptor(typeDesc);
        if (!lvarType.isUnknown()) {
          method.load(lvarType, lvarIndex);
          symbolHadValue = true;
          args++;
        } else if (typeDesc == 'U' && !symbolHadValue) {
          // Symbol boundary with undefined last value.
          // Check if all previous values for this symbol were also undefined; if so, emit one explicit Undefined.
          // This serves to ensure that we're emiting exactly one value for every symbol that uses local slots.
          // While we could in theory ignore symbols that are undefined (in other words, dead) at the point where this exception was thrown, unfortunately we can't do it in practice.
          // The reason for this is that currently our liveness analysis is coarse (it can determine whether a symbol has not been read with a particular type anywhere in the function being compiled, but that's it), and a symbol being promoted to Object due to a deoptimization will suddenly show up as "live for Object type", and previously dead U->O conversions on loop entries will suddenly become alive in the deoptimized method which will then expect a value for that slot in its continuation handler.
          // If we had precise liveness analysis, we could go back to excluding known dead symbols from the payload of the RewriteException.
          if (method.peekType() == Type.UNDEFINED) {
            method.dup();
          } else {
            method.loadUndefined(Type.OBJECT);
          }
          args++;
        }
        if (Character.isUpperCase(typeDesc)) {
          // Reached symbol boundary; reset flag for the next symbol.
          symbolHadValue = false;
        }
        lvarIndex += lvarType.getSlots();
      }
      assert args > 0;
      // Delegate actual storing into array to an array populator utility method.
      // on the stack:
      //   object array to be populated
      //   start index
      //   a lot of types
      method.dynamicArrayPopulatorCall(args + 1, firstArrayIndex);
      if (delegationLabel != null) {
        // We cascade to a prefix handler to fill out the rest of the local variables and throw the
        // RewriteException.
        assert !lastHandler;
        assert commonLvarSpec != null;
        // Must undefine the local variables that we have already processed for the sake of correct join on the delegate label
        method.undefineLocalVariables(firstLvarIndex, true);
        var nextSpec = handlerSpecs.get(handlerIndex + 1);
        // If the delegate immediately follows, and it's not a catch target (so it doesn't have array setup code) don't bother emitting a jump, as we'd just jump to the next instruction.
        if (!nextSpec.lvarSpec.equals(commonLvarSpec) || nextSpec.catchTarget) {
          method.goto_(delegationLabel);
        }
      } else {
        assert lastHandler;
        // Nothing to delegate to, so this handler must create and throw the RewriteException.
        // At this point we have the UnwarrantedOptimismException and the Object[] with local variables on stack.
        // We need to create a RewriteException, push two references to it below the constructor arguments, invoke the constructor, and throw the exception.
        loadConstant(getByteCodeSymbolNames(fn));
        if (isRestOf()) {
          loadConstant(getContinuationEntryPoints());
          method.invoke(CREATE_REWRITE_EXCEPTION_REST_OF);
        } else {
          method.invoke(CREATE_REWRITE_EXCEPTION);
        }
        method.athrow();
      }
    }
    return true;
  }

  // Only names of local variables on the function level are captured.
  // This information is used to reduce deoptimizations, so as much as we can capture will help.
  // We rely on the fact that function wide variables are all live all the time, so the array passed to rewrite exception contains one element for every slotted symbol here.
  static String[] getByteCodeSymbolNames(FunctionNode fn) {
    var names = new ArrayList<String>();
    for (var symbol : fn.getBody().getSymbols()) {
      if (symbol.hasSlot()) {
        if (symbol.isScope()) {
          // slot + scope can only be true for parameters
          assert symbol.isParam();
          names.add(null);
        } else {
          names.add(symbol.getName());
        }
      }
    }
    return names.toArray(new String[0]);
  }

  static String commonPrefix(String s1, String s2) {
    var l1 = s1.length();
    var l = Math.min(l1, s2.length());
    var lms = -1; // last matching symbol
    for (var i = 0; i < l; ++i) {
      var c1 = s1.charAt(i);
      if (c1 != s2.charAt(i)) {
        return s1.substring(0, lms + 1);
      } else if (Character.isUpperCase(c1)) {
        lms = i;
      }
    }
    return l == l1 ? s1 : s2;
  }

  static class OptimismExceptionHandlerSpec implements Comparable<OptimismExceptionHandlerSpec> {

    private final String lvarSpec;
    private final boolean catchTarget;
    private boolean delegationTarget;

    OptimismExceptionHandlerSpec(String lvarSpec, boolean catchTarget) {
      this.lvarSpec = lvarSpec;
      this.catchTarget = catchTarget;
      if (!catchTarget) {
        delegationTarget = true;
      }
    }

    @Override
    public int compareTo(OptimismExceptionHandlerSpec o) {
      return lvarSpec.compareTo(o.lvarSpec);
    }

    @Override
    public String toString() {
      var b = new StringBuilder(64).append("[HandlerSpec ").append(lvarSpec);
      if (catchTarget) {
        b.append(", catchTarget");
      }
      if (delegationTarget) {
        b.append(", delegationTarget");
      }
      return b.append("]").toString();
    }
  }

  static class ContinuationInfo {

    private final Label handlerLabel;
    private Label targetLabel; // Label for the target instruction.
    int lvarCount;

    // Indices of local variables that need to be loaded on the stack when this node completes
    private int[] stackStoreSpec;

    // Types of values loaded on the stack
    private Type[] stackTypes;

    // If non-null, this node should perform the requisite type conversion
    private Type returnValueType;

    // If we are in the middle of an object literal initialization, we need to update the property maps
    private Map<Integer, PropertyMap> objectLiteralMaps;

    // The line number at the continuation point
    private int lineNumber;

// The active catch label, in case the continuation point is in a try/catch block
    private Label catchLabel;

    // The number of scopes that need to be popped before control is transferred to the catch label.
    private int exceptionScopePops;

    ContinuationInfo() {
      this.handlerLabel = new Label("continuation_handler");
    }

    Label getHandlerLabel() {
      return handlerLabel;
    }

    boolean hasTargetLabel() {
      return targetLabel != null;
    }

    Label getTargetLabel() {
      return targetLabel;
    }

    void setTargetLabel(Label targetLabel) {
      this.targetLabel = targetLabel;
    }

    int[] getStackStoreSpec() {
      return stackStoreSpec.clone();
    }

    void setStackStoreSpec(int[] stackStoreSpec) {
      this.stackStoreSpec = stackStoreSpec;
    }

    Type[] getStackTypes() {
      return stackTypes.clone();
    }

    void setStackTypes(Type[] stackTypes) {
      this.stackTypes = stackTypes;
    }

    Type getReturnValueType() {
      return returnValueType;
    }

    void setReturnValueType(Type returnValueType) {
      this.returnValueType = returnValueType;
    }

    void setObjectLiteralMap(int objectLiteralStackDepth, PropertyMap objectLiteralMap) {
      if (objectLiteralMaps == null) {
        objectLiteralMaps = new HashMap<>();
      }
      objectLiteralMaps.put(objectLiteralStackDepth, objectLiteralMap);
    }

    PropertyMap getObjectLiteralMap(int stackDepth) {
      return objectLiteralMaps == null ? null : objectLiteralMaps.get(stackDepth);
    }

    @Override
    public String toString() {
      return "[localVariableTypes=" + targetLabel.getStack().getLocalVariableTypesCopy() + ", stackStoreSpec=" + Arrays.toString(stackStoreSpec) + ", returnValueType=" + returnValueType + "]";
    }
  }

  ContinuationInfo getContinuationInfo() {
    return continuationInfo;
  }

  void generateContinuationHandler() {
    if (!isRestOf()) {
      return;
    }
    var ci = getContinuationInfo();
    method.label(ci.getHandlerLabel());
    // There should never be an exception thrown from the continuation handler, but in case there is (meaning, Nashorn has a bug), then line number 0 will be an indication of where it came from (line numbers are Uint16).
    // method.lineNumber(0);
    var stack = ci.getTargetLabel().getStack();
    var lvarTypes = stack.getLocalVariableTypesCopy();
    var symbolBoundary = stack.getSymbolBoundaryCopy();
    var lvarCount = ci.lvarCount;
    var rewriteExceptionType = Type.typeFor(RewriteException.class);
    // Store the RewriteException into an unused local variable slot.
    method.load(rewriteExceptionType, 0);
    method.storeTemp(rewriteExceptionType, lvarCount);
    // Get local variable array
    method.load(rewriteExceptionType, 0);
    method.invoke(RewriteException.GET_BYTECODE_SLOTS);
    // Store local variables.
    // Note that deoptimization might introduce new value types for existing local variables, so we must use both liveLocals and symbolBoundary, as in some cases (when the continuation is inside of a try block) we need to store the incoming value into multiple slots.
    // The optimism exception handlers will have exactly one array element for every symbol that uses bytecode storage.
    // If in the originating method the value was undefined, there will be an explicit Undefined value in the array.
    var arrayIndex = 0;
    for (var lvarIndex = 0; lvarIndex < lvarCount;) {
      var lvarType = lvarTypes.get(lvarIndex);
      if (!lvarType.isUnknown()) {
        method.dup();
        method.load(arrayIndex).arrayload();
        var typeClass = lvarType.getTypeClass();
        // Deoptimization in array initializers can cause arrays to undergo component type widening
        if (typeClass == long[].class) {
          method.load(rewriteExceptionType, lvarCount);
          method.invoke(RewriteException.TO_LONG_ARRAY);
        } else if (typeClass == double[].class) {
          method.load(rewriteExceptionType, lvarCount);
          method.invoke(RewriteException.TO_DOUBLE_ARRAY);
        } else if (typeClass == Object[].class) {
          method.load(rewriteExceptionType, lvarCount);
          method.invoke(RewriteException.TO_OBJECT_ARRAY);
        } else {
          if (!(typeClass.isPrimitive() || typeClass == Object.class)) {
            // NOTE: this can only happen with dead stores.
            // E.g. for the program "1; []; f();" in which the call to f() will deoptimize the call site, but it'll expect :return to have the type NativeArray.
            // However, in the more optimal version, :return's only live type is int, therefore "{O}:return = []" is a dead store, and the variable will be sent into the continuation as Undefined, however NativeArray can't hold Undefined instance.
            method.loadType(Type.getInternalName(typeClass));
            method.invoke(RewriteException.INSTANCE_OR_NULL);
          }
          method.convert(lvarType);
        }
        method.storeHidden(lvarType, lvarIndex, false);
      }
      var nextLvarIndex = lvarIndex + lvarType.getSlots();
      if (symbolBoundary.get(nextLvarIndex - 1)) {
        ++arrayIndex;
      }
      lvarIndex = nextLvarIndex;
    }
    if (AssertsEnabled.assertsEnabled()) {
      method.load(arrayIndex);
      method.invoke(RewriteException.ASSERT_ARRAY_LENGTH);
    } else {
      method.pop();
    }
    var stackStoreSpec = ci.getStackStoreSpec();
    var stackTypes = ci.getStackTypes();
    var isStackEmpty = stackStoreSpec.length == 0;
    var replacedObjectLiteralMaps = 0;
    if (!isStackEmpty) {
      // Load arguments on the stack
      for (var i = 0; i < stackStoreSpec.length; ++i) {
        var slot = stackStoreSpec[i];
        method.load(lvarTypes.get(slot), slot);
        method.convert(stackTypes[i]);
        // stack: s0=object literal being initialized
        // change map of s0 so that the property we are initializing when we failed is now ci.returnValueType
        var map = ci.getObjectLiteralMap(i);
        if (map != null) {
          method.dup();
          assert ScriptObject.class.isAssignableFrom(method.peekType().getTypeClass()) : method.peekType().getTypeClass() + " is not a script object";
          loadConstant(map);
          method.invoke(ScriptObject.SET_MAP);
          replacedObjectLiteralMaps++;
        }
      }
    }
    // Must have emitted the code for replacing all object literal maps
    assert ci.objectLiteralMaps == null || ci.objectLiteralMaps.size() == replacedObjectLiteralMaps;
    // Load RewriteException back.
    method.load(rewriteExceptionType, lvarCount);
    // Get rid of the stored reference
    method.loadNull();
    method.storeHidden(Type.OBJECT, lvarCount);
    // Mark it dead
    method.markDeadSlots(lvarCount, Type.OBJECT.getSlots());
    // Load return value on the stack
    method.invoke(RewriteException.GET_RETURN_VALUE);
    var returnValueType = ci.getReturnValueType();
    // Set up an exception handler for primitive type conversion of return value if needed
    var needsCatch = false;
    var targetCatchLabel = ci.catchLabel;
    Label tryBegin = null;
    if (returnValueType.isPrimitive()) {
      // If the conversion throws an exception, we want to report the line number of the continuation point.
      // method.lineNumber(ci.lineNumber);
      if (targetCatchLabel != METHOD_BOUNDARY) {
        tryBegin = new Label("");
        method.label(tryBegin);
        needsCatch = true;
      }
    }
    // Convert return value
    method.convert(returnValueType);
    var scopePopCount = needsCatch ? ci.exceptionScopePops : 0;
    // Declare a try/catch for the conversion.
    // If no scopes need to be popped until the target catch block, just jump into it. Otherwise, we'll need to create a scope-popping catch block below.
    var catchLabel = scopePopCount > 0 ? new Label("") : targetCatchLabel;
    if (needsCatch) {
      var tryEnd = new Label("");
      method.label(tryEnd);
      method.try_(tryBegin, tryEnd, catchLabel);
    }
    // Jump to continuation point
    method.goto_(ci.getTargetLabel());
    // Make a scope-popping exception delegate if needed
    if (catchLabel != targetCatchLabel) {
      // method.lineNumber(0);
      assert scopePopCount > 0;
      method.catch_(catchLabel);
      popScopes(scopePopCount);
      method.uncheckedGoto(targetCatchLabel);
    }
  }

  /**
   * Interface implemented by object creators that support splitting over multiple methods.
   */
  interface SplitLiteralCreator {

    /**
     * Generate code to populate a range of the literal object.
     * A reference to the object should be left on the stack when the method terminates.
     *
     * @param method the method emitter
     * @param type the type of the literal object
     * @param slot the local slot containing the literal object
     * @param start the start index (inclusive)
     * @param end the end index (exclusive)
     */
    void populateRange(MethodEmitter method, Type type, int slot, int start, int end);
  }

}
