package es.runtime.arrays;

import java.lang.reflect.Array;

import es.runtime.BitVector;
import es.runtime.UnwarrantedOptimismException;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * This filter handles the presence of undefined array elements.
 */
final class UndefinedArrayFilter extends ArrayFilter {

  // Bit vector tracking undefined slots.
  private final BitVector undefined;

  UndefinedArrayFilter(ArrayData underlying) {
    super(underlying);
    this.undefined = new BitVector(underlying.length());
  }

  @Override
  public ArrayData copy() {
    var copy = new UndefinedArrayFilter(underlying.copy());
    copy.getUndefined().copy(undefined);
    return copy;
  }

  @Override
  public Object[] asObjectArray() {
    var value = super.asObjectArray();
    for (var i = 0; i < value.length; i++) {
      if (undefined.isSet(i)) {
        value[i] = UNDEFINED;
      }
    }
    return value;
  }

  @Override
  public Object asArrayOfType(Class<?> componentType) {
    var value = super.asArrayOfType(componentType);
    var undefValue = convertUndefinedValue(componentType);
    var l = Array.getLength(value);
    for (var i = 0; i < l; i++) {
      if (undefined.isSet(i)) {
        Array.set(value, i, undefValue);
      }
    }
    return value;
  }

  @Override
  public ArrayData shiftLeft(int by) {
    super.shiftLeft(by);
    undefined.shiftLeft(by, length());
    return this;
  }

  @Override
  public ArrayData shiftRight(int by) {
    super.shiftRight(by);
    undefined.shiftRight(by, length());
    return this;
  }

  @Override
  public ArrayData ensure(long safeIndex) {
    if (safeIndex >= SparseArrayData.MAX_DENSE_LENGTH && safeIndex >= length()) {
      return new SparseArrayData(this, safeIndex + 1);
    }
    super.ensure(safeIndex);
    undefined.resize(length());
    return this;
  }

  @Override
  public ArrayData shrink(long newLength) {
    super.shrink(newLength);
    undefined.resize(length());
    return this;
  }

  @Override
  public ArrayData set(int index, Object value) {
    undefined.clear(index);
    if (value == UNDEFINED) {
      undefined.set(index);
      return this;
    }
    return super.set(index, value);
  }

  @Override
  public ArrayData set(int index, int value) {
    undefined.clear(index);
    return super.set(index, value);
  }

  @Override
  public ArrayData set(int index, double value) {
    undefined.clear(index);
    return super.set(index, value);
  }

  @Override
  public int getInt(int index) {
    return undefined.isSet(index) ? 0 : super.getInt(index);
  }

  @Override
  public int getIntOptimistic(int index, int programPoint) {
    if (undefined.isSet(index)) {
      throw new UnwarrantedOptimismException(UNDEFINED, programPoint);
    }
    return super.getIntOptimistic(index, programPoint);
  }

  @Override
  public double getDouble(int index) {
    return undefined.isSet(index) ? Double.NaN : super.getDouble(index);
  }

  @Override
  public double getDoubleOptimistic(int index, int programPoint) {
    if (undefined.isSet(index)) {
      throw new UnwarrantedOptimismException(UNDEFINED, programPoint);
    }
    return super.getDoubleOptimistic(index, programPoint);
  }

  @Override
  public Object getObject(int index) {
    return undefined.isSet(index) ? UNDEFINED : super.getObject(index);
  }

  @Override
  public ArrayData delete(int index) {
    undefined.clear(index);
    return super.delete(index);
  }

  @Override
  public Object pop() {
    var index = length() - 1;
    if (super.has((int) index)) {
      var isUndefined = undefined.isSet(index);
      var value = super.pop();
      return isUndefined ? UNDEFINED : value;
    }
    return super.pop();
  }

  @Override
  public ArrayData slice(long from, long to) {
    var newArray = underlying.slice(from, to);
    var newFilter = new UndefinedArrayFilter(newArray);
    newFilter.getUndefined().copy(undefined);
    newFilter.getUndefined().shiftLeft(from, newFilter.length());
    return newFilter;
  }

  BitVector getUndefined() { // ??
    return undefined;
  }

}
