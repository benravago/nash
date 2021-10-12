package es.objects;

import static es.runtime.ECMAErrors.typeError;
import static es.runtime.ScriptRuntime.UNDEFINED;
import static es.runtime.ScriptRuntime.sameValue;

import java.util.Objects;
import es.objects.annotations.Property;
import es.objects.annotations.ScriptClass;
import es.runtime.JSType;
import es.runtime.PropertyDescriptor;
import es.runtime.PropertyMap;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;

/**
 * Accessor Property descriptor is used to represent attributes an object property
 * that either has a getter or a setter.
 *
 * See ECMA 8.10 The Property Descriptor and Property Identifier Specification Types
 *
 */
@ScriptClass("AccessorPropertyDescriptor")
public final class AccessorPropertyDescriptor extends ScriptObject implements PropertyDescriptor {

  /** is this property configurable? */
  @Property
  public Object configurable;

  /** is this property enumerable? */
  @Property
  public Object enumerable;

  /** getter for property */
  @Property
  public Object get;

  /** setter for property */
  @Property
  public Object set;

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  AccessorPropertyDescriptor(final boolean configurable, final boolean enumerable, final Object get, final Object set, final Global global) {
    super(global.getObjectPrototype(), $nasgenmap$);
    this.configurable = configurable;
    this.enumerable = enumerable;
    this.get = get;
    this.set = set;
  }

  @Override
  public boolean isConfigurable() {
    return JSType.toBoolean(configurable);
  }

  @Override
  public boolean isEnumerable() {
    return JSType.toBoolean(enumerable);
  }

  @Override
  public boolean isWritable() {
    // Not applicable for this. But simplifies flag calculations.
    return true;
  }

  @Override
  public Object getValue() {
    throw new UnsupportedOperationException("value");
  }

  @Override
  public ScriptFunction getGetter() {
    return (get instanceof ScriptFunction) ? (ScriptFunction) get : null;
  }

  @Override
  public ScriptFunction getSetter() {
    return (set instanceof ScriptFunction) ? (ScriptFunction) set : null;
  }

  @Override
  public void setConfigurable(final boolean flag) {
    this.configurable = flag;
  }

  @Override
  public void setEnumerable(final boolean flag) {
    this.enumerable = flag;
  }

  @Override
  public void setWritable(final boolean flag) {
    throw new UnsupportedOperationException("set writable");
  }

  @Override
  public void setValue(final Object value) {
    throw new UnsupportedOperationException("set value");
  }

  @Override
  public void setGetter(final Object getter) {
    this.get = getter;
  }

  @Override
  public void setSetter(final Object setter) {
    this.set = setter;
  }

  @Override
  public PropertyDescriptor fillFrom(final ScriptObject sobj) {
    if (sobj.has(CONFIGURABLE)) {
      this.configurable = JSType.toBoolean(sobj.get(CONFIGURABLE));
    } else {
      delete(CONFIGURABLE);
    }

    if (sobj.has(ENUMERABLE)) {
      this.enumerable = JSType.toBoolean(sobj.get(ENUMERABLE));
    } else {
      delete(ENUMERABLE);
    }

    if (sobj.has(GET)) {
      final Object getter = sobj.get(GET);
      if (getter == UNDEFINED || getter instanceof ScriptFunction) {
        this.get = getter;
      } else {
        throw typeError("not.a.function", ScriptRuntime.safeToString(getter));
      }
    } else {
      delete(GET);
    }

    if (sobj.has(SET)) {
      final Object setter = sobj.get(SET);
      if (setter == UNDEFINED || setter instanceof ScriptFunction) {
        this.set = setter;
      } else {
        throw typeError("not.a.function", ScriptRuntime.safeToString(setter));
      }
    } else {
      delete(SET);
    }

    return this;
  }

  @Override
  public int type() {
    return ACCESSOR;
  }

  @Override
  public boolean hasAndEquals(final PropertyDescriptor otherDesc) {
    if (!(otherDesc instanceof AccessorPropertyDescriptor)) {
      return false;
    }
    final AccessorPropertyDescriptor other = (AccessorPropertyDescriptor) otherDesc;
    return (!has(CONFIGURABLE) || sameValue(configurable, other.configurable))
            && (!has(ENUMERABLE) || sameValue(enumerable, other.enumerable))
            && (!has(GET) || sameValue(get, other.get))
            && (!has(SET) || sameValue(set, other.set));
  }

  @Override
  public boolean equals(final Object obj) {
    if (this == obj) {
      return true;
    }
    if (!(obj instanceof AccessorPropertyDescriptor)) {
      return false;
    }

    final AccessorPropertyDescriptor other = (AccessorPropertyDescriptor) obj;
    return sameValue(configurable, other.configurable)
            && sameValue(enumerable, other.enumerable)
            && sameValue(get, other.get)
            && sameValue(set, other.set);
  }

  @Override
  public String toString() {
    return '[' + getClass().getSimpleName() + " {configurable=" + configurable + " enumerable=" + enumerable + " getter=" + get + " setter=" + set + "}]";
  }

  @Override
  public int hashCode() {
    int hash = 7;
    hash = 41 * hash + Objects.hashCode(this.configurable);
    hash = 41 * hash + Objects.hashCode(this.enumerable);
    hash = 41 * hash + Objects.hashCode(this.get);
    hash = 41 * hash + Objects.hashCode(this.set);
    return hash;
  }
}
