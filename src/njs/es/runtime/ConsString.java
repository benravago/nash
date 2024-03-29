package es.runtime;

import java.util.ArrayDeque;
import java.util.Deque;

import static es.runtime.JSType.isString;

/**
 * This class represents a string composed of two parts which may themselves be instances of <code>ConsString</code> or {@link String}.
 * Copying of characters to a proper string is delayed until it becomes necessary.
 */
public final class ConsString implements CharSequence {

  private CharSequence left, right;
  private final int length;
  private volatile int state = STATE_NEW;

  private final static int STATE_NEW = 0;
  private final static int STATE_THRESHOLD = 2;
  private final static int STATE_FLATTENED = -1;

  /**
   * Constructor
   *
   * Takes two {@link CharSequence} instances that, concatenated, forms this {@code ConsString}
   * @param left  left char sequence
   * @param right right char sequence
   */
  public ConsString(CharSequence left, CharSequence right) {
    assert isString(left);
    assert isString(right);
    this.left = left;
    this.right = right;
    length = left.length() + right.length();
    if (length < 0) {
      throw new IllegalArgumentException("too big concatenated String");
    }
  }

  @Override
  public String toString() {
    return (String) flattened(true);
  }

  @Override
  public int length() {
    return length;
  }

  @Override
  public char charAt(int index) {
    return flattened(true).charAt(index);
  }

  @Override
  public CharSequence subSequence(int start, int end) {
    return flattened(true).subSequence(start, end);
  }

  /**
   * Returns the components of this ConsString as a {@code CharSequence} array with two elements.
   * The elements will be either {@code Strings} or other {@code ConsStrings}.
   * @return CharSequence array of length 2
   */
  public synchronized CharSequence[] getComponents() {
    return new CharSequence[]{left, right};
  }

  CharSequence flattened(boolean flattenNested) {
    if (state != STATE_FLATTENED) {
      flatten(flattenNested);
    }
    return left;
  }

  synchronized void flatten(boolean flattenNested) {
    // We use iterative traversal as recursion may exceed the stack size limit.
    var chars = new char[length];
    int pos = length;
    // Strings are most often composed by appending to the end, which causes ConsStrings to be very unbalanced, with mostly single string elements on the right and a long linear list on the left.
    // Traversing from right to left helps to keep the stack small in this scenario.
    var stack = new ArrayDeque<CharSequence>();
    stack.addFirst(left);
    var cs = right;
    do {
      if (cs instanceof ConsString cons) {
        // Count the times a cons-string is traversed as part of other cons-strings being flattened.
        // If it crosses a threshold we flatten the nested cons-string internally.
        if (cons.state == STATE_FLATTENED || (flattenNested && ++cons.state >= STATE_THRESHOLD)) {
          cs = cons.flattened(false);
        } else {
          stack.addFirst(cons.left);
          cs = cons.right;
        }
      } else {
        var str = (String) cs;
        pos -= str.length();
        str.getChars(0, str.length(), chars, pos);
        cs = stack.isEmpty() ? null : stack.pollFirst();
      }
    } while (cs != null);
    left = new String(chars);
    right = "";
    state = STATE_FLATTENED;
  }

}
