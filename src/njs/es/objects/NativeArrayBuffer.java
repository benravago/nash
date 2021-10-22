package es.objects;

import java.nio.ByteBuffer;

import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.Getter;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.SpecializedFunction;
import es.objects.annotations.Where;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import static es.runtime.ECMAErrors.typeError;


/**
 * NativeArrayBuffer - ArrayBuffer as described in the JS typed array spec
 */
@ScriptClass("ArrayBuffer")
public final class NativeArrayBuffer extends ScriptObject {

  private final ByteBuffer nb;

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  /**
   * Constructor
   * @param nb native byte buffer to wrap
   * @param global global instance
   */
  protected NativeArrayBuffer(ByteBuffer nb, Global global) {
    super(global.getArrayBufferPrototype(), $nasgenmap$);
    this.nb = nb;
  }

  /**
   * Constructor
   * @param nb native byte buffer to wrap
   */
  protected NativeArrayBuffer(ByteBuffer nb) {
    this(nb, Global.instance());
  }

  /**
   * Constructor
   * @param byteLength byteLength for buffer
   */
  protected NativeArrayBuffer(int byteLength) {
    this(ByteBuffer.allocateDirect(byteLength));
  }

  /**
   * Clone constructor
   * Used only for slice
   * @param other original buffer
   * @param begin begin byte index
   * @param end   end byte index
   */
  protected NativeArrayBuffer(NativeArrayBuffer other, int begin, int end) {
    this(cloneBuffer(other.getNioBuffer(), begin, end));
  }

  /**
   * Constructor
   * @param newObj is this invoked with new
   * @param self   self reference
   * @param args   arguments to constructor
   * @return new NativeArrayBuffer
   */
  @Constructor(arity = 1)
  public static NativeArrayBuffer constructor(boolean newObj, Object self, Object... args) {
    if (!newObj) {
      throw typeError("constructor.requires.new", "ArrayBuffer");
    }
    if (args.length == 0) {
      return new NativeArrayBuffer(0);
    }
    var arg0 = args[0];
    if (arg0 instanceof ByteBuffer b) {
      return new NativeArrayBuffer(b);
    } else {
      return new NativeArrayBuffer(JSType.toInt32(arg0));
    }
  }

  static ByteBuffer cloneBuffer(ByteBuffer original, int begin, int end) {
    var clone = ByteBuffer.allocateDirect(original.capacity());
    original.rewind();//copy from the beginning
    clone.put(original);
    original.rewind();
    clone.flip();
    clone.position(begin);
    clone.limit(end);
    return clone.slice();
  }

  ByteBuffer getNioBuffer() {
    return nb;
  }

  @Override
  public String getClassName() {
    return "ArrayBuffer";
  }

  /**
   * Byte length for native array buffer
   * @param self native array buffer
   * @return byte length
   */
  @Getter(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_WRITABLE | Attribute.NOT_CONFIGURABLE)
  public static int byteLength(Object self) {
    return ((NativeArrayBuffer) self).getByteLength();
  }

  /**
   * Returns true if an object is an ArrayBufferView
   *
   * @param self self
   * @param obj  object to check
   *
   * @return true if obj is an ArrayBufferView
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static boolean isView(Object self, Object obj) {
    return obj instanceof ArrayBufferView;
  }

  /**
   * Slice function
   * @param self   native array buffer
   * @param begin0 start byte index
   * @param end0   end byte index
   * @return new array buffer, sliced
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static NativeArrayBuffer slice(Object self, Object begin0, Object end0) {
    var arrayBuffer = (NativeArrayBuffer) self;
    var byteLength = arrayBuffer.getByteLength();
    var begin = adjustIndex(JSType.toInt32(begin0), byteLength);
    var end = adjustIndex(end0 != ScriptRuntime.UNDEFINED ? JSType.toInt32(end0) : byteLength, byteLength);
    return new NativeArrayBuffer(arrayBuffer, begin, Math.max(end, begin));
  }

  /**
   * Specialized slice function
   * @param self   native array buffer
   * @param begin  start byte index
   * @param end    end byte index
   * @return new array buffer, sliced
   */
  @SpecializedFunction
  public static Object slice(Object self, int begin, int end) {
    var arrayBuffer = (NativeArrayBuffer) self;
    var byteLength = arrayBuffer.getByteLength();
    return new NativeArrayBuffer(arrayBuffer, adjustIndex(begin, byteLength), Math.max(adjustIndex(end, byteLength), begin));
  }

  /**
   * Specialized slice function
   * @param self   native array buffer
   * @param begin  start byte index
   * @return new array buffer, sliced
   */
  @SpecializedFunction
  public static Object slice(Object self, int begin) {
    return slice(self, begin, ((NativeArrayBuffer) self).getByteLength());
  }

  /**
   * If index is negative, it refers to an index from the end of the array, as opposed to from the beginning.
   * The index is clamped to the valid index range for the array.
   * @param index  The index.
   * @param length The length of the array.
   * @return valid index index in the range [0, length).
   */
  static int adjustIndex(int index, int length) {
    return index < 0 ? clamp(index + length, length) : clamp(index, length);
  }

  /**
   * Clamp index into the range [0, length).
   */
  static int clamp(int index, int length) {
    return (index < 0) ? 0
         : (index > length) ? length
         : index;
  }

  int getByteLength() {
    return nb.limit();
  }

  ByteBuffer getBuffer() {
    return nb;
  }

  ByteBuffer getBuffer(int offset) {
    return nb.duplicate().position(offset);
  }

  ByteBuffer getBuffer(int offset, int length) {
    return getBuffer(offset).limit(length);
  }

}
