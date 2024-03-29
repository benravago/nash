package es.runtime.regexp;

import java.util.regex.MatchResult;

/**
 * Interface for matching a regular expression against a string and retrieving the match result.
 * Extends {@link MatchResult}.
 */
public interface RegExpMatcher extends MatchResult {

  /**
   * Searches for pattern starting at {@code start}. Returns {@code true} if a match was found.
   *
   * @param start the start index in the input string
   * @return {@code true} if a match was found
   */
  boolean search(int start);

  /**
   * Get the input string.
   *
   * @return the input string
   */
  String getInput();

}
