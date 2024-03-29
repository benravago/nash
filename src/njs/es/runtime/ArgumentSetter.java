package es.runtime;

import static es.codegen.CompilerConstants.staticCallNoLookup;

import es.codegen.CompilerConstants.Call;

/**
 * A class with static helper methods invoked from generated bytecode for setting values of parameters of variable-arity functions.
 */
public final class ArgumentSetter {

  /** Method handle for setting a function argument at a given index in an arguments object. Used from generated bytecode */
  public static final Call SET_ARGUMENT = staticCallNoLookup(ArgumentSetter.class, "setArgument", void.class, Object.class, ScriptObject.class, int.class);

  /** Method handle for setting a function argument at a given index in an arguments array. Used from generated bytecode */
  public static final Call SET_ARRAY_ELEMENT = staticCallNoLookup(ArgumentSetter.class, "setArrayElement", void.class, Object.class, Object[].class, int.class);

  /**
   * Used from generated bytecode to invoke {@link ScriptObject#setArgument(int, Object)} without having to reorder the arguments on the stack.
   * When we're generating a store into the argument, we first have the value on the stack, and only afterwards load the target object and the index.
   * @param value the value to write at the given argument index.
   * @param arguments the arguments object that we're writing the value to
   * @param key the index of the argument
   */
  public static void setArgument(Object value, ScriptObject arguments, int key) {
    arguments.setArgument(key, value);
  }

  /**
   * Used from generated bytecode to set a variable arity parameter - an array element - without having to reorder the arguments on the stack.
   * When we're generating a store into the array, we first have the value on the stack, and only afterwards load the target array and the index.
   * @param value the value to write at the given argument index.
   * @param arguments the arguments array that we're writing the value to
   * @param key the index of the argument
   */
  public static void setArrayElement(Object value, Object[] arguments, int key) {
    arguments[key] = value;
  }

}
