package es.ir;

import es.codegen.CompileUnit;

/**
 * Marker interface for things in the IR that can hold compile units.
 * {@link CompileUnit}
 */
public interface CompileUnitHolder {

  /**
   * Return the compile unit held by this instance
   * @return compile unit
   */
  CompileUnit getCompileUnit();

}
