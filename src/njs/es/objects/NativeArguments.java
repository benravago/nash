package es.objects;

import java.util.ArrayList;
import java.util.Arrays;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import es.runtime.AccessorProperty;
import es.runtime.Property;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;
import es.runtime.arrays.ArrayData;
import static es.lookup.Lookup.MH;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * ECMA 10.6 Arguments Object.
 *
 * Arguments object for functions.
 */
public final class NativeArguments extends ScriptObject {

  private static final MethodHandle G$LENGTH = findOwnMH("G$length", Object.class, Object.class);
  private static final MethodHandle S$LENGTH = findOwnMH("S$length", void.class, Object.class, Object.class);

  // property map for arguments object
  private static final PropertyMap map$;

  static {
    var properties = new ArrayList<Property>(1);
    properties.add(AccessorProperty.create("length", Property.NOT_ENUMERABLE, G$LENGTH, S$LENGTH));
    var map = PropertyMap.newMap(properties);
    // The caller and callee properties should throw TypeError
    // Need to add properties directly to map since slots are assigned speculatively by newUserAccessors.
    var flags = Property.NOT_ENUMERABLE | Property.NOT_CONFIGURABLE;
    map = map.addPropertyNoHistory(map.newUserAccessors("caller", flags));
    map = map.addPropertyNoHistory(map.newUserAccessors("callee", flags));
    map$ = map;
  }

  static PropertyMap getInitialMap() {
    return map$;
  }

  private Object length;
  private final Object[] namedArgs;

  NativeArguments(Object[] values, int numParams, ScriptObject proto) { // , PropertyMap map) {
    super(proto, getInitialMap());
    setIsArguments();

    var func = Global.instance().getTypeErrorThrower();
    // We have to fill user accessor functions late as these are stored in this object rather than in the PropertyMap of this object.
    initUserAccessors("caller", func, func);
    initUserAccessors("callee", func, func);

    setArray(ArrayData.allocate(values));
    this.length = values.length;

    // extend/truncate named arg array as needed and copy values
    this.namedArgs = new Object[numParams];
    if (numParams > values.length) {
      Arrays.fill(namedArgs, UNDEFINED);
    }
    System.arraycopy(values, 0, namedArgs, 0, Math.min(namedArgs.length, values.length));
  }

  @Override
  public String getClassName() {
    return "Arguments";
  }

  /**
   * getArgument is used for named argument access.
   */
  @Override
  public Object getArgument(int key) {
    return (key >= 0 && key < namedArgs.length) ? namedArgs[key] : UNDEFINED;
  }

  /**
   * setArgument is used for named argument set.
   */
  @Override
  public void setArgument(int key, Object value) {
    if (key >= 0 && key < namedArgs.length) {
      namedArgs[key] = value;
    }
  }

  /**
   * Length getter
   * @param self self reference
   * @return length property value
   */
  public static Object G$length(Object self) {
    return (self instanceof NativeArguments na) ? na.getArgumentsLength() : 0;
  }

  /**
   * Length setter
   * @param self self reference
   * @param value value for length property
   */
  public static void S$length(Object self, Object value) {
    if (self instanceof NativeArguments na) {
      na.setArgumentsLength(value);
    }
  }

  Object getArgumentsLength() {
    return length;
  }

  void setArgumentsLength(Object length) {
    this.length = length;
  }

  static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), NativeArguments.class, name, MH.type(rtype, types));
  }

}
