package es.runtime.arrays;

/**
 * Marker interface for any ContinuousArray with any elements
 * Used for type checks that throw ClassCastExceptions and force relinks
 * for fast NativeArray specializations of builtin methods
 */
public interface AnyElements {

  /**
   * Return a numeric weight of the element type - wider is higher
   * @return element type weight
   */
  public int getElementWeight();
}
