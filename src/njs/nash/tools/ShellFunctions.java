package nash.tools;

import java.io.IOException;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import es.objects.Global;
import es.runtime.JSType;
import es.runtime.ScriptingFunctions;
import static es.lookup.Lookup.MH;
import static es.runtime.ScriptRuntime.UNDEFINED;

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

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), ShellFunctions.class, name, MH.type(rtype, types));
  }

}
