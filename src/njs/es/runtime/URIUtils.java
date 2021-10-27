package es.runtime;

import static es.runtime.ECMAErrors.uriError;

/**
 * URI handling global functions.
 * ECMA 15.1.3 URI Handling Function Properties
 */
public final class URIUtils {

  static String encodeURI(Object self, String string) {
    return encode(self, string, false);
  }

  static String encodeURIComponent(Object self, String string) {
    return encode(self, string, true);
  }

  static String decodeURI(Object self, String string) {
    return decode(self, string, false);
  }

  static String decodeURIComponent(Object self, String string) {
    return decode(self, string, true);
  }

  // abstract encode function
  static String encode(Object self, String string, boolean component) {
    if (string.isEmpty()) {
      return string;
    }
    var len = string.length();
    var sb = new StringBuilder();
    for (var k = 0; k < len; k++) {
      var C = string.charAt(k);
      if (isUnescaped(C, component)) {
        sb.append(C);
        continue;
      }
      if (C >= 0xDC00 && C <= 0xDFFF) {
        return error(string, k);
      }
      int V;
      if (C < 0xD800 || C > 0xDBFF) {
        V = C;
      } else {
        k++;
        if (k == len) {
          return error(string, k);
        }
        var kChar = string.charAt(k);
        if (kChar < 0xDC00 || kChar > 0xDFFF) {
          return error(string, k);
        }
        V = ((C - 0xD800) * 0x400 + (kChar - 0xDC00) + 0x10000);
      }
      try {
        sb.append(toHexEscape(V));
      } catch (Exception e) {
        throw uriError(e, "bad.uri", string, Integer.toString(k));
      }
    }
    return sb.toString();
  }

  // abstract decode function
  static String decode(Object self, String string, boolean component) {
    if (string.isEmpty()) {
      return string;
    }
    var len = string.length();
    var sb = new StringBuilder();
    for (var k = 0; k < len; k++) {
      var ch = string.charAt(k);
      if (ch != '%') {
        sb.append(ch);
        continue;
      }
      var start = k;
      if (k + 2 >= len) {
        return error(string, k);
      }
      var B = toHexByte(string.charAt(k + 1), string.charAt(k + 2));
      if (B < 0) {
        return error(string, k + 1);
      }
      k += 2;
      char C;
      // Most significant bit is zero
      if ((B & 0x80) == 0) {
        C = (char) B;
        if (!component && URI_RESERVED.indexOf(C) >= 0) {
          for (var j = start; j <= k; j++) {
            sb.append(string.charAt(j));
          }
        } else {
          sb.append(C);
        }
      } else {
        // n is utf8 length, V is codepoint and minV is lower bound
        int n, V, minV;
        if ((B & 0xC0) == 0x80) {
          // 10xxxxxx - illegal first byte
          return error(string, k);
        } else if ((B & 0x20) == 0) {
          // 110xxxxx 10xxxxxx
          n = 2;
          V = B & 0x1F;
          minV = 0x80;
        } else if ((B & 0x10) == 0) {
          // 1110xxxx 10xxxxxx 10xxxxxx
          n = 3;
          V = B & 0x0F;
          minV = 0x800;
        } else if ((B & 0x08) == 0) {
          // 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
          n = 4;
          V = B & 0x07;
          minV = 0x10000;
        } else if ((B & 0x04) == 0) {
          // 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
          n = 5;
          V = B & 0x03;
          minV = 0x200000;
        } else if ((B & 0x02) == 0) {
          // 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
          n = 6;
          V = B & 0x01;
          minV = 0x4000000;
        } else {
          return error(string, k);
        }
        // check bound for sufficient chars
        if (k + (3 * (n - 1)) >= len) {
          return error(string, k);
        }
        for (var j = 1; j < n; j++) {
          k++;
          if (string.charAt(k) != '%') {
            return error(string, k);
          }
          B = toHexByte(string.charAt(k + 1), string.charAt(k + 2));
          if (B < 0 || (B & 0xC0) != 0x80) {
            return error(string, k + 1);
          }
          V = (V << 6) | (B & 0x3F);
          k += 2;
        }
        // Check for overlongs and invalid codepoints.
        // The high and low surrogate halves used by UTF-16 (U+D800 through U+DFFF) are not legal Unicode values.
        if ((V < minV) || (V >= 0xD800 && V <= 0xDFFF)) {
          V = Integer.MAX_VALUE;
        }
        if (V < 0x10000) {
          C = (char) V;
          if (!component && URI_RESERVED.indexOf(C) >= 0) {
            for (var j = start; j != k; j++) {
              sb.append(string.charAt(j));
            }
          } else {
            sb.append(C);
          }
        } else { // V >= 0x10000
          if (V > 0x10FFFF) {
            return error(string, k);
          }
          var L = ((V - 0x10000) & 0x3FF) + 0xDC00;
          var H = (((V - 0x10000) >> 10) & 0x3FF) + 0xD800;
          sb.append((char) H);
          sb.append((char) L);
        }
      }
    }
    return sb.toString();
  }

  static int hexDigit(char ch) {
    var chu = Character.toUpperCase(ch);
    if (chu >= '0' && chu <= '9') {
      return (chu - '0');
    } else if (chu >= 'A' && chu <= 'F') {
      return (chu - 'A' + 10);
    } else {
      return -1;
    }
  }

  static int toHexByte(char ch1, char ch2) {
    var i1 = hexDigit(ch1);
    var i2 = hexDigit(ch2);
    if (i1 >= 0 && i2 >= 0) {
      return (i1 << 4) | i2;
    }
    return -1;
  }

  static String toHexEscape(int u0) {
    var u = u0;
    int len;
    var b = new byte[6];
    if (u <= 0x7f) {
      b[0] = (byte) u;
      len = 1;
    } else {
      // > 0x7ff -> length 2
      // > 0xffff -> length 3
      // and so on. each new length is an additional 5 bits from the original 11
      // the final mask is 8-len zeros in the low part.
      len = 2;
      for (var mask = u >>> 11; mask != 0; mask >>>= 5) {
        len++;
      }
      for (var i = len - 1; i > 0; i--) {
        b[i] = (byte) (0x80 | (u & 0x3f));
        u >>>= 6; // 64 bits per octet.
      }
      b[0] = (byte) (~((1 << (8 - len)) - 1) | u);
    }
    var sb = new StringBuilder();
    for (var i = 0; i < len; i++) {
      sb.append('%');
      if ((b[i] & 0xff) < 0x10) {
        sb.append('0');
      }
      sb.append(Integer.toHexString(b[i] & 0xff).toUpperCase());
    }
    return sb.toString();
  }

  static String error(String string, int index) {
    throw uriError("bad.uri", string, Integer.toString(index));
  }

  // 'uriEscaped' except for alphanumeric chars
  private static final String URI_UNESCAPED_NONALPHANUMERIC = "-_.!~*'()";
  // 'uriReserved' + '#'
  private static final String URI_RESERVED = ";/?:@&=+$,#";

  static boolean isUnescaped(char ch, boolean component) {
    if (('A' <= ch && ch <= 'Z') || ('a' <= ch && ch <= 'z') || ('0' <= ch && ch <= '9')) {
      return true;
    }
    if (URI_UNESCAPED_NONALPHANUMERIC.indexOf(ch) >= 0) {
      return true;
    }
    if (!component) {
      return URI_RESERVED.indexOf(ch) >= 0;
    }
    return false;
  }

}
