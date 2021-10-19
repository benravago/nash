package es.runtime.arrays;

import java.util.List;

/**
 * Reverse iterator over a List
 */
final class ReverseJavaListIterator extends JavaListIterator {

  /**
   * Constructor
   * @param list list to iterate over
   * @param includeUndefined should undefined elements be included in iteration
   */
  public ReverseJavaListIterator(List<?> list, boolean includeUndefined) {
    super(list, includeUndefined);
    this.index = list.size() - 1;
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
