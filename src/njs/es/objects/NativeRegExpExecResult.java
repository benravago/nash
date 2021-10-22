package es.objects;

import es.objects.annotations.Attribute;
import es.objects.annotations.Getter;
import es.objects.annotations.Property;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.Setter;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.arrays.ArrayData;
import es.runtime.regexp.RegExpResult;

/**
 * Objects of this class are used to represent return values from RegExp.prototype.exec method.
 */
@ScriptClass("RegExpExecResult")
public final class NativeRegExpExecResult extends ScriptObject {

  /** index property */
  @Property
  public Object index;

  /** input property */
  @Property
  public Object input;

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  NativeRegExpExecResult(RegExpResult result, Global global) {
    super(global.getArrayPrototype(), $nasgenmap$);
    setIsArray();
    this.setArray(ArrayData.allocate(result.getGroups().clone()));
    this.index = result.getIndex();
    this.input = result.getInput();
  }

  @Override
  public String getClassName() {
    return "Array";
  }

  /**
   * Length getter
   * @param self self reference
   * @return length property value
   */
  @Getter(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_CONFIGURABLE)
  public static Object length(Object self) {
    return (self instanceof ScriptObject) ? (double) JSType.toUint32(((ScriptObject) self).getArray().length()) : 0;
  }

  /**
   * Length setter
   * @param self self reference
   * @param length property value
   */
  @Setter(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_CONFIGURABLE)
  public static void length(Object self, Object length) {
    if (self instanceof ScriptObject so) {
      so.setLength(NativeArray.validLength(length));
    }
  }

}
