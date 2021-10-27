package es.runtime;

import static es.lookup.Lookup.MH;
import static es.runtime.ScriptRuntime.UNDEFINED;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.util.ArrayList;
import es.objects.Global;

/**
 * Instances of this class serve as "prototype" object for script functions.
 * The purpose is to expose "constructor" property from "prototype".
 * Also, nasgen generated prototype classes extend from this class.
 */
public class PrototypeObject extends ScriptObject {

  private static final PropertyMap map$;

  private Object constructor;

  private static final MethodHandle GET_CONSTRUCTOR = findOwnMH("getConstructor", Object.class, Object.class);
  private static final MethodHandle SET_CONSTRUCTOR = findOwnMH("setConstructor", void.class, Object.class, Object.class);

  static /*<init>*/ {
    var properties = new ArrayList<Property>(1);
    properties.add(AccessorProperty.create("constructor", Property.NOT_ENUMERABLE, GET_CONSTRUCTOR, SET_CONSTRUCTOR));
    map$ = PropertyMap.newMap(properties);
  }

  PrototypeObject(Global global, PropertyMap map) {
    super(global.getObjectPrototype(), map != map$ ? map.addAll(map$) : map$);
  }

  /**
   * Prototype constructor
   */
  protected PrototypeObject() {
    this(Global.instance(), map$);
  }

  /**
   * PropertyObject constructor
   *
   * @param map property map
   */
  protected PrototypeObject(PropertyMap map) {
    this(Global.instance(), map);
  }

  /**
   * PropertyObject constructor
   * @param func constructor function
   */
  protected PrototypeObject(ScriptFunction func) {
    this(Global.instance(), map$);
    this.constructor = func;
  }

  /**
   * Get the constructor for this {@code PrototypeObject}
   * @param self self reference
   * @return constructor, probably, but not necessarily, a {@link ScriptFunction}
   */
  public static Object getConstructor(Object self) {
    return (self instanceof PrototypeObject po) ? po.getConstructor() : UNDEFINED;
  }

  /**
   * Reset the constructor for this {@code PrototypeObject}
   * @param self self reference
   * @param constructor constructor, probably, but not necessarily, a {@link ScriptFunction}
   */
  public static void setConstructor(Object self, Object constructor) {
    if (self instanceof PrototypeObject po) {
      po.setConstructor(constructor);
    }
  }

  Object getConstructor() {
    return constructor;
  }

  void setConstructor(Object constructor) {
    this.constructor = constructor;
  }

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), PrototypeObject.class, name, MH.type(rtype, types));
  }

}
