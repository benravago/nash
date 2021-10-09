package es.runtime.arrays;

import static es.runtime.ECMAErrors.typeError;

import es.objects.Global;
import es.runtime.PropertyDescriptor;

/**
 * ArrayData after the array has been sealed by Object.seal call.
 */
class SealedArrayFilter extends ArrayFilter {

  SealedArrayFilter(final ArrayData underlying) {
    super(underlying);
  }

  @Override
  public ArrayData copy() {
    return new SealedArrayFilter(underlying.copy());
  }

  @Override
  public ArrayData slice(final long from, final long to) {
    return getUnderlying().slice(from, to);
  }

  @Override
  public boolean canDelete(final int index, final boolean strict) {
    return canDelete(ArrayIndex.toLongIndex(index), strict);
  }

  @Override
  public boolean canDelete(final long longIndex, final boolean strict) {
    if (strict) {
      throw typeError("cant.delete.property", Long.toString(longIndex), "sealed array");
    }
    return false;
  }

  @Override
  public PropertyDescriptor getDescriptor(final Global global, final int index) {
    return global.newDataDescriptor(getObject(index), false, true, true);
  }
}
