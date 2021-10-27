package es.runtime;

import java.util.Map;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

import es.codegen.OptimisticTypesPersistence;
import es.codegen.types.Type;
import es.runtime.logging.DebugLogger;
import es.runtime.logging.Loggable;
import es.runtime.logging.Logger;
import es.runtime.options.Options;

/**
 * A code cache for persistent caching of compiled scripts.
 */
@Logger(name = "codestore")
public abstract class CodeStore implements Loggable {

  private DebugLogger log;

  @Override
  public DebugLogger initLogger(Context context) {
    log = context.getLogger(getClass());
    return log;
  }

  @Override
  public DebugLogger getLogger() {
    return log;
  }

  /**
   * Returns a new code store instance.
   * @param context the current context
   * @return The instance, or null if code store could not be created
   */
  public static CodeStore newCodeStore(Context context) {
    try {
      var store = new DirectoryCodeStore(context);
      store.initLogger(context);
      return store;
    } catch (IOException e) {
      context.getLogger(CodeStore.class).warning("failed to create cache directory ", e);
      return null;
    }
  }

  /**
   * Store a compiled script in the cache.
   * @param functionKey   the function key
   * @param source        the source
   * @param mainClassName the main class name
   * @param classBytes    a map of class bytes
   * @param initializers  the function initializers
   * @param constants     the constants array
   * @param compilationId the compilation id
   * @return stored script
   */
  public StoredScript store(String functionKey, Source source, String mainClassName, Map<String, byte[]> classBytes, Map<Integer, FunctionInitializer> initializers, Object[] constants, int compilationId) {
    return store(functionKey, source, storedScriptFor(source, mainClassName, classBytes, initializers, constants, compilationId));
  }

  /**
   * Stores a compiled script.
   * @param functionKey the function key
   * @param source the source
   * @param script The compiled script
   * @return The compiled script or {@code null} if not stored
   */
  public abstract StoredScript store(String functionKey, Source source, StoredScript script);

  /**
   * Return a compiled script from the cache, or null if it isn't found.
   * @param source      the source
   * @param functionKey the function key
   * @return the stored script or null
   */
  public abstract StoredScript load(Source source, String functionKey);

  /**
   * Returns a new StoredScript instance.
   * @param source the source
   * @param mainClassName the main class name
   * @param classBytes a map of class bytes
   * @param initializers function initializers
   * @param constants the constants array
   * @param compilationId the compilation id
   * @return The compiled script
   */
  public StoredScript storedScriptFor(Source source, String mainClassName, Map<String, byte[]> classBytes, Map<Integer, FunctionInitializer> initializers, Object[] constants, int compilationId) {
    for (var constant : constants) {
      // Make sure all constant data is serializable
      if (!(constant instanceof Serializable)) {
        getLogger().warning("cannot store ", source, " non serializable constant ", constant);
        return null;
      }
    }
    return new StoredScript(compilationId, mainClassName, classBytes, initializers, constants);
  }

  /**
   * Generate a string representing the function with {@code functionId} and {@code paramTypes}.
   * @param functionId function id
   * @param paramTypes parameter types
   * @return a string representing the function
   */
  public static String getCacheKey(Object functionId, Type[] paramTypes) {
    var b = new StringBuilder().append(functionId);
    if (paramTypes != null && paramTypes.length > 0) {
      b.append('-');
      for (var t : paramTypes) {
        b.append(Type.getShortSignatureDescriptor(t));
      }
    }
    return b.toString();
  }

  /**
   * A store using a file system directory.
   */
  public static class DirectoryCodeStore extends CodeStore {

    // Default minimum size for storing a compiled script class
    private final static int DEFAULT_MIN_SIZE = 1000;

    private final File dir;
    private final boolean readOnly;
    private final int minSize;

    /**
     * Constructor
     *
     * @param context the current context
     * @throws IOException if there are read/write problems with the cache and cache directory
     */
    public DirectoryCodeStore(Context context) throws IOException {
      this(context, Options.getStringProperty("nashorn.persistent.code.cache", "nashorn_code_cache"), false, DEFAULT_MIN_SIZE);
    }

    /**
     * Constructor
     *
     * @param context the current context
     * @param path    directory to store code in
     * @param readOnly is this a read only code store
     * @param minSize minimum file size for caching scripts
     * @throws IOException if there are read/write problems with the cache and cache directory
     */
    public DirectoryCodeStore(Context context, String path, boolean readOnly, int minSize) throws IOException {
      this.dir = checkDirectory(path, context.getEnv(), readOnly);
      this.readOnly = readOnly;
      this.minSize = minSize;
    }

    static File checkDirectory(String path, ScriptEnvironment env, boolean readOnly) throws IOException {
      var dir = new File(path, getVersionDir(env)).getAbsoluteFile();
      if (readOnly) {
        if (!dir.exists() || !dir.isDirectory()) {
          throw new IOException("Not a directory: " + dir.getPath());
        } else if (!dir.canRead()) {
          throw new IOException("Directory not readable: " + dir.getPath());
        }
      } else if (!dir.exists() && !dir.mkdirs()) {
        throw new IOException("Could not create directory: " + dir.getPath());
      } else if (!dir.isDirectory()) {
        throw new IOException("Not a directory: " + dir.getPath());
      } else if (!dir.canRead() || !dir.canWrite()) {
        throw new IOException("Directory not readable or writable: " + dir.getPath());
      }
      return dir;
    }

    static String getVersionDir(ScriptEnvironment env) throws IOException {
      try {
        var versionDir = OptimisticTypesPersistence.getVersionDirName();
        return env._optimistic_types ? versionDir + "_opt" : versionDir;
      } catch (Exception e) {
        throw new IOException(e);
      }
    }

    @Override
    public StoredScript load(Source source, String functionKey) {
      if (belowThreshold(source)) {
        return null;
      }
      var file = getCacheFile(source, functionKey);
      try {
        if (!file.exists()) {
          return null;
        }
        try (var in = new ObjectInputStream(new BufferedInputStream(new FileInputStream(file)))) {
          var storedScript = (StoredScript) in.readObject();
          getLogger().info("loaded ", source, "-", functionKey);
          return storedScript;
        }
      } catch (Exception e) {
        getLogger().warning("failed to load ", source, "-", functionKey, ": ", e);
        return null;
      }
    }

    @Override
    public StoredScript store(String functionKey, Source source, StoredScript script) {
      if (readOnly || script == null || belowThreshold(source)) {
        return null;
      }
      var file = getCacheFile(source, functionKey);

      try {
        try (var out = new ObjectOutputStream(new BufferedOutputStream(new FileOutputStream(file)))) {
          out.writeObject(script);
        }
        getLogger().info("stored ", source, "-", functionKey);
        return script;
      } catch (Exception e) {
        getLogger().warning("failed to store ", script, "-", functionKey, ": ", e);
        return null;
      }
    }

    File getCacheFile(Source source, String functionKey) {
      return new File(dir, source.getDigest() + '-' + functionKey);
    }

    boolean belowThreshold(Source source) {
      if (source.getLength() < minSize) {
        getLogger().info("below size threshold ", source);
        return true;
      }
      return false;
    }
  }

}
