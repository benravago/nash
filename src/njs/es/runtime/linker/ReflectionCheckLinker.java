package es.runtime.linker;

import java.lang.reflect.Proxy;

import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.LinkerServices;
import jdk.dynalink.linker.TypeBasedGuardingDynamicLinker;

import es.runtime.Context;
import static es.runtime.ECMAErrors.typeError;

/**
 * Check java reflection permission for java reflective and java.lang.invoke access from scripts
 */
final class ReflectionCheckLinker implements TypeBasedGuardingDynamicLinker {

  private static final Class<?> STATEMENT_CLASS = getBeanClass("Statement");
  private static final Class<?> XMLENCODER_CLASS = getBeanClass("XMLEncoder");
  private static final Class<?> XMLDECODER_CLASS = getBeanClass("XMLDecoder");

  static Class<?> getBeanClass(String name) {
    try {
      return Class.forName("java.beans." + name);
    } catch (ClassNotFoundException cnfe) {
      // Possible to miss this class in other profiles.
      return null;
    }
  }

  @Override
  public boolean canLinkType(Class<?> type) {
    return isReflectionClass(type);
  }

  static boolean isReflectionClass(Class<?> type) {
    // Class or ClassLoader subclasses
    if (type == Class.class || ClassLoader.class.isAssignableFrom(type)) {
      return true;
    }
    // check for bean reflection
    if ((STATEMENT_CLASS != null && STATEMENT_CLASS.isAssignableFrom(type)) || (XMLENCODER_CLASS != null && XMLENCODER_CLASS.isAssignableFrom(type)) || (XMLDECODER_CLASS != null && XMLDECODER_CLASS.isAssignableFrom(type))) {
      return true;
    }
    // package name check
    var name = type.getName();
    return name.startsWith("java.lang.reflect.") || name.startsWith("java.lang.invoke.");
  }

  @Override
  public GuardedInvocation getGuardedInvocation(LinkRequest origRequest, LinkerServices linkerServices) throws Exception {
    checkLinkRequest(origRequest);
    // let the next linker deal with actual linking
    return null;
  }

  static boolean isReflectiveCheckNeeded(Class<?> type, boolean isStatic) {
    // special handling for Proxy subclasses
    if (Proxy.class.isAssignableFrom(type)) {
      if (Proxy.isProxyClass(type)) {
        // real Proxy class - filter only static access
        return isStatic;
      }
      // fake Proxy subclass - filter it always!
      return true;
    }
    // check for any other reflective Class
    return isReflectionClass(type);
  }

  static void checkReflectionAccess(Class<?> clazz, boolean isStatic) {
    var global = Context.getGlobal();
    var cf = global.getClassFilter();
    if (cf != null && isReflectiveCheckNeeded(clazz, isStatic)) {
      throw typeError("no.reflection.with.classfilter");
    }
  }

  static void checkLinkRequest(LinkRequest request) {
    var global = Context.getGlobal();
    var cf = global.getClassFilter();
    if (cf != null) {
      throw typeError("no.reflection.with.classfilter");
    }
  }

}
