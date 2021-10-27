package es.runtime;

import java.io.PrintWriter;

import es.parser.Token;
import static es.runtime.ECMAErrors.rangeError;

/**
 * Handles JavaScript error reporting.
 */
public class ErrorManager {

  // TODO - collect and sort/collapse error messages.
  // TODO - property based error messages.

  // Reporting writer.
  private final PrintWriter writer;

  // Error count.
  private int errors;

  // Warning count
  private int warnings;

  // Limit of the number of messages.
  private int limit;

  // Treat warnings as errors.
  private boolean warningsAsErrors;

  /**
   * Constructor
   */
  public ErrorManager() {
    this(new PrintWriter(System.err, true)); //bootstrapping, context may not be initialized
  }

  /**
   * Constructor.
   * @param writer I/O writer to report on.
   */
  public ErrorManager(PrintWriter writer) {
    this.writer = writer;
    this.limit = 100;
    this.warningsAsErrors = false;
  }

  /**
   * Check to see if number of errors exceed limit.
   */
  void checkLimit() {
    var count = errors;
    if (warningsAsErrors) {
      count += warnings;
    }
    if (limit != 0 && count > limit) {
      throw rangeError("too.many.errors", Integer.toString(limit));
    }
  }

  /**
   * Format an error message to include source and line information.
   * @param message Error message string.
   * @param source  Source file information.
   * @param line    Source line number.
   * @param column  Source column number.
   * @param token   Offending token descriptor.
   * @return formatted string
   */
  public static String format(String message, Source source, int line, int column, long token) {
    var eoln = System.lineSeparator();
    var position = Token.descPosition(token);
    var sb = new StringBuilder();
    // Source description and message.
    sb.append(source.getName()).append(':')
      .append(line).append(':')
      .append(column).append(' ')
      .append(message).append(eoln);
    // Source content.
    var sourceLine = source.getSourceLine(position);
    sb.append(sourceLine).append(eoln);
    // Pointer to column.
    for (var i = 0; i < column; i++) {
      if (i < sourceLine.length() && sourceLine.charAt(i) == '\t') {
        sb.append('\t');
      } else {
        sb.append(' ');
      }
    }
    sb.append('^');
    // Use will append eoln.
    // buffer.append(eoln);
    return sb.toString();
  }

  /**
   * Report an error using information provided by the ParserException
   * @param e ParserException object
   */
  public void error(ParserException e) {
    error(e.getMessage());
  }

  /**
   * Report an error message provided
   * @param message Error message string.
   */
  public void error(String message) {
    writer.println(message);
    writer.flush();
    errors++;
    checkLimit();
  }

  /**
   * Report a warning using information provided by the ParserException
   * @param e ParserException object
   */
  public void warning(ParserException e) {
    warning(e.getMessage());
  }

  /**
   * Report a warning message provided
   * @param message Error message string.
   */
  public void warning(String message) {
    writer.println(message);
    writer.flush();
    warnings++;
    checkLimit();
  }

  /**
   * Test to see if errors have occurred.
   * @return True if errors.
   */
  public boolean hasErrors() {
    return errors != 0;
  }

  /**
   * Get the message limit
   * @return max number of messages
   */
  public int getLimit() {
    return limit;
  }

  /**
   * Set the message limit
   * @param limit max number of messages
   */
  public void setLimit(int limit) {
    this.limit = limit;
  }

  /**
   * Check whether warnings should be treated like errors
   * @return true if warnings should be treated like errors
   */
  public boolean isWarningsAsErrors() {
    return warningsAsErrors;
  }

  /**
   * Set warnings to be treated as errors
   * @param warningsAsErrors true if warnings should be treated as errors, false otherwise
   */
  public void setWarningsAsErrors(boolean warningsAsErrors) {
    this.warningsAsErrors = warningsAsErrors;
  }

  /**
   * Get the number of errors
   * @return number of errors
   */
  public int getNumberOfErrors() {
    return errors;
  }

  /**
   * Get number of warnings
   * @return number of warnings
   */
  public int getNumberOfWarnings() {
    return warnings;
  }

  /**
   * Clear warnings and error count.
   */
  void reset() {
    warnings = 0;
    errors = 0;
  }

}
