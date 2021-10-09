package es.runtime.arrays;

import nash.scripting.JSObject;
import es.runtime.JSType;

/**
 * Reverse iterator over a ScriptObjectMirror
 */
final class ReverseJSObjectIterator extends JSObjectIterator {

  ReverseJSObjectIterator(final JSObject obj, final boolean includeUndefined) {
    super(obj, includeUndefined);
    this.index = JSType.toUint32(obj.hasMember("length") ? obj.getMember("length") : 0) - 1;
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
