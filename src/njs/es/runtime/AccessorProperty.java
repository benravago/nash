package es.runtime;

import java.io.IOException;
import java.io.ObjectInputStream;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.SwitchPoint;

import es.codegen.ObjectClassGenerator;
import es.codegen.types.Type;
import es.lookup.Lookup;
import static es.codegen.ObjectClassGenerator.*;
import static es.lookup.Lookup.MH;
import static es.runtime.JSType.getAccessorTypeIndex;
import static es.runtime.JSType.getNumberOfAccessorTypes;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;

/**
 * An AccessorProperty is the most generic property type.
 * An AccessorProperty is represented as fields in a ScriptObject class.
 */
public class AccessorProperty extends Property {

  private static final MethodHandles.Lookup LOOKUP = MethodHandles.lookup();

  private static final MethodHandle REPLACE_MAP = findOwnMH_S("replaceMap", Object.class, Object.class, PropertyMap.class);
  private static final MethodHandle INVALIDATE_SP = findOwnMH_S("invalidateSwitchPoint", Object.class, AccessorProperty.class, Object.class);

  private static final int NOOF_TYPES = getNumberOfAccessorTypes();

  // Properties in different maps for the same structure class will share their field getters and setters.
  // This could be further extended to other method handles that are looked up in the AccessorProperty constructor, but right now these are the most frequently retrieved ones, and lookup of method handle natives only registers in the profiler for them.
  private static ClassValue<Accessors> GETTERS_SETTERS = new ClassValue<Accessors>() {
    @Override
    protected Accessors computeValue(Class<?> structure) {
      return new Accessors(structure);
    }
  };

  private static class Accessors {

    final MethodHandle[] objectGetters;
    final MethodHandle[] objectSetters;
    final MethodHandle[] primitiveGetters;
    final MethodHandle[] primitiveSetters;

    /**
     * Normal
     * @param structure
     */
    Accessors(Class<?> structure) {
      var fieldCount = getFieldCount(structure);
      objectGetters = new MethodHandle[fieldCount];
      objectSetters = new MethodHandle[fieldCount];
      primitiveGetters = new MethodHandle[fieldCount];
      primitiveSetters = new MethodHandle[fieldCount];
      for (var i = 0; i < fieldCount; i++) {
        var fieldName = getFieldName(i, Type.OBJECT);
        var typeClass = Type.OBJECT.getTypeClass();
        objectGetters[i] = MH.asType(MH.getter(LOOKUP, structure, fieldName, typeClass), Lookup.GET_OBJECT_TYPE);
        objectSetters[i] = MH.asType(MH.setter(LOOKUP, structure, fieldName, typeClass), Lookup.SET_OBJECT_TYPE);
      }
      if (!StructureLoader.isSingleFieldStructure(structure.getName())) {
        for (var i = 0; i < fieldCount; i++) {
          var fieldNamePrimitive = getFieldName(i, PRIMITIVE_FIELD_TYPE);
          var typeClass = PRIMITIVE_FIELD_TYPE.getTypeClass();
          primitiveGetters[i] = MH.asType(MH.getter(LOOKUP, structure, fieldNamePrimitive, typeClass), Lookup.GET_PRIMITIVE_TYPE);
          primitiveSetters[i] = MH.asType(MH.setter(LOOKUP, structure, fieldNamePrimitive, typeClass), Lookup.SET_PRIMITIVE_TYPE);
        }
      }
    }
  }

  // Property getter cache.
  // Note that we can't do the same simple caching for optimistic getters, due to the fact that they are bound to a program point, which will produce different boun method handles wrapping the same access mechanism depending on callsite
  private transient MethodHandle[] GETTER_CACHE = new MethodHandle[NOOF_TYPES];

  /**
   * Create a new accessor property. Factory method used by nasgen generated code.
   * @param key           {@link Property} key.
   * @param propertyFlags {@link Property} flags.
   * @param getter        {@link Property} get accessor method.
   * @param setter        {@link Property} set accessor method.
   * @return  New {@link AccessorProperty} created.
   */
  public static AccessorProperty create(Object key, int propertyFlags, MethodHandle getter, MethodHandle setter) {
    return new AccessorProperty(key, propertyFlags, -1, getter, setter);
  }

  // Seed getter for the primitive version of this field (in -Dnashorn.fields.dual=true mode)
  transient MethodHandle primitiveGetter;

  // Seed setter for the primitive version of this field (in -Dnashorn.fields.dual=true mode)
  transient MethodHandle primitiveSetter;

  // Seed getter for the Object version of this field
  transient MethodHandle objectGetter;

  // Seed setter for the Object version of this field
  transient MethodHandle objectSetter;

  /**
   * Delegate constructor for bound properties.
   * This is used for properties created by {@link ScriptRuntime#mergeScope} and the Nashorn {@code Object.bindProperties} method.
   * The former is used to add a script's defined globals to the current global scope while still storing them in a JO-prefixed ScriptObject class.
   * All properties created by this constructor have the {@link #IS_BOUND} flag set.
   * @param property  accessor property to rebind
   * @param delegate  delegate object to rebind receiver to
   */
  AccessorProperty(AccessorProperty property, Object delegate) {
    super(property, property.getFlags() | IS_BOUND);
    this.primitiveGetter = bindTo(property.primitiveGetter, delegate);
    this.primitiveSetter = bindTo(property.primitiveSetter, delegate);
    this.objectGetter = bindTo(property.objectGetter, delegate);
    this.objectSetter = bindTo(property.objectSetter, delegate);
    property.GETTER_CACHE = new MethodHandle[NOOF_TYPES];
    // Properties created this way are bound to a delegate
    setType(property.getType());
  }

  /**
   * SPILL PROPERTY or USER ACCESSOR PROPERTY abstract constructor.
   * Constructor for spill properties.
   * Array getters and setters will be created on demand.
   * @param key    the property key
   * @param flags  the property flags
   * @param slot   spill slot
   * @param primitiveGetter primitive getter
   * @param primitiveSetter primitive setter
   * @param objectGetter    object getter
   * @param objectSetter    object setter
   */
  protected AccessorProperty(Object key, int flags, int slot, MethodHandle primitiveGetter, MethodHandle primitiveSetter, MethodHandle objectGetter, MethodHandle objectSetter) {
    super(key, flags, slot);
    assert getClass() != AccessorProperty.class;
    this.primitiveGetter = primitiveGetter;
    this.primitiveSetter = primitiveSetter;
    this.objectGetter = objectGetter;
    this.objectSetter = objectSetter;
    initializeType();
  }

  /**
   * NASGEN constructor.
   * Constructor: Similar to the constructor with both primitive getters and setters, the difference here being that only one getter and setter (setter is optional for non writable fields) is given to the constructor, and the rest are created from those. Used e.g. by Nasgen classes
   * @param key    the property key
   * @param flags  the property flags
   * @param slot   the property field number or spill slot
   * @param getter the property getter
   * @param setter the property setter or null if non writable, non configurable
   */
  AccessorProperty(Object key, int flags, int slot, MethodHandle getter, MethodHandle setter) {
    super(key, flags | IS_BUILTIN | DUAL_FIELDS | (getter.type().returnType().isPrimitive() ? IS_NASGEN_PRIMITIVE : 0), slot);
    assert !isSpill();
    // we don't need to prep the setters these will never be invalidated as this is a nasgen or known type getter/setter.
    // No invalidations will take place
    var getterType = getter.type().returnType();
    var setterType = setter == null ? null : setter.type().parameterType(1);
    assert setterType == null || setterType == getterType;
    if (getterType == int.class) {
      primitiveGetter = MH.asType(getter, Lookup.GET_PRIMITIVE_TYPE);
      primitiveSetter = setter == null ? null : MH.asType(setter, Lookup.SET_PRIMITIVE_TYPE);
    } else if (getterType == double.class) {
      primitiveGetter = MH.asType(MH.filterReturnValue(getter, ObjectClassGenerator.PACK_DOUBLE), Lookup.GET_PRIMITIVE_TYPE);
      primitiveSetter = setter == null ? null : MH.asType(MH.filterArguments(setter, 1, ObjectClassGenerator.UNPACK_DOUBLE), Lookup.SET_PRIMITIVE_TYPE);
    } else {
      primitiveGetter = primitiveSetter = null;
    }
    assert primitiveGetter == null || primitiveGetter.type() == Lookup.GET_PRIMITIVE_TYPE : primitiveGetter + "!=" + Lookup.GET_PRIMITIVE_TYPE;
    assert primitiveSetter == null || primitiveSetter.type() == Lookup.SET_PRIMITIVE_TYPE : primitiveSetter;
    objectGetter = getter.type() != Lookup.GET_OBJECT_TYPE ? MH.asType(getter, Lookup.GET_OBJECT_TYPE) : getter;
    objectSetter = setter != null && setter.type() != Lookup.SET_OBJECT_TYPE ? MH.asType(setter, Lookup.SET_OBJECT_TYPE) : setter;
    setType(getterType);
  }

  /**
   * Normal ACCESS PROPERTY constructor given a structure class.
   * Constructor for dual field AccessorPropertys.
   * @param key              property key
   * @param flags            property flags
   * @param structure        structure for objects associated with this property
   * @param slot             property field number or spill slot
   */
  public AccessorProperty(Object key, int flags, Class<?> structure, int slot) {
    super(key, flags, slot);
    initGetterSetter(structure);
    initializeType();
  }

  final void initGetterSetter(Class<?> structure) {
    var slot = getSlot();
    // primitiveGetter and primitiveSetter are only used in dual fields mode.
    // Setting them to null also works in dual field mode, it only means that the property never has a primitive representation.
    if (isParameter() && hasArguments()) {
      // parameters are always stored in an object array, which may or may not be a good idea
      var arguments = MH.getter(LOOKUP, structure, "arguments", ScriptObject.class);
      objectGetter = MH.asType(MH.insertArguments(MH.filterArguments(ScriptObject.GET_ARGUMENT.methodHandle(), 0, arguments), 1, slot), Lookup.GET_OBJECT_TYPE);
      objectSetter = MH.asType(MH.insertArguments(MH.filterArguments(ScriptObject.SET_ARGUMENT.methodHandle(), 0, arguments), 1, slot), Lookup.SET_OBJECT_TYPE);
      primitiveGetter = null;
      primitiveSetter = null;
    } else {
      var gs = GETTERS_SETTERS.get(structure);
      objectGetter = gs.objectGetters[slot];
      primitiveGetter = gs.primitiveGetters[slot];
      objectSetter = gs.objectSetters[slot];
      primitiveSetter = gs.primitiveSetters[slot];
    }
    // Always use dual fields except for single field structures
    assert hasDualFields() != StructureLoader.isSingleFieldStructure(structure.getName());
  }

  /**
   * Constructor
   * @param key          key
   * @param flags        flags
   * @param slot         field slot index
   * @param owner        owner of property
   * @param initialValue initial value to which the property can be set
   */
  protected AccessorProperty(Object key, int flags, int slot, ScriptObject owner, Object initialValue) {
    this(key, flags, owner.getClass(), slot);
    setInitialValue(owner, initialValue);
  }

  /**
   * Normal access property constructor that overrides the type Override the initial type.
   * Used for Object Literals
   * @param key          key
   * @param flags        flags
   * @param structure    structure to JO subclass
   * @param slot         field slot index
   * @param initialType  initial type of the property
   */
  public AccessorProperty(Object key, int flags, Class<?> structure, int slot, Class<?> initialType) {
    this(key, flags, structure, slot);
    setType(hasDualFields() ? initialType : Object.class);
  }

  /**
   * Copy constructor that may change type and in that case clear the cache.
   * Important to do that before type change or getters will be created already stale.
   * @param property property
   * @param newType  new type
   */
  protected AccessorProperty(AccessorProperty property, Class<?> newType) {
    super(property, property.getFlags());
    this.GETTER_CACHE = newType != property.getLocalType() ? new MethodHandle[NOOF_TYPES] : property.GETTER_CACHE;
    this.primitiveGetter = property.primitiveGetter;
    this.primitiveSetter = property.primitiveSetter;
    this.objectGetter = property.objectGetter;
    this.objectSetter = property.objectSetter;
    setType(newType);
  }

  /**
   * COPY constructor
   * @param property  source property
   */
  protected AccessorProperty(AccessorProperty property) {
    this(property, property.getLocalType());
  }

  /**
   * Set initial value of a script object's property
   * @param owner        owner
   * @param initialValue initial value
   */
  protected final void setInitialValue(ScriptObject owner, Object initialValue) {
    setType(hasDualFields() ? JSType.unboxedFieldType(initialValue) : Object.class);
    if (initialValue instanceof Integer i) {
      invokeSetter(owner, i.intValue());
    } else if (initialValue instanceof Double d) {
      invokeSetter(owner, d.doubleValue());
    } else {
      invokeSetter(owner, initialValue);
    }
  }

  /**
   * Initialize the type of a property
   */
  protected final void initializeType() {
    setType(!hasDualFields() ? Object.class : null);
  }

  static MethodHandle bindTo(MethodHandle mh, Object receiver) {
    return (mh == null) ? null : MH.dropArguments(MH.bindTo(mh, receiver), 0, Object.class);
  }

  @Override
  public Property copy() {
    return new AccessorProperty(this);
  }

  @Override
  public Property copy(Class<?> newType) {
    return new AccessorProperty(this, newType);
  }

  @Override
  public int getIntValue(ScriptObject self, ScriptObject owner) {
    try {
      return (int) getGetter(int.class).invokeExact((Object) self);
    } catch (Error | RuntimeException e) {
      throw e;
    } catch (Throwable e) {
      throw new RuntimeException(e);
    }
  }

  @Override
  public double getDoubleValue(ScriptObject self, ScriptObject owner) {
    try {
      return (double) getGetter(double.class).invokeExact((Object) self);
    } catch (Error | RuntimeException e) {
      throw e;
    } catch (Throwable e) {
      throw new RuntimeException(e);
    }
  }

  @Override
  public Object getObjectValue(ScriptObject self, ScriptObject owner) {
    try {
      return getGetter(Object.class).invokeExact((Object) self);
    } catch (Error | RuntimeException e) {
      throw e;
    } catch (Throwable e) {
      throw new RuntimeException(e);
    }
  }

  /**
   * Invoke setter for this property with a value
   * @param self  owner
   * @param value value
   */
  protected final void invokeSetter(ScriptObject self, int value) {
    try {
      getSetter(int.class, self.getMap()).invokeExact((Object) self, value);
    } catch (Error | RuntimeException e) {
      throw e;
    } catch (Throwable e) {
      throw new RuntimeException(e);
    }
  }

  /**
   * Invoke setter for this property with a value
   * @param self  owner
   * @param value value
   */
  protected final void invokeSetter(ScriptObject self, double value) {
    try {
      getSetter(double.class, self.getMap()).invokeExact((Object) self, value);
    } catch (Error | RuntimeException e) {
      throw e;
    } catch (Throwable e) {
      throw new RuntimeException(e);
    }
  }

  /**
   * Invoke setter for this property with a value
   * @param self  owner
   * @param value value
   */
  protected final void invokeSetter(ScriptObject self, Object value) {
    try {
      getSetter(Object.class, self.getMap()).invokeExact((Object) self, value);
    } catch (Error | RuntimeException e) {
      throw e;
    } catch (Throwable e) {
      throw new RuntimeException(e);
    }
  }

  @Override
  public void setValue(ScriptObject self, ScriptObject owner, int value) {
    assert isConfigurable() || isWritable() : getKey() + " is not writable or configurable";
    invokeSetter(self, value);
  }

  @Override
  public void setValue(ScriptObject self, ScriptObject owner, double value) {
    assert isConfigurable() || isWritable() : getKey() + " is not writable or configurable";
    invokeSetter(self, value);
  }

  @Override
  public void setValue(ScriptObject self, ScriptObject owner, Object value) {
    //this is sometimes used for bootstrapping, hence no assert. ugly.
    invokeSetter(self, value);
  }

  @Override
  void initMethodHandles(Class<?> structure) {
    // sanity check for structure class
    if (!ScriptObject.class.isAssignableFrom(structure) || !StructureLoader.isStructureClass(structure.getName())) {
      throw new IllegalArgumentException();
    }
    // this method is overridden in SpillProperty
    assert !isSpill();
    initGetterSetter(structure);
  }

  @Override
  public MethodHandle getGetter(Class<?> type) {
    var i = getAccessorTypeIndex(type);
    assert type == int.class || type == double.class || type == Object.class : "invalid getter type " + type + " for " + getKey();
    checkUndeclared();
    // all this does is add a return value filter for object fields only
    var getterCache = GETTER_CACHE;
    var cachedGetter = getterCache[i];
    MethodHandle getter;
    if (cachedGetter != null) {
      getter = cachedGetter;
    } else {
      getter = createGetter(getLocalType(), type, primitiveGetter, objectGetter, INVALID_PROGRAM_POINT);
      getterCache[i] = getter;
    }
    assert getter.type().returnType() == type && getter.type().parameterType(0) == Object.class;
    return getter;
  }

  @Override
  public MethodHandle getOptimisticGetter(Class<?> type, int programPoint) {
    // nasgen generated primitive fields like Math.PI have only one known unchangeable primitive type
    if (objectGetter == null) {
      return getOptimisticPrimitiveGetter(type, programPoint);
    }
    checkUndeclared();
    return createGetter(getLocalType(), type, primitiveGetter, objectGetter, programPoint);
  }

  MethodHandle getOptimisticPrimitiveGetter(Class<?> type, int programPoint) {
    var g = getGetter(getLocalType());
    return MH.asType(OptimisticReturnFilters.filterOptimisticReturnValue(g, type, programPoint), g.type().changeReturnType(type));
  }

  Property getWiderProperty(Class<?> type) {
    return copy(type); // invalidate cache of new property
  }

  PropertyMap getWiderMap(PropertyMap oldMap, Property newProperty) {
    var newMap = oldMap.replaceProperty(this, newProperty);
    assert oldMap.size() > 0;
    assert newMap.size() == oldMap.size();
    return newMap;
  }

  void checkUndeclared() {
    if ((getFlags() & NEEDS_DECLARATION) != 0) {
      // a lexically defined variable that hasn't seen its declaration - throw ReferenceError
      throw ECMAErrors.referenceError("not.defined", getKey().toString());
    }
  }

  // the final three arguments are for debug printout purposes only
  @SuppressWarnings("unused")
  static Object replaceMap(Object sobj, PropertyMap newMap) {
    ((ScriptObject) sobj).setMap(newMap);
    return sobj;
  }

  @SuppressWarnings("unused")
  static Object invalidateSwitchPoint(AccessorProperty property, Object obj) {
    if (!property.builtinSwitchPoint.hasBeenInvalidated()) {
      SwitchPoint.invalidateAll(new SwitchPoint[]{property.builtinSwitchPoint});
    }
    return obj;
  }

  MethodHandle generateSetter(Class<?> forType, Class<?> type) {
    return createSetter(forType, type, primitiveSetter, objectSetter);
  }

  /**
   * Is this property of the undefined type?
   * @return true if undefined
   */
  protected final boolean isUndefined() {
    return getLocalType() == null;
  }

  @Override
  public boolean hasNativeSetter() {
    return objectSetter != null;
  }

  @Override
  public MethodHandle getSetter(Class<?> type, PropertyMap currentMap) {
    checkUndeclared();
    var typeIndex = getAccessorTypeIndex(type);
    var currentTypeIndex = getAccessorTypeIndex(getLocalType());
    //if we are asking for an object setter, but are still a primitive type, we might try to box it
    MethodHandle mh;
    if (needsInvalidator(typeIndex, currentTypeIndex)) {
      var newProperty = getWiderProperty(type);
      var newMap = getWiderMap(currentMap, newProperty);
      var widerSetter = newProperty.getSetter(type, newMap);
      var ct = getLocalType();
      mh = MH.filterArguments(widerSetter, 0, MH.insertArguments(REPLACE_MAP, 1, newMap));
      if (ct != null && ct.isPrimitive() && !type.isPrimitive()) {
        mh = ObjectClassGenerator.createGuardBoxedPrimitiveSetter(ct, generateSetter(ct, ct), mh);
      }
    } else {
      var forType = isUndefined() ? type : getLocalType();
      mh = generateSetter(!forType.isPrimitive() ? Object.class : forType, type);
    }
    if (isBuiltin()) {
      mh = MH.filterArguments(mh, 0, MH.insertArguments(INVALIDATE_SP, 0, this));
    }
    assert mh.type().returnType() == void.class : mh.type();
    return mh;
  }

  @Override
  public final boolean canChangeType() {
    if (!hasDualFields()) {
      return false;
    }
    // Return true for currently undefined even if non-writable/configurable to allow initialization of ES6 CONST.
    return getLocalType() == null || (getLocalType() != Object.class && (isConfigurable() || isWritable()));
  }

  boolean needsInvalidator(int typeIndex, int currentTypeIndex) {
    return canChangeType() && typeIndex > currentTypeIndex;
  }

  private static MethodHandle findOwnMH_S(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(LOOKUP, AccessorProperty.class, name, MH.type(rtype, types));
  }

  private void readObject(ObjectInputStream s) throws IOException, ClassNotFoundException {
    s.defaultReadObject();
    // Restore getters array
    GETTER_CACHE = new MethodHandle[NOOF_TYPES];
  }
  private static final long serialVersionUID = 1;
}
