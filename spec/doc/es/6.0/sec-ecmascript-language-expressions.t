<section id="sec-ecmascript-language-expressions">
  <div class="front">
    <h1 id="sec-12" title="12">
        ECMAScript Language: Expressions</h1></div>

  <section id="sec-identifiers">
    <div class="front">
      <h2 id="sec-12.1" title="12.1">
          Identifiers</h2><p><b>Syntax</b></p>

      <div class="gp">
        <div class="lhs"><span class="nt">IdentifierReference</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">Identifier</span></div>
        <div class="rhs"><span class="grhsannot">[~Yield]</span> <code class="t">yield</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">Identifier</span></div>
        <div class="rhs"><span class="grhsannot">[~Yield]</span> <code class="t">yield</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">LabelIdentifier</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">Identifier</span></div>
        <div class="rhs"><span class="grhsannot">[~Yield]</span> <code class="t">yield</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">Identifier</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">IdentifierName</span> <span class="grhsmod">but not</span> <span class="nt">ReservedWord</span></div>
      </div>
    </div>

    <section id="sec-identifiers-static-semantics-early-errors">
      <h3 id="sec-12.1.1" title="12.1.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">BindingIdentifier</span> <span class="geq">:</span> <span class="nt">Identifier</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if the code matched by this production is contained in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
          mode code</a> and the StringValue of <span class="nt">Identifier</span> is <code>"arguments"</code> or
          <code>"eval"</code>.</p>
        </li>
      </ul>

      <p><span class="prod"><span class="nt">IdentifierReference</span> <span class="geq">:</span> <code class="t">yield</code></span><br /><span class="prod"><span class="nt">BindingIdentifier</span> <span class="geq">:</span>
      <code class="t">yield</code></span><br /><span class="prod"><span class="nt">LabelIdentifier</span> <span class="geq">:</span>
      <code class="t">yield</code></span></p>

      <ul>
        <li>
          <p>It is a Syntax Error if the code matched by this production is contained in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
          mode code</a><var>.</var></p>
        </li>
      </ul>

      <p><i>IdentifierReference</i><span style="font-family: sans-serif"><sub>[Yield]</sub> <b>:</b></span>  <i>Identifier</i>
      <span style="font-family: sans-serif"><br /></span><i>BindingIdentifier</i><span style="font-family:       sans-serif"><sub>[Yield]</sub> <b>:</b></span>  <i>Identifier</i>  <span style="font-family:       sans-serif"><br /></span><i>LabelIdentifier</i><span style="font-family: sans-serif"><sub>[Yield]</sub> <b>:</b></span>
      <i>Identifier</i></p>

      <ul>
        <li>
          <p>It is a Syntax Error if this production has a <sub>[Yield]</sub> parameter and StringValue of <span class="nt">Identifier</span> is <code>"yield"</code>.</p>
        </li>
      </ul>
      <div class="gp prod"><span class="nt">Identifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span> <span class="grhsmod">but not</span> <span class="nt">ReservedWord</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if this phrase is contained in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> and the
          StringValue of <span class="nt">IdentifierName</span> is: <code>"implements"</code>, <code>"interface"</code>,
          <code>"let"</code>, <code>"package"</code>, <code>"private"</code>, <code>"protected"</code>, <code>"public"</code>,
          <code>"static"</code>, or <code>"yield"</code>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if StringValue of <span class="nt">IdentifierName</span> is the same String value as the
          StringValue of any <span class="nt">ReservedWord</span> except for <code>yield</code>.</p>
        </li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE</span>  StringValue of <span class="nt">IdentifierName</span> normalizes any Unicode escape
        sequences in <span class="nt">IdentifierName</span> hence such escapes cannot be used to write an <span class="nt">Identifier</span> whose code point sequence is the same as a <span class="nt">ReservedWord</span>.</p>
      </div>
    </section>

    <section id="sec-identifiers-static-semantics-boundnames">
      <h3 id="sec-12.1.2" title="12.1.2"> Static Semantics: BoundNames</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-boundnames">13.3.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-boundnames">13.3.2.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-boundnames">13.3.3.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-boundnames">13.7.5.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-boundnames">14.1.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-boundnames">14.2.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-boundnames">14.4.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-boundnames">14.5.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-imports-static-semantics-boundnames">15.2.2.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-boundnames">15.2.3.2</a>.</p>

      <div class="gp prod"><span class="nt">BindingIdentifier</span> <span class="geq">:</span> <span class="nt">Identifier</span></div>
      <ol class="proc">
        <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the StringValue of
            <i>Identifier</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">BindingIdentifier</span> <span class="geq">:</span> <code class="t">yield</code></div>
      <ol class="proc">
        <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <code>"yield"</code>.</li>
      </ol>
    </section>

    <section id="sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.1.3" title="12.1.3"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <div class="gp prod"><span class="nt">IdentifierReference</span> <span class="geq">:</span> <span class="nt">Identifier</span></div>
      <ol class="proc">
        <li>If this <i>IdentifierReference</i> is contained in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> and
            StringValue of <i>Identifier</i> is <code>"eval"</code> or <code>"arguments"</code>, return <b>false</b>.</li>
        <li>Return <b>true</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">IdentifierReference</span> <span class="geq">:</span> <code class="t">yield</code></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-identifiers-static-semantics-stringvalue">
      <h3 id="sec-12.1.4" title="12.1.4"> Static Semantics: </h3><p>See also: <a href="sec-ecmascript-language-lexical-grammar#sec-identifier-names-static-semantics-stringvalue">11.6.1.2</a>, <a href="sec-ecmascript-language-lexical-grammar#sec-string-literals-static-semantics-stringvalue">11.8.4.2</a>.</p>

      <p><span class="prod"><span class="nt">IdentifierReference</span> <span class="geq">:</span> <code class="t">yield</code></span><br /><span class="prod"><span class="nt">BindingIdentifier</span> <span class="geq">:</span>
      <code class="t">yield</code></span><br /><span class="prod"><span class="nt">LabelIdentifier</span> <span class="geq">:</span>
      <code class="t">yield</code></span></p>

      <ol class="proc">
        <li>Return <code>"yield"</code>.</li>
      </ol>
      <div class="gp prod"><span class="nt">Identifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span> <span class="grhsmod">but not</span> <span class="nt">ReservedWord</span></div>
      <ol class="proc">
        <li>Return the StringValue of <i>IdentifierName</i>.</li>
      </ol>
    </section>

    <section id="sec-identifiers-runtime-semantics-bindinginitialization">
      <div class="front">
        <h3 id="sec-12.1.5" title="12.1.5"> Runtime Semantics: BindingInitialization</h3><p>With arguments <var>value</var> and <var>environment</var>.</p>

        <p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-runtime-semantics-bindinginitialization">13.3.3.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-runtime-semantics-bindinginitialization">13.7.5.9</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> <b>undefined</b> is passed for <var>environment</var> to indicate that a <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a> operation should be used to assign the initialization value. This is the case for
          <code>var</code> statements and formal parameter lists of some non-strict functions (See <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functiondeclarationinstantiation">9.2.12</a>). In those cases a lexical binding is hoisted and preinitialized
          prior to evaluation of its initializer.</p>
        </div>

        <div class="gp prod"><span class="nt">BindingIdentifier</span> <span class="geq">:</span> <span class="nt">Identifier</span></div>
        <ol class="proc">
          <li>Let <i>name</i> be StringValue of <i>Identifier</i>.</li>
          <li>Return <a href="#sec-initializeboundname">InitializeBoundName</a>( <i>name</i>, <i>value</i>,
              <i>environment</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingIdentifier</span> <span class="geq">:</span> <code class="t">yield</code></div>
        <ol class="proc">
          <li>Return <a href="#sec-initializeboundname">InitializeBoundName</a>(<code>"yield"</code>, <i>value</i>,
              <i>environment</i>).</li>
        </ol>
      </div>

      <section id="sec-initializeboundname">
        <h4 id="sec-12.1.5.1" title="12.1.5.1"> Runtime Semantics: InitializeBoundName(name, value, environment)</h4><ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>name</i>) is String.</li>
          <li>If <i>environment</i> is not <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>env</i> be the <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a> component of
                  <i>environment</i>.</li>
              <li>Perform <i>env</i>.InitializeBinding(<i>name</i>, <i>value</i>).</li>
              <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
            </ol>
          </li>
          <li>Else
            <ol class="block">
              <li>Let <i>lhs</i> be <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(<i>name</i>).</li>
              <li>Return <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lhs</i>, <i>value</i>).</li>
            </ol>
          </li>
        </ol>
      </section>
    </section>

    <section id="sec-identifiers-runtime-semantics-evaluation">
      <h3 id="sec-12.1.6" title="12.1.6"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">IdentifierReference</span> <span class="geq">:</span> <span class="nt">Identifier</span></div>
      <ol class="proc">
        <li>Return <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(StringValue of <i>Identifier</i>).</li>
      </ol>
      <div class="gp prod"><span class="nt">IdentifierReference</span> <span class="geq">:</span> <code class="t">yield</code></div>
      <ol class="proc">
        <li>Return <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(<code>"yield"</code>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 1</span> The result of evaluating an <span class="nt">IdentifierReference</span> is always a
        value of type <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a>.</p>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 2</span> In non-<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict code</a>, the keyword <code>yield</code>
        may be used as an identifier. Evaluating the <span class="nt">IdentifierReference</span> production resolves the binding
        of <code>yield</code> as if it was an <span class="nt">Identifier</span>. Early Error restriction ensures that such an
        evaluation only can occur for non-<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict code</a>. See <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations">13.3.1</a> for the handling of <code>yield</code> in binding creation contexts.</p>
      </div>
    </section>
  </section>

  <section id="sec-primary-expression">
    <div class="front">
      <h2 id="sec-12.2" title="12.2">
          Primary Expression</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">PrimaryExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">this</code></div>
        <div class="rhs"><span class="nt">IdentifierReference</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">Literal</span></div>
        <div class="rhs"><span class="nt">ArrayLiteral</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">ObjectLiteral</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">FunctionExpression</span></div>
        <div class="rhs"><span class="nt">ClassExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">GeneratorExpression</span></div>
        <div class="rhs"><span class="nt">RegularExpressionLiteral</span></div>
        <div class="rhs"><span class="nt">TemplateLiteral</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code></div>
        <div class="rhs"><code class="t">(</code> <code class="t">)</code></div>
        <div class="rhs"><code class="t">(</code> <code class="t">...</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">)</code></div>
        <div class="rhs"><code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">,</code> <code class="t">...</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">)</code></div>
      </div>

      <h2>Supplemental Syntax</h2>

      <p>When processing the production</p>

      <p class="normalbefore">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nt">PrimaryExpression</span><sub>[Yield]</sub>
      <b>:</b> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub>[?Yield]</sub></p>

      <p class="normalbefore">the interpretation of <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span> is
      refined using the following grammar:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">ParenthesizedExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code></div>
      </div>
    </div>

    <section id="sec-primary-expression-semantics">
      <div class="front">
        <h3 id="sec-12.2.1" title="12.2.1"> Semantics</h3></div>

      <section id="sec-static-semantics-coveredparenthesizedexpression">
        <h4 id="sec-12.2.1.1" title="12.2.1.1"> Static Semantics:  CoveredParenthesizedExpression</h4><div class="gp prod"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code></div>
        <ol class="proc">
          <li>Return the result of parsing the lexical token stream matched by
              <i>CoverParenthesizedExpressionAndArrowParameterList</i><sub>[Yield]</sub> using either
              <i>ParenthesizedExpression</i> or <i>ParenthesizedExpression</i><sub>[Yield]</sub> as the goal symbol depending upon
              whether the <sub>[Yield]</sub> grammar parameter was present when
              <i>CoverParenthesizedExpressionAndArrowParameterList was matched.</i></li>
        </ol>
      </section>

      <section id="sec-semantics-static-semantics-hasname">
        <h4 id="sec-12.2.1.2" title="12.2.1.2"> Static Semantics:  HasName</h4><p>See also: <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-hasname">14.1.8</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-hasname">14.2.7</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-hasname">14.4.7</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-hasname">14.5.6</a>.</p>

        <div class="gp prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be CoveredParenthesizedExpression of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
          <li>If IsFunctionDefinition of <i>expr</i> is <b>false</b>, return <b>false</b>.</li>
          <li>Return HasName of <i>expr</i>.</li>
        </ol>
      </section>

      <section id="sec-semantics-static-semantics-isfunctiondefinition">
        <h4 id="sec-12.2.1.3" title="12.2.1.3"> Static Semantics:  IsFunctionDefinition</h4><p>See also: <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">PrimaryExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">this</code></div>
          <div class="rhs"><span class="nt">IdentifierReference</span></div>
          <div class="rhs"><span class="nt">Literal</span></div>
          <div class="rhs"><span class="nt">ArrayLiteral</span></div>
          <div class="rhs"><span class="nt">ObjectLiteral</span></div>
          <div class="rhs"><span class="nt">RegularExpressionLiteral</span></div>
          <div class="rhs"><span class="nt">TemplateLiteral</span></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be CoveredParenthesizedExpression of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
          <li>Return IsFunctionDefinition of <i>expr</i>.</li>
        </ol>
      </section>

      <section id="sec-semantics-static-semantics-isidentifierref">
        <h4 id="sec-12.2.1.4" title="12.2.1.4"> Static Semantics:  IsIdentifierRef</h4><p>See also: <a href="#sec-static-semantics-static-semantics-isidentifierref">12.3.1.4</a>.</p>

        <div class="gp prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">IdentifierReference</span></div>
        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">PrimaryExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">this</code></div>
          <div class="rhs"><span class="nt">Literal</span></div>
          <div class="rhs"><span class="nt">ArrayLiteral</span></div>
          <div class="rhs"><span class="nt">ObjectLiteral</span></div>
          <div class="rhs"><span class="nt">FunctionExpression</span></div>
          <div class="rhs"><span class="nt">ClassExpression</span></div>
          <div class="rhs"><span class="nt">GeneratorExpression</span></div>
          <div class="rhs"><span class="nt">RegularExpressionLiteral</span></div>
          <div class="rhs"><span class="nt">TemplateLiteral</span></div>
          <div class="rhs"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-semantics-static-semantics-isvalidsimpleassignmenttarget">
        <h4 id="sec-12.2.1.5" title="12.2.1.5"> Static Semantics:  IsValidSimpleAssignmentTarget</h4><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">PrimaryExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">this</code></div>
          <div class="rhs"><span class="nt">Literal</span></div>
          <div class="rhs"><span class="nt">ArrayLiteral</span></div>
          <div class="rhs"><span class="nt">ObjectLiteral</span></div>
          <div class="rhs"><span class="nt">FunctionExpression</span></div>
          <div class="rhs"><span class="nt">ClassExpression</span></div>
          <div class="rhs"><span class="nt">GeneratorExpression</span></div>
          <div class="rhs"><span class="nt">RegularExpressionLiteral</span></div>
          <div class="rhs"><span class="nt">TemplateLiteral</span></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be CoveredParenthesizedExpression of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
          <li>Return IsValidSimpleAssignmentTarget of <i>expr</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-this-keyword">
      <div class="front">
        <h3 id="sec-12.2.2" title="12.2.2"> The
            </h3></div>

      <section id="sec-this-keyword-runtime-semantics-evaluation">
        <h4 id="sec-12.2.2.1" title="12.2.2.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <code class="t">this</code></div>
        <ol class="proc">
          <li>Return <a href="sec-executable-code-and-execution-contexts#sec-resolvethisbinding">ResolveThisBinding</a>( ) .</li>
        </ol>
      </section>
    </section>

    <section id="sec-identifier-reference">
      <h3 id="sec-12.2.3" title="12.2.3">
          Identifier Reference</h3><p>See <a href="#sec-identifiers">12.1</a> for <span class="nt">IdentifierReference</span>.</p>
    </section>

    <section id="sec-primary-expression-literals">
      <div class="front">
        <h3 id="sec-12.2.4" title="12.2.4"> Literals</h3><h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">Literal</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">NullLiteral</span></div>
          <div class="rhs"><span class="nt">BooleanLiteral</span></div>
          <div class="rhs"><span class="nt">NumericLiteral</span></div>
          <div class="rhs"><span class="nt">StringLiteral</span></div>
        </div>
      </div>

      <section id="sec-literals-runtime-semantics-evaluation">
        <h4 id="sec-12.2.4.1" title="12.2.4.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">Literal</span> <span class="geq">:</span> <span class="nt">NullLiteral</span></div>
        <ol class="proc">
          <li>Return <b>null</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">Literal</span> <span class="geq">:</span> <span class="nt">BooleanLiteral</span></div>
        <ol class="proc">
          <li>Return <b>false</b> if <i>BooleanLiteral</i> is the token <code>false</code>.</li>
          <li>Return <b>true</b> if <i>BooleanLiteral</i> is the token <code>true</code>.</li>
        </ol>
        <div class="gp prod"><span class="nt">Literal</span> <span class="geq">:</span> <span class="nt">NumericLiteral</span></div>
        <ol class="proc">
          <li>Return the number whose value is  MV of <i>NumericLiteral</i> as defined in <a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">11.8.3</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">Literal</span> <span class="geq">:</span> <span class="nt">StringLiteral</span></div>
        <ol class="proc">
          <li>Return the StringValue of <i>StringLiteral</i> as defined in <a href="sec-ecmascript-language-lexical-grammar#sec-string-literals-static-semantics-stringvalue">11.8.4.2</a>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-array-initializer">
      <div class="front">
        <h3 id="sec-12.2.5" title="12.2.5">
            Array Initializer</h3><div class="note">
          <p><span class="nh">NOTE</span> An <span class="nt">ArrayLiteral</span> is an expression describing the initialization
          of an Array object, using a list, of zero or more expressions each of which represents an array element, enclosed in
          square brackets. The elements need not be literals; they are evaluated each time the array initializer is evaluated.</p>
        </div>

        <p>Array elements may be elided at the beginning, middle or end of the element list. Whenever a comma in the element list
        is not preceded by an <span class="nt">AssignmentExpression</span> (i.e., a comma at the beginning or after another
        comma), the missing array element contributes to the length of the Array and increases the index of subsequent elements.
        Elided array elements are not defined. If an element is elided at the end of an array, that element does not contribute to
        the length of the Array.</p>

        <h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">ArrayLiteral</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">ElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">]</code></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">ElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ElementList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
          <div class="rhs"><span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">SpreadElement</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">ElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
          <div class="rhs"><span class="nt">ElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">SpreadElement</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">Elision</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">,</code></div>
          <div class="rhs"><span class="nt">Elision</span> <code class="t">,</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">SpreadElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">...</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
        </div>
      </div>

      <section id="sec-static-semantics-elisionwidth">
        <h4 id="sec-12.2.5.1" title="12.2.5.1"> Static Semantics:  ElisionWidth</h4><div class="gp prod"><span class="nt">Elision</span> <span class="geq">:</span> <code class="t">,</code></div>
        <ol class="proc">
          <li>Return the numeric value 1.</li>
        </ol>
        <div class="gp prod"><span class="nt">Elision</span> <span class="geq">:</span> <span class="nt">Elision</span> <code class="t">,</code></div>
        <ol class="proc">
          <li>Let <i>preceding</i> be the ElisionWidth of <i>Elision</i>.</li>
          <li>Return <i>preceding</i>+1.</li>
        </ol>
      </section>

      <section id="sec-runtime-semantics-arrayaccumulation">
        <h4 id="sec-12.2.5.2" title="12.2.5.2"> Runtime Semantics: ArrayAccumulation</h4><p>With parameters <var>array</var> and <var>nextIndex</var>.</p>

        <div class="gp prod"><span class="nt">ElementList</span> <span class="geq">:</span> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Let <i>padding</i> be the ElisionWidth of <i>Elision</i>; if <i>Elision</i> is not present, use the numeric value
              zero.</li>
          <li>Let <i>initResult</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
          <li>Let <i>initValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>initResult</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>initValue</i>).</li>
          <li>Let <i>created</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>array</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>nextIndex+padding</i>)),
              <i>initValue</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>created</i> is <b>true</b><i>.</i></li>
          <li>Return <i>nextIndex+padding+</i>1.</li>
        </ol>
        <div class="gp prod"><span class="nt">ElementList</span> <span class="geq">:</span> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">SpreadElement</span></div>
        <ol class="proc">
          <li>Let <i>padding</i> be the ElisionWidth of <i>Elision</i>; if <i>Elision</i> is not present, use the numeric value
              zero.</li>
          <li>Return the result of performing ArrayAccumulation for <i>SpreadElement</i> with arguments <i>array</i> and
              <i>nextIndex</i>+<i>padding</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ElementList</span> <span class="geq">:</span> <span class="nt">ElementList</span> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Let <i>postIndex</i>  be the result of performing ArrayAccumulation for <i>ElementList</i> with arguments
              <i>array</i> and <i>nextIndex</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>postIndex</i>).</li>
          <li>Let <i>padding</i> be the ElisionWidth of <i>Elision</i>; if <i>Elision</i> is not present, use the numeric value
              zero.</li>
          <li>Let <i>initResult</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
          <li>Let <i>initValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>initResult</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>initValue</i>).</li>
          <li>Let <i>created</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>array</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>postIndex</i>+<i>padding</i>)),
              <i>initValue</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>created</i> is <b>true</b>.</li>
          <li>Return <i>postIndex</i>+<i>padding+</i>1.</li>
        </ol>
        <div class="gp prod"><span class="nt">ElementList</span> <span class="geq">:</span> <span class="nt">ElementList</span> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">SpreadElement</span></div>
        <ol class="proc">
          <li>Let <i>postIndex</i>  be the result of performing ArrayAccumulation for <i>ElementList</i> with arguments
              <i>array</i> and <i>nextIndex</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>postIndex</i>).</li>
          <li>Let <i>padding</i> be the ElisionWidth of <i>Elision</i>; if <i>Elision</i> is not present, use the numeric value
              zero.</li>
          <li>Return the result of performing ArrayAccumulation for <i>SpreadElement</i> with arguments <i>array</i> and
              <i>postIndex</i>+<i>padding</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">SpreadElement</span> <span class="geq">:</span> <code class="t">...</code> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Let <i>spreadRef</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
          <li>Let <i>spreadObj</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>spreadRef</i>).</li>
          <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>spreadObj</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iterator</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, return <i>nextIndex</i>.</li>
              <li>Let <i>nextValue</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextValue</i>).</li>
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>array</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>nextIndex</i>), <i>nextValue</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>status</i> is <b>true</b> .</li>
              <li>Let <i>nextIndex</i> be <i>nextIndex</i> + 1.</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a> is used to ensure that own
          properties are defined for the array even if the standard built-in Array prototype object has been modified in a manner
          that would preclude the creation of new own properties using [[Set]].</p>
        </div>
      </section>

      <section id="sec-array-initializer-runtime-semantics-evaluation">
        <h4 id="sec-12.2.5.3" title="12.2.5.3"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">ArrayLiteral</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>array</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0).</li>
          <li>Let <i>pad</i> be the ElisionWidth of <i>Elision</i>; if <i>Elision</i> is not present, use the numeric value
              zero.</li>
          <li>Perform <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>array</i>, <code>"length"</code>, <i>pad</i>, <b>false</b>).</li>
          <li>NOTE:  The above Set cannot fail because of the nature of the object returned by <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>.</li>
          <li>Return <i>array</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayLiteral</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">ElementList</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>array</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0).</li>
          <li>Let <i>len</i> be the result of performing ArrayAccumulation for <i>ElementList</i> with arguments <i>array</i> and
              0.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Perform <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>array</i>, <code>"length"</code>, <i>len</i>, <b>false</b>).</li>
          <li>NOTE:  The above Set cannot fail because of the nature of the object returned by <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>.</li>
          <li>Return <i>array</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayLiteral</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">ElementList</span> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>array</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0).</li>
          <li>Let <i>len</i> be the result of performing ArrayAccumulation for <i>ElementList</i> with arguments <i>array</i> and
              0.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Let <i>padding</i> be the ElisionWidth of <i>Elision</i>; if <i>Elision</i> is not present, use the numeric value
              zero.</li>
          <li>Perform <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>array</i>, <code>"length"</code>, <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>padding</i>+<i>len</i>), <b>false</b>).</li>
          <li>NOTE:  The above Set cannot fail because of the nature of the object returned by <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>.</li>
          <li>Return <i>array</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-object-initializer">
      <div class="front">
        <h3 id="sec-12.2.6" title="12.2.6">
            Object Initializer</h3><div class="note">
          <p><span class="nh">NOTE 1</span> An object initializer is an expression describing the initialization of an Object,
          written in a form resembling a literal. It is a list of zero or more pairs of property keys and associated values,
          enclosed in curly brackets. The values need not be literals; they are evaluated each time the object initializer is
          evaluated.</p>
        </div>

        <h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">ObjectLiteral</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">{</code> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">PropertyDefinitionList</span><sub class="g-params">[?Yield]</sub> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">PropertyDefinitionList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <code class="t">}</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">PropertyDefinitionList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">PropertyDefinition</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">PropertyDefinitionList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">PropertyDefinition</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">PropertyDefinition</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">IdentifierReference</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">CoverInitializedName</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">:</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
          <div class="rhs"><span class="nt">MethodDefinition</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">PropertyName</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">LiteralPropertyName</span></div>
          <div class="rhs"><span class="nt">ComputedPropertyName</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">LiteralPropertyName</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">IdentifierName</span></div>
          <div class="rhs"><span class="nt">StringLiteral</span></div>
          <div class="rhs"><span class="nt">NumericLiteral</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ComputedPropertyName</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">]</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">CoverInitializedName</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">IdentifierReference</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[In, ?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">Initializer</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">=</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> <span class="nt">MethodDefinition</span> is defined in <a href="sec-ecmascript-language-functions-and-classes#sec-method-definitions">14.3</a>.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> In certain contexts, <span class="nt">ObjectLiteral</span> is used as a cover grammar
          for a more restricted secondary grammar. The <span class="nt">CoverInitializedName</span> production is necessary to
          fully cover these secondary grammars. However, use of this production results in an early Syntax Error in normal
          contexts where an actual <span class="nt">ObjectLiteral</span> is expected.</p>
        </div>
      </div>

      <section id="sec-object-initializer-static-semantics-early-errors">
        <h4 id="sec-12.2.6.1" title="12.2.6.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">PropertyDefinition</span> <span class="geq">:</span> <span class="nt">MethodDefinition</span></div>
        <ul>
          <li>It is a Syntax Error if HasDirectSuper of <span class="nt">MethodDefinition</span> is <span style="font-family:               Times New Roman"><b><i>true</i></b></span>.</li>
        </ul>

        <p>In addition to describing an actual object initializer the <span class="nt">ObjectLiteral</span> productions are also
        used as a cover grammar for <span class="nt">ObjectAssignmentPattern</span> (<a href="#sec-destructuring-assignment">12.14.5</a>). and may be recognized as part of a <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span>. When <span class="nt">ObjectLiteral</span> appears in
        a context where <span class="nt">ObjectAssignmentPattern</span> is required the following Early Error rules are <b>not</b>
        applied. In addition, they are not applied when initially parsing a
        <var>CoverParenthesizedExpressionAndArrowParameterList.</var></p>

        <div class="gp prod"><span class="nt">PropertyDefinition</span> <span class="geq">:</span> <span class="nt">CoverInitializedName</span></div>
        <ul>
          <li>Always throw a Syntax Error if code matches <span style="font-family: Times New Roman">this production.</span></li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> This production exists so that <span class="nt">ObjectLiteral</span> can serve as a
          cover grammar for <span class="nt">ObjectAssignmentPattern</span> (<a href="#sec-destructuring-assignment">12.14.5</a>).
          It cannot occur in an actual object initializer.</p>
        </div>
      </section>

      <section id="sec-object-initializer-static-semantics-computedpropertycontains">
        <h4 id="sec-12.2.6.2" title="12.2.6.2"> Static Semantics:  ComputedPropertyContains</h4><p>With parameter <var>symbol</var>.</p>

        <p>See also: <a href="sec-ecmascript-language-functions-and-classes#sec-method-definitions-static-semantics-computedpropertycontains">14.3.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-computedpropertycontains">14.4.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-computedpropertycontains">14.5.5</a>.</p>

        <div class="gp prod"><span class="nt">PropertyName</span> <span class="geq">:</span> <span class="nt">LiteralPropertyName</span></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">PropertyName</span> <span class="geq">:</span> <span class="nt">ComputedPropertyName</span></div>
        <ol class="proc">
          <li>Return the result of <i>ComputedPropertyName</i> Contains <i>symbol</i>.</li>
        </ol>
      </section>

      <section id="sec-object-initializer-static-semantics-contains">
        <h4 id="sec-12.2.6.3" title="12.2.6.3"> Static Semantics:  Contains</h4><p>With parameter <var>symbol</var>.</p>

        <p>See also: <a href="sec-notational-conventions#sec-static-semantic-rules">5.3</a>, <a href="#sec-static-semantics-static-semantics-contains">12.3.1.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-contains">14.1.4</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-contains">14.2.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-contains">14.4.4</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-contains">14.5.4</a>.</p>

        <div class="gp prod"><span class="nt">PropertyDefinition</span> <span class="geq">:</span> <span class="nt">MethodDefinition</span></div>
        <ol class="proc">
          <li>If <i>symbol</i> is <i>MethodDefinition</i>, return <b>true</b>.</li>
          <li>Return the result of ComputedPropertyContains for <i>MethodDefinition</i> with argument <i>symbol</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> Static semantic rules that depend upon substructure generally do not look into function
          definitions.</p>
        </div>

        <div class="gp prod"><span class="nt">LiteralPropertyName</span> <span class="geq">:</span> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>If <i>symbol</i> is a <i>ReservedWord</i>, return <b>false</b>.</li>
          <li>If <i>symbol</i> is an <i>Identifier</i> and StringValue of <i>symbol</i> is the same value as the StringValue of
              <i>IdentifierName</i>, return <b>true</b>;</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-object-initializer-static-semantics-hascomputedpropertykey">
        <h4 id="sec-12.2.6.4" title="12.2.6.4"> Static Semantics: HasComputedPropertyKey</h4><p>See also: <a href="sec-ecmascript-language-functions-and-classes#sec-method-definitions-static-semantics-hascomputedpropertykey">14.3.4</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-hascomputedpropertykey">14.4.5</a></p>

        <div class="gp prod"><span class="nt">PropertyDefinitionList</span> <span class="geq">:</span> <span class="nt">PropertyDefinitionList</span> <code class="t">,</code> <span class="nt">PropertyDefinition</span></div>
        <ol class="proc">
          <li>If HasComputedPropertyKey of <i>PropertyDefinitionList</i> is <b>true</b>, return <b>true</b>.</li>
          <li>Return HasComputedPropertyKey of <i>PropertyDefinition</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">PropertyDefinition</span> <span class="geq">:</span> <span class="nt">IdentifierReference</span></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">PropertyDefinition</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Return IsComputedPropertyKey of <i>PropertyName</i>.</li>
        </ol>
      </section>

      <section id="sec-static-semantics-iscomputedpropertykey">
        <h4 id="sec-12.2.6.5" title="12.2.6.5"> Static Semantics:  IsComputedPropertyKey</h4><div class="gp prod"><span class="nt">PropertyName</span> <span class="geq">:</span> <span class="nt">LiteralPropertyName</span></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">PropertyName</span> <span class="geq">:</span> <span class="nt">ComputedPropertyName</span></div>
        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-object-initializer-static-semantics-propname">
        <h4 id="sec-12.2.6.6" title="12.2.6.6"> Static Semantics: </h4><p>See also: <a href="sec-ecmascript-language-functions-and-classes#sec-method-definitions-static-semantics-propname">14.3.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-propname">14.4.10</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-propname">14.5.12</a></p>

        <div class="gp prod"><span class="nt">PropertyDefinition</span> <span class="geq">:</span> <span class="nt">IdentifierReference</span></div>
        <ol class="proc">
          <li>Return StringValue of <i>IdentifierReference</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">PropertyDefinition</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Return PropName of <i>PropertyName</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LiteralPropertyName</span> <span class="geq">:</span> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Return StringValue of <i>IdentifierName</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LiteralPropertyName</span> <span class="geq">:</span> <span class="nt">StringLiteral</span></div>
        <ol class="proc">
          <li>Return a String value whose code units are the SV of the <i>StringLiteral</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LiteralPropertyName</span> <span class="geq">:</span> <span class="nt">NumericLiteral</span></div>
        <ol class="proc">
          <li>Let <i>nbr</i> be the result of forming the value of the <i>NumericLiteral</i>.</li>
          <li>Return <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>nbr</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">ComputedPropertyName</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">AssignmentExpression</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return <span style="font-family: sans-serif">empty</span>.</li>
        </ol>
      </section>

      <section id="sec-static-semantics-propertynamelist">
        <h4 id="sec-12.2.6.7" title="12.2.6.7"> Static Semantics:  PropertyNameList</h4><div class="gp prod"><span class="nt">PropertyDefinitionList</span> <span class="geq">:</span> <span class="nt">PropertyDefinition</span></div>
        <ol class="proc">
          <li>If PropName of <i>PropertyDefinition</i> is <span style="font-family: sans-serif">empty</span>, return a new empty
              <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing PropName of
              <i>PropertyDefinition</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">PropertyDefinitionList</span> <span class="geq">:</span> <span class="nt">PropertyDefinitionList</span> <code class="t">,</code> <span class="nt">PropertyDefinition</span></div>
        <ol class="proc">
          <li>Let <i>list</i> be PropertyNameList of <i>PropertyDefinitionList.</i></li>
          <li>If PropName of <i>PropertyDefinition</i> is <span style="font-family: sans-serif">empty</span>, return
              <i>list</i>.</li>
          <li>Append PropName of <i>PropertyDefinition</i> to the end of <i>list</i>.</li>
          <li>Return <i>list</i>.</li>
        </ol>
      </section>

      <section id="sec-object-initializer-runtime-semantics-evaluation">
        <h4 id="sec-12.2.6.8" title="12.2.6.8"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">ObjectLiteral</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Return <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<span style="font-family:               sans-serif">%ObjectPrototype%</span>).</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ObjectLiteral</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">PropertyDefinitionList</span> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">PropertyDefinitionList</span> <code class="t">,</code> <code class="t">}</code></div>
        </div>

        <ol class="proc">
          <li>Let <i>obj</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(%ObjectPrototype%).</li>
          <li>Let <i>status</i> be the result of performing PropertyDefinitionEvaluation of <i>PropertyDefinitionList</i> with
              arguments <i>obj</i> and <b>true</b>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return <i>obj</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LiteralPropertyName</span> <span class="geq">:</span> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Return StringValue of <i>IdentifierName</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LiteralPropertyName</span> <span class="geq">:</span> <span class="nt">StringLiteral</span></div>
        <ol class="proc">
          <li>Return a String value whose code units are the SV of the <i>StringLiteral</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LiteralPropertyName</span> <span class="geq">:</span> <span class="nt">NumericLiteral</span></div>
        <ol class="proc">
          <li>Let <i>nbr</i> be the result of forming the value of the <i>NumericLiteral</i>.</li>
          <li>Return <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>nbr</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">ComputedPropertyName</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">AssignmentExpression</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>exprValue</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
          <li>Let <i>propName</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprValue</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propName</i>).</li>
          <li>Return <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>propName</i>).</li>
        </ol>
      </section>

      <section id="sec-object-initializer-runtime-semantics-propertydefinitionevaluation">
        <h4 id="sec-12.2.6.9" title="12.2.6.9"> Runtime Semantics: PropertyDefinitionEvaluation</h4><p>With parameter <var>object</var> and <span style="font-family: Times New Roman"><i>enumerable</i>.</span></p>

        <p>See also: <a href="sec-ecmascript-language-functions-and-classes#sec-method-definitions-runtime-semantics-propertydefinitionevaluation">14.3.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-runtime-semantics-propertydefinitionevaluation">14.4.13</a>, B.3.1</p>

        <div class="gp prod"><span class="nt">PropertyDefinitionList</span> <span class="geq">:</span> <span class="nt">PropertyDefinitionList</span> <code class="t">,</code> <span class="nt">PropertyDefinition</span></div>
        <ol class="proc">
          <li>Let <i>status</i> be the result of performing PropertyDefinitionEvaluation of  <i>PropertyDefinitionList</i> with
              arguments <i>object</i> and <i>enumerable</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return the result of performing PropertyDefinitionEvaluation of <i>PropertyDefinition</i> with arguments
              <i>object</i> and <i>enumerable</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">PropertyDefinition</span> <span class="geq">:</span> <span class="nt">IdentifierReference</span></div>
        <ol class="proc">
          <li>Let <i>propName</i> be StringValue of <i>IdentifierReference</i>.</li>
          <li>Let <i>exprValue</i> be the result of evaluating <i>IdentifierReference</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exprValue</i>).</li>
          <li>Let <i>propValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprValue</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propValue</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>enumerable</i> is <b>true</b>.</li>
          <li>Return <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a>(<i>object</i>, <i>propName</i>,
              <i>propValue</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">PropertyDefinition</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Let <i>propKey</i> be the result of evaluating <i>PropertyName</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propKey</i>).</li>
          <li>Let <i>exprValueRef</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
          <li>Let <i>propValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprValueRef</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propValue</i>).</li>
          <li>If <a href="sec-ecmascript-language-functions-and-classes#sec-isanonymousfunctiondefinition">IsAnonymousFunctionDefinition</a>(<i>AssignmentExpression)</i> is
              <b>true</b>, then
            <ol class="block">
              <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>propValue</i>,
                  <code>"name"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
              <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>propValue</i>, <i>propKey</i>).</li>
            </ol>
          </li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>enumerable</i> is <b>true</b>.</li>
          <li>Return <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a>(<i>object</i>, <i>propKey</i>,
              <i>propValue</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> An alternative semantics for this production is given in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-__proto__-property-names-in-object-initializers">B.3.1</a>.</p>
        </div>
      </section>
    </section>

    <section id="sec-function-defining-expressions">
      <h3 id="sec-12.2.7" title="12.2.7"> Function Defining Expressions</h3><p>See <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">14.1</a> for <span class="prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">FunctionExpression</span></span> .</p>

      <p>See <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions">14.4</a> for <span class="prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">GeneratorExpression</span></span> .</p>

      <p>See <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions">14.5</a> for <span class="prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">ClassExpression</span></span> .</p>
    </section>

    <section id="sec-primary-expression-regular-expression-literals">
      <div class="front">
        <h3 id="sec-12.2.8" title="12.2.8"> Regular Expression Literals</h3><h2>Syntax</h2>

        <p>See <a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">11.8.5</a>.</p>
      </div>

      <section id="sec-primary-expression-regular-expression-literals-static-semantics-early-errors">
        <h4 id="sec-12.2.8.1" title="12.2.8.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">RegularExpressionLiteral</span></div>
        <ul>
          <li>
            <p>It is a Syntax Error if <span style="font-family: Times New Roman">BodyText</span> of <span class="nt">RegularExpressionLiteral</span> cannot be recognized using the goal symbol <span class="nt">Pattern</span>
            of the ECMAScript RegExp grammar specified in <a href="sec-text-processing#sec-patterns">21.2.1</a><var>.</var></p>
          </li>

          <li>
            <p>It is a Syntax Error if <span style="font-family: Times New Roman">FlagText</span> of <span class="nt">RegularExpressionLiteral</span> contains any code points other than <code>"g"</code>, <code>"i"</code>,
            <code>"m"</code>, <code>"u"</code>, or <code>"y"</code>, or if it contains the same code point more than once.</p>
          </li>
        </ul>
      </section>

      <section id="sec-regular-expression-literals-runtime-semantics-evaluation">
        <h4 id="sec-12.2.8.2" title="12.2.8.2"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">RegularExpressionLiteral</span></div>
        <ol class="proc">
          <li>Let <i>pattern</i> be the String value consisting of the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> of each code
              point of BodyText of <i>RegularExpressionLiteral</i>.</li>
          <li>Let <i>flags</i> be the String value consisting of the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> of each code
              point of FlagText of <i>RegularExpressionLiteral</i>.</li>
          <li>Return <a href="sec-text-processing#sec-regexpcreate">RegExpCreate</a>(<i>pattern</i>, <i>flags</i>).</li>
        </ol>
      </section>
    </section>

    <section id="sec-template-literals">
      <div class="front">
        <h3 id="sec-12.2.9" title="12.2.9">
            Template Literals</h3><h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">TemplateLiteral</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">NoSubstitutionTemplate</span></div>
          <div class="rhs"><span class="nt">TemplateHead</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <span class="nt">TemplateSpans</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">TemplateSpans</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">TemplateTail</span></div>
          <div class="rhs"><span class="nt">TemplateMiddleList</span><sub class="g-params">[?Yield]</sub> <span class="nt">TemplateTail</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">TemplateMiddleList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">TemplateMiddle</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub></div>
          <div class="rhs"><span class="nt">TemplateMiddleList</span><sub class="g-params">[?Yield]</sub> <span class="nt">TemplateMiddle</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub></div>
        </div>
      </div>

      <section id="sec-static-semantics-templatestrings">
        <h4 id="sec-12.2.9.1" title="12.2.9.1"> Static Semantics:  TemplateStrings</h4><p>With parameter <var>raw</var>.</p>

        <div class="gp prod"><span class="nt">TemplateLiteral</span> <span class="geq">:</span> <span class="nt">NoSubstitutionTemplate</span></div>
        <ol class="proc">
          <li>If <i>raw</i> is <b>false</b>, then
            <ol class="block">
              <li>Let <i>string</i> be the TV of <i>NoSubstitutionTemplate</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>string</i> be the TRV of <i>NoSubstitutionTemplate</i>.</li>
            </ol>
          </li>
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the single element,
              <i>string</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateLiteral</span> <span class="geq">:</span> <span class="nt">TemplateHead</span> <span class="nt">Expression</span> <span class="nt">TemplateSpans</span></div>
        <ol class="proc">
          <li>If <i>raw</i> is <b>false</b>, then
            <ol class="block">
              <li>Let <i>head</i> be the TV of <i>TemplateHead</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>head</i> be the TRV of <i>TemplateHead</i>.</li>
            </ol>
          </li>
          <li>Let <i>tail</i> be TemplateStrings of <i>TemplateSpans</i> with argument <i>raw</i>.</li>
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>head</i> followed by the element,
              in order of <i>tail</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateSpans</span> <span class="geq">:</span> <span class="nt">TemplateTail</span></div>
        <ol class="proc">
          <li>If <i>raw</i> is <b>false</b>, then
            <ol class="block">
              <li>Let <i>tail</i> be the TV of <i>TemplateTail</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>tail</i> be the TRV of <i>TemplateTail</i>.</li>
            </ol>
          </li>
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the single element, <i>tail</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateSpans</span> <span class="geq">:</span> <span class="nt">TemplateMiddleList</span> <span class="nt">TemplateTail</span></div>
        <ol class="proc">
          <li>Let <i>middle</i> be TemplateStrings of <i>TemplateMiddleList</i> with argument <i>raw</i>.</li>
          <li>If <i>raw</i> is <b>false</b>, then
            <ol class="block">
              <li>Let <i>tail</i> be the TV of <i>TemplateTail</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>tail</i> be the TRV of <i>TemplateTail</i>.</li>
            </ol>
          </li>
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the elements, in order, of
              <i>middle</i> followed by <i>tail</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateMiddleList</span> <span class="geq">:</span> <span class="nt">TemplateMiddle</span> <span class="nt">Expression</span></div>
        <ol class="proc">
          <li>If <i>raw</i> is <b>false</b>, then
            <ol class="block">
              <li>Let <i>string</i> be the TV of <i>TemplateMiddle</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>string</i> be the TRV of <i>TemplateMiddle</i>.</li>
            </ol>
          </li>
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the single element,
              <i>string</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateMiddleList</span> <span class="geq">:</span> <span class="nt">TemplateMiddleList</span> <span class="nt">TemplateMiddle</span> <span class="nt">Expression</span></div>
        <ol class="proc">
          <li>Let <i>front</i> be TemplateStrings of <i>TemplateMiddleList</i> with argument <i>raw</i>.</li>
          <li>If <i>raw</i> is <b>false</b>, then
            <ol class="block">
              <li>Let <i>last</i> be the TV of <i>TemplateMiddle</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>last</i> be the TRV of <i>TemplateMiddle</i>.</li>
            </ol>
          </li>
          <li>Append <i>last</i> as the last element of the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>
              <i>front</i>.</li>
          <li>Return <i>front</i>.</li>
        </ol>
      </section>

      <section id="sec-template-literals-runtime-semantics-argumentlistevaluation">
        <h4 id="sec-12.2.9.2" title="12.2.9.2"> Runtime Semantics: ArgumentListEvaluation</h4><p>See also: <a href="#sec-argument-lists-runtime-semantics-argumentlistevaluation">12.3.6.1</a></p>

        <div class="gp prod"><span class="nt">TemplateLiteral</span> <span class="geq">:</span> <span class="nt">NoSubstitutionTemplate</span></div>
        <ol class="proc">
          <li>Let <i>templateLiteral</i> be this <i>TemplateLiteral.</i></li>
          <li>Let <i>siteObj</i> be <a href="#sec-gettemplateobject">GetTemplateObject</a>(<i>templateLiteral</i>).</li>
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the one element which is
              <i>siteObj</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateLiteral</span> <span class="geq">:</span> <span class="nt">TemplateHead</span> <span class="nt">Expression</span> <span class="nt">TemplateSpans</span></div>
        <ol class="proc">
          <li>Let <i>templateLiteral</i> be this <i>TemplateLiteral.</i></li>
          <li>Let <i>siteObj</i> be <a href="#sec-gettemplateobject">GetTemplateObject</a>(<i>templateLiteral</i>).</li>
          <li>Let <i>firstSub</i> be the result of  evaluating <i>Expression</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>firstSub</i>).</li>
          <li>Let <i>restSub</i> be SubstitutionEvaluation of <i>TemplateSpans</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>restSub</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>restSub</i> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose first element is <i>siteObj</i>, whose
              second elements is <i>firstSub</i>, and whose subsequent elements are the elements of <i>restSub</i>, in order.
              <i>restSub</i> may contain no elements.</li>
        </ol>
      </section>

      <section id="sec-gettemplateobject">
        <h4 id="sec-12.2.9.3" title="12.2.9.3"> Runtime Semantics: GetTemplateObject ( templateLiteral )</h4><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">GetTemplateObject</span> is
        called with a grammar production, <var>templateLiteral</var>, as an argument. It performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>rawStrings</i> be TemplateStrings of <i>templateLiteral</i> with argument <b>true</b>.</li>
          <li>Let <i>ctx</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li>Let <i>realm</i> be the <i>ctx</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>.</li>
          <li>Let <i>templateRegistry</i> be <i>realm</i>.[[templateMap]].</li>
          <li>For each element  <i>e</i> of <i>templateRegistry</i>, do
            <ol class="block">
              <li>If <i>e</i>.[[strings]] and <i>rawStrings</i> contain the same values in the same order, then
                <ol class="block">
                  <li>Return <i>e.</i>[[array]].</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>cookedStrings</i> be TemplateStrings of <i>templateLiteral</i> with argument <b>false</b>.</li>
          <li>Let <i>count</i> be the number of elements in the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>
              <i>cookedStrings</i>.</li>
          <li>Let <i>template</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(<i>count</i>).</li>
          <li>Let <i>rawObj</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(<i>count</i>).</li>
          <li>Let <i>index</i> be 0.</li>
          <li>Repeat while <i>index</i> &lt; <i>count</i>
            <ol class="block">
              <li>Let <i>prop</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>index</i>).</li>
              <li>Let <i>cookedValue</i> be the String value <i>cookedStrings</i>[<i>index</i>].</li>
              <li><a href="sec-abstract-operations#sec-call">Call</a> <i>template</i>.[[DefineOwnProperty]](<i>prop</i>, PropertyDescriptor{[[Value]]:
                  <i>cookedValue</i>, [[Enumerable]]: <b>true</b>, [[Writable]]: <b>false</b>, [[Configurable]]:
                  <b>false</b>})<i>.</i></li>
              <li>Let <i>rawValue</i> be the String value <i>rawStrings</i>[<i>index</i>].</li>
              <li><a href="sec-abstract-operations#sec-call">Call</a> <i>rawObj</i>.[[DefineOwnProperty]](<i>prop</i>, PropertyDescriptor{[[Value]]:
                  <i>rawValue</i>, [[Enumerable]]: <b>true</b>, [[Writable]]: <b>false</b>, [[Configurable]]:
                  <b>false</b>})<i>.</i></li>
              <li>Let <i>index</i> be <i>index</i>+1.</li>
            </ol>
          </li>
          <li>Perform <a href="sec-abstract-operations#sec-setintegritylevel">SetIntegrityLevel</a>(<i>rawObj</i>, <code>"frozen"</code>).</li>
          <li><a href="sec-abstract-operations#sec-call">Call</a> <i>template</i>.[[DefineOwnProperty]](<code>"raw"</code>, PropertyDescriptor{[[Value]]:
              <i>rawObj</i>, [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
              <b>false</b>})<i>.</i></li>
          <li>Perform <a href="sec-abstract-operations#sec-setintegritylevel">SetIntegrityLevel</a>(<i>template</i>, <code>"frozen"</code>).</li>
          <li>Append the Record{[[strings]]: <i>rawStrings</i>, [[array]]: <i>template</i>} to <i>templateRegistry</i>.</li>
          <li>Return <i>template</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The creation of a template object cannot result in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> Each <span class="nt">TemplateLiteral</span> in the program code of a <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> is associated with a unique template object that is used in the evaluation of tagged
          Templates (<a href="#sec-template-literals-runtime-semantics-evaluation">12.2.9.5</a>). The template objects are frozen
          and the same template object is used each time a specific tagged Template is evaluated. Whether template objects are
          created lazily upon first evaluation of the <span class="nt">TemplateLiteral</span> or eagerly prior to first evaluation
          is an implementation choice that is not observable to ECMAScript code.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> Future editions of this specification may define additional non-enumerable properties
          of template objects.</p>
        </div>
      </section>

      <section id="sec-runtime-semantics-substitutionevaluation">
        <h4 id="sec-12.2.9.4" title="12.2.9.4"> Runtime Semantics: SubstitutionEvaluation</h4><div class="gp prod"><span class="nt">TemplateSpans</span> <span class="geq">:</span> <span class="nt">TemplateTail</span></div>
        <ol class="proc">
          <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateSpans</span> <span class="geq">:</span> <span class="nt">TemplateMiddleList</span> <span class="nt">TemplateTail</span></div>
        <ol class="proc">
          <li>Return the result of SubstitutionEvaluation of <i>TemplateMiddleList</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateMiddleList</span> <span class="geq">:</span> <span class="nt">TemplateMiddle</span> <span class="nt">Expression</span></div>
        <ol class="proc">
          <li>Let <i>sub</i> be the result of evaluating <i>Expression</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>sub</i>).</li>
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing only <i>sub</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateMiddleList</span> <span class="geq">:</span> <span class="nt">TemplateMiddleList</span> <span class="nt">TemplateMiddle</span> <span class="nt">Expression</span></div>
        <ol class="proc">
          <li>Let <i>preceding</i> be the result of SubstitutionEvaluation of <i>TemplateMiddleList</i> .</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>preceding</i>).</li>
          <li>Let <i>next</i>  be the result of evaluating <i>Expression</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
          <li>Append <i>next</i> as the last element of the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>
              <i>preceding</i>.</li>
          <li>Return <i>preceding</i>.</li>
        </ol>
      </section>

      <section id="sec-template-literals-runtime-semantics-evaluation">
        <h4 id="sec-12.2.9.5" title="12.2.9.5"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">TemplateLiteral</span> <span class="geq">:</span> <span class="nt">NoSubstitutionTemplate</span></div>
        <ol class="proc">
          <li>Return the String value whose code  units are the elements of the TV of <i>NoSubstitutionTemplate</i> as defined in
              <a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">11.8.6</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateLiteral</span> <span class="geq">:</span> <span class="nt">TemplateHead</span> <span class="nt">Expression</span> <span class="nt">TemplateSpans</span></div>
        <ol class="proc">
          <li>Let <i>head</i> be the TV of <i>TemplateHead</i> as defined in <a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">11.8.6</a>.</li>
          <li>Let <i>sub</i> be the result of evaluating <i>Expression</i>.</li>
          <li>Let <i>middle</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>sub</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>middle</i>).</li>
          <li>Let <i>tail</i> be the result of evaluating <i>TemplateSpans</i> .</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>tail</i>).</li>
          <li>Return the String value whose code units are the elements  of <i>head</i> followed by the elements of <i>middle</i>
              followed by the elements of <i>tail</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The string conversion semantics applied to the <span class="nt">Expression</span>
          value are like <code><a href="sec-text-processing#sec-string.prototype.concat">String.prototype.concat</a></code> rather than the
          <code>+</code> operator.</p>
        </div>

        <div class="gp prod"><span class="nt">TemplateSpans</span> <span class="geq">:</span> <span class="nt">TemplateTail</span></div>
        <ol class="proc">
          <li>Let <i>tail</i> be the TV of <i>TemplateTail</i> as defined in <a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">11.8.6</a>.</li>
          <li>Return the string consisting of the code units of <i>tail</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateSpans</span> <span class="geq">:</span> <span class="nt">TemplateMiddleList</span> <span class="nt">TemplateTail</span></div>
        <ol class="proc">
          <li>Let <i>head</i> be the result of evaluating <i>TemplateMiddleList</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>head</i>).</li>
          <li>Let <i>tail</i> be the TV of <i>TemplateTail</i> as defined in <a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">11.8.6</a>.</li>
          <li>Return the string whose code units are the elements of <i>head</i> followed by the elements of <i>tail</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TemplateMiddleList</span> <span class="geq">:</span> <span class="nt">TemplateMiddle</span> <span class="nt">Expression</span></div>
        <ol class="proc">
          <li>Let <i>head</i> be the TV of <i>TemplateMiddle</i> as defined in <a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">11.8.6</a>.</li>
          <li>Let <i>sub</i> be the result of evaluating <i>Expression</i>.</li>
          <li>Let <i>middle</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>sub</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>middle</i>).</li>
          <li>Return the sequence of code units consisting of the code units of <i>head</i> followed by the elements of
              <i>middle</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The string conversion semantics applied to the <span class="nt">Expression</span>
          value are like <code><a href="sec-text-processing#sec-string.prototype.concat">String.prototype.concat</a></code> rather than the
          <code>+</code> operator.</p>
        </div>

        <div class="gp prod"><span class="nt">TemplateMiddleList</span> <span class="geq">:</span> <span class="nt">TemplateMiddleList</span> <span class="nt">TemplateMiddle</span> <span class="nt">Expression</span></div>
        <ol class="proc">
          <li>Let <i>rest</i> be the result of evaluating <i>TemplateMiddleList</i> .</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rest</i>).</li>
          <li>Let <i>middle</i>  be the TV of <i>TemplateMiddle</i> as defined in <a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">11.8.6</a>.</li>
          <li>Let <i>sub</i> be the result of evaluating <i>Expression</i>.</li>
          <li>Let <i>last</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>sub</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>last</i>).</li>
          <li>Return the sequence of code units consisting of the elements of <i>rest</i> followed by the code units of
              <i>middle</i> followed by the elements of <i>last</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 3</span> The string conversion semantics applied to the <span class="nt">Expression</span>
          value are like <code><a href="sec-text-processing#sec-string.prototype.concat">String.prototype.concat</a></code> rather than the
          <code>+</code> operator.</p>
        </div>
      </section>
    </section>

    <section id="sec-grouping-operator">
      <div class="front">
        <h3 id="sec-12.2.10" title="12.2.10">
            The Grouping Operator</h3></div>

      <section id="sec-grouping-operator-static-semantics-early-errors">
        <h4 id="sec-12.2.10.1" title="12.2.10.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
        <ul>
          <li>
            <p>It is a Syntax Error if the lexical token sequence matched by <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span> cannot be parsed with no tokens left over using
            <span class="nt">ParenthesizedExpression</span> as the goal symbol.</p>
          </li>

          <li>
            <p>All Early Errors rules for <span class="nt">ParenthesizedExpression</span> and its derived productions also apply
            to <span style="font-family: Times New Roman">CoveredParenthesizedExpression</span> of <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span>.</p>
          </li>
        </ul>
      </section>

      <section id="sec-grouping-operator-static-semantics-isfunctiondefinition">
        <h4 id="sec-12.2.10.2" title="12.2.10.2"> Static Semantics:  IsFunctionDefinition</h4><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

        <div class="gp prod"><span class="nt">ParenthesizedExpression</span> <span class="geq">:</span> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code></div>
        <ol class="proc">
          <li>Return IsFunctionDefinition of <i>Expression</i>.</li>
        </ol>
      </section>

      <section id="sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">
        <h4 id="sec-12.2.10.3" title="12.2.10.3"> Static Semantics:  IsValidSimpleAssignmentTarget</h4><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

        <div class="gp prod"><span class="nt">ParenthesizedExpression</span> <span class="geq">:</span> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code></div>
        <ol class="proc">
          <li>Return IsValidSimpleAssignmentTarget of <i>Expression</i>.</li>
        </ol>
      </section>

      <section id="sec-grouping-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.2.10.4" title="12.2.10.4"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be CoveredParenthesizedExpression of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
          <li>Return the result of evaluating <i>expr</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ParenthesizedExpression</span> <span class="geq">:</span> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code></div>
        <ol class="proc">
          <li>Return the result of evaluating <i>Expression</i>. This may be of type <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> This algorithm does not apply <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a> to the result of
          evaluating <span class="nt">Expression</span>. The principal motivation for this is so that operators such as
          <code>delete</code> and <code>typeof</code> may be applied to parenthesized expressions.</p>
        </div>
      </section>
    </section>
  </section>

  <section id="sec-left-hand-side-expressions">
    <div class="front">
      <h2 id="sec-12.3" title="12.3"> Left-Hand-Side Expressions</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">MemberExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">PrimaryExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">[</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">]</code></div>
        <div class="rhs"><span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
        <div class="rhs"><span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">TemplateLiteral</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">SuperProperty</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">MetaProperty</span></div>
        <div class="rhs"><code class="t">new</code> <span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">Arguments</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">SuperProperty</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">super</code> <code class="t">[</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">]</code></div>
        <div class="rhs"><code class="t">super</code> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">MetaProperty</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">NewTarget</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">NewTarget</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">new</code> <code class="t">.</code> <code class="t">target</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">NewExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">new</code> <span class="nt">NewExpression</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">CallExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">Arguments</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">SuperCall</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">CallExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">Arguments</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">CallExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">[</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">]</code></div>
        <div class="rhs"><span class="nt">CallExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
        <div class="rhs"><span class="nt">CallExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">TemplateLiteral</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">SuperCall</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">super</code> <span class="nt">Arguments</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">Arguments</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">(</code> <code class="t">)</code></div>
        <div class="rhs"><code class="t">(</code> <span class="nt">ArgumentList</span><sub class="g-params">[?Yield]</sub> <code class="t">)</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ArgumentList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
        <div class="rhs"><code class="t">...</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">ArgumentList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">ArgumentList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <code class="t">...</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">NewExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">CallExpression</span><sub class="g-params">[?Yield]</sub></div>
      </div>
    </div>

    <section id="sec-static-semantics">
      <div class="front">
        <h3 id="sec-12.3.1" title="12.3.1">
            Static Semantics</h3></div>

      <section id="sec-static-semantics-static-semantics-contains">
        <h4 id="sec-12.3.1.1" title="12.3.1.1"> Static Semantics:  Contains</h4><p>With parameter <var>symbol</var>.</p>

        <p>See also: <a href="sec-notational-conventions#sec-static-semantic-rules">5.3</a>, <a href="#sec-object-initializer-static-semantics-contains">12.2.6.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-contains">14.1.4</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-contains">14.2.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-contains">14.4.4</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-contains">14.5.4</a></p>

        <div class="gp prod"><span class="nt">MemberExpression</span> <span class="geq">:</span> <span class="nt">MemberExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>If  <i>MemberExpression</i> Contains <i>symbol</i> is <b>true</b>, return <b>true</b>.</li>
          <li>If <i>symbol</i> is a <i>ReservedWord</i>, return <b>false</b>.</li>
          <li>If <i>symbol</i> is an <i>Identifier</i> and StringValue of <i>symbol</i> is the same value as the StringValue of
              <i>IdentifierName</i>, return <b>true</b>;</li>
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">SuperProperty</span> <span class="geq">:</span> <code class="t">super</code> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>If  <i>symbol</i> is the <i>ReservedWord</i> <code>super</code>, return <b>true</b>.</li>
          <li>If <i>symbol</i> is a <i>ReservedWord</i>, return <b>false</b>.</li>
          <li>If <i>symbol</i> is an <i>Identifier</i> and StringValue of <i>symbol</i> is the same value as the StringValue of
              <i>IdentifierName</i>, return <b>true</b>;</li>
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">CallExpression</span> <span class="geq">:</span> <span class="nt">CallExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>If  <i>CallExpression</i> Contains <i>symbol</i> is <b>true</b>, return <b>true</b>.</li>
          <li>If <i>symbol</i> is a <i>ReservedWord</i>, return <b>false</b>.</li>
          <li>If <i>symbol</i> is an <i>Identifier</i> and StringValue of <i>symbol</i> is the same value as the StringValue of
              <i>IdentifierName</i>, return <b>true</b>;</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-static-semantics-static-semantics-isfunctiondefinition">
        <h4 id="sec-12.3.1.2" title="12.3.1.2"> Static Semantics:  IsFunctionDefinition</h4><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">MemberExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <span class="nt">TemplateLiteral</span></div>
          <div class="rhs"><span class="nt">SuperProperty</span></div>
          <div class="rhs"><span class="nt">MetaProperty</span></div>
          <div class="rhs"><code class="t">new</code> <span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NewExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">new</code> <span class="nt">NewExpression</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">CallExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
          <div class="rhs"><span class="nt">SuperCall</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <span class="nt">Arguments</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
          <div class="rhs"><span class="nt">CallExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <span class="nt">TemplateLiteral</span></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-static-semantics-static-semantics-isdestructuring">
        <h4 id="sec-12.3.1.3" title="12.3.1.3"> Static Semantics:  IsDestructuring</h4><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-isdestructuring">13.7.5.6</a>.</p>

        <div class="gp prod"><span class="nt">MemberExpression</span> <span class="geq">:</span> <span class="nt">PrimaryExpression</span></div>
        <ol class="proc">
          <li>If <i>PrimaryExpression</i> is either an <i>ObjectLiteral</i> or an <i>ArrayLiteral</i>, return <b>true.</b></li>
          <li>Return <b>false</b>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">MemberExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <span class="nt">TemplateLiteral</span></div>
          <div class="rhs"><span class="nt">SuperProperty</span></div>
          <div class="rhs"><span class="nt">MetaProperty</span></div>
          <div class="rhs"><code class="t">new</code> <span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NewExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">new</code> <span class="nt">NewExpression</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">CallExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
          <div class="rhs"><span class="nt">SuperCall</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <span class="nt">Arguments</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
          <div class="rhs"><span class="nt">CallExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <span class="nt">TemplateLiteral</span></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-static-semantics-static-semantics-isidentifierref">
        <h4 id="sec-12.3.1.4" title="12.3.1.4"> Static Semantics:  IsIdentifierRef</h4><p>See also: <a href="#sec-semantics-static-semantics-isidentifierref">12.2.1.4</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">LeftHandSideExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">CallExpression</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">MemberExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <span class="nt">TemplateLiteral</span></div>
          <div class="rhs"><span class="nt">SuperProperty</span></div>
          <div class="rhs"><span class="nt">MetaProperty</span></div>
          <div class="rhs"><code class="t">new</code> <span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NewExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">new</code> <span class="nt">NewExpression</span></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">
        <h4 id="sec-12.3.1.5" title="12.3.1.5"> Static Semantics:  IsValidSimpleAssignmentTarget</h4><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">CallExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
          <div class="rhs"><span class="nt">CallExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">MemberExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
          <div class="rhs"><span class="nt">SuperProperty</span></div>
        </div>

        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>

        <div class="gp">
          <div class="lhs">ç<span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
          <div class="rhs"><span class="nt">SuperCall</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <span class="nt">Arguments</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <span class="nt">TemplateLiteral</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NewExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">new</code> <span class="nt">NewExpression</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">MemberExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <span class="nt">TemplateLiteral</span></div>
          <div class="rhs"><code class="t">new</code> <span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NewTarget</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">new</code> <code class="t">.</code> <code class="t">target</code></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-property-accessors">
      <h3 id="sec-12.3.2" title="12.3.2">
          Property Accessors</h3><div class="note">
        <p><span class="nh">NOTE</span> Properties are accessed by name, using either the dot notation:</p>

        <div class="rhs"><span class="nt">MemberExpression</span> <code>.</code> <span class="nt">IdentifierName</span><br /> <span class="nt">CallExpression</span> <code>.</code> <span class="nt">IdentifierName</span></div>

        <p>or the bracket notation:</p>

        <div class="rhs"><span class="nt">MemberExpression</span> <code>[</code> <span class="nt">Expression</span> <code>]</code><br /><span class="nt">CallExpression</span> <code>[</code> <span class="nt">Expression</span> <code>]</code></div>

        <p>The dot notation is explained by the following syntactic conversion:</p>

        <div class="rhs"><span class="nt">MemberExpression</span> <code>.</code> <span class="nt">IdentifierName</span></div>

        <p>is identical in its behaviour to</p>

        <div class="rhs"><span class="nt">MemberExpression</span> <code>[</code> &lt;<i>identifier-name-string</i>&gt; <code>]</code></div>

        <p>and similarly</p>

        <div class="rhs"><span class="nt">CallExpression</span> <code>.</code> <span class="nt">IdentifierName</span></div>

        <p>is identical in its behaviour to</p>

        <div class="rhs"><span class="nt">CallExpression</span> <code>[</code> &lt;<i>identifier-name-string</i>&gt; <code>]</code></div>

        <p>where <var>&lt;<i>identifier-name-string</i>&gt;</var> is the result of evaluating StringValue of <span class="nt">IdentifierName</span>.</p>

        <section id="sec-property-accessors-runtime-semantics-evaluation">
          <h4 id="sec-12.3.2.1" title="12.3.2.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">MemberExpression</span> <span class="geq">:</span> <span class="nt">MemberExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
          <ol class="proc">
            <li>Let <i>baseReference</i> be the result of evaluating <i>MemberExpression</i>.</li>
            <li>Let <i>baseValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>baseReference</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>baseValue</i>).</li>
            <li>Let <i>propertyNameReference</i> be the result of evaluating <i>Expression</i>.</li>
            <li>Let <i>propertyNameValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>propertyNameReference</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propertyNameValue</i>).</li>
            <li>Let <i>bv</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<i>baseValue</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>bv</i>).</li>
            <li>Let <i>propertyKey</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>propertyNameValue</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propertyKey</i>).</li>
            <li>If the code matched by the syntactic production that is being evaluated is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
                mode code</a>, let <i>strict</i> be <b>true</b>, else let <i>strict</i> be <b>false</b>.</li>
            <li>Return a value of type <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> whose base value is <i>bv</i> and
                whose referenced name is <i>propertyKey</i>, and whose strict reference flag is <i>strict</i>.</li>
          </ol>
          <div class="gp prod"><span class="nt">MemberExpression</span> <span class="geq">:</span> <span class="nt">MemberExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
          <ol class="proc">
            <li>Let <i>baseReference</i> be the result of evaluating <i>MemberExpression</i>.</li>
            <li>Let <i>baseValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>baseReference</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>baseValue</i>).</li>
            <li>Let <i>bv</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<i>baseValue</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>bv</i>).</li>
            <li>Let <i>propertyNameString</i> be StringValue of <i>IdentifierName</i></li>
            <li>If the code matched by the syntactic production that is being evaluated is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
                mode code</a>, let <i>strict</i> be <b>true</b>, else let <i>strict</i> be <b>false</b>.</li>
            <li>Return a value of type <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> whose base value is <i>bv</i> and
                whose referenced name is <i>propertyNameString</i>, and whose strict reference flag is <i>strict</i>.</li>
          </ol>
          <div class="gp prod"><span class="nt">CallExpression</span> <span class="geq">:</span> <span class="nt">CallExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>

          <p>Is evaluated in exactly the same manner as <span class="prod"><span class="nt">MemberExpression</span> <span class="geq">:</span> <span class="nt">MemberExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></span> except that the contained <span class="nt">CallExpression</span> is evaluated in step 1.</p>

          <div class="gp prod"><span class="nt">CallExpression</span> <span class="geq">:</span> <span class="nt">CallExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>

          <p>Is evaluated in exactly the same manner as <span class="prod"><span class="nt">MemberExpression</span> <span class="geq">:</span> <span class="nt">MemberExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></span>  except that the contained <span class="nt">CallExpression</span> is evaluated
          in step 1.</p>
        </section>
      </div>
    </section>

    <section id="sec-new-operator">
      <div class="front">
        <h3 id="sec-12.3.3" title="12.3.3"> The
            </h3></div>

      <section id="sec-new-operator-runtime-semantics-evaluation">
        <div class="front">
          <h4 id="sec-12.3.3.1" title="12.3.3.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">NewExpression</span> <span class="geq">:</span> <code class="t">new</code> <span class="nt">NewExpression</span></div>
          <ol class="proc">
            <li>Return <a href="#sec-evaluatenew">EvaluateNew</a>(<i>NewExpression</i>, <span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>
          <div class="gp prod"><span class="nt">MemberExpression</span> <span class="geq">:</span> <code class="t">new</code> <span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
          <ol class="proc">
            <li>Return <a href="#sec-evaluatenew">EvaluateNew</a>(<i>MemberExpression</i>, <i>Arguments</i>).</li>
          </ol>
        </div>

        <section id="sec-evaluatenew">
          <h5 id="sec-12.3.3.1.1" title="12.3.3.1.1"> Runtime Semantics: EvaluateNew(constructProduction,
              arguments)</h5><p class="normalbefore">The abstract operation EvaluateNew with arguments <span style="font-family: Times New           Roman"><i>constructProduction</i>,</span> and <var>arguments</var> performs the following steps:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>constructProduction</i> is either a <i>NewExpression</i> or a
                <i>MemberExpression</i>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>arguments</i> is either <span style="font-family:                 sans-serif">empty</span> or an <i>Arguments</i> production.</li>
            <li>Let <i>ref</i> be the result of evaluating  <i>constructProduction</i>.</li>
            <li>Let <i>constructor</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>ref</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>constructor</i>).</li>
            <li>If <i>arguments</i> is <span style="font-family: sans-serif">empty</span>, let <i>argList</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>Else,
              <ol class="block">
                <li>Let <i>argList</i> be ArgumentListEvaluation of <i>arguments</i>.</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>argList</i>).</li>
              </ol>
            </li>
            <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a> (<i>constructor</i>) is <b>false</b>, throw a <b>TypeError</b>
                exception.</li>
            <li>Return <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>constructor</i>, <i>argList</i>).</li>
          </ol>
        </section>
      </section>
    </section>

    <section id="sec-function-calls">
      <div class="front">
        <h3 id="sec-12.3.4" title="12.3.4">
            Function Calls</h3></div>

      <section id="sec-function-calls-runtime-semantics-evaluation">
        <h4 id="sec-12.3.4.1" title="12.3.4.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">CallExpression</span> <span class="geq">:</span> <span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
        <ol class="proc">
          <li>Let <i>ref</i> be the result of evaluating <i>MemberExpression</i>.</li>
          <li>Let <i>func</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>ref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>func</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>ref</i>) is <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> and <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">IsPropertyReference</a>(<i>ref</i>) is <b>false</b> and <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">GetReferencedName</a>(<i>ref</i>) <i>is</i> <code>"eval"</code>, then
            <ol class="block">
              <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>func</i>, %eval%) is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>argList</i> be ArgumentListEvaluation(<i>Arguments</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>argList</i>).</li>
                  <li>If <i>argList</i> has no elements, return <b>undefined.</b></li>
                  <li>Let <i>evalText</i> be the first element of <i>argList</i>.</li>
                  <li>If the source code matching this <i>CallExpression</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict code</a>,
                      let <i>strictCaller</i> be <b>true.</b> Otherwise let <i>strictCaller</i> be <b>false.</b></li>
                  <li>Let <i>evalRealm</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>.</li>
                  <li>Return <a href="sec-global-object#sec-performeval">PerformEval</a>(<i>evalText</i>, <i>evalRealm</i>, <i>strictCaller</i>,
                      <b>true</b>). .</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>ref</i>) is <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a>, then
            <ol class="block">
              <li>If <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">IsPropertyReference</a>(<i>ref</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>thisValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getthisvalue">GetThisValue</a>(<i>ref</i>).</li>
                </ol>
              </li>
              <li>Else, the base of <i>ref</i> is an <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>
                <ol class="block">
                  <li>Let <i>refEnv</i> be <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">GetBase</a>(<i>ref</i>).</li>
                  <li>Let <i>thisValue</i> be <i>refEnv</i>.WithBaseObject().</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Else <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>ref</i>) is not <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a>,
            <ol class="block">
              <li>Let <i>thisValue</i> be <b>undefined</b>.</li>
            </ol>
          </li>
          <li>Let <i>thisCall</i> be this <i>CallExpression</i>.</li>
          <li>Let <i>tailCall</i> be <a href="sec-ecmascript-language-functions-and-classes#sec-isintailposition">IsInTailPosition</a>(<i>thisCall</i>). (See <a href="sec-ecmascript-language-functions-and-classes#sec-isintailposition">14.6.1</a>)</li>
          <li>Return <a href="#sec-evaluatedirectcall">EvaluateDirectCall</a>(<i>func</i>, <i>thisValue</i>, <i>Arguments</i>,
              <i>tailCall</i>).</li>
        </ol>

        <p>A <span class="nt">CallExpression</span> evaluation that executes step 4.a.vii is a <i>direct eval</i>.</p>

        <div class="gp prod"><span class="nt">CallExpression</span> <span class="geq">:</span> <span class="nt">CallExpression</span> <span class="nt">Arguments</span></div>
        <ol class="proc">
          <li>Let <i>ref</i> be the result of evaluating <i>CallExpression</i>.</li>
          <li>Let <i>thisCall</i> be this <i>CallExpression</i></li>
          <li>Let <i>tailCall</i> be <a href="sec-ecmascript-language-functions-and-classes#sec-isintailposition">IsInTailPosition</a>(<i>thisCall</i>). (See <a href="sec-ecmascript-language-functions-and-classes#sec-isintailposition">14.6.1</a>)</li>
          <li>Return <a href="#sec-evaluatecall">EvaluateCall</a>(<i>ref</i>, <i>Arguments</i>, <i>tailCall</i>).</li>
        </ol>
      </section>

      <section id="sec-evaluatecall">
        <h4 id="sec-12.3.4.2" title="12.3.4.2">
            Runtime Semantics: EvaluateCall( ref, arguments, tailPosition )</h4><p class="normalbefore">The abstract operation EvaluateCall takes as arguments a value <var>ref</var>, a syntactic grammar
        production <var>arguments</var>,  and a Boolean argument <var>tailPosition</var>. It performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>func</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>ref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>func</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>ref</i>) is <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a>, then
            <ol class="block">
              <li>If <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">IsPropertyReference</a>(<i>ref</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>thisValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getthisvalue">GetThisValue</a>(<i>ref</i>).</li>
                </ol>
              </li>
              <li>Else, the base of <i>ref</i> is an <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>
                <ol class="block">
                  <li>Let <i>refEnv</i> be <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">GetBase</a>(<i>ref</i>).</li>
                  <li>Let <i>thisValue</i> be <i>refEnv</i>.WithBaseObject().</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Else <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>ref</i>) is not <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a>,
            <ol class="block">
              <li>Let <i>thisValue</i> be <b>undefined</b>.</li>
            </ol>
          </li>
          <li>Return <a href="#sec-evaluatedirectcall">EvaluateDirectCall</a>(<i>func</i>, <i>thisValue</i>, <i>arguments</i>,
              <i>tailPosition</i>).</li>
        </ol>
      </section>

      <section id="sec-evaluatedirectcall">
        <h4 id="sec-12.3.4.3" title="12.3.4.3"> Runtime Semantics: EvaluateDirectCall( func, thisValue, arguments,
            tailPosition )</h4><p class="normalbefore">The abstract operation EvaluateDirectCall takes as arguments a value <var>func</var>, a value
        <var>thisValue</var>, a syntactic grammar production <var>arguments</var>, and a Boolean argument <var>tailPosition</var>.
        It performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>argList</i> be ArgumentListEvaluation(<i>arguments</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>argList</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>func</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>func</i>) is <b>false</b>, throw a <b>TypeError</b> exception.</li>
          <li>If <i>tailPosition</i> is <b>true</b>, perform <a href="sec-ecmascript-language-functions-and-classes#sec-preparefortailcall">PrepareForTailCall</a>().</li>
          <li>Let <i>result</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>func</i>, <i>thisValue</i>, <i>argList</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: If <i>tailPosition</i> is <b>true</b>, the above call will not
              return here, but instead evaluation will continue as if the following return has already occurred.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: If <i>result</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> then <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>result</i>) is an <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language type</a>.</li>
          <li>Return <i>result</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-super-keyword">
      <div class="front">
        <h3 id="sec-12.3.5" title="12.3.5"> The
            </h3></div>

      <section id="sec-super-keyword-runtime-semantics-evaluation">
        <h4 id="sec-12.3.5.1" title="12.3.5.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">SuperProperty</span> <span class="geq">:</span> <code class="t">super</code> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>propertyNameReference</i> be the result of evaluating <i>Expression</i>.</li>
          <li>Let <i>propertyNameValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>propertyNameReference</i>).</li>
          <li>Let <i>propertyKey</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>propertyNameValue</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propertyKey</i>).</li>
          <li>If the code matched by the syntactic production that is being evaluated is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
              mode code</a>, let <i>strict</i> be <b>true</b>, else let <i>strict</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-makesuperpropertyreference">MakeSuperPropertyReference</a>(<i>propertyKey</i>,
              <i>strict</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">SuperProperty</span> <span class="geq">:</span> <code class="t">super</code> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Let <i>propertyKey</i> be StringValue of <i>IdentifierName</i>.</li>
          <li>If the code matched by the syntactic production that is being evaluated is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
              mode code</a>, let <i>strict</i> be <b>true</b>, else let <i>strict</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-makesuperpropertyreference">MakeSuperPropertyReference</a>(<i>propertyKey</i>,
              <i>strict</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">SuperCall</span> <span class="geq">:</span> <code class="t">super</code> <span class="nt">Arguments</span></div>
        <ol class="proc">
          <li>Let <i>newTarget</i> be <a href="sec-executable-code-and-execution-contexts#sec-getnewtarget">GetNewTarget</a>().</li>
          <li>If <i>newTarget</i> is <b>undefined</b>, throw a <b>ReferenceError</b> exception.</li>
          <li>Let <i>func</i> be <a href="#sec-getsuperconstructor">GetSuperConstructor</a>().</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>func</i>).</li>
          <li>Let <i>argList</i> be ArgumentListEvaluation of <i>Arguments</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>argList</i>).</li>
          <li>Let <i>result</i> be <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>func</i>, <i>argList</i>, <i>newTarget</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
          <li>Let <i>thisER</i> be <a href="sec-executable-code-and-execution-contexts#sec-getthisenvironment">GetThisEnvironment</a>( ).</li>
          <li>Return <i>thisER</i>.<a href="sec-executable-code-and-execution-contexts#sec-bindthisvalue">BindThisValue</a>(<i>result</i>).</li>
        </ol>
      </section>

      <section id="sec-getsuperconstructor">
        <h4 id="sec-12.3.5.2" title="12.3.5.2"> Runtime Semantics: GetSuperConstructor ( )</h4><p class="normalbefore">The abstract operation GetSuperConstructor performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>envRec</i> be <a href="sec-executable-code-and-execution-contexts#sec-getthisenvironment">GetThisEnvironment</a>( ).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> is a function <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>.</li>
          <li>Let <i>activeFunction</i> be <i>envRec</i>.[[FunctionObject]].</li>
          <li>Let <i>superConstructor</i> be <i>activeFunction</i>.[[GetPrototypeOf]]().</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>superConstructor</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>superConstructor</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Return <i>superConstructor</i>.</li>
        </ol>
      </section>

      <section id="sec-makesuperpropertyreference">
        <h4 id="sec-12.3.5.3" title="12.3.5.3"> Runtime Semantics: MakeSuperPropertyReference(propertyKey,
            strict)</h4><p class="normalbefore">The abstract operation MakeSuperPropertyReference with arguments <var>propertyKey</var> and
        <var>strict</var> performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>env</i> be <a href="sec-executable-code-and-execution-contexts#sec-getthisenvironment">GetThisEnvironment</a>( ).</li>
          <li>If <i>env</i>.HasSuperBinding() is <b>false</b>, throw a <b>ReferenceError</b> exception.</li>
          <li>Let <i>actualThis</i> be <i>env</i>.GetThisBinding().</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>actualThis</i>).</li>
          <li>Let <i>baseValue</i> be <i>env</i>.<a href="sec-executable-code-and-execution-contexts#sec-getsuperbase">GetSuperBase</a>().</li>
          <li>Let <i>bv</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<i>baseValue</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>bv</i>).</li>
          <li>Return a value of type <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> that is a Super <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> whose base value is <i>bv</i>, whose referenced name is
              <i>propertyKey</i>, whose thisValue is <i>actualThis</i>, and whose strict reference flag is <i>strict</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-argument-lists">
      <div class="front">
        <h3 id="sec-12.3.6" title="12.3.6">
            Argument Lists</h3><div class="note">
          <p><span class="nh">NOTE</span> The evaluation of an argument list produces a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of values (<a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">see
          6.2.1</a>).</p>
        </div>
      </div>

      <section id="sec-argument-lists-runtime-semantics-argumentlistevaluation">
        <h4 id="sec-12.3.6.1" title="12.3.6.1"> Runtime Semantics: ArgumentListEvaluation</h4><p>See also: <a href="#sec-template-literals-runtime-semantics-argumentlistevaluation">12.2.9.2</a></p>

        <div class="gp prod"><span class="nt">Arguments</span> <span class="geq">:</span> <code class="t">(</code> <code class="t">)</code></div>
        <ol class="proc">
          <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArgumentList</span> <span class="geq">:</span> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Let <i>ref</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
          <li>Let <i>arg</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>ref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>arg</i>).</li>
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose sole item is <i>arg</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArgumentList</span> <span class="geq">:</span> <code class="t">...</code> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Let <i>list</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>spreadRef</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
          <li>Let <i>spreadObj</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>spreadRef</i>).</li>
          <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>spreadObj</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iterator</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, return <i>list</i>.</li>
              <li>Let <i>nextArg</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextArg</i>).</li>
              <li>Append <i>nextArg</i> as the last element of <i>list</i>.</li>
            </ol>
          </li>
        </ol>
        <div class="gp prod"><span class="nt">ArgumentList</span> <span class="geq">:</span> <span class="nt">ArgumentList</span> <code class="t">,</code> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Let <i>precedingArgs</i> be the result of evaluating <i>ArgumentList</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>precedingArgs</i>).</li>
          <li>Let <i>ref</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
          <li>Let <i>arg</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>ref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>arg</i>).</li>
          <li>Append <i>arg</i> to the end of <i>precedingArgs</i>.</li>
          <li>Return <i>precedingArgs</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArgumentList</span> <span class="geq">:</span> <span class="nt">ArgumentList</span> <code class="t">,</code> <code class="t">...</code> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Let <i>precedingArgs</i> be the result of evaluating <i>ArgumentList</i>.</li>
          <li>Let <i>spreadRef</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
          <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>spreadRef</i>) ).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iterator</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, return <i>precedingArgs</i>.</li>
              <li>Let <i>nextArg</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextArg</i>).</li>
              <li>Append <i>nextArg</i> as the last element of <i>precedingArgs</i>.</li>
            </ol>
          </li>
        </ol>
      </section>
    </section>

    <section id="sec-tagged-templates">
      <div class="front">
        <h3 id="sec-12.3.7" title="12.3.7">
            Tagged Templates</h3><div class="note">
          <p><span class="nh">NOTE</span> A tagged template is a function call where the arguments of the call are derived from a
          <span class="nt">TemplateLiteral</span> (<a href="#sec-template-literals">12.2.9</a>). The actual arguments include a
          template object (<a href="#sec-gettemplateobject">12.2.9.3</a>) and the values produced by evaluating the expressions
          embedded within the <span class="nt">TemplateLiteral</span>.</p>
        </div>
      </div>

      <section id="sec-tagged-templates-runtime-semantics-evaluation">
        <h4 id="sec-12.3.7.1" title="12.3.7.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">MemberExpression</span> <span class="geq">:</span> <span class="nt">MemberExpression</span> <span class="nt">TemplateLiteral</span></div>
        <ol class="proc">
          <li>Let <i>tagRef</i> be the result of evaluating <i>MemberExpression</i>.</li>
          <li>Let <i>thisCall</i> be this <i>MemberExpression</i>.</li>
          <li>Let <i>tailCall</i> be <a href="sec-ecmascript-language-functions-and-classes#sec-isintailposition">IsInTailPosition</a>(<i>thisCall</i>). (See <a href="sec-ecmascript-language-functions-and-classes#sec-isintailposition">14.6.1</a>)</li>
          <li>Return <a href="#sec-evaluatecall">EvaluateCall</a>(<i>tagRef</i>, <i>TemplateLiteral</i>, <i>tailCall</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">CallExpression</span> <span class="geq">:</span> <span class="nt">CallExpression</span> <span class="nt">TemplateLiteral</span></div>
        <ol class="proc">
          <li>Let <i>tagRef</i> be the result of evaluating <i>CallExpression</i>.</li>
          <li>Let <i>thisCall</i> be this <i>CallExpression</i>.</li>
          <li>Let <i>tailCall</i> be <a href="sec-ecmascript-language-functions-and-classes#sec-isintailposition">IsInTailPosition</a>(<i>thisCall</i>). (See <a href="sec-ecmascript-language-functions-and-classes#sec-isintailposition">14.6.1</a>)</li>
          <li>Return <a href="#sec-evaluatecall">EvaluateCall</a>(<i>tagRef</i>, <i>TemplateLiteral</i>, <i>tailCall</i>).</li>
        </ol>
      </section>
    </section>

    <section id="sec-meta-properties">
      <div class="front">
        <h3 id="sec-12.3.8" title="12.3.8">
            Meta Properties</h3></div>

      <section id="sec-meta-properties-runtime-semantics-evaluation">
        <h4 id="sec-12.3.8.1" title="12.3.8.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">NewTarget</span> <span class="geq">:</span> <code class="t">new</code> <code class="t">.</code> <code class="t">target</code></div>
        <ol class="proc">
          <li>Return <a href="sec-executable-code-and-execution-contexts#sec-getnewtarget">GetNewTarget</a>().</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-postfix-expressions">
    <div class="front">
      <h2 id="sec-12.4" title="12.4">
          Postfix Expressions</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">PostfixExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">++</code></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">--</code></div>
      </div>
    </div>

    <section id="sec-postfix-expressions-static-semantics-early-errors">
      <h3 id="sec-12.4.1" title="12.4.1"> Static Semantics:  Early Errors</h3><div class="gp">
        <div class="lhs"><span class="nt">PostfixExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">++</code></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">--</code></div>
      </div>

      <ul>
        <li>
          <p>It is an early <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> Error if <span style="font-family: Times New           Roman">IsValidSimpleAssignmentTarget</span> of <span class="nt">LeftHandSideExpression</span> is <span class="value">false</span>.</p>
        </li>
      </ul>
    </section>

    <section id="sec-postfix-expressions-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.4.2" title="12.4.2"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a></p>

      <div class="gp">
        <div class="lhs"><span class="nt">PostfixExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">++</code></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">--</code></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.4.3" title="12.4.3"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">PostfixExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">++</code></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">--</code></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-postfix-increment-operator">
      <div class="front">
        <h3 id="sec-12.4.4" title="12.4.4"> Postfix Increment Operator</h3></div>

      <section id="sec-postfix-increment-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.4.4.1" title="12.4.4.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">PostfixExpression</span> <span class="geq">:</span> <span class="nt">LeftHandSideExpression</span> <code class="t">++</code></div>
        <ol class="proc">
          <li>Let <i>lhs</i> be the result of evaluating <i>LeftHandSideExpression</i>.</li>
          <li>Let <i>oldValue</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lhs</i>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>oldValue</i>).</li>
          <li>Let <i>newValue</i> be the result of adding the value <code>1</code> to <i>oldValue</i>, using the same rules as for
              the <code>+</code> operator (<a href="#sec-applying-the-additive-operators-to-numbers">see 12.7.5</a>).</li>
          <li>Let <i>status</i> be <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lhs</i>, <i>newValue</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return <i>oldValue</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-postfix-decrement-operator">
      <div class="front">
        <h3 id="sec-12.4.5" title="12.4.5"> Postfix Decrement Operator</h3></div>

      <section id="sec-postfix-decrement-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.4.5.1" title="12.4.5.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">PostfixExpression</span> <span class="geq">:</span> <span class="nt">LeftHandSideExpression</span> <code class="t">--</code></div>
        <ol class="proc">
          <li>Let <i>lhs</i> be the result of evaluating <i>LeftHandSideExpression</i>.</li>
          <li>Let <i>oldValue</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lhs</i>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>oldValue</i>).</li>
          <li>Let <i>newValue</i> be the result of subtracting the value <code>1</code> from <i>oldValue</i>, using the same rules
              as for the <code>-</code> operator (<a href="#sec-applying-the-additive-operators-to-numbers">12.7.5</a>).</li>
          <li>Let <i>status</i> be <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lhs</i>, <i>newValue</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return <i>oldValue</i>.</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-unary-operators">
    <div class="front">
      <h2 id="sec-12.5" title="12.5"> Unary
          Operators</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">UnaryExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">PostfixExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">delete</code> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">void</code> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">typeof</code> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">++</code> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">--</code> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">+</code> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">-</code> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">~</code> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">!</code> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
      </div>
    </div>

    <section id="sec-unary-operators-static-semantics-early-errors">
      <h3 id="sec-12.5.1" title="12.5.1"> Static Semantics:  Early Errors</h3><div class="gp">
        <div class="lhs"><span class="nt">UnaryExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">++</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">--</code> <span class="nt">UnaryExpression</span></div>
      </div>

      <ul>
        <li>
          <p>It is an early <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> Error if <span style="font-family: Times New           Roman">IsValidSimpleAssignmentTarget</span> of <span class="nt">UnaryExpression</span> is <span class="value">false</span>.</p>
        </li>
      </ul>
    </section>

    <section id="sec-unary-operators-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.5.2" title="12.5.2"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">UnaryExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">delete</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">void</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">typeof</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">++</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">--</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">+</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">-</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">~</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">!</code> <span class="nt">UnaryExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.5.3" title="12.5.3"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">UnaryExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">delete</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">void</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">typeof</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">++</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">--</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">+</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">-</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">~</code> <span class="nt">UnaryExpression</span></div>
        <div class="rhs"><code class="t">!</code> <span class="nt">UnaryExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-delete-operator">
      <div class="front">
        <h3 id="sec-12.5.4" title="12.5.4"> The
            </h3></div>

      <section id="sec-delete-operator-static-semantics-early-errors">
        <h4 id="sec-12.5.4.1" title="12.5.4.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">UnaryExpression</span> <span class="geq">:</span> <code class="t">delete</code> <span class="nt">UnaryExpression</span></div>
        <ul>
          <li>
            <p>It is a Syntax Error if the <span class="nt">UnaryExpression</span> is contained in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> and the derived <span class="nt">UnaryExpression</span> is <span class="prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span></span>
            <var>IdentifierReference.</var></p>
          </li>

          <li>
            <p>It is a Syntax Error if the derived <span class="nt">UnaryExpression</span> is<br />      <span style="font-family:             Times New Roman"><i>PrimaryExpression : CoverParenthesizedExpressionAndArrowParameterList<br /></i></span>and <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span> ultimately derives a phrase that, if used in place
            of <var>UnaryExpression,</var> would produce a Syntax Error according to these rules. This rule is recursively
            applied.</p>
          </li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> The last rule means that expressions such as<br />&#x9;&#x9;<code>delete
          (((foo)))</code><br />produce early errors because of recursive application of the first rule.</p>
        </div>
      </section>

      <section id="sec-delete-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.5.4.2" title="12.5.4.2"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">UnaryExpression</span> <span class="geq">:</span> <code class="t">delete</code> <span class="nt">UnaryExpression</span></div>
        <ol class="proc">
          <li>Let <i>ref</i> be the result of evaluating <i>UnaryExpression</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>ref</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>ref</i>) is not <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a>, return <b>true</b>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">IsUnresolvableReference</a>(<i>ref</i>) is <b>true</b>, then
            <ol class="block">
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">IsStrictReference</a>(<i>ref</i>) is <b>false</b>.</li>
              <li>Return <b>true</b>.</li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">IsPropertyReference</a>(<i>ref</i>) is <b>true</b>, then
            <ol class="block">
              <li>If <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">IsSuperReference</a>(<i>ref</i>), throw a <b>ReferenceError</b>
                  exception.</li>
              <li>Let <i>baseObj</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">GetBase</a>(<i>ref</i>)).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>baseObj</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              <li>Let <i>deleteStatus</i> be <i>baseObj</i>.[[Delete]](<a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">GetReferencedName</a>(<i>ref</i>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
              <li>If <i>deleteStatus</i> is <b>false</b> and <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">IsStrictReference</a>(<i>ref</i>) is <b>true</b>, throw a
                  <b>TypeError</b> exception.</li>
              <li>Return  <i>deleteStatus</i>.</li>
            </ol>
          </li>
          <li>Else <i>ref</i> is a <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> to an <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> binding,
            <ol class="block">
              <li>Let <i>bindings</i> be <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">GetBase</a>(<i>ref</i>).</li>
              <li>Return <i>bindings</i>.DeleteBinding(<a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">GetReferencedName</a>(<i>ref</i>)).</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> When a <code>delete</code> operator occurs within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
          mode code</a>, a <b>SyntaxError</b> exception is thrown if its <span class="nt">UnaryExpression</span> is a direct
          reference to a variable, function argument, or function name. In addition, if a <code>delete</code> operator occurs
          within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> and the property to be deleted has the attribute {
          [[Configurable]]: <b>false</b> }, a <b>TypeError</b> exception is thrown.</p>
        </div>
      </section>
    </section>

    <section id="sec-void-operator">
      <div class="front">
        <h3 id="sec-12.5.5" title="12.5.5"> The
            </h3></div>

      <section id="sec-void-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.5.5.1" title="12.5.5.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">UnaryExpression</span> <span class="geq">:</span> <code class="t">void</code> <span class="nt">UnaryExpression</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be the result of evaluating <i>UnaryExpression</i>.</li>
          <li>Let <i>status</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>expr</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return <b>undefined</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a> must be called even though its value is not used
          because it may have observable side-effects.</p>
        </div>
      </section>
    </section>

    <section id="sec-typeof-operator">
      <div class="front">
        <h3 id="sec-12.5.6" title="12.5.6"> The
            </h3></div>

      <section id="sec-typeof-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.5.6.1" title="12.5.6.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">UnaryExpression</span> <span class="geq">:</span> <code class="t">typeof</code> <span class="nt">UnaryExpression</span></div>
        <ol class="proc">
          <li>Let <i>val</i> be the result of evaluating <i>UnaryExpression</i>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>val</i>) is <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a>, then
            <ol class="block">
              <li>If <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">IsUnresolvableReference</a>(<i>val</i>) is <b>true</b>, return
                  <code>"undefined"</code>.</li>
            </ol>
          </li>
          <li>Let <i>val</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>val</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>val</i>).</li>
          <li>Return a String according to <a href="#table-35">Table 35</a>.</li>
        </ol>

        <figure>
          <figcaption><span id="table-35">Table 35</span> &mdash; typeof Operator Results</figcaption>
          <table class="real-table">
            <tr>
              <th><b>Type of</b> <span style="font-family: Times New Roman">val</span></th>
              <th>Result</th>
            </tr>
            <tr>
              <td>Undefined</td>
              <td><code>"undefined"</code></td>
            </tr>
            <tr>
              <td>Null</td>
              <td><code>"object"</code></td>
            </tr>
            <tr>
              <td>Boolean</td>
              <td><code>"boolean"</code></td>
            </tr>
            <tr>
              <td>Number</td>
              <td><code>"number"</code></td>
            </tr>
            <tr>
              <td>String</td>
              <td><code>"string"</code></td>
            </tr>
            <tr>
              <td>Symbol</td>
              <td><code>"symbol"</code></td>
            </tr>
            <tr>
              <td>Object (ordinary and does not implement [[Call]])</td>
              <td><code>"object"</code></td>
            </tr>
            <tr>
              <td>Object (standard exotic and does not implement [[Call]])</td>
              <td><code>"object"</code></td>
            </tr>
            <tr>
              <td>Object (implements [[Call]])</td>
              <td><code>"function"</code></td>
            </tr>
            <tr>
              <td>Object (non-standard exotic and does not implement [[Call]])</td>
              <td>Implementation-defined. Must not be <code>"undefined"</code>, <code>"boolean"</code>, <code>"function"</code>, <code>"number"</code>, <code>"symbol"</code>, or <code>"string".</code></td>
            </tr>
          </table>
        </figure>

        <div class="note">
          <p><span class="nh">NOTE</span> Implementations are discouraged from defining new <code>typeof</code> result values for
          non-standard exotic objects. If possible <code>"object"</code>should be used for such objects.</p>
        </div>
      </section>
    </section>

    <section id="sec-prefix-increment-operator">
      <div class="front">
        <h3 id="sec-12.5.7" title="12.5.7"> Prefix Increment Operator</h3></div>

      <section id="sec-prefix-increment-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.5.7.1" title="12.5.7.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">UnaryExpression</span> <span class="geq">:</span> <code class="t">++</code> <span class="nt">UnaryExpression</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be the result of evaluating <i>UnaryExpression</i>.</li>
          <li>Let <i>oldValue</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>expr</i>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>oldValue</i>).</li>
          <li>Let <i>newValue</i> be the result of adding the value <code>1</code> to <i>oldValue</i>, using the same rules as for
              the <code>+</code> operator (<a href="#sec-applying-the-additive-operators-to-numbers">see 12.7.5</a>).</li>
          <li>Let <i>status</i> be <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>expr</i>, <i>newValue</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return <i>newValue</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-prefix-decrement-operator">
      <div class="front">
        <h3 id="sec-12.5.8" title="12.5.8"> Prefix Decrement Operator</h3></div>

      <section id="sec-prefix-decrement-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.5.8.1" title="12.5.8.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">UnaryExpression</span> <span class="geq">:</span> <code class="t">--</code> <span class="nt">UnaryExpression</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be the result of evaluating <i>UnaryExpression</i>.</li>
          <li>Let <i>oldValue</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>expr</i>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>oldValue</i>).</li>
          <li>Let <i>newValue</i> be the result of  subtracting the value <code>1</code> from <i>oldValue</i>, using the same
              rules as for the <code>-</code> operator (<a href="#sec-applying-the-additive-operators-to-numbers">see
              12.7.5</a>).</li>
          <li>Let <i>status</i> be <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>expr</i>, <i>newValue</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return <i>newValue</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-unary-plus-operator">
      <div class="front">
        <h3 id="sec-12.5.9" title="12.5.9">
            Unary </h3><div class="note">
          <p><span class="nh">NOTE</span> The unary + operator converts its operand to Number type.</p>
        </div>
      </div>

      <section id="sec-unary-plus-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.5.9.1" title="12.5.9.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">UnaryExpression</span> <span class="geq">:</span> <code class="t">+</code> <span class="nt">UnaryExpression</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be the result of evaluating <i>UnaryExpression</i>.</li>
          <li>Return <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>expr</i>)).</li>
        </ol>
      </section>
    </section>

    <section id="sec-unary-minus-operator">
      <div class="front">
        <h3 id="sec-12.5.10" title="12.5.10"> Unary </h3><div class="note">
          <p><span class="nh">NOTE</span> The unary <code>-</code> operator converts its operand to Number type and then negates
          it. Negating <b>+0</b> produces <b>&minus;0</b>, and negating <b>&minus;0</b> produces <b>+0</b>.</p>
        </div>
      </div>

      <section id="sec-unary-minus-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.5.10.1" title="12.5.10.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">UnaryExpression</span> <span class="geq">:</span> <code class="t">-</code> <span class="nt">UnaryExpression</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be the result of evaluating <i>UnaryExpression</i>.</li>
          <li>Let <i>oldValue</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>expr</i>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>oldValue</i>).</li>
          <li>If <i>oldValue</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return the result of negating <i>oldValue</i>; that is, compute a Number with the same magnitude but opposite
              sign.</li>
        </ol>
      </section>
    </section>

    <section id="sec-bitwise-not-operator">
      <div class="front">
        <h3 id="sec-12.5.11" title="12.5.11"> Bitwise NOT Operator ( </h3></div>

      <section id="sec-bitwise-not-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.5.11.1" title="12.5.11.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">UnaryExpression</span> <span class="geq">:</span> <code class="t">~</code> <span class="nt">UnaryExpression</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be the result of evaluating <i>UnaryExpression</i>.</li>
          <li>Let <i>oldValue</i> be <a href="sec-abstract-operations#sec-toint32">ToInt32</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>expr</i>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>oldValue</i>).</li>
          <li>Return the result of applying bitwise complement to <i>oldValue</i>. The result is a signed 32-bit integer.</li>
        </ol>
      </section>
    </section>

    <section id="sec-logical-not-operator">
      <div class="front">
        <h3 id="sec-12.5.12" title="12.5.12"> Logical NOT Operator ( </h3></div>

      <section id="sec-logical-not-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.5.12.1" title="12.5.12.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">UnaryExpression</span> <span class="geq">:</span> <code class="t">!</code> <span class="nt">UnaryExpression</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be the result of evaluating <i>UnaryExpression</i>.</li>
          <li>Let <i>oldValue</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>expr</i>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>oldValue</i>).</li>
          <li>If <i>oldValue</i> is <b>true</b>, return <b>false</b>.</li>
          <li>Return <b>true</b>.</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-multiplicative-operators">
    <div class="front">
      <h2 id="sec-12.6" title="12.6">
          Multiplicative Operators</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">MultiplicativeExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">MultiplicativeExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">MultiplicativeOperator</span> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">MultiplicativeOperator</span> <span class="geq">:</span> <span class="grhsmod">one of</span></div>
        <div class="rhs"><code class="t">*</code> <code class="t">/</code> <code class="t">%</code></div>
      </div>
    </div>

    <section id="sec-multiplicative-operators-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.6.1" title="12.6.1"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <p><i>MultiplicativeExpression <b>:</b></i> <i>MultiplicativeExpression</i> <i>MultiplicativeOperator</i>
      <i>UnaryExpression</i></p>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.6.2" title="12.6.2"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <p><i>MultiplicativeExpression <b>:</b></i> <i>MultiplicativeExpression</i> <i>MultiplicativeOperator</i>
      <i>UnaryExpression</i></p>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-multiplicative-operators-runtime-semantics-evaluation">
      <div class="front">
        <h3 id="sec-12.6.3" title="12.6.3"> Runtime Semantics: Evaluation</h3><p><i>MultiplicativeExpression <b>:</b></i> <i>MultiplicativeExpression</i> <i>MultiplicativeOperator</i>
        <i>UnaryExpression</i></p>

        <ol class="proc">
          <li>Let <i>left</i> be the result of evaluating <i>MultiplicativeExpression</i>.</li>
          <li>Let <i>leftValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>left</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>leftValue</i>).</li>
          <li>Let <i>right</i> be the result of evaluating <i>UnaryExpression</i>.</li>
          <li>Let <i>rightValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>right</i>).</li>
          <li>Let <i>lnum</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>leftValue</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lnum</i>).</li>
          <li>Let <i>rnum</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>rightValue</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rnum</i>).</li>
          <li>Return the result of applying the <i>MultiplicativeOperator</i> (*, /, or %) to <i>lnum</i> and <i>rnum</i> as
              specified in <a href="#sec-applying-the-mul-operator">12.6.3.1</a>, <a href="#sec-applying-the-div-operator">12.6.3.2</a>, or <a href="#sec-applying-the-mod-operator">12.6.3.3</a>.</li>
        </ol>
      </div>

      <section id="sec-applying-the-mul-operator">
        <h4 id="sec-12.6.3.1" title="12.6.3.1"> Applying the </h4><p>The <code>*</code> <span class="nt">MultiplicativeOperator</span> performs multiplication, producing the product of its
        operands. Multiplication is commutative. Multiplication is not always associative in ECMAScript, because of finite
        precision.</p>

        <p>The result of a floating-point multiplication is governed by the rules of IEEE 754-2008 binary double-precision
        arithmetic:</p>

        <ul>
          <li>
            <p>If either operand is <b>NaN</b>, the result is <b>NaN</b>.</p>
          </li>

          <li>
            <p>The sign of the result is positive if both operands have the same sign, negative if the operands have different
            signs.</p>
          </li>

          <li>
            <p>Multiplication of an infinity by a zero results in <b>NaN</b>.</p>
          </li>

          <li>
            <p>Multiplication of an infinity by an infinity results in an infinity. The sign is determined by the rule already
            stated above.</p>
          </li>

          <li>
            <p>Multiplication of an infinity by a finite nonzero value results in a signed infinity. The sign is determined by the
            rule already stated above.</p>
          </li>

          <li>
            <p>In the remaining cases, where neither an infinity nor <b>NaN</b> is involved, the product is computed and rounded
            to the nearest representable value using IEEE 754-2008 round-to-nearest mode. If the magnitude is too large to
            represent, the result is then an infinity of appropriate sign. If the magnitude is too small to represent, the result
            is then a zero of appropriate sign. The ECMAScript language requires support of gradual underflow as defined by IEEE
            754-2008.</p>
          </li>
        </ul>
      </section>

      <section id="sec-applying-the-div-operator">
        <h4 id="sec-12.6.3.2" title="12.6.3.2"> Applying the </h4><p>The <code>/</code> <span class="nt">MultiplicativeOperator</span> performs division, producing the quotient of its
        operands. The left operand is the dividend and the right operand is the divisor. ECMAScript does not perform integer
        division. The operands and result of all division operations are double-precision floating-point numbers. The result of
        division is determined by the specification of IEEE 754-2008 arithmetic:</p>

        <ul>
          <li>
            <p>If either operand is <b>NaN</b>, the result is <b>NaN</b>.</p>
          </li>

          <li>
            <p>The sign of the result is positive if both operands have the same sign, negative if the operands have different
            signs.</p>
          </li>

          <li>
            <p>Division of an infinity by an infinity results in <b>NaN</b>.</p>
          </li>

          <li>
            <p>Division of an infinity by a zero results in an infinity. The sign is determined by the rule already stated
            above.</p>
          </li>

          <li>
            <p>Division of an infinity by a nonzero finite value results in a signed infinity. The sign is determined by the rule
            already stated above.</p>
          </li>

          <li>
            <p>Division of a finite value by an infinity results in zero. The sign is determined by the rule already stated
            above.</p>
          </li>

          <li>
            <p>Division of a zero by a zero results in <b>NaN</b>; division of zero by any other finite value results in zero,
            with the sign determined by the rule already stated above.</p>
          </li>

          <li>
            <p>Division of a nonzero finite value by a zero results in a signed infinity. The sign is determined by the rule
            already stated above.</p>
          </li>

          <li>
            <p>In the remaining cases, where neither an infinity, nor a zero, nor <b>NaN</b> is involved, the quotient is computed
            and rounded to the nearest representable value using IEEE 754-2008 round-to-nearest mode. If the magnitude is too
            large to represent, the operation overflows; the result is then an infinity of appropriate sign. If the magnitude is
            too small to represent, the operation underflows and the result is a zero of the appropriate sign. The ECMAScript
            language requires support of gradual underflow as defined by IEEE 754-2008.</p>
          </li>
        </ul>
      </section>

      <section id="sec-applying-the-mod-operator">
        <h4 id="sec-12.6.3.3" title="12.6.3.3"> Applying the </h4><p>The <code>%</code> <span class="nt">MultiplicativeOperator</span> yields the remainder of its operands from an implied
        division; the left operand is the dividend and the right operand is the divisor.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> In C and C++, the remainder operator accepts only integral operands; in ECMAScript, it
          also accepts floating-point operands.</p>
        </div>

        <p>The result of a floating-point remainder operation as computed by the <code>%</code> operator is not the same as the
        &ldquo;remainder&rdquo; operation defined by IEEE 754-2008. The IEEE 754-2008 &ldquo;remainder&rdquo; operation computes
        the remainder from a rounding division, not a truncating division, and so its behaviour is not analogous to that of the
        usual integer remainder operator. Instead the ECMAScript language defines <code>%</code> on floating-point operations to
        behave in a manner analogous to that of the Java integer remainder operator; this may be compared with the C library
        function fmod.</p>

        <p>The result of an ECMAScript floating-point remainder operation is determined by the rules of IEEE arithmetic:</p>

        <ul>
          <li>
            <p>If either operand is <b>NaN</b>, the result is <b>NaN</b>.</p>
          </li>

          <li>
            <p>The sign of the result equals the sign of the dividend.</p>
          </li>

          <li>
            <p>If the dividend is an infinity, or the divisor is a zero, or both, the result is <b>NaN</b>.</p>
          </li>

          <li>
            <p>If the dividend is finite and the divisor is an infinity, the result equals the dividend.</p>
          </li>

          <li>
            <p>If the dividend is a zero and the divisor is nonzero and finite, the result is the same as the dividend.</p>
          </li>

          <li>
            <p>In the remaining cases, where neither an infinity, nor a zero, nor <b>NaN</b> is involved, the floating-point
            remainder r from a dividend n and a divisor d is defined by the mathematical relation r = n &minus; (d &times; q)
            where q is an integer that is negative only if n/d is negative and positive only if n/d is positive, and whose
            magnitude is as large as possible without exceeding the magnitude of the true mathematical quotient of n and d. r is
            computed and rounded to the nearest representable value using IEEE 754-2008 round-to-nearest mode.</p>
          </li>
        </ul>
      </section>
    </section>
  </section>

  <section id="sec-additive-operators">
    <div class="front">
      <h2 id="sec-12.7" title="12.7">
          Additive Operators</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">AdditiveExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">MultiplicativeExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">+</code> <span class="nt">MultiplicativeExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">-</code> <span class="nt">MultiplicativeExpression</span><sub class="g-params">[?Yield]</sub></div>
      </div>
    </div>

    <section id="sec-additive-operators-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.7.1" title="12.7.1"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">AdditiveExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">AdditiveExpression</span> <code class="t">+</code> <span class="nt">MultiplicativeExpression</span></div>
        <div class="rhs"><span class="nt">AdditiveExpression</span> <code class="t">-</code> <span class="nt">MultiplicativeExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.7.2" title="12.7.2"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">AdditiveExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">AdditiveExpression</span> <code class="t">+</code> <span class="nt">MultiplicativeExpression</span></div>
        <div class="rhs"><span class="nt">AdditiveExpression</span> <code class="t">-</code> <span class="nt">MultiplicativeExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-addition-operator-plus">
      <div class="front">
        <h3 id="sec-12.7.3" title="12.7.3"> The Addition operator ( </h3><div class="note">
          <p><span class="nh">NOTE</span> The addition operator either performs string concatenation or numeric addition.</p>
        </div>
      </div>

      <section id="sec-addition-operator-plus-runtime-semantics-evaluation">
        <h4 id="sec-12.7.3.1" title="12.7.3.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">AdditiveExpression</span> <span class="geq">:</span> <span class="nt">AdditiveExpression</span> <code class="t">+</code> <span class="nt">MultiplicativeExpression</span></div>
        <ol class="proc">
          <li>Let <i>lref</i> be the result of evaluating <i>AdditiveExpression</i>.</li>
          <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
          <li>Let <i>rref</i> be the result of evaluating <i>MultiplicativeExpression</i>.</li>
          <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
          <li>Let <i>lprim</i> be <a href="sec-abstract-operations#sec-toprimitive">ToPrimitive</a>(<i>lval</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lprim</i>).</li>
          <li>Let <i>rprim</i> be <a href="sec-abstract-operations#sec-toprimitive">ToPrimitive</a>(<i>rval</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rprim</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>lprim</i>) is String or <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>rprim</i>) is String, then
            <ol class="block">
              <li>Let <i>lstr</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>lprim</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lstr</i>).</li>
              <li>Let <i>rstr</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>rprim</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rstr</i>).</li>
              <li>Return the String that is the result of concatenating <i>lstr</i> and <i>rstr.</i></li>
            </ol>
          </li>
          <li>Let <i>lnum</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>lprim</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lnum</i>).</li>
          <li>Let <i>rnum</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>rprim</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rnum</i>).</li>
          <li>Return the result of applying the addition operation to <i>lnum</i> and <i>rnum</i>. See the Note below <a href="#sec-applying-the-additive-operators-to-numbers">12.7.5</a>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 1</span> No hint is provided in the calls to <a href="sec-abstract-operations#sec-toprimitive">ToPrimitive</a> in
          steps 7 and 9. All standard objects except Date objects handle the absence of a hint as if the hint Number were given;
          Date objects handle the absence of a hint as if the hint String were given. Exotic objects may handle the absence of a
          hint in some other manner.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> Step 11 differs from step 5 of the Abstract Relational Comparison algorithm (<a href="sec-abstract-operations#sec-abstract-relational-comparison">7.2.11</a>), by using the logical-or operation instead of the logical-and
          operation.</p>
        </div>
      </section>
    </section>

    <section id="sec-subtraction-operator-minus">
      <div class="front">
        <h3 id="sec-12.7.4" title="12.7.4"> The Subtraction Operator ( </h3></div>

      <section id="sec-subtraction-operator-minus-runtime-semantics-evaluation">
        <h4 id="sec-12.7.4.1" title="12.7.4.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">AdditiveExpression</span> <span class="geq">:</span> <span class="nt">AdditiveExpression</span> <code class="t">-</code> <span class="nt">MultiplicativeExpression</span></div>
        <ol class="proc">
          <li>Let <i>lref</i> be the result of evaluating <i>AdditiveExpression</i>.</li>
          <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
          <li>Let <i>rref</i> be the result of evaluating <i>MultiplicativeExpression</i>.</li>
          <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
          <li>Let <i>lnum</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>lval</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lnum</i>).</li>
          <li>Let <i>rnum</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>rval</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rnum</i>).</li>
          <li>Return the result of applying the subtraction operation to <i>lnum</i> and <i>rnum</i>. See the note below <a href="#sec-applying-the-additive-operators-to-numbers">12.7.5</a>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-applying-the-additive-operators-to-numbers">
      <h3 id="sec-12.7.5" title="12.7.5"> Applying the Additive Operators to Numbers</h3><p>The <code>+</code> operator performs addition when applied to two operands of numeric type, producing the sum of the
      operands. The <code>-</code> operator performs subtraction, producing the difference of two numeric operands.</p>

      <p>Addition is a commutative operation, but not always associative.</p>

      <p>The result of an addition is determined using the rules of IEEE 754-2008 binary double-precision arithmetic:</p>

      <ul>
        <li>
          <p>If either operand is <b>NaN</b>, the result is <b>NaN</b>.</p>
        </li>

        <li>
          <p>The sum of two infinities of opposite sign is <b>NaN</b>.</p>
        </li>

        <li>
          <p>The sum of two infinities of the same sign is the infinity of that sign.</p>
        </li>

        <li>
          <p>The sum of an infinity and a finite value is equal to the infinite operand.</p>
        </li>

        <li>
          <p>The sum of two negative zeroes is <b>&minus;0</b>. The sum of two positive zeroes, or of two zeroes of opposite sign,
          is <b>+0</b>.</p>
        </li>

        <li>
          <p>The sum of a zero and a nonzero finite value is equal to the nonzero operand.</p>
        </li>

        <li>
          <p>The sum of two nonzero finite values of the same magnitude and opposite sign is <b>+0</b>.</p>
        </li>

        <li>
          <p>In the remaining cases, where neither an infinity, nor a zero, nor <b>NaN</b> is involved, and the operands have the
          same sign or have different magnitudes, the sum is computed and rounded to the nearest representable value using IEEE
          754-2008 round-to-nearest mode. If the magnitude is too large to represent, the operation overflows and the result is
          then an infinity of appropriate sign. The ECMAScript language requires support of gradual underflow as defined by IEEE
          754-2008.</p>
        </li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE</span> The <code>-</code> operator performs subtraction when applied to two operands of numeric
        type, producing the difference of its operands; the left operand is the minuend and the right operand is the subtrahend.
        Given numeric operands <var>a</var> and <var>b</var>, it is always the case that <i><span style="font-family: Times New         Roman">a</span><code>&ndash;</code><span style="font-family: Times New Roman">b</span></i> produces the same result as
        <i><span style="font-family: Times New Roman">a</span> <code>+(&ndash;</code><span style="font-family: Times New         Roman">b</span><code>)</code></i>.</p>
      </div>
    </section>
  </section>

  <section id="sec-bitwise-shift-operators">
    <div class="front">
      <h2 id="sec-12.8" title="12.8">
          Bitwise Shift Operators</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">ShiftExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">&lt;&lt;</code> <span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">&gt;&gt;</code> <span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">&gt;&gt;&gt;</code> <span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub></div>
      </div>
    </div>

    <section id="sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.8.1" title="12.8.1"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">ShiftExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ShiftExpression</span> <code class="t">&lt;&lt;</code> <span class="nt">AdditiveExpression</span></div>
        <div class="rhs"><span class="nt">ShiftExpression</span> <code class="t">&gt;&gt;</code> <span class="nt">AdditiveExpression</span></div>
        <div class="rhs"><span class="nt">ShiftExpression</span> <code class="t">&gt;&gt;&gt;</code> <span class="nt">AdditiveExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.8.2" title="12.8.2"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">ShiftExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ShiftExpression</span> <code class="t">&lt;&lt;</code> <span class="nt">AdditiveExpression</span></div>
        <div class="rhs"><span class="nt">ShiftExpression</span> <code class="t">&gt;&gt;</code> <span class="nt">AdditiveExpression</span></div>
        <div class="rhs"><span class="nt">ShiftExpression</span> <code class="t">&gt;&gt;&gt;</code> <span class="nt">AdditiveExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-left-shift-operator">
      <div class="front">
        <h3 id="sec-12.8.3" title="12.8.3">
            The Left Shift Operator ( </h3><div class="note">
          <p><span class="nh">NOTE</span> Performs a bitwise left shift operation on the left operand by the amount specified by
          the right operand.</p>
        </div>
      </div>

      <section id="sec-left-shift-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.8.3.1" title="12.8.3.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">ShiftExpression</span> <span class="geq">:</span> <span class="nt">ShiftExpression</span> <code class="t">&lt;&lt;</code> <span class="nt">AdditiveExpression</span></div>
        <ol class="proc">
          <li>Let <i>lref</i> be the result of evaluating <i>ShiftExpression</i>.</li>
          <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
          <li>Let <i>rref</i> be the result of evaluating <i>AdditiveExpression</i>.</li>
          <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
          <li>Let <i>lnum</i> be <a href="sec-abstract-operations#sec-toint32">ToInt32</a>(<i>lval</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lnum</i>).</li>
          <li>Let <i>rnum</i> be <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>rval</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rnum</i>).</li>
          <li>Let <i>shiftCount</i> be the result of masking out all but the least significant 5 bits of <i>rnum</i>, that is,
              compute <i>rnum</i> &amp; 0x1F.</li>
          <li>Return the result of left shifting <i>lnum</i> by <i>shiftCount</i> bits. The result is a signed 32-bit
              integer.</li>
        </ol>
      </section>
    </section>

    <section id="sec-signed-right-shift-operator">
      <div class="front">
        <h3 id="sec-12.8.4" title="12.8.4"> The Signed Right Shift Operator ( </h3><div class="note">
          <p><span class="nh">NOTE</span> Performs a sign-filling bitwise right shift operation on the left operand by the amount
          specified by the right operand.</p>
        </div>
      </div>

      <section id="sec-signed-right-shift-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.8.4.1" title="12.8.4.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">ShiftExpression</span> <span class="geq">:</span> <span class="nt">ShiftExpression</span> <code class="t">&gt;&gt;</code> <span class="nt">AdditiveExpression</span></div>
        <ol class="proc">
          <li>Let <i>lref</i> be the result of evaluating <i>ShiftExpression</i>.</li>
          <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
          <li>Let <i>rref</i> be the result of evaluating <i>AdditiveExpression</i>.</li>
          <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
          <li>Let <i>lnum</i> be <a href="sec-abstract-operations#sec-toint32">ToInt32</a>(<i>lval</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lnum</i>).</li>
          <li>Let <i>rnum</i> be <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>rval</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rnum</i>).</li>
          <li>Let <i>shiftCount</i> be the result of masking out all but the least significant 5 bits of <i>rnum</i>, that is,
              compute <i>rnum</i> &amp; 0x1F.</li>
          <li>Return the result of performing a sign-extending right shift of <i>lnum</i> by <i>shiftCount</i> bits. The most
              significant bit is propagated. The result is a signed 32-bit integer.</li>
        </ol>
      </section>
    </section>

    <section id="sec-unsigned-right-shift-operator">
      <div class="front">
        <h3 id="sec-12.8.5" title="12.8.5"> The Unsigned Right Shift Operator ( </h3><div class="note">
          <p><span class="nh">NOTE</span> Performs a zero-filling bitwise right shift operation on the left operand by the amount
          specified by the right operand.</p>
        </div>
      </div>

      <section id="sec-unsigned-right-shift-operator-runtime-semantics-evaluation">
        <h4 id="sec-12.8.5.1" title="12.8.5.1"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">ShiftExpression</span> <span class="geq">:</span> <span class="nt">ShiftExpression</span> <code class="t">&gt;&gt;&gt;</code> <span class="nt">AdditiveExpression</span></div>
        <ol class="proc">
          <li>Let <i>lref</i> be the result of evaluating <i>ShiftExpression</i>.</li>
          <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
          <li>Let <i>rref</i> be the result of evaluating <i>AdditiveExpression</i>.</li>
          <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
          <li>Let <i>lnum</i> be <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>lval</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lnum</i>).</li>
          <li>Let <i>rnum</i> be <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>rval</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rnum</i>).</li>
          <li>Let <i>shiftCount</i> be the result of masking out all but the least significant 5 bits of <i>rnum</i>, that is,
              compute <i>rnum</i> &amp; 0x1F.</li>
          <li>Return the result of performing a zero-filling right shift of <i>lnum</i> by <i>shiftCount</i> bits. Vacated bits
              are filled with zero. The result is an unsigned 32-bit integer.</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-relational-operators">
    <div class="front">
      <h2 id="sec-12.9" title="12.9">
          Relational Operators</h2><div class="note">
        <p><span class="nh">NOTE 1</span> The result of evaluating a relational operator is always of type Boolean, reflecting
        whether the relationship named by the operator holds between its two operands.</p>
      </div>

      <h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">RelationalExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&lt;</code> <span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&gt;</code> <span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&lt;=</code> <span class="nt">ShiftExpression</span><sub class="g-params">[? Yield]</sub></div>
        <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&gt;=</code> <span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">instanceof</code> <span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="grhsannot">[+In]</span> <span class="nt">RelationalExpression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">in</code> <span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 2</span> The [In] grammar parameter is needed to avoid confusing the <code>in</code> operator in
        a relational expression with the <code>in</code> operator in a <code>for</code> statement.</p>
      </div>
    </div>

    <section id="sec-relational-operators-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.9.1" title="12.9.1"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">RelationalExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&lt;</code> <span class="nt">ShiftExpression</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&gt;</code> <span class="nt">ShiftExpression</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&lt;=</code> <span class="nt">ShiftExpression</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&gt;=</code> <span class="nt">ShiftExpression</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">instanceof</code> <span class="nt">ShiftExpression</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">in</code> <span class="nt">ShiftExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.9.2" title="12.9.2"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">RelationalExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&lt;</code> <span class="nt">ShiftExpression</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&gt;</code> <span class="nt">ShiftExpression</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&lt;=</code> <span class="nt">ShiftExpression</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&gt;=</code> <span class="nt">ShiftExpression</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">instanceof</code> <span class="nt">ShiftExpression</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">in</code> <span class="nt">ShiftExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-relational-operators-runtime-semantics-evaluation">
      <h3 id="sec-12.9.3" title="12.9.3"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">RelationalExpression</span> <span class="geq">:</span> <span class="nt">RelationalExpression</span> <code class="t">&lt;</code> <span class="nt">ShiftExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>RelationalExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>ShiftExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li>Let <i>r</i> be the result of performing Abstract Relational Comparison <i>lval</i> &lt; <i>rval</i>. (<a href="sec-abstract-operations#sec-abstract-relational-comparison">see 7.2.11</a>)</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>r</i>).</li>
        <li>If <i>r</i> is <b>undefined</b>, return <b>false</b>. Otherwise, return <i>r</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">RelationalExpression</span> <span class="geq">:</span> <span class="nt">RelationalExpression</span> <code class="t">&gt;</code> <span class="nt">ShiftExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>RelationalExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>ShiftExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li>Let <i>r</i> be the result of performing Abstract Relational Comparison <i>rval</i> &lt; <i>lval</i> with
            <i>LeftFirst</i> equal to <b>false</b>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>r</i>).</li>
        <li>If <i>r</i> is <b>undefined</b>, return <b>false</b>. Otherwise, return <i>r</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">RelationalExpression</span> <span class="geq">:</span> <span class="nt">RelationalExpression</span> <code class="t">&lt;=</code> <span class="nt">ShiftExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>RelationalExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>ShiftExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li>Let <i>r</i> be the result of performing Abstract Relational Comparison <i>rval</i> &lt; <i>lval</i>  with
            <i>LeftFirst</i> equal to <b>false</b>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>r</i>).</li>
        <li>If <i>r</i> is <b>true</b> or <b>undefined</b>, return <b>false</b>. Otherwise, return <b>true</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">RelationalExpression</span> <span class="geq">:</span> <span class="nt">RelationalExpression</span> <code class="t">&gt;=</code> <span class="nt">ShiftExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>RelationalExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>ShiftExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li>Let <i>r</i> be the result of performing Abstract Relational Comparison <i>lval</i> &lt; <i>rval</i>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>r</i>).</li>
        <li>If <i>r</i> is <b>true</b> or <b>undefined</b>, return <b>false</b>. Otherwise, return <b>true</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">RelationalExpression</span> <span class="geq">:</span> <span class="nt">RelationalExpression</span> <code class="t">instanceof</code> <span class="nt">ShiftExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>RelationalExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>ShiftExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
        <li>Return <a href="#sec-instanceofoperator">InstanceofOperator</a>(<i>lval</i>, <i>rval</i>).</li>
      </ol>
      <div class="gp prod"><span class="nt">RelationalExpression</span> <span class="geq">:</span> <span class="nt">RelationalExpression</span> <code class="t">in</code> <span class="nt">ShiftExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>RelationalExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>ShiftExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>rval</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Return <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>rval</i>, <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>lval</i>)).</li>
      </ol>
    </section>

    <section id="sec-instanceofoperator">
      <h3 id="sec-12.9.4" title="12.9.4">
          Runtime Semantics: InstanceofOperator(O, C)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">InstanceofOperator(<i>O</i>,
      <i>C</i>)</span> implements the generic algorithm for determining if an object <var>O</var> inherits from the inheritance
      path defined by constructor <var>C</var>. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>C</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>instOfHandler</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>C</i>,@@hasInstance).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>instOfHandler</i>).</li>
        <li>If <i>instOfHandler</i> is not <b>undefined</b>, then
          <ol class="block">
            <li>Return <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>instOfHandler</i>, <i>C</i>,
                &laquo;<i>O</i>&raquo;)).</li>
          </ol>
        </li>
        <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>C</i>) is <b>false</b>, throw a <b>TypeError</b> exception.</li>
        <li>Return <a href="sec-abstract-operations#sec-ordinaryhasinstance">OrdinaryHasInstance</a>(<i>C</i>, <i>O</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Steps 5 and 6 provide compatibility with previous editions of ECMAScript that did not use
        a @@hasInstance method to define the <code>instanceof</code> operator semantics. If a function object does not define or
        inherit @@hasInstance it uses the default <code>instanceof</code> semantics.</p>
      </div>
    </section>
  </section>

  <section id="sec-equality-operators">
    <div class="front">
      <h2 id="sec-12.10" title="12.10">
          Equality Operators</h2><div class="note">
        <p><span class="nh">NOTE</span> The result of evaluating an equality operator is always of type Boolean, reflecting
        whether the relationship named by the operator holds between its two operands.</p>
      </div>

      <h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">EqualityExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">==</code> <span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">!=</code> <span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">===</code> <span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">!==</code> <span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      </div>
    </div>

    <section id="sec-equality-operators-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.10.1" title="12.10.1"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">EqualityExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">==</code> <span class="nt">RelationalExpression</span></div>
        <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">!=</code> <span class="nt">RelationalExpression</span></div>
        <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">===</code> <span class="nt">RelationalExpression</span></div>
        <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">!==</code> <span class="nt">RelationalExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.10.2" title="12.10.2"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">EqualityExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">==</code> <span class="nt">RelationalExpression</span></div>
        <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">!=</code> <span class="nt">RelationalExpression</span></div>
        <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">===</code> <span class="nt">RelationalExpression</span></div>
        <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">!==</code> <span class="nt">RelationalExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-equality-operators-runtime-semantics-evaluation">
      <h3 id="sec-12.10.3" title="12.10.3"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">EqualityExpression</span> <span class="geq">:</span> <span class="nt">EqualityExpression</span> <code class="t">==</code> <span class="nt">RelationalExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>EqualityExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>RelationalExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
        <li>Return the result of performing Abstract Equality Comparison <i>rval</i> == <i>lval</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">EqualityExpression</span> <span class="geq">:</span> <span class="nt">EqualityExpression</span> <code class="t">!=</code> <span class="nt">RelationalExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>EqualityExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>RelationalExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
        <li>Let <i>r</i> be the result of performing Abstract Equality Comparison <i>rval</i> == <i>lval</i>.</li>
        <li>If <i>r</i> is <b>true</b>, return <b>false</b>. Otherwise, return <b>true</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">EqualityExpression</span> <span class="geq">:</span> <span class="nt">EqualityExpression</span> <code class="t">===</code> <span class="nt">RelationalExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>EqualityExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>)</li>
        <li>Let <i>rref</i> be the result of evaluating <i>RelationalExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
        <li>Return the result of performing Strict Equality Comparison <i>rval</i> === <i>lval</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">EqualityExpression</span> <span class="geq">:</span> <span class="nt">EqualityExpression</span> <code class="t">!==</code> <span class="nt">RelationalExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>EqualityExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>RelationalExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
        <li>Let <i>r</i> be the result of performing Strict Equality Comparison <i>rval</i> === <i>lval</i>.</li>
        <li>If <i>r</i> is <b>true</b>, return <b>false</b>. Otherwise, return <b>true</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 1</span> Given the above definition of equality:</p>

        <ul>
          <li>String comparison can be forced by: <code>"" + a == "" + b</code>.</li>
          <li>Numeric comparison can be forced by: <code>+a == +b</code>.</li>
          <li>Boolean comparison can be forced by: <code>!a == !b</code>.</li>
        </ul>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 2</span> The equality operators maintain the following invariants:</p>

        <ul>
          <li><code>A</code> <code>!=</code> <code>B</code> is equivalent to <code>!(A</code> <code>==</code>
              <code>B)</code>.</li>
          <li><code>A</code> <code>==</code> <code>B</code> is equivalent to <code>B</code> <code>==</code> <code>A</code>, except
              in the order of evaluation of <code>A</code> and <code>B</code>.</li>
        </ul>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 3</span> The equality operator is not always transitive. For example, there might be two distinct
        String objects, each representing the same String value; each String object would be considered equal to the String value
        by the <code>==</code> operator, but the two String objects would not be equal to each other. For example:</p>

        <ul>
          <li><code>new String("a") == "a"</code> and <code>"a" ==  new String("a")</code> are both <span class="value">true</span>.</li>
          <li><code>new String("a") == new String("a")</code> is <span class="value">false</span>.</li>
        </ul>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 4</span> Comparison of Strings uses a simple equality test on sequences of code unit values.
        There is no attempt to use the more complex, semantically oriented definitions of character or string equality and
        collating order defined in the Unicode specification. Therefore Strings values that are canonically equal according to the
        Unicode standard could test as unequal. In effect this algorithm assumes that both Strings are already in normalized
        form.</p>
      </div>
    </section>
  </section>

  <section id="sec-binary-bitwise-operators">
    <div class="front">
      <h2 id="sec-12.11" title="12.11"> Binary Bitwise Operators</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">BitwiseANDExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">BitwiseANDExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&amp;</code> <span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">BitwiseXORExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BitwiseANDExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">BitwiseXORExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">^</code> <span class="nt">BitwiseANDExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">BitwiseORExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BitwiseXORExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">BitwiseORExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">|</code> <span class="nt">BitwiseXORExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      </div>
    </div>

    <section id="sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.11.1" title="12.11.1"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <p><span class="prod"><span class="nt">BitwiseANDExpression</span> <span class="geq">:</span> <span class="nt">BitwiseANDExpression</span> <code class="t">&amp;</code> <span class="nt">EqualityExpression</span></span> <span style="font-family: sans-serif"><br /></span><span class="prod"><span class="nt">BitwiseXORExpression</span> <span class="geq">:</span> <span class="nt">BitwiseXORExpression</span> <code class="t">^</code> <span class="nt">BitwiseANDExpression</span></span> <span style="font-family: sans-serif"><br /></span><span class="prod"><span class="nt">BitwiseORExpression</span> <span class="geq">:</span> <span class="nt">BitwiseORExpression</span> <code class="t">|</code> <span class="nt">BitwiseXORExpression</span></span></p>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.11.2" title="12.11.2"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <p><span class="prod"><span class="nt">BitwiseANDExpression</span> <span class="geq">:</span> <span class="nt">BitwiseANDExpression</span> <code class="t">&amp;</code> <span class="nt">EqualityExpression</span></span> <span style="font-family: sans-serif"><br /></span><span class="prod"><span class="nt">BitwiseXORExpression</span> <span class="geq">:</span> <span class="nt">BitwiseXORExpression</span> <code class="t">^</code> <span class="nt">BitwiseANDExpression</span></span> <span style="font-family: sans-serif"><br /></span><span class="prod"><span class="nt">BitwiseORExpression</span> <span class="geq">:</span> <span class="nt">BitwiseORExpression</span> <code class="t">|</code> <span class="nt">BitwiseXORExpression</span></span></p>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-binary-bitwise-operators-runtime-semantics-evaluation">
      <h3 id="sec-12.11.3" title="12.11.3"> Runtime Semantics: Evaluation</h3><p class="normalbefore">The production <var>A</var> <b>:</b> <i><span style="font-family: Times New Roman">A</span> @ <span style="font-family: Times New Roman">B</span></i>, where @ is one of the bitwise operators in the productions above, is
      evaluated as follows:</p>

      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>A</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>B</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
        <li>Let <i>lnum</i> be <a href="sec-abstract-operations#sec-toint32">ToInt32</a>(<i>lval</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lnum</i>).</li>
        <li>Let <i>rnum</i> be <a href="sec-abstract-operations#sec-toint32">ToInt32</a>(<i>rval</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rnum</i>).</li>
        <li>Return the result of applying the bitwise operator @ to <i>lnum</i> and <i>rnum</i>. The result is a signed 32 bit
            integer.</li>
      </ol>
    </section>
  </section>

  <section id="sec-binary-logical-operators">
    <div class="front">
      <h2 id="sec-12.12" title="12.12"> Binary Logical Operators</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">LogicalANDExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BitwiseORExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">LogicalANDExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&amp;&amp;</code> <span class="nt">BitwiseORExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">LogicalORExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">LogicalANDExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">LogicalORExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">||</code> <span class="nt">LogicalANDExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE</span> The value produced by a <code>&amp;&amp;</code> or <code>||</code> operator is not
        necessarily of type Boolean. The value produced will always be the value of one of the two operand expressions.</p>
      </div>
    </div>

    <section id="sec-binary-logical-operators-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.12.1" title="12.12.1"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <p><span class="prod"><span class="nt">LogicalANDExpression</span> <span class="geq">:</span> <span class="nt">LogicalANDExpression</span> <code class="t">&amp;&amp;</code> <span class="nt">BitwiseORExpression</span></span>
      <span style="font-family: sans-serif"><br /></span><span class="prod"><span class="nt">LogicalORExpression</span> <span class="geq">:</span> <span class="nt">LogicalORExpression</span> <code class="t">||</code> <span class="nt">LogicalANDExpression</span></span></p>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.12.2" title="12.12.2"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <p><span class="prod"><span class="nt">LogicalANDExpression</span> <span class="geq">:</span> <span class="nt">LogicalANDExpression</span> <code class="t">&amp;&amp;</code> <span class="nt">BitwiseORExpression</span></span>
      <span style="font-family: sans-serif"><br /></span><span class="prod"><span class="nt">LogicalORExpression</span> <span class="geq">:</span> <span class="nt">LogicalORExpression</span> <code class="t">||</code> <span class="nt">LogicalANDExpression</span></span></p>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-binary-logical-operators-runtime-semantics-evaluation">
      <h3 id="sec-12.12.3" title="12.12.3"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">LogicalANDExpression</span> <span class="geq">:</span> <span class="nt">LogicalANDExpression</span> <code class="t">&amp;&amp;</code> <span class="nt">BitwiseORExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>LogicalANDExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li>Let <i>lbool</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<i>lval</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lbool</i>).</li>
        <li>If <i>lbool</i> is <b>false</b>, return <i>lval</i>.</li>
        <li>Let <i>rref</i> be the result of evaluating <i>BitwiseORExpression</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
      </ol>
      <div class="gp prod"><span class="nt">LogicalORExpression</span> <span class="geq">:</span> <span class="nt">LogicalORExpression</span> <code class="t">||</code> <span class="nt">LogicalANDExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>LogicalORExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li>Let <i>lbool</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<i>lval</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lbool</i>).</li>
        <li>If <i>lbool</i> is <b>true</b>, return <i>lval</i>.</li>
        <li>Let <i>rref</i> be the result of evaluating <i>LogicalANDExpression</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
      </ol>
    </section>
  </section>

  <section id="sec-conditional-operator">
    <div class="front">
      <h2 id="sec-12.13" title="12.13">
          Conditional Operator ( </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">ConditionalExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">LogicalORExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">LogicalORExpression</span><sub class="g-params">[?In,?Yield]</sub> <code class="t">?</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">:</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE</span> The grammar for a <span class="nt">ConditionalExpression</span> in ECMAScript is slightly
        different from that in C and Java, which each allow the second subexpression to be an <span class="nt">Expression</span>
        but restrict the third expression to be a <span class="nt">ConditionalExpression</span>. The motivation for this
        difference in ECMAScript is to allow an assignment expression to be governed by either arm of a conditional and to
        eliminate the confusing and fairly useless case of a comma expression as the centre expression.</p>
      </div>
    </div>

    <section id="sec-conditional-operator-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.13.1" title="12.13.1"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <div class="gp prod"><span class="nt">ConditionalExpression</span> <span class="geq">:</span> <span class="nt">LogicalORExpression</span> <code class="t">?</code> <span class="nt">AssignmentExpression</span> <code class="t">:</code> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.13.2" title="12.13.2"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <div class="gp prod"><span class="nt">ConditionalExpression</span> <span class="geq">:</span> <span class="nt">LogicalORExpression</span> <code class="t">?</code> <span class="nt">AssignmentExpression</span> <code class="t">:</code> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-conditional-operator-runtime-semantics-evaluation">
      <h3 id="sec-12.13.3" title="12.13.3"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">ConditionalExpression</span> <span class="geq">:</span> <span class="nt">LogicalORExpression</span> <code class="t">?</code> <span class="nt">AssignmentExpression</span> <code class="t">:</code> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>LogicalORExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>If <i>lval</i> is <b>true</b>, then
          <ol class="block">
            <li>Let <i>trueRef</i> be the result of evaluating the first <i>AssignmentExpression</i>.</li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>trueRef</i>).</li>
          </ol>
        </li>
        <li>Else
          <ol class="block">
            <li>Let <i>falseRef</i> be the result of evaluating the second <i>AssignmentExpression</i>.</li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>falseRef</i>).</li>
          </ol>
        </li>
      </ol>
    </section>
  </section>

  <section id="sec-assignment-operators">
    <div class="front">
      <h2 id="sec-12.14" title="12.14">
          Assignment Operators</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">AssignmentExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ConditionalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="grhsannot">[+Yield]</span> <span class="nt">YieldExpression</span><sub class="g-params">[?In]</sub></div>
        <div class="rhs"><span class="nt">ArrowFunction</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">=</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">AssignmentOperator</span> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">AssignmentOperator</span> <span class="geq">:</span> <span class="grhsmod">one of</span></div>
        <div class="rhs"><code class="t">*=</code> <code class="t">/=</code> <code class="t">%=</code> <code class="t">+=</code> <code class="t">-=</code> <code class="t">&lt;&lt;=</code> <code class="t">&gt;&gt;=</code> <code class="t">&gt;&gt;&gt;=</code> <code class="t">&amp;=</code> <code class="t">^=</code> <code class="t">|=</code></div>
      </div>
    </div>

    <section id="sec-assignment-operators-static-semantics-early-errors">
      <h3 id="sec-12.14.1" title="12.14.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">AssignmentExpression</span> <span class="geq">:</span> <span class="nt">LeftHandSideExpression</span> <code class="t">=</code> <span class="nt">AssignmentExpression</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if <span class="nt">LeftHandSideExpression</span> is either an <span class="nt">ObjectLiteral</span> or an <span class="nt">ArrayLiteral</span> and the lexical token sequence matched by
          <span class="nt">LeftHandSideExpression</span> cannot be parsed with no tokens left over using <span class="nt">AssignmentPattern</span> as the goal symbol.</p>
        </li>

        <li>
          <p>It is an early <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> Error if <span class="nt">LeftHandSideExpression</span> is neither an <span class="nt">ObjectLiteral</span> nor an <span class="nt">ArrayLiteral</span> and IsValidSimpleAssignmentTarget of <span class="nt">LeftHandSideExpression</span> is
          <span class="value">false</span>.</p>
        </li>
      </ul>
      <div class="gp prod"><span class="nt">AssignmentExpression</span> <span class="geq">:</span> <span class="nt">LeftHandSideExpression</span> <span class="nt">AssignmentOperator</span> <span class="nt">AssignmentExpression</span></div>
      <ul>
        <li>
          <p>It is an early <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> Error if IsValidSimpleAssignmentTarget of
          <span class="nt">LeftHandSideExpression</span> is <span class="value">false</span>.</p>
        </li>
      </ul>
    </section>

    <section id="sec-assignment-operators-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.14.2" title="12.14.2"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <div class="gp prod"><span class="nt">AssignmentExpression</span> <span class="geq">:</span> <span class="nt">ArrowFunction</span></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>

      <div class="gp">
        <div class="lhs"><span class="nt">AssignmentExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">YieldExpression</span></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">=</code> <span class="nt">AssignmentExpression</span></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span> <span class="nt">AssignmentOperator</span> <span class="nt">AssignmentExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.14.3" title="12.14.3"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">12.15.2</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">AssignmentExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">YieldExpression</span></div>
        <div class="rhs"><span class="nt">ArrowFunction</span></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">=</code> <span class="nt">AssignmentExpression</span></div>
        <div class="rhs"><span class="nt">LeftHandSideExpression</span> <span class="nt">AssignmentOperator</span> <span class="nt">AssignmentExpression</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-assignment-operators-runtime-semantics-evaluation">
      <h3 id="sec-12.14.4" title="12.14.4"> Runtime Semantics: Evaluation</h3><p><span class="nt">AssignmentExpression</span><sub>[In, Yield]</sub> <b>:</b> <span class="nt">LeftHandSideExpression</span><sub>[?Yield]</sub> <code>=</code> <span class="nt">AssignmentExpression</span><sub>[?In, ?Yield]</sub></p>

      <ol class="proc">
        <li>If <i>LeftHandSideExpression</i> is neither an <i>ObjectLiteral</i> nor an <i>ArrayLiteral</i>, then
          <ol class="block">
            <li>Let <i>lref</i> be the result of evaluating <i>LeftHandSideExpression</i>.</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lref</i>).</li>
            <li>Let <i>rref</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
            <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
            <li>If <a href="sec-ecmascript-language-functions-and-classes#sec-isanonymousfunctiondefinition">IsAnonymousFunctionDefinition</a>(<i>AssignmentExpression)</i> and
                IsIdentifierRef of <i>LeftHandSideExpression</i> are both <b>true</b>, then
              <ol class="block">
                <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>rval</i>,
                    <code>"name"</code>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
                <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>rval</i>, <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">GetReferencedName</a>(<i>lref</i>)).</li>
              </ol>
            </li>
            <li>Let <i>status</i> be <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lref</i>, <i>rval</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
            <li>Return <i>rval</i>.</li>
          </ol>
        </li>
        <li>Let <i>assignmentPattern</i> be the parse of the source text corresponding to <i>LeftHandSideExpression</i> using
            <i>AssignmentPattern</i><sub>[?Yield]</sub> as the goal symbol.</li>
        <li>Let <i>rref</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
        <li>Let <i>status</i> be the result of performing DestructuringAssignmentEvaluation of <i>assignmentPattern</i> using
            <i>rval</i> as the argument.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
        <li>Return <i>rval</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">AssignmentExpression</span> <span class="geq">:</span> <span class="nt">LeftHandSideExpression</span> <span class="nt">AssignmentOperator</span> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>LeftHandSideExpression</i>.</li>
        <li>Let <i>lval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lval</i>).</li>
        <li>Let <i>rref</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
        <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
        <li>Let <i>op</i> be the <code>@</code> where <i>AssignmentOperator</i> is <code>@=</code></li>
        <li>Let <i>r</i> be the result of applying <i>op</i> to <i>lval</i> and <i>rval</i> as if evaluating the expression
            <i>lval</i> <i>op</i> <i>rval</i>.</li>
        <li>Let <i>status</i> be <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lref</i>, <i>r</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
        <li>Return <i>r</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> When an assignment occurs within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, it
        is an runtime error if <var>lref</var> in step 1.f.of the first algorithm or step 9 of the second algorithm it is an
        unresolvable reference. If it is, a <b>ReferenceError</b> exception is thrown. The <span class="nt">LeftHandSide</span>
        also may not be a reference to a data property with the attribute value <span style="font-family: Times New         Roman">{[[Writable]]:<b>false</b>}</span>, to an accessor property with the attribute value <span style="font-family:         Times New Roman">{[[Set]]:<b>undefined</b>}</span>, nor to a non-existent property of an object for which the <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a> predicate returns the value <b>false</b>. In these cases a <b>TypeError</b>
        exception is thrown.</p>
      </div>
    </section>

    <section id="sec-destructuring-assignment">
      <div class="front">
        <h3 id="sec-12.14.5" title="12.14.5"> Destructuring Assignment</h3><h2>Supplemental Syntax</h2>

        <p>In certain circumstances when processing the production <span class="prod"><span class="nt">AssignmentExpression</span>
        <span class="geq">:</span> <span class="nt">LeftHandSideExpression</span> <code class="t">=</code> <span class="nt">AssignmentExpression</span></span> the following grammar is used to refine the interpretation of  <span class="nt">LeftHandSideExpression</span>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">AssignmentPattern</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ObjectAssignmentPattern</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">ArrayAssignmentPattern</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ObjectAssignmentPattern</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">{</code> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">AssignmentPropertyList</span><sub class="g-params">[?Yield]</sub> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">AssignmentPropertyList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <code class="t">}</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ArrayAssignmentPattern</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentRestElement</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">]</code></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">AssignmentElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">]</code></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">AssignmentElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentRestElement</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">]</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">AssignmentPropertyList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">AssignmentProperty</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">AssignmentPropertyList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">AssignmentProperty</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">AssignmentElementList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">AssignmentElisionElement</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">AssignmentElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">AssignmentElisionElement</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">AssignmentElisionElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentElement</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">AssignmentProperty</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">IdentifierReference</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[In,?Yield]</sub><sub class="g-opt">opt</sub></div>
          <div class="rhs"><span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">AssignmentElement</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">AssignmentElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">DestructuringAssignmentTarget</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[In,?Yield]</sub><sub class="g-opt">opt</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">AssignmentRestElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">...</code> <span class="nt">DestructuringAssignmentTarget</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">DestructuringAssignmentTarget</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub></div>
        </div>
      </div>

      <section id="sec-destructuring-assignment-static-semantics-early-errors">
        <h4 id="sec-12.14.5.1" title="12.14.5.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">AssignmentProperty</span> <span class="geq">:</span> <span class="nt">IdentifierReference</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ul>
          <li>
            <p>It is a Syntax Error if IsValidSimpleAssignmentTarget of <span class="nt">IdentifierReference</span> is <span class="value">false</span>.</p>
          </li>
        </ul>
        <div class="gp prod"><span class="nt">DestructuringAssignmentTarget</span> <span class="geq">:</span> <span class="nt">LeftHandSideExpression</span></div>
        <ul>
          <li>
            <p>It is a Syntax Error if <span class="nt">LeftHandSideExpression</span> is either an <span class="nt">ObjectLiteral</span> or an <span class="nt">ArrayLiteral</span> and if the lexical token sequence matched
            by <span class="nt">LeftHandSideExpression</span> cannot be parsed with no tokens left over using <span class="nt">AssignmentPattern</span> as the goal symbol.</p>
          </li>

          <li>
            <p>It is a Syntax Error if <span class="nt">LeftHandSideExpression</span> is neither an <span class="nt">ObjectLiteral</span> nor an <span class="nt">ArrayLiteral</span> and <span style="font-family: Times New             Roman">IsValidSimpleAssignmentTarget</span>(<span class="nt">LeftHandSideExpression</span>) is <span class="value">false</span>.</p>
          </li>
        </ul>
      </section>

      <section id="sec-runtime-semantics-destructuringassignmentevaluation">
        <h4 id="sec-12.14.5.2" title="12.14.5.2"> Runtime Semantics: DestructuringAssignmentEvaluation</h4><p>with parameter <var>value</var></p>

        <div class="gp prod"><span class="nt">ObjectAssignmentPattern</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Let <i>valid</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>valid</i>).</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ObjectAssignmentPattern</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">AssignmentPropertyList</span> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">AssignmentPropertyList</span> <code class="t">,</code> <code class="t">}</code></div>
        </div>

        <ol class="proc">
          <li>Let <i>valid</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>valid</i>).</li>
          <li>Return the result of performing DestructuringAssignmentEvaluation for <i>AssignmentPropertyList</i> using
              <i>value</i> as the argument.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayAssignmentPattern</span> <span class="geq">:</span> <code class="t">[</code> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
          <li>Return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>)).</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayAssignmentPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">Elision</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
          <li>Let <i>iteratorRecord</i> be Record {[[iterator]]: <i>iterator</i>, [[done]]: <b>false</b>}.</li>
          <li>Let <i>result</i> be the result of performing IteratorDestructuringAssignmentEvaluation of <i>Elision</i> with
              <i>iteratorRecord</i> as the argument.</li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>result</i>).</li>
          <li>Return <i>result</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayAssignmentPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentRestElement</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
          <li>Let <i>iteratorRecord</i> be Record {[[iterator]]: <i>iterator</i>, [[done]]: <b>false</b>}.</li>
          <li>If <i>Elision</i> is present, then
            <ol class="block">
              <li>Let <i>status</i> be the result of performing IteratorDestructuringAssignmentEvaluation of <i>Elision</i> with
                  <i>iteratorRecord</i> as the argument.</li>
              <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
                <ol class="block">
                  <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>status</i>).</li>
                  <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>result</i> be the result of performing IteratorDestructuringAssignmentEvaluation of
              <i>AssignmentRestElement</i> with <i>iteratorRecord</i> as the argument.</li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>result</i>).</li>
          <li>Return <i>result</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayAssignmentPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">AssignmentElementList</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
          <li>Let <i>iteratorRecord</i> be Record {[[iterator]]: <i>iterator</i>, [[done]]: <b>false</b>}.</li>
          <li>Let <i>result</i> be the result of performing IteratorDestructuringAssignmentEvaluation of
              <i>AssignmentElementList</i> using <i>iteratorRecord</i> as the argument.</li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>result</i>).</li>
          <li>Return <i>result</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayAssignmentPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">AssignmentElementList</span> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentRestElement</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
          <li>Let <i>iteratorRecord</i> be Record {[[iterator]]: <i>iterator</i>, [[done]]: <b>false</b>}.</li>
          <li>Let <i>status</i> be the result of performing IteratorDestructuringAssignmentEvaluation of
              <i>AssignmentElementList</i> using <i>iteratorRecord</i> as the argument.</li>
          <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
            <ol class="block">
              <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>status</i>).</li>
              <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>).</li>
            </ol>
          </li>
          <li>If <i>Elision</i> is present, then
            <ol class="block">
              <li>Let <i>status</i> be the result of performing IteratorDestructuringAssignmentEvaluation of <i>Elision</i> with
                  <i>iteratorRecord</i> as the argument.</li>
              <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
                <ol class="block">
                  <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>status</i>).</li>
                  <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>AssignmentRestElement</i> is present, then
            <ol class="block">
              <li>Let <i>status</i> be the result of performing IteratorDestructuringAssignmentEvaluation of
                  <i>AssignmentRestElement</i> with <i>iteratorRecord</i> as the argument.</li>
            </ol>
          </li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>status</i>).</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">AssignmentPropertyList</span> <span class="geq">:</span> <span class="nt">AssignmentPropertyList</span> <code class="t">,</code> <span class="nt">AssignmentProperty</span></div>
        <ol class="proc">
          <li>Let <i>status</i> be the result of performing DestructuringAssignmentEvaluation for <i>AssignmentPropertyList</i>
              using <i>value</i> as the argument.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return the result of performing DestructuringAssignmentEvaluation for <i>AssignmentProperty</i> using <i>value</i>
              as the argument.</li>
        </ol>
        <div class="gp prod"><span class="nt">AssignmentProperty</span> <span class="geq">:</span> <span class="nt">IdentifierReference</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ol class="proc">
          <li>Let <i>P</i> be StringValue of <i>IdentifierReference</i>.</li>
          <li>Let <i>lref</i> be <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(<i>P)</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>P</i>).</li>
          <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-getv">GetV</a>(<i>value</i>, <i>P</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
          <li>If <i>Initializer</i><sub>opt</sub> is present and <i>v</i> is <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>defaultValue</i> be the result of evaluating <i>Initializer</i>.</li>
              <li>Let <i>v</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>defaultValue</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
              <li>If <a href="sec-ecmascript-language-functions-and-classes#sec-isanonymousfunctiondefinition">IsAnonymousFunctionDefinition</a>(<i>Initializer</i>) is
                  <b>true</b>, then
                <ol class="block">
                  <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>v</i>,
                      <code>"name"</code>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
                  <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>v</i>, <i>P</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lref</i>,<i>v</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">AssignmentProperty</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">AssignmentElement</span></div>
        <ol class="proc">
          <li>Let <i>name</i> be  the result of evaluating <i>PropertyName</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>name</i>).</li>
          <li>Return the result of performing KeyedDestructuringAssignmentEvaluation of <i>AssignmentElement</i> with <i>value</i>
              and <i>name</i> as the arguments.</li>
        </ol>
      </section>

      <section id="sec-runtime-semantics-iteratordestructuringassignmentevaluation">
        <h4 id="sec-12.14.5.3" title="12.14.5.3"> Runtime Semantics: IteratorDestructuringAssignmentEvaluation</h4><p>with parameters <var>iteratorRecord</var></p>

        <div class="gp prod"><span class="nt">AssignmentElementList</span> <span class="geq">:</span> <span class="nt">AssignmentElisionElement</span></div>
        <ol class="proc">
          <li>Return the result of performing IteratorDestructuringAssignmentEvaluation of <i>AssignmentElisionElement</i> using
              <i>iteratorRecord</i> as the <i>argument</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">AssignmentElementList</span> <span class="geq">:</span> <span class="nt">AssignmentElementList</span> <code class="t">,</code> <span class="nt">AssignmentElisionElement</span></div>
        <ol class="proc">
          <li>Let <i>status</i> be the result of performing IteratorDestructuringAssignmentEvaluation of
              <i>AssignmentElementList</i> using <i>iteratorRecord</i> as the <i>argument.</i></li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return the result of performing IteratorDestructuringAssignmentEvaluation of <i>AssignmentElisionElement</i> using
              <i>iteratorRecord</i> as the <i>argument</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">AssignmentElisionElement</span> <span class="geq">:</span> <span class="nt">AssignmentElement</span></div>
        <ol class="proc">
          <li><i>R</i>eturn the result of performing IteratorDestructuringAssignmentEvaluation of <i>AssignmentElement</i> with
              <i>iteratorRecord</i> as the argument.</li>
        </ol>
        <div class="gp prod"><span class="nt">AssignmentElisionElement</span> <span class="geq">:</span> <span class="nt">Elision</span> <span class="nt">AssignmentElement</span></div>
        <ol class="proc">
          <li>Let <i>status</i> be the result of performing IteratorDestructuringAssignmentEvaluation of <i>Elision</i> with
              <i>iteratorRecord</i> as the argument.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return the result of performing IteratorDestructuringAssignmentEvaluation of <i>AssignmentElement</i> with
              <i>iteratorRecord</i> as the argument.</li>
        </ol>
        <div class="gp prod"><span class="nt">Elision</span> <span class="geq">:</span> <code class="t">,</code></div>
        <ol class="proc">
          <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, then
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iteratorRecord</i>.[[iterator]]).</li>
              <li>If <i>next</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                  <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, set <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>
        <div class="gp prod"><span class="nt">Elision</span> <span class="geq">:</span> <span class="nt">Elision</span> <code class="t">,</code></div>
        <ol class="proc">
          <li>Let <i>status</i> be the result of performing IteratorDestructuringAssignmentEvaluation of <i>Elision</i> with
              <i>iteratorRecord</i> as the argument.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, then
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iteratorRecord</i>.[[iterator]]).</li>
              <li>If <i>next</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                  <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, set <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>

        <p><span class="nt">AssignmentElement</span><sub>[Yield]</sub> <b>:</b> <span class="nt">DestructuringAssignmentTarget</span>  <span class="nt">Initializer</span><sub>opt</sub></p>

        <ol class="proc">
          <li>If <i>DestructuringAssignmentTarget</i> is neither an <i>ObjectLiteral</i> nor an <i>ArrayLiteral</i>, then
            <ol class="block">
              <li>Let <i>lref</i> be the result of evaluating <i>DestructuringAssignmentTarget</i>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lref</i>).</li>
            </ol>
          </li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, then
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iteratorRecord</i>.[[iterator]]).</li>
              <li>If <i>next</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                  <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, set <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li>Else
                <ol class="block">
                  <li>Let <i>value</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
                  <li>If <i>value</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                      <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>true</b>, let <i>value</i> be <b>undefined</b>.</li>
          <li>If  <i>Initializer</i> is present and <i>value</i> is <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>defaultValue</i> be the result of evaluating <i>Initializer</i>.</li>
              <li>Let <i>v</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>defaultValue</i>)</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
            </ol>
          </li>
          <li>Else, let <i>v</i> be <i>value</i>.</li>
          <li>If <i>DestructuringAssignmentTarget</i> is an <i>ObjectLiteral or an ArrayLiteral</i>, then
            <ol class="block">
              <li>Let <i>nestedAssignmentPattern</i> be the parse of the source text corresponding to
                  <i>DestructuringAssignmentTarget</i> using either <i>AssignmentPattern</i> or
                  <i>AssignmentPattern</i><sub>[Yield]</sub> as the goal symbol depending upon whether this
                  <i>AssignmentElement</i> has the <span style="font-family: sans-serif"><sub>Yield</sub></span> parameter.</li>
              <li>Return the result of performing DestructuringAssignmentEvaluation of <i>nestedAssignmentPattern</i> with
                  <i>v</i> as the argument.</li>
            </ol>
          </li>
          <li>If <i>Initializer</i> is present and <i>value</i> is <b>undefined</b> and <a href="sec-ecmascript-language-functions-and-classes#sec-isanonymousfunctiondefinition">IsAnonymousFunctionDefinition</a>(<i>Initializer)</i> and IsIdentifierRef
              of <i>DestructuringAssignmentTarget</i> are both <b>true</b>, then
            <ol class="block">
              <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>v</i>,
                  <code>"name"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
              <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>v</i>,
                  <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">GetReferencedName</a>(<i>lref</i>)).</li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lref</i>, <i>v</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> Left to right evaluation order is maintained by evaluating a <span class="nt">DestructuringAssignmentTarget</span> that is not a destructuring pattern prior to accessing the iterator or
          evaluating the <span class="nt">Initializer</span>.</p>
        </div>

        <p><i>AssignmentRestElement</i><span style="font-family: sans-serif"><sub>[Yield]</sub> <b>:</b></span> <code>...</code>
        <i>DestructuringAssignmentTarget</i></p>

        <ol class="proc">
          <li>If <i>DestructuringAssignmentTarget</i> is neither an <i>ObjectLiteral</i> nor an <i>ArrayLiteral</i>, then
            <ol class="block">
              <li>Let <i>lref</i> be the result of evaluating <i>DestructuringAssignmentTarget</i>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lref</i>).</li>
            </ol>
          </li>
          <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0).</li>
          <li>Let <i>n</i>=0;</li>
          <li>Repeat while <i>iteratorRecord</i>.[[done]] is <b>false,</b>
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iteratorRecord</i>.[[iterator]]).</li>
              <li>If <i>next</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                  <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, set <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li>else,
                <ol class="block">
                  <li>Let <i>nextValue</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
                  <li>If <i>nextValue</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                      <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextValue</i>).</li>
                  <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>n</i>), <i>nextValue</i>).</li>
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>status</i> is <b>true</b>.</li>
                  <li>Increment <i>n</i> by 1.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>DestructuringAssignmentTarget</i> is neither an <i>ObjectLiteral</i> nor an <i>ArrayLiteral</i>, then
            <ol class="block">
              <li>Return <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lref</i>, <i>A</i>).</li>
            </ol>
          </li>
          <li>Let <i>nestedAssignmentPattern</i> be the parse of the source text corresponding to
              <i>DestructuringAssignmentTarget</i> using either <i>AssignmentPattern</i> or
              <i>AssignmentPattern</i><sub>[Yield]</sub> as the goal symbol depending upon whether this <i>AssignmentElement</i>
              has the <span style="font-family: sans-serif"><sub>Yield</sub></span> parameter.</li>
          <li>Return the result of performing DestructuringAssignmentEvaluation of <i>nestedAssignmentPattern</i> with <i>A</i> as
              the argument.</li>
        </ol>
      </section>

      <section id="sec-runtime-semantics-keyeddestructuringassignmentevaluation">
        <h4 id="sec-12.14.5.4" title="12.14.5.4"> Runtime Semantics: KeyedDestructuringAssignmentEvaluation</h4><p>with parameters <var>value</var> and <var>propertyName</var></p>

        <p><span style="font-family: Times New Roman"><i>AssignmentElement<sub>[Yield]</sub></i></span> <b>:</b> <span class="nt">DestructuringAssignmentTarget</span>   <span class="nt">Initializer</span><sub>opt</sub></p>

        <ol class="proc">
          <li>If <i>DestructuringAssignmentTarget</i> is neither an <i>ObjectLiteral</i> nor an <i>ArrayLiteral</i>, then
            <ol class="block">
              <li>Let <i>lref</i> be the result of evaluating <i>DestructuringAssignmentTarget</i>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lref</i>).</li>
            </ol>
          </li>
          <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-getv">GetV</a>(<i>value</i>, <i>propertyName</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
          <li>If <i>Initializer</i> is present and <i>v</i> is <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>defaultValue</i> be the result of evaluating <i>Initializer</i>.</li>
              <li>Let <i>rhsValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>defaultValue</i>)</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rhsValue</i>).</li>
            </ol>
          </li>
          <li>Else, let <i>rhsValue</i> be <i>v</i>.</li>
          <li>If <i>DestructuringAssignmentTarget</i> is an <i>ObjectLiteral or an ArrayLiteral</i>, then
            <ol class="block">
              <li>Let <i>assignmentPattern</i> be the parse of the source text corresponding to
                  <i>DestructuringAssignmentTarget</i> using either <i>AssignmentPattern</i> or
                  <i>AssignmentPattern</i><sub>[Yield]</sub> as the goal symbol depending upon whether this
                  <i>AssignmentElement</i> has the <span style="font-family: sans-serif"><sub>Yield</sub></span> parameter.</li>
              <li>Return the result of performing DestructuringAssignmentEvaluation of <i>assignmentPattern</i> with
                  <i>rhsValue</i> as the argument.</li>
            </ol>
          </li>
          <li>If <i>Initializer</i> is present and <i>v</i> is <b>undefined</b> and <a href="sec-ecmascript-language-functions-and-classes#sec-isanonymousfunctiondefinition">IsAnonymousFunctionDefinition</a>(<i>Initializer)</i> and IsIdentifierRef
              of <i>DestructuringAssignmentTarget</i> are both <b>true</b>, then
            <ol class="block">
              <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>rhsValue</i>,
                  <code>"name"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
              <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>rhsValue</i>, <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">GetReferencedName</a>(<i>lref</i>)).</li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lref</i>, <i>rhsValue</i>).</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-comma-operator">
    <div class="front">
      <h2 id="sec-12.15" title="12.15"> Comma
          Operator ( </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">Expression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
        <div class="rhs"><span class="nt">Expression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">,</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      </div>
    </div>

    <section id="sec-comma-operator-static-semantics-isfunctiondefinition">
      <h3 id="sec-12.15.1" title="12.15.1"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <div class="gp prod"><span class="nt">Expression</span> <span class="geq">:</span> <span class="nt">Expression</span> <code class="t">,</code> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-comma-operator-static-semantics-isvalidsimpleassignmenttarget">
      <h3 id="sec-12.15.2" title="12.15.2"> Static Semantics:  IsValidSimpleAssignmentTarget</h3><p>See also: <a href="#sec-identifiers-static-semantics-isvalidsimpleassignmenttarget">12.1.3</a>, <a href="#sec-semantics-static-semantics-isvalidsimpleassignmenttarget">12.2.1.5</a>, <a href="#sec-grouping-operator-static-semantics-isvalidsimpleassignmenttarget">12.2.10.3</a>, <a href="#sec-static-semantics-static-semantics-isvalidsimpleassignmenttarget">12.3.1.5</a>, <a href="#sec-postfix-expressions-static-semantics-isvalidsimpleassignmenttarget">12.4.3</a>, <a href="#sec-unary-operators-static-semantics-isvalidsimpleassignmenttarget">12.5.3</a>, <a href="#sec-multiplicative-operators-static-semantics-isvalidsimpleassignmenttarget">12.6.2</a>, <a href="#sec-additive-operators-static-semantics-isvalidsimpleassignmenttarget">12.7.2</a>, <a href="#sec-bitwise-shift-operators-static-semantics-isvalidsimpleassignmenttarget">12.8.2</a>, <a href="#sec-relational-operators-static-semantics-isvalidsimpleassignmenttarget">12.9.2</a>, <a href="#sec-equality-operators-static-semantics-isvalidsimpleassignmenttarget">12.10.2</a>, <a href="#sec-binary-bitwise-operators-static-semantics-isvalidsimpleassignmenttarget">12.11.2</a>, <a href="#sec-binary-logical-operators-static-semantics-isvalidsimpleassignmenttarget">12.12.2</a>, <a href="#sec-conditional-operator-static-semantics-isvalidsimpleassignmenttarget">12.13.2</a>, <a href="#sec-assignment-operators-static-semantics-isvalidsimpleassignmenttarget">12.14.3</a>.</p>

      <div class="gp prod"><span class="nt">Expression</span> <span class="geq">:</span> <span class="nt">Expression</span> <code class="t">,</code> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-comma-operator-runtime-semantics-evaluation">
      <h3 id="sec-12.15.3" title="12.15.3"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">Expression</span> <span class="geq">:</span> <span class="nt">Expression</span> <code class="t">,</code> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Let <i>lref</i> be the result of evaluating <i>Expression</i>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>lref</i>))</li>
        <li>Let <i>rref</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rref</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a> must be called even though its value is not used
        because it may have observable side-effects.</p>
      </div>
    </section>
  </section>
</section>

