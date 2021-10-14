package es.scripts;

import es.runtime.PropertyMap;
import es.runtime.ScriptObject;

/**
 * Empty object class for dual primitive-object fields.
 */
public class JD extends ScriptObject {

  private static final PropertyMap map$ = PropertyMap.newMap(JD.class);

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
  public JD(PropertyMap map) {
    super(map);
  }

  /**
   * Constructor given an initial prototype and the default initial property map.
   *
   * @param proto the prototype object
   */
  public JD(ScriptObject proto) {
    super(proto, getInitialMap());
  }

  /**
   * Constructor that takes a pre-initialized spill pool.
   *
   * Used by {@link es.codegen.SpillObjectCreator} and {@link es.parser.JSONParser} for initializing object literals
   *
   * @param map            property map
   * @param primitiveSpill primitive spill pool
   * @param objectSpill    reference spill pool
   */
  public JD(PropertyMap map, long[] primitiveSpill, Object[] objectSpill) {
    super(map, primitiveSpill, objectSpill);
  }

  /**
   * A method handle of this method is passed to the ScriptFunction constructor.
   *
   * @param map  the property map to use for allocatorMap
   * @return newly allocated ScriptObject
   */
  public static ScriptObject allocate(PropertyMap map) {
    return new JD(map);
  }

}
