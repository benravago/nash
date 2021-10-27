package es.runtime;

import java.util.Map;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

import java.lang.invoke.MethodType;

import es.codegen.CompileUnit;
import es.codegen.FunctionSignature;
import es.codegen.types.Type;
import es.ir.FunctionNode;

/**
 * Class that contains information allowing us to look up a method handle implementing a JavaScript function from a generated class.
 * This is used both for code coming from codegen and for persistent serialized code.
 */
public final class FunctionInitializer implements Serializable {

  private final String className;
  private final MethodType methodType;
  private final int flags;
  private transient Map<Integer, Type> invalidatedProgramPoints;
  private transient Class<?> code;

  private static final long serialVersionUID = -5420835725902966692L;

  /**
   * Constructor.
   *
   * @param functionNode the function node
   */
  public FunctionInitializer(FunctionNode functionNode) {
    this(functionNode, null);
  }

  /**
   * Constructor.
   *
   * @param functionNode the function node
   * @param invalidatedProgramPoints invalidated program points
   */
  public FunctionInitializer(FunctionNode functionNode, Map<Integer, Type> invalidatedProgramPoints) {
    this.className = functionNode.getCompileUnit().getUnitClassName();
    this.methodType = new FunctionSignature(functionNode).getMethodType();
    this.flags = functionNode.getFlags();
    this.invalidatedProgramPoints = invalidatedProgramPoints;
    var cu = functionNode.getCompileUnit();
    if (cu != null) {
      this.code = cu.getCode();
    }
    assert className != null;
  }

  /**
   * Returns the name of the class implementing the function.
   * @return the class name
   */
  public String getClassName() {
    return className;
  }

  /**
   * Returns the type of the method implementing the function.
   * @return the method type
   */
  public MethodType getMethodType() {
    return methodType;
  }

  /**
   * Returns the function flags.
   * @return function flags
   */
  public int getFlags() {
    return flags;
  }

  /**
   * Returns the class implementing the function.
   * @return the class
   */
  public Class<?> getCode() {
    return code;
  }

  /**
   * Set the class implementing the function
   * @param code the class
   */
  void setCode(Class<?> code) {
    // Make sure code has not been set and has expected class name
    if (this.code != null) {
      throw new IllegalStateException("code already set");
    }
    assert className.equals(code.getTypeName().replace('.', '/')) : "unexpected class name";
    this.code = code;
  }

  /**
   * Returns the map of invalidated program points.
   * @return invalidated program points
   */
  public Map<Integer, Type> getInvalidatedProgramPoints() {
    return invalidatedProgramPoints;
  }

  void writeObject(ObjectOutputStream out) throws IOException {
    out.defaultWriteObject();
    Type.writeTypeMap(invalidatedProgramPoints, out);
  }

  void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException {
    in.defaultReadObject();
    invalidatedProgramPoints = Type.readTypeMap(in);
  }

}
