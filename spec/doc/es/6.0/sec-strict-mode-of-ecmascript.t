<section id="sec-strict-mode-of-ecmascript">
  <h1 id="sec-C" title="Annex&nbsp;C"> </h1><p><b>The strict mode restriction and exceptions</b></p>

  <ul>
    <li>
      <p><code>implements</code>, <code>interface</code>, <code>let</code>, <code>package</code>, <code>private</code>,
      <code>protected</code>, <code>public</code>, <code>static</code>, and <code>yield</code> are reserved words within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>. (<a href="sec-ecmascript-language-lexical-grammar#sec-reserved-words">11.6.2</a>).</p>
    </li>

    <li>
      <p>A conforming implementation, when processing <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, may not extend the
      syntax of <i>NumericLiteral</i> (<a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">11.8.3</a>) to include
      <i>LegacyOctalIntegerLiteral</i> as described in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-additional-syntax-numeric-literals">B.1.1</a>.</p>
    </li>

    <li>
      <p>A conforming implementation, when processing <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, may not extend the
      syntax of <i>EscapeSequence</i> to include <i>LegacyOctalEscapeSequence</i> as described in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-additional-syntax-string-literals">B.1.2</a>.</p>
    </li>

    <li>
      <p>Assignment to an undeclared identifier or otherwise unresolvable reference does not create a property in the global
      object. When a simple assignment occurs within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, its <i>LeftHandSide</i>
      must not evaluate to an <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">unresolvable Reference</a>. If it does a
      <b>ReferenceError</b> exception is thrown (<a href="sec-ecmascript-data-types-and-values#sec-putvalue">6.2.3.2</a>). The <i>LeftHandSide</i> also may not be a
      reference to a data property with the attribute value {[[Writable]]:<b>false</b>}, to an accessor property with the
      attribute value {[[Set]]:<b>undefined</b>}, nor to a non-existent property of an object whose [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> has the value <b>false</b>. In these cases a
      <code>TypeError</code> exception is thrown (<a href="sec-ecmascript-language-expressions#sec-assignment-operators">12.14</a>).</p>
    </li>

    <li>
      <p>The identifier <code>eval</code> or <code>arguments</code> may not appear as the <i>LeftHandSideExpression</i> of an
      Assignment operator (<a href="sec-ecmascript-language-expressions#sec-assignment-operators">12.14</a>) or of a <i>PostfixExpression</i> (<a href="sec-ecmascript-language-expressions#sec-postfix-expressions">12.4</a>) or as the <i>UnaryExpression</i> operated upon by a Prefix Increment (<a href="sec-ecmascript-language-expressions#sec-prefix-increment-operator">12.5.7</a>) or a Prefix Decrement (<a href="sec-ecmascript-language-expressions#sec-prefix-decrement-operator">12.5.8</a>) operator.</p>
    </li>

    <li>
      <p>Arguments objects for strict mode functions define non-configurable accessor properties named <code>"caller"</code> and
      <code>"callee"</code> which throw a <b>TypeError</b> exception on access (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-addrestrictedfunctionproperties">9.2.7</a>).</p>
    </li>

    <li>
      <p>Arguments objects for strict mode functions do not dynamically share their array indexed property values with the
      corresponding formal parameter bindings of their functions. (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-arguments-exotic-objects">9.4.4</a>).</p>
    </li>

    <li>
      <p>For strict mode functions, if an arguments object is created the binding of the local identifier <code>arguments</code>
      to the arguments object is immutable and hence may not be the target of an assignment expression. (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-functiondeclarationinstantiation">9.2.12</a>).</p>
    </li>

    <li>
      <p>It is a <b>SyntaxError</b> if the <i>IdentifierName</i> <code>eval</code> or the <i>IdentifierName</i>
      <code>arguments</code> occurs as a <span class="nt">BindingIdentifier</span> within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
      mode code</a> (<a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-early-errors">12.1.1</a>).</p>
    </li>

    <li>
      <p>Strict mode eval code cannot instantiate variables or functions in the variable environment of the caller to eval.
      Instead, a new variable environment is created and that environment is used for declaration binding instantiation for the
      eval code (<a href="sec-global-object#sec-eval-x">18.2.1</a>).</p>
    </li>

    <li>
      <p>If <b>this</b> is evaluated within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, then the <b>this</b> value is
      not coerced to an object. A <b>this</b> value of <b>null</b> or <b>undefined</b> is not converted to the global object and
      primitive values are not converted to wrapper objects. The <b>this</b> value passed via a function call (including calls
      made using <code><a href="sec-fundamental-objects#sec-function.prototype.apply">Function.prototype.apply</a></code> and <code><a href="sec-fundamental-objects#sec-function.prototype.call">Function.prototype.call</a></code>) do not coerce the passed this value to an object (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycallbindthis">9.2.1.2</a>, <a href="sec-fundamental-objects#sec-function.prototype.apply">19.2.3.1</a>, <a href="sec-fundamental-objects#sec-function.prototype.call">19.2.3.3</a>).</p>
    </li>

    <li>
      <p>When a <code>delete</code> operator occurs within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, a
      <b>SyntaxError</b> is thrown if its <i>UnaryExpression</i> is a direct reference to a variable, function argument, or
      function name (<a href="sec-ecmascript-language-expressions#sec-delete-operator-static-semantics-early-errors">12.5.4.1</a>).</p>
    </li>

    <li>
      <p>When a <code>delete</code> operator occurs within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, a
      <b>TypeError</b> is thrown if the property to be deleted has the attribute { [[Configurable]]:<b>false</b> } (<a href="sec-ecmascript-language-expressions#sec-delete-operator-runtime-semantics-evaluation">12.5.4.2</a>).</p>
    </li>

    <li>
      <p>Strict mode code may not include a <i>WithStatement</i>. The occurrence of a <i>WithStatement</i> in such a context is a
      <b>SyntaxError</b> (<a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-early-errors">13.11.1</a>).</p>
    </li>

    <li>
      <p>It is a <b>SyntaxError</b> if a <i>TryStatement</i> with a <i>Catch</i> occurs within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> and the <i>Identifier</i> of the <i>Catch</i> production is
      <code>eval</code> or <code>arguments</code> (<a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-early-errors">13.15.1</a>).</p>
    </li>

    <li>
      <p>It is a <b>SyntaxError</b> if the same <span class="nt">BindingIdentifier</span> appears more than once in the <span class="nt">FormalParameters</span> of a strict mode function. An attempt to create such a function using a
      <code>Function</code> or <code>Generator</code> constructor is a <b>SyntaxError</b> (<a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-early-errors">14.1.2</a>, <a href="sec-fundamental-objects#sec-createdynamicfunction">19.2.1.1.1</a>).</p>
    </li>

    <li>
      <p>An implementation may not extend, beyond that defined in this specification, the meanings within strict mode functions of
      properties named <code>caller</code> or <code>arguments</code> of function instances. ECMAScript code may not create or
      modify properties with these names on function objects that correspond to strict mode functions (<a href="sec-error-handling-and-language-extensions#sec-forbidden-extensions">16.1</a>).</p>
    </li>
  </ul>
</section>

