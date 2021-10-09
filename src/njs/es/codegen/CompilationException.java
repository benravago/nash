package es.codegen;

/**
 * Exception when something in the compiler breaks down. Can only
 * be instantiated by the codegen package
 */
@SuppressWarnings("serial")
public class CompilationException extends RuntimeException {

  CompilationException(final String description) {
    super(description);
  }

  CompilationException(final Exception cause) {
    super(cause);
  }
}
