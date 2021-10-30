package es.runtime;

import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Objects;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.SwitchPoint;
import java.lang.reflect.Array;

import jdk.dynalink.beans.BeansLinker;
import jdk.dynalink.beans.StaticClass;

import nash.scripting.JSObject;
import nash.scripting.ScriptObjectMirror;

import es.codegen.ApplySpecialization;
import es.codegen.CompilerConstants;
import es.codegen.CompilerConstants.Call;
import es.objects.AbstractIterator;
import es.objects.Global;
import es.objects.NativeObject;
import es.objects.NativeJava;
import es.parser.Lexer;
import es.runtime.arrays.ArrayIndex;
import es.runtime.linker.Bootstrap;
import static es.codegen.CompilerConstants.staticCall;
import static es.codegen.CompilerConstants.staticCallNoLookup;
import static es.runtime.ECMAErrors.rangeError;
import static es.runtime.ECMAErrors.referenceError;
import static es.runtime.ECMAErrors.syntaxError;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.JSType.isRepresentableAsInt;
import static es.runtime.JSType.isString;

/**
 * Utilities to be called by JavaScript runtime API and generated classes.
 */
public final class ScriptRuntime {

  /** Singleton representing the empty array object '[]' */
  public static final Object[] EMPTY_ARRAY = new Object[0];

  /** Unique instance of undefined. */
  public static final Undefined UNDEFINED = Undefined.getUndefined();

  /**
   * Unique instance of undefined used to mark empty array slots.
   * Can't escape the array.
   */
  public static final Undefined EMPTY = Undefined.getEmpty();

  /** Method handle to generic + operator, operating on objects */
  public static final Call ADD = staticCallNoLookup(ScriptRuntime.class, "ADD", Object.class, Object.class, Object.class);

  /** Method handle to generic === operator, operating on objects */
  public static final Call EQUIV = staticCallNoLookup(ScriptRuntime.class, "EQUIV", boolean.class, Object.class, Object.class);

  /** Method handle used to enter a {@code with} scope at runtime. */
  public static final Call OPEN_WITH = staticCallNoLookup(ScriptRuntime.class, "openWith", ScriptObject.class, ScriptObject.class, Object.class);

  /**
   * Method used to place a scope's variable into the Global scope, which has to be done for the
   * properties declared at outermost script level.
   */
  public static final Call MERGE_SCOPE = staticCallNoLookup(ScriptRuntime.class, "mergeScope", ScriptObject.class, ScriptObject.class);

  /** Return an appropriate iterator for the elements in a for-in construct */
  public static final Call TO_PROPERTY_ITERATOR = staticCallNoLookup(ScriptRuntime.class, "toPropertyIterator", Iterator.class, Object.class);

  /** Return an appropriate iterator for the elements in a for-each construct */
  public static final Call TO_VALUE_ITERATOR = staticCallNoLookup(ScriptRuntime.class, "toValueIterator", Iterator.class, Object.class);

  /** Return an appropriate iterator for the elements in a ES6 for-of loop */
  public static final Call TO_ES6_ITERATOR = staticCallNoLookup(ScriptRuntime.class, "toES6Iterator", Iterator.class, Object.class);

  /**
   * Method handle for apply.
   * Used from {@link ScriptFunction} for looking up calls to call sites that are known to be megamorphic.
   * Using an invoke dynamic here would lead to the JVM deoptimizing itself to death.
   */
  public static final Call APPLY = staticCall(MethodHandles.lookup(), ScriptRuntime.class, "apply", Object.class, ScriptFunction.class, Object.class, Object[].class);

  /** Throws a reference error for an undefined variable. */
  public static final Call THROW_REFERENCE_ERROR = staticCall(MethodHandles.lookup(), ScriptRuntime.class, "throwReferenceError", void.class, String.class);

  /** Throws a reference error for an undefined variable. */
  public static final Call THROW_CONST_TYPE_ERROR = staticCall(MethodHandles.lookup(), ScriptRuntime.class, "throwConstTypeError", void.class, String.class);

  /** Used to invalidate builtin names, e.g "Function" mapping to all properties in Function.prototype and Function.prototype itself. */
  public static final Call INVALIDATE_RESERVED_BUILTIN_NAME = staticCallNoLookup(ScriptRuntime.class, "invalidateReservedBuiltinName", void.class, String.class);

  /** Used to perform failed delete */
  public static final Call FAIL_DELETE = staticCallNoLookup(ScriptRuntime.class, "failDelete", boolean.class, String.class);

  /** Used to find the scope for slow delete */
  public static final Call SLOW_DELETE = staticCallNoLookup(ScriptRuntime.class, "slowDelete", boolean.class, ScriptObject.class, String.class);

  /**
   * Converts a switch tag value to a simple integer. deflt value if it can't.
   * @param tag   Switch statement tag value.
   * @param deflt default to use if not convertible.
   * @return int tag value (or deflt.)
   */
  public static int switchTagAsInt(Object tag, int deflt) {
    if (tag instanceof Number n) {
      var d = n.doubleValue();
      if (isRepresentableAsInt(d)) {
        return (int) d;
      }
    }
    return deflt;
  }

  /**
   * Converts a switch tag value to a simple integer; deflt value if it can't.
   * @param tag   Switch statement tag value.
   * @param deflt default to use if not convertible.
   * @return int tag value (or deflt.)
   */
  public static int switchTagAsInt(boolean tag, int deflt) {
    return deflt;
  }

  /**
   * Converts a switch tag value to a simple integer. deflt value if it can't.
   * @param tag   Switch statement tag value.
   * @param deflt default to use if not convertible.
   * @return int tag value (or deflt.)
   */
  public static int switchTagAsInt(long tag, int deflt) {
    return isRepresentableAsInt(tag) ? (int) tag : deflt;
  }

  /**
   * Converts a switch tag value to a simple integer. deflt value if it can't.
   * @param tag   Switch statement tag value.
   * @param deflt default to use if not convertible.
   * @return int tag value (or deflt.)
   */
  public static int switchTagAsInt(double tag, int deflt) {
    return isRepresentableAsInt(tag) ? (int) tag : deflt;
  }

  /**
   * This is the builtin implementation of {@code Object.prototype.toString}
   * @param self reference
   * @return string representation as object
   */
  public static String builtinObjectToString(Object self) {
    // Spec tells us to convert primitives by ToObject..
    // But we don't need to -- all we need is the right class name of the corresponding primitive wrapper type.
    var type = JSType.ofNoFunction(self);
    var className = switch (type) {
      case BOOLEAN -> "Boolean";
      case NUMBER -> "Number";
      case STRING -> "String";
      case OBJECT -> {
        yield (self instanceof ScriptObject so) ? so.getClassName()
            : (self instanceof JSObject jso) ? jso.getClassName()
            : self.getClass().getName();
      }
      // special case of null and undefined
      case NULL -> "Null";
      case UNDEFINED -> "Undefined";
      // Nashorn extension: use Java class name
      default -> self.getClass().getName();
    };
    return "[object " + className + ']';
  }

  /**
   * This is called whenever runtime wants to throw an error and wants to provide meaningful information about an object.
   * We don't want to call toString which ends up calling "toString" from script world which may itself throw error.
   * When we want to throw an error, we don't additional error from script land -- which may sometimes lead to infinite recursion.
   * @param obj Object to converted to String safely (without calling user script)
   * @return safe String representation of the given object
   */
  public static String safeToString(Object obj) {
    return JSType.toStringImpl(obj, true);
  }

  /**
   * Returns an iterator over property identifiers used in the {@code for...in} statement.
   * Note that the ECMAScript 5.1 specification, chapter 12.6.4. uses the terminology "property names", which seems to imply that the property identifiers are expected to be strings, but this is not actually spelled out anywhere, and Nashorn will in some cases deviate from this.
   * Namely, we guarantee to always return an iterator over {@link String} values for any built-in JavaScript object.
   * We will however return an iterator over {@link Integer} objects for native Java arrays and {@link List} objects, as well as arbitrary objects representing keys of a {@link Map}.
   * Therefore, the expression {@code typeof i} within a {@code for(i in obj)} statement can return something other than {@code string} when iterating over native Java arrays, {@code List}, and {@code Map} objects.
   * @param obj object to iterate on.
   * @return iterator over the object's property names.
   */
  public static Iterator<?> toPropertyIterator(Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.propertyIterator();
    }
    if (obj != null && obj.getClass().isArray()) {
      return new RangeIterator(Array.getLength(obj));
    }
    if (obj instanceof JSObject jso) {
      return jso.keySet().iterator();
    }
    if (obj instanceof List<?> l) {
      return new RangeIterator(l.size());
    }
    if (obj instanceof Map<?,?> m) {
      return m.keySet().iterator();
    }
    var wrapped = Global.instance().wrapAsObject(obj);
    if (wrapped instanceof ScriptObject so) {
      return so.propertyIterator();
    }
    return Collections.emptyIterator();
  }

  static final class RangeIterator implements Iterator<Integer> {

    private final int length;
    private int index;

    RangeIterator(int length) {
      this.length = length;
    }
    @Override
    public boolean hasNext() {
      return index < length;
    }
    @Override
    public Integer next() {
      return index++;
    }
    @Override
    public void remove() {
      throw new UnsupportedOperationException("remove");
    }
  }

  // value Iterator for important Java objects - arrays, maps, iterables.
  static Iterator<?> iteratorForJavaArrayOrList(Object obj) {
    if (obj != null && obj.getClass().isArray()) {
      var array = obj;
      var length = Array.getLength(obj);
      return new Iterator<>() {
        private int index = 0;
        @Override
        public boolean hasNext() {
          return index < length;
        }
        @Override
        public Object next() {
          if (index >= length) {
            throw new NoSuchElementException();
          }
          return Array.get(array, index++);
        }
        @Override
        public void remove() {
          throw new UnsupportedOperationException("remove");
        }
      };
    }
    return (obj instanceof Iterable<?> i) ? i.iterator() : null;
  }

  /**
   * Returns an iterator over property values used in the {@code for each...in} statement.
   * Aside from built-in JS objects, it also operates on Java arrays, any {@link Iterable}, as well as on {@link Map} objects, iterating over map values.
   * @param obj object to iterate on.
   * @return iterator over the object's property values.
   */
  public static Iterator<?> toValueIterator(Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.valueIterator();
    }
    if (obj instanceof JSObject jso) {
      return jso.values().iterator();
    }
    var itr = iteratorForJavaArrayOrList(obj);
    if (itr != null) {
      return itr;
    }
    if (obj instanceof Map<?,?> m) {
      return m.values().iterator();
    }
    var wrapped = Global.instance().wrapAsObject(obj);
    return (wrapped instanceof ScriptObject so) ? so.valueIterator() : Collections.emptyIterator();
  }

  /**
   * Returns an iterator over property values used in the {@code for ... of} statement.
   * The iterator uses the Iterator interface defined in version 6 of the ECMAScript specification.
   * @param obj object to iterate on.
   * @return iterator based on the ECMA 6 Iterator interface.
   */
  public static Iterator<?> toES6Iterator(Object obj) {
    // if not a ScriptObject, try convenience iterator for Java objects!
    if (!(obj instanceof ScriptObject)) {
      var itr = iteratorForJavaArrayOrList(obj);
      if (itr != null) {
        return itr;
      }
      if (obj instanceof Map<?,?> m) {
        return new Iterator<>() {
          private Iterator<?> iter = m.entrySet().iterator();

          @Override
          public boolean hasNext() {
            return iter.hasNext();
          }
          @Override
          public Object next() {
            var next = (Map.Entry) iter.next();
            var keyvalue = new Object[]{ next.getKey(), next.getValue() };
            var array = NativeJava.from(null, keyvalue);
            return array;
          }
          @Override
          public void remove() {
            iter.remove();
          }
        };
      }
    }
    var global = Global.instance();
    var iterator = AbstractIterator.getIterator(Global.toObject(obj), global);
    var nextInvoker = AbstractIterator.getNextInvoker(global);
    var doneInvoker = AbstractIterator.getDoneInvoker(global);
    var valueInvoker = AbstractIterator.getValueInvoker(global);
    return new Iterator<>() {
      private Object nextResult = nextResult();
      private Object nextResult() {
        try {
          var next = nextInvoker.getGetter().invokeExact(iterator);
          if (Bootstrap.isCallable(next)) {
            return nextInvoker.getInvoker().invokeExact(next, iterator, (Object) null);
          }
        } catch (RuntimeException | Error r) {
          throw r;
        } catch (Throwable t) {
          throw new RuntimeException(t);
        }
        return null;
      }
      @Override
      public boolean hasNext() {
        if (nextResult == null) {
          return false;
        }
        try {
          var done = doneInvoker.invokeExact(nextResult);
          return !JSType.toBoolean(done);
        } catch (RuntimeException | Error r) {
          throw r;
        } catch (Throwable t) {
          throw new RuntimeException(t);
        }
      }
      @Override
      public Object next() {
        if (nextResult == null) {
          return Undefined.getUndefined();
        }
        try {
          var result = nextResult;
          nextResult = nextResult();
          return valueInvoker.invokeExact(result);
        } catch (RuntimeException | Error r) {
          throw r;
        } catch (Throwable t) {
          throw new RuntimeException(t);
        }
      }
      @Override
      public void remove() {
        throw new UnsupportedOperationException("remove");
      }
    };
  }

  /**
   * Merge a scope into its prototype's map.
   * Merge a scope into its prototype.
   * @param scope Scope to merge.
   * @return prototype object after merge
   */
  public static ScriptObject mergeScope(ScriptObject scope) {
    var parentScope = scope.getProto();
    parentScope.addBoundProperties(scope);
    return parentScope;
  }

  /**
   * Call a function given self and args.
   * If the number of the arguments is known in advance, you can likely achieve better performance by creating a dynamic invoker using {@link Bootstrap#createDynamicCallInvoker(Class, Class...)} then using its {@link MethodHandle#invokeExact(Object...)} method instead.
   * @param target ScriptFunction object.
   * @param self   Receiver in call.
   * @param args   Call arguments.
   * @return Call result.
   */
  public static Object apply(ScriptFunction target, Object self, Object... args) {
    try {
      return target.invoke(self, args);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  /**
   * Throws a reference error for an undefined variable.
   * @param name the variable name
   */
  public static void throwReferenceError(String name) {
    throw referenceError("not.defined", name);
  }

  /**
   * Throws a type error for an assignment to a const.
   * @param name the const name
   */
  public static void throwConstTypeError(String name) {
    throw typeError("assign.constant", name);
  }

  /**
   * Call a script function as a constructor with given args.
   * @param target ScriptFunction object.
   * @param args   Call arguments.
   * @return Constructor call result.
   */
  public static Object construct(ScriptFunction target, Object... args) {
    try {
      return target.construct(args);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  /**
   * Generic implementation of ECMA 9.12 - SameValue algorithm
   * @param x first value to compare
   * @param y second value to compare
   * @return true if both objects have the same value
   */
  public static boolean sameValue(Object x, Object y) {
    var xType = JSType.ofNoFunction(x);
    var yType = JSType.ofNoFunction(y);
    if (xType != yType) {
      return false;
    }
    if (xType == JSType.UNDEFINED || xType == JSType.NULL) {
      return true;
    }
    if (xType == JSType.NUMBER) {
      var xVal = ((Number) x).doubleValue();
      var yVal = ((Number) y).doubleValue();
      if (Double.isNaN(xVal) && Double.isNaN(yVal)) {
        return true;
      }
      // checking for xVal == -0.0 and yVal == +0.0 or vice versa
      if (xVal == 0.0 && Double.doubleToLongBits(xVal) != Double.doubleToLongBits(yVal)) {
        return false;
      }
      return xVal == yVal;
    }
    if (xType == JSType.STRING || yType == JSType.BOOLEAN) {
      return x.equals(y);
    }
    return x == y;
  }

  // Returns AST as JSON compatible string. This is used to implement "parse" function in resources/jarse.js script.
  // public static String parse(String code, String name, boolean includeLoc) { ... }

  /**
   * Test whether a char is valid JavaScript whitespace
   * @param ch a char
   * @return true if valid JavaScript whitespace
   */
  public static boolean isJSWhitespace(char ch) {
    return Lexer.isJSWhitespace(ch);
  }

  /**
   * Entering a {@code with} node requires new scope.
   * This is the implementation. When exiting the with statement, use {@link ScriptObject#getProto()} on the scope.
   * @param scope      existing scope
   * @param expression expression in with
   * @return {@link WithObject} that is the new scope
   */
  public static ScriptObject openWith(ScriptObject scope, Object expression) {
    var global = Context.getGlobal();
    if (expression == UNDEFINED) {
      throw typeError(global, "cant.apply.with.to.undefined");
    } else if (expression == null) {
      throw typeError(global, "cant.apply.with.to.null");
    }
    if (expression instanceof ScriptObjectMirror som) {
      var unwrapped = ScriptObjectMirror.unwrap(expression, global);
      if (unwrapped instanceof ScriptObject so) {
        return new WithObject(scope, so);
      }
      // foreign ScriptObjectMirror
      var exprObj = global.newObject();
      NativeObject.bindAllProperties(exprObj, som);
      return new WithObject(scope, exprObj);
    }
    var wrappedExpr = JSType.toScriptObject(global, expression);
    if (wrappedExpr instanceof ScriptObject so) {
      return new WithObject(scope, so);
    }
    throw typeError(global, "cant.apply.with.to.non.scriptobject");
  }

  /**
   * ECMA 11.6.1 - The addition operator (+) - generic implementation
   * @param x  first term
   * @param y  second term
   * @return result of addition
   */
  public static Object ADD(Object x, Object y) {
    // This prefix code to handle Number special is for optimization.
    var xIsNumber = x instanceof Number;
    var yIsNumber = y instanceof Number;
    if (xIsNumber && yIsNumber) {
      return ((Number) x).doubleValue() + ((Number) y).doubleValue();
    }
    var xIsUndefined = x == UNDEFINED;
    var yIsUndefined = y == UNDEFINED;
    if (xIsNumber && yIsUndefined || xIsUndefined && yIsNumber || xIsUndefined && yIsUndefined) {
      return Double.NaN;
    }
    // code below is as per the spec.
    var xPrim = JSType.toPrimitive(x);
    var yPrim = JSType.toPrimitive(y);
    if (isString(xPrim) || isString(yPrim)) {
      try {
        return new ConsString(JSType.toCharSequence(xPrim), JSType.toCharSequence(yPrim));
      } catch (IllegalArgumentException iae) {
        throw rangeError(iae, "concat.string.too.big");
      }
    }
    return JSType.toNumber(xPrim) + JSType.toNumber(yPrim);
  }

  /**
   * Debugger hook.
   * TODO: currently unimplemented
   * @return undefined
   */
  public static Object DEBUGGER() {
    return UNDEFINED;
  }

  /**
   * New hook
   * @param type type for the class
   * @param args  constructor arguments
   * @return undefined
   */
  public static Object NEW(Object type, Object... args) {
    return UNDEFINED;
  }

  /**
   * ECMA 11.4.3 The typeof Operator - generic implementation
   * @param object   the object from which to retrieve property to type check
   * @param property property in object to check
   * @return type name
   */
  public static Object TYPEOF(Object object, Object property) {
    var obj = object;
    if (property != null) {
      if (obj instanceof ScriptObject sobj) {
        // this is a scope identifier
        assert property instanceof String;
        var find = sobj.findProperty(property, true, true, sobj);
        if (find != null) {
          obj = find.getObjectValue();
        } else {
          obj = sobj.invokeNoSuchProperty(property, false, UnwarrantedOptimismException.INVALID_PROGRAM_POINT);
        }
        if (Global.isLocationPropertyPlaceholder(obj)) {
          if (CompilerConstants.__LINE__.name().equals(property)) {
            obj = 0;
          } else {
            obj = "";
          }
        }
      } else if (object instanceof Undefined u) {
        obj = u.get(property);
      } else if (object == null) {
        throw typeError("cant.get.property", safeToString(property), "null");
      } else if (JSType.isPrimitive(obj)) {
        obj = ((ScriptObject) JSType.toScriptObject(obj)).get(property);
      } else if (obj instanceof JSObject jso) {
        obj = jso.getMember(property.toString());
      } else {
        obj = UNDEFINED;
      }
    }
    return JSType.of(obj).typeName();
  }

  /**
   * Throw ReferenceError when LHS of assignment or increment/decrement operator is not an assignable node (say a literal)
   * @param lhs Evaluated LHS
   * @param rhs Evaluated RHS
   * @param msg Additional LHS info for error message
   * @return undefined
   */
  public static Object REFERENCE_ERROR(Object lhs, Object rhs, Object msg) {
    throw referenceError("cant.be.used.as.lhs", Objects.toString(msg));
  }

  /**
   * ECMA 11.4.1 - delete operator, implementation for slow scopes
   * This implementation of 'delete' walks the scope chain to find the scope that contains the property to be deleted, then invokes delete on it.
   * Always used on scopes, never strict.
   * @param obj       top scope object
   * @param property  property to delete
   * @return true if property was successfully found and deleted
   */
  public static boolean slowDelete(ScriptObject obj, String property) {
    var sobj = obj;
    while (sobj != null && sobj.isScope()) {
      var find = sobj.findProperty(property, false);
      if (find != null) {
        return sobj.delete(property);
      }
      sobj = sobj.getProto();
    }
    return obj.delete(property);
  }

  /**
   * ECMA 11.4.1 - delete operator, special case
   * This is 'delete' on a scope; it always fails.
   * It always throws an exception, but is declared to return a boolean to be compatible with the delete operator type.
   * @param property  property to delete
   * @return nothing, always throws an exception.
   */
  public static boolean failDelete(String property) {
    throw syntaxError("cant.delete", property);
  }

  /**
   * ECMA 11.9.1 - The equals operator (==) - generic implementation
   * @param x first object to compare
   * @param y second object to compare
   * @return true if type coerced versions of objects are equal
   */
  public static boolean EQ(Object x, Object y) {
    return equals(x, y);
  }

  /**
   * ECMA 11.9.2 - The does-not-equal operator (==) - generic implementation
   * @param x first object to compare
   * @param y second object to compare
   * @return true if type coerced versions of objects are not equal
   */
  public static boolean NE(Object x, Object y) {
    return !EQ(x, y);
  }

  /** ECMA 11.9.3 The Abstract Equality Comparison Algorithm */
  static boolean equals(Object x, Object y) {
    // We want to keep this method small so we skip reference equality check for numbers as NaN should return false when compared to itself (JDK-8043608).
    if (x == y && !(x instanceof Number)) {
      return true;
    }
    if (x instanceof ScriptObject && y instanceof ScriptObject) {
      return false; // x != y
    }
    if (x instanceof ScriptObjectMirror || y instanceof ScriptObjectMirror) {
      return ScriptObjectMirror.identical(x, y);
    }
    return equalValues(x, y);
  }

  /**
   * Extracted portion of {@code equals()} that compares objects by value (or by reference, if no known value comparison applies).
   * @param x one value
   * @param y another value
   * @return true if they're equal according to 11.9.3
   */
  static boolean equalValues(Object x, Object y) {
    var xType = JSType.ofNoFunction(x);
    var yType = JSType.ofNoFunction(y);
    return (xType == yType) ? equalSameTypeValues(x, y, xType) : equalDifferentTypeValues(x, y, xType, yType);
  }

  /**
   * Extracted portion of {@link #equals(Object, Object)} and {@link #properEquals(Object, Object)} that compares values belonging to the same JSType.
   * @param x one value
   * @param y another value
   * @param type the common type for the values
   * @return true if they're equal
   */
  static boolean equalSameTypeValues(Object x, Object y, JSType type) {
    if (type == JSType.UNDEFINED || type == JSType.NULL) {
      return true;
    }
    if (type == JSType.NUMBER) {
      return ((Number) x).doubleValue() == ((Number) y).doubleValue();
    }
    if (type == JSType.STRING) {
      // String may be represented by ConsString
      return x.toString().equals(y.toString());
    }
    if (type == JSType.BOOLEAN) {
      return ((Boolean) x).booleanValue() == ((Boolean) y).booleanValue();
    }
    return x == y;
  }

  /**
   * Extracted portion of {@link #equals(Object, Object)} that compares values belonging to different JSTypes.
   * @param x one value
   * @param y another value
   * @param xType the type for the value x
   * @param yType the type for the value y
   * @return true if they're equal
   */
  static boolean equalDifferentTypeValues(Object x, Object y, JSType xType, JSType yType) {
    if (isUndefinedAndNull(xType, yType) || isUndefinedAndNull(yType, xType)) {
      return true;
    } else if (isNumberAndString(xType, yType)) {
      return equalNumberToString(x, y);
    } else if (isNumberAndString(yType, xType)) {
      // Can reverse order as both are primitives
      return equalNumberToString(y, x);
    } else if (xType == JSType.BOOLEAN) {
      return equalBooleanToAny(x, y);
    } else if (yType == JSType.BOOLEAN) {
      // Can reverse order as y is primitive
      return equalBooleanToAny(y, x);
    } else if (isPrimitiveAndObject(xType, yType)) {
      return equalWrappedPrimitiveToObject(x, y);
    } else if (isPrimitiveAndObject(yType, xType)) {
      // Can reverse order as y is primitive
      return equalWrappedPrimitiveToObject(y, x);
    }
    return false;
  }

  static boolean isUndefinedAndNull(JSType xType, JSType yType) {
    return xType == JSType.UNDEFINED && yType == JSType.NULL;
  }

  static boolean isNumberAndString(JSType xType, JSType yType) {
    return xType == JSType.NUMBER && yType == JSType.STRING;
  }

  static boolean isPrimitiveAndObject(JSType xType, JSType yType) {
    return (xType == JSType.NUMBER || xType == JSType.STRING || xType == JSType.SYMBOL) && yType == JSType.OBJECT;
  }

  static boolean equalNumberToString(Object num, Object str) {
    // Specification says comparing a number to string should be done as "equals(num, JSType.toNumber(str))".
    // We can short circuit it to this as we know that "num" is a number, so it'll end up being a number-number comparison.
    return ((Number) num).doubleValue() == JSType.toNumber(str.toString());
  }

  static boolean equalBooleanToAny(Object bool, Object any) {
    return equals(JSType.toNumber((Boolean) bool), any);
  }

  static boolean equalWrappedPrimitiveToObject(Object numOrStr, Object any) {
    return equals(numOrStr, JSType.toPrimitive(any));
  }

  /**
   * ECMA 11.9.4 - The equivalent operator (===) - generic implementation
   * @param x first object to compare
   * @param y second object to compare
   * @return true if objects are equal
   */
  public static boolean EQUIV(Object x, Object y) {
    return properEquals(x, y);
  }

  /**
   * ECMA 11.9.5 - The not-equivalent operator (!==) - generic implementation
   * @param x first object to compare
   * @param y second object to compare
   * @return true if objects are not equal
   */
  public static boolean NOT_EQUIV(Object x, Object y) {
    return !EQUIV(x, y);
  }

  /** ECMA 11.9.6 The Proper Equality Comparison Algorithm */
  static boolean properEquals(Object x, Object y) {
    // NOTE: you might be tempted to do a quick x == y comparison.
    // Remember, though, that any Double object having NaN value is not equal to itself by value even though it is referentially.
    var xType = JSType.ofNoFunction(x);
    var yType = JSType.ofNoFunction(y);
    return (xType == yType) && equalSameTypeValues(x, y, xType);
  }

  /**
   * ECMA 11.8.6 - The in operator - generic implementation
   * @param property property to check for
   * @param obj object in which to check for property
   * @return true if objects are equal
   */
  public static boolean IN(Object property, Object obj) {
    var rvalType = JSType.ofNoFunction(obj);
    if (rvalType == JSType.OBJECT) {
      if (obj instanceof ScriptObject so) {
        return so.has(property);
      }
      if (obj instanceof JSObject jso) {
        return jso.hasMember(Objects.toString(property));
      }
      var key = JSType.toPropertyKey(property);
      if (obj instanceof StaticClass sc) {
        var type = sc.getRepresentedClass();
        return BeansLinker.getReadableStaticPropertyNames(type).contains(Objects.toString(key)) || BeansLinker.getStaticMethodNames(type).contains(Objects.toString(key));
      } else {
        if (obj instanceof Map m && m.containsKey(key)) {
          return true;
        }
        var index = ArrayIndex.getArrayIndex(key);
        if (index >= 0) {
          if (obj instanceof List l && index < l.size()) {
            return true;
          }
          if (obj.getClass().isArray() && index < Array.getLength(obj)) {
            return true;
          }
        }
        return BeansLinker.getReadableInstancePropertyNames(obj.getClass()).contains(Objects.toString(key)) || BeansLinker.getInstanceMethodNames(obj.getClass()).contains(Objects.toString(key));
      }
    }
    throw typeError("in.with.non.object", rvalType.toString().toLowerCase(Locale.ENGLISH));
  }

  /**
   * ECMA 11.8.6 - The proper instanceof operator - generic implementation
   * @param obj first object to compare
   * @param type type to check against
   * @return true if {@code obj} is an instanceof {@code type}
   */
  public static boolean INSTANCEOF(Object obj, Object type) {
    if (type instanceof ScriptFunction sf) {
      if (obj instanceof ScriptObject so) {
        return sf.isInstance(so);
      }
      return false;
    }
    if (type instanceof StaticClass sc) {
      return sc.getRepresentedClass().isInstance(obj);
    }
    if (type instanceof JSObject jso) {
      return jso.isInstance(obj);
    }
    // provide for reverse hook
    if (obj instanceof JSObject jso) {
      return jso.isInstanceOf(type);
    }
    throw typeError("instanceof.on.non.object");
  }

  /**
   * ECMA 11.8.1 - The less than operator ({@literal <}) - generic implementation
   * @param x first object to compare
   * @param y second object to compare
   * @return true if x is less than y
   */
  public static boolean LT(Object x, Object y) {
    var px = JSType.toPrimitive(x, Number.class);
    var py = JSType.toPrimitive(y, Number.class);
    return areBothString(px, py) ? px.toString().compareTo(py.toString()) < 0 : JSType.toNumber(px) < JSType.toNumber(py);
  }

  static boolean areBothString(Object x, Object y) {
    return isString(x) && isString(y);
  }

  /**
   * ECMA 11.8.2 - The greater than operator ({@literal >}) - generic implementation
   * @param x first object to compare
   * @param y second object to compare
   * @return true if x is greater than y
   */
  public static boolean GT(Object x, Object y) {
    var px = JSType.toPrimitive(x, Number.class);
    var py = JSType.toPrimitive(y, Number.class);
    return areBothString(px, py) ? px.toString().compareTo(py.toString()) > 0 : JSType.toNumber(px) > JSType.toNumber(py);
  }

  /**
   * ECMA 11.8.3 - The less than or equal operator ({@literal <=}) - generic implementation
   * @param x first object to compare
   * @param y second object to compare
   * @return true if x is less than or equal to y
   */
  public static boolean LE(Object x, Object y) {
    var px = JSType.toPrimitive(x, Number.class);
    var py = JSType.toPrimitive(y, Number.class);
    return areBothString(px, py) ? px.toString().compareTo(py.toString()) <= 0 : JSType.toNumber(px) <= JSType.toNumber(py);
  }

  /**
   * ECMA 11.8.4 - The greater than or equal operator ({@literal >=}) - generic implementation
   * @param x first object to compare
   * @param y second object to compare
   * @return true if x is greater than or equal to y
   */
  public static boolean GE(Object x, Object y) {
    var px = JSType.toPrimitive(x, Number.class);
    var py = JSType.toPrimitive(y, Number.class);
    return areBothString(px, py) ? px.toString().compareTo(py.toString()) >= 0 : JSType.toNumber(px) >= JSType.toNumber(py);
  }

  /**
   * Tag a reserved name as invalidated - used when someone writes to a property with this name - overly conservative, but link time is too late to apply e.g. apply-&gt;call specialization
   * @param name property name
   */
  public static void invalidateReservedBuiltinName(String name) {
    var context = Context.getContextTrusted();
    var sp = context.getBuiltinSwitchPoint(name);
    assert sp != null;
    SwitchPoint.invalidateAll(new SwitchPoint[]{sp});
  }

  /**
   * ES6 12.2.9.3 Runtime Semantics: GetTemplateObject(templateLiteral).
   * @param rawStrings array of template raw values
   * @param cookedStrings array of template values
   * @return template object
   */
  public static ScriptObject GET_TEMPLATE_OBJECT(Object rawStrings, Object cookedStrings) {
    var template = (ScriptObject) cookedStrings;
    var rawObj = (ScriptObject) rawStrings;
    assert rawObj.getArray().length() == template.getArray().length();
    template.addOwnProperty("raw", Property.NOT_WRITABLE | Property.NOT_ENUMERABLE | Property.NOT_CONFIGURABLE, rawObj.freeze());
    template.freeze();
    return template;
  }

}
