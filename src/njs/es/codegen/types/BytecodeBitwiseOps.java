package es.codegen.types;

import org.objectweb.asm.MethodVisitor;

/**
 * Bitwise operations not supported by all types
 */
interface BytecodeBitwiseOps {

  /**
   * Pop and logically shift the two values on top of the stack (steps, value)
   * right and push the result on the stack
   *
   * @param method method visitor
   * @return result type
   */
  Type shr(MethodVisitor method);

  /**
   * Pop and arithmetically shift of the two values on top of the stack
   * (steps, value) right and push the result on the stack
   *
   * @param method method visitor
   * @return result type
   */
  Type sar(MethodVisitor method);

  /**
   * Pop and logically shift of the two values on top of the stack (steps,
   * value) left and push the result on the stack
   *
   * @param method method visitor
   * @return result type
   */
  Type shl(MethodVisitor method);

  /**
   * Pop and AND the two values on top of the stack and push the result on the
   * stack
   *
   * @param method method visitor
   * @return result type
   */
  Type and(MethodVisitor method);

  /**
   * Pop and OR the two values on top of the stack and push the result on the
   * stack
   *
   * @param method method visitor
   * @return result type
   */
  Type or(MethodVisitor method);

  /**
   * Pop and XOR the two values on top of the stack and push the result on the
   * stack
   *
   * @param method method visitor
   * @return result type
   */
  Type xor(MethodVisitor method);

  /**
   * Comparison with int return value, e.g. LCMP.
   *
   * @param method the method visitor
   * @return int return value
   */
  Type cmp(MethodVisitor method);
}
