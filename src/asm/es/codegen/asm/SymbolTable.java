package es.codegen.asm;

class SymbolTable {

  final ClassWriter classWriter;
  final ClassReader sourceClassReader;

  int majorVersion;
  String className;

  int entryCount;
  Entry[] entries;

  int constantPoolCount;
  ByteVector constantPool;

  int bootstrapMethodCount;
  ByteVector bootstrapMethods;

  int typeCount;
  Entry[] typeTable;

  SymbolTable(ClassWriter classWriter) {
    this.classWriter = classWriter;
    this.sourceClassReader = null;
    this.entries = new Entry[256];
    this.constantPoolCount = 1;
    this.constantPool = new ByteVector();
  }

  void copyBootstrapMethods(ClassReader classReader, char[] charBuffer) {
    // Find attributOffset of the 'bootstrap_methods' array.
    var inputBytes = classReader.b;
    var currentAttributeOffset = classReader.getFirstAttributeOffset();
    for (var i = classReader.readUnsignedShort(currentAttributeOffset - 2); i > 0; --i) {
      var attributeName = classReader.readUTF8(currentAttributeOffset, charBuffer);
      if (Constants.BOOTSTRAP_METHODS.equals(attributeName)) {
        bootstrapMethodCount = classReader.readUnsignedShort(currentAttributeOffset + 6);
        break;
      }
      currentAttributeOffset += 6 + classReader.readInt(currentAttributeOffset + 2);
    }
    if (bootstrapMethodCount > 0) {
      // Compute the offset and the length of the BootstrapMethods 'bootstrap_methods' array.
      var bootstrapMethodsOffset = currentAttributeOffset + 8;
      var bootstrapMethodsLength = classReader.readInt(currentAttributeOffset + 2) - 2;
      bootstrapMethods = new ByteVector(bootstrapMethodsLength);
      bootstrapMethods.putByteArray(inputBytes, bootstrapMethodsOffset, bootstrapMethodsLength);
      // Add each bootstrap method in the symbol table entries.
      var currentOffset = bootstrapMethodsOffset;
      for (var i = 0; i < bootstrapMethodCount; i++) {
        var offset = currentOffset - bootstrapMethodsOffset;
        var bootstrapMethodRef = classReader.readUnsignedShort(currentOffset);
        currentOffset += 2;
        var numBootstrapArguments = classReader.readUnsignedShort(currentOffset);
        currentOffset += 2;
        var hashCode = classReader.readConst(bootstrapMethodRef, charBuffer).hashCode();
        while (numBootstrapArguments-- > 0) {
          var bootstrapArgument = classReader.readUnsignedShort(currentOffset);
          currentOffset += 2;
          hashCode ^= classReader.readConst(bootstrapArgument, charBuffer).hashCode();
        }
        add(new Entry(i, Symbol.BOOTSTRAP_METHOD_TAG, offset, hashCode & 0x7FFFFFFF));
      }
    }
  }

  ClassReader getSource() {
    return sourceClassReader;
  }

  int getMajorVersion() {
    return majorVersion;
  }

  String getClassName() {
    return className;
  }

  int setMajorVersionAndClassName(int majorVersion, String className) {
    this.majorVersion = majorVersion;
    this.className = className;
    return addConstantClass(className).index;
  }

  int getConstantPoolCount() {
    return constantPoolCount;
  }

  int getConstantPoolLength() {
    return constantPool.length;
  }

  void putConstantPool(ByteVector output) {
    output.putShort(constantPoolCount).putByteArray(constantPool.data, 0, constantPool.length);
  }

  int computeBootstrapMethodsSize() {
    if (bootstrapMethods != null) {
      addConstantUtf8(Constants.BOOTSTRAP_METHODS);
      return 8 + bootstrapMethods.length;
    } else {
      return 0;
    }
  }

  void putBootstrapMethods(ByteVector output) {
    if (bootstrapMethods != null) {
      output.putShort(addConstantUtf8(Constants.BOOTSTRAP_METHODS))
            .putInt(bootstrapMethods.length + 2)
            .putShort(bootstrapMethodCount)
            .putByteArray(bootstrapMethods.data, 0, bootstrapMethods.length);
    }
  }

  Entry get(int hashCode) {
    return entries[hashCode % entries.length];
  }

  Entry put(Entry entry) {
    if (entryCount > (entries.length * 3) / 4) {
      var currentCapacity = entries.length;
      var newCapacity = currentCapacity * 2 + 1;
      var newEntries = new Entry[newCapacity];
      for (var i = currentCapacity - 1; i >= 0; --i) {
        var currentEntry = entries[i];
        while (currentEntry != null) {
          var newCurrentEntryIndex = currentEntry.hashCode % newCapacity;
          var nextEntry = currentEntry.next;
          currentEntry.next = newEntries[newCurrentEntryIndex];
          newEntries[newCurrentEntryIndex] = currentEntry;
          currentEntry = nextEntry;
        }
      }
      entries = newEntries;
    }
    entryCount++;
    var index = entry.hashCode % entries.length;
    entry.next = entries[index];
    return entries[index] = entry;
  }

  void add(Entry entry) {
    entryCount++;
    var index = entry.hashCode % entries.length;
    entry.next = entries[index];
    entries[index] = entry;
  }

  Symbol addConstant(Object value) {
    if (value instanceof Integer i) {
      return addConstantInteger(i);
    } else if (value instanceof Byte b) {
      return addConstantInteger(b.intValue());
    } else if (value instanceof Character c) {
      return addConstantInteger(c);
    } else if (value instanceof Short s) {
      return addConstantInteger(s.intValue());
    } else if (value instanceof Boolean b) {
      return addConstantInteger(b ? 1 : 0);
    } else if (value instanceof Float f) {
      return addConstantFloat(f);
    } else if (value instanceof Long l) {
      return addConstantLong(l);
    } else if (value instanceof Double d) {
      return addConstantDouble(d);
    } else if (value instanceof String s) {
      return addConstantString(s);
    } else if (value instanceof Type t) {
      var typeSort = t.getSort();
      return switch (typeSort) {
        case Type.OBJECT -> addConstantClass(t.getInternalName());
        case Type.METHOD -> addConstantMethodType(t.getDescriptor());
        default -> addConstantClass(t.getDescriptor()); // type is a primitive or array type.
      };
    } else if (value instanceof Handle h) {
      return addConstantMethodHandle(h.getTag(), h.getOwner(), h.getName(), h.getDesc(), h.isInterface());
    } else if (value instanceof ConstantDynamic cd) {
      return addConstantDynamic(cd.getName(), cd.getDescriptor(), cd.getBootstrapMethod(), cd.getBootstrapMethodArgumentsUnsafe());
    } else {
      throw new IllegalArgumentException("value " + value);
    }
  }

  Symbol addConstantClass(String value) {
    return addConstantUtf8Reference(Symbol.CONSTANT_CLASS_TAG, value);
  }

  Symbol addConstantFieldref(String owner, String name, String descriptor) {
    return addConstantMemberReference(Symbol.CONSTANT_FIELDREF_TAG, owner, name, descriptor);
  }

  Symbol addConstantMethodref(String owner, String name, String descriptor, boolean isInterface) {
    var tag = isInterface ? Symbol.CONSTANT_INTERFACE_METHODREF_TAG : Symbol.CONSTANT_METHODREF_TAG;
    return addConstantMemberReference(tag, owner, name, descriptor);
  }

  Entry addConstantMemberReference(int tag, String owner, String name, String descriptor) {
    var hashCode = hash(tag, owner, name, descriptor);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == tag && entry.hashCode == hashCode && entry.owner.equals(owner) && entry.name.equals(name) && entry.value.equals(descriptor)) {
        return entry;
      }
      entry = entry.next;
    }
    constantPool.put122(tag, addConstantClass(owner).index, addConstantNameAndType(name, descriptor));
    return put(new Entry(constantPoolCount++, tag, owner, name, descriptor, 0, hashCode));
  }

  void addConstantMemberReference(int index, int tag, String owner, String name, String descriptor) {
    add(new Entry(index, tag, owner, name, descriptor, 0, hash(tag, owner, name, descriptor)));
  }

  Symbol addConstantString(String value) {
    return addConstantUtf8Reference(Symbol.CONSTANT_STRING_TAG, value);
  }

  Symbol addConstantInteger(int value) {
    return addConstantIntegerOrFloat(Symbol.CONSTANT_INTEGER_TAG, value);
  }

  Symbol addConstantFloat(float value) {
    return addConstantIntegerOrFloat(Symbol.CONSTANT_FLOAT_TAG, Float.floatToRawIntBits(value));
  }

  Symbol addConstantIntegerOrFloat(int tag, int value) {
    var hashCode = hash(tag, value);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == tag && entry.hashCode == hashCode && entry.data == value) {
        return entry;
      }
      entry = entry.next;
    }
    constantPool.putByte(tag).putInt(value);
    return put(new Entry(constantPoolCount++, tag, value, hashCode));
  }

  void addConstantIntegerOrFloat(int index, int tag, int value) {
    add(new Entry(index, tag, value, hash(tag, value)));
  }

  Symbol addConstantLong(long value) {
    return addConstantLongOrDouble(Symbol.CONSTANT_LONG_TAG, value);
  }

  Symbol addConstantDouble(double value) {
    return addConstantLongOrDouble(Symbol.CONSTANT_DOUBLE_TAG, Double.doubleToRawLongBits(value));
  }

  Symbol addConstantLongOrDouble(int tag, long value) {
    var hashCode = hash(tag, value);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == tag && entry.hashCode == hashCode && entry.data == value) {
        return entry;
      }
      entry = entry.next;
    }
    var index = constantPoolCount;
    constantPool.putByte(tag).putLong(value);
    constantPoolCount += 2;
    return put(new Entry(index, tag, value, hashCode));
  }

  void addConstantLongOrDouble(int index, int tag, long value) {
    add(new Entry(index, tag, value, hash(tag, value)));
  }

  int addConstantNameAndType(String name, String descriptor) {
    var tag = Symbol.CONSTANT_NAME_AND_TYPE_TAG;
    var hashCode = hash(tag, name, descriptor);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == tag && entry.hashCode == hashCode && entry.name.equals(name) && entry.value.equals(descriptor)) {
        return entry.index;
      }
      entry = entry.next;
    }
    constantPool.put122(tag, addConstantUtf8(name), addConstantUtf8(descriptor));
    return put(new Entry(constantPoolCount++, tag, name, descriptor, hashCode)).index;
  }

  void addConstantNameAndType(int index, String name, String descriptor) {
    int tag = Symbol.CONSTANT_NAME_AND_TYPE_TAG;
    add(new Entry(index, tag, name, descriptor, hash(tag, name, descriptor)));
  }

  int addConstantUtf8(String value) {
    var hashCode = hash(Symbol.CONSTANT_UTF8_TAG, value);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == Symbol.CONSTANT_UTF8_TAG && entry.hashCode == hashCode && entry.value.equals(value)) {
        return entry.index;
      }
      entry = entry.next;
    }
    constantPool.putByte(Symbol.CONSTANT_UTF8_TAG).putUTF8(value);
    return put(new Entry(constantPoolCount++, Symbol.CONSTANT_UTF8_TAG, value, hashCode)).index;
  }

  void addConstantUtf8(int index, String value) {
    add(new Entry(index, Symbol.CONSTANT_UTF8_TAG, value, hash(Symbol.CONSTANT_UTF8_TAG, value)));
  }

  Symbol addConstantMethodHandle(int referenceKind, String owner, String name, String descriptor, boolean isInterface) {
    var tag = Symbol.CONSTANT_METHOD_HANDLE_TAG;
    // Note that we don't need to include isInterface in the hash computation, because it is redundant with owner (we can't have the same owner with different isInterface values).
    var hashCode = hash(tag, owner, name, descriptor, referenceKind);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == tag && entry.hashCode == hashCode && entry.data == referenceKind && entry.owner.equals(owner) && entry.name.equals(name) && entry.value.equals(descriptor)) {
        return entry;
      }
      entry = entry.next;
    }
    if (referenceKind <= Opcodes.H_PUTSTATIC) {
      constantPool.put112(tag, referenceKind, addConstantFieldref(owner, name, descriptor).index);
    } else {
      constantPool.put112(tag, referenceKind, addConstantMethodref(owner, name, descriptor, isInterface).index);
    }
    return put(new Entry(constantPoolCount++, tag, owner, name, descriptor, referenceKind, hashCode));
  }

  void addConstantMethodHandle(int index, int referenceKind, String owner, String name, String descriptor) {
    var tag = Symbol.CONSTANT_METHOD_HANDLE_TAG;
    var hashCode = hash(tag, owner, name, descriptor, referenceKind);
    add(new Entry(index, tag, owner, name, descriptor, referenceKind, hashCode));
  }

  Symbol addConstantMethodType(String methodDescriptor) {
    return addConstantUtf8Reference(Symbol.CONSTANT_METHOD_TYPE_TAG, methodDescriptor);
  }

  Symbol addConstantDynamic(String name, String descriptor, Handle bootstrapMethodHandle, Object... bootstrapMethodArguments) {
    var bootstrapMethod = addBootstrapMethod(bootstrapMethodHandle, bootstrapMethodArguments);
    return addConstantDynamicOrInvokeDynamicReference(Symbol.CONSTANT_DYNAMIC_TAG, name, descriptor, bootstrapMethod.index);
  }

  Symbol addConstantInvokeDynamic(String name, String descriptor, Handle bootstrapMethodHandle, Object... bootstrapMethodArguments) {
    var bootstrapMethod = addBootstrapMethod(bootstrapMethodHandle, bootstrapMethodArguments);
    return addConstantDynamicOrInvokeDynamicReference(Symbol.CONSTANT_INVOKE_DYNAMIC_TAG, name, descriptor, bootstrapMethod.index);
  }

  Symbol addConstantDynamicOrInvokeDynamicReference(int tag, String name, String descriptor, int bootstrapMethodIndex) {
    var hashCode = hash(tag, name, descriptor, bootstrapMethodIndex);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == tag && entry.hashCode == hashCode && entry.data == bootstrapMethodIndex && entry.name.equals(name) && entry.value.equals(descriptor)) {
        return entry;
      }
      entry = entry.next;
    }
    constantPool.put122(tag, bootstrapMethodIndex, addConstantNameAndType(name, descriptor));
    return put(new Entry(constantPoolCount++, tag, null, name, descriptor, bootstrapMethodIndex, hashCode));
  }

  void addConstantDynamicOrInvokeDynamicReference(int tag, int index, String name, String descriptor, int bootstrapMethodIndex) {
    var hashCode = hash(tag, name, descriptor, bootstrapMethodIndex);
    add(new Entry(index, tag, null, name, descriptor, bootstrapMethodIndex, hashCode));
  }

  Symbol addConstantModule(String moduleName) {
    return addConstantUtf8Reference(Symbol.CONSTANT_MODULE_TAG, moduleName);
  }

  Symbol addConstantPackage(String packageName) {
    return addConstantUtf8Reference(Symbol.CONSTANT_PACKAGE_TAG, packageName);
  }

  Symbol addConstantUtf8Reference(int tag, String value) {
    var hashCode = hash(tag, value);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == tag && entry.hashCode == hashCode && entry.value.equals(value)) {
        return entry;
      }
      entry = entry.next;
    }
    constantPool.put12(tag, addConstantUtf8(value));
    return put(new Entry(constantPoolCount++, tag, value, hashCode));
  }

  void addConstantUtf8Reference(int index, int tag, String value) {
    add(new Entry(index, tag, value, hash(tag, value)));
  }

  Symbol addBootstrapMethod(Handle bootstrapMethodHandle, Object... bootstrapMethodArguments) {
    var bootstrapMethodsAttribute = bootstrapMethods;
    if (bootstrapMethodsAttribute == null) {
      bootstrapMethodsAttribute = bootstrapMethods = new ByteVector();
    }
    // The bootstrap method arguments can be Constant_Dynamic values, which reference other bootstrap methods. We must therefore add the bootstrap method arguments to the constant pool and BootstrapMethods attribute first, so that the BootstrapMethods attribute is not modified while adding the given bootstrap method to it, in the rest of this method.
    for (var bootstrapMethodArgument : bootstrapMethodArguments) {
      addConstant(bootstrapMethodArgument);
    }
    // Write the bootstrap method in the BootstrapMethods table. This is necessary to be able to compare it with existing ones, and will be reverted below if there is already a similar bootstrap method.
    var bootstrapMethodOffset = bootstrapMethodsAttribute.length;
    bootstrapMethodsAttribute.putShort(addConstantMethodHandle(bootstrapMethodHandle.getTag(), bootstrapMethodHandle.getOwner(), bootstrapMethodHandle.getName(), bootstrapMethodHandle.getDesc(), bootstrapMethodHandle.isInterface()).index);
    var numBootstrapArguments = bootstrapMethodArguments.length;
    bootstrapMethodsAttribute.putShort(numBootstrapArguments);
    for (var bootstrapMethodArgument : bootstrapMethodArguments) {
      bootstrapMethodsAttribute.putShort(addConstant(bootstrapMethodArgument).index);
    }
    // Compute the length and the hash code of the bootstrap method.
    var bootstrapMethodlength = bootstrapMethodsAttribute.length - bootstrapMethodOffset;
    var hashCode = bootstrapMethodHandle.hashCode();
    for (var bootstrapMethodArgument : bootstrapMethodArguments) {
      hashCode ^= bootstrapMethodArgument.hashCode();
    }
    hashCode &= 0x7FFFFFFF;
    // Add the bootstrap method to the symbol table or revert the above changes.
    return addBootstrapMethod(bootstrapMethodOffset, bootstrapMethodlength, hashCode);
  }

  Symbol addBootstrapMethod(int offset, int length, int hashCode) {
    var bootstrapMethodsData = bootstrapMethods.data;
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == Symbol.BOOTSTRAP_METHOD_TAG && entry.hashCode == hashCode) {
        var otherOffset = (int) entry.data;
        var isSameBootstrapMethod = true;
        for (var i = 0; i < length; ++i) {
          if (bootstrapMethodsData[offset + i] != bootstrapMethodsData[otherOffset + i]) {
            isSameBootstrapMethod = false;
            break;
          }
        }
        if (isSameBootstrapMethod) {
          bootstrapMethods.length = offset; // Revert to old position.
          return entry;
        }
      }
      entry = entry.next;
    }
    return put(new Entry(bootstrapMethodCount++, Symbol.BOOTSTRAP_METHOD_TAG, offset, hashCode));
  }

  Symbol getType(int typeIndex) {
    return typeTable[typeIndex];
  }

  int addType(String value) {
    var hashCode = hash(Symbol.TYPE_TAG, value);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == Symbol.TYPE_TAG && entry.hashCode == hashCode && entry.value.equals(value)) {
        return entry.index;
      }
      entry = entry.next;
    }
    return addTypeInternal(new Entry(typeCount, Symbol.TYPE_TAG, value, hashCode));
  }

  int addUninitializedType(String value, int bytecodeOffset) {
    var hashCode = hash(Symbol.UNINITIALIZED_TYPE_TAG, value, bytecodeOffset);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == Symbol.UNINITIALIZED_TYPE_TAG && entry.hashCode == hashCode && entry.data == bytecodeOffset && entry.value.equals(value)) {
        return entry.index;
      }
      entry = entry.next;
    }
    return addTypeInternal(new Entry(typeCount, Symbol.UNINITIALIZED_TYPE_TAG, value, bytecodeOffset, hashCode));
  }

  int addMergedType(int typeTableIndex1, int typeTableIndex2) {
    // TODO sort the arguments? The merge result should be independent of their order.
    var data = typeTableIndex1 | (((long) typeTableIndex2) << 32);
    var hashCode = hash(Symbol.MERGED_TYPE_TAG, typeTableIndex1 + typeTableIndex2);
    var entry = get(hashCode);
    while (entry != null) {
      if (entry.tag == Symbol.MERGED_TYPE_TAG && entry.hashCode == hashCode && entry.data == data) {
        return entry.info;
      }
      entry = entry.next;
    }
    var type1 = typeTable[typeTableIndex1].value;
    var type2 = typeTable[typeTableIndex2].value;
    var commonSuperTypeIndex = addType(classWriter.getCommonSuperClass(type1, type2));
    put(new Entry(typeCount, Symbol.MERGED_TYPE_TAG, data, hashCode)).info = commonSuperTypeIndex;
    return commonSuperTypeIndex;
  }

  int addTypeInternal(Entry entry) {
    if (typeTable == null) {
      typeTable = new Entry[16];
    }
    if (typeCount == typeTable.length) {
      var newTypeTable = new Entry[2 * typeTable.length];
      System.arraycopy(typeTable, 0, newTypeTable, 0, typeTable.length);
      typeTable = newTypeTable;
    }
    typeTable[typeCount++] = entry;
    return put(entry).index;
  }

  static int hash(int tag, int value) {
    return 0x7FFFFFFF & (tag + value);
  }

  static int hash(int tag, long value) {
    return 0x7FFFFFFF & (tag + (int) value + (int) (value >>> 32));
  }

  static int hash(int tag, String value) {
    return 0x7FFFFFFF & (tag + value.hashCode());
  }

  static int hash(int tag, String value1, int value2) {
    return 0x7FFFFFFF & (tag + value1.hashCode() + value2);
  }

  static int hash(int tag, String value1, String value2) {
    return 0x7FFFFFFF & (tag + value1.hashCode() * value2.hashCode());
  }

  static int hash(int tag, String value1, String value2, int value3) {
    return 0x7FFFFFFF & (tag + value1.hashCode() * value2.hashCode() * (value3 + 1));
  }

  static int hash(int tag, String value1, String value2, String value3) {
    return 0x7FFFFFFF & (tag + value1.hashCode() * value2.hashCode() * value3.hashCode());
  }

  static int hash(int tag, String value1, String value2, String value3, int value4) {
    return 0x7FFFFFFF & (tag + value1.hashCode() * value2.hashCode() * value3.hashCode() * value4);
  }

  static class Entry extends Symbol {

    int hashCode;

    Entry next;

    Entry(int index, int tag, String owner, String name, String value, long data, int hashCode) {
      super(index, tag, owner, name, value, data);
      this.hashCode = hashCode;
    }

    Entry(int index, int tag, String value, int hashCode) {
      super(index, tag, null, null, value, 0);
      this.hashCode = hashCode;
    }

    Entry(int index, int tag, String value, long data, int hashCode) {
      super(index, tag, null, null, value, data);
      this.hashCode = hashCode;
    }

    Entry(int index, int tag, String name, String value, int hashCode) {
      super(index, tag, null, name, value, 0);
      this.hashCode = hashCode;
    }

    Entry(int index, int tag, long data, int hashCode) {
      super(index, tag, null, null, null, data);
      this.hashCode = hashCode;
    }
  }
}
