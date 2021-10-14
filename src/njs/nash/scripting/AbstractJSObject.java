package nash.scripting;

import java.util.Collection;
import java.util.Collections;
import java.util.Objects;
import java.util.Set;

/**
 * This is the base class for nashorn ScriptObjectMirror class.
 *
 * This class can also be subclassed by an arbitrary Java class.
 * Nashorn will treat objects of such classes just like nashorn script objects.
 * Usual nashorn operations like obj[i], obj.foo, obj.func(), delete obj.foo will be delegated to appropriate method call of this class.
 */
public abstract class AbstractJSObject implements JSObject {

  /** @implSpec This implementation always throws UnsupportedOperationException */
  @Override
  public Object call(Object thiz, Object... args) {
    throw new UnsupportedOperationException("call");
  }

  /** @implSpec This implementation always throws UnsupportedOperationException */
  @Override
  public Object newObject(Object... args) {
    throw new UnsupportedOperationException("newObject");
  }

  /** @implSpec This imlementation always throws UnsupportedOperationException */
  @Override
  public Object eval(String s) {
    throw new UnsupportedOperationException("eval");
  }

  /** @implSpec This implementation always returns null */
  @Override
  public Object getMember(String name) {
    Objects.requireNonNull(name);
    return null;
  }

  /** @implSpec This implementation always returns null */
  @Override
  public Object getSlot(int index) {
    return null;
  }

  /** @implSpec This implementation always returns false */
  @Override
  public boolean hasMember(String name) {
    Objects.requireNonNull(name);
    return false;
  }

  /** @implSpec This implementation always returns false */
  @Override
  public boolean hasSlot(int slot) {
    return false;
  }

  /** @implSpec This implementation is a no-op */
  @Override
  public void removeMember(String name) {
    Objects.requireNonNull(name);
  }

  /** @implSpec This implementation is a no-op */
  @Override
  public void setMember(String name, Object value) {
    Objects.requireNonNull(name);
  }

  /** @implSpec This implementation is a no-op */
  @Override
  public void setSlot(int index, Object value) {
    //empty
  }

  // property and value iteration

  /** @implSpec This implementation returns empty set */
  @Override
  public Set<String> keySet() {
    return Collections.emptySet();
  }

  /** @implSpec This implementation returns empty set */
  @Override
  public Collection<Object> values() {
    return Collections.emptySet();
  }

  // JavaScript instanceof check

  /** @implSpec This implementation always returns false */
  @Override
  public boolean isInstance(Object instance) {
    return false;
  }

  @Override
  public boolean isInstanceOf(Object type) {
    return type instanceof JSObject jso && jso.isInstance(this);
  }

  @Override
  public String getClassName() {
    return getClass().getName();
  }

  /** @implSpec This implementation always returns false */
  @Override
  public boolean isFunction() {
    return false;
  }

  /** @implSpec This implementation always returns false */
  @Override
  public boolean isArray() {
    return false;
  }

}
