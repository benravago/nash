package es.runtime.options;

import java.io.PrintWriter;
import java.text.MessageFormat;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.Objects;
import java.util.ResourceBundle;
import java.util.StringTokenizer;
import java.util.TimeZone;
import java.util.TreeMap;
import java.util.TreeSet;

import es.runtime.QuotedStringTokenizer;

/**
 * Manages global runtime options.
 */
public final class Options {

  // Resource tag.
  private final String resource;

  // Error writer.
  private final PrintWriter err;

  // File list.
  private final List<String> files;

  // Arguments list
  private final List<String> arguments;

  // The options map of enabled options
  private final TreeMap<String, Option<?>> options;

  // System property that can be used to prepend options to the explicitly specified command line.
  private static final String NASHORN_ARGS_PREPEND_PROPERTY = "nashorn.args.prepend";

  // System property that can be used to append options to the explicitly specified command line.
  private static final String NASHORN_ARGS_PROPERTY = "nashorn.args";

  /**
   * Constructor
   *
   * Options will use System.err as the output stream for any errors
   *
   * @param resource resource prefix for options e.g. "nashorn"
   */
  public Options(String resource) {
    this(resource, new PrintWriter(System.err, true));
  }

  /**
   * Constructor
   *
   * @param resource resource prefix for options e.g. "nashorn"
   * @param err      error stream for reporting parse errors
   */
  public Options(String resource, PrintWriter err) {
    this.resource = resource;
    this.err = err;
    this.files = new ArrayList<>();
    this.arguments = new ArrayList<>();
    this.options = new TreeMap<>();

    // set all default values
    for (var t : Options.validOptions) {
      if (t.getDefaultValue() != null) {
        // populate from system properties
        var v = getStringProperty(t.getKey(), null);
        if (v != null) {
          set(t.getKey(), createOption(t, v));
        } else if (t.getDefaultValue() != null) {
          set(t.getKey(), createOption(t, t.getDefaultValue()));
        }
      }
    }
  }

  /**
   * Get the resource for this Options set, e.g. "nashorn"
   * @return the resource
   */
  public String getResource() {
    return resource;
  }

  @Override
  public String toString() {
    return options.toString();
  }

  static void checkPropertyName(String name) {
    if (!Objects.requireNonNull(name).startsWith("nashorn.")) {
      throw new IllegalArgumentException(name);
    }
  }

  /**
   * Convenience function for getting system properties in a safe way

   * @param name of boolean property
   * @param defValue default value of boolean property
   * @return true if set to true, default value if unset or set to false
   */
  public static boolean getBooleanProperty(String name, Boolean defValue) {
    checkPropertyName(name);
    try {
      var property = System.getProperty(name);
      if (property == null && defValue != null) {
        return defValue;
      }
      return property != null && !"false".equalsIgnoreCase(property);
    } catch (SecurityException e) {
      // if no permission to read, assume false
      return false;
    }
  }

  /**
   * Convenience function for getting system properties in a safe way

   * @param name of boolean property
   * @return true if set to true, false if unset or set to false
   */
  public static boolean getBooleanProperty(String name) {
    return getBooleanProperty(name, null);
  }

  /**
   * Convenience function for getting system properties in a safe way
   *
   * @param name of string property
   * @param defValue the default value if unset
   * @return string property if set or default value
   */
  public static String getStringProperty(String name, String defValue) {
    checkPropertyName(name);
    try {
      return System.getProperty(name, defValue);
    } catch (SecurityException e) {
      // if no permission to read, assume the default value
      return defValue;
    }
  }

  /**
   * Convenience function for getting system properties in a safe way
   *
   * @param name of integer property
   * @param defValue the default value if unset
   * @return integer property if set or default value
   */
  public static int getIntProperty(String name, int defValue) {
    checkPropertyName(name);
    try {
      return Integer.getInteger(name, defValue);
    } catch (SecurityException e) {
      // if no permission to read, assume the default value
      return defValue;
    }
  }

  /**
   * Return an option given its resource key. If the key doesn't begin with
   * {@literal <resource>}.option it will be completed using the resource from this
   * instance
   *
   * @param key key for option
   * @return an option value
   */
  public Option<?> get(String key) {
    return options.get(key(key));
  }

  /**
   * Return an option as a boolean
   *
   * @param key key for option
   * @return an option value
   */
  public boolean getBoolean(String key) {
    var option = get(key);
    return option != null ? (Boolean) option.getValue() : false;
  }

  /**
   * Return an option as a integer
   *
   * @param key key for option
   * @return an option value
   */
  public int getInteger(String key) {
    var option = get(key);
    return option != null ? (Integer) option.getValue() : 0;
  }

  /**
   * Return an option as a String
   *
   * @param key key for option
   * @return an option value
   */
  public String getString(String key) {
    var option = get(key);
    if (option != null) {
      var value = (String) option.getValue();
      if (value != null) {
        return value.intern();
      }
    }
    return null;
  }

  /**
   * Set an option, overwriting an existing state if one exists
   *
   * @param key    option key
   * @param option option
   */
  public void set(String key, Option<?> option) {
    options.put(key(key), option);
  }

  /**
   * Set an option as a boolean value, overwriting an existing state if one exists
   *
   * @param key    option key
   * @param option option
   */
  public void set(String key, boolean option) {
    set(key, new Option<>(option));
  }

  /**
   * Set an option as a String value, overwriting an existing state if one exists
   *
   * @param key    option key
   * @param option option
   */
  public void set(String key, String option) {
    set(key, new Option<>(option));
  }

  /**
   * Return the user arguments to the program, i.e. those trailing "--" after
   * the filename
   *
   * @return a list of user arguments
   */
  public List<String> getArguments() {
    return Collections.unmodifiableList(this.arguments);
  }

  /**
   * Return the JavaScript files passed to the program
   *
   * @return a list of files
   */
  public List<String> getFiles() {
    return Collections.unmodifiableList(files);
  }

  /**
   * Return the option templates for all the valid option supported.
   *
   * @return a collection of OptionTemplate objects.
   */
  public static Collection<OptionTemplate> getValidOptions() {
    return Collections.unmodifiableCollection(validOptions);
  }

  /**
   * Make sure a key is fully qualified for table lookups
   *
   * @param shortKey key for option
   * @return fully qualified key
   */
  private String key(String shortKey) {
    var key = shortKey;
    while (key.startsWith("-")) {
      key = key.substring(1, key.length());
    }
    key = key.replace("-", ".");
    var keyPrefix = this.resource + ".option.";
    if (key.startsWith(keyPrefix)) {
      return key;
    }
    return keyPrefix + key;
  }

  static String getMsg(String msgId, String... args) {
    try {
      var msg = Options.bundle.getString(msgId);
      if (args.length == 0) {
        return msg;
      }
      return new MessageFormat(msg).format(args);
    } catch (MissingResourceException e) {
      throw new IllegalArgumentException(e);
    }
  }

  /**
   * Processes the arguments and stores their information. Throws
   * IllegalArgumentException on error. The message can be analyzed by the
   * displayHelp function to become more context sensitive
   *
   * @param args arguments from command line
   */
  public void process(String[] args) {
    var argList = new LinkedList<String>();
    addSystemProperties(NASHORN_ARGS_PREPEND_PROPERTY, argList);
    processArgList(argList);
    assert argList.isEmpty();
    Collections.addAll(argList, args);
    processArgList(argList);
    assert argList.isEmpty();
    addSystemProperties(NASHORN_ARGS_PROPERTY, argList);
    processArgList(argList);
    assert argList.isEmpty();
  }

  void processArgList(LinkedList<String> argList) {
    while (!argList.isEmpty()) {
      var arg = argList.remove(0);
      Objects.requireNonNull(arg);

      // skip empty args
      if (arg.isEmpty()) {
        continue;
      }

      // user arguments to the script
      if ("--".equals(arg)) {
        arguments.addAll(argList);
        argList.clear();
        continue;
      }

      // If it doesn't start with -, it's a file.
      // But, if it is just "-", then it is a file representing standard input.
      if (!arg.startsWith("-") || arg.length() == 1) {
        files.add(arg);
        continue;
      }

      if (arg.startsWith(definePropPrefix)) {
        var value = arg.substring(definePropPrefix.length());
        var eq = value.indexOf('=');
        if (eq != -1) {
          // -Dfoo=bar Set System property "foo" with value "bar"
          System.setProperty(value.substring(0, eq), value.substring(eq + 1));
        } else {
          // -Dfoo is fine. Set System property "foo" with "" as it's value
          if (!value.isEmpty()) {
            System.setProperty(value, "");
          } else {
            // do not allow empty property name
            throw new IllegalOptionException(definePropTemplate);
          }
        }
        continue;
      }

      // it is an argument,  it and assign key, value and template
      var parg = new ParsedArg(arg);

      // check if the value of this option is passed as next argument
      if (parg.template.isValueNextArg()) {
        if (argList.isEmpty()) {
          throw new IllegalOptionException(parg.template);
        }
        parg.value = argList.remove(0);
      }

      // -h [args...]
      if (parg.template.isHelp()) {
        // check if someone wants help on an explicit arg
        if (!argList.isEmpty()) {
          try {
            var t = new ParsedArg(argList.get(0)).template;
            throw new IllegalOptionException(t);
          } catch (IllegalArgumentException e) {
            throw e;
          }
        }
        throw new IllegalArgumentException(); // show help for
        // everything
      }

      if (parg.template.isXHelp()) {
        throw new IllegalOptionException(parg.template);
      }

      if (parg.template.isRepeated()) {
        assert parg.template.getType().equals("string");

        var key = key(parg.template.getKey());
        var value = options.containsKey(key)
          ? (options.get(key).getValue() + "," + parg.value)
          : Objects.toString(parg.value);
        options.put(key, new Option<>(value));
      } else {
        set(parg.template.getKey(), createOption(parg.template, parg.value));
      }

      // Arg may have a dependency to set other args, e.g. scripting->anon.functions
      if (parg.template.getDependency() != null) {
        argList.addFirst(parg.template.getDependency());
      }
    }
  }

  static void addSystemProperties(String sysPropName, List<String> argList) {
    var sysArgs = getStringProperty(sysPropName, null);
    if (sysArgs != null) {
      var st = new StringTokenizer(sysArgs);
      while (st.hasMoreTokens()) {
        argList.add(st.nextToken());
      }
    }
  }

  /**
   * Retrieves an option template identified by key.
   * @param shortKey the short (that is without the e.g. "nashorn.option." part) key
   * @return the option template identified by the key
   * @throws IllegalArgumentException if the key doesn't specify an existing template
   */
  public OptionTemplate getOptionTemplateByKey(String shortKey) {
    var fullKey = key(shortKey);
    for (var t : validOptions) {
      if (t.getKey().equals(fullKey)) {
        return t;
      }
    }
    throw new IllegalArgumentException(shortKey);
  }

  static OptionTemplate getOptionTemplateByName(String name) {
    for (var t : Options.validOptions) {
      if (t.nameMatches(name)) {
        return t;
      }
    }
    return null;
  }

  static Option<?> createOption(OptionTemplate t, String value) {
    return switch (t.getType()) {

      case "string" -> new Option<>(value); // default value null
      case "timezone" -> new Option<>(TimeZone.getTimeZone(value)); // default value "TimeZone.getDefault()"
      case "locale" -> new Option<>(Locale.forLanguageTag(value));
      case "keyvalues" -> new KeyValueOption(value);
      case "boolean" -> new Option<>(value != null && Boolean.parseBoolean(value));

      case "integer" -> {
        try {
          yield new Option<>(value == null ? 0 : Integer.parseInt(value));
        } catch (NumberFormatException nfe) {
          throw new IllegalOptionException(t);
        }
      }

      case "properties" -> {
        // swallow the properties and set them
        initProps(new KeyValueOption(value));
        yield null;
      }

      default -> {
        throw new IllegalArgumentException(value);
      }
    };

  }

  static void initProps(KeyValueOption kv) {
    for (var entry : kv.getValues().entrySet()) {
      System.setProperty(entry.getKey(), entry.getValue());
    }
  }

  // Resource name for properties file
  private static final String MESSAGES_RESOURCE = "es.runtime.resources.Options";

  // Resource bundle for properties file
  private static ResourceBundle bundle;

  // Usages per resource from properties file
  private static HashMap<Object, Object> usage;

  // Valid options from templates in properties files
  private static Collection<OptionTemplate> validOptions;

  // Help option
  private static OptionTemplate helpOptionTemplate;

  // Define property option template.
  private static OptionTemplate definePropTemplate;

  // Prefix of "define property" option.
  private static String definePropPrefix;

  static {
    Options.bundle = ResourceBundle.getBundle(Options.MESSAGES_RESOURCE, Locale.getDefault());
    Options.validOptions = new TreeSet<>();
    Options.usage = new HashMap<>();

    for (var keys = Options.bundle.getKeys(); keys.hasMoreElements();) {
      var key = keys.nextElement();
      var st = new StringTokenizer(key, ".");
      String resource = null;
      String type = null;

      if (st.countTokens() > 0) {
        resource = st.nextToken(); // e.g. "nashorn"
      }

      if (st.countTokens() > 0) {
        type = st.nextToken(); // e.g. "option"
      }

      if ("option".equals(type)) {
        String helpKey = null;
        String xhelpKey = null;
        String definePropKey = null;
        try {
          helpKey = Options.bundle.getString(resource + ".options.help.key");
          xhelpKey = Options.bundle.getString(resource + ".options.xhelp.key");
          definePropKey = Options.bundle.getString(resource + ".options.D.key");
        } catch (MissingResourceException e) {
          //ignored: no help
        }
        var isHelp = key.equals(helpKey);
        var isXHelp = key.equals(xhelpKey);
        var t = new OptionTemplate(resource, key, Options.bundle.getString(key), isHelp, isXHelp);

        Options.validOptions.add(t);
        if (isHelp) {
          helpOptionTemplate = t;
        }

        if (key.equals(definePropKey)) {
          definePropPrefix = t.getName();
          definePropTemplate = t;
        }
      } else if (resource != null && "options".equals(type)) {
        Options.usage.put(resource, Options.bundle.getObject(key));
      }
    }
  }

  static class IllegalOptionException extends IllegalArgumentException {

    private final OptionTemplate template;

    IllegalOptionException(OptionTemplate t) {
      super();
      this.template = t;
    }

    OptionTemplate getTemplate() {
      return this.template;
    }
  }

  /**
   * This is a resolved argument of the form key=value
   */
  static class ParsedArg {

    // The resolved option template this argument corresponds to
    OptionTemplate template;

    // The value of the argument
    String value;

    ParsedArg(String argument) {
      var st = new QuotedStringTokenizer(argument, "=");
      if (!st.hasMoreTokens()) {
        throw new IllegalArgumentException();
      }

      var token = st.nextToken();
      this.template = getOptionTemplateByName(token);
      if (this.template == null) {
        throw new IllegalArgumentException(argument);
      }

      value = "";
      if (st.hasMoreTokens()) {
        while (st.hasMoreTokens()) {
          value += st.nextToken();
          if (st.hasMoreTokens()) {
            value += ':';
          }
        }
      } else if ("boolean".equals(this.template.getType())) {
        value = "true";
      }
    }
  }

}
