package es.ir;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import es.codegen.CompileUnit;
import es.codegen.Compiler;
import es.codegen.CompilerConstants;
import es.codegen.Namespace;
import es.codegen.types.Type;
import es.ir.annotations.Ignore;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;
import es.parser.Token;
import es.runtime.RecompilableScriptFunctionData;
import es.runtime.ScriptFunction;
import es.runtime.Source;
import es.runtime.UserAccessorProperty;
import es.runtime.linker.LinkerCallSite;

/**
 * IR representation for function (or script.)
 */
@Immutable
public final class FunctionNode extends LexicalContextExpression implements Flags<FunctionNode>, CompileUnitHolder {

  /** Type used for all FunctionNodes */
  public static final Type FUNCTION_TYPE = Type.typeFor(ScriptFunction.class);

  /** Function kinds */
  public enum Kind {
    /** a normal function - nothing special */
    NORMAL,
    /** a script function */
    SCRIPT,
    /** a getter, @see {@link UserAccessorProperty} */
    GETTER,
    /** a setter, @see {@link UserAccessorProperty} */
    SETTER,
    /** an arrow function */
    ARROW,
    /** a generator function */
    GENERATOR,
    /** a module function */
    MODULE
  }

  // Source of entity.
  private transient final Source source;

  // Opaque object representing parser state at the end of the function.
  // Used when reparsing outer functions to skip parsing inner functions.
  private final Object endParserState;

  // External function identifier.
  @Ignore
  private final IdentNode ident;

  // The body of the function node
  private final Block body;

  // Internal function name.
  private final String name;

  // Compilation unit.
  private final CompileUnit compileUnit;

  // Function kind.
  private final Kind kind;

  // List of parameters.
  private final List<IdentNode> parameters;

  // Map of ES6 function parameter expressions.
  private final Map<IdentNode, Expression> parameterExpressions;

  // First token of function.
  private final long firstToken;

  // Last token of function.
  private final long lastToken;

  // Method's namespace.
  private transient final Namespace namespace;

  // Number of properties of "this" object assigned in this function
  @Ignore
  private final int thisProperties;

  // Function flags.
  private final int flags;

  // Line number of function start
  private final int lineNumber;

  // Root class for function
  private final Class<?> rootClass;

  // The ES6 module
  private final Module module;

  /** Is anonymous function flag. */
  public static final int IS_ANONYMOUS = 1 << 0;

  /** Is the function created in a function declaration (as opposed to a function expression) */
  public static final int IS_DECLARED = 1 << 1;

  /** Does the function use the "arguments" identifier ? */
  public static final int USES_ARGUMENTS = 1 << 3;

  /** Has this function been split because it was too large? */
  public static final int IS_SPLIT = 1 << 4;

  /**
   * Does the function call eval?
   * If it does, then all variables in this function might be get/set by it
   * and it can introduce new variables into this function's scope too.
   */
  public static final int HAS_EVAL = 1 << 5;

  /**
   * Does a nested function contain eval?
   * If it does, then all variables in this function might be get/set by it.
   */
  public static final int HAS_NESTED_EVAL = 1 << 6;

  /**
   * Does this function have any blocks that create a scope?
   * This is used to determine if the function needs to have a local variable slot for the scope symbol.
   */
  public static final int HAS_SCOPE_BLOCK = 1 << 7;

  /**
   * Flag this function as one that defines the identifier "arguments" as a function parameter or nested function name.
   * This precludes it from needing to have an Arguments object defined as "arguments" local variable.
   * Note that defining a local variable named "arguments" still requires construction of the Arguments object
   * (see ECMAScript 5.1 Chapter 10.5).
   * @see #needsArguments()
   */
  public static final int DEFINES_ARGUMENTS = 1 << 8;

  /** Does this function or any of its descendants use variables from an ancestor function's scope (incl. globals)? */
  public static final int USES_ANCESTOR_SCOPE = 1 << 9;

  /** Does this function have nested declarations? */
  public static final int HAS_FUNCTION_DECLARATIONS = 1 << 10;

  /** Does this function have optimistic expressions? (If it does, it can undergo deoptimizing recompilation.) */
  public static final int IS_DEOPTIMIZABLE = 1 << 11;

  /** Are we vararg, but do we just pass the arguments along to apply or call */
  public static final int HAS_APPLY_TO_CALL_SPECIALIZATION = 1 << 12;

  /** Is this function the top-level program? */
  public static final int IS_PROGRAM = 1 << 13;

  /**
   * Flag indicating whether this function uses the local variable symbol for itself.
   * Only named function expressions can have this flag set if they reference themselves (e.g. "(function f() { return f })".
   * Declared functions will use the symbol in their parent scope instead when they reference themselves by name.
   */
  public static final int USES_SELF_SYMBOL = 1 << 14;

  /** Does this function use the "this" keyword? */
  public static final int USES_THIS = 1 << 15;

  /** Is this declared in a dynamic context */
  public static final int IN_DYNAMIC_CONTEXT = 1 << 16;

  /**
   * Whether this function needs the callee {@link ScriptFunction} instance passed to its code as a parameter on invocation.
   * Note that we aren't, in fact using this flag in function nodes.
   * Rather, it is always calculated (see {@link #needsCallee()}).
   * {@link RecompilableScriptFunctionData} will, however, cache the value of this flag.
   */
  public static final int NEEDS_CALLEE = 1 << 17;

  /** Is the function node cached? */
  public static final int IS_CACHED = 1 << 18;

  /**
   * Does this function contain a super call?
   * (cf. ES6 14.3.5 Static Semantics: HasDirectSuper)
   */
  public static final int HAS_DIRECT_SUPER = 1 << 19;

  /** Does this function use the super binding? */
  public static final int USES_SUPER = 1 << 20;

  /** Is this function a (class or object) method? */
  public static final int IS_METHOD = 1 << 21;

  /** Is this the constructor method? */
  public static final int IS_CLASS_CONSTRUCTOR = 1 << 22;

  /** Is this the constructor of a subclass (i.e., a class with an extends declaration)? */
  public static final int IS_SUBCLASS_CONSTRUCTOR = 1 << 23;

  /** is this a strong mode function? */
  public static final int IS_STRONG = 1 << 24;

  /** Does this function use new.target? */
  public static final int USES_NEW_TARGET = 1 << 25;

  /** Does this function have expression as its body? */
  public static final int HAS_EXPRESSION_BODY = 1 << 26;

  /** Does this function or any nested functions contain an eval? */
  private static final int HAS_DEEP_EVAL = HAS_EVAL | HAS_NESTED_EVAL;

  /** Does this function need to store all its variables in scope? */
  public static final int HAS_ALL_VARS_IN_SCOPE = HAS_DEEP_EVAL;

  /** Does this function potentially need "arguments"? Note that this is not a full test, as further negative check of REDEFINES_ARGS is needed. */
  private static final int MAYBE_NEEDS_ARGUMENTS = USES_ARGUMENTS | HAS_EVAL;

  /** Does this function need the parent scope? It needs it if either it or its descendants use variables from it, or have a deep eval, or it's the program. */
  public static final int NEEDS_PARENT_SCOPE = USES_ANCESTOR_SCOPE | HAS_DEEP_EVAL | IS_PROGRAM;

  /** What is the return type of this function? */
  public Type returnType = Type.UNKNOWN;

  /**
   * Constructor
   *
   * @param source     the source
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param firstToken first token of the function node (including the function declaration)
   * @param lastToken  lastToken
   * @param namespace  the namespace
   * @param ident      the identifier
   * @param name       the name of the function
   * @param parameters parameter list
   * @param paramExprs the ES6 function parameter expressions
   * @param kind       kind of function as in {@link FunctionNode.Kind}
   * @param flags      initial flags
   * @param body       body of the function
   * @param endParserState The parser state at the end of the parsing.
   * @param module     the module
   */
  public FunctionNode(Source source, int lineNumber, long token, int finish, long firstToken, long lastToken, Namespace namespace, IdentNode ident, String name, List<IdentNode> parameters, Map<IdentNode, Expression> paramExprs, FunctionNode.Kind kind, int flags, Block body, Object endParserState, Module module) {
    super(token, finish);
    this.source = source;
    this.lineNumber = lineNumber;
    this.ident = ident;
    this.name = name;
    this.kind = kind;
    this.parameters = parameters;
    this.parameterExpressions = paramExprs;
    this.firstToken = firstToken;
    this.lastToken = lastToken;
    this.namespace = namespace;
    this.flags = flags;
    this.compileUnit = null;
    this.body = body;
    this.thisProperties = 0;
    this.rootClass = null;
    this.endParserState = endParserState;
    this.module = module;
  }

  FunctionNode(FunctionNode functionNode, long lastToken, Object endParserState, int flags, String name, Type returnType, CompileUnit compileUnit, Block body, List<IdentNode> parameters, int thisProperties, Class<?> rootClass, Source source, Namespace namespace) {
    super(functionNode);
    this.endParserState = endParserState;
    this.lineNumber = functionNode.lineNumber;
    this.flags = flags;
    this.name = name;
    this.returnType = returnType;
    this.compileUnit = compileUnit;
    this.lastToken = lastToken;
    this.body = body;
    this.parameters = parameters;
    this.parameterExpressions = functionNode.parameterExpressions;
    this.thisProperties = thisProperties;
    this.rootClass = rootClass;
    this.source = source;
    this.namespace = namespace;
    // the fields below never change - they are final and assigned in constructor
    this.ident = functionNode.ident;
    this.kind = functionNode.kind;
    this.firstToken = functionNode.firstToken;
    this.module = functionNode.module;
  }

  @Override
  public Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterFunctionNode(this)) ? visitor.leaveFunctionNode(setBody(lc, (Block) body.accept(visitor))) : this;
  }

  /**
   * Visits the parameter nodes of this function.
   * Parameters are normally not visited automatically.
   * @param visitor the visitor to apply to the nodes.
   * @return a list of parameter nodes, potentially modified from original ones by the visitor.
   */
  public List<IdentNode> visitParameters(NodeVisitor<? extends LexicalContext> visitor) {
    return Node.accept(visitor, parameters);
  }

  /**
   * Get additional callsite flags to be used specific to this function.
   * @return callsite flags
   */
  public int getCallSiteFlags() {
    return 0; // none for now
  }

  /**
   * Get the source for this function
   * @return the source
   */
  public Source getSource() {
    return source;
  }

  /**
   * Sets the source and namespace for this function.
   * It can only set a non-null source and namespace for a function that currently has both a null source and a null namespace.
   * This is used to re-set the source and namespace for a deserialized function node.
   * @param source the source for the function.
   * @param namespace the namespace for the function
   * @return a new function node with the set source and namespace
   * @throws IllegalArgumentException if the specified source or namespace is null
   * @throws IllegalStateException if the function already has either a source or namespace set.
   */
  public FunctionNode initializeDeserialized(Source source, Namespace namespace) {
    if (source == null || namespace == null) {
      throw new IllegalArgumentException();
    } else if (this.source == source && this.namespace == namespace) {
      return this;
    } else if (this.source != null || this.namespace != null) {
      throw new IllegalStateException();
    }
    return new FunctionNode(this, lastToken, endParserState, flags, name, returnType, compileUnit, body, parameters, thisProperties, rootClass, source, namespace);
  }

  /**
   * Get the unique ID for this function within the script file.
   * @return the id
   */
  public int getId() {
    return isProgram() ? -1 : Token.descPosition(firstToken);
  }

  /**
   * get source name - sourceURL or name derived from Source.
   * @return name for the script source
   */
  public String getSourceName() {
    return getSourceName(source);
  }

  /**
   * Static source name getter
   * @param source the source
   * @return source name
   */
  public static String getSourceName(Source source) {
    var explicitURL = source.getExplicitURL();
    return explicitURL != null ? explicitURL : source.getName();
  }

  /**
   * Returns the line number.
   * @return the line number.
   */
  public int getLineNumber() {
    return lineNumber;
  }

  /**
   * Create a unique name in the namespace of this FunctionNode
   * @param base prefix for name
   * @return base if no collision exists, otherwise a name prefix with base
   */
  public String uniqueName(String base) {
    return namespace.uniqueName(base);
  }

  @Override
  public void toString(StringBuilder sb, boolean printTypes) {
    sb.append('[')
      .append(returnType)
      .append(']')
      .append(' ');
    sb.append("function");
    if (ident != null) {
      sb.append(' ');
      ident.toString(sb, printTypes);
    }
    sb.append('(');
    for (var iter = parameters.iterator(); iter.hasNext();) {
      var parameter = iter.next();
      if (parameter.getSymbol() != null) {
        sb.append('[').append(parameter.getType()).append(']').append(' ');
      }
      parameter.toString(sb, printTypes);
      if (iter.hasNext()) {
        sb.append(", ");
      }
    }
    sb.append(')');
  }

  @Override
  public int getFlags() {
    return flags;
  }

  @Override
  public boolean getFlag(int flag) {
    return (flags & flag) != 0;
  }

  @Override
  public FunctionNode setFlags(LexicalContext lc, int flags) {
    return (this.flags == flags) ? this : Node.replaceInLexicalContext(lc, this,
      new FunctionNode(this, lastToken, endParserState, flags, name, returnType, compileUnit, body, parameters, thisProperties, rootClass, source, namespace));
  }

  @Override
  public FunctionNode clearFlag(LexicalContext lc, int flag) {
    return setFlags(lc, flags & ~flag);
  }

  @Override
  public FunctionNode setFlag(LexicalContext lc, int flag) {
    return setFlags(lc, flags | flag);
  }

  /**
   * Returns true if the function is the top-level program.
   * @return True if this function node represents the top-level program.
   */
  public boolean isProgram() {
    return getFlag(IS_PROGRAM);
  }

  /**
   * Returns true if the function contains at least one optimistic operation (and thus can be deoptimized).
   * @return true if the function contains at least one optimistic operation (and thus can be deoptimized).
   */
  public boolean canBeDeoptimized() {
    return getFlag(IS_DEOPTIMIZABLE);
  }

  /**
   * Check if this function has a call expression for the identifier "eval" (that is, {@code eval(...)}).
   *
   * @return true if {@code eval} is called.
   */
  public boolean hasEval() {
    return getFlag(HAS_EVAL);
  }

  /**
   * Returns true if a function nested (directly or transitively) within this function {@link #hasEval()}.
   *
   * @return true if a nested function calls {@code eval}.
   */
  public boolean hasNestedEval() {
    return getFlag(HAS_NESTED_EVAL);
  }

  /**
   * Get the first token for this function
   * @return the first token
   */
  public long getFirstToken() {
    return firstToken;
  }

  /**
   * Check whether this function has nested function declarations
   * @return true if nested function declarations exist
   */
  public boolean hasDeclaredFunctions() {
    return getFlag(HAS_FUNCTION_DECLARATIONS);
  }

  /**
   * Check if this function's generated Java method needs a {@code callee} parameter.
   *
   * Functions that need access to their parent scope, functions that reference themselves,
   * and non-strict functions that need an Arguments object (since it exposes {@code arguments.callee} property) will need to have a callee parameter.
   * We also return true for split functions to make sure symbols slots are the same in the main and split methods.
   *
   * A function that has had an apply(this,arguments) turned into a call doesn't need arguments anymore, but still
   * has to fit the old callsite, thus, we require a dummy callee parameter for those functions as well
   *
   * @return true if the function's generated Java method needs a {@code callee} parameter.
   */
  public boolean needsCallee() {
    // NOTE: we only need isSplit() here to ensure that :scope can never drop below slot 2 for splitting array units.
    return needsParentScope() || usesSelfSymbol() || isSplit();
  }

  /**
   * Return {@code true} if this function makes use of the {@code this} object.
   * @return true if function uses {@code this} object
   */
  public boolean usesThis() {
    return getFlag(USES_THIS);
  }

  /**
   * Return true if function contains an apply to call transform
   * @return true if this function has transformed apply to call
   */
  public boolean hasApplyToCallSpecialization() {
    return getFlag(HAS_APPLY_TO_CALL_SPECIALIZATION);
  }

  /**
   * Get the identifier for this function, this is its symbol.
   * @return the identifier as an IdentityNode
   */
  public IdentNode getIdent() {
    return ident;
  }

  /**
   * Get the function body
   * @return the function body
   */
  public Block getBody() {
    return body;
  }

  /**
   * Reset the function body
   * @param lc lexical context
   * @param body new body
   * @return new function node if body changed, same if not
   */
  public FunctionNode setBody(LexicalContext lc, Block body) {
    return (this.body == body) ? this : Node.replaceInLexicalContext(lc, this,
      new FunctionNode(this, lastToken, endParserState, flags | (body.needsScope() ? FunctionNode.HAS_SCOPE_BLOCK : 0), name, returnType, compileUnit, body, parameters, thisProperties, rootClass, source, namespace));
  }

  /**
   * Does this function's method needs to be variable arity (gather all script-declared parameters in a final {@code Object[]} parameter.
   * Functions that need to have the "arguments" object as well as functions that simply declare too many arguments for JVM to handle with fixed arity will need to be variable arity.
   * @return true if the Java method in the generated code that implements this function needs to be variable arity.
   * @see #needsArguments()
   * @see LinkerCallSite#ARGLIMIT
   */
  public boolean isVarArg() {
    return needsArguments() || parameters.size() > LinkerCallSite.ARGLIMIT;
  }

  /**
   * Was this function declared in a dynamic context, i.e. in a with or eval style chain
   * @return true if in dynamic context
   */
  public boolean inDynamicContext() {
    return getFlag(IN_DYNAMIC_CONTEXT);
  }

  /**
   * Flag this function as declared in a dynamic context
   * @param lc lexical context
   * @return new function node, or same if unmodified
   */
  public FunctionNode setInDynamicContext(LexicalContext lc) {
    return setFlag(lc, IN_DYNAMIC_CONTEXT);
  }

  /**
   * Returns true if this function needs to have an Arguments object defined as a local variable named "arguments".
   * Functions that use "arguments" as identifier and don't define it as a name of a parameter or a nested function (see ECMAScript 5.1 Chapter 10.5),
   * as well as any function that uses eval or with, or has a nested function that does the same, will have an "arguments" object.
   * Also, if this function is a script, it will not have an "arguments" object, because it does not have local variables;
   * rather the Global object will have an explicit "arguments" property that provides command-line arguments for the script.
   * @return true if this function needs an arguments object.
   */
  public boolean needsArguments() {
    // uses "arguments" or calls eval, but it does not redefine "arguments",
    // and finally, it's not a script, since for top-level script, "arguments" is picked up from Context by Global.init() instead.
    return getFlag(MAYBE_NEEDS_ARGUMENTS) && !getFlag(DEFINES_ARGUMENTS) && !isProgram();
  }

  /**
   * Returns true if this function needs access to its parent scope.
   * Functions referencing variables outside their scope (including global variables), as well as functions that call eval or have a with block, or have nested functions that call eval or have a with block, will need a parent scope.
   * Top-level script functions also need a parent scope since they might be used from within eval, and eval will need an externally passed scope.
   * @return true if the function needs parent scope.
   */
  public boolean needsParentScope() {
    return getFlag(NEEDS_PARENT_SCOPE);
  }

  /**
   * Set the number of properties assigned to the this object in this function.
   * @param lc the current lexical context.
   * @param thisProperties number of properties
   * @return a potentially modified function node
   */
  public FunctionNode setThisProperties(LexicalContext lc, int thisProperties) {
    return (this.thisProperties == thisProperties) ? this : Node.replaceInLexicalContext(lc, this,
      new FunctionNode(this, lastToken, endParserState, flags, name, returnType, compileUnit, body, parameters, thisProperties, rootClass, source, namespace));
  }

  /**
   * Get the number of properties assigned to the this object in this function.
   * @return number of properties
   */
  public int getThisProperties() {
    return thisProperties;
  }

  /**
   * Returns true if any of the blocks in this function create their own scope.
   * @return true if any of the blocks in this function create their own scope.
   */
  public boolean hasScopeBlock() {
    return getFlag(HAS_SCOPE_BLOCK);
  }

  /**
   * Return the kind of this function
   * @see FunctionNode.Kind
   * @return the kind
   */
  public Kind getKind() {
    return kind;
  }

  /**
   * Return the last token for this function's code
   * @return last token
   */
  public long getLastToken() {
    return lastToken;
  }

  /**
   * Returns the end parser state for this function.
   * @return the end parser state for this function.
   */
  public Object getEndParserState() {
    return endParserState;
  }

  /**
   * Get the name of this function
   * @return the name
   */
  public String getName() {
    return name;
  }

  /**
   * Set the internal name for this function
   * @param lc    lexical context
   * @param name new name
   * @return new function node if changed, otherwise the same
   */
  public FunctionNode setName(LexicalContext lc, String name) {
    return (this.name.equals(name)) ? this : Node.replaceInLexicalContext(lc, this,
      new FunctionNode(this, lastToken, endParserState, flags, name, returnType, compileUnit, body, parameters, thisProperties, rootClass, source, namespace));
  }

  /**
   * Check if this function should have all its variables in its own scope. Split sub-functions, and
   * functions having with and/or eval blocks are such.
   *
   * @return true if all variables should be in scope
   */
  public boolean allVarsInScope() {
    return getFlag(HAS_ALL_VARS_IN_SCOPE);
  }

  /**
   * Checks if this function is split into several smaller fragments.
   *
   * @return true if this function is split into several smaller fragments.
   */
  public boolean isSplit() {
    return getFlag(IS_SPLIT);
  }

  /**
   * Get the parameters to this function
   * @return a list of IdentNodes which represent the function parameters, in order
   */
  public List<IdentNode> getParameters() {
    return Collections.unmodifiableList(parameters);
  }

  /**
   * Get the ES6 style parameter expressions of this function. This may be null.
   *
   * @return a Map of parameter IdentNode to Expression node (for ES6 parameter expressions)
   */
  public Map<IdentNode, Expression> getParameterExpressions() {
    return parameterExpressions;
  }

  /**
   * Return the number of parameters to this function
   * @return the number of parameters
   */
  public int getNumOfParams() {
    return parameters.size();
  }

  /**
   * Returns the identifier for a named parameter at the specified position in this function's parameter list.
   * @param index the parameter's position.
   * @return the identifier for the requested named parameter.
   * @throws IndexOutOfBoundsException if the index is invalid.
   */
  public IdentNode getParameter(int index) {
    return parameters.get(index);
  }

  /**
   * Reset the compile unit used to compile this function
   * @see Compiler
   * @param  lc lexical context
   * @param  parameters the compile unit
   * @return function node or a new one if state was changed
   */
  public FunctionNode setParameters(LexicalContext lc, List<IdentNode> parameters) {
    return (this.parameters == parameters) ? this : Node.replaceInLexicalContext(lc, this,
      new FunctionNode(this, lastToken, endParserState, flags, name, returnType, compileUnit, body, parameters, thisProperties, rootClass, source, namespace));
  }

  /**
   * Check if this function is created as a function declaration (as opposed to function expression)
   * @return true if function is declared.
   */
  public boolean isDeclared() {
    return getFlag(IS_DECLARED);
  }

  /**
   * Check if this function is anonymous
   * @return true if function is anonymous
   */
  public boolean isAnonymous() {
    return getFlag(IS_ANONYMOUS);
  }

  /**
   * Does this function use its self symbol - this is needed only for self-referencing named function expressions.
   * Self-referencing declared functions won't have this flag set,
   * as they can access their own symbol through the scope (since they're bound to the symbol with their name in their enclosing scope).
   * @return true if this function node is a named function expression that uses the symbol for itself.
   */
  public boolean usesSelfSymbol() {
    return getFlag(USES_SELF_SYMBOL);
  }

  /**
   * Returns true if this is a named function expression (that is, it isn't a declared function, it isn't an anonymous function expression, and it isn't a program).
   * @return true if this is a named function expression
   */
  public boolean isNamedFunctionExpression() {
    return !getFlag(IS_PROGRAM | IS_ANONYMOUS | IS_DECLARED);
  }

  @Override
  public Type getType() {
    return FUNCTION_TYPE;
  }

  @Override
  public Type getWidestOperationType() {
    return FUNCTION_TYPE;
  }

  /**
   * Get the return type for this function.
   * Return types can be specialized if the compiler knows them, but parameters cannot, as they need to go through appropriate object conversion
   * @return the return type
   */
  public Type getReturnType() {
    return returnType;
  }

  /**
   * Set the function return type
   * @param lc lexical context
   * @param returnType new return type
   * @return function node or a new one if state was changed
   */
  public FunctionNode setReturnType(LexicalContext lc, Type returnType) {
    // we never bother with object types narrower than objects, that will lead to byte code verification errors
    // as for instance even if we know we are returning a string from a method, the code generator will always treat it as an object, at least for now
    var type = returnType.isObject() ? Type.OBJECT : returnType;
    return (this.returnType == type) ? this : Node.replaceInLexicalContext(lc, this,
      new FunctionNode(this, lastToken, endParserState, flags, name, type, compileUnit, body, parameters, thisProperties, rootClass, source, namespace));
  }

  /**
   * Returns true if this function node has been cached.
   * @return true if this function node has been cached.
   */
  public boolean isCached() {
    return getFlag(IS_CACHED);
  }

  /**
   * Mark this function node as having been cached.
   * @param lc the current lexical context
   * @return a function node equivalent to this one, with the flag set.
   */
  public FunctionNode setCached(LexicalContext lc) {
    return setFlag(lc, IS_CACHED);
  }

  /**
   * Checks if the function is generated in strong mode.
   * @return true if strong mode enabled for function
   */
  public boolean isStrong() {
    return getFlag(IS_STRONG);
  }

  /**
   * Checks if this is an ES6 method.
   * @return true if the ES6 method flag is set
   */
  public boolean isMethod() {
    return getFlag(IS_METHOD);
  }

  /**
   * Checks if this function uses the ES6 super binding.
   * @return true if the ES6 super flag is set
   */
  public boolean usesSuper() {
    return getFlag(USES_SUPER);
  }

  /**
   * Checks if this function directly uses the super binding.
   * @return true if the ES6 has-direct-super flag is set
   */
  public boolean hasDirectSuper() {
    return getFlag(HAS_DIRECT_SUPER);
  }

  /**
   * Checks if this is an ES6 class constructor.
   * @return true if the ES6 class constructor flag is set
   */
  public boolean isClassConstructor() {
    return getFlag(IS_CLASS_CONSTRUCTOR);
  }

  /**
   * Checks if this is an ES6 subclass constructor.
   * @return true if the ES6 subclass constructor flag is set
   */
  public boolean isSubclassConstructor() {
    return getFlag(IS_SUBCLASS_CONSTRUCTOR);
  }

  /**
   * Checks if this function uses the ES6 new-targert.
   * @return true if the ES6 new-target flag is set
   */
  public boolean usesNewTarget() {
    return getFlag(USES_NEW_TARGET);
  }

  /**
   * Checks if this is an ES6 module.
   * @return true if this is an ES6 module
   */
  public boolean isModule() {
    return kind == Kind.MODULE;
  }

  /**
   * Returns the functions's ES6 module.
   * @return the module, or null if this function is not part of one
   */
  public Module getModule() {
    return module;
  }

  /**
   * Get the compile unit used to compile this function
   * @see Compiler
   * @return the compile unit
   */
  @Override
  public CompileUnit getCompileUnit() {
    return compileUnit;
  }

  /**
   * Reset the compile unit used to compile this function
   * @see Compiler
   * @param lc lexical context
   * @param compileUnit the compile unit
   * @return function node or a new one if state was changed
   */
  public FunctionNode setCompileUnit(LexicalContext lc, CompileUnit compileUnit) {
    return (this.compileUnit == compileUnit) ? this : Node.replaceInLexicalContext(lc, this,
      new FunctionNode(this, lastToken, endParserState, flags, name, returnType, compileUnit, body, parameters, thisProperties, rootClass, source, namespace));
  }

  /**
   * Get the symbol for a compiler constant, or null if not available (yet)
   * @param cc compiler constant
   * @return symbol for compiler constant, or null if not defined yet (for example in Lower)
   */
  public Symbol compilerConstant(CompilerConstants cc) {
    return body.getExistingSymbol(cc.symbolName());
  }

  /**
   * Get the root class that this function node compiles to
   * @return root class
   */
  public Class<?> getRootClass() {
    return rootClass;
  }

  /**
   * Reset the root class that this function is compiled to
   * @see Compiler
   * @param lc lexical context
   * @param rootClass root class
   * @return function node or a new one if state was changed
   */
  public FunctionNode setRootClass(LexicalContext lc, Class<?> rootClass) {
    return (this.rootClass == rootClass) ? this : Node.replaceInLexicalContext(lc, this,
      new FunctionNode(this, lastToken, endParserState, flags, name, returnType, compileUnit, body, parameters, thisProperties, rootClass, source, namespace));
  }

  private static final long serialVersionUID = 1;
}
