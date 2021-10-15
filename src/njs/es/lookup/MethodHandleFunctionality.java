package es.lookup;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.invoke.SwitchPoint;
import java.lang.reflect.Method;

import java.util.List;

/**
 * Wrapper for all method handle related functions used in Nashorn.

 * This interface only exists so that instrumentation can be added to all method handle operations.
 */
public interface MethodHandleFunctionality {

  /**
   * Wrapper for {@link MethodHandles#filterArguments(MethodHandle, int, MethodHandle...)}
   *
   * @param target  target method handle
   * @param pos     start argument index
   * @param filters filters
   *
   * @return filtered handle
   */
  MethodHandle filterArguments(MethodHandle target, int pos, MethodHandle... filters);

  /**
   * Wrapper for {@link MethodHandles#filterReturnValue(MethodHandle, MethodHandle)}
   *
   * @param target  target method handle
   * @param filter  filter
   *
   * @return filtered handle
   */
  MethodHandle filterReturnValue(MethodHandle target, MethodHandle filter);

  /**
   * Wrapper for {@link MethodHandles#guardWithTest(MethodHandle, MethodHandle, MethodHandle)}
   *
   * @param test     test method handle
   * @param target   target method handle when test is true
   * @param fallback fallback method handle when test is false
   *
   * @return guarded handles
   */
  MethodHandle guardWithTest(MethodHandle test, MethodHandle target, MethodHandle fallback);

  /**
   * Wrapper for {@link MethodHandles#insertArguments(MethodHandle, int, Object...)}
   *
   * @param target target method handle
   * @param pos    start argument index
   * @param values values to insert
   *
   * @return handle with bound arguments
   */
  MethodHandle insertArguments(MethodHandle target, int pos, Object... values);

  /**
   * Wrapper for {@link MethodHandles#dropArguments(MethodHandle, int, Class...)}
   *
   * @param target     target method handle
   * @param pos        start argument index
   * @param valueTypes valueTypes of arguments to drop
   *
   * @return handle with dropped arguments
   */
  MethodHandle dropArguments(MethodHandle target, int pos, Class<?>... valueTypes);

  /**
   * Wrapper for {@link MethodHandles#dropArguments(MethodHandle, int, List)}
   *
   * @param target     target method handle
   * @param pos        start argument index
   * @param valueTypes valueTypes of arguments to drop
   *
   * @return handle with dropped arguments
   */
  MethodHandle dropArguments(MethodHandle target, int pos, List<Class<?>> valueTypes);

  /**
   * Wrapper for {@link MethodHandles#foldArguments(MethodHandle, MethodHandle)}
   *
   * @param target   target method handle
   * @param combiner combiner to apply for fold
   *
   * @return folded method handle
   */
  MethodHandle foldArguments(MethodHandle target, MethodHandle combiner);

  /**
   * Wrapper for {@link MethodHandles#explicitCastArguments(MethodHandle, MethodType)}
   *
   * @param target  target method handle
   * @param type    type to cast to
   *
   * @return modified method handle
   */
  MethodHandle explicitCastArguments(MethodHandle target, MethodType type);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles#arrayElementGetter(Class)}
   *
   * @param arrayClass class for array
   *
   * @return array element getter
   */
  MethodHandle arrayElementGetter(Class<?> arrayClass);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles#arrayElementSetter(Class)}
   *
   * @param arrayClass class for array
   *
   * @return array element setter
   */
  MethodHandle arrayElementSetter(Class<?> arrayClass);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles#throwException(Class, Class)}
   *
   * @param returnType ignored, but method signature will use it
   * @param exType     exception type that will be thrown
   *
   * @return exception thrower method handle
   */
  MethodHandle throwException(Class<?> returnType, Class<? extends Throwable> exType);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles#catchException(MethodHandle, Class, MethodHandle)}
   *
   * @param target  target method
   * @param exType  exception type
   * @param handler the method handle to call when exception is thrown
   *
   * @return exception thrower method handle
   */
  MethodHandle catchException(MethodHandle target, Class<? extends Throwable> exType, MethodHandle handler);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles#constant(Class, Object)}
   *
   * @param type  type of constant
   * @param value constant value
   *
   * @return method handle that returns said constant
   */
  MethodHandle constant(Class<?> type, Object value);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles#identity(Class)}
   *
   * @param type  type of value
   *
   * @return method handle that returns identity argument
   */
  MethodHandle identity(Class<?> type);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandle#asType(MethodType)}
   *
   * @param handle  method handle for type conversion
   * @param type    type to convert to
   *
   * @return method handle with given type conversion applied
   */
  MethodHandle asType(MethodHandle handle, MethodType type);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandle#asCollector(Class, int)}
   *
   * @param handle      handle to convert
   * @param arrayType   array type for collector array
   * @param arrayLength length of collector array
   *
   * @return method handle with collector
   */
  MethodHandle asCollector(MethodHandle handle, Class<?> arrayType, int arrayLength);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandle#asSpreader(Class, int)}
   *
   * @param handle      handle to convert
   * @param arrayType   array type for spread
   * @param arrayLength length of spreader
   *
   * @return method handle as spreader
   */
  MethodHandle asSpreader(MethodHandle handle, Class<?> arrayType, int arrayLength);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandle#bindTo(Object)}
   *
   * @param handle a handle to which to bind a receiver
   * @param x      the receiver
   *
   * @return the bound handle
   */
  MethodHandle bindTo(MethodHandle handle, Object x);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles.Lookup#findGetter(Class, String, Class)}
   *
   * @param explicitLookup explicit lookup to be used
   * @param clazz          class to look in
   * @param name           name of field
   * @param type           type of field
   *
   * @return getter method handle for virtual field
   */
  MethodHandle getter(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, Class<?> type);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles.Lookup#findStaticGetter(Class, String, Class)}
   *
   * @param explicitLookup explicit lookup to be used
   * @param clazz          class to look in
   * @param name           name of field
   * @param type           type of field
   *
   * @return getter method handle for static field
   */
  MethodHandle staticGetter(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, Class<?> type);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles.Lookup#findSetter(Class, String, Class)}
   *
   * @param explicitLookup explicit lookup to be used
   * @param clazz          class to look in
   * @param name           name of field
   * @param type           type of field
   *
   * @return setter method handle for virtual field
   */
  MethodHandle setter(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, Class<?> type);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles.Lookup#findStaticSetter(Class, String, Class)}
   *
   * @param explicitLookup explicit lookup to be used
   * @param clazz          class to look in
   * @param name           name of field
   * @param type           type of field
   *
   * @return setter method handle for static field
   */
  MethodHandle staticSetter(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, Class<?> type);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles.Lookup#unreflect(Method)}
   *
   * Unreflect a method as a method handle
   *
   * @param method method to unreflect
   * @return unreflected method as method handle
   */
  MethodHandle find(Method method);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles.Lookup#findStatic(Class, String, MethodType)}
   *
   * @param explicitLookup explicit lookup to be used
   * @param clazz          class to look in
   * @param name           name of method
   * @param type           method type
   *
   * @return method handle for static method
   */
  MethodHandle findStatic(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, MethodType type);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles.Lookup#findVirtual(Class, String, MethodType)}
   *
   * @param explicitLookup explicit lookup to be used
   * @param clazz          class to look in
   * @param name           name of method
   * @param type           method type
   *
   * @return method handle for virtual method
   */
  MethodHandle findVirtual(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, MethodType type);

  /**
   * Wrapper for {@link java.lang.invoke.MethodHandles.Lookup#findSpecial(Class, String, MethodType, Class)}
   *
   * @param explicitLookup explicit lookup to be used
   * @param clazz          class to look in
   * @param name           name of method
   * @param type           method type
   * @param thisClass      thisClass
   *
   * @return method handle for virtual method
   */
  MethodHandle findSpecial(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, MethodType type, Class<?> thisClass);

  /**
   * Wrapper for SwitchPoint creation. Just like {@code new SwitchPoint()} but potentially
   * tracked
   *
   * @return new switch point
   */
  SwitchPoint createSwitchPoint();

  /**
   * Wrapper for {@link SwitchPoint#guardWithTest(MethodHandle, MethodHandle)}
   *
   * @param sp     switch point
   * @param before method handle when switchpoint is valid
   * @param after  method handle when switchpoint is invalidated
   *
   * @return guarded method handle
   */
  MethodHandle guardWithTest(SwitchPoint sp, MethodHandle before, MethodHandle after);

  /**
   * Wrapper for {@link MethodType#methodType(Class, Class...)}
   *
   * @param returnType  return type for method type
   * @param paramTypes  parameter types for method type
   *
   * @return the method type
   */
  MethodType type(Class<?> returnType, Class<?>... paramTypes);

}
