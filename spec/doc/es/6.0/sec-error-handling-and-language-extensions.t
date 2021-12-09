<section id="sec-error-handling-and-language-extensions">
  <div class="front">
    <h1 id="sec-16" title="16"> Error Handling and Language Extensions</h1><p>An implementation must report most errors at the time the relevant ECMAScript language construct is evaluated. An <i>early
    error</i> is an error that can be detected and reported prior to the evaluation of any construct in the <span class="nt">Script</span> containing the error. The presence of an early error prevents the evaluation of the construct. An
    implementation must report early errors in a <span class="nt">Script</span> as part of the <a href="sec-ecmascript-language-scripts-and-modules#sec-scriptevaluationjob">ScriptEvaluationJob</a> for that <span class="nt">Script</span>. Early errors in a <span class="nt">Module</span> are reported at the point when the <span class="nt">Module</span> would be evaluated and the <span class="nt">Module</span> is never initialized. Early errors in <b>eval</b> code are reported at the time <code>eval</code> is
    called and prevent evaluation of the <b>eval</b> code. All errors that are not early errors are runtime errors.</p>

    <p>An implementation must report as an early error any occurrence of a condition that is listed in a &ldquo;Static Semantics:
    Early Errors&rdquo; subclause of this specification.</p>

    <p>An implementation shall not treat other kinds of errors as early errors even if the compiler can prove that a construct
    cannot execute without error under any circumstances. An implementation may issue an early warning in such a case, but it
    should not report the error until the relevant construct is actually executed.</p>

    <p class="normalbefore">An implementation shall report all errors as specified, except for the following:</p>

    <ul>
      <li>
        <p>Except as restricted in <a href="#sec-forbidden-extensions">16.1</a>, an implementation may extend <i>Script</i>
        syntax, <i>Module</i> syntax, and regular expression pattern or flag syntax. To permit this, all operations (such as
        calling <code>eval</code>, using a regular expression literal, or using the <code>Function</code> or <code>RegExp</code>
        constructor) that are allowed to throw <b>SyntaxError</b> are permitted to exhibit implementation-defined behaviour
        instead of throwing <b>SyntaxError</b> when they encounter an implementation-defined extension to the script syntax or
        regular expression pattern or flag syntax.</p>
      </li>

      <li>
        <p>Except as restricted in <a href="#sec-forbidden-extensions">16.1</a>, an implementation may provide additional types,
        values, objects, properties, and functions beyond those described in this specification. This may cause constructs (such
        as looking up a variable in the global scope) to have implementation-defined behaviour instead of throwing an error (such
        as <b>ReferenceError</b>).</p>
      </li>
    </ul>

    <p>An implementation may define behaviour other than throwing <b>RangeError</b> for <code>toFixed</code>,
    <code>toExponential</code>, and <code>toPrecision</code> when the <var>fractionDigits</var> or <var>precision</var> argument
    is outside the specified range.</p>
  </div>

  <section id="sec-forbidden-extensions">
    <h2 id="sec-16.1" title="16.1">
        Forbidden Extensions</h2><p>An implementation must not extend this specification in the following ways:</p>

    <ul>
      <li>
        <p>Other than as defined in this specification, ECMAScript Function objects defined using syntactic constructors in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> must not be created with own properties named <code>"caller"</code> or
        <code>"arguments"</code> other than those that are created by applying the <a href="sec-ordinary-and-exotic-objects-behaviours#sec-addrestrictedfunctionproperties">AddRestrictedFunctionProperties</a> abstract operation (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-addrestrictedfunctionproperties">9.2.7</a>) to the function. Such own properties also must not be created for
        function objects defined using an <span class="nt">ArrowFunction</span>, <span class="nt">MethodDefinition</span>, <span class="nt">GeneratorDeclaration</span>, <span class="nt">GeneratorExpression</span>, <span class="nt">ClassDeclaration</span>, or <span class="nt">ClassExpression</span> <var>regardless of whether the definition
        is contained in <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a></var>. Built-in functions, strict mode functions
        created using the <code>Function</code> constructor, generator functions created using the <code>Generator</code>
        constructor, and functions created using the <code>bind</code> method also must not be created with such own
        properties.</p>
      </li>

      <li>
        <p>If an implementation extends non-strict or built-in function objects with an own property named <code>"caller"</code>
        the value of that property, as observed using [[Get]] or [[GetOwnProperty]], must not be a strict function object. If it
        is an accessor property, the function that is the value of the property&rsquo;s [[Get]] attribute must never return a
        strict function when called.</p>
      </li>

      <li>
        <p>The behaviour of the following methods must not be extended except as specified in ECMA-402:  <code><a href="sec-fundamental-objects#sec-object.prototype.tolocalestring">Object.prototype.toLocaleString</a></code>, <code><a href="sec-indexed-collections#sec-array.prototype.tolocalestring">Array.prototype.toLocaleString</a></code>, <code><a href="sec-numbers-and-dates#sec-number.prototype.tolocalestring">Number.prototype.toLocaleString</a></code>, <code><a href="sec-numbers-and-dates#sec-date.prototype.tolocaledatestring">Date.prototype.toLocaleDateString</a></code>, <code><a href="sec-numbers-and-dates#sec-date.prototype.tolocalestring">Date.prototype.toLocaleString</a></code>, <code><a href="sec-numbers-and-dates#sec-date.prototype.tolocaletimestring">Date.prototype.toLocaleTimeString</a></code>, <code><a href="sec-text-processing#sec-string.prototype.localecompare">String.prototype.localeCompare</a></code>.</p>
      </li>

      <li>
        <p>The RegExp pattern grammars in <a href="sec-text-processing#sec-patterns">21.2.1</a> and <a href="sec-additional-ecmascript-features-for-web-browsers#sec-regular-expressions-patterns">B.1.4</a> must not be extended to recognize any of the source characters A-Z or
        a-z as <span class="nt">IdentityEscape</span><sub>[U]</sub> when the U grammar parameter is present.</p>
      </li>

      <li>
        <p>The Syntactic Grammar must not be extended in any manner that allows the token <code>:</code> to immediate follow
        source text that matches the <span class="nt">BindingIdentifier</span> nonterminal symbol.</p>
      </li>

      <li>
        <p>When processing <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, the syntax of <i>NumericLiteral</i> must not be
        extended to include <i>LegacyOctalIntegerLiteral</i> as defined in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-additional-syntax-numeric-literals">B.1.1</a>.</p>
      </li>

      <li>
        <p><span class="nt">TemplateCharacter</span> (<a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">11.8.6</a>) must not be
        extended to include <i>Legacy<span style="font-family: Times New Roman">OctalEscapeSequence</span></i> as defined in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-additional-syntax-string-literals">B.1.2</a>.</p>
      </li>

      <li>
        <p>When processing <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, the extensions defined in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-__proto__-property-names-in-object-initializers">B.3.1</a>, <a href="sec-additional-ecmascript-features-for-web-browsers#sec-labelled-function-declarations">B.3.2</a>, <a href="sec-additional-ecmascript-features-for-web-browsers#sec-block-level-function-declarations-web-legacy-compatibility-semantics">B.3.3</a>, and <a href="sec-additional-ecmascript-features-for-web-browsers#sec-functiondeclarations-in-ifstatement-statement-clauses">B.3.4</a> must not be supported.</p>
      </li>

      <li>
        <p>When parsing for the <span class="nt">Module</span> goal symbol, the lexical grammar extensions defined in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-html-like-comments">B.1.3</a> must not be supported.</p>
      </li>
    </ul>
  </section>
</section>

