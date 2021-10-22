package es.objects;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;

import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.Property;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.Where;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.linker.NashornGuards;
import es.runtime.linker.PrimitiveLookup;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.rangeError;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * ECMA 15.7 Number Objects.
 *
 */
@ScriptClass("Number")
public final class NativeNumber extends ScriptObject {

  // Method handle to create an object wrapper for a primitive number.
  static final MethodHandle WRAPFILTER = findOwnMH("wrapFilter", MH.type(NativeNumber.class, Object.class));

  // Method handle to retrieve the Number prototype object. 
  private static final MethodHandle PROTOFILTER = findOwnMH("protoFilter", MH.type(Object.class, Object.class));

  /** ECMA 15.7.3.2 largest positive finite value */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double MAX_VALUE = Double.MAX_VALUE;

  /** ECMA 15.7.3.3 smallest positive finite value */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double MIN_VALUE = Double.MIN_VALUE;

  /** ECMA 15.7.3.4 NaN */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double NaN = Double.NaN;

  /** ECMA 15.7.3.5 negative infinity */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double NEGATIVE_INFINITY = Double.NEGATIVE_INFINITY;

  /** ECMA 15.7.3.5 positive infinity */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double POSITIVE_INFINITY = Double.POSITIVE_INFINITY;

  private final double value;

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  NativeNumber(double value, ScriptObject proto, PropertyMap map) {
    super(proto, map);
    this.value = value;
  }

  NativeNumber(double value, Global global) {
    this(value, global.getNumberPrototype(), $nasgenmap$);
  }

  NativeNumber(double value) {
    this(value, Global.instance());
  }

  @Override
  public String safeToString() {
    return "[Number " + toString() + "]";
  }

  @Override
  public String toString() {
    return Double.toString(getValue());
  }

  /**
   * Get the value of this Number
   * @return a {@code double} representing the Number value
   */
  public double getValue() {
    return doubleValue();
  }

  /**
   * Get the value of this Number
   * @return a {@code double} representing the Number value
   */
  public double doubleValue() {
    return value;
  }

  @Override
  public String getClassName() {
    return "Number";
  }

  /**
   * ECMA 15.7.2 - The Number constructor
   * @param newObj is this Number instantiated with the new operator
   * @param self   self reference
   * @param args   value of number
   * @return the Number instance (internally represented as a {@code NativeNumber})
   */
  @Constructor(arity = 1)
  public static Object constructor(boolean newObj, Object self, Object... args) {
    var num = (args.length > 0) ? JSType.toNumber(args[0]) : 0.0;
    return newObj ? new NativeNumber(num) : num;
  }

  /**
   * TODO: not supported
   * ECMA 15.7.4.5 Number.prototype.toFixed (fractionDigits)
   * ECMA 15.7.4.5 Number.prototype.toFixed (fractionDigits) specialized for int fractionDigits
   * ECMA 15.7.4.6 Number.prototype.toExponential (fractionDigits)
   * ECMA 15.7.4.7 Number.prototype.toPrecision (precision)
   * ECMA 15.7.4.7 Number.prototype.toPrecision (precision) specialized f
   */

  /**
   * ECMA 15.7.4.2 Number.prototype.toString ( [ radix ] )
   * @param self  self reference
   * @param radix radix to use for string conversion
   * @return string representation of this Number in the given radix
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toString(Object self, Object radix) {
    if (radix != UNDEFINED) {
      var intRadix = JSType.toInteger(radix);
      if (intRadix != 10) {
        if (intRadix < 2 || intRadix > 36) {
          throw rangeError("invalid.radix");
        }
        return JSType.toString(getNumberValue(self), intRadix);
      }
    }
    return JSType.toString(getNumberValue(self));
  }

  /**
   * ECMA 15.7.4.3 Number.prototype.toLocaleString()
   * @param self self reference
   * @return localized string for this Number
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toLocaleString(Object self) {
    return JSType.toString(getNumberValue(self));
  }

  /**
   * ECMA 15.7.4.4 Number.prototype.valueOf ( )
   * @param self self reference
   * @return number value for this Number
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double valueOf(Object self) {
    return getNumberValue(self);
  }

  /**
   * Lookup the appropriate method for an invoke dynamic call.
   * @param request  The link request
   * @param receiver receiver of call
   * @return Link to be invoked at call site.
   */
  public static GuardedInvocation lookupPrimitive(LinkRequest request, Object receiver) {
    return PrimitiveLookup.lookupPrimitive(request, NashornGuards.getNumberGuard(), new NativeNumber(((Number) receiver).doubleValue()), WRAPFILTER, PROTOFILTER);
  }

  @SuppressWarnings("unused")
  static NativeNumber wrapFilter(Object receiver) {
    return new NativeNumber(((Number) receiver).doubleValue());
  }

  @SuppressWarnings("unused")
  static Object protoFilter(Object object) {
    return Global.instance().getNumberPrototype();
  }

  static double getNumberValue(Object self) {
    if (self instanceof Number n) {
      return n.doubleValue();
    } else if (self instanceof NativeNumber nn) {
      return nn.getValue();
    } else if (self != null && self == Global.instance().getNumberPrototype()) {
      return 0.0;
    } else {
      throw typeError("not.a.number", ScriptRuntime.safeToString(self));
    }
  }

  // Exponent of Java "e" or "E" formatter is always 2 digits and zero padded if needed (e+01, e+00, e+12 etc.)
  // JS expects exponent to contain exact number of digits e+1, e+0, e+12 etc. Fix the exponent here.
  // Additionally, if trimZeros is true, this cuts trailing zeros in the fraction part for calls to toExponential() with undefined fractionDigits argument.
  static String fixExponent(String str, boolean trimZeros) {
    var index = str.indexOf('e');
    if (index < 1) {
      // no exponent, do nothing..
      return str;
    }
    // check if character after e+ or e- is 0
    var expPadding = str.charAt(index + 2) == '0' ? 3 : 2;
    // check if there are any trailing zeroes we should remove
    var fractionOffset = index;
    if (trimZeros) {
      assert fractionOffset > 0;
      var c = str.charAt(fractionOffset - 1);
      while (fractionOffset > 1 && (c == '0' || c == '.')) {
        c = str.charAt(--fractionOffset - 1);
      }
    }
    // if anything needs to be done compose a new string
    return (fractionOffset < index || expPadding == 3) ? str.substring(0, fractionOffset) + str.substring(index, index + 2) + str.substring(index + expPadding) : str;
  }

  static MethodHandle findOwnMH(String name, MethodType type) {
    return MH.findStatic(MethodHandles.lookup(), NativeNumber.class, name, type);
  }

}
