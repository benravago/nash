package nash.linker;

import java.util.List;

import jdk.dynalink.linker.GuardingDynamicLinker;
import jdk.dynalink.linker.GuardingDynamicLinkerExporter;

import es.runtime.linker.Bootstrap;

/**
 * This linker exporter is a service provider that exports Nashorn Dynalink linkers to external users.
 *
 * Other language runtimes that use Dynalink can use the linkers exported by this provider to support tight integration of Nashorn objects.
 */
public final class NashornLinkerExporter extends GuardingDynamicLinkerExporter {

  /**
   * Returns a list of exported nashorn specific linkers.
   *
   * @return list of exported nashorn specific linkers
   */
  @Override
  public List<GuardingDynamicLinker> get() {
    return Bootstrap.getExposedLinkers();
  }

}
