package nasgen;

import es.codegen.asm.AnnotationVisitor;
import es.codegen.asm.ClassVisitor;
import es.codegen.asm.FieldVisitor;
import es.codegen.asm.MethodVisitor;

/**
 * A visitor that does nothing on visitXXX calls.
 */
public class NullVisitor extends ClassVisitor {

  NullVisitor() {
    super(null);
  }

  @Override
  public MethodVisitor visitMethod(int access, String name, String desc, String signature, String[] exceptions) {
    return new MethodVisitor(null) {
      @Override
      public AnnotationVisitor visitAnnotationDefault() {
        return new NullAnnotationVisitor();
      }
      @Override
      public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
        return new NullAnnotationVisitor();
      }
    };
  }

  @Override
  public FieldVisitor visitField(int access, String name, String desc, String signature, Object value) {
    return new FieldVisitor(null) {
      @Override
      public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
        return new NullAnnotationVisitor();
      }
    };
  }

  @Override
  public AnnotationVisitor visitAnnotation(String desc, boolean visible) {
    return new NullAnnotationVisitor();
  }

  static class NullAnnotationVisitor extends AnnotationVisitor {
    NullAnnotationVisitor() { super(null); }
  }

}
