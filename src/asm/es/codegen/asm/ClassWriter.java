package es.codegen.asm;

public class ClassWriter extends ClassVisitor {

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
  int signatureIndex;
  int sourceFileIndex;

  public ClassWriter() {
    super(null);
    symbolTable = new SymbolTable(this);
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
      for (var i = 0; i < interfaceCount; ++i) {
        this.interfaces[i] = symbolTable.addConstantClass(interfaces[i]).index;
      }
    }
  }

  @Override
  public void visitSource(String file, String debug) {
    if (file != null) {
      sourceFileIndex = symbolTable.addConstantUtf8(file);
    }
  }

  @Override
  public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
    throw new UnsupportedOperationException();
  }

  @Override
  public FieldVisitor visitField(int access, String name, String descriptor, String signature, Object value) {
    var fieldWriter = new FieldWriter(symbolTable, access, name, descriptor, signature, value);
    if (firstField == null) {
      firstField = fieldWriter;
    } else {
      lastField.fv = fieldWriter;
    }
    return lastField = fieldWriter;
  }

  @Override
  public MethodVisitor visitMethod(int access, String name, String descriptor, String signature, String[] exceptions) {
    var methodWriter = new MethodWriter(symbolTable, access, name, descriptor, signature, exceptions); // MethodWriter.COMPUTE_ALL_FRAMES
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
    var size = 24 + 2 * interfaceCount;
    var fieldsCount = 0;
    var fieldWriter = firstField;
    while (fieldWriter != null) {
      ++fieldsCount;
      size += fieldWriter.computeFieldInfoSize();
      fieldWriter = (FieldWriter) fieldWriter.fv;
    }
    var methodsCount = 0;
    var methodWriter = firstMethod;
    while (methodWriter != null) {
      ++methodsCount;
      size += methodWriter.computeMethodInfoSize();
      methodWriter = (MethodWriter) methodWriter.mv;
    }
    var attributesCount = 0;
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
    if (symbolTable.computeBootstrapMethodsSize() > 0) {
      ++attributesCount;
      size += symbolTable.computeBootstrapMethodsSize();
    }
    size += symbolTable.getConstantPoolLength();
    var constantPoolCount = symbolTable.getConstantPoolCount();
    if (constantPoolCount > 0xFFFF) {
      throw new IndexOutOfBoundsException("Class too large: " + symbolTable.getClassName());
    }
    var result = new ByteVector(size);
    result.putInt(0xCAFEBABE).putInt(version);
    symbolTable.putConstantPool(result);
    var mask = 0; // version >= 1.5
    result.putShort(accessFlags & ~mask).putShort(thisClass).putShort(superClass);
    result.putShort(interfaceCount);
    for (var i = 0; i < interfaceCount; ++i) {
      result.putShort(interfaces[i]);
    }
    result.putShort(fieldsCount);
    fieldWriter = firstField;
    while (fieldWriter != null) {
      fieldWriter.putFieldInfo(result);
      fieldWriter = (FieldWriter) fieldWriter.fv;
    }
    result.putShort(methodsCount);
    methodWriter = firstMethod;
    while (methodWriter != null) {
      methodWriter.putMethodInfo(result);
      methodWriter = (MethodWriter) methodWriter.mv;
    }
    result.putShort(attributesCount);
    if (signatureIndex != 0) {
      result.putShort(symbolTable.addConstantUtf8(Constants.SIGNATURE)).putInt(2).putShort(signatureIndex);
    }
    if (sourceFileIndex != 0) {
      result.putShort(symbolTable.addConstantUtf8(Constants.SOURCE_FILE)).putInt(2).putShort(sourceFileIndex);
    }
    symbolTable.putBootstrapMethods(result);
    return result.data;
  }

  int newConst(Object value) {
    return symbolTable.addConstant(value).index;
  }

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
    return symbolTable.addConstantInvokeDynamic(name, descriptor, bootstrapMethodHandle, bootstrapMethodArguments).index;
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
    var classLoader = getClass().getClassLoader();;
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
}
