<section id="sec-additional-ecmascript-features-for-web-browsers">
  <div class="front">
    <h1 id="sec-B" title="Annex&nbsp;B"> </h1><p>The ECMAScript language syntax and semantics defined in this annex are required when the ECMAScript host is a web browser.
    The content of this annex is normative but optional if the ECMAScript host is not a web browser.</p>

    <div class="note">
      <p><span class="nh">NOTE</span> This annex describes various legacy features and other characteristics of web browser based
      ECMAScript implementations. All of the language features and behaviours specified in this annex have one or more undesirable
      characteristics and in the absence of legacy usage would be removed from this specification. However, the usage of these
      features by large numbers of existing web pages means that web browsers must continue to support them. The specifications in
      this annex defined the requirements for interoperable implementations of these legacy features.</p>

      <p>These features are not considered part of the core ECMAScript language.  Programmers should not use or assume the
      existence of these features and behaviours when writing new ECMAScript code. ECMAScript implementations are discouraged from
      implementing these features unless the implementation is part of a web browser or is required to run the same legacy
      ECMAScript code that web browsers encounter.</p>
    </div>
  </div>

  <section id="sec-additional-syntax">
    <div class="front">
      <h2 id="sec-B.1" title="B.1">
          Additional Syntax</h2></div>

    <section id="sec-additional-syntax-numeric-literals">
      <h3 id="sec-B.1.1" title="B.1.1"> Numeric Literals</h3><p>The syntax and semantics of <a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">11.8.3</a> is extended as follows except that this
      extension is not allowed for <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>:</p>

      <h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">NumericLiteral</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">DecimalLiteral</span></div>
        <div class="rhs"><span class="nt">BinaryIntegerLiteral</span></div>
        <div class="rhs"><span class="nt">OctalIntegerLiteral</span></div>
        <div class="rhs"><span class="nt">HexIntegerLiteral</span></div>
        <div class="rhs"><span class="nt">LegacyOctalIntegerLiteral</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">LegacyOctalIntegerLiteral</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">0</code> <span class="nt">OctalDigit</span></div>
        <div class="rhs"><span class="nt">LegacyOctalIntegerLiteral</span> <span class="nt">OctalDigit</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">DecimalIntegerLiteral</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">0</code></div>
        <div class="rhs"><span class="nt">NonZeroDigit</span> <span class="nt">DecimalDigits</span><sub class="g-opt">opt</sub></div>
        <div class="rhs"><span class="nt">NonOctalDecimalIntegerLiteral</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">NonOctalDecimalIntegerLiteral</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">0</code> <span class="nt">NonOctalDigit</span></div>
        <div class="rhs"><span class="nt">LegacyOctalLikeDecimalIntegerLiteral</span> <span class="nt">NonOctalDigit</span></div>
        <div class="rhs"><span class="nt">NonOctalDecimalIntegerLiteral</span> <span class="nt">DecimalDigit</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">LegacyOctalLikeDecimalIntegerLiteral</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">0</code> <span class="nt">OctalDigit</span></div>
        <div class="rhs"><span class="nt">LegacyOctalLikeDecimalIntegerLiteral</span> <span class="nt">OctalDigit</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">NonOctalDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
        <div class="rhs"><code class="t">8</code> <code class="t">9</code></div>
      </div>

      <p><b>B.1.1.1</b>&#x9;<b>Static Semantics</b></p>

      <ul>
        <li>
          <p>The MV of <span class="prod"><span class="nt">LegacyOctalIntegerLiteral</span> <span class="geq">::</span> <code class="t">0</code> <span class="nt">OctalDigit</span></span> is the MV of <span class="nt">OctalDigit</span>.</p>
        </li>

        <li>
          <p>The MV of <span class="prod"><span class="nt">LegacyOctalIntegerLiteral</span> <span class="geq">::</span> <span class="nt">LegacyOctalIntegerLiteral</span> <span class="nt">OctalDigit</span></span> is (the MV of <span class="nt">LegacyOctalIntegerLiteral</span> times 8) plus the MV of <span class="nt">OctalDigit</span>.</p>
        </li>

        <li>
          <p>The MV of <span class="prod"><span class="nt">DecimalIntegerLiteral</span> <span class="geq">::</span> <span class="nt">NonOctalDecimalIntegerLiteral</span></span> is the MV of <span class="nt">NonOctalDecimalIntegerLiteral</span>.</p>
        </li>

        <li>
          <p>The MV of <span class="prod"><span class="nt">NonOctalDecimalIntegerLiteral</span> <span class="geq">::</span> <code class="t">0</code> <span class="nt">NonOctalDigit</span></span> is the MV of <span class="nt">NonOctalDigit</span>.</p>
        </li>

        <li>
          <p>The MV of <span class="prod"><span class="nt">NonOctalDecimalIntegerLiteral</span> <span class="geq">::</span> <span class="nt">LegacyOctalLikeDecimalIntegerLiteral</span> <span class="nt">NonOctalDigit</span></span> is (the MV of <span class="nt">LegacyOctalLikeDecimalIntegerLiteral</span>  times 10) plus the MV of <span class="nt">NonOctalDigit</span>.</p>
        </li>

        <li>
          <p>The MV of <span class="prod"><span class="nt">NonOctalDecimalIntegerLiteral</span> <span class="geq">::</span> <span class="nt">NonOctalDecimalIntegerLiteral</span> <span class="nt">DecimalDigit</span></span> is (the MV of <span class="nt">NonOctalDecimalIntegerLiteral</span> times 10) plus the MV of <span class="nt">DecimalDigit</span>.</p>
        </li>

        <li>
          <p>The MV of <span class="prod"><span class="nt">LegacyOctalLikeDecimalIntegerLiteral</span> <span class="geq">::</span>
          <code class="t">0</code> <span class="nt">OctalDigit</span></span> is the MV of <span class="nt">OctalDigit</span>.</p>
        </li>

        <li>
          <p>The MV of <span class="prod"><span class="nt">LegacyOctalLikeDecimalIntegerLiteral</span> <span class="geq">::</span>
          <span class="nt">LegacyOctalLikeDecimalIntegerLiteral</span> <span class="nt">OctalDigit</span></span> is (the MV of
          <span class="nt">LegacyOctalLikeDecimalIntegerLiteral</span>  times 10) plus the MV of <span class="nt">OctalDigit</span>.</p>
        </li>

        <li>
          <p>The MV of <span class="prod"><span class="nt">NonOctalDigit</span> <span class="geq">::</span> <code class="t">8</code></span> is 8.</p>
        </li>

        <li>
          <p>The MV of <span class="prod"><span class="nt">NonOctalDigit</span> <span class="geq">::</span> <code class="t">9</code></span> is 9.</p>
        </li>
      </ul>
    </section>

    <section id="sec-additional-syntax-string-literals">
      <h3 id="sec-B.1.2" title="B.1.2"> String Literals</h3><p>The syntax and semantics of <a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">11.8.4</a> is extended as follows except that this
      extension is not allowed for <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>:</p>

      <h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">EscapeSequence</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">CharacterEscapeSequence</span></div>
        <div class="rhs"><span class="nt">LegacyOctalEscapeSequence</span></div>
        <div class="rhs"><span class="nt">HexEscapeSequence</span></div>
        <div class="rhs"><span class="nt">UnicodeEscapeSequence</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">LegacyOctalEscapeSequence</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">OctalDigit</span> <span class="grhsannot">[lookahead &notin; <span class="nt">OctalDigit</span>]</span></div>
        <div class="rhs"><span class="nt">ZeroToThree</span> <span class="nt">OctalDigit</span> <span class="grhsannot">[lookahead &notin; <span class="nt">OctalDigit</span>]</span></div>
        <div class="rhs"><span class="nt">FourToSeven</span> <span class="nt">OctalDigit</span></div>
        <div class="rhs"><span class="nt">ZeroToThree</span> <span class="nt">OctalDigit</span> <span class="nt">OctalDigit</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ZeroToThree</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
        <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">FourToSeven</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
        <div class="rhs"><code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code></div>
      </div>

      <p>This definition of <span class="nt">EscapeSequence</span> is not used in strict mode or when parsing <span class="nt">TemplateCharacter</span> (<a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">11.8.6</a>).</p>

      <p><b>B.1.2.1</b>&#x9;<b>Static Semantics</b></p>

      <ul>
        <li>The SV of <span class="prod"><span class="nt">EscapeSequence</span> <span class="geq">::</span> <span class="nt">LegacyOctalEscapeSequence</span></span> is the SV of the <i>LegacyOctalEscapeSequence</i>.</li>
        <li>The SV of <span class="prod"><span class="nt">LegacyOctalEscapeSequence</span> <span class="geq">::</span> <span class="nt">OctalDigit</span></span> is the code unit whose value is the MV of the <i>OctalDigit</i>.</li>
        <li>The SV of <span class="prod"><span class="nt">LegacyOctalEscapeSequence</span> <span class="geq">::</span> <span class="nt">ZeroToThree</span> <span class="nt">OctalDigit</span></span> is the code unit whose value is (8 times the
            MV of the <i>ZeroToThree</i>) plus the MV of the <i>OctalDigit</i>.</li>
        <li>The SV of <span class="prod"><span class="nt">LegacyOctalEscapeSequence</span> <span class="geq">::</span> <span class="nt">FourToSeven</span> <span class="nt">OctalDigit</span></span> is the code unit whose value is (8 times the
            MV of the <i>FourToSeven</i>) plus the MV of the <i>OctalDigit</i>.</li>
        <li>The SV of <span class="prod"><span class="nt">LegacyOctalEscapeSequence</span> <span class="geq">::</span> <span class="nt">ZeroToThree</span> <span class="nt">OctalDigit</span> <span class="nt">OctalDigit</span></span> is the code
            unit whose value is (64 (that is, 8<sup>2</sup>) times the MV of the <i>ZeroToThree</i>) plus (8 times the MV of the
            first <i>OctalDigit</i>) plus the MV of the second <i>OctalDigit</i>.</li>
        <li>The MV of <span class="prod"><span class="nt">ZeroToThree</span> <span class="geq">::</span> <code class="t">0</code></span> is 0.</li>
        <li>The MV of <span class="prod"><span class="nt">ZeroToThree</span> <span class="geq">::</span> <code class="t">1</code></span> is 1.</li>
        <li>The MV of <span class="prod"><span class="nt">ZeroToThree</span> <span class="geq">::</span> <code class="t">2</code></span> is 2.</li>
        <li>The MV of <span class="prod"><span class="nt">ZeroToThree</span> <span class="geq">::</span> <code class="t">3</code></span> is 3.</li>
        <li>The MV of <span class="prod"><span class="nt">FourToSeven</span> <span class="geq">::</span> <code class="t">4</code></span> is 4.</li>
        <li>The MV of <span class="prod"><span class="nt">FourToSeven</span> <span class="geq">::</span> <code class="t">5</code></span> is 5.</li>
        <li>The MV of <span class="prod"><span class="nt">FourToSeven</span> <span class="geq">::</span> <code class="t">6</code></span> is 6.</li>
        <li>The MV of <span class="prod"><span class="nt">FourToSeven</span> <span class="geq">::</span> <code class="t">7</code></span> is 7.</li>
      </ul>
    </section>

    <section id="sec-html-like-comments">
      <h3 id="sec-B.1.3" title="B.1.3">
          HTML-like Comments</h3><p>The syntax and semantics of <a href="sec-ecmascript-language-lexical-grammar#sec-comments">11.4</a> is extended as follows except that this extension is not
      allowed when parsing source code using the goal symbol <span class="prod"><span class="nt">Module</span> <span class="geq">:</span></span></p>

      <h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">Comment</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">MultiLineComment</span></div>
        <div class="rhs"><span class="nt">SingleLineComment</span></div>
        <div class="rhs"><span class="nt">SingleLineHTMLOpenComment</span></div>
        <div class="rhs"><span class="nt">SingleLineHTMLCloseComment</span></div>
        <div class="rhs"><span class="nt">SingleLineDelimitedComment</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">MultiLineComment</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">/*</code> <span class="nt">FirstCommentLine</span><sub class="g-opt">opt</sub> <span class="nt">LineTerminator</span> <span class="nt">MultiLineCommentChars</span><sub class="g-opt">opt</sub> <code class="t">*/</code> <span class="nt">HTMLCloseComment</span><sub class="g-opt">opt</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">FirstCommentLine</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">SingleLineDelimitedCommentChars</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">SingleLineHTMLOpenComment</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">&lt;!--</code> <span class="nt">SingleLineCommentChars</span><sub class="g-opt">opt</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">SingleLineHTMLCloseComment</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">LineTerminatorSequence</span> <span class="nt">HTMLCloseComment</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">SingleLineDelimitedComment</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">/*</code> <span class="nt">SingleLineDelimitedCommentChars</span><sub class="g-opt">opt</sub> <code class="t">*/</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">HTMLCloseComment</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">WhiteSpaceSequence</span><sub class="g-opt">opt</sub> <span class="nt">SingleLineDelimitedCommentSequence</span><sub class="g-opt">opt</sub> <code class="t">--&gt;</code> <span class="nt">SingleLineCommentChars</span><sub class="g-opt">opt</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">SingleLineDelimitedCommentChars</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">SingleLineNotAsteriskChar</span> <span class="nt">SingleLineDelimitedCommentChars</span><sub class="g-opt">opt</sub></div>
        <div class="rhs"><code class="t">*</code> <span class="nt">SingleLinePostAsteriskCommentChars</span><sub class="g-opt">opt</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">SingleLineNotAsteriskChar</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">*</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">SingleLinePostAsteriskCommentChars</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">SingleLineNotForwardSlashOrAsteriskChar</span> <span class="nt">SingleLineDelimitedCommentChars</span><sub class="g-opt">opt</sub></div>
        <div class="rhs"><code class="t">*</code> <span class="nt">SingleLinePostAsteriskCommentChars</span><sub class="g-opt">opt</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">SingleLineNotForwardSlashOrAsteriskChar</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">/</code> <span class="grhsmod">or</span> <code class="t">*</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">WhiteSpaceSequence</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">WhiteSpace</span> <span class="nt">WhiteSpaceSequence</span><sub class="g-opt">opt</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">SingleLineDelimitedCommentSequence</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">SingleLineDelimitedComment</span> <span class="nt">WhiteSpaceSequence</span><sub class="g-opt">opt</sub> <span class="nt">SingleLineDelimitedCommentSequence</span><sub class="g-opt">opt</sub></div>
      </div>

      <p>Similar to a <span class="nt">MultiLineComment</span> that contains a line terminator code point, a <span class="nt">SingleLineHTMLCloseComment</span> is considered to be a <span class="nt">LineTerminator</span> for purposes of
      parsing by the syntactic grammar.</p>
    </section>

    <section id="sec-regular-expressions-patterns">
      <h3 id="sec-B.1.4" title="B.1.4"> Regular Expressions Patterns</h3><p>The syntax of <a href="sec-text-processing#sec-patterns">21.2.1</a> is modified and extended as follows. These changes introduce ambiguities
      that are broken by the ordering of grammar productions and by contextual information. When parsing using the following
      grammar, each alternative is considered only if previous production alternatives do not match.</p>

      <p>This alternative pattern grammar and semantics only changes the syntax and semantics of BMP patterns. The following
      grammar extensions include productions parameterized with the [U] parameter. However, none of these extensions change the
      syntax of Unicode patterns recognized when parsing with the [U] parameter present on the goal symbol.</p>

      <p><b>Syntax</b></p>

      <div class="gp">
        <div class="lhs"><span class="nt">Term</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">ExtendedTerm</span></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">Assertion</span><sub class="g-params">[U]</sub></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">Atom</span><sub class="g-params">[U]</sub></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">Atom</span><sub class="g-params">[U]</sub> <span class="nt">Quantifier</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ExtendedTerm</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">Assertion</span></div>
        <div class="rhs"><span class="nt">AtomNoBrace</span> <span class="nt">Quantifier</span></div>
        <div class="rhs"><span class="nt">Atom</span></div>
        <div class="rhs"><span class="nt">QuantifiableAssertion</span> <span class="nt">Quantifier</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">AtomNoBrace</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">PatternCharacterNoBrace</span></div>
        <div class="rhs"><code class="t">.</code></div>
        <div class="rhs"><code class="t">\</code> <span class="nt">AtomEscape</span></div>
        <div class="rhs"><span class="nt">CharacterClass</span></div>
        <div class="rhs"><code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></div>
        <div class="rhs"><code class="t">(</code> <code class="t">?</code> <code class="t">:</code> <span class="nt">Disjunction</span> <code class="t">)</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">Atom</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">PatternCharacter</span></div>
        <div class="rhs"><code class="t">.</code></div>
        <div class="rhs"><code class="t">\</code> <span class="nt">AtomEscape</span><sub class="g-params">[?U]</sub></div>
        <div class="rhs"><span class="nt">CharacterClass</span><sub class="g-params">[?U]</sub></div>
        <div class="rhs"><code class="t">(</code> <span class="nt">Disjunction</span><sub class="g-params">[?U]</sub> <code class="t">)</code></div>
        <div class="rhs"><code class="t">(</code> <code class="t">?</code> <code class="t">:</code> <span class="nt">Disjunction</span><sub class="g-params">[?U]</sub> <code class="t">)</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">PatternCharacterNoBrace</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span></div>
        <div class="rhs"><code class="t">^</code> <code class="t">$</code> <code class="t">\</code> <code class="t">.</code> <code class="t">*</code> <code class="t">+</code> <code class="t">?</code> <code class="t">(</code> <code class="t">)</code> <code class="t">[</code> <code class="t">]</code> <code class="t">{</code> <code class="t">}</code> <code class="t">|</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">PatternCharacter</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span></div>
        <div class="rhs"><code class="t">^</code> <code class="t">$</code> <code class="t">\</code> <code class="t">.</code> <code class="t">*</code> <code class="t">+</code> <code class="t">?</code> <code class="t">(</code> <code class="t">)</code> <code class="t">[</code> <code class="t">]</code> <code class="t">|</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">QuantifiableAssertion</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">(</code> <code class="t">?</code> <code class="t">=</code> <span class="nt">Disjunction</span> <code class="t">)</code></div>
        <div class="rhs"><code class="t">(</code> <code class="t">?</code> <code class="t">!</code> <span class="nt">Disjunction</span> <code class="t">)</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">Assertion</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">^</code></div>
        <div class="rhs"><code class="t">$</code></div>
        <div class="rhs"><code class="t">\</code> <code class="t">b</code></div>
        <div class="rhs"><code class="t">\</code> <code class="t">B</code></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">(</code> <code class="t">?</code> <code class="t">=</code> <span class="nt">Disjunction</span><sub class="g-params">[U]</sub> <code class="t">)</code></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">(</code> <code class="t">?</code> <code class="t">!</code> <span class="nt">Disjunction</span><sub class="g-params">[U]</sub> <code class="t">)</code></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">QuantifiableAssertion</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">AtomEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">DecimalEscape</span></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">CharacterEscape</span><sub class="g-params">[U]</sub></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">CharacterClassEscape</span></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">DecimalEscape</span> <code class="t">but</code> <code class="t">only</code> <code class="t">if</code> <code class="t">the</code> <code class="t">integer</code> <code class="t">value</code> <code class="t">of</code> <span class="nt">DecimalEscape</span> <code class="t">is</code> <code class="t">&lt;=</code> <span class="nt">NCapturingParens</span></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">CharacterClassEscape</span></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">CharacterEscape</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">CharacterEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">ControlEscape</span></div>
        <div class="rhs"><code class="t">c</code> <span class="nt">ControlLetter</span></div>
        <div class="rhs"><span class="nt">HexEscapeSequence</span></div>
        <div class="rhs"><span class="nt">RegExpUnicodeEscapeSequence</span><sub class="g-params">[?U]</sub></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">LegacyOctalEscapeSequence</span></div>
        <div class="rhs"><span class="nt">IdentityEscape</span><sub class="g-params">[?U]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">IdentityEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">SyntaxCharacter</span></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">/</code></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <code class="t">c</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">NonemptyClassRanges</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub></div>
        <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub> <span class="nt">NonemptyClassRangesNoDash</span><sub class="g-params">[?U]</sub></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">ClassAtom</span><sub class="g-params">[U]</sub> <code class="t">-</code> <span class="nt">ClassAtom</span><sub class="g-params">[U]</sub> <span class="nt">ClassRanges</span><sub class="g-params">[U]</sub></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">ClassAtomInRange</span> <code class="t">-</code> <span class="nt">ClassAtomInRange</span> <span class="nt">ClassRanges</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">NonemptyClassRangesNoDash</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub></div>
        <div class="rhs"><span class="nt">ClassAtomNoDash</span><sub class="g-params">[?U]</sub> <span class="nt">NonemptyClassRangesNoDash</span><sub class="g-params">[?U]</sub></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">ClassAtomNoDash</span><sub class="g-params">[U]</sub> <code class="t">-</code> <span class="nt">ClassAtom</span><sub class="g-params">[U]</sub> <span class="nt">ClassRanges</span><sub class="g-params">[U]</sub></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">ClassAtomNoDashInRange</span> <code class="t">-</code> <span class="nt">ClassAtomInRange</span> <span class="nt">ClassRanges</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassAtom</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">-</code></div>
        <div class="rhs"><span class="nt">ClassAtomNoDash</span><sub class="g-params">[?U]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassAtomNoDash</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">]</code> <span class="grhsmod">or</span> <code class="t">-</code></div>
        <div class="rhs"><code class="t">\</code> <span class="nt">ClassEscape</span><sub class="g-params">[?U]</sub></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassAtomInRange</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">-</code></div>
        <div class="rhs"><span class="nt">ClassAtomNoDashInRange</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassAtomNoDashInRange</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">]</code> <span class="grhsmod">or</span> <code class="t">-</code></div>
        <div class="rhs"><code class="t">\</code> <span class="nt">ClassEscape</span> <code class="t">but</code> <code class="t">only</code> <code class="t">if</code> <span class="nt">ClassEscape</span> <code class="t">evaluates</code> <code class="t">to</code> <code class="t">a</code> <span class="nt">CharSet</span> <code class="t">with</code> <code class="t">exactly</code> <code class="t">one</code> <code class="t">character</code></div>
        <div class="rhs"><code class="t">\</code> <span class="nt">IdentityEscape</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">ClassEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">DecimalEscape</span></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">CharacterEscape</span><sub class="g-params">[U]</sub></div>
        <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">CharacterClassEscape</span></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">DecimalEscape</span></div>
        <div class="rhs"><code class="t">b</code></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">CharacterClassEscape</span></div>
        <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">CharacterEscape</span></div>
      </div>

      <div class="note">
        <p><span class="nh">NOTE</span> When the same left hand sides occurs with both [+U] and [~U] guards it is to control the
        disambiguation priority.</p>
      </div>

      <p><b>B.1.4.1</b>&#x9;<b>Pattern Semantics</b></p>

      <p>The semantics of <a href="sec-text-processing#sec-pattern-semantics">21.2.2</a> is extended as follows:</p>

      <p>Within <a href="sec-text-processing#sec-term">21.2.2.5</a> reference to &ldquo;<span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> &rdquo;
      are to be interpreted as meaning &ldquo;<span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> &rdquo; or &ldquo;<span class="prod"><span class="nt">AtomNoBrace</span> <span class="geq">::</span> <code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> &rdquo;.</p>

      <p>Term (<a href="sec-text-processing#sec-term">21.2.2.5</a>) includes the following additional evaluation rule:</p>

      <p>The production <span class="prod"><span class="nt">Term</span> <span class="geq">::</span> <span class="nt">QuantifiableAssertion</span> <span class="nt">Quantifier</span></span> evaluates the same as the production <span class="prod"><span class="nt">Term</span> <span class="geq">::</span> <span class="nt">Atom</span> <span class="nt">Quantifier</span></span> but with <span class="nt">QuantifiableAssertion</span> substituted for <span style="font-family: Times New Roman"><i>Atom</i>.</span></p>

      <p>Atom (<a href="sec-text-processing#sec-atom">21.2.2.8</a>) evaluation rules for the <span class="nt">Atom</span> productions except for
      <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <span class="nt">PatternCharacter</span></span>
      are also used for the <span class="nt">AtomNoBrace</span> productions, but with <span class="nt">AtomNoBrace</span>
      substituted for <span style="font-family: Times New Roman"><i>Atom</i>.</span> The following evaluation rule is also
      added:</p>

      <p class="normalbefore">The production <span class="prod"><span class="nt">AtomNoBrace</span> <span class="geq">::</span>
      <span class="nt">PatternCharacterNoBrace</span></span> evaluates as follows:</p>

      <ol class="proc">
        <li>Let <i>ch</i> be the character represented by <i>PatternCharacterNoBrace</i>.</li>
        <li>Let <i>A</i> be a one-element CharSet containing the character <i>ch</i>.</li>
        <li><a href="sec-abstract-operations#sec-call">Call</a> CharacterSetMatcher(<i>A</i>, <b>false</b>) and return its Matcher result.</li>
      </ol>

      <p>CharacterEscape (<a href="sec-text-processing#sec-characterescape">21.2.2.10</a>) includes the following additional evaluation rule:</p>

      <p>The production <span class="prod"><span class="nt">CharacterEscape</span> <span class="geq">::</span> <span class="nt">LegacyOctalEscapeSequence</span></span> evaluates by evaluating the SV of the <span class="nt">LegacyOctalEscapeSequence</span> (<a href="#sec-additional-syntax-string-literals">see B.1.2</a>) and returning
      its character result.</p>

      <p>ClassAtom (<a href="sec-text-processing#sec-classatom">21.2.2.17</a>) includes the following additional evaluation rules:</p>

      <p>The production <span class="prod"><span class="nt">ClassAtomInRange</span> <span class="geq">::</span> <code class="t">-</code></span> evaluates by returning the CharSet containing the one character <code>-</code>.</p>

      <p>The production <span class="prod"><span class="nt">ClassAtomInRange</span> <span class="geq">::</span> <span class="nt">ClassAtomNoDashInRange</span></span> evaluates by evaluating <span class="nt">ClassAtomNoDashInRange</span> to
      obtain a CharSet and returning that CharSet.</p>

      <p>ClassAtomNoDash (<a href="sec-text-processing#sec-classatomnodash">21.2.2.18</a>) includes the following additional evaluation rules:</p>

      <p>The production <span class="prod"><span class="nt">ClassAtomNoDashInRange</span> <span class="geq">::</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">]</code> <span class="grhsmod">or</span> <code class="t">-</code></span> evaluates
      by returning a one-element CharSet containing the character represented by <span class="nt">SourceCharacter</span>.</p>

      <p>The production <span class="prod"><span class="nt">ClassAtomNoDashInRange</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">ClassEscape</span></span> but only if&hellip;, evaluates by evaluating <span class="nt">ClassEscape</span> to obtain a CharSet and returning that CharSet.</p>

      <p>The production <span class="prod"><span class="nt">ClassAtomNoDashInRange</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">IdentityEscape</span></span> evaluates by returning the character represented by <span class="nt">IdentityEscape</span>.</p>
    </section>
  </section>

  <section id="sec-additional-built-in-properties">
    <div class="front">
      <h2 id="sec-B.2" title="B.2"> Additional Built-in Properties</h2><p>When the ECMAScript host is a web browser the following additional properties of the standard built-in objects are
      defined.</p>
    </div>

    <section id="sec-additional-properties-of-the-global-object">
      <div class="front">
        <h3 id="sec-B.2.1" title="B.2.1"> Additional Properties of the Global Object</h3><p>The entries in <a href="#table-60">Table 60</a> are added to <a href="sec-ecmascript-data-types-and-values#table-7">Table 7</a>.</p>

        <figure>
          <figcaption><span id="table-60">Table 60</span> &mdash; Additional Well-known Intrinsic Objects</figcaption>
          <table class="real-table">
            <tr>
              <th>Intrinsic Name</th>
              <th>Global Name</th>
              <th>ECMAScript Language Association</th>
            </tr>
            <tr>
              <td>%escape%</td>
              <td><code>escape</code></td>
              <td>The <code>escape</code> function (<a href="#sec-escape-string">B.2.1.1</a>)</td>
            </tr>
            <tr>
              <td>%unescape%</td>
              <td><code>unescape</code></td>
              <td>The <code>unescape</code> function (<a href="#sec-unescape-string">B.2.1.2</a>)</td>
            </tr>
          </table>
        </figure>
      </div>

      <section id="sec-escape-string">
        <h4 id="sec-B.2.1.1" title="B.2.1.1">
            escape (string)</h4><p>The <code>escape</code> function is a property of the global object. It computes a new version of a String value in
        which certain code units have been replaced by a hexadecimal escape sequence.</p>

        <p>For those code units being replaced whose value is <code>0x00FF</code> or less, a two-digit escape sequence of the form
        <code>%</code><i>xx</i> is used. For those characters being replaced whose code unit value is greater than
        <code>0x00FF</code>, a four-digit escape sequence of the form <code>%u</code><i>xxxx</i> is used.</p>

        <p class="normalbefore">The <code>escape</code> function is the %escape% intrinsic object. When the <code>escape</code>
        function is called with one argument <var>string</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>string</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>string</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>string</i>).</li>
          <li>Let <i>length</i> be the number of code units in <i>string</i>.</li>
          <li>Let <i>R</i> be the empty string.</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>length</i>,
            <ol class="block">
              <li>Let <i>char</i> be the code unit (represented as a 16-bit unsigned integer) at index <i>k</i> within
                  <i>string</i>.</li>
              <li>If <i>char</i> is one of the code units in
                  <b>"<code>ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@*_+-./</code>"</b>, then
                <ol class="block">
                  <li>Let <i>S</i> be a String containing the single code unit <i>char</i>.</li>
                </ol>
              </li>
              <li>Else if <i>char</i> &ge; 256, then
                <ol class="block">
                  <li>Let <i>S</i> be a String containing six code units <b>"<code>%u</code></b><i>wxyz</i><b>"</b> where
                      <i>wxyz</i> are the code units of the four hexadecimal digits encoding the value of <i>char</i>.</li>
                </ol>
              </li>
              <li>Else, <i>char</i> &lt; 256
                <ol class="block">
                  <li>Let <i>S</i> be a String containing three code units <b>"<code>%</code></b><i>xy</i><b>"</b> where <i>xy</i>
                      are the code units of two hexadecimal digits encoding the value of <i>char</i>.</li>
                </ol>
              </li>
              <li>Let <i>R</i> be a new String value computed by concatenating the previous value of <i>R</i> and <i>S</i>.</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>R</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The encoding is partly based on the encoding described in RFC 1738, but the entire
          encoding specified in this standard is described above without regard to the contents of RFC 1738. This encoding does
          not reflect changes to RFC 1738 made by RFC 3986.</p>
        </div>
      </section>

      <section id="sec-unescape-string">
        <h4 id="sec-B.2.1.2" title="B.2.1.2">
            unescape (string)</h4><p>The <code>unescape</code> function is a property of the global object. It computes a new version of a String value in
        which each escape sequence of the sort that might be introduced by the <code>escape</code> function is replaced with the
        code unit that it represents.</p>

        <p class="normalbefore">The <code>unescape</code> function is the %unescape% intrinsic object. When the
        <code>unescape</code> function is called with one argument <var>string</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>string</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>string</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>string</i>).</li>
          <li>Let <i>length</i> be the number of code units in <i>string</i>.</li>
          <li>Let <i>R</i> be the empty String.</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &ne; <i>length</i>
            <ol class="block">
              <li>Let <i>c</i> be the code unit at index <i>k</i> within <i>string</i>.</li>
              <li>If <i>c</i> is <code>%</code>,
                <ol class="block">
                  <li>If <i>k</i> &le; <i>length</i>&minus;6 and the code unit at index <i>k</i>+1 within <i>string</i> is
                      <code>u</code> and the four code units at indices <i>k</i>+2, <i>k</i>+3, <i>k</i>+4, and <i>k</i>+5 within
                      <i>string</i> are all hexadecimal digits, then
                    <ol class="block">
                      <li>Let <i>c</i> be the code unit whose value is the integer represented by the four hexadecimal digits at
                          indices <i>k</i>+2, <i>k</i>+3, <i>k</i>+4, and <i>k</i>+5 within <i>string</i>.</li>
                      <li>Increase <i>k</i> by 5.</li>
                    </ol>
                  </li>
                  <li>Else if <i>k</i> &le; <i>length</i>&minus;3 and the two code units at indices <i>k</i>+1 and <i>k</i>+2
                      within <i>string</i> are both hexadecimal digits, then
                    <ol class="block">
                      <li>Let <i>c</i> be the code unit whose value is the integer represented by two zeroes plus the two
                          hexadecimal digits at indices <i>k</i>+1 and <i>k</i>+2 within <i>string</i>.</li>
                      <li>Increase <i>k</i> by 2.</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li>Let <i>R</i> be a new String value computed by concatenating the previous value of <i>R</i> and <i>c</i>.</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>R</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-additional-properties-of-the-object.prototype-object">
      <div class="front">
        <h3 id="sec-B.2.2" title="B.2.2"> Additional Properties of the Object.prototype Object</h3></div>

      <section id="sec-object.prototype.__proto__">
        <div class="front">
          <h4 id="sec-B.2.2.1" title="B.2.2.1"> Object.prototype.__proto__</h4><p>Object.prototype.__proto__ is an accessor property with attributes { [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }. The [[Get]] and [[Set]] attributes are
          defined as follows</p>
        </div>

        <section id="sec-get-object.prototype.__proto__">
          <h5 id="sec-B.2.2.1.1" title="B.2.2.1.1"> get Object.prototype.__proto__</h5><p class="normalbefore">The value of the [[Get]] attribute is a built-in function that requires no arguments. It
          performs the following steps:</p>

          <ol class="proc">
            <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
            <li>Return <i>O</i>.[[GetPrototypeOf]]().</li>
          </ol>
        </section>

        <section id="sec-set-object.prototype.__proto__">
          <h5 id="sec-B.2.2.1.2" title="B.2.2.1.2"> set Object.prototype.__proto__</h5><p class="normalbefore">The value of the [[Set]] attribute is a built-in function that takes an argument
          <var>proto</var>. It performs the following steps:</p>

          <ol class="proc">
            <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value)<i>.</i></li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>proto</i>) is neither Object nor Null, return
                <b>undefined</b>.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <b>undefined</b>.</li>
            <li>Let <i>status</i> be <i>O</i>.[[SetPrototypeOf]](<i>proto</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
            <li>If <i>status</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
            <li>Return <b>undefined</b>.</li>
          </ol>
        </section>
      </section>
    </section>

    <section id="sec-additional-properties-of-the-string.prototype-object">
      <div class="front">
        <h3 id="sec-B.2.3" title="B.2.3"> Additional Properties of the String.prototype Object</h3></div>

      <section id="sec-string.prototype.substr">
        <h4 id="sec-B.2.3.1" title="B.2.3.1"> String.prototype.substr (start, length)</h4><p class="normalbefore">The <code>substr</code> method takes two arguments, <var>start</var> and <var>length</var>, and
        returns a substring of the result of converting the <b>this</b> object to a String, starting from index <var>start</var>
        and running for <var>length</var> code units (or through the end of the String if <var>length</var> is <b>undefined</b>).
        If <var>start</var> is negative, it is treated as <span style="font-family: Times New         Roman">(<i>sourceLength</i>+<i>start</i>)</span> where <var>sourceLength</var> is the length of the String. The result is
        a String value, not a String object. The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>intStart</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>start</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>intStart</i>).</li>
          <li>If <i>length</i> is <b>undefined</b>, let <i>end</i> be <b>+&infin;</b>; otherwise let <i>end</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>length</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>end</i>).</li>
          <li>Let <i>size</i> be the number of code units in <i>S</i>.</li>
          <li>If <i>intStart</i> &lt; 0, let <i>intStart</i> be max(<i>size</i> + <i>intStart</i>,0).</li>
          <li>Let <i>resultLength</i> be min(max(<i>end</i>,0), <i>size</i> &ndash; <i>intStart</i>).</li>
          <li>If <i>resultLength</i> &le; 0, return the empty String <code>""</code>.</li>
          <li>Return a String containing <i>resultLength</i> consecutive code units from <i>S</i> beginning with the code unit at
              index <i>intStart</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>substr</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>substr</code> function is intentionally generic; it does not require that its
          <b>this</b> value be a String object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.anchor">
        <div class="front">
          <h4 id="sec-B.2.3.2" title="B.2.3.2"> String.prototype.anchor ( name )</h4><p class="normalbefore">When the <b>anchor</b> method is called with argument <var>name</var>, the following steps are
          taken:</p>

          <ol class="proc">
            <li>Let <i>S</i> be the <b>this</b> value.</li>
            <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"a"</code>, <code>"name"</code>,
                <i>name</i>).</li>
          </ol>
        </div>

        <section id="sec-createhtml">
          <h5 id="sec-B.2.3.2.1" title="B.2.3.2.1">
              Runtime Semantics: CreateHTML ( string, tag, attribute, value )</h5><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">CreateHTML</span> is called
          with arguments <var>string, tag</var>, <var>attribute</var>, and <span style="font-family: Times New           Roman"><i>value</i>.</span> The arguments <var>tag</var> and <var>attribute</var> must be String values. The following
          steps are taken:</p>

          <ol class="proc">
            <li>Let <i>str</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<i>string</i>).</li>
            <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>str</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
            <li>Let <i>p1</i> be the String value that is the concatenation of <code>"&lt;"</code> and <i>tag</i>.</li>
            <li>If <i>attribute</i> is not the empty String, then
              <ol class="block">
                <li>Let <i>V</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>value</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>V</i>).</li>
                <li>Let <i>escapedV</i> be the String value that is the same as <i>V</i> except that each occurrence of the code
                    unit 0x0022 (QUOTATION MARK) in <i>V</i> has been replaced with the six code unit sequence
                    <code>"&amp;quot;"</code>.</li>
                <li>Let <i>p1</i> be the String value that is the concatenation of the following String values:
                  <ul>
                    <li>The String value of <i>p1</i></li>
                    <li>Code unit 0x0020 (SPACE)</li>
                    <li>The String value of <i>attribute</i></li>
                    <li>Code unit 0x003D (EQUALS SIGN)</li>
                    <li>Code unit 0x0022 (QUOTATION MARK)</li>
                    <li>The String value of <i>escapedV</i></li>
                    <li>Code unit 0x0022 (QUOTATION MARK)</li>
                  </ul>
                </li>
              </ol>
            </li>
            <li>Let <i>p2</i> be the String value that is the concatenation of <i>p1</i> and <code>"&gt;"</code>.</li>
            <li>Let <i>p3</i> be the String value that is the concatenation of <i>p2</i> and <i>S</i>.</li>
            <li>Let <i>p4</i> be the String value that is the concatenation of <i>p3</i>, <code>"&lt;/"</code>, <i>tag</i>, and
                <code>"&gt;"</code>.</li>
            <li>Return <i>p4</i>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-string.prototype.big">
        <h4 id="sec-B.2.3.3" title="B.2.3.3"> String.prototype.big ()</h4><p class="normalbefore">When the <b>big</b> method is called with no arguments, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"big"</code>, <code>""</code>,
              <code>""</code>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.blink">
        <h4 id="sec-B.2.3.4" title="B.2.3.4"> String.prototype.blink ()</h4><p class="normalbefore">When the <b>blink</b> method is called with no arguments, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"blink"</code>, <code>""</code>,
              <code>""</code>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.bold">
        <h4 id="sec-B.2.3.5" title="B.2.3.5"> String.prototype.bold ()</h4><p class="normalbefore">When the <b>bold</b> method is called with no arguments, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"b"</code>, <code>""</code>, <code>""</code>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.fixed">
        <h4 id="sec-B.2.3.6" title="B.2.3.6"> String.prototype.fixed ()</h4><p class="normalbefore">When the <b>fixed</b> method is called with no arguments, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"tt"</code>, <code>""</code>, <code>""</code>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.fontcolor">
        <h4 id="sec-B.2.3.7" title="B.2.3.7"> String.prototype.fontcolor ( color )</h4><p class="normalbefore">When the <b>fontcolor</b> method is called with argument <var>color</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"font"</code>, <code>"color"</code>,
              <i>color</i>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.fontsize">
        <h4 id="sec-B.2.3.8" title="B.2.3.8"> String.prototype.fontsize ( size )</h4><p class="normalbefore">When the <b>fontsize</b> method is called with argument <var>size</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"font"</code>, <code>"size"</code>,
              <i>size</i>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.italics">
        <h4 id="sec-B.2.3.9" title="B.2.3.9"> String.prototype.italics ()</h4><p class="normalbefore">When the <b>italics</b> method is called with no arguments, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"i"</code>, <code>""</code>, <code>""</code>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.link">
        <h4 id="sec-B.2.3.10" title="B.2.3.10"> String.prototype.link ( url )</h4><p class="normalbefore">When the <b>link</b> method is called with argument <var>url</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"a"</code>, <code>"href"</code>, <i>url</i>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.small">
        <h4 id="sec-B.2.3.11" title="B.2.3.11"> String.prototype.small ()</h4><p class="normalbefore">When the <b>small</b> method is called with no arguments, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"small"</code>, <code>""</code>,
              <code>""</code>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.strike">
        <h4 id="sec-B.2.3.12" title="B.2.3.12"> String.prototype.strike ()</h4><p class="normalbefore">When the <b>strike</b> method is called with no arguments, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"strike"</code>, <code>""</code>,
              <code>""</code>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.sub">
        <h4 id="sec-B.2.3.13" title="B.2.3.13"> String.prototype.sub ()</h4><p class="normalbefore">When the <b>sub</b> method is called with no arguments, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"sub"</code>, <code>""</code>,
              <code>""</code>).</li>
        </ol>
      </section>

      <section id="sec-string.prototype.sup">
        <h4 id="sec-B.2.3.14" title="B.2.3.14"> String.prototype.sup ()</h4><p class="normalbefore">When the <b>sup</b> method is called with no arguments, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createhtml">CreateHTML</a>(<i>S</i>, <code>"sup"</code>, <code>""</code>,
              <code>""</code>).</li>
        </ol>
      </section>
    </section>

    <section id="sec-additional-properties-of-the-date.prototype-object">
      <div class="front">
        <h3 id="sec-B.2.4" title="B.2.4"> Additional Properties of the Date.prototype Object</h3></div>

      <section id="sec-date.prototype.getyear">
        <h4 id="sec-B.2.4.1" title="B.2.4.1"> Date.prototype.getYear ( )</h4><div class="note">
          <p><span class="nh">NOTE</span> The <code>getFullYear</code> method is preferred for nearly all purposes, because it
          avoids the &ldquo;year 2000 problem.&rdquo;</p>
        </div>

        <p class="normalbefore">When the <b>getYear</b> method is called with no arguments, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="sec-numbers-and-dates#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="sec-numbers-and-dates#sec-year-number">YearFromTime</a>(<a href="sec-numbers-and-dates#sec-localtime">LocalTime</a>(<i>t</i>)) &minus;
              1900.</li>
        </ol>
      </section>

      <section id="sec-date.prototype.setyear">
        <h4 id="sec-B.2.4.2" title="B.2.4.2"> Date.prototype.setYear (year)</h4><div class="note">
          <p><span class="nh">NOTE</span> The <code>setFullYear</code> method is preferred for nearly all purposes, because it
          avoids the &ldquo;year 2000 problem.&rdquo;</p>
        </div>

        <p class="normalbefore">When the <b>setYear</b> method is called with one argument <var>year</var>, the following steps
        are taken:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="sec-numbers-and-dates#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, let <i>t</i> be <b>+0</b>; otherwise, let <i>t</i> be <a href="sec-numbers-and-dates#sec-localtime">LocalTime</a>(<i>t</i>).</li>
          <li>Let <i>y</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>year</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>y</i>).</li>
          <li>If <i>y</i> is <b>NaN</b>, set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> of this Date object to <b>NaN</b> and return <b>NaN</b>.</li>
          <li>If <i>y</i> is not <b>NaN</b> and 0 &le; <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>y</i>) &le; 99, let <i>yyyy</i>
              be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>y</i>) +&nbsp;1900.</li>
          <li>Else, let <i>yyyy</i> be <i>y</i>.</li>
          <li>Let <i>d</i> be <a href="sec-numbers-and-dates#sec-makeday">MakeDay</a>(<i>yyyy</i>, <a href="sec-numbers-and-dates#sec-month-number">MonthFromTime</a>(<i>t</i>), <a href="sec-numbers-and-dates#sec-date-number">DateFromTime</a>(<i>t</i>)).</li>
          <li>Let <i>date</i> be <a href="sec-numbers-and-dates#sec-utc-t">UTC</a>(<a href="sec-numbers-and-dates#sec-makedate">MakeDate</a>(<i>d</i>, <a href="sec-numbers-and-dates#sec-day-number-and-time-within-day">TimeWithinDay</a>(<i>t</i>))).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <a href="sec-numbers-and-dates#sec-timeclip">TimeClip</a>(<i>date</i>).</li>
          <li>Return the value of the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
              this Date object.</li>
        </ol>
      </section>

      <section id="sec-date.prototype.togmtstring">
        <h4 id="sec-B.2.4.3" title="B.2.4.3"> Date.prototype.toGMTString ( )</h4><div class="note">
          <p><span class="nh">NOTE</span> The property <code>toUTCString</code> is preferred. The <code>toGMTString</code>
          property is provided principally for compatibility with old code. It is recommended that the <code>toUTCString</code>
          property be used in new ECMAScript code.</p>
        </div>

        <p>The function object that is the initial value of <code>Date.prototype.toGMTString</code> is the same function object
        that is the initial value of <code><a href="sec-numbers-and-dates#sec-date.prototype.toutcstring">Date.prototype.toUTCString</a></code>.</p>
      </section>
    </section>

    <section id="sec-additional-properties-of-the-regexp.prototype-object">
      <div class="front">
        <h3 id="sec-B.2.5" title="B.2.5"> Additional Properties of the RegExp.prototype Object</h3></div>

      <section id="sec-regexp.prototype.compile">
        <h4 id="sec-B.2.5.1" title="B.2.5.1"> RegExp.prototype.compile (pattern, flags )</h4><p class="normalbefore">When the <b>compile</b> method is called with arguments <i>pattern</i> and <i>flags</i>, the
        following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object or <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is Object and <i>O</i> does not have a
              [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, then
            <ol class="block">
              <li>Throw a <b>TypeError</b> exception.</li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>pattern</i>) is Object and <i>pattern</i> has a
              [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, then
            <ol class="block">
              <li>If <i>flags</i> is not <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
              <li>Let <i>P</i> be the value of <i>pattern&rsquo;s</i> [[OriginalSource]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
              <li>Let <i>F</i> be the value of <i>pattern&rsquo;s</i> [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>P</i> be <i>pattern</i>.</li>
              <li>Let <i>F</i> be <i>flags</i>.</li>
            </ol>
          </li>
          <li>Return <a href="sec-text-processing#sec-regexpinitialize">RegExpInitialize</a>(<i>O,</i> <i>P</i>, <i>F</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>compile</code> method completely reinitializes the <b>this</b> object RegExp
          with a new pattern and flags. An implementation may interpret use of this method as an assertion that the resulting
          RegExp object will be used multiple times and hence is a candidate for extra optimization.</p>
        </div>
      </section>
    </section>
  </section>

  <section id="sec-other-additional-features">
    <div class="front">
      <h2 id="sec-B.3" title="B.3">
          Other Additional Features</h2></div>

    <section id="sec-__proto__-property-names-in-object-initializers">
      <h3 id="sec-B.3.1" title="B.3.1"> __proto__ Property Names in Object Initializers</h3><p>The following Early Error rule is added to those in <a href="sec-ecmascript-language-expressions#sec-object-initializer-static-semantics-early-errors">12.2.6.1</a>:</p>

      <p><span class="prod"><span class="nt">ObjectLiteral</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">PropertyDefinitionList</span> <code class="t">}ObjectLiteral</code> <code class="t">:</code> <code class="t">{</code> <span class="nt">PropertyDefinitionList</span> <code class="t">,</code> <code class="t">}</code></span></p>

      <ul>
        <li>
          <p>It is a Syntax Error if <span style="font-family: Times New Roman">PropertyNameList</span> of <span class="nt">PropertyDefinitionList</span> contains any duplicate entries for <code>"__proto__"</code> and at least two of
          those entries were obtained from productions of the form  <span class="prod"><span class="nt">PropertyDefinition</span>
          <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">AssignmentExpression</span></span> .</p>
        </li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE</span> The <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> returned by
        PropertyNameList does not include string literal property names defined as using a <i><span style="font-family: Times New         Roman">ComputedPropertyName</span>.</i></p>
      </div>

      <p class="normalbefore">In <a href="sec-ecmascript-language-expressions#sec-object-initializer-runtime-semantics-propertydefinitionevaluation">12.2.6.9</a> the
      PropertyDefinitionEvaluation algorithm for the production<br /><span class="prod"><span class="nt">PropertyDefinition</span>
      <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">AssignmentExpression</span></span><br />is replaced with the following definition:</p>

      <div class="gp prod"><span class="nt">PropertyDefinition</span> <span class="geq">:</span> <span class="nt">PropertyName</span> <code class="t">:</code> <span class="nt">AssignmentExpression</span></div>
      <ol class="proc">
        <li>Let <i>propKey</i> be the result of evaluating <i>PropertyName</i>.</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propKey</i>).</li>
        <li>Let <i>exprValueRef</i> be the result of evaluating <i>AssignmentExpression</i>.</li>
        <li>Let <i>propValue</i> be <a href="sec-ecmascript-data-types-and-values#sec-getvalue">GetValue</a>(<i>exprValueRef</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propValue</i>).</li>
        <li>If <i>propKey</i> is the String value <code>"__proto__"</code> and if IsComputedPropertyKey(<i>propKey</i>) is
            <b>false</b>, then
          <ol class="block">
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>propValue</i>) is either Object or Null, then
              <ol class="block">
                <li>Return <i>object</i>.[[SetPrototypeOf]](<i>propValue</i>).</li>
              </ol>
            </li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                 sans-serif">empty</span>).</li>
          </ol>
        </li>
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
    </section>

    <section id="sec-labelled-function-declarations">
      <h3 id="sec-B.3.2" title="B.3.2"> Labelled Function Declarations</h3><p>Prior to ECMAScript 2015, the specification of <span class="nt">LabelledStatement</span> did not allow for the
      association of a statement label with a <span class="nt">FunctionDeclaration</span>. However, a labelled <span class="nt">FunctionDeclaration</span> was an allowable extension for non-<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict code</a> and
      most browser-hosted ECMAScript implementations supported that extension. In ECMAScript 2015, the grammar productions for
      <span class="nt">LabelledStatement</span> permits use of <span class="nt">FunctionDeclaration</span> as a <span class="nt">LabelledItem</span> but <a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements-static-semantics-early-errors">13.13.1</a> includes an
      Early Error rule that produces a Syntax Error if that occurs. For web browser compatibility, that rule is modified with the
      addition of the underlined text:</p>

      <div class="gp prod"><span class="nt">LabelledItem</span> <span class="geq">:</span> <span class="nt">FunctionDeclaration</span></div>
      <ul>
        <li>It is a Syntax Error if any strict mode source code matches this rule.</li>
      </ul>
    </section>

    <section id="sec-block-level-function-declarations-web-legacy-compatibility-semantics">
      <h3 id="sec-B.3.3" title="B.3.3"> Block-Level Function Declarations Web Legacy Compatibility Semantics</h3><p>Prior to ECMAScript 2015, the ECMAScript specification did not define the occurrence of a <span class="nt">FunctionDeclaration</span> as an element of a <span class="nt">Block</span> statement&rsquo;s <span class="nt">StatementList</span>. However, support for that form of <span class="nt">FunctionDeclaration</span> was an
      allowable extension and most browser-hosted ECMAScript implementations permitted them. Unfortunately, the semantics of such
      declarations differ among those implementations. Because of these semantic differences, existing web ECMAScript code that
      uses <span class="nt">Block</span> level function declarations is only portable among browser implementation if the usage
      only depends upon the semantic intersection of all of the browser implementations for such declarations. The following are
      the use cases that fall within that intersection semantics:</p>

      <ol class="proc">
        <li>A function is declared and only referenced within a single block
          <ul>
            <li>
              <p>A <span class="nt">FunctionDeclaration</span> whose <span class="nt">BindingIdentifier</span> is the name
              <var>f</var> occurs exactly once within the function code of an enclosing function <var>g</var> and that declaration
              is nested within a <span class="nt">Block</span>.</p>
            </li>

            <li>
              <p>No other declaration of <var>f</var> that is not a <code>var</code> declaration occurs within the function code
              of <var>g</var></p>
            </li>

            <li>
              <p>All occurrences of <var>f</var> as an <span class="nt">IdentifierReference</span> are within the <span class="nt">StatementList</span> of the <span class="nt">Block</span> containing the declaration of <var>f</var>.</p>
            </li>
          </ul>
        </li>
        <li>A function is declared and possibly used within a single <span class="nt">Block</span> but also referenced by an inner
            function definition that is not contained within that same <span class="nt">Block</span>.
          <ul>
            <li>
              <p>A <span class="nt">FunctionDeclaration</span> whose <span class="nt">BindingIdentifier</span> is the name
              <var>f</var> occurs exactly once within the function code of an enclosing function <var>g</var> and that declaration
              is nested within a <span class="nt">Block</span>.</p>
            </li>

            <li>
              <p>No other declaration of <var>f</var> that is not a <code>var</code> declaration occurs within the function code
              of <var>g</var></p>
            </li>

            <li>
              <p>There may be occurrences of <var>f</var> as an <span class="nt">IdentifierReference</span> within the <span class="nt">StatementList</span> of the <span class="nt">Block</span> containing the declaration of <var>f</var>.</p>
            </li>

            <li>
              <p>There is at least one occurrence of <var>f</var> as an <span class="nt">IdentifierReference</span> within the
              function code of <var>g</var> that lexically follows the <span class="nt">Block</span> containing the declaration of
              <var>f</var>.</p>
            </li>
          </ul>
        </li>
        <li>A function is declared and possibly used within a single block but also referenced within subsequent blocks.
          <ul>
            <li>
              <p>A <span class="nt">FunctionDeclaration</span> whose <span class="nt">BindingIdentifier</span> is the name
              <var>f</var> occurs exactly once within the function code of an enclosing function <var>g</var> and that declaration
              is nested within a <span class="nt">Block</span>.</p>
            </li>

            <li>
              <p>No other declaration of <var>f</var> that is not a <code>var</code> declaration occurs within the function code
              of <var>g</var></p>
            </li>

            <li>
              <p>There may be occurrences of <var>f</var> as an <span class="nt">IdentifierReference</span> within the <span class="nt">StatementList</span> of the <span class="nt">Block</span> containing the declaration of <var>f</var>.</p>
            </li>

            <li>
              <p>There is at least one occurrence of <var>f</var> as an <span class="nt">IdentifierReference</span> within another
              function <var>h</var> that is nested within <var>g</var> and no other declaration of <var>f</var> shadows the
              references to <var>f</var> from within <var>h</var>.</p>
            </li>

            <li>
              <p>All invocations of <i>h</i> occur after the declaration of <i>f</i> has been evaluated.</p>
            </li>
          </ul>
        </li>
      </ol>

      <p>The first use case is interoperable with the semantics of <span class="nt">Block</span> level function declarations
      provided by ECMAScript 2015. Any pre-existing ECMAScript code that employees that use case will operate using the Block
      level function declarations semantics defined by clauses 9, 13, and 14 of this specification.</p>

      <p>ECMAScript 2015 interoperability for the second and third use cases requires the following extensions to the <a href="sec-ordinary-and-exotic-objects-behaviours">clause 9</a> and <a href="sec-ecmascript-language-functions-and-classes">clause 14</a> semantics. During <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functiondeclarationinstantiation">FunctionDeclarationInstantiation</a> (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-functiondeclarationinstantiation">9.2.12</a>) the following steps are performed in place of step 29:</p>

      <ol class="proc">
        <li>If <i>strict</i> is <b>false</b>, then
          <ol class="block">
            <li>For each <i>FunctionDeclaration</i> <i>f</i> in <i>varDeclarations</i> that is directly contained in the
                <i>StatementList</i> of a <i>Block</i>, <i>CaseClause</i>, or <i>DefaultClause,</i>
              <ol class="block">
                <li>Let <i>F</i> be StringValue of the <i>BindingIdentifier</i> of <i>FunctionDeclaration</i> <i>f</i>.</li>
                <li>If replacing the <i>FunctionDeclaration</i> <i>f</i> with a <i>VariableStatement</i> that has <i>F</i> as a
                    <i>BindingIdentifier</i> would not produce any Early Errors for <i>func</i> and <i>F</i> is not an element of
                    BoundNames of <i>argumentsList</i>, then
                  <ol class="block">
                    <li><span style="font-family: sans-serif">NOTE&#x9;A var binding for</span> <i>F</i> <span style="font-family:                         sans-serif">is only instantiated here if it is neither a VarDeclaredName, the name of a formal parameter,
                        or another</span> <i>FunctionDeclarations</i>.</li>
                    <li>If <i>instantiatedVarNames</i> does not contain <i>F</i>, then
                      <ol class="block">
                        <li>Let <i>status</i> be <i>varEnvRec.</i>CreateMutableBinding(<i>F</i>).</li>
                        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                        <li>Perform <i>varEnvRec.</i>InitializeBinding(<i>F</i>, <b>undefined</b>).</li>
                        <li>Append <i>F</i> to <i>instantiatedVarNames</i>.</li>
                      </ol>
                    </li>
                    <li>When the <i>FunctionDeclaration</i> <i>f</i> is evaluated, perform the following steps in place of the
                        <i>FunctionDeclaration</i> Evaluation algorithm provided in <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-runtime-semantics-evaluation">14.1.20</a>:
                      <ol class="nested proc">
                        <li>Let <i>fenv</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a>.</li>
                        <li>Let <i>benv</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a>.</li>
                        <li>Let <i>fobj</i> be <i>benv</i>.GetBindingValue(<i>F</i>, <b>false</b>).</li>
                        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fobj</i>).</li>
                        <li>Let <i>status</i> be <i>fenv</i>.SetMutableBinding(<i>F</i>, <i>fobj</i>, <b>false</b>).</li>
                        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family:                             sans-serif">empty</span>).</li>
                      </ol>
                    </li>
                  </ol>
                </li>
              </ol>
            </li>
          </ol>
        </li>
      </ol>

      <p>If an ECMAScript implementation has a mechanism for reporting diagnostic warning messages, a warning should be produced
      for each function whose function code contains a <i>FunctionDeclaration</i> for which steps 1.a.ii.1-3 will be
      performed.</p>
    </section>

    <section id="sec-functiondeclarations-in-ifstatement-statement-clauses">
      <h3 id="sec-B.3.4" title="B.3.4"> FunctionDeclarations in IfStatement Statement Clauses</h3><p class="normalbefore">The following rules for <span class="nt">IfStatement</span> augment those in <a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement">13.6</a>:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">IfStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">FunctionDeclaration</span><sub class="g-params">[?Yield]</sub> <code class="t">else</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
        <div class="rhs"><code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub> <code class="t">else</code> <span class="nt">FunctionDeclaration</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">FunctionDeclaration</span><sub class="g-params">[?Yield]</sub> <code class="t">else</code> <span class="nt">FunctionDeclaration</span><sub class="g-params">[?Yield]</sub></div>
        <div class="rhs"><code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">FunctionDeclaration</span><sub class="g-params">[?Yield]</sub></div>
      </div>

      <p>The above rules are only applied when parsing code that is not <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>. If
      any such code is match by one of these rules subsequent processing of that code takes places as if each matching occurrence
      of <span class="nt">FunctionDeclaration</span><sub>[?Yield]</sub> was the sole <span class="nt">StatementListItem</span> of
      a <span class="nt">BlockStatement</span> occupying that position in the source code. The semantics of such a synthetic <span class="nt">BlockStatement</span> includes the web legacy compatibility semantics specified in <a href="#sec-block-level-function-declarations-web-legacy-compatibility-semantics">B.3.3</a>.</p>
    </section>

    <section id="sec-variablestatements-in-catch-blocks">
      <h3 id="sec-B.3.5" title="B.3.5"> VariableStatements in Catch blocks</h3><p>The content of <a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement-static-semantics-early-errors">subclause 13.15.1</a> is replaced with the
      following:</p>

      <div class="gp prod"><span class="nt">Catch</span> <span class="geq">:</span> <code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span> <code class="t">)</code> <span class="nt">Block</span></div>
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
          VarDeclaredNames of <var>Block, unless that element is only bound by a VariableStatement or the VariableDeclarationList
          of a for statement, or the ForBinding of a for-in statement</var>.</p>
        </li>
      </ul>

      <div class="note">
        <p><span class="nh">NOTE</span> The <span class="nt">Block</span> of a <span class="nt">Catch</span> clause may contain
        <code>var</code> declarations that bind a name that is also bound by the <span class="nt">CatchParameter</span>. At
        runtime, such bindings are instantiated in the VariableDeclarationEnvironment. They do not shadow the same-named bindings
        introduced by the <span class="nt">CatchParameter</span> and hence the <span class="nt">Initializer</span> for such
        <code>var</code> declarations will assign to the corresponding catch parameter rather than the <code>var</code> binding.
        The relaxation of the normal static semantic rule does not apply to names only bound by for-of statements.</p>
      </div>

      <p>This modified behaviour also applies to <code>var</code> and <code>function</code> declarations introduced by direct
      evals contained within the <span class="nt">Block</span> of a <span class="nt">Catch</span> clause. This change is
      accomplished by modify the algorithm of <a href="sec-global-object#sec-evaldeclarationinstantiation">18.2.1.2</a> as follows:</p>

      <p class="normalbefore">Step 5.d.ii.2.a.i is replaced by:</p>

      <p class="special2">i.&#x9;If <i>thisEnvRec</i> is not the <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> for a
      <i>Catch</i> clause, throw a <b>SyntaxError</b> exception.</p>

      <p class="special2">ii.&#x9;If <i>name</i> is <i>bound by any syntactic form other than a FunctionDeclaration, a
      VariableStatement, the VariableDeclarationList of a for statement, or the ForBinding of a for-in statement</i>, throw a
      <b>SyntaxError</b> exception.</p>
    </section>
  </section>
</section>

