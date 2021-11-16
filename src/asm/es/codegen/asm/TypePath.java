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

  @Override
  public String toString() {
    var length = getLength();
    var result = new StringBuilder(length * 2);
    for (var i = 0; i < length; ++i) {
      switch (getStep(i)) {
        case ARRAY_ELEMENT -> result.append('[');
        case INNER_TYPE -> result.append('.');
        case WILDCARD_BOUND -> result.append('*');
        case TYPE_ARGUMENT -> result.append(getStepArgument(i)).append(';');
        default -> throw new AssertionError();
      }
    }
    return result.toString();
  }

  static void put(TypePath typePath, ByteVector output) {
    if (typePath == null) {
      output.putByte(0);
    } else {
      var length = typePath.typePathContainer[typePath.typePathOffset] * 2 + 1;
      output.putByteArray(typePath.typePathContainer, typePath.typePathOffset, length);
    }
  }
}
