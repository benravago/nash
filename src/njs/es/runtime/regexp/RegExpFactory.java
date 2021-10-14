package es.runtime.regexp;

import java.util.Collections;
import java.util.Map;
import java.util.WeakHashMap;
import es.runtime.ParserException;
import es.runtime.options.Options;

/**
 * Factory class for regular expressions.
 * This class creates instances of {@link JdkRegExp}.
 * An alternative factory can be installed using the {@code nashorn.regexp.impl} system property.
 */
public class RegExpFactory {

  private final static RegExpFactory instance;

  private final static String JDK = "jdk";

  /**
   * Weak cache of already validated regexps - when reparsing,
   * we don't need to recompile (reverify) all regexps that have previously been parsed
   * by this RegExpFactory in a previous compilation.
   * This saves significant time in e.g. avatar startup
   */
  private static final Map<String, RegExp> REGEXP_CACHE = // TODO: use ConcurrentHashMap<> instead
    Collections.synchronizedMap(new WeakHashMap<String, RegExp>());

  static {
    var impl = Options.getStringProperty("nashorn.regexp.impl", JDK);
    switch (impl) {
      case JDK -> instance = new RegExpFactory();
      default -> {
        instance = null;
        throw new InternalError("Unsupported RegExp factory: " + impl);
      }
    }
  }

  /**
   * Creates a Regular expression from the given {@code pattern} and {@code flags} strings.
   *
   * @param pattern RegExp pattern string
   * @param flags   RegExp flags string
   * @return new RegExp
   * @throws ParserException if flags is invalid or pattern string has syntax error.
   */
  public RegExp compile(String pattern, String flags) throws ParserException {
    return new JdkRegExp(pattern, flags);
  }

  /**
   * Compile a regexp with the given {@code source} and {@code flags}.
   *
   * @param pattern RegExp pattern string
   * @param flags   flag string
   * @return new RegExp
   * @throws ParserException if invalid source or flags
   */
  public static RegExp create(String pattern, String flags) {
    var key = pattern + "/" + flags;
    var regexp = REGEXP_CACHE.get(key);
    if (regexp == null) {
      regexp = instance.compile(pattern, flags);
      REGEXP_CACHE.put(key, regexp);
    }
    return regexp;
  }

  /**
   * Validate a regexp with the given {@code source} and {@code flags}.
   *
   * @param pattern RegExp pattern string
   * @param flags  flag string
   * @throws ParserException if invalid source or flags
   */
  public static void validate(String pattern, String flags) throws ParserException {
    create(pattern, flags);
  }

  /**
   * Returns true if the instance uses the JDK's {@code java.util.regex} package.
   *
   * @return true if instance uses JDK regex package
   */
  public static boolean usesJavaUtilRegex() {
    return instance != null && instance.getClass() == RegExpFactory.class;
  }

}
