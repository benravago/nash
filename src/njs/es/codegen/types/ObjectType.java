package es.codegen.types;

import org.objectweb.asm.Handle;
import org.objectweb.asm.MethodVisitor;
import static org.objectweb.asm.Opcodes.*;

import java.lang.invoke.MethodHandle;

import es.runtime.JSType;
import es.runtime.ScriptRuntime;
import es.runtime.Undefined;
import es.codegen.CompilerConstants;
import static es.codegen.CompilerConstants.className;
import static es.codegen.CompilerConstants.typeDescriptor;

/**
 * Type class: OBJECT This is the object type, used for all object types.
 * It can contain a class that is a more specialized object
 */
class ObjectType extends Type {

  protected ObjectType() {
    this(Object.class);
  }

  protected ObjectType(Class<?> type) {
    super("object", type, (type == Object.class ? Type.MAX_WEIGHT : 10), 1);
  }

  @Override
  public String toString() {
    return "object" + (getTypeClass() != Object.class ? "<type=" + getTypeClass().getSimpleName() + '>' : "");
  }

  @Override
  public String getShortDescriptor() {
    return getTypeClass() == Object.class ? "Object" : getTypeClass().getSimpleName();
  }

  @Override
  public Type add(MethodVisitor method, int programPoint) {
    invokestatic(method, ScriptRuntime.ADD);
    return Type.OBJECT;
  }

  @Override
  public Type load(MethodVisitor method, int slot) {
    assert slot != -1;
    method.visitVarInsn(ALOAD, slot);
    return this;
  }

  @Override
  public void store(MethodVisitor method, int slot) {
    assert slot != -1;
    method.visitVarInsn(ASTORE, slot);
  }

  @Override
  public Type loadUndefined(MethodVisitor method) {
    method.visitFieldInsn(GETSTATIC, className(ScriptRuntime.class), "UNDEFINED", typeDescriptor(Undefined.class));
    return UNDEFINED;
  }

  @Override
  public Type loadForcedInitializer(MethodVisitor method) {
    method.visitInsn(ACONST_NULL);
    // TODO: do we need a special type for null, e.g. Type.NULL?
    // It should be assignable to any other object type without a checkast in convert.
    return OBJECT;
  }

  @Override
  public Type loadEmpty(MethodVisitor method) {
    method.visitFieldInsn(GETSTATIC, className(ScriptRuntime.class), "EMPTY", typeDescriptor(Undefined.class));
    return UNDEFINED;
  }

  @Override
  public Type ldc(MethodVisitor method, Object c) {
    if (c == null) {
      method.visitInsn(ACONST_NULL);
    } else if (c instanceof Undefined) {
      return loadUndefined(method);
    } else if (c instanceof String) {
      method.visitLdcInsn(c);
      return STRING;
    } else if (c instanceof Handle) {
      method.visitLdcInsn(c);
      return Type.typeFor(MethodHandle.class);
    } else {
      throw new UnsupportedOperationException("implementation missing for class " + c.getClass() + " value=" + c);
    }

    return Type.OBJECT;
  }

  @Override
  public Type convert(MethodVisitor method, Type to) {
    var toString = to.isString();
    if (!toString) {
      if (to.isArray()) {
        var elemType = ((ArrayType) to).getElementType();

        // note that if this an array, things won't work. see {link @ArrayType} subclass.
        // we also have the unpleasant case of NativeArray which looks like an Object, but is an array to the type system.
        // This is treated specially at the known load points
        if (elemType.isString()) {
          method.visitTypeInsn(CHECKCAST, CompilerConstants.className(String[].class));
        } else if (elemType.isNumber()) {
          method.visitTypeInsn(CHECKCAST, CompilerConstants.className(double[].class));
        } else if (elemType.isLong()) {
          method.visitTypeInsn(CHECKCAST, CompilerConstants.className(long[].class));
        } else if (elemType.isInteger()) {
          method.visitTypeInsn(CHECKCAST, CompilerConstants.className(int[].class));
        } else {
          method.visitTypeInsn(CHECKCAST, CompilerConstants.className(Object[].class));
        }
        return to;
      } else if (to.isObject()) {
        var toClass = to.getTypeClass();
        if (!toClass.isAssignableFrom(getTypeClass())) {
          method.visitTypeInsn(CHECKCAST, CompilerConstants.className(toClass));
        }
        return to;
      }
    } else if (isString()) {
      return to;
    }

    if (to.isInteger()) {
      invokestatic(method, JSType.TO_INT32);
    } else if (to.isNumber()) {
      invokestatic(method, JSType.TO_NUMBER);
    } else if (to.isLong()) {
      invokestatic(method, JSType.TO_LONG);
    } else if (to.isBoolean()) {
      invokestatic(method, JSType.TO_BOOLEAN);
    } else if (to.isString()) {
      invokestatic(method, JSType.TO_PRIMITIVE_TO_STRING);
    } else if (to.isCharSequence()) {
      invokestatic(method, JSType.TO_PRIMITIVE_TO_CHARSEQUENCE);
    } else {
      throw new UnsupportedOperationException("Illegal conversion " + this + " -> " + to + " " + isString() + " " + toString);
    }

    return to;
  }

  @Override
  public void ret(MethodVisitor method) {
    method.visitInsn(ARETURN);
  }

  @Override
  public char getBytecodeStackType() {
    return 'A';
  }

  private static final long serialVersionUID = 1L;
}
