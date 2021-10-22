package es.objects;

import java.time.Instant;
import static java.lang.Double.*;

import java.util.Locale;
import java.util.TimeZone;

import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.SpecializedFunction;
import es.objects.annotations.Where;

import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.linker.Bootstrap;
import es.runtime.linker.InvokeByName;

import static es.runtime.ECMAErrors.rangeError;
import static es.runtime.ECMAErrors.typeError;

/**
 * ECMA 15.9 Date Objects
 *
 */
@ScriptClass("Date")
public final class NativeDate extends ScriptObject {

  private static final String INVALID_DATE = "Invalid Date";

  private static final int YEAR = 0;
  private static final int MONTH = 1;
  private static final int DAY = 2;
  private static final int HOUR = 3;
  private static final int MINUTE = 4;
  private static final int SECOND = 5;
  private static final int MILLISECOND = 6;

  private static final int FORMAT_DATE_TIME = 0;
  private static final int FORMAT_DATE = 1;
  private static final int FORMAT_TIME = 2;
  private static final int FORMAT_LOCAL_DATE_TIME = 3;
  private static final int FORMAT_LOCAL_DATE = 4;
  private static final int FORMAT_LOCAL_TIME = 5;

  // Constants defined in ECMA 15.9.1.10
  private static final int hoursPerDay = 24;
  private static final int minutesPerHour = 60;
  private static final int secondsPerMinute = 60;
  private static final int msPerSecond = 1_000;
  private static final int msPerMinute = 60_000;
  private static final double msPerHour = 3_600_000;
  private static final double msPerDay = 86_400_000;

  private static int[][] firstDayInMonth = {
    {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334}, // normal year
    {0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335} // leap year
  };

  private static String[] weekDays = {
    "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
  };

  private static String[] months = {
    "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  };

  private static final Object TO_ISO_STRING = new Object();

  static InvokeByName getTO_ISO_STRING() {
    return Global.instance().getInvokeByName(TO_ISO_STRING, () -> new InvokeByName("toISOString", ScriptObject.class, Object.class, Object.class));
  }

  private double time;
  private final TimeZone timezone;

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  NativeDate(double time, ScriptObject proto, PropertyMap map) {
    super(proto, map);
    var env = Global.getEnv();
    this.time = time;
    this.timezone = env._timezone;
  }

  NativeDate(double time, ScriptObject proto) {
    this(time, proto, $nasgenmap$);
  }

  NativeDate(double time, Global global) {
    this(time, global.getDatePrototype(), $nasgenmap$);
  }

  NativeDate(double time) {
    this(time, Global.instance());
  }

  NativeDate() {
    this(System.currentTimeMillis());
  }

  @Override
  public String getClassName() {
    return "Date";
  }

  // ECMA 8.12.8 [[DefaultValue]] (hint)
  @Override
  public Object getDefaultValue(Class<?> hint) {
    // When the [[DefaultValue]] internal method of O is called with no hint, then it behaves as if the hint were Number, unless O is a Date object in which case it behaves as if the hint were String.
    return super.getDefaultValue(hint == null ? String.class : hint);
  }

  /**
   * Constructor - ECMA 15.9.3.1 new Date
   * @param isNew is this Date constructed with the new operator
   * @param self  self references
   * @return Date representing now
   */
  @SpecializedFunction(isConstructor = true)
  public static Object construct(boolean isNew, Object self) {
    var result = new NativeDate();
    return isNew ? result : toStringImpl(result, FORMAT_DATE_TIME);
  }

  /**
   * Constructor - ECMA 15.9.3.1 new Date (year, month [, date [, hours [, minutes [, seconds [, ms ] ] ] ] ] )
   * @param isNew is this Date constructed with the new operator
   * @param self  self reference
   * @param args  arguments
   * @return new Date
   */
  @Constructor(arity = 7)
  public static Object construct(boolean isNew, Object self, Object... args) {
    if (!isNew) {
      return toStringImpl(new NativeDate(), FORMAT_DATE_TIME);
    }
    NativeDate result;
    switch (args.length) {
      case 0 -> {
        result = new NativeDate();
      }
      case 1 -> {
        double num;
        var arg = JSType.toPrimitive(args[0]);
        if (JSType.isString(arg)) {
          num = parseDateString(arg.toString());
        } else {
          num = timeClip(JSType.toNumber(args[0]));
        }
        result = new NativeDate(num);
      }
      default -> {
        result = new NativeDate(0);
        var d = convertCtorArgs(args);
        if (d == null) {
          result.setTime(Double.NaN);
        } else {
          var time = timeClip(utc(makeDate(d), result.getTimeZone()));
          result.setTime(time);
        }
      }
    }

    return result;
  }

  @Override
  public String safeToString() {
    var str = isValidDate() ? toISOStringImpl(this) : INVALID_DATE;
    return "[Date " + str + "]";
  }

  @Override
  public String toString() {
    return isValidDate() ? toString(this) : INVALID_DATE;
  }

  /**
   * ECMA 15.9.4.2 Date.parse (string)
   * @param self self reference
   * @param string string to parse as date
   * @return Date interpreted from the string, or NaN for illegal values
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double parse(Object self, Object string) {
    return parseDateString(JSType.toString(string));
  }

  /**
   * ECMA 15.9.4.3 Date.UTC (year, month [, date [, hours [, minutes [, seconds [, ms ] ] ] ] ] )
   * @param self self reference
   * @param args mandatory args are year, month. Optional are date, hours, minutes, seconds and milliseconds
   * @return a time clip according to the ECMA specification
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 7, where = Where.CONSTRUCTOR)
  public static double UTC(Object self, Object... args) {
    var nd = new NativeDate(0);
    var d = convertCtorArgs(args);
    var time = d == null ? Double.NaN : timeClip(makeDate(d));
    nd.setTime(time);
    return time;
  }

  /**
   * ECMA 15.9.4.4 Date.now ( )
   * @param self self reference
   * @return a Date that points to the current moment in time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static double now(Object self) {
    // convert to double as long does not represent the primitive JS number type
    return (double) System.currentTimeMillis();
  }

  /**
   * ECMA 15.9.5.2 Date.prototype.toString ( )
   * @param self self reference
   * @return string value that represents the Date in the current time zone
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toString(Object self) {
    return toStringImpl(self, FORMAT_DATE_TIME);
  }

  /**
   * ECMA 15.9.5.3 Date.prototype.toDateString ( )
   * @param self self reference
   * @return string value with the "date" part of the Date in the current time zone
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toDateString(Object self) {
    return toStringImpl(self, FORMAT_DATE);
  }

  /**
   * ECMA 15.9.5.4 Date.prototype.toTimeString ( )
   * @param self self reference
   * @return string value with "time" part of Date in the current time zone
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toTimeString(Object self) {
    return toStringImpl(self, FORMAT_TIME);
  }

  /**
   * ECMA 15.9.5.5 Date.prototype.toLocaleString ( )
   * @param self self reference
   * @return string value that represents the Data in the current time zone and locale
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toLocaleString(Object self) {
    return toStringImpl(self, FORMAT_LOCAL_DATE_TIME);
  }

  /**
   * ECMA 15.9.5.6 Date.prototype.toLocaleDateString ( )
   * @param self self reference
   * @return string value with the "date" part of the Date in the current time zone and locale
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toLocaleDateString(Object self) {
    return toStringImpl(self, FORMAT_LOCAL_DATE);
  }

  /**
   * ECMA 15.9.5.7 Date.prototype.toLocaleTimeString ( )
   * @param self self reference
   * @return string value with the "time" part of Date in the current time zone and locale
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toLocaleTimeString(Object self) {
    return toStringImpl(self, FORMAT_LOCAL_TIME);
  }

  /**
   * ECMA 15.9.5.8 Date.prototype.valueOf ( )
   * @param self self reference
   * @return valueOf - a number which is this time value
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double valueOf(Object self) {
    var nd = getNativeDate(self);
    return (nd != null) ? nd.getTime() : Double.NaN;
  }

  /**
   * ECMA 15.9.5.9 Date.prototype.getTime ( )
   *
   * @param self self reference
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getTime(Object self) {
    var nd = getNativeDate(self);
    return (nd != null) ? nd.getTime() : Double.NaN;
  }

  /**
   * ECMA 15.9.5.10 Date.prototype.getFullYear ( )
   * @param self self reference
   * @return full year
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object getFullYear(Object self) {
    return getField(self, YEAR);
  }

  /**
   * ECMA 15.9.5.11 Date.prototype.getUTCFullYear( )
   *
   * @param self self reference
   * @return UTC full year
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getUTCFullYear(Object self) {
    return getUTCField(self, YEAR);
  }

  /**
   * B.2.4 Date.prototype.getYear ( )
   *
   * @param self self reference
   * @return year
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getYear(Object self) {
    var nd = getNativeDate(self);
    return (nd != null && nd.isValidDate()) ? (yearFromTime(nd.getLocalTime()) - 1900) : Double.NaN;
  }

  /**
   * ECMA 15.9.5.12 Date.prototype.getMonth ( )
   *
   * @param self self reference
   * @return month
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getMonth(Object self) {
    return getField(self, MONTH);
  }

  /**
   * ECMA 15.9.5.13 Date.prototype.getUTCMonth ( )
   *
   * @param self self reference
   * @return UTC month
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getUTCMonth(Object self) {
    return getUTCField(self, MONTH);
  }

  /**
   * ECMA 15.9.5.14 Date.prototype.getDate ( )
   * @param self self reference
   * @return date
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getDate(Object self) {
    return getField(self, DAY);
  }

  /**
   * ECMA 15.9.5.15 Date.prototype.getUTCDate ( )
   * @param self self reference
   * @return UTC Date
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getUTCDate(Object self) {
    return getUTCField(self, DAY);
  }

  /**
   * ECMA 15.9.5.16 Date.prototype.getDay ( )
   * @param self self reference
   * @return day
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getDay(Object self) {
    var nd = getNativeDate(self);
    return (nd != null && nd.isValidDate()) ? weekDay(nd.getLocalTime()) : Double.NaN;
  }

  /**
   * ECMA 15.9.5.17 Date.prototype.getUTCDay ( )
   * @param self self reference
   * @return UTC day
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getUTCDay(Object self) {
    var nd = getNativeDate(self);
    return (nd != null && nd.isValidDate()) ? weekDay(nd.getTime()) : Double.NaN;
  }

  /**
   * ECMA 15.9.5.18 Date.prototype.getHours ( )
   *
   * @param self self reference
   * @return hours
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getHours(Object self) {
    return getField(self, HOUR);
  }

  /**
   * ECMA 15.9.5.19 Date.prototype.getUTCHours ( )
   * @param self self reference
   * @return UTC hours
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getUTCHours(Object self) {
    return getUTCField(self, HOUR);
  }

  /**
   * ECMA 15.9.5.20 Date.prototype.getMinutes ( )
   * @param self self reference
   * @return minutes
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getMinutes(Object self) {
    return getField(self, MINUTE);
  }

  /**
   * ECMA 15.9.5.21 Date.prototype.getUTCMinutes ( )
   * @param self self reference
   * @return UTC minutes
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getUTCMinutes(Object self) {
    return getUTCField(self, MINUTE);
  }

  /**
   * ECMA 15.9.5.22 Date.prototype.getSeconds ( )
   * @param self self reference
   * @return seconds
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getSeconds(Object self) {
    return getField(self, SECOND);
  }

  /**
   * ECMA 15.9.5.23 Date.prototype.getUTCSeconds ( )
   * @param self self reference
   * @return UTC seconds
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getUTCSeconds(Object self) {
    return getUTCField(self, SECOND);
  }

  /**
   * ECMA 15.9.5.24 Date.prototype.getMilliseconds ( )
   * @param self self reference
   * @return milliseconds
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getMilliseconds(Object self) {
    return getField(self, MILLISECOND);
  }

  /**
   * ECMA 15.9.5.25 Date.prototype.getUTCMilliseconds ( )
   * @param self self reference
   * @return UTC milliseconds
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getUTCMilliseconds(Object self) {
    return getUTCField(self, MILLISECOND);
  }

  /**
   * ECMA 15.9.5.26 Date.prototype.getTimezoneOffset ( )
   * @param self self reference
   * @return time zone offset or NaN if N/A
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double getTimezoneOffset(Object self) {
    var nd = getNativeDate(self);
    if (nd != null && nd.isValidDate()) {
      var msec = (long) nd.getTime();
      return -nd.getTimeZone().getOffset(msec) / msPerMinute;
    }
    return Double.NaN;
  }

  /**
   * ECMA 15.9.5.27 Date.prototype.setTime (time)
   * @param self self reference
   * @param time time
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double setTime(Object self, Object time) {
    var nd = getNativeDate(self);
    var num = timeClip(JSType.toNumber(time));
    nd.setTime(num);
    return num;
  }

  /**
   * ECMA 15.9.5.28 Date.prototype.setMilliseconds (ms)
   * @param self self reference
   * @param args milliseconds
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static double setMilliseconds(Object self, Object... args) {
    var nd = getNativeDate(self);
    setFields(nd, MILLISECOND, args, true);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.29 Date.prototype.setUTCMilliseconds (ms)
   * @param self self reference
   * @param args utc milliseconds
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static double setUTCMilliseconds(Object self, Object... args) {
    var nd = getNativeDate(self);
    setFields(nd, MILLISECOND, args, false);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.30 Date.prototype.setSeconds (sec [, ms ] )
   * @param self self reference
   * @param args seconds (milliseconds optional second argument)
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 2)
  public static double setSeconds(Object self, Object... args) {
    var nd = getNativeDate(self);
    setFields(nd, SECOND, args, true);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.31 Date.prototype.setUTCSeconds (sec [, ms ] )
   * @param self self reference
   * @param args UTC seconds (milliseconds optional second argument)
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 2)
  public static double setUTCSeconds(Object self, Object... args) {
    var nd = getNativeDate(self);
    setFields(nd, SECOND, args, false);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.32 Date.prototype.setMinutes (min [, sec [, ms ] ] )
   * @param self self reference
   * @param args minutes (seconds and milliseconds are optional second and third arguments)
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 3)
  public static double setMinutes(Object self, Object... args) {
    var nd = getNativeDate(self);
    setFields(nd, MINUTE, args, true);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.33 Date.prototype.setUTCMinutes (min [, sec [, ms ] ] )
   * @param self self reference
   * @param args minutes (seconds and milliseconds are optional second and third arguments)
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 3)
  public static double setUTCMinutes(Object self, Object... args) {
    var nd = getNativeDate(self);
    setFields(nd, MINUTE, args, false);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.34 Date.prototype.setHours (hour [, min [, sec [, ms ] ] ] )
   * @param self self reference
   * @param args hour (optional arguments after are minutes, seconds, milliseconds)
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 4)
  public static double setHours(Object self, Object... args) {
    var nd = getNativeDate(self);
    setFields(nd, HOUR, args, true);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.35 Date.prototype.setUTCHours (hour [, min [, sec [, ms ] ] ] )
   * @param self self reference
   * @param args hour (optional arguments after are minutes, seconds, milliseconds)
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 4)
  public static double setUTCHours(Object self, Object... args) {
    var nd = getNativeDate(self);
    setFields(nd, HOUR, args, false);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.36 Date.prototype.setDate (date)
   * @param self self reference
   * @param args date
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static double setDate(Object self, Object... args) {
    var nd = getNativeDate(self);
    setFields(nd, DAY, args, true);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.37 Date.prototype.setUTCDate (date)
   * @param self self reference
   * @param args UTC date
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static double setUTCDate(Object self, Object... args) {
    final NativeDate nd = getNativeDate(self);
    setFields(nd, DAY, args, false);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.38 Date.prototype.setMonth (month [, date ] )
   * @param self self reference
   * @param args month (optional second argument is date)
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 2)
  public static double setMonth(Object self, Object... args) {
    var nd = getNativeDate(self);
    setFields(nd, MONTH, args, true);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.39 Date.prototype.setUTCMonth (month [, date ] )
   * @param self self reference
   * @param args UTC month (optional second argument is date)
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 2)
  public static double setUTCMonth(Object self, Object... args) {
    var nd = ensureNativeDate(self);
    setFields(nd, MONTH, args, false);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.40 Date.prototype.setFullYear (year [, month [, date ] ] )
   * @param self self reference
   * @param args year (optional second and third arguments are month and date)
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 3)
  public static double setFullYear(Object self, Object... args) {
    var nd = ensureNativeDate(self);
    if (nd.isValidDate()) {
      setFields(nd, YEAR, args, true);
    } else {
      var d = convertArgs(args, 0, YEAR, YEAR, 3);
      if (d != null) {
        nd.setTime(timeClip(utc(makeDate(makeDay(d[0], d[1], d[2]), 0), nd.getTimeZone())));
      } else {
        nd.setTime(NaN);
      }
    }
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.41 Date.prototype.setUTCFullYear (year [, month [, date ] ] )
   * @param self self reference
   * @param args UTC full year (optional second and third arguments are month and date)
   * @return time
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 3)
  public static double setUTCFullYear(Object self, Object... args) {
    var nd = ensureNativeDate(self);
    if (nd.isValidDate()) {
      setFields(nd, YEAR, args, false);
    } else {
      var d = convertArgs(args, 0, YEAR, YEAR, 3);
      nd.setTime(timeClip(makeDate(makeDay(d[0], d[1], d[2]), 0)));
    }
    return nd.getTime();
  }

  /**
   * ECMA B.2.5 Date.prototype.setYear (year)
   * @param self self reference
   * @param year year
   * @return NativeDate
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double setYear(Object self, Object year) {
    var nd = getNativeDate(self);
    if (isNaN(nd.getTime())) {
      nd.setTime(utc(0, nd.getTimeZone()));
    }
    var yearNum = JSType.toNumber(year);
    if (isNaN(yearNum)) {
      nd.setTime(NaN);
      return nd.getTime();
    }
    var yearInt = (int) yearNum;
    if (0 <= yearInt && yearInt <= 99) {
      yearInt += 1900;
    }
    setFields(nd, YEAR, new Object[]{yearInt}, true);
    return nd.getTime();
  }

  /**
   * ECMA 15.9.5.42 Date.prototype.toUTCString ( )
   * @param self self reference
   * @return string representation of date
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toUTCString(Object self) {
    return toGMTStringImpl(self);
  }

  /**
   * ECMA B.2.6 Date.prototype.toGMTString ( )
   * See {@link NativeDate#toUTCString(Object)}
   * @param self self reference
   * @return string representation of date
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toGMTString(Object self) {
    return toGMTStringImpl(self);
  }

  /**
   * ECMA 15.9.5.43 Date.prototype.toISOString ( )
   * @param self self reference
   * @return string representation of date
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toISOString(Object self) {
    return toISOStringImpl(self);
  }

  /**
   * ECMA 15.9.5.44 Date.prototype.toJSON ( key )
   * Provides a string representation of this Date for use by {@link NativeJSON#stringify(Object, Object, Object, Object)}
   * @param self self reference
   * @param key ignored
   * @return JSON representation of this date
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object toJSON(Object self, Object key) {
    // NOTE: Date.prototype.toJSON is generic. Accepts other objects as well.
    var selfObj = Global.toObject(self);
    if (!(selfObj instanceof ScriptObject)) {
      return null;
    }
    var sobj = (ScriptObject) selfObj;
    var value = sobj.getDefaultValue(Number.class);
    if (value instanceof Number n) {
      var num = n.doubleValue();
      if (isInfinite(num) || isNaN(num)) {
        return null;
      }
    }
    try {
      var toIsoString = getTO_ISO_STRING();
      var func = toIsoString.getGetter().invokeExact(sobj);
      if (Bootstrap.isCallable(func)) {
        return toIsoString.getInvoker().invokeExact(func, sobj, key);
      }
      throw typeError("not.a.function", ScriptRuntime.safeToString(func));
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  // -- Internals below this point

  static double parseDateString(String str) {
    // ECMA 15.9.1.15 -> YYYY-MM-DDTHH:mm:ss.sssZ
    var ts = Instant.parse(str);
    return timeClip((double) ts.getEpochSecond());
  }

  static void zeroPad(StringBuilder sb, int n, int length) {
    for (int l = 1, d = 10; l < length; l++, d *= 10) {
      if (n < d) {
        sb.append('0');
      }
    }
    sb.append(n);
  }

  @SuppressWarnings("fallthrough")
  static String toStringImpl(Object self, int format) {
    var nd = getNativeDate(self);
    if (nd != null && nd.isValidDate()) {
      var sb = new StringBuilder(40);
      var t = nd.getLocalTime();
      switch (format) {

        case FORMAT_DATE_TIME:
        case FORMAT_DATE:
        case FORMAT_LOCAL_DATE_TIME:
          // EEE MMM dd yyyy
          sb.append(weekDays[weekDay(t)])
            .append(' ')
            .append(months[monthFromTime(t)])
            .append(' ');
          zeroPad(sb, dayFromTime(t), 2);
          sb.append(' ');
          zeroPad(sb, yearFromTime(t), 4);
          if (format == FORMAT_DATE) {
            break;
          }
          sb.append(' ');

        case FORMAT_TIME:
          var tz = nd.getTimeZone();
          var utcTime = nd.getTime();
          var offset = tz.getOffset((long) utcTime) / 60000;
          var inDaylightTime = offset != tz.getRawOffset() / 60000;
          // Convert minutes to HHmm timezone offset
          offset = (offset / 60) * 100 + offset % 60;

          // HH:mm:ss GMT+HHmm
          zeroPad(sb, hourFromTime(t), 2);
          sb.append(':');
          zeroPad(sb, minFromTime(t), 2);
          sb.append(':');
          zeroPad(sb, secFromTime(t), 2);
          sb.append(" GMT")
            .append(offset < 0 ? '-' : '+');
          zeroPad(sb, Math.abs(offset), 4);
          sb.append(" (")
            .append(tz.getDisplayName(inDaylightTime, TimeZone.SHORT, Locale.US))
            .append(')');
          break;

        case FORMAT_LOCAL_DATE:
          // yyyy-MM-dd
          zeroPad(sb, yearFromTime(t), 4);
          sb.append('-');
          zeroPad(sb, monthFromTime(t) + 1, 2);
          sb.append('-');
          zeroPad(sb, dayFromTime(t), 2);
          break;

        case FORMAT_LOCAL_TIME:
          // HH:mm:ss
          zeroPad(sb, hourFromTime(t), 2);
          sb.append(':');
          zeroPad(sb, minFromTime(t), 2);
          sb.append(':');
          zeroPad(sb, secFromTime(t), 2);
          break;

        default:
          throw new IllegalArgumentException("format: " + format);
      }
      return sb.toString();
    }

    return INVALID_DATE;
  }

  private static String toGMTStringImpl(Object self) {
    final NativeDate nd = getNativeDate(self);

    if (nd != null && nd.isValidDate()) {
      final StringBuilder sb = new StringBuilder(29);
      final double t = nd.getTime();
      // EEE, dd MMM yyyy HH:mm:ss z
      sb.append(weekDays[weekDay(t)])
              .append(", ");
      zeroPad(sb, dayFromTime(t), 2);
      sb.append(' ')
              .append(months[monthFromTime(t)])
              .append(' ');
      zeroPad(sb, yearFromTime(t), 4);
      sb.append(' ');
      zeroPad(sb, hourFromTime(t), 2);
      sb.append(':');
      zeroPad(sb, minFromTime(t), 2);
      sb.append(':');
      zeroPad(sb, secFromTime(t), 2);
      sb.append(" GMT");
      return sb.toString();
    }

    throw rangeError("invalid.date");
  }

  private static String toISOStringImpl(Object self) {
    final NativeDate nd = getNativeDate(self);

    if (nd != null && nd.isValidDate()) {
      final StringBuilder sb = new StringBuilder(24);
      final double t = nd.getTime();
      // yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
      zeroPad(sb, yearFromTime(t), 4);
      sb.append('-');
      zeroPad(sb, monthFromTime(t) + 1, 2);
      sb.append('-');
      zeroPad(sb, dayFromTime(t), 2);
      sb.append('T');
      zeroPad(sb, hourFromTime(t), 2);
      sb.append(':');
      zeroPad(sb, minFromTime(t), 2);
      sb.append(':');
      zeroPad(sb, secFromTime(t), 2);
      sb.append('.');
      zeroPad(sb, msFromTime(t), 3);
      sb.append("Z");
      return sb.toString();
    }

    throw rangeError("invalid.date");
  }

  // ECMA 15.9.1.2 Day (t)
  static double day(double t) {
    return Math.floor(t / msPerDay);
  }

  // ECMA 15.9.1.2 TimeWithinDay (t)
  static double timeWithinDay(double t) {
    final double val = t % msPerDay;
    return val < 0 ? val + msPerDay : val;
  }

  // ECMA 15.9.1.3 InLeapYear (t)
  static boolean isLeapYear(int y) {
    return y % 4 == 0 && (y % 100 != 0 || y % 400 == 0);
  }

  // ECMA 15.9.1.3 DaysInYear (y)
  static int daysInYear(int y) {
    return isLeapYear(y) ? 366 : 365;
  }

  // ECMA 15.9.1.3 DayFromYear (y)
  static double dayFromYear(double y) {
    return 365 * (y - 1970) + Math.floor((y - 1969) / 4.0) - Math.floor((y - 1901) / 100.0) + Math.floor((y - 1601) / 400.0);
  }

  // ECMA 15.9.1.3 Year Number
  static double timeFromYear(int y) {
    return dayFromYear(y) * msPerDay;
  }

  // ECMA 15.9.1.3 Year Number
  static int yearFromTime(double t) {
    var y = (int) Math.floor(t / (msPerDay * 365.2425)) + 1970;
    var t2 = timeFromYear(y);
    if (t2 > t) {
      y--;
    } else if (t2 + msPerDay * daysInYear(y) <= t) {
      y++;
    }
    return y;
  }

  static int dayWithinYear(double t, int year) {
    return (int) (day(t) - dayFromYear(year));
  }

  static int monthFromTime(double t) {
    var year = yearFromTime(t);
    var day = dayWithinYear(t, year);
    var firstDay = firstDayInMonth[isLeapYear(year) ? 1 : 0];
    var month = 0;
    while (month < 11 && firstDay[month + 1] <= day) {
      month++;
    }
    return month;
  }

  static int dayFromTime(double t) {
    var year = yearFromTime(t);
    var day = dayWithinYear(t, year);
    var firstDay = firstDayInMonth[isLeapYear(year) ? 1 : 0];
    int month = 0;
    while (month < 11 && firstDay[month + 1] <= day) {
      month++;
    }
    return 1 + day - firstDay[month];
  }

  static int dayFromMonth(int month, int year) {
    assert (month >= 0 && month <= 11);
    var firstDay = firstDayInMonth[isLeapYear(year) ? 1 : 0];
    return firstDay[month];
  }

  static int weekDay(double time) {
    var day = (int) (day(time) + 4) % 7;
    return day < 0 ? day + 7 : day;
  }

  // ECMA 15.9.1.9 LocalTime
  static double localTime(double time, TimeZone tz) {
    return time + tz.getOffset((long) time);
  }

  // ECMA 15.9.1.9 UTC
  static double utc(double time, TimeZone tz) {
    return time - tz.getOffset((long) (time - tz.getRawOffset()));
  }

  // ECMA 15.9.1.10 Hours, Minutes, Second, and Milliseconds
  static int hourFromTime(double t) {
    var h = (int) (Math.floor(t / msPerHour) % hoursPerDay);
    return h < 0 ? h + hoursPerDay : h;
  }

  static int minFromTime(double t) {
    var m = (int) (Math.floor(t / msPerMinute) % minutesPerHour);
    return m < 0 ? m + minutesPerHour : m;
  }

  static int secFromTime(double t) {
    var s = (int) (Math.floor(t / msPerSecond) % secondsPerMinute);
    return s < 0 ? s + secondsPerMinute : s;
  }

  static int msFromTime(double t) {
    var m = (int) (t % msPerSecond);
    return m < 0 ? m + msPerSecond : m;
  }

  static int valueFromTime(int unit, double t) {
    return switch (unit) {
      case YEAR -> yearFromTime(t);
      case MONTH -> monthFromTime(t);
      case DAY -> dayFromTime(t);
      case HOUR -> hourFromTime(t);
      case MINUTE -> minFromTime(t);
      case SECOND -> secFromTime(t);
      case MILLISECOND -> msFromTime(t);
      default -> throw new IllegalArgumentException(Integer.toString(unit));
    };
  }

  // ECMA 15.9.1.11 MakeTime (hour, min, sec, ms)
  static double makeTime(double hour, double min, double sec, double ms) {
    return hour * 3600000 + min * 60000 + sec * 1000 + ms;
  }

  // ECMA 15.9.1.12 MakeDay (year, month, date)
  static double makeDay(double year, double month, double date) {
    var y = year + Math.floor(month / 12);
    var m = (int) (month % 12);
    if (m < 0) {
      m += 12;
    }
    var d = dayFromYear(y);
    d += dayFromMonth(m, (int) y);
    return d + date - 1;
  }

  // ECMA 15.9.1.13 MakeDate (day, time)
  static double makeDate(double day, double time) {
    return day * msPerDay + time;
  }

  static double makeDate(Integer[] d) {
    var time = makeDay(d[0], d[1], d[2]) * msPerDay;
    return time + makeTime(d[3], d[4], d[5], d[6]);
  }

  static double makeDate(double[] d) {
    var time = makeDay(d[0], d[1], d[2]) * msPerDay;
    return time + makeTime(d[3], d[4], d[5], d[6]);
  }

  // Convert Date constructor args, checking for NaN, filling in defaults etc.
  static double[] convertCtorArgs(Object[] args) {
    var d = new double[7];
    var nullReturn = false;
    // should not bailout on first NaN or infinite.
    // Need to convert all subsequent args for possible side-effects via valueOf/toString overrides on argument objects.
    for (var i = 0; i < d.length; i++) {
      if (i < args.length) {
        var darg = JSType.toNumber(args[i]);
        if (isNaN(darg) || isInfinite(darg)) {
          nullReturn = true;
        }
        d[i] = (long) darg;
      } else {
        d[i] = i == 2 ? 1 : 0; // day in month defaults to 1
      }
    }
    if (0 <= d[0] && d[0] <= 99) {
      d[0] += 1900;
    }
    return nullReturn ? null : d;
  }

  // This method does the hard work for all setter methods:
  // If a value is provided as argument it is used, otherwise the value is calculated from the existing time value.
  static double[] convertArgs(Object[] args, double time, int fieldId, int start, int length) {
    var d = new double[length];
    var nullReturn = false;
    // Need to call toNumber on all args for side-effects - even if an argument fails to convert to number, subsequent toNumber calls needed for possible side-effects via valueOf/toString overrides.
    for (var i = start; i < start + length; i++) {
      if (fieldId <= i && i < fieldId + args.length) {
        var darg = JSType.toNumber(args[i - fieldId]);
        if (isNaN(darg) || isInfinite(darg)) {
          nullReturn = true;
        }
        d[i - start] = (long) darg;
      } else {
        // Date.prototype.set* methods require first argument to be defined
        if (i == fieldId) {
          nullReturn = true;
        }
        if (!nullReturn && !isNaN(time)) {
          d[i - start] = valueFromTime(i, time);
        }
      }
    }
    return nullReturn ? null : d;
  }

  // ECMA 15.9.1.14 TimeClip (time)
  static double timeClip(double time) {
    return (isInfinite(time) || isNaN(time) || Math.abs(time) > 8.64e15) ? Double.NaN : (long) time;
  }

  static NativeDate ensureNativeDate(Object self) {
    return getNativeDate(self);
  }

  static NativeDate getNativeDate(Object self) {
    if (self instanceof NativeDate nd) {
      return nd;
    } else if (self != null && self == Global.instance().getDatePrototype()) {
      return Global.instance().getDefaultDate();
    } else {
      throw typeError("not.a.date", ScriptRuntime.safeToString(self));
    }
  }

  static double getField(Object self, int field) {
    var nd = getNativeDate(self);
    return (nd != null && nd.isValidDate()) ? (double) valueFromTime(field, nd.getLocalTime()) : Double.NaN;
  }

  static double getUTCField(Object self, int field) {
    var nd = getNativeDate(self);
    return (nd != null && nd.isValidDate()) ? (double) valueFromTime(field, nd.getTime()) : Double.NaN;
  }

  static void setFields(NativeDate nd, int fieldId, Object[] args, boolean local) {
    int start, length;
    if (fieldId < HOUR) {
      start = YEAR;
      length = 3;
    } else {
      start = HOUR;
      length = 4;
    }
    var time = local ? nd.getLocalTime() : nd.getTime();
    var d = convertArgs(args, time, fieldId, start, length);
    if (!nd.isValidDate()) {
      return;
    }
    double newTime;
    if (d == null) {
      newTime = NaN;
    } else {
      if (start == YEAR) {
        newTime = makeDate(makeDay(d[0], d[1], d[2]), timeWithinDay(time));
      } else {
        newTime = makeDate(day(time), makeTime(d[0], d[1], d[2], d[3]));
      }
      if (local) {
        newTime = utc(newTime, nd.getTimeZone());
      }
      newTime = timeClip(newTime);
    }
    nd.setTime(newTime);
  }

  boolean isValidDate() {
    return !isNaN(time);
  }

  double getLocalTime() {
    return localTime(time, timezone);
  }

  double getTime() {
    return time;
  }

  void setTime(double time) {
    this.time = time;
  }

  TimeZone getTimeZone() {
    return timezone;
  }

}
