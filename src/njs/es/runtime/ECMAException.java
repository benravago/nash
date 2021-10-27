package es.runtime;

import javax.script.ScriptException;
import nash.scripting.NashornException;

import es.codegen.CompilerConstants.Call;
import es.codegen.CompilerConstants.FieldAccess;
import static es.codegen.CompilerConstants.*;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * Exception used to implement ECMAScript "throw" from scripts.
 * The actual thrown object from script need not be a Java exception and so it is wrapped as an instance field called "thrown" here.
 * This exception class is also used to represent ECMA errors thrown from runtime code (for example, TypeError, ReferenceError thrown from Nashorn engine runtime).
 */
@SuppressWarnings("serial")
public final class ECMAException extends NashornException {

  /** Method handle pointing to the constructor {@link ECMAException#create(Object, String, int, int)}, */
  public static final Call CREATE = staticCallNoLookup(ECMAException.class, "create", ECMAException.class, Object.class, String.class, int.class, int.class);

  /** Field handle to the{@link ECMAException#thrown} field, so that it can be accessed from generated code */
  public static final FieldAccess THROWN = virtualField(ECMAException.class, "thrown", Object.class);

  private static final String EXCEPTION_PROPERTY = "nashornException";

  /** Object thrown. */
  public final Object thrown;

  /**
   * Constructor. Called from the factory method 'create'.
   *
   * @param thrown    object to be thrown
   * @param fileName  script file name
   * @param line      line number of throw
   * @param column    column number of throw
   */
  ECMAException(Object thrown, String fileName, int line, int column) {
    super(ScriptRuntime.safeToString(thrown), asThrowable(thrown), fileName, line, column);
    this.thrown = thrown;
    setExceptionToThrown();
  }

  /**
   * Constructor. This is called from the runtime code.
   *
   * @param thrown   object to be thrown
   * @param cause    Java exception that triggered this throw
   */
  public ECMAException(Object thrown, Throwable cause) {
    super(ScriptRuntime.safeToString(thrown), cause);
    this.thrown = thrown;
    setExceptionToThrown();
  }

  /**
   * Factory method to retrieve the underlying exception or create an exception.
   * This method is called from the generated code.
   * @param thrown    object to be thrown
   * @param fileName  script file name
   * @param line      line number of throw
   * @param column    column number of throw
   * @return ECMAException object
   */
  public static ECMAException create(Object thrown, String fileName, int line, int column) {
    // If thrown object is an Error or sub-object like TypeError, then an ECMAException object has been already initialized at constructor.
    if (thrown instanceof ScriptObject so) {
      if (getException(so) instanceof ECMAException ee) {
        // Make sure exception has correct thrown reference because that's what will end up getting caught.
        if (ee.getThrown() == thrown) {
          // copy over file name, line number and column number.
          ee.setFileName(fileName);
          ee.setLineNumber(line);
          ee.setColumnNumber(column);
          return ee;
        }
      }
    }
    return new ECMAException(thrown, fileName, line, column);
  }

  /**
   * Get the thrown object
   * @return thrown object
   */
  @Override
  public Object getThrown() {
    return thrown;
  }

  @Override
  public String toString() {
    var sb = new StringBuilder();
    var fileName = getFileName();
    var line = getLineNumber();
    var column = getColumnNumber();
    if (fileName != null) {
      sb.append(fileName);
      if (line >= 0) {
        sb.append(':');
        sb.append(line);
      }
      if (column >= 0) {
        sb.append(':');
        sb.append(column);
      }
      sb.append(' ');
    } else {
      sb.append("ECMAScript Exception: ");
    }
    sb.append(getMessage());
    return sb.toString();
  }

  /**
   * Get the {@link ECMAException}, i.e. the underlying Java object for the JavaScript error object from a {@link ScriptObject} representing an error
   * @param errObj the error object
   * @return a {@link ECMAException}
   */
  public static Object getException(ScriptObject errObj) {
    // Exclude inherited properties that may belong to errors in the prototype chain.
    return errObj.hasOwnProperty(ECMAException.EXCEPTION_PROPERTY) ? errObj.get(ECMAException.EXCEPTION_PROPERTY) : null;
  }

  /**
   * Print the stack trace for a {@code ScriptObject} representing an error
   * @param errObj the error object
   * @return undefined
   */
  public static Object printStackTrace(ScriptObject errObj) {
    if (getException(errObj) instanceof Throwable exception) {
      exception.printStackTrace(Context.getCurrentErr());
    } else {
      Context.err("<stack trace not available>");
    }
    return UNDEFINED;
  }

  /**
   * Get the line number for a {@code ScriptObject} representing an error
   * @param errObj the error object
   * @return the line number, or undefined if wrapped exception is not a ParserException
   */
  public static Object getLineNumber(ScriptObject errObj) {
    var e = getException(errObj);
    return (e instanceof NashornException ne) ? ne.getLineNumber()
         : (e instanceof ScriptException se) ? se.getLineNumber()
         : UNDEFINED;
  }

  /**
   * Get the column number for a {@code ScriptObject} representing an error
   * @param errObj the error object
   * @return the column number, or undefined if wrapped exception is not a ParserException
   */
  public static Object getColumnNumber(ScriptObject errObj) {
    var e = getException(errObj);
    return (e instanceof NashornException ne) ? ne.getColumnNumber()
         : (e instanceof ScriptException se) ? se.getColumnNumber()
         : UNDEFINED;
  }

  /**
   * Get the file name for a {@code ScriptObject} representing an error
   * @param errObj the error object
   * @return the file name, or undefined if wrapped exception is not a ParserException
   */
  public static Object getFileName(ScriptObject errObj) {
    var e = getException(errObj);
    return (e instanceof NashornException ne) ? ne.getFileName()
         : (e instanceof ScriptException se) ? se.getFileName()
         : UNDEFINED;
  }

  /**
   * Stateless string conversion for an error object
   * @param errObj the error object
   * @return string representation of {@code errObj}
   */
  public static String safeToString(ScriptObject errObj) {
    Object name = UNDEFINED;
    try {
      name = errObj.get("name");
    } catch (Exception e) {
      // ignored
    }
    if (name == UNDEFINED) {
      name = "Error";
    } else {
      name = ScriptRuntime.safeToString(name);
    }
    Object msg = UNDEFINED;
    try {
      msg = errObj.get("message");
    } catch (Exception e) {
      // ignored
    }
    if (msg == UNDEFINED) {
      msg = "";
    } else {
      msg = ScriptRuntime.safeToString(msg);
    }
    if (((String) name).isEmpty()) {
      return (String) msg;
    }
    if (((String) msg).isEmpty()) {
      return (String) name;
    }
    return name + ": " + msg;
  }

  static Throwable asThrowable(Object obj) {
    return (obj instanceof Throwable) ? (Throwable) obj : null;
  }

  void setExceptionToThrown() {
    // Nashorn extension: errorObject.nashornException
    // Expose this exception via "nashornException" property of on the thrown object.
    // This exception object can be used to print stack trace and fileName, line number etc. from script code.
    if (thrown instanceof ScriptObject sobj) {
      if (!sobj.has(EXCEPTION_PROPERTY)) {
        sobj.addOwnProperty(EXCEPTION_PROPERTY, Property.NOT_ENUMERABLE, this);
      } else {
        sobj.set(EXCEPTION_PROPERTY, this, 0);
      }
    }
  }

}
