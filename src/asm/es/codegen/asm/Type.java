package es.codegen.asm;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

public class Type {

  public static final int VOID = 0;
  public static final int BOOLEAN = 1;
  public static final int CHAR = 2;
  static final int BYTE = 3;
  static final int SHORT = 4;
  public static final int INT = 5;
  public static final int FLOAT = 6;
  public static final int LONG = 7;
  public static final int DOUBLE = 8;
  public static final int ARRAY = 9;
  public static final int OBJECT = 10;
  static final int METHOD = 11;
  static final int INTERNAL = 12;

  static final String PRIMITIVE_DESCRIPTORS = "VZCBSIFJD";

  public static final Type VOID_TYPE = new Type(VOID, PRIMITIVE_DESCRIPTORS, VOID, VOID + 1);
  public static final Type BOOLEAN_TYPE = new Type(BOOLEAN, PRIMITIVE_DESCRIPTORS, BOOLEAN, BOOLEAN + 1);
  static final Type CHAR_TYPE = new Type(CHAR, PRIMITIVE_DESCRIPTORS, CHAR, CHAR + 1);
  static final Type BYTE_TYPE = new Type(BYTE, PRIMITIVE_DESCRIPTORS, BYTE, BYTE + 1);
  static final Type SHORT_TYPE = new Type(SHORT, PRIMITIVE_DESCRIPTORS, SHORT, SHORT + 1);
  public static final Type INT_TYPE = new Type(INT, PRIMITIVE_DESCRIPTORS, INT, INT + 1);
  static final Type FLOAT_TYPE = new Type(FLOAT, PRIMITIVE_DESCRIPTORS, FLOAT, FLOAT + 1);
  public static final Type LONG_TYPE = new Type(LONG, PRIMITIVE_DESCRIPTORS, LONG, LONG + 1);
  public static final Type DOUBLE_TYPE = new Type(DOUBLE, PRIMITIVE_DESCRIPTORS, DOUBLE, DOUBLE + 1);

  final int sort;
  final String valueBuffer;
  final int valueBegin;
  final int valueEnd;

  protected Type(int sort, String valueBuffer, int valueBegin, int valueEnd) {
    this.sort = sort;
    this.valueBuffer = valueBuffer;
    this.valueBegin = valueBegin;
    this.valueEnd = valueEnd;
  }

  public static Type getType(String typeDescriptor) {
    return getTypeInternal(typeDescriptor, 0, typeDescriptor.length());
  }

  public static Type getType(Class<?> clazz) {
    if (clazz.isPrimitive()) {
      if (clazz == Integer.TYPE) return INT_TYPE; else
      if (clazz == Void.TYPE) return VOID_TYPE; else
      if (clazz == Boolean.TYPE) return BOOLEAN_TYPE; else
      if (clazz == Byte.TYPE) return BYTE_TYPE; else
      if (clazz == Character.TYPE) return CHAR_TYPE; else
      if (clazz == Short.TYPE) return SHORT_TYPE; else
      if (clazz == Double.TYPE) return DOUBLE_TYPE; else
      if (clazz == Float.TYPE) return FLOAT_TYPE; else
      if (clazz == Long.TYPE) return LONG_TYPE; else
      throw new AssertionError();
    } else {
      return getType(getDescriptor(clazz));
    }
  }

  public static Type getType(Constructor<?> constructor) {
    return getType(getConstructorDescriptor(constructor));
  }

  static Type getType(Method method) {
    return getType(getMethodDescriptor(method));
  }

  public Type getElementType() {
    var numDimensions = getDimensions();
    return getTypeInternal(valueBuffer, valueBegin + numDimensions, valueEnd);
  }

  public static Type getObjectType(String internalName) {
    return new Type(internalName.charAt(0) == '[' ? ARRAY : INTERNAL, internalName, 0, internalName.length());
  }

  public static Type getMethodType(String methodDescriptor) {
    return new Type(METHOD, methodDescriptor, 0, methodDescriptor.length());
  }

  static Type getMethodType(Type returnType, Type... argumentTypes) {
    return getType(getMethodDescriptor(returnType, argumentTypes));
  }

  public Type[] getArgumentTypes() {
    return getArgumentTypes(getDescriptor());
  }

  public static Type[] getArgumentTypes(String methodDescriptor) {
    // First step: compute the number of argument types in methodDescriptor.
    var numArgumentTypes = 0;
    // Skip the first character, which is always a '('.
    var currentOffset = 1;
    // Parse the argument types, one at a each loop iteration.
    while (methodDescriptor.charAt(currentOffset) != ')') {
      while (methodDescriptor.charAt(currentOffset) == '[') {
        currentOffset++;
      }
      if (methodDescriptor.charAt(currentOffset++) == 'L') {
        // Skip the argument descriptor content.
        currentOffset = methodDescriptor.indexOf(';', currentOffset) + 1;
      }
      ++numArgumentTypes;
    }
    // Second step: create a Type instance for each argument type.
    var argumentTypes = new Type[numArgumentTypes];
    // Skip the first character, which is always a '('.
    currentOffset = 1;
    // Parse and create the argument types, one at each loop iteration.
    var currentArgumentTypeIndex = 0;
    while (methodDescriptor.charAt(currentOffset) != ')') {
      var currentArgumentTypeOffset = currentOffset;
      while (methodDescriptor.charAt(currentOffset) == '[') {
        currentOffset++;
      }
      if (methodDescriptor.charAt(currentOffset++) == 'L') {
        // Skip the argument descriptor content.
        currentOffset = methodDescriptor.indexOf(';', currentOffset) + 1;
      }
      argumentTypes[currentArgumentTypeIndex++] = getTypeInternal(methodDescriptor, currentArgumentTypeOffset, currentOffset);
    }
    return argumentTypes;
  }

  static Type[] getArgumentTypes(Method method) {
    var classes = method.getParameterTypes();
    var types = new Type[classes.length];
    for (var i = classes.length - 1; i >= 0; --i) {
      types[i] = getType(classes[i]);
    }
    return types;
  }

  public Type getReturnType() {
    return getReturnType(getDescriptor());
  }

  public static Type getReturnType(String methodDescriptor) {
    // Skip the first character, which is always a '('.
    var currentOffset = 1;
    // Skip the argument types, one at a each loop iteration.
    while (methodDescriptor.charAt(currentOffset) != ')') {
      while (methodDescriptor.charAt(currentOffset) == '[') {
        currentOffset++;
      }
      if (methodDescriptor.charAt(currentOffset++) == 'L') {
        // Skip the argument descriptor content.
        currentOffset = methodDescriptor.indexOf(';', currentOffset) + 1;
      }
    }
    return getTypeInternal(methodDescriptor, currentOffset + 1, methodDescriptor.length());
  }

  static Type getReturnType(Method method) {
    return getType(method.getReturnType());
  }

  static Type getTypeInternal(String descriptorBuffer, int descriptorBegin, int descriptorEnd) {
    return switch (descriptorBuffer.charAt(descriptorBegin)) {
      case 'V' -> VOID_TYPE;
      case 'Z' -> BOOLEAN_TYPE;
      case 'C' -> CHAR_TYPE;
      case 'B' -> BYTE_TYPE;
      case 'S' -> SHORT_TYPE;
      case 'I' -> INT_TYPE;
      case 'F' -> FLOAT_TYPE;
      case 'J' -> LONG_TYPE;
      case 'D' -> DOUBLE_TYPE;
      case '[' -> new Type(ARRAY, descriptorBuffer, descriptorBegin, descriptorEnd);
      case 'L' -> new Type(OBJECT, descriptorBuffer, descriptorBegin + 1, descriptorEnd - 1);
      case '(' -> new Type(METHOD, descriptorBuffer, descriptorBegin, descriptorEnd);
      default -> throw new IllegalArgumentException();
    };
  }

  public String getClassName() {
    return switch (sort) {
      case VOID -> "void";
      case BOOLEAN -> "boolean";
      case CHAR -> "char";
      case BYTE -> "byte";
      case SHORT -> "short";
      case INT -> "int";
      case FLOAT -> "float";
      case LONG -> "long";
      case DOUBLE -> "double";
      case OBJECT, INTERNAL -> valueBuffer.substring(valueBegin, valueEnd).replace('/', '.');
      case ARRAY -> {
        var stringBuilder = new StringBuilder(getElementType().getClassName());
        for (var i = getDimensions(); i > 0; --i) {
          stringBuilder.append("[]");
        }
        yield stringBuilder.toString();
      }
      default -> throw new AssertionError();
    };
  }

  public String getInternalName() {
    return valueBuffer.substring(valueBegin, valueEnd);
  }

  public static String getInternalName(Class<?> clazz) {
    return clazz.getName().replace('.', '/');
  }

  public String getDescriptor() {
    return switch (sort) {
      case OBJECT -> valueBuffer.substring(valueBegin - 1, valueEnd + 1);
      case INTERNAL -> new StringBuilder().append('L').append(valueBuffer, valueBegin, valueEnd).append(';').toString();
      default -> valueBuffer.substring(valueBegin, valueEnd);
    };
  }

  public static String getDescriptor(Class<?> clazz) {
    var stringBuilder = new StringBuilder();
    appendDescriptor(clazz, stringBuilder);
    return stringBuilder.toString();
  }

  static String getConstructorDescriptor(Constructor<?> constructor) {
    var stringBuilder = new StringBuilder();
    stringBuilder.append('(');
    var parameters = constructor.getParameterTypes();
    for (var parameter : parameters) {
      appendDescriptor(parameter, stringBuilder);
    }
    return stringBuilder.append(")V").toString();
  }

  public static String getMethodDescriptor(Type returnType, Type... argumentTypes) {
    var stringBuilder = new StringBuilder();
    stringBuilder.append('(');
    for (var argumentType : argumentTypes) {
      argumentType.appendDescriptor(stringBuilder);
    }
    stringBuilder.append(')');
    returnType.appendDescriptor(stringBuilder);
    return stringBuilder.toString();
  }

  static String getMethodDescriptor(Method method) {
    var stringBuilder = new StringBuilder();
    stringBuilder.append('(');
    var parameters = method.getParameterTypes();
    for (var parameter : parameters) {
      appendDescriptor(parameter, stringBuilder);
    }
    stringBuilder.append(')');
    appendDescriptor(method.getReturnType(), stringBuilder);
    return stringBuilder.toString();
  }

  void appendDescriptor(StringBuilder stringBuilder) {
    switch (sort) {
      case OBJECT -> stringBuilder.append(valueBuffer, valueBegin - 1, valueEnd + 1);
      case INTERNAL -> stringBuilder.append('L').append(valueBuffer, valueBegin, valueEnd).append(';');
      default -> stringBuilder.append(valueBuffer, valueBegin, valueEnd);
    }
  }

  static void appendDescriptor(Class<?> clazz, StringBuilder stringBuilder) {
    var currentClass = clazz;
    while (currentClass.isArray()) {
      stringBuilder.append('[');
      currentClass = currentClass.getComponentType();
    }
    if (currentClass.isPrimitive()) {
      char descriptor;
      if (currentClass == Integer.TYPE) descriptor = 'I'; else
      if (currentClass == Void.TYPE) descriptor = 'V'; else
      if (currentClass == Boolean.TYPE) descriptor = 'Z'; else
      if (currentClass == Byte.TYPE) descriptor = 'B'; else
      if (currentClass == Character.TYPE) descriptor = 'C'; else
      if (currentClass == Short.TYPE) descriptor = 'S'; else
      if (currentClass == Double.TYPE) descriptor = 'D'; else
      if (currentClass == Float.TYPE) descriptor = 'F'; else
      if (currentClass == Long.TYPE) descriptor = 'J'; else
      throw new AssertionError();
      stringBuilder.append(descriptor);
    } else {
      stringBuilder.append('L');
      var name = currentClass.getName();
      var nameLength = name.length();
      for (var i = 0; i < nameLength; ++i) {
        var car = name.charAt(i);
        stringBuilder.append(car == '.' ? '/' : car);
      }
      stringBuilder.append(';');
    }
  }

  public int getSort() {
    return sort == INTERNAL ? OBJECT : sort;
  }

  int getDimensions() {
    var numDimensions = 1;
    while (valueBuffer.charAt(valueBegin + numDimensions) == '[') {
      numDimensions++;
    }
    return numDimensions;
  }

  public int getSize() {
    return switch (sort) {
      case VOID -> 0;
      case BOOLEAN, CHAR, BYTE, SHORT, INT, FLOAT, ARRAY, OBJECT, INTERNAL -> 1;
      case LONG, DOUBLE -> 2;
      default -> throw new AssertionError();
    };
  }

  int getArgumentsAndReturnSizes() {
    return getArgumentsAndReturnSizes(getDescriptor());
  }

  static int getArgumentsAndReturnSizes(String methodDescriptor) {
    var argumentsSize = 1;
    // Skip the first character, which is always a '('.
    var currentOffset = 1;
    var currentChar = methodDescriptor.charAt(currentOffset);
    // Parse the argument types and compute their size, one at a each loop iteration.
    while (currentChar != ')') {
      if (currentChar == 'J' || currentChar == 'D') {
        currentOffset++;
        argumentsSize += 2;
      } else {
        while (methodDescriptor.charAt(currentOffset) == '[') {
          currentOffset++;
        }
        if (methodDescriptor.charAt(currentOffset++) == 'L') {
          // Skip the argument descriptor content.
          currentOffset = methodDescriptor.indexOf(';', currentOffset) + 1;
        }
        argumentsSize += 1;
      }
      currentChar = methodDescriptor.charAt(currentOffset);
    }
    currentChar = methodDescriptor.charAt(currentOffset + 1);
    if (currentChar == 'V') {
      return argumentsSize << 2;
    } else {
      int returnSize = (currentChar == 'J' || currentChar == 'D') ? 2 : 1;
      return argumentsSize << 2 | returnSize;
    }
  }

  public int getOpcode(int opcode) {
    if (opcode == Opcodes.IALOAD || opcode == Opcodes.IASTORE) {
      return switch (sort) {
        case BOOLEAN, BYTE -> opcode + (Opcodes.BALOAD - Opcodes.IALOAD);
        case CHAR -> opcode + (Opcodes.CALOAD - Opcodes.IALOAD);
        case SHORT -> opcode + (Opcodes.SALOAD - Opcodes.IALOAD);
        case INT -> opcode;
        case FLOAT -> opcode + (Opcodes.FALOAD - Opcodes.IALOAD);
        case LONG -> opcode + (Opcodes.LALOAD - Opcodes.IALOAD);
        case DOUBLE -> opcode + (Opcodes.DALOAD - Opcodes.IALOAD);
        case ARRAY, OBJECT, INTERNAL -> opcode + (Opcodes.AALOAD - Opcodes.IALOAD);
        case METHOD, VOID -> throw new UnsupportedOperationException();
        default -> throw new AssertionError();
      };
    } else {
      return switch (sort) {
        case BOOLEAN, BYTE, CHAR, SHORT, INT -> opcode;
        case FLOAT -> opcode + (Opcodes.FRETURN - Opcodes.IRETURN);
        case LONG -> opcode + (Opcodes.LRETURN - Opcodes.IRETURN);
        case DOUBLE -> opcode + (Opcodes.DRETURN - Opcodes.IRETURN);
        case VOID -> {
          if (opcode != Opcodes.IRETURN) {
            throw new UnsupportedOperationException();
          }
          yield Opcodes.RETURN;
        }
        case ARRAY, OBJECT, INTERNAL -> {
          if (opcode != Opcodes.ILOAD && opcode != Opcodes.ISTORE && opcode != Opcodes.IRETURN) {
            throw new UnsupportedOperationException();
          }
          yield opcode + (Opcodes.ARETURN - Opcodes.IRETURN);
        }
        case METHOD -> throw new UnsupportedOperationException();
        default -> throw new AssertionError();
      };
    }
  }

  @Override
  public boolean equals(Object object) {
    if (this == object) {
      return true;
    }
    if (!(object instanceof Type)) {
      return false;
    }
    var other = (Type) object;
    if ((sort == INTERNAL ? OBJECT : sort) != (other.sort == INTERNAL ? OBJECT : other.sort)) {
      return false;
    }
    var begin = valueBegin;
    var end = valueEnd;
    var otherBegin = other.valueBegin;
    var otherEnd = other.valueEnd;
    // Compare the values.
    if (end - begin != otherEnd - otherBegin) {
      return false;
    }
    for (int i = begin, j = otherBegin; i < end; i++, j++) {
      if (valueBuffer.charAt(i) != other.valueBuffer.charAt(j)) {
        return false;
      }
    }
    return true;
  }

  @Override
  public int hashCode() {
    var hashCode = 13 * (sort == INTERNAL ? OBJECT : sort);
    if (sort >= ARRAY) {
      for (int i = valueBegin, end = valueEnd; i < end; i++) {
        hashCode = 17 * (hashCode + valueBuffer.charAt(i));
      }
    }
    return hashCode;
  }

  @Override
  public String toString() {
    return getDescriptor();
  }
}
