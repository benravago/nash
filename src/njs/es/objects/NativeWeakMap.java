package es.objects;

import java.util.Map;
import java.util.WeakHashMap;

import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.Undefined;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.JSType.isPrimitive;

/**
 * This implements the ECMA6 WeakMap object.
 */
@ScriptClass("WeakMap")
public class NativeWeakMap extends ScriptObject {

  private final Map<Object, Object> jmap = new WeakHashMap<>();

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  NativeWeakMap(ScriptObject proto, PropertyMap map) {
    super(proto, map);
  }

  /**
   * ECMA6 23.3.1 The WeakMap Constructor
   * @param isNew  whether the new operator used
   * @param self self reference
   * @param arg optional iterable argument
   * @return a new WeakMap object
   */
  @Constructor(arity = 0)
  public static Object construct(boolean isNew, Object self, Object arg) {
    if (!isNew) {
      throw typeError("constructor.requires.new", "WeakMap");
    }
    var global = Global.instance();
    var weakMap = new NativeWeakMap(global.getWeakMapPrototype(), $nasgenmap$);
    populateMap(weakMap.jmap, arg, global);
    return weakMap;
  }

  /**
   * ECMA6 23.3.3.5 WeakMap.prototype.set ( key , value )
   * @param self the self reference
   * @param key the key
   * @param value the value
   * @return this WeakMap object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object set(Object self, Object key, Object value) {
    var map = getMap(self);
    map.jmap.put(checkKey(key), value);
    return self;
  }

  /**
   * ECMA6 23.3.3.3 WeakMap.prototype.get ( key )
   * @param self the self reference
   * @param key the key
   * @return the associated value or undefined
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object get(Object self, Object key) {
    var map = getMap(self);
    return (isPrimitive(key)) ? Undefined.getUndefined() : map.jmap.get(key);
  }

  /**
   * ECMA6 23.3.3.2 WeakMap.prototype.delete ( key )
   *
   * @param self the self reference
   * @param key the key to delete
   * @return true if the key was deleted
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean delete(Object self, Object key) {
    var map = getMap(self).jmap;
    if (isPrimitive(key)) {
      return false;
    }
    var returnValue = map.containsKey(key);
    map.remove(key);
    return returnValue;
  }

  /**
   * ECMA6 23.3.3.4 WeakMap.prototype.has ( key )
   * @param self the self reference
   * @param key the key
   * @return true if key is contained
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean has(Object self, Object key) {
    var map = getMap(self);
    return !isPrimitive(key) && map.jmap.containsKey(key);
  }

  @Override
  public String getClassName() {
    return "WeakMap";
  }

  /**
   * Make sure {@code key} is not a JavaScript primitive value.
   *
   * @param key a key object
   * @return the valid key
   */
  static Object checkKey(Object key) {
    if (isPrimitive(key)) {
      throw typeError("invalid.weak.key", ScriptRuntime.safeToString(key));
    }
    return key;
  }

  static void populateMap(Map<Object, Object> map, Object arg, Global global) {
    // This method is similar to NativeMap.populateMap, but it uses a different
    // map implementation and the checking/conversion of keys differs as well.
    if (arg != null && arg != Undefined.getUndefined()) {
      AbstractIterator.iterate(arg, global, value -> {
        if (isPrimitive(value)) {
          throw typeError(global, "not.an.object", ScriptRuntime.safeToString(value));
        }
        if (value instanceof ScriptObject sobj) {
          map.put(checkKey(sobj.get(0)), sobj.get(1));
        }
      });
    }
  }

  static NativeWeakMap getMap(Object self) {
    if (self instanceof NativeWeakMap m) {
      return m;
    } else {
      throw typeError("not.a.weak.map", ScriptRuntime.safeToString(self));
    }
  }

}
