package es.runtime;

import java.util.Set;

import java.security.ProtectionDomain;

import java.lang.module.ModuleDescriptor;
import java.lang.module.ModuleDescriptor.Modifier;

import es.codegen.ObjectClassGenerator;
import static es.codegen.Compiler.*;
import static es.codegen.CompilerConstants.*;

/**
 * Responsible for on the fly construction of structure classes.
 */
final class StructureLoader extends NashornLoader {

  private static final String SINGLE_FIELD_PREFIX = binaryName(SCRIPTS_PACKAGE) + '.' + JS_OBJECT_SINGLE_FIELD_PREFIX.symbolName();
  private static final String DUAL_FIELD_PREFIX = binaryName(SCRIPTS_PACKAGE) + '.' + JS_OBJECT_DUAL_FIELD_PREFIX.symbolName();

  private final Module structuresModule;

  /**
   * Constructor.
   */
  StructureLoader(ClassLoader parent) {
    super(parent);
    // new structures module, it's exports, read edges
    structuresModule = createModule("jdk.scripting.nashorn.structures");
    // specific exports from nashorn to the structures module
    NASHORN_MODULE.addExports(SCRIPTS_PKG, structuresModule);
    NASHORN_MODULE.addExports(RUNTIME_PKG, structuresModule);
    // nashorn has to read fields from classes of the new module
    NASHORN_MODULE.addReads(structuresModule);
  }

  Module createModule(String moduleName) {
    var descriptor = ModuleDescriptor.newModule(moduleName, Set.of(Modifier.SYNTHETIC))
      .requires(NASHORN_MODULE.getName())
      .packages(Set.of(SCRIPTS_PKG))
      .build();
    var mod = Context.createModuleTrusted(descriptor, this);
    loadModuleManipulator();
    return mod;
  }

  /**
   * Returns true if the class name represents a structure object with dual primitive/object fields.
   * @param name a class name
   * @return true if a dual field structure class
   */
  static boolean isDualFieldStructure(String name) {
    return name.startsWith(DUAL_FIELD_PREFIX);
  }

  /**
   * Returns true if the class name represents a structure object with single object-only fields.
   * @param name a class name
   * @return true if a single field structure class
   */
  static boolean isSingleFieldStructure(String name) {
    return name.startsWith(SINGLE_FIELD_PREFIX);
  }

  /**
   * Returns true if the class name represents a Nashorn structure object.
   * @param name a class name
   * @return true if a structure class
   */
  static boolean isStructureClass(String name) {
    return isDualFieldStructure(name) || isSingleFieldStructure(name);
  }

  Module getModule() {
    return structuresModule;
  }

  @Override
  protected Class<?> findClass(String name) throws ClassNotFoundException {
    return isDualFieldStructure(name) ? generateClass(name, name.substring(DUAL_FIELD_PREFIX.length()), true)
         : isSingleFieldStructure(name) ? generateClass(name, name.substring(SINGLE_FIELD_PREFIX.length()), false)
         : super.findClass(name);
  }

  /**
   * Generate a layout class.
   * @param name       Name of class.
   * @param descriptor Layout descriptor.
   * @return Generated class.
   */
  Class<?> generateClass(String name, String descriptor, boolean dualFields) {
    var context = Context.getContextTrusted();
    var code = new ObjectClassGenerator(context, dualFields).generate(descriptor);
    return defineClass(name, code, 0, code.length, new ProtectionDomain(null, getPermissions(null)));
  }

}
