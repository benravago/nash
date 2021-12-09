<section id="sec-ecmascript-language-functions-and-classes">
  <div class="front">
    <h1 id="sec-14" title="14"> ECMAScript Language: Functions and Classes</h1><div class="note">
      <p><span class="nh">NOTE</span> Various ECMAScript language elements cause the creation of ECMAScript function objects (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-ecmascript-function-objects">9.2</a>). Evaluation of such functions starts with the execution of their [[Call]]
      internal method (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-ecmascript-function-objects-call-thisargument-argumentslist">9.2.1</a>).</p>
    </div>
  </div>

  <section id="sec-function-definitions">
    <div class="front">
      <h2 id="sec-14.1" title="14.1">
          Function Definitions</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">FunctionDeclaration</span><sub class="g-params">[Yield, Default]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">function</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
        <div class="rhs"><span class="grhsannot">[+Default]</span> <code class="t">function</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">FunctionExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">function</code> <span class="nt">BindingIdentifier</span><sub class="g-opt">opt</sub> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">StrictFormalParameters</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">FormalParameters</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">FormalParameters</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="grhsannot">[empty]</span></div>
        <div class="rhs"><span class="nt">FormalParameterList</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">FormalParameterList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">FunctionRestParameter</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">FormalsList</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">FormalsList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">FunctionRestParameter</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">FormalsList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">FormalParameter</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">FormalsList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">FormalParameter</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">FunctionRestParameter</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingRestElement</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">FormalParameter</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingElement</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">FunctionBody</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">FunctionStatementList</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">FunctionStatementList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">StatementList</span><sub class="g-params">[?Yield, Return]</sub><sub class="g-opt">opt</sub></div>
      </div>
    </div>

    <section id="sec-directive-prologues-and-the-use-strict-directive">
      <h3 id="sec-14.1.1" title="14.1.1"> Directive Prologues and the Use Strict Directive</h3><p>A Directive Prologue is the longest sequence of <span class="nt">ExpressionStatement</span> productions occurring as the
      initial <span class="nt">StatementListItem</span> or <span class="nt">ModuleItem</span> productions of a <span class="nt">FunctionBody</span>, a <span class="nt">ScriptBody</span>, or a <span class="nt">ModuleBody</span> and where each
      <span class="nt">ExpressionStatement</span> in the sequence consists entirely of a <span class="nt">StringLiteral</span>
      token followed by a semicolon<span style="font-family: Times New Roman">.</span> The semicolon may appear explicitly or may
      be inserted by <a href="sec-ecmascript-language-lexical-grammar#sec-automatic-semicolon-insertion">automatic semicolon insertion</a>. A Directive Prologue may be
      an empty sequence.</p>

      <p>A Use Strict Directive is an <span class="nt">ExpressionStatement</span> in a Directive Prologue whose <span class="nt">StringLiteral</span> is either the exact code unit sequences <code>"use</code>&nbsp;<code>strict"</code> or
      <code>'use</code>&nbsp;<code>strict'</code>. A Use Strict Directive may not contain an <span class="nt">EscapeSequence</span> or <span class="nt">LineContinuation</span>.</p>

      <p>A Directive Prologue may contain more than one Use Strict Directive. However, an implementation may issue a warning if
      this occurs.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> The <span class="nt">ExpressionStatement</span> productions of a Directive Prologue are
        evaluated normally during evaluation of the containing production. Implementations may define implementation specific
        meanings for <span class="nt">ExpressionStatement</span> productions which are not a Use Strict Directive and which occur
        in a Directive Prologue. If an appropriate notification mechanism exists, an implementation should issue a warning if it
        encounters in a Directive Prologue an <span class="nt">ExpressionStatement</span> that is not a Use Strict Directive and
        which does not have a meaning defined by the implementation.</p>
      </div>
    </section>

    <section id="sec-function-definitions-static-semantics-early-errors">
      <h3 id="sec-14.1.2" title="14.1.2"> Static Semantics:  Early Errors</h3><p><span class="prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code>
      <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></span><br /><span class="prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></span><br /><span class="prod"><span class="nt">FunctionExpression</span> <span class="geq">:</span> <code class="t">function</code> <span class="nt">BindingIdentifier</span><sub class="g-opt">opt</sub> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span>
      <code class="t">}</code></span></p>

      <ul>
        <li>
          <p>If the source code matching this production is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict code</a>, the Early Error rules
          for <span class="prod"><span class="nt">StrictFormalParameters</span> <span class="geq">:</span> <span class="nt">FormalParameters</span></span> are applied.</p>
        </li>

        <li>
          <p>If the source code matching this production is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict code</a>, it is a Syntax Error
          if <span class="nt">BindingIdentifier</span> is the <span class="nt">IdentifierName</span> <code>eval</code> or the
          <span class="nt">IdentifierName</span> <code>arguments</code>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the BoundNames of <span class="nt">FormalParameters</span> also occurs in the
          LexicallyDeclaredNames of <span class="nt">FunctionBody</span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span class="nt">FormalParameters</span> Contains <span class="nt">SuperProperty</span> is
          <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span class="nt">FunctionBody</span> Contains <span class="nt">SuperProperty</span> is <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span class="nt">FormalParameters</span> Contains <span class="nt">SuperCall</span> is <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span class="nt">FunctionBody</span> Contains <span class="nt">SuperCall</span> is <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE 1</span> The <span style="font-family: Times New Roman">LexicallyDeclaredNames</span> of a <span class="nt">FunctionBody</span> does not include identifiers bound using var or function declarations.</p>
      </div>

      <div class="gp prod"><span class="nt">StrictFormalParameters</span> <span class="geq">:</span> <span class="nt">FormalParameters</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if <span style="font-family: Times New Roman">BoundNames of <i>FormalParameters</i></span>
          contains any duplicate elements.</p>
        </li>
      </ul>
      <div class="gp prod"><span class="nt">FormalParameters</span> <span class="geq">:</span> <span class="nt">FormalParameterList</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if IsSimpleParameterList of <span class="nt">FormalParameterList</span> is <span class="value">false</span> and <span style="font-family: Times New Roman">BoundNames of
          <i>FormalParameterList</i></span> contains any duplicate elements.</p>
        </li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE 2</span> Multiple occurrences of the same <span class="nt">BindingIdentifier</span> in a <span class="nt">FormalParameterList</span> is only allowed for functions and generator functions which have simple parameter
        lists  and which are not defined in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>.</p>
      </div>

      <div class="gp prod"><span class="nt">FunctionBody</span> <span class="geq">:</span> <span class="nt">FunctionStatementList</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if the LexicallyDeclaredNames of <span class="nt">FunctionStatementList</span> contains any
          duplicate entries.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the LexicallyDeclaredNames of <span class="nt">FunctionStatementList</span>
          also occurs in the VarDeclaredNames of <span class="nt">FunctionStatementList</span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if ContainsDuplicateLabels of <span style="font-family: Times New           Roman"><i>FunctionStatementList</i> with argument &laquo; &raquo; is <b>true</b>.</span></p>
        </li>

        <li>
          <p>It is a Syntax Error if ContainsUndefinedBreakTarget of <span style="font-family: Times New           Roman"><i>FunctionStatementList</i> with argument &laquo; &raquo; is <b>true</b>.</span></p>
        </li>

        <li>
          <p>It is a Syntax Error if ContainsUndefinedContinueTarget of <span style="font-family: Times New           Roman"><i>FunctionStatementList</i> with arguments &laquo; &raquo; and &laquo; &raquo; is <b>true</b>.</span></p>
        </li>
      </ul>
    </section>

    <section id="sec-function-definitions-static-semantics-boundnames">
      <h3 id="sec-14.1.3" title="14.1.3"> Static Semantics:  BoundNames</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-boundnames">12.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-boundnames">13.3.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-boundnames">13.3.2.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-boundnames">13.3.3.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-boundnames">13.7.5.2</a>, <a href="#sec-arrow-function-definitions-static-semantics-boundnames">14.2.2</a>, <a href="#sec-generator-function-definitions-static-semantics-boundnames">14.4.2</a>, <a href="#sec-class-definitions-static-semantics-boundnames">14.5.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-imports-static-semantics-boundnames">15.2.2.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-boundnames">15.2.3.2</a>.</p>

      <div class="gp prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return the BoundNames of <i>BindingIdentifier</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return &laquo;<code>"*default*"</code>&raquo;.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> <code>"*default*"</code> is used within this specification as a synthetic name for
        hoistable anonymous functions that are defined using export declarations.</p>
      </div>

      <div class="gp prod"><span class="nt">FormalParameters</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameterList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FunctionRestParameter</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be BoundNames of <i>FormalsList</i>.</li>
        <li>Append to <i>names</i> the BoundNames of <i>FunctionRestParameter.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalsList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FormalParameter</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be BoundNames of <i>FormalsList</i>.</li>
        <li>Append to <i>names</i> the elements of BoundNames of <i>FormalParameter.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-contains">
      <h3 id="sec-14.1.4" title="14.1.4"> Static Semantics:  Contains</h3><p>With parameter <var>symbol</var>.</p>

      <p>See also: <a href="sec-notational-conventions#sec-static-semantic-rules">5.3</a>, <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-contains">12.2.6.3</a>, <a href="sec-ecmascript-language-expressions#sec-static-semantics-static-semantics-contains">12.3.1.1</a>, <a href="#sec-arrow-function-definitions-static-semantics-contains">14.2.3</a>, <a href="#sec-generator-function-definitions-static-semantics-contains">14.4.4</a>, <a href="#sec-class-definitions-static-semantics-contains">14.5.4</a></p>

      <div class="gp prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>

      <p><span class="prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code>
      <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></span><br /><span class="prod"><span class="nt">FunctionExpression</span> <span class="geq">:</span> <code class="t">function</code> <span class="nt">BindingIdentifier</span><sub class="g-opt">opt</sub> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span>
      <code class="t">}</code></span></p>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Static semantic rules that depend upon substructure generally do not look into function
        definitions.</p>
      </div>
    </section>

    <section id="sec-function-definitions-static-semantics-containsexpression">
      <h3 id="sec-14.1.5" title="14.1.5"> Static Semantics:  ContainsExpression</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-containsexpression">13.3.3.2</a>, <a href="#sec-arrow-function-definitions-static-semantics-containsexpression">14.2.4</a>.</p>

      <div class="gp prod"><span class="nt">FormalParameters</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameterList</span> <span class="geq">:</span> <span class="nt">FunctionRestParameter</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameterList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FunctionRestParameter</span></div>
      <ol class="proc">
        <li>Return ContainsExpression of <i>FormalsList</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalsList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FormalParameter</span></div>
      <ol class="proc">
        <li>If ContainsExpression of <i>FormalsList</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsExpression of <i>FormalParameter</i>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-expectedargumentcount">
      <h3 id="sec-14.1.6" title="14.1.6"> Static Semantics:  ExpectedArgumentCount</h3><p>See also: <a href="#sec-arrow-function-definitions-static-semantics-expectedargumentcount">14.2.5</a>, <a href="#sec-method-definitions-static-semantics-expectedargumentcount">14.3.3</a>.</p>

      <div class="gp prod"><span class="nt">FormalParameters</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return 0.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameterList</span> <span class="geq">:</span> <span class="nt">FunctionRestParameter</span></div>
      <ol class="proc">
        <li>Return 0.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameterList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FunctionRestParameter</span></div>
      <ol class="proc">
        <li>Return the ExpectedArgumentCount of <i>FormalsList</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> The <span style="font-family: Times New Roman">ExpectedArgumentCount</span> of a <span class="nt">FormalParameterList</span> is the number of <span class="nt">FormalParameters</span> to the left of either the
        rest parameter or the first <span class="nt">FormalParameter</span> with an Initializer. A <span class="nt">FormalParameter</span> without an initializer is allowed after the first parameter with an initializer but such
        parameters are considered to be optional with <span class="value">undefined</span> as their default value.</p>
      </div>

      <div class="gp prod"><span class="nt">FormalsList</span> <span class="geq">:</span> <span class="nt">FormalParameter</span></div>
      <ol class="proc">
        <li>If HasInitializer of <i>FormalParameter</i>  is <b>true</b> return 0</li>
        <li>Return 1.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalsList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FormalParameter</span></div>
      <ol class="proc">
        <li>Let <i>count</i> be the ExpectedArgumentCount of <i>FormalsList.</i></li>
        <li>If HasInitializer of <i>FormalsList</i> is <b>true</b> or HasInitializer of <i>FormalParameter</i> is <b>true</b>,
            return <i>count</i>.</li>
        <li>Return <i>count</i>+1.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-hasinitializer">
      <h3 id="sec-14.1.7" title="14.1.7"> Static Semantics:  HasInitializer</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-hasinitializer">13.3.3.3</a>, <a href="#sec-arrow-function-definitions-static-semantics-hasinitializer">14.2.6</a>.</p>

      <div class="gp prod"><span class="nt">FormalParameters</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameterList</span> <span class="geq">:</span> <span class="nt">FunctionRestParameter</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameterList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FunctionRestParameter</span></div>
      <ol class="proc">
        <li>If HasInitializer of <i>FormalsList</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalsList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FormalParameter</span></div>
      <ol class="proc">
        <li>If HasInitializer of <i>FormalsList</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return HasInitializer of <i>FormalParameter</i>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-hasname">
      <h3 id="sec-14.1.8" title="14.1.8"> Static Semantics:  HasName</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-semantics-static-semantics-hasname">12.2.1.2</a>, <a href="#sec-arrow-function-definitions-static-semantics-hasname">14.2.7</a>, <a href="#sec-generator-function-definitions-static-semantics-hasname">14.4.7</a>, <a href="#sec-class-definitions-static-semantics-hasname">14.5.6</a>.</p>

      <div class="gp prod"><span class="nt">FunctionExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FunctionExpression</span> <span class="geq">:</span> <code class="t">function</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-isanonymousfunctiondefinition">
      <h3 id="sec-14.1.9" title="14.1.9"> Static Semantics:  IsAnonymousFunctionDefinition ( production )</h3><p class="normalbefore">The abstract operation IsAnonymousFunctionDefinition determines if its argument is a function
      definition that does not bind a name. The argument <var>production</var> is the result of parsing an <span class="nt">AssignmentExpression</span> or <span class="nt">Initializer</span>. The following steps are taken:</p>

      <ol class="proc">
        <li>If IsFunctionDefinition of <i>production</i> is <b>false</b>, return <b>false</b>.</li>
        <li>Let <i>hasName</i> be the result of HasName of <i>production</i>.</li>
        <li>If <i>hasName</i> is <b>true</b>, return <b>false</b>.</li>
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-isconstantdeclaration">
      <h3 id="sec-14.1.10" title="14.1.10"> Static Semantics:  IsConstantDeclaration</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-isconstantdeclaration">13.3.1.3</a>, <a href="#sec-generator-function-definitions-static-semantics-isconstantdeclaration">14.4.8</a>, <a href="#sec-class-definitions-static-semantics-isconstantdeclaration">14.5.7</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-isconstantdeclaration">15.2.3.7</a>.</p>

      <p><span class="prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code>
      <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></span><br /><span class="prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></span></p>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-isfunctiondefinition">
      <h3 id="sec-14.1.11" title="14.1.11"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="sec-ecmascript-language-expressions#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="sec-ecmascript-language-expressions#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="sec-ecmascript-language-expressions#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="sec-ecmascript-language-expressions#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="sec-ecmascript-language-expressions#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="sec-ecmascript-language-expressions#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="sec-ecmascript-language-expressions#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="sec-ecmascript-language-expressions#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="sec-ecmascript-language-expressions#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="sec-ecmascript-language-expressions#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="sec-ecmascript-language-expressions#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="sec-ecmascript-language-expressions#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="sec-ecmascript-language-expressions#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="sec-ecmascript-language-expressions#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>, <a href="#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <div class="gp prod"><span class="nt">FunctionExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FunctionExpression</span> <span class="geq">:</span> <code class="t">function</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-issimpleparameterlist">
      <h3 id="sec-14.1.12" title="14.1.12"> Static Semantics:  IsSimpleParameterList</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-issimpleparameterlist">13.3.3.4</a>, <a href="#sec-arrow-function-definitions-static-semantics-issimpleparameterlist">14.2.8</a></p>

      <div class="gp prod"><span class="nt">FormalParameters</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameterList</span> <span class="geq">:</span> <span class="nt">FunctionRestParameter</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameterList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FunctionRestParameter</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalsList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FormalParameter</span></div>
      <ol class="proc">
        <li>If IsSimpleParameterList of <i>FormalsList</i> is <b>false</b>, return <b>false</b>.</li>
        <li>Return IsSimpleParameterList of <i>FormalParameter</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameter</span> <span class="geq">:</span> <span class="nt">BindingElement</span></div>
      <ol class="proc">
        <li>Return IsSimpleParameterList of <i>BindingElement</i>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-lexicallydeclarednames">
      <h3 id="sec-14.1.13" title="14.1.13"> Static Semantics:  LexicallyDeclaredNames</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-lexicallydeclarednames">13.2.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-lexicallydeclarednames">13.12.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-lexicallydeclarednames">13.13.6</a>, <a href="#sec-arrow-function-definitions-static-semantics-lexicallydeclarednames">14.2.10</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-lexicallydeclarednames">15.1.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-lexicallydeclarednames">15.2.1.11</a>.</p>

      <div class="gp prod"><span class="nt">FunctionStatementList</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FunctionStatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>Return TopLevelLexicallyDeclaredNames of <i>StatementList</i>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-lexicallyscopeddeclarations">
      <h3 id="sec-14.1.14" title="14.1.14"> Static Semantics:  LexicallyScopedDeclarations</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-lexicallyscopeddeclarations">13.2.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-lexicallyscopeddeclarations">13.12.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-lexicallyscopeddeclarations">13.13.7</a>, <a href="#sec-arrow-function-definitions-static-semantics-lexicallyscopeddeclarations">14.2.11</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-lexicallyscopeddeclarations">15.1.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-lexicallyscopeddeclarations">15.2.1.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-lexicallyscopeddeclarations">15.2.3.8</a>.</p>

      <div class="gp prod"><span class="nt">FunctionStatementList</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FunctionStatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>Return the TopLevelLexicallyScopedDeclarations of <i>StatementList</i>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-vardeclarednames">
      <h3 id="sec-14.1.15" title="14.1.15"> Static Semantics:  VarDeclaredNames</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

      <div class="gp prod"><span class="nt">FunctionStatementList</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FunctionStatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>Return TopLevelVarDeclaredNames of <i>StatementList</i>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-static-semantics-varscopeddeclarations">
      <h3 id="sec-14.1.16" title="14.1.16"> Static Semantics:  VarScopedDeclarations</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

      <div class="gp prod"><span class="nt">FunctionStatementList</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FunctionStatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>Return the TopLevelVarScopedDeclarations of <i>StatementList</i>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-runtime-semantics-evaluatebody">
      <h3 id="sec-14.1.17" title="14.1.17"> Runtime Semantics: EvaluateBody</h3><p>With parameter <var>functionObject</var>.</p>

      <p>See also: <a href="#sec-arrow-function-definitions-runtime-semantics-evaluatebody">14.2.15</a>, <a href="#sec-generator-function-definitions-runtime-semantics-evaluatebody">14.4.11</a>.</p>

      <div class="gp prod"><span class="nt">FunctionBody</span> <span class="geq">:</span> <span class="nt">FunctionStatementList</span></div>
      <ol class="proc">
        <li>Return the result of evaluating <i>FunctionStatementList</i>.</li>
      </ol>
    </section>

    <section id="sec-function-definitions-runtime-semantics-iteratorbindinginitialization">
      <h3 id="sec-14.1.18" title="14.1.18"> Runtime Semantics: IteratorBindingInitialization</h3><p>With parameters <var>iteratorRecord</var> and  <var>environment</var>.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> When <b>undefined</b> is passed for <var>environment</var> it indicates that a <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a> operation should be used to assign the initialization value. This is the case for formal
        parameter lists of non-strict functions. In that case the formal parameter bindings are preinitialized in order to deal
        with the possibility of multiple parameters with the same name.</p>
      </div>

      <p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-runtime-semantics-iteratorbindinginitialization">13.3.3.6</a>, <a href="#sec-arrow-function-definitions-runtime-semantics-iteratorbindinginitialization">14.2.14</a>.</p>

      <div class="gp prod"><span class="nt">FormalParameters</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameterList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FunctionRestParameter</span></div>
      <ol class="proc">
        <li>Let <i>restIndex</i> be the result of performing IteratorBindingInitialization for <i>FormalsList</i> using
            <i>iteratorRecord</i>, and <i>environment</i> as the arguments.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>restIndex</i>).</li>
        <li>Return the result of performing IteratorBindingInitialization for <i>FunctionRestParameter</i> using
            <i>iteratorRecord</i> and <i>environment</i> as the arguments.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalsList</span> <span class="geq">:</span> <span class="nt">FormalsList</span> <code class="t">,</code> <span class="nt">FormalParameter</span></div>
      <ol class="proc">
        <li>Let <i>status</i> be the result of performing IteratorBindingInitialization for <i>FormalsList</i> using
            <i>iteratorRecord</i> and <i>environment</i> as the arguments.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
        <li>Return the result of performing IteratorBindingInitialization for <i>FormalParameter</i> using <i>iteratorRecord</i>
            and <i>environment</i> as the arguments.</li>
      </ol>
      <div class="gp prod"><span class="nt">FormalParameter</span> <span class="geq">:</span> <span class="nt">BindingElement</span></div>
      <ol class="proc">
        <li>If HasInitializer of <i>BindingElement</i> is <b>false</b>, return the result of performing
            IteratorBindingInitialization for <i>BindingElement</i> using <i>iteratorRecord</i> and <i>environment</i> as the
            arguments.</li>
        <li>Let <i>currentContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>originalEnv</i> be the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> of <i>currentContext</i>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> and <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <i>currentContext</i> are the same.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>environment</i> and <i>originalEnv</i> are the same.</li>
        <li>Let <i>paramVarEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>originalEnv</i>).</li>
        <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> of <i>currentContext</i> to <i>paramVarEnv</i>.</li>
        <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <i>currentContext</i> to <i>paramVarEnv</i>.</li>
        <li>Let <i>result</i> be the result of performing IteratorBindingInitialization for <i>BindingElement</i> using
            <i>iteratorRecord</i> and <i>environment</i> as the arguments.</li>
        <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> of <i>currentContext</i> to <i>originalEnv</i>.</li>
        <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <i>currentContext</i> to <i>originalEnv</i>.</li>
        <li>Return <i>result</i>.</li>
      </ol>

      <p>The new <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> created in step 6 is only used if the <i><span style="font-family: Times New Roman">BindElement</span>&rsquo;</i>s <span class="nt">Initializer</span> contains a direct
      eval.</p>
    </section>

    <section id="sec-function-definitions-runtime-semantics-instantiatefunctionobject">
      <h3 id="sec-14.1.19" title="14.1.19"> Runtime Semantics: InstantiateFunctionObject</h3><p>With parameter <var>scope</var>.</p>

      <p>See also: <a href="#sec-generator-function-definitions-runtime-semantics-instantiatefunctionobject">14.4.12</a>.</p>

      <div class="gp prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the function code for <i>FunctionDeclaration</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>name</i> be StringValue of <i>BindingIdentifier.</i></li>
        <li>Let <i>F</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functioncreate">FunctionCreate</a>(<span style="font-family: sans-serif">Normal</span>,
            <i>FormalParameters</i>, <i>FunctionBody, scope</i>, <i>strict</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>F</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>F</i>, <i>name</i>).</li>
        <li>Return <i>F</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the function code for <i>FunctionDeclaration</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>F</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functioncreate">FunctionCreate</a>(<span style="font-family: sans-serif">Normal</span>,
            <i>FormalParameters</i>, <i>FunctionBody, scope</i>, <i>strict</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>F</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>F</i>, <code>"default"</code>).</li>
        <li>Return <i>F</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> An anonymous <span class="nt">FunctionDeclaration</span> can only occur as part of an
        <code>export default</code> declaration.</p>
      </div>
    </section>

    <section id="sec-function-definitions-runtime-semantics-evaluation">
      <h3 id="sec-14.1.20" title="14.1.20"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 1</span> An alternative semantics is provided in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-block-level-function-declarations-web-legacy-compatibility-semantics">B.3.3</a>.</p>
      </div>

      <div class="gp prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
      </ol>
      <div class="gp prod"><span class="nt">FunctionExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the function code for <i>FunctionExpression</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>scope</i> be the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>closure</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functioncreate">FunctionCreate</a>(<span style="font-family:             sans-serif">Normal</span>, <i>FormalParameters</i>, <i>FunctionBody, scope</i>, <i>strict</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>closure</i>).</li>
        <li>Return <i>closure</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">FunctionExpression</span> <span class="geq">:</span> <code class="t">function</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the function code for <i>FunctionExpression</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>runningContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a>.</li>
        <li>Let <i>funcEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>runningContext</i>
            ).</li>
        <li>Let <i>envRec</i> be <i>funcEnv&rsquo;s</i> <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
        <li>Let <i>name</i> be StringValue of <i>BindingIdentifier</i>.</li>
        <li>Perform <i>envRec.</i>CreateImmutableBinding(<i>name</i>).</li>
        <li>Let <i>closure</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functioncreate">FunctionCreate</a>(<span style="font-family:             sans-serif">Normal</span>, <i>FormalParameters</i>, <i>FunctionBody, funcEnv</i>, <i>strict</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>closure</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>closure</i>, <i>name</i>).</li>
        <li>Perform <i>envRec</i>.InitializeBinding(<i>name,</i> <i>closure</i>).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>closure</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 2</span> The <span class="nt">BindingIdentifier</span> in a <span class="nt">FunctionExpression</span> can be referenced from inside the <var>FunctionExpression's</var> <span class="nt">FunctionBody</span> to allow the function to call itself recursively. However, unlike in a <span class="nt">FunctionDeclaration</span>, the <span class="nt">BindingIdentifier</span> in a <span class="nt">FunctionExpression</span> cannot be referenced from and does not affect the scope enclosing the <span class="nt">FunctionExpression</span>.</p>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 3</span> A <code>prototype</code> property is automatically created for every function defined
        using a <span class="nt">FunctionDeclaration</span> or <span class="nt">FunctionExpression</span>, to allow for the
        possibility that the function will be used as a constructor.</p>
      </div>

      <div class="gp prod"><span class="nt">FunctionStatementList</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
      </ol>
    </section>
  </section>

  <section id="sec-arrow-function-definitions">
    <div class="front">
      <h2 id="sec-14.2" title="14.2"> Arrow Function Definitions</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">ArrowFunction</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ArrowParameters</span><sub class="g-params">[?Yield]</sub> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">=&gt;</code> <span class="nt">ConciseBody</span><sub class="g-params">[?In]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ArrowParameters</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ConciseBody</span><sub class="g-params">[In]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="grhsannot">[lookahead &ne; { ]</span> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In]</sub></div>
        <div class="rhs"><code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      </div>

      <h2>Supplemental Syntax</h2>

      <p>When the production</p>

      <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nt">ArrowParameters</span><sub>[Yield]</sub>  <b>:</b> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub>[?Yield]</sub></p>

      <p>is recognized the following grammar is used to refine the interpretation of <span class="prod"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span> <span class="geq">:</span></span></p>

      <div class="gp">
        <div class="lhs"><span class="nt">ArrowFormalParameters</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">(</code> <span class="nt">StrictFormalParameters</span><sub class="g-params">[?Yield]</sub> <code class="t">)</code></div>
      </div>
    </div>

    <section id="sec-arrow-function-definitions-static-semantics-early-errors">
      <h3 id="sec-14.2.1" title="14.2.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">ArrowFunction</span> <span class="geq">:</span> <span class="nt">ArrowParameters</span> <code class="t">=&gt;</code> <span class="nt">ConciseBody</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if <span class="nt">ArrowParameters</span> Contains <span class="nt">YieldExpression</span> is
          <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span class="nt">ConciseBody</span> Contains <span class="nt">YieldExpression</span> is <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the <span style="font-family: Times New Roman">BoundNames</span> of <span class="nt">ArrowParameters</span> also occurs in the LexicallyDeclaredNames of <span class="nt">ConciseBody</span>.</p>
        </li>
      </ul>

      <p><span class="nt">ArrowParameters</span><sub>[Yield]</sub> <b>:</b> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub>[?Yield]</sub></p>

      <ul>
        <li>
          <p>If the <sub>[Yield]</sub> grammar parameter is present  on  <span class="nt">ArrowParameters</span>, it is a Syntax
          Error if the lexical token sequence matched by <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub>[?Yield]</sub> cannot be parsed with no tokens
          left over using <span class="nt">ArrowFormalParameters</span><sub>[Yield]</sub> as the goal symbol.</p>
        </li>

        <li>
          <p>If the <sub>[Yield]</sub> grammar parameter is not present on <span class="nt">ArrowParameters</span>, it is a Syntax
          Error if the lexical token sequence matched by <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub>[?Yield]</sub> cannot be parsed with no tokens
          left over using <span class="nt">ArrowFormalParameters</span> as the goal symbol.</p>
        </li>

        <li>
          <p>All early errors rules for <span class="nt">ArrowFormalParameters</span> and its derived productions also apply to
          CoveredFormalsList of <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub>[?Yield]</sub>.</p>
        </li>
      </ul>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-boundnames">
      <h3 id="sec-14.2.2" title="14.2.2"> Static Semantics:  BoundNames</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-boundnames">12.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-boundnames">13.3.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-boundnames">13.3.2.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-boundnames">13.3.3.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-boundnames">13.7.5.2</a>, <a href="#sec-function-definitions-static-semantics-boundnames">14.1.3</a>, <a href="#sec-generator-function-definitions-static-semantics-boundnames">14.4.2</a>, <a href="#sec-class-definitions-static-semantics-boundnames">14.5.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-imports-static-semantics-boundnames">15.2.2.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-boundnames">15.2.3.2</a>.</p>

      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
      <ol class="proc">
        <li>Let <i>formals</i> be CoveredFormalsList of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
        <li>Return the BoundNames of <i>formals</i>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-contains">
      <h3 id="sec-14.2.3" title="14.2.3"> Static Semantics:  Contains</h3><p>With parameter <var>symbol</var>.</p>

      <p>See also: <a href="sec-notational-conventions#sec-static-semantic-rules">5.3</a>, <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-contains">12.2.6.3</a>, <a href="sec-ecmascript-language-expressions#sec-static-semantics-static-semantics-contains">12.3.1.1</a>, <a href="#sec-function-definitions-static-semantics-contains">14.1.4</a>, <a href="#sec-generator-function-definitions-static-semantics-contains">14.4.4</a>, <a href="#sec-class-definitions-static-semantics-contains">14.5.4</a></p>

      <div class="gp prod"><span class="nt">ArrowFunction</span> <span class="geq">:</span> <span class="nt">ArrowParameters</span> <code class="t">=&gt;</code> <span class="nt">ConciseBody</span></div>
      <ol class="proc">
        <li>If <i>symbol</i> is not one of <i>NewTarget</i>, <i>SuperProperty, SuperCall,</i> <code>super</code> or
            <code>this</code>, return <b>false</b>.</li>
        <li>If <i>ArrowParameters</i> Contains <i>symbol</i> is <b>true</b>, return <b>true</b>;</li>
        <li>Return <i>ConciseBody</i> Contains <i>symbol</i> .</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Normally, <span style="font-family: Times New Roman">Contains</span> does not look inside
        most function forms  However, <span style="font-family: Times New Roman">Contains</span> is used to detect
        <code>new.target</code>, <code>this</code>, and <code>super</code> usage within an <span class="nt">ArrowFunction</span>.</p>
      </div>

      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
      <ol class="proc">
        <li>Let <i>formals</i> be CoveredFormalsList of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
        <li>Return <i>formals</i> Contains <i>symbol</i>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-containsexpression">
      <h3 id="sec-14.2.4" title="14.2.4"> Static Semantics:  ContainsExpression</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-containsexpression">13.3.3.2</a>, <a href="#sec-function-definitions-static-semantics-containsexpression">14.1.5</a>.</p>

      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>

      <p><span class="prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></span></p>

      <ol class="proc">
        <li>Let <i>formals</i> be CoveredFormalsList of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
        <li>Return the ContainsExpression of <i>formals</i>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-expectedargumentcount">
      <h3 id="sec-14.2.5" title="14.2.5"> Static Semantics:  ExpectedArgumentCount</h3><p>See also: <a href="#sec-function-definitions-static-semantics-expectedargumentcount">14.1.6</a>,<a href="#sec-method-definitions-static-semantics-expectedargumentcount">14.3.3</a>.</p>

      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
      <ol class="proc">
        <li>Return 1.</li>
      </ol>
      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
      <ol class="proc">
        <li>Let <i>formals</i> be CoveredFormalsList of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
        <li>Return the ExpectedArgumentCount of <i>formals</i>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-hasinitializer">
      <h3 id="sec-14.2.6" title="14.2.6"> Static Semantics:  HasInitializer</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-hasinitializer">13.3.3.3</a>, <a href="#sec-function-definitions-static-semantics-hasinitializer">14.1.7</a>.</p>

      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
      <ol class="proc">
        <li>Let <i>formals</i> be CoveredFormalsList of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
        <li>Return the HasInitializer of <i>formals</i>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-hasname">
      <h3 id="sec-14.2.7" title="14.2.7"> Static Semantics:  HasName</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-semantics-static-semantics-hasname">12.2.1.2</a>, <a href="#sec-function-definitions-static-semantics-hasname">14.1.8</a>, <a href="#sec-generator-function-definitions-static-semantics-hasname">14.4.7</a>, <a href="#sec-class-definitions-static-semantics-hasname">14.5.6</a>.</p>

      <div class="gp prod"><span class="nt">ArrowFunction</span> <span class="geq">:</span> <span class="nt">ArrowParameters</span> <code class="t">=&gt;</code> <span class="nt">ConciseBody</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-issimpleparameterlist">
      <h3 id="sec-14.2.8" title="14.2.8"> Static Semantics:  IsSimpleParameterList</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-issimpleparameterlist">13.3.3.4</a>, <a href="#sec-function-definitions-static-semantics-issimpleparameterlist">14.1.12</a>.</p>

      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
      <ol class="proc">
        <li>Let <i>formals</i> be CoveredFormalsList of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
        <li>Return the IsSimpleParameterList of <i>formals</i>.</li>
      </ol>
    </section>

    <section id="sec-static-semantics-coveredformalslist">
      <h3 id="sec-14.2.9" title="14.2.9"> Static Semantics:  CoveredFormalsList</h3><div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
      <ol class="proc">
        <li>Return <i>BindingIdentifier</i>.</li>
      </ol>

      <div class="gp">
        <div class="lhs"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code></div>
        <div class="rhs"><code class="t">(</code> <code class="t">)</code></div>
        <div class="rhs"><code class="t">(</code> <code class="t">...</code> <span class="nt">BindingIdentifier</span> <code class="t">)</code></div>
        <div class="rhs"><code class="t">(</code> <span class="nt">Expression</span> <code class="t">,</code> <code class="t">...</code> <span class="nt">BindingIdentifier</span> <code class="t">)</code></div>
      </div>

      <ol class="proc">
        <li>If the <sub>[Yield]</sub> grammar parameter is present for
            <i>CoverParenthesizedExpressionAndArrowParameterList</i><sub>[Yield]</sub> return the result of parsing the lexical
            token stream matched by <i>CoverParenthesizedExpressionAndArrowParameterList</i><sub>[Yield]</sub> using
            <i>ArrowFormalParameters</i><sub>[Yield]</sub> as the goal symbol.</li>
        <li>If the <sub>[Yield]</sub> grammar parameter is not present for
            <i>CoverParenthesizedExpressionAndArrowParameterList</i><sub>[Yield]</sub> return the result of parsing the lexical
            token stream matched by <i>CoverParenthesizedExpressionAndArrowParameterList</i> using <i>ArrowFormalParameters</i> as
            the goal symbol.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-lexicallydeclarednames">
      <h3 id="sec-14.2.10" title="14.2.10"> Static Semantics:  LexicallyDeclaredNames</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-lexicallydeclarednames">13.2.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-lexicallydeclarednames">13.12.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-lexicallydeclarednames">13.13.6</a>, <a href="#sec-function-definitions-static-semantics-lexicallydeclarednames">14.1.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-lexicallydeclarednames">15.1.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-lexicallydeclarednames">15.2.1.11</a>.</p>

      <div class="gp prod"><span class="nt">ConciseBody</span> <span class="geq">:</span> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-lexicallyscopeddeclarations">
      <h3 id="sec-14.2.11" title="14.2.11"> Static Semantics:  LexicallyScopedDeclarations</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-lexicallyscopeddeclarations">13.2.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-lexicallyscopeddeclarations">13.12.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-lexicallyscopeddeclarations">13.13.7</a>, <a href="#sec-function-definitions-static-semantics-lexicallyscopeddeclarations">14.1.14</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-lexicallyscopeddeclarations">15.1.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-lexicallyscopeddeclarations">15.2.1.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-lexicallyscopeddeclarations">15.2.3.8</a>.</p>

      <div class="gp prod"><span class="nt">ConciseBody</span> <span class="geq">:</span> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-vardeclarednames">
      <h3 id="sec-14.2.12" title="14.2.12"> Static Semantics:  VarDeclaredNames</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

      <div class="gp prod"><span class="nt">ConciseBody</span> <span class="geq">:</span> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-static-semantics-varscopeddeclarations">
      <h3 id="sec-14.2.13" title="14.2.13"> Static Semantics:  VarScopedDeclarations</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

      <div class="gp prod"><span class="nt">ConciseBody</span> <span class="geq">:</span> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-runtime-semantics-iteratorbindinginitialization">
      <h3 id="sec-14.2.14" title="14.2.14"> Runtime Semantics: IteratorBindingInitialization</h3><p>With parameters <var>iteratorRecord</var> and <var>environment</var>.</p>

      <p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-runtime-semantics-iteratorbindinginitialization">13.3.3.6</a>, <a href="#sec-function-definitions-runtime-semantics-iteratorbindinginitialization">14.1.18</a>.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> When <b>undefined</b> is passed for <var>environment</var> it indicates that a <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a> operation should be used to assign the initialization value. This is the case for formal
        parameter lists of non-strict functions. In that case the formal parameter bindings are preinitialized in order to deal
        with the possibility of multiple parameters with the same name.</p>
      </div>

      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>iteratorRecord</i>.[[done]] is <b>false.</b></li>
        <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iteratorRecord</i>.[[iterator]]).</li>
        <li>If <i>next</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
            <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
        <li>If <i>next</i> is <b>false</b>, set <i>iteratorRecord</i>.[[done]] to <b>true</b></li>
        <li>Else
          <ol class="block">
            <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
            <li>If <i>v</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
          </ol>
        </li>
        <li>If <i>iteratorRecord</i>.[[done]] is <b>true</b>, let <i>v</i> be <b>undefined</b>.</li>
        <li>Return the result of performing BindingInitialization for <i>BindingIdentifier</i> using <i>v</i> and
            <i>environment</i> as the arguments.</li>
      </ol>
      <div class="gp prod"><span class="nt">ArrowParameters</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
      <ol class="proc">
        <li>Let <i>formals</i> be CoveredFormalsList of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
        <li>Return the result of performing IteratorBindingInitialization of <i>formals</i> with arguments <i>iteratorRecord</i>
            and <i>environment</i>.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-runtime-semantics-evaluatebody">
      <h3 id="sec-14.2.15" title="14.2.15"> Runtime Semantics: EvaluateBody</h3><p>With parameter <var>functionObject</var>.</p>

      <p>See also: <a href="#sec-function-definitions-runtime-semantics-evaluatebody">14.1.17</a>, <a href="#sec-generator-function-definitions-runtime-semantics-evaluatebody">14.4.11</a>.</p>

      <div class="gp prod"><span class="nt">ConciseBody</span> <span class="geq">:</span> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Let <i>exprRef</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
        <li>Let <i>exprValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exprValue</i>).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:             sans-serif">return</span>, [[value]]: <i>exprValue</i>, [[target]]: <span style="font-family:             sans-serif">empty</span>}.</li>
      </ol>
    </section>

    <section id="sec-arrow-function-definitions-runtime-semantics-evaluation">
      <h3 id="sec-14.2.16" title="14.2.16"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">ArrowFunction</span> <span class="geq">:</span> <span class="nt">ArrowParameters</span> <code class="t">=&gt;</code> <span class="nt">ConciseBody</span></div>
      <ol class="proc">
        <li>If the function code for this <i>ArrowFunction</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> (<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">10.2.1</a>), let  <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be
            <b>false</b>.</li>
        <li>Let <i>scope</i> be the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>parameters</i> be CoveredFormalsList of <i>ArrowParameters</i>.</li>
        <li>Let <i>closure</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functioncreate">FunctionCreate</a>(<span style="font-family:             sans-serif">Arrow</span>, <i>parameters</i>, <i>ConciseBody, scope</i>, <i>strict</i>).</li>
        <li>Return <i>closure</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> An <span class="nt">ArrowFunction</span> does not define local bindings for
        <code>arguments</code>, <code>super</code>, <code>this</code>, or <code>new.target</code>. Any reference to
        <code>arguments</code>, <code>super</code>, <code>this</code>, or <code>new.target</code> within an <span class="nt">ArrowFunction</span> must resolve to a binding in a lexically enclosing environment. Typically this will be the
        Function Environment of an immediately enclosing function. Even though an <span class="nt">ArrowFunction</span> may
        contain references to <code>super</code>, the function object created in step 4 is not made into a method by performing <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makemethod">MakeMethod</a>. An <span class="nt">ArrowFunction</span> that references <code>super</code> is
        always contained within a non-<span class="nt">ArrowFunction</span> and the necessary state to implement
        <code>super</code> is accessible via the <var>scope</var> that is captured by the function object of the <span style="font-family: Times New Roman"><i>ArrowFunction</i>.</span></p>
      </div>
    </section>
  </section>

  <section id="sec-method-definitions">
    <div class="front">
      <h2 id="sec-14.3" title="14.3"> Method
          Definitions</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">MethodDefinition</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
        <div class="rhs"><span class="nt">GeneratorMethod</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">get</code> <span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
        <div class="rhs"><code class="t">set</code> <span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <span class="nt">PropertySetParameterList</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">PropertySetParameterList</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">FormalParameter</span></div>
      </div>
    </div>

    <section id="sec-method-definitions-static-semantics-early-errors">
      <h3 id="sec-14.3.1" title="14.3.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ul>
        <li>
          <p>It is a Syntax Error if any element of the <span style="font-family: Times New Roman">BoundNames</span> of <span class="nt">StrictFormalParameters</span> also occurs in the <span style="font-family: Times New           Roman">LexicallyDeclaredNames</span> of <span class="nt">FunctionBody</span>.</p>
        </li>
      </ul>
      <div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <code class="t">set</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">PropertySetParameterList</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ul>
        <li>
          <p>It is a Syntax Error if <span style="font-family: Times New Roman">BoundNames of
          <i>PropertySetParameterList</i></span> contains any duplicate elements.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the BoundNames of <span class="nt">PropertySetParameterList</span> also occurs
          in the LexicallyDeclaredNames of <span class="nt">FunctionBody</span>.</p>
        </li>
      </ul>
    </section>

    <section id="sec-method-definitions-static-semantics-computedpropertycontains">
      <h3 id="sec-14.3.2" title="14.3.2"> Static Semantics:  ComputedPropertyContains</h3><p>With parameter <var>symbol</var>.</p>

      <p>See also: <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-computedpropertycontains">12.2.6.2</a>, <a href="#sec-generator-function-definitions-static-semantics-computedpropertycontains">14.4.3</a>, <a href="#sec-class-definitions-static-semantics-computedpropertycontains">14.5.5</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">MethodDefinition</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
        <div class="rhs"><code class="t">get</code> <span class="nt">PropertyName</span> <code class="t">(</code> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
        <div class="rhs"><code class="t">set</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">PropertySetParameterList</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      </div>

      <ol class="proc">
        <li>Return the result of ComputedPropertyContains for <i>PropertyName</i> with argument <i>symbol</i>.</li>
      </ol>
    </section>

    <section id="sec-method-definitions-static-semantics-expectedargumentcount">
      <h3 id="sec-14.3.3" title="14.3.3"> Static Semantics:  ExpectedArgumentCount</h3><p>See also: <a href="#sec-function-definitions-static-semantics-expectedargumentcount">14.1.6</a>, <a href="#sec-arrow-function-definitions-static-semantics-expectedargumentcount">14.2.5</a>.</p>

      <div class="gp prod"><span class="nt">PropertySetParameterList</span> <span class="geq">:</span> <span class="nt">FormalParameter</span></div>
      <ol class="proc">
        <li>If HasInitializer of <i>FormalParameter</i>  is <b>true</b> return 0</li>
        <li>Return 1.</li>
      </ol>
    </section>

    <section id="sec-method-definitions-static-semantics-hascomputedpropertykey">
      <h3 id="sec-14.3.4" title="14.3.4"> Static Semantics:  HasComputedPropertyKey</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-hascomputedpropertykey">12.2.6.4</a>, <a href="#sec-generator-function-definitions-static-semantics-hascomputedpropertykey">14.4.5</a></p>

      <div class="gp">
        <div class="lhs"><span class="nt">MethodDefinition</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
        <div class="rhs"><code class="t">get</code> <span class="nt">PropertyName</span> <code class="t">(</code> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
        <div class="rhs"><code class="t">set</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">PropertySetParameterList</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      </div>

      <ol class="proc">
        <li>Return HasComputedPropertyKey of <i>PropertyName</i>.</li>
      </ol>
    </section>

    <section id="sec-method-definitions-static-semantics-hasdirectsuper">
      <h3 id="sec-14.3.5" title="14.3.5"> Static Semantics:  HasDirectSuper</h3><p>See also: <a href="#sec-generator-function-definitions-static-semantics-hasdirectsuper">14.4.6</a>.</p>

      <div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If <i>StrictFormalParameters</i> Contains <i>SuperCall</i> is <b>true</b>, return <b>true.</b></li>
        <li>Return <i>FunctionBody</i> Contains <i>SuperCall</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <code class="t">get</code> <span class="nt">PropertyName</span> <code class="t">(</code> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <i>FunctionBody</i> Contains <i>SuperCall</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <code class="t">set</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">PropertySetParameterList</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If <i>PropertySetParameterList</i> Contains <i>SuperCall</i> is <b>true</b>, return <b>true.</b></li>
        <li>Return <i>FunctionBody</i> Contains <i>SuperCall</i>.</li>
      </ol>
    </section>

    <section id="sec-method-definitions-static-semantics-propname">
      <h3 id="sec-14.3.6" title="14.3.6"> Static Semantics:  PropName</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-propname">12.2.6.6</a>, <a href="#sec-generator-function-definitions-static-semantics-propname">14.4.10</a>, <a href="#sec-class-definitions-static-semantics-propname">14.5.12</a></p>

      <div class="gp">
        <div class="lhs"><span class="nt">MethodDefinition</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
        <div class="rhs"><code class="t">get</code> <span class="nt">PropertyName</span> <code class="t">(</code> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
        <div class="rhs"><code class="t">set</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">PropertySetParameterList</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      </div>

      <ol class="proc">
        <li>Return PropName of <i>PropertyName</i>.</li>
      </ol>
    </section>

    <section id="sec-static-semantics-specialmethod">
      <h3 id="sec-14.3.7" title="14.3.7"> Static Semantics:  SpecialMethod</h3><div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>

      <div class="gp">
        <div class="lhs"><span class="nt">MethodDefinition</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">GeneratorMethod</span></div>
        <div class="rhs"><code class="t">get</code> <span class="nt">PropertyName</span> <code class="t">(</code> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
        <div class="rhs"><code class="t">set</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">PropertySetParameterList</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      </div>

      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-runtime-semantics-definemethod">
      <h3 id="sec-14.3.8" title="14.3.8"> Runtime Semantics: DefineMethod</h3><p>With parameters <var>object</var> and optional parameter <span style="font-family: Times New       Roman"><i>functionPrototype</i>.</span></p>

      <div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Let <i>propKey</i> be the result of evaluating <i>PropertyName</i>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propKey</i>).</li>
        <li>If the function code for this <i>MethodDefinition</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>scope</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
        <li>If <i>functionPrototype</i> was passed as a parameter, let <i>kind</i> be <span style="font-family:             sans-serif">Normal</span>; otherwise let <i>kind</i> be <span style="font-family: sans-serif">Method</span>.</li>
        <li>Let <i>closure</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functioncreate">FunctionCreate</a>(<i>kind</i>, <i>StrictFormalParameters</i>,
            <i>FunctionBody, scope</i>, <i>strict</i>). If <i>functionPrototype</i> was passed as a parameter then pass its value
            as the <i>functionPrototype</i> optional argument of <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functioncreate">FunctionCreate</a>.</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makemethod">MakeMethod</a>(<i>closure</i>, <i>object</i>).</li>
        <li>Return the Record{[[key]]: <i>propKey</i>, [[closure]]: <i>closure</i>}.</li>
      </ol>
    </section>

    <section id="sec-method-definitions-runtime-semantics-propertydefinitionevaluation">
      <h3 id="sec-14.3.9" title="14.3.9"> Runtime Semantics: PropertyDefinitionEvaluation</h3><p>With parameters <var>object</var> and <span style="font-family: Times New Roman"><i>enumerable</i>.</span></p>

      <p>See also: <a href="sec-ecmascript-language-expressions#sec-object-initializer-runtime-semantics-propertydefinitionevaluation">12.2.6.9</a>, <a href="#sec-generator-function-definitions-runtime-semantics-propertydefinitionevaluation">14.4.13</a>, B.3.1</p>

      <div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Let <i>methodDef</i> be DefineMethod of <i>MethodDefinition</i> with argument <i>object</i>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>methodDef</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>methodDef</i>.[[closure]],
            <i>methodDef</i>.[[key]]).</li>
        <li>Let <i>desc</i> be the <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a>{[[Value]]:
            <i>methodDef</i>.[[closure]], [[Writable]]: <b>true</b>, [[Enumerable]]: <i>enumerable</i>, [[Configurable]]:
            <b>true</b>}.</li>
        <li>Return <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>object</i>, <i>methodDef</i>.[[key]],
            <i>desc</i>).</li>
      </ol>
      <div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <span class="nt">GeneratorMethod</span></div>

      <p>See <a href="#sec-generator-function-definitions">14.4</a>.</p>

      <div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <code class="t">get</code> <span class="nt">PropertyName</span> <code class="t">(</code> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Let <i>propKey</i> be the result of evaluating <i>PropertyName</i>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propKey</i>).</li>
        <li>If the function code for this <i>MethodDefinition</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>scope</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
        <li>Let <i>formalParameterList</i> be the production  <span class="prod"><span class="nt">FormalParameters</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></span></li>
        <li>Let <i>closure</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functioncreate">FunctionCreate</a>(<span style="font-family:             sans-serif">Method</span>, <i>formalParameterList</i>, <i>FunctionBody, scope</i>, <i>strict</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makemethod">MakeMethod</a>(<i>closure</i>, <i>object</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>closure</i>, <i>propKey</i>,
            <code>"<b>get</b>"</code>).</li>
        <li>Let <i>desc</i> be the PropertyDescriptor{[[Get]]: <i>closure</i>, [[Enumerable]]: <i>enumerable</i>,
            [[Configurable]]: <b>true</b>}</li>
        <li>Return <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>object</i>, <i>propKey</i>,
            <i>desc</i>).</li>
      </ol>
      <div class="gp prod"><span class="nt">MethodDefinition</span> <span class="geq">:</span> <code class="t">set</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">PropertySetParameterList</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Let <i>propKey</i> be the result of evaluating <i>PropertyName</i>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propKey</i>).</li>
        <li>If the function code for this <i>MethodDefinition</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>scope</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
        <li>Let <i>closure</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functioncreate">FunctionCreate</a>(<span style="font-family:             sans-serif">Method</span>, <i>PropertySetParameterList</i>, <i>FunctionBody, scope</i>, <i>strict</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makemethod">MakeMethod</a>(<i>closure</i>, <i>object</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>closure</i>, <i>propKey</i>,
            <code>"<b>set</b>"</code>).</li>
        <li>Let <i>desc</i> be the PropertyDescriptor{[[Set]]: <i>closure</i>, [[Enumerable]]: <i>enumerable</i>,
            [[Configurable]]: <b>true</b>}</li>
        <li>Return <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>object</i>, <i>propKey</i>,
            <i>desc</i>).</li>
      </ol>
    </section>
  </section>

  <section id="sec-generator-function-definitions">
    <div class="front">
      <h2 id="sec-14.4" title="14.4"> Generator Function Definitions</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">GeneratorMethod</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">*</code> <span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <span class="nt">StrictFormalParameters</span><sub class="g-params">[Yield]</sub> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">GeneratorDeclaration</span><sub class="g-params">[Yield, Default]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <span class="nt">FormalParameters</span><sub class="g-params">[Yield]</sub> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
        <div class="rhs"><span class="grhsannot">[+Default]</span> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span><sub class="g-params">[Yield]</sub> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">GeneratorExpression</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[Yield]</sub><sub class="g-opt">opt</sub> <code class="t">(</code> <span class="nt">FormalParameters</span><sub class="g-params">[Yield]</sub> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">GeneratorBody</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">FunctionBody</span><sub class="g-params">[Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">YieldExpression</span><sub class="g-params">[In]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">yield</code></div>
        <div class="rhs"><code class="t">yield</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, Yield]</sub></div>
        <div class="rhs"><code class="t">yield</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">*</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, Yield]</sub></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 1</span> The syntactic context immediately following <code>yield</code> requires use of the <span class="nt">InputElementRegExpOrTemplateTail</span> lexical goal.</p>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 2</span> <span class="nt">YieldExpression</span> cannot be used within the <span class="nt">FormalParameters</span> of a generator function because any expressions that are part of <span class="nt">FormalParameters</span> are evaluated before the resulting generator object is in a resumable state.</p>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 3</span> Abstract operations relating to generator objects are defined in <a href="sec-control-abstraction-objects#sec-generator-abstract-operations">25.3.3</a>.</p>
      </div>
    </div>

    <section id="sec-generator-function-definitions-static-semantics-early-errors">
      <h3 id="sec-14.4.1" title="14.4.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">GeneratorMethod</span> <span class="geq">:</span> <code class="t">*</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ul>
        <li>
          <p>It is a Syntax Error if HasDirectSuper of <span class="nt">GeneratorMethod</span>  is <span style="font-family: Times           New Roman"><b><i>true</i></b></span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span class="nt">StrictFormalParameters</span> Contains <span class="nt">YieldExpression</span> is <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the <span style="font-family: Times New Roman">BoundNames</span> of <span class="nt">StrictFormalParameters</span> also occurs in the <span style="font-family: Times New           Roman">LexicallyDeclaredNames</span> of <span class="nt">GeneratorBody</span>.</p>
        </li>
      </ul>
      <div class="gp prod"><span class="nt">GeneratorDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ul>
        <li>It is a Syntax Error if HasDirectSuper of <span class="nt">GeneratorDeclaration</span> is <span style="font-family:             Times New Roman"><b><i>true</i></b></span>.</li>
      </ul>
      <div class="gp prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span><sub class="g-opt">opt</sub> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ul>
        <li>It is a Syntax Error if HasDirectSuper of <span class="nt">GeneratorExpression</span> is <span style="font-family:             Times New Roman"><b><i>true</i></b></span>.</li>
      </ul>

      <p><span class="prod"><span class="nt">GeneratorDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span>
      <code class="t">}</code></span><br /><span class="prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span>
      <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span><sub class="g-opt">opt</sub> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></span></p>

      <ul>
        <li>
          <p>If the source code matching this production is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict code</a>, the Early Error rules
          for <span class="prod"><span class="nt">StrictFormalParameters</span> <span class="geq">:</span> <span class="nt">FormalParameters</span></span> are applied.</p>
        </li>

        <li>
          <p>If the source code matching this production is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict code</a>, it is a Syntax Error
          if <span class="nt">BindingIdentifier</span> is the <span class="nt">IdentifierName</span> <code>eval</code> or the
          <span class="nt">IdentifierName</span> <code>arguments</code>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the <span style="font-family: Times New Roman">BoundNames</span> of <span class="nt">FormalParameters</span> also occurs in the <span style="font-family: Times New           Roman">LexicallyDeclaredNames</span> of <span class="nt">GeneratorBody</span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span class="nt">FormalParameters</span> Contains <span class="nt">YieldExpression</span> is
          <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span class="nt">FormalParameters</span> Contains <span class="nt">SuperProperty</span> is
          <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span class="nt">GeneratorBody</span> Contains <span class="nt">SuperProperty</span> is <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>
      </ul>
    </section>

    <section id="sec-generator-function-definitions-static-semantics-boundnames">
      <h3 id="sec-14.4.2" title="14.4.2"> Static Semantics:  BoundNames</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-boundnames">12.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-boundnames">13.3.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-boundnames">13.3.2.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-boundnames">13.3.3.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-boundnames">13.7.5.2</a>, <a href="#sec-function-definitions-static-semantics-boundnames">14.1.3</a>, <a href="#sec-arrow-function-definitions-static-semantics-boundnames">14.2.2</a>, <a href="#sec-class-definitions-static-semantics-boundnames">14.5.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-imports-static-semantics-boundnames">15.2.2.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-boundnames">15.2.3.2</a>.</p>

      <div class="gp prod"><span class="nt">GeneratorDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return the BoundNames of <i>BindingIdentifier</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">GeneratorDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return &laquo;<code>"*default*"</code>&raquo;.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> <code>"*default*"</code> is used within this specification as a synthetic name for
        hoistable anonymous functions that are defined using export declarations.</p>
      </div>
    </section>

    <section id="sec-generator-function-definitions-static-semantics-computedpropertycontains">
      <h3 id="sec-14.4.3" title="14.4.3"> Static Semantics:  ComputedPropertyContains</h3><p>With parameter <var>symbol</var>.</p>

      <p>See also: <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-computedpropertycontains">12.2.6.2</a>, <a href="#sec-method-definitions-static-semantics-computedpropertycontains">14.3.2</a>, <a href="#sec-class-definitions-static-semantics-computedpropertycontains">14.5.5</a>.</p>

      <div class="gp prod"><span class="nt">GeneratorMethod</span> <span class="geq">:</span> <code class="t">*</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return the result of ComputedPropertyContains for <i>PropertyName</i> with argument <i>symbol</i>.</li>
      </ol>
    </section>

    <section id="sec-generator-function-definitions-static-semantics-contains">
      <h3 id="sec-14.4.4" title="14.4.4"> Static Semantics:  Contains</h3><p>With parameter <var>symbol</var>.</p>

      <p>See also: <a href="sec-notational-conventions#sec-static-semantic-rules">5.3</a>, <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-contains">12.2.6.3</a>, <a href="sec-ecmascript-language-expressions#sec-static-semantics-static-semantics-contains">12.3.1.1</a>, <a href="#sec-function-definitions-static-semantics-contains">14.1.4</a>, <a href="#sec-arrow-function-definitions-static-semantics-contains">14.2.3</a>, <a href="#sec-class-definitions-static-semantics-contains">14.5.4</a></p>

      <p><span class="prod"><span class="nt">GeneratorDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span>
      <code class="t">}GeneratorDeclaration</code> <code class="t">:</code> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></span></p>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span><sub class="g-opt">opt</sub> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Static semantic rules that depend upon substructure generally do not look into function
        definitions.</p>
      </div>
    </section>

    <section id="sec-generator-function-definitions-static-semantics-hascomputedpropertykey">
      <h3 id="sec-14.4.5" title="14.4.5"> Static Semantics:  HasComputedPropertyKey</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-hascomputedpropertykey">12.2.6.4</a>, <a href="#sec-method-definitions-static-semantics-hascomputedpropertykey">14.3.4</a>.</p>

      <div class="gp prod"><span class="nt">GeneratorMethod</span> <span class="geq">:</span> <code class="t">*</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return IsComputedPropertyKey of <i>PropertyName</i>.</li>
      </ol>
    </section>

    <section id="sec-generator-function-definitions-static-semantics-hasdirectsuper">
      <h3 id="sec-14.4.6" title="14.4.6"> Static Semantics:  HasDirectSuper</h3><p>See also: <a href="#sec-method-definitions-static-semantics-hasdirectsuper">14.3.5</a>.</p>

      <div class="gp prod"><span class="nt">GeneratorMethod</span> <span class="geq">:</span> <code class="t">*</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If <i>StrictFormalParameters</i> Contains <i>SuperCall</i> is <b>true</b>, return <b>true.</b></li>
        <li>Return <i>GeneratorBody</i> Contains <i>SuperCall</i>.</li>
      </ol>

      <p><span class="prod"><span class="nt">GeneratorDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span>
      <code class="t">}</code> <span class="nt">GeneratorDeclaration</span> <code class="t">:</code> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></span><br /><span class="prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></span><br /><span class="prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code>
      <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></span></p>

      <ol class="proc">
        <li>If <i>FormalParameters</i> Contains <i>SuperCall</i> is <b>true</b>, return <b>true.</b></li>
        <li>Return <i>GeneratorBody</i> Contains <i>SuperCall</i>.</li>
      </ol>
    </section>

    <section id="sec-generator-function-definitions-static-semantics-hasname">
      <h3 id="sec-14.4.7" title="14.4.7"> Static Semantics:  HasName</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-semantics-static-semantics-hasname">12.2.1.2</a>, <a href="#sec-function-definitions-static-semantics-hasname">14.1.8</a>, <a href="#sec-arrow-function-definitions-static-semantics-hasname">14.2.7</a>, <a href="#sec-class-definitions-static-semantics-hasname">14.5.6</a>.</p>

      <div class="gp prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-generator-function-definitions-static-semantics-isconstantdeclaration">
      <h3 id="sec-14.4.8" title="14.4.8"> Static Semantics:  IsConstantDeclaration</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-isconstantdeclaration">13.3.1.3</a>, <a href="#sec-function-definitions-static-semantics-isconstantdeclaration">14.1.10</a>, <a href="#sec-class-definitions-static-semantics-isconstantdeclaration">14.5.7</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-isconstantdeclaration">15.2.3.7</a>.</p>

      <p><span class="prod"><span class="nt">GeneratorDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span>
      <code class="t">}GeneratorDeclaration</code> <code class="t">:</code> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></span></p>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-generator-function-definitions-static-semantics-isfunctiondefinition">
      <h3 id="sec-14.4.9" title="14.4.9"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="sec-ecmascript-language-expressions#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="sec-ecmascript-language-expressions#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="sec-ecmascript-language-expressions#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="sec-ecmascript-language-expressions#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="sec-ecmascript-language-expressions#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="sec-ecmascript-language-expressions#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="sec-ecmascript-language-expressions#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="sec-ecmascript-language-expressions#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="sec-ecmascript-language-expressions#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="sec-ecmascript-language-expressions#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="sec-ecmascript-language-expressions#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="sec-ecmascript-language-expressions#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="sec-ecmascript-language-expressions#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="sec-ecmascript-language-expressions#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="#sec-class-definitions-static-semantics-isfunctiondefinition">14.5.8</a>.</p>

      <div class="gp prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-generator-function-definitions-static-semantics-propname">
      <h3 id="sec-14.4.10" title="14.4.10"> Static Semantics:  PropName</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-propname">12.2.6.6</a>, <a href="#sec-method-definitions-static-semantics-propname">14.3.6</a>, <a href="#sec-class-definitions-static-semantics-propname">14.5.12</a></p>

      <div class="gp prod"><span class="nt">GeneratorMethod</span> <span class="geq">:</span> <code class="t">*</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return PropName of <i>PropertyName</i>.</li>
      </ol>
    </section>

    <section id="sec-generator-function-definitions-runtime-semantics-evaluatebody">
      <h3 id="sec-14.4.11" title="14.4.11"> Runtime Semantics: EvaluateBody</h3><p>With parameter <var>functionObject</var>.</p>

      <p>See also: <a href="#sec-function-definitions-runtime-semantics-evaluatebody">14.1.17</a>, <a href="#sec-arrow-function-definitions-runtime-semantics-evaluatebody">14.2.15</a>.</p>

      <div class="gp prod"><span class="nt">GeneratorBody</span> <span class="geq">:</span> <span class="nt">FunctionBody</span></div>
      <ol class="proc">
        <li>Let <i>G</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(<i>functionObject</i>,
            <code>"%GeneratorPrototype%"</code>, &laquo;&zwj;[[GeneratorState]], [[GeneratorContext]]&raquo; ).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>G</i>).</li>
        <li>Perform <a href="sec-control-abstraction-objects#sec-generatorstart">GeneratorStart</a>(<i>G</i>, <i>FunctionBody</i>).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:             sans-serif">return</span>, [[value]]: <i>G</i>, [[target]]: <span style="font-family: sans-serif">empty</span>}.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> If the generator was invoked using [[Call]], the <code>this</code> binding will have
        already been initialized in the normal manner. If the generator was invoked using [[Construct]], the <code>this</code>
        bind is not initialized and any references to <code>this</code> within the <span class="nt">FunctionBody</span> will
        produce a <span class="value">ReferenceError</span> exception.</p>
      </div>
    </section>

    <section id="sec-generator-function-definitions-runtime-semantics-instantiatefunctionobject">
      <h3 id="sec-14.4.12" title="14.4.12"> Runtime Semantics: InstantiateFunctionObject</h3><p>With parameter <var>scope</var>.</p>

      <p>See also: <a href="#sec-function-definitions-runtime-semantics-instantiatefunctionobject">14.1.19</a>.</p>

      <div class="gp prod"><span class="nt">GeneratorDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the function code for <i>GeneratorDeclaration</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>name</i> be StringValue of <i>BindingIdentifier.</i></li>
        <li>Let <i>F</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-generatorfunctioncreate">GeneratorFunctionCreate</a>(<span style="font-family:             sans-serif">Normal</span>, <i>FormalParameters</i>, <i>GeneratorBody</i>, <i>scope</i>, <i>strict</i>).</li>
        <li>Let <i>prototype</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<span style="font-family:             sans-serif">%GeneratorPrototype%</span>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>F</i>, <b>true</b>, <i>prototype</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>F</i>, <i>name</i>).</li>
        <li>Return <i>F</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">GeneratorDeclaration</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the function code for <i>GeneratorDeclaration</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>F</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-generatorfunctioncreate">GeneratorFunctionCreate</a>(<span style="font-family:             sans-serif">Normal</span>, <i>FormalParameters</i>, <i>GeneratorBody</i>, <i>scope</i>, <i>strict</i>).</li>
        <li>Let <i>prototype</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<span style="font-family:             sans-serif">%GeneratorPrototype%</span>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>F</i>, <b>true</b>, <i>prototype</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>F</i>, <code>"default"</code>).</li>
        <li>Return <i>F</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> An anonymous <span class="nt">GeneratorDeclaration</span> can only occur as part of an
        <code>export default</code> declaration.</p>
      </div>
    </section>

    <section id="sec-generator-function-definitions-runtime-semantics-propertydefinitionevaluation">
      <h3 id="sec-14.4.13" title="14.4.13"> Runtime Semantics: PropertyDefinitionEvaluation</h3><p>With parameter <var>object</var> and <span style="font-family: Times New Roman"><i>enumerable</i>.</span></p>

      <p>See also: <a href="sec-ecmascript-language-expressions#sec-object-initializer-runtime-semantics-propertydefinitionevaluation">12.2.6.9</a>, <a href="#sec-method-definitions-runtime-semantics-propertydefinitionevaluation">14.3.9</a>, B.3.1</p>

      <div class="gp prod"><span class="nt">GeneratorMethod</span> <span class="geq">:</span> <code class="t">*</code> <span class="nt">PropertyName</span> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Let <i>propKey</i> be the result of evaluating <i>PropertyName</i>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propKey</i>).</li>
        <li>If the function code for this <i>GeneratorMethod</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>scope</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
        <li>Let <i>closure</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-generatorfunctioncreate">GeneratorFunctionCreate</a>(<span style="font-family:             sans-serif">Method</span>, <i>StrictFormalParameters</i>, <i>GeneratorBody, scope</i>, <i>strict</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makemethod">MakeMethod</a>(<i>closure</i>, <i>object</i>).</li>
        <li>Let <i>prototype</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<span style="font-family:             sans-serif">%GeneratorPrototype</span>%).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>closure</i>, <b>true</b>, <i>prototype</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>closure</i>, <i>propKey</i>).</li>
        <li>Let <i>desc</i> be the <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a>{[[Value]]:
            <i>closure</i>, [[Writable]]: <b>true</b>, [[Enumerable]]: <i>enumerable</i>, [[Configurable]]: <b>true</b>}.</li>
        <li>Return <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>object</i>, <i>propKey</i>,
            <i>desc</i>).</li>
      </ol>
    </section>

    <section id="sec-generator-function-definitions-runtime-semantics-evaluation">
      <h3 id="sec-14.4.14" title="14.4.14"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the function code for this <i>GeneratorExpression</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>scope</i> be the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>closure</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-generatorfunctioncreate">GeneratorFunctionCreate</a>(<span style="font-family:             sans-serif">Normal</span>, <i>FormalParameters</i>, <i>GeneratorBody, scope</i>, <i>strict</i>).</li>
        <li>Let <i>prototype</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<span style="font-family:             sans-serif">%GeneratorPrototype%</span>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>closure</i>, <b>true</b>, <i>prototype</i>).</li>
        <li>Return <i>closure</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> <code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the function code for this <i>GeneratorExpression</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let
            <i>strict</i> be <b>true</b>. Otherwise let <i>strict</i> be <b>false</b>.</li>
        <li>Let <i>runningContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a>.</li>
        <li>Let <i>funcEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>runningContext</i>).</li>
        <li>Let <i>envRec</i> be <i>funcEnv&rsquo;s</i> <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
        <li>Let <i>name</i> be StringValue of <i>BindingIdentifier</i>.</li>
        <li>Perform <i>envRec.</i>CreateImmutableBinding(<i>name</i>).</li>
        <li>Let <i>closure</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-generatorfunctioncreate">GeneratorFunctionCreate</a>(<span style="font-family:             sans-serif">Normal</span>, <i>FormalParameters</i>, <i>GeneratorBody, funcEnv</i>, <i>strict</i>).</li>
        <li>Let <i>prototype</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<span style="font-family:             sans-serif">%GeneratorPrototype%</span>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a> (<i>closure</i>, <b>true</b>, <i>prototype</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>closure</i>, <i>name</i>).</li>
        <li>Perform <i>envRec.</i>InitializeBinding(<i>name,</i> <i>closure</i>).</li>
        <li>Return <i>closure</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> The <span class="nt">BindingIdentifier</span> in a <span class="nt">GeneratorExpression</span> can be referenced from inside the <var>GeneratorExpression's</var> <span class="nt">FunctionBody</span> to allow the generator code to call itself recursively. However, unlike in a <span class="nt">GeneratorDeclaration</span>, the <span class="nt">BindingIdentifier</span> in a <span class="nt">GeneratorExpression</span> cannot be referenced from and does not affect the scope enclosing the <span class="nt">GeneratorExpression</span>.</p>
      </div>

      <div class="gp prod"><span class="nt">YieldExpression</span> <span class="geq">:</span> <code class="t">yield</code></div>
      <ol class="proc">
        <li>Return <a href="sec-control-abstraction-objects#sec-generatoryield">GeneratorYield</a>(<a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>false</b>)).</li>
      </ol>
      <div class="gp prod"><span class="nt">YieldExpression</span> <span class="geq">:</span> <code class="t">yield</code> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Let <i>exprRef</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
        <li>Let <i>value</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
        <li>Return <a href="sec-control-abstraction-objects#sec-generatoryield">GeneratorYield</a>(<a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<i>value</i>, <b>false</b>)).</li>
      </ol>
      <div class="gp prod"><span class="nt">YieldExpression</span> <span class="geq">:</span> <code class="t">yield</code> <code class="t">*</code> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Let <i>exprRef</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
        <li>Let <i>value</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
        <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>value</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>)<i>.</i></li>
        <li>Let <i>received</i> be <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
        <li>Repeat
          <ol class="block">
            <li>If <i>received</i>.[[type]] is <span style="font-family: sans-serif">normal</span>, then
              <ol class="block">
                <li>Let <i>innerResult</i> be <a href="sec-abstract-operations#sec-iteratornext">IteratorNext</a>(<i>iterator</i>,
                    <i>received</i>.[[value]]).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>innerResult</i>).</li>
                <li>Let <i>done</i> be <a href="sec-abstract-operations#sec-iteratorcomplete">IteratorComplete</a>(<i>innerResult</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>done</i>).</li>
                <li>If <i>done</i> is <b>true</b>, then
                  <ol class="block">
                    <li>Return <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a> (<i>innerResult</i>).</li>
                  </ol>
                </li>
                <li>Let <i>received</i>  be <a href="sec-control-abstraction-objects#sec-generatoryield">GeneratorYield</a>(<i>innerResult</i>).</li>
              </ol>
            </li>
            <li>Else if <i>received</i>.[[type]] is <span style="font-family: sans-serif">throw</span>, then
              <ol class="block">
                <li>Let <i>throw</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>iterator</i>, <code>"throw"</code>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>throw</i>)<span style="font-family:                     sans-serif">.</span></li>
                <li>If <i>throw</i> is not <b>undefined</b>, then
                  <ol class="block">
                    <li>Let <i>innerResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>throw</i>, <i>iterator</i>,
                        &laquo;&zwj;<i>received</i>.[[value]]&raquo;).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>innerResult</i>)<span style="font-family:                         sans-serif">.</span></li>
                    <li>NOTE:  Exceptions from the inner iterator <code>throw</code> method are propagated. Normal completions
                        from an inner <code>throw</code> method are processed similarly to an inner <code>next</code>.</li>
                    <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>innerResult</i>) is not Object, throw a
                        <b>TypeError</b> exception.</li>
                    <li>Let <i>done</i> be <a href="sec-abstract-operations#sec-iteratorcomplete">IteratorComplete</a>(<i>innerResult</i>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>done</i>).</li>
                    <li>If <i>done</i> is <b>true</b>, then
                      <ol class="block">
                        <li>Let <i>value</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>innerResult</i>).</li>
                        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
                        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family: sans-serif">return</span> , [[value]]:<i>value</i>, [[target]]:<span style="font-family: sans-serif">empty</span>}.</li>
                      </ol>
                    </li>
                    <li>Let <i>received</i>  be <a href="sec-control-abstraction-objects#sec-generatoryield">GeneratorYield</a>(<i>innerResult</i>).</li>
                  </ol>
                </li>
                <li>Else,
                  <ol class="block">
                    <li>NOTE:  If <var>iterator</var> does not have a <code>throw</code> method, this throw is going to terminate
                        the <code>yield*</code> loop. But first we need to give <var>iterator</var> a chance to clean up.</li>
                    <li>Let <i>closeResult</i> be <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:                         sans-serif">normal</span> , [[value]]: <span style="font-family: sans-serif">empty</span>,
                        [[target]]:<span style="font-family: sans-serif">empty</span>}).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>closeResult</i>).</li>
                    <li>NOTE: The next step throws a <span class="value">TypeError</span> to indicate that there was a
                        <code>yield*</code> protocol violation: <var>iterator</var> does not have a <code>throw</code>
                        method.</li>
                    <li>Throw a <b>TypeError</b> exception.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>received</i>.[[type]] is <span style="font-family:                     sans-serif">return</span>.</li>
                <li>Let <i>return</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>iterator</i>, <code>"return"</code>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>return</i>)<span style="font-family:                     sans-serif">.</span></li>
                <li>If <i>return</i> is <b>undefined</b>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>received</i>).</li>
                <li>Let <i>innerReturnResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>return</i>, <i>iterator</i>,
                    &laquo;&zwj;<i>received</i>.[[value]]&raquo;).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>innerReturnResult</i>)<span style="font-family:                     sans-serif">.</span></li>
                <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>innerReturnResult</i>) is not Object, throw a
                    <b>TypeError</b> exception.</li>
                <li>Let <i>done</i> be <a href="sec-abstract-operations#sec-iteratorcomplete">IteratorComplete</a>(<i>innerReturnResult</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>done</i>).</li>
                <li>If <i>done</i> is <b>true</b>, then
                  <ol class="block">
                    <li>Let <i>value</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>innerReturnResult</i>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
                    <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family: sans-serif">return</span> , [[value]]: <i>value</i>, [[target]]:<span style="font-family: sans-serif">empty</span>}.</li>
                  </ol>
                </li>
                <li>Let <i>received</i>  be <a href="sec-control-abstraction-objects#sec-generatoryield">GeneratorYield</a>(<i>innerReturnResult</i>).</li>
              </ol>
            </li>
          </ol>
        </li>
      </ol>
    </section>
  </section>

  <section id="sec-class-definitions">
    <div class="front">
      <h2 id="sec-14.5" title="14.5"> Class
          Definitions</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassDeclaration</span><sub class="g-params">[Yield, Default]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">class</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <span class="nt">ClassTail</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="grhsannot">[+Default]</span> <code class="t">class</code> <span class="nt">ClassTail</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">class</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <span class="nt">ClassTail</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassTail</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ClassHeritage</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">{</code> <span class="nt">ClassBody</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassHeritage</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">extends</code> <span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassBody</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ClassElementList</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassElementList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ClassElement</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">ClassElementList</span><sub class="g-params">[?Yield]</sub> <span class="nt">ClassElement</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">MethodDefinition</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">static</code> <span class="nt">MethodDefinition</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">;</code></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE</span> A <span class="nt">ClassBody</span> is always <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
        code</a>.</p>
      </div>
    </div>

    <section id="sec-class-definitions-static-semantics-early-errors">
      <h3 id="sec-14.5.1" title="14.5.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">ClassTail</span> <span class="geq">:</span> <span class="nt">ClassHeritage</span><sub class="g-opt">opt</sub> <code class="t">{</code> <span class="nt">ClassBody</span> <code class="t">}</code></div>
      <ul>
        <li>
          <p>It is a Syntax Error if <span class="nt">ClassHeritage</span> is not present <span style="font-family: Times New           Roman"><i>and the following algorithm evaluates to <b>true</b>:</i></span></p>

          <ol class="proc">
            <li>Let <i>constructor</i> be ConstructorMethod of <i>ClassBody</i>.</li>
            <li>If <i>constructor</i> is <span style="font-family: sans-serif">empty</span>, return <b>false</b>.</li>
            <li>Return HasDirectSuper of <i>constructor</i>.</li>
          </ol>
        </li>
      </ul>
      <div class="gp prod"><span class="nt">ClassBody</span> <span class="geq">:</span> <span class="nt">ClassElementList</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if <span style="font-family: Times New Roman">PrototypePropertyNameList</span> of <span class="nt">ClassElementList</span> <var>contains more than one occurrence of</var> <code>"constructor"</code>.</p>
        </li>
      </ul>
      <div class="gp prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <span class="nt">MethodDefinition</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if <span style="font-family: Times New Roman">PropName</span> of <span class="nt">MethodDefinition</span> is not <code>"constructor"</code> <var>and</var> HasDirectSuper of <span class="nt">MethodDefinition</span> is <span style="font-family: Times New Roman"><b><i>true</i></b></span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span style="font-family: Times New Roman">PropName</span> of <span class="nt">MethodDefinition</span> is <code>"constructor"</code> <var>and SpecialMethod of</var> <span class="nt">MethodDefinition</span> <var>is</var> <span style="font-family: Times New           Roman"><i><b>true</b>.</i></span></p>
        </li>
      </ul>
      <div class="gp prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <code class="t">static</code> <span class="nt">MethodDefinition</span></div>
      <ul>
        <li>It is a Syntax Error if HasDirectSuper of <span class="nt">MethodDefinition</span> is <span style="font-family: Times             New Roman"><b><i>true</i></b></span>.</li>
        <li>It is a Syntax Error if <span style="font-family: Times New Roman">PropName</span> of <span class="nt">MethodDefinition</span> <var>is</var> <code>"prototype"</code><var>.</var></li>
      </ul>
    </section>

    <section id="sec-class-definitions-static-semantics-boundnames">
      <h3 id="sec-14.5.2" title="14.5.2"> Static Semantics:  BoundNames</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-boundnames">12.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-boundnames">13.3.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-boundnames">13.3.2.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-boundnames">13.3.3.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-boundnames">13.7.5.2</a>, <a href="#sec-function-definitions-static-semantics-boundnames">14.1.3</a>, <a href="#sec-arrow-function-definitions-static-semantics-boundnames">14.2.2</a>, <a href="#sec-generator-function-definitions-static-semantics-boundnames">14.4.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-imports-static-semantics-boundnames">15.2.2.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-boundnames">15.2.3.2</a>.</p>

      <div class="gp prod"><span class="nt">ClassDeclaration</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">BindingIdentifier</span> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>Return the BoundNames of <i>BindingIdentifier</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassDeclaration</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>Return &laquo;<code>"*default*"</code>&raquo;.</li>
      </ol>
    </section>

    <section id="sec-static-semantics-constructormethod">
      <h3 id="sec-14.5.3" title="14.5.3"> Static Semantics:  ConstructorMethod</h3><div class="gp prod"><span class="nt">ClassElementList</span> <span class="geq">:</span> <span class="nt">ClassElement</span></div>
      <ol class="proc">
        <li>If <i>ClassElement</i> is the production <span class="prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <code class="t">;</code></span> , return <span style="font-family: sans-serif">empty</span>.</li>
        <li>If IsStatic of <i>ClassElement</i> is <b>true</b>, return <span style="font-family: sans-serif">empty</span>.</li>
        <li>If PropName of <i>ClassElement</i> is not <code>"constructor"</code>, return <span style="font-family:             sans-serif">empty</span>.</li>
        <li>Return <i>ClassElement</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassElementList</span> <span class="geq">:</span> <span class="nt">ClassElementList</span> <span class="nt">ClassElement</span></div>
      <ol class="proc">
        <li>Let <i>head</i> be ConstructorMethod of <i>ClassElementList.</i></li>
        <li>If <i>head</i> is not <span style="font-family: sans-serif">empty</span>, return <i>head</i>.</li>
        <li>If <i>ClassElement</i> is the production <span class="prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <code class="t">;</code></span> , return <span style="font-family: sans-serif">empty</span>.</li>
        <li>If IsStatic of <i>ClassElement</i> is <b>true</b>, return <span style="font-family: sans-serif">empty</span>.</li>
        <li>If PropName of <i>ClassElement</i> is not <code>"constructor"</code>, return <span style="font-family:             sans-serif">empty</span>.</li>
        <li>Return <i>ClassElement</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Early Error rules ensure that there is only one method definition named
        <code>"constructor"</code> and that it is not an accessor property or generator definition.</p>
      </div>
    </section>

    <section id="sec-class-definitions-static-semantics-contains">
      <h3 id="sec-14.5.4" title="14.5.4"> Static Semantics:  Contains</h3><p>With parameter <var>symbol</var>.</p>

      <p>See also: <a href="sec-notational-conventions#sec-static-semantic-rules">5.3</a>, <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-contains">12.2.6.3</a>, <a href="sec-ecmascript-language-expressions#sec-static-semantics-static-semantics-contains">12.3.1.1</a>, <a href="#sec-function-definitions-static-semantics-contains">14.1.4</a>, <a href="#sec-arrow-function-definitions-static-semantics-contains">14.2.3</a>, <a href="#sec-generator-function-definitions-static-semantics-contains">14.4.4</a></p>

      <div class="gp prod"><span class="nt">ClassTail</span> <span class="geq">:</span> <span class="nt">ClassHeritage</span><sub class="g-opt">opt</sub> <code class="t">{</code> <span class="nt">ClassBody</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>If <i>symbol</i> is <i>ClassBody</i>, return <b>true</b>.</li>
        <li>If <i>symbol</i> is <i>ClassHeritage</i>, then
          <ol class="block">
            <li>If <i>ClassHeritage</i> is present, return <b>true</b> otherwise return <b>false</b>.</li>
          </ol>
        </li>
        <li>Let <i>inHeritage</i> be <i>ClassHeritage</i> Contains <i>symbol</i>.</li>
        <li>If <i>inHeritage</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return the result of ComputedPropertyContains for <i>ClassBody</i> with argument <i>symbol</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Static semantic rules that depend upon substructure generally do not look into class
        bodies except for <span class="nt">PropertyName</span> productions.</p>
      </div>
    </section>

    <section id="sec-class-definitions-static-semantics-computedpropertycontains">
      <h3 id="sec-14.5.5" title="14.5.5"> Static Semantics:  ComputedPropertyContains</h3><p>With parameter <var>symbol</var>.</p>

      <p>See also: <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-computedpropertycontains">12.2.6.2</a>, <a href="#sec-method-definitions-static-semantics-computedpropertycontains">14.3.2</a>, <a href="#sec-generator-function-definitions-static-semantics-computedpropertycontains">14.4.3</a>.</p>

      <div class="gp prod"><span class="nt">ClassElementList</span> <span class="geq">:</span> <span class="nt">ClassElementList</span> <span class="nt">ClassElement</span></div>
      <ol class="proc">
        <li>Let <i>inList</i> be the result of ComputedPropertyContains for <i>ClassElementList</i> with argument
            <i>symbol.</i></li>
        <li>If <i>inList</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return the result of ComputedPropertyContains for <i>ClassElement</i> with argument <i>symbol</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <span class="nt">MethodDefinition</span></div>
      <ol class="proc">
        <li>Return the result of ComputedPropertyContains for <i>MethodDefinition</i> with argument <i>symbol</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <code class="t">static</code> <span class="nt">MethodDefinition</span></div>
      <ol class="proc">
        <li>Return the result of ComputedPropertyContains for <i>MethodDefinition</i> with argument <i>symbol</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-class-definitions-static-semantics-hasname">
      <h3 id="sec-14.5.6" title="14.5.6"> Static Semantics:  HasName</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-semantics-static-semantics-hasname">12.2.1.2</a>, <a href="#sec-function-definitions-static-semantics-hasname">14.1.8</a>, <a href="#sec-arrow-function-definitions-static-semantics-hasname">14.2.7</a>, <a href="#sec-generator-function-definitions-static-semantics-hasname">14.4.7</a>.</p>

      <div class="gp prod"><span class="nt">ClassExpression</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassExpression</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">BindingIdentifier</span> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-class-definitions-static-semantics-isconstantdeclaration">
      <h3 id="sec-14.5.7" title="14.5.7"> Static Semantics:  IsConstantDeclaration</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-isconstantdeclaration">13.3.1.3</a>, <a href="#sec-function-definitions-static-semantics-isconstantdeclaration">14.1.10</a>, <a href="#sec-generator-function-definitions-static-semantics-isconstantdeclaration">14.4.8</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-isconstantdeclaration">15.2.3.7</a>.</p>

      <p><span class="prod"><span class="nt">ClassDeclaration</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">BindingIdentifier</span> <span class="nt">ClassTail</span></span></p>

      <div class="gp prod"><span class="nt">ClassDeclaration</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-class-definitions-static-semantics-isfunctiondefinition">
      <h3 id="sec-14.5.8" title="14.5.8"> Static Semantics:  IsFunctionDefinition</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-semantics-static-semantics-isfunctiondefinition">12.2.1.3</a>, <a href="sec-ecmascript-language-expressions#sec-grouping-operator-static-semantics-isfunctiondefinition">12.2.10.2</a>, <a href="sec-ecmascript-language-expressions#sec-static-semantics-static-semantics-isfunctiondefinition">12.3.1.2</a>, <a href="sec-ecmascript-language-expressions#sec-postfix-expressions-static-semantics-isfunctiondefinition">12.4.2</a>, <a href="sec-ecmascript-language-expressions#sec-unary-operators-static-semantics-isfunctiondefinition">12.5.2</a>, <a href="sec-ecmascript-language-expressions#sec-multiplicative-operators-static-semantics-isfunctiondefinition">12.6.1</a>, <a href="sec-ecmascript-language-expressions#sec-additive-operators-static-semantics-isfunctiondefinition">12.7.1</a>, <a href="sec-ecmascript-language-expressions#sec-bitwise-shift-operators-static-semantics-isfunctiondefinition">12.8.1</a>, <a href="sec-ecmascript-language-expressions#sec-relational-operators-static-semantics-isfunctiondefinition">12.9.1</a>, <a href="sec-ecmascript-language-expressions#sec-equality-operators-static-semantics-isfunctiondefinition">12.10.1</a>, <a href="sec-ecmascript-language-expressions#sec-binary-bitwise-operators-static-semantics-isfunctiondefinition">12.11.1</a>, <a href="sec-ecmascript-language-expressions#sec-binary-logical-operators-static-semantics-isfunctiondefinition">12.12.1</a>, <a href="sec-ecmascript-language-expressions#sec-conditional-operator-static-semantics-isfunctiondefinition">12.13.1</a>, <a href="sec-ecmascript-language-expressions#sec-assignment-operators-static-semantics-isfunctiondefinition">12.14.2</a>, <a href="sec-ecmascript-language-expressions#sec-comma-operator-static-semantics-isfunctiondefinition">12.15.1</a>, <a href="#sec-function-definitions-static-semantics-isfunctiondefinition">14.1.11</a>, <a href="#sec-generator-function-definitions-static-semantics-isfunctiondefinition">14.4.9</a>.</p>

      <div class="gp prod"><span class="nt">ClassExpression</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassExpression</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">BindingIdentifier</span> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-static-semantics-isstatic">
      <h3 id="sec-14.5.9" title="14.5.9"> Static Semantics:  IsStatic</h3><div class="gp prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <span class="nt">MethodDefinition</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <code class="t">static</code> <span class="nt">MethodDefinition</span></div>
      <ol class="proc">
        <li>Return <b>true</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-static-semantics-nonconstructormethoddefinitions">
      <h3 id="sec-14.5.10" title="14.5.10"> Static Semantics:  NonConstructorMethodDefinitions</h3><div class="gp prod"><span class="nt">ClassElementList</span> <span class="geq">:</span> <span class="nt">ClassElement</span></div>
      <ol class="proc">
        <li>If <i>ClassElement</i> is the production <span class="prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <code class="t">;</code></span> , return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>If IsStatic of <i>ClassElement</i> is <b>false</b> and PropName of <i>ClassElement</i> is <code>"constructor"</code>,
            return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>ClassElement</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassElementList</span> <span class="geq">:</span> <span class="nt">ClassElementList</span> <span class="nt">ClassElement</span></div>
      <ol class="proc">
        <li>Let <i>list</i> be NonConstructorMethodDefinitions of <i>ClassElementList.</i></li>
        <li>If <i>ClassElement</i> is the production <span class="prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <code class="t">;</code></span> , return <i>list</i>.</li>
        <li>If IsStatic of <i>ClassElement</i> is <b>false</b> and PropName of <i>ClassElement</i> is <code>"constructor"</code>,
            return <i>list</i>.</li>
        <li>Append  <i>ClassElement</i> to the end of <i>list</i>.</li>
        <li>Return <i>list</i>.</li>
      </ol>
    </section>

    <section id="sec-static-semantics-prototypepropertynamelist">
      <h3 id="sec-14.5.11" title="14.5.11"> Static Semantics:  PrototypePropertyNameList</h3><div class="gp prod"><span class="nt">ClassElementList</span> <span class="geq">:</span> <span class="nt">ClassElement</span></div>
      <ol class="proc">
        <li>If PropName of <i>ClassElement</i> is <span style="font-family: sans-serif">empty</span>, return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>If IsStatic of <i>ClassElement</i> is <b>true</b>, return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing PropName of <i>ClassElement</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassElementList</span> <span class="geq">:</span> <span class="nt">ClassElementList</span> <span class="nt">ClassElement</span></div>
      <ol class="proc">
        <li>Let <i>list</i> be PrototypePropertyNameList of <i>ClassElementList.</i></li>
        <li>If PropName of <i>ClassElement</i> is <span style="font-family: sans-serif">empty</span>, return <i>list</i>.</li>
        <li>If IsStatic of <i>ClassElement</i> is <b>true</b>, return <i>list</i>.</li>
        <li>Append  PropName of <i>ClassElement</i> to the end of <i>list</i>.</li>
        <li>Return <i>list</i>.</li>
      </ol>
    </section>

    <section id="sec-class-definitions-static-semantics-propname">
      <h3 id="sec-14.5.12" title="14.5.12"> Static Semantics:  PropName</h3><p>See also: <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-propname">12.2.6.6</a>, <a href="#sec-method-definitions-static-semantics-propname">14.3.6</a>, <a href="#sec-generator-function-definitions-static-semantics-propname">14.4.10</a></p>

      <div class="gp prod"><span class="nt">ClassElement</span> <span class="geq">:</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>Return <span style="font-family: sans-serif">empty</span>.</li>
      </ol>
    </section>

    <section id="sec-static-semantics-staticpropertynamelist">
      <h3 id="sec-14.5.13" title="14.5.13"> Static Semantics:  StaticPropertyNameList</h3><div class="gp prod"><span class="nt">ClassElementList</span> <span class="geq">:</span> <span class="nt">ClassElement</span></div>
      <ol class="proc">
        <li>If PropName of <i>ClassElement</i> is <span style="font-family: sans-serif">empty</span>, return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>If IsStatic of <i>ClassElement</i> is <b>false</b>, return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing PropName of <i>ClassElement</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassElementList</span> <span class="geq">:</span> <span class="nt">ClassElementList</span> <span class="nt">ClassElement</span></div>
      <ol class="proc">
        <li>Let <i>list</i> be StaticPropertyNameList of <i>ClassElementList.</i></li>
        <li>If PropName of <i>ClassElement</i> is <span style="font-family: sans-serif">empty</span>, return <i>list</i>.</li>
        <li>If IsStatic of <i>ClassElement</i> is <b>false</b>, return <i>list</i>.</li>
        <li>Append  PropName of <i>ClassElement</i> to the end of <i>list</i>.</li>
        <li>Return <i>list</i>.</li>
      </ol>
    </section>

    <section id="sec-runtime-semantics-classdefinitionevaluation">
      <h3 id="sec-14.5.14" title="14.5.14"> Runtime Semantics: ClassDefinitionEvaluation</h3><p>With parameter <var>className</var>.</p>

      <div class="gp prod"><span class="nt">ClassTail</span> <span class="geq">:</span> <span class="nt">ClassHeritage</span><sub class="g-opt">opt</sub> <code class="t">{</code> <span class="nt">ClassBody</span><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      <ol class="proc">
        <li>Let <i>lex</i> be the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>classScope</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>lex</i>).</li>
        <li>Let <i>classScopeEnvRec</i> be <i>classScope</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
        <li>If <i>className</i> is not <b>undefined</b>, then
          <ol class="block">
            <li>Perform <i>classScopeEnvRec.</i>CreateImmutableBinding(<i>className</i>, <b>true</b>).</li>
          </ol>
        </li>
        <li>If <i>ClassHeritage</i><sub>opt</sub> is not present, then
          <ol class="block">
            <li>Let <i>protoParent</i> be the intrinsic object %ObjectPrototype%.</li>
            <li>Let <i>constructorParent</i> be the intrinsic object %FunctionPrototype%.</li>
          </ol>
        </li>
        <li>Else
          <ol class="block">
            <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>classScope</i>.</li>
            <li>Let <i>superclass</i> be the result of evaluating <i>ClassHeritage</i>.</li>
            <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>lex</i>.</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>superclass</i>).</li>
            <li>If <i>superclass</i> is <b>null</b>, then
              <ol class="block">
                <li>Let <i>protoParent</i> be <b>null</b>.</li>
                <li>Let <i>constructorParent</i> be the intrinsic object %FunctionPrototype%.</li>
              </ol>
            </li>
            <li>Else if <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>superclass</i>) is <b>false</b>, throw a
                <b>TypeError</b> exception.</li>
            <li>Else
              <ol class="block">
                <li>If <i>superclass</i> has a [[FunctionKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                    slot</a> whose value is <code>"generator"</code>, throw a <b>TypeError</b> exception.</li>
                <li>Let <i>protoParent</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>superclass</i>, <code>"prototype"</code>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>protoParent</i>).</li>
                <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>protoParent</i>) is neither Object nor Null,
                    throw a <b>TypeError</b> exception.</li>
                <li>Let <i>constructorParent</i> be <i>superclass</i>.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Let <i>proto</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<i>protoParent</i>).</li>
        <li>If <i>ClassBody</i><sub>opt</sub> is not present, let <i>constructor</i> be <span style="font-family:             sans-serif">empty</span>.</li>
        <li>Else, let <i>constructor</i> be ConstructorMethod of <i>ClassBody</i>.</li>
        <li>If <i>constructor</i> is <span style="font-family: sans-serif">empty</span>, then,
          <ol class="block">
            <li>If <i>ClassHeritage</i><sub>opt</sub> is present, then
              <ol class="block">
                <li>Let <i>constructor</i> be the result of parsing the source
                    text<br />&nbsp;&nbsp;&nbsp;&nbsp;<code>constructor(... args){ super</code> <code>(...args);}<br /></code>using
                    the syntactic grammar with the goal symbol <i>MethodDefinition.</i></li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Let <i>constructor</i> be the result of parsing the source text<br />&nbsp;&nbsp;&nbsp;&nbsp;<code>constructor(
                    ){ }<br /></code>using the syntactic grammar with the goal symbol <i>MethodDefinition.</i></li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>classScope</i>.</li>
        <li>Let <i>constructorInfo</i> be the result of performing DefineMethod for <i>constructor</i> with arguments <i>proto</i>
            and <i>constructorParent</i> as the optional <i>functionPrototype</i> argument.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>constructorInfo</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
        <li>Let <i>F</i> be <i>constructorInfo</i>.[[closure]]</li>
        <li>If <i>ClassHeritage</i><sub>opt</sub> is present, set <i>F</i>&rsquo;s [[ConstructorKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <code>"derived"</code>.</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>F</i>, <b>false</b>, <i>proto</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeclassconstructor">MakeClassConstructor</a>(<i>F</i>).</li>
        <li>Perform <a href="sec-abstract-operations#sec-createmethodproperty">CreateMethodProperty</a>(<i>proto</i>, <code>"constructor"</code>,
            <i>F</i>)<i>.</i></li>
        <li>If <i>ClassBody</i><sub>opt</sub> is not present, let <i>methods</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Else, let <i>methods</i> be NonConstructorMethodDefinitions of <i>ClassBody</i>.</li>
        <li>For each <i>ClassElement</i> <i>m</i> in order from <i>methods</i>
          <ol class="block">
            <li>If IsStatic of <i>m</i> is <b>false</b>, then
              <ol class="block">
                <li>Let <i>status</i> be the result of performing PropertyDefinitionEvaluation for <i>m</i> with arguments
                    <i>proto</i> and <b>false</b>.</li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Let <i>status</i> be the result of performing PropertyDefinitionEvaluation for <i>m</i> with arguments
                    <i>F</i> and <b>false</b>.</li>
              </ol>
            </li>
            <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
              <ol class="block">
                <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>lex</i>.</li>
                <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>).</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>lex</i>.</li>
        <li>If <i>className</i> is not <b>undefined</b>, then
          <ol class="block">
            <li>Perform <i>classScopeEnvRec.</i>InitializeBinding(<i>className</i>, <i>F</i>).</li>
          </ol>
        </li>
        <li>Return <i>F</i>.</li>
      </ol>
    </section>

    <section id="sec-runtime-semantics-bindingclassdeclarationevaluation">
      <h3 id="sec-14.5.15" title="14.5.15"> Runtime Semantics: BindingClassDeclarationEvaluation</h3><div class="gp prod"><span class="nt">ClassDeclaration</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">BindingIdentifier</span> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>Let <i>className</i> be StringValue of <i>BindingIdentifier</i>.</li>
        <li>Let <i>value</i> be the result of ClassDefinitionEvaluation of <i>ClassTail</i> with argument <i>className.</i></li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
        <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>value</i>,
            <code>"name"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
        <li>If <i>hasNameProperty</i> is <b>false</b>, then perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>value</i>, <i>className</i>).</li>
        <li>Let <i>env</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
        <li>Let <i>status</i> be <a href="sec-ecmascript-language-expressions#sec-initializeboundname">InitializeBoundName</a>(<i>className</i>, <i>value</i>,
            <i>env</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
        <li>Return <i>value</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ClassDeclaration</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>Return the result of ClassDefinitionEvaluation of <i>ClassTail</i> with argument <b>undefined</b><i>.</i></li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> <span class="prod"><span class="nt">ClassDeclaration</span> <span class="geq">:</span>
        <code class="t">class</code> <span class="nt">ClassTail</span></span> <var>only occurs as part of an</var> <span class="nt">ExportDeclaration</span> and the setting of a  name property and establishing its binding are handled as part
        of the evaluation action for that production. See <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-runtime-semantics-evaluation">15.2.3.11</a>.</p>
      </div>
    </section>

    <section id="sec-class-definitions-runtime-semantics-evaluation">
      <h3 id="sec-14.5.16" title="14.5.16"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">ClassDeclaration</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">BindingIdentifier</span> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>Let <i>status</i> be the result of BindingClassDeclarationEvaluation of this <i>ClassDeclaration.</i></li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
      </ol>

      <p class="Note"><var>NOTE 1</var>&#x9;<span class="prod"><span class="nt">ClassDeclaration</span> <span class="geq">:</span>
      <code class="t">class</code> <span class="nt">ClassTail</span></span> <var>only occurs as part of an</var> <span class="nt">ExportDeclaration</span> and is never directly evaluated.</p>

      <div class="gp prod"><span class="nt">ClassExpression</span> <span class="geq">:</span> <code class="t">class</code> <span class="nt">BindingIdentifier</span><sub class="g-opt">opt</sub> <span class="nt">ClassTail</span></div>
      <ol class="proc">
        <li>If <i>BindingIdentifier</i><sub>opt</sub> is not  present, let <i>className</i> be <b>undefined</b>.</li>
        <li>Else, let <i>className</i> be StringValue of <i>BindingIdentifier</i>.</li>
        <li>Let <i>value</i> be the result of ClassDefinitionEvaluation of <i>ClassTail</i> with argument <i>className</i>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
        <li>If <i>className</i> is not <b>undefined</b>, then
          <ol class="block">
            <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>value</i>,
                <code>"name"</code>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
            <li>If <i>hasNameProperty</i> is <b>false</b>, then
              <ol class="block">
                <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>value</i>, <i>className</i>).</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>value</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 2</span> If the class definition included a <code>name</code> static method then that method is
        not over-written with a <code>name</code> data property for the class name.</p>
      </div>
    </section>
  </section>

  <section id="sec-tail-position-calls">
    <div class="front">
      <h2 id="sec-14.6" title="14.6"> Tail
          Position Calls</h2></div>

    <section id="sec-isintailposition">
      <h3 id="sec-14.6.1" title="14.6.1">
          Static Semantics: IsInTailPosition(nonterminal)</h3><p class="normalbefore">The abstract operation IsInTailPosition with argument <var>nonterminal</var> performs the following
      steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>nonterminal</i> is a parsed grammar production.</li>
        <li>If the source code matching <i>nonterminal</i> is not <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict code</a>, return
            <b>false.</b></li>
        <li>If <i>nonterminal</i> is not contained within a <i>FunctionBody</i> or <i>ConciseBody</i>, return <b>false</b>.</li>
        <li>Let <i>body</i> be the <i>FunctionBody</i> or <i>ConciseBody</i> that most closely contains <i>nonterminal</i>.</li>
        <li>If <i>body</i> is the <i>FunctionBody</i> of a <i>GeneratorBody</i>, return <b>false</b>.</li>
        <li>Return the result of HasProductionInTailPosition of <i>body</i> with argument <i>nonterminal</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Tail Position calls are only defined in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode
        code</a> because of a common non-standard language extension (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-addrestrictedfunctionproperties">see
        9.2.7</a>) that enables  observation of the chain of caller contexts.</p>
      </div>
    </section>

    <section id="sec-static-semantics-hasproductionintailposition">
      <div class="front">
        <h3 id="sec-14.6.2" title="14.6.2"> Static Semantics: HasProductionInTailPosition</h3><p>With parameter <var>nonterminal</var>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> <var>nonterminal</var> is a parsed grammar production that represent a specific range of
          source text. When the following algorithms compare <var>nonterminal</var> to other grammar symbols they are testing
          whether the same source text was matched by both symbols.</p>
        </div>
      </div>

      <section id="sec-statement-rules">
        <h4 id="sec-14.6.2.1" title="14.6.2.1">
            Statement Rules</h4><div class="gp prod"><span class="nt">ConciseBody</span> <span class="geq">:</span> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>AssignmentExpression</i> with argument <i>nonterminal</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
        <ol class="proc">
          <li>Let <i>has</i> be HasProductionInTailPosition of <i>StatementList</i> with argument <i>nonterminal</i>.</li>
          <li>If <i>has</i> is <b>true</b>, return <b>true</b>.</li>
          <li>Return HasProductionInTailPosition of <i>StatementListItem</i> with argument <i>nonterminal</i>.</li>
        </ol>

        <p><span class="prod"><span class="nt">FunctionStatementList</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></span></p>

        <p><span class="prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></span></p>

        <div class="gp">
          <div class="lhs"><span class="nt">Statement</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">VariableStatement</span></div>
          <div class="rhs"><span class="nt">EmptyStatement</span></div>
          <div class="rhs"><span class="nt">ExpressionStatement</span></div>
          <div class="rhs"><span class="nt">ContinueStatement</span></div>
          <div class="rhs"><span class="nt">BreakStatement</span></div>
          <div class="rhs"><span class="nt">ThrowStatement</span></div>
          <div class="rhs"><span class="nt">DebuggerStatement</span></div>
          <div class="rhs"><span class="nt">Block</span> <code class="t">:</code> <code class="t">{</code> <code class="t">}</code></div>
          <div class="rhs"><span class="nt">ReturnStatement</span> <code class="t">:</code> <code class="t">return</code> <code class="t">;</code></div>
          <div class="rhs"><span class="nt">LabelledItem</span> <code class="t">:</code> <span class="nt">FunctionDeclaration</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><span class="nt">CaseBlock</span> <code class="t">:</code> <code class="t">{</code> <code class="t">}</code></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span> <code class="t">else</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>has</i> be HasProductionInTailPosition of the first <i>Statement</i> with argument <i>nonterminal</i>.</li>
          <li>If <i>has</i> is <b>true</b>, return <b>true</b>.</li>
          <li>Return HasProductionInTailPosition of the second <i>Statement</i> with argument <i>nonterminal</i>.</li>
        </ol>

        <p><span class="prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></span></p>

        <div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">do</code> <span class="nt">Statement</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <code class="t">;</code></div>
          <div class="rhs"><code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">VariableDeclarationList</span> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><span class="nt">WithStatement</span> <code class="t">:</code> <code class="t">with</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        </div>

        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>Statement</i> with argument <i>nonterminal</i>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">LabelledStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
        </div>

        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>LabelledItem</i> with argument <i>nonterminal</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ReturnStatement</span> <span class="geq">:</span> <code class="t">return</code> <span class="nt">Expression</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>Expression</i> with argument <i>nonterminal</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">SwitchStatement</span> <span class="geq">:</span> <code class="t">switch</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">CaseBlock</span></div>
        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>CaseBlock</i> with argument <i>nonterminal</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <code class="t">}</code></div>
        <ol class="proc">
          <li>Let <i>has</i> be <b>false</b>.</li>
          <li>If the first <i>CaseClauses</i> is present, let <i>has</i> be HasProductionInTailPosition of the first
              <i>CaseClauses</i> with argument <i>nonterminal</i>.</li>
          <li>If <i>has</i> is <b>true</b>, return <b>true</b>.</li>
          <li>Let <i>has</i> be HasProductionInTailPosition of the <i>DefaultClause</i> with argument <i>nonterminal</i>.</li>
          <li>If <i>has</i> is <b>true</b>, return <b>true</b>.</li>
          <li>If the second <i>CaseClauses</i> is present, let <i>has</i> be HasProductionInTailPosition of the second
              <i>CaseClauses</i> with argument <i>nonterminal</i>.</li>
          <li>Return <i>has</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">CaseClauses</span> <span class="geq">:</span> <span class="nt">CaseClauses</span> <span class="nt">CaseClause</span></div>
        <ol class="proc">
          <li>Let <i>has</i> be HasProductionInTailPosition of <i>CaseClauses</i> with argument <i>nonterminal</i>.</li>
          <li>If <i>has</i> is <b>true</b>, return <b>true</b>.</li>
          <li>Return HasProductionInTailPosition of <i>CaseClause</i> with argument <i>nonterminal</i>.</li>
        </ol>

        <p><span class="prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></span></p>

        <div class="gp prod"><span class="nt">DefaultClause</span> <span class="geq">:</span> <code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
        <ol class="proc">
          <li>If <i>StatementList</i> is present, return HasProductionInTailPosition of <i>StatementList</i> with argument
              <i>nonterminal</i>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span></div>
        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>Catch</i> with argument <i>nonterminal</i>.</li>
        </ol>

        <p><span class="prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Finally</span></span></p>

        <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span> <span class="nt">Finally</span></div>
        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>Finally</i> with argument <i>nonterminal</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">Catch</span> <span class="geq">:</span> <code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span> <code class="t">)</code> <span class="nt">Block</span></div>
        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>Block</i> with argument <i>nonterminal</i>.</li>
        </ol>
      </section>

      <section id="sec-expression-rules">
        <h4 id="sec-14.6.2.2" title="14.6.2.2"> Expression Rules</h4><div class="note">
          <p><span class="nh">NOTE</span> A potential tail position call that is immediately followed by return <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a> of the call result is also a possible tail position call. Function calls cannot return
          reference values, so such a <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a> operation will always returns the same value as the
          actual function call result.</p>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">AssignmentExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">YieldExpression</span></div>
          <div class="rhs"><span class="nt">ArrowFunction</span></div>
          <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">=</code> <span class="nt">AssignmentExpression</span></div>
          <div class="rhs"><span class="nt">LeftHandSideExpression</span> <span class="nt">AssignmentOperator</span> <span class="nt">AssignmentExpression</span></div>
          <div class="rhs"><span class="nt">BitwiseANDExpression</span> <code class="t">:</code> <span class="nt">BitwiseANDExpression</span> <code class="t">&amp;</code> <span class="nt">EqualityExpression</span></div>
          <div class="rhs"><span class="nt">BitwiseXORExpression</span> <code class="t">:</code> <span class="nt">BitwiseXORExpression</span> <code class="t">^</code> <span class="nt">BitwiseANDExpression</span></div>
          <div class="rhs"><span class="nt">BitwiseORExpression</span> <code class="t">:</code> <span class="nt">BitwiseORExpression</span> <code class="t">|</code> <span class="nt">BitwiseXORExpression</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">EqualityExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">==</code> <span class="nt">RelationalExpression</span></div>
          <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">!=</code> <span class="nt">RelationalExpression</span></div>
          <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">===</code> <span class="nt">RelationalExpression</span></div>
          <div class="rhs"><span class="nt">EqualityExpression</span> <code class="t">!==</code> <span class="nt">RelationalExpression</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RelationalExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&lt;</code> <span class="nt">ShiftExpression</span></div>
          <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&gt;</code> <span class="nt">ShiftExpression</span></div>
          <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&lt;=</code> <span class="nt">ShiftExpression</span></div>
          <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">&gt;=</code> <span class="nt">ShiftExpression</span></div>
          <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">instanceof</code> <span class="nt">ShiftExpression</span></div>
          <div class="rhs"><span class="nt">RelationalExpression</span> <code class="t">in</code> <span class="nt">ShiftExpression</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ShiftExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ShiftExpression</span> <code class="t">&lt;&lt;</code> <span class="nt">AdditiveExpression</span></div>
          <div class="rhs"><span class="nt">ShiftExpression</span> <code class="t">&gt;&gt;</code> <span class="nt">AdditiveExpression</span></div>
          <div class="rhs"><span class="nt">ShiftExpression</span> <code class="t">&gt;&gt;&gt;</code> <span class="nt">AdditiveExpression</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">AdditiveExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">AdditiveExpression</span> <code class="t">+</code> <span class="nt">MultiplicativeExpression</span></div>
          <div class="rhs"><span class="nt">AdditiveExpression</span> <code class="t">-</code> <span class="nt">MultiplicativeExpression</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">MultiplicativeExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MultiplicativeExpression</span> <span class="nt">MultiplicativeOperator</span> <span class="nt">UnaryExpression</span></div>
        </div>

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

        <div class="gp">
          <div class="lhs"><span class="nt">PostfixExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">++</code></div>
          <div class="rhs"><span class="nt">LeftHandSideExpression</span> <code class="t">--</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">CallExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">SuperCall</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
          <div class="rhs"><span class="nt">CallExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
          <div class="rhs"><span class="nt">NewExpression</span> <code class="t">:</code> <code class="t">new</code> <span class="nt">NewExpression</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">MemberExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <code class="t">[</code> <span class="nt">Expression</span> <code class="t">]</code></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
          <div class="rhs"><span class="nt">SuperProperty</span></div>
          <div class="rhs"><span class="nt">MetaProperty</span></div>
          <div class="rhs"><code class="t">new</code> <span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">PrimaryExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">this</code></div>
          <div class="rhs"><span class="nt">IdentifierReference</span></div>
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

        <div class="gp">
          <div class="lhs"><span class="nt">Expression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">AssignmentExpression</span></div>
          <div class="rhs"><span class="nt">Expression</span> <code class="t">,</code> <span class="nt">AssignmentExpression</span></div>
        </div>

        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>AssignmentExpression</i> with argument <i>nonterminal</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ConditionalExpression</span> <span class="geq">:</span> <span class="nt">LogicalORExpression</span> <code class="t">?</code> <span class="nt">AssignmentExpression</span> <code class="t">:</code> <span class="nt">AssignmentExpression</span></div>
        <ol class="proc">
          <li>Let <i>has</i> be HasProductionInTailPosition of the first <i>AssignmentExpression</i> with argument
              <i>nonterminal</i>.</li>
          <li>If <i>has</i> is <b>true</b>, return <b>true</b>.</li>
          <li>Return HasProductionInTailPosition of the second <i>AssignmentExpression</i> with argument <i>nonterminal</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LogicalANDExpression</span> <span class="geq">:</span> <span class="nt">LogicalANDExpression</span> <code class="t">&amp;&amp;</code> <span class="nt">BitwiseORExpression</span></div>
        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>BitwiseORExpression</i> with argument <i>nonterminal</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LogicalORExpression</span> <span class="geq">:</span> <span class="nt">LogicalORExpression</span> <code class="t">||</code> <span class="nt">LogicalANDExpression</span></div>
        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>LogicalANDExpression</i> with argument <i>nonterminal</i>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">CallExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <span class="nt">Arguments</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <span class="nt">Arguments</span></div>
          <div class="rhs"><span class="nt">CallExpression</span> <span class="nt">TemplateLiteral</span></div>
        </div>

        <ol class="proc">
          <li>If this <i>CallExpression</i> is <i>nonterminal</i>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">MemberExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">MemberExpression</span> <span class="nt">TemplateLiteral</span></div>
        </div>

        <ol class="proc">
          <li>If this <i>MemberExpression</i> is <i>nonterminal</i>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">PrimaryExpression</span> <span class="geq">:</span> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span></div>
        <ol class="proc">
          <li>Let <i>expr</i> be CoveredParenthesizedExpression of <i>CoverParenthesizedExpressionAndArrowParameterList</i>.</li>
          <li>Return HasProductionInTailPosition of <i>expr</i> with argument <i>nonterminal</i>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ParenthesizedExpression</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code></div>
        </div>

        <ol class="proc">
          <li>Return HasProductionInTailPosition of <i>Expression</i> with argument <i>nonterminal</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-preparefortailcall">
      <h3 id="sec-14.6.3" title="14.6.3">
          Runtime Semantics: PrepareForTailCall ( )</h3><p class="normalbefore">The abstract operation PrepareForTailCall performs the following steps:</p>

      <ol class="proc">
        <li>Let <i>leafContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li><a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <i>leafContext</i>.</li>
        <li>Pop <i>leafContext</i> from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>. The <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> now on the top of the stack becomes <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>leafContext</i> has no further use. It will never be activated as
            <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
      </ol>

      <p>A tail position call must either release any transient internal resources associated with the currently executing
      function <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> before invoking the target function or reuse those
      resources in support of the target function.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> For example, a tail position call should only grow an implementation&rsquo;s activation
        record stack by the amount that the size of the target function&rsquo;s activation record exceeds the size of the calling
        function&rsquo;s activation record. If the target function&rsquo;s activation record is smaller, then the total size of
        the stack should decrease.</p>
      </div>
    </section>
  </section>
</section>

