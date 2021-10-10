package es.runtime;

import java.io.File;
import java.io.InputStream;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;

import java.security.CodeSource;
import java.security.Permission;
import java.security.PermissionCollection;
import java.security.Permissions;
import java.security.SecureClassLoader;

/**
 * Superclass for Nashorn class loader classes.
 */
abstract class NashornLoader extends SecureClassLoader {

  protected static final String OBJECTS_PKG = "es.objects";
  protected static final String RUNTIME_PKG = "es.runtime";
  protected static final String RUNTIME_ARRAYS_PKG = "es.runtime.arrays";
  protected static final String RUNTIME_LINKER_PKG = "es.runtime.linker";
  protected static final String SCRIPTS_PKG = "es.scripts";
  protected static final String OBJECTS_PKG_INTERNAL = "es/objects";
  protected static final String RUNTIME_PKG_INTERNAL = "es/runtime";
  protected static final String RUNTIME_ARRAYS_PKG_INTERNAL = "es/runtime/arrays";
  protected static final String RUNTIME_LINKER_PKG_INTERNAL = "es/runtime/linker";
  protected static final String SCRIPTS_PKG_INTERNAL = "es/scripts";

  static final Module NASHORN_MODULE = Context.class.getModule();

  private static final Permission[] SCRIPT_PERMISSIONS;

  private static final String MODULE_MANIPULATOR_NAME = SCRIPTS_PKG + ".ModuleGraphManipulator";
  private static final byte[] MODULE_MANIPULATOR_BYTES = readModuleManipulatorBytes();

  static {
    /*
         * Generated classes get access to runtime, runtime.linker, objects, scripts packages.
         * Note that the actual scripts can not access these because Java.type, Packages
         * prevent these restricted packages. And Java reflection and JSR292 access is prevented
         * for scripts. In other words, nashorn generated portions of script classes can access
         * classes in these implementation packages.
     */
    SCRIPT_PERMISSIONS = new Permission[]{
      new RuntimePermission("accessClassInPackage." + RUNTIME_PKG),
      new RuntimePermission("accessClassInPackage." + RUNTIME_LINKER_PKG),
      new RuntimePermission("accessClassInPackage." + OBJECTS_PKG),
      new RuntimePermission("accessClassInPackage." + SCRIPTS_PKG),
      new RuntimePermission("accessClassInPackage." + RUNTIME_ARRAYS_PKG)
    };
  }

  // addExport Method object on ModuleGraphManipulator
  // class loaded by this loader
  private Method addModuleExport;

  NashornLoader(final ClassLoader parent) {
    super(parent);
  }

  void loadModuleManipulator() {
    final Class<?> clazz = defineClass(MODULE_MANIPULATOR_NAME,
            MODULE_MANIPULATOR_BYTES, 0, MODULE_MANIPULATOR_BYTES.length);
    // force class initialization so that <clinit> runs!
    try {
      Class.forName(MODULE_MANIPULATOR_NAME, true, this);
    } catch (final Exception ex) {
      throw new RuntimeException(ex);
    }

      try {
        addModuleExport = clazz.getDeclaredMethod("addExport", Module.class);
        addModuleExport.setAccessible(true);
      } catch (final NoSuchMethodException | SecurityException ex) {
        throw new RuntimeException(ex);
      }

  }

  final void addModuleExport(final Module to) {
    try {
      addModuleExport.invoke(null, to);
    } catch (final IllegalAccessException
            | IllegalArgumentException
            | InvocationTargetException ex) {
      throw new RuntimeException(ex);
    }
  }

  @Override
  protected PermissionCollection getPermissions(final CodeSource codesource) {
    final Permissions permCollection = new Permissions();
    for (final Permission perm : SCRIPT_PERMISSIONS) {
      permCollection.add(perm);
    }
    return permCollection;
  }

  /**
   * Create a secure URL class loader for the given classpath
   * @param classPath classpath for the loader to search from
   * @param parent the parent class loader for the new class loader
   * @return the class loader
   */
  static ClassLoader createClassLoader(final String classPath, final ClassLoader parent) {
    final URL[] urls = pathToURLs(classPath);
    return URLClassLoader.newInstance(urls, parent);
  }

  /*
     * Utility method for converting a search path string to an array
     * of directory and JAR file URLs.
     *
     * @param path the search path string
     * @return the resulting array of directory and JAR file URLs
   */
  private static URL[] pathToURLs(final String path) {
    final String[] components = path.split(File.pathSeparator);
    URL[] urls = new URL[components.length];
    int count = 0;
    while (count < components.length) {
      final URL url = fileToURL(new File(components[count]));
      if (url != null) {
        urls[count++] = url;
      }
    }
    if (urls.length != count) {
      final URL[] tmp = new URL[count];
      System.arraycopy(urls, 0, tmp, 0, count);
      urls = tmp;
    }
    return urls;
  }

  /*
     * Returns the directory or JAR file URL corresponding to the specified
     * local file name.
     *
     * @param file the File object
     * @return the resulting directory or JAR file URL, or null if unknown
   */
  private static URL fileToURL(final File file) {
    String name;
    try {
      name = file.getCanonicalPath();
    } catch (final IOException e) {
      name = file.getAbsolutePath();
    }
    name = name.replace(File.separatorChar, '/');
    if (!name.startsWith("/")) {
      name = "/" + name;
    }
    // If the file does not exist, then assume that it's a directory
    if (!file.isFile()) {
      name += "/";
    }
    try {
      return new URL("file", "", name);
    } catch (final MalformedURLException e) {
      throw new IllegalArgumentException("file");
    }
  }

  private static byte[] readModuleManipulatorBytes() {
      final String res = "/" + MODULE_MANIPULATOR_NAME.replace('.', '/') + ".class";
      try ( InputStream in = NashornLoader.class.getResourceAsStream(res)) {
        return in.readAllBytes();
      } catch (final IOException exp) {
        throw new UncheckedIOException(exp);
      }
  }
}
