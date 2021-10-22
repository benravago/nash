package es.objects;

import es.objects.annotations.Attribute;
import es.objects.annotations.Function;
import es.objects.annotations.Property;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.SpecializedFunction;
import es.objects.annotations.Where;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;

/**
 * ECMA 15.8 The Math Object
 *
 */
@ScriptClass("Math")
public final class NativeMath extends ScriptObject {

  // initialized by nasgen
  @SuppressWarnings("unused")
  static PropertyMap $nasgenmap$;

  /** ECMA 15.8.1.1 - E, always a double constant. Not writable or configurable */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double E = Math.E;

  /** ECMA 15.8.1.2 - LN10, always a double constant. Not writable or configurable */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double LN10 = 2.302585092994046;

  /** ECMA 15.8.1.3 - LN2, always a double constant. Not writable or configurable */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double LN2 = 0.6931471805599453;

  /** ECMA 15.8.1.4 - LOG2E, always a double constant. Not writable or configurable */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double LOG2E = 1.4426950408889634;

  /** ECMA 15.8.1.5 - LOG10E, always a double constant. Not writable or configurable */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double LOG10E = 0.4342944819032518;

  /** ECMA 15.8.1.6 - PI, always a double constant. Not writable or configurable */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double PI = Math.PI;

  /** ECMA 15.8.1.7 - SQRT1_2, always a double constant. Not writable or configurable */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double SQRT1_2 = 0.7071067811865476;

  /** ECMA 15.8.1.8 - SQRT2, always a double constant. Not writable or configurable */
  @Property(attributes = Attribute.NON_ENUMERABLE_CONSTANT, where = Where.CONSTRUCTOR)
  public static final double SQRT2 = 1.4142135623730951;

  /**
   * ECMA 15.8.2.1 abs(x)
   * @param self  self reference
   * @param x     argument
   * @return abs of value
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double abs(Object self, Object x) {
    return Math.abs(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.1 abs(x) - specialization for int values
   * @param self  self reference
   * @param x     argument
   * @return abs of argument
   */
  @SpecializedFunction
  public static double abs(Object self, int x) {
    return x == Integer.MIN_VALUE ? Math.abs((double) x) : Math.abs(x);
  }

  /**
   * ECMA 15.8.2.1 abs(x) - specialization for long values
   * @param self  self reference
   * @param x     argument
   * @return abs of argument
   */
  @SpecializedFunction
  public static long abs(Object self, long x) {
    return Math.abs(x);
  }

  /**
   * ECMA 15.8.2.1 abs(x) - specialization for double values
   * @param self  self reference
   * @param x     argument
   * @return abs of argument
   */
  @SpecializedFunction
  public static double abs(Object self, double x) {
    return Math.abs(x);
  }

  /**
   * ECMA 15.8.2.2 acos(x)
   * @param self  self reference
   * @param x     argument
   * @return acos of argument
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double acos(Object self, Object x) {
    return Math.acos(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.2 acos(x) - specialization for double values
   * @param self  self reference
   * @param x     argument
   * @return acos of argument
   */
  @SpecializedFunction
  public static double acos(Object self, double x) {
    return Math.acos(x);
  }

  /**
   * ECMA 15.8.2.3 asin(x)
   * @param self  self reference
   * @param x     argument
   * @return asin of argument
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double asin(Object self, Object x) {
    return Math.asin(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.3 asin(x) - specialization for double values
   * @param self  self reference
   * @param x     argument
   * @return asin of argument
   */
  @SpecializedFunction
  public static double asin(Object self, double x) {
    return Math.asin(x);
  }

  /**
   * ECMA 15.8.2.4 atan(x)
   * @param self  self reference
   * @param x     argument
   * @return atan of argument
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double atan(Object self, Object x) {
    return Math.atan(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.4 atan(x) - specialization for double values
   * @param self  self reference
   * @param x     argument
   * @return atan of argument
   */
  @SpecializedFunction
  public static double atan(Object self, double x) {
    return Math.atan(x);
  }

  /**
   * ECMA 15.8.2.5 atan2(x,y)
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return atan2 of x and y
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double atan2(Object self, Object y, Object x) {
    return Math.atan2(JSType.toNumber(y), JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.5 atan2(x,y) - specialization for double values
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return atan2 of x and y
   */
  @SpecializedFunction
  public static double atan2(Object self, double y, double x) {
    return Math.atan2(y, x);
  }

  /**
   * ECMA 15.8.2.6 ceil(x)
   * @param self  self reference
   * @param x     argument
   * @return ceil of argument
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double ceil(Object self, Object x) {
    return Math.ceil(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.6 ceil(x) - specialized version for ints
   * @param self  self reference
   * @param x     argument
   * @return ceil of argument
   */
  @SpecializedFunction
  public static int ceil(Object self, int x) {
    return x;
  }

  /**
   * ECMA 15.8.2.6 ceil(x) - specialized version for longs
   * @param self  self reference
   * @param x     argument
   * @return ceil of argument
   */
  @SpecializedFunction
  public static long ceil(Object self, long x) {
    return x;
  }

  /**
   * ECMA 15.8.2.6 ceil(x) - specialized version for doubles
   * @param self  self reference
   * @param x     argument
   * @return ceil of argument
   */
  @SpecializedFunction
  public static double ceil(Object self, double x) {
    return Math.ceil(x);
  }

  /**
   * ECMA 15.8.2.7 cos(x)
   * @param self  self reference
   * @param x     argument
   * @return cos of argument
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double cos(Object self, Object x) {
    return Math.cos(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.7 cos(x) - specialized version for doubles
   * @param self  self reference
   * @param x     argument
   * @return cos of argument
   */
  @SpecializedFunction
  public static double cos(Object self, double x) {
    return Math.cos(x);
  }

  /**
   * ECMA 15.8.2.8 exp(x)
   * @param self  self reference
   * @param x     argument
   * @return exp of argument
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double exp(Object self, Object x) {
    return Math.exp(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.9 floor(x)
   * @param self  self reference
   * @param x     argument
   * @return floor of argument
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double floor(Object self, Object x) {
    return Math.floor(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.9 floor(x) - specialized version for ints
   * @param self  self reference
   * @param x     argument
   * @return floor of argument
   */
  @SpecializedFunction
  public static int floor(Object self, int x) {
    return x;
  }

  /**
   * ECMA 15.8.2.9 floor(x) - specialized version for longs
   * @param self  self reference
   * @param x     argument
   * @return floor of argument
   */
  @SpecializedFunction
  public static long floor(Object self, long x) {
    return x;
  }

  /**
   * ECMA 15.8.2.9 floor(x) - specialized version for doubles
   * @param self  self reference
   * @param x     argument
   * @return floor of argument
   */
  @SpecializedFunction
  public static double floor(Object self, double x) {
    return Math.floor(x);
  }

  /**
   * ECMA 15.8.2.10 log(x)
   * @param self  self reference
   * @param x     argument
   * @return log of argument
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double log(Object self, Object x) {
    return Math.log(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.10 log(x) - specialized version for doubles
   * @param self  self reference
   * @param x     argument
   * @return log of argument
   */
  @SpecializedFunction
  public static double log(Object self, double x) {
    return Math.log(x);
  }

  /**
   * ECMA 15.8.2.11 max(x)
   * @param self  self reference
   * @param args  arguments
   * @return the largest of the arguments, {@link Double#NEGATIVE_INFINITY} if no args given, or identity if one arg is given
   */
  @Function(arity = 2, attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double max(Object self, Object... args) {
    return switch (args.length) {
      case 0 -> Double.NEGATIVE_INFINITY;
      case 1 -> JSType.toNumber(args[0]);
      default -> {
        var res = JSType.toNumber(args[0]);
        for (var i = 1; i < args.length; i++) {
          res = Math.max(res, JSType.toNumber(args[i]));
        }
        yield res;
      }
    };
  }

  /**
   * ECMA 15.8.2.11 max(x) - specialized no args version
   * @param self  self reference
   * @return {@link Double#NEGATIVE_INFINITY}
   */
  @SpecializedFunction
  public static double max(Object self) {
    return Double.NEGATIVE_INFINITY;
  }

  /**
   * ECMA 15.8.2.11 max(x) - specialized version for ints
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return largest value of x and y
   */
  @SpecializedFunction
  public static int max(Object self, int x, int y) {
    return Math.max(x, y);
  }

  /**
   * ECMA 15.8.2.11 max(x) - specialized version for longs
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return largest value of x and y
   */
  @SpecializedFunction
  public static long max(Object self, long x, long y) {
    return Math.max(x, y);
  }

  /**
   * ECMA 15.8.2.11 max(x) - specialized version for doubles
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return largest value of x and y
   */
  @SpecializedFunction
  public static double max(Object self, double x, double y) {
    return Math.max(x, y);
  }

  /**
   * ECMA 15.8.2.11 max(x) - specialized version for two Object args
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return largest value of x and y
   */
  @SpecializedFunction
  public static double max(Object self, Object x, Object y) {
    return Math.max(JSType.toNumber(x), JSType.toNumber(y));
  }

  /**
   * ECMA 15.8.2.12 min(x)
   * @param self  self reference
   * @param args  arguments
   * @return the smallest of the arguments, {@link Double#NEGATIVE_INFINITY} if no args given, or identity if one arg is given
   */
  @Function(arity = 2, attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double min(Object self, Object... args) {
    return switch (args.length) {
      case 0 -> Double.POSITIVE_INFINITY;
      case 1 -> JSType.toNumber(args[0]);
      default -> {
        var res = JSType.toNumber(args[0]);
        for (var i = 1; i < args.length; i++) {
          res = Math.min(res, JSType.toNumber(args[i]));
        }
        yield res;
      }
    };
  }

  /**
   * ECMA 15.8.2.11 min(x) - specialized no args version
   * @param self  self reference
   * @return {@link Double#POSITIVE_INFINITY}
   */
  @SpecializedFunction
  public static double min(Object self) {
    return Double.POSITIVE_INFINITY;
  }

  /**
   * ECMA 15.8.2.12 min(x) - specialized version for ints
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return smallest value of x and y
   */
  @SpecializedFunction
  public static int min(Object self, int x, int y) {
    return Math.min(x, y);
  }

  /**
   * ECMA 15.8.2.12 min(x) - specialized version for longs
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return smallest value of x and y
   */
  @SpecializedFunction
  public static long min(Object self, long x, long y) {
    return Math.min(x, y);
  }

  /**
   * ECMA 15.8.2.12 min(x) - specialized version for doubles
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return smallest value of x and y
   */
  @SpecializedFunction
  public static double min(Object self, double x, double y) {
    return Math.min(x, y);
  }

  /**
   * ECMA 15.8.2.12 min(x) - specialized version for two Object args
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return smallest value of x and y
   */
  @SpecializedFunction
  public static double min(Object self, Object x, Object y) {
    return Math.min(JSType.toNumber(x), JSType.toNumber(y));
  }

  /**
   * ECMA 15.8.2.13 pow(x,y)
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return x raised to the power of y
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double pow(Object self, Object x, Object y) {
    return Math.pow(JSType.toNumber(x), JSType.toNumber(y));
  }

  /**
   * ECMA 15.8.2.13 pow(x,y) - specialized version for doubles
   * @param self  self reference
   * @param x     first argument
   * @param y     second argument
   * @return x raised to the power of y
   */
  @SpecializedFunction
  public static double pow(Object self, double x, double y) {
    return Math.pow(x, y);
  }

  /**
   * ECMA 15.8.2.14 random()
   * @param self  self reference
   * @return random number in the range [0..1)
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double random(Object self) {
    return Math.random();
  }

  /**
   * ECMA 15.8.2.15 round(x)
   * @param self  self reference
   * @param x     argument
   * @return x rounded
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double round(Object self, Object x) {
    var d = JSType.toNumber(x);
    return (Math.getExponent(d) >= 52) ? d : Math.copySign(Math.floor(d + 0.5), d);
  }

  /**
   * ECMA 15.8.2.16 sin(x)
   * @param self  self reference
   * @param x     argument
   * @return sin of x
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double sin(Object self, Object x) {
    return Math.sin(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.16 sin(x) - specialized version for doubles
   * @param self  self reference
   * @param x     argument
   * @return sin of x
   */
  @SpecializedFunction
  public static double sin(Object self, double x) {
    return Math.sin(x);
  }

  /**
   * ECMA 15.8.2.17 sqrt(x)
   * @param self  self reference
   * @param x     argument
   * @return sqrt of x
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double sqrt(Object self, Object x) {
    return Math.sqrt(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.17 sqrt(x) - specialized version for doubles
   * @param self  self reference
   * @param x     argument
   * @return sqrt of x
   */
  @SpecializedFunction
  public static double sqrt(Object self, double x) {
    return Math.sqrt(x);
  }

  /**
   * ECMA 15.8.2.18 tan(x)
   * @param self  self reference
   * @param x     argument
   * @return tan of x
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double tan(Object self, Object x) {
    return Math.tan(JSType.toNumber(x));
  }

  /**
   * ECMA 15.8.2.18 tan(x) - specialized version for doubles
   * @param self  self reference
   * @param x     argument
   * @return tan of x
   */
  @SpecializedFunction
  public static double tan(Object self, double x) {
    return Math.tan(x);
  }

}
