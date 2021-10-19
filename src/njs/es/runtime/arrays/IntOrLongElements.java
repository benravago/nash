package es.runtime.arrays;

/**
 * Marker interface for any ContinuousArray with int or long elements.
 * Used for type checks that throw ClassCastExceptions and force relinks for fast NativeArray specializations of builtin methods
 */
public interface IntOrLongElements extends NumericElements {
  //empty
}
