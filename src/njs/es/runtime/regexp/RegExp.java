package es.runtime.regexp;

import java.util.regex.MatchResult;

import es.runtime.BitVector;
import es.runtime.ECMAErrors;
import es.runtime.ParserException;

/**
 * This is the base class for representing a parsed regular expression.
 *
 * Instances of this class are created by a {@link RegExpFactory}.
 */
public abstract class RegExp {

  /** Pattern string. */
  private final String source;

  /** Global search flag for this regexp.*/
  private boolean global;

  /** Case insensitive flag for this regexp */
  private boolean ignoreCase;

  /** Multi-line flag for this regexp */
  private boolean multiline;

  /** BitVector that keeps track of groups in negative lookahead */
  protected BitVector groupsInNegativeLookahead;

  /**
   * Constructor.
   *
   * @param source the source string
   * @param flags the flags string
   */
  protected RegExp(String source, String flags) {
    this.source = source.length() == 0 ? "(?:)" : source;
    for (var i = 0; i < flags.length(); i++) {
      var ch = flags.charAt(i);
      switch (ch) {
        case 'g' -> {
          if (this.global) {
            throwParserException("repeated.flag", "g");
          }
          this.global = true;
        }
        case 'i' -> {
          if (this.ignoreCase) {
            throwParserException("repeated.flag", "i");
          }
          this.ignoreCase = true;
        }
        case 'm' -> {
          if (this.multiline) {
            throwParserException("repeated.flag", "m");
          }
          this.multiline = true;
        }
        default -> {
          throwParserException("unsupported.flag", Character.toString(ch));
        }
      }
    }
  }

  /**
   * Get the source pattern of this regular expression.
   *
   * @return the source string
   */
  public String getSource() {
    return source;
  }

  /**
   * Set the global flag of this regular expression to {@code global}.
   *
   * @param global the new global flag
   */
  public void setGlobal(boolean global) {
    this.global = global;
  }

  /**
   * Get the global flag of this regular expression.
   *
   * @return the global flag
   */
  public boolean isGlobal() {
    return global;
  }

  /**
   * Get the ignore-case flag of this regular expression.
   *
   * @return the ignore-case flag
   */
  public boolean isIgnoreCase() {
    return ignoreCase;
  }

  /**
   * Get the multiline flag of this regular expression.
   *
   * @return the multiline flag
   */
  public boolean isMultiline() {
    return multiline;
  }

  /**
   * Get a bitset indicating which of the groups in this regular expression are inside a negative lookahead.
   *
   * @return the groups-in-negative-lookahead bitset
   */
  public BitVector getGroupsInNegativeLookahead() {
    return groupsInNegativeLookahead;
  }

  /**
   * Match this regular expression against {@code str}, starting at index {@code start}
   * and return a {@link MatchResult} with the result.
   *
   * @param str the string
   * @return the matcher
   */
  public abstract RegExpMatcher match(String str);

  /**
   * Throw a regexp parser exception.
   *
   * @param key the message key
   * @param str string argument
   * @throws es.runtime.ParserException unconditionally
   */
  protected static void throwParserException(String key, String str) throws ParserException {
    throw new ParserException(ECMAErrors.getMessage("parser.error.regex." + key, str));
  }

}
