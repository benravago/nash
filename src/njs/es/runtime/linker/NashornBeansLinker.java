package es.runtime.linker;

import java.util.function.Supplier;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.NamedOperation;
import jdk.dynalink.Operation;
import jdk.dynalink.SecureLookupSupplier;
import jdk.dynalink.StandardNamespace;
import jdk.dynalink.StandardOperation;
import jdk.dynalink.beans.BeansLinker;
import jdk.dynalink.linker.ConversionComparator.Comparison;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.GuardingDynamicLinker;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.LinkerServices;
import jdk.dynalink.linker.MethodHandleTransformer;
import jdk.dynalink.linker.support.DefaultInternalObjectFilter;
import jdk.dynalink.linker.support.Lookup;
import jdk.dynalink.linker.support.SimpleLinkRequest;

import nash.scripting.ScriptUtils;

import es.runtime.ConsString;
import es.runtime.Context;
import es.runtime.ScriptObject;
import es.runtime.options.Option;
import static es.lookup.Lookup.MH;

/**
 * This linker delegates to a {@code BeansLinker} but passes it a special linker services object that has a modified {@code compareConversion} method that favors conversion of {@link ConsString} to either {@link String} or {@link CharSequence}.
 * It also provides a {@link #createHiddenObjectFilter()} method for use with bootstrap that will ensure that we never pass internal engine objects that should not be externally observable (currently ConsString and ScriptObject) to Java APIs, but rather that we flatten it into a String.
 * We can't just add this functionality as custom converters via {@code GuaardingTypeConverterFactory}, since they are not consulted when the target method handle parameter signature is {@code Object}.
 * This linker also makes sure that primitive {@link String} operations can be invoked on a {@link ConsString}, and allows invocation of objects implementing the {@link FunctionalInterface} attribute.
 */
public class NashornBeansLinker implements GuardingDynamicLinker {

  // System property to control whether to wrap ScriptObject->ScriptObjectMirror for Object type arguments of Java method calls, field set and array set.
  private static final boolean MIRROR_ALWAYS = Option.get("mirror.always", true);

  private static final Operation GET_METHOD = StandardOperation.GET.withNamespace(StandardNamespace.METHOD);
  private static final MethodType GET_METHOD_TYPE = MethodType.methodType(Object.class, Object.class);

  private static final MethodHandle EXPORT_ARGUMENT;
  private static final MethodHandle IMPORT_RESULT;
  private static final MethodHandle FILTER_CONSSTRING;

  static /*<init>*/ {
    var lookup = new Lookup(MethodHandles.lookup());
    EXPORT_ARGUMENT = lookup.findOwnStatic("exportArgument", Object.class, Object.class);
    IMPORT_RESULT = lookup.findOwnStatic("importResult", Object.class, Object.class);
    FILTER_CONSSTRING = lookup.findOwnStatic("consStringFilter", Object.class, Object.class);
  }

  // cache of @FunctionalInterface method of implementor classes
  private static final ClassValue<String> FUNCTIONAL_IFACE_METHOD_NAME = new ClassValue<>() {
    @Override protected String computeValue(Class<?> type) { return findFunctionalInterfaceMethodName(type); }
  };

  private final BeansLinker beansLinker;

  NashornBeansLinker(BeansLinker beansLinker) {
    this.beansLinker = beansLinker;
  }

  @Override
  public GuardedInvocation getGuardedInvocation(LinkRequest linkRequest, LinkerServices linkerServices) throws Exception {
    var self = linkRequest.getReceiver();
    var desc = linkRequest.getCallSiteDescriptor();
    if (self instanceof ConsString) {
      // In order to treat ConsString like a java.lang.String we need a link request with a string receiver.
      var arguments = linkRequest.getArguments();
      arguments[0] = "";
      var forgedLinkRequest = linkRequest.replaceArguments(desc, arguments);
      var invocation = getGuardedInvocation(beansLinker, forgedLinkRequest, linkerServices);
      // If an invocation is found we add a filter that makes it work for both Strings and ConsStrings.
      return invocation == null ? null : invocation.filterArguments(0, FILTER_CONSSTRING);
    }

    if (self != null && NamedOperation.getBaseOperation(desc.getOperation()) == StandardOperation.CALL) {
      // Support CALL on any object that supports some @FunctionalInterface annotated interface.
      // This way Java method, constructor references or implementations of java.util.function.* interfaces can be called as though those are script functions.
      var name = getFunctionalInterfaceMethodName(self.getClass());
      if (name != null) {
        // Obtain the method
        var getMethodDesc = new CallSiteDescriptor(NashornCallSiteDescriptor.getLookupInternal(desc), GET_METHOD.named(name), GET_METHOD_TYPE);
        var getMethodInv = linkerServices.getGuardedInvocation(new SimpleLinkRequest(getMethodDesc, false, self));
        Object method;
        try {
          method = getMethodInv.getInvocation().invokeExact(self);
        } catch (Exception | Error e) {
          throw e;
        } catch (Throwable t) {
          throw new RuntimeException(t);
        }
        var args = linkRequest.getArguments();
        args[1] = args[0]; // callee (the functional object) becomes this
        args[0] = method; // the method becomes the callee
        var callType = desc.getMethodType();
        var newDesc = desc.changeMethodType(desc.getMethodType().changeParameterType(0, Object.class).changeParameterType(1, callType.parameterType(0)));
        var gi = getGuardedInvocation(beansLinker, linkRequest.replaceArguments(newDesc, args), new NashornBeansLinkerServices(linkerServices));
        // Bind to the method, drop the original "this" and use original "callee" as this:
        var inv = gi.getInvocation() // (method, this, args...)
                    .bindTo(method);  // (this, args...)
        var calleeToThis = MH.dropArguments(inv, 1, callType.parameterType(1)); // (callee->this, <drop>, args...)
        return gi.replaceMethods(calleeToThis, gi.getGuard());
      }
    }
    return getGuardedInvocation(beansLinker, linkRequest, linkerServices);
  }

  /**
   * Delegates to the specified linker but injects its linker services wrapper so that it will apply all special conversions that this class does.
   * @param delegateLinker the linker to which the actual work is delegated to.
   * @param linkRequest the delegated link request
   * @param linkerServices the original link services that will be augmented with special conversions
   * @return the guarded invocation from the delegate, possibly augmented with special conversions
   * @throws Exception if the delegate throws an exception
   */
  public static GuardedInvocation getGuardedInvocation(GuardingDynamicLinker delegateLinker, LinkRequest linkRequest, LinkerServices linkerServices) throws Exception {
    return delegateLinker.getGuardedInvocation(linkRequest, new NashornBeansLinkerServices(linkerServices));
  }

  @SuppressWarnings("unused")
  static Object exportArgument(Object arg) {
    return exportArgument(arg, MIRROR_ALWAYS);
  }

  static Object exportArgument(Object arg, boolean mirrorAlways) {
    return (arg instanceof ConsString) ? arg.toString()
         : (mirrorAlways && arg instanceof ScriptObject) ? ScriptUtils.wrap(arg)
         : arg;
  }

  @SuppressWarnings("unused")
  static Object importResult(Object arg) {
    return ScriptUtils.unwrap(arg);
  }

  @SuppressWarnings("unused")
  static Object consStringFilter(Object arg) {
    return arg instanceof ConsString ? arg.toString() : arg;
  }

  static String findFunctionalInterfaceMethodName(Class<?> type) {
    if (type == null) {
      return null;
    }
    for (var iface : type.getInterfaces()) {
      // check accessibility up-front
      if (!Context.isAccessibleClass(iface)) {
        continue;
      }
      // check for @FunctionalInterface
      if (iface.isAnnotationPresent(FunctionalInterface.class)) {
        // return the first abstract method
        for (var m : iface.getMethods()) {
          if (Modifier.isAbstract(m.getModifiers()) && !isOverridableObjectMethod(m)) {
            return m.getName();
          }
        }
      }
    }
    // did not find here, try super class
    return findFunctionalInterfaceMethodName(type.getSuperclass());
  }

  // is this an overridable java.lang.Object method?
  static boolean isOverridableObjectMethod(Method m) {
    switch (m.getName()) {
      case "equals" -> {
        if (m.getReturnType() == boolean.class) {
          var params = m.getParameterTypes();
          return params.length == 1 && params[0] == Object.class;
        }
        return false;
      }
      case "hashCode" -> {
        return m.getReturnType() == int.class && m.getParameterCount() == 0;
      }
      case "toString" -> {
        return m.getReturnType() == String.class && m.getParameterCount() == 0;
      }
    }
    return false;
  }

  // Returns @FunctionalInterface annotated interface's single abstract method name.
  // If not found, returns null.
  static String getFunctionalInterfaceMethodName(Class<?> type) {
    return FUNCTIONAL_IFACE_METHOD_NAME.get(type);
  }

  static MethodHandleTransformer createHiddenObjectFilter() {
    return new DefaultInternalObjectFilter(EXPORT_ARGUMENT, MIRROR_ALWAYS ? IMPORT_RESULT : null);
  }

  static class NashornBeansLinkerServices implements LinkerServices {

    private final LinkerServices linkerServices;

    NashornBeansLinkerServices(LinkerServices linkerServices) {
      this.linkerServices = linkerServices;
    }

    @Override
    public MethodHandle asType(MethodHandle handle, MethodType fromType) {
      return linkerServices.asType(handle, fromType);
    }
    @Override
    public MethodHandle getTypeConverter(Class<?> sourceType, Class<?> targetType) {
      return linkerServices.getTypeConverter(sourceType, targetType);
    }
    @Override
    public boolean canConvert(Class<?> from, Class<?> to) {
      return linkerServices.canConvert(from, to);
    }
    @Override
    public GuardedInvocation getGuardedInvocation(LinkRequest linkRequest) throws Exception {
      return linkerServices.getGuardedInvocation(linkRequest);
    }
    @Override
    public MethodHandle filterInternalObjects(MethodHandle target) {
      return linkerServices.filterInternalObjects(target);
    }
    @Override
    public <T> T getWithLookup(Supplier<T> operation, SecureLookupSupplier lookupSupplier) {
      return linkerServices.getWithLookup(operation, lookupSupplier);
    }
    @Override
    public Comparison compareConversion(Class<?> sourceType, Class<?> targetType1, Class<?> targetType2) {
      if (sourceType == ConsString.class) {
        if (String.class == targetType1 || CharSequence.class == targetType1) {
          return Comparison.TYPE_1_BETTER;
        }
        if (String.class == targetType2 || CharSequence.class == targetType2) {
          return Comparison.TYPE_2_BETTER;
        }
      }
      return linkerServices.compareConversion(sourceType, targetType1, targetType2);
    }
  }

}
