package es.objects;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.IdentityHashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.Callable;

import java.lang.invoke.MethodHandle;

import nash.scripting.JSObject;
import nash.scripting.ScriptObjectMirror;

import es.objects.annotations.Attribute;
import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.Where;
import es.runtime.ConsString;
import es.runtime.JSONFunctions;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.arrays.ArrayLikeIterator;
import es.runtime.linker.Bootstrap;
import es.runtime.linker.InvokeByName;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * ECMAScript 262 Edition 5, Section 15.12 The NativeJSON Object
 */
@ScriptClass("JSON")
public final class NativeJSON extends ScriptObject {

  private static final Object TO_JSON = new Object();

  static InvokeByName getTO_JSON() {
    return Global.instance().getInvokeByName(TO_JSON, () -> new InvokeByName("toJSON", ScriptObject.class, Object.class, Object.class));
  }

  private static final Object JSOBJECT_INVOKER = new Object();

  static MethodHandle getJSOBJECT_INVOKER() {
    return Global.instance().getDynamicInvoker(JSOBJECT_INVOKER, () -> Bootstrap.createDynamicCallInvoker(Object.class, Object.class, Object.class));
  }

  private static final Object REPLACER_INVOKER = new Object();

  static MethodHandle getREPLACER_INVOKER() {
    return Global.instance().getDynamicInvoker(REPLACER_INVOKER, () -> Bootstrap.createDynamicCallInvoker(Object.class, Object.class, Object.class, Object.class, Object.class));
  }

  // initialized by nasgen
  @SuppressWarnings("unused")
  static PropertyMap $nasgenmap$;

  /**
   * ECMA 15.12.2 parse ( text [ , reviver ] )
   * @param self     self reference
   * @param text     a JSON formatted string
   * @param reviver  optional value: function that takes two parameters (key, value)
   * @return an ECMA script value
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static Object parse(Object self, Object text, Object reviver) {
    return JSONFunctions.parse(text, reviver);
  }

  /**
   * ECMA 15.12.3 stringify ( value [ , replacer [ , space ] ] )
   * @param self     self reference
   * @param value    ECMA script value (usually object or array)
   * @param replacer either a function or an array of strings and numbers
   * @param space    optional parameter - allows result to have whitespace injection
   * @return a string in JSON format
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static Object stringify(Object self, Object value, Object replacer, Object space) {
    // The stringify method takes a value and an optional replacer, and an optional space parameter, and returns a JSON text.
    // The replacer can be a function that can replace values, or an array of strings that will select the keys.

    // A default replacer method can be provided.
    // Use of the space parameter can produce text that is more easily readable.
    var state = new StringifyState();

    // If there is a replacer, it must be a function or an array.
    if (Bootstrap.isCallable(replacer)) {
      state.replacerFunction = replacer;
    } else if (isArray(replacer) || isJSObjectArray(replacer) || replacer instanceof Iterable || (replacer != null && replacer.getClass().isArray())) {
      state.propertyList = new ArrayList<>();
      var iter = ArrayLikeIterator.arrayLikeIterator(replacer);
      while (iter.hasNext()) {
        String item = null;
        var v = iter.next();
        if (v instanceof String s) {
          item = s;
        } else if (v instanceof ConsString) {
          item = v.toString();
        } else if (v instanceof Number || v instanceof NativeNumber || v instanceof NativeString) {
          item = JSType.toString(v);
        }
        if (item != null) {
          state.propertyList.add(item);
        }
      }
    }
    // If the space parameter is a number, make an indent string containing that many spaces.
    String gap;
    // modifiable 'space' - parameter is final
    var modSpace = space;
    if (modSpace instanceof NativeNumber) {
      modSpace = JSType.toNumber(JSType.toPrimitive(modSpace, Number.class));
    } else if (modSpace instanceof NativeString) {
      modSpace = JSType.toString(JSType.toPrimitive(modSpace, String.class));
    }
    if (modSpace instanceof Number) {
      var indent = Math.min(10, JSType.toInteger(modSpace));
      if (indent < 1) {
        gap = "";
      } else {
        var sb = new StringBuilder();
        for (var i = 0; i < indent; i++) {
          sb.append(' ');
        }
        gap = sb.toString();
      }
    } else if (JSType.isString(modSpace)) {
      assert modSpace != null;
      var str = modSpace.toString();
      gap = str.substring(0, Math.min(10, str.length()));
    } else {
      gap = "";
    }
    state.gap = gap;
    var wrapper = Global.newEmptyInstance();
    wrapper.set("", value, 0);
    return str("", wrapper, state);
  }

  // -- Internals only below this point

  // stringify helpers.
  static class StringifyState {
    final Map<Object, Object> stack = new IdentityHashMap<>();
    StringBuilder indent = new StringBuilder();
    String gap = "";
    List<String> propertyList = null;
    Object replacerFunction = null;
  }

  // Spec: The abstract operation Str(key, holder).
  static Object str(Object key, Object holder, StringifyState state) {
    assert holder instanceof ScriptObject || holder instanceof JSObject;
    var value = getProperty(holder, key);
    try {
      if (value instanceof ScriptObject svalue) {
        var toJSONInvoker = getTO_JSON();
        var toJSON = toJSONInvoker.getGetter().invokeExact(svalue);
        if (Bootstrap.isCallable(toJSON)) {
          value = toJSONInvoker.getInvoker().invokeExact(toJSON, svalue, key);
        }
      } else if (value instanceof JSObject jsObj) {
        var toJSON = jsObj.getMember("toJSON");
        if (Bootstrap.isCallable(toJSON)) {
          value = getJSOBJECT_INVOKER().invokeExact(toJSON, value);
        }
      }
      if (state.replacerFunction != null) {
        value = getREPLACER_INVOKER().invokeExact(state.replacerFunction, holder, key, value);
      }
    } catch (Error | RuntimeException t) {
      throw t;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
    var isObj = (value instanceof ScriptObject);
    if (isObj) {
      if (value instanceof NativeNumber) {
        value = JSType.toNumber(value);
      } else if (value instanceof NativeString) {
        value = JSType.toString(value);
      } else if (value instanceof NativeBoolean) {
        value = ((NativeBoolean) value).booleanValue();
      }
    }
    if (value == null) {
      return "null";
    } else if (Boolean.TRUE.equals(value)) {
      return "true";
    } else if (Boolean.FALSE.equals(value)) {
      return "false";
    }
    if (value instanceof String s) {
      return JSONFunctions.quote(s);
    } else if (value instanceof ConsString) {
      return JSONFunctions.quote(value.toString());
    }
    if (value instanceof Number n) {
      return JSType.isFinite(n.doubleValue()) ? JSType.toString(value) : "null";
    }
    var type = JSType.of(value);
    if (type == JSType.OBJECT) {
      if (isArray(value) || isJSObjectArray(value)) {
        return JA(value, state);
      } else if (value instanceof ScriptObject || value instanceof JSObject) {
        return JO(value, state);
      }
    }
    return UNDEFINED;
  }

  // Spec: The abstract operation JO(value) serializes an object.
  static String JO(Object value, StringifyState state) {
    assert value instanceof ScriptObject || value instanceof JSObject;
    if (state.stack.containsKey(value)) {
      throw typeError("JSON.stringify.cyclic");
    }
    state.stack.put(value, value);
    var stepback = new StringBuilder(state.indent.toString());
    state.indent.append(state.gap);
    var finalStr = new StringBuilder();
    var partial = new ArrayList<Object>();
    var k = state.propertyList == null ? Arrays.asList(getOwnKeys(value)) : state.propertyList;
    for (var p : k) {
      var strP = str(p, value, state);
      if (strP != UNDEFINED) {
        var member = new StringBuilder();
        member.append(JSONFunctions.quote(p)).append(':');
        if (!state.gap.isEmpty()) {
          member.append(' ');
        }
        member.append(strP);
        partial.add(member);
      }
    }
    if (partial.isEmpty()) {
      finalStr.append("{}");
    } else {
      if (state.gap.isEmpty()) {
        var size = partial.size();
        var index = 0;
        finalStr.append('{');
        for (var str : partial) {
          finalStr.append(str);
          if (index < size - 1) {
            finalStr.append(',');
          }
          index++;
        }
        finalStr.append('}');
      } else {
        var size = partial.size();
        var index = 0;
        finalStr.append("{\n");
        finalStr.append(state.indent);
        for (var str : partial) {
          finalStr.append(str);
          if (index < size - 1) {
            finalStr.append(",\n");
            finalStr.append(state.indent);
          }
          index++;
        }
        finalStr.append('\n');
        finalStr.append(stepback);
        finalStr.append('}');
      }
    }
    state.stack.remove(value);
    state.indent = stepback;
    return finalStr.toString();
  }

  // Spec: The abstract operation JA(value) serializes an array.
  static Object JA(Object value, StringifyState state) {
    assert value instanceof ScriptObject || value instanceof JSObject;
    if (state.stack.containsKey(value)) {
      throw typeError("JSON.stringify.cyclic");
    }
    state.stack.put(value, value);
    var stepback = new StringBuilder(state.indent.toString());
    state.indent.append(state.gap);
    var partial = new ArrayList<Object>();
    var length = JSType.toInteger(getLength(value));
    var index = 0;
    while (index < length) {
      var strP = str(index, value, state);
      if (strP == UNDEFINED) {
        strP = "null";
      }
      partial.add(strP);
      index++;
    }
    var finalStr = new StringBuilder();
    if (partial.isEmpty()) {
      finalStr.append("[]");
    } else {
      if (state.gap.isEmpty()) {
        var size = partial.size();
        index = 0;
        finalStr.append('[');
        for (var str : partial) {
          finalStr.append(str);
          if (index < size - 1) {
            finalStr.append(',');
          }
          index++;
        }
        finalStr.append(']');
      } else {
        var size = partial.size();
        index = 0;
        finalStr.append("[\n");
        finalStr.append(state.indent);
        for (var str : partial) {
          finalStr.append(str);
          if (index < size - 1) {
            finalStr.append(",\n");
            finalStr.append(state.indent);
          }
          index++;
        }
        finalStr.append('\n');
        finalStr.append(stepback);
        finalStr.append(']');
      }
    }
    state.stack.remove(value);
    state.indent = stepback;
    return finalStr.toString();
  }

  static String[] getOwnKeys(Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.getOwnKeys(false);
    } else if (obj instanceof ScriptObjectMirror som) {
      return som.getOwnKeys(false);
    } else if (obj instanceof JSObject jso) {
      // No notion of "own keys" or "proto" for general JSObject!
      // We just return all keys of the object.
      // This will be useful for POJOs implementing JSObject interface.
      return jso.keySet().toArray(new String[0]);
    } else {
      throw new AssertionError("should not reach here");
    }
  }

  static Object getLength(Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.getLength();
    } else if (obj instanceof JSObject jso) {
      return jso.getMember("length");
    } else {
      throw new AssertionError("should not reach here");
    }
  }

  static boolean isJSObjectArray(Object obj) {
    return (obj instanceof JSObject) && ((JSObject) obj).isArray();
  }

  static Object getProperty(Object holder, Object key) {
    if (holder instanceof ScriptObject so) {
      return so.get(key);
    } else if (holder instanceof JSObject jsObj) {
      if (key instanceof Integer i) {
        return jsObj.getSlot(i);
      } else {
        return jsObj.getMember(Objects.toString(key));
      }
    } else {
      return new AssertionError("should not reach here");
    }
  }

}
