package es.runtime.logging;

import es.runtime.Context;

/**
 * Interface implemented by classes that are loggable.
 *
 * Their instances will provide functionality for initializing a logger
 * (usually by asking Global for it, with a reference to this.getClass())
 * and a method to return the logger in use
 *
 * Typically a class implementing this interface also has the Logger annotation
 *
 * @see Logger
 */
public interface Loggable {

  /**
   * Initialize a logger, by asking Context to get or create it and then keep it in a table by name
   *
   * @param context context
   * @return the initialized logger
   */
  public DebugLogger initLogger(Context context);

  /**
   * Return the logger in use
   * @return logger
   */
  public DebugLogger getLogger();

}
