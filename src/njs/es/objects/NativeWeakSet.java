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
import static es.objects.NativeWeakMap.checkKey;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.JSType.isPrimitive;

/**
 * This implements the ECMA6 WeakSet object.
 */
@ScriptClass("WeakSet")
public class NativeWeakSet extends ScriptObject {

  private final Map<Object, Boolean> map = new WeakHashMap<>();

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  NativeWeakSet(ScriptObject proto, PropertyMap map) {
    super(proto, map);
  }

  /**
   * ECMA6 23.3.1 The WeakSet Constructor
   * @param isNew  whether the new operator used
   * @param self self reference
   * @param arg optional iterable argument
   * @return a new WeakSet object
   */
  @Constructor(arity = 0)
  public static Object construct(boolean isNew, Object self, Object arg) {
    if (!isNew) {
      throw typeError("constructor.requires.new", "WeakSet");
    }
    var global = Global.instance();
    var weakSet = new NativeWeakSet(global.getWeakSetPrototype(), $nasgenmap$);
    populateWeakSet(weakSet.map, arg, global);
    return weakSet;
  }

  /**
   * ECMA6 23.4.3.1 WeakSet.prototype.add ( value )
   * @param self the self reference
   * @param value the value to add
   * @return this Set object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object add(Object self, Object value) {
    var set = getSet(self);
    set.map.put(checkKey(value), Boolean.TRUE);
    return self;
  }

  /**
   * ECMA6 23.4.3.4 WeakSet.prototype.has ( value )
   * @param self the self reference
   * @param value the value
   * @return true if value is contained
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean has(Object self, Object value) {
    var set = getSet(self);
    return !isPrimitive(value) && set.map.containsKey(value);
  }

  /**
   * ECMA6 23.4.3.3 WeakSet.prototype.delete ( value )
   * @param self the self reference
   * @param value the value
   * @return true if value was deleted
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean delete(Object self, Object value) {
    var map = getSet(self).map;
    if (isPrimitive(value)) {
      return false;
    }
    var returnValue = map.containsKey(value);
    map.remove(value);
    return returnValue;
  }

  @Override
  public String getClassName() {
    return "WeakSet";
  }

  static void populateWeakSet(Map<Object, Boolean> set, Object arg, Global global) {
    if (arg != null && arg != Undefined.getUndefined()) {
      AbstractIterator.iterate(arg, global, value -> {
        set.put(checkKey(value), Boolean.TRUE);
      });
    }
  }

  static NativeWeakSet getSet(Object self) {
    if (self instanceof NativeWeakSet s) {
      return s;
    } else {
      throw typeError("not.a.weak.set", ScriptRuntime.safeToString(self));
    }
  }

}
