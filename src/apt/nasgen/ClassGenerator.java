package nasgen;

import java.util.List;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;

import org.objectweb.asm.ClassReader;
import org.objectweb.asm.ClassVisitor;
import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.Handle;
import org.objectweb.asm.Type;
import static org.objectweb.asm.Opcodes.*;

import nasgen.MemberInfo.Kind;
import static nasgen.StringConstants.*;

/**
 * Base class for class generator classes.
 */
public class ClassGenerator {

  /** ASM class writer used to output bytecode for this class */
  protected final ClassWriter cw;

  protected ClassGenerator() {
    this.cw = makeClassWriter();
  }

  MethodGenerator makeStaticInitializer() {
    return makeStaticInitializer(cw);
  }

  MethodGenerator makeConstructor() {
    return makeConstructor(cw);
  }

  MethodGenerator makeMethod(int access, String name, String desc) {
    return makeMethod(cw, access, name, desc);
  }

  void addMapField() {
    addMapField(cw);
  }

  void addField(String name, String desc) {
    addField(cw, name, desc);
  }

  void addFunctionField(String name) {
    addFunctionField(cw, name);
  }

  void addGetter(String owner, MemberInfo memInfo) {
    addGetter(cw, owner, memInfo);
  }

  void addSetter(String owner, MemberInfo memInfo) {
    addSetter(cw, owner, memInfo);
  }

  void emitGetClassName(String name) {
    var mi = makeMethod(ACC_PUBLIC, GET_CLASS_NAME, GET_CLASS_NAME_DESC);
    mi.loadLiteral(name);
    mi.returnValue();
    mi.computeMaxs();
    mi.visitEnd();
  }

  static ClassWriter makeClassWriter() {
    return new ClassWriter(ClassWriter.COMPUTE_FRAMES | ClassWriter.COMPUTE_MAXS) {
      @Override
      protected String getCommonSuperClass(String type1, String type2) {
        try {
          return super.getCommonSuperClass(type1, type2);
        } catch (RuntimeException | LinkageError e) {
          if (MemberInfo.isScriptObject(type1) && MemberInfo.isScriptObject(type2)) {
            return StringConstants.SCRIPTOBJECT_TYPE;
          }
          return StringConstants.OBJECT_TYPE;
        }
      }
    };
  }

  static MethodGenerator makeStaticInitializer(ClassVisitor cv) {
    return makeStaticInitializer(cv, CLINIT);
  }

  static MethodGenerator makeStaticInitializer(ClassVisitor cv, String name) {
    var access = ACC_PUBLIC | ACC_STATIC;
    var desc = DEFAULT_INIT_DESC;
    var mv = cv.visitMethod(access, name, desc, null, null);
    return new MethodGenerator(mv, access, name, desc);
  }

  static MethodGenerator makeConstructor(ClassVisitor cv) {
    var access = 0;
    var name = INIT;
    var desc = DEFAULT_INIT_DESC;
    var mv = cv.visitMethod(access, name, desc, null, null);
    return new MethodGenerator(mv, access, name, desc);
  }

  static MethodGenerator makeMethod(ClassVisitor cv, int access, String name, String desc) {
    var mv = cv.visitMethod(access, name, desc, null, null);
    return new MethodGenerator(mv, access, name, desc);
  }

  static void emitStaticInitPrefix(MethodGenerator mi, String className, int memberCount) {
    mi.visitCode();
    if (memberCount > 0) {
      // new ArrayList(int)
      mi.newObject(ARRAYLIST_TYPE);
      mi.dup();
      mi.push(memberCount);
      mi.invokeSpecial(ARRAYLIST_TYPE, INIT, ARRAYLIST_INIT_DESC);
      // stack: ArrayList
    } else {
      // java.util.Collections.EMPTY_LIST
      mi.getStatic(COLLECTIONS_TYPE, COLLECTIONS_EMPTY_LIST, LIST_DESC);
      // stack List
    }
  }

  static void emitStaticInitSuffix(MethodGenerator mi, String className) {
    // stack: Collection
    // pmap = PropertyMap.newMap(Collection<Property>);
    mi.invokeStatic(PROPERTYMAP_TYPE, PROPERTYMAP_NEWMAP, PROPERTYMAP_NEWMAP_DESC);
    // $nasgenmap$ = pmap;
    mi.putStatic(className, PROPERTYMAP_FIELD_NAME, PROPERTYMAP_DESC);
    mi.returnVoid();
    mi.computeMaxs();
    mi.visitEnd();
  }

  static Type memInfoType(MemberInfo memInfo) {
    return switch (memInfo.getJavaDesc().charAt(0)) {
      case 'I' -> Type.INT_TYPE;
      case 'J' -> Type.LONG_TYPE;
      case 'D' -> Type.DOUBLE_TYPE;
      case 'L' -> TYPE_OBJECT;
      default -> {
        assert false : memInfo.getJavaDesc();
        yield TYPE_OBJECT;
      }
    };
  }

  static String getterDesc(MemberInfo memInfo) {
    return Type.getMethodDescriptor(memInfoType(memInfo));
  }

  static String setterDesc(MemberInfo memInfo) {
    return Type.getMethodDescriptor(Type.VOID_TYPE, memInfoType(memInfo));
  }

  static void addGetter(ClassVisitor cv, String owner, MemberInfo memInfo) {
    var access = ACC_PUBLIC;
    var name = GETTER_PREFIX + memInfo.getJavaName();
    var desc = getterDesc(memInfo);
    var mv = cv.visitMethod(access, name, desc, null, null);
    var mi = new MethodGenerator(mv, access, name, desc);
    mi.visitCode();
    if (memInfo.isStatic() && memInfo.getKind() == Kind.PROPERTY) {
      mi.getStatic(owner, memInfo.getJavaName(), memInfo.getJavaDesc());
    } else {
      mi.loadLocal(0);
      mi.getField(owner, memInfo.getJavaName(), memInfo.getJavaDesc());
    }
    mi.returnValue();
    mi.computeMaxs();
    mi.visitEnd();
  }

  static void addSetter(ClassVisitor cv, String owner, MemberInfo memInfo) {
    var access = ACC_PUBLIC;
    var name = SETTER_PREFIX + memInfo.getJavaName();
    var desc = setterDesc(memInfo);
    var mv = cv.visitMethod(access, name, desc, null, null);
    var mi = new MethodGenerator(mv, access, name, desc);
    mi.visitCode();
    if (memInfo.isStatic() && memInfo.getKind() == Kind.PROPERTY) {
      mi.loadLocal(1);
      mi.putStatic(owner, memInfo.getJavaName(), memInfo.getJavaDesc());
    } else {
      mi.loadLocal(0);
      mi.loadLocal(1);
      mi.putField(owner, memInfo.getJavaName(), memInfo.getJavaDesc());
    }
    mi.returnVoid();
    mi.computeMaxs();
    mi.visitEnd();
  }

  static void addMapField(ClassVisitor cv) {
    // add a PropertyMap static field
    var fv = cv.visitField(ACC_PRIVATE | ACC_STATIC | ACC_FINAL, PROPERTYMAP_FIELD_NAME, PROPERTYMAP_DESC, null, null);
    if (fv != null) {
      fv.visitEnd();
    }
  }

  static void addField(ClassVisitor cv, String name, String desc) {
    var fv = cv.visitField(ACC_PRIVATE, name, desc, null, null);
    if (fv != null) {
      fv.visitEnd();
    }
  }

  static void addFunctionField(ClassVisitor cv, String name) {
    addField(cv, name, OBJECT_DESC);
  }

  static void newFunction(MethodGenerator mi, String objName, String className, MemberInfo memInfo, List<MemberInfo> specs) {
    var arityFound = (memInfo.getArity() != MemberInfo.DEFAULT_ARITY);
    loadFunctionName(mi, memInfo.getName());
    mi.visitLdcInsn(new Handle(H_INVOKESTATIC, className, memInfo.getJavaName(), memInfo.getJavaDesc(), false));
    assert specs != null;
    if (specs.isEmpty()) {
      mi.invokeStatic(SCRIPTFUNCTION_TYPE, SCRIPTFUNCTION_CREATEBUILTIN, SCRIPTFUNCTION_CREATEBUILTIN_DESC);
    } else {
      mi.memberInfoArray(className, specs);
      mi.invokeStatic(SCRIPTFUNCTION_TYPE, SCRIPTFUNCTION_CREATEBUILTIN, SCRIPTFUNCTION_CREATEBUILTIN_SPECS_DESC);
    }
    if (arityFound) {
      mi.dup();
      mi.push(memInfo.getArity());
      mi.invokeVirtual(SCRIPTFUNCTION_TYPE, SCRIPTFUNCTION_SETARITY, SCRIPTFUNCTION_SETARITY_DESC);
    }
    mi.dup();
    mi.loadLiteral(memInfo.getDocumentationKey(objName));
    mi.invokeVirtual(SCRIPTFUNCTION_TYPE, SCRIPTFUNCTION_SETDOCUMENTATIONKEY, SCRIPTFUNCTION_SETDOCUMENTATIONKEY_DESC);
  }

  static void linkerAddGetterSetter(MethodGenerator mi, String className, MemberInfo memInfo) {
    var propertyName = memInfo.getName();
    // stack: Collection
    // dup of Collection instance
    mi.dup();
    // Load property name, converting to Symbol if it begins with "@@"
    loadPropertyKey(mi, propertyName);
    // setup flags
    mi.push(memInfo.getAttributes());
    // setup getter method handle
    var javaName = GETTER_PREFIX + memInfo.getJavaName();
    mi.visitLdcInsn(new Handle(H_INVOKEVIRTUAL, className, javaName, getterDesc(memInfo), false));
    // setup setter method handle
    if (memInfo.isFinal()) {
      mi.pushNull();
    } else {
      javaName = SETTER_PREFIX + memInfo.getJavaName();
      mi.visitLdcInsn(new Handle(H_INVOKEVIRTUAL, className, javaName, setterDesc(memInfo), false));
    }
    // property = AccessorProperty.create(key, flags, getter, setter);
    mi.invokeStatic(ACCESSORPROPERTY_TYPE, ACCESSORPROPERTY_CREATE, ACCESSORPROPERTY_CREATE_DESC);
    // boolean Collection.add(property)
    mi.invokeInterface(COLLECTION_TYPE, COLLECTION_ADD, COLLECTION_ADD_DESC);
    // pop return value of Collection.add
    mi.pop();
    // stack: Collection
  }

  static void linkerAddGetterSetter(MethodGenerator mi, String className, MemberInfo getter, MemberInfo setter) {
    var propertyName = getter.getName();
    // stack: Collection
    // dup of Collection instance
    mi.dup();
    // Load property name, converting to Symbol if it begins with "@@"
    loadPropertyKey(mi, propertyName);
    // setup flags
    mi.push(getter.getAttributes());
    // setup getter method handle
    mi.visitLdcInsn(new Handle(H_INVOKESTATIC, className, getter.getJavaName(), getter.getJavaDesc(), false));
    // setup setter method handle
    if (setter == null) {
      mi.pushNull();
    } else {
      mi.visitLdcInsn(new Handle(H_INVOKESTATIC, className, setter.getJavaName(), setter.getJavaDesc(), false));
    }
    // property = AccessorProperty.create(key, flags, getter, setter);
    mi.invokeStatic(ACCESSORPROPERTY_TYPE, ACCESSORPROPERTY_CREATE, ACCESSORPROPERTY_CREATE_DESC);
    // boolean Collection.add(property)
    mi.invokeInterface(COLLECTION_TYPE, COLLECTION_ADD, COLLECTION_ADD_DESC);
    // pop return value of Collection.add
    mi.pop();
    // stack: Collection
  }

  static ScriptClassInfo getScriptClassInfo(String fileName) throws IOException {
    try (var bis = new BufferedInputStream(new FileInputStream(fileName))) {
      return getScriptClassInfo(new ClassReader(bis));
    }
  }

  static ScriptClassInfo getScriptClassInfo(byte[] classBuf) {
    return getScriptClassInfo(new ClassReader(classBuf));
  }

  static void loadFunctionName(MethodGenerator mi, String propertyName) {
    if (propertyName.startsWith(SYMBOL_PREFIX)) {
      mi.loadLiteral("Symbol[" + propertyName.substring(2) + "]");
    } else {
      mi.loadLiteral(propertyName);
    }
  }

  static void loadPropertyKey(MethodGenerator mi, String propertyName) {
    if (propertyName.startsWith(SYMBOL_PREFIX)) {
      mi.getStatic(NATIVESYMBOL_TYPE, propertyName.substring(2), SYMBOL_DESC);
    } else {
      mi.loadLiteral(propertyName);
    }
  }

  static ScriptClassInfo getScriptClassInfo(ClassReader reader) {
    var scic = new ScriptClassInfoCollector();
    reader.accept(scic, 0);
    return scic.getScriptClassInfo();
  }

}
