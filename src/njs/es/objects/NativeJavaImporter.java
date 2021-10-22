package es.objects;

import jdk.dynalink.beans.StaticClass;
import es.objects.annotations.Constructor;
import es.objects.annotations.ScriptClass;
import es.runtime.FindProperty;
import es.runtime.NativeJavaPackage;
import es.runtime.PropertyMap;
import es.runtime.ScriptObject;

/**
 * This is "JavaImporter" constructor.
 *
 * This constructor allows you to use Java types omitting explicit package names.
 * Objects of this constructor are used along with {@code "with"} statements.
 *
 * Example:
 * <pre>
 *     var imports = new JavaImporter(java.util, java.io);
 *     with (imports) {
 *         var m = new HashMap(); // java.util.HashMap
 *         var f = new File("."); // java.io.File
 *         ...
 *     }
 * </pre>
 * Note however that the preferred way for accessing Java types in Nashorn is through the use of {@link NativeJava#type(Object, Object) Java.type()} method.
 */
@ScriptClass("JavaImporter")
public final class NativeJavaImporter extends ScriptObject {

  private final Object[] args;

  // initialized by nasgen
  private static PropertyMap $nasgenmap$;

  NativeJavaImporter(Object[] args, ScriptObject proto, PropertyMap map) {
    super(proto, map);
    this.args = args;
  }

  NativeJavaImporter(Object[] args, Global global) {
    this(args, global.getJavaImporterPrototype(), $nasgenmap$);
  }

  NativeJavaImporter(Object[] args) {
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
  public static NativeJavaImporter constructor(boolean isNew, Object self, Object... args) {
    return new NativeJavaImporter(args);
  }

  @Override
  protected FindProperty findProperty(Object key, boolean deep, boolean isScope, ScriptObject start) {
    var find = super.findProperty(key, deep, isScope, start);
    if (find == null && key instanceof String name) {
      var value = createProperty(name);
      if (value != null) {
        // We must avoid calling findProperty recursively, so we pass null as first argument
        setObject(null, 0, key, value);
        return super.findProperty(key, deep, isScope, start);
      }
    }
    return find;
  }

  Object createProperty(String name) {
    var len = args.length;
    for (var i = len - 1; i > -1; i--) {
      var obj = args[i];
      if (obj instanceof StaticClass cl) {
        if (cl.getRepresentedClass().getSimpleName().equals(name)) {
          return obj;
        }
      } else if (obj instanceof NativeJavaPackage pkg) {
        var pkgName = pkg.getName();
        var fullName = pkgName.isEmpty() ? name : (pkgName + "." + name);
        var context = Global.instance().getContext();
        try {
          return StaticClass.forClass(context.findClass(fullName));
        } catch (ClassNotFoundException ignore) {}
      }
    }
    return null;
  }

}
