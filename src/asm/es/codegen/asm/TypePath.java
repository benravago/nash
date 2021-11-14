package es.codegen.asm;

class TypePath {

  static final int ARRAY_ELEMENT = 0;
  static final int INNER_TYPE = 1;
  static final int WILDCARD_BOUND = 2;
  static final int TYPE_ARGUMENT = 3;

  final byte[] typePathContainer;
  final int typePathOffset;

  TypePath(byte[] typePathContainer, int typePathOffset) {
    this.typePathContainer = typePathContainer;
    this.typePathOffset = typePathOffset;
  }

  int getLength() {
    // path_length is stored in the first byte of a type_path.
    return typePathContainer[typePathOffset];
  }

  int getStep(int index) {
    // Returns the type_path_kind of the path element of the given index.
    return typePathContainer[typePathOffset + 2 * index + 1];
  }

  int getStepArgument(int index) {
    // Returns the type_argument_index of the path element of the given index.
    return typePathContainer[typePathOffset + 2 * index + 2];
  }

  static TypePath fromString(String typePath) {
    if (typePath == null || typePath.isEmpty()) {
      return null;
    }
    int typePathLength = typePath.length();
    ByteVector output = new ByteVector(typePathLength);
    output.putByte(0);
    int typePathIndex = 0;
    while (typePathIndex < typePathLength) {
      char c = typePath.charAt(typePathIndex++);
      if (c == '[') {
        output.put11(ARRAY_ELEMENT, 0);
      } else if (c == '.') {
        output.put11(INNER_TYPE, 0);
      } else if (c == '*') {
        output.put11(WILDCARD_BOUND, 0);
      } else if (c >= '0' && c <= '9') {
        int typeArg = c - '0';
        while (typePathIndex < typePathLength) {
          c = typePath.charAt(typePathIndex++);
          if (c >= '0' && c <= '9') {
            typeArg = typeArg * 10 + c - '0';
          } else if (c == ';') {
            break;
          } else {
            throw new IllegalArgumentException();
          }
        }
        output.put11(TYPE_ARGUMENT, typeArg);
      } else {
        throw new IllegalArgumentException();
      }
    }
    output.data[0] = (byte) (output.length / 2);
    return new TypePath(output.data, 0);
  }

  @Override
  public String toString() {
    int length = getLength();
    StringBuilder result = new StringBuilder(length * 2);
    for (int i = 0; i < length; ++i) {
      switch (getStep(i)) {
        case ARRAY_ELEMENT:
          result.append('[');
          break;
        case INNER_TYPE:
          result.append('.');
          break;
        case WILDCARD_BOUND:
          result.append('*');
          break;
        case TYPE_ARGUMENT:
          result.append(getStepArgument(i)).append(';');
          break;
        default:
          throw new AssertionError();
      }
    }
    return result.toString();
  }

  static void put(TypePath typePath, ByteVector output) {
    if (typePath == null) {
      output.putByte(0);
    } else {
      int length = typePath.typePathContainer[typePath.typePathOffset] * 2 + 1;
      output.putByteArray(typePath.typePathContainer, typePath.typePathOffset, length);
    }
  }
}
