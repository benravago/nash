<section id="sec-ecmascript-language-scripts-and-modules">
  <div class="front">
    <h1 id="sec-15" title="15"> ECMAScript Language: Scripts and Modules</h1></div>

  <section id="sec-scripts">
    <div class="front">
      <h2 id="sec-15.1" title="15.1"> Scripts</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">Script</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ScriptBody</span><sub class="g-opt">opt</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ScriptBody</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">StatementList</span></div>
      </div>
    </div>

    <section id="sec-scripts-static-semantics-early-errors">
      <h3 id="sec-15.1.1" title="15.1.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">Script</span> <span class="geq">:</span> <span class="nt">ScriptBody</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if the LexicallyDeclaredNames of <span class="nt">ScriptBody</span> contains any duplicate
          entries.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the <span style="font-family: Times New Roman">LexicallyDeclaredNames</span>
          of <span class="nt">ScriptBody</span> also occurs in the <span style="font-family: Times New           Roman">VarDeclaredNames</span> of <span class="nt">ScriptBody</span>.</p>
        </li>
      </ul>
      <div class="gp prod"><span class="nt">ScriptBody</span> <span class="geq">:</span> <span class="nt">StatementList</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if <span class="nt">StatementList</span> <span style="font-family: Times New           Roman">Contains</span> <code>super</code> unless the source code containing <code>super</code> is eval code that is
          being processed by a direct <code>eval</code> that is contained in function code that is not the function code of an
          <span class="nt">ArrowFunction</span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if <span class="nt">StatementList</span> <span style="font-family: Times New           Roman">Contains</span> <span class="nt">NewTarget</span> unless the source code containing <span class="nt">NewTarget</span> is eval code that is being processed by a direct <code>eval</code> that is contained in
          function code that is not the function code of an <span class="nt">ArrowFunction</span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if ContainsDuplicateLabels of <span class="nt">StatementList</span> <span style="font-family:           Times New Roman">with argument &laquo; &raquo; is <b>true</b>.</span></p>
        </li>

        <li>
          <p>It is a Syntax Error if ContainsUndefinedBreakTarget of <span class="nt">StatementList</span> <span style="font-family: Times New Roman">with argument &laquo; &raquo; is <b>true</b>.</span></p>
        </li>

        <li>
          <p>It is a Syntax Error if ContainsUndefinedContinueTarget of <span style="font-family: Times New           Roman"><i>StatementList</i> with arguments &laquo; &raquo; and &laquo; &raquo; is <b>true</b>.</span></p>
        </li>
      </ul>
    </section>

    <section id="sec-static-semantics-isstrict">
      <h3 id="sec-15.1.2" title="15.1.2"> Static Semantics:  IsStrict</h3><div class="gp prod"><span class="nt">ScriptBody</span> <span class="geq">:</span> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>If the DirectivePrologue of <i>StatementList</i> contains a <a href="sec-ecmascript-language-functions-and-classes#sec-directive-prologues-and-the-use-strict-directive">Use Strict Directive</a>, return <b>true</b>; otherwise,
            return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-scripts-static-semantics-lexicallydeclarednames">
      <h3 id="sec-15.1.3" title="15.1.3"> Static Semantics:  LexicallyDeclaredNames</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-lexicallydeclarednames">13.2.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-lexicallydeclarednames">13.12.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-lexicallydeclarednames">13.13.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallydeclarednames">14.1.13</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallydeclarednames">14.2.10</a>, <a href="#sec-module-semantics-static-semantics-lexicallydeclarednames">15.2.1.11</a>.</p>

      <div class="gp prod"><span class="nt">ScriptBody</span> <span class="geq">:</span> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>Return TopLevelLexicallyDeclaredNames of <i>StatementList</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> At the top level of a <span class="nt">Script</span>, function declarations are treated
        like var declarations rather than like lexical declarations.</p>
      </div>
    </section>

    <section id="sec-scripts-static-semantics-lexicallyscopeddeclarations">
      <h3 id="sec-15.1.4" title="15.1.4"> Static Semantics:  LexicallyScopedDeclarations</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-lexicallyscopeddeclarations">13.2.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-lexicallyscopeddeclarations">13.12.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-lexicallyscopeddeclarations">13.13.7</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallyscopeddeclarations">14.1.14</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallyscopeddeclarations">14.2.11</a>, <a href="#sec-module-semantics-static-semantics-lexicallyscopeddeclarations">15.2.1.12</a>, <a href="#sec-exports-static-semantics-lexicallyscopeddeclarations">15.2.3.8</a>.</p>

      <div class="gp prod"><span class="nt">ScriptBody</span> <span class="geq">:</span> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>Return TopLevelLexicallyScopedDeclarations of <i>StatementList</i>.</li>
      </ol>
    </section>

    <section id="sec-scripts-static-semantics-vardeclarednames">
      <h3 id="sec-15.1.5" title="15.1.5"> Static Semantics:  VarDeclaredNames</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

      <div class="gp prod"><span class="nt">ScriptBody</span> <span class="geq">:</span> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>Return TopLevelVarDeclaredNames of <i>StatementList</i>.</li>
      </ol>
    </section>

    <section id="sec-scripts-static-semantics-varscopeddeclarations">
      <h3 id="sec-15.1.6" title="15.1.6"> Static Semantics:  VarScopedDeclarations</h3><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

      <div class="gp prod"><span class="nt">ScriptBody</span> <span class="geq">:</span> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>Return TopLevelVarScopedDeclarations of <i>StatementList</i>.</li>
      </ol>
    </section>

    <section id="sec-runtime-semantics-scriptevaluation">
      <h3 id="sec-15.1.7" title="15.1.7"> Runtime Semantics: ScriptEvaluation</h3><p>With argument <var>realm</var>.</p>

      <div class="gp prod"><span class="nt">Script</span> <span class="geq">:</span> <span class="nt">ScriptBody</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If <i>ScriptBody</i> is not present, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
        <li>Let <i>globalEnv</i> be <i>realm</i>.[[globalEnv]].</li>
        <li>Let <i>scriptCxt</i> be a new <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">ECMAScript code execution context</a>.</li>
        <li>Set the Function of <i>scriptCxt</i> to <b>null</b>.</li>
        <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> of <i>scriptCxt</i> to <i>realm</i>.</li>
        <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> of <i>scriptCxt</i> to <i>globalEnv</i>.</li>
        <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <i>scriptCxt</i> to <i>globalEnv</i>.</li>
        <li><a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the currently running execution
            context</a>.</li>
        <li>Push <i>scriptCxt</i> on to <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>; <i>scriptCxt</i> is now
            <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>result</i> be <a href="#sec-globaldeclarationinstantiation">GlobalDeclarationInstantiation</a>(<i>ScriptBody</i>,
            <i>globalEnv</i>).</li>
        <li>If <i>result</i>.[[type]] is <span style="font-family: sans-serif">normal</span>, then
          <ol class="block">
            <li>Let <i>result</i> be the result of evaluating <i>ScriptBody</i>.</li>
          </ol>
        </li>
        <li>If <i>result</i>.[[type]] is <span style="font-family: sans-serif">normal</span> and <i>result</i>.[[value]] is <span style="font-family: sans-serif">empty</span>, then
          <ol class="block">
            <li>Let <i>result</i> be <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
          </ol>
        </li>
        <li><a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <i>scriptCxt</i> and remove it from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> is
            not empty.</li>
        <li>Resume the context that is now on the top of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> as <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>result</i>).</li>
      </ol>
    </section>

    <section id="sec-globaldeclarationinstantiation">
      <h3 id="sec-15.1.8" title="15.1.8"> Runtime Semantics: GlobalDeclarationInstantiation (script, env)</h3><div class="note">
        <p><span class="nh">NOTE 1</span> When an <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> is established for
        evaluating scripts, declarations are instantiated in the current global environment. Each global binding declared in the
        code is instantiated.</p>
      </div>

      <p class="normalbefore">GlobalDeclarationInstantiation is performed as follows using arguments <var>script</var> and
      <var>env</var>. <var>script</var> is the <span class="nt">ScriptBody</span> for which the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> is being established. <var>env</var> is the global <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">lexical environment</a> in which bindings are to be created.</p>

      <ol class="proc">
        <li>Let <i>envRec</i> be <i>env</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> is a global <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>.</li>
        <li>Let <i>lexNames</i> be the LexicallyDeclaredNames of <i>script</i>.</li>
        <li>Let <i>varNames</i> be the VarDeclaredNames of <i>script</i>.</li>
        <li>For each <i>name</i> in <i>lexNames</i>, do
          <ol class="block">
            <li>If <i>envRec.</i><a href="sec-executable-code-and-execution-contexts#sec-hasvardeclaration">HasVarDeclaration</a>(<i>name</i>) is <b>true</b>, throw a
                <b>SyntaxError</b> exception.</li>
            <li>If <i>envRec.</i><a href="sec-executable-code-and-execution-contexts#sec-haslexicaldeclaration">HasLexicalDeclaration</a>(<i>name</i>) is <b>true</b>, throw
                a <b>SyntaxError</b> exception.</li>
            <li>Let <i>hasRestrictedGlobal</i> be <i>envRec.</i><a href="sec-executable-code-and-execution-contexts#sec-hasrestrictedglobalproperty">HasRestrictedGlobalProperty</a>(<i>name</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasRestrictedGlobal</i>).</li>
            <li>If <i>hasRestrictedGlobal</i> is <b>true</b>, throw a <b>SyntaxError</b> exception.</li>
          </ol>
        </li>
        <li>For each <i>name</i> in <i>varNames</i>, do
          <ol class="block">
            <li>If <i>envRec.</i><a href="sec-executable-code-and-execution-contexts#sec-haslexicaldeclaration">HasLexicalDeclaration</a>(<i>name</i>) is <b>true</b>, throw
                a <b>SyntaxError</b> exception.</li>
          </ol>
        </li>
        <li>Let <i>varDeclarations</i> be the VarScopedDeclarations of <i>script</i>.</li>
        <li>Let <i>functionsToInitialize</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Let <i>declaredFunctionNames</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>For each <i>d</i> in <i>varDeclarations</i>, in reverse list order do
          <ol class="block">
            <li>If <i>d</i> is neither a <i>VariableDeclaration</i> or a <i>ForBinding</i>, then
              <ol class="block">
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>d</i> is either a <i>FunctionDeclaration</i> or a
                    <i>GeneratorDeclaration</i>.</li>
                <li>NOTE&#x9;If there are multiple <span style="font-family: Times New Roman"><i>FunctionDeclarations</i></span>
                    for the same name, the last declaration is used.</li>
                <li>Let <i>fn</i> be the sole element of the BoundNames of <i>d.</i></li>
                <li>If <i>fn</i> is not an element of <i>declaredFunctionNames</i>, then
                  <ol class="block">
                    <li>Let <i>fnDefinable</i> be <i>envRec.</i><a href="sec-executable-code-and-execution-contexts#sec-candeclareglobalfunction">CanDeclareGlobalFunction</a>(<i>fn</i>).</li>
                    <li>If <i>fnDefinable</i> is <b>false</b>, throw <b>TypeError</b> exception.</li>
                    <li>Append <i>fn</i> to <i>declaredFunctionNames</i>.</li>
                    <li>Insert <i>d</i> as the first element of <i>functionsToInitialize</i>.</li>
                  </ol>
                </li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Let <i>declaredVarNames</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>For each <i>d</i> in <i>varDeclarations</i>, do
          <ol class="block">
            <li>If <i>d</i> is a <i>VariableDeclaration</i> or a <i>ForBinding</i>, then
              <ol class="block">
                <li>For each String <i>vn</i> in the BoundNames of <i>d</i>, do
                  <ol class="block">
                    <li>If <i>vn</i> is not an element of <i>declaredFunctionNames</i>, then
                      <ol class="block">
                        <li>Let <i>vnDefinable</i> be <i>envRec.</i><a href="sec-executable-code-and-execution-contexts#sec-candeclareglobalvar">CanDeclareGlobalVar</a>(<i>vn</i>).</li>
                        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>vnDefinable</i>).</li>
                        <li>If <i>vnDefinable</i> is <b>false</b>, throw <b>TypeError</b> exception.</li>
                        <li>If <i>vn</i> is not an element of <i>declaredVarNames</i>, then
                          <ol class="block">
                            <li>Append <i>vn</i> to <i>declaredVarNames</i>.</li>
                          </ol>
                        </li>
                      </ol>
                    </li>
                  </ol>
                </li>
              </ol>
            </li>
          </ol>
        </li>
        <li>NOTE: No abnormal terminations occur after this algorithm step if the global object is an ordinary object. However, if
            the global object is a Proxy exotic object it may exhibit behaviours that cause abnormal terminations in some of the
            following steps.</li>
        <li>Let <i>lexDeclarations</i> be the LexicallyScopedDeclarations of <i>script</i>.</li>
        <li>For each element <i>d</i> in <i>lexDeclarations</i> do
          <ol class="block">
            <li>NOTE  Lexically declared names are only instantiated here but not initialized.</li>
            <li>For each element <i>dn</i> of the BoundNames of <i>d</i> do
              <ol class="block">
                <li>If  IsConstantDeclaration of <i>d</i> is <b>true</b>, then
                  <ol class="block">
                    <li>Let <i>status</i> be <i>envRec</i>.CreateImmutableBinding(<i>dn</i>, <b>true</b>).</li>
                  </ol>
                </li>
                <li>Else,
                  <ol class="block">
                    <li>Let <i>status</i> be <i>envRec</i>.CreateMutableBinding(<i>dn</i>, <b>false</b>).</li>
                  </ol>
                </li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>For each production <i>f</i> in <i>functionsToInitialize</i>, do
          <ol class="block">
            <li>Let <i>fn</i> be the sole element of the BoundNames of <i>f.</i></li>
            <li>Let <i>fo</i> be the result of performing InstantiateFunctionObject  for <i>f</i> with argument <i>env</i>.</li>
            <li>Let <i>status</i> be <i>envRec</i>.<a href="sec-executable-code-and-execution-contexts#sec-createglobalfunctionbinding">CreateGlobalFunctionBinding</a>(<i>fn</i>, <i>fo</i>, <b>false</b>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          </ol>
        </li>
        <li>For each String <i>vn</i> in <i>declaredVarNames</i>, in list order do
          <ol class="block">
            <li>Let <i>status</i> be <i>envRec.</i><a href="sec-executable-code-and-execution-contexts#sec-createglobalvarbinding">CreateGlobalVarBinding</a>(<i>vn</i>,
                <b>false</b>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          </ol>
        </li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>)</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 2</span> Early errors specified in <a href="#sec-scripts-static-semantics-early-errors">15.1.1</a>
        prevent name conflicts between function/var declarations and let/const/class declarations as well as redeclaration of
        let/const/class bindings for declaration contained within a single <span class="nt">Script</span>. However, such conflicts
        and redeclarations that span more than one <span class="nt">Script</span> are detected as runtime errors during
        GlobalDeclarationInstantiation. If any such errors are detected, no bindings are instantiated for the script. However, if
        the global object is defined using Proxy exotic objects then the runtime tests for conflicting declarations may be
        unreliable resulting in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> and some global
        declarations not being instantiated. If this occurs, the code for the <span class="nt">Script</span> is not evaluated.</p>

        <p>Unlike explicit var or function declarations, properties that are directly created on the global object result in
        global bindings that may be shadowed by let/const/class declarations.</p>
      </div>
    </section>

    <section id="sec-scriptevaluationjob">
      <h3 id="sec-15.1.9" title="15.1.9">
          Runtime Semantics: ScriptEvaluationJob ( sourceText )</h3><p class="normalbefore">The job ScriptEvaluationJob with parameter <var>sourceText</var> parses, validates, and evaluates
      <var>sourceText</var> as a <span class="nt">Script</span>.</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>sourceText</i> is an ECMAScript source text (see <a href="sec-ecmascript-language-source-code">clause 10</a>).</li>
        <li>Parse <i>sourceText</i> using <i>Script</i> as the goal symbol and analyze the parse result for any Early Error
            conditions. If the parse was successful and no early errors were found, let <i>code</i> be the resulting parse tree.
            Otherwise, let <i>code</i> be an indication of one or more parsing errors and/or early errors. Parsing and early error
            detection may be interweaved in an implementation dependent manner. If more than one parse or early error is present,
            the number and ordering of reported errors is implementation dependent but at least one error must be reported.</li>
        <li>If <i>code</i> is an error indication, then
          <ol class="block">
            <li>Report or log the error(s) in an implementation dependent manner.</li>
            <li>Let <i>status</i> be <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
          </ol>
        </li>
        <li>Else,
          <ol class="block">
            <li>Let <i>realm</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>.</li>
            <li>Let <i>status</i> be the result of ScriptEvaluation of <i>code</i> with argument <i>realm</i>.</li>
          </ol>
        </li>
        <li>NextJob <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> An implementation may parse a <var>sourceText</var> as a <span class="nt">Script</span>
        and analyze it for Early Error conditions prior to the execution of the ScriptEvaluationJob for that
        <var>sourceText</var>. However, the reporting of any errors must be deferred until the ScriptEvaluationJob is actually
        executed.</p>
      </div>
    </section>
  </section>

  <section id="sec-modules">
    <div class="front">
      <h2 id="sec-15.2" title="15.2"> Modules</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">Module</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ModuleBody</span><sub class="g-opt">opt</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ModuleBody</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ModuleItemList</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ModuleItemList</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ModuleItem</span></div>
        <div class="rhs"><span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ModuleItem</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ImportDeclaration</span></div>
        <div class="rhs"><span class="nt">ExportDeclaration</span></div>
        <div class="rhs"><span class="nt">StatementListItem</span></div>
      </div>
    </div>

    <section id="sec-module-semantics">
      <div class="front">
        <h3 id="sec-15.2.1" title="15.2.1">
            Module Semantics</h3></div>

      <section id="sec-module-semantics-static-semantics-early-errors">
        <h4 id="sec-15.2.1.1" title="15.2.1.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">ModuleBody</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span></div>
        <ul>
          <li>
            <p>It is a Syntax Error if the LexicallyDeclaredNames of <span class="nt">ModuleItemList</span> contains any duplicate
            entries.</p>
          </li>

          <li>
            <p>It is a Syntax Error if any element of the LexicallyDeclaredNames of <span class="nt">ModuleItemList</span> also
            occurs in the VarDeclaredNames of <span class="nt">ModuleItemList</span>.</p>
          </li>

          <li>
            <p>It is a Syntax Error if the ExportedNames of <span class="nt">ModuleItemList</span> contains any duplicate
            entries.</p>
          </li>

          <li>
            <p>It is a Syntax Error if any element of the ExportedBindings of <span class="nt">ModuleItemList</span> does not also
            occur in either the VarDeclaredNames of <var>ModuleItemList,</var> or the LexicallyDeclaredNames of <span class="nt">ModuleItemList</span>.</p>
          </li>

          <li>
            <p>It is a Syntax Error if <span class="nt">ModuleItemList</span> Contains <code>super</code>.</p>
          </li>

          <li>
            <p>It is a Syntax Error if <span style="font-family: Times New Roman"><i>ModuleItemList</i> Contains
            <i>NewTarget</i></span></p>
          </li>

          <li>
            <p>It is a Syntax Error if ContainsDuplicateLabels of <span class="nt">ModuleItemList</span> <span style="font-family:             Times New Roman">with argument &laquo; &raquo; is <b>true</b>.</span></p>
          </li>

          <li>
            <p>It is a Syntax Error if ContainsUndefinedBreakTarget of <span class="nt">ModuleItemList</span> <span style="font-family: Times New Roman">with argument &laquo; &raquo; is <b>true</b>.</span></p>
          </li>

          <li>
            <p>It is a Syntax Error if ContainsUndefinedContinueTarget of <span class="nt">ModuleItemList</span> <span style="font-family: Times New Roman">with arguments &laquo; &raquo; and &laquo; &raquo; is <b>true</b>.</span></p>
          </li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> The duplicate ExportedNames rule implies that multiple <code>export default</code> <span class="nt">ExportDeclaration</span> items within a <span class="nt">ModuleBody</span> is a Syntax Error. Additional
          error conditions relating to conflicting or duplicate declarations are checked during module linking prior to evaluation
          of a <span class="nt">Module</span>. If any such errors are detected the <span class="nt">Module</span> is not
          evaluated.</p>
        </div>
      </section>

      <section id="sec-module-semantics-static-semantics-containsduplicatelabels">
        <h4 id="sec-15.2.1.2" title="15.2.1.2"> Static Semantics:  ContainsDuplicateLabels</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>.</p>

        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>hasDuplicates</i> be ContainsDuplicateLabels of <i>ModuleItemList</i> with argument <i>labelSet</i>.</li>
          <li>If <i>hasDuplicates</i> is <b>true</b> return <b>true</b>.</li>
          <li>Return ContainsDuplicateLabels of <i>ModuleItem</i> with argument <i>labelSet.</i></li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ModuleItem</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ImportDeclaration</span></div>
          <div class="rhs"><span class="nt">ExportDeclaration</span></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-module-semantics-static-semantics-containsundefinedbreaktarget">
        <h4 id="sec-15.2.1.3" title="15.2.1.3"> Static Semantics:  ContainsUndefinedBreakTarget</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>.</p>

        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedBreakTarget of <i>ModuleItemList</i> with argument
              <i>labelSet</i>.</li>
          <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
          <li>Return ContainsUndefinedBreakTarget of <i>ModuleItem</i> with argument <i>labelSet.</i></li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ModuleItem</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ImportDeclaration</span></div>
          <div class="rhs"><span class="nt">ExportDeclaration</span></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-module-semantics-static-semantics-containsundefinedcontinuetarget">
        <h4 id="sec-15.2.1.4" title="15.2.1.4"> Static Semantics:  ContainsUndefinedContinueTarget</h4><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

        <p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>.</p>

        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedContinueTarget of <i>ModuleItemList</i> with arguments
              <i>iterationSet</i> and &laquo;&nbsp;&raquo;.</li>
          <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
          <li>Return ContainsUndefinedContinueTarget of <i>ModuleItem</i> with arguments <i>iterationSet</i> and
              &laquo;&nbsp;&raquo;<i>.</i></li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ModuleItem</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ImportDeclaration</span></div>
          <div class="rhs"><span class="nt">ExportDeclaration</span></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-module-semantics-static-semantics-exportedbindings">
        <h4 id="sec-15.2.1.5" title="15.2.1.5"> Static Semantics:  ExportedBindings</h4><p>See also: <a href="#sec-exports-static-semantics-exportedbindings">15.2.3.3</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> ExportedBindings are the locally bound names that are explicitly associated with a <span style="font-family: Times New Roman"><i>Module</i>&rsquo;s</span> ExportedNames.</p>
        </div>

        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be ExportedBindings of <i>ModuleItemList</i>.</li>
          <li>Append to <i>names</i> the elements of the ExportedBindings of <i>ModuleItem.</i></li>
          <li>Return <i>names</i>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ModuleItem</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ImportDeclaration</span></div>
          <div class="rhs"><span class="nt">StatementListItem</span></div>
        </div>

        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
      </section>

      <section id="sec-module-semantics-static-semantics-exportednames">
        <h4 id="sec-15.2.1.6" title="15.2.1.6"> Static Semantics:  ExportedNames</h4><p>See also: <a href="#sec-exports-static-semantics-exportednames">15.2.3.4</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> ExportedNames are the externally visible names that a <span class="nt">Module</span>
          explicitly maps to one of its local name bindings.</p>
        </div>

        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be ExportedNames of <i>ModuleItemList</i>.</li>
          <li>Append to <i>names</i> the elements of the ExportedNames of <i>ModuleItem.</i></li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">ExportDeclaration</span></div>
        <ol class="proc">
          <li>Return the ExportedNames of <i>ExportDeclaration</i>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ModuleItem</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ImportDeclaration</span></div>
          <div class="rhs"><span class="nt">StatementListItem</span></div>
        </div>

        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
      </section>

      <section id="sec-module-semantics-static-semantics-exportentries">
        <h4 id="sec-15.2.1.7" title="15.2.1.7"> Static Semantics:  ExportEntries</h4><p>See also: <a href="#sec-exports-static-semantics-exportentries">15.2.3.5</a>.</p>

        <div class="gp prod"><span class="nt">Module</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>entries</i> be ExportEntries of <i>ModuleItemList</i>.</li>
          <li>Append to <i>entries</i> the elements of the ExportEntries of <i>ModuleItem.</i></li>
          <li>Return <i>entries</i>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ModuleItem</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ImportDeclaration</span></div>
          <div class="rhs"><span class="nt">StatementListItem</span></div>
        </div>

        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
      </section>

      <section id="sec-module-semantics-static-semantics-importentries">
        <h4 id="sec-15.2.1.8" title="15.2.1.8"> Static Semantics:  ImportEntries</h4><p>See also: <a href="#sec-imports-static-semantics-importentries">15.2.2.3</a>.</p>

        <div class="gp prod"><span class="nt">Module</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>entries</i> be ImportEntries of <i>ModuleItemList</i>.</li>
          <li>Append to <i>entries</i> the elements of the ImportEntries of <i>ModuleItem.</i></li>
          <li>Return <i>entries</i>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ModuleItem</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ExportDeclaration</span></div>
          <div class="rhs"><span class="nt">StatementListItem</span></div>
        </div>

        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
      </section>

      <section id="sec-importedlocalnames">
        <h4 id="sec-15.2.1.9" title="15.2.1.9"> Static Semantics:  ImportedLocalNames ( importEntries )</h4><p class="normalbefore">The abstract operation ImportedLocalNames with argument <var>importEntries</var> creates a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of all of the local name bindings defined by a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of ImportEntry Records (see <a href="#table-39">Table
        39</a>)<var>.</var> ImportedLocalNames performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>localNames</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>For each ImportEntry Record <i>i</i> in <i>importEntries</i>, do
            <ol class="block">
              <li>Append <i>i</i>.[[LocalName]] to <i>localNames</i>.</li>
            </ol>
          </li>
          <li>Return <i>localNames</i>.</li>
        </ol>
      </section>

      <section id="sec-module-semantics-static-semantics-modulerequests">
        <h4 id="sec-15.2.1.10" title="15.2.1.10"> Static Semantics:  ModuleRequests</h4><p>See also: <a href="#sec-imports-static-semantics-modulerequests">15.2.2.5</a>,<a href="#sec-exports-static-semantics-modulerequests">15.2.3.9</a>.</p>

        <div class="gp prod"><span class="nt">Module</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Return ModuleRequests of <i>ModuleItem</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>moduleNames</i> be ModuleRequests of <i>ModuleItemList</i>.</li>
          <li>Let <i>additionalNames</i> be ModuleRequests of <i>ModuleItem.</i></li>
          <li>Append to <i>moduleNames</i> each element of <i>additionalNames</i> that is not already an element of
              <i>moduleNames.</i></li>
          <li>Return <i>moduleNames</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">StatementListItem</span></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
      </section>

      <section id="sec-module-semantics-static-semantics-lexicallydeclarednames">
        <h4 id="sec-15.2.1.11" title="15.2.1.11"> Static Semantics:  LexicallyDeclaredNames</h4><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-lexicallydeclarednames">13.2.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-lexicallydeclarednames">13.12.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-lexicallydeclarednames">13.13.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallydeclarednames">14.1.13</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallydeclarednames">14.2.10</a>, <a href="#sec-scripts-static-semantics-lexicallydeclarednames">15.1.3</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The LexicallyDeclaredNames of a <span class="nt">Module</span> includes the names of
          all of its imported bindings.</p>
        </div>

        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be LexicallyDeclaredNames of <i>ModuleItemList</i>.</li>
          <li>Append to <i>names</i> the elements of the LexicallyDeclaredNames of <i>ModuleItem.</i></li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">ImportDeclaration</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>ImportDeclaration</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">ExportDeclaration</span></div>
        <ol class="proc">
          <li>If <i>ExportDeclaration</i> is <code>export</code> <i>VariableStatement</i><span style="font-family:               sans-serif">,</span> return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Return the BoundNames of <i>ExportDeclaration</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">StatementListItem</span></div>
        <ol class="proc">
          <li>Return LexicallyDeclaredNames of <i>StatementListItem</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 2</span> At the top level of a <span class="nt">Module</span>, function declarations are
          treated like lexical declarations rather than like var declarations.</p>
        </div>
      </section>

      <section id="sec-module-semantics-static-semantics-lexicallyscopeddeclarations">
        <h4 id="sec-15.2.1.12" title="15.2.1.12"> Static Semantics:  LexicallyScopedDeclarations</h4><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-lexicallyscopeddeclarations">13.2.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-lexicallyscopeddeclarations">13.12.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-lexicallyscopeddeclarations">13.13.7</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallyscopeddeclarations">14.1.14</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallyscopeddeclarations">14.2.11</a>, <a href="#sec-scripts-static-semantics-lexicallyscopeddeclarations">15.1.4</a>, <a href="#sec-exports-static-semantics-lexicallyscopeddeclarations">15.2.3.8</a>.</p>

        <div class="gp prod"><span class="nt">Module</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>declarations</i> be LexicallyScopedDeclarations of <i>ModuleItemList</i>.</li>
          <li>Append to <i>declarations</i> the elements of the LexicallyScopedDeclarations of <i>ModuleItem.</i></li>
          <li>Return <i>declarations</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">ImportDeclaration</span></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
      </section>

      <section id="sec-module-semantics-static-semantics-vardeclarednames">
        <h4 id="sec-15.2.1.13" title="15.2.1.13"> Static Semantics:  VarDeclaredNames</h4><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>.</p>

        <div class="gp prod"><span class="nt">Module</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
        <ol class="proc">
          <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>

        <p><span class="prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></span></p>

        <ol class="proc">
          <li>Let <i>names</i> be VarDeclaredNames of <i>ModuleItemList</i>.</li>
          <li>Append to <i>names</i> the elements of the VarDeclaredNames of <i>ModuleItem.</i></li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">ImportDeclaration</span></div>
        <ol class="proc">
          <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">ExportDeclaration</span></div>
        <ol class="proc">
          <li>If <i>ExportDeclaration</i> is <code>export</code> <i>VariableStatement</i>, return BoundNames of
              <i>ExportDeclaration</i>.</li>
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
      </section>

      <section id="sec-module-semantics-static-semantics-varscopeddeclarations">
        <h4 id="sec-15.2.1.14" title="15.2.1.14"> Static Semantics:  VarScopedDeclarations</h4><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>.</p>

        <div class="gp prod"><span class="nt">Module</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>declarations</i> be VarScopedDeclarations of <i>ModuleItemList</i>.</li>
          <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of <i>ModuleItem.</i></li>
          <li>Return <i>declarations</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">ImportDeclaration</span></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">ExportDeclaration</span></div>
        <ol class="proc">
          <li>If <i>ExportDeclaration</i> is <code>export</code> <i>VariableStatement</i>, return VarScopedDeclarations of
              <i>VariableStatement</i>.</li>
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
      </section>

      <section id="sec-abstract-module-records">
        <h4 id="sec-15.2.1.15" title="15.2.1.15"> Abstract Module Records</h4><p>A Module Record encapsulates structural information about the imports and exports of a single module. This information
        is used to link the imports and exports of sets of connected modules. A Module Record includes four fields that are only
        used when evaluating a module.</p>

        <p>For specification purposes Module Record values are values of the Record specification type and can be thought of as
        existing in a simple object-oriented hierarchy where Module Record is an abstract class with concrete subclasses. This
        specification only defines a single Module Record concrete subclass named <a href="#sec-source-text-module-records">Source
        Text Module Record</a>. Other specifications and implementations may define additional Module Record subclasses
        corresponding to alternative module definition facilities that they defined.</p>

        <p class="normalbefore">Module Record defines the fields listed in <a href="#table-36">Table 36</a>. All Module Definition
        subclasses include at least those fields. Module Record also defines the abstract method list in <a href="#table-37">Table
        37</a>. All Module definition subclasses must provide concrete implementations of these abstract methods.</p>

        <figure>
          <figcaption><span id="table-36">Table 36</span> &mdash; Module Record Fields</figcaption>
          <table class="real-table">
            <tr>
              <th>Field Name</th>
              <th>Value Type</th>
              <th>Meaning</th>
            </tr>
            <tr>
              <td>[[Realm]]</td>
              <td><a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> Record | <span class="value">undefined</span></td>
              <td>The <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> within which this module was created. <span class="value">undefined</span> if not yet assigned.</td>
            </tr>
            <tr>
              <td>[[Environment]]</td>
              <td><a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a> | <span class="value">undefined</span></td>
              <td>The <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a> containing the top level bindings for this module. This field is set when the module is instantiated.</td>
            </tr>
            <tr>
              <td>[[Namespace]]</td>
              <td>Object | <span class="value">undefined</span></td>
              <td>The Module Namespace Object (<a href="sec-reflection#sec-module-namespace-objects">26.3</a>) if one has been created  for this module. Otherwise <span class="value">undefined</span>.</td>
            </tr>
            <tr>
              <td>[[Evaluated]]</td>
              <td>Boolean</td>
              <td>Initially <span class="value">false</span>, <span class="value">true</span> if evaluation of this module has started. Remains <span class="value">true</span> when evaluation completes, even if it is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</td>
            </tr>
          </table>
        </figure>

        <figure>
          <figcaption><span id="table-37">Table 37</span> &mdash; Abstract Methods of Module Records</figcaption>
          <table class="real-table">
            <tr>
              <th>Method</th>
              <th>Purpose</th>
            </tr>
            <tr>
              <td><a href="#sec-getexportednames">GetExportedNames</a>(exportStarSet)</td>
              <td>Return a list of all names that are either directly or indirectly exported from this module.</td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black"><a href="#sec-resolveexport">ResolveExport</a>(exportName, resolveSet, exportStarSet)</td>
              <td style="border-bottom: 1px solid black">Return the binding of a name exported by this modules. Bindings are represented by a Record of the form {[[module]]: Module Record, [[bindingName]]: String}</td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid black; border-top: 1px solid black"><a href="#sec-moduledeclarationinstantiation">ModuleDeclarationInstantiation</a>()</td>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid black; border-top: 1px solid black">Transitively resolve all module dependencies and create a module <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> for the module.</td>
            </tr>
            <tr>
              <td style="border-top: 1px solid black"><a href="#sec-moduleevaluation">ModuleEvaluation</a>()</td>

              <td style="border-top: 1px solid black">
                <p>Do nothing if this module has already been evaluated. Otherwise, transitively evaluate all module dependences
                of this module and then evaluate this module.</p>

                <p><a href="#sec-moduledeclarationinstantiation">ModuleDeclarationInstantiation</a> must be completed prior to
                invoking this method.</p>
              </td>
            </tr>
          </table>
        </figure>
      </section>

      <section id="sec-source-text-module-records">
        <div class="front">
          <h4 id="sec-15.2.1.16" title="15.2.1.16"> Source Text Module Records</h4><p>A Source Text <a href="#sec-abstract-module-records">Module Record</a> is used to represent information about a
          module that was defined from ECMAScript source text (10) that was parsed using the goal symbol <span class="nt">Module</span>. Its fields contain digested information about the names that are imported by the module and
          its concrete methods use this digest to link, instantiate, and evaluate the module.</p>

          <p>In addition to the fields, defined in <a href="#table-36">Table 36</a>, Source Text Module Records have the
          additional fields listed in <a href="#table-38">Table 38</a>. Each of these fields initially has the value <span class="value">undefined</span>.</p>

          <figure>
            <figcaption><span id="table-38">Table 38</span> &mdash; Additional Fields of Source Text Module Records</figcaption>
            <table class="real-table">
              <tr>
                <th>Field Name</th>
                <th>Value Type</th>
                <th>Meaning</th>
              </tr>
              <tr>
                <td>[[ECMAScriptCode]]</td>
                <td>a parse result</td>
                <td>The result of parsing the source text of this module using <span class="nt">Module</span> as the goal symbol.</td>
              </tr>
              <tr>
                <td>[[RequestedModules]]</td>
                <td><a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of String</td>
                <td>A <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of all the <span class="nt">ModuleSpecifier</span> strings used by the module represented by this record to request the importation of a module. The <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> is source code occurrence ordered.</td>
              </tr>
              <tr>
                <td>[[ImportEntries]]</td>
                <td><a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of ImportEntry Records</td>
                <td>A <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of ImportEntry records derived from the code of this module.</td>
              </tr>
              <tr>
                <td>[[LocalExportEntries]]</td>
                <td><a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of ExportEntry Records</td>
                <td>A <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of ExportEntry records derived from the code of this module that correspond to declarations that occur within the module.</td>
              </tr>
              <tr>
                <td>[[IndirectExportEntries]]</td>
                <td><a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of ExportEntry Records</td>
                <td>A <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of ExportEntry records derived from the code of this module that correspond to reexported imports that occur within the module.</td>
              </tr>
              <tr>
                <td>[[StarExportEntries]]</td>
                <td><a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of ExportEntry Records</td>
                <td>A <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of ExportEntry records derived from the code of this module that correspond to export * declarations that occur within the module.</td>
              </tr>
            </table>
          </figure>

          <p>An ImportEntry Record is a Record that digests information about a single declarative import. Each ImportEntry Record
          has the fields defined in <a href="#table-39">Table 39</a>:</p>

          <figure>
            <figcaption><span id="table-39">Table 39</span> &mdash; ImportEntry Record Fields</figcaption>
            <table class="real-table">
              <tr>
                <th>Field Name</th>
                <th>Value Type</th>
                <th>Meaning</th>
              </tr>
              <tr>
                <td>[[ModuleRequest]]</td>
                <td>String</td>
                <td>String value of the <span class="nt">ModuleSpecifier</span> of the <span class="nt">ImportDeclaration</span>.</td>
              </tr>
              <tr>
                <td>[[ImportName]]</td>
                <td>String</td>
                <td>The name under which the desired binding is exported by the module identified by [[ModuleRequest]]. The value <code>"*"</code> indicates that the import request is for the target module&rsquo;s namespace object.</td>
              </tr>
              <tr>
                <td>[[LocalName]]</td>
                <td>String</td>
                <td>The name that is used to locally access the imported value from within the importing module.</td>
              </tr>
            </table>
          </figure>

          <div class="note">
            <p><span class="nh">NOTE 1</span> <a href="#table-40">Table 40</a> gives examples of ImportEntry records fields used
            to represent the syntactic import forms:</p>
          </div>

          <figure>
            <figcaption><span id="table-40">Table 40</span> (Informative) &mdash; Import Forms Mappings to ImportEntry Records</figcaption>
            <table class="real-table">
              <tr>
                <th>
                  <p class="Note"><b><i>Import Statement Form</i></b></p>
                </th>
                <th>
                  <p class="Note"><b>[[ModuleRequest]]</b></p>
                </th>
                <th>
                  <p class="Note"><b>[[ImportName]]</b></p>
                </th>
                <th>
                  <p class="Note"><b>[[LocalName]]</b></p>
                </th>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>import v from "mod";</code></p>
                </td>

                <td>
                  <p class="Note"><code>"mod"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"default"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"v"</code></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>import * as ns from "mod";</code></p>
                </td>

                <td>
                  <p class="Note"><code>"mod"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"*"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"ns"</code></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>import {x} from "mod";</code></p>
                </td>

                <td>
                  <p class="Note"><code>"mod"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"x"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"x"</code></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>import {x as v} from "mod";</code></p>
                </td>

                <td>
                  <p class="Note"><code>"mod"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"x"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"v"</code></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>import "mod";</code></p>
                </td>

                <td colspan="3">An ImportEntry Record is not created.</td>
              </tr>
            </table>
          </figure>

          <p>An ExportEntry Record is a Record that digests information about a single declarative export. Each ExportEntry Record
          has the fields defined in <a href="#table-41">Table 41</a>:</p>

          <figure>
            <figcaption><span id="table-41">Table 41</span> &mdash; ExportEntry Record Fields</figcaption>
            <table class="real-table">
              <tr>
                <th>Field Name</th>
                <th>Value&nbsp;Type</th>
                <th>Meaning</th>
              </tr>
              <tr>
                <td>[[ExportName]]</td>
                <td>String</td>
                <td>The name used to export this binding by this module.</td>
              </tr>
              <tr>
                <td>[[ModuleRequest]]</td>
                <td>String | null</td>
                <td>The String value of the <span class="nt">ModuleSpecifier</span> of the <span class="nt">ExportDeclaration</span>. <span class="value">null</span> if the <span class="nt">ExportDeclaration</span> does not have a <span class="nt">ModuleSpecifier</span>.</td>
              </tr>
              <tr>
                <td>[[ImportName]]</td>
                <td>String | null</td>
                <td>The name under which the desired binding is exported by the module identified by [[ModuleRequest]]. <span class="value">null</span> if the <span class="nt">ExportDeclaration</span> does not have a <span class="nt">ModuleSpecifier</span>. <code>"*"</code> indicates that the export request is for all exported bindings.</td>
              </tr>
              <tr>
                <td>[[LocalName]]</td>
                <td>String | null</td>
                <td>The name that is used to locally access the exported value from within the importing module. <span class="value">null</span> if the exported value is not locally accessible from within the module.</td>
              </tr>
            </table>
          </figure>

          <div class="note">
            <p><span class="nh">NOTE 2</span> <a href="#table-42">Table 42</a> gives examples of the ExportEntry record fields
            used to represent the syntactic export forms:</p>
          </div>

          <figure>
            <figcaption><span id="table-42">Table 42</span> (Informative) &mdash; Export Forms Mappings to ExportEntry Records</figcaption>
            <table class="real-table">
              <tr>
                <th>
                  <p class="Note"><b><i>Export Statement Form</i></b></p>
                </th>
                <th>
                  <p class="Note"><b>[[ExportName]]</b></p>
                </th>
                <th>
                  <p class="Note"><b>[[ModuleRequest]]</b></p>
                </th>
                <th>
                  <p class="Note"><b>[[ImportName]]</b></p>
                </th>
                <th>
                  <p class="Note"><b>[[LocalName]]</b></p>
                </th>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>export var v;</code></p>
                </td>

                <td>
                  <p class="Note"><code>"v"</code></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><code>"v"</code></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>export default function f(){};</code></p>
                </td>

                <td>
                  <p class="Note"><code>"default"</code></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><code>"f"</code></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>export default function(){};</code></p>
                </td>

                <td>
                  <p class="Note"><code>"default"</code></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><code>"*default*"</code></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>export default 42;</code></p>
                </td>

                <td>
                  <p class="Note"><code>"default"</code></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><code>"*default*"</code></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>export {x};</code></p>
                </td>

                <td>
                  <p class="Note"><code>"x"</code></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><code>"x"</code></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>export {v as x};</code></p>
                </td>

                <td>
                  <p class="Note"><code>"x"</code></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><code>"v"</code></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>export {x} from "mod";</code></p>
                </td>

                <td>
                  <p class="Note"><code>"x"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"mod"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"x"</code></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>export {v as x} from "mod";</code></p>
                </td>

                <td>
                  <p class="Note"><code>"x"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"mod"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"v"</code></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>
              </tr>
              <tr>
                <td>
                  <p class="Note"><code>export * from "mod";</code></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>

                <td>
                  <p class="Note"><code>"mod"</code></p>
                </td>

                <td>
                  <p class="Note"><code>"*"</code></p>
                </td>

                <td>
                  <p class="Note"><b>null</b></p>
                </td>
              </tr>
            </table>
          </figure>

          <p>The following definitions specify the required concrete methods and other abstract operations for  Source Text Module
          Records</p>
        </div>

        <section id="sec-parsemodule">
          <h5 id="sec-15.2.1.16.1" title="15.2.1.16.1"> Runtime Semantics: ParseModule ( sourceText )</h5><p class="normalbefore">The abstract operation ParseModule with argument <var>sourceText</var> creates a <a href="#sec-source-text-module-records">Source Text Module Record</a> based upon the result of parsing
          <var>sourceText</var> as a <var>Module.</var> ParseModule performs the following steps:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>sourceText</i> is an ECMAScript source text (see <a href="sec-ecmascript-language-source-code">clause 10</a>).</li>
            <li>Parse <i>sourceText</i> using <i>Module</i> as the goal symbol and analyze the parse result for any Early Error
                conditions. If the parse was successful and no early errors were found, let <i>body</i> be the resulting parse
                tree. Otherwise, let <i>body</i> be an indication of one or more parsing errors and/or early errors. Parsing and
                early error detection may be interweaved in an implementation dependent manner. If more than one parse or early
                error is present, the number and ordering of reported errors is implementation dependent but at least one error
                must be reported.</li>
            <li>If <i>body</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> or error
                indication, then
              <ol class="block">
                <li>Throw a <b>SyntaxError</b> exception.</li>
              </ol>
            </li>
            <li>Let <i>requestedModules</i> be the ModuleRequests of <i>body</i>.</li>
            <li>Let <i>importEntries</i> be ImportEntries of <i>body</i>.</li>
            <li>Let <i>importedBoundNames</i> be <a href="#sec-importedlocalnames">ImportedLocalNames</a>(<i>importEntries</i>).</li>
            <li>Let <i>indirectExportEntries</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>Let <i>localExportEntries</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>Let <i>starExportEntries</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>Let <i>exportEntries</i> be ExportEntries of <i>body</i>.</li>
            <li>For each record <i>ee</i> in <i>exportEntries</i>, do
              <ol class="block">
                <li>If <i>ee</i>.[[ModuleRequest]] is <b>null</b>, then
                  <ol class="block">
                    <li>If <i>ee</i>.[[LocalName]] is not an element of <i>importedBoundNames</i>, then
                      <ol class="block">
                        <li>Append <i>ee</i> to <i>localExportEntries</i>.</li>
                      </ol>
                    </li>
                    <li>Else
                      <ol class="block">
                        <li>Let <i>ie</i> be the element of <i>importEntries</i> whose [[LocalName]] is the same as
                            <i>ee</i>.[[LocalName]].</li>
                        <li>If <i>ie</i>.[[ImportName]] is <code>"*"</code>, then
                          <ol class="block">
                            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: this is a re-export of an imported module
                                namespace object.</li>
                            <li>Append <i>ee</i> to <i>localExportEntries</i>.</li>
                          </ol>
                        </li>
                        <li>Else, this is a re-export of a single name
                          <ol class="block">
                            <li>Append to <i>indirectExportEntries</i> the Record {[[ModuleRequest]]: <i>ie</i>.[[ModuleRequest]],
                                [[ImportName]]: <i>ie</i>.[[ImportName]], [[LocalName]]: <b>null</b>, [[ExportName]]:
                                <i>ee</i>.[[ExportName]] }.</li>
                          </ol>
                        </li>
                      </ol>
                    </li>
                  </ol>
                </li>
                <li>Else, if <i>ee</i>.[[ImportName]] is <code>"*"</code>, then
                  <ol class="block">
                    <li>Append <i>ee</i> to <i>starExportEntries</i>.</li>
                  </ol>
                </li>
                <li>Else,
                  <ol class="block">
                    <li>Append <i>ee</i> to <i>indirectExportEntries</i>.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Return <a href="#sec-source-text-module-records">Source Text Module Record</a> {[[Realm]]: <b>undefined</b>,
                [[Environment]]: <b>undefined</b>, [[Namespace]]: <b>undefined</b>, [[Evaluated]]: <b>false</b>,
                [[ECMAScriptCode]]: <i>body</i>, [[RequestedModules]]: <i>requestedModules</i>, [[ImportEntries]]:
                <i>importEntries</i>, [[LocalExportEntries]]: <i>localExportEntries</i>, [[StarExportEntries]]:
                <i>starExportEntries</i>, [[IndirectExportEntries]]: <i>indirectExportEntries</i>}.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> An implementation may parse module source text and analyze it for Early Error
            conditions prior to the evaluation of ParseModule for that module source text. However, the reporting of any errors
            must be deferred until the point where this specification actually performs ParseModule upon that source text.</p>
          </div>
        </section>

        <section id="sec-getexportednames">
          <h5 id="sec-15.2.1.16.2" title="15.2.1.16.2"> GetExportedNames( exportStarSet ) Concrete Method</h5><p class="normalbefore">The GetExportedNames concrete method of a <a href="#sec-source-text-module-records">Source Text
          Module Record</a> with argument <var>exportStarSet</var> performs the following steps:</p>

          <ol class="proc">
            <li>Let <i>module</i> be this <a href="#sec-source-text-module-records">Source Text Module Record</a>.</li>
            <li>If <i>exportStarSet</i> contains <i>module</i>, then
              <ol class="block">
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: We&rsquo;ve reached the starting point of an import *
                    circularity.</li>
                <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
              </ol>
            </li>
            <li>Append <i>module</i> to <i>exportStarSet</i>.</li>
            <li>Let <i>exportedNames</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>For each ExportEntry Record <i>e</i> in <i>module</i>.[[LocalExportEntries]], do
              <ol class="block">
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>module</i> provides the direct binding for this
                    export.</li>
                <li>Append <i>e</i>.[[ExportName]] to <i>exportedNames</i>.</li>
              </ol>
            </li>
            <li>For each ExportEntry Record <i>e</i> in <i>module</i>.[[IndirectExportEntries]], do
              <ol class="block">
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>module</i> imports a specific binding for this
                    export.</li>
                <li>Append <i>e</i>.[[ExportName]] to <i>exportedNames</i>.</li>
              </ol>
            </li>
            <li>For each ExportEntry Record <i>e</i> in <i>module</i>.[[StarExportEntries]], do
              <ol class="block">
                <li>Let <i>requestedModule</i> be <a href="#sec-hostresolveimportedmodule">HostResolveImportedModule</a>(<i>module</i>,
                    <i>e</i>.[[ModuleRequest]]).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>requestedModule</i>).</li>
                <li>Let <i>starNames</i> be <i>requestedModule.</i>GetExportedNames(<i>exportStarSet</i>).</li>
                <li>For each element <i>n</i> of <i>starNames</i>, do
                  <ol class="block">
                    <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>n</i>, <code>"default"</code>) is <b>false</b>, then
                      <ol class="block">
                        <li>If <i>n</i> is not an element of <i>exportedNames</i>, then
                          <ol class="block">
                            <li>Append <i>n</i> to <i>exportedNames</i>.</li>
                          </ol>
                        </li>
                      </ol>
                    </li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Return <i>exportedNames</i>.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> GetExportedNames does not filter out or throw an exception for names that have
            ambiguous star export bindings.</p>
          </div>
        </section>

        <section id="sec-resolveexport">
          <h5 id="sec-15.2.1.16.3" title="15.2.1.16.3"> ResolveExport( exportName, resolveSet, exportStarSet ) Concrete
              Method</h5><p class="normalbefore">The ResolveExport concrete method of a <a href="#sec-source-text-module-records">Source Text
          Module Record</a> with arguments <var>exportName</var>, <var>resolveSet</var>, and <var>exportStarSet</var> performs the
          following steps:</p>

          <ol class="proc">
            <li>Let <i>module</i> be this <a href="#sec-source-text-module-records">Source Text Module Record</a>.</li>
            <li>For each Record {[[module]], [[exportName]]} <i>r</i> in <i>resolveSet</i>, do:
              <ol class="block">
                <li>If <i>module</i> and <i>r</i>.[[module]] are the same <a href="#sec-abstract-module-records">Module Record</a>
                    and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>exportName</i>, <i>r</i>.[[exportName]]) is <b>true</b>, then
                  <ol class="block">
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: this is a circular import request.</li>
                    <li>Return <b>null</b>.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Append the Record {[[module]]: <i>module</i>, [[exportName]]: <i>exportName</i>} to <i>resolveSet</i>.</li>
            <li>For each ExportEntry Record <i>e</i> in <i>module</i>.[[LocalExportEntries]], do
              <ol class="block">
                <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>exportName</i>, <i>e</i>.[[ExportName]]) is <b>true</b>, then
                  <ol class="block">
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>module</i> provides the direct binding for this
                        export.</li>
                    <li>Return Record{[[module]]: <i>module,</i> [[bindingName]]: <i>e</i>.[[LocalName]]}.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>For each ExportEntry Record <i>e</i> in <i>module</i>.[[IndirectExportEntries]], do
              <ol class="block">
                <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>exportName</i>, <i>e</i>.[[ExportName]]) is <b>true</b>, then
                  <ol class="block">
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>module</i> imports a specific binding for this
                        export.</li>
                    <li>Let <i>importedModule</i> be <a href="#sec-hostresolveimportedmodule">HostResolveImportedModule</a>(<i>module</i>,
                        <i>e</i>.[[ModuleRequest]]).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>importedModule</i>).</li>
                    <li>Let <i>indirectResolution</i> be <i>importedModule.</i>ResolveExport(<i>e</i>.[[ImportName]],
                        <i>resolveSet</i>, <i>exportStarSet</i>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>indirectResolution</i>).</li>
                    <li>If <i>indirectResolution</i> is not <b>null</b>, return <i>indirectResolution</i>.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>exportName</i>, <code>"default"</code>) is <b>true</b>, then
              <ol class="block">
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: A <code>default</code> export was not explicitly defined by
                    this module.</li>
                <li>Throw a <b>SyntaxError</b> exception.</li>
                <li>NOTE  A <code>default</code> export cannot be provided by an <code>export *</code>.</li>
              </ol>
            </li>
            <li>If <i>exportStarSet</i> contains <i>module</i>, then return <b>null</b>.</li>
            <li>Append <i>module</i> to <i>exportStarSet</i>.</li>
            <li>Let <i>starResolution</i> be <b>null</b>.</li>
            <li>For each ExportEntry Record <i>e</i> in <i>module</i>.[[StarExportEntries]], do
              <ol class="block">
                <li>Let <i>importedModule</i> be <a href="#sec-hostresolveimportedmodule">HostResolveImportedModule</a>(<i>module</i>,
                    <i>e</i>.[[ModuleRequest]]).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>importedModule</i>).</li>
                <li>Let <i>resolution</i> be <i>importedModule</i>.ResolveExport(<i>exportName</i>, <i>resolveSet</i>,
                    <i>exportStarSet</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>resolution</i>).</li>
                <li>If <i>resolution</i> is <code>"ambiguous"</code>, return <code>"ambiguous"</code>.</li>
                <li>If <i>resolution</i> is not <b>null</b>, then
                  <ol class="block">
                    <li>If <i>starResolution</i> is <b>null</b>, let <i>starResolution</i> be <i>resolution</i>.</li>
                    <li>Else
                      <ol class="block">
                        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: there is more than one * import that includes the
                            requested name.</li>
                        <li>If <i>resolution</i>.[[module]] and <i>starResolution</i>.[[module]] are not the same <a href="#sec-abstract-module-records">Module Record</a> or <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>resolution.</i>[[exportName]],
                            <i>starResolution</i>.[[exportName]]) is <b>false</b>, return <code>"ambiguous"</code>.</li>
                      </ol>
                    </li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Return <i>starResolution</i>.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> ResolveExport attempts to resolve an imported binding to the actual defining module
            and local binding name. The defining module may be the module represented by the <a href="#sec-abstract-module-records">Module Record</a> this method was invoked on or some other module that is imported
            by that module. The parameter <var>resolveSet</var> is use to detect unresolved circular import/export paths. If a
            pair consisting of specific <a href="#sec-abstract-module-records">Module Record</a> and <var>exportName</var> is
            reached that is already in <span style="font-family: Times New Roman"><i>resolveSet</i>, an</span> import circularity
            has been encountered. Before recursively calling ResolveExport, a pair consisting of <var>module</var> and
            <var>exportName</var> is added to <span style="font-family: Times New Roman"><i>resolveSet</i>.</span></p>

            <p>If a defining module is found a Record {[[module]]<i>,</i> [[bindingName]]} is returned. This record identifies the
            resolved binding of the originally requested export. If no definition was found or the request is found to be
            circular, <span class="value">null</span> is returned. If the request is found to be ambiguous, the string
            <code>"ambiguous"</code> is returned.</p>
          </div>
        </section>

        <section id="sec-moduledeclarationinstantiation">
          <h5 id="sec-15.2.1.16.4" title="15.2.1.16.4"> ModuleDeclarationInstantiation( ) Concrete Method</h5><p class="normalbefore">The ModuleDeclarationInstantiation concrete method of a <a href="#sec-source-text-module-records">Source Text Module Record</a> performs the following steps:</p>

          <ol class="proc">
            <li>Let <i>module</i> be this <a href="#sec-source-text-module-records">Source Text Module Record</a>.</li>
            <li>Let <i>realm</i> be <i>module</i>.[[Realm]].</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>realm</i> is not <b>undefined</b>.</li>
            <li>Let <i>code</i> be <i>module</i>.[[ECMAScriptCode]].</li>
            <li>If <i>module</i>.[[Environment]] is not <b>undefined</b>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
            <li>Let <i>env</i> be <a href="sec-executable-code-and-execution-contexts#sec-newmoduleenvironment">NewModuleEnvironment</a>(<i>realm</i>.[[globalEnv]]).</li>
            <li>Set <i>module</i>.[[Environment]] to <i>env</i>.</li>
            <li>For each String <i>required</i> that is an element of <i>module</i>.[[RequestedModules]] do,
              <ol class="block">
                <li>NOTE:  Before instantiating a module, all of the modules it requested must be available. An implementation may
                    perform this test at any time prior to this point,</li>
                <li>Let <i>requiredModule</i> be <a href="#sec-hostresolveimportedmodule">HostResolveImportedModule</a>(<i>module</i>, <i>required</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>requiredModule</i>).</li>
                <li>Let <i>status</i> be <i>requiredModule</i>.ModuleDeclarationInstantiation().</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
              </ol>
            </li>
            <li>For each ExportEntry Record <i>e</i> in <i>module</i>.[[IndirectExportEntries]], do
              <ol class="block">
                <li>Let <i>resolution</i> be <i>module</i>.<a href="#sec-resolveexport">ResolveExport</a>(<i>e</i>.[[ExportName]],
                    &laquo;&zwj; &raquo;, &laquo;&zwj; &raquo;).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>resolution</i>).</li>
                <li>If <i>resolution</i> is <b>null</b> or <i>resolution</i> is <code>"ambiguous"</code>, throw a
                    <b>SyntaxError</b> exception.</li>
              </ol>
            </li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: all named exports from <i>module</i> are resolvable.</li>
            <li>Let <i>envRec</i> be <i>env</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
            <li>For each ImportEntry Record <i>in</i> in <i>module</i>.[[ImportEntries]], do
              <ol class="block">
                <li>Let <i>importedModule</i> be <a href="#sec-hostresolveimportedmodule">HostResolveImportedModule</a>(<i>module</i>,
                    <i>in</i>.[[ModuleRequest]]).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>importedModule</i>).</li>
                <li>If <i>in</i>.[[ImportName]] is <code>"*"</code>, then
                  <ol class="block">
                    <li>Let <i>namespace</i> be <a href="#sec-getmodulenamespace">GetModuleNamespace</a>(<i>importedModule</i>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>module</i>).</li>
                    <li>Let <i>status</i> be <i>envRec</i>.CreateImmutableBinding(<i>in</i>.[[LocalName]], <b>true</b>).</li>
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                    <li><a href="sec-abstract-operations#sec-call">Call</a> <i>envRec</i>.InitializeBinding(<i>in</i>.[[LocalName]],
                        <i>namespace</i>).</li>
                  </ol>
                </li>
                <li>else,
                  <ol class="block">
                    <li>Let <i>resolution</i> be <i>importedModule</i>.<a href="#sec-resolveexport">ResolveExport</a>(<i>in</i>.[[ImportName]], &laquo;&nbsp;&raquo;, &laquo;&zwj;
                        &raquo;).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>resolution</i>).</li>
                    <li>If <i>resolution</i> is <b>null</b> or <i>resolution</i> is <code>"ambiguous"</code>, throw a
                        <b>SyntaxError</b> exception.</li>
                    <li><a href="sec-abstract-operations#sec-call">Call</a> <i>envRec</i>.<a href="sec-executable-code-and-execution-contexts#sec-createimportbinding">CreateImportBinding</a>(<i>in</i>.[[LocalName]],
                        <i>resolution</i>.[[module]], <i>resolution</i>.[[bindingName]]).</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Let <i>varDeclarations</i> be the VarScopedDeclarations of <i>code</i>.</li>
            <li>For each element <i>d</i> in <i>varDeclarations</i> do
              <ol class="block">
                <li>For each element <i>dn</i> of the BoundNames of <i>d</i> do
                  <ol class="block">
                    <li>Let <i>status</i> be <i>envRec</i>.CreateMutableBinding(<i>dn</i>, <b>false</b>).</li>
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                    <li><a href="sec-abstract-operations#sec-call">Call</a> <i>envRec</i>.InitializeBinding(<i>dn</i>, <b>undefined</b>).</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Let <i>lexDeclarations</i> be the LexicallyScopedDeclarations of <i>code</i>.</li>
            <li>For each element <i>d</i> in <i>lexDeclarations</i> do
              <ol class="block">
                <li>For each element <i>dn</i> of the BoundNames of <i>d</i> do
                  <ol class="block">
                    <li>If  IsConstantDeclaration of <i>d</i> is <b>true</b>, then
                      <ol class="block">
                        <li>Let <i>status</i> be <i>envRec</i>.CreateImmutableBinding(<i>dn</i>, <b>true</b>).</li>
                      </ol>
                    </li>
                    <li>Else,
                      <ol class="block">
                        <li>Let <i>status</i> be <i>envRec</i>.CreateMutableBinding(<i>dn</i>, <b>false</b>).</li>
                      </ol>
                    </li>
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                    <li>If <i>d</i> is a <i>GeneratorDeclaration</i> production or a <i>FunctionDeclaration</i> production, then
                      <ol class="block">
                        <li>Let <i>fo</i> be the result of performing  InstantiateFunctionObject  for <i>d</i> with argument
                            <i>env</i>.</li>
                        <li><a href="sec-abstract-operations#sec-call">Call</a> <i>envRec</i>.InitializeBinding(<i>dn</i>, <i>fo</i>).</li>
                      </ol>
                    </li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>
        </section>

        <section id="sec-moduleevaluation">
          <h5 id="sec-15.2.1.16.5" title="15.2.1.16.5"> ModuleEvaluation() Concrete Method</h5><p class="normalbefore">The ModuleEvaluation concrete method of a <a href="#sec-source-text-module-records">Source Text
          Module Record</a> performs the following steps:</p>

          <ol class="proc">
            <li>Let <i>module</i> be this <a href="#sec-source-text-module-records">Source Text Module Record</a>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="#sec-moduledeclarationinstantiation">ModuleDeclarationInstantiation</a> has already been invoked on
                <i>module</i> and successfully completed.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>module</i>.[[Realm]] is not <b>undefined</b>.</li>
            <li>If <i>module.</i>[[Evaluated]] is <b>true</b>, return <b>undefined</b>.</li>
            <li>Set <i>module.</i>[[Evaluated]] to <b>true</b>.</li>
            <li>For each String <i>required</i> that is an element of <i>module</i>.[[RequestedModules]] do,
              <ol class="block">
                <li>Let <i>requiredModule</i> be <a href="#sec-hostresolveimportedmodule">HostResolveImportedModule</a>(<i>module</i>, <i>required</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>requiredModule</i>).</li>
                <li>Let <i>status</i> be <i>requiredModule.</i>ModuleEvaluation().</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
              </ol>
            </li>
            <li>Let <i>moduleCxt</i> be a new <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">ECMAScript code execution context</a>.</li>
            <li>Set the Function of <i>moduleCxt</i> to <b>null</b>.</li>
            <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> of <i>moduleCxt</i> to <i>module</i>.[[Realm]].</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>module</i> has been linked and declarations in its module
                environment have been instantiated.</li>
            <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> of <i>moduleCxt</i> to
                <i>module</i>.[[Environment]].</li>
            <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <i>moduleCxt</i> to
                <i>module</i>.[[Environment]].</li>
            <li><a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the currently running execution
                context</a>.</li>
            <li>Push <i>moduleCxt</i> on to <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>; <i>moduleCxt</i> is
                now <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
            <li>Let <i>result</i> be the result of evaluating <i>module</i>.[[ECMAScriptCode]].</li>
            <li><a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <i>moduleCxt</i> and remove it from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>.</li>
            <li>Resume the context that is now on the top of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> as
                <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>result</i>).</li>
          </ol>
        </section>
      </section>

      <section id="sec-hostresolveimportedmodule">
        <h4 id="sec-15.2.1.17" title="15.2.1.17"> Runtime Semantics: HostResolveImportedModule (referencingModule,
            specifier )</h4><p class="normalbefore">HostResolveImportedModule is an implementation defined abstract operation that provides the
        concrete <a href="#sec-abstract-module-records">Module Record</a> subclass instance that corresponds to the <span class="nt">ModuleSpecifier</span> <var>String, specifier, occurring within the context of the module represented by the <a href="#sec-abstract-module-records">Module Record</a> referencingModule.</var></p>

        <p class="normalbefore">The implementation of HostResolveImportedModule must conform to the following requirements:</p>

        <ul>
          <li>
            <p>The normal return value must be an instance of a concrete subclass of <a href="#sec-abstract-module-records">Module
            Record</a>.</p>
          </li>

          <li>
            <p>If a <a href="#sec-abstract-module-records">Module Record</a> corresponding to the pair <var>referencingModule,
            specifier</var> does not exist or cannot be created, an exception must be thrown.</p>
          </li>

          <li>
            <p>This operation must be idempotent if it completes normally. Each time it is called with a specific
            <var>referencingModule, specifier</var> pair as arguments it must return the same <a href="#sec-abstract-module-records">Module Record</a> instance.</p>
          </li>
        </ul>

        <p class="normalbefore">Multiple different <var>referencingModule, specifier</var> pairs may map to the same <a href="#sec-abstract-module-records">Module Record</a> instance. The actual mapping semantic is implementation defined but
        typically a normalization process is applied to <var>specifier</var> as part of the mapping process. A typical
        normalization process would include actions such as alphabetic case folding and expansion of relative and abbreviated path
        specifiers.</p>
      </section>

      <section id="sec-getmodulenamespace">
        <h4 id="sec-15.2.1.18" title="15.2.1.18"> Runtime Semantics: GetModuleNamespace( module )</h4><p>The abstract operation GetModuleNamespace called with argument <var>module</var> performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>module</i> is an instance of a concrete subclass of <a href="#sec-abstract-module-records">Module Record</a>.</li>
          <li>Let <i>namespace</i> be <i>module</i>.[[Namespace]].</li>
          <li>If <i>namespace</i> is <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>exportedNames</i> be <i>module</i>.<a href="#sec-getexportednames">GetExportedNames</a>(&laquo;
                  &raquo;).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exportedNames</i>).</li>
              <li>Let <i>unambiguousNames</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
              <li>For each <i>name</i> that is an element of <i>exportedNames</i>,
                <ol class="block">
                  <li>Let <i>resolution</i> be <i>module</i>.<a href="#sec-resolveexport">ResolveExport</a>(<i>name</i>, &laquo;
                      &raquo;, &laquo; &raquo;).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>resolution</i>).</li>
                  <li>If <i>resolution</i> is <b>null</b>, throw a <b>SyntaxError</b> exception.</li>
                  <li>If <i>resolution</i> is not <code>"ambiguous"</code>, append <i>name</i> to <i>unambiguousNames</i>.</li>
                </ol>
              </li>
              <li>Let <i>namespace</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-modulenamespacecreate">ModuleNamespaceCreate</a>(<i>module</i>,
                  <i>unambiguousNames</i>).</li>
            </ol>
          </li>
          <li>Return <i>namespace</i>.</li>
        </ol>
      </section>

      <section id="sec-toplevelmoduleevaluationjob">
        <h4 id="sec-15.2.1.19" title="15.2.1.19"> Runtime Semantics: TopLevelModuleEvaluationJob ( sourceText)</h4><p class="normalbefore">A TopLevelModuleEvaluationJob with parameter <var>sourceText</var> is a job that parses,
        validates, and evaluates <var>sourceText</var> as a <span class="nt">Module</span>.</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>sourceText</i> is an ECMAScript source text (see <a href="sec-ecmascript-language-source-code">clause 10</a>).</li>
          <li>Let <i>realm</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>.</li>
          <li>Let <i>m</i> be <a href="#sec-parsemodule">ParseModule</a>(<i>sourceText</i>).</li>
          <li>If <i>m</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> or any other
              implementation defined error indication, then
            <ol class="block">
              <li>Report or log the error(s) in an implementation dependent manner.</li>
              <li>NextJob <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
            </ol>
          </li>
          <li>Set <i>m</i>.[[Realm]] to <i>realm</i>.</li>
          <li>Let <i>status</i> be <i>m</i>.<a href="#sec-moduledeclarationinstantiation">ModuleDeclarationInstantiation</a>().</li>
          <li>If <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
            <ol class="block">
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: all dependencies of <i>m</i> have been transitively resolved
                  and <i>m</i> is ready for evaluation.</li>
              <li>Let <i>status</i> be <i>m</i>.<a href="#sec-moduleevaluation">ModuleEvaluation</a>().</li>
            </ol>
          </li>
          <li>NextJob <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> An implementation may parse a <var>sourceText</var> as a <var>Module,</var> analyze it
          for Early Error conditions, and instantiate it prior to the execution of the TopLevelModuleEvaluationJob for that
          <var>sourceText</var>. An implementation may also resolve, pre-parse and pre-analyze, and pre-instantiate module
          dependencies of <span style="font-family: Times New Roman"><i>sourceText</i>.</span> However, the reporting of any
          errors detected by these actions must be deferred until the TopLevelModuleEvaluationJob is actually executed.</p>
        </div>
      </section>

      <section id="sec-module-semantics-runtime-semantics-evaluation">
        <h4 id="sec-15.2.1.20" title="15.2.1.20"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">Module</span> <span class="geq">:</span> <span class="grhsannot">[empty]</span></div>
        <ol class="proc">
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleBody</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span></div>
        <ol class="proc">
          <li>Let <i>result</i> be the result of evaluating <i>ModuleItemList</i>.</li>
          <li>If <i>result</i>.[[type]] is <span style="font-family: sans-serif">normal</span> and <i>result</i>.[[value]] is
              <span style="font-family: sans-serif">empty</span>, then
            <ol class="block">
              <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>result</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleItemList</span> <span class="geq">:</span> <span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
        <ol class="proc">
          <li>Let <i>sl</i> be the result of evaluating <i>ModuleItemList</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>sl</i>).</li>
          <li>Let <i>s</i> be the result of evaluating <i>ModuleItem</i>.</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>s</i>, <i>sl</i>.[[value]])).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The value of a <span class="nt">ModuleItemList</span> is the value of the last value
          producing item in the <span class="nt">ModuleItemList</span>.</p>
        </div>

        <div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">ImportDeclaration</span></div>
        <ol class="proc">
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>
      </section>
    </section>

    <section id="sec-imports">
      <div class="front">
        <h3 id="sec-15.2.2" title="15.2.2">
            Imports</h3><h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">ImportDeclaration</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">import</code> <span class="nt">ImportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">import</code> <span class="nt">ModuleSpecifier</span> <code class="t">;</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ImportClause</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ImportedDefaultBinding</span></div>
          <div class="rhs"><span class="nt">NameSpaceImport</span></div>
          <div class="rhs"><span class="nt">NamedImports</span></div>
          <div class="rhs"><span class="nt">ImportedDefaultBinding</span> <code class="t">,</code> <span class="nt">NameSpaceImport</span></div>
          <div class="rhs"><span class="nt">ImportedDefaultBinding</span> <code class="t">,</code> <span class="nt">NamedImports</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ImportedDefaultBinding</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ImportedBinding</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NameSpaceImport</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">*</code> <code class="t">as</code> <span class="nt">ImportedBinding</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NamedImports</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">{</code> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">ImportsList</span> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">ImportsList</span> <code class="t">,</code> <code class="t">}</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">FromClause</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">from</code> <span class="nt">ModuleSpecifier</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ImportsList</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ImportSpecifier</span></div>
          <div class="rhs"><span class="nt">ImportsList</span> <code class="t">,</code> <span class="nt">ImportSpecifier</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ImportSpecifier</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ImportedBinding</span></div>
          <div class="rhs"><span class="nt">IdentifierName</span> <code class="t">as</code> <span class="nt">ImportedBinding</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ModuleSpecifier</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">StringLiteral</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ImportedBinding</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">BindingIdentifier</span></div>
        </div>
      </div>

      <section id="sec-imports-static-semantics-early-errors">
        <h4 id="sec-15.2.2.1" title="15.2.2.1"> Static Semantics: Early Errors</h4><div class="gp prod"><span class="nt">ModuleItem</span> <span class="geq">:</span> <span class="nt">ImportDeclaration</span></div>
        <ul>
          <li>
            <p>It is a Syntax Error if the BoundNames of <span class="nt">ImportDeclaration</span> contains any duplicate
            entries.</p>
          </li>
        </ul>
      </section>

      <section id="sec-imports-static-semantics-boundnames">
        <h4 id="sec-15.2.2.2" title="15.2.2.2"> Static Semantics: BoundNames</h4><p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-boundnames">12.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-boundnames">13.3.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-boundnames">13.3.2.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-boundnames">13.3.3.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-boundnames">13.7.5.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-boundnames">14.1.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-boundnames">14.2.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-boundnames">14.4.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-boundnames">14.5.2</a>, <a href="#sec-exports-static-semantics-boundnames">15.2.3.2</a>.</p>

        <div class="gp prod"><span class="nt">ImportDeclaration</span> <span class="geq">:</span> <code class="t">import</code> <span class="nt">ImportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>ImportClause</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ImportDeclaration</span> <span class="geq">:</span> <code class="t">import</code> <span class="nt">ModuleSpecifier</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ImportClause</span> <span class="geq">:</span> <span class="nt">ImportedDefaultBinding</span> <code class="t">,</code> <span class="nt">NameSpaceImport</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be the BoundNames of <i>ImportedDefaultBinding</i>.</li>
          <li>Append to <i>names</i> the elements of the BoundNames of <i>NameSpaceImport</i>.</li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ImportClause</span> <span class="geq">:</span> <span class="nt">ImportedDefaultBinding</span> <code class="t">,</code> <span class="nt">NamedImports</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be the BoundNames of <i>ImportedDefaultBinding</i>.</li>
          <li>Append to <i>names</i> the elements of the BoundNames of <i>NamedImports</i>.</li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">NamedImports</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ImportsList</span> <span class="geq">:</span> <span class="nt">ImportsList</span> <code class="t">,</code> <span class="nt">ImportSpecifier</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be the BoundNames of <i>ImportsList</i>.</li>
          <li>Append to <i>names</i> the elements of the BoundNames of <i>ImportSpecifier</i>.</li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ImportSpecifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span> <code class="t">as</code> <span class="nt">ImportedBinding</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>ImportedBinding</i>.</li>
        </ol>
      </section>

      <section id="sec-imports-static-semantics-importentries">
        <h4 id="sec-15.2.2.3" title="15.2.2.3"> Static Semantics: ImportEntries</h4><p>See also: <a href="#sec-module-semantics-static-semantics-importentries">15.2.1.8</a>.</p>

        <div class="gp prod"><span class="nt">ImportDeclaration</span> <span class="geq">:</span> <code class="t">import</code> <span class="nt">ImportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Let <i>module</i> be the sole element of ModuleRequests of <i>FromClause</i>.</li>
          <li>Return ImportEntriesForModule of <i>ImportClause</i> with argument <i>module</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ImportDeclaration</span> <span class="geq">:</span> <code class="t">import</code> <span class="nt">ModuleSpecifier</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
      </section>

      <section id="sec-static-semantics-importentriesformodule">
        <h4 id="sec-15.2.2.4" title="15.2.2.4"> Static Semantics: ImportEntriesForModule</h4><p>With parameter <var>module</var>.</p>

        <div class="gp prod"><span class="nt">ImportClause</span> <span class="geq">:</span> <span class="nt">ImportedDefaultBinding</span> <code class="t">,</code> <span class="nt">NameSpaceImport</span></div>
        <ol class="proc">
          <li>Let <i>entries</i> be ImportEntriesForModule of <i>ImportedDefaultBinding</i> with argument <i>module</i>.</li>
          <li>Append to <i>entries</i> the elements of the ImportEntriesForModule of <i>NameSpaceImport</i> with argument
              <i>module</i>.</li>
          <li>Return <i>entries</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ImportClause</span> <span class="geq">:</span> <span class="nt">ImportedDefaultBinding</span> <code class="t">,</code> <span class="nt">NamedImports</span></div>
        <ol class="proc">
          <li>Let <i>entries</i> be ImportEntriesForModule of <i>ImportedDefaultBinding</i> with argument <i>module</i>.</li>
          <li>Append to <i>entries</i> the elements of the ImportEntriesForModule of <i>NamedImports</i> with argument
              <i>module</i>.</li>
          <li>Return <i>entries</i>.</li>
        </ol>

        <p><span class="prod"><span class="nt">ImportedDefaultBinding</span> <span class="geq">:</span> <span class="nt">ImportedBinding</span></span></p>

        <ol class="proc">
          <li>Let <i>localName</i> be the sole element of BoundNames of <i>ImportedBinding</i>.</li>
          <li>Let <i>defaultEntry</i> be the Record {[[ModuleRequest]]: <i>module</i>, [[ImportName]]: <code>"default"</code>,
              [[LocalName]]: <i>localName</i> }.</li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>defaultEntry.</i></li>
        </ol>
        <div class="gp prod"><span class="nt">NameSpaceImport</span> <span class="geq">:</span> <code class="t">*</code> <code class="t">as</code> <span class="nt">ImportedBinding</span></div>
        <ol class="proc">
          <li>Let <i>localName</i> be the StringValue of <i>ImportedBinding</i>.</li>
          <li>Let <i>entry</i> be the Record {[[ModuleRequest]]: <i>module</i>, [[ImportName]]: <code>"*"</code>, [[LocalName]]:
              <i>localName</i> }.</li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>entry</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">NamedImports</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ImportsList</span> <span class="geq">:</span> <span class="nt">ImportsList</span> <code class="t">,</code> <span class="nt">ImportSpecifier</span></div>
        <ol class="proc">
          <li>Let <i>specs</i> be the ImportEntriesForModule of <i>ImportsList</i> with argument <i>module</i>.</li>
          <li>Append to <i>specs</i> the elements of the ImportEntriesForModule of <i>ImportSpecifier</i> with argument
              <i>module</i>.</li>
          <li>Return <i>specs</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ImportSpecifier</span> <span class="geq">:</span> <span class="nt">ImportedBinding</span></div>
        <ol class="proc">
          <li>Let <i>localName</i> be the sole element of BoundNames of <i>ImportedBinding</i>.</li>
          <li>Let <i>entry</i> be the Record {[[ModuleRequest]]: <i>module</i>, [[ImportName]]: <i>localName</i> , [[LocalName]]:
              <i>localName</i> }.</li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>entry</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ImportSpecifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span> <code class="t">as</code> <span class="nt">ImportedBinding</span></div>
        <ol class="proc">
          <li>Let <i>importName</i> be the StringValue of <i>IdentifierName</i>.</li>
          <li>Let <i>localName</i> be the StringValue of <i>ImportedBinding</i>.</li>
          <li>Let <i>entry</i> be the Record {[[ModuleRequest]]: <i>module</i>, [[ImportName]]: <i>importName</i>, [[LocalName]]:
              <i>localName</i> }.</li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>entry</i>.</li>
        </ol>
      </section>

      <section id="sec-imports-static-semantics-modulerequests">
        <h4 id="sec-15.2.2.5" title="15.2.2.5"> Static Semantics: ModuleRequests</h4><p>See also: <a href="#sec-module-semantics-static-semantics-modulerequests">15.2.1.10</a>,<a href="#sec-exports-static-semantics-modulerequests">15.2.3.9</a>.</p>

        <div class="gp prod"><span class="nt">ImportDeclaration</span> <span class="geq">:</span> <code class="t">import</code> <span class="nt">ImportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return ModuleRequests of <i>FromClause</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ModuleSpecifier</span> <span class="geq">:</span> <span class="nt">StringLiteral</span></div>
        <ol class="proc">
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the StringValue of
              <i>StringLiteral</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-exports">
      <div class="front">
        <h3 id="sec-15.2.3" title="15.2.3">
            Exports</h3><h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">export</code> <code class="t">*</code> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">VariableStatement</span></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">Declaration</span></div>
          <div class="rhs"><code class="t">export</code> <code class="t">default</code> <span class="nt">HoistableDeclaration</span><sub class="g-params">[Default]</sub></div>
          <div class="rhs"><code class="t">export</code> <code class="t">default</code> <span class="nt">ClassDeclaration</span><sub class="g-params">[Default]</sub></div>
          <div class="rhs"><code class="t">export</code> <code class="t">default</code> <span class="grhsannot">[lookahead &notin; {<code class="t">function</code>, <code class="t">class</code>}]</span> <span class="nt">AssignmentExpression</span><sub class="g-params">[In]</sub> <code class="t">;</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ExportClause</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">{</code> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">ExportsList</span> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">ExportsList</span> <code class="t">,</code> <code class="t">}</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ExportsList</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ExportSpecifier</span></div>
          <div class="rhs"><span class="nt">ExportsList</span> <code class="t">,</code> <span class="nt">ExportSpecifier</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ExportSpecifier</span> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">IdentifierName</span></div>
          <div class="rhs"><span class="nt">IdentifierName</span> <code class="t">as</code> <span class="nt">IdentifierName</span></div>
        </div>
      </div>

      <section id="sec-exports-static-semantics-early-errors">
        <h4 id="sec-15.2.3.1" title="15.2.3.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">ExportClause</span> <code class="t">;</code></div>
        <ul>
          <li>
            <p>For each <span class="nt">IdentifierName</span> <var>n</var> in ReferencedBindings of <span class="prod"><span class="nt">ExportClause</span> <span class="geq">:</span> <span class="nt">It</span> <code class="t">is</code> <code class="t">a</code> <span class="nt">Syntax</span> <span class="nt">Error</span> <code class="t">if</code> <span class="nt">StringValue</span> <code class="t">of</code></span> <var>n</var> is a <span class="nt">ReservedWord</span>
            or if the StringValue of <var>n</var> is one of: <code>"implements"</code>, <code>"interface"</code>,
            <code>"let"</code>, <code>"package"</code>, <code>"private"</code>, <code>"protected"</code>, <code>"public"</code>,
            <code>"static"</code>, or <code>"yield"</code>.</p>
          </li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> The above rule means that each ReferencedBindings of <span class="nt">ExportClause</span> is treated as an <span class="nt">IdentifierReference</span>.</p>
        </div>
      </section>

      <section id="sec-exports-static-semantics-boundnames">
        <h4 id="sec-15.2.3.2" title="15.2.3.2"> Static Semantics: BoundNames</h4><p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-boundnames">12.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-boundnames">13.3.1.2</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement-static-semantics-boundnames">13.3.2.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns-static-semantics-boundnames">13.3.3.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-boundnames">13.7.5.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-boundnames">14.1.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-boundnames">14.2.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-boundnames">14.4.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-boundnames">14.5.2</a>, <a href="#sec-imports-static-semantics-boundnames">15.2.2.2</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">export</code> <code class="t">*</code> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <code class="t">;</code></div>
        </div>

        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">VariableStatement</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>VariableStatement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">Declaration</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>Declaration</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">HoistableDeclaration</span></div>
        <ol class="proc">
          <li>Let <i>declarationNames</i> be the BoundNames of <i>HoistableDeclaration</i>.</li>
          <li>If <i>declarationNames</i> does not include the element <code>"*default*"</code>, append <code>"*default*"</code> to
              <i>declarationNames</i>.</li>
          <li>Return <i>declarationNames</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">ClassDeclaration</span></div>
        <ol class="proc">
          <li>Let <i>declarationNames</i> be the BoundNames of <i>ClassDeclaration</i>.</li>
          <li>If <i>declarationNames</i> does not include the element <code>"*default*"</code>, append <code>"*default*"</code> to
              <i>declarationNames</i>.</li>
          <li>Return <i>declarationNames</i>.</li>
        </ol>

        <p><span style="font-family: Times New Roman"><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></span></span> <code>export default</code> <span class="nt">AssignmentExpression</span>
        <code>;</code></p>

        <ol class="proc">
          <li>Return &laquo;<code>"*default*"</code>&raquo;.</li>
        </ol>
      </section>

      <section id="sec-exports-static-semantics-exportedbindings">
        <h4 id="sec-15.2.3.3" title="15.2.3.3"> Static Semantics:  ExportedBindings</h4><p>See also: <a href="#sec-module-semantics-static-semantics-exportedbindings">15.2.1.5</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <code class="t">*</code> <span class="nt">FromClause</span> <code class="t">;</code></div>
        </div>

        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">ExportClause</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return the ExportedBindings of <i>ExportClause</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">VariableStatement</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>VariableStatement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">Declaration</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>Declaration</i>.</li>
        </ol>

        <p><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code>
        <code class="t">default</code> <span class="nt">HoistableDeclaration</span></span> <sub><br /></sub><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">ClassDeclaration</span></span><br /><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">AssignmentExpression</span> <code class="t">;</code></span></p>

        <ol class="proc">
          <li>Return the BoundNames of this <i>ExportDeclaration</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportClause</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportsList</span> <span class="geq">:</span> <span class="nt">ExportsList</span> <code class="t">,</code> <span class="nt">ExportSpecifier</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be the ExportedBindings of <i>ExportsList</i>.</li>
          <li>Append to <i>names</i> the elements of the ExportedBindings of <i>ExportSpecifier</i>.</li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportSpecifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the StringValue of
              <i>IdentifierName</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportSpecifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span> <code class="t">as</code> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the StringValue of the first
              <i>IdentifierName</i>.</li>
        </ol>
      </section>

      <section id="sec-exports-static-semantics-exportednames">
        <h4 id="sec-15.2.3.4" title="15.2.3.4"> Static Semantics:  ExportedNames</h4><p>See also: <a href="#sec-module-semantics-static-semantics-exportednames">15.2.1.6</a>.</p>

        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">*</code> <span class="nt">FromClause</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <code class="t">;</code></div>
        </div>

        <ol class="proc">
          <li>Return the ExportedNames of <i>ExportClause</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">VariableStatement</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>VariableStatement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">Declaration</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>Declaration</i>.</li>
        </ol>

        <p><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code>
        <code class="t">default</code> <span class="nt">HoistableDeclaration</span></span> <sub><br /></sub><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">ClassDeclaration</span></span><br /><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">AssignmentExpression</span> <code class="t">;</code></span></p>

        <ol class="proc">
          <li>Return &laquo;<code>"default"</code>&raquo;.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportClause</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportsList</span> <span class="geq">:</span> <span class="nt">ExportsList</span> <code class="t">,</code> <span class="nt">ExportSpecifier</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be the ExportedNames of <i>ExportsList</i>.</li>
          <li>Append to <i>names</i> the elements of the ExportedNames of <i>ExportSpecifier</i>.</li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportSpecifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the StringValue of
              <i>IdentifierName</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportSpecifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span> <code class="t">as</code> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the StringValue of the second
              <i>IdentifierName</i>.</li>
        </ol>
      </section>

      <section id="sec-exports-static-semantics-exportentries">
        <h4 id="sec-15.2.3.5" title="15.2.3.5"> Static Semantics:  ExportEntries</h4><p>See also: <a href="#sec-module-semantics-static-semantics-exportentries">15.2.1.7</a>.</p>

        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">*</code> <span class="nt">FromClause</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Let <i>module</i> be the sole element of ModuleRequests of <i>FromClause</i>.</li>
          <li>Let <i>entry</i> be the Record {[[ModuleRequest]]: <i>module</i>, [[ImportName]]: <code>"*"</code>, [[LocalName]]:
              <b>null</b>, [[ExportName]]: <b>null</b> }.</li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>entry</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">ExportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Let <i>module</i> be the sole element of ModuleRequests of <i>FromClause</i>.</li>
          <li>Return ExportEntriesForModule of <i>ExportClause</i> with argument <i>module</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">ExportClause</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return ExportEntriesForModule of <i>ExportClause</i> with argument <b>null</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">VariableStatement</span></div>
        <ol class="proc">
          <li>Let <i>entries</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>names</i> be the BoundNames of <i>VariableStatement</i>.</li>
          <li>Repeat for each <i>name</i> in <i>names,</i>
            <ol class="block">
              <li>Append to <i>entries</i> the Record {[[ModuleRequest]]: <b>null</b>, [[ImportName]]: <b>null</b>, [[LocalName]]:
                  <i>name</i>, [[ExportName]]: <i>name</i> }.</li>
            </ol>
          </li>
          <li>Return <i>entries</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">Declaration</span></div>
        <ol class="proc">
          <li>Let <i>entries</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>names</i> be the BoundNames of <i>Declaration</i>.</li>
          <li>Repeat for each <i>name</i> in <i>names,</i>
            <ol class="block">
              <li>Append to <i>entries</i> the Record {[[ModuleRequest]]: <b>null</b>, [[ImportName]]: <b>null</b>, [[LocalName]]:
                  <i>name</i>, [[ExportName]]: <i>name</i> }.</li>
            </ol>
          </li>
          <li>Return <i>entries</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">HoistableDeclaration</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be BoundNames of <i>HoistableDeclaration</i>.</li>
          <li>Let <i>localName</i> be the sole element of <i>names</i>.</li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the Record {[[ModuleRequest]]:
              <b>null</b>, [[ImportName]]: <b>null</b>, [[LocalName]]: <i>localName</i>, [[ExportName]]:
              <code>"default"</code>}.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">ClassDeclaration</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be BoundNames of <i>ClassDeclaration</i>.</li>
          <li>Let <i>localName</i> be the sole element of <i>names</i>.</li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the Record {[[ModuleRequest]]:
              <b>null</b>, [[ImportName]]: <b>null</b>, [[LocalName]]: <i>localName</i>, [[ExportName]]:
              <code>"default"</code>}.</li>
        </ol>

        <p><span style="font-family: Times New Roman"><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></span></span> <code>export default</code> <span class="nt">AssignmentExpression</span><code>;</code></p>

        <ol class="proc">
          <li>Let <i>entry</i> be the Record {[[ModuleRequest]]: <b>null</b>, [[ImportName]]: <b>null</b>, [[LocalName]]:
              <code>"*default*"</code>, [[ExportName]]: <code>"default"</code>}.</li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>entry</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> <code>"*default*"</code> is used within this specification as a synthetic name for
          anonymous default export values.</p>
        </div>
      </section>

      <section id="sec-static-semantics-exportentriesformodule">
        <h4 id="sec-15.2.3.6" title="15.2.3.6"> Static Semantics: ExportEntriesForModule</h4><p>With parameter <var>module</var>.</p>

        <div class="gp prod"><span class="nt">ExportClause</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportsList</span> <span class="geq">:</span> <span class="nt">ExportsList</span> <code class="t">,</code> <span class="nt">ExportSpecifier</span></div>
        <ol class="proc">
          <li>Let <i>specs</i> be the ExportEntriesForModule of <i>ExportsList</i> with argument <i>module</i>.</li>
          <li>Append to <i>specs</i> the elements of the ExportEntriesForModule of <i>ExportSpecifier</i> with argument
              <i>module</i>.</li>
          <li>Return <i>specs</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportSpecifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Let <i>sourceName</i> be the StringValue of <i>IdentifierName</i>.</li>
          <li>If <i>module</i> is <b>null</b>, then
            <ol class="block">
              <li>Let <i>localName</i> be <i>sourceName</i>.</li>
              <li>Let <i>importName</i> be <b>null</b>.</li>
            </ol>
          </li>
          <li>Else
            <ol class="block">
              <li>Let <i>localName</i> be <b>null</b>.</li>
              <li>Let <i>importName</i> be <i>sourceName</i>.</li>
            </ol>
          </li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the Record {[[ModuleRequest]]:
              <i>module</i>, [[ImportName]]: <i>importName</i>, [[LocalName]]: <i>localName</i>, [[ExportName]]: <i>sourceName</i>
              }.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportSpecifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span> <code class="t">as</code> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Let <i>sourceName</i> be the StringValue of the first <i>IdentifierName</i>.</li>
          <li>Let <i>exportName</i> be the StringValue of the second <i>IdentifierName</i>.</li>
          <li>If <i>module</i> is <b>null</b>, then
            <ol class="block">
              <li>Let <i>localName</i> be <i>sourceName</i>.</li>
              <li>Let <i>importName</i> be <b>null</b>.</li>
            </ol>
          </li>
          <li>Else
            <ol class="block">
              <li>Let <i>localName</i> be <b>null</b>.</li>
              <li>Let <i>importName</i> be <i>sourceName</i>.</li>
            </ol>
          </li>
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the Record {[[ModuleRequest]]:
              <i>module</i>, [[ImportName]]: <i>importName</i>, [[LocalName]]: <i>localName</i>, [[ExportName]]: <i>exportName</i>
              }.</li>
        </ol>
      </section>

      <section id="sec-exports-static-semantics-isconstantdeclaration">
        <h4 id="sec-15.2.3.7" title="15.2.3.7"> Static Semantics:  IsConstantDeclaration</h4><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-isconstantdeclaration">13.3.1.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isconstantdeclaration">14.1.10</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isconstantdeclaration">14.4.8</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isconstantdeclaration">14.5.7</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">export</code> <code class="t">*</code> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <code class="t">default</code> <span class="nt">AssignmentExpression</span> <code class="t">;</code></div>
        </div>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> It is not necessary to treat <code>export</code> <code>default</code> <span class="nt">AssignmentExpression</span> as a constant declaration because there is no syntax that permits assignment to
          the internal bound name used to reference a module&rsquo;s default object.</p>
        </div>
      </section>

      <section id="sec-exports-static-semantics-lexicallyscopeddeclarations">
        <h4 id="sec-15.2.3.8" title="15.2.3.8"> Static Semantics:  LexicallyScopedDeclarations</h4><p>See also: <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-lexicallyscopeddeclarations">13.2.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement-static-semantics-lexicallyscopeddeclarations">13.12.6</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-lexicallyscopeddeclarations">13.13.7</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallyscopeddeclarations">14.1.14</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallyscopeddeclarations">14.2.11</a>, <a href="#sec-scripts-static-semantics-lexicallyscopeddeclarations">15.1.4</a>, <a href="#sec-module-semantics-static-semantics-lexicallyscopeddeclarations">15.2.1.12</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">export</code> <code class="t">*</code> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">VariableStatement</span></div>
        </div>

        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">Declaration</span></div>
        <ol class="proc">
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing DeclarationPart of
              <i>Declaration</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">HoistableDeclaration</span></div>
        <ol class="proc">
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing DeclarationPart of
              <i>HoistableDeclaration</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">ClassDeclaration</span></div>
        <ol class="proc">
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>ClassDeclaration</i>.</li>
        </ol>

        <p><span style="font-family: Times New Roman"><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></span></span> <code>export default</code> <span class="nt">AssignmentExpression</span>
        <code>;</code></p>

        <ol class="proc">
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing this
              <i>ExportDeclaration</i>.</li>
        </ol>
      </section>

      <section id="sec-exports-static-semantics-modulerequests">
        <h4 id="sec-15.2.3.9" title="15.2.3.9"> Static Semantics: ModuleRequests</h4><p>See also: <a href="#sec-module-semantics-static-semantics-modulerequests">15.2.1.10</a>, <a href="#sec-imports-static-semantics-modulerequests">15.2.2.5</a>.</p>

        <p><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code>
        <code class="t">*</code> <span class="nt">FromClause</span> <code class="t">;</code></span></p>

        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">ExportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return the ModuleRequests of <i>FromClause</i>.</li>
        </ol>

        <div class="gp">
          <div class="lhs"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">VariableStatement</span></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">Declaration</span></div>
          <div class="rhs"><code class="t">export</code> <code class="t">default</code> <span class="nt">HoistableDeclaration</span></div>
          <div class="rhs"><code class="t">export</code> <code class="t">default</code> <span class="nt">ClassDeclaration</span></div>
          <div class="rhs"><code class="t">export</code> <code class="t">default</code> <span class="nt">AssignmentExpression</span> <code class="t">;</code></div>
        </div>

        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
      </section>

      <section id="sec-static-semantics-referencedbindings">
        <h4 id="sec-15.2.3.10" title="15.2.3.10"> Static Semantics:  ReferencedBindings</h4><div class="gp prod"><span class="nt">ExportClause</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportsList</span> <span class="geq">:</span> <span class="nt">ExportsList</span> <code class="t">,</code> <span class="nt">ExportSpecifier</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be the ReferencedBindings of <i>ExportsList</i>.</li>
          <li>Append to <i>names</i> the elements of the ReferencedBindings of <i>ExportSpecifier</i>.</li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportSpecifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the <i>IdentifierName</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportSpecifier</span> <span class="geq">:</span> <span class="nt">IdentifierName</span> <code class="t">as</code> <span class="nt">IdentifierName</span></div>
        <ol class="proc">
          <li>Return a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the first <i>IdentifierName</i>.</li>
        </ol>
      </section>

      <section id="sec-exports-runtime-semantics-evaluation">
        <h4 id="sec-15.2.3.11" title="15.2.3.11"> Runtime Semantics: Evaluation</h4><div class="gp">
          <div class="lhs"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">export</code> <code class="t">*</code> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">export</code> <span class="nt">ExportClause</span> <code class="t">;</code></div>
        </div>

        <ol class="proc">
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">VariableStatement</span></div>
        <ol class="proc">
          <li>Return the result of evaluating <i>VariableStatement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <span class="nt">Declaration</span></div>
        <ol class="proc">
          <li>Return the result of evaluating <i>Declaration</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">HoistableDeclaration</span></div>
        <ol class="proc">
          <li>Return the result of evaluating <i>HoistableDeclaration</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> <code class="t">export</code> <code class="t">default</code> <span class="nt">ClassDeclaration</span></div>
        <ol class="proc">
          <li>Let <i>value</i> be the result of BindingClassDeclarationEvaluation of <i>ClassDeclaration</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
          <li>Let <i>className</i> be the sole element of BoundNames of <i>ClassDeclaration</i>.</li>
          <li>If <i>className</i> is <code>"*default*"</code>, then
            <ol class="block">
              <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>value</i>,
                  <code>"name"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
              <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>value</i>, <code>"default"</code>).</li>
              <li>Let <i>env</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
              <li>Let <i>status</i> be <a href="sec-ecmascript-language-expressions#sec-initializeboundname">InitializeBoundName</a>(<code>"*default*"</code>,
                  <i>value</i>, <i>env</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>

        <p><span style="font-family: Times New Roman"><span class="prod"><span class="nt">ExportDeclaration</span> <span class="geq">:</span></span></span> <code>export default</code> <span class="nt">AssignmentExpression</span>
        <code>;</code></p>

        <ol class="proc">
          <li>Let <i>rhs</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
          <li>Let <i>value</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rhs</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
          <li>If <a href="sec-ecmascript-language-functions-and-classes#sec-isanonymousfunctiondefinition">IsAnonymousFunctionDefinition</a>(<i>AssignmentExpression)</i> is
              <b>true</b>, then
            <ol class="block">
              <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>value</i>,
                  <code>"name"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
              <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>value</i>, <code>"default"</code>).</li>
            </ol>
          </li>
          <li>Let <i>env</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
          <li>Let <i>status</i> be <a href="sec-ecmascript-language-expressions#sec-initializeboundname">InitializeBoundName</a>(<code>"*default*"</code>,
              <i>value</i>, <i>env</i>).</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>
      </section>
    </section>
  </section>
</section>

