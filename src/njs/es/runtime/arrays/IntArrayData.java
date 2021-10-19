package es.runtime.arrays;

import java.util.Arrays;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import es.runtime.JSType;
import es.runtime.ScriptRuntime;
import static es.codegen.CompilerConstants.specialCall;

/**
 * Implementation of {@link ArrayData} as soon as an int has been written to the array.
 * This is the default data for new arrays
 */
final class IntArrayData extends ContinuousArrayData implements IntElements {

  // The wrapped array
  private int[] array;

  IntArrayData() {
    this(new int[ArrayData.CHUNK_SIZE], 0);
  }

  IntArrayData(int length) {
    super(length);
    this.array = new int[ArrayData.nextSize(length)];
  }

  /**
   * Constructor
   * @param array an int array
   * @param length a length, not necessarily array.length
   */
  IntArrayData(int[] array, int length) {
    super(length);
    assert array == null || array.length >= length;
    this.array = array;
  }

  @Override
  public final Class<?> getElementType() {
    return int.class;
  }

  @Override
  public final Class<?> getBoxedElementType() {
    return Integer.class;
  }

  @Override
  public final int getElementWeight() {
    return 1;
  }

  @Override
  public final ContinuousArrayData widest(ContinuousArrayData otherData) {
    return otherData;
  }

  private static final MethodHandle HAS_GET_ELEM = specialCall(MethodHandles.lookup(), IntArrayData.class, "getElem", int.class, int.class).methodHandle();
  private static final MethodHandle SET_ELEM = specialCall(MethodHandles.lookup(), IntArrayData.class, "setElem", void.class, int.class, int.class).methodHandle();

  @Override
  public Object[] asObjectArray() {
    return toObjectArray(true);
  }

  @SuppressWarnings("unused")
  int getElem(int index) {
    if (has(index)) {
      return array[index];
    }
    throw new ClassCastException();
  }

  @SuppressWarnings("unused")
  void setElem(int index, int elem) {
    if (hasRoomFor(index)) {
      array[index] = elem;
      return;
    }
    throw new ClassCastException();
  }

  @Override
  public MethodHandle getElementGetter(Class<?> returnType, int programPoint) {
    return getContinuousElementGetter(HAS_GET_ELEM, returnType, programPoint);
  }

  @Override
  public MethodHandle getElementSetter(Class<?> elementType) {
    return elementType == int.class ? getContinuousElementSetter(SET_ELEM, elementType) : null;
  }

  @Override
  public IntArrayData copy() {
    return new IntArrayData(array.clone(), (int) length());
  }

  @Override
  public Object asArrayOfType(Class<?> componentType) {
    if (componentType == int.class) {
      var len = (int) length();
      return array.length == len ? array.clone() : Arrays.copyOf(array, len);
    }
    return super.asArrayOfType(componentType);
  }

  Object[] toObjectArray(boolean trim) {
    assert length() <= array.length : "length exceeds internal array size";
    var len = (int) length();
    var oarray = new Object[trim ? len : array.length];
    for (var index = 0; index < len; index++) {
      oarray[index] = array[index];
    }
    return oarray;
  }

  double[] toDoubleArray() {
    assert length() <= array.length : "length exceeds internal array size";
    var len = (int) length();
    var darray = new double[array.length];
    for (var index = 0; index < len; index++) {
      darray[index] = array[index];
    }
    return darray;
  }

  NumberArrayData convertToDouble() {
    return new NumberArrayData(toDoubleArray(), (int) length());
  }

  ObjectArrayData convertToObject() {
    return new ObjectArrayData(toObjectArray(false), (int) length());
  }

  @Override
  public ArrayData convert(Class<?> type) {
    return (type == Integer.class || type == Byte.class || type == Short.class) ? this
         : (type == Double.class || type == Float.class) ? convertToDouble()
         : convertToObject();
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
      array = Arrays.copyOf(array, newLength);
    }
    if (safeIndex >= length()) {
      setLength(safeIndex + 1);
    }
    return this;
  }

  @Override
  public ArrayData shrink(long newLength) {
    Arrays.fill(array, (int) newLength, array.length, 0);
    return this;
  }

  @Override
  public ArrayData set(int index, Object value) {
    if (JSType.isRepresentableAsInt(value)) {
      return set(index, JSType.toInt32(value));
    } else if (value == ScriptRuntime.UNDEFINED) {
      return new UndefinedArrayFilter(this).set(index, value);
    }
    var newData = convert(value == null ? Object.class : value.getClass());
    return newData.set(index, value);
  }

  @Override
  public ArrayData set(int index, int value) {
    array[index] = value;
    setLength(Math.max(index + 1, length()));
    return this;
  }

  @Override
  public ArrayData set(int index, double value) {
    if (JSType.isRepresentableAsInt(value)) {
      array[index] = (int) (long) value;
      setLength(Math.max(index + 1, length()));
      return this;
    }
    return convert(Double.class).set(index, value);
  }

  @Override
  public int getInt(int index) {
    return array[index];
  }

  @Override
  public int getIntOptimistic(int index, int programPoint) {
    return array[index];
  }

  @Override
  public double getDouble(int index) {
    return array[index];
  }

  @Override
  public double getDoubleOptimistic(int index, int programPoint) {
    return array[index];
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
    return new DeletedRangeArrayFilter(this, index, index);
  }

  @Override
  public ArrayData delete(long fromIndex, long toIndex) {
    return new DeletedRangeArrayFilter(this, fromIndex, toIndex);
  }

  @Override
  public Object pop() {
    var len = (int) length();
    if (len == 0) {
      return ScriptRuntime.UNDEFINED;
    }
    var newLength = len - 1;
    var elem = array[newLength];
    array[newLength] = 0;
    setLength(newLength);
    return elem;
  }

  @Override
  public ArrayData slice(long from, long to) {
    return new IntArrayData(Arrays.copyOfRange(array, (int) from, (int) to), (int) (to - (from < 0 ? from + length() : from)));
  }

  @Override
  public ArrayData fastSplice(int start, int removed, int added) throws UnsupportedOperationException {
    var oldLength = length();
    var newLength = oldLength - removed + added;
    if (newLength > SparseArrayData.MAX_DENSE_LENGTH && newLength > array.length) {
      throw new UnsupportedOperationException();
    }
    var returnValue = removed == 0 ? EMPTY_ARRAY : new IntArrayData(Arrays.copyOfRange(array, start, start + removed), removed);
    if (newLength != oldLength) {
      int[] newArray;
      if (newLength > array.length) {
        newArray = new int[ArrayData.nextSize((int) newLength)];
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
  public double fastPush(int arg) {
    var len = (int) length();
    if (len == array.length) {
      array = Arrays.copyOf(array, nextSize(len));
    }
    array[len] = arg;
    return increaseLength();
  }

  // length must not be zero
  @Override
  public int fastPopInt() {
    if (length() == 0) {
      throw new ClassCastException(); // relink
    }
    var newLength = (int) decreaseLength();
    var elem = array[newLength];
    array[newLength] = 0;
    return elem;
  }

  @Override
  public double fastPopDouble() {
    return fastPopInt();
  }

  @Override
  public Object fastPopObject() {
    return fastPopInt();
  }

  @Override
  public ContinuousArrayData fastConcat(ContinuousArrayData otherData) {
    var otherLength = (int) otherData.length();
    var thisLength = (int) length();
    assert otherLength > 0 && thisLength > 0;
    var otherArray = ((IntArrayData) otherData).array;
    var newLength = otherLength + thisLength;
    var newArray = new int[ArrayData.alignUp(newLength)];
    System.arraycopy(array, 0, newArray, 0, thisLength);
    System.arraycopy(otherArray, 0, newArray, thisLength, otherLength);
    return new IntArrayData(newArray, newLength);
  }

  @Override
  public String toString() {
    assert length() <= array.length : length() + " > " + array.length;
    return getClass().getSimpleName() + ':' + Arrays.toString(Arrays.copyOf(array, (int) length()));
  }

}
