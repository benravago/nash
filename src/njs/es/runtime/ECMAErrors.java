package es.runtime;

import java.util.Locale;
import java.util.ResourceBundle;

import java.text.MessageFormat;

import es.codegen.CompilerConstants;
import es.objects.Global;
import es.scripts.JS;

/**
 * Helper class to throw various standard "ECMA error" exceptions such as Error, ReferenceError, TypeError etc.
 */
public final class ECMAErrors {

  private static final String MESSAGES_RESOURCE = "es.runtime.resources.Messages";

  private static final ResourceBundle MESSAGES_BUNDLE;

  static /*<init>*/ {
    MESSAGES_BUNDLE = ResourceBundle.getBundle(MESSAGES_RESOURCE, Locale.getDefault());
  }

  // We assume that compiler generates script classes into the known package.
  private static final String scriptPackage;

  static /*<init>*/ {
    var name = JS.class.getName();
    scriptPackage = name.substring(0, name.lastIndexOf('.'));
  }

  static ECMAException error(Object thrown, Throwable cause) {
    return new ECMAException(thrown, cause);
  }

  /**
   * Error dispatch mechanism.
   * Create a {@link ParserException} as the correct JavaScript error
   * @param e {@code ParserException} for error dispatcher
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException asEcmaException(ParserException e) {
    return asEcmaException(Context.getGlobal(), e);
  }

  /**
   * Error dispatch mechanism.
   * Create a {@link ParserException} as the correct JavaScript error
   * @param global global scope object
   * @param e {@code ParserException} for error dispatcher
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException asEcmaException(Global global, ParserException e) {
    var errorType = e.getErrorType();
    assert errorType != null : "error type for " + e + " was null";
    var globalObj = global;
    var msg = e.getMessage();
    // translate to ECMAScript Error object using error type
    return switch (errorType) {
      case ERROR -> error(globalObj.newError(msg), e);
      case EVAL_ERROR -> error(globalObj.newEvalError(msg), e);
      case RANGE_ERROR -> error(globalObj.newRangeError(msg), e);
      case REFERENCE_ERROR -> error(globalObj.newReferenceError(msg), e);
      case SYNTAX_ERROR -> error(globalObj.newSyntaxError(msg), e);
      case TYPE_ERROR -> error(globalObj.newTypeError(msg), e);
      case URI_ERROR -> error(globalObj.newURIError(msg), e);
      // should not happen - perhaps unknown error type?
      default -> throw new AssertionError(e.getMessage());
    };
  }

  /**
   * Create a syntax error (ECMA 15.11.6.4)
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException syntaxError(String msgId, String... args) {
    return syntaxError(Context.getGlobal(), msgId, args);
  }

  /**
   * Create a syntax error (ECMA 15.11.6.4)
   * @param global  global scope object
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException syntaxError(Global global, String msgId, String... args) {
    return syntaxError(global, null, msgId, args);
  }

  /**
   * Create a syntax error (ECMA 15.11.6.4)
   * @param cause   native Java {@code Throwable} that is the cause of error
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException syntaxError(Throwable cause, String msgId, String... args) {
    return syntaxError(Context.getGlobal(), cause, msgId, args);
  }

  /**
   * Create a syntax error (ECMA 15.11.6.4)
   * @param global  global scope object
   * @param cause   native Java {@code Throwable} that is the cause of error
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException syntaxError(Global global, Throwable cause, String msgId, String... args) {
    var msg = getMessage("syntax.error." + msgId, args);
    return error(global.newSyntaxError(msg), cause);
  }

  /**
   * Create a type error (ECMA 15.11.6.5)
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException typeError(String msgId, String... args) {
    return typeError(Context.getGlobal(), msgId, args);
  }

  /**
   * Create a type error (ECMA 15.11.6.5)
   * @param global  global scope object
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException typeError(Global global, String msgId, String... args) {
    return typeError(global, null, msgId, args);
  }

  /**
   * Create a type error (ECMA 15.11.6.5)
   * @param cause   native Java {@code Throwable} that is the cause of error
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException typeError(Throwable cause, String msgId, String... args) {
    return typeError(Context.getGlobal(), cause, msgId, args);
  }

  /**
   * Create a type error (ECMA 15.11.6.5)
   * @param global  global scope object
   * @param cause   native Java {@code Throwable} that is the cause of error
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException typeError(Global global, Throwable cause, String msgId, String... args) {
    var msg = getMessage("type.error." + msgId, args);
    return error(global.newTypeError(msg), cause);
  }

  /**
   * Create a range error (ECMA 15.11.6.2)
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException rangeError(String msgId, String... args) {
    return rangeError(Context.getGlobal(), msgId, args);
  }

  /**
   * Create a range error (ECMA 15.11.6.2)
   * @param global  global scope object
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException rangeError(Global global, String msgId, String... args) {
    return rangeError(global, null, msgId, args);
  }

  /**
   * Create a range error (ECMA 15.11.6.2)
   * @param cause   native Java {@code Throwable} that is the cause of error
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException rangeError(Throwable cause, String msgId, String... args) {
    return rangeError(Context.getGlobal(), cause, msgId, args);
  }

  /**
   * Create a range error (ECMA 15.11.6.2)
   * @param global  global scope object
   * @param cause   native Java {@code Throwable} that is the cause of error
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException rangeError(Global global, Throwable cause, String msgId, String... args) {
    var msg = getMessage("range.error." + msgId, args);
    return error(global.newRangeError(msg), cause);
  }

  /**
   * Create a reference error (ECMA 15.11.6.3)
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException referenceError(String msgId, String... args) {
    return referenceError(Context.getGlobal(), msgId, args);
  }

  /**
   * Create a reference error (ECMA 15.11.6.3)
   * @param global  global scope object
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException referenceError(Global global, String msgId, String... args) {
    return referenceError(global, null, msgId, args);
  }

  /**
   * Create a reference error (ECMA 15.11.6.3)
   * @param cause   native Java {@code Throwable} that is the cause of error
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException referenceError(Throwable cause, String msgId, String... args) {
    return referenceError(Context.getGlobal(), cause, msgId, args);
  }

  /**
   * Create a reference error (ECMA 15.11.6.3)
   * @param global  global scope object
   * @param cause   native Java {@code Throwable} that is the cause of error
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException referenceError(Global global, Throwable cause, String msgId, String... args) {
    var msg = getMessage("reference.error." + msgId, args);
    return error(global.newReferenceError(msg), cause);
  }

  /**
   * Create a URI error (ECMA 15.11.6.6)
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException uriError(String msgId, String... args) {
    return uriError(Context.getGlobal(), msgId, args);
  }

  /**
   * Create a URI error (ECMA 15.11.6.6)
   * @param global  global scope object
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException uriError(Global global, String msgId, String... args) {
    return uriError(global, null, msgId, args);
  }

  /**
   * Create a URI error (ECMA 15.11.6.6)
   * @param cause   native Java {@code Throwable} that is the cause of error
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException uriError(Throwable cause, String msgId, String... args) {
    return uriError(Context.getGlobal(), cause, msgId, args);
  }

  /**
   * Create a URI error (ECMA 15.11.6.6)
   * @param global  global scope object
   * @param cause   native Java {@code Throwable} that is the cause of error
   * @param msgId   resource tag for error message
   * @param args    arguments to resource
   * @return the resulting {@link ECMAException}
   */
  public static ECMAException uriError(Global global, Throwable cause, String msgId, String... args) {
    final String msg = getMessage("uri.error." + msgId, args);
    return error(global.newURIError(msg), cause);
  }

  /**
   * Get the exception message by placing the args in the resource defined by the resource tag.
   * This is visible to, e.g. the {@link es.parser.Parser} can use it to generate compile time messages with the correct locale
   * @param msgId the resource tag (message id)
   * @param args  arguments to error string
   * @return the filled out error string
   */
  public static String getMessage(String msgId, String... args) {
    try {
      return new MessageFormat(MESSAGES_BUNDLE.getString(msgId)).format(args);
    } catch (java.util.MissingResourceException e) {
      throw new RuntimeException("no message resource found for message id: " + msgId);
    }
  }

  /**
   * Check if a stack trace element is in JavaScript
   * @param frame frame
   * @return true if frame is in the script
   */
  public static boolean isScriptFrame(StackTraceElement frame) {
    var className = frame.getClassName();
    // Look for script package in class name (into which compiler puts generated code)
    if (className.startsWith(scriptPackage) && !CompilerConstants.isInternalMethodName(frame.getMethodName())) {
      var source = frame.getFileName();
      // Make sure that it is not some Java code that Nashorn has in that package!
      return source != null && !source.endsWith(".java");
    }
    return false;
  }

}
