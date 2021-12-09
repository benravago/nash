<section id="sec-notational-conventions">
  <div class="front">
    <h1 id="sec-5" title="5"> Notational
        Conventions</h1></div>

  <section id="sec-syntactic-and-lexical-grammars">
    <div class="front">
      <h2 id="sec-5.1" title="5.1"> Syntactic and Lexical Grammars</h2></div>

    <section id="sec-context-free-grammars">
      <h3 id="sec-5.1.1" title="5.1.1">
          Context-Free Grammars</h3><p>A <i>context-free grammar</i> consists of a number of <i>productions</i>. Each production has an abstract symbol called a
      <i>nonterminal</i> as its <i>left-hand side</i>, and a sequence of zero or more nonterminal and <i>terminal</i> symbols as
      its <i>right-hand side</i>. For each grammar, the terminal symbols are drawn from a specified alphabet.</p>

      <p>A <i>chain production</i> is a production that has exactly one nonterminal symbol on its right-hand side along with zero
      or more terminal symbols.</p>

      <p>Starting from a sentence consisting of a single distinguished nonterminal, called the <i>goal symbol</i>, a given
      context-free grammar specifies a <i>language</i>, namely, the (perhaps infinite) set of possible sequences of terminal
      symbols that can result from repeatedly replacing any nonterminal in the sequence with a right-hand side of a production for
      which the nonterminal is the left-hand side.</p>
    </section>

    <section id="sec-lexical-and-regexp-grammars">
      <h3 id="sec-5.1.2" title="5.1.2"> The Lexical and RegExp Grammars</h3><p>A <i>lexical grammar</i> for ECMAScript is given in <a href="sec-ecmascript-language-lexical-grammar">clause 11</a>.
      This grammar has as its terminal symbols Unicode code points that conform to the rules for <span class="nt">SourceCharacter</span> defined in <a href="sec-ecmascript-language-source-code#sec-source-text">10.1</a>. It defines a set of productions, starting
      from the goal symbol <var>InputElementDiv,</var> <var>InputElementTemplateTail,</var> or <span class="nt">InputElementRegExp</span>, or <var>InputElementRegExpOrTemplateTail,</var> that describe how sequences of such
      code points are translated into a sequence of input elements.</p>

      <p>Input elements other than white space and comments form the terminal symbols for the syntactic grammar for ECMAScript and
      are called ECMAScript <i>tokens</i>. These tokens are the reserved words, identifiers, literals, and punctuators of the
      ECMAScript language. Moreover, line terminators, although not considered to be tokens, also become part of the stream of
      input elements and guide the process of <a href="sec-ecmascript-language-lexical-grammar#sec-automatic-semicolon-insertion">automatic semicolon insertion</a> (<a href="sec-ecmascript-language-lexical-grammar#sec-automatic-semicolon-insertion">11.9</a>). Simple white space and single-line comments are discarded and do not
      appear in the stream of input elements for the syntactic grammar. A <span class="nt">MultiLineComment</span> (that is, a
      comment of the form <code>/*</code>&hellip;<code>*/</code> regardless of whether it spans more than one line) is likewise
      simply discarded if it contains no line terminator; but if a <span class="nt">MultiLineComment</span> contains one or more
      line terminators, then it is replaced by a single line terminator, which becomes part of the stream of input elements for
      the syntactic grammar.</p>

      <p>A <i>RegExp grammar</i> for ECMAScript is given in <a href="sec-text-processing#sec-patterns">21.2.1</a>. This grammar also has as its
      terminal symbols the code points as defined by <span class="nt">SourceCharacter</span>. It defines a set of productions,
      starting from the goal symbol <span class="nt">Pattern</span>, that describe how sequences of code points are translated
      into regular expression patterns.</p>

      <p>Productions of the lexical and RegExp grammars are distinguished by having two colons &ldquo;<b>::</b>&rdquo; as
      separating punctuation. The lexical and RegExp grammars share some productions.</p>
    </section>

    <section id="sec-numeric-string-grammar">
      <h3 id="sec-5.1.3" title="5.1.3">
          The Numeric String Grammar</h3><p>Another grammar is used for translating Strings into numeric values. This grammar is similar to the part of the lexical
      grammar having to do with numeric literals and has as its terminal symbols <span class="nt">SourceCharacter</span>. This
      grammar appears in <a href="sec-abstract-operations#sec-tonumber-applied-to-the-string-type">7.1.3.1</a>.</p>

      <p>Productions of the numeric string grammar are distinguished by having three colons &ldquo;<b>:::</b>&rdquo; as
      punctuation.</p>
    </section>

    <section id="sec-syntactic-grammar">
      <h3 id="sec-5.1.4" title="5.1.4"> The
          Syntactic Grammar</h3><p>The <i>syntactic grammar</i> for ECMAScript is given in clauses 11, 12, 13, 14, and 15. This grammar has ECMAScript
      tokens defined by the lexical grammar as its terminal symbols (<a href="#sec-lexical-and-regexp-grammars">5.1.2</a>). It
      defines a set of productions, starting from two alternative goal symbols <span class="nt">Script</span> and <span class="nt">Module</span>, that describe how sequences of tokens form syntactically correct independent components of
      ECMAScript programs.</p>

      <p>When a stream of code points is to be parsed as an ECMAScript <span class="nt">Script</span> or <span class="nt">Module</span>, it is first converted to a stream of input elements by repeated application of the lexical
      grammar; this stream of input elements is then parsed by a single application of the syntactic grammar. The input stream is
      syntactically in error if the tokens in the stream of input elements cannot be parsed as a single instance of the goal
      nonterminal (<span class="nt">Script</span> or <span class="nt">Module</span>), with no tokens left over.</p>

      <p>Productions of the syntactic grammar are distinguished by having just one colon &ldquo;<b>:</b>&rdquo; as
      punctuation.</p>

      <p>The syntactic grammar as presented in clauses 12, 13, 14 and 15 is not a complete account of which token sequences are
      accepted as a correct ECMAScript <span class="nt">Script</span> or <span class="nt">Module</span>. Certain additional token
      sequences are also accepted, namely, those that would be described by the grammar if only semicolons were added to the
      sequence in certain places (such as before line terminator characters). Furthermore, certain token sequences that are
      described by the grammar are not considered acceptable if a line terminator character appears in certain
      &ldquo;awkward&rdquo; places.</p>

      <p>In certain cases in order to avoid ambiguities the syntactic grammar uses generalized productions that permit token
      sequences that do not form a valid ECMAScript <span class="nt">Script</span> or <span class="nt">Module</span>. For example,
      this technique is used for object literals and object destructuring patterns. In such cases a more restrictive
      <i>supplemental grammar</i> is provided that further restricts the acceptable token sequences. In certain contexts, when
      explicitly specified, the input elements corresponding to such a production are parsed again using a goal symbol of a
      supplemental grammar. The input stream is syntactically in error if the tokens in the stream of input elements parsed by a
      cover grammar cannot be parsed as a single instance of the corresponding supplemental goal symbol, with no tokens left
      over.</p>
    </section>

    <section id="sec-grammar-notation">
      <h3 id="sec-5.1.5" title="5.1.5">
          Grammar Notation</h3><p>Terminal symbols of the lexical, RegExp, and numeric string grammars are shown in <code>fixed width</code> font, both in
      the productions of the grammars and throughout this specification whenever the text directly refers to such a terminal
      symbol. These are to appear in a script exactly as written. All terminal symbol code points specified in this way are to be
      understood as the appropriate Unicode code points from the Basic Latin range, as opposed to any similar-looking code points
      from other Unicode ranges.</p>

      <p>Nonterminal symbols are shown in <var>italic</var> type. The definition of a nonterminal (also called a
      &ldquo;production&rdquo;) is introduced by the name of the nonterminal being defined followed by one or more colons. (The
      number of colons indicates to which grammar the production belongs.) One or more alternative right-hand sides for the
      nonterminal then follow on succeeding lines. For example, the syntactic definition:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">WhileStatement</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">while</code> <code class="t">(</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      </div>

      <p>states that the nonterminal <span class="nt">WhileStatement</span> represents the token <code>while</code>, followed by a
      left parenthesis token, followed by an <span class="nt">Expression</span>, followed by a right parenthesis token, followed
      by a <span class="nt">Statement</span>. The occurrences of <span class="nt">Expression</span> and <span class="nt">Statement</span> are themselves nonterminals. As another example, the syntactic definition:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">ArgumentList</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">AssignmentExpression</span></div>
        <div class="rhs"><span class="nt">ArgumentList</span> <code class="t">,</code> <span class="nt">AssignmentExpression</span></div>
      </div>

      <p>states that an <span class="nt">ArgumentList</span> may represent either a single <span class="nt">AssignmentExpression</span> or an <span class="nt">ArgumentList</span>, followed by a comma, followed by an <span class="nt">AssignmentExpression</span>. This definition of <span class="nt">ArgumentList</span> is recursive, that is, it is
      defined in terms of itself. The result is that an <span class="nt">ArgumentList</span> may contain any positive number of
      arguments, separated by commas, where each argument expression is an <span class="nt">AssignmentExpression</span>. Such
      recursive definitions of nonterminals are common.</p>

      <p>The subscripted suffix &ldquo;<sub>opt</sub>&rdquo;, which may appear after a terminal or nonterminal, indicates an
      optional symbol. The alternative containing the optional symbol actually specifies two right-hand sides, one that omits the
      optional element and one that includes it. This means that:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">VariableDeclaration</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span><sub class="g-opt">opt</sub></div>
      </div>

      <p>is a convenient abbreviation for:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">VariableDeclaration</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span></div>
      </div>

      <p>and that:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
      </div>

      <p>is a convenient abbreviation for:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span> <code class="t">;</code> <span class="nt">Expression</span><sub class="g-opt">opt</sub> <code class="t">)</code> <span class="nt">Statement</span></div>
      </div>

      <p>which in turn is an abbreviation for:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">IterationStatement</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <code class="t">;</code> <code class="t">)</code> <span class="nt">Statement</span></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <code class="t">;</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span> <code class="t">;</code> <code class="t">)</code> <span class="nt">Statement</span></div>
        <div class="rhs"><code class="t">for</code> <code class="t">(</code> <span class="nt">LexicalDeclaration</span> <span class="nt">Expression</span> <code class="t">;</code> <span class="nt">Expression</span> <code class="t">)</code> <span class="nt">Statement</span></div>
      </div>

      <p>so, in this example, the nonterminal <span class="nt">IterationStatement</span> actually has four alternative right-hand
      sides.</p>

      <p>A production may be parameterized by a subscripted annotation of the form &ldquo;<sub>[parameters]</sub>&rdquo;, which
      may appear as a suffix to the nonterminal symbol defined by the production. &ldquo;<sub>parameters</sub>&rdquo; may be
      either a single name or a comma separated list of names. A parameterized production is shorthand for a set of productions
      defining all combinations of the parameter names, preceded by an underscore, appended to the parameterized nonterminal
      symbol. This means that:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span><sub class="g-params">[Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <p>is a convenient abbreviation for:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList_Return</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <p>and that:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span><sub class="g-params">[Return, In]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <p>is an abbreviation for:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList_Return</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList_In</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList_Return_In</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <p>Multiple parameters produce a combinatory number of productions, not all of which are necessarily referenced in a
      complete grammar.</p>

      <p>References to nonterminals on the right-hand side of a production can also be parameterized. For example:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span><sub class="g-params">[In]</sub></div>
      </div>

      <p>is equivalent to saying:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement_In</span></div>
      </div>

      <p>A nonterminal reference may have both a parameter list and an &ldquo;<sub>opt</sub>&rdquo; suffix. For example:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">VariableDeclaration</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span><sub class="g-params">[In]</sub><sub class="g-opt">opt</sub></div>
      </div>

      <p>is an abbreviation for:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">VariableDeclaration</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span> <span class="nt">Initializer_In</span></div>
      </div>

      <p>Prefixing a parameter name with &ldquo;<sub>?</sub>&rdquo; on a right-hand side nonterminal reference makes that
      parameter value dependent upon the occurrence of the parameter name on the reference to the current production&rsquo;s
      left-hand side symbol. For example:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">VariableDeclaration</span><sub class="g-params">[In]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span><sub class="g-params">[?In]</sub></div>
      </div>

      <p>is an abbreviation for:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">VariableDeclaration</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span> <span class="nt">Initializer</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">VariableDeclaration_In</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">BindingIdentifier</span> <span class="nt">Initializer_In</span></div>
      </div>

      <p>If a right-hand side alternative is prefixed with &ldquo;[+parameter]&rdquo; that alternative is only available if the
      named parameter was used in referencing the production&rsquo;s nonterminal symbol. If a right-hand side alternative is
      prefixed with &ldquo;[~parameter]&rdquo; that alternative is only available if the named parameter was <i>not</i> used in
      referencing the production&rsquo;s nonterminal symbol. This means that:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span><sub class="g-params">[Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="grhsannot">[+Return]</span> <span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <p>is an abbreviation for:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList_Return</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <p>and that</p>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span><sub class="g-params">[Return]</sub> <span class="geq">:</span></div>
        <div class="rhs"><span class="grhsannot">[~Return]</span> <span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <p>is an abbreviation for:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ReturnStatement</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">StatementList_Return</span> <span class="geq">:</span></div>
        <div class="rhs"><span class="nt">ExpressionStatement</span></div>
      </div>

      <p>When the words &ldquo;<b>one of</b>&rdquo; follow the colon(s) in a grammar definition, they signify that each of the
      terminal symbols on the following line or lines is an alternative definition. For example, the lexical grammar for
      ECMAScript contains the production:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">NonZeroDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
        <div class="rhs"><code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code></div>
      </div>

      <p>which is merely a convenient abbreviation for:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">NonZeroDigit</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">1</code></div>
        <div class="rhs"><code class="t">2</code></div>
        <div class="rhs"><code class="t">3</code></div>
        <div class="rhs"><code class="t">4</code></div>
        <div class="rhs"><code class="t">5</code></div>
        <div class="rhs"><code class="t">6</code></div>
        <div class="rhs"><code class="t">7</code></div>
        <div class="rhs"><code class="t">8</code></div>
        <div class="rhs"><code class="t">9</code></div>
      </div>

      <p>If the phrase &ldquo;[empty]&rdquo; appears as the right-hand side of a production, it indicates that the production's
      right-hand side contains no terminals or nonterminals.</p>

      <p>If the phrase &ldquo;[lookahead &notin; <var>set</var>]&rdquo; appears in the right-hand side of a production, it
      indicates that the production may not be used if the immediately following input token sequence is a member of the given
      <var>set</var>. The <var>set</var> can be written as a comma separated list of one or two element terminal sequences
      enclosed in curly brackets. For convenience, the set can also be written as a nonterminal, in which case it represents the
      set of all terminals to which that nonterminal could expand. If the <var>set</var> consists of a single terminal the phrase
      &ldquo;[lookahead &ne; <var>terminal</var>]&rdquo; may be used.</p>

      <p>For example, given the definitions</p>

      <div class="gp">
        <div class="lhs"><span class="nt">DecimalDigit</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
        <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code></div>
      </div>

      <div class="gp">
        <div class="lhs"><span class="nt">DecimalDigits</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">DecimalDigit</span></div>
        <div class="rhs"><span class="nt">DecimalDigits</span> <span class="nt">DecimalDigit</span></div>
      </div>

      <p>the definition</p>

      <div class="gp">
        <div class="lhs"><span class="nt">LookaheadExample</span> <span class="geq">::</span></div>
        <div class="rhs"><code class="t">n</code> <span class="grhsannot">[lookahead &notin; {<code class="t">1</code>, <code class="t">3</code>, <code class="t">5</code>, <code class="t">7</code>, <code class="t">9</code>}]</span> <span class="nt">DecimalDigits</span></div>
        <div class="rhs"><span class="nt">DecimalDigit</span> <span class="grhsannot">[lookahead &notin; <span class="nt">DecimalDigit</span>]</span></div>
      </div>

      <p>matches either the letter <code>n</code> followed by one or more decimal digits the first of which is even, or a decimal
      digit not followed by another decimal digit.</p>

      <p>If the phrase &ldquo;[no <span class="nt">LineTerminator</span> here]&rdquo; appears in the right-hand side of a
      production of the syntactic grammar, it indicates that the production is <i>a restricted production</i>: it may not be used
      if a <span class="nt">LineTerminator</span> occurs in the input stream at the indicated position. For example, the
      production:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">ThrowStatement</span> <span class="geq">:</span></div>
        <div class="rhs"><code class="t">throw</code> <span class="grhsannot">[no <span class="nt">LineTerminator</span> here]</span> <span class="nt">Expression</span> <code class="t">;</code></div>
      </div>

      <p>indicates that the production may not be used if a <span class="nt">LineTerminator</span> occurs in the script between
      the <code>throw</code> token and the <span class="nt">Expression</span>.</p>

      <p>Unless the presence of a <span class="nt">LineTerminator</span> is forbidden by a restricted production, any number of
      occurrences of <span class="nt">LineTerminator</span> may appear between any two consecutive tokens in the stream of input
      elements without affecting the syntactic acceptability of the script.</p>

      <p>When an alternative in a production of the lexical grammar or the numeric string grammar appears to be a multi-code point
      token, it represents the sequence of code points that would make up such a token.</p>

      <p>The right-hand side of a production may specify that certain expansions are not permitted by using the phrase
      &ldquo;<b>but not</b>&rdquo; and then indicating the expansions to be excluded. For example, the production:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">Identifier</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="nt">IdentifierName</span> <span class="grhsmod">but not</span> <span class="nt">ReservedWord</span></div>
      </div>

      <p>means that the nonterminal <span class="nt">Identifier</span> may be replaced by any sequence of code points that could
      replace <span class="nt">IdentifierName</span> provided that the same sequence of code points could not replace <span class="nt">ReservedWord</span>.</p>

      <p>Finally, a few nonterminal symbols are described by a descriptive phrase in sans-serif type in cases where it would be
      impractical to list all the alternatives:</p>

      <div class="gp">
        <div class="lhs"><span class="nt">SourceCharacter</span> <span class="geq">::</span></div>
        <div class="rhs"><span class="gprose">any Unicode code point</span></div>
      </div>
    </section>
  </section>

  <section id="sec-algorithm-conventions">
    <h2 id="sec-5.2" title="5.2">
        Algorithm Conventions</h2><p>The specification often uses a numbered list to specify steps in an algorithm. These algorithms are used to precisely
    specify the required semantics of ECMAScript language constructs. The algorithms are not intended to imply the use of any
    specific implementation technique. In practice, there may be more efficient algorithms available to implement a given
    feature.</p>

    <p>Algorithms may be explicitly parameterized, in which case the names and usage of the parameters must be provided as part of
    the algorithm&rsquo;s definition. In order to facilitate their use in multiple parts of this specification, some algorithms,
    called <i>abstract</i> <i>operations</i>, are named and written in parameterized functional form so that they may be
    referenced by name from within other algorithms. Abstract operations are typically referenced using a functional application
    style such as <span style="font-family: Times New Roman">operationName(<i>arg1</i>, <i>arg2</i>)</span>. Some abstract
    operations are treated as polymorphically dispatched methods of class-like specification abstractions. Such method-like
    abstract operations are typically referenced using a method application style such as <span style="font-family: Times New     Roman"><i>someValue</i>.operationName(<i>arg1</i>, <i>arg2</i>)</span>.</p>

    <p>Algorithms may be associated with productions of one of the ECMAScript grammars. A production that has multiple alternative
    definitions will typically have a distinct algorithm for each alternative. When an algorithm is associated with a grammar
    production, it may reference the terminal and nonterminal symbols of the production alternative as if they were parameters of
    the algorithm. When used in this manner, nonterminal symbols refer to the actual alternative definition that is matched when
    parsing the source text.</p>

    <p>When an algorithm is associated with a production alternative, the alternative is typically shown without any &ldquo;[
    ]&rdquo; grammar annotations. Such annotations should only affect the syntactic recognition of the alternative and have no
    effect on the associated semantics for the alternative.</p>

    <p>Unless explicitly specified otherwise, all <a href="#sec-context-free-grammars">chain productions</a> have an implicit
    definition for every algorithm that might be applied to that production&rsquo;s left-hand side nonterminal. The implicit
    definition simply reapplies the same algorithm name with the same parameters, if any, to the <a href="#sec-context-free-grammars">chain production</a>&rsquo;s sole right-hand side nonterminal and then returns the result.
    For example, assume there is a production:</p>

    <div class="gp">
      <div class="lhs"><span class="nt">Block</span> <span class="geq">:</span></div>
      <div class="rhs"><code class="t">{</code> <span class="nt">StatementList</span> <code class="t">}</code></div>
    </div>

    <p>but there is no corresponding Evaluation algorithm that is explicitly specified for that production. If in some algorithm
    there is a statement of the form: &ldquo;<span style="font-family: Times New Roman">Return the result of evaluating
    <i>Block</i></span>&rdquo; it is implicit that an Evaluation algorithm exists of the form:</p>

    <p><b>Runtime Semantics: Evaluation</b></p>

    <div class="gp prod"><span class="nt">Block</span> <span class="geq">:</span> <code class="t">{</code> <span class="nt">StatementList</span> <code class="t">}</code></div>
    <ol class="proc">
      <li>Return the result of evaluating <i>StatementList</i>.</li>
    </ol>

    <p class="normalbefore">For clarity of expression, algorithm steps may be subdivided into sequential substeps. Substeps are
    indented and may themselves be further divided into indented substeps. Outline numbering conventions are used to identify
    substeps with the first level of substeps labelled with lower case alphabetic characters and the second level of substeps
    labelled with lower case roman numerals. If more than three levels are required these rules repeat with the fourth level using
    numeric labels. For example:</p>

    <ol class="proc">
      <li>Top-level step
        <ol class="block">
          <li>Substep.</li>
          <li>Substep.
            <ol class="block">
              <li>Subsubstep.
                <ol class="block">
                  <li>Subsubsubstep
                    <ol class="block">
                      <li>Subsubsubsubstep
                        <ol class="block">
                          <li>Subsubsubsubsubstep</li>
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
    </ol>

    <p>A step or substep may be written as an &ldquo;if&rdquo; predicate that conditions its substeps. In this case, the substeps
    are only applied if the predicate is true. If a step or substep begins with the word &ldquo;else&rdquo;, it is a predicate
    that is the negation of the preceding &ldquo;if&rdquo; predicate step at the same level.</p>

    <p>A step may specify the iterative application of its substeps.</p>

    <p>A step that begins with &ldquo;Assert:&rdquo; asserts an invariant condition of its algorithm. Such assertions are used to
    make explicit algorithmic invariants that would otherwise be implicit. Such assertions add no additional semantic requirements
    and hence need not be checked by an implementation. They are used simply to clarify algorithms.</p>

    <p>Mathematical operations such as addition, subtraction, negation, multiplication, division, and the mathematical functions
    defined later in this clause should always be understood as computing exact mathematical results on mathematical real numbers,
    which unless otherwise noted do not include infinities and do not include a negative zero that is distinguished from positive
    zero. Algorithms in this standard that model floating-point arithmetic include explicit steps, where necessary, to handle
    infinities and signed zero and to perform rounding. If a mathematical operation or function is applied to a floating-point
    number, it should be understood as being applied to the exact mathematical value represented by that floating-point number;
    such a floating-point number must be finite, and if it is <span class="value">+0</span> or <span class="value">&minus;0</span>
    then the corresponding mathematical value is simply <span class="value">0</span>.</p>

    <p>The mathematical function <span style="font-family: Times New Roman">abs(<i>x</i>)</span> produces the absolute value of
    <var>x</var>, which is <span style="font-family: Times New Roman">&minus;<i>x</i></span> if <var>x</var> is negative (less
    than zero) and otherwise is <var>x</var> itself.</p>

    <p>The mathematical function <span style="font-family: Times New Roman">sign(<i>x</i>)</span> produces <span style="font-family: Times New Roman">1</span> if <var>x</var> is positive and <span style="font-family: Times New     Roman">&minus;1</span> if <var>x</var> is negative. The sign function is not used in this standard for cases when <var>x</var>
    is zero.</p>

    <p>The mathematical function <span style="font-family: Times New Roman">min(<i>x</i><sub>1</sub>,</span> <span style="font-family: Times New Roman"><i>x</i><sub>2</sub>, ..., <i>x</i><sub>n</sub>)</span> produces the mathematically
    smallest of <span style="font-family: Times New Roman"><i>x</i><sub>1</sub></span> through <span style="font-family: Times New     Roman"><i>x</i><sub>n</sub></span>. The mathematical function <span style="font-family: Times New     Roman">max(<i>x</i><sub>1</sub>,</span> <span style="font-family: Times New Roman"><i>x</i><sub>2</sub>, ...,
    <i>x</i><sub>n</sub>)</span> produces the mathematically largest of <span style="font-family: Times New     Roman"><i>x</i><sub>1</sub></span> through <span style="font-family: Times New Roman"><i>x</i><sub>n</sub></span>. The domain
    and range of these mathematical functions include +<b>&infin;</b> and <b>&minus;&infin;</b>.</p>

    <p>The notation &ldquo;<span style="font-family: Times New Roman"><i>x</i> modulo <i>y</i></span>&rdquo; (<var>y</var> must be
    finite and nonzero) computes a value <var>k</var> of the same sign as <var>y</var> (or zero) such that <span style="font-family: Times New Roman">abs(<i>k</i>) &lt; abs(<i>y</i>) and <i>x</i>&minus;<i>k</i> = <i>q</i></span> <span style="font-family: Times New Roman">&times;</span> <var>y</var> for some integer <var>q</var>.</p>

    <p>The mathematical function <span style="font-family: Times New Roman">floor(<i>x</i>)</span> produces the largest integer
    (closest to positive infinity) that is not larger than <var>x</var>.</p>

    <div class="note">
      <p><span class="nh">NOTE</span> <span style="font-family: Times New Roman">floor(<i>x</i>) = <i>x</i>&minus;(<i>x</i> modulo
      1)</span>.</p>
    </div>
  </section>

  <section id="sec-static-semantic-rules">
    <h2 id="sec-5.3" title="5.3"> Static
        Semantic Rules</h2><p>Context-free grammars are not sufficiently powerful to express all the rules that define whether a stream of input elements
    form a valid ECMAScript <span class="nt">Script</span> or <span class="nt">Module</span> that may be evaluated. In some
    situations additional rules are needed that may be expressed using either ECMAScript algorithm conventions or prose
    requirements. Such rules are always associated with a production of a grammar and are called the <i>static semantics</i> of
    the production.</p>

    <p>Static Semantic Rules have names and typically are defined using an algorithm. Named Static Semantic Rules are associated
    with grammar productions and a production that has multiple alternative definitions will typically have for each alternative a
    distinct algorithm for each applicable named static semantic rule.</p>

    <p class="normalbefore">Unless otherwise specified every grammar production alternative in this specification implicitly has a
    definition for a static semantic rule named <span style="font-family: Times New Roman">Contains</span> which takes an argument
    named <var>symbol</var> whose value is a terminal or nonterminal of the grammar that includes the associated production. The
    default definition of <span style="font-family: Times New Roman">Contains</span> is:</p>

    <ol class="proc">
      <li>For each terminal and nonterminal grammar symbol, <i>sym</i>,  in the definition of this production do
        <ol class="block">
          <li>If <i>sym</i> is the same grammar symbol as <i>symbol</i>, return <b>true</b>.</li>
          <li>If <i>sym</i> is a nonterminal, then
            <ol class="block">
              <li>Let <i>contained</i> be the result of <i>sym</i> Contains <i>symbol</i>.</li>
              <li>If <i>contained</i> is <b>true</b>, return <b>true</b>.</li>
            </ol>
          </li>
        </ol>
      </li>
      <li>Return <b>false</b>.</li>
    </ol>

    <p>The above definition is explicitly over-ridden for specific productions.</p>

    <p>A special kind of static semantic rule is an Early Error Rule. Early error rules define early error conditions (see <a href="sec-error-handling-and-language-extensions">clause 16</a>) that are associated with specific grammar productions.
    Evaluation of most early error rules are not explicitly invoked within the algorithms of this specification. A conforming
    implementation must, prior to the first evaluation of a <span style="font-family: Times New Roman"><i>Script</i></span> or
    <span style="font-family: Times New Roman"><i>Module</i></span>, validate all of the early error rules of the productions used to parse that <span style="font-family:     Times New Roman"><i>Script</i></span> or <span style="font-family: Times New Roman"><i>Module</i></span>. If any of the early error rules are violated the <span style="font-family: Times New Roman"><i>Script</i></span> or <span style="font-family: Times New Roman"><i>Module</i></span> is invalid and cannot be evaluated.</p>
  </section>
</section>

