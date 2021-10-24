package es.codegen;

import java.util.Arrays;
import java.util.NoSuchElementException;

import java.lang.invoke.MethodType;

import es.codegen.types.Type;
import es.ir.FunctionNode;
import es.runtime.ScriptFunction;

/**
 * A tuple containing function id, parameter types, return type and needsCallee flag.
 */
public final class TypeMap {

  private final int functionNodeId;
  private final Type[] paramTypes;
  private final Type returnType;
  private final boolean needsCallee;

  /**
   * Constructor
   * @param functionNodeId function node id
   * @param type           method type found at runtime corresponding to parameter guess
   * @param needsCallee    does the function using this type map need a callee
   */
  public TypeMap(int functionNodeId, MethodType type, boolean needsCallee) {
    var types = new Type[type.parameterCount()];
    var pos = 0;
    for (var p : type.parameterArray()) {
      types[pos++] = Type.typeFor(p);
    }
    this.functionNodeId = functionNodeId;
    this.paramTypes = types;
    this.returnType = Type.typeFor(type.returnType());
    this.needsCallee = needsCallee;
  }

  /**
   * Returns the array of parameter types for a particular function node
   * @param functionNodeId the ID of the function node
   * @return an array of parameter types
   * @throws NoSuchElementException if the type map has no mapping for the requested function
   */
  public Type[] getParameterTypes(int functionNodeId) {
    assert this.functionNodeId == functionNodeId;
    return paramTypes.clone();
  }

  MethodType getCallSiteType(FunctionNode functionNode) {
    assert this.functionNodeId == functionNode.getId();
    var types = paramTypes;
    var mt = MethodType.methodType(returnType.getTypeClass());
    if (needsCallee) {
      mt = mt.appendParameterTypes(ScriptFunction.class);
    }
    mt = mt.appendParameterTypes(Object.class); //this
    for (var type : types) {
      if (type == null) {
        return null; // not all parameter information is supplied
      }
      mt = mt.appendParameterTypes(type.getTypeClass());
    }
    return mt;
  }

  /**
   * Does the function using this TypeMap need a callee argument.
   * This is used to compute correct param index offsets in {@link es.codegen.ApplySpecialization}
   * @return true if a callee is needed, false otherwise
   */
  public boolean needsCallee() {
    return needsCallee;
  }

  /**
   * Get the parameter type for this parameter position, or null if not known
   * @param functionNode functionNode
   * @param pos position
   * @return parameter type for this callsite if known
   */
  Type get(FunctionNode functionNode, int pos) {
    assert this.functionNodeId == functionNode.getId();
    var types = paramTypes;
    assert types == null || pos < types.length : "fn = " + functionNode.getId() + " " + "types=" + Arrays.toString(types) + " || pos=" + pos + " >= length=" + types.length + " in " + this;
    return (types != null && pos < types.length) ? types[pos] : null;
  }

  /**
   * Get the return type required for the call site we're compiling for.
   * This only determines whether object return type is required or not.
   * @return Type.OBJECT for call sites with object return types, Type.UNKNOWN for everything else
   */
  Type getReturnType() {
    return returnType.isObject() ? Type.OBJECT : Type.UNKNOWN;
  }

  @Override
  public String toString() {
    return toString("");
  }

  String toString(String prefix) {
    var id = functionNodeId;
    var ret = returnType;
    return prefix + '\t' + "function " + id + '\n' + prefix + "\t\tparamTypes=" + Arrays.toString(paramTypes) + '\n' + prefix + "\t\treturnType=" + (ret == null ? "N/A" : ret) + '\n';
  }

}
