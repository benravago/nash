package es.runtime;

import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import java.io.File;
import java.io.PrintWriter;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.security.CodeSigner;
import java.security.CodeSource;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.invoke.SwitchPoint;
import java.lang.module.ModuleDescriptor;
import java.lang.module.ModuleFinder;
import java.lang.module.ModuleReader;
import java.lang.module.ModuleReference;
import java.lang.ref.ReferenceQueue;
import java.lang.ref.SoftReference;
import java.lang.reflect.Modifier;

import jdk.dynalink.DynamicLinker;

import javax.script.ScriptEngine;
import nash.scripting.ClassFilter;

import es.codegen.Compiler;
import es.codegen.ObjectClassGenerator;
import es.objects.Global;
import es.parser.Parser;
import es.runtime.linker.Bootstrap;
import es.runtime.options.Options;
import static es.codegen.CompilerConstants.*;
import static es.runtime.ScriptRuntime.UNDEFINED;
import static es.runtime.Source.sourceFor;

/**
 * This class manages the global state of execution. Context is immutable.
 */
public final class Context {

  private static final MethodHandles.Lookup LOOKUP = MethodHandles.lookup();
  private static final MethodType CREATE_PROGRAM_FUNCTION_TYPE = MethodType.methodType(ScriptFunction.class, ScriptObject.class);

  // Keeps track of which builtin prototypes and properties have been relinked. Currently we are conservative and associate the name of a builtin class with all its properties, so it's enough to invalidate a property to break all assumptions about a prototype.
  // This can be changed to a more fine grained approach, but no one ever needs this, given the very rare occurrence of swapping out only parts of a builtin v.s. the entire builtin object
  private final Map<String, SwitchPoint> builtinSwitchPoints = new HashMap<>();

  /**
   * ContextCodeInstaller that has the privilege of installing classes in the Context.
   * Can only be instantiated from inside the context and is opaque to other classes
   */
  private abstract static class ContextCodeInstaller implements CodeInstaller {

    final Context context;
    final CodeSource codeSource;

    ContextCodeInstaller(Context context, CodeSource codeSource) {
      this.context = context;
      this.codeSource = codeSource;
    }

    @Override
    public Context getContext() {
      return context;
    }

    @Override
    public void initialize(Collection<Class<?>> classes, Source source, Object[] constants) {
      try {
        for (var type : classes) {
          // use reflection to write source and constants table to installed classes
          var sourceField = type.getDeclaredField(SOURCE.symbolName());
          sourceField.setAccessible(true);
          sourceField.set(null, source);
          var constantsField = type.getDeclaredField(CONSTANTS.symbolName());
          constantsField.setAccessible(true);
          constantsField.set(null, constants);
        }
      } catch (Exception e) {
        throw new RuntimeException(e);
      }
    }

    @Override
    public long getUniqueScriptId() {
      return context.getUniqueScriptId();
    }

    @Override
    public boolean isCompatibleWith(CodeInstaller other) {
      return (other instanceof ContextCodeInstaller cci) ? cci.context == context && cci.codeSource == codeSource : false;
    }
  }

  static class NamedContextCodeInstaller extends ContextCodeInstaller {

    private final ScriptLoader loader;
    private int usageCount = 0;
    private int bytesDefined = 0;

    // We reuse this installer for 10 compilations or 200000 defined bytes.
    // Usually the first condition will occur much earlier, the second is a safety measure for very large scripts/functions.
    private final static int MAX_USAGES = 10;
    private final static int MAX_BYTES_DEFINED = 200_000;

    NamedContextCodeInstaller(Context context, CodeSource codeSource, ScriptLoader loader) {
      super(context, codeSource);
      this.loader = loader;
    }

    @Override
    public Class<?> install(String className, byte[] bytecode) {
      usageCount++;
      bytesDefined += bytecode.length;
      return loader.installClass(Compiler.binaryName(className), bytecode, codeSource);
    }

    @Override
    public CodeInstaller getOnDemandCompilationInstaller() {
      // Reuse this installer if we're within our limits.
      return (usageCount < MAX_USAGES && bytesDefined < MAX_BYTES_DEFINED) ? this : new NamedContextCodeInstaller(context, codeSource, context.createNewLoader());
    }

    @Override
    public CodeInstaller getMultiClassCodeInstaller() {
      // This installer is perfectly suitable for installing multiple classes that reference each other as it produces classes with resolvable names, all defined in a single class loader.
      return this;
    }
  }

  private static final ThreadLocal<Global> currentGlobal = new ThreadLocal<>();

  // in-memory cache for loaded classes
  private ClassCache classCache;

  // A factory for linking global properties as constant method handles.
  // It is created when the first Global is created, and invalidated forever once the second global is created.
  private final AtomicReference<GlobalConstants> globalConstantsRef = new AtomicReference<>();

  /**
   * Get the current global scope
   * @return the current global scope
   */
  public static Global getGlobal() {
    // This class in a package.access protected package.
    // Trusted code only can call this method.
    return currentGlobal.get();
  }

  /**
   * Set the current global scope
   * @param global the global scope
   */
  public static void setGlobal(ScriptObject global) {
    if (global != null && !(global instanceof Global)) {
      throw new IllegalArgumentException("not a global!");
    }
    setGlobal((Global) global);
  }

  /**
   * Set the current global scope
   * @param global the global scope
   */
  public static void setGlobal(Global global) {
    // This class in a package.access protected package.
    // Trusted code only can call this method.
    assert getGlobal() != global;
    //same code can be cached between globals, then we need to invalidate method handle constants
    if (global != null) {
      var globalConstants = getContext(global).getGlobalConstants();
      if (globalConstants != null) {
        globalConstants.invalidateAll();
      }
    }
    currentGlobal.set(global);
  }

  /**
   * Get context of the current global
   * @return current global scope's context.
   */
  public static Context getContext() {
    return getContextTrusted();
  }

  /**
   * Get current context's error writer
   * @return error writer of the current context
   */
  public static PrintWriter getCurrentErr() {
    ScriptObject global = getGlobal();
    return (global != null) ? global.getContext().getErr() : new PrintWriter(System.err);
  }

  /**
   * Output text to this Context's error stream
   * @param str text to write
   */
  public static void err(String str) {
    err(str, true);
  }

  /**
   * Output text to this Context's error stream, optionally with a newline afterwards
   * @param str  text to write
   * @param crlf write a carriage return/new line after text
   */
  public static void err(String str, boolean crlf) {
    var err = Context.getCurrentErr();
    if (err != null) {
      if (crlf) {
        err.println(str);
      } else {
        err.print(str);
      }
    }
  }

  // Current environment.
  private final ScriptEnvironment env;

  // class loader to resolve classes from script.
  private final ClassLoader appLoader;

  ClassLoader getAppLoader() {
    return appLoader;
  }

  // Class loader to load classes compiled from scripts.
  private final ScriptLoader scriptLoader;

  // Dynamic linker for linking call sites in script code loaded by this context
  private final DynamicLinker dynamicLinker;

  // Current error manager.
  private final ErrorManager errors;

  // Unique id for script. Used only when --loader-per-compile=false
  private final AtomicLong uniqueScriptId;

  // Optional class filter to use for Java classes. Can be null.
  private final ClassFilter classFilter;

  // Process-wide singleton structure loader
  private static final StructureLoader theStructLoader;
  private static final ConcurrentMap<String, Class<?>> structureClasses = new ConcurrentHashMap<>();

  @SuppressWarnings("static-method")
  StructureLoader getStructLoader() {
    return theStructLoader;
  }

  static /*<init>*/ {
    var myLoader = Context.class.getClassLoader();
    theStructLoader = new StructureLoader(myLoader);
  }

  /**
   * ThrowErrorManager that throws ParserException upon error conditions.
   */
  public static class ThrowErrorManager extends ErrorManager {

    @Override
    public void error(String message) {
      throw new ParserException(message);
    }

    @Override
    public void error(ParserException e) {
      throw e;
    }
  }

  /**
   * Constructor
   *
   * @param options options from command line or Context creator
   * @param errors  error manger
   * @param appLoader application class loader
   */
  public Context(Options options, ErrorManager errors, ClassLoader appLoader) {
    this(options, errors, appLoader, null);
  }

  /**
   * Constructor
   *
   * @param options options from command line or Context creator
   * @param errors  error manger
   * @param appLoader application class loader
   * @param classFilter class filter to use
   */
  public Context(Options options, ErrorManager errors, ClassLoader appLoader, ClassFilter classFilter) {
    this(options, errors, new PrintWriter(System.out, true), new PrintWriter(System.err, true), appLoader, classFilter);
  }

  /**
   * Constructor
   *
   * @param options options from command line or Context creator
   * @param errors  error manger
   * @param out     output writer for this Context
   * @param err     error writer for this Context
   * @param appLoader application class loader
   */
  public Context(Options options, ErrorManager errors, PrintWriter out, PrintWriter err, ClassLoader appLoader) {
    this(options, errors, out, err, appLoader, (ClassFilter) null);
  }

  /**
   * Constructor
   *
   * @param options options from command line or Context creator
   * @param errors  error manger
   * @param out     output writer for this Context
   * @param err     error writer for this Context
   * @param appLoader application class loader
   * @param classFilter class filter to use
   */
  public Context(Options options, ErrorManager errors, PrintWriter out, PrintWriter err, ClassLoader appLoader, ClassFilter classFilter) {
    this.classFilter = classFilter;
    this.env = new ScriptEnvironment(options, out, err);
    if (env._loader_per_compile) {
      this.scriptLoader = null;
      this.uniqueScriptId = null;
    } else {
      this.scriptLoader = createNewLoader();
      this.uniqueScriptId = new AtomicLong();
    }
    this.errors = errors;
    // if user passed --module-path, we create a module class loader with passed appLoader as the parent.
    var modulePath = env._module_path;
    var appCl = (!env._compile_only && modulePath != null && !modulePath.isEmpty()) ? createModuleLoader(appLoader, modulePath, env._add_modules) : appLoader;
    // if user passed -classpath option, make a URLClassLoader with that and the app loader or module app loader as the parent.
    var classPath = env._classpath;
    if (!env._compile_only && classPath != null && !classPath.isEmpty()) {
      appCl = NashornLoader.createClassLoader(classPath, appCl);
    }
    this.appLoader = appCl;
    this.dynamicLinker = Bootstrap.createDynamicLinker(this.appLoader, env._unstable_relink_threshold);
    var cacheSize = env._class_cache_size;
    if (cacheSize > 0) {
      classCache = new ClassCache(this, cacheSize);
    }
  }

  /**
   * Get the class filter for this context
   * @return class filter
   */
  public ClassFilter getClassFilter() {
    return classFilter;
  }

  /**
   * Returns the factory for constant method handles for global properties.
   * The returned factory can be invalidated if this Context has more than one Global.
   * @return the factory for constant method handles for global properties.
   */
  GlobalConstants getGlobalConstants() {
    return globalConstantsRef.get();
  }

  /**
   * Get the error manager for this context
   * @return error manger
   */
  public ErrorManager getErrorManager() {
    return errors;
  }

  /**
   * Get the script environment for this context
   * @return script environment
   */
  public ScriptEnvironment getEnv() {
    return env;
  }

  /**
   * Get the output stream for this context
   * @return output print writer
   */
  public PrintWriter getOut() {
    return env.getOut();
  }

  /**
   * Get the error stream for this context
   * @return error print writer
   */
  public PrintWriter getErr() {
    return env.getErr();
  }

  /**
   * Should scripts use only object slots for fields, or dual long/object slots?
   * The default behaviour is to couple this to optimistic types, using dual representation if optimistic types are enabled and single field representation otherwise.
   * @return true if using dual fields, false for object-only fields
   */
  public boolean useDualFields() {
    return env._optimistic_types;
  }

  /**
   * Get the PropertyMap of the current global scope
   * @return the property map of the current global scope
   */
  public static PropertyMap getGlobalMap() {
    return Context.getGlobal().getMap();
  }

  /**
   * Compile a top level script.
   * @param source the source
   * @param scope  the scope
   * @return top level function for script
   */
  public ScriptFunction compileScript(Source source, ScriptObject scope) {
    return compileScript(source, scope, this.errors);
  }

  /**
   * Interface to represent compiled code that can be re-used across many global scope instances
   */
  public static interface MultiGlobalCompiledScript {

    /**
     * Obtain script function object for a specific global scope object.
     * @param newGlobal global scope for which function object is obtained
     * @return script function for script level expressions
     */
    public ScriptFunction getFunction(Global newGlobal);
  }

  /**
   * Compile a top level script.
   * @param source the script source
   * @return reusable compiled script across many global scopes.
   */
  public MultiGlobalCompiledScript compileScript(Source source) {
    var type = compile(source, this.errors, false);
    var createProgramFunctionHandle = getCreateProgramFunctionHandle(type);
    return (newGlobal) -> invokeCreateProgramFunctionHandle(createProgramFunctionHandle, newGlobal);
  }

  /**
   * Entry point for {@code eval}
   * @param initialScope The scope of this eval call
   * @param string       Evaluated code as a String
   * @param callThis     "this" to be passed to the evaluated code
   * @param location     location of the eval call
   * @return the return value of the {@code eval}
   */
  public Object eval(ScriptObject initialScope, String string, Object callThis, Object location) {
    return eval(initialScope, string, callThis, location, false);
  }

  /**
   * Entry point for {@code eval}
   * @param initialScope The scope of this eval call
   * @param string       Evaluated code as a String
   * @param callThis     "this" to be passed to the evaluated code
   * @param location     location of the eval call
   * @param evalCall     is this called from "eval" builtin?
   * @return the return value of the {@code eval}
   */
  public Object eval(ScriptObject initialScope, String string, Object callThis, Object location, boolean evalCall) {
    var file = location == UNDEFINED || location == null ? "<eval>" : location.toString();
    var source = sourceFor(file, string, evalCall);
    // is this direct 'eval' builtin call?
    var directEval = evalCall && (location != UNDEFINED);
    var global = Context.getGlobal();
    var scope = initialScope;
    Class<?> type;
    try {
      type = compile(source, new ThrowErrorManager(), true);
    } catch (ParserException e) {
      e.throwAsEcmaException(global);
      return null;
    }
    // Create a new scope object with given scope as its prototype
    scope = newScope(scope);
    var func = getProgramFunction(type, scope);
    return ScriptRuntime.apply(func, callThis);
  }

  static ScriptObject newScope(ScriptObject callerScope) {
    return new Scope(callerScope, PropertyMap.newMap(Scope.class));
  }

  /**
   * Load or get a structure class.
   * Structure class names are based on the number of parameter fields and {@link AccessorProperty} fields in them.
   * Structure classes are used to represent ScriptObjects
   * @see ObjectClassGenerator
   * @see AccessorProperty
   * @see ScriptObject
   * @param fullName  full name of class, e.g. es.objects.JO2P1 contains 2 fields and 1 parameter.
   * @return the {@code Class<?>} for this structure
   * @throws ClassNotFoundException if structure class cannot be resolved
   */
  @SuppressWarnings("unchecked")
  public static Class<? extends ScriptObject> forStructureClass(String fullName) throws ClassNotFoundException {
    if (!StructureLoader.isStructureClass(fullName)) {
      throw new ClassNotFoundException(fullName);
    }
    return (Class<? extends ScriptObject>) structureClasses.computeIfAbsent(fullName, (name) -> {
      try {
        return Class.forName(name, true, theStructLoader);
      } catch (ClassNotFoundException e) {
        throw new AssertionError(e);
      }
    });
  }

  /**
   * Is {@code className} the name of a structure class?
   * @param className a class name
   * @return true if className is a structure class name
   */
  public static boolean isStructureClass(String className) {
    return StructureLoader.isStructureClass(className);
  }

  /**
   * Checks that the given Class is public and it can be accessed from no permissions context.
   * @param clazz Class object to check
   * @return true if Class is accessible, false otherwise
   */
  public static boolean isAccessibleClass(Class<?> clazz) {
    return Modifier.isPublic(clazz.getModifiers());
  }

  /**
   * Lookup a Java class.
   * This is used for JSR-223 stuff linking in from {@code es.objects.NativeJava} and {@code jdk.nashorn.internal.runtime.NativeJavaPackage}
   * @param fullName full name of class to load
   * @return the {@code Class<?>} for the name
   * @throws ClassNotFoundException if class cannot be resolved
   */
  public Class<?> findClass(String fullName) throws ClassNotFoundException {
    if (fullName.indexOf('[') != -1 || fullName.indexOf('/') != -1) {
      // don't allow array class names or internal names.
      throw new ClassNotFoundException(fullName);
    }
    // give chance to ClassFilter to filter out, if present
    if (classFilter != null && !classFilter.exposeToScripts(fullName)) {
      throw new ClassNotFoundException(fullName);
    }
    // Try finding using the "app" loader.
    if (appLoader != null) {
      return Class.forName(fullName, true, appLoader);
    } else {
      var cl = Class.forName(fullName);
      // return the Class only if it was loaded by boot loader
      if (cl.getClassLoader() == null) {
        return cl;
      } else {
        throw new ClassNotFoundException(fullName);
      }
    }
  }

  /**
   * Create and initialize a new global scope object.
   * @return the initialized global scope object.
   */
  public Global createGlobal() {
    return initGlobal(newGlobal());
  }

  /**
   * Create a new uninitialized global scope object
   * @return the global script object
   */
  public Global newGlobal() {
    createOrInvalidateGlobalConstants();
    return new Global(this);
  }

  void createOrInvalidateGlobalConstants() {
    for (;;) {
      var currentGlobalConstants = getGlobalConstants();
      if (currentGlobalConstants != null) {
        // Subsequent invocation; we're creating our second or later Global.
        // GlobalConstants is not safe to use with more than one Global, as the constant method handle linkages it creates create a coupling between the Global and the call sites in the compiled code.
        currentGlobalConstants.invalidateForever();
        return;
      }
      var newGlobalConstants = new GlobalConstants();
      if (globalConstantsRef.compareAndSet(null, newGlobalConstants)) {
        // First invocation; we're creating the first Global in this Context.
        // Create the GlobalConstants object for this Context.
        return;
      }
      // If we reach here, then we started out as the first invocation, but another concurrent invocation won the CAS race.
      // We'll just let the loop repeat and invalidate the CAS race winner.
    }
  }

  /**
   * Initialize given global scope object.
   * @param global the global
   * @param engine the associated ScriptEngine instance, can be null
   * @return the initialized global scope object.
   */
  public Global initGlobal(Global global, ScriptEngine engine) {
    // Need only minimal global object, if we are just compiling.
    if (!env._compile_only) {
      var oldGlobal = Context.getGlobal();
      try {
        Context.setGlobal(global);
        // initialize global scope with builtin global objects
        global.initBuiltinObjects(engine);
      } finally {
        Context.setGlobal(oldGlobal);
      }
    }

    return global;
  }

  /**
   * Initialize given global scope object.
   * @param global the global
   * @return the initialized global scope object.
   */
  public Global initGlobal(Global global) {
    return initGlobal(global, null);
  }

  /**
   * Return the current global's context
   * @return current global's context
   */
  static Context getContextTrusted() {
    return getContext(getGlobal());
  }

  /**
   * Gets the Nashorn dynamic linker for the specified class.
   * If the class is a script class, the dynamic linker associated with its context is returned.
   * Otherwise the dynamic linker associated with the current context is returned.
   * @param clazz the class for which we want to retrieve a dynamic linker.
   * @return the Nashorn dynamic linker for the specified class.
   */
  public static DynamicLinker getDynamicLinker(Class<?> clazz) {
    return fromClass(clazz).dynamicLinker;
  }

  /**
   * Gets the Nashorn dynamic linker associated with the current context.
   * @return the Nashorn dynamic linker for the current context.
   */
  public static DynamicLinker getDynamicLinker() {
    return getContextTrusted().dynamicLinker;
  }

  /**
   * Creates a module layer with one module that is defined to the given class loader.
   * @param descriptor the module descriptor for the newly created module
   * @param loader the class loader of the module
   * @return the new Module
   */
  static Module createModuleTrusted(ModuleDescriptor descriptor, ClassLoader loader) {
    return createModuleTrusted(ModuleLayer.boot(), descriptor, loader);
  }

  /**
   * Creates a module layer with one module that is defined to the given class loader.
   * @param parent the parent layer of the new module
   * @param descriptor the module descriptor for the newly created module
   * @param loader the class loader of the module
   * @return the new Module
   */
  static Module createModuleTrusted(ModuleLayer parent, ModuleDescriptor descriptor, ClassLoader loader) {
    var mn = descriptor.name();
    var mref = new ModuleReference(descriptor, null) {
      @Override
      public ModuleReader open() {
        throw new UnsupportedOperationException();
      }
    };
    var finder = new ModuleFinder() {
      @Override
      public Optional<ModuleReference> find(String name) {
        return (name.equals(mn)) ? Optional.of(mref) : Optional.empty();
      }
      @Override
      public Set<ModuleReference> findAll() {
        return Set.of(mref);
      }
    };
    var cf = parent.configuration().resolve(finder, ModuleFinder.of(), Set.of(mn));
    var layer = parent.defineModules(cf, name -> loader);
    var m = layer.findModule(mn).get();
    assert m.getLayer() == layer;
    return m;
  }

  static Context getContextTrustedOrNull() {
    var global = Context.getGlobal();
    return global == null ? null : getContext(global);
  }

  private static Context getContext(Global global) {
    // We can't invoke Global.getContext() directly, as it's a protected override, and Global isn't in our package.
    // In order to access the method, we must cast it to ScriptObject first (which is in our package) and then let virtual invocation do its thing.
    return ((ScriptObject) global).getContext();
  }

  /**
   * Try to infer Context instance from the Class.
   * If we cannot, then get it from the thread local variable.
   * @param clazz the class
   * @return context
   */
  static Context fromClass(Class<?> clazz) {
    ClassLoader loader = null;
    try {
      loader = clazz.getClassLoader();
    } catch (SecurityException ignored) {
      // This could fail because of anonymous classes being used.
      // Accessing loader of anonymous class fails (for extension loader class too?).
      // In any case, for us fetching Context from class loader is just an optimization.
      // We can always get Context from thread local storage (below).
    }
    if (loader instanceof ScriptLoader sl) {
      return sl.getContext();
    }
    return Context.getContextTrusted();
  }

  static ScriptFunction getProgramFunction(Class<?> script, ScriptObject scope) {
    return (script == null) ? null : invokeCreateProgramFunctionHandle(getCreateProgramFunctionHandle(script), scope);
  }

  static MethodHandle getCreateProgramFunctionHandle(Class<?> script) {
    try {
      return LOOKUP.findStatic(script, CREATE_PROGRAM_FUNCTION.symbolName(), CREATE_PROGRAM_FUNCTION_TYPE);
    } catch (NoSuchMethodException | IllegalAccessException e) {
      throw new AssertionError("Failed to retrieve a handle for the program function for " + script.getName(), e);
    }
  }

  static ScriptFunction invokeCreateProgramFunctionHandle(MethodHandle createProgramFunctionHandle, ScriptObject scope) {
    try {
      return (ScriptFunction) createProgramFunctionHandle.invokeExact(scope);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new AssertionError("Failed to create a program function", t);
    }
  }

  ScriptFunction compileScript(Source source, ScriptObject scope, ErrorManager errMan) {
    return getProgramFunction(compile(source, errMan, false), scope);
  }

  synchronized Class<?> compile(Source source, ErrorManager errMan, boolean isEval) {
    // start with no errors, no warnings.
    errMan.reset();
    var script = findCachedClass(source);
    if (script != null) {
      return script;
    }
    var functionNode = new Parser(env, source, errMan).parse();
    if (errMan.hasErrors() || functionNode == null) {
      return null;
    }
    var url = source.getURL();
    var cs = new CodeSource(url, (CodeSigner[]) null);
    var loader = env._loader_per_compile ? createNewLoader() : scriptLoader;
    var installer = new NamedContextCodeInstaller(this, cs, loader);
    var phases = Compiler.CompilationPhases.COMPILE_ALL;
    var compiler = Compiler.forInitialCompilation(installer, source, errMan);
    var compiledFunction = compiler.compile(functionNode, phases);
    if (errMan.hasErrors()) {
      return null;
    }
    script = compiledFunction.getRootClass();
    cacheClass(source, script);
    return script;
  }

  ScriptLoader createNewLoader() {
    return new ScriptLoader(Context.this);
  }

  long getUniqueScriptId() {
    return uniqueScriptId.getAndIncrement();
  }

  /**
   * Cache for compiled script classes.
   */
  static class ClassCache extends LinkedHashMap<Source, ClassReference> {

    private final int size;
    private final ReferenceQueue<Class<?>> queue;

    ClassCache(Context context, int size) {
      super(size, 0.75f, true);
      this.size = size;
      this.queue = new ReferenceQueue<>();
    }

    void cache(Source source, Class<?> clazz) {
      put(source, new ClassReference(clazz, queue, source));
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<Source, ClassReference> eldest) {
      return size() > size;
    }

    @Override
    public ClassReference get(Object key) {
      for (ClassReference ref; (ref = (ClassReference) queue.poll()) != null;) {
        var source = ref.source;
        remove(source);
      }
      var ref = super.get(key);
      return ref;
    }
  }

  static class ClassReference extends SoftReference<Class<?>> {

    private final Source source;

    ClassReference(Class<?> clazz, ReferenceQueue<Class<?>> queue, Source source) {
      super(clazz, queue);
      this.source = source;
    }
  }

  // Class cache management
  Class<?> findCachedClass(Source source) {
    var ref = classCache == null ? null : classCache.get(source);
    return ref != null ? ref.get() : null;
  }

  void cacheClass(Source source, Class<?> clazz) {
    if (classCache != null) {
      classCache.cache(source, clazz);
    }
  }

  /**
   * This is a special kind of switchpoint used to guard builtin properties and prototypes.
   * In the future it might contain logic to e.g. multiple switchpoint classes.
   */
  public static final class BuiltinSwitchPoint extends SwitchPoint {
    // empty
  }

  /**
   * Create a new builtin switchpoint and return it
   * @param name key name
   * @return new builtin switchpoint
   */
  public SwitchPoint newBuiltinSwitchPoint(String name) {
    assert builtinSwitchPoints.get(name) == null;
    var sp = new BuiltinSwitchPoint();
    builtinSwitchPoints.put(name, sp);
    return sp;
  }

  /**
   * Return the builtin switchpoint for a particular key name
   * @param name key name
   * @return builtin switchpoint or null if none
   */
  public SwitchPoint getBuiltinSwitchPoint(String name) {
    return builtinSwitchPoints.get(name);
  }

  static ClassLoader createModuleLoader(ClassLoader cl, String modulePath, String addModules) {
    if (addModules == null) {
      throw new IllegalArgumentException("--module-path specified with no --add-modules");
    }
    var paths = Stream.of(modulePath.split(File.pathSeparator)).map(s -> Paths.get(s)).toArray(sz -> new Path[sz]);
    var mf = ModuleFinder.of(paths);
    var mrefs = mf.findAll();
    if (mrefs.isEmpty()) {
      throw new RuntimeException("No modules in script --module-path: " + modulePath);
    }
    Set<String> rootMods;
    if (addModules.equals("ALL-MODULE-PATH")) {
      rootMods = mrefs.stream().map(mr -> mr.descriptor().name()).collect(Collectors.toSet());
    } else {
      rootMods = Stream.of(addModules.split(",")).map(String::trim).collect(Collectors.toSet());
    }
    var boot = ModuleLayer.boot();
    var conf = boot.configuration().resolve(mf, ModuleFinder.of(), rootMods);
    var firstMod = rootMods.iterator().next();
    return boot.defineModulesWithOneLoader(conf, cl).findLoader(firstMod);
  }

}
