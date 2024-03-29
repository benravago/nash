package es.codegen.types;

import es.codegen.asm.MethodVisitor;
import static es.codegen.asm.Opcodes.*;

import es.runtime.JSType;
import es.codegen.CompilerConstants;
import static es.codegen.CompilerConstants.staticCallNoLookup;

class NumberType extends NumericType {

  private static final CompilerConstants.Call VALUE_OF = staticCallNoLookup(Double.class, "valueOf", Double.class, double.class);

  protected NumberType() {
    super("double", double.class, 4, 2);
  }

  @Override
  public Type nextWider() {
    return OBJECT;
  }

  @Override
  public Class<?> getBoxedType() {
    return Double.class;
  }

  @Override
  public char getBytecodeStackType() {
    return 'D';
  }

  @Override
  public Type cmp(MethodVisitor method, boolean isCmpG) {
    method.visitInsn(isCmpG ? DCMPG : DCMPL);
    return INT;
  }

  @Override
  public Type load(MethodVisitor method, int slot) {
    assert slot != -1;
    method.visitVarInsn(DLOAD, slot);
    return NUMBER;
  }

  @Override
  public void store(MethodVisitor method, int slot) {
    assert slot != -1;
    method.visitVarInsn(DSTORE, slot);
  }

  @Override
  public Type loadUndefined(MethodVisitor method) {
    method.visitLdcInsn(JSType.UNDEFINED_DOUBLE);
    return NUMBER;
  }

  @Override
  public Type loadForcedInitializer(MethodVisitor method) {
    method.visitInsn(DCONST_0);
    return NUMBER;
  }

  @Override
  public Type ldc(MethodVisitor method, Object c) {
    assert c instanceof Double;

    double value = (Double) c;

    if (Double.doubleToLongBits(value) == 0L) { // guard against -0.0
      method.visitInsn(DCONST_0);
    } else if (value == 1.0) {
      method.visitInsn(DCONST_1);
    } else {
      method.visitLdcInsn(value);
    }

    return NUMBER;
  }

  @Override
  public Type convert(MethodVisitor method, Type to) {
    if (isEquivalentTo(to)) {
      return null;
    }

    if (to.isInteger()) {
      invokestatic(method, JSType.TO_INT32_D);
    } else if (to.isLong()) {
      invokestatic(method, JSType.TO_LONG_D);
    } else if (to.isBoolean()) {
      invokestatic(method, JSType.TO_BOOLEAN_D);
    } else if (to.isString()) {
      invokestatic(method, JSType.TO_STRING_D);
    } else if (to.isObject()) {
      invokestatic(method, VALUE_OF);
    } else {
      throw new UnsupportedOperationException("Illegal conversion " + this + " -> " + to);
    }

    return to;
  }

  @Override
  public Type add(MethodVisitor method, int programPoint) {
    method.visitInsn(DADD);
    return NUMBER;
  }

  @Override
  public Type sub(MethodVisitor method, int programPoint) {
    method.visitInsn(DSUB);
    return NUMBER;
  }

  @Override
  public Type mul(MethodVisitor method, int programPoint) {
    method.visitInsn(DMUL);
    return NUMBER;
  }

  @Override
  public Type div(MethodVisitor method, int programPoint) {
    method.visitInsn(DDIV);
    return NUMBER;
  }

  @Override
  public Type rem(MethodVisitor method, int programPoint) {
    method.visitInsn(DREM);
    return NUMBER;
  }

  @Override
  public Type neg(MethodVisitor method, int programPoint) {
    method.visitInsn(DNEG);
    return NUMBER;
  }

  @Override
  public void ret(MethodVisitor method) {
    method.visitInsn(DRETURN);
  }

  private static final long serialVersionUID = 1;
}
