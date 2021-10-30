package es.runtime;

import nash.scripting.NashornException;

import es.objects.Global;
import es.parser.Token;

/**
 * ECMAScript parser exceptions.
 */
public final class ParserException extends NashornException {

  // Source from which this ParserException originated
  private final Source source;
  // token responsible for this exception
  private final long token;
  // if this is translated as ECMA error, which type should be used?
  private final JSErrorType errorType;

  /**
   * Constructor
   *
   * @param msg exception message for this parser error.
   */
  public ParserException(String msg) {
    this(JSErrorType.SYNTAX_ERROR, msg, null, -1, -1, -1);
  }

  /**
   * Constructor
   *
   * @param errorType error type
   * @param msg       exception message
   * @param source    source from which this exception originates
   * @param line      line number of exception
   * @param column    column number of exception
   * @param token     token from which this exception originates
   *
   */
  public ParserException(JSErrorType errorType, String msg, Source source, int line, int column, long token) {
    super(msg, source != null ? source.getName() : null, line, column);
    this.source = source;
    this.token = token;
    this.errorType = errorType;
  }

  /**
   * Get the {@code Source} of this {@code ParserException}
   * @return source
   */
  public Source getSource() {
    return source;
  }

  /**
   * Get the token responsible for this {@code ParserException}
   * @return token
   */
  public long getToken() {
    return token;
  }

  /**
   * Get token position within source where the error originated.
   * @return token position if available, else -1
   */
  public int getPosition() {
    return Token.descPosition(token);
  }

  /**
   * Get the {@code JSErrorType} of this {@code ParserException}
   * @return error type
   */
  public JSErrorType getErrorType() {
    return errorType;
  }

  /**
   * Throw this {@code ParserException} as one of the 7 native JavaScript errors
   */
  public void throwAsEcmaException() {
    throw ECMAErrors.asEcmaException(this);
  }

  /**
   * Throw this {@code ParserException} as one of the 7 native JavaScript errors
   * @param global global scope object
   */
  public void throwAsEcmaException(Global global) {
    throw ECMAErrors.asEcmaException(global, this);
  }

}
