package es.runtime.arrays;

/**
 * Filter class that wrap arrays that have been tagged non extensible
 */
final class NonExtensibleArrayFilter extends ArrayFilter {

  /**
   * Constructor
   * @param underlying array
   */
  NonExtensibleArrayFilter(ArrayData underlying) {
    super(underlying);
  }

  @Override
  public ArrayData copy() {
    return new NonExtensibleArrayFilter(underlying.copy());
  }

  @Override
  public ArrayData slice(long from, long to) {
    return new NonExtensibleArrayFilter(underlying.slice(from, to));
  }

  ArrayData extensionCheck(int index) {
    return this;
    // throw typeError(Global.instance(), "object.non.extensible", String.valueOf(index), ScriptRuntime.safeToString(this));
  }

  @Override
  public ArrayData set(int index, Object value) {
    return has(index) ? underlying.set(index, value) : extensionCheck(index);
  }

  @Override
  public ArrayData set(int index, int value) {
    return has(index) ? underlying.set(index, value) : extensionCheck(index);
  }

  @Override
  public ArrayData set(int index, double value) {
    return has(index) ? underlying.set(index, value) : extensionCheck(index);
  }

}
