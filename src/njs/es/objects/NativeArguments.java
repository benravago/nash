package es.objects;

import static es.lookup.Lookup.MH;
import static es.runtime.ScriptRuntime.UNDEFINED;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.util.ArrayList;
import java.util.Arrays;
import es.runtime.AccessorProperty;
import es.runtime.Property;
import es.runtime.PropertyMap;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.arrays.ArrayData;

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
    final ArrayList<Property> properties = new ArrayList<>(1);
    properties.add(AccessorProperty.create("length", Property.NOT_ENUMERABLE, G$LENGTH, S$LENGTH));
    PropertyMap map = PropertyMap.newMap(properties);
    // The caller and callee properties should throw TypeError
    // Need to add properties directly to map since slots are assigned speculatively by newUserAccessors.
    final int flags = Property.NOT_ENUMERABLE | Property.NOT_CONFIGURABLE;
    map = map.addPropertyNoHistory(map.newUserAccessors("caller", flags));
    map = map.addPropertyNoHistory(map.newUserAccessors("callee", flags));
    map$ = map;
  }

  static PropertyMap getInitialMap() {
    return map$;
  }

  private Object length;
  private final Object[] namedArgs;

  NativeArguments(final Object[] values, final int numParams, final ScriptObject proto) { // , final PropertyMap map) {
    super(proto, getInitialMap());
    setIsArguments();

    final ScriptFunction func = Global.instance().getTypeErrorThrower();
    // We have to fill user accessor functions late as these are stored
    // in this object rather than in the PropertyMap of this object.
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
  public Object getArgument(final int key) {
    return (key >= 0 && key < namedArgs.length) ? namedArgs[key] : UNDEFINED;
  }

  /**
   * setArgument is used for named argument set.
   */
  @Override
  public void setArgument(final int key, final Object value) {
    if (key >= 0 && key < namedArgs.length) {
      namedArgs[key] = value;
    }
  }

  /**
   * Length getter
   * @param self self reference
   * @return length property value
   */
  public static Object G$length(final Object self) {
    if (self instanceof NativeArguments) {
      return ((NativeArguments) self).getArgumentsLength();
    }
    return 0;
  }

  /**
   * Length setter
   * @param self self reference
   * @param value value for length property
   */
  public static void S$length(final Object self, final Object value) {
    if (self instanceof NativeArguments) {
      ((NativeArguments) self).setArgumentsLength(value);
    }
  }

  private Object getArgumentsLength() {
    return length;
  }

  private void setArgumentsLength(final Object length) {
    this.length = length;
  }

  private static MethodHandle findOwnMH(final String name, final Class<?> rtype, final Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), NativeArguments.class, name, MH.type(rtype, types));
  }
}
