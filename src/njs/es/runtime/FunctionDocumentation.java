package es.runtime;

import java.util.Locale;
import java.util.ResourceBundle;

/**
 * Utility class to fetch documentation for built-in functions, constructors.
 */
final class FunctionDocumentation {

  private static final String DOCS_RESOURCE = "es.runtime.resources.Functions";

  private static final ResourceBundle FUNC_DOCS;

  static /*<init>*/ {
    FUNC_DOCS = ResourceBundle.getBundle(DOCS_RESOURCE, Locale.getDefault());
  }

  static String getDoc(String docKey) {
    try {
      return FUNC_DOCS.getString(docKey);
    } catch (RuntimeException ignored) {
      return null;
    }
  }

}
