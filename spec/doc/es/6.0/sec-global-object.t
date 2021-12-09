<section id="sec-global-object">
  <div class="front">
    <h1 id="sec-18" title="18"> The Global
        Object</h1><p>The unique <i>global object</i> is created before control enters any <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution
    context</a>.</p>

    <p>The global object does not have a [[Construct]] internal method; it is not possible to use the global object as a
    constructor with the <code>new</code> operator.</p>

    <p>The global object does not have a [[Call]] internal method; it is not possible to invoke the global object as a
    function.</p>

    <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the global
    object is implementation-dependent.</p>

    <p>In addition to the properties defined in this specification the global object may have additional host defined properties.
    This may include a property whose value is the global object itself; for example, in the HTML document object model the
    <code>window</code> property of the global object is the global object itself.</p>
  </div>

  <section id="sec-value-properties-of-the-global-object">
    <div class="front">
      <h2 id="sec-18.1" title="18.1"> Value Properties of the Global Object</h2></div>

    <section id="sec-value-properties-of-the-global-object-infinity">
      <h3 id="sec-18.1.1" title="18.1.1"> Infinity</h3><p>The value of <code>Infinity</code> is <b>+&infin;</b> (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-number-type">see
      6.1.6</a>). This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
      <b>false</b> }.</p>
    </section>

    <section id="sec-value-properties-of-the-global-object-nan">
      <h3 id="sec-18.1.2" title="18.1.2"> NaN</h3><p>The value of <code>NaN</code> is <b>NaN</b> (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-number-type">see 6.1.6</a>). This
      property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>false</b>
      }.</p>
    </section>

    <section id="sec-undefined">
      <h3 id="sec-18.1.3" title="18.1.3">
          undefined</h3><p>The value of <code>undefined</code> is <b>undefined</b> (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-undefined-type">see
      6.1.1</a>). This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
      <b>false</b> }.</p>
    </section>
  </section>

  <section id="sec-function-properties-of-the-global-object">
    <div class="front">
      <h2 id="sec-18.2" title="18.2"> Function Properties of the Global Object</h2></div>

    <section id="sec-eval-x">
      <div class="front">
        <h3 id="sec-18.2.1" title="18.2.1"> eval
            (x)</h3><p class="normalbefore">The <code>eval</code> function is the %eval% intrinsic object. When the <code>eval</code> function
        is called with one argument <var>x</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>evalRealm</i> be the value of the active function object&rsquo;s [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>strictCaller</i> be <b>false</b>.</li>
          <li>Let <i>directEval</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-performeval">PerformEval</a>(<i>x</i>, <i>evalRealm</i>, <i>strictCaller</i>,
              <i>directEval</i>).</li>
        </ol>
      </div>

      <section id="sec-performeval">
        <h4 id="sec-18.2.1.1" title="18.2.1.1">
            Runtime Semantics: PerformEval( x, evalRealm, strictCaller, direct)</h4><p class="normalbefore">The abstract operation PerformEval with arguments <var>x</var>, <var>evalRealm</var>,
        <var>strictCaller</var>, and <var>direct</var> performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: If <i>direct</i> is <b>false</b> then  <i>strictCaller</i> is also
              <b>false</b>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is not String, return <i>x</i>.</li>
          <li>Let <i>script</i> be the ECMAScript code that is the result of parsing <i>x</i>, interpreted as UTF-16 encoded
              Unicode text as described in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a><i>,</i> for the goal
              symbol <i>Script</i>. If the parse fails or any early errors are detected, throw a <b>SyntaxError</b> exception (but
              <a href="sec-error-handling-and-language-extensions">see also clause 16</a>).</li>
          <li>If <i>script</i> Contains <i>ScriptBody</i> is <b>false</b>, return <b>undefined</b>.</li>
          <li>Let <i>body</i> be the <i>ScriptBody</i> of <i>script.</i></li>
          <li>If <i>strictCaller</i> is <b>true</b>, let <i>strictEval</i> be <b>true.</b></li>
          <li>Else, let <i>strictEval</i> be IsStrict of <i>script</i>.</li>
          <li>Let <i>ctx</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>. If <i>direct</i> is
              <b>true</b> <i>ctx</i> will be the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> that performed the direct
              <code>eval</code>. If <i>direct</i> is <b>false</b> <i>ctx</i> will be the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> for the invocation of the eval function.</li>
          <li>If <i>direct</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>lexEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>ctx&rsquo;s</i>
                  <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>).</li>
              <li>Let <i>varEnv</i> be <i>ctx&rsquo;s</i> <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>lexEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>evalRealm</i>.[[globalEnv]]).</li>
              <li>Let <i>varEnv</i> be <i>evalRealm</i>.[[globalEnv]].</li>
            </ol>
          </li>
          <li>If <i>strictEval</i> is <b>true</b>, let <i>varEnv</i> be <i>lexEnv</i>.</li>
          <li>If <i>ctx</i> is not already <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">suspended</a>, <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <i>ctx</i>.</li>
          <li>Let <i>evalCxt</i> be a new <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">ECMAScript code execution context</a>.</li>
          <li>Set the <i>evalCxt&rsquo;s</i> <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>  to <i>evalRealm</i>.</li>
          <li>Set the <i>evalCxt&rsquo;s</i> <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> to <i>varEnv</i>.</li>
          <li>Set the <i>evalCxt&rsquo;s</i> <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> to <i>lexEnv</i>.</li>
          <li>Push <i>evalCxt</i> on to <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>; <i>evalCxt</i> is now
              <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li>Let <i>result</i> be <a href="#sec-evaldeclarationinstantiation">EvalDeclarationInstantiation</a>(<i>body</i>,
              <i>varEnv</i>, <i>lexEnv</i>, <i>strictEval</i>).</li>
          <li>If <i>result</i>.[[type]] is <span style="font-family: sans-serif">normal</span>, then
            <ol class="block">
              <li>Let <i>result</i> be the result of evaluating <i>body</i>.</li>
            </ol>
          </li>
          <li>If <i>result</i>.[[type]] is <span style="font-family: sans-serif">normal</span> and <i>result</i>.[[value]] is
              <span style="font-family: sans-serif">empty</span>,  then
            <ol class="block">
              <li>Let <i>result</i> be <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
            </ol>
          </li>
          <li><a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <i>evalCxt</i> and remove it from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>.</li>
          <li>Resume the context that is now on the top of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> as <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>result</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The eval code cannot instantiate variable or function bindings in the variable
          environment of the calling context that invoked the eval if the calling context is evaluating formal parameter
          initializers or if either the code of the calling context or the eval code is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict
          code</a>. Instead such bindings are instantiated in a new <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> that
          is only accessible to the eval code. Bindings introduced by <code>let</code>, <code>const</code>, or <code>class</code>
          declarations are always instantiated in a new <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</p>
        </div>
      </section>

      <section id="sec-evaldeclarationinstantiation">
        <h4 id="sec-18.2.1.2" title="18.2.1.2"> Runtime Semantics: EvalDeclarationInstantiation( body, varEnv,
            lexEnv, strict)</h4><p>When the abstract operation EvalDeclarationInstantiation is called with arguments <var>body</var>, <var>varEnv</var>,
        <var>lexEnv</var>, and <var>strict</var> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>varNames</i> be the VarDeclaredNames of <i>body</i>.</li>
          <li>Let <i>varDeclarations</i> be the VarScopedDeclarations of <i>body</i>.</li>
          <li>Let <i>lexEnvRec</i> be <i>lexEnv</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
          <li>Let <i>varEnvRec</i> be <i>varEnv</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
          <li>If <i>strict</i> is <b>false</b>, then
            <ol class="block">
              <li>If <i>varEnvRec</i> is a global <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>, then
                <ol class="block">
                  <li>For each <i>name</i> in <i>varNames</i>, do
                    <ol class="block">
                      <li>If <i>varEnvRec.</i><a href="sec-executable-code-and-execution-contexts#sec-haslexicaldeclaration">HasLexicalDeclaration</a>(<i>name</i>) is
                          <b>true</b>, throw a <b>SyntaxError</b> exception.</li>
                      <li>NOTE:  <code>eval</code> will not create a global var declaration that would be shadowed by a global
                          lexical declaration.</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li>Let <i>thisLex</i> be <i>lexEnv</i>.</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: the following loop will terminate.</li>
              <li>Repeat while <i>thisLex</i> is not the same as <i>varEnv,</i>
                <ol class="block">
                  <li>Let <i>thisEnvRec</i> be <i>thisLex</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
                  <li>If <i>thisEnvRec</i> is not an object <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>, then
                    <ol class="block">
                      <li>NOTE:  The environment of with statements cannot contain any lexical declaration so it doesn&rsquo;t
                          need to be checked for var/let hoisting conflicts.</li>
                      <li>For each <i>name</i> in <i>varNames</i>, do
                        <ol class="block">
                          <li>If <i>thisEnvRec.</i>HasBinding(<i>name</i>) is <b>true</b>, then
                            <ol class="block">
                              <li>Throw a <b>SyntaxError</b> exception.</li>
                            </ol>
                          </li>
                          <li>NOTE:  A direct <code>eval</code> will not hoist var declaration over a like-named lexical
                              declaration.</li>
                        </ol>
                      </li>
                    </ol>
                  </li>
                  <li>Let <i>thisLex</i> be <i>thisLex</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">outer environment
                      reference</a>.</li>
                </ol>
              </li>
            </ol>
          </li>
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
                      <li>If <i>varEnvRec</i> is a global <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>, then
                        <ol class="block">
                          <li>Let <i>fnDefinable</i> be <i>varEnvRec</i>.<a href="sec-executable-code-and-execution-contexts#sec-candeclareglobalfunction">CanDeclareGlobalFunction</a>(<i>fn</i>).</li>
                          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fnDefinable</i>).</li>
                          <li>If <i>fnDefinable</i> is <b>false</b>, throw <b>SyntaxError</b> exception.</li>
                        </ol>
                      </li>
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
                          <li>If <i>varEnvRec</i> is a global <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>, then
                            <ol class="block">
                              <li>Let <i>vnDefinable</i> be <i>varEnvRec.</i><a href="sec-executable-code-and-execution-contexts#sec-candeclareglobalvar">CanDeclareGlobalVar</a>(<i>vn</i>).</li>
                              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>vnDefinable</i>).</li>
                              <li>If <i>vnDefinable</i> is <b>false</b>, throw <b>SyntaxError</b> exception.</li>
                            </ol>
                          </li>
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
          <li>NOTE: No abnormal terminations occur after this algorithm step unless <span style="font-family: Times New               Roman"><i>varEnvRec</i></span> is a global <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> and the global
              object is a Proxy exotic object.</li>
          <li>Let <i>lexDeclarations</i> be the LexicallyScopedDeclarations of <i>body</i>.</li>
          <li>For each element <i>d</i> in <i>lexDeclarations</i> do
            <ol class="block">
              <li>NOTE  Lexically declared names are only instantiated here but not initialized.</li>
              <li>For each element <i>dn</i> of the BoundNames of <i>d</i> do
                <ol class="block">
                  <li>If  IsConstantDeclaration of <i>d</i> is <b>true</b>, then
                    <ol class="block">
                      <li>Let <i>status</i> be <i>lexEnvRec</i>.CreateImmutableBinding(<i>dn</i>, <b>true</b>).</li>
                    </ol>
                  </li>
                  <li>Else,
                    <ol class="block">
                      <li>Let <i>status</i> be <i>lexEnvRec</i>.CreateMutableBinding(<i>dn</i>, <b>false</b>).</li>
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
              <li>Let <i>fo</i> be the result of performing InstantiateFunctionObject  for <i>f</i> with argument
                  <i>lexEnv</i>.</li>
              <li>If <i>varEnvRec</i> is a global <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>, then
                <ol class="block">
                  <li>Let <i>status</i> be <i>varEnvRec</i>.<a href="sec-executable-code-and-execution-contexts#sec-createglobalfunctionbinding">CreateGlobalFunctionBinding</a>(<i>fn</i>, <i>fo</i>,
                      <b>true</b>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>bindingExists</i> be <i>varEnvRec</i>.HasBinding(<i>fn</i>).</li>
                  <li>If <i>bindingExists</i> is <b>false</b>, then
                    <ol class="block">
                      <li>Let <i>status</i> be <i>varEnvRec</i>.CreateMutableBinding(<i>fn</i>, <b>true</b>).</li>
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> because of validation preceding
                          step 12.</li>
                      <li>Let <i>status</i> be <i>varEnvRec</i>.InitializeBinding(<i>fn</i>, <i>fo</i>).</li>
                    </ol>
                  </li>
                  <li>Else,
                    <ol class="block">
                      <li>Let <i>status</i> be <i>varEnvRec</i>.SetMutableBinding(<i>fn</i>, <i>fo</i>, <b>false</b>).</li>
                    </ol>
                  </li>
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>For each String <i>vn</i> in <i>declaredVarNames</i>, in list order do
            <ol class="block">
              <li>If <i>varEnvRec</i> is a global <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>, then
                <ol class="block">
                  <li>Let <i>status</i> be <i>varEnvRec.</i><a href="sec-executable-code-and-execution-contexts#sec-createglobalvarbinding">CreateGlobalVarBinding</a>(<i>vn</i>, <b>true</b>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>bindingExists</i> be <i>varEnvRec</i>.HasBinding(<i>vn</i>).</li>
                  <li>If <i>bindingExists</i> is <b>false</b>, then
                    <ol class="block">
                      <li>Let <i>status</i> be <i>varEnvRec</i>.CreateMutableBinding(<i>vn</i>, <b>true</b>).</li>
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> because of validation preceding
                          step 12.</li>
                      <li>Let <i>status</i> be <i>varEnvRec</i>.InitializeBinding(<i>vn</i>, <b>undefined</b>).</li>
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                    </ol>
                  </li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>)</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> An alternative version of this algorithm is described in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-variablestatements-in-catch-blocks">B.3.5</a>.</p>
        </div>
      </section>
    </section>

    <section id="sec-isfinite-number">
      <h3 id="sec-18.2.2" title="18.2.2">
          isFinite (number)</h3><p class="normalbefore">The <code>isFinite</code> function is the %isFinite% intrinsic object. When the
      <code>isFinite</code> function is called with one argument <var>x</var>, the following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>num</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>number</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>num</i>).</li>
        <li>If <i>num</i> is <b>NaN</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return <b>false</b>.</li>
        <li>Otherwise, return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-isnan-number">
      <h3 id="sec-18.2.3" title="18.2.3"> isNaN
          (number)</h3><p class="normalbefore">The <code>isNaN</code> function is the %isNaN% intrinsic object. When the <code>isNaN</code>
      function is called with one argument <var>number</var>, the following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>num</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>number</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>num</i>).</li>
        <li>If <i>num</i> is <b>NaN</b>, return <b>true</b>.</li>
        <li>Otherwise, return <b>false</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> A reliable way for ECMAScript code to test if a value <code>X</code> is a <b>NaN</b> is an
        expression of the form <code>X !== X</code>. The result will be <b>true</b> if and only if <code>X</code> is a
        <b>NaN</b>.</p>
      </div>
    </section>

    <section id="sec-parsefloat-string">
      <h3 id="sec-18.2.4" title="18.2.4">
          parseFloat (string)</h3><p>The <code>parseFloat</code> function produces a Number value dictated by interpretation of the contents of the
      <var>string</var> argument as a decimal literal.</p>

      <p class="normalbefore">The <code>parseFloat</code> function is the %parseFloat% intrinsic object. When the
      <code>parseFloat</code> function is called with one argument <var>string</var>, the following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>inputString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>string</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>inputString</i>).</li>
        <li>Let <i>trimmedString</i> be a substring of <i>inputString</i> consisting of the leftmost code unit that is not a
            <i>StrWhiteSpaceChar</i> and all code units to the right of that code unit. (In other words, remove leading white
            space.) If <i>inputString</i> does not contain any such code units, let <i>trimmedString</i> be the empty string.</li>
        <li>If neither <i>trimmedString</i> nor any prefix of <i>trimmedString</i> satisfies the syntax of a
            <i>StrDecimalLiteral</i> (<a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">see 7.1.3.1</a>), return <b>NaN</b>.</li>
        <li>Let <i>numberString</i> be the longest prefix of <i>trimmedString</i>, which might be <i>trimmedString</i> itself,
            that satisfies the syntax of a <i>StrDecimalLiteral</i>.</li>
        <li>Let <i>mathFloat</i> be MV of <i>numberString</i>.</li>
        <li>If <i>mathFloat</i>=0, then
          <ol class="block">
            <li>If the first code unit of <i>trimmedString</i> is <code>"-"</code>, return &minus;0.</li>
            <li>Return +0.</li>
          </ol>
        </li>
        <li>Return the Number value for <i>mathFloat</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> <code>parseFloat</code> may interpret only a leading portion of <var>string</var> as a
        Number value; it ignores any code units that cannot be interpreted as part of the notation of an decimal literal, and no
        indication is given that any such code units were ignored.</p>
      </div>
    </section>

    <section id="sec-parseint-string-radix">
      <h3 id="sec-18.2.5" title="18.2.5">
          parseInt (string , radix)</h3><p>The <code>parseInt</code> function produces an integer value dictated by interpretation of the contents of the
      <var>string</var> argument according to the specified <var>radix</var>. Leading white space in <var>string</var> is ignored.
      If <var>radix</var> is <b>undefined</b> or 0, it is assumed to be <span style="font-family: Times New Roman">10</span>
      except when the number begins with the code unit pairs <code>0x</code> or <code>0X</code>, in which case a radix of 16 is
      assumed. If <var>radix</var> is <span style="font-family: Times New Roman">16,</span> the number may also optionally begin
      with the code unit pairs <code>0x</code> or <code>0X</code>.</p>

      <p class="normalbefore">The <code>parseInt</code> function is the %parseInt% intrinsic object. When the
      <code>parseInt</code> function is called, the following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>inputString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>string</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>string</i>).</li>
        <li>Let <i>S</i> be a newly created substring of <i>inputString</i> consisting of the first code unit that is not a
            <i>StrWhiteSpaceChar</i> and all code units following that code unit. (In other words, remove leading white space.) If
            <i>inputString</i> does not contain any such code unit, let <i>S</i> be the empty string.</li>
        <li>Let <i>sign</i> be 1.</li>
        <li>If <i>S</i> is not empty and the first code unit of <i>S</i> is 0x002D (HYPHEN-MINUS), let <i>sign</i> be
            &minus;1.</li>
        <li>If <i>S</i> is not empty and the first code unit of <i>S</i> is 0x002B (PLUS SIGN) or 0x002D (HYPHEN-MINUS), remove
            the first code unit from <i>S</i>.</li>
        <li>Let <i>R</i> = <a href="sec-abstract-operations#sec-toint32">ToInt32</a>(<i>radix</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>R</i>).</li>
        <li>Let <i>stripPrefix</i> be <b>true</b>.</li>
        <li>If <i>R</i> &ne; 0, then
          <ol class="block">
            <li>If <i>R</i> &lt; 2 or <i>R</i> &gt; 36, return <b>NaN</b>.</li>
            <li>If <i>R</i> &ne; 16, let <i>stripPrefix</i> be <b>false</b>.</li>
          </ol>
        </li>
        <li>Else <i>R</i> = 0,
          <ol class="block">
            <li>Let <i>R</i> = 10.</li>
          </ol>
        </li>
        <li>If <i>stripPrefix</i> is <b>true</b>, then
          <ol class="block">
            <li>If the length of <i>S</i> is at least 2 and the first two code units of <i>S</i> are either <code>"0x"</code> or
                <code>"0X"</code>, remove the first two code units from <i>S</i> and let <i>R</i> = 16.</li>
          </ol>
        </li>
        <li>If <i>S</i> contains a code unit that is not a radix-<i>R</i> digit, let <i>Z</i> be the substring of <i>S</i>
            consisting of all code units before the first such code unit; otherwise, let <i>Z</i> be <i>S</i>.</li>
        <li>If <i>Z</i> is empty, return <b>NaN</b>.</li>
        <li>Let <i>mathInt</i> be the mathematical integer value that is represented by <i>Z</i> in radix-<i>R</i> notation, using
            the letters <b>A</b>-<b>Z</b> and <b>a</b>-<b>z</b> for digits with values 10 through 35. (However, if <i>R</i> is 10
            and <i>Z</i> contains more than 20 significant digits, every significant digit after the 20th may be replaced by a
            <b>0</b> digit, at the option of the implementation; and if <i>R</i> is not 2, 4, 8, 10, 16, or 32, then
            <i>mathInt</i> may be an implementation-dependent approximation to the mathematical integer value that is represented
            by <i>Z</i> in radix-<i>R</i> notation.)</li>
        <li>If <i>mathInt</i> = 0, then
          <ol class="block">
            <li>If <i>sign</i> = &minus;1,  return &minus;0.</li>
            <li>Return +0.</li>
          </ol>
        </li>
        <li>Let <i>number</i> be the Number value for <i>mathInt</i>.</li>
        <li>Return <i>sign</i> &times; <i>number</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> <code>parseInt</code> may interpret only a leading portion of <var>string</var> as an
        integer value; it ignores any code units that cannot be interpreted as part of the notation of an integer, and no
        indication is given that any such code units were ignored.</p>
      </div>
    </section>

    <section id="sec-uri-handling-functions">
      <div class="front">
        <h3 id="sec-18.2.6" title="18.2.6"> URI Handling Functions</h3><p>Uniform Resource Identifiers, or URIs, are Strings that identify resources (e.g. web pages or files) and transport
        protocols by which to access them (e.g. HTTP or FTP) on the Internet. The ECMAScript language itself does not provide any
        support for using URIs except for functions that encode and decode URIs as described in <a href="#sec-decodeuri-encodeduri">18.2.6.2</a>, <a href="#sec-decodeuricomponent-encodeduricomponent">18.2.6.3</a>, <a href="#sec-encodeuri-uri">18.2.6.4</a> and <a href="#sec-encodeuricomponent-uricomponent">18.2.6.5</a></p>

        <div class="note">
          <p><span class="nh">NOTE</span> Many implementations of ECMAScript provide additional functions and methods that
          manipulate web pages; these functions are beyond the scope of this standard.</p>
        </div>
      </div>

      <section id="sec-uri-syntax-and-semantics">
        <div class="front">
          <h4 id="sec-18.2.6.1" title="18.2.6.1"> URI Syntax and Semantics</h4><p>A URI is composed of a sequence of components separated by component separators. The general form is:</p>

          <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="prod"><span class="nt">Scheme</span> <span class="geq">:</span> <span class="nt">First</span> <code class="t">/</code> <span class="nt">Second</span> <code class="t">;</code> <span class="nt">Third</span> <code class="t">?</code> <span class="nt">Fourth</span></span></p>

          <p>where the italicized names represent components and &ldquo;<code>:</code>&rdquo;, &ldquo;<code>/</code>&rdquo;,
          &ldquo;<code>;</code>&rdquo; and &ldquo;<code>?</code>&rdquo; are reserved for use as separators. The
          <code>encodeURI</code> and <code>decodeURI</code> functions are intended to work with complete URIs; they assume that
          any reserved code units in the URI are intended to have special meaning and so are not encoded. The
          <code>encodeURIComponent</code> and <code>decodeURIComponent</code> functions are intended to work with the individual
          component parts of a URI; they assume that any reserved code units represent text and so must be encoded so that they
          are not interpreted as reserved code units when the component is part of a complete URI.</p>

          <p>The following lexical grammar specifies the form of encoded URIs.</p>

          <h2>Syntax</h2>

          <div class="gp">
            <div class="lhs"><span class="nt">uri</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">uriCharacters</span><sub class="g-opt">opt</sub></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">uriCharacters</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">uriCharacter</span> <span class="nt">uriCharacters</span><sub class="g-opt">opt</sub></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">uriCharacter</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">uriReserved</span></div>
            <div class="rhs"><span class="nt">uriUnescaped</span></div>
            <div class="rhs"><span class="nt">uriEscaped</span></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">uriReserved</span> <span class="geq">:::</span> <span class="grhsmod">one of</span></div>
            <div class="rhs"><code class="t">;</code> <code class="t">/</code> <code class="t">?</code> <code class="t">:</code> <code class="t">@</code> <code class="t">&amp;</code> <code class="t">=</code> <code class="t">+</code> <code class="t">$</code> <code class="t">,</code></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">uriUnescaped</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">uriAlpha</span></div>
            <div class="rhs"><span class="nt">DecimalDigit</span></div>
            <div class="rhs"><span class="nt">uriMark</span></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">uriEscaped</span> <span class="geq">:::</span></div>
            <div class="rhs"><code class="t">%</code> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">uriAlpha</span> <span class="geq">:::</span> <span class="grhsmod">one of</span></div>
            <div class="rhs"><code class="t">a</code> <code class="t">b</code> <code class="t">c</code> <code class="t">d</code> <code class="t">e</code> <code class="t">f</code> <code class="t">g</code> <code class="t">h</code> <code class="t">i</code> <code class="t">j</code> <code class="t">k</code> <code class="t">l</code> <code class="t">m</code> <code class="t">n</code> <code class="t">o</code> <code class="t">p</code> <code class="t">q</code> <code class="t">r</code> <code class="t">s</code> <code class="t">t</code> <code class="t">u</code> <code class="t">v</code> <code class="t">w</code> <code class="t">x</code> <code class="t">y</code> <code class="t">z</code></div>
            <div class="rhs"><code class="t">A</code> <code class="t">B</code> <code class="t">C</code> <code class="t">D</code> <code class="t">E</code> <code class="t">F</code> <code class="t">G</code> <code class="t">H</code> <code class="t">I</code> <code class="t">J</code> <code class="t">K</code> <code class="t">L</code> <code class="t">M</code> <code class="t">N</code> <code class="t">O</code> <code class="t">P</code> <code class="t">Q</code> <code class="t">R</code> <code class="t">S</code> <code class="t">T</code> <code class="t">U</code> <code class="t">V</code> <code class="t">W</code> <code class="t">X</code> <code class="t">Y</code> <code class="t">Z</code></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">uriMark</span> <span class="geq">:::</span> <span class="grhsmod">one of</span></div>
            <div class="rhs"><code class="t">-</code> <code class="t">_</code> <code class="t">.</code> <code class="t">!</code> <code class="t">~</code> <code class="t">*</code> <code class="t">'</code> <code class="t">(</code> <code class="t">)</code></div>
          </div>

          <div class="note">
            <p><span class="nh">NOTE</span> The above syntax is based upon RFC 2396 and does not reflect changes introduced by the
            more recent RFC 3986.</p>
          </div>

          <p><b>Runtime Semantics</b></p>

          <p>When a code unit to be included in a URI is not listed above or is not intended to have the special meaning sometimes
          given to the reserved code units, that code unit must be encoded. The code unit is transformed into its UTF-8 encoding,
          with surrogate pairs first converted from UTF-16 to the corresponding code point value. (Note that for code units in the
          range [0,127] this results in a single octet with the same value.) The resulting sequence of octets is then transformed
          into a String with each octet represented by an escape sequence of the form <code><b>"%</b>xx<b>"</b></code>.</p>
        </div>

        <section id="sec-encode">
          <h5 id="sec-18.2.6.1.1" title="18.2.6.1.1">
              Runtime Semantics: Encode ( string, unescapedSet )</h5><p class="normalbefore">The encoding and escaping process is described by the abstract operation Encode taking two
          String arguments <var>string</var> and <var>unescapedSet</var>.</p>

          <ol class="proc">
            <li>Let <i>strLen</i> be the number of code units in <i>string</i>.</li>
            <li>Let <i>R</i> be the empty String.</li>
            <li>Let <i>k</i> be 0.</li>
            <li>Repeat
              <ol class="block">
                <li>If <i>k</i> equals <i>strLen</i>, return <i>R</i>.</li>
                <li>Let <i>C</i> be the code unit at index <i>k</i> within <i>string</i>.</li>
                <li>If <i>C</i> is in <i>unescapedSet</i>, then
                  <ol class="block">
                    <li>Let <i>S</i> be a String containing only the code unit <i>C</i>.</li>
                    <li>Let <i>R</i> be a new String value computed by concatenating the previous value of <i>R</i> and
                        <i>S</i>.</li>
                  </ol>
                </li>
                <li>Else <i>C</i> is not in <i>unescapedSet</i>,
                  <ol class="block">
                    <li>If the code unit value of <i>C</i> is not less than 0xDC00 and not greater than 0xDFFF, throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> exception.</li>
                    <li>If the code unit value of <i>C</i> is less than 0xD800 or greater than 0xDBFF, then
                      <ol class="block">
                        <li>Let <i>V</i> be the code unit value of <i>C</i>.</li>
                      </ol>
                    </li>
                    <li>Else,
                      <ol class="block">
                        <li>Increase <i>k</i> by 1.</li>
                        <li>If <i>k</i> equals <i>strLen</i>, throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> exception.</li>
                        <li>Let <i>kChar</i> be the code unit value of the code unit at index <i>k</i> within <i>string</i>.</li>
                        <li>If <i>kChar</i> is less than 0xDC00 or greater than 0xDFFF, throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> exception.</li>
                        <li>Let <i>V</i> be <a href="sec-ecmascript-language-source-code#sec-utf16decode">UTF16Decode</a>(<i>C</i>, <i>kChar</i>).</li>
                      </ol>
                    </li>
                    <li>Let <i>Octets</i> be the array of octets resulting by applying the UTF-8 transformation to <i>V</i>, and
                        let <i>L</i> be the array size.</li>
                    <li>Let <i>j</i> be 0.</li>
                    <li>Repeat, while <i>j</i> &lt; <i>L</i>
                      <ol class="block">
                        <li>Let <i>jOctet</i> be the value at index <i>j</i> within <i>Octets</i>.</li>
                        <li>Let <i>S</i> be a String containing three code units <code>"%</code><i>XY</i><code>"</code> where
                            <i>XY</i> are two uppercase hexadecimal digits encoding the value of <i>jOctet</i>.</li>
                        <li>Let <i>R</i> be a new String value computed by concatenating the previous value of <i>R</i> and
                            <i>S</i>.</li>
                        <li>Increase <i>j</i> by 1.</li>
                      </ol>
                    </li>
                  </ol>
                </li>
                <li>Increase <i>k</i> by 1.</li>
              </ol>
            </li>
          </ol>
        </section>

        <section id="sec-decode">
          <h5 id="sec-18.2.6.1.2" title="18.2.6.1.2">
              Runtime Semantics: Decode ( string, reservedSet )</h5><p>The unescaping and decoding process is described by the abstract operation Decode taking two String arguments
          <var>string</var> and <var>reservedSet</var>.</p>

          <ol class="proc">
            <li>Let <i>strLen</i> be the number of code units in <i>string</i>.</li>
            <li>Let <i>R</i> be the empty String.</li>
            <li>Let <i>k</i> be 0.</li>
            <li>Repeat
              <ol class="block">
                <li>If <i>k</i> equals <i>strLen</i>, return <i>R</i>.</li>
                <li>Let <i>C</i> be the code unit at index <i>k</i> within <i>string</i>.</li>
                <li>If <i>C</i> is not <code>"<b>%</b>"</code>, then
                  <ol class="block">
                    <li>Let <i>S</i> be the String containing only the code unit <i>C</i>.</li>
                  </ol>
                </li>
                <li>Else <i>C</i> is <code>"<b>%</b>"</code>,
                  <ol class="block">
                    <li>Let <i>start</i> be <i>k</i>.</li>
                    <li>If <i>k</i> + 2 is greater than or equal to <i>strLen</i>, throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> exception.</li>
                    <li>If the code units at index (<i>k</i>+1) and (<i>k</i> + 2) within <i>string</i> do not represent
                        hexadecimal digits, throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> exception.</li>
                    <li>Let <i>B</i> be the 8-bit value represented by the two hexadecimal digits at index (<i>k</i> + 1) and
                        (<i>k</i> + 2).</li>
                    <li>Increment <i>k</i> by 2.</li>
                    <li>If the most significant bit in <i>B</i> is 0, then
                      <ol class="block">
                        <li>Let <i>C</i> be the code unit with code unit value <i>B</i>.</li>
                        <li>If <i>C</i> is not in <i>reservedSet</i>, then
                          <ol class="block">
                            <li>Let <i>S</i> be the String containing only the code unit <i>C</i>.</li>
                          </ol>
                        </li>
                        <li>Else <i>C</i> is in <i>reservedSet</i>,
                          <ol class="block">
                            <li>Let <i>S</i> be the substring of <i>string</i> from index <i>start</i> to index <i>k</i>
                                inclusive.</li>
                          </ol>
                        </li>
                      </ol>
                    </li>
                    <li>Else the most significant bit in <i>B</i> is 1,
                      <ol class="block">
                        <li>Let <i>n</i> be the smallest nonnegative integer such that (<i>B</i> &lt;&lt; <i>n</i>) &amp; 0x80 is
                            equal to 0.</li>
                        <li>If <i>n</i> equals 1 or <i>n</i> is greater than 4, throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> exception.</li>
                        <li>Let <i>Octets</i> be an array of 8-bit integers of size <i>n</i>.</li>
                        <li>Put <i>B</i> into <i>Octets</i> at index 0.</li>
                        <li>If <i>k</i> + (3 &times; (<i>n</i> &ndash; 1)) is greater than or equal to <i>strLen</i>, throw a
                            <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b>
                            exception.</li>
                        <li>Let <i>j</i> be 1.</li>
                        <li>Repeat, while <i>j</i> &lt; <i>n</i>
                          <ol class="block">
                            <li>Increment <i>k</i> by 1.</li>
                            <li>If the code unit at index <i>k</i> within <i>string</i> is not <code>"%"</code>, throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> exception.</li>
                            <li>If the code units at index (<i>k</i> +1) and (<i>k</i> + 2) within <i>string</i> do not represent
                                hexadecimal digits, throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> exception.</li>
                            <li>Let <i>B</i> be the 8-bit value represented by the two hexadecimal digits at index (<i>k</i> + 1)
                                and (<i>k</i> + 2).</li>
                            <li>If the two most significant bits in <i>B</i> are not 10, throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> exception.</li>
                            <li>Increment <i>k</i> by 2.</li>
                            <li>Put <i>B</i> into <i>Octets</i> at index <i>j</i>.</li>
                            <li>Increment <i>j</i> by 1.</li>
                          </ol>
                        </li>
                        <li>Let <i>V</i> be the value obtained by applying the UTF-8 transformation to <i>Octets</i>, that is,
                            from an array of octets into a 21-bit value. If <i>Octets</i> does not contain a valid UTF-8 encoding
                            of a Unicode code point throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> exception.</li>
                        <li>If <i>V</i> &lt; 0x10000, then
                          <ol class="block">
                            <li>Let <i>C</i> be the code unit <i>V</i>.</li>
                            <li>If <i>C</i> is not in <i>reservedSet</i>, then
                              <ol class="block">
                                <li>Let <i>S</i> be the String containing only the code unit <i>C</i>.</li>
                              </ol>
                            </li>
                            <li>Else <i>C</i> is in <i>reservedSet</i>,
                              <ol class="block">
                                <li>Let <i>S</i> be the substring of <i>string</i> from index <i>start</i> to index <i>k</i>
                                    inclusive.</li>
                              </ol>
                            </li>
                          </ol>
                        </li>
                        <li>Else <i>V</i> &ge; 0x10000,
                          <ol class="block">
                            <li>Let <i>L</i> be (((<i>V</i> &ndash; 0x10000) &amp; 0x3FF) + 0xDC00).</li>
                            <li>Let <i>H</i> be ((((<i>V</i> &ndash; 0x10000) &gt;&gt; 10) &amp; 0x3FF) + 0xD800).</li>
                            <li>Let <i>S</i> be the String containing the two code units <i>H</i> and <i>L</i>.</li>
                          </ol>
                        </li>
                      </ol>
                    </li>
                  </ol>
                </li>
                <li>Let <i>R</i> be a new String value computed by concatenating the previous value of <i>R</i> and <i>S</i>.</li>
                <li>Increase <i>k</i> by 1.</li>
              </ol>
            </li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> This syntax of Uniform Resource Identifiers is based upon RFC 2396 and does not
            reflect the more recent RFC 3986 which replaces RFC 2396. A formal description and implementation of UTF-8 is given in
            RFC 3629.</p>

            <p>In UTF-8, characters are encoded using sequences of 1 to 6 octets. The only octet of a sequence of one has the
            higher-order bit set to 0, the remaining 7 bits being used to encode the character value. In a sequence of n octets,
            n&gt;1, the initial octet has the n higher-order bits set to 1, followed by a bit set to 0. The remaining bits of that
            octet contain bits from the value of the character to be encoded. The following octets all have the higher-order bit
            set to 1 and the following bit set to 0, leaving 6 bits in each to contain bits from the character to be encoded. The
            possible UTF-8 encodings of ECMAScript characters are specified in <a href="#table-43">Table 43</a>.</p>

            <figure>
              <figcaption><span id="table-43">Table 43</span> (Informative) &mdash; UTF-8 Encodings</figcaption>
              <table class="real-table">
                <tr>
                  <th>Code Unit Value</th>
                  <th>Representation</th>
                  <th>1<sup>st</sup> Octet</th>
                  <th>2<sup>nd</sup> Octet</th>
                  <th>3<sup>rd</sup> Octet</th>
                  <th>4<sup>th</sup> Octet</th>
                </tr>
                <tr>
                  <td><code>0x0000 - 0x007F</code></td>
                  <td><code>00000000</code> <code><b>0</b><i>zzzzzzz</i></code></td>
                  <td><code><b>0</b><i>zzzzzzz</i></code></td>
                  <td />
                  <td />
                  <td />
                </tr>
                <tr>
                  <td><code>0x0080 - 0x07FF</code></td>
                  <td><code><b>00000</b><i>yyy yyzzzzzz</i></code></td>
                  <td><code><b>110</b><i>yyyyy</i></code></td>
                  <td><code><b>10</b><i>zzzzzz</i></code></td>
                  <td />
                  <td />
                </tr>
                <tr>
                  <td><code>0x0800 - 0xD7FF</code></td>
                  <td><span style="font-family: monospace"><i>xxxxyyyy yyzzzzzz</i></span></td>
                  <td><code><b>1110</b><i>xxxx</i></code></td>
                  <td><code><b>10</b><i>yyyyyy</i></code></td>
                  <td><code><b>10</b><i>zzzzzz</i></code></td>
                  <td />
                </tr>
                <tr>
                  <td><code>0xD800 - 0xDBFF<br /></code><span style="font-family: sans-serif"><i>followed by<br /></i></span><code>0xDC00 &ndash; 0xDFFF</code></td>
                  <td><code><b>110110</b><i>vv vvwwwwxx<br /></i></code><i><span style="font-family: sans-serif">followed by<br /></span></i><code><b>110111</b><i>yy yyzzzzzz</i></code></td>
                  <td><code><b>11110</b><i>uuu</i></code></td>
                  <td><code><b>10</b><i>uuwwww</i></code></td>
                  <td><code><b>10</b><i>xxyyyy</i></code></td>
                  <td><code><b>10</b><i>zzzzzz</i></code></td>
                </tr>
                <tr>
                  <td><code>0xD800 - 0xDBFF<br /></code><span style="font-family: sans-serif"><i>not followed by<br /></i></span><code>0xDC00 &ndash; 0xDFFF</code></td>
                  <td><span style="font-family: sans-serif"><i>causes</i></span> <code><b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b></code></td>
                  <td />
                  <td />
                  <td />
                  <td />
                </tr>
                <tr>
                  <td><code>0xDC00 &ndash; 0xDFFF</code></td>
                  <td><span style="font-family: sans-serif"><i>causes</i></span> <code><b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b></code></td>
                  <td />
                  <td />
                  <td />
                  <td />
                </tr>
                <tr>
                  <td><code>0xE000 - 0xFFFF</code></td>
                  <td><span style="font-family: monospace"><i>xxxxyyyy yyzzzzzz</i></span></td>
                  <td><code><b>1110</b><i>xxxx</i></code></td>
                  <td><code><b>10</b><i>yyyyyy</i></code></td>
                  <td><code><b>10</b><i>zzzzzz</i></code></td>
                  <td />
                </tr>
              </table>
            </figure>

            <p>Where<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<var>uuuuu</var> <span style="font-family: Times New Roman">=</span>
            <var>vvvv</var>  <span style="font-family: Times New Roman">+</span> <span style="font-family: Times New             Roman">1</span><br />to account for the addition of 0x10000 as in Surrogates, section 3.7, of the Unicode Standard.</p>

            <p>The range of code unit values 0xD800-0xDFFF is used to encode surrogate pairs; the above transformation combines a
            UTF-16 surrogate pair into a UTF-32 representation and encodes the resulting 21-bit value in UTF-8. Decoding
            reconstructs the surrogate pair.</p>

            <p>RFC 3629 prohibits the decoding of invalid UTF-8 octet sequences. For example, the invalid sequence C0 80 must not
            decode into the code unit 0x0000. Implementations of the Decode algorithm are required to throw a <b><a href="#sec-constructor-properties-of-the-global-object-urierror">URIError</a></b> when encountering such invalid
            sequences.</p>
          </div>
        </section>
      </section>

      <section id="sec-decodeuri-encodeduri">
        <h4 id="sec-18.2.6.2" title="18.2.6.2"> decodeURI (encodedURI)</h4><p>The <code>decodeURI</code> function computes a new version of a URI in which each escape sequence and UTF-8 encoding of
        the sort that might be introduced by the <code>encodeURI</code> function is replaced with the UTF-16 encoding of the code
        points that it represents. Escape sequences that could not have been introduced by <code>encodeURI</code> are not
        replaced.</p>

        <p class="normalbefore">The <code>decodeURI</code> function is the %decodeURI% intrinsic object. When the
        <code>decodeURI</code> function is called with one argument <var>encodedURI</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>uriString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>encodedURI</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>uriString</i>).</li>
          <li>Let <i>reservedURISet</i> be a String containing one instance of each code unit valid in <i>uriReserved</i> plus
              <code>"#"</code>.</li>
          <li>Return <a href="#sec-decode">Decode</a>(<i>uriString</i>, <i>reservedURISet</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The code point <code>"#"</code> is not decoded from escape sequences even though it is
          not a reserved URI code point.</p>
        </div>
      </section>

      <section id="sec-decodeuricomponent-encodeduricomponent">
        <h4 id="sec-18.2.6.3" title="18.2.6.3"> decodeURIComponent (encodedURIComponent)</h4><p>The <code>decodeURIComponent</code> function computes a new version of a URI in which each escape sequence and UTF-8
        encoding of the sort that might be introduced by the <code>encodeURIComponent</code> function is replaced with the UTF-16
        encoding of the code points that it represents.</p>

        <p class="normalbefore">The <code>decodeURIComponent</code> function is the %decodeURIComponent% intrinsic object. When
        the <code>decodeURIComponent</code> function is called with one argument <var>encodedURIComponent</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>componentString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>encodedURIComponent</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>componentString</i>).</li>
          <li>Let <i>reservedURIComponentSet</i> be the empty String.</li>
          <li>Return <a href="#sec-decode">Decode</a>(<i>componentString</i>, <i>reservedURIComponentSet</i>).</li>
        </ol>
      </section>

      <section id="sec-encodeuri-uri">
        <h4 id="sec-18.2.6.4" title="18.2.6.4">
            encodeURI (uri)</h4><p>The <code>encodeURI</code> function computes a new version of a UTF-16 encoded (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>) URI in which each instance of certain code points is replaced
        by one, two, three, or four escape sequences representing the UTF-8 encoding of the code points.</p>

        <p class="normalbefore">The <code>encodeURI</code> function is the %encodeURI% intrinsic object. When the
        <code>encodeURI</code> function is called with one argument <span class="nt">uri</span>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>uriString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>uri</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>uriString</i>).</li>
          <li>Let <i>unescapedURISet</i> be a String containing one instance of each code unit valid in <i>uriReserved</i> and
              <i>uriUnescaped</i> plus "<code>#</code>".</li>
          <li>Return <a href="#sec-encode">Encode</a>(<i>uriString</i>, <i>unescapedURISet</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The code unit <code>"#"</code> is not encoded to an escape sequence even though it is
          not a reserved or unescaped URI code point.</p>
        </div>
      </section>

      <section id="sec-encodeuricomponent-uricomponent">
        <h4 id="sec-18.2.6.5" title="18.2.6.5"> encodeURIComponent (uriComponent)</h4><p>The <code>encodeURIComponent</code> function computes a new version of a UTF-16 encoded (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>) URI in which each instance of certain code points is replaced
        by one, two, three, or four escape sequences representing the UTF-8 encoding of the code point.</p>

        <p class="normalbefore">The <code>encodeURIComponent</code> function is the %encodeURIComponent% intrinsic object. When
        the <code>encodeURIComponent</code> function is called with one argument <span class="nt">uriComponent</span>, the
        following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>componentString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>uriComponent</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>componentString</i>).</li>
          <li>Let <i>unescapedURIComponentSet</i> be a String containing one instance of each code unit valid in
              <i>uriUnescaped</i>.</li>
          <li>Return <a href="#sec-encode">Encode</a>(<i>componentString</i>, <i>unescapedURIComponentSet</i>).</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-constructor-properties-of-the-global-object">
    <div class="front">
      <h2 id="sec-18.3" title="18.3"> Constructor Properties of the Global Object</h2></div>

    <section id="sec-constructor-properties-of-the-global-object-array">
      <h3 id="sec-18.3.1" title="18.3.1"> Array ( . . . )</h3><p>See <a href="sec-indexed-collections#sec-array-constructor">22.1.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-arraybuffer">
      <h3 id="sec-18.3.2" title="18.3.2"> ArrayBuffer ( . . . )</h3><p>See <a href="sec-structured-data#sec-arraybuffer-constructor">24.1.2</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-boolean">
      <h3 id="sec-18.3.3" title="18.3.3"> Boolean ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-boolean-constructor">19.3.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-dataview">
      <h3 id="sec-18.3.4" title="18.3.4"> DataView ( . . . )</h3><p>See <a href="sec-structured-data#sec-dataview-constructor">24.2.2</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-date">
      <h3 id="sec-18.3.5" title="18.3.5"> Date ( . . . )</h3><p>See <a href="sec-numbers-and-dates#sec-date-constructor">20.3.2</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-error">
      <h3 id="sec-18.3.6" title="18.3.6"> Error ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-error-constructor">19.5.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-evalerror">
      <h3 id="sec-18.3.7" title="18.3.7"> EvalError ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-evalerror">19.5.5.1</a>.</p>
    </section>

    <section id="sec-float32array">
      <h3 id="sec-18.3.8" title="18.3.8">
          Float32Array ( . . . )</h3><p>See <a href="sec-indexed-collections#sec-typedarray-constructors">22.2.4</a>.</p>
    </section>

    <section id="sec-float64array">
      <h3 id="sec-18.3.9" title="18.3.9">
          Float64Array ( . . . )</h3><p>See <a href="sec-indexed-collections#sec-typedarray-constructors">22.2.4</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-function">
      <h3 id="sec-18.3.10" title="18.3.10"> Function ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-function-constructor">19.2.1</a>.</p>
    </section>

    <section id="sec-int8array">
      <h3 id="sec-18.3.11" title="18.3.11"> Int8Array
          ( . . . )</h3><p>See <a href="sec-indexed-collections#sec-typedarray-constructors">22.2.4</a>.</p>
    </section>

    <section id="sec-int16array">
      <h3 id="sec-18.3.12" title="18.3.12">
          Int16Array ( . . . )</h3><p>See <a href="sec-indexed-collections#sec-typedarray-constructors">22.2.4</a>.</p>
    </section>

    <section id="sec-int32array">
      <h3 id="sec-18.3.13" title="18.3.13">
          Int32Array ( . . . )</h3><p>See <a href="sec-indexed-collections#sec-typedarray-constructors">22.2.4</a>.</p>
    </section>

    <section id="sec-map">
      <h3 id="sec-18.3.14" title="18.3.14"> Map ( . . .
          )</h3><p>See <a href="sec-keyed-collection#sec-map-constructor">23.1.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-number">
      <h3 id="sec-18.3.15" title="18.3.15"> Number ( . . . )</h3><p>See <a href="sec-numbers-and-dates#sec-number-constructor">20.1.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-object">
      <h3 id="sec-18.3.16" title="18.3.16"> Object ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-object-constructor">19.1.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-proxy">
      <h3 id="sec-18.3.17" title="18.3.17"> Proxy ( . . . )</h3><p>See <a href="sec-reflection#sec-proxy-constructor">26.2.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-promise">
      <h3 id="sec-18.3.18" title="18.3.18"> Promise ( . . . )</h3><p>See <a href="sec-control-abstraction-objects#sec-promise-constructor">25.4.3</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-rangeerror">
      <h3 id="sec-18.3.19" title="18.3.19"> RangeError ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-rangeerror">19.5.5.2</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-referenceerror">
      <h3 id="sec-18.3.20" title="18.3.20"> ReferenceError ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-referenceerror">19.5.5.3</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-regexp">
      <h3 id="sec-18.3.21" title="18.3.21"> RegExp ( . . . )</h3><p>See <a href="sec-text-processing#sec-regexp-constructor">21.2.3</a>.</p>
    </section>

    <section id="sec-set">
      <h3 id="sec-18.3.22" title="18.3.22"> Set ( . . .
          )</h3><p>See <a href="sec-keyed-collection#sec-set-constructor">23.2.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-string">
      <h3 id="sec-18.3.23" title="18.3.23"> String ( . . . )</h3><p>See <a href="sec-text-processing#sec-string-constructor">21.1.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-symbol">
      <h3 id="sec-18.3.24" title="18.3.24"> Symbol ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-symbol-constructor">19.4.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-syntaxerror">
      <h3 id="sec-18.3.25" title="18.3.25"> SyntaxError ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-syntaxerror">19.5.5.4</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-typeerror">
      <h3 id="sec-18.3.26" title="18.3.26"> TypeError ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-typeerror">19.5.5.5</a>.</p>
    </section>

    <section id="sec-uint8array">
      <h3 id="sec-18.3.27" title="18.3.27">
          Uint8Array ( . . . )</h3><p>See <a href="sec-indexed-collections#sec-typedarray-constructors">22.2.4</a>.</p>
    </section>

    <section id="sec-uint8clampedarray">
      <h3 id="sec-18.3.28" title="18.3.28">
          Uint8ClampedArray ( . . . )</h3><p>See <a href="sec-indexed-collections#sec-typedarray-constructors">22.2.4</a>.</p>
    </section>

    <section id="sec-uint16array">
      <h3 id="sec-18.3.29" title="18.3.29">
          Uint16Array ( . . . )</h3><p>See <a href="sec-indexed-collections#sec-typedarray-constructors">22.2.4</a>.</p>
    </section>

    <section id="sec-uint32array">
      <h3 id="sec-18.3.30" title="18.3.30">
          Uint32Array ( . . . )</h3><p>See <a href="sec-indexed-collections#sec-typedarray-constructors">22.2.4</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-urierror">
      <h3 id="sec-18.3.31" title="18.3.31"> URIError ( . . . )</h3><p>See <a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-urierror">19.5.5.6</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-weakmap">
      <h3 id="sec-18.3.32" title="18.3.32"> WeakMap ( . . . )</h3><p>See <a href="sec-keyed-collection#sec-weakmap-constructor">23.3.1</a>.</p>
    </section>

    <section id="sec-constructor-properties-of-the-global-object-weakset">
      <h3 id="sec-18.3.33" title="18.3.33"> WeakSet ( . . . )</h3><p>See <a href="sec-keyed-collection#sec-weakset-objects">23.4</a>.</p>
    </section>
  </section>

  <section id="sec-other-properties-of-the-global-object">
    <div class="front">
      <h2 id="sec-18.4" title="18.4"> Other Properties of the Global Object</h2></div>

    <section id="sec-json">
      <h3 id="sec-18.4.1" title="18.4.1"> JSON</h3><p>See <a href="sec-structured-data#sec-json-object">24.3</a>.</p>
    </section>

    <section id="sec-math">
      <h3 id="sec-18.4.2" title="18.4.2"> Math</h3><p>See <a href="sec-numbers-and-dates#sec-math-object">20.2</a>.</p>
    </section>

    <section id="sec-reflect">
      <h3 id="sec-18.4.3" title="18.4.3"> Reflect</h3><p>See <a href="sec-reflection#sec-reflect-object">26.1</a>.</p>
    </section>
  </section>
</section>

