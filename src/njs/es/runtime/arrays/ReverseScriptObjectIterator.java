package es.runtime.arrays;

import es.runtime.JSType;
import es.runtime.ScriptObject;

/**
 * Reverse iterator over a map
 */
final class ReverseScriptObjectIterator extends ScriptObjectIterator {

  ReverseScriptObjectIterator(ScriptObject obj, boolean includeUndefined) {
    super(obj, includeUndefined);
    this.index = JSType.toUint32(obj.getLength()) - 1;
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
