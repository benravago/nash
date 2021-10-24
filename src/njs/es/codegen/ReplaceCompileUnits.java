package es.codegen;

import java.util.ArrayList;
import java.util.List;

import es.ir.CompileUnitHolder;
import es.ir.FunctionNode;
import es.ir.LiteralNode;
import es.ir.LiteralNode.ArrayLiteralNode;
import es.ir.Node;
import es.ir.ObjectNode;
import es.ir.Splittable;
import es.ir.visitor.SimpleNodeVisitor;

/**
 * Base class for a node visitor that replaces {@link CompileUnit}s in {@link CompileUnitHolder}s.
 */
abstract class ReplaceCompileUnits extends SimpleNodeVisitor {

  /**
   * Override to provide a replacement for an old compile unit.
   * @param oldUnit the old compile unit to replace
   * @return the compile unit's replacement.
   */
  abstract CompileUnit getReplacement(CompileUnit oldUnit);

  CompileUnit getExistingReplacement(CompileUnitHolder node) {
    var oldUnit = node.getCompileUnit();
    assert oldUnit != null;
    var newUnit = getReplacement(oldUnit);
    assert newUnit != null;
    return newUnit;
  }

  @Override
  public Node leaveFunctionNode(FunctionNode node) {
    return node.setCompileUnit(lc, getExistingReplacement(node));
  }

  @Override
  public Node leaveLiteralNode(LiteralNode<?> node) {
    if (node instanceof ArrayLiteralNode aln) {
      if (aln.getSplitRanges() == null) {
        return node;
      }
      var newArrayUnits = new ArrayList<Splittable.SplitRange>();
      for (var au : aln.getSplitRanges()) {
        newArrayUnits.add(new Splittable.SplitRange(getExistingReplacement(au), au.getLow(), au.getHigh()));
      }
      return aln.setSplitRanges(lc, newArrayUnits);
    }
    return node;
  }

  @Override
  public Node leaveObjectNode(ObjectNode objectNode) {
    var ranges = objectNode.getSplitRanges();
    if (ranges != null) {
      var newRanges = new ArrayList<Splittable.SplitRange>();
      for (var range : ranges) {
        newRanges.add(new Splittable.SplitRange(getExistingReplacement(range), range.getLow(), range.getHigh()));
      }
      return objectNode.setSplitRanges(lc, newRanges);
    }
    return super.leaveObjectNode(objectNode);
  }

}
