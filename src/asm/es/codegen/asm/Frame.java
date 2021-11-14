package es.codegen.asm;

class Frame {

  // Constants used in the StackMapTable attribute.
  // See https://docs.oracle.com/javase/specs/jvms/se9/html/jvms-4.html#jvms-4.7.4.
  static final int SAME_FRAME = 0;
  static final int SAME_LOCALS_1_STACK_ITEM_FRAME = 64;
  static final int RESERVED = 128;
  static final int SAME_LOCALS_1_STACK_ITEM_FRAME_EXTENDED = 247;
  static final int CHOP_FRAME = 248;
  static final int SAME_FRAME_EXTENDED = 251;
  static final int APPEND_FRAME = 252;
  static final int FULL_FRAME = 255;

  static final int ITEM_TOP = 0;
  static final int ITEM_INTEGER = 1;
  static final int ITEM_FLOAT = 2;
  static final int ITEM_DOUBLE = 3;
  static final int ITEM_LONG = 4;
  static final int ITEM_NULL = 5;
  static final int ITEM_UNINITIALIZED_THIS = 6;
  static final int ITEM_OBJECT = 7;
  static final int ITEM_UNINITIALIZED = 8;
  // Additional, ASM specific constants used in abstract types below.
  static final int ITEM_ASM_BOOLEAN = 9;
  static final int ITEM_ASM_BYTE = 10;
  static final int ITEM_ASM_CHAR = 11;
  static final int ITEM_ASM_SHORT = 12;

  // Bitmasks to get each field of an abstract type.
  static final int DIM_MASK = 0xF0000000;
  static final int KIND_MASK = 0x0F000000;
  static final int FLAGS_MASK = 0x00F00000;
  static final int VALUE_MASK = 0x000FFFFF;

  // Constants to manipulate the DIM field of an abstract type.
  static final int DIM_SHIFT = 28;

  static final int ARRAY_OF = +1 << DIM_SHIFT;

  static final int ELEMENT_OF = -1 << DIM_SHIFT;

  // Possible values for the KIND field of an abstract type.
  static final int CONSTANT_KIND = 0x01000000;
  static final int REFERENCE_KIND = 0x02000000;
  static final int UNINITIALIZED_KIND = 0x03000000;
  static final int LOCAL_KIND = 0x04000000;
  static final int STACK_KIND = 0x05000000;

  // Possible flags for the FLAGS field of an abstract type.
  static final int TOP_IF_LONG_OR_DOUBLE_FLAG = 0x00100000 & FLAGS_MASK;

  // Useful predefined abstract types (all the possible CONSTANT_KIND types).
  static final int TOP = CONSTANT_KIND | ITEM_TOP;
  static final int BOOLEAN = CONSTANT_KIND | ITEM_ASM_BOOLEAN;
  static final int BYTE = CONSTANT_KIND | ITEM_ASM_BYTE;
  static final int CHAR = CONSTANT_KIND | ITEM_ASM_CHAR;
  static final int SHORT = CONSTANT_KIND | ITEM_ASM_SHORT;
  static final int INTEGER = CONSTANT_KIND | ITEM_INTEGER;
  static final int FLOAT = CONSTANT_KIND | ITEM_FLOAT;
  static final int LONG = CONSTANT_KIND | ITEM_LONG;
  static final int DOUBLE = CONSTANT_KIND | ITEM_DOUBLE;
  static final int NULL = CONSTANT_KIND | ITEM_NULL;
  static final int UNINITIALIZED_THIS = CONSTANT_KIND | ITEM_UNINITIALIZED_THIS;

  Label owner;

  int[] inputLocals;

  int[] inputStack;

  int[] outputLocals;

  int[] outputStack;

  short outputStackStart;

  short outputStackTop;

  int initializationCount;

  int[] initializations;

  Frame(Label owner) {
    this.owner = owner;
  }

  void copyFrom(Frame frame) {
    inputLocals = frame.inputLocals;
    inputStack = frame.inputStack;
    outputStackStart = 0;
    outputLocals = frame.outputLocals;
    outputStack = frame.outputStack;
    outputStackTop = frame.outputStackTop;
    initializationCount = frame.initializationCount;
    initializations = frame.initializations;
  }

  static int getAbstractTypeFromApiFormat(SymbolTable symbolTable, Object type) {
    if (type instanceof Integer) {
      return CONSTANT_KIND | ((Integer) type).intValue();
    } else if (type instanceof String) {
      String descriptor = Type.getObjectType((String) type).getDescriptor();
      return getAbstractTypeFromDescriptor(symbolTable, descriptor, 0);
    } else {
      return UNINITIALIZED_KIND | symbolTable.addUninitializedType("", ((Label) type).bytecodeOffset);
    }
  }

  static int getAbstractTypeFromInternalName(SymbolTable symbolTable, String internalName) {
    return REFERENCE_KIND | symbolTable.addType(internalName);
  }

  static int getAbstractTypeFromDescriptor(SymbolTable symbolTable, String buffer, int offset) {
    String internalName;
    switch (buffer.charAt(offset)) {
      case 'V':
        return 0;
      case 'Z':
      case 'C':
      case 'B':
      case 'S':
      case 'I':
        return INTEGER;
      case 'F':
        return FLOAT;
      case 'J':
        return LONG;
      case 'D':
        return DOUBLE;
      case 'L':
        internalName = buffer.substring(offset + 1, buffer.length() - 1);
        return REFERENCE_KIND | symbolTable.addType(internalName);
      case '[':
        int elementDescriptorOffset = offset + 1;
        while (buffer.charAt(elementDescriptorOffset) == '[') {
          ++elementDescriptorOffset;
        }
        int typeValue;
        switch (buffer.charAt(elementDescriptorOffset)) {
          case 'Z':
            typeValue = BOOLEAN;
            break;
          case 'C':
            typeValue = CHAR;
            break;
          case 'B':
            typeValue = BYTE;
            break;
          case 'S':
            typeValue = SHORT;
            break;
          case 'I':
            typeValue = INTEGER;
            break;
          case 'F':
            typeValue = FLOAT;
            break;
          case 'J':
            typeValue = LONG;
            break;
          case 'D':
            typeValue = DOUBLE;
            break;
          case 'L':
            internalName = buffer.substring(elementDescriptorOffset + 1, buffer.length() - 1);
            typeValue = REFERENCE_KIND | symbolTable.addType(internalName);
            break;
          default:
            throw new IllegalArgumentException();
        }
        return ((elementDescriptorOffset - offset) << DIM_SHIFT) | typeValue;
      default:
        throw new IllegalArgumentException();
    }
  }

  void setInputFrameFromDescriptor(SymbolTable symbolTable, int access, String descriptor, int maxLocals) {
    inputLocals = new int[maxLocals];
    inputStack = new int[0];
    int inputLocalIndex = 0;
    if ((access & Opcodes.ACC_STATIC) == 0) {
      if ((access & Constants.ACC_CONSTRUCTOR) == 0) {
        inputLocals[inputLocalIndex++] = REFERENCE_KIND | symbolTable.addType(symbolTable.getClassName());
      } else {
        inputLocals[inputLocalIndex++] = UNINITIALIZED_THIS;
      }
    }
    for (Type argumentType : Type.getArgumentTypes(descriptor)) {
      int abstractType = getAbstractTypeFromDescriptor(symbolTable, argumentType.getDescriptor(), 0);
      inputLocals[inputLocalIndex++] = abstractType;
      if (abstractType == LONG || abstractType == DOUBLE) {
        inputLocals[inputLocalIndex++] = TOP;
      }
    }
    while (inputLocalIndex < maxLocals) {
      inputLocals[inputLocalIndex++] = TOP;
    }
  }

  void setInputFrameFromApiFormat(SymbolTable symbolTable, int numLocal, Object[] local, int numStack,
          Object[] stack) {
    int inputLocalIndex = 0;
    for (int i = 0; i < numLocal; ++i) {
      inputLocals[inputLocalIndex++] = getAbstractTypeFromApiFormat(symbolTable, local[i]);
      if (local[i] == Opcodes.LONG || local[i] == Opcodes.DOUBLE) {
        inputLocals[inputLocalIndex++] = TOP;
      }
    }
    while (inputLocalIndex < inputLocals.length) {
      inputLocals[inputLocalIndex++] = TOP;
    }
    int numStackTop = 0;
    for (int i = 0; i < numStack; ++i) {
      if (stack[i] == Opcodes.LONG || stack[i] == Opcodes.DOUBLE) {
        ++numStackTop;
      }
    }
    inputStack = new int[numStack + numStackTop];
    int inputStackIndex = 0;
    for (int i = 0; i < numStack; ++i) {
      inputStack[inputStackIndex++] = getAbstractTypeFromApiFormat(symbolTable, stack[i]);
      if (stack[i] == Opcodes.LONG || stack[i] == Opcodes.DOUBLE) {
        inputStack[inputStackIndex++] = TOP;
      }
    }
    outputStackTop = 0;
    initializationCount = 0;
  }

  int getInputStackSize() {
    return inputStack.length;
  }

  int getLocal(int localIndex) {
    if (outputLocals == null || localIndex >= outputLocals.length) {
      // If this local has never been assigned in this basic block, it is still equal to its value
      // in the input frame.
      return LOCAL_KIND | localIndex;
    } else {
      int abstractType = outputLocals[localIndex];
      if (abstractType == 0) {
        // If this local has never been assigned in this basic block, so it is still equal to its
        // value in the input frame.
        abstractType = outputLocals[localIndex] = LOCAL_KIND | localIndex;
      }
      return abstractType;
    }
  }

  void setLocal(int localIndex, int abstractType) {
    // Create and/or resize the output local variables array if necessary.
    if (outputLocals == null) {
      outputLocals = new int[10];
    }
    int outputLocalsLength = outputLocals.length;
    if (localIndex >= outputLocalsLength) {
      int[] newOutputLocals = new int[Math.max(localIndex + 1, 2 * outputLocalsLength)];
      System.arraycopy(outputLocals, 0, newOutputLocals, 0, outputLocalsLength);
      outputLocals = newOutputLocals;
    }
    // Set the local variable.
    outputLocals[localIndex] = abstractType;
  }

  void push(int abstractType) {
    // Create and/or resize the output stack array if necessary.
    if (outputStack == null) {
      outputStack = new int[10];
    }
    int outputStackLength = outputStack.length;
    if (outputStackTop >= outputStackLength) {
      int[] newOutputStack = new int[Math.max(outputStackTop + 1, 2 * outputStackLength)];
      System.arraycopy(outputStack, 0, newOutputStack, 0, outputStackLength);
      outputStack = newOutputStack;
    }
    // Pushes the abstract type on the output stack.
    outputStack[outputStackTop++] = abstractType;
    // Updates the maximum size reached by the output stack, if needed (note that this size is
    // relative to the input stack size, which is not known yet).
    short outputStackSize = (short) (outputStackStart + outputStackTop);
    if (outputStackSize > owner.outputStackMax) {
      owner.outputStackMax = outputStackSize;
    }
  }

  void push(SymbolTable symbolTable, String descriptor) {
    int typeDescriptorOffset = descriptor.charAt(0) == '(' ? descriptor.indexOf(')') + 1 : 0;
    int abstractType = getAbstractTypeFromDescriptor(symbolTable, descriptor, typeDescriptorOffset);
    if (abstractType != 0) {
      push(abstractType);
      if (abstractType == LONG || abstractType == DOUBLE) {
        push(TOP);
      }
    }
  }

  int pop() {
    if (outputStackTop > 0) {
      return outputStack[--outputStackTop];
    } else {
      // If the output frame stack is empty, pop from the input stack.
      return STACK_KIND | -(--outputStackStart);
    }
  }

  void pop(int elements) {
    if (outputStackTop >= elements) {
      outputStackTop -= elements;
    } else {
      // If the number of elements to be popped is greater than the number of elements in the output
      // stack, clear it, and pop the remaining elements from the input stack.
      outputStackStart -= elements - outputStackTop;
      outputStackTop = 0;
    }
  }

  void pop(String descriptor) {
    char firstDescriptorChar = descriptor.charAt(0);
    if (firstDescriptorChar == '(') {
      pop((Type.getArgumentsAndReturnSizes(descriptor) >> 2) - 1);
    } else if (firstDescriptorChar == 'J' || firstDescriptorChar == 'D') {
      pop(2);
    } else {
      pop(1);
    }
  }

  void addInitializedType(int abstractType) {
    // Create and/or resize the initializations array if necessary.
    if (initializations == null) {
      initializations = new int[2];
    }
    int initializationsLength = initializations.length;
    if (initializationCount >= initializationsLength) {
      int[] newInitializations = new int[Math.max(initializationCount + 1, 2 * initializationsLength)];
      System.arraycopy(initializations, 0, newInitializations, 0, initializationsLength);
      initializations = newInitializations;
    }
    // Store the abstract type.
    initializations[initializationCount++] = abstractType;
  }

  int getInitializedType(SymbolTable symbolTable, int abstractType) {
    if (abstractType == UNINITIALIZED_THIS || (abstractType & (DIM_MASK | KIND_MASK)) == UNINITIALIZED_KIND) {
      for (int i = 0; i < initializationCount; ++i) {
        int initializedType = initializations[i];
        int dim = initializedType & DIM_MASK;
        int kind = initializedType & KIND_MASK;
        int value = initializedType & VALUE_MASK;
        if (kind == LOCAL_KIND) {
          initializedType = dim + inputLocals[value];
        } else if (kind == STACK_KIND) {
          initializedType = dim + inputStack[inputStack.length - value];
        }
        if (abstractType == initializedType) {
          if (abstractType == UNINITIALIZED_THIS) {
            return REFERENCE_KIND | symbolTable.addType(symbolTable.getClassName());
          } else {
            return REFERENCE_KIND | symbolTable.addType(symbolTable.getType(abstractType & VALUE_MASK).value);
          }
        }
      }
    }
    return abstractType;
  }

  void execute(int opcode, int arg, Symbol argSymbol, SymbolTable symbolTable) {
    // Abstract types popped from the stack or read from local variables.
    int abstractType1;
    int abstractType2;
    int abstractType3;
    int abstractType4;
    switch (opcode) {
      case Opcodes.NOP:
      case Opcodes.INEG:
      case Opcodes.LNEG:
      case Opcodes.FNEG:
      case Opcodes.DNEG:
      case Opcodes.I2B:
      case Opcodes.I2C:
      case Opcodes.I2S:
      case Opcodes.GOTO:
      case Opcodes.RETURN:
        break;
      case Opcodes.ACONST_NULL:
        push(NULL);
        break;
      case Opcodes.ICONST_M1:
      case Opcodes.ICONST_0:
      case Opcodes.ICONST_1:
      case Opcodes.ICONST_2:
      case Opcodes.ICONST_3:
      case Opcodes.ICONST_4:
      case Opcodes.ICONST_5:
      case Opcodes.BIPUSH:
      case Opcodes.SIPUSH:
      case Opcodes.ILOAD:
        push(INTEGER);
        break;
      case Opcodes.LCONST_0:
      case Opcodes.LCONST_1:
      case Opcodes.LLOAD:
        push(LONG);
        push(TOP);
        break;
      case Opcodes.FCONST_0:
      case Opcodes.FCONST_1:
      case Opcodes.FCONST_2:
      case Opcodes.FLOAD:
        push(FLOAT);
        break;
      case Opcodes.DCONST_0:
      case Opcodes.DCONST_1:
      case Opcodes.DLOAD:
        push(DOUBLE);
        push(TOP);
        break;
      case Opcodes.LDC:
        switch (argSymbol.tag) {
          case Symbol.CONSTANT_INTEGER_TAG:
            push(INTEGER);
            break;
          case Symbol.CONSTANT_LONG_TAG:
            push(LONG);
            push(TOP);
            break;
          case Symbol.CONSTANT_FLOAT_TAG:
            push(FLOAT);
            break;
          case Symbol.CONSTANT_DOUBLE_TAG:
            push(DOUBLE);
            push(TOP);
            break;
          case Symbol.CONSTANT_CLASS_TAG:
            push(REFERENCE_KIND | symbolTable.addType("java/lang/Class"));
            break;
          case Symbol.CONSTANT_STRING_TAG:
            push(REFERENCE_KIND | symbolTable.addType("java/lang/String"));
            break;
          case Symbol.CONSTANT_METHOD_TYPE_TAG:
            push(REFERENCE_KIND | symbolTable.addType("java/lang/invoke/MethodType"));
            break;
          case Symbol.CONSTANT_METHOD_HANDLE_TAG:
            push(REFERENCE_KIND | symbolTable.addType("java/lang/invoke/MethodHandle"));
            break;
          case Symbol.CONSTANT_DYNAMIC_TAG:
            push(symbolTable, argSymbol.value);
            break;
          default:
            throw new AssertionError();
        }
        break;
      case Opcodes.ALOAD:
        push(getLocal(arg));
        break;
      case Opcodes.LALOAD:
      case Opcodes.D2L:
        pop(2);
        push(LONG);
        push(TOP);
        break;
      case Opcodes.DALOAD:
      case Opcodes.L2D:
        pop(2);
        push(DOUBLE);
        push(TOP);
        break;
      case Opcodes.AALOAD:
        pop(1);
        abstractType1 = pop();
        push(abstractType1 == NULL ? abstractType1 : ELEMENT_OF + abstractType1);
        break;
      case Opcodes.ISTORE:
      case Opcodes.FSTORE:
      case Opcodes.ASTORE:
        abstractType1 = pop();
        setLocal(arg, abstractType1);
        if (arg > 0) {
          int previousLocalType = getLocal(arg - 1);
          if (previousLocalType == LONG || previousLocalType == DOUBLE) {
            setLocal(arg - 1, TOP);
          } else if ((previousLocalType & KIND_MASK) == LOCAL_KIND || (previousLocalType & KIND_MASK) == STACK_KIND) {
            // The type of the previous local variable is not known yet, but if it later appears
            // to be LONG or DOUBLE, we should then use TOP instead.
            setLocal(arg - 1, previousLocalType | TOP_IF_LONG_OR_DOUBLE_FLAG);
          }
        }
        break;
      case Opcodes.LSTORE:
      case Opcodes.DSTORE:
        pop(1);
        abstractType1 = pop();
        setLocal(arg, abstractType1);
        setLocal(arg + 1, TOP);
        if (arg > 0) {
          int previousLocalType = getLocal(arg - 1);
          if (previousLocalType == LONG || previousLocalType == DOUBLE) {
            setLocal(arg - 1, TOP);
          } else if ((previousLocalType & KIND_MASK) == LOCAL_KIND || (previousLocalType & KIND_MASK) == STACK_KIND) {
            // The type of the previous local variable is not known yet, but if it later appears
            // to be LONG or DOUBLE, we should then use TOP instead.
            setLocal(arg - 1, previousLocalType | TOP_IF_LONG_OR_DOUBLE_FLAG);
          }
        }
        break;
      case Opcodes.IASTORE:
      case Opcodes.BASTORE:
      case Opcodes.CASTORE:
      case Opcodes.SASTORE:
      case Opcodes.FASTORE:
      case Opcodes.AASTORE:
        pop(3);
        break;
      case Opcodes.LASTORE:
      case Opcodes.DASTORE:
        pop(4);
        break;
      case Opcodes.POP:
      case Opcodes.IFEQ:
      case Opcodes.IFNE:
      case Opcodes.IFLT:
      case Opcodes.IFGE:
      case Opcodes.IFGT:
      case Opcodes.IFLE:
      case Opcodes.IRETURN:
      case Opcodes.FRETURN:
      case Opcodes.ARETURN:
      case Opcodes.TABLESWITCH:
      case Opcodes.LOOKUPSWITCH:
      case Opcodes.ATHROW:
      case Opcodes.MONITORENTER:
      case Opcodes.MONITOREXIT:
      case Opcodes.IFNULL:
      case Opcodes.IFNONNULL:
        pop(1);
        break;
      case Opcodes.POP2:
      case Opcodes.IF_ICMPEQ:
      case Opcodes.IF_ICMPNE:
      case Opcodes.IF_ICMPLT:
      case Opcodes.IF_ICMPGE:
      case Opcodes.IF_ICMPGT:
      case Opcodes.IF_ICMPLE:
      case Opcodes.IF_ACMPEQ:
      case Opcodes.IF_ACMPNE:
      case Opcodes.LRETURN:
      case Opcodes.DRETURN:
        pop(2);
        break;
      case Opcodes.DUP:
        abstractType1 = pop();
        push(abstractType1);
        push(abstractType1);
        break;
      case Opcodes.DUP_X1:
        abstractType1 = pop();
        abstractType2 = pop();
        push(abstractType1);
        push(abstractType2);
        push(abstractType1);
        break;
      case Opcodes.DUP_X2:
        abstractType1 = pop();
        abstractType2 = pop();
        abstractType3 = pop();
        push(abstractType1);
        push(abstractType3);
        push(abstractType2);
        push(abstractType1);
        break;
      case Opcodes.DUP2:
        abstractType1 = pop();
        abstractType2 = pop();
        push(abstractType2);
        push(abstractType1);
        push(abstractType2);
        push(abstractType1);
        break;
      case Opcodes.DUP2_X1:
        abstractType1 = pop();
        abstractType2 = pop();
        abstractType3 = pop();
        push(abstractType2);
        push(abstractType1);
        push(abstractType3);
        push(abstractType2);
        push(abstractType1);
        break;
      case Opcodes.DUP2_X2:
        abstractType1 = pop();
        abstractType2 = pop();
        abstractType3 = pop();
        abstractType4 = pop();
        push(abstractType2);
        push(abstractType1);
        push(abstractType4);
        push(abstractType3);
        push(abstractType2);
        push(abstractType1);
        break;
      case Opcodes.SWAP:
        abstractType1 = pop();
        abstractType2 = pop();
        push(abstractType1);
        push(abstractType2);
        break;
      case Opcodes.IALOAD:
      case Opcodes.BALOAD:
      case Opcodes.CALOAD:
      case Opcodes.SALOAD:
      case Opcodes.IADD:
      case Opcodes.ISUB:
      case Opcodes.IMUL:
      case Opcodes.IDIV:
      case Opcodes.IREM:
      case Opcodes.IAND:
      case Opcodes.IOR:
      case Opcodes.IXOR:
      case Opcodes.ISHL:
      case Opcodes.ISHR:
      case Opcodes.IUSHR:
      case Opcodes.L2I:
      case Opcodes.D2I:
      case Opcodes.FCMPL:
      case Opcodes.FCMPG:
        pop(2);
        push(INTEGER);
        break;
      case Opcodes.LADD:
      case Opcodes.LSUB:
      case Opcodes.LMUL:
      case Opcodes.LDIV:
      case Opcodes.LREM:
      case Opcodes.LAND:
      case Opcodes.LOR:
      case Opcodes.LXOR:
        pop(4);
        push(LONG);
        push(TOP);
        break;
      case Opcodes.FALOAD:
      case Opcodes.FADD:
      case Opcodes.FSUB:
      case Opcodes.FMUL:
      case Opcodes.FDIV:
      case Opcodes.FREM:
      case Opcodes.L2F:
      case Opcodes.D2F:
        pop(2);
        push(FLOAT);
        break;
      case Opcodes.DADD:
      case Opcodes.DSUB:
      case Opcodes.DMUL:
      case Opcodes.DDIV:
      case Opcodes.DREM:
        pop(4);
        push(DOUBLE);
        push(TOP);
        break;
      case Opcodes.LSHL:
      case Opcodes.LSHR:
      case Opcodes.LUSHR:
        pop(3);
        push(LONG);
        push(TOP);
        break;
      case Opcodes.IINC:
        setLocal(arg, INTEGER);
        break;
      case Opcodes.I2L:
      case Opcodes.F2L:
        pop(1);
        push(LONG);
        push(TOP);
        break;
      case Opcodes.I2F:
        pop(1);
        push(FLOAT);
        break;
      case Opcodes.I2D:
      case Opcodes.F2D:
        pop(1);
        push(DOUBLE);
        push(TOP);
        break;
      case Opcodes.F2I:
      case Opcodes.ARRAYLENGTH:
      case Opcodes.INSTANCEOF:
        pop(1);
        push(INTEGER);
        break;
      case Opcodes.LCMP:
      case Opcodes.DCMPL:
      case Opcodes.DCMPG:
        pop(4);
        push(INTEGER);
        break;
      case Opcodes.JSR:
      case Opcodes.RET:
        throw new IllegalArgumentException("JSR/RET are not supported with computeFrames option");
      case Opcodes.GETSTATIC:
        push(symbolTable, argSymbol.value);
        break;
      case Opcodes.PUTSTATIC:
        pop(argSymbol.value);
        break;
      case Opcodes.GETFIELD:
        pop(1);
        push(symbolTable, argSymbol.value);
        break;
      case Opcodes.PUTFIELD:
        pop(argSymbol.value);
        pop();
        break;
      case Opcodes.INVOKEVIRTUAL:
      case Opcodes.INVOKESPECIAL:
      case Opcodes.INVOKESTATIC:
      case Opcodes.INVOKEINTERFACE:
        pop(argSymbol.value);
        if (opcode != Opcodes.INVOKESTATIC) {
          abstractType1 = pop();
          if (opcode == Opcodes.INVOKESPECIAL && argSymbol.name.charAt(0) == '<') {
            addInitializedType(abstractType1);
          }
        }
        push(symbolTable, argSymbol.value);
        break;
      case Opcodes.INVOKEDYNAMIC:
        pop(argSymbol.value);
        push(symbolTable, argSymbol.value);
        break;
      case Opcodes.NEW:
        push(UNINITIALIZED_KIND | symbolTable.addUninitializedType(argSymbol.value, arg));
        break;
      case Opcodes.NEWARRAY:
        pop();
        switch (arg) {
          case Opcodes.T_BOOLEAN:
            push(ARRAY_OF | BOOLEAN);
            break;
          case Opcodes.T_CHAR:
            push(ARRAY_OF | CHAR);
            break;
          case Opcodes.T_BYTE:
            push(ARRAY_OF | BYTE);
            break;
          case Opcodes.T_SHORT:
            push(ARRAY_OF | SHORT);
            break;
          case Opcodes.T_INT:
            push(ARRAY_OF | INTEGER);
            break;
          case Opcodes.T_FLOAT:
            push(ARRAY_OF | FLOAT);
            break;
          case Opcodes.T_DOUBLE:
            push(ARRAY_OF | DOUBLE);
            break;
          case Opcodes.T_LONG:
            push(ARRAY_OF | LONG);
            break;
          default:
            throw new IllegalArgumentException();
        }
        break;
      case Opcodes.ANEWARRAY:
        String arrayElementType = argSymbol.value;
        pop();
        if (arrayElementType.charAt(0) == '[') {
          push(symbolTable, '[' + arrayElementType);
        } else {
          push(ARRAY_OF | REFERENCE_KIND | symbolTable.addType(arrayElementType));
        }
        break;
      case Opcodes.CHECKCAST:
        String castType = argSymbol.value;
        pop();
        if (castType.charAt(0) == '[') {
          push(symbolTable, castType);
        } else {
          push(REFERENCE_KIND | symbolTable.addType(castType));
        }
        break;
      case Opcodes.MULTIANEWARRAY:
        pop(arg);
        push(symbolTable, argSymbol.value);
        break;
      default:
        throw new IllegalArgumentException();
    }
  }

  boolean merge(SymbolTable symbolTable, Frame dstFrame, int catchTypeIndex) {
    boolean frameChanged = false;

    // Compute the concrete types of the local variables at the end of the basic block corresponding
    // to this frame, by resolving its abstract output types, and merge these concrete types with
    // those of the local variables in the input frame of dstFrame.
    int numLocal = inputLocals.length;
    int numStack = inputStack.length;
    if (dstFrame.inputLocals == null) {
      dstFrame.inputLocals = new int[numLocal];
      frameChanged = true;
    }
    for (int i = 0; i < numLocal; ++i) {
      int concreteOutputType;
      if (outputLocals != null && i < outputLocals.length) {
        int abstractOutputType = outputLocals[i];
        if (abstractOutputType == 0) {
          // If the local variable has never been assigned in this basic block, it is equal to its
          // value at the beginning of the block.
          concreteOutputType = inputLocals[i];
        } else {
          int dim = abstractOutputType & DIM_MASK;
          int kind = abstractOutputType & KIND_MASK;
          if (kind == LOCAL_KIND) {
            // By definition, a LOCAL_KIND type designates the concrete type of a local variable at
            // the beginning of the basic block corresponding to this frame (which is known when
            // this method is called, but was not when the abstract type was computed).
            concreteOutputType = dim + inputLocals[abstractOutputType & VALUE_MASK];
            if ((abstractOutputType & TOP_IF_LONG_OR_DOUBLE_FLAG) != 0
                    && (concreteOutputType == LONG || concreteOutputType == DOUBLE)) {
              concreteOutputType = TOP;
            }
          } else if (kind == STACK_KIND) {
            // By definition, a STACK_KIND type designates the concrete type of a local variable at
            // the beginning of the basic block corresponding to this frame (which is known when
            // this method is called, but was not when the abstract type was computed).
            concreteOutputType = dim + inputStack[numStack - (abstractOutputType & VALUE_MASK)];
            if ((abstractOutputType & TOP_IF_LONG_OR_DOUBLE_FLAG) != 0
                    && (concreteOutputType == LONG || concreteOutputType == DOUBLE)) {
              concreteOutputType = TOP;
            }
          } else {
            concreteOutputType = abstractOutputType;
          }
        }
      } else {
        // If the local variable has never been assigned in this basic block, it is equal to its
        // value at the beginning of the block.
        concreteOutputType = inputLocals[i];
      }
      // concreteOutputType might be an uninitialized type from the input locals or from the input
      // stack. However, if a constructor has been called for this class type in the basic block,
      // then this type is no longer uninitialized at the end of basic block.
      if (initializations != null) {
        concreteOutputType = getInitializedType(symbolTable, concreteOutputType);
      }
      frameChanged |= merge(symbolTable, concreteOutputType, dstFrame.inputLocals, i);
    }

    // If dstFrame is an exception handler block, it can be reached from any instruction of the
    // basic block corresponding to this frame, in particular from the first one. Therefore, the
    // input locals of dstFrame should be compatible (i.e. merged) with the input locals of this
    // frame (and the input stack of dstFrame should be compatible, i.e. merged, with a one
    // element stack containing the caught exception type).
    if (catchTypeIndex > 0) {
      for (int i = 0; i < numLocal; ++i) {
        frameChanged |= merge(symbolTable, inputLocals[i], dstFrame.inputLocals, i);
      }
      if (dstFrame.inputStack == null) {
        dstFrame.inputStack = new int[1];
        frameChanged = true;
      }
      frameChanged |= merge(symbolTable, catchTypeIndex, dstFrame.inputStack, 0);
      return frameChanged;
    }

    // Compute the concrete types of the stack operands at the end of the basic block corresponding
    // to this frame, by resolving its abstract output types, and merge these concrete types with
    // those of the stack operands in the input frame of dstFrame.
    int numInputStack = inputStack.length + outputStackStart;
    if (dstFrame.inputStack == null) {
      dstFrame.inputStack = new int[numInputStack + outputStackTop];
      frameChanged = true;
    }
    // First, do this for the stack operands that have not been popped in the basic block
    // corresponding to this frame, and which are therefore equal to their value in the input
    // frame (except for uninitialized types, which may have been initialized).
    for (int i = 0; i < numInputStack; ++i) {
      int concreteOutputType = inputStack[i];
      if (initializations != null) {
        concreteOutputType = getInitializedType(symbolTable, concreteOutputType);
      }
      frameChanged |= merge(symbolTable, concreteOutputType, dstFrame.inputStack, i);
    }
    // Then, do this for the stack operands that have pushed in the basic block (this code is the
    // same as the one above for local variables).
    for (int i = 0; i < outputStackTop; ++i) {
      int concreteOutputType;
      int abstractOutputType = outputStack[i];
      int dim = abstractOutputType & DIM_MASK;
      int kind = abstractOutputType & KIND_MASK;
      if (kind == LOCAL_KIND) {
        concreteOutputType = dim + inputLocals[abstractOutputType & VALUE_MASK];
        if ((abstractOutputType & TOP_IF_LONG_OR_DOUBLE_FLAG) != 0
                && (concreteOutputType == LONG || concreteOutputType == DOUBLE)) {
          concreteOutputType = TOP;
        }
      } else if (kind == STACK_KIND) {
        concreteOutputType = dim + inputStack[numStack - (abstractOutputType & VALUE_MASK)];
        if ((abstractOutputType & TOP_IF_LONG_OR_DOUBLE_FLAG) != 0
                && (concreteOutputType == LONG || concreteOutputType == DOUBLE)) {
          concreteOutputType = TOP;
        }
      } else {
        concreteOutputType = abstractOutputType;
      }
      if (initializations != null) {
        concreteOutputType = getInitializedType(symbolTable, concreteOutputType);
      }
      frameChanged |= merge(symbolTable, concreteOutputType, dstFrame.inputStack, numInputStack + i);
    }
    return frameChanged;
  }

  static boolean merge(SymbolTable symbolTable, int sourceType, int[] dstTypes, int dstIndex) {
    int dstType = dstTypes[dstIndex];
    if (dstType == sourceType) {
      // If the types are equal, merge(sourceType, dstType) = dstType, so there is no change.
      return false;
    }
    int srcType = sourceType;
    if ((sourceType & ~DIM_MASK) == NULL) {
      if (dstType == NULL) {
        return false;
      }
      srcType = NULL;
    }
    if (dstType == 0) {
      // If dstTypes[dstIndex] has never been assigned, merge(srcType, dstType) = srcType.
      dstTypes[dstIndex] = srcType;
      return true;
    }
    int mergedType;
    if ((dstType & DIM_MASK) != 0 || (dstType & KIND_MASK) == REFERENCE_KIND) {
      // If dstType is a reference type of any array dimension.
      if (srcType == NULL) {
        // If srcType is the NULL type, merge(srcType, dstType) = dstType, so there is no change.
        return false;
      } else if ((srcType & (DIM_MASK | KIND_MASK)) == (dstType & (DIM_MASK | KIND_MASK))) {
        // If srcType has the same array dimension and the same kind as dstType.
        if ((dstType & KIND_MASK) == REFERENCE_KIND) {
          // If srcType and dstType are reference types with the same array dimension,
          // merge(srcType, dstType) = dim(srcType) | common super class of srcType and dstType.
          mergedType = (srcType & DIM_MASK) | REFERENCE_KIND
                  | symbolTable.addMergedType(srcType & VALUE_MASK, dstType & VALUE_MASK);
        } else {
          // If srcType and dstType are array types of equal dimension but different element types,
          // merge(srcType, dstType) = dim(srcType) - 1 | java/lang/Object.
          int mergedDim = ELEMENT_OF + (srcType & DIM_MASK);
          mergedType = mergedDim | REFERENCE_KIND | symbolTable.addType("java/lang/Object");
        }
      } else if ((srcType & DIM_MASK) != 0 || (srcType & KIND_MASK) == REFERENCE_KIND) {
        // If srcType is any other reference or array type,
        // merge(srcType, dstType) = min(srcDdim, dstDim) | java/lang/Object
        // where srcDim is the array dimension of srcType, minus 1 if srcType is an array type
        // with a non reference element type (and similarly for dstDim).
        int srcDim = srcType & DIM_MASK;
        if (srcDim != 0 && (srcType & KIND_MASK) != REFERENCE_KIND) {
          srcDim = ELEMENT_OF + srcDim;
        }
        int dstDim = dstType & DIM_MASK;
        if (dstDim != 0 && (dstType & KIND_MASK) != REFERENCE_KIND) {
          dstDim = ELEMENT_OF + dstDim;
        }
        mergedType = Math.min(srcDim, dstDim) | REFERENCE_KIND | symbolTable.addType("java/lang/Object");
      } else {
        // If srcType is any other type, merge(srcType, dstType) = TOP.
        mergedType = TOP;
      }
    } else if (dstType == NULL) {
      // If dstType is the NULL type, merge(srcType, dstType) = srcType, or TOP if srcType is not a
      // an array type or a reference type.
      mergedType = (srcType & DIM_MASK) != 0 || (srcType & KIND_MASK) == REFERENCE_KIND ? srcType : TOP;
    } else {
      // If dstType is any other type, merge(srcType, dstType) = TOP whatever srcType.
      mergedType = TOP;
    }
    if (mergedType != dstType) {
      dstTypes[dstIndex] = mergedType;
      return true;
    }
    return false;
  }

  void accept(MethodWriter methodWriter) {
    // Compute the number of locals, ignoring TOP types that are just after a LONG or a DOUBLE, and
    // all trailing TOP types.
    int[] localTypes = inputLocals;
    int numLocal = 0;
    int numTrailingTop = 0;
    int i = 0;
    while (i < localTypes.length) {
      int localType = localTypes[i];
      i += (localType == LONG || localType == DOUBLE) ? 2 : 1;
      if (localType == TOP) {
        numTrailingTop++;
      } else {
        numLocal += numTrailingTop + 1;
        numTrailingTop = 0;
      }
    }
    // Compute the stack size, ignoring TOP types that are just after a LONG or a DOUBLE.
    int[] stackTypes = inputStack;
    int numStack = 0;
    i = 0;
    while (i < stackTypes.length) {
      int stackType = stackTypes[i];
      i += (stackType == LONG || stackType == DOUBLE) ? 2 : 1;
      numStack++;
    }
    // Visit the frame and its content.
    int frameIndex = methodWriter.visitFrameStart(owner.bytecodeOffset, numLocal, numStack);
    i = 0;
    while (numLocal-- > 0) {
      int localType = localTypes[i];
      i += (localType == LONG || localType == DOUBLE) ? 2 : 1;
      methodWriter.visitAbstractType(frameIndex++, localType);
    }
    i = 0;
    while (numStack-- > 0) {
      int stackType = stackTypes[i];
      i += (stackType == LONG || stackType == DOUBLE) ? 2 : 1;
      methodWriter.visitAbstractType(frameIndex++, stackType);
    }
    methodWriter.visitFrameEnd();
  }

  static void putAbstractType(SymbolTable symbolTable, int abstractType, ByteVector output) {
    int arrayDimensions = (abstractType & Frame.DIM_MASK) >> DIM_SHIFT;
    if (arrayDimensions == 0) {
      int typeValue = abstractType & VALUE_MASK;
      switch (abstractType & KIND_MASK) {
        case CONSTANT_KIND:
          output.putByte(typeValue);
          break;
        case REFERENCE_KIND:
          output.putByte(ITEM_OBJECT).putShort(symbolTable.addConstantClass(symbolTable.getType(typeValue).value).index);
          break;
        case UNINITIALIZED_KIND:
          output.putByte(ITEM_UNINITIALIZED).putShort((int) symbolTable.getType(typeValue).data);
          break;
        default:
          throw new AssertionError();
      }
    } else {
      // Case of an array type, we need to build its descriptor first.
      StringBuilder typeDescriptor = new StringBuilder();
      while (arrayDimensions-- > 0) {
        typeDescriptor.append('[');
      }
      if ((abstractType & KIND_MASK) == REFERENCE_KIND) {
        typeDescriptor.append('L').append(symbolTable.getType(abstractType & VALUE_MASK).value).append(';');
      } else {
        switch (abstractType & VALUE_MASK) {
          case Frame.ITEM_ASM_BOOLEAN:
            typeDescriptor.append('Z');
            break;
          case Frame.ITEM_ASM_BYTE:
            typeDescriptor.append('B');
            break;
          case Frame.ITEM_ASM_CHAR:
            typeDescriptor.append('C');
            break;
          case Frame.ITEM_ASM_SHORT:
            typeDescriptor.append('S');
            break;
          case Frame.ITEM_INTEGER:
            typeDescriptor.append('I');
            break;
          case Frame.ITEM_FLOAT:
            typeDescriptor.append('F');
            break;
          case Frame.ITEM_LONG:
            typeDescriptor.append('J');
            break;
          case Frame.ITEM_DOUBLE:
            typeDescriptor.append('D');
            break;
          default:
            throw new AssertionError();
        }
      }
      output.putByte(ITEM_OBJECT).putShort(symbolTable.addConstantClass(typeDescriptor.toString()).index);
    }
  }
}
