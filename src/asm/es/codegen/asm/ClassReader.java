package es.codegen.asm;

public class ClassReader {

  static final int SKIP_CODE = 1;
  static final int SKIP_DEBUG = 2;
  static final int SKIP_FRAMES = 4;
  static final int EXPAND_FRAMES = 8;
  static final int EXPAND_ASM_INSNS = 256;
  static final int INPUT_STREAM_DATA_CHUNK_SIZE = 4096;

  final byte[] b;
  final int[] cpInfoOffsets;
  final String[] constantUtf8Values;
  final ConstantDynamic[] constantDynamicValues;
  final int[] bootstrapMethodOffsets;
  final int maxStringLength;
  final int header;

  public ClassReader(byte[] classFile) {
    this(classFile, 0, classFile.length);
  }

  ClassReader(byte[] classFileBuffer, int classFileOffset, int classFileLength) { // NOPMD(UnusedFormalParameter) used for backward compatibility.
    this(classFileBuffer, classFileOffset, true);
  }

  ClassReader(byte[] classFileBuffer, int classFileOffset, boolean _checkClassVersion) {
    b = classFileBuffer;
    // Create the constant pool arrays. The constant_pool_count field is after the magic,
    // minor_version and major_version fields, which use 4, 2 and 2 bytes respectively.
    int constantPoolCount = readUnsignedShort(classFileOffset + 8);
    cpInfoOffsets = new int[constantPoolCount];
    constantUtf8Values = new String[constantPoolCount];
    // Compute the offset of each constant pool entry, as well as a conservative estimate of the
    // maximum length of the constant pool strings. The first constant pool entry is after the
    // magic, minor_version, major_version and constant_pool_count fields, which use 4, 2, 2 and 2
    // bytes respectively.
    int currentCpInfoIndex = 1;
    int currentCpInfoOffset = classFileOffset + 10;
    int currentMaxStringLength = 0;
    boolean hasConstantDynamic = false;
    boolean hasConstantInvokeDynamic = false;
    // The offset of the other entries depend on the total size of all the previous entries.
    while (currentCpInfoIndex < constantPoolCount) {
      cpInfoOffsets[currentCpInfoIndex++] = currentCpInfoOffset + 1;
      int cpInfoSize;
      switch (classFileBuffer[currentCpInfoOffset]) {
        case Symbol.CONSTANT_FIELDREF_TAG:
        case Symbol.CONSTANT_METHODREF_TAG:
        case Symbol.CONSTANT_INTERFACE_METHODREF_TAG:
        case Symbol.CONSTANT_INTEGER_TAG:
        case Symbol.CONSTANT_FLOAT_TAG:
        case Symbol.CONSTANT_NAME_AND_TYPE_TAG:
          cpInfoSize = 5;
          break;
        case Symbol.CONSTANT_DYNAMIC_TAG:
          cpInfoSize = 5;
          hasConstantDynamic = true;
          break;
        case Symbol.CONSTANT_INVOKE_DYNAMIC_TAG:
          cpInfoSize = 5;
          hasConstantInvokeDynamic = true;
          break;
        case Symbol.CONSTANT_LONG_TAG:
        case Symbol.CONSTANT_DOUBLE_TAG:
          cpInfoSize = 9;
          currentCpInfoIndex++;
          break;
        case Symbol.CONSTANT_UTF8_TAG:
          cpInfoSize = 3 + readUnsignedShort(currentCpInfoOffset + 1);
          if (cpInfoSize > currentMaxStringLength) {
            // The size in bytes of this CONSTANT_Utf8 structure provides a conservative estimate
            // of the length in characters of the corresponding string, and is much cheaper to
            // compute than this exact length.
            currentMaxStringLength = cpInfoSize;
          }
          break;
        case Symbol.CONSTANT_METHOD_HANDLE_TAG:
          cpInfoSize = 4;
          break;
        case Symbol.CONSTANT_CLASS_TAG:
        case Symbol.CONSTANT_STRING_TAG:
        case Symbol.CONSTANT_METHOD_TYPE_TAG:
        case Symbol.CONSTANT_PACKAGE_TAG:
        case Symbol.CONSTANT_MODULE_TAG:
          cpInfoSize = 3;
          break;
        default:
          throw new IllegalArgumentException();
      }
      currentCpInfoOffset += cpInfoSize;
    }
    maxStringLength = currentMaxStringLength;
    // The Classfile's access_flags field is just after the last constant pool entry.
    header = currentCpInfoOffset;

    // Allocate the cache of ConstantDynamic values, if there is at least one.
    constantDynamicValues = hasConstantDynamic ? new ConstantDynamic[constantPoolCount] : null;

    // Read the BootstrapMethods attribute, if any (only get the offset of each method).
    bootstrapMethodOffsets = (hasConstantDynamic | hasConstantInvokeDynamic)
            ? readBootstrapMethodsAttribute(currentMaxStringLength)
            : null;
  }

  int getAccess() {
    return readUnsignedShort(header);
  }

  String getClassName() {
    // this_class is just after the access_flags field (using 2 bytes).
    return readClass(header + 2, new char[maxStringLength]);
  }

  String getSuperName() {
    // super_class is after the access_flags and this_class fields (2 bytes each).
    return readClass(header + 4, new char[maxStringLength]);
  }

  String[] getInterfaces() {
    // interfaces_count is after the access_flags, this_class and super_class fields (2 bytes each).
    int currentOffset = header + 6;
    int interfacesCount = readUnsignedShort(currentOffset);
    String[] interfaces = new String[interfacesCount];
    if (interfacesCount > 0) {
      char[] charBuffer = new char[maxStringLength];
      for (int i = 0; i < interfacesCount; ++i) {
        currentOffset += 2;
        interfaces[i] = readClass(currentOffset, charBuffer);
      }
    }
    return interfaces;
  }

  public void accept(ClassVisitor classVisitor, int parsingOptions) {
    Context context = new Context();
    context.parsingOptions = parsingOptions;
    context.charBuffer = new char[maxStringLength];

    // Read the access_flags, this_class, super_class, interface_count and interfaces fields.
    char[] charBuffer = context.charBuffer;
    int currentOffset = header;
    int accessFlags = readUnsignedShort(currentOffset);
    String thisClass = readClass(currentOffset + 2, charBuffer);
    String superClass = readClass(currentOffset + 4, charBuffer);
    String[] interfaces = new String[readUnsignedShort(currentOffset + 6)];
    currentOffset += 8;
    for (int i = 0; i < interfaces.length; ++i) {
      interfaces[i] = readClass(currentOffset, charBuffer);
      currentOffset += 2;
    }

    // Read the class attributes (the variables are ordered as in Section 4.7 of the JVMS).
    // Attribute offsets exclude the attribute_name_index and attribute_length fields.
    // - The string corresponding to the Signature attribute, or null.
    String signature = null;
    // - The string corresponding to the SourceFile attribute, or null.
    String sourceFile = null;
    // - The string corresponding to the SourceDebugExtension attribute, or null.
    String sourceDebugExtension = null;
    // - The offset of the RuntimeVisibleAnnotations attribute, or 0.
    int runtimeVisibleAnnotationsOffset = 0;

    int currentAttributeOffset = getFirstAttributeOffset();
    for (int i = readUnsignedShort(currentAttributeOffset - 2); i > 0; --i) {
      // Read the attribute_info's attribute_name and attribute_length fields.
      String attributeName = readUTF8(currentAttributeOffset, charBuffer);
      int attributeLength = readInt(currentAttributeOffset + 2);
      currentAttributeOffset += 6;      
      if (Constants.SOURCE_FILE.equals(attributeName)) {
        sourceFile = readUTF8(currentAttributeOffset, charBuffer);
      } else if (Constants.INNER_CLASSES.equals(attributeName)) {
        // ignore
      } else if (Constants.ENCLOSING_METHOD.equals(attributeName)) {
        // ignore
      } else if (Constants.NEST_HOST.equals(attributeName)) {
        // ignore
      } else if (Constants.NEST_MEMBERS.equals(attributeName)) {
        // ignore
      } else if (Constants.SIGNATURE.equals(attributeName)) {
        signature = readUTF8(currentAttributeOffset, charBuffer);
      } else if (Constants.RUNTIME_VISIBLE_ANNOTATIONS.equals(attributeName)) {
        runtimeVisibleAnnotationsOffset = currentAttributeOffset;
      } else if (Constants.BOOTSTRAP_METHODS.equals(attributeName)) {
        // ignore
      } else {
        System.out.println("cr1 attributeName "+attributeName);
      }
      currentAttributeOffset += attributeLength;
    }

    // Visit the class declaration. The minor_version and major_version fields start 6 bytes before
    // the first constant pool entry, which itself starts at cpInfoOffsets[1] - 1 (by definition).
    classVisitor.visit(accessFlags, thisClass, signature, superClass, interfaces);

    // Visit the SourceFile and SourceDebugExtenstion attributes.
    if ((parsingOptions & SKIP_DEBUG) == 0 && (sourceFile != null || sourceDebugExtension != null)) {
      classVisitor.visitSource(sourceFile, sourceDebugExtension);
    }

    // Visit the RuntimeVisibleAnnotations attribute.
    if (runtimeVisibleAnnotationsOffset != 0) {
      int numAnnotations = readUnsignedShort(runtimeVisibleAnnotationsOffset);
      int currentAnnotationOffset = runtimeVisibleAnnotationsOffset + 2;
      while (numAnnotations-- > 0) {
        // Parse the type_index field.
        String annotationDescriptor = readUTF8(currentAnnotationOffset, charBuffer);
        currentAnnotationOffset += 2;
        // Parse num_element_value_pairs and element_value_pairs and visit these values.
        currentAnnotationOffset = readElementValues(classVisitor.visitAnnotation(annotationDescriptor, true), currentAnnotationOffset, true, charBuffer);
      }
    }

    // Visit the fields and methods.
    int fieldsCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (fieldsCount-- > 0) {
      currentOffset = readField(classVisitor, context, currentOffset);
    }
    int methodsCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (methodsCount-- > 0) {
      currentOffset = readMethod(classVisitor, context, currentOffset);
    }

    // Visit the end of the class.
    classVisitor.visitEnd();
  }

  int readField(ClassVisitor classVisitor, Context context, int fieldInfoOffset) {
    char[] charBuffer = context.charBuffer;

    // Read the access_flags, name_index and descriptor_index fields.
    int currentOffset = fieldInfoOffset;
    int accessFlags = readUnsignedShort(currentOffset);
    String name = readUTF8(currentOffset + 2, charBuffer);
    String descriptor = readUTF8(currentOffset + 4, charBuffer);
    currentOffset += 6;

    // Read the field attributes (the variables are ordered as in Section 4.7 of the JVMS).
    // Attribute offsets exclude the attribute_name_index and attribute_length fields.
    // - The value corresponding to the ConstantValue attribute, or null.
    Object constantValue = null;
    // - The string corresponding to the Signature attribute, or null.
    String signature = null;
    // - The offset of the RuntimeVisibleAnnotations attribute, or 0.
    int runtimeVisibleAnnotationsOffset = 0;

    int attributesCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (attributesCount-- > 0) {
      // Read the attribute_info's attribute_name and attribute_length fields.
      String attributeName = readUTF8(currentOffset, charBuffer);
      int attributeLength = readInt(currentOffset + 2);
      currentOffset += 6;
      if (Constants.CONSTANT_VALUE.equals(attributeName)) {
        int constantvalueIndex = readUnsignedShort(currentOffset);
        constantValue = constantvalueIndex == 0 ? null : readConst(constantvalueIndex, charBuffer);
      } else if (Constants.SIGNATURE.equals(attributeName)) {
        signature = readUTF8(currentOffset, charBuffer);
      } else if (Constants.RUNTIME_VISIBLE_ANNOTATIONS.equals(attributeName)) {
        runtimeVisibleAnnotationsOffset = currentOffset;
      } else {
        System.out.println("cr2 attributeName "+attributeName);
      }
      currentOffset += attributeLength;
    }

    // Visit the field declaration.
    FieldVisitor fieldVisitor = classVisitor.visitField(accessFlags, name, descriptor, signature, constantValue);
    if (fieldVisitor == null) {
      return currentOffset;
    }

    // Visit the RuntimeVisibleAnnotations attribute.
    if (runtimeVisibleAnnotationsOffset != 0) {
      int numAnnotations = readUnsignedShort(runtimeVisibleAnnotationsOffset);
      int currentAnnotationOffset = runtimeVisibleAnnotationsOffset + 2;
      while (numAnnotations-- > 0) {
        // Parse the type_index field.
        String annotationDescriptor = readUTF8(currentAnnotationOffset, charBuffer);
        currentAnnotationOffset += 2;
        // Parse num_element_value_pairs and element_value_pairs and visit these values.
        currentAnnotationOffset = readElementValues(fieldVisitor.visitAnnotation(annotationDescriptor, true),
                currentAnnotationOffset, true, charBuffer);
      }
    }

    // Visit the end of the field.
    fieldVisitor.visitEnd();
    return currentOffset;
  }

  int readMethod(ClassVisitor classVisitor, Context context, int methodInfoOffset) {
    char[] charBuffer = context.charBuffer;

    // Read the access_flags, name_index and descriptor_index fields.
    int currentOffset = methodInfoOffset;
    context.currentMethodAccessFlags = readUnsignedShort(currentOffset);
    context.currentMethodName = readUTF8(currentOffset + 2, charBuffer);
    context.currentMethodDescriptor = readUTF8(currentOffset + 4, charBuffer);
    currentOffset += 6;

    // Read the method attributes (the variables are ordered as in Section 4.7 of the JVMS).
    // Attribute offsets exclude the attribute_name_index and attribute_length fields.
    // - The offset of the Code attribute, or 0.
    int codeOffset = 0;
    // - The offset of the Exceptions attribute, or 0.
    int exceptionsOffset = 0;
    // - The strings corresponding to the Exceptions attribute, or null.
    String[] exceptions = null;
    // - Whether the method has a Synthetic attribute.
    boolean synthetic = false;
    // - The constant pool index contained in the Signature attribute, or 0.
    int signatureIndex = 0;
    // - The offset of the RuntimeVisibleAnnotations attribute, or 0.
    int runtimeVisibleAnnotationsOffset = 0;

    int attributesCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (attributesCount-- > 0) {
      // Read the attribute_info's attribute_name and attribute_length fields.
      String attributeName = readUTF8(currentOffset, charBuffer);
      int attributeLength = readInt(currentOffset + 2);
      currentOffset += 6;
      if (Constants.CODE.equals(attributeName)) {
        if ((context.parsingOptions & SKIP_CODE) == 0) {
          codeOffset = currentOffset;
        }
      } else if (Constants.EXCEPTIONS.equals(attributeName)) {
        exceptionsOffset = currentOffset;
        exceptions = new String[readUnsignedShort(exceptionsOffset)];
        int currentExceptionOffset = exceptionsOffset + 2;
        for (int i = 0; i < exceptions.length; ++i) {
          exceptions[i] = readClass(currentExceptionOffset, charBuffer);
          currentExceptionOffset += 2;
        }
      } else if (Constants.SIGNATURE.equals(attributeName)) {
        signatureIndex = readUnsignedShort(currentOffset);
      } else if (Constants.RUNTIME_VISIBLE_ANNOTATIONS.equals(attributeName)) {
        runtimeVisibleAnnotationsOffset = currentOffset;
      } else {
        System.out.println("cr3 attributeName "+attributeName);
      }
      currentOffset += attributeLength;
    }

    // Visit the method declaration.
    MethodVisitor methodVisitor = classVisitor.visitMethod(context.currentMethodAccessFlags, context.currentMethodName,
            context.currentMethodDescriptor, signatureIndex == 0 ? null : readUtf(signatureIndex, charBuffer), exceptions);
    if (methodVisitor == null) {
      return currentOffset;
    }

    // If the returned MethodVisitor is in fact a MethodWriter, it means there is no method
    // adapter between the reader and the writer. In this case, it might be possible to copy
    // the method attributes directly into the writer. If so, return early without visiting
    // the content of these attributes.
    if (methodVisitor instanceof MethodWriter) {
      MethodWriter methodWriter = (MethodWriter) methodVisitor;
      if (methodWriter.canCopyMethodAttributes(this, methodInfoOffset, currentOffset - methodInfoOffset, synthetic,
              false, readUnsignedShort(methodInfoOffset + 4),
              signatureIndex, exceptionsOffset)) {
        return currentOffset;
      }
    }

    // Visit the RuntimeVisibleAnnotations attribute.
    if (runtimeVisibleAnnotationsOffset != 0) {
      int numAnnotations = readUnsignedShort(runtimeVisibleAnnotationsOffset);
      int currentAnnotationOffset = runtimeVisibleAnnotationsOffset + 2;
      while (numAnnotations-- > 0) {
        // Parse the type_index field.
        String annotationDescriptor = readUTF8(currentAnnotationOffset, charBuffer);
        currentAnnotationOffset += 2;
        // Parse num_element_value_pairs and element_value_pairs and visit these values.
        currentAnnotationOffset = readElementValues(methodVisitor.visitAnnotation(annotationDescriptor, true),
                currentAnnotationOffset, true, charBuffer);
      }
    }

    // Visit the Code attribute.
    if (codeOffset != 0) {
      methodVisitor.visitCode();
      readCode(methodVisitor, context, codeOffset);
    }

    // Visit the end of the method.
    methodVisitor.visitEnd();
    return currentOffset;
  }

  void readCode(MethodVisitor methodVisitor, Context context, int codeOffset) {
    int currentOffset = codeOffset;

    // Read the max_stack, max_locals and code_length fields.
    byte[] classFileBuffer = b;
    char[] charBuffer = context.charBuffer;
    int maxStack = readUnsignedShort(currentOffset);
    int maxLocals = readUnsignedShort(currentOffset + 2);
    int codeLength = readInt(currentOffset + 4);
    currentOffset += 8;

    // Read the bytecode 'code' array to create a label for each referenced instruction.
    int bytecodeStartOffset = currentOffset;
    int bytecodeEndOffset = currentOffset + codeLength;
    Label[] labels = context.currentMethodLabels = new Label[codeLength + 1];
    while (currentOffset < bytecodeEndOffset) {
      int bytecodeOffset = currentOffset - bytecodeStartOffset;
      int opcode = classFileBuffer[currentOffset] & 0xFF;
      switch (opcode) {
        case Constants.NOP:
        case Constants.ACONST_NULL:
        case Constants.ICONST_M1:
        case Constants.ICONST_0:
        case Constants.ICONST_1:
        case Constants.ICONST_2:
        case Constants.ICONST_3:
        case Constants.ICONST_4:
        case Constants.ICONST_5:
        case Constants.LCONST_0:
        case Constants.LCONST_1:
        case Constants.FCONST_0:
        case Constants.FCONST_1:
        case Constants.FCONST_2:
        case Constants.DCONST_0:
        case Constants.DCONST_1:
        case Constants.IALOAD:
        case Constants.LALOAD:
        case Constants.FALOAD:
        case Constants.DALOAD:
        case Constants.AALOAD:
        case Constants.BALOAD:
        case Constants.CALOAD:
        case Constants.SALOAD:
        case Constants.IASTORE:
        case Constants.LASTORE:
        case Constants.FASTORE:
        case Constants.DASTORE:
        case Constants.AASTORE:
        case Constants.BASTORE:
        case Constants.CASTORE:
        case Constants.SASTORE:
        case Constants.POP:
        case Constants.POP2:
        case Constants.DUP:
        case Constants.DUP_X1:
        case Constants.DUP_X2:
        case Constants.DUP2:
        case Constants.DUP2_X1:
        case Constants.DUP2_X2:
        case Constants.SWAP:
        case Constants.IADD:
        case Constants.LADD:
        case Constants.FADD:
        case Constants.DADD:
        case Constants.ISUB:
        case Constants.LSUB:
        case Constants.FSUB:
        case Constants.DSUB:
        case Constants.IMUL:
        case Constants.LMUL:
        case Constants.FMUL:
        case Constants.DMUL:
        case Constants.IDIV:
        case Constants.LDIV:
        case Constants.FDIV:
        case Constants.DDIV:
        case Constants.IREM:
        case Constants.LREM:
        case Constants.FREM:
        case Constants.DREM:
        case Constants.INEG:
        case Constants.LNEG:
        case Constants.FNEG:
        case Constants.DNEG:
        case Constants.ISHL:
        case Constants.LSHL:
        case Constants.ISHR:
        case Constants.LSHR:
        case Constants.IUSHR:
        case Constants.LUSHR:
        case Constants.IAND:
        case Constants.LAND:
        case Constants.IOR:
        case Constants.LOR:
        case Constants.IXOR:
        case Constants.LXOR:
        case Constants.I2L:
        case Constants.I2F:
        case Constants.I2D:
        case Constants.L2I:
        case Constants.L2F:
        case Constants.L2D:
        case Constants.F2I:
        case Constants.F2L:
        case Constants.F2D:
        case Constants.D2I:
        case Constants.D2L:
        case Constants.D2F:
        case Constants.I2B:
        case Constants.I2C:
        case Constants.I2S:
        case Constants.LCMP:
        case Constants.FCMPL:
        case Constants.FCMPG:
        case Constants.DCMPL:
        case Constants.DCMPG:
        case Constants.IRETURN:
        case Constants.LRETURN:
        case Constants.FRETURN:
        case Constants.DRETURN:
        case Constants.ARETURN:
        case Constants.RETURN:
        case Constants.ARRAYLENGTH:
        case Constants.ATHROW:
        case Constants.MONITORENTER:
        case Constants.MONITOREXIT:
        case Constants.ILOAD_0:
        case Constants.ILOAD_1:
        case Constants.ILOAD_2:
        case Constants.ILOAD_3:
        case Constants.LLOAD_0:
        case Constants.LLOAD_1:
        case Constants.LLOAD_2:
        case Constants.LLOAD_3:
        case Constants.FLOAD_0:
        case Constants.FLOAD_1:
        case Constants.FLOAD_2:
        case Constants.FLOAD_3:
        case Constants.DLOAD_0:
        case Constants.DLOAD_1:
        case Constants.DLOAD_2:
        case Constants.DLOAD_3:
        case Constants.ALOAD_0:
        case Constants.ALOAD_1:
        case Constants.ALOAD_2:
        case Constants.ALOAD_3:
        case Constants.ISTORE_0:
        case Constants.ISTORE_1:
        case Constants.ISTORE_2:
        case Constants.ISTORE_3:
        case Constants.LSTORE_0:
        case Constants.LSTORE_1:
        case Constants.LSTORE_2:
        case Constants.LSTORE_3:
        case Constants.FSTORE_0:
        case Constants.FSTORE_1:
        case Constants.FSTORE_2:
        case Constants.FSTORE_3:
        case Constants.DSTORE_0:
        case Constants.DSTORE_1:
        case Constants.DSTORE_2:
        case Constants.DSTORE_3:
        case Constants.ASTORE_0:
        case Constants.ASTORE_1:
        case Constants.ASTORE_2:
        case Constants.ASTORE_3:
          currentOffset += 1;
          break;
        case Constants.IFEQ:
        case Constants.IFNE:
        case Constants.IFLT:
        case Constants.IFGE:
        case Constants.IFGT:
        case Constants.IFLE:
        case Constants.IF_ICMPEQ:
        case Constants.IF_ICMPNE:
        case Constants.IF_ICMPLT:
        case Constants.IF_ICMPGE:
        case Constants.IF_ICMPGT:
        case Constants.IF_ICMPLE:
        case Constants.IF_ACMPEQ:
        case Constants.IF_ACMPNE:
        case Constants.GOTO:
        case Constants.JSR:
        case Constants.IFNULL:
        case Constants.IFNONNULL:
          createLabel(bytecodeOffset + readShort(currentOffset + 1), labels);
          currentOffset += 3;
          break;
        case Constants.ASM_IFEQ:
        case Constants.ASM_IFNE:
        case Constants.ASM_IFLT:
        case Constants.ASM_IFGE:
        case Constants.ASM_IFGT:
        case Constants.ASM_IFLE:
        case Constants.ASM_IF_ICMPEQ:
        case Constants.ASM_IF_ICMPNE:
        case Constants.ASM_IF_ICMPLT:
        case Constants.ASM_IF_ICMPGE:
        case Constants.ASM_IF_ICMPGT:
        case Constants.ASM_IF_ICMPLE:
        case Constants.ASM_IF_ACMPEQ:
        case Constants.ASM_IF_ACMPNE:
        case Constants.ASM_GOTO:
        case Constants.ASM_JSR:
        case Constants.ASM_IFNULL:
        case Constants.ASM_IFNONNULL:
          createLabel(bytecodeOffset + readUnsignedShort(currentOffset + 1), labels);
          currentOffset += 3;
          break;
        case Constants.GOTO_W:
        case Constants.JSR_W:
        case Constants.ASM_GOTO_W:
          createLabel(bytecodeOffset + readInt(currentOffset + 1), labels);
          currentOffset += 5;
          break;
        case Constants.WIDE:
          switch (classFileBuffer[currentOffset + 1] & 0xFF) {
            case Constants.ILOAD:
            case Constants.FLOAD:
            case Constants.ALOAD:
            case Constants.LLOAD:
            case Constants.DLOAD:
            case Constants.ISTORE:
            case Constants.FSTORE:
            case Constants.ASTORE:
            case Constants.LSTORE:
            case Constants.DSTORE:
            case Constants.RET:
              currentOffset += 4;
              break;
            case Constants.IINC:
              currentOffset += 6;
              break;
            default:
              throw new IllegalArgumentException();
          }
          break;
        case Constants.TABLESWITCH:
          // Skip 0 to 3 padding bytes.
          currentOffset += 4 - (bytecodeOffset & 3);
          // Read the default label and the number of table entries.
          createLabel(bytecodeOffset + readInt(currentOffset), labels);
          int numTableEntries = readInt(currentOffset + 8) - readInt(currentOffset + 4) + 1;
          currentOffset += 12;
          // Read the table labels.
          while (numTableEntries-- > 0) {
            createLabel(bytecodeOffset + readInt(currentOffset), labels);
            currentOffset += 4;
          }
          break;
        case Constants.LOOKUPSWITCH:
          // Skip 0 to 3 padding bytes.
          currentOffset += 4 - (bytecodeOffset & 3);
          // Read the default label and the number of switch cases.
          createLabel(bytecodeOffset + readInt(currentOffset), labels);
          int numSwitchCases = readInt(currentOffset + 4);
          currentOffset += 8;
          // Read the switch labels.
          while (numSwitchCases-- > 0) {
            createLabel(bytecodeOffset + readInt(currentOffset + 4), labels);
            currentOffset += 8;
          }
          break;
        case Constants.ILOAD:
        case Constants.LLOAD:
        case Constants.FLOAD:
        case Constants.DLOAD:
        case Constants.ALOAD:
        case Constants.ISTORE:
        case Constants.LSTORE:
        case Constants.FSTORE:
        case Constants.DSTORE:
        case Constants.ASTORE:
        case Constants.RET:
        case Constants.BIPUSH:
        case Constants.NEWARRAY:
        case Constants.LDC:
          currentOffset += 2;
          break;
        case Constants.SIPUSH:
        case Constants.LDC_W:
        case Constants.LDC2_W:
        case Constants.GETSTATIC:
        case Constants.PUTSTATIC:
        case Constants.GETFIELD:
        case Constants.PUTFIELD:
        case Constants.INVOKEVIRTUAL:
        case Constants.INVOKESPECIAL:
        case Constants.INVOKESTATIC:
        case Constants.NEW:
        case Constants.ANEWARRAY:
        case Constants.CHECKCAST:
        case Constants.INSTANCEOF:
        case Constants.IINC:
          currentOffset += 3;
          break;
        case Constants.INVOKEINTERFACE:
        case Constants.INVOKEDYNAMIC:
          currentOffset += 5;
          break;
        case Constants.MULTIANEWARRAY:
          currentOffset += 4;
          break;
        default:
          throw new IllegalArgumentException();
      }
    }

    // Read the 'exception_table_length' and 'exception_table' field to create a label for each
    // referenced instruction, and to make methodVisitor visit the corresponding try catch blocks.
    int exceptionTableLength = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (exceptionTableLength-- > 0) {
      Label start = createLabel(readUnsignedShort(currentOffset), labels);
      Label end = createLabel(readUnsignedShort(currentOffset + 2), labels);
      Label handler = createLabel(readUnsignedShort(currentOffset + 4), labels);
      String catchType = readUTF8(cpInfoOffsets[readUnsignedShort(currentOffset + 6)], charBuffer);
      currentOffset += 8;
      methodVisitor.visitTryCatchBlock(start, end, handler, catchType);
    }

    // Read the Code attributes to create a label for each referenced instruction (the variables
    // are ordered as in Section 4.7 of the JVMS). Attribute offsets exclude the
    // attribute_name_index and attribute_length fields.
    // - The offset of the current 'stack_map_frame' in the StackMap[Table] attribute, or 0.
    // Initially, this is the offset of the first 'stack_map_frame' entry. Then this offset is
    // updated after each stack_map_frame is read.
    int stackMapFrameOffset = 0;
    // - The end offset of the StackMap[Table] attribute, or 0.
    int stackMapTableEndOffset = 0;
    // - Whether the stack map frames are compressed (i.e. in a StackMapTable) or not.
    boolean compressedFrames = true;
    // - The offset of the LocalVariableTable attribute, or 0.
    int localVariableTableOffset = 0;
    // - The offset of the LocalVariableTypeTable attribute, or 0.
    int localVariableTypeTableOffset = 0;

    int attributesCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (attributesCount-- > 0) {
      // Read the attribute_info's attribute_name and attribute_length fields.
      String attributeName = readUTF8(currentOffset, charBuffer);
      int attributeLength = readInt(currentOffset + 2);
      currentOffset += 6;
      if (Constants.LOCAL_VARIABLE_TABLE.equals(attributeName)) {
        if ((context.parsingOptions & SKIP_DEBUG) == 0) {
          localVariableTableOffset = currentOffset;
          // Parse the attribute to find the corresponding (debug only) labels.
          int currentLocalVariableTableOffset = currentOffset;
          int localVariableTableLength = readUnsignedShort(currentLocalVariableTableOffset);
          currentLocalVariableTableOffset += 2;
          while (localVariableTableLength-- > 0) {
            int startPc = readUnsignedShort(currentLocalVariableTableOffset);
            createDebugLabel(startPc, labels);
            int length = readUnsignedShort(currentLocalVariableTableOffset + 2);
            createDebugLabel(startPc + length, labels);
            // Skip the name_index, descriptor_index and index fields (2 bytes each).
            currentLocalVariableTableOffset += 10;
          }
        }
      } else if (Constants.LOCAL_VARIABLE_TYPE_TABLE.equals(attributeName)) {
        localVariableTypeTableOffset = currentOffset;
        // Here we do not extract the labels corresponding to the attribute content. We assume they
        // are the same or a subset of those of the LocalVariableTable attribute.
      } else if (Constants.LINE_NUMBER_TABLE.equals(attributeName)) {
        if ((context.parsingOptions & SKIP_DEBUG) == 0) {
          // Parse the attribute to find the corresponding (debug only) labels.
          int currentLineNumberTableOffset = currentOffset;
          int lineNumberTableLength = readUnsignedShort(currentLineNumberTableOffset);
          currentLineNumberTableOffset += 2;
          while (lineNumberTableLength-- > 0) {
            int startPc = readUnsignedShort(currentLineNumberTableOffset);
            int lineNumber = readUnsignedShort(currentLineNumberTableOffset + 2);
            currentLineNumberTableOffset += 4;
            createDebugLabel(startPc, labels);
            labels[startPc].addLineNumber(lineNumber);
          }
        }
      } else if (Constants.STACK_MAP_TABLE.equals(attributeName)) {
        if ((context.parsingOptions & SKIP_FRAMES) == 0) {
          stackMapFrameOffset = currentOffset + 2;
          stackMapTableEndOffset = currentOffset + attributeLength;
        }
        // Here we do not extract the labels corresponding to the attribute content. This would
        // require a full parsing of the attribute, which would need to be repeated when parsing
        // the bytecode instructions (see below). Instead, the content of the attribute is read one
        // frame at a time (i.e. after a frame has been visited, the next frame is read), and the
        // labels it contains are also extracted one frame at a time. Thanks to the ordering of
        // frames, having only a "one frame lookahead" is not a problem, i.e. it is not possible to
        // see an offset smaller than the offset of the current instruction and for which no Label
        // exist. Except for UNINITIALIZED type offsets. We solve this by parsing the stack map
        // table without a full decoding (see below).
      } else if ("StackMap".equals(attributeName)) {
        if ((context.parsingOptions & SKIP_FRAMES) == 0) {
          stackMapFrameOffset = currentOffset + 2;
          stackMapTableEndOffset = currentOffset + attributeLength;
          compressedFrames = false;
        }
        // IMPORTANT! Here we assume that the frames are ordered, as in the StackMapTable attribute,
        // although this is not guaranteed by the attribute format. This allows an incremental
        // extraction of the labels corresponding to this attribute (see the comment above for the
        // StackMapTable attribute).
      } else {
        System.out.println("cr4 attributeName "+attributeName);
      }
      currentOffset += attributeLength;
    }

    // Initialize the context fields related to stack map frames, and generate the first
    // (implicit) stack map frame, if needed.
    boolean expandFrames = (context.parsingOptions & EXPAND_FRAMES) != 0;
    if (stackMapFrameOffset != 0) {
      // The bytecode offset of the first explicit frame is not offset_delta + 1 but only
      // offset_delta. Setting the implicit frame offset to -1 allows us to use of the
      // "offset_delta + 1" rule in all cases.
      context.currentFrameOffset = -1;
      context.currentFrameType = 0;
      context.currentFrameLocalCount = 0;
      context.currentFrameLocalCountDelta = 0;
      context.currentFrameLocalTypes = new Object[maxLocals];
      context.currentFrameStackCount = 0;
      context.currentFrameStackTypes = new Object[maxStack];
      if (expandFrames) {
        computeImplicitFrame(context);
      }
      // Find the labels for UNINITIALIZED frame types. Instead of decoding each element of the
      // stack map table, we look for 3 consecutive bytes that "look like" an UNINITIALIZED type
      // (tag ITEM_Uninitialized, offset within bytecode bounds, NEW instruction at this offset).
      // We may find false positives (i.e. not real UNINITIALIZED types), but this should be rare,
      // and the only consequence will be the creation of an unneeded label. This is better than
      // creating a label for each NEW instruction, and faster than fully decoding the whole stack
      // map table.
      for (int offset = stackMapFrameOffset; offset < stackMapTableEndOffset - 2; ++offset) {
        if (classFileBuffer[offset] == Frame.ITEM_UNINITIALIZED) {
          int potentialBytecodeOffset = readUnsignedShort(offset + 1);
          if (potentialBytecodeOffset >= 0 && potentialBytecodeOffset < codeLength
                  && (classFileBuffer[bytecodeStartOffset + potentialBytecodeOffset] & 0xFF) == Opcodes.NEW) {
            createLabel(potentialBytecodeOffset, labels);
          }
        }
      }
    }
    if (expandFrames && (context.parsingOptions & EXPAND_ASM_INSNS) != 0) {
      // Expanding the ASM specific instructions can introduce F_INSERT frames, even if the method
      // does not currently have any frame. These inserted frames must be computed by simulating the
      // effect of the bytecode instructions, one by one, starting from the implicit first frame.
      // For this, MethodWriter needs to know maxLocals before the first instruction is visited. To
      // ensure this, we visit the implicit first frame here (passing only maxLocals - the rest is
      // computed in MethodWriter).
      methodVisitor.visitFrame(Opcodes.F_NEW, maxLocals, null, 0, null);
    }

    // Visit the bytecode instructions.

    // Whether a F_INSERT stack map frame must be inserted before the current instruction.
    boolean insertFrame = false;

    // The delta to subtract from a goto_w or jsr_w opcode to get the corresponding goto or jsr
    // opcode, or 0 if goto_w and jsr_w must be left unchanged (i.e. when expanding ASM specific
    // instructions).
    int wideJumpOpcodeDelta = (context.parsingOptions & EXPAND_ASM_INSNS) == 0 ? Constants.WIDE_JUMP_OPCODE_DELTA
            : 0;

    currentOffset = bytecodeStartOffset;
    while (currentOffset < bytecodeEndOffset) {
      int currentBytecodeOffset = currentOffset - bytecodeStartOffset;

      // Visit the label and the line number(s) for this bytecode offset, if any.
      Label currentLabel = labels[currentBytecodeOffset];
      if (currentLabel != null) {
        currentLabel.accept(methodVisitor, (context.parsingOptions & SKIP_DEBUG) == 0);
      }

      // Visit the stack map frame for this bytecode offset, if any.
      while (stackMapFrameOffset != 0
              && (context.currentFrameOffset == currentBytecodeOffset || context.currentFrameOffset == -1)) {
        // If there is a stack map frame for this offset, make methodVisitor visit it, and read the
        // next stack map frame if there is one.
        if (context.currentFrameOffset != -1) {
          if (!compressedFrames || expandFrames) {
            methodVisitor.visitFrame(Opcodes.F_NEW, context.currentFrameLocalCount, context.currentFrameLocalTypes,
                    context.currentFrameStackCount, context.currentFrameStackTypes);
          } else {
            methodVisitor.visitFrame(context.currentFrameType, context.currentFrameLocalCountDelta,
                    context.currentFrameLocalTypes, context.currentFrameStackCount, context.currentFrameStackTypes);
          }
          // Since there is already a stack map frame for this bytecode offset, there is no need to
          // insert a new one.
          insertFrame = false;
        }
        if (stackMapFrameOffset < stackMapTableEndOffset) {
          stackMapFrameOffset = readStackMapFrame(stackMapFrameOffset, compressedFrames, expandFrames, context);
        } else {
          stackMapFrameOffset = 0;
        }
      }

      // Insert a stack map frame for this bytecode offset, if requested by setting insertFrame to
      // true during the previous iteration. The actual frame content is computed in MethodWriter.
      if (insertFrame) {
        if ((context.parsingOptions & EXPAND_FRAMES) != 0) {
          methodVisitor.visitFrame(Constants.F_INSERT, 0, null, 0, null);
        }
        insertFrame = false;
      }

      // Visit the instruction at this bytecode offset.
      int opcode = classFileBuffer[currentOffset] & 0xFF;
      switch (opcode) {
        case Constants.NOP:
        case Constants.ACONST_NULL:
        case Constants.ICONST_M1:
        case Constants.ICONST_0:
        case Constants.ICONST_1:
        case Constants.ICONST_2:
        case Constants.ICONST_3:
        case Constants.ICONST_4:
        case Constants.ICONST_5:
        case Constants.LCONST_0:
        case Constants.LCONST_1:
        case Constants.FCONST_0:
        case Constants.FCONST_1:
        case Constants.FCONST_2:
        case Constants.DCONST_0:
        case Constants.DCONST_1:
        case Constants.IALOAD:
        case Constants.LALOAD:
        case Constants.FALOAD:
        case Constants.DALOAD:
        case Constants.AALOAD:
        case Constants.BALOAD:
        case Constants.CALOAD:
        case Constants.SALOAD:
        case Constants.IASTORE:
        case Constants.LASTORE:
        case Constants.FASTORE:
        case Constants.DASTORE:
        case Constants.AASTORE:
        case Constants.BASTORE:
        case Constants.CASTORE:
        case Constants.SASTORE:
        case Constants.POP:
        case Constants.POP2:
        case Constants.DUP:
        case Constants.DUP_X1:
        case Constants.DUP_X2:
        case Constants.DUP2:
        case Constants.DUP2_X1:
        case Constants.DUP2_X2:
        case Constants.SWAP:
        case Constants.IADD:
        case Constants.LADD:
        case Constants.FADD:
        case Constants.DADD:
        case Constants.ISUB:
        case Constants.LSUB:
        case Constants.FSUB:
        case Constants.DSUB:
        case Constants.IMUL:
        case Constants.LMUL:
        case Constants.FMUL:
        case Constants.DMUL:
        case Constants.IDIV:
        case Constants.LDIV:
        case Constants.FDIV:
        case Constants.DDIV:
        case Constants.IREM:
        case Constants.LREM:
        case Constants.FREM:
        case Constants.DREM:
        case Constants.INEG:
        case Constants.LNEG:
        case Constants.FNEG:
        case Constants.DNEG:
        case Constants.ISHL:
        case Constants.LSHL:
        case Constants.ISHR:
        case Constants.LSHR:
        case Constants.IUSHR:
        case Constants.LUSHR:
        case Constants.IAND:
        case Constants.LAND:
        case Constants.IOR:
        case Constants.LOR:
        case Constants.IXOR:
        case Constants.LXOR:
        case Constants.I2L:
        case Constants.I2F:
        case Constants.I2D:
        case Constants.L2I:
        case Constants.L2F:
        case Constants.L2D:
        case Constants.F2I:
        case Constants.F2L:
        case Constants.F2D:
        case Constants.D2I:
        case Constants.D2L:
        case Constants.D2F:
        case Constants.I2B:
        case Constants.I2C:
        case Constants.I2S:
        case Constants.LCMP:
        case Constants.FCMPL:
        case Constants.FCMPG:
        case Constants.DCMPL:
        case Constants.DCMPG:
        case Constants.IRETURN:
        case Constants.LRETURN:
        case Constants.FRETURN:
        case Constants.DRETURN:
        case Constants.ARETURN:
        case Constants.RETURN:
        case Constants.ARRAYLENGTH:
        case Constants.ATHROW:
        case Constants.MONITORENTER:
        case Constants.MONITOREXIT:
          methodVisitor.visitInsn(opcode);
          currentOffset += 1;
          break;
        case Constants.ILOAD_0:
        case Constants.ILOAD_1:
        case Constants.ILOAD_2:
        case Constants.ILOAD_3:
        case Constants.LLOAD_0:
        case Constants.LLOAD_1:
        case Constants.LLOAD_2:
        case Constants.LLOAD_3:
        case Constants.FLOAD_0:
        case Constants.FLOAD_1:
        case Constants.FLOAD_2:
        case Constants.FLOAD_3:
        case Constants.DLOAD_0:
        case Constants.DLOAD_1:
        case Constants.DLOAD_2:
        case Constants.DLOAD_3:
        case Constants.ALOAD_0:
        case Constants.ALOAD_1:
        case Constants.ALOAD_2:
        case Constants.ALOAD_3:
          opcode -= Constants.ILOAD_0;
          methodVisitor.visitVarInsn(Opcodes.ILOAD + (opcode >> 2), opcode & 0x3);
          currentOffset += 1;
          break;
        case Constants.ISTORE_0:
        case Constants.ISTORE_1:
        case Constants.ISTORE_2:
        case Constants.ISTORE_3:
        case Constants.LSTORE_0:
        case Constants.LSTORE_1:
        case Constants.LSTORE_2:
        case Constants.LSTORE_3:
        case Constants.FSTORE_0:
        case Constants.FSTORE_1:
        case Constants.FSTORE_2:
        case Constants.FSTORE_3:
        case Constants.DSTORE_0:
        case Constants.DSTORE_1:
        case Constants.DSTORE_2:
        case Constants.DSTORE_3:
        case Constants.ASTORE_0:
        case Constants.ASTORE_1:
        case Constants.ASTORE_2:
        case Constants.ASTORE_3:
          opcode -= Constants.ISTORE_0;
          methodVisitor.visitVarInsn(Opcodes.ISTORE + (opcode >> 2), opcode & 0x3);
          currentOffset += 1;
          break;
        case Constants.IFEQ:
        case Constants.IFNE:
        case Constants.IFLT:
        case Constants.IFGE:
        case Constants.IFGT:
        case Constants.IFLE:
        case Constants.IF_ICMPEQ:
        case Constants.IF_ICMPNE:
        case Constants.IF_ICMPLT:
        case Constants.IF_ICMPGE:
        case Constants.IF_ICMPGT:
        case Constants.IF_ICMPLE:
        case Constants.IF_ACMPEQ:
        case Constants.IF_ACMPNE:
        case Constants.GOTO:
        case Constants.JSR:
        case Constants.IFNULL:
        case Constants.IFNONNULL:
          methodVisitor.visitJumpInsn(opcode, labels[currentBytecodeOffset + readShort(currentOffset + 1)]);
          currentOffset += 3;
          break;
        case Constants.GOTO_W:
        case Constants.JSR_W:
          methodVisitor.visitJumpInsn(opcode - wideJumpOpcodeDelta,
                  labels[currentBytecodeOffset + readInt(currentOffset + 1)]);
          currentOffset += 5;
          break;
        case Constants.ASM_IFEQ:
        case Constants.ASM_IFNE:
        case Constants.ASM_IFLT:
        case Constants.ASM_IFGE:
        case Constants.ASM_IFGT:
        case Constants.ASM_IFLE:
        case Constants.ASM_IF_ICMPEQ:
        case Constants.ASM_IF_ICMPNE:
        case Constants.ASM_IF_ICMPLT:
        case Constants.ASM_IF_ICMPGE:
        case Constants.ASM_IF_ICMPGT:
        case Constants.ASM_IF_ICMPLE:
        case Constants.ASM_IF_ACMPEQ:
        case Constants.ASM_IF_ACMPNE:
        case Constants.ASM_GOTO:
        case Constants.ASM_JSR:
        case Constants.ASM_IFNULL:
        case Constants.ASM_IFNONNULL: {
          // A forward jump with an offset > 32767. In this case we automatically replace ASM_GOTO
          // with GOTO_W, ASM_JSR with JSR_W and ASM_IFxxx <l> with IFNOTxxx <L> GOTO_W <l> L:...,
          // where IFNOTxxx is the "opposite" opcode of ASMS_IFxxx (e.g. IFNE for ASM_IFEQ) and
          // where <L> designates the instruction just after the GOTO_W.
          // First, change the ASM specific opcodes ASM_IFEQ ... ASM_JSR, ASM_IFNULL and
          // ASM_IFNONNULL to IFEQ ... JSR, IFNULL and IFNONNULL.
          opcode = opcode < Constants.ASM_IFNULL ? opcode - Constants.ASM_OPCODE_DELTA
                  : opcode - Constants.ASM_IFNULL_OPCODE_DELTA;
          Label target = labels[currentBytecodeOffset + readUnsignedShort(currentOffset + 1)];
          if (opcode == Opcodes.GOTO || opcode == Opcodes.JSR) {
            // Replace GOTO with GOTO_W and JSR with JSR_W.
            methodVisitor.visitJumpInsn(opcode + Constants.WIDE_JUMP_OPCODE_DELTA, target);
          } else {
            // Compute the "opposite" of opcode. This can be done by flipping the least
            // significant bit for IFNULL and IFNONNULL, and similarly for IFEQ ... IF_ACMPEQ
            // (with a pre and post offset by 1).
            opcode = opcode < Opcodes.GOTO ? ((opcode + 1) ^ 1) - 1 : opcode ^ 1;
            Label endif = createLabel(currentBytecodeOffset + 3, labels);
            methodVisitor.visitJumpInsn(opcode, endif);
            methodVisitor.visitJumpInsn(Constants.GOTO_W, target);
            // endif designates the instruction just after GOTO_W, and is visited as part of the
            // next instruction. Since it is a jump target, we need to insert a frame here.
            insertFrame = true;
          }
          currentOffset += 3;
          break;
        }
        case Constants.ASM_GOTO_W: {
          // Replace ASM_GOTO_W with GOTO_W.
          methodVisitor.visitJumpInsn(Constants.GOTO_W, labels[currentBytecodeOffset + readInt(currentOffset + 1)]);
          // The instruction just after is a jump target (because ASM_GOTO_W is used in patterns
          // IFNOTxxx <L> ASM_GOTO_W <l> L:..., see MethodWriter), so we need to insert a frame
          // here.
          insertFrame = true;
          currentOffset += 5;
          break;
        }
        case Constants.WIDE:
          opcode = classFileBuffer[currentOffset + 1] & 0xFF;
          if (opcode == Opcodes.IINC) {
            methodVisitor.visitIincInsn(readUnsignedShort(currentOffset + 2), readShort(currentOffset + 4));
            currentOffset += 6;
          } else {
            methodVisitor.visitVarInsn(opcode, readUnsignedShort(currentOffset + 2));
            currentOffset += 4;
          }
          break;
        case Constants.TABLESWITCH: {
          // Skip 0 to 3 padding bytes.
          currentOffset += 4 - (currentBytecodeOffset & 3);
          // Read the instruction.
          Label defaultLabel = labels[currentBytecodeOffset + readInt(currentOffset)];
          int low = readInt(currentOffset + 4);
          int high = readInt(currentOffset + 8);
          currentOffset += 12;
          Label[] table = new Label[high - low + 1];
          for (int i = 0; i < table.length; ++i) {
            table[i] = labels[currentBytecodeOffset + readInt(currentOffset)];
            currentOffset += 4;
          }
          methodVisitor.visitTableSwitchInsn(low, high, defaultLabel, table);
          break;
        }
        case Constants.LOOKUPSWITCH: {
          // Skip 0 to 3 padding bytes.
          currentOffset += 4 - (currentBytecodeOffset & 3);
          // Read the instruction.
          Label defaultLabel = labels[currentBytecodeOffset + readInt(currentOffset)];
          int numPairs = readInt(currentOffset + 4);
          currentOffset += 8;
          int[] keys = new int[numPairs];
          Label[] values = new Label[numPairs];
          for (int i = 0; i < numPairs; ++i) {
            keys[i] = readInt(currentOffset);
            values[i] = labels[currentBytecodeOffset + readInt(currentOffset + 4)];
            currentOffset += 8;
          }
          methodVisitor.visitLookupSwitchInsn(defaultLabel, keys, values);
          break;
        }
        case Constants.ILOAD:
        case Constants.LLOAD:
        case Constants.FLOAD:
        case Constants.DLOAD:
        case Constants.ALOAD:
        case Constants.ISTORE:
        case Constants.LSTORE:
        case Constants.FSTORE:
        case Constants.DSTORE:
        case Constants.ASTORE:
        case Constants.RET:
          methodVisitor.visitVarInsn(opcode, classFileBuffer[currentOffset + 1] & 0xFF);
          currentOffset += 2;
          break;
        case Constants.BIPUSH:
        case Constants.NEWARRAY:
          methodVisitor.visitIntInsn(opcode, classFileBuffer[currentOffset + 1]);
          currentOffset += 2;
          break;
        case Constants.SIPUSH:
          methodVisitor.visitIntInsn(opcode, readShort(currentOffset + 1));
          currentOffset += 3;
          break;
        case Constants.LDC:
          methodVisitor.visitLdcInsn(readConst(classFileBuffer[currentOffset + 1] & 0xFF, charBuffer));
          currentOffset += 2;
          break;
        case Constants.LDC_W:
        case Constants.LDC2_W:
          methodVisitor.visitLdcInsn(readConst(readUnsignedShort(currentOffset + 1), charBuffer));
          currentOffset += 3;
          break;
        case Constants.GETSTATIC:
        case Constants.PUTSTATIC:
        case Constants.GETFIELD:
        case Constants.PUTFIELD:
        case Constants.INVOKEVIRTUAL:
        case Constants.INVOKESPECIAL:
        case Constants.INVOKESTATIC:
        case Constants.INVOKEINTERFACE: {
          int cpInfoOffset = cpInfoOffsets[readUnsignedShort(currentOffset + 1)];
          int nameAndTypeCpInfoOffset = cpInfoOffsets[readUnsignedShort(cpInfoOffset + 2)];
          String owner = readClass(cpInfoOffset, charBuffer);
          String name = readUTF8(nameAndTypeCpInfoOffset, charBuffer);
          String descriptor = readUTF8(nameAndTypeCpInfoOffset + 2, charBuffer);
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
          break;
        }
        case Constants.INVOKEDYNAMIC: {
          int cpInfoOffset = cpInfoOffsets[readUnsignedShort(currentOffset + 1)];
          int nameAndTypeCpInfoOffset = cpInfoOffsets[readUnsignedShort(cpInfoOffset + 2)];
          String name = readUTF8(nameAndTypeCpInfoOffset, charBuffer);
          String descriptor = readUTF8(nameAndTypeCpInfoOffset + 2, charBuffer);
          int bootstrapMethodOffset = bootstrapMethodOffsets[readUnsignedShort(cpInfoOffset)];
          Handle handle = (Handle) readConst(readUnsignedShort(bootstrapMethodOffset), charBuffer);
          Object[] bootstrapMethodArguments = new Object[readUnsignedShort(bootstrapMethodOffset + 2)];
          bootstrapMethodOffset += 4;
          for (int i = 0; i < bootstrapMethodArguments.length; i++) {
            bootstrapMethodArguments[i] = readConst(readUnsignedShort(bootstrapMethodOffset), charBuffer);
            bootstrapMethodOffset += 2;
          }
          methodVisitor.visitInvokeDynamicInsn(name, descriptor, handle, bootstrapMethodArguments);
          currentOffset += 5;
          break;
        }
        case Constants.NEW:
        case Constants.ANEWARRAY:
        case Constants.CHECKCAST:
        case Constants.INSTANCEOF:
          methodVisitor.visitTypeInsn(opcode, readClass(currentOffset + 1, charBuffer));
          currentOffset += 3;
          break;
        case Constants.IINC:
          methodVisitor.visitIincInsn(classFileBuffer[currentOffset + 1] & 0xFF, classFileBuffer[currentOffset + 2]);
          currentOffset += 3;
          break;
        case Constants.MULTIANEWARRAY:
          methodVisitor.visitMultiANewArrayInsn(readClass(currentOffset + 1, charBuffer),
                  classFileBuffer[currentOffset + 3] & 0xFF);
          currentOffset += 4;
          break;
        default:
          throw new AssertionError();
      }
    }
    if (labels[codeLength] != null) {
      methodVisitor.visitLabel(labels[codeLength]);
    }

    // Visit LocalVariableTable and LocalVariableTypeTable attributes.
    if (localVariableTableOffset != 0 && (context.parsingOptions & SKIP_DEBUG) == 0) {
      // The (start_pc, index, signature_index) fields of each entry of the LocalVariableTypeTable.
      int[] typeTable = null;
      if (localVariableTypeTableOffset != 0) {
        typeTable = new int[readUnsignedShort(localVariableTypeTableOffset) * 3];
        currentOffset = localVariableTypeTableOffset + 2;
        int typeTableIndex = typeTable.length;
        while (typeTableIndex > 0) {
          // Store the offset of 'signature_index', and the value of 'index' and 'start_pc'.
          typeTable[--typeTableIndex] = currentOffset + 6;
          typeTable[--typeTableIndex] = readUnsignedShort(currentOffset + 8);
          typeTable[--typeTableIndex] = readUnsignedShort(currentOffset);
          currentOffset += 10;
        }
      }
      int localVariableTableLength = readUnsignedShort(localVariableTableOffset);
      currentOffset = localVariableTableOffset + 2;
      while (localVariableTableLength-- > 0) {
        int startPc = readUnsignedShort(currentOffset);
        int length = readUnsignedShort(currentOffset + 2);
        String name = readUTF8(currentOffset + 4, charBuffer);
        String descriptor = readUTF8(currentOffset + 6, charBuffer);
        int index = readUnsignedShort(currentOffset + 8);
        currentOffset += 10;
        String signature = null;
        if (typeTable != null) {
          for (int i = 0; i < typeTable.length; i += 3) {
            if (typeTable[i] == startPc && typeTable[i + 1] == index) {
              signature = readUTF8(typeTable[i + 2], charBuffer);
              break;
            }
          }
        }
        methodVisitor.visitLocalVariable(name, descriptor, signature, labels[startPc], labels[startPc + length], index);
      }
    }

    // Visit the max stack and max locals values.
    methodVisitor.visitMaxs(maxStack, maxLocals);
  }

  Label readLabel(int bytecodeOffset, Label[] labels) {
    if (labels[bytecodeOffset] == null) {
      labels[bytecodeOffset] = new Label();
    }
    return labels[bytecodeOffset];
  }

  Label createLabel(int bytecodeOffset, Label[] labels) {
    Label label = readLabel(bytecodeOffset, labels);
    label.flags &= ~Label.FLAG_DEBUG_ONLY;
    return label;
  }

  void createDebugLabel(int bytecodeOffset, Label[] labels) {
    if (labels[bytecodeOffset] == null) {
      readLabel(bytecodeOffset, labels).flags |= Label.FLAG_DEBUG_ONLY;
    }
  }

  int readElementValues(AnnotationVisitor annotationVisitor, int annotationOffset, boolean named, char[] charBuffer) {
    int currentOffset = annotationOffset;
    // Read the num_element_value_pairs field (or num_values field for an array_value).
    int numElementValuePairs = readUnsignedShort(currentOffset);
    currentOffset += 2;
    if (named) {
      // Parse the element_value_pairs array.
      while (numElementValuePairs-- > 0) {
        String elementName = readUTF8(currentOffset, charBuffer);
        currentOffset = readElementValue(annotationVisitor, currentOffset + 2, elementName, charBuffer);
      }
    } else {
      // Parse the array_value array.
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
    int currentOffset = elementValueOffset;
    if (annotationVisitor == null) {
      switch (b[currentOffset] & 0xFF) {
        case 'e': // enum_const_value
          return currentOffset + 5;
        case '@': // annotation_value
          return readElementValues(null, currentOffset + 3, true, charBuffer);
        case '[': // array_value
          return readElementValues(null, currentOffset + 1, false, charBuffer);
        default:
          return currentOffset + 3;
      }
    }
    switch (b[currentOffset++] & 0xFF) {
      case 'B': // const_value_index, CONSTANT_Integer
        annotationVisitor.visit(elementName, (byte) readInt(cpInfoOffsets[readUnsignedShort(currentOffset)]));
        currentOffset += 2;
        break;
      case 'C': // const_value_index, CONSTANT_Integer
        annotationVisitor.visit(elementName, (char) readInt(cpInfoOffsets[readUnsignedShort(currentOffset)]));
        currentOffset += 2;
        break;
      case 'D': // const_value_index, CONSTANT_Double
      case 'F': // const_value_index, CONSTANT_Float
      case 'I': // const_value_index, CONSTANT_Integer
      case 'J': // const_value_index, CONSTANT_Long
        annotationVisitor.visit(elementName, readConst(readUnsignedShort(currentOffset), charBuffer));
        currentOffset += 2;
        break;
      case 'S': // const_value_index, CONSTANT_Integer
        annotationVisitor.visit(elementName, (short) readInt(cpInfoOffsets[readUnsignedShort(currentOffset)]));
        currentOffset += 2;
        break;

      case 'Z': // const_value_index, CONSTANT_Integer
        annotationVisitor.visit(elementName, readInt(cpInfoOffsets[readUnsignedShort(currentOffset)]) == 0 ? Boolean.FALSE : Boolean.TRUE);
        currentOffset += 2;
        break;
      case 's': // const_value_index, CONSTANT_Utf8
        annotationVisitor.visit(elementName, readUTF8(currentOffset, charBuffer));
        currentOffset += 2;
        break;
      case 'e': // enum_const_value
        annotationVisitor.visitEnum(elementName, readUTF8(currentOffset, charBuffer), readUTF8(currentOffset + 2, charBuffer));
        currentOffset += 4;
        break;
      case 'c': // class_info
        annotationVisitor.visit(elementName, Type.getType(readUTF8(currentOffset, charBuffer)));
        currentOffset += 2;
        break;
      case '@': // annotation_value
        currentOffset = readElementValues(null, currentOffset + 2, true, charBuffer);
        break;
      case '[': // array_value
        int numValues = readUnsignedShort(currentOffset);
        currentOffset += 2;
        if (numValues == 0) {
          return readElementValues(null, currentOffset - 2, false, charBuffer);
        }
        switch (b[currentOffset] & 0xFF) {
          case 'B':
            byte[] byteValues = new byte[numValues];
            for (int i = 0; i < numValues; i++) {
              byteValues[i] = (byte) readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]);
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, byteValues);
            break;
          case 'Z':
            boolean[] booleanValues = new boolean[numValues];
            for (int i = 0; i < numValues; i++) {
              booleanValues[i] = readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]) != 0;
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, booleanValues);
            break;
          case 'S':
            short[] shortValues = new short[numValues];
            for (int i = 0; i < numValues; i++) {
              shortValues[i] = (short) readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]);
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, shortValues);
            break;
          case 'C':
            char[] charValues = new char[numValues];
            for (int i = 0; i < numValues; i++) {
              charValues[i] = (char) readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]);
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, charValues);
            break;
          case 'I':
            int[] intValues = new int[numValues];
            for (int i = 0; i < numValues; i++) {
              intValues[i] = readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]);
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, intValues);
            break;
          case 'J':
            long[] longValues = new long[numValues];
            for (int i = 0; i < numValues; i++) {
              longValues[i] = readLong(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]);
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, longValues);
            break;
          case 'F':
            float[] floatValues = new float[numValues];
            for (int i = 0; i < numValues; i++) {
              floatValues[i] = Float.intBitsToFloat(readInt(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]));
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, floatValues);
            break;
          case 'D':
            double[] doubleValues = new double[numValues];
            for (int i = 0; i < numValues; i++) {
              doubleValues[i] = Double.longBitsToDouble(readLong(cpInfoOffsets[readUnsignedShort(currentOffset + 1)]));
              currentOffset += 3;
            }
            annotationVisitor.visit(elementName, doubleValues);
            break;
          default:
            currentOffset = readElementValues(null, currentOffset - 2, false, charBuffer);
            break;
        }
        break;
      default:
        throw new IllegalArgumentException();
    }
    return currentOffset;
  }

  void computeImplicitFrame(Context context) {
    String methodDescriptor = context.currentMethodDescriptor;
    Object[] locals = context.currentFrameLocalTypes;
    int numLocal = 0;
    if ((context.currentMethodAccessFlags & Opcodes.ACC_STATIC) == 0) {
      if ("<init>".equals(context.currentMethodName)) {
        locals[numLocal++] = Opcodes.UNINITIALIZED_THIS;
      } else {
        locals[numLocal++] = readClass(header + 2, context.charBuffer);
      }
    }
    // Parse the method descriptor, one argument type descriptor at each iteration. Start by
    // skipping the first method descriptor character, which is always '('.
    int currentMethodDescritorOffset = 1;
    while (true) {
      int currentArgumentDescriptorStartOffset = currentMethodDescritorOffset;
      switch (methodDescriptor.charAt(currentMethodDescritorOffset++)) {
        case 'Z':
        case 'C':
        case 'B':
        case 'S':
        case 'I':
          locals[numLocal++] = Opcodes.INTEGER;
          break;
        case 'F':
          locals[numLocal++] = Opcodes.FLOAT;
          break;
        case 'J':
          locals[numLocal++] = Opcodes.LONG;
          break;
        case 'D':
          locals[numLocal++] = Opcodes.DOUBLE;
          break;
        case '[':
          while (methodDescriptor.charAt(currentMethodDescritorOffset) == '[') {
            ++currentMethodDescritorOffset;
          }
          if (methodDescriptor.charAt(currentMethodDescritorOffset) == 'L') {
            ++currentMethodDescritorOffset;
            while (methodDescriptor.charAt(currentMethodDescritorOffset) != ';') {
              ++currentMethodDescritorOffset;
            }
          }
          locals[numLocal++] = methodDescriptor.substring(currentArgumentDescriptorStartOffset,
                  ++currentMethodDescritorOffset);
          break;
        case 'L':
          while (methodDescriptor.charAt(currentMethodDescritorOffset) != ';') {
            ++currentMethodDescritorOffset;
          }
          locals[numLocal++] = methodDescriptor.substring(currentArgumentDescriptorStartOffset + 1,
                  currentMethodDescritorOffset++);
          break;
        default:
          context.currentFrameLocalCount = numLocal;
          return;
      }
    }
  }

  int readStackMapFrame(int stackMapFrameOffset, boolean compressed, boolean expand, Context context) {
    int currentOffset = stackMapFrameOffset;
    char[] charBuffer = context.charBuffer;
    Label[] labels = context.currentMethodLabels;
    int frameType;
    if (compressed) {
      // Read the frame_type field.
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
        int local = expand ? context.currentFrameLocalCount : 0;
        for (int k = frameType - Frame.SAME_FRAME_EXTENDED; k > 0; k--) {
          currentOffset = readVerificationTypeInfo(currentOffset, context.currentFrameLocalTypes, local++, charBuffer,
                  labels);
        }
        context.currentFrameType = Opcodes.F_APPEND;
        context.currentFrameLocalCountDelta = frameType - Frame.SAME_FRAME_EXTENDED;
        context.currentFrameLocalCount += context.currentFrameLocalCountDelta;
        context.currentFrameStackCount = 0;
      } else {
        int numberOfLocals = readUnsignedShort(currentOffset);
        currentOffset += 2;
        context.currentFrameType = Opcodes.F_FULL;
        context.currentFrameLocalCountDelta = numberOfLocals;
        context.currentFrameLocalCount = numberOfLocals;
        for (int local = 0; local < numberOfLocals; ++local) {
          currentOffset = readVerificationTypeInfo(currentOffset, context.currentFrameLocalTypes, local, charBuffer,
                  labels);
        }
        int numberOfStackItems = readUnsignedShort(currentOffset);
        currentOffset += 2;
        context.currentFrameStackCount = numberOfStackItems;
        for (int stack = 0; stack < numberOfStackItems; ++stack) {
          currentOffset = readVerificationTypeInfo(currentOffset, context.currentFrameStackTypes, stack, charBuffer,
                  labels);
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
    int currentOffset = verificationTypeInfoOffset;
    int tag = b[currentOffset++] & 0xFF;
    switch (tag) {
      case Frame.ITEM_TOP:
        frame[index] = Opcodes.TOP;
        break;
      case Frame.ITEM_INTEGER:
        frame[index] = Opcodes.INTEGER;
        break;
      case Frame.ITEM_FLOAT:
        frame[index] = Opcodes.FLOAT;
        break;
      case Frame.ITEM_DOUBLE:
        frame[index] = Opcodes.DOUBLE;
        break;
      case Frame.ITEM_LONG:
        frame[index] = Opcodes.LONG;
        break;
      case Frame.ITEM_NULL:
        frame[index] = Opcodes.NULL;
        break;
      case Frame.ITEM_UNINITIALIZED_THIS:
        frame[index] = Opcodes.UNINITIALIZED_THIS;
        break;
      case Frame.ITEM_OBJECT:
        frame[index] = readClass(currentOffset, charBuffer);
        currentOffset += 2;
        break;
      case Frame.ITEM_UNINITIALIZED:
        frame[index] = createLabel(readUnsignedShort(currentOffset), labels);
        currentOffset += 2;
        break;
      default:
        throw new IllegalArgumentException();
    }
    return currentOffset;
  }

  int getFirstAttributeOffset() {
    // Skip the access_flags, this_class, super_class, and interfaces_count fields (using 2 bytes
    // each), as well as the interfaces array field (2 bytes per interface).
    int currentOffset = header + 8 + readUnsignedShort(header + 6) * 2;

    // Read the fields_count field.
    int fieldsCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    // Skip the 'fields' array field.
    while (fieldsCount-- > 0) {
      // Invariant: currentOffset is the offset of a field_info structure.
      // Skip the access_flags, name_index and descriptor_index fields (2 bytes each), and read the
      // attributes_count field.
      int attributesCount = readUnsignedShort(currentOffset + 6);
      currentOffset += 8;
      // Skip the 'attributes' array field.
      while (attributesCount-- > 0) {
        // Invariant: currentOffset is the offset of an attribute_info structure.
        // Read the attribute_length field (2 bytes after the start of the attribute_info) and skip
        // this many bytes, plus 6 for the attribute_name_index and attribute_length fields
        // (yielding the total size of the attribute_info structure).
        currentOffset += 6 + readInt(currentOffset + 2);
      }
    }

    // Skip the methods_count and 'methods' fields, using the same method as above.
    int methodsCount = readUnsignedShort(currentOffset);
    currentOffset += 2;
    while (methodsCount-- > 0) {
      int attributesCount = readUnsignedShort(currentOffset + 6);
      currentOffset += 8;
      while (attributesCount-- > 0) {
        currentOffset += 6 + readInt(currentOffset + 2);
      }
    }

    // Skip the ClassFile's attributes_count field.
    return currentOffset + 2;
  }

  int[] readBootstrapMethodsAttribute(int maxStringLength) {
    char[] charBuffer = new char[maxStringLength];
    int currentAttributeOffset = getFirstAttributeOffset();
    int[] currentBootstrapMethodOffsets = null;
    for (int i = readUnsignedShort(currentAttributeOffset - 2); i > 0; --i) {
      // Read the attribute_info's attribute_name and attribute_length fields.
      String attributeName = readUTF8(currentAttributeOffset, charBuffer);
      int attributeLength = readInt(currentAttributeOffset + 2);
      currentAttributeOffset += 6;
      if (Constants.BOOTSTRAP_METHODS.equals(attributeName)) {
        // Read the num_bootstrap_methods field and create an array of this size.
        currentBootstrapMethodOffsets = new int[readUnsignedShort(currentAttributeOffset)];
        // Compute and store the offset of each 'bootstrap_methods' array field entry.
        int currentBootstrapMethodOffset = currentAttributeOffset + 2;
        for (int j = 0; j < currentBootstrapMethodOffsets.length; ++j) {
          currentBootstrapMethodOffsets[j] = currentBootstrapMethodOffset;
          // Skip the bootstrap_method_ref and num_bootstrap_arguments fields (2 bytes each),
          // as well as the bootstrap_arguments array field (of size num_bootstrap_arguments * 2).
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

  int readUnsignedShort(int offset) {
    byte[] classFileBuffer = b;
    return ((classFileBuffer[offset] & 0xFF) << 8) | (classFileBuffer[offset + 1] & 0xFF);
  }

  short readShort(int offset) {
    byte[] classFileBuffer = b;
    return (short) (((classFileBuffer[offset] & 0xFF) << 8) | (classFileBuffer[offset + 1] & 0xFF));
  }

  int readInt(int offset) {
    byte[] classFileBuffer = b;
    return ((classFileBuffer[offset] & 0xFF) << 24) | ((classFileBuffer[offset + 1] & 0xFF) << 16)
            | ((classFileBuffer[offset + 2] & 0xFF) << 8) | (classFileBuffer[offset + 3] & 0xFF);
  }

  long readLong(int offset) {
    long l1 = readInt(offset);
    long l0 = readInt(offset + 4) & 0xFFFFFFFFL;
    return (l1 << 32) | l0;
  }

  // DontCheck(AbbreviationAsWordInName): can't be renamed (for backward binary compatibility).
  String readUTF8(int offset, char[] charBuffer) {
    int constantPoolEntryIndex = readUnsignedShort(offset);
    if (offset == 0 || constantPoolEntryIndex == 0) {
      return null;
    }
    return readUtf(constantPoolEntryIndex, charBuffer);
  }

  String readUtf(int constantPoolEntryIndex, char[] charBuffer) {
    String value = constantUtf8Values[constantPoolEntryIndex];
    if (value != null) {
      return value;
    }
    int cpInfoOffset = cpInfoOffsets[constantPoolEntryIndex];
    return constantUtf8Values[constantPoolEntryIndex] = readUtf(cpInfoOffset + 2, readUnsignedShort(cpInfoOffset),
            charBuffer);
  }

  String readUtf(int utfOffset, int utfLength, char[] charBuffer) {
    int currentOffset = utfOffset;
    int endOffset = currentOffset + utfLength;
    int strLength = 0;
    byte[] classFileBuffer = b;
    while (currentOffset < endOffset) {
      int currentByte = classFileBuffer[currentOffset++];
      if ((currentByte & 0x80) == 0) {
        charBuffer[strLength++] = (char) (currentByte & 0x7F);
      } else if ((currentByte & 0xE0) == 0xC0) {
        charBuffer[strLength++] = (char) (((currentByte & 0x1F) << 6) + (classFileBuffer[currentOffset++] & 0x3F));
      } else {
        charBuffer[strLength++] = (char) (((currentByte & 0xF) << 12) + ((classFileBuffer[currentOffset++] & 0x3F) << 6)
                + (classFileBuffer[currentOffset++] & 0x3F));
      }
    }
    return new String(charBuffer, 0, strLength);
  }

  String readStringish(int offset, char[] charBuffer) {
    // Get the start offset of the cp_info structure (plus one), and read the CONSTANT_Utf8 entry
    // designated by the first two bytes of this cp_info.
    return readUTF8(cpInfoOffsets[readUnsignedShort(offset)], charBuffer);
  }

  String readClass(int offset, char[] charBuffer) {
    return readStringish(offset, charBuffer);
  }

  Object readConst(int constantPoolEntryIndex, char[] charBuffer) {
    int cpInfoOffset = cpInfoOffsets[constantPoolEntryIndex];
    switch (b[cpInfoOffset - 1]) {
      case Symbol.CONSTANT_INTEGER_TAG:
        return readInt(cpInfoOffset);
      case Symbol.CONSTANT_FLOAT_TAG:
        return Float.intBitsToFloat(readInt(cpInfoOffset));
      case Symbol.CONSTANT_LONG_TAG:
        return readLong(cpInfoOffset);
      case Symbol.CONSTANT_DOUBLE_TAG:
        return Double.longBitsToDouble(readLong(cpInfoOffset));
      case Symbol.CONSTANT_CLASS_TAG:
        return Type.getObjectType(readUTF8(cpInfoOffset, charBuffer));
      case Symbol.CONSTANT_STRING_TAG:
        return readUTF8(cpInfoOffset, charBuffer);
      case Symbol.CONSTANT_METHOD_TYPE_TAG:
        return Type.getMethodType(readUTF8(cpInfoOffset, charBuffer));
      case Symbol.CONSTANT_METHOD_HANDLE_TAG:
        int referenceKind = readByte(cpInfoOffset);
        int referenceCpInfoOffset = cpInfoOffsets[readUnsignedShort(cpInfoOffset + 1)];
        int nameAndTypeCpInfoOffset = cpInfoOffsets[readUnsignedShort(referenceCpInfoOffset + 2)];
        String owner = readClass(referenceCpInfoOffset, charBuffer);
        String name = readUTF8(nameAndTypeCpInfoOffset, charBuffer);
        String descriptor = readUTF8(nameAndTypeCpInfoOffset + 2, charBuffer);
        boolean isInterface = b[referenceCpInfoOffset - 1] == Symbol.CONSTANT_INTERFACE_METHODREF_TAG;
        return new Handle(referenceKind, owner, name, descriptor, isInterface);
      default:
        throw new IllegalArgumentException();
    }
  }
}
