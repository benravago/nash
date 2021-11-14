package es.codegen.asm;

public abstract class FieldVisitor {

  public FieldVisitor fv;

  public FieldVisitor(FieldVisitor fieldVisitor) {
    this.fv = fieldVisitor;
  }

  public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
    if (fv != null) {
      return fv.visitAnnotation(descriptor, visible);
    }
    return null;
  }

  AnnotationVisitor visitTypeAnnotation(int typeRef, TypePath typePath, String descriptor, boolean visible) {
    if (fv != null) {
      return fv.visitTypeAnnotation(typeRef, typePath, descriptor, visible);
    }
    return null;
  }

  public void visitAttribute(Attribute attribute) {
    if (fv != null) {
      fv.visitAttribute(attribute);
    }
  }

  public void visitEnd() {
    if (fv != null) {
      fv.visitEnd();
    }
  }
}
