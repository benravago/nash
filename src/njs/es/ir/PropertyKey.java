package es.ir;

/**
 * Any node that can be a property key inherits this
 */
public interface PropertyKey {

  /**
   * Get the property name
   *
   * @return the property name
   */
  public abstract String getPropertyName();
}
