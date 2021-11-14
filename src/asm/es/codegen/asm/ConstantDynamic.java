package es.codegen.asm;

import java.util.Arrays;

class ConstantDynamic {

  final String name;
  final String descriptor;
  final Handle bootstrapMethod;
  final Object[] bootstrapMethodArguments;

  ConstantDynamic(String name, String descriptor, Handle bootstrapMethod, Object... bootstrapMethodArguments) {
    this.name = name;
    this.descriptor = descriptor;
    this.bootstrapMethod = bootstrapMethod;
    this.bootstrapMethodArguments = bootstrapMethodArguments;
  }

  String getName() {
    return name;
  }

  String getDescriptor() {
    return descriptor;
  }

  Handle getBootstrapMethod() {
    return bootstrapMethod;
  }

  int getBootstrapMethodArgumentCount() {
    return bootstrapMethodArguments.length;
  }

  Object getBootstrapMethodArgument(int index) {
    return bootstrapMethodArguments[index];
  }

  Object[] getBootstrapMethodArgumentsUnsafe() {
    return bootstrapMethodArguments;
  }

  int getSize() {
    char firstCharOfDescriptor = descriptor.charAt(0);
    return (firstCharOfDescriptor == 'J' || firstCharOfDescriptor == 'D') ? 2 : 1;
  }

  @Override
  public boolean equals(Object object) {
    if (object == this) {
      return true;
    }
    if (!(object instanceof ConstantDynamic)) {
      return false;
    }
    ConstantDynamic constantDynamic = (ConstantDynamic) object;
    return name.equals(constantDynamic.name) && descriptor.equals(constantDynamic.descriptor)
            && bootstrapMethod.equals(constantDynamic.bootstrapMethod)
            && Arrays.equals(bootstrapMethodArguments, constantDynamic.bootstrapMethodArguments);
  }

  @Override
  public int hashCode() {
    return name.hashCode() ^ Integer.rotateLeft(descriptor.hashCode(), 8)
            ^ Integer.rotateLeft(bootstrapMethod.hashCode(), 16)
            ^ Integer.rotateLeft(Arrays.hashCode(bootstrapMethodArguments), 24);
  }

  @Override
  public String toString() {
    return name + " : " + descriptor + ' ' + bootstrapMethod + ' ' + Arrays.toString(bootstrapMethodArguments);
  }
}
