package es.codegen.asm;

public abstract class ClassVisitor {

  public ClassVisitor cv;

  public ClassVisitor(ClassVisitor classVisitor) {
    this.cv = classVisitor;
  }

  public void visit(int access, String name, String signature, String superName, String[] interfaces) {
    if (cv != null) cv.visit(access, name, signature, superName, interfaces);
  }
  public void visitSource(String source, String debug) {
    if (cv != null) cv.visitSource(source, debug);
  }
  public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
    return (cv != null) ? cv.visitAnnotation(descriptor, visible) : null;
  }
  public FieldVisitor visitField(int access, String name, String descriptor, String signature, final Object value) {
    return (cv != null) ? cv.visitField(access, name, descriptor, signature, value) : null;
  }
  public MethodVisitor visitMethod(int access, String name, String descriptor, String signature, String[] exceptions) {
    return (cv != null) ? cv.visitMethod(access, name, descriptor, signature, exceptions) : null;
  }
  public void visitEnd() {
    if (cv != null) cv.visitEnd();
  }
}
