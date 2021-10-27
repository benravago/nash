package es.runtime;

/**
 * Interface for getting and setting properties from script objects.
 * This can be a plugin point for e.g. tagged values or alternative array property getters.
 * The interface is engineered with the combinatorially exhaustive combination of types by purpose, for speed, as currently HotSpot is not good enough at removing boxing.
 */
public interface PropertyAccess {

  /**
   * Get the value for a given key and return it as an int
   * @param key the key
   * @param programPoint or INVALID_PROGRAM_POINT if pessimistic
   * @return the value
   */
  int getInt(Object key, int programPoint);

  /**
   * Get the value for a given key and return it as an int
   * @param key the key
   * @param programPoint or INVALID_PROGRAM_POINT if pessimistic
   * @return the value
   */
  int getInt(double key, int programPoint);

  /**
   * Get the value for a given key and return it as an int
   * @param key the key
   * @param programPoint or INVALID_PROGRAM_POINT if pessimistic
   * @return the value
   */
  int getInt(int key, int programPoint);

  /**
   * Get the value for a given key and return it as a double
   * @param key the key
   * @param programPoint or INVALID_PROGRAM_POINT if pessimistic
   * @return the value
   */
  double getDouble(Object key, int programPoint);

  /**
   * Get the value for a given key and return it as a double
   * @param key the key
   * @param programPoint or INVALID_PROGRAM_POINT if pessimistic
   * @return the value
   */
  double getDouble(double key, int programPoint);

  /**
   * Get the value for a given key and return it as a double
   * @param key the key
   * @param programPoint or INVALID_PROGRAM_POINT if pessimistic
   * @return the value
   */
  double getDouble(int key, int programPoint);

  /**
   * Get the value for a given key and return it as an Object
   * @param key the key
   * @return the value
   */
  Object get(Object key);

  /**
   * Get the value for a given key and return it as an Object
   * @param key the key
   * @return the value
   */
  Object get(double key);

  /**
   * Get the value for a given key and return it as an Object
   * @param key the key
   * @return the value
   */
  Object get(int key);

  /**
   * Set the value of a given key
   * @param key     the key
   * @param value   the value
   * @param flags   call site flags
   */
  void set(Object key, int value, int flags);

  /**
   * Set the value of a given key
   * @param key     the key
   * @param value   the value
   * @param flags   call site flags
   */
  void set(Object key, double value, int flags);

  /**
   * Set the value of a given key
   * @param key     the key
   * @param value   the value
   * @param flags   call site flags
   */
  void set(Object key, Object value, int flags);

  /**
   * Set the value of a given key
   * @param key     the key
   * @param value   the value
   * @param flags   call site flags
   */
  void set(double key, int value, int flags);

  /**
   * Set the value of a given key
   * @param key     the key
   * @param value   the value
   * @param flags   call site flags
   */
  void set(double key, double value, int flags);

  /**
   * Set the value of a given key
   * @param key     the key
   * @param value   the value
   * @param flags   call site flags
   */
  void set(double key, Object value, int flags);

  /**
   * Set the value of a given key
   * @param key     the key
   * @param value   the value
   * @param flags   call site flags
   */
  void set(int key, int value, int flags);

  /**
   * Set the value of a given key
   * @param key     the key
   * @param value   the value
   * @param flags   call site flags
   */
  void set(int key, double value, int flags);

  /**
   * Set the value of a given key
   * @param key     the key
   * @param value   the value
   * @param flags   call site flags
   */
  void set(int key, Object value, int flags);

  /**
   * Check if the given key exists anywhere in the proto chain
   * @param key the key
   * @return true if key exists
   */
  boolean has(Object key);

  /**
   * Check if the given key exists anywhere in the proto chain
   * @param key the key
   * @return true if key exists
   */
  boolean has(int key);

  /**
   * Check if the given key exists anywhere in the proto chain
   * @param key the key
   * @return true if key exists
   */
  boolean has(double key);

  /**
   * Check if the given key exists directly in the implementor
   * @param key the key
   * @return true if key exists
   */
  boolean hasOwnProperty(Object key);

  /**
   * Check if the given key exists directly in the implementor
   * @param key the key
   * @return true if key exists
   */
  boolean hasOwnProperty(int key);

  /**
   * Check if the given key exists directly in the implementor
   * @param key the key
   * @return true if key exists
   */
  boolean hasOwnProperty(double key);

  /**
   * Delete a property with the given key from the implementor
   * @param key    the key
   * @return true if deletion succeeded, false otherwise
   */
  boolean delete(int key);

  /**
   * Delete a property with the given key from the implementor
   * @param key    the key
   * @return true if deletion succeeded, false otherwise
   */
  boolean delete(double key);

  /**
   * Delete a property with the given key from the implementor
   * @param key    the key
   * @return true if deletion succeeded, false otherwise
   */
  boolean delete(Object key);

}
