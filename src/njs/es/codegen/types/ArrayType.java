package es.codegen.types;

import es.codegen.asm.MethodVisitor;
import static es.codegen.asm.Opcodes.*;

/**
 * This is an array type, i.e. OBJECT_ARRAY, NUMBER_ARRAY.
 */
public class ArrayType extends ObjectType implements BytecodeArrayOps {

  /**
   * Constructor
   *
   * @param type the Java class representation of the array
   */
  protected ArrayType(Class<?> type) {
    super(type);
  }

  /**
   * Get the element type of the array elements e.g. for OBJECT_ARRAY, this is OBJECT
   *
   * @return the element type
   */
  public Type getElementType() {
    return Type.typeFor(getTypeClass().getComponentType());
  }

  @Override
  public void astore(MethodVisitor method) {
    method.visitInsn(AASTORE);
  }

  @Override
  public Type aload(MethodVisitor method) {
    method.visitInsn(AALOAD);
    return getElementType();
  }

  @Override
  public Type arraylength(MethodVisitor method) {
    method.visitInsn(ARRAYLENGTH);
    return INT;
  }

  @Override
  public Type newarray(MethodVisitor method) {
    method.visitTypeInsn(ANEWARRAY, getElementType().getInternalName());
    return this;
  }

  @Override
  public Type newarray(MethodVisitor method, int dims) {
    method.visitMultiANewArrayInsn(getInternalName(), dims);
    return this;
  }

  @Override
  public Type load(MethodVisitor method, int slot) {
    assert slot != -1;
    method.visitVarInsn(ALOAD, slot);
    return this;
  }

  @Override
  public String toString() {
    return "array<elementType=" + getElementType().getTypeClass().getSimpleName() + '>';
  }

  @Override
  public Type convert(MethodVisitor method, Type to) {
    assert to.isObject();
    assert !to.isArray() || ((ArrayType) to).getElementType() == getElementType();
    return to;
  }

  private static final long serialVersionUID = 1;
}
