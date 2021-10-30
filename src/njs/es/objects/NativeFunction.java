package es.objects;

import java.util.List;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import jdk.dynalink.linker.support.Lookup;

import nash.scripting.JSObject;
import nash.scripting.ScriptObjectMirror;

import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.parser.Parser;
import es.runtime.Context;
import es.runtime.JSType;
import es.runtime.ParserException;
import es.runtime.PropertyMap;
import es.runtime.ScriptEnvironment;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.linker.Bootstrap;
import static es.runtime.ECMAErrors.rangeError;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.ScriptRuntime.UNDEFINED;
import static es.runtime.Source.sourceFor;


/**
 * ECMA 15.3 Function Objects
 *
 * Note: instances of this class are never created.
 *
 * This class is not even a subclass of ScriptObject.
 * But, we use this class to generate prototype and constructor for "Function".
 */
@ScriptClass("Function")
public final class NativeFunction {

  /** apply arg converter handle */
  public static final MethodHandle TO_APPLY_ARGS = Lookup.findOwnStatic(MethodHandles.lookup(), "toApplyArgs", Object[].class, Object.class);

  // initialized by nasgen
  @SuppressWarnings("unused")
  private static PropertyMap $nasgenmap$;

  /**
   * ECMA 15.3.4.2 Function.prototype.toString ( )
   * @param self self reference
   * @return string representation of Function
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toString(Object self) {
    if (self instanceof ScriptFunction) {
      return ((ScriptFunction) self).toSource();
    }
    throw typeError("not.a.function", ScriptRuntime.safeToString(self));
  }

  /**
   * ECMA 15.3.4.3 Function.prototype.apply (thisArg, argArray)
   * @param self   self reference
   * @param target   {@code this} arg for apply
   * @param array  array of argument for apply
   * @return result of apply
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object apply(Object self, Object target, Object array) {
    checkCallable(self);
    var args = toApplyArgs(array);
    if (self instanceof ScriptFunction sf) {
      return ScriptRuntime.apply(sf, target, args);
    } else if (self instanceof ScriptObjectMirror) {
      return ((JSObject) self).call(target, args);
    } else if (self instanceof JSObject jso) {
      var global = Global.instance();
      var result = jso.call(ScriptObjectMirror.wrap(target, global), ScriptObjectMirror.wrapArray(args, global));
      return ScriptObjectMirror.unwrap(result, global);
    }
    throw new AssertionError("Should not reach here");
  }

  /**
   * Given an array-like object, converts it into a Java object array suitable for invocation of ScriptRuntime.apply
   * or for direct invocation of the applied function.
   * @param array the array-like object. Can be null in which case a zero-length array is created.
   * @return the Java array
   */
  public static Object[] toApplyArgs(Object array) {
    if (array instanceof NativeArguments na) {
      return na.getArray().asObjectArray();
    } else if (array instanceof ScriptObject sobj) {
      // look for array-like object
      var n = lengthToInt(sobj.getLength());
      var args = new Object[n];
      for (var i = 0; i < args.length; i++) {
        args[i] = sobj.get(i);
      }
      return args;
    } else if (array instanceof Object[] o) {
      return o;
    } else if (array instanceof List<?> list) {
      return list.toArray(new Object[0]);
    } else if (array == null || array == UNDEFINED) {
      return ScriptRuntime.EMPTY_ARRAY;
    } else if (array instanceof JSObject jsObj) {
      // look for array-like JSObject object
      var len = jsObj.hasMember("length") ? jsObj.getMember("length") : Integer.valueOf(0);
      var n = lengthToInt(len);
      var args = new Object[n];
      for (var i = 0; i < args.length; i++) {
        args[i] = jsObj.hasSlot(i) ? jsObj.getSlot(i) : UNDEFINED;
      }
      return args;
    } else {
      throw typeError("function.apply.expects.array");
    }
  }

  static int lengthToInt(Object len) {
    var ln = JSType.toUint32(len);
    // NOTE: ECMASCript 5.1 section 15.3.4.3 says length should be treated as Uint32, but we wouldn't be able to allocate a Java array of more than MAX_VALUE elements anyway, so at this point we have to throw an error.
    // People applying a function to more than 2^31 arguments will unfortunately be out of luck.
    if (ln > Integer.MAX_VALUE) {
      throw rangeError("range.error.inappropriate.array.length", JSType.toString(len));
    }
    return (int) ln;
  }

  static void checkCallable(Object self) {
    if (!(self instanceof ScriptFunction || (self instanceof JSObject && ((JSObject) self).isFunction()))) {
      throw typeError("not.a.function", ScriptRuntime.safeToString(self));
    }
  }

  /**
   * ECMA 15.3.4.4 Function.prototype.call (thisArg [ , arg1 [ , arg2, ... ] ] )
   * @param self self reference
   * @param args arguments for call
   * @return result of call
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static Object call(Object self, Object... args) {
    checkCallable(self);
    var target = (args.length == 0) ? UNDEFINED : args[0];
    Object[] arguments;
    if (args.length > 1) {
      arguments = new Object[args.length - 1];
      System.arraycopy(args, 1, arguments, 0, arguments.length);
    } else {
      arguments = ScriptRuntime.EMPTY_ARRAY;
    }
    if (self instanceof ScriptFunction sf) {
      return ScriptRuntime.apply(sf, target, arguments);
    } else if (self instanceof JSObject jso) {
      return jso.call(target, arguments);
    }
    throw new AssertionError("should not reach here");
  }

  /**
   * ECMA 15.3.4.5 Function.prototype.bind (thisArg [, arg1 [, arg2, ...]])
   * @param self self reference
   * @param args arguments for bind
   * @return function with bound arguments
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static Object bind(Object self, Object... args) {
    var target = (args.length == 0) ? UNDEFINED : args[0];
    Object[] arguments;
    if (args.length > 1) {
      arguments = new Object[args.length - 1];
      System.arraycopy(args, 1, arguments, 0, arguments.length);
    } else {
      arguments = ScriptRuntime.EMPTY_ARRAY;
    }
    return Bootstrap.bindCallable(self, target, arguments);
  }

  /**
   * Nashorn extension: Function.prototype.toSource
   * @param self self reference
   * @return source for function
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toSource(Object self) {
    if (self instanceof ScriptFunction sf) {
      return sf.toSource();
    }
    throw typeError("not.a.function", ScriptRuntime.safeToString(self));
  }

  /**
   * ECMA 15.3.2.1 new Function (p1, p2, ... , pn, body)
   *
   * Constructor
   *
   * @param newObj is the new operator used for constructing this function
   * @param self   self reference
   * @param args   arguments
   * @return new NativeFunction
   */
  @Constructor(arity = 1)
  public static ScriptFunction function(boolean newObj, Object self, Object... args) {
    var sb = new StringBuilder();
    sb.append("(function (");
    String funcBody;
    if (args.length > 0) {
      var paramListBuf = new StringBuilder();
      for (var i = 0; i < args.length - 1; i++) {
        paramListBuf.append(JSType.toString(args[i]));
        if (i < args.length - 2) {
          paramListBuf.append(",");
        }
      }
      // now convert function body to a string
      funcBody = JSType.toString(args[args.length - 1]);
      var paramList = paramListBuf.toString();
      if (!paramList.isEmpty()) {
        checkFunctionParameters(paramList);
        sb.append(paramList);
      }
    } else {
      funcBody = null;
    }
    sb.append(") {\n");
    if (args.length > 0) {
      checkFunctionBody(funcBody);
      sb.append(funcBody);
      sb.append('\n');
    }
    sb.append("})");
    var global = Global.instance();
    var context = global.getContext();
    return (ScriptFunction) context.eval(global, sb.toString(), global, "<function>");
  }

  static void checkFunctionParameters(String params) {
    var parser = getParser(params);
    try {
      parser.parseFormalParameterList();
    } catch (ParserException pe) {
      pe.throwAsEcmaException();
    }
  }

  static void checkFunctionBody(String funcBody) {
    var parser = getParser(funcBody);
    try {
      parser.parseFunctionBody();
    } catch (ParserException pe) {
      pe.throwAsEcmaException();
    }
  }

  static Parser getParser(String sourceText) {
    var env = Global.getEnv();
    return new Parser(env, sourceFor("<function>", sourceText), new Context.ThrowErrorManager());
  }

}
