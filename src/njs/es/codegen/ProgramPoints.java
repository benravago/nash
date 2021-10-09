package es.codegen;

import static es.runtime.UnwarrantedOptimismException.FIRST_PROGRAM_POINT;
import static es.runtime.linker.NashornCallSiteDescriptor.MAX_PROGRAM_POINT_VALUE;

import java.util.HashSet;
import java.util.Set;
import es.util.IntDeque;
import es.ir.AccessNode;
import es.ir.BinaryNode;
import es.ir.CallNode;
import es.ir.Expression;
import es.ir.FunctionNode;
import es.ir.IdentNode;
import es.ir.IndexNode;
import es.ir.Node;
import es.ir.Optimistic;
import es.ir.UnaryNode;
import es.ir.VarNode;
import es.ir.visitor.SimpleNodeVisitor;

/**
 * Find program points in the code that are needed for optimistic assumptions
 */
class ProgramPoints extends SimpleNodeVisitor {

  private final IntDeque nextProgramPoint = new IntDeque();
  private final Set<Node> noProgramPoint = new HashSet<>();

  private int next() {
    final int next = nextProgramPoint.getAndIncrement();
    if (next > MAX_PROGRAM_POINT_VALUE) {
      throw new AssertionError("Function has more than " + MAX_PROGRAM_POINT_VALUE + " program points");
    }
    return next;
  }

  @Override
  public boolean enterFunctionNode(final FunctionNode functionNode) {
    nextProgramPoint.push(FIRST_PROGRAM_POINT);
    return true;
  }

  @Override
  public Node leaveFunctionNode(final FunctionNode functionNode) {
    nextProgramPoint.pop();
    return functionNode;
  }

  private Expression setProgramPoint(final Optimistic optimistic) {
    if (noProgramPoint.contains(optimistic)) {
      return (Expression) optimistic;
    }
    return (Expression) (optimistic.canBeOptimistic() ? optimistic.setProgramPoint(next()) : optimistic);
  }

  @Override
  public boolean enterVarNode(final VarNode varNode) {
    noProgramPoint.add(varNode.getName());
    return true;
  }

  @Override
  public boolean enterIdentNode(final IdentNode identNode) {
    if (identNode.isInternal()) {
      noProgramPoint.add(identNode);
    }
    return true;
  }

  @Override
  public Node leaveIdentNode(final IdentNode identNode) {
    if (identNode.isPropertyName()) {
      return identNode;
    }
    return setProgramPoint(identNode);
  }

  @Override
  public Node leaveCallNode(final CallNode callNode) {
    return setProgramPoint(callNode);
  }

  @Override
  public Node leaveAccessNode(final AccessNode accessNode) {
    return setProgramPoint(accessNode);
  }

  @Override
  public Node leaveIndexNode(final IndexNode indexNode) {
    return setProgramPoint(indexNode);
  }

  @Override
  public Node leaveBinaryNode(final BinaryNode binaryNode) {
    return setProgramPoint(binaryNode);
  }

  @Override
  public Node leaveUnaryNode(final UnaryNode unaryNode) {
    return setProgramPoint(unaryNode);
  }
}
