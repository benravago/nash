package es.runtime;

import java.io.NotSerializableException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import es.codegen.types.Type;

/**
 * This exception is thrown from an optimistic operation, e.g. an integer add, that was to optimistic for what really took place.
 * Typically things like trying to get an array element that we want to be an int, and it was a double, and an int add that actually overflows and needs a double for the representation
 */
public final class UnwarrantedOptimismException extends RuntimeException {

  /** Denotes an invalid program point */
  public static final int INVALID_PROGRAM_POINT = -1;

  /** The value for the first ordinary program point */
  public static final int FIRST_PROGRAM_POINT = 1;

  private Object returnValue;
  private final int programPoint;
  private final Type returnType;

  /**
   * Constructor without explicit return type.
   * The return type is determined statically from the class of the return value, and only canonical internal number representations are recognized.
   * Use {@link #createNarrowest} if you want to handle float and long values as numbers instead of objects.
   * @param returnValue actual return value from the too narrow operation
   * @param programPoint program point where unwarranted optimism was detected
   */
  public UnwarrantedOptimismException(Object returnValue, int programPoint) {
    this(returnValue, programPoint, getReturnType(returnValue));
  }

  /**
   * Check if a program point is valid.
   * @param programPoint the program point
   * @return true if valid
   */
  public static boolean isValid(int programPoint) {
    assert programPoint >= INVALID_PROGRAM_POINT;
    return programPoint != INVALID_PROGRAM_POINT;
  }

  private static Type getReturnType(Object v) {
    if (v instanceof Double) {
      return Type.NUMBER;
    }
    assert !(v instanceof Integer) : v + " is an int"; // Can't have an unwarranted optimism exception with int
    return Type.OBJECT;
  }

  /**
   * Constructor with explicit return value type.
   * @param returnValue actual return value from the too narrow operation
   * @param programPoint program point where unwarranted optimism was detected
   * @param returnType type of the returned value. Used to disambiguate the return type. E.g. an {@code ObjectArrayData} might return a {@link Double} for a particular element getter, but still throw this exception even if the call site can accept a double, since the array's type is actually {@code Type#OBJECT}. In this case, it must explicitly use this constructor to indicate its values are to be considered {@code Type#OBJECT} and not {@code Type#NUMBER}.
   */
  public UnwarrantedOptimismException(Object returnValue, int programPoint, Type returnType) {
    super("", null, false, false);
    assert returnType != Type.OBJECT || returnValue == null || !Type.typeFor(returnValue.getClass()).isNumeric();
    assert returnType != Type.INT;
    this.returnValue = returnValue;
    this.programPoint = programPoint;
    this.returnType = returnType;
  }

  /**
   * Create an {@code UnwarrantedOptimismException} with the given return value and program point, narrowing the type to {@code number} if the value is a float or a long that can be represented as double.
   * @param returnValue the return value
   * @param programPoint the program point
   * @return the exception
   */
  public static UnwarrantedOptimismException createNarrowest(Object returnValue, int programPoint) {
    return (returnValue instanceof Float || (returnValue instanceof Long l && JSType.isRepresentableAsDouble(l)))
      ? new UnwarrantedOptimismException(((Number) returnValue).doubleValue(), programPoint, Type.NUMBER)
      : new UnwarrantedOptimismException(returnValue, programPoint);
  }

  /**
   * Get the return value. This is a destructive readout, after the method is invoked the return value is null'd out.
   * @return return value
   */
  public Object getReturnValueDestructive() {
    var retval = returnValue;
    returnValue = null;
    return retval;
  }

  Object getReturnValueNonDestructive() {
    return returnValue;
  }

  /**
   * Get the return type
   * @return return type
   */
  public Type getReturnType() {
    return returnType;
  }

  /**
   * Does this exception refer to an invalid program point? This might be OK if
   * we throw it, e.g. from a parameter guard
   * @return true if invalid program point specified
   */
  public boolean hasInvalidProgramPoint() {
    return programPoint == INVALID_PROGRAM_POINT;
  }

  /**
   * Get the program point
   * @return the program point
   */
  public int getProgramPoint() {
    return programPoint;
  }

  /**
   * Return a new {@code UnwarrantedOptimismException} with the same return value and the new program point.
   * @param newProgramPoint new new program point
   * @return the new exception instance
   */
  public UnwarrantedOptimismException replaceProgramPoint(int newProgramPoint) {
    assert isValid(newProgramPoint);
    return new UnwarrantedOptimismException(returnValue, newProgramPoint, returnType);
  }

  @Override
  public String getMessage() {
    return "UNWARRANTED OPTIMISM: [returnValue=" + returnValue
      + " (class=" + (returnValue == null ? "null" : returnValue.getClass().getSimpleName())
      + (hasInvalidProgramPoint() ? " <invalid program point>" : (" @ program point #" + programPoint))
      + ")]";
  }

  private void writeObject(ObjectOutputStream out) throws NotSerializableException {
    throw new NotSerializableException(getClass().getName());
  }
  private void readObject(ObjectInputStream in) throws NotSerializableException {
    throw new NotSerializableException(getClass().getName());
  }
}
