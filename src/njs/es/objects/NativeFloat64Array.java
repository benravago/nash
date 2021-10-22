package es.objects;

import static es.codegen.CompilerConstants.specialCall;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.nio.ByteBuffer;
import java.nio.DoubleBuffer;
import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.Property;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.Where;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.arrays.ArrayData;
import es.runtime.arrays.TypedArrayData;

/**
 * Float64 array for the TypedArray extension
 */
@ScriptClass("Float64Array")
public final class NativeFloat64Array extends ArrayBufferView {

  /** The size in bytes of each element in the array. */
  @Property(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_WRITABLE | Attribute.NOT_CONFIGURABLE, where = Where.CONSTRUCTOR)
  public static final int BYTES_PER_ELEMENT = 8;

  // initialized by nasgen
  @SuppressWarnings("unused")
  private static PropertyMap $nasgenmap$;

  private static final Factory FACTORY = new Factory(BYTES_PER_ELEMENT) {
    @Override
    public ArrayBufferView construct(NativeArrayBuffer buffer, int byteOffset, int length) {
      return new NativeFloat64Array(buffer, byteOffset, length);
    }
    @Override
    public Float64ArrayData createArrayData(ByteBuffer nb, int start, int length) {
      return new Float64ArrayData(nb.asDoubleBuffer(), start, length);
    }
    @Override
    public String getClassName() {
      return "Float64Array";
    }
  };

  static final class Float64ArrayData extends TypedArrayData<DoubleBuffer> {

    private static final MethodHandle GET_ELEM = specialCall(MethodHandles.lookup(), Float64ArrayData.class, "getElem", double.class, int.class).methodHandle();
    private static final MethodHandle SET_ELEM = specialCall(MethodHandles.lookup(), Float64ArrayData.class, "setElem", void.class, int.class, double.class).methodHandle();

    Float64ArrayData(DoubleBuffer nb, int start, int end) {
      super((nb.position(start).limit(end)).slice(), end - start);
    }

    @Override
    protected MethodHandle getGetElem() {
      return GET_ELEM;
    }

    @Override
    protected MethodHandle getSetElem() {
      return SET_ELEM;
    }

    @Override
    public Class<?> getElementType() {
      return double.class;
    }

    @Override
    public Class<?> getBoxedElementType() {
      return Double.class;
    }

    double getElem(int index) {
      try {
        return nb.get(index);
      } catch (IndexOutOfBoundsException e) {
        throw new ClassCastException(); // force relink - this works for unoptimistic too
      }
    }

    void setElem(int index, double elem) {
      try {
        if (index < nb.limit()) {
          nb.put(index, elem);
        }
      } catch (IndexOutOfBoundsException e) {
        throw new ClassCastException();
      }
    }

    @Override
    public MethodHandle getElementGetter(Class<?> returnType, int programPoint) {
      return (returnType == int.class) ? null : getContinuousElementGetter(getClass(), GET_ELEM, returnType, programPoint);
    }

    @Override
    public int getInt(int index) {
      return (int) getDouble(index);
    }

    @Override
    public double getDouble(int index) {
      return getElem(index);
    }

    @Override
    public double getDoubleOptimistic(int index, int programPoint) {
      return getElem(index);
    }

    @Override
    public Object getObject(int index) {
      return getDouble(index);
    }

    @Override
    public ArrayData set(int index, Object value) {
      return set(index, JSType.toNumber(value));
    }

    @Override
    public ArrayData set(int index, int value) {
      return set(index, (double) value);
    }

    @Override
    public ArrayData set(int index, double value) {
      setElem(index, value);
      return this;
    }
  }

  /**
   * Constructor
   *
   * @param newObj is this typed array instantiated with the new operator
   * @param self   self reference
   * @param args   args
   * @return new typed array
   */
  @Constructor(arity = 1)
  public static NativeFloat64Array constructor(boolean newObj, Object self, Object... args) {
    return (NativeFloat64Array) constructorImpl(newObj, args, FACTORY);
  }

  NativeFloat64Array(NativeArrayBuffer buffer, int byteOffset, int length) {
    super(buffer, byteOffset, length);
  }

  @Override
  protected Factory factory() {
    return FACTORY;
  }

  @Override
  protected boolean isFloatArray() {
    return true;
  }

  /**
   * Set values
   * @param self   self reference
   * @param array  multiple values of array's type to set
   * @param offset optional start index, interpreted  0 if undefined
   * @return undefined
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  protected static Object set(Object self, Object array, Object offset) {
    return ArrayBufferView.setImpl(self, array, offset);
  }

  /**
   * Returns a new TypedArray view of the ArrayBuffer store for this TypedArray, referencing the elements at begin, inclusive, up to end, exclusive.
   * If either begin or end is negative, it refers to an index from the end of the array, as opposed to from the beginning.
   * <p>
   * If end is unspecified, the subarray contains all elements from begin to the end of the TypedArray.
   * The range specified by the begin and end values is clamped to the valid index range for the current array.
   * If the computed length of the new TypedArray would be negative, it is clamped to zero.
   * <p>
   * The returned TypedArray will be of the same type as the array on which this method is invoked.
   *
   * @param self self reference
   * @param begin begin position
   * @param end end position
   * @return sub array
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  protected static NativeFloat64Array subarray(Object self, Object begin, Object end) {
    return (NativeFloat64Array) ArrayBufferView.subarrayImpl(self, begin, end);
  }

  /**
   * ECMA 6 22.2.3.30 %TypedArray%.prototype [ @@iterator ] ( )
   * @param self the self reference
   * @return an iterator over the array's values
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, name = "@@iterator")
  public static Object getIterator(Object self) {
    return ArrayIterator.newArrayValueIterator(self);
  }

  @Override
  protected ScriptObject getPrototype(Global global) {
    return global.getFloat64ArrayPrototype();
  }

}
