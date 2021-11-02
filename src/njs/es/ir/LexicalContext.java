package es.ir;

import java.io.File;
import java.util.Iterator;
import java.util.NoSuchElementException;

import es.util.Hex;

/**
 * A class that tracks the current lexical context of node visitation as a stack of {@link Block} nodes.
 *
 * Has special methods to retrieve useful subsets of the context.
 *
 * This is implemented with a primitive array and a stack pointer, because it really makes a difference performance-wise.
 * None of the collection classes were optimal.
 */
public class LexicalContext {

  private LexicalContextNode[] stack;

  private int[] flags;
  private int sp;

  /**
   * Creates a new empty lexical context.
   */
  public LexicalContext() {
    stack = new LexicalContextNode[16];
    flags = new int[16];
  }

  /**
   * Set the flags for a lexical context node on the stack.
   * Does not replace the flags, but rather adds to them.
   * @param node  node
   * @param flag  new flag to set
   */
  public void setFlag(LexicalContextNode node, int flag) {
    if (flag != 0) {
      // Use setBlockNeedsScope() instead
      assert !(flag == Block.NEEDS_SCOPE && node instanceof Block);
      for (var i = sp - 1; i >= 0; i--) {
        if (stack[i] == node) {
          flags[i] |= flag;
          return;
        }
      }
    }
    assert false; // should not occur
  }

  /**
   * Marks the block as one that creates a scope.
   * Note that this method must be used instead of {@link #setFlag(LexicalContextNode, int)} with {@link Block#NEEDS_SCOPE}
   * because it atomically also sets the {@link FunctionNode#HAS_SCOPE_BLOCK} flag on the block's containing function.
   * @param block the block that needs to be marked as creating a scope.
   */
  public void setBlockNeedsScope(Block block) {
    for (var i = sp - 1; i >= 0; i--) {
      if (stack[i] == block) {
        flags[i] |= Block.NEEDS_SCOPE;
        for (var j = i - 1; j >= 0; j--) {
          if (stack[j] instanceof FunctionNode) {
            flags[j] |= FunctionNode.HAS_SCOPE_BLOCK;
            return;
          }
        }
      }
    }
    assert false; // should not occur
  }

  /**
   * Get the flags for a lexical context node on the stack.
   * @param node node
   * @return the flags for the node
   */
  public int getFlags(LexicalContextNode node) {
    for (var i = sp - 1; i >= 0; i--) {
      if (stack[i] == node) {
        return flags[i];
      }
    }
    assert false; // flag node not on context stack
    return -1;
  }

  /**
   * Get the function body of a function node on the lexical context stack.
   * This will trigger an assertion if node isn't present.
   * @param functionNode function node
   * @return body of function node
   */
  public Block getFunctionBody(FunctionNode functionNode) {
    for (var i = sp - 1; i >= 0; i--) {
      if (stack[i] == functionNode) {
        return (Block) stack[i + 1];
      }
    }
    assert false; // functionNode.getName() + " not on context stack"
    return null;
  }

  /**
   * @return all nodes in the LexicalContext.
   */
  public Iterator<LexicalContextNode> getAllNodes() {
    return new NodeIterator<>(LexicalContextNode.class);
  }

  /**
   * Returns the outermost function in this context. It is either the program,
   * or a lazily compiled function.
   *
   * @return the outermost function in this context.
   */
  public FunctionNode getOutermostFunction() {
    return (FunctionNode) stack[0];
  }

  /**
   * Pushes a new block on top of the context, making it the innermost open
   * block.
   *
   * @param <T> the type of the new node
   * @param node the new node
   *
   * @return the node that was pushed
   */
  public <T extends LexicalContextNode> T push(T node) {
    assert !contains(node);
    if (sp == stack.length) {
      var newStack = new LexicalContextNode[sp * 2];
      System.arraycopy(stack, 0, newStack, 0, sp);
      stack = newStack;
      var newFlags = new int[sp * 2];
      System.arraycopy(flags, 0, newFlags, 0, sp);
      flags = newFlags;
    }
    stack[sp] = node;
    flags[sp] = 0;
    sp++;
    return node;
  }

  /**
   * Is the context empty?
   * @return {@code true} if empty
   */
  public boolean isEmpty() {
    return sp == 0;
  }

  /**
   * @return the depth of the lexical context.
   */
  public int size() {
    return sp;
  }

  /**
   * Pops the innermost block off the context and all nodes that has been contributed since it was put there.
   * @param <T> the type of the node to be popped
   * @param node the node expected to be popped, used to detect unbalanced pushes/pops
   * @return the node that was popped
   */
  public <T extends Node> T pop(T node) {
    --sp;
    var popped = stack[sp];
    stack[sp] = null;
    return (T) (popped instanceof Flags f ? f.setFlag(this, flags[sp]) : popped);
  }

  /**
   * Explicitly apply flags to the topmost element on the stack.
   * This is only valid to use from a {@code NodeVisitor.leaveXxx()} method and only on the node being exited at the time.
   * It is not mandatory to use, as {@link #pop(Node)} will apply the flags automatically,
   * but this method can be used to apply them during the {@code leaveXxx()} method in case its logic depends on the value of the flags.
   * @param <T> the type of the node to apply the flags to.
   * @param node the node to apply the flags to. Must be the topmost node on the stack.
   * @return the passed in node, or a modified node (if any flags were modified)
   */
  public <T extends LexicalContextNode & Flags<T>> T applyTopFlags(T node) {
    assert node == peek();
    return node.setFlag(this, flags[sp - 1]);
  }

  /**
   * Return the top element in the context.
   * @return the node that was pushed last
   */
  public LexicalContextNode peek() {
    return stack[sp - 1];
  }

  /**
   * Check if a node is in the lexical context.
   * @param node node to check for
   * @return {@code true} if in the context
   */
  public boolean contains(LexicalContextNode node) {
    for (var i = 0; i < sp; i++) {
      if (stack[i] == node) {
        return true;
      }
    }
    return false;
  }

  /**
   * Replace a node on the lexical context with a new one.
   * Normally you should try to engineer IR traversals so this isn't needed
   * @param oldNode old node
   * @param newNode new node
   * @return the new node
   */
  public LexicalContextNode replace(LexicalContextNode oldNode, LexicalContextNode newNode) {
    for (var i = sp - 1; i >= 0; i--) {
      if (stack[i] == oldNode) {
        assert i == sp - 1 : "violation of contract - we always expect to find the replacement node on top of the lexical context stack: " + newNode + " has " + stack[i + 1].getClass() + " above it";
        stack[i] = newNode;
        break;
      }
    }
    return newNode;
  }

  /**
   * Returns an iterator over all blocks in the context, with the top block (innermost lexical context) first.
   * @return an iterator over all blocks in the context.
   */
  public Iterator<Block> getBlocks() {
    return new NodeIterator<>(Block.class);
  }

  /**
   * Returns an iterator over all functions in the context, with the top (innermost open) function first.
   * @return an iterator over all functions in the context.
   */
  public Iterator<FunctionNode> getFunctions() {
    return new NodeIterator<>(FunctionNode.class);
  }

  /**
   * Get the parent block for the current lexical context block
   * @return parent block
   */
  public Block getParentBlock() {
    var iter = new NodeIterator<>(Block.class, getCurrentFunction());
    iter.next();
    return iter.hasNext() ? iter.next() : null;
  }

  /**
   * Gets the label node of the current block.
   * @return the label node of the current block, if it is labeled.
   * Otherwise returns {@code null}.
   */
  public LabelNode getCurrentBlockLabelNode() {
    assert stack[sp - 1] instanceof Block;
    if (sp < 2) {
      return null;
    }
    var parent = stack[sp - 2];
    return (parent instanceof LabelNode label) ? label : null;
  }

  /**
   * Returns an iterator over all ancestors block of the given block, with its parent block first.
   * @param block the block whose ancestors are returned
   * @return an iterator over all ancestors block of the given block.
   */
  public Iterator<Block> getAncestorBlocks(Block block) {
    var iter = getBlocks();
    while (iter.hasNext()) {
      var b = iter.next();
      if (block == b) {
        return iter;
      }
    }
    assert false : "Block is not on the current lexical context stack";
    return null;
  }

  /**
   * Returns an iterator over a block and all its ancestors blocks, with the block first.
   * @param block the block that is the starting point of the iteration.
   * @return an iterator over a block and all its ancestors.
   */
  public Iterator<Block> getBlocks(Block block) {
    var iter = getAncestorBlocks(block);
    return new Iterator<>() {
      boolean blockReturned = false;

      @Override
      public boolean hasNext() {
        return iter.hasNext() || !blockReturned;
      }
      @Override
      public Block next() {
        if (blockReturned) {
          return iter.next();
        }
        blockReturned = true;
        return block;
      }
      @Override
      public void remove() {
        throw new UnsupportedOperationException();
      }
    };
  }

  /**
   * Get the function for this block.
   * @param block block for which to get function
   * @return function for block
   */
  public FunctionNode getFunction(Block block) {
    var iter = new NodeIterator<>(LexicalContextNode.class);
    while (iter.hasNext()) {
      var next = iter.next();
      if (next == block) {
        while (iter.hasNext()) {
          var next2 = iter.next();
          if (next2 instanceof FunctionNode node) {
            return node;
          }
        }
      }
    }
    assert false; // should not occur
    return null;
  }

  /**
   * @return the innermost block in the context.
   */
  public Block getCurrentBlock() {
    return getBlocks().next();
  }

  /**
   * @return the innermost function in the context.
   */
  public FunctionNode getCurrentFunction() {
    for (var i = sp - 1; i >= 0; i--) {
      if (stack[i] instanceof FunctionNode node) {
        return node;
      }
    }
    return null;
  }

  /**
   * Get the block in which a symbol is defined.
   *
   * @param symbol symbol
   *
   * @return block in which the symbol is defined, assert if no such block in
   *         context.
   */
  public Block getDefiningBlock(Symbol symbol) {
    var name = symbol.getName();
    for (var it = getBlocks(); it.hasNext();) {
      var next = it.next();
      if (next.getExistingSymbol(name) == symbol) {
        return next;
      }
    }
    assert false; // "Couldn't find symbol " + name + " in the context"
    return null;
  }

  /**
   * Get the function in which a symbol is defined.
   *
   * @param symbol symbol
   *
   * @return function node in which this symbol is defined, assert if no such
   *         symbol exists in context.
   */
  public FunctionNode getDefiningFunction(Symbol symbol) {
    var name = symbol.getName();
    for (var iter = new NodeIterator<>(LexicalContextNode.class); iter.hasNext();) {
      var next = iter.next();
      if (next instanceof Block && ((Block) next).getExistingSymbol(name) == symbol) {
        while (iter.hasNext()) {
          var next2 = iter.next();
          if (next2 instanceof FunctionNode node) {
            return node;
          }
        }
        assert false; // "Defining block for symbol " + name + " has no function in the context"
        return null;
      }
    }
    assert false; // "Couldn't find symbol " + name + " in the context"
    return null;
  }

  /**
   * Is the topmost lexical context element a function body?
   * @return {@code true} if function body.
   */
  public boolean isFunctionBody() {
    return getParentBlock() == null;
  }

  /**
   * Is the topmost lexical context element body of a SplitNode?
   * @return {@code true} if it's the body of a split node.
   */
  public boolean isSplitBody() {
    return sp >= 2 && stack[sp - 1] instanceof Block && stack[sp - 2] instanceof SplitNode;
  }

  /**
   * Get the parent function for a function in the lexical context.
   * @param functionNode function for which to get parent
   * @return parent function of functionNode or {@code null} if none (e.g., if functionNode is the program).
   */
  public FunctionNode getParentFunction(FunctionNode functionNode) {
    var iter = new NodeIterator<>(FunctionNode.class);
    while (iter.hasNext()) {
      var next = iter.next();
      if (next == functionNode) {
        return iter.hasNext() ? iter.next() : null;
      }
    }
    assert false; // should not occur
    return null;
  }

  /**
   * Count the number of scopes until a given node.
   * Note that this method is solely used to figure out the number of scopes that need to be explicitly popped in order to perform a break or continue jump within the current bytecode method.
   * For this reason, the method returns 0 if it encounters a {@code SplitNode} between the current location and the break/continue target.
   * @param until node to stop counting at. Must be within the current function.
   * @return number of with scopes encountered in the context.
   */
  public int getScopeNestingLevelTo(LexicalContextNode until) {
    assert until != null;
    // count the number of with nodes until "until" is hit
    var n = 0;
    for (var iter = getAllNodes(); iter.hasNext();) {
      var node = iter.next();
      if (node == until) {
        break;
      }
      assert !(node instanceof FunctionNode); // Can't go outside current function
      if (node instanceof Block && ((Block) node).needsScope()) {
        n++;
      }
    }
    return n;
  }

  BreakableNode getBreakable() {
    for (var iter = new NodeIterator<>(BreakableNode.class, getCurrentFunction()); iter.hasNext();) {
      var next = iter.next();
      if (next.isBreakableWithoutLabel()) {
        return next;
      }
    }
    return null;
  }

  /**
   * Check whether the lexical context is currently inside a loop.
   * @return {@code true} if inside a loop
   */
  public boolean inLoop() {
    return getCurrentLoop() != null;
  }

  /**
   * @return the loop header of the current loop, or {@code null} if not inside a loop.
   */
  public LoopNode getCurrentLoop() {
    var iter = new NodeIterator<>(LoopNode.class, getCurrentFunction());
    return iter.hasNext() ? iter.next() : null;
  }

  /**
   * Find the breakable node corresponding to this label.
   * @param labelName name of the label to search for.
   *    If {@code null}, the closest breakable node will be returned unconditionally, e.g., a while loop with no label.
   * @return closest breakable node.
   */
  public BreakableNode getBreakable(String labelName) {
    if (labelName != null) {
      var foundLabel = findLabel(labelName);
      if (foundLabel != null) {
        // iterate to the nearest breakable to the foundLabel
        BreakableNode breakable = null;
        for (var iter = new NodeIterator<>(BreakableNode.class, foundLabel); iter.hasNext();) {
          breakable = iter.next();
        }
        return breakable;
      }
      return null;
    }
    return getBreakable();
  }

  LoopNode getContinueTo() {
    return getCurrentLoop();
  }

  /**
   * Find the continue target node corresponding to this label.
   * @param labelName label name to search for.
   *    If {@code null} the closest loop node will be returned unconditionally, e.g., a while loop with no label.
   * @return closest continue target node.
   */
  public LoopNode getContinueTo(String labelName) {
    if (labelName != null) {
      var foundLabel = findLabel(labelName);
      if (foundLabel != null) {
        // iterate to the nearest loop to the foundLabel
        LoopNode loop = null;
        for (var iter = new NodeIterator<>(LoopNode.class, foundLabel); iter.hasNext();) {
          loop = iter.next();
        }
        return loop;
      }
      return null;
    }
    return getContinueTo();
  }

  /**
   * Find the inlined finally block node corresponding to this label.
   * @param labelName label name to search for. Must not be {@code null}.
   * @return closest inlined finally block with the given label.
   */
  public Block getInlinedFinally(String labelName) {
    for (var iter = new NodeIterator<>(TryNode.class); iter.hasNext();) {
      var inlinedFinally = iter.next().getInlinedFinally(labelName);
      if (inlinedFinally != null) {
        return inlinedFinally;
      }
    }
    return null;
  }

  /**
   * Find the try node for an inlined finally block corresponding to this label.
   * @param labelName label name to search for. Must not be {@code null}.
   * @return the try node to which the labelled inlined finally block belongs.
   */
  public TryNode getTryNodeForInlinedFinally(String labelName) {
    for (var iter = new NodeIterator<>(TryNode.class); iter.hasNext();) {
      var tryNode = iter.next();
      if (tryNode.getInlinedFinally(labelName) != null) {
        return tryNode;
      }
    }
    return null;
  }

  /**
   * Check the lexical context for a given label node by name.
   * @param name name of the label.
   * @return LabelNode if found, {@code null} otherwise.
   */
  private LabelNode findLabel(String name) {
    for (var iter = new NodeIterator<>(LabelNode.class, getCurrentFunction()); iter.hasNext();) {
      var next = iter.next();
      if (next.getLabelName().equals(name)) {
        return next;
      }
    }
    return null;
  }

  /**
   * Checks whether a given target is a jump destination that lies outside a given split node.
   * @param splitNode the split node.
   * @param target the target node.
   * @return {@code true} if target resides outside the split node.
   */
  public boolean isExternalTarget(SplitNode splitNode, BreakableNode target) {
    for (var i = sp; i-- > 0;) {
      var next = stack[i];
      if (next == splitNode) {
        return true;
      } else if (next == target) {
        return false;
      } else if (next instanceof TryNode node) {
        for (var inlinedFinally : node.getInlinedFinallies()) {
          if (TryNode.getLabelledInlinedFinallyBlock(inlinedFinally) == target) {
            return false;
          }
        }
      }
    }
    assert false; // target + " was expected in lexical context " + LexicalContext.this + " but wasn't"
    return false;
  }

  /**
   * Checks whether the current context is inside a switch statement without explicit blocks (curly braces).
   * @return {@code true} if in unprotected switch statement.
   */
  public boolean inUnprotectedSwitchContext() {
    for (var i = sp - 1; i > 0; i--) {
      var next = stack[i];
      if (next instanceof Block) {
        return stack[i - 1] instanceof SwitchNode;
      }
    }
    return false;
  }

  @Override
  public String toString() {
    var sb = new StringBuffer();
    sb.append("[ ");
    for (var i = 0; i < sp; i++) {
      var node = stack[i];
      sb.append(node.getClass().getSimpleName());
      sb.append('@');
      sb.append(Hex.id(node));
      sb.append(':');
      if (node instanceof FunctionNode fn) {
        var source = fn.getSource();
        var src = source.toString();
        if (src.contains(File.pathSeparator)) {
          src = src.substring(src.lastIndexOf(File.pathSeparator));
        }
        src += ' ';
        src += fn.getLineNumber();
        sb.append(src);
      }
      sb.append(' ');
    }
    sb.append(" ==> ]");
    return sb.toString();
  }

  class NodeIterator<T extends LexicalContextNode> implements Iterator<T> {

    private int index;
    private T next;
    private final Class<T> clazz;
    private LexicalContextNode until;

    NodeIterator(Class<T> clazz) {
      this(clazz, null);
    }

    NodeIterator(Class<T> clazz, LexicalContextNode until) {
      this.index = sp - 1;
      this.clazz = clazz;
      this.until = until;
      this.next = findNext();
    }

    @Override
    public boolean hasNext() {
      return next != null;
    }

    @Override
    public T next() {
      if (next == null) {
        throw new NoSuchElementException();
      }
      var lnext = next;
      next = findNext();
      return lnext;
    }

    T findNext() {
      for (var i = index; i >= 0; i--) {
        var node = stack[i];
        if (node == until) {
          return null;
        }
        if (clazz.isAssignableFrom(node.getClass())) {
          index = i - 1;
          return (T) node;
        }
      }
      return null;
    }

    @Override
    public void remove() {
      throw new UnsupportedOperationException();
    }
  }

}
