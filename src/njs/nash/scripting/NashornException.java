package nash.scripting;

import java.util.ArrayList;

import es.codegen.CompilerConstants;
import es.runtime.ECMAErrors;
import es.runtime.ScriptObject;

/**
 * This is base exception for all Nashorn exceptions.
 *
 * These originate from user's ECMAScript code.
 * Example: script parse errors, exceptions thrown from scripts.
 * Note that ScriptEngine methods like "eval", "invokeMethod", "invokeFunction" will wrap this as ScriptException and throw it.
 * But, there are cases where user may need to access this exception (or implementation defined subtype of this).
 * For example, if java interface is implemented by a script object or Java access to script object properties via java.util.Map interface.
 * In these cases, user code will get an instance of this or implementation defined subclass.
 */
public abstract class NashornException extends RuntimeException {

  // script file name
  private String fileName;
  // script line number
  private int line;
  // are the line and fileName unknown?
  private boolean lineAndFileNameUnknown;
  // script column number
  private int column;
  // underlying ECMA error object - lazily initialized
  private Object ecmaError;

  /**
   * Constructor to initialize error message, file name, line and column numbers.
   *
   * @param msg       exception message
   * @param fileName  file name
   * @param line      line number
   * @param column    column number
   */
  protected NashornException(String msg, String fileName, int line, int column) {
    this(msg, null, fileName, line, column);
  }

  /**
   * Constructor to initialize error message, cause exception, file name, line and column numbers.
   *
   * @param msg       exception message
   * @param cause     exception cause
   * @param fileName  file name
   * @param line      line number
   * @param column    column number
   */
  protected NashornException(String msg, Throwable cause, String fileName, int line, int column) {
    super(msg, cause == null ? null : cause);
    this.fileName = fileName;
    this.line = line;
    this.column = column;
  }

  /**
   * Constructor to initialize error message and cause exception.
   *
   * @param msg       exception message
   * @param cause     exception cause
   */
  protected NashornException(String msg, Throwable cause) {
    super(msg, cause == null ? null : cause);
    // Hard luck - no column number info
    this.column = -1;
    // We can retrieve the line number and file name from the stack trace if needed
    this.lineAndFileNameUnknown = true;
  }

  /**
   * Get the source file name for this {@code NashornException}
   *
   * @return the file name
   */
  public final String getFileName() {
    ensureLineAndFileName();
    return fileName;
  }

  /**
   * Set the source file name for this {@code NashornException}
   *
   * @param fileName the file name
   */
  public final void setFileName(String fileName) {
    this.fileName = fileName;
    lineAndFileNameUnknown = false;
  }

  /**
   * Get the line number for this {@code NashornException}
   *
   * @return the line number
   */
  public final int getLineNumber() {
    ensureLineAndFileName();
    return line;
  }

  /**
   * Set the line number for this {@code NashornException}
   *
   * @param line the line number
   */
  public final void setLineNumber(int line) {
    lineAndFileNameUnknown = false;
    this.line = line;
  }

  /**
   * Get the column for this {@code NashornException}
   *
   * @return the column number
   */
  public final int getColumnNumber() {
    return column;
  }

  /**
   * Set the column for this {@code NashornException}
   *
   * @param column the column number
   */
  public final void setColumnNumber(int column) {
    this.column = column;
  }

  /**
   * Returns array javascript stack frames from the given exception object.
   *
   * @param exception exception from which stack frames are retrieved and filtered
   * @return array of javascript stack frames
   */
  public static StackTraceElement[] getScriptFrames(Throwable exception) {
    var frames = exception.getStackTrace();
    var filtered = new ArrayList<StackTraceElement>();
    for (var st : frames) {
      if (ECMAErrors.isScriptFrame(st)) {
        var className = "<" + st.getFileName() + ">";
        var m = st.getMethodName();
        var methodName = m.equals(CompilerConstants.PROGRAM.symbolName()) ? "<program>" : stripMethodName(m);
        filtered.add(new StackTraceElement(className, methodName, st.getFileName(), st.getLineNumber()));
      }
    }
    return filtered.toArray(new StackTraceElement[0]);
  }

  static String stripMethodName(String methodName) {
    var name = methodName;

    var nestedSeparator = name.lastIndexOf(CompilerConstants.NESTED_FUNCTION_SEPARATOR.symbolName());
    if (nestedSeparator >= 0) {
      name = name.substring(nestedSeparator + 1);
    }

    var idSeparator = name.indexOf(CompilerConstants.ID_FUNCTION_SEPARATOR.symbolName());
    if (idSeparator >= 0) {
      name = name.substring(0, idSeparator);
    }

    return name.contains(CompilerConstants.ANON_FUNCTION_PREFIX.symbolName()) ? "<anonymous>" : name;
  }

  /**
   * Return a formatted script stack trace string with frames information separated by '\n'
   *
   * @param exception exception for which script stack string is returned
   * @return formatted stack trace string
   */
  public static String getScriptStackString(Throwable exception) {
    var buf = new StringBuilder();
    var frames = getScriptFrames(exception);
    for (var st : frames) {
      buf.append("\tat ")
         .append(st.getMethodName())
         .append(" (")
         .append(st.getFileName())
         .append(':')
         .append(st.getLineNumber())
         .append(")\n");
    }
    var len = buf.length();
    // remove trailing '\n'
    if (len > 0) {
      assert buf.charAt(len - 1) == '\n';
      buf.deleteCharAt(len - 1);
    }
    return buf.toString();
  }

  /**
   * Get the thrown object. Subclass responsibility
   * @return thrown object
   */
  protected Object getThrown() {
    return null;
  }

  /**
   * Initialization function for ECMA errors.
   * Stores the error in the ecmaError field of this class.
   * It is only initialized once, and then reused
   *
   * @param global the global
   * @return initialized exception
   */
  NashornException initEcmaError(ScriptObject global) {
    if (ecmaError != null) {
      return this; // initialized already!
    }

    var thrown = getThrown();
    if (thrown instanceof ScriptObject) {
      setEcmaError(ScriptObjectMirror.wrap(thrown, global));
    } else {
      setEcmaError(thrown);
    }

    return this;
  }

  /**
   * Return the underlying ECMA error object, if available.
   *
   * @return underlying ECMA Error object's mirror or whatever was thrown from script such as a String, Number or a Boolean.
   */
  public Object getEcmaError() {
    return ecmaError;
  }

  /**
   * Return the underlying ECMA error object, if available.
   *
   * @param ecmaError underlying ECMA Error object's mirror or whatever was thrown from script such as a String, Number or a Boolean.
   */
  public void setEcmaError(Object ecmaError) {
    this.ecmaError = ecmaError;
  }

  private void ensureLineAndFileName() {
    if (lineAndFileNameUnknown) {
      for (var ste : getStackTrace()) {
        if (ECMAErrors.isScriptFrame(ste)) {
          // Whatever here is compiled from JavaScript code
          fileName = ste.getFileName();
          line = ste.getLineNumber();
          return;
        }
      }

      lineAndFileNameUnknown = false;
    }
  }

  private static final long serialVersionUID = 1L;
}
