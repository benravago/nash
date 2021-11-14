package nasgen;

import static es.codegen.asm.Opcodes.*;
import static nasgen.StringConstants.*;

/**
 * This class generates prototype class for a @ScriptClass annotated class.
 */
public class PrototypeGenerator extends ClassGenerator {

  private final ScriptClassInfo scriptClassInfo;
  private final String className;
  private final int memberCount;

  PrototypeGenerator(ScriptClassInfo sci) {
    this.scriptClassInfo = sci;
    this.className = scriptClassInfo.getPrototypeClassName();
    this.memberCount = scriptClassInfo.getPrototypeMemberCount();
  }

  byte[] getClassBytes() {
    // new class extending from ScriptObject
    cw.visit(ACC_FINAL | ACC_SUPER, className, null, PROTOTYPEOBJECT_TYPE, null);
    if (memberCount > 0) {
      // add fields
      emitFields();
      // add <clinit>
      emitStaticInitializer();
    }
    // add <init>
    emitConstructor();
    // add getClassName()
    emitGetClassName(scriptClassInfo.getName());
    cw.visitEnd();
    return cw.toByteArray();
  }

  // --Internals only below this point

  void emitFields() {
    // introduce "Function" type instance fields for each prototype @Function in script class info
    for (var memInfo : scriptClassInfo.getMembers()) {
      if (memInfo.isPrototypeFunction()) {
        addFunctionField(memInfo.getJavaName());
        memInfo = (MemberInfo) memInfo.clone();
        memInfo.setJavaDesc(OBJECT_DESC);
        addGetter(className, memInfo);
        addSetter(className, memInfo);
      } else if (memInfo.isPrototypeProperty()) {
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
      if (memInfo.isPrototypeFunction() || memInfo.isPrototypeProperty()) {
        linkerAddGetterSetter(mi, className, memInfo);
      } else if (memInfo.isPrototypeGetter()) {
        final MemberInfo setter = scriptClassInfo.findSetter(memInfo);
        linkerAddGetterSetter(mi, scriptClassInfo.getJavaName(), memInfo, setter);
      }
    }
    emitStaticInitSuffix(mi, className);
  }

  void emitConstructor() {
    var mi = makeConstructor();
    mi.visitCode();
    mi.loadThis();
    if (memberCount > 0) {
      // call "super(map$)"
      mi.getStatic(className, PROPERTYMAP_FIELD_NAME, PROPERTYMAP_DESC);
      mi.invokeSpecial(PROTOTYPEOBJECT_TYPE, INIT, SCRIPTOBJECT_INIT_DESC);
      // initialize Function type fields
      initFunctionFields(mi);
    } else {
      // call "super()"
      mi.invokeSpecial(PROTOTYPEOBJECT_TYPE, INIT, DEFAULT_INIT_DESC);
    }
    mi.returnVoid();
    mi.computeMaxs();
    mi.visitEnd();
  }

  void initFunctionFields(MethodGenerator mi) {
    for (var memInfo : scriptClassInfo.getMembers()) {
      if (!memInfo.isPrototypeFunction()) {
        continue;
      }
      mi.loadThis();
      newFunction(mi, scriptClassInfo.getName(), scriptClassInfo.getJavaName(), memInfo, scriptClassInfo.findSpecializations(memInfo.getJavaName()));
      mi.putField(className, memInfo.getJavaName(), OBJECT_DESC);
    }
  }

}
