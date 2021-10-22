package es.objects;

import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.runtime.PropertyMap;
import es.runtime.ScriptRuntime;
import es.runtime.Undefined;
import static es.runtime.ECMAErrors.typeError;

/**
 * ECMA6 21.1.5 String Iterator Objects
 */
@ScriptClass("StringIterator")
public class StringIterator extends AbstractIterator {

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  private String iteratedString;
  private int nextIndex = 0;
  private final Global global;

  StringIterator(String iteratedString, Global global) {
    super(global.getStringIteratorPrototype(), $nasgenmap$);
    this.iteratedString = iteratedString;
    this.global = global;
  }

  /**
   * ES6 21.1.5.2.1 %StringIteratorPrototype%.next()
   * @param self the self reference
   * @param arg the argument
   * @return the next result
   */
  @Function
  public static Object next(Object self, Object arg) {
    if (!(self instanceof StringIterator)) {
      throw typeError("not.a.string.iterator", ScriptRuntime.safeToString(self));
    }
    return ((StringIterator) self).next(arg);
  }

  @Override
  public String getClassName() {
    return "String Iterator";
  }

  @Override
  protected IteratorResult next(Object arg) {
    var index = nextIndex;
    var string = iteratedString;
    if (string == null || index >= string.length()) {
      // ES6 21.1.5.2.1 step 8
      iteratedString = null;
      return makeResult(Undefined.getUndefined(), Boolean.TRUE, global);
    }
    var first = string.charAt(index);
    if (first >= 0xd800 && first <= 0xdbff && index < string.length() - 1) {
      var second = string.charAt(index + 1);
      if (second >= 0xdc00 && second <= 0xdfff) {
        nextIndex += 2;
        return makeResult(String.valueOf(new char[]{first, second}), Boolean.FALSE, global);
      }
    }
    nextIndex++;
    return makeResult(String.valueOf(first), Boolean.FALSE, global);
  }

}
