package es.runtime.arrays;

import es.runtime.Context;
import es.runtime.ScriptRuntime;
import es.runtime.linker.Bootstrap;

/**
 * Helper class for the various map/apply functions in {@link es.objects.NativeArray}.
 * @param <T> element type of results from application callback
 */
public abstract class IteratorAction<T> {

  // Self object
  protected final Object self;

  // This for the callback invocation
  protected Object thisArg;

  // Callback function to be applied to elements
  protected final Object callbackfn;

  // Result of array iteration
  protected T result;

  // Current array index of iterator
  protected long index;

  // Iterator object
  private final ArrayLikeIterator<Object> iter;

  /**
   * Constructor
   *
   * @param self          self reference to array object
   * @param callbackfn    callback function for each element
   * @param thisArg       the reference
   * @param initialResult result accumulator initialization
   */
  public IteratorAction(Object self, Object callbackfn, Object thisArg, T initialResult) {
    this(self, callbackfn, thisArg, initialResult, ArrayLikeIterator.arrayLikeIterator(self));
  }

  /**
   * Constructor
   *
   * @param self          self reference to array object
   * @param callbackfn    callback function for each element
   * @param thisArg       the reference
   * @param initialResult result accumulator initialization
   * @param iter          custom element iterator
   */
  public IteratorAction(Object self, Object callbackfn, Object thisArg, T initialResult, ArrayLikeIterator<Object> iter) {
    this.self = self;
    this.callbackfn = callbackfn;
    this.result = initialResult;
    this.iter = iter;
    this.thisArg = thisArg;
  }

  /**
   * An action to be performed once at the start of the apply loop
   * @param iterator array element iterator
   */
  protected void applyLoopBegin(ArrayLikeIterator<Object> iterator) {
    //empty
  }

  /**
   * Apply action main loop.
   * @return result of apply
   */
  public final T apply() {
    // for non-strict callback, need to translate undefined thisArg to be global object
    thisArg = (thisArg == ScriptRuntime.UNDEFINED && !Bootstrap.isCallable(callbackfn)) ? Context.getGlobal() : thisArg;
    applyLoopBegin(iter);
    var reverse = iter.isReverse();
    while (iter.hasNext()) {
      var val = iter.next();
      index = iter.nextIndex() + (reverse ? 1 : -1);
      try {
        if (!forEach(val, index)) {
          return result;
        }
      } catch (RuntimeException | Error e) {
        throw e;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
    }
    return result;
  }

  /**
   * For each callback
   * @param val value
   * @param i   position of value
   * @return true if callback invocation return true
   * @throws Throwable if invocation throws an exception/error
   */
  protected abstract boolean forEach(Object val, double i) throws Throwable;

}
