package es.objects;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.Callable;
import java.util.concurrent.ConcurrentHashMap;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.SwitchPoint;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;

import javax.script.ScriptContext;
import javax.script.ScriptEngine;

import nash.scripting.ClassFilter;
import nash.scripting.ScriptObjectMirror;

import es.lookup.Lookup;
import es.objects.annotations.Attribute;
import es.objects.annotations.Getter;
import es.objects.annotations.Property;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.Setter;
import es.runtime.Context;
import es.runtime.ECMAErrors;
import es.runtime.FindProperty;
import es.runtime.GlobalFunctions;
import es.runtime.JSType;
import es.runtime.PropertyDescriptor;
import es.runtime.PropertyMap;
import es.runtime.Scope;
import es.runtime.ScriptEnvironment;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.Specialization;
import es.runtime.Symbol;
import es.runtime.arrays.ArrayData;
import es.runtime.linker.Bootstrap;
import es.runtime.linker.InvokeByName;
import es.runtime.linker.NashornCallSiteDescriptor;
import es.runtime.regexp.RegExpResult;
import es.scripts.JD;
import es.scripts.JO;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.referenceError;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.JSType.isString;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * Representation of global scope.
 */
@ScriptClass("Global")
public final class Global extends Scope {

  // This special value is used to flag a lazily initialized global property.
  private static final Object LAZY_SENTINEL = new Object();

  // This serves as placeholder value used in place of a location property (__FILE__, __DIR__, __LINE__)
  private static final Object LOCATION_PLACEHOLDER = new Object();

  private static final String PACKAGE_PREFIX = "es.objects.";

  private InvokeByName TO_STRING;
  private InvokeByName VALUE_OF;

  /**
   * Optimistic builtin names that require switchpoint invalidation upon assignment.
   *
   * Overly conservative, but works for now, to avoid any complicated scope checks and especially heavy weight guards
   * like
   * <pre>
   *     public boolean setterGuard(Object receiver) {
   *         final Global          global = Global.instance();
   *         final ScriptObject    sobj   = global.getFunctionPrototype();
   *         final Object          apply  = sobj.get("apply");
   *         return apply == receiver;
   *     }
   * </pre>
   *
   * Naturally, checking for builtin classes like NativeFunction is cheaper, it's when you start adding property checks for said builtins you have problems with guard speed.
   */

  /** ECMA 15.1.2.2 parseInt (string , radix) */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object parseInt;

  /** ECMA 15.1.2.3 parseFloat (string) */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object parseFloat;

  /** ECMA 15.1.2.4 isNaN (number) */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object isNaN;

  /** ECMA 15.1.2.5 isFinite (number) */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object isFinite;

  /** ECMA 15.1.3.3 encodeURI */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object encodeURI;

  /** ECMA 15.1.3.4 encodeURIComponent */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object encodeURIComponent;

  /** ECMA 15.1.3.1 decodeURI */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object decodeURI;

  /** ECMA 15.1.3.2 decodeURIComponent */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object decodeURIComponent;

  /** ECMA B.2.1 escape (string) */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object escape;

  /** ECMA B.2.2 unescape (string) */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object unescape;

  /** Value property NaN of the Global Object - ECMA 15.1.1.1 NaN */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT)
  public static final double NaN = Double.NaN;

  /** Value property Infinity of the Global Object - ECMA 15.1.1.2 Infinity */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT)
  public static final double Infinity = Double.POSITIVE_INFINITY;

  /** Value property Undefined of the Global Object - ECMA 15.1.1.3 Undefined */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT)
  public static final Object undefined = UNDEFINED;

  /** ECMA 15.1.2.1 eval(x) */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object eval;

  /** ECMA 15.1.4.1 Object constructor. */
  @Property(name = "Object", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object object;

  /** ECMA 15.1.4.2 Function constructor. */
  @Property(name = "Function", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object function;

  /** ECMA 15.1.4.3 Array constructor. */
  @Property(name = "Array", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object array;

  /** ECMA 15.1.4.4 String constructor */
  @Property(name = "String", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object string;

  /** ECMA 15.1.4.5 Boolean constructor */
  @Property(name = "Boolean", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object _boolean;

  /** ECMA 15.1.4.6 - Number constructor */
  @Property(name = "Number", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object number;
  
  /**
   * Getter for ECMA 15.1.4.7 Date property
   * @param self self reference
   * @return Date property value
   */
  @Getter(name = "Date", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getDate(Object self) {
    var global = Global.instanceFrom(self);
    if (global.date == LAZY_SENTINEL) {
      global.date = global.getBuiltinDate();
    }
    return global.date;
  }

  /**
   * Setter for ECMA 15.1.4.7 Date property
   * @param self self reference
   * @param value value for the Date property
   */
  @Setter(name = "Date", attributes = Attribute.NOT_ENUMERABLE)
  public static void setDate(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.date = value;
  }

  private volatile Object date = LAZY_SENTINEL;

  /**
   * Getter for ECMA 15.1.4.8 RegExp property
   * @param self self reference
   * @return RegExp property value
   */
  @Getter(name = "RegExp", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getRegExp(Object self) {
    var global = Global.instanceFrom(self);
    if (global.regexp == LAZY_SENTINEL) {
      global.regexp = global.getBuiltinRegExp();
    }
    return global.regexp;
  }

  /**
   * Setter for ECMA 15.1.4.8 RegExp property
   * @param self self reference
   * @param value value for the RegExp property
   */
  @Setter(name = "RegExp", attributes = Attribute.NOT_ENUMERABLE)
  public static void setRegExp(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.regexp = value;
  }

  private volatile Object regexp = LAZY_SENTINEL;

  /**
   * Getter for ECMA 15.12 - The JSON property
   * @param self self reference
   * @return the value of JSON property
   */
  @Getter(name = "JSON", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getJSON(Object self) {
    var global = Global.instanceFrom(self);
    if (global.json == LAZY_SENTINEL) {
      global.json = global.getBuiltinJSON();
    }
    return global.json;
  }

  /**
   * Setter for ECMA 15.12 - The JSON property
   * @param self self reference
   * @param value value for the JSON property
   */
  @Setter(name = "JSON", attributes = Attribute.NOT_ENUMERABLE)
  public static void setJSON(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.json = value;
  }

  private volatile Object json = LAZY_SENTINEL;

  /**
   * Getter for Nashorn extension: global.JSAdapter
   * @param self self reference
   * @return value of the JSAdapter property
   */
  @Getter(name = "JSAdapter", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getJSAdapter(Object self) {
    var global = Global.instanceFrom(self);
    if (global.jsadapter == LAZY_SENTINEL) {
      global.jsadapter = global.getBuiltinJSAdapter();
    }
    return global.jsadapter;
  }

  /**
   * Setter for Nashorn extension: global.JSAdapter
   * @param self self reference
   * @param value value for the JSAdapter property
   */
  @Setter(name = "JSAdapter", attributes = Attribute.NOT_ENUMERABLE)
  public static void setJSAdapter(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.jsadapter = value;
  }

  private volatile Object jsadapter = LAZY_SENTINEL;

  /** ECMA 15.8 - The Math object */
  @Property(name = "Math", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object math;

  /** Error object */
  @Property(name = "Error", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object error;

  /**
   * Getter for the EvalError property
   * @param self self reference
   * @return the value of EvalError property
   */
  @Getter(name = "EvalError", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getEvalError(Object self) {
    var global = Global.instanceFrom(self);
    if (global.evalError == LAZY_SENTINEL) {
      global.evalError = global.getBuiltinEvalError();
    }
    return global.evalError;
  }

  /**
   * Setter for the EvalError property
   * @param self self reference
   * @param value value of the EvalError property
   */
  @Setter(name = "EvalError", attributes = Attribute.NOT_ENUMERABLE)
  public static void setEvalError(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.evalError = value;
  }

  private volatile Object evalError = LAZY_SENTINEL;

  /**
   * Getter for the RangeError property.
   * @param self self reference
   * @return the value of RangeError property
   */
  @Getter(name = "RangeError", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getRangeError(Object self) {
    var global = Global.instanceFrom(self);
    if (global.rangeError == LAZY_SENTINEL) {
      global.rangeError = global.getBuiltinRangeError();
    }
    return global.rangeError;
  }

  /**
   * Setter for the RangeError property.
   * @param self self reference
   * @param value value for the RangeError property
   */
  @Setter(name = "RangeError", attributes = Attribute.NOT_ENUMERABLE)
  public static void setRangeError(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.rangeError = value;
  }

  private volatile Object rangeError = LAZY_SENTINEL;

  /** ReferenceError object */
  @Property(name = "ReferenceError", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object referenceError;

  /** SyntaxError object */
  @Property(name = "SyntaxError", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object syntaxError;

  /** TypeError object */
  @Property(name = "TypeError", attributes = Attribute.NOT_ENUMERABLE)
  public volatile Object typeError;

  /**
   * Getter for the URIError property.
   * @param self self reference
   * @return the value of URIError property
   */
  @Getter(name = "URIError", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getURIError(Object self) {
    var global = Global.instanceFrom(self);
    if (global.uriError == LAZY_SENTINEL) {
      global.uriError = global.getBuiltinURIError();
    }
    return global.uriError;
  }

  /**
   * Setter for the URIError property.
   * @param self self reference
   * @param value value for the URIError property
   */
  @Setter(name = "URIError", attributes = Attribute.NOT_ENUMERABLE)
  public static void setURIError(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.uriError = value;
  }

  private volatile Object uriError = LAZY_SENTINEL;

  /**
   * Getter for the ArrayBuffer property.
   * @param self self reference
   * @return the value of the ArrayBuffer property
   */
  @Getter(name = "ArrayBuffer", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getArrayBuffer(Object self) {
    var global = Global.instanceFrom(self);
    if (global.arrayBuffer == LAZY_SENTINEL) {
      global.arrayBuffer = global.getBuiltinArrayBuffer();
    }
    return global.arrayBuffer;
  }

  /**
   * Setter for the ArrayBuffer property.
   * @param self self reference
   * @param value value of the ArrayBuffer property
   */
  @Setter(name = "ArrayBuffer", attributes = Attribute.NOT_ENUMERABLE)
  public static void setArrayBuffer(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.arrayBuffer = value;
  }

  private volatile Object arrayBuffer;

  /**
   * Getter for the DataView property.
   * @param self self reference
   * @return the value of the DataView property
   */
  @Getter(name = "DataView", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getDataView(Object self) {
    var global = Global.instanceFrom(self);
    if (global.dataView == LAZY_SENTINEL) {
      global.dataView = global.getBuiltinDataView();
    }
    return global.dataView;
  }

  /**
   * Setter for the DataView property.
   * @param self self reference
   * @param value value of the DataView property
   */
  @Setter(name = "DataView", attributes = Attribute.NOT_ENUMERABLE)
  public static void setDataView(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.dataView = value;
  }

  private volatile Object dataView;

  /**
   * Getter for the Int8Array property.
   * @param self self reference
   * @return the value of the Int8Array property.
   */
  @Getter(name = "Int8Array", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getInt8Array(Object self) {
    var global = Global.instanceFrom(self);
    if (global.int8Array == LAZY_SENTINEL) {
      global.int8Array = global.getBuiltinInt8Array();
    }
    return global.int8Array;
  }

  /**
   * Setter for the Int8Array property.
   * @param self self reference
   * @param value value of the Int8Array property
   */
  @Setter(name = "Int8Array", attributes = Attribute.NOT_ENUMERABLE)
  public static void setInt8Array(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.int8Array = value;
  }

  private volatile Object int8Array;

  /**
   * Getter for the Uin8Array property.
   * @param self self reference
   * @return the value of the Uint8Array property
   */
  @Getter(name = "Uint8Array", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getUint8Array(Object self) {
    var global = Global.instanceFrom(self);
    if (global.uint8Array == LAZY_SENTINEL) {
      global.uint8Array = global.getBuiltinUint8Array();
    }
    return global.uint8Array;
  }

  /**
   * Setter for the Uin8Array property.
   * @param self self reference
   * @param value value of the Uin8Array property
   */
  @Setter(name = "Uint8Array", attributes = Attribute.NOT_ENUMERABLE)
  public static void setUint8Array(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.uint8Array = value;
  }

  private volatile Object uint8Array;

  /**
   * Getter for the Uint8ClampedArray property.
   * @param self self reference
   * @return the value of the Uint8ClampedArray property
   */
  @Getter(name = "Uint8ClampedArray", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getUint8ClampedArray(Object self) {
    var global = Global.instanceFrom(self);
    if (global.uint8ClampedArray == LAZY_SENTINEL) {
      global.uint8ClampedArray = global.getBuiltinUint8ClampedArray();
    }
    return global.uint8ClampedArray;
  }

  /**
   * Setter for the Uint8ClampedArray property.
   * @param self self reference
   * @param value value of the Uint8ClampedArray property
   */
  @Setter(name = "Uint8ClampedArray", attributes = Attribute.NOT_ENUMERABLE)
  public static void setUint8ClampedArray(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.uint8ClampedArray = value;
  }

  private volatile Object uint8ClampedArray;

  /**
   * Getter for the Int16Array property.
   * @param self self reference
   * @return the value of the Int16Array property
   */
  @Getter(name = "Int16Array", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getInt16Array(Object self) {
    var global = Global.instanceFrom(self);
    if (global.int16Array == LAZY_SENTINEL) {
      global.int16Array = global.getBuiltinInt16Array();
    }
    return global.int16Array;
  }

  /**
   * Setter for the Int16Array property.
   * @param self self reference
   * @param value value of the Int16Array property
   */
  @Setter(name = "Int16Array", attributes = Attribute.NOT_ENUMERABLE)
  public static void setInt16Array(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.int16Array = value;
  }

  private volatile Object int16Array;

  /**
   * Getter for the Uint16Array property.
   * @param self self reference
   * @return the value of the Uint16Array property
   */
  @Getter(name = "Uint16Array", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getUint16Array(Object self) {
    var global = Global.instanceFrom(self);
    if (global.uint16Array == LAZY_SENTINEL) {
      global.uint16Array = global.getBuiltinUint16Array();
    }
    return global.uint16Array;
  }

  /**
   * Setter for the Uint16Array property.
   * @param self self reference
   * @param value value of the Uint16Array property
   */
  @Setter(name = "Uint16Array", attributes = Attribute.NOT_ENUMERABLE)
  public static void setUint16Array(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.uint16Array = value;
  }

  private volatile Object uint16Array;

  /**
   * Getter for the Int32Array property.
   * @param self self reference
   * @return the value of the Int32Array property
   */
  @Getter(name = "Int32Array", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getInt32Array(Object self) {
    var global = Global.instanceFrom(self);
    if (global.int32Array == LAZY_SENTINEL) {
      global.int32Array = global.getBuiltinInt32Array();
    }
    return global.int32Array;
  }

  /**
   * Setter for the Int32Array property.
   * @param self self reference
   * @param value value of the Int32Array property
   */
  @Setter(name = "Int32Array", attributes = Attribute.NOT_ENUMERABLE)
  public static void setInt32Array(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.int32Array = value;
  }

  private volatile Object int32Array;

  /**
   * Getter of the Uint32Array property.
   * @param self self reference
   * @return the value of the Uint32Array property
   */
  @Getter(name = "Uint32Array", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getUint32Array(Object self) {
    var global = Global.instanceFrom(self);
    if (global.uint32Array == LAZY_SENTINEL) {
      global.uint32Array = global.getBuiltinUint32Array();
    }
    return global.uint32Array;
  }

  /**
   * Setter of the Uint32Array property.
   * @param self self reference
   * @param value value of the Uint32Array property
   */
  @Setter(name = "Uint32Array", attributes = Attribute.NOT_ENUMERABLE)
  public static void setUint32Array(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.uint32Array = value;
  }

  private volatile Object uint32Array;

  /**
   * Getter for the Float32Array property.
   * @param self self reference
   * @return the value of the Float32Array property
   */
  @Getter(name = "Float32Array", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getFloat32Array(Object self) {
    var global = Global.instanceFrom(self);
    if (global.float32Array == LAZY_SENTINEL) {
      global.float32Array = global.getBuiltinFloat32Array();
    }
    return global.float32Array;
  }

  /**
   * Setter for the Float32Array property.
   * @param self self reference
   * @param value value of the Float32Array property
   */
  @Setter(name = "Float32Array", attributes = Attribute.NOT_ENUMERABLE)
  public static void setFloat32Array(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.float32Array = value;
  }

  private volatile Object float32Array;

  /**
   * Getter for the Float64Array property.
   * @param self self reference
   * @return the value of the Float64Array property
   */
  @Getter(name = "Float64Array", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getFloat64Array(Object self) {
    var global = Global.instanceFrom(self);
    if (global.float64Array == LAZY_SENTINEL) {
      global.float64Array = global.getBuiltinFloat64Array();
    }
    return global.float64Array;
  }

  /**
   * Setter for the Float64Array property.
   * @param self self reference
   * @param value value of the Float64Array property
   */
  @Setter(name = "Float64Array", attributes = Attribute.NOT_ENUMERABLE)
  public static void setFloat64Array(Object self, Object value) {
    var global = Global.instanceFrom(self);
    global.float64Array = value;
  }

  private volatile Object float64Array;

  /**
   * Getter for the Symbol property.
   * @param self self reference
   * @return  the value of the Symbol property
   */
  @Getter(name = "Symbol", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getSymbol(Object self) {
    var global = Global.instanceFrom(self);
    if (global.symbol == LAZY_SENTINEL) {
      global.symbol = global.getBuiltinSymbol();
    }
    return global.symbol;
  }

  /**
   * Setter for the Symbol property.
   * @param self self reference
   * @param value value of the Symbol property
   */
  @Setter(name = "Symbol", attributes = Attribute.NOT_ENUMERABLE)
  public static void setSymbol(Object self, Object value) {
    Global.instanceFrom(self).symbol = value;
  }

  private volatile Object symbol;

  /**
   * Getter for the Map property.
   * @param self self reference
   * @return  the value of the Map property
   */
  @Getter(name = "Map", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getMap(Object self) {
    var global = Global.instanceFrom(self);
    if (global.map == LAZY_SENTINEL) {
      global.map = global.getBuiltinMap();
    }
    return global.map;
  }

  /**
   * Setter for the Map property.
   * @param self self reference
   * @param value value of the Map property
   */
  @Setter(name = "Map", attributes = Attribute.NOT_ENUMERABLE)
  public static void setMap(Object self, Object value) {
    Global.instanceFrom(self).map = value;
  }

  private volatile Object map;

  /**
   * Getter for the WeakMap property.
   * @param self self reference
   * @return  the value of the WeakMap property
   */
  @Getter(name = "WeakMap", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getWeakMap(Object self) {
    var global = Global.instanceFrom(self);
    if (global.weakMap == LAZY_SENTINEL) {
      global.weakMap = global.getBuiltinWeakMap();
    }
    return global.weakMap;
  }

  /**
   * Setter for the WeakMap property.
   * @param self self reference
   * @param value value of the WeakMap property
   */
  @Setter(name = "WeakMap", attributes = Attribute.NOT_ENUMERABLE)
  public static void setWeakMap(Object self, Object value) {
    Global.instanceFrom(self).weakMap = value;
  }

  private volatile Object weakMap;

  /**
   * Getter for the Set property.
   * @param self self reference
   * @return  the value of the Set property
   */
  @Getter(name = "Set", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getSet(Object self) {
    var global = Global.instanceFrom(self);
    if (global.set == LAZY_SENTINEL) {
      global.set = global.getBuiltinSet();
    }
    return global.set;
  }

  /**
   * Setter for the Set property.
   * @param self self reference
   * @param value value of the Set property
   */
  @Setter(name = "Set", attributes = Attribute.NOT_ENUMERABLE)
  public static void setSet(Object self, Object value) {
    Global.instanceFrom(self).set = value;
  }

  private volatile Object set;

  /**
   * Getter for the WeakSet property.
   * @param self self reference
   * @return  the value of the WeakSet property
   */
  @Getter(name = "WeakSet", attributes = Attribute.NOT_ENUMERABLE)
  public static Object getWeakSet(Object self) {
    var global = Global.instanceFrom(self);
    if (global.weakSet == LAZY_SENTINEL) {
      global.weakSet = global.getBuiltinWeakSet();
    }
    return global.weakSet;
  }

  /**
   * Setter for the WeakSet property.
   * @param self self reference
   * @param value value of the WeakSet property
   */
  @Setter(name = "WeakSet", attributes = Attribute.NOT_ENUMERABLE)
  public static void setWeakSet(Object self, Object value) {
    Global.instanceFrom(self).weakSet = value;
  }

  private volatile Object weakSet;

  /** Nashorn extension: current script's file name */
  @Property(name = "__FILE__", attributes = Attribute.NON_ENUMERABLE_CONSTANT)
  public static final Object __FILE__ = LOCATION_PLACEHOLDER;

  /** Nashorn extension: current script's directory */
  @Property(name = "__DIR__", attributes = Attribute.NON_ENUMERABLE_CONSTANT)
  public static final Object __DIR__ = LOCATION_PLACEHOLDER;

  /** Nashorn extension: current source line number being executed */
  @Property(name = "__LINE__", attributes = Attribute.NON_ENUMERABLE_CONSTANT)
  public static final Object __LINE__ = LOCATION_PLACEHOLDER;

  private volatile NativeDate DEFAULT_DATE;

  /** Used as Date.prototype's default value */
  NativeDate getDefaultDate() {
    return DEFAULT_DATE;
  }

  private volatile NativeRegExp DEFAULT_REGEXP;

  /** Used as RegExp.prototype's default value */
  NativeRegExp getDefaultRegExp() {
    return DEFAULT_REGEXP;
  }

  /**
   * Built-in constructor objects: Even if user changes dynamic values of "Object", "Array" etc., we still want to keep original values of these constructors here.
   * For example, we need to be able to create array, regexp literals even after user overwrites global "Array" or "RegExp" constructor - see also ECMA 262 spec. Annex D.
   */
  private ScriptFunction builtinFunction;
  private ScriptFunction builtinObject;
  private ScriptFunction builtinArray;
  private ScriptFunction builtinBoolean;
  private ScriptFunction builtinDate;
  private ScriptObject builtinJSON;
  private ScriptFunction builtinJSAdapter;
  private ScriptObject builtinMath;
  private ScriptFunction builtinNumber;
  private ScriptFunction builtinRegExp;
  private ScriptFunction builtinString;
  private ScriptFunction builtinError;
  private ScriptFunction builtinEval;
  private ScriptFunction builtinEvalError;
  private ScriptFunction builtinRangeError;
  private ScriptFunction builtinReferenceError;
  private ScriptFunction builtinSyntaxError;
  private ScriptFunction builtinTypeError;
  private ScriptFunction builtinURIError;
  private ScriptFunction builtinArrayBuffer;
  private ScriptFunction builtinDataView;
  private ScriptFunction builtinInt8Array;
  private ScriptFunction builtinUint8Array;
  private ScriptFunction builtinUint8ClampedArray;
  private ScriptFunction builtinInt16Array;
  private ScriptFunction builtinUint16Array;
  private ScriptFunction builtinInt32Array;
  private ScriptFunction builtinUint32Array;
  private ScriptFunction builtinFloat32Array;
  private ScriptFunction builtinFloat64Array;
  private ScriptFunction builtinSymbol;
  private ScriptFunction builtinMap;
  private ScriptFunction builtinWeakMap;
  private ScriptFunction builtinSet;
  private ScriptFunction builtinWeakSet;
  private ScriptObject builtinIteratorPrototype;
  private ScriptObject builtinMapIteratorPrototype;
  private ScriptObject builtinSetIteratorPrototype;
  private ScriptObject builtinArrayIteratorPrototype;
  private ScriptObject builtinStringIteratorPrototype;

  // ECMA section 13.2.3 The [[ThrowTypeError]] Function Object
  private ScriptFunction typeErrorThrower;

  // Used to store the last RegExp result to support deprecated RegExp constructor properties
  private RegExpResult lastRegExpResult;

  private static final MethodHandle EVAL = findOwnMH_S("eval", Object.class, Object.class, Object.class);
  private static final MethodHandle NO_SUCH_PROPERTY = findOwnMH_S(NO_SUCH_PROPERTY_NAME, Object.class, Object.class, Object.class);
  private static final MethodHandle LEXICAL_SCOPE_FILTER = findOwnMH_S("lexicalScopeFilter", Object.class, Object.class);

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  // context to which this global belongs to
  private final Context context;

  // current ScriptContext to use - can be null.
  private ThreadLocal<ScriptContext> scontext;

  // current ScriptEngine associated - can be null.
  private ScriptEngine engine;

  // initial ScriptContext - usually null and only used for special case
  private volatile ScriptContext initscontext;

  // ES6 global lexical scope.
  private final LexicalScope lexicalScope;

  // Switchpoint for non-constant global callsites in the presence of ES6 lexical scope.
  private SwitchPoint lexicalScopeSwitchPoint;

  /**
   * Set the current script context
   * @param ctxt script context
   */
  public void setScriptContext(ScriptContext ctxt) {
    assert scontext != null;
    scontext.set(ctxt);
  }

  /**
   * Get the current script context
   * @return current script context
   */
  public ScriptContext getScriptContext() {
    assert scontext != null;
    return scontext.get();
  }

  /**
   * Set the initial script context
   * @param ctxt initial script context
   */
  public void setInitScriptContext(ScriptContext ctxt) {
    this.initscontext = ctxt;
  }

  ScriptContext currentContext() { 
    var sc = scontext != null ? scontext.get() : null;
    if (sc != null) {
      return sc;
    } else if (initscontext != null) {
      return initscontext;
    }
    return engine != null ? engine.getContext() : null;
  }

  @Override
  public Context getContext() {
    return context;
  }

  @Override
  protected boolean useDualFields() {
    return context.useDualFields();
  }

  // performs initialization checks for Global constructor and returns the PropertyMap, if everything is fine.
  static PropertyMap checkAndGetMap(Context context) {
    Objects.requireNonNull(context);
    return $nasgenmap$;
  }

  /**
   * Constructor
   *
   * @param context the context
   */
  public Global(Context context) {
    super(checkAndGetMap(context));
    this.context = context;
    this.lexicalScope = new LexicalScope(this);
  }

  /**
   * Script access to "current" Global instance
   * @return the global singleton
   */
  public static Global instance() {
    return Objects.requireNonNull(Context.getGlobal());
  }

  static Global instanceFrom(Object self) {
    return self instanceof Global ? (Global) self : instance();
  }

  /**
   * Check if we have a Global instance
   * @return true if one exists
   */
  public static boolean hasInstance() {
    return Context.getGlobal() != null;
  }

  /**
   * Script access to {@link ScriptEnvironment}
   * @return the script environment
   */
  static ScriptEnvironment getEnv() {
    return instance().getContext().getEnv();
  }

  /**
   * Script access to {@link Context}
   * @return the context
   */
  static Context getThisContext() {
    return instance().getContext();
  }

  // Runtime interface to Global

  /**
   * Is there a class filter in the current Context?
   * @return class filter
   */
  public ClassFilter getClassFilter() {
    return context.getClassFilter();
  }

  /**
   * Is this global of the given Context?
   * @param ctxt the context
   * @return true if this global belongs to the given Context
   */
  public boolean isOfContext(Context ctxt) {
    return this.context == ctxt;
  }

  /**
   * Initialize standard builtin objects like "Object", "Array", "Function" etc. as well as our extension builtin objects like "Java", "JSAdapter" as properties of the global scope object.
   * @param eng ScriptEngine to initialize
   */
  public void initBuiltinObjects(ScriptEngine eng) {
    if (this.builtinObject != null) {
      // already initialized, just return
      return;
    }
    TO_STRING = new InvokeByName("toString", ScriptObject.class);
    VALUE_OF = new InvokeByName("valueOf", ScriptObject.class);
    this.engine = eng;
    if (this.engine != null) {
      this.scontext = new ThreadLocal<>();
    }
    init(eng);
  }

  /**
   * Wrap a Java object as corresponding script object
   * @param obj object to wrap
   * @return    wrapped object
   */
  public Object wrapAsObject(Object obj) {
    if (obj instanceof Boolean b) {
      return new NativeBoolean(b, this);
    } else if (obj instanceof Number n) {
      return new NativeNumber(n.doubleValue(), this);
    } else if (isString(obj)) {
      return new NativeString((CharSequence) obj, this);
    } else if (obj instanceof Object[] o) { // extension
      return new NativeArray(ArrayData.allocate(o), this);
    } else if (obj instanceof double[] d) { // extension
      return new NativeArray(ArrayData.allocate(d), this);
    } else if (obj instanceof int[] i) {
      return new NativeArray(ArrayData.allocate(i), this);
    } else if (obj instanceof ArrayData a) {
      return new NativeArray(a, this);
    } else if (obj instanceof Symbol s) {
      return new NativeSymbol(s, this);
    } else {
      // FIXME: more special cases? Map? List?
      return obj;
    }
  }

  /**
   * Lookup helper for JS primitive types
   * @param request the link request for the dynamic call site.
   * @param self     self reference
   * @return guarded invocation
   */
  public static GuardedInvocation primitiveLookup(LinkRequest request, Object self) {
    if (isString(self)) {
      return NativeString.lookupPrimitive(request, self);
    } else if (self instanceof Number) {
      return NativeNumber.lookupPrimitive(request, self);
    } else if (self instanceof Boolean) {
      return NativeBoolean.lookupPrimitive(request, self);
    } else if (self instanceof Symbol) {
      return NativeSymbol.lookupPrimitive(request, self);
    }
    throw new IllegalArgumentException("Unsupported primitive: " + self);
  }

  /**
   * Returns a method handle that creates a wrapper object for a JS primitive value.
   * @param self receiver object
   * @return method handle to create wrapper objects for primitive receiver
   */
  public static MethodHandle getPrimitiveWrapFilter(Object self) {
    if (isString(self)) {
      return NativeString.WRAPFILTER;
    } else if (self instanceof Number) {
      return NativeNumber.WRAPFILTER;
    } else if (self instanceof Boolean) {
      return NativeBoolean.WRAPFILTER;
    }
    throw new IllegalArgumentException("Unsupported primitive: " + self);
  }

  /**
   * Create a new empty script object
   * @return the new ScriptObject
   */
  public ScriptObject newObject() {
    return useDualFields() ? new JD(getObjectPrototype()) : new JO(getObjectPrototype());
  }

  /**
   * Default value of given type
   * @param sobj     script object
   * @param typeHint type hint
   * @return default value
   */
  public Object getDefaultValue(ScriptObject sobj, Class<?> typeHint) {
    // When the [[DefaultValue]] internal method of O is called with no hint, then it behaves as if the hint were Number, unless O is a Date object in which case it behaves as if the hint were String.
    var hint = typeHint;
    if (hint == null) {
      hint = Number.class;
    }
    try {
      if (hint == String.class) {
        var toString = TO_STRING.getGetter().invokeExact(sobj);
        if (Bootstrap.isCallable(toString)) {
          var value = TO_STRING.getInvoker().invokeExact(toString, sobj);
          if (JSType.isPrimitive(value)) {
            return value;
          }
        }
        var valueOf = VALUE_OF.getGetter().invokeExact(sobj);
        if (Bootstrap.isCallable(valueOf)) {
          var value = VALUE_OF.getInvoker().invokeExact(valueOf, sobj);
          if (JSType.isPrimitive(value)) {
            return value;
          }
        }
        throw typeError(this, "cannot.get.default.string");
      }
      if (hint == Number.class) {
        var valueOf = VALUE_OF.getGetter().invokeExact(sobj);
        if (Bootstrap.isCallable(valueOf)) {
          var value = VALUE_OF.getInvoker().invokeExact(valueOf, sobj);
          if (JSType.isPrimitive(value)) {
            return value;
          }
        }
        var toString = TO_STRING.getGetter().invokeExact(sobj);
        if (Bootstrap.isCallable(toString)) {
          var value = TO_STRING.getInvoker().invokeExact(toString, sobj);
          if (JSType.isPrimitive(value)) {
            return value;
          }
        }
        throw typeError(this, "cannot.get.default.number");
      }
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
    return UNDEFINED;
  }

  /**
   * Is the given ScriptObject an ECMAScript Error object?
   * @param sobj the object being checked
   * @return true if sobj is an Error object
   */
  public boolean isError(ScriptObject sobj) {
    var errorProto = getErrorPrototype();
    var proto = sobj.getProto();
    while (proto != null) {
      if (proto == errorProto) {
        return true;
      }
      proto = proto.getProto();
    }
    return false;
  }

  /**
   * Create a new ECMAScript Error object.
   * @param msg error message
   * @return newly created Error object
   */
  public ScriptObject newError(String msg) {
    return new NativeError(msg, this);
  }

  /**
   * Create a new ECMAScript EvalError object.
   * @param msg error message
   * @return newly created EvalError object
   */
  public ScriptObject newEvalError(String msg) {
    return new NativeEvalError(msg, this);
  }

  /**
   * Create a new ECMAScript RangeError object.
   * @param msg error message
   * @return newly created RangeError object
   */
  public ScriptObject newRangeError(String msg) {
    return new NativeRangeError(msg, this);
  }

  /**
   * Create a new ECMAScript ReferenceError object.
   * @param msg error message
   * @return newly created ReferenceError object
   */
  public ScriptObject newReferenceError(String msg) {
    return new NativeReferenceError(msg, this);
  }

  /**
   * Create a new ECMAScript SyntaxError object.
   * @param msg error message
   * @return newly created SyntaxError object
   */
  public ScriptObject newSyntaxError(String msg) {
    return new NativeSyntaxError(msg, this);
  }

  /**
   * Create a new ECMAScript TypeError object.
   * @param msg error message
   * @return newly created TypeError object
   */
  public ScriptObject newTypeError(String msg) {
    return new NativeTypeError(msg, this);
  }

  /**
   * Create a new ECMAScript URIError object.
   * @param msg error message
   * @return newly created URIError object
   */
  public ScriptObject newURIError(String msg) {
    return new NativeURIError(msg, this);
  }

  /**
   * Create a new ECMAScript GenericDescriptor object.
   * @param configurable is the property configurable?
   * @param enumerable is the property enumerable?
   * @return newly created GenericDescriptor object
   */
  public PropertyDescriptor newGenericDescriptor(boolean configurable, boolean enumerable) {
    return new GenericPropertyDescriptor(configurable, enumerable, this);
  }

  /**
   * Create a new ECMAScript DatePropertyDescriptor object.
   * @param value of the data property
   * @param configurable is the property configurable?
   * @param enumerable is the property enumerable?
   * @param writable is the property writable?
   * @return newly created DataPropertyDescriptor object
   */
  public PropertyDescriptor newDataDescriptor(Object value, boolean configurable, boolean enumerable, boolean writable) {
    return new DataPropertyDescriptor(configurable, enumerable, writable, value, this);
  }

  /**
   * Create a new ECMAScript AccessorPropertyDescriptor object.
   * @param get getter function of the user accessor property
   * @param set setter function of the user accessor property
   * @param configurable is the property configurable?
   * @param enumerable is the property enumerable?
   * @return newly created AccessorPropertyDescriptor object
   */
  public PropertyDescriptor newAccessorDescriptor(Object get, Object set, boolean configurable, boolean enumerable) {
    var desc = new AccessorPropertyDescriptor(configurable, enumerable, get == null ? UNDEFINED : get, set == null ? UNDEFINED : set, this);
    if (get == null) {
      desc.delete(PropertyDescriptor.GET);
    }
    if (set == null) {
      desc.delete(PropertyDescriptor.SET);
    }
    return desc;
  }

  <T> T getLazilyCreatedValue(Object key, Callable<T> creator, Map<Object, T> map) {
    var obj = map.get(key);
    if (obj != null) {
      return obj;
    }
    var oldGlobal = Context.getGlobal();
    var differentGlobal = oldGlobal != this;
    try {
      if (differentGlobal) {
        Context.setGlobal(this);
      }
      var newObj = creator.call();
      var existingObj = map.putIfAbsent(key, newObj);
      return existingObj != null ? existingObj : newObj;
    } catch (Exception exp) {
      throw new RuntimeException(exp);
    } finally {
      if (differentGlobal) {
        Context.setGlobal(oldGlobal);
      }
    }
  }

  private final Map<Object, InvokeByName> namedInvokers = new ConcurrentHashMap<>();

  /**
   * Get cached InvokeByName object for the given key
   * @param key key to be associated with InvokeByName object
   * @param creator if InvokeByName is absent 'creator' is called to make one (lazy init)
   * @return InvokeByName object associated with the key.
   */
  public InvokeByName getInvokeByName(Object key, Callable<InvokeByName> creator) {
    return getLazilyCreatedValue(key, creator, namedInvokers);
  }

  private final Map<Object, MethodHandle> dynamicInvokers = new ConcurrentHashMap<>();

  /**
   * Get cached dynamic method handle for the given key
   * @param key key to be associated with dynamic method handle
   * @param creator if method handle is absent 'creator' is called to make one (lazy init)
   * @return dynamic method handle associated with the key.
   */
  public MethodHandle getDynamicInvoker(Object key, Callable<MethodHandle> creator) {
    return getLazilyCreatedValue(key, creator, dynamicInvokers);
  }

  /**
   * Hook to search missing variables in ScriptContext if available
   * @param self used to detect if scope call or not (this function is 'strict')
   * @param name name of the variable missing
   * @return value of the missing variable or undefined (or TypeError for scope search)
   */
  public static Object __noSuchProperty__(Object self, Object name) {
    var global = Global.instance();
    var sctxt = global.currentContext();
    var nameStr = name.toString();
    if (sctxt != null) {
      var scope = sctxt.getAttributesScope(nameStr);
      if (scope != -1) {
        return ScriptObjectMirror.unwrap(sctxt.getAttribute(nameStr, scope), global);
      }
    }
    if ("context".equals(nameStr)) {
      return sctxt;
    } else if ("engine".equals(nameStr)) {
      // expose "engine" variable only when there is no security manager
      // or when no class filter is set.
      if (global.getClassFilter() == null) {
        return global.engine;
      }
    }
    if (self == UNDEFINED) {
      // scope access and so throw ReferenceError
      throw referenceError(global, "not.defined", nameStr);
    }
    return UNDEFINED;
  }

  /**
   * This is the eval used when 'indirect' eval call is made.
   * <pre>
   * Global global = this;
   * global.eval("print('hello')");
   * </pre>
   * @param self  eval scope
   * @param str   eval string
   * @return the result of eval
   */
  public static Object eval(Object self, Object str) {
    return directEval(self, str, Global.instanceFrom(self), UNDEFINED);
  }

  /**
   * Direct eval
   * @param self     The scope of eval passed as 'self'
   * @param str      Evaluated code
   * @param callThis "this" to be passed to the evaluated code
   * @param location location of the eval call
   * @return the return value of the eval
   * This is directly invoked from generated when eval(code) is called in user code
   */
  public static Object directEval(Object self, Object str, Object callThis, Object location) {
    if (!isString(str)) {
      return str;
    }
    var global = Global.instanceFrom(self);
    var scope = self instanceof ScriptObject && ((ScriptObject) self).isScope() ? (ScriptObject) self : global;
    return global.getContext().eval(scope, str.toString(), callThis, location, true);
  }

  // builtin prototype accessors

  /**
   * Get the builtin Object prototype.
   * @return the Object prototype.
   */
  public ScriptObject getObjectPrototype() {
    return ScriptFunction.getPrototype(builtinObject);
  }

  /**
   * Get the builtin Function prototype.
   * @return the Function prototype.
   */
  public ScriptObject getFunctionPrototype() {
    return ScriptFunction.getPrototype(builtinFunction);
  }

  /**
   * Get the builtin Array prototype.
   * @return the Array prototype
   */
  public ScriptObject getArrayPrototype() {
    return ScriptFunction.getPrototype(builtinArray);
  }

  ScriptObject getBooleanPrototype() {
    return ScriptFunction.getPrototype(builtinBoolean);
  }

  ScriptObject getNumberPrototype() {
    return ScriptFunction.getPrototype(builtinNumber);
  }

  ScriptObject getDatePrototype() {
    return ScriptFunction.getPrototype(getBuiltinDate());
  }

  ScriptObject getRegExpPrototype() {
    return ScriptFunction.getPrototype(getBuiltinRegExp());
  }

  ScriptObject getStringPrototype() {
    return ScriptFunction.getPrototype(builtinString);
  }

  ScriptObject getErrorPrototype() {
    return ScriptFunction.getPrototype(builtinError);
  }

  ScriptObject getEvalErrorPrototype() {
    return ScriptFunction.getPrototype(getBuiltinEvalError());
  }

  ScriptObject getRangeErrorPrototype() {
    return ScriptFunction.getPrototype(getBuiltinRangeError());
  }

  ScriptObject getReferenceErrorPrototype() {
    return ScriptFunction.getPrototype(builtinReferenceError);
  }

  ScriptObject getSyntaxErrorPrototype() {
    return ScriptFunction.getPrototype(builtinSyntaxError);
  }

  ScriptObject getTypeErrorPrototype() {
    return ScriptFunction.getPrototype(builtinTypeError);
  }

  ScriptObject getURIErrorPrototype() {
    return ScriptFunction.getPrototype(getBuiltinURIError());
  }

  ScriptObject getJSAdapterPrototype() {
    return ScriptFunction.getPrototype(getBuiltinJSAdapter());
  }

  ScriptObject getSymbolPrototype() {
    return ScriptFunction.getPrototype(getBuiltinSymbol());
  }

  ScriptObject getMapPrototype() {
    return ScriptFunction.getPrototype(getBuiltinMap());
  }

  ScriptObject getWeakMapPrototype() {
    return ScriptFunction.getPrototype(getBuiltinWeakMap());
  }

  ScriptObject getSetPrototype() {
    return ScriptFunction.getPrototype(getBuiltinSet());
  }

  ScriptObject getWeakSetPrototype() {
    return ScriptFunction.getPrototype(getBuiltinWeakSet());
  }

  ScriptObject getIteratorPrototype() {
    if (builtinIteratorPrototype == null) {
      builtinIteratorPrototype = initPrototype("AbstractIterator", getObjectPrototype());
    }
    return builtinIteratorPrototype;
  }

  ScriptObject getMapIteratorPrototype() {
    if (builtinMapIteratorPrototype == null) {
      builtinMapIteratorPrototype = initPrototype("MapIterator", getIteratorPrototype());
    }
    return builtinMapIteratorPrototype;
  }

  ScriptObject getSetIteratorPrototype() {
    if (builtinSetIteratorPrototype == null) {
      builtinSetIteratorPrototype = initPrototype("SetIterator", getIteratorPrototype());
    }
    return builtinSetIteratorPrototype;
  }

  ScriptObject getArrayIteratorPrototype() {
    if (builtinArrayIteratorPrototype == null) {
      builtinArrayIteratorPrototype = initPrototype("ArrayIterator", getIteratorPrototype());
    }
    return builtinArrayIteratorPrototype;
  }

  ScriptObject getStringIteratorPrototype() {
    if (builtinStringIteratorPrototype == null) {
      builtinStringIteratorPrototype = initPrototype("StringIterator", getIteratorPrototype());
    }
    return builtinStringIteratorPrototype;
  }

  synchronized ScriptFunction getBuiltinArrayBuffer() {
    if (this.builtinArrayBuffer == null) {
      this.builtinArrayBuffer = initConstructorAndSwitchPoint("ArrayBuffer", ScriptFunction.class);
    }
    return this.builtinArrayBuffer;
  }

  ScriptObject getArrayBufferPrototype() {
    return ScriptFunction.getPrototype(getBuiltinArrayBuffer());
  }

  synchronized ScriptFunction getBuiltinDataView() {
    if (this.builtinDataView == null) {
      this.builtinDataView = initConstructorAndSwitchPoint("DataView", ScriptFunction.class);
    }
    return this.builtinDataView;
  }

  ScriptObject getDataViewPrototype() {
    return ScriptFunction.getPrototype(getBuiltinDataView());
  }

  synchronized ScriptFunction getBuiltinInt8Array() {
    if (this.builtinInt8Array == null) {
      this.builtinInt8Array = initConstructorAndSwitchPoint("Int8Array", ScriptFunction.class);
    }
    return this.builtinInt8Array;
  }

  ScriptObject getInt8ArrayPrototype() {
    return ScriptFunction.getPrototype(getBuiltinInt8Array());
  }

  synchronized ScriptFunction getBuiltinUint8Array() {
    if (this.builtinUint8Array == null) {
      this.builtinUint8Array = initConstructorAndSwitchPoint("Uint8Array", ScriptFunction.class);
    }
    return this.builtinUint8Array;
  }

  ScriptObject getUint8ArrayPrototype() {
    return ScriptFunction.getPrototype(getBuiltinUint8Array());
  }

  synchronized ScriptFunction getBuiltinUint8ClampedArray() {
    if (this.builtinUint8ClampedArray == null) {
      this.builtinUint8ClampedArray = initConstructorAndSwitchPoint("Uint8ClampedArray", ScriptFunction.class);
    }
    return this.builtinUint8ClampedArray;
  }

  ScriptObject getUint8ClampedArrayPrototype() {
    return ScriptFunction.getPrototype(getBuiltinUint8ClampedArray());
  }

  synchronized ScriptFunction getBuiltinInt16Array() {
    if (this.builtinInt16Array == null) {
      this.builtinInt16Array = initConstructorAndSwitchPoint("Int16Array", ScriptFunction.class);
    }
    return this.builtinInt16Array;
  }

  ScriptObject getInt16ArrayPrototype() {
    return ScriptFunction.getPrototype(getBuiltinInt16Array());
  }

  synchronized ScriptFunction getBuiltinUint16Array() {
    if (this.builtinUint16Array == null) {
      this.builtinUint16Array = initConstructorAndSwitchPoint("Uint16Array", ScriptFunction.class);
    }
    return this.builtinUint16Array;
  }

  ScriptObject getUint16ArrayPrototype() {
    return ScriptFunction.getPrototype(getBuiltinUint16Array());
  }

  synchronized ScriptFunction getBuiltinInt32Array() {
    if (this.builtinInt32Array == null) {
      this.builtinInt32Array = initConstructorAndSwitchPoint("Int32Array", ScriptFunction.class);
    }
    return this.builtinInt32Array;
  }

  ScriptObject getInt32ArrayPrototype() {
    return ScriptFunction.getPrototype(getBuiltinInt32Array());
  }

  synchronized ScriptFunction getBuiltinUint32Array() {
    if (this.builtinUint32Array == null) {
      this.builtinUint32Array = initConstructorAndSwitchPoint("Uint32Array", ScriptFunction.class);
    }
    return this.builtinUint32Array;
  }

  ScriptObject getUint32ArrayPrototype() {
    return ScriptFunction.getPrototype(getBuiltinUint32Array());
  }

  synchronized ScriptFunction getBuiltinFloat32Array() {
    if (this.builtinFloat32Array == null) {
      this.builtinFloat32Array = initConstructorAndSwitchPoint("Float32Array", ScriptFunction.class);
    }
    return this.builtinFloat32Array;
  }

  ScriptObject getFloat32ArrayPrototype() {
    return ScriptFunction.getPrototype(getBuiltinFloat32Array());
  }

  synchronized ScriptFunction getBuiltinFloat64Array() {
    if (this.builtinFloat64Array == null) {
      this.builtinFloat64Array = initConstructorAndSwitchPoint("Float64Array", ScriptFunction.class);
    }
    return this.builtinFloat64Array;
  }

  ScriptObject getFloat64ArrayPrototype() {
    return ScriptFunction.getPrototype(getBuiltinFloat64Array());
  }

  /**
   * Return the function that throws TypeError unconditionally. Used as "poison" methods for certain Function properties.
   * @return the TypeError throwing function
   */
  public ScriptFunction getTypeErrorThrower() {
    return typeErrorThrower;
  }

  synchronized ScriptFunction getBuiltinDate() {
    if (this.builtinDate == null) {
      this.builtinDate = initConstructorAndSwitchPoint("Date", ScriptFunction.class);
      var dateProto = ScriptFunction.getPrototype(builtinDate);
      // initialize default date
      this.DEFAULT_DATE = new NativeDate(NaN, dateProto);
    }
    return this.builtinDate;
  }

  synchronized ScriptFunction getBuiltinEvalError() {
    if (this.builtinEvalError == null) {
      this.builtinEvalError = initErrorSubtype("EvalError", getErrorPrototype());
    }
    return this.builtinEvalError;
  }

  ScriptFunction getBuiltinFunction() {
    return builtinFunction;
  }

  /**
   * Get the switchpoint used to check property changes for Function.prototype.apply
   * @return the switchpoint guarding apply (same as guarding call, and everything else in function)
   */
  public static SwitchPoint getBuiltinFunctionApplySwitchPoint() {
    return ScriptFunction.getPrototype(Global.instance().getBuiltinFunction()).getProperty("apply").getBuiltinSwitchPoint();
  }

  static boolean isBuiltinFunctionProperty(String name) {
    var instance = Global.instance();
    var builtinFunction = instance.getBuiltinFunction();
    if (builtinFunction == null) {
      return false; //conservative for compile-only mode
    }
    var isBuiltinFunction = instance.function == builtinFunction;
    return isBuiltinFunction && ScriptFunction.getPrototype(builtinFunction).getProperty(name).isBuiltin();
  }

  /**
   * Check if the Function.prototype.apply has not been replaced
   * @return true if Function.prototype.apply has been replaced
   */
  public static boolean isBuiltinFunctionPrototypeApply() {
    return isBuiltinFunctionProperty("apply");
  }

  /**
   * Check if the Function.prototype.apply has not been replaced
   * @return true if Function.prototype.call has been replaced
   */
  public static boolean isBuiltinFunctionPrototypeCall() {
    return isBuiltinFunctionProperty("call");
  }

  synchronized ScriptFunction getBuiltinJSAdapter() {
    if (this.builtinJSAdapter == null) {
      this.builtinJSAdapter = initConstructorAndSwitchPoint("JSAdapter", ScriptFunction.class);
    }
    return builtinJSAdapter;
  }

  synchronized ScriptObject getBuiltinJSON() {
    if (this.builtinJSON == null) {
      this.builtinJSON = initConstructorAndSwitchPoint("JSON", ScriptObject.class);
    }
    return this.builtinJSON;
  }

  synchronized ScriptFunction getBuiltinRangeError() {
    if (this.builtinRangeError == null) {
      this.builtinRangeError = initErrorSubtype("RangeError", getErrorPrototype());
    }
    return builtinRangeError;
  }

  synchronized ScriptFunction getBuiltinRegExp() {
    if (this.builtinRegExp == null) {
      this.builtinRegExp = initConstructorAndSwitchPoint("RegExp", ScriptFunction.class);
      var regExpProto = ScriptFunction.getPrototype(builtinRegExp);
      // initialize default regexp object
      this.DEFAULT_REGEXP = new NativeRegExp("(?:)", "", this, regExpProto);
      // RegExp.prototype should behave like a RegExp object. So copy the properties.
      regExpProto.addBoundProperties(DEFAULT_REGEXP);
    }
    return builtinRegExp;
  }

  synchronized ScriptFunction getBuiltinURIError() {
    if (this.builtinURIError == null) {
      this.builtinURIError = initErrorSubtype("URIError", getErrorPrototype());
    }
    return this.builtinURIError;
  }

  synchronized ScriptFunction getBuiltinSymbol() {
    if (this.builtinSymbol == null) {
      this.builtinSymbol = initConstructorAndSwitchPoint("Symbol", ScriptFunction.class);
    }
    return this.builtinSymbol;
  }

  synchronized ScriptFunction getBuiltinMap() {
    if (this.builtinMap == null) {
      this.builtinMap = initConstructorAndSwitchPoint("Map", ScriptFunction.class);
    }
    return this.builtinMap;
  }

  synchronized ScriptFunction getBuiltinWeakMap() {
    if (this.builtinWeakMap == null) {
      this.builtinWeakMap = initConstructorAndSwitchPoint("WeakMap", ScriptFunction.class);
    }
    return this.builtinWeakMap;
  }

  synchronized ScriptFunction getBuiltinSet() {
    if (this.builtinSet == null) {
      this.builtinSet = initConstructorAndSwitchPoint("Set", ScriptFunction.class);
    }
    return this.builtinSet;
  }

  synchronized ScriptFunction getBuiltinWeakSet() {
    if (this.builtinWeakSet == null) {
      this.builtinWeakSet = initConstructorAndSwitchPoint("WeakSet", ScriptFunction.class);
    }
    return this.builtinWeakSet;
  }

  @Override
  public String getClassName() {
    return "global";
  }

  /**
   * Copy function used to clone NativeRegExp objects.
   * @param regexp a NativeRegExp to clone
   * @return copy of the given regexp object
   */
  public static Object regExpCopy(Object regexp) {
    return new NativeRegExp((NativeRegExp) regexp);
  }

  /**
   * Convert given object to NativeRegExp type.
   * @param obj object to be converted
   * @return NativeRegExp instance
   */
  public static NativeRegExp toRegExp(Object obj) {
    return (obj instanceof NativeRegExp nre) ? nre : new NativeRegExp(JSType.toString(obj));
  }

  /**
   * ECMA 9.9 ToObject implementation
   * @param obj  an item for which to run ToObject
   * @return ToObject version of given item
   */
  public static Object toObject(Object obj) {
    if (obj == null || obj == UNDEFINED) {
      throw typeError("not.an.object", ScriptRuntime.safeToString(obj));
    }
    return (obj instanceof ScriptObject) ? obj : instance().wrapAsObject(obj);
  }

  /**
   * Allocate a new object array.
   * @param initial object values.
   * @return the new array
   */
  public static NativeArray allocate(Object[] initial) {
    var arrayData = ArrayData.allocate(initial);
    for (var index = 0; index < initial.length; index++) {
      var value = initial[index];
      if (value == ScriptRuntime.EMPTY) {
        arrayData = arrayData.delete(index);
      }
    }
    return new NativeArray(arrayData);
  }

  /**
   * Allocate a new number array.
   * @param initial number values.
   * @return the new array
   */
  public static NativeArray allocate(double[] initial) {
    return new NativeArray(ArrayData.allocate(initial));
  }

  /**
   * Allocate a new integer array.
   * @param initial number values.
   * @return the new array
   */
  public static NativeArray allocate(int[] initial) {
    return new NativeArray(ArrayData.allocate(initial));
  }

  /**
   * Allocate a new object array for arguments.
   * @param arguments initial arguments passed.
   * @param callee reference to the function that uses arguments object
   * @param numParams actual number of declared parameters
   *
   * @return the new array
   */
  public static ScriptObject allocateArguments(Object[] arguments, Object callee, int numParams) {
    var global = Global.instance();
    var proto = global.getObjectPrototype();
    return new NativeArguments(arguments, numParams, proto);
  }

  /**
   * Called from generated to check if given function is the builtin 'eval'.
   * If eval is used in a script, a lot of optimizations and assumptions cannot be done.
   * @param  fn function object that is checked
   * @return true if fn is the builtin eval
   */
  public static boolean isEval(Object fn) {
    return fn == Global.instance().builtinEval;
  }

  /**
   * Called from generated to replace a location property placeholder with the actual location property value.
   * @param  placeholder the value tested for being a placeholder for a location property
   * @param  locationProperty the actual value for the location property
   * @return locationProperty if placeholder is indeed a placeholder for a location property, the placeholder otherwise
   */
  public static Object replaceLocationPropertyPlaceholder(Object placeholder, Object locationProperty) {
    return isLocationPropertyPlaceholder(placeholder) ? locationProperty : placeholder;
  }

  /**
   * Called from runtime internals to check if the passed value is a location property placeholder.
   * @param  placeholder the value tested for being a placeholder for a location property
   * @return true if the value is a placeholder, false otherwise.
   */
  public static boolean isLocationPropertyPlaceholder(Object placeholder) {
    return placeholder == LOCATION_PLACEHOLDER;
  }

  /**
   * Create a new RegExp object.
   * @param expression Regular expression.
   * @param options    Search options.
   * @return New RegExp object.
   */
  public static Object newRegExp(String expression, String options) {
    return (options == null) ? new NativeRegExp(expression) : new NativeRegExp(expression, options);
  }

  /**
   * Get the object prototype
   * @return the object prototype
   */
  public static ScriptObject objectPrototype() {
    return Global.instance().getObjectPrototype();
  }

  /**
   * Create a new empty object instance.
   * @return New empty object.
   */
  public static ScriptObject newEmptyInstance() {
    return Global.instance().newObject();
  }

  /**
   * Check if a given object is a ScriptObject, raises an exception if this is not the case
   * @param obj and object to check
   * @return the script object
   */
  public static ScriptObject checkObject(Object obj) {
    if (!(obj instanceof ScriptObject)) {
      throw typeError("not.an.object", ScriptRuntime.safeToString(obj));
    }
    return (ScriptObject) obj;
  }

  /**
   * ECMA 9.10 - implementation of CheckObjectCoercible, i.e. raise an exception if this object is null or undefined.
   * @param obj an object to check
   */
  public static void checkObjectCoercible(Object obj) {
    if (obj == null || obj == UNDEFINED) {
      throw typeError("not.an.object", ScriptRuntime.safeToString(obj));
    }
  }

  /**
   * Return the ES6 global scope for lexically declared bindings.
   * @return the ES6 lexical global scope.
   */
  public final ScriptObject getLexicalScope() {
    return lexicalScope;
  }

  @Override
  public void addBoundProperties(ScriptObject source, es.runtime.Property[] properties) {
    var ownMap = getMap();
    var hasLexicalDefinitions = false;
    var lexScope = (LexicalScope) getLexicalScope();
    var lexicalMap = lexScope.getMap();
    for (var property : properties) {
      if (property.isLexicalBinding()) {
        hasLexicalDefinitions = true;
      }
      // ES6 15.1.8 steps 6. and 7.
      var globalProperty = ownMap.findProperty(property.getKey());
      if (globalProperty != null && !globalProperty.isConfigurable() && property.isLexicalBinding()) {
        throw ECMAErrors.syntaxError("redeclare.variable", property.getKey().toString());
      }
      var lexicalProperty = lexicalMap.findProperty(property.getKey());
      if (lexicalProperty != null && !property.isConfigurable()) {
        throw ECMAErrors.syntaxError("redeclare.variable", property.getKey().toString());
      }
    }
    var extensible = isExtensible();
    for (var property : properties) {
      if (property.isLexicalBinding()) {
        assert lexScope != null;
        lexicalMap = lexScope.addBoundProperty(lexicalMap, source, property, true);
        if (ownMap.findProperty(property.getKey()) != null) {
          // If property exists in the global object invalidate any global constant call sites.
          invalidateGlobalConstant(property.getKey());
        }
      } else {
        ownMap = addBoundProperty(ownMap, source, property, extensible);
      }
    }
    setMap(ownMap);
    if (hasLexicalDefinitions) {
      assert lexScope != null;
      lexScope.setMap(lexicalMap);
      invalidateLexicalSwitchPoint();
    }
  }

  @Override
  public GuardedInvocation findGetMethod(CallSiteDescriptor desc, LinkRequest request) {
    var name = NashornCallSiteDescriptor.getOperand(desc);
    var isScope = NashornCallSiteDescriptor.isScope(desc);
    if (lexicalScope != null && isScope && !NashornCallSiteDescriptor.isApplyToCall(desc)) {
      if (lexicalScope.hasOwnProperty(name)) {
        return lexicalScope.findGetMethod(desc, request);
      }
    }
    var invocation = super.findGetMethod(desc, request);
    // We want to avoid adding our generic lexical scope switchpoint to global constant invocations, because those are invalidated per-key in the addBoundProperties method above.
    // We therefore check if the invocation does already have a switchpoint and the property is non-inherited, assuming this only applies to global constants.
    // If other non-inherited properties will start using switchpoints some time in the future we'll have to revisit this.
    if (isScope && (invocation.getSwitchPoints() == null || !hasOwnProperty(name))) {
      return invocation.addSwitchPoint(getLexicalScopeSwitchPoint());
    }
    return invocation;
  }

  @Override
  protected FindProperty findProperty(Object key, boolean deep, boolean isScope, ScriptObject start) {
    if (lexicalScope != null && isScope) {
      var find = lexicalScope.findProperty(key, false);
      if (find != null) {
        return find;
      }
    }
    return super.findProperty(key, deep, isScope, start);
  }

  @Override
  public GuardedInvocation findSetMethod(CallSiteDescriptor desc, LinkRequest request) {
    var isScope = NashornCallSiteDescriptor.isScope(desc);
    if (lexicalScope != null && isScope) {
      var name = NashornCallSiteDescriptor.getOperand(desc);
      if (lexicalScope.hasOwnProperty(name)) {
        return lexicalScope.findSetMethod(desc, request);
      }
    }
    var invocation = super.findSetMethod(desc, request);
    if (isScope) {
      return invocation.addSwitchPoint(getLexicalScopeSwitchPoint());
    }
    return invocation;
  }

  synchronized SwitchPoint getLexicalScopeSwitchPoint() {
    var switchPoint = lexicalScopeSwitchPoint;
    if (switchPoint == null || switchPoint.hasBeenInvalidated()) {
      switchPoint = lexicalScopeSwitchPoint = new SwitchPoint();
    }
    return switchPoint;
  }

  synchronized void invalidateLexicalSwitchPoint() {
    if (lexicalScopeSwitchPoint != null) {
      SwitchPoint.invalidateAll(new SwitchPoint[]{lexicalScopeSwitchPoint});
    }
  }

  @SuppressWarnings("unused")
  static Object lexicalScopeFilter(Object self) {
    return (self instanceof Global g) ? g.getLexicalScope() : self;
  }

  <T extends ScriptObject> T initConstructorAndSwitchPoint(String name, Class<T> clazz) {
    var func = initConstructor(name, clazz);
    tagBuiltinProperties(name, func);
    return func;
  }

  void init(ScriptEngine eng) {
    assert Context.getGlobal() == this : "this global is not set as current";
    var env = getContext().getEnv();
    // initialize Function and Object constructor
    initFunctionAndObject();
    // Now fix Global's own proto.
    this.setInitialProto(getObjectPrototype());
    // initialize global function properties
    this.eval = this.builtinEval = ScriptFunction.createBuiltin("eval", EVAL);
    this.parseInt = ScriptFunction.createBuiltin("parseInt", GlobalFunctions.PARSEINT, new Specialization[]{
      new Specialization(GlobalFunctions.PARSEINT_Z),
      new Specialization(GlobalFunctions.PARSEINT_I),
      new Specialization(GlobalFunctions.PARSEINT_OI),
      new Specialization(GlobalFunctions.PARSEINT_O)
    });
    this.parseFloat = ScriptFunction.createBuiltin("parseFloat", GlobalFunctions.PARSEFLOAT);
    this.isNaN = ScriptFunction.createBuiltin("isNaN", GlobalFunctions.IS_NAN, new Specialization[]{
      new Specialization(GlobalFunctions.IS_NAN_I),
      new Specialization(GlobalFunctions.IS_NAN_J),
      new Specialization(GlobalFunctions.IS_NAN_D)
    });
    this.parseFloat = ScriptFunction.createBuiltin("parseFloat", GlobalFunctions.PARSEFLOAT);
    this.isNaN = ScriptFunction.createBuiltin("isNaN", GlobalFunctions.IS_NAN);
    this.isFinite = ScriptFunction.createBuiltin("isFinite", GlobalFunctions.IS_FINITE);
    this.encodeURI = ScriptFunction.createBuiltin("encodeURI", GlobalFunctions.ENCODE_URI);
    this.encodeURIComponent = ScriptFunction.createBuiltin("encodeURIComponent", GlobalFunctions.ENCODE_URICOMPONENT);
    this.decodeURI = ScriptFunction.createBuiltin("decodeURI", GlobalFunctions.DECODE_URI);
    this.decodeURIComponent = ScriptFunction.createBuiltin("decodeURIComponent", GlobalFunctions.DECODE_URICOMPONENT);
    this.escape = ScriptFunction.createBuiltin("escape", GlobalFunctions.ESCAPE);
    this.unescape = ScriptFunction.createBuiltin("unescape", GlobalFunctions.UNESCAPE);
    // built-in constructors
    this.builtinArray = initConstructorAndSwitchPoint("Array", ScriptFunction.class);
    this.builtinBoolean = initConstructorAndSwitchPoint("Boolean", ScriptFunction.class);
    this.builtinNumber = initConstructorAndSwitchPoint("Number", ScriptFunction.class);
    this.builtinString = initConstructorAndSwitchPoint("String", ScriptFunction.class);
    this.builtinMath = initConstructorAndSwitchPoint("Math", ScriptObject.class);
    // initialize String.prototype.length to 0
    // add String.prototype.length
    var stringPrototype = getStringPrototype();
    stringPrototype.addOwnProperty("length", Attribute.NON_ENUMERABLE_CONSTANT, 0.0);
    // set isArray flag on Array.prototype
    var arrayPrototype = getArrayPrototype();
    arrayPrototype.setIsArray();
    this.symbol = LAZY_SENTINEL;
    this.map = LAZY_SENTINEL;
    this.weakMap = LAZY_SENTINEL;
    this.set = LAZY_SENTINEL;
    this.weakSet = LAZY_SENTINEL;
    // Error stuff
    initErrorObjects();
    // nasgen-created global properties related to java access
    // "Java", "JavaImporter","Packages", "java"
    if (!env._no_typed_arrays) {
      this.arrayBuffer = LAZY_SENTINEL;
      this.dataView = LAZY_SENTINEL;
      this.int8Array = LAZY_SENTINEL;
      this.uint8Array = LAZY_SENTINEL;
      this.uint8ClampedArray = LAZY_SENTINEL;
      this.int16Array = LAZY_SENTINEL;
      this.uint16Array = LAZY_SENTINEL;
      this.int32Array = LAZY_SENTINEL;
      this.uint32Array = LAZY_SENTINEL;
      this.float32Array = LAZY_SENTINEL;
      this.float64Array = LAZY_SENTINEL;
    }
    copyBuiltins();
    if (eng != null) {
      // default file name
      addOwnProperty(ScriptEngine.FILENAME, Attribute.NOT_ENUMERABLE, null);
      // __noSuchProperty__ hook for ScriptContext search of missing variables
      var noSuchProp = ScriptFunction.createBuiltin(NO_SUCH_PROPERTY_NAME, NO_SUCH_PROPERTY);
      addOwnProperty(NO_SUCH_PROPERTY_NAME, Attribute.NOT_ENUMERABLE, noSuchProp);
    }
  }

  void initErrorObjects() {
    // Error objects
    this.builtinError = initConstructor("Error", ScriptFunction.class);
    var errorProto = getErrorPrototype();
    // Nashorn specific accessors on Error.prototype - stack, lineNumber, columnNumber and fileName
    var getStack = ScriptFunction.createBuiltin("getStack", NativeError.GET_STACK);
    var setStack = ScriptFunction.createBuiltin("setStack", NativeError.SET_STACK);
    errorProto.addOwnProperty("stack", Attribute.NOT_ENUMERABLE, getStack, setStack);
    var getLineNumber = ScriptFunction.createBuiltin("getLineNumber", NativeError.GET_LINENUMBER);
    var setLineNumber = ScriptFunction.createBuiltin("setLineNumber", NativeError.SET_LINENUMBER);
    errorProto.addOwnProperty("lineNumber", Attribute.NOT_ENUMERABLE, getLineNumber, setLineNumber);
    var getColumnNumber = ScriptFunction.createBuiltin("getColumnNumber", NativeError.GET_COLUMNNUMBER);
    var setColumnNumber = ScriptFunction.createBuiltin("setColumnNumber", NativeError.SET_COLUMNNUMBER);
    errorProto.addOwnProperty("columnNumber", Attribute.NOT_ENUMERABLE, getColumnNumber, setColumnNumber);
    var getFileName = ScriptFunction.createBuiltin("getFileName", NativeError.GET_FILENAME);
    var setFileName = ScriptFunction.createBuiltin("setFileName", NativeError.SET_FILENAME);
    errorProto.addOwnProperty("fileName", Attribute.NOT_ENUMERABLE, getFileName, setFileName);
    // ECMA 15.11.4.2 Error.prototype.name
    // Error.prototype.name = "Error";
    errorProto.set(NativeError.NAME, "Error", 0);
    // ECMA 15.11.4.3 Error.prototype.message
    // Error.prototype.message = "";
    errorProto.set(NativeError.MESSAGE, "", 0);
    tagBuiltinProperties("Error", builtinError);
    this.builtinReferenceError = initErrorSubtype("ReferenceError", errorProto);
    this.builtinSyntaxError = initErrorSubtype("SyntaxError", errorProto);
    this.builtinTypeError = initErrorSubtype("TypeError", errorProto);
  }

  ScriptFunction initErrorSubtype(String name, ScriptObject errorProto) {
    var cons = initConstructor(name, ScriptFunction.class);
    var prototype = ScriptFunction.getPrototype(cons);
    prototype.set(NativeError.NAME, name, 0);
    prototype.set(NativeError.MESSAGE, "", 0);
    prototype.setInitialProto(errorProto);
    tagBuiltinProperties(name, cons);
    return cons;
  }

  static void copyOptions(ScriptObject options, ScriptEnvironment scriptEnv) {
    for (var f : scriptEnv.getClass().getFields()) {
      try {
        options.set(f.getName(), f.get(scriptEnv), 0);
      } catch (IllegalArgumentException | IllegalAccessException exp) {
        throw new RuntimeException(exp);
      }
    }
  }

  void copyBuiltins() {
    this.array = this.builtinArray;
    this._boolean = this.builtinBoolean;
    this.error = this.builtinError;
    this.function = this.builtinFunction;
    this.math = this.builtinMath;
    this.number = this.builtinNumber;
    this.object = this.builtinObject;
    this.referenceError = this.builtinReferenceError;
    this.string = this.builtinString;
    this.syntaxError = this.builtinSyntaxError;
    this.typeError = this.builtinTypeError;
  }

  public static Object printImpl(Object self, boolean stdout) {
    var global = Global.instanceFrom(self);
    var sc = global.currentContext();
    return stdout
      ? (sc != null ? sc.getWriter() : global.getContext().getEnv().getOut())
      : (sc != null ? sc.getErrorWriter() : global.getContext().getEnv().getErr());
  }
  
  <T extends ScriptObject> T initConstructor(String name, Class<T> type) {
    try {
      // Assuming class name pattern for built-in JS constructors.
      var sb = new StringBuilder(PACKAGE_PREFIX);
      sb.append("Native");
      sb.append(name);
      sb.append("$Constructor");
      var funcClass = Class.forName(sb.toString());
      var res = type.cast(funcClass.getDeclaredConstructor().newInstance());
      assert res != null;
      if (res instanceof ScriptFunction func) {
        // All global constructor prototypes are not-writable, not-enumerable and not-configurable.
        func.modifyOwnProperty(func.getProperty("prototype"), Attribute.NON_ENUMERABLE_CONSTANT);
      }
      if (res.getProto() == null) {
        res.setInitialProto(getObjectPrototype());
      }
      res.setIsBuiltin();
      return res;
    } catch (Exception e) {
      throw e instanceof RuntimeException re ? re : new RuntimeException(e);
    }
  }

  ScriptObject initPrototype(String name, ScriptObject prototype) {
    try {
      // Assuming class name pattern for JS prototypes
      var className = PACKAGE_PREFIX + name + "$Prototype";
      var funcClass = Class.forName(className);
      var res = (ScriptObject) funcClass.getDeclaredConstructor().newInstance();
      res.setIsBuiltin();
      res.setInitialProto(prototype);
      return res;
    } catch (Exception e) {
      throw e instanceof RuntimeException re ? re : new RuntimeException(e);
    }
  }

  List<es.runtime.Property> extractBuiltinProperties(String name, ScriptObject func) {
    var list = new ArrayList<es.runtime.Property>();
    list.addAll(Arrays.asList(func.getMap().getProperties()));
    if (func instanceof ScriptFunction sf) {
      var proto = ScriptFunction.getPrototype(sf);
      if (proto != null) {
        list.addAll(Arrays.asList(proto.getMap().getProperties()));
      }
    }
    var prop = getProperty(name);
    if (prop != null) {
      list.add(prop);
    }
    return list;
  }

  /**
   * Given a builtin object, traverse its properties recursively and associate them with a name that will be a key to their invalidation switchpoint.
   * @param name name for key
   * @param func builtin script object
   */
  void tagBuiltinProperties(String name, ScriptObject func) {
    var sp = context.getBuiltinSwitchPoint(name);
    if (sp == null) {
      sp = context.newBuiltinSwitchPoint(name);
    }
    // get all builtin properties in this builtin object and register switchpoints keyed on the propery name,
    // one overwrite destroys all for now, e.g. Function.prototype.apply = 17; also destroys Function.prototype.call etc
    for (var prop : extractBuiltinProperties(name, func)) {
      prop.setBuiltinSwitchPoint(sp);
    }
  }

  // Function and Object constructors are inter-dependent.
  // Also, Function.prototype functions are not properly initialized.
  // We fix the references here.
  // NOTE: be careful if you want to re-order the operations here.
  // You may have to play with object references carefully!!
  void initFunctionAndObject() {
    // First-n-foremost is Function
    this.builtinFunction = initConstructor("Function", ScriptFunction.class);
    // create global anonymous function
    var anon = ScriptFunction.createAnonymous();
    // need to copy over members of Function.prototype to anon function
    anon.addBoundProperties(getFunctionPrototype());
    // Function.prototype === Object.getPrototypeOf(Function) === <anon-function>
    builtinFunction.setInitialProto(anon);
    builtinFunction.setPrototype(anon);
    anon.set("constructor", builtinFunction, 0);
    anon.deleteOwnProperty(anon.getMap().findProperty("prototype"));
    // use "getter" so that [[ThrowTypeError]] function's arity is 0 - as specified in step 10 of section 13.2.3
    this.typeErrorThrower = ScriptFunction.createBuiltin("TypeErrorThrower", Lookup.TYPE_ERROR_THROWER);
    typeErrorThrower.preventExtensions();
    // now initialize Object
    this.builtinObject = initConstructor("Object", ScriptFunction.class);
    var ObjectPrototype = getObjectPrototype();
    // Object.getPrototypeOf(Function.prototype) === Object.prototype
    anon.setInitialProto(ObjectPrototype);
    // ES6 draft compliant __proto__ property of Object.prototype accessors on Object.prototype for "__proto__"
    var getProto = ScriptFunction.createBuiltin("getProto", NativeObject.GET__PROTO__);
    var setProto = ScriptFunction.createBuiltin("setProto", NativeObject.SET__PROTO__);
    ObjectPrototype.addOwnProperty("__proto__", Attribute.NOT_ENUMERABLE, getProto, setProto);
    // Function valued properties of Function.prototype were not properly initialized.
    // Because, these were created before global.function and global.object were not initialized.
    var properties = getFunctionPrototype().getMap().getProperties();
    for (var property : properties) {
      var key = property.getKey();
      var value = builtinFunction.get(key);
      if (value instanceof ScriptFunction func && value != anon) {
        func.setInitialProto(getFunctionPrototype());
        var prototype = ScriptFunction.getPrototype(func);
        if (prototype != null) {
          prototype.setInitialProto(ObjectPrototype);
        }
      }
    }
    // For function valued properties of Object and Object.prototype, make sure prototype's proto chain ends with Object.prototype
    for (var property : builtinObject.getMap().getProperties()) {
      var key = property.getKey();
      var value = builtinObject.get(key);
      if (value instanceof ScriptFunction func) {
        var prototype = ScriptFunction.getPrototype(func);
        if (prototype != null) {
          prototype.setInitialProto(ObjectPrototype);
        }
      }
    }
    properties = getObjectPrototype().getMap().getProperties();
    for (var property : properties) {
      var key = property.getKey();
      if (key.equals("constructor")) {
        continue;
      }
      var value = ObjectPrototype.get(key);
      if (value instanceof ScriptFunction func) {
        var prototype = ScriptFunction.getPrototype(func);
        if (prototype != null) {
          prototype.setInitialProto(ObjectPrototype);
        }
      }
    }
    tagBuiltinProperties("Object", builtinObject);
    tagBuiltinProperties("Function", builtinFunction);
    tagBuiltinProperties("Function", anon);
  }

  private static MethodHandle findOwnMH_S(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), Global.class, name, MH.type(rtype, types));
  }

  RegExpResult getLastRegExpResult() {
    return lastRegExpResult;
  }

  void setLastRegExpResult(RegExpResult regExpResult) {
    this.lastRegExpResult = regExpResult;
  }

  @Override
  protected boolean isGlobal() {
    return true;
  }

  /**
   * A class representing the ES6 global lexical scope.
   */
  static class LexicalScope extends ScriptObject {

    LexicalScope(Global global) {
      super(global, PropertyMap.newMap());
      setIsInternal();
    }

    @Override
    protected GuardedInvocation findGetMethod(CallSiteDescriptor desc, LinkRequest request) {
      return filterInvocation(super.findGetMethod(desc, request));
    }

    @Override
    protected GuardedInvocation findSetMethod(CallSiteDescriptor desc, LinkRequest request) {
      return filterInvocation(super.findSetMethod(desc, request));
    }

    @Override
    protected PropertyMap addBoundProperty(PropertyMap propMap, ScriptObject source, es.runtime.Property property, boolean extensible) {
      // We override this method just to make it callable by Global
      return super.addBoundProperty(propMap, source, property, extensible);
    }

    static GuardedInvocation filterInvocation(GuardedInvocation invocation) {
      var type = invocation.getInvocation().type();
      return invocation.asType(type.changeParameterType(0, Object.class)).filterArguments(0, LEXICAL_SCOPE_FILTER);
    }
  }

}
