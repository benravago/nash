package es.runtime;

import java.util.Collection;
import java.util.List;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodType;

/**
 * This is a subclass that represents a script function that may not be regenerated.
 * This is used for example for bound functions and builtins.
 */
final class FinalScriptFunctionData extends ScriptFunctionData {

  // documentation key for this function, may be null
  private String docKey;

  /**
   * Constructor - used for bind
   *
   * @param name      name
   * @param arity     arity
   * @param functions precompiled code
   * @param flags     {@link ScriptFunctionData} flags
   */
  FinalScriptFunctionData(String name, int arity, List<CompiledFunction> functions, int flags) {
    super(name, arity, flags);
    code.addAll(functions);
    assert !needsCallee();
  }

  /**
   * Constructor - used from ScriptFunction.
   * This assumes that we have code already for the method (typically a native method) and possibly specializations.
   * @param name  name
   * @param mh    method handle for generic version of method
   * @param specs specializations
   * @param flags {@link ScriptFunctionData} flags
   */
  FinalScriptFunctionData(String name, MethodHandle mh, Specialization[] specs, int flags) {
    super(name, methodHandleArity(mh), flags);
    addInvoker(mh);
    if (specs != null) {
      for (var spec : specs) {
        addInvoker(spec.getMethodHandle(), spec);
      }
    }
  }

  @Override
  String getDocumentationKey() {
    return docKey;
  }

  @Override
  void setDocumentationKey(String docKey) {
    this.docKey = docKey;
  }

  @Override
  String getDocumentation() {
    var doc = docKey != null ? FunctionDocumentation.getDoc(docKey) : null;
    return doc != null ? doc : super.getDocumentation();
  }

  @Override
  protected boolean needsCallee() {
    var needsCallee = code.getFirst().needsCallee();
    assert allNeedCallee(needsCallee);
    return needsCallee;
  }

  private boolean allNeedCallee(boolean needCallee) {
    for (var inv : code) {
      if (inv.needsCallee() != needCallee) {
        return false;
      }
    }
    return true;
  }

  @Override
  CompiledFunction getBest(MethodType callSiteType, ScriptObject runtimeScope, Collection<CompiledFunction> forbidden, boolean linkLogicOkay) {
    assert isValidCallSite(callSiteType) : callSiteType;
    CompiledFunction best = null;
    for (var candidate : code) {
      if (!linkLogicOkay && candidate.hasLinkLogic()) {
        // Skip! Version with no link logic is desired, but this one has link logic!
        continue;
      }
      if (!forbidden.contains(candidate) && candidate.betterThanFinal(best, callSiteType)) {
        best = candidate;
      }
    }
    return best;
  }

  @Override
  MethodType getGenericType() {
    // We need to ask the code for its generic type.
    // We can't just rely on this function data's arity, as it's not actually correct for lots of built-ins.
    // E.g. ECMAScript 5.1 section 15.5.3.2 prescribes that Script.fromCharCode([char0[, char1[, ...]]]) has a declared arity of 1 even though it's a variable arity method.
    var max = 0;
    for (var fn : code) {
      var t = fn.type();
      if (ScriptFunctionData.isVarArg(t)) {
        // 2 for (callee, this, args[])
        return MethodType.genericMethodType(2, true);
      }
      var paramCount = t.parameterCount() - (ScriptFunctionData.needsCallee(t) ? 1 : 0);
      if (paramCount > max) {
        max = paramCount;
      }
    }
    // +1 for callee
    return MethodType.genericMethodType(max + 1);
  }

  CompiledFunction addInvoker(MethodHandle mh, Specialization specialization) {
    assert !needsCallee(mh);
    CompiledFunction invoker;
    if (isConstructor(mh)) {
      // only nasgen constructors:
      // (boolean, self, args) are subject to binding a boolean newObj.
      // isConstructor is too conservative a check.
      // However, isConstructor(mh) always implies isConstructor param
      assert isConstructor();
      invoker = CompiledFunction.createBuiltInConstructor(mh);
    } else {
      invoker = new CompiledFunction(mh, null, specialization);
    }
    code.add(invoker);
    return invoker;
  }

  CompiledFunction addInvoker(MethodHandle mh) {
    return addInvoker(mh, null);
  }

  static int methodHandleArity(MethodHandle mh) {
    // drop self, callee and boolean constructor flag to get real arity
    return isVarArg(mh) ? MAX_ARITY : mh.type().parameterCount() - 1 - (needsCallee(mh) ? 1 : 0) - (isConstructor(mh) ? 1 : 0);
  }

  static boolean isConstructor(MethodHandle mh) {
    return mh.type().parameterCount() >= 1 && mh.type().parameterType(0) == boolean.class;
  }

  private static final long serialVersionUID = 1;
}
