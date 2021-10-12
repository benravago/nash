package es.runtime.arrays;

import static es.runtime.ECMAErrors.typeError;
import es.objects.Global;
import es.runtime.PropertyDescriptor;
import es.runtime.ScriptRuntime;

/**
 * ArrayData after the array has been frozen by Object.freeze call.
 */
final class FrozenArrayFilter extends SealedArrayFilter {

  FrozenArrayFilter(final ArrayData underlying) {
    super(underlying);
  }

  @Override
  public ArrayData copy() {
    return this;
  }

  @Override
  public PropertyDescriptor getDescriptor(final Global global, final int index) {
    return global.newDataDescriptor(getObject(index), false, true, false);
  }

  @Override
  public ArrayData set(final int index, final int value) {
    // throw typeError("cant.set.property", Integer.toString(index), "frozen array");
    return this;
  }

  @Override
  public ArrayData set(final int index, final double value) {
    // throw typeError("cant.set.property", Integer.toString(index), "frozen array");
    return this;
  }

  @Override
  public ArrayData set(final int index, final Object value) {
    // throw typeError("cant.set.property", Integer.toString(index), "frozen array");
    return this;
  }

  @Override
  public ArrayData push(final Object... items) {
    return this; //nop
  }

  @Override
  public Object pop() {
    final int len = (int) underlying.length();
    return len == 0 ? ScriptRuntime.UNDEFINED : underlying.getObject(len - 1);
  }
}
