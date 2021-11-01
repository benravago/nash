package nash.tools;

import es.runtime.ECMAErrors;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import java.nio.file.Path;
import java.nio.file.Paths;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StreamTokenizer;
import java.io.StringReader;
import java.lang.ProcessBuilder.Redirect;

import static nash.tools.CommandExecutor.RedirectType.*;
import static es.runtime.ECMAErrors.rangeError;
import es.runtime.ScriptRuntime;

/**
 * The CommandExecutor class provides support for Nashorn's $EXEC builtin function.
 *
 * CommandExecutor provides support for command parsing, I/O redirection, piping, completion timeouts, # comments, and simple environment variable management (cd, setenv, and unsetenv).
 */
class CommandExecutor {

  // Size of byte buffers used for piping.
  private static final int BUFFER_SIZE = 1024;

  // Test to see if running on Windows.
  private static final boolean IS_WINDOWS = System.getProperty("os.name").contains("Windows");

  // Cygwin drive alias prefix.
  private static final String CYGDRIVE = "/cygdrive/";

  // User's home directory
  private static final String HOME_DIRECTORY = System.getProperty("user.home");

  // Various types of standard redirects.
  enum RedirectType {
    NO_REDIRECT,    REDIRECT_INPUT, REDIRECT_OUTPUT, REDIRECT_OUTPUT_APPEND, REDIRECT_ERROR, REDIRECT_ERROR_APPEND,  REDIRECT_OUTPUT_ERROR_APPEND, REDIRECT_ERROR_TO_OUTPUT
  };
  // Prefix strings to standard redirects.
  private static final String[] redirectPrefixes = { // TODO: put into enum
    "<", "0<", ">", "1>", ">>", "1>>", "2>", "2>>", "&>", "2>&1"
  };
  // Map from redirectPrefixes to RedirectType.
  private static final RedirectType[] redirects = { // TODO: add enum api
    REDIRECT_INPUT, REDIRECT_INPUT, REDIRECT_OUTPUT, REDIRECT_OUTPUT, REDIRECT_OUTPUT_APPEND, REDIRECT_OUTPUT_APPEND, REDIRECT_ERROR, REDIRECT_ERROR_APPEND, REDIRECT_OUTPUT_ERROR_APPEND, REDIRECT_ERROR_TO_OUTPUT
  };

  /**
   * The RedirectInfo class handles checking the next token in a command to see if it contains a redirect.
   * If the redirect file does not butt against the prefix, then the next token is consumed.
   */
  private static class RedirectInfo {

    // true if a redirect was encountered on the current command.
    private boolean hasRedirects;
    // Redirect.PIPE or an input redirect from the command line.
    private Redirect inputRedirect;
    // Redirect.PIPE or an output redirect from the command line.
    private Redirect outputRedirect;
    // Redirect.PIPE or an error redirect from the command line.
    private Redirect errorRedirect;
    // true if the error stream should be merged with output.
    private boolean mergeError;

    RedirectInfo() {
      this.hasRedirects = false;
      this.inputRedirect = Redirect.PIPE;
      this.outputRedirect = Redirect.PIPE;
      this.errorRedirect = Redirect.PIPE;
      this.mergeError = false;
    }

    /**
     * check - tests to see if the current token contains a redirect
     * @param token    current command line token
     * @param iterator current command line iterator
     * @param cwd      current working directory
     * @return true if token is consumed
     */
    boolean check(String token, Iterator<String> iterator, String cwd) {
      // Iterate through redirect prefixes to file a match.
      for (var i = 0; i < redirectPrefixes.length; i++) {
        var prefix = redirectPrefixes[i];
        // If a match is found.
        if (token.startsWith(prefix)) {
          // Indicate we have at least one redirect (efficiency.)
          hasRedirects = true;
          // Map prefix to RedirectType.
          var redirect = redirects[i];
          // Strip prefix from token
          token = token.substring(prefix.length());
          // Get file from either current or next token.
          File file = null;
          if (redirect != REDIRECT_ERROR_TO_OUTPUT) {
            // Nothing left of current token.
            if (token.length() == 0) {
              if (iterator.hasNext()) {
                // Use next token.
                token = iterator.next();
              } else {
                // Send to null device if not provided.
                token = IS_WINDOWS ? "NUL:" : "/dev/null";
              }
            }
            // Redirect file.
            file = resolvePath(cwd, token).toFile();
          }
          // Define redirect based on prefix.
          switch (redirect) {
            case REDIRECT_INPUT -> inputRedirect = Redirect.from(file);
            case REDIRECT_OUTPUT -> outputRedirect = Redirect.to(file);
            case REDIRECT_OUTPUT_APPEND -> outputRedirect = Redirect.appendTo(file);
            case REDIRECT_ERROR -> errorRedirect = Redirect.to(file);
            case REDIRECT_ERROR_APPEND -> errorRedirect = Redirect.appendTo(file);
            case REDIRECT_OUTPUT_ERROR_APPEND -> {
              outputRedirect = Redirect.to(file);
              errorRedirect = Redirect.to(file);
              mergeError = true;
            }
            case REDIRECT_ERROR_TO_OUTPUT -> mergeError = true;
            default -> { return false; }
          }
          // Indicate token is consumed.
          return true;
        }
      }
      // No redirect found.
      return false;
    }

    /**
     * apply - apply the redirects to the current ProcessBuilder.
     * @param pb current ProcessBuilder
     */
    void apply(ProcessBuilder pb) {
      // Only if there was redirects (saves new structure in ProcessBuilder.)
      if (hasRedirects) {
        // If output and error are the same file then merge.
        var outputFile = outputRedirect.file();
        var errorFile = errorRedirect.file();
        if (outputFile != null && outputFile.equals(errorFile)) {
          mergeError = true;
        }
        // Apply redirects.
        pb.redirectInput(inputRedirect);
        pb.redirectOutput(outputRedirect);
        pb.redirectError(errorRedirect);
        pb.redirectErrorStream(mergeError);
      }
    }
  }

  /**
   * The Piper class is responsible for copying from an InputStream to an
   * OutputStream without blocking the current thread.
   */
  private static class Piper implements java.lang.Runnable {

    // Stream to copy from.
    private final InputStream input;

    // Stream to copy to.
    private final OutputStream output;

    private final Thread thread;

    Piper(InputStream input, OutputStream output) {
      this.input = input;
      this.output = output;
      this.thread = new Thread(this, "$EXEC Piper");
    }

    /**
     * start - start the Piper in a new daemon thread
     * @return this Piper
     */
    Piper start() {
      thread.setDaemon(true);
      thread.start();
      return this;
    }

    /**
     * run - thread action
     */
    @Override
    public void run() {
      try {
        // Buffer for copying.
        var b = new byte[BUFFER_SIZE];
        // Read from the InputStream until EOF.
        int read;
        while (-1 < (read = input.read(b, 0, b.length))) {
          // Write available date to OutputStream.
          output.write(b, 0, read);
        }
      } catch (Exception e) {
        // Assume the worst.
        throw new RuntimeException("Broken pipe", e);
      } finally {
        // Make sure the streams are closed.
        try {
          input.close();
        } catch (IOException e) {
          // Don't care.
        }
        try {
          output.close();
        } catch (IOException e) {
          // Don't care.
        }
      }
    }

    public void join() throws InterruptedException {
      thread.join();
    }

    // Exit thread.
  }

  // Process exit statuses.
  static final int EXIT_SUCCESS = 0;
  static final int EXIT_FAILURE = 1;

  // Copy of environment variables used by all processes.
  private Map<String, String> environment;
  // Input string if provided on CommandExecutor call.
  private String inputString;
  // Output string if required from CommandExecutor call.
  private String outputString;
  // Error string if required from CommandExecutor call.
  private String errorString;
  // Last process exit code.
  private int exitCode;

  // Input stream if provided on CommandExecutor call.
  private InputStream inputStream;
  // Output stream if provided on CommandExecutor call.
  private OutputStream outputStream;
  // Error stream if provided on CommandExecutor call.
  private OutputStream errorStream;

  // Ordered collection of current or piped ProcessBuilders.
  private List<ProcessBuilder> processBuilders = new ArrayList<>();

  CommandExecutor() {
    this.environment = new HashMap<>();
    this.inputString = "";
    this.outputString = "";
    this.errorString = "";
    this.exitCode = EXIT_SUCCESS;
    this.inputStream = null;
    this.outputStream = null;
    this.errorStream = null;
    this.processBuilders = new ArrayList<>();
  }

  /**
   * envVarValue - return the value of the environment variable key, or deflt if not found.
   * @param key   name of environment variable
   * @param deflt value to return if not found
   * @return value of the environment variable
   */
  String envVarValue(String key, String deflt) {
    return environment.getOrDefault(key, deflt);
  }

  /**
   * envVarLongValue - return the value of the environment variable key as a long value.
   * @param key name of environment variable
   * @return long value of the environment variable
   */
  long envVarLongValue(String key) {
    try {
      return Long.parseLong(envVarValue(key, "0"));
    } catch (NumberFormatException ex) {
      return 0L;
    }
  }

  /**
   * envVarBooleanValue - return the value of the environment variable key as a
   * boolean value.  true if the value was non-zero, false otherwise.
   * @param key name of environment variable
   * @return boolean value of the environment variable
   */
  private boolean envVarBooleanValue(String key) {
    return envVarLongValue(key) != 0;
  }

  /**
   * stripQuotes - strip quotes from token if present.
   * Quoted tokens kept quotes to prevent search for redirects.
   * @param token token to strip
   * @return stripped token
   */
  static String stripQuotes(String token) {
    return ((token.startsWith("\"") && token.endsWith("\"")) || token.startsWith("\'") && token.endsWith("\'")) ? token.substring(1, token.length() - 1) : token;
  }

  /**
   * resolvePath - resolves a path against a current working directory.
   * @param cwd      current working directory
   * @param fileName name of file or directory
   * @return resolved Path to file
   */
  static Path resolvePath(String cwd, String fileName) {
    return Paths.get(sanitizePath(cwd)).resolve(fileName).normalize();
  }

  /**
   * builtIn - checks to see if the command is a builtin and performs appropriate action.
   * @param cmd current command
   * @param cwd current working directory
   * @return true if was a builtin command
   */
  boolean builtIn(List<String> cmd, String cwd) {
    switch (cmd.get(0)) {
      // Set current working directory.
      case "cd" -> {
        var cygpath = IS_WINDOWS && cwd.startsWith(CYGDRIVE);
        // If zero args then use home directory as cwd else use first arg.
        var newCWD = cmd.size() < 2 ? HOME_DIRECTORY : cmd.get(1);
        // Normalize the cwd
        var cwdPath = resolvePath(cwd, newCWD);
        // Check if is a directory.
        var file = cwdPath.toFile();
        if (!file.exists()) {
          reportError("file.not.exist", file.toString());
          return true;
        } else if (!file.isDirectory()) {
          reportError("not.directory", file.toString());
          return true;
        }
        // Set PWD environment variable to be picked up as cwd.
        // Make sure Cygwin paths look like Unix paths.
        var scwd = cwdPath.toString();
        if (cygpath && scwd.length() >= 2 && Character.isLetter(scwd.charAt(0)) && scwd.charAt(1) == ':') {
          scwd = CYGDRIVE + Character.toLowerCase(scwd.charAt(0)) + "/" + scwd.substring(2);
        }
        environment.put("PWD", scwd);
        return true;
      }
      // Set an environment variable.
      case "setenv" -> {
        if (3 <= cmd.size()) {
          var key = cmd.get(1);
          var value = cmd.get(2);
          environment.put(key, value);
        }
        return true;
      }
      // Unset an environment variable.
      case "unsetenv" -> {
        if (2 <= cmd.size()) {
          var key = cmd.get(1);
          environment.remove(key);
        }
        return true;
      }
    }
    return false;
  }

  /**
   * preprocessCommand - scan the command for redirects, and sanitize the executable path
   * @param tokens       command tokens
   * @param cwd          current working directory
   * @param redirectInfo redirection information
   * @return tokens remaining for actual command
   */
  List<String> preprocessCommand(List<String> tokens, String cwd, RedirectInfo redirectInfo) {
    // Tokens remaining for actual command.
    var command = new ArrayList<String>();
    // iterate through all tokens.
    var iterator = tokens.iterator();
    while (iterator.hasNext()) {
      var token = iterator.next();
      // Check if is a redirect.
      if (redirectInfo.check(token, iterator, cwd)) {
        // Don't add to the command.
        continue;
      }
      // Strip quotes and add to command.
      command.add(stripQuotes(token));
    }
    if (command.size() > 0) {
      command.set(0, sanitizePath(command.get(0)));
    }
    return command;
  }

  /**
   * Sanitize a path in case the underlying platform is Cygwin.
   * In that case, convert from the {@code /cygdrive/x} drive specification to the usual Windows {@code X:} format.
   * @param d a String representing a path
   * @return a String representing the same path in a form that can be processed by the underlying platform
   */
  static String sanitizePath(String d) {
    if (!IS_WINDOWS || (IS_WINDOWS && !d.startsWith(CYGDRIVE))) {
      return d;
    }
    var pd = d.substring(CYGDRIVE.length());
    if (pd.length() >= 2 && pd.charAt(1) == '/') {
      // drive letter plus / -> convert /cygdrive/x/... to X:/...
      return pd.charAt(0) + ":" + pd.substring(1);
    } else if (pd.length() == 1) {
      // just drive letter -> convert /cygdrive/x to X:
      return pd.charAt(0) + ":";
    }
    // remaining case: /cygdrive/ -> can't convert
    return d;
  }

  /**
   * createProcessBuilder - create a ProcessBuilder for the command.
   * @param command      command tokens
   * @param cwd          current working directory
   * @param redirectInfo redirect information
   */
  void createProcessBuilder(List<String> command, String cwd, RedirectInfo redirectInfo) {
    // Create new ProcessBuilder.
    var pb = new ProcessBuilder(command);
    // Set current working directory.
    pb.directory(new File(sanitizePath(cwd)));
    // Map environment variables.
    var processEnvironment = pb.environment();
    processEnvironment.clear();
    processEnvironment.putAll(environment);
    // Apply redirects.
    redirectInfo.apply(pb);
    // Add to current list of commands.
    processBuilders.add(pb);
  }

  /**
   * command - process the command
   * @param tokens  tokens of the command
   * @param isPiped true if the output of this command should be piped to the next
   */
  void command(List<String> tokens, boolean isPiped) {
    // Test to see if we should echo the command to output.
    if (envVarBooleanValue("JJS_ECHO")) {
      System.out.println(String.join(" ", tokens));
    }
    // Get the current working directory.
    var cwd = envVarValue("PWD", HOME_DIRECTORY);
    // Preprocess the command for redirects.
    var redirectInfo = new RedirectInfo();
    var command = preprocessCommand(tokens, cwd, redirectInfo);
    // Skip if empty or a built in.
    if (command.isEmpty() || builtIn(command, cwd)) {
      return;
    }
    // Create ProcessBuilder with cwd and redirects set.
    createProcessBuilder(command, cwd, redirectInfo);
    // If piped, wait for the next command.
    if (isPiped) {
      return;
    }
    // Fetch first and last ProcessBuilder.
    var firstProcessBuilder = processBuilders.get(0);
    var lastProcessBuilder = processBuilders.get(processBuilders.size() - 1);
    // Determine which streams have not be redirected from pipes.
    var inputIsPipe = firstProcessBuilder.redirectInput() == Redirect.PIPE;
    var outputIsPipe = lastProcessBuilder.redirectOutput() == Redirect.PIPE;
    var errorIsPipe = lastProcessBuilder.redirectError() == Redirect.PIPE;
    var inheritIO = envVarBooleanValue("JJS_INHERIT_IO");
    // If not redirected and inputStream is current processes' input.
    if (inputIsPipe && (inheritIO || inputStream == System.in)) {
      // Inherit current processes' input.
      firstProcessBuilder.redirectInput(Redirect.INHERIT);
      inputIsPipe = false;
    }
    // If not redirected and outputStream is current processes' output.
    if (outputIsPipe && (inheritIO || outputStream == System.out)) {
      // Inherit current processes' output.
      lastProcessBuilder.redirectOutput(Redirect.INHERIT);
      outputIsPipe = false;
    }
    // If not redirected and errorStream is current processes' error.
    if (errorIsPipe && (inheritIO || errorStream == System.err)) {
      // Inherit current processes' error.
      lastProcessBuilder.redirectError(Redirect.INHERIT);
      errorIsPipe = false;
    }
    // Start the processes.
    var processes = new ArrayList<Process>();
    for (var pb : processBuilders) {
      try {
        processes.add(pb.start());
      } catch (IOException ex) {
        reportError("unknown.command", String.join(" ", pb.command()));
        return;
      }
    }
    // Clear processBuilders for next command.
    processBuilders.clear();
    // Get first and last process.
    var firstProcess = processes.get(0);
    var lastProcess = processes.get(processes.size() - 1);
    // Prepare for string based i/o if no redirection or provided streams.
    ByteArrayOutputStream byteOutputStream = null;
    ByteArrayOutputStream byteErrorStream = null;
    var piperThreads = new ArrayList<Piper>();
    // If input is not redirected.
    if (inputIsPipe) {
      // If inputStream other than System.in is provided.
      if (inputStream != null) {
        // Pipe inputStream to first process output stream.
        piperThreads.add(new Piper(inputStream, firstProcess.getOutputStream()).start());
      } else {
        // Otherwise assume an input string has been provided.
        piperThreads.add(new Piper(new ByteArrayInputStream(inputString.getBytes()), firstProcess.getOutputStream()).start());
      }
    }
    // If output is not redirected.
    if (outputIsPipe) {
      // If outputStream other than System.out is provided.
      if (outputStream != null) {
        // Pipe outputStream from last process input stream.
        piperThreads.add(new Piper(lastProcess.getInputStream(), outputStream).start());
      } else {
        // Otherwise assume an output string needs to be prepared.
        byteOutputStream = new ByteArrayOutputStream(BUFFER_SIZE);
        piperThreads.add(new Piper(lastProcess.getInputStream(), byteOutputStream).start());
      }
    }
    // If error is not redirected.
    if (errorIsPipe) {
      // If errorStream other than System.err is provided.
      if (errorStream != null) {
        piperThreads.add(new Piper(lastProcess.getErrorStream(), errorStream).start());
      } else {
        // Otherwise assume an error string needs to be prepared.
        byteErrorStream = new ByteArrayOutputStream(BUFFER_SIZE);
        piperThreads.add(new Piper(lastProcess.getErrorStream(), byteErrorStream).start());
      }
    }
    // Pipe commands in between.
    for (int i = 0, n = processes.size() - 1; i < n; i++) {
      var prev = processes.get(i);
      var next = processes.get(i + 1);
      piperThreads.add(new Piper(prev.getInputStream(), next.getOutputStream()).start());
    }
    // Wind up processes.
    try {
      // Get the user specified timeout.
      var timeout = envVarLongValue("JJS_TIMEOUT");
      // If user specified timeout (milliseconds.)
      if (timeout != 0) {
        // Wait for last process, with timeout.
        if (lastProcess.waitFor(timeout, TimeUnit.MILLISECONDS)) {
          // Get exit code of last process.
          exitCode = lastProcess.exitValue();
        } else {
          reportError("timeout", Long.toString(timeout));
        }
      } else {
        // Wait for last process and get exit code.
        exitCode = lastProcess.waitFor();
      }
      // Wait for all piper threads to terminate
      for (var piper : piperThreads) {
        piper.join();
      }

      // Accumulate the output and error streams.
      outputString += byteOutputStream != null ? byteOutputStream.toString() : "";
      errorString += byteErrorStream != null ? byteErrorStream.toString() : "";
    } catch (InterruptedException ex) {
      // Kill any living processes.
      processes.stream().forEach(p -> {
        if (p.isAlive()) {
          p.destroy();
        }
        // Get the first error code.
        exitCode = exitCode == 0 ? p.exitValue() : exitCode;
      });
    }
    // If we got a non-zero exit code then possibly throw an exception.
    if (exitCode != 0 && envVarBooleanValue("JJS_THROW_ON_EXIT")) {
      throw ECMAErrors.rangeError("exec.returned.non.zero", ScriptRuntime.safeToString(exitCode));
    }
  }

  /**
   * createTokenizer - build up StreamTokenizer for the command script
   * @param script command script to parsed
   * @return StreamTokenizer for command script
   */
  static StreamTokenizer createTokenizer(String script) {
    var tokenizer = new StreamTokenizer(new StringReader(script));
    tokenizer.resetSyntax();
    // Default all characters to word.
    tokenizer.wordChars(0, 255);
    // Spaces and special characters are white spaces.
    tokenizer.whitespaceChars(0, ' ');
    // Ignore # comments.
    tokenizer.commentChar('#');
    // Handle double and single quote strings.
    tokenizer.quoteChar('"');
    tokenizer.quoteChar('\'');
    // Need to recognize the end of a command.
    tokenizer.eolIsSignificant(true);
    // Command separator.
    tokenizer.ordinaryChar(';');
    // Pipe separator.
    tokenizer.ordinaryChar('|');
    return tokenizer;
  }

  /**
   * process - process a command string
   * @param script command script to parsed
   */
  void process(String script) {
    // Build up StreamTokenizer for the command script.
    var tokenizer = createTokenizer(script);
    // Prepare to accumulate command tokens.
    var command = new ArrayList<String>();
    // Prepare to acumulate partial tokens joined with "\ ".
    var sb = new StringBuilder();
    try {
      // Fetch next token until end of script.
      while (tokenizer.nextToken() != StreamTokenizer.TT_EOF) {
        // Next word token.
        var token = tokenizer.sval;
        // If special token.
        if (token == null) {
          // Flush any partial token.
          if (sb.length() != 0) {
            command.add(sb.append(token).toString());
            sb.setLength(0);
          }
          // Process a completed command.
          // Will be either ';' (command end) or '|' (pipe), true if '|'.
          command(command, tokenizer.ttype == '|');
          if (exitCode != EXIT_SUCCESS) {
            return;
          }
          // Start with a new set of tokens.
          command.clear();
        } else if (token.endsWith("\\")) {
          // Backslash followed by space.
          sb.append(token.substring(0, token.length() - 1)).append(' ');
        } else if (sb.length() == 0) {
          // If not a word then must be a quoted string.
          if (tokenizer.ttype != StreamTokenizer.TT_WORD) {
            // Quote string, sb is free to use (empty.)
            sb.append((char) tokenizer.ttype);
            sb.append(token);
            sb.append((char) tokenizer.ttype);
            token = sb.toString();
            sb.setLength(0);
          }
          command.add(token);
        } else {
          // Partial token pending.
          command.add(sb.append(token).toString());
          sb.setLength(0);
        }
      }
    } catch (IOException ex) {
      // Do nothing.
    }
    // Partial token pending.
    if (sb.length() != 0) {
      command.add(sb.toString());
    }
    // Process last command.
    command(command, false);
  }

  /**
   * process - process a command array of strings
   * @param tokens command script to be processed
   */
  void process(List<String> tokens) {
    // Prepare to accumulate command tokens.
    var command = new ArrayList<String>();
    // Iterate through tokens.
    var iterator = tokens.iterator();
    while (iterator.hasNext() && exitCode == EXIT_SUCCESS) {
      // Next word token.
      var token = iterator.next();
      if (token == null) {
        continue;
      }
      switch (token) {
        case "|" -> {
          // Process as a piped command.
          command(command, true);
          // Start with a new set of tokens.
          command.clear();
          continue;
        }
        case ";" -> {
          // Process as a normal command.
          command(command, false);
          // Start with a new set of tokens.
          command.clear();
          continue;
        }
      }
      command.add(token);
    }
    // Process last command.
    command(command, false);
  }

  void reportError(String msg, String object) {
    errorString += ECMAErrors.getMessage("range.error.exec." + msg, object);
    exitCode = EXIT_FAILURE;
  }

  String getOutputString() {
    return outputString;
  }

  String getErrorString() {
    return errorString;
  }

  int getExitCode() {
    return exitCode;
  }

  void setEnvironment(Map<String, String> environment) {
    this.environment = environment;
  }

  void setInputStream(InputStream inputStream) {
    this.inputStream = inputStream;
  }

  void setInputString(String inputString) {
    this.inputString = inputString;
  }

  void setOutputStream(OutputStream outputStream) {
    this.outputStream = outputStream;
  }

  void setErrorStream(OutputStream errorStream) {
    this.errorStream = errorStream;
  }

}
