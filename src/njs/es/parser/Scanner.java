package es.parser;

/**
 * Utility for scanning thru a char array.
 */
public class Scanner {

  // Characters to scan.
  protected final char[] content;

  // Position in content.
  protected int position;

  // Scan limit.
  protected final int limit;

  // Current line number.
  protected int line;

  // Current character in stream
  protected char ch0;
  // 1 character lookahead
  protected char ch1;
  // 2 character lookahead
  protected char ch2;
  // 3 character lookahead
  protected char ch3;

  /**
   * Constructor
   *
   * @param content content to scan
   * @param line    start line number
   * @param start   position index in content where to start
   * @param length  length of input
   */
  protected Scanner(char[] content, int line, int start, int length) {
    this.content = content;
    this.position = start;
    this.limit = start + length;
    this.line = line;

    reset(position);
  }

  /**
   * Constructor
   *
   * Scan content from beginning to end. Content given as a string
   *
   * @param content content to scan
   */
  protected Scanner(String content) {
    this(content.toCharArray(), 0, 0, content.length());
  }

  /**
   * Copy constructor
   *
   * @param scanner  scanner
   * @param state    state, the state is a tuple {position, limit, line} only visible internally
   */
  Scanner(Scanner scanner, State state) {
    content = scanner.content;
    position = state.position;
    limit = state.limit;
    line = state.line;

    reset(position);
  }

  /**
   * Information needed to restore previous state.
   */
  static class State {

    // Position in content. 
    final int position;

    // Scan limit. 
    int limit;

    // Current line number. 
    final int line;

    State(int position, int limit, int line) {
      this.position = position;
      this.limit = limit;
      this.line = line;
    }

    /**
     * Change the limit for a new scanner.
     * @param limit New limit.
     */
    void setLimit(int limit) {
      this.limit = limit;
    }

    boolean isEmpty() {
      return position == limit;
    }
  }

  /**
   * Save the state of the scan.
   * @return Captured state.
   */
  State saveState() {
    return new State(position, limit, line);
  }

  /**
   * Restore the state of the scan.
   * @param state Captured state.
   */
  void restoreState(State state) {
    position = state.position;
    line = state.line;

    reset(position);
  }

  /**
   * Returns true of scanner is at end of input
   * @return true if no more input
   */
  protected final boolean atEOF() {
    return position == limit;
  }

  /**
   * Get the ith character from the content.
   * @param i Index of character.
   * @return ith character or '\0' if beyond limit.
   */
  protected final char charAt(int i) {
    // Get a character from the content, '\0' if beyond the end of file.
    return i < limit ? content[i] : '\0';
  }

  /**
   * Reset to a character position.
   * @param i Position in content.
   */
  protected final void reset(int i) {
    ch0 = charAt(i);
    ch1 = charAt(i + 1);
    ch2 = charAt(i + 2);
    ch3 = charAt(i + 3);
    position = i < limit ? i : limit;
  }

  /**
   * Skip ahead a number of characters.
   * @param n Number of characters to skip.
   */
  protected final void skip(int n) {
    if (n == 1 && !atEOF()) {
      ch0 = ch1;
      ch1 = ch2;
      ch2 = ch3;
      ch3 = charAt(position + 4);
      position++;
    } else if (n != 0) {
      reset(position + n);
    }
  }

}
