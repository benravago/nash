package es.runtime;

import java.io.Serializable;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.ref.WeakReference;

import es.codegen.Compiler;
import es.codegen.CompilerConstants;
import es.codegen.ObjectClassGenerator;
import static es.lookup.Lookup.MH;

/**
 * Encapsulates the allocation strategy for a function when used as a constructor.
 */
final public class AllocationStrategy implements Serializable {

  private static final MethodHandles.Lookup LOOKUP = MethodHandles.lookup();

  // Number of fields in the allocated object
  private final int fieldCount;

  // Whether to use dual field representation
  private final boolean dualFields;

  // Name of class where allocator function resides
  private transient String allocatorClassName;

  // lazily generated allocator
  private transient MethodHandle allocator;

  // Last used allocator map
  private transient AllocatorMap lastMap;

  /**
   * Construct an allocation strategy with the given map and class name.
   * @param fieldCount number of fields in the allocated object
   * @param dualFields whether to use dual field representation
   */
  public AllocationStrategy(int fieldCount, boolean dualFields) {
    this.fieldCount = fieldCount;
    this.dualFields = dualFields;
  }

  String getAllocatorClassName() {
    if (allocatorClassName == null) {
      // These classes get loaded, so an interned variant of their name is most likely around anyway.
      allocatorClassName = Compiler.binaryName(ObjectClassGenerator.getClassName(fieldCount, dualFields)).intern();
    }
    return allocatorClassName;
  }

  /**
   * Get the property map for the allocated object.
   * @param prototype the prototype object
   * @return the property map
   */
  synchronized PropertyMap getAllocatorMap(ScriptObject prototype) {
    assert prototype != null;
    var protoMap = prototype.getMap();
    if (lastMap != null) {
      if (!lastMap.hasSharedProtoMap()) {
        if (lastMap.hasSamePrototype(prototype)) {
          return lastMap.allocatorMap;
        }
        if (lastMap.hasSameProtoMap(protoMap) && lastMap.hasUnchangedProtoMap()) {
          // Convert to shared prototype map.
          // Allocated objects will use the same property map that can be used as long as none of the prototypes modify the shared proto map.
          var allocatorMap = PropertyMap.newMap(null, getAllocatorClassName(), 0, fieldCount, 0);
          var sharedProtoMap = new SharedPropertyMap(protoMap);
          allocatorMap.setSharedProtoMap(sharedProtoMap);
          prototype.setMap(sharedProtoMap);
          lastMap = new AllocatorMap(prototype, protoMap, allocatorMap);
          return allocatorMap;
        }
      }
      if (lastMap.hasValidSharedProtoMap() && lastMap.hasSameProtoMap(protoMap)) {
        prototype.setMap(lastMap.getSharedProtoMap());
        return lastMap.allocatorMap;
      }
    }
    var allocatorMap = PropertyMap.newMap(null, getAllocatorClassName(), 0, fieldCount, 0);
    lastMap = new AllocatorMap(prototype, protoMap, allocatorMap);
    return allocatorMap;
  }

  /**
   * Allocate an object with the given property map
   * @param map the property map
   * @return the allocated object
   */
  ScriptObject allocate(PropertyMap map) {
    try {
      if (allocator == null) {
        allocator = MH.findStatic(LOOKUP, Context.forStructureClass(getAllocatorClassName()), CompilerConstants.ALLOCATE.symbolName(), MH.type(ScriptObject.class, PropertyMap.class));
      }
      return (ScriptObject) allocator.invokeExact(map);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  @Override
  public String toString() {
    return "AllocationStrategy[fieldCount=" + fieldCount + "]";
  }

  static class AllocatorMap {

    final private WeakReference<ScriptObject> prototype;
    final private WeakReference<PropertyMap> prototypeMap;

    private final PropertyMap allocatorMap;

    AllocatorMap(ScriptObject prototype, PropertyMap protoMap, PropertyMap allocMap) {
      this.prototype = new WeakReference<>(prototype);
      this.prototypeMap = new WeakReference<>(protoMap);
      this.allocatorMap = allocMap;
    }

    boolean hasSamePrototype(ScriptObject proto) {
      return prototype.get() == proto;
    }

    boolean hasSameProtoMap(PropertyMap protoMap) {
      return prototypeMap.get() == protoMap || allocatorMap.getSharedProtoMap() == protoMap;
    }

    boolean hasUnchangedProtoMap() {
      var proto = prototype.get();
      return proto != null && proto.getMap() == prototypeMap.get();
    }

    boolean hasSharedProtoMap() {
      return getSharedProtoMap() != null;
    }

    boolean hasValidSharedProtoMap() {
      return hasSharedProtoMap() && getSharedProtoMap().isValidSharedProtoMap();
    }

    PropertyMap getSharedProtoMap() {
      return allocatorMap.getSharedProtoMap();
    }
  }

  private static final long serialVersionUID = 1;
}
