package es.parser;

/**
 * Classification of token types.
 */
public enum TokenKind {
  /** Error, EOF, EOL...*/
  SPECIAL,
  /** Unary operators. */
  UNARY,
  /** Binary operators. */
  BINARY,
  /** [] () {} */
  BRACKET,
  /** String recognized as a keyword. */
  KEYWORD,
  /** Literal constant. */
  LITERAL,
  /** IR only token. */
  IR,
  /** Token reserved for future usage. */
  FUTURE,
  /** Token reserved for future in strict mode. */
  FUTURESTRICT
}
