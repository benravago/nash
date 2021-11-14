package es.codegen.asm;

public class ClassWriter extends ClassVisitor {

  public static final int COMPUTE_MAXS = 1;
  public static final int COMPUTE_FRAMES = 2;

  int version;
  final SymbolTable symbolTable;
  int accessFlags;
  int thisClass;
  int superClass;
  int interfaceCount;
  int[] interfaces;
  FieldWriter firstField;
  FieldWriter lastField;
  MethodWriter firstMethod;
  MethodWriter lastMethod;
  int numberOfInnerClasses;
  ByteVector innerClasses;
  int enclosingClassIndex;
  int enclosingMethodIndex;
  int signatureIndex;
  int sourceFileIndex;
  ByteVector debugExtension;
  int nestHostClassIndex;
  int numberOfNestMemberClasses;
  ByteVector nestMemberClasses;
  Attribute firstAttribute;
  int compute;

  public ClassWriter(int flags) {
    this(null, flags);
  }

  ClassWriter(ClassReader classReader, int flags) {
    super(null);
    symbolTable = classReader == null ? new SymbolTable(this) : new SymbolTable(this, classReader);
    if ((flags & COMPUTE_FRAMES) != 0) {
      this.compute = MethodWriter.COMPUTE_ALL_FRAMES;
    } else if ((flags & COMPUTE_MAXS) != 0) {
      this.compute = MethodWriter.COMPUTE_MAX_STACK_AND_LOCAL;
    } else {
      this.compute = MethodWriter.COMPUTE_NOTHING;
    }
  }

  //int V1_7 = 0 << 16 | 51;
  static final int V1_8 = 0 << 16 | 52;
  
  @Override
  public void visit(int access, String name, String signature, String superName, String[] interfaces) {
    this.version = V1_8;
    this.accessFlags = access;
    this.thisClass = symbolTable.setMajorVersionAndClassName(version & 0xFFFF, name);
    if (signature != null) {
      this.signatureIndex = symbolTable.addConstantUtf8(signature);
    }
    this.superClass = superName == null ? 0 : symbolTable.addConstantClass(superName).index;
    if (interfaces != null && interfaces.length > 0) {
      interfaceCount = interfaces.length;
      this.interfaces = new int[interfaceCount];
      for (int i = 0; i < interfaceCount; ++i) {
        this.interfaces[i] = symbolTable.addConstantClass(interfaces[i]).index;
      }
    }
    if (compute == MethodWriter.COMPUTE_MAX_STACK_AND_LOCAL) {
      compute = MethodWriter.COMPUTE_MAX_STACK_AND_LOCAL_FROM_FRAMES;
    }
  }

  @Override
  public void visitSource(String file, String debug) {
    if (file != null) {
      sourceFileIndex = symbolTable.addConstantUtf8(file);
    }
    if (debug != null) {
      debugExtension = new ByteVector().encodeUtf8(debug, 0, Integer.MAX_VALUE);
    }
  }

  @Override
  void visitNestHost(String nestHost) {
    nestHostClassIndex = symbolTable.addConstantClass(nestHost).index;
  }

  @Override
  void visitOuterClass(String owner, String name, String descriptor) {
    enclosingClassIndex = symbolTable.addConstantClass(owner).index;
    if (name != null && descriptor != null) {
      enclosingMethodIndex = symbolTable.addConstantNameAndType(name, descriptor);
    }
  }

  @Override
  public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
    throw new UnsupportedOperationException();
  }

  @Override
  AnnotationVisitor visitTypeAnnotation(int typeRef, TypePath typePath, String descriptor, boolean visible) {
    throw new UnsupportedOperationException();
  }

  @Override
  void visitAttribute(Attribute attribute) {
    // Store the attributes in the <i>reverse</i> order of their visit by this method.
    attribute.nextAttribute = firstAttribute;
    firstAttribute = attribute;
  }

  @Override
  void visitNestMember(String nestMember) {
    if (nestMemberClasses == null) {
      nestMemberClasses = new ByteVector();
    }
    ++numberOfNestMemberClasses;
    nestMemberClasses.putShort(symbolTable.addConstantClass(nestMember).index);
  }

  @Override
  void visitInnerClass(String name, String outerName, String innerName, int access) {
    if (innerClasses == null) {
      innerClasses = new ByteVector();
    }
    // Section 4.7.6 of the JVMS states "Every CONSTANT_Class_info entry in the constant_pool table
    // which represents a class or interface C that is not a package member must have exactly one
    // corresponding entry in the classes array". To avoid duplicates we keep track in the info
    // field of the Symbol of each CONSTANT_Class_info entry C whether an inner class entry has
    // already been added for C. If so, we store the index of this inner class entry (plus one) in
    // the info field. This trick allows duplicate detection in O(1) time.
    Symbol nameSymbol = symbolTable.addConstantClass(name);
    if (nameSymbol.info == 0) {
      ++numberOfInnerClasses;
      innerClasses.putShort(nameSymbol.index);
      innerClasses.putShort(outerName == null ? 0 : symbolTable.addConstantClass(outerName).index);
      innerClasses.putShort(innerName == null ? 0 : symbolTable.addConstantUtf8(innerName));
      innerClasses.putShort(access);
      nameSymbol.info = numberOfInnerClasses;
    }
    // Else, compare the inner classes entry nameSymbol.info - 1 with the arguments of this method
    // and throw an exception if there is a difference?
  }

  @Override
  public FieldVisitor visitField(int access, String name, String descriptor, String signature, Object value) {
    FieldWriter fieldWriter = new FieldWriter(symbolTable, access, name, descriptor, signature, value);
    if (firstField == null) {
      firstField = fieldWriter;
    } else {
      lastField.fv = fieldWriter;
    }
    return lastField = fieldWriter;
  }

  @Override
  public MethodVisitor visitMethod(int access, String name, String descriptor, String signature, String[] exceptions) {
    MethodWriter methodWriter = new MethodWriter(symbolTable, access, name, descriptor, signature, exceptions, compute);
    if (firstMethod == null) {
      firstMethod = methodWriter;
    } else {
      lastMethod.mv = methodWriter;
    }
    return lastMethod = methodWriter;
  }

  @Override
  public void visitEnd() {
    // Nothing to do.
  }

  public byte[] toByteArray() {
    // First step: compute the size in bytes of the ClassFile structure.
    // The magic field uses 4 bytes, 10 mandatory fields (minor_version, major_version,
    // constant_pool_count, access_flags, this_class, super_class, interfaces_count, fields_count,
    // methods_count and attributes_count) use 2 bytes each, and each interface uses 2 bytes too.
    int size = 24 + 2 * interfaceCount;
    int fieldsCount = 0;
    FieldWriter fieldWriter = firstField;
    while (fieldWriter != null) {
      ++fieldsCount;
      size += fieldWriter.computeFieldInfoSize();
      fieldWriter = (FieldWriter) fieldWriter.fv;
    }
    int methodsCount = 0;
    MethodWriter methodWriter = firstMethod;
    while (methodWriter != null) {
      ++methodsCount;
      size += methodWriter.computeMethodInfoSize();
      methodWriter = (MethodWriter) methodWriter.mv;
    }
    // For ease of reference, we use here the same attribute order as in Section 4.7 of the JVMS.
    int attributesCount = 0;
    if (innerClasses != null) {
      ++attributesCount;
      size += 8 + innerClasses.length;
      symbolTable.addConstantUtf8(Constants.INNER_CLASSES);
    }
    if (enclosingClassIndex != 0) {
      ++attributesCount;
      size += 10;
      symbolTable.addConstantUtf8(Constants.ENCLOSING_METHOD);
    }
    if (signatureIndex != 0) {
      ++attributesCount;
      size += 8;
      symbolTable.addConstantUtf8(Constants.SIGNATURE);
    }
    if (sourceFileIndex != 0) {
      ++attributesCount;
      size += 8;
      symbolTable.addConstantUtf8(Constants.SOURCE_FILE);
    }
    if (debugExtension != null) {
      ++attributesCount;
      size += 6 + debugExtension.length;
      symbolTable.addConstantUtf8(Constants.SOURCE_DEBUG_EXTENSION);
    }
    if ((accessFlags & Opcodes.ACC_DEPRECATED) != 0) {
      ++attributesCount;
      size += 6;
      symbolTable.addConstantUtf8(Constants.DEPRECATED);
    }
    if (symbolTable.computeBootstrapMethodsSize() > 0) {
      ++attributesCount;
      size += symbolTable.computeBootstrapMethodsSize();
    }
    if (nestHostClassIndex != 0) {
      ++attributesCount;
      size += 8;
      symbolTable.addConstantUtf8(Constants.NEST_HOST);
    }
    if (nestMemberClasses != null) {
      ++attributesCount;
      size += 8 + nestMemberClasses.length;
      symbolTable.addConstantUtf8(Constants.NEST_MEMBERS);
    }
    if (firstAttribute != null) {
      attributesCount += firstAttribute.getAttributeCount();
      size += firstAttribute.computeAttributesSize(symbolTable);
    }
    // IMPORTANT: this must be the last part of the ClassFile size computation, because the previous
    // statements can add attribute names to the constant pool, thereby changing its size!
    size += symbolTable.getConstantPoolLength();
    int constantPoolCount = symbolTable.getConstantPoolCount();
    if (constantPoolCount > 0xFFFF) {
      throw new IndexOutOfBoundsException("Class too large: " + symbolTable.getClassName());
    }

    // Second step: allocate a ByteVector of the correct size (in order to avoid any array copy in
    // dynamic resizes) and fill it with the ClassFile content.
    ByteVector result = new ByteVector(size);
    result.putInt(0xCAFEBABE).putInt(version);
    symbolTable.putConstantPool(result);
    int mask = 0; // version >= 1.5
    result.putShort(accessFlags & ~mask).putShort(thisClass).putShort(superClass);
    result.putShort(interfaceCount);
    for (int i = 0; i < interfaceCount; ++i) {
      result.putShort(interfaces[i]);
    }
    result.putShort(fieldsCount);
    fieldWriter = firstField;
    while (fieldWriter != null) {
      fieldWriter.putFieldInfo(result);
      fieldWriter = (FieldWriter) fieldWriter.fv;
    }
    result.putShort(methodsCount);
    boolean hasFrames = false;
    boolean hasAsmInstructions = false;
    methodWriter = firstMethod;
    while (methodWriter != null) {
      hasFrames |= methodWriter.hasFrames();
      hasAsmInstructions |= methodWriter.hasAsmInstructions();
      methodWriter.putMethodInfo(result);
      methodWriter = (MethodWriter) methodWriter.mv;
    }
    // For ease of reference, we use here the same attribute order as in Section 4.7 of the JVMS.
    result.putShort(attributesCount);
    if (innerClasses != null) {
      result.putShort(symbolTable.addConstantUtf8(Constants.INNER_CLASSES)).putInt(innerClasses.length + 2)
              .putShort(numberOfInnerClasses).putByteArray(innerClasses.data, 0, innerClasses.length);
    }
    if (enclosingClassIndex != 0) {
      result.putShort(symbolTable.addConstantUtf8(Constants.ENCLOSING_METHOD)).putInt(4).putShort(enclosingClassIndex)
              .putShort(enclosingMethodIndex);
    }
    if (signatureIndex != 0) {
      result.putShort(symbolTable.addConstantUtf8(Constants.SIGNATURE)).putInt(2).putShort(signatureIndex);
    }
    if (sourceFileIndex != 0) {
      result.putShort(symbolTable.addConstantUtf8(Constants.SOURCE_FILE)).putInt(2).putShort(sourceFileIndex);
    }
    if (debugExtension != null) {
      int length = debugExtension.length;
      result.putShort(symbolTable.addConstantUtf8(Constants.SOURCE_DEBUG_EXTENSION)).putInt(length)
              .putByteArray(debugExtension.data, 0, length);
    }
    if ((accessFlags & Opcodes.ACC_DEPRECATED) != 0) {
      result.putShort(symbolTable.addConstantUtf8(Constants.DEPRECATED)).putInt(0);
    }
    symbolTable.putBootstrapMethods(result);
    if (nestHostClassIndex != 0) {
      result.putShort(symbolTable.addConstantUtf8(Constants.NEST_HOST)).putInt(2).putShort(nestHostClassIndex);
    }
    if (nestMemberClasses != null) {
      result.putShort(symbolTable.addConstantUtf8(Constants.NEST_MEMBERS)).putInt(nestMemberClasses.length + 2)
              .putShort(numberOfNestMemberClasses).putByteArray(nestMemberClasses.data, 0, nestMemberClasses.length);
    }
    if (firstAttribute != null) {
      firstAttribute.putAttributes(symbolTable, result);
    }

    // Third step: replace the ASM specific instructions, if any.
    if (hasAsmInstructions) {
      return replaceAsmInstructions(result.data, hasFrames);
    } else {
      return result.data;
    }
  }

  byte[] replaceAsmInstructions(byte[] classFile, boolean hasFrames) {
    Attribute[] attributes = getAttributePrototypes();
    firstField = null;
    lastField = null;
    firstMethod = null;
    lastMethod = null;
    nestHostClassIndex = 0;
    numberOfNestMemberClasses = 0;
    nestMemberClasses = null;
    firstAttribute = null;
    compute = hasFrames ? MethodWriter.COMPUTE_INSERTED_FRAMES : MethodWriter.COMPUTE_NOTHING;
    new ClassReader(classFile, 0, false).accept(this, attributes,
            (hasFrames ? ClassReader.EXPAND_FRAMES : 0) | ClassReader.EXPAND_ASM_INSNS);
    return toByteArray();
  }

  Attribute[] getAttributePrototypes() {
    Attribute.Set attributePrototypes = new Attribute.Set();
    attributePrototypes.addAttributes(firstAttribute);
    FieldWriter fieldWriter = firstField;
    while (fieldWriter != null) {
      fieldWriter.collectAttributePrototypes(attributePrototypes);
      fieldWriter = (FieldWriter) fieldWriter.fv;
    }
    MethodWriter methodWriter = firstMethod;
    while (methodWriter != null) {
      methodWriter.collectAttributePrototypes(attributePrototypes);
      methodWriter = (MethodWriter) methodWriter.mv;
    }
    return attributePrototypes.toArray();
  }

  int newConst(Object value) {
    return symbolTable.addConstant(value).index;
  }

  // DontCheck(AbbreviationAsWordInName): can't be renamed (for backward binary compatibility).
  int newUTF8(String value) {
    return symbolTable.addConstantUtf8(value);
  }

  int newClass(String value) {
    return symbolTable.addConstantClass(value).index;
  }

  int newMethodType(String methodDescriptor) {
    return symbolTable.addConstantMethodType(methodDescriptor).index;
  }

  int newModule(String moduleName) {
    return symbolTable.addConstantModule(moduleName).index;
  }

  int newPackage(String packageName) {
    return symbolTable.addConstantPackage(packageName).index;
  }

  int newHandle(int tag, String owner, String name, String descriptor, boolean isInterface) {
    return symbolTable.addConstantMethodHandle(tag, owner, name, descriptor, isInterface).index;
  }

  int newConstantDynamic(String name, String descriptor, Handle bootstrapMethodHandle, Object... bootstrapMethodArguments) {
    return symbolTable.addConstantDynamic(name, descriptor, bootstrapMethodHandle, bootstrapMethodArguments).index;
  }

  int newInvokeDynamic(String name, String descriptor, Handle bootstrapMethodHandle, Object... bootstrapMethodArguments) {
    return symbolTable.addConstantInvokeDynamic(name, descriptor, bootstrapMethodHandle,
            bootstrapMethodArguments).index;
  }

  int newField(String owner, String name, String descriptor) {
    return symbolTable.addConstantFieldref(owner, name, descriptor).index;
  }

  int newMethod(String owner, String name, String descriptor, boolean isInterface) {
    return symbolTable.addConstantMethodref(owner, name, descriptor, isInterface).index;
  }

  int newNameType(String name, String descriptor) {
    return symbolTable.addConstantNameAndType(name, descriptor);
  }

  protected String getCommonSuperClass(String type1, String type2) {
    ClassLoader classLoader = getClassLoader();
    Class<?> class1;
    try {
      class1 = Class.forName(type1.replace('/', '.'), false, classLoader);
    } catch (ClassNotFoundException e) {
      throw new TypeNotPresentException(type1, e);
    }
    Class<?> class2;
    try {
      class2 = Class.forName(type2.replace('/', '.'), false, classLoader);
    } catch (ClassNotFoundException e) {
      throw new TypeNotPresentException(type2, e);
    }
    if (class1.isAssignableFrom(class2)) {
      return type1;
    }
    if (class2.isAssignableFrom(class1)) {
      return type2;
    }
    if (class1.isInterface() || class2.isInterface()) {
      return "java/lang/Object";
    } else {
      do {
        class1 = class1.getSuperclass();
      } while (!class1.isAssignableFrom(class2));
      return class1.getName().replace('.', '/');
    }
  }

  ClassLoader getClassLoader() {
    return getClass().getClassLoader();
  }
}
