package es.codegen.asm;

class Frame {

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

  static final int ITEM_ASM_BOOLEAN = 9;
  static final int ITEM_ASM_BYTE = 10;
  static final int ITEM_ASM_CHAR = 11;
  static final int ITEM_ASM_SHORT = 12;

  static final int DIM_MASK = 0xF0000000;
  static final int KIND_MASK = 0x0F000000;
  static final int FLAGS_MASK = 0x00F00000;
  static final int VALUE_MASK = 0x000FFFFF;

  static final int DIM_SHIFT = 28;

  static final int ARRAY_OF = +1 << DIM_SHIFT;

  static final int ELEMENT_OF = -1 << DIM_SHIFT;

  static final int CONSTANT_KIND = 0x01000000;
  static final int REFERENCE_KIND = 0x02000000;
  static final int UNINITIALIZED_KIND = 0x03000000;
  static final int LOCAL_KIND = 0x04000000;
  static final int STACK_KIND = 0x05000000;

  static final int TOP_IF_LONG_OR_DOUBLE_FLAG = 0x00100000 & FLAGS_MASK;

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
    if (type instanceof Integer integer) {
      return CONSTANT_KIND | integer;
    } else if (type instanceof String string) {
      var descriptor = Type.getObjectType(string).getDescriptor();
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
      case 'V' -> {
        return 0;
      }
      case 'Z', 'C', 'B', 'S', 'I' -> {
        return INTEGER;
      }
      case 'F' -> {
        return FLOAT;
      }
      case 'J' -> {
        return LONG;
      }
      case 'D' -> {
        return DOUBLE;
      }
      case 'L' -> {
        internalName = buffer.substring(offset + 1, buffer.length() - 1);
        return REFERENCE_KIND | symbolTable.addType(internalName);
      }
      case '[' -> {
        var elementDescriptorOffset = offset + 1;
        while (buffer.charAt(elementDescriptorOffset) == '[') {
          ++elementDescriptorOffset;
        }
        int typeValue;
        switch (buffer.charAt(elementDescriptorOffset)) {
          case 'Z' -> typeValue = BOOLEAN;
          case 'C' -> typeValue = CHAR;
          case 'B' -> typeValue = BYTE;
          case 'S' -> typeValue = SHORT;
          case 'I' -> typeValue = INTEGER;
          case 'F' -> typeValue = FLOAT;
          case 'J' -> typeValue = LONG;
          case 'D' -> typeValue = DOUBLE;
          case 'L' -> {
            internalName = buffer.substring(elementDescriptorOffset + 1, buffer.length() - 1);
            typeValue = REFERENCE_KIND | symbolTable.addType(internalName);
          }
          default -> throw new IllegalArgumentException();
        }
        return ((elementDescriptorOffset - offset) << DIM_SHIFT) | typeValue;
      }
      default -> throw new IllegalArgumentException();
    }
  }

  void setInputFrameFromDescriptor(SymbolTable symbolTable, int access, String descriptor, int maxLocals) {
    inputLocals = new int[maxLocals];
    inputStack = new int[0];
    var inputLocalIndex = 0;
    if ((access & Opcodes.ACC_STATIC) == 0) {
      if ((access & Constants.ACC_CONSTRUCTOR) == 0) {
        inputLocals[inputLocalIndex++] = REFERENCE_KIND | symbolTable.addType(symbolTable.getClassName());
      } else {
        inputLocals[inputLocalIndex++] = UNINITIALIZED_THIS;
      }
    }
    for (var argumentType : Type.getArgumentTypes(descriptor)) {
      var abstractType = getAbstractTypeFromDescriptor(symbolTable, argumentType.getDescriptor(), 0);
      inputLocals[inputLocalIndex++] = abstractType;
      if (abstractType == LONG || abstractType == DOUBLE) {
        inputLocals[inputLocalIndex++] = TOP;
      }
    }
    while (inputLocalIndex < maxLocals) {
      inputLocals[inputLocalIndex++] = TOP;
    }
  }

  void setInputFrameFromApiFormat(SymbolTable symbolTable, int numLocal, Object[] local, int numStack, Object[] stack) {
    var inputLocalIndex = 0;
    for (var i = 0; i < numLocal; ++i) {
      inputLocals[inputLocalIndex++] = getAbstractTypeFromApiFormat(symbolTable, local[i]);
      if (local[i] == Opcodes.LONG || local[i] == Opcodes.DOUBLE) {
        inputLocals[inputLocalIndex++] = TOP;
      }
    }
    while (inputLocalIndex < inputLocals.length) {
      inputLocals[inputLocalIndex++] = TOP;
    }
    var numStackTop = 0;
    for (var i = 0; i < numStack; ++i) {
      if (stack[i] == Opcodes.LONG || stack[i] == Opcodes.DOUBLE) {
        ++numStackTop;
      }
    }
    inputStack = new int[numStack + numStackTop];
    var inputStackIndex = 0;
    for (var i = 0; i < numStack; ++i) {
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
      // If this local has never been assigned in this basic block, it is still equal to its value in the input frame.
      return LOCAL_KIND | localIndex;
    } else {
      var abstractType = outputLocals[localIndex];
      if (abstractType == 0) {
        // If this local has never been assigned in this basic block, so it is still equal to its value in the input frame.
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
    var outputLocalsLength = outputLocals.length;
    if (localIndex >= outputLocalsLength) {
      var newOutputLocals = new int[Math.max(localIndex + 1, 2 * outputLocalsLength)];
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
    var outputStackLength = outputStack.length;
    if (outputStackTop >= outputStackLength) {
      var newOutputStack = new int[Math.max(outputStackTop + 1, 2 * outputStackLength)];
      System.arraycopy(outputStack, 0, newOutputStack, 0, outputStackLength);
      outputStack = newOutputStack;
    }
    // Pushes the abstract type on the output stack.
    outputStack[outputStackTop++] = abstractType;
    // Updates the maximum size reached by the output stack, if needed (note that this size is relative to the input stack size, which is not known yet).
    var outputStackSize = (short) (outputStackStart + outputStackTop);
    if (outputStackSize > owner.outputStackMax) {
      owner.outputStackMax = outputStackSize;
    }
  }

  void push(SymbolTable symbolTable, String descriptor) {
    var typeDescriptorOffset = descriptor.charAt(0) == '(' ? descriptor.indexOf(')') + 1 : 0;
    var abstractType = getAbstractTypeFromDescriptor(symbolTable, descriptor, typeDescriptorOffset);
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
      // If the number of elements to be popped is greater than the number of elements in the output stack, clear it, and pop the remaining elements from the input stack.
      outputStackStart -= elements - outputStackTop;
      outputStackTop = 0;
    }
  }

  void pop(String descriptor) {
    var firstDescriptorChar = descriptor.charAt(0);
    switch (firstDescriptorChar) {
      case '(' -> pop((Type.getArgumentsAndReturnSizes(descriptor) >> 2) - 1);
      case 'J', 'D' -> pop(2);
      default -> pop(1);
    }
  }

  void addInitializedType(int abstractType) {
    // Create and/or resize the initializations array if necessary.
    if (initializations == null) {
      initializations = new int[2];
    }
    var initializationsLength = initializations.length;
    if (initializationCount >= initializationsLength) {
      var newInitializations = new int[Math.max(initializationCount + 1, 2 * initializationsLength)];
      System.arraycopy(initializations, 0, newInitializations, 0, initializationsLength);
      initializations = newInitializations;
    }
    // Store the abstract type.
    initializations[initializationCount++] = abstractType;
  }

  int getInitializedType(SymbolTable symbolTable, int abstractType) {
    if (abstractType == UNINITIALIZED_THIS || (abstractType & (DIM_MASK | KIND_MASK)) == UNINITIALIZED_KIND) {
      for (var i = 0; i < initializationCount; ++i) {
        var initializedType = initializations[i];
        var dim = initializedType & DIM_MASK;
        var kind = initializedType & KIND_MASK;
        var value = initializedType & VALUE_MASK;
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
      case Opcodes.NOP, Opcodes.INEG, Opcodes.LNEG, Opcodes.FNEG, Opcodes.DNEG, Opcodes.I2B, Opcodes.I2C, Opcodes.I2S, Opcodes.GOTO, Opcodes.RETURN -> {
        // no action
      }
      case Opcodes.ACONST_NULL -> {
        push(NULL);
      }
      case Opcodes.ICONST_M1, Opcodes.ICONST_0, Opcodes.ICONST_1, Opcodes.ICONST_2, Opcodes.ICONST_3, Opcodes.ICONST_4, Opcodes.ICONST_5, Opcodes.BIPUSH, Opcodes.SIPUSH, Opcodes.ILOAD -> {
        push(INTEGER);
      }
      case Opcodes.LCONST_0, Opcodes.LCONST_1, Opcodes.LLOAD -> {
        push(LONG);
        push(TOP);
      }
      case Opcodes.FCONST_0, Opcodes.FCONST_1, Opcodes.FCONST_2, Opcodes.FLOAD -> {
        push(FLOAT);
      }
      case Opcodes.DCONST_0, Opcodes.DCONST_1, Opcodes.DLOAD -> {
        push(DOUBLE);
        push(TOP);
      }
      case Opcodes.LDC -> {
        switch (argSymbol.tag) {
          case Symbol.CONSTANT_INTEGER_TAG -> { push(INTEGER); }
          case Symbol.CONSTANT_LONG_TAG -> { push(LONG); push(TOP); }
          case Symbol.CONSTANT_FLOAT_TAG -> { push(FLOAT); }
          case Symbol.CONSTANT_DOUBLE_TAG -> { push(DOUBLE); push(TOP); }
          case Symbol.CONSTANT_CLASS_TAG -> { push(REFERENCE_KIND | symbolTable.addType("java/lang/Class")); }
          case Symbol.CONSTANT_STRING_TAG -> { push(REFERENCE_KIND | symbolTable.addType("java/lang/String")); }
          case Symbol.CONSTANT_METHOD_TYPE_TAG -> { push(REFERENCE_KIND | symbolTable.addType("java/lang/invoke/MethodType")); }
          case Symbol.CONSTANT_METHOD_HANDLE_TAG -> { push(REFERENCE_KIND | symbolTable.addType("java/lang/invoke/MethodHandle")); }
          case Symbol.CONSTANT_DYNAMIC_TAG -> { push(symbolTable, argSymbol.value); }
          default -> throw new AssertionError();
        }
      }
      case Opcodes.ALOAD -> {
        push(getLocal(arg));
      }
      case Opcodes.LALOAD, Opcodes.D2L -> {
        pop(2);
        push(LONG);
        push(TOP);
      }
      case Opcodes.DALOAD, Opcodes.L2D -> {
        pop(2);
        push(DOUBLE);
        push(TOP);
      }
      case Opcodes.AALOAD -> {
        pop(1);
        abstractType1 = pop();
        push(abstractType1 == NULL ? abstractType1 : ELEMENT_OF + abstractType1);
      }
      case Opcodes.ISTORE, Opcodes.FSTORE, Opcodes.ASTORE -> {
        abstractType1 = pop();
        setLocal(arg, abstractType1);
        if (arg > 0) {
          var previousLocalType = getLocal(arg - 1);
          if (previousLocalType == LONG || previousLocalType == DOUBLE) {
            setLocal(arg - 1, TOP);
          } else if ((previousLocalType & KIND_MASK) == LOCAL_KIND || (previousLocalType & KIND_MASK) == STACK_KIND) {
            // The type of the previous local variable is not known yet, but if it later appears to be LONG or DOUBLE, we should then use TOP instead.
            setLocal(arg - 1, previousLocalType | TOP_IF_LONG_OR_DOUBLE_FLAG);
          }
        }
      }
      case Opcodes.LSTORE, Opcodes.DSTORE -> {
        pop(1);
        abstractType1 = pop();
        setLocal(arg, abstractType1);
        setLocal(arg + 1, TOP);
        if (arg > 0) {
          var previousLocalType = getLocal(arg - 1);
          if (previousLocalType == LONG || previousLocalType == DOUBLE) {
            setLocal(arg - 1, TOP);
          } else if ((previousLocalType & KIND_MASK) == LOCAL_KIND || (previousLocalType & KIND_MASK) == STACK_KIND) {
            // The type of the previous local variable is not known yet, but if it later appears to be LONG or DOUBLE, we should then use TOP instead.
            setLocal(arg - 1, previousLocalType | TOP_IF_LONG_OR_DOUBLE_FLAG);
          }
        }
      }
      case Opcodes.IASTORE, Opcodes.BASTORE, Opcodes.CASTORE, Opcodes.SASTORE, Opcodes.FASTORE, Opcodes.AASTORE -> {
        pop(3);
      }
      case Opcodes.LASTORE, Opcodes.DASTORE -> {
        pop(4);
      }
      case Opcodes.POP, Opcodes.IFEQ, Opcodes.IFNE, Opcodes.IFLT, Opcodes.IFGE, Opcodes.IFGT, Opcodes.IFLE, Opcodes.IRETURN, Opcodes.FRETURN, Opcodes.ARETURN, Opcodes.TABLESWITCH, Opcodes.LOOKUPSWITCH, Opcodes.ATHROW, Opcodes.MONITORENTER, Opcodes.MONITOREXIT, Opcodes.IFNULL, Opcodes.IFNONNULL -> {
        pop(1);
      }
      case Opcodes.POP2, Opcodes.IF_ICMPEQ, Opcodes.IF_ICMPNE, Opcodes.IF_ICMPLT, Opcodes.IF_ICMPGE, Opcodes.IF_ICMPGT, Opcodes.IF_ICMPLE, Opcodes.IF_ACMPEQ, Opcodes.IF_ACMPNE, Opcodes.LRETURN, Opcodes.DRETURN -> {
        pop(2);
      }
      case Opcodes.DUP -> {
        abstractType1 = pop();
        push(abstractType1);
        push(abstractType1);
      }
      case Opcodes.DUP_X1 -> {
        abstractType1 = pop();
        abstractType2 = pop();
        push(abstractType1);
        push(abstractType2);
        push(abstractType1);
      }
      case Opcodes.DUP_X2 -> {
        abstractType1 = pop();
        abstractType2 = pop();
        abstractType3 = pop();
        push(abstractType1);
        push(abstractType3);
        push(abstractType2);
        push(abstractType1);
      }
      case Opcodes.DUP2 -> {
        abstractType1 = pop();
        abstractType2 = pop();
        push(abstractType2);
        push(abstractType1);
        push(abstractType2);
        push(abstractType1);
      }
      case Opcodes.DUP2_X1 -> {
        abstractType1 = pop();
        abstractType2 = pop();
        abstractType3 = pop();
        push(abstractType2);
        push(abstractType1);
        push(abstractType3);
        push(abstractType2);
        push(abstractType1);
      }
      case Opcodes.DUP2_X2 -> {
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
      }
      case Opcodes.SWAP -> {
        abstractType1 = pop();
        abstractType2 = pop();
        push(abstractType1);
        push(abstractType2);
      }
      case Opcodes.IALOAD, Opcodes.BALOAD, Opcodes.CALOAD, Opcodes.SALOAD, Opcodes.IADD, Opcodes.ISUB, Opcodes.IMUL, Opcodes.IDIV, Opcodes.IREM, Opcodes.IAND, Opcodes.IOR, Opcodes.IXOR, Opcodes.ISHL, Opcodes.ISHR, Opcodes.IUSHR, Opcodes.L2I, Opcodes.D2I, Opcodes.FCMPL, Opcodes.FCMPG -> {
        pop(2);
        push(INTEGER);
      }
      case Opcodes.LADD, Opcodes.LSUB, Opcodes.LMUL, Opcodes.LDIV, Opcodes.LREM, Opcodes.LAND, Opcodes.LOR, Opcodes.LXOR -> {
        pop(4);
        push(LONG);
        push(TOP);
      }
      case Opcodes.FALOAD, Opcodes.FADD, Opcodes.FSUB, Opcodes.FMUL, Opcodes.FDIV, Opcodes.FREM, Opcodes.L2F, Opcodes.D2F -> {
        pop(2);
        push(FLOAT);
      }
      case Opcodes.DADD, Opcodes.DSUB, Opcodes.DMUL, Opcodes.DDIV, Opcodes.DREM -> {
        pop(4);
        push(DOUBLE);
        push(TOP);
      }
      case Opcodes.LSHL, Opcodes.LSHR, Opcodes.LUSHR -> {
        pop(3);
        push(LONG);
        push(TOP);
      }
      case Opcodes.IINC -> {
        setLocal(arg, INTEGER);
      }
      case Opcodes.I2L, Opcodes.F2L -> {
        pop(1);
        push(LONG);
        push(TOP);
      }
      case Opcodes.I2F -> {
        pop(1);
        push(FLOAT);
      }
      case Opcodes.I2D, Opcodes.F2D -> {
        pop(1);
        push(DOUBLE);
        push(TOP);
      }
      case Opcodes.F2I, Opcodes.ARRAYLENGTH, Opcodes.INSTANCEOF -> {
        pop(1);
        push(INTEGER);
      }
      case Opcodes.LCMP, Opcodes.DCMPL, Opcodes.DCMPG -> {
        pop(4);
        push(INTEGER);
      }
      case Opcodes.JSR, Opcodes.RET -> {
        throw new IllegalArgumentException("JSR/RET are not supported with computeFrames option");
      }
      case Opcodes.GETSTATIC -> {
        push(symbolTable, argSymbol.value);
      }
      case Opcodes.PUTSTATIC -> {
        pop(argSymbol.value);
      }
      case Opcodes.GETFIELD -> {
        pop(1);
        push(symbolTable, argSymbol.value);
      }
      case Opcodes.PUTFIELD -> {
        pop(argSymbol.value);
        pop();
      }
      case Opcodes.INVOKEVIRTUAL, Opcodes.INVOKESPECIAL, Opcodes.INVOKESTATIC, Opcodes.INVOKEINTERFACE -> {
        pop(argSymbol.value);
        if (opcode != Opcodes.INVOKESTATIC) {
          abstractType1 = pop();
          if (opcode == Opcodes.INVOKESPECIAL && argSymbol.name.charAt(0) == '<') {
            addInitializedType(abstractType1);
          }
        }
        push(symbolTable, argSymbol.value);
      }
      case Opcodes.INVOKEDYNAMIC -> {
        pop(argSymbol.value);
        push(symbolTable, argSymbol.value);
      }
      case Opcodes.NEW -> {
        push(UNINITIALIZED_KIND | symbolTable.addUninitializedType(argSymbol.value, arg));
      }
      case Opcodes.NEWARRAY -> {
        pop();
        switch (arg) {
          case Opcodes.T_BOOLEAN -> push(ARRAY_OF | BOOLEAN);
          case Opcodes.T_CHAR -> push(ARRAY_OF | CHAR);
          case Opcodes.T_BYTE -> push(ARRAY_OF | BYTE);
          case Opcodes.T_SHORT -> push(ARRAY_OF | SHORT);
          case Opcodes.T_INT -> push(ARRAY_OF | INTEGER);
          case Opcodes.T_FLOAT -> push(ARRAY_OF | FLOAT);
          case Opcodes.T_DOUBLE -> push(ARRAY_OF | DOUBLE);
          case Opcodes.T_LONG -> push(ARRAY_OF | LONG);
          default -> throw new IllegalArgumentException();
        }
      }
      case Opcodes.ANEWARRAY -> {
        var arrayElementType = argSymbol.value;
        pop();
        if (arrayElementType.charAt(0) == '[') {
          push(symbolTable, '[' + arrayElementType);
        } else {
          push(ARRAY_OF | REFERENCE_KIND | symbolTable.addType(arrayElementType));
        }
      }
      case Opcodes.CHECKCAST -> {
        var castType = argSymbol.value;
        pop();
        if (castType.charAt(0) == '[') {
          push(symbolTable, castType);
        } else {
          push(REFERENCE_KIND | symbolTable.addType(castType));
        }
      }
      case Opcodes.MULTIANEWARRAY -> {
        pop(arg);
        push(symbolTable, argSymbol.value);
      }
      default -> throw new IllegalArgumentException();
    }
  }

  boolean merge(SymbolTable symbolTable, Frame dstFrame, int catchTypeIndex) {
    boolean frameChanged = false;
    // Compute the concrete types of the local variables at the end of the basic block corresponding to this frame, by resolving its abstract output types, and merge these concrete types with those of the local variables in the input frame of dstFrame.
    var numLocal = inputLocals.length;
    var numStack = inputStack.length;
    if (dstFrame.inputLocals == null) {
      dstFrame.inputLocals = new int[numLocal];
      frameChanged = true;
    }
    for (var i = 0; i < numLocal; ++i) {
      int concreteOutputType;
      if (outputLocals != null && i < outputLocals.length) {
        var abstractOutputType = outputLocals[i];
        if (abstractOutputType == 0) {
          // If the local variable has never been assigned in this basic block, it is equal to its value at the beginning of the block.
          concreteOutputType = inputLocals[i];
        } else {
          var dim = abstractOutputType & DIM_MASK;
          var kind = abstractOutputType & KIND_MASK;
          switch (kind) {
            case LOCAL_KIND -> {
              // By definition, a LOCAL_KIND type designates the concrete type of a local variable at the beginning of the basic block corresponding to this frame (which is known when this method is called, but was not when the abstract type was computed).
              concreteOutputType = dim + inputLocals[abstractOutputType & VALUE_MASK];
              if ((abstractOutputType & TOP_IF_LONG_OR_DOUBLE_FLAG) != 0 && (concreteOutputType == LONG || concreteOutputType == DOUBLE)) {
                concreteOutputType = TOP;
              }
            }
            case STACK_KIND -> {
              // By definition, a STACK_KIND type designates the concrete type of a local variable at the beginning of the basic block corresponding to this frame (which is known when this method is called, but was not when the abstract type was computed).
              concreteOutputType = dim + inputStack[numStack - (abstractOutputType & VALUE_MASK)];
              if ((abstractOutputType & TOP_IF_LONG_OR_DOUBLE_FLAG) != 0 && (concreteOutputType == LONG || concreteOutputType == DOUBLE)) {
                concreteOutputType = TOP;
              }
            }
            default -> concreteOutputType = abstractOutputType;
          }
        }
      } else {
        // If the local variable has never been assigned in this basic block, it is equal to its value at the beginning of the block.
        concreteOutputType = inputLocals[i];
      }
      // concreteOutputType might be an uninitialized type from the input locals or from the input stack. However, if a constructor has been called for this class type in the basic block, then this type is no longer uninitialized at the end of basic block.
      if (initializations != null) {
        concreteOutputType = getInitializedType(symbolTable, concreteOutputType);
      }
      frameChanged |= merge(symbolTable, concreteOutputType, dstFrame.inputLocals, i);
    }
    // If dstFrame is an exception handler block, it can be reached from any instruction of the basic block corresponding to this frame, in particular from the first one. Therefore, the input locals of dstFrame should be compatible (i.e. merged) with the input locals of this frame (and the input stack of dstFrame should be compatible, i.e. merged, with a one element stack containing the caught exception type).
    if (catchTypeIndex > 0) {
      for (var i = 0; i < numLocal; ++i) {
        frameChanged |= merge(symbolTable, inputLocals[i], dstFrame.inputLocals, i);
      }
      if (dstFrame.inputStack == null) {
        dstFrame.inputStack = new int[1];
        frameChanged = true;
      }
      frameChanged |= merge(symbolTable, catchTypeIndex, dstFrame.inputStack, 0);
      return frameChanged;
    }
    // Compute the concrete types of the stack operands at the end of the basic block corresponding to this frame, by resolving its abstract output types, and merge these concrete types with those of the stack operands in the input frame of dstFrame.
    var numInputStack = inputStack.length + outputStackStart;
    if (dstFrame.inputStack == null) {
      dstFrame.inputStack = new int[numInputStack + outputStackTop];
      frameChanged = true;
    }
    // First, do this for the stack operands that have not been popped in the basic block corresponding to this frame, and which are therefore equal to their value in the input frame (except for uninitialized types, which may have been initialized).
    for (var i = 0; i < numInputStack; ++i) {
      var concreteOutputType = inputStack[i];
      if (initializations != null) {
        concreteOutputType = getInitializedType(symbolTable, concreteOutputType);
      }
      frameChanged |= merge(symbolTable, concreteOutputType, dstFrame.inputStack, i);
    }
    // Then, do this for the stack operands that have pushed in the basic block (this code is the same as the one above for local variables).
    for (var i = 0; i < outputStackTop; ++i) {
      int concreteOutputType;
      var abstractOutputType = outputStack[i];
      var dim = abstractOutputType & DIM_MASK;
      var kind = abstractOutputType & KIND_MASK;
      switch (kind) {
        case LOCAL_KIND -> {
          concreteOutputType = dim + inputLocals[abstractOutputType & VALUE_MASK];
          if ((abstractOutputType & TOP_IF_LONG_OR_DOUBLE_FLAG) != 0 && (concreteOutputType == LONG || concreteOutputType == DOUBLE)) {
            concreteOutputType = TOP;
          }
        }
        case STACK_KIND -> {
          concreteOutputType = dim + inputStack[numStack - (abstractOutputType & VALUE_MASK)];
          if ((abstractOutputType & TOP_IF_LONG_OR_DOUBLE_FLAG) != 0 && (concreteOutputType == LONG || concreteOutputType == DOUBLE)) {
            concreteOutputType = TOP;
          }
        }
        default -> concreteOutputType = abstractOutputType;
      }
      if (initializations != null) {
        concreteOutputType = getInitializedType(symbolTable, concreteOutputType);
      }
      frameChanged |= merge(symbolTable, concreteOutputType, dstFrame.inputStack, numInputStack + i);
    }
    return frameChanged;
  }

  static boolean merge(SymbolTable symbolTable, int sourceType, int[] dstTypes, int dstIndex) {
    var dstType = dstTypes[dstIndex];
    if (dstType == sourceType) {
      // If the types are equal, merge(sourceType, dstType) = dstType, so there is no change.
      return false;
    }
    var srcType = sourceType;
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
          // If srcType and dstType are reference types with the same array dimension, merge(srcType, dstType) = dim(srcType) | common super class of srcType and dstType.
          mergedType = (srcType & DIM_MASK) | REFERENCE_KIND | symbolTable.addMergedType(srcType & VALUE_MASK, dstType & VALUE_MASK);
        } else {
          // If srcType and dstType are array types of equal dimension but different element types, merge(srcType, dstType) = dim(srcType) - 1 | java/lang/Object.
          var mergedDim = ELEMENT_OF + (srcType & DIM_MASK);
          mergedType = mergedDim | REFERENCE_KIND | symbolTable.addType("java/lang/Object");
        }
      } else if ((srcType & DIM_MASK) != 0 || (srcType & KIND_MASK) == REFERENCE_KIND) {
        // If srcType is any other reference or array type, merge(srcType, dstType) = min(srcDdim, dstDim) | java/lang/Object where srcDim is the array dimension of srcType, minus 1 if srcType is an array type with a non reference element type (and similarly for dstDim).
        var srcDim = srcType & DIM_MASK;
        if (srcDim != 0 && (srcType & KIND_MASK) != REFERENCE_KIND) {
          srcDim = ELEMENT_OF + srcDim;
        }
        var dstDim = dstType & DIM_MASK;
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
    // Compute the number of locals, ignoring TOP types that are just after a LONG or a DOUBLE, and all trailing TOP types.
    var localTypes = inputLocals;
    var numLocal = 0;
    var numTrailingTop = 0;
    var i = 0;
    while (i < localTypes.length) {
      var localType = localTypes[i];
      i += (localType == LONG || localType == DOUBLE) ? 2 : 1;
      if (localType == TOP) {
        numTrailingTop++;
      } else {
        numLocal += numTrailingTop + 1;
        numTrailingTop = 0;
      }
    }
    // Compute the stack size, ignoring TOP types that are just after a LONG or a DOUBLE.
    var stackTypes = inputStack;
    var numStack = 0;
    i = 0;
    while (i < stackTypes.length) {
      var stackType = stackTypes[i];
      i += (stackType == LONG || stackType == DOUBLE) ? 2 : 1;
      numStack++;
    }
    // Visit the frame and its content.
    var frameIndex = methodWriter.visitFrameStart(owner.bytecodeOffset, numLocal, numStack);
    i = 0;
    while (numLocal-- > 0) {
      var localType = localTypes[i];
      i += (localType == LONG || localType == DOUBLE) ? 2 : 1;
      methodWriter.visitAbstractType(frameIndex++, localType);
    }
    i = 0;
    while (numStack-- > 0) {
      var stackType = stackTypes[i];
      i += (stackType == LONG || stackType == DOUBLE) ? 2 : 1;
      methodWriter.visitAbstractType(frameIndex++, stackType);
    }
    methodWriter.visitFrameEnd();
  }

  static void putAbstractType(SymbolTable symbolTable, int abstractType, ByteVector output) {
    var arrayDimensions = (abstractType & Frame.DIM_MASK) >> DIM_SHIFT;
    if (arrayDimensions == 0) {
      var typeValue = abstractType & VALUE_MASK;
      switch (abstractType & KIND_MASK) {
        case CONSTANT_KIND -> output.putByte(typeValue);
        case REFERENCE_KIND -> output.putByte(ITEM_OBJECT).putShort(symbolTable.addConstantClass(symbolTable.getType(typeValue).value).index);
        case UNINITIALIZED_KIND -> output.putByte(ITEM_UNINITIALIZED).putShort((int) symbolTable.getType(typeValue).data);
        default -> throw new AssertionError();
      }
    } else {
      // Case of an array type, we need to build its descriptor first.
      var typeDescriptor = new StringBuilder();
      while (arrayDimensions-- > 0) {
        typeDescriptor.append('[');
      }
      if ((abstractType & KIND_MASK) == REFERENCE_KIND) {
        typeDescriptor.append('L').append(symbolTable.getType(abstractType & VALUE_MASK).value).append(';');
      } else {
        switch (abstractType & VALUE_MASK) {
          case Frame.ITEM_ASM_BOOLEAN -> typeDescriptor.append('Z');
          case Frame.ITEM_ASM_BYTE -> typeDescriptor.append('B');
          case Frame.ITEM_ASM_CHAR -> typeDescriptor.append('C');
          case Frame.ITEM_ASM_SHORT -> typeDescriptor.append('S');
          case Frame.ITEM_INTEGER -> typeDescriptor.append('I');
          case Frame.ITEM_FLOAT -> typeDescriptor.append('F');
          case Frame.ITEM_LONG -> typeDescriptor.append('J');
          case Frame.ITEM_DOUBLE -> typeDescriptor.append('D');
          default -> throw new AssertionError();
        }
      }
      output.putByte(ITEM_OBJECT).putShort(symbolTable.addConstantClass(typeDescriptor.toString()).index);
    }
  }
}
