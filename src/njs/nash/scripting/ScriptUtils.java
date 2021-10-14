package nash.scripting;

import java.lang.invoke.MethodHandle;
import jdk.dynalink.beans.StaticClass;
import jdk.dynalink.linker.LinkerServices;
import es.runtime.Context;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.linker.Bootstrap;

/**
 * Utilities that are to be called from script code.
 */
public final class ScriptUtils {

  /**
   * Method which converts javascript types to java types for the
   * String.format method (jrunscript function sprintf).
   *
   * @param format a format string
   * @param args arguments referenced by the format specifiers in format
   * @return a formatted string
   */
  public static String format(String format, Object[] args) {
    return Formatter.format(format, args);
  }

  /**
   * Create a wrapper function that calls {@code func} synchronized on {@code sync} or, if that is undefined,
   * {@code self}. Used to implement "sync" function in resources/mozilla_compat.js.
   *
   * @param func the function to wrap
   * @param sync the object to synchronize on
   * @return a synchronizing wrapper function
   * @throws IllegalArgumentException if func does not represent a script function
   */
  public static Object makeSynchronizedFunction(Object func, Object sync) {
    var unwrapped = unwrap(func);
    if (unwrapped instanceof ScriptFunction sf) {
      return sf.createSynchronized(unwrap(sync));
    }

    throw new IllegalArgumentException();
  }

  /**
   * Make a script object mirror on given object if needed.
   *
   * @param obj object to be wrapped
   * @return wrapped object
   * @throws IllegalArgumentException if obj cannot be wrapped
   */
  public static ScriptObjectMirror wrap(Object obj) {
    if (obj instanceof ScriptObjectMirror som) {
      return som;
    }

    if (obj instanceof ScriptObject sobj) {
      return (ScriptObjectMirror) ScriptObjectMirror.wrap(sobj, Context.getGlobal());
    }

    throw new IllegalArgumentException();
  }

  /**
   * Unwrap a script object mirror if needed.
   *
   * @param obj object to be unwrapped
   * @return unwrapped object
   */
  public static Object unwrap(Object obj) {
    return (obj instanceof ScriptObjectMirror) ? ScriptObjectMirror.unwrap(obj, Context.getGlobal()) : obj;
  }

  /**
   * Wrap an array of object to script object mirrors if needed.
   *
   * @param args array to be unwrapped
   * @return wrapped array
   */
  public static Object[] wrapArray(Object[] args) {
    return (args == null || args.length == 0) ? args : ScriptObjectMirror.wrapArray(args, Context.getGlobal());
  }

  /**
   * Unwrap an array of script object mirrors if needed.
   *
   * @param args array to be unwrapped
   * @return unwrapped array
   */
  public static Object[] unwrapArray(Object[] args) {
    return (args == null || args.length == 0) ? args : ScriptObjectMirror.unwrapArray(args, Context.getGlobal());
  }

  /**
   * Convert the given object to the given type.
   *
   * @param obj object to be converted
   * @param type destination type to convert to.
   *    type is either a Class or nashorn representation of a Java type returned by Java.type() call in script.
   * @return converted object
   */
  public static Object convert(Object obj, Object type) {
    if (obj == null) {
      return null;
    }

    Class<?> objType;
    if (type instanceof Class c) {
      objType = c;
    } else if (type instanceof StaticClass sc) {
      objType = sc.getRepresentedClass();
    } else {
      throw new IllegalArgumentException("type expected");
    }

    var linker = Bootstrap.getLinkerServices();
    var objToConvert = unwrap(obj);
    var converter = linker.getTypeConverter(objToConvert.getClass(), objType);
    if (converter == null) {
      // no supported conversion!
      throw new UnsupportedOperationException("conversion not supported");
    }

    try {
      return converter.invoke(objToConvert);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

}
