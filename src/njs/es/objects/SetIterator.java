package es.objects;

import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.runtime.PropertyMap;
import es.runtime.ScriptRuntime;
import es.runtime.Undefined;

import static es.runtime.ECMAErrors.typeError;

/**
 * ECMA6 23.2.5 Set Iterator Objects
 */
@ScriptClass("SetIterator")
public class SetIterator extends AbstractIterator {

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  private LinkedMap.LinkedMapIterator iterator;

  private final IterationKind iterationKind;

  // Cached global needed for every iteration result
  private final Global global;

  SetIterator(NativeSet set, IterationKind iterationKind, Global global) {
    super(global.getSetIteratorPrototype(), $nasgenmap$);
    this.iterator = set.getJavaMap().getIterator();
    this.iterationKind = iterationKind;
    this.global = global;
  }

  /**
   * ES6 23.2.5.2.1 %SetIteratorPrototype%.next()
   * @param self the self reference
   * @param arg the argument
   * @return the next result
   */
  @Function
  public static Object next(Object self, Object arg) {
    if (!(self instanceof SetIterator)) {
      throw typeError("not.a.set.iterator", ScriptRuntime.safeToString(self));
    }
    return ((SetIterator) self).next(arg);
  }

  @Override
  public String getClassName() {
    return "Set Iterator";
  }

  @Override
  protected IteratorResult next(Object arg) {
    if (iterator == null) {
      return makeResult(Undefined.getUndefined(), Boolean.TRUE, global);
    }
    var node = iterator.next();
    if (node == null) {
      iterator = null;
      return makeResult(Undefined.getUndefined(), Boolean.TRUE, global);
    }
    if (iterationKind == IterationKind.KEY_VALUE) {
      var array = new NativeArray(new Object[]{node.getKey(), node.getKey()});
      return makeResult(array, Boolean.FALSE, global);
    }
    return makeResult(node.getKey(), Boolean.FALSE, global);
  }

}
