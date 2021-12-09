<section id="sec-executable-code-and-execution-contexts">
  <div class="front">
    <h1 id="sec-8" title="8"> Executable Code and Execution Contexts</h1></div>

  <section id="sec-lexical-environments">
    <div class="front">
      <h2 id="sec-8.1" title="8.1">
          Lexical Environments</h2><p>A <i>Lexical Environment</i> is a specification type used to define the association of <span class="nt">Identifiers</span> to specific variables and functions based upon the lexical nesting structure of ECMAScript
      code. A Lexical Environment consists of an <a href="#sec-environment-records">Environment Record</a> and a possibly null
      reference to an <i>outer</i> Lexical Environment. Usually a Lexical Environment is associated with some specific syntactic
      structure of ECMAScript code such as a <span class="nt">FunctionDeclaration</span>, a <span class="nt">BlockStatement</span>, or a <span class="nt">Catch</span> clause of a <span class="nt">TryStatement</span> and a
      new Lexical Environment is created each time such code is evaluated.</p>

      <p>An <a href="#sec-environment-records">Environment Record</a> records the identifier bindings that are created within the
      scope of its associated Lexical Environment. It is referred to as the Lexical Environment&rsquo;s EnvironmentRecord</p>

      <p>The outer environment reference is used to model the logical nesting of Lexical Environment values. The outer reference
      of a (inner) Lexical Environment is a reference to the Lexical Environment that logically surrounds the inner Lexical
      Environment. An outer Lexical Environment may, of course, have its own outer Lexical Environment. A Lexical Environment may
      serve as the outer environment for multiple inner Lexical Environments. For example, if a <span class="nt">FunctionDeclaration</span> contains two nested <span class="nt">FunctionDeclarations</span> then the Lexical
      Environments of each of the nested functions will have as their outer Lexical Environment the Lexical Environment of the
      current evaluation of the surrounding function.</p>

      <p>A <i>global environment</i> is a Lexical Environment which does not have an outer environment. The global
      environment&rsquo;s outer environment reference is <b>null</b>. A global environment&rsquo;s EnvironmentRecord may be
      prepopulated with identifier bindings and includes an associated <i>global object</i> whose properties provide some of <a href="#sec-global-environment-records">the global environment</a>&rsquo;s identifier bindings. This global object is the
      value of a global environment&rsquo;s <code>this</code> binding. As ECMAScript code is executed, additional properties may
      be added to the global object and the initial properties may be modified.</p>

      <p>A <i>module environment</i> is a Lexical Environment that contains the bindings for the top level declarations of a <span class="nt">Module</span>. It also contains the bindings that are explicitly imported by the <span class="nt">Module</span>.
      The outer environment of a module environment is a global environment.</p>

      <p>A <i>function environment</i> is a Lexical Environment that corresponds to the invocation of an <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ecmascript-function-objects">ECMAScript function object</a>. A function environment may establish a new
      <code>this</code> binding. A function environment also captures the state necessary to support <code>super</code> method
      invocations.</p>

      <p>Lexical Environments and <a href="#sec-environment-records">Environment Record</a> values are purely specification
      mechanisms and need not correspond to any specific artefact of an ECMAScript implementation. It is impossible for an
      ECMAScript program to directly access or manipulate such values.</p>
    </div>

    <section id="sec-environment-records">
      <div class="front">
        <h3 id="sec-8.1.1" title="8.1.1">
            Environment Records</h3><p>There are two primary kinds of Environment Record values used in this specification: <i>declarative Environment
        Records</i> and <i>object Environment Records</i>. Declarative Environment Records are used to define the effect of
        ECMAScript language syntactic elements such as <span class="nt">FunctionDeclarations</span>, <span class="nt">VariableDeclarations</span>, and <span class="nt">Catch</span> clauses that directly associate identifier
        bindings with <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a>. Object Environment Records are used
        to define the effect of ECMAScript elements such as <span class="nt">WithStatement</span> that associate identifier
        bindings with the properties of some object. <a href="#sec-global-environment-records">Global Environment Records</a> and
        function Environment Records are specializations that are used for specifically for <span class="nt">Script</span> global
        declarations and for top-level declarations within functions.</p>

        <p>For specification purposes Environment Record values are values of the Record specification type and can be thought of
        as existing in a simple object-oriented hierarchy where Environment Record is an abstract class with three concrete
        subclasses, declarative Environment Record, object Environment Record, and global Environment Record. <a href="#sec-function-environment-records">Function Environment Records</a> and module Environment Records are subclasses of
        declarative Environment Record. The abstract class includes the abstract specification methods defined in <a href="#table-15">Table 15</a>. These abstract methods have distinct concrete algorithms for each of the concrete
        subclasses.</p>

        <figure>
          <figcaption><span id="table-15">Table 15</span> &mdash; Abstract Methods of Environment Records</figcaption>
          <table class="real-table">
            <tr>
              <th>Method</th>
              <th>Purpose</th>
            </tr>
            <tr>
              <td>HasBinding(N)</td>
              <td>Determine if an Environment Record has a binding for the String value <var>N</var>. Return <b>true</b> if it does and <b>false</b> if it does not</td>
            </tr>
            <tr>
              <td>CreateMutableBinding(N, D)</td>
              <td>Create a new but uninitialized mutable binding in an Environment Record. The String value <var>N</var> is the text of the bound name. If the optional Boolean argument <var>D</var> is <b>true</b> the binding is may be subsequently deleted.</td>
            </tr>
            <tr>
              <td>CreateImmutableBinding(N, S)</td>
              <td>Create a new but uninitialized immutable binding in an Environment Record. The String value <var>N</var> is the text of the bound name. If <var>S</var> is <b>true</b> then attempts to access the value of the binding before it is initialized or set it after it has been initialized will always throw an exception, regardless of the strict mode setting of operations that reference that binding. <var>S</var> is an optional parameter that defaults to <b>false</b>.</td>
            </tr>
            <tr>
              <td>InitializeBinding(N,V)</td>
              <td>Set the value of an already existing but uninitialized binding in an Environment Record. The String value <var>N</var> is the text of the bound name. <var>V</var> is the value for the binding and is a value of any <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language type</a>.</td>
            </tr>
            <tr>
              <td>SetMutableBinding(N,V, S)</td>
              <td>Set the value of an already existing mutable binding in an Environment Record. The String value <var>N</var> is the text of the bound name. <var>V</var> is the value for the binding and may be a value of any <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language type</a>. <var>S</var> is a Boolean flag. If <var>S</var> is <b>true</b> and the binding cannot be set throw a <b>TypeError</b> exception.</td>
            </tr>
            <tr>
              <td>GetBindingValue(N,S)</td>
              <td>Returns the value of an already existing binding from an Environment Record. The String value <var>N</var> is the text of the bound name. <var>S</var> is used to identify references originating in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> or that otherwise require strict mode reference semantics. If <var>S</var> is <b>true</b> and the binding does not exist throw a <b>ReferenceError</b> exception. If the binding exists but is uninitialized a <b>ReferenceError</b> is thrown, regardless of the value of <i><span style="font-family: Times New Roman">S</span>.</i></td>
            </tr>
            <tr>
              <td>DeleteBinding(N)</td>
              <td>Delete a binding from an Environment Record. The String value <var>N</var> is the text of the bound name. If a binding for <var>N</var> exists, remove the binding and return <b>true</b>. If the binding exists but cannot be removed return <b>false</b>. If the binding does not exist return <b>true</b>.</td>
            </tr>
            <tr>
              <td>HasThisBinding()</td>
              <td>Determine if an Environment Record establishes a <code>this</code> binding. Return <b>true</b> if it does and <b>false</b> if it does not.</td>
            </tr>
            <tr>
              <td>HasSuperBinding()</td>
              <td>Determine if an Environment Record establishes a <code>super</code> method binding. Return <b>true</b> if it does and <b>false</b> if it does not.</td>
            </tr>
            <tr>
              <td>WithBaseObject ()</td>
              <td>If this Environment Record is associated with a <code>with</code> statement, return the with object. Otherwise, return <span class="value">undefined</span>.</td>
            </tr>
          </table>
        </figure>
      </div>

      <section id="sec-declarative-environment-records">
        <div class="front">
          <h4 id="sec-8.1.1.1" title="8.1.1.1"> Declarative Environment Records</h4><p>Each declarative <a href="#sec-environment-records">Environment Record</a> is associated with an ECMAScript program
          scope containing variable, constant, let, class, module, import, and/or function declarations. A declarative <a href="#sec-environment-records">Environment Record</a> binds the set of identifiers defined by the declarations
          contained within its scope.</p>

          <p>The behaviour of the concrete specification methods for declarative Environment Records is defined by the following
          algorithms.</p>
        </div>

        <section id="sec-declarative-environment-records-hasbinding-n">
          <h5 id="sec-8.1.1.1.1" title="8.1.1.1.1"> HasBinding(N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method HasBinding for
          declarative Environment Records simply determines if the argument identifier is one of the identifiers bound by the
          record:</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the declarative <a href="#sec-environment-records">Environment Record</a> for which the
                method was invoked.</li>
            <li>If <i>envRec</i> has a binding for the name that is the value of <i>N</i>, return <b>true</b>.</li>
            <li>Return <b>false</b>.</li>
          </ol>
        </section>

        <section id="sec-declarative-environment-records-createmutablebinding-n-d">
          <h5 id="sec-8.1.1.1.2" title="8.1.1.1.2"> CreateMutableBinding (N, D)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          CreateMutableBinding for declarative Environment Records creates a new mutable binding for the name <var>N</var> that is
          uninitialized. A binding must not already exist in this <a href="#sec-environment-records">Environment Record</a> for
          <var>N</var>. If Boolean argument <var>D</var> is provided and has the value <b>true</b> the new binding is marked as
          being subject to deletion.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the declarative <a href="#sec-environment-records">Environment Record</a> for which the
                method was invoked.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> does not already have a binding for <i>N</i>.</li>
            <li>Create a mutable binding in <i>envRec</i> for <i>N</i> and record that it is uninitialized. If <i>D</i> is
                <b>true</b> record that the newly created binding may be deleted by a subsequent DeleteBinding call.</li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>
        </section>

        <section id="sec-declarative-environment-records-createimmutablebinding-n-s">
          <h5 id="sec-8.1.1.1.3" title="8.1.1.1.3"> CreateImmutableBinding (N, S)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          CreateImmutableBinding for declarative Environment Records creates a new immutable binding for the name <var>N</var>
          that is uninitialized. A binding must not already exist in this <a href="#sec-environment-records">Environment
          Record</a> for <var>N</var>. If Boolean argument <var>S</var> is provided and has the value <b>true</b> the new binding
          is marked as a strict binding.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the declarative <a href="#sec-environment-records">Environment Record</a> for which the
                method was invoked.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> does not already have a binding for <i>N</i>.</li>
            <li>Create an immutable binding in <i>envRec</i> for <i>N</i> and record that it is uninitialized. If <i>S</i> is
                <b>true</b> record that the newly created binding is a strict binding.</li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>
        </section>

        <section id="sec-declarative-environment-records-initializebinding-n-v">
          <h5 id="sec-8.1.1.1.4" title="8.1.1.1.4"> InitializeBinding (N,V)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method InitializeBinding
          for declarative Environment Records is used to set the bound value of the current binding of the identifier whose name
          is the value of the argument <var>N</var> to the value of argument <var>V</var>. An uninitialized binding for
          <var>N</var> must already exist.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the declarative <a href="#sec-environment-records">Environment Record</a> for which the
                method was invoked.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> must have an uninitialized binding for
                <i>N</i>.</li>
            <li>Set the bound value for <i>N</i> in <i>envRec</i> to <i>V</i>.</li>
            <li>Record that the binding for <i>N</i> in <i>envRec</i> has been initialized.</li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>
        </section>

        <section id="sec-declarative-environment-records-setmutablebinding-n-v-s">
          <h5 id="sec-8.1.1.1.5" title="8.1.1.1.5"> SetMutableBinding (N,V,S)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method SetMutableBinding
          for declarative Environment Records attempts to change the bound value of the current binding of the identifier whose
          name is the value of the argument <var>N</var> to the value of argument <var>V</var>. A binding for <var>N</var>
          normally already exist, but in rare cases it may not. If the binding is an immutable binding, a <b>TypeError</b> is
          thrown if <span style="font-family: Times New Roman">S</span> is <span class="value">true</span>.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the declarative <a href="#sec-environment-records">Environment Record</a> for which the
                method was invoked.</li>
            <li>If <i>envRec</i> does not have a binding for <i>N</i>, then
              <ol class="block">
                <li>If <i>S</i> is <b>true</b> throw a <b>ReferenceError</b> exception.</li>
                <li>Perform <i>envRec</i>.CreateMutableBinding(<i>N</i>, <b>true</b>).</li>
                <li>Perform <i>envRec</i>.InitializeBinding(<i>N</i>, <i>V</i>).</li>
                <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                     sans-serif">empty</span>).</li>
              </ol>
            </li>
            <li>If the binding for <i>N</i> in <i>envRec</i> is a strict binding, let <i>S</i> be <b>true</b>.</li>
            <li>If the binding for <i>N</i> in <i>envRec</i> has not yet been initialized throw a <b>ReferenceError</b>
                exception.</li>
            <li>Else if the binding for <i>N</i> in <i>envRec</i> is a mutable binding, change its bound value to <i>V</i>.</li>
            <li>Else this must be an attempt to change the value of an immutable binding so if <i>S</i> is <b>true</b> throw a
                <b>TypeError</b> exception.</li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> An example of ECMAScript code that results in a missing binding at step 2 is:</p>

            <pre class="NoteCode">function f(){eval("var x; x = (delete x, 0);")}</pre>
          </div>
        </section>

        <section id="sec-declarative-environment-records-getbindingvalue-n-s">
          <h5 id="sec-8.1.1.1.6" title="8.1.1.1.6"> GetBindingValue(N,S)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method GetBindingValue
          for declarative Environment Records simply returns the value of its bound identifier whose name is the value of the
          argument <var>N</var>. If the binding exists but is uninitialized a <b>ReferenceError</b> is thrown, regardless of the
          value of <i><span style="font-family: Times New Roman">S</span>.</i></p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the declarative <a href="#sec-environment-records">Environment Record</a> for which the
                method was invoked.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> has a binding for <i>N</i>.</li>
            <li>If the binding for <i>N</i> in <i>envRec</i> is an uninitialized binding, throw a <b>ReferenceError</b>
                exception.</li>
            <li>Return the value currently bound to <i>N</i> in <i>envRec</i>.</li>
          </ol>
        </section>

        <section id="sec-declarative-environment-records-deletebinding-n">
          <h5 id="sec-8.1.1.1.7" title="8.1.1.1.7"> DeleteBinding (N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method DeleteBinding for
          declarative Environment Records can only delete bindings that have been explicitly designated as being subject to
          deletion.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the declarative <a href="#sec-environment-records">Environment Record</a> for which the
                method was invoked.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> has a binding for the name that is the value of
                <i>N</i>.</li>
            <li>If the binding for <i>N</i> in <i>envRec</i> cannot be deleted, return <b>false</b>.</li>
            <li>Remove the binding for <i>N</i> from <i>envRec</i>.</li>
            <li>Return <b>true</b>.</li>
          </ol>
        </section>

        <section id="sec-declarative-environment-records-hasthisbinding">
          <h5 id="sec-8.1.1.1.8" title="8.1.1.1.8"> HasThisBinding ()</h5><p class="normalbefore">Regular declarative Environment Records  do not provide a <code>this</code> binding.</p>

          <ol class="proc">
            <li>Return <b>false</b>.</li>
          </ol>
        </section>

        <section id="sec-declarative-environment-records-hassuperbinding">
          <h5 id="sec-8.1.1.1.9" title="8.1.1.1.9"> HasSuperBinding ()</h5><p class="normalbefore">Regular declarative Environment Records do not provide a <code>super</code> binding.</p>

          <ol class="proc">
            <li>Return <b>false</b>.</li>
          </ol>
        </section>

        <section id="sec-declarative-environment-records-withbaseobject">
          <h5 id="sec-8.1.1.1.10" title="8.1.1.1.10"> WithBaseObject()</h5><p class="normalbefore">Declarative Environment Records  always return <b>undefined</b> as their WithBaseObject.</p>

          <ol class="proc">
            <li>Return <b>undefined</b>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-object-environment-records">
        <div class="front">
          <h4 id="sec-8.1.1.2" title="8.1.1.2"> Object Environment Records</h4><p>Each object <a href="#sec-environment-records">Environment Record</a> is associated with an object called its
          <i>binding object</i>. An object <a href="#sec-environment-records">Environment Record</a> binds the set of string
          identifier names that directly correspond to the property names of its binding object. Property keys that are not
          strings in the form of an <span class="nt">IdentifierName</span> are not included in the set of bound identifiers. Both
          own and inherited properties are included in the set regardless of the setting of their [[Enumerable]] attribute.
          Because properties can be dynamically added and deleted from objects, the set of identifiers bound by an object <a href="#sec-environment-records">Environment Record</a> may potentially change as a side-effect of any operation that
          adds or deletes properties. Any bindings that are created as a result of such a side-effect are considered to be a
          mutable binding even if the Writable attribute of the corresponding property has the value <b>false</b>. Immutable
          bindings do not exist for object Environment Records.</p>

          <p>Object Environment Records created for <code>with</code> statements (<a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement">13.11</a>) can
          provide their binding object as an implicit <b>this</b> value for use in function calls. The capability is controlled by
          a <var>withEnvironment</var> Boolean value that is associated with each object <a href="#sec-environment-records">Environment Record</a>. By default, the value of <var>withEnvironment</var> is
          <b>false</b> for any object <a href="#sec-environment-records">Environment Record</a>.</p>

          <p>The behaviour of the concrete specification methods for object Environment Records is defined by the following
          algorithms.</p>
        </div>

        <section id="sec-object-environment-records-hasbinding-n">
          <h5 id="sec-8.1.1.2.1" title="8.1.1.2.1"> HasBinding(N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method HasBinding for
          object Environment Records determines if its associated binding object has a property whose name is the value of the
          argument <var>N</var>:</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the object <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>bindings</i> be the binding object for <i>envRec</i>.</li>
            <li>Let <i>foundBinding</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>bindings</i>, <i>N</i>)</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>foundBinding</i>).</li>
            <li>If <i>foundBinding</i> is <b>false</b>, return <b>false</b>.</li>
            <li>If the <i>withEnvironment</i> flag of <i>envRec</i> is <b>false</b>, return <b>true</b>.</li>
            <li>Let <i>unscopables</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>bindings</i>, @@unscopables).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>unscopables</i>).</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>unscopables</i>) is Object, then
              <ol class="block">
                <li>Let <i>blocked</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>unscopables</i>, <i>N</i>)).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>blocked</i>).</li>
                <li>If <i>blocked</i> is <b>true</b>, return <b>false</b>.</li>
              </ol>
            </li>
            <li>Return <b>true</b>.</li>
          </ol>
        </section>

        <section id="sec-object-environment-records-createmutablebinding-n-d">
          <h5 id="sec-8.1.1.2.2" title="8.1.1.2.2"> CreateMutableBinding (N, D)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          CreateMutableBinding for object Environment Records creates in an Environment Record&rsquo;s associated binding object a
          property whose name is the String value and initializes it to the value <b>undefined</b>. If Boolean argument
          <var>D</var> is provided and has the value <b>true</b> the new property&rsquo;s [[Configurable]] attribute is set to
          <b>true</b>, otherwise it is set to <b>false</b>.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the object <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>bindings</i> be the binding object for <i>envRec</i>.</li>
            <li>If <i>D</i> is <b>true</b> then let <i>configValue</i> be <b>true</b> otherwise let <i>configValue</i> be
                <b>false</b>.</li>
            <li>Return <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>bindings</i>, <i>N</i>,
                PropertyDescriptor{[[Value]]:<b>undefined</b>, [[Writable]]: <b>true</b>, [[Enumerable]]: <b>true</b> ,
                [[Configurable]]: <i>configValue</i>}).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> Normally <i>envRec</i> will not have a binding for <i>N</i> but if it does, the
            semantics of <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a> may result in an existing binding being
            replaced or shadowed or cause an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> to be
            returned.</p>
          </div>
        </section>

        <section id="sec-object-environment-records-createimmutablebinding-n-s">
          <h5 id="sec-8.1.1.2.3" title="8.1.1.2.3"> CreateImmutableBinding (N, S)</h5><p>The concrete <a href="#sec-environment-records">Environment Record</a> method CreateImmutableBinding is never used
          within this specification in association with Object Environment Records.</p>
        </section>

        <section id="sec-object-environment-records-initializebinding-n-v">
          <h5 id="sec-8.1.1.2.4" title="8.1.1.2.4"> InitializeBinding (N,V)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method InitializeBinding
          for object Environment Records is used to set the bound value of the current binding of the identifier whose name is the
          value of the argument <var>N</var> to the value of argument <var>V</var>. An uninitialized binding for <var>N</var> must
          already exist.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the object <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> must have an uninitialized binding for
                <i>N</i>.</li>
            <li>Record that the binding for <i>N</i> in <i>envRec</i> has been initialized.</li>
            <li>Return <i>envRec</i>.SetMutableBinding(<i>N</i>, <i>V</i>, <b>false</b>).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> In this specification, all uses of CreateMutableBinding for object Environment Records
            are immediately followed by a call to InitializeBinding for the same name. Hence, implementations do not need to
            explicitly track the initialization state of individual object Environment Record bindings.</p>
          </div>
        </section>

        <section id="sec-object-environment-records-setmutablebinding-n-v-s">
          <h5 id="sec-8.1.1.2.5" title="8.1.1.2.5"> SetMutableBinding (N,V,S)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method SetMutableBinding
          for object Environment Records attempts to set the value of the Environment Record&rsquo;s associated binding
          object&rsquo;s property whose name is the value of the argument <var>N</var> to the value of argument <var>V</var>. A
          property named <var>N</var> normally already exists but if it does not or is not currently writable, error handling is
          determined by the value of the Boolean argument <var>S</var>.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the object <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>bindings</i> be the binding object for <i>envRec</i>.</li>
            <li>Return <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>bindings</i>, <i>N</i>, <i>V</i>, <i>S</i>).</li>
          </ol>
        </section>

        <section id="sec-object-environment-records-getbindingvalue-n-s">
          <h5 id="sec-8.1.1.2.6" title="8.1.1.2.6"> GetBindingValue(N,S)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method GetBindingValue
          for object Environment Records returns the value of its associated binding object&rsquo;s property whose name is the
          String value of the argument identifier <var>N</var>. The property should already exist but if it does not the result
          depends upon the value of the <var>S</var> argument:</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the object <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>bindings</i> be the binding object for <i>envRec</i>.</li>
            <li>Let <i>value</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>bindings</i>, <i>N</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
            <li>If <i>value</i> is <b>false</b>, then
              <ol class="block">
                <li>If <i>S</i> is <b>false</b>, return the value <b>undefined</b>, otherwise throw a <b>ReferenceError</b>
                    exception.</li>
              </ol>
            </li>
            <li>Return <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>bindings</i>, <i>N</i>).</li>
          </ol>
        </section>

        <section id="sec-object-environment-records-deletebinding-n">
          <h5 id="sec-8.1.1.2.7" title="8.1.1.2.7"> DeleteBinding (N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method DeleteBinding for
          object Environment Records can only delete bindings that correspond to properties of the environment object whose
          [[Configurable]] attribute have the value <b>true</b>.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the object <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>bindings</i> be the binding object for <i>envRec</i>.</li>
            <li>Return <i>bindings</i>.[[Delete]](<i>N</i>).</li>
          </ol>
        </section>

        <section id="sec-object-environment-records-hasthisbinding">
          <h5 id="sec-8.1.1.2.8" title="8.1.1.2.8"> HasThisBinding ()</h5><p class="normalbefore">Regular object Environment Records do not provide a <code>this</code> binding.</p>

          <ol class="proc">
            <li>Return <b>false</b>.</li>
          </ol>
        </section>

        <section id="sec-object-environment-records-hassuperbinding">
          <h5 id="sec-8.1.1.2.9" title="8.1.1.2.9"> HasSuperBinding ()</h5><p class="normalbefore">Regular object Environment Records do not provide a <code>super</code> binding.</p>

          <ol class="proc">
            <li>Return <b>false</b>.</li>
          </ol>
        </section>

        <section id="sec-object-environment-records-withbaseobject">
          <h5 id="sec-8.1.1.2.10" title="8.1.1.2.10"> WithBaseObject()</h5><p class="normalbefore">Object Environment Records return <b>undefined</b> as their WithBaseObject unless their
          <var>withEnvironment</var> flag is <b>true</b>.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the object <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>If the <i>withEnvironment</i> flag of <i>envRec</i> is <b>true</b>, return the binding object for
                <i>envRec</i>.</li>
            <li>Otherwise, return <b>undefined</b>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-function-environment-records">
        <div class="front">
          <h4 id="sec-8.1.1.3" title="8.1.1.3"> Function Environment Records</h4><p>A function <a href="#sec-environment-records">Environment Record</a> is a declarative <a href="#sec-environment-records">Environment Record</a> that is used to represent the top-level scope of a function and,
          if the function is not an <span class="nt">ArrowFunction</span>, provides a <code>this</code> binding. If a function is
          not an <span class="nt">ArrowFunction</span> function and references <code>super</code>, its function <a href="#sec-environment-records">Environment Record</a> also contains the state that is used to perform
          <code>super</code> method invocations from within the function.</p>

          <p>Function Environment Records have the additional state fields listed in <a href="#table-16">Table 16</a>.</p>

          <figure>
            <figcaption><span id="table-16">Table 16</span> &mdash; Additional Fields of Function Environment Records</figcaption>
            <table class="real-table">
              <tr>
                <th>Field Name</th>
                <th>Value</th>
                <th>Meaning</th>
              </tr>
              <tr>
                <td>[[thisValue]]</td>
                <td>Any</td>
                <td>This is the <span class="value">this</span> value used for this invocation of the function.</td>
              </tr>
              <tr>
                <td>[[thisBindingStatus]]</td>
                <td><code>"lexical"</code> | <code>"initialized"</code> | <code>"uninitialized"</code></td>
                <td>If the value is <code>"lexical"</code>, this is an <span class="nt">ArrowFunction</span> and does not have a local this value.</td>
              </tr>
              <tr>
                <td>[[FunctionObject]]</td>
                <td>Object</td>
                <td>The function Object whose invocation caused this <a href="#sec-environment-records">Environment Record</a> to be created.</td>
              </tr>
              <tr>
                <td>[[HomeObject]]</td>
                <td>Object | <b>undefined</b></td>
                <td>If the associated function has <code>super</code> property accesses and is not an <span class="nt">ArrowFunction</span>, [[HomeObject]] is the object that the function is bound to as a method. The default value for [[HomeObject]] is <span class="value">undefined</span>.</td>
              </tr>
              <tr>
                <td>[[NewTarget]]</td>
                <td>Object | <b>undefined</b></td>
                <td>If this <a href="#sec-environment-records">Environment Record</a> was created by the [[Construct]] internal method, [[NewTarget]] is the value of the [[Construct]] <var>newTarget</var> parameter. Otherwise, its value is <span class="value">undefined</span>.</td>
              </tr>
            </table>
          </figure>

          <p>Function Environment Records support all of the declarative Environment Record methods listed in <a href="#table-15">Table 15</a> and share the same specifications for all of those methods except for HasThisBinding and
          HasSuperBinding. In addition, function Environment Records support the methods listed in <a href="#table-17">Table
          17</a>:</p>

          <figure>
            <figcaption><span id="table-17">Table 17</span> &mdash; Additional Methods of Function Environment Records</figcaption>
            <table class="real-table">
              <tr>
                <th>Method</th>
                <th>Purpose</th>
              </tr>
              <tr>
                <td><a href="#sec-bindthisvalue">BindThisValue</a>(V)</td>
                <td>Set the [[thisValue]] and record that it has been initialized.</td>
              </tr>
              <tr>
                <td>GetThisBinding()</td>
                <td>Return the value of this <a href="#sec-environment-records">Environment Record</a>&rsquo;s <code>this</code> binding. Throws a <span class="value">ReferenceError</span> if the <code>this</code> binding has not been initialized.</td>
              </tr>
              <tr>
                <td><a href="#sec-getsuperbase">GetSuperBase</a>()</td>
                <td>Return the object that is the base for <code>super</code> property accesses bound in this <a href="#sec-environment-records">Environment Record</a>. The object is derived from this <a href="#sec-environment-records">Environment Record</a>&rsquo;s [[HomeObject]] field. The value <span class="value">undefined</span> indicates that <code>super</code> property accesses will produce runtime errors.</td>
              </tr>
            </table>
          </figure>

          <p>The behaviour of the additional concrete specification methods for function Environment Records is defined by the
          following algorithms:</p>
        </div>

        <section id="sec-bindthisvalue">
          <h5 id="sec-8.1.1.3.1" title="8.1.1.3.1"> BindThisValue(V)</h5><ol class="proc">
            <li>Let <i>envRec</i> be the function <a href="#sec-environment-records">Environment Record</a> for which the method
                was invoked.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>envRec</i>.[[thisBindingStatus]] is not
                <code>"lexical"</code>.</li>
            <li>If <i>envRec</i>.[[thisBindingStatus]] is <code>"initialized"</code>, throw a <b>ReferenceError</b>
                exception.</li>
            <li>Set <i>envRec</i>.[[thisValue]] to <i>V</i>.</li>
            <li>Set <i>envRec</i>.[[thisBindingStatus]] to <code>"initialized"</code>.</li>
            <li>Return <i>V</i>.</li>
          </ol>
        </section>

        <section id="sec-function-environment-records-hasthisbinding">
          <h5 id="sec-8.1.1.3.2" title="8.1.1.3.2"> HasThisBinding ()</h5><ol class="proc">
            <li>Let <i>envRec</i> be the function <a href="#sec-environment-records">Environment Record</a> for which the method
                was invoked.</li>
            <li>If <i>envRec</i>.[[thisBindingStatus]] is <code>"lexical"</code>, return <b>false</b>; otherwise, return
                <b>true</b>.</li>
          </ol>
        </section>

        <section id="sec-function-environment-records-hassuperbinding">
          <h5 id="sec-8.1.1.3.3" title="8.1.1.3.3"> HasSuperBinding ()</h5><ol class="proc">
            <li>Let <i>envRec</i> be the function <a href="#sec-environment-records">Environment Record</a> for which the method
                was invoked.</li>
            <li>If <i>envRec</i>.[[thisBindingStatus]] is <code>"lexical"</code>, return <b>false</b>.</li>
            <li>If <i>envRec</i>.[[HomeObject]] has the value <b>undefined</b>, return <b>false</b>, otherwise, return
                <b>true</b>.</li>
          </ol>
        </section>

        <section id="sec-function-environment-records-getthisbinding">
          <h5 id="sec-8.1.1.3.4" title="8.1.1.3.4"> GetThisBinding ()</h5><ol class="proc">
            <li>Let <i>envRec</i> be the function <a href="#sec-environment-records">Environment Record</a> for which the method
                was invoked.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>envRec</i>.[[thisBindingStatus]] is not
                <code>"lexical"</code>.</li>
            <li>If <i>envRec</i>.[[thisBindingStatus]] is <code>"uninitialized"</code>, throw a <b>ReferenceError</b>
                exception.</li>
            <li>Return <i>envRec</i>.[[thisValue]].</li>
          </ol>
        </section>

        <section id="sec-getsuperbase">
          <h5 id="sec-8.1.1.3.5" title="8.1.1.3.5"> GetSuperBase ()</h5><ol class="proc">
            <li>Let <i>envRec</i> be the function <a href="#sec-environment-records">Environment Record</a> for which the method
                was invoked.</li>
            <li>Let <i>home</i> be the value of <i>envRec</i>.[[HomeObject]].</li>
            <li>If <i>home</i> has the value <b>undefined</b>, return <b>undefined</b>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>home</i>) is Object.</li>
            <li>Return <i>home.</i>[[GetPrototypeOf]]().</li>
          </ol>
        </section>
      </section>

      <section id="sec-global-environment-records">
        <div class="front">
          <h4 id="sec-8.1.1.4" title="8.1.1.4"> Global Environment Records</h4><p>A global <a href="#sec-environment-records">Environment Record</a> is used to represent the outer most scope that is
          shared by all of the ECMAScript <span class="nt">Script</span> elements that are processed in a common <a href="#sec-code-realms">Realm</a> (<a href="#sec-code-realms">8.2</a>). A global <a href="#sec-environment-records">Environment Record</a> provides the bindings for built-in globals (<a href="sec-global-object">clause 18</a>), properties of the global object, and for all top-level declarations (<a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-toplevellexicallyscopeddeclarations">13.2.8</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-block-static-semantics-toplevelvarscopeddeclarations">13.2.10</a>) that occur within a <span class="nt">Script</span>.</p>

          <p>A global <a href="#sec-environment-records">Environment Record</a> is logically a single record but it is specified
          as a composite encapsulating an object <a href="#sec-environment-records">Environment Record</a> and a declarative <a href="#sec-environment-records">Environment Record</a>. The object <a href="#sec-environment-records">Environment
          Record</a> has as its base object the global object of the associated <a href="#sec-code-realms">Realm</a>. This global
          object is the value returned by the global <a href="#sec-environment-records">Environment Record</a>&rsquo;s
          GetThisBinding concrete method. The object <a href="#sec-environment-records">Environment Record</a> component of a
          global <a href="#sec-environment-records">Environment Record</a> contains the bindings for all built-in globals (<a href="sec-global-object">clause 18</a>) and all bindings introduced by a <span style="font-family: Times New           Roman"><i>FunctionDeclaration</i>, <i>GeneratorDeclaration</i></span>, or <span class="nt">VariableStatement</span>
          contained in global code. The bindings for all other ECMAScript declarations in global code are contained in the
          declarative <a href="#sec-environment-records">Environment Record</a> component of the global <a href="#sec-environment-records">Environment Record</a>.</p>

          <p>Properties may be created directly on a global object. Hence, the object <a href="#sec-environment-records">Environment Record</a> component of a global <a href="#sec-environment-records">Environment Record</a> may contain both bindings created explicitly by <span style="font-family: Times New Roman"><i>FunctionDeclaration</i>, <i>GeneratorDeclaration</i></span>, or <span class="nt">VariableDeclaration</span> declarations and binding created implicitly as properties of the global object. In
          order to identify which bindings were explicitly created using declarations, a global <a href="#sec-environment-records">Environment Record</a> maintains a list of the names bound using its
          CreateGlobalVarBindings and CreateGlobalFunctionBindings concrete methods.</p>

          <p class="normalbefore">Global Environment Records have the additional fields listed in <a href="#table-18">Table 18</a>
          and the additional methods listed in <a href="#table-19">Table 19</a>.</p>

          <figure>
            <figcaption><span id="table-18">Table 18</span> &mdash; Additional Fields of Global Environment Records</figcaption>
            <table class="real-table">
              <tr>
                <th>Field Name</th>
                <th>Value</th>
                <th>Meaning</th>
              </tr>
              <tr>
                <td>[[ObjectRecord]]</td>
                <td><a href="#sec-object-environment-records">Object Environment Record</a></td>
                <td>Binding object is the global object. It contains global built-in bindings as well as <span style="font-family: Times New Roman"><i>FunctionDeclaration</i>, <i>GeneratorDeclaration</i></span>, and <span class="nt">VariableDeclaration</span> bindings in global code for the associated <a href="#sec-code-realms">Realm</a>.</td>
              </tr>
              <tr>
                <td>[[DeclarativeRecord]]</td>
                <td><a href="#sec-declarative-environment-records">Declarative Environment Record</a></td>
                <td>Contains bindings for all declarations in global code for the associated <a href="#sec-code-realms">Realm</a> code except for <span style="font-family: Times New Roman"><i>FunctionDeclaration</i>, <i>GeneratorDeclaration</i></span>, and <span class="nt">VariableDeclaration</span> <var>bindings</var>.</td>
              </tr>
              <tr>
                <td>[[VarNames]]</td>
                <td><a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of String</td>
                <td>The string names bound by <span style="font-family: Times New Roman"><i>FunctionDeclaration</i>, <i>GeneratorDeclaration</i></span>, and <span class="nt">VariableDeclaration</span> declarations in global code for the associated <a href="#sec-code-realms">Realm</a>.</td>
              </tr>
            </table>
          </figure>

          <figure>
            <figcaption><span id="table-19">Table 19</span> &mdash; Additional Methods of Global Environment Records</figcaption>
            <table class="real-table">
              <tr>
                <th>Method</th>
                <th>Purpose</th>
              </tr>
              <tr>
                <td>GetThisBinding()</td>
                <td>Return the value of this <a href="#sec-environment-records">Environment Record</a>&rsquo;s <code>this</code> binding.</td>
              </tr>
              <tr>
                <td><a href="#sec-hasvardeclaration">HasVarDeclaration</a> (N)</td>
                <td>Determines if the argument identifier has a binding in this <a href="#sec-environment-records">Environment Record</a> that was created using a <span style="font-family: Times New Roman"><i>VariableDeclaration</i>,</span> <span class="nt">FunctionDeclaration</span>, or <span style="font-family: Times New Roman"><i>GeneratorDeclaration</i>.</span></td>
              </tr>
              <tr>
                <td><a href="#sec-haslexicaldeclaration">HasLexicalDeclaration</a> (N)</td>
                <td>Determines if the argument identifier has a binding in this <a href="#sec-environment-records">Environment Record</a> that was created using a lexical declaration such as a <span class="nt">LexicalDeclaration</span> or a <span class="nt">ClassDeclaration</span>.</td>
              </tr>
              <tr>
                <td><a href="#sec-hasrestrictedglobalproperty">HasRestrictedGlobalProperty</a> (N)</td>
                <td>Determines if the argument is the name of a global object property that may not be shadowed by a global lexically binding.</td>
              </tr>
              <tr>
                <td><a href="#sec-candeclareglobalvar">CanDeclareGlobalVar</a> (N)</td>
                <td>Determines if a corresponding <a href="#sec-createglobalvarbinding">CreateGlobalVarBinding</a> call would succeed if called for the same argument <var>N</var>.</td>
              </tr>
              <tr>
                <td><a href="#sec-candeclareglobalfunction">CanDeclareGlobalFunction</a> (N)</td>
                <td>Determines if a corresponding <a href="#sec-createglobalfunctionbinding">CreateGlobalFunctionBinding</a> call would succeed if called for the same argument <var>N</var>.</td>
              </tr>
              <tr>
                <td><a href="#sec-createglobalvarbinding">CreateGlobalVarBinding</a>(N, D)</td>
                <td>Used to create and initialize to <b>undefined</b> a global <code>var</code> binding in the [[ObjectRecord]] component of a global <a href="#sec-environment-records">Environment Record</a>. The binding will be a mutable binding. The corresponding global object property will have attribute values appropriate for a <code>var</code>. The String value <var>N</var> is the bound name. If <var>D</var> is <b>true</b> the binding may be deleted. Logically equivalent to CreateMutableBinding followed by a SetMutableBinding but it allows var declarations to receive special treatment.</td>
              </tr>
              <tr>
                <td><a href="#sec-createglobalfunctionbinding">CreateGlobalFunctionBinding</a>(N, V, D)</td>
                <td>Create and initialize a global <code>function</code> binding in the [[ObjectRecord]] component of a global <a href="#sec-environment-records">Environment Record</a>. The binding will be a mutable binding. The corresponding global object property will have attribute values appropriate for a <code>function</code>. The String value <var>N</var> is the bound name. <i>V</i> is the initialization value. If the optional Boolean argument <var>D</var> is <b>true</b> the binding is may be deleted. Logically equivalent to CreateMutableBinding followed by a SetMutableBinding but it allows function declarations to receive special treatment.</td>
              </tr>
            </table>
          </figure>

          <p>The behaviour of the concrete specification methods for global Environment Records is defined by the following
          algorithms.</p>
        </div>

        <section id="sec-global-environment-records-hasbinding-n">
          <h5 id="sec-8.1.1.4.1" title="8.1.1.4.1"> HasBinding(N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method HasBinding for
          global Environment Records simply determines if the argument identifier is one of the identifiers bound by the
          record:</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>DclRec</i> be <i>envRec</i>.[[DeclarativeRecord]].</li>
            <li>If <i>DclRec.</i>HasBinding(<i>N</i>) is <b>true</b>, return <b>true</b>.</li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Return <i>ObjRec.</i>HasBinding(<i>N</i>).</li>
          </ol>
        </section>

        <section id="sec-global-environment-records-createmutablebinding-n-d">
          <h5 id="sec-8.1.1.4.2" title="8.1.1.4.2"> CreateMutableBinding (N, D)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          CreateMutableBinding for global Environment Records creates a new mutable binding for the name <var>N</var> that is
          uninitialized. The binding is created in the associated DeclarativeRecord. A binding for <var>N</var> must not already
          exist in the DeclarativeRecord. If Boolean argument <var>D</var> is provided and has the value <b>true</b> the new
          binding is marked as being subject to deletion.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>DclRec</i> be <i>envRec</i>.[[DeclarativeRecord]].</li>
            <li>If <i>DclRec</i>.HasBinding(<i>N</i>) is <b>true</b>, throw a <b>TypeError</b> exception.</li>
            <li>Return <i>DclRec</i>.CreateMutableBinding(<i>N</i>, <i>D</i>).</li>
          </ol>
        </section>

        <section id="sec-global-environment-records-createimmutablebinding-n-s">
          <h5 id="sec-8.1.1.4.3" title="8.1.1.4.3"> CreateImmutableBinding (N, S)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          CreateImmutableBinding for global Environment Records creates a new immutable binding for the name <var>N</var> that is
          uninitialized. A binding must not already exist in this <a href="#sec-environment-records">Environment Record</a> for
          <var>N</var>. If Boolean argument <var>S</var> is provided and has the value <b>true</b> the new binding is marked as a
          strict binding.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>DclRec</i> be <i>envRec</i>.[[DeclarativeRecord]].</li>
            <li>If <i>DclRec</i>.HasBinding(<i>N</i>) is <b>true</b>, throw a <b>TypeError</b> exception.</li>
            <li>Return <i>DclRec</i>.CreateImmutableBinding(<i>N</i>, <i>S</i>).</li>
          </ol>
        </section>

        <section id="sec-global-environment-records-initializebinding-n-v">
          <h5 id="sec-8.1.1.4.4" title="8.1.1.4.4"> InitializeBinding (N,V)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method InitializeBinding
          for global Environment Records is used to set the bound value of the current binding of the identifier whose name is the
          value of the argument <var>N</var> to the value of argument <var>V</var>. An uninitialized binding for <var>N</var> must
          already exist.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>DclRec</i> be <i>envRec</i>.[[DeclarativeRecord]].</li>
            <li>If <i>DclRec.</i>HasBinding(<i>N</i>) is <b>true</b>, then
              <ol class="block">
                <li>Return <i>DclRec</i>.InitializeBinding(<i>N</i>, <i>V</i>).</li>
              </ol>
            </li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: If the binding exists it must be in the object <a href="#sec-environment-records">Environment Record</a>.</li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Return <i>ObjRec.</i>InitializeBinding(<i>N</i>, <i>V</i>).</li>
          </ol>
        </section>

        <section id="sec-global-environment-records-setmutablebinding-n-v-s">
          <h5 id="sec-8.1.1.4.5" title="8.1.1.4.5"> SetMutableBinding (N,V,S)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method SetMutableBinding
          for global Environment Records attempts to change the bound value of the current binding of the identifier whose name is
          the value of the argument <var>N</var> to the value of argument <var>V</var>. If the binding is an immutable binding, a
          <b>TypeError</b> is thrown if <span style="font-family: Times New Roman">S</span> is <span class="value">true</span>. A
          property named <var>N</var> normally already exists but if it does not or is not currently writable, error handling is
          determined by the value of the Boolean argument <var>S</var>.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>DclRec</i> be <i>envRec</i>.[[DeclarativeRecord]].</li>
            <li>If <i>DclRec.</i>HasBinding(<i>N</i>) is <b>true</b>, then
              <ol class="block">
                <li>Return <i>DclRec.</i>SetMutableBinding(<i>N</i>, <i>V</i>, <i>S</i>).</li>
              </ol>
            </li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Return <i>ObjRec</i>.SetMutableBinding(<i>N</i>, <i>V</i>, <i>S</i>).</li>
          </ol>
        </section>

        <section id="sec-global-environment-records-getbindingvalue-n-s">
          <h5 id="sec-8.1.1.4.6" title="8.1.1.4.6"> GetBindingValue(N,S)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method GetBindingValue
          for global Environment Records returns the value of its bound identifier whose name is the value of the argument
          <var>N</var>. If the binding is an uninitialized binding throw a <b>ReferenceError</b> exception. A property named
          <var>N</var> normally already exists but if it does not or is not currently writable, error handling is determined by
          the value of the Boolean argument <var>S</var>.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>DclRec</i> be <i>envRec</i>.[[DeclarativeRecord]].</li>
            <li>If <i>DclRec.</i>HasBinding(<i>N</i>) is <b>true</b>, then
              <ol class="block">
                <li>Return <i>DclRec.</i>GetBindingValue(<i>N</i>, <i>S</i>).</li>
              </ol>
            </li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Return <i>ObjRec</i>.GetBindingValue(<i>N</i>, <i>S</i>).</li>
          </ol>
        </section>

        <section id="sec-global-environment-records-deletebinding-n">
          <h5 id="sec-8.1.1.4.7" title="8.1.1.4.7"> DeleteBinding (N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method DeleteBinding for
          global Environment Records can only delete bindings that have been explicitly designated as being subject to
          deletion.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>DclRec</i> be <i>envRec</i>.[[DeclarativeRecord]].</li>
            <li>If <i>DclRec.</i>HasBinding(<i>N</i>) is <b>true</b>, then
              <ol class="block">
                <li>Return <i>DclRec.</i>DeleteBinding(<i>N</i>).</li>
              </ol>
            </li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Let <i>globalObject</i> be the binding object for <i>ObjRec</i>.</li>
            <li>Let <i>existingProp</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>globalObject</i>, <i>N</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>existingProp</i>).</li>
            <li>If <i>existingProp</i> is <b>true</b>, then
              <ol class="block">
                <li>Let <i>status</i> be <i>ObjRec.</i>DeleteBinding(<i>N</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                <li>If <i>status</i> is <b>true</b>, then
                  <ol class="block">
                    <li>Let <i>varNames</i> be <i>envRec</i>.[[VarNames]].</li>
                    <li>If <i>N</i> is an element of <i>varNames</i>, remove that element from the <i>varNames</i>.</li>
                  </ol>
                </li>
                <li>Return <i>status</i>.</li>
              </ol>
            </li>
            <li>Return <b>true</b>.</li>
          </ol>
        </section>

        <section id="sec-global-environment-records-hasthisbinding">
          <h5 id="sec-8.1.1.4.8" title="8.1.1.4.8"> HasThisBinding ()</h5><p class="normalbefore"><a href="#sec-global-environment-records">Global Environment Records</a> always provide a
          <code>this</code> binding whose value is the associated global object.</p>

          <ol class="proc">
            <li>Return <b>true</b>.</li>
          </ol>
        </section>

        <section id="sec-global-environment-records-hassuperbinding">
          <h5 id="sec-8.1.1.4.9" title="8.1.1.4.9"> HasSuperBinding ()</h5><ol class="proc">
            <li>Return <b>false</b>.</li>
          </ol>
        </section>

        <section id="sec-global-environment-records-withbaseobject">
          <h5 id="sec-8.1.1.4.10" title="8.1.1.4.10"> WithBaseObject()</h5><p class="normalbefore"><a href="#sec-global-environment-records">Global Environment Records</a> always return
          <b>undefined</b> as their WithBaseObject.</p>

          <ol class="proc">
            <li>Return <b>undefined</b>.</li>
          </ol>
        </section>

        <section id="sec-global-environment-records-getthisbinding">
          <h5 id="sec-8.1.1.4.11" title="8.1.1.4.11"> GetThisBinding ()</h5><ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Let <i>bindings</i> be the binding object for <i>ObjRec</i>.</li>
            <li>Return <i>bindings</i>.</li>
          </ol>
        </section>

        <section id="sec-hasvardeclaration">
          <h5 id="sec-8.1.1.4.12" title="8.1.1.4.12"> HasVarDeclaration (N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method HasVarDeclaration
          for global Environment Records determines if the argument identifier has a binding in this record that was created using
          a <span class="nt">VariableStatement</span> or a <span class="prod"><span class="nt">FunctionDeclaration</span> <span class="geq">:</span></span></p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>varDeclaredNames</i> be <i>envRec</i>.[[VarNames]].</li>
            <li>If <i>varDeclaredNames</i> contains the value of <i>N</i>, return <b>true</b>.</li>
            <li>Return <b>false</b>.</li>
          </ol>
        </section>

        <section id="sec-haslexicaldeclaration">
          <h5 id="sec-8.1.1.4.13" title="8.1.1.4.13"> HasLexicalDeclaration (N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          HasLexicalDeclaration for global Environment Records determines if the argument identifier has a binding in this record
          that was created using a lexical declaration such as a <span class="nt">LexicalDeclaration</span> or a <span class="prod"><span class="nt">ClassDeclaration</span> <span class="geq">:</span></span></p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>DclRec</i> be <i>envRec</i>.[[DeclarativeRecord]].</li>
            <li>Return <i>DclRec.</i>HasBinding(<i>N</i>).</li>
          </ol>
        </section>

        <section id="sec-hasrestrictedglobalproperty">
          <h5 id="sec-8.1.1.4.14" title="8.1.1.4.14"> HasRestrictedGlobalProperty (N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          HasRestrictedGlobalProperty for global Environment Records determines if the argument identifier is the name of a
          property of the global object that must not be shadowed by a global lexically binding:</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Let <i>globalObject</i> be the binding object for <i>ObjRec</i>.</li>
            <li>Let <i>existingProp</i> be <i>globalObject</i>.[[GetOwnProperty]](<i>N</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>existingProp</i>).</li>
            <li>If <i>existingProp</i> is <b>undefined</b>, return <b>false</b>.</li>
            <li>If <i>existingProp</i>.[[Configurable]] is <b>true</b>, return <b>false</b>.</li>
            <li>Return <b>true</b>.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> Properties may exist upon a global object that were directly created rather than being
            declared using a var or function declaration. A global lexical binding may not be created that has the same name as a
            non-configurable property of the global object. The global property <code>undefined</code> is an example of such a
            property.</p>
          </div>
        </section>

        <section id="sec-candeclareglobalvar">
          <h5 id="sec-8.1.1.4.15" title="8.1.1.4.15"> CanDeclareGlobalVar (N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          CanDeclareGlobalVar for global Environment Records determines if a corresponding <a href="#sec-createglobalvarbinding">CreateGlobalVarBinding</a> call would succeed if called for the same argument
          <var>N</var>. Redundant var declarations and var declarations for pre-existing global object properties are allowed.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Let <i>globalObject</i> be the binding object for <i>ObjRec</i>.</li>
            <li>Let <i>hasProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>globalObject, N</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasProperty</i>).</li>
            <li>If <i>hasProperty</i> is <b>true</b>, return <b>true</b>.</li>
            <li>Return <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>globalObject</i>).</li>
          </ol>
        </section>

        <section id="sec-candeclareglobalfunction">
          <h5 id="sec-8.1.1.4.16" title="8.1.1.4.16"> CanDeclareGlobalFunction (N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          CanDeclareGlobalFunction for global Environment Records determines if a corresponding <a href="#sec-createglobalfunctionbinding">CreateGlobalFunctionBinding</a> call would succeed if called for the same
          argument <var>N</var>.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Let <i>globalObject</i> be the binding object for <i>ObjRec</i>.</li>
            <li>Let <i>existingProp</i> be <i>globalObject</i>.[[GetOwnProperty]](<i>N</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>existingProp</i>).</li>
            <li>If <i>existingProp</i> is <b>undefined</b>, return <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>globalObject</i>).</li>
            <li>If <i>existingProp</i>.[[Configurable]] is <b>true</b>, return <b>true</b>.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>existingProp</i>) is <b>true</b> and
                <i>existingProp</i> has attribute values {[[Writable]]: <b>true</b>, [[Enumerable]]: <b>true</b>}, return
                <b>true</b>.</li>
            <li>Return <b>false</b>.</li>
          </ol>
        </section>

        <section id="sec-createglobalvarbinding">
          <h5 id="sec-8.1.1.4.17" title="8.1.1.4.17"> CreateGlobalVarBinding (N, D)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          CreateGlobalVarBinding for global Environment Records creates and initializes a mutable binding in the associated object
          Environment Record and records the bound name in the associated [[VarNames]] <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>. If a binding already exists, it is reused and assumed to be
          initialized.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Let <i>globalObject</i> be the binding object for <i>ObjRec</i>.</li>
            <li>Let <i>hasProperty</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>globalObject, N</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasProperty</i>).</li>
            <li>Let <i>extensible</i> be <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>globalObject</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>extensible</i>).</li>
            <li>If <i>hasProperty</i> is <b>false</b> and <i>extensible</i> is <b>true</b>, then
              <ol class="block">
                <li>Let <i>status</i> be <i>ObjRec.</i>CreateMutableBinding(<i>N</i>, <i>D</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                <li>Let <i>status</i> be <i>ObjRec.</i>InitializeBinding(<i>N</i>, <b>undefined</b>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
              </ol>
            </li>
            <li>Let <i>varDeclaredNames</i> be <i>envRec</i>.[[VarNames]].</li>
            <li>If <i>varDeclaredNames</i> does not contain the value of <i>N</i>, then
              <ol class="block">
                <li>Append <i>N</i> to <i>varDeclaredNames</i>.</li>
              </ol>
            </li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>
        </section>

        <section id="sec-createglobalfunctionbinding">
          <h5 id="sec-8.1.1.4.18" title="8.1.1.4.18"> CreateGlobalFunctionBinding (N, V, D)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          CreateGlobalFunctionBinding for global Environment Records creates and initializes a mutable binding in the associated
          object Environment Record and records the bound name in the associated [[VarNames]] <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>. If a binding already exists, it is replaced.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the global <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>Let <i>ObjRec</i> be <i>envRec</i>.[[ObjectRecord]].</li>
            <li>Let <i>globalObject</i> be the binding object for <i>ObjRec</i>.</li>
            <li>Let <i>existingProp</i> be <i>globalObject</i>.[[GetOwnProperty]](<i>N</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>existingProp</i>).</li>
            <li>If <i>existingProp</i> is <b>undefined</b> or <i>existingProp</i>.[[Configurable]] is <b>true</b>, then
              <ol class="block">
                <li>Let <i>desc</i> be the PropertyDescriptor{[[Value]]:<i>V</i>, [[Writable]]: <b>true</b>, [[Enumerable]]:
                    <b>true</b> , [[Configurable]]: <i>D</i>}.</li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Let <i>desc</i> be the PropertyDescriptor{[[Value]]:<i>V</i> }.</li>
              </ol>
            </li>
            <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>globalObject</i>, <i>N</i>,
                <i>desc</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
            <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>globalObject</i>, <i>N</i>, <i>V</i>,
                <b>false</b>).</li>
            <li>Record that the binding for <i>N</i> in <i>ObjRec</i> has been initialized.</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
            <li>Let <i>varDeclaredNames</i> be <i>envRec</i>.[[VarNames]].</li>
            <li>If <i>varDeclaredNames</i> does not contain the value of <i>N</i>, then
              <ol class="block">
                <li>Append <i>N</i> to <i>varDeclaredNames</i>.</li>
              </ol>
            </li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> Global function declarations are always represented as own properties of the global
            object. If possible, an existing own property is reconfigured to have a standard set of attribute values. Steps 10-12
            are equivalent to what calling the InitializeBinding concrete method would do and if <var>globalObject</var> is a
            Proxy will produce the same sequence of Proxy trap calls.</p>
          </div>
        </section>
      </section>

      <section id="sec-module-environment-records">
        <div class="front">
          <h4 id="sec-8.1.1.5" title="8.1.1.5"> Module Environment Records</h4><p>A module <a href="#sec-environment-records">Environment Record</a> is a declarative <a href="#sec-environment-records">Environment Record</a> that is used to represent the outer scope of an ECMAScript <span class="nt">Module</span>. In additional to normal mutable and immutable bindings, module Environment Records also
          provide immutable import bindings which are bindings that provide indirect access to a target binding that exists in
          another Environment Record.</p>

          <p>Module Environment Records support all of the declarative Environment Record methods listed in <a href="#table-15">Table 15</a> and share the same specifications for all of those methods except for GetBindingValue,
          DeleteBinding, HasThisBinding and GetThisBinding. In addition, module Environment Records support the methods listed in
          <a href="#table-20">Table 20</a>:</p>

          <figure>
            <figcaption><span id="table-20">Table 20</span> &mdash; Additional Methods of Module Environment Records</figcaption>
            <table class="real-table">
              <tr>
                <th>Method</th>
                <th>Purpose</th>
              </tr>
              <tr>
                <td><a href="#sec-createimportbinding">CreateImportBinding</a>(N, M, N2 )</td>
                <td>Create an immutable indirect binding in a module <a href="#sec-environment-records">Environment Record</a>. The String value <var>N</var> is the text of the bound name. <var>M</var> is a <a href="sec-ecmascript-language-scripts-and-modules#sec-abstract-module-records">Module Record</a> (<a href="sec-ecmascript-language-scripts-and-modules#sec-abstract-module-records">see 15.2.1.15</a>), and <var>N2</var> is a binding that exists in M&rsquo;s module <a href="#sec-environment-records">Environment Record</a>.</td>
              </tr>
              <tr>
                <td>GetThisBinding()</td>
                <td>Return the value of this <a href="#sec-environment-records">Environment Record</a>&rsquo;s <code>this</code> binding.</td>
              </tr>
            </table>
          </figure>

          <p>The behaviour of the additional concrete specification methods for module Environment Records are defined by the
          following algorithms:</p>
        </div>

        <section id="sec-module-environment-records-getbindingvalue-n-s">
          <h5 id="sec-8.1.1.5.1" title="8.1.1.5.1"> GetBindingValue(N,S)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method GetBindingValue
          for module Environment Records returns the value of its bound identifier whose name is the value of the argument
          <var>N</var>. However, if the binding is an indirect binding the value of the target binding is returned. If the binding
          exists but is uninitialized a <span class="value">ReferenceError</span> is thrown, regardless of the value of <i><span style="font-family: Times New Roman">S</span>.</i></p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the module <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> has a binding for <i>N</i>.</li>
            <li>If the binding for <i>N</i> is an indirect binding, then
              <ol class="block">
                <li>Let <i>M</i> and <i>N2</i> be the indirection values provided when this binding for <i>N</i> was created.</li>
                <li>Let <i>targetEnv</i> be <i>M</i>.[[Environment]].</li>
                <li>If <i>targetEnv</i> is <b>undefined</b>, throw a <b>ReferenceError</b> exception.</li>
                <li>Let <i>targetER</i> be <i>targetEnv</i>&rsquo;s <a href="#sec-lexical-environments">EnvironmentRecord</a>.</li>
                <li>Return <i>targetER</i>.GetBindingValue(<i>N2</i>, <i>S</i>).</li>
              </ol>
            </li>
            <li>If the binding for <i>N</i> in <i>envRec</i> is an uninitialized binding, throw a <b>ReferenceError</b>
                exception.</li>
            <li>Return the value currently bound to <i>N</i> in <i>envRec</i>.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> Because a <span class="nt">Module</span> is always <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, calls to GetBindingValue should always pass <span class="value">true</span> as the value of&nbsp;<var>S</var>.</p>
          </div>
        </section>

        <section id="sec-module-environment-records-deletebinding-n">
          <h5 id="sec-8.1.1.5.2" title="8.1.1.5.2"> DeleteBinding (N)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method DeleteBinding for
          module Environment Records refuses to delete bindings.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the module <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li>If <i>envRec</i> does not have a binding for the name that is the value of <i>N</i>, return <b>true</b>.</li>
            <li>Return <b>false</b>.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> The bindings of a module <a href="#sec-environment-records">Environment
            Record</a> are not deletable.</p>
          </div>
        </section>

        <section id="sec-module-environment-records-hasthisbinding">
          <h5 id="sec-8.1.1.5.3" title="8.1.1.5.3"> HasThisBinding ()</h5><p class="normalbefore">Module Environment Records provide a <code>this</code> binding.</p>

          <ol class="proc">
            <li>Return <b>true</b>.</li>
          </ol>
        </section>

        <section id="sec-module-environment-records-getthisbinding">
          <h5 id="sec-8.1.1.5.4" title="8.1.1.5.4"> GetThisBinding ()</h5><ol class="proc">
            <li>Return <b>undefined</b>.</li>
          </ol>
        </section>

        <section id="sec-createimportbinding">
          <h5 id="sec-8.1.1.5.5" title="8.1.1.5.5"> CreateImportBinding (N, M, N2)</h5><p class="normalbefore">The concrete <a href="#sec-environment-records">Environment Record</a> method
          CreateImportBinding for module Environment Records creates a new initialized immutable indirect binding for the name
          <var>N</var>. A binding must not already exist in this <a href="#sec-environment-records">Environment Record</a> for
          <var>N</var>. <var>M</var> is a <a href="sec-ecmascript-language-scripts-and-modules#sec-abstract-module-records">Module Record</a> (<a href="sec-ecmascript-language-scripts-and-modules#sec-abstract-module-records">see 15.2.1.15</a>), and <var>N2</var> is the name of a binding that exists in
          M&rsquo;s module <a href="#sec-environment-records">Environment Record</a>. Accesses to the value of the new binding
          will indirectly access the bound value of value of the target binding.</p>

          <ol class="proc">
            <li>Let <i>envRec</i> be the module <a href="#sec-environment-records">Environment Record</a> for which the method was
                invoked.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> does not already have a binding for <i>N</i>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>M</i> is a <a href="sec-ecmascript-language-scripts-and-modules#sec-abstract-module-records">Module
                Record</a>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: When <i>M</i>.[[Environment]] is instantiated it will have a
                direct binding for <i>N2</i>.</li>
            <li>Create an immutable indirect binding in <i>envRec</i> for <i>N</i> that references <i>M</i> and <i>N2</i> as its
                target binding and record that the binding is initialized.</li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>
        </section>
      </section>
    </section>

    <section id="sec-lexical-environment-operations">
      <div class="front">
        <h3 id="sec-8.1.2" title="8.1.2"> Lexical Environment Operations</h3><p>The following abstract operations are used in this specification to operate upon lexical environments:</p>
      </div>

      <section id="sec-getidentifierreference">
        <h4 id="sec-8.1.2.1" title="8.1.2.1"> GetIdentifierReference (lex, name, strict)</h4><p class="normalbefore">The abstract operation GetIdentifierReference is called with a <a href="#sec-lexical-environments">Lexical Environment</a> <var>lex</var>, a String <var>name</var>, and a Boolean flag
        <var>strict.</var> The value of <var>lex</var> may be <b>null</b>. When called, the following steps are performed:</p>

        <ol class="proc">
          <li>If <i>lex</i> is the value <b>null</b>, then
            <ol class="block">
              <li>Return a value of type <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> whose base value is
                  <b>undefined</b>, whose referenced name is <i>name</i>, and whose strict reference flag is <i>strict</i>.</li>
            </ol>
          </li>
          <li>Let <i>envRec</i> be <i>lex</i>&rsquo;s <a href="#sec-lexical-environments">EnvironmentRecord</a>.</li>
          <li>Let <i>exists</i> be <i>envRec</i>.HasBinding(<i>name</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exists</i>).</li>
          <li>If <i>exists</i> is <b>true</b>, then
            <ol class="block">
              <li>Return a value of type <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> whose base value is
                  <i>envRec</i>, whose referenced name is <i>name</i>, and whose strict reference flag is <i>strict.</i></li>
            </ol>
          </li>
          <li>Else
            <ol class="block">
              <li>Let <i>outer</i> be the value of <i>lex&rsquo;s</i> <a href="#sec-lexical-environments">outer environment
                  reference</a>.</li>
              <li>Return GetIdentifierReference(<i>outer</i>, <i>name</i>, <i>strict</i>).</li>
            </ol>
          </li>
        </ol>
      </section>

      <section id="sec-newdeclarativeenvironment">
        <h4 id="sec-8.1.2.2" title="8.1.2.2"> NewDeclarativeEnvironment (E)</h4><p class="normalbefore">When the abstract operation NewDeclarativeEnvironment is called with a <a href="#sec-lexical-environments">Lexical Environment</a> as argument <var>E</var> the following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>env</i> be a new <a href="#sec-lexical-environments">Lexical Environment</a>.</li>
          <li>Let <i>envRec</i> be a new declarative <a href="#sec-environment-records">Environment Record</a> containing no
              bindings.</li>
          <li>Set <i>env&rsquo;s</i> <a href="#sec-lexical-environments">EnvironmentRecord</a> to be <i>envRec</i>.</li>
          <li>Set the <a href="#sec-lexical-environments">outer lexical environment reference</a> of <i>env</i> to <i>E</i>.</li>
          <li>Return <i>env</i>.</li>
        </ol>
      </section>

      <section id="sec-newobjectenvironment">
        <h4 id="sec-8.1.2.3" title="8.1.2.3"> NewObjectEnvironment (O, E)</h4><p class="normalbefore">When the abstract operation NewObjectEnvironment is called with an Object <var>O</var> and a <a href="#sec-lexical-environments">Lexical Environment</a> <var>E</var> as arguments, the following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>env</i> be a new <a href="#sec-lexical-environments">Lexical Environment</a>.</li>
          <li>Let <i>envRec</i> be a new object <a href="#sec-environment-records">Environment Record</a> containing <i>O</i> as
              the binding object.</li>
          <li>Set <i>env&rsquo;s</i> <a href="#sec-lexical-environments">EnvironmentRecord</a> to <i>envRec</i>.</li>
          <li>Set the <a href="#sec-lexical-environments">outer lexical environment reference</a> of <i>env</i> to <i>E</i>.</li>
          <li>Return <i>env</i>.</li>
        </ol>
      </section>

      <section id="sec-newfunctionenvironment">
        <h4 id="sec-8.1.2.4" title="8.1.2.4"> NewFunctionEnvironment ( F, newTarget )</h4><p class="normalbefore">When the abstract operation NewFunctionEnvironment is called with arguments <var>F</var> and
        <var>newTarget</var> the following steps are performed:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> is an ECMAScript function.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>newTarget</i>) is Undefined or Object.</li>
          <li>Let <i>env</i> be a new <a href="#sec-lexical-environments">Lexical Environment</a>.</li>
          <li>Let <i>envRec</i> be a new function <a href="#sec-environment-records">Environment Record</a> containing no
              bindings.</li>
          <li>Set <i>envRec</i>.[[FunctionObject]] to <i>F</i>.</li>
          <li>If <i>F&rsquo;s</i> [[ThisMode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is
              <span style="font-family: sans-serif">lexical</span>, set <i>envRec</i>.[[thisBindingStatus]] to
              <code>"lexical"</code>.</li>
          <li>Else, Set <i>envRec</i>.[[thisBindingStatus]] to <code>"uninitialized"</code>.</li>
          <li>Let <i>home</i> be the value of <i>F&rsquo;s</i> [[HomeObject]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Set <i>envRec</i>.[[HomeObject]] to <i>home</i>.</li>
          <li>Set <i>envRec</i>.[[NewTarget]] to  <i>newTarget</i>.</li>
          <li>Set <i>env&rsquo;s</i> <a href="#sec-lexical-environments">EnvironmentRecord</a> to be <i>envRec</i>.</li>
          <li>Set the <a href="#sec-lexical-environments">outer lexical environment reference</a> of <i>env</i> to the value of
              <i>F&rsquo;s</i> [[Environment]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Return <i>env</i>.</li>
        </ol>
      </section>

      <section id="sec-newglobalenvironment">
        <h4 id="sec-8.1.2.5" title="8.1.2.5"> NewGlobalEnvironment ( G )</h4><p class="normalbefore">When the abstract operation NewGlobalEnvironment is called with an ECMAScript Object <var>G</var>
        as its argument, the following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>env</i> be a new <a href="#sec-lexical-environments">Lexical Environment</a>.</li>
          <li>Let <i>objRec</i> be a new object <a href="#sec-environment-records">Environment Record</a> containing <i>G</i> as
              the binding object.</li>
          <li>Let <i>dclRec</i> be a new declarative <a href="#sec-environment-records">Environment Record</a> containing no
              bindings.</li>
          <li>Let <i>globalRec</i> be a new global <a href="#sec-environment-records">Environment Record</a>.</li>
          <li>Set <i>globalRec</i>.[[ObjectRecord]] to <i>objRec</i>.</li>
          <li>Set <i>globalRec</i>.[[DeclarativeRecord]] to <i>dclRec</i>.</li>
          <li>Set <i>globalRec</i>.[[VarNames]] to a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Set <i>env&rsquo;s</i> <a href="#sec-lexical-environments">EnvironmentRecord</a> to <i>globalRec</i>.</li>
          <li>Set the <a href="#sec-lexical-environments">outer lexical environment reference</a> of <i>env</i> to
              <b>null</b></li>
          <li>Return <i>env</i>.</li>
        </ol>
      </section>

      <section id="sec-newmoduleenvironment">
        <h4 id="sec-8.1.2.6" title="8.1.2.6"> NewModuleEnvironment (E)</h4><p class="normalbefore">When the abstract operation NewModuleEnvironment is called with a <a href="#sec-lexical-environments">Lexical Environment</a> argument <var>E</var> the following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>env</i> be a new <a href="#sec-lexical-environments">Lexical Environment</a>.</li>
          <li>Let <i>envRec</i> be a new module <a href="#sec-environment-records">Environment Record</a> containing no
              bindings.</li>
          <li>Set <i>env&rsquo;s</i> <a href="#sec-lexical-environments">EnvironmentRecord</a> to be <i>envRec</i>.</li>
          <li>Set the <a href="#sec-lexical-environments">outer lexical environment reference</a> of <i>env</i> to <i>E</i>.</li>
          <li>Return <i>env</i>.</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-code-realms">
    <div class="front">
      <h2 id="sec-8.2" title="8.2"> Code
          Realms</h2><p>Before it is evaluated, all ECMAScript code must be associated with a <i>Realm</i>. Conceptually, a realm consists of a
      set of intrinsic objects, an ECMAScript global environment, all of the ECMAScript code that is loaded within the scope of
      that global environment, and other associated state and resources.</p>

      <p>A Realm is specified as a Record with the fields specified in <a href="#table-21">Table 21</a>:</p>

      <figure>
        <figcaption><span id="table-21">Table 21</span> &mdash; Realm Record Fields</figcaption>
        <table class="real-table">
          <tr>
            <th>Field Name</th>
            <th>Value</th>
            <th>Meaning</th>
          </tr>
          <tr>
            <td>[[intrinsics]]</td>
            <td>Record whose field names are intrinsic keys and whose values are objects</td>
            <td>These are the intrinsic values used by code associated with this Realm</td>
          </tr>
          <tr>
            <td>[[globalThis]]</td>
            <td>Object</td>
            <td>The global object for this Realm</td>
          </tr>
          <tr>
            <td>[[globalEnv]]</td>
            <td><a href="#sec-lexical-environments">Lexical Environment</a></td>
            <td>The global environment for this Realm</td>
          </tr>
          <tr>
            <td>[[templateMap]]</td>
            <td>A <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of Record { [[strings]]: <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>, [[array]]: Object}.</td>
            <td>Template objects are canonicalized separately for each Realm using its [[templateMap]]. Each [[strings]] value is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing, in source text order, the raw String values of a <span class="nt">TemplateLiteral</span> that has been evaluated. The associated [[array]] value is the corresponding template object that is passed to a tag function.</td>
          </tr>
        </table>
      </figure>

      <p>An implementation may define other, implementation specific fields.</p>
    </div>

    <section id="sec-createrealm">
      <h3 id="sec-8.2.1" title="8.2.1"> CreateRealm
          ( )</h3><p class="normalbefore">The abstract operation CreateRealm with no arguments performs the following steps:</p>

      <ol class="proc">
        <li>Let <i>realmRec</i> be a new Record.</li>
        <li>Perform <a href="#sec-createintrinsics">CreateIntrinsics</a>(<i>realmRec</i>).</li>
        <li>Set <i>realmRec</i>.[[globalThis]] to <b>undefined</b>.</li>
        <li>Set <i>realmRec</i>.[[globalEnv]] to <b>undefined</b>.</li>
        <li>Set <i>realmRec</i>.[[templateMap]] to a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Return <i>realmRec</i>.</li>
      </ol>
    </section>

    <section id="sec-createintrinsics">
      <h3 id="sec-8.2.2" title="8.2.2">
          CreateIntrinsics ( realmRec )</h3><p class="normalbefore">When the abstract operation CreateIntrinsics with argument <var>realmRec</var> performs the
      following steps:</p>

      <ol class="proc">
        <li>Let <i>intrinsics</i> be a new Record.</li>
        <li>Set <i>realmRec</i>.[[intrinsics]] to <i>intrinsics</i>.</li>
        <li>Let <i>objProto</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<b>null</b>).</li>
        <li>Set <i>intrinsics</i>.[[%ObjectPrototype%]] to <i>objProto</i>.</li>
        <li>Let <i>throwerSteps</i> be the algorithm steps specified in <a href="sec-ordinary-and-exotic-objects-behaviours#sec-%throwtypeerror%">9.2.7.1</a> for the <a href="sec-ordinary-and-exotic-objects-behaviours#sec-%throwtypeerror%">%ThrowTypeError%</a> function.</li>
        <li>Let <i>thrower</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-createbuiltinfunction">CreateBuiltinFunction</a>(<i>realmRec</i>,
            <i>throwerSteps</i>, <b>null</b>).</li>
        <li>Set <i>intrinsics</i>.[[<span style="font-family: sans-serif"><a href="sec-ordinary-and-exotic-objects-behaviours#sec-%throwtypeerror%">%ThrowTypeError%</a></span>]] to <i>thrower</i>.</li>
        <li>Let <i>noSteps</i> be an empty sequence of algorithm steps.</li>
        <li>Let <i>funcProto</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-createbuiltinfunction">CreateBuiltinFunction</a>(<i>realmRec</i>,
            <i>noSteps</i>, <i>objProto</i>).</li>
        <li>Set <i>intrinsics</i>.[[%FunctionPrototype%]] to <i>funcProto</i>.</li>
        <li><a href="sec-abstract-operations#sec-call">Call</a> <i>thrower</i>.[[SetPrototypeOf]](<i>funcProto</i>).</li>
        <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-addrestrictedfunctionproperties">AddRestrictedFunctionProperties</a>(<i>funcProto</i>,
            <i>realmRec</i>).</li>
        <li>Set fields of <i>intrinsics</i> with the values listed in <a href="sec-ecmascript-data-types-and-values#table-7">Table 7</a> that have not already been
            handled above. The field names are the names listed in column one of the table. The value of each field is a new
            object value fully and recursively populated with property values as defined by the specification of each object in
            clauses 18-26. All object property values are newly created object values. All values that are built-in function
            objects are created by performing <a href="sec-ordinary-and-exotic-objects-behaviours#sec-createbuiltinfunction">CreateBuiltinFunction</a>(<i>realmRec</i>,
            &lt;steps&gt;, &lt;prototype&gt;, &lt;slots&gt;) where &lt;steps&gt; is the definition of that function provided by
            this specification, &lt;prototype&gt; is the specified value of the function&rsquo;s [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> and &lt;slots&gt; is a list of the names, if
            any, of the functions specified internal slots. The creation of the intrinsics and their properties must be ordered to
            avoid any dependencies upon objects that have not yet been created.</li>
        <li>Return <i>intrinsics</i>.</li>
      </ol>
    </section>

    <section id="sec-setrealmglobalobject">
      <h3 id="sec-8.2.3" title="8.2.3">
          SetRealmGlobalObject ( realmRec, globalObj )</h3><p class="normalbefore">The abstract operation SetRealmGlobalObject with arguments <var>realmRec</var> and
      <var>globalObj</var> performs the following steps:</p>

      <ol class="proc">
        <li>If <i>globalObj</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Let <i>intrinsics</i> be <i>realmRec</i>.[[intrinsics]].</li>
            <li>Let <i>globalObj</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<i>intrinsics</i>.[[%ObjectPrototype%]]).</li>
          </ol>
        </li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>globalObj</i>) is Object.</li>
        <li>Set <i>realmRec</i>.[[globalThis]] to <i>globalObj</i>.</li>
        <li>Let <i>newGlobalEnv</i> be <a href="#sec-newglobalenvironment">NewGlobalEnvironment</a>(<i>globalObj</i>).</li>
        <li>Set <i>realmRec</i>.[[globalEnv]] to <i>newGlobalEnv</i>.</li>
        <li>Return <i>realmRec</i>.</li>
      </ol>
    </section>

    <section id="sec-setdefaultglobalbindings">
      <h3 id="sec-8.2.4" title="8.2.4"> SetDefaultGlobalBindings ( realmRec )</h3><p class="normalbefore">The abstract operation SetDefaultGlobalBindings with argument <var>realmRec</var> performs the
      following steps:</p>

      <ol class="proc">
        <li>Let <i>global</i> be <i>realmRec</i>.[[globalThis]].</li>
        <li>For each property of the Global Object specified in <a href="sec-global-object">clause 18</a>, do
          <ol class="block">
            <li>Let <i>name</i> be the String value of the property name.</li>
            <li>Let <i>desc</i> be the fully populated data property descriptor for the property containing the specified
                attributes for the property. For properties listed in <a href="sec-global-object#sec-function-properties-of-the-global-object">18.2</a>, <a href="sec-global-object#sec-constructor-properties-of-the-global-object">18.3</a>, or <a href="sec-global-object#sec-other-properties-of-the-global-object">18.4</a> the value of the [[Value]] attribute is the
                corresponding intrinsic object from <i>realmRec</i>.</li>
            <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>global</i>, <i>name</i>,
                <i>desc</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          </ol>
        </li>
        <li>Return <i>global</i>.</li>
      </ol>
    </section>
  </section>

  <section id="sec-execution-contexts">
    <div class="front">
      <h2 id="sec-8.3" title="8.3">
          Execution Contexts</h2><p>An <i>execution context</i> is a specification device that is used to track the runtime evaluation of code by an
      ECMAScript implementation. At any point in time, there is at most one execution context that is actually executing code.
      This is known as the <i>running</i> execution context. A stack is used to track execution contexts. The running execution
      context is always the top element of this stack. A new execution context is created whenever control is transferred from the
      executable code associated with the currently running execution context to executable code that is not associated with that
      execution context. The newly created execution context is pushed onto the stack and becomes the running execution
      context.</p>

      <p>An execution context contains whatever implementation specific state is necessary to track the execution progress of its
      associated code. Each execution context has at least the state components listed in <a href="#table-22">Table 22</a>.</p>

      <figure>
        <figcaption><span id="table-22">Table 22</span> &mdash;State Components for All Execution Contexts</figcaption>
        <table class="real-table">
          <tr>
            <th>Component</th>
            <th>Purpose</th>
          </tr>
          <tr>
            <td>code evaluation state</td>
            <td>Any state needed to perform, suspend, and resume evaluation of the code associated with this execution context.</td>
          </tr>
          <tr>
            <td>Function</td>
            <td>If this execution context is evaluating the code of a function object, then the value of this component is that function object. If the context is evaluating the code of a <span class="nt">Script</span> or <span class="nt">Module</span>, the value is <span class="value">null</span>.</td>
          </tr>
          <tr>
            <td><a href="#sec-code-realms">Realm</a></td>
            <td>The <a href="#sec-code-realms">Realm</a> from which associated code accesses ECMAScript resources.</td>
          </tr>
        </table>
      </figure>

      <p>Evaluation of code by the running execution context may be suspended at various points defined within this specification.
      Once the running execution context has been suspended a different execution context may become the running execution context
      and commence evaluating its code. At some later time a suspended execution context may again become the running execution
      context and continue evaluating its code at the point where it had previously been suspended. Transition of the running
      execution context status among execution contexts usually occurs in stack-like last-in/first-out manner. However, some
      ECMAScript features require non-LIFO transitions of the running execution context.</p>

      <p>The value of the <a href="#sec-code-realms">Realm</a> component of the running execution context is also called the
      <i>current <a href="#sec-code-realms">Realm</a></i>. The value of the Function component of the running execution context is
      also called the <i>active function object.</i></p>

      <p>Execution contexts for ECMAScript code have the additional state components listed in <a href="#table-23">Table
      23</a>.</p>

      <figure>
        <figcaption><span id="table-23">Table 23</span> &mdash; Additional State Components for ECMAScript Code Execution Contexts</figcaption>
        <table class="real-table">
          <tr>
            <th>Component</th>
            <th>Purpose</th>
          </tr>
          <tr>
            <td>LexicalEnvironment</td>
            <td>Identifies the <a href="#sec-lexical-environments">Lexical Environment</a> used to resolve identifier references made by code within this execution context.</td>
          </tr>
          <tr>
            <td>VariableEnvironment</td>
            <td>Identifies the <a href="#sec-lexical-environments">Lexical Environment</a> whose <a href="#sec-lexical-environments">EnvironmentRecord</a> holds bindings created by <span class="nt">VariableStatements</span> within this execution context.</td>
          </tr>
        </table>
      </figure>

      <p>The LexicalEnvironment and VariableEnvironment components of an execution context are always Lexical Environments. When
      an execution context is created its LexicalEnvironment and VariableEnvironment components initially have the same value.</p>

      <p>Execution contexts representing the evaluation of generator objects have the additional state components listed in <a href="#table-24">Table 24</a>.</p>

      <figure>
        <figcaption><span id="table-24">Table 24</span> &mdash; Additional State Components for Generator Execution Contexts</figcaption>
        <table class="real-table">
          <tr>
            <th>Component</th>
            <th>Purpose</th>
          </tr>
          <tr>
            <td>Generator</td>
            <td>The GeneratorObject that this execution context is evaluating.</td>
          </tr>
        </table>
      </figure>

      <p>In most situations only the running execution context (the top of the execution context stack) is directly manipulated by
      algorithms within this specification. Hence when the terms &ldquo;LexicalEnvironment&rdquo;, and
      &ldquo;VariableEnvironment&rdquo; are used without qualification they are in reference to those components of the running
      execution context.</p>

      <p>An execution context is purely a specification mechanism and need not correspond to any particular artefact of an
      ECMAScript implementation. It is impossible for ECMAScript code to directly access or observe an execution context.</p>
    </div>

    <section id="sec-resolvebinding">
      <h3 id="sec-8.3.1" title="8.3.1">
          ResolveBinding ( name, [env] )</h3><p class="normalbefore">The ResolveBinding abstract operation is used to determine the binding of <var>name</var> passed as
      a String value. The optional argument <var>env</var> can be used to explicitly provide the <a href="#sec-lexical-environments">Lexical Environment</a> that is to be searched for the binding. During execution of
      ECMAScript code, ResolveBinding is performed using the following algorithm:</p>

      <ol class="proc">
        <li>If <i>env</i> was not passed or if <i>env</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Let <i>env</i> be <a href="#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="#sec-execution-contexts">LexicalEnvironment</a>.</li>
          </ol>
        </li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>env</i> is a <a href="#sec-lexical-environments">Lexical
            Environment</a>.</li>
        <li>If the code matching the syntactic production that is being evaluated is contained in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, let <i>strict</i> be <b>true</b>, else let <i>strict</i> be
            <b>false</b>.</li>
        <li>Return <a href="#sec-getidentifierreference">GetIdentifierReference</a>(<i>env</i>, <i>name</i>, <i>strict</i> ).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> The result of ResolveBinding is always a <a href="sec-ecmascript-data-types-and-values#sec-reference-specification-type">Reference</a> value with its referenced name component equal to the
        <var>name</var> argument.</p>
      </div>
    </section>

    <section id="sec-getthisenvironment">
      <h3 id="sec-8.3.2" title="8.3.2">
          GetThisEnvironment ( )</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">GetThisEnvironment</span> finds
      the <a href="#sec-environment-records">Environment Record</a> that currently supplies the binding of the keyword
      <code>this</code>. <span style="font-family: Times New Roman">GetThisEnvironment</span> performs the following steps:</p>

      <ol class="proc">
        <li>Let <i>lex</i> be <a href="#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="#sec-execution-contexts">LexicalEnvironment</a>.</li>
        <li>Repeat
          <ol class="block">
            <li>Let <i>envRec</i> be <i>lex</i>&rsquo;s <a href="#sec-lexical-environments">EnvironmentRecord</a>.</li>
            <li>Let <i>exists</i> be <i>envRec</i>.HasThisBinding().</li>
            <li>If <i>exists</i> is <b>true</b>, return <i>envRec</i>.</li>
            <li>Let <i>outer</i> be the value of <i>lex&rsquo;s</i> <a href="#sec-lexical-environments">outer environment
                reference</a>.</li>
            <li>Let <i>lex</i> be <i>outer</i>.</li>
          </ol>
        </li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> The loop in step 2 will always terminate because the list of environments always ends with
        <a href="#sec-global-environment-records">the global environment</a> which has a <code>this</code> binding.</p>
      </div>
    </section>

    <section id="sec-resolvethisbinding">
      <h3 id="sec-8.3.3" title="8.3.3">
          ResolveThisBinding ( )</h3><p class="normalbefore">The abstract operation ResolveThisBinding determines the binding of the keyword <code>this</code>
      using the <a href="#sec-execution-contexts">LexicalEnvironment</a> of <a href="#sec-execution-contexts">the running
      execution context</a>. ResolveThisBinding performs the following steps:</p>

      <ol class="proc">
        <li>Let <i>envRec</i> be <a href="#sec-getthisenvironment">GetThisEnvironment</a>( ).</li>
        <li>Return <i>envRec</i>.GetThisBinding().</li>
      </ol>
    </section>

    <section id="sec-getnewtarget">
      <h3 id="sec-8.3.4" title="8.3.4">
          GetNewTarget ( )</h3><p class="normalbefore">The abstract operation GetNewTarget determines the NewTarget value using the <a href="#sec-execution-contexts">LexicalEnvironment</a> of <a href="#sec-execution-contexts">the running execution
      context</a>. GetNewTarget performs the following steps:</p>

      <ol class="proc">
        <li>Let <i>envRec</i> be <a href="#sec-getthisenvironment">GetThisEnvironment</a>( ).</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>envRec</i> has a [[NewTarget]] field.</li>
        <li>Return <i>envRec</i>.[[NewTarget]].</li>
      </ol>
    </section>

    <section id="sec-getglobalobject">
      <h3 id="sec-8.3.5" title="8.3.5">
          GetGlobalObject ( )</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">GetGlobalObject</span> returns the
      global object used by <a href="#sec-execution-contexts">the currently running execution context</a>. <span style="font-family: Times New Roman">GetGlobalObject</span> performs the following steps:</p>

      <ol class="proc">
        <li>Let <i>ctx</i> be <a href="#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>currentRealm</i> be <i>ctx&rsquo;s</i> <a href="#sec-code-realms">Realm</a>.</li>
        <li>Return <i>currentRealm</i>.[[globalThis]].</li>
      </ol>
    </section>
  </section>

  <section id="sec-jobs-and-job-queues">
    <div class="front">
      <h2 id="sec-8.4" title="8.4"> Jobs
          and Job Queues</h2><p>A Job is an abstract operation that initiates an ECMAScript computation when no other ECMAScript computation is currently
      in progress. A Job abstract operation may be defined to accept an arbitrary set of job parameters.</p>

      <p>Execution of a Job can be initiated only when there is no running <a href="#sec-execution-contexts">execution context</a>
      and <a href="#sec-execution-contexts">the execution context stack</a> is empty. A PendingJob is a request for the future
      execution of a Job. A PendingJob is an internal Record whose fields are specified in <a href="#table-25">Table 25</a>. Once
      execution of a Job is initiated, the Job always executes to completion. No other Job may be initiated until the currently
      running Job completes. However, the currently running Job or external events may cause the enqueuing of additional
      PendingJobs that may be initiated sometime after completion of the currently running Job.</p>

      <figure>
        <figcaption><span id="table-25">Table 25</span> &mdash; PendingJob Record Fields</figcaption>
        <table class="real-table">
          <tr>
            <th>Field Name</th>
            <th>Value</th>
            <th>Meaning</th>
          </tr>
          <tr>
            <td>[[Job]]</td>
            <td>The name of a Job abstract operation</td>
            <td>This is the abstract operation that is performed when execution of this PendingJob is initiated. Jobs are abstract operations that use NextJob rather than Return to indicate that they have completed.</td>
          </tr>
          <tr>
            <td>[[Arguments]]</td>
            <td>A <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a></td>
            <td>The <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of argument values that are to be passed to [[Job]] when it is activated.</td>
          </tr>
          <tr>
            <td>[[Realm]]</td>
            <td>A <a href="#sec-code-realms">Realm</a> Record</td>
            <td>The <a href="#sec-code-realms">Realm</a> for the initial <a href="#sec-execution-contexts">execution context</a> when this Pending Job is initiated.</td>
          </tr>
          <tr>
            <td>[[HostDefined]]</td>
            <td>Any, default value is <span class="value">undefined</span>.</td>
            <td>Field reserved for use by host environments that need to associate additional information with a pending Job.</td>
          </tr>
        </table>
      </figure>

      <p>A Job Queue is a FIFO queue of PendingJob records. Each Job Queue has a name and the full set of available Job Queues are
      defined by an ECMAScript implementation. Every ECMAScript implementation has at least the Job Queues defined in <a href="#table-26">Table 26</a>.</p>

      <figure>
        <figcaption><span id="table-26">Table 26</span> &mdash; Required Job Queues</figcaption>
        <table class="real-table">
          <tr>
            <th>Name</th>
            <th>Purpose</th>
          </tr>
          <tr>
            <td>ScriptJobs</td>
            <td>Jobs that validate and evaluate ECMAScript <span class="nt">Script</span> and <span class="nt">Module</span> source text. See clauses 10 and 15.</td>
          </tr>
          <tr>
            <td>PromiseJobs</td>
            <td>Jobs that are responses to the settlement of a Promise (<a href="sec-control-abstraction-objects#sec-promise-objects">see 25.4</a>).</td>
          </tr>
        </table>
      </figure>

      <p>A request for the future execution of a Job is made by enqueueing, on a Job Queue, a PendingJob record that includes a
      Job abstract operation name and any necessary argument values. When there is no running <a href="#sec-execution-contexts">execution context</a> and <a href="#sec-execution-contexts">the execution context stack</a>
      is empty, the ECMAScript implementation removes the first PendingJob from a Job Queue and uses the information contained in
      it to create an <a href="#sec-execution-contexts">execution context</a> and starts execution of the associated Job abstract
      operation.</p>

      <p>The PendingJob records from a single Job Queue are always initiated in FIFO order. This specification does not define the
      order in which multiple Job Queues are serviced. An ECMAScript implementation may interweave the FIFO evaluation of the
      PendingJob records of a Job Queue with the evaluation of the PendingJob records of one or more other Job Queues. An
      implementation must define what occurs when there are no running <a href="#sec-execution-contexts">execution context</a> and
      all Job Queues are empty.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> Typically an ECMAScript implementation will have its Job Queues pre-initialized with at
        least one PendingJob and one of those Jobs will be the first to be executed. An implementation might choose to free all
        resources and terminate if the current Job completes and all Job Queues are empty. Alternatively, it might choose to wait
        for a some implementation specific agent or mechanism to enqueue new PendingJob requests.</p>
      </div>

      <p>The following abstract operations are used to create and manage Jobs and Job Queues:</p>
    </div>

    <section id="sec-enqueuejob">
      <h3 id="sec-8.4.1" title="8.4.1"> EnqueueJob
          (queueName, job, arguments)</h3><p class="normalbefore">The EnqueueJob abstract operation requires three arguments: <var>queueName</var>, <var>job</var>,
      and <var>arguments</var>. It performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>queueName</i>) is String and its value is the name of a Job
            Queue recognized by this implementation.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>job</i> is the name of a Job.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>arguments</i> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that has the same number of elements as the number of
            parameters required by <i>job</i>.</li>
        <li>Let <i>callerContext</i> be <a href="#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>callerRealm</i> be <i>callerContext&rsquo;s</i> <a href="#sec-code-realms">Realm</a>.</li>
        <li>Let <i>pending</i> be PendingJob{ [[Job]]: <i>job</i>, [[Arguments]]: <i>arguments</i>, [[Realm]]: <i>callerRealm</i>,
            [[HostDefined]]: <b>undefined</b> }.</li>
        <li>Perform any implementation or host environment defined processing of <i>pending</i>. This may include modifying the
            [[HostDefined]] field or any other field of <i>pending</i>.</li>
        <li>Add <i>pending</i> at the back of the Job Queue named by <i>queueName</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
      </ol>
    </section>

    <section id="sec-nextjob-result">
      <h3 id="sec-8.4.2" title="8.4.2"> NextJob
          result</h3><p class="normalbefore">An algorithm step such as:</p>

      <ol class="proc">
        <li>NextJob <i>result</i>.</li>
      </ol>

      <p>is used in Job abstract operations in place of:</p>

      <ol class="proc">
        <li>Return <i>result</i>.</li>
      </ol>

      <p>Job abstract operations must not contain a Return step or a <a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a> step. The
      NextJob <var>result</var> operation is equivalent to the following steps:</p>

      <ol class="proc">
        <li>If <i>result</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, perform
            implementation defined unhandled exception processing.</li>
        <li><a href="#sec-execution-contexts">Suspend</a> <a href="#sec-execution-contexts">the running execution context</a> and
            remove it from <a href="#sec-execution-contexts">the execution context stack</a>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The <a href="#sec-execution-contexts">execution context stack</a> is
            now empty.</li>
        <li>Let <i>nextQueue</i> be a non-empty Job Queue chosen in an implementation defined manner. If all Job Queues are empty,
            the result is implementation defined.</li>
        <li>Let <i>nextPending</i> be the PendingJob record at the front of <i>nextQueue</i>. Remove that record from
            <i>nextQueue</i>.</li>
        <li>Let <i>newContext</i> be a new <a href="#sec-execution-contexts">execution context</a>.</li>
        <li>Set <i>newContext</i>&rsquo;s <a href="#sec-code-realms">Realm</a> to <i>nextPending</i>.[[Realm]].</li>
        <li>Push <i>newContext</i> onto <a href="#sec-execution-contexts">the execution context stack</a>; <i>newContext</i> is
            now <a href="#sec-execution-contexts">the running execution context</a>.</li>
        <li>Perform any implementation or host environment defined job initialization using <i>nextPending</i>.</li>
        <li>Perform the abstract operation named by <i>nextPending</i>.[[Job]] using the elements of
            <i>nextPending</i>.[[Arguments]] as its arguments.</li>
      </ol>
    </section>
  </section>

  <section id="sec-ecmascript-initialization">
    <div class="front">
      <h2 id="sec-8.5" title="8.5">
          ECMAScript Initialization()</h2><p>An ECMAScript implementation performs the following steps prior to the execution of any Jobs or the evaluation of any
      ECMAScript code:</p>

      <ol class="proc">
        <li>Let <i>realm</i> be <a href="#sec-createrealm">CreateRealm</a>().</li>
        <li>Let <i>newContext</i> be a new <a href="#sec-execution-contexts">execution context</a>.</li>
        <li>Set the Function of <i>newContext</i> to <b>null</b>.</li>
        <li>Set the <a href="#sec-code-realms">Realm</a> of <i>newContext</i> to <i>realm</i>.</li>
        <li>Push <i>newContext</i> onto <a href="#sec-execution-contexts">the execution context stack</a>; <i>newContext</i> is
            now <a href="#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>status</i> be <a href="#sec-initializehostdefinedrealm">InitializeHostDefinedRealm</a>(<i>realm</i>).</li>
        <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
          <ol class="block">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The first realm could not be created.</li>
            <li>Terminate ECMAScript execution.</li>
          </ol>
        </li>
        <li>In an implementation dependent manner, obtain the ECMAScript source texts (see <a href="sec-ecmascript-language-source-code">clause 10</a>) for zero or more ECMAScript scripts and/or ECMAScript
            modules. For each such  <i>sourceText</i> do,
          <ol class="block">
            <li>If <i>sourceText</i> is the source code of a script, then
              <ol class="block">
                <li>Perform <a href="#sec-enqueuejob">EnqueueJob</a>(<code>"ScriptJobs"</code>, <a href="sec-ecmascript-language-scripts-and-modules#sec-scriptevaluationjob">ScriptEvaluationJob</a>, &laquo; <i>sourceText</i> &raquo;).</li>
              </ol>
            </li>
            <li>Else <i>sourceText</i> is the source code of a module,
              <ol class="block">
                <li>Perform <a href="#sec-enqueuejob">EnqueueJob</a>(<code>"ScriptJobs"</code>, <a href="sec-ecmascript-language-scripts-and-modules#sec-toplevelmoduleevaluationjob">TopLevelModuleEvaluationJob</a>, &laquo; <i>sourceText</i>
                    &raquo;).</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>NextJob <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
      </ol>
    </div>

    <section id="sec-initializehostdefinedrealm">
      <h3 id="sec-8.5.1" title="8.5.1"> InitializeHostDefinedRealm ( realm )</h3><p class="normalbefore">The abstract operation InitializeHostDefinedRealm with parameter <var>realm</var> performs the
      following steps:</p>

      <ol class="proc">
        <li>If this implementation requires use of an exotic object to serve as <i>realm</i>&rsquo;s global object, let
            <i>global</i> be such an object created in an implementation defined manner. Otherwise, let <i>global</i> be
            <b>undefined</b> indicating that an ordinary object should be created as the global object.</li>
        <li>Perform <a href="#sec-setrealmglobalobject">SetRealmGlobalObject</a>(<i>realm</i>, <i>global</i>).</li>
        <li>Let <i>globalObj</i> be <a href="#sec-setdefaultglobalbindings">SetDefaultGlobalBindings</a>(<i>realm</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>globalObj</i>).</li>
        <li>Create any implementation defined global object properties on <i>globalObj</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
      </ol>
    </section>
  </section>
</section>

