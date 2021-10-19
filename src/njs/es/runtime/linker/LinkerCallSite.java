package es.runtime.linker;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map.Entry;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.LongAdder;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import jdk.dynalink.DynamicLinker;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.support.ChainedCallSite;

import es.util.Hex;
import es.runtime.Context;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.options.Options;
import static es.lookup.Lookup.MH;

/**
 * Relinkable form of call site.
 */
public class LinkerCallSite extends ChainedCallSite {

  /** Maximum number of arguments passed directly. */
  public static final int ARGLIMIT = 125;

  private static final String PROFILEFILE = Options.getStringProperty("nashorn.profilefile", "NashornProfile.txt");

  private static final MethodHandle INCREASE_MISS_COUNTER = MH.findStatic(MethodHandles.lookup(), LinkerCallSite.class, "increaseMissCount", MH.type(Object.class, String.class, Object.class));

  LinkerCallSite(NashornCallSiteDescriptor descriptor) {
    super(descriptor);
    if (Context.DEBUG) {
      LinkerCallSite.count.increment();
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
    if (desc.isProfile()) {
      return ProfilingLinkerCallSite.newProfilingLinkerCallSite(desc);
    }
    if (desc.isTrace()) {
      return new TracingLinkerCallSite(desc);
    }
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
    missCount.increment();
    if (r.nextInt(100) < missSamplingPercentage) {
      var i = missCounts.get(desc);
      if (i == null) {
        missCounts.put(desc, new AtomicInteger(1));
      } else {
        i.incrementAndGet();
      }
    }
    return self;
  }

  /**
   * Debugging call sites.
   */
  static class ProfilingLinkerCallSite extends LinkerCallSite {

    // List of all profiled call sites.
    private static LinkedList<ProfilingLinkerCallSite> profileCallSites = null;

    // Start time when entered at zero depth.
    private long startTime;

    // Depth of nested calls.
    private int depth;

    // Total time spent in this call site.
    private long totalTime;

    // Total number of times call site entered.
    private long hitCount;

    private static final MethodHandles.Lookup LOOKUP = MethodHandles.lookup();

    private static final MethodHandle PROFILEENTRY = MH.findVirtual(LOOKUP, ProfilingLinkerCallSite.class, "profileEntry", MH.type(Object.class, Object.class));
    private static final MethodHandle PROFILEEXIT = MH.findVirtual(LOOKUP, ProfilingLinkerCallSite.class, "profileExit", MH.type(Object.class, Object.class));
    private static final MethodHandle PROFILEVOIDEXIT = MH.findVirtual(LOOKUP, ProfilingLinkerCallSite.class, "profileVoidExit", MH.type(void.class));

    ProfilingLinkerCallSite(NashornCallSiteDescriptor desc) {
      super(desc);
    }

    public static ProfilingLinkerCallSite newProfilingLinkerCallSite(NashornCallSiteDescriptor desc) {
      if (profileCallSites == null) {
        profileCallSites = new LinkedList<>();
        var profileDumperThread = new Thread(new ProfileDumper());
        Runtime.getRuntime().addShutdownHook(profileDumperThread);
      }
      var callSite = new ProfilingLinkerCallSite(desc);
      profileCallSites.add(callSite);
      return callSite;
    }

    @Override
    public void setTarget(MethodHandle newTarget) {
      var type = type();
      var isVoid = type.returnType() == void.class;
      var newSelfType = newTarget.type().parameterType(0);
      var selfFilter = MH.bindTo(PROFILEENTRY, this);
      if (newSelfType != Object.class) {
        // new target uses a more precise 'self' type than Object.class.
        // We need to convert the filter type.
        // Note that the profileEntry method returns "self" argument "as is" and so the cast introduced will succeed for any type.
        var selfFilterType = MethodType.methodType(newSelfType, newSelfType);
        selfFilter = selfFilter.asType(selfFilterType);
      }
      var methodHandle = MH.filterArguments(newTarget, 0, selfFilter);
      if (isVoid) {
        methodHandle = MH.filterReturnValue(methodHandle, MH.bindTo(PROFILEVOIDEXIT, this));
      } else {
        var filter = MH.type(type.returnType(), type.returnType());
        methodHandle = MH.filterReturnValue(methodHandle, MH.asType(MH.bindTo(PROFILEEXIT, this), filter));
      }
      super.setTarget(methodHandle);
    }

    /**
     * Start the clock for a profile entry and increase depth
     * @param self argument to filter
     * @return preserved argument
     */
    @SuppressWarnings("unused")
    public Object profileEntry(Object self) {
      if (depth == 0) {
        startTime = System.nanoTime();
      }
      depth++;
      hitCount++;
      return self;
    }

    /**
     * Decrease depth and stop the clock for a profile entry
     * @param result return value to filter
     * @return preserved argument
     */
    @SuppressWarnings("unused")
    public Object profileExit(Object result) {
      depth--;
      if (depth == 0) {
        totalTime += System.nanoTime() - startTime;
      }
      return result;
    }

    /**
     * Decrease depth without return value filter
     */
    @SuppressWarnings("unused")
    public void profileVoidExit() {
      depth--;
      if (depth == 0) {
        totalTime += System.nanoTime() - startTime;
      }
    }

    static class ProfileDumper implements Runnable {
      @Override
      public void run() {
        PrintWriter out = null;
        var fileOutput = false;
        try {
          try {
            out = new PrintWriter(new FileOutputStream(PROFILEFILE));
            fileOutput = true;
          } catch (FileNotFoundException e) {
            out = Context.getCurrentErr();
          }
          dump(out);
        } finally {
          if (out != null && fileOutput) {
            out.close();
          }
        }
      }

      static void dump(PrintWriter out) {
        var index = 0;
        for (var callSite : profileCallSites) {
          out.println("" + (index++) + '\t'
            + callSite.getDescriptor().getOperation() + '\t'
            + callSite.totalTime + '\t'
            + callSite.hitCount);
        }
      }
    }
  }

  /**
   * Debug subclass for LinkerCallSite that allows tracing
   */
  static class TracingLinkerCallSite extends LinkerCallSite {

    private static final MethodHandles.Lookup LOOKUP = MethodHandles.lookup();

    private static final MethodHandle TRACEOBJECT = MH.findVirtual(LOOKUP, TracingLinkerCallSite.class, "traceObject", MH.type(Object.class, MethodHandle.class, Object[].class));
    private static final MethodHandle TRACEVOID = MH.findVirtual(LOOKUP, TracingLinkerCallSite.class, "traceVoid", MH.type(void.class, MethodHandle.class, Object[].class));
    private static final MethodHandle TRACEMISS = MH.findVirtual(LOOKUP, TracingLinkerCallSite.class, "traceMiss", MH.type(void.class, String.class, Object[].class));

    TracingLinkerCallSite(NashornCallSiteDescriptor desc) {
      super(desc);
    }

    @Override
    public void setTarget(MethodHandle newTarget) {
      if (!getNashornDescriptor().isTraceEnterExit()) {
        super.setTarget(newTarget);
        return;
      }
      var type = type();
      var isVoid = type.returnType() == void.class;
      var traceMethodHandle = isVoid ? TRACEVOID : TRACEOBJECT;
      traceMethodHandle = MH.bindTo(traceMethodHandle, this);
      traceMethodHandle = MH.bindTo(traceMethodHandle, newTarget);
      traceMethodHandle = MH.asCollector(traceMethodHandle, Object[].class, type.parameterCount());
      traceMethodHandle = MH.asType(traceMethodHandle, type);
      super.setTarget(traceMethodHandle);
    }

    @Override
    public void initialize(MethodHandle relinkAndInvoke) {
      super.initialize(getFallbackLoggingRelink(relinkAndInvoke));
    }

    @Override
    public void relink(GuardedInvocation invocation, MethodHandle relink) {
      super.relink(invocation, getFallbackLoggingRelink(relink));
    }

    @Override
    public void resetAndRelink(GuardedInvocation invocation, MethodHandle relink) {
      super.resetAndRelink(invocation, getFallbackLoggingRelink(relink));
    }

    private MethodHandle getFallbackLoggingRelink(MethodHandle relink) {
      if (!getNashornDescriptor().isTraceMisses()) {
        // If we aren't tracing misses, just return relink as-is
        return relink;
      }
      var type = relink.type();
      return MH.foldArguments(relink, MH.asType(MH.asCollector(MH.insertArguments(TRACEMISS, 0, this, "MISS " + getScriptLocation() + " "), Object[].class, type.parameterCount()), type.changeReturnType(void.class)));
    }

    void printObject(PrintWriter out, Object arg) {
      if (!getNashornDescriptor().isTraceObjects()) {
        out.print((arg instanceof ScriptObject) ? "ScriptObject" : arg);
        return;
      }
      if (arg instanceof ScriptObject object) {
        var isFirst = true;
        var keySet = object.keySet();
        if (keySet.isEmpty()) {
          out.print(ScriptRuntime.safeToString(arg));
        } else {
          out.print("{ ");
          for (var key : keySet) {
            if (!isFirst) {
              out.print(", ");
            }
            out.print(key);
            out.print(":");
            var value = object.get(key);
            if (value instanceof ScriptObject) {
              out.print("...");
            } else {
              printObject(out, value);
            }
            isFirst = false;
          }
          out.print(" }");
        }
      } else {
        out.print(ScriptRuntime.safeToString(arg));
      }
    }

    void tracePrint(PrintWriter out, String tag, Object[] args, Object result) {
      //boolean isVoid = type().returnType() == void.class;
      out.print(Hex.id(this) + " TAG " + tag);
      out.print(getDescriptor().getOperation() + "(");
      if (args.length > 0) {
        printObject(out, args[0]);
        for (var i = 1; i < args.length; i++) {
          var arg = args[i];
          out.print(", ");
          if (!(arg instanceof ScriptObject so && so.isScope())) {
            printObject(out, arg);
          } else {
            out.print("SCOPE");
          }
        }
      }
      out.print(")");
      if (tag.equals("EXIT  ")) {
        out.print(" --> ");
        printObject(out, result);
      }
      out.println();
    }

    /**
     * Trace event. Wrap an invocation with a return value
     *
     * @param mh     invocation handle
     * @param args   arguments to call
     *
     * @return return value from invocation
     *
     * @throws Throwable if invocation fails or throws exception/error
     */
    @SuppressWarnings("unused")
    public Object traceObject(MethodHandle mh, Object... args) throws Throwable {
      var out = Context.getCurrentErr();
      tracePrint(out, "ENTER ", args, null);
      var result = mh.invokeWithArguments(args);
      tracePrint(out, "EXIT  ", args, result);
      return result;
    }

    /**
     * Trace event. Wrap an invocation that returns void
     *
     * @param mh     invocation handle
     * @param args   arguments to call
     *
     * @throws Throwable if invocation fails or throws exception/error
     */
    @SuppressWarnings("unused")
    public void traceVoid(MethodHandle mh, Object... args) throws Throwable {
      var out = Context.getCurrentErr();
      tracePrint(out, "ENTER ", args, null);
      mh.invokeWithArguments(args);
      tracePrint(out, "EXIT  ", args, null);
    }

    /**
     * Tracer function that logs a callsite miss
     * @param desc callsite descriptor string
     * @param args arguments to function
     * @throws Throwable if invocation fails or throws exception/error
     */
    @SuppressWarnings("unused")
    public void traceMiss(String desc, Object... args) throws Throwable {
      tracePrint(Context.getCurrentErr(), desc, args, null);
    }
  }

  // counters updated in debug mode
  private static LongAdder count;
  private static final HashMap<String, AtomicInteger> missCounts = new HashMap<>();
  private static LongAdder missCount;
  private static final Random r = new Random();
  private static final int missSamplingPercentage = Options.getIntProperty("nashorn.tcs.miss.samplePercent", 1);

  static {
    if (Context.DEBUG) {
      count = new LongAdder();
      missCount = new LongAdder();
    }
  }

  @Override
  protected int getMaxChainLength() {
    return 8;
  }

  /**
   * Get the callsite count
   * @return the count
   */
  public static long getCount() {
    return count.longValue();
  }

  /**
   * Get the callsite miss count
   * @return the missCount
   */
  public static long getMissCount() {
    return missCount.longValue();
  }

  /**
   * Get given miss sampling percentage for sampler. Default is 1%. Specified with -Dnashorn.tcs.miss.samplePercent=x
   * @return miss sampling percentage
   */
  public static int getMissSamplingPercentage() {
    return missSamplingPercentage;
  }

  /**
   * Dump the miss counts collected so far to a given output stream
   * @param out print stream
   */
  public static void getMissCounts(PrintWriter out) {
    var entries = new ArrayList<Entry<String, AtomicInteger>>(missCounts.entrySet());
    Collections.sort(entries, (o1, o2) -> o2.getValue().get() - o1.getValue().get());
    for (var entry : entries) {
      out.println("  " + entry.getKey() + "\t" + entry.getValue().get());
    }
  }

}
