package es.runtime.arrays;

import java.lang.reflect.Array;

/**
 * Reverse iterator over a array
 */
final class ReverseJavaArrayIterator extends JavaArrayIterator {

  /**
   * Constructor
   * @param array array to iterate over
   * @param includeUndefined should undefined elements be included in iteration
   */
  public ReverseJavaArrayIterator(Object array, boolean includeUndefined) {
    super(array, includeUndefined);
    this.index = Array.getLength(array) - 1;
  }

  @Override
  public boolean isReverse() {
    return true;
  }

  @Override
  protected boolean indexInArray() {
    return index >= 0;
  }

  @Override
  protected long bumpIndex() {
    return index--;
  }

}
