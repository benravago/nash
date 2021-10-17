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
   * @return get the assignment destination node
   */
  D getAssignmentDest();

  /**
   * Get the assignment source
   * @return get the assignment source node
   */
  Expression getAssignmentSource();

  /**
   * Set assignment destination node.
   * @param n the assignment destination node.
   * @return a node equivalent to this one except for the requested change.
   */
  Node setAssignmentDest(D n);

}
