<section id="sec-ecmascript-language-lexical-grammar">
  <div class="front">
    <h1 id="sec-11" title="11"> ECMAScript Language: Lexical Grammar</h1><p>The source text of an ECMAScript <span class="nt">Script</span> or <span class="nt">Module</span> is first converted into a
    sequence of input elements, which are tokens, line terminators, comments, or white space. The source text is scanned from left
    to right, repeatedly taking the longest possible sequence of code points as the next input element.</p>

    <p>There are several situations where the identification of lexical input elements is sensitive to the syntactic grammar
    context that is consuming the input elements. This requires multiple goal symbols for the lexical grammar. The <span class="nt">InputElementRegExpOrTemplateTail</span> goal is used in syntactic grammar contexts where a
    <var>RegularExpressionLiteral,</var> a <var>TemplateMiddle,</var> or a <span class="nt">TemplateTail</span> is permitted. The
    <span class="nt">InputElementRegExp</span> goal symbol is used in all syntactic grammar contexts where a <span class="nt">RegularExpressionLiteral</span> is permitted but neither a <var>TemplateMiddle,</var> nor a <span class="nt">TemplateTail</span> is permitted. The <span class="nt">InputElementTemplateTail</span> goal is used in all
    syntactic grammar contexts where a <span class="nt">TemplateMiddle</span> or a <span class="nt">TemplateTail</span> is
    permitted but a <span class="nt">RegularExpressionLiteral</span> is not permitted. In all other contexts, <span class="nt">InputElementDiv</span> is used as the lexical goal symbol.</p>

    <div class="note">
      <p><span class="nh">NOTE</span> The use of multiple lexical goals ensures that there are no lexical ambiguities that would
      affect <a href="#sec-automatic-semicolon-insertion">automatic semicolon insertion</a>. For example, there are no syntactic
      grammar contexts where both a leading division or division-assignment, and a leading <span class="nt">RegularExpressionLiteral</span> are permitted. This is not affected by semicolon insertion (<a href="#sec-automatic-semicolon-insertion">see 11.9</a>); in examples such as the following:</p>

      <p><code>a = b<br />/hi/g.exec(c).map(d);</code></p>

      <p>where the first non-whitespace, non-comment code point after a <span class="nt">LineTerminator</span> is U+002F (SOLIDUS)
      and the syntactic context allows division or division-assignment, no semicolon is inserted at the <span class="nt">LineTerminator</span>. That is, the above example is interpreted in the same way as:</p>

      <p><code>a = b / hi / g.exec(c).map(d);</code></p>

      <p />
    </div>

    <h2>Syntax</h2>

    <div class="gp">
      <div class="lhs"><span class="nt">InputElementDiv</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">WhiteSpace</span></div>
      <div class="rhs"><span class="nt">LineTerminator</span></div>
      <div class="rhs"><span class="nt">Comment</span></div>
      <div class="rhs"><span class="nt">CommonToken</span></div>
      <div class="rhs"><span class="nt">DivPunctuator</span></div>
      <div class="rhs"><span class="nt">RightBracePunctuator</span></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">InputElementRegExp</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">WhiteSpace</span></div>
      <div class="rhs"><span class="nt">LineTerminator</span></div>
      <div class="rhs"><span class="nt">Comment</span></div>
      <div class="rhs"><span class="nt">CommonToken</span></div>
      <div class="rhs"><span class="nt">RightBracePunctuator</span></div>
      <div class="rhs"><span class="nt">RegularExpressionLiteral</span></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">InputElementRegExpOrTemplateTail</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">WhiteSpace</span></div>
      <div class="rhs"><span class="nt">LineTerminator</span></div>
      <div class="rhs"><span class="nt">Comment</span></div>
      <div class="rhs"><span class="nt">CommonToken</span></div>
      <div class="rhs"><span class="nt">RegularExpressionLiteral</span></div>
      <div class="rhs"><span class="nt">TemplateSubstitutionTail</span></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">InputElementTemplateTail</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">WhiteSpace</span></div>
      <div class="rhs"><span class="nt">LineTerminator</span></div>
      <div class="rhs"><span class="nt">Comment</span></div>
      <div class="rhs"><span class="nt">CommonToken</span></div>
      <div class="rhs"><span class="nt">DivPunctuator</span></div>
      <div class="rhs"><span class="nt">TemplateSubstitutionTail</span></div>
    </div>
  </div>

  <section id="sec-unicode-format-control-characters">
    <h2 id="sec-11.1" title="11.1"> Unicode Format-Control Characters</h2><p>The Unicode format-control characters (i.e., the characters in category &ldquo;Cf&rdquo; in the Unicode Character Database
    such as LEFT-TO-RIGHT MARK or RIGHT-TO-LEFT MARK) are control codes used to control the formatting of a range of text in the
    absence of higher-level protocols for this (such as mark-up languages).</p>

    <p>It is useful to allow format-control characters in source text to facilitate editing and display. All format control
    characters may be used within comments, and within string literals, template literals,  and regular expression literals.</p>

    <p>U+200C <span style="font-family: Times New Roman">(</span>ZERO WIDTH NON-JOINER<span style="font-family: Times New     Roman">)</span> and U+200D <span style="font-family: Times New Roman">(</span>ZERO WIDTH JOINER<span style="font-family: Times     New Roman">)</span> are format-control characters that are used to make necessary distinctions when forming words or phrases
    in certain languages. In ECMAScript source text these code points may also be used in an <span class="nt">IdentifierName</span> (<a href="#sec-identifier-names">see 11.6.1</a>) after the first character.</p>

    <p>U+FEFF <span style="font-family: Times New Roman">(</span>ZERO WIDTH NO-BREAK SPACE<span style="font-family: Times New     Roman">)</span> is a format-control character used primarily at the start of a text to mark it as Unicode and to allow
    detection of the text's encoding and byte order. &lt;ZWNBSP&gt; characters intended for this purpose can sometimes also appear
    after the start of a text, for example as a result of concatenating files. In ECMAScript source text &lt;ZWNBSP&gt; code
    points are treated as white space characters (<a href="#sec-white-space">see 11.2</a>).</p>

    <p>The special treatment of certain format-control characters outside of comments, string literals, and regular expression
    literals is summarized in <a href="#table-31">Table 31</a>.</p>

    <figure>
      <figcaption><span id="table-31">Table 31</span> &mdash; Format-Control Code Point Usage</figcaption>
      <table class="real-table">
        <tr>
          <th>Code Point</th>
          <th>Name</th>
          <th>Abbreviation</th>
          <th>Usage</th>
        </tr>
        <tr>
          <td><code>U+200C</code></td>
          <td>ZERO WIDTH NON-JOINER</td>
          <td>&lt;ZWNJ&gt;</td>
          <td><i>IdentifierPart</i></td>
        </tr>
        <tr>
          <td><code>U+200D</code></td>
          <td>ZERO WIDTH JOINER</td>
          <td>&lt;ZWJ&gt;</td>
          <td><i>IdentifierPart</i></td>
        </tr>
        <tr>
          <td><code>U+FEFF</code></td>
          <td>ZERO WIDTH NO-BREAK SPACE</td>
          <td>&lt;ZWNBSP&gt;</td>
          <td><i>WhiteSpace</i></td>
        </tr>
      </table>
    </figure>
  </section>

  <section id="sec-white-space">
    <h2 id="sec-11.2" title="11.2"> White
        Space</h2><p>White space code points are used to improve source text readability and to separate tokens (indivisible lexical units) from
    each other, but are otherwise insignificant. White space code points may occur between any two tokens and at the start or end
    of input. White space code points may occur within a <span class="nt">StringLiteral</span>, a <span class="nt">RegularExpressionLiteral</span>, a <span class="nt">Template</span>, or a <span class="nt">TemplateSubstitutionTail</span> where they are considered significant code points forming part of a literal value.
    They may also occur within a <span class="nt">Comment</span>, but cannot appear within any other kind of token.</p>

    <p>The ECMAScript white space code points are listed in <a href="#table-32">Table 32</a>.</p>

    <figure>
      <figcaption><span id="table-32">Table 32</span> &mdash; White Space Code Points</figcaption>
      <table class="real-table">
        <tr>
          <th>Code Point</th>
          <th>Name</th>
          <th>Abbreviation</th>
        </tr>
        <tr>
          <td><code>U+0009</code></td>
          <td>CHARACTER TABULATION</td>
          <td>&lt;TAB&gt;</td>
        </tr>
        <tr>
          <td><code>U+000B</code></td>
          <td>LINE TABULATION</td>
          <td>&lt;VT&gt;</td>
        </tr>
        <tr>
          <td><code>U+000C</code></td>
          <td>FORM FEED (FF)</td>
          <td>&lt;FF&gt;</td>
        </tr>
        <tr>
          <td><code>U+0020</code></td>
          <td>SPACE</td>
          <td>&lt;SP&gt;</td>
        </tr>
        <tr>
          <td><code>U+00A0</code></td>
          <td>NO-BREAK SPACE</td>
          <td>&lt;NBSP&gt;</td>
        </tr>
        <tr>
          <td><code>U+FEFF</code></td>
          <td>ZERO WIDTH NO-BREAK SPACE</td>
          <td>&lt;ZWNBSP&gt;</td>
        </tr>
        <tr>
          <td>Other category &ldquo;Zs&rdquo;</td>
          <td>Any other Unicode &ldquo;Separator, space&rdquo; code point</td>
          <td>&lt;USP&gt;</td>
        </tr>
      </table>
    </figure>

    <p>ECMAScript implementations must recognize as <span class="nt">WhiteSpace</span> code points listed in the &ldquo;Separator,
    space&rdquo; (Zs) category by Unicode 5.1. ECMAScript implementations may also recognize as <span class="nt">WhiteSpace</span>
    additional category Zs code points from subsequent editions of the Unicode Standard.</p>

    <div class="note">
      <p><span class="nh">NOTE</span> Other than for the code points listed in <a href="#table-32">Table 32</a>, ECMAScript <span class="nt">WhiteSpace</span> intentionally excludes all code points that have the Unicode &ldquo;White_Space&rdquo; property
      but which are not classified in category &ldquo;Zs&rdquo;.</p>
    </div>

    <h2>Syntax</h2>

    <div class="gp">
      <div class="lhs"><span class="nt">WhiteSpace</span> <span class="geq">::</span></div>
      <div class="rhs">&lt;TAB&gt;</div>
      <div class="rhs">&lt;VT&gt;</div>
      <div class="rhs">&lt;FF&gt;</div>
      <div class="rhs">&lt;SP&gt;</div>
      <div class="rhs">&lt;NBSP&gt;</div>
      <div class="rhs">&lt;ZWNBSP&gt;</div>
      <div class="rhs">&lt;USP&gt;</div>
    </div>
  </section>

  <section id="sec-line-terminators">
    <h2 id="sec-11.3" title="11.3"> Line
        Terminators</h2><p>Like white space code points, line terminator code points are used to improve source text readability and to separate
    tokens (indivisible lexical units) from each other. However, unlike white space code points, line terminators have some
    influence over the behaviour of the syntactic grammar. In general, line terminators may occur between any two tokens, but
    there are a few places where they are forbidden by the syntactic grammar. Line terminators also affect the process of <a href="#sec-automatic-semicolon-insertion">automatic semicolon insertion</a> (<a href="#sec-automatic-semicolon-insertion">11.9</a>). A line terminator cannot occur within any token except a <span class="nt">StringLiteral</span>, <span class="nt">Template</span>, or <span class="nt">TemplateSubstitutionTail</span>. Line
    terminators may only occur within a <span class="nt">StringLiteral</span> token as part of a <span class="nt">LineContinuation</span>.</p>

    <p>A line terminator can occur within a <span class="nt">MultiLineComment</span> (<a href="#sec-comments">11.4</a>) but cannot
    occur within a <span class="nt">SingleLineComment</span>.</p>

    <p>Line terminators are included in the set of white space code points that are matched by the <code>\s</code> class in
    regular expressions.</p>

    <p>The ECMAScript line terminator code points are listed in <a href="#table-33">Table 33</a>.</p>

    <figure>
      <figcaption><span id="table-33">Table 33</span> &mdash; Line Terminator Code Points</figcaption>
      <table class="real-table">
        <tr>
          <th>Code Point</th>
          <th>Unicode Name</th>
          <th>Abbreviation</th>
        </tr>
        <tr>
          <td><code>U+000A</code></td>
          <td>LINE FEED (LF)</td>
          <td>&lt;LF&gt;</td>
        </tr>
        <tr>
          <td><code>U+000D</code></td>
          <td>CARRIAGE RETURN (CR)</td>
          <td>&lt;CR&gt;</td>
        </tr>
        <tr>
          <td><code>U+2028</code></td>
          <td>LINE SEPARATOR</td>
          <td>&lt;LS&gt;</td>
        </tr>
        <tr>
          <td><code>U+2029</code></td>
          <td>PARAGRAPH SEPARATOR</td>
          <td>&lt;PS&gt;</td>
        </tr>
      </table>
    </figure>

    <p>Only the Unicode code points in <a href="#table-33">Table 33</a> are treated as line terminators. Other new line or line
    breaking Unicode code points are not treated as line terminators but are treated as white space if they meet the requirements
    listed in <a href="#table-32">Table 32</a>. The sequence &lt;CR&gt;&lt;LF&gt; is commonly used as a line terminator. It should
    be considered a single <span class="nt">SourceCharacter</span> for the purpose of reporting line numbers.</p>

    <h2>Syntax</h2>

    <div class="gp">
      <div class="lhs"><span class="nt">LineTerminator</span> <span class="geq">::</span></div>
      <div class="rhs">&lt;LF&gt;</div>
      <div class="rhs">&lt;CR&gt;</div>
      <div class="rhs">&lt;LS&gt;</div>
      <div class="rhs">&lt;PS&gt;</div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">LineTerminatorSequence</span> <span class="geq">::</span></div>
      <div class="rhs">&lt;LF&gt;</div>
      <div class="rhs">&lt;CR&gt; <span class="grhsannot">[lookahead &ne; &lt;LF&gt; ]</span></div>
      <div class="rhs">&lt;LS&gt;</div>
      <div class="rhs">&lt;PS&gt;</div>
      <div class="rhs">&lt;CR&gt; &lt;LF&gt;</div>
    </div>
  </section>

  <section id="sec-comments">
    <h2 id="sec-11.4" title="11.4"> Comments</h2><p>Comments can be either single or multi-line. Multi-line comments cannot nest.</p>

    <p>Because a single-line comment can contain any Unicode code point except a <span class="nt">LineTerminator</span> code
    point, and because of the general rule that a token is always as long as possible, a single-line comment always consists of
    all code points from the <code>//</code> marker to the end of the line. However, the <span class="nt">LineTerminator</span> at
    the end of the line is not considered to be part of the single-line comment; it is recognized separately by the lexical
    grammar and becomes part of the stream of input elements for the syntactic grammar. This point is very important, because it
    implies that the presence or absence of single-line comments does not affect the process of <a href="#sec-automatic-semicolon-insertion">automatic semicolon insertion</a> (<a href="#sec-automatic-semicolon-insertion">see
    11.9</a>).</p>

    <p>Comments behave like white space and are discarded except that, if a <span class="nt">MultiLineComment</span> contains a
    line terminator code point, then the entire comment is considered to be a <span class="nt">LineTerminator</span> for purposes
    of parsing by the syntactic grammar.</p>

    <h2>Syntax</h2>

    <div class="gp">
      <div class="lhs"><span class="nt">Comment</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">MultiLineComment</span></div>
      <div class="rhs"><span class="nt">SingleLineComment</span></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">MultiLineComment</span> <span class="geq">::</span></div>
      <div class="rhs"><code class="t">/*</code> <span class="nt">MultiLineCommentChars</span><sub class="g-opt">opt</sub> <code class="t">*/</code></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">MultiLineCommentChars</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">MultiLineNotAsteriskChar</span> <span class="nt">MultiLineCommentChars</span><sub class="g-opt">opt</sub></div>
      <div class="rhs"><code class="t">*</code> <span class="nt">PostAsteriskCommentChars</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">PostAsteriskCommentChars</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">MultiLineNotForwardSlashOrAsteriskChar</span> <span class="nt">MultiLineCommentChars</span><sub class="g-opt">opt</sub></div>
      <div class="rhs"><code class="t">*</code> <span class="nt">PostAsteriskCommentChars</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">MultiLineNotAsteriskChar</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <code class="t">*</code></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">MultiLineNotForwardSlashOrAsteriskChar</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">/</code> <span class="grhsmod">or</span> <code class="t">*</code></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">SingleLineComment</span> <span class="geq">::</span></div>
      <div class="rhs"><code class="t">//</code> <span class="nt">SingleLineCommentChars</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">SingleLineCommentChars</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">SingleLineCommentChar</span> <span class="nt">SingleLineCommentChars</span><sub class="g-opt">opt</sub></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">SingleLineCommentChar</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <span class="nt">LineTerminator</span></div>
    </div>
  </section>

  <section id="sec-tokens">
    <h2 id="sec-11.5" title="11.5"> Tokens</h2><h2>Syntax</h2>

    <div class="gp">
      <div class="lhs"><span class="nt">CommonToken</span> <span class="geq">::</span></div>
      <div class="rhs"><span class="nt">IdentifierName</span></div>
      <div class="rhs"><span class="nt">Punctuator</span></div>
      <div class="rhs"><span class="nt">NumericLiteral</span></div>
      <div class="rhs"><span class="nt">StringLiteral</span></div>
      <div class="rhs"><span class="nt">Template</span></div>
    </div>

    <div class="note">
      <p><span class="nh">NOTE</span> The <span class="nt">DivPunctuator</span>, <span class="nt">RegularExpressionLiteral</span>,
      <var>RightBracePunctuator,</var> and <span class="nt">TemplateSubstitutionTail</span> productions derive additional tokens
      that are not included in the <span class="nt">CommonToken</span> production.</p>
    </div>
  </section>

  <section id="sec-names-and-keywords">
    <div class="front">
      <h2 id="sec-11.6" title="11.6"> Names
          and Keywords</h2><p><span class="nt">IdentifierName</span> and <span class="nt">ReservedWord</span> are tokens that are interpreted according
      to the Default Identifier Syntax given in Unicode Standard Annex #31, Identifier and Pattern Syntax, with some small
      modifications. <span class="nt">ReservedWord</span>  is an enumerated subset of <span style="font-family: Times New       Roman"><i>IdentifierName</i>.</span> The syntactic grammar defines <span class="nt">Identifier</span> as an <span class="nt">IdentifierName</span> that is not a <span class="nt">ReservedWord</span> (<a href="#sec-reserved-words">see
      11.6.2</a>). The Unicode identifier grammar is based on character properties specified by the Unicode Standard. The Unicode
      code points in the specified categories in version 5.1.0 of the Unicode standard must be treated as in those categories by
      all conforming ECMAScript implementations. ECMAScript implementations may recognize identifier code points defined in later
      editions of the Unicode Standard.</p>

      <div class="note">
        <p><span class="nh">NOTE 1</span> This standard specifies specific code point additions: U+0024 (DOLLAR SIGN) and U+005F
        (LOW LINE) are permitted anywhere in an <span class="nt">IdentifierName</span>, and the code points U+200C (ZERO WIDTH
        NON-JOINER) and U+200D (ZERO WIDTH JOINER) are permitted anywhere after the first code point of an <span class="nt">IdentifierName</span>.</p>
      </div>

      <p>Unicode escape sequences are permitted in an <span class="nt">IdentifierName</span>, where they contribute a single
      Unicode code point to the <span class="nt">IdentifierName</span>. The code point is expressed by the <span class="nt">HexDigits</span> of the <span class="nt">UnicodeEscapeSequence</span> (<a href="#sec-literals-string-literals">see 11.8.4</a>). The <code>\</code> preceding the <span class="nt">UnicodeEscapeSequence</span> and the <code>u</code> and <code>{ }</code> code units, if they appear, do not
      contribute code points to the <span class="nt">IdentifierName</span>. A <span class="nt">UnicodeEscapeSequence</span> cannot
      be used to put a code point into an <span class="nt">IdentifierName</span> that would otherwise be illegal. In other words,
      if a <code>\</code> <span class="nt">UnicodeEscapeSequence</span> sequence were replaced by the <span class="nt">SourceCharacter</span> it contributes, the result must still be a valid <span class="nt">IdentifierName</span>
      that has the exact same sequence of <span class="nt">SourceCharacter</span> elements as the original <span class="nt">IdentifierName</span>. All interpretations of <span class="nt">IdentifierName</span> within this specification
      are based upon their actual code points regardless of whether or not an escape sequence was used to contribute any
      particular code point.</p>

      <p>Two <span class="nt">IdentifierName</span> that are canonically equivalent according to the Unicode standard are
      <i>not</i> equal unless, after replacement of each <span class="nt">UnicodeEscapeSequence</span>, they are represented by
      the exact same sequence of code points.</p>

      <h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">IdentifierName</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">IdentifierStart</span></div>
        <div class="rhs"><span class="nt">IdentifierName</span> <span class="nt">IdentifierPart</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">IdentifierStart</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">UnicodeIDStart</span></div>
        <div class="rhs"><code class="t">$</code></div>
        <div class="rhs"><code class="t">_</code></div>
        <div class="rhs"><code class="t">\</code> <span class="nt">UnicodeEscapeSequence</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">IdentifierPart</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">UnicodeIDContinue</span></div>
        <div class="rhs"><code class="t">$</code></div>
        <div class="rhs"><code class="t">_</code></div>
        <div class="rhs"><code class="t">\</code> <span class="nt">UnicodeEscapeSequence</span></div>
        <div class="rhs">&lt;ZWNJ&gt;</div>
        <div class="rhs">&lt;ZWJ&gt;</div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">UnicodeIDStart</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="gprose">any Unicode code point with the Unicode property &ldquo;ID_Start&rdquo;</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">UnicodeIDContinue</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="gprose">any Unicode code point with the Unicode property &ldquo;ID_Continue&rdquo;</span></div>
      </div>

      <p>The definitions of the nonterminal <span class="nt">UnicodeEscapeSequence</span> is given in <a href="#sec-literals-string-literals">11.8.4</a>.</p>

      <div class="note">
        <p><span class="nh">NOTE 2</span> The sets of code points with Unicode properties &ldquo;ID_Start&rdquo; and
        &ldquo;ID_Continue&rdquo; include, respectively, the code points with Unicode properties &ldquo;Other_ID_Start&rdquo; and
        &ldquo;Other_ID_Continue&rdquo;.</p>
      </div>
    </div>

    <section id="sec-identifier-names">
      <div class="front">
        <h3 id="sec-11.6.1" title="11.6.1">
            Identifier Names</h3></div>

      <section id="sec-identifier-names-static-semantics-early-errors">
        <h4 id="sec-11.6.1.1" title="11.6.1.1"> Static Semantics: Early Errors</h4><div class="gp prod"><span class="nt">IdentifierStart</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">UnicodeEscapeSequence</span></div>
        <ul>
          <li>
            <p>It is a Syntax Error if <span style="font-family: Times New Roman">SV(<i>UnicodeEscapeSequence</i>)</span> is none
            of <code>"$"</code>, or <code>"_"</code>, or the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of a code point matched by the <span class="nt">UnicodeIDStart</span> lexical
            grammar production.</p>
          </li>
        </ul>
        <div class="gp prod"><span class="nt">IdentifierPart</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">UnicodeEscapeSequence</span></div>
        <ul>
          <li>
            <p>It is a Syntax Error if <span style="font-family: Times New Roman">SV(<i>UnicodeEscapeSequence</i>)</span> is none
            of <code>"$"</code>, or <code>"_"</code>, or the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of either &lt;ZWNJ&gt; or &lt;ZWJ&gt;, or the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> of a Unicode code point that would be matched by the <span class="nt">UnicodeIDContinue</span> lexical grammar production.</p>
          </li>
        </ul>
      </section>

      <section id="sec-identifier-names-static-semantics-stringvalue">
        <h4 id="sec-11.6.1.2" title="11.6.1.2"> Static Semantics: </h4><p>See also: <a href="#sec-string-literals-static-semantics-stringvalue">11.8.4.2</a>, <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-stringvalue">12.1.4</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">IdentifierName</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">IdentifierStart</span></div>
          <div class="rhs"><span class="nt">IdentifierName</span> <span class="nt">IdentifierPart</span></div>
        </div>

        <ol class="proc">
          <li>Return the String value consisting of the sequence of code units corresponding to <i>IdentifierName</i>. In
              determining the sequence any occurrences of <code>\</code> <i>UnicodeEscapeSequence</i> are first replaced with the
              code point represented by the <i>UnicodeEscapeSequence</i> and then the code points of the entire
              <i>IdentifierName</i> are converted to code units by <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) each code point.</li>
        </ol>
      </section>
    </section>

    <section id="sec-reserved-words">
      <div class="front">
        <h3 id="sec-11.6.2" title="11.6.2">
            Reserved Words</h3><p>A reserved word is an <span class="nt">IdentifierName</span> that cannot be used as an <span class="nt">Identifier</span>.</p>

        <h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">ReservedWord</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">Keyword</span></div>
          <div class="rhs"><span class="nt">FutureReservedWord</span></div>
          <div class="rhs"><span class="nt">NullLiteral</span></div>
          <div class="rhs"><span class="nt">BooleanLiteral</span></div>
        </div>

        <div class="note">
          <p><span class="nh">NOTE</span> The <span class="nt">ReservedWord</span> definitions are specified as literal sequences
          of specific <span class="nt">SourceCharacter</span> elements. A code point in a <span class="nt">ReservedWord</span>
          cannot be expressed by a <code>\</code> <span class="nt">UnicodeEscapeSequence</span>.</p>
        </div>
      </div>

      <section id="sec-keywords">
        <h4 id="sec-11.6.2.1" title="11.6.2.1">
            Keywords</h4><p>The following tokens are ECMAScript keywords and may not be used as <span class="nt">Identifiers</span> in ECMAScript
        programs.</p>

        <h2>Syntax</h2>
        <div class="gp prod"><span class="nt">Keyword</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>

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

        <div class="note">
          <p><span class="nh">NOTE</span> In some contexts <code>yield</code> is given the semantics of an <span class="nt">Identifier</span>. See <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-early-errors">12.1.1</a>. In <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>, <code>let</code> and <code>static</code> are treated as reserved
          keywords through static semantic restrictions (see <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-early-errors">12.1.1</a>,
          <a href="sec-ecmascript-language-statements-and-declarations#sec-let-and-const-declarations-static-semantics-early-errors">13.3.1.1</a>, <a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements-static-semantics-early-errors">13.7.5.1</a>, and <a href="sec-ecmascript-language-functions-and-classes#sec-class-definitions-static-semantics-early-errors">14.5.1</a>) rather than the lexical grammar.</p>
        </div>
      </section>

      <section id="sec-future-reserved-words">
        <h4 id="sec-11.6.2.2" title="11.6.2.2"> Future Reserved Words</h4><p>The following tokens are reserved for used as keywords in future language extensions.</p>

        <h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">FutureReservedWord</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">enum</code></div>
          <div class="rhs"><code class="t">await</code></div>
        </div>

        <p><code>await</code> is only treated as a <span class="nt">FutureReservedWord</span> when <span class="nt">Module</span>
        is the goal symbol of the syntactic grammar.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Use of the following tokens within <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>
          (<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">see 10.2.1</a>) is also reserved. That usage is restricted using static semantic
          restrictions (<a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-early-errors">see 12.1.1</a>) rather than the lexical
          grammar:</p>
        </div>

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
      </section>
    </section>
  </section>

  <section id="sec-punctuators">
    <h2 id="sec-11.7" title="11.7">
        Punctuators</h2><h2>Syntax</h2>
    <div class="gp prod"><span class="nt">Punctuator</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>

    <figure>
      <table class="lightweight-table">
        <tr>
          <td><code>{</code></td>
          <td><code>(</code></td>
          <td><code>)</code></td>
          <td><code>[</code></td>
          <td><code>]</code></td>
          <td><code>.</code></td>
        </tr>
        <tr>
          <td><code>...</code></td>
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
      <div class="lhs"><span class="nt">DivPunctuator</span> <span class="geq">::</span></div>
      <div class="rhs"><code class="t">/</code></div>
      <div class="rhs"><code class="t">/=</code></div>
    </div>

    <div class="gp">
      <div class="lhs"><span class="nt">RightBracePunctuator</span> <span class="geq">::</span></div>
      <div class="rhs"><code class="t">}</code></div>
    </div>
  </section>

  <section id="sec-ecmascript-language-lexical-grammar-literals">
    <div class="front">
      <h2 id="sec-11.8" title="11.8"> Literals</h2></div>

    <section id="sec-null-literals">
      <h3 id="sec-11.8.1" title="11.8.1"> Null
          Literals</h3><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">NullLiteral</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">null</code></div>
      </div>
    </section>

    <section id="sec-boolean-literals">
      <h3 id="sec-11.8.2" title="11.8.2">
          Boolean Literals</h3><h2>Syntax</h2>

      <div class="gp">
        <div class="lhs"><span class="nt">BooleanLiteral</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">true</code></div>
        <div class="rhs"><code class="t">false</code></div>
      </div>
    </section>

    <section id="sec-literals-numeric-literals">
      <div class="front">
        <h3 id="sec-11.8.3" title="11.8.3"> Numeric Literals</h3><h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">NumericLiteral</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">DecimalLiteral</span></div>
          <div class="rhs"><span class="nt">BinaryIntegerLiteral</span></div>
          <div class="rhs"><span class="nt">OctalIntegerLiteral</span></div>
          <div class="rhs"><span class="nt">HexIntegerLiteral</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">DecimalLiteral</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">DecimalIntegerLiteral</span> <code class="t">.</code> <span class="nt">DecimalDigits</span><sub class="g-opt">opt</sub> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
          <div class="rhs"><code class="t">.</code> <span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
          <div class="rhs"><span class="nt">DecimalIntegerLiteral</span> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">DecimalIntegerLiteral</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">0</code></div>
          <div class="rhs"><span class="nt">NonZeroDigit</span> <span class="nt">DecimalDigits</span><sub class="g-opt">opt</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">DecimalDigits</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">DecimalDigit</span></div>
          <div class="rhs"><span class="nt">DecimalDigits</span> <span class="nt">DecimalDigit</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NonZeroDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ExponentPart</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">ExponentIndicator</span> <span class="nt">SignedInteger</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ExponentIndicator</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">e</code> <code class="t">E</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">SignedInteger</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">DecimalDigits</span></div>
          <div class="rhs"><code class="t">+</code> <span class="nt">DecimalDigits</span></div>
          <div class="rhs"><code class="t">-</code> <span class="nt">DecimalDigits</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BinaryIntegerLiteral</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">0b</code> <span class="nt">BinaryDigits</span></div>
          <div class="rhs"><code class="t">0B</code> <span class="nt">BinaryDigits</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BinaryDigits</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">BinaryDigit</span></div>
          <div class="rhs"><span class="nt">BinaryDigits</span> <span class="nt">BinaryDigit</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BinaryDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">0</code> <code class="t">1</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">OctalIntegerLiteral</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">0o</code> <span class="nt">OctalDigits</span></div>
          <div class="rhs"><code class="t">0O</code> <span class="nt">OctalDigits</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">OctalDigits</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">OctalDigit</span></div>
          <div class="rhs"><span class="nt">OctalDigits</span> <span class="nt">OctalDigit</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">OctalDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">HexIntegerLiteral</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">0x</code> <span class="nt">HexDigits</span></div>
          <div class="rhs"><code class="t">0X</code> <span class="nt">HexDigits</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">HexDigits</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">HexDigit</span></div>
          <div class="rhs"><span class="nt">HexDigits</span> <span class="nt">HexDigit</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">HexDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code> <code class="t">a</code> <code class="t">b</code> <code class="t">c</code> <code class="t">d</code> <code class="t">e</code> <code class="t">f</code> <code class="t">A</code> <code class="t">B</code> <code class="t">C</code> <code class="t">D</code> <code class="t">E</code> <code class="t">F</code></div>
        </div>

        <p>The <span class="nt">SourceCharacter</span> immediately following a <span class="nt">NumericLiteral</span> must not be
        an <span class="nt">IdentifierStart</span> or <span class="nt">DecimalDigit</span>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> For example:<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code><b>3in</b><br /></code>is an
          error and not the two input elements <code>3</code> and <code>in</code>.</p>
        </div>

        <p>A conforming implementation, when processing <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> (<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">see 10.2.1</a>), must not extend, as described in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-additional-syntax-numeric-literals">B.1.1</a>, the syntax of <span class="nt">NumericLiteral</span> to include
        <i>Legacy<span style="font-family: Times New Roman">OctalIntegerLiteral</span></i>, nor extend the syntax of <span class="nt">DecimalIntegerLiteral</span> to include <span class="nt">NonOctalDecimalIntegerLiteral</span>.</p>
      </div>

      <section id="sec-static-semantics-mv">
        <h4 id="sec-11.8.3.1" title="11.8.3.1"> Static Semantics: MV</h4><p>A numeric literal stands for a value of the Number type. This value is determined in two steps: first, a mathematical
        value (MV) is derived from the literal; second, this mathematical value is rounded as described below.</p>

        <ul>
          <li>
            <p>The MV of <span class="prod"><span class="nt">NumericLiteral</span> <span class="geq">::</span> <span class="nt">DecimalLiteral</span></span> is the MV of <i>DecimalLiteral</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">NumericLiteral</span> <span class="geq">::</span> <span class="nt">BinaryIntegerLiteral</span></span> is the MV of <i>BinaryIntegerLiteral</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">NumericLiteral</span> <span class="geq">::</span> <span class="nt">OctalIntegerLiteral</span></span> is the MV of <i>OctalIntegerLiteral</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">NumericLiteral</span> <span class="geq">::</span> <span class="nt">HexIntegerLiteral</span></span> is the MV of <i>HexIntegerLiteral</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalLiteral</span> <span class="geq">::</span> <span class="nt">DecimalIntegerLiteral</span> <code class="t">.</code></span> is the MV of <i>DecimalIntegerLiteral</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalLiteral</span> <span class="geq">::</span> <span class="nt">DecimalIntegerLiteral</span> <code class="t">.</code> <span class="nt">DecimalDigits</span></span> is the
            MV of <i>DecimalIntegerLiteral</i> plus (the MV of <i>DecimalDigits</i> &times; 10<sup>&ndash;<i>n</i></sup>), where
            <i>n</i> is the number of code points in <i>DecimalDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalLiteral</span> <span class="geq">::</span> <span class="nt">DecimalIntegerLiteral</span> <code class="t">.</code> <span class="nt">ExponentPart</span></span> is the MV
            of <i>DecimalIntegerLiteral</i> &times; 10<sup><i>e</i></sup>, where <i>e</i> is the MV of <i>ExponentPart</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalLiteral</span> <span class="geq">::</span> <span class="nt">DecimalIntegerLiteral</span> <code class="t">.</code> <span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span></span> is (the MV of <i>DecimalIntegerLiteral</i> plus (the MV of <i>DecimalDigits</i>
            &times; 10<sup>&ndash;<i>n</i></sup>)) &times; 10<sup><i>e</i></sup>, where <i>n</i> is the number of code points in
            <i>DecimalDigits</i> and <i>e</i> is the MV of <i>ExponentPart</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalLiteral</span> <span class="geq">::</span> <code class="t">.</code> <span class="nt">DecimalDigits</span></span> is the MV of <i>DecimalDigits</i> &times;
            10<sup>&ndash;<i>n</i></sup>, where <i>n</i> is the number of code points in <i>DecimalDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalLiteral</span> <span class="geq">::</span> <code class="t">.</code> <span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span></span> is the MV of
            <i>DecimalDigits</i> &times; 10<sup><i>e</i>&ndash;<i>n</i></sup>, where <i>n</i> is the number of code points in
            <i>DecimalDigits</i> and <i>e</i> is the MV of <i>ExponentPart</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalLiteral</span> <span class="geq">::</span> <span class="nt">DecimalIntegerLiteral</span></span> is the MV of <i>DecimalIntegerLiteral</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalLiteral</span> <span class="geq">::</span> <span class="nt">DecimalIntegerLiteral</span> <span class="nt">ExponentPart</span></span> is the MV of
            <i>DecimalIntegerLiteral</i> &times; 10<sup><i>e</i></sup>, where <i>e</i> is the MV of <i>ExponentPart</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalIntegerLiteral</span> <span class="geq">::</span> <code class="t">0</code></span> is 0.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalIntegerLiteral</span> <span class="geq">::</span> <span class="nt">NonZeroDigit</span></span> is the MV of <i>NonZeroDigit.</i></p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalIntegerLiteral</span> <span class="geq">::</span> <span class="nt">NonZeroDigit</span> <span class="nt">DecimalDigits</span></span> is (the MV of <i>NonZeroDigit</i> &times;
            10<sup><i>n</i></sup>) plus the MV of <i>DecimalDigits</i>, where <i>n</i> is the number of code points in
            <i>DecimalDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigits</span> <span class="geq">::</span> <span class="nt">DecimalDigit</span></span> is the MV of <i>DecimalDigit</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigits</span> <span class="geq">::</span> <span class="nt">DecimalDigits</span> <span class="nt">DecimalDigit</span></span> is (the MV of <i>DecimalDigits</i> &times;
            10) plus the MV of <i>DecimalDigit</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">ExponentPart</span> <span class="geq">::</span> <span class="nt">ExponentIndicator</span> <span class="nt">SignedInteger</span></span> is the MV of
            <i>SignedInteger</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">SignedInteger</span> <span class="geq">::</span> <span class="nt">DecimalDigits</span></span> is the MV of <i>DecimalDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">SignedInteger</span> <span class="geq">::</span> <code class="t">+</code> <span class="nt">DecimalDigits</span></span> is the MV of <i>DecimalDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">SignedInteger</span> <span class="geq">::</span> <code class="t">-</code> <span class="nt">DecimalDigits</span></span> is the negative of the MV of <i>DecimalDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <code class="t">0</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">0</code></span> or of <span class="prod"><span class="nt">OctalDigit</span> <span class="geq">::</span>
            <code class="t">0</code></span> or of <span class="prod"><span class="nt">BinaryDigit</span> <span class="geq">::</span> <code class="t">0</code></span> is 0.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <code class="t">1</code></span> or of <span class="prod"><span class="nt">NonZeroDigit</span> <span class="geq">::</span>
            <code class="t">1</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span>
            <code class="t">1</code></span> or of <span class="prod"><span class="nt">OctalDigit</span> <span class="geq">::</span> <code class="t">1</code></span> or<br />of <span class="prod"><span class="nt">BinaryDigit</span>
            <span class="geq">::</span> <code class="t">1</code></span> is 1.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <code class="t">2</code></span> or of <span class="prod"><span class="nt">NonZeroDigit</span> <span class="geq">::</span>
            <code class="t">2</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span>
            <code class="t">2</code></span> or of <span class="prod"><span class="nt">OctalDigit</span> <span class="geq">::</span> <code class="t">2</code></span>  is 2.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <code class="t">3</code></span> or of <span class="prod"><span class="nt">NonZeroDigit</span> <span class="geq">::</span>
            <code class="t">3</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span>
            <code class="t">3</code></span> or of <span class="prod"><span class="nt">OctalDigit</span> <span class="geq">::</span> <code class="t">3</code></span> is 3.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <code class="t">4</code></span> or of <span class="prod"><span class="nt">NonZeroDigit</span> <span class="geq">::</span>
            <code class="t">4</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span>
            <code class="t">4</code></span> or of <span class="prod"><span class="nt">OctalDigit</span> <span class="geq">::</span> <code class="t">4</code></span> is 4.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <code class="t">5</code></span> or of <span class="prod"><span class="nt">NonZeroDigit</span> <span class="geq">::</span>
            <code class="t">5</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span>
            <code class="t">5</code></span> or of <span class="prod"><span class="nt">OctalDigit</span> <span class="geq">::</span> <code class="t">5</code></span>  is 5.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <code class="t">6</code></span> or of <span class="prod"><span class="nt">NonZeroDigit</span> <span class="geq">::</span>
            <code class="t">6</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span>
            <code class="t">6</code></span> or of <span class="prod"><span class="nt">OctalDigit</span> <span class="geq">::</span> <code class="t">6</code></span> is 6.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <code class="t">7</code></span> or of <span class="prod"><span class="nt">NonZeroDigit</span> <span class="geq">::</span>
            <code class="t">7</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span>
            <code class="t">7</code></span> or of <span class="prod"><span class="nt">OctalDigit</span> <span class="geq">::</span> <code class="t">7</code></span> is 7.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <code class="t">8</code></span> or of <span class="prod"><span class="nt">NonZeroDigit</span> <span class="geq">::</span>
            <code class="t">8</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span>
            <code class="t">8</code></span> is 8.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <code class="t">9</code></span> or of <span class="prod"><span class="nt">NonZeroDigit</span> <span class="geq">::</span>
            <code class="t">9</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span>
            <code class="t">9</code></span> is 9.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">a</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">A</code></span> is 10.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">b</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">B</code></span> is 11.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">c</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">C</code></span> is 12.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">d</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">D</code></span> is 13.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">e</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">E</code></span> is 14.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">f</code></span> or of <span class="prod"><span class="nt">HexDigit</span> <span class="geq">::</span> <code class="t">F</code></span> is 15.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">BinaryIntegerLiteral</span> <span class="geq">::</span> <code class="t">0b</code> <span class="nt">BinaryDigits</span></span> is the MV of <i>BinaryDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">BinaryIntegerLiteral</span> <span class="geq">::</span> <code class="t">0B</code> <span class="nt">BinaryDigits</span></span> is the MV of <i>BinaryDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">BinaryDigits</span> <span class="geq">::</span> <span class="nt">BinaryDigit</span></span> is the MV of <i>BinaryDigit</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">BinaryDigits</span> <span class="geq">::</span> <span class="nt">BinaryDigits</span> <span class="nt">BinaryDigit</span></span> is (the MV of <i>BinaryDigits</i> &times; 2)
            plus the MV of <i>BinaryDigit</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">OctalIntegerLiteral</span> <span class="geq">::</span> <code class="t">0o</code> <span class="nt">OctalDigits</span></span> is the MV of <i>OctalDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">OctalIntegerLiteral</span> <span class="geq">::</span> <code class="t">0O</code> <span class="nt">OctalDigits</span></span> is the MV of <i>OctalDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">OctalDigits</span> <span class="geq">::</span> <span class="nt">OctalDigit</span></span> is the MV of <i>OctalDigit</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">OctalDigits</span> <span class="geq">::</span> <span class="nt">OctalDigits</span> <span class="nt">OctalDigit</span></span> is (the MV of <i>OctalDigits</i> &times; 8)
            plus the MV of <i>OctalDigit</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">HexIntegerLiteral</span> <span class="geq">::</span> <code class="t">0x</code> <span class="nt">HexDigits</span></span> is the MV of <i>HexDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">HexIntegerLiteral</span> <span class="geq">::</span> <code class="t">0X</code> <span class="nt">HexDigits</span></span> is the MV of <i>HexDigits</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">HexDigits</span> <span class="geq">::</span> <span class="nt">HexDigit</span></span> is the MV of <i>HexDigit</i>.</p>
          </li>

          <li>
            <p>The MV of <span class="prod"><span class="nt">HexDigits</span> <span class="geq">::</span> <span class="nt">HexDigits</span> <span class="nt">HexDigit</span></span> is (the MV of <i>HexDigits</i> &times; 16) plus
            the MV of <i>HexDigit</i>.</p>
          </li>
        </ul>

        <p>Once the exact MV for a numeric literal has been determined, it is then rounded to a value of the Number type. If the
        MV is 0, then the rounded value is <span class="value">+0</span>; otherwise, the rounded value must be the Number value
        for the MV (as specified in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-number-type">6.1.6</a>), unless the literal is a <span class="nt">DecimalLiteral</span> and the literal has more than 20 significant digits, in which case the Number value may
        be either the Number value for the MV of a literal produced by replacing each significant digit after the 20th with a
        <code>0</code> digit or the Number value for the MV of a literal produced by replacing each significant digit after the
        20th with a <code>0</code> digit and then incrementing the literal at the 20th significant digit position. A digit is
        <i>significant</i> if it is not part of an <span class="nt">ExponentPart</span> and</p>

        <ul>
          <li>it is not <code>0</code>; or</li>
          <li>there is a nonzero digit to its left and there is a nonzero digit, not in the <i>ExponentPart</i>, to its
              right.</li>
        </ul>
      </section>
    </section>

    <section id="sec-literals-string-literals">
      <div class="front">
        <h3 id="sec-11.8.4" title="11.8.4"> String Literals</h3><div class="note">
          <p><span class="nh">NOTE 1</span> A string literal is zero or more Unicode code points enclosed in single or double
          quotes. Unicode code points may also be represented by an escape sequence. All code points may appear literally in a
          string literal except for the closing quote code points, U+005C (REVERSE SOLIDUS), U+000D (CARRIAGE RETURN), U+2028
          (LINE SEPARATOR), U+2029 (PARAGRAPH SEPARATOR), and U+000A (LINE FEED). Any code points may appear in the form of an
          escape sequence. String literals evaluate to ECMAScript String values. When generating these String values Unicode code
          points are UTF-16 encoded as defined in <a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>. Code points belonging to the Basic
          Multilingual Plane are encoded as a single code unit element of the string. All other code points are encoded as two
          code unit elements of the string.</p>
        </div>

        <h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">StringLiteral</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">"</code> <span class="nt">DoubleStringCharacters</span><sub class="g-opt">opt</sub> <code class="t">"</code></div>
          <div class="rhs"><code class="t">'</code> <span class="nt">SingleStringCharacters</span><sub class="g-opt">opt</sub> <code class="t">'</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">DoubleStringCharacters</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">DoubleStringCharacter</span> <span class="nt">DoubleStringCharacters</span><sub class="g-opt">opt</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">SingleStringCharacters</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">SingleStringCharacter</span> <span class="nt">SingleStringCharacters</span><sub class="g-opt">opt</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">DoubleStringCharacter</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">"</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></div>
          <div class="rhs"><code class="t">\</code> <span class="nt">EscapeSequence</span></div>
          <div class="rhs"><span class="nt">LineContinuation</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">SingleStringCharacter</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">'</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></div>
          <div class="rhs"><code class="t">\</code> <span class="nt">EscapeSequence</span></div>
          <div class="rhs"><span class="nt">LineContinuation</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">LineContinuation</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">\</code> <span class="nt">LineTerminatorSequence</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">EscapeSequence</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">CharacterEscapeSequence</span></div>
          <div class="rhs"><code class="t">0</code> <span class="grhsannot">[lookahead &notin; <span class="nt">DecimalDigit</span>]</span></div>
          <div class="rhs"><span class="nt">HexEscapeSequence</span></div>
          <div class="rhs"><span class="nt">UnicodeEscapeSequence</span></div>
        </div>

        <p>A conforming implementation, when processing <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> (<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">see 10.2.1</a>), must not extend the syntax of <span class="nt">EscapeSequence</span> to
        include <i>Legacy<span style="font-family: Times New Roman">OctalEscapeSequence</span></i> as described in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-additional-syntax-string-literals">B.1.2</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">CharacterEscapeSequence</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">SingleEscapeCharacter</span></div>
          <div class="rhs"><span class="nt">NonEscapeCharacter</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">SingleEscapeCharacter</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">'</code> <code class="t">"</code> <code class="t">\</code> <code class="t">b</code> <code class="t">f</code> <code class="t">n</code> <code class="t">r</code> <code class="t">t</code> <code class="t">v</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NonEscapeCharacter</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <span class="nt">EscapeCharacter</span> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">EscapeCharacter</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">SingleEscapeCharacter</span></div>
          <div class="rhs"><span class="nt">DecimalDigit</span></div>
          <div class="rhs"><code class="t">x</code></div>
          <div class="rhs"><code class="t">u</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">HexEscapeSequence</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">x</code> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">UnicodeEscapeSequence</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">u</code> <span class="nt">Hex4Digits</span></div>
          <div class="rhs"><code class="t">u{</code> <span class="nt">HexDigits</span> <code class="t">}</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">Hex4Digits</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">HexDigit</span> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span></div>
        </div>

        <p>The definition of the nonterminal <span class="nt">HexDigit</span> is given in <a href="#sec-literals-numeric-literals">11.8.3</a>. <span class="nt">SourceCharacter</span> is defined in <a href="sec-ecmascript-language-source-code#sec-source-text">10.1</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> A line terminator code point cannot appear in a string literal, except as part of a
          <span class="nt">LineContinuation</span> to produce the empty code points sequence. The proper way to cause a line
          terminator code point to be part of the String value of a string literal is to use an escape sequence such as
          <code>\n</code> or <code>\u000A</code>.</p>
        </div>
      </div>

      <section id="sec-string-literals-static-semantics-early-errors">
        <h4 id="sec-11.8.4.1" title="11.8.4.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">UnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u{</code> <span class="nt">HexDigits</span> <code class="t">}</code></div>
        <ul>
          <li>It is a Syntax Error if the MV of <span class="nt">HexDigits</span> &gt; <span style="font-family: Times New               Roman">1114111<i>.</i></span></li>
        </ul>
      </section>

      <section id="sec-string-literals-static-semantics-stringvalue">
        <h4 id="sec-11.8.4.2" title="11.8.4.2"> Static Semantics: </h4><p>See also: <a href="#sec-identifier-names-static-semantics-stringvalue">11.6.1.2</a>, <a href="sec-ecmascript-language-expressions#sec-identifiers-static-semantics-stringvalue">12.1.4</a>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">StringLiteral</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">"</code> <span class="nt">DoubleStringCharacters</span><sub class="g-opt">opt</sub> <code class="t">"</code></div>
          <div class="rhs"><code class="t">'</code> <span class="nt">SingleStringCharacters</span><sub class="g-opt">opt</sub> <code class="t">'</code></div>
        </div>

        <ol class="proc">
          <li>Return the String value whose elements are the SV of this <i>StringLiteral</i>.</li>
        </ol>
      </section>

      <section id="sec-static-semantics-sv">
        <h4 id="sec-11.8.4.3" title="11.8.4.3"> Static Semantics: </h4><p>A string literal stands for a value of the String type. The String value (SV) of the literal is described in terms of
        code unit values contributed by the various parts of the string literal. As part of this process, some Unicode code points
        within the string literal are interpreted as having a mathematical value (MV), as described below or in <a href="#sec-literals-numeric-literals">11.8.3</a>.</p>

        <ul>
          <li>
            <p>The SV of <span class="prod"><span class="nt">StringLiteral</span> <span class="geq">::</span> <code class="t">""</code></span> is the empty code unit sequence.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">StringLiteral</span> <span class="geq">::</span> <code class="t">''</code></span> is the empty code unit sequence.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">StringLiteral</span> <span class="geq">::</span> <code class="t">"</code> <span class="nt">DoubleStringCharacters</span> <code class="t">"</code></span> is the SV of
            <i>DoubleStringCharacters</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">StringLiteral</span> <span class="geq">::</span> <code class="t">'</code> <span class="nt">SingleStringCharacters</span> <code class="t">'</code></span> is the SV of
            <i>SingleStringCharacters</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">DoubleStringCharacters</span> <span class="geq">::</span> <span class="nt">DoubleStringCharacter</span></span> is a sequence of one or two code units that is the SV of
            <i>DoubleStringCharacter</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">DoubleStringCharacters</span> <span class="geq">::</span> <span class="nt">DoubleStringCharacter</span> <span class="nt">DoubleStringCharacters</span></span> is a sequence of one or
            two code units that is the SV of <i>DoubleStringCharacter</i> followed by all the code units in the SV of
            <i>DoubleStringCharacters</i> in order.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">SingleStringCharacters</span> <span class="geq">::</span> <span class="nt">SingleStringCharacter</span></span> is a sequence of one or two code units that is the SV of
            <i>SingleStringCharacter</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">SingleStringCharacters</span> <span class="geq">::</span> <span class="nt">SingleStringCharacter</span> <span class="nt">SingleStringCharacters</span></span> is a sequence of one or
            two code units that is the SV of <i>SingleStringCharacter</i> followed by all the code units in the SV of
            <i>SingleStringCharacters</i> in order.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">DoubleStringCharacter</span> <span class="geq">::</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">"</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></span> is the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of the code point value of <i>SourceCharacter</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">DoubleStringCharacter</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">EscapeSequence</span></span> is the SV of the <i>EscapeSequence</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">DoubleStringCharacter</span> <span class="geq">::</span> <span class="nt">LineContinuation</span></span> is the empty code unit sequence.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">SingleStringCharacter</span> <span class="geq">::</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">'</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></span> is the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of the code point value of <i>SourceCharacter</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">SingleStringCharacter</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">EscapeSequence</span></span> is the SV of the <i>EscapeSequence</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">SingleStringCharacter</span> <span class="geq">::</span> <span class="nt">LineContinuation</span></span> is the empty code unit sequence.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">EscapeSequence</span> <span class="geq">::</span> <span class="nt">CharacterEscapeSequence</span></span> is the SV of the <i>CharacterEscapeSequence</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">EscapeSequence</span> <span class="geq">::</span> <code class="t">0</code></span> is the code unit value 0.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">EscapeSequence</span> <span class="geq">::</span> <span class="nt">HexEscapeSequence</span></span> is the SV of the <i>HexEscapeSequence</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">EscapeSequence</span> <span class="geq">::</span> <span class="nt">UnicodeEscapeSequence</span></span> is the SV of the <i>UnicodeEscapeSequence</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">CharacterEscapeSequence</span> <span class="geq">::</span> <span class="nt">SingleEscapeCharacter</span></span> is the code unit whose value is determined by  the
            <i>SingleEscapeCharacter</i> according to <a href="#table-34">Table 34</a>.</p>
          </li>
        </ul>

        <figure>
          <figcaption><span id="table-34">Table 34</span> &mdash; String Single Character Escape Sequences</figcaption>
          <table class="real-table">
            <tr>
              <th>Escape Sequence</th>
              <th>Code Unit Value</th>
              <th>Unicode Character Name</th>
              <th>Symbol</th>
            </tr>
            <tr>
              <td><code>\b</code></td>
              <td><code>0x0008</code></td>
              <td>BACKSPACE</td>
              <td>&lt;BS&gt;</td>
            </tr>
            <tr>
              <td><code>\t</code></td>
              <td><code>0x0009</code></td>
              <td>CHARACTER TABULATION</td>
              <td>&lt;HT&gt;</td>
            </tr>
            <tr>
              <td><code>\n</code></td>
              <td><code>0x000A</code></td>
              <td>LINE FEED (LF)</td>
              <td>&lt;LF&gt;</td>
            </tr>
            <tr>
              <td><code>\v</code></td>
              <td><code>0x000B</code></td>
              <td>LINE TABULATION</td>
              <td>&lt;VT&gt;</td>
            </tr>
            <tr>
              <td><code>\f</code></td>
              <td><code>0x000C</code></td>
              <td>FORM FEED (FF)</td>
              <td>&lt;FF&gt;</td>
            </tr>
            <tr>
              <td><code>\r</code></td>
              <td><code>0x000D</code></td>
              <td>CARRIAGE RETURN (CR)</td>
              <td>&lt;CR&gt;</td>
            </tr>
            <tr>
              <td><code>\"</code></td>
              <td><code>0x0022</code></td>
              <td>QUOTATION MARK</td>
              <td><code>"</code></td>
            </tr>
            <tr>
              <td><code>\'</code></td>
              <td><code>0x0027</code></td>
              <td>APOSTROPHE</td>
              <td><code>'</code></td>
            </tr>
            <tr>
              <td><code>\\</code></td>
              <td><code>0x005C</code></td>
              <td>REVERSE SOLIDUS</td>
              <td><code>\</code></td>
            </tr>
          </table>
        </figure>

        <ul>
          <li>
            <p>The SV of <span class="prod"><span class="nt">CharacterEscapeSequence</span> <span class="geq">::</span> <span class="nt">NonEscapeCharacter</span></span> is the SV of the <i>NonEscapeCharacter</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">NonEscapeCharacter</span> <span class="geq">::</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <span class="nt">EscapeCharacter</span>
            <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></span> is the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of the code point value of
            <i>SourceCharacter</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">HexEscapeSequence</span> <span class="geq">::</span> <code class="t">x</code> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span></span> is the code unit value
            that is (16 times the MV of the first <i>HexDigit</i>) plus the MV of the second <i>HexDigit</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">UnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u</code> <span class="nt">Hex4Digits</span></span> is the SV of <var>Hex4Digits.</var></p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">Hex4Digits</span> <span class="geq">::</span> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span></span> is the code unit value that is (4096 times the MV of the first <i>HexDigit</i>) plus
            (256 times the MV of the second <i>HexDigit</i>) plus (16 times the MV of the third <i>HexDigit</i>) plus the MV of
            the fourth <i>HexDigit</i>.</p>
          </li>

          <li>
            <p>The SV of <span class="prod"><span class="nt">UnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u{</code> <span class="nt">HexDigits</span> <code class="t">}</code></span> is the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of the MV of
            <i>HexDigits</i>.</p>
          </li>
        </ul>
      </section>
    </section>

    <section id="sec-literals-regular-expression-literals">
      <div class="front">
        <h3 id="sec-11.8.5" title="11.8.5"> Regular Expression Literals</h3><div class="note">
          <p><span class="nh">NOTE 1</span> A regular expression literal is an input element that is converted to a RegExp object
          (<a href="sec-text-processing#sec-regexp-regular-expression-objects">see 21.2</a>) each time the literal is evaluated. Two regular
          expression literals in a program evaluate to regular expression objects that never compare as <code>===</code> to each
          other even if the two literals' contents are identical. A RegExp object may also be created at runtime by <code>new
          RegExp</code> or calling the <code>RegExp</code> constructor as a function (<a href="sec-text-processing#sec-regexp-constructor">see
          21.2.3</a>).</p>
        </div>

        <p>The productions below describe the syntax for a regular expression literal and are used by the input element scanner to
        find the end of the regular expression literal. The source text comprising the <span class="nt">RegularExpressionBody</span> and the <span class="nt">RegularExpressionFlags</span> are subsequently parsed
        again using the more stringent ECMAScript Regular Expression grammar (<a href="sec-text-processing#sec-patterns">21.2.1</a>).</p>

        <p>An implementation may extend the ECMAScript Regular Expression grammar defined in <a href="sec-text-processing#sec-patterns">21.2.1</a>,
        but it must not extend the <span class="nt">RegularExpressionBody</span> and <span class="nt">RegularExpressionFlags</span> productions defined below or the productions used by these productions.</p>

        <h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionLiteral</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">/</code> <span class="nt">RegularExpressionBody</span> <code class="t">/</code> <span class="nt">RegularExpressionFlags</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionBody</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">RegularExpressionFirstChar</span> <span class="nt">RegularExpressionChars</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionChars</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="grhsannot">[empty]</span></div>
          <div class="rhs"><span class="nt">RegularExpressionChars</span> <span class="nt">RegularExpressionChar</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionFirstChar</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">RegularExpressionNonTerminator</span> <span class="grhsmod">but not one of</span> <code class="t">*</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">/</code> <span class="grhsmod">or</span> <code class="t">[</code></div>
          <div class="rhs"><span class="nt">RegularExpressionBackslashSequence</span></div>
          <div class="rhs"><span class="nt">RegularExpressionClass</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionChar</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">RegularExpressionNonTerminator</span> <span class="grhsmod">but not one of</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">/</code> <span class="grhsmod">or</span> <code class="t">[</code></div>
          <div class="rhs"><span class="nt">RegularExpressionBackslashSequence</span></div>
          <div class="rhs"><span class="nt">RegularExpressionClass</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionBackslashSequence</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">\</code> <span class="nt">RegularExpressionNonTerminator</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionNonTerminator</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <span class="nt">LineTerminator</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionClass</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">[</code> <span class="nt">RegularExpressionClassChars</span> <code class="t">]</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionClassChars</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="grhsannot">[empty]</span></div>
          <div class="rhs"><span class="nt">RegularExpressionClassChars</span> <span class="nt">RegularExpressionClassChar</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionClassChar</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">RegularExpressionNonTerminator</span> <span class="grhsmod">but not one of</span> <code class="t">]</code> <span class="grhsmod">or</span> <code class="t">\</code></div>
          <div class="rhs"><span class="nt">RegularExpressionBackslashSequence</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegularExpressionFlags</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="grhsannot">[empty]</span></div>
          <div class="rhs"><span class="nt">RegularExpressionFlags</span> <span class="nt">IdentifierPart</span></div>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> Regular expression literals may not be empty; instead of representing an empty regular
          expression literal, the code unit sequence <code>//</code> starts a single-line comment. To specify an empty regular
          expression, use:  <code>/(?:)/</code>.</p>
        </div>
      </div>

      <section id="sec-literals-regular-expression-literals-static-semantics-early-errors">
        <h4 id="sec-11.8.5.1" title="11.8.5.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">RegularExpressionFlags</span> <span class="geq">::</span> <span class="nt">RegularExpressionFlags</span> <span class="nt">IdentifierPart</span></div>
        <ul>
          <li>It is a Syntax Error if <span class="nt">IdentifierPart</span> contains a Unicode escape sequence<var>.</var></li>
        </ul>
      </section>

      <section id="sec-static-semantics-bodytext">
        <h4 id="sec-11.8.5.2" title="11.8.5.2"> Static Semantics: </h4><div class="gp prod"><span class="nt">RegularExpressionLiteral</span> <span class="geq">::</span> <code class="t">/</code> <span class="nt">RegularExpressionBody</span> <code class="t">/</code> <span class="nt">RegularExpressionFlags</span></div>
        <ol class="proc">
          <li>Return the source text that was recognized as <i>RegularExpressionBody</i>.</li>
        </ol>
      </section>

      <section id="sec-static-semantics-flagtext">
        <h4 id="sec-11.8.5.3" title="11.8.5.3"> Static Semantics: </h4><div class="gp prod"><span class="nt">RegularExpressionLiteral</span> <span class="geq">::</span> <code class="t">/</code> <span class="nt">RegularExpressionBody</span> <code class="t">/</code> <span class="nt">RegularExpressionFlags</span></div>
        <ol class="proc">
          <li>Return the source text that was recognized as <i>RegularExpressionFlags</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-template-literal-lexical-components">
      <div class="front">
        <h3 id="sec-11.8.6" title="11.8.6"> Template Literal Lexical Components</h3><h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">Template</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">NoSubstitutionTemplate</span></div>
          <div class="rhs"><span class="nt">TemplateHead</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NoSubstitutionTemplate</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">`</code> <span class="nt">TemplateCharacters</span><sub class="g-opt">opt</sub> <code class="t">`</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">TemplateHead</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">`</code> <span class="nt">TemplateCharacters</span><sub class="g-opt">opt</sub> <code class="t">${</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">TemplateSubstitutionTail</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">TemplateMiddle</span></div>
          <div class="rhs"><span class="nt">TemplateTail</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">TemplateMiddle</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">}</code> <span class="nt">TemplateCharacters</span><sub class="g-opt">opt</sub> <code class="t">${</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">TemplateTail</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">}</code> <span class="nt">TemplateCharacters</span><sub class="g-opt">opt</sub> <code class="t">`</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">TemplateCharacters</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">TemplateCharacter</span> <span class="nt">TemplateCharacters</span><sub class="g-opt">opt</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">TemplateCharacter</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">$</code> <span class="grhsannot">[lookahead &ne; { ]</span></div>
          <div class="rhs"><code class="t">\</code> <span class="nt">EscapeSequence</span></div>
          <div class="rhs"><span class="nt">LineContinuation</span></div>
          <div class="rhs"><span class="nt">LineTerminatorSequence</span></div>
          <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">`</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">$</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></div>
        </div>

        <p>A conforming implementation must not use the extended definition of <span class="nt">EscapeSequence</span> described in
        <a href="sec-additional-ecmascript-features-for-web-browsers#sec-additional-syntax-string-literals">B.1.2</a> when parsing a <span class="nt">TemplateCharacter</span>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> <span class="nt">TemplateSubstitutionTail</span> is used by the <span class="nt">InputElementTemplateTail</span> alternative lexical goal.</p>
        </div>
      </div>

      <section id="sec-static-semantics-tv-and-trv">
        <h4 id="sec-11.8.6.1" title="11.8.6.1"> Static Semantics: </h4><p>A template literal component is interpreted as a sequence of Unicode code points. The Template Value (TV) of a literal
        component is described in terms of code unit values (SV, <a href="#sec-literals-string-literals">11.8.4</a>) contributed
        by the various parts of the template literal component. As part of this process, some Unicode code points within the
        template component are interpreted as having a mathematical value (MV, <a href="#sec-literals-numeric-literals">11.8.3</a>). In determining a TV, escape sequences are replaced by the UTF-16 code
        unit(s) of the Unicode code point represented by the escape sequence. The Template Raw Value (TRV) is similar to a
        Template Value with the difference that in TRVs escape sequences are interpreted literally.</p>

        <ul>
          <li>
            <p>The TV and TRV of <span class="prod"><span class="nt">NoSubstitutionTemplate</span> <span class="geq">::</span>
            <code class="t">``</code></span> is the empty code unit sequence.</p>
          </li>

          <li>
            <p>The TV and TRV of <span class="prod"><span class="nt">TemplateHead</span> <span class="geq">::</span> <code class="t">`${</code></span>  is the empty code unit sequence.</p>
          </li>

          <li>
            <p>The TV and TRV of <span class="prod"><span class="nt">TemplateMiddle</span> <span class="geq">::</span> <code class="t">}${</code></span> is the empty code unit sequence.</p>
          </li>

          <li>
            <p>The TV and TRV of <span class="prod"><span class="nt">TemplateTail</span> <span class="geq">::</span> <code class="t">}`</code></span> is the empty code unit sequence.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">NoSubstitutionTemplate</span> <span class="geq">::</span> <code class="t">`</code> <span class="nt">TemplateCharacters</span> <code class="t">`</code></span> is the TV of
            <i>TemplateCharacters</i>.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">TemplateHead</span> <span class="geq">::</span> <code class="t">`</code> <span class="nt">TemplateCharacters</span> <code class="t">${</code></span> is the TV of
            <i>TemplateCharacters</i>.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">TemplateMiddle</span> <span class="geq">::</span> <code class="t">}</code> <span class="nt">TemplateCharacters</span> <code class="t">${</code></span> is the TV of
            <i>TemplateCharacters</i>.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">TemplateTail</span> <span class="geq">::</span> <code class="t">}</code> <span class="nt">TemplateCharacters</span> <code class="t">`</code></span> is the TV of
            <i>TemplateCharacters</i>.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">TemplateCharacters</span> <span class="geq">::</span> <span class="nt">TemplateCharacter</span></span>  is the TV of <i>TemplateCharacter</i>.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">TemplateCharacters</span> <span class="geq">::</span> <span class="nt">TemplateCharacter</span> <span class="nt">TemplateCharacters</span></span> is a sequence consisting of the
            code units in the TV of <i>TemplateCharacter</i> followed by all the code units in the TV of <i>TemplateCharacters</i>
            in order.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">`</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">$</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></span> is the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of the code point value of
            <i>SourceCharacter</i>.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> <code class="t">$</code></span> is the code unit value 0x0024.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">EscapeSequence</span></span> is the SV of <i>EscapeSequence</i>.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> <span class="nt">LineContinuation</span></span> is the TV of <i>LineContinuation</i>.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> <span class="nt">LineTerminatorSequence</span></span> is the TRV of <i>LineTerminatorSequence</i>.</p>
          </li>

          <li>
            <p>The TV of <span class="prod"><span class="nt">LineContinuation</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">LineTerminatorSequence</span></span> is the empty code unit sequence.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">NoSubstitutionTemplate</span> <span class="geq">::</span> <code class="t">`</code> <span class="nt">TemplateCharacters</span> <code class="t">`</code></span> is the TRV of
            <i>TemplateCharacters</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">TemplateHead</span> <span class="geq">::</span> <code class="t">`</code> <span class="nt">TemplateCharacters</span> <code class="t">${</code></span> is the TRV of
            <i>TemplateCharacters</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">TemplateMiddle</span> <span class="geq">::</span> <code class="t">}</code> <span class="nt">TemplateCharacters</span> <code class="t">${</code></span> is the TRV of
            <i>TemplateCharacters</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">TemplateTail</span> <span class="geq">::</span> <code class="t">}</code> <span class="nt">TemplateCharacters</span> <code class="t">`</code></span> is the TRV of
            <i>TemplateCharacters</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">TemplateCharacters</span> <span class="geq">::</span> <span class="nt">TemplateCharacter</span></span>  is the TRV of <i>TemplateCharacter</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">TemplateCharacters</span> <span class="geq">::</span> <span class="nt">TemplateCharacter</span> <span class="nt">TemplateCharacters</span></span> is a sequence consisting of the
            code units in the TRV of <i>TemplateCharacter</i> followed by all the code units in the TRV of
            <i>TemplateCharacters,</i> in order.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">`</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">$</code> <span class="grhsmod">or</span> <span class="nt">LineTerminator</span></span> is the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of the code point value of
            <i>SourceCharacter</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> <code class="t">$</code></span> is the code unit value 0x0024.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">EscapeSequence</span></span> is the sequence consisting of the code unit value
            0x005C  followed by the code units of TRV of <i>EscapeSequence</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> <span class="nt">LineContinuation</span></span> is the TRV of <i>LineContinuation</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">TemplateCharacter</span> <span class="geq">::</span> <span class="nt">LineTerminatorSequence</span></span> is the TRV of <i>LineTerminatorSequence</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">EscapeSequence</span> <span class="geq">::</span> <span class="nt">CharacterEscapeSequence</span></span> is the TRV of the <i>CharacterEscapeSequence</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">EscapeSequence</span> <span class="geq">::</span> <code class="t">0</code></span>  is the code unit value 0x0030.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">EscapeSequence</span> <span class="geq">::</span> <span class="nt">HexEscapeSequence</span></span> is the TRV of the <i>HexEscapeSequence</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">EscapeSequence</span> <span class="geq">::</span> <span class="nt">UnicodeEscapeSequence</span></span> is the TRV of the <i>UnicodeEscapeSequence</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">CharacterEscapeSequence</span> <span class="geq">::</span> <span class="nt">SingleEscapeCharacter</span></span> is the TRV of the <i>SingleEscapeCharacter</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">CharacterEscapeSequence</span> <span class="geq">::</span> <span class="nt">NonEscapeCharacter</span></span> is the SV of the <i>NonEscapeCharacter</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">SingleEscapeCharacter</span> <span class="geq">::</span> <span class="grhsmod">one of</span> <code class="t">'</code> <code class="t">"</code> <code class="t">\</code> <code class="t">b</code> <code class="t">f</code> <code class="t">n</code> <code class="t">r</code> <code class="t">t</code>
            <code class="t">v</code></span>  is the SV of the <i>SourceCharacter</i> that is that single code point.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">HexEscapeSequence</span> <span class="geq">::</span> <code class="t">x</code> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span></span>  is the sequence
            consisting of code unit value 0x0078 followed by TRV of the first <i>HexDigit</i> followed by the TRV of the second
            <i>HexDigit</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">UnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u</code> <span class="nt">Hex4Digits</span></span> is the sequence consisting of code unit value 0x0075
            followed by TRV of <span class="nt">Hex4Digits</span>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">UnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u{</code> <span class="nt">HexDigits</span> <code class="t">}</code></span> is the sequence consisting of
            code unit value 0x0075 followed by code unit value 0x007B  followed by TRV of <i>HexDigits</i> followed by code unit
            value 0x007D.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">Hex4Digits</span> <span class="geq">::</span> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span> <span class="nt">HexDigit</span></span> is the sequence consisting of the TRV of the first <i>HexDigit</i> followed by the
            TRV of the second <i>HexDigit</i> followed by the TRV of the third <i>HexDigit</i> followed by the TRV of the fourth
            <span class="nt">HexDigit</span>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">HexDigits</span> <span class="geq">::</span> <span class="nt">HexDigit</span></span> is the TRV of <i>HexDigit</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">HexDigits</span> <span class="geq">::</span> <span class="nt">HexDigits</span> <span class="nt">HexDigit</span></span> is the sequence consisting of TRV of
            <i>HexDigits</i> followed by TRV of <i>HexDigit</i>.</p>
          </li>

          <li>
            <p>The TRV of a <i>HexDigit</i>  is the SV of the <i>SourceCharacter</i> that is that <i>HexDigit</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">LineContinuation</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">LineTerminatorSequence</span></span> is the sequence consisting of the code unit
            value 0x005C  followed by the code units of TRV of <i>LineTerminatorSequence</i>.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">LineTerminatorSequence</span> <span class="geq">::</span></span>
            &lt;LF&gt; is the code unit value 0x000A.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">LineTerminatorSequence</span> <span class="geq">::</span></span>
            &lt;CR&gt; is the code unit value 0x000A.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">LineTerminatorSequence</span> <span class="geq">::</span></span>
            &lt;LS&gt;  is the code unit value 0x2028.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">LineTerminatorSequence</span> <span class="geq">::</span></span>
            &lt;PS&gt;  is the code unit value 0x2029.</p>
          </li>

          <li>
            <p>The TRV of <span class="prod"><span class="nt">LineTerminatorSequence</span> <span class="geq">::</span></span>
            &lt;CR&gt;&lt;LF&gt;  is the sequence consisting of the code unit value 0x000A.</p>
          </li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> TV excludes the code units of <span class="nt">LineContinuation</span> while TRV
          includes them. &lt;CR&gt;&lt;LF&gt; and &lt;CR&gt; <span class="nt">LineTerminatorSequences</span> are normalized to
          &lt;LF&gt; for both TV and TRV. An explicit <span class="nt">EscapeSequence</span> is needed to include a &lt;CR&gt; or
          &lt;CR&gt;&lt;LF&gt; sequence.</p>
        </div>
      </section>
    </section>
  </section>

  <section id="sec-automatic-semicolon-insertion">
    <div class="front">
      <h2 id="sec-11.9" title="11.9"> Automatic Semicolon Insertion</h2><p>Certain ECMAScript statements (empty statement, <code>let</code>, <code>const</code>, <code>import</code>, and
      <code>export</code> declarations, variable statement, expression statement, <code>debugger</code> statement,
      <code>continue</code> statement, <code>break</code> statement, <code>return</code> statement, and <code>throw</code>
      statement) must be terminated with semicolons. Such semicolons may always appear explicitly in the source text. For
      convenience, however, such semicolons may be omitted from the source text in certain situations. These situations are
      described by saying that semicolons are automatically inserted into the source code token stream in those situations.</p>
    </div>

    <section id="sec-rules-of-automatic-semicolon-insertion">
      <h3 id="sec-11.9.1" title="11.9.1"> Rules of Automatic Semicolon Insertion</h3><p>In the following rules, &ldquo;token&rdquo; means the actual recognized lexical token determined using the current
      lexical goal symbol as described in <a href="sec-ecmascript-language-lexical-grammar">clause 11</a>.</p>

      <p>There are three basic rules of semicolon insertion:</p>

      <ol class="proc">
        <li>When, as a <span style="font-family: Times New Roman"><i>Script</i> or <i>Module</i></span> is parsed from left to
            right, a token (called the <i>offending token</i>) is encountered that is not allowed by any production of the
            grammar, then a semicolon is automatically inserted before the offending token if one or more of the following
            conditions is true:
          <ul>
            <li>
              <p>The offending token is separated from the previous token by at least one <span class="nt">LineTerminator</span>.</p>
            </li>

            <li>
              <p>The offending token is <code>}</code>.</p>
            </li>

            <li>
              <p>The previous token is <code>)</code> and the inserted semicolon would then be parsed as the terminating semicolon
              of a do-while statement (<a href="sec-ecmascript-language-statements-and-declarations#sec-do-while-statement">13.7.2</a>).</p>
            </li>
          </ul>
        </li>
        <li>When, as the <span style="font-family: Times New Roman"><i>Script</i> or <i>Module</i></span> is parsed from left to
            right, the end of the input stream of tokens is encountered and the parser is unable to parse the input token stream
            as a single complete ECMAScript <span style="font-family: Times New Roman"><i>Script</i> or <i>Module</i></span>, then
            a semicolon is automatically inserted at the end of the input stream.</li>
        <li>When, as the <span style="font-family: Times New Roman"><i>Script</i> or <i>Module</i></span> is parsed from left to
            right, a token is encountered that is allowed by some production of the grammar, but the production is a <i>restricted
            production</i> and the token would be the first token for a terminal or nonterminal immediately following the
            annotation <span style="font-family: Times New Roman">&ldquo;</span>[no<span style="font-family: Times New             Roman">&nbsp;<i>LineTerminator</i></span> here]&rdquo; within the restricted production (and therefore such a token is
            called a restricted token), and the restricted token is separated from the previous token by at least one <span class="nt">LineTerminator</span>, then a semicolon is automatically inserted before the restricted token.</li>
      </ol>

      <p>However, there is an additional overriding condition on the preceding rules: a semicolon is never inserted automatically
      if the semicolon would then be parsed as an empty statement or if that semicolon would become one of the two semicolons in
      the header of a <code>for</code> statement (<a href="sec-ecmascript-language-statements-and-declarations#sec-for-statement">see 13.7.4</a>).</p>

      <div class="note">
        <p><span class="nh">NOTE</span> The following are the only restricted productions in the grammar:</p>

        <div class="gp">
          <div class="lhs"><span class="nt">PostfixExpression</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">++</code></div>
          <div class="rhs"><span class="nt">LeftHandSideExpression</span><sub class="g-params">[?Yield]</sub> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">--</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ContinueStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">continue;</code></div>
          <div class="rhs"><code class="t">continue</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">LabelIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">;</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">BreakStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">break</code> <code class="t">;</code></div>
          <div class="rhs"><code class="t">break</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">LabelIdentifier</span><sub class="g-params">[?Yield]</sub> <code class="t">;</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ReturnStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">return</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">Expression</span> <code class="t">;</code></div>
          <div class="rhs"><code class="t">return</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">;</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ThrowStatement</span><sub class="g-params">[Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">throw</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">Expression</span><sub class="g-params">[In, ?Yield]</sub> <code class="t">;</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ArrowFunction</span><sub class="g-params">[In, Yield]</sub> <span class="geq">:</span></div>
          <div class="rhs"><span class="nt">ArrowParameters</span><sub class="g-params">[?Yield]</sub> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">=&gt;</code> <span class="nt">ConciseBody</span><sub class="g-params">[?In]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">YieldExpression</span><sub class="g-params">[In]</sub> <span class="geq">:</span></div>
          <div class="rhs"><code class="t">yield</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <code class="t">*</code> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, Yield]</sub></div>
          <div class="rhs"><code class="t">yield</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">AssignmentExpression</span><sub class="g-params">[?In, Yield]</sub></div>
        </div>

        <p>The practical effect of these restricted productions is as follows:</p>

        <ul>
          <li>
            <p>When a <code>++</code> or <code>--</code> token is encountered where the parser would treat it as a postfix
            operator, and at least one <span class="nt">LineTerminator</span> occurred between the preceding token and the
            <code>++</code> or <code>--</code> token, then a semicolon is automatically inserted before the <code>++</code> or
            <code>--</code> token.</p>
          </li>

          <li>
            <p>When a <code>continue</code>, <code>break</code>, <code>return</code>, <code>throw</code>, or <code>yield</code>
            token is encountered and a <span class="nt">LineTerminator</span> is encountered before the next token, a semicolon is
            automatically inserted after the <code>continue</code>, <code>break</code>, <code>return</code>, <code>throw</code>,
            or <code>yield</code>  token.</p>
          </li>
        </ul>

        <p>The resulting practical advice to ECMAScript programmers is:</p>

        <ul>
          <li>
            <p>A postfix <code>++</code> or <code>--</code> operator should appear on the same line as its operand.</p>
          </li>

          <li>
            <p>An <span class="nt">Expression</span> in a <code>return</code> or <code>throw</code> statement or an <span class="nt">AssignmentExpression</span> in a <code>yield</code> expression should start on the same line as the
            <code>return</code>, <code>throw</code>, or <code>yield</code> token.</p>
          </li>

          <li>
            <p>An <span class="nt">IdentifierReference</span> in a <code>break</code> or <code>continue</code> statement should be
            on the same line as the <code>break</code> or <code>continue</code> token.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-examples-of-automatic-semicolon-insertion">
      <h3 id="sec-11.9.2" title="11.9.2"> Examples of Automatic Semicolon Insertion</h3><p>The source</p>

      <pre class="NoteCode">{ 1 2 } 3</pre>

      <p>is not a valid sentence in the ECMAScript grammar, even with the <a href="#sec-automatic-semicolon-insertion">automatic
      semicolon insertion</a> rules. In contrast, the source</p>

      <pre class="NoteCode">{ 1<br />2 } 3</pre>

      <p>is also not a valid ECMAScript sentence, but is transformed by <a href="#sec-automatic-semicolon-insertion">automatic
      semicolon insertion</a> into the following:</p>

      <pre class="NoteCode">{ 1<br />;2 ;} 3;</pre>

      <p>which is a valid ECMAScript sentence.</p>

      <p>The source</p>

      <pre class="NoteCode">for (a; b<br />)</pre>

      <p>is not a valid ECMAScript sentence and is not altered by <a href="#sec-automatic-semicolon-insertion">automatic semicolon
      insertion</a> because the semicolon is needed for the header of a <code>for</code> statement. Automatic semicolon insertion
      never inserts one of the two semicolons in the header of a <code>for</code> statement.</p>

      <p>The source</p>

      <pre class="NoteCode">return<br />a + b</pre>

      <p>is transformed by <a href="#sec-automatic-semicolon-insertion">automatic semicolon insertion</a> into the following:</p>

      <pre class="NoteCode">return;<br />a + b;</pre>

      <div class="note">
        <p><span class="nh">NOTE 1</span> The expression <code>a + b</code> is not treated as a value to be returned by the
        <code>return</code> statement, because a <span class="nt">LineTerminator</span> separates it from the token
        <code>return</code>.</p>
      </div>

      <p>The source</p>

      <pre class="NoteCode">a = b<br />++c</pre>

      <p>is transformed by <a href="#sec-automatic-semicolon-insertion">automatic semicolon insertion</a> into the following:</p>

      <pre class="NoteCode">a = b;<br />++c;</pre>

      <div class="note">
        <p><span class="nh">NOTE 2</span> The token <code>++</code> is not treated as a postfix operator applying to the variable
        <code>b</code>, because a <span class="nt">LineTerminator</span> occurs between <code>b</code> and <code>++</code>.</p>
      </div>

      <p>The source</p>

      <pre class="NoteCode">if (a &gt; b)<br />else c = d</pre>

      <p>is not a valid ECMAScript sentence and is not altered by <a href="#sec-automatic-semicolon-insertion">automatic semicolon
      insertion</a> before the <code>else</code> token, even though no production of the grammar applies at that point, because an
      automatically inserted semicolon would then be parsed as an empty statement.</p>

      <p>The source</p>

      <pre class="NoteCode">a = b + c<br />(d + e).print()</pre>

      <p>is <i>not</i> transformed by <a href="#sec-automatic-semicolon-insertion">automatic semicolon insertion</a>, because the
      parenthesized expression that begins the second line can be interpreted as an argument list for a function call:</p>

      <pre class="NoteCode">a = b + c(d + e).print()</pre>

      <p>In the circumstance that an assignment statement must begin with a left parenthesis, it is a good idea for the programmer
      to provide an explicit semicolon at the end of the preceding statement rather than to rely on <a href="#sec-automatic-semicolon-insertion">automatic semicolon insertion</a>.</p>
    </section>
  </section>
</section>

