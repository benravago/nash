package es.parser;

import java.io.Serializable;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Deque;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.function.Consumer;

import es.codegen.CompilerConstants;
import es.codegen.Namespace;
import es.ir.AccessNode;
import es.ir.BaseNode;
import es.ir.BinaryNode;
import es.ir.Block;
import es.ir.BlockStatement;
import es.ir.BreakNode;
import es.ir.CallNode;
import es.ir.CaseNode;
import es.ir.CatchNode;
import es.ir.ClassNode;
import es.ir.ContinueNode;
import es.ir.DebuggerNode;
import es.ir.EmptyNode;
import es.ir.ErrorNode;
import es.ir.Expression;
import es.ir.ExpressionList;
import es.ir.ExpressionStatement;
import es.ir.ForNode;
import es.ir.FunctionNode;
import es.ir.IdentNode;
import es.ir.IfNode;
import es.ir.IndexNode;
import es.ir.JoinPredecessorExpression;
import es.ir.LabelNode;
import es.ir.LexicalContext;
import es.ir.LiteralNode;
import es.ir.Module;
import es.ir.Node;
import es.ir.ObjectNode;
import es.ir.PropertyKey;
import es.ir.PropertyNode;
import es.ir.ReturnNode;
import es.ir.RuntimeNode;
import es.ir.Statement;
import es.ir.SwitchNode;
import es.ir.TemplateLiteral;
import es.ir.TernaryNode;
import es.ir.ThrowNode;
import es.ir.TryNode;
import es.ir.UnaryNode;
import es.ir.VarNode;
import es.ir.WhileNode;
import es.ir.visitor.NodeVisitor;
import es.runtime.ErrorManager;
import es.runtime.JSErrorType;
import es.runtime.ParserException;
import es.runtime.RecompilableScriptFunctionData;
import es.runtime.ScriptEnvironment;
import es.runtime.ScriptFunctionData;
import es.runtime.ScriptingFunctions;
import es.runtime.Source;
import es.runtime.linker.NameCodec;
import static es.parser.TokenType.*;

/**
 * Builds the IR.
 */
public class Parser extends AbstractParser {

  private static final String ARGUMENTS_NAME = CompilerConstants.ARGUMENTS_VAR.symbolName();
  private static final String CONSTRUCTOR_NAME = "constructor";
  private static final String GET_NAME = "get";
  private static final String SET_NAME = "set";

  // Current env.
  private final ScriptEnvironment env;

  // syntax extension marker
  private final static boolean _syntax_extension_ = true;

  // Is scripting mode.
  private final boolean scripting;

  private List<Statement> functionDeclarations;

  private final ParserContext lc;
  private final Deque<Object> defaultNames;

  // Namespace for function names where not explicitly given
  private final Namespace namespace;

  // to receive line information from Lexer when scanning multine literals.
  final Lexer.LineInfoReceiver lineInfoReceiver;

  private RecompilableScriptFunctionData reparsedFunction;

  /**
   * Constructor
   *
   * @param env     script environment
   * @param source  source to parse
   * @param errors  error manager
   */
  public Parser(ScriptEnvironment env, Source source, ErrorManager errors) {
    this(env, source, errors, 0);
  }

  /**
   * Construct a parser.
   *
   * @param env     script environment
   * @param source  source to parse
   * @param errors  error manager
   * @param lineOffset line offset to start counting lines from
   */
  public Parser(ScriptEnvironment env, Source source, ErrorManager errors, int lineOffset) {
    super(source, errors, lineOffset);
    this.lc = new ParserContext();
    this.defaultNames = new ArrayDeque<>();
    this.env = env;
    this.namespace = new Namespace(env.getNamespace());
    this.scripting = env._scripting;
    if (this.scripting) {
      this.lineInfoReceiver = (receiverLine, receiverLinePosition) -> {
        // update the parser maintained line information
        Parser.this.line = receiverLine;
        Parser.this.linePosition = receiverLinePosition;
      };
    } else {
      // non-scripting mode script can't have multi-line literals
      this.lineInfoReceiver = null;
    }
  }

  /**
   * Sets the name for the first function.
   * This is only used when reparsing anonymous functions to ensure they can preserve their already assigned name, as that name doesn't appear in their source text.
   *
   * @param name the name for the first parsed function.
   */
  public void setFunctionName(String name) {
    defaultNames.push(createIdentNode(0, 0, name));
  }

  /**
   * Sets the {@link RecompilableScriptFunctionData} representing the function being reparsed (when this parser instance is used to reparse a previously parsed function, as part of its on-demand compilation).
   * This will trigger various special behaviors, such as skipping nested function bodies.
   *
   * @param reparsedFunction the function being reparsed.
   */
  public void setReparsedFunction(RecompilableScriptFunctionData reparsedFunction) {
    this.reparsedFunction = reparsedFunction;
  }

  /**
   * Execute parse and return the resulting function node.
   *
   * Errors will be thrown and the error manager will contain information if parsing should fail
   * This is the default parse call, which will name the function node {code :program} {@link CompilerConstants#PROGRAM}
   *
   * @return function node resulting from successful parse
   */
  public FunctionNode parse() {
    return parse(CompilerConstants.PROGRAM.symbolName(), 0, source.getLength(), 0);
  }

  /**
   * Set up first token. Skips opening EOL.
   */
  void scanFirstToken() {
    k = -1;
    NEXT();
  }

  /**
   * Execute parse and return the resulting function node.
   *
   * Errors will be thrown and the error manager will contain information if parsing should fail
   * This should be used to create one and only one function node
   *
   * @param scriptName name for the script, given to the parsed FunctionNode
   * @param startPos start position in source
   * @param len length of parse
   * @param reparseFlags flags provided by {@link RecompilableScriptFunctionData} as context for the code being reparsed.
   *    This allows us to recognize special forms of functions such as property getters and setters or instances of ES6 method shorthand in object literals.
   * @return function node resulting from successful parse
   */
  public FunctionNode parse(String scriptName, int startPos, int len, int reparseFlags) {
    // log.info(this, " begin for '", scriptName, "'");
    try {
      stream = new TokenStream();
      lexer = new Lexer(source, startPos, len, stream, scripting && _syntax_extension_, reparsedFunction != null);
      lexer.line = lexer.pendingLine = lineOffset + 1;
      line = lineOffset;
      scanFirstToken();
      // Begin parse.
      return program(scriptName, reparseFlags);
    } catch (Exception e) {
      handleParseException(e);
      return null;
    // } finally {
    //   log.info(this + " end '" + scriptName + "'");
    }
  }

  /**
   * Parse and return the resulting module.
   *
   * Errors will be thrown and the error manager will contain information if parsing should fail
   *
   * @param moduleName name for the module, given to the parsed FunctionNode
   * @param startPos start position in source
   * @param len length of parse
   * @return function node resulting from successful parse
   */
  public FunctionNode parseModule(String moduleName, int startPos, int len) {
    try {
      stream = new TokenStream();
      lexer = new Lexer(source, startPos, len, stream, scripting && _syntax_extension_, reparsedFunction != null);
      lexer.line = lexer.pendingLine = lineOffset + 1;
      line = lineOffset;
      scanFirstToken();
      // Begin parse.
      return module(moduleName);
    } catch (Exception e) {
      handleParseException(e);
      return null;
    }
  }

  /**
   * Entry point for parsing a module.
   *
   * @param moduleName the module name
   * @return the parsed module
   */
  public FunctionNode parseModule(String moduleName) {
    return parseModule(moduleName, 0, source.getLength());
  }

  /**
   * Parse and return the list of function parameter list.
   *
   * A comma separated list of function parameter identifiers is expected to be parsed.
   * Errors will be thrown and the error manager will contain information if parsing should fail.
   * This method is used to check if parameter Strings passed to "Function" constructor is a valid or not.
   *
   * @return the list of IdentNodes representing the formal parameter list
   */
  public List<IdentNode> parseFormalParameterList() {
    try {
      stream = new TokenStream();
      lexer = new Lexer(source, stream, scripting && _syntax_extension_);
      scanFirstToken();
      return formalParameterList(TokenType.EOF, false);
    } catch (Exception e) {
      handleParseException(e);
      return null;
    }
  }

  /**
   * Execute parse and return the resulting function node.
   *
   * Errors will be thrown and the error manager will contain information if parsing should fail.
   * This method is used to check if code String passed to "Function" constructor is a valid function body or not.
   *
   * @return function node resulting from successful parse
   */
  public FunctionNode parseFunctionBody() {
    try {
      stream = new TokenStream();
      lexer = new Lexer(source, stream, scripting && _syntax_extension_);
      var functionLine = line;
      scanFirstToken();
      // Make a fake token for the function.
      var functionToken = Token.toDesc(FUNCTION, 0, source.getLength());
      // Set up the function to append elements.
      var ident = new IdentNode(functionToken, Token.descPosition(functionToken), CompilerConstants.PROGRAM.symbolName());
      var function = createParserContextFunctionNode(ident, functionToken, FunctionNode.Kind.NORMAL, functionLine, Collections.<IdentNode>emptyList());
      lc.push(function);
      var body = newBlock();
      functionDeclarations = new ArrayList<>();
      sourceElements(0);
      addFunctionDeclarations(function);
      functionDeclarations = null;
      restoreBlock(body);
      body.setFlag(Block.NEEDS_SCOPE);
      var functionBody = new Block(functionToken, source.getLength() - 1, body.getFlags() | Block.IS_SYNTHETIC, body.getStatements());
      lc.pop(function);
      expect(EOF);
      return createFunctionNode(function, functionToken, ident, Collections.<IdentNode>emptyList(), FunctionNode.Kind.NORMAL, functionLine, functionBody);
    } catch (Exception e) {
      handleParseException(e);
      return null;
    }
  }

  void handleParseException(Exception e) {
    // Extract message from exception.  The message will be in error message format.
    var message = e.getMessage();
    // If empty message.
    if (message == null) {
      message = e.toString();
    }
    // Issue message.
    if (e instanceof ParserException pe) {
      errors.error(pe);
    } else {
      errors.error(message);
    }
  }

  /**
   * Skip to a good parsing recovery point.
   */
  void recover(Exception e) {
    if (e != null) {
      // Extract message from exception.  The message will be in error message format.
      var message = e.getMessage();
      // If empty message.
      if (message == null) {
        message = e.toString();
      }
      // Issue message.
      if (e instanceof ParserException pe) {
        errors.error(pe);
      } else {
        errors.error(message);
      }
    }

    // Skip to a recovery point.
    loop: for(;;) {
      switch (type) {
        case EOF -> {
          // Can not go any further.
          break loop;
        }
        case EOL, SEMICOLON, RBRACE -> {
          // Good recovery points.
          NEXT();
          break loop;
        }
        default -> {
          // So we can recover after EOL.
          NEXTorEOL();
        }
      }
    }
  }

  /**
   * Set up a new block.
   *
   * @return New block.
   */
  ParserContextBlockNode newBlock() {
    return lc.push(new ParserContextBlockNode(token));
  }

  ParserContextFunctionNode createParserContextFunctionNode(IdentNode ident, long functionToken, FunctionNode.Kind kind, int functionLine, List<IdentNode> parameters) {
    // Build function name.
    var sb = new StringBuilder();
    var parentFunction = lc.getCurrentFunction();
    if (parentFunction != null && !parentFunction.isProgram()) {
      sb.append(parentFunction.getName()).append(CompilerConstants.NESTED_FUNCTION_SEPARATOR.symbolName());
    }
    assert ident.getName() != null;
    sb.append(ident.getName());
    var name = namespace.uniqueName(sb.toString());
    assert parentFunction != null || kind == FunctionNode.Kind.MODULE || name.equals(CompilerConstants.PROGRAM.symbolName()) : "name = " + name;
    var flags = 0;
    if (parentFunction == null) {
      flags |= FunctionNode.IS_PROGRAM;
    }
    var functionNode = new ParserContextFunctionNode(functionToken, ident, name, namespace, functionLine, kind, parameters);
    functionNode.setFlag(flags);
    return functionNode;
  }

  FunctionNode createFunctionNode(ParserContextFunctionNode function, long startToken, IdentNode ident, List<IdentNode> parameters, FunctionNode.Kind kind, int functionLine, Block body) {
    // assert body.isFunctionBody() || body.getFlag(Block.IS_PARAMETER_BLOCK) && ((BlockStatement) body.getLastStatement()).getBlock().isFunctionBody();
    // Start new block.
    return new FunctionNode(source, functionLine, body.getToken(), Token.descPosition(body.getToken()), startToken, function.getLastToken(), namespace, ident, function.getName(), parameters, function.getParameterExpressions(), kind, function.getFlags(), body, function.getEndParserState(), function.getModule());
  }

  /**
   * Restore the current block.
   */
  ParserContextBlockNode restoreBlock(ParserContextBlockNode block) {
    return lc.pop(block);
  }

  /**
   * Get the statements in a block.
   * @return Block statements.
   */
  Block getBlock(boolean needsBraces) {
    var blockToken = token;
    var newBlock = newBlock();
    try {
      // Block opening brace.
      if (needsBraces) {
        expect(LBRACE);
      }
      // Accumulate block statements.
      statementList();
    } finally {
      restoreBlock(newBlock);
    }
    // Block closing brace.
    if (needsBraces) {
      expect(RBRACE);
    }
    var flags = newBlock.getFlags() | (needsBraces ? 0 : Block.IS_SYNTHETIC);
    return new Block(blockToken, finish, flags, newBlock.getStatements());
  }

  /**
   * Get all the statements generated by a single statement.
   * @return Statements.
   */
  Block getStatement() {
    return getStatement(false);
  }

  Block getStatement(boolean labelledStatement) {
    if (type == LBRACE) {
      return getBlock(true);
    }
    // Set up new block. Captures first token.
    var newBlock = newBlock();
    try {
      statement(false, 0, true, labelledStatement);
    } finally {
      restoreBlock(newBlock);
    }
    return new Block(newBlock.getToken(), finish, newBlock.getFlags() | Block.IS_SYNTHETIC, newBlock.getStatements());
  }

  /**
   * Detect calls to special functions.
   * @param ident Called function.
   */
  void detectSpecialFunction(IdentNode ident) {
    var name = ident.getName();
    if (CompilerConstants.EVAL.symbolName().equals(name)) {
      markEval(lc);
    } else if (SUPER.getName().equals(name)) {
      assert ident.isDirectSuper();
      markSuperCall(lc);
    }
  }

  /**
   * Detect use of special properties.
   * @param ident Referenced property.
   */
  void detectSpecialProperty(IdentNode ident) {
    if (isArguments(ident)) {
      // skip over arrow functions, e.g. function f() { return (() => arguments.length)(); }
      getCurrentNonArrowFunction().setFlag(FunctionNode.USES_ARGUMENTS);
    }
  }

  static boolean isArguments(String name) {
    return ARGUMENTS_NAME.equals(name);
  }

  static boolean isArguments(IdentNode ident) {
    return isArguments(ident.getName());
  }

  /**
   * Tells whether a IdentNode can be used as L-value of an assignment
   *
   * @param ident IdentNode to be checked
   * @return whether the ident can be used as L-value
   */
  static boolean checkIdentLValue(IdentNode ident) {
    return ident.tokenType().getKind() != TokenKind.KEYWORD;
  }

  /**
   * Verify an assignment expression.
   *
   * @param op  Operation token.
   * @param lhs Left hand side expression.
   * @param rhs Right hand side expression.
   * @return Verified expression.
   */
  Expression verifyAssignment(long op, Expression lhs, Expression rhs) {
    var opType = Token.descType(op);
    switch (opType) {
      case ASSIGN, ASSIGN_ADD, ASSIGN_BIT_AND, ASSIGN_BIT_OR, ASSIGN_BIT_XOR, ASSIGN_DIV, ASSIGN_MOD, ASSIGN_MUL, ASSIGN_SAR, ASSIGN_SHL, ASSIGN_SHR, ASSIGN_SUB -> {
        if (lhs instanceof IdentNode) {
          if (!checkIdentLValue((IdentNode) lhs)) {
            return referenceError(lhs, rhs, false);
          }
          verifyIdent((IdentNode) lhs, "assignment");
        } else if (lhs instanceof AccessNode || lhs instanceof IndexNode) {
          // continue
        } else if (opType == ASSIGN && isDestructuringLhs(lhs)) {
          verifyDestructuringAssignmentPattern(lhs, "assignment");
        } else {
          return referenceError(lhs, rhs, env._early_lvalue_error);
        }
      }
      // default: ignore other op types
    }

    // Build up node.
    if (BinaryNode.isLogical(opType)) {
      return new BinaryNode(op, new JoinPredecessorExpression(lhs), new JoinPredecessorExpression(rhs));
    }
    return new BinaryNode(op, lhs, rhs);
  }

  boolean isDestructuringLhs(Expression lhs) {
    return (lhs instanceof ObjectNode || lhs instanceof LiteralNode.ArrayLiteralNode);
  }

  void verifyDestructuringAssignmentPattern(Expression pattern, String contextString) {
    assert pattern instanceof ObjectNode || pattern instanceof LiteralNode.ArrayLiteralNode;
    pattern.accept(new VerifyDestructuringPatternNodeVisitor(new LexicalContext()) {
      @Override
      void verifySpreadElement(Expression lvalue) {
        if (!checkValidLValue(lvalue, contextString)) {
          throw error(AbstractParser.message("invalid.lvalue"), lvalue.getToken());
        }
      }
      @Override
      public boolean enterIdentNode(IdentNode identNode) {
        verifyIdent(identNode, contextString);
        if (!checkIdentLValue(identNode)) {
          referenceError(identNode, null, true);
          return false;
        }
        return false;
      }
      @Override
      public boolean enterAccessNode(AccessNode accessNode) {
        return false;
      }
      @Override
      public boolean enterIndexNode(IndexNode indexNode) {
        return false;
      }
      @Override
      protected boolean enterDefault(Node node) {
        throw error(String.format("unexpected node in AssignmentPattern: %s", node));
      }
    });
  }

  /**
   * Reduce increment/decrement to simpler operations.
   * @param firstToken First token.
   * @param tokenType  Operation token (INCPREFIX/DEC.)
   * @param expression Left hand side expression.
   * @param isPostfix  Prefix or postfix.
   * @return           Reduced expression.
   */
  static UnaryNode incDecExpression(long firstToken, TokenType tokenType, Expression expression, boolean isPostfix) {
    return isPostfix
      ? new UnaryNode(Token.recast(firstToken, tokenType == DECPREFIX ? DECPOSTFIX : INCPOSTFIX), expression.getStart(), Token.descPosition(firstToken) + Token.descLength(firstToken), expression)
      : new UnaryNode(firstToken, expression);
  }

  /**
   * -----------------------------------------------------------------------
   *
   * Grammar based on
   *
   *      ECMAScript Language Specification
   *      ECMA-262 5th Edition / December 2009
   *
   * -----------------------------------------------------------------------
   */

  /**
   * Program :
   *      SourceElements?
   *
   * See 14
   *
   * Parse the top level script.
   */
  FunctionNode program(String scriptName, int reparseFlags) {
    // Make a pseudo-token for the script holding its start and length.
    var functionToken = Token.toDesc(FUNCTION, Token.descPosition(Token.withDelimiter(token)), source.getLength());
    var functionLine = line;
    var ident = new IdentNode(functionToken, Token.descPosition(functionToken), scriptName);
    var script = createParserContextFunctionNode(ident, functionToken, FunctionNode.Kind.SCRIPT, functionLine, Collections.<IdentNode>emptyList());
    lc.push(script);
    var body = newBlock();
    functionDeclarations = new ArrayList<>();
    sourceElements(reparseFlags);
    addFunctionDeclarations(script);
    functionDeclarations = null;
    restoreBlock(body);
    body.setFlag(Block.NEEDS_SCOPE);
    var programBody = new Block(functionToken, finish, body.getFlags() | Block.IS_SYNTHETIC | Block.IS_BODY, body.getStatements());
    lc.pop(script);
    script.setLastToken(token);
    expect(EOF);
    return createFunctionNode(script, functionToken, ident, Collections.<IdentNode>emptyList(), FunctionNode.Kind.SCRIPT, functionLine, programBody);
  }

  /**
   * Directive value or null if statement is not a directive.
   *
   * @param stmt Statement to be checked
   * @return Directive value if the given statement is a directive
   */
  String getDirective(Node stmt) {
    if (stmt instanceof ExpressionStatement es) {
      var expr = es.getExpression();
      if (expr instanceof LiteralNode) {
        var lit = (LiteralNode<?>) expr;
        var litToken = lit.getToken();
        var tt = Token.descType(litToken);
        // A directive is either a string or an escape string
        if (tt == TokenType.STRING || tt == TokenType.ESCSTRING) {
          // Make sure that we don't unescape anything. Return as seen in source!
          return source.getString(lit.getStart(), Token.descLength(litToken));
        }
      }
    }
    return null;
  }

  /**
   * SourceElements :
   *      SourceElement
   *      SourceElements SourceElement
   *
   * See 14
   *
   * Parse the elements of the script or function.
   */
  void sourceElements(int reparseFlags) {
    var functionFlags = reparseFlags;
    // If is a script, then process until the end of the script.
    while (type != EOF) {
      // Break if the end of a code block.
      if (type == RBRACE) {
        break;
      }
      try {
        // Get the next element.
        statement(true, functionFlags, false, false);
        functionFlags = 0;
        // check for directive prologues here
      } catch (Exception e) {
        var errorLine = line;
        var errorToken = token;
        //recover parsing
        recover(e);
        var errorExpr = new ErrorNode(errorToken, finish);
        var expressionStatement = new ExpressionStatement(errorLine, errorToken, finish, errorExpr);
        appendStatement(expressionStatement);
      }
      // No backtracking from here on.
      stream.commit(k);
    }
  }

  /**
   * Parse any of the basic statement types.
   *
   * Statement :
   *      BlockStatement
   *      VariableStatement
   *      EmptyStatement
   *      ExpressionStatement
   *      IfStatement
   *      BreakableStatement
   *      ContinueStatement
   *      BreakStatement
   *      ReturnStatement
   *      WithStatement
   *      LabelledStatement
   *      ThrowStatement
   *      TryStatement
   *      DebuggerStatement
   *
   * BreakableStatement :
   *      IterationStatement
   *      SwitchStatement
   *
   * BlockStatement :
   *      Block
   *
   * Block :
   *      { StatementList opt }
   *
   * StatementList :
   *      StatementListItem
   *      StatementList StatementListItem
   *
   * StatementItem :
   *      Statement
   *      Declaration
   *
   * Declaration :
   *     HoistableDeclaration
   *     ClassDeclaration
   *     LexicalDeclaration
   *
   * HoistableDeclaration :
   *     FunctionDeclaration
   *     GeneratorDeclaration
   */
  void statement() {
    statement(false, 0, false, false);
  }

  /**
   * @param topLevel does this statement occur at the "top level" of a script or a function?
   * @param reparseFlags reparse flags to decide whether to allow property "get" and "set" functions or ES6 methods.
   * @param singleStatement are we in a single statement context?
   */
  void statement(boolean topLevel, int reparseFlags, boolean singleStatement, boolean labelledStatement) {
    switch (type) {

      case LBRACE -> block();
      case VAR -> variableStatement(type);
      case SEMICOLON -> emptyStatement();
      case IF -> ifStatement();
      case FOR -> forStatement();
      case WHILE -> whileStatement();
      case DO -> doStatement();
      case CONTINUE -> continueStatement();
      case BREAK -> breakStatement();
      case RETURN -> returnStatement();
      case WITH -> withStatement();
      case SWITCH -> switchStatement();
      case THROW -> throwStatement();
      case TRY -> tryStatement();
      case DEBUGGER -> debuggerStatement();
      case RPAREN, RBRACKET, EOF -> expect(SEMICOLON);

      case FUNCTION -> {
        // As per spec (ECMA section 12), function declarations as arbitrary statement is not "portable".
        // Implementation can issue a warning or disallow the same.
        if (singleStatement) {
          // ES6 B.3.2 Labelled Function Declarations
          // It is a Syntax Error if any source code matches this rule:
          // LabelledItem : FunctionDeclaration.
          if (!labelledStatement) {
            throw error(AbstractParser.message("expected.stmt", "function declaration"), token);
          }
        }
        functionExpression(true, topLevel || labelledStatement);
        return;
      }

      default -> {
        if ((type == LET && lookaheadIsLetDeclaration(false) || type == CONST)) {
          if (singleStatement) {
            throw error(AbstractParser.message("expected.stmt", type.getName() + " declaration"), token);
          }
          variableStatement(type);
          break;
        } else if (type == CLASS) {
          if (singleStatement) {
            throw error(AbstractParser.message("expected.stmt", "class declaration"), token);
          }
          classDeclaration(false);
          break;
        }
        if (type == IDENT) {
          if (T(k + 1) == COLON) {
            labelStatement();
            return;
          }
          if ((reparseFlags & ScriptFunctionData.IS_PROPERTY_ACCESSOR) != 0) {
            var ident = (String) getValue();
            var propertyToken = token;
            var propertyLine = line;
            if (GET_NAME.equals(ident)) {
              NEXT();
              addPropertyFunctionStatement(propertyGetterFunction(propertyToken, propertyLine));
              return;
            } else if (SET_NAME.equals(ident)) {
              NEXT();
              addPropertyFunctionStatement(propertySetterFunction(propertyToken, propertyLine));
              return;
            }
          }
        }
        if ((reparseFlags & ScriptFunctionData.IS_ES6_METHOD) != 0 && (type == IDENT || type == LBRACKET)) {
          var ident = (String) getValue();
          var propertyToken = token;
          var propertyLine = line;
          var propertyKey = propertyName();
          // Code below will need refinement once we fully support ES6 class syntax
          var flags = CONSTRUCTOR_NAME.equals(ident) ? FunctionNode.IS_CLASS_CONSTRUCTOR : FunctionNode.IS_METHOD;
          addPropertyFunctionStatement(propertyMethodFunction(propertyKey, propertyToken, propertyLine, false, flags, false));
          return;
        }
        expressionStatement();
      }
    }
  }

  void addPropertyFunctionStatement(PropertyFunction propertyFunction) {
    var fn = propertyFunction.functionNode;
    functionDeclarations.add(new ExpressionStatement(fn.getLineNumber(), fn.getToken(), finish, fn));
  }

  /**
   * ClassDeclaration[Yield, Default] :
   *   class BindingIdentifier[?Yield] ClassTail[?Yield]
   *   [+Default] class ClassTail[?Yield]
   */
  ClassNode classDeclaration(boolean isDefault) {
    var classLineNumber = line;
    var classExpression = classExpression(!isDefault);
    if (!isDefault) {
      var classVar = new VarNode(classLineNumber, classExpression.getToken(), classExpression.getIdent().getFinish(), classExpression.getIdent(), classExpression, VarNode.IS_CONST);
      appendStatement(classVar);
    }
    return classExpression;
  }

  /**
   * ClassExpression[Yield] :
   *   class BindingIdentifier[?Yield]opt ClassTail[?Yield]
   */
  ClassNode classExpression(boolean isStatement) {
    assert type == CLASS;
    var classLineNumber = line;
    var classToken = token;
    NEXT();
    IdentNode className = null;
    if (isStatement || type == IDENT) {
      className = getIdent();
    }
    return classTail(classLineNumber, classToken, className, isStatement);
  }

  static final class ClassElementKey {

    private final boolean isStatic;
    private final String propertyName;

    ClassElementKey(boolean isStatic, String propertyName) {
      this.isStatic = isStatic;
      this.propertyName = propertyName;
    }

    @Override
    public int hashCode() {
      var prime = 31;
      var result = 1;
      result = prime * result + (isStatic ? 1231 : 1237);
      result = prime * result + ((propertyName == null) ? 0 : propertyName.hashCode());
      return result;
    }
    @Override
    public boolean equals(Object obj) {
      return obj instanceof ClassElementKey other && this.isStatic == other.isStatic && Objects.equals(this.propertyName, other.propertyName);
    }
  }

  /**
   * Parse ClassTail and ClassBody.
   *
   * ClassTail[Yield] :
   *   ClassHeritage[?Yield]opt { ClassBody[?Yield]opt }
   * ClassHeritage[Yield] :
   *   extends LeftHandSideExpression[?Yield]
   *
   * ClassBody[Yield] :
   *   ClassElementList[?Yield]
   * ClassElementList[Yield] :
   *   ClassElement[?Yield]
   *   ClassElementList[?Yield] ClassElement[?Yield]
   * ClassElement[Yield] :
   *   MethodDefinition[?Yield]
   *   static MethodDefinition[?Yield]
   *   ;
   */
  ClassNode classTail(int classLineNumber, long classToken, IdentNode className, boolean isStatement) {
      Expression classHeritage = null;
      if (type == EXTENDS) {
        NEXT();
        classHeritage = leftHandSideExpression();
      }
      expect(LBRACE);
      PropertyNode constructor = null;
      var classElements = new ArrayList<PropertyNode>();
      var keyToIndexMap = new HashMap<ClassElementKey, Integer>();
      for (;;) {
        if (type == SEMICOLON) {
          NEXT();
          continue;
        }
        if (type == RBRACE) {
          break;
        }
        var classElementToken = token;
        var isStatic = false;
        if (type == STATIC) {
          isStatic = true;
          NEXT();
        }
        var generator = false;
        if (type == MUL) {
          generator = true;
          NEXT();
        }
        var classElement = methodDefinition(isStatic, classHeritage != null, generator);
        if (classElement.isComputed()) {
          classElements.add(classElement);
        } else if (!classElement.isStatic() && classElement.getKeyName().equals(CONSTRUCTOR_NAME)) {
          if (constructor == null) {
            constructor = classElement;
          } else {
            throw error(AbstractParser.message("multiple.constructors"), classElementToken);
          }
        } else {
          // Check for duplicate method definitions and combine accessor methods.
          // In ES6, a duplicate is never an error (in consequence of computed property names).
          var key = new ClassElementKey(classElement.isStatic(), classElement.getKeyName());
          var existing = keyToIndexMap.get(key);
          if (existing == null) {
            keyToIndexMap.put(key, classElements.size());
            classElements.add(classElement);
          } else {
            var existingProperty = classElements.get(existing);
            var value = classElement.getValue();
            var getter = classElement.getGetter();
            var setter = classElement.getSetter();
            if (value != null || existingProperty.getValue() != null) {
              keyToIndexMap.put(key, classElements.size());
              classElements.add(classElement);
            } else if (getter != null) {
              assert existingProperty.getGetter() != null || existingProperty.getSetter() != null;
              classElements.set(existing, existingProperty.setGetter(getter));
            } else if (setter != null) {
              assert existingProperty.getGetter() != null || existingProperty.getSetter() != null;
              classElements.set(existing, existingProperty.setSetter(setter));
            }
          }
        }
      }
      var lastToken = token;
      expect(RBRACE);
      if (constructor == null) {
        constructor = createDefaultClassConstructor(classLineNumber, classToken, lastToken, className, classHeritage != null);
      }
      classElements.trimToSize();
      return new ClassNode(classLineNumber, classToken, finish, className, classHeritage, constructor, classElements, isStatement);
  }

  PropertyNode createDefaultClassConstructor(int classLineNumber, long classToken, long lastToken, IdentNode className, boolean subclass) {
    var ctorFinish = finish;
    List<Statement> statements;
    List<IdentNode> parameters;
    var identToken = Token.recast(classToken, TokenType.IDENT);
    if (subclass) {
      var superIdent = createIdentNode(identToken, ctorFinish, SUPER.getName()).setIsDirectSuper();
      var argsIdent = createIdentNode(identToken, ctorFinish, "args").setIsRestParameter();
      var spreadArgs = new UnaryNode(Token.recast(classToken, TokenType.SPREAD_ARGUMENT), argsIdent);
      var superCall = new CallNode(classLineNumber, classToken, ctorFinish, superIdent, Collections.singletonList(spreadArgs), false);
      statements = Collections.singletonList(new ExpressionStatement(classLineNumber, classToken, ctorFinish, superCall));
      parameters = Collections.singletonList(argsIdent);
    } else {
      statements = Collections.emptyList();
      parameters = Collections.emptyList();
    }
    var body = new Block(classToken, ctorFinish, Block.IS_BODY, statements);
    var ctorName = className != null ? className : createIdentNode(identToken, ctorFinish, CONSTRUCTOR_NAME);
    var function = createParserContextFunctionNode(ctorName, classToken, FunctionNode.Kind.NORMAL, classLineNumber, parameters);
    function.setLastToken(lastToken);
    function.setFlag(FunctionNode.IS_METHOD);
    function.setFlag(FunctionNode.IS_CLASS_CONSTRUCTOR);
    if (subclass) {
      function.setFlag(FunctionNode.IS_SUBCLASS_CONSTRUCTOR);
      function.setFlag(FunctionNode.HAS_DIRECT_SUPER);
    }
    if (className == null) {
      function.setFlag(FunctionNode.IS_ANONYMOUS);
    }
    var fn = createFunctionNode(function, classToken, ctorName, parameters, FunctionNode.Kind.NORMAL, classLineNumber, body);
    var constructor = new PropertyNode(classToken, ctorFinish, ctorName, fn, null, null, false, false);
    return constructor;
  }

  PropertyNode methodDefinition(boolean isStatic, boolean subclass, boolean generator) {
    var methodToken = token;
    var methodLine = line;
    var computed = type == LBRACKET;
    var isIdent = type == IDENT;
    var propertyName = propertyName();
    var flags = FunctionNode.IS_METHOD;
    if (!computed) {
      var name = ((PropertyKey) propertyName).getPropertyName();
      if (!generator && isIdent && type != LPAREN && name.equals(GET_NAME)) {
        var methodDefinition = propertyGetterFunction(methodToken, methodLine, flags);
        verifyAllowedMethodName(methodDefinition.key, isStatic, methodDefinition.computed, generator, true);
        return new PropertyNode(methodToken, finish, methodDefinition.key, null, methodDefinition.functionNode, null, isStatic, methodDefinition.computed);
      } else if (!generator && isIdent && type != LPAREN && name.equals(SET_NAME)) {
        var methodDefinition = propertySetterFunction(methodToken, methodLine, flags);
        verifyAllowedMethodName(methodDefinition.key, isStatic, methodDefinition.computed, generator, true);
        return new PropertyNode(methodToken, finish, methodDefinition.key, null, null, methodDefinition.functionNode, isStatic, methodDefinition.computed);
      } else {
        if (!isStatic && !generator && name.equals(CONSTRUCTOR_NAME)) {
          flags |= FunctionNode.IS_CLASS_CONSTRUCTOR;
          if (subclass) {
            flags |= FunctionNode.IS_SUBCLASS_CONSTRUCTOR;
          }
        }
        verifyAllowedMethodName(propertyName, isStatic, computed, generator, false);
      }
    }
    var methodDefinition = propertyMethodFunction(propertyName, methodToken, methodLine, generator, flags, computed);
    return new PropertyNode(methodToken, finish, methodDefinition.key, methodDefinition.functionNode, null, null, isStatic, computed);
  }

  /**
   * ES6 14.5.1 Static Semantics: Early Errors.
   */
  void verifyAllowedMethodName(Expression key, boolean isStatic, boolean computed, boolean generator, boolean accessor) {
    if (!computed) {
      if (!isStatic && generator && ((PropertyKey) key).getPropertyName().equals(CONSTRUCTOR_NAME)) {
        throw error(AbstractParser.message("generator.constructor"), key.getToken());
      }
      if (!isStatic && accessor && ((PropertyKey) key).getPropertyName().equals(CONSTRUCTOR_NAME)) {
        throw error(AbstractParser.message("accessor.constructor"), key.getToken());
      }
      if (isStatic && ((PropertyKey) key).getPropertyName().equals("prototype")) {
        throw error(AbstractParser.message("static.prototype.method"), key.getToken());
      }
    }
  }

  /**
   * block :
   *      { StatementList? }
   *
   * see 12.1
   *
   * Parse a statement block.
   */
  void block() {
    appendStatement(new BlockStatement(line, getBlock(true)));
  }

  /**
   * StatementList :
   *      Statement
   *      StatementList Statement
   *
   * See 12.1
   *
   * Parse a list of statements.
   */
  void statementList() {
    // Accumulate statements until end of list. */
    loop: while (type != EOF) {
      switch (type) {
        case EOF, CASE, DEFAULT, RBRACE -> { break loop; }
        // default: pass
      }
      // Get next statement.
      statement();
    }
  }

  /**
   * Make sure that the identifier name used is allowed.
   *
   * @param ident         Identifier that is verified
   * @param contextString String used in error message to give context to the user
   */
  void verifyIdent(IdentNode ident, String contextString) {
    verifyFutureIdent(ident, contextString);
    checkEscapedKeyword(ident);
  }

  /**
   * Make sure that the identifier name used is allowed.
   *
   * @param ident         Identifier that is verified
   * @param contextString String used in error message to give context to the user
   */
  void verifyFutureIdent(IdentNode ident, String contextString) {
    switch (ident.getName()) {
      case "eval", "arguments" -> throw error(AbstractParser.message("name", ident.getName(), contextString), ident.getToken());
      // default: pass
    }
    if (ident.isFutureName()) {
      throw error(AbstractParser.message("name", ident.getName(), contextString), ident.getToken());
    }
  }

  /**
   * ES6 11.6.2: A code point in a ReservedWord cannot be expressed by a | UnicodeEscapeSequence.
   */
  void checkEscapedKeyword(IdentNode ident) {
    if (ident.containsEscapes()) {
      var tokenType = TokenLookup.lookupKeyword(ident.getName().toCharArray(), 0, ident.getName().length());
      if (tokenType != IDENT) {
        throw error(AbstractParser.message("keyword.escaped.character"), ident.getToken());
      }
    }
  }

  /**
   * VariableStatement :
   *      var VariableDeclarationList ;
   *
   * VariableDeclarationList :
   *      VariableDeclaration
   *      VariableDeclarationList , VariableDeclaration
   *
   * VariableDeclaration :
   *      Identifier Initializer?
   *
   * Initializer :
   *      = AssignmentExpression
   *
   * See 12.2
   *
   * Parse a VAR statement.
   * @param isStatement True if a statement (not used in a FOR.)
   */
  void variableStatement(TokenType varType) {
    variableDeclarationList(varType, true, -1);
  }

  static final class ForVariableDeclarationListResult {

    // First missing const or binding pattern initializer.
    Expression missingAssignment;
    // First declaration with an initializer.
    long declarationWithInitializerToken;
    // Destructuring assignments.
    Expression init;
    Expression firstBinding;
    Expression secondBinding;

    void recordMissingAssignment(Expression binding) {
      if (missingAssignment == null) {
        missingAssignment = binding;
      }
    }

    void recordDeclarationWithInitializer(long token) {
      if (declarationWithInitializerToken == 0L) {
        declarationWithInitializerToken = token;
      }
    }

    void addBinding(Expression binding) {
      if (firstBinding == null) {
        firstBinding = binding;
      } else if (secondBinding == null) {
        secondBinding = binding;
      }
      // ignore the rest
    }

    void addAssignment(Expression assignment) {
      if (init == null) {
        init = assignment;
      } else {
        init = new BinaryNode(Token.recast(init.getToken(), COMMARIGHT), init, assignment);
      }
    }
  }

  /**
   * @param isStatement {@code true} if a VariableStatement, {@code false} if a {@code for} loop VariableDeclarationList
   */
  ForVariableDeclarationListResult variableDeclarationList(TokenType varType, boolean isStatement, int sourceOrder) {
    // VAR tested in caller.
    assert varType == VAR || varType == LET || varType == CONST;
    var varLine = line;
    var varToken = token;
    NEXT();
    var varFlags = 0;
    if (varType == LET) {
      varFlags |= VarNode.IS_LET;
    } else if (varType == CONST) {
      varFlags |= VarNode.IS_CONST;
    }
    var forResult = isStatement ? null : new ForVariableDeclarationListResult();
    assert forResult != null;
    for (;;) {
      // Get name of var.
      if (type == YIELD && inGeneratorFunction()) {
        expect(IDENT);
      }
      var contextString = "variable name";
      var binding = bindingIdentifierOrPattern(contextString);
      assert binding != null;
      var isDestructuring = !(binding instanceof IdentNode);
      if (isDestructuring) {
        var finalVarFlags = varFlags;
        verifyDestructuringBindingPattern(binding, (identNode) -> {
          verifyIdent(identNode, contextString);
          if (!env._parse_only) {
            // don't bother adding a variable if we are just parsing!
            var node = new VarNode(varLine, varToken, sourceOrder, identNode.getFinish(), identNode.setIsDeclaredHere(), null, finalVarFlags);
            appendStatement(node);
          }
        });
      }
      // Assume no init.
      Expression init = null;
      // Look for initializer assignment.
      if (type == ASSIGN) {
        if (!isStatement) {
          forResult.recordDeclarationWithInitializer(varToken);
        }
        NEXT();
        // Get initializer expression. Suppress IN if not statement.
        if (!isDestructuring) {
          defaultNames.push(binding);
        }
        try {
          init = assignmentExpression(!isStatement);
        } finally {
          if (!isDestructuring) {
            defaultNames.pop();
          }
        }
      } else if (isStatement) {
        if (isDestructuring) {
          throw error(AbstractParser.message("missing.destructuring.assignment"), token);
        } else if (varType == CONST) {
          throw error(AbstractParser.message("missing.const.assignment", ((IdentNode) binding).getName()));
        }
        // else, if we are in a for loop, delay checking until we know the kind of loop
      }
      if (!isDestructuring) {
        assert init != null || varType != CONST || !isStatement;
        var ident = (IdentNode) binding;
        if (!isStatement && ident.getName().equals("let")) {
          throw error(AbstractParser.message("let.binding.for")); //ES6 13.7.5.1
        }
        // Only set declaration flag on lexically scoped let/const as it adds runtime overhead.
        var name = varType == LET || varType == CONST ? ident.setIsDeclaredHere() : ident;
        if (!isStatement) {
          if (init == null && varType == CONST) {
            forResult.recordMissingAssignment(name);
          }
          forResult.addBinding(new IdentNode(name));
        }
        var node = new VarNode(varLine, varToken, sourceOrder, finish, name, init, varFlags);
        appendStatement(node);
      } else {
        assert init != null || !isStatement;
        if (init != null) {
          var assignment = verifyAssignment(Token.recast(varToken, ASSIGN), binding, init);
          if (isStatement) {
            appendStatement(new ExpressionStatement(varLine, assignment.getToken(), finish, assignment, varType));
          } else {
            forResult.addAssignment(assignment);
            forResult.addBinding(assignment);
          }
        } else if (!isStatement) {
          forResult.recordMissingAssignment(binding);
          forResult.addBinding(binding);
        }
      }
      if (type != COMMARIGHT) {
        break;
      }
      NEXT();
    }
    // If is a statement then handle end of line.
    if (isStatement) {
      ENDofLINE();
    }
    return forResult;
  }

  boolean isBindingIdentifier() {
    return type == IDENT;
  }

  IdentNode bindingIdentifier(String contextString) {
    var name = getIdent();
    verifyIdent(name, contextString);
    return name;
  }

  Expression bindingPattern() {
    return switch(type) {
      case LBRACKET -> arrayLiteral();
      case LBRACE -> objectLiteral();
      default -> throw error(AbstractParser.message("expected.binding"));
    };
  }

  Expression bindingIdentifierOrPattern(String contextString) {
    return isBindingIdentifier() ? bindingIdentifier(contextString) : bindingPattern();
  }

  abstract class VerifyDestructuringPatternNodeVisitor extends NodeVisitor<LexicalContext> {

    VerifyDestructuringPatternNodeVisitor(LexicalContext lc) {
      super(lc);
    }

    @Override
    public boolean enterLiteralNode(LiteralNode<?> literalNode) {
      if (literalNode.isArray()) {
        if (((LiteralNode.ArrayLiteralNode) literalNode).hasSpread() && ((LiteralNode.ArrayLiteralNode) literalNode).hasTrailingComma()) {
          throw error("Rest element must be last", literalNode.getElementExpressions().get(literalNode.getElementExpressions().size() - 1).getToken());
        }
        var restElement = false;
        for (var element : literalNode.getElementExpressions()) {
          if (element != null) {
            if (restElement) {
              throw error("Unexpected element after rest element", element.getToken());
            }
            if (element.isTokenType(SPREAD_ARRAY)) {
              restElement = true;
              var lvalue = ((UnaryNode) element).getExpression();
              verifySpreadElement(lvalue);
            }
            element.accept(this);
          }
        }
        return false;
      } else {
        return enterDefault(literalNode);
      }
    }

    abstract void verifySpreadElement(Expression lvalue);

    @Override
    public boolean enterObjectNode(ObjectNode objectNode) {
      return true;
    }

    @Override
    public boolean enterPropertyNode(PropertyNode propertyNode) {
      if (propertyNode.getValue() != null) {
        propertyNode.getValue().accept(this);
        return false;
      } else {
        return enterDefault(propertyNode);
      }
    }

    @Override
    public boolean enterBinaryNode(BinaryNode binaryNode) {
      if (binaryNode.isTokenType(ASSIGN)) {
        binaryNode.lhs().accept(this);
        // Initializer(rhs) can be any AssignmentExpression
        return false;
      } else {
        return enterDefault(binaryNode);
      }
    }

    @Override
    public boolean enterUnaryNode(UnaryNode unaryNode) {
      if (unaryNode.isTokenType(SPREAD_ARRAY)) {
        // rest element
        return true;
      } else {
        return enterDefault(unaryNode);
      }
    }
  }

  /**
   * Verify destructuring variable declaration binding pattern and extract bound variable declarations.
   */
  void verifyDestructuringBindingPattern(Expression pattern, Consumer<IdentNode> identifierCallback) {
    assert (pattern instanceof BinaryNode && pattern.isTokenType(ASSIGN)) || pattern instanceof ObjectNode || pattern instanceof LiteralNode.ArrayLiteralNode;
    pattern.accept(new VerifyDestructuringPatternNodeVisitor(new LexicalContext()) {
      @Override
      void verifySpreadElement(Expression lvalue) {
        if (lvalue instanceof IdentNode) {
          // checked in identifierCallback
        } else if (isDestructuringLhs(lvalue)) {
          verifyDestructuringBindingPattern(lvalue, identifierCallback);
        } else {
          throw error("Expected a valid binding identifier", lvalue.getToken());
        }
      }
      @Override
      public boolean enterIdentNode(IdentNode identNode) {
        identifierCallback.accept(identNode);
        return false;
      }
      @Override
      protected boolean enterDefault(Node node) {
        throw error(String.format("unexpected node in BindingPattern: %s", node));
      }
    });
  }

  /**
   * EmptyStatement :
   *      ;
   *
   * See 12.3
   *
   * Parse an empty statement.
   */
  void emptyStatement() {
    if (env._empty_statements) {
      appendStatement(new EmptyNode(line, token, Token.descPosition(token) + Token.descLength(token)));
    }
    // SEMICOLON checked in caller.
    NEXT();
  }

  /**
   * ExpressionStatement :
   *      Expression ; // [lookahead ~({ or  function )]
   *
   * See 12.4
   *
   * Parse an expression used in a statement block.
   */
  void expressionStatement() {
    // Lookahead checked in caller.
    var expressionLine = line;
    var expressionToken = token;
    // Get expression and add as statement.
    var expression = expression();
    if (expression != null) {
      var expressionStatement = new ExpressionStatement(expressionLine, expressionToken, finish, expression);
      appendStatement(expressionStatement);
    } else {
      expect(null);
    }
    ENDofLINE();
  }

  /**
   * IfStatement :
   *      if ( Expression ) Statement else Statement
   *      if ( Expression ) Statement
   *
   * See 12.5
   *
   * Parse an IF statement.
   */
  void ifStatement() {
    // Capture IF token.
    var ifLine = line;
    var ifToken = token;
    // IF tested in caller.
    NEXT();
    expect(LPAREN);
    var test = expression();
    expect(RPAREN);
    var pass = getStatement();
    Block fail = null;
    if (type == ELSE) {
      NEXT();
      fail = getStatement();
    }
    appendStatement(new IfNode(ifLine, ifToken, fail != null ? fail.getFinish() : pass.getFinish(), test, pass, fail));
  }

  /**
   * ... IterationStatement:
   *           ...
   *           for ( Expression[NoIn]?; Expression? ; Expression? ) Statement
   *           for ( var VariableDeclarationList[NoIn]; Expression? ; Expression? ) Statement
   *           for ( LeftHandSideExpression in Expression ) Statement
   *           for ( var VariableDeclaration[NoIn] in Expression ) Statement
   *
   * See 12.6
   *
   * Parse a FOR statement.
   */
  void forStatement() {
    var forToken = token;
    var forLine = line;
    // start position of this for statement.
    // This is used for sort order for variables declared in the initializer part of this 'for' statement (if any).
    var forStart = Token.descPosition(forToken);
    // When ES6 for-let is enabled we create a container block to capture the LET.
    var outer = newBlock();
    // Create FOR node, capturing FOR token.
    var forNode = new ParserContextLoopNode();
    lc.push(forNode);
    Block body = null;
    Expression init = null;
    JoinPredecessorExpression test = null;
    JoinPredecessorExpression modify = null;
    ForVariableDeclarationListResult varDeclList = null;
    var flags = 0;
    try {
      // FOR tested in caller.
      NEXT();
      // Nashorn extension: for each expression.
      // iterate property values rather than property names.
      if (_syntax_extension_ && type == IDENT && "each".equals(getValue())) {
        flags |= ForNode.IS_FOR_EACH;
        NEXT();
      }
      expect(LPAREN);
      TokenType varType = null;
      // TODO: review use of 2 switch()'s here
      switch (type) {
        case VAR -> { // Var declaration captured in for outer block.
          varDeclList = variableDeclarationList(varType = type, false, forStart);
        }
        case SEMICOLON -> {
          // continue
        }
        default -> {
          if ((type == LET && lookaheadIsLetDeclaration(true) || type == CONST)) {
            flags |= ForNode.PER_ITERATION_SCOPE;
            // LET/CONST declaration captured in container block created above.
            varDeclList = variableDeclarationList(varType = type, false, forStart);
            break;
          }
          init = expression(unaryExpression(), COMMARIGHT.getPrecedence(), true);
        }

      }
      switch (type) { // TODO: 2nd switch

        case SEMICOLON -> {
          // for (init; test; modify)
          if (varDeclList != null) {
            assert init == null;
            init = varDeclList.init;
            // late check for missing assignment, now we know it's a for (init; test; modify) loop
            if (varDeclList.missingAssignment != null) {
              if (varDeclList.missingAssignment instanceof IdentNode node) {
                throw error(AbstractParser.message("missing.const.assignment", node.getName()));
              } else {
                throw error(AbstractParser.message("missing.destructuring.assignment"), varDeclList.missingAssignment.getToken());
              }
            }
          }
          // for each (init; test; modify) is invalid
          if ((flags & ForNode.IS_FOR_EACH) != 0) {
            throw error(AbstractParser.message("for.each.without.in"), token);
          }
          expect(SEMICOLON);
          if (type != SEMICOLON) {
            test = joinPredecessorExpression();
          }
          expect(SEMICOLON);
          if (type != RPAREN) {
            modify = joinPredecessorExpression();
          }
        }

        case IDENT, IN -> {
          boolean isForOf;
          if (type == IDENT && "of".equals(getValue())) {
            isForOf = true;
          } else {
            expect(SEMICOLON); // fail with expected message
            break;
          } // type == IN
          flags |= isForOf ? ForNode.IS_FOR_OF : ForNode.IS_FOR_IN;
          test = new JoinPredecessorExpression();
          if (varDeclList != null) {
            // for (var|let|const ForBinding in|of expression)
            if (varDeclList.secondBinding != null) {
              // for (var i, j in obj) is invalid
              throw error(AbstractParser.message("many.vars.in.for.in.loop", isForOf ? "of" : "in"), varDeclList.secondBinding.getToken());
            }
            if (varDeclList.declarationWithInitializerToken != 0) {
              // ES5 legacy: for (var i = AssignmentExpressionNoIn in Expression)
              // Generally invalid in ES6, but allow for some cases,
              // i.e., error if for-of, let/const, or destructuring
              throw error(AbstractParser.message("for.in.loop.initializer", isForOf ? "of" : "in"), varDeclList.declarationWithInitializerToken);
            }
            init = varDeclList.firstBinding;
            assert init instanceof IdentNode || isDestructuringLhs(init);
          } else {
            // for (expr in obj)
            assert init != null : "for..in/of init expression can not be null here";
            // check if initial expression is a valid L-value
            if (!checkValidLValue(init, isForOf ? "for-of iterator" : "for-in iterator")) {
              throw error(AbstractParser.message("not.lvalue.for.in.loop", isForOf ? "of" : "in"), init.getToken());
            }
          }
          NEXT();
          // For-of only allows AssignmentExpression.
          modify = isForOf ? new JoinPredecessorExpression(assignmentExpression(false)) : joinPredecessorExpression();
        }

        default -> {
          expect(SEMICOLON);
        }
      }
      expect(RPAREN);
      // Set the for body.
      body = getStatement();
    } finally {
      lc.pop(forNode);
      for (var stmt : forNode.getStatements()) {
        assert stmt instanceof VarNode;
        appendStatement(stmt);
      }
      if (body != null) {
        appendStatement(new ForNode(forLine, forToken, body.getFinish(), body, (forNode.getFlags() | flags), init, test, modify));
      }
      if (outer != null) {
        restoreBlock(outer);
        if (body != null) {
          var statements = new ArrayList<Statement>();
          for (var stmt : outer.getStatements()) {
            if (stmt instanceof VarNode node && !node.isBlockScoped()) {
              appendStatement(stmt);
            } else {
              statements.add(stmt);
            }
          }
          appendStatement(new BlockStatement(forLine, new Block(outer.getToken(), body.getFinish(), statements)));
        }
      }
    }
  }

  boolean checkValidLValue(Expression init, String contextString) {
    if (init instanceof IdentNode node) {
      if (!checkIdentLValue(node)) {
        return false;
      }
      verifyIdent(node, contextString);
      return true;
    } else if (init instanceof AccessNode || init instanceof IndexNode) {
      return true;
    } else if (isDestructuringLhs(init)) {
      verifyDestructuringAssignmentPattern(init, contextString);
      return true;
    } else {
      return false;
    }
  }

  boolean lookaheadIsLetDeclaration(boolean ofContextualKeyword) {
    assert type == LET;
    for (var i = 1;; i++) {
      var t = T(k + i);
      switch (t) {
        case EOL, COMMENT -> { continue; }
        case IDENT -> { return ! (ofContextualKeyword && "of".equals(getValue(getToken(k + i)))); }
        case LBRACKET, LBRACE -> { return true; }
        default -> { return false; }
      }
    }
  }

  /**
   * ...IterationStatement :
   *           ...
   *           while ( Expression ) Statement
   *           ...
   *
   * See 12.6
   *
   * Parse while statement.
   */
  void whileStatement() {
    // Capture WHILE token.
    var whileToken = token;
    var whileLine = line;
    // WHILE tested in caller.
    NEXT();
    var whileNode = new ParserContextLoopNode();
    lc.push(whileNode);
    JoinPredecessorExpression test = null;
    Block body = null;
    try {
      expect(LPAREN);
      test = joinPredecessorExpression();
      expect(RPAREN);
      body = getStatement();
    } finally {
      lc.pop(whileNode);
    }
    if (body != null) {
      appendStatement(new WhileNode(whileLine, whileToken, body.getFinish(), false, test, body));
    }
  }

  /**
   * ...IterationStatement :
   *           ...
   *           do Statement while( Expression ) ;
   *           ...
   *
   * See 12.6
   *
   * Parse DO WHILE statement.
   */
  void doStatement() {
    // Capture DO token.
    var doToken = token;
    var doLine = 0;
    // DO tested in the caller.
    NEXT();
    var doWhileNode = new ParserContextLoopNode();
    lc.push(doWhileNode);
    Block body = null;
    JoinPredecessorExpression test = null;
    try {
      // Get DO body.
      body = getStatement();
      expect(WHILE);
      expect(LPAREN);
      doLine = line;
      test = joinPredecessorExpression();
      expect(RPAREN);
      if (type == SEMICOLON) {
        ENDofLINE();
      }
    } finally {
      lc.pop(doWhileNode);
    }
    appendStatement(new WhileNode(doLine, doToken, finish, true, test, body));
  }

  /**
   * ContinueStatement :
   *      continue Identifier? ; // [no LineTerminator here]
   *
   * See 12.7
   *
   * Parse CONTINUE statement.
   */
  void continueStatement() {
    // Capture CONTINUE token.
    var continueLine = line;
    var continueToken = token;
    // CONTINUE tested in caller.
    NEXTorEOL();
    ParserContextLabelNode labelNode = null;
    // SEMICOLON or label.
    switch (type) {
      case RBRACE, SEMICOLON, EOL, EOF -> {
        // no-op
      }
      default -> {
        var ident = getIdent();
        labelNode = lc.findLabel(ident.getName());
        if (labelNode == null) {
          throw error(AbstractParser.message("undefined.label", ident.getName()), ident.getToken());
        }
      }
    }
    var labelName = labelNode == null ? null : labelNode.getLabelName();
    var targetNode = lc.getContinueTo(labelName);
    if (targetNode == null) {
      throw error(AbstractParser.message("illegal.continue.stmt"), continueToken);
    }
    ENDofLINE();
    // Construct and add CONTINUE node.
    appendStatement(new ContinueNode(continueLine, continueToken, finish, labelName));
  }

  /**
   * BreakStatement :
   *      break Identifier? ; // [no LineTerminator here]
   *
   * See 12.8
   *
   */
  void breakStatement() {
    // Capture BREAK token.
    var breakLine = line;
    var breakToken = token;
    // BREAK tested in caller.
    NEXTorEOL();
    ParserContextLabelNode labelNode = null;
    // SEMICOLON or label.
    switch (type) {
      case RBRACE, SEMICOLON, EOL, EOF -> {
        // pass
      }
      default -> {
        var ident = getIdent();
        labelNode = lc.findLabel(ident.getName());
        if (labelNode == null) {
          throw error(AbstractParser.message("undefined.label", ident.getName()), ident.getToken());
        }
      }
    }
    // either an explicit label - then get its node or just a "break" - get first breakable
    // targetNode is what we are breaking out from.
    var labelName = labelNode == null ? null : labelNode.getLabelName();
    var targetNode = lc.getBreakable(labelName);
    if (targetNode instanceof ParserContextBlockNode) {
      targetNode.setFlag(Block.IS_BREAKABLE);
    }
    if (targetNode == null) {
      throw error(AbstractParser.message("illegal.break.stmt"), breakToken);
    }
    ENDofLINE();
    // Construct and add BREAK node.
    appendStatement(new BreakNode(breakLine, breakToken, finish, labelName));
  }

  /**
   * ReturnStatement :
   *      return Expression? ; // [no LineTerminator here]
   *
   * See 12.9
   *
   * Parse RETURN statement.
   */
  void returnStatement() {
    // check for return outside function
    if (lc.getCurrentFunction().getKind() == FunctionNode.Kind.SCRIPT || lc.getCurrentFunction().getKind() == FunctionNode.Kind.MODULE) {
      throw error(AbstractParser.message("invalid.return"));
    }
    // Capture RETURN token.
    var returnLine = line;
    var returnToken = token;
    // RETURN tested in caller.
    NEXTorEOL();
    Expression expression = null;
    // SEMICOLON or expression.
    switch (type) {
      case RBRACE, SEMICOLON, EOL, EOF -> {
        // pass
      }
      default -> expression = expression();
    }
    ENDofLINE();
    // Construct and add RETURN node.
    appendStatement(new ReturnNode(returnLine, returnToken, finish, expression));
  }

  /**
   * Parse YieldExpression.
   *
   * YieldExpression[In] :
   *   yield
   *   yield [no LineTerminator here] AssignmentExpression[?In, Yield]
   *   yield [no LineTerminator here] * AssignmentExpression[?In, Yield]
   */
  Expression yieldExpression(boolean noIn) {
    assert inGeneratorFunction();
    // Capture YIELD token.
    var yieldToken = token;
    // YIELD tested in caller.
    assert type == YIELD;
    NEXTorEOL();
    Expression expression = null;
    var yieldAsterisk = false;
    if (type == MUL) {
      yieldAsterisk = true;
      yieldToken = Token.recast(yieldToken, YIELD_STAR);
      NEXT();
    }
    switch (type) {
      case RBRACE, SEMICOLON, EOL, EOF, COMMARIGHT, RPAREN, RBRACKET, COLON -> {
        if (!yieldAsterisk) {
          // treat (yield) as (yield void 0)
          expression = newUndefinedLiteral(yieldToken, finish);
          if (type == EOL) {
            NEXT();
          }
        } else {
          expression = assignmentExpression(noIn);
        }
      }
      default -> {
        expression = assignmentExpression(noIn);
      }
    }
    // Construct and add YIELD node.
    return new UnaryNode(yieldToken, expression);
  }

  static UnaryNode newUndefinedLiteral(long token, int finish) {
    return new UnaryNode(Token.recast(token, VOID), LiteralNode.newInstance(token, finish, 0));
  }

  /**
   * WithStatement :
   *      with ( Expression ) Statement
   *
   * See 12.10
   *
   * Parse WITH statement.
   */
  void withStatement() {
    // Capture WITH token.
    throw error(AbstractParser.message("no.with"), token);
  }

  /**
   * SwitchStatement :
   *      switch ( Expression ) CaseBlock
   *
   * CaseBlock :
   *      { CaseClauses? }
   *      { CaseClauses? DefaultClause CaseClauses }
   *
   * CaseClauses :
   *      CaseClause
   *      CaseClauses CaseClause
   *
   * CaseClause :
   *      case Expression : StatementList?
   *
   * DefaultClause :
   *      default : StatementList?
   *
   * See 12.11
   *
   * Parse SWITCH statement.
   */
  void switchStatement() {
    var switchLine = line;
    var switchToken = token;
    // Block to capture variables declared inside the switch statement.
    var switchBlock = newBlock();
    // SWITCH tested in caller.
    NEXT();
    // Create and add switch statement.
    var switchNode = new ParserContextSwitchNode();
    lc.push(switchNode);
    CaseNode defaultCase = null;
    // Prepare to accumulate cases.
    var cases = new ArrayList<CaseNode>();
    Expression expression = null;
    try {
      expect(LPAREN);
      expression = expression();
      expect(RPAREN);
      expect(LBRACE);
      while (type != RBRACE) {
        // Prepare for next case.
        Expression caseExpression = null;
        var caseToken = token;
        switch (type) {
          case CASE -> {
            NEXT();
            caseExpression = expression();
          }
          case DEFAULT -> {
            if (defaultCase != null) {
              throw error(AbstractParser.message("duplicate.default.in.switch"));
            }
            NEXT();
          }
          default -> { // Force an error.
            expect(CASE);
          }
        }
        expect(COLON);
        // Get CASE body.
        var statements = getBlock(false); // TODO: List<Statement> statements = caseStatementList();
        var caseNode = new CaseNode(caseToken, finish, caseExpression, statements);
        if (caseExpression == null) {
          defaultCase = caseNode;
        }
        cases.add(caseNode);
      }
      NEXT();
    } finally {
      lc.pop(switchNode);
      restoreBlock(switchBlock);
    }
    var switchStatement = new SwitchNode(switchLine, switchToken, finish, expression, cases, defaultCase);
    appendStatement(new BlockStatement(switchLine, new Block(switchToken, finish, switchBlock.getFlags() | Block.IS_SYNTHETIC | Block.IS_SWITCH_BLOCK, switchStatement)));
  }

  /**
   * LabelledStatement :
   *      Identifier : Statement
   *
   * See 12.12
   *
   * Parse label statement.
   */
  void labelStatement() {
    // Capture label token.
    var labelToken = token;
    // Get label ident.
    var ident = getIdent();
    expect(COLON);
    if (lc.findLabel(ident.getName()) != null) {
      throw error(AbstractParser.message("duplicate.label", ident.getName()), labelToken);
    }
    var labelNode = new ParserContextLabelNode(ident.getName());
    Block body = null;
    try {
      lc.push(labelNode);
      body = getStatement(true);
    } finally {
      assert lc.peek() instanceof ParserContextLabelNode;
      lc.pop(labelNode);
    }
    appendStatement(new LabelNode(line, labelToken, finish, ident.getName(), body));
  }

  /**
   * ThrowStatement :
   *      throw Expression ; // [no LineTerminator here]
   *
   * See 12.13
   *
   * Parse throw statement.
   */
  void throwStatement() {
    // Capture THROW token.
    var throwLine = line;
    var throwToken = token;
    // THROW tested in caller.
    NEXTorEOL();
    Expression expression = null;
    // SEMICOLON or expression.
    switch (type) {
      case RBRACE, SEMICOLON, EOL -> {
        // pass
      }
      default -> expression = expression();
    }
    if (expression == null) {
      throw error(AbstractParser.message("expected.operand", type.getNameOrType()));
    }
    ENDofLINE();
    appendStatement(new ThrowNode(throwLine, throwToken, finish, expression, false));
  }

  /**
   * TryStatement :
   *      try Block Catch
   *      try Block Finally
   *      try Block Catch Finally
   *
   * Catch :
   *      catch( Identifier if Expression ) Block
   *      catch( Identifier ) Block
   *
   * Finally :
   *      finally Block
   *
   * See 12.14
   *
   * Parse TRY statement.
   */
  void tryStatement() {
    // Capture TRY token.
    var tryLine = line;
    var tryToken = token;
    // TRY tested in caller.
    NEXT();
    // Container block needed to act as target for labeled break statements
    var startLine = line;
    var outer = newBlock();
    // Create try.
    try {
      var tryBody = getBlock(true);
      var catchBlocks = new ArrayList<Block>();
      while (type == CATCH) {
        var catchLine = line;
        var catchToken = token;
        NEXT();
        expect(LPAREN);
        // ES6 catch parameter can be a BindingIdentifier or a BindingPattern
        // http://www.ecma-international.org/ecma-262/6.0/
        var contextString = "catch argument";
        var exception = bindingIdentifierOrPattern(contextString);
        var isDestructuring = !(exception instanceof IdentNode);
        if (isDestructuring) {
          verifyDestructuringBindingPattern(exception, (identNode) -> {
            verifyIdent(identNode, contextString);
          });
        } else {
          // ECMA 12.4.1 constraints
          verifyIdent((IdentNode) exception, "catch argument");
        }
        // Nashorn extension: catch clause can have optional condition.
        // So, a single try can have more than one catch clause each with it's own condition.
        Expression ifExpression;
        if (_syntax_extension_ && type == IF) {
          NEXT();
          // Get the exception condition.
          ifExpression = expression();
        } else {
          ifExpression = null;
        }
        expect(RPAREN);

        var catchBlock = newBlock();
        try {
          // Get CATCH body.
          var catchBody = getBlock(true);
          var catchNode = new CatchNode(catchLine, catchToken, finish, exception, ifExpression, catchBody, false);
          appendStatement(catchNode);
        } finally {
          restoreBlock(catchBlock);
          catchBlocks.add(new Block(catchBlock.getToken(), finish, catchBlock.getFlags() | Block.IS_SYNTHETIC, catchBlock.getStatements()));
        }
        // If unconditional catch then should to be the end.
        if (ifExpression == null) {
          break;
        }
      }
      // Prepare to capture finally statement.
      Block finallyStatements = null;
      if (type == FINALLY) {
        NEXT();
        finallyStatements = getBlock(true);
      }
      // Need at least one catch or a finally.
      if (catchBlocks.isEmpty() && finallyStatements == null) {
        throw error(AbstractParser.message("missing.catch.or.finally"), tryToken);
      }
      var tryNode = new TryNode(tryLine, tryToken, finish, tryBody, catchBlocks, finallyStatements);
      // Add try.
      assert lc.peek() == outer;
      appendStatement(tryNode);
    } finally {
      restoreBlock(outer);
    }
    appendStatement(new BlockStatement(startLine, new Block(tryToken, finish, outer.getFlags() | Block.IS_SYNTHETIC, outer.getStatements())));
  }

  /**
   * DebuggerStatement :
   *      debugger ;
   *
   * See 12.15
   *
   * Parse debugger statement.
   */
  void debuggerStatement() {
    // Capture DEBUGGER token.
    final int debuggerLine = line;
    final long debuggerToken = token;
    // DEBUGGER tested in caller.
    NEXT();
    ENDofLINE();
    appendStatement(new DebuggerNode(debuggerLine, debuggerToken, finish));
  }

  /**
   * PrimaryExpression :
   *      this
   *      IdentifierReference
   *      Literal
   *      ArrayLiteral
   *      ObjectLiteral
   *      RegularExpressionLiteral
   *      TemplateLiteral
   *      CoverParenthesizedExpressionAndArrowParameterList
   *
   * CoverParenthesizedExpressionAndArrowParameterList :
   *      ( Expression )
   *      ( )
   *      ( ... BindingIdentifier )
   *      ( Expression , ... BindingIdentifier )
   *
   * Parse primary expression.
   * @return Expression node.
   */
  Expression primaryExpression() {
    // Capture first token.
    var primaryLine = line;
    var primaryToken = token;
    return switch (type) {
      case STRING, ESCSTRING, DECIMAL, HEXADECIMAL, OCTAL, BINARY_NUMBER, FLOATING, REGEX, XML -> getLiteral();
      case TEMPLATE, TEMPLATE_HEAD -> templateLiteral();
      case EXECSTRING -> execString(primaryLine, primaryToken);
      case LBRACKET -> arrayLiteral();
      case LBRACE -> objectLiteral();
      case OCTAL_LEGACY -> throw error(AbstractParser.message("no.octal"), token);
      case FALSE -> {
        NEXT();
        yield LiteralNode.newInstance(primaryToken, finish, false);
      }
      case TRUE -> {
        NEXT();
        yield LiteralNode.newInstance(primaryToken, finish, true);
      }
      case NULL -> {
        NEXT();
        yield LiteralNode.newInstance(primaryToken, finish);
      }
      case THIS -> {
        var name = type.getName();
        NEXT();
        markThis(lc);
        yield new IdentNode(primaryToken, finish, name);
      }
      case IDENT -> {
        var ident = getIdent();
        if (ident == null) {
          yield null;
        }
        detectSpecialProperty(ident);
        checkEscapedKeyword(ident);
        yield ident;
      }
      case LPAREN -> {
        NEXT();
        if (type == RPAREN) {
          // ()
          NEXTorEOL();
          expectDontAdvance(ARROW);
          yield new ExpressionList(primaryToken, finish, Collections.emptyList());
        } else if (type == ELLIPSIS) {
          // (...rest)
          var restParam = formalParameterList(false).get(0);
          expectDontAdvance(RPAREN);
          NEXTorEOL();
          expectDontAdvance(ARROW);
          yield new ExpressionList(primaryToken, finish, Collections.singletonList(restParam));
        }
        var expression = expression();
        expect(RPAREN);
        yield expression;
      }
      default -> {
        // In this context some operator tokens mark the start of a literal.
        if (lexer.scanLiteral(primaryToken, type, lineInfoReceiver)) {
          NEXT();
          yield getLiteral();
        }
        yield null;
      }
    };
  }

  /**
   * Convert execString to a call to $EXEC.
   *
   * @param primaryToken Original string token.
   * @return callNode to $EXEC.
   */
  CallNode execString(int primaryLine, long primaryToken) {
    // Synthesize an ident to call $EXEC.
    var execIdent = new IdentNode(primaryToken, finish, ScriptingFunctions.EXEC_NAME);
    // Skip over EXECSTRING.
    NEXT();
    // Set up argument list for call.
    // Skip beginning of edit string expression.
    expect(LBRACE);
    // Add the following expression to arguments.
    var arguments = List.of(expression());
    // Skip ending of edit string expression.
    expect(RBRACE);
    return new CallNode(primaryLine, primaryToken, finish, execIdent, arguments, false);
  }

  /**
   * ArrayLiteral :
   *      [ Elision? ]
   *      [ ElementList ]
   *      [ ElementList , Elision? ]
   *      [ expression for (LeftHandExpression in expression) ( (if ( Expression ) )? ]
   *
   * ElementList : Elision? AssignmentExpression
   *      ElementList , Elision? AssignmentExpression
   *
   * Elision :
   *      ,
   *      Elision ,
   *
   * See 12.1.4
   * JavaScript 1.8
   *
   * Parse array literal.
   * @return Expression node.
   */
  LiteralNode<Expression[]> arrayLiteral() {
    // Capture LBRACKET token.
    var arrayToken = token;
    // LBRACKET tested in caller.
    NEXT();
    // Prepare to accumulate elements.
    var elements = new ArrayList<Expression>();
    // Track elisions.
    var elision = true;
    var hasSpread = false;
    loop: for (;;) {
      long spreadToken = 0;
      switch (type) {
        case RBRACKET -> {
          NEXT();
          break loop;
        }
        case COMMARIGHT -> {
          NEXT();
          // If no prior expression
          if (elision) {
            elements.add(null);
          }
          elision = true;
        }
        default -> {
          if (type == ELLIPSIS) {
            hasSpread = true;
            spreadToken = token;
            NEXT();
          }
          if (!elision) {
            throw error(AbstractParser.message("expected.comma", type.getNameOrType()));
          }
          // Add expression element.
          var expression = assignmentExpression(false);
          if (expression != null) {
            if (spreadToken != 0) {
              expression = new UnaryNode(Token.recast(spreadToken, SPREAD_ARRAY), expression);
            }
            elements.add(expression);
          } else {
            expect(RBRACKET);
          }
          elision = false;
        }
      }
    }
    return LiteralNode.newInstance(arrayToken, finish, elements, hasSpread, elision);
  }

  /**
   * ObjectLiteral :
   *      { }
   *      { PropertyNameAndValueList } { PropertyNameAndValueList , }
   *
   * PropertyNameAndValueList :
   *      PropertyAssignment
   *      PropertyNameAndValueList , PropertyAssignment
   *
   * See 11.1.5
   *
   * Parse an object literal.
   * @return Expression node.
   */
  ObjectNode objectLiteral() {
    // Capture LBRACE token.
    var objectToken = token;
    // LBRACE tested in caller.
    NEXT();
    // Object context.
    // Prepare to accumulate elements.
    var elements = new ArrayList<PropertyNode>();
    var map = new HashMap<String, Integer>();
    // Create a block for the object literal.
    var commaSeen = true;
    loop: for (;;) {
      switch (type) {
        case RBRACE -> {
          NEXT();
          break loop;
        }
        case COMMARIGHT -> {
          if (commaSeen) {
            throw error(AbstractParser.message("expected.property.id", type.getNameOrType()));
          }
          NEXT();
          commaSeen = true;
        }
        default -> {
          if (!commaSeen) {
            throw error(AbstractParser.message("expected.comma", type.getNameOrType()));
          }
          commaSeen = false;
          // Get and add the next property.
          var property = propertyAssignment();
          if (property.isComputed()) {
            elements.add(property);
            break;
          }
          var key = property.getKeyName();
          var existing = map.get(key);
          if (existing == null) {
            map.put(key, elements.size());
            elements.add(property);
            break;
          }
          var existingProperty = elements.get(existing);
          // ECMA section 11.1.5 Object Initialiser
          // point # 4 on property assignment production
          var value = property.getValue();
          var getter = property.getGetter();
          var setter = property.getSetter();
          var prevValue = existingProperty.getValue();
          var prevGetter = existingProperty.getGetter();
          var prevSetter = existingProperty.getSetter();
          if (property.getKey() instanceof IdentNode && ((IdentNode) property.getKey()).isProtoPropertyName() && existingProperty.getKey() instanceof IdentNode && ((IdentNode) existingProperty.getKey()).isProtoPropertyName()) {
            throw error(AbstractParser.message("multiple.proto.key"), property.getToken());
          }
          if (value != null || prevValue != null) {
            map.put(key, elements.size());
            elements.add(property);
          } else if (getter != null) {
            assert prevGetter != null || prevSetter != null;
            elements.set(existing, existingProperty.setGetter(getter));
          } else if (setter != null) {
            assert prevGetter != null || prevSetter != null;
            elements.set(existing, existingProperty.setSetter(setter));
          }
        }
      }
    }
    return new ObjectNode(objectToken, finish, elements);
  }

  /**
   * LiteralPropertyName :
   *      IdentifierName
   *      StringLiteral
   *      NumericLiteral
   *
   * @return PropertyName node
   */
  PropertyKey literalPropertyName() {
    return switch (type) {
      case IDENT -> getIdent().setIsPropertyName();
      case OCTAL_LEGACY -> throw error(AbstractParser.message("no.octal"), token);
      case STRING, ESCSTRING, DECIMAL, HEXADECIMAL, OCTAL, BINARY_NUMBER, FLOATING -> getLiteral();
      default -> getIdentifierName().setIsPropertyName();
    };
  }

  /**
   * ComputedPropertyName :
   *      AssignmentExpression
   *
   * @return PropertyName node
   */
  Expression computedPropertyName() {
    expect(LBRACKET);
    var expression = assignmentExpression(false);
    expect(RBRACKET);
    return expression;
  }

  /**
   * PropertyName :
   *      LiteralPropertyName
   *      ComputedPropertyName
   *
   * @return PropertyName node
   */
  Expression propertyName() {
    return (type == LBRACKET) ? computedPropertyName() : (Expression) literalPropertyName();
  }

  /**
   * PropertyAssignment :
   *      PropertyName : AssignmentExpression
   *      get PropertyName ( ) { FunctionBody }
   *      set PropertyName ( PropertySetParameterList ) { FunctionBody }
   *
   * PropertySetParameterList :
   *      Identifier
   *
   * PropertyName :
   *      IdentifierName
   *      StringLiteral
   *      NumericLiteral
   *
   * See 11.1.5
   *
   * Parse an object literal property.
   * @return Property or reference node.
   */
  PropertyNode propertyAssignment() {
    // Capture firstToken.
    var propertyToken = token;
    var functionLine = line;
    Expression propertyName;
    boolean isIdentifier;
    var generator = false;
    if (type == MUL) {
      generator = true;
      NEXT();
    }
    var computed = type == LBRACKET;
    if (type == IDENT) {
      // Get IDENT.
      var ident = (String) expectValue(IDENT);
      if (type != COLON && (type != LPAREN)) {
        var getSetToken = propertyToken;
        switch (ident) {
          case GET_NAME -> {
            final PropertyFunction getter = propertyGetterFunction(getSetToken, functionLine);
            return new PropertyNode(propertyToken, finish, getter.key, null, getter.functionNode, null, false, getter.computed);
          }
          case SET_NAME -> {
            final PropertyFunction setter = propertySetterFunction(getSetToken, functionLine);
            return new PropertyNode(propertyToken, finish, setter.key, null, null, setter.functionNode, false, setter.computed);
          }
          // default: pass
        }
      }
      isIdentifier = true;
      var identNode = createIdentNode(propertyToken, finish, ident).setIsPropertyName();
      if (type == COLON && ident.equals("__proto__")) {
        identNode = identNode.setIsProtoPropertyName();
      }
      propertyName = identNode;
    } else {
      isIdentifier = false;
      propertyName = propertyName();
    }
    Expression propertyValue;
    if (generator) {
      expectDontAdvance(LPAREN);
    }
    if (type == LPAREN) {
      propertyValue = propertyMethodFunction(propertyName, propertyToken, functionLine, generator, FunctionNode.IS_METHOD, computed).functionNode;
    } else if (isIdentifier && (type == COMMARIGHT || type == RBRACE || type == ASSIGN)) {
      propertyValue = createIdentNode(propertyToken, finish, ((IdentNode) propertyName).getPropertyName());
      if (type == ASSIGN) {
        // TODO: if not destructuring, this is a SyntaxError
        var assignToken = token;
        NEXT();
        var rhs = assignmentExpression(false);
        propertyValue = verifyAssignment(assignToken, propertyValue, rhs);
      }
    } else {
      expect(COLON);
      defaultNames.push(propertyName);
      try {
        propertyValue = assignmentExpression(false);
      } finally {
        defaultNames.pop();
      }
    }
    return new PropertyNode(propertyToken, finish, propertyName, propertyValue, null, null, false, computed);
  }

  PropertyFunction propertyGetterFunction(long getSetToken, int functionLine) {
    return propertyGetterFunction(getSetToken, functionLine, FunctionNode.IS_METHOD);
  }

  PropertyFunction propertyGetterFunction(long getSetToken, int functionLine, int flags) {
    var computed = type == LBRACKET;
    var propertyName = propertyName();
    assert propertyName != null;
    var getterName = propertyName instanceof PropertyKey key ? key.getPropertyName() : getDefaultValidFunctionName(functionLine, false);
    var getNameNode = createIdentNode(propertyName.getToken(), finish, NameCodec.encode("get " + getterName));
    expect(LPAREN);
    expect(RPAREN);
    var functionNode = createParserContextFunctionNode(getNameNode, getSetToken, FunctionNode.Kind.GETTER, functionLine, Collections.<IdentNode>emptyList());
    functionNode.setFlag(flags);
    if (computed) {
      functionNode.setFlag(FunctionNode.IS_ANONYMOUS);
    }
    lc.push(functionNode);
    Block functionBody;
    try {
      functionBody = functionBody(functionNode);
    } finally {
      lc.pop(functionNode);
    }
    var function = createFunctionNode(functionNode, getSetToken, getNameNode, Collections.<IdentNode>emptyList(), FunctionNode.Kind.GETTER, functionLine, functionBody);
    return new PropertyFunction(propertyName, function, computed);
  }

  PropertyFunction propertySetterFunction(long getSetToken, int functionLine) {
    return propertySetterFunction(getSetToken, functionLine, FunctionNode.IS_METHOD);
  }

  PropertyFunction propertySetterFunction(long getSetToken, int functionLine, int flags) {
    var computed = type == LBRACKET;
    var propertyName = propertyName();
    assert propertyName != null;
    var setterName = propertyName instanceof PropertyKey key ? key.getPropertyName() : getDefaultValidFunctionName(functionLine, false);
    var setNameNode = createIdentNode(propertyName.getToken(), finish, NameCodec.encode("set " + setterName));
    expect(LPAREN);
    // be sloppy and allow missing setter parameter even though spec does not permit it!
    IdentNode argIdent;
    if (isBindingIdentifier()) {
      argIdent = getIdent();
      verifyIdent(argIdent, "setter argument");
    } else {
      argIdent = null;
    }
    expect(RPAREN);
    var parameters = new ArrayList<IdentNode>();
    if (argIdent != null) {
      parameters.add(argIdent);
    }
    var functionNode = createParserContextFunctionNode(setNameNode, getSetToken, FunctionNode.Kind.SETTER, functionLine, parameters);
    functionNode.setFlag(flags);
    if (computed) {
      functionNode.setFlag(FunctionNode.IS_ANONYMOUS);
    }
    lc.push(functionNode);
    Block functionBody;
    try {
      functionBody = functionBody(functionNode);
    } finally {
      lc.pop(functionNode);
    }
    var function = createFunctionNode(functionNode, getSetToken, setNameNode, parameters, FunctionNode.Kind.SETTER, functionLine, functionBody);
    return new PropertyFunction(propertyName, function, computed);
  }

  PropertyFunction propertyMethodFunction(Expression key, long methodToken, int methodLine, boolean generator, int flags, boolean computed) {
    assert key != null;
    var methodName = key instanceof PropertyKey pk ? pk.getPropertyName() : getDefaultValidFunctionName(methodLine, false);
    var methodNameNode = createIdentNode(((Node) key).getToken(), finish, methodName);
    var functionKind = generator ? FunctionNode.Kind.GENERATOR : FunctionNode.Kind.NORMAL;
    var functionNode = createParserContextFunctionNode(methodNameNode, methodToken, functionKind, methodLine, null);
    functionNode.setFlag(flags);
    if (computed) {
      functionNode.setFlag(FunctionNode.IS_ANONYMOUS);
    }
    lc.push(functionNode);
    try {
      var parameterBlock = newBlock();
      List<IdentNode> parameters;
      try {
        expect(LPAREN);
        parameters = formalParameterList(generator);
        functionNode.setParameters(parameters);
        expect(RPAREN);
      } finally {
        restoreBlock(parameterBlock);
      }
      var functionBody = functionBody(functionNode);
      functionBody = maybeWrapBodyInParameterBlock(functionBody, parameterBlock);
      var function = createFunctionNode(functionNode, methodToken, methodNameNode, parameters, functionKind, methodLine, functionBody);
      return new PropertyFunction(key, function, computed);
    } finally {
      lc.pop(functionNode);
    }
  }

  static class PropertyFunction {
    PropertyFunction(Expression key, FunctionNode function, boolean computed) {
      this.key = key;
      this.functionNode = function;
      this.computed = computed;
    }
    final Expression key;
    final FunctionNode functionNode;
    final boolean computed;
  }

  /**
   * LeftHandSideExpression :
   *      NewExpression
   *      CallExpression
   *
   * CallExpression :
   *      MemberExpression Arguments
   *      SuperCall
   *      CallExpression Arguments
   *      CallExpression [ Expression ]
   *      CallExpression . IdentifierName
   *
   * SuperCall :
   *      super Arguments
   *
   * See 11.2
   *
   * Parse left hand side expression.
   * @return Expression node.
   */
  Expression leftHandSideExpression() {
    var callLine = line;
    var callToken = token;
    Expression lhs = memberExpression();
    if (type == LPAREN) {
      var arguments = optimizeList(argumentList());
      // Catch special functions.
      if (lhs instanceof IdentNode ident) {
        detectSpecialFunction(ident);
        checkEscapedKeyword(ident);
      }
      lhs = new CallNode(callLine, callToken, finish, lhs, arguments, false);
    }
    loop: for (;;) {
      // Capture token.
      callLine = line;
      callToken = token;
      switch (type) {
        case LPAREN ->  {
          // Get NEW or FUNCTION arguments.
          var arguments = optimizeList(argumentList());
          // Create call node.
          lhs = new CallNode(callLine, callToken, finish, lhs, arguments, false);
        }
        case LBRACKET ->  {
          NEXT();
          // Get array index.
          var rhs = expression();
          expect(RBRACKET);
          // Create indexing node.
          lhs = new IndexNode(callToken, finish, lhs, rhs);
        }
        case PERIOD ->  {
          NEXT();
          var property = getIdentifierName();
          // Create property access node.
          lhs = new AccessNode(callToken, finish, lhs, property.getName());
        }
        case TEMPLATE, TEMPLATE_HEAD -> {
          // tagged template literal
          var arguments = templateLiteralArgumentList();
          // Create call node.
          lhs = new CallNode(callLine, callToken, finish, lhs, arguments, false);
        }
        default ->  {
          break loop;
        }
      }
    }
    return lhs;
  }

  /**
   * NewExpression :
   *      MemberExpression
   *      new NewExpression
   *
   * See 11.2
   *
   * Parse new expression.
   * @return Expression node.
   */
  Expression newExpression() {
    var newToken = token;
    // NEW is tested in caller.
    NEXT();
    if (type == PERIOD) {
      NEXT();
      if (type == IDENT && "target".equals(getValue())) {
        if (lc.getCurrentFunction().isProgram()) {
          throw error(AbstractParser.message("new.target.in.function"), token);
        }
        NEXT();
        markNewTarget(lc);
        return new IdentNode(newToken, finish, "new.target");
      } else {
        throw error(AbstractParser.message("expected.target"), token);
      }
    }
    // Get function base.
    var callLine = line;
    var constructor = memberExpression();
    if (constructor == null) {
      return null;
    }
    // Get arguments.
    ArrayList<Expression> arguments;
    // Allow for missing arguments.
    if (type == LPAREN) {
      arguments = argumentList();
    } else {
      arguments = new ArrayList<>();
    }

    // Nashorn extension: This is to support the following interface implementation
    // syntax:
    //
    //     var r = new java.lang.Runnable() {
    //         run: function() { println("run"); }
    //     };
    //
    // The object literal following the "new Constructor()" expression
    // is passed as an additional (last) argument to the constructor.
    if (_syntax_extension_ && type == LBRACE) {
      arguments.add(objectLiteral());
    }

    var callNode = new CallNode(callLine, constructor.getToken(), finish, constructor, optimizeList(arguments), true);
    return new UnaryNode(newToken, callNode);
  }

  /**
   * MemberExpression :
   *      PrimaryExpression
   *        FunctionExpression
   *        ClassExpression
   *        GeneratorExpression
   *      MemberExpression [ Expression ]
   *      MemberExpression . IdentifierName
   *      MemberExpression TemplateLiteral
   *      SuperProperty
   *      MetaProperty
   *      new MemberExpression Arguments
   *
   * SuperProperty :
   *      super [ Expression ]
   *      super . IdentifierName
   *
   * MetaProperty :
   *      NewTarget
   *
   * Parse member expression.
   * @return Expression node.
   */
  Expression memberExpression() {
    // Prepare to build operation.
    Expression lhs;
    var isSuper = false;
    switch (type) {
      case NEW -> { // Get new expression.
        lhs = newExpression();
      }
      case FUNCTION -> { // Get function expression.
        lhs = functionExpression(false, false);
      }
      case CLASS -> {
        lhs = classExpression(false);
      }
      case SUPER -> {
        var currentFunction = getCurrentNonArrowFunction();
        if (currentFunction.isMethod()) {
          var identToken = Token.recast(token, IDENT);
          NEXT();
          lhs = createIdentNode(identToken, finish, SUPER.getName());
          switch (type) {
            case LBRACKET, PERIOD -> {
              getCurrentNonArrowFunction().setFlag(FunctionNode.USES_SUPER);
              isSuper = true;
            }
            case LPAREN -> {
              if (currentFunction.isSubclassConstructor()) {
                lhs = ((IdentNode) lhs).setIsDirectSuper();
              } else {
                throw error(AbstractParser.message("invalid.super"), identToken);
              }
            }
            default -> {
              throw error(AbstractParser.message("invalid.super"), identToken);
            }
          }
        } else {
          lhs = primaryExpression();
        }
      }
      default -> { // Get primary expression.
        lhs = primaryExpression();
      }
    }
    loop: for (;;) {
      // Capture token.
      var callToken = token;
      switch (type) {
        case LBRACKET ->  {
          NEXT();
          // Get array index.
          var index = expression();
          expect(RBRACKET);
          // Create indexing node.
          lhs = new IndexNode(callToken, finish, lhs, index);
          if (isSuper) {
            isSuper = false;
            lhs = ((BaseNode) lhs).setIsSuper();
          }
        }
        case PERIOD ->  {
          if (lhs == null) {
            throw error(AbstractParser.message("expected.operand", type.getNameOrType()));
          }
          NEXT();
          var property = getIdentifierName();
          // Create property access node.
          lhs = new AccessNode(callToken, finish, lhs, property.getName());
          if (isSuper) {
            isSuper = false;
            lhs = ((BaseNode) lhs).setIsSuper();
          }
        }
        case TEMPLATE, TEMPLATE_HEAD -> {
          // tagged template literal
          var callLine = line;
          var arguments = templateLiteralArgumentList();
          lhs = new CallNode(callLine, callToken, finish, lhs, arguments, false);
        }
        default ->  {
          break loop;
        }
      }
    }
    return lhs;
  }

  /**
   * Arguments :
   *      ( )
   *      ( ArgumentList )
   *
   * ArgumentList :
   *      AssignmentExpression
   *      ... AssignmentExpression
   *      ArgumentList , AssignmentExpression
   *      ArgumentList , ... AssignmentExpression
   *
   * See 11.2
   *
   * Parse function call arguments.
   * @return Argument list.
   */
  ArrayList<Expression> argumentList() {
    // Prepare to accumulate list of arguments.
    var nodeList = new ArrayList<Expression>();
    // LPAREN tested in caller.
    NEXT();
    // Track commas.
    var first = true;
    while (type != RPAREN) {
      // Comma prior to every argument except the first.
      if (!first) {
        expect(COMMARIGHT);
      } else {
        first = false;
      }
      long spreadToken = 0;
      if (type == ELLIPSIS) {
        spreadToken = token;
        NEXT();
      }
      // Get argument expression.
      var expression = assignmentExpression(false);
      if (spreadToken != 0) {
        expression = new UnaryNode(Token.recast(spreadToken, TokenType.SPREAD_ARGUMENT), expression);
      }
      nodeList.add(expression);
    }
    expect(RPAREN);
    return nodeList;
  }

  static <T> List<T> optimizeList(ArrayList<T> list) {
    return switch (list.size()) {
      case 0 -> Collections.emptyList();
      case 1 -> Collections.singletonList(list.get(0));
      default -> { list.trimToSize(); yield list; }
    };
  }

  /**
   * FunctionDeclaration :
   *      function Identifier ( FormalParameterList? ) { FunctionBody }
   *
   * FunctionExpression :
   *      function Identifier? ( FormalParameterList? ) { FunctionBody }
   *
   * See 13
   *
   * Parse function declaration.
   * @param isStatement True if for is a statement.
   *
   * @return Expression node.
   */
  Expression functionExpression(boolean isStatement, boolean topLevel) {
    var functionToken = token;
    var functionLine = line;
    // FUNCTION is tested in caller.
    assert type == FUNCTION;
    NEXT();
    var generator = false;
    if (type == MUL) {
      generator = true;
      NEXT();
    }
    IdentNode name = null;
    if (isBindingIdentifier()) {
      if (type == YIELD && ((!isStatement && generator) || (isStatement && inGeneratorFunction()))) {
        // 12.1.1 Early SyntaxError if:
        // GeneratorExpression with BindingIdentifier yield
        // HoistableDeclaration with BindingIdentifier yield in generator function body
        expect(IDENT);
      }
      name = getIdent();
      verifyIdent(name, "function name");
    } else if (isStatement) {
      // Nashorn extension: anonymous function statements.
      // Do not allow anonymous function statement if extensions are now allowed.
      // But if we are reparsing then anon function statement is possible - because it was used as function expression in surrounding code.
      if (!_syntax_extension_ && reparsedFunction == null) {
        expect(IDENT);
      }
    }
    // name is null, generate anonymous name
    var isAnonymous = false;
    if (name == null) {
      var tmpName = getDefaultValidFunctionName(functionLine, isStatement);
      name = new IdentNode(functionToken, Token.descPosition(functionToken), tmpName);
      isAnonymous = true;
    }
    var functionKind = generator ? FunctionNode.Kind.GENERATOR : FunctionNode.Kind.NORMAL;
    var parameters = Collections.<IdentNode>emptyList();
    var functionNode = createParserContextFunctionNode(name, functionToken, functionKind, functionLine, parameters);
    lc.push(functionNode);
    Block functionBody = null;
    // Hide the current default name across function boundaries. E.g. "x3 = function x1() { function() {}}"
    // If we didn't hide the current default name, then the innermost anonymous function would receive "x3".
    hideDefaultName();
    try {
      var parameterBlock = newBlock();
      try {
        expect(LPAREN);
        parameters = formalParameterList(generator);
        functionNode.setParameters(parameters);
        expect(RPAREN);
      } finally {
        restoreBlock(parameterBlock);
      }
      functionBody = functionBody(functionNode);
      functionBody = maybeWrapBodyInParameterBlock(functionBody, parameterBlock);
    } finally {
      defaultNames.pop();
      lc.pop(functionNode);
    }
    if (isStatement) {
      if (topLevel) {
        functionNode.setFlag(FunctionNode.IS_DECLARED);
      } else {
        throw error(JSErrorType.SYNTAX_ERROR, AbstractParser.message("no.func.decl.here"), functionToken);
      }
      if (isArguments(name)) {
        lc.getCurrentFunction().setFlag(FunctionNode.DEFINES_ARGUMENTS);
      }
    }
    if (isAnonymous) {
      functionNode.setFlag(FunctionNode.IS_ANONYMOUS);
    }
    verifyParameterList(parameters, functionNode);
    var function = createFunctionNode(functionNode, functionToken, name, parameters, functionKind, functionLine, functionBody);
    if (isStatement) {
      if (isAnonymous) {
        appendStatement(new ExpressionStatement(functionLine, functionToken, finish, function));
        return function;
      }
      // mark ES6 block functions as lexically scoped
      var varFlags = topLevel ? 0 : VarNode.IS_LET;
      var varNode = new VarNode(functionLine, functionToken, finish, name, function, varFlags);
      if (topLevel) {
        functionDeclarations.add(varNode);
      } else {
        prependStatement(varNode); // Hoist to beginning of current block
      }
    }
    return function;
  }

  void verifyParameterList(List<IdentNode> parameters, ParserContextFunctionNode functionNode) {
    var duplicateParameter = functionNode.getDuplicateParameterBinding();
    if (duplicateParameter != null) {
      if (functionNode.getKind() == FunctionNode.Kind.ARROW || !functionNode.isSimpleParameterList()) {
        throw error(AbstractParser.message("param.redefinition", duplicateParameter.getName()), duplicateParameter.getToken());
      }
      var arity = parameters.size();
      var parametersSet = new HashSet<String>(arity);
      for (var i = arity - 1; i >= 0; i--) {
        var parameter = parameters.get(i);
        var parameterName = parameter.getName();
        if (parametersSet.contains(parameterName)) {
          // redefinition of parameter name (rename)
          parameterName = functionNode.uniqueName(parameterName);
          var parameterToken = parameter.getToken();
          parameters.set(i, new IdentNode(parameterToken, Token.descPosition(parameterToken), functionNode.uniqueName(parameterName)));
        }
        parametersSet.add(parameterName);
      }
    }
  }

  static Block maybeWrapBodyInParameterBlock(Block functionBody, ParserContextBlockNode parameterBlock) {
    assert functionBody.isFunctionBody();
    if (!parameterBlock.getStatements().isEmpty()) {
      parameterBlock.appendStatement(new BlockStatement(functionBody));
      return new Block(parameterBlock.getToken(), functionBody.getFinish(), (functionBody.getFlags() | Block.IS_PARAMETER_BLOCK) & ~Block.IS_BODY, parameterBlock.getStatements());
    }
    return functionBody;
  }

  String getDefaultValidFunctionName(int functionLine, boolean isStatement) {
    var defaultFunctionName = getDefaultFunctionName();
    if (isValidIdentifier(defaultFunctionName)) {
      if (isStatement) {
        // The name will be used as the LHS of a symbol assignment. We add the anonymous function
        // prefix to ensure that it can't clash with another variable.
        return CompilerConstants.ANON_FUNCTION_PREFIX.symbolName() + defaultFunctionName;
      }
      return defaultFunctionName;
    }
    return CompilerConstants.ANON_FUNCTION_PREFIX.symbolName() + functionLine;
  }

  static boolean isValidIdentifier(String name) {
    if (name == null || name.isEmpty()) {
      return false;
    }
    if (!Character.isJavaIdentifierStart(name.charAt(0))) {
      return false;
    }
    for (var i = 1; i < name.length(); ++i) {
      if (!Character.isJavaIdentifierPart(name.charAt(i))) {
        return false;
      }
    }
    return true;
  }

  String getDefaultFunctionName() {
    if (!defaultNames.isEmpty()) {
      var nameExpr = defaultNames.peek();
      if (nameExpr instanceof PropertyKey key) {
        markDefaultNameUsed();
        return key.getPropertyName();
      } else if (nameExpr instanceof AccessNode node) {
        markDefaultNameUsed();
        return node.getProperty();
      }
    }
    return null;
  }

  void markDefaultNameUsed() {
    defaultNames.pop();
    hideDefaultName();
  }

  void hideDefaultName() {
    // Can be any value as long as getDefaultFunctionName doesn't recognize it as something it can extract a value from.
    // Can't be null
    defaultNames.push("");
  }

  /**
   * FormalParameterList :
   *      Identifier
   *      FormalParameterList , Identifier
   *
   * See 13
   *
   * Parse function parameter list.
   * @return List of parameter nodes.
   */
  List<IdentNode> formalParameterList(boolean yield) {
    return formalParameterList(RPAREN, yield);
  }

  /**
   * Same as the other method of the same name - except that the end
   * token type expected is passed as argument to this method.
   *
   * FormalParameterList :
   *      Identifier
   *      FormalParameterList , Identifier
   *
   * See 13
   *
   * Parse function parameter list.
   * @return List of parameter nodes.
   */
  List<IdentNode> formalParameterList(TokenType endType, boolean yield) {
    // Prepare to gather parameters.
    var parameters = new ArrayList<IdentNode>();
    // Track commas.
    var first = true;
    while (type != endType) {
      // Comma prior to every argument except the first.
      if (!first) {
        expect(COMMARIGHT);
      } else {
        first = false;
      }
      var restParameter = false;
      if (type == ELLIPSIS) {
        NEXT();
        restParameter = true;
      }
      if (type == YIELD && yield) {
        expect(IDENT);
      }
      var paramToken = token;
      var paramLine = line;
      var contextString = "function parameter";
      IdentNode ident;
      if (isBindingIdentifier() || restParameter) {
        ident = bindingIdentifier(contextString);
        if (restParameter) {
          ident = ident.setIsRestParameter();
          // rest parameter must be last
          expectDontAdvance(endType);
          parameters.add(ident);
          break;
        } else if (type == ASSIGN) {
          NEXT();
          ident = ident.setIsDefaultParameter();
          if (type == YIELD && yield) {
            // error: yield in default expression
            expect(IDENT);
          }
          // default parameter
          var initializer = assignmentExpression(false);
          var currentFunction = lc.getCurrentFunction();
          if (currentFunction != null) {
            if (env._parse_only) {
              // keep what is seen in source "as is" and save it as parameter expression
              var assignment = new BinaryNode(Token.recast(paramToken, ASSIGN), ident, initializer);
              currentFunction.addParameterExpression(ident, assignment);
            } else {
              // desugar to: param = (param === undefined) ? initializer : param;
              // possible alternative: if (param === undefined) param = initializer;
              var test = new BinaryNode(Token.recast(paramToken, EQU), ident, newUndefinedLiteral(paramToken, finish));
              var value = new TernaryNode(Token.recast(paramToken, TERNARY), test, new JoinPredecessorExpression(initializer), new JoinPredecessorExpression(ident));
              var assignment = new BinaryNode(Token.recast(paramToken, ASSIGN), ident, value);
              lc.getFunctionBody(currentFunction).appendStatement(new ExpressionStatement(paramLine, assignment.getToken(), assignment.getFinish(), assignment));
            }
          }
        }
        var currentFunction = lc.getCurrentFunction();
        if (currentFunction != null) {
          currentFunction.addParameterBinding(ident);
          if (ident.isRestParameter() || ident.isDefaultParameter()) {
            currentFunction.setSimpleParameterList(false);
          }
        }
      } else {
        var pattern = bindingPattern();
        // Introduce synthetic temporary parameter to capture the object to be destructured.
        ident = createIdentNode(paramToken, pattern.getFinish(), String.format("arguments[%d]", parameters.size())).setIsDestructuredParameter();
        verifyDestructuringParameterBindingPattern(pattern, paramToken, paramLine, contextString);
        Expression value = ident;
        if (type == ASSIGN) {
          NEXT();
          ident = ident.setIsDefaultParameter();
          // binding pattern with initializer. desugar to: (param === undefined) ? initializer : param
          var initializer = assignmentExpression(false);
          if (env._parse_only) {
            // we don't want the synthetic identifier in parse only mode
            value = initializer;
          } else {
            // TODO initializer must not contain yield expression if yield=true (i.e. this is generator function's parameter list)
            var test = new BinaryNode(Token.recast(paramToken, EQU), ident, newUndefinedLiteral(paramToken, finish));
            value = new TernaryNode(Token.recast(paramToken, TERNARY), test, new JoinPredecessorExpression(initializer), new JoinPredecessorExpression(ident));
          }
        }
        var currentFunction = lc.getCurrentFunction();
        if (currentFunction != null) {
          // destructuring assignment
          var assignment = new BinaryNode(Token.recast(paramToken, ASSIGN), pattern, value);
          if (env._parse_only) {
            // in parse-only mode, represent source tree "as is"
            if (ident.isDefaultParameter()) {
              currentFunction.addParameterExpression(ident, assignment);
            } else {
              currentFunction.addParameterExpression(ident, pattern);
            }
          } else {
            lc.getFunctionBody(currentFunction).appendStatement(new ExpressionStatement(paramLine, assignment.getToken(), assignment.getFinish(), assignment));
          }
        }
      }
      parameters.add(ident);
    }
    parameters.trimToSize();
    return parameters;
  }

  void verifyDestructuringParameterBindingPattern(Expression pattern, long paramToken, int paramLine, String contextString) {
    verifyDestructuringBindingPattern(pattern, (identNode) -> {
      verifyIdent(identNode, contextString);
      var currentFunction = lc.getCurrentFunction();
      if (currentFunction != null) {
        // declare function-scope variables for destructuring bindings
        if (!env._parse_only) {
          lc.getFunctionBody(currentFunction).appendStatement(new VarNode(paramLine, Token.recast(paramToken, VAR), pattern.getFinish(), identNode, null));
        }
        // detect duplicate bounds names in parameter list
        currentFunction.addParameterBinding(identNode);
        currentFunction.setSimpleParameterList(false);
      }
    });
  }

  /**
   * FunctionBody :
   *      SourceElements?
   *
   * See 13
   *
   * Parse function body.
   * @return function node (body.)
   */
  Block functionBody(ParserContextFunctionNode functionNode) {
    long lastToken;
    ParserContextBlockNode body = null;
    var bodyToken = token;
    var bodyFinish = 0;
    boolean parseBody;
    Object endParserState = null;
    try {
      // Create a new function block.
      body = newBlock();
      assert functionNode != null;
      var functionId = functionNode.getId();
      parseBody = reparsedFunction == null || functionId <= reparsedFunction.getFunctionNodeId();

      // Nashorn extension: expression closures
      // Example:
      //   function square(x) x * x;
      //   print(square(3));
      if ((_syntax_extension_ || functionNode.getKind() == FunctionNode.Kind.ARROW) && type != LBRACE) {
        // just expression as function body
        var expr = assignmentExpression(false);
        lastToken = previousToken;
        functionNode.setLastToken(previousToken);
        assert lc.getCurrentBlock() == lc.getFunctionBody(functionNode);
        // EOL uses length field to store the line number
        var lastFinish = Token.descPosition(lastToken) + (Token.descType(lastToken) == EOL ? 0 : Token.descLength(lastToken));
        // Only create the return node if we aren't skipping nested functions.
        // Note that we aren't skipping parsing of these extended functions; they're considered to be small anyway.
        // Also, they don't end with a single well known token, so it'd be very hard to get correctly
        // (see the note below for reasoning on skipping happening before instead of after RBRACE for details).
        if (parseBody) {
          functionNode.setFlag(FunctionNode.HAS_EXPRESSION_BODY);
          var returnNode = new ReturnNode(functionNode.getLineNumber(), expr.getToken(), lastFinish, expr);
          appendStatement(returnNode);
        }
      } else {
        expectDontAdvance(LBRACE);
        if (parseBody || !skipFunctionBody(functionNode)) {
          NEXT();
          // Gather the function elements.
          var prevFunctionDecls = functionDeclarations;
          functionDeclarations = new ArrayList<>();
          try {
            sourceElements(0);
            addFunctionDeclarations(functionNode);
          } finally {
            functionDeclarations = prevFunctionDecls;
          }
          // lastToken = token;
          if (parseBody) {
            // Since the lexer can read ahead and lexify some number of tokens in advance and have them buffered in the TokenStream,
            // we need to produce a lexer state as it was just before it lexified RBRACE, and not whatever is its current (quite possibly well read ahead) state.
            endParserState = new ParserState(Token.descPosition(token), line, linePosition);
            // NOTE: you might wonder why do we capture/restore parser state before RBRACE instead of after RBRACE;
            // after all, we could skip the below "expect(RBRACE);" if we captured the state after it.
            // The reason is that RBRACE is a well-known token that we can expect and will never involve us getting into a weird lexer state, and as such is a great reparse point.
            // Typical example of a weird lexer state after RBRACE would be:
            //   function this_is_skipped() { ... } "use ...";
            // because lexer is doing weird off-by-one maneuvers around string literal quotes.
            // Instead of compensating for the possibility of a string literal (or similar) after RBRACE, we'll rather just restart parsing from this well-known, friendly token instead.
          }
        }
        bodyFinish = finish;
        functionNode.setLastToken(token);
        expect(RBRACE);
      }
    } finally {
      restoreBlock(body);
    }
    // NOTE: we can only do alterations to the function node after restoreFunctionNode.
    assert body != null;
    if (parseBody) {
      functionNode.setEndParserState(endParserState);
    } else if (!body.getStatements().isEmpty()) {
      // This is to ensure the body is empty when !parseBody but we couldn't skip parsing it (see skipFunctionBody() for possible reasons).
      // While it is not exactly necessary for correctness to enforce empty bodies in nested functions that were supposed to be skipped,
      // we do assert it as an invariant in few places in the compiler pipeline,
      // so for consistency's sake we'll throw away nested bodies early if we were supposed to skip 'em.
      body.setStatements(Collections.<Statement>emptyList());
    }
    if (reparsedFunction != null) {
      // We restore the flags stored in the function's ScriptFunctionData that we got when we first eagerly parsed the code.
      // We're doing it because some flags would be set based on the content of the function,
      // or even content of its nested functions, most of which are normally skipped during an on-demand compilation.
      var data = reparsedFunction.getScriptFunctionData(functionNode.getId());
      if (data != null) {
        // Data can be null if when we originally parsed the file, we removed the function declaration as it was dead code.
        functionNode.setFlag(data.getFunctionFlags());
        // This compensates for missing markEval() in case the function contains an inner function that contains eval(),
        // that now we didn't discover since we skipped the inner function.
        if (functionNode.hasNestedEval()) {
          assert functionNode.hasScopeBlock();
          body.setFlag(Block.NEEDS_SCOPE);
        }
      }
    }
    return new Block(bodyToken, bodyFinish, body.getFlags() | Block.IS_BODY, body.getStatements());
  }

  boolean skipFunctionBody(ParserContextFunctionNode functionNode) {
    if (reparsedFunction == null) {
      // Not reparsing, so don't skip any function body.
      return false;
    }
    // Skip to the RBRACE of this function, and continue parsing from there.
    var data = reparsedFunction.getScriptFunctionData(functionNode.getId());
    if (data == null) {
      // Nested function is not known to the reparsed function.
      // This can happen if the FunctionNode was in dead code that was removed.
      // Both FoldConstants and Lower prune dead code.
      // In that case, the FunctionNode was dropped before a RecompilableScriptFunctionData could've been created for it.
      return false;
    }
    var parserState = (ParserState) data.getEndParserState();
    assert parserState != null;
    if (k < stream.last() && start < parserState.position && parserState.position <= Token.descPosition(stream.get(stream.last()))) {
      // RBRACE is already in the token stream, so fast forward to it
      for (; k < stream.last(); k++) {
        var nextToken = stream.get(k + 1);
        if (Token.descPosition(nextToken) == parserState.position && Token.descType(nextToken) == RBRACE) {
          token = stream.get(k);
          type = Token.descType(token);
          NEXT();
          assert type == RBRACE && start == parserState.position;
          return true;
        }
      }
    }
    stream.reset();
    lexer = parserState.createLexer(source, lexer, stream, scripting && _syntax_extension_);
    line = parserState.line;
    linePosition = parserState.linePosition;
    // Doesn't really matter, but it's safe to treat it as if there were a semicolon before the RBRACE.
    type = SEMICOLON;
    scanFirstToken();
    return true;
  }

  /**
   * Encapsulates part of the state of the parser, enough to reconstruct the state of both parser and lexer for resuming parsing after skipping a function body.
   */
  static class ParserState implements Serializable {

    private final int position;
    private final int line;
    private final int linePosition;

    ParserState(int position, int line, int linePosition) {
      this.position = position;
      this.line = line;
      this.linePosition = linePosition;
    }

    Lexer createLexer(Source source, Lexer lexer, TokenStream stream, boolean scripting) {
      var newLexer = new Lexer(source, position, lexer.limit - position, stream, scripting, true);
      newLexer.restoreState(new Lexer.State(position, Integer.MAX_VALUE, line, -1, linePosition, SEMICOLON));
      return newLexer;
    }

    private static final long serialVersionUID = 1;
  }

  void addFunctionDeclarations(ParserContextFunctionNode functionNode) {
    VarNode lastDecl = null;
    for (var i = functionDeclarations.size() - 1; i >= 0; i--) {
      var decl = functionDeclarations.get(i);
      if (lastDecl == null && decl instanceof VarNode) {
        decl = lastDecl = ((VarNode) decl).setFlag(VarNode.IS_LAST_FUNCTION_DECLARATION);
        functionNode.setFlag(FunctionNode.HAS_FUNCTION_DECLARATIONS);
      }
      prependStatement(decl);
    }
  }

  RuntimeNode referenceError(Expression lhs, Expression rhs, boolean earlyError) {
    if (env._parse_only || earlyError) {
      throw error(JSErrorType.REFERENCE_ERROR, AbstractParser.message("invalid.lvalue"), lhs.getToken());
    }
    var args = new ArrayList<Expression>();
    args.add(lhs);
    if (rhs == null) {
      args.add(LiteralNode.newInstance(lhs.getToken(), lhs.getFinish()));
    } else {
      args.add(rhs);
    }
    args.add(LiteralNode.newInstance(lhs.getToken(), lhs.getFinish(), lhs.toString()));
    return new RuntimeNode(lhs.getToken(), lhs.getFinish(), RuntimeNode.Request.REFERENCE_ERROR, args);
  }

  /**
   * PostfixExpression :
   *      LeftHandSideExpression
   *      LeftHandSideExpression ++ // [no LineTerminator here]
   *      LeftHandSideExpression -- // [no LineTerminator here]
   *
   * See 11.3
   *
   * UnaryExpression :
   *      PostfixExpression
   *      delete UnaryExpression
   *      void UnaryExpression
   *      typeof UnaryExpression
   *      ++ UnaryExpression
   *      -- UnaryExpression
   *      + UnaryExpression
   *      - UnaryExpression
   *      ~ UnaryExpression
   *      ! UnaryExpression
   *
   * See 11.4
   *
   * Parse unary expression.
   * @return Expression node.
   */
  Expression unaryExpression() {
    // var unaryLine = line;
    var unaryToken = token;
    switch (type) {
      case ADD, SUB -> {
        var opType = type;
        NEXT();
        var expr = unaryExpression();
        return new UnaryNode(Token.recast(unaryToken, (opType == TokenType.ADD) ? TokenType.POS : TokenType.NEG), expr);
      }
      case DELETE, VOID, TYPEOF, BIT_NOT, NOT ->  {
        NEXT();
        var expr = unaryExpression();
        return new UnaryNode(unaryToken, expr);
      }
      case INCPREFIX, DECPREFIX -> {
        var opType = type;
        NEXT();
        var lhs = leftHandSideExpression();
        // ++, -- without operand..
        if (lhs == null) {
          throw error(AbstractParser.message("expected.lvalue", type.getNameOrType()));
        }
        return verifyIncDecExpression(unaryToken, opType, lhs, false);
      }
      // default: pass
    }
    var expression = leftHandSideExpression();
    if (last != EOL) {
      switch (type) {
        case INCPREFIX, DECPREFIX -> {
          var opToken = token;
          var opType = type;
          var lhs = expression;
          // ++, -- without operand..
          if (lhs == null) {
            throw error(AbstractParser.message("expected.lvalue", type.getNameOrType()));
          }
          NEXT();
          return verifyIncDecExpression(opToken, opType, lhs, true);
        }
        // default: pass
      }
    }
    if (expression == null) {
      throw error(AbstractParser.message("expected.operand", type.getNameOrType()));
    }
    return expression;
  }

  Expression verifyIncDecExpression(long unaryToken, TokenType opType, Expression lhs, boolean isPostfix) {
    assert lhs != null;
    if (!(lhs instanceof AccessNode || lhs instanceof IndexNode || lhs instanceof IdentNode)) {
      return referenceError(lhs, null, env._early_lvalue_error);
    }
    if (lhs instanceof IdentNode ident) {
      if (!checkIdentLValue(ident)) {
        return referenceError(lhs, null, false);
      }
      verifyIdent(ident, "operand for " + opType.getName() + " operator");
    }
    return incDecExpression(unaryToken, opType, lhs, isPostfix);
  }

  /**
   * {@code
   * MultiplicativeExpression :
   *      UnaryExpression
   *      MultiplicativeExpression * UnaryExpression
   *      MultiplicativeExpression / UnaryExpression
   *      MultiplicativeExpression % UnaryExpression
   *
   * See 11.5
   *
   * AdditiveExpression :
   *      MultiplicativeExpression
   *      AdditiveExpression + MultiplicativeExpression
   *      AdditiveExpression - MultiplicativeExpression
   *
   * See 11.6
   *
   * ShiftExpression :
   *      AdditiveExpression
   *      ShiftExpression << AdditiveExpression
   *      ShiftExpression >> AdditiveExpression
   *      ShiftExpression >>> AdditiveExpression
   *
   * See 11.7
   *
   * RelationalExpression :
   *      ShiftExpression
   *      RelationalExpression < ShiftExpression
   *      RelationalExpression > ShiftExpression
   *      RelationalExpression <= ShiftExpression
   *      RelationalExpression >= ShiftExpression
   *      RelationalExpression instanceof ShiftExpression
   *      RelationalExpression in ShiftExpression // if !noIf
   *
   * See 11.8
   *
   *      RelationalExpression
   *      EqualityExpression == RelationalExpression
   *      EqualityExpression != RelationalExpression
   *      EqualityExpression === RelationalExpression
   *      EqualityExpression !== RelationalExpression
   *
   * See 11.9
   *
   * BitwiseANDExpression :
   *      EqualityExpression
   *      BitwiseANDExpression & EqualityExpression
   *
   * BitwiseXORExpression :
   *      BitwiseANDExpression
   *      BitwiseXORExpression ^ BitwiseANDExpression
   *
   * BitwiseORExpression :
   *      BitwiseXORExpression
   *      BitwiseORExpression | BitwiseXORExpression
   *
   * See 11.10
   *
   * LogicalANDExpression :
   *      BitwiseORExpression
   *      LogicalANDExpression && BitwiseORExpression
   *
   * LogicalORExpression :
   *      LogicalANDExpression
   *      LogicalORExpression || LogicalANDExpression
   *
   * See 11.11
   *
   * ConditionalExpression :
   *      LogicalORExpression
   *      LogicalORExpression ? AssignmentExpression : AssignmentExpression
   *
   * See 11.12
   *
   * AssignmentExpression :
   *      ConditionalExpression
   *      LeftHandSideExpression AssignmentOperator AssignmentExpression
   *
   * AssignmentOperator :
   *      = *= /= %= += -= <<= >>= >>>= &= ^= |=
   *
   * See 11.13
   *
   * Expression :
   *      AssignmentExpression
   *      Expression , AssignmentExpression
   *
   * See 11.14
   * }
   *
   * Parse expression.
   * @return Expression node.
   */
  protected Expression expression() { // This method protected is so that subclass can get details at expression start point!
    // Include commas in expression parsing.
    return expression(false);
  }

  Expression expression(boolean noIn) {
    var assignmentExpression = assignmentExpression(noIn);
    while (type == COMMARIGHT) {
      var commaToken = token;
      NEXT();
      var rhsRestParameter = false;
      if (type == ELLIPSIS) {
        // (a, b, ...rest) is not a valid expression, unless we're parsing the parameter list of an arrow function (we need to throw the right error).
        // But since the rest parameter is always last, at least we know that the expression has to end here and be followed by RPAREN and ARROW, so peek ahead.
        if (isRestParameterEndOfArrowFunctionParameterList()) {
          NEXT();
          rhsRestParameter = true;
        }
      }
      var rhs = assignmentExpression(noIn);
      if (rhsRestParameter) {
        rhs = ((IdentNode) rhs).setIsRestParameter();
        // Our only valid move is to end Expression here and continue with ArrowFunction.
        // We've already checked that this is the parameter list of an arrow function (see above).
        // RPAREN is next, so we'll finish the binary expression and drop out of the loop.
        assert type == RPAREN;
      }
      assignmentExpression = new BinaryNode(commaToken, assignmentExpression, rhs);
    }
    return assignmentExpression;
  }

  Expression expression(int minPrecedence, boolean noIn) {
    return expression(unaryExpression(), minPrecedence, noIn);
  }

  JoinPredecessorExpression joinPredecessorExpression() {
    return new JoinPredecessorExpression(expression());
  }

  Expression expression(Expression exprLhs, int minPrecedence, boolean noIn) {
    // Get the precedence of the next operator.
    var precedence = type.getPrecedence();
    var lhs = exprLhs;
    // While greater precedence.
    while (type.isOperator(noIn) && precedence >= minPrecedence) {
      // Capture the operator token.
      var op = token;
      if (type == TERNARY) {
        // Skip operator.
        NEXT();
        // Pass expression. Middle expression of a conditional expression can be a "in" expression - even in the contexts where "in" is not permitted.
        var trueExpr = expression(unaryExpression(), ASSIGN.getPrecedence(), false);
        expect(COLON);
        // Fail expression.
        var falseExpr = expression(unaryExpression(), ASSIGN.getPrecedence(), noIn);
        // Build up node.
        lhs = new TernaryNode(op, lhs, new JoinPredecessorExpression(trueExpr), new JoinPredecessorExpression(falseExpr));
      } else {
        // Skip operator.
        NEXT();
        // Get the next primary expression.
        Expression rhs;
        var isAssign = Token.descType(op) == ASSIGN;
        if (isAssign) {
          defaultNames.push(lhs);
        }
        try {
          rhs = unaryExpression();
          // Get precedence of next operator.
          var nextPrecedence = type.getPrecedence();
          // Subtask greater precedence.
          while (type.isOperator(noIn) && (nextPrecedence > precedence || nextPrecedence == precedence && !type.isLeftAssociative())) {
            rhs = expression(rhs, nextPrecedence, noIn);
            nextPrecedence = type.getPrecedence();
          }
        } finally {
          if (isAssign) {
            defaultNames.pop();
          }
        }
        lhs = verifyAssignment(op, lhs, rhs);
      }
      precedence = type.getPrecedence();
    }
    return lhs;
  }

  /**
   * AssignmentExpression.
   *
   * AssignmentExpression[In, Yield] :
   *   ConditionalExpression[?In, ?Yield]
   *   [+Yield] YieldExpression[?In]
   *   ArrowFunction[?In, ?Yield]
   *   LeftHandSideExpression[?Yield] = AssignmentExpression[?In, ?Yield]
   *   LeftHandSideExpression[?Yield] AssignmentOperator AssignmentExpression[?In, ?Yield]
   *
   * @param noIn {@code true} if IN operator should be ignored.
   * @return the assignment expression
   */
  protected Expression assignmentExpression(boolean noIn) { // This method protected is so that subclass can get details at assignment expression start point!
    if (type == YIELD && inGeneratorFunction()) {
      return yieldExpression(noIn);
    }
    var startToken = token;
    var startLine = line;
    var exprLhs = conditionalExpression(noIn);
    if (type == ARROW) {
      if (checkNoLineTerminator()) {
        Expression paramListExpr;
        if (exprLhs instanceof ExpressionList) {
          paramListExpr = (((ExpressionList) exprLhs).getExpressions().isEmpty() ? null : ((ExpressionList) exprLhs).getExpressions().get(0));
        } else {
          paramListExpr = exprLhs;
        }
        return arrowFunction(startToken, startLine, paramListExpr);
      }
    }
    assert !(exprLhs instanceof ExpressionList);
    if (isAssignmentOperator(type)) {
      var isAssign = type == ASSIGN;
      if (isAssign) {
        defaultNames.push(exprLhs);
      }
      try {
        var assignToken = token;
        NEXT();
        var exprRhs = assignmentExpression(noIn);
        return verifyAssignment(assignToken, exprLhs, exprRhs);
      } finally {
        if (isAssign) {
          defaultNames.pop();
        }
      }
    } else {
      return exprLhs;
    }
  }

  /**
   * Is type one of {@code = *= /= %= += -= <<= >>= >>>= &= ^= |=}?
   */
  static boolean isAssignmentOperator(TokenType type) {
    return switch (type) {
      case ASSIGN,
        ASSIGN_ADD, ASSIGN_DIV, ASSIGN_MOD, ASSIGN_MUL, ASSIGN_SUB,
        ASSIGN_BIT_AND, ASSIGN_BIT_OR, ASSIGN_BIT_XOR,
        ASSIGN_SAR, ASSIGN_SHL, ASSIGN_SHR -> true;
      default -> false;
    };
  }

  /**
   * ConditionalExpression.
   */
  Expression conditionalExpression(boolean noIn) {
    return expression(TERNARY.getPrecedence(), noIn);
  }

  /**
   * ArrowFunction.
   *
   * @param startToken start token of the ArrowParameters expression
   * @param functionLine start line of the arrow function
   * @param paramListExpr ArrowParameters expression or {@code null} for {@code ()} (empty list)
   */
  Expression arrowFunction(long startToken, int functionLine, Expression paramListExpr) {
    // caller needs to check that there's no LineTerminator between parameter list and arrow
    assert type != ARROW || checkNoLineTerminator();
    expect(ARROW);
    var functionToken = Token.recast(startToken, ARROW);
    var name = new IdentNode(functionToken, Token.descPosition(functionToken), NameCodec.encode("=>:") + functionLine);
    var functionNode = createParserContextFunctionNode(name, functionToken, FunctionNode.Kind.ARROW, functionLine, null);
    functionNode.setFlag(FunctionNode.IS_ANONYMOUS);
    lc.push(functionNode);
    try {
      var parameterBlock = newBlock();
      List<IdentNode> parameters;
      try {
        parameters = convertArrowFunctionParameterList(paramListExpr, functionLine);
        functionNode.setParameters(parameters);
        if (!functionNode.isSimpleParameterList()) {
          markEvalInArrowParameterList(parameterBlock);
        }
      } finally {
        restoreBlock(parameterBlock);
      }
      var functionBody = functionBody(functionNode);
      functionBody = maybeWrapBodyInParameterBlock(functionBody, parameterBlock);
      verifyParameterList(parameters, functionNode);
      var function = createFunctionNode(functionNode, functionToken, name, parameters, FunctionNode.Kind.ARROW, functionLine, functionBody);
      return function;
    } finally {
      lc.pop(functionNode);
    }
  }

  void markEvalInArrowParameterList(ParserContextBlockNode parameterBlock) {
    var iter = lc.getFunctions();
    var current = iter.next();
    var parent = iter.next();
    if (parent.getFlag(FunctionNode.HAS_EVAL) != 0) {
      // we might have flagged has-eval in the parent function during parsing the parameter list,
      // if the parameter list contains eval; must tag arrow function as has-eval.
      for (var st : parameterBlock.getStatements()) {
        st.accept(new NodeVisitor<LexicalContext>(new LexicalContext()) {
          @Override
          public boolean enterCallNode(CallNode callNode) {
            if (callNode.getFunction() instanceof IdentNode && ((IdentNode) callNode.getFunction()).getName().equals("eval")) {
              current.setFlag(FunctionNode.HAS_EVAL);
            }
            return true;
          }
        });
      }
      // TODO: function containing the arrow function should not be flagged has-eval
    }
  }

  List<IdentNode> convertArrowFunctionParameterList(Expression paramListExpr, int functionLine) {
    List<IdentNode> parameters;
    if (paramListExpr == null) {
      // empty parameter list, i.e. () =>
      parameters = Collections.emptyList();
    } else if (paramListExpr instanceof IdentNode || paramListExpr.isTokenType(ASSIGN) || isDestructuringLhs(paramListExpr)) {
      parameters = Collections.singletonList(verifyArrowParameter(paramListExpr, 0, functionLine));
    } else if (paramListExpr instanceof BinaryNode && Token.descType(paramListExpr.getToken()) == COMMARIGHT) {
      parameters = new ArrayList<>();
      var car = paramListExpr;
      do {
        var cdr = ((BinaryNode) car).rhs();
        parameters.add(0, verifyArrowParameter(cdr, parameters.size(), functionLine));
        car = ((BinaryNode) car).lhs();
      } while (car instanceof BinaryNode && Token.descType(car.getToken()) == COMMARIGHT);
      parameters.add(0, verifyArrowParameter(car, parameters.size(), functionLine));
    } else {
      throw error(AbstractParser.message("expected.arrow.parameter"), paramListExpr.getToken());
    }
    return parameters;
  }

  IdentNode verifyArrowParameter(Expression param, int index, int paramLine) {
    var contextString = "function parameter";
    if (param instanceof IdentNode ident) {
      verifyIdent(ident, contextString);
      var currentFunction = lc.getCurrentFunction();
      if (currentFunction != null) {
        currentFunction.addParameterBinding(ident);
      }
      return ident;
    }
    assert param != null;
    if (param.isTokenType(ASSIGN)) {
      var lhs = ((BinaryNode) param).lhs();
      var paramToken = lhs.getToken();
      var initializer = ((BinaryNode) param).rhs();
      if (lhs instanceof IdentNode ident) {
        // default parameter
        var currentFunction = lc.getCurrentFunction();
        if (currentFunction != null) {
          if (env._parse_only) {
            currentFunction.addParameterExpression(ident, param);
          } else {
            var test = new BinaryNode(Token.recast(paramToken, EQU), ident, newUndefinedLiteral(paramToken, finish));
            var value = new TernaryNode(Token.recast(paramToken, TERNARY), test, new JoinPredecessorExpression(initializer), new JoinPredecessorExpression(ident));
            var assignment = new BinaryNode(Token.recast(paramToken, ASSIGN), ident, value);
            lc.getFunctionBody(currentFunction).appendStatement(new ExpressionStatement(paramLine, assignment.getToken(), assignment.getFinish(), assignment));
          }
          currentFunction.addParameterBinding(ident);
          currentFunction.setSimpleParameterList(false);
        }
        return ident;
      } else if (isDestructuringLhs(lhs)) {
        // binding pattern with initializer
        // Introduce synthetic temporary parameter to capture the object to be destructured.
        var ident = createIdentNode(paramToken, param.getFinish(), String.format("arguments[%d]", index)).setIsDestructuredParameter().setIsDefaultParameter();
        verifyDestructuringParameterBindingPattern(param, paramToken, paramLine, contextString);
        var currentFunction = lc.getCurrentFunction();
        if (currentFunction != null) {
          if (env._parse_only) {
            currentFunction.addParameterExpression(ident, param);
          } else {
            var test = new BinaryNode(Token.recast(paramToken, EQU), ident, newUndefinedLiteral(paramToken, finish));
            var value = new TernaryNode(Token.recast(paramToken, TERNARY), test, new JoinPredecessorExpression(initializer), new JoinPredecessorExpression(ident));
            var assignment = new BinaryNode(Token.recast(paramToken, ASSIGN), param, value);
            lc.getFunctionBody(currentFunction).appendStatement(new ExpressionStatement(paramLine, assignment.getToken(), assignment.getFinish(), assignment));
          }
        }
        return ident;
      }
    } else if (isDestructuringLhs(param)) {
      // binding pattern
      var paramToken = param.getToken();
      // Introduce synthetic temporary parameter to capture the object to be destructured.
      var ident = createIdentNode(paramToken, param.getFinish(), String.format("arguments[%d]", index)).setIsDestructuredParameter();
      verifyDestructuringParameterBindingPattern(param, paramToken, paramLine, contextString);
      var currentFunction = lc.getCurrentFunction();
      if (currentFunction != null) {
        if (env._parse_only) {
          currentFunction.addParameterExpression(ident, param);
        } else {
          var assignment = new BinaryNode(Token.recast(paramToken, ASSIGN), param, ident);
          lc.getFunctionBody(currentFunction).appendStatement(new ExpressionStatement(paramLine, assignment.getToken(), assignment.getFinish(), assignment));
        }
      }
      return ident;
    }
    throw error(AbstractParser.message("invalid.arrow.parameter"), param.getToken());
  }

  boolean checkNoLineTerminator() {
    assert type == ARROW;
    if (last == RPAREN) {
      return true;
    } else if (last == IDENT) {
      return true;
    }
    for (var i = k - 1; i >= 0; i--) {
      var t = T(i);
      switch (t) {
        case RPAREN, IDENT -> { return true; }
        case EOL -> { return false; }
        case COMMENT -> { continue; }
        default -> { return t.getKind() == TokenKind.FUTURE; }
      }
    }
    return false;
  }

  /**
   * Peek ahead to see if what follows after the ellipsis is a rest parameter
   * at the end of an arrow function parameter list.
   */
  boolean isRestParameterEndOfArrowFunctionParameterList() {
    assert type == ELLIPSIS;
    // find IDENT, RPAREN, ARROW, in that order, skipping over EOL (where allowed) and COMMENT
    var i = 1;
    A: for (;;) {
      switch (T(k + i++)) {
        case IDENT -> { break A; }
        case EOL, COMMENT -> { continue; }
        default -> { return false; }
      }
    }
    B: for (;;) {
      switch (T(k + i++)) {
        case RPAREN -> { break  B; }
        case EOL, COMMENT -> { continue; }
        default -> { return false; }
      }
    }
    C: for (;;) {
      switch (T(k + i++)) {
        case ARROW -> { break C; }
        case COMMENT -> { continue; }
        default -> { return false; }
      }
    }
    return true;
  }

  /**
   * Parse an end of line.
   */
  void ENDofLINE() {
    switch (type) {
      case SEMICOLON, EOL -> NEXT();
      case RPAREN, RBRACKET, RBRACE, EOF -> {} // pass
      default -> { if (last != EOL) expect(SEMICOLON); }
    }
  }

  /**
   * Parse untagged template literal as string concatenation.
   */
  Expression templateLiteral() {
    assert type == TEMPLATE || type == TEMPLATE_HEAD;
    var noSubstitutionTemplate = type == TEMPLATE;
    var lastLiteralToken = token;
    var literal = getLiteral();
    if (noSubstitutionTemplate) {
      return literal;
    }
    if (env._parse_only) {
      var exprs = new ArrayList<Expression>();
      exprs.add(literal);
      TokenType lastLiteralType;
      do {
        var expression = expression();
        if (type != TEMPLATE_MIDDLE && type != TEMPLATE_TAIL) {
          throw error(AbstractParser.message("unterminated.template.expression"), token);
        }
        exprs.add(expression);
        lastLiteralType = type;
        literal = getLiteral();
        exprs.add(literal);
      } while (lastLiteralType == TEMPLATE_MIDDLE);
      return new TemplateLiteral(exprs);
    } else {
      Expression concat = literal;
      TokenType lastLiteralType;
      do {
        var expression = expression();
        if (type != TEMPLATE_MIDDLE && type != TEMPLATE_TAIL) {
          throw error(AbstractParser.message("unterminated.template.expression"), token);
        }
        concat = new BinaryNode(Token.recast(lastLiteralToken, TokenType.ADD), concat, expression);
        lastLiteralType = type;
        lastLiteralToken = token;
        literal = getLiteral();
        concat = new BinaryNode(Token.recast(lastLiteralToken, TokenType.ADD), concat, literal);
      } while (lastLiteralType == TEMPLATE_MIDDLE);
      return concat;
    }
  }

  /**
   * Parse tagged template literal as argument list.
   * @return argument list for a tag function call (template object, ...substitutions)
   */
  List<Expression> templateLiteralArgumentList() {
    assert type == TEMPLATE || type == TEMPLATE_HEAD;
    var argumentList = new ArrayList<Expression>();
    var rawStrings = new ArrayList<Expression>();
    var cookedStrings = new ArrayList<Expression>();
    argumentList.add(null); // filled at the end
    var templateToken = token;
    var hasSubstitutions = type == TEMPLATE_HEAD;
    addTemplateLiteralString(rawStrings, cookedStrings);
    if (hasSubstitutions) {
      TokenType lastLiteralType;
      do {
        var expression = expression();
        if (type != TEMPLATE_MIDDLE && type != TEMPLATE_TAIL) {
          throw error(AbstractParser.message("unterminated.template.expression"), token);
        }
        argumentList.add(expression);
        lastLiteralType = type;
        addTemplateLiteralString(rawStrings, cookedStrings);
      } while (lastLiteralType == TEMPLATE_MIDDLE);
    }
    var rawStringArray = LiteralNode.newInstance(templateToken, finish, rawStrings);
    var cookedStringArray = LiteralNode.newInstance(templateToken, finish, cookedStrings);
    if (!env._parse_only) {
      var templateObject = new RuntimeNode(templateToken, finish, RuntimeNode.Request.GET_TEMPLATE_OBJECT, rawStringArray, cookedStringArray);
      argumentList.set(0, templateObject);
    } else {
      argumentList.set(0, rawStringArray);
    }
    return optimizeList(argumentList);
  }

  void addTemplateLiteralString(ArrayList<Expression> rawStrings, ArrayList<Expression> cookedStrings) {
    var stringToken = token;
    var rawString = lexer.valueOfRawString(stringToken);
    var cookedString = (String) getValue();
    NEXT();
    rawStrings.add(LiteralNode.newInstance(stringToken, finish, rawString));
    cookedStrings.add(LiteralNode.newInstance(stringToken, finish, cookedString));
  }

  /**
   * Parse a module.
   *
   * Module :
   *      ModuleBody?
   *
   * ModuleBody :
   *      ModuleItemList
   */
  FunctionNode module(String moduleName) {
    // Make a pseudo-token for the script holding its start and length.
    var functionStart = Math.min(Token.descPosition(Token.withDelimiter(token)), finish);
    var functionToken = Token.toDesc(FUNCTION, functionStart, source.getLength() - functionStart);
    var functionLine = line;
    var ident = new IdentNode(functionToken, Token.descPosition(functionToken), moduleName);
    var script = createParserContextFunctionNode(ident, functionToken, FunctionNode.Kind.MODULE, functionLine, Collections.<IdentNode>emptyList());
    lc.push(script);
    var module = new ParserContextModuleNode(moduleName);
    lc.push(module);
    var body = newBlock();
    functionDeclarations = new ArrayList<>();
    moduleBody();
    addFunctionDeclarations(script);
    functionDeclarations = null;
    restoreBlock(body);
    body.setFlag(Block.NEEDS_SCOPE);
    var programBody = new Block(functionToken, finish, body.getFlags() | Block.IS_SYNTHETIC | Block.IS_BODY, body.getStatements());
    lc.pop(module);
    lc.pop(script);
    script.setLastToken(token);
    expect(EOF);
    script.setModule(module.createModule());
    return createFunctionNode(script, functionToken, ident, Collections.<IdentNode>emptyList(), FunctionNode.Kind.MODULE, functionLine, programBody);
  }

  /**
   * Parse module body.
   *
   * ModuleBody :
   *      ModuleItemList
   *
   * ModuleItemList :
   *      ModuleItem
   *      ModuleItemList ModuleItem
   *
   * ModuleItem :
   *      ImportDeclaration
   *      ExportDeclaration
   *      StatementListItem
   */
  void moduleBody() {
    loop: while (type != EOF) {
      switch (type) {
        case EOF -> { break loop; }
        case IMPORT -> importDeclaration();
        case EXPORT -> exportDeclaration();
        default -> statement(true, 0, false, false); // StatementListItem
      }
    }
  }

  /**
   * Parse import declaration.
   *
   * ImportDeclaration :
   *     import ImportClause FromClause ;
   *     import ModuleSpecifier ;
   * ImportClause :
   *     ImportedDefaultBinding
   *     NameSpaceImport
   *     NamedImports
   *     ImportedDefaultBinding , NameSpaceImport
   *     ImportedDefaultBinding , NamedImports
   * ImportedDefaultBinding :
   *     ImportedBinding
   * ModuleSpecifier :
   *     StringLiteral
   * ImportedBinding :
   *     BindingIdentifier
   */
  void importDeclaration() {
    var startPosition = start;
    expect(IMPORT);
    var module = lc.getCurrentModule();
    if (type == STRING || type == ESCSTRING) {
      // import ModuleSpecifier ;
      var moduleSpecifier = createIdentNode(token, finish, (String) getValue());
      NEXT();
      module.addModuleRequest(moduleSpecifier);
    } else {
      // import ImportClause FromClause ;
      List<Module.ImportEntry> importEntries;
      if (type == MUL) {
        importEntries = Collections.singletonList(nameSpaceImport(startPosition));
      } else if (type == LBRACE) {
        importEntries = namedImports(startPosition);
      } else if (isBindingIdentifier()) {
        // ImportedDefaultBinding
        var importedDefaultBinding = bindingIdentifier("ImportedBinding");
        var defaultImport = Module.ImportEntry.importSpecifier(importedDefaultBinding, startPosition, finish);
        if (type == COMMARIGHT) {
          NEXT();
          importEntries = new ArrayList<>();
          if (type == MUL) {
            importEntries.add(nameSpaceImport(startPosition));
          } else if (type == LBRACE) {
            importEntries.addAll(namedImports(startPosition));
          } else {
            throw error(AbstractParser.message("expected.named.import"));
          }
        } else {
          importEntries = Collections.singletonList(defaultImport);
        }
      } else {
        throw error(AbstractParser.message("expected.import"));
      }
      var moduleSpecifier = fromClause();
      module.addModuleRequest(moduleSpecifier);
      for (var i = 0; i < importEntries.size(); i++) {
        module.addImportEntry(importEntries.get(i).withFrom(moduleSpecifier, finish));
      }
    }
    expect(SEMICOLON);
  }

  /**
   * NameSpaceImport :
   *     * as ImportedBinding
   *
   * @param startPosition the start of the import declaration
   * @return imported binding identifier
   */
  Module.ImportEntry nameSpaceImport(int startPosition) {
    assert type == MUL;
    var starName = createIdentNode(Token.recast(token, IDENT), finish, Module.STAR_NAME);
    NEXT();
    var asToken = token;
    var as = (String) expectValue(IDENT);
    if (!"as".equals(as)) {
      throw error(AbstractParser.message("expected.as"), asToken);
    }
    var localNameSpace = bindingIdentifier("ImportedBinding");
    return Module.ImportEntry.importSpecifier(starName, localNameSpace, startPosition, finish);
  }

  /**
   * NamedImports :
   *     { }
   *     { ImportsList }
   *     { ImportsList , }
   * ImportsList :
   *     ImportSpecifier
   *     ImportsList , ImportSpecifier
   * ImportSpecifier :
   *     ImportedBinding
   *     IdentifierName as ImportedBinding
   * ImportedBinding :
   *     BindingIdentifier
   */
  List<Module.ImportEntry> namedImports(int startPosition) {
    assert type == LBRACE;
    NEXT();
    var importEntries = new ArrayList<Module.ImportEntry>();
    while (type != RBRACE) {
      var bindingIdentifier = isBindingIdentifier();
      var nameToken = token;
      var importName = getIdentifierName();
      if (type == IDENT && "as".equals(getValue())) {
        NEXT();
        var localName = bindingIdentifier("ImportedBinding");
        importEntries.add(Module.ImportEntry.importSpecifier(importName, localName, startPosition, finish));
      } else if (!bindingIdentifier) {
        throw error(AbstractParser.message("expected.binding.identifier"), nameToken);
      } else {
        importEntries.add(Module.ImportEntry.importSpecifier(importName, startPosition, finish));
      }
      if (type == COMMARIGHT) {
        NEXT();
      } else {
        break;
      }
    }
    expect(RBRACE);
    return importEntries;
  }

  /**
   * FromClause :
   *     from ModuleSpecifier
   */
  IdentNode fromClause() {
    var fromToken = token;
    var name = (String) expectValue(IDENT);
    if (!"from".equals(name)) {
      throw error(AbstractParser.message("expected.from"), fromToken);
    }
    if (type == STRING || type == ESCSTRING) {
      var moduleSpecifier = createIdentNode(Token.recast(token, IDENT), finish, (String) getValue());
      NEXT();
      return moduleSpecifier;
    } else {
      throw error(expectMessage(STRING));
    }
  }

  /**
   * Parse export declaration.
   *
   * ExportDeclaration :
   *     export * FromClause ;
   *     export ExportClause FromClause ;
   *     export ExportClause ;
   *     export VariableStatement
   *     export Declaration
   *     export default HoistableDeclaration[Default]
   *     export default ClassDeclaration[Default]
   *     export default [lookahead !in {function, class}] AssignmentExpression[In] ;
   */
  void exportDeclaration() {
    expect(EXPORT);
    var startPosition = start;
    var module = lc.getCurrentModule();
    switch (type) {
      case MUL ->  {
        var starName = createIdentNode(Token.recast(token, IDENT), finish, Module.STAR_NAME);
        NEXT();
        var moduleRequest = fromClause();
        expect(SEMICOLON);
        module.addModuleRequest(moduleRequest);
        module.addStarExportEntry(Module.ExportEntry.exportStarFrom(starName, moduleRequest, startPosition, finish));
      }
      case LBRACE ->  {
        var exportEntries = exportClause(startPosition);
        if (type == IDENT && "from".equals(getValue())) {
          var moduleRequest = fromClause();
          module.addModuleRequest(moduleRequest);
          for (var exportEntry : exportEntries) {
            module.addIndirectExportEntry(exportEntry.withFrom(moduleRequest, finish));
          }
        } else {
          for (var exportEntry : exportEntries) {
            module.addLocalExportEntry(exportEntry);
          }
        }
        expect(SEMICOLON);
      }
      case DEFAULT -> {
        var defaultName = createIdentNode(Token.recast(token, IDENT), finish, Module.DEFAULT_NAME);
        NEXT();
        Expression assignmentExpression;
        IdentNode ident;
        var lineNumber = line;
        var rhsToken = token;
        boolean declaration;
        switch (type) {
          case FUNCTION -> {
            assignmentExpression = functionExpression(false, true);
            ident = ((FunctionNode) assignmentExpression).getIdent();
            declaration = true;
          }
          case CLASS -> {
            assignmentExpression = classDeclaration(true);
            ident = ((ClassNode) assignmentExpression).getIdent();
            declaration = true;
          }
          default -> {
            assignmentExpression = assignmentExpression(false);
            ident = null;
            declaration = false;
          }
        }
        if (ident != null) {
          module.addLocalExportEntry(Module.ExportEntry.exportDefault(defaultName, ident, startPosition, finish));
        } else {
          ident = createIdentNode(Token.recast(rhsToken, IDENT), finish, Module.DEFAULT_EXPORT_BINDING_NAME);
          lc.appendStatementToCurrentNode(new VarNode(lineNumber, Token.recast(rhsToken, LET), finish, ident, assignmentExpression));
          if (!declaration) {
            expect(SEMICOLON);
          }
          module.addLocalExportEntry(Module.ExportEntry.exportDefault(defaultName, ident, startPosition, finish));
        }
      }
      case VAR, LET, CONST -> {
        var statements = lc.getCurrentBlock().getStatements();
        var previousEnd = statements.size();
        variableStatement(type);
        for (var statement : statements.subList(previousEnd, statements.size())) {
          if (statement instanceof VarNode node) {
            module.addLocalExportEntry(Module.ExportEntry.exportSpecifier(node.getName(), startPosition, finish));
          }
        }
      }
      case CLASS -> {
        var  classDeclaration = classDeclaration(false);
        module.addLocalExportEntry(Module.ExportEntry.exportSpecifier(classDeclaration.getIdent(), startPosition, finish));
      }
      case FUNCTION -> {
        var functionDeclaration = (FunctionNode) functionExpression(true, true);
        module.addLocalExportEntry(Module.ExportEntry.exportSpecifier(functionDeclaration.getIdent(), startPosition, finish));
      }
      default -> {
        throw error(AbstractParser.message("invalid.export"), token);
      }
    }
  }

  /**
   * ExportClause :
   *     { }
   *     { ExportsList }
   *     { ExportsList , }
   * ExportsList :
   *     ExportSpecifier
   *     ExportsList , ExportSpecifier
   * ExportSpecifier :
   *     IdentifierName
   *     IdentifierName as IdentifierName
   *
   * @return a list of ExportSpecifiers
   */
  List<Module.ExportEntry> exportClause(int startPosition) {
    assert type == LBRACE;
    NEXT();
    var exports = new ArrayList<Module.ExportEntry>();
    while (type != RBRACE) {
      var localName = getIdentifierName();
      if (type == IDENT && "as".equals(getValue())) {
        NEXT();
        var exportName = getIdentifierName();
        exports.add(Module.ExportEntry.exportSpecifier(exportName, localName, startPosition, finish));
      } else {
        exports.add(Module.ExportEntry.exportSpecifier(localName, startPosition, finish));
      }
      if (type == COMMARIGHT) {
        NEXT();
      } else {
        break;
      }
    }
    expect(RBRACE);
    return exports;
  }

  static void markEval(ParserContext lc) {
    var iter = lc.getFunctions();
    var flaggedCurrentFn = false;
    while (iter.hasNext()) {
      var fn = iter.next();
      if (!flaggedCurrentFn) {
        fn.setFlag(FunctionNode.HAS_EVAL);
        flaggedCurrentFn = true;
        if (fn.getKind() == FunctionNode.Kind.ARROW) {
          // possible use of this in an eval that's nested in an arrow function, e.g.:
          // function fun(){ return (() => eval("this"))(); };
          markThis(lc);
          markNewTarget(lc);
        }
      } else {
        fn.setFlag(FunctionNode.HAS_NESTED_EVAL);
      }
      var body = lc.getFunctionBody(fn);
      // NOTE: it is crucial to mark the body of the outer function as needing scope even when we skip parsing a nested function.
      // functionBody() contains code to compensate for the lack of invoking this method when the parser skips a nested function.
      body.setFlag(Block.NEEDS_SCOPE);
      fn.setFlag(FunctionNode.HAS_SCOPE_BLOCK);
    }
  }

  void prependStatement(Statement statement) {
    lc.prependStatementToCurrentNode(statement);
  }

  void appendStatement(Statement statement) {
    lc.appendStatementToCurrentNode(statement);
  }

  static void markSuperCall(ParserContext lc) {
    var iter = lc.getFunctions();
    while (iter.hasNext()) {
      var fn = iter.next();
      if (fn.getKind() != FunctionNode.Kind.ARROW) {
        assert fn.isSubclassConstructor();
        fn.setFlag(FunctionNode.HAS_DIRECT_SUPER);
        break;
      }
    }
  }

  ParserContextFunctionNode getCurrentNonArrowFunction() {
    var iter = lc.getFunctions();
    while (iter.hasNext()) {
      var fn = iter.next();
      if (fn.getKind() != FunctionNode.Kind.ARROW) {
        return fn;
      }
    }
    return null;
  }

  static void markThis(ParserContext lc) {
    var iter = lc.getFunctions();
    while (iter.hasNext()) {
      var fn = iter.next();
      fn.setFlag(FunctionNode.USES_THIS);
      if (fn.getKind() != FunctionNode.Kind.ARROW) {
        break;
      }
    }
  }

  static void markNewTarget(ParserContext lc) {
    var iter = lc.getFunctions();
    while (iter.hasNext()) {
      var fn = iter.next();
      if (fn.getKind() != FunctionNode.Kind.ARROW) {
        if (!fn.isProgram()) {
          fn.setFlag(FunctionNode.USES_NEW_TARGET);
        }
        break;
      }
    }
  }

  boolean inGeneratorFunction() {
    return lc.getCurrentFunction().getKind() == FunctionNode.Kind.GENERATOR;
  }

  @Override
  public String toString() {
    return "'JavaScript Parsing'";
  }
}
