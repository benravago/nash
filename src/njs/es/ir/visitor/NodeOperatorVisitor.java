package es.ir.visitor;

import es.ir.BinaryNode;
import es.ir.LexicalContext;
import es.ir.Node;
import es.ir.UnaryNode;

/**
 * Like NodeVisitor but navigating further into operators.
 *
 * @param <T> Lexical context class for this NodeOperatorVisitor
 */
public abstract class NodeOperatorVisitor<T extends LexicalContext> extends NodeVisitor<T> {

  /**
   * Constructor
   *
   * @param lc a custom lexical context
   */
  public NodeOperatorVisitor(T lc) {
    super(lc);
  }

  @Override
  public boolean enterUnaryNode(UnaryNode unaryNode) {
    return switch (unaryNode.tokenType()) {
      case POS -> enterPOS(unaryNode);
      case BIT_NOT -> enterBIT_NOT(unaryNode);
      case DELETE -> enterDELETE(unaryNode);
      case NEW -> enterNEW(unaryNode);
      case NOT -> enterNOT(unaryNode);
      case NEG -> enterNEG(unaryNode);
      case TYPEOF -> enterTYPEOF(unaryNode);
      case VOID -> enterVOID(unaryNode);
      case DECPREFIX, DECPOSTFIX, INCPREFIX, INCPOSTFIX -> enterDECINC(unaryNode);
      default -> super.enterUnaryNode(unaryNode);
    };
  }

  @Override
  public final Node leaveUnaryNode(UnaryNode unaryNode) {
    return switch (unaryNode.tokenType()) {
      case POS -> leavePOS(unaryNode);
      case BIT_NOT -> leaveBIT_NOT(unaryNode);
      case DELETE -> leaveDELETE(unaryNode);
      case NEW -> leaveNEW(unaryNode);
      case NOT -> leaveNOT(unaryNode);
      case NEG -> leaveNEG(unaryNode);
      case TYPEOF -> leaveTYPEOF(unaryNode);
      case VOID -> leaveVOID(unaryNode);
      case DECPREFIX, DECPOSTFIX, INCPREFIX, INCPOSTFIX -> leaveDECINC(unaryNode);
      default -> super.leaveUnaryNode(unaryNode);
    };
  }

  @Override
  public final boolean enterBinaryNode(BinaryNode binaryNode) {
    return switch (binaryNode.tokenType()) {
      case ADD -> enterADD(binaryNode);
      case AND -> enterAND(binaryNode);
      case ASSIGN -> enterASSIGN(binaryNode);
      case ASSIGN_ADD -> enterASSIGN_ADD(binaryNode);
      case ASSIGN_BIT_AND -> enterASSIGN_BIT_AND(binaryNode);
      case ASSIGN_BIT_OR -> enterASSIGN_BIT_OR(binaryNode);
      case ASSIGN_BIT_XOR -> enterASSIGN_BIT_XOR(binaryNode);
      case ASSIGN_DIV -> enterASSIGN_DIV(binaryNode);
      case ASSIGN_MOD -> enterASSIGN_MOD(binaryNode);
      case ASSIGN_MUL -> enterASSIGN_MUL(binaryNode);
      case ASSIGN_SAR -> enterASSIGN_SAR(binaryNode);
      case ASSIGN_SHL -> enterASSIGN_SHL(binaryNode);
      case ASSIGN_SHR -> enterASSIGN_SHR(binaryNode);
      case ASSIGN_SUB -> enterASSIGN_SUB(binaryNode);
      case ARROW -> enterARROW(binaryNode);
      case BIT_AND -> enterBIT_AND(binaryNode);
      case BIT_OR -> enterBIT_OR(binaryNode);
      case BIT_XOR -> enterBIT_XOR(binaryNode);
      case COMMARIGHT -> enterCOMMARIGHT(binaryNode);
      case DIV -> enterDIV(binaryNode);
      case EQ -> enterEQ(binaryNode);
      case EQU -> enterEQUIV(binaryNode);
      case GE -> enterGE(binaryNode);
      case GT -> enterGT(binaryNode);
      case IN -> enterIN(binaryNode);
      case INSTANCEOF -> enterINSTANCEOF(binaryNode);
      case LE -> enterLE(binaryNode);
      case LT -> enterLT(binaryNode);
      case MOD -> enterMOD(binaryNode);
      case MUL -> enterMUL(binaryNode);
      case NE -> enterNE(binaryNode);
      case NEQU -> enterNOT_EQUIV(binaryNode);
      case OR -> enterOR(binaryNode);
      case SAR -> enterSAR(binaryNode);
      case SHL -> enterSHL(binaryNode);
      case SHR -> enterSHR(binaryNode);
      case SUB -> enterSUB(binaryNode);
      default -> super.enterBinaryNode(binaryNode);
    };
  }

  @Override
  public final Node leaveBinaryNode(BinaryNode binaryNode) {
    return switch (binaryNode.tokenType()) {
      case ADD -> leaveADD(binaryNode);
      case AND -> leaveAND(binaryNode);
      case ASSIGN -> leaveASSIGN(binaryNode);
      case ASSIGN_ADD -> leaveASSIGN_ADD(binaryNode);
      case ASSIGN_BIT_AND -> leaveASSIGN_BIT_AND(binaryNode);
      case ASSIGN_BIT_OR -> leaveASSIGN_BIT_OR(binaryNode);
      case ASSIGN_BIT_XOR -> leaveASSIGN_BIT_XOR(binaryNode);
      case ASSIGN_DIV -> leaveASSIGN_DIV(binaryNode);
      case ASSIGN_MOD -> leaveASSIGN_MOD(binaryNode);
      case ASSIGN_MUL -> leaveASSIGN_MUL(binaryNode);
      case ASSIGN_SAR -> leaveASSIGN_SAR(binaryNode);
      case ASSIGN_SHL -> leaveASSIGN_SHL(binaryNode);
      case ASSIGN_SHR -> leaveASSIGN_SHR(binaryNode);
      case ASSIGN_SUB -> leaveASSIGN_SUB(binaryNode);
      case ARROW -> leaveARROW(binaryNode);
      case BIT_AND -> leaveBIT_AND(binaryNode);
      case BIT_OR -> leaveBIT_OR(binaryNode);
      case BIT_XOR -> leaveBIT_XOR(binaryNode);
      case COMMARIGHT -> leaveCOMMARIGHT(binaryNode);
      case DIV -> leaveDIV(binaryNode);
      case EQ -> leaveEQ(binaryNode);
      case EQU -> leaveEQUIV(binaryNode);
      case GE -> leaveGE(binaryNode);
      case GT -> leaveGT(binaryNode);
      case IN -> leaveIN(binaryNode);
      case INSTANCEOF -> leaveINSTANCEOF(binaryNode);
      case LE -> leaveLE(binaryNode);
      case LT -> leaveLT(binaryNode);
      case MOD -> leaveMOD(binaryNode);
      case MUL -> leaveMUL(binaryNode);
      case NE -> leaveNE(binaryNode);
      case NEQU -> leaveNOT_EQUIV(binaryNode);
      case OR -> leaveOR(binaryNode);
      case SAR -> leaveSAR(binaryNode);
      case SHL -> leaveSHL(binaryNode);
      case SHR -> leaveSHR(binaryNode);
      case SUB -> leaveSUB(binaryNode);
      default -> super.leaveBinaryNode(binaryNode);
    };
  }

  /*
     * Unary entries and exists.
   */
  /**
   * Unary enter - callback for entering a unary +
   *
   * @param  unaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterPOS(UnaryNode unaryNode) {
    return enterDefault(unaryNode);
  }

  /**
   * Unary leave - callback for leaving a unary +
   *
   * @param  unaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leavePOS(UnaryNode unaryNode) {
    return leaveDefault(unaryNode);
  }

  /**
   * Unary enter - callback for entering a ~ operator
   *
   * @param  unaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterBIT_NOT(UnaryNode unaryNode) {
    return enterDefault(unaryNode);
  }

  /**
   * Unary leave - callback for leaving a unary ~
   *
   * @param  unaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveBIT_NOT(UnaryNode unaryNode) {
    return leaveDefault(unaryNode);
  }

  /**
   * Unary enter - callback for entering a ++ or -- operator
   *
   * @param  unaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterDECINC(UnaryNode unaryNode) {
    return enterDefault(unaryNode);
  }

  /**
   * Unary leave - callback for leaving a ++ or -- operator
   *
   * @param  unaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveDECINC(UnaryNode unaryNode) {
    return leaveDefault(unaryNode);
  }

  /**
   * Unary enter - callback for entering a delete operator
   *
   * @param  unaryNode the node
   * @return processed node
   */
  public boolean enterDELETE(UnaryNode unaryNode) {
    return enterDefault(unaryNode);
  }

  /**
   * Unary leave - callback for leaving a delete operator
   *
   * @param  unaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveDELETE(UnaryNode unaryNode) {
    return leaveDefault(unaryNode);
  }

  /**
   * Unary enter - callback for entering a new operator
   *
   * @param  unaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterNEW(UnaryNode unaryNode) {
    return enterDefault(unaryNode);
  }

  /**
   * Unary leave - callback for leaving a new operator
   *
   * @param  unaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveNEW(UnaryNode unaryNode) {
    return leaveDefault(unaryNode);
  }

  /**
   * Unary enter - callback for entering a ! operator
   *
   * @param  unaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterNOT(UnaryNode unaryNode) {
    return enterDefault(unaryNode);
  }

  /**
   * Unary leave - callback for leaving a ! operator
   *
   * @param  unaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveNOT(UnaryNode unaryNode) {
    return leaveDefault(unaryNode);
  }

  /**
   * Unary enter - callback for entering a unary -
   *
   * @param  unaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterNEG(UnaryNode unaryNode) {
    return enterDefault(unaryNode);
  }

  /**
   * Unary leave - callback for leaving a unary -
   *
   * @param  unaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveNEG(UnaryNode unaryNode) {
    return leaveDefault(unaryNode);
  }

  /**
   * Unary enter - callback for entering a typeof
   *
   * @param  unaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterTYPEOF(UnaryNode unaryNode) {
    return enterDefault(unaryNode);
  }

  /**
   * Unary leave - callback for leaving a typeof operator
   *
   * @param  unaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveTYPEOF(UnaryNode unaryNode) {
    return leaveDefault(unaryNode);
  }

  /**
   * Unary enter - callback for entering a void
   *
   * @param  unaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterVOID(UnaryNode unaryNode) {
    return enterDefault(unaryNode);
  }

  /**
   * Unary leave - callback for leaving a void
   *
   * @param  unaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveVOID(UnaryNode unaryNode) {
    return leaveDefault(unaryNode);
  }

  /**
   * Binary enter - callback for entering + operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterADD(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a + operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveADD(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal &&} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterAND(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a {@literal &&} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveAND(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering an assignment
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving an assignment
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering += operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_ADD(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a += operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_ADD(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal &=} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_BIT_AND(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a {@literal &=} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_BIT_AND(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering |= operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_BIT_OR(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a |= operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_BIT_OR(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering ^= operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_BIT_XOR(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a ^= operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_BIT_XOR(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering /= operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_DIV(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a /= operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_DIV(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering %= operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_MOD(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a %= operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_MOD(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering *= operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_MUL(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a *= operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_MUL(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal >>=} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_SAR(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a {@literal >>=} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_SAR(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering a {@literal <<=} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_SHL(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a {@literal <<=} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_SHL(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal >>>=} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_SHR(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a {@literal >>>=} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_SHR(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering -= operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterASSIGN_SUB(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a -= operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveASSIGN_SUB(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering a arrow operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterARROW(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a arrow operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveARROW(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal &} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterBIT_AND(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a {@literal &} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveBIT_AND(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering | operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterBIT_OR(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a | operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveBIT_OR(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering ^ operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterBIT_XOR(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a  operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveBIT_XOR(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering comma right operator
   * (a, b) where the result is b
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterCOMMARIGHT(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a comma left operator
   * (a, b) where the result is b
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveCOMMARIGHT(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering a division
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterDIV(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving a division
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveDIV(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering == operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterEQ(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving == operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveEQ(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering === operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterEQUIV(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving === operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveEQUIV(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal >=} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterGE(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving {@literal >=} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveGE(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal >} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterGT(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving {@literal >} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveGT(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering in operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterIN(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving in operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveIN(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering instanceof operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterINSTANCEOF(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving instanceof operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveINSTANCEOF(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal <=} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterLE(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving {@literal <=} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveLE(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal <} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterLT(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving {@literal <} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveLT(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering % operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterMOD(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving % operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveMOD(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering * operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterMUL(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving * operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveMUL(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering != operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterNE(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving != operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveNE(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering a !== operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterNOT_EQUIV(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving !== operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveNOT_EQUIV(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering || operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterOR(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving || operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveOR(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal >>} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterSAR(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving {@literal >>} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveSAR(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal <<} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterSHL(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving {@literal <<} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveSHL(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering {@literal >>>} operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterSHR(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving {@literal >>>} operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveSHR(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

  /**
   * Binary enter - callback for entering - operator
   *
   * @param  binaryNode the node
   * @return true if traversal should continue and node children be traversed, false otherwise
   */
  public boolean enterSUB(BinaryNode binaryNode) {
    return enterDefault(binaryNode);
  }

  /**
   * Binary leave - callback for leaving - operator
   *
   * @param  binaryNode the node
   * @return processed node, which will replace the original one, or the original node
   */
  public Node leaveSUB(BinaryNode binaryNode) {
    return leaveDefault(binaryNode);
  }

}
