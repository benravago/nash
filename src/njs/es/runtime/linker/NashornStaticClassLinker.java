package es.runtime.linker;

import java.lang.reflect.Modifier;

import jdk.dynalink.NamedOperation;
import jdk.dynalink.StandardOperation;
import jdk.dynalink.beans.BeansLinker;
import jdk.dynalink.beans.StaticClass;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.GuardingDynamicLinker;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.LinkerServices;
import jdk.dynalink.linker.TypeBasedGuardingDynamicLinker;
import jdk.dynalink.linker.support.Guards;

import es.runtime.ECMAErrors;

/**
 * Internal linker for {@link StaticClass} objects, only ever used by Nashorn engine and not exposed to other engines.
 *
 * It is used for extending the "new" operator on StaticClass in order to be able to instantiate interfaces and abstract classes by passing a ScriptObject or ScriptFunction as their implementation,
 * e.g.:
 * <pre>
 *   var r = new Runnable() { run: function() { print("Hello World" } }
 * </pre>
 * or for SAM types, even just passing a function:
 * <pre>
 *   var r = new Runnable(function() { print("Hello World" })
 * </pre>
 */
final class NashornStaticClassLinker implements TypeBasedGuardingDynamicLinker {

  private final GuardingDynamicLinker staticClassLinker;

  NashornStaticClassLinker(BeansLinker beansLinker) {
    this.staticClassLinker = beansLinker.getLinkerForClass(StaticClass.class);
  }

  @Override
  public boolean canLinkType(Class<?> type) {
    return type == StaticClass.class;
  }

  @Override
  public GuardedInvocation getGuardedInvocation(LinkRequest request, LinkerServices linkerServices) throws Exception {
    var self = request.getReceiver();
    if (self == null || self.getClass() != StaticClass.class) {
      return null;
    }
    var receiverClass = ((StaticClass) self).getRepresentedClass();
    Bootstrap.checkReflectionAccess(receiverClass, true);
    var desc = request.getCallSiteDescriptor();
    // We intercept "new" on StaticClass instances to provide additional capabilities
    if (NamedOperation.getBaseOperation(desc.getOperation()) == StandardOperation.NEW) {
      if (!Modifier.isPublic(receiverClass.getModifiers())) {
        throw ECMAErrors.typeError("new.on.nonpublic.javatype", receiverClass.getName());
      }
      // Is the class abstract? (This includes interfaces.)
      if (NashornLinker.isAbstractClass(receiverClass)) {
        // Change this link request into a link request on the adapter class.
        var args = request.getArguments();
        var lookup = NashornCallSiteDescriptor.getLookupInternal(request.getCallSiteDescriptor());
        args[0] = JavaAdapterFactory.getAdapterClassFor(new Class<?>[]{receiverClass}, null, lookup);
        var adapterRequest = request.replaceArguments(request.getCallSiteDescriptor(), args);
        var gi = checkNullConstructor(delegate(linkerServices, adapterRequest), receiverClass);
        // Finally, modify the guard to test for the original abstract class.
        return gi.replaceMethods(gi.getInvocation(), Guards.getIdentityGuard(self));
      }
      // If the class was not abstract, just delegate linking to the standard StaticClass linker.
      // Make an additional check to ensure we have a constructor.
      // We could just fall through to the next "return" statement, except we also insert a call to checkNullConstructor() which throws an ECMAScript TypeError with a more intuitive message when no suitable constructor is found.
      return checkNullConstructor(delegate(linkerServices, request), receiverClass);
    }
    // In case this was not a "new" operation, just delegate to the the standard StaticClass linker.
    return delegate(linkerServices, request);
  }

  GuardedInvocation delegate(LinkerServices linkerServices, LinkRequest request) throws Exception {
    return NashornBeansLinker.getGuardedInvocation(staticClassLinker, request, linkerServices);
  }

  static GuardedInvocation checkNullConstructor(GuardedInvocation ctorInvocation, Class<?> receiverClass) {
    if (ctorInvocation == null) {
      throw ECMAErrors.typeError("no.constructor.matches.args", receiverClass.getName());
    }
    return ctorInvocation;
  }

}
