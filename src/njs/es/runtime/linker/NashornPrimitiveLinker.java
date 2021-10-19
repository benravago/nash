package es.runtime.linker;

import java.util.function.Supplier;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import jdk.dynalink.linker.ConversionComparator;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.GuardingTypeConverterFactory;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.LinkerServices;
import jdk.dynalink.linker.TypeBasedGuardingDynamicLinker;
import jdk.dynalink.linker.support.TypeUtilities;

import es.objects.Global;
import es.runtime.ConsString;
import es.runtime.JSType;
import es.runtime.ScriptRuntime;
import es.runtime.Symbol;
import static es.lookup.Lookup.MH;

/**
 * Internal linker for String, Boolean, and Number objects, only ever used by Nashorn engine and not exposed to other engines.
 *
 * It is used for treatment of strings, boolean, and numbers as JavaScript primitives.
 * Also provides ECMAScript primitive type conversions for these types when linking to Java methods.
 */
final class NashornPrimitiveLinker implements TypeBasedGuardingDynamicLinker, GuardingTypeConverterFactory, ConversionComparator {

  private static final GuardedInvocation VOID_TO_OBJECT = new GuardedInvocation(MethodHandles.constant(Object.class, ScriptRuntime.UNDEFINED));

  @Override
  public boolean canLinkType(Class<?> type) {
    return canLinkTypeStatic(type);
  }

  private static boolean canLinkTypeStatic(Class<?> c) {
    return c == String.class || c == Boolean.class || c == ConsString.class || c == Integer.class || c == Double.class || c == Float.class || c == Short.class || c == Byte.class || c == Symbol.class;
  }

  @Override
  public GuardedInvocation getGuardedInvocation(LinkRequest request, LinkerServices linkerServices) throws Exception {
    var self = request.getReceiver();
    return Bootstrap.asTypeSafeReturn(Global.primitiveLookup(request, self), linkerServices, request.getCallSiteDescriptor());
  }

  /**
   * This implementation of type converter factory will pretty much allow implicit conversions of anything to anything else that's allowed among JavaScript primitive types (string to number, boolean to string, etc.)
   * @param sourceType the type to convert from
   * @param targetType the type to convert to
   * @return a conditional converter from source to target type
   */
  @Override
  public GuardedInvocation convertToType(Class<?> sourceType, Class<?> targetType, Supplier<MethodHandles.Lookup> lookupSupplier) {
    var mh = JavaArgumentConverters.getConverter(targetType);
    if (mh == null) {
      if (targetType == Object.class && sourceType == void.class) {
        return VOID_TO_OBJECT;
      }
      return null;
    }
    return new GuardedInvocation(mh, canLinkTypeStatic(sourceType) ? null : GUARD_PRIMITIVE).asType(mh.type().changeParameterType(0, sourceType));
  }

  /**
   * Implements the somewhat involved prioritization of JavaScript primitive types conversions.
   * Instead of explaining it here in prose, just follow the source code comments.
   * @param sourceType the source type to convert from
   * @param targetType1 one candidate target type
   * @param targetType2 another candidate target type
   * @return one of {@link jdk.dynalink.linker.ConversionComparator.Comparison} values signifying which target type should be favored for conversion.
   */
  @Override
  public Comparison compareConversion(Class<?> sourceType, Class<?> targetType1, Class<?> targetType2) {
    var wrapper1 = getWrapperTypeOrSelf(targetType1);
    if (sourceType == wrapper1) {
      // Source type exactly matches target 1
      return Comparison.TYPE_1_BETTER;
    }
    var wrapper2 = getWrapperTypeOrSelf(targetType2);
    if (sourceType == wrapper2) {
      // Source type exactly matches target 2
      return Comparison.TYPE_2_BETTER;
    }
    if (Number.class.isAssignableFrom(sourceType)) {
      // If exactly one of the targets is a number, pick it.
      if (Number.class.isAssignableFrom(wrapper1)) {
        if (!Number.class.isAssignableFrom(wrapper2)) {
          return Comparison.TYPE_1_BETTER;
        }
      } else if (Number.class.isAssignableFrom(wrapper2)) {
        return Comparison.TYPE_2_BETTER;
      }

      // If exactly one of the targets is a character, pick it.
      // Numbers can be reasonably converted to chars using the UTF-16 values.
      if (Character.class == wrapper1) {
        return Comparison.TYPE_1_BETTER;
      } else if (Character.class == wrapper2) {
        return Comparison.TYPE_2_BETTER;
      }
      // For all other cases, we fall through to the next if statement - not that we repeat the condition in it too so if we entered this branch, we'll enter the below if statement too.
    }
    if (sourceType == String.class || sourceType == Boolean.class || Number.class.isAssignableFrom(sourceType)) {
      // Treat wrappers as primitives.
      var primitiveType1 = getPrimitiveTypeOrSelf(targetType1);
      var primitiveType2 = getPrimitiveTypeOrSelf(targetType2);
      // Basically, choose the widest possible primitive type.
      // (First "if" returning TYPE_2_BETTER is correct; when faced with a choice between double and int, choose double).
      if (TypeUtilities.isMethodInvocationConvertible(primitiveType1, primitiveType2)) {
        return Comparison.TYPE_2_BETTER;
      } else if (TypeUtilities.isMethodInvocationConvertible(primitiveType2, primitiveType1)) {
        return Comparison.TYPE_1_BETTER;
      }
      // Ok, at this point we're out of possible number conversions, so try strings.
      // A String can represent any value without loss, so if one of the potential targets is string, go for it.
      if (targetType1 == String.class) {
        return Comparison.TYPE_1_BETTER;
      }
      if (targetType2 == String.class) {
        return Comparison.TYPE_2_BETTER;
      }
    }
    return Comparison.INDETERMINATE;
  }

  static Class<?> getPrimitiveTypeOrSelf(Class<?> type) {
    var primitive = TypeUtilities.getPrimitiveType(type);
    return primitive == null ? type : primitive;
  }

  static Class<?> getWrapperTypeOrSelf(Class<?> type) {
    var wrapper = TypeUtilities.getWrapperType(type);
    return wrapper == null ? type : wrapper;
  }

  @SuppressWarnings("unused")
  static boolean isJavaScriptPrimitive(Object o) {
    return JSType.isString(o) || o instanceof Boolean || JSType.isNumber(o) || o == null || o instanceof Symbol;
  }

  private static final MethodHandle GUARD_PRIMITIVE = findOwnMH("isJavaScriptPrimitive", boolean.class, Object.class);

  static MethodHandle findOwnMH(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), NashornPrimitiveLinker.class, name, MH.type(rtype, types));
  }

}
