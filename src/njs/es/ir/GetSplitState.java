package es.ir;

import es.codegen.CompilerConstants;
import es.codegen.types.Type;
import es.ir.annotations.Ignore;
import es.ir.visitor.NodeVisitor;
import es.runtime.Scope;

/**
 * Synthetic AST node that represents loading of the scope object and invocation of the {@link Scope#getSplitState()} method on it.
 *
 * It has no JavaScript source representation and only occurs in synthetic functions created by the split-into-functions transformation.
 */
public final class GetSplitState extends Expression {

  // The sole instance of this AST node.
  @Ignore
  public final static GetSplitState INSTANCE = new GetSplitState();

  GetSplitState() {
    super(NO_TOKEN, NO_FINISH);
  }

  @Override
  public Type getType() {
    return Type.INT;
  }

  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return visitor.enterGetSplitState(this) ? visitor.leaveGetSplitState(this) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    if (printType) {
      sb.append("{I}");
    }
    sb.append(CompilerConstants.SCOPE.symbolName()).append('.').append(Scope.GET_SPLIT_STATE.name()).append("()");
  }

  Object readResolve() {
    return INSTANCE;
  }

  private static final long serialVersionUID = 1;
}
