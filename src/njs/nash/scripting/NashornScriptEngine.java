package nash.scripting;

import java.io.IOException;
import java.io.Reader;
import java.lang.invoke.MethodHandles;
import java.lang.reflect.Modifier;

import java.text.MessageFormat;
import java.util.Locale;
import java.util.Objects;
import java.util.ResourceBundle;

import javax.script.AbstractScriptEngine;
import javax.script.Bindings;
import javax.script.Compilable;
import javax.script.CompiledScript;
import javax.script.Invocable;
import javax.script.ScriptContext;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineFactory;
import javax.script.ScriptException;
import javax.script.SimpleBindings;

import es.objects.Global;
import es.runtime.Context;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.Source;
import es.runtime.linker.JavaAdapterFactory;
import es.runtime.options.Options;
import static es.runtime.Source.sourceFor;

/**
 * JSR-223 compliant script engine for Nashorn.
 *
 * Instances are not created directly, but rather returned through {@link NashornScriptEngineFactory#getScriptEngine()}.
 * Note that this engine implements the {@link Compilable} and {@link Invocable} interfaces, allowing for efficient pre-compilation and repeated execution of scripts.
 * @see NashornScriptEngineFactory
 */
public final class NashornScriptEngine extends AbstractScriptEngine implements Compilable, Invocable {

  // Key used to associate Nashorn global object mirror with arbitrary Bindings instance.
  public static final String NASHORN_GLOBAL = "nashorn.global";

  // the factory that created this engine
  private final ScriptEngineFactory factory;
  // underlying nashorn Context - 1:1 with engine instance
  private final Context nashornContext;
  // do we want to share single Nashorn global instance across ENGINE_SCOPEs?
  private final boolean _global_per_engine;
  // the initial default Nashorn global object; used as "shared" global if above option is true.
  private final Global global;

  // Nashorn script engine error message management
  private static final String MESSAGES_RESOURCE = "nash.api.scripting.resources.Messages";

  private static final ResourceBundle MESSAGES_BUNDLE;

  static {
    MESSAGES_BUNDLE = ResourceBundle.getBundle(MESSAGES_RESOURCE, Locale.getDefault());
  }

  // helper to get Nashorn script engine error message
  static String getMessage(String msgId, String... args) {
    try {
      return new MessageFormat(MESSAGES_BUNDLE.getString(msgId)).format(args);
    } catch (java.util.MissingResourceException e) {
      throw new RuntimeException("no message resource found for message id: " + msgId);
    }
  }

  NashornScriptEngine(NashornScriptEngineFactory factory, String[] args, ClassLoader appLoader, ClassFilter classFilter) {
    assert args != null : "null argument array";
    this.factory = factory;
    var options = new Options("nashorn");
    options.process(args);

    // throw ParseException on first error from script
    var errMgr = new Context.ThrowErrorManager();
    // create new Nashorn Context
        try {
          this.nashornContext = new Context(options, errMgr, appLoader, classFilter);
        } catch (RuntimeException e) {
          if (Context.DEBUG) {
            e.printStackTrace();
          }
          throw e;
        }

    // cache this option that is used often
    this._global_per_engine = nashornContext.getEnv()._global_per_engine;

    // create new global object
    this.global = createNashornGlobal();
    // set the default ENGINE_SCOPE object for the default context
    context.setBindings(new ScriptObjectMirror(global, global), ScriptContext.ENGINE_SCOPE);
  }

  @Override
  public Object eval(Reader reader, ScriptContext ctxt) throws ScriptException {
    return evalImpl(makeSource(reader, ctxt), ctxt);
  }

  @Override
  public Object eval(String script, ScriptContext ctxt) throws ScriptException {
    return evalImpl(makeSource(script, ctxt), ctxt);
  }

  @Override
  public ScriptEngineFactory getFactory() {
    return factory;
  }

  @Override
  public Bindings createBindings() {
    if (_global_per_engine) {
      // just create normal SimpleBindings.
      // We use same 'global' for all Bindings.
      return new SimpleBindings();
    }
    return createGlobalMirror();
  }

  // Compilable methods
  @Override
  public CompiledScript compile(Reader reader) throws ScriptException {
    return asCompiledScript(makeSource(reader, context));
  }

  @Override
  public CompiledScript compile(String str) throws ScriptException {
    return asCompiledScript(makeSource(str, context));
  }

  // Invocable methods
  @Override
  public Object invokeFunction(String name, Object... args) throws ScriptException, NoSuchMethodException {
    return invokeImpl(null, name, args);
  }

  @Override
  public Object invokeMethod(Object self, String name, Object... args) throws ScriptException, NoSuchMethodException {
    if (self == null) {
      throw new IllegalArgumentException(getMessage("thiz.cannot.be.null"));
    }
    return invokeImpl(self, name, args);
  }

  @Override
  public <T> T getInterface(Class<T> type) {
    return getInterfaceInner(null, type);
  }

  @Override
  public <T> T getInterface(Object self, Class<T> type) {
    if (self == null) {
      throw new IllegalArgumentException(getMessage("thiz.cannot.be.null"));
    }
    return getInterfaceInner(self, type);
  }

  // Implementation only below this point
  static Source makeSource(Reader reader, ScriptContext ctxt) throws ScriptException {
    try {
      return sourceFor(getScriptName(ctxt), reader);
    } catch (IOException e) {
      throw new ScriptException(e);
    }
  }

  static Source makeSource(String src, ScriptContext ctxt) {
    return sourceFor(getScriptName(ctxt), src);
  }

  static String getScriptName(ScriptContext ctxt) {
    var val = ctxt.getAttribute(ScriptEngine.FILENAME);
    return (val != null) ? val.toString() : "<eval>";
  }

  <T> T getInterfaceInner(Object self, Class<T> type) {
    assert !(self instanceof ScriptObject) : "raw ScriptObject not expected here";

    if (type == null || !type.isInterface()) {
      throw new IllegalArgumentException(getMessage("interface.class.expected"));
    }

    ScriptObject realSelf = null;
    Global realGlobal = null;
    if (self == null) {
      // making interface out of global functions
      realSelf = realGlobal = getNashornGlobalFrom(context);
    } else if (self instanceof ScriptObjectMirror mirror) {
      realSelf = mirror.getScriptObject();
      realGlobal = mirror.getHomeGlobal();
      if (!isOfContext(realGlobal, nashornContext)) {
        throw new IllegalArgumentException(getMessage("script.object.from.another.engine"));
      }
    }

    if (realSelf == null) {
      throw new IllegalArgumentException(getMessage("interface.on.non.script.object"));
    }

    try {
      var oldGlobal = Context.getGlobal();
      var globalChanged = (oldGlobal != realGlobal);
      try {
        if (globalChanged) {
          Context.setGlobal(realGlobal);
        }

        if (!isInterfaceImplemented(type, realSelf)) {
          return null;
        }
        return type.cast(
          JavaAdapterFactory.getConstructor(realSelf.getClass(),
          type, MethodHandles.publicLookup()).invoke(realSelf)
        );
      } finally {
        if (globalChanged) {
          Context.setGlobal(oldGlobal);
        }
      }
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  // Retrieve nashorn Global object for a given ScriptContext object
  Global getNashornGlobalFrom(ScriptContext ctxt) {
    if (_global_per_engine) {
      // shared single global object for all ENGINE_SCOPE Bindings
      return global;
    }

    var bindings = ctxt.getBindings(ScriptContext.ENGINE_SCOPE);
    // is this Nashorn's own Bindings implementation?
    if (bindings instanceof ScriptObjectMirror som) {
      var glob = globalFromMirror(som);
      if (glob != null) {
        return glob;
      }
    }

    // Arbitrary user Bindings implementation. Look for NASHORN_GLOBAL in it!
    var scope = bindings.get(NASHORN_GLOBAL);
    if (scope instanceof ScriptObjectMirror som) {
      var glob = globalFromMirror(som);
      if (glob != null) {
        return glob;
      }
    }

    // We didn't find associated nashorn global mirror in the Bindings given!
    // Create new global instance mirror and associate with the Bindings.
    var mirror = createGlobalMirror();
    bindings.put(NASHORN_GLOBAL, mirror);
    // Since we created this global explicitly for the non-default script context we set the
    // current script context in global permanently so that invokes work as expected.
    mirror.getHomeGlobal().setInitScriptContext(ctxt);
    return mirror.getHomeGlobal();
  }

  // Retrieve nashorn Global object from a given ScriptObjectMirror
  Global globalFromMirror(ScriptObjectMirror mirror) {
    var sobj = mirror.getScriptObject();
    if (sobj instanceof Global g && isOfContext(g, nashornContext)) {
      return g;
    }

    return null;
  }

  // Create a new ScriptObjectMirror wrapping a newly created Nashorn Global object
  ScriptObjectMirror createGlobalMirror() {
    var newGlobal = createNashornGlobal();
    return new ScriptObjectMirror(newGlobal, newGlobal);
  }

  // Create a new Nashorn Global object
  Global createNashornGlobal() {
    Global newGlobal = null;
    try {
      newGlobal = nashornContext.newGlobal();
    } catch (RuntimeException e) {
      if (Context.DEBUG) {
        e.printStackTrace();
      }
      throw e;
    }

    nashornContext.initGlobal(newGlobal, this);

    return newGlobal;
  }

  Object invokeImpl(Object selfObject, String name, Object... args) throws ScriptException, NoSuchMethodException {
    Objects.requireNonNull(name);
    assert !(selfObject instanceof ScriptObject) : "raw ScriptObject not expected here";

    Global invokeGlobal = null;
    ScriptObjectMirror selfMirror = null;
    if (selfObject instanceof ScriptObjectMirror som) {
      selfMirror = som;
      if (!isOfContext(selfMirror.getHomeGlobal(), nashornContext)) {
        throw new IllegalArgumentException(getMessage("script.object.from.another.engine"));
      }
      invokeGlobal = selfMirror.getHomeGlobal();
    } else if (selfObject == null) {
      // selfObject is null => global function call
      var ctxtGlobal = getNashornGlobalFrom(context);
      invokeGlobal = ctxtGlobal;
      selfMirror = (ScriptObjectMirror) ScriptObjectMirror.wrap(ctxtGlobal, ctxtGlobal);
    }

    if (selfMirror != null) {
      try {
        return ScriptObjectMirror.translateUndefined(selfMirror.callMember(name, args));
      } catch (Exception e) {
        var cause = e.getCause();
        if (cause instanceof NoSuchMethodException nsme) {
          throw nsme;
        }
        throwAsScriptException(e, invokeGlobal);
        throw new AssertionError("should not reach here");
      }
    }

    // Non-script object passed as selfObject
    throw new IllegalArgumentException(getMessage("interface.on.non.script.object"));
  }

  Object evalImpl(Source src, ScriptContext ctxt) throws ScriptException {
    return evalImpl(compileImpl(src, ctxt), ctxt);
  }

  Object evalImpl(ScriptFunction script, ScriptContext ctxt) throws ScriptException {
    return evalImpl(script, ctxt, getNashornGlobalFrom(ctxt));
  }

  Object evalImpl(Context.MultiGlobalCompiledScript mgcs, ScriptContext ctxt, Global ctxtGlobal) throws ScriptException {
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != ctxtGlobal);
    try {
      if (globalChanged) {
        Context.setGlobal(ctxtGlobal);
      }

      var script = mgcs.getFunction(ctxtGlobal);
      var oldCtxt = ctxtGlobal.getScriptContext();
      ctxtGlobal.setScriptContext(ctxt);
      try {
        return ScriptObjectMirror.translateUndefined(ScriptObjectMirror.wrap(ScriptRuntime.apply(script, ctxtGlobal), ctxtGlobal));
      } finally {
        ctxtGlobal.setScriptContext(oldCtxt);
      }
    } catch (Exception e) {
      throwAsScriptException(e, ctxtGlobal);
      throw new AssertionError("should not reach here");
    } finally {
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }
  }

  Object evalImpl(ScriptFunction script, ScriptContext ctxt, Global ctxtGlobal) throws ScriptException {
    if (script == null) {
      return null;
    }
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != ctxtGlobal);
    try {
      if (globalChanged) {
        Context.setGlobal(ctxtGlobal);
      }

      final ScriptContext oldCtxt = ctxtGlobal.getScriptContext();
      ctxtGlobal.setScriptContext(ctxt);
      try {
        return ScriptObjectMirror.translateUndefined(ScriptObjectMirror.wrap(ScriptRuntime.apply(script, ctxtGlobal), ctxtGlobal));
      } finally {
        ctxtGlobal.setScriptContext(oldCtxt);
      }
    } catch (Exception e) {
      throwAsScriptException(e, ctxtGlobal);
      throw new AssertionError("should not reach here");
    } finally {
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }
  }

  static void throwAsScriptException(Exception e, Global global) throws ScriptException {
    if (e instanceof ScriptException se) {
      throw se;
    } else if (e instanceof NashornException ne) {
      var se = new ScriptException(ne.getMessage(), ne.getFileName(), ne.getLineNumber(), ne.getColumnNumber());
      ne.initEcmaError(global);
      se.initCause(e);
      throw se;
    } else if (e instanceof RuntimeException re) {
      throw re;
    } else {
      // wrap any other exception as ScriptException
      throw new ScriptException(e);
    }
  }

  CompiledScript asCompiledScript(Source source) throws ScriptException {
    final Context.MultiGlobalCompiledScript mgcs;
    final ScriptFunction func;

    var oldGlobal = Context.getGlobal();
    var newGlobal = getNashornGlobalFrom(context);
    var globalChanged = (oldGlobal != newGlobal);
    try {
      if (globalChanged) {
        Context.setGlobal(newGlobal);
      }

      mgcs = nashornContext.compileScript(source);
      func = mgcs.getFunction(newGlobal);
    } catch (Exception e) {
      throwAsScriptException(e, newGlobal);
      throw new AssertionError("should not reach here");
    } finally {
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }

    return new CompiledScript() {
      @Override
      public Object eval(ScriptContext ctxt) throws ScriptException {
        var globalObject = getNashornGlobalFrom(ctxt);
        // Are we running the script in the same global in which it was compiled?
        if (func.getScope() == globalObject) {
          return evalImpl(func, ctxt, globalObject);
        }

        // different global
        return evalImpl(mgcs, ctxt, globalObject);
      }
      @Override
      public ScriptEngine getEngine() {
        return NashornScriptEngine.this;
      }
    };
  }

  ScriptFunction compileImpl(Source source, ScriptContext ctxt) throws ScriptException {
    return compileImpl(source, getNashornGlobalFrom(ctxt));
  }

  ScriptFunction compileImpl(Source source, Global newGlobal) throws ScriptException {
    var oldGlobal = Context.getGlobal();
    var globalChanged = (oldGlobal != newGlobal);
    try {
      if (globalChanged) {
        Context.setGlobal(newGlobal);
      }

      return nashornContext.compileScript(source, newGlobal);
    } catch (Exception e) {
      throwAsScriptException(e, newGlobal);
      throw new AssertionError("should not reach here");
    } finally {
      if (globalChanged) {
        Context.setGlobal(oldGlobal);
      }
    }
  }

  static boolean isInterfaceImplemented(Class<?> iface, ScriptObject sobj) {
    for (var method : iface.getMethods()) {
      // ignore methods of java.lang.Object class
      if (method.getDeclaringClass() == Object.class) {
        continue;
      }

      // skip check for default methods - non-abstract, interface methods
      if (!Modifier.isAbstract(method.getModifiers())) {
        continue;
      }

      var obj = sobj.get(method.getName());
      if (!(obj instanceof ScriptFunction)) {
        return false;
      }
    }
    return true;
  }

  static boolean isOfContext(Global global, Context context) {
    return global.isOfContext(context);
  }

}
