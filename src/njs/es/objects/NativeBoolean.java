package es.objects;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;

import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.linker.PrimitiveLookup;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;

/**
 * ECMA 15.6 Boolean Objects.
 */
@ScriptClass("Boolean")
public final class NativeBoolean extends ScriptObject {

  private final boolean value;

  // Method handle to create an object wrapper for a primitive boolean.
  static final MethodHandle WRAPFILTER = findOwnMH("wrapFilter", MH.type(NativeBoolean.class, Object.class));

  // Method handle to retrieve the Boolean prototype object.
  private static final MethodHandle PROTOFILTER = findOwnMH("protoFilter", MH.type(Object.class, Object.class));

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  NativeBoolean(boolean value, ScriptObject proto, PropertyMap map) {
    super(proto, map);
    this.value = value;
  }

  NativeBoolean(boolean flag, Global global) {
    this(flag, global.getBooleanPrototype(), $nasgenmap$);
  }

  NativeBoolean(boolean flag) {
    this(flag, Global.instance());
  }

  @Override
  public String safeToString() {
    return "[Boolean " + toString() + "]";
  }

  @Override
  public String toString() {
    return Boolean.toString(getValue());
  }

  /**
   * Get the value for this NativeBoolean
   * @return true or false
   */
  public boolean getValue() {
    return booleanValue();
  }

  /**
   * Get the value for this NativeBoolean
   * @return true or false
   */
  public boolean booleanValue() {
    return value;
  }

  @Override
  public String getClassName() {
    return "Boolean";
  }

  /**
   * ECMA 15.6.4.2 Boolean.prototype.toString ( )
   * @param self self reference
   * @return string representation of this boolean
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toString(Object self) {
    return getBoolean(self).toString();
  }

  /**
   * ECMA 15.6.4.3 Boolean.prototype.valueOf ( )
   * @param self self reference
   * @return value of this boolean
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean valueOf(Object self) {
    return getBoolean(self);
  }

  /**
   * ECMA 15.6.2.1 new Boolean (value)
   * @param newObj is the new operator used to instantiate this NativeBoolean
   * @param self   self reference
   * @param value  value of boolean
   * @return the new NativeBoolean
   */
  @Constructor(arity = 1)
  public static Object constructor(boolean newObj, Object self, Object value) {
    var flag = JSType.toBoolean(value);
    return newObj ? new NativeBoolean(flag) : flag;
  }

  static Boolean getBoolean(Object self) {
    if (self instanceof Boolean b) {
      return b;
    } else if (self instanceof NativeBoolean nb) {
      return nb.getValue();
    } else if (self != null && self == Global.instance().getBooleanPrototype()) {
      return false;
    } else {
      throw typeError("not.a.boolean", ScriptRuntime.safeToString(self));
    }
  }

  /**
   * Lookup the appropriate method for an invoke dynamic call.
   * @param request  The link request
   * @param receiver The receiver for the call
   * @return Link to be invoked at call site.
   */
  public static GuardedInvocation lookupPrimitive(LinkRequest request, Object receiver) {
    return PrimitiveLookup.lookupPrimitive(request, Boolean.class, new NativeBoolean((Boolean) receiver), WRAPFILTER, PROTOFILTER);
  }

  /**
   * Wrap a native boolean in a NativeBoolean object.
   * @param receiver Native boolean.
   * @return Wrapped object.
   */
  @SuppressWarnings("unused")
  static NativeBoolean wrapFilter(Object receiver) {
    return new NativeBoolean((Boolean) receiver);
  }

  @SuppressWarnings("unused")
  static Object protoFilter(Object object) {
    return Global.instance().getBooleanPrototype();
  }

  static MethodHandle findOwnMH(String name, MethodType type) {
    return MH.findStatic(MethodHandles.lookup(), NativeBoolean.class, name, type);
  }

}
