package es.codegen;

import es.codegen.types.Type;

/**
 * Encapsulates the information for restoring the local state when continuing execution after a rewrite triggered by an optimistic assumption failure.
 *
 * An instance of this class is specific to a program point.
 */
public class LocalStateRestorationInfo {

  private final Type[] localVariableTypes;
  private final int[] stackLoads;

  LocalStateRestorationInfo(Type[] localVariableTypes, int[] stackLoads) {
    this.localVariableTypes = localVariableTypes;
    this.stackLoads = stackLoads;
  }

  /**
   * Returns the types of the local variables at the continuation of a program point.
   * @return the types of the local variables at the continuation of a program point.
   */
  public Type[] getLocalVariableTypes() {
    return localVariableTypes.clone();
  }

  /**
   * Returns the indices of local variables that need to be loaded on stack before jumping to the continuation of the program point.
   * @return the indices of local variables that need to be loaded on stack.
   */
  public int[] getStackLoads() {
    return stackLoads.clone();
  }

}
