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
  private final PrintWriter out;

  // Error writer for this environment
  private final PrintWriter err;

  // Top level namespace.
  private final Namespace namespace;

  // Current Options object.
  private final Options options;

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
    this.options = options;
    _class_cache_size = options.getInteger("class.cache.size");
    _classpath = options.getString("classpath");
    _compile_only = options.getBoolean("compile.only");
    _early_lvalue_error = options.getBoolean("early.lvalue.error");
    _empty_statements = options.getBoolean("empty.statements");
    _global_per_engine = options.getBoolean("global.per.engine");
    _optimistic_types = options.getBoolean("optimistic.types");
    _lazy_compilation = _optimistic_types ? true : options.getBoolean("lazy.compilation");
    _loader_per_compile = options.getBoolean("loader.per.compile");
    _module_path = options.getString("module.path");
    _add_modules = options.getString("add.modules");
    _no_typed_arrays = options.getBoolean("no.typed.arrays");
    _parse_only = options.getBoolean("parse.only");
    var configuredUrt = options.getInteger("unstable.relink.threshold");
    // The default for this property is -1, so we can easily detect when it is not specified on command line.
    if (configuredUrt < 1) {
      // In this case, use a default of 8, or 16 for optimistic types.
      // Optimistic types come with dual fields, and in order to get performance on benchmarks with a lot of object instantiation and then field reassignment, it can take slightly more relinks to become stable with type changes swapping out an entire property map and making a map guard fail.
      _unstable_relink_threshold = _optimistic_types ? 16 : 8;
    } else {
      _unstable_relink_threshold = configuredUrt;
    }
    var timezoneOption = options.get("timezone");
    if (timezoneOption != null) {
      this._timezone = (TimeZone) timezoneOption.getValue();
    } else {
      this._timezone = TimeZone.getDefault();
    }
    var localeOption = options.get("locale");
    if (localeOption != null) {
      this._locale = (Locale) localeOption.getValue();
    } else {
      this._locale = Locale.getDefault();
    }
  }

  /**
   * Get the output stream for this environment
   * @return output print writer
   */
  public PrintWriter getOut() {
    return out;
  }

  /**
   * Get the error stream for this environment
   * @return error print writer
   */
  public PrintWriter getErr() {
    return err;
  }

  /**
   * Get the namespace for this environment
   * @return namespace
   */
  public Namespace getNamespace() {
    return namespace;
  }

  /**
   * Return the JavaScript files passed to the program
   * @return a list of files
   */
  public List<String> getFiles() {
    return options.getFiles();
  }

  /**
   * Return the user arguments to the program, i.e. those trailing "--" after the filename
   * @return a list of user arguments
   */
  public List<String> getArguments() {
    return options.getArguments();
  }

}
