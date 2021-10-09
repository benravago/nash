package nasgen;

import org.objectweb.asm.AnnotationVisitor;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.MethodVisitor;

/**
 * A visitor that does nothing on visitXXX calls.
 *
 */
public class NullVisitor extends ClassVisitor {

  NullVisitor() {
    super(Main.ASM_VERSION);
  }

  @Override
  public MethodVisitor visitMethod(
          final int access,
          final String name,
          final String desc,
          final String signature,
          final String[] exceptions) {
    return new MethodVisitor(Main.ASM_VERSION) {
      @Override
      public AnnotationVisitor visitAnnotationDefault() {
        return new NullAnnotationVisitor();
      }

      @Override
      public AnnotationVisitor visitAnnotation(final String descriptor, final boolean visible) {
        return new NullAnnotationVisitor();
      }
    };
  }

  @Override
  public FieldVisitor visitField(
          final int access,
          final String name,
          final String desc,
          final String signature,
          final Object value) {
    return new FieldVisitor(Main.ASM_VERSION) {
      @Override
      public AnnotationVisitor visitAnnotation(final String descriptor, final boolean visible) {
        return new NullAnnotationVisitor();
      }
    };
  }

  @Override
  public AnnotationVisitor visitAnnotation(final String desc, final boolean visible) {
    return new NullAnnotationVisitor();
  }

  private static class NullAnnotationVisitor extends AnnotationVisitor {

    NullAnnotationVisitor() {
      super(Main.ASM_VERSION);
    }
  }
}
