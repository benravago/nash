package es.codegen;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import es.runtime.PropertyMap;

/**
 * Manages constants needed by code generation.
 * Objects are maintained in an interning maps to remove duplicates.
 */
final class ConstantData {

  // Constant table.
  final List<Object> constants;

  // Constant table string interning map.
  final Map<String, Integer> stringMap;

  // Constant table object interning map.
  final Map<Object, Integer> objectMap;

  private static class ArrayWrapper {

    private final Object array;
    private final int hashCode;

    public ArrayWrapper(Object array) {
      this.array = array;
      this.hashCode = calcHashCode();
    }

    /**
     * Calculate a shallow hashcode for the array.
     * @return Hashcode with elements factored in.
     */
    int calcHashCode() {
      var cls = array.getClass();
      if (!cls.getComponentType().isPrimitive()) {
        return Arrays.hashCode((Object[]) array);
      } else if (cls == double[].class) {
        return Arrays.hashCode((double[]) array);
      }
      if (cls == long[].class) {
        return Arrays.hashCode((long[]) array);
      }
      if (cls == int[].class) {
        return Arrays.hashCode((int[]) array);
      }
      throw new AssertionError("ConstantData doesn't support " + cls);
    }

    @Override
    public boolean equals(Object other) {
      if (!(other instanceof ArrayWrapper)) {
        return false;
      }
      var otherArray = ((ArrayWrapper) other).array;
      if (array == otherArray) {
        return true;
      }
      var cls = array.getClass();
      if (cls == otherArray.getClass()) {
        if (!cls.getComponentType().isPrimitive()) {
          return Arrays.equals((Object[]) array, (Object[]) otherArray);
        } else if (cls == double[].class) {
          return Arrays.equals((double[]) array, (double[]) otherArray);
        } else if (cls == long[].class) {
          return Arrays.equals((long[]) array, (long[]) otherArray);
        } else if (cls == int[].class) {
          return Arrays.equals((int[]) array, (int[]) otherArray);
        }
      }
      return false;
    }

    @Override
    public int hashCode() {
      return hashCode;
    }
  }

  /**
   * {@link PropertyMap} wrapper class that provides implementations for the {@code hashCode} and {@code equals} methods that are based on the map layout.
   * {@code PropertyMap} itself inherits the identity based implementations from {@code java.lang.Object}.
   */
  private static class PropertyMapWrapper {

    private final PropertyMap propertyMap;
    private final int hashCode;

    public PropertyMapWrapper(PropertyMap map) {
      this.hashCode = Arrays.hashCode(map.getProperties()) + 31 * Objects.hashCode(map.getClassName());
      this.propertyMap = map;
    }

    @Override
    public int hashCode() {
      return hashCode;
    }

    @Override
    public boolean equals(Object other) {
      if (!(other instanceof PropertyMapWrapper)) {
        return false;
      }
      var otherMap = ((PropertyMapWrapper) other).propertyMap;
      return propertyMap == otherMap
          || (Arrays.equals(propertyMap.getProperties(), otherMap.getProperties())
          && Objects.equals(propertyMap.getClassName(), otherMap.getClassName()));
    }
  }

  /**
   * Constructor
   */
  ConstantData() {
    this.constants = new ArrayList<>();
    this.stringMap = new HashMap<>();
    this.objectMap = new HashMap<>();
  }

  /**
   * Add a string to the constant data
   * @param string the string to add
   * @return the index in the constant pool that the string was given
   */
  public int add(String string) {
    var value = stringMap.get(string);
    if (value != null) {
      return value;
    }
    constants.add(string);
    var index = constants.size() - 1;
    stringMap.put(string, index);
    return index;
  }

  /**
   * Add an object to the constant data
   * @param object the string to add
   * @return the index in the constant pool that the object was given
   */
  public int add(Object object) {
    assert object != null;
    var entry = (object.getClass().isArray()) ? new ArrayWrapper(object)
              : (object instanceof PropertyMap) ? new PropertyMapWrapper((PropertyMap) object)
              : object;
    var value = objectMap.get(entry);
    if (value != null) {
      return value;
    }
    constants.add(object);
    var index = constants.size() - 1;
    objectMap.put(entry, index);
    return index;
  }

  Object[] toArray() {
    return constants.toArray();
  }

}
