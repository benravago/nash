package nash.tools;

public class ScriptingGlobal {
  
}
/*
from es.runtime.Global

  // Nashorn extension: arguments array 
  @Property(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_CONFIGURABLE)
  public Object arguments;

  // Nashorn extension: global.print 
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object print;

  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object warn;

  // Nashorn extension: global.exit 
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object exit;

  // Nashorn extension: global.quit 
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object quit;

  void init(ScriptEngine eng) {
    ...
    if (env._scripting) {
      initScripting(env);
    }
    // expose script (command line) arguments as "arguments" property of global
    arguments = wrapAsObject(env.getArguments().toArray());
    if (env._scripting) {
      // synonym for "arguments" in scripting mode
      addOwnProperty("$ARG", Attribute.NOT_ENUMERABLE, arguments);
    }
    ...
  }    

  void initScripting(ScriptEnvironment scriptEnv) {
    ScriptObject value;
    value = ScriptFunction.createBuiltin("readLine", ScriptingFunctions.READLINE);
    addOwnProperty("readLine", Attribute.NOT_ENUMERABLE, value);
    value = ScriptFunction.createBuiltin("readFully", ScriptingFunctions.READFULLY);
    addOwnProperty("readFully", Attribute.NOT_ENUMERABLE, value);
    var execName = ScriptingFunctions.EXEC_NAME;
    value = ScriptFunction.createBuiltin(execName, ScriptingFunctions.EXEC);
    addOwnProperty(execName, Attribute.NOT_ENUMERABLE, value);
    // Nashorn extension: global.echo (scripting-mode-only)
    // alias for "print"
    value = (ScriptObject) get("print");
    addOwnProperty("echo", Attribute.NOT_ENUMERABLE, value);
    // Nashorn extension: global.$OPTIONS (scripting-mode-only)
    var options = newObject();
    copyOptions(options, scriptEnv);
    addOwnProperty("$OPTIONS", Attribute.NOT_ENUMERABLE, options);
    // Nashorn extension: global.$ENV (scripting-mode-only)
    var env = newObject();
    // do not fill $ENV if we have a security manager around
    // Retrieve current state of ENV variables.
    env.putAll(System.getenv());
    // Set the PWD variable to a value that is guaranteed to be understood
    // by the underlying platform.
    env.put(ScriptingFunctions.PWD_NAME, System.getProperty("user.dir"));
    addOwnProperty(ScriptingFunctions.ENV_NAME, Attribute.NOT_ENUMERABLE, env);
    // add other special properties for exec support
    addOwnProperty(ScriptingFunctions.OUT_NAME, Attribute.NOT_ENUMERABLE, UNDEFINED);
    addOwnProperty(ScriptingFunctions.ERR_NAME, Attribute.NOT_ENUMERABLE, UNDEFINED);
    addOwnProperty(ScriptingFunctions.EXIT_NAME, Attribute.NOT_ENUMERABLE, UNDEFINED);
  }


*/