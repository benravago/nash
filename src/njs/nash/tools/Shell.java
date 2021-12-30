package nash.tools;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.io.StringReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

import es.codegen.Compiler;
import es.codegen.Compiler.CompilationPhases;
import es.ir.Expression;
import es.objects.Global;
import es.objects.NativeSymbol;
import es.objects.annotations.Attribute;
import es.parser.Parser;
import es.runtime.Context;
import es.runtime.ErrorManager;
import es.runtime.JSType;
import es.runtime.Property;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
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

  // Resource name for properties file
  private static final String MESSAGE_RESOURCE = "nash.tools.resources.Shell";

  // Shell message bundle.
  protected static final ResourceBundle bundle = ResourceBundle.getBundle(MESSAGE_RESOURCE, Locale.getDefault());

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

  // Constructor
  protected Shell() {}

  /**
   * Main entry point with the default input, output and error streams.
   *
   * @param args The command line arguments
   */
  public static void main(String... args) throws Exception {
    try {
      var exitCode = main(System.in, System.out, System.err, args);
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
   * Starts a shell with the given arguments and streams and lets it run until exit.
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
  public static int main(InputStream in, OutputStream out, OutputStream err, String... args) throws IOException {
    return new Shell().run(in, out, err, args);
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
  protected final int run(InputStream in, OutputStream out, OutputStream err, String[] args) throws IOException {
    var context = makeContext(in, out, err, args);
    if (context == null) {
      return COMMANDLINE_ERROR;
    }

    var global = context.createGlobal();
    var env = context.getEnv();

    var files = args;
    if (files.length == 0) {
      return readEvalPrint(context, global);
    }

    if (env._compile_only) {
      return compileScripts(context, global, files);
    }

    return runScripts(context, global, files);
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
  static Context makeContext(InputStream in, OutputStream out, OutputStream err, String... args) {
    var pout = out instanceof PrintStream ? (PrintStream) out : new PrintStream(out);
    var perr = err instanceof PrintStream ? (PrintStream) err : new PrintStream(err);
    var wout = new PrintWriter(pout, true);
    var werr = new PrintWriter(perr, true);

    // Set up error handler.
    var errors = new ErrorManager(werr);
    // Set up options.
    var options = new Options(Option::getProperty);

//  // parse options
//  if (args != null) {
//    try {
//      var prepArgs = preprocessArgs(args);
//      options.process(prepArgs);
//    } catch (IllegalArgumentException e) {
//      werr.println(bundle.getString("shell.usage"));
//      // options.displayHelp(e);
//      return null;
//    }
//  }
    
    var scripting = false;

    // detect scripting mode by any source's first character being '#'
    if (!scripting) {
      for (var fileName : args) { // options.getFiles()
        var firstFile = new File(fileName);
        if (firstFile.isFile()) {
          try (var fr = new FileReader(firstFile)) {
            var firstChar = fr.read();
            // starts with '#
            if (firstChar == '#') {
              scripting = true;
              break;
            }
          } catch (IOException e) {
            // ignore this. File IO errors will be reported later anyway
          }
        }
      }
    }

    return new Context(options, errors, wout, werr, Thread.currentThread().getContextClassLoader());
  }

  /**
   * Preprocess the command line arguments passed in by the shell.
   *
   * This method checks, for the first non-option argument, whether the file denoted by it begins with a shebang line.
   * If so, it is assumed that execution in shebang mode is intended.
   * The consequence of this is that the identified script file will be treated as the <em>only</em> script file, and all subsequent arguments will be regarded as arguments to the script.
   * <p>
   * This method canonicalizes the command line arguments to the form {@code <options> <script> -- <arguments>} if a shebang script is identified.
   * On platforms that pass shebang arguments as single strings, the shebang arguments will be broken down into single arguments; whitespace is used as separator.
   * <p>
   * Shebang mode is entered regardless of whether the script is actually run directly from the shell, or indirectly via the {@code njs} executable.
   * It is the user's / script author's responsibility to ensure that the arguments given on the shebang line do not lead to a malformed argument sequence.
   * In particular, the shebang arguments should not contain any whitespace for purposes other than separating arguments, as the different platforms deal with whitespace in different and incompatible ways.
   * <p>
   * @implNote Example:<ul>
   * <li>Shebang line in {@code script.js}: {@code #!/path/to/njs --language=es6}</li>
   * <li>Command line: {@code ./script.js arg2}</li>
   * <li>{@code args} array passed to Nashorn: {@code --language=es6,./script.js,arg}</li>
   * <li>Required canonicalized arguments array: {@code --language=es6,./script.js,--,arg2}</li>
   * </ul>
   *
   * @param args the command line arguments as passed into Nashorn.
   * @return the passed and possibly canonicalized argument list
   */
  static String[] preprocessArgs(String... args) {
    if (args.length == 0) {
      return args;
    }

    var processedArgs = new ArrayList<String>();
    processedArgs.addAll(Arrays.asList(args));

    // Nash supports passing multiple shebang arguments.
    // On platforms that pass anything following the shebang interpreter notice as one argument,
    // the first element of the argument array needs to be special-cased as it might actually contain several arguments.
    // Mac OS X splits shebang arguments, other platforms don't.
    // This special handling is also only necessary if the first argument actually starts with an option.
    if (args[0].startsWith("-") && !System.getProperty("os.name", "generic").startsWith("Mac OS X")) {
      processedArgs.addAll(0, tokenizeString(processedArgs.remove(0)));
    }

    var shebangFilePos = -1; // -1 signifies "none found"
    // identify a shebang file and its position in the arguments array (if any)
    for (var i = 0; i < processedArgs.size(); ++i) {
      var a = processedArgs.get(i);
      if (!a.startsWith("-")) {
        var p = Paths.get(a);
        var l = "";
        try (var r = Files.newBufferedReader(p)) {
          l = r.readLine();
        } catch (IOException ioe) {
          // ignore
        }
        if (l != null && l.startsWith("#!")) {
          shebangFilePos = i;
        }
        // We're only checking the first non-option argument.
        // If it's not a shebang file, we're in normal execution mode.
        break;
      }
    }
    if (shebangFilePos != -1) {
      // Insert the argument separator after the shebang script file.
      processedArgs.add(shebangFilePos + 1, "--");
    }
    return processedArgs.stream().toArray(String[]::new);
  }

  public static List<String> tokenizeString(String str) {
    var tokenizer = new StreamTokenizer(new StringReader(str));
    tokenizer.resetSyntax();
    tokenizer.wordChars(0, 255);
    tokenizer.whitespaceChars(0, ' ');
    tokenizer.commentChar('#');
    tokenizer.quoteChar('"');
    tokenizer.quoteChar('\'');
    var tokenList = new ArrayList<String>();
    var toAppend = new StringBuilder();
    while (nextToken(tokenizer) != StreamTokenizer.TT_EOF) {
      var s = tokenizer.sval;
      // The tokenizer understands about honoring quoted strings and recognizes them as one token that possibly contains multiple space-separated words.
      // It does not recognize quoted spaces, though, and will split after the escaping \ character.
      // This is handled here.
      if (s.endsWith("\\")) {
        // omit trailing \, append space instead
        toAppend.append(s.substring(0, s.length() - 1)).append(' ');
      } else {
        tokenList.add(toAppend.append(s).toString());
        toAppend.setLength(0);
      }
    }
    if (toAppend.length() != 0) {
      tokenList.add(toAppend.toString());
    }
    return tokenList;
  }

  static int nextToken(StreamTokenizer tokenizer) {
    try { return tokenizer.nextToken(); }
    catch (IOException ioe) { return StreamTokenizer.TT_EOF; }
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
  private static int compileScripts(Context context, Global global, String... files) throws IOException {
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
  int runScripts(Context context, Global global, String... files) throws IOException {
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);
    try {
      if (globalChanged) {
        Context.setGlobal(global);
      }
      addScriptingBuiltins(global);
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
          apply(script, global);
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
   * Hook to ScriptFunction "apply".
   * A performance metering shell may introduce enter/exit timing here.
   *
   * @param target target function for apply
   * @param self self reference for apply
   *
   * @return result of the function apply
   */
  protected Object apply(ScriptFunction target, Object self) {
    return ScriptRuntime.apply(target, self);
  }

  /**
   * Parse potentially partial code and keep track of the start of last expression.
   * This 'partial' parsing support is meant to be used for code-completion.
   *
   * @param context the nashorn context
   * @param code code that is to be parsed
   * @return the start index of the last expression parsed in the (incomplete) code.
   */
  public final int getLastExpressionStart(Context context, String code) {
    var exprStart = new int[] {-1};

    var p = new Parser(context.getEnv(), sourceFor("<partial_code>", code), new Context.ThrowErrorManager()) {
      @Override
      protected Expression expression() {
        exprStart[0] = this.start;
        return super.expression();
      }
      @Override
      protected Expression assignmentExpression(boolean noIn) {
        exprStart[0] = this.start;
        return super.assignmentExpression(noIn);
      }
    };

    try {
      p.parse();
    } catch (Exception ignored) {
      // throw any parser exception, but we are partial parsing anyway
    }

    return exprStart[0];
  }

  /**
   * read-eval-print loop for Nash shell.
   *
   * @param context the nashorn context
   * @param global  global scope object to use
   * @return return code
   */
  protected int readEvalPrint(Context context, Global global) {
    var prompt = bundle.getString("shell.prompt");
    var in = new BufferedReader(new InputStreamReader(System.in));
    var err = context.getErr();
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != global);
    var env = context.getEnv();

    try {
      if (globalChanged) {
        Context.setGlobal(global);
      }
      addScriptingBuiltins(global);
      addShellBuiltins(global);
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
  protected static String toString(Object result, Global global) {
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

  /**
   * from es.object.Global
   * Adds njs shell interactive mode builtin functions to global scope.
   */
  void addShellBuiltins(Global global) {
    ScriptFunction value;
    System.out.println("addShellBuiltin "+global);
    value = ScriptFunction.createBuiltin("input", ShellFunctions.INPUT);
    global.addOwnProperty("input", Attribute.NOT_ENUMERABLE, value);
    value = ScriptFunction.createBuiltin("evalinput", ShellFunctions.EVALINPUT);
    global.addOwnProperty("evalinput", Attribute.NOT_ENUMERABLE, value);
  }

  void addScriptingBuiltins(Global global) {
    ScriptFunction value;
    value = ScriptFunction.createBuiltin("print", ShellFunctions.PRINTLN);
    global.addOwnProperty("print", Attribute.NOT_ENUMERABLE, value);
    value = ScriptFunction.createBuiltin("warn", ShellFunctions.ERRORLN);
    global.addOwnProperty("warn", Attribute.NOT_ENUMERABLE, value);
    value = ScriptFunction.createBuiltin("exit", ShellFunctions.EXIT);
    global.addOwnProperty("exit", Attribute.NOT_ENUMERABLE, value);
    value = ScriptFunction.createBuiltin("quit", ShellFunctions.EXIT);
    global.addOwnProperty("quit", Attribute.NOT_ENUMERABLE, value);
  }

}
