package es.runtime;

import java.util.Objects;
import java.util.Set;

import java.security.CodeSource;

import java.lang.module.ModuleDescriptor;
import java.lang.module.ModuleDescriptor.Modifier;

/**
 * Responsible for loading script generated classes.
 */
final class ScriptLoader extends NashornLoader {

  private static final String NASHORN_PKG_PREFIX = "es.";

  private volatile boolean structureAccessAdded;
  private final Context context;
  private final Module scriptModule;

  Context getContext() {
    return context;
  }

  /**
   * Constructor.
   */
  ScriptLoader(Context context) {
    super(context.getStructLoader());
    this.context = context;
    // new scripts module, it's specific exports and read-edges
    scriptModule = createModule("jdk.scripting.nashorn.scripts");
    // specific exports from nashorn to new scripts module
    NASHORN_MODULE.addExports(OBJECTS_PKG, scriptModule);
    NASHORN_MODULE.addExports(RUNTIME_PKG, scriptModule);
    NASHORN_MODULE.addExports(RUNTIME_ARRAYS_PKG, scriptModule);
    NASHORN_MODULE.addExports(RUNTIME_LINKER_PKG, scriptModule);
    NASHORN_MODULE.addExports(SCRIPTS_PKG, scriptModule);
    // nashorn needs to read scripts module methods,fields
    NASHORN_MODULE.addReads(scriptModule);
  }

  Module createModule(String moduleName) {
    var structMod = context.getStructLoader().getModule();
    var builder = ModuleDescriptor.newModule(moduleName, Set.of(Modifier.SYNTHETIC))
      .requires("java.logging")
      .requires(NASHORN_MODULE.getName())
      .requires(structMod.getName())
      .packages(Set.of(SCRIPTS_PKG));
    if (Context.javaSqlFound) {
      builder.requires("java.sql");
    }
    if (Context.javaSqlRowsetFound) {
      builder.requires("java.sql.rowset");
    }
    var descriptor = builder.build();
    var mod = Context.createModuleTrusted(structMod.getLayer(), descriptor, this);
    loadModuleManipulator();
    return mod;
  }

  @Override
  protected Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
    var cl = super.loadClass(name, resolve);
    if (!structureAccessAdded) {
      var structLoader = context.getStructLoader();
      if (cl.getClassLoader() == structLoader) {
        structureAccessAdded = true;
        structLoader.addModuleExport(scriptModule);
      }
    }
    return cl;
  }

  @Override
  protected Class<?> findClass(String name) throws ClassNotFoundException {
    var appLoader = context.getAppLoader();
    // If the appLoader is null, don't bother side-delegating to it!
    // Bootloader has been already attempted via parent loader delegation from the "loadClass" method.
    // Also, make sure that we don't delegate to the app loader for nashorn's own classes or nashorn generated classes!
    if (appLoader == null || name.startsWith(NASHORN_PKG_PREFIX)) {
      throw new ClassNotFoundException(name);
    }
    // This split-delegation is used so that caller loader based resolutions of classes would work.
    // For example, java.sql.DriverManager uses caller's class loader to get Driver instances.
    // Without this split-delegation a script class evaluating DriverManager.getDrivers() will not get back any JDBC driver!
    return appLoader.loadClass(name);
  }

  // package-private and private stuff below this point

  /**
   * Install a class for use by the Nashorn runtime
   * @param name Binary name of class.
   * @param data Class data bytes.
   * @param cs CodeSource code source of the class bytes.
   * @return Installed class.
   */
  synchronized Class<?> installClass(String name, byte[] data, CodeSource cs) {
    return defineClass(name, data, 0, data.length, Objects.requireNonNull(cs));
  }

}
