package es.parser;

import java.io.Serializable;

import es.runtime.ECMAErrors;
import es.runtime.ErrorManager;
import es.runtime.JSErrorType;
import es.runtime.JSType;
import es.runtime.ParserException;
import es.runtime.Source;
import static es.parser.TokenType.*;

/**
 * Responsible for converting source content into a stream of tokens.
 */
public class Lexer extends Scanner {

  private static final long MIN_INT_L = Integer.MIN_VALUE;
  private static final long MAX_INT_L = Integer.MAX_VALUE;

  // Content source.
  private final Source source;

  // Buffered stream for tokens.
  private final TokenStream stream;

  // True if here and edit strings are supported.
  private final boolean scripting;

  // True if a nested scan. (scan to completion, no EOF.)
  private final boolean nested;

  // Pending new line number and position.
  int pendingLine;

  // Position of last EOL + 1.
  private int linePosition;

  // Type of last token added.
  private TokenType last;

  private final boolean pauseOnFunctionBody;
  private boolean pauseOnNextLeftBrace;

  private int templateExpressionOpenBraces;

  private static final String JAVASCRIPT_OTHER_WHITESPACE =
    "\u2028" + // line separator
    "\u2029" + // paragraph separator
    "\u00a0" + // Latin-1 space
    "\u1680" + // Ogham space mark
    "\u180e" + // separator, Mongolian vowel
    "\u2000" + // en quad
    "\u2001" + // em quad
    "\u2002" + // en space
    "\u2003" + // em space
    "\u2004" + // three-per-em space
    "\u2005" + // four-per-em space
    "\u2006" + // six-per-em space
    "\u2007" + // figure space
    "\u2008" + // punctuation space
    "\u2009" + // thin space
    "\u200a" + // hair space
    "\u202f" + // narrow no-break space
    "\u205f" + // medium mathematical space
    "\u3000" + // ideographic space
    "\ufeff" ; // byte order mark

  private static final String JAVASCRIPT_WHITESPACE_IN_REGEXP =
    "\\u000a" + // line feed
    "\\u000d" + // carriage return (ctrl-m)
    "\\u2028" + // line separator
    "\\u2029" + // paragraph separator
    "\\u0009" + // tab
    "\\u0020" + // ASCII space
    "\\u000b" + // tabulation line
    "\\u000c" + // ff (ctrl-l)
    "\\u00a0" + // Latin-1 space
    "\\u1680" + // Ogham space mark
    "\\u180e" + // separator, Mongolian vowel
    "\\u2000" + // en quad
    "\\u2001" + // em quad
    "\\u2002" + // en space
    "\\u2003" + // em space
    "\\u2004" + // three-per-em space
    "\\u2005" + // four-per-em space
    "\\u2006" + // six-per-em space
    "\\u2007" + // figure space
    "\\u2008" + // punctuation space
    "\\u2009" + // thin space
    "\\u200a" + // hair space
    "\\u202f" + // narrow no-break space
    "\\u205f" + // medium mathematical space
    "\\u3000" + // ideographic space
    "\\ufeff" ; // byte order mark

  static String unicodeEscape(char ch) {
    var sb = new StringBuilder();

    sb.append("\\u");

    var hex = Integer.toHexString(ch);
    for (var i = hex.length(); i < 4; i++) {
      sb.append('0');
    }
    sb.append(hex);

    return sb.toString();
  }

  /**
   * Constructor
   *
   * @param source    the source
   * @param stream    the token stream to lex
   */
  public Lexer(Source source, TokenStream stream) {
    this(source, stream, false);
  }

  /**
   * Constructor
   *
   * @param source    the source
   * @param stream    the token stream to lex
   * @param scripting are we in scripting mode
   */
  public Lexer(Source source, TokenStream stream, boolean scripting) {
    this(source, 0, source.getLength(), stream, scripting, false);
  }

  /**
   * Constructor
   *
   * @param source    the source
   * @param start     start position in source from which to start lexing
   * @param len       length of source segment to lex
   * @param stream    token stream to lex
   * @param scripting are we in scripting mode
   * @param pauseOnFunctionBody if true, lexer will return from {@link #lexify()} when it encounters a function body.
   *    This is used with the feature where the parser is skipping nested function bodies to avoid reading ahead unnecessarily when we skip the function bodies.
   */
  public Lexer(Source source, int start, int len, TokenStream stream, boolean scripting, boolean pauseOnFunctionBody) {
    super(source.getContent(), 1, start, len);
    this.source = source;
    this.stream = stream;
    this.scripting = scripting;
    this.nested = false;
    this.pendingLine = 1;
    this.last = EOL;

    this.pauseOnFunctionBody = pauseOnFunctionBody;
  }

  private Lexer(Lexer lexer, State state) {
    super(lexer, state);

    source = lexer.source;
    stream = lexer.stream;
    scripting = lexer.scripting;
    nested = true;

    pendingLine = state.pendingLine;
    linePosition = state.linePosition;
    last = EOL;
    pauseOnFunctionBody = false;
  }

  static class State extends Scanner.State {

    // Pending new line number and position.
    public final int pendingLine;

    // Position of last EOL + 1.
    public final int linePosition;

    // Type of last token added.
    public final TokenType last;

    State(int position, int limit, int line, int pendingLine, int linePosition, TokenType last) {
      super(position, limit, line);
      this.pendingLine = pendingLine;
      this.linePosition = linePosition;
      this.last = last;
    }
  }

  /**
   * Save the state of the scan.
   *
   * @return Captured state.
   */
  @Override
  State saveState() {
    return new State(position, limit, line, pendingLine, linePosition, last);
  }

  /**
   * Restore the state of the scan.
   *
   * @param state Captured state.
   */
  void restoreState(State state) {
    super.restoreState(state);
    pendingLine = state.pendingLine;
    linePosition = state.linePosition;
    last = state.last;
  }

  /**
   * Add a new token to the stream.
   *
   * @param type  Token type.
   * @param start Start position.
   * @param end   End position.
   */
  void add(TokenType type, int start, int end) {
    // Record last token.
    last = type;
    // Only emit the last EOL in a cluster.
    if (type == EOL) {
      pendingLine = end;
      linePosition = start;
    } else {
      // Write any pending EOL to stream.
      if (pendingLine != -1) {
        stream.put(Token.toDesc(EOL, linePosition, pendingLine));
        pendingLine = -1;
      }
      // Write token to stream.
      stream.put(Token.toDesc(type, start, end - start));
    }
  }

  /**
   * Add a new token to the stream.
   *
   * @param type  Token type.
   * @param start Start position.
   */
  void add(TokenType type, int start) {
    add(type, start, position);
  }

  /**
   * Return the String of valid whitespace characters for regular expressions in JavaScript
   * @return regexp whitespace string
   */
  public static String getWhitespaceRegExp() {
    return JAVASCRIPT_WHITESPACE_IN_REGEXP;
  }

  /**
   * Skip end of line.
   *
   * @param addEOL true if EOL token should be recorded.
   */
  void skipEOL(boolean addEOL) {
    if (ch0 == '\r') { // detect \r\n pattern
      skip(1);
      if (ch0 == '\n') {
        skip(1);
      }
    } else { // all other space, ch0 is guaranteed to be EOL or \0
      skip(1);
    }
    // bump up line count
    line++;
    if (addEOL) {
      // Add an EOL token.
      add(EOL, position, line);
    }
  }

  /**
   * Skip over rest of line including end of line.
   *
   * @param addEOL true if EOL token should be recorded.
   */
  void skipLine(boolean addEOL) {
    // Ignore characters.
    while (!isEOL(ch0) && !atEOF()) {
      skip(1);
    }
    // Skip over end of line.
    skipEOL(addEOL);
  }

  /**
   * Test whether a char is valid JavaScript whitespace
   * @param ch a char
   * @return true if valid JavaScript whitespace
   */
  public static boolean isJSWhitespace(char ch) {
    return ch == ' ' // space
        || ch >= '\t' && ch <= '\r' // 0x09..0x0d: tab, line feed, tabulation line, ff, carriage return
        || ch >= 160 && isOtherJSWhitespace(ch);
  }

  private static boolean isOtherJSWhitespace(char ch) {
    return JAVASCRIPT_OTHER_WHITESPACE.indexOf(ch) != -1;
  }

  /**
   * Test whether a char is valid JavaScript end of line
   * @param ch a char
   * @return true if valid JavaScript end of line
   */
  public static boolean isJSEOL(char ch) {
    return ch == '\n' // line feed
        || ch == '\r' // carriage return (ctrl-m)
        || ch == '\u2028' // line separator
        || ch == '\u2029'; // paragraph separator
  }

  /**
   * Test if char is a string delimiter, e.g. '\' or '"'.
   * @param ch a char
   * @return true if string delimiter
   */
  boolean isStringDelimiter(char ch) {
    return ch == '\'' || ch == '"';
  }

  /**
   * Test if char is a template literal delimiter ('`').
   */
  static boolean isTemplateDelimiter(char ch) {
    return ch == '`';
  }

  /**
   * Test whether a char is valid JavaScript whitespace
   * @param ch a char
   * @return true if valid JavaScript whitespace
   */
  boolean isWhitespace(char ch) {
    return Lexer.isJSWhitespace(ch);
  }

  /**
   * Test whether a char is valid JavaScript end of line
   * @param ch a char
   * @return true if valid JavaScript end of line
   */
  boolean isEOL(char ch) {
    return Lexer.isJSEOL(ch);
  }

  /**
   * Skip over whitespace and detect end of line, adding EOL tokens if
   * encountered.
   *
   * @param addEOL true if EOL tokens should be recorded.
   */
  void skipWhitespace(boolean addEOL) {
    while (isWhitespace(ch0)) {
      if (isEOL(ch0)) {
        skipEOL(addEOL);
      } else {
        skip(1);
      }
    }
  }

  /**
   * Skip over comments.
   *
   * @return True if a comment.
   */
  boolean skipComments() {
    // Save the current position.
    var start = position;
    if (ch0 == '/') {
      // Is it a // comment.
      if (ch1 == '/') {
        // Skip over //.
        skip(2);
        var directiveComment = false;
        if ((ch0 == '#' || ch0 == '@') && (ch1 == ' ')) {
          directiveComment = true;
        }
        // Scan for EOL.
        while (!atEOF() && !isEOL(ch0)) {
          skip(1);
        }
        // Did detect a comment.
        add(directiveComment ? DIRECTIVE_COMMENT : COMMENT, start);
        return true;
      } else if (ch1 == '*') {
        // Skip over /*.
        skip(2);
        // Scan for */.
        while (!atEOF() && !(ch0 == '*' && ch1 == '/')) {
          // If end of line handle else skip character.
          if (isEOL(ch0)) {
            skipEOL(true);
          } else {
            skip(1);
          }
        }
        if (atEOF()) {
          // TODO - Report closing */ missing in parser.
          add(ERROR, start);
        } else {
          // Skip */.
          skip(2);
        }
        // Did detect a comment.
        add(COMMENT, start);
        return true;
      }
    } else if (ch0 == '#') {
      assert scripting;
      // shell style comment
      // Skip over #.
      skip(1);
      // Scan for EOL.
      while (!atEOF() && !isEOL(ch0)) {
        skip(1);
      }
      // Did detect a comment.
      add(COMMENT, start);
      return true;
    }
    // Not a comment.
    return false;
  }

  /**
   * Convert a regex token to a token object.
   *
   * @param start  Position in source content.
   * @param length Length of regex token.
   * @return Regex token object.
   */
  public RegexToken valueOfPattern(int start, int length) {
    // Save the current position.
    var savePosition = position;
    // Reset to beginning of content.
    reset(start);
    // Buffer for recording characters.
    var sb = new StringBuilder(length);
    // Skip /.
    skip(1);
    boolean inBrackets = false;
    // Scan for closing /, stopping at end of line.
    while (!atEOF() && ch0 != '/' && !isEOL(ch0) || inBrackets) {
      // Skip over escaped character.
      if (ch0 == '\\') {
        sb.append(ch0);
        sb.append(ch1);
        skip(2);
      } else {
        if (ch0 == '[') {
          inBrackets = true;
        } else if (ch0 == ']') {
          inBrackets = false;
        }
        // Skip literal character.
        sb.append(ch0);
        skip(1);
      }
    }
    // Get pattern as string.
    var regex = sb.toString();
    // Skip /.
    skip(1);
    // Options as string.
    var options = source.getString(position, scanIdentifier());
    reset(savePosition);
    // Compile the pattern.
    return new RegexToken(regex, options);
  }

  /**
   * Return true if the given token can be the beginning of a literal.
   *
   * @param token a token
   * @return true if token can start a literal.
   */
  public boolean canStartLiteral(TokenType token) {
    return token.startsWith('/') || (scripting && token.startsWith('<'));
  }

  /**
   * interface to receive line information for multi-line literals.
   */
  interface LineInfoReceiver {
    /**
     * Receives line information
     * @param line last line number
     * @param linePosition position of last line
     */
    public void lineInfo(int line, int linePosition);
  }

  /**
   * Check whether the given token represents the beginning of a literal.
   * If so scan the literal and return <code>true</code>, otherwise return false.
   *
   * @param token the token.
   * @param startTokenType the token type.
   * @param lir LineInfoReceiver that receives line info for multi-line string literals.
   * @return True if a literal beginning with startToken was found and scanned.
   */
  boolean scanLiteral(long token, TokenType startTokenType, LineInfoReceiver lir) {
    // Check if it can be a literal.
    if (!canStartLiteral(startTokenType)) {
      return false;
    }
    // We break on ambiguous tokens so if we already moved on it can't be a literal.
    if (stream.get(stream.last()) != token) {
      return false;
    }
    // Record current position in case multiple heredocs start on this line - see JDK-8073653
    var state = saveState();
    // Rewind to token start position
    reset(Token.descPosition(token));

    if (ch0 == '/') {
      return scanRegEx();
    }
    return false;
  }

  /**
   * Scan over regex literal.
   *
   * @return True if a regex literal.
   */
  boolean scanRegEx() {
    assert ch0 == '/';
    // Make sure it's not a comment.
    if (ch1 != '/' && ch1 != '*') {
      // Record beginning of literal.
      var start = position;
      // Skip /.
      skip(1);
      var inBrackets = false;
      // Scan for closing /, stopping at end of line.
      while (!atEOF() && (ch0 != '/' || inBrackets) && !isEOL(ch0)) {
        // Skip over escaped character.
        if (ch0 == '\\') {
          skip(1);
          if (isEOL(ch0)) {
            reset(start);
            return false;
          }
          skip(1);
        } else {
          if (ch0 == '[') {
            inBrackets = true;
          } else if (ch0 == ']') {
            inBrackets = false;
          }
          // Skip literal character.
          skip(1);
        }
      }
      // If regex literal.
      if (ch0 == '/') {
        // Skip /.
        skip(1);
        // Skip over options.
        while (!atEOF() && Character.isJavaIdentifierPart(ch0) || ch0 == '\\' && ch1 == 'u') {
          skip(1);
        }
        // Add regex token.
        add(REGEX, start);
        // Regex literal detected.
        return true;
      }
      // False start try again.
      reset(start);
    }
    // Regex literal not detected.
    return false;
  }

  /**
   * Convert a digit to a integer.  Can't use Character.digit since we are
   * restricted to ASCII by the spec.
   *
   * @param ch   Character to convert.
   * @param base Numeric base.
   *
   * @return The converted digit or -1 if invalid.
   */
  static int convertDigit(char ch, int base) {
    int digit;
    if ('0' <= ch && ch <= '9') {
      digit = ch - '0';
    } else if ('A' <= ch && ch <= 'Z') {
      digit = ch - 'A' + 10;
    } else if ('a' <= ch && ch <= 'z') {
      digit = ch - 'a' + 10;
    } else {
      return -1;
    }
    return digit < base ? digit : -1;
  }

  /**
   * Get the value of a hexadecimal numeric sequence.
   *
   * @param length Number of digits.
   * @param type   Type of token to report against.
   * @return Value of sequence or < 0 if no digits.
   */
  int hexSequence(int length, TokenType type) {
    var value = 0;
    for (var i = 0; i < length; i++) {
      var digit = convertDigit(ch0, 16);
      if (digit == -1) {
        error(Lexer.message("invalid.hex"), type, position, limit);
        return i == 0 ? -1 : value;
      }
      value = digit | value << 4;
      skip(1);
    }
    return value;
  }

  /**
   * Get the value of an octal numeric sequence. This parses up to 3 digits with a maximum value of 255.
   *
   * @return Value of sequence.
   */
  int octalSequence() {
    var value = 0;
    for (var i = 0; i < 3; i++) {
      var digit = convertDigit(ch0, 8);
      if (digit == -1) {
        break;
      }
      value = digit | value << 3;
      skip(1);
      if (i == 1 && value >= 32) {
        break;
      }
    }
    return value;
  }

  /**
   * Convert a string to a JavaScript identifier.
   *
   * @param start  Position in source content.
   * @param length Length of token.
   * @return Ident string or null if an error.
   */
  String valueOfIdent(int start, int length) throws RuntimeException {
    // Save the current position.
    var savePosition = position;
    // End of scan.
    var end = start + length;
    // Reset to beginning of content.
    reset(start);
    // Buffer for recording characters.
    var sb = new StringBuilder(length);
    // Scan until end of line or end of file.
    while (!atEOF() && position < end && !isEOL(ch0)) {
      // If escape character.
      if (ch0 == '\\' && ch1 == 'u') {
        skip(2);
        var ch = hexSequence(4, TokenType.IDENT);
        assert !isWhitespace((char) ch);
        assert ch >= 0;
        sb.append((char) ch);
      } else {
        // Add regular character.
        sb.append(ch0);
        skip(1);
      }
    }
    // Restore position.
    reset(savePosition);
    return sb.toString();
  }

  /**
   * Scan over and identifier or keyword. Handles identifiers containing
   * encoded Unicode chars.
   *
   * Example:
   *
   * var \u0042 = 44;
   */
  void scanIdentifierOrKeyword() {
    // Record beginning of identifier.
    var start = position;
    // Scan identifier.
    var length = scanIdentifier();
    // Check to see if it is a keyword.
    var type = TokenLookup.lookupKeyword(content, start, length);
    if (type == FUNCTION && pauseOnFunctionBody) {
      pauseOnNextLeftBrace = true;
    }
    // Add keyword or identifier token.
    add(type, start);
  }

  /**
   * Convert a string to a JavaScript string object.
   *
   * @param start  Position in source content.
   * @param length Length of token.
   * @return JavaScript string object.
   */
  String valueOfString(int start, int length, boolean allow) throws RuntimeException {
    // Save the current position.
    var savePosition = position;
    // Calculate the end position.
    var end = start + length;
    // Reset to beginning of string.
    reset(start);
    // Buffer for recording characters.
    var sb = new StringBuilder(length);
    // Scan until end of string.
    while (position < end) {
      // If escape character.
      if (ch0 == '\\') {
        skip(1);
        var next = ch0;
        var afterSlash = position;
        skip(1);
        // Special characters.
        switch (next) {
          case '0', '1', '2', '3', '4', '5', '6', '7' -> {
            if (allow) {
              // "\0" itself may be allowed.
              // Only other 'real' octal escape sequences are not allowed (eg. "\02", "\31").
              // See section 7.8.4 String literals production EscapeSequence
              if (next != '0' || (ch0 >= '0' && ch0 <= '9')) {
                error(Lexer.message("no.octal"), STRING, position, limit);
              }
            }
            reset(afterSlash);
            // Octal sequence.
            var ch = octalSequence();
            if (ch < 0) {
              sb.append('\\');
              sb.append('x');
            } else {
              sb.append((char) ch);
            }
          }

          case '\r' -> { // CR | CRLF
            if (ch0 == '\n') {
              skip(1);
            }
            // continue as in '\n'
          }
          case '\n', '\u2028', '\u2029' -> { // LF, LS, PS
            // continue on the next line, slash-return continues string literal
          }
          case 'x' -> { // Hex sequence.
            var ch = hexSequence(2, STRING);
            if (ch < 0) {
              sb.append('\\');
              sb.append('x');
            } else {
              sb.append((char) ch);
            }
          }
          case 'u' -> { // Unicode sequence.
            var ch = hexSequence(4, STRING);
            if (ch < 0) {
              sb.append('\\');
              sb.append('u');
            } else {
              sb.append((char) ch);
            }
          }

          case 'n' -> sb.append('\n');
          case 't' -> sb.append('\t');
          case 'b' -> sb.append('\b');
          case 'f' -> sb.append('\f');
          case 'r' -> sb.append('\r');
          case '\'' -> sb.append('\'');
          case '\"' -> sb.append('\"');
          case '\\' -> sb.append('\\');
          case 'v' -> sb.append('\u000B');

          default -> sb.append(next); // All other characters.
        }
      } else if (ch0 == '\r') {
        // Convert CR-LF or CR to LF line terminator.
        sb.append('\n');
        skip(ch1 == '\n' ? 2 : 1);
      } else {
        // Add regular character.
        sb.append(ch0);
        skip(1);
      }
    }
    // Restore position.
    reset(savePosition);
    return sb.toString();
  }

  /**
   * Scan over a string literal.
   * @param add true if we are not just scanning but should actually modify the token stream
   */
  void scanString(boolean add) {
    // Type of string.
    var type = STRING;
    // Record starting quote.
    var quote = ch0;
    // Skip over quote.
    skip(1);
    // Record beginning of string content.
    var stringState = saveState();
    // Scan until close quote or end of line.
    while (!atEOF() && ch0 != quote && !isEOL(ch0)) {
      // Skip over escaped character.
      if (ch0 == '\\') {
        type = ESCSTRING;
        skip(1);
        if (isEOL(ch0)) {
          // Multiline string literal
          skipEOL(false);
          continue;
        }
      }
      // Skip literal character.
      skip(1);
    }
    // If close quote.
    if (ch0 == quote) {
      // Skip close quote.
      skip(1);
    } else {
      error(Lexer.message("missing.close.quote"), STRING, position, limit);
    }
    // If not just scanning.
    if (add) {
      // Record end of string.
      stringState.setLimit(position - 1);
      if (scripting && !stringState.isEmpty()) {
        switch (quote) {
          case '"' -> { // Only edit double quoted strings.
            editString(type, stringState);
          }
          case '\'' -> { // Add string token without editing.
            add(type, stringState.position, stringState.limit);
          }
          // default : no-op
        }
      } else {
        /// Add string token without editing.
        add(type, stringState.position, stringState.limit);
      }
    }
  }

  /**
   * Scan over a template string literal.
   */
  void scanTemplate() {
    assert ch0 == '`';
    var type = TEMPLATE;
    // Skip over quote and record beginning of string content.
    skip(1);
    var stringState = saveState();
    // Scan until close quote
    while (!atEOF()) {
      // Skip over escaped character.
      if (ch0 == '`') {
        skip(1);
        // Record end of string.
        stringState.setLimit(position - 1);
        add(type == TEMPLATE ? type : TEMPLATE_TAIL, stringState.position, stringState.limit);
        return;
      } else if (ch0 == '$' && ch1 == '{') {
        skip(2);
        stringState.setLimit(position - 2);
        add(type == TEMPLATE ? TEMPLATE_HEAD : type, stringState.position, stringState.limit);
        // scan to RBRACE
        var expressionLexer = new Lexer(this, saveState());
        expressionLexer.templateExpressionOpenBraces = 1;
        expressionLexer.lexify();
        restoreState(expressionLexer.saveState());
        // scan next middle or tail of the template literal
        assert ch0 == '}';
        type = TEMPLATE_MIDDLE;
        // Skip over rbrace and record beginning of string content.
        skip(1);
        stringState = saveState();
        continue;
      } else if (ch0 == '\\') {
        skip(1);
        // EscapeSequence
        if (isEOL(ch0)) {
          // LineContinuation
          skipEOL(false);
          continue;
        }
      } else if (isEOL(ch0)) {
        // LineTerminatorSequence
        skipEOL(false);
        continue;
      }
      // Skip literal character.
      skip(1);
    }
    error(Lexer.message("missing.close.quote"), TEMPLATE, position, limit);
  }

  /**
   * Convert string to number.
   *
   * @param valueString  String to convert.
   * @param radix        Numeric base.
   * @return Converted number.
   */
  static Number valueOf(String valueString, int radix) throws NumberFormatException {
    try {
      return Integer.parseInt(valueString, radix);
    } catch (NumberFormatException e) {
      if (radix == 10) {
        return Double.valueOf(valueString);
      }
      var value = 0.0;
      for (var i = 0; i < valueString.length(); i++) {
        var ch = valueString.charAt(i);
        // Preverified, should always be a valid digit.
        var digit = convertDigit(ch, radix);
        value *= radix;
        value += digit;
      }
      return value;
    }
  }

  /**
   * Scan a number.
   */
  void scanNumber() {
    // Record beginning of number.
    var start = position;
    // Assume value is a decimal.
    var type = DECIMAL;
    // First digit of number.
    var digit = convertDigit(ch0, 10);
    // If number begins with 0x.
    if (digit == 0 && (ch1 == 'x' || ch1 == 'X') && convertDigit(ch2, 16) != -1) {
      // Skip over 0xN.
      skip(3);
      // Skip over remaining digits.
      while (convertDigit(ch0, 16) != -1) {
        skip(1);
      }
      type = HEXADECIMAL;
    } else if (digit == 0 && (ch1 == 'o' || ch1 == 'O') && convertDigit(ch2, 8) != -1) {
      // Skip over 0oN.
      skip(3);
      // Skip over remaining digits.
      while (convertDigit(ch0, 8) != -1) {
        skip(1);
      }
      type = OCTAL;
    } else if (digit == 0 && (ch1 == 'b' || ch1 == 'B') && convertDigit(ch2, 2) != -1) {
      // Skip over 0bN.
      skip(3);
      // Skip over remaining digits.
      while (convertDigit(ch0, 2) != -1) {
        skip(1);
      }
      type = BINARY_NUMBER;
    } else {
      // Check for possible octal constant.
      var octal = digit == 0;
      // Skip first digit if not leading '.'.
      if (digit != -1) {
        skip(1);
      }
      // Skip remaining digits.
      while ((digit = convertDigit(ch0, 10)) != -1) {
        // Check octal only digits.
        octal = octal && digit < 8;
        // Skip digit.
        skip(1);
      }
      if (octal && position - start > 1) {
        type = OCTAL_LEGACY;
      } else if (ch0 == '.' || ch0 == 'E' || ch0 == 'e') {
        // Must be a double.
        if (ch0 == '.') {
          // Skip period.
          skip(1);
          // Skip mantissa.
          while (convertDigit(ch0, 10) != -1) {
            skip(1);
          }
        }
        // Detect exponent.
        if (ch0 == 'E' || ch0 == 'e') {
          // Skip E.
          skip(1);
          // Detect and skip exponent sign.
          if (ch0 == '+' || ch0 == '-') {
            skip(1);
          }
          // Skip exponent.
          while (convertDigit(ch0, 10) != -1) {
            skip(1);
          }
        }
        type = FLOATING;
      }
    }
    if (Character.isJavaIdentifierStart(ch0)) {
      error(Lexer.message("missing.space.after.number"), type, position, 1);
    }
    // Add number token.
    add(type, start);
  }

  /**
   * Scan over identifier characters.
   *
   * @return Length of identifier or zero if none found.
   */
  int scanIdentifier() {
    var start = position;
    // Make sure first character is valid start character.
    if (ch0 == '\\' && ch1 == 'u') {
      skip(2);
      var ch = hexSequence(4, TokenType.IDENT);
      if (!Character.isJavaIdentifierStart(ch)) {
        error(Lexer.message("illegal.identifier.character"), TokenType.IDENT, start, position);
      }
    } else if (!Character.isJavaIdentifierStart(ch0)) {
      // Not an identifier.
      return 0;
    }
    // Make sure remaining characters are valid part characters.
    while (!atEOF()) {
      if (ch0 == '\\' && ch1 == 'u') {
        skip(2);
        var ch = hexSequence(4, TokenType.IDENT);
        if (!Character.isJavaIdentifierPart(ch)) {
          error(Lexer.message("illegal.identifier.character"), TokenType.IDENT, start, position);
        }
      } else if (Character.isJavaIdentifierPart(ch0)) {
        skip(1);
      } else {
        break;
      }
    }
    // Length of identifier sequence.
    return position - start;
  }

  /**
   * Compare two identifiers (in content) for equality.
   *
   * @param aStart  Start of first identifier.
   * @param aLength Length of first identifier.
   * @param bStart  Start of second identifier.
   * @param bLength Length of second identifier.
   * @return True if equal.
   */
  boolean identifierEqual(int aStart, int aLength, int bStart, int bLength) {
    if (aLength == bLength) {
      for (var i = 0; i < aLength; i++) {
        if (content[aStart + i] != content[bStart + i]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  /**
   * Detect if a line starts with a marker identifier.
   *
   * @param identStart  Start of identifier.
   * @param identLength Length of identifier.
   * @return True if detected.
   */
  boolean hasHereMarker(int identStart, int identLength) {
    // Skip any whitespace.
    skipWhitespace(false);
    return identifierEqual(identStart, identLength, position, scanIdentifier());
  }

  /**
   * Lexer to service edit strings.
   */
  static class EditStringLexer extends Lexer {

    // Type of string literals to emit.
    final TokenType stringType;

    EditStringLexer(Lexer lexer, TokenType stringType, State stringState) {
      super(lexer, stringState);
      this.stringType = stringType;
    }

    /**
     * Lexify the contents of the string.
     */
    @Override
    public void lexify() {
      // Record start of string position.
      var stringStart = position;
      // Indicate that the priming first string has not been emitted.
      var primed = false;
      for (;;) {
        // Detect end of content.
        if (atEOF()) {
          break;
        }
        // Honour escapes (should be well formed.)
        if (ch0 == '\\' && stringType == ESCSTRING) {
          skip(2);
          continue;
        }
        // If start of expression.
        if (ch0 == '$' && ch1 == '{') {
          if (!primed || stringStart != position) {
            if (primed) {
              add(ADD, stringStart, stringStart + 1);
            }
            add(stringType, stringStart, position);
            primed = true;
          }
          // Skip ${
          skip(2);
          // Save expression state.
          var expressionState = saveState();
          // Start with one open brace.
          var braceCount = 1;
          // Scan for the rest of the string.
          while (!atEOF()) {
            // If closing brace.
            if (ch0 == '}') {
              // Break only only if matching brace.
              if (--braceCount == 0) {
                break;
              }
            } else if (ch0 == '{') {
              // Bump up the brace count.
              braceCount++;
            }
            // Skip to next character.
            skip(1);
          }
          // If braces don't match then report an error.
          if (braceCount != 0) {
            error(Lexer.message("edit.string.missing.brace"), LBRACE, expressionState.position - 1, 1);
          }
          // Mark end of expression.
          expressionState.setLimit(position);
          // Skip closing brace.
          skip(1);
          // Start next string.
          stringStart = position;
          // Concatenate expression.
          add(ADD, expressionState.position, expressionState.position + 1);
          add(LPAREN, expressionState.position, expressionState.position + 1);
          // Scan expression.
          var lexer = new Lexer(this, expressionState);
          lexer.lexify();
          // Close out expression parenthesis.
          add(RPAREN, position - 1, position);
          continue;
        }
        // Next character in string.
        skip(1);
      }
      // If there is any unemitted string portion.
      if (stringStart != limit) {
        // Concatenate remaining string.
        if (primed) {
          add(ADD, stringStart, 1);
        }
        add(stringType, stringStart, limit);
      }
    }
  }

  /**
   * Edit string for nested expressions.
   *
   * @param stringType  Type of string literals to emit.
   * @param stringState State of lexer at start of string.
   */
  void editString(TokenType stringType, State stringState) {
    // Use special lexer to scan string.
    var lexer = new EditStringLexer(this, stringType, stringState);
    lexer.lexify();
    // Need to keep lexer informed.
    last = stringType;
  }

  /**
   * Breaks source content down into lex units, adding tokens to the token stream.
   * The routine scans until the stream buffer is full.
   * Can be called repeatedly until EOF is detected.
   */
  public void lexify() {
    while (!stream.isFull() || nested) {
      // Skip over whitespace.
      skipWhitespace(true);
      // Detect end of file.
      if (atEOF()) {
        if (!nested) {
          // Add an EOF token at the end.
          add(EOF, position);
        }
        break;
      }
      // Check for comments.
      // Note that we don't scan for regexp and other literals here as we may not have enough context to distinguish them from similar looking operators.
      // Instead we break on ambiguous operators below and let the parser decide.
      if (ch0 == '/' && skipComments()) {
        continue;
      }
      if (scripting && ch0 == '#' && skipComments()) {
        continue;
      }
      // TokenType for lookup of delimiter or operator.
      TokenType type;
      if (ch0 == '.' && convertDigit(ch1, 10) != -1) {
        // '.' followed by digit.
        // Scan and add a number.
        scanNumber();
      } else if ((type = TokenLookup.lookupOperator(ch0, ch1, ch2, ch3)) != null) {
        if (templateExpressionOpenBraces > 0) {
          if (type == LBRACE) {
            templateExpressionOpenBraces++;
          } else if (type == RBRACE) {
            if (--templateExpressionOpenBraces == 0) {
              break;
            }
          }
        }
        // Get the number of characters in the token.
        var typeLength = type.getLength();
        // Skip that many characters.
        skip(typeLength);
        // Add operator token.
        add(type, position - typeLength);
        // Some operator tokens also mark the beginning of regexp, XML, or here string literals.
        // We break to let the parser decide what it is.
        if (canStartLiteral(type)) {
          break;
        } else if (type == LBRACE && pauseOnNextLeftBrace) {
          pauseOnNextLeftBrace = false;
          break;
        }
      } else if (Character.isJavaIdentifierStart(ch0) || ch0 == '\\' && ch1 == 'u') {
        // Scan and add identifier or keyword.
        scanIdentifierOrKeyword();
      } else if (isStringDelimiter(ch0)) {
        // Scan and add a string.
        scanString(true);
      } else if (Character.isDigit(ch0)) {
        // Scan and add a number.
        scanNumber();
      } else if (isTemplateDelimiter(ch0)) {
        // Scan and add template.
        scanTemplate();
      } else {
        // Don't recognize this character.
        skip(1);
        add(ERROR, position - 1);
      }
    }
  }

  /**
   * Return value of token given its token descriptor.
   *
   * @param token  Token descriptor.
   * @return JavaScript value.
   */
  Object getValueOf(long token) {
    var start = Token.descPosition(token);
    var len = Token.descLength(token);

    return switch (Token.descType(token)) {

      case DECIMAL -> Lexer.valueOf(source.getString(start, len), 10); // number
      case HEXADECIMAL -> Lexer.valueOf(source.getString(start + 2, len - 2), 16); // number
      case OCTAL_LEGACY -> Lexer.valueOf(source.getString(start, len), 8); // number
      case OCTAL -> Lexer.valueOf(source.getString(start + 2, len - 2), 8); // number
      case BINARY_NUMBER -> Lexer.valueOf(source.getString(start + 2, len - 2), 2); // number

      case FLOATING -> {
        var str = source.getString(start, len);
        double value = Double.valueOf(str);
        if (str.indexOf('.') != -1) {
          yield value; //number
        }
        // anything without an explicit decimal point is still subject to a "representable as int or long" check.
        // Then the programmer does not explicitly code something as a double.
        // For example new Color(int, int, int) and new Color(float, float, float) will get ambiguous
        //  for cases like new Color(1.0, 1.5, 1.5) if we don't respect the decimal point.
        //  yet we don't want e.g. 1e6 to be a double unnecessarily
        if (JSType.isNonNegativeZeroInt(value)) {
          yield (int) value;
        }
        yield value;
      }

      case STRING -> source.getString(start, len); // String
      case ESCSTRING -> valueOfString(start, len, true); // String
      case IDENT -> valueOfIdent(start, len); // String
      case REGEX -> valueOfPattern(start, len); // RegexToken::LexerToken
      case TEMPLATE, TEMPLATE_HEAD, TEMPLATE_MIDDLE, TEMPLATE_TAIL -> valueOfString(start, len, true); // String
      case DIRECTIVE_COMMENT -> source.getString(start, len);

      default -> null;
    };
  }

  /**
   * Get the raw string value of a template literal string part.
   *
   * @param token template string token
   * @return raw string
   */
  public String valueOfRawString(long token) {
    var start = Token.descPosition(token);
    var length = Token.descLength(token);
    // Save the current position.
    var savePosition = position;
    // Calculate the end position.
    var end = start + length;
    // Reset to beginning of string.
    reset(start);
    // Buffer for recording characters.
    var sb = new StringBuilder(length);
    // Scan until end of string.
    while (position < end) {
      if (ch0 == '\r') {
        // Convert CR-LF or CR to LF line terminator.
        sb.append('\n');
        skip(ch1 == '\n' ? 2 : 1);
      } else {
        // Add regular character.
        sb.append(ch0);
        skip(1);
      }
    }
    // Restore position.
    reset(savePosition);
    return sb.toString();
  }

  /**
   * Get the correctly localized error message for a given message id format arguments
   *
   * @param msgId message id
   * @param args  format arguments
   * @return message
   */
  static String message(String msgId, String... args) {
    return ECMAErrors.getMessage("lexer.error." + msgId, args);
  }

  /**
   * Generate a runtime exception
   *
   * @param message       error message
   * @param type          token type
   * @param start         start position of lexed error
   * @param length        length of lexed error
   * @throws ParserException  unconditionally
   */
  void error(String message, TokenType type, int start, int length) throws ParserException {
    var token = Token.toDesc(type, start, length);
    var pos = Token.descPosition(token);
    var lineNum = source.getLine(pos);
    var columnNum = source.getColumn(pos);
    var formatted = ErrorManager.format(message, source, lineNum, columnNum, token);
    throw new ParserException(JSErrorType.SYNTAX_ERROR, formatted, source, lineNum, columnNum, token);
  }

  /**
   * Helper class for Lexer tokens, e.g XML or RegExp tokens.
   * This is the abstract superclass
   */
  public static abstract class LexerToken implements Serializable {

    private final String expression;

    /**
     * Constructor
     * @param expression token expression
     */
    LexerToken(String expression) {
      this.expression = expression;
    }

    /**
     * Get the expression
     * @return expression
     */
    public String getExpression() {
      return expression;
    }

    private static final long serialVersionUID = 1;
  }

  /**
   * Temporary container for regular expressions.
   */
  public static class RegexToken extends LexerToken {

    // Options.
    private final String options;

    /**
     * Constructor.
     * @param expression  regexp expression
     * @param options     regexp options
     */
    public RegexToken(String expression, String options) {
      super(expression);
      this.options = options;
    }

    /**
     * Get regexp options
     * @return options
     */
    public String getOptions() {
      return options;
    }

    @Override
    public String toString() {
      return '/' + getExpression() + '/' + options;
    }

    private static final long serialVersionUID = 1;
  }

}
