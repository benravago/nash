package es.codegen.asm;

class FieldWriter extends FieldVisitor {

  final SymbolTable symbolTable;
  final int accessFlags;
  final int nameIndex;
  final int descriptorIndex;
  int signatureIndex;
  int constantValueIndex;
  Attribute firstAttribute;

  FieldWriter(SymbolTable symbolTable, int access, String name, String descriptor, String signature, Object constantValue) {
    super(null);
    this.symbolTable = symbolTable;
    this.accessFlags = access;
    this.nameIndex = symbolTable.addConstantUtf8(name);
    this.descriptorIndex = symbolTable.addConstantUtf8(descriptor);
    if (signature != null) {
      this.signatureIndex = symbolTable.addConstantUtf8(signature);
    }
    if (constantValue != null) {
      this.constantValueIndex = symbolTable.addConstant(constantValue).index;
    }
  }

  @Override
  public void visitAttribute(Attribute attribute) {
    // Store the attributes in the <i>reverse</i> order of their visit by this method.
    attribute.nextAttribute = firstAttribute;
    firstAttribute = attribute;
  }

  @Override
  public void visitEnd() {
    // Nothing to do.
  }

  int computeFieldInfoSize() {
    // The access_flags, name_index, descriptor_index and attributes_count fields use 8 bytes.
    int size = 8;
    // For ease of reference, we use here the same attribute order as in Section 4.7 of the JVMS.
    if (constantValueIndex != 0) {
      // ConstantValue attributes always use 8 bytes.
      symbolTable.addConstantUtf8(Constants.CONSTANT_VALUE);
      size += 8;
    }
    if (signatureIndex != 0) {
      // Signature attributes always use 8 bytes.
      symbolTable.addConstantUtf8(Constants.SIGNATURE);
      size += 8;
    }
    // ACC_DEPRECATED is ASM specific, the ClassFile format uses a Deprecated attribute instead.
    if ((accessFlags & Opcodes.ACC_DEPRECATED) != 0) {
      // Deprecated attributes always use 6 bytes.
      symbolTable.addConstantUtf8(Constants.DEPRECATED);
      size += 6;
    }
    if (firstAttribute != null) {
      size += firstAttribute.computeAttributesSize(symbolTable);
    }
    return size;
  }

  void putFieldInfo(ByteVector output) {
    // boolean useSyntheticAttribute = false; // symbolTable.getMajorVersion() < Opcodes.V1_5;
    // Put the access_flags, name_index and descriptor_index fields.
    int mask = 0;
    output.putShort(accessFlags & ~mask).putShort(nameIndex).putShort(descriptorIndex);
    // Compute and put the attributes_count field.
    // For ease of reference, we use here the same attribute order as in Section 4.7 of the JVMS.
    int attributesCount = 0;
    if (constantValueIndex != 0) {
      ++attributesCount;
    }
    if (signatureIndex != 0) {
      ++attributesCount;
    }
    if ((accessFlags & Opcodes.ACC_DEPRECATED) != 0) {
      ++attributesCount;
    }
    if (firstAttribute != null) {
      attributesCount += firstAttribute.getAttributeCount();
    }
    output.putShort(attributesCount);
    // Put the field_info attributes.
    // For ease of reference, we use here the same attribute order as in Section 4.7 of the JVMS.
    if (constantValueIndex != 0) {
      output.putShort(symbolTable.addConstantUtf8(Constants.CONSTANT_VALUE)).putInt(2).putShort(constantValueIndex);
    }
    if (signatureIndex != 0) {
      output.putShort(symbolTable.addConstantUtf8(Constants.SIGNATURE)).putInt(2).putShort(signatureIndex);
    }
    if ((accessFlags & Opcodes.ACC_DEPRECATED) != 0) {
      output.putShort(symbolTable.addConstantUtf8(Constants.DEPRECATED)).putInt(0);
    }
    if (firstAttribute != null) {
      firstAttribute.putAttributes(symbolTable, output);
    }
  }

  void collectAttributePrototypes(Attribute.Set attributePrototypes) {
    attributePrototypes.addAttributes(firstAttribute);
  }
}
