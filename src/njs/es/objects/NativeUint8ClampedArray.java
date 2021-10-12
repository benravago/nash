package es.objects;

import static es.codegen.CompilerConstants.specialCall;
import static es.codegen.CompilerConstants.staticCall;
import static es.lookup.Lookup.MH;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.nio.ByteBuffer;
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
 * Uint8 clamped array for TypedArray extension
 */
@ScriptClass("Uint8ClampedArray")
public final class NativeUint8ClampedArray extends ArrayBufferView {

  /**
   * The size in bytes of each element in the array.
   */
  @Property(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_WRITABLE | Attribute.NOT_CONFIGURABLE, where = Where.CONSTRUCTOR)
  public static final int BYTES_PER_ELEMENT = 1;

  // initialized by nasgen
  @SuppressWarnings("unused")
  private static PropertyMap $nasgenmap$;

  private static final Factory FACTORY = new Factory(BYTES_PER_ELEMENT) {
    @Override
    public ArrayBufferView construct(final NativeArrayBuffer buffer, final int byteOffset, final int length) {
      return new NativeUint8ClampedArray(buffer, byteOffset, length);
    }

    @Override
    public Uint8ClampedArrayData createArrayData(final ByteBuffer nb, final int start, final int end) {
      return new Uint8ClampedArrayData(nb, start, end);
    }

    @Override
    public String getClassName() {
      return "Uint8ClampedArray";
    }
  };

  private static final class Uint8ClampedArrayData extends TypedArrayData<ByteBuffer> {

    private static final MethodHandle GET_ELEM = specialCall(MethodHandles.lookup(), Uint8ClampedArrayData.class, "getElem", int.class, int.class).methodHandle();
    private static final MethodHandle SET_ELEM = specialCall(MethodHandles.lookup(), Uint8ClampedArrayData.class, "setElem", void.class, int.class, int.class).methodHandle();
    private static final MethodHandle RINT_D = staticCall(MethodHandles.lookup(), Uint8ClampedArrayData.class, "rint", double.class, double.class).methodHandle();
    private static final MethodHandle RINT_O = staticCall(MethodHandles.lookup(), Uint8ClampedArrayData.class, "rint", Object.class, Object.class).methodHandle();

    private Uint8ClampedArrayData(final ByteBuffer nb, final int start, final int end) {
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
      return int.class;
    }

    @Override
    public Class<?> getBoxedElementType() {
      return int.class;
    }

    private int getElem(final int index) {
      try {
        return nb.get(index) & 0xff;
      } catch (final IndexOutOfBoundsException e) {
        throw new ClassCastException(); //force relink - this works for unoptimistic too
      }
    }

    @Override
    public MethodHandle getElementSetter(final Class<?> elementType) {
      final MethodHandle setter = super.getElementSetter(elementType); //getContinuousElementSetter(getClass(), setElem(), elementType);
      if (setter != null) {
        if (elementType == Object.class) {
          return MH.filterArguments(setter, 2, RINT_O);
        } else if (elementType == double.class) {
          return MH.filterArguments(setter, 2, RINT_D);
        }
      }
      return setter;
    }

    private void setElem(final int index, final int elem) {
      try {
        if (index < nb.limit()) {
          final byte clamped;
          if ((elem & 0xffff_ff00) == 0) {
            clamped = (byte) elem;
          } else {
            clamped = elem < 0 ? 0 : (byte) 0xff;
          }
          nb.put(index, clamped);
        }
      } catch (final IndexOutOfBoundsException e) {
        throw new ClassCastException();
      }
    }

    @Override
    public boolean isClamped() {
      return true;
    }

    @Override
    public boolean isUnsigned() {
      return true;
    }

    @Override
    public int getInt(final int index) {
      return getElem(index);
    }

    @Override
    public int getIntOptimistic(final int index, final int programPoint) {
      return getElem(index);
    }

    @Override
    public double getDouble(final int index) {
      return getInt(index);
    }

    @Override
    public double getDoubleOptimistic(final int index, final int programPoint) {
      return getElem(index);
    }

    @Override
    public Object getObject(final int index) {
      return getInt(index);
    }

    @Override
    public ArrayData set(final int index, final Object value) {
      return set(index, JSType.toNumber(value));
    }

    @Override
    public ArrayData set(final int index, final int value) {
      setElem(index, value);
      return this;
    }

    @Override
    public ArrayData set(final int index, final double value) {
      return set(index, (int) rint(value));
    }

    private static double rint(final double rint) {
      return (int) Math.rint(rint);
    }

    @SuppressWarnings("unused")
    private static Object rint(final Object rint) {
      return rint(JSType.toNumber(rint));
    }

  }

  /**
   * Constructor
   *
   * @param newObj is this typed array instantiated with the new operator
   * @param self   self reference
   * @param args   args
   *
   * @return new typed array
   */
  @Constructor(arity = 1)
  public static NativeUint8ClampedArray constructor(final boolean newObj, final Object self, final Object... args) {
    return (NativeUint8ClampedArray) constructorImpl(newObj, args, FACTORY);
  }

  NativeUint8ClampedArray(final NativeArrayBuffer buffer, final int byteOffset, final int length) {
    super(buffer, byteOffset, length);
  }

  @Override
  protected Factory factory() {
    return FACTORY;
  }

  /**
   * Set values
   * @param self   self reference
   * @param array  multiple values of array's type to set
   * @param offset optional start index, interpreted  0 if undefined
   * @return undefined
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  protected static Object set(final Object self, final Object array, final Object offset) {
    return ArrayBufferView.setImpl(self, array, offset);
  }

  /**
   * Returns a new TypedArray view of the ArrayBuffer store for this TypedArray,
   * referencing the elements at begin, inclusive, up to end, exclusive. If either
   * begin or end is negative, it refers to an index from the end of the array,
   * as opposed to from the beginning.
   * <p>
   * If end is unspecified, the subarray contains all elements from begin to the end
   * of the TypedArray. The range specified by the begin and end values is clamped to
   * the valid index range for the current array. If the computed length of the new
   * TypedArray would be negative, it is clamped to zero.
   * <p>
   * The returned TypedArray will be of the same type as the array on which this
   * method is invoked.
   *
   * @param self self reference
   * @param begin begin position
   * @param end end position
   *
   * @return sub array
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  protected static NativeUint8ClampedArray subarray(final Object self, final Object begin, final Object end) {
    return (NativeUint8ClampedArray) ArrayBufferView.subarrayImpl(self, begin, end);
  }

  /**
   * ECMA 6 22.2.3.30 %TypedArray%.prototype [ @@iterator ] ( )
   *
   * @param self the self reference
   * @return an iterator over the array's values
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, name = "@@iterator")
  public static Object getIterator(final Object self) {
    return ArrayIterator.newArrayValueIterator(self);
  }

  @Override
  protected ScriptObject getPrototype(final Global global) {
    return global.getUint8ClampedArrayPrototype();
  }
}
