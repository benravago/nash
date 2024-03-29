package es.runtime;

import java.lang.invoke.MethodHandle;

import jdk.dynalink.linker.LinkRequest;

import es.codegen.ObjectClassGenerator;
import es.objects.Global;
import static es.lookup.Lookup.MH;
import static es.runtime.UnwarrantedOptimismException.isValid;

/**
 * This class represents the result from a find property search.
 */
public final class FindProperty {

  // Object where search began.
  private final ScriptObject self;

  // Object where search finish.
  private final ScriptObject prototype;

  // Found property.
  private final Property property;

  /**
   * Constructor
   *
   * @param self      script object where search began
   * @param prototype prototype where property was found, may be {@code self} if not inherited
   * @param property  property that was search result
   */
  public FindProperty(ScriptObject self, ScriptObject prototype, Property property) {
    this.self = self;
    this.prototype = prototype;
    this.property = property;
  }

  /**
   * Return a copy of this FindProperty with a different property.
   * @param newProperty the new property
   * @return the new FindProperty instance
   */
  public FindProperty replaceProperty(Property newProperty) {
    assert this.property.getKey().equals(newProperty.getKey());
    assert this.property.getSlot() == newProperty.getSlot();
    return new FindProperty(self, prototype, newProperty);
  }

  /**
   * Ask for a getter that returns the given type.
   * The type has nothing to do with the internal representation of the property.
   * It may be an Object (boxing primitives) or a primitive (primitive fields with -Dnashorn.fields.dual=true)
   * @see ObjectClassGenerator
   * @param type type of getter, e.g. int.class if we want a function with {@code get()I} signature
   * @param programPoint program point, or INVALID_PROGRAM_POINT if pessimistic
   * @param request link request
   * @return method handle for the getter
   */
  public MethodHandle getGetter(Class<?> type, int programPoint, LinkRequest request) {
    var getter = isValid(programPoint) ? property.getOptimisticGetter(type, programPoint) : property.getGetter(type);
    if (property instanceof UserAccessorProperty uap) {
      getter = MH.insertArguments(getter, 1, UserAccessorProperty.getINVOKE_UA_GETTER(type, programPoint));
      if (isValid(programPoint) && type.isPrimitive()) {
        getter = MH.insertArguments(getter, 1, programPoint);
      }
      property.setType(type);
      return insertAccessorsGetter(uap, request, getter);
    }
    return getter;
  }

  /**
   * Ask for a setter that sets the given type.
   * The type has nothing to do with the internal representation of the property.
   * It may be an Object (boxing primitives) or a primitive (primitive fields with -Dnashorn.fields.dual=true)
   * @see ObjectClassGenerator
   * @param type type of setter, e.g. int.class if we want a function with {@code set(I)V} signature
   * @param request link request
   * @return method handle for the getter
   */
  public MethodHandle getSetter(Class<?> type, LinkRequest request) {
    var setter = property.getSetter(type, getOwner().getMap());
    if (property instanceof UserAccessorProperty uap) {
      setter = MH.insertArguments(setter, 1, UserAccessorProperty.getINVOKE_UA_SETTER(type), property.getKey());
      property.setType(type);
      return insertAccessorsGetter(uap, request, setter);
    }
    return setter;
  }

  // Fold an accessor getter into the method handle of a user accessor property.
  MethodHandle insertAccessorsGetter(UserAccessorProperty uap, LinkRequest request, MethodHandle mh) {
    var superGetter = uap.getAccessorsGetter();
    if (!isSelf()) {
      superGetter = ScriptObject.addProtoFilter(superGetter, getProtoChainLength());
    }
    if (request != null && !(request.getReceiver() instanceof ScriptObject)) {
      var wrapFilter = Global.getPrimitiveWrapFilter(request.getReceiver());
      superGetter = MH.filterArguments(superGetter, 0, wrapFilter.asType(wrapFilter.type().changeReturnType(superGetter.type().parameterType(0))));
    }
    superGetter = MH.asType(superGetter, superGetter.type().changeParameterType(0, Object.class));
    return MH.foldArguments(mh, superGetter);
  }

  /**
   * Return the {@code ScriptObject} owning of the property:  this means the prototype.
   * @return owner of property
   */
  public ScriptObject getOwner() {
    return prototype;
  }

  /**
   * Return the {@code ScriptObject} where the search started.
   * This is usually the ScriptObject the operation was started on, except for properties found inside a 'with' statement, where it is the top-level 'with' expression object.
   * @return the start object.
   */
  public ScriptObject getSelf() {
    return self;
  }

  /**
   * Return the appropriate receiver for a getter.
   * @return appropriate receiver
   */
  public ScriptObject getGetterReceiver() {
    return property != null && property.isAccessorProperty() ? self : prototype;
  }

  /**
   * Return the appropriate receiver for a setter.
   * @return appropriate receiver
   */
  public ScriptObject getSetterReceiver() {
    return property != null && property.hasSetterFunction(prototype) ? self : prototype;
  }

  /**
   * Return the property that was found
   * @return property
   */
  public Property getProperty() {
    return property;
  }

  /**
   * Check if the property found was inherited from a prototype and it is an ordinary property (one that has no accessor function).
   * @return true if the found property is an inherited ordinary property
   */
  public boolean isInheritedOrdinaryProperty() {
    return !isSelf() && !getProperty().isAccessorProperty();
  }

  /**
   * Check if the property found was NOT inherited, i.e. defined in the script object, rather than in the prototype
   * @return true if not inherited
   */
  public boolean isSelf() {
    return self == prototype;
  }

  /**
   * Check if the property is in the scope
   * @return true if on scope
   */
  public boolean isScope() {
    return prototype.isScope();
  }

  /**
   * Get the property value from self as object.
   * @return the property value
   */
  public int getIntValue() {
    return property.getIntValue(getGetterReceiver(), getOwner());
  }

  /**
   * Get the property value from self as object.
   * @return the property value
   */
  public double getDoubleValue() {
    return property.getDoubleValue(getGetterReceiver(), getOwner());
  }

  /**
   * Get the property value from self as object.
   * @return the property value
   */
  public Object getObjectValue() {
    return property.getObjectValue(getGetterReceiver(), getOwner());
  }

  /**
   * Set the property value in self.
   * @param value the new value
   */
  public void setValue(int value) {
    property.setValue(getSetterReceiver(), getOwner(), value);
  }

  /**
   * Set the property value in self.
   * @param value the new value
   */
  public void setValue(double value) {
    property.setValue(getSetterReceiver(), getOwner(), value);
  }

  /**
   * Set the property value in self.
   * @param value the new value
   */
  public void setValue(Object value) {
    property.setValue(getSetterReceiver(), getOwner(), value);
  }

  /**
   * Get the number of objects in the prototype chain between the {@code self} and the {@code owner} objects.
   * @return the prototype chain length
   */
  int getProtoChainLength() {
    assert self != null;
    var length = 0;
    for (var obj = self; obj != prototype; obj = obj.getProto()) {
      ++length;
    }
    return length;
  }

  @Override
  public String toString() {
    return "[FindProperty: " + property.getKey() + ']';
  }

}
