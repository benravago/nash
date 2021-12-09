<section id="sec-grammar-summary">
  <div class="front">
    <h1 id="sec-A" title="Annex&nbsp;A"> </h1></div>

  <section id="sec-lexical-grammar">
    <h2 id="sec-A.1" title="A.1"> Lexical
        Grammar</h2><div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-source-code#sec-source-text">See 10.1</a></div>
      <div class="lhs"><span class="nt">SourceCharacter</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="gprose">any Unicode code point</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar">See clause 11</a></div>
      <div class="lhs"><span class="nt">InputElementDiv</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">WhiteSpace</span></div>
      <div class="rhs"><span class="nt">LineTerminator</span></div>
      <div class="rhs"><span class="nt">Comment</span></div>
      <div class="rhs"><span class="nt">CommonToken</span></div>
      <div class="rhs"><span class="nt">DivPunctuator</span></div>
      <div class="rhs"><span class="nt">RightBracePunctuator</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar">See clause 11</a></div>
      <div class="lhs"><span class="nt">InputElementRegExp</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">WhiteSpace</span></div>
      <div class="rhs"><span class="nt">LineTerminator</span></div>
      <div class="rhs"><span class="nt">Comment</span></div>
      <div class="rhs"><span class="nt">CommonToken</span></div>
      <div class="rhs"><span class="nt">RightBracePunctuator</span></div>
      <div class="rhs"><span class="nt">RegularExpressionLiteral</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar">See clause 11</a></div>
      <div class="lhs"><span class="nt">InputElementRegExpOrTemplateTail</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">WhiteSpace</span></div>
      <div class="rhs"><span class="nt">LineTerminator</span></div>
      <div class="rhs"><span class="nt">Comment</span></div>
      <div class="rhs"><span class="nt">CommonToken</span></div>
      <div class="rhs"><span class="nt">RegularExpressionLiteral</span></div>
      <div class="rhs"><span class="nt">TemplateSubstitutionTail</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar">See clause 11</a></div>
      <div class="lhs"><span class="nt">InputElementTemplateTail</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">WhiteSpace</span></div>
      <div class="rhs"><span class="nt">LineTerminator</span></div>
      <div class="rhs"><span class="nt">Comment</span></div>
      <div class="rhs"><span class="nt">CommonToken</span></div>
      <div class="rhs"><span class="nt">DivPunctuator</span></div>
      <div class="rhs"><span class="nt">TemplateSubstitutionTail</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-white-space">See 11.2</a></div>
      <div class="lhs"><span class="nt">WhiteSpace</span> <span class="geq">::</span> </div>
      <div class="rhs">&lt;TAB&gt;</div>
      <div class="rhs">&lt;VT&gt;</div>
      <div class="rhs">&lt;FF&gt;</div>
      <div class="rhs">&lt;SP&gt;</div>
      <div class="rhs">&lt;NBSP&gt;</div>
      <div class="rhs">&lt;ZWNBSP&gt;</div>
      <div class="rhs">&lt;USP&gt;</div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-line-terminators">See 11.3</a></div>
      <div class="lhs"><span class="nt">LineTerminator</span> <span class="geq">::</span> </div>
      <div class="rhs">&lt;LF&gt;</div>
      <div class="rhs">&lt;CR&gt;</div>
      <div class="rhs">&lt;LS&gt;</div>
      <div class="rhs">&lt;PS&gt;</div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-line-terminators">See 11.3</a></div>
      <div class="lhs"><span class="nt">LineTerminatorSequence</span> <span class="geq">::</span> </div>
      <div class="rhs">&lt;LF&gt;</div>
      <div class="rhs">&lt;CR&gt; <span class="grhsannot">[lookahead &ne; &lt;LF&gt; ]</span></div>
      <div class="rhs">&lt;LS&gt;</div>
      <div class="rhs">&lt;PS&gt;</div>
      <div class="rhs">&lt;CR&gt; &lt;LF&gt;</div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-comments">See 11.4</a></div>
      <div class="lhs"><span class="nt">Comment</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">MultiLineComment</span></div>
      <div class="rhs"><span class="nt">SingleLineComment</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-comments">See 11.4</a></div>
      <div class="lhs"><span class="nt">MultiLineComment</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">/*</code> <span class="nt">MultiLineCommentChars</span><sub class="g-opt">opt</sub> <code class="t">*/</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-comments">See 11.4</a></div>
      <div class="lhs"><span class="nt">MultiLineCommentChars</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">MultiLineNotAsteriskChar</span> <span class="nt">MultiLineCommentChars</span><sub class="g-opt">opt</sub></div>
      <div class="rhs"><code class="t">*</code> <span class="nt">PostAsteriskCommentChars</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-comments">See 11.4</a></div>
      <div class="lhs"><span class="nt">PostAsteriskCommentChars</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">MultiLineNotForwardSlashOrAsteriskChar</span> <span class="nt">MultiLineCommentChars</span><sub class="g-opt">opt</sub></div>
      <div class="rhs"><code class="t">*</code> <span class="nt">PostAsteriskCommentChars</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-comments">See 11.4</a></div>
      <div class="lhs"><span class="nt">MultiLineNotAsteriskChar</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <code class="t">*</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-comments">See 11.4</a></div>
      <div class="lhs"><span class="nt">MultiLineNotForwardSlashOrAsteriskChar</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">/</code> <span class="grhsmod">or</span> <code class="t">*</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-comments">See 11.4</a></div>
      <div class="lhs"><span class="nt">SingleLineComment</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">//</code> <span class="nt">SingleLineCommentChars</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-comments">See 11.4</a></div>
      <div class="lhs"><span class="nt">SingleLineCommentChars</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SingleLineCommentChar</span> <span class="nt">SingleLineCommentChars</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-comments">See 11.4</a></div>
      <div class="lhs"><span class="nt">SingleLineCommentChar</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <span class="nt">LineTerminator</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-tokens">See 11.5</a></div>
      <div class="lhs"><span class="nt">CommonToken</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">IdentifierName</span></div>
      <div class="rhs"><span class="nt">Punctuator</span></div>
      <div class="rhs"><span class="nt">NumericLiteral</span></div>
      <div class="rhs"><span class="nt">StringLiteral</span></div>
      <div class="rhs"><span class="nt">Template</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-names-and-keywords">See 11.6</a></div>
      <div class="lhs"><span class="nt">IdentifierName</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">IdentifierStart</span></div>
      <div class="rhs"><span class="nt">IdentifierName</span> <span class="nt">IdentifierPart</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-names-and-keywords">See 11.6</a></div>
      <div class="lhs"><span class="nt">IdentifierStart</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">UnicodeIDStart</span></div>
      <div class="rhs"><code class="t">$</code></div>
      <div class="rhs"><code class="t">_</code></div>
      <div class="rhs"><code class="t">\</code> <span class="nt">UnicodeEscapeSequence</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-names-and-keywords">See 11.6</a></div>
      <div class="lhs"><span class="nt">IdentifierPart</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">UnicodeIDContinue</span></div>
      <div class="rhs"><code class="t">$</code></div>
      <div class="rhs"><code class="t">_</code></div>
      <div class="rhs"><code class="t">\</code> <span class="nt">UnicodeEscapeSequence</span></div>
      <div class="rhs">&lt;ZWNJ&gt;</div>
      <div class="rhs">&lt;ZWJ&gt;</div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-names-and-keywords">See 11.6</a></div>
      <div class="lhs"><span class="nt">UnicodeIDStart</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="gprose">any Unicode code point with the Unicode property &ldquo;ID_Start&rdquo; or &ldquo;Other_ID_Start&rdquo;</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-names-and-keywords">See 11.6</a></div>
      <div class="lhs"><span class="nt">UnicodeIDContinue</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="gprose">any Unicode code point with the Unicode property &ldquo;ID_Continue&rdquo;, &ldquo;Other_ID_Continue&rdquo;, or &ldquo;Other_ID_Start&rdquo;</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-reserved-words">See 11.6.2</a></div>
      <div class="lhs"><span class="nt">ReservedWord</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">Keyword</span></div>
      <div class="rhs"><span class="nt">FutureReservedWord</span></div>
      <div class="rhs"><span class="nt">NullLiteral</span></div>
      <div class="rhs"><span class="nt">BooleanLiteral</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-keywords">See 11.6.2.1</a></div>
      <div class="lhs"><span class="nt">Keyword</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
    </div>

    <figure>
      <table class="lightweight-table">
        <tr>
          <td><code>break</code></td>
          <td><code>do</code></td>
          <td><code>in</code></td>
          <td><code>typeof</code></td>
        </tr>
        <tr>
          <td><code>case</code></td>
          <td><code>else</code></td>
          <td><code>instanceof</code></td>
          <td><code>var</code></td>
        </tr>
        <tr>
          <td><code>catch</code></td>
          <td><code>export</code></td>
          <td><code>new</code></td>
          <td><code>void</code></td>
        </tr>
        <tr>
          <td><code>class</code></td>
          <td><code>extends</code></td>
          <td><code>return</code></td>
          <td><code>while</code></td>
        </tr>
        <tr>
          <td><code>const</code></td>
          <td><code>finally</code></td>
          <td><code>super</code></td>
          <td><code>with</code></td>
        </tr>
        <tr>
          <td><code>continue</code></td>
          <td><code>for</code></td>
          <td><code>switch</code></td>
          <td><code>yield</code></td>
        </tr>
        <tr>
          <td><code>debugger</code></td>
          <td><code>function</code></td>
          <td><code>this</code></td>
          <td />
        </tr>
        <tr>
          <td><code>default</code></td>
          <td><code>if</code></td>
          <td><code>throw</code></td>
          <td />
        </tr>
        <tr>
          <td><code>delete</code></td>
          <td><code>import</code></td>
          <td><code>try</code></td>
          <td />
        </tr>
      </table>
    </figure>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-future-reserved-words">See 11.6.2.2</a></div>
      <div class="lhs"><span class="nt">FutureReservedWord</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">enum</code></div>
      <div class="rhs"><code class="t">await</code></div>
    </div>

    <p><code>await</code> is only treated as a <span class="nt">FutureReservedWord</span> when <span class="nt">Module</span> is
    the goal symbol of the syntactic grammar.</p>

    <p>The following tokens are also considered to be <span class="nt">FutureReservedWords</span> when parsing <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> (<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">see 10.2.1</a>).</p>

    <figure>
      <table class="lightweight-table">
        <tr>
          <td><code>implements</code></td>
          <td><code>package</code></td>
          <td><code>protected</code></td>
          <td />
        </tr>
        <tr>
          <td><code>interface</code></td>
          <td><code>private</code></td>
          <td><code>public</code></td>
          <td />
        </tr>
      </table>
    </figure>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-punctuators">See 11.7</a></div>
      <div class="lhs"><span class="nt">Punctuator</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
    </div>

    <figure>
      <table class="lightweight-table">
        <tr>
          <td><code>{</code></td>
          <td><code>}</code></td>
          <td><code>(</code></td>
          <td><code>)</code></td>
          <td><code>[</code></td>
          <td><code>]</code></td>
        </tr>
        <tr>
          <td><code>.</code></td>
          <td><code>;</code></td>
          <td><code>,</code></td>
          <td><code>&lt;</code></td>
          <td><code>&gt;</code></td>
          <td><code>&lt;=</code></td>
        </tr>
        <tr>
          <td><code>&gt;=</code></td>
          <td><code>==</code></td>
          <td><code>!=</code></td>
          <td><code>===</code></td>
          <td><code>!==</code></td>
          <td />
        </tr>
        <tr>
          <td><code>+</code></td>
          <td><code>-</code></td>
          <td><code>*</code></td>
          <td><code>%</code></td>
          <td><code>++</code></td>
          <td><code>--</code></td>
        </tr>
        <tr>
          <td><code>&lt;&lt;</code></td>
          <td><code>&gt;&gt;</code></td>
          <td><code>&gt;&gt;&gt;</code></td>
          <td><code>&amp;</code></td>
          <td><code>|</code></td>
          <td><code>^</code></td>
        </tr>
        <tr>
          <td><code>!</code></td>
          <td><code>~</code></td>
          <td><code>&amp;&amp;</code></td>
          <td><code>||</code></td>
          <td><code>?</code></td>
          <td><code>:</code></td>
        </tr>
        <tr>
          <td><code>=</code></td>
          <td><code>+=</code></td>
          <td><code>-=</code></td>
          <td><code>*=</code></td>
          <td><code>%=</code></td>
          <td><code>&lt;&lt;=</code></td>
        </tr>
        <tr>
          <td><code>&gt;&gt;=</code></td>
          <td><code>&gt;&gt;&gt;=</code></td>
          <td><code>&amp;=</code></td>
          <td><code>|=</code></td>
          <td><code>^=</code></td>
          <td><code>=&gt;</code></td>
        </tr>
      </table>
    </figure>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-punctuators">See 11.7</a></div>
      <div class="lhs"><span class="nt">DivPunctuator</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">/</code></div>
      <div class="rhs"><code class="t">/=</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-punctuators">See 11.7</a></div>
      <div class="lhs"><span class="nt">RightBracePunctuator</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-null-literals">See 11.8.1</a></div>
      <div class="lhs"><span class="nt">NullLiteral</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">null</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-boolean-literals">See 11.8.2</a></div>
      <div class="lhs"><span class="nt">BooleanLiteral</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">true</code></div>
      <div class="rhs"><code class="t">false</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">NumericLiteral</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">DecimalLiteral</span></div>
      <div class="rhs"><span class="nt">BinaryIntegerLiteral</span></div>
      <div class="rhs"><span class="nt">OctalIntegerLiteral</span></div>
      <div class="rhs"><span class="nt">HexIntegerLiteral</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">DecimalLiteral</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">DecimalIntegerLiteral</span> <code class="t">.</code> <span class="nt">DecimalDigits</span><sub class="g-opt">opt</sub> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
      <div class="rhs"><code class="t">.</code> <span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
      <div class="rhs"><span class="nt">DecimalIntegerLiteral</span> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">DecimalIntegerLiteral</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">0</code></div>
      <div class="rhs"><span class="nt">NonZeroDigit</span> <span class="nt">DecimalDigits</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">DecimalDigits</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">DecimalDigit</span></div>
      <div class="rhs"><span class="nt">DecimalDigits</span> <span class="nt">DecimalDigit</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">NonZeroDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">ExponentPart</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">ExponentIndicator</span> <span class="nt">SignedInteger</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">ExponentIndicator</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">e</code> <code class="t">E</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">SignedInteger</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">DecimalDigits</span></div>
      <div class="rhs"><code class="t">+</code> <span class="nt">DecimalDigits</span></div>
      <div class="rhs"><code class="t">-</code> <span class="nt">DecimalDigits</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">BinaryIntegerLiteral</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">0b</code> <span class="nt">BinaryDigits</span></div>
      <div class="rhs"><code class="t">0B</code> <span class="nt">BinaryDigits</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">BinaryDigits</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">BinaryDigit</span></div>
      <div class="rhs"><span class="nt">BinaryDigits</span> <span class="nt">BinaryDigit</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">BinaryDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">0</code> <code class="t">1</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">OctalIntegerLiteral</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">0o</code> <span class="nt">OctalDigits</span></div>
      <div class="rhs"><code class="t">0O</code> <span class="nt">OctalDigits</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">OctalDigits</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">OctalDigit</span></div>
      <div class="rhs"><span class="nt">OctalDigits</span> <span class="nt">OctalDigit</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">OctalDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">HexIntegerLiteral</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">0x</code> <span class="nt">HexDigits</span></div>
      <div class="rhs"><code class="t">0X</code> <span class="nt">HexDigits</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">HexDigits</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">HexDigit</span></div>
      <div class="rhs"><span class="nt">HexDigits</span> <span class="nt">HexDigit</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">See 11.8.3</a></div>
      <div class="lhs"><span class="nt">HexDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code> <code class="t">a</code> <code class="t">b</code> <code class="t">c</code> <code class="t">d</code> <code class="t">e</code> <code class="t">f</code> <code class="t">A</code> <code class="t">B</code> <code class="t">C</code> <code class="t">D</code> <code class="t">E</code> <code class="t">F</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">StringLiteral</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">"</code> <span class="nt">DoubleStringCharacters</span><sub class="g-opt">opt</sub> <code class="t">"</code></div>
      <div class="rhs"><code class="t">'</code> <span class="nt">SingleStringCharacters</span><sub class="g-opt">opt</sub> <code class="t">'</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">DoubleStringCharacters</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">DoubleStringCharacter</span> <span class="nt">DoubleStringCharacters</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">SingleStringCharacters</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SingleStringCharacter</span> <span class="nt">SingleStringCharacters</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">DoubleStringCharacter</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">"</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></div>
      <div class="rhs"><code class="t">\</code> <span class="nt">EscapeSequence</span></div>
      <div class="rhs"><span class="nt">LineContinuation</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">SingleStringCharacter</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">'</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></div>
      <div class="rhs"><code class="t">\</code> <span class="nt">EscapeSequence</span></div>
      <div class="rhs"><span class="nt">LineContinuation</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">LineContinuation</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">\</code> <span class="nt">LineTerminatorSequence</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">EscapeSequence</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">CharacterEscapeSequence</span></div>
      <div class="rhs"><code class="t">0</code> <span class="grhsannot">[lookahead &notin; <span class="nt">DecimalDigit</span>]</span></div>
      <div class="rhs"><span class="nt">HexEscapeSequence</span></div>
      <div class="rhs"><span class="nt">UnicodeEscapeSequence</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">CharacterEscapeSequence</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SingleEscapeCharacter</span></div>
      <div class="rhs"><span class="nt">NonEscapeCharacter</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">SingleEscapeCharacter</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">'</code> <code class="t">"</code> <code class="t">\</code> <code class="t">b</code> <code class="t">f</code> <code class="t">n</code> <code class="t">r</code> <code class="t">t</code> <code class="t">v</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">NonEscapeCharacter</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <span class="nt">EscapeCharacter</span> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">EscapeCharacter</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SingleEscapeCharacter</span></div>
      <div class="rhs"><span class="nt">DecimalDigit</span></div>
      <div class="rhs"><code class="t">x</code></div>
      <div class="rhs"><code class="t">u</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">HexEscapeSequence</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">x</code> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">UnicodeEscapeSequence</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">u</code> <span class="nt">Hex4Digits</span></div>
      <div class="rhs"><code class="t">u{</code> <span class="nt">HexDigits</span> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-string-literals">See 11.8.4</a></div>
      <div class="lhs"><span class="nt">Hex4Digits</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">HexDigit</span> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionLiteral</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">/</code> <span class="nt">RegularExpressionBody</span> <code class="t">/</code> <span class="nt">RegularExpressionFlags</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionBody</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">RegularExpressionFirstChar</span> <span class="nt">RegularExpressionChars</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionChars</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="grhsannot">[empty]</span></div>
      <div class="rhs"><span class="nt">RegularExpressionChars</span> <span class="nt">RegularExpressionChar</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionFirstChar</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">RegularExpressionNonTerminator</span> <span class="grhsmod">but not one of</span> <code class="t">*</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">/</code> <span class="grhsmod">or</span> <code class="t">[</code></div>
      <div class="rhs"><span class="nt">RegularExpressionBackslashSequence</span></div>
      <div class="rhs"><span class="nt">RegularExpressionClass</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionChar</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">RegularExpressionNonTerminator</span> <span class="grhsmod">but not one of</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">/</code> <span class="grhsmod">or</span> <code class="t">[</code></div>
      <div class="rhs"><span class="nt">RegularExpressionBackslashSequence</span></div>
      <div class="rhs"><span class="nt">RegularExpressionClass</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionBackslashSequence</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">\</code> <span class="nt">RegularExpressionNonTerminator</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionNonTerminator</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <span class="nt">LineTerminator</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionClass</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">[</code> <span class="nt">RegularExpressionClassChars</span> <code class="t">]</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionClassChars</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="grhsannot">[empty]</span></div>
      <div class="rhs"><span class="nt">RegularExpressionClassChars</span> <span class="nt">RegularExpressionClassChar</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionClassChar</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">RegularExpressionNonTerminator</span> <span class="grhsmod">but not one of</span> <code class="t">]</code> <span class="grhsmod">or</span> <code class="t">\</code></div>
      <div class="rhs"><span class="nt">RegularExpressionBackslashSequence</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-literals-regular-expression-literals">See 11.8.5</a></div>
      <div class="lhs"><span class="nt">RegularExpressionFlags</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="grhsannot">[empty]</span></div>
      <div class="rhs"><span class="nt">RegularExpressionFlags</span> <span class="nt">IdentifierPart</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">See 11.8.6</a></div>
      <div class="lhs"><span class="nt">Template</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">NoSubstitutionTemplate</span></div>
      <div class="rhs"><span class="nt">TemplateHead</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">See 11.8.6</a></div>
      <div class="lhs"><span class="nt">NoSubstitutionTemplate</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">`</code> <span class="nt">TemplateCharacters</span><sub class="g-opt">opt</sub> <code class="t">`</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">See 11.8.6</a></div>
      <div class="lhs"><span class="nt">TemplateHead</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">`</code> <span class="nt">TemplateCharacters</span><sub class="g-opt">opt</sub> <code class="t">${</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">See 11.8.6</a></div>
      <div class="lhs"><span class="nt">TemplateSubstitutionTail</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">TemplateMiddle</span></div>
      <div class="rhs"><span class="nt">TemplateTail</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">See 11.8.6</a></div>
      <div class="lhs"><span class="nt">TemplateMiddle</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">}</code> <span class="nt">TemplateCharacters</span><sub class="g-opt">opt</sub> <code class="t">${</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">See 11.8.6</a></div>
      <div class="lhs"><span class="nt">TemplateTail</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">}</code> <span class="nt">TemplateCharacters</span><sub class="g-opt">opt</sub> <code class="t">`</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">See 11.8.6</a></div>
      <div class="lhs"><span class="nt">TemplateCharacters</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">TemplateCharacter</span> <span class="nt">TemplateCharacters</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-lexical-grammar#sec-template-literal-lexical-components">See 11.8.6</a></div>
      <div class="lhs"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">$</code> <span class="grhsannot">[lookahead &ne; { ]</span></div>
      <div class="rhs"><code class="t">\</code> <span class="nt">EscapeSequence</span></div>
      <div class="rhs"><span class="nt">LineContinuation</span></div>
      <div class="rhs"><span class="nt">LineTerminatorSequence</span></div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">`</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">$</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></div>
    </div>
  </section>

  <section id="sec-expressions">
    <h2 id="sec-A.2" title="A.2"> Expressions</h2><div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-identifiers">See 12.1</a></div>
      <div class="lhs"><span class="nt">IdentifierReference</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">Identifier</span></div>
      <div class="rhs"><span class="grhsannot">[~Yield]</span> <code class="t">yield</code></div>
    </div>

    <p><span class="nt">BindingIdentifier</span><sub>[Yield]</sub>  <b>:</b> &#x9;See <a href="sec-ecmascript-language-expressions#sec-identifiers">12.1</a></p>

    <p><span style="font-family: Times New Roman"><i>Identifier<br /></i></span>[~Yield]  <code>yield</code></p>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-identifiers">See 12.1</a></div>
      <div class="lhs"><span class="nt">LabelIdentifier</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">Identifier</span></div>
      <div class="rhs"><span class="grhsannot">[~Yield]</span> <code class="t">yield</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-identifiers">See 12.1</a></div>
      <div class="lhs"><span class="nt">Identifier</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">IdentifierName</span> <span class="grhsmod">but not</span> <span class="nt">ReservedWord</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-primary-expression">See 12.2</a></div>
      <div class="lhs"><span class="nt">PrimaryExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
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
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-primary-expression">See 12.2</a></div>
      <div class="lhs"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code></div>
      <div class="rhs"><code class="t">(</code> <code class="t">)</code></div>
      <div class="rhs"><code class="t">(</code> <code class="t">...</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">)</code></div>
      <div class="rhs"><code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">,</code> <code class="t">...</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">)</code></div>
    </div>

    <p>When processing the production</p>

    <p class="normalbefore">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nt">PrimaryExpression</span><sub>[Yield]</sub>
    <b>:</b> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub>[?Yield]</sub><span style="font-family:     Times New Roman"><i><br /></i></span>the interpretation of <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span> is refined using the following grammar:</p>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-primary-expression">See 12.2</a></div>
      <div class="lhs"><span class="nt">ParenthesizedExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-primary-expression-literals">See 12.2.4</a></div>
      <div class="lhs"><span class="nt">Literal</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">NullLiteral</span></div>
      <div class="rhs"><span class="nt">BooleanLiteral</span></div>
      <div class="rhs"><span class="nt">NumericLiteral</span></div>
      <div class="rhs"><span class="nt">StringLiteral</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-array-initializer">See 12.2.5</a></div>
      <div class="lhs"><span class="nt">ArrayLiteral</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
      <div class="rhs"><code class="t">[</code> <span class="nt">ElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">]</code></div>
      <div class="rhs"><code class="t">[</code> <span class="nt">ElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <code class="t">]</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-array-initializer">See 12.2.5</a></div>
      <div class="lhs"><span class="nt">ElementList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">SpreadElement</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">ElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">ElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">SpreadElement</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-array-initializer">See 12.2.5</a></div>
      <div class="lhs"><span class="nt">Elision</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">,</code></div>
      <div class="rhs"><span class="nt">Elision</span> <code class="t">,</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-array-initializer">See 12.2.5</a></div>
      <div class="lhs"><span class="nt">SpreadElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">...</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-object-initializer">See 12.2.6</a></div>
      <div class="lhs"><span class="nt">ObjectLiteral</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">{</code> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">PropertyDefinitionList</span><sub class="g-params">[?Yield]</sub> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">PropertyDefinitionList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-object-initializer">See 12.2.6</a></div>
      <div class="lhs"><span class="nt">PropertyDefinitionList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">PropertyDefinition</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">PropertyDefinitionList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">PropertyDefinition</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-object-initializer">See 12.2.6</a></div>
      <div class="lhs"><span class="nt">PropertyDefinition</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">IdentifierReference</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">CoverInitializedName</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">:</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">MethodDefinition</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-object-initializer">See 12.2.6</a></div>
      <div class="lhs"><span class="nt">PropertyName</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">LiteralPropertyName</span></div>
      <div class="rhs"><span class="nt">ComputedPropertyName</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-object-initializer">See 12.2.6</a></div>
      <div class="lhs"><span class="nt">LiteralPropertyName</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">IdentifierName</span></div>
      <div class="rhs"><span class="nt">StringLiteral</span></div>
      <div class="rhs"><span class="nt">NumericLiteral</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-object-initializer">See 12.2.6</a></div>
      <div class="lhs"><span class="nt">ComputedPropertyName</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">[</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">]</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-object-initializer">See 12.2.6</a></div>
      <div class="lhs"><span class="nt">CoverInitializedName</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">IdentifierReference</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-object-initializer">See 12.2.6</a></div>
      <div class="lhs"><span class="nt">Initializer</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">=</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-template-literals">See 12.2.9</a></div>
      <div class="lhs"><span class="nt">TemplateLiteral</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">NoSubstitutionTemplate</span></div>
      <div class="rhs"><span class="nt">TemplateHead</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <span class="nt">TemplateSpans</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-template-literals">See 12.2.9</a></div>
      <div class="lhs"><span class="nt">TemplateSpans</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">TemplateTail</span></div>
      <div class="rhs"><span class="nt">TemplateMiddleList</span><sub class="g-params">[?Yield]</sub> <span class="nt">TemplateTail</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-template-literals">See 12.2.9</a></div>
      <div class="lhs"><span class="nt">TemplateMiddleList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">TemplateMiddle</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">TemplateMiddleList</span><sub class="g-params">[?Yield]</sub> <span class="nt">TemplateMiddle</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-left-hand-side-expressions">See 12.3</a></div>
      <div class="lhs"><span class="nt">MemberExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">PrimaryExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">[</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">]</code></div>
      <div class="rhs"><span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
      <div class="rhs"><span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">TemplateLiteral</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">SuperProperty</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">MetaProperty</span></div>
      <div class="rhs"><code class="t">new</code> <span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">Arguments</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-left-hand-side-expressions">See 12.3</a></div>
      <div class="lhs"><span class="nt">SuperProperty</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">super</code> <code class="t">[</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">]</code></div>
      <div class="rhs"><code class="t">super</code> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-left-hand-side-expressions">See 12.3</a></div>
      <div class="lhs"><span class="nt">MetaProperty</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">NewTarget</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-left-hand-side-expressions">See 12.3</a></div>
      <div class="lhs"><span class="nt">NewTarget</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">new</code> <code class="t">.</code> <code class="t">target</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-left-hand-side-expressions">See 12.3</a></div>
      <div class="lhs"><span class="nt">NewExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><code class="t">new</code> <span class="nt">NewExpression</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-left-hand-side-expressions">See 12.3</a></div>
      <div class="lhs"><span class="nt">CallExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">MemberExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">Arguments</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">SuperCall</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">CallExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">Arguments</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">CallExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">[</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">]</code></div>
      <div class="rhs"><span class="nt">CallExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">.</code> <span class="nt">IdentifierName</span></div>
      <div class="rhs"><span class="nt">CallExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">TemplateLiteral</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-left-hand-side-expressions">See 12.3</a></div>
      <div class="lhs"><span class="nt">SuperCall</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">super</code> <span class="nt">Arguments</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-left-hand-side-expressions">See 12.3</a></div>
      <div class="lhs"><span class="nt">Arguments</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">(</code> <code class="t">)</code></div>
      <div class="rhs"><code class="t">(</code> <span class="nt">ArgumentList</span><sub class="g-params">[?Yield]</sub> <code class="t">)</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-left-hand-side-expressions">See 12.3</a></div>
      <div class="lhs"><span class="nt">ArgumentList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
      <div class="rhs"><code class="t">...</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">ArgumentList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">ArgumentList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <code class="t">...</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-left-hand-side-expressions">See 12.3</a></div>
      <div class="lhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">NewExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">CallExpression</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-postfix-expressions">See 12.4</a></div>
      <div class="lhs"><span class="nt">PostfixExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">++</code></div>
      <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">--</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-unary-operators">See 12.5</a></div>
      <div class="lhs"><span class="nt">UnaryExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
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

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-multiplicative-operators">See 12.6</a></div>
      <div class="lhs"><span class="nt">MultiplicativeExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">MultiplicativeExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">MultiplicativeOperator</span> <span class="nt">UnaryExpression</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-multiplicative-operators">See 12.6</a></div>
      <div class="lhs"><span class="nt">MultiplicativeOperator</span> <span class="geq">:</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">*</code> <code class="t">/</code> <code class="t">%</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-additive-operators">See 12.7</a></div>
      <div class="lhs"><span class="nt">AdditiveExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">MultiplicativeExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">+</code> <span class="nt">MultiplicativeExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">-</code> <span class="nt">MultiplicativeExpression</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-bitwise-shift-operators">See 12.8</a></div>
      <div class="lhs"><span class="nt">ShiftExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">&lt;&lt;</code> <span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">&gt;&gt;</code> <span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">&gt;&gt;&gt;</code> <span class="nt">AdditiveExpression</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-relational-operators">See 12.9</a></div>
      <div class="lhs"><span class="nt">RelationalExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&lt;</code> <span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&gt;</code> <span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&lt;=</code> <span class="nt">ShiftExpression</span><sub class="g-params">[? Yield]</sub></div>
      <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&gt;=</code> <span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">instanceof</code> <span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="grhsannot">[+In]</span> <span class="nt">RelationalExpression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">in</code> <span class="nt">ShiftExpression</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-equality-operators">See 12.10</a></div>
      <div class="lhs"><span class="nt">EqualityExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">==</code> <span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">!=</code> <span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">===</code> <span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">!==</code> <span class="nt">RelationalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-binary-bitwise-operators">See 12.11</a></div>
      <div class="lhs"><span class="nt">BitwiseANDExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">BitwiseANDExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&amp;</code> <span class="nt">EqualityExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-binary-bitwise-operators">See 12.11</a></div>
      <div class="lhs"><span class="nt">BitwiseXORExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BitwiseANDExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">BitwiseXORExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">^</code> <span class="nt">BitwiseANDExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-binary-bitwise-operators">See 12.11</a></div>
      <div class="lhs"><span class="nt">BitwiseORExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BitwiseXORExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">BitwiseORExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">|</code> <span class="nt">BitwiseXORExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-binary-logical-operators">See 12.12</a></div>
      <div class="lhs"><span class="nt">LogicalANDExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BitwiseORExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">LogicalANDExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">&amp;&amp;</code> <span class="nt">BitwiseORExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-binary-logical-operators">See 12.12</a></div>
      <div class="lhs"><span class="nt">LogicalORExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">LogicalANDExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">LogicalORExpression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">||</code> <span class="nt">LogicalANDExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-conditional-operator">See 12.13</a></div>
      <div class="lhs"><span class="nt">ConditionalExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">LogicalORExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">LogicalORExpression</span><sub class="g-params">[?In,?Yield]</sub> <code class="t">?</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">:</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-assignment-operators">See 12.14</a></div>
      <div class="lhs"><span class="nt">AssignmentExpression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ConditionalExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="grhsannot">[+Yield]</span> <span class="nt">YieldExpression</span><sub class="g-params">[?In]</sub></div>
      <div class="rhs"><span class="nt">ArrowFunction</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <code class="t">=</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <span class="nt">AssignmentOperator</span> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-assignment-operators">See 12.14</a></div>
      <div class="lhs"><span class="nt">AssignmentOperator</span> <span class="geq">:</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">*=</code> <code class="t">/=</code> <code class="t">%=</code> <code class="t">+=</code> <code class="t">-=</code> <code class="t">&lt;&lt;=</code> <code class="t">&gt;&gt;=</code> <code class="t">&gt;&gt;&gt;=</code> <code class="t">&amp;=</code> <code class="t">^=</code> <code class="t">|=</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-expressions#sec-comma-operator">See 12.15</a></div>
      <div class="lhs"><span class="nt">Expression</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">Expression</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">,</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>
  </section>

  <section id="sec-statements">
    <h2 id="sec-A.3" title="A.3"> Statements</h2><div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations">See clause 13</a></div>
      <div class="lhs"><span class="nt">Statement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
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
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations">See clause 13</a></div>
      <div class="lhs"><span class="nt">Declaration</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">HoistableDeclaration</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">ClassDeclaration</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">LexicalDeclaration</span><sub class="g-params">[In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations">See clause 13</a></div>
      <div class="lhs"><span class="nt">HoistableDeclaration</span><sub class="g-params">[Yield, Default]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">FunctionDeclaration</span><sub class="g-params">[?Yield,?Default]</sub></div>
      <div class="rhs"><span class="nt">GeneratorDeclaration</span><sub class="g-params">[?Yield, ?Default]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations">See clause 13</a></div>
      <div class="lhs"><span class="nt">BreakableStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">IterationStatement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">SwitchStatement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-block">See 13.2</a></div>
      <div class="lhs"><span class="nt">BlockStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-block">See 13.2</a></div>
      <div class="lhs"><span class="nt">Block</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">{</code> <span class="nt">StatementList</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-block">See 13.2</a></div>
      <div class="lhs"><span class="nt">StatementList</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">StatementListItem</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">StatementList</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">StatementListItem</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-block">See 13.2</a></div>
      <div class="lhs"><span class="nt">StatementListItem</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">Declaration</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations">See 13.3.1</a></div>
      <div class="lhs"><span class="nt">LexicalDeclaration</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">LetOrConst</span> <span class="nt">BindingList</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">;</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations">See 13.3.1</a></div>
      <div class="lhs"><span class="nt">LetOrConst</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">let</code></div>
      <div class="rhs"><code class="t">const</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations">See 13.3.1</a></div>
      <div class="lhs"><span class="nt">BindingList</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">LexicalBinding</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">BindingList</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">,</code> <span class="nt">LexicalBinding</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations">See 13.3.1</a></div>
      <div class="lhs"><span class="nt">LexicalBinding</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[?In, ?Yield]</sub><sub class="g-opt">opt</sub></div>
      <div class="rhs"><span class="nt">BindingPattern</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement">See 13.3.2</a></div>
      <div class="lhs"><span class="nt">VariableStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">var</code> <span class="nt">VariableDeclarationList</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">;</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement">See 13.3.2</a></div>
      <div class="lhs"><span class="nt">VariableDeclarationList</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">VariableDeclaration</span><sub class="g-params">[?In, ?Yield]</sub></div>
      <div class="rhs"><span class="nt">VariableDeclarationList</span><sub class="g-params">[?In, ?Yield]</sub> <code class="t">,</code> <span class="nt">VariableDeclaration</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-variable-statement">See 13.3.2</a></div>
      <div class="lhs"><span class="nt">VariableDeclaration</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[?In, ?Yield]</sub><sub class="g-opt">opt</sub></div>
      <div class="rhs"><span class="nt">BindingPattern</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[?In, ?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns">See 13.3.3</a></div>
      <div class="lhs"><span class="nt">BindingPattern</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ObjectBindingPattern</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">ArrayBindingPattern</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns">See 13.3.3</a></div>
      <div class="lhs"><span class="nt">ObjectBindingPattern</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">{</code> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">BindingPropertyList</span><sub class="g-params">[?Yield]</sub> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">BindingPropertyList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns">See 13.3.3</a></div>
      <div class="lhs"><span class="nt">ArrayBindingPattern</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">[</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingRestElement</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">]</code></div>
      <div class="rhs"><code class="t">[</code> <span class="nt">BindingElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">]</code></div>
      <div class="rhs"><code class="t">[</code> <span class="nt">BindingElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingRestElement</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">]</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns">See 13.3.3</a></div>
      <div class="lhs"><span class="nt">BindingPropertyList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingProperty</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">BindingPropertyList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">BindingProperty</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns">See 13.3.3</a></div>
      <div class="lhs"><span class="nt">BindingElementList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingElisionElement</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">BindingElementList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">BindingElisionElement</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns">See 13.3.3</a></div>
      <div class="lhs"><span class="nt">BindingElisionElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">Elision</span><sub class="g-opt">opt</sub> <span class="nt">BindingElement</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns">See 13.3.3</a></div>
      <div class="lhs"><span class="nt">BindingProperty</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">SingleNameBinding</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">:</code> <span class="nt">BindingElement</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns">See 13.3.3</a></div>
      <div class="lhs"><span class="nt">BindingElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">SingleNameBinding</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">BindingPattern</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[In, ?Yield]</sub><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns">See 13.3.3</a></div>
      <div class="lhs"><span class="nt">SingleNameBinding</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <span class="nt">Initializer</span><sub class="g-params">[In, ?Yield]</sub><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-destructuring-binding-patterns">See 13.3.3</a></div>
      <div class="lhs"><span class="nt">BindingRestElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">...</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-empty-statement">See 13.4</a></div>
      <div class="lhs"><span class="nt">EmptyStatement</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">;</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-expression-statement">See 13.5</a></div>
      <div class="lhs"><span class="nt">ExpressionStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="grhsannot">[lookahead &notin; {<code class="t">{</code>, <code class="t">function</code>, <code class="t">class</code>, <code class="t">let [</code>}]</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">;</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-if-statement">See 13.6</a></div>
      <div class="lhs"><span class="nt">IfStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub> <code class="t">else</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><code class="t">if</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-iteration-statements">See 13.7</a></div>
      <div class="lhs"><span class="nt">IterationStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
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
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-iteration-statements">See 13.7</a></div>
      <div class="lhs"><span class="nt">ForDeclaration</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">LetOrConst</span> <span class="nt">ForBinding</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-iteration-statements">See 13.7</a></div>
      <div class="lhs"><span class="nt">ForBinding</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">BindingPattern</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-continue-statement">See 13.8</a></div>
      <div class="lhs"><span class="nt">ContinueStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">continue</code> <code class="t">;</code></div>
      <div class="rhs"><code class="t">continue</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">LabelIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">;</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-break-statement">See 13.9</a></div>
      <div class="lhs"><span class="nt">BreakStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">break</code> <code class="t">;</code></div>
      <div class="rhs"><code class="t">break</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">LabelIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">;</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-return-statement">See 13.10</a></div>
      <div class="lhs"><span class="nt">ReturnStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">return</code> <code class="t">;</code></div>
      <div class="rhs"><code class="t">return</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">;</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-with-statement">See 13.11</a></div>
      <div class="lhs"><span class="nt">WithStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">with</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement">See 13.12</a></div>
      <div class="lhs"><span class="nt">SwitchStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">switch</code> <code class="t">(</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">)</code> <span class="nt">CaseBlock</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement">See 13.12</a></div>
      <div class="lhs"><span class="nt">CaseBlock</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">CaseClauses</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub> <span class="nt">DefaultClause</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">CaseClauses</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement">See 13.12</a></div>
      <div class="lhs"><span class="nt">CaseClauses</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">CaseClause</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">CaseClauses</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">CaseClause</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement">See 13.12</a></div>
      <div class="lhs"><span class="nt">CaseClause</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">case</code> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-switch-statement">See 13.12</a></div>
      <div class="lhs"><span class="nt">DefaultClause</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">default</code> <code class="t">:</code> <span class="nt">StatementList</span><sub class="g-params">[?Yield, ?Return]</sub><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements">See 13.13</a></div>
      <div class="lhs"><span class="nt">LabelledStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">LabelIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">:</code> <span class="nt">LabelledItem</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-labelled-statements">See 13.13</a></div>
      <div class="lhs"><span class="nt">LabelledItem</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">Statement</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><span class="nt">FunctionDeclaration</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-throw-statement">See 13.14</a></div>
      <div class="lhs"><span class="nt">ThrowStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">throw</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">;</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement">See 13.15</a></div>
      <div class="lhs"><span class="nt">TryStatement</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">try</code> <span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">Catch</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><code class="t">try</code> <span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">Finally</span><sub class="g-params">[?Yield, ?Return]</sub></div>
      <div class="rhs"><code class="t">try</code> <span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">Catch</span><sub class="g-params">[?Yield, ?Return]</sub> <span class="nt">Finally</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement">See 13.15</a></div>
      <div class="lhs"><span class="nt">Catch</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">catch</code> <code class="t">(</code> <span class="nt">CatchParameter</span><sub class="g-params">[?Yield]</sub> <code class="t">)</code> <span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement">See 13.15</a></div>
      <div class="lhs"><span class="nt">Finally</span><sub class="g-params">[Yield, Return]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">finally</code> <span class="nt">Block</span><sub class="g-params">[?Yield, ?Return]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-try-statement">See 13.15</a></div>
      <div class="lhs"><span class="nt">CatchParameter</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">BindingPattern</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-statements-and-declarations#sec-debugger-statement">See 13.16</a></div>
      <div class="lhs"><span class="nt">DebuggerStatement</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">debugger</code> <code class="t">;</code></div>
    </div>
  </section>

  <section id="sec-functions-and-classes">
    <h2 id="sec-A.4" title="A.4">
        Functions and Classes</h2><div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">See 14.1</a></div>
      <div class="lhs"><span class="nt">FunctionDeclaration</span><sub class="g-params">[Yield, Default]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">function</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <div class="rhs"><span class="grhsannot">[+Default]</span> <code class="t">function</code> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">See 14.1</a></div>
      <div class="lhs"><span class="nt">FunctionExpression</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">function</code> <span class="nt">BindingIdentifier</span><sub class="g-opt">opt</sub> <code class="t">(</code> <span class="nt">FormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">See 14.1</a></div>
      <div class="lhs"><span class="nt">StrictFormalParameters</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">FormalParameters</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">See 14.1</a></div>
      <div class="lhs"><span class="nt">FormalParameters</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="grhsannot">[empty]</span></div>
      <div class="rhs"><span class="nt">FormalParameterList</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">See 14.1</a></div>
      <div class="lhs"><span class="nt">FormalParameterList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">FunctionRestParameter</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">FormalsList</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">FormalsList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">FunctionRestParameter</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">See 14.1</a></div>
      <div class="lhs"><span class="nt">FormalsList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">FormalParameter</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">FormalsList</span><sub class="g-params">[?Yield]</sub> <code class="t">,</code> <span class="nt">FormalParameter</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">See 14.1</a></div>
      <div class="lhs"><span class="nt">FunctionRestParameter</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingRestElement</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">See 14.1</a></div>
      <div class="lhs"><span class="nt">FormalParameter</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingElement</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">See 14.1</a></div>
      <div class="lhs"><span class="nt">FunctionBody</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">FunctionStatementList</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions">See 14.1</a></div>
      <div class="lhs"><span class="nt">FunctionStatementList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">StatementList</span><sub class="g-params">[?Yield, Return]</sub><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions">See 14.2</a></div>
      <div class="lhs"><span class="nt">ArrowFunction</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ArrowParameters</span><sub class="g-params">[?Yield]</sub> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">=&gt;</code> <span class="nt">ConciseBody</span><sub class="g-params">[?In]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions">See 14.2</a></div>
      <div class="lhs"><span class="nt">ArrowParameters</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions">See 14.2</a></div>
      <div class="lhs"><span class="nt">ConciseBody</span><sub class="g-params">[In]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="grhsannot">[lookahead &ne; { ]</span> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In]</sub></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
    </div>

    <p>When the production<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nt">ArrowParameters</span><sub>[Yield]</sub>
    <b>:</b> <span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span><sub>[?Yield]</sub><span style="font-family:     Times New Roman"><i><br /></i></span>is recognized the following grammar is used to refine the interpretation of <span class="prod"><span class="nt">CoverParenthesizedExpressionAndArrowParameterList</span> <span class="geq">:</span></span></p>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-arrow-function-definitions">See 14.2</a></div>
      <div class="lhs"><span class="nt">ArrowFormalParameters</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">(</code> <span class="nt">StrictFormalParameters</span><sub class="g-params">[?Yield]</sub> <code class="t">)</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-method-definitions">See 14.3</a></div>
      <div class="lhs"><span class="nt">MethodDefinition</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <span class="nt">StrictFormalParameters</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <div class="rhs"><span class="nt">GeneratorMethod</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><code class="t">get</code> <span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
      <div class="rhs"><code class="t">set</code> <span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <span class="nt">PropertySetParameterList</span> <code class="t">)</code> <code class="t">{</code> <span class="nt">FunctionBody</span> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-method-definitions">See 14.3</a></div>
      <div class="lhs"><span class="nt">PropertySetParameterList</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">FormalParameter</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions">See 14.4</a></div>
      <div class="lhs"><span class="nt">GeneratorMethod</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">*</code> <span class="nt">PropertyName</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <span class="nt">StrictFormalParameters</span><sub class="g-params">[Yield]</sub> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions">See 14.4</a></div>
      <div class="lhs"><span class="nt">GeneratorDeclaration</span><sub class="g-params">[Yield, Default]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">(</code> <span class="nt">FormalParameters</span><sub class="g-params">[Yield]</sub> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
      <div class="rhs"><span class="grhsannot">[+Default]</span> <code class="t">function</code> <code class="t">*</code> <code class="t">(</code> <span class="nt">FormalParameters</span><sub class="g-params">[Yield]</sub> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions">See 14.4</a></div>
      <div class="lhs"><span class="nt">GeneratorExpression</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">function</code> <code class="t">*</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[Yield]</sub><sub class="g-opt">opt</sub> <code class="t">(</code> <span class="nt">FormalParameters</span><sub class="g-params">[Yield]</sub> <code class="t">)</code> <code class="t">{</code> <span class="nt">GeneratorBody</span> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions">See 14.4</a></div>
      <div class="lhs"><span class="nt">GeneratorBody</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">FunctionBody</span><sub class="g-params">[Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-generator-function-definitions">See 14.4</a></div>
      <div class="lhs"><span class="nt">YieldExpression</span><sub class="g-params">[In]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">yield</code></div>
      <div class="rhs"><code class="t">yield</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, Yield]</sub></div>
      <div class="rhs"><code class="t">yield</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">*</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions">See 14.5</a></div>
      <div class="lhs"><span class="nt">ClassDeclaration</span><sub class="g-params">[Yield, Default]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">class</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub> <span class="nt">ClassTail</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="grhsannot">[+Default]</span> <code class="t">class</code> <span class="nt">ClassTail</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions">See 14.5</a></div>
      <div class="lhs"><span class="nt">ClassExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">class</code> <span class="nt">BindingIdentifier</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <span class="nt">ClassTail</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions">See 14.5</a></div>
      <div class="lhs"><span class="nt">ClassTail</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ClassHeritage</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">{</code> <span class="nt">ClassBody</span><sub class="g-params">[?Yield]</sub><sub class="g-opt">opt</sub> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions">See 14.5</a></div>
      <div class="lhs"><span class="nt">ClassHeritage</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">extends</code> <span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions">See 14.5</a></div>
      <div class="lhs"><span class="nt">ClassBody</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ClassElementList</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions">See 14.5</a></div>
      <div class="lhs"><span class="nt">ClassElementList</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ClassElement</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><span class="nt">ClassElementList</span><sub class="g-params">[?Yield]</sub> <span class="nt">ClassElement</span><sub class="g-params">[?Yield]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions">See 14.5</a></div>
      <div class="lhs"><span class="nt">ClassElement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">MethodDefinition</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><code class="t">static</code> <span class="nt">MethodDefinition</span><sub class="g-params">[?Yield]</sub></div>
      <div class="rhs"><code class="t">;</code></div>
    </div>
  </section>

  <section id="sec-scripts-and-modules">
    <h2 id="sec-A.5" title="A.5"> Scripts
        and Modules</h2><div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-scripts">See 15.1</a></div>
      <div class="lhs"><span class="nt">Script</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ScriptBody</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-scripts">See 15.1</a></div>
      <div class="lhs"><span class="nt">ScriptBody</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">StatementList</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-modules">See 15.2</a></div>
      <div class="lhs"><span class="nt">Module</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ModuleBody</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-modules">See 15.2</a></div>
      <div class="lhs"><span class="nt">ModuleBody</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ModuleItemList</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-modules">See 15.2</a></div>
      <div class="lhs"><span class="nt">ModuleItemList</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ModuleItem</span></div>
      <div class="rhs"><span class="nt">ModuleItemList</span> <span class="nt">ModuleItem</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-modules">See 15.2</a></div>
      <div class="lhs"><span class="nt">ModuleItem</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ImportDeclaration</span></div>
      <div class="rhs"><span class="nt">ExportDeclaration</span></div>
      <div class="rhs"><span class="nt">StatementListItem</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-imports">See 15.2.2</a></div>
      <div class="lhs"><span class="nt">ImportDeclaration</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">import</code> <span class="nt">ImportClause</span> <span class="nt">FromClause</span> <code class="t">;</code></div>
      <div class="rhs"><code class="t">import</code> <span class="nt">ModuleSpecifier</span> <code class="t">;</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-imports">See 15.2.2</a></div>
      <div class="lhs"><span class="nt">ImportClause</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ImportedDefaultBinding</span></div>
      <div class="rhs"><span class="nt">NameSpaceImport</span></div>
      <div class="rhs"><span class="nt">NamedImports</span></div>
      <div class="rhs"><span class="nt">ImportedDefaultBinding</span> <code class="t">,</code> <span class="nt">NameSpaceImport</span></div>
      <div class="rhs"><span class="nt">ImportedDefaultBinding</span> <code class="t">,</code> <span class="nt">NamedImports</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-imports">See 15.2.2</a></div>
      <div class="lhs"><span class="nt">ImportedDefaultBinding</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ImportedBinding</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-imports">See 15.2.2</a></div>
      <div class="lhs"><span class="nt">NameSpaceImport</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">*</code> <code class="t">as</code> <span class="nt">ImportedBinding</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-imports">See 15.2.2</a></div>
      <div class="lhs"><span class="nt">NamedImports</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">{</code> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">ImportsList</span> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">ImportsList</span> <code class="t">,</code> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-imports">See 15.2.2</a></div>
      <div class="lhs"><span class="nt">FromClause</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">from</code> <span class="nt">ModuleSpecifier</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-imports">See 15.2.2</a></div>
      <div class="lhs"><span class="nt">ImportsList</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ImportSpecifier</span></div>
      <div class="rhs"><span class="nt">ImportsList</span> <code class="t">,</code> <span class="nt">ImportSpecifier</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-imports">See 15.2.2</a></div>
      <div class="lhs"><span class="nt">ImportSpecifier</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ImportedBinding</span></div>
      <div class="rhs"><span class="nt">IdentifierName</span> <code class="t">as</code> <span class="nt">ImportedBinding</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-imports">See 15.2.2</a></div>
      <div class="lhs"><span class="nt">ModuleSpecifier</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">StringLiteral</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-imports">See 15.2.2</a></div>
      <div class="lhs"><span class="nt">ImportedBinding</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">BindingIdentifier</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-exports">See 15.2.3</a></div>
      <div class="lhs"><span class="nt">ExportDeclaration</span> <span class="geq">:</span> </div>
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
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-exports">See 15.2.3</a></div>
      <div class="lhs"><span class="nt">ExportClause</span> <span class="geq">:</span> </div>
      <div class="rhs"><code class="t">{</code> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">ExportsList</span> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">ExportsList</span> <code class="t">,</code> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-exports">See 15.2.3</a></div>
      <div class="lhs"><span class="nt">ExportsList</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">ExportSpecifier</span></div>
      <div class="rhs"><span class="nt">ExportsList</span> <code class="t">,</code> <span class="nt">ExportSpecifier</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-ecmascript-language-scripts-and-modules#sec-exports">See 15.2.3</a></div>
      <div class="lhs"><span class="nt">ExportSpecifier</span> <span class="geq">:</span> </div>
      <div class="rhs"><span class="nt">IdentifierName</span></div>
      <div class="rhs"><span class="nt">IdentifierName</span> <code class="t">as</code> <span class="nt">IdentifierName</span></div>
    </div>
  </section>

  <section id="sec-number-conversions">
    <h2 id="sec-A.6" title="A.6"> Number
        Conversions</h2><div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">StringNumericLiteral</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">StrWhiteSpace</span><sub class="g-opt">opt</sub></div>
      <div class="rhs"><span class="nt">StrWhiteSpace</span><sub class="g-opt">opt</sub> <span class="nt">StrNumericLiteral</span> <span class="nt">StrWhiteSpace</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">StrWhiteSpace</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">StrWhiteSpaceChar</span> <span class="nt">StrWhiteSpace</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">StrWhiteSpaceChar</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">WhiteSpace</span></div>
      <div class="rhs"><span class="nt">LineTerminator</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">StrNumericLiteral</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">StrDecimalLiteral</span></div>
      <div class="rhs"><span class="nt">BinaryIntegerLiteral</span></div>
      <div class="rhs"><span class="nt">OctalIntegerLiteral</span></div>
      <div class="rhs"><span class="nt">HexIntegerLiteral</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">StrDecimalLiteral</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">StrUnsignedDecimalLiteral</span></div>
      <div class="rhs"><code class="t">+</code> <span class="nt">StrUnsignedDecimalLiteral</span></div>
      <div class="rhs"><code class="t">-</code> <span class="nt">StrUnsignedDecimalLiteral</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">Infinity</span></div>
      <div class="rhs"><span class="nt">DecimalDigits</span> <code class="t">.</code> <span class="nt">DecimalDigits</span><sub class="g-opt">opt</sub> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
      <div class="rhs"><code class="t">.</code> <span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
      <div class="rhs"><span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">DecimalDigits</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">DecimalDigit</span></div>
      <div class="rhs"><span class="nt">DecimalDigits</span> <span class="nt">DecimalDigit</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">DecimalDigit</span> <span class="geq">:::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">ExponentPart</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">ExponentIndicator</span> <span class="nt">SignedInteger</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">ExponentIndicator</span> <span class="geq">:::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">e</code> <code class="t">E</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">SignedInteger</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">DecimalDigits</span></div>
      <div class="rhs"><code class="t">+</code> <span class="nt">DecimalDigits</span></div>
      <div class="rhs"><code class="t">-</code> <span class="nt">DecimalDigits</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">HexIntegerLiteral</span> <span class="geq">:::</span> </div>
      <div class="rhs"><code class="t">0x</code> <span class="nt">HexDigit</span></div>
      <div class="rhs"><code class="t">0X</code> <span class="nt">HexDigit</span></div>
      <div class="rhs"><span class="nt">HexIntegerLiteral</span> <span class="nt">HexDigit</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">See 7.1.3.1</a></div>
      <div class="lhs"><span class="nt">HexDigit</span> <span class="geq">:::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code> <code class="t">a</code> <code class="t">b</code> <code class="t">c</code> <code class="t">d</code> <code class="t">e</code> <code class="t">f</code> <code class="t">A</code> <code class="t">B</code> <code class="t">C</code> <code class="t">D</code> <code class="t">E</code> <code class="t">F</code></div>
    </div>

    <p>All grammar symbols not explicitly defined by the <span class="nt">StringNumericLiteral</span> grammar have the definitions
    used in the Lexical Grammar for numeric literals (<a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">11.8.3</a>)</p>
  </section>

  <section id="sec-universal-resource-identifier-character-classes">
    <h2 id="sec-A.7" title="A.7"> Universal Resource Identifier Character Classes</h2><div class="gp">
      <div class="gsumxref"><a href="sec-global-object#sec-uri-syntax-and-semantics">See 18.2.6.1</a></div>
      <div class="lhs"><span class="nt">uri</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">uriCharacters</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-global-object#sec-uri-syntax-and-semantics">See 18.2.6.1</a></div>
      <div class="lhs"><span class="nt">uriCharacters</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">uriCharacter</span> <span class="nt">uriCharacters</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-global-object#sec-uri-syntax-and-semantics">See 18.2.6.1</a></div>
      <div class="lhs"><span class="nt">uriCharacter</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">uriReserved</span></div>
      <div class="rhs"><span class="nt">uriUnescaped</span></div>
      <div class="rhs"><span class="nt">uriEscaped</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-global-object#sec-uri-syntax-and-semantics">See 18.2.6.1</a></div>
      <div class="lhs"><span class="nt">uriReserved</span> <span class="geq">:::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">;</code> <code class="t">/</code> <code class="t">?</code> <code class="t">:</code> <code class="t">@</code> <code class="t">&amp;</code> <code class="t">=</code> <code class="t">+</code> <code class="t">$</code> <code class="t">,</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-global-object#sec-uri-syntax-and-semantics">See 18.2.6.1</a></div>
      <div class="lhs"><span class="nt">uriUnescaped</span> <span class="geq">:::</span> </div>
      <div class="rhs"><span class="nt">uriAlpha</span></div>
      <div class="rhs"><span class="nt">DecimalDigit</span></div>
      <div class="rhs"><span class="nt">uriMark</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-global-object#sec-uri-syntax-and-semantics">See 18.2.6.1</a></div>
      <div class="lhs"><span class="nt">uriEscaped</span> <span class="geq">:::</span> </div>
      <div class="rhs"><code class="t">%</code> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-global-object#sec-uri-syntax-and-semantics">See 18.2.6.1</a></div>
      <div class="lhs"><span class="nt">uriAlpha</span> <span class="geq">:::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">a</code> <code class="t">b</code> <code class="t">c</code> <code class="t">d</code> <code class="t">e</code> <code class="t">f</code> <code class="t">g</code> <code class="t">h</code> <code class="t">i</code> <code class="t">j</code> <code class="t">k</code> <code class="t">l</code> <code class="t">m</code> <code class="t">n</code> <code class="t">o</code> <code class="t">p</code> <code class="t">q</code> <code class="t">r</code> <code class="t">s</code> <code class="t">t</code> <code class="t">u</code> <code class="t">v</code> <code class="t">w</code> <code class="t">x</code> <code class="t">y</code> <code class="t">z</code></div>
      <div class="rhs"><code class="t">A</code> <code class="t">B</code> <code class="t">C</code> <code class="t">D</code> <code class="t">E</code> <code class="t">F</code> <code class="t">G</code> <code class="t">H</code> <code class="t">I</code> <code class="t">J</code> <code class="t">K</code> <code class="t">L</code> <code class="t">M</code> <code class="t">N</code> <code class="t">O</code> <code class="t">P</code> <code class="t">Q</code> <code class="t">R</code> <code class="t">S</code> <code class="t">T</code> <code class="t">U</code> <code class="t">V</code> <code class="t">W</code> <code class="t">X</code> <code class="t">Y</code> <code class="t">Z</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-global-object#sec-uri-syntax-and-semantics">See 18.2.6.1</a></div>
      <div class="lhs"><span class="nt">uriMark</span> <span class="geq">:::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">-</code> <code class="t">_</code> <code class="t">.</code> <code class="t">!</code> <code class="t">~</code> <code class="t">*</code> <code class="t">'</code> <code class="t">(</code> <code class="t">)</code></div>
    </div>
  </section>

  <section id="sec-regular-expressions">
    <h2 id="sec-A.8" title="A.8"> Regular
        Expressions</h2><div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">Pattern</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">Disjunction</span><sub class="g-params">[?U]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">Disjunction</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">Alternative</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">Alternative</span><sub class="g-params">[?U]</sub> <code class="t">|</code> <span class="nt">Disjunction</span><sub class="g-params">[?U]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">Alternative</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="grhsannot">[empty]</span></div>
      <div class="rhs"><span class="nt">Alternative</span><sub class="g-params">[?U]</sub> <span class="nt">Term</span><sub class="g-params">[?U]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">Term</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">Assertion</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">Atom</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">Atom</span><sub class="g-params">[?U]</sub> <span class="nt">Quantifier</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">Assertion</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">^</code></div>
      <div class="rhs"><code class="t">$</code></div>
      <div class="rhs"><code class="t">\</code> <code class="t">b</code></div>
      <div class="rhs"><code class="t">\</code> <code class="t">B</code></div>
      <div class="rhs"><code class="t">(</code> <code class="t">?</code> <code class="t">=</code> <span class="nt">Disjunction</span><sub class="g-params">[?U]</sub> <code class="t">)</code></div>
      <div class="rhs"><code class="t">(</code> <code class="t">?</code> <code class="t">!</code> <span class="nt">Disjunction</span><sub class="g-params">[?U]</sub> <code class="t">)</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">Quantifier</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">QuantifierPrefix</span></div>
      <div class="rhs"><span class="nt">QuantifierPrefix</span> <code class="t">?</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">QuantifierPrefix</span> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">*</code></div>
      <div class="rhs"><code class="t">+</code></div>
      <div class="rhs"><code class="t">?</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">DecimalDigits</span> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">DecimalDigits</span> <code class="t">,</code> <code class="t">}</code></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">DecimalDigits</span> <code class="t">,</code> <span class="nt">DecimalDigits</span> <code class="t">}</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">Atom</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">PatternCharacter</span></div>
      <div class="rhs"><code class="t">.</code></div>
      <div class="rhs"><code class="t">\</code> <span class="nt">AtomEscape</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">CharacterClass</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><code class="t">(</code> <span class="nt">Disjunction</span><sub class="g-params">[?U]</sub> <code class="t">)</code></div>
      <div class="rhs"><code class="t">(</code> <code class="t">?</code> <code class="t">:</code> <span class="nt">Disjunction</span><sub class="g-params">[?U]</sub> <code class="t">)</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">SyntaxCharacter</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">^</code> <code class="t">$</code> <code class="t">\</code> <code class="t">.</code> <code class="t">*</code> <code class="t">+</code> <code class="t">?</code> <code class="t">(</code> <code class="t">)</code> <code class="t">[</code> <code class="t">]</code> <code class="t">{</code> <code class="t">}</code> <code class="t">|</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">PatternCharacter</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <span class="nt">SyntaxCharacter</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">AtomEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">DecimalEscape</span></div>
      <div class="rhs"><span class="nt">CharacterEscape</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">CharacterClassEscape</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">CharacterEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">ControlEscape</span></div>
      <div class="rhs"><code class="t">c</code> <span class="nt">ControlLetter</span></div>
      <div class="rhs"><span class="nt">HexEscapeSequence</span></div>
      <div class="rhs"><span class="nt">RegExpUnicodeEscapeSequence</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">IdentityEscape</span><sub class="g-params">[?U]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">ControlEscape</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">f</code> <code class="t">n</code> <code class="t">r</code> <code class="t">t</code> <code class="t">v</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">ControlLetter</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">a</code> <code class="t">b</code> <code class="t">c</code> <code class="t">d</code> <code class="t">e</code> <code class="t">f</code> <code class="t">g</code> <code class="t">h</code> <code class="t">i</code> <code class="t">j</code> <code class="t">k</code> <code class="t">l</code> <code class="t">m</code> <code class="t">n</code> <code class="t">o</code> <code class="t">p</code> <code class="t">q</code> <code class="t">r</code> <code class="t">s</code> <code class="t">t</code> <code class="t">u</code> <code class="t">v</code> <code class="t">w</code> <code class="t">x</code> <code class="t">y</code> <code class="t">z</code></div>
      <div class="rhs"><code class="t">A</code> <code class="t">B</code> <code class="t">C</code> <code class="t">D</code> <code class="t">E</code> <code class="t">F</code> <code class="t">G</code> <code class="t">H</code> <code class="t">I</code> <code class="t">J</code> <code class="t">K</code> <code class="t">L</code> <code class="t">M</code> <code class="t">N</code> <code class="t">O</code> <code class="t">P</code> <code class="t">Q</code> <code class="t">R</code> <code class="t">S</code> <code class="t">T</code> <code class="t">U</code> <code class="t">V</code> <code class="t">W</code> <code class="t">X</code> <code class="t">Y</code> <code class="t">Z</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">RegExpUnicodeEscapeSequence</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">u</code> <span class="nt">LeadSurrogate</span> <code class="t">\u</code> <span class="nt">TrailSurrogate</span></div>
      <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">u</code> <span class="nt">LeadSurrogate</span></div>
      <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">u</code> <span class="nt">TrailSurrogate</span></div>
      <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">u</code> <span class="nt">NonSurrogate</span></div>
      <div class="rhs"><span class="grhsannot">[~U]</span> <code class="t">u</code> <span class="nt">Hex4Digits</span></div>
      <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">u{</code> <span class="nt">HexDigits</span> <code class="t">}</code></div>
    </div>

    <p>Each <code>\u</code> <span class="nt">TrailSurrogate</span> for which the choice of associated <code>u</code> <span class="nt">LeadSurrogate</span> is ambiguous shall be associated with the nearest possible <code>u</code> <span class="nt">LeadSurrogate</span> that would otherwise have no corresponding <code>\u</code>&nbsp;<span class="nt">TrailSurrogate</span>.</p>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">LeadSurrogate</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">Hex4Digits</span> <span class="grhsannot">[match only if the SV of <span class="nt">Hex4Digits</span> is in the inclusive range 0xD800 to 0xDBFF]</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">TrailSurrogate</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">Hex4Digits</span> <span class="grhsannot">[match only if the SV of <span class="nt">Hex4Digits</span> is in the inclusive range 0xDC00 to 0xDFFF]</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">NonSurrogate</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">Hex4Digits</span> <span class="grhsannot">[match only if the SV of <span class="nt">Hex4Digits</span> is not in the inclusive range 0xD800 to 0xDFFF]</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">IdentityEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">SyntaxCharacter</span></div>
      <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">/</code></div>
      <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <span class="nt">UnicodeIDContinue</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">DecimalEscape</span> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">DecimalIntegerLiteral</span> <span class="grhsannot">[lookahead &notin; <span class="nt">DecimalDigit</span>]</span></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <span class="grhsmod">one of</span> </div>
      <div class="rhs"><code class="t">d</code> <code class="t">D</code> <code class="t">s</code> <code class="t">S</code> <code class="t">w</code> <code class="t">W</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">CharacterClass</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">[</code> <span class="grhsannot">[lookahead &notin; {<code class="t">^</code>}]</span> <span class="nt">ClassRanges</span><sub class="g-params">[?U]</sub> <code class="t">]</code></div>
      <div class="rhs"><code class="t">[</code> <code class="t">^</code> <span class="nt">ClassRanges</span><sub class="g-params">[?U]</sub> <code class="t">]</code></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">ClassRanges</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="grhsannot">[empty]</span></div>
      <div class="rhs"><span class="nt">NonemptyClassRanges</span><sub class="g-params">[?U]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">NonemptyClassRanges</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub> <span class="nt">NonemptyClassRangesNoDash</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub> <code class="t">-</code> <span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub> <span class="nt">ClassRanges</span><sub class="g-params">[?U]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">NonemptyClassRangesNoDash</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">ClassAtomNoDash</span><sub class="g-params">[?U]</sub> <span class="nt">NonemptyClassRangesNoDash</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">ClassAtomNoDash</span><sub class="g-params">[?U]</sub> <code class="t">-</code> <span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub> <span class="nt">ClassRanges</span><sub class="g-params">[?U]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">ClassAtom</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><code class="t">-</code></div>
      <div class="rhs"><span class="nt">ClassAtomNoDash</span><sub class="g-params">[?U]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">ClassAtomNoDash</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">]</code> <span class="grhsmod">or</span> <code class="t">-</code></div>
      <div class="rhs"><code class="t">\</code> <span class="nt">ClassEscape</span><sub class="g-params">[?U]</sub></div>
    </div>

    <div class="gp">
      <div class="gsumxref"><a href="sec-text-processing#sec-patterns">See 21.2.1</a></div>
      <div class="lhs"><span class="nt">ClassEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span> </div>
      <div class="rhs"><span class="nt">DecimalEscape</span></div>
      <div class="rhs"><code class="t">b</code></div>
      <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">-</code></div>
      <div class="rhs"><span class="nt">CharacterEscape</span><sub class="g-params">[?U]</sub></div>
      <div class="rhs"><span class="nt">CharacterClassEscape</span></div>
    </div>
  </section>
</section>

