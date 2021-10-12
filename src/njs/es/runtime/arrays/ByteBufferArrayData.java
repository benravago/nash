package es.runtime.arrays;

import static es.runtime.ECMAErrors.typeError;

import java.nio.ByteBuffer;
import es.objects.Global;
import es.runtime.PropertyDescriptor;
import es.runtime.ScriptRuntime;

/**
 * Implementation of {@link ArrayData} that wraps a nio ByteBuffer
 */
final class ByteBufferArrayData extends ArrayData {

  private final ByteBuffer buf;

  ByteBufferArrayData(final int length) {
    super(length);
    this.buf = ByteBuffer.allocateDirect(length);
  }

  /**
   * Constructor
   *
   * @param buf ByteBuffer to create array data with.
   */
  ByteBufferArrayData(final ByteBuffer buf) {
    super(buf.capacity());
    this.buf = buf;
  }

  /**
   * Returns property descriptor for element at a given index
   *
   * @param global the global object
   * @param index  the index
   *
   * @return property descriptor for element
   */
  @Override
  public PropertyDescriptor getDescriptor(final Global global, final int index) {
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
  public void setLength(final long length) {
    throw new UnsupportedOperationException("setLength");
  }

  @Override
  public ArrayData shiftLeft(final int by) {
    throw unsupported("shiftLeft");
  }

  @Override
  public ArrayData shiftRight(final int by) {
    throw unsupported("shiftRight");
  }

  @Override
  public ArrayData ensure(final long safeIndex) {
    if (safeIndex < buf.capacity()) {
      return this;
    }

    throw unsupported("ensure");
  }

  @Override
  public ArrayData shrink(final long newLength) {
    throw unsupported("shrink");
  }

  @Override
  public ArrayData set(final int index, final Object value) {
    if (value instanceof Number) {
      buf.put(index, ((Number) value).byteValue());
      return this;
    }

    throw typeError("not.a.number", ScriptRuntime.safeToString(value));
  }

  @Override
  public ArrayData set(final int index, final int value) {
    buf.put(index, (byte) value);
    return this;
  }

  @Override
  public ArrayData set(final int index, final double value) {
    buf.put(index, (byte) value);
    return this;
  }

  @Override
  public int getInt(final int index) {
    return 0x0ff & buf.get(index);
  }

  @Override
  public double getDouble(final int index) {
    return 0x0ff & buf.get(index);
  }

  @Override
  public Object getObject(final int index) {
    return 0x0ff & buf.get(index);
  }

  @Override
  public boolean has(final int index) {
    return index > -1 && index < buf.capacity();
  }

  @Override
  public boolean canDelete(final int index) {
    return false;
  }

  @Override
  public boolean canDelete(final long longIndex) {
    return false;
  }

  @Override
  public ArrayData delete(final int index) {
    throw unsupported("delete");
  }

  @Override
  public ArrayData delete(final long fromIndex, final long toIndex) {
    throw unsupported("delete");
  }

  @Override
  public ArrayData push(final Object... items) {
    throw unsupported("push");
  }

  @Override
  public Object pop() {
    throw unsupported("pop");
  }

  @Override
  public ArrayData slice(final long from, final long to) {
    throw unsupported("slice");
  }

  @Override
  public ArrayData convert(final Class<?> type) {
    throw unsupported("convert");
  }

  private static UnsupportedOperationException unsupported(final String method) {
    return new UnsupportedOperationException(method);
  }
}
