package es.ir;

import java.io.Serializable;
import java.util.Collections;
import java.util.List;

import es.codegen.types.Type;
import es.ir.annotations.Ignore;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;
import static es.runtime.UnwarrantedOptimismException.INVALID_PROGRAM_POINT;

/**
 * IR representation for a function call.
 */
@Immutable
public final class CallNode extends LexicalContextExpression implements Optimistic {

  // Function identifier or function body.
  private final Expression function;

  // Call arguments.
  private final List<Expression> args;

  // Is this a "new" operation
  private static final int IS_NEW = 1 << 0;

  // Can this be a Function.call?
  private static final int IS_APPLY_TO_CALL = 1 << 1;

  private final int flags;

  private final int lineNumber;

  private final int programPoint;

  private final Type optimisticType;

  /**
   * Arguments to be passed to builtin {@code eval} function
   */
  public static class EvalArgs implements Serializable {

    private final List<Expression> args;

    // location string for the eval call
    private final String location;

    /**
     * Constructor
     *
     * @param args     arguments to eval
     * @param location location for the eval call
     */
    public EvalArgs(List<Expression> args, String location) {
      this.args = args;
      this.location = location;
    }

    /**
     * Return the code that is to be eval:ed by this eval function
     * @return code as an AST node
     */
    public List<Expression> getArgs() {
      return Collections.unmodifiableList(args);
    }

    EvalArgs setArgs(List<Expression> args) {
      return (this.args == args) ? this : new EvalArgs(args, location);
    }

    /**
     * Get the human readable location for this eval call
     * @return the location
     */
    public String getLocation() {
      return this.location;
    }
    
    private static final long serialVersionUID = 1;
  }

  /** arguments for 'eval' call. Non-null only if this call node is 'eval' */
  @Ignore
  private final EvalArgs evalArgs;

  /**
   * Constructors
   *
   * @param lineNumber line number
   * @param token      token
   * @param finish     finish
   * @param function   the function to call
   * @param args       args to the call
   * @param isNew      true if this is a constructor call with the "new" keyword
   */
  public CallNode(int lineNumber, long token, int finish, Expression function, List<Expression> args, boolean isNew) {
    super(token, finish);
    this.function = function;
    this.args = args;
    this.flags = isNew ? IS_NEW : 0;
    this.evalArgs = null;
    this.lineNumber = lineNumber;
    this.programPoint = INVALID_PROGRAM_POINT;
    this.optimisticType = null;
  }

  CallNode(CallNode callNode, Expression function, List<Expression> args, int flags, Type optimisticType, EvalArgs evalArgs, int programPoint) {
    super(callNode);
    this.lineNumber = callNode.lineNumber;
    this.function = function;
    this.args = args;
    this.flags = flags;
    this.evalArgs = evalArgs;
    this.programPoint = programPoint;
    this.optimisticType = optimisticType;
  }

  /**
   * Returns the line number.
   * @return the line number.
   */
  public int getLineNumber() {
    return lineNumber;
  }

  @Override
  public Type getType() {
    return optimisticType == null ? Type.OBJECT : optimisticType;
  }

  @Override
  public Optimistic setType(Type optimisticType) {
    return (this.optimisticType == optimisticType) ? this : new CallNode(this, function, args, flags, optimisticType, evalArgs, programPoint);
  }

  /**
   * Assist in IR navigation.
   * @param visitor IR navigating visitor.
   * @return node or replacement
   */
  @Override
  public Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor) {
    if (visitor.enterCallNode(this)) {
      var newCallNode = (CallNode) visitor.leaveCallNode(
        setFunction((Expression)function.accept(visitor))
        .setArgs(Node.accept(visitor, args))
        .setEvalArgs(evalArgs == null ? null : evalArgs.setArgs(Node.accept(visitor, evalArgs.getArgs())))
      );
      // Theoretically, we'd need to instead pass lc to every setter and do a replacement on each.
      // In practice, setType from TypeOverride can't accept a lc, and we don't necessarily want to go there now.
      if (this != newCallNode) {
        return Node.replaceInLexicalContext(lc, this, newCallNode);
      }
    }
    return this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    if (printType) {
      optimisticTypeToString(sb);
    }
    var fsb = new StringBuilder();
    function.toString(fsb, printType);
    if (isApplyToCall()) {
      sb.append(fsb.toString().replace("apply", "[apply => call]"));
    } else {
      sb.append(fsb);
    }
    sb.append('(');
    var first = true;
    for (var arg : args) {
      if (!first) {
        sb.append(", ");
      } else {
        first = false;
      }
      arg.toString(sb, printType);
    }
    sb.append(')');
  }

  /**
   * Get the arguments for the call
   * @return a list of arguments
   */
  public List<Expression> getArgs() {
    return Collections.unmodifiableList(args);
  }

  /**
   * Reset the arguments for the call
   * @param args new arguments list
   * @return new callnode, or same if unchanged
   */
  public CallNode setArgs(List<Expression> args) {
    return (this.args == args) ? this : new CallNode(this, function, args, flags, optimisticType, evalArgs, programPoint);
  }

  /**
   * If this call is an {@code eval} call, get its EvalArgs structure
   * @return EvalArgs for call
   */
  public EvalArgs getEvalArgs() {
    return evalArgs;
  }

  /**
   * Set the EvalArgs structure for this call, if it has been determined it is an {@code eval}
   * @param evalArgs eval args
   * @return same node or new one on state change
   */
  public CallNode setEvalArgs(EvalArgs evalArgs) {
    return (this.evalArgs == evalArgs) ? this : new CallNode(this, function, args, flags, optimisticType, evalArgs, programPoint);
  }

  /**
   * Check if this call is a call to {@code eval}
   * @return true if this is a call to {@code eval}
   */
  public boolean isEval() {
    return evalArgs != null;
  }

  /**
   * Is this an apply call that we optimistically should try to turn into a call instead
   * @return true if apply to call
   */
  public boolean isApplyToCall() {
    return (flags & IS_APPLY_TO_CALL) != 0;
  }

  /**
   * Flag this call node as one that tries to call call instead of apply
   * @return new call node with changed flags, if not already flagged as apply to call, then the same node
   */
  public CallNode setIsApplyToCall() {
    return setFlags(flags | IS_APPLY_TO_CALL);
  }

  /**
   * Return the function expression that this call invokes
   * @return the function
   */
  public Expression getFunction() {
    return function;
  }

  /**
   * Reset the function expression that this call invokes
   * @param function the function
   * @return same node or new one on state change
   */
  public CallNode setFunction(Expression function) {
    return (this.function == function) ? this : new CallNode(this, function, args, flags, optimisticType, evalArgs, programPoint);
  }

  /**
   * Check if this call is a new operation
   * @return true if this a new operation
   */
  public boolean isNew() {
    return (flags & IS_NEW) != 0;
  }

  CallNode setFlags(int flags) {
    return (this.flags == flags) ? this : new CallNode(this, function, args, flags, optimisticType, evalArgs, programPoint);
  }

  @Override
  public int getProgramPoint() {
    return programPoint;
  }

  @Override
  public CallNode setProgramPoint(int programPoint) {
    return (this.programPoint == programPoint) ? this : new CallNode(this, function, args, flags, optimisticType, evalArgs, programPoint);
  }

  @Override
  public Type getMostOptimisticType() {
    return Type.INT;
  }

  @Override
  public Type getMostPessimisticType() {
    return Type.OBJECT;
  }

  @Override
  public boolean canBeOptimistic() {
    return true;
  }

  private static final long serialVersionUID = 1;
}
