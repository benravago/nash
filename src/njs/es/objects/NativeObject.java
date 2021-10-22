package es.objects;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.Operation;
import jdk.dynalink.beans.BeansLinker;
import jdk.dynalink.beans.StaticClass;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.GuardingDynamicLinker;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.support.SimpleLinkRequest;
import static jdk.dynalink.StandardNamespace.METHOD;
import static jdk.dynalink.StandardNamespace.PROPERTY;
import static jdk.dynalink.StandardOperation.GET;
import static jdk.dynalink.StandardOperation.SET;

import nash.scripting.ScriptObjectMirror;

import es.lookup.Lookup;
import es.objects.annotations.Attribute;
import es.objects.annotations.Constructor;
import es.objects.annotations.Function;
import es.objects.annotations.ScriptClass;
import es.objects.annotations.Where;
import es.runtime.AccessorProperty;
import es.runtime.ECMAException;
import es.runtime.JSType;
import es.runtime.Property;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import es.runtime.arrays.ArrayData;
import es.runtime.arrays.ArrayIndex;
import es.runtime.linker.Bootstrap;
import es.runtime.linker.InvokeByName;
import es.runtime.linker.NashornBeansLinker;
import es.runtime.linker.NashornCallSiteDescriptor;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * ECMA 15.2 Object objects: JavaScript Object constructor/prototype.
 *
 * Note: instances of this class are never created.
 * This class is not even a subclass of ScriptObject.
 * But, we use this class to generate prototype and constructor for "Object".
 */
@ScriptClass("Object")
public final class NativeObject {

  /** Methodhandle to proto getter */
  public static final MethodHandle GET__PROTO__ = findOwnMH("get__proto__", ScriptObject.class, Object.class);

  /** Methodhandle to proto setter */
  public static final MethodHandle SET__PROTO__ = findOwnMH("set__proto__", Object.class, Object.class, Object.class);

  private static final Object TO_STRING = new Object();

  static InvokeByName getTO_STRING() {
    return Global.instance().getInvokeByName(TO_STRING, () -> new InvokeByName("toString", ScriptObject.class));
  }

  private static final Operation GET_METHOD = GET.withNamespace(METHOD);
  private static final Operation GET_PROPERTY = GET.withNamespace(PROPERTY);
  private static final Operation SET_PROPERTY = SET.withNamespace(PROPERTY);

  @SuppressWarnings("unused")
  static ScriptObject get__proto__(Object self) {
    // See ES6 draft spec: B.2.2.1.1 get Object.prototype.__proto__
    // Step 1 Let O be the result of calling ToObject passing the this.
    var sobj = Global.checkObject(Global.toObject(self));
    return sobj.getProto();
  }

  @SuppressWarnings("unused")
  static Object set__proto__(Object self, Object proto) {
    // See ES6 draft spec: B.2.2.1.2 set Object.prototype.__proto__
    // Step 1
    Global.checkObjectCoercible(self);
    // Step 4
    if (!(self instanceof ScriptObject)) {
      return UNDEFINED;
    }
    var sobj = (ScriptObject) self;
    // __proto__ assignment ignores non-nulls and non-objects
    // step 3: If Type(proto) is neither Object nor Null, then return undefined.
    if (proto == null || proto instanceof ScriptObject) {
      sobj.setPrototypeOf(proto);
    }
    return UNDEFINED;
  }

  private static final MethodType MIRROR_GETTER_TYPE = MethodType.methodType(Object.class, ScriptObjectMirror.class);
  private static final MethodType MIRROR_SETTER_TYPE = MethodType.methodType(Object.class, ScriptObjectMirror.class, Object.class);

  // initialized by nasgen
  @SuppressWarnings("unused")
  static PropertyMap $nasgenmap$;

  static ECMAException notAnObject(Object obj) {
    return typeError("not.an.object", ScriptRuntime.safeToString(obj));
  }

  /**
   * Nashorn extension: setIndexedPropertiesToExternalArrayData
   * @param self self reference
   * @param obj object whose index properties are backed by buffer
   * @param buf external buffer - should be a nio ByteBuffer
   * @return the 'obj' object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static ScriptObject setIndexedPropertiesToExternalArrayData(Object self, Object obj, Object buf) {
    Global.checkObject(obj);
    var sobj = (ScriptObject) obj;
    if (buf instanceof ByteBuffer b) {
      sobj.setArray(ArrayData.allocate(b));
    }
    throw typeError("not.a.bytebuffer", "setIndexedPropertiesToExternalArrayData's buf argument");
  }

  /**
   * ECMA 15.2.3.2 Object.getPrototypeOf ( O )
   * @param  self self reference
   * @param  obj object to get prototype from
   * @return the prototype of an object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static Object getPrototypeOf(Object self, Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.getProto();
    } else if (obj instanceof ScriptObjectMirror som) {
      return som.getProto();
    } else {
      var type = JSType.of(obj);
      if (type == JSType.OBJECT) {
        // host (Java) objects have null __proto__
        return null;
      }
      // must be some JS primitive
      throw notAnObject(obj);
    }
  }

  /**
   * Nashorn extension: Object.setPrototypeOf ( O, proto )
   * Also found in ES6 draft specification.
   * @param  self self reference
   * @param  obj object to set prototype for
   * @param  proto prototype object to be used
   * @return object whose prototype is set
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static Object setPrototypeOf(Object self, Object obj, Object proto) {
    if (obj instanceof ScriptObject so) {
      so.setPrototypeOf(proto);
      return obj;
    } else if (obj instanceof ScriptObjectMirror som) {
      som.setProto(proto);
      return obj;
    }
    throw notAnObject(obj);
  }

  /**
   * ECMA 15.2.3.3 Object.getOwnPropertyDescriptor ( O, P )
   * @param self  self reference
   * @param obj   object from which to get property descriptor for {@code ToString(prop)}
   * @param prop  property descriptor
   * @return property descriptor
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static Object getOwnPropertyDescriptor(Object self, Object obj, Object prop) {
    if (obj instanceof ScriptObject sobj) {
      var key = JSType.toString(prop);
      return sobj.getOwnPropertyDescriptor(key);
    } else if (obj instanceof ScriptObjectMirror sobjMirror) {
      var key = JSType.toString(prop);
      return sobjMirror.getOwnPropertyDescriptor(key);
    } else {
      throw notAnObject(obj);
    }
  }

  /**
   * ECMA 15.2.3.4 Object.getOwnPropertyNames ( O )
   * @param self self reference
   * @param obj  object to query for property names
   * @return array of property names
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static ScriptObject getOwnPropertyNames(Object self, Object obj) {
    if (obj instanceof ScriptObject so) {
      return new NativeArray(so.getOwnKeys(true));
    } else if (obj instanceof ScriptObjectMirror som) {
      return new NativeArray(som.getOwnKeys(true));
    } else {
      throw notAnObject(obj);
    }
  }

  /**
   * ECMA 2 19.1.2.8 Object.getOwnPropertySymbols ( O )
   * @param self self reference
   * @param obj  object to query for property names
   * @return array of property names
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static ScriptObject getOwnPropertySymbols(Object self, Object obj) {
    if (obj instanceof ScriptObject so) {
      return new NativeArray(so.getOwnSymbols(true));
    } else {
      // TODO: we don't support this on ScriptObjectMirror objects yet
      throw notAnObject(obj);
    }
  }

  /**
   * ECMA 15.2.3.5 Object.create ( O [, Properties] )
   * @param self  self reference
   * @param proto prototype object
   * @param props properties to define
   * @return object created
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static ScriptObject create(Object self, Object proto, Object props) {
    if (proto != null) {
      Global.checkObject(proto);
    }
    // FIXME: should we create a proper object with correct number of properties?
    var newObj = Global.newEmptyInstance();
    newObj.setProto((ScriptObject) proto);
    if (props != UNDEFINED) {
      NativeObject.defineProperties(self, newObj, props);
    }
    return newObj;
  }

  /**
   * ECMA 15.2.3.6 Object.defineProperty ( O, P, Attributes )
   * @param self self reference
   * @param obj  object in which to define a property
   * @param prop property to define
   * @param attr attributes for property descriptor
   * @return object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static ScriptObject defineProperty(Object self, Object obj, Object prop, Object attr) {
    var sobj = Global.checkObject(obj);
    sobj.defineOwnProperty(JSType.toPropertyKey(prop), attr, true);
    return sobj;
  }

  /**
   * ECMA 5.2.3.7 Object.defineProperties ( O, Properties )
   * @param self  self reference
   * @param obj   object in which to define properties
   * @param props properties
   * @return object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static ScriptObject defineProperties(Object self, Object obj, Object props) {
    var sobj = Global.checkObject(obj);
    var propsObj = Global.toObject(props);
    if (propsObj instanceof ScriptObject so) {
      var keys = so.getOwnKeys(false);
      for (var key : keys) {
        var prop = JSType.toString(key);
        sobj.defineOwnProperty(prop, so.get(prop), true);
      }
    }
    return sobj;
  }

  /**
   * ECMA 15.2.3.8 Object.seal ( O )
   * @param self self reference
   * @param obj  object to seal
   * @return sealed object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static Object seal(Object self, Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.seal();
    } else if (obj instanceof ScriptObjectMirror som) {
      return som.seal();
    } else {
      throw notAnObject(obj);
    }
  }

  /**
   * ECMA 15.2.3.9 Object.freeze ( O )
   * @param self self reference
   * @param obj object to freeze
   * @return frozen object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static Object freeze(Object self, Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.freeze();
    } else if (obj instanceof ScriptObjectMirror som) {
      return som.freeze();
    } else {
      throw notAnObject(obj);
    }
  }

  /**
   * ECMA 15.2.3.10 Object.preventExtensions ( O )
   * @param self self reference
   * @param obj  object, for which to set the internal extensible property to false
   * @return object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static Object preventExtensions(Object self, Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.preventExtensions();
    } else if (obj instanceof ScriptObjectMirror som) {
      return som.preventExtensions();
    } else {
      throw notAnObject(obj);
    }
  }

  /**
   * ECMA 15.2.3.11 Object.isSealed ( O )
   * @param self self reference
   * @param obj check whether an object is sealed
   * @return true if sealed, false otherwise
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static boolean isSealed(Object self, Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.isSealed();
    } else if (obj instanceof ScriptObjectMirror som) {
      return som.isSealed();
    } else {
      throw notAnObject(obj);
    }
  }

  /**
   * ECMA 15.2.3.12 Object.isFrozen ( O )
   * @param self self reference
   * @param obj check whether an object
   * @return true if object is frozen, false otherwise
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static boolean isFrozen(Object self, Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.isFrozen();
    } else if (obj instanceof ScriptObjectMirror som) {
      return som.isFrozen();
    } else {
      throw notAnObject(obj);
    }
  }

  /**
   * ECMA 15.2.3.13 Object.isExtensible ( O )
   *
   * @param self self reference
   * @param obj check whether an object is extensible
   * @return true if object is extensible, false otherwise
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static boolean isExtensible(Object self, Object obj) {
    if (obj instanceof ScriptObject so) {
      return so.isExtensible();
    } else if (obj instanceof ScriptObjectMirror som) {
      return som.isExtensible();
    } else {
      throw notAnObject(obj);
    }
  }

  /**
   * ECMA 15.2.3.14 Object.keys ( O )
   * @param self self reference
   * @param obj  object from which to extract keys
   * @return array of keys in object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static ScriptObject keys(Object self, Object obj) {
    if (obj instanceof ScriptObject sobj) {
      return new NativeArray(sobj.getOwnKeys(false));
    } else if (obj instanceof ScriptObjectMirror sobjMirror) {
      return new NativeArray(sobjMirror.getOwnKeys(false));
    } else {
      throw notAnObject(obj);
    }
  }

  /**
   * ECMA 15.2.2.1 , 15.2.1.1 new Object([value]) and Object([value])
   * Constructor
   * @param newObj is the new object instantiated with the new operator
   * @param self   self reference
   * @param value  value of object to be instantiated
   * @return the new NativeObject
   */
  @Constructor
  public static Object construct(boolean newObj, Object self, Object value) {
    var type = JSType.ofNoFunction(value);
    // Object(null), Object(undefined), Object() are same as "new Object()"
    if (newObj || type == JSType.NULL || type == JSType.UNDEFINED) {
      return switch (type) {
        case BOOLEAN, NUMBER, STRING, SYMBOL -> Global.toObject(value);
        case OBJECT -> value;
        // case NULL, UNDEFINED:
        default -> Global.newEmptyInstance();
      };
    }
    return Global.toObject(value);
  }

  /**
   * ECMA 15.2.4.2 Object.prototype.toString ( )
   * @param self self reference
   * @return ToString of object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static String toString(Object self) {
    return ScriptRuntime.builtinObjectToString(self);
  }

  /**
   * ECMA 15.2.4.3 Object.prototype.toLocaleString ( )
   * @param self self reference
   * @return localized ToString
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object toLocaleString(Object self) {
    var obj = JSType.toScriptObject(self);
    if (obj instanceof ScriptObject sobj) {
      var toStringInvoker = getTO_STRING();
      try {
        var toString = toStringInvoker.getGetter().invokeExact(sobj);
        if (Bootstrap.isCallable(toString)) {
          return toStringInvoker.getInvoker().invokeExact(toString, sobj);
        }
      } catch (RuntimeException | Error e) {
        throw e;
      } catch (Throwable t) {
        throw new RuntimeException(t);
      }
      throw typeError("not.a.function", "toString");
    }
    return ScriptRuntime.builtinObjectToString(self);
  }

  /**
   * ECMA 15.2.4.4 Object.prototype.valueOf ( )
   * @param self self reference
   * @return value of object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static Object valueOf(Object self) {
    return Global.toObject(self);
  }

  /**
   * ECMA 15.2.4.5 Object.prototype.hasOwnProperty (V)
   * @param self self reference
   * @param v property to check for
   * @return true if property exists in object
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean hasOwnProperty(Object self, Object v) {
    // Convert ScriptObjects to primitive with String.class hint but no need to convert other primitives to string.
    var key = JSType.toPrimitive(v, String.class);
    var obj = Global.toObject(self);
    return obj instanceof ScriptObject so && so.hasOwnProperty(key);
  }

  /**
   * ECMA 15.2.4.6 Object.prototype.isPrototypeOf (V)
   * @param self self reference
   * @param v v prototype object to check against
   * @return true if object is prototype of v
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean isPrototypeOf(Object self, Object v) {
    if (v instanceof ScriptObject proto) {
      var obj = Global.toObject(self);
      do {
        proto = proto.getProto();
        if (proto == obj) {
          return true;
        }
      } while (proto != null);
    }
    return false;
  }

  /**
   * ECMA 15.2.4.7 Object.prototype.propertyIsEnumerable (V)
   * @param self self reference
   * @param v property to check if enumerable
   * @return true if property is enumerable
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE)
  public static boolean propertyIsEnumerable(Object self, Object v) {
    var str = JSType.toString(v);
    var obj = Global.toObject(self);
    if (obj instanceof ScriptObject sobj) {
      var property = sobj.getProperty(str);
      return (property != null) ? property.isEnumerable() : (sobj.getArray().has(ArrayIndex.getArrayIndex(v)));
    }
    return false;
  }

  /**
   * Nashorn extension: Object.bindProperties
   * <p>
   * Binds the source object's properties to the target object.
   * Binding properties allows two-way read/write for the properties of the source object.
   * <p>
   * Example:
   * <pre>
   * var obj = { x: 34, y: 100 };
   * var foo = {}
   *
   * // bind properties of "obj" to "foo" object
   * Object.bindProperties(foo, obj);
   *
   * // now, we can access/write on 'foo' properties
   * print(foo.x); // prints obj.x which is 34
   *
   * // update obj.x via foo.x
   * foo.x = "hello";
   * print(obj.x); // prints "hello" now
   *
   * obj.x = 42;   // foo.x also becomes 42
   * print(foo.x); // prints 42
   * </pre>
   * <p>
   * The source object bound can be a ScriptObject or a ScriptOjectMirror.
   * null or undefined source object results in TypeError being thrown.
   * <p>
   * Example:
   * <pre>
   * var obj = loadWithNewGlobal({
   *    name: "test",
   *    script: "obj = { x: 33, y: 'hello' }"
   * });
   *
   * // bind 'obj's properties to global scope 'this'
   * Object.bindProperties(this, obj);
   * print(x);         // prints 33
   * print(y);         // prints "hello"
   * x = Math.PI;      // changes obj.x to Math.PI
   * print(obj.x);     // prints Math.PI
   * </pre>
   * <p>
   * Limitations of property binding:
   * <ul>
   * <li> Only enumerable, immediate (not proto inherited) properties of the source object are bound.
   * <li> If the target object already contains a property called "foo", the source's "foo" is skipped (not bound).
   * <li> Properties added to the source object after binding to the target are not bound.
   * <li> Property configuration changes on the source object (or on the target) is not propagated.
   * <li> Delete of property on the target (or the source) is not propagated - only the property value is set to 'undefined' if the property happens to be a data property.
   * </ul>
   * <p>
   * It is recommended that the bound properties be treated as non-configurable properties to avoid surprises.
   * <p>
   * @param self self reference
   * @param target the target object to which the source object's properties are bound
   * @param source the source object whose properties are bound to the target
   * @return the target object after property binding
   */
  @Function(attributes = Attribute.NOT_ENUMERABLE, where = Where.CONSTRUCTOR)
  public static Object bindProperties(Object self, Object target, Object source) {
    // target object has to be a ScriptObject
    var targetObj = Global.checkObject(target);
    // check null or undefined source object
    Global.checkObjectCoercible(source);
    if (source instanceof ScriptObject sourceObj) {
      var sourceMap = sourceObj.getMap();
      var properties = sourceMap.getProperties();
      // replace the map and blow up everything to objects to work with dual fields :-(
      // filter non-enumerable properties
      var propList = new ArrayList<Property>();
      for (var prop : properties) {
        if (prop.isEnumerable()) {
          var value = sourceObj.get(prop.getKey());
          prop.setType(Object.class);
          prop.setValue(sourceObj, sourceObj, value);
          propList.add(prop);
        }
      }
      if (!propList.isEmpty()) {
        targetObj.addBoundProperties(sourceObj, propList.toArray(new Property[0]));
      }
    } else if (source instanceof ScriptObjectMirror mirror) {
      // get enumerable, immediate properties of mirror
      var keys = mirror.getOwnKeys(false);
      if (keys.length == 0) {
        // nothing to bind
        return target;
      }
      // make accessor properties using dynamic invoker getters and setters
      var props = new AccessorProperty[keys.length];
      for (var idx = 0; idx < keys.length; idx++) {
        props[idx] = createAccessorProperty(keys[idx]);
      }
      targetObj.addBoundProperties(source, props);
    } else if (source instanceof StaticClass sc) {
      var type = sc.getRepresentedClass();
      Bootstrap.checkReflectionAccess(type, true);
      bindBeanProperties(targetObj, source, BeansLinker.getReadableStaticPropertyNames(type), BeansLinker.getWritableStaticPropertyNames(type), BeansLinker.getStaticMethodNames(type));
    } else {
      assert source != null;
      var type = source.getClass();
      Bootstrap.checkReflectionAccess(type, false);
      bindBeanProperties(targetObj, source, BeansLinker.getReadableInstancePropertyNames(type), BeansLinker.getWritableInstancePropertyNames(type), BeansLinker.getInstanceMethodNames(type));
    }
    return target;
  }

  static AccessorProperty createAccessorProperty(String name) {
    var getter = Bootstrap.createDynamicInvoker(name, NashornCallSiteDescriptor.GET_METHOD_PROPERTY, MIRROR_GETTER_TYPE);
    var setter = Bootstrap.createDynamicInvoker(name, NashornCallSiteDescriptor.SET_PROPERTY, MIRROR_SETTER_TYPE);
    return AccessorProperty.create(name, 0, getter, setter);
  }

  /**
   * Binds the source mirror object's properties to the target object.
   * Binding properties allows two-way read/write for the properties of the source object.
   * All inherited, enumerable properties are also bound.
   * This method is used to to make 'with' statement work with ScriptObjectMirror as scope object.
   * @param target the target object to which the source object's properties are bound
   * @param source the source object whose properties are bound to the target
   * @return the target object after property binding
   */
  public static Object bindAllProperties(ScriptObject target, ScriptObjectMirror source) {
    var keys = source.keySet();
    // make accessor properties using dynamic invoker getters and setters
    var props = new AccessorProperty[keys.size()];
    var idx = 0;
    for (var name : keys) {
      props[idx] = createAccessorProperty(name);
      idx++;
    }
    target.addBoundProperties(source, props);
    return target;
  }

  static void bindBeanProperties(ScriptObject targetObj, Object source, Collection<String> readablePropertyNames, Collection<String> writablePropertyNames, Collection<String> methodNames) {
    var propertyNames = new HashSet<String>(readablePropertyNames);
    propertyNames.addAll(writablePropertyNames);
    var type = source.getClass();
    var getterType = MethodType.methodType(Object.class, type);
    var setterType = MethodType.methodType(Object.class, type, Object.class);
    var linker = Bootstrap.getBeanLinkerForClass(type);
    var properties = new ArrayList<AccessorProperty>(propertyNames.size() + methodNames.size());
    for (var methodName : methodNames) {
      MethodHandle method;
      try {
        method = getBeanOperation(linker, GET_METHOD, methodName, getterType, source);
      } catch (IllegalAccessError e) {
        // Presumably, this was a caller sensitive method. Ignore it and carry on.
        continue;
      }
      properties.add(AccessorProperty.create(methodName, Property.NOT_WRITABLE, getBoundBeanMethodGetter(source, method), Lookup.EMPTY_SETTER));
    }
    for (var propertyName : propertyNames) {
      MethodHandle getter;
      if (readablePropertyNames.contains(propertyName)) {
        try {
          getter = getBeanOperation(linker, GET_PROPERTY, propertyName, getterType, source);
        } catch (IllegalAccessError e) {
          // Presumably, this was a caller sensitive method. Ignore it and carry on.
          getter = Lookup.EMPTY_GETTER;
        }
      } else {
        getter = Lookup.EMPTY_GETTER;
      }
      var isWritable = writablePropertyNames.contains(propertyName);
      MethodHandle setter;
      if (isWritable) {
        try {
          setter = getBeanOperation(linker, SET_PROPERTY, propertyName, setterType, source);
        } catch (IllegalAccessError e) {
          // Presumably, this was a caller sensitive method. Ignore it and carry on.
          setter = Lookup.EMPTY_SETTER;
        }
      } else {
        setter = Lookup.EMPTY_SETTER;
      }
      if (getter != Lookup.EMPTY_GETTER || setter != Lookup.EMPTY_SETTER) {
        properties.add(AccessorProperty.create(propertyName, isWritable ? 0 : Property.NOT_WRITABLE, getter, setter));
      }
    }
    targetObj.addBoundProperties(source, properties.toArray(new AccessorProperty[0]));
  }

  static MethodHandle getBoundBeanMethodGetter(Object source, MethodHandle methodGetter) {
    try {
      // NOTE: we're relying on the fact that StandardOperation.GET_METHOD return value is constant for any given method name and object linked with BeansLinker.
      // (Actually, an even stronger assumption is true: return value is constant for any given method name and object's class.)
      return MethodHandles.dropArguments(
        MethodHandles.constant(Object.class, Bootstrap.bindCallable(methodGetter.invoke(source), source, null)), 0, Object.class);
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
  }

  static MethodHandle getBeanOperation(GuardingDynamicLinker linker, Operation operation, String name, MethodType methodType, Object source) {
    GuardedInvocation inv;
    try {
      inv = NashornBeansLinker.getGuardedInvocation(linker, createLinkRequest(operation.named(name), methodType, source), Bootstrap.getLinkerServices());
      assert passesGuard(source, inv.getGuard());
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable t) {
      throw new RuntimeException(t);
    }
    assert inv.getSwitchPoints() == null; // Linkers in Dynalink's beans package don't use switchpoints.
    // We discard the guard, as all method handles will be bound to a specific object.
    return inv.getInvocation();
  }

  static boolean passesGuard(Object obj, MethodHandle guard) throws Throwable {
    return guard == null || (boolean) guard.invoke(obj);
  }

  static LinkRequest createLinkRequest(Operation operation, MethodType methodType, Object source) {
    return new SimpleLinkRequest(new CallSiteDescriptor(MethodHandles.publicLookup(), operation, methodType), false, source);
  }

  static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), NativeObject.class, name, MH.type(rtype, types));
  }

}
