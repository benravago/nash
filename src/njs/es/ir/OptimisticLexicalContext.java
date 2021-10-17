package es.ir;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Deque;
import java.util.List;
import es.codegen.types.Type;

/**
 * Lexical context that keeps track of optimistic assumptions (if any) made during code generation.
 * Used from Attr and FinalizeTypes
 */
public class OptimisticLexicalContext extends LexicalContext {

  private final boolean isEnabled;

  public class Assumption {

    Symbol symbol;
    Type type;

    Assumption(Symbol symbol, Type type) {
      this.symbol = symbol;
      this.type = type;
    }

    @Override
    public String toString() {
      return symbol.getName() + "=" + type;
    }
  }

  // Optimistic assumptions that could be made per function
  private final Deque<List<Assumption>> optimisticAssumptions = new ArrayDeque<>();

  /**
   * Constructor
   * @param isEnabled are optimistic types enabled?
   */
  public OptimisticLexicalContext(boolean isEnabled) {
    super();
    this.isEnabled = isEnabled;
  }

  /**
   * Are optimistic types enabled
   * @return true if optimistic types
   */
  public boolean isEnabled() {
    return isEnabled;
  }

  /**
   * Log an optimistic assumption during codegen
   * TODO : different parameters and more info about the assumption for future profiling needs
   * @param symbol symbol
   * @param type   type
   */
  public void logOptimisticAssumption(Symbol symbol, Type type) {
    if (isEnabled) {
      var peek = optimisticAssumptions.peek();
      peek.add(new Assumption(symbol, type));
    }
  }

  /**
   * Get the list of optimistic assumptions made
   * @return optimistic assumptions
   */
  public List<Assumption> getOptimisticAssumptions() {
    return Collections.unmodifiableList(optimisticAssumptions.peek());
  }

  /**
   * Does this method have optimistic assumptions made during codegen?
   * @return true if optimistic assumptions were made
   */
  public boolean hasOptimisticAssumptions() {
    return !optimisticAssumptions.isEmpty() && !getOptimisticAssumptions().isEmpty();
  }

  @Override
  public <T extends LexicalContextNode> T push(T node) {
    if (isEnabled) {
      if (node instanceof FunctionNode) {
        optimisticAssumptions.push(new ArrayList<>());
      }
    }
    return super.push(node);
  }

  @Override
  public <T extends Node> T pop(T node) {
    var popped = super.pop(node);
    if (isEnabled) {
      if (node instanceof FunctionNode) {
        optimisticAssumptions.pop();
      }
    }
    return popped;
  }

}
