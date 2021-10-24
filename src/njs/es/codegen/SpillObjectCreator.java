package es.codegen;

import java.util.List;

import es.codegen.types.Type;
import es.ir.Expression;
import es.ir.LiteralNode;
import es.runtime.JSType;
import es.runtime.Property;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.arrays.ArrayData;
import es.runtime.arrays.ArrayIndex;
import es.scripts.JD;
import es.scripts.JO;
import static es.codegen.CompilerConstants.*;

/**
 * An object creator that uses spill properties.
 */
public final class SpillObjectCreator extends ObjectCreator<Expression> {

  /**
   * Constructor
   *
   * @param codegen  code generator
   * @param tuples   tuples for key, symbol, value
   */
  SpillObjectCreator(CodeGenerator codegen, List<MapTuple<Expression>> tuples) {
    super(codegen, tuples, false, false);
    makeMap();
  }

  @Override
  public void createObject(MethodEmitter method) {
    assert !isScope() : "spill scope objects are not currently supported";
    var length = tuples.size();
    var dualFields = codegen.useDualFields();
    var spillLength = ScriptObject.spillAllocationLength(length);
    var jpresetValues = dualFields ? new long[spillLength] : null;
    var opresetValues = new Object[spillLength];
    var objectClass = getAllocatorClass();
    var arrayData = ArrayData.allocate(ScriptRuntime.EMPTY_ARRAY);
    // Compute constant property values
    var pos = 0;
    for (var tuple : tuples) {
      var key = tuple.key;
      var value = tuple.value;
      // this is a nop of tuple.key isn't e.g. "apply" or another special name
      method.invalidateSpecialName(tuple.key);
      if (value != null) {
        var constantValue = LiteralNode.objectAsConstant(value);
        if (constantValue != LiteralNode.POSTSET_MARKER) {
          var property = propertyMap.findProperty(key);
          if (property != null) {
            // normal property key
            property.setType(dualFields ? JSType.unboxedFieldType(constantValue) : Object.class);
            var slot = property.getSlot();
            if (dualFields && constantValue instanceof Number) {
              jpresetValues[slot] = ObjectClassGenerator.pack((Number) constantValue);
            } else {
              opresetValues[slot] = constantValue;
            }
          } else {
            // array index key
            var oldLength = arrayData.length();
            var index = ArrayIndex.getArrayIndex(key);
            var longIndex = ArrayIndex.toLongIndex(index);
            assert ArrayIndex.isValidArrayIndex(index);
            if (longIndex >= oldLength) {
              arrayData = arrayData.ensure(longIndex);
            }
            // avoid blowing up the array if we can
            if (constantValue instanceof Integer i) {
              arrayData = arrayData.set(index, i.intValue());
            } else if (constantValue instanceof Double d) {
              arrayData = arrayData.set(index, d.doubleValue());
            } else {
              arrayData = arrayData.set(index, constantValue);
            }
            if (longIndex > oldLength) {
              arrayData = arrayData.delete(oldLength, longIndex - 1);
            }
          }
        }
      }
      pos++;
    }
    // create object and invoke constructor
    method.new_(objectClass).dup();
    codegen.loadConstant(propertyMap);
    // load primitive value spill array
    if (dualFields) {
      codegen.loadConstant(jpresetValues);
    } else {
      method.loadNull();
    }
    // load object value spill array
    codegen.loadConstant(opresetValues);
    // instantiate the script object with spill objects
    method.invoke(constructorNoLookup(objectClass, PropertyMap.class, long[].class, Object[].class));
    // Set prefix array data if any
    if (arrayData.length() > 0) {
      method.dup();
      codegen.loadConstant(arrayData);
      method.invoke(virtualCallNoLookup(ScriptObject.class, "setArray", void.class, ArrayData.class));
    }
  }

  @Override
  public void populateRange(MethodEmitter method, Type objectType, int objectSlot, int start, int end) {
    var callSiteFlags = codegen.getCallSiteFlags();
    method.load(objectType, objectSlot);
    // set postfix values
    for (var i = start; i < end; i++) {
      var tuple = tuples.get(i);
      if (LiteralNode.isConstant(tuple.value)) {
        continue;
      }
      var property = propertyMap.findProperty(tuple.key);
      if (property == null) {
        var index = ArrayIndex.getArrayIndex(tuple.key);
        assert ArrayIndex.isValidArrayIndex(index);
        method.dup();
        loadIndex(method, ArrayIndex.toLongIndex(index));
        loadTuple(method, tuple, false);
        method.dynamicSetIndex(callSiteFlags);
      } else {
        assert property.getKey() instanceof String; // symbol keys not yet supported in object literals
        method.dup();
        loadTuple(method, tuple, false);
        method.dynamicSet((String) property.getKey(), codegen.getCallSiteFlags(), false);
      }
    }
  }

  @Override
  protected PropertyMap makeMap() {
    assert propertyMap == null : "property map already initialized";
    var clazz = getAllocatorClass();
    propertyMap = new MapCreator<>(clazz, tuples).makeSpillMap(false, codegen.useDualFields());
    return propertyMap;
  }

  @Override
  protected void loadValue(Expression expr, Type type) {
    // Use generic type in order to avoid conversion between object types
    codegen.loadExpressionAsType(expr, Type.generic(type));
  }

  @Override
  protected Class<? extends ScriptObject> getAllocatorClass() {
    return codegen.useDualFields() ? JD.class : JO.class;
  }

}
