package es.codegen;

/**
 * Exception when something in the compiler breaks down.
 * Can only be instantiated by the codegen package
 */
public class CompilationException extends RuntimeException {
  CompilationException(String description) {
    super(description);
  }
  CompilationException(Exception cause) {
    super(cause);
  }
}
