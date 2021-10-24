package es.codegen;

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
import static es.runtime.UnwarrantedOptimismException.FIRST_PROGRAM_POINT;
import static es.runtime.linker.NashornCallSiteDescriptor.MAX_PROGRAM_POINT_VALUE;

/**
 * Find program points in the code that are needed for optimistic assumptions
 */
class ProgramPoints extends SimpleNodeVisitor {

  private final IntDeque nextProgramPoint = new IntDeque();
  private final Set<Node> noProgramPoint = new HashSet<>();

  int next() {
    var next = nextProgramPoint.getAndIncrement();
    if (next > MAX_PROGRAM_POINT_VALUE) {
      throw new AssertionError("Function has more than " + MAX_PROGRAM_POINT_VALUE + " program points");
    }
    return next;
  }

  @Override
  public boolean enterFunctionNode(FunctionNode functionNode) {
    nextProgramPoint.push(FIRST_PROGRAM_POINT);
    return true;
  }

  @Override
  public Node leaveFunctionNode(FunctionNode functionNode) {
    nextProgramPoint.pop();
    return functionNode;
  }

  Expression setProgramPoint(Optimistic optimistic) {
    return (noProgramPoint.contains(optimistic)) ? (Expression) optimistic : (Expression) (optimistic.canBeOptimistic() ? optimistic.setProgramPoint(next()) : optimistic);
  }

  @Override
  public boolean enterVarNode(VarNode varNode) {
    noProgramPoint.add(varNode.getName());
    return true;
  }

  @Override
  public boolean enterIdentNode(IdentNode identNode) {
    if (identNode.isInternal()) {
      noProgramPoint.add(identNode);
    }
    return true;
  }

  @Override
  public Node leaveIdentNode(IdentNode identNode) {
    return (identNode.isPropertyName()) ? identNode : setProgramPoint(identNode);
  }

  @Override
  public Node leaveCallNode(CallNode callNode) {
    return setProgramPoint(callNode);
  }

  @Override
  public Node leaveAccessNode(AccessNode accessNode) {
    return setProgramPoint(accessNode);
  }

  @Override
  public Node leaveIndexNode(IndexNode indexNode) {
    return setProgramPoint(indexNode);
  }

  @Override
  public Node leaveBinaryNode(BinaryNode binaryNode) {
    return setProgramPoint(binaryNode);
  }

  @Override
  public Node leaveUnaryNode(UnaryNode unaryNode) {
    return setProgramPoint(unaryNode);
  }

}
