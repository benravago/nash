package es.runtime.linker;

import java.lang.invoke.MethodHandle;

/**
 * A tuple of method handles, one for dynamically getting function as a property of an object, and another for invoking a function with a given signature.
 *
 * A typical use for this class is to create method handles that can be used to efficiently recreate dynamic invocation of a method on an object from Java code.
 * E.g. if you would have a call site in JavaScript that says
 * <pre>
 *     value = obj.toJSON(key)
 * </pre>
 * then the efficient way to code an exact equivalent of this in Java would be:
 * <pre>
 *     private static final InvokeByName TO_JSON = new InvokeByName("toJSON", Object.class, Object.class, Object.class);
 *     ...
 *     final Object toJSONFn = TO_JSON.getGetter().invokeExact(obj);
 *     value = TO_JSON.getInvoker().invokeExact(toJSONFn, obj, key);
 * </pre>
 * In practice, you can have stronger type assumptions if it makes sense for your code, just remember that you must use the same parameter types as the formal types of the arguments for {@code invokeExact} to work:
 * <pre>
 *     private static final InvokeByName TO_JSON = new InvokeByName("toJSON", ScriptObject.class, Object.class, Object.class);
 *     ...
 *     final ScriptObject sobj = (ScriptObject)obj;
 *     final Object toJSONFn = TO_JSON.getGetter().invokeExact(sobj);
 *     if(toJSONFn instanceof ScriptFunction) {
 *         value = TO_JSON.getInvoker().invokeExact(toJSONFn, sobj, key);
 *     }
 * </pre>
 * Note that in general you will not want to reuse a single instance of this class for implementing more than one call site - that would increase the risk of them becoming megamorphic or otherwise hard to optimize by the JVM.
 * Even if you dynamically invoke a function with the same name from multiple places in your code, it is advisable to create a separate instance of this class for every place.
 */
public final class InvokeByName {

  private final String name;
  private final MethodHandle getter;
  private final MethodHandle invoker;

  /**
   * Creates a getter and invoker for a function of the given name that takes no arguments and has a return type of {@code Object}.
   * @param name the name of the function
   * @param targetClass the target class it is invoked on; e.g. {@code Object} or {@code ScriptObject}.
   */
  public InvokeByName(String name, Class<?> targetClass) {
    this(name, targetClass, Object.class);
  }

  /**
   * Creates a getter and invoker for a function of the given name with given parameter types and a given return type of {@code Object}.
   * @param name the name of the function
   * @param targetClass the target class it is invoked on; e.g. {@code Object} or {@code ScriptObject}.
   * @param rtype the return type of the function
   * @param ptypes the parameter types of the function.
   */
  public InvokeByName(String name, Class<?> targetClass, Class<?> rtype, Class<?>... ptypes) {
    this.name = name;
    getter = Bootstrap.createDynamicInvoker(name, NashornCallSiteDescriptor.GET_METHOD_PROPERTY, Object.class, targetClass);
    Class<?>[] finalPtypes;
    var plength = ptypes.length;
    if (plength == 0) {
      finalPtypes = new Class<?>[]{Object.class, targetClass};
    } else {
      finalPtypes = new Class<?>[plength + 2];
      finalPtypes[0] = Object.class;
      finalPtypes[1] = targetClass;
      System.arraycopy(ptypes, 0, finalPtypes, 2, plength);
    }
    invoker = Bootstrap.createDynamicCallInvoker(rtype, finalPtypes);
  }

  /**
   * Returns the name of the function retrieved through this invoker.
   * @return the name of the function retrieved through this invoker.
   */
  public String getName() {
    return name;
  }

  /**
   * Returns the property getter that can be invoked on an object to retrieve the function object that will be subsequently invoked by the invoker returned by {@link #getInvoker()}.
   * @return the property getter method handle for the function.
   */
  public MethodHandle getGetter() {
    return getter;
  }

  /**
   * Returns the function invoker that can be used to invoke a function object previously retrieved by invoking the getter retrieved with {@link #getGetter()} on the target object.
   * @return the invoker method handle for the function.
   */
  public MethodHandle getInvoker() {
    return invoker;
  }

}
