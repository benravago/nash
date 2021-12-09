<section id="sec-abstract-operations">
  <div class="front">
    <h1 id="sec-7" title="7"> Abstract
        Operations</h1><p>These operations are not a part of the ECMAScript language; they are defined here to solely to aid the specification of the
    semantics of the ECMAScript language. Other, more specialized abstract operations are defined throughout this
    specification.</p>
  </div>

  <section id="sec-type-conversion">
    <div class="front">
      <h2 id="sec-7.1" title="7.1"> Type
          Conversion</h2><p>The ECMAScript language implicitly performs automatic type conversion as needed. To clarify the semantics of certain
      constructs it is useful to define a set of conversion abstract operations. The conversion abstract operations are
      polymorphic; they can accept a value of any <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language type</a> or of a <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a> value. But no other specification types are used with
      these operations.</p>
    </div>

    <section id="sec-toprimitive">
      <h3 id="sec-7.1.1" title="7.1.1"> ToPrimitive
          ( input [, PreferredType] )</h3><p>The abstract operation ToPrimitive takes an <var>input</var> argument and an optional argument <span class="nt">PreferredType</span>. The abstract operation ToPrimitive converts its <var>input</var> argument to a non-Object
      type. If an object is capable of converting to more than one primitive type, it may use the optional hint <span class="nt">PreferredType</span> to favour that type. Conversion occurs according to <a href="#table-9">Table 9</a>:</p>

      <figure>
        <figcaption><span id="table-9">Table 9</span> &mdash; ToPrimitive Conversions</figcaption>
        <table class="real-table">
          <tr>
            <th>Input Type</th>
            <th>Result</th>
          </tr>
          <tr>
            <td><a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a></td>
            <td>If <var>input</var> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <var>input</var>. Otherwise return ToPrimitive(<var>input</var>.[[value]]) also passing the optional hint <span class="nt">PreferredType</span>.</td>
          </tr>
          <tr>
            <td>Undefined</td>
            <td>Return <var>input</var>.</td>
          </tr>
          <tr>
            <td>Null</td>
            <td>Return <var>input</var>.</td>
          </tr>
          <tr>
            <td>Boolean</td>
            <td>Return <var>input</var>.</td>
          </tr>
          <tr>
            <td>Number</td>
            <td>Return <var>input</var>.</td>
          </tr>
          <tr>
            <td>String</td>
            <td>Return <var>input</var>.</td>
          </tr>
          <tr>
            <td>Symbol</td>
            <td>Return <var>input</var>.</td>
          </tr>
          <tr>
            <td>Object</td>
            <td>Perform the steps following this table.</td>
          </tr>
        </table>
      </figure>

      <p class="normalbefore">When <span style="font-family: Times New Roman"><a href="sec-ecmascript-data-types-and-values">Type</a>(<i>input</i>)</span> is Object, the following steps are taken:</p>

      <ol class="proc">
        <li>If <i>PreferredType</i> was not passed, let <i>hint</i> be <code>"default"</code>.</li>
        <li>Else if <i>PreferredType</i> is hint String, let <i>hint</i> be <code>"string"</code>.</li>
        <li>Else <i>PreferredType</i> is hint Number, let <i>hint</i> be <code>"number"</code>.</li>
        <li>Let <i>exoticToPrim</i>  be <a href="#sec-getmethod">GetMethod</a>(<i>input</i>, @@toPrimitive).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exoticToPrim</i>).</li>
        <li>If <i>exoticToPrim</i> is not <b>undefined</b>, then
          <ol class="block">
            <li>Let <i>result</i> be <a href="#sec-call">Call</a>(<i>exoticToPrim</i>, <i>input,</i>
                &laquo;<i>hint</i>&raquo;).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>result</i>) is not Object, return
                <i>result</i>.</li>
            <li>Throw a <b>TypeError</b> exception.</li>
          </ol>
        </li>
        <li>If <i>hint</i> is <code>"default"</code>, let <i>hint</i> be <code>"number"</code>.</li>
        <li>Return OrdinaryToPrimitive(<i>input,hint</i>).</li>
      </ol>

      <p class="normalbefore">When the abstract operation OrdinaryToPrimitive is called with arguments <var>O</var> and
      <var>hint</var>, the following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>hint</i>)
            is String and its value is either <code>"string"</code> or <code>"number"</code>.</li>
        <li>If <i>hint</i> is <code>"string"</code>, then
          <ol class="block">
            <li>Let <i>methodNames</i> be &laquo;<code>"toString"</code>, <code>"valueOf"</code>&raquo;.</li>
          </ol>
        </li>
        <li>Else,
          <ol class="block">
            <li>Let <i>methodNames</i> be &laquo;<code>"valueOf"</code>, <code>"toString"</code>&raquo;.</li>
          </ol>
        </li>
        <li>For each <i>name</i> in <i>methodNames</i> in <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> order, do
          <ol class="block">
            <li>Let <i>method</i> be <a href="#sec-get-o-p">Get</a>(<i>O</i>, <i>name</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>method</i>).</li>
            <li>If <a href="#sec-iscallable">IsCallable</a>(<i>method</i>) is <b>true</b>, then
              <ol class="block">
                <li>Let <i>result</i> be <a href="#sec-call">Call</a>(<i>method</i>, <i>O</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
                <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>result</i>) is not Object, return
                    <i>result</i>.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Throw a <b>TypeError</b> exception.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> When ToPrimitive is called with no hint, then it generally behaves as if the hint were
        Number. However, objects may over-ride this behaviour by defining a @@toPrimitive method. Of the objects defined in this
        specification only Date objects (<a href="sec-numbers-and-dates#sec-date.prototype-@@toprimitive">see 20.3.4.45</a>) and Symbol objects (<a href="sec-fundamental-objects#sec-symbol.prototype-@@toprimitive">see 19.4.3.4</a>) over-ride the default ToPrimitive behaviour. Date objects
        treat no hint as if the hint were String.</p>
      </div>
    </section>

    <section id="sec-toboolean">
      <h3 id="sec-7.1.2" title="7.1.2"> ToBoolean (
          argument )</h3><p>The abstract operation ToBoolean converts <var>argument</var> to a value of type Boolean according to <a href="#table-10">Table 10</a>:</p>

      <figure>
        <figcaption><span id="table-10">Table 10</span> &mdash; ToBoolean Conversions</figcaption>
        <table class="real-table">
          <tr>
            <th>Argument Type</th>
            <th>Result</th>
          </tr>
          <tr>
            <td><a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a></td>
            <td>If <var>argument</var> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <var>argument</var>. Otherwise return ToBoolean(<var>argument</var>.[[value]]).</td>
          </tr>
          <tr>
            <td>Undefined</td>
            <td>Return <b>false</b>.</td>
          </tr>
          <tr>
            <td>Null</td>
            <td>Return <b>false</b>.</td>
          </tr>
          <tr>
            <td>Boolean</td>
            <td>Return <var>argument</var>.</td>
          </tr>
          <tr>
            <td>Number</td>
            <td>Return <b>false</b> if <var>argument</var> is <b>+0</b>, <b>&minus;0</b>, or <b>NaN</b>; otherwise return <b>true</b>.</td>
          </tr>
          <tr>
            <td>String</td>
            <td>Return <b>false</b> if <var>argument</var> is the empty String (its length is zero); otherwise return <b>true</b>.</td>
          </tr>
          <tr>
            <td>Symbol</td>
            <td>Return <b>true</b>.</td>
          </tr>
          <tr>
            <td>Object</td>
            <td>Return <b>true</b>.</td>
          </tr>
        </table>
      </figure>
    </section>

    <section id="sec-tonumber">
      <div class="front">
        <h3 id="sec-7.1.3" title="7.1.3"> ToNumber (
            argument )</h3><p>The abstract operation ToNumber converts <var>argument</var> to a value of type Number according to <a href="#table-11">Table 11</a>:</p>

        <figure>
          <figcaption><span id="table-11">Table 11</span> &mdash; ToNumber Conversions</figcaption>
          <table class="real-table">
            <tr>
              <th>Argument Type</th>
              <th>Result</th>
            </tr>
            <tr>
              <td><a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a></td>
              <td>If <var>argument</var> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <var>argument</var>. Otherwise return ToNumber(<var>argument</var>.[[value]]).</td>
            </tr>
            <tr>
              <td>Undefined</td>
              <td>Return <b>NaN</b>.</td>
            </tr>
            <tr>
              <td>Null</td>
              <td>Return <b>+0</b>.</td>
            </tr>
            <tr>
              <td>Boolean</td>
              <td>Return <b>1</b> if <var>argument</var> is <b>true</b>. Return <b>+0</b> if <var>argument</var> is <b>false</b>.</td>
            </tr>
            <tr>
              <td>Number</td>
              <td>Return <var>argument</var> (no conversion).</td>
            </tr>
            <tr>
              <td>String</td>
              <td>See grammar and conversion algorithm below.</td>
            </tr>
            <tr>
              <td>Symbol</td>
              <td>Throw a <b>TypeError</b> exception.</td>
            </tr>
            <tr>
              <td>Object</td>

              <td>
                <p>Apply the following steps:</p>

                <ol class="proc">
                  <li>Let <i>primValue</i> be <a href="#sec-toprimitive">ToPrimitive</a>(<i>argument</i>, hint Number).</li>
                  <li>Return ToNumber(<i>primValue</i>).</li>
                </ol>
              </td>
            </tr>
          </table>
        </figure>
      </div>

      <section id="sec-tonumber-applied-to-the-string-type">
        <div class="front">
          <h4 id="sec-7.1.3.1" title="7.1.3.1"> ToNumber Applied to the String Type</h4><p><a href="#sec-tonumber">ToNumber</a> applied to Strings applies the following grammar to the input String interpreted
          as a sequence of UTF-16 encoded code points (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>). If the
          grammar cannot interpret the String as an expansion of <span class="nt">StringNumericLiteral</span>, then the result of
          <a href="#sec-tonumber">ToNumber</a> is <b>NaN</b>.</p>

          <div class="note">
            <p><span class="nh">NOTE 1</span> The terminal symbols of this grammar are all composed of Unicode BMP code points so
            the result will be <b>NaN</b> if the string contains the UTF-16 encoding of any supplementary code points or any
            unpaired surrogate code points.</p>
          </div>

          <h2>Syntax</h2>

          <div class="gp">
            <div class="lhs"><span class="nt">StringNumericLiteral</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">StrWhiteSpace</span><sub class="g-opt">opt</sub></div>
            <div class="rhs"><span class="nt">StrWhiteSpace</span><sub class="g-opt">opt</sub> <span class="nt">StrNumericLiteral</span> <span class="nt">StrWhiteSpace</span><sub class="g-opt">opt</sub></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">StrWhiteSpace</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">StrWhiteSpaceChar</span> <span class="nt">StrWhiteSpace</span><sub class="g-opt">opt</sub></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">StrWhiteSpaceChar</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">WhiteSpace</span></div>
            <div class="rhs"><span class="nt">LineTerminator</span></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">StrNumericLiteral</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">StrDecimalLiteral</span></div>
            <div class="rhs"><span class="nt">BinaryIntegerLiteral</span></div>
            <div class="rhs"><span class="nt">OctalIntegerLiteral</span></div>
            <div class="rhs"><span class="nt">HexIntegerLiteral</span></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">StrDecimalLiteral</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">StrUnsignedDecimalLiteral</span></div>
            <div class="rhs"><code class="t">+</code> <span class="nt">StrUnsignedDecimalLiteral</span></div>
            <div class="rhs"><code class="t">-</code> <span class="nt">StrUnsignedDecimalLiteral</span></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">Infinity</span></div>
            <div class="rhs"><span class="nt">DecimalDigits</span> <code class="t">.</code> <span class="nt">DecimalDigits</span><sub class="g-opt">opt</sub> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
            <div class="rhs"><code class="t">.</code> <span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
            <div class="rhs"><span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span><sub class="g-opt">opt</sub></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">DecimalDigits</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">DecimalDigit</span></div>
            <div class="rhs"><span class="nt">DecimalDigits</span> <span class="nt">DecimalDigit</span></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">DecimalDigit</span> <span class="geq">:::</span> <span class="grhsmod">one of</span></div>
            <div class="rhs"><code class="t">0</code> <code class="t">1</code> <code class="t">2</code> <code class="t">3</code> <code class="t">4</code> <code class="t">5</code> <code class="t">6</code> <code class="t">7</code> <code class="t">8</code> <code class="t">9</code></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">ExponentPart</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">ExponentIndicator</span> <span class="nt">SignedInteger</span></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">ExponentIndicator</span> <span class="geq">:::</span> <span class="grhsmod">one of</span></div>
            <div class="rhs"><code class="t">e</code> <code class="t">E</code></div>
          </div>

          <div class="gp">
            <div class="lhs"><span class="nt">SignedInteger</span> <span class="geq">:::</span></div>
            <div class="rhs"><span class="nt">DecimalDigits</span></div>
            <div class="rhs"><code class="t">+</code> <span class="nt">DecimalDigits</span></div>
            <div class="rhs"><code class="t">-</code> <span class="nt">DecimalDigits</span></div>
          </div>

          <p>All grammar symbols not explicitly defined above have the definitions used in the Lexical Grammar for numeric
          literals (<a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">11.8.3</a>)</p>

          <div class="note">
            <p><span class="nh">NOTE 2</span> Some differences should be noted between the syntax of a <span class="nt">StringNumericLiteral</span> and a <span class="nt">NumericLiteral</span> (<a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">see 11.8.3</a>):</p>

            <ul>
              <li>
                <p>A <span class="nt">StringNumericLiteral</span> may include leading and/or trailing white space and/or line
                terminators.</p>
              </li>

              <li>
                <p>A <span class="nt">StringNumericLiteral</span> that is decimal may have any number of leading <code>0</code>
                digits.</p>
              </li>

              <li>
                <p>A <span class="nt">StringNumericLiteral</span> that is decimal may include a <code>+</code> or <code>-</code>
                to indicate its sign.</p>
              </li>

              <li>
                <p>A <span class="nt">StringNumericLiteral</span> that is empty or contains only white space is converted to
                <b>+0</b>.</p>
              </li>

              <li>
                <p><code>Infinity</code> <code>and &ndash;Infinity</code> are recognized as a <span class="nt">StringNumericLiteral</span>  but not as a  <span class="nt">NumericLiteral</span>.</p>
              </li>
            </ul>
          </div>
        </div>

        <section id="sec-runtime-semantics-mv-s">
          <h5 id="sec-7.1.3.1.1" title="7.1.3.1.1"> Runtime Semantics: MV&rsquo;s</h5><p>The conversion of a String to a Number value is similar overall to the determination of the Number value for a
          numeric literal (<a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">see 11.8.3</a>), but some of the details are different, so the
          process for converting a String numeric literal to a value of Number type is given here. This value is determined in two
          steps: first, a mathematical value (MV) is derived from the String numeric literal; second, this mathematical value is
          rounded as described below. The MV on any grammar symbol, not provided below, is the MV for that symbol defined in <a href="sec-ecmascript-language-lexical-grammar#sec-static-semantics-mv">11.8.3.1</a>.</p>

          <ul>
            <li>
              <p>The MV of <span class="prod"><span class="nt">StringNumericLiteral</span> <span class="geq">:::</span> <span class="grhsannot">[empty]</span></span> is 0.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StringNumericLiteral</span> <span class="geq">:::</span> <span class="nt">StrWhiteSpace</span></span> is 0.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StringNumericLiteral</span> <span class="geq">:::</span> <span class="nt">StrWhiteSpace</span><sub class="g-opt">opt</sub> <span class="nt">StrNumericLiteral</span> <span class="nt">StrWhiteSpace</span><sub class="g-opt">opt</sub></span> is the MV of <span class="nt">StrNumericLiteral</span>, no matter whether white space is present or not.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrNumericLiteral</span> <span class="geq">:::</span> <span class="nt">StrDecimalLiteral</span></span> is the MV of <span class="nt">StrDecimalLiteral</span>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrNumericLiteral</span> <span class="geq">:::</span> <span class="nt">BinaryIntegerLiteral</span></span> is the MV of <span class="nt">BinaryIntegerLiteral</span>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrNumericLiteral</span> <span class="geq">:::</span> <span class="nt">OctalIntegerLiteral</span></span> is the MV of <span class="nt">OctalIntegerLiteral</span>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrNumericLiteral</span> <span class="geq">:::</span> <span class="nt">HexIntegerLiteral</span></span> is the MV of <span class="nt">HexIntegerLiteral</span>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrDecimalLiteral</span> <span class="geq">:::</span> <span class="nt">StrUnsignedDecimalLiteral</span></span> is the MV of <span class="nt">StrUnsignedDecimalLiteral</span>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrDecimalLiteral</span> <span class="geq">:::</span> <code class="t">+</code> <span class="nt">StrUnsignedDecimalLiteral</span></span> is the MV of <span class="nt">StrUnsignedDecimalLiteral</span>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrDecimalLiteral</span> <span class="geq">:::</span> <code class="t">-</code> <span class="nt">StrUnsignedDecimalLiteral</span></span> is the negative of the MV of <span class="nt">StrUnsignedDecimalLiteral</span>. (Note that if the MV of <span class="nt">StrUnsignedDecimalLiteral</span> is 0, the negative of this MV is also 0. The rounding rule described
              below handles the conversion of this signless mathematical zero to a floating-point <b>+0</b> or <b>&minus;0</b> as
              appropriate.)</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span> <span class="nt">Infinity</span></span> is <span style="font-family: Times New Roman">10<sup>10000</sup></span> (a value
              so large that it will round to <b>+&infin;</b>).</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span> <span class="nt">DecimalDigits</span> <code class="t">.</code></span> is the MV of <span class="nt">DecimalDigits</span>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span> <span class="nt">DecimalDigits</span> <code class="t">.</code> <span class="nt">DecimalDigits</span></span> is the MV of
              the first <span class="nt">DecimalDigits</span> plus (the MV of the second <span class="nt">DecimalDigits</span>
              times <span style="font-family: Times New Roman">10<sup>&minus;<i>n</i></sup></span>), where <var>n</var> is the
              number of code points in the second <span class="nt">DecimalDigits</span>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span> <span class="nt">DecimalDigits</span> <code class="t">.</code> <span class="nt">ExponentPart</span></span> is the MV of
              <i>DecimalDigits</i> times 10<sup><i>e</i></sup>, where <i>e</i> is the MV of <i>ExponentPart</i>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span> <span class="nt">DecimalDigits</span> <code class="t">.</code> <span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span></span> is (the MV of the first <i>DecimalDigits</i> plus (the MV of the second
              <i>DecimalDigits</i> times 10<sup>&minus;<i>n</i></sup>)) times 10<sup><i>e</i></sup>, where <i>n</i> is the number
              of code points in the second <i>DecimalDigits</i> and <i>e</i> is the MV of <i>ExponentPart</i>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span> <code class="t">.</code> <span class="nt">DecimalDigits</span></span> is the MV of <i>DecimalDigits</i> times
              10<sup>&minus;<i>n</i></sup>, where <i>n</i> is the number of code points in <i>DecimalDigits</i>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span> <code class="t">.</code> <span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span></span> is the MV of
              <i>DecimalDigits</i> times 10<sup><i>e</i>&minus;<i>n</i></sup>, where <i>n</i> is the number of code points in
              <i>DecimalDigits</i> and <i>e</i> is the MV of <i>ExponentPart</i>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span> <span class="nt">DecimalDigits</span></span> is the MV of <i>DecimalDigits</i>.</p>
            </li>

            <li>
              <p>The MV of <span class="prod"><span class="nt">StrUnsignedDecimalLiteral</span> <span class="geq">:::</span> <span class="nt">DecimalDigits</span> <span class="nt">ExponentPart</span></span> is the MV of <i>DecimalDigits</i> times
              10<sup><i>e</i></sup>, where <i>e</i> is the MV of <i>ExponentPart</i>.</p>
            </li>
          </ul>

          <p>Once the exact MV for a String numeric literal has been determined, it is then rounded to a value of the Number type.
          If the MV is 0, then the rounded value is +0 unless the first non white space code point in the String numeric literal
          is &lsquo;<code>-</code>&rsquo;, in which case the rounded value is &minus;0. Otherwise, the rounded value must be the
          Number value for the MV (in the sense defined in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-number-type">6.1.6</a>), unless
          the literal includes a <span class="nt">StrUnsignedDecimalLiteral</span> and the literal has more than 20 significant
          digits, in which case the Number value may be either the Number value for the MV of a literal produced by replacing each
          significant digit after the 20th with a 0 digit or the Number value for the MV of a literal produced by replacing each
          significant digit after the 20th with a 0 digit and then incrementing the literal at the 20th digit position. A digit is
          significant if it is not part of an <span class="nt">ExponentPart</span> and</p>

          <ul>
            <li>it is not <code>0</code>; or</li>
            <li>there is a nonzero digit to its left and there is a nonzero digit, not in the <span class="nt">ExponentPart</span>, to its right.</li>
          </ul>
        </section>
      </section>
    </section>

    <section id="sec-tointeger">
      <h3 id="sec-7.1.4" title="7.1.4"> ToInteger (
          argument )</h3><p class="normalbefore">The abstract operation ToInteger converts <var>argument</var> to an integral numeric value. This
      abstract operation functions as follows:</p>

      <ol class="proc">
        <li>Let <i>number</i> be <a href="#sec-tonumber">ToNumber</a>(<i>argument</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>number</i>).</li>
        <li>If <i>number</i> is <b>NaN</b>, return <b>+0</b>.</li>
        <li>If <i>number</i> is <b>+0</b>, <b>&minus;0</b>, <b>+&infin;,</b> or <b>&minus;&infin;</b>, return <i>number</i>.</li>
        <li>Return the number value that is the same sign as  <i>number</i> and whose magnitude is <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>number</i>)).</li>
      </ol>
    </section>

    <section id="sec-toint32">
      <h3 id="sec-7.1.5" title="7.1.5"> ToInt32 (
          argument )</h3><p class="normalbefore">The abstract operation ToInt32 converts <var>argument</var> to one of <span style="font-family:       Times New Roman">2<sup>32</sup></span> integer values in the range <span style="font-family: Times New       Roman">&minus;2<sup>31</sup></span> through <span style="font-family: Times New Roman">2<sup>31</sup>&minus;1</span>,
      inclusive. This abstract operation functions as follows:</p>

      <ol class="proc">
        <li>Let <i>number</i> be <a href="#sec-tonumber">ToNumber</a>(<i>argument</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>number</i>).</li>
        <li>If <i>number</i> is <b>NaN</b>, <b>+0</b>, <b>&minus;0</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return
            <b>+0</b>.</li>
        <li>Let <i>int</i> be the mathematical value that is the same sign as <i>number</i> and whose magnitude is <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>number</i>)).</li>
        <li>Let <i>int32bit</i> be <i>int</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 2<sup>32</sup>.</li>
        <li>If <i>int32bit</i> &ge; 2<sup>31</sup>, return <i>int32bit</i> &minus; 2<sup>32</sup>, otherwise return
            <i>int32bit</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Given the above definition of ToInt32:</p>

        <ul>
          <li>
            <p>The ToInt32 abstract operation is idempotent: if applied to a result that it produced, the second application
            leaves that value unchanged.</p>
          </li>

          <li>
            <p><var>ToInt32(<a href="#sec-touint32">ToUint32</a>(x))</var> is equal to <span style="font-family: Times New             Roman">ToInt32(<i>x</i>)</span> for all values of <var>x</var>. (It is to preserve this latter property that
            +<b>&infin;</b> and &minus;<b>&infin;</b> are mapped to <b>+0</b>.)</p>
          </li>

          <li>
            <p>ToInt32 maps <b>&minus;0</b> to <b>+0</b>.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-touint32">
      <h3 id="sec-7.1.6" title="7.1.6"> ToUint32 (
          argument )</h3><p class="normalbefore">The abstract operation ToUint32 converts <var>argument</var> to one of <span style="font-family:       Times New Roman">2<sup>32</sup></span> integer values in the range <span style="font-family: Times New Roman">0</span>
      through <span style="font-family: Times New Roman">2<sup>32</sup>&minus;1</span>, inclusive. This abstract operation
      functions as follows:</p>

      <ol class="proc">
        <li>Let <i>number</i> be <a href="#sec-tonumber">ToNumber</a>(<i>argument</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>number</i>).</li>
        <li>If <i>number</i> is <b>NaN</b>, <b>+0</b>, <b>&minus;0</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return
            <b>+0</b>.</li>
        <li>Let <i>int</i> be the mathematical value that is the same sign as <i>number</i> and whose magnitude is <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>number</i>)).</li>
        <li>Let <i>int32bit</i> be <i>int</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 2<sup>32</sup>.</li>
        <li>Return <i>int32bit</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Given the above definition of ToUint32:</p>

        <ul>
          <li>
            <p>Step 6 is the only difference between ToUint32 and <a href="#sec-toint32">ToInt32</a>.</p>
          </li>

          <li>
            <p>The ToUint32 abstract operation is idempotent: if applied to a result that it produced, the second application
            leaves that value unchanged.</p>
          </li>

          <li>
            <p><span style="font-family: Times New Roman">ToUint32(<a href="#sec-toint32">ToInt32</a>(<i>x</i>))</span> is equal
            to <span style="font-family: Times New Roman">ToUint32(<i>x</i>)</span> for all values of <var>x</var>. (It is to
            preserve this latter property that <b>+&infin;</b> and <b>&minus;&infin;</b> are mapped to <b>+0</b>.)</p>
          </li>

          <li>
            <p>ToUint32 maps <b>&minus;0</b> to <b>+0</b>.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-toint16">
      <h3 id="sec-7.1.7" title="7.1.7"> ToInt16 (
          argument )</h3><p>The abstract operation ToInt16 converts <var>argument</var> to one of <span style="font-family: Times New       Roman">2<sup>16</sup></span> integer values in the range <span style="font-family: Times New Roman">&minus;32768</span>
      through <span style="font-family: Times New Roman">32767</span>, inclusive. This abstract operation functions as
      follows:</p>

      <ol class="proc">
        <li>Let <i>number</i> be <a href="#sec-tonumber">ToNumber</a>(<i>argument</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>number</i>).</li>
        <li>If <i>number</i> is <b>NaN</b>, <b>+0</b>, <b>&minus;0</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return
            <b>+0</b>.</li>
        <li>Let <i>int</i> be the mathematical value that is the same sign as <i>number</i> and whose magnitude is <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>number</i>)).</li>
        <li>Let <i>int16bit</i> be <i>int</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 2<sup>16</sup>.</li>
        <li>If <i>int16bit</i> &ge; 2<sup>15</sup>, return <i>int16bit</i> &minus; 2<sup>16</sup>, otherwise return
            <i>int16bit</i>.</li>
      </ol>
    </section>

    <section id="sec-touint16">
      <h3 id="sec-7.1.8" title="7.1.8"> ToUint16 (
          argument )</h3><p class="normalbefore">The abstract operation ToUint16 converts <var>argument</var> to one of <span style="font-family:       Times New Roman">2<sup>16</sup></span> integer values in the range <span style="font-family: Times New Roman">0</span>
      through <span style="font-family: Times New Roman">2<sup>16</sup>&minus;1</span>, inclusive. This abstract operation
      functions as follows:</p>

      <ol class="proc">
        <li>Let <i>number</i> be <a href="#sec-tonumber">ToNumber</a>(<i>argument</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>number</i>).</li>
        <li>If <i>number</i> is <b>NaN</b>, <b>+0</b>, <b>&minus;0</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return
            <b>+0</b>.</li>
        <li>Let <i>int</i> be the mathematical value that is the same sign as <i>number</i> and whose magnitude is <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>number</i>)).</li>
        <li>Let <i>int16bit</i> be <i>int</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 2<sup>16</sup>.</li>
        <li>Return <i>int16bit</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Given the above definition of ToUint16:</p>

        <ul>
          <li>The substitution of <span style="font-family: Times New Roman">2<sup>16</sup></span> for <span style="font-family:               Times New Roman">2<sup>32</sup></span> in step 5 is the only difference between <a href="#sec-touint32">ToUint32</a>
              and ToUint16.</li>
          <li>ToUint16 maps <b>&minus;0</b> to <b>+0</b>.</li>
        </ul>
      </div>
    </section>

    <section id="sec-toint8">
      <h3 id="sec-7.1.9" title="7.1.9"> ToInt8 (
          argument )</h3><p class="normalbefore">The abstract operation ToInt8 converts <var>argument</var> to one of <span style="font-family: Times       New Roman">2<sup>8</sup></span> integer values in the range <span style="font-family: Times New Roman">&minus;128</span>
      through <span style="font-family: Times New Roman">127</span>, inclusive. This abstract operation functions as follows:</p>

      <ol class="proc">
        <li>Let <i>number</i> be <a href="#sec-tonumber">ToNumber</a>(<i>argument</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>number</i>).</li>
        <li>If <i>number</i> is <b>NaN</b>, <b>+0</b>, <b>&minus;0</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return
            <b>+0</b>.</li>
        <li>Let <i>int</i> be the mathematical value that is the same sign as <i>number</i> and whose magnitude is <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>number</i>)).</li>
        <li>Let <i>int8bit</i> be <i>int</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 2<sup>8</sup>.</li>
        <li>If <i>int8bit</i> &ge; 2<sup>7</sup>, return <i>int8bit</i> &minus; 2<sup>8</sup>, otherwise return
            <i>int8bit</i>.</li>
      </ol>
    </section>

    <section id="sec-touint8">
      <h3 id="sec-7.1.10" title="7.1.10"> ToUint8 (
          argument )</h3><p class="normalbefore">The abstract operation ToUint8 converts <var>argument</var> to one of <span style="font-family:       Times New Roman">2<sup>8</sup></span> integer values in the range <span style="font-family: Times New Roman">0</span>
      through <span style="font-family: Times New Roman">255</span>, inclusive. This abstract operation functions as follows:</p>

      <ol class="proc">
        <li>Let <i>number</i> be <a href="#sec-tonumber">ToNumber</a>(<i>argument</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>number</i>).</li>
        <li>If <i>number</i> is <b>NaN</b>, <b>+0</b>, <b>&minus;0</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return
            <b>+0</b>.</li>
        <li>Let <i>int</i> be the mathematical value that is the same sign as <i>number</i> and whose magnitude is <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>number</i>)).</li>
        <li>Let <i>int8bit</i> be <i>int</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 2<sup>8</sup>.</li>
        <li>Return <i>int8bit</i>.</li>
      </ol>
    </section>

    <section id="sec-touint8clamp">
      <h3 id="sec-7.1.11" title="7.1.11">
          ToUint8Clamp ( argument )</h3><p class="normalbefore">The abstract operation ToUint8Clamp converts <var>argument</var> to one of <span style="font-family:       Times New Roman">2<sup>8</sup></span> integer values in the range <span style="font-family: Times New Roman">0</span>
      through <span style="font-family: Times New Roman">255</span>, inclusive. This abstract operation functions as follows:</p>

      <ol class="proc">
        <li>Let <i>number</i> be <a href="#sec-tonumber">ToNumber</a>(<i>argument</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>number</i>).</li>
        <li>If <i>number</i> is <b>NaN</b>, return <b>+0</b>.</li>
        <li>If <i>number</i> &le; 0, return <b>+0</b>.</li>
        <li>If <i>number</i> &ge; 255, return 255.</li>
        <li>Let <i>f</i> be <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<i>number</i>).</li>
        <li>If <i>f +</i> 0.5 &lt; <i>number</i>, return <i>f</i> + 1.</li>
        <li>If <i>number</i> &lt; <i>f +</i> 0.5, return <i>f</i>.</li>
        <li>If <i>f</i> is odd, return <i>f</i> + 1.</li>
        <li>Return <i>f</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Unlike the other ECMAScript integer conversion abstract operation, ToUint8Clamp rounds
        rather than truncates non-integer values and does not convert +<b>&infin;</b> to 0. ToUint8Clamp does &ldquo;round half to
        even&rdquo; tie-breaking. This differs from <code><a href="sec-numbers-and-dates#sec-math.round">Math.round</a></code> which does &ldquo;round
        half up&rdquo; tie-breaking.</p>
      </div>
    </section>

    <section id="sec-tostring">
      <div class="front">
        <h3 id="sec-7.1.12" title="7.1.12"> ToString (
            argument )</h3><p>The abstract operation ToString converts <var>argument</var> to a value of type String according to <a href="#table-12">Table 12</a>:</p>

        <figure>
          <figcaption><span id="table-12">Table 12</span> &mdash; ToString Conversions</figcaption>
          <table class="real-table">
            <tr>
              <th>Argument Type</th>
              <th>Result</th>
            </tr>
            <tr>
              <td><a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a></td>
              <td>If <var>argument</var> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <var>argument</var>. Otherwise return ToString(<var>argument</var>.[[value]]).</td>
            </tr>
            <tr>
              <td>Undefined</td>
              <td>Return <code>"undefined"</code>.</td>
            </tr>
            <tr>
              <td>Null</td>
              <td>Return <code>"null"</code>.</td>
            </tr>
            <tr>
              <td>Boolean</td>

              <td>
                <p>If <var>argument</var> is <b>true</b>, return <code>"true"</code>.</p>

                <p>If <var>argument</var> is <b>false</b>, return <b><code>"false"</code>.</b></p>
              </td>
            </tr>
            <tr>
              <td>Number</td>
              <td>See <a href="#sec-tostring-applied-to-the-number-type">7.1.12.1</a>.</td>
            </tr>
            <tr>
              <td>String</td>
              <td>Return <var>argument</var>.</td>
            </tr>
            <tr>
              <td>Symbol</td>
              <td>Throw a <b>TypeError</b> exception.</td>
            </tr>
            <tr>
              <td>Object</td>

              <td>
                <p>Apply the following steps:</p>

                <p>1. Let <i>primValue</i> be <a href="#sec-toprimitive">ToPrimitive</a>(<i>argument</i>, hint String).</p>

                <p>2. Return ToString(<i>primValue</i>).</p>
              </td>
            </tr>
          </table>
        </figure>
      </div>

      <section id="sec-tostring-applied-to-the-number-type">
        <h4 id="sec-7.1.12.1" title="7.1.12.1"> ToString Applied to the Number Type</h4><p class="normalbefore">The abstract operation <a href="#sec-tostring">ToString</a> converts a Number <var>m</var> to
        String format as follows:</p>

        <ol class="proc">
          <li>If <i>m</i> is <b>NaN</b>, return the String <code>"NaN"</code>.</li>
          <li>If <i>m</i> is <b>+0</b> or <b>&minus;0</b>, return the String <code>"0"</code>.</li>
          <li>If <i>m</i> is less than zero, return the String concatenation of the String <code>"-"</code> and <a href="#sec-tostring">ToString</a>(&minus;<i>m</i>).</li>
          <li>If <i>m</i> is +&infin;, return the String <code>"Infinity"</code>.</li>
          <li>Otherwise, let <i>n</i>, <i>k</i>, and <i>s</i> be integers such that <i>k</i> &ge; 1, 10<sup><i>k</i>&minus;1</sup>
              &le; <i>s</i> &lt; 10<sup><i>k</i></sup>, the Number value for <i>s</i> &times; 10<sup><i>n&minus;k</i></sup> is
              <i>m</i>, and <i>k</i> is as small as possible. Note that <i>k</i> is the number of digits in the decimal
              representation of <i>s</i>, that <i>s</i> is not divisible by 10, and that the least significant digit of <i>s</i>
              is not necessarily uniquely determined by these criteria.</li>
          <li>If <i>k</i> &le; <i>n</i> &le; 21, return the String consisting of the code units of the <i>k</i> digits of the
              decimal representation of <i>s</i> (in order, with no leading zeroes), followed by <i>n&minus;k</i> occurrences of
              the code unit 0x0030 (DIGIT ZERO).</li>
          <li>If 0 &lt; <i>n</i> &le; 21, return the String consisting of the code units of the most significant <i>n</i> digits
              of the decimal representation of <i>s</i>, followed by the code unit 0x002E (FULL STOP), followed by the code units
              of the remaining <i>k&minus;n</i> digits of the decimal representation of <i>s</i>.</li>
          <li>If &minus;6 &lt; <i>n</i> &le; 0, return the String consisting of the code unit 0x0030 (DIGIT ZERO), followed by the
              code unit 0x002E (FULL STOP), followed by &minus;<i>n</i> occurrences of the code unit 0x0030 (DIGIT ZERO), followed
              by the code units of the <i>k</i> digits of the decimal representation of <i>s</i>.</li>
          <li>Otherwise, if <i>k</i> = 1, return the String consisting of the code unit of the single digit of <i>s</i>, followed
              by code unit 0x0065 (LATIN SMALL LETTER E), followed by the code unit 0x002B (PLUS SIGN) or the code unit 0x002D
              (HYPHEN-MINUS) according to whether <i>n</i>&minus;1 is positive or negative, followed by the code units of the
              decimal representation of the integer <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>n</i>&minus;1) (with no
              leading zeroes).</li>
          <li>Return the String consisting of the code units of the most significant digit of the decimal representation of
              <i>s</i>, followed by code unit 0x002E (FULL STOP), followed by the code units of the remaining <i>k</i>&minus;1
              digits of the decimal representation of <i>s</i>, followed by code unit 0x0065 (LATIN SMALL LETTER E), followed by
              code unit 0x002B (PLUS SIGN) or the code unit 0x002D (HYPHEN-MINUS) according to whether <i>n</i>&minus;1 is
              positive or negative, followed by the code units of the decimal representation of the integer <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>n</i>&minus;1) (with no leading zeroes).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The following observations may be useful as guidelines for implementations, but are
          not part of the normative requirements of this Standard:</p>

          <ul>
            <li>
              <p>If x is any Number value other than <b>&minus;0</b>, then <a href="#sec-tonumber">ToNumber</a>(<a href="#sec-tostring">ToString</a>(x)) is exactly the same Number value as x.</p>
            </li>

            <li>
              <p>The least significant digit of s is not always uniquely determined by the requirements listed in step 5.</p>
            </li>
          </ul>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> For implementations that provide more accurate conversions than required by the rules
          above, it is recommended that the following alternative version of step 5 be used as a guideline:</p>

          <p class="special4">5.&#x9;Otherwise, let <i>n</i>, <i>k</i>, and <i>s</i> be integers such that <i>k</i> &ge; 1,
          10<sup><i>k</i>&minus;1</sup> &le; <i>s</i> &lt; 10<sup><i>k</i></sup>, the Number value for <i>s</i> &times;
          10<sup><i>n</i>&minus;<i>k</i></sup> is <i>m</i>, and <i>k</i> is as small as possible. If there are multiple
          possibilities for <i>s</i>, choose the value of <i>s</i> for which <i>s</i> &times; 10<sup><i>n</i>&minus;<i>k</i></sup>
          is closest in value to <i>m</i>. If there are two such possible values of <i>s</i>, choose the one that is even. Note
          that <i>k</i> is the number of digits in the decimal representation of <i>s</i> and that <i>s</i> is not divisible by
          10.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> Implementers of ECMAScript may find useful the paper and code written by David M. Gay
          for binary-to-decimal conversion of floating-point numbers:</p>

          <p>Gay, David M. Correctly Rounded Binary-Decimal and Decimal-Binary Conversions. Numerical Analysis, Manuscript 90-10.
          AT&amp;T Bell Laboratories (Murray Hill, New Jersey). November 30, 1990. Available as<br /><a href="http://cm.bell-labs.com/cm/cs/doc/90/4-10.ps.gz">http://cm.bell-labs.com/cm/cs/doc/90/4-10.ps.gz</a>. Associated
          code available as<br /><a href="http://netlib.sandia.gov/fp/dtoa.c">http://netlib.sandia.gov/fp/dtoa.c</a>&nbsp;and&nbsp;as<br /><a href="http://netlib.sandia.gov/fp/g_fmt.c">http://netlib.sandia.gov/fp/g_fmt.c</a> and may also be found at the various
          <code>netlib</code> mirror sites.</p>
        </div>
      </section>
    </section>

    <section id="sec-toobject">
      <h3 id="sec-7.1.13" title="7.1.13"> ToObject (
          argument )</h3><p>The abstract operation ToObject converts <var>argument</var> to a value of type Object according to <a href="#table-13">Table 13</a>:</p>

      <figure>
        <figcaption><span id="table-13">Table 13</span> &mdash; ToObject Conversions</figcaption>
        <table class="real-table">
          <tr>
            <th>Argument Type</th>
            <th>Result</th>
          </tr>
          <tr>
            <td><a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a></td>
            <td>If <i>argument</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <i>argument</i>. Otherwise return ToObject(<i>argument</i>.[[value]]).</td>
          </tr>
          <tr>
            <td>Undefined</td>
            <td>Throw a <b>TypeError</b> exception.</td>
          </tr>
          <tr>
            <td>Null</td>
            <td>Throw a <b>TypeError</b> exception.</td>
          </tr>
          <tr>
            <td>Boolean</td>
            <td>Return a new Boolean object whose [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is set to the value of <i>argument</i>. See <a href="sec-fundamental-objects#sec-boolean-objects">19.3</a> for a description of Boolean objects.</td>
          </tr>
          <tr>
            <td>Number</td>
            <td>Return a new Number object whose [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is set to the value of <i>argument</i>. See <a href="sec-numbers-and-dates#sec-number-objects">20.1</a> for a description of Number objects.</td>
          </tr>
          <tr>
            <td>String</td>
            <td>Return a new String object whose [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is set to the value of <i>argument</i>. See <a href="sec-text-processing#sec-string-objects">21.1</a> for a description of String objects.</td>
          </tr>
          <tr>
            <td>Symbol</td>
            <td>Return a new Symbol object whose [[SymbolData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is set to the value of <i>argument</i>. See <a href="sec-fundamental-objects#sec-symbol-objects">19.4</a> for a description of Symbol objects.</td>
          </tr>
          <tr>
            <td>Object</td>
            <td>Return <i>argument</i>.</td>
          </tr>
        </table>
      </figure>
    </section>

    <section id="sec-topropertykey">
      <h3 id="sec-7.1.14" title="7.1.14">
          ToPropertyKey ( argument )</h3><p class="normalbefore">The abstract operation ToPropertyKey converts <var>argument</var> to a value that can be used as a
      <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> by performing the following steps:</p>

      <ol class="proc">
        <li>Let <i>key</i> be <a href="#sec-toprimitive">ToPrimitive</a>(<i>argument</i>, hint String).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>key</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>key</i>) is Symbol, then
          <ol class="block">
            <li>Return <i>key</i>.</li>
          </ol>
        </li>
        <li>Return <a href="#sec-tostring">ToString</a>(<i>key</i>).</li>
      </ol>
    </section>

    <section id="sec-tolength">
      <h3 id="sec-7.1.15" title="7.1.15"> ToLength (
          argument )</h3><p class="normalbefore">The abstract operation ToLength converts <var>argument</var> to an integer suitable for use as the
      length of an array-like object. It performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>argument</i>).</li>
        <li>Let <i>len</i> be <a href="#sec-tointeger">ToInteger</a>(<i>argument</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
        <li>If <i>len</i> &le; +0, return +0.</li>
        <li>If <i>len</i> is <b>+&infin;</b>, return 2<sup>53</sup>-1.</li>
        <li>Return min(<i>len</i>, 2<sup>53</sup>-1).</li>
      </ol>
    </section>

    <section id="sec-canonicalnumericindexstring">
      <h3 id="sec-7.1.16" title="7.1.16"> CanonicalNumericIndexString ( argument )</h3><p class="normalbefore">The abstract operation CanonicalNumericIndexString returns <var>argument</var> converted to a
      numeric value if it is a String representation of a Number that would be produced by <a href="#sec-tostring">ToString</a>,
      or the string <code>"-0"</code>. Otherwise, it returns <span class="value">undefined.</span> This abstract operation
      functions as follows:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>argument</i>) is String.</li>
        <li>If <i>argument</i> is <code>"-0"</code>, return &minus;0.</li>
        <li>Let <i>n</i> be <a href="#sec-tonumber">ToNumber</a>(<i>argument</i>).</li>
        <li>If <a href="#sec-samevalue">SameValue</a>(<a href="#sec-tostring">ToString</a>(<i>n</i>), <i>argument</i>) is
            <b>false</b>, return <b>undefined</b>.</li>
        <li>Return <i>n</i>.</li>
      </ol>

      <p>A <i>canonical numeric string</i> is any String value for which the CanonicalNumericIndexString abstract operation does
      not return <span class="value">undefined</span>.</p>
    </section>
  </section>

  <section id="sec-testing-and-comparison-operations">
    <div class="front">
      <h2 id="sec-7.2" title="7.2"> Testing and Comparison Operations</h2></div>

    <section id="sec-requireobjectcoercible">
      <h3 id="sec-7.2.1" title="7.2.1">
          RequireObjectCoercible ( argument )</h3><p>The abstract operation RequireObjectCoercible throws an error if <var>argument</var> is a value that cannot be converted
      to an Object using <a href="#sec-toobject">ToObject</a>. It is defined by <a href="#table-14">Table 14</a>:</p>

      <figure>
        <figcaption><span id="table-14">Table 14</span>&nbsp;&mdash; RequireObjectCoercible Results</figcaption>
        <table class="real-table">
          <tr>
            <th>Argument Type</th>
            <th>Result</th>
          </tr>
          <tr>
            <td><a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a></td>
            <td>If <var>argument</var> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <var>argument</var>. Otherwise return RequireObjectCoercible(<var>argument</var>.[[value]]).</td>
          </tr>
          <tr>
            <td>Undefined</td>
            <td>Throw a <b>TypeError</b> exception.</td>
          </tr>
          <tr>
            <td>Null</td>
            <td>Throw a <b>TypeError</b> exception.</td>
          </tr>
          <tr>
            <td>Boolean</td>
            <td>Return <var>argument</var>.</td>
          </tr>
          <tr>
            <td>Number</td>
            <td>Return <var>argument</var>.</td>
          </tr>
          <tr>
            <td>String</td>
            <td>Return <var>argument</var>.</td>
          </tr>
          <tr>
            <td>Symbol</td>
            <td>Return <var>argument</var>.</td>
          </tr>
          <tr>
            <td>Object</td>
            <td>Return <var>argument</var>.</td>
          </tr>
        </table>
      </figure>
    </section>

    <section id="sec-isarray">
      <h3 id="sec-7.2.2" title="7.2.2"> IsArray (
          argument )</h3><p class="normalbefore">The abstract operation IsArray takes one argument <var>argument</var>, and performs the following
      steps:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>argument</i>) is not Object, return <b>false</b>.</li>
        <li>If <i>argument</i> is an <a href="sec-ordinary-and-exotic-objects-behaviours#sec-array-exotic-objects">Array exotic object</a>, return <b>true</b>.</li>
        <li>If <i>argument</i> is a Proxy exotic object, then
          <ol class="block">
            <li>If the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>
                of <i>argument</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
            <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>argument</i>.</li>
            <li>Return IsArray(<i>target</i>).</li>
          </ol>
        </li>
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-iscallable">
      <h3 id="sec-7.2.3" title="7.2.3"> IsCallable (
          argument )</h3><p>The abstract operation IsCallable determines if <var>argument</var>, which must be an <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> or a <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a>, is a callable function with a [[Call]] internal
      method.</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>argument</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>argument</i>) is not Object, return <b>false</b>.</li>
        <li>If <i>argument</i> has a [[Call]] internal method, return <b>true</b>.</li>
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-isconstructor">
      <h3 id="sec-7.2.4" title="7.2.4">
          IsConstructor ( argument )</h3><p class="normalbefore">The abstract operation IsConstructor determines if <var>argument</var>, which must be an <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> or a <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a>, is a function object with a [[Construct]] internal
      method.</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>argument</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>argument</i>) is not Object, return <b>false</b>.</li>
        <li>If <i>argument</i> has a [[Construct]] internal method, return <b>true</b>.</li>
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-isextensible-o">
      <h3 id="sec-7.2.5" title="7.2.5">
          IsExtensible (O)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">IsExtensible</span> is used to
      determine whether additional properties can be added to the object that is <var>O</var>. A Boolean value is returned. This
      abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li>Return <i>O</i>.[[IsExtensible]]().</li>
      </ol>
    </section>

    <section id="sec-isinteger">
      <h3 id="sec-7.2.6" title="7.2.6"> IsInteger (
          argument )</h3><p class="normalbefore">The abstract operation IsInteger determines if <var>argument</var> is a finite integer numeric
      value.</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>argument</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>argument</i>) is not Number, return <b>false</b>.</li>
        <li>If <i>argument</i> is <b>NaN</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return <b>false</b>.</li>
        <li>If <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>argument</i>)) &ne;
            <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>argument</i>), return <b>false</b>.</li>
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-ispropertykey">
      <h3 id="sec-7.2.7" title="7.2.7">
          IsPropertyKey ( argument )</h3><p class="normalbefore">The abstract operation IsPropertyKey determines if <var>argument</var>, which must be an <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> or a <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a>, is a value that may be used as a <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>.</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>argument</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>argument</i>) is String, return <b>true</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>argument</i>) is Symbol, return <b>true</b>.</li>
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-isregexp">
      <h3 id="sec-7.2.8" title="7.2.8"> IsRegExp (
          argument )</h3><p class="normalbefore">The abstract operation IsRegExp with argument <var>argument</var> performs the following steps:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>argument</i>) is not Object, return <b>false</b>.</li>
        <li>Let <i>isRegExp</i> be <a href="#sec-get-o-p">Get</a>(<i>argument</i>, @@match).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>isRegExp</i>).</li>
        <li>If <i>isRegExp</i> is not <b>undefined</b>, return <a href="#sec-toboolean">ToBoolean</a>(<i>isRegExp</i>).</li>
        <li>If <i>argument</i> has a [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
            slot</a>, return <b>true</b>.</li>
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-samevalue">
      <h3 id="sec-7.2.9" title="7.2.9"> SameValue(x,
          y)</h3><p class="normalbefore">The internal comparison abstract operation SameValue(<var>x</var>, <var>y</var>), where <var>x</var>
      and <var>y</var> are <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a>, produces <b>true</b> or
      <b>false</b>. Such a comparison is performed as follows:</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>x</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>y</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is different from <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>y</i>), return <b>false</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Undefined, return <b>true</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Null, return <b>true</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Number, then
          <ol class="block">
            <li>If <i>x</i> is <b>NaN</b> and <i>y</i> is <b>NaN</b>, return <b>true</b>.</li>
            <li>If <i>x</i> is <b>+0</b> and <i>y</i> is <b>&minus;0</b>, return <b>false</b>.</li>
            <li>If <i>x</i> is <b>&minus;0</b> and <i>y</i> is <b>+0</b>, return <b>false</b>.</li>
            <li>If <i>x</i> is the same Number value as <i>y</i>, return <b>true</b>.</li>
            <li>Return <b>false</b>.</li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is String, then
          <ol class="block">
            <li>If <i>x</i> and <i>y</i> are exactly the same sequence of code units (same length and same code units at
                corresponding indices) return <b>true</b>; otherwise, return <b>false</b>.</li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Boolean, then
          <ol class="block">
            <li>If <i>x</i> and <i>y</i> are both <b>true</b> or both <b>false</b>, return <b>true</b>; otherwise, return
                <b>false</b>.</li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Symbol, then
          <ol class="block">
            <li>If <i>x</i> and <i>y</i> are both the same Symbol value, return <b>true</b>; otherwise, return <b>false</b>.</li>
          </ol>
        </li>
        <li>Return <b>true</b> if <i>x</i> and <i>y</i> are the same Object value. Otherwise, return <b>false</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> This algorithm differs from the Strict Equality Comparison Algorithm (<a href="#sec-strict-equality-comparison">7.2.13</a>) in its treatment of signed zeroes and NaNs.</p>
      </div>
    </section>

    <section id="sec-samevaluezero">
      <h3 id="sec-7.2.10" title="7.2.10">
          SameValueZero(x, y)</h3><p class="normalbefore">The internal comparison abstract operation SameValueZero(<var>x</var>, <var>y</var>), where
      <var>x</var> and <var>y</var> are <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a>, produces
      <b>true</b> or <b>false</b>. Such a comparison is performed as follows:</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>x</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>y</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is different from <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>y</i>), return <b>false</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Undefined, return <b>true</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Null, return <b>true</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Number, then
          <ol class="block">
            <li>If <i>x</i> is <b>NaN</b> and <i>y</i> is <b>NaN</b>, return <b>true</b>.</li>
            <li>If <i>x</i> is <b>+0</b> and <i>y</i> is <b>&minus;0</b>, return <b>true</b>.</li>
            <li>If <i>x</i> is <b>&minus;0</b> and <i>y</i> is <b>+0</b>, return <b>true</b>.</li>
            <li>If <i>x</i> is the same Number value as <i>y</i>, return <b>true</b>.</li>
            <li>Return <b>false</b>.</li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is String, then
          <ol class="block">
            <li>If <i>x</i> and <i>y</i> are exactly the same sequence of code units (same length and same code units at
                corresponding indices) return <b>true</b>; otherwise, return <b>false</b>.</li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Boolean, then
          <ol class="block">
            <li>If <i>x</i> and <i>y</i> are both <b>true</b> or both <b>false</b>, return <b>true</b>; otherwise, return
                <b>false</b>.</li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Symbol, then
          <ol class="block">
            <li>If <i>x</i> and <i>y</i> are both the same Symbol value, return <b>true</b>; otherwise, return <b>false</b>.</li>
          </ol>
        </li>
        <li>Return <b>true</b> if <i>x</i> and <i>y</i> are the same Object value. Otherwise, return <b>false</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> SameValueZero differs from SameValue only in its treatment of <span class="value">+0</span> and <span class="value">&minus;0</span>.</p>
      </div>
    </section>

    <section id="sec-abstract-relational-comparison">
      <h3 id="sec-7.2.11" title="7.2.11"> Abstract Relational Comparison</h3><p class="normalbefore">The comparison <var>x</var> &lt; <var>y</var>, where <var>x</var> and <var>y</var> are values,
      produces <b>true</b>, <b>false</b>, or <b>undefined</b> (which indicates that at least one operand is <b>NaN</b>). In
      addition to <var>x</var> and <var>y</var> the algorithm takes a Boolean flag named <span class="nt">LeftFirst</span> as a
      parameter. The flag is used to control the order in which operations with potentially visible side-effects are performed
      upon <var>x</var> and <var>y</var>. It is necessary because ECMAScript specifies left to right evaluation of expressions.
      The default value of <span class="nt">LeftFirst</span> is <b>true</b> and indicates that the <var>x</var> parameter
      corresponds to an expression that occurs to the left of the <var>y</var> parameter&rsquo;s corresponding expression. If
      <span class="nt">LeftFirst</span> is <b>false</b>, the reverse is the case and operations must be performed upon
      <var>y</var> before <var>x</var>. Such a comparison is performed as follows:</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>x</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>y</i>).</li>
        <li>If the <i>LeftFirst</i> flag is <b>true</b>, then
          <ol class="block">
            <li>Let <i>px</i> be <a href="#sec-toprimitive">ToPrimitive</a>(<i>x</i>, hint Number).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>px</i>).</li>
            <li>Let <i>py</i> be <a href="#sec-toprimitive">ToPrimitive</a>(<i>y</i>, hint Number).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>py</i>).</li>
          </ol>
        </li>
        <li>Else the order of evaluation needs to be reversed to preserve left to right evaluation
          <ol class="block">
            <li>Let <i>py</i> be <a href="#sec-toprimitive">ToPrimitive</a>(<i>y</i>, hint Number).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>py</i>).</li>
            <li>Let <i>px</i> be <a href="#sec-toprimitive">ToPrimitive</a>(<i>x</i>, hint Number).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>px</i>).</li>
          </ol>
        </li>
        <li>If both <i>px</i> and <i>py</i> are Strings, then
          <ol class="block">
            <li>If <i>py</i> is a prefix of <i>px</i>, return <b>false</b>. (A String value <i>p</i> is a prefix of String value
                <i>q</i> if <i>q</i> can be the result of concatenating <i>p</i> and some other String <i>r</i>. Note that any
                String is a prefix of itself, because <i>r</i> may be the empty String.)</li>
            <li>If <i>px</i> is a prefix of <i>py</i>, return <b>true</b>.</li>
            <li>Let <i>k</i> be the smallest nonnegative integer such that the code unit at index <i>k</i> within <i>px</i> is
                different from the code unit at index <i>k</i> within <i>py</i>. (There must be such a <i>k</i>, for neither
                String is a prefix of the other.)</li>
            <li>Let <i>m</i> be the integer that is the code unit value at index <i>k</i> within <i>px</i>.</li>
            <li>Let <i>n</i> be the integer that is the code unit value at index <i>k</i> within <i>py</i>.</li>
            <li>If <i>m</i> &lt; <i>n</i>, return <b>true</b>. Otherwise, return <b>false</b>.</li>
          </ol>
        </li>
        <li>Else,
          <ol class="block">
            <li>Let <i>nx</i> be <a href="#sec-tonumber">ToNumber</a>(<i>px</i>). Because <i>px</i> and <i>py</i> are primitive
                values evaluation order is not important.</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nx</i>).</li>
            <li>Let <i>ny</i> be <a href="#sec-tonumber">ToNumber</a>(<i>py</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>ny</i>).</li>
            <li>If <i>nx</i> is <b>NaN</b>, return <b>undefined</b>.</li>
            <li>If <i>ny</i> is <b>NaN</b>, return <b>undefined</b>.</li>
            <li>If <i>nx</i> and <i>ny</i> are the same Number value, return <b>false</b>.</li>
            <li>If <i>nx</i> is <b>+0</b> and <i>ny</i> is <b>&minus;0</b>, return <b>false</b>.</li>
            <li>If <i>nx</i> is <b>&minus;0</b> and <i>ny</i> is <b>+0</b>, return <b>false</b>.</li>
            <li>If <i>nx</i> is <b>+&infin;</b>, return <b>false</b>.</li>
            <li>If <i>ny</i> is <b>+&infin;</b>, return <b>true</b>.</li>
            <li>If <i>ny</i> is <b>&minus;&infin;</b>, return <b>false</b>.</li>
            <li>If <i>nx</i> is <b>&minus;&infin;</b>, return <b>true</b>.</li>
            <li>If the mathematical value of <i>nx</i> is less than the mathematical value of <i>ny</i> &mdash;note that these
                mathematical values are both finite and not both zero&mdash;return <b>true</b>. Otherwise, return
                <b>false</b>.</li>
          </ol>
        </li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 1</span> Step 5 differs from step 11 in the algorithm for the addition operator <code>+</code>
        (<a href="sec-ecmascript-language-expressions#sec-addition-operator-plus">12.7.3</a>) in using &ldquo;and&rdquo; instead of &ldquo;or&rdquo;.</p>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 2</span> The comparison of Strings uses a simple lexicographic ordering on sequences of code unit
        values. There is no attempt to use the more complex, semantically oriented definitions of character or string equality and
        collating order defined in the Unicode specification. Therefore String values that are canonically equal according to the
        Unicode standard could test as unequal. In effect this algorithm assumes that both Strings are already in normalized form.
        Also, note that for strings containing supplementary characters, lexicographic ordering on sequences of UTF-16 code unit
        values differs from that on sequences of code point values.</p>
      </div>
    </section>

    <section id="sec-abstract-equality-comparison">
      <h3 id="sec-7.2.12" title="7.2.12"> Abstract Equality Comparison</h3><p class="normalbefore">The comparison <var>x</var> == <var>y</var>, where <var>x</var> and <var>y</var> are values,
      produces <b>true</b> or <b>false</b>. Such a comparison is performed as follows:</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>x</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>y</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is the same as <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>y</i>), then
          <ol class="block">
            <li>Return the result of performing Strict Equality Comparison <i>x</i> === <i>y</i>.</li>
          </ol>
        </li>
        <li>If <i>x</i> is <b>null</b> and <i>y</i> is <b>undefined</b>, return <b>true</b>.</li>
        <li>If <i>x</i> is <b>undefined</b> and <i>y</i> is <b>null</b>, return <b>true</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Number and <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>y</i>) is String,<br />return the result of the comparison
            <i>x</i> == <a href="#sec-tonumber">ToNumber</a>(<i>y</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is String and <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>y</i>) is Number,<br />return the result of the comparison <a href="#sec-tonumber">ToNumber</a>(<i>x</i>) == <i>y</i>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Boolean, return the result of the comparison
            <a href="#sec-tonumber">ToNumber</a>(<i>x</i>) == <i>y</i>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>y</i>) is Boolean, return the result of the comparison
            <i>x</i> == <a href="#sec-tonumber">ToNumber</a>(<i>y</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is either String, Number, or Symbol and <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>y</i>) is Object, then<br />return the result of the comparison
            <i>x</i> == <a href="#sec-toprimitive">ToPrimitive</a>(<i>y</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Object and <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>y</i>) is either String, Number, or Symbol, then<br />return
            the result of the comparison <a href="#sec-toprimitive">ToPrimitive</a>(<i>x</i>) == <i>y</i>.</li>
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-strict-equality-comparison">
      <h3 id="sec-7.2.13" title="7.2.13"> Strict Equality Comparison</h3><p class="normalbefore">The comparison <var>x</var> === <var>y</var>, where <var>x</var> and <var>y</var> are values,
      produces <b>true</b> or <b>false</b>. Such a comparison is performed as follows:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is different from <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>y</i>), return <b>false</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Undefined, return <b>true</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Null, return <b>true</b>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Number, then
          <ol class="block">
            <li>If <i>x</i> is <b>NaN</b>, return <b>false</b>.</li>
            <li>If <i>y</i> is <b>NaN</b>, return <b>false</b>.</li>
            <li>If <i>x</i> is the same Number value as <i>y</i>, return <b>true</b>.</li>
            <li>If <i>x</i> is <b>+0</b> and <i>y</i> is <b>&minus;0</b>, return <b>true</b>.</li>
            <li>If <i>x</i> is <b>&minus;0</b> and <i>y</i> is <b>+0</b>, return <b>true</b>.</li>
            <li>Return <b>false</b>.</li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is String, then
          <ol class="block">
            <li>If <i>x</i> and <i>y</i> are exactly the same sequence of code units (same length and same code units at
                corresponding indices), return <b>true</b>.</li>
            <li>Else, return <b>false</b>.</li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is Boolean, then
          <ol class="block">
            <li>If <i>x</i> and <i>y</i> are both <b>true</b> or both <b>false</b>, return <b>true</b>.</li>
            <li>Else, return <b>false</b>.</li>
          </ol>
        </li>
        <li>If <i>x</i> and <i>y</i> are the same Symbol value, return <b>true</b>.</li>
        <li>If <i>x</i> and <i>y</i> are the same Object value, return <b>true</b>.</li>
        <li>Return <b>false</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> This algorithm differs from <a href="#sec-samevalue">the SameValue Algorithm</a> (<a href="#sec-samevalue">7.2.9</a>) in its treatment of signed zeroes and NaNs.</p>
      </div>
    </section>
  </section>

  <section id="sec-operations-on-objects">
    <div class="front">
      <h2 id="sec-7.3" title="7.3">
          Operations on Objects</h2></div>

    <section id="sec-get-o-p">
      <h3 id="sec-7.3.1" title="7.3.1"> Get (O, P)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">Get</span> is used to retrieve the
      value of a specific property of an object. The operation is called with arguments  <var>O</var> and <var>P</var> where
      <var>O</var> is the object and <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>. This abstract operation
      performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Return <i>O</i>.[[Get]](<i>P</i>, <i>O</i>).</li>
      </ol>
    </section>

    <section id="sec-getv">
      <h3 id="sec-7.3.2" title="7.3.2"> GetV (V, P)</h3><p class="normalbefore">The abstract operation GetV is used to retrieve the value of a specific property of an <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a>. If the value is not an object, the property lookup is
      performed using a wrapper object appropriate for the type of the value. The operation is called with arguments <var>V</var>
      and <var>P</var> where <var>V</var> is the value and <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>. This
      abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>O</i> be <a href="#sec-toobject">ToObject</a>(<i>V</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
        <li>Return <i>O</i>.[[Get]](<i>P</i>, <i>V</i>).</li>
      </ol>
    </section>

    <section id="sec-set-o-p-v-throw">
      <h3 id="sec-7.3.3" title="7.3.3"> Set (O,
          P, V, Throw)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">Set</span> is used to set the
      value of a specific property of an object. The operation is called with arguments  <var>O</var>, <var>P</var>, <var>V</var>,
      and <span class="nt">Throw</span> where <var>O</var> is the object, <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property
      key</a>, <var>V</var> is the new value for the property and <span class="nt">Throw</span> is a Boolean flag. This abstract
      operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>Throw</i>) is Boolean.</li>
        <li>Let  <i>success</i> be <i>O</i>.[[Set]](<i>P</i>, <i>V</i>, <i>O</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>success</i>).</li>
        <li>If <i>success</i> is <b>false</b> and <i>Throw</i> is <b>true</b>, throw a <b>TypeError</b> exception.</li>
        <li>Return <i>success</i>.</li>
      </ol>
    </section>

    <section id="sec-createdataproperty">
      <h3 id="sec-7.3.4" title="7.3.4">
          CreateDataProperty (O, P, V)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">CreateDataProperty</span> is used
      to create a new own property of an object. The operation is called with arguments  <var>O</var>, <var>P</var>, and
      <var>V</var> where <var>O</var> is the object, <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>, and
      <var>V</var> is the value for the property. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>newDesc</i> be the PropertyDescriptor{[[Value]]: <i>V</i>, [[Writable]]: <b>true</b>, [[Enumerable]]:
            <b>true</b>, [[Configurable]]: <b>true</b>}.</li>
        <li>Return <i>O</i>.[[DefineOwnProperty]](<i>P</i>, <i>newDesc</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> This abstract operation creates a property whose attributes are set to the same defaults
        used for properties created by the ECMAScript language assignment operator. Normally, the property will not already exist.
        If it does exist and is not configurable or if <var>O</var> is not extensible, [[DefineOwnProperty]] will return <span class="value">false</span>.</p>
      </div>
    </section>

    <section id="sec-createmethodproperty">
      <h3 id="sec-7.3.5" title="7.3.5">
          CreateMethodProperty (O, P, V)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">CreateMethodProperty</span> is
      used to create a new own property of an object. The operation is called with arguments <var>O</var>, <var>P</var>, and
      <var>V</var> where <var>O</var> is the object, <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>, and
      <var>V</var> is the value for the property. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>newDesc</i> be the PropertyDescriptor{[[Value]]: <i>V</i>, [[Writable]]: <b>true</b>, [[Enumerable]]:
            <b>false</b>, [[Configurable]]: <b>true</b>}.</li>
        <li>Return <i>O</i>.[[DefineOwnProperty]](<i>P</i>, <i>newDesc</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> This abstract operation creates a property whose attributes are set to the same defaults
        used for built-in methods and methods defined using class declaration syntax. Normally, the property will not already
        exist. If it does exist and is not configurable or if <var>O</var> is not extensible, [[DefineOwnProperty]] will return
        <span class="value">false</span>.</p>
      </div>
    </section>

    <section id="sec-createdatapropertyorthrow">
      <h3 id="sec-7.3.6" title="7.3.6"> CreateDataPropertyOrThrow (O, P, V)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">CreateDataPropertyOrThrow</span>
      is used to create a new own property of an object. It throws a <span class="value">TypeError</span> exception if the
      requested property update cannot be performed. The operation is called with arguments  <var>O</var>, <var>P</var>, and
      <var>V</var> where <var>O</var> is the object, <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>, and
      <var>V</var> is the value for the property. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let  <i>success</i> be <a href="#sec-createdataproperty">CreateDataProperty</a>(<i>O</i>,  <i>P</i>, <i>V</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>success</i>).</li>
        <li>If <i>success</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
        <li>Return <i>success</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> This abstract operation creates a property whose attributes are set to the same defaults
        used for properties created by the ECMAScript language assignment operator. Normally, the property will not already exist.
        If it does exist and is not configurable or if <var>O</var> is not extensible, [[DefineOwnProperty]] will return <span class="value">false</span> causing this operation to throw a <span class="value">TypeError</span> exception.</p>
      </div>
    </section>

    <section id="sec-definepropertyorthrow">
      <h3 id="sec-7.3.7" title="7.3.7">
          DefinePropertyOrThrow (O, P, desc)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">DefinePropertyOrThrow</span> is
      used to call the [[DefineOwnProperty]] internal method of an object in a manner that will throw a <b>TypeError</b> exception
      if the requested property update cannot be performed. The operation is called with arguments  <var>O</var>, <var>P</var>,
      and <var>desc</var> where <var>O</var> is the object, <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>, and
      <var>desc</var> is the <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a> for the property. This
      abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let  <i>success</i> be <i>O</i>.[[DefineOwnProperty]](<i>P</i>, <i>desc</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>success</i>).</li>
        <li>If <i>success</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
        <li>Return <i>success</i>.</li>
      </ol>
    </section>

    <section id="sec-deletepropertyorthrow">
      <h3 id="sec-7.3.8" title="7.3.8">
          DeletePropertyOrThrow (O, P)</h3><p class="normalbefore">The abstract operation DeletePropertyOrThrow is used to remove a specific own property of an object.
      It throws an exception if the property is not configurable. The operation is called with arguments  <var>O</var> and
      <var>P</var> where <var>O</var> is the object and <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>. This
      abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let  <i>success</i> be <i>O</i>.[[Delete]](<i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>success</i>).</li>
        <li>If <i>success</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
        <li>Return <i>success</i>.</li>
      </ol>
    </section>

    <section id="sec-getmethod">
      <h3 id="sec-7.3.9" title="7.3.9"> GetMethod (O,
          P)</h3><p>The abstract operation GetMethod is used to get the value of a specific property of an object when the value of the
      property is expected to be a function. The operation is called with arguments <var>O</var> and <var>P</var> where
      <var>O</var> is the object, <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>. This abstract operation
      performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let  <i>func</i> be <a href="#sec-getv">GetV</a>(<i>O</i>, <i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>func</i>).</li>
        <li>If <i>func</i> is either <b>undefined</b> or <b>null</b>, return <b>undefined</b>.</li>
        <li>If <a href="#sec-iscallable">IsCallable</a>(<i>func</i>) is <b>false</b>, throw a <b>TypeError</b> exception.</li>
        <li>Return <i>func</i>.</li>
      </ol>
    </section>

    <section id="sec-hasproperty">
      <h3 id="sec-7.3.10" title="7.3.10">
          HasProperty (O, P)</h3><p class="normalbefore">The abstract operation HasProperty is used to determine whether an object has a property with the
      specified <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>. The property may be either an own or inherited. A Boolean value is
      returned. The operation is called with arguments  <var>O</var> and <var>P</var> where <var>O</var> is the object and
      <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Return <i>O</i>.[[HasProperty]](<i>P</i>).</li>
      </ol>
    </section>

    <section id="sec-hasownproperty">
      <h3 id="sec-7.3.11" title="7.3.11">
          HasOwnProperty (O, P)</h3><p class="normalbefore">The abstract operation HasOwnProperty is used to determine whether an object has an own property
      with the specified <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>. A Boolean value is returned. The operation is called with
      arguments  <var>O</var> and <var>P</var> where <var>O</var> is the object and <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>desc</i> be <i>O</i>.[[GetOwnProperty]](<i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
        <li>If <i>desc</i> is <b>undefined</b>, return <b>false</b>.</li>
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-call">
      <h3 id="sec-7.3.12" title="7.3.12"> Call(F, V,
          [argumentsList])</h3><p class="normalbefore">The abstract operation Call is used to call the [[Call]] internal method of a function object. The
      operation is called with arguments  <var>F</var>, <var>V</var> , and optionally <var>argumentsList</var> where <var>F</var>
      is the function object, <var>V</var> is an <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> that is
      the <b>this</b> value of the [[Call]], and <var>argumentsList</var> is the value passed to the corresponding argument of the
      internal method. If <var>argumentsList</var> is not present, an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> is used as its value. This abstract operation performs the following
      steps:</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>F</i>).</li>
        <li>If <i>argumentsList</i> was not passed, let <i>argumentsList</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>If <a href="#sec-iscallable">IsCallable</a>(<i>F</i>) is <b>false</b>, throw a <b>TypeError</b> exception.</li>
        <li>Return <i>F</i>.[[Call]](<i>V</i>, <i>argumentsList</i>).</li>
      </ol>
    </section>

    <section id="sec-construct">
      <h3 id="sec-7.3.13" title="7.3.13"> Construct
          (F, [argumentsList], [newTarget])</h3><p class="normalbefore">The abstract operation Construct is used to call the [[Construct]] internal method of a function
      object. The operation is called with arguments  <var>F</var>, and optionally <span style="font-family: Times New       Roman"><i>argumentsList</i>, and <i>newTarget</i></span> where <var>F</var> is the function object. <var>argumentsList</var>
      and <var>newTarget</var> are the values to be passed as the corresponding arguments of the internal method. If
      <var>argumentsList</var> is not present, an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> is used as its
      value. If <var>newTarget</var> is not present, <var>F</var> is used as its value. This abstract operation performs the
      following steps:</p>

      <ol class="proc">
        <li>If <i>newTarget</i> was not passed, let <i>newTarget</i> be <i>F</i>.</li>
        <li>If <i>argumentsList</i> was not passed, let <i>argumentsList</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="#sec-isconstructor">IsConstructor</a> (<i>F</i>) is
            <b>true</b>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="#sec-isconstructor">IsConstructor</a> (<i>newTarget</i>) is
            <b>true</b>.</li>
        <li>Return <i>F</i>.[[Construct]](<i>argumentsList</i>, <i>newTarget</i>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> If <var>newTarget</var> is not passed, this operation is equivalent to: <code>new
        F(...argumentsList)</code></p>
      </div>
    </section>

    <section id="sec-setintegritylevel">
      <h3 id="sec-7.3.14" title="7.3.14">
          SetIntegrityLevel (O, level)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">SetIntegrityLevel</span> is used
      to fix the set of own properties of an object. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>level</i> is either <code>"sealed"</code> or
            <code>"frozen"</code>.</li>
        <li>Let <i>status</i> be <i>O</i>.[[PreventExtensions]]().</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
        <li>If <i>status</i> is <b>false</b>, return <b>false</b>.</li>
        <li>Let <i>keys</i> be <i>O</i>.[[OwnPropertyKeys]]().</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keys</i>).</li>
        <li>If <i>level</i> is <code>"sealed"</code>, then
          <ol class="block">
            <li>Repeat for each element <i>k</i> of <i>keys</i>,
              <ol class="block">
                <li>Let <i>status</i> be <a href="#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>O</i>, <i>k</i>,
                    PropertyDescriptor{ [[Configurable]]: <b>false</b>}).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Else <i>level</i> is <code>"frozen"</code>,
          <ol class="block">
            <li>Repeat for each element <i>k</i> of <i>keys</i>,
              <ol class="block">
                <li>Let <i>currentDesc</i> be <i>O</i>.[[GetOwnProperty]](<i>k</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>currentDesc</i>).</li>
                <li>If <i>currentDesc</i> is not <b>undefined</b>, then
                  <ol class="block">
                    <li>If <a href="sec-ecmascript-data-types-and-values#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>currentDesc</i>) is <b>true</b>, then
                      <ol class="block">
                        <li>Let <i>desc</i> be the PropertyDescriptor{[[Configurable]]: <b>false</b>}.</li>
                      </ol>
                    </li>
                    <li>Else,
                      <ol class="block">
                        <li>Let <i>desc</i> be the PropertyDescriptor { [[Configurable]]: <b>false</b>, [[Writable]]: <b>false</b>
                            }.</li>
                      </ol>
                    </li>
                    <li>Let <i>status</i> be <a href="#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>O</i>, <i>k</i>,
                        <i>desc</i>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                  </ol>
                </li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-testintegritylevel">
      <h3 id="sec-7.3.15" title="7.3.15">
          TestIntegrityLevel (O, level)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">TestIntegrityLevel</span> is used
      to determine if the set of own properties of an object are fixed. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>level</i> is either <code>"sealed"</code> or
            <code>"frozen"</code>.</li>
        <li>Let <i>status</i> be <a href="#sec-isextensible-o">IsExtensible</a>(<i>O</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
        <li>If <i>status</i> is <b>true</b>, return <b>false</b></li>
        <li>NOTE  If the object is extensible, none of its properties are examined.</li>
        <li>Let <i>keys</i> be <i>O</i>.[[OwnPropertyKeys]]().</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keys</i>).</li>
        <li>Repeat for each element <i>k</i> of <i>keys</i>,
          <ol class="block">
            <li>Let <i>currentDesc</i> be <i>O</i>.[[GetOwnProperty]](<i>k</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>currentDesc</i>).</li>
            <li>If <i>currentDesc</i> is not <b>undefined</b>, then
              <ol class="block">
                <li>If <i>currentDesc</i>.[[Configurable]] is <b>true</b>, return <b>false</b>.</li>
                <li>If <i>level</i> is <code>"frozen"</code> and  <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>currentDesc</i>) is <b>true</b>, then
                  <ol class="block">
                    <li>If <i>currentDesc</i>.[[Writable]] is <b>true</b>, return <b>false</b>.</li>
                  </ol>
                </li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-createarrayfromlist">
      <h3 id="sec-7.3.16" title="7.3.16">
          CreateArrayFromList (elements)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">CreateArrayFromList</span> is used
      to create an Array object whose elements are provided by a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>. This
      abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>elements</i> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose elements are all <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a>.</li>
        <li>Let <i>array</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0) (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">see 9.4.2.2</a>).</li>
        <li>Let <i>n</i> be 0.</li>
        <li>For each element <i>e</i> of <i>elements</i>
          <ol class="block">
            <li>Let <i>status</i> be <a href="#sec-createdataproperty">CreateDataProperty</a>(<i>array</i>, <a href="#sec-tostring">ToString</a>(<i>n</i>), <i>e</i>).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>status</i> is <b>true</b>.</li>
            <li>Increment <i>n</i> by 1.</li>
          </ol>
        </li>
        <li>Return <i>array</i>.</li>
      </ol>
    </section>

    <section id="sec-createlistfromarraylike">
      <h3 id="sec-7.3.17" title="7.3.17"> CreateListFromArrayLike (obj [, elementTypes] )</h3><p class="normalbefore">The abstract operation CreateListFromArrayLike is used to create a List value whose elements are
      provided by the indexed properties of an array-like object, <var>obj</var>. The optional argument <var>elementTypes</var> is
      a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the names of ECMAScript Language Types that are
      allowed for element values of the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is created. This abstract
      operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>obj</i>).</li>
        <li>If <i>elementTypes</i> was not passed, let <i>elementTypes</i> be (Undefined, Null, Boolean, String, Symbol, Number,
            Object).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>obj</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>len</i> be <a href="#sec-tolength">ToLength</a>(<a href="#sec-get-o-p">Get</a>(<i>obj</i>,
            <code>"length"</code>)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
        <li>Let <i>list</i>  be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Let <i>index</i> be 0.</li>
        <li>Repeat while <i>index</i> &lt; <i>len</i>
          <ol class="block">
            <li>Let <i>indexName</i> be <a href="#sec-tostring">ToString</a>(<i>index</i>).</li>
            <li>Let <i>next</i> be <a href="#sec-get-o-p">Get</a>(<i>obj</i>, <i>indexName</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>next</i>) is not an element of <i>elementTypes</i>,
                throw a <b>TypeError</b> exception.</li>
            <li>Append <i>next</i> as the last element of <i>list</i>.</li>
            <li>Set <i>index</i> to <i>index</i> + 1.</li>
          </ol>
        </li>
        <li>Return <i>list</i>.</li>
      </ol>
    </section>

    <section id="sec-invoke">
      <h3 id="sec-7.3.18" title="7.3.18"> Invoke(O,P,
          [argumentsList])</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">Invoke</span> is used to call a
      method property of an object. The operation is called with arguments  <var>O</var>, <var>P</var> , and optionally
      <var>argumentsList</var> where <var>O</var> serves as both the lookup point for the property and the <b>this</b> value of
      the call, <var>P</var> is the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>, and <var>argumentsList</var> is the list of
      arguments values passed to the method. If <var>argumentsList</var> is not present, an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> is used as its value. This abstract operation performs the following
      steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>If <i>argumentsList</i> was not passed, let <i>argumentsList</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Let  <i>func</i> be <a href="#sec-getv">GetV</a>(<i>O</i>, <i>P</i>).</li>
        <li>Return <a href="#sec-call">Call</a>(<i>func</i>, <i>O</i>, <i>argumentsList</i>).</li>
      </ol>
    </section>

    <section id="sec-ordinaryhasinstance">
      <h3 id="sec-7.3.19" title="7.3.19">
          OrdinaryHasInstance (C, O)</h3><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">OrdinaryHasInstance</span>
      implements the default algorithm for determining if an object <var>O</var> inherits from the instance object inheritance
      path provided by constructor <var>C</var>. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li>If <a href="#sec-iscallable">IsCallable</a>(<i>C</i>) is <b>false</b>, return <b>false</b>.</li>
        <li>If <i>C</i> has a <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">[[BoundTargetFunction]]</a> <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, then
          <ol class="block">
            <li>Let <i>BC</i> be the value of <i>C&rsquo;s</i> <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">[[BoundTargetFunction]]</a> <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Return <a href="sec-ecmascript-language-expressions#sec-instanceofoperator">InstanceofOperator</a>(<i>O</i>,<i>BC</i>)  (<a href="sec-ecmascript-language-expressions#sec-instanceofoperator">see 12.9.4</a>).</li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <b>false</b>.</li>
        <li>Let <i>P</i> be <a href="#sec-get-o-p">Get</a>(<i>C</i>, <code>"prototype"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>P</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Repeat
          <ol class="block">
            <li>Let <i>O</i> be <i>O</i>.[[GetPrototypeOf]]().</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
            <li>If <i>O</i> is <code>null</code>, return <b>false</b>.</li>
            <li>If <a href="#sec-samevalue">SameValue</a>(<i>P</i>, <i>O</i>) is <b>true</b>, return <b>true</b>.</li>
          </ol>
        </li>
      </ol>
    </section>

    <section id="sec-speciesconstructor">
      <h3 id="sec-7.3.20" title="7.3.20">
          SpeciesConstructor ( O, defaultConstructor )</h3><p class="normalbefore">The abstract operation SpeciesConstructor is used to retrieve the constructor that should be used to
      create new objects that are derived from the argument object <var>O</var>. The <var>defaultConstructor</var> argument is the
      constructor to use if a constructor @@species property cannot be found starting from <var>O</var>. This abstract operation
      performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is
            Object.</li>
        <li>Let <i>C</i> be <a href="#sec-get-o-p">Get</a>(<i>O</i>, <code>"constructor"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>C</i>).</li>
        <li>If <i>C</i> is <b>undefined</b>, return <i>defaultConstructor</i>.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>C</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>S</i> be <a href="#sec-get-o-p">Get</a>(<i>C</i>, @@species).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
        <li>If <i>S</i> is either <b>undefined</b> or <b>null</b>, return <i>defaultConstructor</i>.</li>
        <li>If <a href="#sec-isconstructor">IsConstructor</a>(<i>S</i>) is <b>true</b>, return <i>S.</i></li>
        <li>Throw a <b>TypeError</b> exception.</li>
      </ol>
    </section>

    <section id="sec-enumerableownnames">
      <h3 id="sec-7.3.21" title="7.3.21">
          EnumerableOwnNames (O)</h3><p class="normalbefore">When the abstract operation EnumerableOwnNames is called with Object <var>O</var> the following
      steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>)
            is Object.</li>
        <li>Let <i>ownKeys</i> be <i>O</i>.[[OwnPropertyKeys]]().</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>ownKeys</i>).</li>
        <li>Let <i>names</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Repeat, for each element <i>key</i> of <i>ownKeys</i> in <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>
            order
          <ol class="block">
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>key</i>) is String, then
              <ol class="block">
                <li>Let <i>desc</i> be <i>O</i>.[[GetOwnProperty]](<i>key</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
                <li>If <i>desc</i> is not <b>undefined</b>, then
                  <ol class="block">
                    <li>If <i>desc.</i>[[Enumerable]] is <b>true</b>, append <i>key</i> to <i>names</i>.</li>
                  </ol>
                </li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Order the elements of <i>names</i> so they are in the same relative order as would be produced by the Iterator that
            would be returned if the [[Enumerate]] internal method was invoked on <i>O</i>.</li>
        <li>Return <i>names</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> The order of elements in the returned list is the same as the enumeration order that is
        used by a for-in statement.</p>
      </div>
    </section>

    <section id="sec-getfunctionrealm">
      <h3 id="sec-7.3.22" title="7.3.22">
          GetFunctionRealm ( obj )</h3><p class="normalbefore">The abstract operation GetFunctionRealm with argument <var>obj</var> performs the following
      steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>obj</i> is a callable object.</li>
        <li>If <i>obj</i> has a [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, then
          <ol class="block">
            <li>Return <i>obj</i>&rsquo;s [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                slot</a>.</li>
          </ol>
        </li>
        <li>If <i>obj</i> is a <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">Bound Function</a> exotic object, then
          <ol class="block">
            <li>Let <i>target</i> be <i>obj</i>&rsquo;s <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">[[BoundTargetFunction]]</a>
                <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Return GetFunctionRealm(<i>target</i>).</li>
          </ol>
        </li>
        <li>If <i>obj</i> is a Proxy exotic object, then
          <ol class="block">
            <li>If the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>
                of <i>obj</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
            <li>Let <i>proxyTarget</i> be the value of <i>obj</i>&rsquo;s [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Return GetFunctionRealm(<i>proxyTarget</i>).</li>
          </ol>
        </li>
        <li>Return <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> Step 5 will only be reached if <var>target</var> is a non-standard exotic function object
        that does not have a [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
      </div>
    </section>
  </section>

  <section id="sec-operations-on-iterator-objects">
    <div class="front">
      <h2 id="sec-7.4" title="7.4"> Operations on Iterator Objects</h2><p>See Common Iteration Interfaces (<a href="sec-control-abstraction-objects#sec-iteration">25.1</a>).</p>
    </div>

    <section id="sec-getiterator">
      <h3 id="sec-7.4.1" title="7.4.1"> GetIterator
          ( obj, method )</h3><p class="normalbefore">The abstract operation GetIterator with argument <span style="font-family: Times New       Roman"><i>obj</i> and</span> optional argument <var>method</var> performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>obj</i>).</li>
        <li>If <i>method</i> was not passed, then
          <ol class="block">
            <li>Let <i>method</i> be <a href="#sec-getmethod">GetMethod</a>(<i>obj</i>, @@iterator).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>method</i>).</li>
          </ol>
        </li>
        <li>Let <i>iterator</i> be <a href="#sec-call">Call</a>(<i>method</i>,<i>obj</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>)<i>.</i></li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>iterator</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Return <i>iterator</i>.</li>
      </ol>
    </section>

    <section id="sec-iteratornext">
      <h3 id="sec-7.4.2" title="7.4.2">
          IteratorNext ( iterator, value )</h3><p class="normalbefore">The abstract operation IteratorNext with argument <var>iterator</var> and optional argument
      <var>value</var> performs the following steps:</p>

      <ol class="proc">
        <li>If <i>value</i> was not passed, then
          <ol class="block">
            <li>Let <i>result</i> be <a href="#sec-invoke">Invoke</a>(<i>iterator</i>, <code>"next"</code>, &laquo;&zwj;
                &raquo;).</li>
          </ol>
        </li>
        <li>Else,
          <ol class="block">
            <li>Let <i>result</i> be <a href="#sec-invoke">Invoke</a>(<i>iterator</i>, <code>"next"</code>,
                &laquo;&zwj;<i>value</i>&raquo;).</li>
          </ol>
        </li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>result</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Return <i>result</i>.</li>
      </ol>
    </section>

    <section id="sec-iteratorcomplete">
      <h3 id="sec-7.4.3" title="7.4.3">
          IteratorComplete ( iterResult )</h3><p class="normalbefore">The abstract operation IteratorComplete with argument <var>iterResult</var> performs the following
      steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>iterResult</i>) is Object.</li>
        <li>Return <a href="#sec-toboolean">ToBoolean</a>(<a href="#sec-get-o-p">Get</a>(<i>iterResult</i>,
            <code>"done"</code>)).</li>
      </ol>
    </section>

    <section id="sec-iteratorvalue">
      <h3 id="sec-7.4.4" title="7.4.4">
          IteratorValue ( iterResult )</h3><p class="normalbefore">The abstract operation IteratorValue with argument <var>iterResult</var> performs the following
      steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>iterResult</i>) is Object.</li>
        <li>Return <a href="#sec-get-o-p">Get</a>(<i>iterResult</i>, <code>"value"</code>).</li>
      </ol>
    </section>

    <section id="sec-iteratorstep">
      <h3 id="sec-7.4.5" title="7.4.5">
          IteratorStep ( iterator )</h3><p class="normalbefore">The abstract operation IteratorStep with argument <var>iterator</var> requests the next value from
      <var>iterator</var> and returns either <span class="value">false</span> indicating that the iterator has reached its end or
      the IteratorResult object if a next value is available. IteratorStep performs the following steps:</p>

      <ol class="proc">
        <li>Let <i>result</i> be <a href="#sec-iteratornext">IteratorNext</a>(<i>iterator</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
        <li>Let <i>done</i> be <a href="#sec-iteratorcomplete">IteratorComplete</a>(<i>result</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>done</i>).</li>
        <li>If <i>done</i> is <b>true</b>, return <b>false</b>.</li>
        <li>Return <i>result</i>.</li>
      </ol>
    </section>

    <section id="sec-iteratorclose">
      <h3 id="sec-7.4.6" title="7.4.6">
          IteratorClose( iterator, completion )</h3><p class="normalbefore">The abstract operation IteratorClose with arguments <var>iterator</var> and <var>completion</var> is
      used to notify an iterator that it should perform any actions it would normally perform when it has reached its completed
      state:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>iterator</i>) is Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>completion</i> is a <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a>.</li>
        <li>Let <i>return</i> be <a href="#sec-getmethod">GetMethod</a>(<i>iterator</i>, <code>"return"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>return</i>).</li>
        <li>If <i>return</i> is <b>undefined</b>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>completion</i>).</li>
        <li>Let <i>innerResult</i> be <a href="#sec-call">Call</a>(<i>return</i>, <i>iterator</i>, &laquo;&zwj; &raquo;).</li>
        <li>If <i>completion</i>.[[type]] is <span style="font-family: sans-serif">throw</span>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>completion</i>).</li>
        <li>If <i>innerResult</i>.[[type]] is <span style="font-family: sans-serif">throw</span>, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>innerResult</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>innerResult</i>.[[value]]) is not Object<i>,</i> throw
            a <b>TypeError</b> exception.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>completion</i>).</li>
      </ol>
    </section>

    <section id="sec-createiterresultobject">
      <h3 id="sec-7.4.7" title="7.4.7">
          CreateIterResultObject ( value, done )</h3><p class="normalbefore">The abstract operation CreateIterResultObject with arguments <var>value</var> and <var>done</var>
      creates an object that supports the IteratorResult interface by performing the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>done</i>)
            is Boolean.</li>
        <li>Let <i>obj</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<span style="font-family:             sans-serif">%ObjectPrototype%</span>).</li>
        <li>Perform <a href="#sec-createdataproperty">CreateDataProperty</a>(<i>obj</i>, <code>"value"</code>, <i>value</i>).</li>
        <li>Perform <a href="#sec-createdataproperty">CreateDataProperty</a>(<i>obj</i>, <code>"done"</code>, <i>done</i>).</li>
        <li>Return <i>obj</i>.</li>
      </ol>
    </section>

    <section id="sec-createlistiterator">
      <div class="front">
        <h3 id="sec-7.4.8" title="7.4.8">
            CreateListIterator ( list )</h3><p class="normalbefore">The abstract operation CreateListIterator with argument <var>list</var>  creates an Iterator (<a href="sec-control-abstraction-objects#sec-iterator-interface">25.1.1.2</a>) object whose next method returns the successive elements of <var>list</var>.
        It performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>iterator</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(%IteratorPrototype%, &laquo;[[IteratorNext]],
              [[IteratedList]], [[ListIteratorNextIndex]]&raquo;).</li>
          <li>Set <i>iterator&rsquo;s</i> [[IteratedList]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>list</i>.</li>
          <li>Set <i>iterator&rsquo;s</i> [[ListIteratorNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to 0.</li>
          <li>Let <i>next</i> be a new built-in function object as defined in ListIterator <code>next</code> (<a href="#sec-listiterator-next">7.4.8.1</a>).</li>
          <li>Set <i>iterator&rsquo;s</i> [[IteratorNext]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>next</i>.</li>
          <li>Perform <a href="#sec-createmethodproperty">CreateMethodProperty</a>(<i>iterator</i>, <code>"next"</code>,
              <i>next</i>).</li>
          <li>Return <i>iterator</i>.</li>
        </ol>
      </div>

      <section id="sec-listiterator-next">
        <h4 id="sec-7.4.8.1" title="7.4.8.1">
            ListIterator next( )</h4><p class="normalbefore">The ListIterator <code>next</code> method is a standard built-in function object (<a href="sec-ecmascript-standard-built-in-objects">clause 17</a>) that performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>Let <i>f</i> be the active function object.</li>
          <li>If <i>O</i> does not have a [[IteratorNext]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>next</i> be the value of the [[IteratorNext]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
          <li>If <a href="#sec-samevalue">SameValue</a>(<i>f</i>, <i>next</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>O</i> does not have a [[IteratedList]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>list</i> be the value of the [[IteratedList]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
          <li>Let <i>index</i> be the value of the [[ListIteratorNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
          <li>Let <i>len</i> be the number of elements of <i>list</i>.</li>
          <li>If <i>index</i> &ge; <i>len</i>, then
            <ol class="block">
              <li>Return <a href="#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>true</b>).</li>
            </ol>
          </li>
          <li>Set the value of the [[ListIteratorNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> of <i>O</i> to <i>index</i>+1.</li>
          <li>Return <a href="#sec-createiterresultobject">CreateIterResultObject</a>(<i>list</i>[<i>index</i>],
              <b>false</b>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> A ListIterator <code>next</code> method will throw an exception if applied to any object
          other than the one with which it was originally associated.</p>
        </div>
      </section>
    </section>
  </section>
</section>

