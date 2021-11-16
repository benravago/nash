package es.codegen.asm;

public class ClassReader {

  final byte[] b;
  final int[] cpInfoOffsets;
  final String[] constantUtf8Values;
  final ConstantDynamic[] constantDynamicValues;
  final int[] bootstrapMethodOffsets;
  final int maxStringLength;
  final int header;

  public ClassReader(byte[] classFileBuffer) {
    b = classFileBuffer;
    int constantPoolCount = readUnsignedShort(8);
    cpInfoOffsets = new int[constantPoolCount];
    constantUtf8Values = new String[constantPoolCount];
    int currentCpInfoIndex = 1;
    int currentCpInfoOffset = 10;
    int currentMaxStringLength = 0;
    boolean hasConstantDynamic = false;
    boolean hasConstantInvokeDynamic = false;
    while (currentCpInfoIndex < constantPoolCount) {
      cpInfoOffsets[currentCpInfoIndex++] = currentCpInfoOffset + 1;
      int cpInfoSize;
      switch (classFileBuffer[currentCpInfoOffset]) {
        case Symbol.CONSTANT_FIELDREF_TAG, Symbol.CONSTANT_METHODREF_TAG, Symbol.CONSTANT_INTERFACE_METHODREF_TAG, Symbol.CONSTANT_INTEGER_TAG, Symbol.CONSTANT_FLOAT_TAG, Symbol.CONSTANT_NAME_AND_TYPE_TAG -> {
          cpInfoSize = 5;
        }
        case Symbol.CONSTANT_DYNAMIC_TAG -> {
          cpInfoSize = 5;
          hasConstantDynamic = true;
        }
        case Symbol.CONSTANT_INVOKE_DYNAMIC_TAG -> {
          cpInfoSize = 5;
          hasConstantInvokeDynamic = true;
        }
        case Symbol.CONSTANT_LONG_TAG, Symbol.CONSTANT_DOUBLE_TAG -> {
          cpInfoSize = 9;
          currentCpInfoIndex++;
        }
        case Symbol.CONSTANT_UTF8_TAG -> {
          cpInfoSize = 3 + readUnsignedShort(currentCpInfoOffset + 1);
          if (cpInfoSize > currentMaxStringLength) {
            // The size in bytes of this CONSTANT_Utf8 structure provides a conservative estimate of the length in characters of the corresponding string, and is much cheaper to compute than this exact length.
            currentMaxStringLength = cpInfoSize;
          }
        }
        case Symbol.CONSTANT_METHOD_HANDLE_TAG -> {
          cpInfoSize = 4;
        }
        case Symbol.CONSTANT_CLASS_TAG, Symbol.CONSTANT_STRING_TAG, Symbol.CONSTANT_METHOD_TYPE_TAG, Symbol.CONSTANT_PACKAGE_TAG, Symbol.CONSTANT_MODULE_TAG -> {
          cpInfoSize = 3;
        }
        default -> throw new IllegalArgumentException();
      }
      currentCpInfoOffset += cpInfoSize;
    }
    maxStringLength = currentMaxStringLength;
    header = currentCpInfoOffset;
    constantDynamicValues = hasConstantDynamic ? new ConstantDynamic[constantPoolCount] : null;
    bootstrapMethodOffsets = (hasConstantDynamic | hasConstantInvokeDynamic) ? readBootstrapMethodsAttribute(currentMaxStringLength) : null;
  }

  int getAccess() {
    return readUnsignedShort(header);
  }

  String getClassName() {
    return readClass(header + 2, new char[maxStringLength]);
  }

  String getSuperName() {
    return readClass(header + 4, new char[maxStringLength]);
  }

  String[] getInterfaces() {
    var currentOffset = header + 6;
    var interfacesCount = readUnsignedShort(currentOffset);
    var interfaces = new String[interfacesCount];
    if (interfacesCount > 0) {
      var charBuffer = new char[maxStringLength];
      for (var i = 0; i < interfacesCount; ++i) {
        currentOffset += 2;
        interfaces[i] = readClass(currentOffset, charBuffer);
      }
    }
    return interfaces;
  }

  public void accept(ClassVisitor classVisitor) {
    var context = new Context();
    context.charBuffer = new char[maxStringLength];
    var charBuffer = context.charBuffer;
    var currentOffset = header;
    var accessFlags = readUnsignedShort(currentOffset);
    var thisClass = readClass(currentOffset + 2, charBuffer);
    var superClass = readClass(currentOffset + 4, charBuffer);
    var interfaces = new String[readUnsignedShort(currentOffset + 6)];
    currentOffset += 8;
    for (var i = 0; i < interfaces.length; ++i) {
      interfaces[i] = readClass(currentOffset, charBuffer);
      currentOffset += 2;
    }
    String signature = null;
    String sourceFile = null;
    var runtimeVisibleAnnotationsOffset = 0;
    var currentAttributeOffset = getFirstAttributeOffset();
    for (var i = readUnsignedShort(currentAttributeOffset - 2); i > 0; --i) {
      var attributeName = readUTF8(currentAttributeOffset, charBuffer);
      var attributeLength = readInt(currentAttributeOffset + 2);
      currentAttributeOffset += 6;
      switch (attributeName) {
        case Constants.SOURCE_FILE -> sourceFile = readUTF8(currentAttributeOffset, charBuffer);
        case Constants.SIGNATURE -> signature = readUTF8(currentAttributeOffset, charBuffer);
        case Constants.RUNTIME_VISIBLE_ANNOTATIONS -> runtimeVisibleAnnotationsOffset = currentAttributeOffset;
        case Constants.INNER_CLASSES, Constants.ENCLOSING_METHOD, Constants.NEST_HOST, Constants.NEST_MEMBERS, Constants.BOOTSTRAP_METHODS -> {} // ignore
        default -> System.out.println("cr1 attributeName "+attributeName);
      }
      currentAttributeOffset += attributeLength;
    }
    classVisitor.visit(accessFlags, thisClass, signature, superClass, interfaces);
    if (sourceFile != null) {
      classVisitor.visitSource(sourceFile, null);
    }
    if (runtimeVisibleAnnotationsOffset != 0) {
      var numAnnotations = readUnsignedShort(runtimeVisibleAnnotationsOffset);
      var currentAnnotationOffset = runtimeVisibleAnnotationsOffset + 2;
      while (numAnnotations-- > 0) {
        var annotationDescriptor = readUTF8(currentAnnotationOffset, charBuffer);
        currentAnnotationOffset += 2;
        currentAnnotationOffset = readElementValues(classVisitor.visitAnnotation(annotationDescriptor, true), currentAnnotationOffset, true, charBuffer);
      }
    }
    var fieldsCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (fieldsCount-- > 0) {
      currentOffset = readField(classVisitor, context, currentOffset);
    }
    var methodsCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (methodsCount-- > 0) {
      currentOffset = readMethod(classVisitor, context, currentOffset);
    }
    classVisitor.visitEnd();
  }

  int readField(ClassVisitor classVisitor, Context context, int fieldInfoOffset) {
    var charBuffer = context.charBuffer;
    var currentOffset = fieldInfoOffset;
    var accessFlags = readUnsignedShort(currentOffset);
    var name = readUTF8(currentOffset + 2, charBuffer);
    var descriptor = readUTF8(currentOffset + 4, charBuffer);
    currentOffset += 6;
    Object constantValue = null;
    String signature = null;
    var runtimeVisibleAnnotationsOffset = 0;
    var attributesCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (attributesCount-- > 0) {
      var attributeName = readUTF8(currentOffset, charBuffer);
      var attributeLength = readInt(currentOffset + 2);
      currentOffset += 6;
      switch (attributeName) {
        case Constants.CONSTANT_VALUE -> {
          var constantvalueIndex = readUnsignedShort(currentOffset);
          constantValue = constantvalueIndex == 0 ? null : readConst(constantvalueIndex, charBuffer);
        }
        case Constants.SIGNATURE -> {
          signature = readUTF8(currentOffset, charBuffer);
        }
        case Constants.RUNTIME_VISIBLE_ANNOTATIONS -> {
          runtimeVisibleAnnotationsOffset = currentOffset;
        }
        default -> System.out.println("cr2 attributeName "+attributeName);
      }
      currentOffset += attributeLength;
    }
    var fieldVisitor = classVisitor.visitField(accessFlags, name, descriptor, signature, constantValue);
    if (fieldVisitor == null) {
      return currentOffset;
    }
    if (runtimeVisibleAnnotationsOffset != 0) {
      var numAnnotations = readUnsignedShort(runtimeVisibleAnnotationsOffset);
      var currentAnnotationOffset = runtimeVisibleAnnotationsOffset + 2;
      while (numAnnotations-- > 0) {
        var annotationDescriptor = readUTF8(currentAnnotationOffset, charBuffer);
        currentAnnotationOffset += 2;
        currentAnnotationOffset = readElementValues(fieldVisitor.visitAnnotation(annotationDescriptor, true), currentAnnotationOffset, true, charBuffer);
      }
    }
    fieldVisitor.visitEnd();
    return currentOffset;
  }

  int readMethod(ClassVisitor classVisitor, Context context, int methodInfoOffset) {
    var charBuffer = context.charBuffer;
    var currentOffset = methodInfoOffset;
    context.currentMethodAccessFlags = readUnsignedShort(currentOffset);
    context.currentMethodName = readUTF8(currentOffset + 2, charBuffer);
    context.currentMethodDescriptor = readUTF8(currentOffset + 4, charBuffer);
    currentOffset += 6;
    var codeOffset = 0;
    var exceptionsOffset = 0;
    String[] exceptions = null;
    var synthetic = false;
    var signatureIndex = 0;
    var runtimeVisibleAnnotationsOffset = 0;
    var attributesCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (attributesCount-- > 0) {
      var attributeName = readUTF8(currentOffset, charBuffer);
      var attributeLength = readInt(currentOffset + 2);
      currentOffset += 6;
      switch (attributeName) {
        case Constants.CODE -> {
          codeOffset = currentOffset;
        }
        case Constants.EXCEPTIONS -> {
          exceptionsOffset = currentOffset;
          exceptions = new String[readUnsignedShort(exceptionsOffset)];
          var currentExceptionOffset = exceptionsOffset + 2;
          for (var i = 0; i < exceptions.length; ++i) {
            exceptions[i] = readClass(currentExceptionOffset, charBuffer);
            currentExceptionOffset += 2;
          }
        }
        case Constants.SIGNATURE -> {
          signatureIndex = readUnsignedShort(currentOffset);
        }
        case Constants.RUNTIME_VISIBLE_ANNOTATIONS -> {
          runtimeVisibleAnnotationsOffset = currentOffset;
        }
        default -> System.out.println("cr3 attributeName "+attributeName);
      }
      currentOffset += attributeLength;
    }
    var methodVisitor = classVisitor.visitMethod(context.currentMethodAccessFlags, context.currentMethodName, context.currentMethodDescriptor, signatureIndex == 0 ? null : readUtf(signatureIndex, charBuffer), exceptions);
    if (methodVisitor == null) {
      return currentOffset;
    }
    if (methodVisitor instanceof MethodWriter methodWriter) {
      if (methodWriter.canCopyMethodAttributes(this, methodInfoOffset, currentOffset - methodInfoOffset, synthetic, false, readUnsignedShort(methodInfoOffset + 4), signatureIndex, exceptionsOffset)) {
        return currentOffset;
      }
    }
    if (runtimeVisibleAnnotationsOffset != 0) {
      var numAnnotations = readUnsignedShort(runtimeVisibleAnnotationsOffset);
      var currentAnnotationOffset = runtimeVisibleAnnotationsOffset + 2;
      while (numAnnotations-- > 0) {
        var annotationDescriptor = readUTF8(currentAnnotationOffset, charBuffer);
        currentAnnotationOffset += 2;
        currentAnnotationOffset = readElementValues(methodVisitor.visitAnnotation(annotationDescriptor, true), currentAnnotationOffset, true, charBuffer);
      }
    }
    if (codeOffset != 0) {
      methodVisitor.visitCode();
      readCode(methodVisitor, context, codeOffset);
    }
    methodVisitor.visitEnd();
    return currentOffset;
  }

  void readCode(MethodVisitor methodVisitor, Context context, int codeOffset) {
    var currentOffset = codeOffset;
    var classFileBuffer = b;
    var charBuffer = context.charBuffer;
    var maxStack = readUnsignedShort(currentOffset);
    var maxLocals = readUnsignedShort(currentOffset + 2);
    var codeLength = readInt(currentOffset + 4);
    currentOffset += 8;
    var bytecodeStartOffset = currentOffset;
    var bytecodeEndOffset = currentOffset + codeLength;
    var labels = context.currentMethodLabels = new Label[codeLength + 1];
    while (currentOffset < bytecodeEndOffset) {
      var bytecodeOffset = currentOffset - bytecodeStartOffset;
      var opcode = classFileBuffer[currentOffset] & 0xFF;
      switch (opcode) {
        case Constants.NOP, Constants.ACONST_NULL, Constants.ICONST_M1, Constants.ICONST_0, Constants.ICONST_1, Constants.ICONST_2, Constants.ICONST_3, Constants.ICONST_4, Constants.ICONST_5, Constants.LCONST_0, Constants.LCONST_1, Constants.FCONST_0, Constants.FCONST_1, Constants.FCONST_2, Constants.DCONST_0, Constants.DCONST_1, Constants.IALOAD, Constants.LALOAD, Constants.FALOAD, Constants.DALOAD, Constants.AALOAD, Constants.BALOAD, Constants.CALOAD, Constants.SALOAD, Constants.IASTORE, Constants.LASTORE, Constants.FASTORE, Constants.DASTORE, Constants.AASTORE, Constants.BASTORE, Constants.CASTORE, Constants.SASTORE, Constants.POP, Constants.POP2, Constants.DUP, Constants.DUP_X1, Constants.DUP_X2, Constants.DUP2, Constants.DUP2_X1, Constants.DUP2_X2, Constants.SWAP, Constants.IADD, Constants.LADD, Constants.FADD, Constants.DADD, Constants.ISUB, Constants.LSUB, Constants.FSUB, Constants.DSUB, Constants.IMUL, Constants.LMUL, Constants.FMUL, Constants.DMUL, Constants.IDIV, Constants.LDIV, Constants.FDIV, Constants.DDIV, Constants.IREM, Constants.LREM, Constants.FREM, Constants.DREM, Constants.INEG, Constants.LNEG, Constants.FNEG, Constants.DNEG, Constants.ISHL, Constants.LSHL, Constants.ISHR, Constants.LSHR, Constants.IUSHR, Constants.LUSHR, Constants.IAND, Constants.LAND, Constants.IOR, Constants.LOR, Constants.IXOR, Constants.LXOR, Constants.I2L, Constants.I2F, Constants.I2D, Constants.L2I, Constants.L2F, Constants.L2D, Constants.F2I, Constants.F2L, Constants.F2D, Constants.D2I, Constants.D2L, Constants.D2F, Constants.I2B, Constants.I2C, Constants.I2S, Constants.LCMP, Constants.FCMPL, Constants.FCMPG, Constants.DCMPL, Constants.DCMPG, Constants.IRETURN, Constants.LRETURN, Constants.FRETURN, Constants.DRETURN, Constants.ARETURN, Constants.RETURN, Constants.ARRAYLENGTH, Constants.ATHROW, Constants.MONITORENTER, Constants.MONITOREXIT, Constants.ILOAD_0, Constants.ILOAD_1, Constants.ILOAD_2, Constants.ILOAD_3, Constants.LLOAD_0, Constants.LLOAD_1, Constants.LLOAD_2, Constants.LLOAD_3, Constants.FLOAD_0, Constants.FLOAD_1, Constants.FLOAD_2, Constants.FLOAD_3, Constants.DLOAD_0, Constants.DLOAD_1, Constants.DLOAD_2, Constants.DLOAD_3, Constants.ALOAD_0, Constants.ALOAD_1, Constants.ALOAD_2, Constants.ALOAD_3, Constants.ISTORE_0, Constants.ISTORE_1, Constants.ISTORE_2, Constants.ISTORE_3, Constants.LSTORE_0, Constants.LSTORE_1, Constants.LSTORE_2, Constants.LSTORE_3, Constants.FSTORE_0, Constants.FSTORE_1, Constants.FSTORE_2, Constants.FSTORE_3, Constants.DSTORE_0, Constants.DSTORE_1, Constants.DSTORE_2, Constants.DSTORE_3, Constants.ASTORE_0, Constants.ASTORE_1, Constants.ASTORE_2, Constants.ASTORE_3 -> {
          currentOffset += 1;
        }
        case Constants.IFEQ, Constants.IFNE, Constants.IFLT, Constants.IFGE, Constants.IFGT, Constants.IFLE, Constants.IF_ICMPEQ, Constants.IF_ICMPNE, Constants.IF_ICMPLT, Constants.IF_ICMPGE, Constants.IF_ICMPGT, Constants.IF_ICMPLE, Constants.IF_ACMPEQ, Constants.IF_ACMPNE, Constants.GOTO, Constants.JSR, Constants.IFNULL, Constants.IFNONNULL -> {
          createLabel(bytecodeOffset + readShort(currentOffset + 1), labels);
          currentOffset += 3;
        }
        case Constants.GOTO_W, Constants.JSR_W -> { // Constants.ASM_GOTO_W
          createLabel(bytecodeOffset + readInt(currentOffset + 1), labels);
          currentOffset += 5;
        }
        case Constants.WIDE -> {
          switch (classFileBuffer[currentOffset + 1] & 0xFF) {
            case Constants.ILOAD, Constants.FLOAD, Constants.ALOAD, Constants.LLOAD, Constants.DLOAD, Constants.ISTORE, Constants.FSTORE, Constants.ASTORE, Constants.LSTORE, Constants.DSTORE, Constants.RET -> {
              currentOffset += 4;
            }
            case Constants.IINC -> {
              currentOffset += 6;
            }
            default -> throw new IllegalArgumentException();
          }
        }
        case Constants.TABLESWITCH -> {
          // Skip 0 to 3 padding bytes.
          currentOffset += 4 - (bytecodeOffset & 3);
          // Read the default label and the number of table entries.
          createLabel(bytecodeOffset + readInt(currentOffset), labels);
          var numTableEntries = readInt(currentOffset + 8) - readInt(currentOffset + 4) + 1;
          currentOffset += 12;
          // Read the table labels.
          while (numTableEntries-- > 0) {
            createLabel(bytecodeOffset + readInt(currentOffset), labels);
            currentOffset += 4;
          }
        }
        case Constants.LOOKUPSWITCH -> {
          // Skip 0 to 3 padding bytes.
          currentOffset += 4 - (bytecodeOffset & 3);
          // Read the default label and the number of switch cases.
          createLabel(bytecodeOffset + readInt(currentOffset), labels);
          var numSwitchCases = readInt(currentOffset + 4);
          currentOffset += 8;
          // Read the switch labels.
          while (numSwitchCases-- > 0) {
            createLabel(bytecodeOffset + readInt(currentOffset + 4), labels);
            currentOffset += 8;
          }
        }
        case Constants.ILOAD, Constants.LLOAD, Constants.FLOAD, Constants.DLOAD, Constants.ALOAD, Constants.ISTORE, Constants.LSTORE, Constants.FSTORE, Constants.DSTORE, Constants.ASTORE, Constants.RET, Constants.BIPUSH, Constants.NEWARRAY, Constants.LDC -> {
          currentOffset += 2;
        }
        case Constants.SIPUSH, Constants.LDC_W, Constants.LDC2_W, Constants.GETSTATIC, Constants.PUTSTATIC, Constants.GETFIELD, Constants.PUTFIELD, Constants.INVOKEVIRTUAL, Constants.INVOKESPECIAL, Constants.INVOKESTATIC, Constants.NEW, Constants.ANEWARRAY, Constants.CHECKCAST, Constants.INSTANCEOF, Constants.IINC -> {
          currentOffset += 3;
        }
        case Constants.INVOKEINTERFACE, Constants.INVOKEDYNAMIC -> {
          currentOffset += 5;
        }
        case Constants.MULTIANEWARRAY -> {
          currentOffset += 4;
        }
        default -> throw new IllegalArgumentException();
      }
    }
    var exceptionTableLength = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (exceptionTableLength-- > 0) {
      var start = createLabel(readUnsignedShort(currentOffset), labels);
      var end = createLabel(readUnsignedShort(currentOffset + 2), labels);
      var handler = createLabel(readUnsignedShort(currentOffset + 4), labels);
      var catchType = readUTF8(cpInfoOffsets[readUnsignedShort(currentOffset + 6)], charBuffer);
      currentOffset += 8;
      methodVisitor.visitTryCatchBlock(start, end, handler, catchType);
    }
    var stackMapFrameOffset = 0;
    var stackMapTableEndOffset = 0;
    var compressedFrames = true;
    var localVariableTableOffset = 0;
    var localVariableTypeTableOffset = 0;
    var attributesCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (attributesCount-- > 0) {
      var attributeName = readUTF8(currentOffset, charBuffer);
      var attributeLength = readInt(currentOffset + 2);
      currentOffset += 6;
      switch (attributeName) {
        case Constants.LOCAL_VARIABLE_TABLE -> {
          localVariableTableOffset = currentOffset;
          var currentLocalVariableTableOffset = currentOffset;
          var localVariableTableLength = readUnsignedShort(currentLocalVariableTableOffset);
          currentLocalVariableTableOffset += 2;
          while (localVariableTableLength-- > 0) {
            var startPc = readUnsignedShort(currentLocalVariableTableOffset);
            createDebugLabel(startPc, labels);
            var length = readUnsignedShort(currentLocalVariableTableOffset + 2);
            createDebugLabel(startPc + length, labels);
            currentLocalVariableTableOffset += 10;
          }
        }
        case Constants.LOCAL_VARIABLE_TYPE_TABLE -> {
          localVariableTypeTableOffset = currentOffset;
        }
        case Constants.LINE_NUMBER_TABLE -> {
          var currentLineNumberTableOffset = currentOffset;
          var lineNumberTableLength = readUnsignedShort(currentLineNumberTableOffset);
          currentLineNumberTableOffset += 2;
          while (lineNumberTableLength-- > 0) {
            var startPc = readUnsignedShort(currentLineNumberTableOffset);
            var lineNumber = readUnsignedShort(currentLineNumberTableOffset + 2);
            currentLineNumberTableOffset += 4;
            createDebugLabel(startPc, labels);
            labels[startPc].addLineNumber(lineNumber);
          }
        }
        case Constants.STACK_MAP_TABLE -> {
          stackMapFrameOffset = currentOffset + 2;
          stackMapTableEndOffset = currentOffset + attributeLength;
        }
        case Constants.STACK_MAP -> {
          stackMapFrameOffset = currentOffset + 2;
          stackMapTableEndOffset = currentOffset + attributeLength;
          compressedFrames = false;
        }
        default -> System.out.println("cr4 attributeName "+attributeName);
      }
      currentOffset += attributeLength;
    }
    if (stackMapFrameOffset != 0) {
      context.currentFrameOffset = -1;
      context.currentFrameType = 0;
      context.currentFrameLocalCount = 0;
      context.currentFrameLocalCountDelta = 0;
      context.currentFrameLocalTypes = new Object[maxLocals];
      context.currentFrameStackCount = 0;
      context.currentFrameStackTypes = new Object[maxStack];
      for (var offset = stackMapFrameOffset; offset < stackMapTableEndOffset - 2; ++offset) {
        if (classFileBuffer[offset] == Frame.ITEM_UNINITIALIZED) {
          var potentialBytecodeOffset = readUnsignedShort(offset + 1);
          if (potentialBytecodeOffset >= 0 && potentialBytecodeOffset < codeLength && (classFileBuffer[bytecodeStartOffset + potentialBytecodeOffset] & 0xFF) == Opcodes.NEW) {
            createLabel(potentialBytecodeOffset, labels);
          }
        }
      }
    }
    // Visit the bytecode instructions.
    boolean insertFrame = false;
    int wideJumpOpcodeDelta = Constants.WIDE_JUMP_OPCODE_DELTA;
    currentOffset = bytecodeStartOffset;
    while (currentOffset < bytecodeEndOffset) {
      var currentBytecodeOffset = currentOffset - bytecodeStartOffset;
      var currentLabel = labels[currentBytecodeOffset];
      if (currentLabel != null) {
        currentLabel.accept(methodVisitor, true);
      }
      while (stackMapFrameOffset != 0 && (context.currentFrameOffset == currentBytecodeOffset || context.currentFrameOffset == -1)) {
        if (context.currentFrameOffset != -1) {
          if (!compressedFrames || false) {
            methodVisitor.visitFrame(Opcodes.F_NEW, context.currentFrameLocalCount, context.currentFrameLocalTypes, context.currentFrameStackCount, context.currentFrameStackTypes);
          } else {
            methodVisitor.visitFrame(context.currentFrameType, context.currentFrameLocalCountDelta, context.currentFrameLocalTypes, context.currentFrameStackCount, context.currentFrameStackTypes);
          }
          insertFrame = false;
        }
        if (stackMapFrameOffset < stackMapTableEndOffset) {
          stackMapFrameOffset = readStackMapFrame(stackMapFrameOffset, compressedFrames, false, context);
        } else {
          stackMapFrameOffset = 0;
        }
      }
      if (insertFrame) {
        insertFrame = false;
      }
      var opcode = classFileBuffer[currentOffset] & 0xFF;
      switch (opcode) {
        case Constants.NOP, Constants.ACONST_NULL, Constants.ICONST_M1, Constants.ICONST_0, Constants.ICONST_1, Constants.ICONST_2, Constants.ICONST_3, Constants.ICONST_4, Constants.ICONST_5, Constants.LCONST_0, Constants.LCONST_1, Constants.FCONST_0, Constants.FCONST_1, Constants.FCONST_2, Constants.DCONST_0, Constants.DCONST_1, Constants.IALOAD, Constants.LALOAD, Constants.FALOAD, Constants.DALOAD, Constants.AALOAD, Constants.BALOAD, Constants.CALOAD, Constants.SALOAD, Constants.IASTORE, Constants.LASTORE, Constants.FASTORE, Constants.DASTORE, Constants.AASTORE, Constants.BASTORE, Constants.CASTORE, Constants.SASTORE, Constants.POP, Constants.POP2, Constants.DUP, Constants.DUP_X1, Constants.DUP_X2, Constants.DUP2, Constants.DUP2_X1, Constants.DUP2_X2, Constants.SWAP, Constants.IADD, Constants.LADD, Constants.FADD, Constants.DADD, Constants.ISUB, Constants.LSUB, Constants.FSUB, Constants.DSUB, Constants.IMUL, Constants.LMUL, Constants.FMUL, Constants.DMUL, Constants.IDIV, Constants.LDIV, Constants.FDIV, Constants.DDIV, Constants.IREM, Constants.LREM, Constants.FREM, Constants.DREM, Constants.INEG, Constants.LNEG, Constants.FNEG, Constants.DNEG, Constants.ISHL, Constants.LSHL, Constants.ISHR, Constants.LSHR, Constants.IUSHR, Constants.LUSHR, Constants.IAND, Constants.LAND, Constants.IOR, Constants.LOR, Constants.IXOR, Constants.LXOR, Constants.I2L, Constants.I2F, Constants.I2D, Constants.L2I, Constants.L2F, Constants.L2D, Constants.F2I, Constants.F2L, Constants.F2D, Constants.D2I, Constants.D2L, Constants.D2F, Constants.I2B, Constants.I2C, Constants.I2S, Constants.LCMP, Constants.FCMPL, Constants.FCMPG, Constants.DCMPL, Constants.DCMPG, Constants.IRETURN, Constants.LRETURN, Constants.FRETURN, Constants.DRETURN, Constants.ARETURN, Constants.RETURN, Constants.ARRAYLENGTH, Constants.ATHROW, Constants.MONITORENTER, Constants.MONITOREXIT -> {
          methodVisitor.visitInsn(opcode);
          currentOffset += 1;
        }
        case Constants.ILOAD_0, Constants.ILOAD_1, Constants.ILOAD_2, Constants.ILOAD_3, Constants.LLOAD_0, Constants.LLOAD_1, Constants.LLOAD_2, Constants.LLOAD_3, Constants.FLOAD_0, Constants.FLOAD_1, Constants.FLOAD_2, Constants.FLOAD_3, Constants.DLOAD_0, Constants.DLOAD_1, Constants.DLOAD_2, Constants.DLOAD_3, Constants.ALOAD_0, Constants.ALOAD_1, Constants.ALOAD_2, Constants.ALOAD_3 -> {
          opcode -= Constants.ILOAD_0;
          methodVisitor.visitVarInsn(Opcodes.ILOAD + (opcode >> 2), opcode & 0x3);
          currentOffset += 1;
        }
        case Constants.ISTORE_0, Constants.ISTORE_1, Constants.ISTORE_2, Constants.ISTORE_3, Constants.LSTORE_0, Constants.LSTORE_1, Constants.LSTORE_2, Constants.LSTORE_3, Constants.FSTORE_0, Constants.FSTORE_1, Constants.FSTORE_2, Constants.FSTORE_3, Constants.DSTORE_0, Constants.DSTORE_1, Constants.DSTORE_2, Constants.DSTORE_3, Constants.ASTORE_0, Constants.ASTORE_1, Constants.ASTORE_2, Constants.ASTORE_3 -> {
          opcode -= Constants.ISTORE_0;
          methodVisitor.visitVarInsn(Opcodes.ISTORE + (opcode >> 2), opcode & 0x3);
          currentOffset += 1;
        }
        case Constants.IFEQ, Constants.IFNE, Constants.IFLT, Constants.IFGE, Constants.IFGT, Constants.IFLE, Constants.IF_ICMPEQ, Constants.IF_ICMPNE, Constants.IF_ICMPLT, Constants.IF_ICMPGE, Constants.IF_ICMPGT, Constants.IF_ICMPLE, Constants.IF_ACMPEQ, Constants.IF_ACMPNE, Constants.GOTO, Constants.JSR, Constants.IFNULL, Constants.IFNONNULL -> {
          methodVisitor.visitJumpInsn(opcode, labels[currentBytecodeOffset + readShort(currentOffset + 1)]);
          currentOffset += 3;
        }
        case Constants.GOTO_W, Constants.JSR_W -> {
          methodVisitor.visitJumpInsn(opcode - wideJumpOpcodeDelta, labels[currentBytecodeOffset + readInt(currentOffset + 1)]);
          currentOffset += 5;
        }
        case Constants.WIDE -> {
          opcode = classFileBuffer[currentOffset + 1] & 0xFF;
          if (opcode == Opcodes.IINC) {
            methodVisitor.visitIincInsn(readUnsignedShort(currentOffset + 2), readShort(currentOffset + 4));
            currentOffset += 6;
          } else {
            methodVisitor.visitVarInsn(opcode, readUnsignedShort(currentOffset + 2));
            currentOffset += 4;
          }
        }
        case Constants.TABLESWITCH -> {
          // Skip 0 to 3 padding bytes.
          currentOffset += 4 - (currentBytecodeOffset & 3);
          // Read the instruction.
          var defaultLabel = labels[currentBytecodeOffset + readInt(currentOffset)];
          var low = readInt(currentOffset + 4);
          var high = readInt(currentOffset + 8);
          currentOffset += 12;
          var table = new Label[high - low + 1];
          for (var i = 0; i < table.length; ++i) {
            table[i] = labels[currentBytecodeOffset + readInt(currentOffset)];
            currentOffset += 4;
          }
          methodVisitor.visitTableSwitchInsn(low, high, defaultLabel, table);
        }
        case Constants.LOOKUPSWITCH -> {
          // Skip 0 to 3 padding bytes.
          currentOffset += 4 - (currentBytecodeOffset & 3);
          // Read the instruction.
          var defaultLabel = labels[currentBytecodeOffset + readInt(currentOffset)];
          var numPairs = readInt(currentOffset + 4);
          currentOffset += 8;
          var keys = new int[numPairs];
          var values = new Label[numPairs];
          for (var i = 0; i < numPairs; ++i) {
            keys[i] = readInt(currentOffset);
            values[i] = labels[currentBytecodeOffset + readInt(currentOffset + 4)];
            currentOffset += 8;
          }
          methodVisitor.visitLookupSwitchInsn(defaultLabel, keys, values);
        }
        case Constants.ILOAD, Constants.LLOAD, Constants.FLOAD, Constants.DLOAD, Constants.ALOAD, Constants.ISTORE, Constants.LSTORE, Constants.FSTORE, Constants.DSTORE, Constants.ASTORE, Constants.RET -> {
          methodVisitor.visitVarInsn(opcode, classFileBuffer[currentOffset + 1] & 0xFF);
          currentOffset += 2;
        }
        case Constants.BIPUSH, Constants.NEWARRAY -> {
          methodVisitor.visitIntInsn(opcode, classFileBuffer[currentOffset + 1]);
          currentOffset += 2;
        }
        case Constants.SIPUSH -> {
          methodVisitor.visitIntInsn(opcode, readShort(currentOffset + 1));
          currentOffset += 3;
        }
        case Constants.LDC -> {
          methodVisitor.visitLdcInsn(readConst(classFileBuffer[currentOffset + 1] & 0xFF, charBuffer));
          currentOffset += 2;
        }
        case Constants.LDC_W, Constants.LDC2_W -> {
          methodVisitor.visitLdcInsn(readConst(readUnsignedShort(currentOffset + 1), charBuffer));
          currentOffset += 3;
        }
        case Constants.GETSTATIC, Constants.PUTSTATIC, Constants.GETFIELD, Constants.PUTFIELD, Constants.INVOKEVIRTUAL, Constants.INVOKESPECIAL, Constants.INVOKESTATIC, Constants.INVOKEINTERFACE -> {
          var cpInfoOffset = cpInfoOffsets[readUnsignedShort(currentOffset + 1)];
          var nameAndTypeCpInfoOffset = cpInfoOffsets[readUnsignedShort(cpInfoOffset + 2)];
          var owner = readClass(cpInfoOffset, charBuffer);
          var name = readUTF8(nameAndTypeCpInfoOffset, charBuffer);
          var descriptor = readUTF8(nameAndTypeCpInfoOffset + 2, charBuffer);
          if (opcode < Opcodes.INVOKEVIRTUAL) {
            methodVisitor.visitFieldInsn(opcode, owner, name, descriptor);
          } else {
            boolean isInterface = classFileBuffer[cpInfoOffset - 1] == Symbol.CONSTANT_INTERFACE_METHODREF_TAG;
            methodVisitor.visitMethodInsn(opcode, owner, name, descriptor, isInterface);
          }
          if (opcode == Opcodes.INVOKEINTERFACE) {
            currentOffset += 5;
          } else {
            currentOffset += 3;
          }
        }
        case Constants.INVOKEDYNAMIC -> {
          var cpInfoOffset = cpInfoOffsets[readUnsignedShort(currentOffset + 1)];
          var nameAndTypeCpInfoOffset = cpInfoOffsets[readUnsignedShort(cpInfoOffset + 2)];
          var name = readUTF8(nameAndTypeCpInfoOffset, charBuffer);
          var descriptor = readUTF8(nameAndTypeCpInfoOffset + 2, charBuffer);
          var bootstrapMethodOffset = bootstrapMethodOffsets[readUnsignedShort(cpInfoOffset)];
          var handle = (Handle) readConst(readUnsignedShort(bootstrapMethodOffset), charBuffer);
          var bootstrapMethodArguments = new Object[readUnsignedShort(bootstrapMethodOffset + 2)];
          bootstrapMethodOffset += 4;
          for (var i = 0; i < bootstrapMethodArguments.length; i++) {
            bootstrapMethodArguments[i] = readConst(readUnsignedShort(bootstrapMethodOffset), charBuffer);
            bootstrapMethodOffset += 2;
          }
          methodVisitor.visitInvokeDynamicInsn(name, descriptor, handle, bootstrapMethodArguments);
          currentOffset += 5;
        }
        case Constants.NEW, Constants.ANEWARRAY, Constants.CHECKCAST, Constants.INSTANCEOF -> {
          methodVisitor.visitTypeInsn(opcode, readClass(currentOffset + 1, charBuffer));
          currentOffset += 3;
        }
        case Constants.IINC -> {
          methodVisitor.visitIincInsn(classFileBuffer[currentOffset + 1] & 0xFF, classFileBuffer[currentOffset + 2]);
          currentOffset += 3;
        }
        case Constants.MULTIANEWARRAY -> {
          methodVisitor.visitMultiANewArrayInsn(readClass(currentOffset + 1, charBuffer), classFileBuffer[currentOffset + 3] & 0xFF);
          currentOffset += 4;
        }
        default -> throw new AssertionError();
      }
    }
    if (labels[codeLength] != null) {
      methodVisitor.visitLabel(labels[codeLength]);
    }
    if (localVariableTableOffset != 0) {
      int[] typeTable = null;
      if (localVariableTypeTableOffset != 0) {
        typeTable = new int[readUnsignedShort(localVariableTypeTableOffset) * 3];
        currentOffset = localVariableTypeTableOffset + 2;
        var typeTableIndex = typeTable.length;
        while (typeTableIndex > 0) {
          typeTable[--typeTableIndex] = currentOffset + 6;
          typeTable[--typeTableIndex] = readUnsignedShort(currentOffset + 8);
          typeTable[--typeTableIndex] = readUnsignedShort(currentOffset);
          currentOffset += 10;
        }
      }
      var localVariableTableLength = readUnsignedShort(localVariableTableOffset);
      currentOffset = localVariableTableOffset + 2;
      while (localVariableTableLength-- > 0) {
        var startPc = readUnsignedShort(currentOffset);
        var length = readUnsignedShort(currentOffset + 2);
        var name = readUTF8(currentOffset + 4, charBuffer);
        var descriptor = readUTF8(currentOffset + 6, charBuffer);
        var index = readUnsignedShort(currentOffset + 8);
        currentOffset += 10;
        String signature = null;
        if (typeTable != null) {
          for (var i = 0; i < typeTable.length; i += 3) {
            if (typeTable[i] == startPc && typeTable[i + 1] == index) {
              signature = readUTF8(typeTable[i + 2], charBuffer);
              break;
            }
          }
        }
        methodVisitor.visitLocalVariable(name, descriptor, signature, labels[startPc], labels[startPc + length], index);
      }
    }
    methodVisitor.visitMaxs(maxStack, maxLocals);
  }

  Label readLabel(int bytecodeOffset, Label[] labels) {
    if (labels[bytecodeOffset] == null) {
      labels[bytecodeOffset] = new Label();
    }
    return labels[bytecodeOffset];
  }

  Label createLabel(int bytecodeOffset, Label[] labels) {
    var label = readLabel(bytecodeOffset, labels);
    label.flags &= ~Label.FLAG_DEBUG_ONLY;
    return label;
  }

  void createDebugLabel(int bytecodeOffset, Label[] labels) {
    if (labels[bytecodeOffset] == null) {
      readLabel(bytecodeOffset, labels).flags |= Label.FLAG_DEBUG_ONLY;
    }
  }

  int readElementValues(AnnotationVisitor annotationVisitor, int annotationOffset, boolean named, char[] charBuffer) {
    var currentOffset = annotationOffset;
    var numElementValuePairs = readUnsignedShort(currentOffset);
    currentOffset += 2;
    if (named) {
      while (numElementValuePairs-- > 0) {
        var elementName = readUTF8(currentOffset, charBuffer);
        currentOffset = readElementValue(annotationVisitor, currentOffset + 2, elementName, charBuffer);
      }
    } else {
      while (numElementValuePairs-- > 0) {
        currentOffset = readElementValue(annotationVisitor, currentOffset, null, charBuffer);
      }
    }
    if (annotationVisitor != null) {
      annotationVisitor.visitEnd();
    }
    return currentOffset;
  }

  int readElementValue(AnnotationVisitor annotationVisitor, int elementValueOffset, String elementName, char[] charBuffer) {
    var currentOffset = elementValueOffset;
    if (annotationVisitor == null) {
      return switch (b[currentOffset] & 0xFF) {
        case 'e' -> currentOffset + 5;
        case '@' -> readElementValues(null, currentOffset + 3, true, charBuffer);
        case '[' -> readElementValues(null, currentOffset + 1, false, charBuffer);
        default -> currentOffset + 3;
      };
    }
    switch (b[currentOffset++] & 0xFF) {
      case 'B' -> {
        annotationVisitor.visit(elementName, (byte) readInt(cpInfoOffsets[readUnsignedShort(currentOffset)]));
        currentOffset += 2;
      }
      case 'C' -> {
        annotationVisitor.visit(elementName, (char) readInt(cpInfoOffsets[readUnsignedShort(currentOffset)]));
        currentOffset += 2;
      }
      case 'D', 'F', 'I', 'J' -> {
        annotationVisitor.visit(elementName, readConst(readUnsignedShort(currentOffset), charBuffer));
        currentOffset += 2;
      }
      case 'S' -> {
        annotationVisitor.visit(elementName, (short) readInt(cpInfoOffsets[readUnsignedShort(currentOffset)]));
        currentOffset += 2;
      }
      case 'Z' -> {
        annotationVisitor.visit(elementName, readInt(cpInfoOffsets[readUnsignedShort(currentOffset)]) == 0 ? Boolean.FALSE : Boolean.TRUE);
        currentOffset += 2;
      }
      case 's' -> {
        annotationVisitor.visit(elementName, readUTF8(currentOffset, charBuffer));
        currentOffset += 2;
      }
      case 'e' -> {
        annotationVisitor.visitEnum(elementName, readUTF8(currentOffset, charBuffer), readUTF8(currentOffset + 2, charBuffer));
        currentOffset += 4;
      }
      case 'c' -> {
        annotationVisitor.visit(elementName, Type.getType(readUTF8(currentOffset, charBuffer)));
        currentOffset += 2;
      }
      case '@' -> {
        currentOffset = readElementValues(null, currentOffset + 2, true, charBuffer);
      }
      case '[' -> {
        int numValues = readUnsignedShort(currentOffset);
        currentOffset += 2;
        if (numValues == 0) {
          return readElementValues(null, currentOffset - 2, false, charBuffer);
        }
        switch (b[currentOffset] & 0xFF) {
          case 'B' -> {
            var byteValues = new byte[numValues];
            for (var i = 0; i < numValues; i++) {
              byteValues[i] = (byte) readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]);
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, byteValues);
          }
          case 'Z' -> {
            var booleanValues = new boolean[numValues];
            for (var i = 0; i < numValues; i++) {
              booleanValues[i] = readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]) != 0;
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, booleanValues);
          }
          case 'S' -> {
            var shortValues = new short[numValues];
            for (var i = 0; i < numValues; i++) {
              shortValues[i] = (short) readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]);
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, shortValues);
          }
          case 'C' -> {
            var charValues = new char[numValues];
            for (var i = 0; i < numValues; i++) {
              charValues[i] = (char) readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]);
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, charValues);
          }
          case 'I' -> {
            var intValues = new int[numValues];
            for (var i = 0; i < numValues; i++) {
              intValues[i] = readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]);
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, intValues);
          }
          case 'J' -> {
            var longValues = new long[numValues];
            for (var i = 0; i < numValues; i++) {
              longValues[i] = readLong(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]);
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, longValues);
          }
          case 'F' -> {
            var floatValues = new float[numValues];
            for (var i = 0; i < numValues; i++) {
              floatValues[i] = Float.intBitsToFloat(readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]));
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, floatValues);
          }
          case 'D' -> {
            var doubleValues = new double[numValues];
            for (var i = 0; i < numValues; i++) {
              doubleValues[i] = Double.longBitsToDouble(readLong(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]));
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, doubleValues);
          }
          default -> currentOffset = readElementValues(null, currentOffset - 2, false, charBuffer);
        }
      }
      default -> throw new IllegalArgumentException();
    }
    return currentOffset;
  }

  void computeImplicitFrame(Context context) {
    var methodDescriptor = context.currentMethodDescriptor;
    var locals = context.currentFrameLocalTypes;
    var numLocal = 0;
    if ((context.currentMethodAccessFlags & Opcodes.ACC_STATIC) == 0) {
      if ("<init>".equals(context.currentMethodName)) {
        locals[numLocal++] = Opcodes.UNINITIALIZED_THIS;
      } else {
        locals[numLocal++] = readClass(header + 2, context.charBuffer);
      }
    }
    var currentMethodDescritorOffset = 1;
    for (;;) {
      var currentArgumentDescriptorStartOffset = currentMethodDescritorOffset;
      switch (methodDescriptor.charAt(currentMethodDescritorOffset++)) {
        case 'Z', 'C', 'B', 'S', 'I' -> {
          locals[numLocal++] = Opcodes.INTEGER;
        }
        case 'F' -> {
          locals[numLocal++] = Opcodes.FLOAT;
        }
        case 'J' -> {
          locals[numLocal++] = Opcodes.LONG;
        }
        case 'D' -> {
          locals[numLocal++] = Opcodes.DOUBLE;
        }
        case '[' -> {
          while (methodDescriptor.charAt(currentMethodDescritorOffset) == '[') {
            ++currentMethodDescritorOffset;
          }
          if (methodDescriptor.charAt(currentMethodDescritorOffset) == 'L') {
            ++currentMethodDescritorOffset;
            while (methodDescriptor.charAt(currentMethodDescritorOffset) != ';') {
              ++currentMethodDescritorOffset;
            }
          }
          locals[numLocal++] = methodDescriptor.substring(currentArgumentDescriptorStartOffset, ++currentMethodDescritorOffset);
        }
        case 'L' -> {
          while (methodDescriptor.charAt(currentMethodDescritorOffset) != ';') {
            ++currentMethodDescritorOffset;
          }
          locals[numLocal++] = methodDescriptor.substring(currentArgumentDescriptorStartOffset + 1, currentMethodDescritorOffset++);
        }
        default -> {
          context.currentFrameLocalCount = numLocal;
          return;
        }
      }
    }
  }

  int readStackMapFrame(int stackMapFrameOffset, boolean compressed, boolean expand, Context context) {
    var currentOffset = stackMapFrameOffset;
    var charBuffer = context.charBuffer;
    var labels = context.currentMethodLabels;
    int frameType;
    if (compressed) {
      frameType = b[currentOffset++] & 0xFF;
    } else {
      frameType = Frame.FULL_FRAME;
      context.currentFrameOffset = -1;
    }
    int offsetDelta;
    context.currentFrameLocalCountDelta = 0;
    if (frameType < Frame.SAME_LOCALS_1_STACK_ITEM_FRAME) {
      offsetDelta = frameType;
      context.currentFrameType = Opcodes.F_SAME;
      context.currentFrameStackCount = 0;
    } else if (frameType < Frame.RESERVED) {
      offsetDelta = frameType - Frame.SAME_LOCALS_1_STACK_ITEM_FRAME;
      currentOffset = readVerificationTypeInfo(currentOffset, context.currentFrameStackTypes, 0, charBuffer, labels);
      context.currentFrameType = Opcodes.F_SAME1;
      context.currentFrameStackCount = 1;
    } else if (frameType >= Frame.SAME_LOCALS_1_STACK_ITEM_FRAME_EXTENDED) {
      offsetDelta = readUnsignedShort(currentOffset);
      currentOffset += 2;
      if (frameType == Frame.SAME_LOCALS_1_STACK_ITEM_FRAME_EXTENDED) {
        currentOffset = readVerificationTypeInfo(currentOffset, context.currentFrameStackTypes, 0, charBuffer, labels);
        context.currentFrameType = Opcodes.F_SAME1;
        context.currentFrameStackCount = 1;
      } else if (frameType >= Frame.CHOP_FRAME && frameType < Frame.SAME_FRAME_EXTENDED) {
        context.currentFrameType = Opcodes.F_CHOP;
        context.currentFrameLocalCountDelta = Frame.SAME_FRAME_EXTENDED - frameType;
        context.currentFrameLocalCount -= context.currentFrameLocalCountDelta;
        context.currentFrameStackCount = 0;
      } else if (frameType == Frame.SAME_FRAME_EXTENDED) {
        context.currentFrameType = Opcodes.F_SAME;
        context.currentFrameStackCount = 0;
      } else if (frameType < Frame.FULL_FRAME) {
        var local = expand ? context.currentFrameLocalCount : 0;
        for (var k = frameType - Frame.SAME_FRAME_EXTENDED; k > 0; k--) {
          currentOffset = readVerificationTypeInfo(currentOffset, context.currentFrameLocalTypes, local++, charBuffer,
                  labels);
        }
        context.currentFrameType = Opcodes.F_APPEND;
        context.currentFrameLocalCountDelta = frameType - Frame.SAME_FRAME_EXTENDED;
        context.currentFrameLocalCount += context.currentFrameLocalCountDelta;
        context.currentFrameStackCount = 0;
      } else {
        var numberOfLocals = readUnsignedShort(currentOffset);
        currentOffset += 2;
        context.currentFrameType = Opcodes.F_FULL;
        context.currentFrameLocalCountDelta = numberOfLocals;
        context.currentFrameLocalCount = numberOfLocals;
        for (var local = 0; local < numberOfLocals; ++local) {
          currentOffset = readVerificationTypeInfo(currentOffset, context.currentFrameLocalTypes, local, charBuffer, labels);
        }
        var numberOfStackItems = readUnsignedShort(currentOffset);
        currentOffset += 2;
        context.currentFrameStackCount = numberOfStackItems;
        for (var stack = 0; stack < numberOfStackItems; ++stack) {
          currentOffset = readVerificationTypeInfo(currentOffset, context.currentFrameStackTypes, stack, charBuffer, labels);
        }
      }
    } else {
      throw new IllegalArgumentException();
    }
    context.currentFrameOffset += offsetDelta + 1;
    createLabel(context.currentFrameOffset, labels);
    return currentOffset;
  }

  int readVerificationTypeInfo(int verificationTypeInfoOffset, Object[] frame, int index, char[] charBuffer, Label[] labels) {
    var currentOffset = verificationTypeInfoOffset;
    var tag = b[currentOffset++] & 0xFF;
    switch (tag) {
      case Frame.ITEM_TOP -> {
        frame[index] = Opcodes.TOP;
      }
      case Frame.ITEM_INTEGER -> {
        frame[index] = Opcodes.INTEGER;
      }
      case Frame.ITEM_FLOAT -> {
        frame[index] = Opcodes.FLOAT;
      }
      case Frame.ITEM_DOUBLE -> {
        frame[index] = Opcodes.DOUBLE;
      }
      case Frame.ITEM_LONG -> {
        frame[index] = Opcodes.LONG;
      }
      case Frame.ITEM_NULL -> {
        frame[index] = Opcodes.NULL;
      }
      case Frame.ITEM_UNINITIALIZED_THIS -> {
        frame[index] = Opcodes.UNINITIALIZED_THIS;
      }
      case Frame.ITEM_OBJECT -> {
        frame[index] = readClass(currentOffset, charBuffer);
        currentOffset += 2;
      }
      case Frame.ITEM_UNINITIALIZED -> {
        frame[index] = createLabel(readUnsignedShort(currentOffset), labels);
        currentOffset += 2;
      }
      default -> throw new IllegalArgumentException();
    }
    return currentOffset;
  }

  int getFirstAttributeOffset() {
    var currentOffset = header + 8 + readUnsignedShort(header + 6) * 2;
    var fieldsCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (fieldsCount-- > 0) {
      var attributesCount = readUnsignedShort(currentOffset + 6);
      currentOffset += 8;
      while (attributesCount-- > 0) {
        currentOffset += 6 + readInt(currentOffset + 2);
      }
    }
    var methodsCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (methodsCount-- > 0) {
      var attributesCount = readUnsignedShort(currentOffset + 6);
      currentOffset += 8;
      while (attributesCount-- > 0) {
        currentOffset += 6 + readInt(currentOffset + 2);
      }
    }
    return currentOffset + 2;
  }

  final int[] readBootstrapMethodsAttribute(int maxStringLength) {
    var charBuffer = new char[maxStringLength];
    var currentAttributeOffset = getFirstAttributeOffset();
    for (var i = readUnsignedShort(currentAttributeOffset - 2); i > 0; --i) {
      var attributeName = readUTF8(currentAttributeOffset, charBuffer);
      var attributeLength = readInt(currentAttributeOffset + 2);
      currentAttributeOffset += 6;
      if (Constants.BOOTSTRAP_METHODS.equals(attributeName)) {
        var currentBootstrapMethodOffsets = new int[readUnsignedShort(currentAttributeOffset)];
        var currentBootstrapMethodOffset = currentAttributeOffset + 2;
        for (var j = 0; j < currentBootstrapMethodOffsets.length; ++j) {
          currentBootstrapMethodOffsets[j] = currentBootstrapMethodOffset;
          currentBootstrapMethodOffset += 4 + readUnsignedShort(currentBootstrapMethodOffset + 2) * 2;
        }
        return currentBootstrapMethodOffsets;
      }
      currentAttributeOffset += attributeLength;
    }
    return null;
  }

  int getItemCount() {
    return cpInfoOffsets.length;
  }

  int getItem(int constantPoolEntryIndex) {
    return cpInfoOffsets[constantPoolEntryIndex];
  }

  int getMaxStringLength() {
    return maxStringLength;
  }

  int readByte(int offset) {
    return b[offset] & 0xFF;
  }

  final int readUnsignedShort(int offset) {
    var classFileBuffer = b;
    return ((classFileBuffer[offset] & 0xFF) << 8) | (classFileBuffer[offset + 1] & 0xFF);
  }

  short readShort(int offset) {
    var classFileBuffer = b;
    return (short) (((classFileBuffer[offset] & 0xFF) << 8) | (classFileBuffer[offset + 1] & 0xFF));
  }

  int readInt(int offset) {
    var classFileBuffer = b;
    return ((classFileBuffer[offset] & 0xFF) << 24) | ((classFileBuffer[offset + 1] & 0xFF) << 16) | ((classFileBuffer[offset + 2] & 0xFF) << 8) | (classFileBuffer[offset + 3] & 0xFF);
  }

  long readLong(int offset) {
    long l1 = readInt(offset);
    long l0 = readInt(offset + 4) & 0xFFFFFFFFL;
    return (l1 << 32) | l0;
  }

  String readUTF8(int offset, char[] charBuffer) {
    var constantPoolEntryIndex = readUnsignedShort(offset);
    if (offset == 0 || constantPoolEntryIndex == 0) {
      return null;
    }
    return readUtf(constantPoolEntryIndex, charBuffer);
  }

  String readUtf(int constantPoolEntryIndex, char[] charBuffer) {
    var value = constantUtf8Values[constantPoolEntryIndex];
    if (value != null) {
      return value;
    }
    var cpInfoOffset = cpInfoOffsets[constantPoolEntryIndex];
    return constantUtf8Values[constantPoolEntryIndex] = readUtf(cpInfoOffset + 2, readUnsignedShort(cpInfoOffset), charBuffer);
  }

  String readUtf(int utfOffset, int utfLength, char[] charBuffer) {
    var currentOffset = utfOffset;
    var endOffset = currentOffset + utfLength;
    var strLength = 0;
    var classFileBuffer = b;
    while (currentOffset < endOffset) {
      var currentByte = classFileBuffer[currentOffset++];
      if ((currentByte & 0x80) == 0) {
        charBuffer[strLength++] = (char) (currentByte & 0x7F);
      } else if ((currentByte & 0xE0) == 0xC0) {
        charBuffer[strLength++] = (char) (((currentByte & 0x1F) << 6) + (classFileBuffer[currentOffset++] & 0x3F));
      } else {
        charBuffer[strLength++] = (char) (((currentByte & 0xF) << 12) + ((classFileBuffer[currentOffset++] & 0x3F) << 6) + (classFileBuffer[currentOffset++] & 0x3F));
      }
    }
    return new String(charBuffer, 0, strLength);
  }

  String readStringish(int offset, char[] charBuffer) {
    return readUTF8(cpInfoOffsets[readUnsignedShort(offset)], charBuffer);
  }

  String readClass(int offset, char[] charBuffer) {
    return readStringish(offset, charBuffer);
  }

  Object readConst(int constantPoolEntryIndex, char[] charBuffer) {
    var cpInfoOffset = cpInfoOffsets[constantPoolEntryIndex];
    switch (b[cpInfoOffset - 1]) {
      case Symbol.CONSTANT_INTEGER_TAG -> {
        return readInt(cpInfoOffset);
      }
      case Symbol.CONSTANT_FLOAT_TAG -> {
        return Float.intBitsToFloat(readInt(cpInfoOffset));
      }
      case Symbol.CONSTANT_LONG_TAG -> {
        return readLong(cpInfoOffset);
      }
      case Symbol.CONSTANT_DOUBLE_TAG -> {
        return Double.longBitsToDouble(readLong(cpInfoOffset));
      }
      case Symbol.CONSTANT_CLASS_TAG -> {
        return Type.getObjectType(readUTF8(cpInfoOffset, charBuffer));
      }
      case Symbol.CONSTANT_STRING_TAG -> {
        return readUTF8(cpInfoOffset, charBuffer);
      }
      case Symbol.CONSTANT_METHOD_TYPE_TAG -> {
        return Type.getMethodType(readUTF8(cpInfoOffset, charBuffer));
      }
      case Symbol.CONSTANT_METHOD_HANDLE_TAG -> {
        var referenceKind = readByte(cpInfoOffset);
        var referenceCpInfoOffset = cpInfoOffsets[readUnsignedShort(cpInfoOffset + 1)];
        var nameAndTypeCpInfoOffset = cpInfoOffsets[readUnsignedShort(referenceCpInfoOffset + 2)];
        var owner = readClass(referenceCpInfoOffset, charBuffer);
        var name = readUTF8(nameAndTypeCpInfoOffset, charBuffer);
        var descriptor = readUTF8(nameAndTypeCpInfoOffset + 2, charBuffer);
        var isInterface = b[referenceCpInfoOffset - 1] == Symbol.CONSTANT_INTERFACE_METHODREF_TAG;
        return new Handle(referenceKind, owner, name, descriptor, isInterface);
      }
      default -> throw new IllegalArgumentException();
    }
  }
}
