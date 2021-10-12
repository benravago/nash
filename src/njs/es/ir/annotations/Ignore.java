package es.ir.annotations;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * This signifies a node that should be ignored in traversal,
 * for example a reference to an already traversed node,
 * or various metadata that has no actual IR representations, but yet reside in the node.
 *
 * @see ASTWriter
 * @see es.ir.Node
 */
@Retention(value = RetentionPolicy.RUNTIME)
public @interface Ignore {
  // Empty
}
