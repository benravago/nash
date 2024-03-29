package es.runtime.events;

import java.util.logging.Level;
import es.runtime.RewriteException;

/**
 * Subclass of runtime event for {@link RewriteException}.
 *
 * In order not to leak memory, RewriteExceptions get their return value destroyed and nulled out during recompilation.
 * If we are running with event logging enabled, we need to retain the returnValue, hence the extra field
 */
public final class RecompilationEvent extends RuntimeEvent<RewriteException> {

  private final Object returnValue;

  /**
   * Constructor
   *
   * @param level            logging level
   * @param rewriteException rewriteException wrapped by this RuntimEvent
   * @param returnValue      rewriteException return value
   *   - as we don't want to make {@code RewriteException.getReturnValueNonDestructive()} public,
   *     we pass it as an extra parameter, rather than querying the getter from another package.
   */
  public RecompilationEvent(Level level, RewriteException rewriteException, Object returnValue) {
    super(level, rewriteException);
    // TODO: review this
    // assert Context.getContext().getLogger(RecompilableScriptFunctionData.class).isEnabled() :
    // "Unit test/instrumentation purpose only: RecompilationEvent instances should not be created without '--log=recompile', or we will leak memory in the general case";
    this.returnValue = returnValue;
  }

  /**
   * Get the preserved return value for the RewriteException
   * @return return value
   */
  public Object getReturnValue() {
    return returnValue;
  }

}
