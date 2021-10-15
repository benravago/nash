package es.codegen.types;

/**
 * This class represents a numeric type that can be used for bit operations.
 */
public abstract class BitwiseType extends NumericType implements BytecodeBitwiseOps {

  /**
   * Constructor
   *
   * @param name   name of type
   * @param type  Java class used to represent type
   * @param weight weight of type
   * @param slots  number of bytecode slots this type takes up
   */
  protected BitwiseType(String name, Class<?> type, int weight, int slots) {
    super(name, type, weight, slots);
  }

  private static final long serialVersionUID = 1L;
}
