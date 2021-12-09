<section id="sec-text-processing">
  <div class="front">
    <h1 id="sec-21" title="21"> Text
        Processing</h1></div>

  <section id="sec-string-objects">
    <div class="front">
      <h2 id="sec-21.1" title="21.1"> String
          Objects</h2></div>

    <section id="sec-string-constructor">
      <div class="front">
        <h3 id="sec-21.1.1" title="21.1.1">
            The String Constructor</h3><p>The String constructor is the %String% intrinsic object and the initial value of the <code>String</code> property of
        the global object. When called as a constructor it creates and initializes a new String object. When <code>String</code>
        is called as a function rather than as a constructor, it performs a type conversion.</p>

        <p>The <code>String</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>String</code> behaviour must include a <code>super</code> call to the <code>String</code> constructor to create and
        initialize the subclass instance with a [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
        slot</a>.</p>
      </div>

      <section id="sec-string-constructor-string-value">
        <h4 id="sec-21.1.1.1" title="21.1.1.1"> String ( value )</h4><p class="normalbefore">When <code>String</code> is called with argument <var>value</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>If no arguments were passed to this function invocation, let <i>s</i> be <code>""</code>.</li>
          <li>Else,
            <ol class="block">
              <li>If NewTarget is <b>undefined</b> and <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is
                  Symbol, return <a href="sec-fundamental-objects#sec-symboldescriptivestring">SymbolDescriptiveString</a>(<i>value</i>).</li>
              <li>Let <i>s</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>value</i>).</li>
            </ol>
          </li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>s</i>).</li>
          <li>If NewTarget is <b>undefined</b><i>,</i> return <i>s</i>.</li>
          <li>Return <a href="sec-ordinary-and-exotic-objects-behaviours#sec-stringcreate">StringCreate</a>(<i>s</i>, <a href="sec-ordinary-and-exotic-objects-behaviours#sec-getprototypefromconstructor">GetPrototypeFromConstructor</a>(NewTarget,
              <code>"%StringPrototype%"</code>)).</li>
        </ol>

        <p>The <code>length</code> property of the <code>String</code> function is <b>1</b>.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-string-constructor">
      <div class="front">
        <h3 id="sec-21.1.2" title="21.1.2"> Properties of the String Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        String constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is <b>1</b>), the String constructor has the following
        properties:</p>
      </div>

      <section id="sec-string.fromcharcode">
        <h4 id="sec-21.1.2.1" title="21.1.2.1"> String.fromCharCode ( ...codeUnits )</h4><p class="normalbefore">The <code>String.fromCharCode</code> function may be called with any number of arguments which
        form the rest parameter <var>codeUnits</var>. The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>codeUnits</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the arguments passed
              to this function.</li>
          <li>Let <i>length</i> be the number of elements in <i>codeUnits</i><b>.</b></li>
          <li>Let <i>elements</i> be  a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>nextIndex</i> be 0.</li>
          <li>Repeat while <i>nextIndex</i> &lt; <i>length</i>
            <ol class="block">
              <li>Let <i>next</i> be <i>codeUnits</i>[<i>nextIndex</i>].</li>
              <li>Let <i>nextCU</i> be <a href="sec-abstract-operations#sec-touint16">ToUint16</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextCU</i>).</li>
              <li>Append <i>nextCU</i> to the end of <i>elements</i>.</li>
              <li>Let <i>nextIndex</i> be <i>nextIndex</i> + 1.</li>
            </ol>
          </li>
          <li>Return the String value whose elements are, in order, the elements in the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> <i>elements</i>. If <i>length</i> is 0, the empty string is
              returned.</li>
        </ol>

        <p>The <code>length</code> property of the <code>fromCharCode</code> function is <b>1</b>.</p>
      </section>

      <section id="sec-string.fromcodepoint">
        <h4 id="sec-21.1.2.2" title="21.1.2.2"> String.fromCodePoint ( ...codePoints )</h4><p class="normalbefore">The <code>String.fromCodePoint</code> function may be called with any number of arguments which
        form the rest parameter <var>codePoints</var>. The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>codePoints</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the arguments
              passed to this function.</li>
          <li>Let <i>length</i> be the number of elements in <i>codePoints</i><code>.</code></li>
          <li>Let <i>elements</i> be a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>nextIndex</i> be 0.</li>
          <li>Repeat while <i>nextIndex</i> &lt; <i>length</i>
            <ol class="block">
              <li>Let <i>next</i> be <i>codePoints</i>[<i>nextIndex</i>].</li>
              <li>Let <i>nextCP</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextCP</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>nextCP</i>, <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>nextCP</i>))
                  is <b>false</b>, throw a <b>RangeError</b> exception.</li>
              <li>If  <i>nextCP</i> &lt; 0 or <i>nextCP</i> &gt; 0x10FFFF, throw a <b>RangeError</b> exception.</li>
              <li>Append the elements of the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of <i>nextCP</i> to the end of <i>elements</i>.</li>
              <li>Let <i>nextIndex</i> be <i>nextIndex</i> + 1.</li>
            </ol>
          </li>
          <li>Return the String value whose elements are, in order, the elements in the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> <i>elements</i>. If <i>length</i> is 0, the empty string is
              returned.</li>
        </ol>

        <p>The <code>length</code> property of the <code>fromCodePoint</code> function is <b>1</b>.</p>
      </section>

      <section id="sec-string.prototype">
        <h4 id="sec-21.1.2.3" title="21.1.2.3"> String.prototype</h4><p>The initial value of <code>String.prototype</code> is the intrinsic object %StringPrototype% (<a href="#sec-properties-of-the-string-prototype-object">21.1.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-string.raw">
        <h4 id="sec-21.1.2.4" title="21.1.2.4">
            String.raw ( template , ...substitutions  )</h4><p class="normalbefore">The <code>String.raw</code> function may be called with a variable number of arguments. The first
        argument is <var>template</var> and the remainder of the arguments form the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> <var>substitutions</var>. The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>substitutions</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> consisting of all of the
              arguments passed to this function, starting with the second argument. If fewer than two arguments were passed, the
              <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> is empty.</li>
          <li>Let <i>numberOfSubstitutions</i> be the number of elements in <i>substitutions</i>.</li>
          <li>Let <i>cooked</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>template</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>cooked</i>).</li>
          <li>Let <i>raw</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>cooked</i>,
              <code>"raw"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>raw</i>).</li>
          <li>Let <i>literalSegments</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>raw</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>literalSegments</i>).</li>
          <li>If <i>literalSegments</i> &le; 0, return the empty string.</li>
          <li>Let <i>stringElements</i> be a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>nextIndex</i> be 0.</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>nextKey</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>nextIndex</i>).</li>
              <li>Let <i>nextSeg</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>raw</i>,
                  <i>nextKey</i>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextSeg</i>).</li>
              <li>Append in order the code unit elements of <i>nextSeg</i> to the end of <i>stringElements</i>.</li>
              <li>If <i>nextIndex</i> + 1 = <i>literalSegments</i>, then
                <ol class="block">
                  <li>Return the String value whose code units are, in order, the elements in the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> <i>stringElements</i>. If <i>stringElements</i> has
                      no elements, the empty string is returned.</li>
                </ol>
              </li>
              <li>If <i>nextIndex &lt; numberOfSubstitutions</i>, let <i>next</i> be <i>substitutions</i>[<i>nextIndex</i>].</li>
              <li>Else, let <i>next</i> be the empty String.</li>
              <li>Let <i>nextSub</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextSub</i>).</li>
              <li>Append in order the code unit elements of <i>nextSub</i> to the end of <i>stringElements</i>.</li>
              <li>Let <i>nextIndex</i> be <i>nextIndex</i> + 1.</li>
            </ol>
          </li>
        </ol>

        <p>The <code>length</code> property of the <code>raw</code> function is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> String.raw is intended for use as a tag function of a Tagged Template (<a href="sec-ecmascript-language-expressions#sec-tagged-templates">12.3.7</a>). When called as such, the first argument will be a well formed template object
          and the rest parameter will contain the substitution values.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-string-prototype-object">
      <div class="front">
        <h3 id="sec-21.1.3" title="21.1.3"> Properties of the String Prototype Object</h3><p>The String prototype object is the intrinsic object %StringPrototype%. The String prototype object is itself an
        ordinary object. It is not a String instance and does not have a [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        String prototype object is the intrinsic object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>).</p>

        <p>Unless explicitly stated otherwise, the methods of the String prototype object defined below are not generic and the
        <b>this</b> value passed to them must be either a String value or an object that has a [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> that has been initialized to a String value.</p>

        <p class="normalbefore">The abstract operation <span style="font-family: Times New         Roman">thisStringValue(<i>value</i>)</span> performs the following steps:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is String, return <i>value</i>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Object and <i>value</i> has a
              [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, then
            <ol class="block">
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>value</i>&rsquo;s [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is a String value.</li>
              <li>Return the value of <i>value&rsquo;s</i> [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            </ol>
          </li>
          <li>Throw a <b>TypeError</b> exception.</li>
        </ol>

        <p>The phrase &ldquo;this String value&rdquo; within the specification of a method refers to the result returned  by
        calling the abstract operation <span style="font-family: Times New Roman">thisStringValue</span> with the <b>this</b>
        value of the method invocation passed as the argument.</p>
      </div>

      <section id="sec-string.prototype.charat">
        <h4 id="sec-21.1.3.1" title="21.1.3.1"> String.prototype.charAt ( pos )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> Returns a single element String containing the code unit at index <var>pos</var> in
          the String value resulting from converting this object to a String. If there is no element at that index, the result is
          the empty String. The result is a String value, not a String object.</p>
        </div>

        <p class="NoteMore">If <var>pos</var> is a value of Number type that is an integer, then the result of
        <code>x.charAt(</code><var>pos</var><code>)</code> is equal to the result of
        <code>x.substring(</code><var>pos</var><code>,</code> <var>pos</var><code>+1)</code>.</p>

        <p class="normalbefore">When the <code>charAt</code> method is called with one argument <var>pos</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>position</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>pos</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>position</i>).</li>
          <li>Let <i>size</i> be the number of elements in <i>S</i>.</li>
          <li>If <i>position</i> &lt; 0 or <i>position</i> &ge; <i>size</i>, return the empty String.</li>
          <li>Return a String of length 1, containing one code unit from <i>S</i>, namely the code unit at index
              <i>position</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>charAt</code> function is intentionally generic; it does not require that
          its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.charcodeat">
        <h4 id="sec-21.1.3.2" title="21.1.3.2"> String.prototype.charCodeAt ( pos )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> Returns a Number (a nonnegative integer less than <span style="font-family: Times New           Roman">2<sup>16</sup></span>) that is the code unit value of the string element at index <var>pos</var> in the String
          resulting from converting this object to a String. If there is no element at that index, the result is <b>NaN</b>.</p>
        </div>

        <p class="normalbefore">When the <code>charCodeAt</code> method is called with one argument <var>pos</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>position</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>pos</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>position</i>).</li>
          <li>Let <i>size</i> be the number of elements in <i>S</i>.</li>
          <li>If <i>position</i> &lt; 0 or <i>position</i> &ge; <i>size</i>, return <b>NaN</b>.</li>
          <li>Return a value of Number type, whose value is the code unit value of the element at index <i>position</i> in the
              String <i>S</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>charCodeAt</code> function is intentionally generic; it does not require
          that its <b>this</b> value be a String object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.codepointat">
        <h4 id="sec-21.1.3.3" title="21.1.3.3"> String.prototype.codePointAt ( pos )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> Returns a nonnegative integer Number less than <span style="font-family: Times New           Roman">1114112 (0x110000</span>) that is the code point value of the UTF-16 encoded code point (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>) starting at the string element at index <var>pos</var> in
          the String resulting from converting this object to a String. If there is no element at that index, the result is <span class="value">undefined</span>. If a valid UTF-16 surrogate pair does not begin at <var>pos</var>, the result is the
          code unit at <var>pos</var>.</p>
        </div>

        <p class="normalbefore">When the <code>codePointAt</code> method is called with one argument <var>pos</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>position</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>pos</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>position</i>).</li>
          <li>Let <i>size</i> be the number of elements in <i>S</i>.</li>
          <li>If <i>position</i> &lt; 0 or <i>position</i> &ge; <i>size</i>, return <b>undefined</b>.</li>
          <li>Let <i>first</i> be the code unit value of the element at index <i>position</i> in the String <i>S</i>.</li>
          <li>If <i>first</i> &lt; 0xD800 or <i>first</i> &gt; 0xDBFF or <i>position</i>+1 = <i>size</i>, return
              <i>first</i>.</li>
          <li>Let <i>second</i> be the code unit value of the element at index <i>position</i>+1 in the String <i>S</i>.</li>
          <li>If <i>second</i> &lt; 0xDC00 or <i>second</i> &gt; 0xDFFF, return <i>first</i>.</li>
          <li>Return <a href="sec-ecmascript-language-source-code#sec-utf16decode">UTF16Decode</a>(<i>first</i>, <i>second</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>codePointAt</code> function is intentionally generic; it does not require
          that its <b>this</b> value be a String object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.concat">
        <h4 id="sec-21.1.3.4" title="21.1.3.4"> String.prototype.concat ( ...args )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> When the <code>concat</code> method is called it returns a String consisting of the
          code units of the <code>this</code> object (converted to a String) followed by the code units of each of the arguments
          converted to a String. The result is a String value, not a String object.</p>
        </div>

        <p class="normalbefore">When the <code>concat</code> method is called with zero or more arguments the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>args</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose elements are the arguments
              passed to this function.</li>
          <li>Let <i>R</i> be <i>S</i>.</li>
          <li>Repeat, while <i>args</i> is not empty
            <ol class="block">
              <li>Remove the first element from <i>args</i> and let <i>next</i> be the value of that element.</li>
              <li>Let <i>nextString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextString</i>).</li>
              <li>Let <i>R</i> be the String value consisting of the code units of the previous value of <i>R</i> followed by the
                  code units of <i>nextString</i>.</li>
            </ol>
          </li>
          <li>Return <i>R</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>concat</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>concat</code> function is intentionally generic; it does not require that
          its <b>this</b> value be a String object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.constructor">
        <h4 id="sec-21.1.3.5" title="21.1.3.5"> String.prototype.constructor</h4><p>The initial value of <code>String.prototype.constructor</code> is the intrinsic object %String%.</p>
      </section>

      <section id="sec-string.prototype.endswith">
        <h4 id="sec-21.1.3.6" title="21.1.3.6"> String.prototype.endsWith ( searchString [ , endPosition] )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>isRegExp</i> be <a href="sec-abstract-operations#sec-isregexp">IsRegExp</a>(<i>searchString</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>isRegExp</i>).</li>
          <li>If <i>isRegExp</i> is <b>true</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>searchStr</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>searchString</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>searchStr</i>).</li>
          <li>Let <i>len</i> be the number of elements in <i>S</i>.</li>
          <li>If <i>endPosition</i> is <b>undefined</b>, let <i>pos</i> be <i>len</i>, else let <i>pos</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>endPosition</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>pos</i>).</li>
          <li>Let <i>end</i> be min(max(<i>pos</i>, 0), <i>len</i>).</li>
          <li>Let <i>searchLength</i> be the number of elements in <i>searchStr</i>.</li>
          <li>Let <i>start</i> be <i>end</i> - <i>searchLength</i>.</li>
          <li>If <i>start</i> is less than 0, return <b>false</b><i>.</i></li>
          <li>If the sequence of elements of <i>S</i> starting at <i>start</i> of length <i>searchLength</i> is the same as the
              full element sequence of <i>searchStr</i>, return <b>true</b>.</li>
          <li>Otherwise, return <b>false</b>.</li>
        </ol>

        <p>The <b>length</b> property of the <b>endsWith</b> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> Returns <b>true</b> if the sequence of elements of <i>searchString</i> converted to a
          String is the same as the corresponding elements of this object (converted to a String) starting at <i>endPosition</i>
          &ndash; length(this). Otherwise returns <b>false</b>.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> Throwing an exception if the first argument is a RegExp is specified in order to allow
          future editions to define extensions that allow such argument values.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> The <b>endsWith</b> function is intentionally generic; it does not require that its
          <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.includes">
        <h4 id="sec-21.1.3.7" title="21.1.3.7"> String.prototype.includes ( searchString [ , position ] )</h4><p class="normalbefore">The <code>includes</code> method takes two arguments, <i>searchString</i> and <i>position</i>, and
        performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>isRegExp</i> be  <a href="sec-abstract-operations#sec-isregexp">IsRegExp</a>(<i>searchString</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>isRegExp</i>).</li>
          <li>If <i>isRegExp</i> is <b>true</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>searchStr</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>searchString</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>searchStr</i>).</li>
          <li>Let <i>pos</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>position</i>). (If <i>position</i> is <b>undefined</b>,
              this step produces the value <b>0</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>pos</i>).</li>
          <li>Let <i>len</i> be the number of elements in <i>S</i>.</li>
          <li>Let <i>start</i> be min(max(<i>pos</i>, 0), <i>len</i>).</li>
          <li>Let <i>searchLen</i> be the number of elements in <i>searchStr</i>.</li>
          <li>If there exists any integer <i>k</i> not smaller than <i>start</i> such that <i>k</i> + <i>searchLen</i> is not
              greater than <i>len</i>, and for all nonnegative integers <i>j</i> less than <i>searchLen</i>, the code unit at
              index <i>k</i>+<i>j</i> of <i>S</i> is the same as the code unit at index <i>j</i> of <i>searchStr,</i> return
              <b>true</b>; but if there is no such integer <i>k</i>, return <b>false</b>.</li>
        </ol>

        <p>The <b>length</b> property of the <code>includes</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> If <var>searchString</var> appears as a substring of the result of converting this
          object to a String, at one or more indices that are greater than or equal to <i>position</i>, return <span class="value">true</span>; otherwise, returns <span class="value">false</span>. If <i>position</i> is <span class="value">undefined</span>, 0 is assumed, so as to search all of the String.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> Throwing an exception if the first argument is a RegExp is specified in order to allow
          future editions to define extensions that allow such argument values.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> The <code>includes</code> function is intentionally generic; it does not require that
          its <span class="value">this</span> value be a String object. Therefore, it can be transferred to other kinds of objects
          for use as a method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.indexof">
        <h4 id="sec-21.1.3.8" title="21.1.3.8"> String.prototype.indexOf ( searchString [ , position ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> If <var>searchString</var> appears as a substring of the result of converting this
          object to a String, at one or more indices that are greater than or equal to <var>position</var>, then the smallest such
          index is returned; otherwise, <code>&#x2011;1</code> is returned. If <var>position</var> is <b>undefined</b>, 0 is
          assumed, so as to search all of the String.</p>
        </div>

        <p class="normalbefore">The <code>indexOf</code> method takes two arguments, <var>searchString</var> and
        <var>position</var>, and performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>searchStr</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>searchString</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>searchStr</i>).</li>
          <li>Let <i>pos</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>position</i>). (If <i>position</i> is <b>undefined</b>,
              this step produces the value <code>0</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>pos</i>).</li>
          <li>Let <i>len</i> be the number of elements in <i>S</i>.</li>
          <li>Let <i>start</i> be min(max(<i>pos</i>, 0), <i>len</i>).</li>
          <li>Let <i>searchLen</i> be the number of elements in <i>searchStr</i>.</li>
          <li>Return the smallest possible integer <i>k</i> not smaller than <i>start</i> such that <i>k</i>+ <i>searchLen</i> is
              not greater than <i>len</i>, and for all nonnegative integers <i>j</i> less than <i>searchLen</i>, the code unit at
              index <i>k</i>+<i>j</i> of <i>S</i> is the same as the code unit at index <i>j</i> of <i>searchStr</i>; but if there
              is no such integer <i>k</i>, return the value <code>-1</code><span style="font-family: sans-serif">.</span></li>
        </ol>

        <p>The <code>length</code> property of the <code>indexOf</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>indexOf</code> function is intentionally generic; it does not require that
          its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.lastindexof">
        <h4 id="sec-21.1.3.9" title="21.1.3.9"> String.prototype.lastIndexOf ( searchString [ , position ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> If <var>searchString</var> appears as a substring of the result of converting this
          object to a String at one or more indices that are smaller than or equal to <var>position</var>, then the greatest such
          index is returned; otherwise, <code>&#x2011;1</code> is returned. If <var>position</var> is <b>undefined</b>, the length
          of the String value is assumed, so as to search all of the String.</p>
        </div>

        <p class="normalbefore">The <code>lastIndexOf</code> method takes two arguments, <var>searchString</var> and
        <var>position</var>, and performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>searchStr</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>searchString</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>searchString</i>).</li>
          <li>Let <i>numPos</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>position</i>). (If <i>position</i> is <b>undefined</b>,
              this step produces the value <b>NaN</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>numPos</i>).</li>
          <li>If <i>numPos</i> is <b>NaN</b>, let <i>pos</i> be <b>+&infin;</b>; otherwise, let <i>pos</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>numPos</i>).</li>
          <li>Let <i>len</i> be the number of elements in <i>S</i>.</li>
          <li>Let <i>start</i> be min(max(<i>pos</i>, 0), <i>len</i>).</li>
          <li>Let <i>searchLen</i> be the number of elements in <i>searchStr</i>.</li>
          <li>Return the largest possible nonnegative integer <i>k</i> not larger than <i>start</i> such that <i>k</i>+
              <i>searchLen</i> is not greater than <i>len</i>, and for all nonnegative integers <i>j</i> less than
              <i>searchLen</i>, the code unit at index <i>k</i>+<i>j</i> of <i>S</i> is the same as the code unit at index
              <i>j</i> of <i>searchStr</i>; but if there is no such integer <i>k</i>, return the value <code>-1</code>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>lastIndexOf</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>lastIndexOf</code> function is intentionally generic; it does not require
          that its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.localecompare">
        <h4 id="sec-21.1.3.10" title="21.1.3.10"> String.prototype.localeCompare ( that [, reserved1 [ , reserved2 ] ]
            )</h4><p>An ECMAScript implementation that includes the ECMA-402 Internationalization API must implement the
        <code>localeCompare</code> method as specified in the ECMA-402 specification. If an ECMAScript implementation does not
        include the ECMA-402 API the following  specification of the <code>localeCompare</code> method is used.</p>

        <p>When the <code>localeCompare</code> method is called with argument <var>that</var>, it returns a Number other than
        <b>NaN</b> that represents the result of a locale-sensitive String comparison of the <b>this</b> value (converted to a
        String) with <var>that</var> (converted to a String). The two Strings are <var>S</var> and <span class="nt">That</span>.
        The two Strings are compared in an implementation-defined fashion. The result is intended to order String values in the
        sort order specified by a host default locale, and will be negative, zero, or positive, depending on whether <var>S</var>
        comes before <span class="nt">That</span> in the sort order, the Strings are equal, or <var>S</var> comes after <span class="nt">That</span> in the sort order, respectively.</p>

        <p class="normalbefore">Before performing the comparisons, the following steps are performed to prepare the Strings:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>That</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>that</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>That</i>).</li>
        </ol>

        <p>The meaning of the optional second and third parameters to this method are defined in the ECMA-402 specification;
        implementations that do not include ECMA-402 support must not assign any other interpretation to those parameter
        positions.</p>

        <p>The <code>localeCompare</code> method, if considered as a function of two arguments <b>this</b> and <var>that</var>, is
        a consistent comparison function (as defined in <a href="sec-indexed-collections#sec-array.prototype.sort">22.1.3.24</a>) on the set of all
        Strings.</p>

        <p>The actual return values are implementation-defined to permit implementers to encode additional information in the
        value, but the function is required to define a total ordering on all Strings. This function must treat Strings that are
        canonically equivalent according to the Unicode standard as identical and must return <code>0</code> when comparing
        Strings that are considered canonically equivalent.</p>

        <p>The <code>length</code> property of the <code>localeCompare</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The <code>localeCompare</code> method itself is not directly suitable as an argument
          to <code><a href="sec-indexed-collections#sec-array.prototype.sort">Array.prototype.sort</a></code> because the latter requires a function of
          two arguments.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> This function is intended to rely on whatever language-sensitive comparison
          functionality is available to the ECMAScript environment from the host environment, and to compare according to the
          rules of the host environment&rsquo;s current locale. However, regardless of the host provided comparison capabilities,
          this function must treat Strings that are canonically equivalent according to the Unicode standard as identical. It is
          recommended that this function should not honour Unicode compatibility equivalences or decompositions. For a definition
          and discussion of canonical equivalence see the Unicode Standard, chapters 2 and 3, as well as Unicode Standard Annex
          #15, Unicode Normalization Forms (<a href="http://www.unicode.org/reports/tr15/">http://www.unicode.org/reports/tr15/</a>) and Unicode Technical Note #5,
          Canonical Equivalence in Applications (<a href="http://www.unicode.org/notes/tn5/">http://www.unicode.org/notes/tn5/</a>). Also see Unicode Technical Standard
          #10,  Unicode Collation Algorithm (<a href="http://www.unicode.org/reports/tr10/">http://www.unicode.org/reports/tr10/</a>).</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> The <code>localeCompare</code> function is intentionally generic; it does not require
          that its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.match">
        <h4 id="sec-21.1.3.11" title="21.1.3.11"> String.prototype.match ( regexp )</h4><p class="normalbefore">When the <code>match</code> method is called with argument <var>regexp</var>, the following steps
        are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>If <i>regexp</i> is neither <b>undefined</b> nor <b>null<i>,</i></b> then
            <ol class="block">
              <li>Let <i>matcher</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>regexp</i>, @@match).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>matcher</i>).</li>
              <li>If <i>matcher</i> is not <b>undefined</b>, then
                <ol class="block">
                  <li>Return  <a href="sec-abstract-operations#sec-call">Call</a>(<i>matcher</i>, <i>regexp</i>, &laquo;&zwj;<i>O</i>&raquo;).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>rx</i> be <a href="#sec-regexpcreate">RegExpCreate</a>(<i>regexp</i>, <b>undefined</b>) (<a href="#sec-regexpcreate">see 21.2.3.2.3</a>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rx</i>).</li>
          <li>Return <a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>rx</i>, @@match, &laquo;&zwj;<i>S</i>&raquo;).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>match</code> function is intentionally generic; it does not require that its
          <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.normalize">
        <h4 id="sec-21.1.3.12" title="21.1.3.12"> String.prototype.normalize ( [ form ] )</h4><p class="normalbefore">When the <code>normalize</code> method is called with one argument <var>form</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>If <i>form</i> is not provided or <i>form</i> is <b>undefined</b>, let <i>form</i> be
              <code><b>"</b>NFC<b>"</b></code>.</li>
          <li>Let <i>f</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>form</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>f</i>).</li>
          <li>If <i>f</i> is not one of <code><b>"</b>NFC<b>"</b></code>, <code><b>"</b>NFD<b>"</b></code>,
              <code><b>"</b>NFKC<b>"</b></code>, or <code><b>"</b>NFKD<b>"</b></code>, throw a <b>RangeError</b> exception.</li>
          <li>Let <i>ns</i> be the String value that is the result of normalizing <i>S</i> into the normalization form named by
              <i>f</i> as specified in <a href="http://www.unicode.org/reports/tr15/tr15-29.html">http://www.unicode.org/reports/tr15/tr15-29.html</a>.</li>
          <li>Return <i>ns</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>normalize</code> method is <b>0</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>normalize</code> function is intentionally generic; it does not require that
          its <b>this</b> value be a String object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.repeat">
        <h4 id="sec-21.1.3.13" title="21.1.3.13"> String.prototype.repeat ( count )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>n</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>count</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>n</i>).</li>
          <li>If <i>n</i> &lt; 0, throw a <b>RangeError</b> exception.</li>
          <li>If <i>n</i> is  +&infin;, throw a <b>RangeError</b> exception.</li>
          <li>Let <i>T</i> be a String value that is made from <i>n</i> copies of <i>S</i> appended together. If <i>n</i> is 0,
              <i>T</i> is the empty String.</li>
          <li>Return <i>T</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 1</span> This method creates a String consisting of the code units of the <code>this</code>
          object (converted to String) repeated <var>count</var> times.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>repeat</code> function is intentionally generic; it does not require that
          its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.replace">
        <div class="front">
          <h4 id="sec-21.1.3.14" title="21.1.3.14"> String.prototype.replace (searchValue, replaceValue )</h4><p class="normalbefore">When the <code>replace</code> method is called with arguments <var>searchValue</var> and
          <var>replaceValue</var> the following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
            <li>If <i>searchValue</i> is neither <b>undefined</b> nor <b>null<i>,</i></b> then
              <ol class="block">
                <li>Let <i>replacer</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>searchValue</i>, @@replace).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>replacer</i>).</li>
                <li>If <i>replacer</i> is not <b>undefined</b>, then
                  <ol class="block">
                    <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>replacer</i>, <i>searchValue</i>, &laquo;<i>O</i>,
                        <i>replaceValue</i>&raquo;).</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Let <i>string</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>string</i>).</li>
            <li>Let <i>searchString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>searchValue</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>searchString</i>).</li>
            <li>Let <i>functionalReplace</i> be <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>replaceValue</i>).</li>
            <li>If <i>functionalReplace</i> is <b>false</b>, then
              <ol class="block">
                <li>Let <i>replaceValue</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>replaceValue</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>replaceValue</i>).</li>
              </ol>
            </li>
            <li>Search <i>string</i> for the first occurrence of <i>searchString</i> and let <i>pos</i> be the index within
                <i>string</i> of the first code unit of the matched substring and let <i>matched</i> be <i>searchString</i>. If no
                occurrences of <i>searchString</i> were found, return <i>string</i>.</li>
            <li>If <i>functionalReplace</i> is <b>true</b>, then
              <ol class="block">
                <li>Let <i>replValue</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>replaceValue</i>,
                    <b>undefined</b>,&laquo;<i>matched</i>, <i>pos</i>, and <i>string</i>&raquo;).</li>
                <li>Let <i>replStr</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>replValue</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>replStr</i>).</li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Let <i>captures</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
                <li>Let <i>replStr</i> be <a href="#sec-getsubstitution">GetSubstitution</a>(<i>matched</i>, <i>string</i>,
                    <i>pos</i>, <i>captures</i>, <i>replaceValue</i>).</li>
              </ol>
            </li>
            <li>Let <i>tailPos</i> be <i>pos</i> + the number of code units in <i>matched</i>.</li>
            <li>Let <i>newString</i> be the String formed by concatenating the first <i>pos</i> code units of <i>string</i>,
                <i>replStr</i>, and the trailing substring of <i>string</i> starting at index <i>tailPos</i>. If <i>pos</i> is 0,
                the first element of the concatenation will be the empty String.</li>
            <li>Return  <i>newString</i>.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> The <code>replace</code> function is intentionally generic; it does not require that
            its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
            method.</p>
          </div>
        </div>

        <section id="sec-getsubstitution">
          <h5 id="sec-21.1.3.14.1" title="21.1.3.14.1"> Runtime Semantics: GetSubstitution(matched, str, position,
              captures, replacement)</h5><p class="normalbefore">The abstract operation GetSubstitution performs the following steps:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>matched</i>) is String.</li>
            <li>Let <i>matchLength</i> be the number of code units in <i>matched</i>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>str</i>) is String.</li>
            <li>Let <i>stringLength</i> be the number of code units in <i>str</i>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>position</i> is a nonnegative integer.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>position</i> &le; <i>stringLength</i>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>captures</i> is a possibly empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of Strings.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(
                <i>replacement</i>) is String</li>
            <li>Let <i>tailPos</i> be <i>position</i> + <i>matchLength</i>.</li>
            <li>Let <i>m</i> be the number of elements in <i>captures</i>.</li>
            <li>Let <i>result</i> be a String value derived from <i>replacement</i> by copying code unit elements from
                <i>replacement</i> to <i>result</i> while performing replacements as specified in <a href="#table-45">Table
                45</a>. These <code>$</code> replacements are done left-to-right, and, once such a replacement is performed, the
                new replacement text is not subject to further replacements.</li>
            <li>Return <i>result</i>.</li>
          </ol>

          <figure>
            <figcaption><span id="table-45">Table 45</span> &mdash; Replacement Text Symbol Substitutions</figcaption>
            <table class="real-table">
              <tr>
                <th>Code units</th>
                <th>Unicode Characters</th>
                <th>Replacement text</th>
              </tr>
              <tr>
                <td>0x0024, 0x0024</td>
                <td><code>$$</code></td>
                <td><code>$</code></td>
              </tr>
              <tr>
                <td>0x0024, 0x0026</td>
                <td><code>$&amp;</code></td>
                <td><i>matched</i></td>
              </tr>
              <tr>
                <td>0x0024, 0x0060</td>
                <td><code>$`</code></td>
                <td>If <i>position</i> is 0, the replacement is the empty String. Otherwise  the replacement is the substring of <i>str</i> that starts at index 0 and whose last code unit is at index <i>position</i> -1.</td>
              </tr>
              <tr>
                <td>0x0024, 0x0027</td>
                <td><code>$'</code></td>
                <td>If <i>tailPos</i> &ge; <i>stringLength</i>, the replacement is the empty String. Otherwise  the replacement is the substring of <i>str</i> that starts at index <i>tailPos</i> and continues to the end of <i>str</i>.</td>
              </tr>
              <tr>
                <td>0x0024, N<br />Where<br />0x0031 &le; N &le; 0x0039</td>
                <td><code>$n</code> <span style="font-family: Times New Roman">where</span> <code><br />n</code> <span style="font-family: Times New Roman">is one of</span> <code>1 2 3 4 5 6 7 8 9</code> <span style="font-family: Times New Roman">and</span> <code>$n</code> <span style="font-family: Times New Roman">is not followed by a decimal digit</span></td>
                <td>The <i>n</i><sup>th</sup> element of <i>captures</i>, where <i>n</i> is a single digit in the range 1 to 9. If <i>n</i>&le;<i>m</i> and the <i>n</i><sup>th</sup> element of <i>captures</i> is <b>undefined</b>, use the empty String instead. If <i>n</i>&gt;<i>m</i>, the result is implementation-defined.</td>
              </tr>
              <tr>
                <td>0x0024, N, N<br />Where<br />0x0030 &le; N &le; 0x0039</td>
                <td><code>$nn</code> <span style="font-family: Times New Roman">where</span> <code><br />n</code> <span style="font-family: Times New Roman">is one of</span> <code>0 1 2 3 4 5 6 7 8 9</code></td>
                <td>The <i>nn</i><sup>th</sup> element of <i>captures</i>, where <i>nn</i> is a two-digit decimal number in the range 01 to 99. If <i>nn</i>&le;<i>m</i> and the <i>nn</i><sup>th</sup> element of <i>captures</i> is <b>undefined</b>, use the empty String instead. If <i>nn</i> is 00 or <i>nn</i>&gt;<i>m</i>, the result is implementation-defined.</td>
              </tr>
              <tr>
                <td>0x0024</td>
                <td><code>$</code> <span style="font-family: Times New Roman">in any context that does not match any of the above.</span></td>
                <td><code>$</code></td>
              </tr>
            </table>
          </figure>
        </section>
      </section>

      <section id="sec-string.prototype.search">
        <h4 id="sec-21.1.3.15" title="21.1.3.15"> String.prototype.search ( regexp )</h4><p class="normalbefore">When the search method is called with argument <var>regexp</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>If <i>regexp</i> is neither <b>undefined</b> nor <b>null<i>,</i></b> then
            <ol class="block">
              <li>Let <i>searcher</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>regexp</i>, @@search).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>searcher</i>).</li>
              <li>If <i>searcher</i> is not <b>undefined</b> , then
                <ol class="block">
                  <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>searcher</i>, <i>regexp</i>, &laquo;<i>O</i>&raquo;)</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>string</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>string</i>).</li>
          <li>Let <i>rx</i> be <a href="#sec-regexpcreate">RegExpCreate</a>(<i>regexp</i>, <b>undefined</b>) (<a href="#sec-regexpcreate">see 21.2.3.2.3</a>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rx</i>).</li>
          <li>Return <a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>rx</i>, @@search, &laquo;&zwj;<i>string</i>&raquo;).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>search</code> function is intentionally generic; it does not require that its
          <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.slice">
        <h4 id="sec-21.1.3.16" title="21.1.3.16"> String.prototype.slice ( start, end )</h4><p class="normalbefore">The <code>slice</code> method takes two arguments, <var>start</var> and <var>end</var>, and
        returns a substring of the result of converting this object to a String, starting from index <var>start</var> and running
        to, but not including, index <var>end</var> (or through the end of the String if <var>end</var> is <b>undefined</b>). If
        <var>start</var> is negative, it is treated as <span style="font-family: Times New         Roman"><i>sourceLength</i>+<i>start</i></span> where <var>sourceLength</var> is the length of the String. If
        <var>end</var> is negative, it is treated as <span style="font-family: Times New         Roman"><i>sourceLength</i>+<i>end</i></span> where <var>sourceLength</var> is the length of the String. The result is a
        String value, not a String object. The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>len</i> be the number of elements in <i>S</i>.</li>
          <li>Let <i>intStart</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>start</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>intStart</i>).</li>
          <li>If <i>end</i> is <b>undefined</b>, let <i>intEnd</i> be <i>len</i>; else let <i>intEnd</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>end</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>intEnd</i>).</li>
          <li>If  <i>intStart</i> &lt; 0, let <i>from</i> be max(<i>len</i> + <i>intStart</i>,0); otherwise let <i>from</i> be
              min(<i>intStart</i>, <i>len</i>).</li>
          <li>If <i>intEnd</i> &lt; 0, let <i>to</i> be max(<i>len</i> + <i>intEnd</i>,0); otherwise let <i>to</i> be
              min(<i>intEnd</i>, <i>len</i>).</li>
          <li>Let <i>span</i> be max(<i>to</i> &ndash; <i>from</i>,0).</li>
          <li>Return a String value containing <i>span</i> consecutive elements from <i>S</i> beginning with the element at index
              <i>from</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>slice</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>slice</code> function is intentionally generic; it does not require that its
          <b>this</b> value be a String object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.split">
        <div class="front">
          <h4 id="sec-21.1.3.17" title="21.1.3.17"> String.prototype.split ( separator, limit )</h4><p>Returns an Array object into which substrings of the result of converting this object to a String have been stored.
          The substrings are determined by searching from left to right for occurrences of <var>separator</var>; these occurrences
          are not part of any substring in the returned array, but serve to divide up the String value. The value of
          <var>separator</var> may be a String of any length or it may be an object, such as an RegExp, that has a @@split
          method.</p>

          <p>When the <code>split</code> method is called, the following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
            <li>If <i>separator</i> is neither <b>undefined</b> nor <b>null</b>, then
              <ol class="block">
                <li>Let <i>splitter</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>separator</i>, @@split).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>splitter</i>).</li>
                <li>If <i>splitter</i> is not <b>undefined</b> , then
                  <ol class="block">
                    <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>splitter</i>, <i>separator</i>, &laquo;&zwj;<i>O</i>,
                        <i>limit</i>&raquo;).</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
            <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0).</li>
            <li>Let <i>lengthA</i> be 0.</li>
            <li>If <i>limit</i> is <b>undefined</b>, let <i>lim</i> = 2<sup>53</sup>&ndash;1; else let <i>lim</i> = <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<i>limit</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lim</i>).</li>
            <li>Let <i>s</i> be the number of elements in <i>S</i>.</li>
            <li>Let <i>p</i> = 0.</li>
            <li>Let <i>R</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>separator</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>R</i>).</li>
            <li>If <i>lim</i> = 0, return <i>A</i>.</li>
            <li>If <i>separator</i> is <b>undefined</b>, then
              <ol class="block">
                <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <code>"<b>0</b>"</code>,
                    <i>S</i>).</li>
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The above call will never result in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                <li>Return <i>A</i>.</li>
              </ol>
            </li>
            <li>If <i>s</i> = 0, then
              <ol class="block">
                <li>Let <i>z</i> be <a href="#sec-splitmatch">SplitMatch</a>(<i>S</i>, 0, <i>R</i>).</li>
                <li>If <i>z</i> is not <b>false</b>, return <i>A</i>.</li>
                <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <code>"<b>0</b>"</code>,
                    <i>S</i>).</li>
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The above call will never result in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                <li>Return <i>A</i>.</li>
              </ol>
            </li>
            <li>Let <i>q</i> = <i>p</i>.</li>
            <li>Repeat, while <i>q</i> &ne; <i>s</i>
              <ol class="block">
                <li>Let <i>e</i> be <a href="#sec-splitmatch">SplitMatch</a>(<i>S, q, R</i>).</li>
                <li>If <i>e</i> is <b>false</b>, let <i>q</i> = <i>q</i>+1.</li>
                <li>Else  <i>e</i> is an integer index into <i>S</i>,
                  <ol class="block">
                    <li>If <i>e</i> = <i>p</i>, let <i>q</i> = <i>q</i>+1.</li>
                    <li>Else <i>e</i> &ne; <i>p</i>,
                      <ol class="block">
                        <li>Let <i>T</i> be a String value equal to the substring of <i>S</i> consisting of the code units at
                            indices <i>p</i> (inclusive) through <i>q</i> (exclusive).</li>
                        <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>lengthA</i>), <i>T</i>).</li>
                        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The above call will never result in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                        <li>Increment <i>lengthA</i> by 1.</li>
                        <li>If <i>lengthA</i> = <i>lim</i>, return <i>A</i>.</li>
                        <li>Let <i>p</i> = <i>e</i>.</li>
                        <li>Let <i>q</i> = <i>p</i>.</li>
                      </ol>
                    </li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Let <i>T</i> be a String value equal to the substring of <i>S</i> consisting of the code units at indices <i>p</i>
                (inclusive) through <i>s</i> (exclusive).</li>
            <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>lengthA</i>), <i>T</i>).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The above call will never result in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
            <li>Return <i>A</i>.</li>
          </ol>

          <p>The <code>length</code> property of the <code>split</code> method is <b>2</b>.</p>

          <div class="note">
            <p><span class="nh">NOTE 1</span> The value of <var>separator</var> may be an empty String, an empty regular
            expression, or a regular expression that can match an empty String. In this case, <var>separator</var> does not match
            the empty substring at the beginning or end of the input String, nor does it match the empty substring at the end of
            the previous separator match. (For example, if <var>separator</var> is the empty String, the String is split up into
            individual code unit elements; the length of the result array equals the length of the String, and each substring
            contains one code unit.) If <var>separator</var> is a regular expression, only the first match at a given index of the
            <b>this</b> String is considered, even if backtracking could yield a non-empty-substring match at that index. (For
            example, <code>"ab".split(/a*?/)</code> evaluates to the array <code>["a","b"]</code>, while
            <code>"ab".split(/a*/)</code> evaluates to the array<code>["","b"]</code>.)</p>

            <p>If the <b>this</b> object is (or converts to) the empty String, the result depends on whether <var>separator</var>
            can match the empty String. If it can, the result array contains no elements. Otherwise, the result array contains one
            element, which is the empty String.</p>

            <p>If <var>separator</var> is a regular expression that contains capturing parentheses, then each time
            <var>separator</var> is matched the results (including any <b>undefined</b> results) of the capturing parentheses are
            spliced into the output array. For&nbsp;example,</p>

            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code>"A&lt;B&gt;bold&lt;/B&gt;and&lt;CODE&gt;coded&lt;/CODE&gt;".split(/&lt;(\/)?([^&lt;&gt;]+)&gt;/)</code></p>

            <p>evaluates to the array:</p>

            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code>["A", undefined, "B", "bold", "/", "B", "and",
            undefined,<br /></code>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code>"CODE", "coded", "/", "CODE", ""]</code></p>

            <p>If <var>separator</var> is <span class="value">undefined</span>, then the result array contains just one String,
            which is the <b>this</b> value (converted to a String). If <var>limit</var> is not <span class="value">undefined</span>, then the output array is truncated so that it contains no more than <var>limit</var>
            elements.</p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 2</span> The <code>split</code> function is intentionally generic; it does not require that
            its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
            method.</p>
          </div>
        </div>

        <section id="sec-splitmatch">
          <h5 id="sec-21.1.3.17.1" title="21.1.3.17.1"> Runtime Semantics: SplitMatch ( S, q, R )</h5><p class="normalbefore">The abstract operation SplitMatch takes three parameters, a String <var>S</var>, an integer
          <var>q</var>, and a String <var>R</var>, and performs the following steps in order to return either <b>false</b> or the
          end index of a match:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is String.</li>
            <li>Let <i>r</i> be the number of code units in <i>R</i>.</li>
            <li>Let <i>s</i> be the number of code units in <i>S</i>.</li>
            <li>If <i>q</i>+<i>r</i> &gt; <i>s</i>, return <b>false</b>.</li>
            <li>If there exists an integer <i>i</i> between 0 (inclusive) and <i>r</i> (exclusive) such that the code unit at
                index <i>q</i>+<i>i</i> of <i>S</i> is different from the code unit at index <i>i</i> of <i>R</i>, return
                <b>false</b>.</li>
            <li>Return <i>q</i>+<i>r</i>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-string.prototype.startswith">
        <h4 id="sec-21.1.3.18" title="21.1.3.18"> String.prototype.startsWith ( searchString [, position ] )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>isRegExp</i> be  <a href="sec-abstract-operations#sec-isregexp">IsRegExp</a>(<i>searchString</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>isRegExp</i>).</li>
          <li>If <i>isRegExp</i> is <b>true</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>searchStr</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>searchString</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>searchString</i>).</li>
          <li>Let <i>pos</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>position</i>). (If <i>position</i> is <b>undefined</b>,
              this step produces the value <b>0</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>pos</i>).</li>
          <li>Let <i>len</i> be the number of elements in <i>S</i>.</li>
          <li>Let <i>start</i> be min(max(<i>pos</i>, 0), <i>len</i>).</li>
          <li>Let <i>searchLength</i> be the number of elements in <i>searchStr</i>.</li>
          <li>If <i>searchLength+start</i> is greater than <i>len</i>, return <b>false</b><i>.</i></li>
          <li>If the sequence of elements of <i>S</i> starting at <i>start</i> of length <i>searchLength</i> is the same as the
              full element sequence of <i>searchStr</i>, return <b>true</b>.</li>
          <li>Otherwise, return <b>false</b>.</li>
        </ol>

        <p>The <b>length</b> property of the <b>startsWith</b> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> This method returns <b>true</b> if the sequence of elements of <i>searchString</i>
          converted to a String is the same as the corresponding elements of this object (converted to a String) starting at index
          <i>position</i>. Otherwise returns <b>false</b>.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> Throwing an exception if the first argument is a RegExp is specified in order to allow
          future editions to define extensions that allow such argument values.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> The <b>startsWith</b> function is intentionally generic; it does not require that its
          <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.substring">
        <h4 id="sec-21.1.3.19" title="21.1.3.19"> String.prototype.substring ( start, end )</h4><p>The <b>substring</b> method takes two arguments, <var>start</var> and <var>end</var>, and returns a substring of the
        result of converting this object to a String, starting from index <var>start</var> and running to, but not including,
        index <var>end</var> of the String (or through the end of the String is <var>end</var> is <b>undefined</b>). The result is
        a String value, not a String object.</p>

        <p>If either argument is <b>NaN</b> or negative, it is replaced with zero; if either argument is larger than the length of
        the String, it is replaced with the length of the String.</p>

        <p>If <var>start</var> is larger than <var>end</var>, they are swapped.</p>

        <p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>len</i> be the number of elements in <i>S</i>.</li>
          <li>Let <i>intStart</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>start</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>intStart</i>).</li>
          <li>If <i>end</i> is <b>undefined</b>, let <i>intEnd</i> be <i>len</i>; else let <i>intEnd</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>end</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>intEnd</i>).</li>
          <li>Let <i>finalStart</i> be min(max(<i>intStart</i>, 0), <i>len</i>).</li>
          <li>Let <i>finalEnd</i> be min(max(<i>intEnd</i>, 0), <i>len</i>).</li>
          <li>Let <i>from</i> be min(<i>finalStart</i>, <i>finalEnd</i>).</li>
          <li>Let <i>to</i> be max(<i>finalStart</i>, <i>finalEnd</i>).</li>
          <li>Return a String whose length is <i>to</i> - <i>from</i>, containing code units from <i>S</i>, namely the code units
              with indices <i>from</i> through <i>to</i> &minus;1, in ascending order.</li>
        </ol>

        <p>The <code>length</code> property of the <code>substring</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>substring</code> function is intentionally generic; it does not require that
          its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.tolocalelowercase">
        <h4 id="sec-21.1.3.20" title="21.1.3.20"> String.prototype.toLocaleLowerCase ( [ reserved1 [ , reserved2 ] ]
            )</h4><p>An ECMAScript implementation that includes the ECMA-402 Internationalization API must implement the
        <code>toLocaleLowerCase</code> method as specified in the ECMA-402 specification. If an ECMAScript implementation does not
        include the ECMA-402 API the following  specification of the <code>toLocaleLowerCase</code> method is used.</p>

        <p>This function interprets a String value as a sequence of UTF-16 encoded code points, as described in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>.</p>

        <p>This function works exactly the same as <code>toLowerCase</code> except that its result is intended to yield the
        correct result for the host environment&rsquo;s current locale, rather than a locale-independent result. There will only
        be a difference in the few cases (such as Turkish) where the rules for that language conflict with the regular Unicode
        case mappings.</p>

        <p>The <b>length</b> property of the <b>toLocaleLowerCase</b> method is <b>0</b>.</p>

        <p>The meaning of the optional parameters to this method are defined in the ECMA-402 specification; implementations that
        do not include ECMA-402 support must not use those parameter positions for anything else.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>toLocaleLowerCase</code> function is intentionally generic; it does not
          require that its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for
          use as a method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.tolocaleuppercase">
        <h4 id="sec-21.1.3.21" title="21.1.3.21"> String.prototype.toLocaleUpperCase ([ reserved1 [ , reserved2 ] ]
            )</h4><p>An ECMAScript implementation that includes the ECMA-402 Internationalization API must implement the
        <code>toLocaleUpperCase</code> method as specified in the ECMA-402 specification. If an ECMAScript implementation does not
        include the ECMA-402 API the following  specification of the <code>toLocaleUpperCase</code> method is used.</p>

        <p>This function interprets a String value as a sequence of UTF-16 encoded code points, as described in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>.</p>

        <p>This function works exactly the same as <code>toUpperCase</code> except that its result is intended to yield the
        correct result for the host environment&rsquo;s current locale, rather than a locale-independent result. There will only
        be a difference in the few cases (such as Turkish) where the rules for that language conflict with the regular Unicode
        case mappings.</p>

        <p>The <b>length</b> property of the <b>toLocaleUpperCase</b> method is <b>0</b>.</p>

        <p>The meaning of the optional parameters to this method are defined in the ECMA-402 specification; implementations that
        do not include ECMA-402 support must not use those parameter positions for anything else.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>toLocaleUpperCase</code> function is intentionally generic; it does not
          require that its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for
          use as a method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.tolowercase">
        <h4 id="sec-21.1.3.22" title="21.1.3.22"> String.prototype.toLowerCase ( )</h4><p class="normalbefore">This function interprets a String value as a sequence of UTF-16 encoded code points, as described
        in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>. The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>cpList</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing in order the code
              points as defined in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a> of <i>S</i>, starting at the
              first element of <i>S</i>.</li>
          <li>For each code point <i>c</i> in <i>cpList</i>, if the Unicode Character Database provides a language insensitive
              lower case equivalent of <i>c</i> then replace <i>c</i> in <i>cpList</i> with that equivalent code point(s).</li>
          <li>Let <i>cuList</i> be a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>For each code point <i>c</i> in <i>cpList</i>, in order, append to <i>cuList</i> the elements of the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of <i>c</i>.</li>
          <li>Let <i>L</i> be a String whose elements are, in order, the elements of <i>cuList</i> .</li>
          <li>Return <i>L</i>.</li>
        </ol>

        <p class="normalBullet">The result must be derived according to the locale-insensitive case mappings in the Unicode
        Character Database (this explicitly includes not only the UnicodeData.txt file, but also all locale-insensitive mappings
        in the SpecialCasings.txt file that accompanies it).</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The case mapping of some code points may produce multiple code points . In this case
          the result String may not be the same length as the source String. Because both <code>toUpperCase</code> and
          <code>toLowerCase</code> have context-sensitive behaviour, the functions are not symmetrical. In other words,
          <code>s.toUpperCase().toLowerCase()</code> is not necessarily equal to <code>s.toLowerCase()</code>.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>toLowerCase</code> function is intentionally generic; it does not require
          that its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.tostring">
        <h4 id="sec-21.1.3.23" title="21.1.3.23"> String.prototype.toString ( )</h4><p class="normalbefore">When the <code>toString</code> method is called, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>s</i> be thisStringValue(<b>this</b> value).</li>
          <li>Return  <i>s</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> For a String object, the <code>toString</code> method happens to return the same thing
          as the <code>valueOf</code> method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.touppercase">
        <h4 id="sec-21.1.3.24" title="21.1.3.24"> String.prototype.toUpperCase ( )</h4><p>This function interprets a String value as a sequence of UTF-16 encoded code points, as described in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>.</p>

        <p>This function behaves in exactly the same way as <code><a href="#sec-string.prototype.tolowercase">String.prototype.toLowerCase</a></code>, except that code points are mapped to
        their <var>uppercase</var> equivalents as specified in the Unicode Character Database.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>toUpperCase</code> function is intentionally generic; it does not require that
          its <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.trim">
        <h4 id="sec-21.1.3.25" title="21.1.3.25"> String.prototype.trim ( )</h4><p>This function interprets a String value as a sequence of UTF-16 encoded code points, as described in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>.</p>

        <p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>T</i> be a String value that is a copy of <i>S</i> with both leading and trailing white space removed. The
              definition of white space is the union of <i>WhiteSpace</i> and <i>LineTerminator</i>. When determining whether a
              Unicode code point is in Unicode general category &ldquo;Zs&rdquo;, code unit sequences are interpreted as UTF-16
              encoded code point sequences as specified in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>.</li>
          <li>Return <i>T</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>trim</code> function is intentionally generic; it does not require that its
          <b>this</b> value be a String object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-string.prototype.valueof">
        <h4 id="sec-21.1.3.26" title="21.1.3.26"> String.prototype.valueOf ( )</h4><p class="normalbefore">When the <code>valueOf</code> method is called, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>s</i> be thisStringValue(<b>this</b> value).</li>
          <li>Return  <i>s</i>.</li>
        </ol>
      </section>

      <section id="sec-string.prototype-@@iterator">
        <h4 id="sec-21.1.3.27" title="21.1.3.27"> String.prototype [ @@iterator ]( )</h4><p class="normalbefore">When the @@iterator method is called it returns an Iterator object (<a href="sec-control-abstraction-objects#sec-iterator-interface">25.1.1.2</a>) that iterates over the code points of a String value, returning each code
        point as a String value. The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<b>this</b> value).</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Return <a href="#sec-createstringiterator">CreateStringIterator</a>(<i>S</i>).</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"[Symbol.iterator]"</code>.</p>
      </section>
    </section>

    <section id="sec-properties-of-string-instances">
      <div class="front">
        <h3 id="sec-21.1.4" title="21.1.4"> Properties of String Instances</h3><p>String instances are String exotic objects and have the internal methods specified for such objects. String instances
        inherit properties from the String prototype object. String instances also have a [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>String instances have a <code>length</code> property, and a set of enumerable properties with integer indexed
        names.</p>
      </div>

      <section id="sec-properties-of-string-instances-length">
        <h4 id="sec-21.1.4.1" title="21.1.4.1"> length</h4><p>The number of elements in the String value represented by this String object.</p>

        <p>Once a String object is initialized, this property is unchanging. It has the attributes { [[Writable]]: <b>false</b>,
        [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>false</b> }.</p>
      </section>
    </section>

    <section id="sec-string-iterator-objects">
      <div class="front">
        <h3 id="sec-21.1.5" title="21.1.5"> String Iterator Objects</h3><p>An String Iterator is an object, that represents a specific iteration over some specific String instance object. There
        is not a named constructor for String Iterator objects. Instead, String iterator objects are created by calling certain
        methods of String instance objects.</p>
      </div>

      <section id="sec-createstringiterator">
        <h4 id="sec-21.1.5.1" title="21.1.5.1"> CreateStringIterator Abstract Operation</h4><p class="normalbefore">Several methods of String objects return Iterator objects. The abstract operation
        CreateStringIterator with argument <var>string</var> is used to create such iterator objects. It performs the following
        steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>string</i>) is String.</li>
          <li>Let <i>iterator</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(%StringIteratorPrototype%,
              &laquo;[[IteratedString]], [[StringIteratorNextIndex]] &raquo;).</li>
          <li>Set <i>iterator&rsquo;s</i> [[IteratedString]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>string</i>.</li>
          <li>Set <i>iterator&rsquo;s</i> [[StringIteratorNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to 0.</li>
          <li>Return <i>iterator</i>.</li>
        </ol>
      </section>

      <section id="sec-%stringiteratorprototype%-object">
        <div class="front">
          <h4 id="sec-21.1.5.2" title="21.1.5.2"> The %StringIteratorPrototype% Object</h4><p>All String Iterator Objects inherit properties from the %StringIteratorPrototype% intrinsic object. The
          %StringIteratorPrototype% object is an ordinary object and its [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is the %IteratorPrototype% intrinsic object (<a href="sec-control-abstraction-objects#sec-%iteratorprototype%-object">25.1.2</a>). In addition, %StringIteratorPrototype% has the following
          properties:</p>
        </div>

        <section id="sec-%stringiteratorprototype%.next">
          <h5 id="sec-21.1.5.2.1" title="21.1.5.2.1"> %StringIteratorPrototype%.next ( )</h5><ol class="proc">
            <li>Let <i>O</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>If <i>O</i> does not have all of the internal slots of an String Iterator Instance (<a href="#sec-properties-of-string-iterator-instances">21.1.5.3</a>), throw a <b>TypeError</b> exception.</li>
            <li>Let <i>s</i> be the value of the [[IteratedString]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
            <li>If <i>s</i> is <b>undefined</b>, return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>true</b>).</li>
            <li>Let <i>position</i> be the value of the [[StringIteratorNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
            <li>Let <i>len</i> be the number of elements in <i>s</i>.</li>
            <li>If <i>position</i> &ge; <i>len</i>, then
              <ol class="block">
                <li>Set the value of the [[IteratedString]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                    slot</a> of <i>O</i> to <b>undefined</b>.</li>
                <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>true</b>).</li>
              </ol>
            </li>
            <li>Let <i>first</i> be the code unit value at index <i>position</i> in <i>s</i>.</li>
            <li>If <i>first</i> &lt; 0xD800 or <i>first</i> &gt; 0xDBFF or <i>position</i>+1 = <i>len</i>, let <i>resultString</i>
                be the string consisting of the single code unit <i>first</i>.</li>
            <li>Else,
              <ol class="block">
                <li>Let <i>second</i> be the code unit value at index <i>position</i>+1 in the String <i>S</i>.</li>
                <li>If <i>second</i> &lt; 0xDC00 or <i>second</i> &gt; 0xDFFF, let <i>resultString</i> be the string consisting of
                    the single code unit <i>first</i>.</li>
                <li>Else, let <i>resultString</i> be the string consisting of the code unit <i>first</i> followed by the code unit
                    <i>second</i>.</li>
              </ol>
            </li>
            <li>Let <i>resultSize</i> be the number of code units in <i>resultString</i>.</li>
            <li>Set the value of the [[StringIteratorNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i> to <i>position</i>+
                <i>resultSize</i>.</li>
            <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<i>resultString</i>, <b>false</b>).</li>
          </ol>
        </section>

        <section id="sec-%stringiteratorprototype%-@@tostringtag">
          <h5 id="sec-21.1.5.2.2" title="21.1.5.2.2"> %StringIteratorPrototype% [ @@toStringTag ]</h5><p>The initial value of the @@toStringTag property is the String value <code>"String Iterator"</code>.</p>

          <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
        </section>
      </section>

      <section id="sec-properties-of-string-iterator-instances">
        <h4 id="sec-21.1.5.3" title="21.1.5.3"> Properties of String Iterator Instances</h4><p>String Iterator instances are ordinary objects that inherit properties from the %StringIteratorPrototype% intrinsic
        object. String Iterator instances are initially created with the internal slots listed in <a href="#table-46">Table
        46</a>.</p>

        <figure>
          <figcaption><span id="table-46">Table 46</span> &mdash; Internal Slots of String Iterator Instances</figcaption>
          <table class="real-table">
            <tr>
              <th>Internal Slot</th>
              <th>Description</th>
            </tr>
            <tr>
              <td>[[IteratedString]]</td>
              <td>The String value whose elements are being iterated.</td>
            </tr>
            <tr>
              <td>[[StringIteratorNextIndex]]</td>
              <td>The integer index of the next string index to be examined by this iteration.</td>
            </tr>
          </table>
        </figure>
      </section>
    </section>
  </section>

  <section id="sec-regexp-regular-expression-objects">
    <div class="front">
      <h2 id="sec-21.2" title="21.2"> RegExp (Regular Expression) Objects</h2><p>A RegExp object contains a regular expression and the associated flags.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> The form and functionality of regular expressions is modelled after the regular expression
        facility in the Perl&nbsp;5 programming language.</p>
      </div>
    </div>

    <section id="sec-patterns">
      <div class="front">
        <h3 id="sec-21.2.1" title="21.2.1">
            Patterns</h3><p>The <code>RegExp</code> constructor applies the following grammar to the input pattern String. An error occurs if the
        grammar cannot interpret the String as an expansion of <span class="nt">Pattern</span>.</p>

        <h2>Syntax</h2>

        <div class="gp">
          <div class="lhs"><span class="nt">Pattern</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">Disjunction</span><sub class="g-params">[?U]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">Disjunction</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">Alternative</span><sub class="g-params">[?U]</sub></div>
          <div class="rhs"><span class="nt">Alternative</span><sub class="g-params">[?U]</sub> <code class="t">|</code> <span class="nt">Disjunction</span><sub class="g-params">[?U]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">Alternative</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="grhsannot">[empty]</span></div>
          <div class="rhs"><span class="nt">Alternative</span><sub class="g-params">[?U]</sub> <span class="nt">Term</span><sub class="g-params">[?U]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">Term</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">Assertion</span><sub class="g-params">[?U]</sub></div>
          <div class="rhs"><span class="nt">Atom</span><sub class="g-params">[?U]</sub></div>
          <div class="rhs"><span class="nt">Atom</span><sub class="g-params">[?U]</sub> <span class="nt">Quantifier</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">Assertion</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">^</code></div>
          <div class="rhs"><code class="t">$</code></div>
          <div class="rhs"><code class="t">\</code> <code class="t">b</code></div>
          <div class="rhs"><code class="t">\</code> <code class="t">B</code></div>
          <div class="rhs"><code class="t">(</code> <code class="t">?</code> <code class="t">=</code> <span class="nt">Disjunction</span><sub class="g-params">[?U]</sub> <code class="t">)</code></div>
          <div class="rhs"><code class="t">(</code> <code class="t">?</code> <code class="t">!</code> <span class="nt">Disjunction</span><sub class="g-params">[?U]</sub> <code class="t">)</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">Quantifier</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">QuantifierPrefix</span></div>
          <div class="rhs"><span class="nt">QuantifierPrefix</span> <code class="t">?</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">QuantifierPrefix</span> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">*</code></div>
          <div class="rhs"><code class="t">+</code></div>
          <div class="rhs"><code class="t">?</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">DecimalDigits</span> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">DecimalDigits</span> <code class="t">,</code> <code class="t">}</code></div>
          <div class="rhs"><code class="t">{</code> <span class="nt">DecimalDigits</span> <code class="t">,</code> <span class="nt">DecimalDigits</span> <code class="t">}</code></div>
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
          <div class="lhs"><span class="nt">SyntaxCharacter</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">^</code> <code class="t">$</code> <code class="t">\</code> <code class="t">.</code> <code class="t">*</code> <code class="t">+</code> <code class="t">?</code> <code class="t">(</code> <code class="t">)</code> <code class="t">[</code> <code class="t">]</code> <code class="t">{</code> <code class="t">}</code> <code class="t">|</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">PatternCharacter</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <span class="nt">SyntaxCharacter</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">AtomEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">DecimalEscape</span></div>
          <div class="rhs"><span class="nt">CharacterEscape</span><sub class="g-params">[?U]</sub></div>
          <div class="rhs"><span class="nt">CharacterClassEscape</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">CharacterEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">ControlEscape</span></div>
          <div class="rhs"><code class="t">c</code> <span class="nt">ControlLetter</span></div>
          <div class="rhs"><span class="nt">HexEscapeSequence</span></div>
          <div class="rhs"><span class="nt">RegExpUnicodeEscapeSequence</span><sub class="g-params">[?U]</sub></div>
          <div class="rhs"><span class="nt">IdentityEscape</span><sub class="g-params">[?U]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ControlEscape</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">f</code> <code class="t">n</code> <code class="t">r</code> <code class="t">t</code> <code class="t">v</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ControlLetter</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">a</code> <code class="t">b</code> <code class="t">c</code> <code class="t">d</code> <code class="t">e</code> <code class="t">f</code> <code class="t">g</code> <code class="t">h</code> <code class="t">i</code> <code class="t">j</code> <code class="t">k</code> <code class="t">l</code> <code class="t">m</code> <code class="t">n</code> <code class="t">o</code> <code class="t">p</code> <code class="t">q</code> <code class="t">r</code> <code class="t">s</code> <code class="t">t</code> <code class="t">u</code> <code class="t">v</code> <code class="t">w</code> <code class="t">x</code> <code class="t">y</code> <code class="t">z</code></div>
          <div class="rhs"><code class="t">A</code> <code class="t">B</code> <code class="t">C</code> <code class="t">D</code> <code class="t">E</code> <code class="t">F</code> <code class="t">G</code> <code class="t">H</code> <code class="t">I</code> <code class="t">J</code> <code class="t">K</code> <code class="t">L</code> <code class="t">M</code> <code class="t">N</code> <code class="t">O</code> <code class="t">P</code> <code class="t">Q</code> <code class="t">R</code> <code class="t">S</code> <code class="t">T</code> <code class="t">U</code> <code class="t">V</code> <code class="t">W</code> <code class="t">X</code> <code class="t">Y</code> <code class="t">Z</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">RegExpUnicodeEscapeSequence</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">u</code> <span class="nt">LeadSurrogate</span> <code class="t">\u</code> <span class="nt">TrailSurrogate</span></div>
          <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">u</code> <span class="nt">LeadSurrogate</span></div>
          <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">u</code> <span class="nt">TrailSurrogate</span></div>
          <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">u</code> <span class="nt">NonSurrogate</span></div>
          <div class="rhs"><span class="grhsannot">[~U]</span> <code class="t">u</code> <span class="nt">Hex4Digits</span></div>
          <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">u{</code> <span class="nt">HexDigits</span> <code class="t">}</code></div>
        </div>

        <p>Each <code>\u</code> <span class="nt">TrailSurrogate</span> for which the choice of associated <code>u</code> <span class="nt">LeadSurrogate</span> is ambiguous shall be associated with the nearest possible <code>u</code> <span class="nt">LeadSurrogate</span> that would otherwise have no corresponding <code>\u</code>&nbsp;<span class="nt">TrailSurrogate</span>.</p>

        <div class="gp">
          <div class="lhs"><span class="nt">LeadSurrogate</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">Hex4Digits</span> <span class="grhsannot">[match only if the SV of <span class="nt">Hex4Digits</span> is in the inclusive range 0xD800 to 0xDBFF]</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">TrailSurrogate</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">Hex4Digits</span> <span class="grhsannot">[match only if the SV of <span class="nt">Hex4Digits</span> is in the inclusive range 0xDC00 to 0xDFFF]</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NonSurrogate</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">Hex4Digits</span> <span class="grhsannot">[match only if the SV of <span class="nt">Hex4Digits</span> is not in the inclusive range 0xD800 to 0xDFFF]</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">IdentityEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="grhsannot">[+U]</span> <span class="nt">SyntaxCharacter</span></div>
          <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">/</code></div>
          <div class="rhs"><span class="grhsannot">[~U]</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not</span> <span class="nt">UnicodeIDContinue</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">DecimalEscape</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">DecimalIntegerLiteral</span> <span class="grhsannot">[lookahead &notin; <span class="nt">DecimalDigit</span>]</span></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <span class="grhsmod">one of</span></div>
          <div class="rhs"><code class="t">d</code> <code class="t">D</code> <code class="t">s</code> <code class="t">S</code> <code class="t">w</code> <code class="t">W</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">CharacterClass</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><code class="t">[</code> <span class="grhsannot">[lookahead &notin; {<code class="t">^</code>}]</span> <span class="nt">ClassRanges</span><sub class="g-params">[?U]</sub> <code class="t">]</code></div>
          <div class="rhs"><code class="t">[</code> <code class="t">^</code> <span class="nt">ClassRanges</span><sub class="g-params">[?U]</sub> <code class="t">]</code></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">ClassRanges</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="grhsannot">[empty]</span></div>
          <div class="rhs"><span class="nt">NonemptyClassRanges</span><sub class="g-params">[?U]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NonemptyClassRanges</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub></div>
          <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub> <span class="nt">NonemptyClassRangesNoDash</span><sub class="g-params">[?U]</sub></div>
          <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub> <code class="t">-</code> <span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub> <span class="nt">ClassRanges</span><sub class="g-params">[?U]</sub></div>
        </div>

        <div class="gp">
          <div class="lhs"><span class="nt">NonemptyClassRangesNoDash</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub></div>
          <div class="rhs"><span class="nt">ClassAtomNoDash</span><sub class="g-params">[?U]</sub> <span class="nt">NonemptyClassRangesNoDash</span><sub class="g-params">[?U]</sub></div>
          <div class="rhs"><span class="nt">ClassAtomNoDash</span><sub class="g-params">[?U]</sub> <code class="t">-</code> <span class="nt">ClassAtom</span><sub class="g-params">[?U]</sub> <span class="nt">ClassRanges</span><sub class="g-params">[?U]</sub></div>
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
          <div class="lhs"><span class="nt">ClassEscape</span><sub class="g-params">[U]</sub> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">DecimalEscape</span></div>
          <div class="rhs"><code class="t">b</code></div>
          <div class="rhs"><span class="grhsannot">[+U]</span> <code class="t">-</code></div>
          <div class="rhs"><span class="nt">CharacterEscape</span><sub class="g-params">[?U]</sub></div>
          <div class="rhs"><span class="nt">CharacterClassEscape</span></div>
        </div>
      </div>

      <section id="sec-patterns-static-semantics-early-errors">
        <h4 id="sec-21.2.1.1" title="21.2.1.1"> Static Semantics:  Early Errors</h4><div class="gp prod"><span class="nt">RegExpUnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u{</code> <span class="nt">HexDigits</span> <code class="t">}</code></div>
        <ul>
          <li>It is a Syntax Error if the MV of <span class="nt">HexDigits</span> &gt; <span style="font-family: Times New               Roman">1114111<i>.</i></span></li>
        </ul>
      </section>
    </section>

    <section id="sec-pattern-semantics">
      <div class="front">
        <h3 id="sec-21.2.2" title="21.2.2">
            Pattern Semantics</h3><p>A regular expression pattern is converted into an internal procedure using the process described below. An
        implementation is encouraged to use more efficient algorithms than the ones listed below, as long as the results are the
        same. The internal procedure is used as the value of a RegExp object&rsquo;s [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>A <span class="nt">Pattern</span> is either a BMP pattern or a Unicode pattern depending upon whether or not its
        associated flags contain a <code>"u"</code>. A BMP pattern matches against a String interpreted as consisting of a
        sequence of 16-bit values that are Unicode code points in the range of the Basic Multilingual Plane. A Unicode pattern
        matches against a String interpreted as consisting of Unicode code points encoded using UTF-16. In the context of
        describing the behaviour of a BMP pattern &ldquo;character&rdquo; means a single 16-bit Unicode BMP code point. In the
        context of describing the behaviour of a Unicode pattern &ldquo;character&rdquo; means a UTF-16 encoded code point (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>). In either context, &ldquo;character value&rdquo; means the
        numeric value of the  corresponding non-encoded code point.</p>

        <p>The syntax and semantics of <span class="nt">Pattern</span> is defined as if the source code for the <span class="nt">Pattern</span> was a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <span class="nt">SourceCharacter</span> values where each <span class="nt">SourceCharacter</span> corresponds to a Unicode code
        point. If a BMP pattern contains a non-BMP <span class="nt">SourceCharacter</span> the entire pattern is encoded using
        UTF-16 and the individual code units of that encoding are used as the elements of the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> For example, consider a pattern expressed in source text as the single non-BMP character
          U+1D11E (MUSICAL SYMBOL G CLEF). Interpreted as a Unicode pattern, it would be a single element (character) <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> consisting of the single code point 0x1D11E. However,
          interpreted as a BMP pattern, it is first UTF-16 encoded to produce a two element <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> consisting of the code units 0xD834 and 0xDD1E.</p>

          <p>Patterns are passed to the RegExp constructor as ECMAScript String values in which non-BMP characters are UTF-16
          encoded. For example, the single character MUSICAL SYMBOL G CLEF pattern, expressed as a String value, is a String of
          length 2 whose elements were the code units 0xD834 and 0xDD1E. So no further translation of the string would be
          necessary to process it as a BMP pattern consisting of two pattern characters. However, to process it as a Unicode
          pattern <a href="sec-ecmascript-language-source-code#sec-utf16decode">UTF16Decode</a> (<a href="sec-ecmascript-language-source-code#sec-utf16decode">see 10.1.2</a>) must be used in producing
          a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> consisting of a single pattern character, the code point
          U+1D11E.</p>

          <p>An implementation may not actually perform such translations to or from UTF-16, but the semantics of this
          specification requires that the result of pattern matching be as if such translations were performed.</p>
        </div>
      </div>

      <section id="sec-notation">
        <h4 id="sec-21.2.2.1" title="21.2.2.1">
            Notation</h4><p>The descriptions below use the following variables:</p>

        <ul>
          <li>
            <p><span class="nt">Input</span> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> consisting of all of
            the characters, in order, of the String being matched by the regular expression pattern. Each character is either a
            code unit or a code point, depending upon the kind of pattern involved. The notation <span style="font-family: Times             New Roman"><i>Input</i>[<i>n</i>]</span> means the <span style="font-family: Times New             Roman"><i>n<sup>th</sup></i></span> character of <span class="nt">Input</span>, where <var>n</var> can range between 0
            (inclusive) and <span class="nt">InputLength</span> (exclusive).</p>
          </li>

          <li>
            <p><span class="nt">InputLength</span> is the number of characters in <span class="nt">Input</span>.</p>
          </li>

          <li>
            <p><span class="nt">NcapturingParens</span> is the total number of left capturing parentheses (i.e. the total number
            of times the <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">(</code>
            <span class="nt">Disjunction</span> <code class="t">)</code></span> production is expanded) in the pattern. A left
            capturing parenthesis is any <code>(</code> pattern character that is matched by the <code>(</code> terminal of the
            <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> production.</p>
          </li>

          <li>
            <p><span class="nt">IgnoreCase</span> is <b>true</b> if the RegExp object's [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> contains <code>"i"</code> and otherwise is
            <b>false</b>.</p>
          </li>

          <li>
            <p><span class="nt">Multiline</span> is <b>true</b> if the RegExp object&rsquo;s [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> contains <code>"m"</code> and otherwise is
            <b>false</b>.</p>
          </li>

          <li>
            <p><span class="nt">Unicode</span> is <b>true</b> if the RegExp object&rsquo;s [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> contains <code>"u"</code> and otherwise is
            <b>false</b>.</p>
          </li>
        </ul>

        <p class="normalbefore">Furthermore, the descriptions below use the following internal data structures:</p>

        <ul>
          <li>
            <p>A <span class="nt">CharSet</span> is a mathematical set of characters, either code units or code points depending
            up the state of the <span class="nt">Unicode</span> flag. &ldquo;All characters&rdquo; means either all code unit
            values or all code point values also depending upon the state if <span class="nt">Unicode</span>.</p>
          </li>

          <li>
            <p>A <span class="nt">State</span> is an ordered pair <span style="font-family: Times New Roman">(<i>endIndex</i>,
            <i>captures</i>)</span> where <var>endIndex</var> is an integer and <var>captures</var> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <span class="nt">NcapturingParens</span> values. <span class="nt">States</span> are used to represent partial match states in the regular expression matching algorithms. The
            <var>endIndex</var> is one plus the index of the last input character matched so far by the pattern, while
            <var>captures</var> holds the results of capturing parentheses. The <span style="font-family: Times New             Roman"><i>n<sup>th</sup></i></span> element of <var>captures</var> is either a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that represents the value obtained by the <span style="font-family: Times New Roman"><i>n<sup>th</sup></i></span> set of capturing parentheses or <b>undefined</b> if
            the <span style="font-family: Times New Roman"><i>n<sup>th</sup></i></span> set of capturing parentheses hasn&rsquo;t
            been reached yet. Due to backtracking, many <span class="nt">States</span> may be in use at any time during the
            matching process.</p>
          </li>

          <li>
            <p>A <span class="nt">MatchResult</span> is either a <span class="nt">State</span> or the special token <b>failure</b>
            that indicates that the match failed.</p>
          </li>

          <li>
            <p>A <span class="nt">Continuation</span> procedure is an internal closure (i.e. an internal procedure with some
            arguments already bound to values) that takes one <span class="nt">State</span> argument and returns a <span class="nt">MatchResult</span> result. If an internal closure references variables which are bound in the function that
            creates the closure, the closure uses the values that these variables had at the time the closure was created. The
            <span class="nt">Continuation</span> attempts to match the remaining portion (specified by the closure's already-bound
            arguments) of the pattern against <span class="nt">Input</span>, starting at the intermediate state given by its <span class="nt">State</span> argument. If the match succeeds, the <span class="nt">Continuation</span> returns the final
            <span class="nt">State</span> that it reached; if the match fails, the <span class="nt">Continuation</span> returns
            <b>failure</b>.</p>
          </li>

          <li>
            <p>A <span class="nt">Matcher</span> procedure is an internal closure that takes two arguments &mdash; a <span class="nt">State</span> and a <span class="nt">Continuation</span> &mdash; and returns a <span class="nt">MatchResult</span> result. A <span class="nt">Matcher</span> attempts to match a middle subpattern
            (specified by the closure's already-bound arguments) of the pattern against <span class="nt">Input</span>, starting at
            the intermediate state given by its <span class="nt">State</span> argument. The <span class="nt">Continuation</span>
            argument should be a closure that matches the rest of the pattern. After matching the subpattern of a pattern to
            obtain a new <span class="nt">State</span>, the <span class="nt">Matcher</span> then calls <span class="nt">Continuation</span> on that new <span class="nt">State</span> to test if the rest of the pattern can match
            as well. If it can, the <i>Matcher</i> returns the <span class="nt">State</span> returned by <span class="nt">Continuation</span>; if not, the <span class="nt">Matcher</span> may try different choices at its choice
            points, repeatedly calling <span class="nt">Continuation</span> until it either succeeds or all possibilities have
            been exhausted.</p>
          </li>

          <li>
            <p>An <span class="nt">AssertionTester</span> procedure is an internal closure that takes a <span class="nt">State</span> argument and returns a Boolean result. The assertion tester tests a specific condition
            (specified by the closure's already-bound arguments) against the current place in <span class="nt">Input</span> and
            returns <b>true</b> if the condition matched or <b>false</b> if not.</p>
          </li>

          <li>
            <p>An <span class="nt">EscapeValue</span> is either a character or an integer. An <span class="nt">EscapeValue</span>
            is used to denote the interpretation of a <span class="nt">DecimalEscape</span> escape sequence: a character
            <var>ch</var> means that the escape sequence is interpreted as the character <var>ch</var>, while an integer
            <var>n</var> means that the escape sequence is interpreted as a backreference to the <span style="font-family: Times             New Roman"><i>n</i><sup>th</sup></span> set of capturing parentheses.</p>
          </li>
        </ul>
      </section>

      <section id="sec-pattern">
        <h4 id="sec-21.2.2.2" title="21.2.2.2">
            Pattern</h4><p class="normalbefore">The production <span class="prod"><span class="nt">Pattern</span> <span class="geq">::</span>
        <span class="nt">Disjunction</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Evaluate <i>Disjunction</i> to obtain a Matcher <i>m</i>.</li>
          <li>Return an internal closure that takes two arguments, a String <i>str</i> and an integer <i>index</i>, and performs
              the following steps:
            <ol class="nested proc">
              <li>If <i>Unicode</i> is <b>true</b>, let <i>Input</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> consisting of the sequence of code points of  <i>str</i>
                  interpreted as a UTF-16 encoded (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>) Unicode string.
                  Otherwise, let <i>Input</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> consisting of the
                  sequence of code units that are the elements of <i>str</i>. <i>Input</i> will be used throughout the algorithms
                  in <a href="#sec-pattern-semantics">21.2.2</a>. Each element of <i>Input</i> is considered to be a
                  character.</li>
              <li>Let <i>listIndex</i> be the index into <i>Input</i> of the character that was obtained from element <i>index</i>
                  of <i>str</i>.</li>
              <li>Let <i>InputLength</i> be the number of characters contained in <i>Input</i>. This variable will be used
                  throughout the algorithms in <a href="#sec-pattern-semantics">21.2.2</a>.</li>
              <li>Let <i>c</i> be a Continuation that always returns its State argument as a successful MatchResult.</li>
              <li>Let <i>cap</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <i>NcapturingParens</i>
                  <b>undefined</b> values, indexed 1 through <i>NcapturingParens</i>.</li>
              <li>Let <i>x</i> be the State (<i>listIndex</i>, <i>cap</i>).</li>
              <li><a href="sec-abstract-operations#sec-call">Call</a> <i>m</i>(<i>x</i>, <i>c</i>) and return its result.</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> A Pattern evaluates (&ldquo;compiles&rdquo;) to an internal procedure value. <code><a href="#sec-regexp.prototype.exec">RegExp.prototype.exec</a></code> and other methods can then apply this procedure to a
          String and an offset within the String to determine whether the pattern would match starting at exactly that offset
          within the String, and, if it does match, what the values of the capturing parentheses would be. The algorithms in <a href="#sec-pattern-semantics">21.2.2</a> are designed so that compiling a pattern may throw a <b>SyntaxError</b>
          exception; on the other hand, once the pattern is successfully compiled, applying the resulting internal procedure to
          find a match in a String cannot throw an exception (except for any host-defined exceptions that can occur anywhere such
          as out-of-memory).</p>
        </div>
      </section>

      <section id="sec-disjunction">
        <h4 id="sec-21.2.2.3" title="21.2.2.3">
            Disjunction</h4><p>The production <span class="prod"><span class="nt">Disjunction</span> <span class="geq">::</span> <span class="nt">Alternative</span></span> evaluates by evaluating <span class="nt">Alternative</span> to obtain a <span style="font-family: Times New Roman">Matcher</span> and returning that <span style="font-family: Times New         Roman">Matcher</span>.</p>

        <p class="normalbefore">The production <span class="prod"><span class="nt">Disjunction</span> <span class="geq">::</span>
        <span class="nt">Alternative</span> <code class="t">|</code> <span class="nt">Disjunction</span></span> evaluates as
        follows:</p>

        <ol class="proc">
          <li>Evaluate <i>Alternative</i> to obtain a Matcher <i>m1</i>.</li>
          <li>Evaluate <i>Disjunction</i> to obtain a Matcher <i>m2</i>.</li>
          <li>Return an internal Matcher closure that takes two arguments, a State <i>x</i> and a Continuation <i>c</i>, and
              performs the following steps when evaluated:
            <ol class="nested proc">
              <li><a href="sec-abstract-operations#sec-call">Call</a> <i>m1</i>(<i>x</i>, <i>c</i>) and let <i>r</i> be its result.</li>
              <li>If <i>r</i> is not <b>failure</b>, return <i>r</i>.</li>
              <li><a href="sec-abstract-operations#sec-call">Call</a> <i>m2</i>(<i>x</i>, <i>c</i>) and return its result.</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>|</code> regular expression operator separates two alternatives. The pattern
          first tries to match the left <span class="nt">Alternative</span> (followed by the sequel of the regular expression); if
          it fails, it tries to match the right <span class="nt">Disjunction</span> (followed by the sequel of the regular
          expression). If the left <span class="nt">Alternative</span>, the right <span class="nt">Disjunction</span>, and the
          sequel all have choice points, all choices in the sequel are tried before moving on to the next choice in the left <span class="nt">Alternative</span>. If choices in the left <span class="nt">Alternative</span> are exhausted, the right <span class="nt">Disjunction</span> is tried instead of the left <span class="nt">Alternative</span>. Any capturing
          parentheses inside a portion of the pattern skipped by <code>|</code> produce <b>undefined</b> values instead of
          Strings. Thus, for example,</p>

          <pre>/a|ab/.exec("abc")</pre>

          <p>returns the result <code>"a"</code> and not <code>"ab"</code>. Moreover,</p>

          <pre>/((a)|(ab))((c)|(bc))/.exec("abc")</pre>

          <p>returns the array</p>

          <pre>["abc", "a", "a", undefined, "bc", undefined, "bc"]</pre>

          <p>and not</p>

          <pre>["abc", "ab", undefined, "ab", "c", "c", undefined]</pre>

          <p />
        </div>
      </section>

      <section id="sec-alternative">
        <h4 id="sec-21.2.2.4" title="21.2.2.4">
            Alternative</h4><p>The production <span class="prod"><span class="nt">Alternative</span> <span class="geq">::</span> <span class="grhsannot">[empty]</span></span> evaluates by returning a Matcher that takes two arguments, a State <var>x</var>
        and a Continuation <var>c</var>, and returns the result of calling <var>c</var>(<var>x</var>).</p>

        <p class="normalbefore">The production <span class="prod"><span class="nt">Alternative</span> <span class="geq">::</span>
        <span class="nt">Alternative</span> <span class="nt">Term</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Evaluate <i>Alternative</i> to obtain a Matcher <i>m1</i>.</li>
          <li>Evaluate <i>Term</i> to obtain a Matcher <i>m2</i>.</li>
          <li>Return an internal Matcher closure that takes two arguments, a State <i>x</i> and a Continuation <i>c</i>, and
              performs the following steps when evaluated:
            <ol class="nested proc">
              <li>Create a Continuation <i>d</i> that takes a State argument <i>y</i> and returns the result of calling
                  <i>m2</i>(<i>y</i>, <i>c</i>).</li>
              <li><a href="sec-abstract-operations#sec-call">Call</a> <i>m1</i>(<i>x</i>, <i>d</i>) and return its result.</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> Consecutive <span class="nt">Terms</span> try to simultaneously match consecutive
          portions of <span class="nt">Input</span>. If the left <span class="nt">Alternative</span>, the right <span class="nt">Term</span>, and the sequel of the regular expression all have choice points, all choices in the sequel are
          tried before moving on to the next choice in the right <span class="nt">Term</span>, and all choices in the right <span class="nt">Term</span> are tried before moving on to the next choice in the left <span class="nt">Alternative</span>.</p>
        </div>
      </section>

      <section id="sec-term">
        <div class="front">
          <h4 id="sec-21.2.2.5" title="21.2.2.5">
              Term</h4><p>The production <span class="prod"><span class="nt">Term</span> <span class="geq">::</span> <span class="nt">Assertion</span></span> evaluates by returning an internal Matcher closure that takes two arguments, a State
          <var>x</var> and a Continuation <var>c</var>, and performs the following steps when evaluated:</p>

          <ol class="proc">
            <li>Evaluate <i>Assertion</i> to obtain an AssertionTester <i>t</i>.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> <i>t</i>(<i>x</i>) and let <i>r</i> be the resulting Boolean value.</li>
            <li>If <i>r</i> is <b>false</b>, return <b>failure</b>.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> <i>c</i>(<i>x</i>) and return its result.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Term</span> <span class="geq">::</span> <span class="nt">Atom</span></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Return the Matcher that is the result of evaluating <i>Atom</i>.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Term</span> <span class="geq">::</span> <span class="nt">Atom</span> <span class="nt">Quantifier</span></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Evaluate <i>Atom</i> to obtain a Matcher <i>m</i>.</li>
            <li>Evaluate <i>Quantifier</i> to obtain the three results: an integer <i>min</i>, an integer (or &infin;) <i>max</i>,
                and Boolean <i>greedy</i>.</li>
            <li>If <i>max</i> is finite and less than <i>min</i>, throw a <b>SyntaxError</b> exception.</li>
            <li>Let <i>parenIndex</i> be the number of left capturing parentheses in the entire regular expression that occur to
                the left of this production expansion's <i>Term</i>. This is the total number of times the <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> production is expanded prior to this production's
                <i>Term</i> plus the total number of <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span>
                <code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> productions enclosing
                this <i>Term</i>.</li>
            <li>Let <i>parenCount</i> be the number of left capturing parentheses in the expansion of this production's
                <i>Atom</i>. This is the total number of <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></span>
                productions enclosed by this production's <i>Atom</i>.</li>
            <li>Return an internal Matcher closure that takes two arguments, a State <i>x</i> and a Continuation <i>c</i>, and
                performs the following steps when evaluated:
              <ol class="nested proc">
                <li><a href="sec-abstract-operations#sec-call">Call</a> RepeatMatcher(<i>m</i>, <i>min</i>, <i>max</i>, <i>greedy</i>, <i>x</i>,
                    <i>c</i>, <i>parenIndex</i>, <i>parenCount</i>) and return its result.</li>
              </ol>
            </li>
          </ol>
        </div>

        <section id="sec-runtime-semantics-repeatmatcher-abstract-operation">
          <h5 id="sec-21.2.2.5.1" title="21.2.2.5.1"> Runtime Semantics: RepeatMatcher Abstract Operation</h5><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">RepeatMatcher</span> takes
          eight parameters, a Matcher <var>m</var>, an integer <var>min</var>, an integer (or &infin;) <var>max</var>, a Boolean
          <var>greedy</var>, a State <var>x</var>, a Continuation <var>c</var>, an integer <var>parenIndex</var>, and an integer
          <var>parenCount</var>, and performs the following steps:</p>

          <ol class="proc">
            <li>If <i>max</i> is zero, return <i>c</i>(<i>x</i>).</li>
            <li>Create an internal Continuation closure <i>d</i> that takes one State argument <i>y</i> and performs the following
                steps when evaluated:
              <ol class="nested proc">
                <li>If <i>min</i> is zero and <i>y</i>'s <i>endIndex</i> is equal to <i>x</i>'s <i>endIndex</i>, return
                    <b>failure</b>.</li>
                <li>If <i>min</i> is zero, let <i>min2</i> be zero; otherwise let <i>min2</i> be <i>min</i>&ndash;1.</li>
                <li>If <i>max</i> is &infin;, let <i>max2</i> be &infin;; otherwise let <i>max2</i> be <i>max</i>&ndash;1.</li>
                <li><a href="sec-abstract-operations#sec-call">Call</a> RepeatMatcher(<i>m</i>, <i>min2</i>, <i>max2</i>, <i>greedy</i>, <i>y</i>,
                    <i>c</i>, <i>parenIndex</i>, <i>parenCount</i>) and return its result.</li>
              </ol>
            </li>
            <li>Let <i>cap</i> be a fresh copy of <i>x</i>'s <i>captures</i> <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>For every integer <i>k</i> that satisfies <i>parenIndex</i> &lt; <i>k</i> and <i>k</i> &le;
                <i>parenIndex</i>+<i>parenCount</i>, set <i>cap</i>[<i>k</i>] to <b>undefined</b>.</li>
            <li>Let <i>e</i> be <i>x</i>'s <i>endIndex</i>.</li>
            <li>Let <i>xr</i> be the State (<i>e</i>, <i>cap</i>).</li>
            <li>If <i>min</i> is not zero, return <i>m</i>(<i>xr</i>, <i>d</i>).</li>
            <li>If <i>greedy</i> is <b>false</b>, then
              <ol class="block">
                <li><a href="sec-abstract-operations#sec-call">Call</a> <i>c</i>(<i>x</i>) and let <i>z</i> be its result.</li>
                <li>If <i>z</i> is not <b>failure</b>, return <i>z</i>.</li>
                <li><a href="sec-abstract-operations#sec-call">Call</a> <i>m</i>(<i>xr</i>, <i>d</i>) and return its result.</li>
              </ol>
            </li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> <i>m</i>(<i>xr</i>, <i>d</i>) and let <i>z</i> be its result.</li>
            <li>If <i>z</i> is not <b>failure</b>, return <i>z</i>.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> <i>c</i>(<i>x</i>) and return its result.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE 1</span> An <span class="nt">Atom</span> followed by a <span class="nt">Quantifier</span> is
            repeated the number of times specified by the <span class="nt">Quantifier</span>. A <span class="nt">Quantifier</span>
            can be non-greedy, in which case the <span class="nt">Atom</span> pattern is repeated as few times as possible while
            still matching the sequel, or it can be greedy, in which case the <span class="nt">Atom</span> pattern is repeated as
            many times as possible while still matching the sequel. The <span class="nt">Atom</span> pattern is repeated rather
            than the input character sequence that it matches, so different repetitions of the <span class="nt">Atom</span> can
            match different input substrings.</p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 2</span> If the <span class="nt">Atom</span> and the sequel of the regular expression all
            have choice points, the <span class="nt">Atom</span> is first matched as many (or as few, if non-greedy) times as
            possible. All choices in the sequel are tried before moving on to the next choice in the last repetition of <span class="nt">Atom</span>. All choices in the last (n<sup>th</sup>) repetition of <span class="nt">Atom</span> are tried
            before moving on to the next choice in the next-to-last (n&ndash;1)<sup>st</sup> repetition of <span class="nt">Atom</span>; at which point it may turn out that more or fewer repetitions of <span class="nt">Atom</span>
            are now possible; these are exhausted (again, starting with either as few or as many as possible) before moving on to
            the next choice in the (n-1)<sup>st</sup> repetition of <span class="nt">Atom</span> and so on.</p>

            <p>Compare</p>

            <pre>/a[a-z]{2,4}/.exec("abcdefghi")</pre>

            <p>which returns <code>"abcde"</code> with</p>

            <pre>/a[a-z]{2,4}?/.exec("abcdefghi")</pre>

            <p>which returns <code>"abc"</code>.</p>

            <p>Consider also</p>

            <pre>/(aa|aabaac|ba|b|c)*/.exec("aabaac")</pre>

            <p>which, by the choice point ordering above, returns the array</p>

            <pre>["aaba", "ba"]</pre>

            <p>and not any of:</p>

            <pre>["aabaac", "aabaac"]</pre>
            <pre>["aabaac", "c"]</pre>

            <p>The above ordering of choice points can be used to write a regular expression that calculates the greatest common
            divisor of two numbers (represented in unary notation). The following example calculates the gcd of 10 and 15:</p>

            <pre>"aaaaaaaaaa,aaaaaaaaaaaaaaa".replace(/^(a+)\1*,\1+$/,"$1")</pre>

            <p>which returns the gcd in unary notation <code>"aaaaa"</code>.</p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 3</span> Step 5 of the RepeatMatcher clears <var>Atom's</var> captures each time <span class="nt">Atom</span> is repeated. We can see its behaviour in the regular expression</p>

            <pre>/(z)((a+)?(b+)?(c))*/.exec("zaacbbbcac")</pre>

            <p>which returns the array</p>

            <pre>["zaacbbbcac", "z", "ac", "a", undefined, "c"]</pre>

            <p>and not</p>

            <pre>["zaacbbbcac", "z", "ac", "a", "bbb", "c"]</pre>

            <p>because each iteration of the outermost <code>*</code> clears all captured Strings contained in the quantified
            <span class="nt">Atom</span>, which in this case includes capture Strings numbered 2, 3, 4, and 5.</p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 4</span> Step 1 of the RepeatMatcher's <var>d</var> closure states that, once the minimum
            number of repetitions has been satisfied, any more expansions of <span class="nt">Atom</span> that match the empty
            character sequence are not considered for further repetitions. This prevents the regular expression engine from
            falling into an infinite loop on patterns such as:</p>

            <pre>/(a*)*/.exec("b")</pre>

            <p>or the slightly more complicated:</p>

            <pre>/(a*)b\1+/.exec("baaaac")</pre>

            <p>which returns the array</p>

            <pre>["b", ""]</pre>

            <p />
          </div>
        </section>
      </section>

      <section id="sec-assertion">
        <div class="front">
          <h4 id="sec-21.2.2.6" title="21.2.2.6">
              Assertion</h4><p class="normalbefore">The production <span class="prod"><span class="nt">Assertion</span> <span class="geq">::</span>
          <code class="t">^</code></span> evaluates by returning an internal AssertionTester closure that takes a State argument
          <var>x</var> and performs the following steps when evaluated:</p>

          <ol class="proc">
            <li>Let <i>e</i> be <i>x</i>'s <i>endIndex</i>.</li>
            <li>If <i>e</i> is zero, return <b>true</b>.</li>
            <li>If <i>Multiline</i> is <b>false</b>, return <b>false</b>.</li>
            <li>If the character <i>Input</i>[<i>e</i>&ndash;1] is one of <i>LineTerminator</i>, return <b>true</b>.</li>
            <li>Return <b>false</b>.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> Even when the <code>y</code> flag is used with a pattern, <code>^</code> always
            matches only at the beginning of <span class="nt">Input</span>, or (if <span class="nt">Multiline</span> is <span class="value">true</span>) at the beginning of a line.</p>
          </div>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Assertion</span> <span class="geq">::</span>
          <code class="t">$</code></span> evaluates by returning an internal AssertionTester closure that takes a State argument
          <var>x</var> and performs the following steps when evaluated:</p>

          <ol class="proc">
            <li>Let <i>e</i> be <i>x</i>'s <i>endIndex</i>.</li>
            <li>If <i>e</i> is equal to <i>InputLength</i>, return <b>true</b>.</li>
            <li>If <i>Multiline</i> is <b>false</b>, return <b>false</b>.</li>
            <li>If the character <i>Input</i>[<i>e</i>] is one of <i>LineTerminator</i>, return <b>true</b>.</li>
            <li>Return <b>false</b>.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Assertion</span> <span class="geq">::</span>
          <code class="t">\</code> <code class="t">b</code></span> evaluates by returning an internal AssertionTester closure that
          takes a State argument <var>x</var> and performs the following steps when evaluated:</p>

          <ol class="proc">
            <li>Let <i>e</i> be <i>x</i>'s <i>endIndex</i>.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> IsWordChar(<i>e</i>&ndash;1) and let <i>a</i> be the Boolean result.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> IsWordChar(<i>e</i>) and let <i>b</i> be the Boolean result.</li>
            <li>If <i>a</i> is <b>true</b> and <i>b</i> is <b>false</b>, return <b>true</b>.</li>
            <li>If <i>a</i> is <b>false</b> and <i>b</i> is <b>true</b>, return <b>true</b>.</li>
            <li>Return <b>false</b>.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Assertion</span> <span class="geq">::</span>
          <code class="t">\</code> <code class="t">B</code></span> evaluates by returning an internal AssertionTester closure that
          takes a State argument <var>x</var> and performs the following steps when evaluated:</p>

          <ol class="proc">
            <li>Let <i>e</i> be <i>x</i>'s <i>endIndex</i>.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> IsWordChar(<i>e</i>&ndash;1) and let <i>a</i> be the Boolean result.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> IsWordChar(<i>e</i>) and let <i>b</i> be the Boolean result.</li>
            <li>If <i>a</i> is <b>true</b> and <i>b</i> is <b>false</b>, return <b>false</b>.</li>
            <li>If <i>a</i> is <b>false</b> and <i>b</i> is <b>true</b>, return <b>false</b>.</li>
            <li>Return <b>true</b>.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Assertion</span> <span class="geq">::</span>
          <code class="t">(</code> <code class="t">?</code> <code class="t">=</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Evaluate <i>Disjunction</i> to obtain a Matcher <i>m</i>.</li>
            <li>Return an internal Matcher closure that takes two arguments, a State <i>x</i> and a Continuation <i>c</i>, and
                performs the following steps:
              <ol class="nested proc">
                <li>Let <i>d</i> be a Continuation that always returns its State argument as a successful MatchResult.</li>
                <li><a href="sec-abstract-operations#sec-call">Call</a> <i>m</i>(<i>x</i>, <i>d</i>) and let <i>r</i> be its result.</li>
                <li>If <i>r</i> is <b>failure</b>, return <b>failure</b>.</li>
                <li>Let <i>y</i> be <i>r</i>'s State.</li>
                <li>Let <i>cap</i> be <i>y</i>'s <i>captures</i> <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
                <li>Let <i>xe</i> be <i>x</i>'s <i>endIndex</i>.</li>
                <li>Let <i>z</i> be the State (<i>xe</i>, <i>cap</i>).</li>
                <li><a href="sec-abstract-operations#sec-call">Call</a> <i>c</i>(<i>z</i>) and return its result.</li>
              </ol>
            </li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Assertion</span> <span class="geq">::</span>
          <code class="t">(</code> <code class="t">?</code> <code class="t">!</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Evaluate <i>Disjunction</i> to obtain a Matcher <i>m</i>.</li>
            <li>Return an internal Matcher closure that takes two arguments, a State <i>x</i> and a Continuation <i>c</i>, and
                performs the following steps:
              <ol class="nested proc">
                <li>Let <i>d</i> be a Continuation that always returns its State argument as a successful MatchResult.</li>
                <li><a href="sec-abstract-operations#sec-call">Call</a> <i>m</i>(<i>x</i>, <i>d</i>) and let <i>r</i> be its result.</li>
                <li>If <i>r</i> is not <b>failure</b>, return <b>failure</b>.</li>
                <li><a href="sec-abstract-operations#sec-call">Call</a> <i>c</i>(<i>x</i>) and return its result.</li>
              </ol>
            </li>
          </ol>
        </div>

        <section id="sec-runtime-semantics-iswordchar-abstract-operation">
          <h5 id="sec-21.2.2.6.1" title="21.2.2.6.1"> Runtime Semantics: IsWordChar Abstract Operation</h5><p class="normalbefore">The abstract operation IsWordChar takes an integer parameter <var>e</var> and performs the
          following steps:</p>

          <ol class="proc">
            <li>If <i>e</i> is &ndash;1 or <i>e</i>  is <i>InputLength</i>, return <b>false</b>.</li>
            <li>Let <i>c</i> be the character <i>Input</i>[<i>e</i>].</li>
            <li>If <i>c</i> is one of the sixty-three characters below, return <b>true</b>.
              <figure>
                <table class="lightweight-table">
                  <tr>
                    <td><code>a</code></td>
                    <td><code>b</code></td>
                    <td><code>c</code></td>
                    <td><code>d</code></td>
                    <td><code>e</code></td>
                    <td><code>f</code></td>
                    <td><code>g</code></td>
                    <td><code>h</code></td>
                    <td><code>i</code></td>
                    <td><code>j</code></td>
                    <td><code>k</code></td>
                    <td><code>l</code></td>
                    <td><code>m</code></td>
                    <td><code>n</code></td>
                    <td><code>o</code></td>
                    <td><code>p</code></td>
                    <td><code>q</code></td>
                    <td><code>r</code></td>
                    <td><code>s</code></td>
                    <td><code>t</code></td>
                    <td><code>u</code></td>
                    <td><code>v</code></td>
                    <td><code>w</code></td>
                    <td><code>x</code></td>
                    <td><code>y</code></td>
                    <td><code>z</code></td>
                  </tr>
                  <tr>
                    <td><code>A</code></td>
                    <td><code>B</code></td>
                    <td><code>C</code></td>
                    <td><code>D</code></td>
                    <td><code>E</code></td>
                    <td><code>F</code></td>
                    <td><code>G</code></td>
                    <td><code>H</code></td>
                    <td><code>I</code></td>
                    <td><code>J</code></td>
                    <td><code>K</code></td>
                    <td><code>L</code></td>
                    <td><code>M</code></td>
                    <td><code>N</code></td>
                    <td><code>O</code></td>
                    <td><code>P</code></td>
                    <td><code>Q</code></td>
                    <td><code>R</code></td>
                    <td><code>S</code></td>
                    <td><code>T</code></td>
                    <td><code>U</code></td>
                    <td><code>V</code></td>
                    <td><code>W</code></td>
                    <td><code>X</code></td>
                    <td><code>Y</code></td>
                    <td><code>Z</code></td>
                  </tr>
                  <tr>
                    <td><code>0</code></td>
                    <td><code>1</code></td>
                    <td><code>2</code></td>
                    <td><code>3</code></td>
                    <td><code>4</code></td>
                    <td><code>5</code></td>
                    <td><code>6</code></td>
                    <td><code>7</code></td>
                    <td><code>8</code></td>
                    <td><code>9</code></td>
                    <td><code>_</code></td>
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                    <td />
                  </tr>
                </table>
              </figure>
            </li>
            <li>Return <b>false</b>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-quantifier">
        <h4 id="sec-21.2.2.7" title="21.2.2.7">
            Quantifier</h4><p class="normalbefore">The production <span class="prod"><span class="nt">Quantifier</span> <span class="geq">::</span>
        <span class="nt">QuantifierPrefix</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Evaluate <i>QuantifierPrefix</i> to obtain the two results: an integer <i>min</i> and an integer (or &infin;)
              <i>max</i>.</li>
          <li>Return the three results <i>min</i>, <i>max</i>, and <b>true</b>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">Quantifier</span> <span class="geq">::</span>
        <span class="nt">QuantifierPrefix</span> <code class="t">?</code></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Evaluate <i>QuantifierPrefix</i> to obtain the two results: an integer <i>min</i> and an integer (or &infin;)
              <i>max</i>.</li>
          <li>Return the three results <i>min</i>, <i>max</i>, and <b>false</b>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">QuantifierPrefix</span> <span class="geq">::</span> <code class="t">*</code></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the two results 0 and &infin;.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">QuantifierPrefix</span> <span class="geq">::</span> <code class="t">+</code></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the two results 1 and &infin;.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">QuantifierPrefix</span> <span class="geq">::</span> <code class="t">?</code></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the two results 0 and 1.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">QuantifierPrefix</span> <span class="geq">::</span> <code class="t">{</code> <span class="nt">DecimalDigits</span> <code class="t">}</code></span>
        evaluates as follows:</p>

        <ol class="proc">
          <li>Let <i>i</i> be the MV of <i>DecimalDigits</i> (<a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">see 11.8.3</a>).</li>
          <li>Return the two results <i>i</i> and <i>i</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">QuantifierPrefix</span> <span class="geq">::</span> <code class="t">{</code> <span class="nt">DecimalDigits</span> <code class="t">,</code> <code class="t">}</code></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Let <i>i</i> be the MV of <i>DecimalDigits</i>.</li>
          <li>Return the two results <i>i</i> and &infin;.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">QuantifierPrefix</span> <span class="geq">::</span> <code class="t">{</code> <span class="nt">DecimalDigits</span> <code class="t">,</code> <span class="nt">DecimalDigits</span> <code class="t">}</code></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Let <i>i</i> be the MV of the first <i>DecimalDigits</i>.</li>
          <li>Let <i>j</i> be the MV of the second <i>DecimalDigits</i>.</li>
          <li>Return the two results <i>i</i> and <i>j</i>.</li>
        </ol>
      </section>

      <section id="sec-atom">
        <div class="front">
          <h4 id="sec-21.2.2.8" title="21.2.2.8">
              Atom</h4><p class="normalbefore">The production <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <span class="nt">PatternCharacter</span></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Let <i>ch</i> be the character matched by <i>PatternCharacter</i>.</li>
            <li>Let <i>A</i> be a one-element CharSet containing the character <i>ch</i>.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> CharacterSetMatcher(<i>A</i>, <b>false</b>) and return its Matcher result.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">.</code></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Let <i>A</i> be the set of all characters except <i>LineTerminator</i>.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> CharacterSetMatcher(<i>A</i>, <b>false</b>) and return its Matcher result.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">AtomEscape</span></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Return the Matcher that is the result of evaluating <i>AtomEscape</i>.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <span class="nt">CharacterClass</span></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Evaluate <i>CharacterClass</i> to obtain a CharSet <i>A</i> and a Boolean <i>invert</i>.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> CharacterSetMatcher(<i>A</i>, <i>invert</i>) and return its Matcher result.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Evaluate <i>Disjunction</i> to obtain a Matcher <i>m</i>.</li>
            <li>Let <i>parenIndex</i> be the number of left capturing parentheses in the entire regular expression that occur to
                the left of this production expansion's initial left parenthesis. This is the total number of times the <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> production is expanded prior to this production's
                <i>Atom</i> plus the total number of <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span>
                <code class="t">(</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> productions enclosing
                this <i>Atom</i>.</li>
            <li>Return an internal Matcher closure that takes two arguments, a State <i>x</i> and a Continuation <i>c</i>, and
                performs the following steps:
              <ol class="nested proc">
                <li>Create an internal Continuation closure <i>d</i> that takes one State argument <i>y</i> and performs the
                    following steps:
                  <ol class="nested proc">
                    <li>Let <i>cap</i> be a fresh copy of <i>y</i>'s <i>captures</i> <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
                    <li>Let <i>xe</i> be <i>x</i>'s <i>endIndex</i>.</li>
                    <li>Let <i>ye</i> be <i>y</i>'s <i>endIndex</i>.</li>
                    <li>Let <i>s</i> be a fresh <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose characters are
                        the characters of <i>Input</i> at indices <i>xe</i> (inclusive) through <i>ye</i> (exclusive).</li>
                    <li>Set <i>cap</i>[<i>parenIndex</i>+1] to <i>s</i>.</li>
                    <li>Let <i>z</i> be the State (<i>ye</i>, <i>cap</i>).</li>
                    <li><a href="sec-abstract-operations#sec-call">Call</a> <i>c</i>(<i>z</i>) and return its result.</li>
                  </ol>
                </li>
                <li><a href="sec-abstract-operations#sec-call">Call</a> <i>m</i>(<i>x</i>, <i>d</i>) and return its result.</li>
              </ol>
            </li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">Atom</span> <span class="geq">::</span> <code class="t">(</code> <code class="t">?</code> <code class="t">:</code> <span class="nt">Disjunction</span> <code class="t">)</code></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Return the Matcher that is the result of evaluating <i>Disjunction</i>.</li>
          </ol>
        </div>

        <section id="sec-runtime-semantics-charactersetmatcher-abstract-operation">
          <h5 id="sec-21.2.2.8.1" title="21.2.2.8.1"> Runtime Semantics: CharacterSetMatcher Abstract Operation</h5><p class="normalbefore">The abstract operation CharacterSetMatcher takes two arguments, a CharSet <var>A</var> and a
          Boolean flag <var>invert</var>, and performs the following steps:</p>

          <ol class="proc">
            <li>Return an internal Matcher closure that takes two arguments, a State <i>x</i> and a Continuation <i>c</i>, and
                performs the following steps when evaluated:
              <ol class="nested proc">
                <li>Let <i>e</i> be <i>x</i>'s <i>endIndex</i>.</li>
                <li>If <i>e</i> is <i>InputLength</i>, return <b>failure</b>.</li>
                <li>Let <i>ch</i> be the character <i>Input</i>[<i>e</i>].</li>
                <li>Let <i>cc</i> be Canonicalize(<i>ch</i>).</li>
                <li>If <i>invert</i> is <b>false</b>, then
                  <ol class="block">
                    <li>If there does not exist a member <i>a</i> of set <i>A</i> such that Canonicalize(<i>a</i>) is <i>cc</i>,
                        return <b>failure</b>.</li>
                  </ol>
                </li>
                <li>Else <i>invert</i> is <b>true</b>,
                  <ol class="block">
                    <li>If there exists a member <i>a</i> of set <i>A</i> such that Canonicalize(<i>a</i>) is <i>cc</i>, return
                        <b>failure.</b></li>
                  </ol>
                </li>
                <li>Let <i>cap</i> be <i>x</i>'s <i>captures</i> <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
                <li>Let <i>y</i> be the State (<i>e</i>+1, <i>cap</i>).</li>
                <li><a href="sec-abstract-operations#sec-call">Call</a> <i>c</i>(<i>y</i>) and return its result.</li>
              </ol>
            </li>
          </ol>
        </section>

        <section id="sec-runtime-semantics-canonicalize-ch">
          <h5 id="sec-21.2.2.8.2" title="21.2.2.8.2"> Runtime Semantics: Canonicalize ( ch )</h5><p class="normalbefore">The abstract operation Canonicalize takes a character parameter <var>ch</var> and performs the
          following steps:</p>

          <ol class="proc">
            <li>If <i>IgnoreCase</i> is <b>false</b>, return <i>ch</i>.</li>
            <li>If <i>Unicode</i> is <b>true</b>,
              <ol class="block">
                <li>If the file CaseFolding.txt of the Unicode Character Database provides a simple or common case folding mapping
                    for <i>ch</i>, return the result of applying that mapping to <i>ch</i>.</li>
                <li>Else, return <i>ch.</i></li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>ch</i> is a UTF-16 code unit.</li>
                <li>Let <i>s</i> be the ECMAScript String value consisting of the single code unit <i>ch</i>.</li>
                <li>Let <i>u</i> be the same result produced as if by performing the algorithm for <code><a href="#sec-string.prototype.touppercase">String.prototype.toUpperCase</a></code> using <i>s</i> as the
                    <b>this</b> value.</li>
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>u</i> is a String value.</li>
                <li>If <i>u</i> does not consist of a single code unit, return <i>ch</i>.</li>
                <li>Let <i>cu</i> be <i>u</i>&rsquo;s single code unit element.</li>
                <li>If <i>ch</i>'s code unit value &ge; 128 and <i>cu</i>'s code unit value &lt; 128, return <i>ch</i>.</li>
                <li>Return <i>cu</i>.</li>
              </ol>
            </li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE 1</span> Parentheses of the form <code>(</code> <span class="nt">Disjunction</span>
            <code>)</code> serve both to group the components of the <span class="nt">Disjunction</span> pattern together and to
            save the result of the match. The result can be used either in a backreference (<code>\</code> followed by a nonzero
            decimal number), referenced in a replace String, or returned as part of an array from the regular expression matching
            internal procedure. To inhibit the capturing behaviour of parentheses, use the form <code>(?:</code> <span class="nt">Disjunction</span> <code>)</code> instead.</p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 2</span> The form <code>(?=</code> <span class="nt">Disjunction</span> <code>)</code>
            specifies a zero-width positive lookahead. In order for it to succeed, the pattern inside <span class="nt">Disjunction</span> must match at the current position, but the current position is not advanced before
            matching the sequel. If <span class="nt">Disjunction</span> can match at the current position in several ways, only
            the first one is tried. Unlike other regular expression operators, there is no backtracking into a <code>(?=</code>
            form (this unusual behaviour is inherited from Perl). This only matters when the <span class="nt">Disjunction</span>
            contains capturing parentheses and the sequel of the pattern contains backreferences to those captures.</p>

            <p>For example,</p>

            <pre>/(?=(a+))/.exec("baaabac")</pre>

            <p>matches the empty String immediately after the first <code>b</code> and therefore returns the array:</p>

            <pre>["", "aaa"]</pre>

            <p>To illustrate the lack of backtracking into the lookahead, consider:</p>

            <pre>/(?=(a+))a*b\1/.exec("baaabac")</pre>

            <p>This expression returns</p>

            <pre>["aba", "a"]</pre>

            <p>and not:</p>

            <pre>["aaaba", "a"]</pre>

            <p />
          </div>

          <div class="note">
            <p><span class="nh">NOTE 3</span> The form <code>(?!</code> <span class="nt">Disjunction</span> <code>)</code>
            specifies a zero-width negative lookahead. In order for it to succeed, the pattern inside <span class="nt">Disjunction</span> must fail to match at the current position. The current position is not advanced before
            matching the sequel. <span class="nt">Disjunction</span> can contain capturing parentheses, but backreferences to them
            only make sense from within <span class="nt">Disjunction</span> itself. Backreferences to these capturing parentheses
            from elsewhere in the pattern always return <b>undefined</b> because the negative lookahead must fail for the pattern
            to succeed. For example,</p>

            <pre>/(.*?)a(?!(a+)b\2c)\2(.*)/.exec("baaabaac")</pre>

            <p>looks for an <code>a</code> not immediately followed by some positive number n of <code>a</code>'s, a
            <code>b</code>, another n <code>a</code>'s (specified by the first <code>\2</code>) and a <code>c</code>. The second
            <code>\2</code> is outside the negative lookahead, so it matches against <b>undefined</b> and therefore always
            succeeds. The whole expression returns the array:</p>

            <pre>["baaabaac", "ba", undefined, "abaac"]</pre>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 4</span> In case-insignificant matches when <span class="nt">Unicode</span> is <span class="value">true</span>, all characters are implicitly case-folded using the simple mapping provided by the Unicode
            standard immediately before they are compared. The simple mapping always maps to a single code point, so it does not
            map, for example, <code>"&szlig;"</code> (U+00DF) to <code>"SS"</code>. It may however map a code point outside the
            Basic Latin range to a character within, for example, <code>"</code>&#x17f;<code>"</code> (U+017F) to
            <code>"</code>s<code>"</code>. Such characters are not mapped if <span class="nt">Unicode</span> is <span class="value">false</span>. This prevents Unicode code points such as U+017F and U+212A from matching regular
            expressions such as <code>/[a&#x2011;z]/i</code>, but they will match <code>/[a&#x2011;z]/ui</code>.</p>
          </div>
        </section>
      </section>

      <section id="sec-atomescape">
        <h4 id="sec-21.2.2.9" title="21.2.2.9">
            AtomEscape</h4><p class="normalbefore">The production <span class="prod"><span class="nt">AtomEscape</span> <span class="geq">::</span>
        <span class="nt">DecimalEscape</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Evaluate <i>DecimalEscape</i> to obtain an EscapeValue <i>E</i>.</li>
          <li>If <i>E</i> is a character, then
            <ol class="block">
              <li>Let <i>ch</i> be <i>E</i>'s character.</li>
              <li>Let <i>A</i> be a one-element CharSet containing the character <i>ch</i>.</li>
              <li><a href="sec-abstract-operations#sec-call">Call</a> CharacterSetMatcher(<i>A</i>, <b>false</b>) and return its Matcher result.</li>
            </ol>
          </li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>E</i> must be an integer.</li>
          <li>Let <i>n</i> be that integer.</li>
          <li>If <i>n</i>=0 or <i>n</i>&gt;<i>NcapturingParens</i>, throw a <b>SyntaxError</b> exception.</li>
          <li>Return an internal Matcher closure that takes two arguments, a State <i>x</i> and a Continuation <i>c</i>, and
              performs the following steps:
            <ol class="nested proc">
              <li>Let <i>cap</i> be <i>x</i>'s <i>captures</i> <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
              <li>Let <i>s</i> be <i>cap</i>[<i>n</i>].</li>
              <li>If <i>s</i> is <b>undefined</b>, return <i>c</i>(<i>x</i>).</li>
              <li>Let <i>e</i> be <i>x</i>'s <i>endIndex</i>.</li>
              <li>Let <i>len</i> be <i>s</i>'s length.</li>
              <li>Let <i>f</i> be <i>e</i>+<i>len</i>.</li>
              <li>If <i>f</i>&gt;<i>InputLength</i>, return <b>failure</b>.</li>
              <li>If there exists an integer <i>i</i> between 0 (inclusive) and <i>len</i> (exclusive) such that
                  Canonicalize(<i>s</i>[<i>i</i>]) is not the same character value as Canonicalize(<i>Input</i>
                  [<i>e</i>+<i>i</i>]), return <b>failure</b>.</li>
              <li>Let <i>y</i> be the State (<i>f</i>, <i>cap</i>).</li>
              <li><a href="sec-abstract-operations#sec-call">Call</a> <i>c</i>(<i>y</i>) and return its result.</li>
            </ol>
          </li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">AtomEscape</span> <span class="geq">::</span>
        <span class="nt">CharacterEscape</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Evaluate <i>CharacterEscape</i> to obtain a character <i>ch</i>.</li>
          <li>Let <i>A</i> be a one-element CharSet containing the character <i>ch</i>.</li>
          <li><a href="sec-abstract-operations#sec-call">Call</a> CharacterSetMatcher(<i>A</i>, <b>false</b>) and return its Matcher result.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">AtomEscape</span> <span class="geq">::</span>
        <span class="nt">CharacterClassEscape</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Evaluate <i>CharacterClassEscape</i> to obtain a CharSet <i>A</i>.</li>
          <li><a href="sec-abstract-operations#sec-call">Call</a> CharacterSetMatcher(<i>A</i>, <b>false</b>) and return its Matcher result.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> An escape sequence of the form <code>\</code> followed by a nonzero decimal number
          <var>n</var> matches the result of the <var>n</var>th set of capturing parentheses (see 0). It is an error if the
          regular expression has fewer than <var>n</var> capturing parentheses. If the regular expression has <var>n</var> or more
          capturing parentheses but the <var>n</var>th one is <b>undefined</b> because it has not captured anything, then the
          backreference always succeeds.</p>
        </div>
      </section>

      <section id="sec-characterescape">
        <h4 id="sec-21.2.2.10" title="21.2.2.10"> CharacterEscape</h4><p class="normalbefore">The production <span class="prod"><span class="nt">CharacterEscape</span> <span class="geq">::</span> <span class="nt">ControlEscape</span></span> evaluates by returning the character according to <a href="#table-47">Table 47</a>.</p>

        <figure>
          <figcaption><span id="table-47">Table 47</span> &mdash; ControlEscape Character Values</figcaption>
          <table class="real-table">
            <tr>
              <th>ControlEscape</th>
              <th>Character Value</th>
              <th>Code Point</th>
              <th>Unicode Name</th>
              <th>Symbol</th>
            </tr>
            <tr>
              <td><code>t</code></td>
              <td>9</td>
              <td><code>U+0009</code></td>
              <td>CHARACTER TABULATION</td>
              <td>&lt;HT&gt;</td>
            </tr>
            <tr>
              <td><code>n</code></td>
              <td>10</td>
              <td><code>U+000A</code></td>
              <td>LINE FEED (LF)</td>
              <td>&lt;LF&gt;</td>
            </tr>
            <tr>
              <td><code>v</code></td>
              <td>11</td>
              <td><code>U+000B</code></td>
              <td>LINE TABULATION</td>
              <td>&lt;VT&gt;</td>
            </tr>
            <tr>
              <td><code>f</code></td>
              <td>12</td>
              <td><code>U+000C</code></td>
              <td>FORM FEED (FF)</td>
              <td>&lt;FF&gt;</td>
            </tr>
            <tr>
              <td><code>r</code></td>
              <td>13</td>
              <td><code>U+000D</code></td>
              <td>CARRIAGE RETURN (CR)</td>
              <td>&lt;CR&gt;</td>
            </tr>
          </table>
        </figure>

        <p class="normalbefore">The production <span class="prod"><span class="nt">CharacterEscape</span> <span class="geq">::</span> <code class="t">c</code> <span class="nt">ControlLetter</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Let <i>ch</i> be the character matched by <i>ControlLetter</i>.</li>
          <li>Let <i>i</i> be <i>ch</i>'s character value.</li>
          <li>Let <i>j</i> be the remainder of dividing <i>i</i> by 32.</li>
          <li>Return the character whose character value is <i>j</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">CharacterEscape</span> <span class="geq">::</span> <span class="nt">HexEscapeSequence</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the character whose code is the SV of <i>HexEscapeSequence</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">CharacterEscape</span> <span class="geq">::</span> <span class="nt">RegExpUnicodeEscapeSequence</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the result of evaluating <i>RegExpUnicodeEscapeSequence</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">CharacterEscape</span> <span class="geq">::</span> <span class="nt">IdentityEscape</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the character matched by <i>IdentityEscape</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">RegExpUnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u</code> <span class="nt">LeadSurrogate</span> <code class="t">\u</code> <span class="nt">TrailSurrogate</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Let <i>lead</i> be the result of evaluating <i>LeadSurrogate</i>.</li>
          <li>Let <i>trail</i> be the result of evaluating <i>TrailSurrogate</i>.</li>
          <li>Let <i>cp</i> be <a href="sec-ecmascript-language-source-code#sec-utf16decode">UTF16Decode</a>(<i>lead</i>, <i>trail</i>).</li>
          <li>Return the character whose character value is <i>cp</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">RegExpUnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u</code> <span class="nt">LeadSurrogate</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the character whose code is the result of evaluating <i>LeadSurrogate</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">RegExpUnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u</code> <span class="nt">TrailSurrogate</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the character whose code is the result of evaluating <i>TrailSurrogate</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">RegExpUnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u</code> <span class="nt">NonSurrogate</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the character whose code is the result of evaluating <i>NonSurrogate</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">RegExpUnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u</code> <span class="nt">Hex4Digits</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the character whose code is the SV of <i>Hex4Digits</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">RegExpUnicodeEscapeSequence</span> <span class="geq">::</span> <code class="t">u{</code> <span class="nt">HexDigits</span> <code class="t">}</code></span>
        evaluates as follows:</p>

        <ol class="proc">
          <li>Return the character whose code is the MV of <i>HexDigits</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">LeadSurrogate</span> <span class="geq">::</span> <span class="nt">Hex4Digits</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the character whose code is the SV of <i>Hex4Digits</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">TrailSurrogate</span> <span class="geq">::</span> <span class="nt">Hex4Digits</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the character whose code is the SV of <i>Hex4Digits</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">NonSurrogate</span> <span class="geq">::</span>
        <span class="nt">Hex4Digits</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the character whose code is the SV of <i>Hex4Digits</i>.</li>
        </ol>
      </section>

      <section id="sec-decimalescape">
        <h4 id="sec-21.2.2.11" title="21.2.2.11">
            DecimalEscape</h4><p class="normalbefore">The production <span class="prod"><span class="nt">DecimalEscape</span> <span class="geq">::</span> <span class="nt">DecimalIntegerLiteral</span></span>  evaluates as follows:</p>

        <ol class="proc">
          <li>Let <i>i</i> be the MV of <i>DecimalIntegerLiteral</i>.</li>
          <li>If <i>i</i> is zero, return the EscapeValue consisting of the character U+0000 (NULL).</li>
          <li>Return the EscapeValue consisting of the integer <i>i</i>.</li>
        </ol>

        <p>The definition of &ldquo;the MV of <span class="nt">DecimalIntegerLiteral</span>&rdquo; is in <a href="sec-ecmascript-language-lexical-grammar#sec-literals-numeric-literals">11.8.3</a>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If <code>\</code> is followed by a decimal number <var>n</var> whose first digit is not
          <code>0</code>, then the escape sequence is considered to be a backreference. It is an error if <var>n</var> is greater
          than the total number of left capturing parentheses in the entire regular expression. <code>\0</code> represents the
          &lt;NUL&gt; character and cannot be followed by a decimal digit.</p>
        </div>
      </section>

      <section id="sec-characterclassescape">
        <h4 id="sec-21.2.2.12" title="21.2.2.12"> CharacterClassEscape</h4><p>The production <span class="prod"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <code class="t">d</code></span> evaluates by returning the ten-element set of characters containing the characters
        <code>0</code> through <code>9</code> inclusive.</p>

        <p>The production <span class="prod"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <code class="t">D</code></span> evaluates by returning the set of all characters not included in the set returned by <span class="prod"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <code class="t">d</code></span>
        .</p>

        <p>The production <span class="prod"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <code class="t">s</code></span> evaluates by returning the set of characters containing the characters that are on the
        right-hand side of the <span class="nt">WhiteSpace</span> (<a href="sec-ecmascript-language-lexical-grammar#sec-white-space">11.2</a>) or <span class="nt">LineTerminator</span> (<a href="sec-ecmascript-language-lexical-grammar#sec-line-terminators">11.3</a>) productions.</p>

        <p>The production <span class="prod"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <code class="t">S</code></span> evaluates by returning the set of all characters not included in the set returned by <span class="prod"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <code class="t">s</code></span>
        .</p>

        <p>The production <span class="prod"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <code class="t">w</code></span> evaluates by returning the set of characters containing the sixty-three characters:</p>

        <figure>
          <table class="lightweight-table">
            <tr>
              <td><code>a</code></td>
              <td><code>b</code></td>
              <td><code>c</code></td>
              <td><code>d</code></td>
              <td><code>e</code></td>
              <td><code>f</code></td>
              <td><code>g</code></td>
              <td><code>h</code></td>
              <td><code>i</code></td>
              <td><code>j</code></td>
              <td><code>k</code></td>
              <td><code>l</code></td>
              <td><code>m</code></td>
              <td><code>n</code></td>
              <td><code>o</code></td>
              <td><code>p</code></td>
              <td><code>q</code></td>
              <td><code>r</code></td>
              <td><code>s</code></td>
              <td><code>t</code></td>
              <td><code>u</code></td>
              <td><code>v</code></td>
              <td><code>w</code></td>
              <td><code>x</code></td>
              <td><code>y</code></td>
              <td><code>z</code></td>
            </tr>
            <tr>
              <td><code>A</code></td>
              <td><code>B</code></td>
              <td><code>C</code></td>
              <td><code>D</code></td>
              <td><code>E</code></td>
              <td><code>F</code></td>
              <td><code>G</code></td>
              <td><code>H</code></td>
              <td><code>I</code></td>
              <td><code>J</code></td>
              <td><code>K</code></td>
              <td><code>L</code></td>
              <td><code>M</code></td>
              <td><code>N</code></td>
              <td><code>O</code></td>
              <td><code>P</code></td>
              <td><code>Q</code></td>
              <td><code>R</code></td>
              <td><code>S</code></td>
              <td><code>T</code></td>
              <td><code>U</code></td>
              <td><code>V</code></td>
              <td><code>W</code></td>
              <td><code>X</code></td>
              <td><code>Y</code></td>
              <td><code>Z</code></td>
            </tr>
            <tr>
              <td><code>0</code></td>
              <td><code>1</code></td>
              <td><code>2</code></td>
              <td><code>3</code></td>
              <td><code>4</code></td>
              <td><code>5</code></td>
              <td><code>6</code></td>
              <td><code>7</code></td>
              <td><code>8</code></td>
              <td><code>9</code></td>
              <td><code>_</code></td>
              <td />
              <td />
              <td />
              <td />
              <td />
              <td />
              <td />
              <td />
              <td />
              <td />
              <td />
              <td />
              <td />
              <td />
              <td />
            </tr>
          </table>
        </figure>

        <p>The production <span class="prod"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <code class="t">W</code></span> evaluates by returning the set of all characters not included in the set returned by <span class="prod"><span class="nt">CharacterClassEscape</span> <span class="geq">::</span> <code class="t">w</code></span>
        .</p>
      </section>

      <section id="sec-characterclass">
        <h4 id="sec-21.2.2.13" title="21.2.2.13"> CharacterClass</h4><p>The production <span class="prod"><span class="nt">CharacterClass</span> <span class="geq">::</span> <code class="t">[</code> <span class="nt">ClassRanges</span> <code class="t">]</code></span> evaluates by evaluating <span class="nt">ClassRanges</span> to obtain a CharSet and returning that CharSet and the Boolean <b>false</b>.</p>

        <p>The production <span class="prod"><span class="nt">CharacterClass</span> <span class="geq">::</span> <code class="t">[</code> <code class="t">^</code> <span class="nt">ClassRanges</span> <code class="t">]</code></span> evaluates
        by evaluating <span class="nt">ClassRanges</span> to obtain a CharSet and returning that CharSet and the Boolean
        <b>true</b>.</p>
      </section>

      <section id="sec-classranges">
        <h4 id="sec-21.2.2.14" title="21.2.2.14">
            ClassRanges</h4><p>The production <span class="prod"><span class="nt">ClassRanges</span> <span class="geq">::</span> <span class="grhsannot">[empty]</span></span> evaluates by returning the empty CharSet.</p>

        <p>The production <span class="prod"><span class="nt">ClassRanges</span> <span class="geq">::</span> <span class="nt">NonemptyClassRanges</span></span> evaluates by evaluating <span class="nt">NonemptyClassRanges</span> to obtain
        a CharSet and returning that CharSet.</p>
      </section>

      <section id="sec-nonemptyclassranges">
        <div class="front">
          <h4 id="sec-21.2.2.15" title="21.2.2.15"> NonemptyClassRanges</h4><p class="normalbefore">The production <span class="prod"><span class="nt">NonemptyClassRanges</span> <span class="geq">::</span> <span class="nt">ClassAtom</span></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Return the CharSet that is the result of evaluating <i>ClassAtom</i>.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">NonemptyClassRanges</span> <span class="geq">::</span> <span class="nt">ClassAtom</span> <span class="nt">NonemptyClassRangesNoDash</span></span>
          evaluates as follows:</p>

          <ol class="proc">
            <li>Evaluate <i>ClassAtom</i> to obtain a CharSet <i>A</i>.</li>
            <li>Evaluate <i>NonemptyClassRangesNoDash</i> to obtain a CharSet <i>B</i>.</li>
            <li>Return the union of CharSets <i>A</i> and <i>B</i>.</li>
          </ol>

          <p class="normalbefore">The production <span class="prod"><span class="nt">NonemptyClassRanges</span> <span class="geq">::</span> <span class="nt">ClassAtom</span> <code class="t">-</code> <span class="nt">ClassAtom</span> <span class="nt">ClassRanges</span></span> evaluates as follows:</p>

          <ol class="proc">
            <li>Evaluate the first <i>ClassAtom</i> to obtain a CharSet <i>A</i>.</li>
            <li>Evaluate the second <i>ClassAtom</i> to obtain a CharSet <i>B</i>.</li>
            <li>Evaluate <i>ClassRanges</i> to obtain a CharSet <i>C</i>.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> CharacterRange(<i>A</i>, <i>B</i>) and let <i>D</i> be the resulting CharSet.</li>
            <li>Return the union of CharSets <i>D</i> and <i>C</i>.</li>
          </ol>
        </div>

        <section id="sec-runtime-semantics-characterrange-abstract-operation">
          <h5 id="sec-21.2.2.15.1" title="21.2.2.15.1"> Runtime Semantics: CharacterRange Abstract Operation</h5><p class="normalbefore">The abstract operation CharacterRange takes two CharSet parameters <var>A</var> and <var>B</var>
          and performs the following steps:</p>

          <ol class="proc">
            <li>If <i>A</i> does not contain exactly one character or <i>B</i> does not contain exactly one character, throw a
                <b>SyntaxError</b> exception.</li>
            <li>Let <i>a</i> be the one character in CharSet <i>A</i>.</li>
            <li>Let <i>b</i> be the one character in CharSet <i>B</i>.</li>
            <li>Let <i>i</i> be the character value of character <i>a</i>.</li>
            <li>Let <i>j</i> be the character value of character <i>b</i>.</li>
            <li>If <i>i</i> &gt; <i>j</i>, throw a <b>SyntaxError</b> exception.</li>
            <li>Return the set containing all characters numbered <i>i</i> through <i>j</i>, inclusive.</li>
          </ol>
        </section>
      </section>

      <section id="sec-nonemptyclassrangesnodash">
        <h4 id="sec-21.2.2.16" title="21.2.2.16"> NonemptyClassRangesNoDash</h4><p class="normalbefore">The production <span class="prod"><span class="nt">NonemptyClassRangesNoDash</span> <span class="geq">::</span> <span class="nt">ClassAtom</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the CharSet that is the result of evaluating <i>ClassAtom</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">NonemptyClassRangesNoDash</span> <span class="geq">::</span> <span class="nt">ClassAtomNoDash</span> <span class="nt">NonemptyClassRangesNoDash</span></span>
        evaluates as follows:</p>

        <ol class="proc">
          <li>Evaluate <i>ClassAtomNoDash</i> to obtain a CharSet <i>A</i>.</li>
          <li>Evaluate <i>NonemptyClassRangesNoDash</i> to obtain a CharSet <i>B</i>.</li>
          <li>Return the union of CharSets <i>A</i> and <i>B</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">NonemptyClassRangesNoDash</span> <span class="geq">::</span> <span class="nt">ClassAtomNoDash</span> <code class="t">-</code> <span class="nt">ClassAtom</span>
        <span class="nt">ClassRanges</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Evaluate <i>ClassAtomNoDash</i> to obtain a CharSet <i>A</i>.</li>
          <li>Evaluate <i>ClassAtom</i> to obtain a CharSet <i>B</i>.</li>
          <li>Evaluate <i>ClassRanges</i> to obtain a CharSet <i>C</i>.</li>
          <li><a href="sec-abstract-operations#sec-call">Call</a> CharacterRange(<i>A</i>, <i>B</i>) and let <i>D</i> be the resulting CharSet.</li>
          <li>Return the union of CharSets <i>D</i> and <i>C</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 1</span> <span class="nt">ClassRanges</span> can expand into a single <span class="nt">ClassAtom</span> and/or ranges of two <span class="nt">ClassAtom</span>
          separated by dashes. In the latter case the <span class="nt">ClassRanges</span> includes all characters between the first <span class="nt">ClassAtom</span> and the
          second <span class="nt">ClassAtom</span>, inclusive; an error occurs if either <span class="nt">ClassAtom</span> does not represent a single character (for example, if
          one is \w) or if the first <span class="nt">ClassAtom</span>'s character value is greater than the second <span class="nt">ClassAtom</span>'s character value.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> Even if the pattern ignores case, the case of the two ends of a range is significant
          in determining which characters belong to the range. Thus, for example, the pattern <code>/[E-F]/i</code> matches only
          the letters <code>E</code>, <code>F</code>, <code>e</code>, and <code>f</code>, while the pattern <code>/[E-f]/i</code>
          matches all upper and lower-case letters in the Unicode Basic Latin block as well as the symbols <code>[</code>,
          <code>\</code>, <code>]</code>, <code>^</code>, <code>_</code>, and <code>`</code>.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> A <code>-</code> character can be treated literally or it can denote a range. It is
          treated literally if it is the first or last character of <span class="nt">ClassRanges</span>, the beginning or end
          limit of a range specification, or immediately follows a range specification.</p>
        </div>
      </section>

      <section id="sec-classatom">
        <h4 id="sec-21.2.2.17" title="21.2.2.17">
            ClassAtom</h4><p>The production <span class="prod"><span class="nt">ClassAtom</span> <span class="geq">::</span> <code class="t">-</code></span> evaluates by returning the CharSet containing the one character <code>-</code>.</p>

        <p>The production <span class="prod"><span class="nt">ClassAtom</span> <span class="geq">::</span> <span class="nt">ClassAtomNoDash</span></span> evaluates by evaluating <span class="nt">ClassAtomNoDash</span> to obtain a
        CharSet and returning that CharSet.</p>
      </section>

      <section id="sec-classatomnodash">
        <h4 id="sec-21.2.2.18" title="21.2.2.18"> ClassAtomNoDash</h4><p class="normalbefore">The production <span class="prod"><span class="nt">ClassAtomNoDash</span> <span class="geq">::</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">\</code> <span class="grhsmod">or</span> <code class="t">]</code> <span class="grhsmod">or</span> <code class="t">-</code></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the CharSet containing the character matched by <i>SourceCharacter</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">ClassAtomNoDash</span> <span class="geq">::</span> <code class="t">\</code> <span class="nt">ClassEscape</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the CharSet that is the result of evaluating <i>ClassEscape</i>.</li>
        </ol>
      </section>

      <section id="sec-classescape">
        <h4 id="sec-21.2.2.19" title="21.2.2.19">
            ClassEscape</h4><p class="normalbefore">The production <span class="prod"><span class="nt">ClassEscape</span> <span class="geq">::</span>
        <span class="nt">DecimalEscape</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Evaluate <i>DecimalEscape</i> to obtain an EscapeValue <i>E</i>.</li>
          <li>If <i>E</i> is not a character, throw a <b>SyntaxError</b> exception.</li>
          <li>Let <i>ch</i> be <i>E</i>'s character.</li>
          <li>Return the one-element CharSet containing the character <i>ch</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">ClassEscape</span> <span class="geq">::</span>
        <code class="t">b</code></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the CharSet containing the single character &lt;BS&gt; U+0008 (BACKSPACE).</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">ClassEscape</span> <span class="geq">::</span>
        <code class="t">-</code></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the CharSet containing the single character - U+002D (HYPEN-MINUS).</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">ClassEscape</span> <span class="geq">::</span>
        <span class="nt">CharacterEscape</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the CharSet containing the single character that is the result of evaluating <i>CharacterEscape</i>.</li>
        </ol>

        <p class="normalbefore">The production <span class="prod"><span class="nt">ClassEscape</span> <span class="geq">::</span>
        <span class="nt">CharacterClassEscape</span></span> evaluates as follows:</p>

        <ol class="proc">
          <li>Return the CharSet that is the result of evaluating <i>CharacterClassEscape</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> A <span class="nt">ClassAtom</span> can use any of the escape sequences that are allowed
          in the rest of the regular expression except for <code>\b</code>, <code>\B</code>, and backreferences. Inside a <span class="nt">CharacterClass</span>, <code>\b</code> means the backspace character, while <code>\B</code> and
          backreferences raise errors. Using a backreference inside a <span class="nt">ClassAtom</span> causes an error.</p>
        </div>
      </section>
    </section>

    <section id="sec-regexp-constructor">
      <div class="front">
        <h3 id="sec-21.2.3" title="21.2.3">
            The RegExp Constructor</h3><p>The RegExp constructor is the %RegExp% intrinsic object and the initial value of the <code>RegExp</code> property of
        the global object. When <code>RegExp</code> is called as a function rather than as a constructor, it creates and
        initializes a new RegExp object. Thus the function call <code><b>RegExp(</b>&hellip;<b>)</b></code> is equivalent to the
        object creation expression <code><b>new&nbsp;RegExp(</b>&hellip;<b>)</b></code> with the same arguments.</p>

        <p>The <code>RegExp</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>RegExp</code> behaviour must include a <code>super</code> call to the <code>RegExp</code> constructor to create and
        initialize subclass instances with the necessary internal slots.</p>
      </div>

      <section id="sec-regexp-pattern-flags">
        <h4 id="sec-21.2.3.1" title="21.2.3.1"> RegExp ( pattern, flags )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>patternIsRegExp</i> be <a href="sec-abstract-operations#sec-isregexp">IsRegExp</a>(<i>pattern</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>patternIsRegExp</i>).</li>
          <li>If NewTarget is not <b>undefined</b>, let <i>newTarget</i> be NewTarget.</li>
          <li>Else,
            <ol class="block">
              <li>Let <i>newTarget</i> be the active function object.</li>
              <li>If <i>patternIsRegExp</i> is <b>true</b> and <i>flags</i> is <b>undefined</b>, then
                <ol class="block">
                  <li>Let <i>patternConstructor</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>pattern</i>,
                      <code>"constructor"</code>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>patternConstructor</i>).</li>
                  <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>newTarget</i>, <i>patternConstructor</i>) is <b>true</b>,
                      return <i>pattern</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>pattern</i>) is Object and <i>pattern</i> has a
              [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, then
            <ol class="block">
              <li>Let <i>P</i> be the value of <i>pattern&rsquo;s</i> [[OriginalSource]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
              <li>If <i>flags</i> is <b>undefined</b>, let <i>F</i> be the value of <i>pattern&rsquo;s</i> [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
              <li>Else, let <i>F</i> be <i>flags</i>.</li>
            </ol>
          </li>
          <li>Else if <i>patternIsRegExp</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>P</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>pattern</i>, <code>"source"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>P</i>).</li>
              <li>If <i>flags</i> is <b>undefined</b>, then
                <ol class="block">
                  <li>Let <i>F</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>pattern</i>, <code>"flags"</code>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>F</i>).</li>
                </ol>
              </li>
              <li>Else, let <i>F</i> be <i>flags</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>P</i> be <i>pattern</i>.</li>
              <li>Let <i>F</i> be <i>flags</i>.</li>
            </ol>
          </li>
          <li>Let <i>O</i> be <a href="#sec-regexpalloc">RegExpAlloc</a>(<i>newTarget</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Return <a href="#sec-regexpinitialize">RegExpInitialize</a>(<i>O,</i> <i>P</i>, <i>F</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> If pattern is supplied using a <span class="nt">StringLiteral</span>, the usual escape
          sequence substitutions are performed before the String is processed by RegExp. If pattern must contain an escape
          sequence to be recognized by RegExp, any U+005C (REVERSE SOLIDUS) code points must be escaped within the <span class="nt">StringLiteral</span> to prevent them being removed when the contents of the <span class="nt">StringLiteral</span> are formed.</p>
        </div>
      </section>

      <section id="sec-abstract-operations-for-the-regexp-constructor">
        <div class="front">
          <h4 id="sec-21.2.3.2" title="21.2.3.2"> Abstract Operations for the RegExp Constructor</h4></div>

        <section id="sec-regexpalloc">
          <h5 id="sec-21.2.3.2.1" title="21.2.3.2.1"> Runtime Semantics: RegExpAlloc ( newTarget )</h5><p class="normalbefore">When the abstract operation RegExpAlloc with argument <var>newTarget</var> is called, the
          following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>obj</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(<i>newTarget</i>,
                <code>"%RegExpPrototype%"</code>, &laquo;&zwj;[[RegExpMatcher]], [[OriginalSource]],
                [[OriginalFlags]]&raquo;).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>obj</i>).</li>
            <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>obj</i>,
                <code>"lastIndex"</code>, PropertyDescriptor {[[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>,
                [[Configurable]]: <b>false</b>}).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
            <li>Return <i>obj</i>.</li>
          </ol>
        </section>

        <section id="sec-regexpinitialize">
          <h5 id="sec-21.2.3.2.2" title="21.2.3.2.2"> Runtime Semantics: RegExpInitialize ( obj, pattern, flags )</h5><p class="normalbefore">When the abstract operation RegExpInitialize with arguments <i><span style="font-family: Times           New Roman">obj</span>,</i> <var>pattern</var>, and <var>flags</var> is called, the following steps are taken:</p>

          <ol class="proc">
            <li>If <i>pattern</i> is <b>undefined</b>, let <i>P</i> be the empty String.</li>
            <li>Else, let <i>P</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>pattern</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>P</i>).</li>
            <li>If <i>flags</i> is <b>undefined</b>, let <i>F</i> be the empty String.</li>
            <li>Else, let <i>F</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>flags</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>F</i>).</li>
            <li>If <i>F</i> contains any code unit other than <code>"g"</code>, <code>"i"</code>, <code>"m"</code>,
                <code>"u"</code>, or <code>"y"</code> or if it contains the same code unit more than once, throw a
                <b>SyntaxError</b> exception.</li>
            <li>If <i>F</i> contains <code>"u"</code>, let <i>BMP</i> be <b>false</b>; else let <i>BMP</i> be <b>true</b>.</li>
            <li>If <i>BMP</i> is <b>true</b>, then
              <ol class="block">
                <li>Parse <i>P</i> using the grammars in <a href="#sec-patterns">21.2.1</a> and interpreting each of its 16-bit
                    elements as a Unicode BMP code point. UTF-16 decoding is not applied to the elements. The goal symbol for the
                    parse is <i>Pattern</i>. Throw a <b>SyntaxError</b> exception if <i>P</i> did not conform to the grammar, if
                    any elements of <i>P</i> were not matched by the parse, or if any Early Error conditions exist.</li>
                <li>Let <i>patternCharacters</i>  be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose elements
                    are the code unit elements of <i>P.</i></li>
              </ol>
            </li>
            <li>Else
              <ol class="block">
                <li>Parse <i>P</i> using the grammars in <a href="#sec-patterns">21.2.1</a> and interpreting  <i>P</i> as UTF-16
                    encoded Unicode code points (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>). The goal symbol
                    for the parse is <i>Pattern</i><sub>[U]</sub>. Throw a <b>SyntaxError</b> exception if <i>P</i> did not
                    conform to the grammar, if any elements of <i>P</i> were not matched by the parse, or if any Early Error
                    conditions exist.</li>
                <li>Let <i>patternCharacters</i>  be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose elements
                    are the code points resulting from applying UTF-16 decoding to <i>P</i>&rsquo;s sequence of elements.</li>
              </ol>
            </li>
            <li>Set the value of <i>obj&rsquo;s</i> [[OriginalSource]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <i>P</i>.</li>
            <li>Set the value of <i>obj&rsquo;s</i> [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <i>F</i>.</li>
            <li>Set <i>obj&rsquo;s</i> [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                slot</a> to the internal procedure that evaluates the above parse of <i>P</i> by applying the semantics provided
                in <a href="#sec-pattern-semantics">21.2.2</a> using <i>patternCharacters</i> as the pattern&rsquo;s <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <i>SourceCharacter</i> values and <i>F</i> as the flag
                parameters.</li>
            <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>obj</i>, <code>"lastIndex"</code>, 0,
                <b>true</b>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
            <li>Return <i>obj</i>.</li>
          </ol>
        </section>

        <section id="sec-regexpcreate">
          <h5 id="sec-21.2.3.2.3" title="21.2.3.2.3"> Runtime Semantics: RegExpCreate ( P, F )</h5><p class="normalbefore">When the abstract operation RegExpCreate with arguments <var>P</var> and <var>F</var> is called,
          the following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>obj</i> be <a href="#sec-regexpalloc">RegExpAlloc</a>(%RegExp%).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>obj</i>).</li>
            <li>Return <a href="#sec-regexpinitialize">RegExpInitialize</a>(<i>obj,</i> <i>P</i>, <i>F</i>).</li>
          </ol>
        </section>

        <section id="sec-escaperegexppattern">
          <h5 id="sec-21.2.3.2.4" title="21.2.3.2.4"> Runtime Semantics: EscapeRegExpPattern ( P, F )</h5><p>When the abstract operation EscapeRegExpPattern with arguments <var>P</var> and <var>F</var> is called, the following
          occurs:</p>

          <ol class="proc">
            <li>Let <i>S</i> be a String in the form of a <i>Pattern</i> (<i>Pattern</i><sub>[U]</sub> if <i>F</i> contains
                <code>"u"</code><span style="font-family: sans-serif">)</span> equivalent to <i>P</i> interpreted as UTF-16
                encoded Unicode code points (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>), in which certain
                code points are escaped as described below. <i>S</i> may or may not be identical to <i>P</i>; however, the
                internal procedure that would result from evaluating <i>S</i> as a <i>Pattern</i> (<i>Pattern</i><sub>[U]</sub> if
                <i>F</i> contains <code>"u"</code><span style="font-family: sans-serif">)</span> must behave identically to the
                internal procedure given by the constructed object's [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>. Multiple calls to this abstract
                operation using the same values for <i>P</i> and <i>F</i> must produce identical results.</li>
            <li>The code points <code>/</code> or any <i>LineTerminator</i> occurring in the pattern shall be escaped in <i>S</i>
                as necessary to ensure that the String value formed by concatenating the Strings <code>"/"</code>, <i>S</i>,
                <code>"/"</code>, and <i>F</i> can be parsed (in an appropriate lexical context) as a
                <i>RegularExpressionLiteral</i> that behaves identically to the constructed regular expression. For example, if
                <i>P</i> is <code>"/"</code>, then <i>S</i> could be <code>"\/"</code> or <code>"\u002F"</code>, among other
                possibilities, but not <code>"/"</code>, because <code>///</code> followed by <i>F</i> would be parsed as a
                <i>SingleLineComment</i> rather than a <i>RegularExpressionLiteral</i>. If <i>P</i> is the empty String, this
                specification can be met by letting <i>S</i> be <code>"(?:)"</code>.</li>
            <li>Return <i>S</i>.</li>
          </ol>
        </section>
      </section>
    </section>

    <section id="sec-properties-of-the-regexp-constructor">
      <div class="front">
        <h3 id="sec-21.2.4" title="21.2.4"> Properties of the RegExp Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        RegExp constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is <b>2</b>), the RegExp constructor has the following
        properties:</p>
      </div>

      <section id="sec-regexp.prototype">
        <h4 id="sec-21.2.4.1" title="21.2.4.1"> RegExp.prototype</h4><p>The initial value of <code>RegExp.prototype</code> is the intrinsic object %RegExpPrototype% (<a href="#sec-properties-of-the-regexp-prototype-object">21.2.5</a>).</p>

        <p>This property has the attributes {&nbsp;[[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b>&nbsp;}.</p>
      </section>

      <section id="sec-get-regexp-@@species">
        <h4 id="sec-21.2.4.2" title="21.2.4.2"> get RegExp [ @@species ]</h4><p class="normalbefore"><code>RegExp[@@species]</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Return the <b>this</b> value.</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"get [Symbol.species]"</code>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> RegExp prototype methods normally use their <code>this</code> object&rsquo;s constructor
          to create a derived object. However, a subclass constructor may over-ride that default behaviour by redefining its
          @@species property.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-regexp-prototype-object">
      <div class="front">
        <h3 id="sec-21.2.5" title="21.2.5"> Properties of the RegExp Prototype Object</h3><p>The RegExp prototype object is the intrinsic object %RegExpPrototype%. The RegExp prototype object is an ordinary
        object. It is not a RegExp instance and does not have a [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> or any of the other internal slots of RegExp
        instance objects.</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        RegExp prototype object is the intrinsic object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>).</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The RegExp prototype object does not have a <code>valueOf</code> property of its own;
          however, it inherits the <code>valueOf</code> property from the Object prototype object.</p>
        </div>
      </div>

      <section id="sec-regexp.prototype.constructor">
        <h4 id="sec-21.2.5.1" title="21.2.5.1"> RegExp.prototype.constructor</h4><p>The initial value of <code>RegExp.prototype.constructor</code> is the intrinsic object %RegExp%.</p>
      </section>

      <section id="sec-regexp.prototype.exec">
        <div class="front">
          <h4 id="sec-21.2.5.2" title="21.2.5.2"> RegExp.prototype.exec ( string )</h4><p>Performs a regular expression match of <var>string</var> against the regular expression and returns an Array object
          containing the results of the match, or <b>null</b> if <var>string</var> did not match.</p>

          <p class="normalbefore">The String <span style="font-family: Times New Roman"><a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>string</i>)</span> is searched for an occurrence of the regular expression pattern
          as follows:</p>

          <ol class="proc">
            <li>Let <i>R</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>If <i>R</i> does not have a [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                slot</a>, throw a <b>TypeError</b> exception.</li>
            <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>string</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
            <li>Return <a href="#sec-regexpbuiltinexec">RegExpBuiltinExec</a>(<i>R</i>, <i>S</i>).</li>
          </ol>
        </div>

        <section id="sec-regexpexec">
          <h5 id="sec-21.2.5.2.1" title="21.2.5.2.1"> Runtime Semantics: RegExpExec ( R, S )</h5><p class="normalbefore">The abstract operation RegExpExec with arguments <var>R</var> and <var>S</var> performs the
          following steps:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is Object.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is String.</li>
            <li>Let <i>exec</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>, <code>"<b>exec"</b></code>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exec</i>).</li>
            <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>exec</i>) is <b>true</b>, then
              <ol class="block">
                <li>Let <i>result</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>exec</i>, <i>R</i>, &laquo;<i>S</i>&raquo;).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
                <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>result</i>) is neither Object or Null, throw a
                    <b>TypeError</b> exception.</li>
                <li>Return <i>result</i>.</li>
              </ol>
            </li>
            <li>If <i>R</i> does not have a [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                slot</a>, throw a <b>TypeError</b> exception.</li>
            <li>Return <a href="#sec-regexpbuiltinexec">RegExpBuiltinExec</a>(<i>R</i>, <i>S</i>).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> If a callable <code>exec</code> property is not found this algorithm falls back to
            attempting to use the built-in RegExp matching algorithm. This provides compatible behaviour for code written for
            prior editions where most built-in algorithms that use regular expressions did not perform a dynamic property lookup
            of <code>exec</code>.</p>
          </div>
        </section>

        <section id="sec-regexpbuiltinexec">
          <h5 id="sec-21.2.5.2.2" title="21.2.5.2.2"> Runtime Semantics: RegExpBuiltinExec ( R, S )</h5><p class="normalbefore">The abstract operation RegExpBuiltinExec with arguments <var>R</var> and <var>S</var> performs
          the following steps:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>R</i> is an initialized RegExp instance.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is String.</li>
            <li>Let <i>length</i> be the number of code units in <i>S</i>.</li>
            <li>Let <i>lastIndex</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>,<code>"<b>lastIndex</b>"</code>)).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lastIndex</i>).</li>
            <li>Let <i>global</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>,
                <code>"<b>global"</b></code>)).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>global</i>).</li>
            <li>Let <i>sticky</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>,
                <code>"<b>sticky"</b></code>)).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>sticky</i>).</li>
            <li>If <i>global</i> is <b>false</b> and <i>sticky</i> is <b>false</b>, let <i>lastIndex</i> be 0.</li>
            <li>Let <i>matcher</i> be the value of <i>R&rsquo;s</i> [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>flags</i> be the value of <i>R&rsquo;s</i> [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <i>flags</i> contains <code>"u"</code>, let <i>fullUnicode</i> be <b>true</b>, else let <i>fullUnicode</i> be
                <b>false.</b></li>
            <li>Let <i>matchSucceeded</i> be <b>false</b>.</li>
            <li>Repeat, while <i>matchSucceeded</i> is <b>false</b>
              <ol class="block">
                <li>If <i>lastIndex</i> &gt; <i>length</i>, then
                  <ol class="block">
                    <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>R</i>, <code>"<b>lastIndex"</b></code>,
                        0, <b>true</b>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                    <li>Return <b>null</b>.</li>
                  </ol>
                </li>
                <li>Let <i>r</i> be <i>matcher</i>(<i>S</i>, <i>lastIndex</i>).</li>
                <li>If <i>r</i> is <b>failure</b>, then
                  <ol class="block">
                    <li>If <i>sticky</i> is <b>true</b>, then
                      <ol class="block">
                        <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>R</i>,
                            <code>"<b>lastIndex"</b></code>, 0, <b>true</b>).</li>
                        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                        <li>Return <b>null</b>.</li>
                      </ol>
                    </li>
                    <li>Let <i>lastIndex</i> be <a href="#sec-advancestringindex">AdvanceStringIndex</a>(<i>S</i>,
                        <i>lastIndex</i>, <i>fullUnicode</i>).</li>
                  </ol>
                </li>
                <li>Else,
                  <ol class="block">
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>r</i> is a State.</li>
                    <li>Set <i>matchSucceeded</i> to <b>true</b>.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Let <i>e</i> be <i>r</i>'s <i>endIndex</i> value.</li>
            <li>If <i>fullUnicode</i> is <b>true</b>, then
              <ol class="block">
                <li><i>e</i> is an index into the <i>Input</i> character list, derived from <i>S</i>, matched by <i>matcher</i>.
                    Let <i>eUTF</i>  be the smallest index into <i>S</i> that corresponds to the character at element <i>e</i> of
                    <i>Input</i>. If <i>e</i> is greater than or equal to the length of <i>Input</i>, then <i>eUTF</i> is the
                    number of code units in <i>S.</i></li>
                <li>Let <i>e</i> be <i>eUTF</i>.</li>
              </ol>
            </li>
            <li>If <i>global</i> is <b>true</b> or <i>sticky</i> is <b>true</b>,
              <ol class="block">
                <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>R</i>, <code>"<b>lastIndex"</b></code>,
                    <i>e</i>, <b>true</b>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
              </ol>
            </li>
            <li>Let <i>n</i> be the length of <i>r</i>'s <i>captures</i> <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>. (This is the same value as <a href="#sec-notation">21.2.2.1</a>'s <i>NcapturingParens</i>.)</li>
            <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(<i>n</i> + 1).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The value of <i>A</i>&rsquo;s <code>"<b>length"</b></code>
                property is <i>n</i> + 1.</li>
            <li>Let <i>matchIndex</i> be <i>lastIndex</i>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The following <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a> calls will not result in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
            <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <code>"<b>index"</b></code>,
                <i>matchIndex</i>).</li>
            <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <code>"<b>input"</b></code>,
                <i>S</i>).</li>
            <li>Let <i>matchedSubstr</i> be the matched substring (i.e. the portion of <i>S</i> between offset <i>lastIndex</i>
                inclusive and offset <i>e</i> exclusive).</li>
            <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <code>"<b>0"</b></code>,
                <i>matchedSubstr</i>).</li>
            <li>For each integer <i>i</i> such that <i>i</i> &gt; 0 and <i>i</i> &le; <i>n</i>
              <ol class="block">
                <li>Let <i>captureI</i> be <i>i</i><sup>th</sup> element of <i>r</i>'s <i>captures</i> <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
                <li>If <i>captureI</i> is <b>undefined</b>, let <i>capturedValue</i> be <b>undefined</b>.</li>
                <li>Else if <i>fullUnicode</i> is <b>true</b>,
                  <ol class="block">
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>captureI</i> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of code points.</li>
                    <li>Let <i>capturedValue</i> be a string whose code units are the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> <span style="font-family: sans-serif">(<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>)</span> of the code points of <i>captureI.</i></li>
                  </ol>
                </li>
                <li>Else, <i>fullUnicode</i> is <b>false</b>,
                  <ol class="block">
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>captureI</i> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of code units.</li>
                    <li>Let <i>capturedValue</i> be a string consisting of the code units of <i>captureI.</i></li>
                  </ol>
                </li>
                <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>i</i>) , <i>capturedValue</i>).</li>
              </ol>
            </li>
            <li>Return <i>A</i>.</li>
          </ol>
        </section>

        <section id="sec-advancestringindex">
          <h5 id="sec-21.2.5.2.3" title="21.2.5.2.3"> AdvanceStringIndex ( S, index, unicode )</h5><p class="normalbefore">The abstract operation AdvanceStringIndex with arguments <var>S</var>, <var>index</var>, and
          <var>unicode</var> performs the following steps:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is String.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>index</i> is an integer such that
                0&le;<i>index</i>&le;2<sup>53</sup>-1.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>unicode</i>) is Boolean.</li>
            <li>If <i>unicode</i> is <b>false</b>, return <i>index</i>+1.</li>
            <li>Let <i>length</i> be the number of code units in <i>S</i>.</li>
            <li>If <i>index</i>+1 &ge; <i>length</i>, return <i>index</i>+1.</li>
            <li>Let <i>first</i> be the code unit value at index <i>index</i> in <i>S</i>.</li>
            <li>If <i>first</i> &lt; 0xD800 or <i>first</i> &gt; 0xDBFF, return <i>index</i>+1.</li>
            <li>Let <i>second</i> be the code unit value at index <i>index</i>+1 in <i>S</i>.</li>
            <li>If <i>second</i> &lt; 0xDC00 or <i>second</i> &gt; 0xDFFF, return <i>index</i>+1.</li>
            <li>Return <i>index</i>+2.</li>
          </ol>
        </section>
      </section>

      <section id="sec-get-regexp.prototype.flags">
        <h4 id="sec-21.2.5.3" title="21.2.5.3"> get RegExp.prototype.flags</h4><p class="normalbefore"><code>RegExp.prototype.flags</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>R</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>result</i> be the empty String.</li>
          <li>Let <i>global</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>,
              <code>"global"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>global</i>).</li>
          <li>If <i>global</i> is <b>true</b>, append <code>"g"</code> as the last code unit of <i>result</i>.</li>
          <li>Let <i>ignoreCase</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>,
              <code>"ignoreCase"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>ignoreCase</i>).</li>
          <li>If <i>ignoreCase</i> is <b>true</b>, append <code>"i"</code> as the last code unit of <i>result</i>.</li>
          <li>Let <i>multiline</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>,
              <code>"multiline"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>multiline</i>).</li>
          <li>If <i>multiline</i> is <b>true</b>, append <code>"m"</code> as the last code unit of <i>result</i>.</li>
          <li>Let <i>unicode</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>,
              <code>"unicode"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>unicode</i>).</li>
          <li>If <i>unicode</i> is <b>true</b>, append <code>"u"</code> as the last code unit of <i>result</i>.</li>
          <li>Let <i>sticky</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>,
              <code>"sticky"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>sticky</i>).</li>
          <li>If <i>sticky</i> is <b>true</b>, append <code>"y"</code> as the last code unit of <i>result</i>.</li>
          <li>Return <i>result</i>.</li>
        </ol>
      </section>

      <section id="sec-get-regexp.prototype.global">
        <h4 id="sec-21.2.5.4" title="21.2.5.4"> get RegExp.prototype.global</h4><p class="normalbefore"><code>RegExp.prototype.global</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>R</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>R</i> does not have an [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>flags</i> be the value of <i>R&rsquo;s</i> [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>flags</i> contains the code unit <code>"g"</code>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-get-regexp.prototype.ignorecase">
        <h4 id="sec-21.2.5.5" title="21.2.5.5"> get RegExp.prototype.ignoreCase</h4><p class="normalbefore"><code>RegExp.prototype.ignoreCase</code> is an accessor property whose set accessor function is
        <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>R</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>R</i> does not have an [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>flags</i> be the value of <i>R&rsquo;s</i> [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>flags</i> contains the code unit <code>"i"</code>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-regexp.prototype-@@match">
        <h4 id="sec-21.2.5.6" title="21.2.5.6"> RegExp.prototype [ @@match ] ( string )</h4><p class="normalbefore">When the @@<code>match</code> method is called with argument <var>string</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>rx</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>rx</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>string</i>)</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>global</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>rx</i>,
              <code>"global"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>global</i>).</li>
          <li>If <i>global</i> is <b>false</b>, then
            <ol class="block">
              <li>Return <a href="#sec-regexpexec">RegExpExec</a>(<i>rx</i>, <i>S</i>).</li>
            </ol>
          </li>
          <li>Else <i>global</i> is <b>true</b>,
            <ol class="block">
              <li>Let <i>fullUnicode</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>rx</i>,
                  <code>"unicode"</code>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fullUnicode</i>).</li>
              <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>rx</i>, <code>"lastIndex"</code>, 0,
                  <b>true</b>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
              <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0).</li>
              <li>Let <i>n</i> be 0.</li>
              <li>Repeat,
                <ol class="block">
                  <li>Let <i>result</i> be <a href="#sec-regexpexec">RegExpExec</a>(<i>rx</i>, <i>S</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
                  <li>If <i>result</i> is <b>null</b>, then
                    <ol class="block">
                      <li>If <i>n</i>=0, return <b>null</b>.</li>
                      <li>Else, return <i>A</i>.</li>
                    </ol>
                  </li>
                  <li>Else <i>result</i> is not <b>null</b>,
                    <ol class="block">
                      <li>Let <i>matchStr</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>result</i>, <code>"0"</code>)).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>matchStr</i>).</li>
                      <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>n</i>), <i>matchStr</i>).</li>
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>status</i> is <b>true</b>.</li>
                      <li>If <i>matchStr</i> is the empty String, then
                        <ol class="block">
                          <li>Let <i>thisIndex</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>rx</i>, <code>"lastIndex"</code>)).</li>
                          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>thisIndex</i>).</li>
                          <li>Let <i>nextIndex</i> be <a href="#sec-advancestringindex">AdvanceStringIndex</a>(<i>S</i>,
                              <i>thisIndex</i>, <i>fullUnicode</i>).</li>
                          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>rx</i>, <code>"lastIndex"</code>,
                              <i>nextIndex</i>, <b>true</b>).</li>
                          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                        </ol>
                      </li>
                      <li>Increment <i>n</i>.</li>
                    </ol>
                  </li>
                </ol>
              </li>
            </ol>
          </li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"[Symbol.match]"</code>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The @@match property is used by the <a href="sec-abstract-operations#sec-isregexp">IsRegExp</a> abstract
          operation to identify objects that have the basic behaviour of regular expressions. The absence of a @@match property or
          the existence of such a property whose value does not Boolean coerce to <span class="value">true</span> indicates that
          the object is not intended to be used as a regular expression object.</p>
        </div>
      </section>

      <section id="sec-get-regexp.prototype.multiline">
        <h4 id="sec-21.2.5.7" title="21.2.5.7"> get RegExp.prototype.multiline</h4><p class="normalbefore"><code>RegExp.prototype.multiline</code> is an accessor property whose set accessor function is
        <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>R</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>R</i> does not have an [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>flags</i> be the value of <i>R&rsquo;s</i> [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>flags</i> contains the code unit <code>"m"</code>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-regexp.prototype-@@replace">
        <h4 id="sec-21.2.5.8" title="21.2.5.8"> RegExp.prototype [ @@replace ] ( string, replaceValue )</h4><p class="normalbefore">When the @@<code>replace</code> method is called with arguments <var>string</var> and
        <var>replaceValue</var> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>rx</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>rx</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>string</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>lengthS</i> be the number of code unit elements in <i>S</i>.</li>
          <li>Let <i>functionalReplace</i> be <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>replaceValue</i>).</li>
          <li>If <i>functionalReplace</i> is <b>false</b>, then
            <ol class="block">
              <li>Let <i>replaceValue</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>replaceValue</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>replaceValue</i>).</li>
            </ol>
          </li>
          <li>Let <i>global</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>rx</i>,
              <code>"global"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>global</i>).</li>
          <li>If <i>global</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>fullUnicode</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>rx</i>,
                  <code>"unicode"</code>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fullUnicode</i>).</li>
              <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>rx</i>, <code>"lastIndex"</code>, 0,
                  <b>true</b>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
            </ol>
          </li>
          <li>Let <i>results</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>done</i> be <b>false</b>.</li>
          <li>Repeat, while <i>done</i> is <b>false</b>
            <ol class="block">
              <li>Let <i>result</i> be <a href="#sec-regexpexec">RegExpExec</a>(<i>rx</i>, <i>S</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
              <li>If <i>result</i> is <b>null</b>, set <i>done</i> to <b>true</b>.</li>
              <li>Else <i>result</i> is not <b>null</b>,
                <ol class="block">
                  <li>Append <i>result</i> to the end of <i>results</i>.</li>
                  <li>If <i>global</i> is <b>false</b>, set <i>done</i> to <b>true</b>.</li>
                  <li>Else,
                    <ol class="block">
                      <li>Let <i>matchStr</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>result</i>, <code>"0"</code>)).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>matchStr</i>).</li>
                      <li>If <i>matchStr</i> is the empty String, then
                        <ol class="block">
                          <li>Let <i>thisIndex</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>rx</i>, <code>"lastIndex"</code>)).</li>
                          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>thisIndex</i>).</li>
                          <li>Let <i>nextIndex</i> be <a href="#sec-advancestringindex">AdvanceStringIndex</a>(<i>S</i>,
                              <i>thisIndex</i>, <i>fullUnicode</i>).</li>
                          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>rx</i>, <code>"lastIndex"</code>,
                              <i>nextIndex</i>, <b>true</b>).</li>
                          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                        </ol>
                      </li>
                    </ol>
                  </li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>accumulatedResult</i> be the empty String value.</li>
          <li>Let <i>nextSourcePosition</i> be 0.</li>
          <li>Repeat, for each <i>result</i> in <i>results</i>,
            <ol class="block">
              <li>Let <i>nCaptures</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>result</i>,
                  <code>"length"</code>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nCaptures</i>).</li>
              <li>Let <i>nCaptures</i> be max(<i>nCaptures</i> &minus; 1, 0).</li>
              <li>Let <i>matched</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>result</i>,
                  <code>"0"</code>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>matched</i>).</li>
              <li>Let <i>matchLength</i> be the number of code units in <i>matched</i>.</li>
              <li>Let <i>position</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>result</i>,
                  <code>"index"</code>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>position</i>).</li>
              <li>Let <i>position</i> be max(min(<i>position</i>, <i>lengthS</i>), 0).</li>
              <li>Let <i>n</i> be 1.</li>
              <li>Let <i>captures</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
              <li>Repeat while <i>n</i> &le; <i>nCaptures</i>
                <ol class="block">
                  <li>Let <i>capN</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>result</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>n</i>)).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>capN</i>).</li>
                  <li>If <i>capN</i> is not <b>undefined</b>, then
                    <ol class="block">
                      <li>Let <i>capN</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>capN</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>capN</i>).</li>
                    </ol>
                  </li>
                  <li>Append <i>capN</i> as the last element of <i>captures.</i></li>
                  <li>Let <i>n</i> be <i>n</i>+1</li>
                </ol>
              </li>
              <li>If <i>functionalReplace</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>replacerArgs</i> be &laquo;<i>matched</i>&raquo;.</li>
                  <li>Append in list order the elements of <i>captures</i> to the end of the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> <i>replacerArgs</i>.</li>
                  <li>Append <i>position</i> and <i>S</i> as the last two elements of <i>replacerArgs.</i></li>
                  <li>Let <i>replValue</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>replaceValue</i>, <b>undefined</b>,
                      <i>replacerArgs</i>).</li>
                  <li>Let <i>replacement</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>replValue</i>).</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>replacement</i> be <a href="#sec-getsubstitution">GetSubstitution</a>(<i>matched</i>, <i>S</i>,
                      <i>position</i>, <i>captures</i>, <i>replaceValue</i>).</li>
                </ol>
              </li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>replacement</i>).</li>
              <li>If <i>position</i> &ge; <i>nextSourcePosition</i>, then
                <ol class="block">
                  <li>NOTE&#x9;<span style="font-family: Times New Roman"><i>position</i></span> should not normally move
                      backwards. If it does, it is an indication of an ill-behaving RegExp subclass or use of an access triggered
                      side-effect to change the global flag or other characteristics of <i><span style="font-family: Times New                       Roman">rx</span>.</i> In such cases, the corresponding substitution is ignored.</li>
                  <li>Let <i>accumulatedResult</i> be the String formed by concatenating the code units of the current value of
                      <i>accumulatedResult</i> with the substring of <i>S</i> consisting of the code units from
                      <i>nextSourcePosition</i> (inclusive) up to <i>position</i> (exclusive) and with the code units of
                      <i>replacement</i>.</li>
                  <li>Let <i>nextSourcePosition</i> be <i>position</i> + <i>matchLength</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>nextSourcePosition</i> &ge; <i>lengthS</i>, return <i>accumulatedResult</i>.</li>
          <li>Return the String formed by concatenating the code units of <i>accumulatedResult</i> with the substring of <i>S</i>
              consisting of the code units from <i>nextSourcePosition</i> (inclusive) up through the final code unit of <i>S</i>
              (inclusive).</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"[Symbol.replace]"</code>.</p>
      </section>

      <section id="sec-regexp.prototype-@@search">
        <h4 id="sec-21.2.5.9" title="21.2.5.9"> RegExp.prototype [ @@search ] ( string )</h4><p class="normalbefore">When the @@search method is called with argument <var>string</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>rx</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>rx</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>string</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>previousLastIndex</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>rx</i>, <code>"lastIndex"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>previousLastIndex</i>).</li>
          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>rx</i>, <code>"lastIndex"</code>, 0,
              <b>true</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>Let <i>result</i> be <a href="#sec-regexpexec">RegExpExec</a>(<i>rx</i>, <i>S</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>rx</i>, <code>"lastIndex"</code>,
              <i>previousLastIndex</i>, <b>true</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>If <i>result</i> is <b>null</b>, return &ndash;1.</li>
          <li>Return <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>result</i>, <code>"index"</code>).</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"[Symbol.search]"</code>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>lastIndex</code> and <code>global</code> properties of this RegExp object are
          ignored when performing the search. The <code>lastIndex</code> property is left unchanged.</p>
        </div>
      </section>

      <section id="sec-get-regexp.prototype.source">
        <h4 id="sec-21.2.5.10" title="21.2.5.10"> get RegExp.prototype.source</h4><p class="normalbefore"><code>RegExp.prototype.source</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>R</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>R</i> does not have an [[OriginalSource]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>If <i>R</i> does not have an [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>src</i> be the value of <i>R&rsquo;s</i> [[OriginalSource]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>flags</i> be the value of <i>R&rsquo;s</i> [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Return <a href="#sec-escaperegexppattern">EscapeRegExpPattern</a>(<i>src</i>, <i>flags</i>).</li>
        </ol>
      </section>

      <section id="sec-regexp.prototype-@@split">
        <h4 id="sec-21.2.5.11" title="21.2.5.11"> RegExp.prototype [ @@split ] ( string, limit )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> Returns an Array object into which substrings of the result of converting
          <var>string</var> to a String have been stored. The substrings are determined by searching from left to right for
          matches of the <b>this</b> value regular expression; these occurrences are not part of any substring in the returned
          array, but serve to divide up the String value.</p>
        </div>

        <p class="NoteMore">The <b>this</b> value may be an empty regular expression or a regular expression that can match an
        empty String. In this case, regular expression does not match the empty substring at the beginning or end of the input
        String, nor does it match the empty substring at the end of the previous separator match. (For example, if the regular
        expression matches the empty String, the String is split up into individual code unit elements; the length of the result
        array equals the length of the String, and each substring contains one code unit.) Only the first match at a given index
        of the <b>this</b> String is considered, even if backtracking could yield a non-empty-substring match at that index. (For
        example, <code>/a*?/[Symbol.split]("ab")</code> evaluates to the array <code>["a","b"]</code>, while
        <code>/a*/[Symbol.split]("ab")</code> evaluates to the array<code>["","b"]</code>.)</p>

        <p class="NoteMore">If the <var>string</var> is (or converts to) the empty String, the result depends on whether the
        regular expression can match the empty String. If it can, the result array contains no elements. Otherwise, the result
        array contains one element, which is the empty String.</p>

        <p class="NoteMore">If the regular expression that contains capturing parentheses, then each time <var>separator</var> is
        matched the results (including any <b>undefined</b> results) of the capturing parentheses are spliced into the output
        array. For&nbsp;example,</p>

        <p class="NoteMore">&nbsp;&nbsp;&nbsp;&nbsp;<code>/&lt;(\/)?([^&lt;&gt;]+)&gt;/[Symbol.split]("A&lt;B&gt;bold&lt;/B&gt;and&lt;CODE&gt;coded&lt;/CODE&gt;")</code></p>

        <p class="NoteMore">evaluates to the array</p>

        <p class="NoteMore">&nbsp;&nbsp;&nbsp;&nbsp;<code>["A",undefined,"B","bold","/","B","and",undefined,"CODE","coded","/","CODE",""]</code></p>

        <p class="NoteMore">If <var>limit</var> is not <b>undefined</b>, then the output array is truncated so that it contains no
        more than <var>limit</var> elements.</p>

        <p class="normalbefore">When the @@<code>split</code> method is called, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>rx</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>rx</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>string</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
          <li>Let <i>C</i> be <a href="sec-abstract-operations#sec-speciesconstructor">SpeciesConstructor</a>(<i>rx</i>, %RegExp%).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>C</i>).</li>
          <li>Let <i>flags</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>rx</i>,
              <code>"<b>flags"</b></code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>flags</i>).</li>
          <li>If <i>flags</i> contains <code>"<b>u"</b></code>, let <i>unicodeMatching</i> be <b>true</b>.</li>
          <li>Else, let <i>unicodeMatching</i> be <b>false</b>.</li>
          <li>If <i>flags</i> contains <code>"<b>y"</b></code>, let <i>newFlags</i> be <i>flags</i>.</li>
          <li>Else, let <i>newFlags</i> be the string that is the concatenation of <i>flags</i> and <code>"<b>y"</b></code>.</li>
          <li>Let <i>splitter</i> be <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>C</i>, &laquo;<i>rx</i>,
              <i>newFlags</i>&raquo;).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>splitter</i>).</li>
          <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0).</li>
          <li>Let <i>lengthA</i> be 0.</li>
          <li>If <i>limit</i> is <b>undefined</b>, let <i>lim</i> be 2<sup>53</sup>&ndash;1; else let <i>lim</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<i>limit</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lim</i>).</li>
          <li>Let <i>size</i> be the number of elements in <i>S</i>.</li>
          <li>Let <i>p</i> be 0.</li>
          <li>If <i>lim</i> = 0, return <i>A</i>.</li>
          <li>If <i>size</i> = 0, then
            <ol class="block">
              <li>Let <i>z</i> be <a href="#sec-regexpexec">RegExpExec</a>(<i>splitter</i>, <i>S</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>z</i>).</li>
              <li>If <i>z</i> is not <b>null</b>, return <i>A</i>.</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The following call will never result in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              <li>Perform  <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <code>"<b>0</b>"</code>,
                  <i>S</i>).</li>
              <li>Return <i>A</i>.</li>
            </ol>
          </li>
          <li>Let <i>q</i> be <i>p</i>.</li>
          <li>Repeat, while <i>q</i> &lt; <i>size</i>
            <ol class="block">
              <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>splitter</i>, <code>"<b>lastIndex</b>"</code>,
                  <i>q</i>, <b>true</b>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
              <li>Let <i>z</i> be <a href="#sec-regexpexec">RegExpExec</a>(<i>splitter</i>, <i>S</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>z</i>).</li>
              <li>If <i>z</i> is <b>null</b>, let <i>q</i> be <a href="#sec-advancestringindex">AdvanceStringIndex</a>(<i>S</i>,
                  <i>q</i>, <i>unicodeMatching</i>).</li>
              <li>Else  <i>z</i> is not <b>null</b>,
                <ol class="block">
                  <li>Let <i>e</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>splitter</i>,
                      <code>"<b>lastIndex</b>"</code>)).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>e</i>).</li>
                  <li>If <i>e</i> = <i>p</i>, let <i>q</i> be <a href="#sec-advancestringindex">AdvanceStringIndex</a>(<i>S</i>,
                      <i>q</i>, <i>unicodeMatching</i>).</li>
                  <li>Else <i>e</i> &ne; <i>p</i>,
                    <ol class="block">
                      <li>Let <i>T</i> be a String value equal to the substring of <i>S</i> consisting of the elements at indices
                          <i>p</i> (inclusive) through <i>q</i> (exclusive).</li>
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The following call will never result in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                      <li>Perform  <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>lengthA</i>), <i>T</i>).</li>
                      <li>Let <i>lengthA</i> be <i>lengthA</i> +1.</li>
                      <li>If <i>lengthA</i> = <i>lim</i>, return <i>A</i>.</li>
                      <li>Let <i>p</i> be <i>e</i>.</li>
                      <li>Let <i>numberOfCaptures</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>z</i>, <code>"<b>length</b>"</code>)).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>numberOfCaptures</i>).</li>
                      <li>Let <i>numberOfCaptures</i> be max(<i>numberOfCaptures</i>-1, 0).</li>
                      <li>Let <i>i</i> be 1.</li>
                      <li>Repeat, while <i>i</i> &le; <i>numberOfCaptures</i>.
                        <ol class="block">
                          <li>Let <i>nextCapture</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>z</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>i</i>)).</li>
                          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextCapture</i>).</li>
                          <li>Perform  <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>lengthA</i>), <i>nextCapture</i>).</li>
                          <li>Let <i>i</i> be <i>i</i> +1.</li>
                          <li>Let <i>lengthA</i> be <i>lengthA</i> +1.</li>
                          <li>If <i>lengthA</i> = <i>lim</i>, return <i>A</i>.</li>
                        </ol>
                      </li>
                      <li>Let <i>q</i> be <i>p</i>.</li>
                    </ol>
                  </li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>T</i> be a String value equal to the substring of <i>S</i> consisting of the elements at indices <i>p</i>
              (inclusive) through <i>size</i> (exclusive).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The following call will never result in an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>lengthA</i>), <i>T</i> ).</li>
          <li>Return <i>A</i>.</li>
        </ol>

        <p>The <code>length</code> property of the @@<code>split</code> method is <b>2</b>.</p>

        <p>The value of the <code>name</code> property of this function is <code>"[Symbol.split]"</code>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The @@<code>split</code> method ignores the value of the <code>global</code> and
          <code>sticky</code> properties of this RegExp object.</p>
        </div>
      </section>

      <section id="sec-get-regexp.prototype.sticky">
        <h4 id="sec-21.2.5.12" title="21.2.5.12"> get RegExp.prototype.sticky</h4><p class="normalbefore"><code>RegExp.prototype.sticky</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>R</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>R</i> does not have an [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>flags</i> be the value of <i>R&rsquo;s</i> [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>flags</i> contains the code unit <code>"y"</code>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-regexp.prototype.test">
        <h4 id="sec-21.2.5.13" title="21.2.5.13"> RegExp.prototype.test( S )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>R</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>string</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>S</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>string</i>).</li>
          <li>Let <i>match</i> be <a href="#sec-regexpexec">RegExpExec</a>(<i>R</i>, <i>string</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>match</i>).</li>
          <li>If <i>match</i> is not <b>null</b>, return <b>true</b>; else return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-regexp.prototype.tostring">
        <h4 id="sec-21.2.5.14" title="21.2.5.14"> RegExp.prototype.toString ( )</h4><ol class="proc">
          <li>Let <i>R</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>pattern</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>,
              <code>"source"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>pattern</i>).</li>
          <li>Let <i>flags</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>R</i>,
              <code>"flags"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>flags</i>).</li>
          <li>Let <i>result</i> be the String value formed by concatenating <code>"<b>/</b>"</code>, <i>pattern</i>, and
              <code>"<b>/</b>"</code>, and <i>flags</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The returned String has the form of a <span class="nt">RegularExpressionLiteral</span>
          that evaluates to another RegExp object with the same behaviour as this object.</p>
        </div>
      </section>

      <section id="sec-get-regexp.prototype.unicode">
        <h4 id="sec-21.2.5.15" title="21.2.5.15"> get RegExp.prototype.unicode</h4><p class="normalbefore"><code>RegExp.prototype.unicode</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>R</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>R</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>R</i> does not have an [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>flags</i> be the value of <i>R&rsquo;s</i> [[OriginalFlags]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>flags</i> contains the code unit <code>"u"</code>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-regexp-instances">
      <div class="front">
        <h3 id="sec-21.2.6" title="21.2.6"> Properties of RegExp Instances</h3><p>RegExp instances are ordinary objects that inherit properties from the RegExp prototype object. RegExp instances have
        internal slots [[RegExpMatcher]], [[OriginalSource]], and [[OriginalFlags]]. The value of the [[RegExpMatcher]] internal
        slot is an implementation dependent representation of the <span class="nt">Pattern</span> of the RegExp object.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Prior to ECMAScript 2015, <code>RegExp</code> instances were specified as having the own
          data properties <code>source</code>, <code>global</code>, <code>ignoreCase</code>, and <code>multiline</code>. Those
          properties are now specified as accessor properties of <a href="#sec-regexp.prototype">RegExp.prototype</a>.</p>
        </div>

        <p>RegExp instances also have the following property:</p>
      </div>

      <section id="sec-lastindex">
        <h4 id="sec-21.2.6.1" title="21.2.6.1">
            lastIndex</h4><p>The value of the <code>lastIndex</code> property specifies the String index at which to start the next match. It is
        coerced to an integer when used (<a href="#sec-regexpbuiltinexec">see 21.2.5.2.2</a>). This property shall have the
        attributes {&nbsp;[[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>false</b>&nbsp;}.</p>
      </section>
    </section>
  </section>
</section>

