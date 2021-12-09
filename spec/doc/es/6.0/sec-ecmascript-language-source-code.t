<section id="sec-ecmascript-language-source-code">
  <div class="front">
    <h1 id="sec-10" title="10">
        ECMAScript Language: Source Code</h1></div>

  <section id="sec-source-text">
    <div class="front">
      <h2 id="sec-10.1" title="10.1"> Source
          Text</h2><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">SourceCharacter</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="gprose">any Unicode code point</span></div>
      </div>

      <p>ECMAScript code is expressed using Unicode, version 5.1 or later. ECMAScript source text is a sequence of code points.
      All Unicode code point values from U+0000 to U+10FFFF, including surrogate code points, may occur in source text where
      permitted by the ECMAScript grammars. The actual encodings used to store and interchange ECMAScript source text is not
      relevant to this specification. Regardless of the external source text encoding, a conforming ECMAScript implementation
      processes the source text as if it was an equivalent sequence of <span class="nt">SourceCharacter</span> values. Each <span class="nt">SourceCharacter</span> being a Unicode code point. Conforming ECMAScript implementations are not required to
      perform any normalization of source text, or behave as though they were performing normalization of source text.</p>

      <p>The components of a combining character sequence are treated as individual Unicode code points even though a user might
      think of the whole sequence as a single character.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> In string literals, regular expression literals, template literals and identifiers, any
        Unicode code point may also be expressed using Unicode escape sequences that explicitly express a code point&rsquo;s
        numeric value. Within a comment, such an escape sequence is effectively ignored as part of the comment.</p>

        <p>ECMAScript differs from the Java programming language in the behaviour of Unicode escape sequences. In a Java program,
        if the Unicode escape sequence <code>\u000A</code>, for example, occurs within a single-line comment, it is interpreted as
        a line terminator (Unicode code point U+000A is LINE FEED (LF) and therefore the next code point is not part of the
        comment. Similarly, if the Unicode escape sequence <code>\u000A</code> occurs within a string literal in a Java program,
        it is likewise interpreted as a line terminator, which is not allowed within a string literal&mdash;one must write
        <code>\n</code> instead of <code>\u000A</code> to cause a LINE FEED (LF) to be part of the String value of a string
        literal. In an ECMAScript program, a Unicode escape sequence occurring within a comment is never interpreted and therefore
        cannot contribute to termination of the comment. Similarly, a Unicode escape sequence occurring within a string literal in
        an ECMAScript program always contributes to the literal and is never interpreted as a line terminator or as a code point
        that might terminate the string literal.</p>
      </div>
    </div>

    <section id="sec-utf16encoding">
      <h3 id="sec-10.1.1" title="10.1.1"> Static
          Semantics:  </h3><p>The UTF16Encoding of a numeric code point value, <var>cp</var>, is determined as follows:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: 0 &le; <i>cp</i> &le; 0x10FFFF.</li>
        <li>If <i>cp</i> &le; 65535, return <i>cp</i>.</li>
        <li>Let <i>cu1</i> be <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>((<i>cp</i> &ndash; 65536) / 1024) + 0xD800.</li>
        <li>Let <i>cu2</i> be ((<i>cp</i> &ndash; 65536) <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 1024) + 0xDC00.</li>
        <li>Return the code unit sequence consisting of <i>cu1</i> followed by <i>cu2</i>.</li>
      </ol>
    </section>

    <section id="sec-utf16decode">
      <h3 id="sec-10.1.2" title="10.1.2"> Static
          Semantics: UTF16Decode( lead, trail )</h3><p>Two code units, <var>lead</var> and <var>trail</var>, that form a UTF-16 surrogate pair are converted to a code point by
      performing the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: 0xD800 &le; <i>lead</i> &le; 0xDBFF and 0xDC00 &le; <i>trail</i> &le;
            0xDFFF.</li>
        <li>Let <i>cp</i> be (<i>lead</i> &ndash; 0xD800) &times; 1024 + (<i>trail</i> &ndash; 0xDC00) + 0x10000.</li>
        <li>Return the code point <i>cp</i>.</li>
      </ol>
    </section>
  </section>

  <section id="sec-types-of-source-code">
    <div class="front">
      <h2 id="sec-10.2" title="10.2">
          Types of Source Code</h2><p>There are four types of ECMAScript code:</p>

      <ul>
        <li>
          <p><i>Global code</i> is source text that is treated as an ECMAScript <i>Script</i>. The global code of a particular
          <i>Script</i> does not include any source text that is parsed as part of a <i>FunctionDeclaration</i>,
          <i>FunctionExpression</i>, <i>GeneratorDeclaration</i>, <i>GeneratorExpression</i>, <i>MethodDefinition</i>,
          <i>ArrowFunction, ClassDeclaration</i>, or <i>ClassExpression</i>.</p>
        </li>

        <li>
          <p><i>Eval code</i> is the source text supplied to the built-in <code>eval</code> function. More precisely, if the
          parameter to the built-in <code>eval</code> function is a String, it is treated as an ECMAScript <i>Script</i>. The eval
          code for a particular invocation of <code>eval</code> is the global code portion of that <i>Script</i>.</p>
        </li>

        <li>
          <p><i>Function code</i> is source text that is parsed to supply the value of the [[ECMAScriptCode]] and
          [[FormalParameters]] internal slots (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-ecmascript-function-objects">see 9.2</a>) of an <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ecmascript-function-objects">ECMAScript function object</a>. The function code of a particular ECMAScript
          function does not include any source text that is parsed as the function code of a nested <i>FunctionDeclaration</i>,
          <i>FunctionExpression</i>, <i>GeneratorDeclaration</i>, <i>GeneratorExpression</i>, <i>MethodDefinition</i>,
          <i>ArrowFunction, ClassDeclaration</i>, or <i>ClassExpression</i>.</p>
        </li>

        <li>
          <p><i>Module code</i> is source text that is code that is provided as a <i>ModuleBody</i>. It is the code that is
          directly evaluated when a module is initialized. The module code of a particular module does not include any source text
          that is parsed as part of a nested <i>FunctionDeclaration</i>, <i>FunctionExpression</i>, <i>GeneratorDeclaration</i>,
          <i>GeneratorExpression</i>, <i>MethodDefinition</i>,  <i>ArrowFunction, ClassDeclaration</i>, or
          <i>ClassExpression</i>.</p>
        </li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE</span> Function code is generally provided as the bodies of Function Definitions (<a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">14.1</a>), Arrow Function Definitions (<a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions">14.2</a>), Method Definitions (<a href="sec-ecmascript-language-functions-and-classes#sec-method-definitions">14.3</a>) and
        Generator Definitions (<a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions">14.4</a>). Function code is also derived from the
        arguments to the <code>Function</code> constructor (<a href="sec-fundamental-objects#sec-function-p1-p2-pn-body">19.2.1.1</a>) and the
        GeneratorFunction constructor (<a href="sec-control-abstraction-objects#sec-generatorfunction">25.2.1.1</a>).</p>
      </div>
    </div>

    <section id="sec-strict-mode-code">
      <h3 id="sec-10.2.1" title="10.2.1">
          Strict Mode Code</h3><p>An ECMAScript <span class="nt">Script</span> syntactic unit may be processed using either unrestricted or strict mode
      syntax and semantics. Code is interpreted as <i>strict mode code</i> in the following situations:</p>

      <ul>
        <li>
          <p>Global code is strict mode code if it begins with a <a href="sec-ecmascript-language-functions-and-classes#sec-directive-prologues-and-the-use-strict-directive">Directive Prologue</a> that contains a <a href="sec-ecmascript-language-functions-and-classes#sec-directive-prologues-and-the-use-strict-directive">Use Strict Directive</a> (see  <a href="sec-ecmascript-language-functions-and-classes#sec-directive-prologues-and-the-use-strict-directive">14.1.1</a>).</p>
        </li>

        <li>
          <p>Module code is always strict mode code.</p>
        </li>

        <li>
          <p>All parts of a <span class="nt">ClassDeclaration</span> or a <span class="nt">ClassExpression</span> are strict mode
          code.</p>
        </li>

        <li>
          <p>Eval code is strict mode code if it begins with a <a href="sec-ecmascript-language-functions-and-classes#sec-directive-prologues-and-the-use-strict-directive">Directive Prologue</a> that contains a <a href="sec-ecmascript-language-functions-and-classes#sec-directive-prologues-and-the-use-strict-directive">Use Strict Directive</a> or if the call to eval is a direct
          eval (<a href="sec-ecmascript-language-expressions#sec-function-calls-runtime-semantics-evaluation">see 12.3.4.1</a>) that is contained in strict mode
          code.</p>
        </li>

        <li>
          <p>Function code is strict mode code if the associated <span class="nt">FunctionDeclaration</span>, <span class="nt">FunctionExpression</span>, <span class="nt">GeneratorDeclaration</span>, <span class="nt">GeneratorExpression</span>, <span class="nt">MethodDefinition</span>, or <span class="nt">ArrowFunction</span> is contained in strict mode code or if the code that produces the value of the
          function&rsquo;s [[ECMAScriptCode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> begins
          with a <a href="sec-ecmascript-language-functions-and-classes#sec-directive-prologues-and-the-use-strict-directive">Directive Prologue</a> that contains a <a href="sec-ecmascript-language-functions-and-classes#sec-directive-prologues-and-the-use-strict-directive">Use Strict Directive</a>.</p>
        </li>

        <li>
          <p>Function code that is supplied as the arguments to the built-in <code>Function</code> and <code>Generator</code>
          constructors is strict mode code if the last argument is a String that when processed is a <span class="nt">FunctionBody</span> that begins with a <a href="sec-ecmascript-language-functions-and-classes#sec-directive-prologues-and-the-use-strict-directive">Directive Prologue</a> that contains a <a href="sec-ecmascript-language-functions-and-classes#sec-directive-prologues-and-the-use-strict-directive">Use Strict Directive</a>.</p>
        </li>
      </ul>

      <p>ECMAScript code that is not strict mode code is called <i>non-strict code</i>.</p>
    </section>

    <section id="sec-non-ecmascript-functions">
      <h3 id="sec-10.2.2" title="10.2.2"> Non-ECMAScript Functions</h3><p>An ECMAScript implementation may support the evaluation of exotic function objects whose evaluative behaviour is
      expressed in some implementation defined form of executable code other than via ECMAScript code. Whether a function object
      is an ECMAScript code function or a non-ECMAScript function is not semantically observable from the perspective of an
      ECMAScript code function that calls or is called by such a non-ECMAScript function.</p>
    </section>
  </section>
</section>

