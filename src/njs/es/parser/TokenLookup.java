package es.parser;

import static es.parser.TokenKind.SPECIAL;
import static es.parser.TokenType.IDENT;

/**
 * Fast lookup of operators and keywords.
 *
 */
public final class TokenLookup {

  // Lookup table for tokens.
  private static final TokenType[] table;

  // Table base character.
  private static final int tableBase = ' ';

  // Table base character.
  private static final int tableLimit = '~';

  // Table size.
  private static final int tableLength = tableLimit - tableBase + 1;

  static {
    // Construct the table.
    table = new TokenType[tableLength];
    // For each token type.
    for (var tokenType : TokenType.getValues()) {
      // Get the name.
      var name = tokenType.getName();
      // Filter tokens.
      if (name == null) {
        continue;
      }
      // Ignore null and special.
      if (tokenType.getKind() != SPECIAL) {
        // Get the first character of the name.
        var first = name.charAt(0);
        // Translate that character into a table index.
        var index = first - tableBase;
        assert index < tableLength : "Token name does not fit lookup table";
        // Get the length of the token so that the longest come first.
        var length = tokenType.getLength();
        // Prepare for table insert.
        TokenType prev = null;
        var next = table[index];
        // Find the right spot in the table.
        while (next != null && next.getLength() > length) {
          prev = next;
          next = next.getNext();
        }
        // Insert in table.
        tokenType.setNext(next);
        if (prev == null) {
          table[index] = tokenType;
        } else {
          prev.setNext(tokenType);
        }
      }
    }
  }

  /**
   * Lookup keyword.
   *
   * @param content parse content char array
   * @param position index of position to start looking
   * @param length   max length to scan
   *
   * @return token type for keyword
   */
  public static TokenType lookupKeyword(char[] content, int position, int length) {
    assert table != null : "Token lookup table is not initialized";

    // First character of keyword.
    var first = content[position];

    // Must be lower case character.
    if ('a' <= first && first <= 'z') {
      // Convert to table index.
      var index = first - tableBase;
      // Get first bucket entry.
      var tokenType = table[index];

      // Search bucket list.
      while (tokenType != null) {
        var tokenLength = tokenType.getLength();

        // if we have a length match maybe a keyword.
        if (tokenLength == length) {
          // Do an exact compare of string.
          var name = tokenType.getName();
          int i;
          for (i = 0; i < length; i++) {
            if (content[position + i] != name.charAt(i)) {
              break;
            }
          }

          if (i == length) {
            // Found a match.
            return tokenType;
          }
        } else if (tokenLength < length) {
          // Rest of tokens are shorter.
          break;
        }

        // Try next token.
        tokenType = tokenType.getNext();
      }
    }

    // Not found.
    return IDENT;
  }

  /**
   * Lookup operator.
   *
   * @param ch0 0th char in stream
   * @param ch1 1st char in stream
   * @param ch2 2nd char in stream
   * @param ch3 3rd char in stream
   *
   * @return the token type for the operator
   */
  public static TokenType lookupOperator(char ch0, char ch1, char ch2, char ch3) {
    assert table != null : "Token lookup table is not initialized";

    // Ignore keyword entries.
    if (tableBase < ch0 && ch0 <= tableLimit && !('a' <= ch0 && ch0 <= 'z')) {
      // Convert to index.
      var index = ch0 - tableBase;
      // Get first bucket entry.
      var tokenType = table[index];

      // Search bucket list.
      while (tokenType != null) {
        var name = tokenType.getName();

        switch (name.length()) {
          case 1 -> { // One character entry.
            return tokenType;
          }
          case 2 -> { // Two character entry.
            if (name.charAt(1) == ch1) {
              return tokenType;
            }
          }
          case 3 -> { // Three character entry.
            if (name.charAt(1) == ch1 && name.charAt(2) == ch2) {
              return tokenType;
            }
          }
          case 4 -> { // Four character entry.
            if (name.charAt(1) == ch1 && name.charAt(2) == ch2 && name.charAt(3) == ch3) {
              return tokenType;
            }
          }
        }

        // Try next token.
        tokenType = tokenType.getNext();
      }
    }

    // Not found.
    return null;
  }

}
