<section id="sec-control-abstraction-objects">
  <div class="front">
    <h1 id="sec-25" title="25">
        Control Abstraction Objects</h1></div>

  <section id="sec-iteration">
    <div class="front">
      <h2 id="sec-25.1" title="25.1"> Iteration</h2></div>

    <section id="sec-common-iteration-interfaces">
      <div class="front">
        <h3 id="sec-25.1.1" title="25.1.1"> Common Iteration Interfaces</h3><p>An interface is a set of property keys whose associated values match a specific specification. Any object that provides
        all the properties as described by an interface&rsquo;s specification <i>conforms</i> to that interface. An interface is
        not represented by a distinct object. There may be many separately implemented objects that conform to any interface. An
        individual object may conform to multiple interfaces.</p>
      </div>

      <section id="sec-iterable-interface">
        <h4 id="sec-25.1.1.1" title="25.1.1.1"> The </h4><p>The <i>Iterable</i> interface includes the property described in <a href="#table-52">Table 52</a>:</p>

        <figure>
          <figcaption><span id="table-52">Table 52</span> &mdash; <i>Iterable</i> Interface Required Properties</figcaption>
          <table class="real-table">
            <tr>
              <th style="background-color: #A6A6A6">Property</th>
              <th style="background-color: #A6A6A6">Value</th>
              <th style="background-color: #A6A6A6">Requirements</th>
            </tr>
            <tr>
              <td><code>@@iterator</code></td>
              <td>A function that returns an <i>Iterator</i> object.</td>
              <td>The returned object must conform to the <i>Iterator</i> interface.</td>
            </tr>
          </table>
        </figure>
      </section>

      <section id="sec-iterator-interface">
        <h4 id="sec-25.1.1.2" title="25.1.1.2"> The </h4><p>An object that implements the <i>Iterator</i> interface must include the property in <a href="#table-53">Table 53</a>.
        Such objects may also implement the properties in <a href="#table-54">Table 54</a>.</p>

        <figure>
          <figcaption><span id="table-53">Table 53</span> &mdash; <i>Iterator</i> Interface Required Properties</figcaption>
          <table class="real-table">
            <tr>
              <th style="background-color: #A6A6A6">Property</th>
              <th style="background-color: #A6A6A6">Value</th>
              <th style="background-color: #A6A6A6">Requirements</th>
            </tr>
            <tr>
              <td><code>next</code></td>
              <td>A function that returns an <i>IteratorResult</i> object.</td>
              <td>The returned object must conform to the <i>IteratorResult</i> interface. If a previous call to the <code>next</code> method of an <i>Iterator</i> has returned an <i>IteratorResult</i> object whose <code>done</code> property is <b>true</b>, then all subsequent calls to the <code>next</code> method of that object should also return an <i>IteratorResult</i> object whose <code>done</code> property is <b>true</b>. However, this requirement is not enforced.</td>
            </tr>
          </table>
        </figure>

        <div class="note">
          <p><span class="nh">NOTE 1</span> Arguments may be passed to the next function but their interpretation and validity is
          dependent upon the target <i>Iterator</i>. The for-of statement and other common users of <i>Iterators</i> do not pass
          any arguments, so <i>Iterator</i> objects that expect to be used in such a manner must be prepared to deal with being
          called with no arguments.</p>
        </div>

        <figure>
          <figcaption><span id="table-54">Table 54</span> &mdash; <i>Iterator</i> Interface Optional Properties</figcaption>
          <table class="real-table">
            <tr>
              <th style="background-color: #A6A6A6">Property</th>
              <th style="background-color: #A6A6A6">Value</th>
              <th style="background-color: #A6A6A6">Requirements</th>
            </tr>
            <tr>
              <td><code>return</code></td>
              <td>A function that returns an <i>IteratorResult</i> object.</td>
              <td>The returned object must conform to the <i>IteratorResult</i> interface. Invoking this method notifies the <i>Iterator</i> object that the caller does not intend to make any more <code>next</code> method calls to the <i>Iterator</i>. The returned <i>IteratorResult</i> object will typically have a <code>done</code> property whose value is <b>true</b>, and a <code>value</code> property with the value passed as the argument of the <code>return</code> method. However, this requirement is not enforced.</td>
            </tr>
            <tr>
              <td><code>throw</code></td>
              <td>A function that returns an <i>IteratorResult</i> object.</td>
              <td>The returned object must conform to the <i>IteratorResult</i> interface. Invoking this method notifies the <i>Iterator</i> object that the caller has detected an error condition. The argument may be used to identify the error condition and typically will be an exception object. A typical response is to <code>throw</code> the value passed as the argument. If the method does not <code>throw</code>, the returned <i>IteratorResult</i> object will typically have a <code>done</code> property whose value is <b>true</b>.</td>
            </tr>
          </table>
        </figure>

        <div class="note">
          <p><span class="nh">NOTE 2</span> Typically callers of these methods should check for their existence before invoking
          them. Certain ECMAScript language features including <code>for</code>-<code>of</code>, <code>yield*</code>, and array
          destructuring call these methods after performing an existence check. Most ECMAScript library functions that accept
          <i>Iterable</i> objects as arguments also conditionally call them.</p>
        </div>
      </section>

      <section id="sec-iteratorresult-interface">
        <h4 id="sec-25.1.1.3" title="25.1.1.3"> The IteratorResult  Interface</h4><p>The <i>IteratorResult</i> interface includes the properties  listed in <a href="#table-55">Table 55</a>:</p>

        <figure>
          <figcaption><span id="table-55">Table 55</span> &mdash; <i>IteratorResult</i> Interface Properties</figcaption>
          <table class="real-table">
            <tr>
              <th style="background-color: #A6A6A6">Property</th>
              <th style="background-color: #A6A6A6">Value</th>
              <th style="background-color: #A6A6A6">Requirements</th>
            </tr>
            <tr>
              <td><code>done</code></td>
              <td>Either <span class="value">true</span> or <span class="value">false</span>.</td>
              <td>This is the result status of an <i>iterator</i> <code>next</code> method call. If the end of the iterator was reached <code>done</code> is <span class="value">true</span>. If the end was not reached <code>done</code> is <span class="value">false</span> and a value is available. If a <code>done</code> property (either own or inherited) does not exist, it is consider to have the value <span class="value">false</span>.</td>
            </tr>
            <tr>
              <td><code>value</code></td>
              <td>Any <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a>.</td>
              <td>If done is <span class="value">false</span>, this is the current iteration element value. If done is <span class="value">true</span>, this is the return value of the iterator, if it supplied one. If the iterator does not have a return value, <code>value</code> is <span class="value">undefined</span>. In that case, the <code>value</code> property may be absent from the conforming object if it does not inherit an explicit <code>value</code> property.</td>
            </tr>
          </table>
        </figure>
      </section>
    </section>

    <section id="sec-%iteratorprototype%-object">
      <div class="front">
        <h3 id="sec-25.1.2" title="25.1.2"> The %IteratorPrototype% Object</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        %IteratorPrototype% object is the intrinsic object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>). The %IteratorPrototype% object is an ordinary object.
        The initial value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        %IteratorPrototype% object is <b>true</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> All objects defined in this specification that implement the Iterator interface also
          inherit from %IteratorPrototype%. ECMAScript code may also define objects that inherit from %IteratorPrototype%.The
          %IteratorPrototype% object provides a place where additional methods that are applicable to all iterator objects may be
          added.</p>

          <p>The following expression is one way that ECMAScript code can access the %IteratorPrototype% object:</p>

          <p><code><a href="sec-fundamental-objects#sec-object.getprototypeof">Object.getPrototypeOf</a>(<a href="sec-fundamental-objects#sec-object.getprototypeof">Object.getPrototypeOf</a>([][Symbol.iterator]()))</code></p>

          <p />
        </div>
      </div>

      <section id="sec-%iteratorprototype%-@@iterator">
        <h4 id="sec-25.1.2.1" title="25.1.2.1"> %IteratorPrototype% [ @@iterator ] (   )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Return the <b>this</b> value.</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"[Symbol.iterator]"</code>.</p>
      </section>
    </section>
  </section>

  <section id="sec-generatorfunction-objects">
    <div class="front">
      <h2 id="sec-25.2" title="25.2">
          GeneratorFunction Objects</h2><p>Generator Function objects are constructor functions that are usually created by evaluating <span class="nt">GeneratorDeclaration</span>, <span class="nt">GeneratorExpression</span>, and <span class="nt">GeneratorMethod</span> syntactic productions. They may also be created by calling the %GeneratorFunction%
      intrinsic.</p>

      <figure>
        <img alt="A staggering variety of boxes and arrows." height="958" src="figure-2.png" width="968" />
        <figcaption>Figure 2 (informative) &mdash; Generator Objects Relationships</figcaption>
      </figure>
    </div>

    <section id="sec-generatorfunction-constructor">
      <div class="front">
        <h3 id="sec-25.2.1" title="25.2.1"> The GeneratorFunction Constructor</h3><p>The <code>GeneratorFunction</code> constructor is the %GeneratorFunction% intrinsic. When
        <code>GeneratorFunction</code> is called as a function rather than as a constructor, it creates and initializes a new
        GeneratorFunction object. Thus the function call <code>GeneratorFunction</code> <code><b>(</b>&hellip;<b>)</b></code> is
        equivalent to the object creation expression <code>new GeneratorFunction</code> <code><b>(</b>&hellip;<b>)</b></code> with
        the same arguments.</p>

        <p><code>GeneratorFunction</code> is designed to be subclassable. It may be used as the value of an <code>extends</code>
        clause of a class definition. Subclass constructors that intend to inherit the specified <code>GeneratorFunction</code>
        behaviour must include a <code>super</code> call to the <code>GeneratorFunction</code> constructor to create and
        initialize subclass instances with the internal slots necessary for built-in GeneratorFunction behaviour. All ECMAScript
        syntactic forms for defining generator function objects create direct instances of <code>GeneratorFunction</code>. There
        is no syntactic means to create instances of <code>GeneratorFunction</code> subclasses.</p>
      </div>

      <section id="sec-generatorfunction">
        <h4 id="sec-25.2.1.1" title="25.2.1.1"> GeneratorFunction (p1, p2, &hellip; , pn, body)</h4><p>The last argument specifies the body (executable code) of a generator function; any preceding arguments specify formal
        parameters.</p>

        <p class="normalbefore">When the <code>GeneratorFunction</code> function is called with some arguments <var>p1</var>,
        <var>p2</var>, &hellip; , <var>pn</var>, <var>body</var> (where <var>n</var> might be <span style="font-family: Times New         Roman">0</span>, that is, there are no &ldquo;<var>p</var>&rdquo; arguments, and where <var>body</var> might also not be
        provided), the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>C</i> be the active function object.</li>
          <li>Let <i>args</i> be the <i>argumentsList</i> that was passed to this function by [[Call]] or [[Construct]].</li>
          <li>Return <a href="sec-fundamental-objects#sec-createdynamicfunction">CreateDynamicFunction</a>(<i>C</i>, NewTarget, <code>"generator"</code>,
              <i>args</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> See NOTE for <a href="sec-fundamental-objects#sec-function-p1-p2-pn-body">19.2.1.1</a>.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-generatorfunction-constructor">
      <div class="front">
        <h3 id="sec-25.2.2" title="25.2.2"> Properties of the GeneratorFunction Constructor</h3><p>The <code>GeneratorFunction</code> constructor is a standard built-in function object that inherits from the
        <code>Function</code> constructor. The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the <code>GeneratorFunction</code> constructor
        is the intrinsic object %Function%.</p>

        <p>The value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        GeneratorFunction constructor is <b>true</b>.</p>

        <p>The value of the <code>name</code> property of the GeneratorFunction is <code>"<b>GeneratorFunction</b>"</code>.</p>

        <p>The <code>GeneratorFunction</code> constructor has the following properties:</p>
      </div>

      <section id="sec-generatorfunction.length">
        <h4 id="sec-25.2.2.1" title="25.2.2.1"> GeneratorFunction.length</h4><p>This is a data property with a value of 1. This property has the attributes { [[Writable]]: <b>false</b>,
        [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>true</b> }.</p>
      </section>

      <section id="sec-generatorfunction.prototype">
        <h4 id="sec-25.2.2.2" title="25.2.2.2"> GeneratorFunction.prototype</h4><p>The initial value of <code>GeneratorFunction.prototype</code> is the intrinsic object %Generator%.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-generatorfunction-prototype-object">
      <div class="front">
        <h3 id="sec-25.2.3" title="25.2.3"> Properties of the GeneratorFunction Prototype Object</h3><p>The GeneratorFunction prototype object is an ordinary object. It is not a function object and does not have an
        [[ECMAScriptCode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> or any other of the
        internal slots listed in <a href="sec-ordinary-and-exotic-objects-behaviours#table-27">Table 27</a> or <a href="#table-56">Table 56</a>. In addition to being the
        value of the prototype property of the %GeneratorFunction% intrinsic, it is the %Generator% intrinsic (see Figure 2).</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        GeneratorFunction prototype object is the %FunctionPrototype% intrinsic object. The initial value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the GeneratorFunction prototype object is
        <b>true</b>.</p>
      </div>

      <section id="sec-generatorfunction.prototype.constructor">
        <h4 id="sec-25.2.3.1" title="25.2.3.1"> GeneratorFunction.prototype.constructor</h4><p>The initial value of <code>GeneratorFunction.prototype.constructor</code> is the intrinsic object
        %GeneratorFunction%.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>

      <section id="sec-generatorfunction.prototype.prototype">
        <h4 id="sec-25.2.3.2" title="25.2.3.2"> GeneratorFunction.prototype.prototype</h4><p>The value of <code>GeneratorFunction.prototype.prototype</code> is the %GeneratorPrototype% intrinsic object.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>

      <section id="sec-generatorfunction.prototype-@@tostringtag">
        <h4 id="sec-25.2.3.3" title="25.2.3.3"> GeneratorFunction.prototype [ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"GeneratorFunction"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-generatorfunction-instances">
      <div class="front">
        <h3 id="sec-25.2.4" title="25.2.4"> GeneratorFunction Instances</h3><p>Every GeneratorFunction instance is an <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ecmascript-function-objects">ECMAScript function object</a> and
        has the internal slots listed in <a href="sec-ordinary-and-exotic-objects-behaviours#table-27">Table 27</a>. The value of the [[FunctionKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> for all such instances is
        <code>"generator"</code>.</p>

        <p>Each GeneratorFunction instance has the following own properties:</p>
      </div>

      <section id="sec-generatorfunction-instances-length">
        <h4 id="sec-25.2.4.1" title="25.2.4.1"> length</h4><p>The value of the <code>length</code> property is an integer that indicates the typical number of arguments expected by
        the GeneratorFunction. However, the language permits the function to be invoked with some other number of arguments. The
        behaviour of a GeneratorFunction when invoked on a number of arguments other than the number specified by its
        <code>length</code> property depends on the function.</p>

        <p>This property has the attributes {&nbsp;[[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>true</b>&nbsp;}.</p>
      </section>

      <section id="sec-generatorfunction-instances-name">
        <h4 id="sec-25.2.4.2" title="25.2.4.2"> name</h4><p>The specification for the <code>name</code> property of Function instances given in <a href="sec-fundamental-objects#sec-function-instances-name">19.2.4.2</a> also applies to GeneratorFunction instances.</p>
      </section>

      <section id="sec-generatorfunction-instances-prototype">
        <h4 id="sec-25.2.4.3" title="25.2.4.3"> prototype</h4><p>Whenever a GeneratorFunction instance is created another ordinary object is also created and is the initial value of
        the generator function&rsquo;s <code>prototype</code> property. The value of the prototype property is used to initialize
        the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of a newly created Generator
        object when the generator function object is invoked using either [[Call]] or [[Construct]].</p>

        <p>This property has the attributes {&nbsp;[[Writable]]: <span class="value">true</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">false</span>&nbsp;}.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Unlike function instances, the object that is the value of the a
          GeneratorFunction&rsquo;s <code>prototype</code> property does not have a <code>constructor</code> property whose value
          is the GeneratorFunction instance.</p>
        </div>
      </section>
    </section>
  </section>

  <section id="sec-generator-objects">
    <div class="front">
      <h2 id="sec-25.3" title="25.3">
          Generator Objects</h2><p>A Generator object is an instance of a generator function and conforms to both the <i>Iterator</i> and <i>Iterable</i>
      interfaces.</p>

      <p>Generator instances directly inherit properties from the object that is the value of the <code>prototype</code> property
      of the Generator function that created the instance. Generator instances indirectly inherit properties from the Generator
      Prototype intrinsic, %GeneratorPrototype%.</p>
    </div>

    <section id="sec-properties-of-generator-prototype">
      <div class="front">
        <h3 id="sec-25.3.1" title="25.3.1"> Properties of Generator Prototype</h3><p>The Generator prototype object is the %GeneratorPrototype% intrinsic. It is also the initial value of the
        <code>prototype</code> property of the %Generator% intrinsic (the <a href="#sec-generatorfunction.prototype">GeneratorFunction.prototype</a>).</p>

        <p>The Generator prototype is an ordinary object. It is not a Generator instance and does not have a [[GeneratorState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Generator prototype object is the intrinsic object %IteratorPrototype% (<a href="#sec-%iteratorprototype%-object">25.1.2</a>). The initial value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Generator prototype object is
        <b>true</b>.</p>

        <p>All Generator instances indirectly inherit properties of the Generator prototype object.</p>
      </div>

      <section id="sec-generator.prototype.constructor">
        <h4 id="sec-25.3.1.1" title="25.3.1.1"> Generator.prototype.constructor</h4><p>The initial value of <code>Generator.prototype.constructor</code> is the intrinsic object %Generator%.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>

      <section id="sec-generator.prototype.next">
        <h4 id="sec-25.3.1.2" title="25.3.1.2"> Generator.prototype.next ( value )</h4><p class="normalbefore">The <code>next</code> method performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>g</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-generatorresume">GeneratorResume</a>(<i>g</i>, <i>value</i>).</li>
        </ol>
      </section>

      <section id="sec-generator.prototype.return">
        <h4 id="sec-25.3.1.3" title="25.3.1.3"> Generator.prototype.return ( value )</h4><p class="normalbefore">The <code>return</code> method performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>g</i> be the <b>this</b> value.</li>
          <li>Let <i>C</i> be <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family: sans-serif">return</span>, [[value]]: <i>value</i>, [[target]]: <span style="font-family:               sans-serif">empty</span>}.</li>
          <li>Return <a href="#sec-generatorresumeabrupt">GeneratorResumeAbrupt</a>(<i>g</i>, <i>C</i>).</li>
        </ol>
      </section>

      <section id="sec-generator.prototype.throw">
        <h4 id="sec-25.3.1.4" title="25.3.1.4"> Generator.prototype.throw ( exception )</h4><p class="normalbefore">The <code>throw</code> method performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>g</i> be the <b>this</b> value.</li>
          <li>Let <i>C</i> be <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family: sans-serif">throw</span>, [[value]]: <i>exception</i>, [[target]]: <span style="font-family:               sans-serif">empty</span>}.</li>
          <li>Return <a href="#sec-generatorresumeabrupt">GeneratorResumeAbrupt</a>(<i>g</i>, <i>C</i>).</li>
        </ol>
      </section>

      <section id="sec-generator.prototype-@@tostringtag">
        <h4 id="sec-25.3.1.5" title="25.3.1.5"> Generator.prototype [ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"Generator"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-generator-instances">
      <h3 id="sec-25.3.2" title="25.3.2"> Properties of Generator Instances</h3><p>Generator instances are initially created with the internal slots described in <a href="#table-56">Table 56</a>.</p>

      <figure>
        <figcaption><span id="table-56">Table 56</span> &mdash; Internal Slots of Generator Instances</figcaption>
        <table class="real-table">
          <tr>
            <th>Internal Slot</th>
            <th>Description</th>
          </tr>
          <tr>
            <td>[[GeneratorState]]</td>
            <td>The current execution state of the generator. The possible values are: <b>undefined</b>, <code>"suspendedStart"</code><span style="font-family: Times New Roman">,</span> <code>"suspendedYield"</code><span style="font-family: Times New Roman">,</span> <code>"executing"</code>, and <code>"completed"</code><span style="font-family: Times New Roman">.</span></td>
          </tr>
          <tr>
            <td>[[GeneratorContext]]</td>
            <td>The <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> that is used when executing the code of this generator.</td>
          </tr>
        </table>
      </figure>
    </section>

    <section id="sec-generator-abstract-operations">
      <div class="front">
        <h3 id="sec-25.3.3" title="25.3.3"> Generator Abstract Operations</h3></div>

      <section id="sec-generatorstart">
        <h4 id="sec-25.3.3.1" title="25.3.3.1">
            GeneratorStart (generator, generatorBody)</h4><p class="normalbefore">The abstract operation GeneratorStart with arguments <span style="font-family: Times New         Roman"><i>generator</i> and <i>generatorBody</i></span> performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The value of <i>generator&rsquo;s</i> [[GeneratorState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is <b>undefined</b>.</li>
          <li>Let <i>genContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li>Set the Generator component of <i>genContext</i> to <i>generator.</i></li>
          <li>Set the code evaluation state of <i>genContext</i> such that when evaluation is resumed for that <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> the following steps will be performed:
            <ol class="nested proc">
              <li>Let <i>result</i> be the result of evaluating <i>generatorBody</i>.</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: If we return here, the generator either threw an exception or
                  performed either an implicit or explicit return.</li>
              <li>Remove <i>genContext</i> from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> and restore the
                  <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> that is at the top of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> as <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running
                  execution context</a>.</li>
              <li>Set <i>generator&rsquo;s</i> [[GeneratorState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <code>"completed"</code>.</li>
              <li>Once a generator enters the <code>"completed"</code> state it never leaves it and its associated <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> is never resumed. Any execution state associated with
                  <i>generator</i> can be discarded at this point.</li>
              <li>If <i>result</i> is a normal completion, let <i>resultValue</i> be <b>undefined</b>.</li>
              <li>Else,
                <ol class="block">
                  <li>If <i>result</i>.[[type]] is <span style="font-family: sans-serif">return</span>, let <i>resultValue</i> be
                      <i>result</i>.[[value]].</li>
                  <li>Else, return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>result</i>).</li>
                </ol>
              </li>
              <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<i>resultValue</i>, <b>true</b>).</li>
            </ol>
          </li>
          <li>Set <i>generator&rsquo;s</i> [[GeneratorContext]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>genContext</i>.</li>
          <li>Set <i>generator&rsquo;s</i> [[GeneratorState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <code>"suspendedStart"</code>.</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
        </ol>
      </section>

      <section id="sec-generatorvalidate">
        <h4 id="sec-25.3.3.2" title="25.3.3.2"> GeneratorValidate ( generator )</h4><p class="normalbefore">The abstract operation GeneratorValidate with argument <var>generator</var> performs the following
        steps:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>generator</i>) is not Object, throw a
              <b>TypeError</b> exception.</li>
          <li>If <i>generator</i> does not have a [[GeneratorState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, throw a <b>TypeError</b> exception.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>generator</i> also has a [[GeneratorContext]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>state</i> be the value of <i>generator&rsquo;s</i> [[GeneratorState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>state</i> is <code>"executing"</code>, throw a <b>TypeError</b> exception.</li>
          <li>Return <i>state</i>.</li>
        </ol>
      </section>

      <section id="sec-generatorresume">
        <h4 id="sec-25.3.3.3" title="25.3.3.3">
            GeneratorResume ( generator, value )</h4><p class="normalbefore">The abstract operation GeneratorResume with arguments <span style="font-family: Times New         Roman"><i>generator</i> and <i>value</i></span> performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>state</i> be <a href="#sec-generatorvalidate">GeneratorValidate</a>(<i>generator</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>state</i>).</li>
          <li>If <i>state</i> is <code>"completed"</code>, return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>true</b>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>state</i> is either <code>"suspendedStart"</code> or
              <code>"suspendedYield"</code>.</li>
          <li>Let <i>genContext</i> be the value of <i>generator&rsquo;s</i> [[GeneratorContext]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>methodContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li><a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <i>methodContext</i>.</li>
          <li>Set <i>generator&rsquo;s</i> [[GeneratorState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <code>"executing"</code>.</li>
          <li>Push <i>genContext</i> onto <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>; <i>genContext</i> is
              now <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li>Resume the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">suspended</a> evaluation of <i>genContext</i> using <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>value</i>) as the result of the operation that <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">suspended</a> it. Let <i>result</i> be the value returned by the resumed
              computation.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: When we return here, <i>genContext</i> has already been removed
              from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> and <i>methodContext</i> is <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the currently running execution context</a>.</li>
          <li>Return <i>result</i>.</li>
        </ol>
      </section>

      <section id="sec-generatorresumeabrupt">
        <h4 id="sec-25.3.3.4" title="25.3.3.4"> GeneratorResumeAbrupt(generator, abruptCompletion)</h4><p class="normalbefore">The abstract operation GeneratorResumeAbrupt with arguments <span style="font-family: Times New         Roman"><i>generator</i> and <i>abruptCompletion</i></span> performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>state</i> be <a href="#sec-generatorvalidate">GeneratorValidate</a>(<i>generator</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>state</i>).</li>
          <li>If <i>state</i> is <code>"suspendedStart"</code>, then
            <ol class="block">
              <li>Set <i>generator&rsquo;s</i> [[GeneratorState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <code>"completed"</code>.</li>
              <li>Once a generator enters the <code>"completed"</code> state it never leaves it and its associated <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> is never resumed. Any execution state associated with
                  <i>generator</i> can be discarded at this point.</li>
              <li>Let <i>state</i> be <code>"completed"</code>.</li>
            </ol>
          </li>
          <li>If <i>state</i> is <code>"completed"</code>, then
            <ol class="block">
              <li>If <i>abruptCompletion</i>.[[type]] is <span style="font-family: sans-serif">return</span>, then
                <ol class="block">
                  <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<i>abruptCompletion</i>.[[value]],
                      <b>true</b>).</li>
                </ol>
              </li>
              <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>abruptCompletion</i>).</li>
            </ol>
          </li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>state</i> is <code>"suspendedYield"</code>.</li>
          <li>Let <i>genContext</i> be the value of <i>generator&rsquo;s</i> [[GeneratorContext]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>methodContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li><a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <i>methodContext</i>.</li>
          <li>Set <i>generator&rsquo;s</i> [[GeneratorState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <code>"executing"</code>.</li>
          <li>Push <i>genContext</i> onto <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>; <i>genContext</i> is
              now <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li>Resume the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">suspended</a> evaluation of <i>genContext</i> using
              <i>abruptCompletion</i> as the result of the operation that <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">suspended</a> it. Let
              <i>result</i> be the completion record returned by the resumed computation.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: When we return here, <i>genContext</i> has already been removed
              from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> and <i>methodContext</i> is <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the currently running execution context</a>.</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>result</i>).</li>
        </ol>
      </section>

      <section id="sec-generatoryield">
        <h4 id="sec-25.3.3.5" title="25.3.3.5">
            GeneratorYield ( iterNextObj )</h4><p class="normalbefore">The abstract operation GeneratorYield with argument <var>iterNextObj</var> performs the following
        steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>iterNextObj</i> is an Object that implements the
              <i>IteratorResult</i> interface.</li>
          <li>Let <i>genContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>genContext</i> is the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> of a generator.</li>
          <li>Let <i>generator</i> be the value of the Generator component of <i>genContext</i>.</li>
          <li>Set the value of <i>generator&rsquo;s</i> [[GeneratorState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <code>"suspendedYield"</code>.</li>
          <li>Remove <i>genContext</i> from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> and restore the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> that is at the top of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the
              execution context stack</a> as <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li>Set the code evaluation state of <i>genContext</i> such that when evaluation is resumed with a <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a> <i>resumptionValue</i> the following steps will be
              performed:
            <ol class="nested proc">
              <li>Return <i>resumptionValue</i>.</li>
              <li>NOTE:  This returns to the evaluation of the <span class="nt">YieldExpression</span> production that originally
                  called this abstract operation.</li>
            </ol>
          </li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>iterNextObj</i>).</li>
          <li><span style="font-family: sans-serif">NOTE:  This returns to the evaluation of the operation that had most
              previously resumed evaluation of</span> <i>genContext</i>.</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-promise-objects">
    <div class="front">
      <h2 id="sec-25.4" title="25.4"> Promise
          Objects</h2><p>A Promise is an object that is used as a placeholder for the eventual results of a deferred (and possibly asynchronous)
      computation.</p>

      <p class="normalbefore">Any Promise object is in one of three mutually exclusive states: <i>fulfilled</i>, <i>rejected</i>,
      and <i>pending</i>:</p>

      <ul>
        <li>
          <p>A promise <code>p</code> is fulfilled if <code>p.then(f, r)</code> will immediately enqueue a Job to call the
          function <code>f</code>.</p>
        </li>

        <li>
          <p>A promise <code>p</code> is rejected if <code>p.then(f, r)</code> will immediately enqueue a Job to call the function
          <code>r</code>.</p>
        </li>

        <li>
          <p>A promise is pending if it is neither fulfilled nor rejected.</p>
        </li>
      </ul>

      <p>A promise is said to be <i>settled</i> if it is not pending, i.e. if it is either fulfilled or rejected.</p>

      <p>A promise is <i>resolved</i> if it is settled or if it has been &ldquo;locked in&rdquo; to match the state of another
      promise. Attempting to resolve or reject a resolved promise has no effect. A promise is <i>unresolved</i> if it is not
      resolved. An unresolved promise is always in the pending state. A resolved promise may be pending, fulfilled or
      rejected.</p>
    </div>

    <section id="sec-promise-abstract-operations">
      <div class="front">
        <h3 id="sec-25.4.1" title="25.4.1"> Promise Abstract Operations</h3></div>

      <section id="sec-promisecapability-records">
        <div class="front">
          <h4 id="sec-25.4.1.1" title="25.4.1.1"> PromiseCapability Records</h4><p>A PromiseCapability is a Record value used to encapsulate a promise object along with the functions that are capable
          of resolving or rejecting that promise object. PromiseCapability records are produced by the <a href="#sec-newpromisecapability">NewPromiseCapability</a> abstract operation.</p>

          <p>PromiseCapability Records have the fields listed in <a href="#table-57">Table 57</a>.</p>

          <figure>
            <figcaption><span id="table-57">Table 57</span> &mdash; PromiseCapability Record Fields</figcaption>
            <table class="real-table">
              <tr>
                <th>Field Name</th>
                <th>Value</th>
                <th>Meaning</th>
              </tr>
              <tr>
                <td>[[Promise]]</td>
                <td>An object</td>
                <td>An object that is usable as a promise.</td>
              </tr>
              <tr>
                <td>[[Resolve]]</td>
                <td>A function object</td>
                <td>The function that is used to resolve the given promise object.</td>
              </tr>
              <tr>
                <td>[[Reject]]</td>
                <td>A function object</td>
                <td>The function that is used to reject the given promise object.</td>
              </tr>
            </table>
          </figure>
        </div>

        <section id="sec-ifabruptrejectpromise">
          <h5 id="sec-25.4.1.1.1" title="25.4.1.1.1"> IfAbruptRejectPromise ( value, capability )</h5><p class="normalbefore">IfAbruptRejectPromise is a short hand for a sequence of algorithm steps that use a
          PromiseCapability record. An algorithm step of the form:</p>

          <ol class="proc">
            <li>IfAbruptRejectPromise(<i>value</i>, <i>capability</i>).</li>
          </ol>

          <p>means the same thing as:</p>

          <ol class="proc">
            <li>If <i>value</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>,
              <ol class="block">
                <li>Let <i>rejectResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>capability</i>.[[Reject]], <b>undefined</b>,
                    &laquo;<i>value</i>.[[value]]&raquo;).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rejectResult</i>).</li>
                <li>Return <i>capability</i>.[[Promise]].</li>
              </ol>
            </li>
            <li>Else if <i>value</i> is a <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a>, let
                <i>value</i> be <i>value</i>.[[value]].</li>
          </ol>
        </section>
      </section>

      <section id="sec-promisereaction-records">
        <h4 id="sec-25.4.1.2" title="25.4.1.2"> PromiseReaction Records</h4><p>The PromiseReaction is a Record value used to store information about how a promise should react when it becomes
        resolved or rejected with a given value. PromiseReaction records are created by the <code>then</code> method of the
        Promise prototype, and are used by a <a href="#sec-promisereactionjob">PromiseReactionJob</a>.</p>

        <p>PromiseReaction records have the fields listed in <a href="#table-58">Table 58</a>.</p>

        <figure>
          <figcaption><span id="table-58">Table 58</span> &mdash; PromiseReaction Record Fields</figcaption>
          <table class="real-table">
            <tr>
              <th>Field Name</th>
              <th>Value</th>
              <th>Meaning</th>
            </tr>
            <tr>
              <td>[[Capabilities]]</td>
              <td>A PromiseCapability record</td>
              <td>The capabilities of the promise for which this record provides a reaction handler.</td>
            </tr>
            <tr>
              <td>[[Handler]]</td>
              <td>A function object or a String</td>
              <td>The function that should be applied to the incoming value, and whose return value will govern what happens to the derived promise. If [[Handler]] is <code>"Identity"</code> it is equivalent to a function that simply returns its first argument. If [[Handler]] is <code>"Thrower"</code> it is equivalent to a function that throws its first argument as an exception.</td>
            </tr>
          </table>
        </figure>
      </section>

      <section id="sec-createresolvingfunctions">
        <div class="front">
          <h4 id="sec-25.4.1.3" title="25.4.1.3"> CreateResolvingFunctions ( promise )</h4><p class="normalbefore">When CreateResolvingFunctions is performed with argument <var>promise</var>, the following steps
          are taken:</p>

          <ol class="proc">
            <li>Let <i>alreadyResolved</i> be a new Record { [[value]]: <b>false</b> }.</li>
            <li>Let <i>resolve</i> be a new built-in function object as defined in Promise Resolve Functions (<a href="#sec-promise-resolve-functions">25.4.1.3.2</a>).</li>
            <li>Set the [[Promise]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>resolve</i>
                to <i>promise</i>.</li>
            <li>Set the [[AlreadyResolved]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                <i>resolve</i> to <i>alreadyResolved</i>.</li>
            <li>Let <i>reject</i> be a new built-in function object as defined in Promise Reject Functions (<a href="#sec-promise-reject-functions">25.4.1.3.1</a>).</li>
            <li>Set the [[Promise]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>reject</i>
                to <i>promise</i>.</li>
            <li>Set the [[AlreadyResolved]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                <i>reject</i> to <i>alreadyResolved</i>.</li>
            <li>Return a new Record { [[Resolve]]: <i>resolve</i>, [[Reject]]: <i>reject</i> }.</li>
          </ol>
        </div>

        <section id="sec-promise-reject-functions">
          <h5 id="sec-25.4.1.3.1" title="25.4.1.3.1"> Promise Reject Functions</h5><p>A promise reject function is an anonymous built-in function that has [[Promise]] and [[AlreadyResolved]] internal
          slots.</p>

          <p class="normalbefore">When a promise reject function <var>F</var> is called with argument <var>reason</var>, the
          following steps are taken:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> has a [[Promise]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> whose value is an Object.</li>
            <li>Let <i>promise</i> be the value of <i>F</i>'s [[Promise]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>alreadyResolved</i> be the value of <i>F</i>'s [[AlreadyResolved]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <i>alreadyResolved</i>.[[value]] is <b>true</b>, return <b>undefined</b>.</li>
            <li>Set <i>alreadyResolved</i>.[[value]] to <b>true</b>.</li>
            <li>Return <a href="#sec-rejectpromise">RejectPromise</a>(<i>promise</i>, <i>reason</i>).</li>
          </ol>

          <p>The <code>length</code> property of a promise reject function is <b>1</b>.</p>
        </section>

        <section id="sec-promise-resolve-functions">
          <h5 id="sec-25.4.1.3.2" title="25.4.1.3.2"> Promise Resolve Functions</h5><p>A promise resolve function is an anonymous built-in function that has [[Promise]] and [[AlreadyResolved]] internal
          slots.</p>

          <p class="normalbefore">When a promise resolve function <var>F</var> is called with argument <var>resolution</var>, the
          following steps are taken:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> has a [[Promise]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> whose value is an Object.</li>
            <li>Let <i>promise</i> be the value of <i>F</i>'s [[Promise]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>alreadyResolved</i> be the value of <i>F</i>'s [[AlreadyResolved]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <i>alreadyResolved</i>.[[value]] is <b>true</b>, return <b>undefined</b>.</li>
            <li>Set <i>alreadyResolved</i>.[[value]] to <b>true</b>.</li>
            <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>resolution</i>, <i>promise</i>) is <b>true</b>, then
              <ol class="block">
                <li>Let <i>selfResolutionError</i> be a newly created <b>TypeError</b> object.</li>
                <li>Return <a href="#sec-rejectpromise">RejectPromise</a>(<i>promise</i>, <i>selfResolutionError</i>).</li>
              </ol>
            </li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>resolution</i>) is not Object, then
              <ol class="block">
                <li>Return <a href="#sec-fulfillpromise">FulfillPromise</a>(<i>promise</i>, <i>resolution</i>).</li>
              </ol>
            </li>
            <li>Let <i>then</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>resolution</i>, <code>"then"</code>).</li>
            <li>If <i>then</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
              <ol class="block">
                <li>Return <a href="#sec-rejectpromise">RejectPromise</a>(<i>promise</i>, <i>then</i>.[[value]]).</li>
              </ol>
            </li>
            <li>Let <i>thenAction</i> be <i>then</i>.[[value]].</li>
            <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>thenAction</i>) is <b>false</b>, then
              <ol class="block">
                <li>Return <a href="#sec-fulfillpromise">FulfillPromise</a>(<i>promise</i>, <i>resolution</i>).</li>
              </ol>
            </li>
            <li>Perform <a href="sec-executable-code-and-execution-contexts#sec-enqueuejob">EnqueueJob</a> (<code>"PromiseJobs"</code>, <a href="#sec-promiseresolvethenablejob">PromiseResolveThenableJob</a>, &laquo;&zwj;<i>promise</i>,
                <i>resolution</i>, <i>thenAction</i>&raquo;)</li>
            <li>Return <b>undefined</b>.</li>
          </ol>

          <p>The <code>length</code> property of a promise resolve function is <b>1</b>.</p>
        </section>
      </section>

      <section id="sec-fulfillpromise">
        <h4 id="sec-25.4.1.4" title="25.4.1.4">
            FulfillPromise ( promise, value)</h4><p class="normalbefore">When the FulfillPromise abstract operation is called with arguments <var>promise</var> and
        <var>value</var> the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: the value of <i>promise</i>'s [[PromiseState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is <code>"pending"</code>.</li>
          <li>Let <i>reactions</i> be the value of <i>promise</i>'s [[PromiseFulfillReactions]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Set the value of <i>promise</i>'s [[PromiseResult]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <i>value</i>.</li>
          <li>Set the value of <i>promise</i>'s [[PromiseFulfillReactions]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <b>undefined</b>.</li>
          <li>Set the value of <i>promise</i>'s [[PromiseRejectReactions]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <b>undefined</b>.</li>
          <li>Set the value of <i>promise</i>'s [[PromiseState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <code>"fulfilled"</code>.</li>
          <li>Return <a href="#sec-triggerpromisereactions">TriggerPromiseReactions</a>(<i>reactions</i>, <i>value</i>).</li>
        </ol>
      </section>

      <section id="sec-newpromisecapability">
        <div class="front">
          <h4 id="sec-25.4.1.5" title="25.4.1.5"> NewPromiseCapability ( C )</h4><p class="normalbefore">The abstract operation NewPromiseCapability takes a constructor function, and attempts to use
          that constructor function in the fashion of the built-in <code>Promise</code> constructor to create a Promise object and
          extract its resolve and reject functions. The promise plus the resolve and reject functions are used to initialize a new
          PromiseCapability record which is returned as the value of this abstract operation.</p>

          <ol class="proc">
            <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>C</i>) is <b>false</b>, throw a <b>TypeError</b>
                exception.</li>
            <li>NOTE <span style="font-family: Times New Roman"><i>C</i></span> is assumed to be a constructor function that
                supports the parameter conventions of the <code>Promise</code> constructor (<a href="#sec-promise-executor">see
                25.4.3.1</a>).</li>
            <li>Let <i>promiseCapability</i> be a new PromiseCapability { [[Promise]]: <b>undefined</b>, [[Resolve]]:
                <b>undefined</b>, [[Reject]]: <b>undefined</b> }.</li>
            <li>Let <i>executor</i> be a new built-in function object as defined in <a href="#sec-getcapabilitiesexecutor-functions">GetCapabilitiesExecutor Functions</a> (<a href="#sec-getcapabilitiesexecutor-functions">25.4.1.5.1</a>).</li>
            <li>Set the [[Capability]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                <i>executor</i> to <i>promiseCapability</i>.</li>
            <li>Let <i>promise</i> be <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>C</i>, &laquo;<i>executor</i>&raquo;).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>promise</i>).</li>
            <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>promiseCapability</i>.[[Resolve]]) is <b>false</b>, throw a
                <b>TypeError</b> exception.</li>
            <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>promiseCapability</i>.[[Reject]]) is <b>false</b>, throw a
                <b>TypeError</b> exception.</li>
            <li>Set <i>promiseCapability</i>.[[Promise]] to <i>promise</i>.</li>
            <li>Return <i>promiseCapability</i>.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> This abstract operation supports Promise subclassing, as it is generic on any
            constructor that calls a passed executor function argument in the same way as the Promise constructor. It is used to
            generalize static methods of the Promise constructor to any subclass.</p>
          </div>
        </div>

        <section id="sec-getcapabilitiesexecutor-functions">
          <h5 id="sec-25.4.1.5.1" title="25.4.1.5.1"> GetCapabilitiesExecutor Functions</h5><p>A GetCapabilitiesExecutor function is an anonymous built-in function that has a [[Capability]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

          <p class="normalbefore">When a GetCapabilitiesExecutor function <var>F</var> is called with arguments <var>resolve</var>
          and <var>reject</var> the following steps are taken:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> has a [[Capability]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> whose value is a PromiseCapability
                Record.</li>
            <li>Let <i>promiseCapability</i> be the value of <i>F</i>'s [[Capability]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <i>promiseCapability</i>.[[Resolve]] is not <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
            <li>If <i>promiseCapability</i>.[[Reject]] is not <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
            <li>Set <i>promiseCapability</i>.[[Resolve]] to <i>resolve</i>.</li>
            <li>Set <i>promiseCapability</i>.[[Reject]] to <i>reject</i>.</li>
            <li>Return <b>undefined</b>.</li>
          </ol>

          <p>The <code>length</code> property of a GetCapabilitiesExecutor function is <b>2</b>.</p>
        </section>
      </section>

      <section id="sec-ispromise">
        <h4 id="sec-25.4.1.6" title="25.4.1.6">
            IsPromise ( x )</h4><p class="normalbefore">The abstract operation IsPromise checks for the promise brand on an object.</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) is not Object, return <b>false</b>.</li>
          <li>If <i>x</i> does not have a [[PromiseState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, return <b>false</b>.</li>
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-rejectpromise">
        <h4 id="sec-25.4.1.7" title="25.4.1.7">
            RejectPromise ( promise, reason)</h4><p class="normalbefore">When the RejectPromise abstract operation is called with arguments <var>promise</var> and
        <var>reason</var> the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: the value of <i>promise</i>'s [[PromiseState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is <code>"pending"</code>.</li>
          <li>Let <i>reactions</i> be the value of <i>promise</i>'s [[PromiseRejectReactions]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Set the value of <i>promise</i>'s [[PromiseResult]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <i>reason</i>.</li>
          <li>Set the value of <i>promise</i>'s [[PromiseFulfillReactions]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <b>undefined</b>.</li>
          <li>Set the value of <i>promise</i>'s [[PromiseRejectReactions]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <b>undefined</b>.</li>
          <li>Set the value of <i>promise</i>'s [[PromiseState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <code>"rejected"</code>.</li>
          <li>Return <a href="#sec-triggerpromisereactions">TriggerPromiseReactions</a>(<i>reactions</i>, <i>reason</i>).</li>
        </ol>
      </section>

      <section id="sec-triggerpromisereactions">
        <h4 id="sec-25.4.1.8" title="25.4.1.8"> TriggerPromiseReactions ( reactions, argument )</h4><p>The abstract operation TriggerPromiseReactions takes a collection of PromiseReactionRecords and enqueues a new Job for
        each record. Each such Job processes the [[Handler]] of the PromiseReactionRecord, and if the [[Handler]] is a function
        calls it passing the given argument.</p>

        <ol class="proc">
          <li>Repeat for each <i>reaction</i> in <i>reactions</i>, in original insertion order
            <ol class="block">
              <li>Perform <a href="sec-executable-code-and-execution-contexts#sec-enqueuejob">EnqueueJob</a>(<code>"<b>PromiseJobs</b>"</code><span style="font-family:                   sans-serif">,</span> <a href="#sec-promisereactionjob">PromiseReactionJob</a>, &laquo;&zwj;<i>reaction</i>,
                  <i>argument</i>&raquo;).</li>
            </ol>
          </li>
          <li>Return <b>undefined</b>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-promise-jobs">
      <div class="front">
        <h3 id="sec-25.4.2" title="25.4.2">
            Promise Jobs</h3></div>

      <section id="sec-promisereactionjob">
        <h4 id="sec-25.4.2.1" title="25.4.2.1"> PromiseReactionJob ( reaction, argument )</h4><p class="normalbefore">The job PromiseReactionJob with parameters <var>reaction</var> and <var>argument</var> applies the
        appropriate handler to the incoming value, and uses the handler's return value to resolve or reject the derived promise
        associated with that handler.</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>reaction</i> is a PromiseReaction Record.</li>
          <li>Let <i>promiseCapability</i> be <i>reaction</i>.[[Capabilities]].</li>
          <li>Let <i>handler</i> be <i>reaction</i>.[[Handler]].</li>
          <li>If <i>handler</i> is <code>"Identity"</code>, let <i>handlerResult</i> be <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>argument</i>).</li>
          <li>Else if <i>handler</i> is <code>"Thrower"</code>, let <i>handlerResult</i> be <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family:               sans-serif">throw</span>, [[value]]: <i>argument</i>, [[target]]: <span style="font-family:               sans-serif">empty</span>}.</li>
          <li>Else, let <i>handlerResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>handler</i>, <b>undefined</b>,
              &laquo;<i>argument</i>&raquo;).</li>
          <li>If <i>handlerResult</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
            <ol class="block">
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>promiseCapability</i>.[[Reject]], <b>undefined</b>,
                  &laquo;<i>handlerResult</i>.[[value]]&raquo;).</li>
              <li>NextJob <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>).</li>
            </ol>
          </li>
          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>promiseCapability</i>.[[Resolve]], <b>undefined</b>,
              &laquo;<i>handlerResult</i>.[[value]]&raquo;)<i>.</i></li>
          <li>NextJob <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>).</li>
        </ol>
      </section>

      <section id="sec-promiseresolvethenablejob">
        <h4 id="sec-25.4.2.2" title="25.4.2.2"> PromiseResolveThenableJob ( promiseToResolve, thenable, then)</h4><p class="normalbefore">The job PromiseResolveThenableJob with parameters <var>promiseToResolve</var>,
        <var>thenable</var>, and <var>then</var> performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>resolvingFunctions</i> be <a href="#sec-createresolvingfunctions">CreateResolvingFunctions</a>(<i>promiseToResolve</i>).</li>
          <li>Let <i>thenCallResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>then</i>, <i>thenable</i>,
              &laquo;<i>resolvingFunctions</i>.[[Resolve]], <i>resolvingFunctions</i>.[[Reject]]&raquo;).</li>
          <li>If <i>thenCallResult</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>,
            <ol class="block">
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>resolvingFunctions</i>.[[Reject]], <b>undefined</b>,
                  &laquo;<i>thenCallResult</i>.[[value]]&raquo;)<i>.</i></li>
              <li>NextJob <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>status</i>)<i>.</i></li>
            </ol>
          </li>
          <li>NextJob <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>thenCallResult</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> This Job uses the supplied thenable and its <code>then</code> method to resolve the
          given promise. This process must take place as a Job to ensure that the evaluation of the <code>then</code> method
          occurs after evaluation of any surrounding code has completed.</p>
        </div>
      </section>
    </section>

    <section id="sec-promise-constructor">
      <div class="front">
        <h3 id="sec-25.4.3" title="25.4.3">
            The Promise Constructor</h3><p>The Promise constructor is the %Promise% intrinsic object and the initial value of the <code>Promise</code> property of
        the global object. When called as a constructor it creates and initializes a new Promise object. <code>Promise</code> is
        not intended to be called as a function and will throw an exception when called in that manner.</p>

        <p>The <code>Promise</code> constructor is designed to be subclassable. It may be used as the value in an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>Promise</code> behaviour must include a <code>super</code> call to the <code>Promise</code> constructor to create
        and initialize the subclass instance with the internal state necessary to support the <code>Promise</code> and
        <code>Promise.prototype</code> built-in methods.</p>
      </div>

      <section id="sec-promise-executor">
        <h4 id="sec-25.4.3.1" title="25.4.3.1"> Promise ( executor )</h4><p class="normalbefore">When the <code>Promise</code> function is called with argument <var>executor</var> the following
        steps are taken:</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>executor</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>promise</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
              <code>"%PromisePrototype%"</code>, &laquo;&zwj;[[PromiseState]], [[PromiseResult]], [[PromiseFulfillReactions]],
              [[PromiseRejectReactions]]&raquo; ).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>promise</i>).</li>
          <li>Set <i>promise</i>'s [[PromiseState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <code>"pending"</code>.</li>
          <li>Set <i>promise</i>'s [[PromiseFulfillReactions]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Set <i>promise</i>'s [[PromiseRejectReactions]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>resolvingFunctions</i> be <a href="#sec-createresolvingfunctions">CreateResolvingFunctions</a>(<i>promise</i>).</li>
          <li>Let <i>completion</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>executor</i>, <b>undefined</b>,
              &laquo;<i>resolvingFunctions</i>.[[Resolve]], <i>resolvingFunctions</i>.[[Reject]]&raquo;).</li>
          <li>If <i>completion</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
            <ol class="block">
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>resolvingFunctions</i>.[[Reject]], <b>undefined</b>,
                  &laquo;<i>completion</i>.[[value]]&raquo;).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
            </ol>
          </li>
          <li>Return <i>promise</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The <var>executor</var> argument must be a function object. It is called for initiating
          and reporting completion of the possibly deferred action represented by this Promise object. The executor is called with
          two arguments: <var>resolve</var> and <var>reject</var>. These are functions that may be used by the <var>executor</var>
          function to report eventual completion or failure of the deferred computation. Returning from the executor function does
          not mean that the deferred action has been completed but only that the request to eventually perform the deferred action
          has been accepted.</p>

          <p>The <var>resolve</var> function that is passed to an <var>executor</var> function accepts a single argument. The
          <var>executor</var> code may eventually call the <var>resolve</var> function to indicate that it wishes to resolve the
          associated Promise object. The argument passed to the <var>resolve</var> function represents the eventual value of the
          deferred action and can be either the actual fulfillment value or another Promise object which will provide the value if
          it is fulfilled.</p>

          <p>The <var>reject</var> function that is passed to an <var>executor</var> function accepts a single argument. The
          <var>executor</var> code may eventually call the <var>reject</var> function to indicate that the associated Promise is
          rejected and will never be fulfilled. The argument passed to the <var>reject</var> function is used as the rejection
          value of the promise. Typically it will be an <code>Error</code> object.</p>

          <p>The resolve and reject functions passed to an <var>executor</var> function by the Promise constructor have the
          capability to actually resolve and reject the associated promise. Subclasses may have different constructor behaviour
          that passes in customized values for resolve and reject.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-promise-constructor">
      <div class="front">
        <h3 id="sec-25.4.4" title="25.4.4"> Properties of the Promise Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        <code>Promise</code> constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is 1), the Promise constructor has the following properties:</p>
      </div>

      <section id="sec-promise.all">
        <div class="front">
          <h4 id="sec-25.4.4.1" title="25.4.4.1">
              Promise.all ( iterable )</h4><p class="normalbefore">The <code>all</code> function returns a new promise which is fulfilled with an array of
          fulfillment values for the passed promises, or rejects with the reason of the first passed promise that rejects. It
          resolves all elements of the passed iterable to promises as it runs this algorithm.</p>

          <ol class="proc">
            <li>Let <i>C</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>C</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>C</i>, @@species).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
            <li>If <i>S</i> is neither <b>undefined</b> nor <b>null</b>, let <i>C</i> be <i>S</i>.</li>
            <li>Let <i>promiseCapability</i> be <a href="#sec-newpromisecapability">NewPromiseCapability</a>(<i>C</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>promiseCapability</i>).</li>
            <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>iterable</i>).</li>
            <li><a href="#sec-ifabruptrejectpromise">IfAbruptRejectPromise</a>(<i>iterator</i>, <i>promiseCapability</i>).</li>
            <li>Let <i>iteratorRecord</i> be Record {[[iterator]]: <i>iterator</i>, [[done]]: <b>false</b>}.</li>
            <li>Let <i>result</i> be <a href="#sec-performpromiseall">PerformPromiseAll</a>(<i>iteratorRecord</i>, <i>C</i>,
                <i>promiseCapability</i>).</li>
            <li>If <i>result</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>,
              <ol class="block">
                <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, let <i>result</i> be <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>result</i>).</li>
                <li><a href="#sec-ifabruptrejectpromise">IfAbruptRejectPromise</a>(<i>result</i>, <i>promiseCapability</i>).</li>
              </ol>
            </li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>result</i>).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> The <code>all</code> function requires its <b>this</b> value to be a constructor
            function that supports the parameter conventions of the <code>Promise</code> constructor.</p>
          </div>
        </div>

        <section id="sec-performpromiseall">
          <h5 id="sec-25.4.4.1.1" title="25.4.4.1.1"> Runtime Semantics: PerformPromiseAll( iteratorRecord,
              constructor, resultCapability)</h5><p class="normalbefore">When the PerformPromiseAll abstract operation is called with arguments <var>iteratorRecord,
          constructor,</var> and <var>resultCapability</var> the following steps are taken:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>constructor</i> is a constructor function.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>resultCapability</i> is a PromiseCapability record.</li>
            <li>Let <i>values</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>Let <i>remainingElementsCount</i> be a new Record { [[value]]: 1 }.</li>
            <li>Let <i>index</i> be 0.</li>
            <li>Repeat
              <ol class="block">
                <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iteratorRecord</i>.[[iterator]]).</li>
                <li>If <i>next</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                    <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
                <li>If <i>next</i> is <b>false</b>,
                  <ol class="block">
                    <li>Set <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                    <li>Set <i>remainingElementsCount</i>.[[value]] to <i>remainingElementsCount</i>.[[value]] &minus; 1.</li>
                    <li>If <i>remainingElementsCount</i>.[[value]] is 0,
                      <ol class="block">
                        <li>Let <i>valuesArray</i> be <a href="sec-abstract-operations#sec-createarrayfromlist">CreateArrayFromList</a>(<i>values</i>).</li>
                        <li>Let <i>resolveResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>resultCapability</i>.[[Resolve]],
                            <b>undefined</b>, &laquo;<i>valuesArray</i>&raquo;).</li>
                        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>resolveResult</i>)</li>
                      </ol>
                    </li>
                    <li>Return <i>resultCapability</i>.[[Promise]].</li>
                  </ol>
                </li>
                <li>Let <i>nextValue</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
                <li>If <i>nextValue</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                    <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextValue</i>).</li>
                <li>Append <b>undefined</b> to <i>values</i>.</li>
                <li>Let <i>nextPromise</i> be <a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>constructor</i>, <code>"resolve"</code>,
                    &laquo;&zwj;<i>nextValue</i>&raquo;).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextPromise</i> ).</li>
                <li>Let <i>resolveElement</i> be a new built-in function object as defined in <a href="#sec-promise.all">Promise.all</a> Resolve Element Functions.</li>
                <li>Set the [[AlreadyCalled]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                    <i>resolveElement</i> to a new Record {[[value]]: <b>false</b> }.</li>
                <li>Set the [[Index]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                    <i>resolveElement</i> to <i>index</i>.</li>
                <li>Set the [[Values]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                    <i>resolveElement</i> to <i>values</i>.</li>
                <li>Set the [[Capabilities]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                    <i>resolveElement</i> to <i>resultCapability</i>.</li>
                <li>Set the [[RemainingElements]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                    <i>resolveElement</i> to <i>remainingElementsCount</i>.</li>
                <li>Set <i>remainingElementsCount</i>.[[value]] to <i>remainingElementsCount</i>.[[value]] + 1.</li>
                <li>Let <i>result</i> be <a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>nextPromise</i>, <code>"then"</code>,
                    &laquo;&zwj;<i>resolveElement</i>, <i>resultCapability</i>.[[Reject]]&raquo;).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
                <li>Set <i>index</i> to <i>index</i> + 1.</li>
              </ol>
            </li>
          </ol>
        </section>

        <section id="sec-promise.all-resolve-element-functions">
          <h5 id="sec-25.4.4.1.2" title="25.4.4.1.2"> Promise.all Resolve Element Functions</h5><p>A <a href="#sec-promise.all">Promise.all</a> resolve element function is an anonymous built-in function that is used
          to resolve a specific <a href="#sec-promise.all">Promise.all</a> element. Each <a href="#sec-promise.all">Promise.all</a> resolve element function has [[Index]], [[Values]], [[Capabilities]],
          [[RemainingElements]], and [[AlreadyCalled]] internal slots.</p>

          <p class="normalbefore">When a <a href="#sec-promise.all">Promise.all</a> resolve element function <var>F</var> is
          called with argument <var>x</var>, the following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>alreadyCalled</i> be the value of <i>F</i>'s [[AlreadyCalled]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <i>alreadyCalled</i>.[[value]] is <b>true</b>, return <b>undefined</b>.</li>
            <li>Set <i>alreadyCalled</i>.[[value]] to <b>true</b>.</li>
            <li>Let <i>index</i> be the value of <i>F</i>'s [[Index]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>values</i> be the value of <i>F</i>'s [[Values]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>promiseCapability</i> be the value of <i>F</i>'s [[Capabilities]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>remainingElementsCount</i> be the value of <i>F</i>'s [[RemainingElements]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Set <i>values</i>[<i>index</i>] to <i>x</i>.</li>
            <li>Set <i>remainingElementsCount</i>.[[value]] to <i>remainingElementsCount</i>.[[value]] - 1.</li>
            <li>If <i>remainingElementsCount</i>.[[value]] is 0,
              <ol class="block">
                <li>Let <i>valuesArray</i> be <a href="sec-abstract-operations#sec-createarrayfromlist">CreateArrayFromList</a>(<i>values</i>).</li>
                <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>promiseCapability</i>.[[Resolve]], <b>undefined</b>,
                    &laquo;<i>valuesArray</i>&raquo;).</li>
              </ol>
            </li>
            <li>Return <b>undefined</b>.</li>
          </ol>

          <p>The <code>length</code> property of a <a href="#sec-promise.all">Promise.all</a> resolve element function is
          <b>1</b>.</p>
        </section>
      </section>

      <section id="sec-promise.prototype">
        <h4 id="sec-25.4.4.2" title="25.4.4.2"> Promise.prototype</h4><p>The initial value of <code>Promise.prototype</code> is the intrinsic object %PromisePrototype% (<a href="#sec-properties-of-the-promise-prototype-object">25.4.5</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-promise.race">
        <div class="front">
          <h4 id="sec-25.4.4.3" title="25.4.4.3">
              Promise.race ( iterable )</h4><p class="normalbefore">The <code>race</code> function returns a new promise which is settled in the same way as the
          first passed promise to settle. It resolves all elements of the passed <span style="font-family: Times New           Roman">iterable</span> to promises as it runs this algorithm.</p>

          <ol class="proc">
            <li>Let <i>C</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>C</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>Let <i>S</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>C</i>, @@species).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>S</i>).</li>
            <li>If <i>S</i> is neither <b>undefined</b> nor <b>null</b>, let <i>C</i> be <i>S</i>.</li>
            <li>Let <i>promiseCapability</i> be <a href="#sec-newpromisecapability">NewPromiseCapability</a>(<i>C</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>promiseCapability</i>).</li>
            <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>iterable</i>).</li>
            <li><a href="#sec-ifabruptrejectpromise">IfAbruptRejectPromise</a>(<i>iterator</i>, <i>promiseCapability</i>).</li>
            <li>Let <i>iteratorRecord</i> be Record {[[iterator]]: <i>iterator</i>, [[done]]: <b>false</b>}.</li>
            <li>Let <i>result</i> be <a href="#sec-performpromiserace">PerformPromiseRace</a>(<i>iteratorRecord</i>,
                <i>promiseCapability</i>, <i>C</i>).</li>
            <li>If <i>result</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, then
              <ol class="block">
                <li>If <i>iteratorRecord</i>.[[done]] is <b>false</b>, let <i>result</i> be <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator,result</i>).</li>
                <li><a href="#sec-ifabruptrejectpromise">IfAbruptRejectPromise</a>(<i>result</i>, <i>promiseCapability</i>).</li>
              </ol>
            </li>
            <li>Return <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>(<i>result</i>).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE 1</span> If the <var>iterable</var> argument is empty or if none of the promises in
            <var>iterable</var> ever settle then the pending promise returned by this method will never be settled</p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 2</span> The <code>race</code> function expects its <b>this</b> value to be a constructor
            function that supports the parameter conventions of the <code>Promise</code> constructor. It also expects that its
            <b>this</b> value provides a <code>resolve</code> method.</p>
          </div>
        </div>

        <section id="sec-performpromiserace">
          <h5 id="sec-25.4.4.3.1" title="25.4.4.3.1"> Runtime Semantics:  PerformPromiseRace ( iteratorRecord,
              promiseCapability, C )</h5><p class="normalbefore">When the PerformPromiseRace abstract operation is called with arguments <var>iteratorRecord,
          promiseCapability,</var> and <var>C</var> the following steps are taken:</p>

          <ol class="proc">
            <li>Repeat
              <ol class="block">
                <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iteratorRecord</i>.[[iterator]]).</li>
                <li>If <i>next</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                    <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
                <li>If <i>next</i> is <b>false</b>, then
                  <ol class="block">
                    <li>Set <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                    <li>Return <i>promiseCapability</i>.[[Promise]].</li>
                  </ol>
                </li>
                <li>Let <i>nextValue</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
                <li>If <i>nextValue</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, set
                    <i>iteratorRecord</i>.[[done]] to <b>true</b>.</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextValue</i>).</li>
                <li>Let <i>nextPromise</i> be <a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>C</i>, <code>"resolve"</code>,
                    &laquo;&zwj;<i>nextValue</i>&raquo;).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextPromise</i>).</li>
                <li>Let <i>result</i> be <a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>nextPromise</i>, <code>"then"</code>,
                    &laquo;&zwj;<i>promiseCapability</i>.[[Resolve]], <i>promiseCapability</i>.[[Reject]]&raquo;).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
              </ol>
            </li>
          </ol>
        </section>
      </section>

      <section id="sec-promise.reject">
        <h4 id="sec-25.4.4.4" title="25.4.4.4">
            Promise.reject ( r )</h4><p class="normalbefore">The <code>reject</code> function returns a new promise rejected with the passed argument.</p>

        <ol class="proc">
          <li>Let <i>C</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>C</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>promiseCapability</i> be <a href="#sec-newpromisecapability">NewPromiseCapability</a>(<i>C</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>promiseCapability</i>).</li>
          <li>Let <i>rejectResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>promiseCapability</i>.[[Reject]], <b>undefined</b>,
              &laquo;<i>r</i>&raquo;).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>rejectResult</i>).</li>
          <li>Return <i>promiseCapability</i>.[[Promise]].</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>reject</code> function expects its <b>this</b> value to be a constructor
          function that supports the parameter conventions of the <code>Promise</code> constructor.</p>
        </div>
      </section>

      <section id="sec-promise.resolve">
        <h4 id="sec-25.4.4.5" title="25.4.4.5">
            Promise.resolve ( x )</h4><p class="normalbefore">The <code>resolve</code> function returns either a new promise resolved with the passed argument,
        or the argument itself if the argument is a promise produced by this constructor.</p>

        <ol class="proc">
          <li>Let <i>C</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>C</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <a href="#sec-ispromise">IsPromise</a>(<i>x</i>) is <b>true</b>,
            <ol class="block">
              <li>Let <i>xConstructor</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>x</i>, <code>"constructor"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>xConstructor</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>xConstructor</i>, <i>C</i>) is <b>true</b>, return <i>x</i>.</li>
            </ol>
          </li>
          <li>Let <i>promiseCapability</i> be <a href="#sec-newpromisecapability">NewPromiseCapability</a>(<i>C</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>promiseCapability</i>).</li>
          <li>Let <i>resolveResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>promiseCapability</i>.[[Resolve]], <b>undefined</b>,
              &laquo;<i>x</i>&raquo;).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>resolveResult</i>).</li>
          <li>Return <i>promiseCapability</i>.[[Promise]].</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span>  The <code>resolve</code> function expects its <b>this</b> value to be a constructor
          function that supports the parameter conventions of the <code>Promise</code> constructor.</p>
        </div>
      </section>

      <section id="sec-get-promise-@@species">
        <h4 id="sec-25.4.4.6" title="25.4.4.6"> get Promise [ @@species ]</h4><p class="normalbefore"><code>Promise[@@species]</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Return the <b>this</b> value.</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"get [Symbol.species]"</code>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Promise prototype methods normally use their <code>this</code> object&rsquo;s
          constructor to create a derived object. However, a subclass constructor may over-ride that default behaviour by
          redefining its @@species property.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-promise-prototype-object">
      <div class="front">
        <h3 id="sec-25.4.5" title="25.4.5"> Properties of the Promise Prototype Object</h3><p>The Promise prototype object is the intrinsic object %PromisePrototype%. The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Promise prototype object is the intrinsic
        object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>). The Promise prototype
        object is an ordinary object. It does not have a [[PromiseState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> or any of the other internal slots of Promise
        instances.</p>
      </div>

      <section id="sec-promise.prototype.catch">
        <h4 id="sec-25.4.5.1" title="25.4.5.1"> Promise.prototype.catch ( onRejected )</h4><p class="normalbefore">When the <code>catch</code> method is called with argument <var>onRejected</var> the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>promise</i> be the <b>this</b> value.</li>
          <li>Return <a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>promise</i>, <code>"then"</code>, &laquo;&zwj;<b>undefined</b>,
              <i>onRejected</i>&raquo;).</li>
        </ol>
      </section>

      <section id="sec-promise.prototype.constructor">
        <h4 id="sec-25.4.5.2" title="25.4.5.2"> Promise.prototype.constructor</h4><p>The initial value of <code>Promise.prototype.constructor</code> is the intrinsic object %Promise%.</p>
      </section>

      <section id="sec-promise.prototype.then">
        <div class="front">
          <h4 id="sec-25.4.5.3" title="25.4.5.3"> Promise.prototype.then ( onFulfilled , onRejected )</h4><p class="normalbefore">When the <code>then</code> method is called with arguments <var>onFulfilled</var> and
          <var>onRejected</var> the following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>promise</i> be the <b>this</b> value.</li>
            <li>If <a href="#sec-ispromise">IsPromise</a>(<i>promise</i>) is <b>false</b>, throw a <b>TypeError</b>
                exception.</li>
            <li>Let <i>C</i> be <a href="sec-abstract-operations#sec-speciesconstructor">SpeciesConstructor</a>(<i>promise</i>, %Promise%).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>C</i>).</li>
            <li>Let <i>resultCapability</i> be <a href="#sec-newpromisecapability">NewPromiseCapability</a>(<i>C</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>resultCapability</i>).</li>
            <li>Return <a href="#sec-performpromisethen">PerformPromiseThen</a>(<i>promise</i>, <i>onFulfilled</i>,
                <i>onRejected</i>, <i>resultCapability</i>).</li>
          </ol>
        </div>

        <section id="sec-performpromisethen">
          <h5 id="sec-25.4.5.3.1" title="25.4.5.3.1"> PerformPromiseThen ( promise, onFulfilled, onRejected,
              resultCapability )</h5><p class="normalbefore">The abstract operation PerformPromiseThen performs the &ldquo;then&rdquo; operation on
          <var>promise</var> using <var>onFulfilled</var> and <var>onRejected</var> as its settlement actions. The result is
          <var>resultCapability</var>&rsquo;s promise.</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="#sec-ispromise">IsPromise</a>(<i>promise</i>) is
                <b>true</b>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>resultCapability</i> is a PromiseCapability record.</li>
            <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>onFulfilled</i>) is <b>false</b>, then
              <ol class="block">
                <li>Let <i>onFulfilled</i> be <code>"Identity"</code>.</li>
              </ol>
            </li>
            <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>onRejected</i>) is <b>false</b>, then
              <ol class="block">
                <li>Let <i>onRejected</i> be <code>"Thrower"</code>.</li>
              </ol>
            </li>
            <li>Let <i>fulfillReaction</i> be the PromiseReaction { [[Capabilities]]: <i>resultCapability</i>, [[Handler]]:
                <i>onFulfilled</i> }.</li>
            <li>Let <i>rejectReaction</i> be the PromiseReaction { [[Capabilities]]: <i>resultCapability</i>, [[Handler]]:
                <i>onRejected</i>}.</li>
            <li>If the value of <i>promise</i>'s [[PromiseState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is <code>"pending"</code>,
              <ol class="block">
                <li>Append <i>fulfillReaction</i> as the last element of the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of <i>promise</i>'s
                    [[PromiseFulfillReactions]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
                <li>Append <i>rejectReaction</i> as the last element of the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of <i>promise</i>'s
                    [[PromiseRejectReactions]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
              </ol>
            </li>
            <li>Else if the value of <i>promise</i>'s [[PromiseState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is <code>"fulfilled"</code>,
              <ol class="block">
                <li>Let <i>value</i> be the value of <i>promise</i>'s [[PromiseResult]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
                <li>Perform <a href="sec-executable-code-and-execution-contexts#sec-enqueuejob">EnqueueJob</a>(<code>"PromiseJobs"</code>, <a href="#sec-promisereactionjob">PromiseReactionJob</a>, &laquo;&zwj;<i>fulfillReaction</i>,
                    <i>value</i>&raquo;).</li>
              </ol>
            </li>
            <li>Else if the value of <i>promise</i>'s [[PromiseState]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is <code>"rejected"</code>,
              <ol class="block">
                <li>Let <i>reason</i> be the value of <i>promise</i>'s [[PromiseResult]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
                <li>Perform <a href="sec-executable-code-and-execution-contexts#sec-enqueuejob">EnqueueJob</a>(<code>"PromiseJobs"</code>, <a href="#sec-promisereactionjob">PromiseReactionJob</a>, &laquo;&zwj;<i>rejectReaction</i>,
                    <i>reason</i>&raquo;).</li>
              </ol>
            </li>
            <li>Return <i>resultCapability</i>.[[Promise]].</li>
          </ol>
        </section>
      </section>

      <section id="sec-promise.prototype-@@tostringtag">
        <h4 id="sec-25.4.5.4" title="25.4.5.4"> Promise.prototype [ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"Promise"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-promise-instances">
      <h3 id="sec-25.4.6" title="25.4.6"> Properties of Promise Instances</h3><p>Promise instances are ordinary objects that inherit properties from the Promise prototype object (the intrinsic,
      %PromisePrototype%). Promise instances are initially created with the internal slots described in <a href="#table-59">Table
      59</a>.</p>

      <figure>
        <figcaption><span id="table-59">Table 59</span> &mdash; Internal Slots of Promise Instances</figcaption>
        <table class="real-table">
          <tr>
            <th>Internal Slot</th>
            <th>Description</th>
          </tr>
          <tr>
            <td>[[PromiseState]]</td>
            <td>A String value that governs how a promise will react to incoming calls to its <code>then</code> method. The possible values are: <code>"pending"</code><span style="font-family: Times New Roman">,</span> <code>"fulfilled"</code>, and <code>"rejected"</code><span style="font-family: Times New Roman">.</span></td>
          </tr>
          <tr>
            <td>[[PromiseResult]]</td>
            <td>The value with which the promise has been fulfilled or rejected, if any. Only meaningful if <span style="font-family: Times New Roman">[[PromiseState]]</span> is not <code>"pending"</code>.</td>
          </tr>
          <tr>
            <td>[[PromiseFulfillReactions]]</td>
            <td>A <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of PromiseReaction records to be processed when/if the promise transitions from the <code>"pending"</code> state to the <code>"fulfilled"</code> state.</td>
          </tr>
          <tr>
            <td>[[PromiseRejectReactions]]</td>
            <td>A <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of PromiseReaction records to be processed when/if the promise transitions from the <code>"pending"</code> state to the <code>"rejected"</code> state.</td>
          </tr>
        </table>
      </figure>
    </section>
  </section>
</section>

