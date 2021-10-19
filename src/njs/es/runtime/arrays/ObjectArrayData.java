package es.runtime.arrays;

import java.util.Arrays;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import es.runtime.JSType;
import es.runtime.ScriptRuntime;
import static es.codegen.CompilerConstants.specialCall;

/**
 * Implementation of {@link ArrayData} as soon as an Object has been written to the array
 */
final class ObjectArrayData extends ContinuousArrayData implements AnyElements {

  // The wrapped array
  private Object[] array;

  /**
   * Constructor
   * @param array an int array
   * @param length a length, not necessarily array.length
   */
  ObjectArrayData(Object[] array, int length) {
    super(length);
    assert array.length >= length;
    this.array = array;
  }

  @Override
  public final Class<?> getElementType() {
    return Object.class;
  }

  @Override
  public final Class<?> getBoxedElementType() {
    return getElementType();
  }

  @Override
  public final int getElementWeight() {
    return 4;
  }

  @Override
  public final ContinuousArrayData widest(ContinuousArrayData otherData) {
    return otherData instanceof NumericElements ? this : otherData;
  }

  @Override
  public ObjectArrayData copy() {
    return new ObjectArrayData(array.clone(), (int) length());
  }

  @Override
  public Object[] asObjectArray() {
    return array.length == length() ? array.clone() : asObjectArrayCopy();
  }

  Object[] asObjectArrayCopy() {
    var len = length();
    assert len <= Integer.MAX_VALUE;
    var copy = new Object[(int) len];
    System.arraycopy(array, 0, copy, 0, (int) len);
    return copy;
  }

  @Override
  public ObjectArrayData convert(Class<?> type) {
    return this;
  }

  @Override
  public ArrayData shiftLeft(int by) {
    if (by >= length()) {
      shrink(0);
    } else {
      System.arraycopy(array, by, array, 0, array.length - by);
    }
    setLength(Math.max(0, length() - by));
    return this;
  }

  @Override
  public ArrayData shiftRight(int by) {
    var newData = ensure(by + length() - 1);
    if (newData != this) {
      newData.shiftRight(by);
      return newData;
    }
    System.arraycopy(array, 0, array, by, array.length - by);
    return this;
  }

  @Override
  public ArrayData ensure(long safeIndex) {
    if (safeIndex >= SparseArrayData.MAX_DENSE_LENGTH) {
      return new SparseArrayData(this, safeIndex + 1);
    }
    var alen = array.length;
    if (safeIndex >= alen) {
      var newLength = ArrayData.nextSize((int) safeIndex);
      array = Arrays.copyOf(array, newLength); //fill with undefined or OK? TODO
    }
    if (safeIndex >= length()) {
      setLength(safeIndex + 1);
    }
    return this;
  }

  @Override
  public ArrayData shrink(long newLength) {
    Arrays.fill(array, (int) newLength, array.length, ScriptRuntime.UNDEFINED);
    return this;
  }

  @Override
  public ArrayData set(int index, Object value) {
    array[index] = value;
    setLength(Math.max(index + 1, length()));
    return this;
  }

  @Override
  public ArrayData set(int index, int value) {
    array[index] = value;
    setLength(Math.max(index + 1, length()));
    return this;
  }

  @Override
  public ArrayData set(int index, double value) {
    array[index] = value;
    setLength(Math.max(index + 1, length()));
    return this;
  }

  @Override
  public ArrayData setEmpty(int index) {
    array[index] = ScriptRuntime.EMPTY;
    return this;
  }

  @Override
  public ArrayData setEmpty(long lo, long hi) {
    // hi parameter is inclusive, but Arrays.fill toIndex parameter is exclusive
    Arrays.fill(array, (int) Math.max(lo, 0L), (int) Math.min(hi + 1, Integer.MAX_VALUE), ScriptRuntime.EMPTY);
    return this;
  }

  private static final MethodHandle HAS_GET_ELEM = specialCall(MethodHandles.lookup(), ObjectArrayData.class, "getElem", Object.class, int.class).methodHandle();
  private static final MethodHandle SET_ELEM = specialCall(MethodHandles.lookup(), ObjectArrayData.class, "setElem", void.class, int.class, Object.class).methodHandle();

  @SuppressWarnings("unused")
  Object getElem(int index) {
    if (has(index)) {
      return array[index];
    }
    throw new ClassCastException();
  }

  @SuppressWarnings("unused")
  void setElem(int index, Object elem) {
    if (hasRoomFor(index)) {
      array[index] = elem;
      return;
    }
    throw new ClassCastException();
  }

  @Override
  public MethodHandle getElementGetter(Class<?> returnType, int programPoint) {
    return returnType.isPrimitive() ? null : getContinuousElementGetter(HAS_GET_ELEM, returnType, programPoint);
  }

  @Override
  public MethodHandle getElementSetter(Class<?> elementType) {
    return getContinuousElementSetter(SET_ELEM, Object.class);
  }

  @Override
  public int getInt(int index) {
    return JSType.toInt32(array[index]);
  }

  @Override
  public double getDouble(int index) {
    return JSType.toNumber(array[index]);
  }

  @Override
  public Object getObject(int index) {
    return array[index];
  }

  @Override
  public boolean has(int index) {
    return 0 <= index && index < length();
  }

  @Override
  public ArrayData delete(int index) {
    setEmpty(index);
    return new DeletedRangeArrayFilter(this, index, index);
  }

  @Override
  public ArrayData delete(long fromIndex, long toIndex) {
    setEmpty(fromIndex, toIndex);
    return new DeletedRangeArrayFilter(this, fromIndex, toIndex);
  }

  @Override
  public double fastPush(int arg) {
    return fastPush((Object) arg);
  }

  @Override
  public double fastPush(long arg) {
    return fastPush((Object) arg);
  }

  @Override
  public double fastPush(double arg) {
    return fastPush((Object) arg);
  }

  @Override
  public double fastPush(Object arg) {
    var len = (int) length();
    if (len == array.length) {
      array = Arrays.copyOf(array, nextSize(len));
    }
    array[len] = arg;
    return increaseLength();
  }

  @Override
  public Object fastPopObject() {
    if (length() == 0) {
      return ScriptRuntime.UNDEFINED;
    }
    var newLength = (int) decreaseLength();
    var elem = array[newLength];
    array[newLength] = ScriptRuntime.EMPTY;
    return elem;
  }

  @Override
  public Object pop() {
    if (length() == 0) {
      return ScriptRuntime.UNDEFINED;
    }
    var newLength = (int) length() - 1;
    var elem = array[newLength];
    setEmpty(newLength);
    setLength(newLength);
    return elem;
  }

  @Override
  public ArrayData slice(long from, long to) {
    var start = from < 0 ? from + length() : from;
    var newLength = to - start;
    return new ObjectArrayData(Arrays.copyOfRange(array, (int) from, (int) to), (int) newLength);
  }

  @Override
  public ArrayData fastSplice(int start, int removed, int added) throws UnsupportedOperationException {
    var oldLength = length();
    var newLength = oldLength - removed + added;
    if (newLength > SparseArrayData.MAX_DENSE_LENGTH && newLength > array.length) {
      throw new UnsupportedOperationException();
    }
    var returnValue = removed == 0 ? EMPTY_ARRAY : new ObjectArrayData(Arrays.copyOfRange(array, start, start + removed), removed);
    if (newLength != oldLength) {
      Object[] newArray;
      if (newLength > array.length) {
        newArray = new Object[ArrayData.nextSize((int) newLength)];
        System.arraycopy(array, 0, newArray, 0, start);
      } else {
        newArray = array;
      }
      System.arraycopy(array, start + removed, newArray, start + added, (int) (oldLength - start - removed));
      array = newArray;
      setLength(newLength);
    }
    return returnValue;
  }

  @Override
  public ContinuousArrayData fastConcat(ContinuousArrayData otherData) {
    var otherLength = (int) otherData.length();
    var thisLength = (int) length();
    assert otherLength > 0 && thisLength > 0;
    var otherArray = ((ObjectArrayData) otherData).array;
    var newLength = otherLength + thisLength;
    var newArray = new Object[ArrayData.alignUp(newLength)];
    System.arraycopy(array, 0, newArray, 0, thisLength);
    System.arraycopy(otherArray, 0, newArray, thisLength, otherLength);
    return new ObjectArrayData(newArray, newLength);
  }

  @Override
  public String toString() {
    assert length() <= array.length : length() + " > " + array.length;
    return getClass().getSimpleName() + ':' + Arrays.toString(Arrays.copyOf(array, (int) length()));
  }

}
