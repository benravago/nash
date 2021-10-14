package es.scripts;

import es.runtime.PropertyMap;
import es.runtime.ScriptObject;

/**
 * Empty object class for object-only fields.
 */
public class JO extends ScriptObject {

  private static final PropertyMap map$ = PropertyMap.newMap(JO.class);

  /**
   * Returns the initial property map to be used.
   * @return the initial property map.
   */
  public static PropertyMap getInitialMap() {
    return map$;
  }

  /**
   * Constructor given an initial property map
   *
   * @param map the property map
   */
  public JO(PropertyMap map) {
    super(map);
  }

  /**
   * Constructor given an initial prototype and the default initial property map.
   *
   * @param proto the prototype object
   */
  public JO(ScriptObject proto) {
    super(proto, getInitialMap());
  }

  /**
   * Constructor that takes a pre-initialized spill pool.
   * Used by {@link es.codegen.SpillObjectCreator} and {@link es.parser.JSONParser} for initializing object literals
   *
   * @param map            property map
   * @param primitiveSpill primitive spill pool
   * @param objectSpill    reference spill pool
   */
  public JO(PropertyMap map, long[] primitiveSpill, Object[] objectSpill) {
    super(map, primitiveSpill, objectSpill);
  }

  /**
   * A method handle of this method is passed to the ScriptFunction constructor.
   *
   * @param map  the property map to use for allocatorMap
   * @return newly allocated ScriptObject
   */
  public static ScriptObject allocate(PropertyMap map) {
    return new JO(map);
  }

}
