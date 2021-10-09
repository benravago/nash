package es.codegen;

import static es.runtime.arrays.ArrayIndex.getArrayIndex;
import static es.runtime.arrays.ArrayIndex.isValidArrayIndex;

import java.util.ArrayList;
import java.util.List;
import es.ir.Symbol;
import es.runtime.AccessorProperty;
import es.runtime.Property;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.SpillProperty;

/**
 * Class that creates PropertyMap sent to script object constructors.
 * @param <T> value type for tuples, e.g. Symbol
 */
public class MapCreator<T> {

  /** Object structure for objects associated with this map */
  private final Class<?> structure;

  /** key set for object map */
  private final List<MapTuple<T>> tuples;

  /**
   * Constructor
   *
   * @param structure structure to generate map for (a JO subclass)
   * @param tuples    list of tuples for map
   */
  MapCreator(final Class<? extends ScriptObject> structure, final List<MapTuple<T>> tuples) {
    this.structure = structure;
    this.tuples = tuples;
  }

  /**
   * Constructs a property map based on a set of fields.
   *
   * @param hasArguments  does the created object have an "arguments" property
   * @param fieldCount    Number of fields in use.
   * @param fieldMaximum  Number of fields available.
   * @param evalCode      is this property map created for 'eval' code?
   * @return New map populated with accessor properties.
   */
  PropertyMap makeFieldMap(final boolean hasArguments, final boolean dualFields, final int fieldCount, final int fieldMaximum, final boolean evalCode) {
    final List<Property> properties = new ArrayList<>();
    assert tuples != null;

    for (final MapTuple<T> tuple : tuples) {
      final String key = tuple.key;
      final Symbol symbol = tuple.symbol;
      final Class<?> initialType = dualFields ? tuple.getValueType() : Object.class;

      if (symbol != null && !isValidArrayIndex(getArrayIndex(key))) {
        final int flags = getPropertyFlags(symbol, hasArguments, evalCode, dualFields);
        final Property property = new AccessorProperty(
                key,
                flags,
                structure,
                symbol.getFieldIndex(),
                initialType);
        properties.add(property);
      }
    }

    return PropertyMap.newMap(properties, structure.getName(), fieldCount, fieldMaximum, 0);
  }

  PropertyMap makeSpillMap(final boolean hasArguments, final boolean dualFields) {
    final List<Property> properties = new ArrayList<>();
    int spillIndex = 0;
    assert tuples != null;

    for (final MapTuple<T> tuple : tuples) {
      final String key = tuple.key;
      final Symbol symbol = tuple.symbol;
      final Class<?> initialType = dualFields ? tuple.getValueType() : Object.class;

      if (symbol != null && !isValidArrayIndex(getArrayIndex(key))) {
        final int flags = getPropertyFlags(symbol, hasArguments, false, dualFields);
        properties.add(
                new SpillProperty(
                        key,
                        flags,
                        spillIndex++,
                        initialType));
      }
    }

    return PropertyMap.newMap(properties, structure.getName(), 0, 0, spillIndex);
  }

  /**
   * Compute property flags given local state of a field. May be overridden and extended,
   *
   * @param symbol       symbol to check
   * @param hasArguments does the created object have an "arguments" property
   *
   * @return flags to use for fields
   */
  static int getPropertyFlags(final Symbol symbol, final boolean hasArguments, final boolean evalCode, final boolean dualFields) {
    int flags = 0;

    if (symbol.isParam()) {
      flags |= Property.IS_PARAMETER;
    }

    if (hasArguments) {
      flags |= Property.HAS_ARGUMENTS;
    }

    // See ECMA 5.1 10.5 Declaration Binding Instantiation.
    // Step 2  If code is eval code, then let configurableBindings
    // be true else let configurableBindings be false.
    // We have to make vars, functions declared in 'eval' code
    // configurable. But vars, functions from any other code is
    // not configurable.
    if (symbol.isScope() && !evalCode) {
      flags |= Property.NOT_CONFIGURABLE;
    }

    if (symbol.isFunctionDeclaration()) {
      flags |= Property.IS_FUNCTION_DECLARATION;
    }

    if (symbol.isConst()) {
      flags |= Property.NOT_WRITABLE;
    }

    if (symbol.isBlockScoped()) {
      flags |= Property.IS_LEXICAL_BINDING;
    }

    // Mark symbol as needing declaration. Access before declaration will throw a ReferenceError.
    if (symbol.isBlockScoped() && symbol.isScope()) {
      flags |= Property.NEEDS_DECLARATION;
    }

    if (dualFields) {
      flags |= Property.DUAL_FIELDS;
    }

    return flags;
  }
}
