package nash.scripting;

import java.util.regex.Pattern;

/**
 * Formatter is a class to get the type conversion between javascript types and java types for the format (sprintf) method working.
 * <p>
 * In javascript the type for numbers can be different from the format type specifier.
 * For format type '%d', '%o', '%x', '%X' double need to be converted to integer.
 * For format type 'e', 'E', 'f', 'g', 'G', 'a', 'A' integer needs to be converted to double.
 * <p>
 * Format type "%c" and javascript string needs special handling.
 * <p>
 * The javascript date objects can be handled if they are type double (the related javascript code will convert with Date.getTime() to double).
 * So double date types are converted to long.
 * <p>
 * Pattern and the logic for parameter position: java.util.Formatter
 */
final class Formatter {

  /**
   * Method which converts javascript types to java types for the String.format method (jrunscript function sprintf).
   *
   * @param format a format string
   * @param args arguments referenced by the format specifiers in format
   * @return a formatted string
   */
  static String format(String format, Object[] args) {
    var m = FS_PATTERN.matcher(format);
    var positionalParameter = 1;

    while (m.find()) {
      var index = index(m.group(1));
      var previous = isPreviousArgument(m.group(2));
      var conversion = m.group(6).charAt(0);

      // skip over some formats
      if (index < 0 || previous || conversion == 'n' || conversion == '%') {
        continue;
      }

      // index 0 here means take a positional parameter
      if (index == 0) {
        index = positionalParameter++;
      }

      // out of index, String.format will handle
      if (index > args.length) {
        continue;
      }

      // current argument
      var arg = args[index - 1];

      // for date we convert double to long
      if (m.group(5) != null) {
        // convert double to long
        if (arg instanceof Double d) {
          args[index - 1] = d.longValue();
        }
      } else {
        // we have to convert some types
        switch (conversion) {

          case 'd', 'o', 'x', 'X' -> {
            if (arg instanceof Double d) {
              // convert double to long
              args[index - 1] = d.longValue();
            } else if (arg instanceof String s && s.length() > 0) {
              // convert string (first character) to int
              args[index - 1] = (int) s.charAt(0);
            }
          }

          case 'e', 'E', 'f', 'g', 'G', 'a', 'A' -> {
            if (arg instanceof Integer i) {
              // convert integer to double
              args[index - 1] = i.doubleValue();
            }
          }

          case 'c' -> {
            if (arg instanceof Double d) {
              // convert double to integer
              args[index - 1] = d.intValue();
            } else if (arg instanceof String s && s.length() > 0) {
              // get the first character from string
              args[index - 1] = (int) s.charAt(0);
            }
          }

          default -> {}
        }
      }
    }

    return String.format(format, args);
  }

  /**
   * Method to parse the integer of the argument index.
   *
   * @param s string to parse
   * @return -1 if parsing failed, 0 if string is null, > 0 integer
   */
  static int index(String s) {
    var index = -1;

    if (s != null) {
      try {
        index = Integer.parseInt(s.substring(0, s.length() - 1));
      } catch (NumberFormatException e) {
        // ignored
      }
    } else {
      index = 0;
    }

    return index;
  }

  /**
   * Method to check if a string contains '&lt;'.
   * This is used to find out if previous parameter is used.
   *
   * @param s string to check
   * @return true if '&lt;' is in the string, else false
   */
  static boolean isPreviousArgument(String s) {
    return (s != null && s.indexOf('<') >= 0);
  }

  // compiled format string
  static final Pattern FS_PATTERN;

  static {
    FS_PATTERN = Pattern.compile(
      "%(\\d+\\$)?([-#+ 0,(\\<]*)?(\\d+)?(\\.\\d+)?([tT])?([a-zA-Z%])");
    // %[argument_index$][flags][width][.precision][t]conversion
  }

}
