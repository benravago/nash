package nash.tools;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.UncheckedIOException;

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

import nash.scripting.NashornException;

/**
 * Command line Shell for processing JavaScript files.
 */
public class Shell {

  /**
   * Main entry point with the default input, output and error streams.
   */
  public static void main(String... args) throws Exception {
    run(System.in, System.out, System.err, args);
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
  static void run(InputStream in, OutputStream out, OutputStream err, String[] args) {
    var context = makeContext(in, out, err);
    if (context == null) {
      System.err.println(">>> error creating script context");
      return;
    }
    var global = context.createGlobal();
    var env = context.getEnv();
    if (args.length == 0) { 
      readEvalPrint(context, global);
    } else if (env._compile_only || env._parse_only) {
      compileScripts(context, global, args);
    } else {
      runScripts(context, global, args);
    }
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
    var errors = new ErrorManager(werr);
    return new Context(Thread.currentThread().getContextClassLoader(), null,
      errors, wout, werr, Option::getProperty);
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
  static void compileScripts(Context context, Global global, String... files) {
    var err = context.getErr();
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
        var file = new File(fileName);
        var source = Source.sourceFor(fileName, file);
        var functionNode = new Parser(env, source, errors, 0).parse();
        if (errors.hasErrors()) {
          err.println(">>> "+errors.getNumberOfErrors()+" parse errors");
          break;
        }
        if (env._parse_only) {
          continue;
        }
        Compiler.forNoInstallerCompilation(context, functionNode.getSource())
                .compile(functionNode, CompilationPhases.COMPILE_ALL_NO_INSTALL);
        if (errors.hasErrors()) {
          err.println(">>> "+errors.getNumberOfErrors()+" compile errors");
          break;
        }
      }
    } catch (IOException ioe) {
      throw new UncheckedIOException(ioe); 
    } finally {
      env.out.flush();
      env.err.flush();
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }
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
  static void runScripts(Context context, Global global, String... files) {
    var err = context.getErr();
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
          readEvalPrint(context, global);
          continue;
        }
        var file = new File(fileName);
        var source = Source.sourceFor(fileName, file);
        var script = context.compileScript(source, global);
        if (errors.hasErrors()) {
          err.println(">>> "+errors.getNumberOfErrors()+" errors");
          break;
        }
        if (script != null) {
          try {
            ScriptRuntime.apply(script, global);        
          } catch (NashornException e) {
            errors.error(e.toString());
            break;
          }
        }
      }
    } catch (IOException ioe) {
      throw new UncheckedIOException(ioe); 
    } finally {
      context.getOut().flush();
      context.getErr().flush();
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }
  }

  /**
   * read-eval-print loop for Nash shell.
   *
   * @param context the nashorn context
   * @param global  global scope object to use
   * @return return code
   */
  static void readEvalPrint(Context context, Global global) {
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
