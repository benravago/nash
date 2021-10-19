package es.runtime.linker;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Supplier;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.NamedOperation;
import jdk.dynalink.beans.BeansLinker;
import jdk.dynalink.beans.StaticClass;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.GuardingDynamicLinker;
import jdk.dynalink.linker.GuardingTypeConverterFactory;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.LinkerServices;
import jdk.dynalink.linker.support.Lookup;

import es.codegen.types.Type;
import es.runtime.ECMAException;
import es.runtime.JSType;
import es.runtime.ScriptRuntime;
import es.runtime.UnwarrantedOptimismException;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.typeError;
import static es.runtime.ScriptRuntime.UNDEFINED;

/**
 * Nashorn bottom linker; used as a last-resort catch-all linker for all linking requests that fall through all other linkers (see how {@link Bootstrap} class configures the dynamic linker in its static initializer).
 *
 * It will throw appropriate ECMAScript errors for attempts to invoke operations on {@code null}, link no-op property getters and setters for Java objects that couldn't be linked by any other linker, and throw appropriate ECMAScript errors for attempts to invoke arbitrary Java objects as functions or constructors.
 */
final class NashornBottomLinker implements GuardingDynamicLinker, GuardingTypeConverterFactory {

  @Override
  public GuardedInvocation getGuardedInvocation(LinkRequest linkRequest, LinkerServices linkerServices) throws Exception {
    var self = linkRequest.getReceiver();
    if (self == null) {
      return linkNull(linkRequest);
    }
    // None of the objects that can be linked by NashornLinker should ever reach here.
    // Basically, anything below this point is a generic Java bean.
    // Therefore, reaching here with a ScriptObject is a Nashorn bug.
    assert isExpectedObject(self) : "Couldn't link " + linkRequest.getCallSiteDescriptor() + " for " + self.getClass().getName();
    return linkBean(linkRequest);
  }

  private static final MethodHandle EMPTY_PROP_GETTER = MH.dropArguments(MH.constant(Object.class, UNDEFINED), 0, Object.class);
  private static final MethodHandle EMPTY_ELEM_GETTER = MH.dropArguments(EMPTY_PROP_GETTER, 0, Object.class);
  private static final MethodHandle EMPTY_PROP_SETTER = MH.asType(EMPTY_ELEM_GETTER, EMPTY_ELEM_GETTER.type().changeReturnType(void.class));

  private static final MethodHandle THROW_PROPERTY_SETTER;
  private static final MethodHandle THROW_PROPERTY_REMOVER;
  private static final MethodHandle THROW_OPTIMISTIC_UNDEFINED;
  
  // TODO: maybe remove
  private static final MethodHandle EMPTY_ELEM_SETTER = MH.dropArguments(EMPTY_PROP_SETTER, 0, Object.class);
  private static final MethodHandle MISSING_PROPERTY_REMOVER;

  static /*<init>*/ {
    var lookup = new Lookup(MethodHandles.lookup());
    THROW_PROPERTY_SETTER = lookup.findOwnStatic("throwPropertySetter", void.class, Object.class, Object.class);
    THROW_PROPERTY_REMOVER = lookup.findOwnStatic("throwPropertyRemover", boolean.class, Object.class, Object.class);
    THROW_OPTIMISTIC_UNDEFINED = lookup.findOwnStatic("throwOptimisticUndefined", Object.class, int.class);
    MISSING_PROPERTY_REMOVER = lookup.findOwnStatic("missingPropertyRemover", boolean.class, Object.class, Object.class);
  }

  static GuardedInvocation linkBean(LinkRequest linkRequest) throws Exception {
    var desc = linkRequest.getCallSiteDescriptor();
    var self = linkRequest.getReceiver();
    switch (NashornCallSiteDescriptor.getStandardOperation(desc)) {
      case NEW -> {
        if (BeansLinker.isDynamicConstructor(self)) {
          throw typeError("no.constructor.matches.args", ScriptRuntime.safeToString(self));
        }
        if (BeansLinker.isDynamicMethod(self)) {
          throw typeError("method.not.constructor", ScriptRuntime.safeToString(self));
        }
        throw typeError("not.a.function", NashornCallSiteDescriptor.getFunctionErrorMessage(desc, self));
      }
      case CALL -> {
        if (BeansLinker.isDynamicConstructor(self)) {
          throw typeError("constructor.requires.new", ScriptRuntime.safeToString(self));
        }
        if (BeansLinker.isDynamicMethod(self)) {
          throw typeError("no.method.matches.args", ScriptRuntime.safeToString(self));
        }
        throw typeError("not.a.function", NashornCallSiteDescriptor.getFunctionErrorMessage(desc, self));
      }
      default -> {
        // Everything else is supposed to have been already handled by Bootstrap.beansLinker
        // delegating to linkNoSuchBeanMember
        throw new AssertionError("unknown call type " + desc);
      }
    }
  }

  static MethodHandle linkMissingBeanMember(LinkRequest linkRequest, LinkerServices linkerServices) throws Exception {
    var desc = linkRequest.getCallSiteDescriptor();
    var operand = NashornCallSiteDescriptor.getOperand(desc);
    return switch (NashornCallSiteDescriptor.getStandardOperation(desc)) {
      case GET -> {
        if (NashornCallSiteDescriptor.isOptimistic(desc)) {
          yield adaptThrower(MethodHandles.insertArguments(THROW_OPTIMISTIC_UNDEFINED, 0, NashornCallSiteDescriptor.getProgramPoint(desc)), desc);
        } else if (operand != null) {
          yield getInvocation(EMPTY_PROP_GETTER, linkerServices, desc);
        }
        yield getInvocation(EMPTY_ELEM_GETTER, linkerServices, desc);
      }
      case SET -> {
        yield adaptThrower(bindOperand(THROW_PROPERTY_SETTER, operand), desc);
      }
      case REMOVE -> {
        yield adaptThrower(bindOperand(THROW_PROPERTY_REMOVER, operand), desc);
      }
      default -> {
        throw new AssertionError("unknown call type " + desc);
      }
    };
  }

  static MethodHandle bindOperand(MethodHandle handle, String operand) {
    return operand == null ? handle : MethodHandles.insertArguments(handle, 1, operand);
  }

  static MethodHandle adaptThrower(MethodHandle handle, CallSiteDescriptor desc) {
    var targetType = desc.getMethodType();
    var paramCount = handle.type().parameterCount();
    return MethodHandles
      .dropArguments(handle, paramCount, targetType.parameterList().subList(paramCount, targetType.parameterCount()))
      .asType(targetType);
  }

  @SuppressWarnings("unused")
  static void throwPropertySetter(Object self, Object name) {
    throw createTypeError(self, name, "cant.set.property");
  }

  @SuppressWarnings("unused")
  static boolean throwPropertyRemover(Object self, Object name) {
    if (isNonConfigurableProperty(self, name)) {
      throw createTypeError(self, name, "cant.delete.property");
    }
    return true;
  }

  @SuppressWarnings("unused")
  static boolean missingPropertyRemover(Object self, Object name) {
    return !isNonConfigurableProperty(self, name);
  }

  // Corresponds to ECMAScript 5.1 8.12.7 [[Delete]] point 3 check for "isConfigurable" (but negated)
  static boolean isNonConfigurableProperty(Object self, Object name) {
    if (self instanceof StaticClass sc) {
      var type = sc.getRepresentedClass();
      return BeansLinker.getReadableStaticPropertyNames(type).contains(name)
          || BeansLinker.getWritableStaticPropertyNames(type).contains(name)
          || BeansLinker.getStaticMethodNames(type).contains(name);
    }
    var type = self.getClass();
    return BeansLinker.getReadableInstancePropertyNames(type).contains(name)
        || BeansLinker.getWritableInstancePropertyNames(type).contains(name)
        || BeansLinker.getInstanceMethodNames(type).contains(name);
  }

  static ECMAException createTypeError(Object self, Object name, String msg) {
    return typeError(msg, String.valueOf(name), ScriptRuntime.safeToString(self));
  }

  @SuppressWarnings("unused")
  static Object throwOptimisticUndefined(int programPoint) {
    throw new UnwarrantedOptimismException(UNDEFINED, programPoint, Type.OBJECT);
  }

  @Override
  public GuardedInvocation convertToType(Class<?> sourceType, Class<?> targetType, Supplier<MethodHandles.Lookup> lookupSupplier) throws Exception {
    var gi = convertToTypeNoCast(sourceType, targetType);
    return gi == null ? null : gi.asType(MH.type(targetType, sourceType));
  }

  /**
   * Main part of the implementation of {@link GuardingTypeConverterFactory#convertToType} that doesn't care about adapting the method signature; that's done by the invoking method.
   * Returns conversion from Object to String/number/boolean (JS primitive types).
   * @param sourceType the source type
   * @param targetType the target type
   * @return a guarded invocation that converts from the source type to the target type.
   * @throws Exception if something goes wrong
   */
  static GuardedInvocation convertToTypeNoCast(Class<?> sourceType, Class<?> targetType) throws Exception {
    var mh = CONVERTERS.get(targetType);
    return (mh != null) ? new GuardedInvocation(mh) : null;
  }

  static MethodHandle getInvocation(MethodHandle handle, LinkerServices linkerServices, CallSiteDescriptor desc) {
    return linkerServices.asTypeLosslessReturn(handle, desc.getMethodType());
  }

  // Used solely in an assertion to figure out if the object we get here is something we in fact expect.
  // Objects linked by NashornLinker should never reach here.
  static boolean isExpectedObject(Object obj) {
    return !(NashornLinker.canLinkTypeStatic(obj.getClass()));
  }

  static GuardedInvocation linkNull(LinkRequest linkRequest) {
    var desc = linkRequest.getCallSiteDescriptor();
    switch (NashornCallSiteDescriptor.getStandardOperation(desc)) {
      case NEW, CALL -> throw typeError("not.a.function", "null");
      case GET -> throw typeError(NashornCallSiteDescriptor.isMethodFirstOperation(desc) ? "no.such.function" : "cant.get.property", getArgument(linkRequest), "null");
      case SET -> throw typeError("cant.set.property", getArgument(linkRequest), "null");
      case REMOVE -> throw typeError("cant.delete.property", getArgument(linkRequest), "null");
      default -> throw new AssertionError("unknown call type " + desc);
    }
  }

  private static final Map<Class<?>, MethodHandle> CONVERTERS = new HashMap<>();

  static /*<init>*/ {
    CONVERTERS.put(boolean.class, JSType.TO_BOOLEAN.methodHandle());
    CONVERTERS.put(double.class, JSType.TO_NUMBER.methodHandle());
    CONVERTERS.put(int.class, JSType.TO_INTEGER.methodHandle());
    CONVERTERS.put(long.class, JSType.TO_LONG.methodHandle());
    CONVERTERS.put(String.class, JSType.TO_STRING.methodHandle());
  }

  static String getArgument(LinkRequest linkRequest) {
    var op = linkRequest.getCallSiteDescriptor().getOperation();
    if (op instanceof NamedOperation no) {
      return no.getName().toString();
    }
    return ScriptRuntime.safeToString(linkRequest.getArguments()[1]);
  }

}
