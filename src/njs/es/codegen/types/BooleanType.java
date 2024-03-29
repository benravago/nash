package es.codegen.types;

import static es.codegen.asm.Opcodes.I2D;
import static es.codegen.asm.Opcodes.I2L;
import static es.codegen.asm.Opcodes.ICONST_0;
import static es.codegen.asm.Opcodes.ICONST_1;
import static es.codegen.asm.Opcodes.ILOAD;
import static es.codegen.asm.Opcodes.IRETURN;
import static es.codegen.asm.Opcodes.ISTORE;
import static es.codegen.CompilerConstants.staticCallNoLookup;
import static es.runtime.JSType.UNDEFINED_INT;

import es.codegen.asm.MethodVisitor;
import es.codegen.CompilerConstants;

/**
 * The boolean type class
 */
public final class BooleanType extends Type {

  private static final CompilerConstants.Call VALUE_OF = staticCallNoLookup(Boolean.class, "valueOf", Boolean.class, boolean.class);
  private static final CompilerConstants.Call TO_STRING = staticCallNoLookup(Boolean.class, "toString", String.class, boolean.class);

  /**
   * Constructor
   */
  protected BooleanType() {
    super("boolean", boolean.class, 1, 1);
  }

  @Override
  public Type nextWider() {
    return INT;
  }

  @Override
  public Class<?> getBoxedType() {
    return Boolean.class;
  }

  @Override
  public char getBytecodeStackType() {
    return 'I';
  }

  @Override
  public Type loadUndefined(MethodVisitor method) {
    method.visitLdcInsn(UNDEFINED_INT);
    return BOOLEAN;
  }

  @Override
  public Type loadForcedInitializer(MethodVisitor method) {
    method.visitInsn(ICONST_0);
    return BOOLEAN;
  }

  @Override
  public void ret(MethodVisitor method) {
    method.visitInsn(IRETURN);
  }

  @Override
  public Type load(MethodVisitor method, int slot) {
    assert slot != -1;
    method.visitVarInsn(ILOAD, slot);
    return BOOLEAN;
  }

  @Override
  public void store(MethodVisitor method, int slot) {
    assert slot != -1;
    method.visitVarInsn(ISTORE, slot);
  }

  @Override
  public Type ldc(MethodVisitor method, Object c) {
    assert c instanceof Boolean;
    method.visitInsn((Boolean) c ? ICONST_1 : ICONST_0);
    return BOOLEAN;
  }

  @Override
  public Type convert(MethodVisitor method, Type to) {
    if (isEquivalentTo(to)) {
      return to;
    }

    if (to.isNumber()) {
      method.visitInsn(I2D);
    } else if (to.isLong()) {
      method.visitInsn(I2L);
    } else if (to.isInteger()) {
      //nop
    } else if (to.isString()) {
      invokestatic(method, TO_STRING);
    } else if (to.isObject()) {
      invokestatic(method, VALUE_OF);
    } else {
      throw new UnsupportedOperationException("Illegal conversion " + this + " -> " + to);
    }

    return to;
  }

  @Override
  public Type add(MethodVisitor method, int programPoint) {
    // Adding booleans in JavaScript is perfectly valid, they add as if false=0 and true=1
    return Type.INT.add(method, programPoint);
  }

  private static final long serialVersionUID = 1;
}
