package es.runtime;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.support.TypeUtilities;

import es.codegen.types.Type;
import es.runtime.linker.NashornCallSiteDescriptor;
import static es.lookup.Lookup.MH;
import static es.runtime.JSType.getAccessorTypeIndex;
import static es.runtime.UnwarrantedOptimismException.isValid;

/**
 * Optimistic return value filters
 */
public final class OptimisticReturnFilters {

  private static final MethodHandle[] ENSURE_INT;
  private static final MethodHandle[] ENSURE_NUMBER;

  // These extend the type index constants in JSType
  private static final int VOID_TYPE_INDEX;
  private static final int BOOLEAN_TYPE_INDEX;
  private static final int CHAR_TYPE_INDEX;
  private static final int LONG_TYPE_INDEX;
  private static final int FLOAT_TYPE_INDEX;

  static /*<init>*/ {
    var INT_DOUBLE = findOwnMH("ensureInt", int.class, double.class, int.class);
    ENSURE_INT = new MethodHandle[] {
      null,
      INT_DOUBLE,
      findOwnMH("ensureInt", int.class, Object.class, int.class),
      findOwnMH("ensureInt", int.class, int.class),
      findOwnMH("ensureInt", int.class, boolean.class, int.class),
      findOwnMH("ensureInt", int.class, char.class, int.class),
      findOwnMH("ensureInt", int.class, long.class, int.class),
      INT_DOUBLE.asType(INT_DOUBLE.type().changeParameterType(0, float.class))
    };

    VOID_TYPE_INDEX = ENSURE_INT.length - 5;
    BOOLEAN_TYPE_INDEX = ENSURE_INT.length - 4;
    CHAR_TYPE_INDEX = ENSURE_INT.length - 3;
    LONG_TYPE_INDEX = ENSURE_INT.length - 2;
    FLOAT_TYPE_INDEX = ENSURE_INT.length - 1;

    ENSURE_NUMBER = new MethodHandle[] {
      null,
      null,
      findOwnMH("ensureNumber", double.class, Object.class, int.class),
      ENSURE_INT[VOID_TYPE_INDEX].asType(ENSURE_INT[VOID_TYPE_INDEX].type().changeReturnType(double.class)),
      ENSURE_INT[BOOLEAN_TYPE_INDEX].asType(ENSURE_INT[BOOLEAN_TYPE_INDEX].type().changeReturnType(double.class)),
      ENSURE_INT[CHAR_TYPE_INDEX].asType(ENSURE_INT[CHAR_TYPE_INDEX].type().changeReturnType(double.class)),
      findOwnMH("ensureNumber", double.class, long.class, int.class),
      null
    };
  }

  /**
   * Given a method handle and an expected return type, perform return value filtering according to the optimistic type coercion rules
   * @param mh method handle
   * @param expectedReturnType expected return type
   * @param programPoint program point
   * @return filtered method
   */
  public static MethodHandle filterOptimisticReturnValue(MethodHandle mh, Class<?> expectedReturnType, int programPoint) {
    if (!isValid(programPoint)) {
      return mh;
    }
    var type = mh.type();
    var actualReturnType = type.returnType();
    if (TypeUtilities.isConvertibleWithoutLoss(actualReturnType, expectedReturnType)) {
      return mh;
    }
    var guard = getOptimisticTypeGuard(expectedReturnType, actualReturnType);
    return guard == null ? mh : MH.filterReturnValue(mh, MH.insertArguments(guard, guard.type().parameterCount() - 1, programPoint));
  }

  /**
   * Given a guarded invocation and a callsite descriptor, perform return value filtering according to the optimistic type coercion rules, using the return value from the descriptor
   * @param inv the invocation
   * @param desc the descriptor
   * @return filtered invocation
   */
  public static GuardedInvocation filterOptimisticReturnValue(GuardedInvocation inv, CallSiteDescriptor desc) {
    if (!NashornCallSiteDescriptor.isOptimistic(desc)) {
      return inv;
    }
    return inv.replaceMethods(filterOptimisticReturnValue(inv.getInvocation(), desc.getMethodType().returnType(), NashornCallSiteDescriptor.getProgramPoint(desc)), inv.getGuard());
  }

  static MethodHandle getOptimisticTypeGuard(Class<?> actual, Class<?> provable) {
    MethodHandle guard;
    var provableTypeIndex = getProvableTypeIndex(provable);
    if (actual == int.class) {
      guard = ENSURE_INT[provableTypeIndex];
    } else if (actual == double.class) {
      guard = ENSURE_NUMBER[provableTypeIndex];
    } else {
      guard = null;
      assert !actual.isPrimitive() : actual + ", " + provable;
    }
    if (guard != null && !(provable.isPrimitive())) {
      // Make sure filtering a MethodHandle(...)String works with a filter MethodHandle(Object, int)...
      // Note that if the return type of the method is incompatible with Number, then the guard will always throw an UnwarrantedOperationException when invoked, but we must link it anyway as we need the guarded function to successfully execute and return the non-convertible return value that it'll put into the thrown UnwarrantedOptimismException.
      return guard.asType(guard.type().changeParameterType(0, provable));
    }
    return guard;
  }

  static int getProvableTypeIndex(Class<?> provable) {
    var accTypeIndex = getAccessorTypeIndex(provable);
    if (accTypeIndex != -1) {
      return accTypeIndex;
    } else if (provable == boolean.class) {
      return BOOLEAN_TYPE_INDEX;
    } else if (provable == void.class) {
      return VOID_TYPE_INDEX;
    } else if (provable == byte.class || provable == short.class) {
      return 0; // never needs a guard, as it's assignable to int
    } else if (provable == char.class) {
      return CHAR_TYPE_INDEX;
    } else if (provable == long.class) {
      return LONG_TYPE_INDEX;
    } else if (provable == float.class) {
      return FLOAT_TYPE_INDEX;
    }
    throw new AssertionError(provable.getName());
  }

  //maps staticallyProvableCallSiteType to actualCallSiteType, throws exception if impossible
  @SuppressWarnings("unused")
  static int ensureInt(long arg, int programPoint) {
    if (JSType.isRepresentableAsInt(arg)) {
      return (int) arg;
    }
    throw UnwarrantedOptimismException.createNarrowest(arg, programPoint);
  }

  @SuppressWarnings("unused")
  static int ensureInt(double arg, int programPoint) {
    if (JSType.isNonNegativeZeroInt(arg)) {
      return (int) arg;
    }
    throw new UnwarrantedOptimismException(arg, programPoint, Type.NUMBER);
  }

  /**
   * Returns the argument value as an int.
   * If the argument is not a wrapper for a primitive numeric type with a value that can be exactly represented as an int, throw an {@link UnwarrantedOptimismException}.
   * This method is only public so that generated script code can use it. See {code CodeGenerator.ENSURE_INT}.
   * @param arg the original argument.
   * @param programPoint the program point used in the exception
   * @return the value of the argument as an int.
   * @throws UnwarrantedOptimismException if the argument is not a wrapper for a primitive numeric type with a value that can be exactly represented as an int.
   */
  public static int ensureInt(Object arg, int programPoint) {
    // NOTE: this doesn't delegate to ensureInt(double, int) as in that case if arg were a Long, it would throw a (potentially imprecise) Double in the UnwarrantedOptimismException.
    // This way, it will put the correct valued Long into the exception.
    if (isPrimitiveNumberWrapper(arg)) {
      var d = ((Number) arg).doubleValue();
      if (JSType.isNonNegativeZeroInt(d)) {
        return (int) d;
      }
    }
    throw UnwarrantedOptimismException.createNarrowest(arg, programPoint);
  }

  static boolean isPrimitiveNumberWrapper(Object obj) {
    if (obj == null) {
      return false;
    }
    var c = obj.getClass();
    return c == Integer.class || c == Double.class || c == Long.class || c == Float.class || c == Short.class || c == Byte.class;
  }

  @SuppressWarnings("unused")
  static int ensureInt(boolean arg, int programPoint) {
    throw new UnwarrantedOptimismException(arg, programPoint, Type.OBJECT);
  }

  @SuppressWarnings("unused")
  static int ensureInt(char arg, int programPoint) {
    throw new UnwarrantedOptimismException(arg, programPoint, Type.OBJECT);
  }

  @SuppressWarnings("unused")
  static int ensureInt(int programPoint) {
    // Turns a void into UNDEFINED
    throw new UnwarrantedOptimismException(ScriptRuntime.UNDEFINED, programPoint, Type.OBJECT);
  }

  @SuppressWarnings("unused")
  static double ensureNumber(long arg, int programPoint) {
    if (JSType.isRepresentableAsDouble(arg)) {
      return (double) arg;
    }
    throw new UnwarrantedOptimismException(arg, programPoint, Type.OBJECT);
  }

  /**
   * Returns the argument value as a double.
   * If the argument is not a wrapper for a primitive numeric type that can be represented as double throw an {@link UnwarrantedOptimismException}.
   * This method is only public so that generated script code can use it. See {code CodeGenerator.ENSURE_NUMBER}.
   * @param arg the original argument.
   * @param programPoint the program point used in the exception
   * @return the value of the argument as a double.
   * @throws UnwarrantedOptimismException if the argument is not a wrapper for a primitive numeric type.
   */
  public static double ensureNumber(Object arg, int programPoint) {
    if (isPrimitiveNumberWrapper(arg) && (arg.getClass() != Long.class || JSType.isRepresentableAsDouble((Long) arg))) {
      return ((Number) arg).doubleValue();
    }
    throw new UnwarrantedOptimismException(arg, programPoint, Type.OBJECT);
  }

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), OptimisticReturnFilters.class, name, MH.type(rtype, types));
  }

}
