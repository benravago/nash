package es.codegen;

import static org.objectweb.asm.Opcodes.*;

/**
 * Condition enum used for all kinds of jumps, regardless of type
 */
enum Condition {
  EQ, NE, LE, LT, GE, GT;

  static int toUnary(Condition c) {
    return switch (c) {
      case EQ -> IFEQ;
      case NE -> IFNE;
      case LE -> IFLE;
      case LT -> IFLT;
      case GE -> IFGE;
      case GT -> IFGT;
      default -> throw new UnsupportedOperationException("toUnary:" + c.toString());
    };
  }

  static int toBinary(Condition c, boolean isObject) {
    return switch (c) {
      case EQ -> isObject ? IF_ACMPEQ : IF_ICMPEQ;
      case NE -> isObject ? IF_ACMPNE : IF_ICMPNE;
      case LE -> IF_ICMPLE;
      case LT -> IF_ICMPLT;
      case GE -> IF_ICMPGE;
      case GT -> IF_ICMPGT;
      default -> throw new UnsupportedOperationException("toBinary:" + c.toString());
    };
  }

}
