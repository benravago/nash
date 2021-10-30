package es.runtime;

import static es.lookup.Lookup.MH;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

/**
 * Spill property
 */
public class SpillProperty extends AccessorProperty {

  private static final MethodHandles.Lookup LOOKUP = MethodHandles.lookup();

  private static final MethodHandle PARRAY_GETTER = MH.asType(MH.getter(LOOKUP, ScriptObject.class, "primitiveSpill", long[].class), MH.type(long[].class, Object.class));
  private static final MethodHandle OARRAY_GETTER = MH.asType(MH.getter(LOOKUP, ScriptObject.class, "objectSpill", Object[].class), MH.type(Object[].class, Object.class));

  private static final MethodHandle OBJECT_GETTER = MH.filterArguments(MH.arrayElementGetter(Object[].class), 0, OARRAY_GETTER);
  private static final MethodHandle PRIMITIVE_GETTER = MH.filterArguments(MH.arrayElementGetter(long[].class), 0, PARRAY_GETTER);
  private static final MethodHandle OBJECT_SETTER = MH.filterArguments(MH.arrayElementSetter(Object[].class), 0, OARRAY_GETTER);
  private static final MethodHandle PRIMITIVE_SETTER = MH.filterArguments(MH.arrayElementSetter(long[].class), 0, PARRAY_GETTER);

  static class Accessors {

    private MethodHandle objectGetter;
    private MethodHandle objectSetter;
    private MethodHandle primitiveGetter;
    private MethodHandle primitiveSetter;

    private final int slot;
    private final MethodHandle ensureSpillSize;

    private static Accessors ACCESSOR_CACHE[] = new Accessors[512];

    //private static final Map<Integer, Reference<Accessors>> ACCESSOR_CACHE = Collections.synchronizedMap(new WeakHashMap<Integer, Reference<Accessors>>());
    Accessors(int slot) {
      assert slot >= 0;
      this.slot = slot;
      this.ensureSpillSize = MH.asType(MH.insertArguments(ScriptObject.ENSURE_SPILL_SIZE, 1, slot), MH.type(Object.class, Object.class));
    }

    static void ensure(int slot) {
      var len = ACCESSOR_CACHE.length;
      if (slot >= len) {
        do {
          len *= 2;
        } while (slot >= len);
        var newCache = new Accessors[len];
        System.arraycopy(ACCESSOR_CACHE, 0, newCache, 0, ACCESSOR_CACHE.length);
        ACCESSOR_CACHE = newCache;
      }
    }

    static MethodHandle getCached(int slot, boolean isPrimitive, boolean isGetter) {
      //Reference<Accessors> ref = ACCESSOR_CACHE.get(slot);
      ensure(slot);
      var acc = ACCESSOR_CACHE[slot];
      if (acc == null) {
        acc = new Accessors(slot);
        ACCESSOR_CACHE[slot] = acc;
      }
      return acc.getOrCreate(isPrimitive, isGetter);
    }

    static MethodHandle primordial(boolean isPrimitive, boolean isGetter) {
      return isPrimitive ? (isGetter ? PRIMITIVE_GETTER : PRIMITIVE_SETTER) : (isGetter ? OBJECT_GETTER : OBJECT_SETTER);
    }

    MethodHandle getOrCreate(boolean isPrimitive, boolean isGetter) {
      MethodHandle accessor;
      accessor = getInner(isPrimitive, isGetter);
      if (accessor != null) {
        return accessor;
      }
      accessor = primordial(isPrimitive, isGetter);
      accessor = MH.insertArguments(accessor, 1, slot);
      if (!isGetter) {
        accessor = MH.filterArguments(accessor, 0, ensureSpillSize);
      }
      setInner(isPrimitive, isGetter, accessor);
      return accessor;
    }

    void setInner(boolean isPrimitive, boolean isGetter, MethodHandle mh) {
      if (isPrimitive) {
        if (isGetter) {
          primitiveGetter = mh;
        } else {
          primitiveSetter = mh;
        }
      } else {
        if (isGetter) {
          objectGetter = mh;
        } else {
          objectSetter = mh;
        }
      }
    }

    MethodHandle getInner(boolean isPrimitive, boolean isGetter) {
      return isPrimitive ? (isGetter ? primitiveGetter : primitiveSetter) : (isGetter ? objectGetter : objectSetter);
    }
  }

  static MethodHandle primitiveGetter(int slot, int flags) {
    return (flags & DUAL_FIELDS) == DUAL_FIELDS ? Accessors.getCached(slot, true, true) : null;
  }

  static MethodHandle primitiveSetter(int slot, int flags) {
    return (flags & DUAL_FIELDS) == DUAL_FIELDS ? Accessors.getCached(slot, true, false) : null;
  }

  static MethodHandle objectGetter(int slot) {
    return Accessors.getCached(slot, false, true);
  }

  static MethodHandle objectSetter(int slot) {
    return Accessors.getCached(slot, false, false);
  }

  /**
   * Constructor for spill properties. Array getters and setters will be created on demand.
   * @param key    the property key
   * @param flags  the property flags
   * @param slot   spill slot
   */
  public SpillProperty(Object key, int flags, int slot) {
    super(key, flags, slot, primitiveGetter(slot, flags), primitiveSetter(slot, flags), objectGetter(slot), objectSetter(slot));
  }

  /**
   * Constructor for spill properties with an initial type.
   * @param key         the property key
   * @param flags       the property flags
   * @param slot        spill slot
   * @param initialType initial type
   */
  public SpillProperty(String key, int flags, int slot, Class<?> initialType) {
    this(key, flags, slot);
    setType(hasDualFields() ? initialType : Object.class);
  }

  SpillProperty(Object key, int flags, int slot, ScriptObject owner, Object initialValue) {
    this(key, flags, slot);
    setInitialValue(owner, initialValue);
  }

  /**
   * Copy constructor
   * @param property other property
   */
  protected SpillProperty(SpillProperty property) {
    super(property);
  }

  /**
   * Copy constructor
   * @param newType new type
   * @param property other property
   */
  protected SpillProperty(SpillProperty property, Class<?> newType) {
    super(property, newType);
  }

  @Override
  public Property copy() {
    return new SpillProperty(this);
  }

  @Override
  public Property copy(Class<?> newType) {
    return new SpillProperty(this, newType);
  }

  @Override
  public boolean isSpill() {
    return true;
  }

  @Override
  void initMethodHandles(Class<?> structure) {
    var slot = getSlot();
    primitiveGetter = primitiveGetter(slot, getFlags());
    primitiveSetter = primitiveSetter(slot, getFlags());
    objectGetter = objectGetter(slot);
    objectSetter = objectSetter(slot);
  }
  
  private static final long serialVersionUID = 1;
}
