package es.parser;

import java.util.ArrayList;
import java.util.List;

import es.codegen.ObjectClassGenerator;
import es.objects.Global;
import es.runtime.ECMAErrors;
import es.runtime.ErrorManager;
import es.runtime.JSErrorType;
import es.runtime.JSType;
import es.runtime.ParserException;
import es.runtime.Property;
import es.runtime.PropertyMap;
import es.runtime.Source;
import es.runtime.SpillProperty;
import es.runtime.arrays.ArrayData;
import es.runtime.arrays.ArrayIndex;
import es.scripts.JD;
import es.scripts.JO;

import static es.parser.TokenType.STRING;

/**
 * Parses JSON text and returns the corresponding IR node.
 *
 * This is derived from the objectLiteral production of the main parser.
 * See: 15.12.1.2 The JSON Syntactic Grammar
 */
public class JSONParser {

  final private String source;
  final private Global global;
  final private boolean dualFields;
  final int length;
  int pos = 0;

  private static final int EOF = -1;

  private static final String TRUE = "true";
  private static final String FALSE = "false";
  private static final String NULL = "null";

  private static final int STATE_EMPTY = 0;
  private static final int STATE_ELEMENT_PARSED = 1;
  private static final int STATE_COMMA_PARSED = 2;

  /**
   * Constructor.
   *
   * @param source     the source
   * @param global     the global object
   * @param dualFields whether the parser should regard dual field representation
   */
  public JSONParser(String source, Global global, boolean dualFields) {
    this.source = source;
    this.global = global;
    this.length = source.length();
    this.dualFields = dualFields;
  }

  /**
   * Implementation of the Quote(value) operation as defined in the ECMAscript spec.
   * It wraps a String value in double quotes and escapes characters within.
   *
   * @param value string to quote
   * @return quoted and escaped string
   */
  public static String quote(String value) {
    var product = new StringBuilder();
    product.append("\"");
    for (var ch : value.toCharArray()) {
      // TODO: should use a table?
      switch (ch) {
        case '\\' -> product.append("\\\\");
        case '"' -> product.append("\\\"");
        case '\b' -> product.append("\\b");
        case '\f' -> product.append("\\f");
        case '\n' -> product.append("\\n");
        case '\r' -> product.append("\\r");
        case '\t' -> product.append("\\t");
        default -> {
          if (ch < ' ') {
            product.append(Lexer.unicodeEscape(ch));
            break;
          }
          product.append(ch);
        }
      }
    }
    product.append("\"");
    return product.toString();
  }

  /**
   * Public parse method. Parse a string into a JSON object.
   *
   * @return the parsed JSON Object
   */
  public Object parse() {
    var value = parseLiteral();
    skipWhiteSpace();
    if (pos < length) {
      throw expectedError(pos, "eof", toString(peek()));
    }
    return value;
  }

  Object parseLiteral() {
    skipWhiteSpace();
    var c = peek();
    if (c == EOF) {
      throw expectedError(pos, "json literal", "eof");
    }
    return switch (c) {
      case '{' -> parseObject();
      case '[' -> parseArray();
      case '"' -> parseString();
      case 'f' -> parseKeyword(FALSE, Boolean.FALSE);
      case 't' -> parseKeyword(TRUE, Boolean.TRUE);
      case 'n' -> parseKeyword(NULL, null);
      default -> {
        if (isDigit(c) || c == '-') {
          yield parseNumber();
        } else if (c == '.') {
          throw numberError(pos);
        } else {
          throw expectedError(pos, "json literal", toString(c));
        }
      }
    };
  }

  Object parseObject() {
    var propertyMap = dualFields ? JD.getInitialMap() : JO.getInitialMap();
    var arrayData = ArrayData.EMPTY_ARRAY;
    var values = new ArrayList<Object>();
    var state = STATE_EMPTY;
    assert peek() == '{';
    pos++;
    while (pos < length) {
      skipWhiteSpace();
      var c = peek();
      switch (c) {
        case '"' -> {
          if (state == STATE_ELEMENT_PARSED) {
            throw expectedError(pos - 1, ", or }", toString(c));
          }
          var id = parseString();
          expectColon();
          var value = parseLiteral();
          var index = ArrayIndex.getArrayIndex(id);
          if (ArrayIndex.isValidArrayIndex(index)) {
            arrayData = addArrayElement(arrayData, index, value);
          } else {
            propertyMap = addObjectProperty(propertyMap, values, id, value);
          }
          state = STATE_ELEMENT_PARSED;
        }
        case ',' -> {
          if (state != STATE_ELEMENT_PARSED) {
            throw error(AbstractParser.message("trailing.comma.in.json"), pos);
          }
          state = STATE_COMMA_PARSED;
          pos++;
        }
        case '}' -> {
          if (state == STATE_COMMA_PARSED) {
            throw error(AbstractParser.message("trailing.comma.in.json"), pos);
          }
          pos++;
          return createObject(propertyMap, values, arrayData);
        }
        default -> {
          throw expectedError(pos, ", or }", toString(c));
        }
      }
    } // while()
    throw expectedError(pos, ", or }", "eof");
  }

  static ArrayData addArrayElement(ArrayData arrayData, int index, Object value) {
    var oldLength = arrayData.length();
    var longIndex = ArrayIndex.toLongIndex(index);
    var newArrayData = arrayData;
    if (longIndex >= oldLength) {
      newArrayData = newArrayData.ensure(longIndex);
      if (longIndex > oldLength) {
        newArrayData = newArrayData.delete(oldLength, longIndex - 1);
      }
    }
    return newArrayData.set(index, value);
  }

  PropertyMap addObjectProperty(PropertyMap propertyMap, List<Object> values, String id, Object value) {
    var oldProperty = propertyMap.findProperty(id);
    PropertyMap newMap;
    Class<?> type;
    int flags;
    if (dualFields) {
      type = getType(value);
      flags = Property.DUAL_FIELDS;
    } else {
      type = Object.class;
      flags = 0;
    }
    if (oldProperty != null) {
      values.set(oldProperty.getSlot(), value);
      newMap = propertyMap.replaceProperty(oldProperty, new SpillProperty(id, flags, oldProperty.getSlot(), type));
    } else {
      values.add(value);
      newMap = propertyMap.addProperty(new SpillProperty(id, flags, propertyMap.size(), type));
    }
    return newMap;
  }

  private Object createObject(PropertyMap propertyMap, List<Object> values, ArrayData arrayData) {
    var primitiveSpill = dualFields ? new long[values.size()] : null;
    var objectSpill = new Object[values.size()];
    for (var property : propertyMap.getProperties()) {
      if (!dualFields || property.getType() == Object.class) {
        objectSpill[property.getSlot()] = values.get(property.getSlot());
      } else {
        primitiveSpill[property.getSlot()] = ObjectClassGenerator.pack((Number) values.get(property.getSlot()));
      }
    }
    var object = dualFields ? new JD(propertyMap, primitiveSpill, objectSpill) : new JO(propertyMap, null, objectSpill);
    object.setInitialProto(global.getObjectPrototype());
    object.setArray(arrayData);
    return object;
  }

  static Class<?> getType(Object value) {
    return (value instanceof Integer) ? int.class
         : (value instanceof Double) ? double.class
         : Object.class;
  }

  void expectColon() {
    skipWhiteSpace();
    var n = next();
    if (n != ':') {
      throw expectedError(pos - 1, ":", toString(n));
    }
  }

  Object parseArray() {
    var arrayData = ArrayData.EMPTY_ARRAY;
    var state = STATE_EMPTY;
    assert peek() == '[';
    pos++;
    while (pos < length) {
      skipWhiteSpace();
      var c = peek();
      switch (c) {
        case ',' -> {
          if (state != STATE_ELEMENT_PARSED) {
            throw error(AbstractParser.message("trailing.comma.in.json"), pos);
          }
          state = STATE_COMMA_PARSED;
          pos++;
        }
        case ']' -> {
          if (state == STATE_COMMA_PARSED) {
            throw error(AbstractParser.message("trailing.comma.in.json"), pos);
          }
          pos++;
          return global.wrapAsObject(arrayData);
        }
        default -> {
          if (state == STATE_ELEMENT_PARSED) {
            throw expectedError(pos, ", or ]", toString(c));
          }
          var index = arrayData.length();
          arrayData = arrayData.ensure(index).set((int) index, parseLiteral());
          state = STATE_ELEMENT_PARSED;
        }
      }
    }
    throw expectedError(pos, ", or ]", "eof");
  }

  String parseString() {
    // String buffer is only instantiated if string contains escape sequences.
    var start = ++pos;
    StringBuilder sb = null;
    while (pos < length) {
      var c = next();
      if (c <= 0x1f) {
        // Characters < 0x1f are not allowed in JSON strings.
        throw syntaxError(pos, "String contains control character");
      } else if (c == '\\') {
        if (sb == null) {
          sb = new StringBuilder(pos - start + 16);
        }
        sb.append(source, start, pos - 1);
        sb.append(parseEscapeSequence());
        start = pos;
      } else if (c == '"') {
        if (sb != null) {
          sb.append(source, start, pos - 1);
          return sb.toString();
        }
        return source.substring(start, pos - 1);
      }
    }
    throw error(Lexer.message("missing.close.quote"), pos, length);
  }

  char parseEscapeSequence() {
    var c = next();
    return switch (c) {
      case '"' -> '"';
      case '\\' -> '\\';
      case '/' -> '/';
      case 'b' -> '\b';
      case 'f' -> '\f';
      case 'n' -> '\n';
      case 'r' -> '\r';
      case 't' -> '\t';
      case 'u' -> parseUnicodeEscape();
      default -> { throw error(Lexer.message("invalid.escape.char"), pos - 1, length); }
    };
  }

  char parseUnicodeEscape() {
    return (char) (parseHexDigit() << 12 | parseHexDigit() << 8 | parseHexDigit() << 4 | parseHexDigit());
  }

  int parseHexDigit() {
    var c = next();
    if (c >= '0' && c <= '9') {
      return c - '0';
    } else if (c >= 'A' && c <= 'F') {
      return c + 10 - 'A';
    } else if (c >= 'a' && c <= 'f') {
      return c + 10 - 'a';
    }
    throw error(Lexer.message("invalid.hex"), pos - 1, length);
  }

  boolean isDigit(int c) {
    return c >= '0' && c <= '9';
  }

  void skipDigits() {
    while (pos < length) {
      var c = peek();
      if (!isDigit(c)) {
        break;
      }
      pos++;
    }
  }

  Number parseNumber() {
    var start = pos;
    var c = next();
    if (c == '-') {
      c = next();
    }
    if (!isDigit(c)) {
      throw numberError(start);
    }
    // no more digits allowed after 0
    if (c != '0') {
      skipDigits();
    }
    // fraction
    if (peek() == '.') {
      pos++;
      if (!isDigit(next())) {
        throw numberError(pos - 1);
      }
      skipDigits();
    }
    // exponent
    c = peek();
    if (c == 'e' || c == 'E') {
      pos++;
      c = next();
      if (c == '-' || c == '+') {
        c = next();
      }
      if (!isDigit(c)) {
        throw numberError(pos - 1);
      }
      skipDigits();
    }
    var d = Double.parseDouble(source.substring(start, pos));
    if (JSType.isRepresentableAsInt(d)) {
      return (int) d;
    }
    return d;
  }

  Object parseKeyword(String keyword, Object value) {
    if (!source.regionMatches(pos, keyword, 0, keyword.length())) {
      throw expectedError(pos, "json literal", "ident");
    }
    pos += keyword.length();
    return value;
  }

  int peek() {
    if (pos >= length) {
      return -1;
    }
    return source.charAt(pos);
  }

  int next() {
    var next = peek();
    pos++;
    return next;
  }

  void skipWhiteSpace() {
    while (pos < length) {
      switch (peek()) {
        case '\t', '\r', '\n', ' ' -> pos++;
        default -> { return; }
      }
    }
  }

  static String toString(int c) {
    return c == EOF ? "eof" : String.valueOf((char) c);
  }

  ParserException error(String message, int start, int length) throws ParserException {
    var token = Token.toDesc(STRING, start, length);
    var loc = Token.descPosition(token);
    var src = Source.sourceFor("<json>", source);
    var lineNum = src.getLine(loc);
    var columnNum = src.getColumn(loc);
    var formatted = ErrorManager.format(message, src, lineNum, columnNum, token);
    return new ParserException(JSErrorType.SYNTAX_ERROR, formatted, src, lineNum, columnNum, token);
  }

  ParserException error(String message, int start) {
    return error(message, start, length);
  }

  ParserException numberError(int start) {
    return error(Lexer.message("json.invalid.number"), start);
  }

  ParserException expectedError(int start, String expected, String found) {
    return error(AbstractParser.message("expected", expected, found), start);
  }

  ParserException syntaxError(int start, String reason) {
    var message = ECMAErrors.getMessage("syntax.error.invalid.json", reason);
    return error(message, start);
  }

}
