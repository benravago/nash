<section id="sec-numbers-and-dates">
  <div class="front">
    <h1 id="sec-20" title="20"> Numbers and
        Dates</h1></div>

  <section id="sec-number-objects">
    <div class="front">
      <h2 id="sec-20.1" title="20.1"> Number
          Objects</h2></div>

    <section id="sec-number-constructor">
      <div class="front">
        <h3 id="sec-20.1.1" title="20.1.1">
            The Number Constructor</h3><p>The Number constructor is the %Number% intrinsic object and the initial value of the <code>Number</code> property of
        the global object. When called as a constructor, it creates and initializes a new Number object. When <code>Number</code>
        is called as a function rather than as a constructor, it performs a type conversion.</p>

        <p>The <code>Number</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>Number</code> behaviour must include a <code>super</code> call to the <code>Number</code> constructor to create and
        initialize the subclass instance with a [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
        slot</a>.</p>
      </div>

      <section id="sec-number-constructor-number-value">
        <h4 id="sec-20.1.1.1" title="20.1.1.1"> Number ( [ value ] )</h4><p class="normalbefore">When <code>Number</code> is called with argument <var>number</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>If no arguments were passed to this function invocation, let <i>n</i> be +0.</li>
          <li>Else, let <i>n</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>n</i>).</li>
          <li>If NewTarget is <b>undefined</b><i>,</i> return <i>n</i>.</li>
          <li>Let <i>O</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
              <code>"%NumberPrototype%"</code>, &laquo;[[NumberData]]&raquo; ).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Set the value of <i>O&rsquo;s</i> [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>n</i>.</li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-number-constructor">
      <div class="front">
        <h3 id="sec-20.1.2" title="20.1.2"> Properties of the Number Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Number constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is <b>1</b>), the Number constructor has the following
        properties:</p>
      </div>

      <section id="sec-number.epsilon">
        <h4 id="sec-20.1.2.1" title="20.1.2.1">
            Number.EPSILON</h4><p>The value of Number.EPSILON is the difference between 1 and the smallest value greater than 1 that is representable as
        a Number value, which is approximately 2.2204460492503130808472633361816 x 10&zwj;<sup>&minus;&zwj;16</sup>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-number.isfinite">
        <h4 id="sec-20.1.2.2" title="20.1.2.2">
            Number.isFinite ( number )</h4><p class="normalbefore">When the <code>Number.isFinite</code> is called with one argument <var>number</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>number</i>) is not Number, return <b>false</b>.</li>
          <li>If <i>number</i> is <b>NaN</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return <b>false</b>.</li>
          <li>Otherwise, return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-number.isinteger">
        <h4 id="sec-20.1.2.3" title="20.1.2.3"> Number.isInteger ( number )</h4><p class="normalbefore">When the <code>Number.isInteger</code> is called with one argument <var>number</var>, the
        following steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>number</i>) is not Number, return <b>false</b>.</li>
          <li>If <i>number</i> is <b>NaN</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return <b>false</b>.</li>
          <li>Let <i>integer</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>number</i>).</li>
          <li>If <i>integer</i> is not equal to <i>number</i>, return <b>false</b>.</li>
          <li>Otherwise, return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-number.isnan">
        <h4 id="sec-20.1.2.4" title="20.1.2.4">
            Number.isNaN ( number )</h4><p class="normalbefore">When the <code>Number.isNaN</code> is called with one argument <var>number</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>number</i>) is not Number, return <b>false</b>.</li>
          <li>If <i>number</i> is <b>NaN</b>, return <b>true</b>.</li>
          <li>Otherwise, return <b>false</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> This function differs from the global isNaN function (<a href="sec-global-object#sec-isnan-number">18.2.3</a>) is that it does not convert its argument to a Number before determining whether it
          is NaN.</p>
        </div>
      </section>

      <section id="sec-number.issafeinteger">
        <h4 id="sec-20.1.2.5" title="20.1.2.5"> Number.isSafeInteger ( number )</h4><p class="normalbefore">When the <code>Number.isSafeInteger</code> is called with one argument <var>number</var>, the
        following steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>number</i>) is not Number, return <b>false</b>.</li>
          <li>If <i>number</i> is <b>NaN</b>, <b>+&infin;</b>, or <b>&minus;&infin;</b>, return <b>false</b>.</li>
          <li>Let <i>integer</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>number</i>).</li>
          <li>If <i>integer</i> is not equal to <i>number</i>, return <b>false</b>.</li>
          <li>If <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>integer</i>) &le; 2<sup>53</sup>&minus;1, return
              <b>true</b>.</li>
          <li>Otherwise, return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-number.max_safe_integer">
        <h4 id="sec-20.1.2.6" title="20.1.2.6"> Number.MAX_SAFE_INTEGER</h4><div class="note">
          <p><span class="nh">NOTE</span>   The value of <code>Number.MAX_SAFE_INTEGER</code> is the largest integer n such that n
          and n + 1 are both exactly representable as a Number value.</p>
        </div>

        <p>The value of Number.MAX_SAFE_INTEGER is 9007199254740991 (2<sup>53</sup>&minus;1).</p>

        <p><br />This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-number.max_value">
        <h4 id="sec-20.1.2.7" title="20.1.2.7"> Number.MAX_VALUE</h4><p>The value of <code>Number.MAX_VALUE</code> is the largest positive finite value of the Number type, which is
        approximately <span style="font-family: Times New Roman">1.7976931348623157&nbsp;&times;&nbsp;10<sup>308</sup></span>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-number.min_safe_integer">
        <h4 id="sec-20.1.2.8" title="20.1.2.8"> Number.MIN_SAFE_INTEGER</h4><div class="note">
          <p><span class="nh">NOTE</span>   The value of <code>Number.MIN_SAFE_INTEGER</code> is the smallest integer n such that
          n and n &minus; 1 are both exactly representable as a Number value.</p>
        </div>

        <p>The value of Number.MIN_SAFE_INTEGER is &minus;9007199254740991 (&minus;(2<sup>53</sup>&minus;1)).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-number.min_value">
        <h4 id="sec-20.1.2.9" title="20.1.2.9"> Number.MIN_VALUE</h4><p>The value of <code>Number.MIN_VALUE</code> is the smallest positive value of the Number type, which is approximately
        <span style="font-family: Times New Roman">5&nbsp;&times;&nbsp;10<sup>&minus;324</sup></span>.</p>

        <p>In the IEEE 754-2008 double precision binary representation, the smallest possible value is a denormalized number. If
        an implementation does not support denormalized values, the value of <code>Number.MIN_VALUE</code> must be the smallest
        non-zero positive value that can actually be represented by the implementation.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-number.nan">
        <h4 id="sec-20.1.2.10" title="20.1.2.10">
            Number.NaN</h4><p>The value of <code>Number.NaN</code> is <b>NaN</b>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-number.negative_infinity">
        <h4 id="sec-20.1.2.11" title="20.1.2.11"> Number.NEGATIVE_INFINITY</h4><p>The value of Number.NEGATIVE_INFINITY is &minus;&infin;.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-number.parsefloat">
        <h4 id="sec-20.1.2.12" title="20.1.2.12"> Number.parseFloat ( string )</h4><p>The value of the <code>Number.parseFloat</code> data property is the same built-in function object that is the value of
        the <code>parseFloat</code> property of the global object defined in <a href="sec-global-object#sec-parsefloat-string">18.2.4</a>.</p>
      </section>

      <section id="sec-number.parseint">
        <h4 id="sec-20.1.2.13" title="20.1.2.13"> Number.parseInt ( string, radix )</h4><p>The value of the <code>Number.parseInt</code> data property is the same built-in function object that is the value of
        the <code>parseInt</code> property of the global object defined in <a href="sec-global-object#sec-parseint-string-radix">18.2.5</a>.</p>
      </section>

      <section id="sec-number.positive_infinity">
        <h4 id="sec-20.1.2.14" title="20.1.2.14"> Number.POSITIVE_INFINITY</h4><p>The value of Number.POSITIVE_INFINITY is +&infin;.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-number.prototype">
        <h4 id="sec-20.1.2.15" title="20.1.2.15"> Number.prototype</h4><p>The initial value of <code>Number.prototype</code> is the intrinsic object %NumberPrototype% (<a href="#sec-properties-of-the-number-prototype-object">20.1.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-number-prototype-object">
      <div class="front">
        <h3 id="sec-20.1.3" title="20.1.3"> Properties of the Number Prototype Object</h3><p>The Number prototype object is the intrinsic object %NumberPrototype%. The Number prototype object is an ordinary
        object. It is not a Number instance and does not have a [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Number prototype object is the intrinsic object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>).</p>

        <p>Unless explicitly stated otherwise, the methods of the Number prototype object defined below are not generic and the
        <b>this</b> value passed to them must be either a Number value or an object that has a [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> that has been initialized to a Number value.</p>

        <p class="normalbefore">The abstract operation <span style="font-family: Times New         Roman">thisNumberValue(<i>value</i>)</span> performs the following steps:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Number, return <i>value</i>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Object and <i>value</i> has a
              [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, then
            <ol class="block">
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>value</i>&rsquo;s [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is a Number value.</li>
              <li>Return the value of <i>value&rsquo;s</i> [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            </ol>
          </li>
          <li>Throw a <b>TypeError</b> exception.</li>
        </ol>

        <p>The phrase &ldquo;this Number value&rdquo; within the specification of a method refers to the result returned  by
        calling the abstract operation <span style="font-family: Times New Roman">thisNumberValue</span> with the <b>this</b>
        value of the method invocation passed as the argument.</p>
      </div>

      <section id="sec-number.prototype.constructor">
        <h4 id="sec-20.1.3.1" title="20.1.3.1"> Number.prototype.constructor</h4><p>The initial value of <code>Number.prototype.constructor</code> is the intrinsic object %Number%.</p>
      </section>

      <section id="sec-number.prototype.toexponential">
        <h4 id="sec-20.1.3.2" title="20.1.3.2"> Number.prototype.toExponential ( fractionDigits )</h4><p class="normalbefore">Return a String containing this Number value represented in decimal exponential notation with one
        digit before the significand's decimal point and <var>fractionDigits</var> digits after the significand's decimal point.
        If <var>fractionDigits</var> is <b>undefined</b>, include as many significand digits as necessary to uniquely specify the
        Number (just like in <a href="sec-abstract-operations#sec-tostring">ToString</a> except that in this case the Number is always output in
        exponential notation). Specifically, perform the following steps:</p>

        <ol class="proc">
          <li>Let <i>x</i> be thisNumberValue(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>x</i>).</li>
          <li>Let <i>f</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>fractionDigits</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>f</i> is 0, when <i>fractionDigits</i> is <b>undefined</b>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>f</i>).</li>
          <li>If <i>x</i> is <b>NaN</b>, return the String <code>"NaN"</code>.</li>
          <li>Let <i>s</i> be the empty String.</li>
          <li>If <i>x</i> <i>&lt;</i> 0, then
            <ol class="block">
              <li>Let <i>s</i> be <code>"-"</code>.</li>
              <li>Let <i>x</i> = &ndash;<i>x</i>.</li>
            </ol>
          </li>
          <li>If <i>x</i> = +&infin;, then
            <ol class="block">
              <li>Return the concatenation of the Strings <i>s</i> and <code>"Infinity"</code>.</li>
            </ol>
          </li>
          <li>If <i>f</i> &lt; 0 or <i>f</i> &gt; 20, throw a <b>RangeError</b> exception. However, an implementation is permitted
              to extend the behaviour of <code>toExponential</code> for values of <i>f</i> less than 0 or greater than 20. In this
              case <code>toExponential</code> would not necessarily throw <b>RangeError</b> for such values.</li>
          <li>If <i>x</i> = 0, then
            <ol class="block">
              <li>Let <i>m</i> be the String consisting of <i>f</i>+1 occurrences of the code unit 0x0030.</li>
              <li>Let <i>e</i> = 0.</li>
            </ol>
          </li>
          <li>Else <i>x</i> &ne; 0,
            <ol class="block">
              <li>If <i>fractionDigits</i> is not <b>undefined</b>, then
                <ol class="block">
                  <li>Let <i>e</i> and <i>n</i> be integers such that 10<sup><i>f</i></sup> &le; <i>n</i> &lt;
                      10<sup><i>f</i>+1</sup> and for which the exact mathematical value of <i>n</i> &times;
                      10<sup><i>e</i>&ndash;<i>f</i></sup> &ndash; <i>x</i> is as close to zero as possible. If there are two such
                      sets of <i>e</i> and <i>n</i>, pick the <i>e</i> and <i>n</i> for which <i>n</i> &times;
                      10<sup><i>e</i>&ndash;<i>f</i></sup> is larger.</li>
                </ol>
              </li>
              <li>Else <i>fractionDigits</i> is <b>undefined</b>,
                <ol class="block">
                  <li>Let <i>e</i>, <i>n</i>, and <i>f</i> be integers such that <i>f</i> &ge; 0, 10<sup><i>f</i></sup> &le;
                      <i>n</i> &lt; 10<sup><i>f</i>+1</sup>, the Number value for n &times; 10<sup><i>e</i>&ndash;<i>f</i></sup>
                      is <i>x</i>, and <i>f</i> is as small as possible. Note that the decimal representation of <i>n</i> has
                      <i>f</i>+1 digits, <i>n</i> is not divisible by 10, and the least significant digit of <i>n</i> is not
                      necessarily uniquely determined by these criteria.</li>
                </ol>
              </li>
              <li>Let <i>m</i> be the String consisting of the digits of the decimal representation of <i>n</i> (in order, with no
                  leading zeroes).</li>
            </ol>
          </li>
          <li>If <i>f</i> &ne; 0, then
            <ol class="block">
              <li>Let <i>a</i> be the first element of <i>m</i>, and let <i>b</i> be the remaining <i>f</i> elements of
                  <i>m</i>.</li>
              <li>Let <i>m</i> be the concatenation of the three Strings <i>a</i>, <code>"."</code>, and <i>b</i>.</li>
            </ol>
          </li>
          <li>If <i>e</i> = 0, then
            <ol class="block">
              <li>Let <i>c</i> = <code>"+".</code></li>
              <li>Let <i>d</i> = <code>"0".</code></li>
            </ol>
          </li>
          <li>Else
            <ol class="block">
              <li>If <i>e</i> &gt; 0, let <i>c</i> = <code>"+".</code></li>
              <li>Else <i>e</i> &le; 0,
                <ol class="block">
                  <li>Let <i>c</i> = <code>"-"</code>.</li>
                  <li>Let <i>e</i> = &ndash;<i>e</i>.</li>
                </ol>
              </li>
              <li>Let <i>d</i> be the String consisting of the digits of the decimal representation of <i>e</i> (in order, with no
                  leading zeroes).</li>
            </ol>
          </li>
          <li>Let <i>m</i> be the concatenation of the four Strings <i>m</i>, <code>"e"</code>, <i>c</i>, and <i>d</i>.</li>
          <li>Return the concatenation of the Strings <i>s</i> and <i>m</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>toExponential</code> method is <b>1</b>.</p>

        <p>If the <code>toExponential</code> method is called with more than one argument, then the behaviour is undefined (see <a href="sec-ecmascript-standard-built-in-objects">clause 17</a>).</p>

        <div class="note">
          <p><span class="nh">NOTE</span> For implementations that provide more accurate conversions than required by the rules
          above, it is recommended that the following alternative version of step 12.b.i be used as a guideline:</p>

          <p class="special3">i.&#x9;Let <i>e</i>, <i>n</i>, and <i>f</i> be integers such that <i>f</i> &ge; 0,
          10<sup><i>f</i></sup> &le; n &lt; 10<sup><i>f</i>+1</sup>, the Number value for n &times;
          10<sup><i>e</i>&ndash;<i>f</i></sup> is x, and <i>f</i> is as small as possible. If there are multiple possibilities for
          <i>n</i>, choose the value of <i>n</i> for which <i>n</i> &times; 10<sup><i>e</i>&ndash;<i>f</i></sup> is closest in
          value to <i>x</i>. If there are two such possible values of <i>n</i>, choose the one that is even.</p>
        </div>
      </section>

      <section id="sec-number.prototype.tofixed">
        <h4 id="sec-20.1.3.3" title="20.1.3.3"> Number.prototype.toFixed ( fractionDigits )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <code>toFixed</code> returns a String containing this Number value represented in
          decimal fixed-point notation with <var>fractionDigits</var> digits after the decimal point. If <var>fractionDigits</var>
          is <b>undefined</b>, 0 is assumed.</p>
        </div>

        <p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>x</i> be thisNumberValue(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>x</i>).</li>
          <li>Let <i>f</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>fractionDigits</i>). (If <i>fractionDigits</i> is
              <b>undefined</b>, this step produces the value <code>0</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>f</i>).</li>
          <li>If <i>f</i> &lt; 0 or <i>f</i> &gt; 20, throw a <b>RangeError</b> exception. However, an implementation is permitted
              to extend the behaviour of <code>toFixed</code> for values of <i>f</i> less than 0 or greater than 20. In this case
              <code>toFixed</code> would not necessarily throw <b>RangeError</b> for such values.</li>
          <li>If <i>x</i> is <b>NaN</b>, return the String <code>"NaN"</code>.</li>
          <li>Let <i>s</i> be the empty String.</li>
          <li>If <i>x</i> &lt; 0, then
            <ol class="block">
              <li>Let <i>s</i> be "<code>-</code>".</li>
              <li>Let <i>x</i> = &ndash;<i>x</i>.</li>
            </ol>
          </li>
          <li>If <i>x</i> &ge; 10<sup>21</sup>, then
            <ol class="block">
              <li>Let <i>m</i> = <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>x</i>).</li>
            </ol>
          </li>
          <li>Else <i>x</i> &lt; 10<sup>21</sup>,
            <ol class="block">
              <li>Let <i>n</i> be an integer for which the exact mathematical value of <i>n</i> &divide; 10<sup>f</sup> &ndash;
                  <i>x</i> is as close to zero as possible. If there are two such <i>n</i>, pick the larger <i>n</i>.</li>
              <li>If <i>n</i> = 0, let <i>m</i> be the String <code>"0"</code>. Otherwise, let <i>m</i> be the String consisting
                  of the digits of the decimal representation of <i>n</i> (in order, with no leading zeroes).</li>
              <li>If <i>f</i> &ne; 0, then
                <ol class="block">
                  <li>Let <i>k</i> be the number of elements in <i>m</i>.</li>
                  <li>If <i>k</i> &le; <i>f</i>, then
                    <ol class="block">
                      <li>Let <i>z</i> be the String consisting of <i>f</i>+1&ndash;<i>k</i> occurrences of the code unit
                          0x0030.</li>
                      <li>Let <i>m</i> be the concatenation of Strings <i>z</i> and <i>m</i>.</li>
                      <li>Let <i>k</i> = <i>f</i> + 1.</li>
                    </ol>
                  </li>
                  <li>Let <i>a</i> be the first <i>k</i>&ndash;<i>f</i> elements of <i>m</i>, and let <i>b</i> be the remaining
                      <i>f</i> elements of <i>m</i>.</li>
                  <li>Let <i>m</i> be the concatenation of the three Strings <i>a</i>, <code>"."</code>, and <i>b</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return the concatenation of the Strings <i>s</i> and <i>m</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>toFixed</code> method is <b>1</b>.</p>

        <p>If the <code>toFixed</code> method is called with more than one argument, then the behaviour is undefined (see <a href="sec-ecmascript-standard-built-in-objects">clause&nbsp;17</a>).</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The output of <code>toFixed</code> may be more precise than <code>toString</code> for
          some values because toString only prints enough significant digits to distinguish the number from adjacent number
          values. For example,</p>

          <p><code>(1000000000000000128).toString()</code> returns <code>"1000000000000000100"</code>,
          while<br /><code>(1000000000000000128).toFixed(0)</code> returns <code>"1000000000000000128"</code>.</p>
        </div>
      </section>

      <section id="sec-number.prototype.tolocalestring">
        <h4 id="sec-20.1.3.4" title="20.1.3.4"> Number.prototype.toLocaleString( [ reserved1 [ , reserved2 ] ])</h4><p>An ECMAScript implementation that includes the ECMA-402 Internationalization API must implement the
        <code>Number.prototype.toLocaleString</code> method as specified in the ECMA-402 specification. If an ECMAScript
        implementation does not include the ECMA-402 API the following specification of the <code>toLocaleString</code> method is
        used.</p>

        <p>Produces a String value that represents this Number value formatted according to the conventions of the host
        environment&rsquo;s current locale. This function is implementation-dependent, and it is permissible, but not encouraged,
        for it to return the same thing as <code>toString</code>.</p>

        <p>The meanings of the optional parameters to this method are defined in the ECMA-402 specification; implementations that
        do not include ECMA-402 support must not use those parameter positions for anything else.</p>

        <p>The <code>length</code> property of the <code>toLocaleString</code> method is <b>0</b>.</p>
      </section>

      <section id="sec-number.prototype.toprecision">
        <h4 id="sec-20.1.3.5" title="20.1.3.5"> Number.prototype.toPrecision ( precision )</h4><p class="normalbefore">Return a String containing this Number value represented either in decimal exponential notation
        with one digit before the significand's decimal point and <span style="font-family: Times New         Roman"><i>precision</i>&ndash;1</span> digits after the significand's decimal point or in decimal fixed notation with
        <var>precision</var> significant digits. If <var>precision</var> is <b>undefined</b>, call <a href="sec-abstract-operations#sec-tostring">ToString</a> (<a href="sec-abstract-operations#sec-tostring">7.1.12</a>) instead. Specifically, perform the following
        steps:</p>

        <ol class="proc">
          <li>Let <i>x</i> be thisNumberValue(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>x</i>).</li>
          <li>If <i>precision</i> is <b>undefined</b>, return <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>x</i>).</li>
          <li>Let <i>p</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>precision</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>p</i>).</li>
          <li>If <i>x</i> is <b>NaN</b>, return the String <code>"NaN"</code>.</li>
          <li>Let <i>s</i> be the empty String.</li>
          <li>If <i>x</i> &lt; 0, then
            <ol class="block">
              <li>Let <i>s</i> be code unit 0x002D (HYPHEN-MINUS).</li>
              <li>Let <i>x</i> = &ndash;<i>x</i>.</li>
            </ol>
          </li>
          <li>If <i>x</i> = +&infin;, then
            <ol class="block">
              <li>Return the String that is the concatenation of <i>s</i> and <code>"Infinity"</code>.</li>
            </ol>
          </li>
          <li>If <i>p</i> &lt; 1 or <i>p</i> &gt; 21, throw a <b>RangeError</b> exception. However, an implementation is permitted
              to extend the behaviour of <code>toPrecision</code> for values of <i>p</i> less than 1 or greater than 21. In this
              case <code>toPrecision</code> would not necessarily throw <b>RangeError</b> for such values.</li>
          <li>If <i>x</i> = 0, then
            <ol class="block">
              <li>Let <i>m</i> be the String consisting of <i>p</i> occurrences of the code unit 0x0030 (DIGIT ZERO).</li>
              <li>Let <i>e</i> = 0.</li>
            </ol>
          </li>
          <li>Else <i>x</i> &ne; 0,
            <ol class="block">
              <li>Let <i>e</i> and <i>n</i> be integers such that 10<sup><i>p</i>&ndash;1</sup> &le; <i>n</i> &lt;
                  10<sup><i>p</i></sup> and for which the exact mathematical value of <i>n</i> &times;
                  10<sup><i>e</i>&ndash;<i>p</i>+1</sup> &ndash; <i>x</i> is as close to zero as possible. If there are two such
                  sets of <i>e</i> and <i>n</i>, pick the <i>e</i> and <i>n</i> for which <i>n</i> &times;
                  10<sup><i>e</i>&ndash;<i>p</i>+1</sup> is larger.</li>
              <li>Let <i>m</i> be the String consisting of the digits of the decimal representation of <i>n</i> (in order, with no
                  leading zeroes).</li>
              <li>If <i>e</i> &lt; &ndash;6 or <i>e</i> &ge; <i>p</i>, then
                <ol class="block">
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>e</i> &ne; 0</li>
                  <li>Let <i>a</i> be the first element of <i>m</i>, and let <i>b</i> be the remaining <i>p</i>&ndash;1 elements
                      of <i>m</i>.</li>
                  <li>Let <i>m</i> be the concatenation of <i>a</i>, code unit 0x002E (FULL STOP), and <i>b</i>.</li>
                  <li>If <i>e</i> &gt; 0,  then
                    <ol class="block">
                      <li>Let <i>c</i> be code unit 0x002B (PLUS SIGN).</li>
                    </ol>
                  </li>
                  <li>Else <i>e</i> &lt; 0,
                    <ol class="block">
                      <li>Let <i>c</i> be code unit 0x002D (HYPHEN-MINUS).</li>
                      <li>Let <i>e</i> = &ndash;<i>e</i>.</li>
                    </ol>
                  </li>
                  <li>Let <i>d</i> be the String consisting of the digits of the decimal representation of <i>e</i> (in order,
                      with no leading zeroes).</li>
                  <li>Return the concatenation of <i>s</i>, <i>m</i>, code unit 0x0065 (LATIN SMALL LETTER E), <i>c</i>, and
                      <i>d</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>e</i> = <i>p</i>&ndash;1, return the concatenation of the Strings <i>s</i> and <i>m</i>.</li>
          <li>If <i>e</i> &ge; 0, then
            <ol class="block">
              <li>Let <i>m</i> be the concatenation of the first <i>e</i>+1 elements of <i>m</i>, the code unit 0x002E (FULL
                  STOP), and the remaining <i>p</i>&ndash; (<i>e</i>+1) elements of <i>m</i>.</li>
            </ol>
          </li>
          <li>Else <i>e</i> &lt; 0,
            <ol class="block">
              <li>Let <i>m</i> be the String formed by the concatenation of code unit 0x0030 (DIGIT ZERO)<b>,</b> code unit 0x002E
                  (FULL STOP), &ndash;(<i>e</i>+1) occurrences of code unit 0x0030 (DIGIT ZERO), and the String <i>m</i>.</li>
            </ol>
          </li>
          <li>Return the String that is the concatenation of <i>s</i> and <i>m</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>toPrecision</code> method is <b>1</b>.</p>

        <p>If the <code>toPrecision</code> method is called with more than one argument, then the behaviour is undefined (see <a href="sec-ecmascript-standard-built-in-objects">clause&nbsp;17</a>).</p>
      </section>

      <section id="sec-number.prototype.tostring">
        <h4 id="sec-20.1.3.6" title="20.1.3.6"> Number.prototype.toString ( [ radix ] )</h4><div class="note">
          <p><span class="nh">NOTE</span> The optional <var>radix</var> should be an integer value in the inclusive range <span style="font-family: Times New Roman">2</span> to <span style="font-family: Times New Roman">36</span>. If
          <var>radix</var> not present or is <b>undefined</b> the Number <span style="font-family: Times New Roman">10</span> is
          used as the value of <var>radix</var>.</p>
        </div>

        <p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>x</i> be thisNumberValue(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>x</i>).</li>
          <li>If <i>radix</i> is not present, let <i>radixNumber</i> be 10.</li>
          <li>Else if <i>radix</i> is <b>undefined</b>, let <i>radixNumber</i> be 10.</li>
          <li>Else let <i>radixNumber</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>radix</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>radixNumber</i>).</li>
          <li>If <i>radixNumber</i> &lt; 2 or <i>radixNumber</i> &gt; 36, throw a <b>RangeError</b> exception.</li>
          <li>If <i>radixNumber</i> = 10, return <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>x</i>).</li>
          <li>Return the String representation of this Number value using the radix specified by <i>radixNumber</i>. Letters
              <code>a</code>-<code>z</code> are used for digits with values 10 through 35. The precise algorithm is
              implementation-dependent, however the algorithm should be a generalization of that specified in <a href="sec-abstract-operations#sec-tostring-applied-to-the-number-type">7.1.12.1</a>.</li>
        </ol>

        <p>The <code>toString</code> function is not generic; it throws a <b>TypeError</b> exception if its <b>this</b> value is
        not a Number or a Number object. Therefore, it cannot be transferred to other kinds of objects for use as a method.</p>
      </section>

      <section id="sec-number.prototype.valueof">
        <h4 id="sec-20.1.3.7" title="20.1.3.7"> Number.prototype.valueOf ( )</h4><ol class="proc">
          <li>Let <i>x</i> be thisNumberValue(<b>this</b> value).</li>
          <li>Return  <i>x</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-number-instances">
      <h3 id="sec-20.1.4" title="20.1.4"> Properties of Number Instances</h3><p>Number instances are ordinary objects that inherit properties from the Number prototype object. Number instances also
      have a [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>. The [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is the Number value represented by this Number
      object.</p>
    </section>
  </section>

  <section id="sec-math-object">
    <div class="front">
      <h2 id="sec-20.2" title="20.2"> The Math
          Object</h2><p>The Math object is the %Math% intrinsic object and the initial value of the <code>Math</code> property of the global
      object. The Math object is a single ordinary object.</p>

      <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Math
      object is the intrinsic object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>).</p>

      <p>The Math object is not a function object. It does not have a [[Construct]] internal method; it is not possible to use the
      Math object as a constructor with the <code>new</code> operator. The Math object also does not have a [[Call]] internal
      method; it is not possible to invoke the Math object as a function.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> In this specification, the phrase &ldquo;the Number value for <var>x</var>&rdquo; has a
        technical meaning defined in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-number-type">6.1.6</a>.</p>
      </div>
    </div>

    <section id="sec-value-properties-of-the-math-object">
      <div class="front">
        <h3 id="sec-20.2.1" title="20.2.1"> Value Properties of the Math Object</h3></div>

      <section id="sec-math.e">
        <h4 id="sec-20.2.1.1" title="20.2.1.1">
            Math.E</h4><p>The Number value for <var>e</var>, the base of the natural logarithms, which is approximately
        2.7182818284590452354.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-math.ln10">
        <h4 id="sec-20.2.1.2" title="20.2.1.2">
            Math.LN10</h4><p>The Number value for the natural logarithm of 10, which is approximately 2.302585092994046.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-math.ln2">
        <h4 id="sec-20.2.1.3" title="20.2.1.3">
            Math.LN2</h4><p>The Number value for the natural logarithm of 2, which is approximately 0.6931471805599453.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-math.log10e">
        <h4 id="sec-20.2.1.4" title="20.2.1.4">
            Math.LOG10E</h4><p>The Number value for the base-<span style="font-family: Times New Roman">10</span> logarithm of <var>e</var>, the base
        of the natural logarithms; this value is approximately <span style="font-family: Times New         Roman">0.4342944819032518</span>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The value of <code>Math.LOG10E</code> is approximately the reciprocal of the value of
          <code>Math.LN10</code>.</p>
        </div>
      </section>

      <section id="sec-math.log2e">
        <h4 id="sec-20.2.1.5" title="20.2.1.5">
            Math.LOG2E</h4><p>The Number value for the base-<span style="font-family: Times New Roman">2</span> logarithm of <var>e</var>, the base
        of the natural logarithms; this value is approximately <span style="font-family: Times New         Roman">1.4426950408889634</span>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The value of <code>Math.LOG2E</code> is approximately the reciprocal of the value of
          <code>Math.LN2</code>.</p>
        </div>
      </section>

      <section id="sec-math.pi">
        <h4 id="sec-20.2.1.6" title="20.2.1.6">
            Math.PI</h4><p>The Number value for <span style="font-family: Times New Roman">&pi;</span>, the ratio of the circumference of a circle
        to its diameter, which is approximately <span style="font-family: Times New Roman">3.1415926535897932</span>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-math.sqrt1_2">
        <h4 id="sec-20.2.1.7" title="20.2.1.7">
            Math.SQRT1_2</h4><p>The Number value for the square root of <span style="font-family: Times New Roman">&frac12;</span>, which is
        approximately <span style="font-family: Times New Roman">0.7071067811865476</span>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The value of <code>Math.SQRT1_2</code> is approximately the reciprocal of the value of
          <code>Math.SQRT2</code>.</p>
        </div>
      </section>

      <section id="sec-math.sqrt2">
        <h4 id="sec-20.2.1.8" title="20.2.1.8">
            Math.SQRT2</h4><p>The Number value for the square root of <span style="font-family: Times New Roman">2</span>, which is approximately
        <span style="font-family: Times New Roman">1.4142135623730951</span>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-math-@@tostringtag">
        <h4 id="sec-20.2.1.9" title="20.2.1.9"> Math [ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"Math"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-function-properties-of-the-math-object">
      <div class="front">
        <h3 id="sec-20.2.2" title="20.2.2"> Function Properties of the Math Object</h3><p>Each of the following <code>Math</code> object functions applies the <a href="sec-abstract-operations#sec-tonumber">ToNumber</a> abstract
        operation to each of its arguments (in left-to-right order if there is more than one). If <a href="sec-abstract-operations#sec-tonumber">ToNumber</a> returns an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>,
        that <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a> is immediately returned. Otherwise, the
        function performs a computation on the resulting Number value(s). The value returned by each function is a Number.</p>

        <p>In the function descriptions below, the symbols NaN, &minus;0, +0, &minus;&infin; and +&infin; refer to the Number
        values described in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-number-type">6.1.6</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The behaviour of the functions <code>acos</code>, <code>acosh</code>, <code>asin</code>,
          <code>asinh</code>, <code>atan</code>, <code>atanh</code>, <code>atan2</code>, <code>cbrt</code>, <code>cos</code>,
          <code>cosh</code>, <code>exp</code>, <code>expm1</code>, <code>hypot</code>, <code>log</code>,<code>log1p</code>,
          <code>log2</code>, <code>log10</code>, <code>pow</code>, <code>random</code>, <code>sin</code>, <code>sinh</code>,
          <code>sqrt</code>, <code>tan</code>, and <code>tanh</code> is not precisely specified here except to require specific
          results for certain argument values that represent boundary cases of interest. For other argument values, these
          functions are intended to compute approximations to the results of familiar mathematical functions, but some latitude is
          allowed in the choice of approximation algorithms. The general intent is that an implementer should be able to use the
          same mathematical library for ECMAScript on a given hardware platform that is available to C programmers on that
          platform.</p>

          <p>Although the choice of algorithms is left to the implementation, it is recommended (but not specified by this
          standard) that implementations use the approximation algorithms for IEEE 754-2008 arithmetic contained in
          <code>fdlibm</code>, the freely distributable mathematical library from Sun Microsystems (<a href="http://www.netlib.org/fdlibm">http://www.netlib.org/fdlibm</a><code>)</code>.</p>
        </div>
      </div>

      <section id="sec-math.abs">
        <h4 id="sec-20.2.2.1" title="20.2.2.1">
            Math.abs ( x )</h4><p class="normalbefore">Returns the absolute value of <var>x</var>; the result has the same magnitude as <var>x</var> but
        has positive sign.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is &minus;0, the result is +0.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is +&infin;.</li>
        </ul>
      </section>

      <section id="sec-math.acos">
        <h4 id="sec-20.2.2.2" title="20.2.2.2">
            Math.acos ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the arc cosine of <var>x</var>. The result is
        expressed in radians and ranges from <span style="font-family: Times New Roman">+0</span> to <span style="font-family:         Times New Roman">+&pi;</span>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is greater than 1, the result is NaN.</li>
          <li>If <i>x</i> is less than <b>&minus;</b>1, the result is NaN.</li>
          <li>If <i>x</i> is exactly 1, the result is +0.</li>
        </ul>
      </section>

      <section id="sec-math.acosh">
        <h4 id="sec-20.2.2.3" title="20.2.2.3">
            Math.acosh( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the inverse hyperbolic cosine of
        <i>x</i>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If x is less than 1, the result is NaN.</li>
          <li>If x is 1, the result is +0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
        </ul>
      </section>

      <section id="sec-math.asin">
        <h4 id="sec-20.2.2.4" title="20.2.2.4">
            Math.asin ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the arc sine of <var>x</var>. The result is
        expressed in radians and ranges from <span style="font-family: Times New Roman">&minus;&pi;/2</span> to <span style="font-family: Times New Roman">+&pi;/2</span>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is greater than 1, the result is NaN.</li>
          <li>If <i>x</i> is less than &ndash;1, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
        </ul>
      </section>

      <section id="sec-math.asinh">
        <h4 id="sec-20.2.2.5" title="20.2.2.5">
            Math.asinh( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the inverse hyperbolic sine of <i>x</i>.</p>

        <ul>
          <li>I<span style="font-family: Times New Roman">f <i>x</i> is NaN, the result is NaN.</span></li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
          <li>If x is &minus;&infin;, the result is &minus;&infin;.</li>
        </ul>
      </section>

      <section id="sec-math.atan">
        <h4 id="sec-20.2.2.6" title="20.2.2.6">
            Math.atan ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the arc tangent of <var>x</var>. The result
        is expressed in radians and ranges from <span style="font-family: Times New Roman">&minus;&pi;/2</span> to <span style="font-family: Times New Roman">+&pi;/2</span>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is an implementation-dependent approximation to +&pi;/2.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is an implementation-dependent approximation to &minus;&pi;/2.</li>
        </ul>
      </section>

      <section id="sec-math.atanh">
        <h4 id="sec-20.2.2.7" title="20.2.2.7">
            Math.atanh( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the inverse hyperbolic tangent of
        <i>x</i>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is less than &minus;1, the result is NaN.</li>
          <li>If <i>x</i> is greater than 1, the result is NaN.</li>
          <li>If <i>x</i> is &minus;1, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is +1, the result is +&infin;.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
        </ul>
      </section>

      <section id="sec-math.atan2">
        <h4 id="sec-20.2.2.8" title="20.2.2.8">
            Math.atan2 ( y, x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the arc tangent of the quotient <span style="font-family: Times New Roman"><i>y</i><b>/</b><i>x</i></span> of the arguments <var>y</var> and <var>x</var>, where
        the signs of <var>y</var> and <var>x</var> are used to determine the quadrant of the result. Note that it is intentional
        and traditional for the two-argument arc tangent function that the argument named <var>y</var> be first and the argument
        named <var>x</var> be second. The result is expressed in radians and ranges from <span style="font-family: Times New         Roman">&minus;&pi;</span> to <span style="font-family: Times New Roman">+&pi;</span>.</p>

        <ul>
          <li>If either <i>x</i> or <i>y</i> is NaN, the result is NaN.</li>
          <li>If <i>y</i>&gt;0 and <i>x</i> is +0, the result is an implementation-dependent approximation to  +&pi;/2.</li>
          <li>If <i>y</i>&gt;0 and <i>x</i> is &minus;0, the result is an implementation-dependent approximation to  +&pi;/2.</li>
          <li>If <i>y</i> is +0 and <i>x</i>&gt;0, the result is +0.</li>
          <li>If <i>y</i> is +0 and <i>x</i> is +0, the result is +0.</li>
          <li>If <i>y</i> is +0 and <i>x</i> is &minus;0, the result is an implementation-dependent approximation to  +&pi;.</li>
          <li>If <i>y</i> is +0 and <i>x</i>&lt;0, the result is an implementation-dependent approximation to  +&pi;.</li>
          <li>If <i>y</i> is &minus;0 and <i>x</i>&gt;0, the result is &minus;0.</li>
          <li>If <i>y</i> is &minus;0 and <i>x</i> is +0, the result is &minus;0.</li>
          <li>If <i>y</i> is &minus;0 and <i>x</i> is &minus;0, the result is an implementation-dependent approximation to
              &minus;&pi;.</li>
          <li>If <i>y</i> is &minus;0 and <i>x</i>&lt;0, the result is an implementation-dependent approximation to
              &minus;&pi;.</li>
          <li>If <i>y</i>&lt;0 and <i>x</i> is +0, the result is an implementation-dependent approximation to  &minus;&pi;/2.</li>
          <li>If <i>y</i>&lt;0 and <i>x</i> is &minus;0, the result is an implementation-dependent approximation to
              &minus;&pi;/2.</li>
          <li>If <i>y</i>&gt;0 and <i>y</i> is finite and <i>x</i> is +&infin;, the result is +0.</li>
          <li>If <i>y</i>&gt;0 and <i>y</i> is finite and <i>x</i> is &minus;&infin;, the result if an implementation-dependent
              approximation to  +&pi;.</li>
          <li>If <i>y</i>&lt;0 and <i>y</i> is finite and <i>x</i> is +&infin;, the result is &minus;0.</li>
          <li>If <i>y</i>&lt;0 and <i>y</i> is finite and <i>x</i> is &minus;&infin;, the result is an implementation-dependent
              approximation to &minus;&pi;.</li>
          <li>If <i>y</i> is +&infin; and <i>x</i> is finite, the result is an implementation-dependent approximation to
              +&pi;/2.</li>
          <li>If <i>y</i> is &minus;&infin; and <i>x</i> is finite, the result is an implementation-dependent approximation to
              &minus;&pi;/2.</li>
          <li>If <i>y</i> is +&infin; and <i>x</i> is +&infin;, the result is an implementation-dependent approximation to
              +&pi;/4.</li>
          <li>If <i>y</i> is +&infin; and <i>x</i> is &minus;&infin;, the result is an implementation-dependent approximation to
              +3&pi;/4.</li>
          <li>If <i>y</i> is &minus;&infin; and <i>x</i> is +&infin;, the result is an implementation-dependent approximation to
              &minus;&pi;/4.</li>
          <li>If <i>y</i> is &minus;&infin; and <i>x</i> is &minus;&infin;, the result is an implementation-dependent
              approximation to  &minus;3&pi;/4.</li>
        </ul>
      </section>

      <section id="sec-math.cbrt">
        <h4 id="sec-20.2.2.9" title="20.2.2.9">
            Math.cbrt ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the cube root of <i>x</i>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is &minus;&infin;.</li>
        </ul>
      </section>

      <section id="sec-math.ceil">
        <h4 id="sec-20.2.2.10" title="20.2.2.10">
            Math.ceil ( x )</h4><p class="normalbefore">Returns the smallest (closest to <b>&minus;&infin;</b>) Number value that is not less than
        <var>x</var> and is equal to a mathematical integer. If <var>x</var> is already an integer, the result is
        <var>x</var>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is less than 0 but greater than -1, the result is &minus;0.</li>
        </ul>

        <p>The value of <code>Math.ceil(x)</code> is the same as the value of <code>-<a href="#sec-math.floor">Math.floor</a>(-x)</code>.</p>
      </section>

      <section id="sec-math.clz32">
        <h4 id="sec-20.2.2.11" title="20.2.2.11">
            Math.clz32 ( x )</h4><p class="normalbefore">When <code>Math.clz32</code> is called with one argument <var>x</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>n</i> be <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>x</i>).</li>
          <li>Let <i>p</i> be the number of leading zero bits in the 32-bit binary representation of <i>n</i>.</li>
          <li>Return <i>p</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>n</var> is 0, <var>p</var> will be 32. If the most significant bit of the 32-bit
          binary encoding of <var>n</var> is 1, <var>p</var> will be 0.</p>
        </div>
      </section>

      <section id="sec-math.cos">
        <h4 id="sec-20.2.2.12" title="20.2.2.12">
            Math.cos ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the cosine of <var>x</var>. The argument is
        expressed in radians.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is 1.</li>
          <li>If <i>x</i> is &minus;0, the result is 1.</li>
          <li>If <i>x</i> is +&infin;, the result is NaN.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is NaN.</li>
        </ul>
      </section>

      <section id="sec-math.cosh">
        <h4 id="sec-20.2.2.13" title="20.2.2.13">
            Math.cosh ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the hyperbolic cosine of <i>x</i>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is 1.</li>
          <li>If <i>x</i> is &minus;0, the result is 1.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is +&infin;.</li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> The value of cosh(x) is the same as <i>(exp(x) + exp(-x))/2</i>.</p>
        </div>
      </section>

      <section id="sec-math.exp">
        <h4 id="sec-20.2.2.14" title="20.2.2.14">
            Math.exp ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the exponential function of <var>x</var>
        (<var>e</var> raised to the power of <var>x</var>, where <var>e</var> is the base of the natural logarithms).</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is 1.</li>
          <li>If <i>x</i> is &minus;0, the result is 1.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is +0.</li>
        </ul>
      </section>

      <section id="sec-math.expm1">
        <h4 id="sec-20.2.2.15" title="20.2.2.15">
            Math.expm1 ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to subtracting 1 from the exponential function
        of <i>x</i> (<i>e</i> raised to the power of <i>x</i>, where <i>e</i> is the base of the natural logarithms). The result
        is computed in a way that is accurate even when the value of x is close 0.</p>

        <ul>
          <li>I<span style="font-family: Times New Roman">f <i>x</i> is NaN, the result is NaN.</span></li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is &minus;1.</li>
        </ul>
      </section>

      <section id="sec-math.floor">
        <h4 id="sec-20.2.2.16" title="20.2.2.16">
            Math.floor ( x )</h4><p class="normalbefore">Returns the greatest (closest to <b>+&infin;</b>) Number value that is not greater than
        <var>x</var> and is equal to a mathematical integer. If <var>x</var> is already an integer, the result is
        <var>x</var>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is greater than 0 but less than 1, the result is +0.</li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> The value of <code>Math.<a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(x)</code> is the
          same as the value of <code>-<a href="#sec-math.ceil">Math.ceil</a>(-x)</code>.</p>
        </div>
      </section>

      <section id="sec-math.fround">
        <h4 id="sec-20.2.2.17" title="20.2.2.17">
            Math.fround ( x )</h4><p class="normalbefore">When <code>Math.fround</code> is called with argument <i>x</i> the following steps are taken:</p>

        <ol class="proc">
          <li>If <i>x</i> is NaN, return NaN.</li>
          <li>If <i>x</i> is one of +0, &minus;0, +&infin;, &minus;&infin;, return <i>x</i>.</li>
          <li>Let <i>x32</i> be the result of converting <i>x</i> to a value in IEEE 754-2008 binary32 format using
              roundTiesToEven.</li>
          <li>Let <i>x64</i> be the result of converting <i>x32</i> to a value in IEEE 754-2008 binary64 format.</li>
          <li>Return the ECMAScript Number value corresponding to <i>x64</i>.</li>
        </ol>
      </section>

      <section id="sec-math.hypot">
        <h4 id="sec-20.2.2.18" title="20.2.2.18">
            Math.hypot ( value1 , value2 , &hellip;values )</h4><p class="normalbefore"><code>Math.hypot</code> returns an implementation-dependent approximation of the square root of
        the sum of squares of its arguments.</p>

        <ul>
          <li>If no arguments are passed, the result is +0.</li>
          <li>If any argument is +&infin;, the result is +&infin;.</li>
          <li>If any argument is &minus;&infin;, the result is +&infin;.</li>
          <li>If no argument is +&infin; or &minus;&infin;, and any argument is NaN, the result is NaN.</li>
          <li>If all arguments are either +0 or &minus;0, the result is +0.</li>
        </ul>

        <p>The length property of the <code>hypot</code> function is 2.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Implementations should take care to avoid the loss of precision from overflows and
          underflows that are prone to occur in naive implementations when this function is called with two or more arguments.</p>
        </div>
      </section>

      <section id="sec-math.imul">
        <h4 id="sec-20.2.2.19" title="20.2.2.19">
            Math.imul ( x, y )</h4><p class="normalbefore">When the <code>Math.imul</code> is called with arguments <var>x</var> and <var>y</var> the
        following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>a</i> be <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>x</i>).</li>
          <li>Let <i>b</i> be <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>y</i>).</li>
          <li>Let <i>product</i> be (<i>a</i> &times; <i>b</i>) <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a>
              2<sup>32</sup>.</li>
          <li>If <i>product</i> &ge; 2<sup>31</sup>, return <i>product</i> &minus; 2<sup>32</sup>, otherwise return
              <i>product</i>.</li>
        </ol>
      </section>

      <section id="sec-math.log">
        <h4 id="sec-20.2.2.20" title="20.2.2.20">
            Math.log ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the natural logarithm of <var>x</var>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is less than 0, the result is NaN.</li>
          <li>If <i>x</i> is +0 or &minus;0, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is 1, the result is +0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
        </ul>
      </section>

      <section id="sec-math.log1p">
        <h4 id="sec-20.2.2.21" title="20.2.2.21">
            Math.log1p ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the natural logarithm of 1 + <i>x</i>. The
        result is computed in a way that is accurate even when the value of x is close to zero.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is less than -1, the result is NaN.</li>
          <li>If x is -1, the result is -&infin;.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
        </ul>
      </section>

      <section id="sec-math.log10">
        <h4 id="sec-20.2.2.22" title="20.2.2.22">
            Math.log10 ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the base 10 logarithm of <i>x</i>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is less than 0, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is 1, the result is +0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
        </ul>
      </section>

      <section id="sec-math.log2">
        <h4 id="sec-20.2.2.23" title="20.2.2.23">
            Math.log2 ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the base 2 logarithm of <i>x</i>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is less than 0, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is 1, the result is +0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
        </ul>
      </section>

      <section id="sec-math.max">
        <h4 id="sec-20.2.2.24" title="20.2.2.24">
            Math.max ( value1, value2  , &hellip;values  )</h4><p class="normalbefore">Given zero or more arguments, calls <a href="sec-abstract-operations#sec-tonumber">ToNumber</a> on each of the arguments
        and returns the largest of the resulting values.</p>

        <ul>
          <li>
            <p>If no arguments are given, the result is &minus;&infin;.</p>
          </li>

          <li>
            <p>If any value is NaN, the result is NaN.</p>
          </li>

          <li>
            <p>The comparison of values to determine the largest value is done using the Abstract Relational Comparison algorithm
            (<span style="font-family: sans-serif"><a href="sec-abstract-operations#sec-abstract-relational-comparison">7.2.11</a></span>) except that +0
            is considered to be larger than &minus;0.</p>
          </li>
        </ul>

        <p>The <code>length</code> property of the <code>max</code> method is <b>2</b>.</p>
      </section>

      <section id="sec-math.min">
        <h4 id="sec-20.2.2.25" title="20.2.2.25">
            Math.min ( value1, value2  , &hellip;values  )</h4><p class="normalbefore">Given zero or more arguments, calls <a href="sec-abstract-operations#sec-tonumber">ToNumber</a> on each of the arguments
        and returns the smallest of the resulting values.</p>

        <ul>
          <li>
            <p>If no arguments are given, the result is +&infin;.</p>
          </li>

          <li>
            <p>If any value is NaN, the result is NaN.</p>
          </li>

          <li>
            <p>The comparison of values to determine the smallest value is done using the Abstract Relational Comparison algorithm
            (<span style="font-family: sans-serif"><a href="sec-abstract-operations#sec-abstract-relational-comparison">7.2.11</a></span>) except that +0
            is considered to be larger than &minus;0.</p>
          </li>
        </ul>

        <p>The <code>length</code> property of the <code>min</code> method is <b>2</b>.</p>
      </section>

      <section id="sec-math.pow">
        <h4 id="sec-20.2.2.26" title="20.2.2.26">
            Math.pow ( x, y )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the result of raising <var>x</var> to the
        power <var>y</var>.</p>

        <ul>
          <li>If <i>y</i> is NaN, the result is NaN.</li>
          <li>If <i>y</i> is +0, the result is 1, even if <i>x</i> is NaN.</li>
          <li>If <i>y</i> is &minus;0, the result is 1, even if <i>x</i> is NaN.</li>
          <li>If <i>x</i> is NaN and <i>y</i> is nonzero, the result is NaN.</li>
          <li>If <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>x</i>)&gt;1 and <i>y</i> is +&infin;, the result is
              +&infin;.</li>
          <li>If <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>x</i>)&gt;1 and <i>y</i> is &minus;&infin;, the result is
              +0.</li>
          <li>If <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>x</i>) is 1 and <i>y</i> is +&infin;, the result is NaN.</li>
          <li>If <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>x</i>) is 1 and <i>y</i> is &minus;&infin;, the result is
              NaN.</li>
          <li>If <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>x</i>)&lt;1 and <i>y</i> is +&infin;, the result is +0.</li>
          <li>If <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>x</i>)&lt;1 and <i>y</i> is &minus;&infin;, the result is
              +&infin;.</li>
          <li>If <i>x</i> is +&infin; and <i>y</i>&gt;0, the result is +&infin;.</li>
          <li>If <i>x</i> is +&infin; and <i>y</i>&lt;0, the result is +0.</li>
          <li>If <i>x</i> is &minus;&infin; and <i>y</i>&gt;0 and <i>y</i> is an odd integer, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is &minus;&infin; and <i>y</i>&gt;0 and <i>y</i> is not an odd integer, the result is +&infin;.</li>
          <li>If <i>x</i> is &minus;&infin; and <i>y</i>&lt;0 and <i>y</i> is an odd integer, the result is &minus;0.</li>
          <li>If <i>x</i> is &minus;&infin; and <i>y</i>&lt;0 and <i>y</i> is not an odd integer, the result is +0.</li>
          <li>If <i>x</i> is +0 and <i>y</i>&gt;0, the result is +0.</li>
          <li>If <i>x</i> is +0 and <i>y</i>&lt;0, the result is +&infin;.</li>
          <li>If <i>x</i> is &minus;0 and <i>y</i>&gt;0 and <i>y</i> is an odd integer, the result is &minus;0.</li>
          <li>If <i>x</i> is &minus;0 and <i>y</i>&gt;0 and <i>y</i> is not an odd integer, the result is +0.</li>
          <li>If <i>x</i> is &minus;0 and <i>y</i>&lt;0 and <i>y</i> is an odd integer, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is &minus;0 and <i>y</i>&lt;0 and <i>y</i> is not an odd integer, the result is +&infin;.</li>
          <li>If <i>x</i>&lt;0 and <i>x</i> is finite and <i>y</i> is finite and <i>y</i> is not an integer, the result is
              NaN.</li>
        </ul>
      </section>

      <section id="sec-math.random">
        <h4 id="sec-20.2.2.27" title="20.2.2.27">
            Math.random ( )</h4><p>Returns a Number value with positive sign, greater than or equal to 0 but less than 1, chosen randomly or pseudo
        randomly with approximately uniform distribution over that range, using an implementation-dependent algorithm or strategy.
        This function takes no arguments.</p>

        <p>Each <code>Math.random</code> function created for distinct code Realms must produce a distinct sequence of values from
        successive calls.</p>
      </section>

      <section id="sec-math.round">
        <h4 id="sec-20.2.2.28" title="20.2.2.28">
            Math.round ( x )</h4><p class="normalbefore">Returns the Number value that is closest to <var>x</var> and is equal to a mathematical integer.
        If two integer Number values are equally close to <var>x</var>, then the result is the Number value that is closer to
        <span style="font-family: Times New Roman">+&infin;</span>. If <var>x</var> is already an integer, the result is
        <var>x</var>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is greater than 0 but less than 0.5, the result is +0.</li>
          <li>If <i>x</i> is less than 0 but greater than or equal to -0.5, the result is &minus;0.</li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE 1</span> <code>Math.round(3.5)</code> returns <span style="font-family: Times New           Roman">4</span>, but <code>Math.round(&ndash;3.5)</code> returns <span style="font-family: Times New           Roman">&ndash;3</span>.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The value of <code>Math.round(x)</code> is not always the same as the value of
          <code><a href="#sec-math.floor">Math.floor</a>(x+0.5)</code>. When <code>x</code> is <span style="font-family: Times New           Roman">&minus;0</span> or is less than <span style="font-family: Times New Roman">0</span> but greater than or equal to
          <span style="font-family: Times New Roman">-0.5</span>, <code>Math.round(x)</code> returns <span style="font-family:           Times New Roman">&minus;0</span>, but <code><a href="#sec-math.floor">Math.floor</a>(x+0.5)</code> returns <span style="font-family: Times New Roman">+0</span>. <code>Math.round(x)</code> may also differ from the value of <code><a href="#sec-math.floor">Math.floor</a>(x+0.5)</code>because of internal rounding when computing <code>x+0.5</code>.</p>
        </div>
      </section>

      <section id="sec-math.sign">
        <h4 id="sec-20.2.2.29" title="20.2.2.29">
            Math.sign(x)</h4><p class="normalbefore">Returns the sign of the x, indicating whether x is positive, negative or zero.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is negative and not &minus;0, the result is &minus;1.</li>
          <li>If <i>x</i> is positive and not +0, the result is +1.</li>
        </ul>
      </section>

      <section id="sec-math.sin">
        <h4 id="sec-20.2.2.30" title="20.2.2.30">
            Math.sin ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the sine of <var>x</var>. The argument is
        expressed in radians.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin; or &minus;&infin;, the result is NaN.</li>
        </ul>
      </section>

      <section id="sec-math.sinh">
        <h4 id="sec-20.2.2.31" title="20.2.2.31">
            Math.sinh( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the hyperbolic sine of <i>x</i>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
          <li>If x is &minus;&infin;, the result is &minus;&infin;.</li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> The value of sinh(x) is the same as <i>(exp(x) - exp(-x))/2</i>.</p>
        </div>
      </section>

      <section id="sec-math.sqrt">
        <h4 id="sec-20.2.2.32" title="20.2.2.32">
            Math.sqrt ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the square root of <var>x</var>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is less than 0, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
        </ul>
      </section>

      <section id="sec-math.tan">
        <h4 id="sec-20.2.2.33" title="20.2.2.33">
            Math.tan ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the tangent of <var>x</var>. The argument is
        expressed in radians.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin; or &minus;&infin;, the result is NaN.</li>
        </ul>
      </section>

      <section id="sec-math.tanh">
        <h4 id="sec-20.2.2.34" title="20.2.2.34">
            Math.tanh ( x )</h4><p class="normalbefore">Returns an implementation-dependent approximation to the hyperbolic tangent of <i>x</i>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +&infin;, the result is +1.</li>
          <li>If <i>x</i> is &minus;&infin;, the result is -1.</li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> The value of tanh(x) is the same as <i>(exp(x) - exp(-x))/(exp(x) + exp(-x))</i>.</p>
        </div>
      </section>

      <section id="sec-math.trunc">
        <h4 id="sec-20.2.2.35" title="20.2.2.35">
            Math.trunc ( x )</h4><p class="normalbefore">Returns the integral part of the number <var>x</var>, removing any fractional digits. If
        <var>x</var> is already an integer, the result is <var>x</var>.</p>

        <ul>
          <li>If <i>x</i> is NaN, the result is NaN.</li>
          <li>If <i>x</i> is &minus;0, the result is &minus;0.</li>
          <li>If <i>x</i> is +0, the result is +0.</li>
          <li>If <i>x</i> is +&infin;, the result is +&infin;.</li>
          <li>If x is &minus;&infin;, the result is &minus;&infin;.</li>
          <li>If <i>x</i> is greater than 0 but less than 1, the result is +0.</li>
          <li>If <i>x</i> is less than 0 but greater than &minus;1, the result is &minus;0.</li>
        </ul>
      </section>
    </section>
  </section>

  <section id="sec-date-objects">
    <div class="front">
      <h2 id="sec-20.3" title="20.3"> Date
          Objects</h2></div>

    <section id="sec-overview-of-date-objects-and-definitions-of-abstract-operations">
      <div class="front">
        <h3 id="sec-20.3.1" title="20.3.1"> Overview of Date Objects and Definitions of Abstract Operations</h3><p>The following functions are abstract operations that operate on time values (defined in <a href="#sec-time-values-and-time-range">20.3.1.1</a>). Note that, in every case, if any argument to one of these functions
        is <b>NaN</b>, the result will be <b>NaN</b>.</p>
      </div>

      <section id="sec-time-values-and-time-range">
        <h4 id="sec-20.3.1.1" title="20.3.1.1"> Time Values and Time Range</h4><p>A Date object contains a Number indicating a particular instant in time to within a millisecond. Such a Number is
        called a <i>time value</i>. A time value may also be <b>NaN</b>, indicating that the Date object does not represent a
        specific instant of time.</p>

        <p>Time is measured in ECMAScript in milliseconds since 01 January, 1970 UTC. In time values leap seconds are ignored. It
        is assumed that there are exactly 86,400,000 milliseconds per day. ECMAScript Number values can represent all integers
        from &ndash;9,007,199,254,740,992 to 9,007,199,254,740,992; this range suffices to measure times to millisecond precision
        for any instant that is within approximately 285,616 years, either forward or backward, from 01 January, 1970 UTC.</p>

        <p>The actual range of times supported by ECMAScript Date objects is slightly smaller: exactly &ndash;100,000,000 days to
        100,000,000 days measured relative to midnight at the beginning of 01 January, 1970 UTC. This gives a range of
        8,640,000,000,000,000 milliseconds to either side of 01 January, 1970 UTC.</p>

        <p>The exact moment of midnight at the beginning of 01 January, 1970 UTC is represented by the value <b>+0</b>.</p>
      </section>

      <section id="sec-day-number-and-time-within-day">
        <h4 id="sec-20.3.1.2" title="20.3.1.2"> Day Number and Time within Day</h4><p class="normalbefore">A given <a href="#sec-time-values-and-time-range">time value</a> <i>t</i> belongs to day
        number</p>

        <div class="display">Day(<i>t</i>) = <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<i>t</i> / msPerDay)</div>

        <p class="normalbefore">where the number of milliseconds per day is</p>

        <div class="display">msPerDay = 86400000</div>

        <p class="normalbefore">The remainder is called the time within the day:</p>

        <div class="display">TimeWithinDay(<i>t</i>) = <i>t</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> msPerDay</div>
      </section>

      <section id="sec-year-number">
        <h4 id="sec-20.3.1.3" title="20.3.1.3">
            Year Number</h4><p class="normalbefore">ECMAScript uses an extrapolated Gregorian system to map a day number to a year number and to
        determine the month and date within that year. In this system, leap years are precisely those which are (divisible by
        <span style="font-family: Times New Roman">4</span>) and ((not divisible by <span style="font-family: Times New         Roman">100</span>) or (divisible by <span style="font-family: Times New Roman">400</span>)). The number of days in year
        number <var>y</var> is therefore defined by</p>

        <p class="normalBullet">DaysInYear(<i>y</i>) <br />= 365  if (<i>y</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 4)
        &ne; 0<br />= 366  if (<i>y</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 4) = 0 and (<i>y</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 100) &ne; 0<br />= 365  if (<i>y</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 100) = 0 and (<i>y</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 400)
        &ne; 0<br />= 366  if (<i>y</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 400) = 0</p>

        <p class="normalbefore">All non-leap years have <span style="font-family: Times New Roman">365</span> days with the usual
        number of days per month and leap years have an extra day in February. The day number of the first day of year
        <var>y</var> is given by:</p>

        <p class="normalBullet">DayFromYear(<i>y</i>) = 365 &times; (<i>y</i>&minus;1970) + <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>((<i>y</i>&minus;1969)/4) &minus; <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>((<i>y</i>&minus;1901)/100) + <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>((<i>y</i>&minus;1601)/400)</p>

        <p class="normalbefore">The <a href="#sec-time-values-and-time-range">time value</a> of the start of a year is:</p>

        <p class="normalBullet">TimeFromYear(<i>y</i>) = <a href="#sec-day-number-and-time-within-day">msPerDay</a> &times;
        DayFromYear(<i>y</i>)</p>

        <p class="normalbefore">A <a href="#sec-time-values-and-time-range">time value</a> determines a year by:</p>

        <p class="normalBullet">YearFromTime(<i>t</i>) = the largest integer <i>y</i> (closest to positive infinity) such that
        TimeFromYear(<i>y</i>) &le; <i>t</i></p>

        <p class="normalbefore">The leap-year function is 1 for a time within a leap year and otherwise is zero:</p>

        <p class="normalBullet">InLeapYear(<i>t</i>)<br />= 0  if DaysInYear(YearFromTime(<i>t</i>)) = 365<br />= 1  if
        DaysInYear(YearFromTime(<i>t</i>)) = 366</p>
      </section>

      <section id="sec-month-number">
        <h4 id="sec-20.3.1.4" title="20.3.1.4">
            Month Number</h4><p class="normalbefore">Months are identified by an integer in the range <span style="font-family: Times New         Roman">0</span> to <span style="font-family: Times New Roman">11</span>, inclusive. The mapping MonthFromTime(<i>t</i>)
        from a <a href="#sec-time-values-and-time-range">time value</a> <i>t</i> to a month number is defined by:</p>

        <p class="normalBullet">MonthFromTime(<i>t</i>)&#x9;<br />&#x9;= 0&#x9;if 0&#x9;&le; DayWithinYear(<i>t</i>) &lt;
        31<br />&#x9;= 1&#x9;if 31 &le; DayWithinYear (<i>t</i>) &lt; 59+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)<br />&#x9;= 2&#x9;if 59+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)
        &le; DayWithinYear (<i>t</i>) &lt; 90+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)<br />&#x9;= 3&#x9;if 90+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>) &le; DayWithinYear (<i>t</i>) &lt; 120+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)<br />&#x9;= 4&#x9;if 120+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>) &le; DayWithinYear (<i>t</i>) &lt; 151+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)<br />&#x9;= 5&#x9;if 151+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>) &le; DayWithinYear (<i>t</i>) &lt; 181+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)<br />&#x9;= 6&#x9;if 181+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>) &le; DayWithinYear (<i>t</i>) &lt; 212+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)<br />&#x9;= 7&#x9;if 212+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>) &le; DayWithinYear (<i>t</i>) &lt; 243+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)<br />&#x9;= 8&#x9;if 243+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>) &le; DayWithinYear (<i>t</i>) &lt; 273+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)<br />&#x9;= 9&#x9;if 273+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>) &le; DayWithinYear (<i>t</i>) &lt; 304+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)<br />&#x9;= 10&#x9;if 304+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>) &le; DayWithinYear (<i>t</i>) &lt; 334+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)<br />&#x9;= 11&#x9;if 334+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>) &le; DayWithinYear (<i>t</i>) &lt; 365+<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)</p>

        <p class="normalbefore">where</p>

        <p class="normalBullet">DayWithinYear(<i>t</i>) = <a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>)&minus;DayFromYear(<a href="#sec-year-number">YearFromTime</a>(<i>t</i>))</p>

        <p>A month value of <span style="font-family: Times New Roman">0</span> specifies January; <span style="font-family: Times         New Roman">1</span> specifies February; <span style="font-family: Times New Roman">2</span> specifies March; <span style="font-family: Times New Roman">3</span> specifies April; <span style="font-family: Times New         Roman">4</span>&nbsp;specifies May; <span style="font-family: Times New Roman">5</span> specifies June; <span style="font-family: Times New Roman">6</span> specifies July; <span style="font-family: Times New Roman">7</span>
        specifies August; <span style="font-family: Times New Roman">8</span> specifies September; <span style="font-family: Times         New Roman">9</span> specifies October; <span style="font-family: Times New Roman">10</span> specifies November; and <span style="font-family: Times New Roman">11</span> specifies December. Note that <span style="font-family: Times New         Roman">MonthFromTime(0) = 0</span>, corresponding to Thursday, 01 January, 1970.</p>
      </section>

      <section id="sec-date-number">
        <h4 id="sec-20.3.1.5" title="20.3.1.5">
            Date Number</h4><p>A date number is identified by an integer in the range <span style="font-family: Times New Roman">1</span> through
        <span style="font-family: Times New Roman">31</span>, inclusive. The mapping DateFromTime(<i>t</i>) from a <a href="#sec-time-values-and-time-range">time value</a> <i>t</i> to a date number is defined by:</p>

        <p class="normalBullet">DateFromTime(<i>t</i>)<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)+1&#x9;&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=0<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;30&#x9;&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=1<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;58&minus;<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=2<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;89&minus;<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=3<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;119&minus;<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=4<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;150&minus;<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=5<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;180&minus;<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=6<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;211&minus;<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=7<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;242&minus;<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=8<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;272&minus;<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=9<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;303&minus;<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=10<br />&#x9;&#x9;= <a href="#sec-month-number">DayWithinYear</a>(<i>t</i>)&minus;333&minus;<a href="#sec-year-number">InLeapYear</a>(<i>t</i>)&#x9;if <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>)=11</p>
      </section>

      <section id="sec-week-day">
        <h4 id="sec-20.3.1.6" title="20.3.1.6"> Week
            Day</h4><p class="normalbefore">The weekday for a particular <a href="#sec-time-values-and-time-range">time value</a> <var>t</var>
        is defined as</p>

        <p class="normalBullet">WeekDay(<i>t</i>) = (<a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>) + 4) <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 7</p>

        <p>A weekday value of <span style="font-family: Times New Roman">0</span> specifies Sunday; <span style="font-family:         Times New Roman">1</span> specifies Monday; <span style="font-family: Times New Roman">2</span> specifies Tuesday; <span style="font-family: Times New Roman">3</span> specifies Wednesday; <span style="font-family: Times New         Roman">4</span>&nbsp;specifies Thursday; <span style="font-family: Times New Roman">5</span> specifies Friday; and <span style="font-family: Times New Roman">6</span> specifies Saturday. Note that <span style="font-family: Times New         Roman">WeekDay(0) = 4</span>, corresponding to Thursday, 01 January, 1970.</p>
      </section>

      <section id="sec-local-time-zone-adjustment">
        <h4 id="sec-20.3.1.7" title="20.3.1.7"> Local Time Zone Adjustment</h4><p>An implementation of ECMAScript is expected to determine the local time zone adjustment. The local time zone adjustment
        is a value LocalTZA measured in milliseconds which when added to UTC represents the local <i>standard</i> time. Daylight
        saving time is <i>not</i> reflected by LocalTZA.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> It is recommended that implementations use the time zone information of the IANA Time
          Zone Database  <a href="http://www.iana.org/time-zones/">http://www.iana.org/time-zones/</a>.</p>
        </div>
      </section>

      <section id="sec-daylight-saving-time-adjustment">
        <h4 id="sec-20.3.1.8" title="20.3.1.8"> Daylight Saving Time Adjustment</h4><p>An implementation dependent algorithm using best available information on time zones to determine the local daylight
        saving time adjustment DaylightSavingTA(<i>t</i>), measured in milliseconds. An implementation of ECMAScript is expected
        to make its best effort to determine the local daylight saving time adjustment.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> It is recommended that implementations use the time zone information of the IANA Time
          Zone Database  <a href="http://www.iana.org/time-zones/">http://www.iana.org/time-zones/</a>.</p>
        </div>
      </section>

      <section id="sec-localtime">
        <h4 id="sec-20.3.1.9" title="20.3.1.9">
            LocalTime ( t )</h4><p class="normalbefore">The abstract operation LocalTime with argument <var>t</var> converts <var>t</var> from UTC to
        local time by performing the following steps:</p>

        <ol class="proc">
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Return <i>t</i> + <a href="#sec-local-time-zone-adjustment">LocalTZA</a> + <a href="#sec-daylight-saving-time-adjustment">DaylightSavingTA</a>(<i>t</i>).</li>
        </ol>
      </section>

      <section id="sec-utc-t">
        <h4 id="sec-20.3.1.10" title="20.3.1.10"> UTC ( t
            )</h4><p class="normalbefore">The abstract operation UTC with argument <var>t</var> converts <var>t</var> from local time to UTC
        is defined by performing the following steps:</p>

        <ol class="proc">
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Return <i>t</i> &ndash; <a href="#sec-local-time-zone-adjustment">LocalTZA</a> &ndash; <a href="#sec-daylight-saving-time-adjustment">DaylightSavingTA</a>(<i>t</i> &ndash; <a href="#sec-local-time-zone-adjustment">LocalTZA</a>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span>  <span style="font-family: Times New Roman">UTC(<a href="#sec-localtime">LocalTime</a>(<i>t</i>))</span> is not necessarily always equal to <i>t</i>.</p>
        </div>
      </section>

      <section id="sec-hours-minutes-second-and-milliseconds">
        <h4 id="sec-20.3.1.11" title="20.3.1.11"> Hours, Minutes, Second, and Milliseconds</h4><p class="normalbefore">The following abstract operations are useful in decomposing time values:</p>

        <p class="normalBullet">HourFromTime(<i>t</i>)&#x9;= <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<i>t</i> / msPerHour)
        <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> HoursPerDay</p>

        <p class="normalBullet">MinFromTime(<i>t</i>)&#x9;= <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<i>t</i> / msPerMinute)
        <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> MinutesPerHour</p>

        <p class="normalBullet">SecFromTime(<i>t</i>)&#x9;= <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<i>t</i> / msPerSecond)
        <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> SecondsPerMinute</p>

        <p class="normalBullet">msFromTime(<i>t</i>)&#x9;= <i>t</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a>
        msPerSecond</p>

        <p class="normalbefore">where</p>

        <p class="normalBullet">HoursPerDay&#x9;= 24</p>

        <p class="normalBullet">MinutesPerHour&#x9;= 60</p>

        <p class="normalBullet">SecondsPerMinute&#x9;= 60</p>

        <p class="normalBullet">msPerSecond&#x9;= 1000</p>

        <p class="normalBullet">msPerMinute&#x9;= 60000&#x9;= msPerSecond &times; SecondsPerMinute</p>

        <p class="normalBullet">msPerHour&#x9;= 3600000&#x9;= msPerMinute &times; MinutesPerHour</p>
      </section>

      <section id="sec-maketime">
        <h4 id="sec-20.3.1.12" title="20.3.1.12">
            MakeTime (hour, min, sec, ms)</h4><p class="normalbefore">The abstract operation MakeTime calculates a number of milliseconds from its four arguments, which
        must be ECMAScript Number values. This operator functions as follows:</p>

        <ol class="proc">
          <li>If <i>hour</i> is not finite or <i>min</i> is not finite or <i>sec</i> is not finite or <i>ms</i> is not finite,
              return <b>NaN</b>.</li>
          <li>Let <i>h</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>hour</i>).</li>
          <li>Let <i>m</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>min</i>).</li>
          <li>Let <i>s</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>sec</i>).</li>
          <li>Let <i>milli</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>ms</i>).</li>
          <li>Let <i>t</i> be <i>h</i> <code>*</code> <a href="#sec-hours-minutes-second-and-milliseconds">msPerHour</a>
              <code>+</code> <i>m</i> <code>*</code> <a href="#sec-hours-minutes-second-and-milliseconds">msPerMinute</a>
              <code>+</code> <i>s</i> <code>*</code> <a href="#sec-hours-minutes-second-and-milliseconds">msPerSecond</a>
              <code>+</code> <i>milli</i>, performing the arithmetic according to IEEE 754-2008 rules (that is, as if using the
              ECMAScript operators <code>*</code> and <code>+</code>).</li>
          <li>Return <i>t</i>.</li>
        </ol>
      </section>

      <section id="sec-makeday">
        <h4 id="sec-20.3.1.13" title="20.3.1.13">
            MakeDay (year, month, date)</h4><p>The abstract operation MakeDay calculates a number of days from its three arguments, which must be ECMAScript Number
        values. This operator functions as follows:</p>

        <ol class="proc">
          <li>If <i>year</i> is not finite or <i>month</i> is not finite or <i>date</i> is not finite, return <b>NaN</b>.</li>
          <li>Let <i>y</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>year</i>).</li>
          <li>Let <i>m</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>month</i>).</li>
          <li>Let <i>dt</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>date</i>).</li>
          <li>Let <i>ym</i> be <i>y</i> + <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<i>m</i> /12).</li>
          <li>Let <i>mn</i> be <i>m</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> 12.</li>
          <li>Find a value <i>t</i> such that <a href="#sec-year-number">YearFromTime</a>(<i>t</i>) is <i>ym</i> and <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>) is <i>mn</i> and <a href="#sec-date-number">DateFromTime</a>(<i>t</i>) is 1; but if this is not possible (because some argument is out
              of range), return <b>NaN</b>.</li>
          <li>Return <a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>) + <i>dt</i> &minus; 1.</li>
        </ol>
      </section>

      <section id="sec-makedate">
        <h4 id="sec-20.3.1.14" title="20.3.1.14">
            MakeDate (day, time)</h4><p class="normalbefore">The abstract operation MakeDate calculates a number of milliseconds from its two arguments, which
        must be ECMAScript Number values. This operator functions as follows:</p>

        <ol class="proc">
          <li>If <i>day</i> is not finite or <i>time</i> is not finite, return <b>NaN</b>.</li>
          <li>Return <i>day</i> &times; <a href="#sec-day-number-and-time-within-day">msPerDay</a> + <i>time</i>.</li>
        </ol>
      </section>

      <section id="sec-timeclip">
        <h4 id="sec-20.3.1.15" title="20.3.1.15">
            TimeClip (time)</h4><p class="normalbefore">The abstract operation TimeClip calculates a number of milliseconds from its argument, which must
        be an ECMAScript Number value. This operator functions as follows:</p>

        <ol class="proc">
          <li>If <i>time</i> is not finite, return <b>NaN</b>.</li>
          <li>If <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>time</i>) &gt; 8.64&nbsp;<span style="font-family:               sans-serif">&times;</span>&nbsp;10<sup>15</sup>, return <b>NaN</b>.</li>
          <li>Return <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>time</i>) + (<b>+0</b>). (Adding a positive zero converts
              <b>&minus;0</b> to <b>+0</b>.)</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The point of step 3 is that an implementation is permitted a choice of internal
          representations of time values, for example as a 64-bit signed integer or as a 64-bit floating-point value. Depending on
          the implementation, this internal representation may or may not distinguish <b>&minus;0</b> and <b>+0</b>.</p>
        </div>
      </section>

      <section id="sec-date-time-string-format">
        <div class="front">
          <h4 id="sec-20.3.1.16" title="20.3.1.16"> Date Time String Format</h4><p>ECMAScript defines a string interchange format for date-times based upon a simplification of the ISO 8601 Extended
          Format. The format is as follows: <code>YYYY-MM-DDTHH:mm:ss.sss<i>Z</i></code></p>

          <p class="normalbefore">Where the fields are as follows:</p>

          <figure>
            <table class="lightweight-table">
              <tr>
                <td><code>YYYY</code></td>
                <td>is the decimal digits of the year 0000 to 9999 in the Gregorian calendar.</td>
              </tr>
              <tr>
                <td><code>-</code></td>
                <td><code>"-"</code> <span style="font-family: sans-serif">(hyphen) appears literally twice in the string.</span></td>
              </tr>
              <tr>
                <td><code>MM</code></td>
                <td>is the month of the year from 01 (January) to 12 (December).</td>
              </tr>
              <tr>
                <td><code>DD</code></td>
                <td>is the day of the month from 01 to 31.</td>
              </tr>
              <tr>
                <td><code>T</code></td>
                <td><code>"T"</code> <span style="font-family: sans-serif">appears literally in the string, to indicate the beginning of the time element.</span></td>
              </tr>
              <tr>
                <td><code>HH</code></td>
                <td>is the number of complete hours that have passed since midnight as two decimal digits from 00 to 24.</td>
              </tr>
              <tr>
                <td><code>:</code></td>
                <td><code>":"</code> <span style="font-family: sans-serif">(colon) appears literally twice in the string.</span></td>
              </tr>
              <tr>
                <td><code>mm</code></td>
                <td>is the number of complete minutes since the start of the hour as two decimal digits from 00 to 59.</td>
              </tr>
              <tr>
                <td><code>ss</code></td>
                <td>is the number of complete seconds since the start of the minute as two decimal digits from 00 to 59.</td>
              </tr>
              <tr>
                <td><code>.</code></td>
                <td><code>"."</code> <span style="font-family: sans-serif">(dot) appears literally in the string.</span></td>
              </tr>
              <tr>
                <td><code>sss</code></td>
                <td>is the number of complete milliseconds since the start of the second as three decimal digits.</td>
              </tr>
              <tr>
                <td><code>Z</code></td>
                <td><span style="font-family: sans-serif">is the time zone offset specified as</span> <code>"Z"</code> <span style="font-family: sans-serif">(for UTC) or either</span> <code>"+"</code> <span style="font-family: sans-serif">or</span> <code>"-"</code> <span style="font-family: sans-serif">followed by a time expression</span> <code>HH:mm</code></td>
              </tr>
            </table>
          </figure>

          <p class="normalbefore">This format includes date-only forms:</p>

          <pre>YYYY<br />YYYY-MM<br />YYYY-MM-DD</pre>

          <p class="normalbefore">It also includes &ldquo;date-time&rdquo; forms that consist of one of the above date-only forms
          immediately followed by one of the following time forms with an optional time zone offset appended:</p>

          <pre>THH:mm<br />THH:mm:ss<br />THH:mm:ss.sss</pre>

          <p>All numbers must be base <span style="font-family: Times New Roman">10</span>. If the <code>MM</code> or
          <code>DD</code> fields are absent <code>"01"</code> is used as the value. If the <code>HH</code>, <code>mm</code>, or
          <code>ss</code> fields are absent <code>"00"</code> is used as the value and the value of an absent <code>sss</code>
          field is <code>"000"</code>. If the time zone offset is absent, the date-time is interpreted as a local time.</p>

          <p>Illegal values (out-of-bounds as well as syntax errors) in a format string means that the format string is not a
          valid instance of this format.</p>

          <div class="note">
            <p><span class="nh">NOTE 1</span> As every day both starts and ends with midnight, the two notations
            <code>00:00</code> and <code>24:00</code> are available to distinguish the two midnights that can be associated with
            one date. This means that the following two notations refer to exactly the same point in time:
            <code>1995-02-04T24:00</code> and <code>1995-02-05T00:00</code></p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 2</span> There exists no international standard that specifies abbreviations for civil time
            zones like CET, EST, etc. and sometimes the same abbreviation is even used for two very different time zones. For this
            reason, ISO 8601 and this format specifies numeric representations of date and time.</p>
          </div>
        </div>

        <section id="sec-extended-years">
          <h5 id="sec-20.3.1.16.1" title="20.3.1.16.1"> Extended years</h5><p>ECMAScript requires the ability to specify <span style="font-family: Times New Roman">6</span> digit years (extended
          years); approximately <span style="font-family: Times New Roman">285,426</span> years, either forward or backward, from
          01 January, 1970 UTC. To represent years before <span style="font-family: Times New Roman">0</span> or after <span style="font-family: Times New Roman">9999</span>, ISO 8601 permits the expansion of the year representation, but only by
          prior agreement between the sender and the receiver. In the simplified ECMAScript format such an expanded year
          representation shall have <span style="font-family: Times New Roman">2</span> extra year digits and is always prefixed
          with a + or &ndash; sign. The year <span style="font-family: Times New Roman">0</span> is considered positive and hence
          prefixed with a + sign.</p>

          <div class="note">
            <p><span class="nh">NOTE</span> Examples of extended years:</p>

            <figure>
              <table class="lightweight-table">
                <tr>
                  <td>
                    <p class="NoteCode">-283457-03-21T15:00:59.008Z</p>
                  </td>

                  <td>
                    <p class="NoteCode">283458 B.C.</p>
                  </td>
                </tr>
                <tr>
                  <td>
                    <p class="NoteCode">-000001-01-01T00:00:00Z</p>
                  </td>

                  <td>
                    <p class="NoteCode">2 B.C.</p>
                  </td>
                </tr>
                <tr>
                  <td>
                    <p class="NoteCode">+000000-01-01T00:00:00Z</p>
                  </td>

                  <td>
                    <p class="NoteCode">1 B.C.</p>
                  </td>
                </tr>
                <tr>
                  <td>
                    <p class="NoteCode">+000001-01-01T00:00:00Z</p>
                  </td>

                  <td>
                    <p class="NoteCode">1 A.D.</p>
                  </td>
                </tr>
                <tr>
                  <td>
                    <p class="NoteCode">+001970-01-01T00:00:00Z</p>
                  </td>

                  <td>
                    <p class="NoteCode">1970 A.D.</p>
                  </td>
                </tr>
                <tr>
                  <td>
                    <p class="NoteCode">+002009-12-15T00:00:00Z</p>
                  </td>

                  <td>
                    <p class="NoteCode">2009 A.D.</p>
                  </td>
                </tr>
                <tr>
                  <td>
                    <p class="NoteCode">+287396-10-12T08:59:00.992Z</p>
                  </td>

                  <td>
                    <p class="NoteCode">287396 A.D.</p>
                  </td>
                </tr>
              </table>
            </figure>
          </div>
        </section>
      </section>
    </section>

    <section id="sec-date-constructor">
      <div class="front">
        <h3 id="sec-20.3.2" title="20.3.2">
            The Date Constructor</h3><p>The Date constructor is the %Date% intrinsic object and the initial value of the <code>Date</code> property of the
        global object. When called as a constructor it creates and initializes a new Date object. When <code>Date</code> is called
        as a function rather than as a constructor, it returns a String representing the current time (UTC).</p>

        <p>The <code>Date</code> constructor is a single function whose behaviour is overloaded based upon the number and types of
        its arguments.</p>

        <p>The <code>Date</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>Date</code> behaviour must include a <code>super</code> call to the <code>Date</code> constructor to create and
        initialize the subclass instance with a [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
        slot</a>.</p>
      </div>

      <section id="sec-date-year-month-date-hours-minutes-seconds-ms">
        <h4 id="sec-20.3.2.1" title="20.3.2.1"> Date ( year, month [, date [ , hours [ , minutes [ , seconds [ , ms ]
            ] ] ] ] )</h4><p>This description applies only if the Date constructor is called with at least two arguments.</p>

        <p class="normalbefore">When the <code>Date</code> function is called the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>numberOfArgs</i> be the number of arguments passed to this function call.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numberOfArgs</i> &ge; 2.</li>
          <li>If NewTarget is not <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>y</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>year</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>y</i>).</li>
              <li>Let <i>m</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>month</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>m</i>).</li>
              <li>If <i>date</i> is supplied, let <i>dt</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>date</i>); else let
                  <i>dt</i> be <b>1</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>dt</i>).</li>
              <li>If <i>hours</i> is supplied, let <i>h</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>hours</i>); else let
                  <i>h</i> be <b>0</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>h</i>).</li>
              <li>If <i>minutes</i> is supplied, let <i>min</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>minutes</i>); else let
                  <i>min</i> be <b>0</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>min</i>).</li>
              <li>If <i>seconds</i> is supplied, let <i>s</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>seconds</i>); else let
                  <i>s</i> be <b>0</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>s</i>).</li>
              <li>If <i>ms</i> is supplied, let <i>milli</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>ms</i>); else let
                  <i>milli</i> be <b>0</b>.</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>milli</i>).</li>
              <li>If&nbsp;<i>y</i>&nbsp;is&nbsp;not&nbsp;<b>NaN</b>&nbsp;and&nbsp;0&nbsp;&le;&nbsp;<a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>y</i>)&nbsp;&le;&nbsp;99, let <i>yr</i> be&nbsp;1900+<a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>y</i>); otherwise, let <i>yr</i> be <i>y</i>.</li>
              <li>Let <i>finalDate</i> be  <a href="#sec-makedate">MakeDate</a>(<a href="#sec-makeday">MakeDay</a>(<i>yr</i>,
                  <i>m</i>, <i>dt</i>), <a href="#sec-maketime">MakeTime</a>(<i>h</i>, <i>min</i>, <i>s</i>, <i>milli</i>)).</li>
              <li>Let <i>O</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
                  <code>"%DatePrototype%"</code>, &laquo;&zwj; [[DateValue]]&raquo;).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
              <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i> to
                  <a href="#sec-timeclip">TimeClip</a>(<a href="#sec-utc-t">UTC</a>(<i>finalDate</i>)).</li>
              <li>Return <i>O</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>now</i> be the Number that is the <a href="#sec-time-values-and-time-range">time value</a> (UTC)
                  identifying the current time.</li>
              <li>Return <a href="#sec-todatestring">ToDateString</a> (<i>now</i>).</li>
            </ol>
          </li>
        </ol>
      </section>

      <section id="sec-date-value">
        <h4 id="sec-20.3.2.2" title="20.3.2.2"> Date
            ( value )</h4><p>This description applies only if the Date constructor is called with exactly one argument.</p>

        <p class="normalbefore">When the <code>Date</code> function is called the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>numberOfArgs</i> be the number of arguments passed to this function call.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numberOfArgs</i> = 1.</li>
          <li>If NewTarget is not <b>undefined</b>, then
            <ol class="block">
              <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Object and  <i>value</i> has a
                  [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, then
                <ol class="block">
                  <li>Let <i>tv</i> be thisTimeValue(<i>value</i>).</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-toprimitive">ToPrimitive</a>(<i>value</i>).</li>
                  <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>v</i>) is String, then
                    <ol class="block">
                      <li>Let <i>tv</i> be the result of parsing <i>v</i> as a date, in exactly the same manner as for the
                          <code>parse</code> method (<a href="#sec-date.parse">20.3.3.2</a>). If the parse resulted in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, <i>tv</i> is the <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a>.</li>
                    </ol>
                  </li>
                  <li>Else,
                    <ol class="block">
                      <li>Let <i>tv</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>v</i>).</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>tv</i>).</li>
              <li>Let <i>O</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
                  <code>"%DatePrototype%"</code>, &laquo;&zwj; [[DateValue]]&raquo;).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
              <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i> to
                  <a href="#sec-timeclip">TimeClip</a>(<i>tv</i>).</li>
              <li>Return <i>O</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>now</i> be the Number that is the <a href="#sec-time-values-and-time-range">time value</a> (UTC)
                  identifying the current time.</li>
              <li>Return <a href="#sec-todatestring">ToDateString</a> (<i>now</i>).</li>
            </ol>
          </li>
        </ol>
      </section>

      <section id="sec-date-constructor-date">
        <h4 id="sec-20.3.2.3" title="20.3.2.3"> Date ( )</h4><p>This description applies only if the Date constructor is called with no arguments.</p>

        <p class="normalbefore">When the <code>Date</code> function is called the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>numberOfArgs</i> be the number of arguments passed to this function call.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numberOfArgs</i> = 0.</li>
          <li>If NewTarget is not <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>O</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
                  <code>"%DatePrototype%"</code>, &laquo;&zwj; [[DateValue]]&raquo;).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
              <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i> to
                  the <a href="#sec-time-values-and-time-range">time value</a> (UTC) identifying the current time.</li>
              <li>Return <i>O</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>now</i> be the Number that is the <a href="#sec-time-values-and-time-range">time value</a> (UTC)
                  identifying the current time.</li>
              <li>Return <a href="#sec-todatestring">ToDateString</a> (<i>now</i>).</li>
            </ol>
          </li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-date-constructor">
      <div class="front">
        <h3 id="sec-20.3.3" title="20.3.3"> Properties of the Date Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Date
        constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is <code>7</code>), the Date constructor has the following
        properties:</p>
      </div>

      <section id="sec-date.now">
        <h4 id="sec-20.3.3.1" title="20.3.3.1">
            Date.now ( )</h4><p>The <code>now</code> function returns a Number value that is the <a href="#sec-time-values-and-time-range">time
        value</a> designating the UTC date and time of the occurrence of the call to <code>now</code>.</p>
      </section>

      <section id="sec-date.parse">
        <h4 id="sec-20.3.3.2" title="20.3.3.2">
            Date.parse ( string )</h4><p>The <code>parse</code> function applies the <a href="sec-abstract-operations#sec-tostring">ToString</a> operator to its argument. If <a href="sec-abstract-operations#sec-tostring">ToString</a> results in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>
        the <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a> is immediately returned. Otherwise,
        <code>parse</code> interprets the resulting String as a date and time; it returns a Number, the UTC <a href="#sec-time-values-and-time-range">time value</a> corresponding to the date and time. The String may be interpreted as
        a local time, a UTC time, or a time in some other time zone, depending on the contents of the String. The function first
        attempts to parse the format of the String according to the rules (including extended years) called out in Date Time
        String Format (<a href="#sec-date-time-string-format">20.3.1.16</a>). If the String does not conform to that format the
        function may fall back to any implementation-specific heuristics or implementation-specific date formats. Unrecognizable
        Strings or dates containing illegal element values in the format String shall cause <code>Date.parse</code> to return
        <b>NaN</b>.</p>

        <p>If <var>x</var> is any Date object whose milliseconds amount is zero within a particular implementation of ECMAScript,
        then all of the following expressions should produce the same numeric value in that implementation, if all the properties
        referenced have their initial values:</p>

        <pre><i>x</i>.valueOf()</pre>
        <pre>Date.parse(<i>x</i>.toString())</pre>
        <pre>Date.parse(<i>x</i>.toUTCString())</pre>
        <pre>Date.parse(<i>x</i>.toISOString())</pre>

        <p>However, the expression</p>

        <pre>Date.parse(<i>x</i>.toLocaleString())</pre>

        <p>is not required to produce the same Number value as the preceding three expressions and, in general, the value produced
        by <code>Date.parse</code> is implementation-dependent when given any String value that does not conform to the Date Time
        String Format (<a href="#sec-date-time-string-format">20.3.1.16</a>) and that could not be produced in that implementation
        by the <code>toString</code> or <code>toUTCString</code> method.</p>
      </section>

      <section id="sec-date.prototype">
        <h4 id="sec-20.3.3.3" title="20.3.3.3">
            Date.prototype</h4><p>The initial value of <code>Date.prototype</code> is the intrinsic object %DatePrototype% (<a href="#sec-properties-of-the-date-prototype-object">20.3.4</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-date.utc">
        <h4 id="sec-20.3.3.4" title="20.3.3.4">
            Date.UTC ( year, month [ , date [ , hours [ , minutes [ , seconds [ , ms ] ] ] ] ] )</h4><p class="normalbefore">When the <code>UTC</code> function is called with fewer than two arguments, the behaviour is
        implementation-dependent. When the <code>UTC</code> function is called with two to seven arguments, it computes the date
        from <var>year</var>, <var>month</var> and (optionally) <var>date</var>, <var>hours</var>, <var>minutes</var>,
        <var>seconds</var> and <var>ms</var>. The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>y</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>year</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>y</i>).</li>
          <li>Let <i>m</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>month</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>m</i>).</li>
          <li>If <i>date</i> is supplied, let <i>dt</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>date</i>); else let <i>dt</i>
              be <b>1</b>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>dt</i>).</li>
          <li>If <i>hours</i> is supplied, let <i>h</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>hours</i>); else let <i>h</i>
              be <b>0</b>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>h</i>).</li>
          <li>If <i>minutes</i> is supplied, let <i>min</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>minutes</i>); else let
              <i>min</i> be <b>0</b>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>min</i>).</li>
          <li>If <i>seconds</i> is supplied, let <i>s</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>seconds</i>); else let
              <i>s</i> be <b>0</b>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>s</i>).</li>
          <li>If <i>ms</i> is supplied, let <i>milli</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>ms</i>); else let <i>milli</i>
              be <b>0</b>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>milli</i>).</li>
          <li>If&nbsp;<i>y</i>&nbsp;is&nbsp;not&nbsp;<b>NaN</b>&nbsp;and&nbsp;0&nbsp;&le;&nbsp;<a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>y</i>)&nbsp;&le;&nbsp;99, let <i>yr</i> be&nbsp;1900+<a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>y</i>); otherwise, let <i>yr</i> be <i>y</i>.</li>
          <li>Return <a href="#sec-timeclip">TimeClip</a>(<a href="#sec-makedate">MakeDate</a>(<a href="#sec-makeday">MakeDay</a>(<i>yr</i>, <i>m</i>, <i>dt</i>), <a href="#sec-maketime">MakeTime</a>(<i>h</i>,
              <i>min</i>, <i>s</i>, <i>milli</i>))).</li>
        </ol>

        <p>The <code>length</code> property of the <code>UTC</code> function is <b>7</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>UTC</code> function differs from the <code>Date</code> constructor in two
          ways: it returns a <a href="#sec-time-values-and-time-range">time value</a> as a Number, rather than creating a Date
          object, and it interprets the arguments in UTC rather than as local time.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-date-prototype-object">
      <div class="front">
        <h3 id="sec-20.3.4" title="20.3.4"> Properties of the Date Prototype Object</h3><p>The Date prototype object is the intrinsic object %DatePrototype%. The Date prototype object is itself an ordinary
        object. It is not a Date instance and does not have a [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Date
        prototype object is the intrinsic object %ObjectPrototype% (<a href="#sec-properties-of-the-date-prototype-object">20.3.4</a>).</p>

        <p>Unless explicitly defined otherwise, the methods of the Date prototype object defined below are not generic and the
        <b>this</b> value passed to them must be an object that has a [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> that has been initialized to a <a href="#sec-time-values-and-time-range">time value</a>.</p>

        <p class="normalbefore">The abstract operation <span style="font-family: Times New         Roman">thisTimeValue(<i>value</i>)</span> performs the following steps:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Object and <i>value</i> has a
              [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, then
            <ol class="block">
              <li>Return the value of <i>value&rsquo;s</i> [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            </ol>
          </li>
          <li>Throw a <b>TypeError</b> exception.</li>
        </ol>

        <p>In following descriptions of functions that are properties of the Date prototype object, the phrase &ldquo;this Date
        object&rdquo; refers to the object that is the <b>this</b> value for the invocation of the function. If the Type of the
        <b>this</b> value is not Object, a <span class="value">TypeError</span> exception is thrown. The phrase &ldquo;this <a href="#sec-time-values-and-time-range">time value</a>&rdquo; within the specification of a method refers to the result
        returned  by calling the abstract operation thisTimeValue with the <b>this</b> value of the method invocation passed as
        the argument.</p>
      </div>

      <section id="sec-date.prototype.constructor">
        <h4 id="sec-20.3.4.1" title="20.3.4.1"> Date.prototype.constructor</h4><p>The initial value of <code>Date.prototype.constructor</code> is the intrinsic object %Date%.</p>
      </section>

      <section id="sec-date.prototype.getdate">
        <h4 id="sec-20.3.4.2" title="20.3.4.2"> Date.prototype.getDate ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-date-number">DateFromTime</a>(<a href="#sec-localtime">LocalTime</a>(<i>t</i>)).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getday">
        <h4 id="sec-20.3.4.3" title="20.3.4.3"> Date.prototype.getDay ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-week-day">WeekDay</a>(<a href="#sec-localtime">LocalTime</a>(<i>t</i>)).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getfullyear">
        <h4 id="sec-20.3.4.4" title="20.3.4.4"> Date.prototype.getFullYear ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-year-number">YearFromTime</a>(<a href="#sec-localtime">LocalTime</a>(<i>t</i>)).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.gethours">
        <h4 id="sec-20.3.4.5" title="20.3.4.5"> Date.prototype.getHours ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-hours-minutes-second-and-milliseconds">HourFromTime</a>(<a href="#sec-localtime">LocalTime</a>(<i>t</i>)).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getmilliseconds">
        <h4 id="sec-20.3.4.6" title="20.3.4.6"> Date.prototype.getMilliseconds ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-hours-minutes-second-and-milliseconds">msFromTime</a>(<a href="#sec-localtime">LocalTime</a>(<i>t</i>)).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getminutes">
        <h4 id="sec-20.3.4.7" title="20.3.4.7"> Date.prototype.getMinutes ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-hours-minutes-second-and-milliseconds">MinFromTime</a>(<a href="#sec-localtime">LocalTime</a>(<i>t</i>)).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getmonth">
        <h4 id="sec-20.3.4.8" title="20.3.4.8"> Date.prototype.getMonth ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-month-number">MonthFromTime</a>(<a href="#sec-localtime">LocalTime</a>(<i>t</i>)).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getseconds">
        <h4 id="sec-20.3.4.9" title="20.3.4.9"> Date.prototype.getSeconds ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-hours-minutes-second-and-milliseconds">SecFromTime</a>(<a href="#sec-localtime">LocalTime</a>(<i>t</i>)).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.gettime">
        <h4 id="sec-20.3.4.10" title="20.3.4.10"> Date.prototype.getTime ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Return <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
        </ol>
      </section>

      <section id="sec-date.prototype.gettimezoneoffset">
        <h4 id="sec-20.3.4.11" title="20.3.4.11"> Date.prototype.getTimezoneOffset ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return (<i>t</i> &minus; <a href="#sec-localtime">LocalTime</a>(<i>t</i>)) / <a href="#sec-hours-minutes-second-and-milliseconds">msPerMinute</a>.</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getutcdate">
        <h4 id="sec-20.3.4.12" title="20.3.4.12"> Date.prototype.getUTCDate ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-date-number">DateFromTime</a>(<i>t</i>).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getutcday">
        <h4 id="sec-20.3.4.13" title="20.3.4.13"> Date.prototype.getUTCDay ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-week-day">WeekDay</a>(<i>t</i>).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getutcfullyear">
        <h4 id="sec-20.3.4.14" title="20.3.4.14"> Date.prototype.getUTCFullYear ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-year-number">YearFromTime</a>(<i>t</i>).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getutchours">
        <h4 id="sec-20.3.4.15" title="20.3.4.15"> Date.prototype.getUTCHours ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-hours-minutes-second-and-milliseconds">HourFromTime</a>(<i>t</i>).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getutcmilliseconds">
        <h4 id="sec-20.3.4.16" title="20.3.4.16"> Date.prototype.getUTCMilliseconds ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-hours-minutes-second-and-milliseconds">msFromTime</a>(<i>t</i>).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getutcminutes">
        <h4 id="sec-20.3.4.17" title="20.3.4.17"> Date.prototype.getUTCMinutes ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-hours-minutes-second-and-milliseconds">MinFromTime</a>(<i>t</i>).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getutcmonth">
        <h4 id="sec-20.3.4.18" title="20.3.4.18"> Date.prototype.getUTCMonth ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.getutcseconds">
        <h4 id="sec-20.3.4.19" title="20.3.4.19"> Date.prototype.getUTCSeconds ( )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, return <b>NaN</b>.</li>
          <li>Return <a href="#sec-hours-minutes-second-and-milliseconds">SecFromTime</a>(<i>t</i>).</li>
        </ol>
      </section>

      <section id="sec-date.prototype.setdate">
        <h4 id="sec-20.3.4.20" title="20.3.4.20"> Date.prototype.setDate ( date )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-localtime">LocalTime</a>(<a href="#sec-properties-of-the-date-prototype-object">this
              time value</a>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>dt</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>date</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>dt</i>).</li>
          <li>Let <i>newDate</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-makeday">MakeDay</a>(<a href="#sec-year-number">YearFromTime</a>(<i>t</i>), <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>),
              <i>dt</i>), <a href="#sec-day-number-and-time-within-day">TimeWithinDay</a>(<i>t</i>)).</li>
          <li>Let <i>u</i> be <a href="#sec-timeclip">TimeClip</a>(<a href="#sec-utc-t">UTC</a>(<i>newDate</i>)).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>u</i>.</li>
          <li>Return <i>u</i>.</li>
        </ol>
      </section>

      <section id="sec-date.prototype.setfullyear">
        <h4 id="sec-20.3.4.21" title="20.3.4.21"> Date.prototype.setFullYear ( year [ , month [ , date ] ] )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, let <i>t</i> be <b>+0</b>; otherwise, let <i>t</i> be <a href="#sec-localtime">LocalTime</a>(<i>t</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>y</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>year</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>y</i>).</li>
          <li>If <i>month</i> is not specified, let <i>m</i> be <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>);
              otherwise, let <i>m</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>month</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>m</i>).</li>
          <li>If <i>date</i> is not specified, let <i>dt</i> be <a href="#sec-date-number">DateFromTime</a>(<i>t</i>); otherwise,
              let <i>dt</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>date</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>dt</i>).</li>
          <li>Let <i>newDate</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-makeday">MakeDay</a>(<i>y</i>, <i>m</i>,
              <i>dt</i>), <a href="#sec-day-number-and-time-within-day">TimeWithinDay</a>(<i>t</i>)).</li>
          <li>Let <i>u</i> be <a href="#sec-timeclip">TimeClip</a>(<a href="#sec-utc-t">UTC</a>(<i>newDate</i>)).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>u</i>.</li>
          <li>Return <i>u</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>setFullYear</code> method is <b>3</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>month</var> is not specified, this method behaves as if <var>month</var> were
          specified with the value <code>getMonth()</code>. If <var>date</var> is not specified, it behaves as if <var>date</var>
          were specified with the value <code>getDate()</code>.</p>
        </div>
      </section>

      <section id="sec-date.prototype.sethours">
        <h4 id="sec-20.3.4.22" title="20.3.4.22"> Date.prototype.setHours ( hour [ , min [ , sec [ , ms ] ] ] )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-localtime">LocalTime</a>(<a href="#sec-properties-of-the-date-prototype-object">this
              time value</a>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>h</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>hour</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>h</i>).</li>
          <li>If <i>min</i> is not specified, let <i>m</i> be <a href="#sec-hours-minutes-second-and-milliseconds">MinFromTime</a>(<i>t</i>); otherwise, let <i>m</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>min</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>m</i>).</li>
          <li>If <i>sec</i> is not specified, let <i>s</i> be <a href="#sec-hours-minutes-second-and-milliseconds">SecFromTime</a>(<i>t</i>); otherwise, let <i>s</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>sec</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>s</i>).</li>
          <li>If <i>ms</i> is not specified, let <i>milli</i> be <a href="#sec-hours-minutes-second-and-milliseconds">msFromTime</a>(<i>t</i>); otherwise, let <i>milli</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>ms</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>milli</i>).</li>
          <li>Let <i>date</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>), <a href="#sec-maketime">MakeTime</a>(<i>h</i>,
              <i>m</i>, <i>s</i>, <i>milli</i>)).</li>
          <li>Let <i>u</i> be <a href="#sec-timeclip">TimeClip</a>(<a href="#sec-utc-t">UTC</a>(<i>date</i>)).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>u</i>.</li>
          <li>Return <i>u</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>setHours</code> method is <b>4</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>min</var> is not specified, this method behaves as if <var>min</var> were
          specified with the value <code>getMinutes()</code>. If <var>sec</var> is not specified, it behaves as if <var>sec</var>
          were specified with the value <code>getSeconds()</code>. If <var>ms</var> is not specified, it behaves as if
          <var>ms</var> were specified with the value <code>getMilliseconds()</code>.</p>
        </div>
      </section>

      <section id="sec-date.prototype.setmilliseconds">
        <h4 id="sec-20.3.4.23" title="20.3.4.23"> Date.prototype.setMilliseconds ( ms )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-localtime">LocalTime</a>(<a href="#sec-properties-of-the-date-prototype-object">this
              time value</a>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>ms</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>ms</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>ms</i>).</li>
          <li>Let <i>time</i> be <a href="#sec-maketime">MakeTime</a>(<a href="#sec-hours-minutes-second-and-milliseconds">HourFromTime</a>(<i>t</i>), <a href="#sec-hours-minutes-second-and-milliseconds">MinFromTime</a>(<i>t</i>), <a href="#sec-hours-minutes-second-and-milliseconds">SecFromTime</a>(<i>t</i>), <i>ms</i>).</li>
          <li>Let <i>u</i> be <a href="#sec-timeclip">TimeClip</a>(<a href="#sec-utc-t">UTC</a>(<a href="#sec-makedate">MakeDate</a>(<a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>),
              <i>time</i>))).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>u</i>.</li>
          <li>Return <i>u</i>.</li>
        </ol>
      </section>

      <section id="sec-date.prototype.setminutes">
        <h4 id="sec-20.3.4.24" title="20.3.4.24"> Date.prototype.setMinutes ( min [ , sec [ , ms ] ] )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-localtime">LocalTime</a>(<a href="#sec-properties-of-the-date-prototype-object">this
              time value</a>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>m</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>min</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>m</i>).</li>
          <li>If <i>sec</i> is not specified, let <i>s</i> be <a href="#sec-hours-minutes-second-and-milliseconds">SecFromTime</a>(<i>t</i>); otherwise, let <i>s</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>sec</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>s</i>).</li>
          <li>If <i>ms</i> is not specified, let <i>milli</i> be <a href="#sec-hours-minutes-second-and-milliseconds">msFromTime</a>(<i>t</i>); otherwise, let <i>milli</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>ms</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>milli</i>).</li>
          <li>Let <i>date</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>), <a href="#sec-maketime">MakeTime</a>(<a href="#sec-hours-minutes-second-and-milliseconds">HourFromTime</a>(<i>t</i>), <i>m</i>, <i>s</i>,
              <i>milli</i>)).</li>
          <li>Let <i>u</i> be <a href="#sec-timeclip">TimeClip</a>(<a href="#sec-utc-t">UTC</a>(<i>date</i>)).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>u</i>.</li>
          <li>Return <i>u</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>setMinutes</code> method is <b>3</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>sec</var> is not specified, this method behaves as if <var>sec</var> were
          specified with the value <code>getSeconds()</code>. If <var>ms</var> is not specified, this behaves as if <var>ms</var>
          were specified with the value <code>getMilliseconds()</code>.</p>
        </div>
      </section>

      <section id="sec-date.prototype.setmonth">
        <h4 id="sec-20.3.4.25" title="20.3.4.25"> Date.prototype.setMonth ( month [ , date ] )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-localtime">LocalTime</a>(<a href="#sec-properties-of-the-date-prototype-object">this
              time value</a>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>m</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>month</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>m</i>).</li>
          <li>If <i>date</i> is not specified, let <i>dt</i> be <a href="#sec-date-number">DateFromTime</a>(<i>t</i>); otherwise,
              let <i>dt</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>date</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>dt</i>).</li>
          <li>Let <i>newDate</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-makeday">MakeDay</a>(<a href="#sec-year-number">YearFromTime</a>(<i>t</i>), <i>m</i>, <i>dt</i>), <a href="#sec-day-number-and-time-within-day">TimeWithinDay</a>(<i>t</i>)).</li>
          <li>Let <i>u</i> be <a href="#sec-timeclip">TimeClip</a>(<a href="#sec-utc-t">UTC</a>(<i>newDate</i>)).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>u</i>.</li>
          <li>Return <i>u</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>setMonth</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>date</var> is not specified, this method behaves as if <var>date</var> were
          specified with the value <code>getDate()</code>.</p>
        </div>
      </section>

      <section id="sec-date.prototype.setseconds">
        <h4 id="sec-20.3.4.26" title="20.3.4.26"> Date.prototype.setSeconds ( sec [ , ms ] )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-localtime">LocalTime</a>(<a href="#sec-properties-of-the-date-prototype-object">this
              time value</a>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>s</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>sec</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>s</i>).</li>
          <li>If <i>ms</i> is not specified, let <i>milli</i> be <a href="#sec-hours-minutes-second-and-milliseconds">msFromTime</a>(<i>t</i>); otherwise, let <i>milli</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>ms</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>milli</i>).</li>
          <li>Let <i>date</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>), <a href="#sec-maketime">MakeTime</a>(<a href="#sec-hours-minutes-second-and-milliseconds">HourFromTime</a>(<i>t</i>), <a href="#sec-hours-minutes-second-and-milliseconds">MinFromTime</a>(<i>t</i>), <i>s</i>, <i>milli</i>)).</li>
          <li>Let <i>u</i> be <a href="#sec-timeclip">TimeClip</a>(<a href="#sec-utc-t">UTC</a>(<i>date</i>)).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>u</i>.</li>
          <li>Return <i>u</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>setSeconds</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>ms</var> is not specified, this method behaves as if <var>ms</var> were
          specified with the value <code>getMilliseconds()</code>.</p>
        </div>
      </section>

      <section id="sec-date.prototype.settime">
        <h4 id="sec-20.3.4.27" title="20.3.4.27"> Date.prototype.setTime ( time )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>valueNotUsed</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>valueNotUsed</i>).</li>
          <li>Let <i>t</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>time</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>v</i> be <a href="#sec-timeclip">TimeClip</a>(<i>t</i>).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>v</i>.</li>
          <li>Return <i>v</i>.</li>
        </ol>
      </section>

      <section id="sec-date.prototype.setutcdate">
        <h4 id="sec-20.3.4.28" title="20.3.4.28"> Date.prototype.setUTCDate ( date )</h4><ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>dt</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>date</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>dt</i>).</li>
          <li>Let <i>newDate</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-makeday">MakeDay</a>(<a href="#sec-year-number">YearFromTime</a>(<i>t</i>), <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>),
              <i>dt</i>), <a href="#sec-day-number-and-time-within-day">TimeWithinDay</a>(<i>t</i>)).</li>
          <li>Let <i>v</i> be <a href="#sec-timeclip">TimeClip</a>(<i>newDate</i>).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>v</i>.</li>
          <li>Return <i>v</i>.</li>
        </ol>
      </section>

      <section id="sec-date.prototype.setutcfullyear">
        <h4 id="sec-20.3.4.29" title="20.3.4.29"> Date.prototype.setUTCFullYear ( year [ , month [ , date ] ] )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>If <i>t</i> is <b>NaN</b>, let <i>t</i> be <b>+0</b>.</li>
          <li>Let <i>y</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>year</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>y</i>).</li>
          <li>If <i>month</i> is not specified, let <i>m</i> be <a href="#sec-month-number">MonthFromTime</a>(<i>t</i>);
              otherwise, let <i>m</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>month</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>m</i>).</li>
          <li>If <i>date</i> is not specified, let <i>dt</i> be <a href="#sec-date-number">DateFromTime</a>(<i>t</i>); otherwise,
              let <i>dt</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>date</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>dt</i>).</li>
          <li>Let <i>newDate</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-makeday">MakeDay</a>(<i>y</i>, <i>m</i>,
              <i>dt</i>), <a href="#sec-day-number-and-time-within-day">TimeWithinDay</a>(<i>t</i>)).</li>
          <li>Let <i>v</i> be <a href="#sec-timeclip">TimeClip</a>(<i>newDate</i>).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>v</i>.</li>
          <li>Return <i>v</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>setUTCFullYear</code> method is <b>3</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>month</var> is not specified, this method behaves as if <var>month</var> were
          specified with the value <code>getUTCMonth()</code>. If <var>date</var> is not specified, it behaves as if
          <var>date</var> were specified with the value <code>getUTCDate()</code>.</p>
        </div>
      </section>

      <section id="sec-date.prototype.setutchours">
        <h4 id="sec-20.3.4.30" title="20.3.4.30"> Date.prototype.setUTCHours ( hour [ , min [ , sec [ , ms ] ] ]
            )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>h</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>hour</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>h</i>).</li>
          <li>If <i>min</i> is not specified, let <i>m</i> be <a href="#sec-hours-minutes-second-and-milliseconds">MinFromTime</a>(<i>t</i>); otherwise, let <i>m</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>min</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>m</i>).</li>
          <li>If <i>sec</i> is not specified, let <i>s</i> be <a href="#sec-hours-minutes-second-and-milliseconds">SecFromTime</a>(<i>t</i>); otherwise, let <i>s</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>sec</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>s</i>).</li>
          <li>If <i>ms</i> is not specified, let <i>milli</i> be <a href="#sec-hours-minutes-second-and-milliseconds">msFromTime</a>(<i>t</i>); otherwise, let <i>milli</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>ms</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>milli</i>).</li>
          <li>Let <i>newDate</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>), <a href="#sec-maketime">MakeTime</a>(<i>h</i>,
              <i>m</i>, <i>s</i>, <i>milli</i>)).</li>
          <li>Let <i>v</i> be <a href="#sec-timeclip">TimeClip</a>(<i>newDate</i>).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>v</i>.</li>
          <li>Return <i>v</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>setUTCHours</code> method is <b>4</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>min</var> is not specified, this method behaves as if <var>min</var> were
          specified with the value <code>getUTCMinutes()</code>. If <var>sec</var> is not specified, it behaves as if
          <var>sec</var> were specified with the value <code>getUTCSeconds()</code>. If <var>ms</var> is not specified, it behaves
          as if <var>ms</var> were specified with the value <code>getUTCMilliseconds()</code>.</p>
        </div>
      </section>

      <section id="sec-date.prototype.setutcmilliseconds">
        <h4 id="sec-20.3.4.31" title="20.3.4.31"> Date.prototype.setUTCMilliseconds ( ms )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let  <i>milli</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>ms</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>milli</i>).</li>
          <li>Let <i>time</i> be <a href="#sec-maketime">MakeTime</a>(<a href="#sec-hours-minutes-second-and-milliseconds">HourFromTime</a>(<i>t</i>), <a href="#sec-hours-minutes-second-and-milliseconds">MinFromTime</a>(<i>t</i>), <a href="#sec-hours-minutes-second-and-milliseconds">SecFromTime</a>(<i>t</i>), <i>milli</i>).</li>
          <li>Let <i>v</i> be <a href="#sec-timeclip">TimeClip</a>(<a href="#sec-makedate">MakeDate</a>(<a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>), <i>time</i>)).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>v</i>.</li>
          <li>Return <i>v</i>.</li>
        </ol>
      </section>

      <section id="sec-date.prototype.setutcminutes">
        <h4 id="sec-20.3.4.32" title="20.3.4.32"> Date.prototype.setUTCMinutes ( min [ , sec [, ms ] ] )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>m</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>min</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>m</i>).</li>
          <li>If <i>sec</i> is not specified, let <i>s</i> be <a href="#sec-hours-minutes-second-and-milliseconds">SecFromTime</a>(<i>t</i>).</li>
          <li>Else
            <ol class="block">
              <li>Let <i>s</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>sec</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>s</i>).</li>
            </ol>
          </li>
          <li>If <i>ms</i> is not specified, let <i>milli</i> be <a href="#sec-hours-minutes-second-and-milliseconds">msFromTime</a>(<i>t</i>).</li>
          <li>Else
            <ol class="block">
              <li>Let <i>milli</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>ms</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>milli</i>).</li>
            </ol>
          </li>
          <li>Let <i>date</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>), <a href="#sec-maketime">MakeTime</a>(<a href="#sec-hours-minutes-second-and-milliseconds">HourFromTime</a>(<i>t</i>), <i>m</i>, <i>s</i>,
              <i>milli</i>)).</li>
          <li>Let <i>v</i> be <a href="#sec-timeclip">TimeClip</a>(<i>date</i>).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>v</i>.</li>
          <li>Return <i>v</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>setUTCMinutes</code> method is <b>3</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>sec</var> is not specified, this method behaves as if <var>sec</var> were
          specified with the value <code>getUTCSeconds()</code>. If <var>ms</var> is not specified, it function behaves as if
          <var>ms</var> were specified with the value return by <code>getUTCMilliseconds()</code>.</p>
        </div>
      </section>

      <section id="sec-date.prototype.setutcmonth">
        <h4 id="sec-20.3.4.33" title="20.3.4.33"> Date.prototype.setUTCMonth ( month [ , date ] )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>m</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>month</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>m</i>).</li>
          <li>If <i>date</i> is not specified, let <i>dt</i> be <a href="#sec-date-number">DateFromTime</a>(<i>t</i>).</li>
          <li>Else
            <ol class="block">
              <li>Let <i>dt</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>date</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>dt</i>).</li>
            </ol>
          </li>
          <li>Let <i>newDate</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-makeday">MakeDay</a>(<a href="#sec-year-number">YearFromTime</a>(<i>t</i>), <i>m</i>, <i>dt</i>), <a href="#sec-day-number-and-time-within-day">TimeWithinDay</a>(<i>t</i>)).</li>
          <li>Let <i>v</i> be <a href="#sec-timeclip">TimeClip</a>(<i>newDate</i>).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>v</i>.</li>
          <li>Return <i>v</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>setUTCMonth</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>date</var> is not specified, this method behaves as if <var>date</var> were
          specified with the value <code>getUTCDate()</code>.</p>
        </div>
      </section>

      <section id="sec-date.prototype.setutcseconds">
        <h4 id="sec-20.3.4.34" title="20.3.4.34"> Date.prototype.setUTCSeconds ( sec [ , ms ] )</h4><p class="normalbefore">The following steps are performed:</p>

        <ol class="proc">
          <li>Let <i>t</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>t</i>).</li>
          <li>Let <i>s</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>sec</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>s</i>).</li>
          <li>If <i>ms</i> is not specified, let <i>milli</i> be <a href="#sec-hours-minutes-second-and-milliseconds">msFromTime</a>(<i>t</i>).</li>
          <li>Else
            <ol class="block">
              <li>Let <i>milli</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>ms</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>milli</i>).</li>
            </ol>
          </li>
          <li>Let <i>date</i> be <a href="#sec-makedate">MakeDate</a>(<a href="#sec-day-number-and-time-within-day">Day</a>(<i>t</i>), <a href="#sec-maketime">MakeTime</a>(<a href="#sec-hours-minutes-second-and-milliseconds">HourFromTime</a>(<i>t</i>), <a href="#sec-hours-minutes-second-and-milliseconds">MinFromTime</a>(<i>t</i>), <i>s</i>, <i>milli</i>)).</li>
          <li>Let <i>v</i> be <a href="#sec-timeclip">TimeClip</a>(<i>date</i>).</li>
          <li>Set the [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of this Date
              object to <i>v</i>.</li>
          <li>Return <i>v</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>setUTCSeconds</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>ms</var> is not specified, this method behaves as if <var>ms</var> were
          specified with the value <code>getUTCMilliseconds()</code>.</p>
        </div>
      </section>

      <section id="sec-date.prototype.todatestring">
        <h4 id="sec-20.3.4.35" title="20.3.4.35"> Date.prototype.toDateString ( )</h4><p>This function returns a String value. The contents of the String are implementation-dependent, but are intended to
        represent the &ldquo;date&rdquo; portion of the Date in the current time zone in a convenient, human-readable form.</p>
      </section>

      <section id="sec-date.prototype.toisostring">
        <h4 id="sec-20.3.4.36" title="20.3.4.36"> Date.prototype.toISOString ( )</h4><p>This function returns a String value representing the instance in time corresponding to <a href="#sec-properties-of-the-date-prototype-object">this time value</a>. The format of the String is the Date Time string
        format defined in <a href="#sec-date-time-string-format">20.3.1.16</a>. All fields are present in the String. The time
        zone is always UTC, denoted by the suffix Z. If <a href="#sec-properties-of-the-date-prototype-object">this time value</a>
        is not a finite Number or if the year is not a value that can be represented in that format (if necessary using extended
        year format), a <b>RangeError</b> exception is thrown.</p>
      </section>

      <section id="sec-date.prototype.tojson">
        <h4 id="sec-20.3.4.37" title="20.3.4.37"> Date.prototype.toJSON ( key )</h4><p>This function provides a String representation of a Date object for use by <code><a href="sec-structured-data#sec-json.stringify">JSON.stringify</a></code> (<a href="sec-structured-data#sec-json.stringify">24.3.2</a>).</p>

        <p class="normalbefore">When the <code>toJSON</code> method is called with argument <var>key</var>, the following steps
        are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li>Let <i>tv</i> be <a href="sec-abstract-operations#sec-toprimitive">ToPrimitive</a>(<i>O</i>, hint Number).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>tv</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>tv</i>) is Number and <i>tv</i> is not finite, return
              <b>null</b>.</li>
          <li>Return <a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>O</i>, <code>"toISOString"</code>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The argument is ignored.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>toJSON</code> function is intentionally generic; it does not require that
          its <b>this</b> value be a Date object. Therefore, it can be transferred to other kinds of objects for use as a method.
          However, it does require that any such object have a <code>toISOString</code> method.</p>
        </div>
      </section>

      <section id="sec-date.prototype.tolocaledatestring">
        <h4 id="sec-20.3.4.38" title="20.3.4.38"> Date.prototype.toLocaleDateString ( [ reserved1 [ , reserved2 ] ]
            )</h4><p>An ECMAScript implementation that includes the ECMA-402 Internationalization API must implement the
        <code>Date.prototype.toLocaleDateString</code> method as specified in the ECMA-402 specification. If an ECMAScript
        implementation does not include the ECMA-402 API the following  specification of the <code>toLocaleDateString</code>
        method is used.</p>

        <p>This function returns a String value. The contents of the String are implementation-dependent, but are intended to
        represent the &ldquo;date&rdquo; portion of the Date in the current time zone in a convenient, human-readable form that
        corresponds to the conventions of the host environment&rsquo;s current locale.</p>

        <p>The meaning of the optional parameters to this method are defined in the ECMA-402 specification; implementations that
        do not include ECMA-402 support must not use those parameter positions for anything else.</p>

        <p>The <code>length</code> property of the <code>toLocaleDateString</code> method is <b>0</b>.</p>
      </section>

      <section id="sec-date.prototype.tolocalestring">
        <h4 id="sec-20.3.4.39" title="20.3.4.39"> Date.prototype.toLocaleString ( [ reserved1 [ , reserved2 ] ] )</h4><p>An ECMAScript implementation that includes the ECMA-402 Internationalization API must implement the
        <code>Date.prototype.toLocaleString</code> method as specified in the ECMA-402 specification. If an ECMAScript
        implementation does not include the ECMA-402 API the following  specification of the <code>toLocaleString</code> method is
        used.</p>

        <p>This function returns a String value. The contents of the String are implementation-dependent, but are intended to
        represent the Date in the current time zone in a convenient, human-readable form that corresponds to the conventions of
        the host environment&rsquo;s current locale.</p>

        <p>The meaning of the optional parameters to this method are defined in the ECMA-402 specification; implementations that
        do not include ECMA-402 support must not use those parameter positions for anything else.</p>

        <p>The <code>length</code> property of the <code>toLocaleString</code> method is <b>0</b>.</p>
      </section>

      <section id="sec-date.prototype.tolocaletimestring">
        <h4 id="sec-20.3.4.40" title="20.3.4.40"> Date.prototype.toLocaleTimeString ( [ reserved1 [ , reserved2 ] ]
            )</h4><p>An ECMAScript implementation that includes the ECMA-402 Internationalization API must implement the
        <code>Date.prototype.toLocaleTimeString</code> method as specified in the ECMA-402 specification. If an ECMAScript
        implementation does not include the ECMA-402 API the following  specification of the <code>toLocaleTimeString</code>
        method is used.</p>

        <p>This function returns a String value. The contents of the String are implementation-dependent, but are intended to
        represent the &ldquo;time&rdquo; portion of the Date in the current time zone in a convenient, human-readable form that
        corresponds to the conventions of the host environment&rsquo;s current locale.</p>

        <p>The meaning of the optional parameters to this method are defined in the ECMA-402 specification; implementations that
        do not include ECMA-402 support must not use those parameter positions for anything else.</p>

        <p>The <code>length</code> property of the <code>toLocaleTimeString</code> method is <b>0</b>.</p>
      </section>

      <section id="sec-date.prototype.tostring">
        <div class="front">
          <h4 id="sec-20.3.4.41" title="20.3.4.41"> Date.prototype.toString ( )</h4><p class="normalbefore">The following steps are performed:</p>

          <ol class="proc">
            <li>Let <i>O</i> be this Date object.</li>
            <li>If <i>O</i> does not have a [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                slot</a>, then
              <ol class="block">
                <li>Let <i>tv</i> be <b>NaN</b>.</li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Let <i>tv</i> be <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</li>
              </ol>
            </li>
            <li>Return <a href="#sec-todatestring">ToDateString</a>(<i>tv</i>).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE 1</span> For any Date object <span style="font-family: monospace"><i>d</i></span> whose
            milliseconds amount is zero, the result of <code><a href="#sec-date.parse">Date.parse</a>(<i>d</i>.toString())</code>
            is equal to <code><i>d</i>.valueOf()</code>. See <a href="#sec-date.parse">20.3.3.2</a>.</p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 2</span> The <code>toString</code> function is intentionally generic; it does not require
            that its <b>this</b> value be a Date object. Therefore, it can be transferred to other kinds of objects for use as a
            method.</p>
          </div>
        </div>

        <section id="sec-todatestring">
          <h5 id="sec-20.3.4.41.1" title="20.3.4.41.1"> Runtime Semantics: ToDateString(tv)</h5><p class="normalbefore">The following steps are performed:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>tv</i>) is Number.</li>
            <li>If <i>tv</i> is <b>NaN</b>, return <code>"Invalid Date"</code>.</li>
            <li>Return an implementation-dependent String value that represents <i>tv</i> as a date and time in the current time
                zone using a convenient, human-readable form.</li>
          </ol>
        </section>
      </section>

      <section id="sec-date.prototype.totimestring">
        <h4 id="sec-20.3.4.42" title="20.3.4.42"> Date.prototype.toTimeString ( )</h4><p>This function returns a String value. The contents of the String are implementation-dependent, but are intended to
        represent the &ldquo;time&rdquo; portion of the Date in the current time zone in a convenient, human-readable form.</p>
      </section>

      <section id="sec-date.prototype.toutcstring">
        <h4 id="sec-20.3.4.43" title="20.3.4.43"> Date.prototype.toUTCString ( )</h4><p>This function returns a String value. The contents of the String are implementation-dependent, but are intended to
        represent <a href="#sec-properties-of-the-date-prototype-object">this time value</a> in a convenient, human-readable form
        in UTC.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The intent is to produce a String representation of a date that is more readable than
          the format specified in <a href="#sec-date-time-string-format">20.3.1.16</a>. It is not essential that the chosen format
          be unambiguous or easily machine parsable. If an implementation does not have a preferred human-readable format it is
          recommended to use the format defined in <a href="#sec-date-time-string-format">20.3.1.16</a> but with a space rather
          than a <code><b>"</b>T<b>"</b></code> used to separate the date and time elements.</p>
        </div>
      </section>

      <section id="sec-date.prototype.valueof">
        <h4 id="sec-20.3.4.44" title="20.3.4.44"> Date.prototype.valueOf ( )</h4><p>The <code>valueOf</code> function returns a Number, which is <a href="#sec-properties-of-the-date-prototype-object">this time value</a>.</p>
      </section>

      <section id="sec-date.prototype-@@toprimitive">
        <h4 id="sec-20.3.4.45" title="20.3.4.45"> Date.prototype [ @@toPrimitive ] ( hint )</h4><p>This function is called by ECMAScript language operators to convert a Date object to a primitive value. The allowed
        values for <var>hint</var> are <code>"default"</code>,  <code>"number"</code>, and <code>"string"</code>. Date objects,
        are unique among built-in ECMAScript object in that they treat <code>"default"</code> as being equivalent to
        <code>"string"</code>,  All other built-in ECMAScript objects treat <code>"default"</code> as being equivalent to
        <code>"number"</code>.</p>

        <p class="normalbefore">When the <code>@@toPrimitive</code> method is called with argument <var>hint</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value<b>.</b></li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>hint</i> is the String value "<code>string</code>" or the String value "<code>default</code>" , then
            <ol class="block">
              <li>Let <i>tryFirst</i> be "<code>string</code>".</li>
            </ol>
          </li>
          <li>Else if <i>hint</i> is the String value "<code>number</code>", then
            <ol class="block">
              <li>Let <i>tryFirst</i> be "<code>number</code>".</li>
            </ol>
          </li>
          <li>Else, throw a <b>TypeError</b> exception.</li>
          <li>Return OrdinaryToPrimitive(<i>O</i>, <i>tryFirst</i>).</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"[Symbol.toPrimitive]"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-date-instances">
      <h3 id="sec-20.3.5" title="20.3.5"> Properties of Date Instances</h3><p>Date instances are ordinary objects that inherit properties from the Date prototype object. Date instances also have a
      [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>. The [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is the <a href="#sec-time-values-and-time-range">time value</a> represented by this Date object.</p>
    </section>
  </section>
</section>

