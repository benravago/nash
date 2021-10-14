package nash.scripting;

import java.nio.ByteBuffer;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.Callable;

import javax.script.Bindings;

import es.objects.Global;
import es.runtime.ConsString;
import es.runtime.Context;
import es.runtime.ECMAException;
import es.runtime.JSONListAdapter;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.arrays.ArrayData;

/**
 * Mirror object that wraps a given Nashorn Script object.
 */
public final class ScriptObjectMirror extends AbstractJSObject implements Bindings {

  private final ScriptObject sobj;
  private final Global global;
  private final boolean jsonCompatible;

  @Override
  public boolean equals(Object other) {
    return other instanceof ScriptObjectMirror som && sobj.equals(som.sobj);
  }

  @Override
  public int hashCode() {
    return sobj.hashCode();
  }

  @Override
  public String toString() {
    return inGlobal(() -> ScriptRuntime.safeToString(sobj));
  }

  // JSObject methods
  @Override
  public Object call(Object thiz, Object... args) {
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);

    try {
      if (globalChanged) {
        Context.setGlobal(global);
      }

      if (sobj instanceof ScriptFunction sf) {
        var modArgs = globalChanged ? wrapArrayLikeMe(args, oldGlobal) : args;
        var self = globalChanged ? wrapLikeMe(thiz, oldGlobal) : thiz;
        return wrapLikeMe(ScriptRuntime.apply(sf, unwrap(self, global), unwrapArray(modArgs, global)));
      }

      throw new RuntimeException("not a function: " + toString());
    } catch (NashornException ne) {
      throw ne.initEcmaError(global);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    } finally {
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }
  }

  @Override
  public Object newObject(Object... args) {
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);

    try {
      if (globalChanged) {
        Context.setGlobal(global);
      }

      if (sobj instanceof ScriptFunction sf) {
        var modArgs = globalChanged ? wrapArrayLikeMe(args, oldGlobal) : args;
        return wrapLikeMe(ScriptRuntime.construct(sf, unwrapArray(modArgs, global)));
      }

      throw new RuntimeException("not a constructor: " + toString());
    } catch (NashornException ne) {
      throw ne.initEcmaError(global);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    } finally {
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }
  }

  @Override
  public Object eval(String s) {
    return inGlobal(() -> {
      var context = Context.getContext();
      return wrapLikeMe(context.eval(global, s, sobj, null));
    });
  }

  /**
   * Call member function
   *
   * @param functionName function name
   * @param args         arguments
   * @return return value of function
   */
  public Object callMember(String functionName, Object... args) {
    Objects.requireNonNull(functionName);
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);

    try {
      if (globalChanged) {
        Context.setGlobal(global);
      }

      var val = sobj.get(functionName);
      if (val instanceof ScriptFunction sf) {
        var modArgs = globalChanged ? wrapArrayLikeMe(args, oldGlobal) : args;
        return wrapLikeMe(ScriptRuntime.apply(sf, sobj, unwrapArray(modArgs, global)));
      } else if (val instanceof JSObject jso && jso.isFunction()) {
        return jso.call(sobj, args);
      }

      throw new NoSuchMethodException("No such function " + functionName);
    } catch (NashornException ne) {
      throw ne.initEcmaError(global);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    } finally {
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }
  }

  @Override
  public Object getMember(String name) {
    Objects.requireNonNull(name);
    return inGlobal(() -> wrapLikeMe(sobj.get(name)));
  }

  @Override
  public Object getSlot(int index) {
    return inGlobal(() -> wrapLikeMe(sobj.get(index)));
  }

  @Override
  public boolean hasMember(String name) {
    Objects.requireNonNull(name);
    return inGlobal(() -> sobj.has(name));
  }

  @Override
  public boolean hasSlot(int slot) {
    return inGlobal(() -> sobj.has(slot));
  }

  @Override
  public void removeMember(String name) {
    remove(Objects.requireNonNull(name));
  }

  @Override
  public void setMember(String name, Object value) {
    put(Objects.requireNonNull(name), value);
  }

  @Override
  public void setSlot(int index, Object value) {
    inGlobal(() -> {
      sobj.set(index, unwrap(value, global), 0);
      return null;
    });
  }

  /**
   * Nashorn extension: setIndexedPropertiesToExternalArrayData.
   * set indexed properties be exposed from a given nio ByteBuffer.
   *
   * @param buf external buffer - should be a nio ByteBuffer
   */
  public void setIndexedPropertiesToExternalArrayData(ByteBuffer buf) {
    inGlobal(() -> {
      sobj.setArray(ArrayData.allocate(buf));
      return null;
    });
  }

  @Override
  public boolean isInstance(Object instance) {
    if (instance instanceof ScriptObjectMirror mirror && global == mirror.global) {
      return inGlobal(() -> sobj.isInstance(mirror.sobj));
    }
    // if not belongs to my global scope, return false
    return false;
  }

  @Override
  public String getClassName() {
    return sobj.getClassName();
  }

  @Override
  public boolean isFunction() {
    return sobj instanceof ScriptFunction;
  }

  @Override
  public boolean isArray() {
    return sobj.isArray();
  }

  // javax.script.Bindings methods
  @Override
  public void clear() {
    inGlobal(() -> {
      sobj.clear();
      return null;
    });
  }

  @Override
  public boolean containsKey(Object key) {
    checkKey(key);
    return inGlobal(() -> sobj.containsKey(key));
  }

  @Override
  public boolean containsValue(Object value) {
    return inGlobal(() -> sobj.containsValue(unwrap(value, global)));
  }

  @Override
  public Set<Map.Entry<String, Object>> entrySet() {
    return inGlobal(() -> {
      var iter = sobj.propertyIterator();
      var entries = new LinkedHashSet<Map.Entry<String, Object>>();

      while (iter.hasNext()) {
        var key = iter.next();
        var value = translateUndefined(wrapLikeMe(sobj.get(key)));
        entries.add(new AbstractMap.SimpleImmutableEntry<>(key, value));
      }

      return Collections.unmodifiableSet(entries);
    });
  }

  @Override
  public Object get(Object key) {
    checkKey(key);
    return inGlobal(() -> translateUndefined(wrapLikeMe(sobj.get(key))));
  }

  @Override
  public boolean isEmpty() {
    return inGlobal(sobj::isEmpty);
  }

  @Override
  public Set<String> keySet() {
    return inGlobal(() -> {
      var iter = sobj.propertyIterator();
      var keySet = new LinkedHashSet<String>();

      while (iter.hasNext()) {
        keySet.add(iter.next());
      }

      return Collections.unmodifiableSet(keySet);
    });
  }

  @Override
  public Object put(String key, Object value) {
    checkKey(key);
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);
    return inGlobal(() -> {
      var modValue = globalChanged ? wrapLikeMe(value, oldGlobal) : value;
      return translateUndefined(wrapLikeMe(sobj.put(key, unwrap(modValue, global))));
    });
  }

  @Override
  public void putAll(Map<? extends String, ? extends Object> map) {
    Objects.requireNonNull(map);
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);
    inGlobal(() -> {
      for (var entry : map.entrySet()) {
        var value = entry.getValue();
        var modValue = globalChanged ? wrapLikeMe(value, oldGlobal) : value;
        var key = entry.getKey();
        checkKey(key);
        sobj.set(key, unwrap(modValue, global), 0);
      }
      return null;
    });
  }

  @Override
  public Object remove(Object key) {
    checkKey(key);
    return inGlobal(() -> translateUndefined(wrapLikeMe(sobj.remove(key))));
  }

  /**
   * Delete a property from this object.
   *
   * @param key the property to be deleted
   * @return if the delete was successful or not
   */
  public boolean delete(Object key) {
    return inGlobal(() -> sobj.delete(unwrap(key, global)));
  }

  @Override
  public int size() {
    return inGlobal(sobj::size);
  }

  @Override
  public Collection<Object> values() {
    return inGlobal(() -> {
      var values = new ArrayList<Object>(size());
      var iter = sobj.valueIterator();

      while (iter.hasNext()) {
        values.add(translateUndefined(wrapLikeMe(iter.next())));
      }

      return Collections.unmodifiableList(values);
    });
  }

  // Support for ECMAScript Object API on mirrors
  /**
   * Return the __proto__ of this object.
   * @return __proto__ object.
   */
  public Object getProto() {
    return inGlobal(() -> wrapLikeMe(sobj.getProto()));
  }

  /**
   * Set the __proto__ of this object.
   * @param proto new proto for this object
   */
  public void setProto(Object proto) {
    inGlobal(() -> {
      sobj.setPrototypeOf(unwrap(proto, global));
      return null;
    });
  }

  /**
   * ECMA 8.12.1 [[GetOwnProperty]] (P)
   *
   * @param key property key
   *
   * @return Returns the Property Descriptor of the named own property of this
   * object, or undefined if absent.
   */
  public Object getOwnPropertyDescriptor(String key) {
    return inGlobal(() -> wrapLikeMe(sobj.getOwnPropertyDescriptor(key)));
  }

  /**
   * return an array of own property keys associated with the object.
   *
   * @param all True if to include non-enumerable keys.
   * @return Array of keys.
   */
  public String[] getOwnKeys(boolean all) {
    return inGlobal(() -> sobj.getOwnKeys(all));
  }

  /**
   * Flag this script object as non extensible
   *
   * @return the object after being made non extensible
   */
  public ScriptObjectMirror preventExtensions() {
    return inGlobal(() -> {
      sobj.preventExtensions();
      return ScriptObjectMirror.this;
    });
  }

  /**
   * Check if this script object is extensible
   * @return true if extensible
   */
  public boolean isExtensible() {
    return inGlobal(sobj::isExtensible);
  }

  /**
   * ECMAScript 15.2.3.8 - seal implementation
   * @return the sealed script object
   */
  public ScriptObjectMirror seal() {
    return inGlobal(() -> {
      sobj.seal();
      return ScriptObjectMirror.this;
    });
  }

  /**
   * Check whether this script object is sealed
   * @return true if sealed
   */
  public boolean isSealed() {
    return inGlobal(sobj::isSealed);
  }

  /**
   * ECMA 15.2.39 - freeze implementation. Freeze this script object
   * @return the frozen script object
   */
  public ScriptObjectMirror freeze() {
    return inGlobal(() -> {
      sobj.freeze();
      return ScriptObjectMirror.this;
    });
  }

  /**
   * Check whether this script object is frozen
   * @return true if frozen
   */
  public boolean isFrozen() {
    return inGlobal(sobj::isFrozen);
  }

  /**
   * Utility to check if given object is ECMAScript undefined value
   *
   * @param obj object to check
   * @return true if 'obj' is ECMAScript undefined value
   */
  public static boolean isUndefined(Object obj) {
    return obj == ScriptRuntime.UNDEFINED;
  }

  /**
   * Utility to convert this script object to the given type.
   *
   * @param <T> destination type to convert to
   * @param type destination type to convert to
   * @return converted object
   */
  public <T> T to(Class<T> type) {
    return inGlobal(() -> type.cast(ScriptUtils.convert(sobj, type)));
  }

  /**
   * Make a script object mirror on given object if needed.
   *
   * @param obj object to be wrapped/converted
   * @param homeGlobal global to which this object belongs.
   * @return wrapped/converted object
   */
  public static Object wrap(Object obj, Object homeGlobal) {
    return wrap(obj, homeGlobal, false);
  }

  /**
   * Make a script object mirror on given object if needed.
   * The created wrapper will implement the Java {@code List} interface if {@code obj} is a JavaScript {@code Array} object; this is compatible with Java JSON libraries expectations.
   * Arrays retrieved through its properties (transitively) will also implement the list interface.
   *
   * @param obj object to be wrapped/converted
   * @param homeGlobal global to which this object belongs.
   * @return wrapped/converted object
   */
  public static Object wrapAsJSONCompatible(Object obj, Object homeGlobal) {
    return wrap(obj, homeGlobal, true);
  }

  /**
   * Make a script object mirror on given object if needed.
   *
   * @param obj object to be wrapped/converted
   * @param homeGlobal global to which this object belongs.
   * @param jsonCompatible if true,
   *    the created wrapper will implement the Java {@code List} interface if {@code obj} is a JavaScript {@code Array} object.
   *    Arrays retrieved through its properties (transitively) will also implement the list interface.
   * @return wrapped/converted object
   */
  static Object wrap(Object obj, Object homeGlobal, boolean jsonCompatible) {
    if (obj instanceof ScriptObject sobj) {
      if (!(homeGlobal instanceof Global)) {
        return obj;
      }
      var global = (Global) homeGlobal;
      var mirror = new ScriptObjectMirror(sobj, global, jsonCompatible);
      if (jsonCompatible && sobj.isArray()) {
        return new JSONListAdapter(mirror, global);
      }
      return mirror;
    } else if (obj instanceof ConsString) {
      return obj.toString();
    } else if (jsonCompatible && obj instanceof ScriptObjectMirror som) {
      // Since choosing JSON compatible representation is an explicit decision on user's part,
      // if we're asked to wrap a mirror that was not JSON compatible,
      // explicitly create its compatible counterpart following the principle of least surprise.
      return som.asJSONCompatible();
    }
    return obj;
  }

  /**
   * Wraps the passed object with the same jsonCompatible flag as this mirror.
   *
   * @param obj the object
   * @param homeGlobal the object's home global.
   * @return a wrapper for the object.
   */
  Object wrapLikeMe(Object obj, Object homeGlobal) {
    return wrap(obj, homeGlobal, jsonCompatible);
  }

  /**
   * Wraps the passed object with the same home global and jsonCompatible flag as this mirror.
   *
   * @param obj the object
   * @return a wrapper for the object.
   */
  Object wrapLikeMe(Object obj) {
    return wrapLikeMe(obj, global);
  }

  /**
   * Unwrap a script object mirror if needed.
   *
   * @param obj object to be unwrapped
   * @param homeGlobal global to which this object belongs
   * @return unwrapped object
   */
  public static Object unwrap(Object obj, Object homeGlobal) {
    if (obj instanceof ScriptObjectMirror mirror) {
      return (mirror.global == homeGlobal) ? mirror.sobj : obj;
    } else if (obj instanceof JSONListAdapter jla) {
      return jla.unwrap(homeGlobal);
    }

    return obj;
  }

  /**
   * Wrap an array of object to script object mirrors if needed.
   *
   * @param args array to be unwrapped
   * @param homeGlobal global to which this object belongs
   * @return wrapped array
   */
  public static Object[] wrapArray(Object[] args, Object homeGlobal) {
    return wrapArray(args, homeGlobal, false);
  }

  static Object[] wrapArray(Object[] args, Object homeGlobal, boolean jsonCompatible) {
    if (args == null || args.length == 0) {
      return args;
    }

    var newArgs = new Object[args.length];
    var index = 0;
    for (var obj : args) {
      newArgs[index] = wrap(obj, homeGlobal, jsonCompatible);
      index++;
    }
    return newArgs;
  }

  Object[] wrapArrayLikeMe(Object[] args, Object homeGlobal) {
    return wrapArray(args, homeGlobal, jsonCompatible);
  }

  /**
   * Unwrap an array of script object mirrors if needed.
   *
   * @param args array to be unwrapped
   * @param homeGlobal global to which this object belongs
   * @return unwrapped array
   */
  public static Object[] unwrapArray(Object[] args, Object homeGlobal) {
    if (args == null || args.length == 0) {
      return args;
    }

    var newArgs = new Object[args.length];
    var index = 0;
    for (var obj : args) {
      newArgs[index] = unwrap(obj, homeGlobal);
      index++;
    }
    return newArgs;
  }

  /**
   * Are the given objects mirrors to same underlying object?
   *
   * @param obj1 first object
   * @param obj2 second object
   * @return true if obj1 and obj2 are identical script objects or mirrors of it.
   */
  public static boolean identical(Object obj1, Object obj2) {
    var o1 = obj1 instanceof ScriptObjectMirror som ? som.sobj : obj1;
    var o2 = obj2 instanceof ScriptObjectMirror som ? som.sobj : obj2;

    return o1 == o2;
  }

  // package-privates below this.

  ScriptObjectMirror(ScriptObject sobj, Global global) {
    this(sobj, global, false);
  }

  ScriptObjectMirror(ScriptObject sobj, Global global, boolean jsonCompatible) {
    assert sobj != null : "ScriptObjectMirror on null!";
    assert global != null : "home Global is null";

    this.sobj = sobj;
    this.global = global;
    this.jsonCompatible = jsonCompatible;
  }

  // accessors for script engine
  ScriptObject getScriptObject() {
    return sobj;
  }

  Global getHomeGlobal() {
    return global;
  }

  static Object translateUndefined(Object obj) {
    return (obj == ScriptRuntime.UNDEFINED) ? null : obj;
  }

  // internals only below this.
  <V> V inGlobal(Callable<V> callable) {
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);
    if (globalChanged) {
      Context.setGlobal(global);
    }
    try {
      return callable.call();
    } catch (NashornException ne) {
      throw ne.initEcmaError(global);
    } catch (RuntimeException e) {
      throw e;
    } catch (Exception e) {
      throw new AssertionError("Cannot happen", e);
    } finally {
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }
  }

  /**
   * Ensures the key is not null, empty string, or a non-String object. The contract of the {@link Bindings}
   * interface requires that these are not accepted as keys.
   * @param key the key to check
   * @throws NullPointerException if key is null
   * @throws ClassCastException if key is not a String
   * @throws IllegalArgumentException if key is empty string
   */
  private static void checkKey(Object key) {
    Objects.requireNonNull(key, "key can not be null");

    if (key instanceof String str) {
      if (str.length() == 0) {
        throw new IllegalArgumentException("key can not be empty");
      }
    } else {
      throw new ClassCastException("key should be a String. It is " + key.getClass().getName() + " instead.");
    }
  }

  @Override
  public Object getDefaultValue(Class<?> hint) {
    return inGlobal(() -> {
      try {
        return sobj.getDefaultValue(hint);
      } catch (ECMAException e) {
        // We're catching ECMAException (likely TypeError), and translating it to UnsupportedOperationException.
        // This in turn will be translated into TypeError of the caller's Global by JSType#toPrimitive(JSObject,Class)
        // therefore ensuring that it's recognized as "instanceof TypeError" in the caller.
        throw new UnsupportedOperationException(e.getMessage(), e);
      }
    });
  }

  ScriptObjectMirror asJSONCompatible() {
    return this.jsonCompatible ? this : new ScriptObjectMirror(sobj, global, true);
  }

}
