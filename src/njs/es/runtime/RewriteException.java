package es.runtime;

import java.util.Arrays;

import java.io.NotSerializableException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import java.lang.invoke.CallSite;
import java.lang.invoke.ConstantCallSite;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodHandles.Lookup;
import java.lang.invoke.MethodType;
import java.lang.reflect.Array;

import es.codegen.CompilerConstants;
import es.codegen.CompilerConstants.Call;
import es.codegen.types.Type;
import es.lookup.MethodHandleFactory;
import es.lookup.MethodHandleFunctionality;
import es.objects.Global;
import static es.codegen.CompilerConstants.*;

/**
 * Used to signal to the linker to relink the callee
 */
public final class RewriteException extends Exception {

  private static final MethodHandleFunctionality MH = MethodHandleFactory.getFunctionality();

  // Runtime scope in effect at the time of the compilation. Used to evaluate types of expressions and prevent overly
  // optimistic assumptions (which will lead to unnecessary deoptimizing recompilations).
  private ScriptObject runtimeScope;

  // Contents of bytecode slots
  private Object[] byteCodeSlots;

  private final int[] previousContinuationEntryPoints;

  /** Call for getting the contents of the bytecode slots in the exception */
  public static final Call GET_BYTECODE_SLOTS = virtualCallNoLookup(RewriteException.class, "getByteCodeSlots", Object[].class);
  /** Call for getting the program point in the exception */
  public static final Call GET_PROGRAM_POINT = virtualCallNoLookup(RewriteException.class, "getProgramPoint", int.class);
  /** Call for getting the return value for the exception */
  public static final Call GET_RETURN_VALUE = virtualCallNoLookup(RewriteException.class, "getReturnValueDestructive", Object.class);
  /** Call for the populate array bootstrap */
  public static final Call BOOTSTRAP = staticCallNoLookup(RewriteException.class, "populateArrayBootstrap", CallSite.class, Lookup.class, String.class, MethodType.class, int.class);

  /** Call for populating an array with local variable state */
  private static final Call POPULATE_ARRAY = staticCall(MethodHandles.lookup(), RewriteException.class, "populateArray", Object[].class, Object[].class, int.class, Object[].class);

  /** Call for converting an array to a long array. */
  public static final Call TO_LONG_ARRAY = staticCallNoLookup(RewriteException.class, "toLongArray", long[].class, Object.class, RewriteException.class);
  /** Call for converting an array to a double array. */
  public static final Call TO_DOUBLE_ARRAY = staticCallNoLookup(RewriteException.class, "toDoubleArray", double[].class, Object.class, RewriteException.class);
  /** Call for converting an array to an object array. */
  public static final Call TO_OBJECT_ARRAY = staticCallNoLookup(RewriteException.class, "toObjectArray", Object[].class, Object.class, RewriteException.class);
  /** Call for converting an object to null if it can't be represented as an instance of a class. */
  public static final Call INSTANCE_OR_NULL = staticCallNoLookup(RewriteException.class, "instanceOrNull", Object.class, Object.class, Class.class);
  /** Call for asserting the length of an array. */
  public static final Call ASSERT_ARRAY_LENGTH = staticCallNoLookup(RewriteException.class, "assertArrayLength", void.class, Object[].class, int.class);

  RewriteException(UnwarrantedOptimismException e, Object[] byteCodeSlots, String[] byteCodeSymbolNames, int[] previousContinuationEntryPoints) {
    super("", e, false, false);
    this.byteCodeSlots = byteCodeSlots;
    this.runtimeScope = mergeSlotsWithScope(byteCodeSlots, byteCodeSymbolNames);
    this.previousContinuationEntryPoints = previousContinuationEntryPoints;
  }

  /**
   * Constructor for a rewrite exception thrown from an optimistic function.
   * @param e the {@link UnwarrantedOptimismException} that triggered this exception.
   * @param byteCodeSlots contents of local variable slots at the time of rewrite at the program point @param byteCodeSymbolNames the names of the variables in the {@code byteCodeSlots} parameter. The array might have less elements, and some elements might be unnamed (the name can be null). The information is provided in an effort to assist evaluation of expressions for their types by the compiler doing the deoptimizing recompilation, and can thus be incomplete - the more complete it is, the more expressions can be evaluated by the compiler, and the more unnecessary deoptimizing compilations can be avoided.
   * @return a new rewrite exception
   */
  public static RewriteException create(UnwarrantedOptimismException e, Object[] byteCodeSlots, String[] byteCodeSymbolNames) {
    return create(e, byteCodeSlots, byteCodeSymbolNames, null);
  }

  /**
   * Constructor for a rewrite exception thrown from a rest-of method.
   * @param e the {@link UnwarrantedOptimismException} that triggered this exception.
   * @param byteCodeSlots contents of local variable slots at the time of rewrite at the program point
   * @param byteCodeSymbolNames the names of the variables in the {@code byteCodeSlots} parameter. The array might have less elements, and some elements might be unnamed (the name can be null). The information is provided in an effort to assist evaluation of expressions for their types by the compiler doing the deoptimizing recompilation, and can thus be incomplete - the more complete it is, the more expressions can be evaluated by the compiler, and the more unnecessary deoptimizing compilations can be avoided.
   * @param previousContinuationEntryPoints an array of continuation entry points that were already executed during one logical invocation of the function (a rest-of triggering a rest-of triggering a...)
   * @return a new rewrite exception
   */
  public static RewriteException create(UnwarrantedOptimismException e, Object[] byteCodeSlots, String[] byteCodeSymbolNames, int[] previousContinuationEntryPoints) {
    return new RewriteException(e, byteCodeSlots, byteCodeSymbolNames, previousContinuationEntryPoints);
  }

  /**
   * Bootstrap method for populate array
   * @param lookup     lookup
   * @param name       name (ignored)
   * @param type       method type for signature
   * @param startIndex start index to start writing to
   * @return callsite to array populator (constant)
   */
  public static CallSite populateArrayBootstrap(MethodHandles.Lookup lookup, String name, MethodType type, int startIndex) {
    var mh = POPULATE_ARRAY.methodHandle();
    mh = MH.insertArguments(mh, 1, startIndex);
    mh = MH.asCollector(mh, Object[].class, type.parameterCount() - 1);
    mh = MH.asType(mh, type);
    return new ConstantCallSite(mh);
  }

  static ScriptObject mergeSlotsWithScope(Object[] byteCodeSlots, String[] byteCodeSymbolNames) {
    var locals = Global.newEmptyInstance();
    var l = Math.min(byteCodeSlots.length, byteCodeSymbolNames.length);
    ScriptObject runtimeScope = null;
    var scopeName = CompilerConstants.SCOPE.symbolName();
    for (var i = 0; i < l; ++i) {
      var name = byteCodeSymbolNames[i];
      var value = byteCodeSlots[i];
      if (scopeName.equals(name)) {
        assert runtimeScope == null;
        runtimeScope = (ScriptObject) value;
      } else if (name != null) {
        locals.set(name, value, 0);
      }
    }
    locals.setProto(runtimeScope);
    return locals;
  }

  /**
   * Array populator used for saving the local variable state into the array contained in the RewriteException
   * @param arrayToBePopluated array to be populated
   * @param startIndex start index to write to
   * @param items items with which to populate the array
   * @return the populated array - same array object
   */
  public static Object[] populateArray(Object[] arrayToBePopluated, int startIndex, Object[] items) {
    System.arraycopy(items, 0, arrayToBePopluated, startIndex, items.length);
    return arrayToBePopluated;
  }

  /**
   * Continuation handler calls this method when a local variable carried over into the continuation is expected to be a long array in the continued method.
   * Normally, it will also be a long array in the original (interrupted by deoptimization) method, but it can actually be an int array that underwent widening in the new code version.
   * @param obj the object that has to be converted into a long array
   * @param e the exception being processed
   * @return a long array
   */
  public static long[] toLongArray(Object obj, RewriteException e) {
    if (obj instanceof long[] l) {
      return l;
    }
    assert obj instanceof int[];
    var in = (int[]) obj;
    var out = new long[in.length];
    for (var i = 0; i < in.length; ++i) {
      out[i] = in[i];
    }
    return e.replaceByteCodeValue(in, out);
  }

  /**
   * Continuation handler calls this method when a local variable carried over into the continuation is expected to be a double array in the continued method.
   * Normally, it will also be a double array in the original (interrupted by deoptimization) method, but it can actually be an int or long array that underwent widening in the new code version.
   * @param obj the object that has to be converted into a double array
   * @param e the exception being processed
   * @return a double array
   */
  public static double[] toDoubleArray(Object obj, RewriteException e) {
    if (obj instanceof double[] d) {
      return d;
    }
    assert obj instanceof int[] || obj instanceof long[];
    var l = Array.getLength(obj);
    var out = new double[l];
    for (var i = 0; i < l; ++i) {
      out[i] = Array.getDouble(obj, i);
    }
    return e.replaceByteCodeValue(obj, out);
  }

  /**
   * Continuation handler calls this method when a local variable carried over into the continuation is expected to be an Object array in the continued method.
   * Normally, it will also be an Object array in the original (interrupted by deoptimization) method, but it can actually be an int, long, or double array that underwent widening in the new code version.
   * @param obj the object that has to be converted into an Object array
   * @param e the exception being processed
   * @return an Object array
   */
  public static Object[] toObjectArray(Object obj, RewriteException e) {
    if (obj instanceof Object[] o) {
      return o;
    }
    assert obj instanceof int[] || obj instanceof long[] || obj instanceof double[] : obj + " is " + obj.getClass().getName();
    var l = Array.getLength(obj);
    var out = new Object[l];
    for (var i = 0; i < l; ++i) {
      out[i] = Array.get(obj, i);
    }
    return e.replaceByteCodeValue(obj, out);
  }

  /**
   * Continuation handler calls this method when a local variable carried over into the continuation is expected to have a certain type, but the value can have a different type coming from the deoptimized method as it was a dead store.
   * If we had precise liveness analysis, we wouldn't need this.
   * @param obj the object inspected for being of a particular type
   * @param type the type the object must belong to
   * @return the object if it belongs to the type, or null otherwise
   */
  public static Object instanceOrNull(Object obj, Class<?> type) {
    return type.isInstance(obj) ? obj : null;
  }

  /**
   * Asserts the length of an array.
   * Invoked from continuation handler only when running with assertions enabled.
   * The array can, in fact, have more elements than asserted, but they must all have Undefined as their value.
   * The method does not test for the array having less elements than asserted, as those would already have caused an {@code ArrayIndexOutOfBoundsException} to be thrown as the continuation handler attempts to access the missing elements.
   * @param arr the array
   * @param length the asserted length
   */
  public static void assertArrayLength(Object[] arr, int length) {
    for (var i = arr.length; i-- > length;) {
      if (arr[i] != ScriptRuntime.UNDEFINED) {
        throw new AssertionError(String.format("Expected array length %d, but it is %d", length, i + 1));
      }
    }
  }

  <T> T replaceByteCodeValue(Object in, T out) {
    for (var i = 0; i < byteCodeSlots.length; ++i) {
      if (byteCodeSlots[i] == in) {
        byteCodeSlots[i] = out;
      }
    }
    return out;
  }

  UnwarrantedOptimismException getUOE() {
    return (UnwarrantedOptimismException) getCause();
  }

  /**
   * Get return value.
   * This method is destructive, after it is invoked subsequent invocation of either {@link #getByteCodeSlots()} or this method will return null.
   * This method is invoked from the generated continuation code as the last step before continuing the execution, and we need to make sure we don't hang on to either the entry bytecode slot values or the return value and prevent them from being garbage collected.
   * @return return value
   */
  public Object getReturnValueDestructive() {
    assert byteCodeSlots != null;
    byteCodeSlots = null;
    runtimeScope = null;
    return getUOE().getReturnValueDestructive();
  }

  Object getReturnValueNonDestructive() {
    return getUOE().getReturnValueNonDestructive();
  }

  /**
   * Get return type
   * @return return type
   */
  public Type getReturnType() {
    return getUOE().getReturnType();
  }

  /**
   * Get the program point.
   * @return program point.
   */
  public int getProgramPoint() {
    return getUOE().getProgramPoint();
  }

  /**
   * Get the bytecode slot contents.
   * @return bytecode slot contents.
   */
  public Object[] getByteCodeSlots() {
    return byteCodeSlots == null ? null : byteCodeSlots.clone();
  }

  /**
   * @return an array of continuation entry points that were already executed during one logical invocation of the
   * function (a rest-of triggering a rest-of triggering a...)
   */
  public int[] getPreviousContinuationEntryPoints() {
    return previousContinuationEntryPoints == null ? null : previousContinuationEntryPoints.clone();
  }

  /**
   * Returns the runtime scope that was in effect when the exception was thrown.
   * @return the runtime scope.
   */
  public ScriptObject getRuntimeScope() {
    return runtimeScope;
  }

  private static String stringify(Object returnValue) {
    if (returnValue == null) {
      return "null";
    }
    var str = returnValue.toString();
    if (returnValue instanceof String) {
      str = '\'' + str + '\'';
    } else if (returnValue instanceof Double) {
      str += 'd';
    } else if (returnValue instanceof Long) {
      str += 'l';
    }
    return str;
  }

  @Override
  public String getMessage() {
    return getMessage(false);
  }

  /**
   * Short toString function for message
   * @return short message
   */
  public String getMessageShort() {
    return getMessage(true);
  }

  private String getMessage(boolean isShort) {
    var sb = new StringBuilder();
    // program point
    sb.append("[pp=").append(getProgramPoint()).append(", ");
    //slot contents
    if (!isShort) {
      var slots = byteCodeSlots;
      if (slots != null) {
        sb.append("slots=").append(Arrays.asList(slots)).append(", ");
      }
    }
    //return type
    sb.append("type=").append(getReturnType()).append(", ");
    //return value
    sb.append("value=").append(stringify(getReturnValueNonDestructive())).append(")]");
    return sb.toString();
  }

  private void writeObject(ObjectOutputStream out) throws NotSerializableException {
    throw new NotSerializableException(getClass().getName());
  }
  private void readObject(ObjectInputStream in) throws NotSerializableException {
    throw new NotSerializableException(getClass().getName());
  }
}
