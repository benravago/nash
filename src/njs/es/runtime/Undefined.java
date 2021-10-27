package es.runtime;

import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.NamedOperation;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.support.Guards;
import es.runtime.linker.NashornCallSiteDescriptor;

/**
 * Unique instance of this class is used to represent JavaScript undefined.
 */
public final class Undefined extends DefaultPropertyAccess {

  private static final Undefined UNDEFINED = new Undefined();
  private static final Undefined EMPTY = new Undefined();

  // Guard used for indexed property access/set on the Undefined instance
  private static final MethodHandle UNDEFINED_GUARD = Guards.getIdentityGuard(UNDEFINED);

  /**
   * Get the value of {@code undefined}, this is represented as a global singleton instance of this class.
   * It can always be reference compared
   * @return the undefined object
   */
  public static Undefined getUndefined() {
    return UNDEFINED;
  }

  /**
   * Get the value of {@code empty}.
   * This is represented as a global singleton instanceof this class.
   * It can always be reference compared.
   * Note: We need empty to differentiate behavior in things like array iterators
   * @return the empty object
   */
  public static Undefined getEmpty() {
    return EMPTY;
  }

  /**
   * Get the class name of Undefined
   * @return "Undefined"
   */
  @SuppressWarnings("static-method")
  public String getClassName() {
    return "Undefined";
  }

  @Override
  public String toString() {
    return "undefined";
  }

  /**
   * Lookup the appropriate method for an invoke dynamic call.
   * @param desc The invoke dynamic callsite descriptor.
   * @return GuardedInvocation to be invoked at call site.
   */
  public static GuardedInvocation lookup(CallSiteDescriptor desc) {
    return switch (NashornCallSiteDescriptor.getStandardOperation(desc)) {
      case CALL, NEW -> {
        var name = NashornCallSiteDescriptor.getOperand(desc);
        var msg = name != null ? "not.a.function" : "cant.call.undefined";
        throw typeError(msg, name);
      }
      // NOTE: we support GET:ELEMENT and SET:ELEMENT as JavaScript doesn't distinguish items from properties.
      // Nashorn itself emits "GET:PROPERTY|ELEMENT|METHOD:identifier" for "<expr>.<identifier>" and "GET:ELEMENT|PROPERTY|METHOD" for "<expr>[<expr>]", but we are more flexible here and dispatch not on operation name (getProp vs. getElem), but rather on whether the operation has an associated name or not.
      case GET -> desc.getOperation() instanceof NamedOperation ? findGetMethod(desc) : findGetIndexMethod(desc);
      case SET -> desc.getOperation() instanceof NamedOperation ? findSetMethod(desc) : findSetIndexMethod(desc);
      case REMOVE -> desc.getOperation() instanceof NamedOperation ? findDeleteMethod(desc) : findDeleteIndexMethod(desc);
      default -> null;
    };
  }

  static ECMAException lookupTypeError(String msg, CallSiteDescriptor desc) {
    var name = NashornCallSiteDescriptor.getOperand(desc);
    return typeError(msg, name != null && !name.isEmpty() ? name : null);
  }

  private static final MethodHandle GET_METHOD = findOwnMH("get", Object.class, Object.class);
  private static final MethodHandle SET_METHOD = MH.insertArguments(findOwnMH("set", void.class, Object.class, Object.class, int.class), 3, 0);
  private static final MethodHandle DELETE_METHOD = findOwnMH("delete", boolean.class, Object.class);

  static GuardedInvocation findGetMethod(CallSiteDescriptor desc) {
    return new GuardedInvocation(MH.insertArguments(GET_METHOD, 1, NashornCallSiteDescriptor.getOperand(desc)), UNDEFINED_GUARD).asType(desc);
  }

  static GuardedInvocation findGetIndexMethod(CallSiteDescriptor desc) {
    return new GuardedInvocation(GET_METHOD, UNDEFINED_GUARD).asType(desc);
  }

  static GuardedInvocation findSetMethod(CallSiteDescriptor desc) {
    return new GuardedInvocation(MH.insertArguments(SET_METHOD, 1, NashornCallSiteDescriptor.getOperand(desc)), UNDEFINED_GUARD).asType(desc);
  }

  static GuardedInvocation findSetIndexMethod(CallSiteDescriptor desc) {
    return new GuardedInvocation(SET_METHOD, UNDEFINED_GUARD).asType(desc);
  }

  static GuardedInvocation findDeleteMethod(CallSiteDescriptor desc) {
    return new GuardedInvocation(MH.insertArguments(DELETE_METHOD, 1, NashornCallSiteDescriptor.getOperand(desc)), UNDEFINED_GUARD).asType(desc);
  }

  static GuardedInvocation findDeleteIndexMethod(CallSiteDescriptor desc) {
    return new GuardedInvocation(DELETE_METHOD, UNDEFINED_GUARD).asType(desc);
  }

  @Override
  public Object get(Object key) {
    throw typeError("cant.read.property.of.undefined", ScriptRuntime.safeToString(key));
  }

  @Override
  public void set(Object key, Object value, int flags) {
    throw typeError("cant.set.property.of.undefined", ScriptRuntime.safeToString(key));
  }

  @Override
  public boolean delete(Object key) {
    throw typeError("cant.delete.property.of.undefined", ScriptRuntime.safeToString(key));
  }

  @Override
  public boolean has(Object key) {
    return false;
  }

  @Override
  public boolean hasOwnProperty(Object key) {
    return false;
  }

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findVirtual(MethodHandles.lookup(), Undefined.class, name, MH.type(rtype, types));
  }

}
