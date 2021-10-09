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
 * ECMA 15.11.6.1 EvalError
 *
 */
@ScriptClass("Error")
public final class NativeEvalError extends ScriptObject {

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
  private NativeEvalError(final Object msg, final ScriptObject proto, final PropertyMap map) {
    super(proto, map);
    if (msg != UNDEFINED) {
      this.instMessage = JSType.toString(msg);
    } else {
      this.delete(NativeError.MESSAGE, false);
    }
    NativeError.initException(this);
  }

  NativeEvalError(final Object msg, final Global global) {
    this(msg, global.getEvalErrorPrototype(), $nasgenmap$);
  }

  private NativeEvalError(final Object msg) {
    this(msg, Global.instance());
  }

  @Override
  public String getClassName() {
    return "Error";
  }

  /**
   * ECMA 15.11.6.1 EvalError
   *
   * Constructor
   *
   * @param newObj was this error instantiated with the new operator
   * @param self   self reference
   * @param msg    error message
   *
   * @return new EvalError
   */
  @Constructor(name = "EvalError")
  public static NativeEvalError constructor(final boolean newObj, final Object self, final Object msg) {
    return new NativeEvalError(msg);
  }
}
