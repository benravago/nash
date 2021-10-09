package es.objects;

import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;
import es.util.WeakValueCache;
import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.Getter;
import es.objects.annotations.Property;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.Where;
import es.runtime.JSType;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.Symbol;
import es.runtime.Undefined;
import es.runtime.linker.PrimitiveLookup;

/**
 * ECMAScript 6 - 19.4 Symbol Objects
 */
@ScriptClass("Symbol")
public final class NativeSymbol extends ScriptObject {

  private final Symbol symbol;

  /** Method handle to create an object wrapper for a primitive symbol. */
  static final MethodHandle WRAPFILTER = findOwnMH("wrapFilter", MH.type(NativeSymbol.class, Object.class));
  /** Method handle to retrieve the Symbol prototype object. */
  private static final MethodHandle PROTOFILTER = findOwnMH("protoFilter", MH.type(Object.class, Object.class));

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  /** See ES6 19.4.2.1 */
  private static WeakValueCache<String, Symbol> globalSymbolRegistry = new WeakValueCache<>();

  /**
   * ECMA 6 19.4.2.4 Symbol.iterator
   */
  @Property(where = Where.CONSTRUCTOR, attributes = Attribute.NON_ENUMERABLE_CONSTANT, name = "iterator")
  public static final Symbol iterator = new Symbol("Symbol.iterator");

  NativeSymbol(final Symbol symbol) {
    this(symbol, Global.instance());
  }

  NativeSymbol(final Symbol symbol, final Global global) {
    this(symbol, global.getSymbolPrototype(), $nasgenmap$);
  }

  private NativeSymbol(final Symbol symbol, final ScriptObject prototype, final PropertyMap map) {
    super(prototype, map);
    this.symbol = symbol;
  }

  private static Symbol getSymbolValue(final Object self) {
    if (self instanceof Symbol) {
      return (Symbol) self;
    } else if (self instanceof NativeSymbol) {
      return ((NativeSymbol) self).symbol;
    } else {
      throw typeError("not.a.symbol", ScriptRuntime.safeToString(self));
    }
  }

  /**
   * Lookup the appropriate method for an invoke dynamic call.
   *
   * @param request  The link request
   * @param receiver The receiver for the call
   * @return Link to be invoked at call site.
   */
  public static GuardedInvocation lookupPrimitive(final LinkRequest request, final Object receiver) {
    return PrimitiveLookup.lookupPrimitive(request, Symbol.class, new NativeSymbol((Symbol) receiver), WRAPFILTER, PROTOFILTER);
  }

  // ECMA 6 19.4.3.4 Symbol.prototype [ @@toPrimitive ] ( hint )
  @Override
  public Object getDefaultValue(final Class<?> typeHint) {
    // Just return the symbol value.
    return symbol;
  }

  /**
   * ECMA 6 19.4.3.2 Symbol.prototype.toString ( )
   *
   * @param self self reference
   * @return localized string for this Number
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toString(final Object self) {
    return getSymbolValue(self).toString();
  }

  /**
   * ECMA 6 19.4.3.3  Symbol.prototype.valueOf ( )
   *
   * @param self self reference
   * @return number value for this Number
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object valueOf(final Object self) {
    return getSymbolValue(self);
  }

  /**
   * ECMA 6 19.4.1.1 Symbol ( [ description ] )
   *
   * @param newObj is this function invoked with the new operator
   * @param self   self reference
   * @param args   arguments
   * @return new symbol value
   */
  @Constructor(arity = 1)
  public static Object constructor(final boolean newObj, final Object self, final Object... args) {
    if (newObj) {
      throw typeError("symbol.as.constructor");
    }
    final String description = args.length > 0 && args[0] != Undefined.getUndefined()
            ? JSType.toString(args[0]) : "";
    return new Symbol(description);
  }

  /**
   * ES6 19.4.2.1 Symbol.for ( key )
   *
   * @param self self reference
   * @param arg the argument
   * @return the symbol value
   */
  @Function(name = "for", attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public synchronized static Object _for(final Object self, final Object arg) {
    final String name = JSType.toString(arg);
    return globalSymbolRegistry.getOrCreate(name, Symbol::new);
  }

  /**
   * ES6 19.4.2.5 Symbol.keyFor ( sym )
   *
   * @param self self reference
   * @param arg the argument
   * @return the symbol name
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public synchronized static Object keyFor(final Object self, final Object arg) {
    if (!(arg instanceof Symbol)) {
      throw typeError("not.a.symbol", ScriptRuntime.safeToString(arg));
    }
    final String name = ((Symbol) arg).getName();
    return globalSymbolRegistry.get(name) == arg ? name : Undefined.getUndefined();
  }

  @SuppressWarnings("unused")
  private static NativeSymbol wrapFilter(final Object receiver) {
    return new NativeSymbol((Symbol) receiver);
  }

  @SuppressWarnings("unused")
  private static Object protoFilter(final Object object) {
    return Global.instance().getSymbolPrototype();
  }

  private static MethodHandle findOwnMH(final String name, final MethodType type) {
    return MH.findStatic(MethodHandles.lookup(), NativeSymbol.class, name, type);
  }

}
