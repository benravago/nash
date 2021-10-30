package es.runtime;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import es.lookup.Lookup;
import es.runtime.linker.Bootstrap;
import es.runtime.linker.NashornCallSiteDescriptor;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.ScriptRuntime.UNDEFINED;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;
import static es.runtime.linker.NashornCallSiteDescriptor.CALLSITE_PROGRAM_POINT_SHIFT;

/**
 * Property with user defined getters/setters.
 * Actual getter and setter functions are stored in underlying ScriptObject. Only the 'slot' info is stored in the property.
 */
public final class UserAccessorProperty extends SpillProperty {

  static final class Accessors {

    Object getter;
    Object setter;

    Accessors(Object getter, Object setter) {
      set(getter, setter);
    }

    final void set(Object getter, Object setter) {
      this.getter = getter;
      this.setter = setter;
    }

    @Override
    public String toString() {
      return "[getter=" + getter + " setter=" + setter + ']';
    }
  }

  private static final MethodHandles.Lookup LOOKUP = MethodHandles.lookup();

  // Getter method handle
  private final static MethodHandle INVOKE_OBJECT_GETTER = findOwnMH_S("invokeObjectGetter", Object.class, Accessors.class, MethodHandle.class, Object.class);
  private final static MethodHandle INVOKE_INT_GETTER = findOwnMH_S("invokeIntGetter", int.class, Accessors.class, MethodHandle.class, int.class, Object.class);
  private final static MethodHandle INVOKE_NUMBER_GETTER = findOwnMH_S("invokeNumberGetter", double.class, Accessors.class, MethodHandle.class, int.class, Object.class);

  // Setter method handle
  private final static MethodHandle INVOKE_OBJECT_SETTER = findOwnMH_S("invokeObjectSetter", void.class, Accessors.class, MethodHandle.class, String.class, Object.class, Object.class);
  private final static MethodHandle INVOKE_INT_SETTER = findOwnMH_S("invokeIntSetter", void.class, Accessors.class, MethodHandle.class, String.class, Object.class, int.class);
  private final static MethodHandle INVOKE_NUMBER_SETTER = findOwnMH_S("invokeNumberSetter", void.class, Accessors.class, MethodHandle.class, String.class, Object.class, double.class);

  private static final Object OBJECT_GETTER_INVOKER_KEY = new Object();

  static MethodHandle getObjectGetterInvoker() {
    return Context.getGlobal().getDynamicInvoker(OBJECT_GETTER_INVOKER_KEY, () -> getINVOKE_UA_GETTER(Object.class, INVALID_PROGRAM_POINT));
  }

  static MethodHandle getINVOKE_UA_GETTER(Class<?> returnType, int programPoint) {
    if (UnwarrantedOptimismException.isValid(programPoint)) {
      var flags = NashornCallSiteDescriptor.CALL | NashornCallSiteDescriptor.CALLSITE_OPTIMISTIC | programPoint << CALLSITE_PROGRAM_POINT_SHIFT;
      return Bootstrap.createDynamicInvoker("", flags, returnType, Object.class, Object.class);
    } else {
      return Bootstrap.createDynamicCallInvoker(Object.class, Object.class, Object.class);
    }
  }

  private static final Object OBJECT_SETTER_INVOKER_KEY = new Object();

  static MethodHandle getObjectSetterInvoker() {
    return Context.getGlobal().getDynamicInvoker(OBJECT_SETTER_INVOKER_KEY, () -> getINVOKE_UA_SETTER(Object.class));
  }

  static MethodHandle getINVOKE_UA_SETTER(Class<?> valueType) {
    return Bootstrap.createDynamicCallInvoker(void.class, Object.class, Object.class, valueType);
  }

  /**
   * Constructor
   * @param key   property key
   * @param flags property flags
   * @param slot  spill slot
   */
  UserAccessorProperty(Object key, int flags, int slot) {
    // Always set accessor property flag for this class
    super(key, flags | IS_ACCESSOR_PROPERTY, slot);
  }

  UserAccessorProperty(UserAccessorProperty property) {
    super(property);
  }

  UserAccessorProperty(UserAccessorProperty property, Class<?> newType) {
    super(property, newType);
  }

  @Override
  public Property copy() {
    return new UserAccessorProperty(this);
  }

  @Override
  public Property copy(Class<?> newType) {
    return new UserAccessorProperty(this, newType);
  }

  void setAccessors(ScriptObject sobj, PropertyMap map, Accessors gs) {
    try {
      //invoke the getter and find out
      super.getSetter(Object.class, map).invokeExact((Object) sobj, (Object) gs);
    } catch (Error | RuntimeException t) {
      throw t;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  // pick the getter setter out of the correct spill slot in sobj
  Accessors getAccessors(ScriptObject sobj) {
    try {
      // invoke the super getter with this spill slot
      // get the getter setter from the correct spill slot
      var gs = super.getGetter(Object.class).invokeExact((Object) sobj);
      return (Accessors) gs;
    } catch (Error | RuntimeException t) {
      throw t;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  @Override
  protected Class<?> getLocalType() {
    return Object.class;
  }

  @Override
  public boolean hasGetterFunction(ScriptObject sobj) {
    return getAccessors(sobj).getter != null;
  }

  @Override
  public boolean hasSetterFunction(ScriptObject sobj) {
    return getAccessors(sobj).setter != null;
  }

  @Override
  public int getIntValue(ScriptObject self, ScriptObject owner) {
    return (int) getObjectValue(self, owner);
  }

  @Override
  public double getDoubleValue(ScriptObject self, ScriptObject owner) {
    return (double) getObjectValue(self, owner);
  }

  @Override
  public Object getObjectValue(ScriptObject self, ScriptObject owner) {
    try {
      return invokeObjectGetter(getAccessors((owner != null) ? owner : self), getObjectGetterInvoker(), self);
    } catch (Error | RuntimeException t) {
      throw t;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  @Override
  public void setValue(ScriptObject self, ScriptObject owner, int value) {
    setValue(self, owner, (Object) value);
  }

  @Override
  public void setValue(ScriptObject self, ScriptObject owner, double value) {
    setValue(self, owner, (Object) value);
  }

  @Override
  public void setValue(ScriptObject self, ScriptObject owner, Object value) {
    try {
      invokeObjectSetter(getAccessors((owner != null) ? owner : self), getObjectSetterInvoker(), getKey().toString(), self, value);
    } catch (Error | RuntimeException t) {
      throw t;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  @Override
  public MethodHandle getGetter(Class<?> type) {
    // this returns a getter on the format (Accessors, Object receiver)
    return Lookup.filterReturnType(INVOKE_OBJECT_GETTER, type);
  }

  @Override
  public MethodHandle getOptimisticGetter(Class<?> type, int programPoint) {
    if (type == int.class) {
      return INVOKE_INT_GETTER;
    } else if (type == double.class) {
      return INVOKE_NUMBER_GETTER;
    } else {
      assert type == Object.class;
      return INVOKE_OBJECT_GETTER;
    }
  }

  @Override
  void initMethodHandles(Class<?> structure) {
    throw new UnsupportedOperationException();
  }

  @Override
  public ScriptFunction getGetterFunction(ScriptObject sobj) {
    var value = getAccessors(sobj).getter;
    return (value instanceof ScriptFunction) ? (ScriptFunction) value : null;
  }

  @Override
  public MethodHandle getSetter(Class<?> type, PropertyMap currentMap) {
    if (type == int.class) {
      return INVOKE_INT_SETTER;
    } else if (type == double.class) {
      return INVOKE_NUMBER_SETTER;
    } else {
      assert type == Object.class;
      return INVOKE_OBJECT_SETTER;
    }
  }

  @Override
  public ScriptFunction getSetterFunction(ScriptObject sobj) {
    var value = getAccessors(sobj).setter;
    return (value instanceof ScriptFunction) ? (ScriptFunction) value : null;
  }

  /**
   * Get the getter for the {@code Accessors} object.
   * This is the the super {@code Object} type getter with {@code Accessors} return type.
   * @return The getter handle for the Accessors
   */
  MethodHandle getAccessorsGetter() {
    return super.getGetter(Object.class).asType(MethodType.methodType(Accessors.class, Object.class));
  }

  // User defined getter and setter are always called by StandardOperation.CALL.
  // Note that the user getter/setter may be inherited.
  // If so, proto is bound during lookup.
  // In either inherited or self case, slot is also bound during lookup.
  // Actual ScriptFunction to be called is retrieved everytime and applied.
  @SuppressWarnings("unused")
  static Object invokeObjectGetter(Accessors gs, MethodHandle invoker, Object self) throws Throwable {
    var func = gs.getter;
    if (func instanceof ScriptFunction) {
      return invoker.invokeExact(func, self);
    }
    return UNDEFINED;
  }

  @SuppressWarnings("unused")
  static int invokeIntGetter(Accessors gs, MethodHandle invoker, int programPoint, Object self) throws Throwable {
    var func = gs.getter;
    if (func instanceof ScriptFunction) {
      return (int) invoker.invokeExact(func, self);
    }
    throw new UnwarrantedOptimismException(UNDEFINED, programPoint);
  }

  @SuppressWarnings("unused")
  static double invokeNumberGetter(Accessors gs, MethodHandle invoker, int programPoint, Object self) throws Throwable {
    var func = gs.getter;
    if (func instanceof ScriptFunction) {
      return (double) invoker.invokeExact(func, self);
    }
    throw new UnwarrantedOptimismException(UNDEFINED, programPoint);
  }

  @SuppressWarnings("unused")
  static void invokeObjectSetter(Accessors gs, MethodHandle invoker, String name, Object self, Object value) throws Throwable {
    var func = gs.setter;
    if (func instanceof ScriptFunction) {
      invoker.invokeExact(func, self, value);
    } else if (name != null) {
      throw typeError("property.has.no.setter", name, ScriptRuntime.safeToString(self));
    }
  }

  @SuppressWarnings("unused")
  static void invokeIntSetter(Accessors gs, MethodHandle invoker, String name, Object self, int value) throws Throwable {
    var func = gs.setter;
    if (func instanceof ScriptFunction) {
      invoker.invokeExact(func, self, value);
    } else if (name != null) {
      throw typeError("property.has.no.setter", name, ScriptRuntime.safeToString(self));
    }
  }

  @SuppressWarnings("unused")
  static void invokeNumberSetter(Accessors gs, MethodHandle invoker, String name, Object self, double value) throws Throwable {
    var func = gs.setter;
    if (func instanceof ScriptFunction) {
      invoker.invokeExact(func, self, value);
    } else if (name != null) {
      throw typeError("property.has.no.setter", name, ScriptRuntime.safeToString(self));
    }
  }

  private static MethodHandle findOwnMH_S(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(LOOKUP, UserAccessorProperty.class, name, MH.type(rtype, types));
  }
  
  private static final long serialVersionUID = 1;
}
