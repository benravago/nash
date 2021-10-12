package es.objects;

import static es.runtime.ScriptRuntime.UNDEFINED;

import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Property;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.Where;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;

/**
 * ECMA 15.11.6.6 URIError
 */
@ScriptClass("Error")
public final class NativeURIError extends ScriptObject {

  /** message property in instance */
  @Property(name = NativeError.MESSAGE, attributes = Attribute.NOT_ENUMERABLE)
  public Object instMessage;

  /** error name property */
  @Property(attributes = Attribute.NOT_ENUMERABLE, where = Where.PROTOTYPE)
  public Object name;

  /** ECMA 15.1.1.1 message property */
  @Property(attributes = Attribute.NOT_ENUMERABLE, where = Where.PROTOTYPE)
  public Object message;

  /** Nashorn extension: underlying exception */
  @Property(attributes = Attribute.NOT_ENUMERABLE)
  public Object nashornException;

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  @SuppressWarnings("LeakingThisInConstructor")
  NativeURIError(final Object msg, final Global global) {
    super(global.getURIErrorPrototype(), $nasgenmap$);
    if (msg != UNDEFINED) {
      this.instMessage = JSType.toString(msg);
    } else {
      this.delete(NativeError.MESSAGE);
    }
    NativeError.initException(this);
  }

  private NativeURIError(final Object msg) {
    this(msg, Global.instance());
  }

  @Override
  public String getClassName() {
    return "Error";
  }

  /**
   * ECMA 15.11.6.6 URIError
   *
   * Constructor
   *
   * @param newObj was this error instantiated with the new operator
   * @param self   self reference
   * @param msg    error message
   *
   * @return new URIError
   */
  @Constructor(name = "URIError")
  public static NativeURIError constructor(final boolean newObj, final Object self, final Object msg) {
    return new NativeURIError(msg);
  }
}
