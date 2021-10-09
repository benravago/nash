package es.codegen;

import static org.objectweb.asm.Opcodes.IFEQ;
import static org.objectweb.asm.Opcodes.IFGE;
import static org.objectweb.asm.Opcodes.IFGT;
import static org.objectweb.asm.Opcodes.IFLE;
import static org.objectweb.asm.Opcodes.IFLT;
import static org.objectweb.asm.Opcodes.IFNE;
import static org.objectweb.asm.Opcodes.IF_ACMPEQ;
import static org.objectweb.asm.Opcodes.IF_ACMPNE;
import static org.objectweb.asm.Opcodes.IF_ICMPEQ;
import static org.objectweb.asm.Opcodes.IF_ICMPGE;
import static org.objectweb.asm.Opcodes.IF_ICMPGT;
import static org.objectweb.asm.Opcodes.IF_ICMPLE;
import static org.objectweb.asm.Opcodes.IF_ICMPLT;
import static org.objectweb.asm.Opcodes.IF_ICMPNE;

/**
 * Condition enum used for all kinds of jumps, regardless of type
 */
enum Condition {
  EQ,
  NE,
  LE,
  LT,
  GE,
  GT;

  static int toUnary(final Condition c) {
    switch (c) {
      case EQ:
        return IFEQ;
      case NE:
        return IFNE;
      case LE:
        return IFLE;
      case LT:
        return IFLT;
      case GE:
        return IFGE;
      case GT:
        return IFGT;
      default:
        throw new UnsupportedOperationException("toUnary:" + c.toString());
    }
  }

  static int toBinary(final Condition c, final boolean isObject) {
    switch (c) {
      case EQ:
        return isObject ? IF_ACMPEQ : IF_ICMPEQ;
      case NE:
        return isObject ? IF_ACMPNE : IF_ICMPNE;
      case LE:
        return IF_ICMPLE;
      case LT:
        return IF_ICMPLT;
      case GE:
        return IF_ICMPGE;
      case GT:
        return IF_ICMPGT;
      default:
        throw new UnsupportedOperationException("toBinary:" + c.toString());
    }
  }
}
