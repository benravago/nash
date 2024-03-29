package es.runtime.arrays;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.SwitchPoint;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;

import es.codegen.types.Type;
import es.lookup.Lookup;
import es.runtime.ScriptObject;
import es.runtime.linker.NashornCallSiteDescriptor;
import static es.codegen.CompilerConstants.staticCall;
import static es.lookup.Lookup.MH;
import static es.runtime.JSType.getAccessorTypeIndex;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;
import static es.runtime.UnwarrantedOptimismException.isValid;

/**
 * Interface implemented by all arrays that are directly accessible as underlying native arrays
 */
public abstract class ContinuousArrayData extends ArrayData {

  /**
   * Constructor
   * @param length length (elementLength)
   */
  protected ContinuousArrayData(long length) {
    super(length);
  }

  /**
   * Check if we can put one more element at the end of this continuous array without reallocating, or if we are overwriting an already allocated element
   * @param index index to check
   * @return true if we don't need to do any array reallocation to fit an element at index
   */
  public final boolean hasRoomFor(int index) {
    return has(index) || (index == length() && ensure(index) == this);
  }

  /**
   * Check if an arraydata is empty
   * @return true if empty
   */
  public boolean isEmpty() {
    return length() == 0L;
  }

  /**
   * Return element getter for a certain type at a certain program point
   * @param returnType   return type
   * @param programPoint program point
   * @return element getter or null if not supported (used to implement slow linkage instead as fast isn't possible)
   */
  public abstract MethodHandle getElementGetter(Class<?> returnType, int programPoint);

  /**
   * Return element getter for a certain type at a certain program point
   * @param elementType element type
   * @return element setter or null if not supported (used to implement slow linkage instead as fast isn't possible)
   */
  public abstract MethodHandle getElementSetter(Class<?> elementType);

  /**
   * Version of has that throws a class cast exception if element does not exist used for relinking
   * @param index index to check - currently only int indexes
   * @return index
   */
  protected final int throwHas(int index) {
    if (!has(index)) {
      throw new ClassCastException();
    }
    return index;
  }

  @Override
  public abstract ContinuousArrayData copy();

  /**
   * Returns the type used to store an element in this array
   * @return element type
   */
  public abstract Class<?> getElementType();

  @Override
  public Type getOptimisticType() {
    return Type.typeFor(getElementType());
  }

  /**
   * Returns the boxed type of the type used to store an element in this array
   * @return element type
   */
  public abstract Class<?> getBoxedElementType();

  /**
   * Get the widest element type of two arrays.
   * This can be done faster in subclasses, but this works for all ContinuousArrayDatas and for where more optimal checks haven't been implemented.
   * @param otherData another ContinuousArrayData
   * @return the widest boxed element type
   */
  public ContinuousArrayData widest(ContinuousArrayData otherData) {
    var elementType = getElementType();
    return Type.widest(elementType, otherData.getElementType()) == elementType ? this : otherData;
  }

  /**
   * Look up a continuous array element getter
   * @param get          getter, sometimes combined with a has check that throws CCE on failure for relink
   * @param returnType   return type
   * @param programPoint program point
   * @return array getter
   */
  protected final MethodHandle getContinuousElementGetter(MethodHandle get, Class<?> returnType, int programPoint) {
    return getContinuousElementGetter(getClass(), get, returnType, programPoint);
  }

  /**
   * Look up a continuous array element setter
   * @param set          setter, sometimes combined with a has check that throws CCE on failure for relink
   * @param returnType   return type
   * @return array setter
   */
  protected final MethodHandle getContinuousElementSetter(MethodHandle set, Class<?> returnType) {
    return getContinuousElementSetter(getClass(), set, returnType);
  }

  /**
   * Return element getter for a {@link ContinuousArrayData}
   * @param type        type for exact type guard
   * @param getHas       has getter
   * @param returnType   return type
   * @param programPoint program point
   * @return method handle for element setter
   */
  protected MethodHandle getContinuousElementGetter(Class<? extends ContinuousArrayData> type, MethodHandle getHas, Class<?> returnType, int programPoint) {
    var isOptimistic = isValid(programPoint);
    var fti = getAccessorTypeIndex(getHas.type().returnType());
    var ti = getAccessorTypeIndex(returnType);
    var mh = getHas;
    if (isOptimistic) {
      if (ti < fti) {
        mh = MH.insertArguments(ArrayData.THROW_UNWARRANTED.methodHandle(), 1, programPoint);
      }
    }
    mh = MH.asType(mh, mh.type().changeReturnType(returnType).changeParameterType(0, type));
    if (!isOptimistic) {
      //for example a & array[17];
      return Lookup.filterReturnType(mh, returnType);
    }
    return mh;
  }

  /**
   * Return element setter for a {@link ContinuousArrayData}
   * @param type        class for exact type guard
   * @param setHas       set has guard
   * @param elementType  element type
   * @return method handle for element setter
   */
  protected MethodHandle getContinuousElementSetter(Class<? extends ContinuousArrayData> type, MethodHandle setHas, Class<?> elementType) {
    return MH.asType(setHas, setHas.type().changeParameterType(2, elementType).changeParameterType(0, type));
  }

  // Fast access guard - it is impractical for JIT performance reasons to use only CCE asType as guard :-(, also we need the null case explicitly, which is the one that CCE doesn't handle
  protected static final MethodHandle FAST_ACCESS_GUARD =
    MH.dropArguments(staticCall(MethodHandles.lookup(), ContinuousArrayData.class, "guard", boolean.class, Class.class, ScriptObject.class).methodHandle(), 2, int.class);

  @SuppressWarnings("unused")
  static boolean guard(Class<? extends ContinuousArrayData> type, ScriptObject sobj) {
    return sobj != null && sobj.getArray().getClass() == type;
  }

  /**
   * Return a fast linked array getter, or null if we have to dispatch to super class
   * @param desc     descriptor
   * @param request  link request
   * @return invocation or null if needs to be sent to slow relink
   */
  @Override
  public GuardedInvocation findFastGetIndexMethod(Class<? extends ArrayData> type, CallSiteDescriptor desc, LinkRequest request) {
    var callType = desc.getMethodType();
    var indexType = callType.parameterType(1);
    var returnType = callType.returnType();
    if (ContinuousArrayData.class.isAssignableFrom(type) && indexType == int.class) {
      var args = request.getArguments();
      var index = (int) args[args.length - 1];
      if (has(index)) {
        var getArray = ScriptObject.GET_ARRAY.methodHandle();
        var programPoint = NashornCallSiteDescriptor.isOptimistic(desc) ? NashornCallSiteDescriptor.getProgramPoint(desc) : INVALID_PROGRAM_POINT;
        var getElement = getElementGetter(returnType, programPoint);
        if (getElement != null) {
          getElement = MH.filterArguments(getElement, 0, MH.asType(getArray, getArray.type().changeReturnType(type)));
          var guard = MH.insertArguments(FAST_ACCESS_GUARD, 0, type);
          return new GuardedInvocation(getElement, guard, (SwitchPoint) null, ClassCastException.class);
        }
      }
    }
    return null;
  }

  /**
   * Return a fast linked array setter, or null if we have to dispatch to super class
   * @param desc     descriptor
   * @param request  link request
   * @return invocation or null if needs to be sent to slow relink
   */
  @Override
  public GuardedInvocation findFastSetIndexMethod(Class<? extends ArrayData> type, CallSiteDescriptor desc, LinkRequest request) { // array, index, value
    var callType = desc.getMethodType();
    var indexType = callType.parameterType(1);
    var elementType = callType.parameterType(2);
    if (ContinuousArrayData.class.isAssignableFrom(type) && indexType == int.class) {
      var args = request.getArguments();
      var index = (int) args[args.length - 2];
      if (hasRoomFor(index)) {
        var setElement = getElementSetter(elementType); // Z(continuousarraydata, int, int), return true if successful
        if (setElement != null) {
          // else we are dealing with a wider type than supported by this callsite
          var getArray = ScriptObject.GET_ARRAY.methodHandle();
          getArray = MH.asType(getArray, getArray.type().changeReturnType(getClass()));
          setElement = MH.filterArguments(setElement, 0, getArray);
          var guard = MH.insertArguments(FAST_ACCESS_GUARD, 0, type);
          return new GuardedInvocation(setElement, guard, (SwitchPoint) null, ClassCastException.class); //CCE if not a scriptObject anymore
        }
      }
    }

    return null;
  }

  /**
   * Specialization - fast push implementation
   * @param arg argument
   * @return new array length
   */
  public double fastPush(int arg) {
    throw new ClassCastException(String.valueOf(getClass())); //type is wrong, relink
  }

  /**
   * Specialization - fast push implementation
   * @param arg argument
   * @return new array length
   */
  public double fastPush(long arg) {
    throw new ClassCastException(String.valueOf(getClass())); //type is wrong, relink
  }

  /**
   * Specialization - fast push implementation
   * @param arg argument
   * @return new array length
   */
  public double fastPush(double arg) {
    throw new ClassCastException(String.valueOf(getClass())); //type is wrong, relink
  }

  /**
   * Specialization - fast push implementation
   * @param arg argument
   * @return new array length
   */
  public double fastPush(Object arg) {
    throw new ClassCastException(String.valueOf(getClass())); //type is wrong, relink
  }

  /**
   * Specialization - fast pop implementation
   * @return element value
   */
  public int fastPopInt() {
    throw new ClassCastException(String.valueOf(getClass())); //type is wrong, relink
  }

  /**
   * Specialization - fast pop implementation
   * @return element value
   */
  public double fastPopDouble() {
    throw new ClassCastException(String.valueOf(getClass())); //type is wrong, relink
  }

  /**
   * Specialization - fast pop implementation
   * @return element value
   */
  public Object fastPopObject() {
    throw new ClassCastException(String.valueOf(getClass())); //type is wrong, relink
  }

  /**
   * Specialization - fast concat implementation
   * @param otherData data to concat
   * @return new arraydata
   */
  public ContinuousArrayData fastConcat(ContinuousArrayData otherData) {
    throw new ClassCastException(String.valueOf(getClass()) + " != " + String.valueOf(otherData.getClass()));
  }

}
