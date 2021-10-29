package es.runtime.linker;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import jdk.dynalink.DynamicLinker;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.support.ChainedCallSite;

import static es.lookup.Lookup.MH;

/**
 * Relinkable form of call site.
 */
public class LinkerCallSite extends ChainedCallSite {

  /** Maximum number of arguments passed directly. */
  public static final int ARGLIMIT = 125;

  LinkerCallSite(NashornCallSiteDescriptor descriptor) {
    super(descriptor);
  }

  /**
   * Construct a new linker call site.
   * @param name     Name of method.
   * @param type     Method type.
   * @param flags    Call site specific flags.
   * @return New LinkerCallSite.
   */
  static LinkerCallSite newLinkerCallSite(MethodHandles.Lookup lookup, String name, MethodType type, int flags) {
    var desc = NashornCallSiteDescriptor.get(lookup, name, type, flags);
    return new LinkerCallSite(desc);
  }

  @Override
  public String toString() {
    return getDescriptor().toString();
  }

  /**
   * Get the descriptor for this callsite
   * @return a {@link NashornCallSiteDescriptor}
   */
  public NashornCallSiteDescriptor getNashornDescriptor() {
    return (NashornCallSiteDescriptor) getDescriptor();
  }

  @Override
  public void relink(GuardedInvocation invocation, MethodHandle relink) {
    super.relink(invocation, relink);
  }

  @Override
  public void resetAndRelink(GuardedInvocation invocation, MethodHandle relink) {
    super.resetAndRelink(invocation, relink);
  }

  static String getScriptLocation() {
    var caller = DynamicLinker.getLinkedCallSiteLocation();
    return caller == null ? "unknown location" : (caller.getFileName() + ":" + caller.getLineNumber());
  }

}
