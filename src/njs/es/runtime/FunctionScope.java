package es.runtime;

/**
 * This is the base class for function scopes.
 *
 * Subclasses of this class are produced by the ObjectClassGenerator along with additional fields for storing local vars.
 * The number of fields required is determined by ObjectCreator.
 *
 * The scope is also responsible for handling the var arg 'arguments' object, though most of the access is via generated code.
 *
 * The constructor of this class is responsible for any function prologue involving the scope.
 */
public class FunctionScope extends Scope {

  /** Area to store scope arguments. (public for access from scripts.) */
  public final ScriptObject arguments;

  /**
   * Constructor
   *
   * @param map         property map
   * @param callerScope caller scope
   * @param arguments   arguments
   */
  public FunctionScope(PropertyMap map, ScriptObject callerScope, ScriptObject arguments) {
    super(callerScope, map);
    this.arguments = arguments;
  }

  /**
   * Constructor
   *
   * @param map         property map
   * @param callerScope caller scope
   */
  public FunctionScope(PropertyMap map, ScriptObject callerScope) {
    super(callerScope, map);
    this.arguments = null;
  }

  /**
   * Constructor
   *
   * @param map            property map
   * @param primitiveSpill primitive spill pool
   * @param objectSpill    reference spill pool
   */
  public FunctionScope(PropertyMap map, long[] primitiveSpill, Object[] objectSpill) {
    super(map, primitiveSpill, objectSpill);
    this.arguments = null;
  }

}
