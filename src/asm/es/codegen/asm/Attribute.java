package es.codegen.asm;

public class Attribute {

  final String type;

  byte[] content;

  Attribute nextAttribute;

  public Attribute(String type) {
    this.type = type;
  }

  boolean isUnknown() {
    return true;
  }

  boolean isCodeAttribute() {
    return false;
  }

  Label[] getLabels() {
    return new Label[0];
  }

  Attribute read(ClassReader classReader, int offset, int length, char[] charBuffer, int codeAttributeOffset, Label[] labels) {
    Attribute attribute = new Attribute(type);
    attribute.content = new byte[length];
    System.arraycopy(classReader.b, offset, attribute.content, 0, length);
    return attribute;
  }

  ByteVector write(ClassWriter classWriter, byte[] code, int codeLength, int maxStack, int maxLocals) {
    return new ByteVector(content);
  }

  int getAttributeCount() {
    int count = 0;
    Attribute attribute = this;
    while (attribute != null) {
      count += 1;
      attribute = attribute.nextAttribute;
    }
    return count;
  }

  int computeAttributesSize(SymbolTable symbolTable) {
    byte[] code = null;
    int codeLength = 0;
    int maxStack = -1;
    int maxLocals = -1;
    return computeAttributesSize(symbolTable, code, codeLength, maxStack, maxLocals);
  }

  int computeAttributesSize(SymbolTable symbolTable, byte[] code, int codeLength, int maxStack, int maxLocals) {
    ClassWriter classWriter = symbolTable.classWriter;
    int size = 0;
    Attribute attribute = this;
    while (attribute != null) {
      symbolTable.addConstantUtf8(attribute.type);
      size += 6 + attribute.write(classWriter, code, codeLength, maxStack, maxLocals).length;
      attribute = attribute.nextAttribute;
    }
    return size;
  }

  void putAttributes(SymbolTable symbolTable, ByteVector output) {
    byte[] code = null;
    int codeLength = 0;
    int maxStack = -1;
    int maxLocals = -1;
    putAttributes(symbolTable, code, codeLength, maxStack, maxLocals, output);
  }

  void putAttributes(SymbolTable symbolTable, byte[] code, int codeLength, int maxStack, int maxLocals, ByteVector output) {
    ClassWriter classWriter = symbolTable.classWriter;
    Attribute attribute = this;
    while (attribute != null) {
      ByteVector attributeContent = attribute.write(classWriter, code, codeLength, maxStack, maxLocals);
      // Put attribute_name_index and attribute_length.
      output.putShort(symbolTable.addConstantUtf8(attribute.type)).putInt(attributeContent.length);
      output.putByteArray(attributeContent.data, 0, attributeContent.length);
      attribute = attribute.nextAttribute;
    }
  }

  static class Set {

    static int SIZE_INCREMENT = 6;

    int size;
    Attribute[] data = new Attribute[SIZE_INCREMENT];

    void addAttributes(Attribute attributeList) {
      Attribute attribute = attributeList;
      while (attribute != null) {
        if (!contains(attribute)) {
          add(attribute);
        }
        attribute = attribute.nextAttribute;
      }
    }

    Attribute[] toArray() {
      Attribute[] result = new Attribute[size];
      System.arraycopy(data, 0, result, 0, size);
      return result;
    }

    boolean contains(Attribute attribute) {
      for (int i = 0; i < size; ++i) {
        if (data[i].type.equals(attribute.type)) {
          return true;
        }
      }
      return false;
    }

    void add(Attribute attribute) {
      if (size >= data.length) {
        Attribute[] newData = new Attribute[data.length + SIZE_INCREMENT];
        System.arraycopy(data, 0, newData, 0, size);
        data = newData;
      }
      data[size++] = attribute;
    }
  }
}
