package es.runtime.arrays;

import java.nio.ByteBuffer;

import es.objects.Global;
import es.runtime.PropertyDescriptor;
import es.runtime.ScriptRuntime;
import static es.runtime.ECMAErrors.typeError;

/**
 * Implementation of {@link ArrayData} that wraps a nio ByteBuffer
 */
final class ByteBufferArrayData extends ArrayData {

  private final ByteBuffer buf;

  ByteBufferArrayData(int length) {
    super(length);
    this.buf = ByteBuffer.allocateDirect(length);
  }

  /**
   * Constructor
   *
   * @param buf ByteBuffer to create array data with.
   */
  ByteBufferArrayData(ByteBuffer buf) {
    super(buf.capacity());
    this.buf = buf;
  }

  /**
   * Returns property descriptor for element at a given index
   * @param global the global object
   * @param index  the index
   * @return property descriptor for element
   */
  @Override
  public PropertyDescriptor getDescriptor(Global global, int index) {
    // make the index properties not configurable
    return global.newDataDescriptor(getObject(index), false, true, true);
  }

  @Override
  public ArrayData copy() {
    throw unsupported("copy");
  }

  @Override
  public Object[] asObjectArray() {
    throw unsupported("asObjectArray");
  }

  @Override
  public void setLength(long length) {
    throw new UnsupportedOperationException("setLength");
  }

  @Override
  public ArrayData shiftLeft(int by) {
    throw unsupported("shiftLeft");
  }

  @Override
  public ArrayData shiftRight(int by) {
    throw unsupported("shiftRight");
  }

  @Override
  public ArrayData ensure(long safeIndex) {
    if (safeIndex < buf.capacity()) {
      return this;
    }
    throw unsupported("ensure");
  }

  @Override
  public ArrayData shrink(long newLength) {
    throw unsupported("shrink");
  }

  @Override
  public ArrayData set(int index, Object value) {
    if (value instanceof Number n) {
      buf.put(index, n.byteValue());
      return this;
    }
    throw typeError("not.a.number", ScriptRuntime.safeToString(value));
  }

  @Override
  public ArrayData set(int index, int value) {
    buf.put(index, (byte) value);
    return this;
  }

  @Override
  public ArrayData set(int index, double value) {
    buf.put(index, (byte) value);
    return this;
  }

  @Override
  public int getInt(int index) {
    return 0x0ff & buf.get(index);
  }

  @Override
  public double getDouble(int index) {
    return 0x0ff & buf.get(index);
  }

  @Override
  public Object getObject(int index) {
    return 0x0ff & buf.get(index);
  }

  @Override
  public boolean has(int index) {
    return index > -1 && index < buf.capacity();
  }

  @Override
  public boolean canDelete(int index) {
    return false;
  }

  @Override
  public boolean canDelete(long longIndex) {
    return false;
  }

  @Override
  public ArrayData delete(int index) {
    throw unsupported("delete");
  }

  @Override
  public ArrayData delete(long fromIndex, long toIndex) {
    throw unsupported("delete");
  }

  @Override
  public ArrayData push(Object... items) {
    throw unsupported("push");
  }

  @Override
  public Object pop() {
    throw unsupported("pop");
  }

  @Override
  public ArrayData slice(long from, long to) {
    throw unsupported("slice");
  }

  @Override
  public ArrayData convert(Class<?> type) {
    throw unsupported("convert");
  }

  static UnsupportedOperationException unsupported(String method) {
    return new UnsupportedOperationException(method);
  }

}
