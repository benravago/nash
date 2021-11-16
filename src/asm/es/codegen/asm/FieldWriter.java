package es.codegen.asm;

class FieldWriter extends FieldVisitor {

  final SymbolTable symbolTable;
  final int accessFlags;
  final int nameIndex;
  final int descriptorIndex;

  int signatureIndex;
  int constantValueIndex;

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
  public void visitEnd() {
    // Nothing to do.
  }

  int computeFieldInfoSize() {
    var size = 8;
    if (constantValueIndex != 0) {
      symbolTable.addConstantUtf8(Constants.CONSTANT_VALUE);
      size += 8;
    }
    if (signatureIndex != 0) {
      symbolTable.addConstantUtf8(Constants.SIGNATURE);
      size += 8;
    }
    return size;
  }

  void putFieldInfo(ByteVector output) {
    output.putShort(accessFlags).putShort(nameIndex).putShort(descriptorIndex);
    var attributesCount = 0;
    if (constantValueIndex != 0) {
      ++attributesCount;
    }
    if (signatureIndex != 0) {
      ++attributesCount;
    }
    output.putShort(attributesCount);
    if (constantValueIndex != 0) {
      output.putShort(symbolTable.addConstantUtf8(Constants.CONSTANT_VALUE)).putInt(2).putShort(constantValueIndex);
    }
    if (signatureIndex != 0) {
      output.putShort(symbolTable.addConstantUtf8(Constants.SIGNATURE)).putInt(2).putShort(signatureIndex);
    }
  }
}
