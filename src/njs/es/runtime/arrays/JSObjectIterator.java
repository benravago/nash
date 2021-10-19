package es.runtime.arrays;

import java.util.NoSuchElementException;

import nash.scripting.JSObject;
import es.runtime.JSType;

/**
 * Iterator over a ScriptObjectMirror
 */
class JSObjectIterator extends ArrayLikeIterator<Object> {

  protected final JSObject obj;
  private final long length;

  JSObjectIterator(JSObject obj, boolean includeUndefined) {
    super(includeUndefined);
    this.obj = obj;
    this.length = JSType.toUint32(obj.hasMember("length") ? obj.getMember("length") : 0);
    this.index = 0;
  }

  protected boolean indexInArray() {
    return index < length;
  }

  @Override
  public long getLength() {
    return length;
  }

  @Override
  public boolean hasNext() {
    if (length == 0L) {
      return false; //return empty string if toUint32(length) == 0
    }
    while (indexInArray()) {
      if (obj.hasSlot((int) index) || includeUndefined) {
        break;
      }
      bumpIndex();
    }
    return indexInArray();
  }

  @Override
  public Object next() {
    if (indexInArray()) {
      return obj.getSlot((int) bumpIndex());
    }
    throw new NoSuchElementException();
  }

}
