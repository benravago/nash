package nash.tools;

import java.io.IOException;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import es.objects.Global;
import es.objects.annotations.Attribute;
import es.runtime.JSType;
import es.runtime.ScriptFunction;

import static es.lookup.Lookup.MH;
import static es.runtime.ScriptRuntime.UNDEFINED;
import java.io.UncheckedIOException;
import java.io.Writer;

/**
 * Global functions supported only in shell interactive mode.
 */
final class ShellFunctions {

  public static final MethodHandle ERRORLN = findOwnMH("errorln", Object.class, Object.class, Object[].class);
  public static final MethodHandle PRINTLN = findOwnMH("println", Object.class, Object.class, Object[].class);

  /**
   * Global warn implementation - Nashorn extension
   * @param self    scope
   * @param objects arguments to print
   * @return result of warn (undefined)
   */
  public static Object errorln(Object self, Object... objects) {
    return ShellFunctions.printImpl(self, false, objects);
  }

  /**
   * Global println implementation - Nashorn extension
   * @param self    scope
   * @param objects arguments to print
   * @return result of println (undefined)
   */
  public static Object println(Object self, Object... objects) {
    return ShellFunctions.printImpl(self, true, objects);
  }

  static Object printImpl(Object self, boolean stdout, Object... objects) {
    var out = (Writer) Global.printImpl(self,stdout);
    var sb = new StringBuilder();
    for (var obj : objects) {
      if (sb.length() != 0) {
        sb.append(' ');
      }
      sb.append(JSType.toString(obj));
    }
    // Print all at once to ensure thread friendly result.
    try {
      out.append(sb).append('\n');
      out.flush();
    } catch (IOException e) {
      throw new UncheckedIOException(e);
    }
    return UNDEFINED;
  }

  public static final MethodHandle EXIT = findOwnMH("exit", Object.class, Object.class, Object.class);

  /**
   * Global exit and quit implementation - Nashorn extension: perform a {@code System.exit} call from the script
   * @param self  self reference
   * @param code  exit code
   * @return undefined (will never be reached)
   */
  public static Object exit(Object self, Object code) {
    System.exit(JSType.toInt32(code));
    return UNDEFINED;
  }

  static void init(Global global) {
    ScriptFunction value;
    value = ScriptFunction.createBuiltin("print", ShellFunctions.PRINTLN);
    global.addOwnProperty("print", Attribute.NOT_ENUMERABLE, value);
    value = ScriptFunction.createBuiltin("warn", ShellFunctions.ERRORLN);
    global.addOwnProperty("warn", Attribute.NOT_ENUMERABLE, value);
    value = ScriptFunction.createBuiltin("exit", ShellFunctions.EXIT);
    global.addOwnProperty("exit", Attribute.NOT_ENUMERABLE, value);
    value = ScriptFunction.createBuiltin("quit", ShellFunctions.EXIT);
    global.addOwnProperty("quit", Attribute.NOT_ENUMERABLE, value);
  }

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), ShellFunctions.class, name, MH.type(rtype, types));
  }

}
