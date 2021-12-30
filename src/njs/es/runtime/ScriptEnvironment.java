package es.runtime;

import java.io.PrintWriter;

import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import es.codegen.Namespace;
import es.runtime.options.Options;

/**
 * Script environment consists of command line options, arguments, script files and output and error writers, top level Namespace etc.
 */
public final class ScriptEnvironment {

  // Output writer for this environment
  public final PrintWriter out;

  // Error writer for this environment
  public final PrintWriter err;

  // Top level namespace.
  public final Namespace namespace;

  /** Size of the per-global Class cache size */
  public final int _class_cache_size;

  /** -classpath value. */
  public final String _classpath;

  /** Only compile script, do not run it or generate other ScriptObjects */
  public final boolean _compile_only;

  /** Invalid lvalue expressions should be reported as early errors */
  public final boolean _early_lvalue_error;

  /** Empty statements should be preserved in the AST */
  public final boolean _empty_statements;

  /** Use single Global instance per jsr223 engine instance. */
  public final boolean _global_per_engine;

  /** Number of times a dynamic call site has to be relinked before it is considered unstable (and thus should be linked as if it were megamorphic). */
  public final int _unstable_relink_threshold;

  /** Argument passed to compile only if optimistic compilation should take place */
  public static final String COMPILE_ONLY_OPTIMISTIC_ARG = "optimistic";

  /** Should lazy compilation take place */
  public final boolean _lazy_compilation;

  /** Should optimistic types be used */
  public final boolean _optimistic_types;

  /** Create a new class loaded for each compilation */
  public final boolean _loader_per_compile;

  /** --module-path, if any */
  public final String _module_path;

  /** --add-modules, if any */
  public final String _add_modules;

  /** Do not support typed arrays. */
  public final boolean _no_typed_arrays;

  /** Only parse the source code, do not compile */
  public final boolean _parse_only;

  /** time zone for this environment */
  public final TimeZone _timezone;

  /** Local for error messages */
  public final Locale _locale;

  /**
   * Constructor
   *
   * @param options a Options object
   * @param out output print writer
   * @param err error print writer
   */
  @SuppressWarnings("unused")
  public ScriptEnvironment(Options options, PrintWriter out, PrintWriter err) {
    this.out = out;
    this.err = err;
    this.namespace = new Namespace();
    _class_cache_size = options.get("class.cache.size", 50);
    _classpath = options.get("classpath", null);
    _compile_only = options.get("compile.only", false);
    _early_lvalue_error = options.get("early.lvalue.error", true);
    _empty_statements = options.get("empty.statements", false);
    _global_per_engine = options.get("global.per.engine", false);
    _optimistic_types = options.get("optimistic.types", false);
    _lazy_compilation = _optimistic_types ? true : options.get("lazy.compilation", true);
    _loader_per_compile = options.get("loader.per.compile", true);
    _module_path = options.get("module.path", null);
    _add_modules = options.get("add.modules", null);
    _no_typed_arrays = options.get("no.typed.arrays", false);
    _parse_only = options.get("parse.only", false);
    // use a default of 8, or 16 for optimistic types.
    _unstable_relink_threshold = options.get("unstable.relink.threshold", _optimistic_types ? 16 : 8);
    // Optimistic types come with dual fields, and in order to get performance on benchmarks with a lot of object instantiation and then field reassignment, it can take slightly more relinks to become stable with type changes swapping out an entire property map and making a map guard fail.
    var tz = options.get("timezone", null);
    _timezone = tz != null ? TimeZone.getTimeZone(tz) : TimeZone.getDefault();
    var id = options.get("locale", null);
    _locale = id != null ? new Locale(id) : Locale.getDefault();
  }

}
