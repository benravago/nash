package es.runtime.linker;

import java.util.Collection;
import java.util.Deque;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.function.Supplier;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.reflect.Modifier;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.SecureLookupSupplier;
import jdk.dynalink.linker.ConversionComparator;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.GuardingTypeConverterFactory;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.LinkerServices;
import jdk.dynalink.linker.TypeBasedGuardingDynamicLinker;
import jdk.dynalink.linker.support.Guards;
import jdk.dynalink.linker.support.Lookup;

import javax.script.Bindings;
import nash.scripting.JSObject;
import nash.scripting.ScriptObjectMirror;
import nash.scripting.ScriptUtils;

import es.codegen.CompilerConstants.Call;
import es.objects.NativeArray;
import es.runtime.JSType;
import es.runtime.ListAdapter;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.Undefined;
import static es.lookup.Lookup.MH;

/**
 * This is the main dynamic linker for Nashorn.
 *
 * It is used for linking all {@link ScriptObject} and its subclasses (this includes {@link ScriptFunction} and its subclasses) as well as {@link Undefined}.
 */
final class NashornLinker implements TypeBasedGuardingDynamicLinker, GuardingTypeConverterFactory, ConversionComparator {

  private static final ClassValue<MethodHandle> ARRAY_CONVERTERS = new ClassValue<>() {
    @Override protected MethodHandle computeValue(Class<?> type) { return createArrayConverter(type); }
  };

  /**
   * Returns true if {@code ScriptObject} is assignable from {@code type}, or it is {@code Undefined}.
   */
  @Override
  public boolean canLinkType(Class<?> type) {
    return canLinkTypeStatic(type);
  }

  static boolean canLinkTypeStatic(Class<?> type) {
    return ScriptObject.class.isAssignableFrom(type) || Undefined.class == type;
  }

  @Override
  public GuardedInvocation getGuardedInvocation(LinkRequest request, LinkerServices linkerServices) throws Exception {
    var desc = request.getCallSiteDescriptor();
    return Bootstrap.asTypeSafeReturn(getGuardedInvocation(request, desc), linkerServices, desc);
  }

  static GuardedInvocation getGuardedInvocation(LinkRequest request, CallSiteDescriptor desc) {
    var self = request.getReceiver();
    GuardedInvocation inv;
    if (self instanceof ScriptObject so) {
      inv = so.lookup(desc, request);
    } else if (self instanceof Undefined) {
      inv = Undefined.lookup(desc);
    } else {
      throw new AssertionError(self.getClass().getName()); // Should never reach here.
    }
    return inv;
  }

  @Override
  public GuardedInvocation convertToType(Class<?> sourceType, Class<?> targetType, Supplier<MethodHandles.Lookup> lookupSupplier) throws Exception {
    var gi = convertToTypeNoCast(sourceType, targetType, lookupSupplier);
    if (gi == null) {
      gi = getSamTypeConverter(sourceType, targetType, lookupSupplier);
    }
    return gi == null ? null : gi.asType(MH.type(targetType, sourceType));
  }

  /**
   * Main part of the implementation of {@link GuardingTypeConverterFactory#convertToType(Class, Class)} that doesn't care about adapting the method signature; that's done by the invoking method.
   * Returns either a built-in conversion to primitive (or primitive wrapper) Java types or to String, or a just-in-time generated converter to a SAM type (if the target type is a SAM type).
   * @param sourceType the source type
   * @param targetType the target type
   * @return a guarded invocation that converts from the source type to the target type.
   * @throws Exception if something goes wrong
   */
  static GuardedInvocation convertToTypeNoCast(Class<?> sourceType, Class<?> targetType, Supplier<MethodHandles.Lookup> lookupSupplier) throws Exception {
    var mh = JavaArgumentConverters.getConverter(targetType);
    if (mh != null) {
      return new GuardedInvocation(mh, canLinkTypeStatic(sourceType) ? null : IS_NASHORN_OR_UNDEFINED_TYPE);
    }
    var arrayConverter = getArrayConverter(sourceType, targetType, lookupSupplier);
    if (arrayConverter != null) {
      return arrayConverter;
    }
    return getMirrorConverter(sourceType, targetType);
  }

  /**
   * Returns a guarded invocation that converts from a source type that is ScriptFunction, or a subclass or a superclass of it) to a SAM type.
   * @param sourceType the source type (presumably ScriptFunction or a subclass or a superclass of it)
   * @param targetType the target type (presumably a SAM type)
   * @return a guarded invocation that converts from the source type to the target SAM type. null is returned if either the source type is neither ScriptFunction, nor a subclass, nor a superclass of it, or if the target type is not a SAM type.
   * @throws Exception if something goes wrong; generally, if there's an issue with creation of the SAM proxy type constructor.
   */
  static GuardedInvocation getSamTypeConverter(Class<?> sourceType, Class<?> targetType, Supplier<MethodHandles.Lookup> lookupSupplier) throws Exception {
    // If source type is more generic than ScriptFunction class, we'll need to use a guard
    var isSourceTypeGeneric = sourceType.isAssignableFrom(ScriptObject.class);
    if ((isSourceTypeGeneric || ScriptFunction.class.isAssignableFrom(sourceType)) && isAutoConvertibleFromFunction(targetType)) {
      var paramType = isSourceTypeGeneric ? Object.class : ScriptFunction.class;
      // Using Object.class as constructor source type means we're getting an overloaded constructor handle, which is safe but slower than a single constructor handle.
      // If the actual argument is a ScriptFunction it would be nice if we could change the formal parameter to ScriptFunction.class and add a guard for it in the main invocation.
      var ctor = JavaAdapterFactory.getConstructor(paramType, targetType, getCurrentLookup(lookupSupplier));
      assert ctor != null; // if isAutoConvertibleFromFunction() returned true, then ctor must exist.
      return new GuardedInvocation(ctor, isSourceTypeGeneric ? IS_FUNCTION : null);
    }
    return null;
  }

  static MethodHandles.Lookup getCurrentLookup(Supplier<MethodHandles.Lookup> lookupSupplier) {
    return lookupSupplier.get();
  }

  /**
   * Returns a guarded invocation that converts from a source type that is NativeArray to a Java array or List or Queue or Deque or Collection type.
   * @param sourceType the source type (presumably NativeArray a superclass of it)
   * @param targetType the target type (presumably an array type, or List or Queue, or Deque, or Collection)
   * @return a guarded invocation that converts from the source type to the target type. null is returned if either the source type is neither NativeArray, nor a superclass of it, or if the target type is not an array type, List, Queue, Deque, or Collection.
   */
  static GuardedInvocation getArrayConverter(Class<?> sourceType, Class<?> targetType, Supplier<MethodHandles.Lookup> lookupSupplier) {
    var isSourceTypeNativeArray = sourceType == NativeArray.class;
    // If source type is more generic than NativeArray class, we'll need to use a guard
    var isSourceTypeGeneric = !isSourceTypeNativeArray && sourceType.isAssignableFrom(NativeArray.class);
    if (isSourceTypeNativeArray || isSourceTypeGeneric) {
      var guard = isSourceTypeGeneric ? IS_NATIVE_ARRAY : null;
      if (targetType.isArray()) {
        var mh = ARRAY_CONVERTERS.get(targetType);
        MethodHandle mhWithLookup;
        if (mh.type().parameterCount() == 2) {
          assert mh.type().parameterType(1) == SecureLookupSupplier.class;
          // We enter this branch when the array's ultimate component type is a SAM type; we use a handle to JSType.toJavaArrayWithLookup for these in the converter MH and must bind it here with a secure supplier for the current lookup.
          // By retrieving the lookup, we'll also (correctly) inform the type converter that this array converter is lookup specific.
          // We then need to wrap the returned lookup into a new SecureLookupSupplier in order to bind it to the JSType.toJavaArrayWithLookup() parameter.
          mhWithLookup = MH.insertArguments(mh, 1, new SecureLookupSupplier(getCurrentLookup(lookupSupplier)));
        } else {
          mhWithLookup = mh;
        }
        return new GuardedInvocation(mhWithLookup, guard);
      } else if (targetType == List.class) {
        return new GuardedInvocation(TO_LIST, guard);
      } else if (targetType == Deque.class) {
        return new GuardedInvocation(TO_DEQUE, guard);
      } else if (targetType == Queue.class) {
        return new GuardedInvocation(TO_QUEUE, guard);
      } else if (targetType == Collection.class) {
        return new GuardedInvocation(TO_COLLECTION, guard);
      }
    }
    return null;
  }

  static MethodHandle createArrayConverter(Class<?> type) {
    assert type.isArray();
    var componentType = type.getComponentType();
    Call converterCall;
    // Is the ultimate component type of this array a SAM type?
    if (isComponentTypeAutoConvertibleFromFunction(componentType)) {
      converterCall = JSType.TO_JAVA_ARRAY_WITH_LOOKUP;
    } else {
      converterCall = JSType.TO_JAVA_ARRAY;
    }
    var typeBoundConverter = MH.insertArguments(converterCall.methodHandle(), 1, componentType);
    return MH.asType(typeBoundConverter, typeBoundConverter.type().changeReturnType(type));
  }

  static boolean isComponentTypeAutoConvertibleFromFunction(Class<?> targetType) {
    return (targetType.isArray()) ? isComponentTypeAutoConvertibleFromFunction(targetType.getComponentType()) : isAutoConvertibleFromFunction(targetType);
  }

  static GuardedInvocation getMirrorConverter(Class<?> sourceType, Class<?> targetType) {
    // Could've also used (targetType.isAssignableFrom(ScriptObjectMirror.class) && targetType != Object.class) but it's probably better to explicitly spell out the supported target types
    if (targetType == Map.class || targetType == Bindings.class || targetType == JSObject.class || targetType == ScriptObjectMirror.class) {
      if (ScriptObject.class.isAssignableFrom(sourceType)) {
        return new GuardedInvocation(CREATE_MIRROR);
      } else if (sourceType.isAssignableFrom(ScriptObject.class) || sourceType.isInterface()) {
        return new GuardedInvocation(CREATE_MIRROR, IS_SCRIPT_OBJECT);
      }
    }
    return null;
  }

  static boolean isAutoConvertibleFromFunction(Class<?> clazz) {
    return isAbstractClass(clazz) && !ScriptObject.class.isAssignableFrom(clazz) && JavaAdapterFactory.isAutoConvertibleFromFunction(clazz);
  }

  /**
   * Utility method used by few other places in the code.
   * Tests if the class has the abstract modifier and is not an array class.
   * For some reason, array classes have the abstract modifier set in HotSpot JVM, and we don't want to treat array classes as abstract.
   * @param clazz the inspected class
   * @return true if the class is abstract and is not an array type.
   */
  static boolean isAbstractClass(Class<?> clazz) {
    return Modifier.isAbstract(clazz.getModifiers()) && !clazz.isArray();
  }

  @Override
  public Comparison compareConversion(Class<?> sourceType, Class<?> targetType1, Class<?> targetType2) {
    if (sourceType == NativeArray.class) {
      // Prefer those types we can convert to with just a wrapper (cheaper than Java array creation).
      if (isArrayPreferredTarget(targetType1)) {
        if (!isArrayPreferredTarget(targetType2)) {
          return Comparison.TYPE_1_BETTER;
        }
      } else if (isArrayPreferredTarget(targetType2)) {
        return Comparison.TYPE_2_BETTER;
      }
      // Then prefer Java arrays
      if (targetType1.isArray()) {
        if (!targetType2.isArray()) {
          return Comparison.TYPE_1_BETTER;
        }
      } else if (targetType2.isArray()) {
        return Comparison.TYPE_2_BETTER;
      }
    }
    if (ScriptObject.class.isAssignableFrom(sourceType)) {
      // Prefer interfaces
      if (targetType1.isInterface()) {
        if (!targetType2.isInterface()) {
          return Comparison.TYPE_1_BETTER;
        }
      } else if (targetType2.isInterface()) {
        return Comparison.TYPE_2_BETTER;
      }
    }
    return Comparison.INDETERMINATE;
  }

  static boolean isArrayPreferredTarget(Class<?> c) {
    return c == List.class || c == Collection.class || c == Queue.class || c == Deque.class;
  }

  private static final MethodHandle IS_SCRIPT_OBJECT = Guards.isInstance(ScriptObject.class, MH.type(Boolean.TYPE, Object.class));
  private static final MethodHandle IS_FUNCTION = findOwnMH("isFunction", boolean.class, Object.class);
  private static final MethodHandle IS_NATIVE_ARRAY = Guards.isOfClass(NativeArray.class, MH.type(Boolean.TYPE, Object.class));

  private static final MethodHandle IS_NASHORN_OR_UNDEFINED_TYPE = findOwnMH("isNashornTypeOrUndefined", Boolean.TYPE, Object.class);
  private static final MethodHandle CREATE_MIRROR = findOwnMH("createMirror", Object.class, Object.class);

  private static final MethodHandle TO_COLLECTION;
  private static final MethodHandle TO_DEQUE;
  private static final MethodHandle TO_LIST;
  private static final MethodHandle TO_QUEUE;

  static /*<init>*/ {
    var listAdapterCreate = new Lookup(MethodHandles.lookup())
      .findStatic(ListAdapter.class, "create", MethodType.methodType(ListAdapter.class, Object.class));
    TO_COLLECTION = asReturning(listAdapterCreate, Collection.class);
    TO_DEQUE = asReturning(listAdapterCreate, Deque.class);
    TO_LIST = asReturning(listAdapterCreate, List.class);
    TO_QUEUE = asReturning(listAdapterCreate, Queue.class);
  }

  static MethodHandle asReturning(MethodHandle mh, Class<?> nrtype) {
    return mh.asType(mh.type().changeReturnType(nrtype));
  }

  @SuppressWarnings("unused")
  static boolean isNashornTypeOrUndefined(Object o) {
    return o instanceof ScriptObject || o instanceof Undefined;
  }

  @SuppressWarnings("unused")
  static Object createMirror(Object obj) {
    return obj instanceof ScriptObject so ? ScriptUtils.wrap(so) : obj;
  }

  @SuppressWarnings("unused")
  static boolean isFunction(Object o) {
    return o instanceof ScriptFunction || (o instanceof ScriptObjectMirror som && som.isFunction());
  }

  private static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), NashornLinker.class, name, MH.type(rtype, types));
  }

}
