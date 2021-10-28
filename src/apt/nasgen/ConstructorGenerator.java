package nasgen;

import java.util.List;

import org.objectweb.asm.Handle;
import static org.objectweb.asm.Opcodes.*;

import static nasgen.StringConstants.*;

/**
 * This class generates constructor class for a @ScriptClass annotated class.
 */
public class ConstructorGenerator extends ClassGenerator {

  private final ScriptClassInfo scriptClassInfo;
  private final String className;
  private final MemberInfo constructor;
  private final int memberCount;
  private final List<MemberInfo> specs;

  ConstructorGenerator(final ScriptClassInfo sci) {
    this.scriptClassInfo = sci;
    this.className = scriptClassInfo.getConstructorClassName();
    this.constructor = scriptClassInfo.getConstructor();
    this.memberCount = scriptClassInfo.getConstructorMemberCount();
    this.specs = scriptClassInfo.getSpecializedConstructors();
  }

  byte[] getClassBytes() {
    // new class extending from ScriptObject
    var superClass = (constructor != null) ? SCRIPTFUNCTION_TYPE : SCRIPTOBJECT_TYPE;
    cw.visit(V1_7, ACC_FINAL, className, null, superClass, null);
    if (memberCount > 0) {
      // add fields
      emitFields();
      // add <clinit>
      emitStaticInitializer();
    }
    // add <init>
    emitConstructor();
    if (constructor == null) {
      emitGetClassName(scriptClassInfo.getName());
    }
    cw.visitEnd();
    return cw.toByteArray();
  }

  // --Internals only below this point

  void emitFields() {
    // Introduce "Function" type instance fields for each constructor @Function in script class and introduce instance fields for each constructor @Property in the script class.
    for (var memInfo : scriptClassInfo.getMembers()) {
      if (memInfo.isConstructorFunction()) {
        addFunctionField(memInfo.getJavaName());
        memInfo = (MemberInfo) memInfo.clone();
        memInfo.setJavaDesc(OBJECT_DESC);
        memInfo.setJavaAccess(ACC_PUBLIC);
        addGetter(className, memInfo);
        addSetter(className, memInfo);
      } else if (memInfo.isConstructorProperty()) {
        if (memInfo.isStaticFinal()) {
          addGetter(scriptClassInfo.getJavaName(), memInfo);
        } else {
          addField(memInfo.getJavaName(), memInfo.getJavaDesc());
          memInfo = (MemberInfo) memInfo.clone();
          memInfo.setJavaAccess(ACC_PUBLIC);
          addGetter(className, memInfo);
          addSetter(className, memInfo);
        }
      }
    }
    addMapField();
  }

  void emitStaticInitializer() {
    var mi = makeStaticInitializer();
    emitStaticInitPrefix(mi, className, memberCount);
    for (var memInfo : scriptClassInfo.getMembers()) {
      if (memInfo.isConstructorFunction() || memInfo.isConstructorProperty()) {
        linkerAddGetterSetter(mi, className, memInfo);
      } else if (memInfo.isConstructorGetter()) {
        var setter = scriptClassInfo.findSetter(memInfo);
        linkerAddGetterSetter(mi, scriptClassInfo.getJavaName(), memInfo, setter);
      }
    }
    emitStaticInitSuffix(mi, className);
  }

  void emitConstructor() {
    var mi = makeConstructor();
    mi.visitCode();
    callSuper(mi);
    if (memberCount > 0) {
      // initialize Function type fields
      initFunctionFields(mi);
      // initialize data fields
      initDataFields(mi);
    }
    if (constructor != null) {
      initPrototype(mi);
      var arity = constructor.getArity();
      if (arity != MemberInfo.DEFAULT_ARITY) {
        mi.loadThis();
        mi.push(arity);
        mi.invokeVirtual(SCRIPTFUNCTION_TYPE, SCRIPTFUNCTION_SETARITY, SCRIPTFUNCTION_SETARITY_DESC);
      }
      mi.loadThis();
      mi.loadLiteral(scriptClassInfo.getName());
      mi.invokeVirtual(SCRIPTFUNCTION_TYPE, SCRIPTFUNCTION_SETDOCUMENTATIONKEY, SCRIPTFUNCTION_SETDOCUMENTATIONKEY_DESC);
    }
    mi.returnVoid();
    mi.computeMaxs();
    mi.visitEnd();
  }

  void loadMap(final MethodGenerator mi) {
    if (memberCount > 0) {
      mi.getStatic(className, PROPERTYMAP_FIELD_NAME, PROPERTYMAP_DESC);
    }
  }

  void callSuper(final MethodGenerator mi) {
    String superClass, superDesc;
    mi.loadThis();
    if (constructor == null) {
      // call ScriptObject.<init>
      superClass = SCRIPTOBJECT_TYPE;
      superDesc = (memberCount > 0) ? SCRIPTOBJECT_INIT_DESC : DEFAULT_INIT_DESC;
      loadMap(mi);
    } else {
      // call Function.<init>
      superClass = SCRIPTFUNCTION_TYPE;
      superDesc = (memberCount > 0) ? SCRIPTFUNCTION_INIT_DESC4 : SCRIPTFUNCTION_INIT_DESC3;
      mi.loadLiteral(constructor.getName());
      mi.visitLdcInsn(new Handle(H_INVOKESTATIC, scriptClassInfo.getJavaName(), constructor.getJavaName(), constructor.getJavaDesc(), false));
      loadMap(mi);
      mi.memberInfoArray(scriptClassInfo.getJavaName(), specs); //pushes null if specs empty
    }
    mi.invokeSpecial(superClass, INIT, superDesc);
  }

  void initFunctionFields(final MethodGenerator mi) {
    assert memberCount > 0;
    for (var memInfo : scriptClassInfo.getMembers()) {
      if (!memInfo.isConstructorFunction()) {
        continue;
      }
      mi.loadThis();
      newFunction(mi, scriptClassInfo.getName(), scriptClassInfo.getJavaName(), memInfo, scriptClassInfo.findSpecializations(memInfo.getJavaName()));
      mi.putField(className, memInfo.getJavaName(), OBJECT_DESC);
    }
  }

  void initDataFields(final MethodGenerator mi) {
    assert memberCount > 0;
    for (var memInfo : scriptClassInfo.getMembers()) {
      if (!memInfo.isConstructorProperty() || memInfo.isFinal()) {
        continue;
      }
      var value = memInfo.getValue();
      if (value != null) {
        mi.loadThis();
        mi.loadLiteral(value);
        mi.putField(className, memInfo.getJavaName(), memInfo.getJavaDesc());
      } else if (!memInfo.getInitClass().isEmpty()) {
        var initClass = memInfo.getInitClass();
        mi.loadThis();
        mi.newObject(initClass);
        mi.dup();
        mi.invokeSpecial(initClass, INIT, DEFAULT_INIT_DESC);
        mi.putField(className, memInfo.getJavaName(), memInfo.getJavaDesc());
      }
    }
  }

  void initPrototype(final MethodGenerator mi) {
    assert constructor != null;
    mi.loadThis();
    var protoName = scriptClassInfo.getPrototypeClassName();
    mi.newObject(protoName);
    mi.dup();
    mi.invokeSpecial(protoName, INIT, DEFAULT_INIT_DESC);
    mi.dup();
    mi.loadThis();
    mi.invokeStatic(PROTOTYPEOBJECT_TYPE, PROTOTYPEOBJECT_SETCONSTRUCTOR, PROTOTYPEOBJECT_SETCONSTRUCTOR_DESC);
    mi.invokeVirtual(SCRIPTFUNCTION_TYPE, SCRIPTFUNCTION_SETPROTOTYPE, SCRIPTFUNCTION_SETPROTOTYPE_DESC);
  }

}
