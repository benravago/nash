package es.codegen.types;

/**
 * This is a numeric type, i.e. NUMBER, LONG, INT, INT32.
 */
public abstract class NumericType extends Type implements BytecodeNumericOps {

  /**
   * Constructor
   *
   * @param name   name of type
   * @param type  Java class used to represent type
   * @param weight weight of type
   * @param slots  number of bytecode slots this type takes up
   */
  protected NumericType(String name, Class<?> type, int weight, int slots) {
    super(name, type, weight, slots);
  }

  private static final long serialVersionUID = 1;
}
