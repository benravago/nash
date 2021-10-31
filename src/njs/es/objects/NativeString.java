package es.objects;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.Locale;
import java.util.Set;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.reflect.Array;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;

import es.lookup.MethodHandleFactory.LookupException;
import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.Getter;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.SpecializedFunction;
import es.objects.annotations.SpecializedFunction.LinkLogic;
import es.objects.annotations.Where;
import es.runtime.ConsString;
import es.runtime.JSType;
import es.runtime.OptimisticBuiltins;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.arrays.ArrayIndex;
import es.runtime.linker.Bootstrap;
import es.runtime.linker.NashornCallSiteDescriptor;
import es.runtime.linker.NashornGuards;
import es.runtime.linker.PrimitiveLookup;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.JSType.isRepresentableAsInt;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * ECMA 15.5 String Objects.
 */
@ScriptClass("String")
public final class NativeString extends ScriptObject implements OptimisticBuiltins {

  private final CharSequence value;

  // Method handle to create an object wrapper for a primitive string
  static final MethodHandle WRAPFILTER = findOwnMH("wrapFilter", MH.type(NativeString.class, Object.class));

  // Method handle to retrieve the String prototype object
  private static final MethodHandle PROTOFILTER = findOwnMH("protoFilter", MH.type(Object.class, Object.class));

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  NativeString(CharSequence value) {
    this(value, Global.instance());
  }

  NativeString(CharSequence value, Global global) {
    this(value, global.getStringPrototype(), $nasgenmap$);
  }

  NativeString(CharSequence value, ScriptObject proto, PropertyMap map) {
    super(proto, map);
    assert JSType.isString(value);
    this.value = value;
  }

  @Override
  public String safeToString() {
    return "[String " + toString() + "]";
  }

  @Override
  public String toString() {
    return getStringValue();
  }

  String getStringValue() {
    return value instanceof String ? (String) value : value.toString();
  }

  CharSequence getValue() {
    return value;
  }

  @Override
  public String getClassName() {
    return "String";
  }

  @Override
  public Object getLength() {
    return value.length();
  }

  // This is to support length as method call as well.
  @Override
  protected GuardedInvocation findGetMethod(CallSiteDescriptor desc, LinkRequest request) {
    var name = NashornCallSiteDescriptor.getOperand(desc);
    // if str.length(), then let the bean linker handle it
    return ("length".equals(name) && NashornCallSiteDescriptor.isMethodFirstOperation(desc)) ? null : super.findGetMethod(desc, request);
  }

  // This is to provide array-like access to string characters without creating a NativeString wrapper.
  @Override
  protected GuardedInvocation findGetIndexMethod(CallSiteDescriptor desc, LinkRequest request) {
    var self = request.getReceiver();
    var returnType = desc.getMethodType().returnType();

    if (returnType == Object.class && JSType.isString(self)) {
      try {
        return new GuardedInvocation(MH.findStatic(MethodHandles.lookup(), NativeString.class, "get", desc.getMethodType()), NashornGuards.getStringGuard());
      } catch (LookupException e) {
        // empty. Shouldn't happen. Fall back to super
      }
    }
    return super.findGetIndexMethod(desc, request);
  }

  @SuppressWarnings("unused")
  static Object get(Object self, Object key) {
    var cs = JSType.toCharSequence(self);
    var primitiveKey = JSType.toPrimitive(key, String.class);
    var index = ArrayIndex.getArrayIndex(primitiveKey);
    return (index >= 0 && index < cs.length()) ? String.valueOf(cs.charAt(index)) : ((ScriptObject) Global.toObject(self)).get(primitiveKey);
  }

  @SuppressWarnings("unused")
  static Object get(Object self, double key) {
    return isRepresentableAsInt(key) ? get(self, (int) key) : ((ScriptObject) Global.toObject(self)).get(key);
  }

  @SuppressWarnings("unused")
  static Object get(Object self, long key) {
    var cs = JSType.toCharSequence(self);
    return (key >= 0 && key < cs.length()) ? String.valueOf(cs.charAt((int) key)) : ((ScriptObject) Global.toObject(self)).get(key);
  }

  static Object get(Object self, int key) {
    var cs = JSType.toCharSequence(self);
    return (key >= 0 && key < cs.length()) ? String.valueOf(cs.charAt(key)) : ((ScriptObject) Global.toObject(self)).get(key);
  }

  // String characters can be accessed with array-like indexing..
  @Override
  public Object get(Object key) {
    var primitiveKey = JSType.toPrimitive(key, String.class);
    var index = ArrayIndex.getArrayIndex(primitiveKey);
    return (index >= 0 && index < value.length()) ? String.valueOf(value.charAt(index)) : super.get(primitiveKey);
  }

  @Override
  public Object get(double key) {
    return isRepresentableAsInt(key) ? get((int) key) : super.get(key);
  }

  @Override
  public Object get(int key) {
    return (key >= 0 && key < value.length()) ? String.valueOf(value.charAt(key)) : super.get(key);
  }

  @Override
  public int getInt(Object key, int programPoint) {
    return JSType.toInt32MaybeOptimistic(get(key), programPoint);
  }

  @Override
  public int getInt(double key, int programPoint) {
    return JSType.toInt32MaybeOptimistic(get(key), programPoint);
  }

  @Override
  public int getInt(int key, int programPoint) {
    return JSType.toInt32MaybeOptimistic(get(key), programPoint);
  }

  @Override
  public double getDouble(Object key, int programPoint) {
    return JSType.toNumberMaybeOptimistic(get(key), programPoint);
  }

  @Override
  public double getDouble(double key, int programPoint) {
    return JSType.toNumberMaybeOptimistic(get(key), programPoint);
  }

  @Override
  public double getDouble(int key, int programPoint) {
    return JSType.toNumberMaybeOptimistic(get(key), programPoint);
  }

  @Override
  public boolean has(Object key) {
    var primitiveKey = JSType.toPrimitive(key, String.class);
    var index = ArrayIndex.getArrayIndex(primitiveKey);
    return isValidStringIndex(index) || super.has(primitiveKey);
  }

  @Override
  public boolean has(int key) {
    return isValidStringIndex(key) || super.has(key);
  }

  @Override
  public boolean has(double key) {
    var index = ArrayIndex.getArrayIndex(key);
    return isValidStringIndex(index) || super.has(key);
  }

  @Override
  public boolean hasOwnProperty(Object key) {
    var primitiveKey = JSType.toPrimitive(key, String.class);
    var index = ArrayIndex.getArrayIndex(primitiveKey);
    return isValidStringIndex(index) || super.hasOwnProperty(primitiveKey);
  }

  @Override
  public boolean hasOwnProperty(int key) {
    return isValidStringIndex(key) || super.hasOwnProperty(key);
  }

  @Override
  public boolean hasOwnProperty(double key) {
    var index = ArrayIndex.getArrayIndex(key);
    return isValidStringIndex(index) || super.hasOwnProperty(key);
  }

  @Override
  public boolean delete(int key) {
    return checkDeleteIndex(key) ? false : super.delete(key);
  }

  @Override
  public boolean delete(double key) {
    var index = ArrayIndex.getArrayIndex(key);
    return checkDeleteIndex(index) ? false : super.delete(key);
  }

  @Override
  public boolean delete(Object key) {
    var primitiveKey = JSType.toPrimitive(key, String.class);
    var index = ArrayIndex.getArrayIndex(primitiveKey);
    return checkDeleteIndex(index) ? false : super.delete(primitiveKey);
  }

  private boolean checkDeleteIndex(int index) {
    if (isValidStringIndex(index)) {
      // throw typeError("cant.delete.property", Integer.toString(index), ScriptRuntime.safeToString(this));
      return true;
    }
    return false;
  }

  @Override
  public Object getOwnPropertyDescriptor(Object key) {
    var index = ArrayIndex.getArrayIndex(key);
    if (index >= 0 && index < value.length()) {
      var global = Global.instance();
      return global.newDataDescriptor(String.valueOf(value.charAt(index)), false, true, false);
    }
    return super.getOwnPropertyDescriptor(key);
  }

  /**
   * return a List of own keys associated with the object.
   * @param all True if to include non-enumerable keys.
   * @param nonEnumerable set of non-enumerable properties seen already. Used to filter out shadowed, but enumerable properties from proto children.
   * @return Array of keys.
   */
  @Override
  @SuppressWarnings("unchecked")
  protected <T> T[] getOwnKeys(Class<T> type, boolean all, Set<T> nonEnumerable) {
    if (type != String.class) {
      return super.getOwnKeys(type, all, nonEnumerable);
    }
    var keys = new ArrayList<Object>();
    // add string index keys
    for (var i = 0; i < value.length(); i++) {
      keys.add(JSType.toString(i));
    }
    // add super class properties
    keys.addAll(Arrays.asList(super.getOwnKeys(type, all, nonEnumerable)));
    return keys.toArray((T[]) Array.newInstance(type, keys.size()));
  }

  /**
   * ECMA 15.5.3 String.length
   * @param self self reference
   * @return     value of length property for string
   */
  @Getter(attributes = Attribute.NOT_ENUMERABLE | Attribute.NOT_WRITABLE | Attribute.NOT_CONFIGURABLE)
  public static Object length(Object self) {
    return getCharSequence(self).length();
  }

  /**
   * ECMA 15.5.3.2 String.fromCharCode ( [ char0 [ , char1 [ , ... ] ] ] )
   * @param self  self reference
   * @param args  array of arguments to be interpreted as char
   * @return string with arguments translated to charcodes
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1, where = Where.CONSTRUCTOR)
  public static String fromCharCode(Object self, Object... args) {
    var buf = new char[args.length];
    var index = 0;
    for (var arg : args) {
      buf[index++] = (char) JSType.toUint16(arg);
    }
    return new String(buf);
  }

  /**
   * ECMA 15.5.3.2 - specialization for one char
   * @param self  self reference
   * @param value one argument to be interpreted as char
   * @return string with one charcode
   */
  @SpecializedFunction
  public static Object fromCharCode(Object self, Object value) {
    return (value instanceof Integer) ? fromCharCode(self, (int) value) : Character.toString((char) JSType.toUint16(value));
  }

  /**
   * ECMA 15.5.3.2 - specialization for one char of int type
   * @param self  self reference
   * @param value one argument to be interpreted as char
   * @return string with one charcode
   */
  @SpecializedFunction
  public static String fromCharCode(Object self, int value) {
    return Character.toString((char) (value & 0xffff));
  }

  /**
   * ECMA 15.5.3.2 - specialization for two chars of int type
   * @param self  self reference
   * @param ch1 first char
   * @param ch2 second char
   * @return string with one charcode
   */
  @SpecializedFunction
  public static Object fromCharCode(Object self, int ch1, int ch2) {
    return Character.toString((char) (ch1 & 0xffff)) + Character.toString((char) (ch2 & 0xffff));
  }

  /**
   * ECMA 15.5.3.2 - specialization for three chars of int type
   * @param self  self reference
   * @param ch1 first char
   * @param ch2 second char
   * @param ch3 third char
   * @return string with one charcode
   */
  @SpecializedFunction
  public static Object fromCharCode(Object self, int ch1, int ch2, int ch3) {
    return Character.toString((char) (ch1 & 0xffff)) + Character.toString((char) (ch2 & 0xffff)) + Character.toString((char) (ch3 & 0xffff));
  }

  /**
   * ECMA 15.5.3.2 - specialization for four chars of int type
   * @param self  self reference
   * @param ch1 first char
   * @param ch2 second char
   * @param ch3 third char
   * @param ch4 fourth char
   * @return string with one charcode
   */
  @SpecializedFunction
  public static String fromCharCode(Object self, int ch1, int ch2, int ch3, int ch4) {
    return Character.toString((char) (ch1 & 0xffff)) + Character.toString((char) (ch2 & 0xffff)) + Character.toString((char) (ch3 & 0xffff)) + Character.toString((char) (ch4 & 0xffff));
  }

  /**
   * ECMA 15.5.3.2 - specialization for one char of double type
   * @param self  self reference
   * @param value one argument to be interpreted as char
   * @return string with one charcode
   */
  @SpecializedFunction
  public static String fromCharCode(Object self, double value) {
    return Character.toString((char) JSType.toUint16(value));
  }

  /**
   * ECMA 15.5.4.2 String.prototype.toString ( )
   * @param self self reference
   * @return self as string
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toString(Object self) {
    return getString(self);
  }

  /**
   * ECMA 15.5.4.3 String.prototype.valueOf ( )
   * @param self self reference
   * @return self as string
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String valueOf(Object self) {
    return getString(self);
  }

  /**
   * ECMA 15.5.4.4 String.prototype.charAt (pos)
   * @param self self reference
   * @param pos  position in string
   * @return string representing the char at the given position
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String charAt(Object self, Object pos) {
    return charAtImpl(checkObjectToString(self), JSType.toInteger(pos));
  }

  /**
   * ECMA 15.5.4.4 String.prototype.charAt (pos) - specialized version for double position
   * @param self self reference
   * @param pos  position in string
   * @return string representing the char at the given position
   */
  @SpecializedFunction
  public static String charAt(Object self, double pos) {
    return charAt(self, (int) pos);
  }

  /**
   * ECMA 15.5.4.4 String.prototype.charAt (pos) - specialized version for int position
   * @param self self reference
   * @param pos  position in string
   * @return string representing the char at the given position
   */
  @SpecializedFunction
  public static String charAt(Object self, int pos) {
    return charAtImpl(checkObjectToString(self), pos);
  }

  static String charAtImpl(String str, int pos) {
    return pos < 0 || pos >= str.length() ? "" : String.valueOf(str.charAt(pos));
  }

  static int getValidChar(Object self, int pos) {
    try {
      return ((CharSequence) self).charAt(pos);
    } catch (IndexOutOfBoundsException e) {
      throw new ClassCastException(); //invalid char, out of bounds, force relink
    }
  }

  /**
   * ECMA 15.5.4.5 String.prototype.charCodeAt (pos)
   * @param self self reference
   * @param pos  position in string
   * @return number representing charcode at position
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double charCodeAt(Object self, Object pos) {
    var str = checkObjectToString(self);
    var idx = JSType.toInteger(pos);
    return idx < 0 || idx >= str.length() ? Double.NaN : str.charAt(idx);
  }

  /**
   * ECMA 15.5.4.5 String.prototype.charCodeAt (pos) - specialized version for double position
   * @param self self reference
   * @param pos  position in string
   * @return number representing charcode at position
   */
  @SpecializedFunction(linkLogic = CharCodeAtLinkLogic.class)
  public static int charCodeAt(Object self, double pos) {
    return charCodeAt(self, (int) pos); //toInt pos is ok
  }

  /**
   * ECMA 15.5.4.5 String.prototype.charCodeAt (pos) - specialized version for int position
   * @param self self reference
   * @param pos  position in string
   * @return number representing charcode at position
   */
  @SpecializedFunction(linkLogic = CharCodeAtLinkLogic.class)
  public static int charCodeAt(Object self, int pos) {
    return getValidChar(self, pos);
  }

  /**
   * ECMA 15.5.4.6 String.prototype.concat ( [ string1 [ , string2 [ , ... ] ] ] )
   * @param self self reference
   * @param args list of string to concatenate
   * @return concatenated string
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static Object concat(Object self, Object... args) {
    CharSequence cs = checkObjectToString(self);
    if (args != null) {
      for (var obj : args) {
        cs = new ConsString(cs, JSType.toCharSequence(obj));
      }
    }
    return cs;
  }

  /**
   * ECMA 15.5.4.7 String.prototype.indexOf (searchString, position)
   * @param self   self reference
   * @param search string to search for
   * @param pos    position to start search
   * @return position of first match or -1
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static int indexOf(Object self, Object search, Object pos) {
    var str = checkObjectToString(self);
    return str.indexOf(JSType.toString(search), JSType.toInteger(pos));
  }

  /**
   * ECMA 15.5.4.7 String.prototype.indexOf (searchString, position) specialized for no position parameter
   * @param self   self reference
   * @param search string to search for
   * @return position of first match or -1
   */
  @SpecializedFunction
  public static int indexOf(Object self, Object search) {
    return indexOf(self, search, 0);
  }

  /**
   * ECMA 15.5.4.7 String.prototype.indexOf (searchString, position) specialized for double position parameter
   * @param self   self reference
   * @param search string to search for
   * @param pos    position to start search
   * @return position of first match or -1
   */
  @SpecializedFunction
  public static int indexOf(Object self, Object search, double pos) {
    return indexOf(self, search, (int) pos);
  }

  /**
   * ECMA 15.5.4.7 String.prototype.indexOf (searchString, position) specialized for int position parameter
   * @param self   self reference
   * @param search string to search for
   * @param pos    position to start search
   * @return position of first match or -1
   */
  @SpecializedFunction
  public static int indexOf(Object self, Object search, int pos) {
    return checkObjectToString(self).indexOf(JSType.toString(search), pos);
  }

  /**
   * ECMA 15.5.4.8 String.prototype.lastIndexOf (searchString, position)
   * @param self   self reference
   * @param search string to search for
   * @param pos    position to start search
   * @return last position of match or -1
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, arity = 1)
  public static int lastIndexOf(Object self, Object search, Object pos) {
    var str = checkObjectToString(self);
    var searchStr = JSType.toString(search);
    var length = str.length();
    int end;
    if (pos == UNDEFINED) {
      end = length;
    } else {
      var numPos = JSType.toNumber(pos);
      end = Double.isNaN(numPos) ? length : (int) numPos;
      if (end < 0) {
        end = 0;
      } else if (end > length) {
        end = length;
      }
    }
    return str.lastIndexOf(searchStr, end);
  }

  /**
   * ECMA 15.5.4.9 String.prototype.localeCompare (that)
   * @param self self reference
   * @param that comparison object
   * @return result of locale sensitive comparison operation between {@code self} and {@code that}
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static double localeCompare(Object self, Object that) {
    var str = checkObjectToString(self);
    var collator = Collator.getInstance(Global.getEnv()._locale);
    collator.setStrength(Collator.IDENTICAL);
    collator.setDecomposition(Collator.CANONICAL_DECOMPOSITION);
    return collator.compare(str, JSType.toString(that));
  }

  /**
   * ECMA 15.5.4.10 String.prototype.match (regexp)
   * @param self   self reference
   * @param regexp regexp expression
   * @return array of regexp matches
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static ScriptObject match(Object self, Object regexp) {
    var str = checkObjectToString(self);
    var nativeRegExp = (regexp == UNDEFINED) ? new NativeRegExp("") : Global.toRegExp(regexp);
    if (!nativeRegExp.getGlobal()) {
      return nativeRegExp.exec(str);
    }
    nativeRegExp.setLastIndex(0);
    var matches = new ArrayList<Object>();
    Object result;
    // We follow ECMAScript 6 spec here (checking for empty string instead of previous index)
    // as the ES5 specification is buggy and causes empty strings to be matched twice.
    while ((result = nativeRegExp.exec(str)) != null) {
      var matchStr = JSType.toString(((ScriptObject) result).get(0));
      if (matchStr.isEmpty()) {
        nativeRegExp.setLastIndex(nativeRegExp.getLastIndex() + 1);
      }
      matches.add(matchStr);
    }
    if (matches.isEmpty()) {
      return null;
    }
    return new NativeArray(matches.toArray());
  }

  /**
   * ECMA 15.5.4.11 String.prototype.replace (searchValue, replaceValue)
   * @param self        self reference
   * @param string      item to replace
   * @param replacement item to replace it with
   * @return string after replacement
   * @throws Throwable if replacement fails
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String replace(Object self, Object string, Object replacement) throws Throwable {
    var str = checkObjectToString(self);
    var nativeRegExp = (string instanceof NativeRegExp nre) ? nre : NativeRegExp.flatRegExp(JSType.toString(string));
    return (Bootstrap.isCallable(replacement)) ? nativeRegExp.replace(str, "", replacement) : nativeRegExp.replace(str, JSType.toString(replacement), null);
  }

  /**
   * ECMA 15.5.4.12 String.prototype.search (regexp)
   * @param self    self reference
   * @param string  string to search for
   * @return offset where match occurred
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static int search(Object self, Object string) {
    var str = checkObjectToString(self);
    var nativeRegExp = Global.toRegExp(string == UNDEFINED ? "" : string);
    return nativeRegExp.search(str);
  }

  /**
   * ECMA 15.5.4.13 String.prototype.slice (start, end)
   * @param self  self reference
   * @param start start position for slice
   * @param end   end position for slice
   * @return sliced out substring
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String slice(Object self, Object start, Object end) {
    var str = checkObjectToString(self);
    return (end == UNDEFINED) ? slice(str, JSType.toInteger(start)) : slice(str, JSType.toInteger(start), JSType.toInteger(end));
  }

  /**
   * ECMA 15.5.4.13 String.prototype.slice (start, end) specialized for single int parameter
   * @param self  self reference
   * @param start start position for slice
   * @return sliced out substring
   */
  @SpecializedFunction
  public static String slice(Object self, int start) {
    var str = checkObjectToString(self);
    var from = start < 0 ? Math.max(str.length() + start, 0) : Math.min(start, str.length());
    return str.substring(from);
  }

  /**
   * ECMA 15.5.4.13 String.prototype.slice (start, end) specialized for single double parameter
   * @param self  self reference
   * @param start start position for slice
   * @return sliced out substring
   */
  @SpecializedFunction
  public static String slice(Object self, double start) {
    return slice(self, (int) start);
  }

  /**
   * ECMA 15.5.4.13 String.prototype.slice (start, end) specialized for two int parameters
   * @param self  self reference
   * @param start start position for slice
   * @param end   end position for slice
   * @return sliced out substring
   */
  @SpecializedFunction
  public static String slice(Object self, int start, int end) {
    var str = checkObjectToString(self);
    var len = str.length();
    var from = start < 0 ? Math.max(len + start, 0) : Math.min(start, len);
    var to = end < 0 ? Math.max(len + end, 0) : Math.min(end, len);
    return str.substring(Math.min(from, to), to);
  }

  /**
   * ECMA 15.5.4.13 String.prototype.slice (start, end) specialized for two double parameters
   * @param self  self reference
   * @param start start position for slice
   * @param end   end position for slice
   * @return sliced out substring
   */
  @SpecializedFunction
  public static String slice(Object self, double start, double end) {
    return slice(self, (int) start, (int) end);
  }

  /**
   * ECMA 15.5.4.14 String.prototype.split (separator, limit)
   * @param self      self reference
   * @param separator separator for split
   * @param limit     limit for splits
   * @return array object in which splits have been placed
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static ScriptObject split(Object self, Object separator, Object limit) {
    var str = checkObjectToString(self);
    var lim = limit == UNDEFINED ? JSType.MAX_UINT : JSType.toUint32(limit);
    if (separator == UNDEFINED) {
      return lim == 0 ? new NativeArray() : new NativeArray(new Object[]{str});
    }
    if (separator instanceof NativeRegExp nre) {
      return nre.split(str, lim);
    }
    // when separator is a string, it is treated as a literal search string to be used for splitting.
    return splitString(str, JSType.toString(separator), lim);
  }

  private static ScriptObject splitString(String str, String separator, long limit) {
    if (separator.isEmpty()) {
      var length = (int) Math.min(str.length(), limit);
      var array = new Object[length];
      for (var i = 0; i < length; i++) {
        array[i] = String.valueOf(str.charAt(i));
      }
      return new NativeArray(array);
    }
    var elements = new LinkedList<String>();
    var strLength = str.length();
    var sepLength = separator.length();
    var pos = 0;
    var n = 0;
    while (pos < strLength && n < limit) {
      var found = str.indexOf(separator, pos);
      if (found == -1) {
        break;
      }
      elements.add(str.substring(pos, found));
      n++;
      pos = found + sepLength;
    }
    if (pos <= strLength && n < limit) {
      elements.add(str.substring(pos));
    }
    return new NativeArray(elements.toArray());
  }

  /**
   * ECMA B.2.3 String.prototype.substr (start, length)
   * @param self   self reference
   * @param start  start position
   * @param length length of section
   * @return substring given start and length of section
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String substr(Object self, Object start, Object length) {
    var str = JSType.toString(self);
    var strLength = str.length();
    var intStart = JSType.toInteger(start);
    if (intStart < 0) {
      intStart = Math.max(intStart + strLength, 0);
    }
    var intLen = Math.min(Math.max(length == UNDEFINED ? Integer.MAX_VALUE : JSType.toInteger(length), 0), strLength - intStart);
    return intLen <= 0 ? "" : str.substring(intStart, intStart + intLen);
  }

  /**
   * ECMA 15.5.4.15 String.prototype.substring (start, end)
   * @param self  self reference
   * @param start start position of substring
   * @param end   end position of substring
   * @return substring given start and end indexes
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String substring(Object self, Object start, Object end) {
    var str = checkObjectToString(self);
    return (end == UNDEFINED) ? substring(str, JSType.toInteger(start)) : substring(str, JSType.toInteger(start), JSType.toInteger(end));
  }

  /**
   * ECMA 15.5.4.15 String.prototype.substring (start, end) specialized for int start parameter
   * @param self  self reference
   * @param start start position of substring
   * @return substring given start and end indexes
   */
  @SpecializedFunction
  public static String substring(Object self, int start) {
    var str = checkObjectToString(self);
    return (start < 0) ? str
         : (start >= str.length()) ? ""
         : str.substring(start);
  }

  /**
   * ECMA 15.5.4.15 String.prototype.substring (start, end) specialized for double start parameter
   * @param self  self reference
   * @param start start position of substring
   * @return substring given start and end indexes
   */
  @SpecializedFunction
  public static String substring(Object self, double start) {
    return substring(self, (int) start);
  }

  /**
   * ECMA 15.5.4.15 String.prototype.substring (start, end) specialized for int start and end parameters
   * @param self  self reference
   * @param start start position of substring
   * @param end   end position of substring
   * @return substring given start and end indexes
   */
  @SpecializedFunction
  public static String substring(Object self, int start, int end) {
    var str = checkObjectToString(self);
    var len = str.length();
    var validStart = start < 0 ? 0 : start > len ? len : start;
    var validEnd = end < 0 ? 0 : end > len ? len : end;
    return (validStart < validEnd) ? str.substring(validStart, validEnd) : str.substring(validEnd, validStart);
  }

  /**
   * ECMA 15.5.4.15 String.prototype.substring (start, end) specialized for double start and end parameters
   * @param self  self reference
   * @param start start position of substring
   * @param end   end position of substring
   * @return substring given start and end indexes
   */
  @SpecializedFunction
  public static String substring(Object self, double start, double end) {
    return substring(self, (int) start, (int) end);
  }

  /**
   * ECMA 15.5.4.16 String.prototype.toLowerCase ( )
   * @param self self reference
   * @return string to lower case
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toLowerCase(Object self) {
    return checkObjectToString(self).toLowerCase(Locale.ROOT);
  }

  /**
   * ECMA 15.5.4.17 String.prototype.toLocaleLowerCase ( )
   * @param self self reference
   * @return string to locale sensitive lower case
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toLocaleLowerCase(Object self) {
    return checkObjectToString(self).toLowerCase(Global.getEnv()._locale);
  }

  /**
   * ECMA 15.5.4.18 String.prototype.toUpperCase ( )
   * @param self self reference
   * @return string to upper case
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toUpperCase(Object self) {
    return checkObjectToString(self).toUpperCase(Locale.ROOT);
  }

  /**
   * ECMA 15.5.4.19 String.prototype.toLocaleUpperCase ( )
   * @param self self reference
   * @return string to locale sensitive upper case
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toLocaleUpperCase(Object self) {
    return checkObjectToString(self).toUpperCase(Global.getEnv()._locale);
  }

  /**
   * ECMA 15.5.4.20 String.prototype.trim ( )
   * @param self self reference
   * @return string trimmed from whitespace
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String trim(Object self) {
    var str = checkObjectToString(self);
    var start = 0;
    var end = str.length() - 1;
    while (start <= end && ScriptRuntime.isJSWhitespace(str.charAt(start))) {
      start++;
    }
    while (end > start && ScriptRuntime.isJSWhitespace(str.charAt(end))) {
      end--;
    }
    return str.substring(start, end + 1);
  }

  /**
   * Nashorn extension: String.prototype.trimLeft ( )
   * @param self self reference
   * @return string trimmed left from whitespace
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String trimLeft(Object self) {
    var str = checkObjectToString(self);
    var start = 0;
    var end = str.length() - 1;
    while (start <= end && ScriptRuntime.isJSWhitespace(str.charAt(start))) {
      start++;
    }
    return str.substring(start, end + 1);
  }

  /**
   * Nashorn extension: String.prototype.trimRight ( )
   * @param self self reference
   * @return string trimmed right from whitespace
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String trimRight(Object self) {
    var str = checkObjectToString(self);
    var start = 0;
    var end = str.length() - 1;
    while (end >= start && ScriptRuntime.isJSWhitespace(str.charAt(end))) {
      end--;
    }
    return str.substring(start, end + 1);
  }

  static ScriptObject newObj(CharSequence str) {
    return new NativeString(str);
  }

  /**
   * ECMA 15.5.2.1 new String ( [ value ] )
   * Constructor
   * @param newObj is this constructor invoked with the new operator
   * @param self   self reference
   * @param args   arguments (a value)
   * @return new NativeString, empty string if no args, extraneous args ignored
   */
  @Constructor(arity = 1)
  public static Object constructor(boolean newObj, Object self, Object... args) {
    var str = args.length > 0 ? JSType.toCharSequence(args[0]) : "";
    return newObj ? newObj(str) : str.toString();
  }

  /**
   * ECMA 15.5.2.1 new String ( [ value ] ) - special version with no args
   * Constructor
   * @param newObj is this constructor invoked with the new operator
   * @param self   self reference
   * @return new NativeString ("")
   */
  @SpecializedFunction(isConstructor = true)
  public static Object constructor(boolean newObj, Object self) {
    return newObj ? newObj("") : "";
  }

  /**
   * ECMA 15.5.2.1 new String ( [ value ] ) - special version with one arg
   * Constructor
   * @param newObj is this constructor invoked with the new operator
   * @param self   self reference
   * @param arg    argument
   * @return new NativeString (arg)
   */
  @SpecializedFunction(isConstructor = true)
  public static Object constructor(boolean newObj, Object self, Object arg) {
    var str = JSType.toCharSequence(arg);
    return newObj ? newObj(str) : str.toString();
  }

  /**
   * ECMA 15.5.2.1 new String ( [ value ] ) - special version with exactly one {@code int} arg
   * Constructor
   * @param newObj is this constructor invoked with the new operator
   * @param self   self reference
   * @param arg    the arg
   * @return new NativeString containing the string representation of the arg
   */
  @SpecializedFunction(isConstructor = true)
  public static Object constructor(boolean newObj, Object self, int arg) {
    var str = Integer.toString(arg);
    return newObj ? newObj(str) : str;
  }

  /**
   * ECMA 15.5.2.1 new String ( [ value ] ) - special version with exactly one {@code double} arg
   * Constructor
   * @param newObj is this constructor invoked with the new operator
   * @param self   self reference
   * @param arg    the arg
   * @return new NativeString containing the string representation of the arg
   */
  @SpecializedFunction(isConstructor = true)
  public static Object constructor(boolean newObj, Object self, double arg) {
    var str = JSType.toString(arg);
    return newObj ? newObj(str) : str;
  }

  /**
   * ECMA 15.5.2.1 new String ( [ value ] ) - special version with exactly one {@code boolean} arg
   * Constructor
   * @param newObj is this constructor invoked with the new operator
   * @param self   self reference
   * @param arg    the arg
   * @return new NativeString containing the string representation of the arg
   */
  @SpecializedFunction(isConstructor = true)
  public static Object constructor(boolean newObj, Object self, boolean arg) {
    var str = Boolean.toString(arg);
    return newObj ? newObj(str) : str;
  }

  /**
   * ECMA 6 21.1.3.27 String.prototype [ @@iterator ]( )
   * @param self self reference
   * @return a string iterator
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, name = "@@iterator")
  public static Object getIterator(Object self) {
    return new StringIterator(checkObjectToString(self), Global.instance());
  }

  /**
   * Lookup the appropriate method for an invoke dynamic call.
   * @param request  the link request
   * @param receiver receiver of call
   * @return Link to be invoked at call site.
   */
  public static GuardedInvocation lookupPrimitive(LinkRequest request, Object receiver) {
    return PrimitiveLookup.lookupPrimitive(request, NashornGuards.getStringGuard(),
            new NativeString((CharSequence) receiver), WRAPFILTER, PROTOFILTER);
  }

  @SuppressWarnings("unused")
  static NativeString wrapFilter(Object receiver) {
    return new NativeString((CharSequence) receiver);
  }

  @SuppressWarnings("unused")
  static Object protoFilter(Object object) {
    return Global.instance().getStringPrototype();
  }

  static CharSequence getCharSequence(Object self) {
    if (JSType.isString(self)) {
      return (CharSequence) self;
    } else if (self instanceof NativeString n) {
      return n.getValue();
    } else if (self != null && self == Global.instance().getStringPrototype()) {
      return "";
    } else {
      throw typeError("not.a.string", ScriptRuntime.safeToString(self));
    }
  }

  static String getString(Object self) {
    if (self instanceof String s) {
      return s;
    } else if (self instanceof ConsString) {
      return self.toString();
    } else if (self instanceof NativeString n) {
      return n.getStringValue();
    } else if (self != null && self == Global.instance().getStringPrototype()) {
      return "";
    } else {
      throw typeError("not.a.string", ScriptRuntime.safeToString(self));
    }
  }

  /**
   * Combines ECMA 9.10 CheckObjectCoercible and ECMA 9.8 ToString with a shortcut for strings.
   * @param self the object
   * @return the object as string
   */
  static String checkObjectToString(Object self) {
    if (self instanceof String s) {
      return s;
    } else if (self instanceof ConsString) {
      return self.toString();
    } else {
      Global.checkObjectCoercible(self);
      return JSType.toString(self);
    }
  }

  boolean isValidStringIndex(int key) {
    return key >= 0 && key < value.length();
  }

  private static MethodHandle findOwnMH(String name, MethodType type) {
    return MH.findStatic(MethodHandles.lookup(), NativeString.class, name, type);
  }

  @Override
  public LinkLogic getLinkLogic(Class<? extends LinkLogic> type) {
    return (type == CharCodeAtLinkLogic.class) ? CharCodeAtLinkLogic.INSTANCE : null;
  }

  @Override
  public boolean hasPerInstanceAssumptions() {
    return false;
  }

  /**
   * This is linker logic charCodeAt - when we specialize further methods in NativeString.
   * It may be expanded.
   * It's link check makes sure that we are dealing with a char sequence and that we are in range
   */
  static final class CharCodeAtLinkLogic extends SpecializedFunction.LinkLogic {

    private static final CharCodeAtLinkLogic INSTANCE = new CharCodeAtLinkLogic();

    @Override
    public boolean canLink(Object self, CallSiteDescriptor desc, LinkRequest request) {
      try {
        // check that it's a char sequence or throw cce
        var cs = (CharSequence) self;
        // check that the index, representable as an int, is inside the array
        var intIndex = JSType.toInteger(request.getArguments()[2]);
        return intIndex >= 0 && intIndex < cs.length(); //can link
      } catch (ClassCastException | IndexOutOfBoundsException e) {
        // fallthru
      }
      return false;
    }

    /**
     * charCodeAt callsites can throw ClassCastException as a mechanism to have them relinked
     * - this enabled fast checks of the kind of ((IntArrayData)arrayData).push(x) for an IntArrayData only push
     * - if this fails, a CCE will be thrown and we will relink
     */
    @Override
    public Class<? extends Throwable> getRelinkException() {
      return ClassCastException.class;
    }
  }

}
