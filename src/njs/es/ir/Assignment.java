package es.ir;

/**
 * Can a node be an assignment under certain circumstances?
 * Then it should implement this interface
 *
 * @param <D> the destination type
 */
public interface Assignment<D extends Expression> {

  /**
   * Get assignment destination
   *
   * @return get the assignment destination node
   */
  public D getAssignmentDest();

  /**
   * Get the assignment source
   *
   * @return get the assignment source node
   */
  public Expression getAssignmentSource();

  /**
   * Set assignment destination node.
   * @param n the assignment destination node.
   * @return a node equivalent to this one except for the requested change.
   */
  public Node setAssignmentDest(D n);
}
