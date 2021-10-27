package es.runtime;

import java.util.MissingResourceException;
import java.util.ResourceBundle;

/**
 * Class to handle version strings for Nashorn.
 */
public final class Version {

  /**
   * The current version number as a string.
   * @return version string
   */
  public static String version() {
    return version("version_short");  // E.g. "9-internal" or "9.1.2"
  }

  /**
   * The current full version number as a string.
   * @return full version string
   */
  public static String fullVersion() {
    return version("version_string"); // E.g. "9.1.2.3-ea-4+nashorn-testing"
  }

  private static final String VERSION_RB_NAME = "es.runtime.resources.version";
  private static ResourceBundle versionRB;

  static String version(String key) {
    if (versionRB == null) {
      try {
        versionRB = ResourceBundle.getBundle(VERSION_RB_NAME);
      } catch (MissingResourceException e) {
        return "version not available";
      }
    }
    try {
      return versionRB.getString(key);
    } catch (MissingResourceException e) {
      return "version not available";
    }
  }

}
