package es.runtime.events;

import java.util.logging.Level;
import es.runtime.options.Options;

/**
 * Class for representing a runtime event, giving less global dependencies than logger.
 * Every {@link NativeDebug} object keeps a queue of RuntimeEvents that can be explored through the debug API.
 *
 * @param <T> class of the value this event wraps
 */
public class RuntimeEvent<T> {

  // Queue size for the runtime event buffer
  public static final int RUNTIME_EVENT_QUEUE_SIZE = Options.getIntProperty("nashorn.runtime.event.queue.size", 1024);

  private final Level level;
  private final T value;

  /**
   * Constructor
   *
   * @param level  log level for runtime event to create
   * @param object object to wrap
   */
  public RuntimeEvent(final Level level, final T object) {
    this.level = level;
    this.value = object;
  }

  /**
   * Return the value wrapped in this runtime event
   * @return value
   */
  public final T getValue() {
    return value;
  }

  @Override
  public String toString() {
    return "[" + level + "] " +
      (value == null ? "null" : getValueClass().getSimpleName()) +
      " value=" + value;
  }

  /**
   * Descriptor for this runtime event, must be overridden and implemented, e.g. "RewriteException"
   * @return event name
   */
  public final Class<?> getValueClass() {
    return value.getClass();
  }

}
