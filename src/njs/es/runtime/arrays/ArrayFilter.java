package es.runtime.arrays;

import es.codegen.types.Type;
import es.runtime.ScriptRuntime;
import es.runtime.Undefined;
import es.runtime.linker.Bootstrap;

/**
 * Base class for array filters.
 * Implements all core routines so that the filter only has to implement those needed.
 */
abstract class ArrayFilter extends ArrayData {

  // Underlying array.
  protected ArrayData underlying;

  ArrayFilter(ArrayData underlying) {
    super(underlying.length());
    this.underlying = underlying;
  }

  /**
   * Get the underlying {@link ArrayData} that this filter wraps
   * @return array data
   */
  protected ArrayData getUnderlying() {
    return underlying;
  }

  @Override
  public void setLength(long length) {
    super.setLength(length);
    underlying.setLength(length);
  }

  @Override
  public Object[] asObjectArray() {
    return underlying.asObjectArray();
  }

  @Override
  public Object asArrayOfType(Class<?> componentType) {
    return underlying.asArrayOfType(componentType);
  }

  @Override
  public ArrayData shiftLeft(int by) {
    underlying.shiftLeft(by);
    setLength(underlying.length());
    return this;
  }

  @Override
  public ArrayData shiftRight(int by) {
    underlying = underlying.shiftRight(by);
    setLength(underlying.length());
    return this;
  }

  @Override
  public ArrayData ensure(long safeIndex) {
    underlying = underlying.ensure(safeIndex);
    setLength(underlying.length());
    return this;
  }

  @Override
  public ArrayData shrink(long newLength) {
    underlying = underlying.shrink(newLength);
    setLength(underlying.length());
    return this;
  }

  @Override
  public ArrayData set(int index, Object value) {
    underlying = underlying.set(index, value);
    setLength(underlying.length());
    return this;
  }

  @Override
  public ArrayData set(int index, int value) {
    underlying = underlying.set(index, value);
    setLength(underlying.length());
    return this;
  }

  @Override
  public ArrayData set(int index, double value) {
    underlying = underlying.set(index, value);
    setLength(underlying.length());
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
    return underlying.getInt(index);
  }

  @Override
  public int getIntOptimistic(int index, int programPoint) {
    return underlying.getIntOptimistic(index, programPoint);
  }

  @Override
  public double getDouble(int index) {
    return underlying.getDouble(index);
  }

  @Override
  public double getDoubleOptimistic(int index, int programPoint) {
    return underlying.getDoubleOptimistic(index, programPoint);
  }

  @Override
  public Object getObject(int index) {
    return underlying.getObject(index);
  }

  @Override
  public boolean has(int index) {
    return underlying.has(index);
  }

  @Override
  public ArrayData delete(int index) {
    underlying = underlying.delete(index);
    setLength(underlying.length());
    return this;
  }

  @Override
  public ArrayData delete(long from, long to) {
    underlying = underlying.delete(from, to);
    setLength(underlying.length());
    return this;
  }

  @Override
  public ArrayData convert(Class<?> type) {
    underlying = underlying.convert(type);
    setLength(underlying.length());
    return this;
  }

  @Override
  public Object pop() {
    var value = underlying.pop();
    setLength(underlying.length());
    return value;
  }

  @Override
  public long nextIndex(long index) {
    return underlying.nextIndex(index);
  }

  static Object convertUndefinedValue(Class<?> targetType) {
    return invoke(Bootstrap.getLinkerServices().getTypeConverter(Undefined.class, targetType), ScriptRuntime.UNDEFINED);
  }

}
