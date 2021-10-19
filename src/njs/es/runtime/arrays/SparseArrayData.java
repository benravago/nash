package es.runtime.arrays;

import java.util.Arrays;
import java.util.TreeMap;

import es.codegen.types.Type;
import es.runtime.JSType;
import es.runtime.ScriptRuntime;

/**
 * Handle arrays where the index is very large.
 */
class SparseArrayData extends ArrayData {

  // Maximum size for dense arrays
  static final int MAX_DENSE_LENGTH = 128 * 1024;

  // Underlying array.
  private ArrayData underlying;

  // Maximum length to be stored in the array.
  private final long maxDenseLength;

  // Sparse elements.
  private TreeMap<Long, Object> sparseMap; // TODO: find a TreeMap with long key's

  SparseArrayData(ArrayData underlying, long length) {
    this(underlying, length, new TreeMap<>());
  }

  SparseArrayData(ArrayData underlying, long length, TreeMap<Long, Object> sparseMap) {
    super(length);
    assert underlying.length() <= length;
    this.underlying = underlying;
    this.maxDenseLength = underlying.length();
    this.sparseMap = sparseMap;
  }

  @Override
  public ArrayData copy() {
    return new SparseArrayData(underlying.copy(), length(), new TreeMap<>(sparseMap));
  }

  @Override
  public Object[] asObjectArray() {
    var len = (int) Math.min(length(), Integer.MAX_VALUE);
    var underlyingLength = (int) Math.min(len, underlying.length());
    var objArray = new Object[len];
    for (var i = 0; i < underlyingLength; i++) {
      objArray[i] = underlying.getObject(i);
    }
    Arrays.fill(objArray, underlyingLength, len, ScriptRuntime.UNDEFINED);
    for (var entry : sparseMap.entrySet()) {
      long key = entry.getKey();
      if (key < Integer.MAX_VALUE) {
        objArray[(int) key] = entry.getValue();
      } else {
        break; // ascending key order
      }
    }
    return objArray;
  }

  @Override
  public ArrayData shiftLeft(int by) {
    underlying = underlying.shiftLeft(by);
    var newSparseMap = new TreeMap<Long, Object>();
    for (var entry : sparseMap.entrySet()) {
      long newIndex = entry.getKey() - by;
      if (newIndex >= 0) {
        if (newIndex < maxDenseLength) {
          var oldLength = underlying.length();
          underlying = underlying
            .ensure(newIndex)
            .set((int) newIndex, entry.getValue())
            .safeDelete(oldLength, newIndex - 1);
        } else {
          newSparseMap.put(newIndex, entry.getValue());
        }
      }
    }
    sparseMap = newSparseMap;
    setLength(Math.max(length() - by, 0));
    return sparseMap.isEmpty() ? underlying : this;
  }

  @Override
  public ArrayData shiftRight(int by) {
    var newSparseMap = new TreeMap<Long, Object>();
    // Move elements from underlying to sparse map if necessary
    var len = underlying.length();
    if (len + by > maxDenseLength) {
      // Length of underlying array after shrinking, before right-shifting
      var tempLength = Math.max(0, maxDenseLength - by);
      for (var i = tempLength; i < len; i++) {
        if (underlying.has((int) i)) {
          newSparseMap.put(i + by, underlying.getObject((int) i));
        }
      }
      underlying = underlying.shrink((int) tempLength);
      underlying.setLength(tempLength);
    }
    underlying = underlying.shiftRight(by);
    for (var entry : sparseMap.entrySet()) {
      var newIndex = entry.getKey() + by;
      newSparseMap.put(newIndex, entry.getValue());
    }
    sparseMap = newSparseMap;
    setLength(length() + by);
    return this;
  }

  @Override
  public ArrayData ensure(long safeIndex) {
    if (safeIndex >= length()) {
      setLength(safeIndex + 1);
    }
    return this;
  }

  @Override
  public ArrayData shrink(long newLength) {
    if (newLength < underlying.length()) {
      underlying = underlying.shrink(newLength);
      underlying.setLength(newLength);
      sparseMap.clear();
      setLength(newLength);
    }
    sparseMap.subMap(newLength, Long.MAX_VALUE).clear();
    setLength(newLength);
    return this;
  }

  @Override
  public ArrayData set(int index, Object value) {
    if (index >= 0 && index < maxDenseLength) {
      var oldLength = underlying.length();
      underlying = underlying.ensure(index).set(index, value).safeDelete(oldLength, index - 1);
      setLength(Math.max(underlying.length(), length()));
    } else {
      var longIndex = indexToKey(index);
      sparseMap.put(longIndex, value);
      setLength(Math.max(longIndex + 1, length()));
    }
    return this;
  }

  @Override
  public ArrayData set(int index, int value) {
    if (index >= 0 && index < maxDenseLength) {
      var oldLength = underlying.length();
      underlying = underlying.ensure(index).set(index, value).safeDelete(oldLength, index - 1);
      setLength(Math.max(underlying.length(), length()));
    } else {
      var longIndex = indexToKey(index);
      sparseMap.put(longIndex, value);
      setLength(Math.max(longIndex + 1, length()));
    }
    return this;
  }

  @Override
  public ArrayData set(int index, double value) {
    if (index >= 0 && index < maxDenseLength) {
      var oldLength = underlying.length();
      underlying = underlying.ensure(index).set(index, value).safeDelete(oldLength, index - 1);
      setLength(Math.max(underlying.length(), length()));
    } else {
      var longIndex = indexToKey(index);
      sparseMap.put(longIndex, value);
      setLength(Math.max(longIndex + 1, length()));
    }
    return this;
  }

  @Override
  public ArrayData setEmpty(int index) {
    underlying.setEmpty(index);
    return this;
  }

  @Override
  public ArrayData setEmpty(long lo, long hi) {
    underlying.setEmpty(lo, hi);
    return this;
  }

  @Override
  public Type getOptimisticType() {
    return underlying.getOptimisticType();
  }

  @Override
  public int getInt(int index) {
    return (index >= 0 && index < maxDenseLength) ? underlying.getInt(index) : JSType.toInt32(sparseMap.get(indexToKey(index)));
  }

  @Override
  public int getIntOptimistic(int index, int programPoint) {
    return (index >= 0 && index < maxDenseLength) ? underlying.getIntOptimistic(index, programPoint) : JSType.toInt32Optimistic(sparseMap.get(indexToKey(index)), programPoint);
  }

  @Override
  public double getDouble(int index) {
    return (index >= 0 && index < maxDenseLength) ? underlying.getDouble(index) : JSType.toNumber(sparseMap.get(indexToKey(index)));
  }

  @Override
  public double getDoubleOptimistic(int index, int programPoint) {
    return (index >= 0 && index < maxDenseLength) ? underlying.getDouble(index) : JSType.toNumberOptimistic(sparseMap.get(indexToKey(index)), programPoint);
  }

  @Override
  public Object getObject(int index) {
    if (index >= 0 && index < maxDenseLength) {
      return underlying.getObject(index);
    }
    var key = indexToKey(index);
    if (sparseMap.containsKey(key)) {
      return sparseMap.get(key);
    }
    return ScriptRuntime.UNDEFINED;
  }

  @Override
  public boolean has(int index) {
    return (index >= 0 && index < maxDenseLength) ? (index < underlying.length() && underlying.has(index)) : sparseMap.containsKey(indexToKey(index));
  }

  @Override
  public ArrayData delete(int index) {
    if (index >= 0 && index < maxDenseLength) {
      if (index < underlying.length()) {
        underlying = underlying.delete(index);
      }
    } else {
      sparseMap.remove(indexToKey(index));
    }
    return this;
  }

  @Override
  public ArrayData delete(long fromIndex, long toIndex) {
    if (fromIndex < maxDenseLength && fromIndex < underlying.length()) {
      underlying = underlying.delete(fromIndex, Math.min(toIndex, underlying.length() - 1));
    }
    if (toIndex >= maxDenseLength) {
      sparseMap.subMap(fromIndex, true, toIndex, true).clear();
    }
    return this;
  }

  static Long indexToKey(int index) {
    return ArrayIndex.toLongIndex(index);
  }

  @Override
  public ArrayData convert(Class<?> type) {
    underlying = underlying.convert(type);
    return this;
  }

  @Override
  public Object pop() {
    var len = length();
    var underlyingLen = underlying.length();
    if (len == 0) {
      return ScriptRuntime.UNDEFINED;
    }
    if (len == underlyingLen) {
      var result = underlying.pop();
      setLength(underlying.length());
      return result;
    }
    setLength(len - 1);
    var key = len - 1;
    return sparseMap.containsKey(key) ? sparseMap.remove(key) : ScriptRuntime.UNDEFINED;
  }

  @Override
  public ArrayData slice(long from, long to) {
    assert to <= length();
    var start = from < 0 ? (from + length()) : from;
    var newLength = to - start;
    var underlyingLength = underlying.length();
    if (start >= 0 && to <= maxDenseLength) {
      if (newLength <= underlyingLength) {
        return underlying.slice(from, to);
      }
      return underlying.slice(from, to).ensure(newLength - 1).delete(underlyingLength, newLength);
    }
    var sliced = EMPTY_ARRAY;
    sliced = sliced.ensure(newLength - 1);
    for (var i = start; i < to; i = nextIndex(i)) {
      if (has((int) i)) {
        sliced = sliced.set((int) (i - start), getObject((int) i));
      }
    }
    assert sliced.length() == newLength;
    return sliced;
  }

  @Override
  public long nextIndex(long index) {
    if (index < underlying.length() - 1) {
      return underlying.nextIndex(index);
    }
    var nextKey = sparseMap.higherKey(index);
    if (nextKey != null) {
      return nextKey;
    }
    return length();
  }

}
