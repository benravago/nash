package nash.tools;

import java.io.IOException;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import es.objects.Global;
import es.runtime.JSType;
import static es.lookup.Lookup.MH;
import static es.runtime.ScriptRuntime.UNDEFINED;
import java.io.UncheckedIOException;
import java.io.Writer;

/**
 * Global functions supported only in shell interactive mode.
 */
final class ShellFunctions {

  // Handle to implementation of {@link ShellFunctions#input} - Nashorn extension
  public static final MethodHandle INPUT =
    findOwnMH("input", Object.class, Object.class, Object.class, Object.class);

  /** Handle to implementation of {@link ShellFunctions#evalinput} - Nashorn extension */
  public static final MethodHandle EVALINPUT =
    findOwnMH("evalinput", Object.class, Object.class, Object.class, Object.class);

  /**
   * Nashorn extension: global.input (shell-interactive-mode-only)
   * Read one or more lines of input from the standard input till the given end marker is seen in standard input.
   *
   * @param self   self reference
   * @param endMarker String used as end marker for input
   * @param prompt String used as input prompt
   *
   * @return line that was read
   *
   * @throws IOException if an exception occurs
   */
  public static Object input(Object self, Object endMarker, Object prompt) throws IOException {
    var endMarkerStr = (endMarker != UNDEFINED) ? JSType.toString(endMarker) : "";
    var promptStr = (prompt != UNDEFINED) ? JSType.toString(prompt) : ">> ";
    var buf = new StringBuilder();
    for (;;) {
      var line = ScriptingFunctions.readLine(promptStr);
      if (line == null || line.equals(endMarkerStr)) {
        break;
      }
      buf.append(line);
      buf.append('\n');
    }
    return buf.toString();
  }

  /**
   * Nashorn extension:
   * Reads zero or more lines from standard input and evaluates the concatenated string as code
   *
   * @param self self reference
   * @param endMarker String used as end marker for input
   * @param prompt String used as input prompt
   *
   * @return output from evaluating the script
   *
   * @throws IOException if an exception occurs
   */
  public static Object evalinput(Object self, Object endMarker, Object prompt) throws IOException {
    return Global.eval(self, input(self, endMarker, prompt));
  }

  public static final MethodHandle ERRORLN =
    findOwnMH("errorln", Object.class, Object.class, Object[].class);
  public static final MethodHandle PRINTLN =
    findOwnMH("println", Object.class, Object.class, Object[].class);
  
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

  public static final MethodHandle EXIT =
    findOwnMH("exit", Object.class, Object.class, Object.class);

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
  
  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), ShellFunctions.class, name, MH.type(rtype, types));
  }

}
