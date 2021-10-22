package es.objects;

import java.lang.invoke.MethodHandle;

import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.Getter;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.Where;
import es.runtime.ConsString;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.Undefined;
import es.runtime.linker.Bootstrap;

import static es.runtime.ECMAErrors.typeError;

/**
 * This implements the ECMA6 Map object.
 */
@ScriptClass("Map")
public class NativeMap extends ScriptObject {

  // our underlying map
  private final LinkedMap map = new LinkedMap();

  // key for the forEach invoker callback
  private final static Object FOREACH_INVOKER_KEY = new Object();

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  NativeMap(ScriptObject proto, PropertyMap map) {
    super(proto, map);
  }

  /**
   * ECMA6 23.1.1 The Map Constructor
   * @param isNew is this called with the new operator?
   * @param self self reference
   * @param arg optional iterable argument
   * @return  a new Map instance
   */
  @Constructor(arity = 0)
  public static Object construct(boolean isNew, Object self, Object arg) {
    if (!isNew) {
      throw typeError("constructor.requires.new", "Map");
    }
    var global = Global.instance();
    var map = new NativeMap(global.getMapPrototype(), $nasgenmap$);
    populateMap(map.getJavaMap(), arg, global);
    return map;
  }

  /**
   * ECMA6 23.1.3.1 Map.prototype.clear ( )
   * @param self the self reference
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static void clear(Object self) {
    getNativeMap(self).map.clear();
  }

  /**
   * ECMA6 23.1.3.3 Map.prototype.delete ( key )
   * @param self the self reference
   * @param key the key to delete
   * @return true if the key was deleted
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean delete(Object self, Object key) {
    return getNativeMap(self).map.delete(convertKey(key));
  }

  /**
   * ECMA6 23.1.3.7 Map.prototype.has ( key )
   * @param self the self reference
   * @param key the key
   * @return true if key is contained
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean has(Object self, Object key) {
    return getNativeMap(self).map.has(convertKey(key));
  }

  /**
   * ECMA6 23.1.3.9 Map.prototype.set ( key , value )
   * @param self the self reference
   * @param key the key
   * @param value the value
   * @return this Map object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object set(Object self, Object key, Object value) {
    getNativeMap(self).map.set(convertKey(key), value);
    return self;
  }

  /**
   * ECMA6 23.1.3.6 Map.prototype.get ( key )
   * @param self the self reference
   * @param key the key
   * @return the associated value or undefined
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object get(Object self, Object key) {
    return getNativeMap(self).map.get(convertKey(key));
  }

  /**
   * ECMA6 23.1.3.10 get Map.prototype.size
   * @param self the self reference
   * @return the size of the map
   */
  @Getter(attributes = Attribute.NOT_ENUMERABLE | Attribute.IS_ACCESSOR, where = Where.PROTOTYPE)
  public static int size(Object self) {
    return getNativeMap(self).map.size();
  }

  /**
   * ECMA6 23.1.3.4 Map.prototype.entries ( )
   *
   * @param self the self reference
   * @return an iterator over the Map's entries
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object entries(Object self) {
    return new MapIterator(getNativeMap(self), AbstractIterator.IterationKind.KEY_VALUE, Global.instance());
  }

  /**
   * ECMA6 23.1.3.8 Map.prototype.keys ( )
   * @param self the self reference
   * @return an iterator over the Map's keys
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object keys(Object self) {
    return new MapIterator(getNativeMap(self), AbstractIterator.IterationKind.KEY, Global.instance());
  }

  /**
   * ECMA6 23.1.3.11 Map.prototype.values ( )
   * @param self the self reference
   * @return an iterator over the Map's values
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object values(Object self) {
    return new MapIterator(getNativeMap(self), AbstractIterator.IterationKind.VALUE, Global.instance());
  }

  /**
   * ECMA6 23.1.3.12 Map.prototype [ @@iterator ]( )
   * @param self the self reference
   * @return An iterator over the Map's entries
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, name = "@@iterator")
  public static Object getIterator(Object self) {
    return new MapIterator(getNativeMap(self), AbstractIterator.IterationKind.KEY_VALUE, Global.instance());
  }

  /**
   * @param self the self reference
   * @param callbackFn the callback function
   * @param thisArg optional this-object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static void forEach(Object self, Object callbackFn, Object thisArg) {
    var map = getNativeMap(self);
    if (!Bootstrap.isCallable(callbackFn)) {
      throw typeError("not.a.function", ScriptRuntime.safeToString(callbackFn));
    }
    var invoker = Global.instance().getDynamicInvoker(FOREACH_INVOKER_KEY, () -> Bootstrap.createDynamicCallInvoker(Object.class, Object.class, Object.class, Object.class, Object.class, Object.class));
    var iterator = map.getJavaMap().getIterator();
    for (;;) {
      var node = iterator.next();
      if (node == null) {
        break;
      }
      try {
        var result = invoker.invokeExact(callbackFn, thisArg, node.getValue(), node.getKey(), self);
      } catch (RuntimeException | Error e) {
        throw e;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
  }

  @Override
  public String getClassName() {
    return "Map";
  }

  static void populateMap(LinkedMap map, Object arg, Global global) {
    if (arg != null && arg != Undefined.getUndefined()) {
      AbstractIterator.iterate(arg, global, value -> {
        if (JSType.isPrimitive(value)) {
          throw typeError(global, "not.an.object", ScriptRuntime.safeToString(value));
        }
        if (value instanceof ScriptObject sobj) {
          map.set(convertKey(sobj.get(0)), sobj.get(1));
        }
      });
    }
  }

  /**
   * Returns a canonicalized key object by converting numbers to their narrowest representation and ConsStrings to strings.
   * Conversion of Double to Integer also takes care of converting -0 to 0 as required by step 6 of ECMA6 23.1.3.9.
   * @param key a key
   * @return the canonical key
   */
  static Object convertKey(Object key) {
    if (key instanceof ConsString) {
      return key.toString();
    }
    if (key instanceof Double d) {
      if (JSType.isRepresentableAsInt(d.doubleValue())) {
        return d.intValue();
      }
    }
    return key;
  }

  /**
   * Get the underlying Java map.
   * @return the Java map
   */
  LinkedMap getJavaMap() {
    return map;
  }

  static NativeMap getNativeMap(Object self) {
    if (self instanceof NativeMap nm) {
      return nm;
    } else {
      throw typeError("not.a.map", ScriptRuntime.safeToString(self));
    }
  }

}
