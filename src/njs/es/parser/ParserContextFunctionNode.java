package es.parser;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import es.codegen.Namespace;
import es.ir.Expression;
import es.ir.FunctionNode;
import es.ir.IdentNode;
import es.ir.Module;

/**
 * ParserContextNode that represents a function that is currently being parsed
 */
class ParserContextFunctionNode extends ParserContextBaseNode {

  // Function name
  private final String name;

  // Function identifier node
  private final IdentNode ident;

  // Name space for function
  private final Namespace namespace;

  // Line number for function declaration
  private final int line;

  // Function node kind, see {@link FunctionNode.Kind}
  private final FunctionNode.Kind kind;

  // List of parameter identifiers for function
  private List<IdentNode> parameters;

  // Token for function start
  private final long token;

  // Last function token
  private long lastToken;

  // Opaque node for parser end state, see {@link Parser}
  private Object endParserState;

  private HashSet<String> parameterBoundNames;
  private IdentNode duplicateParameterBinding;
  private boolean simpleParameterList = true;

  private Module module;

  private int debugFlags;
  private Map<IdentNode, Expression> parameterExpressions;

  /**
   * @param token The token for the function
   * @param ident External function name
   * @param name  Internal name of the function
   * @param namespace Function's namespace
   * @param line  The source line of the function
   * @param kind  Function kind
   * @param parameters The parameters of the function
   */
  public ParserContextFunctionNode(long token, IdentNode ident, String name, Namespace namespace, int line, FunctionNode.Kind kind, List<IdentNode> parameters) {
    this.ident = ident;
    this.namespace = namespace;
    this.line = line;
    this.kind = kind;
    this.name = name;
    this.parameters = parameters;
    this.token = token;
  }

  /** @return Internal name of the function */
  public String getName() {
    return name;
  }

  /** @return The external identifier for the function */
  public IdentNode getIdent() {
    return ident;
  }

  /** @return true if function is the program function */
  public boolean isProgram() {
    return getFlag(FunctionNode.IS_PROGRAM) != 0;
  }

  /** @return true if the function has nested evals */
  public boolean hasNestedEval() {
    return getFlag(FunctionNode.HAS_NESTED_EVAL) != 0;
  }

  /** @return true if any of the blocks in this function create their own scope. */
  public boolean hasScopeBlock() {
    return getFlag(FunctionNode.HAS_SCOPE_BLOCK) != 0;
  }

  /**
   * Create a unique name in the namespace of this FunctionNode
   *
   * @param base prefix for name
   * @return base if no collision exists, otherwise a name prefix with base
   */
  public String uniqueName(String base) {
    return namespace.uniqueName(base);
  }

  /** @return line number of the function */
  public int getLineNumber() {
    return line;
  }

  /** @return The kind if function */
  public FunctionNode.Kind getKind() {
    return kind;
  }

  /** @return The parameters of the function */
  public List<IdentNode> getParameters() {
    return parameters;
  }

  void setParameters(List<IdentNode> parameters) {
    this.parameters = parameters;
  }

  /** @return ES6 function parameter expressions */
  public Map<IdentNode, Expression> getParameterExpressions() {
    return parameterExpressions;
  }

  void addParameterExpression(IdentNode ident, Expression node) {
    if (parameterExpressions == null) {
      parameterExpressions = new HashMap<>();
    }
    parameterExpressions.put(ident, node);
  }

  /**
   * Set last token
   * @param token New last token
   */
  public void setLastToken(long token) {
    this.lastToken = token;
  }

  /** @return lastToken Function's last token */
  public long getLastToken() {
    return lastToken;
  }

  /**
   * Returns the ParserState of when the parsing of this function was ended
   * @return endParserState The end parser state
   */
  public Object getEndParserState() {
    return endParserState;
  }

  /**
   * Sets the ParserState of when the parsing of this function was ended
   * @param endParserState The end parser state
   */
  public void setEndParserState(Object endParserState) {
    this.endParserState = endParserState;
  }

  /**
   * Returns the if of this function
   * @return The function id
   */
  public int getId() {
    return isProgram() ? -1 : Token.descPosition(token);
  }

  /**
   * Returns the debug flags for this function.
   * @return the debug flags
   */
  int getDebugFlags() {
    return debugFlags;
  }

  /**
   * Sets a debug flag for this function.
   * @param debugFlag the debug flag
   */
  void setDebugFlag(int debugFlag) {
    debugFlags |= debugFlag;
  }

  public boolean isMethod() {
    return getFlag(FunctionNode.IS_METHOD) != 0;
  }

  public boolean isClassConstructor() {
    return getFlag(FunctionNode.IS_CLASS_CONSTRUCTOR) != 0;
  }

  public boolean isSubclassConstructor() {
    return getFlag(FunctionNode.IS_SUBCLASS_CONSTRUCTOR) != 0;
  }

  boolean addParameterBinding(IdentNode bindingIdentifier) {
    if (Parser.isArguments(bindingIdentifier)) {
      setFlag(FunctionNode.DEFINES_ARGUMENTS);
    }

    if (parameterBoundNames == null) {
      parameterBoundNames = new HashSet<>();
    }
    if (parameterBoundNames.add(bindingIdentifier.getName())) {
      return true;
    } else {
      duplicateParameterBinding = bindingIdentifier;
      return false;
    }
  }

  public IdentNode getDuplicateParameterBinding() {
    return duplicateParameterBinding;
  }

  public boolean isSimpleParameterList() {
    return simpleParameterList;
  }

  public void setSimpleParameterList(boolean simpleParameterList) {
    this.simpleParameterList = simpleParameterList;
  }

  public Module getModule() {
    return module;
  }

  public void setModule(Module module) {
    this.module = module;
  }

}
