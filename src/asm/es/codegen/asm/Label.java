package es.codegen.asm;

public class Label {

  static final int FLAG_DEBUG_ONLY = 1;
  static final int FLAG_JUMP_TARGET = 2;
  static final int FLAG_RESOLVED = 4;
  static final int FLAG_REACHABLE = 8;
  static final int FLAG_SUBROUTINE_CALLER = 16;
  static final int FLAG_SUBROUTINE_START = 32;
  static final int FLAG_SUBROUTINE_END = 64;

  static final int LINE_NUMBERS_CAPACITY_INCREMENT = 4;
  static final int FORWARD_REFERENCES_CAPACITY_INCREMENT = 6;

  static final int FORWARD_REFERENCE_TYPE_MASK = 0xF0000000;
  static final int FORWARD_REFERENCE_TYPE_SHORT = 0x10000000;
  static final int FORWARD_REFERENCE_TYPE_WIDE = 0x20000000;
  static final int FORWARD_REFERENCE_HANDLE_MASK = 0x0FFFFFFF;

  static final Label EMPTY_LIST = new Label();

  Object info;
  short flags;
  short lineNumber;
  int[] otherLineNumbers;
  int bytecodeOffset;
  int[] forwardReferences;

  short inputStackSize;
  short outputStackSize;
  short outputStackMax;
  short subroutineId;

  Frame frame;
  Label nextBasicBlock;
  Edge outgoingEdges;
  Label nextListElement;

  public int getOffset() {
    if ((flags & FLAG_RESOLVED) == 0) {
      throw new IllegalStateException("Label offset position has not been resolved yet");
    }
    return bytecodeOffset;
  }

  Label getCanonicalInstance() {
    return frame == null ? this : frame.owner;
  }

  void addLineNumber(int lineNumber) {
    if (this.lineNumber == 0) {
      this.lineNumber = (short) lineNumber;
    } else {
      if (otherLineNumbers == null) {
        otherLineNumbers = new int[LINE_NUMBERS_CAPACITY_INCREMENT];
      }
      var otherLineNumberIndex = ++otherLineNumbers[0];
      if (otherLineNumberIndex >= otherLineNumbers.length) {
        var newLineNumbers = new int[otherLineNumbers.length + LINE_NUMBERS_CAPACITY_INCREMENT];
        System.arraycopy(otherLineNumbers, 0, newLineNumbers, 0, otherLineNumbers.length);
        otherLineNumbers = newLineNumbers;
      }
      otherLineNumbers[otherLineNumberIndex] = lineNumber;
    }
  }

  void accept(MethodVisitor methodVisitor, boolean visitLineNumbers) {
    methodVisitor.visitLabel(this);
    if (visitLineNumbers && lineNumber != 0) {
      methodVisitor.visitLineNumber(lineNumber & 0xFFFF, this);
      if (otherLineNumbers != null) {
        for (var i = 1; i <= otherLineNumbers[0]; ++i) {
          methodVisitor.visitLineNumber(otherLineNumbers[i], this);
        }
      }
    }
  }

  void put(ByteVector code, int sourceInsnBytecodeOffset, boolean wideReference) {
    if ((flags & FLAG_RESOLVED) == 0) {
      if (wideReference) {
        addForwardReference(sourceInsnBytecodeOffset, FORWARD_REFERENCE_TYPE_WIDE, code.length);
        code.putInt(-1);
      } else {
        addForwardReference(sourceInsnBytecodeOffset, FORWARD_REFERENCE_TYPE_SHORT, code.length);
        code.putShort(-1);
      }
    } else {
      if (wideReference) {
        code.putInt(bytecodeOffset - sourceInsnBytecodeOffset);
      } else {
        code.putShort(bytecodeOffset - sourceInsnBytecodeOffset);
      }
    }
  }

  void addForwardReference(int sourceInsnBytecodeOffset, int referenceType, int referenceHandle) {
    if (forwardReferences == null) {
      forwardReferences = new int[FORWARD_REFERENCES_CAPACITY_INCREMENT];
    }
    var lastElementIndex = forwardReferences[0];
    if (lastElementIndex + 2 >= forwardReferences.length) {
      var newValues = new int[forwardReferences.length + FORWARD_REFERENCES_CAPACITY_INCREMENT];
      System.arraycopy(forwardReferences, 0, newValues, 0, forwardReferences.length);
      forwardReferences = newValues;
    }
    forwardReferences[++lastElementIndex] = sourceInsnBytecodeOffset;
    forwardReferences[++lastElementIndex] = referenceType | referenceHandle;
    forwardReferences[0] = lastElementIndex;
  }

  void resolve(byte[] code, int bytecodeOffset) {
    this.flags |= FLAG_RESOLVED;
    this.bytecodeOffset = bytecodeOffset;
    if (forwardReferences == null) {
      return;
    }
    for (var i = forwardReferences[0]; i > 0; i -= 2) {
      var sourceInsnBytecodeOffset = forwardReferences[i - 1];
      var reference = forwardReferences[i];
      var relativeOffset = bytecodeOffset - sourceInsnBytecodeOffset;
      var handle = reference & FORWARD_REFERENCE_HANDLE_MASK;
      if ((reference & FORWARD_REFERENCE_TYPE_MASK) == FORWARD_REFERENCE_TYPE_SHORT) {
        if (relativeOffset < Short.MIN_VALUE || relativeOffset > Short.MAX_VALUE) {
          throw new IllegalArgumentException("ASM_*_DELTA");
        }
        code[handle++] = (byte) (relativeOffset >>> 8);
        code[handle] = (byte) relativeOffset;
      } else {
        code[handle++] = (byte) (relativeOffset >>> 24);
        code[handle++] = (byte) (relativeOffset >>> 16);
        code[handle++] = (byte) (relativeOffset >>> 8);
        code[handle] = (byte) relativeOffset;
      }
    }
  }

  void markSubroutine(short subroutineId) {
    // Data flow algorithm: put this basic block in a list of blocks to process (which are blocks belonging to subroutine subroutineId) and, while there are blocks to process, remove one from the list, mark it as belonging to the subroutine, and add its successor basic blocks in the control flow graph to the list of blocks to process (if not already done).
    var listOfBlocksToProcess = this;
    listOfBlocksToProcess.nextListElement = EMPTY_LIST;
    while (listOfBlocksToProcess != EMPTY_LIST) {
      // Remove a basic block from the list of blocks to process.
      var basicBlock = listOfBlocksToProcess;
      listOfBlocksToProcess = listOfBlocksToProcess.nextListElement;
      basicBlock.nextListElement = null;
      // If it is not already marked as belonging to a subroutine, mark it as belonging to subroutineId and add its successors to the list of blocks to process (unless already done).
      if (basicBlock.subroutineId == 0) {
        basicBlock.subroutineId = subroutineId;
        listOfBlocksToProcess = basicBlock.pushSuccessors(listOfBlocksToProcess);
      }
    }
  }

  void addSubroutineRetSuccessors(Label subroutineCaller) {
    // Data flow algorithm: put this basic block in a list blocks to process (which are blocks belonging to a subroutine starting with this label) and, while there are blocks to process, remove one from the list, put it in a list of blocks that have been processed, add a return edge to the successor of subroutineCaller if applicable, and add its successor basic blocks in the control flow graph to the list of blocks to process (if not already done).
    var listOfProcessedBlocks = EMPTY_LIST;
    var listOfBlocksToProcess = this;
    listOfBlocksToProcess.nextListElement = EMPTY_LIST;
    while (listOfBlocksToProcess != EMPTY_LIST) {
      // Move a basic block from the list of blocks to process to the list of processed blocks.
      var basicBlock = listOfBlocksToProcess;
      listOfBlocksToProcess = basicBlock.nextListElement;
      basicBlock.nextListElement = listOfProcessedBlocks;
      listOfProcessedBlocks = basicBlock;
      // Add an edge from this block to the successor of the caller basic block, if this block is the end of a subroutine and if this block and subroutineCaller do not belong to the same subroutine.
      if ((basicBlock.flags & FLAG_SUBROUTINE_END) != 0 && basicBlock.subroutineId != subroutineCaller.subroutineId) {
        // By construction, the first outgoing edge of a basic block that ends with a jsr instruction leads to the jsr continuation block, i.e. where execution continues when ret is called (see {@link #FLAG_SUBROUTINE_CALLER}).
        basicBlock.outgoingEdges = new Edge(basicBlock.outputStackSize, subroutineCaller.outgoingEdges.successor, basicBlock.outgoingEdges);
      }
      // Add its successors to the list of blocks to process. Note that {@link #pushSuccessors} does not push basic blocks which are already in a list. Here this means either in the list of blocks to process, or in the list of already processed blocks. This second list is important to make sure we don't reprocess an already processed block.
      listOfBlocksToProcess = basicBlock.pushSuccessors(listOfBlocksToProcess);
    }
    // Reset the {@link #nextListElement} of all the basic blocks that have been processed to null, so that this method can be called again with a different subroutine or subroutine caller.
    while (listOfProcessedBlocks != EMPTY_LIST) {
      var newListOfProcessedBlocks = listOfProcessedBlocks.nextListElement;
      listOfProcessedBlocks.nextListElement = null;
      listOfProcessedBlocks = newListOfProcessedBlocks;
    }
  }

  Label pushSuccessors(Label listOfLabelsToProcess) {
    var newListOfLabelsToProcess = listOfLabelsToProcess;
    var outgoingEdge = outgoingEdges;
    while (outgoingEdge != null) {
      // By construction, the second outgoing edge of a basic block that ends with a jsr instruction leads to the jsr target (see {@link #FLAG_SUBROUTINE_CALLER}).
      var isJsrTarget = (flags & Label.FLAG_SUBROUTINE_CALLER) != 0 && outgoingEdge == outgoingEdges.nextEdge;
      if (!isJsrTarget && outgoingEdge.successor.nextListElement == null) {
        // Add this successor to the list of blocks to process, if it does not already belong to a list of labels.
        outgoingEdge.successor.nextListElement = newListOfLabelsToProcess;
        newListOfLabelsToProcess = outgoingEdge.successor;
      }
      outgoingEdge = outgoingEdge.nextEdge;
    }
    return newListOfLabelsToProcess;
  }

  @Override
  public String toString() {
    return "L" + System.identityHashCode(this);
  }
}
