package nash.scripting;

/**
 * Class filter (optional) to be used by nashorn script engine.
 *
 * jsr-223 program embedding nashorn script can set ClassFilter instance to be used when an engine instance is created.
 */
public interface ClassFilter {

  /**
   * Should the Java class of the specified name be exposed to scripts?
   * @param className is the fully qualified name of the java class being checked.
   *   This will not be null. Only non-array class names will be passed.
   * @return true if the java class can be exposed to scripts false otherwise
   */
  public boolean exposeToScripts(String className);

}
