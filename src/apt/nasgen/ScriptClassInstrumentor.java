package nasgen;

import es.codegen.asm.AnnotationVisitor;
import es.codegen.asm.ClassVisitor;
import es.codegen.asm.FieldVisitor;
import es.codegen.asm.MethodVisitor;
import static es.codegen.asm.Opcodes.*;

import nasgen.MemberInfo.Kind;
import static nasgen.StringConstants.*;

/**
 * This class instruments the java class annotated with @ScriptClass.
 *
 * Changes done are:
 * 1) remove all jdk.nashorn.internal.objects.annotations.* annotations.
 * 2) static final @Property fields stay here. Other @Property fields moved to respective classes depending on 'where' value of annotation.
 * 2) add "Map" type static field named "$map".
 * 3) add static initializer block to initialize map.
 */
public class ScriptClassInstrumentor extends ClassVisitor {

  private final ScriptClassInfo scriptClassInfo;
  private final int memberCount;
  private boolean staticInitFound;

  ScriptClassInstrumentor(ClassVisitor visitor, ScriptClassInfo sci) {
    super(visitor);
    if (sci == null) {
      throw new IllegalArgumentException("Null ScriptClassInfo, is the class annotated?");
    }
    this.scriptClassInfo = sci;
    this.memberCount = scriptClassInfo.getInstancePropertyCount();
  }

  @Override
  public AnnotationVisitor visitAnnotation(String desc, boolean visible) {
    if (ScriptClassInfo.annotations.containsKey(desc)) {
      // ignore @ScriptClass
      return null;
    }
    return super.visitAnnotation(desc, visible);
  }

  @Override
  public FieldVisitor visitField(int fieldAccess, String fieldName, String fieldDesc, String signature, Object value) {
    var memInfo = scriptClassInfo.find(fieldName, fieldDesc, fieldAccess);
    if (memInfo != null && memInfo.getKind() == Kind.PROPERTY && memInfo.getWhere() != Where.INSTANCE && !memInfo.isStaticFinal()) {
      // non-instance @Property fields - these have to go elsewhere unless 'static final'
      return null;
    }
    var delegateFV = super.visitField(fieldAccess, fieldName, fieldDesc, signature, value);
    return new FieldVisitor(delegateFV) {
      @Override
      public AnnotationVisitor visitAnnotation(String desc, boolean visible) {
        if (ScriptClassInfo.annotations.containsKey(desc)) {
          // ignore script field annotations
          return null;
        }
        return fv.visitAnnotation(desc, visible);
      }
      @Override
      public void visitEnd() {
        fv.visitEnd();
      }
    };
  }

  @Override
  public MethodVisitor visitMethod(int methodAccess, String methodName, final String methodDesc, String signature, String[] exceptions) {
    var isConstructor = INIT.equals(methodName);
    var isStaticInit = CLINIT.equals(methodName);
    if (isStaticInit) {
      staticInitFound = true;
    }
    var delegateMV = new MethodGenerator(super.visitMethod(methodAccess, methodName, methodDesc, signature, exceptions), methodAccess, methodName, methodDesc);
    return new MethodVisitor(delegateMV) {
      @Override
      public void visitInsn(int opcode) {
        // call $clinit$ just before return from <clinit>
        if (isStaticInit && opcode == RETURN) {
          super.visitMethodInsn(INVOKESTATIC, scriptClassInfo.getJavaName(), $CLINIT$, DEFAULT_INIT_DESC, false);
        }
        super.visitInsn(opcode);
      }
      @Override
      public void visitMethodInsn(int opcode, String owner, String name, String desc, boolean itf) {
        if (isConstructor && opcode == INVOKESPECIAL && INIT.equals(name) && SCRIPTOBJECT_TYPE.equals(owner)) {
          super.visitMethodInsn(opcode, owner, name, desc, false);
          if (memberCount > 0) {
            // initialize @Property fields if needed
            for (var memInfo : scriptClassInfo.getMembers()) {
              if (memInfo.isInstanceProperty() && !memInfo.getInitClass().isEmpty()) {
                var initClass = memInfo.getInitClass();
                super.visitVarInsn(ALOAD, 0);
                super.visitTypeInsn(NEW, initClass);
                super.visitInsn(DUP);
                super.visitMethodInsn(INVOKESPECIAL, initClass, INIT, DEFAULT_INIT_DESC, false);
                super.visitFieldInsn(PUTFIELD, scriptClassInfo.getJavaName(), memInfo.getJavaName(), memInfo.getJavaDesc());
              }
              if (memInfo.isInstanceFunction()) {
                super.visitVarInsn(ALOAD, 0);
                ClassGenerator.newFunction(delegateMV, scriptClassInfo.getName(), scriptClassInfo.getJavaName(), memInfo, scriptClassInfo.findSpecializations(memInfo.getJavaName()));
                super.visitFieldInsn(PUTFIELD, scriptClassInfo.getJavaName(), memInfo.getJavaName(), OBJECT_DESC);
              }
            }
          }
        } else {
          super.visitMethodInsn(opcode, owner, name, desc, itf);
        }
      }
      @Override
      public AnnotationVisitor visitAnnotation(String desc, boolean visible) {
        if (ScriptClassInfo.annotations.containsKey(desc)) {
          // ignore script method annotations
          return null;
        }
        return super.visitAnnotation(desc, visible);
      }
    };
  }

  @Override
  public void visitEnd() {
    emitFields();
    emitStaticInitializer();
    emitGettersSetters();
    super.visitEnd();
  }

  void emitFields() {
    // introduce "Function" type instance fields for each instance @Function in script class info
    var className = scriptClassInfo.getJavaName();
    for (var memInfo : scriptClassInfo.getMembers()) {
      if (memInfo.isInstanceFunction()) {
        ClassGenerator.addFunctionField(cv, memInfo.getJavaName());
        memInfo = (MemberInfo) memInfo.clone();
        memInfo.setJavaDesc(OBJECT_DESC);
        ClassGenerator.addGetter(cv, className, memInfo);
        ClassGenerator.addSetter(cv, className, memInfo);
      }
    }
    // omit addMapField() since instance classes already define a static PropertyMap field
  }

  void emitGettersSetters() {
    if (memberCount > 0) {
      for (var memInfo : scriptClassInfo.getMembers()) {
        var className = scriptClassInfo.getJavaName();
        if (memInfo.isInstanceProperty()) {
          ClassGenerator.addGetter(cv, className, memInfo);
          if (!memInfo.isFinal()) {
            ClassGenerator.addSetter(cv, className, memInfo);
          }
        }
      }
    }
  }

  void emitStaticInitializer() {
    var className = scriptClassInfo.getJavaName();
    if (!staticInitFound) {
      // no user written <clinit> and so create one
      var mv = ClassGenerator.makeStaticInitializer(this);
      mv.visitCode();
      mv.visitInsn(RETURN);
      mv.visitMaxs(Short.MAX_VALUE, 0);
      mv.visitEnd();
    }
    // Now generate $clinit$
    var mi = ClassGenerator.makeStaticInitializer(this, $CLINIT$);
    ClassGenerator.emitStaticInitPrefix(mi, className, memberCount);
    if (memberCount > 0) {
      for (var memInfo : scriptClassInfo.getMembers()) {
        if (memInfo.isInstanceProperty() || memInfo.isInstanceFunction()) {
          ClassGenerator.linkerAddGetterSetter(mi, className, memInfo);
        } else if (memInfo.isInstanceGetter()) {
          final MemberInfo setter = scriptClassInfo.findSetter(memInfo);
          ClassGenerator.linkerAddGetterSetter(mi, className, memInfo, setter);
        }
      }
    }
    ClassGenerator.emitStaticInitSuffix(mi, className);
  }

}
