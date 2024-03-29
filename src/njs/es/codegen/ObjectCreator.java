package es.codegen;

import java.util.List;

import es.codegen.types.Type;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import static es.codegen.CompilerConstants.SCOPE;

/**
 * Base class for object creation code generation.
 * @param <T> value type
 */
public abstract class ObjectCreator<T> implements CodeGenerator.SplitLiteralCreator {

  // List of keys & symbols to initiate in this ObjectCreator
  final List<MapTuple<T>> tuples;

  // Code generator
  final CodeGenerator codegen;

  // Property map
  protected PropertyMap propertyMap;

  private final boolean isScope;
  private final boolean hasArguments;

  /**
   * Constructor
   *
   * @param codegen      the code generator
   * @param tuples       key,symbol,value (optional) tuples
   * @param isScope      is this object scope
   * @param hasArguments does the created object have an "arguments" property
   */
  ObjectCreator(CodeGenerator codegen, List<MapTuple<T>> tuples, boolean isScope, boolean hasArguments) {
    this.codegen = codegen;
    this.tuples = tuples;
    this.isScope = isScope;
    this.hasArguments = hasArguments;
  }

  /**
   * Generate code for making the object.
   * @param method Script method.
   */
  public void makeObject(MethodEmitter method) {
    createObject(method);
    // We need to store the object in a temporary slot as populateRange expects to load the object from a slot (as it is also invoked within split methods).
    // Note that this also helps optimistic continuations to handle the stack in case an optimistic assumption fails during initialization (see JDK-8079269).
    var objectSlot = method.getUsedSlotsWithLiveTemporaries();
    var objectType = method.peekType();
    method.storeTemp(objectType, objectSlot);
    populateRange(method, objectType, objectSlot, 0, tuples.size());
  }

  /**
   * Generate code for creating and initializing the object.
   * @param method the method emitter
   */
  protected abstract void createObject(MethodEmitter method);

  /**
   * Construct the property map appropriate for the object.
   * @return the newly created property map
   */
  protected abstract PropertyMap makeMap();

  /**
   * Create a new MapCreator
   * @param clazz type of MapCreator
   * @return map creator instantiated by type
   */
  protected MapCreator<?> newMapCreator(Class<? extends ScriptObject> clazz) {
    return new MapCreator<>(clazz, tuples);
  }

  /**
   * Loads the scope on the stack through the passed method emitter.
   * @param method the method emitter to use
   */
  protected void loadScope(MethodEmitter method) {
    method.loadCompilerConstant(SCOPE);
  }

  /**
   * Emit the correct map for the object.
   * @param method method emitter
   * @return the method emitter
   */
  protected MethodEmitter loadMap(MethodEmitter method) {
    codegen.loadConstant(propertyMap);
    return method;
  }

  PropertyMap getMap() {
    return propertyMap;
  }

  /**
   * Is this a scope object
   * @return true if scope
   */
  protected boolean isScope() {
    return isScope;
  }

  /**
   * Does the created object have an "arguments" property
   * @return true if has an "arguments" property
   */
  protected boolean hasArguments() {
    return hasArguments;
  }

  /**
   * Get the class of objects created by this ObjectCreator
   * @return class of created object
   */
  abstract protected Class<? extends ScriptObject> getAllocatorClass();

  /**
   * Technique for loading an initial value. Defined by anonymous subclasses in code gen.
   * @param value Value to load.
   * @param type the type of the value to load
   */
  protected abstract void loadValue(T value, Type type);

  MethodEmitter loadTuple(MethodEmitter method, MapTuple<T> tuple, boolean pack) {
    loadValue(tuple.value, tuple.type);
    if (!codegen.useDualFields() || !tuple.isPrimitive()) {
      method.convert(Type.OBJECT);
    } else if (pack) {
      method.pack();
    }
    return method;
  }

  MethodEmitter loadIndex(MethodEmitter method, long index) {
    return JSType.isRepresentableAsInt(index) ? method.load((int) index) : method.load((double) index);
  }

}
