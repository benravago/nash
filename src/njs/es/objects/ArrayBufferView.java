package es.objects;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;

import es.objects.annotations.Attribute;
import es.objects.annotations.Getter;
import es.objects.annotations.ScriptClass;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.arrays.TypedArrayData;
import static es.runtime.ECMAErrors.rangeError;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;

/**
 * ArrayBufferView, es6 class or TypedArray implementation
 */
@ScriptClass("ArrayBufferView")
public abstract class ArrayBufferView extends ScriptObject {

  private final NativeArrayBuffer buffer;
  private final int byteOffset;

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  ArrayBufferView(NativeArrayBuffer buffer, int byteOffset, int elementLength, Global global) {
    super($nasgenmap$);

    var bytesPerElement = bytesPerElement();

    checkConstructorArgs(buffer.getByteLength(), bytesPerElement, byteOffset, elementLength);
    setProto(getPrototype(global));

    this.buffer = buffer;
    this.byteOffset = byteOffset;

    assert byteOffset % bytesPerElement == 0;
    var start = byteOffset / bytesPerElement;
    var newNioBuffer = buffer.getNioBuffer().duplicate().order(ByteOrder.nativeOrder());
    var data = factory().createArrayData(newNioBuffer, start, start + elementLength);

    setArray(data);
  }

  /**
   * Constructor
   *
   * @param buffer         underlying NativeArrayBuffer
   * @param byteOffset     byte offset for buffer
   * @param elementLength  element length in bytes
   */
  protected ArrayBufferView(NativeArrayBuffer buffer, int byteOffset, int elementLength) {
    this(buffer, byteOffset, elementLength, Global.instance());
  }

  static void checkConstructorArgs(int byteLength, int bytesPerElement, int byteOffset, int elementLength) {
    if (byteOffset < 0 || elementLength < 0) {
      throw new RuntimeException("byteOffset or length must not be negative, byteOffset=" + byteOffset + ", elementLength=" + elementLength + ", bytesPerElement=" + bytesPerElement);
    } else if (byteOffset + elementLength * bytesPerElement > byteLength) {
      throw new RuntimeException("byteOffset + byteLength out of range, byteOffset=" + byteOffset + ", elementLength=" + elementLength + ", bytesPerElement=" + bytesPerElement);
    } else if (byteOffset % bytesPerElement != 0) {
      throw new RuntimeException("byteOffset must be a multiple of the element size, byteOffset=" + byteOffset + " bytesPerElement=" + bytesPerElement);
    }
  }

  int bytesPerElement() {
    return factory().bytesPerElement;
  }

  /**
   * Buffer getter as per spec
   * @param self ArrayBufferView instance
   * @return buffer
   */
  @Getter(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_WRITABLE | Attribute.NOT_CONFIGURABLE)
  public static Object buffer(Object self) {
    return ((ArrayBufferView) self).buffer;
  }

  /**
   * Buffer offset getter as per spec
   * @param self ArrayBufferView instance
   * @return buffer offset
   */
  @Getter(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_WRITABLE | Attribute.NOT_CONFIGURABLE)
  public static int byteOffset(Object self) {
    return ((ArrayBufferView) self).byteOffset;
  }

  /**
   * Byte length getter as per spec
   * @param self ArrayBufferView instance
   * @return array buffer view length in bytes
   */
  @Getter(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_WRITABLE | Attribute.NOT_CONFIGURABLE)
  public static int byteLength(Object self) {
    var view = (ArrayBufferView) self;
    return ((TypedArrayData<?>) view.getArray()).getElementLength() * view.bytesPerElement();
  }

  /**
   * Length getter as per spec
   * @param self ArrayBufferView instance
   * @return length in elements
   */
  @Getter(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_WRITABLE | Attribute.NOT_CONFIGURABLE)
  public static int length(Object self) {
    return ((ArrayBufferView) self).elementLength();
  }

  @Override
  public final Object getLength() {
    return elementLength();
  }

  int elementLength() {
    return ((TypedArrayData<?>) getArray()).getElementLength();
  }

  /**
   * Factory class for byte ArrayBufferViews
   */
  protected static abstract class Factory {

    final int bytesPerElement;
    final int maxElementLength;

    /**
     * Constructor
       * @param bytesPerElement number of bytes per element for this buffer
     */
    public Factory(int bytesPerElement) {
      this.bytesPerElement = bytesPerElement;
      this.maxElementLength = Integer.MAX_VALUE / bytesPerElement;
    }

    /**
     * Factory method
       * @param elementLength number of elements
     * @return new ArrayBufferView
     */
    public final ArrayBufferView construct(int elementLength) {
      if (elementLength > maxElementLength) {
        throw rangeError("inappropriate.array.buffer.length", JSType.toString(elementLength));
      }
      return construct(new NativeArrayBuffer(elementLength * bytesPerElement), 0, elementLength);
    }

    /**
     * Factory method
     * @param buffer         underlying buffer
     * @param byteOffset     byte offset
     * @param elementLength  number of elements
       * @return new ArrayBufferView
     */
    public abstract ArrayBufferView construct(NativeArrayBuffer buffer, int byteOffset, int elementLength);

    /**
     * Factory method for array data
     * @param nb    underlying native buffer
     * @param start start element
     * @param end   end element
     * @return      new array data
     */
    public abstract TypedArrayData<?> createArrayData(ByteBuffer nb, int start, int end);

    /**
     * Get the class name for this type of buffer
     * @return class name
     */
    public abstract String getClassName();
  }

  /**
   * Get the factor for this kind of buffer
   * @return Factory
   */
  protected abstract Factory factory();

  /**
   * Get the prototype for this ArrayBufferView
   * @param global global instance
   * @return prototype
   */
  protected abstract ScriptObject getPrototype(Global global);

  @Override
  public final String getClassName() {
    return factory().getClassName();
  }

  /**
   * Check if this array contains floats
   * @return true if float array (or double)
   */
  protected boolean isFloatArray() {
    return false;
  }

  /**
   * Inheritable constructor implementation
   * @param newObj   is this a new constructor
   * @param args     arguments
   * @param factory  factory
   * @return new ArrayBufferView
   */
  protected static ArrayBufferView constructorImpl(boolean newObj, Object[] args, Factory factory) {
    var arg0 = args.length != 0 ? args[0] : 0;
    ArrayBufferView dest;
    int length;
    if (!newObj) {
      throw typeError("constructor.requires.new", factory.getClassName());
    }
    if (arg0 instanceof NativeArrayBuffer buffer) {
      // Constructor(ArrayBuffer buffer, optional unsigned long byteOffset, optional unsigned long length)
      var byteOffset = args.length > 1 ? JSType.toInt32(args[1]) : 0;
      if (args.length > 2) {
        length = JSType.toInt32(args[2]);
      } else {
        if ((buffer.getByteLength() - byteOffset) % factory.bytesPerElement != 0) {
          throw new RuntimeException("buffer.byteLength - byteOffset must be a multiple of the element size");
        }
        length = (buffer.getByteLength() - byteOffset) / factory.bytesPerElement;
      }
      return factory.construct(buffer, byteOffset, length);
    } else if (arg0 instanceof ArrayBufferView b) {
      // Constructor(TypedArray array)
      length = b.elementLength();
      dest = factory.construct(length);
    } else if (arg0 instanceof NativeArray n) {
      // Constructor(type[] array)
      length = lengthToInt(n.getArray().length());
      dest = factory.construct(length);
    } else {
      // Constructor(unsigned long length). Treating infinity as 0 is a special case for ArrayBufferView.
      var dlen = JSType.toNumber(arg0);
      length = lengthToInt(Double.isInfinite(dlen) ? 0L : JSType.toLong(dlen));
      return factory.construct(length);
    }
    copyElements(dest, length, (ScriptObject) arg0, 0);
    return dest;
  }

  /**
   * Inheritable implementation of set, if no efficient implementation is available
   * @param self     ArrayBufferView instance
   * @param array    array
   * @param offset0  array offset
   * @return result of setter
   */
  protected static Object setImpl(Object self, Object array, Object offset0) {
    var dest = (ArrayBufferView) self;
    int length;
    if (array instanceof ArrayBufferView a) {
      // void set(TypedArray array, optional unsigned long offset)
      length = a.elementLength();
    } else if (array instanceof NativeArray n) {
      // void set(type[] array, optional unsigned long offset)
      length = (int) (n.getArray().length() & 0x7fff_ffff);
    } else {
      throw new RuntimeException("argument is not of array type");
    }
    var source = (ScriptObject) array;
    var offset = JSType.toInt32(offset0); // default=0
    if (dest.elementLength() < length + offset || offset < 0) {
      throw new RuntimeException("offset or array length out of bounds");
    }
    copyElements(dest, length, source, offset);
    return ScriptRuntime.UNDEFINED;
  }

  static void copyElements(ArrayBufferView dest, int length, ScriptObject source, int offset) {
    if (!dest.isFloatArray()) {
      for (int i = 0, j = offset; i < length; i++, j++) {
        dest.set(j, source.getInt(i, INVALID_PROGRAM_POINT), 0);
      }
    } else {
      for (int i = 0, j = offset; i < length; i++, j++) {
        dest.set(j, source.getDouble(i, INVALID_PROGRAM_POINT), 0);
      }
    }
  }

  static int lengthToInt(long length) {
    if (length > Integer.MAX_VALUE || length < 0) {
      throw rangeError("inappropriate.array.buffer.length", JSType.toString(length));
    }
    return (int) (length & Integer.MAX_VALUE);
  }

  /**
   * Implementation of subarray if no efficient override exists
   *
   * @param self    ArrayBufferView instance
   * @param begin0  begin index
   * @param end0    end index
   *
   * @return sub array
   */
  protected static ScriptObject subarrayImpl(Object self, Object begin0, Object end0) {
    var arrayView = (ArrayBufferView) self;
    var byteOffset = arrayView.byteOffset;
    var bytesPerElement = arrayView.bytesPerElement();
    var elementLength = arrayView.elementLength();
    var begin = NativeArrayBuffer.adjustIndex(JSType.toInt32(begin0), elementLength);
    var end = NativeArrayBuffer.adjustIndex(end0 != ScriptRuntime.UNDEFINED ? JSType.toInt32(end0) : elementLength, elementLength);
    var length = Math.max(end - begin, 0);
    assert byteOffset % bytesPerElement == 0;
    //second is byteoffset
    return arrayView.factory().construct(arrayView.buffer, begin * bytesPerElement + byteOffset, length);
  }

  @Override
  protected GuardedInvocation findGetIndexMethod(CallSiteDescriptor desc, LinkRequest request) {
    var inv = getArray().findFastGetIndexMethod(getArray().getClass(), desc, request);
    return (inv != null) ? inv : super.findGetIndexMethod(desc, request);
  }

  @Override
  protected GuardedInvocation findSetIndexMethod(CallSiteDescriptor desc, LinkRequest request) {
    var inv = getArray().findFastSetIndexMethod(getArray().getClass(), desc, request);
    return (inv != null) ? inv : super.findSetIndexMethod(desc, request);
  }

}
