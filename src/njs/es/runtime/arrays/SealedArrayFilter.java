package es.runtime.arrays;

import es.objects.Global;
import es.runtime.PropertyDescriptor;

/**
 * ArrayData after the array has been sealed by Object.seal call.
 */
class SealedArrayFilter extends ArrayFilter {

  SealedArrayFilter(ArrayData underlying) {
    super(underlying);
  }

  @Override
  public ArrayData copy() {
    return new SealedArrayFilter(underlying.copy());
  }

  @Override
  public ArrayData slice(long from, long to) {
    return getUnderlying().slice(from, to);
  }

  @Override
  public boolean canDelete(int index) {
    return canDelete(ArrayIndex.toLongIndex(index));
  }

  @Override
  public boolean canDelete(long longIndex) {
    // throw typeError("cant.delete.property", Long.toString(longIndex), "sealed array");
    return false;
  }

  @Override
  public PropertyDescriptor getDescriptor(Global global, int index) {
    return global.newDataDescriptor(getObject(index), false, true, true);
  }

}
