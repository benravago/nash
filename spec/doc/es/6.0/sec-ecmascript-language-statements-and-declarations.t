<section id="sec-ecmascript-language-statements-and-declarations">
  <div class="front">
    <h1 id="sec-13" title="13"> ECMAScript Language: Statements and Declarations</h1><h2>Syntax</h2>

    <div class="gp">
      <div class="lhs"><span class="nt">Statement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
      <div class="rhs"><span class="nt">BlockStatement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">VariableStatement</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">EmptyStatement</span></div>
      <div class="rhs"><span class="nt">ExpressionStatement</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">IfStatement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">BreakableStatement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">ContinueStatement</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">BreakStatement</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="grhsannot">[+Return]</span> <span class="nt">ReturnStatement</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">WithStatement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">LabelledStatement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">ThrowStatement</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">TryStatement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">DebuggerStatement</span></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">Declaration</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
      <div class="rhs"><span class="nt">HoistableDeclaration</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">ClassDeclaration</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">LexicalDeclaration</span><sub class="g-params">[In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">HoistableDeclaration</span><sub class="g-params">[Yield, Default]</sub> <span class="geq">:</span></div>
      <div class="rhs"><span class="nt">FunctionDeclaration</span><sub class="g-params">[?Yield,?Default]</sub></div>
      <div class="rhs"><span class="nt">GeneratorDeclaration</span><sub class="g-params">[?Yield, ?Default]</sub></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">BreakableStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
      <div class="rhs"><span class="nt">IterationStatement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">SwitchStatement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>
  </div>

  <section id="sec-statement-semantics">
    <div class="front">
      <h2 id="sec-13.1" title="13.1">
          Statement Semantics</h2></div>

    <section id="sec-statement-semantics-static-semantics-containsduplicatelabels">
      <h3 id="sec-13.1.1" title="13.1.1"> Static Semantics: ContainsDuplicateLabels</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">Statement</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">VariableStatement</span></div>
        <div class="rhs"><span class="nt">EmptyStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
        <div class="rhs"><span class="nt">ContinueStatement</span></div>
        <div class="rhs"><span class="nt">BreakStatement</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ThrowStatement</span></div>
        <div class="rhs"><span class="nt">DebuggerStatement</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-statement-semantics-static-semantics-containsundefinedbreaktarget">
      <h3 id="sec-13.1.2" title="13.1.2"> Static Semantics: ContainsUndefinedBreakTarget</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">Statement</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">VariableStatement</span></div>
        <div class="rhs"><span class="nt">EmptyStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
        <div class="rhs"><span class="nt">ContinueStatement</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ThrowStatement</span></div>
        <div class="rhs"><span class="nt">DebuggerStatement</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">
      <h3 id="sec-13.1.3" title="13.1.3"> Static Semantics: ContainsUndefinedContinueTarget</h3><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>,<a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">Statement</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">VariableStatement</span></div>
        <div class="rhs"><span class="nt">EmptyStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
        <div class="rhs"><span class="nt">BreakStatement</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ThrowStatement</span></div>
        <div class="rhs"><span class="nt">DebuggerStatement</span></div>
      </div>

      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">BreakableStatement</span> <span class="geq">:</span> <span class="nt">IterationStatement</span></div>
      <ol class="proc">
        <li>Let <i>newIterationSet</i> be a copy of  <i>iterationSet</i> with all the elements of <i>labelSet</i> appended.</li>
        <li>Return ContainsUndefinedContinueTarget of <i>IterationStatement</i> with arguments <i>newIterationSet</i> and &laquo;
            &raquo;.</li>
      </ol>
    </section>

    <section id="sec-static-semantics-declarationpart">
      <h3 id="sec-13.1.4" title="13.1.4"> Static Semantics:  DeclarationPart</h3><div class="gp prod"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ol class="proc">
        <li>Return <i>FunctionDeclaration</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span> <span class="nt">GeneratorDeclaration</span></div>
      <ol class="proc">
        <li>Return <i>GeneratorDeclaration</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">Declaration</span> <span class="geq">:</span> <span class="nt">ClassDeclaration</span></div>
      <ol class="proc">
        <li>Return <i>ClassDeclaration</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">Declaration</span> <span class="geq">:</span> <span class="nt">LexicalDeclaration</span></div>
      <ol class="proc">
        <li>Return <i>LexicalDeclaration</i>.</li>
      </ol>
    </section>

    <section id="sec-statement-semantics-static-semantics-vardeclarednames">
      <h3 id="sec-13.1.5" title="13.1.5"> Static Semantics:  VarDeclaredNames</h3><p>See also: <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">Statement</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">EmptyStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
        <div class="rhs"><span class="nt">ContinueStatement</span></div>
        <div class="rhs"><span class="nt">BreakStatement</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ThrowStatement</span></div>
        <div class="rhs"><span class="nt">DebuggerStatement</span></div>
      </div>

      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-statement-semantics-static-semantics-varscopeddeclarations">
      <h3 id="sec-13.1.6" title="13.1.6"> Static Semantics:  VarScopedDeclarations</h3><p>See also: <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

      <div class="gp">
        <div class="lhs"><span class="nt">Statement</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">EmptyStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
        <div class="rhs"><span class="nt">ContinueStatement</span></div>
        <div class="rhs"><span class="nt">BreakStatement</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ThrowStatement</span></div>
        <div class="rhs"><span class="nt">DebuggerStatement</span></div>
      </div>

      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-statement-semantics-runtime-semantics-labelledevaluation">
      <h3 id="sec-13.1.7" title="13.1.7"> Runtime Semantics: LabelledEvaluation</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-do-while-statement-runtime-semantics-labelledevaluation">13.7.2.6</a>, <a href="#sec-while-statement-runtime-semantics-labelledevaluation">13.7.3.6</a>, <a href="#sec-for-statement-runtime-semantics-labelledevaluation">13.7.4.7</a>, <a href="#sec-for-in-and-for-of-statements-runtime-semantics-labelledevaluation">13.7.5.11</a>, <a href="#sec-labelled-statements-runtime-semantics-labelledevaluation">13.13.14</a>.</p>

      <div class="gp prod"><span class="nt">BreakableStatement</span> <span class="geq">:</span> <span class="nt">IterationStatement</span></div>
      <ol class="proc">
        <li>Let <i>stmtResult</i> be the result of performing LabelledEvaluation of <i>IterationStatement</i> with argument
            <i>labelSet</i>.</li>
        <li>If <i>stmtResult</i>.[[type]] is <span style="font-family: sans-serif">break</span>, then
          <ol class="block">
            <li>If <i>stmtResult</i>.[[target]] is <span style="font-family: sans-serif">empty</span>, then
              <ol class="block">
                <li>If <i>stmtResult</i>.[[value]] is <span style="font-family: sans-serif">empty</span>, let <i>stmtResult</i> be
                    <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
                <li>Else, let <i>stmtResult</i> be <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>stmtResult</i>.[[value]]).</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>stmtResult</i>).</li>
      </ol>
      <div class="gp prod"><span class="nt">BreakableStatement</span> <span class="geq">:</span> <span class="nt">SwitchStatement</span></div>
      <ol class="proc">
        <li>Let <i>stmtResult</i> be the result of evaluating <i>SwitchStatement</i>.</li>
        <li>If <i>stmtResult</i>.[[type]] is <span style="font-family: sans-serif">break</span>, then
          <ol class="block">
            <li>If <i>stmtResult</i>.[[target]] is <span style="font-family: sans-serif">empty</span>, then
              <ol class="block">
                <li>If <i>stmtResult</i>.[[value]] is <span style="font-family: sans-serif">empty</span>, let <i>stmtResult</i> be
                    <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
                <li>Else, let <i>stmtResult</i> be <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>stmtResult</i>.[[value]]).</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>stmtResult</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> A <span class="nt">BreakableStatement</span> is one that can be exited via an unlabelled
        <var>BreakStatement.</var></p>
      </div>
    </section>

    <section id="sec-statement-semantics-runtime-semantics-evaluation">
      <h3 id="sec-13.1.8" title="13.1.8"> Runtime Semantics: Evaluation</h3><div class="gp">
        <div class="lhs"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">GeneratorDeclaration</span></div>
      </div>

      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
      </ol>

      <div class="gp">
        <div class="lhs"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">FunctionDeclaration</span></div>
      </div>

      <ol class="proc">
        <li>Return the result of evaluating <i>FunctionDeclaration</i>.</li>
      </ol>

      <div class="gp">
        <div class="lhs"><span class="nt">BreakableStatement</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">IterationStatement</span></div>
        <div class="rhs"><span class="nt">SwitchStatement</span></div>
      </div>

      <ol class="proc">
        <li>Let <i>newLabelSet</i>  be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Return the result of performing LabelledEvaluation of this <i>BreakableStatement</i> with argument
            <i>newLabelSet</i>.</li>
      </ol>
    </section>
  </section>

  <section id="sec-block">
    <div class="front">
      <h2 id="sec-13.2" title="13.2"> Block</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">BlockStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">Block</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">{</code> <span class="nt">StatementList</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">StatementListItem</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><span class="nt">StatementList</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">StatementListItem</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementListItem</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><span class="nt">Declaration</span><sub class="g-params">[?Yield]</sub></div>
      </div>
    </div>

    <section id="sec-block-static-semantics-early-errors">
      <h3 id="sec-13.2.1" title="13.2.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">StatementList</span> <code class="t">}</code></div>
      <ul>
        <li>
          <p>It is a Syntax Error if the LexicallyDeclaredNames of <span class="nt">StatementList</span> contains any duplicate
          entries.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the LexicallyDeclaredNames of <span class="nt">StatementList</span> also
          occurs in the VarDeclaredNames of <span class="nt">StatementList</span>.</p>
        </li>
      </ul>
    </section>

    <section id="sec-block-static-semantics-containsduplicatelabels">
      <h3 id="sec-13.2.2" title="13.2.2"> Static Semantics: ContainsDuplicateLabels</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

      <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>hasDuplicates</i> be ContainsDuplicateLabels of <i>StatementList</i> with argument <i>labelSet</i>.</li>
        <li>If <i>hasDuplicates</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsDuplicateLabels of <i>StatementListItem</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-block-static-semantics-containsundefinedbreaktarget">
      <h3 id="sec-13.2.3" title="13.2.3"> Static Semantics: ContainsUndefinedBreakTarget</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

      <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedBreakTarget of <i>StatementList</i> with argument
            <i>labelSet</i>.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedBreakTarget of <i>StatementListItem</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-block-static-semantics-containsundefinedcontinuetarget">
      <h3 id="sec-13.2.4" title="13.2.4"> Static Semantics: ContainsUndefinedContinueTarget</h3><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>,<a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

      <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedContinueTarget of <i>StatementList</i> with arguments
            <i>iterationSet</i> and &laquo; &raquo;.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedContinueTarget of <i>StatementListItem</i> with arguments <i>iterationSet</i> and
            &laquo;&nbsp;&raquo;.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-block-static-semantics-lexicallydeclarednames">
      <h3 id="sec-13.2.5" title="13.2.5"> Static Semantics:  LexicallyDeclaredNames</h3><p>See also: <a href="#sec-switch-statement-static-semantics-lexicallydeclarednames">13.12.5</a>, <a href="#sec-labelled-statements-static-semantics-lexicallydeclarednames">13.13.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallydeclarednames">14.1.13</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallydeclarednames">14.2.10</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-lexicallydeclarednames">15.1.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-lexicallydeclarednames">15.2.1.11</a>.</p>

      <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be LexicallyDeclaredNames of <i>StatementList</i>.</li>
        <li>Append to <i>names</i> the elements of the LexicallyDeclaredNames of <i>StatementListItem.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>If <i>Statement</i> is <span class="prod"><span class="nt">Statement</span> <span class="geq">:</span> <span class="nt">LabelledStatement</span></span> , return LexicallyDeclaredNames of <i>LabelledStatement</i>.</li>
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>Return the BoundNames of <i>Declaration</i>.</li>
      </ol>
    </section>

    <section id="sec-block-static-semantics-lexicallyscopeddeclarations">
      <h3 id="sec-13.2.6" title="13.2.6"> Static Semantics:  LexicallyScopedDeclarations</h3><p>See also: <a href="#sec-switch-statement-static-semantics-lexicallyscopeddeclarations">13.12.6</a>, <a href="#sec-labelled-statements-static-semantics-lexicallyscopeddeclarations">13.13.7</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallyscopeddeclarations">14.1.14</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallyscopeddeclarations">14.2.11</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-lexicallyscopeddeclarations">15.1.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-lexicallyscopeddeclarations">15.2.1.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-lexicallyscopeddeclarations">15.2.3.8</a>.</p>

      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>declarations</i> be LexicallyScopedDeclarations of <i>StatementList</i>.</li>
        <li>Append to <i>declarations</i> the elements of the LexicallyScopedDeclarations of <i>StatementListItem.</i></li>
        <li>Return <i>declarations</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>If <i>Statement</i> is <span class="prod"><span class="nt">Statement</span> <span class="geq">:</span> <span class="nt">LabelledStatement</span></span> , return LexicallyScopedDeclarations of <i>LabelledStatement</i>.</li>
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing DeclarationPart of
            <i>Declaration</i>.</li>
      </ol>
    </section>

    <section id="sec-block-static-semantics-toplevellexicallydeclarednames">
      <h3 id="sec-13.2.7" title="13.2.7"> Static Semantics:  TopLevelLexicallyDeclaredNames</h3><p>See also: <a href="#sec-labelled-statements-static-semantics-toplevellexicallydeclarednames">13.13.8</a>.</p>

      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be TopLevelLexicallyDeclaredNames of <i>StatementList</i>.</li>
        <li>Append to <i>names</i> the elements of the TopLevelLexicallyDeclaredNames of <i>StatementListItem.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>If <i>Declaration</i> is <span class="prod"><span class="nt">Declaration</span> <span class="geq">:</span> <span class="nt">HoistableDeclaration</span></span> , then
          <ol class="block">
            <li>If <i>HoistableDeclaration</i> is <span class="prod"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></span> , return &laquo; &raquo;.</li>
            <li>If <i>HoistableDeclaration</i> is <span class="prod"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span> <span class="nt">GeneratorDeclaration</span></span> , return &laquo; &raquo;.</li>
          </ol>
        </li>
        <li>Return the BoundNames of <i>Declaration</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> At the top level of a function, or script,  function declarations are treated like var
        declarations rather than like lexical declarations.</p>
      </div>
    </section>

    <section id="sec-block-static-semantics-toplevellexicallyscopeddeclarations">
      <h3 id="sec-13.2.8" title="13.2.8"> Static Semantics:  TopLevelLexicallyScopedDeclarations</h3><p>See also: <a href="#sec-labelled-statements-static-semantics-toplevellexicallyscopeddeclarations">13.13.9</a>.</p>

      <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>declarations</i> be TopLevelLexicallyScopedDeclarations of <i>StatementList</i>.</li>
        <li>Append to <i>declarations</i> the elements of the TopLevelLexicallyScopedDeclarations of
            <i>StatementListItem.</i></li>
        <li>Return <i>declarations</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>If <i>Declaration</i> is <span class="prod"><span class="nt">Declaration</span> <span class="geq">:</span> <span class="nt">HoistableDeclaration</span></span> , then
          <ol class="block">
            <li>If <i>HoistableDeclaration</i> is <span class="prod"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></span> , return &laquo; &raquo;.</li>
            <li>If <i>HoistableDeclaration</i> is <span class="prod"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span> <span class="nt">GeneratorDeclaration</span></span> , return &laquo; &raquo;.</li>
          </ol>
        </li>
        <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>Declaration</i>.</li>
      </ol>
    </section>

    <section id="sec-block-static-semantics-toplevelvardeclarednames">
      <h3 id="sec-13.2.9" title="13.2.9"> Static Semantics:  TopLevelVarDeclaredNames</h3><p>See also: <a href="#sec-labelled-statements-static-semantics-toplevelvardeclarednames">13.13.10</a>.</p>

      <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be TopLevelVarDeclaredNames of <i>StatementList</i>.</li>
        <li>Append to <i>names</i> the elements of the TopLevelVarDeclaredNames of <i>StatementListItem.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>If <i>Declaration</i> is <span class="prod"><span class="nt">Declaration</span> <span class="geq">:</span> <span class="nt">HoistableDeclaration</span></span> , then
          <ol class="block">
            <li>If <i>HoistableDeclaration</i> is <span class="prod"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></span> , return the BoundNames of
                <i>FunctionDeclaration</i>.</li>
            <li>If <i>HoistableDeclaration</i> is <span class="prod"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span> <span class="nt">GeneratorDeclaration</span></span> , return the BoundNames of
                <i>GeneratorDeclaration</i>.</li>
          </ol>
        </li>
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>If <i>Statement</i> is <span class="prod"><span class="nt">Statement</span> <span class="geq">:</span> <span class="nt">LabelledStatement</span></span> , return TopLevelVarDeclaredNames of <i>Statement</i>.</li>
        <li>Return VarDeclaredNames of <i>Statement</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> At the top level of a function or script, inner function declarations are treated like var
        declarations.</p>
      </div>
    </section>

    <section id="sec-block-static-semantics-toplevelvarscopeddeclarations">
      <h3 id="sec-13.2.10" title="13.2.10"> Static Semantics:  TopLevelVarScopedDeclarations</h3><p>See also: <a href="#sec-labelled-statements-static-semantics-toplevelvarscopeddeclarations">13.13.11</a>.</p>

      <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>declarations</i> be TopLevelVarScopedDeclarations of <i>StatementList</i>.</li>
        <li>Append to <i>declarations</i> the elements of the TopLevelVarScopedDeclarations of <i>StatementListItem.</i></li>
        <li>Return <i>declarations</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>If <i>Statement</i> is <span class="prod"><span class="nt">Statement</span> <span class="geq">:</span> <span class="nt">LabelledStatement</span></span> , return TopLevelVarScopedDeclarations of <i>Statement</i>.</li>
        <li>Return VarScopedDeclarations of <i>Statement</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>If <i>Declaration</i> is <span class="prod"><span class="nt">Declaration</span> <span class="geq">:</span> <span class="nt">HoistableDeclaration</span></span> , then
          <ol class="block">
            <li>If <i>HoistableDeclaration</i> is <span class="prod"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></span> , return
                &laquo;&nbsp;<i>FunctionDeclaration</i> &raquo;.</li>
            <li>If <i>HoistableDeclaration</i> is <span class="prod"><span class="nt">HoistableDeclaration</span> <span class="geq">:</span> <span class="nt">GeneratorDeclaration</span></span> , return
                &laquo;&nbsp;<i>GeneratorDeclaration</i> &raquo;.</li>
          </ol>
        </li>
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-block-static-semantics-vardeclarednames">
      <h3 id="sec-13.2.11" title="13.2.11"> Static Semantics:  VarDeclaredNames</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

      <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be VarDeclaredNames of <i>StatementList</i>.</li>
        <li>Append to <i>names</i> the elements of the VarDeclaredNames of <i>StatementListItem.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-block-static-semantics-varscopeddeclarations">
      <h3 id="sec-13.2.12" title="13.2.12"> Static Semantics:  VarScopedDeclarations</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

      <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>declarations</i> be VarScopedDeclarations of <i>StatementList</i>.</li>
        <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of <i>StatementListItem.</i></li>
        <li>Return <i>declarations</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">StatementListItem</span> <span class="geq">:</span> <span class="nt">Declaration</span></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-block-runtime-semantics-evaluation">
      <h3 id="sec-13.2.13" title="13.2.13"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
      </ol>
      <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">StatementList</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Let <i>oldEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
        <li>Let <i>blockEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>oldEnv</i>).</li>
        <li>Perform <a href="#sec-blockdeclarationinstantiation">BlockDeclarationInstantiation</a>(<i>StatementList,</i>
            <i>blockEnv</i>).</li>
        <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>blockEnv</i>.</li>
        <li>Let <i>blockValue</i> be the result of evaluating <i>StatementList</i>.</li>
        <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>oldEnv</i>.</li>
        <li>Return <i>blockValue</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 1</span> No matter how control leaves the <span class="nt">Block</span> the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> is always restored to its former state.</p>
      </div>

      <div class="gp prod"><span class="nt">StatementList</span> <span class="geq">:</span> <span class="nt">StatementList</span> <span class="nt">StatementListItem</span></div>
      <ol class="proc">
        <li>Let <i>sl</i> be the result of evaluating <i>StatementList</i>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>sl</i>).</li>
        <li>Let <i>s</i> be the result of evaluating <i>StatementListItem</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>s</i>, <i>sl</i>.[[value]])).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 2</span> The value of a <span class="nt">StatementList</span> is the value of the last value
        producing item in the <span class="nt">StatementList</span>. For example, the following calls to the <code>eval</code>
        function all return the value 1:</p>

        <p><code>eval("1;;;;;")</code></p>

        <p><code>eval("1;{}")</code></p>

        <p><code>eval("1;var a;")</code></p>
      </div>
    </section>

    <section id="sec-blockdeclarationinstantiation">
      <h3 id="sec-13.2.14" title="13.2.14"> Runtime Semantics: BlockDeclarationInstantiation( code, env )</h3><div class="note">
        <p><span class="nh">NOTE</span>  When a <span class="nt">Block</span> or <span class="nt">CaseBlock</span> production is
        evaluated a new declarative <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> is created and bindings for each
        block scoped variable, constant, function, generator function, or class declared in the block are instantiated in the <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>.</p>
      </div>

      <p>BlockDeclarationInstantiation is performed as follows using arguments <var>code</var> and <var>env</var>. <var>code</var>
      is the grammar production corresponding to the body of the block. <var>env</var> is the declarative <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> in which bindings are to be created.</p>

      <ol class="proc">
        <li>Let <i>declarations</i> be the LexicallyScopedDeclarations of <i>code</i>.</li>
        <li>For each element <i>d</i> in <i>declarations</i> do
          <ol class="block">
            <li>For each element <i>dn</i> of the BoundNames of <i>d</i> do
              <ol class="block">
                <li>If IsConstantDeclaration of <i>d</i> is <b>true</b>, then
                  <ol class="block">
                    <li>Let <i>status</i> be <i>env</i>.CreateImmutableBinding(<i>dn</i>, <b>true</b>).</li>
                  </ol>
                </li>
                <li>Else,
                  <ol class="block">
                    <li>Let <i>status</i> be <i>env</i>.CreateMutableBinding(<i>dn</i>, <b>false</b>).</li>
                  </ol>
                </li>
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              </ol>
            </li>
            <li>If <i>d</i> is a <i>GeneratorDeclaration</i> production or a <i>FunctionDeclaration</i> production, then
              <ol class="block">
                <li>Let <i>fn</i> be the sole element of the BoundNames of <i>d</i></li>
                <li>Let <i>fo</i> be the result of performing  InstantiateFunctionObject  for <i>d</i> with argument
                    <i>env</i>.</li>
                <li>Perform <i>env</i>.InitializeBinding(<i>fn</i>, <i>fo</i>).</li>
              </ol>
            </li>
          </ol>
        </li>
      </ol>
    </section>
  </section>

  <section id="sec-declarations-and-the-variable-statement">
    <div class="front">
      <h2 id="sec-13.3" title="13.3"> Declarations and the Variable Statement</h2></div>

    <section id="sec-let-and-const-declarations">
      <div class="front">
        <h3 id="sec-13.3.1" title="13.3.1"> Let and Const Declarations</h3><div class="note">
          <p><span class="nh">NOTE</span> <code>let</code> and <code>const</code> declarations define variables that are scoped to
          <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>. The variables are created when their containing <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a> is instantiated but may not be accessed in any way until the
          variable&rsquo;s <span class="nt">LexicalBinding</span> is evaluated. A variable defined by a <span class="nt">LexicalBinding</span> with an <span class="nt">Initializer</span> is assigned the value of its <span style="font-family: Times New Roman"><i>Initializer</i>&rsquo;s</span> <span class="nt">AssignmentExpression</span> when
          the <span class="nt">LexicalBinding</span> is evaluated, not when the variable is created. If a <span class="nt">LexicalBinding</span> in a <code>let</code> declaration does not have an <span class="nt">Initializer</span>
          the variable is assigned the value <b>undefined</b> when the <span class="nt">LexicalBinding</span> is evaluated.</p>
        </div>

        <h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">LexicalDeclaration</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">LetOrConst</span> <span class="nt">BindingList</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">;</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">LetOrConst</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">let</code></div>
          <div class="rhs"><code class="t">const</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BindingList</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">LexicalBinding</span><sub class="g-params">[?In, ?Yield]</sub></div>
          <div class="rhs"><span class="nt">BindingList</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">,</code> <span class="nt">LexicalBinding</span><sub class="g-params">[?In, ?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">LexicalBinding</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[?In, ?Yield]</sub><sub class="g-opt">opt</sub></div>
          <div class="rhs"><span class="nt">BindingPattern</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[?In, ?Yield]</sub></div>
        </div>
      </div>

      <section id="sec-let-and-const-declarations-static-semantics-early-errors">
        <h4 id="sec-13.3.1.1" title="13.3.1.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">LexicalDeclaration</span> <span class="geq">:</span> <span class="nt">LetOrConst</span> <span class="nt">BindingList</span> <code class="t">;</code></div>
        <ul>
          <li>It is a Syntax Error if the BoundNames of <span class="nt">BindingList</span> contains <code>"let"</code>.</li>
          <li>It is a Syntax Error if the BoundNames of <span class="nt">BindingList</span> contains any duplicate entries.</li>
        </ul>
        <div class="gp prod"><span class="nt">LexicalBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ul>
          <li>
            <p>It is a Syntax Error if <span class="nt">Initializer</span> is not present and IsConstantDeclaration of the <span class="nt">LexicalDeclaration</span> containing this production is <span class="value">true</span>.</p>
          </li>
        </ul>
      </section>

      <section id="sec-let-and-const-declarations-static-semantics-boundnames">
        <h4 id="sec-13.3.1.2" title="13.3.1.2"> Static Semantics:  BoundNames</h4><p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-boundnames">12.1.2</a>, <a href="#sec-variable-statement-static-semantics-boundnames">13.3.2.1</a>, <a href="#sec-destructuring-binding-patterns-static-semantics-boundnames">13.3.3.1</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-boundnames">13.7.5.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-boundnames">14.1.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-boundnames">14.2.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-boundnames">14.4.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-boundnames">14.5.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-imports-static-semantics-boundnames">15.2.2.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-boundnames">15.2.3.2</a>.</p>

        <div class="gp prod"><span class="nt">LexicalDeclaration</span> <span class="geq">:</span> <span class="nt">LetOrConst</span> <span class="nt">BindingList</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>BindingList</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingList</span> <span class="geq">:</span> <span class="nt">BindingList</span> <code class="t">,</code> <span class="nt">LexicalBinding</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be the BoundNames of <i>BindingList</i>.</li>
          <li>Append to <i>names</i> the elements of the BoundNames of <i>LexicalBinding.</i></li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LexicalBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>BindingIdentifier</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LexicalBinding</span> <span class="geq">:</span> <span class="nt">BindingPattern</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>BindingPattern</i>.</li>
        </ol>
      </section>

      <section id="sec-let-and-const-declarations-static-semantics-isconstantdeclaration">
        <h4 id="sec-13.3.1.3" title="13.3.1.3"> Static Semantics:  IsConstantDeclaration</h4><p>See also: <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-isconstantdeclaration">14.1.10</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-isconstantdeclaration">14.4.8</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-isconstantdeclaration">14.5.7</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-isconstantdeclaration">15.2.3.7</a>.</p>

        <div class="gp prod"><span class="nt">LexicalDeclaration</span> <span class="geq">:</span> <span class="nt">LetOrConst</span> <span class="nt">BindingList</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return IsConstantDeclaration of <i>LetOrConst</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LetOrConst</span> <span class="geq">:</span> <code class="t">let</code></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LetOrConst</span> <span class="geq">:</span> <code class="t">const</code></div>
        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-let-and-const-declarations-runtime-semantics-evaluation">
        <h4 id="sec-13.3.1.4" title="13.3.1.4"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">LexicalDeclaration</span> <span class="geq">:</span> <span class="nt">LetOrConst</span> <span class="nt">BindingList</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Let <i>next</i> be the result of evaluating <i>BindingList</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingList</span> <span class="geq">:</span> <span class="nt">BindingList</span> <code class="t">,</code> <span class="nt">LexicalBinding</span></div>
        <ol class="proc">
          <li>Let <i>next</i> be the result of evaluating <i>BindingList</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
          <li>Return the result of evaluating <i>LexicalBinding</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">LexicalBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
        <ol class="proc">
          <li>Let <i>lhs</i> be <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(StringValue of <i>BindingIdentifier</i>).</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-initializereferencedbinding">InitializeReferencedBinding</a>(<i>lhs</i>,
              <b>undefined</b>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> A static semantics rule ensures that this form of <span class="nt">LexicalBinding</span>
          never occurs in a <code>const</code> declaration.</p>
        </div>

        <div class="gp prod"><span class="nt">LexicalBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Let <i>bindingId</i> be StringValue of <i>BindingIdentifier.</i></li>
          <li>Let <i>lhs</i> be <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(<i>bindingId</i>).</li>
          <li>Let <i>rhs</i> be the result of evaluating <i>Initializer</i>.</li>
          <li>Let <i>value</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rhs</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
          <li>If <a href="sec-ecmascript-language-functions-and-classes#sec-isanonymousfunctiondefinition">IsAnonymousFunctionDefinition</a>(<i>Initializer)</i> is
              <b>true</b>, then
            <ol class="block">
              <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>value</i>,
                  <code>"name"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
              <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>value</i>, <i>bindingId</i>).</li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-initializereferencedbinding">InitializeReferencedBinding</a>(<i>lhs</i>, <i>value</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">LexicalBinding</span> <span class="geq">:</span> <span class="nt">BindingPattern</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Let <i>rhs</i> be the result of evaluating <i>Initializer</i>.</li>
          <li>Let <i>value</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rhs</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
          <li>Let <i>env</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
          <li>Return the result of performing BindingInitialization for <i>BindingPattern</i> using <i>value</i> and <i>env</i> as
              the <i>arguments</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-variable-statement">
      <div class="front">
        <h3 id="sec-13.3.2" title="13.3.2">
            Variable Statement</h3><div class="note">
          <p><span class="nh">NOTE</span> A <code>var</code> statement declares variables that are scoped to <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a>. Var variables are created when their containing <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a> is instantiated and are initialized to <b>undefined</b> when
          created. Within the scope of any <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> a common <span class="nt">BindingIdentifier</span> may appear in more than one <span class="nt">VariableDeclaration</span> but those
          declarations collective define only one variable. A variable defined by a <span class="nt">VariableDeclaration</span>
          with an <span class="nt">Initializer</span> is assigned the value of its <span style="font-family: Times New           Roman"><i>Initializer</i>&rsquo;s</span> <span class="nt">AssignmentExpression</span> when the <span class="nt">VariableDeclaration</span> is executed, not when the variable is created.</p>
        </div>

        <h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">VariableStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">var</code> <span class="nt">VariableDeclarationList</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">;</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">VariableDeclarationList</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">VariableDeclaration</span><sub class="g-params">[?In, ?Yield]</sub></div>
          <div class="rhs"><span class="nt">VariableDeclarationList</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">,</code> <span class="nt">VariableDeclaration</span><sub class="g-params">[?In, ?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">VariableDeclaration</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[?In, ?Yield]</sub><sub class="g-opt">opt</sub></div>
          <div class="rhs"><span class="nt">BindingPattern</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[?In, ?Yield]</sub></div>
        </div>
      </div>

      <section id="sec-variable-statement-static-semantics-boundnames">
        <h4 id="sec-13.3.2.1" title="13.3.2.1"> Static Semantics:  BoundNames</h4><p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-boundnames">12.1.2</a>, <a href="#sec-let-and-const-declarations-static-semantics-boundnames">13.3.1.2</a>, <a href="#sec-destructuring-binding-patterns-static-semantics-boundnames">13.3.3.1</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-boundnames">13.7.5.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-boundnames">14.1.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-boundnames">14.2.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-boundnames">14.4.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-boundnames">14.5.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-imports-static-semantics-boundnames">15.2.2.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-boundnames">15.2.3.2</a>.</p>

        <div class="gp prod"><span class="nt">VariableDeclarationList</span> <span class="geq">:</span> <span class="nt">VariableDeclarationList</span> <code class="t">,</code> <span class="nt">VariableDeclaration</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be BoundNames of <i>VariableDeclarationList</i>.</li>
          <li>Append to <i>names</i> the elements of BoundNames of <i>VariableDeclaration.</i></li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">VariableDeclaration</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>BindingIdentifier</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">VariableDeclaration</span> <span class="geq">:</span> <span class="nt">BindingPattern</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>BindingPattern</i>.</li>
        </ol>
      </section>

      <section id="sec-variable-statement-static-semantics-vardeclarednames">
        <h4 id="sec-13.3.2.2" title="13.3.2.2"> Static Semantics:  VarDeclaredNames</h4><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

        <div class="gp prod"><span class="nt">VariableStatement</span> <span class="geq">:</span> <code class="t">var</code> <span class="nt">VariableDeclarationList</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return BoundNames of <i>VariableDeclarationList.</i></li>
        </ol>
      </section>

      <section id="sec-variable-statement-static-semantics-varscopeddeclarations">
        <h4 id="sec-13.3.2.3" title="13.3.2.3"> Static Semantics:  VarScopedDeclarations</h4><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

        <div class="gp prod"><span class="nt">VariableDeclarationList</span> <span class="geq">:</span> <span class="nt">VariableDeclaration</span></div>
        <ol class="proc">
          <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>VariableDeclaration.</i></li>
        </ol>
        <div class="gp prod"><span class="nt">VariableDeclarationList</span> <span class="geq">:</span> <span class="nt">VariableDeclarationList</span> <code class="t">,</code> <span class="nt">VariableDeclaration</span></div>
        <ol class="proc">
          <li>Let <i>declarations</i> be VarScopedDeclarations of <i>VariableDeclarationList</i>.</li>
          <li>Append <i>VariableDeclaration</i> to <i>declarations.</i></li>
          <li>Return <i>declarations</i>.</li>
        </ol>
      </section>

      <section id="sec-variable-statement-runtime-semantics-evaluation">
        <h4 id="sec-13.3.2.4" title="13.3.2.4"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">VariableStatement</span> <span class="geq">:</span> <code class="t">var</code> <span class="nt">VariableDeclarationList</span> <code class="t">;</code></div>
        <ol class="proc">
          <li>Let <i>next</i> be the result of evaluating <i>VariableDeclarationList</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>( <span style="font-family:               sans-serif">empty</span>).</li>
        </ol>
        <div class="gp prod"><span class="nt">VariableDeclarationList</span> <span class="geq">:</span> <span class="nt">VariableDeclarationList</span> <code class="t">,</code> <span class="nt">VariableDeclaration</span></div>
        <ol class="proc">
          <li>Let <i>next</i> be the result of evaluating <i>VariableDeclarationList</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
          <li>Return the result of evaluating <i>VariableDeclaration</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">VariableDeclaration</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
        <ol class="proc">
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>
        <div class="gp prod"><span class="nt">VariableDeclaration</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Let <i>bindingId</i> be StringValue of <i>BindingIdentifier.</i></li>
          <li>Let <i>lhs</i> be <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(<i>bindingId</i>)</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lhs</i>).</li>
          <li>Let <i>rhs</i> be the result of evaluating <i>Initializer</i>.</li>
          <li>Let <i>value</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rhs</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
          <li>If <a href="sec-ecmascript-language-functions-and-classes#sec-isanonymousfunctiondefinition">IsAnonymousFunctionDefinition</a>(<i>Initializer)</i> is
              <b>true</b>, then
            <ol class="block">
              <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>value</i>,
                  <code>"name"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
              <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>value</i>, <i>bindingId</i>).</li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lhs</i>, <i>value</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> If a <span class="nt">VariableDeclaration</span> is nested within a with statement and
          the <span class="nt">BindingIdentifier</span> in the <span class="nt">VariableDeclaration</span> is the same as a
          property name of the binding object of the with statement&rsquo;s object <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment
          Record</a>, then step 7 will assign <var>value</var> to the property instead of assigning to the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> binding of the <span class="nt">Identifier</span>.</p>
        </div>

        <div class="gp prod"><span class="nt">VariableDeclaration</span> <span class="geq">:</span> <span class="nt">BindingPattern</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Let <i>rhs</i> be the result of evaluating <i>Initializer</i>.</li>
          <li>Let <i>rval</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>rhs</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rval</i>).</li>
          <li>Return the result of performing BindingInitialization for <i>BindingPattern</i> passing <i>rval</i> and
              <b>undefined</b> as arguments.</li>
        </ol>
      </section>
    </section>

    <section id="sec-destructuring-binding-patterns">
      <div class="front">
        <h3 id="sec-13.3.3" title="13.3.3"> Destructuring Binding Patterns</h3><h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">BindingPattern</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ObjectBindingPattern</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">ArrayBindingPattern</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ObjectBindingPattern</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">{</code> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">BindingPropertyList</span><sub class="g-params">[?Yield]</sub> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">BindingPropertyList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <code class="t">}</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ArrayBindingPattern</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingRestElement</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">]</code></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">BindingElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">]</code></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">BindingElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingRestElement</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">]</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BindingPropertyList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">BindingProperty</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">BindingPropertyList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">BindingProperty</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BindingElementList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">BindingElisionElement</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">BindingElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">BindingElisionElement</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BindingElisionElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingElement</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BindingProperty</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">SingleNameBinding</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">:</code> <span class="nt">BindingElement</span><sub class="g-params">[?Yield]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BindingElement</span><sub class="g-params">[Yield ]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">SingleNameBinding</span><sub class="g-params">[?Yield]</sub></div>
          <div class="rhs"><span class="nt">BindingPattern</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[In, ?Yield]</sub><sub class="g-opt">opt</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">SingleNameBinding</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[In, ?Yield]</sub><sub class="g-opt">opt</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BindingRestElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">...</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub></div>
        </div>
      </div>

      <section id="sec-destructuring-binding-patterns-static-semantics-boundnames">
        <h4 id="sec-13.3.3.1" title="13.3.3.1"> Static Semantics:  BoundNames</h4><p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-boundnames">12.1.2</a>, <a href="#sec-let-and-const-declarations-static-semantics-boundnames">13.3.1.2</a>, <a href="#sec-variable-statement-static-semantics-boundnames">13.3.2.1</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-boundnames">13.7.5.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-boundnames">14.1.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-boundnames">14.2.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-boundnames">14.4.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-boundnames">14.5.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-imports-static-semantics-boundnames">15.2.2.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-boundnames">15.2.3.2</a>.</p>

        <div class="gp prod"><span class="nt">ObjectBindingPattern</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingRestElement</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>BindingRestElement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">BindingElementList</span> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>BindingElementList</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">BindingElementList</span> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingRestElement</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>names</i> be BoundNames of <i>BindingElementList</i>.</li>
          <li>Append to <i>names</i> the elements of BoundNames of <i>BindingRestElement.</i></li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingPropertyList</span> <span class="geq">:</span> <span class="nt">BindingPropertyList</span> <code class="t">,</code> <span class="nt">BindingProperty</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be BoundNames of <i>BindingPropertyList</i>.</li>
          <li>Append to <i>names</i> the elements of BoundNames of <i>BindingProperty.</i></li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElementList</span> <span class="geq">:</span> <span class="nt">BindingElementList</span> <code class="t">,</code> <span class="nt">BindingElisionElement</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be BoundNames of <i>BindingElementList</i>.</li>
          <li>Append to <i>names</i> the elements of BoundNames of <i>BindingElisionElement.</i></li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElisionElement</span> <span class="geq">:</span> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingElement</span></div>
        <ol class="proc">
          <li>Return BoundNames of <i>BindingElement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingProperty</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">BindingElement</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>BindingElement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">SingleNameBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>BindingIdentifier</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElement</span> <span class="geq">:</span> <span class="nt">BindingPattern</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>BindingPattern</i>.</li>
        </ol>
      </section>

      <section id="sec-destructuring-binding-patterns-static-semantics-containsexpression">
        <h4 id="sec-13.3.3.2" title="13.3.3.2"> Static Semantics:  ContainsExpression</h4><p>See also: <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-containsexpression">14.1.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-containsexpression">14.2.4</a>.</p>

        <div class="gp prod"><span class="nt">ObjectBindingPattern</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingRestElement</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">BindingElementList</span> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return ContainsExpression of <i>BindingElementList</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">BindingElementList</span> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingRestElement</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return ContainsExpression of <i>BindingElementList</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingPropertyList</span> <span class="geq">:</span> <span class="nt">BindingPropertyList</span> <code class="t">,</code> <span class="nt">BindingProperty</span></div>
        <ol class="proc">
          <li>Let <i>has</i> be ContainsExpression of <i>BindingPropertyList</i>.</li>
          <li>If <i>has</i> is <b>true</b>, return <b>true</b><i>.</i></li>
          <li>Return ContainsExpression of <i>BindingProperty</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElementList</span> <span class="geq">:</span> <span class="nt">BindingElementList</span> <code class="t">,</code> <span class="nt">BindingElisionElement</span></div>
        <ol class="proc">
          <li>Let <i>has</i> be ContainsExpression of <i>BindingElementList</i>.</li>
          <li>If <i>has</i> is <b>true</b>, return <b>true</b><i>.</i></li>
          <li>Return ContainsExpression of <i>BindingElisionElement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElisionElement</span> <span class="geq">:</span> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingElement</span></div>
        <ol class="proc">
          <li>Return ContainsExpression of <i>BindingElement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingProperty</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">BindingElement</span></div>
        <ol class="proc">
          <li>Let <i>has</i> be IsComputedPropertyKey of <i>PropertyName</i>.</li>
          <li>If <i>has</i> is <b>true</b>, return <b>true</b><i>.</i></li>
          <li>Return the ContainsExpression of <i>BindingElement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElement</span> <span class="geq">:</span> <span class="nt">BindingPattern</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">SingleNameBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">SingleNameBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-destructuring-binding-patterns-static-semantics-hasinitializer">
        <h4 id="sec-13.3.3.3" title="13.3.3.3"> Static Semantics:  HasInitializer</h4><p>See also: <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-hasinitializer">14.1.7</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-hasinitializer">14.2.6</a>.</p>

        <div class="gp prod"><span class="nt">BindingElement</span> <span class="geq">:</span> <span class="nt">BindingPattern</span></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElement</span> <span class="geq">:</span> <span class="nt">BindingPattern</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">SingleNameBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">SingleNameBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-destructuring-binding-patterns-static-semantics-issimpleparameterlist">
        <h4 id="sec-13.3.3.4" title="13.3.3.4"> Static Semantics:  IsSimpleParameterList</h4><p>See also: <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-issimpleparameterlist">14.1.12</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-issimpleparameterlist">14.2.8</a>.</p>

        <div class="gp prod"><span class="nt">BindingElement</span> <span class="geq">:</span> <span class="nt">BindingPattern</span></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElement</span> <span class="geq">:</span> <span class="nt">BindingPattern</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">SingleNameBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">SingleNameBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-destructuring-binding-patterns-runtime-semantics-bindinginitialization">
        <h4 id="sec-13.3.3.5" title="13.3.3.5"> Runtime Semantics: BindingInitialization</h4><p>With parameters <var>value</var> and <var>environment</var>.</p>

        <p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-runtime-semantics-bindinginitialization">12.1.5</a>, <a href="#sec-for-in-and-for-of-statements-runtime-semantics-bindinginitialization">13.7.5.9</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> When <b>undefined</b> is passed for <var>environment</var> it indicates that a <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a> operation should be used to assign the initialization value. This is the case for
          formal parameter lists of non-strict functions. In that case the formal parameter bindings are preinitialized in order
          to deal with the possibility of multiple parameters with the same name.</p>
        </div>

        <div class="gp prod"><span class="nt">BindingPattern</span> <span class="geq">:</span> <span class="nt">ObjectBindingPattern</span></div>
        <ol class="proc">
          <li>Let  <i>valid</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>valid</i>).</li>
          <li>Return the result of performing BindingInitialization for <i>ObjectBindingPattern</i> using <i>value</i> and
              <i>environment</i> as arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingPattern</span> <span class="geq">:</span> <span class="nt">ArrayBindingPattern</span></div>
        <ol class="proc">
          <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
          <li>Let <i>iteratorRecord</i> be Record {[[iterator]]: <i>iterator</i>, [[done]]: <b>false</b>}.</li>
          <li>Let <i>result</i> be IteratorBindingInitialization for <i>ArrayBindingPattern</i> using <i>iteratorRecord</i>, and
              <i>environment</i> as arguments.</li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>result</i>).</li>
          <li>Return <i>result</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ObjectBindingPattern</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
        <ol class="proc">
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingPropertyList</span> <span class="geq">:</span> <span class="nt">BindingPropertyList</span> <code class="t">,</code> <span class="nt">BindingProperty</span></div>
        <ol class="proc">
          <li>Let <i>status</i> be the result of performing BindingInitialization for <i>BindingPropertyList</i> using
              <i>value</i> and <i>environment</i> as arguments.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return the result of performing BindingInitialization for <i>BindingProperty</i> using <i>value</i> and
              <i>environment</i> as arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingProperty</span> <span class="geq">:</span> <span class="nt">SingleNameBinding</span></div>
        <ol class="proc">
          <li>Let <i>name</i> be the string that is the only element of BoundNames of <i>SingleNameBinding</i>.</li>
          <li>Return the result of performing KeyedBindingInitialization for <i>SingleNameBinding</i> using  <i>value</i>,
              <i>environment</i>, and <i>name</i> as the arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingProperty</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">BindingElement</span></div>
        <ol class="proc">
          <li>Let <i>P</i> be the result of evaluating <i>PropertyName</i></li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>P</i>).</li>
          <li>Return the result of performing KeyedBindingInitialization for <i>BindingElement</i> using <i>value</i>,
              <i>environment</i>, and <i>P</i> as arguments.</li>
        </ol>
      </section>

      <section id="sec-destructuring-binding-patterns-runtime-semantics-iteratorbindinginitialization">
        <h4 id="sec-13.3.3.6" title="13.3.3.6"> Runtime Semantics: IteratorBindingInitialization</h4><p>With parameters <var>iteratorRecord,</var> and  <var>environment</var>.</p>

        <p>See also: <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-runtime-semantics-iteratorbindinginitialization">14.1.18</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-runtime-semantics-iteratorbindinginitialization">14.2.14</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> When <b>undefined</b> is passed for <var>environment</var> it indicates that a <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a> operation should be used to assign the initialization value. This is the case for
          formal parameter lists of non-strict functions. In that case the formal parameter bindings are preinitialized in order
          to deal with the possibility of multiple parameters with the same name.</p>
        </div>

        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:               sans-serif">empty</span>).</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">Elision</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return the result of performing IteratorDestructuringAssignmentEvaluation of <i>Elision</i> with
              <i>iteratorRecord</i> as the argument.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingRestElement</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>If <i>Elision</i> is present, then
            <ol class="block">
              <li>Let <i>status</i> be the result of performing IteratorDestructuringAssignmentEvaluation of <i>Elision</i> with
                  <i>iteratorRecord</i> as the argument.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
            </ol>
          </li>
          <li>Return the result of performing IteratorBindingInitialization for <i>BindingRestElement</i>  with
              <i>iteratorRecord</i> and <i>environment</i> as arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">BindingElementList</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return the result of performing IteratorBindingInitialization for <i>BindingElementList</i> with
              <i>iteratorRecord</i> and <i>environment</i> as arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">BindingElementList</span> <code class="t">,</code> <code class="t">]</code></div>
        <ol class="proc">
          <li>Return the result of performing IteratorBindingInitialization for <i>BindingElementList</i> with
              <i>iteratorRecord</i> and <i>environment</i> as arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">BindingElementList</span> <code class="t">,</code> <span class="nt">Elision</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>status</i> be the result of performing IteratorBindingInitialization for <i>BindingElementList</i> with
              <i>iteratorRecord</i> and <i>environment</i> as arguments.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return the result of performing IteratorDestructuringAssignmentEvaluation of <i>Elision</i> with
              <i>iteratorRecord</i> as the argument.</li>
        </ol>
        <div class="gp prod"><span class="nt">ArrayBindingPattern</span> <span class="geq">:</span> <code class="t">[</code> <span class="nt">BindingElementList</span> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingRestElement</span> <code class="t">]</code></div>
        <ol class="proc">
          <li>Let <i>status</i> be the result of performing IteratorBindingInitialization for <i>BindingElementList</i> with
              <i>iteratorRecord</i> and <i>environment</i> as arguments.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>If <i>Elision</i> is present, then
            <ol class="block">
              <li>Let <i>status</i> be the result of performing IteratorDestructuringAssignmentEvaluation of <i>Elision</i> with
                  <i>iteratorRecord</i> as the argument.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
            </ol>
          </li>
          <li>Return the result of performing IteratorBindingInitialization for <i>BindingRestElement</i>  with
              <i>iteratorRecord</i> and <i>environment</i> as arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElementList</span> <span class="geq">:</span> <span class="nt">BindingElisionElement</span></div>
        <ol class="proc">
          <li>Return the result of performing IteratorBindingInitialization for <i>BindingElisionElement</i>  with
              <i>iteratorRecord</i> and <i>environment</i> as arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElementList</span> <span class="geq">:</span> <span class="nt">BindingElementList</span> <code class="t">,</code> <span class="nt">BindingElisionElement</span></div>
        <ol class="proc">
          <li>Let <i>status</i> be the result of performing IteratorBindingInitialization for <i>BindingElementList</i>
              <i>with</i> <i>iteratorRecord</i> and <i>environment</i> as arguments.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return the result of performing IteratorBindingInitialization for <i>BindingElisionElement</i> using
              <i>iteratorRecord</i> and <i>environment</i> as arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElisionElement</span> <span class="geq">:</span> <span class="nt">BindingElement</span></div>
        <ol class="proc">
          <li>Return the result of performing IteratorBindingInitialization of <i>BindingElement</i> with <i>iteratorRecord</i>
              and <i>environment</i> as the arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElisionElement</span> <span class="geq">:</span> <span class="nt">Elision</span> <span class="nt">BindingElement</span></div>
        <ol class="proc">
          <li>Let <i>status</i> be the result of performing IteratorDestructuringAssignmentEvaluation of <i>Elision</i> with
              <i>iteratorRecord</i> as the argument.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Return the result of performing IteratorBindingInitialization of <i>BindingElement</i> with <i>iteratorRecord</i>
              and <i>environment</i> as the arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElement</span> <span class="geq">:</span> <span class="nt">SingleNameBinding</span></div>
        <ol class="proc">
          <li>Return the result of performing IteratorBindingInitialization for <i>SingleNameBinding</i> with <i>iteratorRecord
              and</i> <i>environment</i> as the arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">SingleNameBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ol class="proc">
          <li>Let <i>bindingId</i> be StringValue of <i>BindingIdentifier.</i></li>
          <li>Let <i>lhs</i> be <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(<i>bindingId</i>, <i>environment</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lhs</i>).</li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, then
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iteratorRecord</i>.[[iterator]]).</li>
              <li>If <i>next</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                  <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, set <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
                  <li>If <i>v</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                      <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>true</b>, let <i>v</i> be <b>undefined</b>.</li>
          <li>If <i>Initializer</i> is present and <i>v</i> is <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>defaultValue</i> be the result of evaluating <i>Initializer</i>.</li>
              <li>Let <i>v</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>defaultValue</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
              <li>If <a href="sec-ecmascript-language-functions-and-classes#sec-isanonymousfunctiondefinition">IsAnonymousFunctionDefinition</a>(<i>Initializer)</i> is
                  <b>true</b>, then
                <ol class="block">
                  <li>Let <i>hasNameProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>v</i>,
                      <code>"name"</code>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasNameProperty</i>).</li>
                  <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>v</i>, <i>bindingId</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>environment</i> is <b>undefined</b>, return <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lhs</i>, <i>v</i>).</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-initializereferencedbinding">InitializeReferencedBinding</a>(<i>lhs</i>, <i>v</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingElement</span> <span class="geq">:</span> <span class="nt">BindingPattern</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ol class="proc">
          <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, then
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iteratorRecord</i>.[[iterator]]).</li>
              <li>If <i>next</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                  <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, set <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li>Else
                <ol class="block">
                  <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
                  <li>If <i>v</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                      <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>iteratorRecord</i>.[[done]] is <b>true</b>, let <i>v</i> be <b>undefined</b>.</li>
          <li>If <i>Initializer</i> is present and <i>v</i> is <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>defaultValue</i> be the result of evaluating <i>Initializer</i>.</li>
              <li>Let <i>v</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>defaultValue</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
            </ol>
          </li>
          <li>Return the result of performing BindingInitialization of <i>BindingPattern</i> with <i>v</i> and <i>environment</i>
              as the arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">BindingRestElement</span> <span class="geq">:</span> <code class="t">...</code> <span class="nt">BindingIdentifier</span></div>
        <ol class="proc">
          <li>Let <i>lhs</i> be <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(StringValue of <i>BindingIdentifier,
              environment</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lhs</i>).</li>
          <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0).</li>
          <li>Let <i>n</i>=0.</li>
          <li>Repeat<b>,</b>
            <ol class="block">
              <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>,
                <ol class="block">
                  <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iteratorRecord</i>.[[iterator]]).</li>
                  <li>If <i>next</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                      <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
                  <li>If <i>next</i> is <b>false</b>, set <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                </ol>
              </li>
              <li>If <i>iteratorRecord</i>.[[done]] is <b>true</b>, then
                <ol class="block">
                  <li>If <i>environment</i> is <b>undefined</b>, return <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lhs</i>,
                      <i>A</i>).</li>
                  <li>Return <a href="sec-ecmascript-data-types-and-values#sec-initializereferencedbinding">InitializeReferencedBinding</a>(<i>lhs</i>,
                      <i>A</i>).</li>
                </ol>
              </li>
              <li>Let <i>nextValue</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
              <li>If <i>nextValue</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                  <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextValue</i>).</li>
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a> (<i>n</i>), <i>nextValue</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is <b>true</b>.</li>
              <li>Increment <i>n</i> by 1.</li>
            </ol>
          </li>
        </ol>
      </section>

      <section id="sec-runtime-semantics-keyedbindinginitialization">
        <h4 id="sec-13.3.3.7" title="13.3.3.7"> Runtime Semantics: KeyedBindingInitialization</h4><p>With parameters <var>value</var>, <var>environment,</var> and  <var>propertyName</var>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> When <b>undefined</b> is passed for <var>environment</var> it indicates that a <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a> operation should be used to assign the initialization value. This is the case for
          formal parameter lists of non-strict functions. In that case the formal parameter bindings are preinitialized in order
          to deal with the possibility of multiple parameters with the same name.</p>
        </div>

        <div class="gp prod"><span class="nt">BindingElement</span> <span class="geq">:</span> <span class="nt">BindingPattern</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ol class="proc">
          <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-getv">GetV</a>(<i>value</i>, <i>propertyName</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
          <li>If <i>Initializer</i> is present and <i>v</i> is <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>defaultValue</i> be the result of evaluating <i>Initializer</i>.</li>
              <li>Let <i>v</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>defaultValue</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
            </ol>
          </li>
          <li>Return the result of performing BindingInitialization for <i>BindingPattern</i> passing <i>v</i> and
              <i>environment</i> as arguments.</li>
        </ol>
        <div class="gp prod"><span class="nt">SingleNameBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
        <ol class="proc">
          <li>Let <i>bindingId</i> be StringValue of <i>BindingIdentifier.</i></li>
          <li>Let <i>lhs</i> be <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(<i>bindingId, environment</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lhs</i>).</li>
          <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-getv">GetV</a>(<i>value</i>, <i>propertyName</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
          <li>If <i>Initializer</i> is present and <i>v</i> is <b>undefined</b>, then
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
                  <li>If <i>hasNameProperty</i> is <b>false</b>, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>v</i>, <i>bindingId</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>environment</i> is <b>undefined</b>, return <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lhs</i>, <i>v</i>).</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-initializereferencedbinding">InitializeReferencedBinding</a>(<i>lhs</i>, <i>v</i>).</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-empty-statement">
    <div class="front">
      <h2 id="sec-13.4" title="13.4"> Empty
          Statement</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">EmptyStatement</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">;</code></div>
      </div>
    </div>

    <section id="sec-empty-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.4.1" title="13.4.1"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">EmptyStatement</span> <span class="geq">:</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>)<span style="font-family: sans-serif">.</span></li>
      </ol>
    </section>
  </section>

  <section id="sec-expression-statement">
    <div class="front">
      <h2 id="sec-13.5" title="13.5">
          Expression Statement</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">ExpressionStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="grhsannot">[lookahead &notin; {<code class="t">{</code>, <code class="t">function</code>, <code class="t">class</code>, <code class="t">let [</code>}]</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">;</code></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE</span> An <span class="nt">ExpressionStatement</span> cannot start with a U+007B (LEFT CURLY
        BRACKET) because that might make it ambiguous with a <span class="nt">Block</span>. Also, an <span class="nt">ExpressionStatement</span> cannot start with the <code>function</code> or <code>class</code> keywords because
        that would make it ambiguous with a <span class="nt">FunctionDeclaration</span>, a <span class="nt">GeneratorDeclaration</span>, or a <span class="nt">ClassDeclaration</span>. An <span class="nt">ExpressionStatement</span> cannot start with the two token sequence <code>let [</code> because that would make
        it ambiguous with a <code>let</code> <span class="nt">LexicalDeclaration</span> whose first <span class="nt">LexicalBinding</span> was an <span class="nt">ArrayBindingPattern</span>.</p>
      </div>
    </div>

    <section id="sec-expression-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.5.1" title="13.5.1"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">ExpressionStatement</span> <span class="geq">:</span> <span class="nt">Expression</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>Let <i>exprRef</i> be the result of evaluating <i>Expression</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
      </ol>
    </section>
  </section>

  <section id="sec-if-statement">
    <div class="front">
      <h2 id="sec-13.6" title="13.6"> The
          </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">IfStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub> <code class="t">else</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <p>Each <code>else</code> for which the choice of associated <code>if</code> is ambiguous shall be associated with the
      nearest possible <b>if</b> that would otherwise have no corresponding <code>else</code>.</p>
    </div>

    <section id="sec-if-statement-static-semantics-early-errors">
      <h3 id="sec-13.6.1" title="13.6.1"> Static Semantics:  Early Errors</h3><div class="gp">
        <div class="lhs"><span class="nt">IfStatement</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span> <code class="t">else</code> <span class="nt">Statement</span></div>
        <div class="rhs"><code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      </div>

      <ul>
        <li>It is a Syntax Error if <a href="#sec-islabelledfunction">IsLabelledFunction</a>(<span class="nt">Statement</span>) is
            <span class="value">true</span>.</li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE</span> It is only necessary to apply this rule if the extension specified in  <a href="sec-additional-ecmascript-features-for-web-browsers#sec-labelled-function-declarations">B.3.2</a> is implemented.</p>
      </div>
    </section>

    <section id="sec-if-statement-static-semantics-containsduplicatelabels">
      <h3 id="sec-13.6.2" title="13.6.2"> Static Semantics: ContainsDuplicateLabels</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span> <code class="t">else</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsDuplicateLabels of <i>the first Statement</i> with argument
            <i>labelSet</i>.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsDuplicateLabels of <i>the second Statement</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return ContainsDuplicateLabels of <i>Statement</i> with argument <i>labelSet.</i></li>
      </ol>
    </section>

    <section id="sec-if-statement-static-semantics-containsundefinedbreaktarget">
      <h3 id="sec-13.6.3" title="13.6.3"> Static Semantics: ContainsUndefinedBreakTarget</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span> <code class="t">else</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedBreakTarget of <i>the first Statement</i> with argument
            <i>labelSet</i>.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedBreakTarget of <i>the second Statement</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return ContainsUndefinedBreakTarget of <i>Statement</i> with argument <i>labelSet.</i></li>
      </ol>
    </section>

    <section id="sec-if-statement-static-semantics-containsundefinedcontinuetarget">
      <h3 id="sec-13.6.4" title="13.6.4"> Static Semantics: ContainsUndefinedContinueTarget</h3><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>,<a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span> <code class="t">else</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedContinueTarget of <i>the first Statement</i> with arguments
            <i>iterationSet</i> and &laquo; &raquo;.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedContinueTarget of <i>the second Statement</i> with arguments <i>iterationSet</i> and &laquo;
            &raquo;<i>.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return ContainsUndefinedContinueTarget of <i>Statement</i> with arguments <i>iterationSet</i> and &laquo;
            &raquo;<i>.</i></li>
      </ol>
    </section>

    <section id="sec-if-statement-static-semantics-vardeclarednames">
      <h3 id="sec-13.6.5" title="13.6.5"> Static Semantics:  VarDeclaredNames</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span> <code class="t">else</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be VarDeclaredNames of the first <i>Statement</i>.</li>
        <li>Append to <i>names</i> the elements of the VarDeclaredNames of the second <i>Statement.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return the VarDeclaredNames of <i>Statement</i>.</li>
      </ol>
    </section>

    <section id="sec-if-statement-static-semantics-varscopeddeclarations">
      <h3 id="sec-13.6.6" title="13.6.6"> Static Semantics:  VarScopedDeclarations</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span> <code class="t">else</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Let <i>declarations</i> be VarScopedDeclarations of the first <i>Statement</i>.</li>
        <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of the second <i>Statement.</i></li>
        <li>Return <i>declarations</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return the VarScopedDeclarations of <i>Statement</i>.</li>
      </ol>
    </section>

    <section id="sec-if-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.6.7" title="13.6.7"> Runtime Semantics:  Evaluation</h3><div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span> <code class="t">else</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Let <i>exprRef</i> be the result of evaluating <i>Expression</i>.</li>
        <li>Let <i>exprValue</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exprValue</i>).</li>
        <li>If <i>exprValue</i> is <b>true</b>, then
          <ol class="block">
            <li>Let <i>stmtCompletion</i> be the result of evaluating the first <i>Statement</i>.</li>
          </ol>
        </li>
        <li>Else,
          <ol class="block">
            <li>Let <i>stmtCompletion</i> be the result of evaluating the second <i>Statement</i>.</li>
          </ol>
        </li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>stmtCompletion</i>).</li>
        <li>If <i>stmtCompletion</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, return
            <i>stmtCompletion</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
      </ol>
      <div class="gp prod"><span class="nt">IfStatement</span> <span class="geq">:</span> <code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Let <i>exprRef</i> be the result of evaluating <i>Expression</i>.</li>
        <li>Let <i>exprValue</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exprValue</i>).</li>
        <li>If <i>exprValue</i> is <b>false</b>, then
          <ol class="block">
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
          </ol>
        </li>
        <li>Else,
          <ol class="block">
            <li>Let <i>stmtCompletion</i> be the result of evaluating <i>Statement</i>.</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>stmtCompletion</i>).</li>
            <li>If <i>stmtCompletion</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, return
                <i>stmtCompletion</i>.</li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
          </ol>
        </li>
      </ol>
    </section>
  </section>

  <section id="sec-iteration-statements">
    <div class="front">
      <h2 id="sec-13.7" title="13.7">
          Iteration Statements</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">IterationStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">do</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <code class="t">;</code></div>
        <div class="rhs"><code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="grhsannot">[lookahead &notin; {<code class="t">let [</code>}]</span> <span class="nt">Expression</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">VariableDeclarationList</span><sub class="g-params">[?Yield]</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span><sub class="g-params">[?Yield]</sub> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="grhsannot">[lookahead &notin; {<code class="t">let [</code>}]</span> <span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">in</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span><sub class="g-params">[?Yield]</sub> <code class="t">in</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span><sub class="g-params">[?Yield]</sub> <code class="t">in</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="grhsannot">[lookahead &ne; let ]</span> <span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">of</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span><sub class="g-params">[?Yield]</sub> <code class="t">of</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span><sub class="g-params">[?Yield]</sub> <code class="t">of</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ForDeclaration</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">LetOrConst</span> <span class="nt">ForBinding</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ForBinding</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">BindingPattern</span><sub class="g-params">[?Yield]</sub></div>
      </div>
    </div>

    <section id="sec-iteration-statements-semantics">
      <div class="front">
        <h3 id="sec-13.7.1" title="13.7.1"> Semantics</h3></div>

      <section id="sec-semantics-static-semantics-early-errors">
        <h4 id="sec-13.7.1.1" title="13.7.1.1"> Static Semantics:  Early Errors</h4><div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">do</code> <span class="nt">Statement</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <code class="t">;</code></div>
          <div class="rhs"><code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">VariableDeclarationList</span> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        </div>

        <ul>
          <li>It is a Syntax Error if <a href="#sec-islabelledfunction">IsLabelledFunction</a>(<span class="nt">Statement</span>)
              is <span class="value">true</span>.</li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> It is only necessary to apply this rule if the extension specified in  <a href="sec-additional-ecmascript-features-for-web-browsers#sec-labelled-function-declarations">B.3.2</a> is implemented.</p>
        </div>
      </section>

      <section id="sec-loopcontinues">
        <h4 id="sec-13.7.1.2" title="13.7.1.2">
            Runtime Semantics: LoopContinues(completion, labelSet)</h4><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">LoopContinues</span> with
        arguments <var>completion</var> and <var>labelSet</var> is defined by the following steps:</p>

        <ol class="proc">
          <li>If <i>completion</i>.[[type]] is <span style="font-family: sans-serif">normal</span>, return <b>true</b>.</li>
          <li>If <i>completion</i>.[[type]] is not <span style="font-family: sans-serif">continue</span>, return
              <b>false</b>.</li>
          <li>If <i>completion</i>.[[target]] is <span style="font-family: sans-serif">empty</span>, return <b>true</b>.</li>
          <li>If <i>completion</i>.[[target]] is an element of <i>labelSet</i>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> Within the <span class="nt">Statement</span> part of an <span class="nt">IterationStatement</span> a <span class="nt">ContinueStatement</span> may be used to begin a new
          iteration.</p>
        </div>
      </section>
    </section>

    <section id="sec-do-while-statement">
      <div class="front">
        <h3 id="sec-13.7.2" title="13.7.2">
            The </h3></div>

      <section id="sec-do-while-statement-static-semantics-containsduplicatelabels">
        <h4 id="sec-13.7.2.1" title="13.7.2.1"> Static Semantics: ContainsDuplicateLabels</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">do</code> <span class="nt">Statement</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return ContainsDuplicateLabels of <i>Statement</i> with argument <i>labelSet.</i></li>
        </ol>
      </section>

      <section id="sec-do-while-statement-static-semantics-containsundefinedbreaktarget">
        <h4 id="sec-13.7.2.2" title="13.7.2.2"> Static Semantics: ContainsUndefinedBreakTarget</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">do</code> <span class="nt">Statement</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return ContainsUndefinedBreakTarget of <i>Statement</i> with argument <i>labelSet.</i></li>
        </ol>
      </section>

      <section id="sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">
        <h4 id="sec-13.7.2.3" title="13.7.2.3"> Static Semantics: ContainsUndefinedContinueTarget</h4><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>,<a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">do</code> <span class="nt">Statement</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return ContainsUndefinedContinueTarget of <i>Statement</i> with arguments <i>iterationSet</i> and
              &laquo;&nbsp;&raquo;<i>.</i></li>
        </ol>
      </section>

      <section id="sec-do-while-statement-static-semantics-vardeclarednames">
        <h4 id="sec-13.7.2.4" title="13.7.2.4"> Static Semantics:  VarDeclaredNames</h4><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">do</code> <span class="nt">Statement</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return the VarDeclaredNames of <i>Statement</i>.</li>
        </ol>
      </section>

      <section id="sec-do-while-statement-static-semantics-varscopeddeclarations">
        <h4 id="sec-13.7.2.5" title="13.7.2.5"> Static Semantics:  VarScopedDeclarations</h4><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">do</code> <span class="nt">Statement</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <code class="t">;</code></div>
        <ol class="proc">
          <li>Return the VarScopedDeclarations of <i>Statement</i>.</li>
        </ol>
      </section>

      <section id="sec-do-while-statement-runtime-semantics-labelledevaluation">
        <h4 id="sec-13.7.2.6" title="13.7.2.6"> Runtime Semantics: LabelledEvaluation</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-runtime-semantics-labelledevaluation">13.1.7</a>, <a href="#sec-while-statement-runtime-semantics-labelledevaluation">13.7.3.6</a>, <a href="#sec-for-statement-runtime-semantics-labelledevaluation">13.7.4.7</a>, <a href="#sec-for-in-and-for-of-statements-runtime-semantics-labelledevaluation">13.7.5.11</a>, <a href="#sec-labelled-statements-runtime-semantics-labelledevaluation">13.13.14</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">do</code> <span class="nt">Statement</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <code class="t">;</code></div>
        <ol class="proc">
          <li>Let <i>V</i> = <b>undefined</b>.</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>stmt</i> be the result of evaluating <i>Statement</i>.</li>
              <li>If <a href="#sec-loopcontinues">LoopContinues</a>(<i>stmt</i>, <i>labelSet</i>) is <b>false</b>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>stmt</i>, <i>V</i>)).</li>
              <li>If <i>stmt</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, let <i>V</i> =
                  <i>stmt</i>.[[value]]<i>.</i></li>
              <li>Let <i>exprRef</i> be the result of evaluating <i>Expression</i>.</li>
              <li>Let <i>exprValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exprValue</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<i>exprValue</i>) is <b>false</b>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>V</i>).</li>
            </ol>
          </li>
        </ol>
      </section>
    </section>

    <section id="sec-while-statement">
      <div class="front">
        <h3 id="sec-13.7.3" title="13.7.3"> The
            </h3></div>

      <section id="sec-while-statement-static-semantics-containsduplicatelabels">
        <h4 id="sec-13.7.3.1" title="13.7.3.1"> Static Semantics: ContainsDuplicateLabels</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return ContainsDuplicateLabels of <i>Statement</i> with argument <i>labelSet.</i></li>
        </ol>
      </section>

      <section id="sec-while-statement-static-semantics-containsundefinedbreaktarget">
        <h4 id="sec-13.7.3.2" title="13.7.3.2"> Static Semantics: ContainsUndefinedBreakTarget</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return ContainsUndefinedBreakTarget of <i>Statement</i> with argument <i>labelSet.</i></li>
        </ol>
      </section>

      <section id="sec-while-statement-static-semantics-containsundefinedcontinuetarget">
        <h4 id="sec-13.7.3.3" title="13.7.3.3"> Static Semantics: ContainsUndefinedContinueTarget</h4><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>,<a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return ContainsUndefinedContinueTarget of <i>Statement</i> with arguments <i>iterationSet</i> and
              &laquo;&nbsp;&raquo;<i>.</i></li>
        </ol>
      </section>

      <section id="sec-while-statement-static-semantics-vardeclarednames">
        <h4 id="sec-13.7.3.4" title="13.7.3.4"> Static Semantics:  VarDeclaredNames</h4><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarDeclaredNames of <i>Statement</i>.</li>
        </ol>
      </section>

      <section id="sec-while-statement-static-semantics-varscopeddeclarations">
        <h4 id="sec-13.7.3.5" title="13.7.3.5"> Static Semantics:  VarScopedDeclarations</h4><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarScopedDeclarations of <i>Statement</i>.</li>
        </ol>
      </section>

      <section id="sec-while-statement-runtime-semantics-labelledevaluation">
        <h4 id="sec-13.7.3.6" title="13.7.3.6"> Runtime Semantics: LabelledEvaluation</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-runtime-semantics-labelledevaluation">13.1.7</a>, <a href="#sec-do-while-statement-runtime-semantics-labelledevaluation">13.7.2.6</a>, <a href="#sec-for-statement-runtime-semantics-labelledevaluation">13.7.4.7</a>, <a href="#sec-for-in-and-for-of-statements-runtime-semantics-labelledevaluation">13.7.5.11</a>, <a href="#sec-labelled-statements-runtime-semantics-labelledevaluation">13.13.14</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>V</i> = <b>undefined</b>.</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>exprRef</i> be the result of evaluating <i>Expression</i>.</li>
              <li>Let <i>exprValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exprValue</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<i>exprValue</i>) is <b>false</b>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>V</i>).</li>
              <li>Let <i>stmt</i> be the result of evaluating <i>Statement</i>.</li>
              <li>If <a href="#sec-loopcontinues">LoopContinues</a> (<i>stmt</i>, <i>labelSet</i>) is <b>false</b>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>stmt</i>, <i>V</i>)).</li>
              <li>If <i>stmt</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, let <i>V</i> =
                  <i>stmt</i>.[[value]].</li>
            </ol>
          </li>
        </ol>
      </section>
    </section>

    <section id="sec-for-statement">
      <div class="front">
        <h3 id="sec-13.7.4" title="13.7.4"> The
            </h3></div>

      <section id="sec-for-statement-static-semantics-early-errors">
        <h4 id="sec-13.7.4.1" title="13.7.4.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ul>
          <li>
            <p>It is a Syntax Error if any element of the BoundNames of <span class="nt">LexicalDeclaration</span> also occurs in
            the VarDeclaredNames of <span class="nt">Statement</span>.</p>
          </li>
        </ul>
      </section>

      <section id="sec-for-statement-static-semantics-containsduplicatelabels">
        <h4 id="sec-13.7.4.2" title="13.7.4.2"> Static Semantics: ContainsDuplicateLabels</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">VariableDeclarationList</span> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        </div>

        <ol class="proc">
          <li>Return ContainsDuplicateLabels of <i>Statement</i> with argument <i>labelSet.</i></li>
        </ol>
      </section>

      <section id="sec-for-statement-static-semantics-containsundefinedbreaktarget">
        <h4 id="sec-13.7.4.3" title="13.7.4.3"> Static Semantics: ContainsUndefinedBreakTarget</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">VariableDeclarationList</span> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        </div>

        <ol class="proc">
          <li>Return ContainsUndefinedBreakTarget of <i>Statement</i> with argument <i>labelSet.</i></li>
        </ol>
      </section>

      <section id="sec-for-statement-static-semantics-containsundefinedcontinuetarget">
        <h4 id="sec-13.7.4.4" title="13.7.4.4"> Static Semantics: ContainsUndefinedContinueTarget</h4><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>,<a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">VariableDeclarationList</span> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        </div>

        <ol class="proc">
          <li>Return ContainsUndefinedContinueTarget of <i>Statement</i> with arguments <i>iterationSet</i> and
              &laquo;&nbsp;&raquo;<i>.</i></li>
        </ol>
      </section>

      <section id="sec-for-statement-static-semantics-vardeclarednames">
        <h4 id="sec-13.7.4.5" title="13.7.4.5"> Static Semantics:  VarDeclaredNames</h4><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarDeclaredNames of <i>Statement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">VariableDeclarationList</span> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be BoundNames of <i>VariableDeclarationList</i>.</li>
          <li>Append to <i>names</i> the elements of the VarDeclaredNames of <i>Statement.</i></li>
          <li>Return <i>names</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarDeclaredNames of <i>Statement</i>.</li>
        </ol>
      </section>

      <section id="sec-for-statement-static-semantics-varscopeddeclarations">
        <h4 id="sec-13.7.4.6" title="13.7.4.6"> Static Semantics:  VarScopedDeclarations</h4><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarScopedDeclarations of <i>Statement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">VariableDeclarationList</span> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>declarations</i> be VarScopedDeclarations of <i>VariableDeclarationList</i>.</li>
          <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of <i>Statement.</i></li>
          <li>Return <i>declarations</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarScopedDeclarations of <i>Statement</i>.</li>
        </ol>
      </section>

      <section id="sec-for-statement-runtime-semantics-labelledevaluation">
        <h4 id="sec-13.7.4.7" title="13.7.4.7"> Runtime Semantics: LabelledEvaluation</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-runtime-semantics-labelledevaluation">13.1.7</a>, <a href="#sec-do-while-statement-runtime-semantics-labelledevaluation">13.7.2.6</a>, <a href="#sec-while-statement-runtime-semantics-labelledevaluation">13.7.3.6</a>, <a href="#sec-for-in-and-for-of-statements-runtime-semantics-labelledevaluation">13.7.5.11</a>, <a href="#sec-labelled-statements-runtime-semantics-labelledevaluation">13.13.14</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>If the first <i>Expression</i> is present, then
            <ol class="block">
              <li>Let <i>exprRef</i> be the result of evaluating the first <i>Expression</i>.</li>
              <li>Let <i>exprValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exprValue</i>).</li>
            </ol>
          </li>
          <li>Return <a href="#sec-forbodyevaluation">ForBodyEvaluation</a>(the second <i>Expression</i>, the third
              <i>Expression</i>, <i>Statement</i>, &laquo; &raquo;, <i>labelSet</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">VariableDeclarationList</span> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>varDcl</i> be the result of evaluating <i>VariableDeclarationList</i>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>varDcl</i>).</li>
          <li>Return <a href="#sec-forbodyevaluation">ForBodyEvaluation</a>(the first <i>Expression</i>, the second
              <i>Expression</i>, <i>Statement</i>, &laquo;&nbsp;&raquo;, <i>labelSet</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>oldEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
          <li>Let <i>loopEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>oldEnv</i>).</li>
          <li>Let <i>isConst</i> be the result of performing IsConstantDeclaration of <i>LexicalDeclaration</i>.</li>
          <li>Let <i>boundNames</i> be the BoundNames of <i>LexicalDeclaration</i>.</li>
          <li>For each element <i>dn</i> of <i>boundNames</i> do
            <ol class="block">
              <li>If <i>isConst</i> is <b>true</b>, then
                <ol class="block">
                  <li>Perform <i>loopEnv</i>.CreateImmutableBinding(<i>dn</i>, <b>true</b>).</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Perform <i>loopEnv</i>.CreateMutableBinding(<i>dn,</i> <b>false</b>).</li>
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The above call to CreateMutableBinding will never return an
                      <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>loopEnv</i>.</li>
          <li>Let <i>forDcl</i> be the result of evaluating <i>LexicalDeclaration</i>.</li>
          <li>If <i>forDcl</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
            <ol class="block">
              <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>oldEnv</i>.</li>
              <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>forDcl</i>).</li>
            </ol>
          </li>
          <li>If <i>isConst</i> is <b>false</b>, let <i>perIterationLets</i> be <i>boundNames</i> otherwise let
              <i>perIterationLets</i> be &laquo; &raquo;.</li>
          <li>Let <i>bodyResult</i> be <a href="#sec-forbodyevaluation">ForBodyEvaluation</a>(the first <i>Expression</i>, the
              second <i>Expression</i>, <i>Statement</i>, <i>perIterationLets</i>, <i>labelSet</i>).</li>
          <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>oldEnv</i>.</li>
          <li>Return  <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>bodyResult</i>).</li>
        </ol>
      </section>

      <section id="sec-forbodyevaluation">
        <h4 id="sec-13.7.4.8" title="13.7.4.8"> Runtime Semantics: ForBodyEvaluation( test, increment, stmt,
            perIterationBindings, labelSet )</h4><p class="normalbefore">The abstract operation ForBodyEvaluation with arguments <var>test</var>, <var>increment</var>,
        <var>stmt</var>, <var>perIterationBindings</var>, and <var>labelSet</var> is performed as follows:</p>

        <ol class="proc">
          <li>Let <i>V</i> = <b>undefined</b>.</li>
          <li>Let <i>status</i> be <a href="#sec-createperiterationenvironment">CreatePerIterationEnvironment</a>(<i>perIterationBindings</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Repeat
            <ol class="block">
              <li>If <i>test</i> is not <span style="font-family: sans-serif">[empty]</span>, then
                <ol class="block">
                  <li>Let <i>testRef</i> be the result of evaluating <i>test</i>.</li>
                  <li>Let <i>testValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>testRef</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>testValue</i>).</li>
                  <li>If <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<i>testValue</i>) is <b>false</b>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>V</i>).</li>
                </ol>
              </li>
              <li>Let <i>result</i> be the result of evaluating <i>stmt</i>.</li>
              <li>If <a href="#sec-loopcontinues">LoopContinues</a>(<i>result</i>, <i>labelSet</i>) is <b>false</b>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>result</i>, <i>V</i>)).</li>
              <li>If <i>result</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, let <i>V</i> =
                  <i>result</i>.[[value]].</li>
              <li>Let <i>status</i> be <a href="#sec-createperiterationenvironment">CreatePerIterationEnvironment</a>(<i>perIterationBindings</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
              <li>If <i>increment</i> is not <span style="font-family: sans-serif">[empty]</span>, then
                <ol class="block">
                  <li>Let <i>incRef</i> be the result of evaluating <i>increment</i>.</li>
                  <li>Let <i>incValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>incRef</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>incValue</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
        </ol>
      </section>

      <section id="sec-createperiterationenvironment">
        <h4 id="sec-13.7.4.9" title="13.7.4.9"> Runtime Semantics: CreatePerIterationEnvironment(
            perIterationBindings )</h4><p class="normalbefore">The abstract operation CreatePerIterationEnvironment with argument <var>perIterationBindings</var>
        is performed as follows:</p>

        <ol class="proc">
          <li>If <i>perIterationBindings</i> has any elements, then
            <ol class="block">
              <li>Let <i>lastIterationEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
              <li>Let <i>outer</i> be <i>lastIterationEnv</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">outer environment
                  reference</a>.</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>outer</i> is not <b>null</b>.</li>
              <li>Let <i>thisIterationEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>outer</i>).</li>
              <li>For each element <i>bn</i> of <i>perIterationBindings</i> do,
                <ol class="block">
                  <li>Let <i>status</i> be <i>thisIterationEnv</i>.CreateMutableBinding(<i>bn</i>, <b>false</b>).</li>
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                  <li>Let <i>lastValue</i> be <i>lastIterationEnv</i>.GetBindingValue(<i>bn</i>, <b>true</b>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lastValue</i>).</li>
                  <li>Perform <i>thisIterationEnv</i>.InitializeBinding(<i>bn</i>, <i>lastValue</i>).</li>
                </ol>
              </li>
              <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>thisIterationEnv.</i></li>
            </ol>
          </li>
          <li>Return <b>undefined</b></li>
        </ol>
      </section>
    </section>

    <section id="sec-for-in-and-for-of-statements">
      <div class="front">
        <h3 id="sec-13.7.5" title="13.7.5"> The </h3></div>

      <section id="sec-for-in-and-for-of-statements-static-semantics-early-errors">
        <h4 id="sec-13.7.5.1" title="13.7.5.1"> Static Semantics:  Early Errors</h4><div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        </div>

        <ul>
          <li>
            <p>It is a Syntax Error if <span class="nt">LeftHandSideExpression</span> is either an <span class="nt">ObjectLiteral</span> or an <span class="nt">ArrayLiteral</span> and if the lexical token sequence matched
            by <span class="nt">LeftHandSideExpression</span> cannot be parsed with no tokens left over using <span class="nt">AssignmentPattern</span> as the goal symbol.</p>
          </li>
        </ul>

        <p>If <span class="nt">LeftHandSideExpression</span> is either an <span class="nt">ObjectLiteral</span> or an <span class="nt">ArrayLiteral</span> and if the lexical token sequence matched by <span class="nt">LeftHandSideExpression</span>
        can be parsed with no tokens left over using <span class="nt">AssignmentPattern</span> as the goal symbol then the
        following rules are not applied. Instead, the Early Error rules for <span class="nt">AssignmentPattern</span> are
        used.</p>

        <ul>
          <li>
            <p>It is a Syntax Error if <span style="font-family: Times New Roman">IsValidSimpleAssignmentTarget</span> of <span class="nt">LeftHandSideExpression</span> is <span class="value">false</span>.</p>
          </li>

          <li>
            <p>It is a Syntax Error if the <span class="nt">LeftHandSideExpression</span> is                    <span class="prod"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span> <span class="geq">:</span>
            <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code></span> and <span class="nt">Expression</span> derives a production that would produce a Syntax Error according to these rules if that
            production is substituted for <span class="nt">LeftHandSideExpression</span>. This rule is recursively applied.</p>
          </li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> The last rule means that the other rules are applied even if parentheses surround <span class="nt">Expression</span>.</p>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        </div>

        <ul>
          <li>
            <p>It is a Syntax Error if the BoundNames of <span class="nt">ForDeclaration</span> contains <code>"let"</code>.</p>
          </li>

          <li>
            <p>It is a Syntax Error if any element of the BoundNames of <span class="nt">ForDeclaration</span> also occurs in the
            VarDeclaredNames of <span class="nt">Statement</span>.</p>
          </li>

          <li>
            <p>It is a Syntax Error if the BoundNames of <span class="nt">ForDeclaration</span> contains any duplicate
            entries.</p>
          </li>
        </ul>
      </section>

      <section id="sec-for-in-and-for-of-statements-static-semantics-boundnames">
        <h4 id="sec-13.7.5.2" title="13.7.5.2"> Static Semantics:  BoundNames</h4><p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-boundnames">12.1.2</a>, <a href="#sec-let-and-const-declarations-static-semantics-boundnames">13.3.1.2</a>, <a href="#sec-variable-statement-static-semantics-boundnames">13.3.2.1</a>, <a href="#sec-destructuring-binding-patterns-static-semantics-boundnames">13.3.3.1</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-boundnames">14.1.3</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-boundnames">14.2.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions-static-semantics-boundnames">14.4.2</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-boundnames">14.5.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-imports-static-semantics-boundnames">15.2.2.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-boundnames">15.2.3.2</a>.</p>

        <div class="gp prod"><span class="nt">ForDeclaration</span> <span class="geq">:</span> <span class="nt">LetOrConst</span> <span class="nt">ForBinding</span></div>
        <ol class="proc">
          <li>Return the BoundNames of <i>ForBinding</i>.</li>
        </ol>
      </section>

      <section id="sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">
        <h4 id="sec-13.7.5.3" title="13.7.5.3"> Static Semantics: ContainsDuplicateLabels</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        </div>

        <ol class="proc">
          <li>Return ContainsDuplicateLabels of <i>Statement</i> with argument <i>labelSet.</i></li>
        </ol>
      </section>

      <section id="sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">
        <h4 id="sec-13.7.5.4" title="13.7.5.4"> Static Semantics: ContainsUndefinedBreakTarget</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        </div>

        <ol class="proc">
          <li>Return ContainsUndefinedBreakTarget of <i>Statement</i> with argument <i>labelSet.</i></li>
        </ol>
      </section>

      <section id="sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">
        <h4 id="sec-13.7.5.5" title="13.7.5.5"> Static Semantics: ContainsUndefinedContinueTarget</h4><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>,<a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
          <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        </div>

        <ol class="proc">
          <li>Return ContainsUndefinedContinueTarget of <i>Statement</i> with arguments <i>iterationSet</i> and
              &laquo;&nbsp;&raquo;<i>.</i></li>
        </ol>
      </section>

      <section id="sec-for-in-and-for-of-statements-static-semantics-isdestructuring">
        <h4 id="sec-13.7.5.6" title="13.7.5.6"> Static Semantics:  IsDestructuring</h4><p>See also: <a href="sec-ecmascript-language-expressions#sec-static-semantics-static-semantics-isdestructuring">12.3.1.3</a>.</p>

        <div class="gp prod"><span class="nt">ForDeclaration</span> <span class="geq">:</span> <span class="nt">LetOrConst</span> <span class="nt">ForBinding</span></div>
        <ol class="proc">
          <li>Return IsDestructuring of <i>ForBinding</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ForBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
        <div class="gp prod"><span class="nt">ForBinding</span> <span class="geq">:</span> <span class="nt">BindingPattern</span></div>
        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">
        <h4 id="sec-13.7.5.7" title="13.7.5.7"> Static Semantics:  VarDeclaredNames</h4><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarDeclaredNames of <i>Statement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be the BoundNames of <i>ForBinding</i>.</li>
          <li>Append to <i>names</i> the elements of the VarDeclaredNames of <i>Statement.</i></li>
          <li>Return <i>names.</i></li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarDeclaredNames of <i>Statement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarDeclaredNames of <i>Statement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>names</i> be the BoundNames of <i>ForBinding</i>.</li>
          <li>Append to <i>names</i> the elements of the VarDeclaredNames of <i>Statement.</i></li>
          <li>Return <i>names.</i></li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarDeclaredNames of <i>Statement</i>.</li>
        </ol>
      </section>

      <section id="sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">
        <h4 id="sec-13.7.5.8" title="13.7.5.8"> Static Semantics:  VarScopedDeclarations</h4><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarScopedDeclarations of <i>Statement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>declarations</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing
              <i>ForBinding</i>.</li>
          <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of <i>Statement.</i></li>
          <li>Return <i>declarations.</i></li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarScopedDeclarations of <i>Statement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarScopedDeclarations of <i>Statement</i>.</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>declarations</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing
              <i>ForBinding</i>.</li>
          <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of <i>Statement.</i></li>
          <li>Return <i>declarations.</i></li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Return the VarScopedDeclarations of <i>Statement</i>.</li>
        </ol>
      </section>

      <section id="sec-for-in-and-for-of-statements-runtime-semantics-bindinginitialization">
        <h4 id="sec-13.7.5.9" title="13.7.5.9"> Runtime Semantics: BindingInitialization</h4><p>With arguments <var>value</var> and <var>environment</var>.</p>

        <p>See also: <a href="sec-ecmascript-language-expressions#sec-identifiers-runtime-semantics-bindinginitialization">12.1.5</a>, <a href="#sec-destructuring-binding-patterns-runtime-semantics-bindinginitialization">13.3.3.5</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> <b>undefined</b> is passed for <var>environment</var> to indicate that a <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a> operation should be used to assign the initialization value. This is the case for
          <code>var</code> statements and the formal parameter lists of some non-strict functions (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-functiondeclarationinstantiation">see 9.2.12</a>). In those cases a lexical binding is hoisted and
          preinitialized prior to evaluation of its initializer.</p>
        </div>

        <div class="gp prod"><span class="nt">ForDeclaration</span> <span class="geq">:</span> <span class="nt">LetOrConst</span> <span class="nt">ForBinding</span></div>
        <ol class="proc">
          <li>Return the result of performing BindingInitialization for <i>ForBinding</i> passing <i>value</i> and
              <i>environment</i> as the arguments.</li>
        </ol>
      </section>

      <section id="sec-runtime-semantics-bindinginstantiation">
        <h4 id="sec-13.7.5.10" title="13.7.5.10"> Runtime Semantics: BindingInstantiation</h4><p>With argument <var>environment</var>.</p>

        <div class="gp prod"><span class="nt">ForDeclaration</span> <span class="geq">:</span> <span class="nt">LetOrConst</span> <span class="nt">ForBinding</span></div>
        <ol class="proc">
          <li>For each element <i>name</i> of the BoundNames of <i>ForBinding</i> do
            <ol class="block">
              <li>If IsConstantDeclaration of <i>LetOrConst</i> is <b>true</b>, then
                <ol class="block">
                  <li>Perform <i>environment</i>.CreateImmutableBinding(<i>name</i>, <b>true</b>).</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Perform <i>environment</i>.CreateMutableBinding(<i>name</i>).</li>
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The above call to CreateMutableBinding will never return an
                      <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                </ol>
              </li>
            </ol>
          </li>
        </ol>
      </section>

      <section id="sec-for-in-and-for-of-statements-runtime-semantics-labelledevaluation">
        <h4 id="sec-13.7.5.11" title="13.7.5.11"> Runtime Semantics: LabelledEvaluation</h4><p>With argument <var>labelSet</var>.</p>

        <p>See also: <a href="#sec-statement-semantics-runtime-semantics-labelledevaluation">13.1.7</a>, <a href="#sec-do-while-statement-runtime-semantics-labelledevaluation">13.7.2.6</a>, <a href="#sec-while-statement-runtime-semantics-labelledevaluation">13.7.3.6</a>, <a href="#sec-for-statement-runtime-semantics-labelledevaluation">13.7.4.7</a>, <a href="#sec-labelled-statements-runtime-semantics-labelledevaluation">13.13.14</a>.</p>

        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>keyResult</i> be ForIn/OfHeadEvaluation( &laquo; &raquo;, <i>Expression</i>, <span style="font-family:               sans-serif">enumerate</span>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keyResult</i>).</li>
          <li>Return ForIn/OfBodyEvaluation(<i>LeftHandSideExpression</i>, <i>Statement</i>, <i>keyResult</i>,  <span style="font-family: sans-serif">assignment</span>, <i>labelSet</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>keyResult</i> be ForIn/OfHeadEvaluation( &laquo; &raquo;, <i>Expression</i>, <span style="font-family:               sans-serif">enumerate</span>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keyResult</i>).</li>
          <li>Return ForIn/OfBodyEvaluation(<i>ForBinding</i>, <i>Statement</i>, <i>keyResult</i>,  <span style="font-family:               sans-serif">varBinding</span>, <i>labelSet</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">in</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>keyResult</i> be the result of performing ForIn/OfHeadEvaluation(BoundNames of <i>ForDeclaration,</i>
              <i>Expression</i>, <span style="font-family: sans-serif">enumerate</span>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keyResult</i>).</li>
          <li>Return ForIn/OfBodyEvaluation(<i>ForDeclaration</i>, <i>Statement</i>, <i>keyResult</i>, <span style="font-family:               sans-serif">lexicalBinding</span>, <i>labelSet</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">LeftHandSideExpression</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>keyResult</i> be the result of performing ForIn/OfHeadEvaluation( &laquo; &raquo;,
              <i>AssignmentExpression</i>, <span style="font-family: sans-serif">iterate</span>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keyResult</i>).</li>
          <li>Return ForIn/OfBodyEvaluation(<i>LeftHandSideExpression</i>, <i>Statement</i>, <i>keyResult</i>, <span style="font-family: sans-serif">assignment</span>, <i>labelSet</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <code class="t">var</code> <span class="nt">ForBinding</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>keyResult</i> be the result of performing ForIn/OfHeadEvaluation( &laquo; &raquo;,
              <i>AssignmentExpression</i>, <span style="font-family: sans-serif">iterate</span>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keyResult</i>).</li>
          <li>Return ForIn/OfBodyEvaluation(<i>ForBinding</i>, <i>Statement</i>, <i>keyResult</i>,  <span style="font-family:               sans-serif">varBinding</span>, <i>labelSet</i>).</li>
        </ol>
        <div class="gp prod"><span class="nt">IterationStatement</span> <span class="geq">:</span> <code class="t">for</code> <code class="t">(</code> <span class="nt">ForDeclaration</span> <code class="t">of</code> <span class="nt">AssignmentExpression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <ol class="proc">
          <li>Let <i>keyResult</i> be the result of performing ForIn/OfHeadEvaluation( BoundNames of <i>ForDeclaration</i>,
              <i>AssignmentExpression</i>, <span style="font-family: sans-serif">iterate</span>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keyResult</i>).</li>
          <li>Return ForIn/OfBodyEvaluation(<i>ForDeclaration</i>, <i>Statement</i>, <i>keyResult</i>,  <span style="font-family:               sans-serif">lexicalBinding</span>, <i>labelSet</i>).</li>
        </ol>
      </section>

      <section id="sec-runtime-semantics-forin-div-ofheadevaluation-tdznames-expr-iterationkind">
        <h4 id="sec-13.7.5.12" title="13.7.5.12"> Runtime Semantics: ForIn/OfHeadEvaluation ( TDZnames, expr,
            iterationKind)</h4><p class="normalbefore">The abstract operation ForIn/OfHeadEvaluation is called with arguments <span class="nt">TDZnames</span>, <var>expr</var>, and <span style="font-family: Times New Roman"><i>iterationKind</i>.</span>
        The value of <var>iterationKind</var> is either <b>enumerate</b> or <b>iterate</b>.</p>

        <ol class="proc">
          <li>Let <i>oldEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
          <li>If <i>TDZnames</i> is not an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>, then
            <ol class="block">
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>TDZnames</i> has no duplicate entries.</li>
              <li>Let <i>TDZ</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>oldEnv</i>).</li>
              <li>For each string <i>name</i> in <i>TDZnames</i>, do
                <ol class="block">
                  <li>Let <i>status</i> be <i>TDZ</i>.CreateMutableBinding(<i>name</i>, <b>false</b>).</li>
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                </ol>
              </li>
              <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>TDZ</i>.</li>
            </ol>
          </li>
          <li>Let <i>exprRef</i> be the result of evaluating the production that is <i>expr</i>.</li>
          <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>oldEnv</i>.</li>
          <li>Let <i>exprValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exprValue</i>).</li>
          <li>If <i>iterationKind</i> is <span style="font-family: sans-serif">enumerate</span>, then
            <ol class="block">
              <li>If <i>exprValue</i>.[[value]] is <b>null</b> or <b>undefined</b>, then
                <ol class="block">
                  <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family: sans-serif">break</span>, [[value]]: <span style="font-family: sans-serif">empty,</span>
                      [[target]]: <span style="font-family: sans-serif">empty</span>}.</li>
                </ol>
              </li>
              <li>Let <i>obj</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>exprValue</i>).</li>
              <li>Return <i>obj</i>.[[Enumerate]]().</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>iterationKind</i> is <span style="font-family:                   sans-serif">iterate</span>.</li>
              <li>Return <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>exprValue</i>).</li>
            </ol>
          </li>
        </ol>
      </section>

      <section id="sec-runtime-semantics-forin-div-ofbodyevaluation-lhs-stmt-iterator-lhskind-labelset">
        <h4 id="sec-13.7.5.13" title="13.7.5.13"> Runtime Semantics: ForIn/OfBodyEvaluation ( lhs, stmt, iterator,
            lhsKind, labelSet )</h4><p class="normalbefore">The abstract operation ForIn/OfBodyEvaluation is called with arguments <var>lhs</var>, <var>stmt,
        iterator,</var> <var>lhsKind</var>, and <var>labelSet.</var> The value of <var>lhsKind</var> is either <b>assignment</b>,
        <b>varBinding</b> or <b>lexicalBinding</b>.</p>

        <ol class="proc">
          <li>Let <i>oldEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
          <li>Let <i>V</i> = <b>undefined</b> .</li>
          <li>Let <i>destructuring</i> be IsDestructuring of <i>lhs</i>.</li>
          <li>If <i>destructuring</i> is <b>true</b> and if <i>lhsKind</i> is <span style="font-family:               sans-serif">assignment</span>, then
            <ol class="block">
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>lhs</i> is a <i>LeftHandSideExpression</i>.</li>
              <li>Let <i>assignmentPattern</i> be the parse of the source text corresponding to <i>lhs</i> using
                  <i>AssignmentPattern</i> as the goal symbol.</li>
            </ol>
          </li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>nextResult</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iterator</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextResult</i>).</li>
              <li>If <i>nextResult</i> is <b>false</b>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>V</i>).</li>
              <li>Let <i>nextValue</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>nextResult</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextValue</i>).</li>
              <li>If <i>lhsKind</i> is either <span style="font-family: sans-serif">assignment</span> or <span style="font-family:                   sans-serif">varBinding</span>, then
                <ol class="block">
                  <li>If <i>destructuring</i> is <b>false</b>, then
                    <ol class="block">
                      <li>Let <i>lhsRef</i> be the result of evaluating <i>lhs</i> ( it may be evaluated repeatedly).</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li>Else
                <ol class="block">
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>lhsKind</i> is <span style="font-family:                       sans-serif">lexicalBinding</span>.</li>
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>lhs</i> is a <i>ForDeclaration</i>.</li>
                  <li>Let <i>iterationEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>oldEnv</i>).</li>
                  <li>Perform BindingInstantiation for <i>lhs</i> passing <i>iterationEnv</i> as the argument.</li>
                  <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>iterationEnv</i>.</li>
                  <li>If <i>destructuring</i> is <b>false</b>, then
                    <ol class="block">
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>lhs</i> binds a single name.</li>
                      <li>Let <i>lhsName</i> be the sole element of BoundNames of <i>lhs.</i></li>
                      <li>Let <i>lhsRef</i> be <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(<i>lhsName</i>).</li>
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>lhsRef</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li>If <i>destructuring</i> is <b>false</b>, then
                <ol class="block">
                  <li>If <i>lhsRef</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
                    <ol class="block">
                      <li>Let <i>status</i> be <i>lhsRef</i>.</li>
                    </ol>
                  </li>
                  <li>Else if <i>lhsKind</i> is <span style="font-family: sans-serif">lexicalBinding</span>, then
                    <ol class="block">
                      <li>Let <i>status</i> be <a href="sec-ecmascript-data-types-and-values#sec-initializereferencedbinding">InitializeReferencedBinding</a>(<i>lhsRef</i>,
                          <i>nextValue</i>).</li>
                    </ol>
                  </li>
                  <li>Else,
                    <ol class="block">
                      <li>Let <i>status</i> be <a href="sec-ecmascript-data-types-and-values#sec-putvalue">PutValue</a>(<i>lhsRef</i>,  <i>nextValue</i>).</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>If <i>lhsKind</i> is <span style="font-family: sans-serif">assignment</span>, then
                    <ol class="block">
                      <li>Let <i>status</i> be the result of performing DestructuringAssignmentEvaluation of
                          <i>assignmentPattern</i> using <i>nextValue</i> as the argument.</li>
                    </ol>
                  </li>
                  <li>Else if <i>lhsKind</i> is <span style="font-family: sans-serif">varBinding</span>, then
                    <ol class="block">
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>lhs</i> is a <i>ForBinding</i>.</li>
                      <li>Let <i>status</i> be the result of performing BindingInitialization for <i>lhs</i> passing
                          <i>nextValue</i> and <b>undefined</b> as the arguments.</li>
                    </ol>
                  </li>
                  <li>Else,
                    <ol class="block">
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>lhsKind</i> is <span style="font-family:                           sans-serif">lexicalBinding</span>.</li>
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>lhs</i> is a <i>ForDeclaration</i>.</li>
                      <li>Let <i>status</i> be the result of performing BindingInitialization for <i>lhs</i> passing
                          <i>nextValue</i> and <i>iterationEnv</i> as arguments.</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
                <ol class="block">
                  <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>oldEnv</i>.</li>
                  <li>Return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>status</i>).</li>
                </ol>
              </li>
              <li>Let <i>result</i> be the result  of evaluating <i>stmt</i>.</li>
              <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>oldEnv</i>.</li>
              <li>If <a href="#sec-loopcontinues">LoopContinues</a>(<i>result</i>, <i>labelSet</i>) is <b>false</b>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>result</i>, <i>V</i>)).</li>
              <li>If <i>result</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, let <i>V</i> be
                  <i>result</i>.[[value]].</li>
            </ol>
          </li>
        </ol>
      </section>

      <section id="sec-for-in-and-for-of-statements-runtime-semantics-evaluation">
        <h4 id="sec-13.7.5.14" title="13.7.5.14"> Runtime Semantics: Evaluation</h4><div class="gp prod"><span class="nt">ForBinding</span> <span class="geq">:</span> <span class="nt">BindingIdentifier</span></div>
        <ol class="proc">
          <li>Let <i>bindingId</i> be StringValue of <i>BindingIdentifier.</i></li>
          <li>Return <a href="sec-executable-code-and-execution-contexts#sec-resolvebinding">ResolveBinding</a>(<i>bindingId</i>)</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-continue-statement">
    <div class="front">
      <h2 id="sec-13.8" title="13.8"> The
          </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">ContinueStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">continue</code> <code class="t">;</code></div>
        <div class="rhs"><code class="t">continue</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">LabelIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">;</code></div>
      </div>
    </div>

    <section id="sec-continue-statement-static-semantics-early-errors">
      <h3 id="sec-13.8.1" title="13.8.1"> Static Semantics:  Early Errors</h3><p><span class="prod"><span class="nt">ContinueStatement</span> <span class="geq">:</span> <code class="t">continue</code>
      <code class="t">;</code></span></p>

      <div class="gp prod"><span class="nt">ContinueStatement</span> <span class="geq">:</span> <code class="t">continue</code> <span class="nt">LabelIdentifier</span> <code class="t">;</code></div>
      <ul>
        <li>
          <p>It is a Syntax Error if this production is not nested, directly or indirectly (but not crossing function boundaries),
          within an <span class="nt">IterationStatement</span>.</p>
        </li>
      </ul>
    </section>

    <section id="sec-continue-statement-static-semantics-containsundefinedcontinuetarget">
      <h3 id="sec-13.8.2" title="13.8.2"> Static Semantics: ContainsUndefinedContinueTarget</h3><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>,<a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

      <div class="gp prod"><span class="nt">ContinueStatement</span> <span class="geq">:</span> <code class="t">continue</code> <code class="t">;</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">ContinueStatement</span> <span class="geq">:</span> <code class="t">continue</code> <span class="nt">LabelIdentifier</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>If the StringValue of <i>LabelIdentifier</i>  is not an element of <i>iterationSet</i>, return <b>true</b>.</li>
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-continue-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.8.3" title="13.8.3"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">ContinueStatement</span> <span class="geq">:</span> <code class="t">continue</code> <code class="t">;</code></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:             sans-serif">continue</span>, [[value]]: <span style="font-family: sans-serif">empty</span>, [[target]]: <span style="font-family: sans-serif">empty</span>}.</li>
      </ol>
      <div class="gp prod"><span class="nt">ContinueStatement</span> <span class="geq">:</span> <code class="t">continue</code> <span class="nt">LabelIdentifier</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>Let <i>label</i> be the StringValue of <i>LabelIdentifier</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:             sans-serif">continue</span>, [[value]]: <span style="font-family: sans-serif">empty</span>, [[target]]: <i>label</i>
            }.</li>
      </ol>
    </section>
  </section>

  <section id="sec-break-statement">
    <div class="front">
      <h2 id="sec-13.9" title="13.9"> The
          </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">BreakStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">break</code> <code class="t">;</code></div>
        <div class="rhs"><code class="t">break</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">LabelIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">;</code></div>
      </div>
    </div>

    <section id="sec-break-statement-static-semantics-early-errors">
      <h3 id="sec-13.9.1" title="13.9.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">BreakStatement</span> <span class="geq">:</span> <code class="t">break</code> <code class="t">;</code></div>
      <ul>
        <li>
          <p>It is a Syntax Error if this production is not nested, directly or indirectly (but not crossing function boundaries),
          within an <span class="nt">IterationStatement</span> or a <span class="nt">SwitchStatement</span>.</p>
        </li>
      </ul>
    </section>

    <section id="sec-break-statement-static-semantics-containsundefinedbreaktarget">
      <h3 id="sec-13.9.2" title="13.9.2"> Static Semantics: ContainsUndefinedBreakTarget</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

      <div class="gp prod"><span class="nt">BreakStatement</span> <span class="geq">:</span> <code class="t">break</code> <code class="t">;</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">BreakStatement</span> <span class="geq">:</span> <code class="t">break</code> <span class="nt">LabelIdentifier</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>If the StringValue of <i>LabelIdentifier</i>  is not an element of <i>labelSet</i>, return <b>true</b>.</li>
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-break-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.9.3" title="13.9.3"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">BreakStatement</span> <span class="geq">:</span> <code class="t">break</code> <code class="t">;</code></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:             sans-serif">break</span>, [[value]]: <span style="font-family: sans-serif">empty</span>, [[target]]: <span style="font-family: sans-serif">empty</span>}.</li>
      </ol>
      <div class="gp prod"><span class="nt">BreakStatement</span> <span class="geq">:</span> <code class="t">break</code> <span class="nt">LabelIdentifier</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>Let <i>label</i> be the StringValue of  <i>LabelIdentifier</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:             sans-serif">break</span>, [[value]]: <span style="font-family: sans-serif">empty</span>, [[target]]: <i>label</i>
            }.</li>
      </ol>
    </section>
  </section>

  <section id="sec-return-statement">
    <div class="front">
      <h2 id="sec-13.10" title="13.10"> The
          </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">ReturnStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">return</code> <code class="t">;</code></div>
        <div class="rhs"><code class="t">return</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">;</code></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE</span> A <code>return</code> statement causes a function to cease execution and return a value to
        the caller. If <span class="nt">Expression</span> is omitted, the return value is <b>undefined</b>. Otherwise, the return
        value is the value of <span class="nt">Expression</span>.</p>
      </div>
    </div>

    <section id="sec-return-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.10.1" title="13.10.1"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">ReturnStatement</span> <span class="geq">:</span> <code class="t">return</code> <code class="t">;</code></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:             sans-serif">return</span>, [[value]]:  <b>undefined</b>, [[target]]:  <span style="font-family:             sans-serif">empty</span>}.</li>
      </ol>
      <div class="gp prod"><span class="nt">ReturnStatement</span> <span class="geq">:</span> <code class="t">return</code> <span class="nt">Expression</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>Let <i>exprRef</i> be the result of evaluating <i>Expression</i>.</li>
        <li>Let <i>exprValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exprValue</i>).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:             sans-serif">return</span>, [[value]]: <i>exprValue</i>, [[target]]: <span style="font-family:             sans-serif">empty</span>}.</li>
      </ol>
    </section>
  </section>

  <section id="sec-with-statement">
    <div class="front">
      <h2 id="sec-13.11" title="13.11"> The
          </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">WithStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">with</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE</span> The <code>with</code> statement adds an object <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> for a computed object to the <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">lexical environment</a> of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution
        context</a>. It then executes a statement using this augmented <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">lexical
        environment</a>. Finally, it restores the original <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">lexical environment</a>.</p>
      </div>
    </div>

    <section id="sec-with-statement-static-semantics-early-errors">
      <h3 id="sec-13.11.1" title="13.11.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">WithStatement</span> <span class="geq">:</span> <code class="t">with</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ul>
        <li>It is a Syntax Error if the code that matches this production is contained in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
            code</a>.</li>
        <li>It is a Syntax Error if <a href="#sec-islabelledfunction">IsLabelledFunction</a>(<span class="nt">Statement</span>) is
            <span class="value">true</span>.</li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE</span> It is only necessary to apply the second rule if the extension specified in  <a href="sec-additional-ecmascript-features-for-web-browsers#sec-labelled-function-declarations">B.3.2</a> is implemented.</p>
      </div>
    </section>

    <section id="sec-with-statement-static-semantics-containsduplicatelabels">
      <h3 id="sec-13.11.2" title="13.11.2"> Static Semantics: ContainsDuplicateLabels</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

      <div class="gp prod"><span class="nt">WithStatement</span> <span class="geq">:</span> <code class="t">with</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return ContainsDuplicateLabels of <i>Statement</i> with argument <i>labelSet.</i></li>
      </ol>
    </section>

    <section id="sec-with-statement-static-semantics-containsundefinedbreaktarget">
      <h3 id="sec-13.11.3" title="13.11.3"> Static Semantics: ContainsUndefinedBreakTarget</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

      <div class="gp prod"><span class="nt">WithStatement</span> <span class="geq">:</span> <code class="t">with</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return ContainsUndefinedBreakTarget of <i>Statement</i> with argument <i>labelSet.</i></li>
      </ol>
    </section>

    <section id="sec-with-statement-static-semantics-containsundefinedcontinuetarget">
      <h3 id="sec-13.11.4" title="13.11.4"> Static Semantics: ContainsUndefinedContinueTarget</h3><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>,<a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

      <div class="gp prod"><span class="nt">WithStatement</span> <span class="geq">:</span> <code class="t">with</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return ContainsUndefinedContinueTarget of <i>Statement</i> with arguments <i>iterationSet</i> and
            &laquo;&nbsp;&raquo;<i>.</i></li>
      </ol>
    </section>

    <section id="sec-with-statement-static-semantics-vardeclarednames">
      <h3 id="sec-13.11.5" title="13.11.5"> Static Semantics:  VarDeclaredNames</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

      <div class="gp prod"><span class="nt">WithStatement</span> <span class="geq">:</span> <code class="t">with</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return the VarDeclaredNames of <i>Statement</i>.</li>
      </ol>
    </section>

    <section id="sec-with-statement-static-semantics-varscopeddeclarations">
      <h3 id="sec-13.11.6" title="13.11.6"> Static Semantics:  VarScopedDeclarations</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

      <div class="gp prod"><span class="nt">WithStatement</span> <span class="geq">:</span> <code class="t">with</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return the VarScopedDeclarations of <i>Statement</i>.</li>
      </ol>
    </section>

    <section id="sec-with-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.11.7" title="13.11.7"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">WithStatement</span> <span class="geq">:</span> <code class="t">with</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Let <i>val</i> be the result of evaluating <i>Expression</i>.</li>
        <li>Let <i>obj</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>val</i>)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>obj</i>).</li>
        <li>Let <i>oldEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
        <li>Let <i>newEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newobjectenvironment">NewObjectEnvironment</a>(<i>obj</i>, <i>oldEnv</i>).</li>
        <li>Set the <i>withEnvironment</i> flag of <i>newEnv&rsquo;s</i> <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>
            to <b>true</b>.</li>
        <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>newEnv</i>.</li>
        <li>Let <i>C</i> be the result of evaluating <i>Statement</i>.</li>
        <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a> to <i>oldEnv</i>.</li>
        <li>If <i>C</i>.[[type]] is <span style="font-family: sans-serif">normal</span> and <i>C</i>.[[value]] is <span style="font-family: sans-serif">empty</span>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>C</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> No matter how control leaves the embedded <span class="nt">Statement</span>, whether
        normally or by some form of <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> or exception, the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> is always restored to its former state.</p>
      </div>
    </section>
  </section>

  <section id="sec-switch-statement">
    <div class="front">
      <h2 id="sec-13.12" title="13.12"> The
          </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">SwitchStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">switch</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">CaseBlock</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">CaseBlock</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub> <code class="t">}</code></div>
        <div class="rhs"><code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">CaseClauses</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">CaseClauses</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">CaseClause</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><span class="nt">CaseClauses</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">CaseClause</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">CaseClause</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">case</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">DefaultClause</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub></div>
      </div>
    </div>

    <section id="sec-switch-statement-static-semantics-early-errors">
      <h3 id="sec-13.12.1" title="13.12.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span> <code class="t">}</code></div>
      <ul>
        <li>
          <p>It is a Syntax Error if the LexicallyDeclaredNames of <span class="nt">CaseClauses</span> contains any duplicate
          entries.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the LexicallyDeclaredNames of <span class="nt">CaseClauses</span> also occurs
          in the VarDeclaredNames of <span class="nt">CaseClauses</span>.</p>
        </li>
      </ul>
    </section>

    <section id="sec-switch-statement-static-semantics-containsduplicatelabels">
      <h3 id="sec-13.12.2" title="13.12.2"> Static Semantics: ContainsDuplicateLabels</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

      <div class="gp prod"><span class="nt">SwitchStatement</span> <span class="geq">:</span> <code class="t">switch</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">CaseBlock</span></div>
      <ol class="proc">
        <li>Return ContainsDuplicateLabels of <i>CaseBlock</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the first <i>CaseClauses</i> is present, then
          <ol class="block">
            <li>Let <i>hasDuplicates</i> be ContainsDuplicateLabels of the first <i>CaseClauses</i> with argument
                <i>labelSet</i>.</li>
            <li>If <i>hasDuplicates</i> is <b>true</b>, return <b>true</b>.</li>
          </ol>
        </li>
        <li>Let <i>hasDuplicates</i> be ContainsDuplicateLabels of <i>DefaultClause</i> with argument <i>labelSet.</i></li>
        <li>If <i>hasDuplicates</i> is <b>true</b>, return <b>true</b>.</li>
        <li>If the second <i>CaseClauses</i> is not present, return <b>false</b>.</li>
        <li>Return ContainsDuplicateLabels of the second <i>CaseClauses</i> with argument <i>labelSet</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClauses</span> <span class="geq">:</span> <span class="nt">CaseClauses</span> <span class="nt">CaseClause</span></div>
      <ol class="proc">
        <li>Let <i>hasDuplicates</i> be ContainsDuplicateLabels of <i>CaseClauses</i> with argument <i>labelSet</i>.</li>
        <li>If <i>hasDuplicates</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsDuplicateLabels of <i>CaseClause</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return ContainsDuplicateLabels of <i>StatementList</i> with argument
            <i>labelSet</i>.</li>
        <li>Else return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">DefaultClause</span> <span class="geq">:</span> <code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return ContainsDuplicateLabels of <i>StatementList</i> with argument
            <i>labelSet</i>.</li>
        <li>Else return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-switch-statement-static-semantics-containsundefinedbreaktarget">
      <h3 id="sec-13.12.3" title="13.12.3"> Static Semantics: ContainsUndefinedBreakTarget</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

      <div class="gp prod"><span class="nt">SwitchStatement</span> <span class="geq">:</span> <code class="t">switch</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">CaseBlock</span></div>
      <ol class="proc">
        <li>Return ContainsUndefinedBreakTarget of <i>CaseBlock</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the first <i>CaseClauses</i> is present, then
          <ol class="block">
            <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedBreakTarget of the first <i>CaseClauses</i> with argument
                <i>labelSet</i>.</li>
            <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
          </ol>
        </li>
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedBreakTarget of <i>DefaultClause</i> with argument
            <i>labelSet.</i></li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>If the second <i>CaseClauses</i> is not present, return <b>false</b>.</li>
        <li>Return ContainsUndefinedBreakTarget of the second <i>CaseClauses</i> with argument <i>labelSet</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClauses</span> <span class="geq">:</span> <span class="nt">CaseClauses</span> <span class="nt">CaseClause</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedBreakTarget of <i>CaseClauses</i> with argument
            <i>labelSet</i>.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedBreakTarget of <i>CaseClause</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return ContainsUndefinedBreakTarget of <i>StatementList</i> with argument
            <i>labelSet</i>.</li>
        <li>Else return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">DefaultClause</span> <span class="geq">:</span> <code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return ContainsUndefinedBreakTarget of <i>StatementList</i> with argument
            <i>labelSet</i>.</li>
        <li>Else return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-switch-statement-static-semantics-containsundefinedcontinuetarget">
      <h3 id="sec-13.12.4" title="13.12.4"> Static Semantics: ContainsUndefinedContinueTarget</h3><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>,<a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

      <div class="gp prod"><span class="nt">SwitchStatement</span> <span class="geq">:</span> <code class="t">switch</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">CaseBlock</span></div>
      <ol class="proc">
        <li>Return ContainsUndefinedContinueTarget of <i>CaseBlock</i> with arguments <i>iterationSet</i> and
            &laquo;&nbsp;&raquo;<i>.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the first <i>CaseClauses</i> is present, then
          <ol class="block">
            <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedContinueTarget of the first <i>CaseClauses</i> with arguments
                <i>iterationSet</i> and &laquo;&nbsp;&raquo;.</li>
            <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
          </ol>
        </li>
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedContinueTarget of <i>DefaultClause</i> with arguments
            <i>iterationSet</i> and &laquo;&nbsp;&raquo;<i>.</i></li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>If the second <i>CaseClauses</i> is not present, return <b>false</b>.</li>
        <li>Return ContainsUndefinedContinueTarget of the second <i>CaseClauses</i> with arguments <i>iterationSet</i> and
            &laquo;&nbsp;&raquo;.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClauses</span> <span class="geq">:</span> <span class="nt">CaseClauses</span> <span class="nt">CaseClause</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedContinueTarget of <i>CaseClauses</i> with arguments
            <i>iterationSet</i> and &laquo;&nbsp;&raquo;.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedContinueTarget of <i>CaseClause</i> with arguments <i>iterationSet</i> and
            &laquo;&nbsp;&raquo;<i>.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return ContainsUndefinedContinueTarget of <i>StatementList</i> with arguments
            <i>iterationSet</i> and &laquo;&nbsp;&raquo;.</li>
        <li>Else return <b>false</b>.</li>
      </ol>
      <div class="gp prod"><span class="nt">DefaultClause</span> <span class="geq">:</span> <code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return ContainsUndefinedContinueTarget of <i>StatementList</i> with arguments
            <i>iterationSet</i> and &laquo;&nbsp;&raquo;.</li>
        <li>Else return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-switch-statement-static-semantics-lexicallydeclarednames">
      <h3 id="sec-13.12.5" title="13.12.5"> Static Semantics:  LexicallyDeclaredNames</h3><p>See also: <a href="#sec-block-static-semantics-lexicallydeclarednames">13.2.5</a>, <a href="#sec-labelled-statements-static-semantics-lexicallydeclarednames">13.13.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallydeclarednames">14.1.13</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallydeclarednames">14.2.10</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-lexicallydeclarednames">15.1.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-lexicallydeclarednames">15.2.1.11</a>.</p>

      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the first <i>CaseClauses</i> is present, let <i>names</i> be the LexicallyDeclaredNames of the first
            <i>CaseClauses</i>.</li>
        <li>Else let <i>names</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Append to <i>names</i> the elements of the LexicallyDeclaredNames of the <i>DefaultClause.</i></li>
        <li>If the second <i>CaseClauses</i> is not present, return <i>names</i>.</li>
        <li>Else return the result of appending to <i>names</i> the elements of the LexicallyDeclaredNames of the second
            <i>CaseClauses</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClauses</span> <span class="geq">:</span> <span class="nt">CaseClauses</span> <span class="nt">CaseClause</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be LexicallyDeclaredNames of <i>CaseClauses</i>.</li>
        <li>Append to <i>names</i> the elements of the LexicallyDeclaredNames of <i>CaseClause.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return the LexicallyDeclaredNames of <i>StatementList</i>.</li>
        <li>Else return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">DefaultClause</span> <span class="geq">:</span> <code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return the LexicallyDeclaredNames of <i>StatementList</i>.</li>
        <li>Else return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-switch-statement-static-semantics-lexicallyscopeddeclarations">
      <h3 id="sec-13.12.6" title="13.12.6"> Static Semantics:  LexicallyScopedDeclarations</h3><p>See also: <a href="#sec-block-static-semantics-lexicallyscopeddeclarations">13.2.6</a>, <a href="#sec-labelled-statements-static-semantics-lexicallyscopeddeclarations">13.13.7</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallyscopeddeclarations">14.1.14</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallyscopeddeclarations">14.2.11</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-lexicallyscopeddeclarations">15.1.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-lexicallyscopeddeclarations">15.2.1.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-lexicallyscopeddeclarations">15.2.3.8</a>.</p>

      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the first <i>CaseClauses</i> is present, let <i>declarations</i> be the LexicallyScopedDeclarations of the first
            <i>CaseClauses</i>.</li>
        <li>Else let <i>declarations</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Append to <i>declarations</i> the elements of the LexicallyScopedDeclarations of the <i>DefaultClause.</i></li>
        <li>If the second <i>CaseClauses</i> is not present, return <i>declarations</i>.</li>
        <li>Else return the result of appending to <i>declarations</i> the elements of the LexicallyScopedDeclarations of the
            second <i>CaseClauses</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClauses</span> <span class="geq">:</span> <span class="nt">CaseClauses</span> <span class="nt">CaseClause</span></div>
      <ol class="proc">
        <li>Let <i>declarations</i> be LexicallyScopedDeclarations of <i>CaseClauses</i>.</li>
        <li>Append to <i>declarations</i> the elements of the LexicallyScopedDeclarations of <i>CaseClause.</i></li>
        <li>Return <i>declarations</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return the LexicallyScopedDeclarations of <i>StatementList</i>.</li>
        <li>Else return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">DefaultClause</span> <span class="geq">:</span> <code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return the LexicallyScopedDeclarations of <i>StatementList</i>.</li>
        <li>Else return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-switch-statement-static-semantics-vardeclarednames">
      <h3 id="sec-13.12.7" title="13.12.7"> Static Semantics:  VarDeclaredNames</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

      <div class="gp prod"><span class="nt">SwitchStatement</span> <span class="geq">:</span> <code class="t">switch</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">CaseBlock</span></div>
      <ol class="proc">
        <li>Return the VarDeclaredNames of <i>CaseBlock</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the first <i>CaseClauses</i> is present, let <i>names</i> be the VarDeclaredNames of the first
            <i>CaseClauses</i>.</li>
        <li>Else let <i>names</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Append to <i>names</i> the elements of the VarDeclaredNames of the <i>DefaultClause.</i></li>
        <li>If the second <i>CaseClauses</i> is not present, return <i>names</i>.</li>
        <li>Else return the result of appending to <i>names</i> the elements of the VarDeclaredNames of the second
            <i>CaseClauses</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClauses</span> <span class="geq">:</span> <span class="nt">CaseClauses</span> <span class="nt">CaseClause</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be VarDeclaredNames of <i>CaseClauses</i>.</li>
        <li>Append to <i>names</i> the elements of the VarDeclaredNames of <i>CaseClause.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return the VarDeclaredNames of <i>StatementList</i>.</li>
        <li>Else return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">DefaultClause</span> <span class="geq">:</span> <code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return the VarDeclaredNames of <i>StatementList</i>.</li>
        <li>Else return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-switch-statement-static-semantics-varscopeddeclarations">
      <h3 id="sec-13.12.8" title="13.12.8"> Static Semantics:  VarScopedDeclarations</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

      <div class="gp prod"><span class="nt">SwitchStatement</span> <span class="geq">:</span> <code class="t">switch</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">CaseBlock</span></div>
      <ol class="proc">
        <li>Return the VarScopedDeclarations of <i>CaseBlock</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      <ol class="proc">
        <li>If the first <i>CaseClauses</i> is present, let <i>declarations</i> be the VarScopedDeclarations of the first
            <i>CaseClauses</i>.</li>
        <li>Else let <i>declarations</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of the <i>DefaultClause.</i></li>
        <li>If the second <i>CaseClauses</i> is not present, return <i>declarations</i>.</li>
        <li>Else return the result of appending to <i>declarations</i> the elements of the VarScopedDeclarations of the second
            <i>CaseClauses</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClauses</span> <span class="geq">:</span> <span class="nt">CaseClauses</span> <span class="nt">CaseClause</span></div>
      <ol class="proc">
        <li>Let <i>declarations</i> be VarScopedDeclarations of <i>CaseClauses</i>.</li>
        <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of <i>CaseClause.</i></li>
        <li>Return <i>declarations</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return the VarScopedDeclarations of <i>StatementList</i>.</li>
        <li>Else return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">DefaultClause</span> <span class="geq">:</span> <code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>If the <i>StatementList</i> is present, return the VarScopedDeclarations of <i>StatementList</i>.</li>
        <li>Else return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-runtime-semantics-caseblockevaluation">
      <h3 id="sec-13.12.9" title="13.12.9"> Runtime Semantics: CaseBlockEvaluation</h3><p>With argument <var>input</var>.</p>

      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <code class="t">}</code></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span> <code class="t">}</code></div>
      <ol class="proc">
        <li>Let <i>V</i> = <b>undefined</b>.</li>
        <li>Let <i>A</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <i>CaseClause</i> items in
            <i>CaseClauses</i>, in source text order.</li>
        <li>Let <i>found</i> be <b>false</b>.</li>
        <li>Repeat for each <i>CaseClause</i> <i>C</i> in <i>A</i>,
          <ol class="block">
            <li>If <i>found</i> is <b>false</b>, then
              <ol class="block">
                <li>Let <i>clauseSelector</i> be the result of CaseSelectorEvaluation of <i>C</i>.</li>
                <li>If <i>clauseSelector</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
                  <ol class="block">
                    <li>If <i>clauseSelector</i>.[[value]] is <span style="font-family: sans-serif">empty</span>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <i>clauseSelector</i>.[[type]],
                        [[value]]:  <b>undefined</b>, [[target]]:  <i>clauseSelector</i>.[[target]]}.</li>
                    <li>Else, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>clauseSelector</i>).</li>
                  </ol>
                </li>
                <li>Let <i>found</i> be the result of performing Strict Equality Comparison <i>input</i> ===
                    <i>clauseSelector</i>.[[value]].</li>
              </ol>
            </li>
            <li>If <i>found</i> is <b>true</b>, then
              <ol class="block">
                <li>Let <i>R</i> be the result of evaluating <i>C</i>.</li>
                <li>If <i>R</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, let <i>V</i> =
                    <i>R</i>.[[value]].</li>
                <li>If <i>R</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>R</i>, <i>V</i>)).</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>V</i>).</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseBlock</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span> <span class="nt">CaseClauses</span><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      <ol class="proc">
        <li>Let <i>V</i> = <b>undefined</b>.</li>
        <li>Let <i>A</i> be the list of <i>CaseClause</i> items in the first <i>CaseClauses</i>, in source text order. If the
            first <i>CaseClauses</i> is not present <i>A</i> is &laquo; &raquo;.</li>
        <li>Let <i>found</i> be <b>false</b>.</li>
        <li>Repeat for each <i>CaseClause</i> <i>C</i> in <i>A</i>
          <ol class="block">
            <li>If <i>found</i> is <b>false</b>, then
              <ol class="block">
                <li>Let <i>clauseSelector</i> be the result of CaseSelectorEvaluation of <i>C</i>.</li>
                <li>If <i>clauseSelector</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
                  <ol class="block">
                    <li>If <i>clauseSelector</i>.[[value]] is <span style="font-family: sans-serif">empty</span>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <i>clauseSelector</i>.[[type]],
                        [[value]]:  <b>undefined</b>, [[target]]:  <i>clauseSelector</i>.[[target]]}.</li>
                    <li>Else, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>clauseSelector</i>).</li>
                  </ol>
                </li>
                <li>Let <i>found</i> be the result of performing Strict Equality Comparison <i>input</i> ===
                    <i>clauseSelector</i>.[[value]].</li>
              </ol>
            </li>
            <li>If <i>found</i> is <b>true</b>, then
              <ol class="block">
                <li>Let <i>R</i> be the result of evaluating <i>C</i>.</li>
                <li>If <i>R</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, let <i>V</i> =
                    <i>R</i>.[[value]].</li>
                <li>If <i>R</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>R</i>, <i>V</i>)).</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Let <i>foundInB</i> be <b>false</b>.</li>
        <li>Let <i>B</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the <i>CaseClause</i> items
            in the second <i>CaseClauses</i>, in source text order. If the second <i>CaseClauses</i> is not present <i>B</i> is
            &laquo; &raquo;.</li>
        <li>If <i>found</i> is <b>false</b>, then
          <ol class="block">
            <li>Repeat for  each <i>CaseClause C</i> in <i>B</i>
              <ol class="block">
                <li>If <i>foundInB</i> is <b>false</b>, then
                  <ol class="block">
                    <li>Let <i>clauseSelector</i> be the result of CaseSelectorEvaluation of <i>C</i>.</li>
                    <li>If <i>clauseSelector</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>,
                        then
                      <ol class="block">
                        <li>If <i>clauseSelector</i>.[[value]] is <span style="font-family: sans-serif">empty</span>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]:
                            <i>clauseSelector</i>.[[type]], [[value]]: <b>undefined</b>, [[target]]:
                            <i>clauseSelector</i>.[[target]]}.</li>
                        <li>Else, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>clauseSelector</i>).</li>
                      </ol>
                    </li>
                    <li>Let <i>foundInB</i> be the result of performing Strict Equality Comparison <i>input</i> ===
                        <i>clauseSelector</i>.[[value]].</li>
                  </ol>
                </li>
                <li>If <i>foundInB</i> is <b>true</b>, then
                  <ol class="block">
                    <li>Let <i>R</i> be the result of evaluating <i>CaseClause C</i>.</li>
                    <li>If <i>R</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, let <i>V</i> =
                        <i>R</i>.[[value]].</li>
                    <li>If <i>R</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>R</i>, <i>V</i>)).</li>
                  </ol>
                </li>
              </ol>
            </li>
          </ol>
        </li>
        <li>If <i>foundInB</i> is <b>true</b>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>V</i>).</li>
        <li>Let <i>R</i> be the result of evaluating <i>DefaultClause</i>.</li>
        <li>If <i>R</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, let <i>V</i> =
            <i>R</i>.[[value]].</li>
        <li>If <i>R</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>R</i>,
            <i>V</i>)).</li>
        <li>Repeat for each <i>CaseClause C</i> in <i>B</i> (NOTE  this is another complete iteration of the second
            <i>CaseClauses</i>)
          <ol class="block">
            <li>Let <i>R</i> be the result of evaluating <i>CaseClause</i> <i>C</i>.</li>
            <li>If <i>R</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, let <i>V</i> =
                <i>R</i>.[[value]].</li>
            <li>If <i>R</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<a href="sec-ecmascript-data-types-and-values#sec-updateempty">UpdateEmpty</a>(<i>R</i>, <i>V</i>)).</li>
          </ol>
        </li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>V</i>).</li>
      </ol>
    </section>

    <section id="sec-runtime-semantics-caseselectorevaluation">
      <h3 id="sec-13.12.10" title="13.12.10"> Runtime Semantics: CaseSelectorEvaluation</h3><div class="gp prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-opt">opt</sub></div>
      <ol class="proc">
        <li>Let <i>exprRef</i> be the result of evaluating <i>Expression</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> CaseSelectorEvaluation does not execute the associated <span class="nt">StatementList</span>. It simply evaluates the <span class="nt">Expression</span> and returns the value, which
        the <span class="nt">CaseBlock</span> algorithm uses to determine which <span class="nt">StatementList</span> to start
        executing.</p>
      </div>
    </section>

    <section id="sec-switch-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.12.11" title="13.12.11"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">SwitchStatement</span> <span class="geq">:</span> <code class="t">switch</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">CaseBlock</span></div>
      <ol class="proc">
        <li>Let <i>exprRef</i> be the result of evaluating <i>Expression</i>.</li>
        <li>Let <i>switchValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>switchValue</i>).</li>
        <li>Let <i>oldEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
        <li>Let <i>blockEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>oldEnv</i>).</li>
        <li>Perform <a href="#sec-blockdeclarationinstantiation">BlockDeclarationInstantiation</a>(<i>CaseBlock,</i>
            <i>blockEnv</i>).</li>
        <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>blockEnv</i>.</li>
        <li>Let <i>R</i> be the result of performing CaseBlockEvaluation of <i>CaseBlock</i> with argument
            <i>switchValue</i>.</li>
        <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>oldEnv</i>.</li>
        <li>Return <i>R</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> No matter how control leaves the <span class="nt">SwitchStatement</span> the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> is always restored to its former state.</p>
      </div>

      <div class="gp prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
      </ol>
      <div class="gp prod"><span class="nt">CaseClause</span> <span class="geq">:</span> <code class="t">case</code> <span class="nt">Expression</span> <code class="t">:</code> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>Return the result of evaluating <i>StatementList</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">DefaultClause</span> <span class="geq">:</span> <code class="t">default</code> <code class="t">:</code></div>
      <ol class="proc">
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
      </ol>
      <div class="gp prod"><span class="nt">DefaultClause</span> <span class="geq">:</span> <code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span></div>
      <ol class="proc">
        <li>Return the result of evaluating <i>StatementList</i>.</li>
      </ol>
    </section>
  </section>

  <section id="sec-labelled-statements">
    <div class="front">
      <h2 id="sec-13.13" title="13.13">
          Labelled Statements</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">LabelledStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">LabelIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">:</code> <span class="nt">LabelledItem</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">LabelledItem</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><span class="nt">FunctionDeclaration</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE</span> A <span class="nt">Statement</span> may be prefixed by a label. Labelled statements are
        only used in conjunction with labelled <code>break</code> and <code>continue</code> statements. ECMAScript has no
        <code>goto</code> statement. A <span class="nt">Statement</span> can be part of a <span class="nt">LabelledStatement</span>, which itself can be part of a <span class="nt">LabelledStatement</span>, and so on.
        The labels introduced this way are collectively referred to as the &ldquo;current label set&rdquo; when describing the
        semantics of individual statements. A <span class="nt">LabelledStatement</span> has no semantic meaning other than the
        introduction of a label to a <i>label set</i>.</p>
      </div>
    </div>

    <section id="sec-labelled-statements-static-semantics-early-errors">
      <h3 id="sec-13.13.1" title="13.13.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ul>
        <li>It is a Syntax Error if any source text matches this rule.</li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE</span> An alternative  definition for this rule is provided in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-labelled-function-declarations">B.3.2</a>.</p>
      </div>
    </section>

    <section id="sec-labelled-statements-static-semantics-containsduplicatelabels">
      <h3 id="sec-13.13.2" title="13.13.2"> Static Semantics: ContainsDuplicateLabels</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="#sec-try-statement-static-semantics-containsduplicatelabels">13.15.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Let <i>label</i> be the StringValue of <i>LabelIdentifier</i>.</li>
        <li>If <i>label</i> is an element of <i>labelSet</i>, return <b>true</b>.</li>
        <li>Let <i>newLabelSet</i> be a copy of  <i>labelSet</i> with <i>label</i> appended.</li>
        <li>Return ContainsDuplicateLabels of <i>LabelledItem</i> with argument <i>newLabelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-static-semantics-containsundefinedbreaktarget">
      <h3 id="sec-13.13.3" title="13.13.3"> Static Semantics: ContainsUndefinedBreakTarget</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-try-statement-static-semantics-containsundefinedbreaktarget">13.15.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Let <i>label</i> be the StringValue of <i>LabelIdentifier</i>.</li>
        <li>Let <i>newLabelSet</i> be a copy of  <i>labelSet</i> with <i>label</i> appended.</li>
        <li>Return ContainsUndefinedBreakTarget of <i>LabelledItem</i> with argument <i>newLabelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">
      <h3 id="sec-13.13.4" title="13.13.4"> Static Semantics: ContainsUndefinedContinueTarget</h3><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-try-statement-static-semantics-containsundefinedcontinuetarget">13.15.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Let <i>label</i> be the StringValue of <i>LabelIdentifier</i>.</li>
        <li>Let <i>newLabelSet</i> be a copy of  <i>labelSet</i> with <i>label</i> appended.</li>
        <li>Return ContainsUndefinedContinueTarget of <i>LabelledItem</i> with arguments <i>iterationSet</i> and
            <i>newLabelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ol class="proc">
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-islabelledfunction">
      <h3 id="sec-13.13.5" title="13.13.5">
          Static Semantics:  IsLabelledFunction ( stmt )</h3><p class="normalbefore">The abstract operation IsLabelledFunction  with argument <var>stmt</var> performs the following
      steps:</p>

      <ol class="proc">
        <li>If <i>stmt</i> is not a <i>LabelledStatement</i>, return <b>false</b>.</li>
        <li>Let <i>item</i> be the <i>LabelledItem</i> component of <i>stmt</i>.</li>
        <li>If <i>item</i> is <span class="prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></span> , return <b>true</b>.</li>
        <li>Let <i>subStmt</i> be the <i>Statement</i> component of <i>item</i>.</li>
        <li>Return IsLabelledFunction(<i>subStmt</i>).</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-static-semantics-lexicallydeclarednames">
      <h3 id="sec-13.13.6" title="13.13.6"> Static Semantics:  LexicallyDeclaredNames</h3><p>See also: <a href="#sec-block-static-semantics-lexicallydeclarednames">13.2.5</a>, <a href="#sec-switch-statement-static-semantics-lexicallydeclarednames">13.12.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallydeclarednames">14.1.13</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallydeclarednames">14.2.10</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-lexicallydeclarednames">15.1.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-lexicallydeclarednames">15.2.1.11</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Return the LexicallyDeclaredNames of <i>LabelledItem</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ol class="proc">
        <li>Return BoundNames of <i>FunctionDeclaration</i>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-static-semantics-lexicallyscopeddeclarations">
      <h3 id="sec-13.13.7" title="13.13.7"> Static Semantics:  LexicallyScopedDeclarations</h3><p>See also: <a href="#sec-block-static-semantics-lexicallyscopeddeclarations">13.2.6</a>, <a href="#sec-switch-statement-static-semantics-lexicallyscopeddeclarations">13.12.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-lexicallyscopeddeclarations">14.1.14</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-lexicallyscopeddeclarations">14.2.11</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-lexicallyscopeddeclarations">15.1.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-lexicallyscopeddeclarations">15.2.1.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-exports-static-semantics-lexicallyscopeddeclarations">15.2.3.8</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Return the LexicallyScopedDeclarations of <i>LabelledItem</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ol class="proc">
        <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>FunctionDeclaration</i>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-static-semantics-toplevellexicallydeclarednames">
      <h3 id="sec-13.13.8" title="13.13.8"> Static Semantics:  TopLevelLexicallyDeclaredNames</h3><p>See also: <a href="#sec-block-static-semantics-toplevellexicallydeclarednames">13.2.7</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-static-semantics-toplevellexicallyscopeddeclarations">
      <h3 id="sec-13.13.9" title="13.13.9"> Static Semantics:  TopLevelLexicallyScopedDeclarations</h3><p>See also: <a href="#sec-block-static-semantics-toplevellexicallyscopeddeclarations">13.2.8</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-static-semantics-toplevelvardeclarednames">
      <h3 id="sec-13.13.10" title="13.13.10"> Static Semantics:  TopLevelVarDeclaredNames</h3><p>See also: <a href="#sec-block-static-semantics-toplevelvardeclarednames">13.2.9</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Return the TopLevelVarDeclaredNames of <i>LabelledItem</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>If <i>Statement</i> is <span class="prod"><span class="nt">Statement</span> <span class="geq">:</span> <span class="nt">LabelledStatement</span></span> , return TopLevelVarDeclaredNames of <i>Statement</i>.</li>
        <li>Return VarDeclaredNames of <i>Statement</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ol class="proc">
        <li>Return BoundNames of <i>FunctionDeclaration</i>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-static-semantics-toplevelvarscopeddeclarations">
      <h3 id="sec-13.13.11" title="13.13.11"> Static Semantics:  TopLevelVarScopedDeclarations</h3><p>See also: <a href="#sec-block-static-semantics-toplevelvarscopeddeclarations">13.2.10</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Return the TopLevelVarScopedDeclarations of <i>LabelledItem</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>If <i>Statement</i> is <span class="prod"><span class="nt">Statement</span> <span class="geq">:</span> <span class="nt">LabelledStatement</span></span> , return TopLevelVarScopedDeclarations of <i>Statement</i>.</li>
        <li>Return VarScopedDeclarations of <i>Statement</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ol class="proc">
        <li>Return a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing <i>FunctionDeclaration</i>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-static-semantics-vardeclarednames">
      <h3 id="sec-13.13.12" title="13.13.12"> Static Semantics:  VarDeclaredNames</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-try-statement-static-semantics-vardeclarednames">13.15.5</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Return the VarDeclaredNames of <i>LabelledItem</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-static-semantics-varscopeddeclarations">
      <h3 id="sec-13.13.13" title="13.13.13"> Static Semantics:  VarScopedDeclarations</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-try-statement-static-semantics-varscopeddeclarations">13.15.6</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Return the VarScopedDeclarations of <i>LabelledItem</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ol class="proc">
        <li>Return a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-runtime-semantics-labelledevaluation">
      <h3 id="sec-13.13.14" title="13.13.14"> Runtime Semantics: LabelledEvaluation</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-runtime-semantics-labelledevaluation">13.1.7</a>, <a href="#sec-do-while-statement-runtime-semantics-labelledevaluation">13.7.2.6</a>, <a href="#sec-while-statement-runtime-semantics-labelledevaluation">13.7.3.6</a>, <a href="#sec-for-statement-runtime-semantics-labelledevaluation">13.7.4.7</a>, <a href="#sec-for-in-and-for-of-statements-runtime-semantics-labelledevaluation">13.7.5.11</a>.</p>

      <div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Let <i>label</i> be the StringValue of <i>LabelIdentifier</i>.</li>
        <li>Append  <i>label</i> as an element of <i>labelSet</i>.</li>
        <li>Let <i>stmtResult</i> be LabelledEvaluation of <i>LabelledItem</i> with argument <i>labelSet</i>.</li>
        <li>If <i>stmtResult</i>.[[type]] is <span style="font-family: sans-serif">break</span> and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>stmtResult</i>.[[target]], <i>label</i>), then
          <ol class="block">
            <li>Let <i>stmtResult</i> be <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>stmtResult</i>.[[value]]).</li>
          </ol>
        </li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>stmtResult</i>).</li>
      </ol>
      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">Statement</span></div>
      <ol class="proc">
        <li>If <i>Statement</i> is either a <i>LabelledStatement</i> or a <i>BreakableStatement</i>, then
          <ol class="block">
            <li>Return LabelledEvaluation of <i>Statement</i> with argument <i>labelSet</i>.</li>
          </ol>
        </li>
        <li>Else,
          <ol class="block">
            <li>Return the result of evaluating <i>Statement</i>.</li>
          </ol>
        </li>
      </ol>

      <p><span class="prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></span></p>

      <ol class="proc">
        <li>Return the result of evaluating <i>FunctionDeclaration</i>.</li>
      </ol>
    </section>

    <section id="sec-labelled-statements-runtime-semantics-evaluation">
      <h3 id="sec-13.13.15" title="13.13.15"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">LabelledStatement</span> <span class="geq">:</span> <span class="nt">LabelIdentifier</span> <code class="t">:</code> <span class="nt">LabelledItem</span></div>
      <ol class="proc">
        <li>Let <i>newLabelSet</i>  be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Return LabelledEvaluation of <i>LabelledItem</i> with argument <i>newLabelSet</i>.</li>
      </ol>
    </section>
  </section>

  <section id="sec-throw-statement">
    <div class="front">
      <h2 id="sec-13.14" title="13.14"> The
          </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">ThrowStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">throw</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">;</code></div>
      </div>
    </div>

    <section id="sec-throw-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.14.1" title="13.14.1"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">ThrowStatement</span> <span class="geq">:</span> <code class="t">throw</code> <span class="nt">Expression</span> <code class="t">;</code></div>
      <ol class="proc">
        <li>Let <i>exprRef</i> be the result of evaluating <i>Expression</i>.</li>
        <li>Let <i>exprValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprRef</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exprValue</i>).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:             sans-serif">throw</span>, [[value]]: <i>exprValue</i>, [[target]]: <span style="font-family:             sans-serif">empty</span>}.</li>
      </ol>
    </section>
  </section>

  <section id="sec-try-statement">
    <div class="front">
      <h2 id="sec-13.15" title="13.15"> The
          </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">TryStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">try</code> <span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">Catch</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">try</code> <span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">Finally</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">try</code> <span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">Catch</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">Finally</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">Catch</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span><sub class="g-params">[?Yield]</sub> <code class="t">)</code> <span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">Finally</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">finally</code> <span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">CatchParameter</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><span class="nt">BindingPattern</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE</span> The <code>try</code> statement encloses a block of code in which an exceptional condition
        can occur, such as a runtime error or a <code>throw</code> statement. The <code>catch</code> clause provides the
        exception-handling code. When a catch clause catches an exception, its <span class="nt">CatchParameter</span> is bound to
        that exception.</p>
      </div>
    </div>

    <section id="sec-try-statement-static-semantics-early-errors">
      <h3 id="sec-13.15.1" title="13.15.1"> Static Semantics:  Early Errors</h3><div class="gp prod"><span class="nt">Catch</span> <span class="geq">:</span> <code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span> <code class="t">)</code> <span class="nt">Block</span></div>
      <ul>
        <li>
          <p>It is a Syntax Error if BoundNames <span style="font-family: Times New Roman">of <i>CatchParameter</i></span>
          contains any duplicate elements.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the BoundNames of <span class="nt">CatchParameter</span> also occurs in the
          LexicallyDeclaredNames of <span class="nt">Block</span>.</p>
        </li>

        <li>
          <p>It is a Syntax Error if any element of the BoundNames of <span class="nt">CatchParameter</span> also occurs in the
          VarDeclaredNames of <span class="nt">Block</span>.</p>
        </li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE</span> An alternative static semantics for this production is given in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-variablestatements-in-catch-blocks">B.3.5</a>.</p>
      </div>
    </section>

    <section id="sec-try-statement-static-semantics-containsduplicatelabels">
      <h3 id="sec-13.15.2" title="13.15.2"> Static Semantics: ContainsDuplicateLabels</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsduplicatelabels">13.1.1</a>, <a href="#sec-block-static-semantics-containsduplicatelabels">13.2.2</a>, <a href="#sec-if-statement-static-semantics-containsduplicatelabels">13.6.2</a>, <a href="#sec-do-while-statement-static-semantics-containsduplicatelabels">13.7.2.1</a>, <a href="#sec-while-statement-static-semantics-containsduplicatelabels">13.7.3.1</a>, <a href="#sec-for-statement-static-semantics-containsduplicatelabels">13.7.4.2</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsduplicatelabels">13.7.5.3</a>, <a href="#sec-with-statement-static-semantics-containsduplicatelabels">13.11.2</a>, <a href="#sec-switch-statement-static-semantics-containsduplicatelabels">13.12.2</a>, <a href="#sec-labelled-statements-static-semantics-containsduplicatelabels">13.13.2</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsduplicatelabels">15.2.1.2</a>.</p>

      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span></div>
      <ol class="proc">
        <li>Let <i>hasDuplicates</i> be ContainsDuplicateLabels of <i>Block</i> with argument <i>labelSet</i>.</li>
        <li>If <i>hasDuplicates</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsDuplicateLabels of <i>Catch</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>hasDuplicates</i> be ContainsDuplicateLabels of <i>Block</i> with argument <i>labelSet</i>.</li>
        <li>If <i>hasDuplicates</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsDuplicateLabels of <i>Finally</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>hasDuplicates</i> be ContainsDuplicateLabels of <i>Block</i> with argument <i>labelSet</i>.</li>
        <li>If <i>hasDuplicates</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Let <i>hasDuplicates</i> be ContainsDuplicateLabels of <i>Catch</i> with argument <i>labelSet</i>.</li>
        <li>If <i>hasDuplicates</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsDuplicateLabels of <i>Finally</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">Catch</span> <span class="geq">:</span> <code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span> <code class="t">)</code> <span class="nt">Block</span></div>
      <ol class="proc">
        <li>Return ContainsDuplicateLabels of <i>Block</i> with argument <i>labelSet.</i></li>
      </ol>
    </section>

    <section id="sec-try-statement-static-semantics-containsundefinedbreaktarget">
      <h3 id="sec-13.15.3" title="13.15.3"> Static Semantics: ContainsUndefinedBreakTarget</h3><p>With argument <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedbreaktarget">13.1.2</a>, <a href="#sec-block-static-semantics-containsundefinedbreaktarget">13.2.3</a>, <a href="#sec-if-statement-static-semantics-containsundefinedbreaktarget">13.6.3</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedbreaktarget">13.7.2.2</a>, <a href="#sec-while-statement-static-semantics-containsundefinedbreaktarget">13.7.3.2</a>, <a href="#sec-for-statement-static-semantics-containsundefinedbreaktarget">13.7.4.3</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedbreaktarget">13.7.5.4</a>, <a href="#sec-break-statement-static-semantics-containsundefinedbreaktarget">13.9.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedbreaktarget">13.11.3</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedbreaktarget">13.12.3</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedbreaktarget">13.13.3</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedbreaktarget">15.2.1.3</a>.</p>

      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedBreakTarget of <i>Block</i> with argument <i>labelSet</i>.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedBreakTarget of <i>Catch</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedBreakTarget of <i>Block</i> with argument <i>labelSet</i>.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedBreakTarget of <i>Finally</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedBreakTarget of <i>Block</i> with argument <i>labelSet</i>.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedBreakTarget of <i>Catch</i> with argument <i>labelSet</i>.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedBreakTarget of <i>Finally</i> with argument <i>labelSet.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">Catch</span> <span class="geq">:</span> <code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span> <code class="t">)</code> <span class="nt">Block</span></div>
      <ol class="proc">
        <li>Return ContainsUndefinedBreakTarget of <i>Block</i> with argument <i>labelSet.</i></li>
      </ol>
    </section>

    <section id="sec-try-statement-static-semantics-containsundefinedcontinuetarget">
      <h3 id="sec-13.15.4" title="13.15.4"> Static Semantics: ContainsUndefinedContinueTarget</h3><p>With arguments <var>iterationSet</var> and <var>labelSet</var>.</p>

      <p>See also: <a href="#sec-statement-semantics-static-semantics-containsundefinedcontinuetarget">13.1.3</a>, <a href="#sec-block-static-semantics-containsundefinedcontinuetarget">13.2.4</a>, <a href="#sec-if-statement-static-semantics-containsundefinedcontinuetarget">13.6.4</a>, <a href="#sec-do-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.2.3</a>, <a href="#sec-while-statement-static-semantics-containsundefinedcontinuetarget">13.7.3.3</a>, <a href="#sec-for-statement-static-semantics-containsundefinedcontinuetarget">13.7.4.4</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-containsundefinedcontinuetarget">13.7.5.5</a>, <a href="#sec-continue-statement-static-semantics-containsundefinedcontinuetarget">13.8.2</a>, <a href="#sec-with-statement-static-semantics-containsundefinedcontinuetarget">13.11.4</a>, <a href="#sec-switch-statement-static-semantics-containsundefinedcontinuetarget">13.12.4</a>, <a href="#sec-labelled-statements-static-semantics-containsundefinedcontinuetarget">13.13.4</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-containsundefinedcontinuetarget">15.2.1.4</a>.</p>

      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedContinueTarget of <i>Block</i> with arguments <i>iterationSet</i>
            and &laquo;&nbsp;&raquo;.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedContinueTarget of <i>Catch</i> with arguments <i>iterationSet</i> and
            &laquo;&nbsp;&raquo;<i>.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedContinueTarget of <i>Block</i> with arguments <i>iterationSet</i>
            and &laquo;&nbsp;&raquo;.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedContinueTarget of <i>Finally</i> with arguments <i>iterationSet</i> and
            &laquo;&nbsp;&raquo;<i>.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedContinueTarget of <i>Block</i> with arguments <i>iterationSet</i>
            and &laquo;&nbsp;&raquo;.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Let <i>hasUndefinedLabels</i> be ContainsUndefinedContinueTarget of <i>Catch</i> with arguments <i>iterationSet</i>
            and &laquo;&nbsp;&raquo;.</li>
        <li>If <i>hasUndefinedLabels</i> is <b>true</b>, return <b>true</b>.</li>
        <li>Return ContainsUndefinedContinueTarget of <i>Finally</i> with arguments <i>iterationSet</i> and
            &laquo;&nbsp;&raquo;<i>.</i></li>
      </ol>
      <div class="gp prod"><span class="nt">Catch</span> <span class="geq">:</span> <code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span> <code class="t">)</code> <span class="nt">Block</span></div>
      <ol class="proc">
        <li>Return ContainsUndefinedContinueTarget of <i>Block</i> with arguments <i>iterationSet</i> and
            &laquo;&nbsp;&raquo;<i>.</i></li>
      </ol>
    </section>

    <section id="sec-try-statement-static-semantics-vardeclarednames">
      <h3 id="sec-13.15.5" title="13.15.5"> Static Semantics:  VarDeclaredNames</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-vardeclarednames">13.1.5</a>, <a href="#sec-block-static-semantics-vardeclarednames">13.2.11</a>, <a href="#sec-variable-statement-static-semantics-vardeclarednames">13.3.2.2</a>, <a href="#sec-if-statement-static-semantics-vardeclarednames">13.6.5</a>, <a href="#sec-do-while-statement-static-semantics-vardeclarednames">13.7.2.4</a>, <a href="#sec-while-statement-static-semantics-vardeclarednames">13.7.3.4</a>, <a href="#sec-for-statement-static-semantics-vardeclarednames">13.7.4.5</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-vardeclarednames">13.7.5.7</a>, <a href="#sec-with-statement-static-semantics-vardeclarednames">13.11.5</a>, <a href="#sec-switch-statement-static-semantics-vardeclarednames">13.12.7</a>, <a href="#sec-labelled-statements-static-semantics-vardeclarednames">13.13.12</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-vardeclarednames">14.1.15</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-vardeclarednames">14.2.12</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-vardeclarednames">15.1.5</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-vardeclarednames">15.2.1.13</a>.</p>

      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be VarDeclaredNames of <i>Block</i>.</li>
        <li>Append to <i>names</i> the elements of the VarDeclaredNames of <i>Catch.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be VarDeclaredNames of <i>Block</i>.</li>
        <li>Append to <i>names</i> the elements of the VarDeclaredNames of <i>Finally.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>names</i> be VarDeclaredNames of <i>Block</i>.</li>
        <li>Append to <i>names</i> the elements of the VarDeclaredNames of <i>Catch.</i></li>
        <li>Append to <i>names</i> the elements of the VarDeclaredNames of <i>Finally.</i></li>
        <li>Return <i>names</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">Catch</span> <span class="geq">:</span> <code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span> <code class="t">)</code> <span class="nt">Block</span></div>
      <ol class="proc">
        <li>Return the VarDeclaredNames of <i>Block</i>.</li>
      </ol>
    </section>

    <section id="sec-try-statement-static-semantics-varscopeddeclarations">
      <h3 id="sec-13.15.6" title="13.15.6"> Static Semantics:  VarScopedDeclarations</h3><p>See also: <a href="#sec-statement-semantics-static-semantics-varscopeddeclarations">13.1.6</a>, <a href="#sec-block-static-semantics-varscopeddeclarations">13.2.12</a>, <a href="#sec-variable-statement-static-semantics-varscopeddeclarations">13.3.2.3</a>, <a href="#sec-if-statement-static-semantics-varscopeddeclarations">13.6.6</a>, <a href="#sec-do-while-statement-static-semantics-varscopeddeclarations">13.7.2.5</a>, <a href="#sec-while-statement-static-semantics-varscopeddeclarations">13.7.3.5</a>, <a href="#sec-for-statement-static-semantics-varscopeddeclarations">13.7.4.6</a>, <a href="#sec-for-in-and-for-of-statements-static-semantics-varscopeddeclarations">13.7.5.8</a>, <a href="#sec-with-statement-static-semantics-varscopeddeclarations">13.11.6</a>, <a href="#sec-switch-statement-static-semantics-varscopeddeclarations">13.12.8</a>, <a href="#sec-labelled-statements-static-semantics-varscopeddeclarations">13.13.13</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-static-semantics-varscopeddeclarations">14.1.16</a>, <a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions-static-semantics-varscopeddeclarations">14.2.13</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scripts-static-semantics-varscopeddeclarations">15.1.6</a>, <a href="sec-ecmascript-language-scripts-and-modules#sec-module-semantics-static-semantics-varscopeddeclarations">15.2.1.14</a>.</p>

      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span></div>
      <ol class="proc">
        <li>Let <i>declarations</i> be VarScopedDeclarations of <i>Block</i>.</li>
        <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of <i>Catch.</i></li>
        <li>Return <i>declarations</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>declarations</i> be VarScopedDeclarations of <i>Block</i>.</li>
        <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of <i>Finally.</i></li>
        <li>Return <i>declarations</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>declarations</i> be VarScopedDeclarations of <i>Block</i>.</li>
        <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of <i>Catch.</i></li>
        <li>Append to <i>declarations</i> the elements of the VarScopedDeclarations of <i>Finally.</i></li>
        <li>Return <i>declarations</i>.</li>
      </ol>
      <div class="gp prod"><span class="nt">Catch</span> <span class="geq">:</span> <code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span> <code class="t">)</code> <span class="nt">Block</span></div>
      <ol class="proc">
        <li>Return the VarScopedDeclarations of <i>Block</i>.</li>
      </ol>
    </section>

    <section id="sec-runtime-semantics-catchclauseevaluation">
      <h3 id="sec-13.15.7" title="13.15.7"> Runtime Semantics: CatchClauseEvaluation</h3><p>with parameter <var>thrownValue</var></p>

      <div class="gp prod"><span class="nt">Catch</span> <span class="geq">:</span> <code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span> <code class="t">)</code> <span class="nt">Block</span></div>
      <ol class="proc">
        <li>Let <i>oldEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
        <li>Let <i>catchEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>oldEnv</i>).</li>
        <li>For each element <i>argName</i> of the BoundNames of <i>CatchParameter</i>, do
          <ol class="block">
            <li>Perform <i>catchEnv</i>.CreateMutableBinding(<i>argName</i>).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The above call to CreateMutableBinding will never return an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          </ol>
        </li>
        <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>catchEnv</i>.</li>
        <li>Let <i>status</i> be the result of performing BindingInitialization for <i>CatchParameter</i> passing
            <i>thrownValue</i> and <i>catchEnv</i> as arguments.</li>
        <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
          <ol class="block">
            <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>oldEnv</i>.</li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>).</li>
          </ol>
        </li>
        <li>Let <i>B</i> be the result of evaluating <i>Block</i>.</li>
        <li>Set <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>oldEnv</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>B</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> No matter how control leaves the <span class="nt">Block</span> the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> is always restored to its former state.</p>
      </div>
    </section>

    <section id="sec-try-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.15.8" title="13.15.8"> Runtime Semantics: Evaluation</h3><div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span></div>
      <ol class="proc">
        <li>Let <i>B</i> be the result of evaluating <i>Block</i>.</li>
        <li>If <i>B</i>.[[type]] is <span style="font-family: sans-serif">throw</span>, then
          <ol class="block">
            <li>Let <i>C</i> be CatchClauseEvaluation of <i>Catch</i> with parameter <i>B</i>.[[value]].</li>
          </ol>
        </li>
        <li>Else <i>B</i>.[[type]] is not <span style="font-family: sans-serif">throw</span><b>,</b>
          <ol class="block">
            <li>Let <i>C</i> be <i>B</i>.</li>
          </ol>
        </li>
        <li>If <i>C</i>.[[type]] is <span style="font-family: sans-serif">return</span>, or <i>C</i>.[[type]] is <span style="font-family: sans-serif">throw</span>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>C</i>).</li>
        <li>If <i>C</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>C</i>).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <i>C</i>.[[type]], [[value]]:
            <b>undefined</b>, [[target]]: <i>C</i>.[[target]]}.</li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>B</i> be the result of evaluating <i>Block</i>.</li>
        <li>Let <i>F</i> be the result of evaluating <i>Finally</i>.</li>
        <li>If <i>F</i>.[[type]] is <span style="font-family: sans-serif">normal</span>, let <i>F</i> be <i>B.</i></li>
        <li>If <i>F</i>.[[type]] is <span style="font-family: sans-serif">return</span>, or <i>F</i>.[[type]] is <span style="font-family: sans-serif">throw</span>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>F</i>).</li>
        <li>If <i>F</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>F</i>).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <i>F</i>.[[type]], [[value]]:
            <b>undefined</b>, [[target]]: <i>F</i>.[[target]]}.</li>
      </ol>
      <div class="gp prod"><span class="nt">TryStatement</span> <span class="geq">:</span> <code class="t">try</code> <span class="nt">Block</span> <span class="nt">Catch</span> <span class="nt">Finally</span></div>
      <ol class="proc">
        <li>Let <i>B</i> be the result of evaluating <i>Block</i>.</li>
        <li>If <i>B</i>.[[type]] is <span style="font-family: sans-serif">throw</span>, then
          <ol class="block">
            <li>Let <i>C</i> be CatchClauseEvaluation of <i>Catch</i> with parameter <i>B</i>.[[value]].</li>
          </ol>
        </li>
        <li>Else <i>B</i>.[[type]] is not <span style="font-family: sans-serif">throw</span><b>,</b> let <i>C</i> be
            <i>B</i>.</li>
        <li>Let <i>F</i> be the result of evaluating <i>Finally</i>.</li>
        <li>If <i>F</i>.[[type]] is <span style="font-family: sans-serif">normal</span>, let <i>F</i> be <i>C</i>.</li>
        <li>If <i>F</i>.[[type]] is <span style="font-family: sans-serif">return</span>, or <i>F</i>.[[type]] is <span style="font-family: sans-serif">throw</span>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>F</i>).</li>
        <li>If <i>F</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>F</i>.[[value]]).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <i>F</i>.[[type]], [[value]]:
            <b>undefined</b>, [[target]]: <i>F</i>.[[target]]}.</li>
      </ol>
    </section>
  </section>

  <section id="sec-debugger-statement">
    <div class="front">
      <h2 id="sec-13.16" title="13.16"> The
          </h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">DebuggerStatement</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">debugger</code> <code class="t">;</code></div>
      </div>
    </div>

    <section id="sec-debugger-statement-runtime-semantics-evaluation">
      <h3 id="sec-13.16.1" title="13.16.1"> Runtime Semantics: Evaluation</h3><div class="note">
        <p><span class="nh">NOTE</span> Evaluating the <span class="nt">DebuggerStatement</span> production may allow an
        implementation to cause a breakpoint when run under a debugger. If a debugger is not present or active this statement has
        no observable effect.</p>
      </div>

      <div class="gp prod"><span class="nt">DebuggerStatement</span> <span class="geq">:</span> <code class="t">debugger</code> <code class="t">;</code></div>
      <ol class="proc">
        <li>If an implementation defined debugging facility is available and enabled, then
          <ol class="block">
            <li>Perform an implementation defined debugging action.</li>
            <li>Let <i>result</i> be an implementation defined <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>
                value.</li>
          </ol>
        </li>
        <li>Else
          <ol class="block">
            <li>Let <i>result</i> be <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>
        </li>
        <li>Return <i>result.</i></li>
      </ol>
    </section>
  </section>
</section>

