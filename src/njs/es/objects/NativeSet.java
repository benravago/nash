package es.objects;

import java.lang.invoke.MethodHandle;

import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.Getter;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.Where;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.Undefined;
import es.runtime.linker.Bootstrap;
import static es.objects.NativeMap.convertKey;
import static es.runtime.ECMAErrors.typeError;

/**
 * This implements the ECMA6 Set object.
 */
@ScriptClass("Set")
public class NativeSet extends ScriptObject {

  // our set/map implementation
  private final LinkedMap map = new LinkedMap();

  // Invoker for the forEach callback
  private final static Object FOREACH_INVOKER_KEY = new Object();

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  NativeSet(ScriptObject proto, PropertyMap map) {
    super(proto, map);
  }

  /**
   * ECMA6 23.1 Set constructor
   * @param isNew  whether the new operator used
   * @param self self reference
   * @param arg optional iterable argument
   * @return a new Set object
   */
  @Constructor(arity = 0)
  public static Object construct(boolean isNew, Object self, Object arg) {
    if (!isNew) {
      throw typeError("constructor.requires.new", "Set");
    }
    var global = Global.instance();
    var set = new NativeSet(global.getSetPrototype(), $nasgenmap$);
    populateSet(set.getJavaMap(), arg, global);
    return set;
  }

  /**
   * ECMA6 23.2.3.1 Set.prototype.add ( value )
   * @param self the self reference
   * @param value the value to add
   * @return this Set object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object add(Object self, Object value) {
    getNativeSet(self).map.set(convertKey(value), null);
    return self;
  }

  /**
   * ECMA6 23.2.3.7 Set.prototype.has ( value )
   * @param self the self reference
   * @param value the value
   * @return true if value is contained
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean has(Object self, Object value) {
    return getNativeSet(self).map.has(convertKey(value));
  }

  /**
   * ECMA6 23.2.3.2 Set.prototype.clear ( )
   * @param self the self reference
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static void clear(Object self) {
    getNativeSet(self).map.clear();
  }

  /**
   * ECMA6 23.2.3.4 Set.prototype.delete ( value )
   * @param self the self reference
   * @param value the value
   * @return true if value was deleted
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean delete(Object self, Object value) {
    return getNativeSet(self).map.delete(convertKey(value));
  }

  /**
   * ECMA6 23.2.3.9 get Set.prototype.size
   * @param self the self reference
   * @return the number of contained values
   */
  @Getter(attributes = Attribute.NOT_ENUMERABLE | Attribute.IS_ACCESSOR, where = Where.PROTOTYPE)
  public static int size(Object self) {
    return getNativeSet(self).map.size();
  }

  /**
   * ECMA6 23.2.3.5 Set.prototype.entries ( )
   * @param self the self reference
   * @return an iterator over the Set object's entries
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object entries(Object self) {
    return new SetIterator(getNativeSet(self), AbstractIterator.IterationKind.KEY_VALUE, Global.instance());
  }

  /**
   * ECMA6 23.2.3.8 Set.prototype.keys ( )
   * @param self the self reference
   * @return an iterator over the Set object's values
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object keys(Object self) {
    return new SetIterator(getNativeSet(self), AbstractIterator.IterationKind.KEY, Global.instance());
  }

  /**
   * ECMA6 23.2.3.10 Set.prototype.values ( )
   * @param self the self reference
   * @return an iterator over the Set object's values
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object values(Object self) {
    return new SetIterator(getNativeSet(self), AbstractIterator.IterationKind.VALUE, Global.instance());
  }

  /**
   * ECMA6 23.2.3.11 Set.prototype [ @@iterator ] ( )
   * @param self the self reference
   * @return an iterator over the Set object's values
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, name = "@@iterator")
  public static Object getIterator(Object self) {
    return new SetIterator(getNativeSet(self), AbstractIterator.IterationKind.VALUE, Global.instance());
  }

  /**
   * ECMA6 23.2.3.6 Set.prototype.forEach ( callbackfn [ , thisArg ] )
   * @param self the self reference
   * @param callbackFn the callback function
   * @param thisArg optional this object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static void forEach(Object self, Object callbackFn, Object thisArg) {
    var set = getNativeSet(self);
    if (!Bootstrap.isCallable(callbackFn)) {
      throw typeError("not.a.function", ScriptRuntime.safeToString(callbackFn));
    }
    var invoker = Global.instance().getDynamicInvoker(FOREACH_INVOKER_KEY, () -> Bootstrap.createDynamicCallInvoker(Object.class, Object.class, Object.class, Object.class, Object.class, Object.class));
    var iterator = set.getJavaMap().getIterator();
    for (;;) {
      var node = iterator.next();
      if (node == null) {
        break;
      }
      try {
        var result = invoker.invokeExact(callbackFn, thisArg, node.getKey(), node.getKey(), self);
      } catch (RuntimeException | Error e) {
        throw e;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  @Override
  public String getClassName() {
    return "Set";
  }

  static void populateSet(LinkedMap map, Object arg, Global global) {
    if (arg != null && arg != Undefined.getUndefined()) {
      AbstractIterator.iterate(arg, global, value -> map.set(convertKey(value), null));
    }
  }

  LinkedMap getJavaMap() {
    return map;
  }

  static NativeSet getNativeSet(Object self) {
    if (self instanceof NativeSet ns) {
      return ns;
    } else {
      throw typeError("not.a.set", ScriptRuntime.safeToString(self));
    }
  }

}
