package es.objects;

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
 * Generic Property descriptor is used to represent attributes an object property that is neither a data property descriptor nor an accessor property descriptor.
 * See ECMA 8.10 The Property Descriptor and Property Identifier Specification Types
 */
@ScriptClass("GenericPropertyDescriptor")
public final class GenericPropertyDescriptor extends ScriptObject implements PropertyDescriptor {

  /** Is the property configurable? */
  @Property
  public Object configurable;

  /** Is the property writable? */
  @Property
  public Object enumerable;

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  GenericPropertyDescriptor(boolean configurable, boolean enumerable, Global global) {
    super(global.getObjectPrototype(), $nasgenmap$);
    this.configurable = configurable;
    this.enumerable = enumerable;
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
    return false;
  }

  @Override
  public Object getValue() {
    throw new UnsupportedOperationException("value");
  }

  @Override
  public ScriptFunction getGetter() {
    throw new UnsupportedOperationException("get");
  }

  @Override
  public ScriptFunction getSetter() {
    throw new UnsupportedOperationException("set");
  }

  @Override
  public void setConfigurable(boolean flag) {
    this.configurable = flag;
  }

  @Override
  public void setEnumerable(boolean flag) {
    this.enumerable = flag;
  }

  @Override
  public void setWritable(boolean flag) {
    throw new UnsupportedOperationException("set writable");
  }

  @Override
  public void setValue(Object value) {
    throw new UnsupportedOperationException("set value");
  }

  @Override
  public void setGetter(Object getter) {
    throw new UnsupportedOperationException("set getter");
  }

  @Override
  public void setSetter(Object setter) {
    throw new UnsupportedOperationException("set setter");
  }

  @Override
  public PropertyDescriptor fillFrom(ScriptObject sobj) {
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
    return this;
  }

  @Override
  public int type() {
    return GENERIC;
  }

  @Override
  public boolean hasAndEquals(PropertyDescriptor other) {
    if (has(CONFIGURABLE) && other.has(CONFIGURABLE)) {
      if (isConfigurable() != other.isConfigurable()) {
        return false;
      }
    }
    if (has(ENUMERABLE) && other.has(ENUMERABLE)) {
      if (isEnumerable() != other.isEnumerable()) {
        return false;
      }
    }
    return true;
  }

  @Override
  public boolean equals(Object obj) {
    if (this == obj) {
      return true;
    }
    if (!(obj instanceof GenericPropertyDescriptor)) {
      return false;
    }
    var other = (GenericPropertyDescriptor) obj;
    return ScriptRuntime.sameValue(configurable, other.configurable)
        && ScriptRuntime.sameValue(enumerable, other.enumerable);
  }

  @Override
  public String toString() {
    return '[' + getClass().getSimpleName() + " {configurable=" + configurable + " enumerable=" + enumerable + "}]";
  }

  @Override
  public int hashCode() {
    var hash = 7;
    hash = 97 * hash + Objects.hashCode(this.configurable);
    hash = 97 * hash + Objects.hashCode(this.enumerable);
    return hash;
  }

}
