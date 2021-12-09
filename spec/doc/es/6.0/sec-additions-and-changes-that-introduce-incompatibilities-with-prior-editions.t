<section id="sec-additions-and-changes-that-introduce-incompatibilities-with-prior-editions">
  <h1 id="sec-E" title="Annex&nbsp;E"> </h1><p><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">7.1.3.1</a>: In ECMAScript 2015, <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>
  applied to a String value now recognizes and converts <span class="nt">BinaryIntegerLiteral</span> and <span class="nt">OctalIntegerLIteral</span> numeric strings. In previous editions such strings were converted to <span class="value">NaN</span>,</p>

  <p><a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">6.2.3</a>: In ECMAScript 2015, Function calls are not allowed to return a <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> value.</p>

  <p><a href="sec-ecmascript-language-lexical-grammar#sec-names-and-keywords">11.6</a>: In ECMAScript 2015, the valid code points for an <span class="nt">IdentifierName</span> are specified in terms of the Unicode properties &ldquo;ID_Start&rdquo; and
  &ldquo;ID_Continue&rdquo;.  In previous editions, the valid <span class="nt">IdentifierName</span> or <span class="nt">Identifier</span> code points were specified by enumerating various Unicode code point categories.</p>

  <p><a href="sec-ecmascript-language-lexical-grammar#sec-rules-of-automatic-semicolon-insertion">11.9.1</a>: In ECMAScript 2015, Automatic Semicolon Insertion adds a
  semicolon at the end of a do-while statement if the semicolon is missing. This change aligns the specification with the actual
  behaviour of most existing implementations.</p>

  <p><a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-early-errors">12.2.6.1</a>: In ECMAScript 2015, it is no longer an early
  error to have duplicate property names in Object Initializers.</p>

  <p><a href="sec-ecmascript-language-expressions#sec-assignment-operators-static-semantics-early-errors">12.14.1</a>: In ECMAScript 2015, <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> containing an assignment to an immutable binding such as the function name of
  a <span class="nt">FunctionExpression</span> does not produce an early error. Instead it produces a runtime error.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-expression-statement">13.5</a>: In ECMAScript 2015, a <span class="nt">StatementListItem</span>  beginning with
  the token <code>let</code> followed by the token <code>[</code> is the start of a <span class="nt">LexicalDeclaration</span>. In
  previous editions such a sequence would be the start of an <span class="nt">ExpressionStatement</span>.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-runtime-semantics-evaluation">13.6.7</a>: In ECMAScript 2015, the normal completion value of an
  <span class="nt">IfStatement</span> is never the value <b>empty</b>. If no <span class="nt">Statement</span> part is evaluated
  or if the evaluated <span class="nt">Statement</span> part produces a normal completion whose value is <b>empty</b>, the
  completion value of the <span class="nt">IfStatement</span> is <span class="value">undefined</span>.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-iteration-statements">13.7</a>: In ECMAScript 2015, if the <code>(</code> token of a for statement is
  immediately followed by the token sequence <code>let</code> <code>[</code> then the <code>let</code> is treated as the start of
  a <span class="nt">LexicalDeclaration</span>. In previous editions such a token sequence would be the start of an <span class="nt">Expression</span>.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-iteration-statements">13.7</a>: In ECMAScript 2015, if the ( token of a for-in statement is immediately
  followed by the token sequence <code>let</code> <code>[</code> then the <code>let</code> is treated as the start of a <span class="nt">ForDeclaration</span>. In previous editions such a token sequence would be the start of an <span class="nt">LeftHandSideExpression</span>.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-iteration-statements">13.7</a>: Prior to ECMAScript 2015, an initialization expression could appear as part of
  the <i>VariableDeclaration</i> that precedes the <code>in</code> keyword. The value of that expression was always discarded. In
  ECMAScript 2015, the <i>ForBind</i> in that same position does not allow the occurrence of such an initializer.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-iteration-statements">13.7</a>: In ECMAScript 2015, the completion value of an <span class="nt">IterationStatement</span> is never the value <b>empty</b>. If the <span class="nt">Statement</span> part of an <span class="nt">IterationStatement</span> is not evaluated or if the final evaluation of the <span class="nt">Statement</span> part
  produces a completion whose value is <b>empty</b>, the completion value of the <span class="nt">IterationStatement</span> is
  <span class="value">undefined</span>.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-runtime-semantics-evaluation">13.11.7</a>: In ECMAScript 2015, the normal completion value of a
  <span class="nt">WithStatement</span> is never the value <b>empty</b>. If evaluation of the <span class="nt">Statement</span>
  part of a <span class="nt">WithStatement</span> produces a normal completion whose value is <b>empty</b>, the completion value
  of the <span class="nt">WithStatement</span> is <span class="value">undefined</span>.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-runtime-semantics-evaluation">13.12.11</a>: In ECMAScript 2015, the completion value of a
  <span class="nt">SwitchStatement</span> is never the value <b>empty</b>. If the <span class="nt">CaseBlock</span> part of a
  <span class="nt">SwitchStatement</span> produces a completion whose value is <b>empty</b>, the completion value of the <span class="nt">SwitchStatement</span> is <span class="value">undefined</span>.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement">13.15</a>: In ECMAScript 2015, it is an early error for a <span class="nt">Catch</span> clause
  to contained a <code>var</code> declaration for the same <span class="nt">Identifier</span> that appears as the <span class="nt">Catch</span> clause parameter. In previous editions, such a variable declaration would be instantiated in the
  enclosing variable environment but the declaration&rsquo;s <span class="nt">Initializer</span> value would be assigned to the
  <span class="nt">Catch</span> parameter.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement">13.15</a>, <a href="sec-global-object#sec-evaldeclarationinstantiation">18.2.1.2</a>: In ECMAScript 2015, a
  runtime <span class="value">SyntaxError</span> is thrown if a <span class="nt">Catch</span> clause evaluates a non-strict direct
  <code>eval</code> whose eval code includes a <code>var</code> or <code>FunctionDeclaration</code> declaration that binds the
  same <span class="nt">Identifier</span> that appears as th<b>e</b> <span class="nt">Catch</span> clause parameter.</p>

  <p><a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-runtime-semantics-evaluation">13.15.8</a>: In ECMAScript 2015, the completion value of a <span class="nt">TryStatement</span> is never the value <b>empty</b>. If the <span class="nt">Block</span> part of a <span class="nt">TryStatement</span> evaluates to a normal completion whose value is <b>empty</b>, the completion value of the <span class="nt">TryStatement</span> is <span class="value">undefined</span>. If the <span class="nt">Block</span> part of a <span class="nt">TryStatement</span> evaluates to a throw completion and it has a <span class="nt">Catch</span> part that evaluates to
  a normal completion whose value is <b>empty</b>, the completion value of the <span class="nt">TryStatement</span> is <span class="value">undefined</span> if there is no <span class="nt">Finally</span> clause or if its <span class="nt">Finally</span>
  clause evalulates to an <b>empty</b> normal completion.</p>

  <p><a href="sec-ecmascript-language-functions-and-classes#sec-method-definitions-runtime-semantics-propertydefinitionevaluation">14.3.9</a> In ECMAScript 2015, the function
  objects that are created as the values of the [[Get]] or [[Set]] attribute of accessor properties in an <span class="nt">ObjectLiteral</span> are not constructor functions and they do not have a <code>prototype</code> own property. In the
  previous edition, they were constructors and had a <code>prototype</code> property.</p>

  <p><a href="sec-fundamental-objects#sec-object.freeze">19.1.2.5</a>: In ECMAScript 2015, if the argument to <code><a href="sec-fundamental-objects#sec-object.freeze">Object.freeze</a></code> is not an object it is treated as if it was a non-extensible ordinary object
  with no own properties. In the previous edition, a non-object argument always causes a <span class="value">TypeError</span> to
  be thrown.</p>

  <p><a href="sec-fundamental-objects#sec-object.getownpropertydescriptor">19.1.2.6</a>: In ECMAScript 2015, if the argument to <code><a href="sec-fundamental-objects#sec-object.getownpropertydescriptor">Object.getOwnPropertyDescriptor</a></code> is not an object an attempt is made to
  coerce the argument using <a href="sec-abstract-operations#sec-toobject">ToObject</a>. If the coercion is successful the result is used in place of the
  original argument value. In the previous edition, a non-object argument always causes a <span class="value">TypeError</span> to
  be thrown.</p>

  <p><a href="sec-fundamental-objects#sec-object.getownpropertynames">19.1.2.7</a>: In ECMAScript 2015, if the argument to <code><a href="sec-fundamental-objects#sec-object.getownpropertynames">Object.getOwnPropertyNames</a></code> is not an object an attempt is made to coerce the
  argument using <a href="sec-abstract-operations#sec-toobject">ToObject</a>. If the coercion is successful the result is used in place of the original
  argument value. In the previous edition, a non-object argument always causes a <span class="value">TypeError</span> to be
  thrown.</p>

  <p><a href="sec-fundamental-objects#sec-object.getprototypeof">19.1.2.9</a>: In ECMAScript 2015, if the argument to <code><a href="sec-fundamental-objects#sec-object.getprototypeof">Object.getPrototypeOf</a></code> is not an object an attempt is made to coerce the argument
  using <a href="sec-abstract-operations#sec-toobject">ToObject</a>. If the coercion is successful the result is used in place of the original argument
  value. In the previous edition, a non-object argument always causes a <b>TypeError</b> to be thrown.</p>

  <p><a href="sec-fundamental-objects#sec-object.isextensible">19.1.2.11</a>: In ECMAScript 2015, if the argument to <code><a href="sec-fundamental-objects#sec-object.isextensible">Object.isExtensible</a></code> is not an object it is treated as if it was a non-extensible
  ordinary object with no own properties. In the previous edition, a non-object argument always causes a <span class="value">TypeError</span> to be thrown.</p>

  <p><a href="sec-fundamental-objects#sec-object.isfrozen">19.1.2.12</a>: In ECMAScript 2015, if the argument to <code><a href="sec-fundamental-objects#sec-object.isfrozen">Object.isFrozen</a></code> is not an object it is treated as if it was a non-extensible ordinary
  object with no own properties. In the previous edition, a non-object argument always causes a <span class="value">TypeError</span> to be thrown.</p>

  <p><a href="sec-fundamental-objects#sec-object.issealed">19.1.2.13</a>: In ECMAScript 2015, if the argument to <code><a href="sec-fundamental-objects#sec-object.issealed">Object.isSealed</a></code> is not an object it is treated as if it was a non-extensible ordinary
  object with no own properties. In the previous edition, a non-object argument always causes a <span class="value">TypeError</span> to be thrown.</p>

  <p><a href="sec-fundamental-objects#sec-object.keys">19.1.2.14</a>: In ECMAScript 2015, if the argument to <code><a href="sec-fundamental-objects#sec-object.keys">Object.keys</a></code> is not an object an attempt is made to coerce the argument using <a href="sec-abstract-operations#sec-toobject">ToObject</a>. If the coercion is successful the result is used in place of the original argument value. In
  the previous edition, a non-object argument always causes a <span class="value">TypeError</span> to be thrown.</p>

  <p><a href="sec-fundamental-objects#sec-object.preventextensions">19.1.2.15</a>: In ECMAScript 2015, if the argument to <code><a href="sec-fundamental-objects#sec-object.preventextensions">Object.preventExtensions</a></code> is not an object it is treated as if it was a
  non-extensible ordinary object with no own properties. In the previous edition, a non-object argument always causes a <span class="value">TypeError</span> to be thrown.</p>

  <p><a href="sec-fundamental-objects#sec-object.seal">19.1.2.17</a>: In ECMAScript 2015, if the argument to <code><a href="sec-fundamental-objects#sec-object.seal">Object.seal</a></code> is not an object it is treated as if it was a non-extensible ordinary object with
  no own properties. In the previous edition, a non-object argument always causes a <span class="value">TypeError</span> to be
  thrown.</p>

  <p><a href="sec-fundamental-objects#sec-function.prototype.bind">19.2.3.2</a>: In ECMAScript 2015, the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of a <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">bound
  function</a> is set to the [[GetPrototypeOf]] value of its target function. In the previous edition, [[Prototype]] was always
  set to %FunctionPrototype%.</p>

  <p><a href="sec-fundamental-objects#sec-function-instances-length">19.2.4.1</a>: In ECMAScript 2015, the <code>length</code> property of function
  instances is configurable. In previous editions it was non-configurable.</p>

  <p><a href="sec-fundamental-objects#sec-properties-of-the-boolean-prototype-object">19.3.3</a>: In ECMAScript 2015, the Boolean prototype object is not
  a Boolean instance. In previous editions it was a Boolean instance whose Boolean value was <b>false</b>.</p>

  <p><a href="sec-fundamental-objects#sec-properties-of-the-nativeerror-constructors">19.5.6.2</a>: In ECMAScript 2015, the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of a <i>NativeError</i> constructor is the Error
  constructor. In previous editions it was the Function prototype object.</p>

  <p><a href="sec-numbers-and-dates#sec-properties-of-the-number-prototype-object">20.1.3</a> In ECMAScript 2015, the Number prototype object is not a
  Number instance. In previous editions it was a Number instance whose number value was +0.</p>

  <p><a href="sec-numbers-and-dates#sec-properties-of-the-date-prototype-object">20.3.4</a> In ECMAScript 2015, the Date prototype object is not a Date
  instance. In previous editions it was a Date instance whose TimeValue was NaN.</p>

  <p><a href="sec-text-processing#sec-string.prototype.localecompare">21.1.3.10</a> In ECMAScript 2015, the <code><a href="sec-text-processing#sec-string.prototype.localecompare">String.prototype.localeCompare</a></code> function must treat Strings that are
  canonically equivalent according to the Unicode standard as being identical. In previous editions implementations were permitted
  to ignore canonical equivalence and could instead use a bit-wise comparison.</p>

  <p><a href="sec-text-processing#sec-properties-of-the-string-prototype-object">21.1.3</a> In ECMAScript 2015, the String prototype object is not a
  String instance. In previous editions it was a String instance whose String value was the empty string.</p>

  <p><a href="sec-text-processing#sec-string.prototype.tolowercase">21.1.3.22</a> and <a href="sec-text-processing#sec-string.prototype.touppercase">21.1.3.24</a> In
  ECMAScript 2015, lowercase/upper conversion processing operates on code points. In previous editions such the conversion
  processing was only applied to individual code units. The only affected code points are those in the Deseret block of
  Unicode</p>

  <p><a href="sec-text-processing#sec-string.prototype.trim">21.1.3.25</a> In ECMAScript 2015, the <code><a href="sec-text-processing#sec-string.prototype.trim">String.prototype.trim</a></code> method is defined to recognize white space code points that
  may exists outside of the Unicode BMP. However, as of Unicode 7 no such code points are defined. In previous editions such code
  points would not have been recognized as white space.</p>

  <p><a href="sec-text-processing#sec-regexp-pattern-flags">21.2.3.1</a> In ECMAScript 2015, If the <var>pattern</var> argument is a RegExp instance
  and the <var>flags</var> argument is not <span class="value">undefined</span>, a new RegExp instance is created just like
  <var>pattern</var> except that <var>pattern&rsquo;s</var> flags are replaced by the argument <var>flags</var>.  In previous
  editions a <b>TypeError</b> exception was thrown when <var>pattern</var> was a RegExp instance and <var>flags</var> was not
  <span class="value">undefined</span>.</p>

  <p><a href="sec-text-processing#sec-properties-of-the-regexp-prototype-object">21.2.5</a> In ECMAScript 2015, the RegExp prototype object is not a
  RegExp instance. In previous editions it was a RegExp instance whose pattern is the empty string.</p>

  <p><a href="sec-text-processing#sec-properties-of-the-regexp-prototype-object">21.2.5</a> In ECMAScript 2015, <code>source</code>,
  <code>global</code>, <code>ignoreCase</code>, and <code>multiline</code> are accessor properties defined on the RegExp prototype
  object. In previous editions they were data properties defined on RegExp instances</p>
</section>

