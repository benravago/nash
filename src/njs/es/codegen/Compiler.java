package es.codegen;

import java.io.File;
import java.lang.invoke.MethodType;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;

import es.codegen.types.Type;
import es.ir.Expression;
import es.ir.FunctionNode;
import es.ir.Optimistic;
import es.runtime.CodeInstaller;
import es.runtime.Context;
import es.runtime.ErrorManager;
import es.runtime.FunctionInitializer;
import es.runtime.ParserException;
import es.runtime.RecompilableScriptFunctionData;
import es.runtime.ScriptEnvironment;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.Source;
import es.runtime.linker.NameCodec;
import es.runtime.logging.DebugLogger;
import static es.runtime.logging.DebugLogger.quote;
import es.runtime.logging.Loggable;
import es.runtime.logging.Logger;
import static es.codegen.CompilerConstants.*;

/**
 * Responsible for converting JavaScripts to java byte code.
 *
 * Main entry point for code generator.
 * The compiler may also install classes given some predefined Code installation policy, given to it at construction time.
 * @see CodeInstaller
 */
@Logger(name = "compiler")
public final class Compiler implements Loggable {

  /** Name of the scripts package */
  public static final String SCRIPTS_PACKAGE = "es/scripts";

  /** Name of the objects package */
  public static final String OBJECTS_PACKAGE = "es/objects";

  private final ScriptEnvironment env;

  private final Source source;

  private final String sourceName;

  private final ErrorManager errors;

  private final boolean optimistic;

  private final Map<String, byte[]> bytecode;

  private final Set<CompileUnit> compileUnits;

  private final ConstantData constantData;

  private final CodeInstaller installer;

  // logger for compiler, trampolines and related code generation events that affect classes
  private final DebugLogger log;

  private final Context context;

  private final TypeMap types;

  // Runtime scope in effect at the time of the compilation.
  // Used to evaluate types of expressions and prevent overly optimistic assumptions (which will lead to unnecessary deoptimizing recompilations).
  private final TypeEvaluator typeEvaluator;

  private final boolean onDemand;

  // If this is a recompilation, this is how we pass in the invalidations, e.g. programPoint=17, Type == int means that using whatever was at program point 17 as an int failed.
  private final Map<Integer, Type> invalidatedProgramPoints;

  // Descriptor of the location where we write the type information after compilation.
  private final Object typeInformationFile;

  // Compile unit name of first compile unit - this prefix will be used for all classes that a compilation generates.
  private final String firstCompileUnitName;

  // Contains the program point that should be used as the continuation entry point, as well as all previous continuation entry points executed as part of a single logical invocation of the function.
  // In practical terms, if we execute a rest-of method from the program point 17, but then we hit deoptimization again during it at program point 42, and execute a rest-of method from the program point 42, and then we hit deoptimization again at program point 57 and are compiling a rest-of method for it, the values in the array will be [57, 42, 17].
  // This is only set when compiling a rest-of method.
  // If this method is a rest-of for a non-rest-of method, the array will have one element.
  // If it is a rest-of for a rest-of, the array will have two elements, and so on.
  private final int[] continuationEntryPoints;

  // ScriptFunction data for what is being compile, where applicable.
  // TODO: make this immutable, propagate it through the CompilationPhases
  private RecompilableScriptFunctionData compiledFunction;

  // Most compile unit names are longer than the default StringBuilder buffer, worth startup performance when massive class generation is going on to increase this
  private static final int COMPILE_UNIT_NAME_BUFFER_SIZE = 32;

  /**
   * Compilation phases that a compilation goes through
   */
  public static class CompilationPhases implements Iterable<CompilationPhase> {

    // Singleton that describes compilation up to the phase where a function can be cached.
    private final static CompilationPhases COMPILE_UPTO_CACHED = new CompilationPhases(
      "Common initial phases",
      CompilationPhase.CONSTANT_FOLDING_PHASE,
      CompilationPhase.LOWERING_PHASE,
      CompilationPhase.APPLY_SPECIALIZATION_PHASE,
      CompilationPhase.SPLITTING_PHASE,
      CompilationPhase.PROGRAM_POINT_PHASE,
      CompilationPhase.SYMBOL_ASSIGNMENT_PHASE,
      CompilationPhase.SCOPE_DEPTH_COMPUTATION_PHASE,
      CompilationPhase.CACHE_AST_PHASE
    );

    private final static CompilationPhases COMPILE_CACHED_UPTO_BYTECODE = new CompilationPhases(
      "After common phases, before bytecode generator",
      CompilationPhase.DECLARE_LOCAL_SYMBOLS_PHASE,
      CompilationPhase.OPTIMISTIC_TYPE_ASSIGNMENT_PHASE,
      CompilationPhase.LOCAL_VARIABLE_TYPE_CALCULATION_PHASE
    );

    /** Singleton that describes additional steps to be taken after retrieving a cached function, all the way up to (but not including) generating and installing code. */
    public final static CompilationPhases RECOMPILE_CACHED_UPTO_BYTECODE = new CompilationPhases(
      "Recompile cached function up to bytecode",
      CompilationPhase.REINITIALIZE_CACHED,
      COMPILE_CACHED_UPTO_BYTECODE
    );

    /** Singleton that describes back end of method generation, given that we have generated the normal method up to CodeGenerator as in {@link CompilationPhases#COMPILE_UPTO_BYTECODE} */
    public final static CompilationPhases GENERATE_BYTECODE_AND_INSTALL = new CompilationPhases(
      "Generate bytecode and install",
      CompilationPhase.BYTECODE_GENERATION_PHASE,
      CompilationPhase.INSTALL_PHASE
    );

    /** Singleton that describes compilation up to the CodeGenerator, but not actually generating code */
    public final static CompilationPhases COMPILE_UPTO_BYTECODE = new CompilationPhases(
      "Compile upto bytecode",
      COMPILE_UPTO_CACHED,
      COMPILE_CACHED_UPTO_BYTECODE);

    /** Singleton that describes a standard eager compilation, but no installation, for example used by --compile-only */
    public final static CompilationPhases COMPILE_ALL_NO_INSTALL = new CompilationPhases(
      "Compile without install",
      COMPILE_UPTO_BYTECODE,
      CompilationPhase.BYTECODE_GENERATION_PHASE);

    /** Singleton that describes a standard eager compilation - this includes code installation */
    public final static CompilationPhases COMPILE_ALL = new CompilationPhases(
      "Full eager compilation",
      COMPILE_UPTO_BYTECODE,
      GENERATE_BYTECODE_AND_INSTALL);

    /** Singleton that describes a full compilation - this includes code installation - from serialized state*/
    public final static CompilationPhases COMPILE_ALL_CACHED = new CompilationPhases(
      "Eager compilation from serializaed state",
      RECOMPILE_CACHED_UPTO_BYTECODE,
      GENERATE_BYTECODE_AND_INSTALL);

    /** Singleton that describes restOf method generation, given that we have generated the normal method up to CodeGenerator as in {@link CompilationPhases#COMPILE_UPTO_BYTECODE} */
    public final static CompilationPhases GENERATE_BYTECODE_AND_INSTALL_RESTOF = new CompilationPhases(
      "Generate bytecode and install - RestOf method",
      CompilationPhase.REUSE_COMPILE_UNITS_PHASE,
      GENERATE_BYTECODE_AND_INSTALL);

    /** Compile all for a rest of method */
    public final static CompilationPhases COMPILE_ALL_RESTOF = new CompilationPhases(
      "Compile all, rest of",
      COMPILE_UPTO_BYTECODE,
      GENERATE_BYTECODE_AND_INSTALL_RESTOF);

    /** Compile from serialized for a rest of method */
    public final static CompilationPhases COMPILE_CACHED_RESTOF = new CompilationPhases(
      "Compile serialized, rest of",
      RECOMPILE_CACHED_UPTO_BYTECODE,
      GENERATE_BYTECODE_AND_INSTALL_RESTOF);

    private final List<CompilationPhase> phases;

    private final String desc;

    CompilationPhases(String desc, CompilationPhase... phases) {
      this(desc, Arrays.asList(phases));
    }

    CompilationPhases(String desc, CompilationPhases base, CompilationPhase... phases) {
      this(desc, concat(base.phases, Arrays.asList(phases)));
    }

    CompilationPhases(String desc, CompilationPhase first, CompilationPhases rest) {
      this(desc, concat(Collections.singletonList(first), rest.phases));
    }

    CompilationPhases(String desc, CompilationPhases base) {
      this(desc, base.phases);
    }

    CompilationPhases(String desc, CompilationPhases... bases) {
      this(desc, concatPhases(bases));
    }

    CompilationPhases(String desc, List<CompilationPhase> phases) {
      this.desc = desc;
      this.phases = phases;
    }

    static List<CompilationPhase> concatPhases(CompilationPhases[] bases) {
      var l = new ArrayList<CompilationPhase>();
      for (var base : bases) {
        l.addAll(base.phases);
      }
      l.trimToSize();
      return l;
    }

    static <T> List<T> concat(List<T> l1, List<T> l2) {
      var l = new ArrayList<T>(l1);
      l.addAll(l2);
      l.trimToSize();
      return l;
    }

    @Override
    public String toString() {
      return "'" + desc + "' " + phases.toString();
    }

    boolean contains(CompilationPhase phase) {
      return phases.contains(phase);
    }

    @Override
    public Iterator<CompilationPhase> iterator() {
      return phases.iterator();
    }

    boolean isRestOfCompilation() {
      return this == COMPILE_ALL_RESTOF || this == GENERATE_BYTECODE_AND_INSTALL_RESTOF || this == COMPILE_CACHED_RESTOF;
    }

    String getDesc() {
      return desc;
    }

    String toString(String prefix) {
      var sb = new StringBuilder();
      for (var phase : phases) {
        sb.append(prefix).append(phase).append('\n');
      }
      return sb.toString();
    }

  } // CompilationPhases

  /**
   * This array contains names that need to be reserved at the start
   * of a compile, to avoid conflict with variable names later introduced.
   * See {@link CompilerConstants} for special names used for structures
   * during a compile.
   */
  private static String[] RESERVED_NAMES = {
    SCOPE.symbolName(),
    THIS.symbolName(),
    RETURN.symbolName(),
    CALLEE.symbolName(),
    VARARGS.symbolName(),
    ARGUMENTS.symbolName()
  };

  // per instance
  private final int compilationId = COMPILATION_ID.getAndIncrement();

  // per instance
  private final AtomicInteger nextCompileUnitId = new AtomicInteger(0);

  private static final AtomicInteger COMPILATION_ID = new AtomicInteger(0);

  /**
   * Creates a new compiler instance for initial compilation of a script.
   *
   * @param installer code installer
   * @param source    source to compile
   * @param errors    error manager
   * @return a new compiler
   */
  public static Compiler forInitialCompilation(CodeInstaller installer, Source source, ErrorManager errors) {
    return new Compiler(installer.getContext(), installer, source, errors);
  }

  /**
   * Creates a compiler without a code installer. It can only be used to compile code, not install the
   * generated classes and as such it is useful only for implementation of {@code --compile-only} command
   * line option.
   * @param context  the current context
   * @param source   source to compile
   * @return a new compiler
   */
  public static Compiler forNoInstallerCompilation(Context context, Source source) {
    return new Compiler(context, null, source, context.getErrorManager());
  }

  /**
   * Creates a compiler for an on-demand compilation job.
   *
   * @param installer                code installer
   * @param source                   source to compile
   * @param compiledFunction         compiled function, if any
   * @param types                    parameter and return value type information, if any is known
   * @param invalidatedProgramPoints invalidated program points for recompilation
   * @param typeInformationFile      descriptor of the location where type information is persisted
   * @param continuationEntryPoints  continuation entry points for restof method
   * @param runtimeScope             runtime scope for recompilation type lookup in {@code TypeEvaluator}
   * @return a new compiler
   */
  public static Compiler forOnDemandCompilation(CodeInstaller installer, Source source, RecompilableScriptFunctionData compiledFunction, TypeMap types, Map<Integer, Type> invalidatedProgramPoints, Object typeInformationFile, int[] continuationEntryPoints, ScriptObject runtimeScope) {
    var context = installer.getContext();
    return new Compiler(context, installer, source, context.getErrorManager(), true, compiledFunction, types, invalidatedProgramPoints, typeInformationFile, continuationEntryPoints, runtimeScope);
  }

  /**
   * Convenience constructor for non on-demand compiler instances.
   */
  Compiler(Context context, CodeInstaller installer, Source source, ErrorManager errors) {
    this(context, installer, source, errors, false, null, null, null, null, null, null);
  }

  Compiler(Context context, CodeInstaller installer, Source source, ErrorManager errors, boolean isOnDemand, RecompilableScriptFunctionData compiledFunction, TypeMap types, Map<Integer, Type> invalidatedProgramPoints, Object typeInformationFile, int[] continuationEntryPoints, ScriptObject runtimeScope) {
    this.context = context;
    this.env = context.getEnv();
    this.installer = installer;
    this.constantData = new ConstantData();
    this.compileUnits = CompileUnit.createCompileUnitSet();
    this.bytecode = new LinkedHashMap<>();
    this.log = initLogger(context);
    this.source = source;
    this.errors = errors;
    this.sourceName = FunctionNode.getSourceName(source);
    this.onDemand = isOnDemand;
    this.compiledFunction = compiledFunction;
    this.types = types;
    this.invalidatedProgramPoints = invalidatedProgramPoints == null ? new HashMap<>() : invalidatedProgramPoints;
    this.typeInformationFile = typeInformationFile;
    this.continuationEntryPoints = continuationEntryPoints == null ? null : continuationEntryPoints.clone();
    this.typeEvaluator = new TypeEvaluator(this, runtimeScope);
    this.firstCompileUnitName = firstCompileUnitName();
    this.optimistic = env._optimistic_types;
  }

  String safeSourceName() {
    var baseName = new File(source.getName()).getName();
    var index = baseName.lastIndexOf(".js");
    if (index != -1) {
      baseName = baseName.substring(0, index);
    }
    baseName = baseName.replace('.', '_').replace('-', '_');
    if (!env._loader_per_compile) {
      baseName += installer.getUniqueScriptId();
    }
    // ASM's bytecode verifier does not allow JVM allowed safe escapes using '\' as escape char.
    // While ASM accepts such escapes for method names, field names, it enforces Java identifier for class names.
    // Workaround that ASM bug here by replacing JVM 'dangerous' chars with '_' rather than safe encoding using '\'.
    var mangled = NameCodec.encode(baseName);
    return mangled != null ? mangled : baseName;
  }

  String firstCompileUnitName() {
    var sb = new StringBuilder(SCRIPTS_PACKAGE)
      .append('/')
      .append(CompilerConstants.DEFAULT_SCRIPT_NAME.symbolName())
      .append('$');
    if (isOnDemandCompilation()) {
      sb.append(RecompilableScriptFunctionData.RECOMPILATION_PREFIX);
    }
    if (compilationId > 0) {
      sb.append(compilationId).append('$');
    }
    if (types != null && compiledFunction.getFunctionNodeId() > 0) {
      sb.append(compiledFunction.getFunctionNodeId());
      var paramTypes = types.getParameterTypes(compiledFunction.getFunctionNodeId());
      for (var t : paramTypes) {
        sb.append(Type.getShortSignatureDescriptor(t));
      }
      sb.append('$');
    }
    sb.append(safeSourceName());
    return sb.toString();
  }

  void declareLocalSymbol(String symbolName) {
    typeEvaluator.declareLocalSymbol(symbolName);
  }

  void setData(RecompilableScriptFunctionData data) {
    assert this.compiledFunction == null : data;
    this.compiledFunction = data;
  }

  @Override
  public DebugLogger getLogger() {
    return log;
  }

  @Override
  public DebugLogger initLogger(Context ctxt) {
    var optimisticTypes = env._optimistic_types;
    var lazyCompilation = env._lazy_compilation;
    return ctxt.getLogger(this.getClass(), (DebugLogger newLogger) -> {
      if (!lazyCompilation) {
        newLogger.warning("WARNING: Running with lazy compilation switched off. This is not a default setting.");
      }
      newLogger.warning("Optimistic types are ", optimisticTypes ? "ENABLED." : "DISABLED.");
    });
  }

  ScriptEnvironment getScriptEnvironment() {
    return env;
  }

  boolean isOnDemandCompilation() {
    return onDemand;
  }

  boolean useOptimisticTypes() {
    return optimistic;
  }

  Context getContext() {
    return context;
  }

  Type getOptimisticType(Optimistic node) {
    return typeEvaluator.getOptimisticType(node);
  }

  /**
   * Returns true if the expression can be safely evaluated, and its value is an object known to always use String as the type of its property names retrieved through {@link ScriptRuntime#toPropertyIterator(Object)}.
   * It is used to avoid optimistic assumptions about its property name types.
   * @param expr the expression to test
   * @return true if the expression can be safely evaluated, and its value is an object known to always use String as the type of its property iterators.
   */
  boolean hasStringPropertyIterator(Expression expr) {
    return typeEvaluator.hasStringPropertyIterator(expr);
  }

  void addInvalidatedProgramPoint(int programPoint, Type type) {
    invalidatedProgramPoints.put(programPoint, type);
  }

  /**
   * Returns a copy of this compiler's current mapping of invalidated optimistic program points to their types.
   * The copy is not live with regard to changes in state in this compiler instance, and is mutable.
   * @return a copy of this compiler's current mapping of invalidated optimistic program points to their types.
   */
  public Map<Integer, Type> getInvalidatedProgramPoints() {
    return invalidatedProgramPoints.isEmpty() ? null : new TreeMap<>(invalidatedProgramPoints);
  }

  TypeMap getTypeMap() {
    return types;
  }

  MethodType getCallSiteType(FunctionNode fn) {
    return (types == null || !isOnDemandCompilation()) ? null : types.getCallSiteType(fn);
  }

  Type getParamType(FunctionNode fn, int pos) {
    return types == null ? null : types.get(fn, pos);
  }

  Type getReturnType() {
    return types == null || !isOnDemandCompilation() ? Type.UNKNOWN : types.getReturnType();
  }

  /**
   * Do a compilation job
   * @param functionNode function node to compile
   * @param phases phases of compilation transforms to apply to function
   * @return transformed function
   * @throws CompilationException if error occurs during compilation
   */
  public FunctionNode compile(FunctionNode functionNode, CompilationPhases phases) throws CompilationException {
    if (log.isEnabled()) {
      log.info(">> Starting compile job for ", DebugLogger.quote(functionNode.getName()), " phases=", quote(phases.getDesc()));
      log.indent();
    }
    var name = DebugLogger.quote(functionNode.getName());
    var newFunctionNode = functionNode;
    for (var reservedName : RESERVED_NAMES) {
      newFunctionNode.uniqueName(reservedName);
    }
    var info = log.isLoggable(Level.INFO);
    var timeLogger = env.isTimingEnabled() ? env._timing.getLogger() : null;
    var time = 0L;
    for (var phase : phases) {
      log.fine(phase, " starting for ", name);
      try {
        newFunctionNode = phase.apply(this, phases, newFunctionNode);
      } catch (ParserException error) {
        errors.error(error);
        if (env._dump_on_error) {
          error.printStackTrace(env.getErr());
        }
        return null;
      }
      log.fine(phase, " done for function ", quote(name));
      time += (env.isTimingEnabled() ? phase.getEndTime() - phase.getStartTime() : 0L);
    }
    if (typeInformationFile != null && !phases.isRestOfCompilation()) {
      OptimisticTypesPersistence.store(typeInformationFile, invalidatedProgramPoints);
    }
    log.unindent();
    if (info) {
      var sb = new StringBuilder("<< Finished compile job for ");
      sb.append(newFunctionNode.getSource()).append(':').append(quote(newFunctionNode.getName()));
      if (time > 0L && timeLogger != null) {
        assert env.isTimingEnabled();
        sb.append(" in ").append(TimeUnit.NANOSECONDS.toMillis(time)).append(" ms");
      }
      log.info(sb);
    }
    return newFunctionNode;
  }

  Source getSource() {
    return source;
  }

  Map<String, byte[]> getBytecode() {
    return Collections.unmodifiableMap(bytecode);
  }

  // Reset bytecode cache for compiler reuse.
  void clearBytecode() {
    bytecode.clear();
  }

  CompileUnit getFirstCompileUnit() {
    assert !compileUnits.isEmpty();
    return compileUnits.iterator().next();
  }

  Set<CompileUnit> getCompileUnits() {
    return compileUnits;
  }

  ConstantData getConstantData() {
    return constantData;
  }

  CodeInstaller getCodeInstaller() {
    return installer;
  }

  void addClass(String name, byte[] code) {
    bytecode.put(name, code);
  }

  String nextCompileUnitName() {
    var sb = new StringBuilder(COMPILE_UNIT_NAME_BUFFER_SIZE);
    sb.append(firstCompileUnitName);
    var cuid = nextCompileUnitId.getAndIncrement();
    if (cuid > 0) {
      sb.append("$cu").append(cuid);
    }
    return sb.toString();
  }

  /**
   * Persist current compilation with the given {@code cacheKey}.
   * @param cacheKey cache key
   * @param functionNode function node
   */
  public void persistClassInfo(String cacheKey, FunctionNode functionNode) {
    if (cacheKey != null && env._persistent_cache) {
      // If this is an on-demand compilation create a function initializer for the function being compiled.
      // Otherwise use function initializer map generated by codegen.
      var initializers = new HashMap<Integer, FunctionInitializer>();
      if (isOnDemandCompilation()) {
        initializers.put(functionNode.getId(), new FunctionInitializer(functionNode, getInvalidatedProgramPoints()));
      } else {
        for (var compileUnit : getCompileUnits()) {
          for (var fn : compileUnit.getFunctionNodes()) {
            initializers.put(fn.getId(), new FunctionInitializer(fn));
          }
        }
      }
      var mainClassName = getFirstCompileUnit().getUnitClassName();
      installer.storeScript(cacheKey, source, mainClassName, bytecode, initializers, constantData.toArray(), compilationId);
    }
  }

  /**
   * Make sure the next compilation id is greater than {@code value}.
   * @param value compilation id value
   */
  public static void updateCompilationId(int value) {
    if (value >= COMPILATION_ID.get()) {
      COMPILATION_ID.set(value + 1);
    }
  }

  CompileUnit addCompileUnit(long initialWeight) {
    var compileUnit = createCompileUnit(initialWeight);
    compileUnits.add(compileUnit);
    log.fine("Added compile unit ", compileUnit);
    return compileUnit;
  }

  CompileUnit createCompileUnit(String unitClassName, long initialWeight) {
    var classEmitter = new ClassEmitter(sourceName, unitClassName, context);
    var compileUnit = new CompileUnit(unitClassName, classEmitter, initialWeight);
    classEmitter.begin();
    return compileUnit;
  }

  CompileUnit createCompileUnit(long initialWeight) {
    return createCompileUnit(nextCompileUnitName(), initialWeight);
  }

  void replaceCompileUnits(Set<CompileUnit> newUnits) {
    compileUnits.clear();
    compileUnits.addAll(newUnits);
  }

  CompileUnit findUnit(long weight) {
    for (var unit : compileUnits) {
      if (unit.canHold(weight)) {
        unit.addWeight(weight);
        return unit;
      }
    }
    return addCompileUnit(weight);
  }

  /**
   * Convert a package/class name to a binary name.
   * @param name Package/class name.
   * @return Binary name.
   */
  public static String binaryName(String name) {
    return name.replace('/', '.');
  }

  RecompilableScriptFunctionData getScriptFunctionData(int functionId) {
    assert compiledFunction != null;
    var fn = compiledFunction.getScriptFunctionData(functionId);
    assert fn != null : functionId;
    return fn;
  }

  boolean isGlobalSymbol(FunctionNode fn, String name) {
    return getScriptFunctionData(fn.getId()).isGlobalSymbol(fn, name);
  }

  int[] getContinuationEntryPoints() {
    return continuationEntryPoints;
  }

  Type getInvalidatedProgramPointType(int programPoint) {
    return invalidatedProgramPoints.get(programPoint);
  }

}
