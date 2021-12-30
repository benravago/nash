package nash.tools;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.PrintWriter;

import es.codegen.Compiler;
import es.codegen.Compiler.CompilationPhases;
import es.objects.Global;
import es.objects.NativeSymbol;
import es.parser.Parser;
import es.runtime.Context;
import es.runtime.ErrorManager;
import es.runtime.JSType;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.Source;
import es.runtime.Symbol;
import es.runtime.arrays.ArrayLikeIterator;
import es.runtime.options.Option;
import es.runtime.options.Options;

import nash.scripting.NashornException;

import static es.runtime.Source.sourceFor;

/**
 * Command line Shell for processing JavaScript files.
 */
public class Shell {

  // Exit code for command line tool - successful
  public static final int SUCCESS = 0;

  // Exit code for command line tool - error on command line
  public static final int COMMANDLINE_ERROR = 100;

  // Exit code for command line tool - error compiling script
  public static final int COMPILATION_ERROR = 101;

  // Exit code for command line tool - error during runtime
  public static final int RUNTIME_ERROR = 102;

  // Exit code for command line tool - i/o error
  public static final int IO_ERROR = 103;

  // Exit code for command line tool - internal error
  public static final int INTERNAL_ERROR = 104;

  /**
   * Main entry point with the default input, output and error streams.
   *
   * @param args The command line arguments
   */
  public static void main(String... args) throws Exception {
    try {
      var exitCode = run(System.in, System.out, System.err, args);
      if (exitCode != SUCCESS) {
        System.exit(exitCode);
      }
    } catch (IOException e) {
      System.err.println(e); // bootstrapping, Context.err may not exist
      System.exit(IO_ERROR);
    }
  }

  /**
   * Starting point for executing a {@code Shell}.
   * Starts a shell with the given source and lets it run until exit.
   *
   * @param in input stream for Shell
   * @param out output stream for Shell
   * @param err error stream for Shell
   * @param name name of script
   * @param content text of script
   */
  public static void eval(InputStream in, OutputStream out, OutputStream err, String name, String text) {
    var context = makeContext(in, out, err);
    var global = context.createGlobal();
    if (Context.getGlobal() != global) {
      Context.setGlobal(global);
    }
    ShellFunctions.init(global);
    var source = Source.sourceFor(name, text);
    var script = context.compileScript(source, global);
    ScriptRuntime.apply(script, global);
  }

  /**
   * Run method logic.
   *
   * @param in input stream for Shell
   * @param out output stream for Shell
   * @param err error stream for Shell
   * @param args arguments to Shell
   *
   * @return exit code
   *
   * @throws IOException if there's a problem setting up the streams
   */
  static int run(InputStream in, OutputStream out, OutputStream err, String[] args) throws IOException {
    var context = makeContext(in, out, err);
    if (context == null) {
      return COMMANDLINE_ERROR;
    }
    var global = context.createGlobal();
    var env = context.getEnv();
    return args.length == 0 ? readEvalPrint(context, global)
         : env._compile_only ? compileScripts(context, global, args)
                             : runScripts(context, global, args);
  }

  /**
   * Make a new Nashorn Context to compile and/or run JavaScript files.
   *
   * @param in input stream for Shell
   * @param out output stream for Shell
   * @param err error stream for Shell
   * @param args arguments to Shell
   *
   * @return null if there are problems with option parsing.
   */
  static Context makeContext(InputStream in, OutputStream out, OutputStream err) {

    var wout = printer(out);
    var werr = printer(err);
    // Set up error handler.
    var errors = new ErrorManager(werr);
    // Set up options.
    var options = new Options(Option::getProperty);

    return new Context(options, errors, wout, werr, Thread.currentThread().getContextClassLoader());
  }
  
  static PrintWriter printer(OutputStream os) {
    return (os instanceof PrintStream ps) ? new PrintStreamWriter(ps) : new PrintWriter(os,true);
  }

  /**
   * Compiles the given script files in the command line.
   * This is called only when using the --compile-only flag
   *
   * @param context the nashorn context
   * @param global the global scope
   * @param files the list of script files to compile
   *
   * @return error code
   * @throws IOException when any script file read results in I/O error
   */
  static int compileScripts(Context context, Global global, String... files) throws IOException {
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);
    var env = context.getEnv();
    try {
      if (globalChanged) {
        Context.setGlobal(global);
      }
      var errors = context.getErrorManager();

      // For each file on the command line.
      for (var fileName : files) {
        var functionNode = new Parser(env, sourceFor(fileName, new File(fileName)), errors, 0).parse();

        if (errors.getNumberOfErrors() != 0) {
          return COMPILATION_ERROR;
        }

        Compiler.forNoInstallerCompilation(context, functionNode.getSource())
                .compile(functionNode, CompilationPhases.COMPILE_ALL_NO_INSTALL);

        if (errors.getNumberOfErrors() != 0) {
          return COMPILATION_ERROR;
        }
      }
    } finally {
      env.out.flush();
      env.err.flush();
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }

    return SUCCESS;
  }

  /**
   * Runs the given JavaScript files in the command line
   *
   * @param context the nashorn context
   * @param global the global scope
   * @param files the list of script files to run
   *
   * @return error code
   * @throws IOException when any script file read results in I/O error
   */
  static int runScripts(Context context, Global global, String... files) throws IOException {
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);
    try {
      if (globalChanged) {
        Context.setGlobal(global);
      }
      ShellFunctions.init(global);
      var errors = context.getErrorManager();
      // For each file on the command line.
      for (var fileName : files) {
        if ("-".equals(fileName)) {
          var res = readEvalPrint(context, global);
          if (res != SUCCESS) {
            return res;
          }
          continue;
        }

        var file = new File(fileName);
        var script = context.compileScript(sourceFor(fileName, file), global);
        if (script == null || errors.getNumberOfErrors() != 0) {
          if (context.getEnv()._parse_only && !errors.hasErrors()) {
            continue; // No error, continue to consume all files in list
          }
          return COMPILATION_ERROR;
        }

        try {
          ScriptRuntime.apply(script, global);
        } catch (NashornException e) {
          errors.error(e.toString());
          return RUNTIME_ERROR;
        }
      }
    } finally {
      context.getOut().flush();
      context.getErr().flush();
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }

    return SUCCESS;
  }

  /**
   * read-eval-print loop for Nash shell.
   *
   * @param context the nashorn context
   * @param global  global scope object to use
   * @return return code
   */
  static int readEvalPrint(Context context, Global global) {
    var prompt = "nash>";
    var in = new BufferedReader(new InputStreamReader(System.in));
    var err = context.getErr();
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);

    try {
      if (globalChanged) {
        Context.setGlobal(global);
      }
      ShellFunctions.init(global);
      for (;;) {
        err.print(prompt);
        err.flush();

        var source = "";
        try {
          source = in.readLine();
        } catch (IOException ioe) {
          err.println(ioe.toString());
        }

        if (source == null) {
          break;
        }

        if (source.isEmpty()) {
          continue;
        }

        try {
          var res = context.eval(global, source, global, "<shell>");
          if (res != ScriptRuntime.UNDEFINED) {
            err.println(toString(res, global));
          }
        } catch (Exception e) {
          err.println(e);
        }
      }
    } finally {
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }

    return SUCCESS;
  }

  /**
   * Converts {@code result} to a printable string.
   * The reason we don't use {@link JSType#toString(Object)} or {@link ScriptRuntime#safeToString(Object)} is that we want to be able to render Symbol values even if they occur within an Array, and therefore have to implement our own Array to String conversion.
   *
   * @param result the result
   * @param global the global object
   * @return the string representation
   */
  static String toString(Object result, Global global) {
    if (result instanceof Symbol) {
      // Normal implicit conversion of symbol to string would throw TypeError
      return result.toString();
    }

    if (result instanceof NativeSymbol) {
      return JSType.toPrimitive(result).toString();
    }

    if (isArrayWithDefaultToString(result, global)) {
      // This should yield the same string as Array.prototype.toString but will not throw if the array contents include symbols.
      var sb = new StringBuilder();
      var iter = ArrayLikeIterator.arrayLikeIterator(result, true);

      while (iter.hasNext()) {
        var obj = iter.next();

        if (obj != null && obj != ScriptRuntime.UNDEFINED) {
          sb.append(toString(obj, global));
        }

        if (iter.hasNext()) {
          sb.append(',');
        }
      }

      return sb.toString();
    }

    return JSType.toString(result);
  }

  static boolean isArrayWithDefaultToString(Object result, Global global) {
    return result instanceof ScriptObject sobj && sobj.isArray() &&
           sobj.get("toString") == global.getArrayPrototype().get("toString");
  }

}
