package es.runtime.arrays;

import java.util.Iterator;
import java.util.List;

import nash.scripting.JSObject;

import es.runtime.JSType;
import es.runtime.ScriptObject;

/**
 * Superclass for array iterators
 * TODO: rewrite these
 *
 * @param <T> element type
 */
abstract public class ArrayLikeIterator<T> implements Iterator<T> {

  // current element index in iteration
  protected long index;

  // should undefined elements be included in the iteration?
  protected final boolean includeUndefined;

  /**
   * Constructor
   *
   * @param includeUndefined should undefined elements be included in the iteration?
   */
  ArrayLikeIterator(boolean includeUndefined) {
    this.includeUndefined = includeUndefined;
    this.index = 0;
  }

  /**
   * Is this a reverse order iteration?
   * @return true if reverse
   */
  public boolean isReverse() {
    return false;
  }

  /**
   * Go the the next valid element index of the iterator
   * @return next index
   */
  protected long bumpIndex() {
    return index++;
  }

  /**
   * Return the next valid element index of the iterator
   * @return next index
   */
  public long nextIndex() {
    return index;
  }

  @Override
  public void remove() {
    throw new UnsupportedOperationException("remove");
  }

  /**
   * Get the length of the iteration
   * @return length
   */
  public abstract long getLength();

  /**
   * ArrayLikeIterator factory
   * @param object object over which to do element iteration
   * @return iterator
   */
  public static ArrayLikeIterator<Object> arrayLikeIterator(Object object) {
    return arrayLikeIterator(object, false);
  }

  /**
   * ArrayLikeIterator factory (reverse order)
   * @param object object over which to do reverse element iteration
   * @return iterator
   */
  public static ArrayLikeIterator<Object> reverseArrayLikeIterator(Object object) {
    return reverseArrayLikeIterator(object, false);
  }

  /**
   * ArrayLikeIterator factory
   * @param object object over which to do reverse element iteration
   * @param includeUndefined should undefined elements be included in the iteration
   * @return iterator
   */
  public static ArrayLikeIterator<Object> arrayLikeIterator(Object object, boolean includeUndefined) {
    var obj = object;
    if (ScriptObject.isArray(obj)) {
      return new ScriptArrayIterator((ScriptObject) obj, includeUndefined);
    }
    obj = JSType.toScriptObject(obj);
    if (obj instanceof ScriptObject) {
      return new ScriptObjectIterator((ScriptObject) obj, includeUndefined);
    }
    if (obj instanceof JSObject) {
      return new JSObjectIterator((JSObject) obj, includeUndefined);
    }
    if (obj instanceof List) {
      return new JavaListIterator((List<?>) obj, includeUndefined);
    }
    if (obj != null && obj.getClass().isArray()) {
      return new JavaArrayIterator(obj, includeUndefined);
    }
    return new EmptyArrayLikeIterator();
  }

  /**
   * ArrayLikeIterator factory (reverse order)
   * @param object object over which to do reverse element iteration
   * @param includeUndefined should undefined elements be included in the iteration
   * @return iterator
   */
  public static ArrayLikeIterator<Object> reverseArrayLikeIterator(Object object, boolean includeUndefined) {
    var obj = object;
    if (ScriptObject.isArray(obj)) {
      return new ReverseScriptArrayIterator((ScriptObject) obj, includeUndefined);
    }
    obj = JSType.toScriptObject(obj);
    if (obj instanceof ScriptObject so) {
      return new ReverseScriptObjectIterator(so, includeUndefined);
    }
    if (obj instanceof JSObject jso) {
      return new ReverseJSObjectIterator(jso, includeUndefined);
    }
    if (obj instanceof List l) {
      return new ReverseJavaListIterator(l, includeUndefined);
    }
    if (obj != null && obj.getClass().isArray()) {
      return new ReverseJavaArrayIterator(obj, includeUndefined);
    }
    return new EmptyArrayLikeIterator();
  }

}
