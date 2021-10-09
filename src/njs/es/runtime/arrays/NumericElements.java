package es.runtime.arrays;

/**
 * Marker interface for any ContinuousArray with numeric elements
 * (int, long or double)
 * Used for type checks that throw ClassCastExceptions and force relinks
 * for fast NativeArray specializations of builtin methods
 */
public interface NumericElements extends AnyElements {
  //empty
}
