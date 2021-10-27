package es.runtime;

import java.util.AbstractList;
import java.util.Deque;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.RandomAccess;
import java.util.concurrent.Callable;

import java.lang.invoke.MethodHandle;

import nash.scripting.JSObject;
import nash.scripting.ScriptObjectMirror;

import es.objects.Global;
import es.runtime.linker.Bootstrap;

/**
 * An adapter that can wrap any ECMAScript Array-like object (that adheres to the array rules for the property {@code length} and having conforming {@code push}, {@code pop}, {@code shift}, {@code unshift}, and {@code splice} methods) and expose it as both a Java list and double-ended queue.
 * While script arrays aren't necessarily efficient as dequeues, it's still slightly more efficient to be able to translate dequeue operations into pushes, pops, shifts, and unshifts, than to blindly translate all list's add/remove operations into splices.
 * Also, it is conceivable that a custom script object that implements an Array-like API can have a background data representation that is optimized for dequeue-like access.
 * Note that with ECMAScript arrays, {@code push} and {@code pop} operate at the end of the array, while in Java {@code Deque} they operate on the front of the queue and as such the Java dequeue {@link #push(Object)} and {@link #pop()} operations will translate to {@code unshift} and {@code shift} script operations respectively, while {@link #addLast(Object)} and {@link #removeLast()} will translate to {@code push} and {@code pop}.
 */
public class ListAdapter extends AbstractList<Object> implements RandomAccess, Deque<Object> {

  // Invoker creator for methods that add to the start or end of the list: PUSH and UNSHIFT. Takes fn, this, and value, returns void.
  private static final Callable<MethodHandle> ADD_INVOKER_CREATOR = invokerCreator(void.class, Object.class, JSObject.class, Object.class);

  // PUSH adds to the start of the list
  private static final Object PUSH = new Object();
  // UNSHIFT adds to the end of the list
  private static final Object UNSHIFT = new Object();

  // Invoker creator for methods that remove from the tail or head of the list: POP and SHIFT. Takes fn, this, returns Object.
  private static final Callable<MethodHandle> REMOVE_INVOKER_CREATOR = invokerCreator(Object.class, Object.class, JSObject.class);

  // POP removes from the start of the list
  private static final Object POP = new Object();
  // SHIFT removes from the end of the list
  private static final Object SHIFT = new Object();

  // SPLICE can be used to add a value in the middle of the list.
  private static final Object SPLICE_ADD = new Object();
  private static final Callable<MethodHandle> SPLICE_ADD_INVOKER_CREATOR = invokerCreator(void.class, Object.class, JSObject.class, int.class, int.class, Object.class);

  // SPLICE can also be used to remove values from the middle of the list.
  private static final Object SPLICE_REMOVE = new Object();
  private static final Callable<MethodHandle> SPLICE_REMOVE_INVOKER_CREATOR = invokerCreator(void.class, Object.class, JSObject.class, int.class, int.class);

  // wrapped object
  final JSObject obj;
  private final Global global;

  // allow subclasses only in this package
  ListAdapter(JSObject obj, Global global) {
    if (global == null) {
      throw new IllegalStateException(ECMAErrors.getMessage("list.adapter.null.global"));
    }
    this.obj = obj;
    this.global = global;
  }

  /**
   * Factory to create a ListAdapter for a given script object.
   * @param obj script object to wrap as a ListAdapter
   * @return A ListAdapter wrapper object
   */
  public static ListAdapter create(Object obj) {
    var global = Context.getGlobal();
    return new ListAdapter(getJSObject(obj, global), global);
  }

  static JSObject getJSObject(Object obj, Global global) {
    if (obj instanceof ScriptObject) {
      return (JSObject) ScriptObjectMirror.wrap(obj, global);
    } else if (obj instanceof JSObject jso) {
      return jso;
    }
    throw new IllegalArgumentException("ScriptObject or JSObject expected");
  }

  @Override
  public final Object get(int index) {
    checkRange(index);
    return getAt(index);
  }

  Object getAt(int index) {
    return obj.getSlot(index);
  }

  @Override
  public Object set(int index, Object element) {
    checkRange(index);
    var prevValue = getAt(index);
    obj.setSlot(index, element);
    return prevValue;
  }

  void checkRange(int index) {
    if (index < 0 || index >= size()) {
      throw invalidIndex(index);
    }
  }

  @Override
  public int size() {
    return JSType.toInt32(obj.getMember("length"));
  }

  @Override
  public final void push(Object e) {
    addFirst(e);
  }

  @Override
  public final boolean add(Object e) {
    addLast(e);
    return true;
  }

  @Override
  public final void addFirst(Object e) {
    try {
      getDynamicInvoker(UNSHIFT, ADD_INVOKER_CREATOR).invokeExact(getFunction("unshift"), obj, e);
    } catch (RuntimeException | Error ex) {
      throw ex;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  @Override
  public final void addLast(Object e) {
    try {
      getDynamicInvoker(PUSH, ADD_INVOKER_CREATOR).invokeExact(getFunction("push"), obj, e);
    } catch (RuntimeException | Error ex) {
      throw ex;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  @Override
  public final void add(int index, Object e) {
    try {
      if (index < 0) {
        throw invalidIndex(index);
      } else if (index == 0) {
        addFirst(e);
      } else {
        var size = size();
        if (index < size) {
          getDynamicInvoker(SPLICE_ADD, SPLICE_ADD_INVOKER_CREATOR).invokeExact(obj.getMember("splice"), obj, index, 0, e);
        } else if (index == size) {
          addLast(e);
        } else {
          throw invalidIndex(index);
        }
      }
    } catch (RuntimeException | Error ex) {
      throw ex;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  Object getFunction(String name) {
    var fn = obj.getMember(name);
    if (!(Bootstrap.isCallable(fn))) {
      throw new UnsupportedOperationException("The script object doesn't have a function named " + name);
    }
    return fn;
  }

  static IndexOutOfBoundsException invalidIndex(int index) {
    return new IndexOutOfBoundsException(String.valueOf(index));
  }

  @Override
  public final boolean offer(Object e) {
    return offerLast(e);
  }

  @Override
  public final boolean offerFirst(Object e) {
    addFirst(e);
    return true;
  }

  @Override
  public final boolean offerLast(Object e) {
    addLast(e);
    return true;
  }

  @Override
  public final Object pop() {
    return removeFirst();
  }

  @Override
  public final Object remove() {
    return removeFirst();
  }

  @Override
  public final Object removeFirst() {
    checkNonEmpty();
    return invokeShift();
  }

  @Override
  public final Object removeLast() {
    checkNonEmpty();
    return invokePop();
  }

  private void checkNonEmpty() {
    if (isEmpty()) {
      throw new NoSuchElementException();
    }
  }

  @Override
  public final Object remove(int index) {
    if (index < 0) {
      throw invalidIndex(index);
    } else if (index == 0) {
      return invokeShift();
    } else {
      var maxIndex = size() - 1;
      if (index < maxIndex) {
        var prevValue = get(index);
        invokeSpliceRemove(index, 1);
        return prevValue;
      } else if (index == maxIndex) {
        return invokePop();
      } else {
        throw invalidIndex(index);
      }
    }
  }

  Object invokeShift() {
    try {
      return getDynamicInvoker(SHIFT, REMOVE_INVOKER_CREATOR).invokeExact(getFunction("shift"), obj);
    } catch (RuntimeException | Error ex) {
      throw ex;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  Object invokePop() {
    try {
      return getDynamicInvoker(POP, REMOVE_INVOKER_CREATOR).invokeExact(getFunction("pop"), obj);
    } catch (RuntimeException | Error ex) {
      throw ex;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  @Override
  protected final void removeRange(int fromIndex, int toIndex) {
    invokeSpliceRemove(fromIndex, toIndex - fromIndex);
  }

  void invokeSpliceRemove(int fromIndex, int count) {
    try {
      getDynamicInvoker(SPLICE_REMOVE, SPLICE_REMOVE_INVOKER_CREATOR).invokeExact(getFunction("splice"), obj, fromIndex, count);
    } catch (RuntimeException | Error ex) {
      throw ex;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  @Override
  public final Object poll() {
    return pollFirst();
  }

  @Override
  public final Object pollFirst() {
    return isEmpty() ? null : invokeShift();
  }

  @Override
  public final Object pollLast() {
    return isEmpty() ? null : invokePop();
  }

  @Override
  public final Object peek() {
    return peekFirst();
  }

  @Override
  public final Object peekFirst() {
    return isEmpty() ? null : get(0);
  }

  @Override
  public final Object peekLast() {
    return isEmpty() ? null : get(size() - 1);
  }

  @Override
  public final Object element() {
    return getFirst();
  }

  @Override
  public final Object getFirst() {
    checkNonEmpty();
    return get(0);
  }

  @Override
  public final Object getLast() {
    checkNonEmpty();
    return get(size() - 1);
  }

  @Override
  public final Iterator<Object> descendingIterator() {
    return new Iterator<>() {
      final ListIterator<Object> it = listIterator(size());
      @Override public boolean hasNext() { return it.hasPrevious(); }
      @Override public Object next() { return it.previous(); }
      @Override public void remove() { it.remove(); }
    };
  }

  @Override
  public final boolean removeFirstOccurrence(Object o) {
    return removeOccurrence(o, iterator());
  }

  @Override
  public final boolean removeLastOccurrence(Object o) {
    return removeOccurrence(o, descendingIterator());
  }

  static boolean removeOccurrence(Object o, Iterator<Object> it) {
    while (it.hasNext()) {
      if (Objects.equals(o, it.next())) {
        it.remove();
        return true;
      }
    }
    return false;
  }

  static Callable<MethodHandle> invokerCreator(Class<?> rtype, Class<?>... ptypes) {
    return () -> Bootstrap.createDynamicCallInvoker(rtype, ptypes);
  }

  MethodHandle getDynamicInvoker(Object key, Callable<MethodHandle> creator) {
    return global.getDynamicInvoker(key, creator);
  }

}
