package es.runtime.options;

import java.util.Locale;
import java.util.TimeZone;
import es.runtime.QuotedStringTokenizer;

/**
 * This describes the valid input for an option, as read from the resource bundle file.
 *
 * Metainfo such as parameters and description is here as well for context sensitive help generation.
 */
public final class OptionTemplate implements Comparable<OptionTemplate> {

  // Resource, e.g. "nashorn" for this option
  private final String resource;

  // Key in the resource bundle
  private final String key;

  // Is this option a help option?
  private final boolean isHelp;

  // Is this option a extended help option?
  private final boolean isXHelp;

  // Name - for example --dump-on-error (usually prefixed with --)
  private String name;

  // Short name - for example -doe (usually prefixed with -)
  private String shortName;

  // Params - a parameter template string
  private String params;

  // Type - e.g. "boolean".
  private String type;

  // Does this option have a default value?
  private String defaultValue;

  // Does this option activate another option when set?
  private String dependency;

  // Does this option conflict with another?
  private String conflict;

  // Is this a documented option that should show up in help?
  private boolean isUndocumented;

  // A longer description of what this option does
  private String description;

  // is the option value specified as next argument?
  private boolean valueNextArg;

  /**
   * Can this option be repeated in command line?
   *
   * For a repeatable option, multiple values will be merged as comma separated values
   * rather than the last value overriding previous ones.
   */
  private boolean repeated;

  OptionTemplate(String resource, String key, String value, boolean isHelp, boolean isXHelp) {
    this.resource = resource;
    this.key = key;
    this.isHelp = isHelp;
    this.isXHelp = isXHelp;
    parse(value);
  }

  /**
   * Is this the special help option, used to generate help for all the others
   * @return true if this is the help option
   */
  public boolean isHelp() {
    return this.isHelp;
  }

  /**
   * Is this the special extended help option, used to generate extended help for all the others
   * @return true if this is the extended help option
   */
  public boolean isXHelp() {
    return this.isXHelp;
  }

  /**
   * Get the resource name used to prefix this option set, e.g. "nashorn"
   * @return the name of the resource
   */
  public String getResource() {
    return this.resource;
  }

  /**
   * Get the type of this option
   * @return the type of the option
   */
  public String getType() {
    return this.type;
  }

  /**
   * Get the key of this option
   * @return the key
   */
  public String getKey() {
    return this.key;
  }

  /**
   * Get the default value for this option
   * @return the default value as a string
   */
  public String getDefaultValue() {
    switch (getType()) {
      case "boolean" -> {
        if (this.defaultValue == null) {
          this.defaultValue = "false";
        }
      }
      case "integer" -> {
        if (this.defaultValue == null) {
          this.defaultValue = "0";
        }
      }
      case "timezone" -> {
        this.defaultValue = TimeZone.getDefault().getID();
      }
      case "locale" -> {
        this.defaultValue = Locale.getDefault().toLanguageTag();
      }
      default -> {
        // ignore
      }
    }
    return this.defaultValue;
  }

  /**
   * Does this option automatically enable another option, i.e. a dependency.
   * @return the dependency or null if none exists
   */
  public String getDependency() {
    return this.dependency;
  }

  /**
   * Is this option in conflict with another option so that both can't be enabled at the same time
   * @return the conflicting option or null if none exists
   */
  public String getConflict() {
    return this.conflict;
  }

  /**
   * Is this option undocumented, i.e. should not show up in the standard help output
   * @return true if option is undocumented
   */
  public boolean isUndocumented() {
    return this.isUndocumented;
  }

  /**
   * Get the short version of this option name if one exists, e.g. "-co" for "--compile-only"
   * @return the short name
   */
  public String getShortName() {
    return this.shortName;
  }

  /**
   * Get the name of this option, e.g. "--compile-only". A name always exists
   * @return the name of the option
   */
  public String getName() {
    return this.name;
  }

  /**
   * Get the description of this option.
   * @return the description
   */
  public String getDescription() {
    return this.description;
  }

  /**
   * Is value of this option passed as next argument?
   * @return boolean
   */
  public boolean isValueNextArg() {
    return valueNextArg;
  }

  /**
   * Can this option be repeated?
   * @return boolean
   */
  public boolean isRepeated() {
    return repeated;
  }

  static String strip(String value, char start, char end) {
    var len = value.length();
    if (len > 1 && value.charAt(0) == start && value.charAt(len - 1) == end) {
      return value.substring(1, len - 1);
    }
    return null;
  }

  void parse(String origValue) {
    var value = origValue.trim();

    try {
      value = OptionTemplate.strip(value, '{', '}');
      var keyValuePairs = new QuotedStringTokenizer(value, ",");

      while (keyValuePairs.hasMoreTokens()) {
        var keyValue = keyValuePairs.nextToken();
        var st = new QuotedStringTokenizer(keyValue, "=");
        var keyToken = st.nextToken();
        var arg = st.nextToken();

        switch (keyToken) {
          case "is_undocumented" -> {
            this.isUndocumented = Boolean.parseBoolean(arg);
          }
          case "name" -> {
            if (!arg.startsWith("-")) {
              throw new IllegalArgumentException(arg);
            }
            this.name = arg;
          }
          case "short_name" -> {
            if (!arg.startsWith("-")) {
              throw new IllegalArgumentException(arg);
            }
            this.shortName = arg;
          }
          case "desc" -> {
            this.description = arg;
          }
          case "params" -> {
            this.params = arg;
          }
          case "type" -> {
            this.type = arg.toLowerCase(Locale.ENGLISH);
          }
          case "default" -> {
            this.defaultValue = arg;
          }
          case "dependency" -> {
            this.dependency = arg;
          }
          case "conflict" -> {
            this.conflict = arg;
          }
          case "value_next_arg" -> {
            this.valueNextArg = Boolean.parseBoolean(arg);
          }
          case "repeated" -> {
            this.repeated = true;
          }
          default -> {
            throw new IllegalArgumentException(keyToken);
          }
        }
      }

      // default to boolean if no type is given
      if (this.type == null) {
        this.type = "boolean";
      }

      if (this.params == null && "boolean".equals(this.type)) {
        this.params = "[true|false]";
      }

    } catch (Exception e) {
      throw new IllegalArgumentException(origValue);
    }

    if (name == null && shortName == null) {
      throw new IllegalArgumentException(origValue);
    }

    if (this.repeated && !"string".equals(this.type)) {
      throw new IllegalArgumentException("repeated option should be of type string: " + this.name);
    }
  }

  boolean nameMatches(String aName) {
    return aName.equals(this.shortName) || aName.equals(this.name);
  }

  private static final int LINE_BREAK = 64;

  @Override
  public String toString() {
    var sb = new StringBuilder();

    sb.append('\t');

    if (shortName != null) {
      sb.append(shortName);
      if (name != null) {
        sb.append(", ");
      }
    }

    if (name != null) {
      sb.append(name);
    }

    if (description != null) {
      var indent = sb.length();
      sb.append(' ');
      sb.append('(');
      var pos = 0;
      for (var c : description.toCharArray()) {
        sb.append(c);
        pos++;
        if (pos >= LINE_BREAK && Character.isWhitespace(c)) {
          pos = 0;
          sb.append("\n\t");
          for (var i = 0; i < indent; i++) {
            sb.append(' ');
          }
        }
      }
      sb.append(')');
    }

    if (params != null) {
      sb.append('\n');
      sb.append('\t');
      sb.append('\t');
      sb.append(Options.getMsg("nashorn.options.param")).append(": ");
      sb.append(params);
      sb.append("   ");
      var def = this.getDefaultValue();
      if (def != null) {
        sb.append(Options.getMsg("nashorn.options.default")).append(": ");
        sb.append(this.getDefaultValue());
      }
    }

    return sb.toString();
  }

  @Override
  public int compareTo(OptionTemplate o) {
    return this.getKey().compareTo(o.getKey());
  }

}
