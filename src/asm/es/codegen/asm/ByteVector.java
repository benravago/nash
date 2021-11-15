package es.codegen.asm;

class ByteVector {

  byte[] data;

  int length;

  ByteVector() {
    data = new byte[64];
  }

  ByteVector(int initialCapacity) {
    data = new byte[initialCapacity];
  }

  ByteVector(byte[] data) {
    this.data = data;
    this.length = data.length;
  }

  ByteVector putByte(int byteValue) {
    if (length + 1 > data.length) {
      enlarge(1);
    }
    data[length++] = (byte) byteValue;
    return this;
  }

  ByteVector put11(int byteValue1, int byteValue2) {
    if (length + 2 > data.length) {
      enlarge(2);
    }
    data[length++] = (byte) byteValue1;
    data[length++] = (byte) byteValue2;
    return this;
  }

  ByteVector putShort(int shortValue) {
    if (length + 2 > data.length) {
      enlarge(2);
    }
    data[length++] = (byte) (shortValue >>> 8);
    data[length++] = (byte) shortValue;
    return this;
  }

  ByteVector put12(int byteValue, int shortValue) {
    if (length + 3 > data.length) {
      enlarge(3);
    }
    data[length++] = (byte) byteValue;
    data[length++] = (byte) (shortValue >>> 8);
    data[length++] = (byte) shortValue;
    return this;
  }

  ByteVector put112(int byteValue1, int byteValue2, int shortValue) {
    if (length + 4 > data.length) {
      enlarge(4);
    }
    data[length++] = (byte) byteValue1;
    data[length++] = (byte) byteValue2;
    data[length++] = (byte) (shortValue >>> 8);
    data[length++] = (byte) shortValue;
    return this;
  }

  ByteVector putInt(int intValue) {
    if (length + 4 > data.length) {
      enlarge(4);
    }
    data[length++] = (byte) (intValue >>> 24);
    data[length++] = (byte) (intValue >>> 16);
    data[length++] = (byte) (intValue >>> 8);
    data[length++] = (byte) intValue;
    return this;
  }

  ByteVector put122(int byteValue, int shortValue1, int shortValue2) {
    if (length + 5 > data.length) {
      enlarge(5);
    }
    data[length++] = (byte) byteValue;
    data[length++] = (byte) (shortValue1 >>> 8);
    data[length++] = (byte) shortValue1;
    data[length++] = (byte) (shortValue2 >>> 8);
    data[length++] = (byte) shortValue2;
    return this;
  }

  ByteVector putLong(long longValue) {
    if (length + 8 > data.length) {
      enlarge(8);
    }
    var intValue = (int) (longValue >>> 32);
    data[length++] = (byte) (intValue >>> 24);
    data[length++] = (byte) (intValue >>> 16);
    data[length++] = (byte) (intValue >>> 8);
    data[length++] = (byte) intValue;
    intValue = (int) longValue;
    data[length++] = (byte) (intValue >>> 24);
    data[length++] = (byte) (intValue >>> 16);
    data[length++] = (byte) (intValue >>> 8);
    data[length++] = (byte) intValue;
    return this;
  }

  ByteVector putUTF8(String stringValue) {
    var charLength = stringValue.length();
    if (charLength > 65535) {
      throw new IllegalArgumentException("UTF8 string too large");
    }
    if (length + 2 + charLength > data.length) {
      enlarge(2 + charLength);
    }
    // Optimistic algorithm: instead of computing the byte length and then serializing the string
    // (which requires two loops), we assume the byte length is equal to char length (which is the
    // most frequent case), and we start serializing the string right away. During the
    // serialization, if we find that this assumption is wrong, we continue with the general method.
    data[length++] = (byte) (charLength >>> 8);
    data[length++] = (byte) charLength;
    for (var i = 0; i < charLength; ++i) {
      var charValue = stringValue.charAt(i);
      if (charValue >= '\u0001' && charValue <= '\u007F') {
        data[length++] = (byte) charValue;
      } else {
        return encodeUtf8(stringValue, i, 65535);
      }
    }
    return this;
  }

  ByteVector encodeUtf8(String stringValue, int offset, int maxByteLength) {
    var charLength = stringValue.length();
    var byteLength = offset;
    for (var i = offset; i < charLength; ++i) {
      var charValue = stringValue.charAt(i);
      if (charValue >= 0x0001 && charValue <= 0x007F) {
        byteLength++;
      } else if (charValue <= 0x07FF) {
        byteLength += 2;
      } else {
        byteLength += 3;
      }
    }
    if (byteLength > maxByteLength) {
      throw new IllegalArgumentException("UTF8 string too large");
    }
    // Compute where 'byteLength' must be stored in 'data', and store it at this location.
    var byteLengthOffset = length - offset - 2;
    if (byteLengthOffset >= 0) {
      data[byteLengthOffset] = (byte) (byteLength >>> 8);
      data[byteLengthOffset + 1] = (byte) byteLength;
    }
    if (length + byteLength - offset > data.length) {
      enlarge(byteLength - offset);
    }
    var currentLength = length;
    for (var i = offset; i < charLength; ++i) {
      var charValue = stringValue.charAt(i);
      if (charValue >= 0x0001 && charValue <= 0x007F) {
        data[currentLength++] = (byte) charValue;
      } else if (charValue <= 0x07FF) {
        data[currentLength++] = (byte) (0xC0 | charValue >> 6 & 0x1F);
        data[currentLength++] = (byte) (0x80 | charValue & 0x3F);
      } else {
        data[currentLength++] = (byte) (0xE0 | charValue >> 12 & 0xF);
        data[currentLength++] = (byte) (0x80 | charValue >> 6 & 0x3F);
        data[currentLength++] = (byte) (0x80 | charValue & 0x3F);
      }
    }
    length = currentLength;
    return this;
  }

  ByteVector putByteArray(byte[] byteArrayValue, int byteOffset, int byteLength) {
    if (length + byteLength > data.length) {
      enlarge(byteLength);
    }
    if (byteArrayValue != null) {
      System.arraycopy(byteArrayValue, byteOffset, data, length, byteLength);
    }
    length += byteLength;
    return this;
  }

  void enlarge(int size) {
    var doubleCapacity = 2 * data.length;
    var minimalCapacity = length + size;
    var newData = new byte[doubleCapacity > minimalCapacity ? doubleCapacity : minimalCapacity];
    System.arraycopy(data, 0, newData, 0, length);
    data = newData;
  }
}
