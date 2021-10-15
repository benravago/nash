package es.lookup;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import es.runtime.JSType;
import es.runtime.ScriptRuntime;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * MethodHandle Lookup management for Nashorn.
 */
public final class Lookup {

  /**
   * A global singleton that points to the {@link MethodHandleFunctionality}.
   *
   * This is basically a collection of wrappers to the standard methods in {@link MethodHandle},
   * {@link MethodHandles} and {@link java.lang.invoke.MethodHandles.Lookup},
   * but instrumentation and debugging purposes we need intercept points.
   * <p>
   * All method handle operations in Nashorn should go through this field,
   * not directly to the classes in {@code java.lang.invoke}
   */
  public static final MethodHandleFunctionality MH = MethodHandleFactory.getFunctionality();

  /** Method handle to the empty getter */
  public static final MethodHandle EMPTY_GETTER = findOwnMH("emptyGetter", Object.class, Object.class);

  /** Method handle to the empty setter */
  public static final MethodHandle EMPTY_SETTER = findOwnMH("emptySetter", void.class, Object.class, Object.class);

  /** Method handle to a getter or setter that only throws type error */
  public static final MethodHandle TYPE_ERROR_THROWER = findOwnMH("typeErrorThrower", Object.class, Object.class);

  /** Method handle to the most generic of getters, the one that returns an Object */
  public static final MethodType GET_OBJECT_TYPE = MH.type(Object.class, Object.class);

  /** Method handle to the most generic of setters, the one that takes an Object */
  public static final MethodType SET_OBJECT_TYPE = MH.type(void.class, Object.class, Object.class);

  /** Method handle to the primitive getters, the one that returns an long/int/double */
  public static final MethodType GET_PRIMITIVE_TYPE = MH.type(long.class, Object.class);

  /** Method handle to the primitive getters, the one that returns an long/int/double */
  public static final MethodType SET_PRIMITIVE_TYPE = MH.type(void.class, Object.class, long.class);

  /**
   * Empty getter implementation. Nop
   * @param self self reference
   * @return undefined
   */
  public static Object emptyGetter(Object self) {
    return UNDEFINED;
  }

  /**
   * Empty setter implementation. Nop
   * @param self  self reference
   * @param value value (ignored)
   */
  public static void emptySetter(Object self, Object value) {
    // do nothing!!
  }

  /**
   * Return a method handle to the empty getter, with a different return type value.
   * It will still be undefined cast to whatever return value property was specified
   *
   * @param type return value type
   * @return undefined as return value type
   */
  public static MethodHandle emptyGetter(Class<?> type) {
    return filterReturnType(EMPTY_GETTER, type);
  }

  /**
   * Getter function that always throws type error
   *
   * @param self  self reference
   * @return undefined (but throws error before return point)
   */
  public static Object typeErrorThrower(Object self) {
    throw typeError("getter.setter.poison", ScriptRuntime.safeToString(self));
  }

  /**
   * This method filters primitive argument types using JavaScript semantics.
   * For example, an (int) cast of a double in Java land is not the same thing as invoking toInt32 on it.
   * If you are returning values to JavaScript that have to be of a specific type,
   * this is the correct return value filter to use,
   * as the explicitCastArguments just uses the Java boxing equivalents
   *
   * @param mh   method handle for which to filter argument value
   * @param n    argument index
   * @param from old argument type, the new one is given by the sent method handle
   * @return method handle for appropriate argument type conversion
   */
  public static MethodHandle filterArgumentType(MethodHandle mh, int n, Class<?> from) {
    var to = mh.type().parameterType(n);

    if (from == int.class) {
      // fallthru
    } else if (from == long.class) {
      if (to == int.class) {
        return MH.filterArguments(mh, n, JSType.TO_INT32_L.methodHandle());
      }
      // fallthru
    } else if (from == double.class) {
      if (to == int.class) {
        return MH.filterArguments(mh, n, JSType.TO_INT32_D.methodHandle());
      } else if (to == long.class) {
        return MH.filterArguments(mh, n, JSType.TO_UINT32_D.methodHandle());
      }
      // fallthru
    } else if (!from.isPrimitive()) {
      if (to == int.class) {
        return MH.filterArguments(mh, n, JSType.TO_INT32.methodHandle());
      } else if (to == long.class) {
        return MH.filterArguments(mh, n, JSType.TO_UINT32.methodHandle());
      } else if (to == double.class) {
        return MH.filterArguments(mh, n, JSType.TO_NUMBER.methodHandle());
      } else if (!to.isPrimitive()) {
        return mh;
      }

      assert false : "unsupported Lookup.filterReturnType type " + from + " -> " + to;
    }

    // use a standard cast - we don't need to check JavaScript special cases
    return MH.explicitCastArguments(mh, mh.type().changeParameterType(n, from));
  }

  /**
   * This method filters primitive return types using JavaScript semantics.
   * For example, an (int) cast of a double in Java land is not the same thing as invoking toInt32 on it.
   * If you are returning values to JavaScript that have to be of a specific type,
   * this is the correct return value filter to use,
   * as the explicitCastArguments just uses the Java boxing equivalents
   *
   * @param mh   method handle for which to filter return value
   * @param type new return type
   * @return method handle for appropriate return type conversion
   */
  public static MethodHandle filterReturnType(MethodHandle mh, Class<?> type) {
    var retType = mh.type().returnType();

    if (retType == int.class) {
      // fallthru
    } else if (retType == long.class) {
      if (type == int.class) {
        return MH.filterReturnValue(mh, JSType.TO_INT32_L.methodHandle());
      }
      // fallthru
    } else if (retType == double.class) {
      if (type == int.class) {
        return MH.filterReturnValue(mh, JSType.TO_INT32_D.methodHandle());
      } else if (type == long.class) {
        return MH.filterReturnValue(mh, JSType.TO_UINT32_D.methodHandle());
      }
      // fallthru
    } else if (!retType.isPrimitive()) {
      if (type == int.class) {
        return MH.filterReturnValue(mh, JSType.TO_INT32.methodHandle());
      } else if (type == long.class) {
        return MH.filterReturnValue(mh, JSType.TO_UINT32.methodHandle());
      } else if (type == double.class) {
        return MH.filterReturnValue(mh, JSType.TO_NUMBER.methodHandle());
      } else if (!type.isPrimitive()) {
        return mh;
      }

      assert false : "unsupported Lookup.filterReturnType type " + retType + " -> " + type;
    }

    // use a standard cast - we don't need to check JavaScript special cases
    return MH.explicitCastArguments(mh, mh.type().changeReturnType(type));
  }

  static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), Lookup.class, name, MH.type(rtype, types));
  }

}
