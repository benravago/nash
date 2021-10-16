package es.parser;

import java.util.HashMap;
import java.util.Map;

import es.ir.IdentNode;
import es.ir.LiteralNode;
import es.parser.Lexer.LexerToken;
import es.parser.Lexer.RegexToken;
import es.runtime.ECMAErrors;
import es.runtime.ErrorManager;
import es.runtime.JSErrorType;
import es.runtime.ParserException;
import es.runtime.Source;
import es.runtime.regexp.RegExpFactory;
import static es.parser.TokenType.*;

/**
 * Base class for parsers.
 */
public abstract class AbstractParser {

  // Source to parse.
  protected final Source source;

  // Error manager to report errors.
  protected final ErrorManager errors;

  // Stream of lex tokens to parse.
  protected TokenStream stream;

  // Index of current token.
  protected int k;

  // Previous token - accessible to sub classes
  protected long previousToken;

  // Descriptor of current token.
  protected long token;

  // Type of current token.
  protected TokenType type;

  // Type of last token.
  protected TokenType last;

  // Start position of current token.
  protected int start;

  // Finish position of previous token.
  protected int finish;

  // Current line number.
  protected int line;

  // Position of last EOL + 1.
  protected int linePosition;

  // Lexer used to scan source content.
  protected Lexer lexer;

  // What should line numbers be counted from?
  protected final int lineOffset;

  private final Map<String, String> canonicalNames = new HashMap<>();

  /**
   * Construct a parser.
   *
   * @param source     Source to parse.
   * @param errors     Error reporting manager.
   * @param lineOffset Offset from which lines should be counted
   */
  protected AbstractParser(Source source, ErrorManager errors, int lineOffset) {
    if (source.getLength() > Token.LENGTH_MASK) {
      throw new RuntimeException("Source exceeds size limit of " + Token.LENGTH_MASK + " bytes");
    }
    this.source = source;
    this.errors = errors;
    this.k = -1;
    this.token = Token.toDesc(EOL, 0, 1);
    this.type = EOL;
    this.last = EOL;
    this.lineOffset = lineOffset;
  }

  /**
   * Get the ith token.
   *
   * @param i Index of token.
   * @return  the token
   */
  protected final long getToken(int i) {
    // Make sure there are enough tokens available.
    while (i > stream.last()) {
      // If we need to buffer more for lookahead.
      if (stream.isFull()) {
        stream.grow();
      }
      // Get more tokens.
      lexer.lexify();
    }
    return stream.get(i);
  }

  /**
   * Return the tokenType of the ith token.
   *
   * @param i Index of token
   * @return the token type
   */
  protected final TokenType T(int i) {
    // Get token descriptor and extract tokenType.
    return Token.descType(getToken(i));
  }

  /**
   * Seek next token that is not an EOL or comment.
   *
   * @return tokenType of next token.
   */
  protected final TokenType NEXT() {
    do {
      NEXTorEOL();
    } while (type == EOL || type == COMMENT);
    return type;
  }

  /**
   * Seek next token or EOL (skipping comments.)
   *
   * @return tokenType of next token.
   */
  protected final TokenType NEXTorEOL() {
    do {
      nextToken();
      if (type == DIRECTIVE_COMMENT) {
        checkDirectiveComment();
      }
    } while (type == COMMENT || type == DIRECTIVE_COMMENT);
    return type;
  }

  // sourceURL= after directive comment
  private static final String SOURCE_URL_PREFIX = "sourceURL=";

  // currently only @sourceURL=foo supported
  void checkDirectiveComment() {
    // if already set, ignore this one
    if (source.getExplicitURL() != null) {
      return;
    }
    var comment = (String) lexer.getValueOf(token);
    var len = comment.length();
    // 4 characters for directive comment marker //@\s or //#\s
    if (len > 4 && comment.substring(4).startsWith(SOURCE_URL_PREFIX)) {
      source.setExplicitURL(comment.substring(4 + SOURCE_URL_PREFIX.length()));
    }
  }

  /**
   * Seek next token.
   *
   * @return tokenType of next token.
   */
  private TokenType nextToken() {
    // Capture last token type, but ignore comments (which are irrelevant for the purpose of newline detection).
    if (type != COMMENT) {
      last = type;
    }
    if (type != EOF) {
      // Set up next token.
      k++;
      var lastToken = token;
      previousToken = token;
      token = getToken(k);
      type = Token.descType(token);
      // do this before the start is changed below
      if (last != EOL) {
        finish = start + Token.descLength(lastToken);
      }
      if (type == EOL) {
        line = Token.descLength(token);
        linePosition = Token.descPosition(token);
      } else {
        start = Token.descPosition(token);
      }
    }
    return type;
  }

  /**
   * Get the message string for a message ID and arguments
   *
   * @param msgId The Message ID
   * @param args  The arguments
   * @return The message string
   */
  protected static String message(String msgId, String... args) {
    return ECMAErrors.getMessage("parser.error." + msgId, args);
  }

  /**
   * Report an error.
   *
   * @param message    Error message.
   * @param errorToken Offending token.
   * @return ParserException upon failure. Caller should throw and not ignore
   */
  protected final ParserException error(String message, long errorToken) {
    return error(JSErrorType.SYNTAX_ERROR, message, errorToken);
  }

  /**
   * Report an error.
   *
   * @param errorType  The error type
   * @param message    Error message.
   * @param errorToken Offending token.
   * @return ParserException upon failure. Caller should throw and not ignore
   */
  protected final ParserException error(JSErrorType errorType, String message, long errorToken) {
    var position = Token.descPosition(errorToken);
    var lineNum = source.getLine(position);
    var columnNum = source.getColumn(position);
    var formatted = ErrorManager.format(message, source, lineNum, columnNum, errorToken);
    return new ParserException(errorType, formatted, source, lineNum, columnNum, errorToken);
  }

  /**
   * Report an error.
   *
   * @param message Error message.
   * @return ParserException upon failure. Caller should throw and not ignore
   */
  protected final ParserException error(String message) {
    return error(JSErrorType.SYNTAX_ERROR, message);
  }

  /**
   * Report an error.
   *
   * @param errorType  The error type
   * @param message    Error message.
   * @return ParserException upon failure. Caller should throw and not ignore
   */
  protected final ParserException error(JSErrorType errorType, String message) {
    // TODO - column needs to account for tabs.
    var position = Token.descPosition(token);
    var column = position - linePosition;
    var formatted = ErrorManager.format(message, source, line, column, token);
    return new ParserException(errorType, formatted, source, line, column, token);
  }

  /**
   * Report a warning to the error manager.
   *
   * @param errorType  The error type of the warning
   * @param message    Warning message.
   * @param errorToken error token
   */
  protected final void warning(JSErrorType errorType, String message, long errorToken) {
    errors.warning(error(errorType, message, errorToken));
  }

  /**
   * Generate 'expected' message.
   *
   * @param expected Expected tokenType.
   * @return the message string
   */
  protected final String expectMessage(TokenType expected) {
    var tokenString = Token.toString(source, token);
    String msg;
    if (expected == null) {
      msg = AbstractParser.message("expected.stmt", tokenString);
    } else {
      var expectedName = expected.getNameOrType();
      msg = AbstractParser.message("expected", expectedName, tokenString);
    }
    return msg;
  }

  /**
   * Check current token and advance to the next token.
   *
   * @param expected Expected tokenType.
   * @throws ParserException on unexpected token type
   */
  protected final void expect(TokenType expected) throws ParserException {
    expectDontAdvance(expected);
    NEXT();
  }

  /**
   * Check current token, but don't advance to the next token.
   *
   * @param expected Expected tokenType.
   *
   * @throws ParserException on unexpected token type
   */
  protected final void expectDontAdvance(TokenType expected) throws ParserException {
    if (type != expected) {
      throw error(expectMessage(expected));
    }
  }

  /**
   * Check next token, get its value and advance.
   *
   * @param  expected Expected tokenType.
   * @return The JavaScript value of the token
   * @throws ParserException on unexpected token type
   */
  protected final Object expectValue(TokenType expected) throws ParserException {
    if (type != expected) {
      throw error(expectMessage(expected));
    }
    var value = getValue();
    NEXT();
    return value;
  }

  /**
   * Get the value of the current token.
   *
   * @return JavaScript value of the token.
   */
  protected final Object getValue() {
    return getValue(token);
  }

  /**
   * Get the value of a specific token
   *
   * @param valueToken the token
   *
   * @return JavaScript value of the token
   */
  protected final Object getValue(long valueToken) {
    try {
      return lexer.getValueOf(valueToken);
    } catch (ParserException e) {
      errors.error(e);
    }

    return null;
  }

  /**
   * Get ident.
   *
   * @return Ident node.
   */
  protected final IdentNode getIdent() {
    // Capture IDENT token.
    var identToken = token;
    // Get IDENT.
    var ident = (String) expectValue(IDENT);
    if (ident == null) {
      return null;
    }
    // Create IDENT node.
    return createIdentNode(identToken, finish, ident);
  }

  /**
   * Creates a new {@link IdentNode} as if invoked with a {@link IdentNode#IdentNode(long, int, String) constructor} but making sure that the {@code name} is deduplicated within this parse job.

   * @param identToken the token for the new {@code IdentNode}
   * @param identFinish the finish for the new {@code IdentNode}
   * @param name the name for the new {@code IdentNode}. It will be de-duplicated.
   * @return a newly constructed {@code IdentNode} with the specified token, finish, and name; the name will be deduplicated.
   */
  protected IdentNode createIdentNode(long identToken, int identFinish, String name) {
    var existingName = canonicalNames.putIfAbsent(name, name);
    var canonicalName = existingName != null ? existingName : name;
    return new IdentNode(identToken, identFinish, canonicalName);
  }

  /**
   * Check if current token is in identifier name
   *
   * @return true if current token is an identifier name
   */
  protected final boolean isIdentifierName() {
    var kind = type.getKind();
    if (kind == TokenKind.KEYWORD || kind == TokenKind.FUTURE) {
      return true;
    }
    // only literals allowed are null, false and true
    if (kind == TokenKind.LITERAL) {
      return switch (type) {
        case FALSE, NULL, TRUE -> true;
        default -> false;
      };
    }
    // Fake out identifier.
    var identToken = Token.recast(token, IDENT);
    // Get IDENT.
    var ident = (String) getValue(identToken);
    return !ident.isEmpty() && Character.isJavaIdentifierStart(ident.charAt(0));
  }

  /**
   * Create an IdentNode from the current token
   *
   * @return an IdentNode representing the current token
   */
  protected final IdentNode getIdentifierName() {
    if (type == IDENT) {
      return getIdent();
    } else if (isIdentifierName()) {
      // Fake out identifier.
      var identToken = Token.recast(token, IDENT);
      // Get IDENT.
      var ident = (String) getValue(identToken);
      NEXT();
      // Create IDENT node.
      return createIdentNode(identToken, finish, ident);
    } else {
      expect(IDENT);
      return null;
    }
  }

  /**
   * Create a LiteralNode from the current token
   *
   * @return LiteralNode representing the current token
   * @throws ParserException if any literals fails to parse
   */
  protected final LiteralNode<?> getLiteral() throws ParserException {
    // Capture LITERAL token.
    var literalToken = token;
    // Create literal node.
    var value = getValue();
    // Advance to have a correct finish
    NEXT();
    LiteralNode<?> node = null;
    if (value == null) {
      node = LiteralNode.newInstance(literalToken, finish);
    } else if (value instanceof Number num) {
      node = LiteralNode.newInstance(literalToken, finish, num);
    } else if (value instanceof String str) {
      node = LiteralNode.newInstance(literalToken, finish, str);
    } else if (value instanceof LexerToken lex) {
      if (lex instanceof RegexToken re) {
        try {
          RegExpFactory.validate(re.getExpression(), re.getOptions());
        } catch (ParserException e) {
          throw error(e.getMessage());
        }
      }
      node = LiteralNode.newInstance(literalToken, finish, lex);
    } else {
      throw new AssertionError("unknown type for LiteralNode: " + value.getClass());
      // TODO: review use of assert instead of throw
    }
    return node;
  }

}
