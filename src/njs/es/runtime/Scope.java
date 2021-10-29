package es.runtime;

import static es.codegen.CompilerConstants.virtualCallNoLookup;

import es.codegen.CompilerConstants;

/**
 * A {@link ScriptObject} subclass for objects that act as scope.
 */
public class Scope extends ScriptObject {

  // This is used to store return state of split functions.
  private int splitState = -1;

  /** Method handle that points to {@link Scope#getSplitState}. */
  public static final CompilerConstants.Call GET_SPLIT_STATE = virtualCallNoLookup(Scope.class, "getSplitState", int.class);
  /** Method handle that points to {@link Scope#setSplitState(int)}. */
  public static final CompilerConstants.Call SET_SPLIT_STATE = virtualCallNoLookup(Scope.class, "setSplitState", void.class, int.class);

  /**
   * Constructor
   *
   * @param map initial property map
   */
  public Scope(PropertyMap map) {
    super(map);
  }

  /**
   * Constructor
   *
   * @param proto parent scope
   * @param map   initial property map
   */
  public Scope(ScriptObject proto, PropertyMap map) {
    super(proto, map);
  }

  /**
   * Constructor
   *
   * @param map            property map
   * @param primitiveSpill primitive spill array
   * @param objectSpill    reference spill array
   */
  public Scope(PropertyMap map, long[] primitiveSpill, Object[] objectSpill) {
    super(map, primitiveSpill, objectSpill);
  }

  @Override
  public boolean isScope() {
    return true;
  }

  @Override
  boolean hasWithScope() {
    for (ScriptObject obj = this; obj != null; obj = obj.getProto()) {
      if (obj instanceof WithObject) {
        return true;
      }
    }
    return false;
  }

  /**
   * Get the scope's split method state.
   * @return current split state
   */
  public int getSplitState() {
    return splitState;
  }

  /**
   * Set the scope's split method state.
   * @param state current split state
   */
  public void setSplitState(int state) {
    splitState = state;
  }

}
