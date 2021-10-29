package es.runtime.linker;


import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import jdk.dynalink.DynamicLinker;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.support.ChainedCallSite;

import es.runtime.Context;
import static es.lookup.Lookup.MH;

/**
 * Relinkable form of call site.
 */
public class LinkerCallSite extends ChainedCallSite {

  /** Maximum number of arguments passed directly. */
  public static final int ARGLIMIT = 125;

  private static final MethodHandle INCREASE_MISS_COUNTER = MH.findStatic(MethodHandles.lookup(), LinkerCallSite.class, "increaseMissCount", MH.type(Object.class, String.class, Object.class));

  LinkerCallSite(NashornCallSiteDescriptor descriptor) {
    super(descriptor);
    if (Context.DEBUG) {
    }
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
    super.relink(invocation, getDebuggingRelink(relink));
  }

  @Override
  public void resetAndRelink(GuardedInvocation invocation, MethodHandle relink) {
    super.resetAndRelink(invocation, getDebuggingRelink(relink));
  }

  private MethodHandle getDebuggingRelink(MethodHandle relink) {
    if (Context.DEBUG) {
      return MH.filterArguments(relink, 0, getIncreaseMissCounter(relink.type().parameterType(0)));
    }
    return relink;
  }

  MethodHandle getIncreaseMissCounter(Class<?> type) {
    var missCounterWithDesc = MH.bindTo(INCREASE_MISS_COUNTER, getDescriptor().getOperation() + " @ " + getScriptLocation());
    return (type == Object.class) ? missCounterWithDesc : MH.asType(missCounterWithDesc, missCounterWithDesc.type().changeParameterType(0, type).changeReturnType(type));
  }

  static String getScriptLocation() {
    var caller = DynamicLinker.getLinkedCallSiteLocation();
    return caller == null ? "unknown location" : (caller.getFileName() + ":" + caller.getLineNumber());
  }

  /**
   * Instrumentation - increase the miss count when a callsite misses. Used as filter
   * @param desc descriptor for table entry
   * @param self self reference
   * @return self reference
   */
  public static Object increaseMissCount(String desc, Object self) {
    return self; // TODO: no-op
  }

}
