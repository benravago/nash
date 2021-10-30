package es.runtime;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.SwitchPoint;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.DynamicLinker;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;

import es.lookup.Lookup;
import es.runtime.linker.NashornCallSiteDescriptor;
import es.util.Hex;
import static es.codegen.CompilerConstants.*;
import static es.lookup.Lookup.MH;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;
import static es.runtime.linker.NashornCallSiteDescriptor.getProgramPoint;

/**
 * Each context owns one of these.
 *
 * This is basically table of accessors for global properties.
 * A global constant is evaluated to a MethodHandle.constant for faster access and to avoid walking to proto chain looking for it.
 *
 * We put a switchpoint on the global setter, which invalidates the method handle constant getters, and reverts to the standard access strategy
 *
 * However, there is a twist - while certain globals like "undefined" and "Math" are usually never reassigned, a global value can be reset once, and never again.
 * This is a rather common pattern, like:
 *
 * x = function(something) { ...
 *
 * Thus everything registered as a global constant gets an extra chance.
 * Set once, reregister the switchpoint.
 * Set twice or more - don't try again forever, or we'd just end up relinking our way into megamorphism.
 *
 * Also it has to be noted that this kind of linking creates a coupling between a Global and the call sites in compiled code belonging to the Context.
 * For this reason, the linkage becomes incorrect as soon as the Context has more than one Global.
 * The {@link #invalidateForever()} is invoked by the Context to invalidate all linkages and turn off the functionality of this object as soon as the Context's {@link Context#newGlobal()} is invoked for second time.
 *
 * We can extend this to ScriptObjects in general (GLOBAL_ONLY=false), which requires a receiver guard on the constant getter, but it currently leaks memory and its benefits have not yet been investigated property.
 *
 * As long as all Globals in a Context share the same GlobalConstants instance, we need synchronization whenever we access it.
 */
public final class GlobalConstants {

  /**
   * Should we only try to link globals as constants, and not generic script objects.
   * Script objects require a receiver guard, which is memory intensive, so this is currently disabled.
   * We might implement a weak reference based approach to this later.
   */
  public static final boolean GLOBAL_ONLY = true;

  private static final MethodHandles.Lookup LOOKUP = MethodHandles.lookup();

  private static final MethodHandle INVALIDATE_SP = virtualCall(LOOKUP, GlobalConstants.class, "invalidateSwitchPoint", Object.class, Object.class, Access.class).methodHandle();
  private static final MethodHandle RECEIVER_GUARD = staticCall(LOOKUP, GlobalConstants.class, "receiverGuard", boolean.class, Access.class, Object.class, Object.class).methodHandle();

  // Access map for this global - associates a symbol name with an Access object, with getter and invalidation information
  private final Map<Object, Access> map = new HashMap<>();

  private final AtomicBoolean invalidatedForever = new AtomicBoolean(false);

  /**
   * Information about a constant access and its potential invalidations
   */
  static class Access {

    // name of symbol
    private final String name;

    // switchpoint that invalidates the getters and setters for this access
    private SwitchPoint sp;

    // invalidation count for this access, i.e. how many times has this property been reset
    private int invalidations;

    // has a guard guarding this property getter failed?
    private boolean guardFailed;

    private static final int MAX_RETRIES = 2;

    Access(String name, SwitchPoint sp) {
      this.name = name;
      this.sp = sp;
    }

    boolean hasBeenInvalidated() {
      return sp.hasBeenInvalidated();
    }

    boolean guardFailed() {
      return guardFailed;
    }

    void failGuard() {
      invalidateOnce();
      guardFailed = true;
    }

    void newSwitchPoint() {
      assert hasBeenInvalidated();
      sp = new SwitchPoint();
    }

    void invalidate(int count) {
      if (!sp.hasBeenInvalidated()) {
        SwitchPoint.invalidateAll(new SwitchPoint[]{sp});
        invalidations += count;
      }
    }

    /** Invalidate the access, but do not contribute to the invalidation count */
    void invalidateUncounted() {
      invalidate(0);
    }

    /** Invalidate the access, and contribute 1 to the invalidation count */
    void invalidateOnce() {
      invalidate(1);
    }

    /** Invalidate the access and make sure that we never try to turn this into a MethodHandle.constant getter again */
    void invalidateForever() {
      invalidate(MAX_RETRIES);
    }

    /**
     * Are we allowed to relink this as constant getter, even though it it has been reset
     * @return true if we can relink as constant, one retry is allowed
     */
    boolean mayRetry() {
      return invalidations < MAX_RETRIES;
    }

    @Override
    public String toString() {
      return "[" + Hex.quote(name) + " <id=" + Hex.id(this) + "> inv#=" + invalidations + '/' + MAX_RETRIES + " sp_inv=" + sp.hasBeenInvalidated() + ']';
    }

    String getName() {
      return name;
    }

    SwitchPoint getSwitchPoint() {
      return sp;
    }
  }

  /**
   * To avoid an expensive global guard "is this the same global", similar to the receiver guard on the ScriptObject level, we invalidate all getters once when we switch globals.
   * This is used from the class cache. We _can_ reuse the same class for a new global, but the builtins and global scoped variables will have changed.
   */
  public void invalidateAll() {
    if (!invalidatedForever.get()) {
      synchronized (this) {
        for (var acc : map.values()) {
          acc.invalidateUncounted();
        }
      }
    }
  }

  /**
   * To avoid an expensive global guard "is this the same global", similar to the receiver guard on the ScriptObject level, we invalidate all getters when the second Global is created by the Context owning this instance.
   * After this method is invoked, this GlobalConstants instance will both invalidate all the switch points it produced, and it will stop handing out new method handles altogether.
   */
  public void invalidateForever() {
    if (invalidatedForever.compareAndSet(false, true)) {
      synchronized (this) {
        for (var acc : map.values()) {
          acc.invalidateForever();
        }
        map.clear();
      }
    }
  }

  /**
   * Invalidate the switchpoint of an access - we have written to the property
   * @param obj receiver
   * @param acc access
   * @return receiver, so this can be used as param filter
   */
  @SuppressWarnings("unused")
  synchronized Object invalidateSwitchPoint(Object obj, Access acc) {
    acc.invalidateOnce();
    if (acc.mayRetry()) {
      acc.newSwitchPoint();
    }
    return obj;
  }

  Access getOrCreateSwitchPoint(String name) {
    var acc = map.get(name);
    if (acc != null) {
      return acc;
    }
    var sp = new SwitchPoint();
    map.put(name, acc = new Access(name, sp));
    return acc;
  }

  /**
   * Called from script object on property deletion to erase a property that might be linked as MethodHandle.constant and force relink
   * @param name name of property
   */
  void delete(Object name) {
    if (!invalidatedForever.get()) {
      synchronized (this) {
        var acc = map.get(name);
        if (acc != null) {
          acc.invalidateForever();
        }
      }
    }
  }

  /**
   * Receiver guard is used if we extend the global constants to script objects in general.
   * As the property can have different values in different script objects, while Global is by definition a singleton, we need this for ScriptObject constants (currently disabled)
   * TODO: Note - this seems to cause memory leaks. Use weak references?
   * But what is leaking seems to be the Access objects, which isn't the case for Globals. Weird.
   * @param acc            access
   * @param boundReceiver  the receiver bound to the callsite
   * @param receiver       the receiver to check against
   * @return true if this receiver is still the one we bound to the callsite
   */
  @SuppressWarnings("unused")
  static boolean receiverGuard(Access acc, Object boundReceiver, Object receiver) {
    var id = receiver == boundReceiver;
    if (!id) {
      acc.failGuard();
    }
    return id;
  }

  static boolean isGlobalSetter(ScriptObject receiver, FindProperty find) {
    return (find == null) ? receiver.isScope() : find.getOwner().isGlobal();
  }

  /**
   * Augment a setter with switchpoint for invalidating its getters, should the setter be called
   * @param find    property lookup
   * @param inv     normal guarded invocation for this setter, as computed by the ScriptObject linker
   * @param desc    callsite descriptor
   * @param request link request
   * @return null if failed to set up constant linkage
   */
  GuardedInvocation findSetMethod(FindProperty find, ScriptObject receiver, GuardedInvocation inv, CallSiteDescriptor desc, LinkRequest request) {
    if (invalidatedForever.get() || (GLOBAL_ONLY && !isGlobalSetter(receiver, find))) {
      return null;
    }
    var name = NashornCallSiteDescriptor.getOperand(desc);
    synchronized (this) {
      var acc = getOrCreateSwitchPoint(name);
      if (!acc.mayRetry() || invalidatedForever.get()) {
        return null;
      }
      if (acc.hasBeenInvalidated()) {
        acc.newSwitchPoint();
      }
      assert !acc.hasBeenInvalidated();
      // if we haven't given up on this symbol, add a switchpoint invalidation filter to the receiver parameter
      var target = inv.getInvocation();
      var receiverType = target.type().parameterType(0);
      var boundInvalidator = MH.bindTo(INVALIDATE_SP, this);
      var invalidator = MH.asType(boundInvalidator, boundInvalidator.type().changeParameterType(0, receiverType).changeReturnType(receiverType));
      var mh = MH.filterArguments(inv.getInvocation(), 0, MH.insertArguments(invalidator, 1, acc));
      assert inv.getSwitchPoints() == null : Arrays.asList(inv.getSwitchPoints());
      return new GuardedInvocation(mh, inv.getGuard(), acc.getSwitchPoint(), inv.getException());
    }
  }

  /**
   * Try to reuse constant method handles for getters
   * @param c constant value
   * @return method handle (with dummy receiver) that returns this constant
   */
  public static MethodHandle staticConstantGetter(Object c) {
    return MH.dropArguments(JSType.unboxConstant(c), 0, Object.class);
  }

  MethodHandle constantGetter(Object c) {
    return staticConstantGetter(c);
  }

  /**
   * Try to turn a getter into a MethodHandle.constant, if possible
   * @param find      property lookup
   * @param receiver  receiver
   * @param desc      callsite descriptor
   * @return resulting getter, or null if failed to create constant
   */
  GuardedInvocation findGetMethod(FindProperty find, ScriptObject receiver, CallSiteDescriptor desc) {
    // Only use constant getter for fast scope access, because the receiver may change between invocations for slow-scope and non-scope callsites.
    // Also return null for user accessor properties as they may have side effects.
    if (invalidatedForever.get() || !NashornCallSiteDescriptor.isFastScope(desc) || (GLOBAL_ONLY && !find.getOwner().isGlobal()) || find.getProperty() instanceof UserAccessorProperty) {
      return null;
    }
    var isOptimistic = NashornCallSiteDescriptor.isOptimistic(desc);
    var programPoint = isOptimistic ? getProgramPoint(desc) : INVALID_PROGRAM_POINT;
    var retType = desc.getMethodType().returnType();
    var name = NashornCallSiteDescriptor.getOperand(desc);
    synchronized (this) {
      var acc = getOrCreateSwitchPoint(name);
      var c = find.getObjectValue();
      if (acc.hasBeenInvalidated() || acc.guardFailed() || invalidatedForever.get()) {
        return null;
      }
      var cmh = constantGetter(c);
      MethodHandle mh;
      MethodHandle guard;
      if (isOptimistic) {
        if (JSType.getAccessorTypeIndex(cmh.type().returnType()) <= JSType.getAccessorTypeIndex(retType)) {
          //widen return type - this is pessimistic, so it will always work
          mh = MH.asType(cmh, cmh.type().changeReturnType(retType));
        } else {
          //immediately invalidate - we asked for a too wide constant as a narrower one
          mh = MH.dropArguments(MH.insertArguments(JSType.THROW_UNWARRANTED.methodHandle(), 0, c, programPoint), 0, Object.class);
        }
      } else {
        //pessimistic return type filter
        mh = Lookup.filterReturnType(cmh, retType);
      }
      if (find.getOwner().isGlobal()) {
        guard = null;
      } else {
        guard = MH.insertArguments(RECEIVER_GUARD, 0, acc, receiver);
      }
      return new GuardedInvocation(mh, guard, acc.getSwitchPoint(), null);
    }
  }

}
