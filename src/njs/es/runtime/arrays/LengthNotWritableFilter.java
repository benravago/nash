package es.runtime.arrays;

import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;

import es.runtime.JSType;
import es.runtime.ScriptRuntime;

/**
 * Filter to use for ArrayData where the length is not writable.
 *
 * The default behavior is just to ignore {@link ArrayData#setLength}
 */
final class LengthNotWritableFilter extends ArrayFilter {

  private final SortedMap<Long, Object> extraElements; // elements with index >= length

  /**
   * Constructor
   * @param underlying array
   */
  LengthNotWritableFilter(ArrayData underlying) {
    this(underlying, new TreeMap<Long, Object>());
  }

  LengthNotWritableFilter(ArrayData underlying, SortedMap<Long, Object> extraElements) {
    super(underlying);
    this.extraElements = extraElements;
  }

  @Override
  public ArrayData copy() {
    return new LengthNotWritableFilter(underlying.copy(), new TreeMap<>(extraElements));
  }

  @Override
  public boolean has(int index) {
    return super.has(index) || extraElements.containsKey((long) index);
  }

  /**
   * Set the length of the data array
   * @param length the new length for the data array
   */
  @Override
  public void setLength(long length) {
    // empty - setting length for a LengthNotWritableFilter is always a nop
  }

  @Override
  public ArrayData ensure(long index) {
    return this;
  }

  @Override
  public ArrayData slice(long from, long to) {
    // return array[from...to), or array[from...length] if undefined, in this case not as we are an ArrayData
    return new LengthNotWritableFilter(underlying.slice(from, to), extraElements.subMap(from, to));
  }

  boolean checkAdd(long index, Object value) {
    if (index >= length()) {
      extraElements.put(index, value);
      return true;
    }
    return false;
  }

  Object get(long index) {
    var obj = extraElements.get(index);
    return (obj == null) ? ScriptRuntime.UNDEFINED : obj;
  }

  @Override
  public int getInt(int index) {
    return (index >= length()) ? JSType.toInt32(get(index)) : underlying.getInt(index);
  }

  @Override
  public int getIntOptimistic(int index, int programPoint) {
    return (index >= length()) ? JSType.toInt32Optimistic(get(index), programPoint) : underlying.getIntOptimistic(index, programPoint);
  }

  @Override
  public double getDouble(int index) {
    return (index >= length()) ? JSType.toNumber(get(index)) : underlying.getDouble(index);
  }

  @Override
  public double getDoubleOptimistic(int index, int programPoint) {
    return (index >= length()) ? JSType.toNumberOptimistic(get(index), programPoint) : underlying.getDoubleOptimistic(index, programPoint);
  }

  @Override
  public Object getObject(int index) {
    return (index >= length()) ? get(index) : underlying.getObject(index);
  }

  @Override
  public ArrayData set(int index, Object value) {
    if (checkAdd(index, value)) {
      return this;
    }
    underlying = underlying.set(index, value);
    return this;
  }

  @Override
  public ArrayData set(int index, int value) {
    if (checkAdd(index, value)) {
      return this;
    }
    underlying = underlying.set(index, value);
    return this;
  }

  @Override
  public ArrayData set(int index, double value) {
    if (checkAdd(index, value)) {
      return this;
    }
    underlying = underlying.set(index, value);
    return this;
  }

  @Override
  public ArrayData delete(int index) {
    extraElements.remove(ArrayIndex.toLongIndex(index));
    underlying = underlying.delete(index);
    return this;
  }

  @Override
  public ArrayData delete(long fromIndex, long toIndex) {
    for (var iter = extraElements.keySet().iterator(); iter.hasNext();) {
      var next = iter.next();
      if (next >= fromIndex && next <= toIndex) {
        iter.remove();
      }
      if (next > toIndex) { //ordering guaranteed because TreeSet
        break;
      }
    }
    underlying = underlying.delete(fromIndex, toIndex);
    return this;
  }

  @Override
  public Iterator<Long> indexIterator() {
    var keys = computeIteratorKeys();
    keys.addAll(extraElements.keySet()); //even if they are outside length this is fine
    return keys.iterator();
  }

}
