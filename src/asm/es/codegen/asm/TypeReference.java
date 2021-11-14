package es.codegen.asm;

class TypeReference {

  static final int CLASS_TYPE_PARAMETER = 0x00;

  static final int METHOD_TYPE_PARAMETER = 0x01;

  static final int CLASS_EXTENDS = 0x10;

  static final int CLASS_TYPE_PARAMETER_BOUND = 0x11;

  static final int METHOD_TYPE_PARAMETER_BOUND = 0x12;

  static final int FIELD = 0x13;

  static final int METHOD_RETURN = 0x14;

  static final int METHOD_RECEIVER = 0x15;

  static final int METHOD_FORMAL_PARAMETER = 0x16;

  static final int THROWS = 0x17;

  static final int LOCAL_VARIABLE = 0x40;

  static final int RESOURCE_VARIABLE = 0x41;

  static final int EXCEPTION_PARAMETER = 0x42;

  static final int INSTANCEOF = 0x43;

  static final int NEW = 0x44;

  static final int CONSTRUCTOR_REFERENCE = 0x45;

  static final int METHOD_REFERENCE = 0x46;

  static final int CAST = 0x47;

  static final int CONSTRUCTOR_INVOCATION_TYPE_ARGUMENT = 0x48;

  static final int METHOD_INVOCATION_TYPE_ARGUMENT = 0x49;

  static final int CONSTRUCTOR_REFERENCE_TYPE_ARGUMENT = 0x4A;

  static final int METHOD_REFERENCE_TYPE_ARGUMENT = 0x4B;

  final int targetTypeAndInfo;

  TypeReference(int typeRef) {
    this.targetTypeAndInfo = typeRef;
  }

  static TypeReference newTypeReference(int sort) {
    return new TypeReference(sort << 24);
  }

  static TypeReference newTypeParameterReference(int sort, int paramIndex) {
    return new TypeReference((sort << 24) | (paramIndex << 16));
  }

  static TypeReference newTypeParameterBoundReference(int sort, int paramIndex, final int boundIndex) {
    return new TypeReference((sort << 24) | (paramIndex << 16) | (boundIndex << 8));
  }

  static TypeReference newSuperTypeReference(int itfIndex) {
    return new TypeReference((CLASS_EXTENDS << 24) | ((itfIndex & 0xFFFF) << 8));
  }

  static TypeReference newFormalParameterReference(int paramIndex) {
    return new TypeReference((METHOD_FORMAL_PARAMETER << 24) | (paramIndex << 16));
  }

  static TypeReference newExceptionReference(int exceptionIndex) {
    return new TypeReference((THROWS << 24) | (exceptionIndex << 8));
  }

  static TypeReference newTryCatchReference(int tryCatchBlockIndex) {
    return new TypeReference((EXCEPTION_PARAMETER << 24) | (tryCatchBlockIndex << 8));
  }

  static TypeReference newTypeArgumentReference(int sort, int argIndex) {
    return new TypeReference((sort << 24) | argIndex);
  }

  int getSort() {
    return targetTypeAndInfo >>> 24;
  }

  int getTypeParameterIndex() {
    return (targetTypeAndInfo & 0x00FF0000) >> 16;
  }

  int getTypeParameterBoundIndex() {
    return (targetTypeAndInfo & 0x0000FF00) >> 8;
  }

  int getSuperTypeIndex() {
    return (short) ((targetTypeAndInfo & 0x00FFFF00) >> 8);
  }

  int getFormalParameterIndex() {
    return (targetTypeAndInfo & 0x00FF0000) >> 16;
  }

  int getExceptionIndex() {
    return (targetTypeAndInfo & 0x00FFFF00) >> 8;
  }

  int getTryCatchBlockIndex() {
    return (targetTypeAndInfo & 0x00FFFF00) >> 8;
  }

  int getTypeArgumentIndex() {
    return targetTypeAndInfo & 0xFF;
  }

  int getValue() {
    return targetTypeAndInfo;
  }

  static void putTarget(int targetTypeAndInfo, ByteVector output) {
    switch (targetTypeAndInfo >>> 24) {
      case CLASS_TYPE_PARAMETER:
      case METHOD_TYPE_PARAMETER:
      case METHOD_FORMAL_PARAMETER:
        output.putShort(targetTypeAndInfo >>> 16);
        break;
      case FIELD:
      case METHOD_RETURN:
      case METHOD_RECEIVER:
        output.putByte(targetTypeAndInfo >>> 24);
        break;
      case CAST:
      case CONSTRUCTOR_INVOCATION_TYPE_ARGUMENT:
      case METHOD_INVOCATION_TYPE_ARGUMENT:
      case CONSTRUCTOR_REFERENCE_TYPE_ARGUMENT:
      case METHOD_REFERENCE_TYPE_ARGUMENT:
        output.putInt(targetTypeAndInfo);
        break;
      case CLASS_EXTENDS:
      case CLASS_TYPE_PARAMETER_BOUND:
      case METHOD_TYPE_PARAMETER_BOUND:
      case THROWS:
      case EXCEPTION_PARAMETER:
      case INSTANCEOF:
      case NEW:
      case CONSTRUCTOR_REFERENCE:
      case METHOD_REFERENCE:
        output.put12(targetTypeAndInfo >>> 24, (targetTypeAndInfo & 0xFFFF00) >> 8);
        break;
      default:
        throw new IllegalArgumentException();
    }
  }
}
