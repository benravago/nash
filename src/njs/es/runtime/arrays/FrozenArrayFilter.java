package es.runtime.arrays;

import es.objects.Global;
import es.runtime.PropertyDescriptor;
import es.runtime.ScriptRuntime;

/**
 * ArrayData after the array has been frozen by Object.freeze call.
 */
final class FrozenArrayFilter extends SealedArrayFilter {

  FrozenArrayFilter(ArrayData underlying) {
    super(underlying);
  }

  @Override
  public ArrayData copy() {
    return this;
  }

  @Override
  public PropertyDescriptor getDescriptor(Global global, int index) {
    return global.newDataDescriptor(getObject(index), false, true, false);
  }

  @Override
  public ArrayData set(int index, int value) {
    // throw typeError("cant.set.property", Integer.toString(index), "frozen array");
    return this;
  }

  @Override
  public ArrayData set(int index, double value) {
    // throw typeError("cant.set.property", Integer.toString(index), "frozen array");
    return this;
  }

  @Override
  public ArrayData set(int index, Object value) {
    // throw typeError("cant.set.property", Integer.toString(index), "frozen array");
    return this;
  }

  @Override
  public ArrayData push(Object... items) {
    return this; //nop
  }

  @Override
  public Object pop() {
    var len = (int) underlying.length();
    return len == 0 ? ScriptRuntime.UNDEFINED : underlying.getObject(len - 1);
  }

}
