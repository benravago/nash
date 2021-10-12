package es.objects;

import jdk.dynalink.beans.StaticClass;
import es.objects.annotations.Constructor;
import es.objects.annotations.ScriptClass;
import es.runtime.Context;
import es.runtime.FindProperty;
import es.runtime.NativeJavaPackage;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;

/**
 * This is "JavaImporter" constructor. This constructor allows you to use Java types omitting explicit package names.
 * Objects of this constructor are used along with {@code "with"} statements.
 * Example:
 * <pre>
 *     var imports = new JavaImporter(java.util, java.io);
 *     with (imports) {
 *         var m = new HashMap(); // java.util.HashMap
 *         var f = new File("."); // java.io.File
 *         ...
 *     }
 * </pre>
 * Note however that the preferred way for accessing Java types in Nashorn is through the use of
 * {@link NativeJava#type(Object, Object) Java.type()} method.
 */
@ScriptClass("JavaImporter")
public final class NativeJavaImporter extends ScriptObject {

  private final Object[] args;

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  private NativeJavaImporter(final Object[] args, final ScriptObject proto, final PropertyMap map) {
    super(proto, map);
    this.args = args;
  }

  private NativeJavaImporter(final Object[] args, final Global global) {
    this(args, global.getJavaImporterPrototype(), $nasgenmap$);
  }

  private NativeJavaImporter(final Object[] args) {
    this(args, Global.instance());
  }

  @Override
  public String getClassName() {
    return "JavaImporter";
  }

  /**
   * Constructor
   * @param isNew is the new operator used for instantiating this NativeJavaImporter
   * @param self self reference
   * @param args arguments
   * @return NativeJavaImporter instance
   */
  @Constructor(arity = 1)
  public static NativeJavaImporter constructor(final boolean isNew, final Object self, final Object... args) {
    return new NativeJavaImporter(args);
  }

  @Override
  protected FindProperty findProperty(final Object key, final boolean deep, final boolean isScope, final ScriptObject start) {
    final FindProperty find = super.findProperty(key, deep, isScope, start);
    if (find == null && key instanceof String) {
      final String name = (String) key;
      final Object value = createProperty(name);
      if (value != null) {
        // We must avoid calling findProperty recursively, so we pass null as first argument
        setObject(null, 0, key, value);
        return super.findProperty(key, deep, isScope, start);
      }
    }
    return find;
  }

  private Object createProperty(final String name) {
    final int len = args.length;

    for (int i = len - 1; i > -1; i--) {
      final Object obj = args[i];

      if (obj instanceof StaticClass) {
        if (((StaticClass) obj).getRepresentedClass().getSimpleName().equals(name)) {
          return obj;
        }
      } else if (obj instanceof NativeJavaPackage) {
        final String pkgName = ((NativeJavaPackage) obj).getName();
        final String fullName = pkgName.isEmpty() ? name : (pkgName + "." + name);
        final Context context = Global.instance().getContext();
        try {
          return StaticClass.forClass(context.findClass(fullName));
        } catch (final ClassNotFoundException e) {
          // IGNORE
        }
      }
    }
    return null;
  }
}
