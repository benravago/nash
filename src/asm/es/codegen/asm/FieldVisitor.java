package es.codegen.asm;

public abstract class FieldVisitor {

  public FieldVisitor fv;

  public FieldVisitor(FieldVisitor fieldVisitor) {
    this.fv = fieldVisitor;
  }

  public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
    return (fv != null) ? fv.visitAnnotation(descriptor, visible) : null;
  }
  public void visitEnd() {
    if (fv != null) fv.visitEnd();
  }
}
