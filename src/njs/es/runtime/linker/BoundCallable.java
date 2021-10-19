package es.runtime.linker;

import java.util.Arrays;

import es.runtime.ScriptRuntime;

/**
 * Represents a Nashorn callable bound to a receiver and optionally arguments.
 *
 * Note that objects of this class are just the tuples of a callable and a bound this and arguments, without any behavior.
 * All the behavior is defined in the {@code BoundCallableLinker}.
 */
public final class BoundCallable {

  private final Object callable;
  private final Object boundThis;
  private final Object[] boundArgs;

  BoundCallable(Object callable, Object boundThis, Object[] boundArgs) {
    this.callable = callable;
    this.boundThis = boundThis;
    this.boundArgs = isEmptyArray(boundArgs) ? ScriptRuntime.EMPTY_ARRAY : boundArgs.clone();
  }

  BoundCallable(BoundCallable original, Object[] extraBoundArgs) {
    this.callable = original.callable;
    this.boundThis = original.boundThis;
    this.boundArgs = original.concatenateBoundArgs(extraBoundArgs);
  }

  Object getCallable() {
    return callable;
  }

  Object getBoundThis() {
    return boundThis;
  }

  Object[] getBoundArgs() {
    return boundArgs;
  }

  BoundCallable bind(Object[] extraBoundArgs) {
    if (isEmptyArray(extraBoundArgs)) {
      return this;
    }
    return new BoundCallable(this, extraBoundArgs);
  }

  Object[] concatenateBoundArgs(Object[] extraBoundArgs) {
    if (boundArgs.length == 0) {
      return extraBoundArgs.clone();
    }
    var origBoundArgsLen = boundArgs.length;
    var extraBoundArgsLen = extraBoundArgs.length;
    var newBoundArgs = new Object[origBoundArgsLen + extraBoundArgsLen];
    System.arraycopy(boundArgs, 0, newBoundArgs, 0, origBoundArgsLen);
    System.arraycopy(extraBoundArgs, 0, newBoundArgs, origBoundArgsLen, extraBoundArgsLen);
    return newBoundArgs;
  }

  static boolean isEmptyArray(Object[] a) {
    return a == null || a.length == 0;
  }

  @Override
  public String toString() {
    var b = new StringBuilder(callable.toString()).append(" on ").append(boundThis);
    if (boundArgs.length != 0) {
      b.append(" with ").append(Arrays.toString(boundArgs));
    }
    return b.toString();
  }

}
