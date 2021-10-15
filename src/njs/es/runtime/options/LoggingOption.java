package es.runtime.options;

import java.util.Collections;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.logging.Level;

/**
 * Class that collects logging options like --log=compiler:finest,fields,recompile:fine
 * into a map form that can be used to instantiate loggers in the Global object on demand
 */
public class LoggingOption extends KeyValueOption {

  /**
   * Logging info.
   *
   * Basically a logger name maps to this, which is a tuple of log level and the "is quiet" flag,
   * which is a special log level used to collect RuntimeEvents only, but not output anything
   */
  public static class LoggerInfo {

    private final Level level;
    private final boolean isQuiet;

    LoggerInfo(Level level, boolean isQuiet) {
      this.level = level;
      this.isQuiet = isQuiet;
    }

    /**
     * Get the log level
     * @return log level
     */
    public Level getLevel() {
      return level;
    }

    /**
     * Get the quiet flag
     * @return true if quiet flag is set
     */
    public boolean isQuiet() {
      return isQuiet;
    }
  }

  private final Map<String, LoggerInfo> loggers = new HashMap<>();

  LoggingOption(String value) {
    super(value);
    initialize(getValues());
  }

  /**
   * Return the logger info collected from this command line option
   *
   * @return map of logger name to logger info
   */
  public Map<String, LoggerInfo> getLoggers() {
    return Collections.unmodifiableMap(loggers);
  }

  /**
   * Initialization function that is called to instantiate the logging system.
   * It takes logger names (keys) and logging labels respectively
   *
   * @param map a map where the key is a logger name and the value a logging level
   * @throws IllegalArgumentException if level or names cannot be parsed
   */
  void initialize(Map<String, String> logMap) throws IllegalArgumentException {
    try {
      for (var entry : logMap.entrySet()) {
        Level level;
        var name = lastPart(entry.getKey());
        var levelString = entry.getValue().toUpperCase(Locale.ENGLISH);
        boolean isQuiet;

        if ("".equals(levelString)) {
          level = Level.INFO;
          isQuiet = false;
        } else if ("QUIET".equals(levelString)) {
          level = Level.INFO;
          isQuiet = true;
        } else {
          level = Level.parse(levelString);
          isQuiet = false;
        }

        loggers.put(name, new LoggerInfo(level, isQuiet));
      }
    } catch (IllegalArgumentException | SecurityException e) {
      throw e;
    }
  }

  static String lastPart(String packageName) {
    var parts = packageName.split("\\.");
    if (parts.length == 0) {
      return packageName;
    }
    return parts[parts.length - 1];
  }

}
