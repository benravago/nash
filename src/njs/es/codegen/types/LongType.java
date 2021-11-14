package es.codegen.types;

import es.codegen.asm.MethodVisitor;
import static es.codegen.asm.Opcodes.*;

import es.runtime.JSType;
import es.codegen.CompilerConstants;
import static es.codegen.CompilerConstants.staticCallNoLookup;

/**
 * Type class: LONG
 */
class LongType extends Type {

  private static final CompilerConstants.Call VALUE_OF = staticCallNoLookup(Long.class, "valueOf", Long.class, long.class);

  protected LongType(String name) {
    super(name, long.class, 3, 2);
  }

  protected LongType() {
    this("long");
  }

  @Override
  public Type nextWider() {
    return NUMBER;
  }

  @Override
  public Class<?> getBoxedType() {
    return Long.class;
  }

  @Override
  public char getBytecodeStackType() {
    return 'J';
  }

  @Override
  public Type load(MethodVisitor method, int slot) {
    assert slot != -1;
    method.visitVarInsn(LLOAD, slot);
    return LONG;
  }

  @Override
  public void store(MethodVisitor method, int slot) {
    assert slot != -1;
    method.visitVarInsn(LSTORE, slot);
  }

  @Override
  public Type ldc(MethodVisitor method, Object c) {
    assert c instanceof Long;

    long value = (Long) c;

    if (value == 0L) {
      method.visitInsn(LCONST_0);
    } else if (value == 1L) {
      method.visitInsn(LCONST_1);
    } else {
      method.visitLdcInsn(c);
    }

    return Type.LONG;
  }

  @Override
  public Type convert(MethodVisitor method, Type to) {
    if (isEquivalentTo(to)) {
      return to;
    }

    if (to.isNumber()) {
      method.visitInsn(L2D);
    } else if (to.isInteger()) {
      invokestatic(method, JSType.TO_INT32_L);
    } else if (to.isBoolean()) {
      method.visitInsn(L2I);
    } else if (to.isObject()) {
      invokestatic(method, VALUE_OF);
    } else {
      assert false : "Illegal conversion " + this + " -> " + to;
    }

    return to;
  }

  @Override
  public Type add(MethodVisitor method, int programPoint) {
    throw new UnsupportedOperationException("add");
  }

  @Override
  public void ret(MethodVisitor method) {
    method.visitInsn(LRETURN);
  }

  @Override
  public Type loadUndefined(MethodVisitor method) {
    method.visitLdcInsn(JSType.UNDEFINED_LONG);
    return LONG;
  }

  @Override
  public Type loadForcedInitializer(MethodVisitor method) {
    method.visitInsn(LCONST_0);
    return LONG;
  }

  private static final long serialVersionUID = 1;
}
