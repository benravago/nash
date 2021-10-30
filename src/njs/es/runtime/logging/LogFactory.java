package es.runtime.logging;

public class LogFactory {

  public static System.Logger getLogger() {
    return getLogger(caller());
  }

  public static System.Logger getLogger(String name) {
    return System.getLogger(name);
  }

  public static Log getLog() {
    return getLog(caller());
  }

  public static Log getLog(String name) {
    return new Log(getLogger(name));
  }

  final static StackWalker walker = StackWalker.getInstance(StackWalker.Option.RETAIN_CLASS_REFERENCE);
  final static String caller() { // caller(0) -> getLog*(1) -> invoker(2)
    return walker.walk(s -> s.skip(2).findFirst().get().getClassName());
  }

}
