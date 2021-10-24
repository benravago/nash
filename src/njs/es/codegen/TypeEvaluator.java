package es.codegen;

import java.lang.invoke.MethodType;

import es.codegen.types.Type;
import es.ir.AccessNode;
import es.ir.CallNode;
import es.ir.Expression;
import es.ir.FunctionNode;
import es.ir.IdentNode;
import es.ir.IndexNode;
import es.ir.Optimistic;
import es.objects.ArrayBufferView;
import es.objects.NativeArray;
import es.runtime.FindProperty;
import es.runtime.JSType;
import es.runtime.Property;
import es.runtime.RecompilableScriptFunctionData;
import es.runtime.ScriptFunction;
import es.runtime.ScriptObject;
import es.runtime.ScriptRuntime;
import static es.runtime.Property.*;

/**
 * Functionality for using a runtime scope to look up value types.
 * Used during recompilation.
 */
final class TypeEvaluator {

  // Type signature for invocation of functions without parameters: we must pass (callee, this) of type (ScriptFunction, Object) respectively.
  // We also use Object as the return type (we must pass something, but it'll be ignored; it can't be void, though).
  private static final MethodType EMPTY_INVOCATION_TYPE = MethodType.methodType(Object.class, ScriptFunction.class, Object.class);

  private final Compiler compiler;
  private final ScriptObject runtimeScope;

  TypeEvaluator(Compiler compiler, ScriptObject runtimeScope) {
    this.compiler = compiler;
    this.runtimeScope = runtimeScope;
  }

  /**
   * Returns true if the expression can be safely evaluated, and its value is an object known to always use String as the type of its property names retrieved through {@link ScriptRuntime#toPropertyIterator(Object)}.
   * It is used to avoid optimistic assumptions about its property name types.
   * @param expr the expression to test
   * @return true if the expression can be safely evaluated, and its value is an object known to always use String as the type of its property iterators.
   */
  boolean hasStringPropertyIterator(Expression expr) {
    return evaluateSafely(expr) instanceof ScriptObject;
  }

  Type getOptimisticType(Optimistic node) {
    assert compiler.useOptimisticTypes();
    var programPoint = node.getProgramPoint();
    var validType = compiler.getInvalidatedProgramPointType(programPoint);
    if (validType != null) {
      return validType;
    }
    var mostOptimisticType = node.getMostOptimisticType();
    var evaluatedType = getEvaluatedType(node);
    if (evaluatedType != null) {
      if (evaluatedType.widerThan(mostOptimisticType)) {
        var newValidType = evaluatedType.isObject() || evaluatedType.isBoolean() ? Type.OBJECT : evaluatedType;
        // Update invalidatedProgramPoints so we don't re-evaluate the expression next time.
        // This is a heuristic as we're doing a tradeoff.
        // Re-evaluating expressions on each recompile takes time, but it might notice a widening in the type of the expression and thus prevent an unnecessary deoptimization later.
        // We'll presume though that the types of expressions are mostly stable, so if we evaluated it in one compilation, we'll keep to that and risk a low-probability deoptimization if its type gets widened in the future.
        compiler.addInvalidatedProgramPoint(node.getProgramPoint(), newValidType);
      }
      return evaluatedType;
    }
    return mostOptimisticType;
  }

  static Type getPropertyType(ScriptObject sobj, String name) {
    var find = sobj.findProperty(name, true);
    if (find == null) {
      return null;
    }
    var property = find.getProperty();
    var propertyClass = property.getType();
    if (propertyClass == null) {
      // propertyClass == null means its value is Undefined.
      // It is probably not initialized yet, so we won't make a type assumption yet.
      return null;
    } else if (propertyClass.isPrimitive()) {
      return Type.typeFor(propertyClass);
    }
    var owner = find.getOwner();
    if (property.hasGetterFunction(owner)) {
      // Can have side effects, so we can't safely evaluate it; since !propertyClass.isPrimitive(), it's Object.
      return Type.OBJECT;
    }
    // Safely evaluate the property, and return the narrowest type for the actual value (e.g. Type.INT for a boxed integer).
    var value = property.needsDeclaration() ? ScriptRuntime.UNDEFINED : property.getObjectValue(owner, owner);
    if (value == ScriptRuntime.UNDEFINED) {
      return null;
    }
    return Type.typeFor(JSType.unboxedFieldType(value));
  }

  /**
   * Declares a symbol name as belonging to a non-scoped local variable during an on-demand compilation of a single function.
   * This method will add an explicit Undefined binding for the local into the runtime scope if it's otherwise implicitly undefined so that when an expression is evaluated for the name, it won't accidentally find an unrelated value higher up the scope chain.
   * It is only required to call this method when doing an optimistic on-demand compilation.
   * @param symbolName the name of the symbol that is to be declared as being a non-scoped local variable.
   */
  void declareLocalSymbol(String symbolName) {
    assert compiler.useOptimisticTypes() && compiler.isOnDemandCompilation() && runtimeScope != null
      : "useOptimistic=" + compiler.useOptimisticTypes() + " isOnDemand=" + compiler.isOnDemandCompilation() + " scope=" + runtimeScope;
    if (runtimeScope.findProperty(symbolName, false) == null) {
      runtimeScope.addOwnProperty(symbolName, NOT_WRITABLE | NOT_ENUMERABLE | NOT_CONFIGURABLE, ScriptRuntime.UNDEFINED);
    }
  }

  Object evaluateSafely(Expression expr) {
    if (expr instanceof IdentNode i) {
      return runtimeScope == null ? null : evaluatePropertySafely(runtimeScope, i.getName());
    }
    if (expr instanceof AccessNode accessNode) {
      var base = evaluateSafely(accessNode.getBase());
      return (base instanceof ScriptObject) ? evaluatePropertySafely((ScriptObject) base, accessNode.getProperty()) : null;
    }
    return null;
  }

  static Object evaluatePropertySafely(ScriptObject sobj, String name) {
    var find = sobj.findProperty(name, true);
    if (find == null) {
      return null;
    }
    var property = find.getProperty();
    var owner = find.getOwner();
    if (property.hasGetterFunction(owner)) {
      // Possible side effects; can't evaluate safely
      return null;
    }
    return property.getObjectValue(owner, owner);
  }

  Type getEvaluatedType(Optimistic expr) {
    if (expr instanceof IdentNode i) {
      return (runtimeScope != null) ? getPropertyType(runtimeScope, i.getName()) : null;
    } else if (expr instanceof AccessNode accessNode) {
      var base = evaluateSafely(accessNode.getBase());
      return (base instanceof ScriptObject s) ? getPropertyType(s, accessNode.getProperty()) : null;
    } else if (expr instanceof IndexNode indexNode) {
      var base = evaluateSafely(indexNode.getBase());
      if (base instanceof NativeArray || base instanceof ArrayBufferView) {
        // NOTE: optimistic array getters throw UnwarrantedOptimismException based on the type of their underlying array storage, not based on values of individual elements.
        // Thus, a LongArrayData will throw UOE for every optimistic int linkage attempt, even if the long value being returned in the first invocation would be representable as int.
        // That way, we can presume that the array's optimistic type is the most optimistic type for which an element getter has a chance of executing successfully.
        return ((ScriptObject) base).getArray().getOptimisticType();
      }
    } else if (expr instanceof CallNode callExpr) {
      // Currently, we'll only try to guess the return type of immediately invoked function expressions with no parameters, that is (function() { ... })().
      // We could do better, but these are all heuristics and we can gradually introduce them as needed. An easy one would be to do the same for .call(this) idiom.
      var fnExpr = callExpr.getFunction();
      // Skip evaluation if running with eager compilation as we may violate constraints in RecompilableScriptFunctionData
      if (fnExpr instanceof FunctionNode fn && compiler.getContext().getEnv()._lazy_compilation) {
        if (callExpr.getArgs().isEmpty()) {
          var data = compiler.getScriptFunctionData(fn.getId());
          if (data != null) {
            var returnType = Type.typeFor(data.getReturnType(EMPTY_INVOCATION_TYPE, runtimeScope));
            if (returnType == Type.BOOLEAN) {
              // We don't have optimistic booleans.
              // In fact, optimistic call sites getting back boolean currently deoptimize all the way to Object.
              return Type.OBJECT;
            }
            assert returnType == Type.INT || returnType == Type.NUMBER || returnType == Type.OBJECT;
            return returnType;
          }
        }
      }
    }
    return null;
  }

}
