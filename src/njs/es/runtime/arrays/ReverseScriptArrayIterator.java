package es.runtime.arrays;

import es.runtime.ScriptObject;

/**
 * Reverse iterator over a NativeArray
 */
final class ReverseScriptArrayIterator extends ScriptArrayIterator {

  /**
   * Constructor
   * @param array array to iterate over
   * @param includeUndefined should undefined elements be included in iteration
   */
  public ReverseScriptArrayIterator(ScriptObject array, boolean includeUndefined) {
    super(array, includeUndefined);
    this.index = array.getArray().length() - 1;
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
