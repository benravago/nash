package nasgen;

import java.util.List;

import org.objectweb.asm.Handle;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Type;
import static org.objectweb.asm.Opcodes.*;

import static nasgen.StringConstants.*;

/**
 * Base class for all method generating classes.
 */
public class MethodGenerator extends MethodVisitor {

  private final int access;
  private final String name;
  private final String descriptor;
  private final Type returnType;
  private final Type[] argumentTypes;

  static final Type EMPTY_LINK_LOGIC_TYPE = Type.getType("L" + OBJ_ANNO_PKG + "SpecializedFunction$LinkLogic$Empty;");

  MethodGenerator(MethodVisitor mv, int access, String name, String descriptor) {
    super(Main.ASM_VERSION, mv);
    this.access = access;
    this.name = name;
    this.descriptor = descriptor;
    this.returnType = Type.getReturnType(descriptor);
    this.argumentTypes = Type.getArgumentTypes(descriptor);
  }

  int getAccess() {
    return access;
  }

  final String getName() {
    return name;
  }

  final String getDescriptor() {
    return descriptor;
  }

  final Type getReturnType() {
    return returnType;
  }

  final Type[] getArgumentTypes() {
    return argumentTypes;
  }

  /**
   * Check whether access for this method is static
   * @return true if static
   */
  protected final boolean isStatic() {
    return (getAccess() & ACC_STATIC) != 0;
  }

  /**
   * Check whether this method is a constructor
   * @return true if constructor
   */
  protected final boolean isConstructor() {
    return "<init>".equals(name);
  }

  void newObject(String type) {
    super.visitTypeInsn(NEW, type);
  }

  void newObjectArray(String type) {
    super.visitTypeInsn(ANEWARRAY, type);
  }

  void loadThis() {
    if ((access & ACC_STATIC) != 0) {
      throw new IllegalStateException("no 'this' inside static method");
    }
    super.visitVarInsn(ALOAD, 0);
  }

  void returnValue() {
    super.visitInsn(returnType.getOpcode(IRETURN));
  }

  void returnVoid() {
    super.visitInsn(RETURN);
  }

  // load, store
  void arrayLoad(Type type) {
    super.visitInsn(type.getOpcode(IALOAD));
  }

  void arrayLoad() {
    super.visitInsn(AALOAD);
  }

  void arrayStore(Type type) {
    super.visitInsn(type.getOpcode(IASTORE));
  }

  void arrayStore() {
    super.visitInsn(AASTORE);
  }

  void loadLiteral(Object value) {
    super.visitLdcInsn(value);
  }

  void classLiteral(String className) {
    super.visitLdcInsn(className);
  }

  void loadLocal(Type type, int index) {
    super.visitVarInsn(type.getOpcode(ILOAD), index);
  }

  void loadLocal(int index) {
    super.visitVarInsn(ALOAD, index);
  }

  void storeLocal(Type type, int index) {
    super.visitVarInsn(type.getOpcode(ISTORE), index);
  }

  void storeLocal(int index) {
    super.visitVarInsn(ASTORE, index);
  }

  void checkcast(String type) {
    super.visitTypeInsn(CHECKCAST, type);
  }

  // push constants/literals
  void pushNull() {
    super.visitInsn(ACONST_NULL);
  }

  void push(int value) {
    if (value >= -1 && value <= 5) {
      super.visitInsn(ICONST_0 + value);
    } else if (value >= Byte.MIN_VALUE && value <= Byte.MAX_VALUE) {
      super.visitIntInsn(BIPUSH, value);
    } else if (value >= Short.MIN_VALUE && value <= Short.MAX_VALUE) {
      super.visitIntInsn(SIPUSH, value);
    } else {
      super.visitLdcInsn(value);
    }
  }

  void loadClass(String className) {
    super.visitLdcInsn(Type.getObjectType(className));
  }

  void pop() {
    super.visitInsn(POP);
  }

  // various "dups"
  void dup() {
    super.visitInsn(DUP);
  }

  void dup2() {
    super.visitInsn(DUP2);
  }

  void swap() {
    super.visitInsn(SWAP);
  }

  void dupArrayValue(int arrayOpcode) {
    switch (arrayOpcode) {
      case IALOAD, FALOAD, AALOAD, BALOAD, CALOAD, SALOAD, IASTORE, FASTORE, AASTORE, BASTORE, CASTORE, SASTORE -> dup();
      case LALOAD, DALOAD, LASTORE, DASTORE -> dup2();
      default -> throw new AssertionError("invalid dup");
    }
  }

  void dupReturnValue(int returnOpcode) {
    switch (returnOpcode) {
      case IRETURN, FRETURN, ARETURN -> super.visitInsn(DUP);
      case LRETURN, DRETURN -> super.visitInsn(DUP2);
      case RETURN -> { return; }
      default -> throw new IllegalArgumentException("not return");
    }
  }

  void dupValue(Type type) {
    switch (type.getSize()) {
      case 1 -> dup();
      case 2 -> dup2();
      default -> throw new AssertionError("invalid dup");
    }
  }

  void dupValue(String desc) {
    var typeCode = desc.charAt(0);
    switch (typeCode) {
      case '[', 'L', 'Z', 'C', 'B', 'S', 'I' -> super.visitInsn(DUP);
      case 'J', 'D' -> super.visitInsn(DUP2);
      default -> throw new RuntimeException("invalid signature");
    }
  }

  // push default value of given type desc
  void defaultValue(String desc) {
    var typeCode = desc.charAt(0);
    switch (typeCode) {
      case '[', 'L' -> super.visitInsn(ACONST_NULL);
      case 'Z', 'C', 'B', 'S', 'I' -> super.visitInsn(ICONST_0);
      case 'J' -> super.visitInsn(LCONST_0);
      case 'F' -> super.visitInsn(FCONST_0);
      case 'D' -> super.visitInsn(DCONST_0);
      default -> throw new AssertionError("invalid desc " + desc);
    }
  }

  // invokes, field get/sets
  void invokeInterface(String owner, String method, String desc) {
    super.visitMethodInsn(INVOKEINTERFACE, owner, method, desc, true);
  }

  void invokeVirtual(String owner, String method, String desc) {
    super.visitMethodInsn(INVOKEVIRTUAL, owner, method, desc, false);
  }

  void invokeSpecial(String owner, String method, String desc) {
    super.visitMethodInsn(INVOKESPECIAL, owner, method, desc, false);
  }

  void invokeStatic(String owner, String method, String desc) {
    super.visitMethodInsn(INVOKESTATIC, owner, method, desc, false);
  }

  void putStatic(String owner, String field, String desc) {
    super.visitFieldInsn(PUTSTATIC, owner, field, desc);
  }

  void getStatic(String owner, String field, String desc) {
    super.visitFieldInsn(GETSTATIC, owner, field, desc);
  }

  void putField(String owner, String field, String desc) {
    super.visitFieldInsn(PUTFIELD, owner, field, desc);
  }

  void getField(String owner, String field, String desc) {
    super.visitFieldInsn(GETFIELD, owner, field, desc);
  }

  private static boolean linkLogicIsEmpty(Type type) {
    assert EMPTY_LINK_LOGIC_TYPE != null; //type is ok for null if we are a @SpecializedFunction without any attribs
    return EMPTY_LINK_LOGIC_TYPE.equals(type);
  }

  void memberInfoArray(String className, List<MemberInfo> mis) {
    if (mis.isEmpty()) {
      pushNull();
      return;
    }
    var pos = 0;
    push(mis.size());
    newObjectArray(SPECIALIZATION_TYPE);
    for (var mi : mis) {
      dup();
      push(pos++);
      visitTypeInsn(NEW, SPECIALIZATION_TYPE);
      dup();
      visitLdcInsn(new Handle(H_INVOKESTATIC, className, mi.getJavaName(), mi.getJavaDesc(), false));
      final Type linkLogicClass = mi.getLinkLogicClass();
      final boolean linkLogic = !linkLogicIsEmpty(linkLogicClass);
      final String ctor = linkLogic ? SPECIALIZATION_INIT3 : SPECIALIZATION_INIT2;
      if (linkLogic) {
        visitLdcInsn(linkLogicClass);
      }
      visitInsn(mi.isOptimistic() ? ICONST_1 : ICONST_0);
      visitInsn(mi.convertsNumericArgs() ? ICONST_1 : ICONST_0);
      visitMethodInsn(INVOKESPECIAL, SPECIALIZATION_TYPE, INIT, ctor, false);
      arrayStore(TYPE_SPECIALIZATION);
    }
  }

  void computeMaxs() {
    // These values are ignored as we create class writer with ClassWriter.COMPUTE_MAXS flag.
    super.visitMaxs(Short.MAX_VALUE, Short.MAX_VALUE);
  }

  // debugging support - print calls
  void println(String msg) {
    super.visitFieldInsn(GETSTATIC, "java/lang/System", "out", "Ljava/io/PrintStream;");
    super.visitLdcInsn(msg);
    super.visitMethodInsn(INVOKEVIRTUAL, "java/io/PrintStream", "println", "(Ljava/lang/String;)V", false);
  }

  // print the object on the top of the stack
  void printObject() {
    super.visitFieldInsn(GETSTATIC, "java/lang/System", "out", "Ljava/io/PrintStream;");
    super.visitInsn(SWAP);
    super.visitMethodInsn(INVOKEVIRTUAL, "java/io/PrintStream", "println", "(Ljava/lang/Object;)V", false);
  }

}
