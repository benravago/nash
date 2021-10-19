package es.runtime.linker;

import java.util.Set;

import java.security.ProtectionDomain;
import java.security.SecureClassLoader;

import jdk.dynalink.beans.StaticClass;

import es.runtime.Context;
import es.runtime.JSType;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;

/**
 * This class encapsulates the bytecode of the adapter class and can be used to load it into the JVM as an actual Class.
 *
 * It can be invoked repeatedly to create multiple adapter classes from the same bytecode; adapter classes that have class-level overrides must be re-created for every set of such overrides.
 * Note that while this class is named "class loader", it does not, in fact, extend {@code ClassLoader}, but rather uses them internally.
 * Instances of this class are normally created by {@code JavaAdapterBytecodeGenerator}.
 */
final class JavaAdapterClassLoader {

  private static final Module NASHORN_MODULE = Context.class.getModule();

  private static final Set<String> VISIBLE_INTERNAL_CLASS_NAMES = Set.of(
    JavaAdapterServices.class.getName(),
    ScriptObject.class.getName(),
    ScriptFunction.class.getName(),
    JSType.class.getName()
  );

  private final String className;
  private final byte[] classBytes;

  JavaAdapterClassLoader(String className, byte[] classBytes) {
    this.className = className.replace('/', '.');
    this.classBytes = classBytes;
  }

  /**
   * Loads the generated adapter class into the JVM.
   * @param parentLoader the parent class loader for the generated class loader
   * @param protectionDomain the protection domain for the generated class
   * @return the generated adapter class
   */
  StaticClass generateClass(ClassLoader parentLoader, ProtectionDomain protectionDomain) {
    assert protectionDomain != null;
    try {
      return StaticClass.forClass(Class.forName(className, true, createClassLoader(parentLoader, protectionDomain)));
    } catch (ClassNotFoundException e) {
      throw new AssertionError(e); // cannot happen
    }
  }

  // Note that the adapter class is created in the protection domain of the class/interface being extended/implemented, and only the privileged global setter action class is generated in the protection domain of Nashorn itself.
  // Also note that the creation and loading of the global setter is deferred until it is required by JVM linker, which will only happen on first invocation of any of the adapted method.
  // We could defer it even more by separating its invocation into a separate static method on the adapter class, but then someone with ability to introspect on the class and use setAccessible(true) on it could invoke the method.
  // It's a security tradeoff...
  ClassLoader createClassLoader(ClassLoader parentLoader, ProtectionDomain protectionDomain) {
    return new SecureClassLoader(parentLoader) {
      private final ClassLoader myLoader = getClass().getClassLoader();

      // the unnamed module into which adapter is loaded!
      private final Module adapterModule = getUnnamedModule();

      /*<init>*/ {
        // specific exports from nashorn to the new adapter module
        NASHORN_MODULE.addExports("es.runtime", adapterModule);
        NASHORN_MODULE.addExports("es.runtime.linker", adapterModule);
        // nashorn should be be able to read methods of classes loaded in adapter module
        NASHORN_MODULE.addReads(adapterModule);
      }

      @Override
      public Class<?> loadClass(String name, boolean resolve) throws ClassNotFoundException {
        try {
          var i = name.lastIndexOf('.');
          if (i != -1) {
            var pkgName = name.substring(0, i);
          }
          return super.loadClass(name, resolve);
        } catch (SecurityException se) {
          // we may be implementing an interface or extending a class that was loaded by a loader that prevents package.access.
          // If so, it'd throw SecurityException for nashorn's classes!.
          // For adapter's to work, we should be able to refer to the few classes it needs in its implementation.
          if (VISIBLE_INTERNAL_CLASS_NAMES.contains(name)) {
            return myLoader != null ? myLoader.loadClass(name) : Class.forName(name, false, myLoader);
          }
          throw se;
        }
      }

      @Override
      protected Class<?> findClass(String name) throws ClassNotFoundException {
        if (name.equals(className)) {
          assert classBytes != null : "what? already cleared .class bytes!!";
          var ctx = Context.getContext();
          return defineClass(name, classBytes, 0, classBytes.length, protectionDomain);
        }
        throw new ClassNotFoundException(name);
      }
    };
  }

}
