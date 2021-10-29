package es.runtime;

import java.util.Collection;
import java.util.Map;

import es.codegen.ClassEmitter;

/**
 * Interface for installing classes passed to the compiler.
 *
 * As only the code generating package (i.e. Context) knows about the ScriptLoader and it would be a security hazard otherwise the Compiler is given an installation interface for its code.
 * The compiler still retains most of the state around code emission and management internally, so this is to avoid passing around any logic that isn't directly related to installing a class
 */
public interface CodeInstaller {

  /**
   * Return the {@link Context} associated with this code installer.
   * @return the context.
   */
  Context getContext();

  /**
   * Install a class.
   * @param className name of the class with / separation
   * @param bytecode  bytecode
   * @return the installed class
   */
  Class<?> install(String className, byte[] bytecode);

  /**
   * Initialize already installed classes.
   * @param classes the class to initialize
   * @param source the source object for the classes
   * @param constants the runtime constants for the classes
   */
  void initialize(Collection<Class<?>> classes, Source source, Object[] constants);

  /**
   * Get next unique script id
   * @return unique script id
   */
  long getUniqueScriptId();

  /**
   * Store a compiled script for later reuse
   * @param cacheKey key to use in cache
   * @param source the script source
   * @param mainClassName the main class name
   * @param classBytes map of class names to class bytes
   * @param initializers compilation id -&gt; FunctionInitializer map
   * @param constants constants array
   * @param compilationId compilation id
   */
  void storeScript(String cacheKey, Source source, String mainClassName, Map<String, byte[]> classBytes, Map<Integer, FunctionInitializer> initializers, Object[] constants, int compilationId);

  /**
   * Load a previously compiled script
   * @param source the script source
   * @param functionKey the function id and signature
   * @return compiled script data
   */
  StoredScript loadScript(Source source, String functionKey);

  /**
   * Returns a code installer {@code #isCompatibleWith(CodeInstaller) compatible with} this installer, but is suitable for on-demand compilations. Can return itself if it is itself suitable.
   * @return a compatible code installer suitable for on-demand compilations.
   */
  CodeInstaller getOnDemandCompilationInstaller();

  /**
   * Returns a code installer {@code #isCompatibleWith(CodeInstaller) compatible with} this installer, but is suitable for installation of multiple classes that reference each other by name.
   * Should be used when a compilation job produces multiple compilation units. Can return itself if it is itself suitable.
   * @return a compatible code installer suitable for installation of multiple classes.
   */
  CodeInstaller getMultiClassCodeInstaller();

  /**
   * Returns true if this code installer is compatible with the other code installer.
   * Compatibility is expected to be an equivalence relation, and installers are supposed to be compatible with those they create using {@link #getOnDemandCompilationInstaller()}.
   * @param other the other code installer tested for compatibility with this code installer.
   * @return true if this code installer is compatible with the other code installer.
   */
  boolean isCompatibleWith(CodeInstaller other);

}
