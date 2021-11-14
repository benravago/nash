package es.codegen.asm;

public class Handle {

  final int tag;
  final String owner;
  final String name;
  final String descriptor;
  final boolean isInterface;

  public Handle(int tag, String owner, String name, String descriptor, boolean isInterface) {
    this.tag = tag;
    this.owner = owner;
    this.name = name;
    this.descriptor = descriptor;
    this.isInterface = isInterface;
  }

  int getTag() {
    return tag;
  }

  String getOwner() {
    return owner;
  }

  String getName() {
    return name;
  }

  String getDesc() {
    return descriptor;
  }

  boolean isInterface() {
    return isInterface;
  }

  @Override
  public boolean equals(Object object) {
    if (object == this) {
      return true;
    }
    if (!(object instanceof Handle)) {
      return false;
    }
    Handle handle = (Handle) object;
    return tag == handle.tag && isInterface == handle.isInterface && owner.equals(handle.owner)
            && name.equals(handle.name) && descriptor.equals(handle.descriptor);
  }

  @Override
  public int hashCode() {
    return tag + (isInterface ? 64 : 0) + owner.hashCode() * name.hashCode() * descriptor.hashCode();
  }

  @Override
  public String toString() {
    return owner + '.' + name + descriptor + " (" + tag + (isInterface ? " itf" : "") + ')';
  }
}
