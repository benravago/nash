package es.runtime.linker;

import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.invoke.SwitchPoint;
import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.support.Guards;
import es.runtime.Context;
import es.runtime.FindProperty;
import es.runtime.GlobalConstants;
import es.runtime.JSType;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;

/**
 * Implements lookup of methods to link for dynamic operations on JavaScript primitive values (booleans, strings, and
 * numbers). This class is only public so it can be accessed by classes in the {@code es.objects}
 * package.
 */
public final class PrimitiveLookup {

  /** Method handle to link setters on primitive base. See ES5 8.7.2. */
  private static final MethodHandle PRIMITIVE_SETTER = findOwnMH("primitiveSetter",
          MH.type(void.class, ScriptObject.class, Object.class, Object.class, boolean.class, Object.class));

  private PrimitiveLookup() {
  }

  /**
   * Returns a guarded invocation representing the linkage for a dynamic operation on a primitive Java value.
   * @param request the link request for the dynamic call site.
   * @param receiverClass the class of the receiver value (e.g., {@link java.lang.Boolean}, {@link java.lang.String} etc.)
   * @param wrappedReceiver a transient JavaScript native wrapper object created as the object proxy for the primitive
   * value; see ECMAScript 5.1, section 8.7.1 for discussion of using {@code [[Get]]} on a property reference with a
   * primitive base value. This instance will be used to delegate actual lookup.
   * @param wrapFilter A method handle that takes a primitive value of type specified in the {@code receiverClass} and
   * creates a transient native wrapper of the same type as {@code wrappedReceiver} for subsequent invocations of the
   * method - it will be combined into the returned invocation as an argument filter on the receiver.
   * @return a guarded invocation representing the operation at the call site when performed on a JavaScript primitive
   * @param protoFilter A method handle that walks up the proto chain of this receiver object
   * type {@code receiverClass}.
   */
  public static GuardedInvocation lookupPrimitive(final LinkRequest request, final Class<?> receiverClass,
          final ScriptObject wrappedReceiver, final MethodHandle wrapFilter,
          final MethodHandle protoFilter) {
    return lookupPrimitive(request, Guards.getInstanceOfGuard(receiverClass), wrappedReceiver, wrapFilter, protoFilter);
  }

  /**
   * Returns a guarded invocation representing the linkage for a dynamic operation on a primitive Java value.
   * @param request the link request for the dynamic call site.
   * @param guard an explicit guard that will be used for the returned guarded invocation.
   * @param wrappedReceiver a transient JavaScript native wrapper object created as the object proxy for the primitive
   * value; see ECMAScript 5.1, section 8.7.1 for discussion of using {@code [[Get]]} on a property reference with a
   * primitive base value. This instance will be used to delegate actual lookup.
   * @param wrapFilter A method handle that takes a primitive value of type guarded by the {@code guard} and
   * creates a transient native wrapper of the same type as {@code wrappedReceiver} for subsequent invocations of the
   * method - it will be combined into the returned invocation as an argument filter on the receiver.
   * @param protoFilter A method handle that walks up the proto chain of this receiver object
   * @return a guarded invocation representing the operation at the call site when performed on a JavaScript primitive
   * type (that is implied by both {@code guard} and {@code wrappedReceiver}).
   */
  public static GuardedInvocation lookupPrimitive(final LinkRequest request, final MethodHandle guard,
          final ScriptObject wrappedReceiver, final MethodHandle wrapFilter,
          final MethodHandle protoFilter) {
    final CallSiteDescriptor desc = request.getCallSiteDescriptor();
    final String name = NashornCallSiteDescriptor.getOperand(desc);
    final FindProperty find = name != null ? wrappedReceiver.findProperty(name, true) : null;

    switch (NashornCallSiteDescriptor.getStandardOperation(desc)) {
      case GET:
        //checks whether the property name is hard-coded in the call-site (i.e. a getProp vs a getElem, or setProp vs setElem)
        //if it is we can make assumptions on the property: that if it is not defined on primitive wrapper itself it never will be.
        //so in that case we can skip creation of primitive wrapper and start our search with the prototype.
        if (name != null) {
          if (find == null) {
            // Give up early, give chance to BeanLinker and NashornBottomLinker to deal with it.
            return null;
          }

          final SwitchPoint sp = find.getProperty().getBuiltinSwitchPoint(); //can use this instead of proto filter
          if (sp instanceof Context.BuiltinSwitchPoint && !sp.hasBeenInvalidated()) {
            return new GuardedInvocation(GlobalConstants.staticConstantGetter(find.getObjectValue()), guard, sp, null);
          }

          if (find.isInheritedOrdinaryProperty()) {
            // If property is found in the prototype object bind the method handle directly to
            // the proto filter instead of going through wrapper instantiation below.
            final ScriptObject proto = wrappedReceiver.getProto();
            final GuardedInvocation link = proto.lookup(desc, request);

            if (link != null) {
              final MethodHandle invocation = link.getInvocation(); //this contains the builtin switchpoint
              final MethodHandle adaptedInvocation = MH.asType(invocation, invocation.type().changeParameterType(0, Object.class));
              final MethodHandle method = MH.filterArguments(adaptedInvocation, 0, protoFilter);
              final MethodHandle protoGuard = MH.filterArguments(link.getGuard(), 0, protoFilter);
              return new GuardedInvocation(method, NashornGuards.combineGuards(guard, protoGuard));
            }
          }
        }
        break;
      case SET:
        return getPrimitiveSetter(name, guard, wrapFilter, NashornCallSiteDescriptor.isStrict(desc));
      default:
        break;
    }

    final GuardedInvocation link = wrappedReceiver.lookup(desc, request);
    if (link != null) {
      MethodHandle method = link.getInvocation();
      final Class<?> receiverType = method.type().parameterType(0);
      if (receiverType != Object.class) {
        final MethodType wrapType = wrapFilter.type();
        assert receiverType.isAssignableFrom(wrapType.returnType());
        method = MH.filterArguments(method, 0, MH.asType(wrapFilter, wrapType.changeReturnType(receiverType)));
      }

      return new GuardedInvocation(method, guard, link.getSwitchPoints(), null);
    }

    return null;
  }

  private static GuardedInvocation getPrimitiveSetter(final String name, final MethodHandle guard,
          final MethodHandle wrapFilter, final boolean isStrict) {
    MethodHandle filter = MH.asType(wrapFilter, wrapFilter.type().changeReturnType(ScriptObject.class));
    final MethodHandle target;

    if (name == null) {
      filter = MH.dropArguments(filter, 1, Object.class, Object.class);
      target = MH.insertArguments(PRIMITIVE_SETTER, 3, isStrict);
    } else {
      filter = MH.dropArguments(filter, 1, Object.class);
      target = MH.insertArguments(PRIMITIVE_SETTER, 2, name, isStrict);
    }

    return new GuardedInvocation(MH.foldArguments(target, filter), guard);
  }

  @SuppressWarnings("unused")
  private static void primitiveSetter(final ScriptObject wrappedSelf, final Object self, final Object key,
          final boolean strict, final Object value) {
    // See ES5.1 8.7.2 PutValue (V, W)
    final String name = JSType.toString(key);
    final FindProperty find = wrappedSelf.findProperty(name, true);
    if (find == null || !find.getProperty().isAccessorProperty() || !find.getProperty().hasNativeSetter()) {
      if (strict) {
        if (find == null || !find.getProperty().isAccessorProperty()) {
          throw typeError("property.not.writable", name, ScriptRuntime.safeToString(self));
        } else {
          throw typeError("property.has.no.setter", name, ScriptRuntime.safeToString(self));
        }
      }
      return;
    }
    // property found and is a UserAccessorProperty
    find.setValue(value, strict);
  }

  private static MethodHandle findOwnMH(final String name, final MethodType type) {
    return MH.findStatic(MethodHandles.lookup(), PrimitiveLookup.class, name, type);
  }
}
