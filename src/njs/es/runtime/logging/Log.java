package es.runtime.logging;

import java.lang.System.Logger.Level;

/**
 * A System.Logger facade.
 *
 * Provides Logger.Level based api and java.util.Formatter type formatting.
 * Also checks if the last param value is a Throwable and uses it as such if so.
 */

public final class Log {

  Log(System.Logger log) {
    this.log = log;
  }

  public final boolean trace() { return log.isLoggable(Level.TRACE); }
  public final void trace(String format, Object... params) { log(Level.TRACE,format,params); }

  public final boolean debug() { return log.isLoggable(Level.DEBUG); }
  public final void debug(String format, Object... params) { log(Level.DEBUG,format,params); }

  public final boolean info() { return log.isLoggable(Level.INFO); }
  public final void info(String format, Object... params) { log(Level.INFO,format,params); }

  public final boolean warn() { return log.isLoggable(Level.WARNING); }
  public final void warn(String format, Object... params) { log(Level.WARNING,format,params); }

  public final boolean error() { return log.isLoggable(Level.ERROR); }
  public final void error(String format, Object... params) { log(Level.ERROR,format,params); }

  final System.Logger log;

  final void log(Level level, String format, Object... params) {
    Throwable thrown = null;
    var n = params.length;
    if (n > 0) {
      format = format.formatted(params);
      if (params[n-1] instanceof Throwable t) thrown = t;
    }
    log.log(level,format,thrown);
  }

  @Override
  public String toString() {
    return log.getName();
  }

}
