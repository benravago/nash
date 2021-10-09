package es.objects;

import es.objects.annotations.Property;
import es.objects.annotations.ScriptClass;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;

@ScriptClass("IteratorResult")
public class IteratorResult extends ScriptObject {

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  IteratorResult(final Object value, final Boolean done, final Global global) {
    super(global.getObjectPrototype(), $nasgenmap$);
    this.value = value;
    this.done = done;
  }

  /**
   * The result value property.
   */
  @Property
  public Object value;

  /**
   * The result status property.
   */
  @Property
  public Object done;

}
