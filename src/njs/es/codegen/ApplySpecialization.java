package es.codegen;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import java.net.URL;

import java.lang.invoke.MethodType;

import es.ir.AccessNode;
import es.ir.CallNode;
import es.ir.Expression;
import es.ir.FunctionNode;
import es.ir.IdentNode;
import es.ir.Node;
import es.ir.visitor.SimpleNodeVisitor;
import es.objects.Global;
import es.runtime.Context;
import es.runtime.logging.DebugLogger;
import es.runtime.logging.Loggable;
import es.runtime.logging.Logger;
import es.runtime.options.Options;
import static es.codegen.CompilerConstants.*;

/**
 * An optimization that attempts to turn applies into calls.
 *
 * This pattern is very common for fake class instance creation, and apply introduces expensive args collection and boxing
 * <pre>
 * var Class = {
 *     create: function() {
 *         return function() { //vararg
 *             this.initialize.apply(this, arguments);
 *         }
 *     }
 * };
 *
 * Color = Class.create();
 *
 * Color.prototype = {
 *    red: 0, green: 0, blue: 0,
 *    initialize: function(r,g,b) {
 *        this.red = r;
 *        this.green = g;
 *        this.blue = b;
 *    }
 * }
 *
 * new Color(17, 47, 11);
 * </pre>
 */
@Logger(name = "apply2call")
public final class ApplySpecialization extends SimpleNodeVisitor implements Loggable {

  private static final boolean USE_APPLY2CALL = Options.getBooleanProperty("nashorn.apply2call", true);

  private final DebugLogger log;

  private final Compiler compiler;

  private final Set<Integer> changed = new HashSet<>();

  private final Deque<List<IdentNode>> explodedArguments = new ArrayDeque<>();

  private final Deque<MethodType> callSiteTypes = new ArrayDeque<>();

  private static final String ARGUMENTS = ARGUMENTS_VAR.symbolName();

  /**
   * Apply specialization optimization.
   * Try to explode arguments and call applies as calls if they just pass on the "arguments" array and "arguments" doesn't escape.
   * @param compiler compiler
   */
  public ApplySpecialization(Compiler compiler) {
    this.compiler = compiler;
    this.log = initLogger(compiler.getContext());
  }

  @Override
  public DebugLogger getLogger() {
    return log;
  }

  @Override
  public DebugLogger initLogger(Context context) {
    return context.getLogger(this.getClass());
  }

  @SuppressWarnings("serial")
  static class TransformFailedException extends RuntimeException {
    TransformFailedException(FunctionNode fn, String message) {
      super(massageURL(fn.getSource().getURL()) + '.' + fn.getName() + " => " + message, null, false, false);
    }
  }

  @SuppressWarnings("serial")
  static class AppliesFoundException extends RuntimeException {
    AppliesFoundException() {
      super("applies_found", null, false, false);
    }
  }

  private static final AppliesFoundException HAS_APPLIES = new AppliesFoundException();

  boolean hasApplies(FunctionNode functionNode) {
    try {
      functionNode.accept(new SimpleNodeVisitor() {
        @Override
        public boolean enterFunctionNode(FunctionNode fn) {
          return fn == functionNode;
        }
        @Override
        public boolean enterCallNode(CallNode callNode) {
          if (isApply(callNode)) {
            throw HAS_APPLIES;
          }
          return true;
        }
      });
    } catch (AppliesFoundException e) {
      return true;
    }
    log.fine("There are no applies in ", DebugLogger.quote(functionNode.getName()), " - nothing to do.");
    return false; // no applies
  }

  /**
   * Arguments may only be used as args to the apply; everything else is disqualified.
   * We cannot control arguments if they escape from the method and go into an unknown scope, thus we are conservative and treat any access to arguments outside the apply call as a case of "we cannot apply the optimization".
   */
  static void checkValidTransform(FunctionNode functionNode) {
    var argumentsFound = new HashSet<Expression>();
    var stack = new ArrayDeque<Set<Expression>>();
    // ensure that arguments is only passed as arg to apply
    functionNode.accept(new SimpleNodeVisitor() {
      boolean isCurrentArg(Expression expr) {
        return !stack.isEmpty() && stack.peek().contains(expr); //args to current apply call
      }
      boolean isArguments(Expression expr) {
        if (expr instanceof IdentNode ident && ARGUMENTS.equals(ident.getName())) {
          argumentsFound.add(expr);
          return true;
        }
        return false;
      }
      boolean isParam(String name) {
        for (var param : functionNode.getParameters()) {
          if (param.getName().equals(name)) {
            return true;
          }
        }
        return false;
      }

      @Override
      public Node leaveIdentNode(IdentNode identNode) {
        if (isParam(identNode.getName())) {
          throw new TransformFailedException(lc.getCurrentFunction(), "parameter: " + identNode.getName());
        }
        // it's OK if 'argument' occurs as the current argument of an apply
        if (isArguments(identNode) && !isCurrentArg(identNode)) {
          throw new TransformFailedException(lc.getCurrentFunction(), "is 'arguments': " + identNode.getName());
        }
        return identNode;
      }

      @Override
      public boolean enterCallNode(CallNode callNode) {
        var callArgs = new HashSet<Expression>();
        if (isApply(callNode)) {
          var argList = callNode.getArgs();
          if (argList.size() != 2 || !isArguments(argList.get(argList.size() - 1))) {
            throw new TransformFailedException(lc.getCurrentFunction(), "argument pattern not matched: " + argList);
          }
          callArgs.addAll(callNode.getArgs());
        }
        stack.push(callArgs);
        return true;
      }

      @Override
      public Node leaveCallNode(CallNode callNode) {
        stack.pop();
        return callNode;
      }
    });
  }

  @Override
  public boolean enterCallNode(CallNode callNode) {
    return !explodedArguments.isEmpty();
  }

  @Override
  public Node leaveCallNode(CallNode callNode) {
    // apply needs to be a global symbol or we don't allow it
    var newParams = explodedArguments.peek();
    if (isApply(callNode)) {
      var newArgs = new ArrayList<Expression>();
      for (var arg : callNode.getArgs()) {
        if (arg instanceof IdentNode ident && ARGUMENTS.equals(ident.getName())) {
          newArgs.addAll(newParams);
        } else {
          newArgs.add(arg);
        }
      }
      changed.add(lc.getCurrentFunction().getId());
      var newCallNode = callNode.setArgs(newArgs).setIsApplyToCall();
      if (log.isEnabled()) {
        log.fine("Transformed ", callNode, " from apply to call => ", newCallNode, " in ", DebugLogger.quote(lc.getCurrentFunction().getName()));
      }
      return newCallNode;
    }
    return callNode;
  }

  void pushExplodedArgs(FunctionNode functionNode) {
    var start = 0;
    var actualCallSiteType = compiler.getCallSiteType(functionNode);
    if (actualCallSiteType == null) {
      throw new TransformFailedException(lc.getCurrentFunction(), "No callsite type");
    }
    assert actualCallSiteType.parameterType(actualCallSiteType.parameterCount() - 1) != Object[].class : "error vararg callsite passed to apply2call " + functionNode.getName() + " " + actualCallSiteType;
    var ptm = compiler.getTypeMap();
    if (ptm.needsCallee()) {
      start++;
    }
    start++; // we always use this
    assert functionNode.getNumOfParams() == 0 : "apply2call on function with named paramaters!";
    var newParams = new ArrayList<IdentNode>();
    var to = actualCallSiteType.parameterCount() - start;
    for (var i = 0; i < to; i++) {
      newParams.add(new IdentNode(functionNode.getToken(), functionNode.getFinish(), EXPLODED_ARGUMENT_PREFIX.symbolName() + (i)));
    }
    callSiteTypes.push(actualCallSiteType);
    explodedArguments.push(newParams);
  }

  @Override
  public boolean enterFunctionNode(FunctionNode functionNode) {
    // Cheap tests first
    if (!( // is the transform globally enabled?
          USE_APPLY2CALL
           // Are we compiling lazily? We can't known the number and types of the actual parameters at the caller when compiling eagerly, so this only works with on-demand compilation.
          && compiler.isOnDemandCompilation()
           // Does the function even reference the "arguments" identifier (without redefining it)? If not, it trivially can't have an expression of form "f.apply(self, arguments)" that this transform is targeting.
          && functionNode.needsArguments()
           // Does the function have eval? If so, it can arbitrarily modify arguments so we can't touch it.
          && !functionNode.hasEval()
           // Finally, does the function declare any parameters explicitly? We don't support that. It could be done, but has some complications. Therefore only a function with no explicit parameters is considered.
          && functionNode.getNumOfParams() == 0)) {
      return false;
    }
    if (!Global.isBuiltinFunctionPrototypeApply()) {
      log.fine("Apply transform disabled: apply/call overridden");
      assert !Global.isBuiltinFunctionPrototypeCall() : "call and apply should have the same SwitchPoint";
      return false;
    }
    if (!hasApplies(functionNode)) {
      return false;
    }
    if (log.isEnabled()) {
      log.info("Trying to specialize apply to call in '", functionNode.getName(), "' params=", functionNode.getParameters(), " id=", functionNode.getId(), " source=", massageURL(functionNode.getSource().getURL()));
    }
    try {
      checkValidTransform(functionNode);
      pushExplodedArgs(functionNode);
    } catch (TransformFailedException e) {
      log.info("Failure: ", e.getMessage());
      return false;
    }
    return true;
  }

  /**
   * Try to do the apply to call transformation
   * @return true if successful, false otherwise
   */
  @Override
  public Node leaveFunctionNode(FunctionNode functionNode) {
    var newFunctionNode = functionNode;
    var functionName = newFunctionNode.getName();
    if (changed.contains(newFunctionNode.getId())) {
      newFunctionNode = newFunctionNode.clearFlag(lc, FunctionNode.USES_ARGUMENTS). setFlag(lc, FunctionNode.HAS_APPLY_TO_CALL_SPECIALIZATION). setParameters(lc, explodedArguments.peek());
      if (log.isEnabled()) {
        log.info("Success: ", massageURL(newFunctionNode.getSource().getURL()), '.', functionName, "' id=", newFunctionNode.getId(), " params=", callSiteTypes.peek());
      }
    }
    callSiteTypes.pop();
    explodedArguments.pop();
    return newFunctionNode;
  }

  static boolean isApply(CallNode callNode) {
    var f = callNode.getFunction();
    return f instanceof AccessNode a && "apply".equals(a.getProperty());
  }

  static String massageURL(URL url) {
    if (url == null) {
      return "<null>";
    }
    var str = url.toString();
    var slash = str.lastIndexOf('/');
    return (slash == -1) ? str : str.substring(slash + 1);
  }

}
