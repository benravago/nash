package es.lookup;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.invoke.SwitchPoint;
import java.lang.reflect.Method;

import java.util.ArrayList;
import java.util.List;

import es.runtime.Context;
import es.runtime.ScriptObject;
import es.runtime.logging.DebugLogger;
import es.runtime.logging.Loggable;
import es.runtime.logging.Logger;
import es.util.Hex;
import static es.runtime.JSType.isString;

/**
 * This class is abstraction for all method handle, switchpoint and method type operations.
 *
 * This enables the functionality interface to be subclassed and instrumented,
 * as it has been proven vital to keep the number of method handles in the system down.
 *
 * All operations of the above type should go through this class, and not directly into java.lang.invoke
 */
public final class MethodHandleFactory {

  private static final MethodHandles.Lookup PUBLIC_LOOKUP = MethodHandles.publicLookup();
  private static final MethodHandles.Lookup LOOKUP = MethodHandles.lookup();

  /** Runtime exception that collects every reason that a method handle lookup operation can go wrong */
  public static class LookupException extends RuntimeException {
    /**
     * Constructor
     * @param e causing exception
     */
    public LookupException(Exception e) {
      super(e);
    }
  }

  /**
   * Helper function that takes a class or an object with a toString override and shortens it to notation after last dot.
   * This is used to facilitiate pretty printouts in various debug loggers - internal only
   *
   * @param obj class or object
   * @return pretty version of object as string
   */
  public static String stripName(Object obj) {
    if (obj == null) {
      return "null";
    }

    if (obj instanceof Class c) {
      return c.getSimpleName();
    }
    return obj.toString();
  }

  private static final MethodHandleFunctionality FUNC = new StandardMethodHandleFunctionality();

  /**
   * Return the method handle functionality used for all method handle operations
   * @return a method handle functionality implementation
   */
  public static MethodHandleFunctionality getFunctionality() {
    return FUNC;
  }

  private static final String VOID_TAG = "[VOID]";

  static void err(String str) {
    Context.getContext().getErr().println(str);
  }

  static String argString(Object arg) {
    if (arg == null) {
      return "null";
    }

    if (arg.getClass().isArray()) {
      var list = new ArrayList<Object>();
      for (var elem : (Object[]) arg) {
        list.add('\'' + argString(elem) + '\'');
      }

      return list.toString();
    }

    if (arg instanceof ScriptObject so) {
      return arg.toString() + " (map=" + Hex.id(so.getMap()) + ')';
    }

    return arg.toString();
  }

  /**
   * Class that marshalls all method handle operations to the java.lang.invoke package.
   * This exists only so that it can be subclassed and method handles created from Nashorn made possible to instrument.
   * All Nashorn classes should use the MethodHandleFactory for their method handle operations
   */
  @Logger(name = "methodhandles")
  static class StandardMethodHandleFunctionality implements MethodHandleFunctionality, Loggable {

    // for bootstrapping reasons, because a lot of static fields use MH for lookups, we
    // need to set the logger when the Global object is finished. This means that we don't
    // get instrumentation for public static final MethodHandle SOMETHING = MH... in the builtin
    // classes, but that doesn't matter, because this is usually not where we want it
    private DebugLogger log = DebugLogger.DISABLED_LOGGER;

    @Override
    public DebugLogger initLogger(Context context) {
      return this.log = context.getLogger(this.getClass());
    }

    @Override
    public DebugLogger getLogger() {
      return log;
    }

    protected static String describe(Object... data) {
      var sb = new StringBuilder();

      for (var i = 0; i < data.length; i++) {
        var d = data[i];
        if (d == null) {
          sb.append("<null> ");
        } else if (isString(d)) {
          sb.append(d.toString());
          sb.append(' ');
        } else if (d.getClass().isArray()) {
          sb.append("[ ");
          for (var da : (Object[]) d) {
            sb.append(describe(new Object[]{da})).append(' ');
          }
          sb.append("] ");
        } else {
          sb.append(d)
                  .append('{')
                  .append(Integer.toHexString(System.identityHashCode(d)))
                  .append('}');
        }

        if (i + 1 < data.length) {
          sb.append(", ");
        }
      }

      return sb.toString();
    }

    @Override
    public MethodHandle filterArguments(MethodHandle target, int pos, MethodHandle... filters) {
      return MethodHandles.filterArguments(target, pos, filters);
    }

    @Override
    public MethodHandle filterReturnValue(MethodHandle target, MethodHandle filter) {
      return MethodHandles.filterReturnValue(target, filter);
    }

    @Override
    public MethodHandle guardWithTest(MethodHandle test, MethodHandle target, MethodHandle fallback) {
      return MethodHandles.guardWithTest(test, target, fallback);
    }

    @Override
    public MethodHandle insertArguments(MethodHandle target, int pos, Object... values) {
      return MethodHandles.insertArguments(target, pos, values);
    }

    @Override
    public MethodHandle dropArguments(MethodHandle target, int pos, Class<?>... values) {
      return MethodHandles.dropArguments(target, pos, values);
    }

    @Override
    public MethodHandle dropArguments(MethodHandle target, int pos, List<Class<?>> values) {
      return MethodHandles.dropArguments(target, pos, values);
    }

    @Override
    public MethodHandle asType(MethodHandle handle, MethodType type) {
      return handle.asType(type);
    }

    @Override
    public MethodHandle bindTo(MethodHandle handle, Object x) {
      return handle.bindTo(x);
    }

    @Override
    public MethodHandle foldArguments(MethodHandle target, MethodHandle combiner) {
      return MethodHandles.foldArguments(target, combiner);
    }

    @Override
    public MethodHandle explicitCastArguments(MethodHandle target, MethodType type) {
      return MethodHandles.explicitCastArguments(target, type);
    }

    @Override
    public MethodHandle arrayElementGetter(Class<?> type) {
      return MethodHandles.arrayElementGetter(type);
    }

    @Override
    public MethodHandle arrayElementSetter(Class<?> type) {
      return MethodHandles.arrayElementSetter(type);
    }

    @Override
    public MethodHandle throwException(Class<?> returnType, Class<? extends Throwable> exType) {
      return MethodHandles.throwException(returnType, exType);
    }

    @Override
    public MethodHandle catchException(MethodHandle target, Class<? extends Throwable> exType, MethodHandle handler) {
      return MethodHandles.catchException(target, exType, handler);
    }

    @Override
    public MethodHandle constant(Class<?> type, Object value) {
      return MethodHandles.constant(type, value);
    }

    @Override
    public MethodHandle identity(Class<?> type) {
      return MethodHandles.identity(type);
    }

    @Override
    public MethodHandle asCollector(MethodHandle handle, Class<?> arrayType, int arrayLength) {
      return handle.asCollector(arrayType, arrayLength);
    }

    @Override
    public MethodHandle asSpreader(MethodHandle handle, Class<?> arrayType, int arrayLength) {
      return handle.asSpreader(arrayType, arrayLength);
    }

    @Override
    public MethodHandle getter(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, Class<?> type) {
      try {
        return explicitLookup.findGetter(clazz, name, type);
      } catch (NoSuchFieldException | IllegalAccessException e) {
        throw new LookupException(e);
      }
    }

    @Override
    public MethodHandle staticGetter(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, Class<?> type) {
      try {
        return explicitLookup.findStaticGetter(clazz, name, type);
      } catch (NoSuchFieldException | IllegalAccessException e) {
        throw new LookupException(e);
      }
    }

    @Override
    public MethodHandle setter(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, Class<?> type) {
      try {
        return explicitLookup.findSetter(clazz, name, type);
      } catch (NoSuchFieldException | IllegalAccessException e) {
        throw new LookupException(e);
      }
    }

    @Override
    public MethodHandle staticSetter(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, Class<?> type) {
      try {
        return explicitLookup.findStaticSetter(clazz, name, type);
      } catch (NoSuchFieldException | IllegalAccessException e) {
        throw new LookupException(e);
      }
    }

    @Override
    public MethodHandle find(Method method) {
      try {
        return PUBLIC_LOOKUP.unreflect(method);
      } catch (IllegalAccessException e) {
        throw new LookupException(e);
      }
    }

    @Override
    public MethodHandle findStatic(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, MethodType type) {
      try {
        return explicitLookup.findStatic(clazz, name, type);
      } catch (NoSuchMethodException | IllegalAccessException e) {
        throw new LookupException(e);
      }
    }

    @Override
    public MethodHandle findSpecial(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, MethodType type, Class<?> thisClass) {
      try {
        return explicitLookup.findSpecial(clazz, name, type, thisClass);
      } catch (NoSuchMethodException | IllegalAccessException e) {
        throw new LookupException(e);
      }
    }

    @Override
    public MethodHandle findVirtual(MethodHandles.Lookup explicitLookup, Class<?> clazz, String name, MethodType type) {
      try {
        return explicitLookup.findVirtual(clazz, name, type);
      } catch (NoSuchMethodException | IllegalAccessException e) {
        throw new LookupException(e);
      }
    }

    @Override
    public SwitchPoint createSwitchPoint() {
      var sp = new SwitchPoint();
      return sp;
    }

    @Override
    public MethodHandle guardWithTest(SwitchPoint sp, MethodHandle before, MethodHandle after) {
      return sp.guardWithTest(before, after);
    }

    @Override
    public MethodType type(Class<?> returnType, Class<?>... paramTypes) {
      return MethodType.methodType(returnType, paramTypes);
    }
  }

}
