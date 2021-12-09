<section id="sec-ecmascript-data-types-and-values">
  <div class="front">
    <h1 id="sec-6" title="6">
        ECMAScript Data Types and Values</h1><p>Algorithms within this specification manipulate values each of which has an associated type. The possible value types are
    exactly those defined in this clause. Types are further subclassified into ECMAScript language types and specification
    types.</p>

    <p>Within this specification, the notation &ldquo;<span style="font-family: Times New Roman">Type(<i>x</i>)</span>&rdquo; is
    used as shorthand for &ldquo;<span style="font-family: Times New Roman">the type of <i>x</i></span>&rdquo; where &ldquo;<span style="font-family: Times New Roman">type</span>&rdquo; refers to the ECMAScript language and specification types defined in
    this clause. When the term &ldquo;empty&rdquo; is used as if it was naming a value, it is equivalent to saying &ldquo;no value
    of any type&rdquo;.</p>
  </div>

  <section id="sec-ecmascript-language-types">
    <div class="front">
      <h2 id="sec-6.1" title="6.1">
          ECMAScript Language Types</h2><p>An ECMAScript language type corresponds to values that are directly manipulated by an ECMAScript programmer using the
      ECMAScript language. The ECMAScript language types are Undefined, Null, Boolean, String, Symbol, Number, and Object. An
      ECMAScript language value is a value that is characterized by an ECMAScript language type.</p>
    </div>

    <section id="sec-ecmascript-language-types-undefined-type">
      <h3 id="sec-6.1.1" title="6.1.1"> The Undefined Type</h3><p>The Undefined type has exactly one value, called <b>undefined</b>. Any variable that has not been assigned a value has
      the value <b>undefined</b>.</p>
    </section>

    <section id="sec-ecmascript-language-types-null-type">
      <h3 id="sec-6.1.2" title="6.1.2"> The Null Type</h3><p>The Null type has exactly one value, called <b>null</b>.</p>
    </section>

    <section id="sec-ecmascript-language-types-boolean-type">
      <h3 id="sec-6.1.3" title="6.1.3"> The Boolean Type</h3><p>The Boolean type represents a logical entity having two values, called <b>true</b> and <b>false</b>.</p>
    </section>

    <section id="sec-ecmascript-language-types-string-type">
      <h3 id="sec-6.1.4" title="6.1.4"> The String Type</h3><p>The String type is the set of all ordered sequences of zero or more 16-bit unsigned integer values
      (&ldquo;elements&rdquo;) up to a maximum length of 2<sup>53</sup>-1 elements. The String type is generally used to represent
      textual data in a running ECMAScript program, in which case each element in the String is treated as a UTF-16 code unit
      value. Each element is regarded as occupying a position within the sequence. These positions are indexed with nonnegative
      integers. The first element (if any) is at index 0, the next element (if any) at index 1, and so on. The length of a String
      is the number of elements (i.e., 16-bit values) within it. The empty String has length zero and therefore contains no
      elements.</p>

      <p>Where ECMAScript operations interpret String values, each element is interpreted as a single UTF-16 code unit. However,
      ECMAScript does not place any restrictions or requirements on the sequence of code units in a String value, so they may be
      ill-formed when interpreted as UTF-16 code unit sequences. Operations that do not interpret String contents treat them as
      sequences of undifferentiated 16-bit unsigned integers. The function <code><a href="sec-text-processing#sec-string.prototype.normalize">String.prototype.normalize</a></code> (<a href="sec-text-processing#sec-string.prototype.normalize">see
      21.1.3.12</a>) can be used to explicitly normalize a String value. <code><a href="sec-text-processing#sec-string.prototype.localecompare">String.prototype.localeCompare</a></code> (<a href="sec-text-processing#sec-string.prototype.localecompare">see 21.1.3.10</a>) internally normalizes String values, but no other operations
      implicitly normalize the strings upon which they operate. Only operations that are explicitly specified to be language or
      locale sensitive produce language-sensitive results.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> The rationale behind this design was to keep the implementation of Strings as simple and
        high-performing as possible. If ECMAScript source text is in Normalized Form C, string literals are guaranteed to also be
        normalized, as long as they do not contain any Unicode escape sequences.</p>
      </div>

      <p>Some operations interpret String contents as UTF-16 encoded Unicode code points. In that case the interpretation is:</p>

      <ul>
        <li>
          <p>A code unit in the range <span style="font-family: Times New Roman">0</span> to <span style="font-family: Times New           Roman">0xD7FF</span> or in the range <span style="font-family: Times New Roman">0xE000</span> to <span style="font-family: Times New Roman">0xFFFF</span> is interpreted as a code point with the same value.</p>
        </li>

        <li>
          <p>A sequence of two code units, where the first code unit <var>c1</var> is in the range <span style="font-family: Times           New Roman">0xD800</span> to <span style="font-family: Times New Roman">0xDBFF</span> and the second code unit
          <var>c2</var> is in the range <span style="font-family: Times New Roman">0xDC00</span> to <span style="font-family:           Times New Roman">0xDFFF</span>, is a surrogate pair and is interpreted as a code point with the value (<var>c1</var> -
          <span style="font-family: Times New Roman">0xD800</span>) &times; <span style="font-family: Times New           Roman">0x400</span> + (<var>c2</var> &ndash; <span style="font-family: Times New Roman">0xDC00</span>) + <span style="font-family: Times New Roman">0x10000</span>. (See <a href="sec-ecmascript-language-source-code#sec-utf16decode">10.1.2</a>)</p>
        </li>

        <li>
          <p>A code unit that is in the range <span style="font-family: Times New Roman">0xD800</span> to <span style="font-family: Times New Roman">0xDFFF</span>, but is not part of a surrogate pair, is interpreted as a code point
          with the same value.</p>
        </li>
      </ul>
    </section>

    <section id="sec-ecmascript-language-types-symbol-type">
      <div class="front">
        <h3 id="sec-6.1.5" title="6.1.5"> The Symbol Type</h3><p>The Symbol type is the set of all non-String values that may be used as the key of an Object property (<a href="#sec-object-type">6.1.7</a>).</p>

        <p>Each possible Symbol value is unique and immutable.</p>

        <p>Each Symbol value immutably holds an associated value called [[Description]] that is either <span class="value">undefined</span> or a String value.</p>
      </div>

      <section id="sec-well-known-symbols">
        <h4 id="sec-6.1.5.1" title="6.1.5.1"> Well-Known Symbols</h4><p>Well-known symbols are built-in Symbol values that are explicitly referenced by algorithms of this specification. They
        are typically used as the keys of properties whose values serve as extension points of a specification algorithm. Unless
        otherwise specified, well-known symbols values are shared by all Code Realms (<a href="sec-executable-code-and-execution-contexts#sec-code-realms">8.2</a>).</p>

        <p>Within this specification a well-known symbol is referred to by using a notation of the form @@name, where
        &ldquo;name&rdquo; is one of the values listed in <a href="#table-1">Table 1</a>.</p>

        <figure>
          <figcaption><span id="table-1">Table 1</span> &mdash; Well-known Symbols</figcaption>
          <table class="real-table">
            <tr>
              <th>Specification Name</th>
              <th>[[Description]]</th>
              <th>Value and Purpose</th>
            </tr>
            <tr>
              <td>@@hasInstance</td>
              <td><code>"Symbol.hasInstance"</code></td>
              <td>A method that determines if a constructor object recognizes an object as one of the constructor&rsquo;s instances. Called by the semantics of the <code>instanceof</code> operator.</td>
            </tr>
            <tr>
              <td>@@isConcatSpreadable</td>
              <td><code>"Symbol.isConcatSpreadable"</code></td>
              <td>A Boolean valued property that if true indicates that an object should be flattened to its array elements by <code><a href="sec-indexed-collections#sec-array.prototype.concat">Array.prototype.concat</a></code>.</td>
            </tr>
            <tr>
              <td>@@iterator</td>
              <td><code>"Symbol.iterator"</code></td>
              <td>A method that returns the default Iterator for an object. Called by the semantics of the for-of statement.</td>
            </tr>
            <tr>
              <td>@@match</td>
              <td><code>"Symbol.match"</code></td>
              <td>A regular expression method that matches the regular expression against a string. Called by the <code><a href="sec-text-processing#sec-string.prototype.match">String.prototype.match</a></code> method.</td>
            </tr>
            <tr>
              <td>@@replace</td>
              <td><code>"Symbol.replace"</code></td>
              <td>A regular expression method that replaces matched substrings of a string. Called by the <code><a href="sec-text-processing#sec-string.prototype.replace">String.prototype.replace</a></code> method.</td>
            </tr>
            <tr>
              <td>@@search</td>
              <td><code>"Symbol.search"</code></td>
              <td>A regular expression method that returns the index within a string that matches the regular expression. Called by the <code><a href="sec-text-processing#sec-string.prototype.search">String.prototype.search</a></code> method.</td>
            </tr>
            <tr>
              <td>@@species</td>
              <td><code>"Symbol.species"</code></td>
              <td>A function valued property that is the constructor function that is used to create derived objects.</td>
            </tr>
            <tr>
              <td>@@split</td>
              <td><code>"Symbol.split"</code></td>
              <td>A regular expression method that splits a string at the indices that match the regular expression. Called by the <code><a href="sec-text-processing#sec-string.prototype.split">String.prototype.split</a></code> method.</td>
            </tr>
            <tr>
              <td>@@toPrimitive</td>
              <td><code>"Symbol.toPrimitive"</code></td>
              <td>A method that converts an object to a corresponding primitive value. Called by the <a href="sec-abstract-operations#sec-toprimitive">ToPrimitive</a> abstract operation.</td>
            </tr>
            <tr>
              <td>@@toStringTag</td>
              <td><code>"Symbol.toStringTag"</code></td>
              <td>A String valued property that is used in the creation of the default string description of an object. Accessed by the built-in method <code><a href="sec-fundamental-objects#sec-object.prototype.tostring">Object.prototype.toString</a></code>.</td>
            </tr>
            <tr>
              <td>@@unscopables</td>
              <td><code>"Symbol.unscopables"</code></td>
              <td>An object valued property whose own property names are property names that are excluded from the <code>with</code> environment bindings of the associated object.</td>
            </tr>
          </table>
        </figure>
      </section>
    </section>

    <section id="sec-ecmascript-language-types-number-type">
      <h3 id="sec-6.1.6" title="6.1.6"> The Number Type</h3><p>The Number type has exactly <span style="font-family: Times New Roman">18437736874454810627</span> (that is, <span style="font-family: Times New Roman">2<sup>64</sup>&minus;2<sup>53</sup>+3</span>) values, representing the double-precision
      64-bit format IEEE 754-2008 values as specified in the IEEE Standard for Binary Floating-Point Arithmetic, except that the
      <span style="font-family: Times New Roman">9007199254740990</span> (that is, <span style="font-family: Times New       Roman">2<sup>53</sup>&minus;2</span>) distinct &ldquo;Not-a-Number&rdquo; values of the IEEE Standard are represented in
      ECMAScript as a single special <b>NaN</b> value. (Note that the <b>NaN</b> value is produced by the program expression
      <code>NaN</code>.) In some implementations, external code might be able to detect a difference between various Not-a-Number
      values, but such behaviour is implementation-dependent; to ECMAScript code, all NaN values are indistinguishable from each
      other.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> The bit pattern that might be observed in an ArrayBuffer (<a href="sec-structured-data#sec-arraybuffer-objects">see 24.1</a>) after a Number value has been stored into it is not necessarily the same as
        the internal representation of that Number value used by the ECMAScript implementation.</p>
      </div>

      <p>There are two other special values, called <b>positive Infinity</b> and <b>negative Infinity</b>. For brevity, these
      values are also referred to for expository purposes by the symbols <span class="value">+&infin;</span> and <span class="value">&minus;&infin;</span>, respectively. (Note that these two infinite Number values are produced by the program
      expressions <code>+Infinity</code> (or simply <code>Infinity</code>) and <code>-Infinity</code>.)</p>

      <p>The other <span style="font-family: Times New Roman">18437736874454810624</span> (that is, <span style="font-family:       Times New Roman">2<sup>64</sup>&minus;2<sup>53</sup></span>) values are called the finite numbers. Half of these are
      positive numbers and half are negative numbers; for every finite positive Number value there is a corresponding negative
      value having the same magnitude.</p>

      <p>Note that there is both a <b>positive zero</b> and a <b>negative zero</b>. For brevity, these values are also referred to
      for expository purposes by the symbols <span class="value">+0</span> and <span class="value">&minus;0</span>, respectively.
      (Note that these two different zero Number values are produced by the program expressions <code>+0</code> (or simply
      <code>0</code>) and <code>-0</code>.)</p>

      <p>The <span style="font-family: Times New Roman">18437736874454810622</span> (that is, <span style="font-family: Times New       Roman">2<sup>64</sup>&minus;2<sup>53</sup>&minus;2</span>) finite nonzero values are of two kinds:</p>

      <p><span style="font-family: Times New Roman">18428729675200069632</span> (that is, <span style="font-family: Times New       Roman">2<sup>64</sup>&minus;2<sup>54</sup></span>) of them are normalized, having the form</p>

      <div class="math-display"><i>s</i> &times; <i>m</i> &times; 2<sup><i>e</i></sup></div>

      <p>where <var>s</var> is <span style="font-family: Times New Roman">+1</span> or <span style="font-family: Times New       Roman">&minus;1</span>, <var>m</var> is a positive integer less than <span style="font-family: Times New       Roman">2<sup>53</sup></span> but not less than <span style="font-family: Times New Roman">2<sup>52</sup></span>, and
      <var>e</var> is an integer ranging from <span style="font-family: Times New Roman">&minus;1074</span> to <span style="font-family: Times New Roman">971</span>, inclusive.</p>

      <p>The remaining <span style="font-family: Times New Roman">9007199254740990</span> (that is, <span style="font-family:       Times New Roman">2<sup>53</sup>&minus;2</span>) values are denormalized, having the form</p>

      <div class="math-display"><i>s</i> &times; <i>m</i> &times; 2<sup><i>e</i></sup></div>

      <p>where <var>s</var> is <span style="font-family: Times New Roman">+1</span> or <span style="font-family: Times New       Roman">&minus;1</span>, <var>m</var> is a positive integer less than <span style="font-family: Times New       Roman">2<sup>52</sup></span>, and <var>e</var> is <span style="font-family: Times New Roman">&minus;1074</span>.</p>

      <p>Note that all the positive and negative integers whose magnitude is no greater than <span style="font-family: Times New       Roman">2<sup>53</sup></span> are representable in the Number type (indeed, the integer <span style="font-family: Times New       Roman">0</span> has two representations, <code>+0</code> and <code>-0</code>).</p>

      <p>A finite number has an <i>odd significand</i> if it is nonzero and the integer <var>m</var> used to express it (in one of
      the two forms shown above) is odd. Otherwise, it has an <i>even significand</i>.</p>

      <p>In this specification, the phrase &ldquo;<span style="font-family: Times New Roman">the Number value for
      <i>x</i></span>&rdquo; where <var>x</var> represents an exact nonzero real mathematical quantity (which might even be an
      irrational number such as <span style="font-family: Times New Roman">&pi;</span>) means a Number value chosen in the
      following manner. Consider the set of all finite values of the Number type, with <span class="value">&minus;0</span> removed
      and with two additional values added to it that are not representable in the Number type, namely <span style="font-family:       Times New Roman">2<sup>1024</sup></span> (which is <span style="font-family: Times New Roman">+1 &times;
      2<sup>53</sup></span> <span style="font-family: Times New Roman">&times; 2<sup>971</sup></span>) and <span style="font-family: Times New Roman">&minus;2<sup>1024</sup></span> (which is <span style="font-family: Times New       Roman">&minus;1 &times; 2<sup>53</sup></span> <span style="font-family: Times New Roman">&times; 2<sup>971</sup></span>).
      Choose the member of this set that is closest in value to <var>x</var>. If two values of the set are equally close, then the
      one with an even significand is chosen; for this purpose, the two extra values <span style="font-family: Times New       Roman">2<sup>1024</sup></span> and <span style="font-family: Times New Roman">&minus;2<sup>1024</sup></span> are considered
      to have even significands. Finally, if <span style="font-family: Times New Roman">2<sup>1024</sup></span> was chosen,
      replace it with <span class="value">+&infin;</span>; if <span style="font-family: Times New       Roman">&minus;2<sup>1024</sup></span> was chosen, replace it with <span class="value">&minus;&infin;</span>; if <span class="value">+0</span> was chosen, replace it with <span class="value">&minus;0</span> if and only if <var>x</var> is less
      than zero; any other chosen value is used unchanged. The result is the Number value for <var>x</var>. (This procedure
      corresponds exactly to the behaviour of the IEEE 754-2008 &ldquo;round to nearest, ties to even&rdquo; mode.)</p>

      <p>Some ECMAScript operators deal only with integers in specific ranges such as <span style="font-family: Times New       Roman">&minus;2<sup>31</sup></span> through <span style="font-family: Times New Roman">2<sup>31</sup>&minus;1</span>,
      inclusive, or in the range <span style="font-family: Times New Roman">0</span> through <span style="font-family: Times New       Roman">2<sup>16</sup>&minus;1</span>, inclusive. These operators accept any value of the Number type but first convert each
      such value to an integer value in the expected range. See the descriptions of the numeric conversion operations in <a href="sec-abstract-operations#sec-type-conversion">7.1</a>.</p>
    </section>

    <section id="sec-object-type">
      <div class="front">
        <h3 id="sec-6.1.7" title="6.1.7"> The
            Object Type</h3><p>An Object is logically a collection of properties. Each property is either a data property, or an accessor
        property:</p>

        <ul>
          <li>
            <p>A <i>data property</i> associates a key value with an <a href="#sec-ecmascript-language-types">ECMAScript language
            value</a> and a set of Boolean attributes.</p>
          </li>

          <li>
            <p>An <i>accessor property</i> associates a key value with one or two accessor functions, and a set of Boolean
            attributes. The accessor functions are used to store or retrieve an <a href="#sec-ecmascript-language-types">ECMAScript language value</a> that is associated with the property.</p>
          </li>
        </ul>

        <p>Properties are identified using key values. A property key value is either an ECMAScript String value or a Symbol
        value. All String and Symbol values, including the empty string, are valid as property keys. A <i>property name</i> is a
        property key that is a String value.</p>

        <p>An <i>integer index</i> is a String-valued property key that is a canonical numeric String (<a href="sec-abstract-operations#sec-canonicalnumericindexstring">see 7.1.16</a>) and whose numeric value is either <span style="font-family: Times         New Roman">+0</span> or a positive integer &le; 2<sup>53</sup>&minus;1. An <i>array index</i> is an integer index whose
        numeric value <var>i</var> is in the range <span style="font-family: Times New Roman">+0 &le; <i>i</i> &lt;
        2<sup>32</sup>&minus;1.</span></p>

        <p>Property keys are used to access properties and their values. There are two kinds of access for properties: <i>get</i>
        and <i>set</i>, corresponding to value retrieval and assignment, respectively. The properties accessible via get and set
        access includes both <i>own properties</i> that are a direct part of an object and <i>inherited properties</i> which are
        provided by another associated object via a property inheritance relationship. Inherited properties may be either own or
        inherited properties of the associated object. Each own property of an object must each have a key value that is distinct
        from the key values of the other own properties of that object.</p>

        <p>All objects are logically collections of properties, but there are multiple forms of objects that differ in their
        semantics for accessing and manipulating their properties. O<i>rdinary objects</i> are the most common form of objects and
        have the default object semantics. An <i>exotic object</i> is any form of object whose property semantics differ in any
        way from the default semantics.</p>
      </div>

      <section id="sec-property-attributes">
        <h4 id="sec-6.1.7.1" title="6.1.7.1"> Property Attributes</h4><p>Attributes are used in this specification to define and explain the state of Object properties. A data property
        associates a key value with the attributes listed in <a href="#table-2">Table 2</a>.</p>

        <figure>
          <figcaption><span id="table-2">Table 2</span> &mdash; Attributes of a Data Property</figcaption>
          <table class="real-table">
            <tr>
              <th style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">Attribute Name</th>
              <th style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">Value Domain</th>
              <th style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">Description</th>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid black">[[Value]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">Any <a href="#sec-ecmascript-language-types">ECMAScript language type</a></td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">The value retrieved by a get access of the property.</td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid black">[[Writable]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">Boolean</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">If <b>false</b>, attempts by ECMAScript code to change the property&rsquo;s [[Value]] attribute using [[Set]] will not succeed.</td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid black">[[Enumerable]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">Boolean</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">If <b>true</b>, the property will be enumerated by a for-in enumeration (<a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements">see 13.7.5</a>). Otherwise, the property is said to be non-enumerable.</td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid black">[[Configurable]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">Boolean</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">If <b>false</b>, attempts to delete the property, change the property to be an accessor property, or change its attributes (other than [[Value]], or changing [[Writable]] to <b>false</b>) will fail.</td>
            </tr>
          </table>
        </figure>

        <p>An accessor property associates a key value with the attributes listed in <a href="#table-3">Table 3</a>.</p>

        <figure>
          <figcaption><span id="table-3">Table 3</span> &mdash; Attributes of an Accessor Property</figcaption>
          <table class="real-table">
            <tr>
              <th style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">Attribute Name</th>
              <th style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">Value Domain</th>
              <th style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">Description</th>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000">[[Get]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">Object <i>|</i> Undefined</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">If the value is an Object it must be a function object. The function&rsquo;s [[Call]] internal method (<a href="#table-6">Table 6</a>) is called with an empty arguments list to retrieve the property value each time a get access of the property is performed.</td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">[[Set]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">Object <i>|</i> Undefined</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">If the value is an Object it must be a function object. The function&rsquo;s [[Call]] internal method (<a href="#table-6">Table 6</a>) is called with an arguments list containing the assigned value as its sole argument each time a set access of the property is performed. The effect of a property's [[Set]] internal method may, but is not required to, have an effect on the value returned by subsequent calls to the property's [[Get]] internal method.</td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">[[Enumerable]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">Boolean</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">If <b>true</b>, the property is to be enumerated by a for-in enumeration (<a href="sec-ecmascript-language-statements-and-declarations#sec-for-in-and-for-of-statements">see 13.7.5</a>). Otherwise, the property is said to be non-enumerable.</td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">[[Configurable]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">Boolean</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black">If <b>false</b>, attempts to delete the property, change the property to be a data property, or change its attributes will fail.</td>
            </tr>
          </table>
        </figure>

        <p>If the initial values of a property&rsquo;s attributes are not explicitly specified by this specification, the default
        value defined in <a href="#table-4">Table 4</a> is used.</p>

        <figure>
          <figcaption><span id="table-4">Table 4</span> &mdash; Default Attribute Values</figcaption>
          <table class="real-table">
            <tr>
              <th style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">Attribute Name</th>
              <th style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">Default Value</th>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">[[Value]]</td>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black"><b>undefined</b></td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000">[[Get]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black"><b>undefined</b></td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">[[Set]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black"><b>undefined</b></td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">[[Writable]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black"><b>false</b></td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">[[Enumerable]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black"><b>false</b></td>
            </tr>
            <tr>
              <td style="border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid #000000; border-top: 1px solid black">[[Configurable]]</td>
              <td style="border-bottom: 1px solid black; border-right: 1px solid black"><b>false</b></td>
            </tr>
          </table>
        </figure>
      </section>

      <section id="sec-object-internal-methods-and-internal-slots">
        <h4 id="sec-6.1.7.2" title="6.1.7.2"> Object Internal Methods and Internal Slots</h4><p>The actual semantics of objects, in ECMAScript, are specified via algorithms called <i>internal methods</i>. Each
        object in an ECMAScript engine is associated with a set of internal methods that defines its runtime behaviour. These
        internal methods are not part of the ECMAScript language. They are defined by this specification purely for expository
        purposes. However, each object within an implementation of ECMAScript must behave as specified by the internal methods
        associated with it. The exact manner in which this is accomplished is determined by the implementation.</p>

        <p>Internal method names are polymorphic. This means that different object values may perform different algorithms when a
        common internal method name is invoked upon them. That actual object upon which an internal method is invoked is the
        &ldquo;target&rdquo; of the invocation. If, at runtime, the implementation of an algorithm attempts to use an internal
        method of an object that the object does not support, a <b>TypeError</b> exception is thrown.</p>

        <p>Internal slots correspond to internal state that is associated with objects and used by various ECMAScript
        specification algorithms. Internal slots are not object properties and they are not inherited. Depending upon the specific
        internal slot specification, such state may consist of values of any <a href="#sec-ecmascript-language-types">ECMAScript
        language type</a> or of specific ECMAScript specification type values. Unless explicitly specified otherwise, internal
        slots are allocated as part of the process of creating an object and may not be dynamically added to an object. Unless
        specified otherwise, the initial value of an internal slot is the value <span class="value">undefined</span>. Various
        algorithms within this specification create objects that have internal slots. However, the ECMAScript language provides no
        direct way to associate internal slots with an object.</p>

        <p>Internal methods and internal slots are identified within this specification using names enclosed in double square
        brackets [[ ]].</p>

        <p><a href="#table-5">Table 5</a> summarizes the <i>essential internal methods</i> used by this specification that are
        applicable to all objects created or manipulated by ECMAScript code. Every object must have algorithms for all of the
        essential internal methods. However, all objects do not necessarily use the same algorithms for those methods.</p>

        <p>The &ldquo;Signature&rdquo; column of <a href="#table-5">Table 5</a> and other similar tables describes the invocation
        pattern for each internal method. The invocation pattern always includes a parenthesized list of descriptive parameter
        names. If a parameter name is the same as an ECMAScript type name then the name describes the required type of the
        parameter value. If an internal method  explicitly returns a value, its parameter list is followed by the symbol
        &ldquo;&rarr;&rdquo; and the type name of the returned value. The type names used in signatures refer to the types defined
        in <a href="sec-ecmascript-data-types-and-values">clause 6</a> augmented by the following additional names.
        &ldquo;<i>any</i>&rdquo; means the value may be any <a href="#sec-ecmascript-language-types">ECMAScript language type</a>.
        An internal method implicitly returns a <a href="#sec-completion-record-specification-type">Completion Record</a> as
        described in <a href="#sec-completion-record-specification-type">6.2.2</a>. In addition to its parameters, an internal
        method always has access to the object that is the target of the method invocation.</p>

        <figure>
          <figcaption><span id="table-5">Table 5</span> &mdash; Essential Internal Methods</figcaption>
          <table class="real-table">
            <tr>
              <th>Internal Method</th>
              <th>Signature</th>
              <th>Description</th>
            </tr>
            <tr>
              <td>[[GetPrototypeOf]]</td>
              <td>() <b>&rarr;</b> Object | Null</td>
              <td>Determine the object that provides inherited properties for this object. A <b>null</b> value indicates that there are no inherited properties.</td>
            </tr>
            <tr>
              <td>[[SetPrototypeOf]]</td>
              <td>(<i>Object</i> | Null) <b>&rarr;</b> Boolean</td>
              <td>Associate this object with another object that provides inherited properties. Passing <b>null</b> indicates that there are no inherited properties. Returns <b>true</b> indicating that the operation was completed successfully or <b>false</b> indicating that the operation was not successful.</td>
            </tr>
            <tr>
              <td>[[IsExtensible]]</td>
              <td>( ) <b>&rarr;</b> Boolean</td>
              <td>Determine whether it is permitted to add additional properties to this object.</td>
            </tr>
            <tr>
              <td>[[PreventExtensions]]</td>
              <td>( ) <b>&rarr;</b> Boolean</td>
              <td>Control whether new properties may be added to this object. Returns <b>true</b> if the operation was successful or <b>false</b> if the operation was unsuccessful.</td>
            </tr>
            <tr>
              <td>[[GetOwnProperty]]</td>
              <td>(<i>propertyKey</i>) <b>&rarr;</b> Undefined | <a href="#sec-property-descriptor-specification-type">Property Descriptor</a></td>
              <td>Return a <a href="#sec-property-descriptor-specification-type">Property Descriptor</a> for the own property of this object whose key is <i>propertyKey</i>, or <b>undefined</b> if no such property exists.</td>
            </tr>
            <tr>
              <td>[[HasProperty]]</td>
              <td>(<i>propertyKey</i>) <b>&rarr;</b> Boolean</td>
              <td>Return a Boolean value indicating whether this object already has either an own or inherited property whose key is <i>propertyKey</i>.</td>
            </tr>
            <tr>
              <td>[[Get]]</td>
              <td>(<i>propertyKey</i>, <i>Receiver</i>)<br /><b>&rarr;</b> <i>any</i></td>
              <td>Return the value of the property whose key is <i>propertyKey</i> from this object. If any ECMAScript code must be executed to retrieve the property value, <i>Receiver</i> is used as the <b>this</b> value when evaluating the code.</td>
            </tr>
            <tr>
              <td>[[Set]]</td>
              <td>(<i>propertyKey</i>,<i>value</i>, <i>Receiver</i>) <br /><b>&rarr;</b> <i>Boolean</i></td>
              <td>Set the value of the property whose key is <i>propertyKey</i> to <i>value</i>. If any ECMAScript code must be executed to set the property value, <i>Receiver</i> is used as the <b>this</b> value when evaluating the code. Returns <b>true</b> if the property value was set or <b>false</b> if it could not be set.</td>
            </tr>
            <tr>
              <td>[[Delete]]</td>
              <td>(<i>propertyKey</i>) <b>&rarr;</b> Boolean</td>
              <td>Remove the own property whose key is <i>propertyKey</i> from this object . Return <b>false</b> if the property was not deleted and is still present. Return <b>true</b> if the property was deleted or is not present.</td>
            </tr>
            <tr>
              <td>[[DefineOwnProperty]]</td>
              <td>(<i>propertyKey</i>, <i>PropertyDescriptor</i>)<br /><b>&rarr;</b> Boolean</td>
              <td>Create or alter the own property, whose key is <i>propertyKey</i>, to have the state described by <i>PropertyDescriptor</i>. Return <b>true</b> if that property was successfully created/updated or <b>false</b> if the property could not be created or updated.</td>
            </tr>
            <tr>
              <td>[[Enumerate]]</td>
              <td>()<b><i>&rarr;</i></b>Object</td>
              <td>Return an iterator object that produces the keys of the string-keyed enumerable properties of the object.</td>
            </tr>
            <tr>
              <td>[[OwnPropertyKeys]]</td>
              <td>()<b>&rarr;</b><a href="#sec-list-and-record-specification-type">List</a> of propertyKey</td>
              <td>Return a <a href="#sec-list-and-record-specification-type">List</a> whose elements are all of the own property keys for the object.</td>
            </tr>
          </table>
        </figure>

        <p><a href="#table-6">Table 6</a> summarizes additional essential internal methods that are supported by objects that may
        be called as functions. A <i>function object</i> is an object that supports the [[Call]] internal methods. A
        <i>constructor</i> (also referred to as a <i>constructor function</i>) is a function object that supports the
        [[Construct]] internal method.</p>

        <figure>
          <figcaption><span id="table-6">Table 6</span> &mdash; Additional Essential Internal Methods of Function Objects</figcaption>
          <table class="real-table">
            <tr>
              <th>Internal Method</th>
              <th>Signature</th>
              <th>Description</th>
            </tr>
            <tr>
              <td>[[Call]]</td>
              <td>(<i>any</i>, a <a href="#sec-list-and-record-specification-type">List</a> of <i>any</i>)<br /><span class="value">&rarr;</span> <i>any</i></td>
              <td>Executes code associated with this object. Invoked via a function call expression. The arguments to the internal method are a <b>this</b> value and a list containing the arguments passed to the function by a call expression. Objects that implement this internal method are <i>callable</i>.</td>
            </tr>
            <tr>
              <td>[[Construct]]</td>
              <td>(a <a href="#sec-list-and-record-specification-type">List</a> of <i>any</i>, Object)<br /><span class="value">&rarr;</span> Object</td>
              <td>Creates an object. Invoked via the <code>new</code> or <code>super</code> operators. The first argument to the internal method is a list containing the arguments of the operator. The second argument is the object to which the <code>new</code> operator was initially applied. Objects that implement this internal method are called <i>constructors</i>. A function object is not necessarily a constructor and such non-constructor function objects do not have a [[Construct]] internal method.</td>
            </tr>
          </table>
        </figure>

        <p>The semantics of the essential internal methods for ordinary objects and standard exotic objects are specified in <a href="sec-ordinary-and-exotic-objects-behaviours">clause 9</a>. If any specified use of an internal method of an exotic
        object is not supported by an implementation, that usage must throw a <b>TypeError</b> exception when attempted.</p>
      </section>

      <section id="sec-invariants-of-the-essential-internal-methods">
        <h4 id="sec-6.1.7.3" title="6.1.7.3"> Invariants of the Essential Internal Methods</h4><p>The Internal Methods of Objects of an ECMAScript engine must conform to the list of invariants specified below.
        Ordinary ECMAScript Objects as well as all standard exotic objects in this specification maintain these invariants.
        ECMAScript Proxy objects maintain these invariants by means of runtime checks on the result of traps invoked on the
        [[ProxyHandler]] object.</p>

        <p>Any implementation provided exotic objects must also maintain these invariants for those objects. Violation of these
        invariants may cause ECMAScript code to have unpredictable behaviour and create security issues. However, violation of
        these invariants must never compromise the memory safety of an implementation.</p>

        <p>An implementation must not allow these invariants to be circumvented in any manner such as by providing alternative
        interfaces that implement the functionality of the essential internal methods without enforcing their invariants.</p>

        <p class="normalbefore">Definitions:</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The <i>target</i> of an internal method is the object upon which the
        internal method is called.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;A target is <i>non-extensible</i> if it has been observed to return
        false from its [[IsExtensible]] internal method, or true from its [[PreventExtensions]] internal method.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;A <i>non-existent</i> property is a property that does not exist as an
        own property on a non-extensible target.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;All references to <i><a href="sec-abstract-operations#sec-samevalue">SameValue</a></i> are
        according to the definition of <a href="sec-abstract-operations#sec-samevalue">SameValue</a> algorithm specified in <a href="sec-abstract-operations#sec-samevalue">7.2.9</a>.</p>

        <p class="normalbefore"><b>[[GetPrototypeOf]] ( )</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of the return value must be either Object or Null.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If target is non-extensible, and [[GetPrototypeOf]] returns a value v,
        then any future calls to [[GetPrototypeOf]] should return the <a href="sec-abstract-operations#sec-samevalue">SameValue</a> as v.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> An object&rsquo;s prototype chain should have finite length (that is, starting from
          any object, recursively applying the [[GetPrototypeOf]] internal method to its result should eventually lead to the
          value null). However, this requirement is not enforceable as an object level invariant if the prototype chain includes
          any exotic objects that do not use the ordinary object definition of [[GetPrototypeOf]]. Such a circular prototype chain
          may result in infinite loops when accessing object properties.</p>
        </div>

        <p class="normalbefore"><b>[[SetPrototypeOf]] (V)</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of the return value must be Boolean.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If target is non-extensible, [[SetPrototypeOf]] must return false,
        unless V is the <a href="sec-abstract-operations#sec-samevalue">SameValue</a> as the target&rsquo;s observed [[GetPrototypeOf]] value.</p>

        <p class="normalbefore"><b>[[PreventExtensions]] ( )</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of the return value must be Boolean.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If [[PreventExtensions]] returns true, all future calls to
        [[IsExtensible]] on the target must return false and the target is now considered non-extensible.</p>

        <p class="normalbefore"><b>[[GetOwnProperty]] (P)</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of the return value must be either <a href="#sec-property-descriptor-specification-type">Property Descriptor</a> or Undefined.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If the Type of the return value is <a href="#sec-property-descriptor-specification-type">Property Descriptor</a>, the return value must be a complete property
        descriptor (<a href="#sec-completepropertydescriptor">see 6.2.4.6</a>).</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If a property P is described as a data property with Desc.[[Value]]
        equal to v and Desc.[[Writable]] and Desc.[[Configurable]] are both false, then the <a href="sec-abstract-operations#sec-samevalue">SameValue</a>
        must be returned for the Desc.[[Value]] attribute of the property on all future calls to [[GetOwnProperty]] ( P ).</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If P&rsquo;s attributes other than [[Writable]] may change over time or
        if the property might disappear, then P&rsquo;s [[Configurable]] attribute must be true.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If the [[Writable]] attribute may change from false to true, then the
        [[Configurable]] attribute must be true.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If the target is non-extensible and P is non-existent, then all future
        calls to [[GetOwnProperty]] (P)  on the target must describe P as non-existent (i.e. [[GetOwnProperty]] (P) must return
        undefined).</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> As a consequence of the third invariant, if a property is described as a data property
          and it may return different values over time, then either or both of the Desc.[[Writable]] and Desc.[[Configurable]]
          attributes must be true even if no mechanism to change the value is exposed via the other internal methods.</p>
        </div>

        <p class="normalbefore"><b>[[DefineOwnProperty]] (P, Desc)</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of the return value must be Boolean.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;[[DefineOwnProperty]] must return false if P has previously been
        observed as a non-configurable own property of the target, unless either:</p>

        <p class="normalBulletSubstep">1.&#x9;P is a non-configurable writable own data property. A non-configurable writable data
        property can be changed into a non-configurable non-writable data property.</p>

        <p class="normalBulletSubstep">2.&#x9;All attributes in Desc are the <a href="sec-abstract-operations#sec-samevalue">SameValue</a> as P&rsquo;s
        attributes.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;[[DefineOwnProperty]] (P, Desc) must return false if target is
        non-extensible and P is a non-existent own property. That is, a non-extensible target object cannot be extended with new
        properties.</p>

        <p class="normalbefore"><b>[[HasProperty]] ( P )</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of the return value must be Boolean.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If P was previously observed as a non-configurable data or accessor own
        property of the target, [[HasProperty]] must return true.</p>

        <p class="normalbefore"><b>[[Get]] (P, Receiver)</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If P was previously observed as a non-configurable, non-writable own
        data property of the target with value v, then [[Get]] must return the <a href="sec-abstract-operations#sec-samevalue">SameValue</a>.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If P was previously observed as a non-configurable own accessor property
        of the target whose [[Get]] attribute is undefined, the [[Get]] operation must return undefined.</p>

        <p class="normalbefore"><b>[[Set]] ( P, V, Receiver)</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of the return value must be Boolean.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If P was previously observed as a non-configurable, non-writable own
        data property of the target, then [[Set]] must return false unless V is the <a href="sec-abstract-operations#sec-samevalue">SameValue</a> as
        P&rsquo;s [[Value]] attribute.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If P was previously observed as a non-configurable own accessor property
        of the target whose [[Set]] attribute is undefined, the [[Set]] operation must return false.</p>

        <p class="normalbefore"><b>[[Delete]] ( P )</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of the return value must be Boolean.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If P was previously observed to be a non-configurable own data or
        accessor property of the target, [[Delete]] must return false.</p>

        <p class="normalbefore"><b>[[Enumerate]] ( )</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of the return value must be Object.</p>

        <p class="normalbefore"><b>[[OwnPropertyKeys]] ( )</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The return value must be a <a href="#sec-list-and-record-specification-type">List</a>.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of each element of the returned <a href="#sec-list-and-record-specification-type">List</a> is either String or Symbol.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The returned <a href="#sec-list-and-record-specification-type">List</a>
        must contain at least the keys of all non-configurable own properties that have previously been observed.</p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;If the object is non-extensible, the returned <a href="#sec-list-and-record-specification-type">List</a> must contain only the keys of all own properties of the object
        that are observable using [[GetOwnProperty]].</p>

        <p class="normalbefore"><b>[[Construct]] ( )</b></p>

        <p class="normalBullet">&#x25cf;&nbsp;&nbsp;&nbsp;The Type of the return value must be Object.</p>
      </section>

      <section id="sec-well-known-intrinsic-objects">
        <h4 id="sec-6.1.7.4" title="6.1.7.4"> Well-Known Intrinsic Objects</h4><p>Well-known intrinsics are built-in objects that are explicitly referenced by the algorithms of this specification and
        which usually have <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> specific identities. Unless otherwise specified each intrinsic
        object actually corresponds to a set of similar objects, one per <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>.</p>

        <p>Within this specification a reference such as %name% means the intrinsic object, associated with <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the current Realm</a>, corresponding to the name. Determination of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the current Realm</a> and its intrinsics is described in <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">8.3</a>. The well-known intrinsics are listed in <a href="#table-7">Table 7</a>.</p>

        <figure>
          <figcaption><span id="table-7">Table 7</span> &mdash; Well-known Intrinsic Objects</figcaption>
          <table class="real-table">
            <tr>
              <th>Intrinsic Name</th>
              <th>Global Name</th>
              <th>ECMAScript Language Association</th>
            </tr>
            <tr>
              <td>%Array%</td>
              <td><code>Array</code></td>
              <td>The <code>Array</code> constructor (<a href="sec-indexed-collections#sec-array-constructor">22.1.1</a>)</td>
            </tr>
            <tr>
              <td>%ArrayBuffer%</td>
              <td><code>ArrayBuffer</code></td>
              <td>The <code>ArrayBuffer</code> constructor (<a href="sec-structured-data#sec-arraybuffer-constructor">24.1.2</a>)</td>
            </tr>
            <tr>
              <td>%ArrayBufferPrototype%</td>
              <td><code><a href="sec-structured-data#sec-arraybuffer.prototype">ArrayBuffer.prototype</a></code></td>
              <td>The initial value of the <code>prototype</code> data property of %ArrayBuffer%.</td>
            </tr>
            <tr>
              <td>%ArrayIteratorPrototype%</td>
              <td />
              <td>The prototype of Array iterator objects (<a href="sec-indexed-collections#sec-array-iterator-objects">22.1.5</a>)</td>
            </tr>
            <tr>
              <td>%ArrayPrototype%</td>
              <td><code>Array.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Array%  (<a href="sec-indexed-collections#sec-properties-of-the-array-prototype-object">22.1.3</a>)</td>
            </tr>
            <tr>
              <td>%ArrayProto_values%</td>
              <td><code><a href="sec-indexed-collections#sec-array.prototype.values">Array.prototype.values</a></code></td>
              <td>The initial value of the <code>values</code> data property of %ArrayPrototype% (<a href="sec-indexed-collections#sec-array.prototype.values">22.1.3.29</a>)</td>
            </tr>
            <tr>
              <td>%Boolean%</td>
              <td><code>Boolean</code></td>
              <td>The <code>Boolean</code> constructor (<a href="sec-fundamental-objects#sec-boolean-constructor">19.3.1</a>)</td>
            </tr>
            <tr>
              <td>%BooleanPrototype%</td>
              <td><code>Boolean.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Boolean% (<a href="sec-fundamental-objects#sec-properties-of-the-boolean-prototype-object">19.3.3</a>)</td>
            </tr>
            <tr>
              <td>%DataView%</td>
              <td><code>DataView</code></td>
              <td>The <code>DataView</code> constructor (<a href="sec-structured-data#sec-dataview-constructor">24.2.2</a>)</td>
            </tr>
            <tr>
              <td>%DataViewPrototype%</td>
              <td><code><a href="sec-structured-data#sec-dataview.prototype">DataView.prototype</a></code></td>
              <td>The initial value of the <code>prototype</code> data property of %DataView%</td>
            </tr>
            <tr>
              <td>%Date%</td>
              <td><code>Date</code></td>
              <td>The <code>Date</code> constructor (<a href="sec-numbers-and-dates#sec-date-constructor">20.3.2</a>)</td>
            </tr>
            <tr>
              <td>%DatePrototype%</td>
              <td><code>Date.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Date%.</td>
            </tr>
            <tr>
              <td>%decodeURI%</td>
              <td><code>decodeURI</code></td>
              <td>The <code>decodeURI</code> function (<a href="sec-global-object#sec-decodeuri-encodeduri">18.2.6.2</a>)</td>
            </tr>
            <tr>
              <td>%decodeURIComponent%</td>
              <td><code>decodeURIComponent</code></td>
              <td>The <code>decodeURIComponent</code> function (<a href="sec-global-object#sec-decodeuricomponent-encodeduricomponent">18.2.6.3</a>)</td>
            </tr>
            <tr>
              <td>%encodeURI%</td>
              <td><code>encodeURI</code></td>
              <td>The <code>encodeURI</code> function (<a href="sec-global-object#sec-encodeuri-uri">18.2.6.4</a>)</td>
            </tr>
            <tr>
              <td>%encodeURIComponent%</td>
              <td><code>encodeURIComponent</code></td>
              <td>The <code>encodeURIComponent</code> function (<a href="sec-global-object#sec-encodeuricomponent-uricomponent">18.2.6.5</a>)</td>
            </tr>
            <tr>
              <td>%Error%</td>
              <td><code>Error</code></td>
              <td>The <code>Error</code> constructor (<a href="sec-fundamental-objects#sec-error-constructor">19.5.1</a>)</td>
            </tr>
            <tr>
              <td>%ErrorPrototype%</td>
              <td><code>Error.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Error%</td>
            </tr>
            <tr>
              <td>%eval%</td>
              <td><code>eval</code></td>
              <td>The <code>eval</code> function (<a href="sec-global-object#sec-eval-x">18.2.1</a>)</td>
            </tr>
            <tr>
              <td>%EvalError%</td>
              <td><code>EvalError</code></td>
              <td>The <code>EvalError</code> constructor (<a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-evalerror">19.5.5.1</a>)</td>
            </tr>
            <tr>
              <td>%EvalErrorPrototype%</td>
              <td><code>EvalError.prototype</code></td>
              <td>The initial value of the <code>prototype</code> property of %EvalError%</td>
            </tr>
            <tr>
              <td>%Float32Array%</td>
              <td><code><a href="sec-global-object#sec-float32array">Float32Array</a></code></td>
              <td>The <code><a href="sec-global-object#sec-float32array">Float32Array</a></code> constructor (<a href="sec-indexed-collections#sec-typedarray-objects">22.2</a>)</td>
            </tr>
            <tr>
              <td>%Float32ArrayPrototype%</td>
              <td><code>Float32Array.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Float32Array%.</td>
            </tr>
            <tr>
              <td>%Float64Array%</td>
              <td><code><a href="sec-global-object#sec-float64array">Float64Array</a></code></td>
              <td>The <code><a href="sec-global-object#sec-float64array">Float64Array</a></code> constructor (<a href="sec-indexed-collections#sec-typedarray-objects">22.2</a>)</td>
            </tr>
            <tr>
              <td>%Float64ArrayPrototype%</td>
              <td><code>Float64Array.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Float64Array%</td>
            </tr>
            <tr>
              <td>%Function%</td>
              <td><code>Function</code></td>
              <td>The <code>Function</code> constructor (<a href="sec-fundamental-objects#sec-function-constructor">19.2.1</a>)</td>
            </tr>
            <tr>
              <td>%FunctionPrototype%</td>
              <td><code>Function.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Function%</td>
            </tr>
            <tr>
              <td>%Generator%</td>
              <td />
              <td>The initial value of the <code>prototype</code> property of %GeneratorFunction%</td>
            </tr>
            <tr>
              <td>%GeneratorFunction%</td>
              <td />
              <td>The constructor of generator objects (<a href="sec-control-abstraction-objects#sec-generatorfunction-constructor">25.2.1</a>)</td>
            </tr>
            <tr>
              <td>%GeneratorPrototype%</td>
              <td />
              <td>The initial value of the <code>prototype</code> property of %Generator%</td>
            </tr>
            <tr>
              <td>%Int8Array%</td>
              <td><code><a href="sec-global-object#sec-int8array">Int8Array</a></code></td>
              <td>The <code><a href="sec-global-object#sec-int8array">Int8Array</a></code> constructor (<a href="sec-indexed-collections#sec-typedarray-objects">22.2</a>)</td>
            </tr>
            <tr>
              <td>%Int8ArrayPrototype%</td>
              <td><code>Int8Array.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Int8Array%</td>
            </tr>
            <tr>
              <td>%Int16Array%</td>
              <td><code><a href="sec-global-object#sec-int16array">Int16Array</a></code></td>
              <td>The <code><a href="sec-global-object#sec-int16array">Int16Array</a></code> constructor (<a href="sec-indexed-collections#sec-typedarray-objects">22.2</a>)</td>
            </tr>
            <tr>
              <td>%Int16ArrayPrototype%</td>
              <td><code>Int16Array.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Int16Array%</td>
            </tr>
            <tr>
              <td>%Int32Array%</td>
              <td><code><a href="sec-global-object#sec-int32array">Int32Array</a></code></td>
              <td>The <code><a href="sec-global-object#sec-int32array">Int32Array</a></code> constructor (<a href="sec-indexed-collections#sec-typedarray-objects">22.2</a>)</td>
            </tr>
            <tr>
              <td>%Int32ArrayPrototype%</td>
              <td><code>Int32Array.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Int32Array%</td>
            </tr>
            <tr>
              <td>%isFinite%</td>
              <td><code>isFinite</code></td>
              <td>The <code>isFinite</code> function (<a href="sec-global-object#sec-isfinite-number">18.2.2</a>)</td>
            </tr>
            <tr>
              <td>%isNaN%</td>
              <td><code>isNaN</code></td>
              <td>The <code>isNaN</code> function (<a href="sec-global-object#sec-isnan-number">18.2.3</a>)</td>
            </tr>
            <tr>
              <td>%IteratorPrototype%</td>
              <td />
              <td>An object that all standard built-in  iterator objects indirectly inherit from</td>
            </tr>
            <tr>
              <td>%JSON%</td>
              <td><code>JSON</code></td>
              <td>The <code>JSON</code> object (<a href="sec-structured-data#sec-json-object">24.3</a>)</td>
            </tr>
            <tr>
              <td>%Map%</td>
              <td><code>Map</code></td>
              <td>The <code>Map</code> constructor (<a href="sec-keyed-collection#sec-map-constructor">23.1.1</a>)</td>
            </tr>
            <tr>
              <td>%MapIteratorPrototype%</td>
              <td />
              <td>The prototype of Map iterator objects (<a href="sec-keyed-collection#sec-map-iterator-objects">23.1.5</a>)</td>
            </tr>
            <tr>
              <td>%MapPrototype%</td>
              <td><code>Map.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Map%</td>
            </tr>
            <tr>
              <td>%Math%</td>
              <td><code>Math</code></td>
              <td>The <code>Math</code> object (<a href="sec-numbers-and-dates#sec-math-object">20.2</a>)</td>
            </tr>
            <tr>
              <td>%Number%</td>
              <td><code>Number</code></td>
              <td>The <code>Number</code> constructor (<a href="sec-numbers-and-dates#sec-number-constructor">20.1.1</a>)</td>
            </tr>
            <tr>
              <td>%NumberPrototype%</td>
              <td><code>Number.prototype</code></td>
              <td>The initial value of the <code>prototype</code> property of %Number%</td>
            </tr>
            <tr>
              <td>%Object%</td>
              <td><code>Object</code></td>
              <td>The <code>Object</code> constructor (<a href="sec-fundamental-objects#sec-object-constructor">19.1.1</a>)</td>
            </tr>
            <tr>
              <td>%ObjectPrototype%</td>
              <td><code>Object.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Object%. (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>)</td>
            </tr>
            <tr>
              <td>%ObjProto_toString%</td>
              <td><code>Object.prototype.<br />toString</code></td>
              <td>The initial value of the <code>toString</code> data property of %ObjectPrototype% (<a href="sec-fundamental-objects#sec-object.prototype.tostring">19.1.3.6</a>)</td>
            </tr>
            <tr>
              <td>%parseFloat%</td>
              <td><code>parseFloat</code></td>
              <td>The <code>parseFloat</code> function (<a href="sec-global-object#sec-parsefloat-string">18.2.4</a>)</td>
            </tr>
            <tr>
              <td>%parseInt%</td>
              <td><code>parseInt</code></td>
              <td>The <code>parseInt</code> function (<a href="sec-global-object#sec-parseint-string-radix">18.2.5</a>)</td>
            </tr>
            <tr>
              <td>%Promise%</td>
              <td><code>Promise</code></td>
              <td>The <code>Promise</code> constructor (<a href="sec-control-abstraction-objects#sec-promise-constructor">25.4.3</a>)</td>
            </tr>
            <tr>
              <td>%PromisePrototype%</td>
              <td><code>Promise.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Promise%</td>
            </tr>
            <tr>
              <td>%Proxy%</td>
              <td><code>Proxy</code></td>
              <td>The <code>Proxy</code> constructor (<a href="sec-reflection#sec-proxy-constructor">26.2.1</a>)</td>
            </tr>
            <tr>
              <td>%RangeError%</td>
              <td><code>RangeError</code></td>
              <td>The <code>RangeError</code> constructor (<a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-rangeerror">19.5.5.2</a>)</td>
            </tr>
            <tr>
              <td>%RangeErrorPrototype%</td>
              <td><code>RangeError.prototype</code></td>
              <td>The initial value of the <code>prototype</code> property of %RangeError%</td>
            </tr>
            <tr>
              <td>%ReferenceError%</td>
              <td><code>ReferenceError</code></td>
              <td>The <code>ReferenceError</code> constructor (<a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-referenceerror">19.5.5.3</a>)</td>
            </tr>
            <tr>
              <td>%ReferenceErrorPrototype%</td>
              <td><code>ReferenceError.<br />prototype</code></td>
              <td>The initial value of the <code>prototype</code> property of %ReferenceError%</td>
            </tr>
            <tr>
              <td>%Reflect%</td>
              <td><code>Reflect</code></td>
              <td>The <code>Reflect</code> object (<a href="sec-reflection#sec-reflect-object">26.1</a>)</td>
            </tr>
            <tr>
              <td>%RegExp%</td>
              <td><code>RegExp</code></td>
              <td>The <code>RegExp</code> constructor (<a href="sec-text-processing#sec-regexp-constructor">21.2.3</a>)</td>
            </tr>
            <tr>
              <td>%RegExpPrototype%</td>
              <td><code><a href="sec-text-processing#sec-regexp.prototype">RegExp.prototype</a></code></td>
              <td>The initial value of the <code>prototype</code> data property of %RegExp%</td>
            </tr>
            <tr>
              <td>%Set%</td>
              <td><code>Set</code></td>
              <td>The <code>Set</code> constructor (<a href="sec-keyed-collection#sec-set-constructor">23.2.1</a>)</td>
            </tr>
            <tr>
              <td>%SetIteratorPrototype%</td>
              <td />
              <td>The prototype of Set iterator objects (<a href="sec-keyed-collection#sec-set-iterator-objects">23.2.5</a>)</td>
            </tr>
            <tr>
              <td>%SetPrototype%</td>
              <td><code>Set.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Set%</td>
            </tr>
            <tr>
              <td>%String%</td>
              <td><code>String</code></td>
              <td>The <code>String</code> constructor (<a href="sec-text-processing#sec-string-constructor">21.1.1</a>)</td>
            </tr>
            <tr>
              <td>%StringIteratorPrototype%</td>
              <td />
              <td>The prototype of String iterator objects (<a href="sec-text-processing#sec-string-iterator-objects">21.1.5</a>)</td>
            </tr>
            <tr>
              <td>%StringPrototype%</td>
              <td><code>String.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %String%</td>
            </tr>
            <tr>
              <td>%Symbol%</td>
              <td><code>Symbol</code></td>
              <td>The <code>Symbol</code> constructor (<a href="sec-fundamental-objects#sec-symbol-constructor">19.4.1</a>)</td>
            </tr>
            <tr>
              <td>%SymbolPrototype%</td>
              <td><code>Symbol.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Symbol%. (<a href="sec-fundamental-objects#sec-properties-of-the-symbol-prototype-object">19.4.3</a>)</td>
            </tr>
            <tr>
              <td>%SyntaxError%</td>
              <td><code>SyntaxError</code></td>
              <td>The <code>SyntaxError</code> constructor (<a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-syntaxerror">19.5.5.4</a>)</td>
            </tr>
            <tr>
              <td>%SyntaxErrorPrototype%</td>
              <td><code>SyntaxError.prototype</code></td>
              <td>The initial value of the <code>prototype</code> property of %SyntaxError%</td>
            </tr>
            <tr>
              <td><a href="sec-ordinary-and-exotic-objects-behaviours#sec-%throwtypeerror%">%ThrowTypeError%</a></td>
              <td />
              <td>A function object that unconditionally throws a new instance of %TypeError%</td>
            </tr>
            <tr>
              <td>%TypedArray%</td>
              <td />
              <td>The super class of all typed Array  constructors (<a href="sec-indexed-collections#sec-%typedarray%-intrinsic-object">22.2.1</a>)</td>
            </tr>
            <tr>
              <td>%TypedArrayPrototype%</td>
              <td />
              <td>The initial value of the <code>prototype</code> property of %TypedArray%</td>
            </tr>
            <tr>
              <td>%TypeError%</td>
              <td><code>TypeError</code></td>
              <td>The <code>TypeError</code> constructor (<a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-typeerror">19.5.5.5</a>)</td>
            </tr>
            <tr>
              <td>%TypeErrorPrototype%</td>
              <td><code>TypeError.prototype</code></td>
              <td>The initial value of the <code>prototype</code> property of %TypeError%</td>
            </tr>
            <tr>
              <td>%Uint8Array%</td>
              <td><code><a href="sec-global-object#sec-uint8array">Uint8Array</a></code></td>
              <td>The <code><a href="sec-global-object#sec-uint8array">Uint8Array</a></code> constructor (<a href="sec-indexed-collections#sec-typedarray-objects">22.2</a>)</td>
            </tr>
            <tr>
              <td>%Uint8ArrayPrototype%</td>
              <td><code>Uint8Array.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Uint8Array%</td>
            </tr>
            <tr>
              <td>%Uint8ClampedArray%</td>
              <td><code><a href="sec-global-object#sec-uint8clampedarray">Uint8ClampedArray</a></code></td>
              <td>The <code><a href="sec-global-object#sec-uint8clampedarray">Uint8ClampedArray</a></code> constructor (<a href="sec-indexed-collections#sec-typedarray-objects">22.2</a>)</td>
            </tr>
            <tr>
              <td>%Uint8ClampedArrayPrototype%</td>
              <td><code><a href="sec-global-object#sec-uint8clampedarray">Uint8ClampedArray</a>.<br />prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Uint8ClampedArray%</td>
            </tr>
            <tr>
              <td>%Uint16Array%</td>
              <td><code><a href="sec-global-object#sec-uint16array">Uint16Array</a></code></td>
              <td>The <code><a href="sec-global-object#sec-uint16array">Uint16Array</a></code> constructor (<a href="sec-indexed-collections#sec-typedarray-objects">22.2</a>)</td>
            </tr>
            <tr>
              <td>%Uint16ArrayPrototype%</td>
              <td><code>Uint16Array.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Uint16Array%</td>
            </tr>
            <tr>
              <td>%Uint32Array%</td>
              <td><code><a href="sec-global-object#sec-uint32array">Uint32Array</a></code></td>
              <td>The <code><a href="sec-global-object#sec-uint32array">Uint32Array</a></code> constructor (<a href="sec-indexed-collections#sec-typedarray-objects">22.2</a>)</td>
            </tr>
            <tr>
              <td>%Uint32ArrayPrototype%</td>
              <td><code>Uint32Array.prototype</code></td>
              <td>The initial value of the <code>prototype</code> data property of %Uint32Array%</td>
            </tr>
            <tr>
              <td>%URIError%</td>
              <td><code><a href="sec-global-object#sec-constructor-properties-of-the-global-object-urierror">URIError</a></code></td>
              <td>The <code><a href="sec-global-object#sec-constructor-properties-of-the-global-object-urierror">URIError</a></code> constructor (<a href="sec-fundamental-objects#sec-native-error-types-used-in-this-standard-urierror">19.5.5.6</a>)</td>
            </tr>
            <tr>
              <td>%URIErrorPrototype%</td>
              <td><code>URIError.prototype</code></td>
              <td>The initial value of the <code>prototype</code> property of %URIError%</td>
            </tr>
            <tr>
              <td>%WeakMap%</td>
              <td><code>WeakMap</code></td>
              <td>The <code>WeakMap</code> constructor (<a href="sec-keyed-collection#sec-weakmap-constructor">23.3.1</a>)</td>
            </tr>
            <tr>
              <td>%WeakMapPrototype%</td>
              <td><code><a href="sec-keyed-collection#sec-weakmap.prototype">WeakMap.prototype</a></code></td>
              <td>The initial value of the <code>prototype</code> data property of %WeakMap%</td>
            </tr>
            <tr>
              <td>%WeakSet%</td>
              <td><code>WeakSet</code></td>
              <td>The <code>WeakSet</code> constructor (<a href="sec-keyed-collection#sec-weakset-constructor">23.4.1</a>)</td>
            </tr>
            <tr>
              <td>%WeakSetPrototype%</td>
              <td><code><a href="sec-keyed-collection#sec-weakset.prototype">WeakSet.prototype</a></code></td>
              <td>The initial value of the <code>prototype</code> data property of %WeakSet%</td>
            </tr>
          </table>
        </figure>
      </section>
    </section>
  </section>

  <section id="sec-ecmascript-specification-types">
    <div class="front">
      <h2 id="sec-6.2" title="6.2"> ECMAScript Specification Types</h2><p>A specification type corresponds to meta-values that are used within algorithms to describe the semantics of ECMAScript
      language constructs and ECMAScript language types. The specification types are <a href="#sec-reference-specification-type">Reference</a>, <a href="#sec-list-and-record-specification-type">List</a>, <a href="#sec-completion-record-specification-type">Completion</a>, <a href="#sec-property-descriptor-specification-type">Property Descriptor</a>, <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical
      Environment</a>, <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>, and <a href="#sec-data-blocks">Data Block</a>.
      Specification type values are specification artefacts that do not necessarily correspond to any specific entity within an
      ECMAScript implementation. Specification type values may be used to describe intermediate results of ECMAScript expression
      evaluation but such values cannot be stored as properties of objects or values of ECMAScript language variables.</p>
    </div>

    <section id="sec-list-and-record-specification-type">
      <h3 id="sec-6.2.1" title="6.2.1"> The List and Record Specification Type</h3><p>The List type is used to explain the evaluation of argument lists (<a href="sec-ecmascript-language-expressions#sec-argument-lists">see 12.3.6</a>) in
      <code>new</code> expressions, in function calls, and in other algorithms where a simple ordered list of values is needed.
      Values of the List type are simply ordered sequences of list elements containing the individual values. These sequences may
      be of any length. The elements of a list may be randomly accessed using 0-origin indices. For notational convenience an
      array-like syntax can be used to access List elements. For example, <i>arguments</i>[2] is shorthand for saying the
      3<sup>rd</sup> element of the List <i>arguments</i>.</p>

      <p>For notational convenience within this specification, a literal syntax can be used to express a new List value. For
      example, &laquo;1, 2&raquo; defines a List value that has two elements each of which is initialized to a specific value. A
      new empty List can be expressed as &laquo;&raquo;.</p>

      <p>The Record type is used to describe data aggregations within the algorithms of this specification. A Record type value
      consists of one or more named fields. The value of each field is either an ECMAScript value or an abstract value represented
      by a name associated with the Record type. Field names are always enclosed in double brackets, for example [[value]].</p>

      <p>For notational convenience within this specification, an object literal-like syntax can be used to express a Record
      value. For example, {[[field1]]: 42, [[field2]]: <b>false</b>, [[field3]]: <b>empty</b>} defines a Record value that has
      three fields, each of which is initialized to a specific value. Field name order is not significant. Any fields that are not
      explicitly listed are considered to be absent.</p>

      <p>In specification text and algorithms, dot notation may be used to refer to a specific field of a Record value. For
      example, if R is the record shown in the previous paragraph then R.[[field2]] is shorthand for &ldquo;the field of R named
      [[field2]]&rdquo;.</p>

      <p>Schema for commonly used Record field combinations may be named, and that name may be used as a prefix to a literal
      Record value to identify the specific kind of aggregations that is being described. For example:
      PropertyDescriptor{[[Value]]: 42, [[Writable]]: <b>false</b>, [[Configurable]]: <b>true</b>}.</p>
    </section>

    <section id="sec-completion-record-specification-type">
      <div class="front">
        <h3 id="sec-6.2.2" title="6.2.2"> The Completion Record Specification Type</h3><p>The Completion type is a Record used to explain the runtime propagation of values and control flow such as the
        behaviour of statements (<code>break</code>, <code>continue</code>, <code>return</code> and <code>throw</code>) that
        perform nonlocal transfers of control.</p>

        <p>Values of the Completion type are Record values whose fields are defined as by <a href="#table-8">Table 8</a>.</p>

        <figure>
          <figcaption><span id="table-8">Table 8</span> &mdash; Completion Record Fields</figcaption>
          <table class="real-table">
            <tr>
              <th>Field</th>
              <th>Value</th>
              <th>Meaning</th>
            </tr>
            <tr>
              <td>[[type]]</td>
              <td>One of <b>normal</b>, <b>break</b>, <b>continue</b>, <b>return</b>, or <b>throw</b></td>
              <td>The type of completion that occurred.</td>
            </tr>
            <tr>
              <td>[[value]]</td>
              <td>any <a href="#sec-ecmascript-language-types">ECMAScript language value</a> or <b>empty</b></td>
              <td>The value that was produced.</td>
            </tr>
            <tr>
              <td>[[target]]</td>
              <td>any ECMAScript string or <b>empty</b></td>
              <td>The target label for directed control transfers.</td>
            </tr>
          </table>
        </figure>

        <p>The term &ldquo;abrupt completion&rdquo; refers to any completion with a <span style="font-family: Times New         Roman">[[type]]</span> value other than <b>normal</b>.</p>
      </div>

      <section id="sec-normalcompletion">
        <h4 id="sec-6.2.2.1" title="6.2.2.1">
            NormalCompletion</h4><p class="normalbefore">The abstract operation NormalCompletion with a single <i>argument</i>, such as:</p>

        <ol class="proc">
          <li>Return NormalCompletion(<i>argument</i>).</li>
        </ol>

        <p class="normalbefore">Is a shorthand that is defined as follows:</p>

        <ol class="proc">
          <li>Return <a href="#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:               sans-serif">normal</span>, [[value]]: <i>argument</i>, [[target]]:<span style="font-family:               sans-serif">empty</span>}.</li>
        </ol>
      </section>

      <section id="sec-implicit-completion-values">
        <h4 id="sec-6.2.2.2" title="6.2.2.2"> Implicit Completion Values</h4><p class="normalbefore">The algorithms of this specification often implicitly return <a href="#sec-completion-record-specification-type">Completion</a> Records whose [[type]] is <b>normal</b>. Unless it is
        otherwise obvious from the context, an algorithm statement that returns a value that is not a <a href="#sec-completion-record-specification-type">Completion Record</a>, such as:</p>

        <ol class="proc">
          <li>Return <code>"Infinity"</code>.</li>
        </ol>

        <p class="normalbefore">means the same thing as:</p>

        <ol class="proc">
          <li>Return <a href="#sec-normalcompletion">NormalCompletion</a>(<code>"Infinity"</code>).</li>
        </ol>

        <p>However, if the value expression of a &ldquo;<span style="font-family: Times New Roman">return</span>&rdquo; statement
        is a <a href="#sec-completion-record-specification-type">Completion Record</a> construction literal, the resulting <a href="#sec-completion-record-specification-type">Completion Record</a> is returned. If the value expression is a call to
        an abstract operation, the &ldquo;<span style="font-family: Times New Roman">return</span>&rdquo; statement simply returns
        the <a href="#sec-completion-record-specification-type">Completion Record</a> produced by the abstract operation.</p>

        <p class="normalbefore">The abstract operation <span style="font-family: Times New Roman"><a href="#sec-completion-record-specification-type">Completion</a>(<i>completionRecord</i>)</span> is used to emphasize that
        a previously computed <a href="#sec-completion-record-specification-type">Completion Record</a> is being returned. The <a href="#sec-completion-record-specification-type">Completion</a> abstract operation takes a single argument,
        <var>completionRecord</var>, and performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>completionRecord</i> is a <a href="#sec-completion-record-specification-type">Completion Record</a>.</li>
          <li>Return <i>completionRecord</i>  as the <a href="#sec-completion-record-specification-type">Completion Record</a> of
              this abstract operation.</li>
        </ol>

        <p>A &ldquo;<span style="font-family: Times New Roman">return</span>&rdquo; statement without a value in an algorithm step
        means the same thing as:</p>

        <ol class="proc">
          <li>Return <a href="#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
        </ol>

        <p>Any reference to a <a href="#sec-completion-record-specification-type">Completion Record</a> value that is in a context
        that does not explicitly require a complete <a href="#sec-completion-record-specification-type">Completion Record</a>
        value is equivalent to an explicit reference to the [[value]] field of the <a href="#sec-completion-record-specification-type">Completion Record</a> value unless the <a href="#sec-completion-record-specification-type">Completion Record</a> is an <a href="#sec-completion-record-specification-type">abrupt completion</a>.</p>
      </section>

      <section id="sec-throw-an-exception">
        <h4 id="sec-6.2.2.3" title="6.2.2.3"> Throw an Exception</h4><p class="normalbefore">Algorithms steps that say to throw an exception, such as</p>

        <ol class="proc">
          <li>Throw a <b>TypeError</b> exception.</li>
        </ol>

        <p class="normalbefore">mean the same things as:</p>

        <ol class="proc">
          <li>Return <a href="#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:               sans-serif">throw</span>, [[value]]: a newly created <b>TypeError</b> object, [[target]]:<span style="font-family:               sans-serif">empty</span>}.</li>
        </ol>
      </section>

      <section id="sec-returnifabrupt">
        <h4 id="sec-6.2.2.4" title="6.2.2.4">
            ReturnIfAbrupt</h4><p class="normalbefore">Algorithms steps that say</p>

        <ol class="proc">
          <li>ReturnIfAbrupt(<i>argument</i>).</li>
        </ol>

        <p class="normalbefore">mean the same thing as:</p>

        <ol class="proc">
          <li>If <i>argument</i> is an <a href="#sec-completion-record-specification-type">abrupt completion</a>, return
              <i>argument</i>.</li>
          <li>Else if <i>argument</i> is a <a href="#sec-completion-record-specification-type">Completion Record</a>, let
              <i>argument</i> be <i>argument</i>.[[value]].</li>
        </ol>
      </section>

      <section id="sec-updateempty">
        <h4 id="sec-6.2.2.5" title="6.2.2.5">
            UpdateEmpty ( completionRecord, value)</h4><p class="normalbefore">The abstract operation UpdateEmpty with arguments <var>completionRecord</var> and <var>value</var>
        performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: if <i>completionRecord</i>.[[type]] is <span style="font-family:               sans-serif">throw</span> then <i>completionRecord</i>.[[value]] is not <span style="font-family:               sans-serif">empty</span>.</li>
          <li>If <i>completionRecord</i>.[[type]] is <span style="font-family: sans-serif">throw</span>, return <a href="#sec-completion-record-specification-type">Completion</a>(<i>completionRecord</i>).</li>
          <li>If <i>completionRecord</i>.[[value]] is not <span style="font-family: sans-serif">empty</span>, return <a href="#sec-completion-record-specification-type">Completion</a>(<i>completionRecord</i>).</li>
          <li>Return <a href="#sec-completion-record-specification-type">Completion</a>{[[type]]:
              <i>completionRecord</i>.[[type]], [[value]]: <i>value</i>, [[target]]: <i>completionRecord</i>.[[target]] }.</li>
        </ol>
      </section>
    </section>

    <section id="sec-reference-specification-type">
      <div class="front">
        <h3 id="sec-6.2.3" title="6.2.3"> The Reference Specification Type</h3><div class="note">
          <p><span class="nh">NOTE</span> The Reference type is used to explain the behaviour of such operators as
          <code>delete</code>, <code>typeof</code>, the assignment operators, the <code>super</code> keyword and other language
          features. For example, the left-hand operand of an assignment is expected to produce a reference.</p>
        </div>

        <p>A <b>Reference</b> is a resolved name or property binding. A Reference consists of three components, the
        <var>base</var> value, the <var>referenced name</var> and the Boolean valued <var>strict reference</var> flag. The
        <var>base</var> value is either <b>undefined</b>, an Object, a Boolean, a String, a Symbol, a Number, or an <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> (<a href="sec-executable-code-and-execution-contexts#sec-environment-records">8.1.1</a>). A <var>base</var>
        value of <b>undefined</b> indicates that the Reference could not be resolved to a binding. The <var>referenced name</var>
        is a String or Symbol value.</p>

        <p>A Super Reference is a Reference that is used to represents a name binding that was expressed using the super keyword.
        A Super Reference has an additional <var>thisValue</var> component and its <var>base</var> value will never be an <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>.</p>

        <p class="normalbefore">The following abstract operations are used in this specification to access the components of
        references:</p>

        <ul>
          <li>
            <p>GetBase(V). Returns the <var>base</var> value component of the reference V.</p>
          </li>

          <li>
            <p>GetReferencedName(V). Returns the <var>referenced name</var> component of the reference V.</p>
          </li>

          <li>
            <p>IsStrictReference(V). Returns the <var>strict reference</var> flag component of the reference V.</p>
          </li>

          <li>
            <p>HasPrimitiveBase(V). Returns <span class="value">true</span> if <a href="sec-ecmascript-data-types-and-values">Type</a>(<span style="font-family: Times New Roman"><i>base</i>)</span>
            is Boolean, String, Symbol, or Number.</p>
          </li>

          <li>
            <p>IsPropertyReference(V). Returns <span class="value">true</span> if either the <var>base</var> value is an object or
            HasPrimitiveBase(V) is <b>true</b>; otherwise returns <span class="value">false</span>.</p>
          </li>

          <li>
            <p>IsUnresolvableReference(V). Returns <span class="value">true</span> if the <var>base</var> value is
            <b>undefined</b> and <b>false</b> otherwise.</p>
          </li>

          <li>
            <p>IsSuperReference(V). Returns <span class="value">true</span> if this reference has a <var>thisValue</var>
            component.</p>
          </li>
        </ul>

        <p>The following abstract operations are used in this specification to operate on references:</p>
      </div>

      <section id="sec-getvalue">
        <h4 id="sec-6.2.3.1" title="6.2.3.1"> GetValue
            (V)</h4><ol class="proc">
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>V</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>V</i>) is not <a href="#sec-reference-specification-type">Reference</a>, return <i>V</i>.</li>
          <li>Let <i>base</i> be <a href="#sec-reference-specification-type">GetBase</a>(<i>V</i>).</li>
          <li>If <a href="#sec-reference-specification-type">IsUnresolvableReference</a>(<i>V</i>), throw a <b>ReferenceError</b>
              exception.</li>
          <li>If <a href="#sec-reference-specification-type">IsPropertyReference</a>(<i>V</i>), then
            <ol class="block">
              <li>If <a href="#sec-reference-specification-type">HasPrimitiveBase</a>(<i>V</i>) is <b>true</b>, then
                <ol class="block">
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: In this case, <i>base</i> will never be <b>null</b> or
                      <b>undefined</b>.</li>
                  <li>Let <i>base</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>base</i>).</li>
                </ol>
              </li>
              <li>Return <i>base.</i>[[Get]](<a href="#sec-reference-specification-type">GetReferencedName</a>(<i>V</i>), <a href="#sec-getthisvalue">GetThisValue</a>(<i>V</i>)).</li>
            </ol>
          </li>
          <li>Else <i>base</i> must be an <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>,
            <ol class="block">
              <li>Return <i>base.</i>GetBindingValue(<a href="#sec-reference-specification-type">GetReferencedName</a>(<i>V</i>),
                  <a href="#sec-reference-specification-type">IsStrictReference</a>(<i>V</i>)) (<a href="sec-executable-code-and-execution-contexts#sec-environment-records">see 8.1.1</a>).</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The object that may be created in step 5.a.ii is not accessible outside of the above
          abstract operation and the ordinary object [[Get]] internal method. An implementation might choose to avoid the actual
          creation of the object.</p>
        </div>
      </section>

      <section id="sec-putvalue">
        <h4 id="sec-6.2.3.2" title="6.2.3.2"> PutValue
            (V, W)</h4><ol class="proc">
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>V</i>).</li>
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>W</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>V</i>) is not <a href="#sec-reference-specification-type">Reference</a>, throw a <b>ReferenceError</b> exception.</li>
          <li>Let <i>base</i> be <a href="#sec-reference-specification-type">GetBase</a>(<i>V</i>).</li>
          <li>If <a href="#sec-reference-specification-type">IsUnresolvableReference</a>(<i>V</i>), then
            <ol class="block">
              <li>If <a href="#sec-reference-specification-type">IsStrictReference</a>(<i>V</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Throw <b>ReferenceError</b> exception.</li>
                </ol>
              </li>
              <li>Let <i>globalObj</i> be <a href="sec-executable-code-and-execution-contexts#sec-getglobalobject">GetGlobalObject</a>().</li>
              <li>Return <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>globalObj</i>,<a href="#sec-reference-specification-type">GetReferencedName</a>(<i>V</i>), <i>W</i>, <b>false</b>).</li>
            </ol>
          </li>
          <li>Else if <a href="#sec-reference-specification-type">IsPropertyReference</a>(<i>V</i>), then
            <ol class="block">
              <li>If <a href="#sec-reference-specification-type">HasPrimitiveBase</a>(<i>V</i>) is <b>true</b>, then
                <ol class="block">
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: In this case, <i>base</i> will never be <b>null</b> or
                      <b>undefined</b>.</li>
                  <li>Set <i>base</i>  to <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>base</i>).</li>
                </ol>
              </li>
              <li>Let <i>succeeded</i> be <i>base.</i>[[Set]](<a href="#sec-reference-specification-type">GetReferencedName</a>(<i>V</i>), <i>W</i>, <a href="#sec-getthisvalue">GetThisValue</a>(<i>V</i>)).</li>
              <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>succeeded</i>).</li>
              <li>If <i>succeeded</i> is <b>false</b> and <a href="#sec-reference-specification-type">IsStrictReference</a>(<i>V</i>) is <b>true</b>, throw a
                  <b>TypeError</b> exception.</li>
              <li>Return.</li>
            </ol>
          </li>
          <li>Else <i>base</i> must be an <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>.
            <ol class="block">
              <li>Return <i>base.</i>SetMutableBinding(<a href="#sec-reference-specification-type">GetReferencedName</a>(<i>V</i>), <i>W</i>, <a href="#sec-reference-specification-type">IsStrictReference</a>(<i>V</i>)) (<a href="sec-executable-code-and-execution-contexts#sec-environment-records">see 8.1.1</a>).</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The object that may be created in step 6.a.ii is not accessible outside of the above
          algorithm and the ordinary object [[Set]] internal method. An implementation might choose to avoid the actual creation
          of that object.</p>
        </div>
      </section>

      <section id="sec-getthisvalue">
        <h4 id="sec-6.2.3.3" title="6.2.3.3">
            GetThisValue (V)</h4><ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="#sec-reference-specification-type">IsPropertyReference</a>(<i>V</i>) is <b>true</b>.</li>
          <li>If <a href="#sec-reference-specification-type">IsSuperReference</a>(<i>V</i>), then
            <ol class="block">
              <li>Return the value of the <i>thisValue</i> component of the reference <i>V</i>.</li>
            </ol>
          </li>
          <li>Return <a href="#sec-reference-specification-type">GetBase</a>(<i>V</i>).</li>
        </ol>
      </section>

      <section id="sec-initializereferencedbinding">
        <h4 id="sec-6.2.3.4" title="6.2.3.4"> InitializeReferencedBinding (V, W)</h4><ol class="proc">
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>V</i>).</li>
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>W</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>V</i>)
              is <a href="#sec-reference-specification-type">Reference</a>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="#sec-reference-specification-type">IsUnresolvableReference</a>(<i>V</i>) is <b>false</b>.</li>
          <li>Let <i>base</i> be <a href="#sec-reference-specification-type">GetBase</a>(<i>V</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>base</i> is an <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment
              Record</a>.</li>
          <li>Return <i>base.</i>InitializeBinding(<a href="#sec-reference-specification-type">GetReferencedName</a>(<i>V</i>),
              <i>W</i>).</li>
        </ol>
      </section>
    </section>

    <section id="sec-property-descriptor-specification-type">
      <div class="front">
        <h3 id="sec-6.2.4" title="6.2.4"> The Property Descriptor Specification Type</h3><p>The Property Descriptor type is used to explain the manipulation and reification of Object property attributes. Values
        of the Property Descriptor type are Records. Each field&rsquo;s name is an attribute name and its value is a corresponding
        attribute value as specified in <a href="#sec-property-attributes">6.1.7.1</a>. In addition, any field may be present or
        absent. The schema name used within this specification to tag literal descriptions of Property Descriptor records is
        &ldquo;PropertyDescriptor&rdquo;.</p>

        <p>Property Descriptor values may be further classified as data Property Descriptors and accessor Property Descriptors
        based upon the existence or use of certain fields. A data Property Descriptor is one that includes any fields named either
        [[Value]] or [[Writable]]. An accessor Property Descriptor is one that includes any fields named either [[Get]] or
        [[Set]]. Any Property Descriptor may have fields named [[Enumerable]] and [[Configurable]]. A Property Descriptor value
        may not be both a data Property Descriptor and an accessor Property Descriptor; however, it may be neither. A generic
        Property Descriptor is a Property Descriptor value that is neither a data Property Descriptor nor an accessor Property
        Descriptor. A fully populated Property Descriptor is one that is either an accessor Property Descriptor or a data Property
        Descriptor and that has all of the fields that correspond to the property attributes defined in either  <a href="#table-2">Table 2</a> or <a href="#table-3">Table 3</a>.</p>

        <p>The following abstract operations are used in this specification to operate upon Property Descriptor values:</p>
      </div>

      <section id="sec-isaccessordescriptor">
        <h4 id="sec-6.2.4.1" title="6.2.4.1"> IsAccessorDescriptor ( Desc )</h4><p class="normalbefore">When the abstract operation IsAccessorDescriptor is called with <a href="#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>If <i>Desc</i> is <b>undefined</b>, return <b>false</b>.</li>
          <li>If both <i>Desc</i>.[[Get]] and <i>Desc</i>.[[Set]] are absent, return <b>false</b>.</li>
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-isdatadescriptor">
        <h4 id="sec-6.2.4.2" title="6.2.4.2">
            IsDataDescriptor ( Desc )</h4><p class="normalbefore">When the abstract operation IsDataDescriptor is called with <a href="#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>If <i>Desc</i> is <b>undefined</b>, return <b>false</b>.</li>
          <li>If both <i>Desc</i>.[[Value]] and <i>Desc</i>.[[Writable]] are absent, return <b>false</b>.</li>
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-isgenericdescriptor">
        <h4 id="sec-6.2.4.3" title="6.2.4.3"> IsGenericDescriptor ( Desc )</h4><p class="normalbefore">When the abstract operation IsGenericDescriptor is called with <a href="#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>If <i>Desc</i> is <b>undefined</b>, return <b>false</b>.</li>
          <li>If <a href="#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>Desc</i>) and <a href="#sec-isdatadescriptor">IsDataDescriptor</a>(<i>Desc</i>) are both <b>false</b>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-frompropertydescriptor">
        <h4 id="sec-6.2.4.4" title="6.2.4.4"> FromPropertyDescriptor ( Desc )</h4><p class="normalbefore">When the abstract operation FromPropertyDescriptor is called with <a href="#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>If <i>Desc</i> is <b>undefined</b>, return <b>undefined</b>.</li>
          <li>Let <i>obj</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<span style="font-family:               sans-serif">%ObjectPrototype%</span>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>obj</i> is an extensible ordinary object with no own
              properties.</li>
          <li>If <i>Desc</i> has a [[Value]] field, then
            <ol class="block">
              <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>obj</i>, <code>"value"</code>,
                  <i>Desc</i>.[[Value]]).</li>
            </ol>
          </li>
          <li>If <i>Desc</i> has a [[Writable]] field, then
            <ol class="block">
              <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>obj</i>, <code>"writable"</code>,
                  <i>Desc</i>.[[Writable]]).</li>
            </ol>
          </li>
          <li>If <i>Desc</i> has a [[Get]] field, then
            <ol class="block">
              <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>obj</i>, <code>"get"</code>,
                  <i>Desc</i>.[[Get]]).</li>
            </ol>
          </li>
          <li>If <i>Desc</i> has a [[Set]] field, then
            <ol class="block">
              <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>obj</i>, <code>"set"</code>,
                  <i>Desc</i>.[[Set]])</li>
            </ol>
          </li>
          <li>If <i>Desc</i> has an [[Enumerable]] field, then
            <ol class="block">
              <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>obj</i>, <code>"enumerable"</code>,
                  <i>Desc</i>.[[Enumerable]]).</li>
            </ol>
          </li>
          <li>If <i>Desc</i> has a [[Configurable]] field, then
            <ol class="block">
              <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>obj</i> , <code>"configurable"</code>,
                  <i>Desc</i>.[[Configurable]]).</li>
            </ol>
          </li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: all of the above <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a> operations return <b>true</b>.</li>
          <li>Return <i>obj</i>.</li>
        </ol>
      </section>

      <section id="sec-topropertydescriptor">
        <h4 id="sec-6.2.4.5" title="6.2.4.5"> ToPropertyDescriptor ( Obj )</h4><p class="normalbefore">When the abstract operation ToPropertyDescriptor is called with object <span class="nt">Obj</span>, the following steps are taken:</p>

        <ol class="proc">
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>Obj</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>Obj</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>desc</i> be a new <a href="#sec-property-descriptor-specification-type">Property Descriptor</a> that
              initially has no fields.</li>
          <li>Let <i>hasEnumerable</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>Obj</i>, <code>"enumerable"</code>).</li>
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasEnumerable</i>).</li>
          <li>If <i>hasEnumerable</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>enum</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>Obj</i>,
                  <code>"enumerable"</code>)).</li>
              <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>enum</i>).</li>
              <li>Set the [[Enumerable]] field of <i>desc</i> to <i>enum</i>.</li>
            </ol>
          </li>
          <li>Let <i>hasConfigurable</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>Obj</i>,
              <code>"configurable"</code>).</li>
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasConfigurable</i>).</li>
          <li>If <i>hasConfigurable</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>conf</i>  be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>Obj</i>,
                  <code>"configurable"</code>)).</li>
              <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>conf</i>).</li>
              <li>Set the [[Configurable]] field of <i>desc</i> to <i>conf</i>.</li>
            </ol>
          </li>
          <li>Let <i>hasValue</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>Obj</i>, <code>"value"</code>).</li>
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasValue</i>).</li>
          <li>If <i>hasValue</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>value</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>Obj</i>, <code>"value"</code>).</li>
              <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
              <li>Set the [[Value]] field of <i>desc</i> to <i>value</i>.</li>
            </ol>
          </li>
          <li>Let <i>hasWritable</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>Obj</i>, <code>"writable"</code>).</li>
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasWritable</i>).</li>
          <li>If <i>hasWritable</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>writable</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>Obj</i>,
                  <code>"writable"</code>)).</li>
              <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>writable</i>).</li>
              <li>Set the [[Writable]] field of <i>desc</i> to <i>writable</i>.</li>
            </ol>
          </li>
          <li>Let <i>hasGet</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>Obj</i>, <code>"get"</code>).</li>
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasGet</i>).</li>
          <li>If <i>hasGet</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>getter</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>Obj</i>, <code>"get"</code>).</li>
              <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>getter</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>getter</i>) is <b>false</b> and <i>getter</i> is not
                  <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
              <li>Set the [[Get]] field of <i>desc</i> to <i>getter</i>.</li>
            </ol>
          </li>
          <li>Let <i>hasSet</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>Obj</i>, <code>"set"</code>).</li>
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>hasSet</i>).</li>
          <li>If <i>hasSet</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>setter</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>Obj</i>, <code>"set"</code>).</li>
              <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setter</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>setter</i>) is <b>false</b> and <i>setter</i> is not
                  <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
              <li>Set the [[Set]] field of <i>desc</i> to <i>setter</i>.</li>
            </ol>
          </li>
          <li>If either <i>desc</i>.[[Get]] or <i>desc</i>.[[Set]] is present, then
            <ol class="block">
              <li>If either <i>desc</i>.[[Value]] or <i>desc</i>.[[Writable]] is present, throw a <b>TypeError</b> exception.</li>
            </ol>
          </li>
          <li>Return <i>desc</i>.</li>
        </ol>
      </section>

      <section id="sec-completepropertydescriptor">
        <h4 id="sec-6.2.4.6" title="6.2.4.6"> CompletePropertyDescriptor ( Desc  )</h4><p class="normalbefore">When the abstract operation CompletePropertyDescriptor is called with <a href="#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span> the following
        steps are taken:</p>

        <ol class="proc">
          <li><a href="#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>Desc</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>Desc</i> is a <a href="#sec-property-descriptor-specification-type">Property Descriptor</a></li>
          <li>Let <i>like</i> be Record{[[Value]]: <b>undefined</b>, [[Writable]]: <b>false</b>, [[Get]]: <b>undefined</b>,
              [[Set]]: <b>undefined</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>false</b>}.</li>
          <li>If either <a href="#sec-isgenericdescriptor">IsGenericDescriptor</a>(<i>Desc</i>) or <a href="#sec-isdatadescriptor">IsDataDescriptor</a>(<i>Desc</i>) is <b>true</b>, then
            <ol class="block">
              <li>If <i>Desc</i> does not have a [[Value]] field, set <i>Desc</i>.[[Value]] to <i>like</i>.[[Value]].</li>
              <li>If <i>Desc</i> does not have a [[Writable]] field, set <i>Desc</i>.[[Writable]] to
                  <i>like</i>.[[Writable]].</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>If <i>Desc</i> does not have a [[Get]] field, set <i>Desc</i>.[[Get]] to <i>like</i>.[[Get]].</li>
              <li>If <i>Desc</i> does not have a [[Set]] field, set <i>Desc</i>.[[Set]] to <i>like</i>.[[Set]].</li>
            </ol>
          </li>
          <li>If <i>Desc</i> does not have an [[Enumerable]] field, set <i>Desc</i>.[[Enumerable]] to
              <i>like</i>.[[Enumerable]].</li>
          <li>If <i>Desc</i> does not have a [[Configurable]] field, set <i>Desc</i>.[[Configurable]] to
              <i>like</i>.[[Configurable]].</li>
          <li>Return <i>Desc</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-lexical-environment-and-environment-record-specification-types">
      <h3 id="sec-6.2.5" title="6.2.5"> The Lexical Environment and Environment Record Specification Types</h3><p>The <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a> and <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment
      Record</a> types are used to explain the behaviour of name resolution in nested functions and blocks. These types and the
      operations upon them are defined in <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">8.1</a>.</p>
    </section>

    <section id="sec-data-blocks">
      <div class="front">
        <h3 id="sec-6.2.6" title="6.2.6"> Data
            Blocks</h3><p>The Data Block specification type is used to describe a distinct and mutable sequence of byte-sized (8 bit)  numeric
        values. A Data Block value is created with a fixed number of bytes that each have the initial value 0.</p>

        <p>For notational convenience within this specification, an array-like syntax can be used to access the individual bytes
        of a Data Block value. This notation presents a Data Block value as a 0-origined integer indexed sequence of bytes. For
        example, if <var>db</var> is a 5 byte Data Block value then <var>db</var>[2] can be used to access its 3<sup>rd</sup>
        byte.</p>

        <p>The following abstract operations are used in this specification to operate upon Data Block values:</p>
      </div>

      <section id="sec-createbytedatablock">
        <h4 id="sec-6.2.6.1" title="6.2.6.1"> CreateByteDataBlock(size)</h4><p class="normalbefore">When the abstract operation CreateByteDataBlock is called with integer argument <var>size</var>,
        the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>size</i>&ge;0.</li>
          <li>Let <i>db</i> be a new <a href="#sec-data-blocks">Data Block</a> value consisting of <i>size</i> bytes. If it is
              impossible to create such a <a href="#sec-data-blocks">Data Block</a>, throw a <b>RangeError</b> exception.</li>
          <li>Set all of the bytes of <i>db</i> to 0.</li>
          <li>Return <i>db</i>.</li>
        </ol>
      </section>

      <section id="sec-copydatablockbytes">
        <h4 id="sec-6.2.6.2" title="6.2.6.2"> CopyDataBlockBytes(toBlock, toIndex, fromBlock, fromIndex, count)</h4><p class="normalbefore">When the abstract operation CopyDataBlockBytes is called the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>fromBlock</i> and <i>toBlock</i> are distinct <a href="#sec-data-blocks">Data Block</a> values.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>fromIndex</i>, <i>toIndex</i>, and <i>count</i> are positive
              integer values.</li>
          <li>Let <i>fromSize</i> be the number of bytes in <i>fromBlock</i>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>fromIndex</i>+<i>count</i> &le; <i>fromSize</i>.</li>
          <li>Let <i>toSize</i> be the number of bytes in <i>toBlock</i>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>toIndex</i>+<i>count</i> &le; <i>toSize</i>.</li>
          <li>Repeat, while <i>count</i>&gt;0
            <ol class="block">
              <li>Set <i>toBlock</i>[<i>toIndex</i>] to the value of <i>fromBlock</i>[<i>fromIndex</i>].</li>
              <li>Increment <i>toIndex</i> and <i>fromIndex</i> each by 1.</li>
              <li>Decrement <i>count</i> by 1.</li>
            </ol>
          </li>
          <li>Return <a href="#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>)</li>
        </ol>
      </section>
    </section>
  </section>
</section>

