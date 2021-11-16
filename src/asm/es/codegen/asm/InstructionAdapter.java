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
      case Opcodes.NOP -> nop();
      case Opcodes.ACONST_NULL -> aconst(null);
      case Opcodes.ICONST_M1, Opcodes.ICONST_0, Opcodes.ICONST_1, Opcodes.ICONST_2, Opcodes.ICONST_3, Opcodes.ICONST_4, Opcodes.ICONST_5 -> iconst(opcode - Opcodes.ICONST_0);
      case Opcodes.LCONST_0, Opcodes.LCONST_1 -> lconst((long) (opcode - Opcodes.LCONST_0));
      case Opcodes.FCONST_0, Opcodes.FCONST_1, Opcodes.FCONST_2 -> fconst((float) (opcode - Opcodes.FCONST_0));
      case Opcodes.DCONST_0, Opcodes.DCONST_1 -> dconst((double) (opcode - Opcodes.DCONST_0));
      case Opcodes.IALOAD -> aload(Type.INT_TYPE);
      case Opcodes.LALOAD -> aload(Type.LONG_TYPE);
      case Opcodes.FALOAD -> aload(Type.FLOAT_TYPE);
      case Opcodes.DALOAD -> aload(Type.DOUBLE_TYPE);
      case Opcodes.AALOAD -> aload(OBJECT_TYPE);
      case Opcodes.BALOAD -> aload(Type.BYTE_TYPE);
      case Opcodes.CALOAD -> aload(Type.CHAR_TYPE);
      case Opcodes.SALOAD -> aload(Type.SHORT_TYPE);
      case Opcodes.IASTORE -> astore(Type.INT_TYPE);
      case Opcodes.LASTORE -> astore(Type.LONG_TYPE);
      case Opcodes.FASTORE -> astore(Type.FLOAT_TYPE);
      case Opcodes.DASTORE -> astore(Type.DOUBLE_TYPE);
      case Opcodes.AASTORE -> astore(OBJECT_TYPE);
      case Opcodes.BASTORE -> astore(Type.BYTE_TYPE);
      case Opcodes.CASTORE -> astore(Type.CHAR_TYPE);
      case Opcodes.SASTORE -> astore(Type.SHORT_TYPE);
      case Opcodes.POP -> pop();
      case Opcodes.POP2 -> pop2();
      case Opcodes.DUP -> dup();
      case Opcodes.DUP_X1 -> dupX1();
      case Opcodes.DUP_X2 -> dupX2();
      case Opcodes.DUP2 -> dup2();
      case Opcodes.DUP2_X1 -> dup2X1();
      case Opcodes.DUP2_X2 -> dup2X2();
      case Opcodes.SWAP -> swap();
      case Opcodes.IADD -> add(Type.INT_TYPE);
      case Opcodes.LADD -> add(Type.LONG_TYPE);
      case Opcodes.FADD -> add(Type.FLOAT_TYPE);
      case Opcodes.DADD -> add(Type.DOUBLE_TYPE);
      case Opcodes.ISUB -> sub(Type.INT_TYPE);
      case Opcodes.LSUB -> sub(Type.LONG_TYPE);
      case Opcodes.FSUB -> sub(Type.FLOAT_TYPE);
      case Opcodes.DSUB -> sub(Type.DOUBLE_TYPE);
      case Opcodes.IMUL -> mul(Type.INT_TYPE);
      case Opcodes.LMUL -> mul(Type.LONG_TYPE);
      case Opcodes.FMUL -> mul(Type.FLOAT_TYPE);
      case Opcodes.DMUL -> mul(Type.DOUBLE_TYPE);
      case Opcodes.IDIV -> div(Type.INT_TYPE);
      case Opcodes.LDIV -> div(Type.LONG_TYPE);
      case Opcodes.FDIV -> div(Type.FLOAT_TYPE);
      case Opcodes.DDIV -> div(Type.DOUBLE_TYPE);
      case Opcodes.IREM -> rem(Type.INT_TYPE);
      case Opcodes.LREM -> rem(Type.LONG_TYPE);
      case Opcodes.FREM -> rem(Type.FLOAT_TYPE);
      case Opcodes.DREM -> rem(Type.DOUBLE_TYPE);
      case Opcodes.INEG -> neg(Type.INT_TYPE);
      case Opcodes.LNEG -> neg(Type.LONG_TYPE);
      case Opcodes.FNEG -> neg(Type.FLOAT_TYPE);
      case Opcodes.DNEG -> neg(Type.DOUBLE_TYPE);
      case Opcodes.ISHL -> shl(Type.INT_TYPE);
      case Opcodes.LSHL -> shl(Type.LONG_TYPE);
      case Opcodes.ISHR -> shr(Type.INT_TYPE);
      case Opcodes.LSHR -> shr(Type.LONG_TYPE);
      case Opcodes.IUSHR -> ushr(Type.INT_TYPE);
      case Opcodes.LUSHR -> ushr(Type.LONG_TYPE);
      case Opcodes.IAND -> and(Type.INT_TYPE);
      case Opcodes.LAND -> and(Type.LONG_TYPE);
      case Opcodes.IOR -> or(Type.INT_TYPE);
      case Opcodes.LOR -> or(Type.LONG_TYPE);
      case Opcodes.IXOR -> xor(Type.INT_TYPE);
      case Opcodes.LXOR -> xor(Type.LONG_TYPE);
      case Opcodes.I2L -> cast(Type.INT_TYPE, Type.LONG_TYPE);
      case Opcodes.I2F -> cast(Type.INT_TYPE, Type.FLOAT_TYPE);
      case Opcodes.I2D -> cast(Type.INT_TYPE, Type.DOUBLE_TYPE);
      case Opcodes.L2I -> cast(Type.LONG_TYPE, Type.INT_TYPE);
      case Opcodes.L2F -> cast(Type.LONG_TYPE, Type.FLOAT_TYPE);
      case Opcodes.L2D -> cast(Type.LONG_TYPE, Type.DOUBLE_TYPE);
      case Opcodes.F2I -> cast(Type.FLOAT_TYPE, Type.INT_TYPE);
      case Opcodes.F2L -> cast(Type.FLOAT_TYPE, Type.LONG_TYPE);
      case Opcodes.F2D -> cast(Type.FLOAT_TYPE, Type.DOUBLE_TYPE);
      case Opcodes.D2I -> cast(Type.DOUBLE_TYPE, Type.INT_TYPE);
      case Opcodes.D2L -> cast(Type.DOUBLE_TYPE, Type.LONG_TYPE);
      case Opcodes.D2F -> cast(Type.DOUBLE_TYPE, Type.FLOAT_TYPE);
      case Opcodes.I2B -> cast(Type.INT_TYPE, Type.BYTE_TYPE);
      case Opcodes.I2C -> cast(Type.INT_TYPE, Type.CHAR_TYPE);
      case Opcodes.I2S -> cast(Type.INT_TYPE, Type.SHORT_TYPE);
      case Opcodes.LCMP -> lcmp();
      case Opcodes.FCMPL -> cmpl(Type.FLOAT_TYPE);
      case Opcodes.FCMPG -> cmpg(Type.FLOAT_TYPE);
      case Opcodes.DCMPL -> cmpl(Type.DOUBLE_TYPE);
      case Opcodes.DCMPG -> cmpg(Type.DOUBLE_TYPE);
      case Opcodes.IRETURN -> areturn(Type.INT_TYPE);
      case Opcodes.LRETURN -> areturn(Type.LONG_TYPE);
      case Opcodes.FRETURN -> areturn(Type.FLOAT_TYPE);
      case Opcodes.DRETURN -> areturn(Type.DOUBLE_TYPE);
      case Opcodes.ARETURN -> areturn(OBJECT_TYPE);
      case Opcodes.RETURN -> areturn(Type.VOID_TYPE);
      case Opcodes.ARRAYLENGTH -> arraylength();
      case Opcodes.ATHROW -> athrow();
      case Opcodes.MONITORENTER -> monitorenter();
      case Opcodes.MONITOREXIT -> monitorexit();
      default -> throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitIntInsn(int opcode, int operand) {
    switch (opcode) {
      case Opcodes.BIPUSH -> iconst(operand);
      case Opcodes.SIPUSH -> iconst(operand);
      case Opcodes.NEWARRAY -> {
        switch (operand) {
          case Opcodes.T_BOOLEAN -> newarray(Type.BOOLEAN_TYPE);
          case Opcodes.T_CHAR -> newarray(Type.CHAR_TYPE);
          case Opcodes.T_BYTE -> newarray(Type.BYTE_TYPE);
          case Opcodes.T_SHORT -> newarray(Type.SHORT_TYPE);
          case Opcodes.T_INT -> newarray(Type.INT_TYPE);
          case Opcodes.T_FLOAT -> newarray(Type.FLOAT_TYPE);
          case Opcodes.T_LONG -> newarray(Type.LONG_TYPE);
          case Opcodes.T_DOUBLE -> newarray(Type.DOUBLE_TYPE);
          default -> throw new IllegalArgumentException();
        }
      }
      default -> throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitVarInsn(int opcode, int var) {
    switch (opcode) {
      case Opcodes.ILOAD -> load(var, Type.INT_TYPE);
      case Opcodes.LLOAD -> load(var, Type.LONG_TYPE);
      case Opcodes.FLOAD -> load(var, Type.FLOAT_TYPE);
      case Opcodes.DLOAD -> load(var, Type.DOUBLE_TYPE);
      case Opcodes.ALOAD -> load(var, OBJECT_TYPE);
      case Opcodes.ISTORE -> store(var, Type.INT_TYPE);
      case Opcodes.LSTORE -> store(var, Type.LONG_TYPE);
      case Opcodes.FSTORE -> store(var, Type.FLOAT_TYPE);
      case Opcodes.DSTORE -> store(var, Type.DOUBLE_TYPE);
      case Opcodes.ASTORE -> store(var, OBJECT_TYPE);
      case Opcodes.RET -> ret(var);
      default -> throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitTypeInsn(int opcode, String type) {
    Type objectType = Type.getObjectType(type);
    switch (opcode) {
      case Opcodes.NEW -> anew(objectType);
      case Opcodes.ANEWARRAY -> newarray(objectType);
      case Opcodes.CHECKCAST -> checkcast(objectType);
      case Opcodes.INSTANCEOF -> instanceOf(objectType);
      default -> throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitFieldInsn(int opcode, String owner, String name, String descriptor) {
    switch (opcode) {
      case Opcodes.GETSTATIC -> getstatic(owner, name, descriptor);
      case Opcodes.PUTSTATIC -> putstatic(owner, name, descriptor);
      case Opcodes.GETFIELD -> getfield(owner, name, descriptor);
      case Opcodes.PUTFIELD -> putfield(owner, name, descriptor);
      default -> throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitMethodInsn(int opcode, String owner, String name, String descriptor, boolean isInterface) {
    doVisitMethodInsn(opcode, owner, name, descriptor, isInterface);
  }

  void doVisitMethodInsn(int opcode, String owner, String name, String descriptor, boolean isInterface) {
    switch (opcode) {
      case Opcodes.INVOKESPECIAL -> invokespecial(owner, name, descriptor, isInterface);
      case Opcodes.INVOKEVIRTUAL -> invokevirtual(owner, name, descriptor, isInterface);
      case Opcodes.INVOKESTATIC -> invokestatic(owner, name, descriptor, isInterface);
      case Opcodes.INVOKEINTERFACE -> invokeinterface(owner, name, descriptor);
      default -> throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitInvokeDynamicInsn(String name, String descriptor, Handle bootstrapMethodHandle, Object... bootstrapMethodArguments) {
    invokedynamic(name, descriptor, bootstrapMethodHandle, bootstrapMethodArguments);
  }

  @Override
  public void visitJumpInsn(int opcode, Label label) {
    switch (opcode) {
      case Opcodes.IFEQ -> ifeq(label);
      case Opcodes.IFNE -> ifne(label);
      case Opcodes.IFLT -> iflt(label);
      case Opcodes.IFGE -> ifge(label);
      case Opcodes.IFGT -> ifgt(label);
      case Opcodes.IFLE -> ifle(label);
      case Opcodes.IF_ICMPEQ -> ificmpeq(label);
      case Opcodes.IF_ICMPNE -> ificmpne(label);
      case Opcodes.IF_ICMPLT -> ificmplt(label);
      case Opcodes.IF_ICMPGE -> ificmpge(label);
      case Opcodes.IF_ICMPGT -> ificmpgt(label);
      case Opcodes.IF_ICMPLE -> ificmple(label);
      case Opcodes.IF_ACMPEQ -> ifacmpeq(label);
      case Opcodes.IF_ACMPNE -> ifacmpne(label);
      case Opcodes.GOTO -> goTo(label);
      case Opcodes.JSR -> jsr(label);
      case Opcodes.IFNULL -> ifnull(label);
      case Opcodes.IFNONNULL -> ifnonnull(label);
      default -> throw new IllegalArgumentException();
    }
  }

  @Override
  public void visitLabel(Label label) {
    mark(label);
  }

  @Override
  public void visitLdcInsn(Object value) {
    if (value instanceof Integer i) iconst(i); else
    if (value instanceof Byte b) iconst(b.intValue()); else
    if (value instanceof Character c) iconst(c); else
    if (value instanceof Short s) iconst(s.intValue()); else
    if (value instanceof Boolean b) iconst(b ? 1 : 0); else
    if (value instanceof Float f) fconst(f); else
    if (value instanceof Long l) lconst(l); else
    if (value instanceof Double d) dconst(d); else
    if (value instanceof String s) aconst(s); else
    if (value instanceof Type t) tconst(t); else
    if (value instanceof Handle h) hconst(h); else
    if (value instanceof ConstantDynamic cd) cconst(cd); else
    throw new IllegalArgumentException();
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
    var bits = Float.floatToIntBits(floatValue);
    if (bits == 0L || bits == 0x3F800000 || bits == 0x40000000) { // 0..2
      mv.visitInsn(Opcodes.FCONST_0 + (int) floatValue);
    } else {
      mv.visitLdcInsn(floatValue);
    }
  }

  void dconst(double doubleValue) {
    var bits = Double.doubleToLongBits(doubleValue);
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
      case Type.BOOLEAN -> arrayType = Opcodes.T_BOOLEAN;
      case Type.CHAR -> arrayType = Opcodes.T_CHAR;
      case Type.BYTE -> arrayType = Opcodes.T_BYTE;
      case Type.SHORT -> arrayType = Opcodes.T_SHORT;
      case Type.INT -> arrayType = Opcodes.T_INT;
      case Type.FLOAT -> arrayType = Opcodes.T_FLOAT;
      case Type.LONG -> arrayType = Opcodes.T_LONG;
      case Type.DOUBLE -> arrayType = Opcodes.T_DOUBLE;
      default -> {
        mv.visitTypeInsn(Opcodes.ANEWARRAY, type.getInternalName());
        return;
      }
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
