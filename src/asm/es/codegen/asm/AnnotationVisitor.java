package es.codegen.asm;

public abstract class AnnotationVisitor {

  AnnotationVisitor av;

  public AnnotationVisitor(AnnotationVisitor annotationVisitor) {
    this.av = annotationVisitor;
  }

  public void visit(String name, Object value) {
    if (av != null) av.visit(name, value);
  }
  public void visitEnum(String name, String descriptor, String value) {
    if (av != null) av.visitEnum(name, descriptor, value);
  }
  public void visitEnd() {
    if (av != null) av.visitEnd();
  }
}
