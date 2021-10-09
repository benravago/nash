package es.runtime.arrays;

import java.util.NoSuchElementException;

/**
 * Dummy array iterator that has no elements
 */
final class EmptyArrayLikeIterator extends ArrayLikeIterator<Object> {

  EmptyArrayLikeIterator() {
    super(false);
  }

  @Override
  public boolean hasNext() {
    return false;
  }

  @Override
  public Object next() {
    throw new NoSuchElementException();
  }

  @Override
  public long getLength() {
    return 0;
  }
}
