package es.ir;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import es.codegen.types.ArrayType;
import es.codegen.types.Type;
import es.ir.annotations.Ignore;
import es.ir.annotations.Immutable;
import es.ir.visitor.NodeVisitor;
import es.objects.NativeArray;
import es.parser.Lexer.LexerToken;
import es.parser.Token;
import es.parser.TokenType;
import es.runtime.JSType;
import es.runtime.ScriptRuntime;
import es.runtime.Undefined;

/**
 * Literal nodes represent JavaScript values.
 *
 * @param <T> the literal type
 */
@Immutable
public abstract class LiteralNode<T> extends Expression implements PropertyKey {

  // Literal value
  protected final T value;

  /** Marker for values that must be computed at runtime */
  public static final Object POSTSET_MARKER = new Object();

  /**
   * Constructor
   *
   * @param token   token
   * @param finish  finish
   * @param value   the value of the literal
   */
  LiteralNode(long token, int finish, T value) {
    super(token, finish);
    this.value = value;
  }

  /**
   * Copy constructor
   *
   * @param literalNode source node
   */
  LiteralNode(LiteralNode<T> literalNode) {
    this(literalNode, literalNode.value);
  }

  /**
   * A copy constructor with value change.
   * @param literalNode the original literal node
   * @param newValue new value for this node
   */
  LiteralNode(LiteralNode<T> literalNode, T newValue) {
    super(literalNode);
    this.value = newValue;
  }

  /**
   * Initialization setter, if required for immutable state.
   * This is used for things like ArrayLiteralNodes that need to carry state for the splitter.
   * Default implementation is just a nop.
   * @param lc lexical context
   * @return new literal node with initialized state, or same if nothing changed
   */
  public LiteralNode<?> initialize(LexicalContext lc) {
    return this;
  }

  /**
   * Check if the literal value is null
   * @return true if literal value is null
   */
  public boolean isNull() {
    return value == null;
  }

  @Override
  public Type getType() {
    return Type.typeFor(value.getClass());
  }

  @Override
  public String getPropertyName() {
    return JSType.toString(getObject());
  }

  /**
   * Fetch boolean value of node.
   * @return boolean value of node.
   */
  public boolean getBoolean() {
    return JSType.toBoolean(value);
  }

  /**
   * Fetch int32 value of node.
   * @return Int32 value of node.
   */
  public int getInt32() {
    return JSType.toInt32(value);
  }

  /**
   * Fetch uint32 value of node.
   * @return uint32 value of node.
   */
  public long getUint32() {
    return JSType.toUint32(value);
  }

  /**
   * Fetch long value of node
   * @return long value of node
   */
  public long getLong() {
    return JSType.toLong(value);
  }

  /**
   * Fetch double value of node.
   * @return double value of node.
   */
  public double getNumber() {
    return JSType.toNumber(value);
  }

  /**
   * Fetch String value of node.
   * @return String value of node.
   */
  public String getString() {
    return JSType.toString(value);
  }

  /**
   * Fetch Object value of node.
   * @return Object value of node.
   */
  public Object getObject() {
    return value;
  }

  /**
   * Test if the value is an array
   * @return True if value is an array
   */
  public boolean isArray() {
    return false;
  }

  public List<Expression> getElementExpressions() {
    return null;
  }

  /**
   * Test if the value is a boolean.
   * @return True if value is a boolean.
   */
  public boolean isBoolean() {
    return value instanceof Boolean;
  }

  /**
   * Test if the value is a string.
   * @return True if value is a string.
   */
  public boolean isString() {
    return value instanceof String;
  }

  /**
   * Test if tha value is a number
   * @return True if value is a number
   */
  public boolean isNumeric() {
    return value instanceof Number;
  }

  /**
   * Assist in IR navigation.
   * @param visitor IR navigating visitor.
   */
  @Override
  public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
    return (visitor.enterLiteralNode(this)) ? visitor.leaveLiteralNode(this) : this;
  }

  @Override
  public void toString(StringBuilder sb, boolean printType) {
    if (value == null) {
      sb.append("null");
    } else {
      sb.append(value.toString());
    }
  }

  /**
   * Get the literal node value
   * @return the value
   */
  public final T getValue() {
    return value;
  }

  static Expression[] valueToArray(List<Expression> value) {
    return value.toArray(new Expression[0]);
  }

  /**
   * Create a new null literal
   * @param token   token
   * @param finish  finish
   * @return the new literal node
   */
  public static LiteralNode<Object> newInstance(long token, int finish) {
    return new NullLiteralNode(token, finish);
  }

  /**
   * Create a new null literal based on a parent node (source, token, finish)
   * @param parent parent node
   * @return the new literal node
   */
  public static LiteralNode<Object> newInstance(Node parent) {
    return new NullLiteralNode(parent.getToken(), parent.getFinish());
  }

  /**
   * Super class for primitive (side-effect free) literals.
   * @param <T> the literal type
   */
  public static class PrimitiveLiteralNode<T> extends LiteralNode<T> {

    PrimitiveLiteralNode(long token, int finish, T value) {
      super(token, finish, value);
    }
    PrimitiveLiteralNode(PrimitiveLiteralNode<T> literalNode) {
      super(literalNode);
    }

    /**
     * Check if the literal value is boolean true
     * @return true if literal value is boolean true
     */
    public boolean isTrue() {
      return JSType.toBoolean(value);
    }

    @Override public boolean isLocal() { return true; }
    @Override public boolean isAlwaysFalse() { return !isTrue(); }
    @Override public boolean isAlwaysTrue() { return isTrue(); }
    
    private static final long serialVersionUID = 1;
  }

  @Immutable
  static final class BooleanLiteralNode extends PrimitiveLiteralNode<Boolean> {

    BooleanLiteralNode(long token, int finish, boolean value) {
      super(Token.recast(token, value ? TokenType.TRUE : TokenType.FALSE), finish, value);
    }
    BooleanLiteralNode(BooleanLiteralNode literalNode) {
      super(literalNode);
    }

    @Override public boolean isTrue() { return value; }
    @Override public Type getType() { return Type.BOOLEAN; }
    @Override public Type getWidestOperationType() { return Type.BOOLEAN; }
    
    private static final long serialVersionUID = 1;
  }

  /**
   * Create a new boolean literal
   * @param token   token
   * @param finish  finish
   * @param value   true or false
   * @return the new literal node
   */
  public static LiteralNode<Boolean> newInstance(long token, int finish, boolean value) {
    return new BooleanLiteralNode(token, finish, value);
  }

  /**
   * Create a new boolean literal based on a parent node (source, token, finish)
   * @param parent parent node
   * @param value  true or false
   * @return the new literal node
   */
  public static LiteralNode<?> newInstance(Node parent, boolean value) {
    return new BooleanLiteralNode(parent.getToken(), parent.getFinish(), value);
  }

  @Immutable
  static final class NumberLiteralNode extends PrimitiveLiteralNode<Number> {

    private final Type type = numberGetType(value);

    NumberLiteralNode(long token, int finish, Number value) {
      super(Token.recast(token, TokenType.DECIMAL), finish, value);
    }
    NumberLiteralNode(NumberLiteralNode literalNode) {
      super(literalNode);
    }

    static Type numberGetType(Number number) {
      return (number instanceof Integer) ? Type.INT
           : (number instanceof Double) ? Type.NUMBER
           : null; // assert false; not a number
    }

    @Override public Type getType() { return type; }
    @Override public Type getWidestOperationType() { return getType(); }
    
    private static final long serialVersionUID = 1;
  }

  /**
   * Create a new number literal
   * @param token   token
   * @param finish  finish
   * @param value   literal value
   * @return the new literal node
   */
  public static LiteralNode<Number> newInstance(long token, int finish, Number value) {
    assert !(value instanceof Long);
    return new NumberLiteralNode(token, finish, value);
  }

  /**
   * Create a new number literal based on a parent node (source, token, finish)
   * @param parent parent node
   * @param value  literal value
   * @return the new literal node
   */
  public static LiteralNode<?> newInstance(Node parent, Number value) {
    return new NumberLiteralNode(parent.getToken(), parent.getFinish(), value);
  }

  static class UndefinedLiteralNode extends PrimitiveLiteralNode<Undefined> {

    UndefinedLiteralNode(long token, int finish) {
      super(Token.recast(token, TokenType.OBJECT), finish, ScriptRuntime.UNDEFINED);
    }
    UndefinedLiteralNode(UndefinedLiteralNode literalNode) {
      super(literalNode);
    }
    
    private static final long serialVersionUID = 1;
  }

  /**
   * Create a new undefined literal
   * @param token   token
   * @param finish  finish
   * @param value   undefined value, passed only for polymorphism discrimination
   * @return the new literal node
   */
  public static LiteralNode<Undefined> newInstance(long token, int finish, Undefined value) {
    return new UndefinedLiteralNode(token, finish);
  }

  /**
   * Create a new null literal based on a parent node (source, token, finish)
   * @param parent parent node
   * @param value  undefined value
   * @return the new literal node
   */
  public static LiteralNode<?> newInstance(Node parent, Undefined value) {
    return new UndefinedLiteralNode(parent.getToken(), parent.getFinish());
  }

  @Immutable
  static class StringLiteralNode extends PrimitiveLiteralNode<String> {

    StringLiteralNode(long token, int finish, String value) {
      super(Token.recast(token, TokenType.STRING), finish, value);
    }
    StringLiteralNode(StringLiteralNode literalNode) {
      super(literalNode);
    }

    @Override
    public void toString(StringBuilder sb, boolean printType) {
      sb.append('\"');
      sb.append(value);
      sb.append('\"');
    }
    
    private static final long serialVersionUID = 1;
  }

  /**
   * Create a new string literal
   * @param token   token
   * @param finish  finish
   * @param value   string value
   * @return the new literal node
   */
  public static LiteralNode<String> newInstance(long token, int finish, String value) {
    return new StringLiteralNode(token, finish, value);
  }

  /**
   * Create a new String literal based on a parent node (source, token, finish)
   * @param parent parent node
   * @param value  string value
   * @return the new literal node
   */
  public static LiteralNode<?> newInstance(Node parent, String value) {
    return new StringLiteralNode(parent.getToken(), parent.getFinish(), value);
  }

  @Immutable
  static class LexerTokenLiteralNode extends LiteralNode<LexerToken> {

    LexerTokenLiteralNode(long token, int finish, LexerToken value) {
      super(Token.recast(token, TokenType.STRING), finish, value); //TODO is string the correct token type here?
    }
    LexerTokenLiteralNode(LexerTokenLiteralNode literalNode) {
      super(literalNode);
    }

    @Override public Type getType() { return Type.OBJECT; }

    @Override
    public void toString(StringBuilder sb, boolean printType) {
      sb.append(value.toString());
    }
    
    private static final long serialVersionUID = 1;
  }

  /**
   * Create a new literal node for a lexer token
   * @param token   token
   * @param finish  finish
   * @param value   lexer token value
   * @return the new literal node
   */
  public static LiteralNode<LexerToken> newInstance(long token, int finish, LexerToken value) {
    return new LexerTokenLiteralNode(token, finish, value);
  }

  /**
   * Create a new lexer token literal based on a parent node (source, token, finish)
   * @param parent parent node
   * @param value  lexer token
   * @return the new literal node
   */
  public static LiteralNode<?> newInstance(Node parent, LexerToken value) {
    return new LexerTokenLiteralNode(parent.getToken(), parent.getFinish(), value);
  }

  /**
   * Get the constant value for an object, or {@link #POSTSET_MARKER} if the value can't be statically computed.
   * @param object a node or value object
   * @return the constant value or {@code POSTSET_MARKER}
   */
  public static Object objectAsConstant(Object object) {
    return (object == null) ? null
         : (object instanceof Number || object instanceof String || object instanceof Boolean) ? object
         : (object instanceof LiteralNode) ? objectAsConstant(((LiteralNode<?>) object).getValue())
         : POSTSET_MARKER;
  }

  /**
   * Test whether {@code object} represents a constant value.
   * @param object a node or value object
   * @return true if object is a constant value
   */
  public static boolean isConstant(Object object) {
    return objectAsConstant(object) != POSTSET_MARKER;
  }

  static final class NullLiteralNode extends PrimitiveLiteralNode<Object> {

    NullLiteralNode(long token, int finish) {
      super(Token.recast(token, TokenType.OBJECT), finish, null);
    }

    @Override
    public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
      return (visitor.enterLiteralNode(this)) ? visitor.leaveLiteralNode(this) : this;
    }

    @Override public Type getType() { return Type.OBJECT; }
    @Override public Type getWidestOperationType() { return Type.OBJECT; }
    
    private static final long serialVersionUID = 1;
  }

  /**
   * Array literal node class.
   */
  @Immutable
  public static final class ArrayLiteralNode extends LiteralNode<Expression[]> implements LexicalContextNode, Splittable {

    // Array element type.
    private final Type elementType;

    // Preset constant array.
    private final Object presets;

    // Indices of array elements requiring computed post sets.
    private final int[] postsets;

    // Ranges for splitting up large literals in code generation
    @Ignore
    private final List<Splittable.SplitRange> splitRanges;

    // Does this array literal have a spread element?
    private final boolean hasSpread;

    // Does this array literal have a trailing comma?
    private final boolean hasTrailingComma;

    @Override
    public boolean isArray() {
      return true;
    }

    static final class ArrayLiteralInitializer {

      static ArrayLiteralNode initialize(ArrayLiteralNode node) {
        var elementType = computeElementType(node.value);
        var postsets = computePostsets(node.value);
        var presets = computePresets(node.value, elementType, postsets);
        return new ArrayLiteralNode(node, node.value, elementType, postsets, presets, node.splitRanges);
      }

      static Type computeElementType(Expression[] value) {
        Type widestElementType = Type.INT;
        for (var elem : value) {
          if (elem == null) {
            widestElementType = widestElementType.widest(Type.OBJECT); //no way to represent undefined as number
            break;
          }
          var type = elem.getType().isUnknown() ? Type.OBJECT : elem.getType();
          if (type.isBoolean()) {
            // TODO fix this with explicit boolean types
            widestElementType = widestElementType.widest(Type.OBJECT);
            break;
          }
          widestElementType = widestElementType.widest(type);
          if (widestElementType.isObject()) {
            break;
          }
        }
        return widestElementType;
      }

      static int[] computePostsets(Expression[] value) {
        var computed = new int[value.length];
        var nComputed = 0;
        for (var i = 0; i < value.length; i++) {
          var element = value[i];
          if (element == null || !isConstant(element)) {
            computed[nComputed++] = i;
          }
        }
        return Arrays.copyOf(computed, nComputed);
      }

      static boolean setArrayElement(int[] array, int i, Object n) {
        if (n instanceof Number num) {
          array[i] = num.intValue();
          return true;
        }
        return false;
      }

      static boolean setArrayElement(long[] array, int i, Object n) {
        if (n instanceof Number num) {
          array[i] = num.longValue();
          return true;
        }
        return false;
      }

      static boolean setArrayElement(double[] array, int i, Object n) {
        if (n instanceof Number num) {
          array[i] = num.doubleValue();
          return true;
        }
        return false;
      }

      private static int[] presetIntArray(Expression[] value, int[] postsets) {
        var array = new int[value.length];
        var nComputed = 0;
        for (var i = 0; i < value.length; i++) {
          if (!setArrayElement(array, i, objectAsConstant(value[i]))) {
            assert postsets[nComputed++] == i; // side-effects
          }
        }
        assert postsets.length == nComputed; // relies on side-effects
        return array;
      }

      static long[] presetLongArray(Expression[] value, int[] postsets) {
        var array = new long[value.length];
        var nComputed = 0;
        for (var i = 0; i < value.length; i++) {
          if (!setArrayElement(array, i, objectAsConstant(value[i]))) {
            assert postsets[nComputed++] == i; // side-effects
          }
        }
        assert postsets.length == nComputed; // relies on side-effects
        return array;
      }

      static double[] presetDoubleArray(Expression[] value, int[] postsets) {
        var array = new double[value.length];
        var nComputed = 0;
        for (var i = 0; i < value.length; i++) {
          if (!setArrayElement(array, i, objectAsConstant(value[i]))) {
            assert postsets[nComputed++] == i; // side-effects
          }
        }
        assert postsets.length == nComputed; // relies on side-effects
        return array;
      }

      static Object[] presetObjectArray(Expression[] value, int[] postsets) {
        var array = new Object[value.length];
        var nComputed = 0;
        for (var i = 0; i < value.length; i++) {
          var node = value[i];
          if (node == null) {
            assert postsets[nComputed++] == i; // side-effects
            continue;
          }
          var element = objectAsConstant(node);
          if (element != POSTSET_MARKER) {
            array[i] = element;
          } else {
            assert postsets[nComputed++] == i; // side-effects
          }
        }
        assert postsets.length == nComputed; // relies on side-effects
        return array;
      }

      static Object computePresets(Expression[] value, Type elementType, int[] postsets) {
        assert !elementType.isUnknown();
        return (elementType.isInteger()) ? presetIntArray(value, postsets)
             : (elementType.isNumeric()) ? presetDoubleArray(value, postsets)
             : presetObjectArray(value, postsets);
      }
    }

    /**
     * Constructor
     *
     * @param token   token
     * @param finish  finish
     * @param value   array literal value, a Node array
     */
    protected ArrayLiteralNode(long token, int finish, Expression[] value) {
      this(token, finish, value, false, false);
    }

    /**
     * Constructor
     *
     * @param token   token
     * @param finish  finish
     * @param value   array literal value, a Node array
     * @param hasSpread true if the array has a spread element
     * @param hasTrailingComma true if the array literal has a comma after the last element
     */
    protected ArrayLiteralNode(long token, int finish, Expression[] value, boolean hasSpread, boolean hasTrailingComma) {
      super(Token.recast(token, TokenType.ARRAY), finish, value);
      this.elementType = Type.UNKNOWN;
      this.presets = null;
      this.postsets = null;
      this.splitRanges = null;
      this.hasSpread = hasSpread;
      this.hasTrailingComma = hasTrailingComma;
    }

    /**
     * Copy constructor
     * @param node source array literal node
     */
    ArrayLiteralNode(ArrayLiteralNode node, Expression[] value, Type elementType, int[] postsets, Object presets, List<Splittable.SplitRange> splitRanges) {
      super(node, value);
      this.elementType = elementType;
      this.postsets = postsets;
      this.presets = presets;
      this.splitRanges = splitRanges;
      this.hasSpread = node.hasSpread;
      this.hasTrailingComma = node.hasTrailingComma;
    }

    /**
     * Returns {@code true} if this array literal has a spread element.
     * @return true if this literal has a spread element
     */
    public boolean hasSpread() {
      return hasSpread;
    }

    /**
     * Returns {@code true} if this array literal has a trailing comma.
     * @return true if this literal has a trailing comma
     */
    public boolean hasTrailingComma() {
      return hasTrailingComma;
    }

    /**
     * Returns a list of array element expressions. Note that empty array elements manifest themselves as
     * null.
     * @return a list of array element expressions.
     */
    @Override
    public List<Expression> getElementExpressions() {
      return Collections.unmodifiableList(Arrays.asList(value));
    }

    /**
     * Setter that initializes all code generation meta data for an ArrayLiteralNode.
     * This acts a setter, so the return value may return a new node and must be handled
     * @param lc lexical context
     * @return new array literal node with postsets, presets and element types initialized
     */
    @Override
    public ArrayLiteralNode initialize(LexicalContext lc) {
      return Node.replaceInLexicalContext(lc, this, ArrayLiteralInitializer.initialize(this));
    }

    /**
     * Get the array element type as Java format, e.g. [I
     * @return array element type
     */
    public ArrayType getArrayType() {
      return getArrayType(getElementType());
    }

    static ArrayType getArrayType(Type elementType) {
      return (elementType.isInteger()) ? Type.INT_ARRAY
           : (elementType.isNumeric()) ? Type.NUMBER_ARRAY
           : Type.OBJECT_ARRAY;
    }

    @Override
    public Type getType() {
      return Type.typeFor(NativeArray.class);
    }

    /**
     * Get the element type of this array literal
     * @return element type
     */
    public Type getElementType() {
      assert !elementType.isUnknown() : this + " has elementType=unknown";
      return elementType;
    }

    /**
     * Get indices of arrays containing computed post sets. post sets
     * are things like non literals e.g. "x+y" instead of i or 17
     * @return post set indices
     */
    public int[] getPostsets() {
      assert postsets != null : this + " elementType=" + elementType + " has no postsets";
      return postsets;
    }

    boolean presetsMatchElementType() {
      return (elementType == Type.INT) ? presets instanceof int[]
           : (elementType == Type.NUMBER) ?  presets instanceof double[]
           : presets instanceof Object[];
    }

    /**
     * Get presets constant array
     * @return presets array, always returns an array type
     */
    public Object getPresets() {
      assert presets != null && presetsMatchElementType() : this + " doesn't have presets, or invalid preset type: " + presets;
      return presets;
    }

    /**
     * Get the split ranges for this ArrayLiteral, or null if this array does not have to be split.
     * @see Splittable.SplitRange
     * @return list of split ranges
     */
    @Override
    public List<Splittable.SplitRange> getSplitRanges() {
      return splitRanges == null ? null : Collections.unmodifiableList(splitRanges);
    }

    /**
     * Set the SplitRanges that make up this ArrayLiteral
     * @param lc lexical context
     * @see Splittable.SplitRange
     * @param splitRanges list of split ranges
     * @return new or changed node
     */
    public ArrayLiteralNode setSplitRanges(LexicalContext lc, List<Splittable.SplitRange> splitRanges) {
      return (this.splitRanges == splitRanges) ? this : Node.replaceInLexicalContext(lc, this, new ArrayLiteralNode(this, value, elementType, postsets, presets, splitRanges));
    }

    @Override
    public Node accept(NodeVisitor<? extends LexicalContext> visitor) {
      return Acceptor.accept(this, visitor);
    }

    @Override
    public Node accept(LexicalContext lc, NodeVisitor<? extends LexicalContext> visitor) {
      if (visitor.enterLiteralNode(this)) {
        var oldValue = Arrays.asList(value);
        var newValue = Node.accept(visitor, oldValue);
        return visitor.leaveLiteralNode(oldValue != newValue ? setValue(lc, newValue) : this);
      }
      return this;
    }

    ArrayLiteralNode setValue(LexicalContext lc, Expression[] value) {
      return (this.value == value) ? this : Node.replaceInLexicalContext(lc, this, new ArrayLiteralNode(this, value, elementType, postsets, presets, splitRanges));
    }

    ArrayLiteralNode setValue(LexicalContext lc, List<Expression> value) {
      return setValue(lc, value.toArray(new Expression[0]));
    }

    @Override
    public void toString(StringBuilder sb, boolean printType) {
      sb.append('[');
      var first = true;
      for (var node : value) {
        if (!first) {
          sb.append(',');
          sb.append(' ');
        }
        if (node == null) {
          sb.append("undefined");
        } else {
          node.toString(sb, printType);
        }
        first = false;
      }
      sb.append(']');
    }

    private static final long serialVersionUID = 1;
  } // ArrayLiteralNode

  /**
   * Create a new array literal of Nodes from a list of Node values
   * @param token   token
   * @param finish  finish
   * @param value   literal value list
   * @return the new literal node
   */
  public static LiteralNode<Expression[]> newInstance(long token, int finish, List<Expression> value) {
    return new ArrayLiteralNode(token, finish, valueToArray(value));
  }

  /**
   * Create a new array literal based on a parent node (source, token, finish)
   * @param parent parent node
   * @param value  literal value list
   * @return the new literal node
   */
  public static LiteralNode<?> newInstance(Node parent, List<Expression> value) {
    return new ArrayLiteralNode(parent.getToken(), parent.getFinish(), valueToArray(value));
  }

  /**
   * Create a new array literal of Nodes from a list of Node values
   * @param token token
   * @param finish finish
   * @param value literal value list
   * @param hasSpread true if the array has a spread element
   * @param hasTrailingComma true if the array literal has a comma after the last element
   * @return the new literal node
   */
  public static LiteralNode<Expression[]> newInstance(long token, int finish, List<Expression> value, boolean hasSpread, boolean hasTrailingComma) {
    return new ArrayLiteralNode(token, finish, valueToArray(value), hasSpread, hasTrailingComma);
  }

  /**
   * Create a new array literal of Nodes
   * @param token   token
   * @param finish  finish
   * @param value   literal value array
   * @return the new literal node
   */
  public static LiteralNode<Expression[]> newInstance(long token, int finish, Expression[] value) {
    return new ArrayLiteralNode(token, finish, value);
  }

  private static final long serialVersionUID = 1;
}
