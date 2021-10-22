package es.objects;

import java.util.function.Consumer;

import java.lang.invoke.MethodHandle;

import es.objects.annotations.Attribute;
import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.linker.Bootstrap;
import es.runtime.linker.InvokeByName;
import es.runtime.linker.NashornCallSiteDescriptor;
import static es.runtime.ECMAErrors.typeError;

/**
 * ECMA6 25.1.2 The %IteratorPrototype% Object
 */
@ScriptClass("Iterator")
public abstract class AbstractIterator extends ScriptObject {

  // initialized by nasgen
  static PropertyMap $nasgenmap$;

  private final static Object ITERATOR_INVOKER_KEY = new Object();
  private final static Object NEXT_INVOKER_KEY = new Object();
  private final static Object DONE_INVOKER_KEY = new Object();
  private final static Object VALUE_INVOKER_KEY = new Object();

  // ECMA6 iteration kinds
  enum IterationKind {
    /** key iteration */
    KEY,
    /** value iteration */
    VALUE,
    /** key+value iteration */
    KEY_VALUE
  }

  /**
   * Create an abstract iterator object with the given prototype and property map.
   * @param prototype the prototype
   * @param map the property map
   */
  protected AbstractIterator(ScriptObject prototype, PropertyMap map) {
    super(prototype, map);
  }

  /**
   * 25.1.2.1 %IteratorPrototype% [ @@iterator ] ( )
   * @param self the self object
   * @return this iterator
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, name = "@@iterator")
  public static Object getIterator(Object self) {
    return self;
  }

  @Override
  public String getClassName() {
    return "Iterator";
  }

  /**
   * ES6 25.1.1.2 The Iterator Interface
   * @param arg argument
   * @return next iterator result
   */
  protected abstract IteratorResult next(Object arg);

  /**
   * ES6 25.1.1.3 The IteratorResult Interface
   *
   * @param value result value
   * @param done result status
   * @param global the global object
   * @return result object
   */
  protected IteratorResult makeResult(Object value, Boolean done, Global global) {
    return new IteratorResult(value, done, global);
  }

  static MethodHandle getIteratorInvoker(Global global) {
    return global.getDynamicInvoker(ITERATOR_INVOKER_KEY, () -> Bootstrap.createDynamicCallInvoker(Object.class, Object.class, Object.class));
  }

  /**
   * Get the invoker for the ES6 iterator {@code next} method.
   * @param global the global object
   * @return the next invoker
   */
  public static InvokeByName getNextInvoker(Global global) {
    return global.getInvokeByName(AbstractIterator.NEXT_INVOKER_KEY, () -> new InvokeByName("next", Object.class, Object.class, Object.class));
  }

  /**
   * Get the invoker for the ES6 iterator result {@code done} property.
   * @param global the global object
   * @return the done invoker
   */
  public static MethodHandle getDoneInvoker(Global global) {
    return global.getDynamicInvoker(AbstractIterator.DONE_INVOKER_KEY, () -> Bootstrap.createDynamicInvoker("done", NashornCallSiteDescriptor.GET_PROPERTY, Object.class, Object.class));
  }

  /**
   * Get the invoker for the ES6 iterator result {@code value} property.
   * @param global the global object
   * @return the value invoker
   */
  public static MethodHandle getValueInvoker(Global global) {
    return global.getDynamicInvoker(AbstractIterator.VALUE_INVOKER_KEY, () -> Bootstrap.createDynamicInvoker("value", NashornCallSiteDescriptor.GET_PROPERTY, Object.class, Object.class));
  }

  /**
   * ES6 7.4.1 GetIterator abstract operation
   * @param iterable an object
   * @param global the global object
   * @return the iterator
   */
  public static Object getIterator(Object iterable, Global global) {
    var object = Global.toObject(iterable);
    if (object instanceof ScriptObject so) {
      // TODO: we need to implement fast property access for Symbol keys in order to use InvokeByName here.
      var getter = so.get(NativeSymbol.iterator);
      if (Bootstrap.isCallable(getter)) {
        try {
          var invoker = getIteratorInvoker(global);
          var value = invoker.invokeExact(getter, iterable);
          if (JSType.isPrimitive(value)) {
            throw typeError("not.an.object", ScriptRuntime.safeToString(value));
          }
          return value;
        } catch (Throwable t) {
          throw new RuntimeException(t);
        }
      }
      throw typeError("not.a.function", ScriptRuntime.safeToString(getter));
    }
    throw typeError("cannot.get.iterator", ScriptRuntime.safeToString(iterable));
  }

  /**
   * Iterate over an iterable object, passing every value to {@code consumer}.
   * @param iterable an iterable object
   * @param global the current global
   * @param consumer the value consumer
   */
  public static void iterate(Object iterable, Global global, Consumer<Object> consumer) {
    var iterator = AbstractIterator.getIterator(Global.toObject(iterable), global);
    var nextInvoker = getNextInvoker(global);
    var doneInvoker = getDoneInvoker(global);
    var valueInvoker = getValueInvoker(global);
    try {
      for (;;) {
        var next = nextInvoker.getGetter().invokeExact(iterator);
        if (!Bootstrap.isCallable(next)) {
          break;
        }
        var result = nextInvoker.getInvoker().invokeExact(next, iterator, (Object) null);
        if (!(result instanceof ScriptObject)) {
          break;
        }
        var done = doneInvoker.invokeExact(result);
        if (JSType.toBoolean(done)) {
          break;
        }
        consumer.accept(valueInvoker.invokeExact(result));
      }
    } catch (RuntimeException r) {
      throw r;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

}
