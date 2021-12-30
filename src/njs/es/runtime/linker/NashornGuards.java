package es.runtime.linker;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.ref.WeakReference;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.linker.LinkRequest;

import nash.scripting.JSObject;

import es.objects.Global;
import es.runtime.JSType;
import es.runtime.Property;
import es.runtime.PropertyMap;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.options.Option;
import static es.lookup.Lookup.MH;

/**
 * Constructor of method handles used to guard call sites.
 */
public final class NashornGuards {

  private static final MethodHandle IS_MAP = findOwnMH("isMap", boolean.class, ScriptObject.class, PropertyMap.class);
  private static final MethodHandle IS_MAP_SCRIPTOBJECT = findOwnMH("isMap", boolean.class, Object.class, PropertyMap.class);
  private static final MethodHandle IS_SCRIPTOBJECT = findOwnMH("isScriptObject", boolean.class, Object.class);
  private static final MethodHandle IS_NOT_JSOBJECT = findOwnMH("isNotJSObject", boolean.class, Object.class);
  private static final MethodHandle SAME_OBJECT = findOwnMH("sameObject", boolean.class, Object.class, WeakReference.class);

  // TODO - maybe put this back in ScriptFunction instead of the ClassCastException.class relinkage
  // private static final MethodHandle IS_SCRIPTFUNCTION = findOwnMH("isScriptFunction", boolean.class, Object.class);

  private static final boolean CCE_ONLY = Option.get("cce.only",false);

  /**
   * Given a callsite descriptor and a link request, determine whether we should use an instanceof check explicitly for the guard if needed, or if we should link it with a try/catch ClassCastException combinator as its relink criteria - i.e. relink when CCE is thrown.
   * @param desc     callsite descriptor
   * @param request  link request
   * @return true of explicit instanceof check is needed
   */
  public static boolean explicitInstanceOfCheck(CallSiteDescriptor desc, LinkRequest request) {
    // THIS is currently true, as the inliner encounters several problems with sun.misc.ValueConversions.castReference otherwise.
    // We should only use the exception based relink where we have no choice, and the result is faster code, for example in the NativeArray, TypedArray, ContinuousArray getters.
    // For the standard callsite, it appears that we lose performance rather than gain it, due to JVM issues. :-(
    return !CCE_ONLY;
  }

  /**
   * Returns a guard that does an instanceof ScriptObject check on the receiver
   * @return guard
   */
  public static MethodHandle getScriptObjectGuard() {
    return IS_SCRIPTOBJECT;
  }

  /**
   * Get the guard that checks if an item is not a {@code JSObject}
   * @return method handle for guard
   */
  public static MethodHandle getNotJSObjectGuard() {
    return IS_NOT_JSOBJECT;
  }

  /**
   * Returns a guard that does an instanceof ScriptObject check on the receiver
   * @param explicitInstanceOfCheck - if false, then this is a nop, because it's all the guard does
   * @return guard
   */
  public static MethodHandle getScriptObjectGuard(boolean explicitInstanceOfCheck) {
    return explicitInstanceOfCheck ? IS_SCRIPTOBJECT : null;
  }

  /**
   * Get the guard that checks if a {@link PropertyMap} is equal to a known map, using reference comparison
   * @param explicitInstanceOfCheck true if we should do an explicit script object instanceof check instead of just casting
   * @param map The map to check against. This will be bound to the guard method handle
   * @return method handle for guard
   */
  public static MethodHandle getMapGuard(PropertyMap map, boolean explicitInstanceOfCheck) {
    return MH.insertArguments(explicitInstanceOfCheck ? IS_MAP_SCRIPTOBJECT : IS_MAP, 1, map);
  }

  /**
   * Determine whether the given callsite needs a guard.
   * @param property the property, or null
   * @param desc the callsite descriptor
   * @return true if a guard should be used for this callsite
   */
  static boolean needsGuard(Property property, CallSiteDescriptor desc) {
    return property == null || property.isConfigurable() || property.isBound() || property.hasDualFields() || !NashornCallSiteDescriptor.isFastScope(desc) || property.canChangeType();
  }

  /**
   * Get the guard for a property access.
   * This returns an identity guard for non-configurable global properties and a map guard for everything else.
   * @param sobj the first object in the prototype chain
   * @param property the property
   * @param desc the callsite descriptor
   * @param explicitInstanceOfCheck true if we should do an explicit script object instanceof check instead of just casting
   * @return method handle for guard
   */
  public static MethodHandle getGuard(ScriptObject sobj, Property property, CallSiteDescriptor desc, boolean explicitInstanceOfCheck) {
    if (!needsGuard(property, desc)) {
      return null;
    }
    if (NashornCallSiteDescriptor.isScope(desc) && sobj.isScope()) {
      if (property != null && property.isBound() && !property.canChangeType()) {
        // This is a declared top level variables in main script or eval, use identity guard.
        return getIdentityGuard(sobj);
      }
      if (!(sobj instanceof Global) && (property == null || property.isConfigurable())) {
        // Undeclared variables in nested evals need stronger guards
        return combineGuards(getIdentityGuard(sobj), getMapGuard(sobj.getMap(), explicitInstanceOfCheck));
      }
    }
    return getMapGuard(sobj.getMap(), explicitInstanceOfCheck);
  }

  /**
   * Get a guard that checks referential identity of the current object.
   * @param sobj the self object
   * @return true if same self object instance
   */
  public static MethodHandle getIdentityGuard(ScriptObject sobj) {
    return MH.insertArguments(SAME_OBJECT, 1, new WeakReference<>(sobj));
  }

  /**
   * Get a guard that checks if in item is a JS string.
   * @return method handle for guard
   */
  public static MethodHandle getStringGuard() {
    return JSType.IS_STRING.methodHandle();
  }

  /**
   * Get a guard that checks if in item is a JS number.
   * @return method handle for guard
   */
  public static MethodHandle getNumberGuard() {
    return JSType.IS_NUMBER.methodHandle();
  }

  /**
   * Combine two method handles of type {@code (Object)boolean} using logical AND.
   * @param guard1 the first guard
   * @param guard2 the second guard, only invoked if guard1 returns true
   * @return true if both guard1 and guard2 returned true
   */
  public static MethodHandle combineGuards(MethodHandle guard1, MethodHandle guard2) {
    return (guard1 == null) ? guard2
         : (guard2 == null) ? guard1
         : MH.guardWithTest(guard1, guard2, MH.dropArguments(MH.constant(boolean.class, false), 0, Object.class));
  }

  @SuppressWarnings("unused")
  static boolean isScriptObject(Object self) {
    return self instanceof ScriptObject;
  }

  @SuppressWarnings("unused")
  static boolean isScriptObject(Class<? extends ScriptObject> clazz, Object self) {
    return clazz.isInstance(self);
  }

  @SuppressWarnings("unused")
  static boolean isMap(ScriptObject self, PropertyMap map) {
    return self.getMap() == map;
  }

  @SuppressWarnings("unused")
  static boolean isNotJSObject(Object self) {
    return !(self instanceof JSObject);
  }

  @SuppressWarnings("unused")
  static boolean isMap(Object self, PropertyMap map) {
    return self instanceof ScriptObject && ((ScriptObject) self).getMap() == map;
  }

  @SuppressWarnings("unused")
  static boolean sameObject(Object self, WeakReference<ScriptObject> ref) {
    return self == ref.get();
  }

  @SuppressWarnings("unused")
  static boolean isScriptFunction(Object self) {
    return self instanceof ScriptFunction;
  }

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), NashornGuards.class, name, MH.type(rtype, types));
  }

}
