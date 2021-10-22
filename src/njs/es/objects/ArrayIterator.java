package es.objects;

import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.Undefined;
import static es.runtime.ECMAErrors.typeError;

@ScriptClass("ArrayIterator")
public class ArrayIterator extends AbstractIterator {

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  private ScriptObject iteratedObject;
  private long nextIndex = 0L;
  private final IterationKind iterationKind;
  private final Global global;

  ArrayIterator(Object iteratedObject, IterationKind iterationKind, Global global) {
    super(global.getArrayIteratorPrototype(), $nasgenmap$);
    this.iteratedObject = iteratedObject instanceof ScriptObject ? (ScriptObject) iteratedObject : null;
    this.iterationKind = iterationKind;
    this.global = global;
  }

  static ArrayIterator newArrayValueIterator(Object iteratedObject) {
    return new ArrayIterator(Global.toObject(iteratedObject), IterationKind.VALUE, Global.instance());
  }

  static ArrayIterator newArrayKeyIterator(Object iteratedObject) {
    return new ArrayIterator(Global.toObject(iteratedObject), IterationKind.KEY, Global.instance());
  }

  static ArrayIterator newArrayKeyValueIterator(Object iteratedObject) {
    return new ArrayIterator(Global.toObject(iteratedObject), IterationKind.KEY_VALUE, Global.instance());
  }

  /**
   * 22.1.5.2.1 %ArrayIteratorPrototype%.next()
   * @param self the self reference
   * @param arg the argument
   * @return the next result
   */
  @Function
  public static Object next(Object self, Object arg) {
    if (!(self instanceof ArrayIterator)) {
      throw typeError("not.a.array.iterator", ScriptRuntime.safeToString(self));
    }
    return ((ArrayIterator) self).next(arg);
  }

  @Override
  public String getClassName() {
    return "Array Iterator";
  }

  @Override
  protected IteratorResult next(Object arg) {
    var index = nextIndex;
    if (iteratedObject == null || index >= JSType.toUint32(iteratedObject.getLength())) {
      // ES6 22.1.5.2.1 step 10
      iteratedObject = null;
      return makeResult(Undefined.getUndefined(), Boolean.TRUE, global);
    }
    nextIndex++;
    if (iterationKind == IterationKind.KEY_VALUE) {
      var value = new NativeArray(new Object[]{JSType.toNarrowestNumber(index), iteratedObject.get((double) index)});
      return makeResult(value, Boolean.FALSE, global);
    }
    var value = iterationKind == IterationKind.KEY ? JSType.toNarrowestNumber(index) : iteratedObject.get((double) index);
    return makeResult(value, Boolean.FALSE, global);
  }

}
