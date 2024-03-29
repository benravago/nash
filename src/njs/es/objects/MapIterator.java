package es.objects;

import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.runtime.PropertyMap;
import es.runtime.ScriptRuntime;
import es.runtime.Undefined;

import static es.runtime.ECMAErrors.typeError;

/**
 * ECMA6 23.1.5 Map Iterator Objects
 */
@ScriptClass("MapIterator")
public class MapIterator extends AbstractIterator {

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  private LinkedMap.LinkedMapIterator iterator;

  private final IterationKind iterationKind;

  // Cached global needed for each iteration result
  private final Global global;

  /**
   * Constructor for Map iterators.
   * @param map the map to iterate over
   * @param iterationKind the iteration kind
   * @param global the current global object
   */
  MapIterator(NativeMap map, IterationKind iterationKind, Global global) {
    super(global.getMapIteratorPrototype(), $nasgenmap$);
    this.iterator = map.getJavaMap().getIterator();
    this.iterationKind = iterationKind;
    this.global = global;
  }

  /**
   * ES6 23.1.5.2.1 %MapIteratorPrototype%.next()
   * @param self the self reference
   * @param arg the argument
   * @return the next result
   */
  @Function
  public static Object next(Object self, Object arg) {
    if (!(self instanceof MapIterator)) {
      throw typeError("not.a.map.iterator", ScriptRuntime.safeToString(self));
    }
    return ((MapIterator) self).next(arg);
  }

  @Override
  public String getClassName() {
    return "Map Iterator";
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
      var array = new NativeArray(new Object[]{node.getKey(), node.getValue()});
      return makeResult(array, Boolean.FALSE, global);
    }
    return makeResult(iterationKind == IterationKind.KEY ? node.getKey() : node.getValue(), Boolean.FALSE, global);
  }

}
