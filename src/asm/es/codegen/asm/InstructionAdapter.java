package es.codegen.asm;

public class InstructionAdapter extends MethodVisitor {

  static final Type OBJECT_TYPE = Type.getType("Ljava/lang/Object;");

  public InstructionAdapter(MethodVisitor methodVisitor) {
    super(methodVisitor);
    if (getClass() != InstructionAdapter.class) {
      throw new IllegalStateException();
    }
  }

  @Override
  public void visitInsn(int opcode) {
    switch (opcode) {
      case Opcodes.NOP:
        nop();
        break;
      case Opcodes.ACONST_NULL:
        aconst(null);
        break;
      case Opcodes.ICONST_M1:
      case Opcodes.ICONST_0:
      case Opcodes.ICONST_1:
      case Opcodes.ICONST_2:
      case Opcodes.ICONST_3:
      case Opcodes.ICONST_4:
      case Opcodes.ICONST_5:
        iconst(opcode - Opcodes.ICONST_0);
        break;
      case Opcodes.LCONST_0:
      case Opcodes.LCONST_1:
        lconst((long) (opcode - Opcodes.LCONST_0));
        break;
      case Opcodes.FCONST_0:
      case Opcodes.FCONST_1:
      case Opcodes.FCONST_2:
        fconst((float) (opcode - Opcodes.FCONST_0));
        break;
      case Opcodes.DCONST_0:
      case Opcodes.DCONST_1:
        dconst((double) (opcode - Opcodes.DCONST_0));
        break;
      case Opcodes.IALOAD:
        aload(Type.INT_TYPE);
        break;
      case Opcodes.LALOAD:
        aload(Type.LONG_TYPE);
        break;
      case Opcodes.FALOAD:
        aload(Type.FLOAT_TYPE);
        break;
      case Opcodes.DALOAD:
        aload(Type.DOUBLE_TYPE);
        break;
      case Opcodes.AALOAD:
        aload(OBJECT_TYPE);
        break;
      case Opcodes.BALOAD:
        aload(Type.BYTE_TYPE);
        break;
      case Opcodes.CALOAD:
        aload(Type.CHAR_TYPE);
        break;
      case Opcodes.SALOAD:
        aload(Type.SHORT_TYPE);
        break;
      case Opcodes.IASTORE:
        astore(Type.INT_TYPE);
        break;
      case Opcodes.LASTORE:
        astore(Type.LONG_TYPE);
        break;
      case Opcodes.FASTORE:
        astore(Type.FLOAT_TYPE);
        break;
      case Opcodes.DASTORE:
        astore(Type.DOUBLE_TYPE);
        break;
      case Opcodes.AASTORE:
        astore(OBJECT_TYPE);
        break;
      case Opcodes.BASTORE:
        astore(Type.BYTE_TYPE);
        break;
      case Opcodes.CASTORE:
        astore(Type.CHAR_TYPE);
        break;
      case Opcodes.SASTORE:
        astore(Type.SHORT_TYPE);
        break;
      case Opcodes.POP:
        pop();
        break;
      case Opcodes.POP2:
        pop2();
        break;
      case Opcodes.DUP:
        dup();
        break;
      case Opcodes.DUP_X1:
        dupX1();
        break;
      case Opcodes.DUP_X2:
        dupX2();
        break;
      case Opcodes.DUP2:
        dup2();
        break;
      case Opcodes.DUP2_X1:
        dup2X1();
        break;
      case Opcodes.DUP2_X2:
        dup2X2();
        break;
      case Opcodes.SWAP:
        swap();
        break;
      case Opcodes.IADD:
        add(Type.INT_TYPE);
        break;
      case Opcodes.LADD:
        add(Type.LONG_TYPE);
        break;
      case Opcodes.FADD:
        add(Type.FLOAT_TYPE);
        break;
      case Opcodes.DADD:
        add(Type.DOUBLE_TYPE);
        break;
      case Opcodes.ISUB:
        sub(Type.INT_TYPE);
        break;
      case Opcodes.LSUB:
        sub(Type.LONG_TYPE);
        break;
      case Opcodes.FSUB:
        sub(Type.FLOAT_TYPE);
        break;
      case Opcodes.DSUB:
        sub(Type.DOUBLE_TYPE);
        break;
      case Opcodes.IMUL:
        mul(Type.INT_TYPE);
        break;
      case Opcodes.LMUL:
        mul(Type.LONG_TYPE);
        break;
      case Opcodes.FMUL:
        mul(Type.FLOAT_TYPE);
        break;
      case Opcodes.DMUL:
        mul(Type.DOUBLE_TYPE);
        break;
      case Opcodes.IDIV:
        div(Type.INT_TYPE);
        break;
      case Opcodes.LDIV:
        div(Type.LONG_TYPE);
        break;
      case Opcodes.FDIV:
        div(Type.FLOAT_TYPE);
        break;
      case Opcodes.DDIV:
        div(Type.DOUBLE_TYPE);
        break;
      case Opcodes.IREM:
        rem(Type.INT_TYPE);
        break;
      case Opcodes.LREM:
        rem(Type.LONG_TYPE);
        break;
      case Opcodes.FREM:
        rem(Type.FLOAT_TYPE);
        break;
      case Opcodes.DREM:
        rem(Type.DOUBLE_TYPE);
        break;
      case Opcodes.INEG:
        neg(Type.INT_TYPE);
        break;
      case Opcodes.LNEG:
        neg(Type.LONG_TYPE);
        break;
      case Opcodes.FNEG:
        neg(Type.FLOAT_TYPE);
        break;
      case Opcodes.DNEG:
        neg(Type.DOUBLE_TYPE);
        break;
      case Opcodes.ISHL:
        shl(Type.INT_TYPE);
        break;
      case Opcodes.LSHL:
        shl(Type.LONG_TYPE);
        break;
      case Opcodes.ISHR:
        shr(Type.INT_TYPE);
        break;
      case Opcodes.LSHR:
        shr(Type.LONG_TYPE);
        break;
      case Opcodes.IUSHR:
        ushr(Type.INT_TYPE);
        break;
      case Opcodes.LUSHR:
        ushr(Type.LONG_TYPE);
        break;
      case Opcodes.IAND:
        and(Type.INT_TYPE);
        break;
      case Opcodes.LAND:
        and(Type.LONG_TYPE);
        break;
      case Opcodes.IOR:
        or(Type.INT_TYPE);
        break;
      case Opcodes.LOR:
        or(Type.LONG_TYPE);
        break;
      case Opcodes.IXOR:
        xor(Type.INT_TYPE);
        break;
      case Opcodes.LXOR:
        xor(Type.LONG_TYPE);
        break;
      case Opcodes.I2L:
        cast(Type.INT_TYPE, Type.LONG_TYPE);
        break;
      case Opcodes.I2F:
        cast(Type.INT_TYPE, Type.FLOAT_TYPE);
        break;
      case Opcodes.I2D:
        cast(Type.INT_TYPE, Type.DOUBLE_TYPE);
        break;
      case Opcodes.L2I:
        cast(Type.LONG_TYPE, Type.INT_TYPE);
        break;
      case Opcodes.L2F:
        cast(Type.LONG_TYPE, Type.FLOAT_TYPE);
        break;
      case Opcodes.L2D:
        cast(Type.LONG_TYPE, Type.DOUBLE_TYPE);
        break;
      case Opcodes.F2I:
        cast(Type.FLOAT_TYPE, Type.INT_TYPE);
        break;
      case Opcodes.F2L:
        cast(Type.FLOAT_TYPE, Type.LONG_TYPE);
        break;
      case Opcodes.F2D:
        cast(Type.FLOAT_TYPE, Type.DOUBLE_TYPE);
        break;
      case Opcodes.D2I:
        cast(Type.DOUBLE_TYPE, Type.INT_TYPE);
        break;
      case Opcodes.D2L:
        cast(Type.DOUBLE_TYPE, Type.LONG_TYPE);
        break;
      case Opcodes.D2F:
        cast(Type.DOUBLE_TYPE, Type.FLOAT_TYPE);
        break;
      case Opcodes.I2B:
        cast(Type.INT_TYPE, Type.BYTE_TYPE);
        break;
      case Opcodes.I2C:
        cast(Type.INT_TYPE, Type.CHAR_TYPE);
        break;
      case Opcodes.I2S:
        cast(Type.INT_TYPE, Type.SHORT_TYPE);
        break;
      case Opcodes.LCMP:
        lcmp();
        break;
      case Opcodes.FCMPL:
        cmpl(Type.FLOAT_TYPE);
        break;
      case Opcodes.FCMPG:
        cmpg(Type.FLOAT_TYPE);
        break;
      case Opcodes.DCMPL:
        cmpl(Type.DOUBLE_TYPE);
        break;
      case Opcodes.DCMPG:
        cmpg(Type.DOUBLE_TYPE);
        break;
      case Opcodes.IRETURN:
        areturn(Type.INT_TYPE);
        break;
      case Opcodes.LRETURN:
        areturn(Type.LONG_TYPE);
        break;
      case Opcodes.FRETURN:
        areturn(Type.FLOAT_TYPE);
        break;
      case Opcodes.DRETURN:
        areturn(Type.DOUBLE_TYPE);
        break;
      case Opcodes.ARETURN:
        areturn(OBJECT_TYPE);
        break;
      case Opcodes.RETURN:
        areturn(Type.VOID_TYPE);
        break;
      case Opcodes.ARRAYLENGTH:
        arraylength();
        break;
      case Opcodes.ATHROW:
        athrow();
        break;
      case Opcodes.MONITORENTER:
        monitorenter();
        break;
      case Opcodes.MONITOREXIT:
        monitorexit();
        break;
      default:
        throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitIntInsn(int opcode, int operand) {
    switch (opcode) {
      case Opcodes.BIPUSH:
        iconst(operand);
        break;
      case Opcodes.SIPUSH:
        iconst(operand);
        break;
      case Opcodes.NEWARRAY:
        switch (operand) {
          case Opcodes.T_BOOLEAN:
            newarray(Type.BOOLEAN_TYPE);
            break;
          case Opcodes.T_CHAR:
            newarray(Type.CHAR_TYPE);
            break;
          case Opcodes.T_BYTE:
            newarray(Type.BYTE_TYPE);
            break;
          case Opcodes.T_SHORT:
            newarray(Type.SHORT_TYPE);
            break;
          case Opcodes.T_INT:
            newarray(Type.INT_TYPE);
            break;
          case Opcodes.T_FLOAT:
            newarray(Type.FLOAT_TYPE);
            break;
          case Opcodes.T_LONG:
            newarray(Type.LONG_TYPE);
            break;
          case Opcodes.T_DOUBLE:
            newarray(Type.DOUBLE_TYPE);
            break;
          default:
            throw new IllegalArgumentException();
        }
        break;
      default:
        throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitVarInsn(int opcode, int var) {
    switch (opcode) {
      case Opcodes.ILOAD:
        load(var, Type.INT_TYPE);
        break;
      case Opcodes.LLOAD:
        load(var, Type.LONG_TYPE);
        break;
      case Opcodes.FLOAD:
        load(var, Type.FLOAT_TYPE);
        break;
      case Opcodes.DLOAD:
        load(var, Type.DOUBLE_TYPE);
        break;
      case Opcodes.ALOAD:
        load(var, OBJECT_TYPE);
        break;
      case Opcodes.ISTORE:
        store(var, Type.INT_TYPE);
        break;
      case Opcodes.LSTORE:
        store(var, Type.LONG_TYPE);
        break;
      case Opcodes.FSTORE:
        store(var, Type.FLOAT_TYPE);
        break;
      case Opcodes.DSTORE:
        store(var, Type.DOUBLE_TYPE);
        break;
      case Opcodes.ASTORE:
        store(var, OBJECT_TYPE);
        break;
      case Opcodes.RET:
        ret(var);
        break;
      default:
        throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitTypeInsn(int opcode, String type) {
    Type objectType = Type.getObjectType(type);
    switch (opcode) {
      case Opcodes.NEW:
        anew(objectType);
        break;
      case Opcodes.ANEWARRAY:
        newarray(objectType);
        break;
      case Opcodes.CHECKCAST:
        checkcast(objectType);
        break;
      case Opcodes.INSTANCEOF:
        instanceOf(objectType);
        break;
      default:
        throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitFieldInsn(int opcode, String owner, String name, String descriptor) {
    switch (opcode) {
      case Opcodes.GETSTATIC:
        getstatic(owner, name, descriptor);
        break;
      case Opcodes.PUTSTATIC:
        putstatic(owner, name, descriptor);
        break;
      case Opcodes.GETFIELD:
        getfield(owner, name, descriptor);
        break;
      case Opcodes.PUTFIELD:
        putfield(owner, name, descriptor);
        break;
      default:
        throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitMethodInsn(int opcode, String owner, String name, String descriptor, boolean isInterface) {
    doVisitMethodInsn(opcode, owner, name, descriptor, isInterface);
  }

  void doVisitMethodInsn(int opcode, String owner, String name, String descriptor, boolean isInterface) {
    switch (opcode) {
      case Opcodes.INVOKESPECIAL:
        invokespecial(owner, name, descriptor, isInterface);
        break;
      case Opcodes.INVOKEVIRTUAL:
        invokevirtual(owner, name, descriptor, isInterface);
        break;
      case Opcodes.INVOKESTATIC:
        invokestatic(owner, name, descriptor, isInterface);
        break;
      case Opcodes.INVOKEINTERFACE:
        invokeinterface(owner, name, descriptor);
        break;
      default:
        throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitInvokeDynamicInsn(String name, String descriptor, Handle bootstrapMethodHandle, Object... bootstrapMethodArguments) {
    invokedynamic(name, descriptor, bootstrapMethodHandle, bootstrapMethodArguments);
  }

  @Override
  public void visitJumpInsn(int opcode, Label label) {
    switch (opcode) {
      case Opcodes.IFEQ:
        ifeq(label);
        break;
      case Opcodes.IFNE:
        ifne(label);
        break;
      case Opcodes.IFLT:
        iflt(label);
        break;
      case Opcodes.IFGE:
        ifge(label);
        break;
      case Opcodes.IFGT:
        ifgt(label);
        break;
      case Opcodes.IFLE:
        ifle(label);
        break;
      case Opcodes.IF_ICMPEQ:
        ificmpeq(label);
        break;
      case Opcodes.IF_ICMPNE:
        ificmpne(label);
        break;
      case Opcodes.IF_ICMPLT:
        ificmplt(label);
        break;
      case Opcodes.IF_ICMPGE:
        ificmpge(label);
        break;
      case Opcodes.IF_ICMPGT:
        ificmpgt(label);
        break;
      case Opcodes.IF_ICMPLE:
        ificmple(label);
        break;
      case Opcodes.IF_ACMPEQ:
        ifacmpeq(label);
        break;
      case Opcodes.IF_ACMPNE:
        ifacmpne(label);
        break;
      case Opcodes.GOTO:
        goTo(label);
        break;
      case Opcodes.JSR:
        jsr(label);
        break;
      case Opcodes.IFNULL:
        ifnull(label);
        break;
      case Opcodes.IFNONNULL:
        ifnonnull(label);
        break;
      default:
        throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitLabel(Label label) {
    mark(label);
  }

  @Override
  public void visitLdcInsn(Object value) {
    if (value instanceof Integer) {
      iconst((Integer) value);
    } else if (value instanceof Byte) {
      iconst(((Byte) value).intValue());
    } else if (value instanceof Character) {
      iconst(((Character) value).charValue());
    } else if (value instanceof Short) {
      iconst(((Short) value).intValue());
    } else if (value instanceof Boolean) {
      iconst(((Boolean) value).booleanValue() ? 1 : 0);
    } else if (value instanceof Float) {
      fconst((Float) value);
    } else if (value instanceof Long) {
      lconst((Long) value);
    } else if (value instanceof Double) {
      dconst((Double) value);
    } else if (value instanceof String) {
      aconst(value);
    } else if (value instanceof Type) {
      tconst((Type) value);
    } else if (value instanceof Handle) {
      hconst((Handle) value);
    } else if (value instanceof ConstantDynamic) {
      cconst((ConstantDynamic) value);
    } else {
      throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitIincInsn(int var, int increment) {
    iinc(var, increment);
  }

  @Override
  public void visitTableSwitchInsn(int min, int max, Label dflt, Label... labels) {
    tableswitch(min, max, dflt, labels);
  }

  @Override
  public void visitLookupSwitchInsn(Label dflt, int[] keys, Label[] labels) {
    lookupswitch(dflt, keys, labels);
  }

  @Override
  public void visitMultiANewArrayInsn(String descriptor, int numDimensions) {
    multianewarray(descriptor, numDimensions);
  }

  void nop() {
    mv.visitInsn(Opcodes.NOP);
  }

  public void aconst(Object value) {
    if (value == null) {
      mv.visitInsn(Opcodes.ACONST_NULL);
    } else {
      mv.visitLdcInsn(value);
    }
  }

  public void iconst(int intValue) {
    if (intValue >= -1 && intValue <= 5) {
      mv.visitInsn(Opcodes.ICONST_0 + intValue);
    } else if (intValue >= Byte.MIN_VALUE && intValue <= Byte.MAX_VALUE) {
      mv.visitIntInsn(Opcodes.BIPUSH, intValue);
    } else if (intValue >= Short.MIN_VALUE && intValue <= Short.MAX_VALUE) {
      mv.visitIntInsn(Opcodes.SIPUSH, intValue);
    } else {
      mv.visitLdcInsn(intValue);
    }
  }

  void lconst(long longValue) {
    if (longValue == 0L || longValue == 1L) {
      mv.visitInsn(Opcodes.LCONST_0 + (int) longValue);
    } else {
      mv.visitLdcInsn(longValue);
    }
  }

  void fconst(float floatValue) {
    int bits = Float.floatToIntBits(floatValue);
    if (bits == 0L || bits == 0x3F800000 || bits == 0x40000000) { // 0..2
      mv.visitInsn(Opcodes.FCONST_0 + (int) floatValue);
    } else {
      mv.visitLdcInsn(floatValue);
    }
  }

  void dconst(double doubleValue) {
    long bits = Double.doubleToLongBits(doubleValue);
    if (bits == 0L || bits == 0x3FF0000000000000L) { // +0.0d and 1.0d
      mv.visitInsn(Opcodes.DCONST_0 + (int) doubleValue);
    } else {
      mv.visitLdcInsn(doubleValue);
    }
  }

  void tconst(Type type) {
    mv.visitLdcInsn(type);
  }

  void hconst(Handle handle) {
    mv.visitLdcInsn(handle);
  }

  void cconst(ConstantDynamic constantDynamic) {
    mv.visitLdcInsn(constantDynamic);
  }

  public void load(int var, Type type) {
    mv.visitVarInsn(type.getOpcode(Opcodes.ILOAD), var);
  }

  void aload(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IALOAD));
  }

  void store(int var, Type type) {
    mv.visitVarInsn(type.getOpcode(Opcodes.ISTORE), var);
  }

  void astore(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IASTORE));
  }

  public void pop() {
    mv.visitInsn(Opcodes.POP);
  }

  public void pop2() {
    mv.visitInsn(Opcodes.POP2);
  }

  public void dup() {
    mv.visitInsn(Opcodes.DUP);
  }

  void dup2() {
    mv.visitInsn(Opcodes.DUP2);
  }

  void dupX1() {
    mv.visitInsn(Opcodes.DUP_X1);
  }

  void dupX2() {
    mv.visitInsn(Opcodes.DUP_X2);
  }

  void dup2X1() {
    mv.visitInsn(Opcodes.DUP2_X1);
  }

  void dup2X2() {
    mv.visitInsn(Opcodes.DUP2_X2);
  }

  public void swap() {
    mv.visitInsn(Opcodes.SWAP);
  }

  void add(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IADD));
  }

  void sub(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.ISUB));
  }

  void mul(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IMUL));
  }

  void div(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IDIV));
  }

  void rem(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IREM));
  }

  void neg(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.INEG));
  }

  void shl(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.ISHL));
  }

  void shr(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.ISHR));
  }

  void ushr(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IUSHR));
  }

  void and(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IAND));
  }

  void or(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IOR));
  }

  void xor(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IXOR));
  }

  void iinc(int var, int increment) {
    mv.visitIincInsn(var, increment);
  }

  void cast(Type from, Type to) {
    if (from != to) {
      if (from == Type.DOUBLE_TYPE) {
        if (to == Type.FLOAT_TYPE) {
          mv.visitInsn(Opcodes.D2F);
        } else if (to == Type.LONG_TYPE) {
          mv.visitInsn(Opcodes.D2L);
        } else {
          mv.visitInsn(Opcodes.D2I);
          cast(Type.INT_TYPE, to);
        }
      } else if (from == Type.FLOAT_TYPE) {
        if (to == Type.DOUBLE_TYPE) {
          mv.visitInsn(Opcodes.F2D);
        } else if (to == Type.LONG_TYPE) {
          mv.visitInsn(Opcodes.F2L);
        } else {
          mv.visitInsn(Opcodes.F2I);
          cast(Type.INT_TYPE, to);
        }
      } else if (from == Type.LONG_TYPE) {
        if (to == Type.DOUBLE_TYPE) {
          mv.visitInsn(Opcodes.L2D);
        } else if (to == Type.FLOAT_TYPE) {
          mv.visitInsn(Opcodes.L2F);
        } else {
          mv.visitInsn(Opcodes.L2I);
          cast(Type.INT_TYPE, to);
        }
      } else {
        if (to == Type.BYTE_TYPE) {
          mv.visitInsn(Opcodes.I2B);
        } else if (to == Type.CHAR_TYPE) {
          mv.visitInsn(Opcodes.I2C);
        } else if (to == Type.DOUBLE_TYPE) {
          mv.visitInsn(Opcodes.I2D);
        } else if (to == Type.FLOAT_TYPE) {
          mv.visitInsn(Opcodes.I2F);
        } else if (to == Type.LONG_TYPE) {
          mv.visitInsn(Opcodes.I2L);
        } else if (to == Type.SHORT_TYPE) {
          mv.visitInsn(Opcodes.I2S);
        }
      }
    }
  }

  void lcmp() {
    mv.visitInsn(Opcodes.LCMP);
  }

  void cmpl(Type type) {
    mv.visitInsn(type == Type.FLOAT_TYPE ? Opcodes.FCMPL : Opcodes.DCMPL);
  }

  void cmpg(Type type) {
    mv.visitInsn(type == Type.FLOAT_TYPE ? Opcodes.FCMPG : Opcodes.DCMPG);
  }

  public void ifeq(Label label) {
    mv.visitJumpInsn(Opcodes.IFEQ, label);
  }

  public void ifne(Label label) {
    mv.visitJumpInsn(Opcodes.IFNE, label);
  }

  void iflt(Label label) {
    mv.visitJumpInsn(Opcodes.IFLT, label);
  }

  void ifge(Label label) {
    mv.visitJumpInsn(Opcodes.IFGE, label);
  }

  void ifgt(Label label) {
    mv.visitJumpInsn(Opcodes.IFGT, label);
  }

  void ifle(Label label) {
    mv.visitJumpInsn(Opcodes.IFLE, label);
  }

  void ificmpeq(Label label) {
    mv.visitJumpInsn(Opcodes.IF_ICMPEQ, label);
  }

  void ificmpne(Label label) {
    mv.visitJumpInsn(Opcodes.IF_ICMPNE, label);
  }

  void ificmplt(Label label) {
    mv.visitJumpInsn(Opcodes.IF_ICMPLT, label);
  }

  void ificmpge(Label label) {
    mv.visitJumpInsn(Opcodes.IF_ICMPGE, label);
  }

  void ificmpgt(Label label) {
    mv.visitJumpInsn(Opcodes.IF_ICMPGT, label);
  }

  void ificmple(Label label) {
    mv.visitJumpInsn(Opcodes.IF_ICMPLE, label);
  }

  void ifacmpeq(Label label) {
    mv.visitJumpInsn(Opcodes.IF_ACMPEQ, label);
  }

  void ifacmpne(Label label) {
    mv.visitJumpInsn(Opcodes.IF_ACMPNE, label);
  }

  public void goTo(Label label) {
    mv.visitJumpInsn(Opcodes.GOTO, label);
  }

  void jsr(Label label) {
    mv.visitJumpInsn(Opcodes.JSR, label);
  }

  void ret(int var) {
    mv.visitVarInsn(Opcodes.RET, var);
  }

  void tableswitch(int min, int max, Label dflt, Label... labels) {
    mv.visitTableSwitchInsn(min, max, dflt, labels);
  }

  void lookupswitch(Label dflt, int[] keys, Label[] labels) {
    mv.visitLookupSwitchInsn(dflt, keys, labels);
  }

  public void areturn(Type type) {
    mv.visitInsn(type.getOpcode(Opcodes.IRETURN));
  }

  public void getstatic(String owner, String name, String descriptor) {
    mv.visitFieldInsn(Opcodes.GETSTATIC, owner, name, descriptor);
  }

  public void putstatic(String owner, String name, String descriptor) {
    mv.visitFieldInsn(Opcodes.PUTSTATIC, owner, name, descriptor);
  }

  public void getfield(String owner, String name, String descriptor) {
    mv.visitFieldInsn(Opcodes.GETFIELD, owner, name, descriptor);
  }

  public void putfield(String owner, String name, String descriptor) {
    mv.visitFieldInsn(Opcodes.PUTFIELD, owner, name, descriptor);
  }

  public void invokevirtual(String owner, String name, String descriptor, boolean isInterface) {
    mv.visitMethodInsn(Opcodes.INVOKEVIRTUAL, owner, name, descriptor, isInterface);
  }

  public void invokespecial(String owner, String name, String descriptor, boolean isInterface) {
    mv.visitMethodInsn(Opcodes.INVOKESPECIAL, owner, name, descriptor, isInterface);
  }

  void invokestatic(String owner, String name, String descriptor, boolean isInterface) {
    mv.visitMethodInsn(Opcodes.INVOKESTATIC, owner, name, descriptor, isInterface);
  }

  void invokeinterface(String owner, String name, String descriptor) {
    mv.visitMethodInsn(Opcodes.INVOKEINTERFACE, owner, name, descriptor, true);
  }

  void invokedynamic(String name, String descriptor, Handle bootstrapMethodHandle, Object[] bootstrapMethodArguments) {
    mv.visitInvokeDynamicInsn(name, descriptor, bootstrapMethodHandle, bootstrapMethodArguments);
  }

  void anew(Type type) {
    mv.visitTypeInsn(Opcodes.NEW, type.getInternalName());
  }

  void newarray(Type type) {
    int arrayType;
    switch (type.getSort()) {
      case Type.BOOLEAN:
        arrayType = Opcodes.T_BOOLEAN;
        break;
      case Type.CHAR:
        arrayType = Opcodes.T_CHAR;
        break;
      case Type.BYTE:
        arrayType = Opcodes.T_BYTE;
        break;
      case Type.SHORT:
        arrayType = Opcodes.T_SHORT;
        break;
      case Type.INT:
        arrayType = Opcodes.T_INT;
        break;
      case Type.FLOAT:
        arrayType = Opcodes.T_FLOAT;
        break;
      case Type.LONG:
        arrayType = Opcodes.T_LONG;
        break;
      case Type.DOUBLE:
        arrayType = Opcodes.T_DOUBLE;
        break;
      default:
        mv.visitTypeInsn(Opcodes.ANEWARRAY, type.getInternalName());
        return;
    }
    mv.visitIntInsn(Opcodes.NEWARRAY, arrayType);
  }

  void arraylength() {
    mv.visitInsn(Opcodes.ARRAYLENGTH);
  }

  public void athrow() {
    mv.visitInsn(Opcodes.ATHROW);
  }

  public void checkcast(Type type) {
    mv.visitTypeInsn(Opcodes.CHECKCAST, type.getInternalName());
  }

  public void instanceOf(Type type) {
    mv.visitTypeInsn(Opcodes.INSTANCEOF, type.getInternalName());
  }

  void monitorenter() {
    mv.visitInsn(Opcodes.MONITORENTER);
  }

  void monitorexit() {
    mv.visitInsn(Opcodes.MONITOREXIT);
  }

  void multianewarray(String descriptor, int numDimensions) {
    mv.visitMultiANewArrayInsn(descriptor, numDimensions);
  }

  public void ifnull(Label label) {
    mv.visitJumpInsn(Opcodes.IFNULL, label);
  }

  public void ifnonnull(Label label) {
    mv.visitJumpInsn(Opcodes.IFNONNULL, label);
  }

  void mark(Label label) {
    mv.visitLabel(label);
  }
}
