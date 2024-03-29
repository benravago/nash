package es.codegen;

import java.util.List;

import es.codegen.types.Type;
import es.ir.Symbol;
import es.runtime.Context;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.arrays.ArrayIndex;
import static es.codegen.CompilerConstants.*;
import static es.codegen.ObjectClassGenerator.*;
import static es.runtime.arrays.ArrayIndex.*;

/**
 * Analyze an object's characteristics for appropriate code generation.
 *
 * This is used for functions and for objects.
 * A field object take a set of values which to assign to the various fields in the object. This is done by the generated code
 *
 * @param <T> the value type for the fields being written on object creation, e.g. Node
 * @see es.ir.Node
 */
public abstract class FieldObjectCreator<T> extends ObjectCreator<T> {

  private String fieldObjectClassName;
  private Class<? extends ScriptObject> fieldObjectClass;
  private int fieldCount;
  private int paddedFieldCount;
  private int paramCount;

  // call site flags to be used for invocations
  private final int callSiteFlags;

  // are we creating this field object from 'eval' code?
  private final boolean evalCode;

  /**
   * Constructor
   *
   * @param codegen  code generator
   * @param tuples   tuples for fields in object
   */
  FieldObjectCreator(CodeGenerator codegen, List<MapTuple<T>> tuples) {
    this(codegen, tuples, false, false);
  }

  /**
   * Constructor
   *
   * @param codegen      code generator
   * @param tuples       tuples for fields in object
   * @param isScope      is this a scope object
   * @param hasArguments does the created object have an "arguments" property
   */
  FieldObjectCreator(CodeGenerator codegen, List<MapTuple<T>> tuples, boolean isScope, boolean hasArguments) {
    super(codegen, tuples, isScope, hasArguments);
    this.callSiteFlags = codegen.getCallSiteFlags();
    this.evalCode = codegen.isEvalCode();
    countFields();
    findClass();
  }

  @Override
  public void createObject(MethodEmitter method) {
    makeMap();
    var className = getClassName();
    // NOTE: we must load the actual structure class here, because the API operates with Nashorn Type objects, and Type objects need a loaded class, for better or worse.
    // We also have to be specific and use the type of the actual structure class, we can't generalize it to e.g. Type.typeFor(ScriptObject.class) as the exact type information is needed for generating continuations in rest-of methods.
    // If we didn't do this, object initializers like { x: arr[i] } would fail during deoptimizing compilation on arr[i], as the values restored from the RewriteException would be cast to "ScriptObject" instead of to e.g. "JO4", and subsequently the "PUTFIELD J04.L0" instruction in the continuation code would fail bytecode verification.
    assert fieldObjectClass != null;
    method.new_(fieldObjectClass).dup();
    loadMap(method); //load the map
    if (isScope()) {
      loadScope(method);
      if (hasArguments()) {
        method.loadCompilerConstant(ARGUMENTS);
        method.invoke(constructorNoLookup(className, PropertyMap.class, ScriptObject.class, ARGUMENTS.type()));
      } else {
        method.invoke(constructorNoLookup(className, PropertyMap.class, ScriptObject.class));
      }
    } else {
      method.invoke(constructorNoLookup(className, PropertyMap.class));
    }
  }

  /**
   * Create a scope for a for-in/of loop as defined in ES6 13.7.5.13 step 5.g.iii
   * @param method the method emitter
   */
  void createForInIterationScope(MethodEmitter method) {
    assert fieldObjectClass != null;
    assert isScope();
    assert getMap() != null;
    var className = getClassName();
    method.new_(fieldObjectClass).dup();
    loadMap(method); //load the map
    loadScope(method);
    // We create a scope identical to the currently active one, so use its parent as our parent
    method.invoke(ScriptObject.GET_PROTO);
    method.invoke(constructorNoLookup(className, PropertyMap.class, ScriptObject.class));
  }

  @Override
  public void populateRange(MethodEmitter method, Type objectType, int objectSlot, int start, int end) {
    method.load(objectType, objectSlot);
    // Set values.
    for (var i = start; i < end; i++) {
      var tuple = tuples.get(i);
      // we only load when we have both symbols and values (which can be == the symbol)
      // if we didn't load, we need an array property
      if (tuple.symbol != null && tuple.value != null) {
        var index = getArrayIndex(tuple.key);
        method.dup();
        if (!isValidArrayIndex(index)) {
          putField(method, tuple.key, tuple.symbol.getFieldIndex(), tuple);
        } else {
          putSlot(method, ArrayIndex.toLongIndex(index), tuple);
        }
        // this is a nop of tuple.key isn't e.g. "apply" or another special name
        method.invalidateSpecialName(tuple.key);
      }
    }
  }

  @Override
  protected PropertyMap makeMap() {
    assert propertyMap == null : "property map already initialized";
    propertyMap = newMapCreator(fieldObjectClass).makeFieldMap(hasArguments(), codegen.useDualFields(), fieldCount, paddedFieldCount, evalCode);
    return propertyMap;
  }

  /**
   * Store a value in a field of the generated class object.
   * @param method      Script method.
   * @param key         Property key.
   * @param fieldIndex  Field number.
   * @param tuple       Tuple to store.
   */
  void putField(MethodEmitter method, String key, int fieldIndex, MapTuple<T> tuple) {
    var fieldType = codegen.useDualFields() && tuple.isPrimitive() ? PRIMITIVE_FIELD_TYPE : Type.OBJECT;
    var fieldClass = getClassName();
    var fieldName = getFieldName(fieldIndex, fieldType);
    var fieldDesc = typeDescriptor(fieldType.getTypeClass());
    assert fieldName.equals(getFieldName(fieldIndex, PRIMITIVE_FIELD_TYPE)) || fieldType.isObject() : key + " object keys must store to L*-fields";
    assert fieldName.equals(getFieldName(fieldIndex, Type.OBJECT)) || fieldType.isPrimitive() : key + " primitive keys must store to J*-fields";
    loadTuple(method, tuple, true);
    method.putField(fieldClass, fieldName, fieldDesc);
  }

  /**
   * Store a value in an indexed slot of a generated class object.
   * @param method Script method.
   * @param index  Slot index.
   * @param tuple  Tuple to store.
   */
  void putSlot(MethodEmitter method, long index, MapTuple<T> tuple) {
    loadIndex(method, index);
    loadTuple(method, tuple, false); //we don't pack array like objects
    method.dynamicSetIndex(callSiteFlags);
  }

  /**
   * Locate (or indirectly create) the object container class.
   */
  void findClass() {
    fieldObjectClassName = isScope()
      ? ObjectClassGenerator.getClassName(fieldCount, paramCount, codegen.useDualFields())
      : ObjectClassGenerator.getClassName(paddedFieldCount, codegen.useDualFields());
    try {
      this.fieldObjectClass = Context.forStructureClass(Compiler.binaryName(fieldObjectClassName));
    } catch (ClassNotFoundException e) {
      throw new AssertionError("Nashorn has encountered an internal error.  Structure can not be created.");
    }
  }

  @Override
  protected Class<? extends ScriptObject> getAllocatorClass() {
    return fieldObjectClass;
  }

  /**
   * Get the class name for the object class, e.g. {@code com.nashorn.oracle.scripts.JO2P0}
   * @return script class name
   */
  String getClassName() {
    return fieldObjectClassName;
  }

  /**
   * Tally the number of fields and parameters.
   */
  void countFields() {
    for (var tuple : tuples) {
      var symbol = tuple.symbol;
      if (symbol != null) {
        if (hasArguments() && symbol.isParam()) {
          symbol.setFieldIndex(paramCount++);
        } else if (!isValidArrayIndex(getArrayIndex(tuple.key))) {
          symbol.setFieldIndex(fieldCount++);
        }
      }
    }
    paddedFieldCount = getPaddedFieldCount(fieldCount);
  }

}
