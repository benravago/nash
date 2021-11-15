package es.codegen.asm;

public abstract class MethodVisitor {

  MethodVisitor mv;

  public MethodVisitor(MethodVisitor methodVisitor) {
    this.mv = methodVisitor;
  }

  public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
    return (mv != null) ? mv.visitAnnotation(descriptor, visible) : null;
  }
  public void visitCode() {
    if (mv != null) mv.visitCode();
  }
  void visitFrame(int type, int numLocal, Object[] local, int numStack, Object[] stack) {
    if (mv != null) mv.visitFrame(type, numLocal, local, numStack, stack);
  }
  public void visitInsn(int opcode) {
    if (mv != null) mv.visitInsn(opcode);
  }
  public void visitIntInsn(int opcode, int operand) {
    if (mv != null) mv.visitIntInsn(opcode, operand);
  }
  public void visitVarInsn(int opcode, int var) {
    if (mv != null) mv.visitVarInsn(opcode, var);
  }
  public void visitTypeInsn(int opcode, String type) {
    if (mv != null) mv.visitTypeInsn(opcode, type);
  }
  public void visitFieldInsn(int opcode, String owner, String name, String descriptor) {
    if (mv != null) mv.visitFieldInsn(opcode, owner, name, descriptor);
  }
  public void visitMethodInsn(int opcode, String owner, String name, String descriptor, boolean isInterface) {
    if (mv != null) mv.visitMethodInsn(opcode, owner, name, descriptor, isInterface);
  }
  public void visitInvokeDynamicInsn(String name, String descriptor, Handle bootstrapMethodHandle, Object... bootstrapMethodArguments) {
    if (mv != null) mv.visitInvokeDynamicInsn(name, descriptor, bootstrapMethodHandle, bootstrapMethodArguments);
  }
  public void visitJumpInsn(int opcode, Label label) {
    if (mv != null) mv.visitJumpInsn(opcode, label);
  }
  public void visitLabel(Label label) {
    if (mv != null) mv.visitLabel(label);
  }
  public void visitLdcInsn(Object value) {
    if (mv != null) mv.visitLdcInsn(value);
  }
  public void visitIincInsn(int var, int increment) {
    if (mv != null) mv.visitIincInsn(var, increment);
  }
  public void visitTableSwitchInsn(int min, int max, Label dflt, Label... labels) {
    if (mv != null) mv.visitTableSwitchInsn(min, max, dflt, labels);
  }
  public void visitLookupSwitchInsn(Label dflt, int[] keys, Label[] labels) {
    if (mv != null) mv.visitLookupSwitchInsn(dflt, keys, labels);
  }
  public void visitMultiANewArrayInsn(String descriptor, int numDimensions) {
    if (mv != null) mv.visitMultiANewArrayInsn(descriptor, numDimensions);
  }
  public void visitTryCatchBlock(Label start, Label end, Label handler, String type) {
    if (mv != null) mv.visitTryCatchBlock(start, end, handler, type);
  }
  void visitLineNumber(int line, Label start) {
    if (mv != null) mv.visitLineNumber(line, start);
  }
  public void visitMaxs(int maxStack, int maxLocals) {
    if (mv != null) mv.visitMaxs(maxStack, maxLocals);
  }
  public void visitEnd() {
    if (mv != null) mv.visitEnd();
  }

  public void visitLocalVariable(String name, String descriptor, String signature, Label start, Label end, int index) {
    System.out.println("visitLocalVariable");
    if (mv != null) {
      mv.visitLocalVariable(name, descriptor, signature, start, end, index);
    }
  }
}
