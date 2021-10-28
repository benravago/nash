package nasgen;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.objectweb.asm.AnnotationVisitor;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Opcodes;
import org.objectweb.asm.Type;

import nasgen.MemberInfo.Kind;
import static nasgen.ScriptClassInfo.*;

/**
 * This class collects all @ScriptClass and other annotation information from a compiled .class file.
 * Enforces that @Function/@Getter/@Setter/@Constructor methods are declared to be 'static'.
 */
public class ScriptClassInfoCollector extends ClassVisitor {

  private String scriptClassName;
  private List<MemberInfo> scriptMembers;
  private String javaClassName;

  ScriptClassInfoCollector(ClassVisitor visitor) {
    super(Main.ASM_VERSION, visitor);
  }

  ScriptClassInfoCollector() {
    this(new NullVisitor());
  }

  void addScriptMember(MemberInfo memInfo) {
    if (scriptMembers == null) {
      scriptMembers = new ArrayList<>();
    }
    scriptMembers.add(memInfo);
  }

  @Override
  public void visit(int version, int access, String name, String signature, String superName, String[] interfaces) {
    super.visit(version, access, name, signature, superName, interfaces);
    javaClassName = name;
  }

  @Override
  public AnnotationVisitor visitAnnotation(String desc, boolean visible) {
    var delegateAV = super.visitAnnotation(desc, visible);
    if (SCRIPT_CLASS_ANNO_DESC.equals(desc)) {
      return new AnnotationVisitor(Main.ASM_VERSION, delegateAV) {
        @Override
        public void visit(String name, Object value) {
          if ("value".equals(name)) {
            scriptClassName = (String) value;
          }
          super.visit(name, value);
        }
      };
    }
    return delegateAV;
  }

  @Override
  public FieldVisitor visitField(int fieldAccess, String fieldName, String fieldDesc, String signature, Object value) {
    var delegateFV = super.visitField(fieldAccess, fieldName, fieldDesc, signature, value);
    return new FieldVisitor(Main.ASM_VERSION, delegateFV) {
      @Override
      public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
        var delegateAV = super.visitAnnotation(descriptor, visible);
        if (ScriptClassInfo.PROPERTY_ANNO_DESC.equals(descriptor)) {
          var memInfo = new MemberInfo();
          memInfo.setKind(Kind.PROPERTY);
          memInfo.setJavaName(fieldName);
          memInfo.setJavaDesc(fieldDesc);
          memInfo.setJavaAccess(fieldAccess);
          if ((fieldAccess & Opcodes.ACC_STATIC) != 0) {
            memInfo.setValue(value);
          }
          addScriptMember(memInfo);
          return new AnnotationVisitor(Main.ASM_VERSION, delegateAV) {

            // These could be "null" if values are not supplied, in which case we have to use the default values.
            private String name;
            private Integer attributes;
            private String type = "";
            private Where where;

            @Override
            public void visit(String annotationName, Object annotationValue) {
              switch (annotationName) {
                case "name" -> this.name = (String) annotationValue;
                case "attributes" -> this.attributes = (Integer) annotationValue;
                case "type" -> this.type = (annotationValue == null) ? "" : annotationValue.toString();
                // default: pass
              }
              super.visit(annotationName, annotationValue);
            }

            @Override
            public void visitEnum(String enumName, String desc, String enumValue) {
              if ("where".equals(enumName) && WHERE_ENUM_DESC.equals(desc)) {
                this.where = Where.valueOf(enumValue);
              }
              super.visitEnum(enumName, desc, enumValue);
            }

            @Override
            public void visitEnd() {
              super.visitEnd();
              memInfo.setName(name == null ? fieldName : name);
              memInfo.setAttributes(attributes == null ? MemberInfo.DEFAULT_ATTRIBUTES : attributes);
              type = type.replace('.', '/');
              memInfo.setInitClass(type);
              memInfo.setWhere(where == null ? Where.INSTANCE : where);
            }
          };
        }
        return delegateAV;
      }
    };
  }

  private void error(String javaName, String javaDesc, String msg) {
    throw new RuntimeException(scriptClassName + "." + javaName + javaDesc + " : " + msg);
  }

  @Override
  public MethodVisitor visitMethod(int methodAccess, String methodName, String methodDesc, String signature, String[] exceptions) {
    var delegateMV = super.visitMethod(methodAccess, methodName, methodDesc, signature, exceptions);
    return new MethodVisitor(Main.ASM_VERSION, delegateMV) {

      @Override
      public AnnotationVisitor visitAnnotation(String descriptor, boolean visible) {
        var delegateAV = super.visitAnnotation(descriptor, visible);
        var annoKind = ScriptClassInfo.annotations.get(descriptor);
        if (annoKind != null) {
          if ((methodAccess & Opcodes.ACC_STATIC) == 0) {
            error(methodName, methodDesc, "nasgen method annotations cannot be on instance methods");
          }
          var memInfo = new MemberInfo();
          // annoKind == GETTER or SPECIALIZED_FUNCTION
          memInfo.setKind(annoKind);
          memInfo.setJavaName(methodName);
          memInfo.setJavaDesc(methodDesc);
          memInfo.setJavaAccess(methodAccess);
          addScriptMember(memInfo);
          return new AnnotationVisitor(Main.ASM_VERSION, delegateAV) {
            // These could be "null" if values are not supplied, in which case we have to use the default values.
            private String name;
            private Integer attributes;
            private Integer arity;
            private Where where;
            private boolean isSpecializedConstructor;
            private boolean isOptimistic;
            private boolean convertsNumericArgs;
            private Type linkLogicClass = MethodGenerator.EMPTY_LINK_LOGIC_TYPE;

            @Override
            public void visit(String annotationName, Object annotationValue) {
              switch (annotationName) {
                case "name" -> {
                  this.name = (String) annotationValue;
                  if (name.isEmpty()) {
                    name = null;
                  }
                }
                case "attributes" -> this.attributes = (Integer) annotationValue;
                case "arity" -> this.arity = (Integer) annotationValue;
                case "isConstructor" -> {
                  assert annoKind == Kind.SPECIALIZED_FUNCTION;
                  this.isSpecializedConstructor = (Boolean) annotationValue;
                }
                case "isOptimistic" -> {
                  assert annoKind == Kind.SPECIALIZED_FUNCTION;
                  this.isOptimistic = (Boolean) annotationValue;
                }
                case "linkLogic" -> this.linkLogicClass = (Type) annotationValue;
                case "convertsNumericArgs" -> {
                  assert annoKind == Kind.SPECIALIZED_FUNCTION;
                  this.convertsNumericArgs = (Boolean) annotationValue;
                }
                // default: pass
              }
              super.visit(annotationName, annotationValue);
            }

            @Override
            public void visitEnum(String enumName, String desc, String enumValue) {
              switch (enumName) {
                case "where" -> {
                  if (WHERE_ENUM_DESC.equals(desc)) {
                    this.where = Where.valueOf(enumValue);
                  }
                }
                // default: pass
              }
              super.visitEnum(enumName, desc, enumValue);
            }

            @SuppressWarnings("fallthrough")
            @Override
            public void visitEnd() {
              super.visitEnd();
              if (memInfo.getKind() == Kind.CONSTRUCTOR) {
                memInfo.setName(name == null ? scriptClassName : name);
              } else {
                memInfo.setName(name == null ? methodName : name);
              }
              memInfo.setAttributes(attributes == null ? MemberInfo.DEFAULT_ATTRIBUTES : attributes);
              memInfo.setArity((arity == null) ? MemberInfo.DEFAULT_ARITY : arity);
              if (where == null) {
                // by default @Getter/@Setter belongs to INSTANCE @Function belong to PROTOTYPE.
                switch (memInfo.getKind()) {
                  case GETTER, SETTER -> where = Where.INSTANCE;
                  case CONSTRUCTOR -> where = Where.CONSTRUCTOR;
                  case FUNCTION -> where = Where.PROTOTYPE;
                  case SPECIALIZED_FUNCTION -> where = isSpecializedConstructor ? Where.CONSTRUCTOR : Where.PROTOTYPE;
                  // default: pass
                }
              }
              memInfo.setWhere(where);
              memInfo.setLinkLogicClass(linkLogicClass);
              memInfo.setIsSpecializedConstructor(isSpecializedConstructor);
              memInfo.setIsOptimistic(isOptimistic);
              memInfo.setConvertsNumericArgs(convertsNumericArgs);
            }
          };
        }
        return delegateAV;
      }
    };
  }

  ScriptClassInfo getScriptClassInfo() {
    ScriptClassInfo sci = null;
    if (scriptClassName != null) {
      sci = new ScriptClassInfo();
      sci.setName(scriptClassName);
      if (scriptMembers == null) {
        scriptMembers = Collections.emptyList();
      }
      sci.setMembers(scriptMembers);
      sci.setJavaName(javaClassName);
    }
    return sci;
  }

}
