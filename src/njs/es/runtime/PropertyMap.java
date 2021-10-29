package es.runtime;

import java.util.Arrays;
import java.util.BitSet;
import java.util.Collection;
import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.Set;
import java.util.WeakHashMap;
import java.util.concurrent.atomic.LongAdder;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

import java.lang.invoke.SwitchPoint;
import java.lang.ref.Reference;
import java.lang.ref.SoftReference;
import java.lang.ref.WeakReference;

import es.runtime.options.Options;
import es.scripts.JO;
import es.util.Hex;
import static es.runtime.PropertyHashMap.EMPTY_HASHMAP;
import static es.runtime.arrays.ArrayIndex.getArrayIndex;
import static es.runtime.arrays.ArrayIndex.isValidArrayIndex;

/**
 * Map of object properties.
 *
 * The PropertyMap is the "template" for JavaScript object layouts.
 * It contains a map with prototype names as keys and {@link Property} instances as values.
 * A PropertyMap is typically passed to the {@link ScriptObject} constructor to form the seed map for the ScriptObject.
 * <p>
 * All property maps are immutable. If a property is added, modified or removed, the mutator will return a new map.
 */
public class PropertyMap implements Iterable<Object>, Serializable {

  private static final int INITIAL_SOFT_REFERENCE_DERIVATION_LIMIT = Math.max(0, Options.getIntProperty("nashorn.propertyMap.softReferenceDerivationLimit", 32));

  // Used for non extensible PropertyMaps, negative logic as the normal case is extensible. See {@link ScriptObject#preventExtensions()}
  private static final int NOT_EXTENSIBLE = 0b0000_0001;

  // Does this map contain valid array keys?
  private static final int CONTAINS_ARRAY_KEYS = 0b0000_0010;

  // Map status flags.
  private final int flags;

  // Map of properties.
  private transient PropertyHashMap properties;

  // Number of fields in use.
  private final int fieldCount;

  // Number of fields available.
  private final int fieldMaximum;

  // Length of spill in use.
  private final int spillLength;

  // Structure class name
  private final String className;

  // Countdown of number of times this property map has been derived from another property map.
  // When it reaches zero, the property map will start using weak references instead of soft references to hold on to its history elements.
  private final int softReferenceDerivationLimit;

  // A reference to the expected shared prototype property map.
  // If this is set this property map should only be used if it the same as the actual prototype map.
  private transient SharedPropertyMap sharedProtoMap;

  // History of maps, used to limit map duplication.
  private transient WeakHashMap<Property, Reference<PropertyMap>> history;

  // History of prototypes, used to limit map duplication.
  private transient WeakHashMap<ScriptObject, SoftReference<PropertyMap>> protoHistory;

  // SwitchPoints for properties inherited form this map
  private transient PropertySwitchPoints propertySwitchPoints;

  private transient BitSet freeSlots;

  private static final long serialVersionUID = -7041836752008732533L;

  /**
   * Constructs a new property map.
   *
   * @param properties   A {@link PropertyHashMap} with initial contents.
   * @param fieldCount   Number of fields in use.
   * @param fieldMaximum Number of fields available.
   * @param spillLength  Number of spill slots used.
   */
  PropertyMap(PropertyHashMap properties, int flags, String className, int fieldCount, int fieldMaximum, int spillLength) {
    this.properties = properties;
    this.className = className;
    this.fieldCount = fieldCount;
    this.fieldMaximum = fieldMaximum;
    this.spillLength = spillLength;
    this.flags = flags;
    this.softReferenceDerivationLimit = INITIAL_SOFT_REFERENCE_DERIVATION_LIMIT;
  }

  /**
   * Constructs a clone of {@code propertyMap} with changed properties, flags, or boundaries.
   * @param propertyMap Existing property map.
   * @param properties  A {@link PropertyHashMap} with a new set of properties.
   */
  PropertyMap(PropertyMap propertyMap, PropertyHashMap properties, int flags, int fieldCount, int spillLength, int softReferenceDerivationLimit) {
    this.properties = properties;
    this.flags = flags;
    this.spillLength = spillLength;
    this.fieldCount = fieldCount;
    this.fieldMaximum = propertyMap.fieldMaximum;
    this.className = propertyMap.className;
    // We inherit the parent property propertySwitchPoints instance. It will be cloned when a new listener is added.
    this.propertySwitchPoints = propertyMap.propertySwitchPoints;
    this.freeSlots = propertyMap.freeSlots;
    this.sharedProtoMap = propertyMap.sharedProtoMap;
    this.softReferenceDerivationLimit = softReferenceDerivationLimit;
  }

  /**
   * Constructs an exact clone of {@code propertyMap}.
   * @param propertyMap Existing property map.
   */
  protected PropertyMap(PropertyMap propertyMap) {
    this(propertyMap, propertyMap.properties, propertyMap.flags, propertyMap.fieldCount, propertyMap.spillLength, propertyMap.softReferenceDerivationLimit);
  }

  void writeObject(ObjectOutputStream out) throws IOException {
    out.defaultWriteObject();
    out.writeObject(properties.getProperties());
  }

  void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException {
    in.defaultReadObject();
    var props = (Property[]) in.readObject();
    this.properties = EMPTY_HASHMAP.immutableAdd(props);
    assert className != null;
    var structure = Context.forStructureClass(className);
    for (var prop : props) {
      prop.initMethodHandles(structure);
    }
  }

  /**
   * Public property map allocator.
   * <p>
   * It is the caller's responsibility to make sure that {@code properties} does not contain properties with keys that are valid array indices.</p>
   * @param properties   Collection of initial properties.
   * @param className    class name
   * @param fieldCount   Number of fields in use.
   * @param fieldMaximum Number of fields available.
   * @param spillLength  Number of used spill slots.
   * @return New {@link PropertyMap}.
   */
  public static PropertyMap newMap(Collection<Property> properties, String className, int fieldCount, int fieldMaximum, int spillLength) {
    var newProperties = EMPTY_HASHMAP.immutableAdd(properties);
    return new PropertyMap(newProperties, 0, className, fieldCount, fieldMaximum, spillLength);
  }

  /**
   * Public property map allocator; used by nasgen generated code.
   * It is the caller's responsibility to make sure that {@code properties} does not contain properties with keys that are valid array indices.
   * @param properties Collection of initial properties.
   * @return New {@link PropertyMap}.
   */
  public static PropertyMap newMap(Collection<Property> properties) {
    return properties == null || properties.isEmpty() ? newMap() : newMap(properties, JO.class.getName(), 0, 0, 0);
  }

  /**
   * Return a sharable empty map for the given object class.
   * @param type the base object class
   * @return New empty {@link PropertyMap}.
   */
  public static PropertyMap newMap(Class<? extends ScriptObject> type) {
    return new PropertyMap(EMPTY_HASHMAP, 0, type.getName(), 0, 0, 0);
  }

  /**
   * Return a sharable empty map.
   * @return New empty {@link PropertyMap}.
   */
  public static PropertyMap newMap() {
    return newMap(JO.class);
  }

  /**
   * Return number of properties in the map.
   * @return Number of properties.
   */
  public int size() {
    return properties.size();
  }

  /**
   * Get the number of property SwitchPoints of this map
   * @return the number of property SwitchPoints
   */
  public int getSwitchPointCount() {
    return propertySwitchPoints == null ? 0 : propertySwitchPoints.getSwitchPointCount();
  }

  /**
   * Add a property switchpoint to this property map for the given {@code key}.
   * @param key the property name
   * @param switchPoint the switchpoint
   */
  public void addSwitchPoint(String key, SwitchPoint switchPoint) {
    // We need to clone listener instance when adding a new listener since we share the propertySwitchPoints instance with our parent maps that don't need to see the new listener.
    propertySwitchPoints = PropertySwitchPoints.addSwitchPoint(propertySwitchPoints, key, switchPoint);
  }

  /**
   * Method called when a property of an object using this property map is being created, modified, or deleted. If a switchpoint for the property exists it will be invalidated.
   * @param property The changed property.
   */
  public void propertyChanged(Property property) {
    if (propertySwitchPoints != null) {
      propertySwitchPoints.invalidateProperty(property);
    }
  }

  /**
   * Method called when the prototype of an object using this property map is changed.
   */
  void protoChanged() {
    if (sharedProtoMap != null) {
      sharedProtoMap.invalidateSwitchPoint();
    }
    if (propertySwitchPoints != null) {
      propertySwitchPoints.invalidateInheritedProperties(this);
    }
  }

  /**
   * Returns a SwitchPoint for use with a property inherited from this or a parent map.
   * If such a switchpoint exists, it will be invalidated when the property is modified in an object using this map. This method returns {@code null} if no swichpoint exists for the property.
   * @param key Property key.
   * @return A {@link SwitchPoint} for the property, or null.
   */
  public synchronized SwitchPoint getSwitchPoint(String key) {
    if (propertySwitchPoints != null) {
      var existingSwitchPoints = propertySwitchPoints.getSwitchPoints(key);
      for (var switchPoint : existingSwitchPoints) {
        if (switchPoint != null && !switchPoint.hasBeenInvalidated()) {
          return switchPoint;
        }
      }
    }
    return null;
  }

  /**
   * Add a property to the map, re-binding its getters and setters,
   * if available, to a given receiver.
   * This is typically the global scope.
   * See {@link ScriptObject#addBoundProperties(ScriptObject)}
   * @param property {@link Property} being added.
   * @param bindTo   Object to bind to.
   * @return New {@link PropertyMap} with {@link Property} added.
   */
  PropertyMap addPropertyBind(AccessorProperty property, Object bindTo) {
    // We must not store bound property in the history as bound properties can't be reused.
    return addPropertyNoHistory(new AccessorProperty(property, bindTo));
  }

  // Get a logical slot index for a property, with spill slot 0 starting at fieldMaximum.
  int logicalSlotIndex(Property property) {
    var slot = property.getSlot();
    return (slot < 0) ? -1 : property.isSpill() ? slot + fieldMaximum : slot;
  }

  int newSpillLength(Property newProperty) {
    return newProperty.isSpill() ? Math.max(spillLength, newProperty.getSlot() + 1) : spillLength;
  }

  int newFieldCount(Property newProperty) {
    return newProperty.isSpill() ? fieldCount : Math.max(fieldCount, newProperty.getSlot() + 1);
  }

  int newFlags(Property newProperty) {
    return isValidArrayIndex(getArrayIndex(newProperty.getKey())) ? flags | CONTAINS_ARRAY_KEYS : flags;
  }

  // Update the free slots bitmap for a property that has been deleted and/or added.
  // This method is not synchronized as it is always invoked on a newly created instance.
  private void updateFreeSlots(Property oldProperty, Property newProperty) {
    // Free slots bitset is possibly shared with parent map, so we must clone it before making modifications.
    var freeSlotsCloned = false;
    if (oldProperty != null) {
      var slotIndex = logicalSlotIndex(oldProperty);
      if (slotIndex >= 0) {
        var newFreeSlots = freeSlots == null ? new BitSet() : (BitSet) freeSlots.clone();
        assert !newFreeSlots.get(slotIndex);
        newFreeSlots.set(slotIndex);
        freeSlots = newFreeSlots;
        freeSlotsCloned = true;
      }
    }
    if (freeSlots != null && newProperty != null) {
      var slotIndex = logicalSlotIndex(newProperty);
      if (slotIndex > -1 && freeSlots.get(slotIndex)) {
        var newFreeSlots = freeSlotsCloned ? freeSlots : ((BitSet) freeSlots.clone());
        newFreeSlots.clear(slotIndex);
        freeSlots = newFreeSlots.isEmpty() ? null : newFreeSlots;
      }
    }
  }

  /**
   * Add a property to the map without adding it to the history.
   * This should be used for properties that can't be shared such as bound properties, or properties that are expected to be added only once.
   * @param property {@link Property} being added.
   * @return New {@link PropertyMap} with {@link Property} added.
   */
  public final PropertyMap addPropertyNoHistory(Property property) {
    propertyChanged(property);
    return addPropertyInternal(property);
  }

  /**
   * Add a property to the map.
   * Cloning or using an existing map if available.
   * @param property {@link Property} being added.
   * @return New {@link PropertyMap} with {@link Property} added.
   */
  public final synchronized PropertyMap addProperty(Property property) {
    propertyChanged(property);
    var newMap = checkHistory(property);
    if (newMap == null) {
      newMap = addPropertyInternal(property);
      addToHistory(property, newMap);
    }
    return newMap;
  }

  PropertyMap deriveMap(PropertyHashMap newProperties, int newFlags, int newFieldCount, int newSpillLength) {
    return new PropertyMap(this, newProperties, newFlags, newFieldCount, newSpillLength, softReferenceDerivationLimit == 0 ? 0 : softReferenceDerivationLimit - 1);
  }

  PropertyMap addPropertyInternal(Property property) {
    var newProperties = properties.immutableAdd(property);
    var newMap = deriveMap(newProperties, newFlags(property), newFieldCount(property), newSpillLength(property));
    newMap.updateFreeSlots(null, property);
    return newMap;
  }

  /**
   * Remove a property from a map. Cloning or using an existing map if available.
   * @param property {@link Property} being removed.
   * @return New {@link PropertyMap} with {@link Property} removed or {@code null} if not found.
   */
  public final synchronized PropertyMap deleteProperty(Property property) {
    propertyChanged(property);
    var newMap = checkHistory(property);
    var key = property.getKey();
    if (newMap == null && properties.containsKey(key)) {
      var newProperties = properties.immutableRemove(key);
      var isSpill = property.isSpill();
      var slot = property.getSlot();
      // If deleted property was last field or spill slot we can make it reusable by reducing field/slot count.
      // Otherwise mark it as free in free slots bitset.
      if (isSpill && slot >= 0 && slot == spillLength - 1) {
        newMap = deriveMap(newProperties, flags, fieldCount, spillLength - 1);
        newMap.freeSlots = freeSlots;
      } else if (!isSpill && slot >= 0 && slot == fieldCount - 1) {
        newMap = deriveMap(newProperties, flags, fieldCount - 1, spillLength);
        newMap.freeSlots = freeSlots;
      } else {
        newMap = deriveMap(newProperties, flags, fieldCount, spillLength);
        newMap.updateFreeSlots(property, null);
      }
      addToHistory(property, newMap);
    }
    return newMap;
  }

  /**
   * Replace an existing property with a new one.
   * @param oldProperty Property to replace.
   * @param newProperty New {@link Property}.
   * @return New {@link PropertyMap} with {@link Property} replaced.
   */
  public final PropertyMap replaceProperty(Property oldProperty, Property newProperty) {
    propertyChanged(oldProperty);
    // See ScriptObject.modifyProperty and ScriptObject.setUserAccessors methods.
    // This replaceProperty method is called only for the following three cases:
    //   1. To change flags OR TYPE of an old (cloned) property. We use the same spill slots.
    //   2. To change one UserAccessor property with another - user getter or setter changed via Object.defineProperty function. Again, same spill slots are re-used.
    //   3. Via ScriptObject.setUserAccessors method to set user getter and setter functions replacing the dummy AccessorProperty with null method handles (added during map init).
    // In case (1) and case(2), the property type of old and new property is same.
    // For case (3),the old property is an AccessorProperty and the new one is a UserAccessorProperty property.
    var sameType = oldProperty.getClass() == newProperty.getClass();
    assert sameType || oldProperty instanceof AccessorProperty && newProperty instanceof UserAccessorProperty
      : "arbitrary replaceProperty attempted " + sameType + " oldProperty=" + oldProperty.getClass() + " newProperty=" + newProperty.getClass() + " [" + oldProperty.getLocalType() + " => " + newProperty.getLocalType() + "]";
    // spillLength remains same in case (1) and (2) because of slot reuse.
    // Only for case (3), we need to add spill count of the newly added UserAccessorProperty property.
    var newSpillLength = sameType ? spillLength : Math.max(spillLength, newProperty.getSlot() + 1);
    // Add replaces existing property.
    var newProperties = properties.immutableReplace(oldProperty, newProperty);
    var newMap = deriveMap(newProperties, flags, fieldCount, newSpillLength);
    if (!sameType) {
      newMap.updateFreeSlots(oldProperty, newProperty);
    }
    return newMap;
  }

  /**
   * Make a new UserAccessorProperty property.
   * getter and setter functions are stored in this ScriptObject and slot values are used in property object.
   * Note that slots are assigned speculatively and should be added to map before adding other properties.
   * @param key the property name
   * @param propertyFlags attribute flags of the property
   * @return the newly created UserAccessorProperty
   */
  public final UserAccessorProperty newUserAccessors(Object key, int propertyFlags) {
    return new UserAccessorProperty(key, propertyFlags, getFreeSpillSlot());
  }

  /**
   * Find a property in the map.
   * @param key Key to search for.
   * @return {@link Property} matching key.
   */
  public final Property findProperty(Object key) {
    return properties.find(key);
  }

  /**
   * Adds all map properties from another map.
   * @param other The source of properties.
   * @return New {@link PropertyMap} with added properties.
   */
  public final PropertyMap addAll(PropertyMap other) {
    assert this != other : "adding property map to itself";
    var otherProperties = other.properties.getProperties();
    var newProperties = properties.immutableAdd(otherProperties);
    var newMap = deriveMap(newProperties, flags, fieldCount, spillLength);
    for (var property : otherProperties) {
      // This method is only safe to use with non-slotted, native getter/setter properties
      assert property.getSlot() == -1;
      assert !(isValidArrayIndex(getArrayIndex(property.getKey())));
    }
    return newMap;
  }

  /**
   * Return an array of all properties.
   * @return Properties as an array.
   */
  public final Property[] getProperties() {
    return properties.getProperties();
  }

  /**
   * Return the name of the class of objects using this property map.
   * @return class name of owner objects.
   */
  public final String getClassName() {
    return className;
  }

  /**
   * Prevents the map from having additional properties.
   * @return New map with {@link #NOT_EXTENSIBLE} flag set.
   */
  PropertyMap preventExtensions() {
    return deriveMap(properties, flags | NOT_EXTENSIBLE, fieldCount, spillLength);
  }

  /**
   * Prevents properties in map from being modified.
   * @return New map with {@link #NOT_EXTENSIBLE} flag set and properties with
   * {@link Property#NOT_CONFIGURABLE} set.
   */
  PropertyMap seal() {
    var newProperties = EMPTY_HASHMAP;
    for (var oldProperty : properties.getProperties()) {
      newProperties = newProperties.immutableAdd(oldProperty.addFlags(Property.NOT_CONFIGURABLE));
    }
    return deriveMap(newProperties, flags | NOT_EXTENSIBLE, fieldCount, spillLength);
  }

  /**
   * Prevents properties in map from being modified or written to.
   * @return New map with {@link #NOT_EXTENSIBLE} flag set and properties with
   * {@link Property#NOT_CONFIGURABLE} and {@link Property#NOT_WRITABLE} set.
   */
  PropertyMap freeze() {
    var newProperties = EMPTY_HASHMAP;
    for (var oldProperty : properties.getProperties()) {
      var propertyFlags = Property.NOT_CONFIGURABLE;
      if (!(oldProperty instanceof UserAccessorProperty)) {
        propertyFlags |= Property.NOT_WRITABLE;
      }
      newProperties = newProperties.immutableAdd(oldProperty.addFlags(propertyFlags));
    }
    return deriveMap(newProperties, flags | NOT_EXTENSIBLE, fieldCount, spillLength);
  }

  /**
   * Check for any configurable properties.
   * @return {@code true} if any configurable.
   */
  boolean anyConfigurable() {
    for (var property : properties.getProperties()) {
      if (property.isConfigurable()) {
        return true;
      }
    }
    return false;
  }

  /**
   * Check if all properties are frozen.
   * @return {@code true} if all are frozen.
   */
  boolean allFrozen() {
    for (Property property : properties.getProperties()) {
      // check if it is a data descriptor
      if (!property.isAccessorProperty() && property.isWritable()) {
        return false;
      }
      if (property.isConfigurable()) {
        return false;
      }
    }
    return true;
  }

  /**
   * Check prototype history for an existing property map with specified prototype.
   * @param proto New prototype object.
   * @return Existing {@link PropertyMap} or {@code null} if not found.
   */
  PropertyMap checkProtoHistory(ScriptObject proto) {
    PropertyMap cachedMap;
    if (protoHistory != null) {
      var weakMap = protoHistory.get(proto);
      cachedMap = (weakMap != null ? weakMap.get() : null);
    } else {
      cachedMap = null;
    }
    return cachedMap;
  }

  /**
   * Add a map to the prototype history.
   * @param newProto Prototype to add (key.)
   * @param newMap   {@link PropertyMap} associated with prototype.
   */
  void addToProtoHistory(ScriptObject newProto, PropertyMap newMap) {
    if (protoHistory == null) {
      protoHistory = new WeakHashMap<>();
    }
    protoHistory.put(newProto, new SoftReference<>(newMap));
  }

  /**
   * Track the modification of the map.
   * @param property Mapping property.
   * @param newMap   Modified {@link PropertyMap}.
   */
  void addToHistory(Property property, PropertyMap newMap) {
    if (history == null) {
      history = new WeakHashMap<>();
    }
    history.put(property, softReferenceDerivationLimit == 0 ? new WeakReference<>(newMap) : new SoftReference<>(newMap));
  }

  /**
   * Check the history for a map that already has the given property added.
   * @param property {@link Property} to add.
   * @return Existing map or {@code null} if not found.
   */
  PropertyMap checkHistory(Property property) {
    if (history != null) {
      var ref = history.get(property);
      var historicMap = ref == null ? null : ref.get();
      if (historicMap != null) {
        return historicMap;
      }
    }
    return null;
  }

  /**
   * Returns true if the two maps have identical properties in the same order, but allows the properties to differ in their types.
   * This method is mostly useful for tests.
   * @param otherMap the other map
   * @return true if this map has identical properties in the same order as the other map, allowing the properties to differ in type.
   */
  public boolean equalsWithoutType(PropertyMap otherMap) {
    if (properties.size() != otherMap.properties.size()) {
      return false;
    }
    var iter = properties.values().iterator();
    var otherIter = otherMap.properties.values().iterator();
    while (iter.hasNext() && otherIter.hasNext()) {
      if (!iter.next().equalsWithoutType(otherIter.next())) {
        return false;
      }
    }
    return true;
  }

  @Override
  public String toString() {
    var sb = new StringBuilder();
    sb.append(Hex.id(this));
    sb.append(" = {\n");
    for (var property : getProperties()) {
      sb.append('\t');
      sb.append(property);
      sb.append('\n');
    }
    sb.append('}');
    return sb.toString();
  }

  @Override
  public Iterator<Object> iterator() {
    return new PropertyMapIterator(this);
  }

  /**
   * Check if this map contains properties with valid array keys
   * @return {@code true} if this map contains properties with valid array keys
   */
  public final boolean containsArrayKeys() {
    return (flags & CONTAINS_ARRAY_KEYS) != 0;
  }

  /**
   * Test to see if {@link PropertyMap} is extensible.
   * @return {@code true} if {@link PropertyMap} can be added to.
   */
  boolean isExtensible() {
    return (flags & NOT_EXTENSIBLE) == 0;
  }

  /**
   * Test to see if {@link PropertyMap} is not extensible or any properties can not be modified.
   * @return {@code true} if {@link PropertyMap} is sealed.
   */
  boolean isSealed() {
    return !isExtensible() && !anyConfigurable();
  }

  /**
   * Test to see if {@link PropertyMap} is not extensible or all properties can not be modified.
   * @return {@code true} if {@link PropertyMap} is frozen.
   */
  boolean isFrozen() {
    return !isExtensible() && allFrozen();
  }

  /**
   * Return a free field slot for this map, or {@code -1} if none is available.
   * @return free field slot or -1
   */
  int getFreeFieldSlot() {
    if (freeSlots != null) {
      var freeSlot = freeSlots.nextSetBit(0);
      if (freeSlot > -1 && freeSlot < fieldMaximum) {
        return freeSlot;
      }
    }
    if (fieldCount < fieldMaximum) {
      return fieldCount;
    }
    return -1;
  }

  /**
   * Get a free spill slot for this map.
   * @return free spill slot
   */
  int getFreeSpillSlot() {
    if (freeSlots != null) {
      var freeSlot = freeSlots.nextSetBit(fieldMaximum);
      if (freeSlot > -1) {
        return freeSlot - fieldMaximum;
      }
    }
    return spillLength;
  }

  /**
   * Return a property map with the same layout that is associated with the new prototype object.
   * @param newProto New prototype object to replace oldProto.
   * @return New {@link PropertyMap} with prototype changed.
   */
  public synchronized PropertyMap changeProto(ScriptObject newProto) {
    var nextMap = checkProtoHistory(newProto);
    if (nextMap != null) {
      return nextMap;
    }
    var newMap = makeUnsharedCopy();
    addToProtoHistory(newProto, newMap);
    return newMap;
  }

  /**
   * Make a copy of this property map with the shared prototype field set to null.
   * Note that this is only necessary for shared maps of top-level objects.
   * Shared prototype maps represented by {@link SharedPropertyMap} are automatically converted to plain property maps when they evolve.
   * @return a copy with the shared proto map unset
   */
  PropertyMap makeUnsharedCopy() {
    var newMap = new PropertyMap(this);
    newMap.sharedProtoMap = null;
    return newMap;
  }

  /**
   * Set a reference to the expected parent prototype map.
   * This is used for class-like structures where we only want to use a top-level property map if all of the prototype property maps have not been modified.
   * @param protoMap weak reference to the prototype property map
   */
  void setSharedProtoMap(SharedPropertyMap protoMap) {
    sharedProtoMap = protoMap;
  }

  /**
   * Get the expected prototype property map if it is known, or null.
   * @return parent map or null
   */
  public PropertyMap getSharedProtoMap() {
    return sharedProtoMap;
  }

  /**
   * Returns {@code true} if this map has been used as a shared prototype map (i.e. as a prototype for a JavaScript constructor function) and has not had properties added, deleted or replaced since then.
   * @return true if this is a valid shared prototype map
   */
  boolean isValidSharedProtoMap() {
    return false;
  }

  /**
   * Returns the shared prototype switch point, or null if this is not a shared prototype map.
   * @return the shared prototype switch point, or null
   */
  SwitchPoint getSharedProtoSwitchPoint() {
    return null;
  }

  /**
   * Return true if this map has a shared prototype map which has either been invalidated or does not match the map of {@code proto}.
   * @param prototype the prototype object
   * @return true if this is an invalid shared map for {@code prototype}
   */
  boolean isInvalidSharedMapFor(ScriptObject prototype) {
    return sharedProtoMap != null && (!sharedProtoMap.isValidSharedProtoMap() || prototype == null || sharedProtoMap != prototype.getMap());
  }

  /**
   * {@link PropertyMap} iterator.
   */
  static class PropertyMapIterator implements Iterator<Object> {

    // Property iterator.
    final Iterator<Property> iter;

    // Current Property.
    Property property;

    /**
     * Constructor.
     *
     * @param propertyMap {@link PropertyMap} to iterate over.
     */
    PropertyMapIterator(PropertyMap propertyMap) {
      iter = Arrays.asList(propertyMap.properties.getProperties()).iterator();
      property = iter.hasNext() ? iter.next() : null;
      skipNotEnumerable();
    }

    /**
     * Ignore properties that are not enumerable.
     */
    void skipNotEnumerable() {
      while (property != null && !property.isEnumerable()) {
        property = iter.hasNext() ? iter.next() : null;
      }
    }

    @Override
    public boolean hasNext() {
      return property != null;
    }

    @Override
    public Object next() {
      if (property == null) {
        throw new NoSuchElementException();
      }
      var key = property.getKey();
      property = iter.hasNext() ? iter.next() : null;
      skipNotEnumerable();
      return key;
    }

    @Override
    public void remove() {
      throw new UnsupportedOperationException("remove");
    }
  }


  // Debugging and statistics.

  /**
   * Debug helper function that returns the diff of two property maps, only displaying the information that is different and in which map it exists compared to the other map.
   * Can be used to e.g. debug map guards and investigate why they fail, causing relink
   * @param map0 the first property map
   * @param map1 the second property map
   * @return property map diff as string
   */
  public static String diff(PropertyMap map0, PropertyMap map1) {
    var sb = new StringBuilder();
    if (map0 != map1) {
      sb.append(">>> START: Map diff");
      boolean found = false;
      for (var p : map0.getProperties()) {
        var p2 = map1.findProperty(p.getKey());
        if (p2 == null) {
          sb.append("FIRST ONLY : [").append(p).append("]");
          found = true;
        } else if (p2 != p) {
          sb.append("DIFFERENT  : [").append(p).append("] != [").append(p2).append("]");
          found = true;
        }
      }
      for (var p2 : map1.getProperties()) {
        var p1 = map0.findProperty(p2.getKey());
        if (p1 == null) {
          sb.append("SECOND ONLY: [").append(p2).append("]");
          found = true;
        }
      }
      // assert found;
      if (!found) {
        sb.append(map0).append("!=").append(map1);
      }
      sb.append("<<< END: Map diff\n");
    }
    return sb.toString();
  }

}
