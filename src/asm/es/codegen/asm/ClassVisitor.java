package es.codegen.asm;

public abstract class ClassVisitor {

  public ClassVisitor cv;

  public ClassVisitor(ClassVisitor classVisitor) {
    this.cv = classVisitor;
  }

  public void visit(int access, String name, String signature, String superName, String[] interfaces) {
    if (cv != null) {
      cv.visit(access, name, signature, superName, interfaces);
    }
  }

  public void visitSource(String source, String debug) {
    if (cv != null) {
      cv.visitSource(source, debug);
    }
  }

  void visitNestHost(String nestHost) {
    if (cv != null) {
      cv.visitNestHost(nestHost);
    }
  }

  void visitOuterClass(String owner, String name, String descriptor) {
    if (cv != null) {
      cv.visitOuterClass(owner, name, descriptor);
    }
  }

  public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
    if (cv != null) {
      return cv.visitAnnotation(descriptor, visible);
    }
    return null;
  }

  AnnotationVisitor visitTypeAnnotation(int typeRef, TypePath typePath, String descriptor, boolean visible) {
    if (cv != null) {
      return cv.visitTypeAnnotation(typeRef, typePath, descriptor, visible);
    }
    return null;
  }

  void visitAttribute(Attribute attribute) {
    if (cv != null) {
      cv.visitAttribute(attribute);
    }
  }

  void visitNestMember(String nestMember) {
    if (cv != null) {
      cv.visitNestMember(nestMember);
    }
  }

  void visitInnerClass(String name, String outerName, String innerName, int access) {
    if (cv != null) {
      cv.visitInnerClass(name, outerName, innerName, access);
    }
  }

  public FieldVisitor visitField(int access, String name, String descriptor, String signature, final Object value) {
    if (cv != null) {
      return cv.visitField(access, name, descriptor, signature, value);
    }
    return null;
  }

  public MethodVisitor visitMethod(int access, String name, String descriptor, String signature, String[] exceptions) {
    if (cv != null) {
      return cv.visitMethod(access, name, descriptor, signature, exceptions);
    }
    return null;
  }

  public void visitEnd() {
    if (cv != null) {
      cv.visitEnd();
    }
  }
}
