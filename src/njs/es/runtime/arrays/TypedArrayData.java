package es.runtime.arrays;

import java.nio.Buffer;

import java.lang.invoke.MethodHandle;

import es.lookup.Lookup;
import static es.lookup.Lookup.MH;

/**
 * The superclass of all ArrayData used by TypedArrays
 *
 * @param <T> buffer implementation
 */
public abstract class TypedArrayData<T extends Buffer> extends ContinuousArrayData {

  // wrapped native buffer 
  protected final T nb;

  /**
   * Constructor
   * @param nb wrapped native buffer
   * @param elementLength length in elements
   */
  protected TypedArrayData(T nb, int elementLength) {
    super(elementLength); //TODO is this right?
    this.nb = nb;
  }

  /**
   * Length in number of elements. Accessed from {@code ArrayBufferView}
   * @return element length
   */
  public final int getElementLength() {
    return (int) length();
  }

  /**
   * Is this an unsigned array data?
   * @return true if unsigned
   */
  public boolean isUnsigned() {
    return false;
  }

  /**
   * Is this a clamped array data?
   * @return true if clamped
   */
  public boolean isClamped() {
    return false;
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
  public TypedArrayData<T> copy() {
    throw new UnsupportedOperationException();
  }

  @Override
  public Object[] asObjectArray() {
    throw new UnsupportedOperationException();
  }

  @Override
  public ArrayData shiftLeft(int by) {
    throw new UnsupportedOperationException();
  }

  @Override
  public ArrayData shiftRight(int by) {
    throw new UnsupportedOperationException();
  }

  @Override
  public ArrayData ensure(long safeIndex) {
    return this;
  }

  @Override
  public ArrayData shrink(long newLength) {
    throw new UnsupportedOperationException();
  }

  @Override
  public final boolean has(int index) {
    return 0 <= index && index < length();
  }

  @Override
  public ArrayData delete(int index) {
    return this;
  }

  @Override
  public ArrayData delete(long fromIndex, long toIndex) {
    return this;
  }

  @Override
  public TypedArrayData<T> convert(Class<?> type) {
    throw new UnsupportedOperationException();
  }

  @Override
  public Object pop() {
    throw new UnsupportedOperationException();
  }

  @Override
  public ArrayData slice(long from, long to) {
    throw new UnsupportedOperationException();
  }

  /**
   * Element getter method handle
   * @return getter
   */
  protected abstract MethodHandle getGetElem();

  /**
   * Element setter method handle
   * @return setter
   */
  protected abstract MethodHandle getSetElem();

  @Override
  public MethodHandle getElementGetter(Class<?> returnType, int programPoint) {
    var getter = getContinuousElementGetter(getClass(), getGetElem(), returnType, programPoint);
    return (getter != null) ? Lookup.filterReturnType(getter, returnType) : getter;
  }

  @Override
  public MethodHandle getElementSetter(Class<?> elementType) {
    return getContinuousElementSetter(getClass(), Lookup.filterArgumentType(getSetElem(), 2, elementType), elementType);
  }

  @Override
  protected MethodHandle getContinuousElementSetter(Class<? extends ContinuousArrayData> clazz, MethodHandle setHas, Class<?> elementType) {
    var mh = Lookup.filterArgumentType(setHas, 2, elementType);
    return MH.asType(mh, mh.type().changeParameterType(0, clazz));
  }

}
