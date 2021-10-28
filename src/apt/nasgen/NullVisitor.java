package nasgen;

import org.objectweb.asm.AnnotationVisitor;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.MethodVisitor;

/**
 * A visitor that does nothing on visitXXX calls.
 */
public class NullVisitor extends ClassVisitor {

  NullVisitor() {
    super(Main.ASM_VERSION);
  }

  @Override
  public MethodVisitor visitMethod(int access, String name, String desc, String signature, String[] exceptions) {
    return new MethodVisitor(Main.ASM_VERSION) {
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
    return new FieldVisitor(Main.ASM_VERSION) {
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
    NullAnnotationVisitor() {
      super(Main.ASM_VERSION);
    }
  }

}
