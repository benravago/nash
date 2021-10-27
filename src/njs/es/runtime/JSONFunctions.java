package es.runtime;

import java.lang.invoke.MethodHandle;
import java.util.concurrent.Callable;
import es.objects.Global;
import es.parser.JSONParser;
import es.runtime.arrays.ArrayIndex;
import es.runtime.linker.Bootstrap;

/**
 * Utilities used by "JSON" object implementation.
 */
public final class JSONFunctions {

  private static final Object REVIVER_INVOKER = new Object();

  static MethodHandle getREVIVER_INVOKER() {
    return Context.getGlobal().getDynamicInvoker(REVIVER_INVOKER, () -> Bootstrap.createDynamicCallInvoker(Object.class, Object.class, Object.class, String.class, Object.class));
  }

  /**
   * Returns JSON-compatible quoted version of the given string.
   * @param str String to be quoted
   * @return JSON-compatible quoted string
   */
  public static String quote(String str) {
    return JSONParser.quote(str);
  }

  /**
   * Parses the given JSON text string and returns object representation.
   * @param text JSON text to be parsed
   * @param reviver  optional value: function that takes two parameters (key, value)
   * @return Object representation of JSON text given
   */
  public static Object parse(Object text, Object reviver) {
    var str = JSType.toString(text);
    var global = Context.getGlobal();
    var dualFields = ((ScriptObject) global).useDualFields();
    var parser = new JSONParser(str, global, dualFields);
    Object value;
    try {
      value = parser.parse();
    } catch (ParserException e) {
      throw ECMAErrors.syntaxError(e, "invalid.json", e.getMessage());
    }
    return applyReviver(global, value, reviver);
  }

  // -- Internals only below this point

  // parse helpers

  // apply 'reviver' function if available
  static Object applyReviver(Global global, Object unfiltered, Object reviver) {
    if (Bootstrap.isCallable(reviver)) {
      var root = global.newObject();
      root.addOwnProperty("", Property.WRITABLE_ENUMERABLE_CONFIGURABLE, unfiltered);
      return walk(root, "", reviver);
    }
    return unfiltered;
  }

  // This is the abstract "Walk" operation from the spec.
  static Object walk(ScriptObject holder, Object name, Object reviver) {
    var val = holder.get(name);
    if (val instanceof ScriptObject valueObj) {
      if (valueObj.isArray()) {
        var length = JSType.toInteger(valueObj.getLength());
        for (var i = 0; i < length; i++) {
          var key = Integer.toString(i);
          var newElement = walk(valueObj, key, reviver);
          if (newElement == ScriptRuntime.UNDEFINED) {
            valueObj.delete(i);
          } else {
            setPropertyValue(valueObj, key, newElement);
          }
        }
      } else {
        var keys = valueObj.getOwnKeys(false);
        for (var key : keys) {
          var newElement = walk(valueObj, key, reviver);
          if (newElement == ScriptRuntime.UNDEFINED) {
            valueObj.delete(key);
          } else {
            setPropertyValue(valueObj, key, newElement);
          }
        }
      }
    }
    try {
      // Object.class, ScriptFunction.class, ScriptObject.class, String.class, Object.class);
      return getREVIVER_INVOKER().invokeExact(reviver, (Object) holder, JSType.toString(name), val);
    } catch (Error | RuntimeException t) {
      throw t;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  // add a new property if does not exist already, or else set old property
  static void setPropertyValue(ScriptObject sobj, String name, Object value) {
    var index = ArrayIndex.getArrayIndex(name);
    if (ArrayIndex.isValidArrayIndex(index)) {
      // array index key
      sobj.defineOwnProperty(index, value);
    } else if (sobj.getMap().findProperty(name) != null) {
      // pre-existing non-inherited property, call set
      sobj.set(name, value, 0);
    } else {
      // add new property
      sobj.addOwnProperty(name, Property.WRITABLE_ENUMERABLE_CONFIGURABLE, value);
    }
  }

}
