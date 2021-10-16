package es.parser;

import java.util.ArrayList;
import java.util.List;

import es.ir.IdentNode;
import es.ir.Module;
import es.ir.Module.ExportEntry;
import es.ir.Module.ImportEntry;

/**
 * ParserContextNode that represents a module.
 */
class ParserContextModuleNode extends ParserContextBaseNode {

  // Module name.
  private final String name;

  private final List<String> requestedModules = new ArrayList<>();
  private final List<ImportEntry> importEntries = new ArrayList<>();
  private final List<ExportEntry> localExportEntries = new ArrayList<>();
  private final List<ExportEntry> indirectExportEntries = new ArrayList<>();
  private final List<ExportEntry> starExportEntries = new ArrayList<>();

  /**
   * Constructor.
   * @param name name of the module
   */
  ParserContextModuleNode(String name) {
    this.name = name;
  }

  /**
   * Returns the name of the module.
   * @return name of the module
   */
  public String getModuleName() {
    return name;
  }

  public void addModuleRequest(IdentNode moduleRequest) {
    requestedModules.add(moduleRequest.getName());
  }

  public void addImportEntry(ImportEntry importEntry) {
    importEntries.add(importEntry);
  }

  public void addLocalExportEntry(ExportEntry exportEntry) {
    localExportEntries.add(exportEntry);
  }

  public void addIndirectExportEntry(ExportEntry exportEntry) {
    indirectExportEntries.add(exportEntry);
  }

  public void addStarExportEntry(ExportEntry exportEntry) {
    starExportEntries.add(exportEntry);
  }

  public Module createModule() {
    return new Module(requestedModules, importEntries, localExportEntries, indirectExportEntries, starExportEntries);
  }

}
