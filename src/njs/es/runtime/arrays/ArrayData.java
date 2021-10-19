package es.runtime.arrays;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.reflect.Array;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;

import es.codegen.CompilerConstants;
import es.codegen.types.Type;
import es.objects.Global;
import es.runtime.JSType;
import es.runtime.PropertyDescriptor;
import es.runtime.ScriptRuntime;
import es.runtime.UnwarrantedOptimismException;
import static es.codegen.CompilerConstants.staticCall;

/**
 * ArrayData - abstraction for wrapping array elements
 */
public abstract class ArrayData {

  // Minimum chunk size for underlying arrays
  protected static final int CHUNK_SIZE = 32;

  /** Untouched data - still link callsites as IntArrayData, but expands to a proper ArrayData when we try to write to it */
  public static final ArrayData EMPTY_ARRAY = new UntouchedArrayData();

  // Length of the array data.
  // Not necessarily length of the wrapped array.
  // This is private to ensure that no one in a subclass is able to touch the length without going through {@link #setLength}.
  // This is used to implement{@link LengthNotWritableFilter}s, ensuring that there are no ways past a {@link #setLength} function replaced by a nop
  private long length;

  // Method handle to throw an {@link UnwarrantedOptimismException} when getting an element of the wrong type
  protected static final CompilerConstants.Call THROW_UNWARRANTED = staticCall(MethodHandles.lookup(), ArrayData.class, "throwUnwarranted", void.class, ArrayData.class, int.class, int.class);

  /**
   * Immutable empty array to get ScriptObjects started.
   * Use the same array and convert it to mutable as soon as it is modified
   */
  static class UntouchedArrayData extends ContinuousArrayData {

    UntouchedArrayData() {
      super(0);
    }

    ArrayData toRealArrayData() {
      return new IntArrayData(0);
    }

    ArrayData toRealArrayData(int index) {
      var newData = new IntArrayData(index + 1);
      return new DeletedRangeArrayFilter(newData, 0, index);
    }

    @Override
    public ContinuousArrayData copy() {
      assert length() == 0;
      return this;
    }

    @Override
    public Object asArrayOfType(Class<?> componentType) {
      return Array.newInstance(componentType, 0);
    }

    @Override
    public Object[] asObjectArray() {
      return ScriptRuntime.EMPTY_ARRAY;
    }

    @Override
    public ArrayData ensure(long safeIndex) {
      assert safeIndex >= 0L;
      if (safeIndex >= SparseArrayData.MAX_DENSE_LENGTH) {
        return new SparseArrayData(this, safeIndex + 1);
      }
      // known to fit in int
      return toRealArrayData((int) safeIndex);
    }

    @Override
    public ArrayData convert(Class<?> type) {
      return toRealArrayData().convert(type);
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
    public ArrayData shiftLeft(int by) {
      return this; // nop, always empty or we wouldn't be of this class
    }

    @Override
    public ArrayData shiftRight(int by) {
      return this; //always empty or we wouldn't be of this class
    }

    @Override
    public ArrayData shrink(long newLength) {
      return this;
    }

    @Override
    public ArrayData set(int index, Object value) {
      return toRealArrayData(index).set(index, value);
    }

    @Override
    public ArrayData set(int index, int value) {
      return toRealArrayData(index).set(index, value);
    }

    @Override
    public ArrayData set(int index, double value) {
      return toRealArrayData(index).set(index, value);
    }

    @Override
    public int getInt(int index) {
      throw new ArrayIndexOutOfBoundsException(index); //empty
    }

    @Override
    public double getDouble(int index) {
      throw new ArrayIndexOutOfBoundsException(index); //empty
    }

    @Override
    public Object getObject(int index) {
      throw new ArrayIndexOutOfBoundsException(index); //empty
    }

    @Override
    public boolean has(int index) {
      return false; //empty
    }

    @Override
    public Object pop() {
      return ScriptRuntime.UNDEFINED;
    }

    @Override
    public ArrayData slice(long from, long to) {
      return this; //empty
    }

    @Override
    public ContinuousArrayData fastConcat(ContinuousArrayData otherData) {
      return otherData.copy();
    }

    // no need to override fastPopInt, as the default behavior is to throw classcast exception so we
    // can relink and return an undefined, this is the IntArrayData default behavior
    @Override
    public String toString() {
      return getClass().getSimpleName();
    }

    @Override
    public MethodHandle getElementGetter(Class<?> returnType, int programPoint) {
      return null;
    }

    @Override
    public MethodHandle getElementSetter(Class<?> elementType) {
      return null;
    }

    @Override
    public Class<?> getElementType() {
      return int.class;
    }

    @Override
    public Class<?> getBoxedElementType() {
      return Integer.class;
    }
  }

  /**
   * Constructor
   * @param length Virtual length of the array.
   */
  protected ArrayData(long length) {
    this.length = length;
  }

  /**
   * Factory method for unspecified array - start as int
   * @return ArrayData
   */
  public static ArrayData initialArray() {
    return new IntArrayData();
  }

  /**
   * Unwarranted thrower
   * @param data         array data
   * @param programPoint program point
   * @param index        array index
   */
  protected static void throwUnwarranted(ArrayData data, int programPoint, int index) {
    throw new UnwarrantedOptimismException(data.getObject(index), programPoint);
  }

  /**
   * Align an array size up to the nearest array chunk size
   * @param size size required
   * @return size given, always &gt;= size
   */
  protected static int alignUp(int size) {
    return size + CHUNK_SIZE - 1 & ~(CHUNK_SIZE - 1);
  }

  /**
   * Factory method for unspecified array with given length - start as int array data
   * @param length the initial length
   * @return ArrayData
   */
  public static ArrayData allocate(long length) {
    return (length == 0L) ? new IntArrayData()
         : (length >= SparseArrayData.MAX_DENSE_LENGTH) ? new SparseArrayData(EMPTY_ARRAY, length)
         : new DeletedRangeArrayFilter(new IntArrayData((int) length), 0, length - 1);
  }

  /**
   * Factory method for unspecified given an array object
   *
   * @param  array the array
   * @return ArrayData wrapping this array
   */
  public static ArrayData allocate(Object array) {
    var type = array.getClass();
    return (type == int[].class) ? new IntArrayData((int[]) array, ((int[]) array).length)
         : (type == double[].class) ? new NumberArrayData((double[]) array, ((double[]) array).length)
         : new ObjectArrayData((Object[]) array, ((Object[]) array).length);
  }

  /**
   * Allocate an ArrayData wrapping a given array
   * @param array the array to use for initial elements
   * @return the ArrayData
   */
  public static ArrayData allocate(int[] array) {
    return new IntArrayData(array, array.length);
  }

  /**
   * Allocate an ArrayData wrapping a given array
   * @param array the array to use for initial elements
   * @return the ArrayData
   */
  public static ArrayData allocate(double[] array) {
    return new NumberArrayData(array, array.length);
  }

  /**
   * Allocate an ArrayData wrapping a given array
   * @param array the array to use for initial elements
   * @return the ArrayData
   */
  public static ArrayData allocate(Object[] array) {
    return new ObjectArrayData(array, array.length);
  }

  /**
   * Allocate an ArrayData wrapping a given nio ByteBuffer
   * @param buf the nio ByteBuffer to wrap
   * @return the ArrayData
   */
  public static ArrayData allocate(ByteBuffer buf) {
    return new ByteBufferArrayData(buf);
  }

  /**
   * Apply a freeze filter to an ArrayData.
   * @param underlying  the underlying ArrayData to wrap in the freeze filter
   * @return the frozen ArrayData
   */
  public static ArrayData freeze(ArrayData underlying) {
    return new FrozenArrayFilter(underlying);
  }

  /**
   * Apply a seal filter to an ArrayData.
   * @param underlying  the underlying ArrayData to wrap in the seal filter
   * @return the sealed ArrayData
   */
  public static ArrayData seal(ArrayData underlying) {
    return new SealedArrayFilter(underlying);
  }

  /**
   * Prevent this array from being extended
   * @param  underlying the underlying ArrayData to wrap in the non extensible filter
   * @return new array data, filtered
   */
  public static ArrayData preventExtension(ArrayData underlying) {
    return new NonExtensibleArrayFilter(underlying);
  }

  /**
   * Prevent this array from having its length reset
   * @param underlying the underlying ArrayDAta to wrap in the non extensible filter
   * @return new array data, filtered
   */
  public static ArrayData setIsLengthNotWritable(ArrayData underlying) {
    return new LengthNotWritableFilter(underlying);
  }

  /**
   * Return the length of the array data.
   * This may differ from the actual length of the array this wraps as length may be set or gotten as any other JavaScript Property
   * Even though a JavaScript array length may be a long, we only store int parts for the optimized array access.
   * For long lengths there are special cases anyway.
   * TODO: represent arrays with "long" lengths as a special ArrayData that basically maps to the ScriptObject directly for better abstraction
   * @return the length of the data
   */
  public final long length() {
    return length;
  }

  /**
   * Return a copy of the array that can be modified without affecting this instance.
   * It is safe to return themselves for immutable subclasses.
   * @return a new array
   */
  public abstract ArrayData copy();

  /**
   * Return a copy of the array data as an Object array.
   * @return an Object array
   */
  public abstract Object[] asObjectArray();

  /**
   * Return a copy of the array data as an array of the specified type.
   * @param componentType  the type of elements in the array
   * @return and array of the given type
   */
  public Object asArrayOfType(Class<?> componentType) {
    return JSType.convertArray(asObjectArray(), componentType);
  }

  /**
   * Set the length of the data array
   * @param length the new length for the data array
   */
  public void setLength(long length) {
    this.length = length;
  }

  /**
   * Increase length by 1
   * @return the new length, not the old one (i.e. pre-increment)
   */
  protected final long increaseLength() {
    return ++this.length;
  }

  /**
   * Decrease length by 1.
   * @return the new length, not the old one (i.e. pre-decrement)
   */
  protected final long decreaseLength() {
    return --this.length;
  }

  /**
   * Shift the array data left
   * TODO: This is used for Array.prototype.shift() which only shifts by 1, so we might consider dropping the offset parameter.
   * @param by offset to shift
   * @return New arraydata (or same)
   */
  public abstract ArrayData shiftLeft(int by);

  /**
   * Shift the array right
   * @param by offset to shift
   * @return New arraydata (or same)
   */
  public abstract ArrayData shiftRight(int by);

  /**
   * Ensure that the given index exists and won't fail in a subsequent access.
   * If {@code safeIndex} is equal or greater than the current length the length is updated to {@code safeIndex + 1}.
   * @param safeIndex the index to ensure wont go out of bounds
   * @return new array data (or same)
   */
  public abstract ArrayData ensure(long safeIndex);

  /**
   * Shrink the array to a new length, may or may not retain the inner array
   * @param newLength new max length
   * @return new array data (or same)
   */
  public abstract ArrayData shrink(long newLength);

  /**
   * Set an object value at a given index
   * @param index the index
   * @param value the value
   * @return new array data (or same)
   */
  public abstract ArrayData set(int index, Object value);

  /**
   * Set an int value at a given index
   * @param index the index
   * @param value the value
   * @return new array data (or same)
   */
  public abstract ArrayData set(int index, int value);

  /**
   * Set an double value at a given index
   * @param index the index
   * @param value the value
   * @return new array data (or same)
   */
  public abstract ArrayData set(int index, double value);

  /**
   * Set an empty value at a given index. Should only affect Object array.
   * @param index the index
   * @return new array data (or same)
   */
  public ArrayData setEmpty(int index) {
    // Do nothing.
    return this;
  }

  /**
   * Set an empty value for a given range. Should only affect Object array.
   * @param lo range low end
   * @param hi range high end
   * @return new array data (or same)
   */
  public ArrayData setEmpty(long lo, long hi) {
    // Do nothing.
    return this;
  }

  /**
   * Get an int value from a given index
   * @param index the index
   * @return the value
   */
  public abstract int getInt(int index);

  /**
   * Returns the optimistic type of this array data.
   * Basically, when an array data object needs to throw an {@link UnwarrantedOptimismException}, this type is used as the actual type of the return value.
   * @return the optimistic type of this array data.
   */
  public Type getOptimisticType() {
    return Type.OBJECT;
  }

  /**
   * Get optimistic int - default is that it's impossible.
   * Overridden by arrays that actually represents ints
   * @param index        the index
   * @param programPoint program point
   * @return the value
   */
  public int getIntOptimistic(int index, int programPoint) {
    throw new UnwarrantedOptimismException(getObject(index), programPoint, getOptimisticType());
  }

  /**
   * Get a double value from a given index
   * @param index the index
   * @return the value
   */
  public abstract double getDouble(int index);

  /**
   * Get optimistic double - default is that it's impossible.
   * Overridden by arrays that actually represents doubles or narrower
   * @param index        the index
   * @param programPoint program point
   * @return the value
   */
  public double getDoubleOptimistic(int index, int programPoint) {
    throw new UnwarrantedOptimismException(getObject(index), programPoint, getOptimisticType());
  }

  /**
   * Get an Object value from a given index
   * @param index the index
   * @return the value
   */
  public abstract Object getObject(int index);

  /**
   * Tests to see if an entry exists (avoids boxing.)
   * @param index the index
   * @return true if entry exists
   */
  public abstract boolean has(int index);

  /**
   * Returns if element at specific index can be deleted or not.
   * @param index the index of the element
   * @return true if element can be deleted
   */
  public boolean canDelete(int index) {
    return true;
  }

  /**
   * Returns if element at specific index can be deleted or not.
   * @param longIndex  the index
   * @return true if range can be deleted
   */
  public boolean canDelete(long longIndex) {
    return true;
  }

  /**
   * Delete a range from the array if {@code fromIndex} is less than or equal to {@code toIndex} and the array supports deletion.
   * @param fromIndex  the start index (inclusive)
   * @param toIndex    the end index (inclusive)
   * @return an array with the range deleted, or this array if no deletion took place
   */
  public final ArrayData safeDelete(long fromIndex, long toIndex) {
    return (fromIndex <= toIndex && canDelete(fromIndex)) ? delete(fromIndex, toIndex) : this;
  }

  /**
   * Returns property descriptor for element at a given index
   * @param global the global object
   * @param index  the index
   * @return property descriptor for element
   */
  public PropertyDescriptor getDescriptor(Global global, int index) {
    return global.newDataDescriptor(getObject(index), true, true, true);
  }

  /**
   * Delete an array value at the given index, substituting for an undefined
   * @param index the index
   * @return new array data (or same)
   */
  public abstract ArrayData delete(int index);

  /**
   * Delete a given range from this array;
   * @param fromIndex  from index (inclusive)
   * @param toIndex    to index (inclusive)
   * @return new ArrayData after deletion
   */
  public abstract ArrayData delete(long fromIndex, long toIndex);

  /**
   * Convert the ArrayData to one with a different element type.
   * Currently Arrays are not collapsed to narrower types, just to wider ones.
   * Attempting to narrow an array will assert
   * @param type new element type
   * @return new array data
   */
  public abstract ArrayData convert(Class<?> type);

  /**
   * Push an array of items to the end of the array
   * @param items  the items
   * @return new array data (or same)
   */
  public ArrayData push(Object... items) {
    if (items.length == 0) {
      return this;
    }
    var widest = widestType(items);
    var newData = convert(widest);
    var pos = newData.length;
    for (var item : items) {
      newData = newData.ensure(pos); //avoid sparse array
      newData.set((int) pos++, item);
    }
    return newData;
  }

  /**
   * Pop an element from the end of the array
   * @return the popped element
   */
  public abstract Object pop();

  /**
   * Slice out a section of the array and return that subsection as a new array data: [from, to)
   * @param from start index
   * @param to   end index + 1
   * @return new array data
   */
  public abstract ArrayData slice(long from, long to);

  /**
   * Fast splice operation.
   * This just modifies the array according to the number of elements added and deleted but does not insert the added elements.
   * Throws {@code UnsupportedOperationException} if fast splice operation is not supported for this class or arguments.
   * @param start start index of splice operation
   * @param removed number of removed elements
   * @param added number of added elements
   * @throws UnsupportedOperationException if fast splice is not supported for the class or arguments.
   * @return new arraydata, but this never happens because we always throw an exception
   */
  public ArrayData fastSplice(int start, int removed, int added) throws UnsupportedOperationException {
    throw new UnsupportedOperationException();
  }

  static Class<?> widestType(Object... items) {
    assert items.length > 0;
    Class<?> widest = Integer.class;
    for (Object item : items) {
      if (item == null) {
        return Object.class;
      }
      var itemClass = item.getClass();
      if (itemClass == Double.class || itemClass == Float.class || itemClass == Long.class) {
        if (widest == Integer.class) {
          widest = Double.class;
        }
      } else if (itemClass != Integer.class && itemClass != Short.class && itemClass != Byte.class) {
        return Object.class;
      }
    }
    return widest;
  }

  /**
   * Return a list of keys in the array for the iterators
   * @return iterator key list
   */
  protected List<Long> computeIteratorKeys() {
    var keys = new ArrayList<Long>();
    var len = length();
    for (var i = 0L; i < len; i = nextIndex(i)) {
      if (has((int) i)) {
        keys.add(i);
      }
    }
    return keys;
  }

  /**
   * Return an iterator that goes through all indexes of elements in this array.
   * This includes those after array.length if they exist
   * @return iterator
   */
  public Iterator<Long> indexIterator() {
    return computeIteratorKeys().iterator();
  }

  /**
   * Exponential growth function for array size when in need of resizing.
   * @param size current size
   * @return next size to allocate for internal array
   */
  public static int nextSize(int size) {
    return alignUp(size + 1) * 2;
  }

  /**
   * Return the next valid index from a given one.
   * Subclassed for various array representation
   * @param index the current index
   * @return the next index
   */
  long nextIndex(long index) {
    return index + 1;
  }

  static Object invoke(MethodHandle mh, Object arg) {
    try {
      return mh.invoke(arg);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  /**
   * Find a fast call if one exists
   * @param clazz    array data class
   * @param desc     callsite descriptor
   * @param request  link request
   * @return fast property getter if one is found
   */
  public GuardedInvocation findFastCallMethod(Class<? extends ArrayData> clazz, CallSiteDescriptor desc, LinkRequest request) {
    return null;
  }

  /**
   * Find a fast element getter if one exists
   * @param clazz   array data class
   * @param desc    callsite descriptor
   * @param request link request
   * @return fast index getter if one is found
   */
  public GuardedInvocation findFastGetIndexMethod(Class<? extends ArrayData> clazz, CallSiteDescriptor desc, LinkRequest request) { // array, index, value
    return null;
  }

  /**
   * Find a fast element setter if one exists
   * @param clazz   array data class
   * @param desc    callsite descriptor
   * @param request link request
   * @return fast index getter if one is found
   */
  public GuardedInvocation findFastSetIndexMethod(Class<? extends ArrayData> clazz, CallSiteDescriptor desc, LinkRequest request) { // array, index, value
    return null;
  }

}
