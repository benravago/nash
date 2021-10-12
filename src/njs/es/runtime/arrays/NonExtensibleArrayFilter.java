package es.runtime.arrays;

import static es.runtime.ECMAErrors.typeError;
import es.objects.Global;
import es.runtime.ScriptRuntime;

/**
 * Filter class that wrap arrays that have been tagged non extensible
 */
final class NonExtensibleArrayFilter extends ArrayFilter {

  /**
   * Constructor
   * @param underlying array
   */
  NonExtensibleArrayFilter(final ArrayData underlying) {
    super(underlying);
  }

  @Override
  public ArrayData copy() {
    return new NonExtensibleArrayFilter(underlying.copy());
  }

  @Override
  public ArrayData slice(final long from, final long to) {
    return new NonExtensibleArrayFilter(underlying.slice(from, to));
  }

  private ArrayData extensionCheck(final int index) {
      return this;
    // throw typeError(Global.instance(), "object.non.extensible", String.valueOf(index), ScriptRuntime.safeToString(this));
  }

  @Override
  public ArrayData set(final int index, final Object value) {
    if (has(index)) {
      return underlying.set(index, value);
    }
    return extensionCheck(index);
  }

  @Override
  public ArrayData set(final int index, final int value) {
    if (has(index)) {
      return underlying.set(index, value);
    }
    return extensionCheck(index);
  }

  @Override
  public ArrayData set(final int index, final double value) {
    if (has(index)) {
      return underlying.set(index, value);
    }
    return extensionCheck(index);
  }
}
