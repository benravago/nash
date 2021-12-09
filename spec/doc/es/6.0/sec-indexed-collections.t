<section id="sec-indexed-collections">
  <div class="front">
    <h1 id="sec-22" title="22"> Indexed
        Collections</h1></div>

  <section id="sec-array-objects">
    <div class="front">
      <h2 id="sec-22.1" title="22.1"> Array
          Objects</h2><p>Array objects are exotic objects that give special treatment to a certain class of property names. See <a href="sec-ordinary-and-exotic-objects-behaviours#sec-array-exotic-objects">9.4.2</a> for a definition of this special treatment.</p>
    </div>

    <section id="sec-array-constructor">
      <div class="front">
        <h3 id="sec-22.1.1" title="22.1.1">
            The Array Constructor</h3><p>The Array constructor is the %Array% intrinsic object and the initial value of the <code>Array</code> property of the
        global object. When called as a constructor it creates and initializes a new exotic Array object. When <code>Array</code>
        is called as a function rather than as a constructor, it also creates and initializes a new Array object. Thus the
        function call <code><b>Array(</b>&hellip;<b>)</b></code> is equivalent to the object creation expression
        <code><b>new&nbsp;Array(</b>&hellip;<b>)</b></code> with the same arguments.</p>

        <p>The <code>Array</code> constructor is a single function whose behaviour is overloaded based upon the number and types
        of its arguments.</p>

        <p>The <code>Array</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the exotic
        <code>Array</code> behaviour must include a <code>super</code> call to the <code>Array</code> constructor to initialize
        subclass instances that are exotic Array objects. However, most of the <code>Array.prototype</code> methods are generic
        methods that are not dependent upon their <code>this</code> value being an exotic Array object.</p>

        <p>The <code>length</code> property of the <code>Array</code> constructor function is <b>1</b>.</p>
      </div>

      <section id="sec-array-constructor-array">
        <h4 id="sec-22.1.1.1" title="22.1.1.1"> Array ( )</h4><p class="normalbefore">This description applies if and only if the Array constructor is called with no arguments.</p>

        <ol class="proc">
          <li>Let <i>numberOfArgs</i> be the number of arguments passed to this function call.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numberOfArgs</i> = 0.</li>
          <li>If NewTarget is <b>undefined</b><i>,</i> let <i>newTarget</i> be the active function object, else let
              <i>newTarget</i> be NewTarget.</li>
          <li>Let <i>proto</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-getprototypefromconstructor">GetPrototypeFromConstructor</a>(<i>newTarget</i>,
              <code>"%ArrayPrototype%"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>proto</i>).</li>
          <li>Return <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0, <i>proto</i>).</li>
        </ol>
      </section>

      <section id="sec-array-len">
        <h4 id="sec-22.1.1.2" title="22.1.1.2"> Array
            (len)</h4><p class="normalbefore">This description applies if and only if the Array constructor is called with exactly one
        argument.</p>

        <ol class="proc">
          <li>Let <i>numberOfArgs</i> be the number of arguments passed to this function call.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numberOfArgs</i> = 1.</li>
          <li>If NewTarget is <b>undefined</b><i>,</i> let <i>newTarget</i> be the active function object, else let
              <i>newTarget</i> be NewTarget.</li>
          <li>Let <i>proto</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-getprototypefromconstructor">GetPrototypeFromConstructor</a>(<i>newTarget</i>,
              <code>"%ArrayPrototype%"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>proto</i>).</li>
          <li>Let <i>array</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0, <i>proto</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>len</i>) is not Number, then
            <ol class="block">
              <li>Let <i>defineStatus</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>array</i>,
                  <code>"<b>0</b>"</code>, <i>len</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>defineStatus</i> is <b>true</b>.</li>
              <li>Let <i>intLen</i> be 1.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>intLen</i> be <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>len</i>).</li>
              <li>If <i>intLen</i> &ne; <i>len</i>, throw a <b>RangeError</b> exception.</li>
            </ol>
          </li>
          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>array</i>, <code>"length"</code>, <i>intLen</i>,
              <b>true</b>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>setStatus</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>Return <i>array</i>.</li>
        </ol>
      </section>

      <section id="sec-array-items">
        <h4 id="sec-22.1.1.3" title="22.1.1.3">
            Array (...items )</h4><p>This description applies if and only if the Array constructor is called with at least two arguments.</p>

        <p class="normalbefore">When the <code>Array</code> function is called the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>numberOfArgs</i> be the number of arguments passed to this function call.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numberOfArgs</i> &ge; 2.</li>
          <li>If NewTarget is <b>undefined</b><i>,</i> let <i>newTarget</i> be the active function object, else let
              <i>newTarget</i> be NewTarget.</li>
          <li>Let <i>proto</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-getprototypefromconstructor">GetPrototypeFromConstructor</a>(<i>newTarget</i>,
              <code>"%ArrayPrototype%"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>proto</i>).</li>
          <li>Let <i>array</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(<i>numberOfArgs</i>, <i>proto</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>array</i>).</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Let <i>items</i> be a zero-origined <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the
              argument items in order.</li>
          <li>Repeat, while <i>k</i> &lt; <i>numberOfArgs</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>itemK</i> be <i>items</i>[<i>k</i>].</li>
              <li>Let <i>defineStatus</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>array</i>, <i>Pk</i>,
                  <i>itemK</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>defineStatus</i> is <b>true</b>.</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: the value of <i>array</i>&rsquo;s <code>length</code> property is
              <i>numberOfArgs</i>.</li>
          <li>Return <i>array</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-array-constructor">
      <div class="front">
        <h3 id="sec-22.1.2" title="22.1.2"> Properties of the Array Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Array
        constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is <b>1</b>), the Array constructor has the following
        properties:</p>
      </div>

      <section id="sec-array.from">
        <h4 id="sec-22.1.2.1" title="22.1.2.1">
            Array.from ( items [ , mapfn [ , thisArg ] ] )</h4><p class="normalbefore">When the <code>from</code> method is called with  argument <var>items</var> and optional arguments
        <var>mapfn</var> and <var>thisArg</var> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>C</i> be the <b>this</b> value.</li>
          <li>If <i>mapfn</i> is <b>undefined</b>, let  <i>mapping</i> be <b>false.</b></li>
          <li>else
            <ol class="block">
              <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>mapfn</i>) is <b>false</b>, throw a <b>TypeError</b>
                  exception.</li>
              <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
              <li>Let <i>mapping</i> be <b>true</b></li>
            </ol>
          </li>
          <li>Let <i>usingIterator</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>items</i>, @@iterator).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>usingIterator</i>).</li>
          <li>If <i>usingIterator</i> is not <b>undefined</b>, then
            <ol class="block">
              <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>C</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>A</i> be <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>C</i>).</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(0).</li>
                </ol>
              </li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
              <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>items</i>, <i>usingIterator</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
              <li>Let <i>k</i> be 0.</li>
              <li>Repeat
                <ol class="block">
                  <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
                  <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iterator</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
                  <li>If <i>next</i> is <b>false</b>, then
                    <ol class="block">
                      <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>A</i>, <code>"length"</code>,
                          <i>k</i>, <b>true</b>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                      <li>Return <i>A</i>.</li>
                    </ol>
                  </li>
                  <li>Let <i>nextValue</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextValue</i>).</li>
                  <li>If <i>mapping</i> is <b>true</b>, then
                    <ol class="block">
                      <li>Let <i>mappedValue</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>mapfn</i>, <i>T</i>, &laquo;<i>nextValue</i>,
                          <i>k</i>&raquo;).</li>
                      <li>If <i>mappedValue</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>,
                          return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>mappedValue</i>).</li>
                      <li>Let <i>mappedValue</i> be <i>mappedValue</i>.[[value]].</li>
                    </ol>
                  </li>
                  <li>Else, let <i>mappedValue</i> be <i>nextValue</i>.</li>
                  <li>Let <i>defineStatus</i> be <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a>(<i>A</i>,
                      <i>Pk</i>, <i>mappedValue</i>).</li>
                  <li>If <i>defineStatus</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>,
                      return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iterator</i>, <i>defineStatus</i>).</li>
                  <li>Increase <i>k</i> by 1.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>items</i> is not an Iterable so assume it is an array-like
              object.</li>
          <li>Let <i>arrayLike</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>items</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>arrayLike</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>arrayLike</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>C</i>) is <b>true</b>, then
            <ol class="block">
              <li>Let <i>A</i> be <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>C</i>, &laquo;<i>len</i>&raquo;).</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(<i>len</i>).</li>
            </ol>
          </li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>arrayLike</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
              <li>If <i>mapping</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>mappedValue</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>mapfn</i>, <i>T</i>, &laquo;<i>kValue</i>,
                      <i>k</i>&raquo;).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>mappedValue</i>).</li>
                </ol>
              </li>
              <li>Else, let <i>mappedValue</i> be <i>kValue</i>.</li>
              <li>Let <i>defineStatus</i> be <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a>(<i>A</i>,
                  <i>Pk</i>, <i>mappedValue</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>defineStatus</i>).</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>A</i>, <code>"length"</code>, <i>len</i>,
              <b>true</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
          <li>Return <i>A</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>from</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>from</code> function is an intentionally generic factory method; it does not
          require that its <b>this</b> value be the Array constructor. Therefore it can be transferred to or inherited by any
          other constructors that may be called with a single numeric argument.</p>
        </div>
      </section>

      <section id="sec-array.isarray">
        <h4 id="sec-22.1.2.2" title="22.1.2.2">
            Array.isArray ( arg )</h4><p class="normalbefore">The <code>isArray</code> function takes one argument <var>arg</var>, and performs the following
        steps:</p>

        <ol class="proc">
          <li>Return <a href="sec-abstract-operations#sec-isarray">IsArray</a>(<i>arg</i>).</li>
        </ol>
      </section>

      <section id="sec-array.of">
        <h4 id="sec-22.1.2.3" title="22.1.2.3">
            Array.of ( ...items )</h4><p class="normalbefore">When the <code>of</code> method is called with any number of arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>len</i> be the actual number of arguments passed to this function.</li>
          <li>Let <i>items</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of arguments passed to this
              function.</li>
          <li>Let <i>C</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>C</i>) is <b>true</b>, then
            <ol class="block">
              <li>Let <i>A</i> be <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>C</i>, &laquo;<i>len</i>&raquo;).</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arraycreate">ArrayCreate</a>(<i>len</i>).</li>
            </ol>
          </li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>kValue</i> be <i>items</i>[<i>k</i>].</li>
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>defineStatus</i> be <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a>(<i>A</i>,<i>Pk</i>, <i>kValue</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>defineStatus</i>).</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>A</i>, <code>"length"</code>, <i>len</i>,
              <b>true</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
          <li>Return <i>A</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>of</code> method is <b>0</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The <var>items</var> argument is assumed to be a well-formed rest argument value.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>of</code> function is an intentionally generic factory method; it does not
          require that its <b>this</b> value be the Array constructor. Therefore it can be transferred to or inherited by other
          constructors that may be called with a single numeric argument.</p>
        </div>
      </section>

      <section id="sec-array.prototype">
        <h4 id="sec-22.1.2.4" title="22.1.2.4">
            Array.prototype</h4><p>The value of <code>Array.prototype</code> is %ArrayPrototype%, the intrinsic Array prototype object (<a href="#sec-properties-of-the-array-prototype-object">22.1.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-get-array-@@species">
        <h4 id="sec-22.1.2.5" title="22.1.2.5"> get Array [ @@species ]</h4><p class="normalbefore"><code>Array[@@species]</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Return the <b>this</b> value.</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"get [Symbol.species]"</code>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Array prototype methods normally use their <code>this</code> object&rsquo;s constructor
          to create a derived object. However, a subclass constructor may over-ride that default behaviour by redefining its
          @@species property.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-array-prototype-object">
      <div class="front">
        <h3 id="sec-22.1.3" title="22.1.3"> Properties of the Array Prototype Object</h3><p>The Array prototype object is the intrinsic object %ArrayPrototype%. The Array prototype object is an Array exotic
        objects and has the internal methods specified for such objects. It has a <code>length</code> property whose initial value
        is 0 and whose attributes are <span style="font-family: Times New Roman">{ [[Writable]]: <b>true</b>, [[Enumerable]]:
        <b>false</b>, [[Configurable]]: <b>false</b> }</span>.</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Array
        prototype object is the intrinsic object %ObjectPrototype%.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The Array prototype object is specified to be an <a href="sec-ordinary-and-exotic-objects-behaviours#sec-array-exotic-objects">Array exotic object</a> to ensure compatibility with ECMAScript code that was created
          prior to the ECMAScript 2015 specification.</p>
        </div>
      </div>

      <section id="sec-array.prototype.concat">
        <div class="front">
          <h4 id="sec-22.1.3.1" title="22.1.3.1"> Array.prototype.concat ( ...arguments )</h4><p>When the <code>concat</code> method is called with zero or more arguments, it returns an array containing the array
          elements of the object followed by the array elements of each argument in order.</p>

          <p class="normalbefore">The following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
            <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arrayspeciescreate">ArraySpeciesCreate</a>(<i>O</i>, 0).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
            <li>Let <i>n</i> be 0.</li>
            <li>Let <i>items</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose first element is <i>O</i>
                and whose subsequent elements are, in left to right order, the arguments that were passed to this function
                invocation.</li>
            <li>Repeat, while <i>items</i> is not empty
              <ol class="block">
                <li>Remove the first element from <i>items</i> and let <i>E</i> be the value of the element.</li>
                <li>Let <i>spreadable</i> be <a href="#sec-isconcatspreadable">IsConcatSpreadable</a>(<i>E</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>spreadable</i>).</li>
                <li>If <i>spreadable</i> is <b>true</b>, then
                  <ol class="block">
                    <li>Let <i>k</i> be 0.</li>
                    <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>E</i>,
                        <code>"length"</code>)).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
                    <li>If <i>n</i> + <i>len</i> &gt; 2<sup>53</sup>-1, throw a <b>TypeError</b> exception.</li>
                    <li>Repeat, while <i>k</i> &lt; <i>len</i>
                      <ol class="block">
                        <li>Let <i>P</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
                        <li>Let <i>exists</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>E</i>, <i>P</i>).</li>
                        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>exists</i>).</li>
                        <li>If <i>exists</i> is <b>true</b>, then
                          <ol class="block">
                            <li>Let <i>subElement</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>E</i>, <i>P</i>).</li>
                            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>subElement</i>).</li>
                            <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a>
                                (<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>n</i>), <i>subElement</i>).</li>
                            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                          </ol>
                        </li>
                        <li>Increase <i>n</i> by 1.</li>
                        <li>Increase <i>k</i> by 1.</li>
                      </ol>
                    </li>
                  </ol>
                </li>
                <li>Else <i>E</i> is added as a single item rather than spread,
                  <ol class="block">
                    <li>If <i>n</i>&ge;2<sup>53</sup>-1, throw a <b>TypeError</b> exception.</li>
                    <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a> (<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>n</i>), <i>E</i>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                    <li>Increase <i>n</i> by 1.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>A</i>, <code>"length"</code>, <i>n</i>,
                <b>true</b>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
            <li>Return <i>A</i>.</li>
          </ol>

          <p>The <code>length</code> property of the <code>concat</code> method is <b>1</b>.</p>

          <div class="note">
            <p><span class="nh">NOTE 1</span> The explicit setting of the <code>length</code> property in step 8 is necessary to
            ensure that its value is correct in situations where the trailing elements of the result Array are not present.</p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 2</span> The <code>concat</code> function is intentionally generic; it does not require that
            its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
            method.</p>
          </div>
        </div>

        <section id="sec-isconcatspreadable">
          <h5 id="sec-22.1.3.1.1" title="22.1.3.1.1"> Runtime Semantics: IsConcatSpreadable ( O )</h5><p class="normalbefore">The abstract operation IsConcatSpreadable with argument <i>O</i> performs the following
          steps:</p>

          <ol class="proc">
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <b>false</b>.</li>
            <li>Let <i>spreadable</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, @@isConcatSpreadable).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>spreadable</i>).</li>
            <li>If <i>spreadable</i> is not <b>undefined</b>, return <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<i>spreadable</i>).</li>
            <li>Return <a href="sec-abstract-operations#sec-isarray">IsArray</a>(<i>O</i>).</li>
          </ol>
        </section>
      </section>

      <section id="sec-array.prototype.constructor">
        <h4 id="sec-22.1.3.2" title="22.1.3.2"> Array.prototype.constructor</h4><p>The initial value of <code>Array.prototype.constructor</code> is the intrinsic object %Array%.</p>
      </section>

      <section id="sec-array.prototype.copywithin">
        <h4 id="sec-22.1.3.3" title="22.1.3.3"> Array.prototype.copyWithin (target, start [ , end ] )</h4><p class="normalbefore">The <code>copyWithin</code> method takes up to three arguments <var>target</var>, <var>start</var>
        and <var>end</var>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The <var>end</var> argument is optional with the length of the <b>this</b> object as
          its default value. If <var>target</var> is negative, it is treated as <span style="font-family: Times New           Roman"><i>length</i>+<i>target</i></span> where <var>length</var> is the length of the array. If <var>start</var> is
          negative, it is treated as <span style="font-family: Times New Roman"><i>length</i>+<i>start</i></span>. If
          <var>end</var> is negative, it is treated as <span style="font-family: Times New           Roman"><i>length</i>+<i>end</i></span>.</p>
        </div>

        <p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Let <i>relativeTarget</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>target</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeTarget</i>).</li>
          <li>If <i>relativeTarget</i> &lt; 0, let <i>to</i> be max((<i>len</i> + <i>relativeTarget</i>),0); else let <i>to</i> be
              min(<i>relativeTarget</i>, <i>len</i>).</li>
          <li>Let <i>relativeStart</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>start</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeStart</i>).</li>
          <li>If <i>relativeStart</i> &lt; 0, let <i>from</i> be max((<i>len</i> + <i>relativeStart</i>),0); else let <i>from</i>
              be min(<i>relativeStart</i>, <i>len</i>).</li>
          <li>If <i>end</i> is <b>undefined</b>, let <i>relativeEnd</i> be <i>len</i>; else let <i>relativeEnd</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>end</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeEnd</i>).</li>
          <li>If <i>relativeEnd</i> &lt; 0, let <i>final</i> be max((<i>len</i> + <i>relativeEnd</i>),0); else let <i>final</i> be
              min(<i>relativeEnd</i>, <i>len</i>).</li>
          <li>Let <i>count</i> be min(<i>final</i>-<i>from</i>, <i>len</i>-<i>to</i>).</li>
          <li>If <i>from</i>&lt;<i>to</i> and <i>to</i>&lt;<i>from</i>+<i>count</i>
            <ol class="block">
              <li>Let <i>direction</i> be -1.</li>
              <li>Let <i>from</i> be <i>from</i> + <i>count</i> -1.</li>
              <li>Let <i>to</i> be <i>to</i> + <i>count</i> -1.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>direction</i> = 1.</li>
            </ol>
          </li>
          <li>Repeat, while <i>count</i> &gt; 0
            <ol class="block">
              <li>Let <i>fromKey</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>from</i>).</li>
              <li>Let <i>toKey</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>to</i>).</li>
              <li>Let <i>fromPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>fromKey</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromPresent</i>).</li>
              <li>If <i>fromPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>fromVal</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>fromKey</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromVal</i>).</li>
                  <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <i>toKey</i>, <i>fromVal</i>,
                      <b>true</b>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                </ol>
              </li>
              <li>Else <i>fromPresent</i> is <b>false</b>,
                <ol class="block">
                  <li>Let <i>deleteStatus</i> be <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a>(<i>O</i>,
                      <i>toKey</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
                </ol>
              </li>
              <li>Let <i>from</i> be <i>from</i> + <i>direction</i>.</li>
              <li>Let <i>to</i> be <i>to</i> + <i>direction</i>.</li>
              <li>Let <i>count</i> be <i>count</i> &minus; 1.</li>
            </ol>
          </li>
          <li>Return <i>O</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>copyWithin</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>copyWithin</code> function is intentionally generic; it does not require
          that its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.entries">
        <h4 id="sec-22.1.3.4" title="22.1.3.4"> Array.prototype.entries ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Return <a href="#sec-createarrayiterator">CreateArrayIterator</a>(<i>O</i>, <code>"key+value"</code>).</li>
        </ol>
      </section>

      <section id="sec-array.prototype.every">
        <h4 id="sec-22.1.3.5" title="22.1.3.5"> Array.prototype.every ( callbackfn [ , thisArg] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <var>callbackfn</var> should be a function that accepts three arguments and returns a
          value that is coercible to the Boolean value <b>true</b> or <b>false</b>. <code>every</code> calls <var>callbackfn</var>
          once for each element present in the array, in ascending order, until it finds one where <var>callbackfn</var> returns
          <b>false</b>. If such an element is found, <code>every</code> immediately returns <b>false</b>. Otherwise, if
          <var>callbackfn</var> returned <b>true</b> for all elements, <code>every</code> will return <b>true</b>.
          <var>callbackfn</var> is called only for elements of the array which actually exist; it is not called for missing
          elements of the array.</p>
        </div>

        <p class="NoteMore">If a <var>thisArg</var> parameter is provided, it will be used as the <b>this</b> value for each
        invocation of <var>callbackfn</var>. If it is not provided, <b>undefined</b> is used instead.</p>

        <p class="NoteMore"><var>callbackfn</var> is called with three arguments: the value of the element, the index of the
        element, and the object being traversed.</p>

        <p class="NoteMore"><code>every</code> does not directly mutate the object on which it is called but the object may be
        mutated by the calls to <var>callbackfn</var>.</p>

        <p class="NoteMore">The range of elements processed by <code>every</code> is set before the first call to
        <var>callbackfn</var>. Elements which are appended to the array after the call to <code>every</code> begins will not be
        visited by <var>callbackfn</var>. If existing elements of the array are changed, their value as passed to
        <var>callbackfn</var> will be the value at the time <code>every</code> visits them; elements that are deleted after the
        call to <code>every</code> begins and before being visited are not visited. <code>every</code> acts like the "for all"
        quantifier in mathematics. In particular, for an empty array, it returns <b>true</b>.</p>

        <p class="normalbefore">When the <code>every</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
              <li>If <i>kPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
                  <li>Let <i>testResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>, <i>T</i>, &laquo;<i>kValue</i>, <i>k</i>,
                      <i>O</i>&raquo;)).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>testResult</i>).</li>
                  <li>If <i>testResult</i> is <b>false</b>, return <b>false</b>.</li>
                </ol>
              </li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <b>true</b>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>every</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>every</code> function is intentionally generic; it does not require that its
          <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.fill">
        <h4 id="sec-22.1.3.6" title="22.1.3.6"> Array.prototype.fill (value [ , start [ , end ] ] )</h4><p class="normalbefore">The <code>fill</code> method takes up to three arguments <var>value</var>, <var>start</var> and
        <var>end</var>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The <var>start</var> and <var>end</var> arguments are optional with default values of
          0 and the length of the <b>this</b> object. If <var>start</var> is negative, it is treated as <span style="font-family:           Times New Roman"><i>length</i>+<i>start</i></span> where <var>length</var> is the length of the array. If <var>end</var>
          is negative, it is treated as <span style="font-family: Times New Roman"><i>length</i>+<i>end</i></span>.</p>
        </div>

        <p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Let <i>relativeStart</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>start</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeStart</i>).</li>
          <li>If <i>relativeStart</i> &lt; 0, let <i>k</i> be max((<i>len</i> + <i>relativeStart</i>),0); else let <i>k</i> be
              min(<i>relativeStart</i>, <i>len</i>).</li>
          <li>If <i>end</i> is <b>undefined</b>, let <i>relativeEnd</i> be <i>len</i>; else let <i>relativeEnd</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>end</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeEnd</i>).</li>
          <li>If <i>relativeEnd</i> &lt; 0, let <i>final</i> be max((<i>len</i> + <i>relativeEnd</i>),0); else let <i>final</i> be
              min(<i>relativeEnd</i>, <i>len</i>).</li>
          <li>Repeat, while <i>k</i> &lt; <i>final</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <i>Pk</i>, <i>value</i>,
                  <b>true</b>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>O</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>fill</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>fill</code> function is intentionally generic; it does not require that its
          <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.filter">
        <h4 id="sec-22.1.3.7" title="22.1.3.7"> Array.prototype.filter ( callbackfn [ , thisArg ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <var>callbackfn</var> should be a function that accepts three arguments and returns a
          value that is coercible to the Boolean value <b>true</b> or <b>false</b>. <code>filter</code> calls
          <var>callbackfn</var> once for each element in the array, in ascending order, and constructs a new array of all the
          values for which <var>callbackfn</var> returns <b>true</b>. <var>callbackfn</var> is called only for elements of the
          array which actually exist; it is not called for missing elements of the array.</p>
        </div>

        <p class="NoteMore">If a <var>thisArg</var> parameter is provided, it will be used as the <b>this</b> value for each
        invocation of <var>callbackfn</var>. If it is not provided, <b>undefined</b> is used instead.</p>

        <p class="NoteMore"><var>callbackfn</var> is called with three arguments: the value of the element, the index of the
        element, and the object being traversed.</p>

        <p class="NoteMore"><code>filter</code> does not directly mutate the object on which it is called but the object may be
        mutated by the calls to <var>callbackfn</var>.</p>

        <p class="NoteMore">The range of elements processed by <code>filter</code> is set before the first call to
        <var>callbackfn</var>. Elements which are appended to the array after the call to <code>filter</code> begins will not be
        visited by <var>callbackfn</var>. If existing elements of the array are changed their value as passed to
        <var>callbackfn</var> will be the value at the time <code>filter</code> visits them; elements that are deleted after the
        call to <code>filter</code> begins and before being visited are not visited.</p>

        <p class="normalbefore">When the <code>filter</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arrayspeciescreate">ArraySpeciesCreate</a>(<i>O</i>, 0).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Let <i>to</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
              <li>If <i>kPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
                  <li>Let <i>selected</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>, <i>T</i>, &laquo;<i>kValue</i>, <i>k</i>,
                      <i>O</i>&raquo;)).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>selected</i>).</li>
                  <li>If <i>selected</i> is <b>true</b>, then
                    <ol class="block">
                      <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a> (<i>A</i>,
                          <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>to</i>), <i>kValue</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                      <li>Increase <i>to</i> by 1.</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>A</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>filter</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>filter</code> function is intentionally generic; it does not require that
          its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.find">
        <h4 id="sec-22.1.3.8" title="22.1.3.8"> Array.prototype.find ( predicate [ , thisArg ] )</h4><p class="normalBullet">The <code>find</code> method is called with one or two arguments, <var>predicate</var> and
        <var>thisArg</var>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> <var>predicate</var> should be a function that accepts three arguments and returns a
          value that is coercible to a Boolean value. <code>find</code> calls <var>predicate</var> once for each element of the
          array, in ascending order, until it finds one where <var>predicate</var> returns <span class="value">true</span>. If
          such an element is found, <code>find</code> immediately returns that element value. Otherwise, <code>find</code> returns
          <span class="value">undefined</span>.</p>
        </div>

        <p class="NoteMore">If a <var>thisArg</var> parameter is provided, it will be used as the <b>this</b> value for each
        invocation of <var>predicate</var>. If it is not provided, <span class="value">undefined</span> is used instead.</p>

        <p class="NoteMore"><var>predicate</var> is called with three arguments: the value of the element, the index of the
        element, and the object being traversed.</p>

        <p class="NoteMore"><code>find</code> does not directly mutate the object on which it is called but the object may be
        mutated by the calls to <var>predicate</var>.</p>

        <p class="NoteMore">The range of elements processed by <code>find</code> is set before the first call to
        <var>callbackfn</var>. Elements that are appended to the array after the call to <code>find</code> begins will not be
        visited by <var>callbackfn</var>. If existing elements of the array are changed, their value as passed to
        <var>predicate</var> will be the value at the time that <code>find</code> visits them.</p>

        <p class="normalbefore">When the <code>find</code> method is called, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>predicate</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
              <li>Let <i>testResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>predicate</i>,
                  <i>T</i>, &laquo;<i>kValue</i>, <i>k</i>, <i>O</i>&raquo;)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>testResult</i>).</li>
              <li>If <i>testResult</i> is <b>true</b>, return <i>kValue</i>.</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <b>undefined</b>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>find</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>find</code> function is intentionally generic; it does not require that its
          <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.findindex">
        <h4 id="sec-22.1.3.9" title="22.1.3.9"> Array.prototype.findIndex ( predicate [ , thisArg ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <var>predicate</var> should be a function that accepts three arguments and returns a
          value that is coercible to the Boolean value <b>true</b> or <b>false</b>. <code>findIndex</code> calls
          <var>predicate</var> once for each element of the array, in ascending order, until it finds one where
          <var>predicate</var> returns <b>true</b>. If such an element is found, <code>findIndex</code> immediately returns the
          index of that element value. Otherwise, <code>findIndex</code> returns -1.</p>
        </div>

        <p class="NoteMore">If a <var>thisArg</var> parameter is provided, it will be used as the <b>this</b> value for each
        invocation of <var>predicate</var>. If it is not provided, <b>undefined</b> is used instead.</p>

        <p class="NoteMore"><var>predicate</var> is called with three arguments: the value of the element, the index of the
        element, and the object being traversed.</p>

        <p class="NoteMore"><code>findIndex</code> does not directly mutate the object on which it is called but the object may be
        mutated by the calls to <var>predicate</var>.</p>

        <p class="NoteMore">The range of elements processed by <code>findIndex</code> is set before the first call to
        <var>callbackfn</var>. Elements that are appended to the array after the call to <code>findIndex</code> begins will not be
        visited by <var>callbackfn</var>. If existing elements of the array are changed, their value as passed to
        <var>predicate</var> will be the value at the time that <code>findIndex</code> visits them.</p>

        <p class="normalbefore">When the <code>findIndex</code> method is called with one or two arguments, the following steps
        are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>predicate</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
              <li>Let <i>testResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>predicate</i>,
                  <i>T</i>, &laquo;<i>kValue</i>, <i>k</i>, <i>O</i>&raquo;)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>testResult</i>).</li>
              <li>If <i>testResult</i> is <b>true</b>, return <i>k</i>.</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return -1.</li>
        </ol>

        <p>The <code>length</code> property of the <code>findIndex</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>findIndex</code> function is intentionally generic; it does not require that
          its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.foreach">
        <h4 id="sec-22.1.3.10" title="22.1.3.10"> Array.prototype.forEach ( callbackfn [ , thisArg ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <var>callbackfn</var> should be a function that accepts three arguments.
          <code>forEach</code> calls <var>callbackfn</var> once for each element present in the array, in ascending order.
          <var>callbackfn</var> is called only for elements of the array which actually exist; it is not called for missing
          elements of the array.</p>

          <p>If a <var>thisArg</var> parameter is provided, it will be used as the <b>this</b> value for each invocation of
          <var>callbackfn</var>. If it is not provided, <b>undefined</b> is used instead.</p>

          <p><var>callbackfn</var> is called with three arguments: the value of the element, the index of the element, and the
          object being traversed.</p>

          <p><code>forEach</code> does not directly mutate the object on which it is called but the object may be mutated by the
          calls to <var>callbackfn</var>.</p>
        </div>

        <p class="normalbefore">When the <code>forEach</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
              <li>If <i>kPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
                  <li>Let <i>funcResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>, <i>T</i>, &laquo;<i>kValue</i>,
                      <i>k</i>, <i>O</i>&raquo;).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>funcResult</i>).</li>
                </ol>
              </li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <b>undefined</b>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>forEach</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>forEach</code> function is intentionally generic; it does not require that
          its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.indexof">
        <h4 id="sec-22.1.3.11" title="22.1.3.11"> Array.prototype.indexOf ( searchElement [ , fromIndex ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <code>indexOf</code> compares <var>searchElement</var> to the elements of the array,
          in ascending order, using the Strict Equality Comparison algorithm (<a href="sec-abstract-operations#sec-strict-equality-comparison">7.2.13</a>), and if found at one or more indices, returns the smallest such
          index; otherwise, &minus;1 is returned.</p>

          <p>The optional second argument <var>fromIndex</var> defaults to 0 (i.e. the whole array is searched). If it is greater
          than or equal to the length of the array, &minus;1 is returned, i.e. the array will not be searched. If it is negative,
          it is used as the offset from the end of the array to compute <var>fromIndex</var>. If the computed index is less than
          0, the whole array will be searched.</p>
        </div>

        <p class="normalbefore">When the <code>indexOf</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <i>len</i> is 0, return &minus;1.</li>
          <li>If argument <i>fromIndex</i> was passed let <i>n</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>fromIndex</i>);
              else let <i>n</i> be 0.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>n</i>).</li>
          <li>If <i>n</i> &ge; <i>len</i>, return &minus;1.</li>
          <li>If <i>n</i> &ge; 0, then
            <ol class="block">
              <li>Let <i>k</i> be <i>n</i>.</li>
            </ol>
          </li>
          <li>Else <i>n</i>&lt;0,
            <ol class="block">
              <li>Let <i>k</i> be <i>len</i> - <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>n</i>).</li>
              <li>If <i>k</i> &lt; 0, let <i>k</i> be 0.</li>
            </ol>
          </li>
          <li>Repeat, while <i>k</i>&lt;<i>len</i>
            <ol class="block">
              <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
              <li>If <i>kPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>elementK</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>)).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>elementK</i>).</li>
                  <li>Let <i>same</i> be the result of performing Strict Equality Comparison <i>searchElement</i> ===
                      <i>elementK</i>.</li>
                  <li>If <i>same</i> is <b>true,</b>  return <i>k</i>.</li>
                </ol>
              </li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return -1.</li>
        </ol>

        <p>The <code>length</code> property of the <code>indexOf</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>indexOf</code> function is intentionally generic; it does not require that
          its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.join">
        <h4 id="sec-22.1.3.12" title="22.1.3.12"> Array.prototype.join (separator)</h4><div class="note">
          <p><span class="nh">NOTE 1</span> The elements of the array are converted to Strings, and these Strings are then
          concatenated, separated by occurrences of the <var>separator</var>. If no separator is provided, a single comma is used
          as the separator.</p>
        </div>

        <p class="normalbefore">The <code>join</code> method takes one argument, <var>separator</var>, and performs the following
        steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <i>separator</i> is <b>undefined</b>, let <i>separator</i> be the single-element String <code>","</code>.</li>
          <li>Let <i>sep</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>separator</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>sep</i>).</li>
          <li>If <i>len</i> is zero, return the empty String.</li>
          <li>Let <i>element0</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <code>"0"</code>).</li>
          <li>If <i>element0</i> is <b>undefined</b> or <b>null</b>, let <i>R</i> be the empty String; otherwise, let <i>R</i> be
              <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>element0</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>R</i>).</li>
          <li>Let <i>k</i> be <code>1</code>.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>S</i> be the String value produced by concatenating <i>R</i> and <i>sep</i>.</li>
              <li>Let <i>element</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>)).</li>
              <li>If <i>element</i> is <b>undefined</b> or <b>null</b>, let <i>next</i> be the empty String; otherwise, let
                  <i>next</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>element</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>Let <i>R</i> be a String value produced by concatenating <i>S</i> and <i>next</i>.</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>R</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>join</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>join</code> function is intentionally generic; it does not require that its
          <b>this</b> value be an Array object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.keys">
        <h4 id="sec-22.1.3.13" title="22.1.3.13"> Array.prototype.keys ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Return <a href="#sec-createarrayiterator">CreateArrayIterator</a>(<i>O</i>, <code>"key"</code>).</li>
        </ol>
      </section>

      <section id="sec-array.prototype.lastindexof">
        <h4 id="sec-22.1.3.14" title="22.1.3.14"> Array.prototype.lastIndexOf ( searchElement [ , fromIndex ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <code>lastIndexOf</code> compares <var>searchElement</var> to the elements of the
          array in descending order using the Strict Equality Comparison algorithm (<a href="sec-abstract-operations#sec-strict-equality-comparison">7.2.13</a>), and if found at one or more indices, returns the largest such index;
          otherwise, &minus;1 is returned.</p>

          <p>The optional second argument <var>fromIndex</var> defaults to the array's length minus one (i.e. the whole array is
          searched). If it is greater than or equal to the length of the array, the whole array will be searched. If it is
          negative, it is used as the offset from the end of the array to compute <var>fromIndex</var>. If the computed index is
          less than 0, &minus;1 is returned.</p>
        </div>

        <p class="normalbefore">When the <code>lastIndexOf</code> method is called with one or two arguments, the following steps
        are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <i>len</i> is 0, return -1.</li>
          <li>If argument <i>fromIndex</i> was passed let <i>n</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>fromIndex</i>);
              else let <i>n</i> be <i>len</i>-1.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>n</i>).</li>
          <li>If <i>n</i> &ge; 0, let <i>k</i> be min(<i>n</i>, <i>len</i> &ndash; 1).</li>
          <li>Else  <i>n</i> &lt; 0,
            <ol class="block">
              <li>Let <i>k</i> be <i>len</i> - <a href="sec-notational-conventions#sec-algorithm-conventions">abs</a>(<i>n</i>).</li>
            </ol>
          </li>
          <li>Repeat, while <i>k</i>&ge; 0
            <ol class="block">
              <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
              <li>If <i>kPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>elementK</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>)).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>elementK</i>).</li>
                  <li>Let <i>same</i> be the result of performing Strict Equality Comparison <br /><i>searchElement</i> ===
                      <i>elementK</i>.</li>
                  <li>If <i>same</i> is <b>true,</b>  return <i>k</i>.</li>
                </ol>
              </li>
              <li>Decrease <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return -1.</li>
        </ol>

        <p>The <code>length</code> property of the <code>lastIndexOf</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>lastIndexOf</code> function is intentionally generic; it does not require
          that its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.map">
        <h4 id="sec-22.1.3.15" title="22.1.3.15"> Array.prototype.map ( callbackfn [ , thisArg ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <var>callbackfn</var> should be a function that accepts three arguments.
          <code>map</code> calls <var>callbackfn</var> once for each element in the array, in ascending order, and constructs a
          new Array from the results. <var>callbackfn</var> is called only for elements of the array which actually exist; it is
          not called for missing elements of the array.</p>

          <p>If a <var>thisArg</var> parameter is provided, it will be used as the <b>this</b> value for each invocation of
          <var>callbackfn</var>. If it is not provided, <b>undefined</b> is used instead.</p>

          <p><var>callbackfn</var> is called with three arguments: the value of the element, the index of the element, and the
          object being traversed.</p>

          <p><code>map</code> does not directly mutate the object on which it is called but the object may be mutated by the calls
          to <var>callbackfn</var>.</p>

          <p>The range of elements processed by <code>map</code> is set before the first call to <var>callbackfn</var>. Elements
          which are appended to the array after the call to <code>map</code> begins will not be visited by <var>callbackfn</var>.
          If existing elements of the array are changed, their value as passed to <var>callbackfn</var> will be the value at the
          time <code>map</code> visits them; elements that are deleted after the call to <code>map</code> begins and before being
          visited are not visited.</p>
        </div>

        <p class="normalbefore">When the <code>map</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arrayspeciescreate">ArraySpeciesCreate</a>(<i>O</i>, <i>len</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
              <li>If <i>kPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
                  <li>Let <i>mappedValue</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>, <i>T</i>, &laquo;<i>kValue</i>,
                      <i>k</i>, <i>O</i>&raquo;).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>mappedValue</i>).</li>
                  <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a> (<i>A</i>,
                      <i>Pk</i>, <i>mappedValue</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                </ol>
              </li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>A</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>map</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>map</code> function is intentionally generic; it does not require that its
          <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.pop">
        <h4 id="sec-22.1.3.16" title="22.1.3.16"> Array.prototype.pop ( )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> The last element of the array is removed from the array and returned.</p>
        </div>

        <p class="normalbefore">When the <code>pop</code> method is called the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <i>len</i> is zero,
            <ol class="block">
              <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <code>"length"</code>, 0,
                  <b>true</b>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
              <li>Return <b>undefined</b>.</li>
            </ol>
          </li>
          <li>Else <i>len</i> &gt; 0,
            <ol class="block">
              <li>Let <i>newLen</i> be <i>len</i>&ndash;1.</li>
              <li>Let <i>indx</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>newLen</i>).</li>
              <li>Let <i>element</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>indx</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>element</i>).</li>
              <li>Let <i>deleteStatus</i> be <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a>(<i>O</i>,
                  <i>indx</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
              <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <code>"length"</code>, <i>newLen</i>,
                  <b>true</b>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
              <li>Return <i>element</i>.</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>pop</code> function is intentionally generic; it does not require that its
          <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.push">
        <h4 id="sec-22.1.3.17" title="22.1.3.17"> Array.prototype.push ( ...items )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> The arguments are appended to the end of the array, in the order in which they appear.
          The new length of the array is returned as the result of the call.</p>
        </div>

        <p class="normalbefore">When the <code>push</code> method is called with zero or more arguments the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Let <i>items</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose elements are, in left to
              right order, the arguments that were passed to this function invocation.</li>
          <li>Let <i>argCount</i> be the number of elements in <i>items</i>.</li>
          <li>If <i>len</i> + <i>argCount</i> &gt; 2<sup>53</sup>-1, throw a <b>TypeError</b> exception.</li>
          <li>Repeat, while <i>items</i> is not empty
            <ol class="block">
              <li>Remove the first element from <i>items</i> and let <i>E</i> be the value of the element.</li>
              <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>len</i>), <i>E</i>, <b>true</b>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
              <li>Let  <i>len</i> be <i>len</i>+1.</li>
            </ol>
          </li>
          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <code>"length"</code>, <i>len</i>,
              <b>true</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
          <li>Return <i>len</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>push</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>push</code> function is intentionally generic; it does not require that its
          <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.reduce">
        <h4 id="sec-22.1.3.18" title="22.1.3.18"> Array.prototype.reduce ( callbackfn [ , initialValue ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <var>callbackfn</var> should be a function that takes four arguments.
          <code>reduce</code> calls the callback, as a function, once for each element present in the array, in ascending
          order.</p>

          <p><var>callbackfn</var> is called with four arguments: the <i>previousValue</i> (value from the previous call to
          <var>callbackfn</var>), the <i>currentValue</i> (value of the current element), the <i>currentIndex</i>, and the object
          being traversed. The first time that callback is called, the <i>previousValue</i> and <i>currentValue</i> can be one of
          two values. If an <var>initialValue</var> was provided in the call to <code>reduce</code>, then <i>previousValue</i>
          will be equal to <var>initialValue</var> and <i>currentValue</i> will be equal to the first value in the array. If no
          <var>initialValue</var> was provided, then <i>previousValue</i> will be equal to the first value in the array and
          <i>currentValue</i> will be equal to the second. It is a <b>TypeError</b> if the array contains no elements and
          <var>initialValue</var> is not provided.</p>

          <p><code>reduce</code> does not directly mutate the object on which it is called but the object may be mutated by the
          calls to <var>callbackfn</var>.</p>

          <p>The range of elements processed by <code>reduce</code> is set before the first call to <var>callbackfn</var>.
          Elements that are appended to the array after the call to <code>reduce</code> begins will not be visited by
          <var>callbackfn</var>. If existing elements of the array are changed, their value as passed to <var>callbackfn</var>
          will be the value at the time <code>reduce</code> visits them; elements that are deleted after the call to
          <code>reduce</code> begins and before being visited are not visited.</p>
        </div>

        <p class="normalbefore">When the <code>reduce</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>len</i> is 0 and <i>initialValue</i> is not present, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>k</i> be 0.</li>
          <li>If <i>initialValue</i> is present, then
            <ol class="block">
              <li>Set <i>accumulator</i> to <i>initialValue</i>.</li>
            </ol>
          </li>
          <li>Else <i>initialValue</i> is not present,
            <ol class="block">
              <li>Let <i>kPresent</i> be <b>false</b>.</li>
              <li>Repeat, while  <i>kPresent</i> is <b>false</b> and  <i>k</i> &lt; <i>len</i>
                <ol class="block">
                  <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
                  <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
                  <li>If <i>kPresent</i> is <b>true</b>, then
                    <ol class="block">
                      <li>Let <i>accumulator</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>accumulator</i>).</li>
                    </ol>
                  </li>
                  <li>Increase <i>k</i> by 1.</li>
                </ol>
              </li>
              <li>If <i>kPresent</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
            </ol>
          </li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
              <li>If <i>kPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
                  <li>Let <i>accumulator</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>, <b>undefined</b>,
                      &laquo;<i>accumulator</i>, <i>kValue</i>, <i>k</i>, <i>O</i>&raquo;).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>accumulator</i>).</li>
                </ol>
              </li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>accumulator</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>reduce</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>reduce</code> function is intentionally generic; it does not require that
          its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.reduceright">
        <h4 id="sec-22.1.3.19" title="22.1.3.19"> Array.prototype.reduceRight ( callbackfn [ , initialValue ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <var>callbackfn</var> should be a function that takes four arguments.
          <code>reduceRight</code> calls the callback, as a function, once for each element present in the array, in descending
          order.</p>

          <p><var>callbackfn</var> is called with four arguments: the <var>previousValue</var> (value from the previous call to
          <var>callbackfn</var>), the <var>currentValue</var> (value of the current element), the <var>currentIndex</var>, and the
          object being traversed. The first time the function is called, the <var>previousValue</var> and <var>currentValue</var>
          can be one of two values. If an <var>initialValue</var> was provided in the call to <code>reduceRight</code>, then
          <var>previousValue</var> will be equal to <var>initialValue</var> and <var>currentValue</var> will be equal to the last
          value in the array. If no <var>initialValue</var> was provided, then <var>previousValue</var> will be equal to the last
          value in the array and <var>currentValue</var> will be equal to the second-to-last value. It is a <b>TypeError</b> if
          the array contains no elements and <var>initialValue</var> is not provided.</p>

          <p><code>reduceRight</code> does not directly mutate the object on which it is called but the object may be mutated by
          the calls to <var>callbackfn</var>.</p>

          <p>The range of elements processed by <code>reduceRight</code> is set before the first call to <var>callbackfn</var>.
          Elements that are appended to the array after the call to <code>reduceRight</code> begins will not be visited by
          <var>callbackfn</var>. If existing elements of the array are changed by <var>callbackfn</var>, their value as passed to
          <var>callbackfn</var> will be the value at the time <code>reduceRight</code> visits them; elements that are deleted
          after the call to <code>reduceRight</code> begins and before being visited are not visited.</p>
        </div>

        <p class="normalbefore">When the <code>reduceRight</code> method is called with one or two arguments, the following steps
        are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>len</i> is 0 and <i>initialValue</i> is not present, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>k</i> be <i>len</i>-1.</li>
          <li>If <i>initialValue</i> is present, then
            <ol class="block">
              <li>Set <i>accumulator</i> to <i>initialValue</i>.</li>
            </ol>
          </li>
          <li>Else <i>initialValue</i> is not present,
            <ol class="block">
              <li>Let <i>kPresent</i> be <b>false</b>.</li>
              <li>Repeat, while  <i>kPresent</i> is <b>false</b> and  <i>k</i> &ge; 0
                <ol class="block">
                  <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
                  <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
                  <li>If <i>kPresent</i> is <b>true</b>, then
                    <ol class="block">
                      <li>Let <i>accumulator</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>accumulator</i>).</li>
                    </ol>
                  </li>
                  <li>Decrease <i>k</i> by 1.</li>
                </ol>
              </li>
              <li>If <i>kPresent</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
            </ol>
          </li>
          <li>Repeat, while <i>k</i> &ge; 0
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
              <li>If <i>kPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
                  <li>Let <i>accumulator</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>, <b>undefined</b>,
                      &laquo;<i>accumulator</i>, <i>kValue</i>, <i>k</i>, &raquo;).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>accumulator</i>).</li>
                </ol>
              </li>
              <li>Decrease <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>accumulator</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>reduceRight</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>reduceRight</code> function is intentionally generic; it does not require
          that its this value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.reverse">
        <h4 id="sec-22.1.3.20" title="22.1.3.20"> Array.prototype.reverse ( )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> The elements of the array are rearranged so as to reverse their order. The object is
          returned as the result of the call.</p>
        </div>

        <p class="normalbefore">When the <code>reverse</code> method is called the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Let <i>middle</i> be  <a href="sec-notational-conventions#sec-algorithm-conventions">floor</a>(<i>len</i>/2).</li>
          <li>Let <i>lower</i> be <b>0</b>.</li>
          <li>Repeat, while <i>lower</i> &ne; <i>middle</i>
            <ol class="block">
              <li>Let <i>upper</i> be <i>len</i>&minus; <i>lower</i> &minus;1.</li>
              <li>Let <i>upperP</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>upper</i>).</li>
              <li>Let <i>lowerP</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>lower</i>).</li>
              <li>Let <i>lowerExists</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>lowerP</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lowerExists</i>).</li>
              <li>If <i>lowerExists</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>lowerValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,  <i>lowerP</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>lowerValue</i>).</li>
                </ol>
              </li>
              <li>Let <i>upperExists</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>upperP</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>upperExists</i>).</li>
              <li>If <i>upperExists</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>upperValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>upperP</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>upperValue</i>).</li>
                </ol>
              </li>
              <li>If <i>lowerExists</i> is <b>true</b> and <i>upperExists</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <i>lowerP</i>, <i>upperValue</i>,
                      <b>true</b>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                  <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <i>upperP</i>, <i>lowerValue</i>,
                      <b>true</b>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                </ol>
              </li>
              <li>Else if <i>lowerExists</i> is <b>false</b> and <i>upperExists</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <i>lowerP</i>, <i>upperValue</i>,
                      <b>true</b>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                  <li>Let <i>deleteStatus</i> be <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a> (<i>O</i>,
                      <i>upperP</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
                </ol>
              </li>
              <li>Else if <i>lowerExists</i> is <b>true</b> and <i>upperExists</i> is <b>false</b>, then
                <ol class="block">
                  <li>Let <i>deleteStatus</i> be <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a> (<i>O</i>,
                      <i>lowerP</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
                  <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <i>upperP</i>, <i>lowerValue</i>,
                      <b>true</b>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                </ol>
              </li>
              <li>Else both <i>lowerExists</i> and <i>upperExists</i> are <b>false</b>,
                <ol class="block">
                  <li>No action is required.</li>
                </ol>
              </li>
              <li>Increase <i>lower</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>O</i> .</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>reverse</code> function is intentionally generic; it does not require that
          its <b>this</b> value be an Array object. Therefore, it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.shift">
        <h4 id="sec-22.1.3.21" title="22.1.3.21"> Array.prototype.shift ( )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> The first element of the array is removed from the array and returned.</p>
        </div>

        <p class="normalbefore">When the <code>shift</code> method is called the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <i>len</i> is zero, then
            <ol class="block">
              <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <code>"length"</code>, 0,
                  <b>true</b>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
              <li>Return <b>undefined</b>.</li>
            </ol>
          </li>
          <li>Let <i>first</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <code>"<b>0</b>"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>first</i>).</li>
          <li>Let <i>k</i> be 1.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>from</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>to</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>&ndash;1).</li>
              <li>Let <i>fromPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>from</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromPresent</i>).</li>
              <li>If <i>fromPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>fromVal</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>from</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromVal</i>).</li>
                  <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <i>to</i>, <i>fromVal</i>,
                      <b>true</b>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                </ol>
              </li>
              <li>Else <i>fromPresent</i> is <b>false</b>,
                <ol class="block">
                  <li>Let <i>deleteStatus</i> be <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a>(<i>O</i>,
                      <i>to</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
                </ol>
              </li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Let <i>deleteStatus</i> be <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a>(<i>O</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>len</i>&ndash;1)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <code>"length"</code>, <i>len</i>&ndash;1,
              <b>true</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
          <li>Return <i>first</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>shift</code> function is intentionally generic; it does not require that its
          <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.slice">
        <h4 id="sec-22.1.3.22" title="22.1.3.22"> Array.prototype.slice (start, end)</h4><div class="note">
          <p><span class="nh">NOTE 1</span> The <code>slice</code> method takes two arguments, <var>start</var> and
          <var>end</var>, and returns an array containing the elements of the array from element <var>start</var> up to, but not
          including, element <var>end</var> (or through the end of the array if <var>end</var> is <b>undefined</b>). If
          <var>start</var> is negative, it is treated as <span style="font-family: Times New           Roman"><i>length</i>+<i>start</i></span> where <var>length</var> is the length of the array. If <var>end</var> is
          negative, it is treated as <span style="font-family: Times New Roman"><i>length</i>+<i>end</i></span> where
          <var>length</var> is the length of the array.</p>
        </div>

        <p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Let <i>relativeStart</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>start</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeStart</i>).</li>
          <li>If <i>relativeStart</i> &lt; 0, let <i>k</i> be max((<i>len</i> + <i>relativeStart</i>),0); else let <i>k</i> be
              min(<i>relativeStart</i>, <i>len</i>).</li>
          <li>If <i>end</i> is <b>undefined</b>, let <i>relativeEnd</i> be <i>len</i>; else let <i>relativeEnd</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>end</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeEnd</i>).</li>
          <li>If <i>relativeEnd</i> &lt; 0, let <i>final</i> be max((<i>len</i> + <i>relativeEnd</i>),0); else let <i>final</i> be
              min(<i>relativeEnd</i>, <i>len</i>).</li>
          <li>Let <i>count</i> be max(<i>final</i> &ndash; <i>k</i>, 0).</li>
          <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arrayspeciescreate">ArraySpeciesCreate</a>(<i>O</i>, <i>count</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
          <li>Let <i>n</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>final</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
              <li>If <i>kPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
                  <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>n</i>), <i>kValue</i> ).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                </ol>
              </li>
              <li>Increase <i>k</i> by 1.</li>
              <li>Increase <i>n</i> by 1.</li>
            </ol>
          </li>
          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>A</i>, <code>"length"</code>, <i>n</i>,
              <b>true</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
          <li>Return <i>A</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>slice</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The explicit setting of the <code>length</code> property of the result Array in step
          16 is necessary to ensure that its value is correct in situations where the trailing elements of the result Array are
          not present.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> The <code>slice</code> function is intentionally generic; it does not require that its
          <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.some">
        <h4 id="sec-22.1.3.23" title="22.1.3.23"> Array.prototype.some ( callbackfn [ , thisArg ] )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> <var>callbackfn</var> should be a function that accepts three arguments and returns a
          value that is coercible to the Boolean value <b>true</b> or <b>false</b>. <code>some</code> calls <var>callbackfn</var>
          once for each element present in the array, in ascending order, until it finds one where <var>callbackfn</var> returns
          <b>true</b>. If such an element is found, <code>some</code> immediately returns <b>true</b>. Otherwise,
          <code>some</code> returns <b>false</b>. <var>callbackfn</var> is called only for elements of the array which actually
          exist; it is not called for missing elements of the array.</p>

          <p>If a <var>thisArg</var> parameter is provided, it will be used as the <b>this</b> value for each invocation of
          <var>callbackfn</var>. If it is not provided, <b>undefined</b> is used instead.</p>

          <p><var>callbackfn</var> is called with three arguments: the value of the element, the index of the element, and the
          object being traversed.</p>

          <p><code>some</code> does not directly mutate the object on which it is called but the object may be mutated by the
          calls to <var>callbackfn</var>.</p>

          <p>The range of elements processed by <code>some</code> is set before the first call to <var>callbackfn</var>. Elements
          that are appended to the array after the call to <code>some</code> begins will not be visited by <var>callbackfn</var>.
          If existing elements of the array are changed, their value as passed to <var>callbackfn</var> will be the value at the
          time that <code>some</code> visits them; elements that are deleted after the call to <code>some</code> begins and before
          being visited are not visited. <code>some</code> acts like the "exists" quantifier in mathematics. In particular, for an
          empty array, it returns <b>false</b>.</p>
        </div>

        <p class="normalbefore">When the <code>some</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kPresent</i>).</li>
              <li>If <i>kPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
                  <li>Let <i>testResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>, <i>T</i>, &laquo;<i>kValue</i>, <i>k</i>, and
                      <i>O</i>&raquo;)).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>testResult</i>).</li>
                  <li>If <i>testResult</i> is <b>true</b>, return <b>true</b>.</li>
                </ol>
              </li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <b>false</b>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>some</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>some</code> function is intentionally generic; it does not require that its
          <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.sort">
        <div class="front">
          <h4 id="sec-22.1.3.24" title="22.1.3.24"> Array.prototype.sort (comparefn)</h4><p>The elements of this array are sorted. The sort is not necessarily stable (that is, elements that compare equal do
          not necessarily remain in their original order). If <var>comparefn</var> is not <b>undefined</b>, it should be a
          function that accepts two arguments <var>x</var> and <var>y</var> and returns a negative value if <var>x</var> <span style="font-family: Times New Roman">&lt;</span> <var>y</var>, zero if <var>x</var> <span style="font-family: Times New           Roman">=</span> <var>y</var>, or a positive value if <var>x</var> <span style="font-family: Times New Roman">&gt;</span>
          <var>y</var>.</p>

          <p class="normalbefore">Upon entry, the following steps are performed to initialize evaluation of the <code>sort</code>
          function:</p>

          <ol class="proc">
            <li>Let <i>obj</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
            <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>obj</i>,
                <code>"length"</code>)).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          </ol>

          <p class="normalbefore">Within this specification of the <code>sort</code> method, an object, <var>obj</var>,  is said
          to be <i>sparse</i> if the following algorithm returns <b>true</b>:</p>

          <ol class="proc">
            <li>For each integer <i>i</i> in the range 0&le;<i>i</i>&lt; <i>len</i>
              <ol class="block">
                <li>Let <i>elem</i> be <i>obj</i>.[[GetOwnProperty]](<a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>i</i>)).</li>
                <li>If <i>elem</i> is <b>undefined</b>, return <b>true</b>.</li>
              </ol>
            </li>
            <li>Return <b>false</b>.</li>
          </ol>

          <p>The <i>sort order</i> is the ordering, after completion of this function, of the integer indexed property values of
          <var>obj</var> whose integer indexes are less than <var>len</var>. The result of the <code>sort</code> function is then
          determined as follows:</p>

          <p>If <var>comparefn</var> is not <b>undefined</b> and is not a consistent comparison function for the elements of this
          array (see below), the sort order is implementation-defined. The sort order is also implementation-defined if
          <var>comparefn</var> is <b>undefined</b> and <a href="#sec-sortcompare">SortCompare</a> (<a href="#sec-sortcompare">22.1.3.24.1</a>) does not act as a consistent comparison function.</p>

          <p class="normalbefore">Let <var>proto</var> be <var>obj</var>.[[GetPrototypeOf]](). If <var>proto</var> is not
          <b>null</b> and there exists an integer <var>j</var> such that all of the conditions below are satisfied then the sort
          order is implementation-defined:</p>

          <ul>
            <li><var>obj</var> is sparse</li>
            <li>0 &le; <var>j</var> &lt; <var>len</var></li>
            <li><a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<var>proto</var>, <span style="font-family: Times New Roman"><a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>j</i>))</span> is <b>true</b>.</li>
          </ul>

          <p class="normalbefore">The sort order is also implementation defined if <var>obj</var> is sparse and any of the
          following conditions are true:</p>

          <ul>
            <li>
              <p><a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<span style="font-family: Times New Roman"><i>obj</i>)</span> is
              <b>false</b>.</p>
            </li>

            <li>
              <p>Any integer index property of <var>obj</var> whose name is a nonnegative integer less than <var>len</var> is a
              data property whose [[Configurable]] attribute is <b>false</b>.</p>
            </li>
          </ul>

          <p>The sort order is also implementation defined if any of the following conditions are true:</p>

          <ul>
            <li>
              <p>If <var>obj</var> is an exotic object (including Proxy exotic objects) whose behaviour for [[Get]], [[Set]],
              [[Delete]], and [[GetOwnProperty]] is not the ordinary object implementation of these internal methods.</p>
            </li>

            <li>
              <p>If any index index property of <var>obj</var> whose name is a nonnegative integer less than <var>len</var> is an
              accessor property or is a data property whose [[Writable]] attribute is <span class="value">false</span>.</p>
            </li>

            <li>
              <p>If <var>comparefn</var> is <span class="value">undefined</span> and the application of <a href="sec-abstract-operations#sec-tostring">ToString</a> to any value passed as an argument to <a href="#sec-sortcompare">SortCompare</a>
              modifies <var>obj</var> or any object on <var>obj</var>&rsquo;s prototype chain.</p>
            </li>

            <li>
              <p>If <var>comparefn</var> is <span class="value">undefined</span> and all applications of <a href="sec-abstract-operations#sec-tostring">ToString</a>, to any specific value passed as an argument to <a href="#sec-sortcompare">SortCompare</a>, do not produce the same result.</p>
            </li>
          </ul>

          <p class="normalbefore">The following steps are taken:</p>

          <ol class="proc">
            <li>Perform an implementation-dependent sequence of calls to the [[Get]] and [[Set]] internal methods of <i>obj</i>,
                to the <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a> and <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a> abstract operation with <i>obj</i> as the first argument, and to <a href="#sec-sortcompare">SortCompare</a> (described below), such that:
              <ul>
                <li>
                  <p>The <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> argument for each call to [[Get]], [[Set]], <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>, or <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a>
                  is the string representation of a nonnegative integer less than <i>len</i>.</p>
                </li>

                <li>
                  <p>The arguments for calls to <a href="#sec-sortcompare">SortCompare</a> are values returned by a previous call
                  to the [[Get]] internal method, unless the properties accessed by those previous calls did not exist according
                  to <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>. If both perspective arguments to <a href="#sec-sortcompare">SortCompare</a> correspond to non-existent properties, use +0 instead of calling <a href="#sec-sortcompare">SortCompare</a>. If only the first perspective argument is non-existent use +1. If only
                  the second perspective argument is non-existent use &minus;1.</p>
                </li>

                <li>
                  <p>If <i>obj</i> is not sparse then <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a> must not be
                  called.</p>
                </li>

                <li>
                  <p>If any [[Set]] call returns <b>false</b> a <b>TypeError</b> exception is thrown.</p>
                </li>

                <li>
                  <p>If an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> is returned from any of these
                  operations, it is immediately returned as the value of this function.</p>
                </li>
              </ul>
            </li>
            <li>Return <i>obj</i>.</li>
          </ol>

          <p class="normalbefore">Unless the sort order is specified above to be implementation-defined, the returned object must
          have the following two characteristics:</p>

          <ul>
            <li>
              <p>There must be some mathematical permutation <span style="font-family: Times New Roman">&pi;</span> of the
              nonnegative integers less than <var>len</var>, such that for every nonnegative integer <var>j</var> less than
              <var>len</var>, if property <span style="font-family: Times New Roman">old[<i>j</i>]</span> existed, then <span style="font-family: Times New Roman">new[&pi;(<i>j</i>)]</span> is exactly the same value as <span style="font-family: Times New Roman">old[<i>j</i>]</span>. But if property <span style="font-family: Times New               Roman">old[<i>j</i>]</span> did not exist, then <span style="font-family: Times New               Roman">new[&pi;(<i>j</i>)]</span> does not exist.</p>
            </li>

            <li>
              <p>Then for all nonnegative integers <var>j</var> and <var>k</var>, each less than <var>len</var>, if <span style="font-family: Times New Roman"><a href="#sec-sortcompare">SortCompare</a>(old[<i>j</i>], old[<i>k</i>]) &lt;
              0</span> (see <a href="#sec-sortcompare">SortCompare</a> below), then <span style="font-family: Times New               Roman">new[<b>&pi;</b>(<i>j</i>)] &lt;</span> <span style="font-family: Times New               Roman">new[<b>&pi;</b>(<i>k</i>)]</span>.</p>
            </li>
          </ul>

          <p>Here the notation <span style="font-family: Times New Roman">old[<i>j</i>]</span> is used to refer to the
          hypothetical result of calling the [[Get]] internal method of <var>obj</var> with argument <var>j</var> before this
          function is executed, and the notation <span style="font-family: Times New Roman">new[<i>j</i>]</span> to refer to the
          hypothetical result of calling the [[Get]] internal method of <var>obj</var> with argument <var>j</var> after this
          function has been executed.</p>

          <p class="normalbefore">A function <var>comparefn</var> is a consistent comparison function for a set of values
          <var>S</var> if all of the requirements below are met for all values <var>a</var>, <var>b</var>, and <var>c</var>
          (possibly the same value) in the set <var>S</var>: The notation <span style="font-family: Times New           Roman"><i>a</i>&nbsp;&lt;<sub>CF</sub></span>&nbsp;<var>b</var> means <span style="font-family: Times New           Roman"><i>comparefn</i>(<i>a</i>,<i>b</i>)&nbsp;&lt;&nbsp;0</span>; <span style="font-family: Times New           Roman"><i>a</i>&nbsp;=<sub>CF</sub></span>&nbsp;<var>b</var> means <span style="font-family: Times New           Roman"><i>comparefn</i>(<i>a</i>,<i>b</i>)&nbsp;=&nbsp;0</span> (of either sign); and <span style="font-family: Times           New Roman"><i>a</i>&nbsp;&gt;<sub>CF</sub></span>&nbsp;<var>b</var> means <span style="font-family: Times New           Roman"><i>comparefn</i>(<i>a</i>,<i>b</i>)&nbsp;&gt;&nbsp;0</span>.</p>

          <ul>
            <li>
              <p>Calling <i>comparefn</i>(<i>a</i>,<i>b</i>) always returns the same value <i>v</i> when given a specific pair of
              values <i>a</i> and <i>b</i> as its two arguments. Furthermore, <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>v</i>) is Number, and <i>v</i> is not NaN. Note that this
              implies that exactly one of <i>a</i>&nbsp;&lt;<sub>CF</sub><span style="font-family:               sans-serif" />&nbsp;<i>b</i>, <i>a</i>&nbsp;=<sub>CF</sub><span style="font-family:               sans-serif" />&nbsp;<i>b</i>, and <i>a</i>&nbsp;&gt;<sub>CF</sub><span style="font-family:               sans-serif" />&nbsp;<i>b</i> will be true for a given pair of <i>a</i> and <i>b</i>.</p>
            </li>

            <li>
              <p>Calling <i>comparefn</i>(<i>a</i>,<i>b</i>) does not modify <i>obj</i> or any object on <i>obj</i>&rsquo;s
              prototype chain.</p>
            </li>

            <li>
              <p><i>a</i>&nbsp;=<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>a</i>   (reflexivity)</p>
            </li>

            <li>
              <p>If <i>a</i>&nbsp;=<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>b</i>, then
              <i>b</i>&nbsp;=<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>a</i>   (symmetry)</p>
            </li>

            <li>
              <p>If <i>a</i>&nbsp;=<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>b</i> and
              <i>b</i>&nbsp;=<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>c</i>, then
              <i>a</i>&nbsp;=<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>c</i>   (transitivity of
              =<sub>CF</sub>)</p>
            </li>

            <li>
              <p>If <i>a</i>&nbsp;&lt;<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>b</i> and
              <i>b</i>&nbsp;&lt;<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>c</i>, then
              <i>a</i>&nbsp;&lt;<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>c</i>   (transitivity of
              &lt;<sub>CF</sub>)</p>
            </li>

            <li>
              <p>If <i>a</i>&nbsp;&gt;<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>b</i> and
              <i>b</i>&nbsp;&gt;<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>c</i>, then
              <i>a</i>&nbsp;&gt;<sub>CF</sub><span style="font-family: sans-serif" />&nbsp;<i>c</i>   (transitivity of
              &gt;<sub>CF</sub>)</p>
            </li>
          </ul>

          <div class="note">
            <p><span class="nh">NOTE 1</span> The above conditions are necessary and sufficient to ensure that
            <var>comparefn</var> divides the set <var>S</var> into equivalence classes and that these equivalence classes are
            totally ordered.</p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 2</span> The <code>sort</code> function is intentionally generic; it does not require that
            its <b>this</b> value be an Array object. Therefore, it can be transferred to other kinds of objects for use as a
            method.</p>
          </div>
        </div>

        <section id="sec-sortcompare">
          <h5 id="sec-22.1.3.24.1" title="22.1.3.24.1"> Runtime Semantics: SortCompare( x, y )</h5><p class="normalbefore">The SortCompare abstract operation is called with two arguments <var>x</var> and <var>y</var>.
          It also has access to the <var>comparefn</var> argument passed to the current invocation of the <code>sort</code>
          method. The following steps are taken:</p>

          <ol class="proc">
            <li>If <i>x</i> and <i>y</i> are both <b>undefined</b>, return +0.</li>
            <li>If <i>x</i> is <b>undefined</b>, return 1.</li>
            <li>If <i>y</i> is <b>undefined</b>, return &minus;1.</li>
            <li>If the argument <i>comparefn</i> is not <b>undefined</b>, then
              <ol class="block">
                <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>comparefn</i>,
                    <b>undefined</b>, &laquo;<i>x</i>, <i>y</i>&raquo;)).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
                <li>If <i>v</i> is <b>NaN</b>, return +0.</li>
                <li>Return <i>v</i>.</li>
              </ol>
            </li>
            <li>Let <i>xString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>x</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>xString</i>).</li>
            <li>Let <i>yString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>y</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>yString</i>).</li>
            <li>If <i>xString</i> &lt; <i>yString</i>, return &minus;1.</li>
            <li>If <i>xString</i> &gt; <i>yString</i>, return 1.</li>
            <li>Return +0.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE 1</span> Because non-existent property values always compare greater than <b>undefined</b>
            property values, and <b>undefined</b> always compares greater than any other value, <b>undefined</b> property values
            always sort to the end of the result, followed by non-existent property values.</p>
          </div>

          <div class="note">
            <p><span class="nh">NOTE 2</span> Method calls performed by the <a href="sec-abstract-operations#sec-tostring">ToString</a> abstract
            operations in steps 5 and 7 have the potential to cause SortCompare to not behave as a consistent comparison
            function.</p>
          </div>
        </section>
      </section>

      <section id="sec-array.prototype.splice">
        <h4 id="sec-22.1.3.25" title="22.1.3.25"> Array.prototype.splice (start, deleteCount , ...items  )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> When the <code>splice</code> method is called with two or more arguments
          <var>start</var>, <var>deleteCount</var> and zero or more <var>items</var>, the <var>deleteCount</var> elements of the
          array starting at integer index <var>start</var> are replaced by the arguments <var>items</var>. An Array object
          containing the deleted elements (if any) is returned.</p>
        </div>

        <p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Let <i>relativeStart</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>start</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeStart</i>).</li>
          <li>If <i>relativeStart</i> &lt; 0, let <i>actualStart</i> be max((<i>len</i> + <i>relativeStart</i>),0); else let
              <i>actualStart</i> be min(<i>relativeStart</i>, <i>len</i>).</li>
          <li>If  the number of actual arguments is 0, then
            <ol class="block">
              <li>Let <i>insertCount</i> be 0.</li>
              <li>Let <i>actualDeleteCount</i> be 0.</li>
            </ol>
          </li>
          <li>Else if the number of actual arguments is 1, then
            <ol class="block">
              <li>Let <i>insertCount</i> be 0.</li>
              <li>Let <i>actualDeleteCount</i> be <i>len</i> &ndash; <i>actualStart</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>insertCount</i> be the number of actual arguments minus 2.</li>
              <li>Let <i>dc</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>deleteCount</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>dc</i>).</li>
              <li>Let <i>actualDeleteCount</i> be min(max(<i>dc</i>,0), <i>len</i> &ndash; <i>actualStart</i>).</li>
            </ol>
          </li>
          <li>If <i>len+insertCount</i>&minus;<i>actualDeleteCount</i> &gt; 2<sup>53</sup>-1, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>A</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-arrayspeciescreate">ArraySpeciesCreate</a>(<i>O</i>, <i>actualDeleteCount</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>actualDeleteCount</i>
            <ol class="block">
              <li>Let <i>from</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>actualStart</i>+<i>k</i>).</li>
              <li>Let <i>fromPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>from</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromPresent</i>).</li>
              <li>If <i>fromPresent</i> is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>fromValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O,</i> <i>from</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromValue</i>).</li>
                  <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdatapropertyorthrow">CreateDataPropertyOrThrow</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>), <i>fromValue</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                </ol>
              </li>
              <li>Increment <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>A</i>, <code>"length"</code>,
              <i>actualDeleteCount</i>, <b>true</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
          <li>Let <i>items</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose elements are, in left to
              right order, the portion of the actual argument list starting with the third argument. The list is empty if fewer
              than three arguments were passed.</li>
          <li>Let <i>itemCount</i> be the number of elements in <i>items</i>.</li>
          <li>If <i>itemCount</i> &lt; <i>actualDeleteCount</i>, then
            <ol class="block">
              <li>Let <i>k</i> be <i>actualStart</i>.</li>
              <li>Repeat, while <i>k</i> &lt; (<i>len</i> &ndash; <i>actualDeleteCount</i>)
                <ol class="block">
                  <li>Let <i>from</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>+<i>actualDeleteCount</i>).</li>
                  <li>Let <i>to</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>+<i>itemCount</i>).</li>
                  <li>Let <i>fromPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>from</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromPresent</i>).</li>
                  <li>If <i>fromPresent</i> is <b>true</b>, then
                    <ol class="block">
                      <li>Let <i>fromValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>from</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromValue</i>).</li>
                      <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <i>to</i>, <i>fromValue</i>,
                          <b>true</b>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                    </ol>
                  </li>
                  <li>Else <i>fromPresent</i> is <b>false</b>,
                    <ol class="block">
                      <li>Let <i>deleteStatus</i> be <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a>(<i>O</i>,
                          <i>to</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
                    </ol>
                  </li>
                  <li>Increase <i>k</i> by 1.</li>
                </ol>
              </li>
              <li>Let <i>k</i> be <i>len</i>.</li>
              <li>Repeat, while <i>k</i> &gt; (<i>len</i> &ndash; <i>actualDeleteCount</i> + <i>itemCount</i>)
                <ol class="block">
                  <li>Let <i>deleteStatus</i> be <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a>(<i>O</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>&ndash;1)).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
                  <li>Decrease <i>k</i> by 1.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Else if <i>itemCount</i> &gt; <i>actualDeleteCount</i>, then
            <ol class="block">
              <li>Let <i>k</i> be (<i>len</i> &ndash; <i>actualDeleteCount</i>).</li>
              <li>Repeat, while <i>k</i> &gt; <i>actualStart</i>
                <ol class="block">
                  <li>Let <i>from</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i> + <i>actualDeleteCount</i> &ndash; 1).</li>
                  <li>Let <i>to</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i> + <i>itemCount</i> &ndash; 1)</li>
                  <li>Let <i>fromPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>from</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromPresent</i>).</li>
                  <li>If <i>fromPresent</i> is <b>true</b>, then
                    <ol class="block">
                      <li>Let <i>fromValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>from</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromValue</i>).</li>
                      <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <i>to</i>, <i>fromValue</i>,
                          <b>true</b>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                    </ol>
                  </li>
                  <li>Else <i>fromPresent</i> is <b>false</b>,
                    <ol class="block">
                      <li>Let <i>deleteStatus</i> be <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a>(<i>O</i>,
                          <i>to</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
                    </ol>
                  </li>
                  <li>Decrease <i>k</i> by 1.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>k</i> be <i>actualStart</i>.</li>
          <li>Repeat, while <i>items</i> is not empty
            <ol class="block">
              <li>Remove the first element from <i>items</i> and let <i>E</i> be the value of that element.</li>
              <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>), <i>E</i>, <b>true</b>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <code>"length"</code>, <i>len</i> &ndash;
              <i>actualDeleteCount</i> + <i>itemCount</i>, <b>true</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
          <li>Return <i>A</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>splice</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The explicit setting of the <code>length</code> property of the result Array in step
          24 is necessary to ensure that its value is correct in situations where its trailing elements are not present.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> The <code>splice</code> function is intentionally generic; it does not require that
          its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.tolocalestring">
        <h4 id="sec-22.1.3.26" title="22.1.3.26"> Array.prototype.toLocaleString ( [ reserved1 [ , reserved2 ] ]
            )</h4><p>An ECMAScript implementation that includes the ECMA-402 Internationalization API must implement the
        <code>Array.prototype.toLocaleString</code> method as specified in the ECMA-402 specification. If an ECMAScript
        implementation does not include the ECMA-402 API the following specification of the <code>toLocaleString</code> method is
        used.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The first edition of ECMA-402 did not include a replacement specification for the
          <code>Array.prototype.toLocaleString</code> method.</p>
        </div>

        <p>The meanings of the optional parameters to this method are defined in the ECMA-402 specification; implementations that
        do not include ECMA-402 support must not use those parameter positions for anything else.</p>

        <p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>array</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>array</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>array</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Let <i>separator</i> be the String value for the list-separator String appropriate for the host environment&rsquo;s
              current locale (this is derived in an implementation-defined way).</li>
          <li>If <i>len</i> is zero, return the empty String.</li>
          <li>Let <i>firstElement</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>array</i>, <code>"0"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>firstElement</i>).</li>
          <li>If <i>firstElement</i> is <b>undefined</b> or <b>null</b>, then
            <ol class="block">
              <li>Let <i>R</i> be the empty String.</li>
            </ol>
          </li>
          <li>Else
            <ol class="block">
              <li>Let <i>R</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>firstElement</i>,
                  <code>"toLocaleString"</code>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>R</i>).</li>
            </ol>
          </li>
          <li>Let <i>k</i> be <code>1</code>.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>S</i> be a String value produced by concatenating <i>R</i> and <i>separator</i>.</li>
              <li>Let <i>nextElement</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>array</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextElement</i>).</li>
              <li>If <i>nextElement</i> is <b>undefined</b> or <b>null</b>, then
                <ol class="block">
                  <li>Let <i>R</i> be the empty String.</li>
                </ol>
              </li>
              <li>Else
                <ol class="block">
                  <li>Let <i>R</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>nextElement</i>,
                      <code>"toLocaleString"</code>)).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>R</i>).</li>
                </ol>
              </li>
              <li>Let <i>R</i> be a String value produced by concatenating <i>S</i> and <i>R</i>.</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>R</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The elements of the array are converted to Strings using their
          <code>toLocaleString</code> methods, and these Strings are then concatenated, separated by occurrences of a separator
          String that has been derived in an implementation-defined locale-specific way. The result of calling this function is
          intended to be analogous to the result of <code>toString</code>, except that the result of this function is intended to
          be locale-specific.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> The <code>toLocaleString</code> function is intentionally generic; it does not require
          that its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.tostring">
        <h4 id="sec-22.1.3.27" title="22.1.3.27"> Array.prototype.toString ( )</h4><p class="normalbefore">When the <code>toString</code> method is called, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>array</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>array</i>).</li>
          <li>Let <i>func</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>array</i>, <code>"join"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>func</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>func</i>) is <b>false</b>, let <i>func</i> be the intrinsic function
              %ObjProto_toString% (<a href="sec-fundamental-objects#sec-object.prototype.tostring">19.1.3.6</a>).</li>
          <li>Return  <a href="sec-abstract-operations#sec-call">Call</a>(<i>func</i>, <i>array</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The <code>toString</code> function is intentionally generic; it does not require that
          its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.unshift">
        <h4 id="sec-22.1.3.28" title="22.1.3.28"> Array.prototype.unshift ( ...items )</h4><div class="note">
          <p><span class="nh">NOTE 1</span> The arguments are prepended to the start of the array, such that their order within
          the array is the same as the order in which they appear in the argument list.</p>
        </div>

        <p class="normalbefore">When the <code>unshift</code> method is called with zero or more arguments <var>item1</var>,
        <var>item2</var>, etc., the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Let <i>argCount</i> be the number of actual arguments.</li>
          <li>If <i>argCount</i> &gt; 0, then
            <ol class="block">
              <li>If <i>len</i>+ <i>argCount</i> &gt; 2<sup>53</sup>-1, throw a <b>TypeError</b> exception.</li>
              <li>Let <i>k</i> be <i>len</i>.</li>
              <li>Repeat, while <i>k</i> &gt; 0,
                <ol class="block">
                  <li>Let <i>from</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>&ndash;1).</li>
                  <li>Let <i>to</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>+<i>argCount</i> &ndash;1).</li>
                  <li>Let <i>fromPresent</i> be <a href="sec-abstract-operations#sec-hasproperty">HasProperty</a>(<i>O</i>, <i>from</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromPresent</i>).</li>
                  <li>If <i>fromPresent</i> is <b>true</b>, then
                    <ol class="block">
                      <li>Let <i>fromValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>from</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>fromValue</i>).</li>
                      <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <i>to</i>, <i>fromValue</i>,
                          <b>true</b>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                    </ol>
                  </li>
                  <li>Else <i>fromPresent</i> is <b>false</b>,
                    <ol class="block">
                      <li>Let <i>deleteStatus</i> be <a href="sec-abstract-operations#sec-deletepropertyorthrow">DeletePropertyOrThrow</a>(<i>O</i>,
                          <i>to</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>deleteStatus</i>).</li>
                    </ol>
                  </li>
                  <li>Decrease <i>k</i> by 1.</li>
                </ol>
              </li>
              <li>Let <i>j</i> be 0.</li>
              <li>Let <i>items</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> whose elements are, in left to
                  right order, the arguments that were passed to this function invocation.</li>
              <li>Repeat, while <i>items</i> is not empty
                <ol class="block">
                  <li>Remove the first element from <i>items</i> and let <i>E</i> be the value of that element.</li>
                  <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>j</i>), <i>E</i>, <b>true</b>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                  <li>Increase <i>j</i> by 1.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>O</i>, <code>"length"</code>,
              <i>len</i>+<i>argCount</i>, <b>true</b>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
          <li>Return <i>len</i>+<i>argCount</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>unshift</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The <code>unshift</code> function is intentionally generic; it does not require that
          its <b>this</b> value be an Array object. Therefore it can be transferred to other kinds of objects for use as a
          method.</p>
        </div>
      </section>

      <section id="sec-array.prototype.values">
        <h4 id="sec-22.1.3.29" title="22.1.3.29"> Array.prototype.values ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Return <a href="#sec-createarrayiterator">CreateArrayIterator</a>(<i>O</i>, <code>"value"</code>).</li>
        </ol>

        <p>This function is the %ArrayProto_values% intrinsic object.</p>
      </section>

      <section id="sec-array.prototype-@@iterator">
        <h4 id="sec-22.1.3.30" title="22.1.3.30"> Array.prototype [ @@iterator ]  ( )</h4><p>The initial value of the @@iterator property is the same function object as the initial value of the <b><a href="#sec-array.prototype.values">Array.prototype.values</a></b> property.</p>
      </section>

      <section id="sec-array.prototype-@@unscopables">
        <h4 id="sec-22.1.3.31" title="22.1.3.31"> Array.prototype [ @@unscopables ]</h4><p class="normalbefore">The initial value of the @@unscopables data property is an object created by the following
        steps:</p>

        <ol class="proc">
          <li>Let <i>blackList</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<b>null</b>).</li>
          <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>blackList</i>, <code>"copyWithin"</code>,
              <b>true</b>).</li>
          <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>blackList</i>, <code>"entries"</code>,
              <b>true</b>).</li>
          <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>blackList</i>, <code>"fill"</code>,
              <b>true</b>).</li>
          <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>blackList</i>, <code>"find"</code>,
              <b>true</b>).</li>
          <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>blackList</i>, <code>"findIndex"</code>,
              <b>true</b>).</li>
          <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>blackList</i>, <code>"keys"</code>,
              <b>true</b>).</li>
          <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>blackList</i>, <code>"values"</code>,
              <b>true</b>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: Each of the above calls will return <b>true</b>.</li>
          <li>Return <i>blackList</i>.</li>
        </ol>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <span class="value">false</span>,
        [[Configurable]]: <span class="value">true</span> }.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The own property names of this object are property names that were not included as
          standard properties of <code>Array.prototype</code> prior to the ECMAScript 2015 specification. These names are ignored
          for <code>with</code> statement binding purposes in order to preserve the behaviour of existing code that might use one
          of these names as a binding in an outer scope that is shadowed by a <code>with</code> statement whose binding object is
          an Array object.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-array-instances">
      <div class="front">
        <h3 id="sec-22.1.4" title="22.1.4"> Properties of Array Instances</h3><p>Array instances are Array exotic objects and have the internal methods specified for such objects. Array instances
        inherit properties from the Array prototype object.</p>

        <p>Array instances have a <code>length</code> property, and a set of enumerable properties with array index names.</p>
      </div>

      <section id="sec-properties-of-array-instances-length">
        <h4 id="sec-22.1.4.1" title="22.1.4.1"> length</h4><p>The <code>length</code> property of an Array instance is a data property whose value is always numerically greater than
        the name of every configurable own property whose name is an array index.</p>

        <p>The <code>length</code> property initially has the attributes <span style="font-family: Times New Roman">{
        [[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>false</b> }</span>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Reducing the value of the <code>length</code> property has the side-effect of deleting
          own array elements whose array index is between the old and new length values. However, non-configurable properties can
          not be deleted. Attempting to set the length property of an Array object to a value that is numerically less than or
          equal to the largest numeric own property name of an existing non-configurable array indexed property of the array will
          result in the length being set to a numeric value that is one greater than that non-configurable numeric own property
          name. See <a href="sec-ordinary-and-exotic-objects-behaviours#sec-array-exotic-objects-defineownproperty-p-desc">9.4.2.1</a>.</p>
        </div>
      </section>
    </section>

    <section id="sec-array-iterator-objects">
      <div class="front">
        <h3 id="sec-22.1.5" title="22.1.5"> Array Iterator Objects</h3><p>An Array Iterator is an object, that represents a specific iteration over some specific Array instance object. There is
        not a named constructor for Array Iterator objects. Instead, Array iterator objects are created by calling certain methods
        of Array instance objects.</p>
      </div>

      <section id="sec-createarrayiterator">
        <h4 id="sec-22.1.5.1" title="22.1.5.1"> CreateArrayIterator Abstract Operation</h4><p class="normalbefore">Several methods of Array objects return Iterator objects. The abstract operation
        CreateArrayIterator with arguments <var>array</var> and <var>kind</var> is used to create such iterator objects. It
        performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>array</i>) is Object.</li>
          <li>Let <i>iterator</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(%ArrayIteratorPrototype%,
              &laquo;&zwj;[[IteratedObject]], [[ArrayIteratorNextIndex]], [[ArrayIterationKind]]&raquo;).</li>
          <li>Set <i>iterator&rsquo;s</i> [[IteratedObject]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>array</i>.</li>
          <li>Set <i>iterator&rsquo;s</i> [[ArrayIteratorNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to 0.</li>
          <li>Set <i>iterator&rsquo;s</i> [[ArrayIterationKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <i>kind</i>.</li>
          <li>Return <i>iterator</i>.</li>
        </ol>
      </section>

      <section id="sec-%arrayiteratorprototype%-object">
        <div class="front">
          <h4 id="sec-22.1.5.2" title="22.1.5.2"> The %ArrayIteratorPrototype% Object</h4><p>All Array Iterator Objects inherit properties from the %ArrayIteratorPrototype% intrinsic object. The
          %ArrayIteratorPrototype% object is an ordinary object and its [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is the %IteratorPrototype% intrinsic object (<a href="sec-control-abstraction-objects#sec-%iteratorprototype%-object">25.1.2</a>). In addition, %ArrayIteratorPrototype% has the following
          properties:</p>
        </div>

        <section id="sec-%arrayiteratorprototype%.next">
          <h5 id="sec-22.1.5.2.1" title="22.1.5.2.1"> %ArrayIteratorPrototype%.next( )</h5><ol class="proc">
            <li>Let <i>O</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>If <i>O</i> does not have all of the internal slots of an Array Iterator Instance (<a href="#sec-properties-of-array-iterator-instances">22.1.5.3</a>), throw a <b>TypeError</b> exception.</li>
            <li>Let <i>a</i> be the value of the [[IteratedObject]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
            <li>If <i>a</i> is <b>undefined</b>, return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>true</b>).</li>
            <li>Let <i>index</i> be the value of the [[ArrayIteratorNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
            <li>Let <i>itemKind</i> be the value of the [[ArrayIterationKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
            <li>If <i>a</i> has a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
                then
              <ol class="block">
                <li>Let <i>len</i> be the value of <i>O</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>a</i>,
                    <code>"length"</code>)).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
              </ol>
            </li>
            <li>If <i>index</i> &ge; <i>len</i>, then
              <ol class="block">
                <li>Set the value of the [[IteratedObject]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                    slot</a> of <i>O</i> to <b>undefined</b>.</li>
                <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>true</b>).</li>
              </ol>
            </li>
            <li>Set the value of the [[ArrayIteratorNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                slot</a> of <i>O</i> to <i>index</i>+1.</li>
            <li>If <i>itemKind</i> is <b>"<code>key</code>"</b>, return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<i>index</i>, <b>false</b>).</li>
            <li>Let <i>elementKey</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>index</i>).</li>
            <li>Let <i>elementValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>a</i>, <i>elementKey</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>elementValue</i>).</li>
            <li>If <i>itemKind</i> is <b>"<code>value</code>"</b>, let <i>result</i> be <i>elementValue</i>.</li>
            <li>Else,
              <ol class="block">
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>itemKind</i> is <b>"<code>key+value</code>"</b>.</li>
                <li>Let <i>result</i> be <a href="sec-abstract-operations#sec-createarrayfromlist">CreateArrayFromList</a>(&laquo;<i>index</i>,
                    <i>elementValue</i>&raquo;).</li>
              </ol>
            </li>
            <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<i>result</i>, <b>false</b>).</li>
          </ol>
        </section>

        <section id="sec-%arrayiteratorprototype%-@@tostringtag">
          <h5 id="sec-22.1.5.2.2" title="22.1.5.2.2"> %ArrayIteratorPrototype% [ @@toStringTag ]</h5><p>The initial value of the @@toStringTag property is the String value <code>"Array Iterator"</code>.</p>

          <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
        </section>
      </section>

      <section id="sec-properties-of-array-iterator-instances">
        <h4 id="sec-22.1.5.3" title="22.1.5.3"> Properties of Array Iterator Instances</h4><p>Array Iterator instances are ordinary objects that inherit properties from the %ArrayIteratorPrototype% intrinsic
        object. Array Iterator instances are initially created with the internal slots listed in <a href="#table-48">Table
        48</a>.</p>

        <figure>
          <figcaption><span id="table-48">Table 48</span> &mdash; Internal Slots of Array Iterator Instances</figcaption>
          <table class="real-table">
            <tr>
              <th>Internal Slot</th>
              <th>Description</th>
            </tr>
            <tr>
              <td>[[IteratedObject]]</td>
              <td>The object whose array elements are being iterated.</td>
            </tr>
            <tr>
              <td>[[ArrayIteratorNextIndex]]</td>
              <td>The integer index of the next integer index to be examined by this iteration.</td>
            </tr>
            <tr>
              <td>[[ArrayIterationKind]]</td>
              <td>A String value that identifies what is returned for each element of the iteration. The possible values are: <code>"key"</code>, <code>"value"</code>, <code>"key+value"</code>.</td>
            </tr>
          </table>
        </figure>
      </section>
    </section>
  </section>

  <section id="sec-typedarray-objects">
    <div class="front">
      <h2 id="sec-22.2" title="22.2">
          TypedArray Objects</h2><p><i>TypedArray</i> objects present an array-like view of an underlying binary data buffer (<a href="sec-structured-data#sec-arraybuffer-objects">24.1</a>). Each element of a <i>TypedArray</i> instance has the same underlying binary
      scalar data type. There is a distinct <i>TypedArray</i> constructor, listed in <a href="#table-49">Table 49</a>, for each of
      the nine supported element types. Each constructor in <a href="#table-49">Table 49</a>  has a corresponding distinct
      prototype object.</p>

      <figure>
        <figcaption><span id="table-49">Table 49</span> &ndash; The <i>TypedArray</i> Constructors</figcaption>
        <table class="real-table">
          <tr>
            <th style="background-color: #BFBFBF">Constructor Name and Intrinsic</th>
            <th style="background-color: #BFBFBF">Element Type</th>
            <th style="background-color: #BFBFBF">Element Size</th>
            <th style="background-color: #BFBFBF">Conversion Operation</th>
            <th style="background-color: #BFBFBF">Description</th>
            <th style="background-color: #BFBFBF">Equivalent C Type</th>
          </tr>
          <tr>
            <td><a href="sec-global-object#sec-int8array">Int8Array</a><br />%Int8Array%</td>
            <td>Int8</td>
            <td>1</td>
            <td><a href="sec-abstract-operations#sec-toint8">ToInt8</a></td>
            <td>8-bit 2&rsquo;s complement signed integer</td>
            <td>signed char</td>
          </tr>
          <tr>
            <td><a href="sec-global-object#sec-uint8array">Uint8Array</a> <br />%Uint8Array%</td>
            <td>Uint8</td>
            <td>1</td>
            <td><a href="sec-abstract-operations#sec-touint8">ToUint8</a></td>
            <td>8-bit unsigned integer</td>
            <td>unsigned char</td>
          </tr>
          <tr>
            <td><a href="sec-global-object#sec-uint8clampedarray">Uint8ClampedArray</a><br />%Uint8ClampedArray%</td>
            <td>Uint8C</td>
            <td>1</td>
            <td><a href="sec-abstract-operations#sec-touint8clamp">ToUint8Clamp</a></td>
            <td>8-bit unsigned integer (clamped conversion)</td>
            <td>unsigned char</td>
          </tr>
          <tr>
            <td><a href="sec-global-object#sec-int16array">Int16Array</a> <br />%Int16Array%</td>
            <td>Int16</td>
            <td>2</td>
            <td><a href="sec-abstract-operations#sec-toint16">ToInt16</a></td>
            <td>16-bit 2&rsquo;s complement signed integer</td>
            <td>short</td>
          </tr>
          <tr>
            <td><a href="sec-global-object#sec-uint16array">Uint16Array</a> <br />%Uint16Array%</td>
            <td>Uint16</td>
            <td>2</td>
            <td><a href="sec-abstract-operations#sec-touint16">ToUint16</a></td>
            <td>16-bit unsigned integer</td>
            <td>unsigned short</td>
          </tr>
          <tr>
            <td><a href="sec-global-object#sec-int32array">Int32Array</a> <br />%Int32Array%</td>
            <td>Int32</td>
            <td>4</td>
            <td><a href="sec-abstract-operations#sec-toint32">ToInt32</a></td>
            <td>32-bit 2&rsquo;s complement signed integer</td>
            <td>int</td>
          </tr>
          <tr>
            <td><a href="sec-global-object#sec-uint32array">Uint32Array</a> <br />%Uint32Array%</td>
            <td>Uint32</td>
            <td>4</td>
            <td><a href="sec-abstract-operations#sec-touint32">ToUint32</a></td>
            <td>32-bit unsigned integer</td>
            <td>unsigned int</td>
          </tr>
          <tr>
            <td><a href="sec-global-object#sec-float32array">Float32Array</a> <br />%Float32Array%</td>
            <td>Float32</td>
            <td>4</td>
            <td />
            <td>32-bit IEEE floating point</td>
            <td>float</td>
          </tr>
          <tr>
            <td><a href="sec-global-object#sec-float64array">Float64Array</a> <br />%Float64Array%</td>
            <td>Float64</td>
            <td>8</td>
            <td />
            <td>64-bit IEEE floating point</td>
            <td>double</td>
          </tr>
        </table>
      </figure>

      <p>In the definitions below, references to <i>TypedArray</i> should be replaced with the appropriate constructor name from
      the above table. The phrase &ldquo;the element size in bytes&rdquo; refers to the value in the Element Size column of the
      table in the row corresponding to the constructor. The phrase &ldquo;element Type&rdquo; refers to the value in the Element
      Type column for that row.</p>
    </div>

    <section id="sec-%typedarray%-intrinsic-object">
      <div class="front">
        <h3 id="sec-22.2.1" title="22.2.1"> The %TypedArray% Intrinsic Object</h3><p>The %TypedArray% intrinsic object is a constructor function object that all of the <i>TypedArray</i> constructor object
        inherit from. %TypedArray% and its corresponding prototype object provide common properties that are inherited by all
        <i>TypedArray</i> constructors and their instances. The %TypedArray% intrinsic does not have a global name or appear as a
        property of the global object.</p>

        <p>The %TypedArray% intrinsic function object is designed to act as the superclass of the various <i>TypedArray</i>
        constructors. Those constructors use %TypedArray% to initialize their instances by invoking %TypedArray% as if by making a
        <code>super</code> call. The %TypedArray% intrinsic function is not designed to be directly called in any other way. If
        %TypedArray% is directly called or called as part of a <code>new</code> expression an exception is thrown.</p>

        <p>The %TypedArray% intrinsic constructor function is a single function whose behaviour is overloaded based upon the
        number and types of its arguments. The actual behaviour of a <code>super</code> call of %TypedArray% depends upon the
        number and kind of arguments that are passed to it.</p>
      </div>

      <section id="sec-%typedarray%-intrinsic-object-%typedarray%">
        <h4 id="sec-22.2.1.1" title="22.2.1.1"> %TypedArray% ( )</h4><p>This description applies only if the %TypedArray% function is called with no arguments.</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Return <a href="#sec-allocatetypedarray">AllocateTypedArray</a>(NewTarget, 0).</li>
        </ol>
      </section>

      <section id="sec-%typedarray%-length">
        <div class="front">
          <h4 id="sec-22.2.1.2" title="22.2.1.2"> %TypedArray% ( length )</h4><p>This description applies only if the %TypedArray% function is called with at least one argument and the Type of the
          first argument is not Object.</p>

          <p class="normalbefore">%TypedArray% called with argument <var>length</var> performs the following steps:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>length</i>) is not Object.</li>
            <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
            <li>If <i>length</i> is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
            <li>Let <i>numberLength</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>length</i>).</li>
            <li>Let <i>elementLength</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<i>numberLength</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>elementLength</i>).</li>
            <li>If <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a>(<i>numberLength</i>, <i>elementLength</i>) is <b>false</b>,
                throw a <b>RangeError</b> exception.</li>
            <li>Return <a href="#sec-allocatetypedarray">AllocateTypedArray</a>(NewTarget, <i>elementLength</i>).</li>
          </ol>
        </div>

        <section id="sec-allocatetypedarray">
          <h5 id="sec-22.2.1.2.1" title="22.2.1.2.1"> Runtime Semantics: AllocateTypedArray (newTarget, length )</h5><p class="normalbefore">The abstract operation AllocateTypedArray with argument <var>newTarget</var> and optional
          argument <var>length</var> is used to validate and create an instance of a TypedArray constructor. If the
          <var>length</var> argument is passed an ArrayBuffer of that length is also allocated and associated with the new
          TypedArray instance. AllocateTypedArray provides common semantics that is used by all of the %TypeArray% overloads and
          other methods. AllocateTypedArray performs the following steps:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>newTarget</i>)
                is <b>true</b>.</li>
            <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(%TypedArray%, <i>newTarget</i>) is <b>true</b>, throw a <b>TypeError</b>
                exception.</li>
            <li>NOTE <span style="font-family: Times New Roman">%TypedArray%</span> throws an exception when invoked via either a
                function call or the <code>new</code> operator. It can only be successfully invoked by a <span class="nt">SuperCall</span>.</li>
            <li>Let <i>constructorName</i> be <b>undefined</b>.</li>
            <li>Let <i>subclass</i> be <i>newTarget</i>.</li>
            <li>Repeat while <i>constructorName</i> is <b>undefined</b>
              <ol class="block">
                <li>If <i>subclass</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
                <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(%TypedArray%, <i>subclass</i>) is <b>true</b>, throw a
                    <b>TypeError</b> exception.</li>
                <li>If <i>subclass</i> has a [[TypedArrayConstructorName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, let <i>constructorName</i> be the
                    value of <i>subclass</i>&rsquo;s [[TypedArrayConstructorName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
                <li>Let <i>subclass</i> be <i>subclass</i>.[[GetPrototypeOf]]().</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>subclass</i>).</li>
              </ol>
            </li>
            <li>Let <i>proto</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-getprototypefromconstructor">GetPrototypeFromConstructor</a>(<i>newTarget</i>,
                <code>"%TypedArrayPrototype%"</code>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>proto</i>).</li>
            <li>Let <i>obj</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-integerindexedobjectcreate">IntegerIndexedObjectCreate</a> (<i>proto</i>,
                &laquo;&zwj;[[ViewedArrayBuffer]], [[TypedArrayName]], [[ByteLength]], [[ByteOffset]], [[ArrayLength]]&raquo;
                ).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  The [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i> is <b>undefined</b>.</li>
            <li>Set <i>obj</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                slot</a> to <i>constructorName</i>.</li>
            <li>If <i>length</i> was not passed, then
              <ol class="block">
                <li>Set <i>obj</i>&rsquo;s [[ByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                    slot</a>  to 0.</li>
                <li>Set <i>obj</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                    slot</a> to 0.</li>
                <li>Set <i>obj</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                    slot</a> to 0.</li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Let <i>elementSize</i> be the Element Size value in <a href="#table-49">Table 49</a> for
                    <i>constructorName</i>.</li>
                <li>Let <i>byteLength</i> be <i>elementSize</i> &times; <i>length</i>.</li>
                <li>Let <i>data</i> be <a href="sec-structured-data#sec-allocatearraybuffer">AllocateArrayBuffer</a>(<span style="font-family:                     sans-serif">%ArrayBuffer%</span>, <i>byteLength</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>data</i>).</li>
                <li>Set <i>obj&rsquo;s</i> [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <i>data</i>.</li>
                <li>Set <i>obj</i>&rsquo;s [[ByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                    slot</a> to <i>byteLength</i>.</li>
                <li>Set <i>obj</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                    slot</a> to 0.</li>
                <li>Set <i>obj</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                    slot</a> to <i>length</i>.</li>
              </ol>
            </li>
            <li>Return <i>obj</i>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-%typedarray%-typedarray">
        <h4 id="sec-22.2.1.3" title="22.2.1.3"> %TypedArray% ( typedArray )</h4><p>This description applies only if the %TypedArray% function is called with at least one argument and the Type of the
        first argument is Object and that object has a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p class="normalbefore">%TypedArray% called with argument <var>typedArray</var> performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>typedArray</i>) is Object and <i>typedArray</i> has a
              [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>O</i> be <a href="#sec-allocatetypedarray">AllocateTypedArray</a>(NewTarget).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>srcArray</i> be <i>typedArray</i>.</li>
          <li>Let <i>srcData</i> be the value of <i>srcArray&rsquo;s</i> [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>srcData</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>constructorName</i> be the String value of <i>O</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>elementType</i> be the String value of the Element Type value in <a href="#table-49">Table 49</a> for
              <i>constructorName</i>.</li>
          <li>Let <i>elementLength</i> be the value of <i>srcArray&rsquo;s</i> [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>srcName</i> be the String value of <i>srcArray&rsquo;s</i> [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>srcType</i> be the String value of the Element Type value in <a href="#table-49">Table 49</a> for
              <i>srcName</i>.</li>
          <li>Let <i>srcElementSize</i> be the Element Size value in <a href="#table-49">Table 49</a> for <i>srcName</i>.</li>
          <li>Let <i>srcByteOffset</i> be the value of <i>srcArray</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>elementSize</i> be the Element Size value in <a href="#table-49">Table 49</a> for
              <i>constructorName</i>.</li>
          <li>Let <i>byteLength</i> be <i>elementSize</i> &times; <i>elementLength</i>.</li>
          <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>elementType</i>,<i>srcType</i>) is <b>true</b>, then
            <ol class="block">
              <li>Let <i>data</i> be <a href="sec-structured-data#sec-clonearraybuffer">CloneArrayBuffer</a>(<i>srcData</i>,
                  <i>srcByteOffset</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>data</i>).</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>bufferConstructor</i> be <a href="sec-abstract-operations#sec-speciesconstructor">SpeciesConstructor</a>(<i>srcData</i>,
                  %ArrayBuffer%).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>bufferConstructor</i>).</li>
              <li>Let <i>data</i> be <a href="sec-structured-data#sec-allocatearraybuffer">AllocateArrayBuffer</a>(<i>bufferConstructor</i>,
                  <i>byteLength</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>data</i>).</li>
              <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>srcData</i>) is <b>true</b>, throw a <b>TypeError</b>
                  exception.</li>
              <li>Let <i>srcByteIndex</i> be <i>srcByteOffset</i>.</li>
              <li>Let <i>targetByteIndex</i> be 0.</li>
              <li>Let <i>count</i> be <i>elementLength</i>.</li>
              <li>Repeat, while <i>count</i> &gt;0
                <ol class="block">
                  <li>Let <i>value</i> be <a href="sec-structured-data#sec-getvaluefrombuffer">GetValueFromBuffer</a>(<i>srcData</i>,
                      <i>srcByteIndex</i>, <i>srcType</i>).</li>
                  <li>Perform <a href="sec-structured-data#sec-setvalueinbuffer">SetValueInBuffer</a>(<i>data</i>, <i>targetByteIndex</i>,
                      <i>elementType</i>, <i>value</i>).</li>
                  <li>Set <i>srcByteIndex</i> to <i>srcByteIndex</i> + <i>srcElementSize</i>.</li>
                  <li>Set <i>targetByteIndex</i> to <i>targetByteIndex</i> + <i>elementSize</i>.</li>
                  <li>Decrement <i>count</i> by 1.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Set <i>O&rsquo;s</i> [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>data</i>.</li>
          <li>Set <i>O</i>&rsquo;s [[ByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <i>byteLength</i>.</li>
          <li>Set <i>O</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              0.</li>
          <li>Set <i>O</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <i>elementLength</i>.</li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>

      <section id="sec-%typedarray%-object">
        <h4 id="sec-22.2.1.4" title="22.2.1.4"> %TypedArray% ( object )</h4><p>This description applies only if the %TypedArray% function is called with at least one argument and the Type of the
        first argument is Object and that object does not have either a [[TypedArrayName]] or an [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p class="normalbefore">%TypedArray% called with argument <var>object</var> performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>object</i>) is Object and <i>object</i> does not have
              either a [[TypedArrayName]] or an [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Return <a href="#sec-typedarrayfrom">TypedArrayFrom</a>(NewTarget, <i>object</i>, <b>undefined</b>,
              <b>undefined</b>).</li>
        </ol>
      </section>

      <section id="sec-%typedarray%-buffer-byteoffset-length">
        <h4 id="sec-22.2.1.5" title="22.2.1.5"> %TypedArray% ( buffer [ , byteOffset [ , length ] ] )</h4><p>This description applies only if the %TypedArray% function is called with at least one argument and the Type of the
        first argument is Object and that object has an [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p class="normalbefore">%TypedArray% called with arguments <span style="font-family: Times New Roman"><i>buffer</i>,
        <i>byteOffset</i>, and <i>length</i></span> performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>buffer</i>) is Object and <i>buffer</i> has an
              [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>O</i> be <a href="#sec-allocatetypedarray">AllocateTypedArray</a>(NewTarget).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>constructorName</i> be the String value of <i>O</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>elementSize</i> be the Number value of the Element Size value in <a href="#table-49">Table 49</a> for
              <i>constructorName</i>.</li>
          <li>Let <i>offset</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>byteOffset</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>offset</i>).</li>
          <li>If <i>offset</i> &lt; 0, throw a <b>RangeError</b> exception.</li>
          <li>If <i>offset</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> <i>elementSize</i> &ne; 0, throw a
              <b>RangeError</b> exception.</li>
          <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>bufferByteLength</i> be the value of <i>buffer&rsquo;s</i> [[ArrayBufferByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>length</i> is <b>undefined</b>, then
            <ol class="block">
              <li>If <i>bufferByteLength</i> <a href="sec-notational-conventions#sec-algorithm-conventions">modulo</a> <i>elementSize</i> &ne; 0, throw a
                  <b>RangeError</b> exception.</li>
              <li>Let <i>newByteLength</i> be <i>bufferByteLength</i> &ndash; <i>offset</i>.</li>
              <li>If <i>newByteLength</i> &lt; 0, throw a <b>RangeError</b> exception.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>newLength</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<i>length</i>)<i>.</i></li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>newLength</i>).</li>
              <li>Let <i>newByteLength</i> be <i>newLength</i> &times; <i>elementSize</i>.</li>
              <li>If <i>offset</i>+<i>newByteLength</i> &gt; <i>bufferByteLength</i>, throw a <b>RangeError</b> exception.</li>
            </ol>
          </li>
          <li>Set <i>O&rsquo;s</i> [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>buffer</i>.</li>
          <li>Set <i>O</i>&rsquo;s [[ByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <i>newByteLength</i>.</li>
          <li>Set <i>O</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <i>offset</i>.</li>
          <li>Set <i>O</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <i>newByteLength /</i> <i>elementSize</i> .</li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-%typedarray%-intrinsic-object">
      <div class="front">
        <h3 id="sec-22.2.2" title="22.2.2"> Properties of the %TypedArray% Intrinsic Object</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
        %TypedArray% is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides a <code>length</code> property whose value is 3 and a <code>name</code> property whose value is
        <code>"TypedArray"</code>, %TypedArray% has the following properties:</p>
      </div>

      <section id="sec-%typedarray%.from">
        <div class="front">
          <h4 id="sec-22.2.2.1" title="22.2.2.1"> %TypedArray%.from ( source [ , mapfn [ , thisArg ] ] )</h4><p class="normalbefore">When the <code>from</code> method is called with  argument <var>source</var>, and optional
          arguments <i>mapfn</i> and <i>thisArg</i>, the following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>C</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>C</i>) is <b>false</b>, throw a <b>TypeError</b>
                exception.</li>
            <li>If <i>mapfn</i> was supplied, let <i>f</i> be <i>mapfn</i>; otherwise let <i>f</i> be <b>undefined</b>.</li>
            <li>If <i>f</i> is not <b>undefined</b>, then
              <ol class="block">
                <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>f</i>) is <b>false</b>, throw a <b>TypeError</b>
                    exception.</li>
              </ol>
            </li>
            <li>If <i>thisArg</i> was supplied, let <i>t</i> be <i>thisArg</i>; else let <i>t</i> be <b>undefined</b>.</li>
            <li>Return <a href="#sec-typedarrayfrom">TypedArrayFrom</a>(<i>C</i>, <i>source</i>, <i>f</i>, <i>t</i>).</li>
          </ol>

          <p>The <code>length</code> property of the <code>from</code> method is <b>1</b>.</p>
        </div>

        <section id="sec-typedarrayfrom">
          <h5 id="sec-22.2.2.1.1" title="22.2.2.1.1"> Runtime Semantics: TypedArrayFrom( constructor, items, mapfn,
              thisArg )</h5><p class="normalbefore">When the TypedArrayFrom abstract operation is called with arguments <span style="font-family:           Times New Roman"><i>constructor</i>, <i>items</i></span>, <var>mapfn</var>, and <var>thisArg</var>, the following steps
          are taken:</p>

          <ol class="proc">
            <li>Let <i>C</i> be <i>constructor</i>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>C</i>) is
                <b>true</b>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>mapfn</i> is either a callable Object or
                <b>undefined</b>.</li>
            <li>If <i>mapfn</i> is <b>undefined</b>, let <i>mapping</i> be <b>false.</b></li>
            <li>Else
              <ol class="block">
                <li>Let <i>T</i> be <i>thisArg</i>.</li>
                <li>Let <i>mapping</i> be <b>true</b></li>
              </ol>
            </li>
            <li>Let <i>usingIterator</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>items</i>, @@iterator).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>usingIterator</i>).</li>
            <li>If <i>usingIterator</i> is not <b>undefined</b>, then
              <ol class="block">
                <li>Let <i>iterator</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>items</i>, <i>usingIterator</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iterator</i>).</li>
                <li>Let <i>values</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
                <li>Let <i>next</i> be <b>true</b>.</li>
                <li>Repeat, while <i>next</i> is not <b>false</b>
                  <ol class="block">
                    <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iterator</i>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
                    <li>If <i>next</i> is not <b>false</b>, then
                      <ol class="block">
                        <li>Let <i>nextValue</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
                        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextValue</i>).</li>
                        <li>Append <i>nextValue</i> to the end of the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>
                            <i>values</i>.</li>
                      </ol>
                    </li>
                  </ol>
                </li>
                <li>Let <i>len</i> be the number of elements in <i>values</i>.</li>
                <li>Let <i>targetObj</i> be <a href="#sec-allocatetypedarray">AllocateTypedArray</a>(<i>C</i>, <i>len</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetObj</i>).</li>
                <li>Let <i>k</i> be 0.</li>
                <li>Repeat, while <i>k</i> &lt; <i>len</i>
                  <ol class="block">
                    <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
                    <li>Let <i>kValue</i> be the first element of <i>values</i> and remove that element from <i>values</i>.</li>
                    <li>If <i>mapping</i> is <b>true</b>, then
                      <ol class="block">
                        <li>Let <i>mappedValue</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>mapfn</i>, <i>T</i>, &laquo;<i>kValue</i>,
                            <i>k</i>&raquo;).</li>
                        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>mappedValue</i>).</li>
                      </ol>
                    </li>
                    <li>Else, let <i>mappedValue</i> be <i>kValue</i>.</li>
                    <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>targetObj</i>, <i>Pk</i>,
                        <i>mappedValue</i>, <b>true</b>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                    <li>Increase <i>k</i> by 1.</li>
                  </ol>
                </li>
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>values</i> is now an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
                <li>Return <i>targetObj</i>.</li>
              </ol>
            </li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>items</i> is not an Iterable so assume it is an array-like
                object.</li>
            <li>Let <i>arrayLike</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>items</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>arrayLike</i>).</li>
            <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>arrayLike</i>,
                <code>"length"</code>)).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
            <li>Let <i>targetObj</i> be <a href="#sec-allocatetypedarray">AllocateTypedArray</a>(<i>C</i>, <i>len</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetObj</i>).</li>
            <li>Let <i>k</i> be 0.</li>
            <li>Repeat, while <i>k</i> &lt; <i>len</i>
              <ol class="block">
                <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
                <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>arrayLike</i>, <i>Pk</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
                <li>If <i>mapping</i> is <b>true</b>, then
                  <ol class="block">
                    <li>Let <i>mappedValue</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>mapfn</i>, <i>T</i>, &laquo;<i>kValue</i>,
                        <i>k</i>&raquo;).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>mappedValue</i>).</li>
                  </ol>
                </li>
                <li>Else, let <i>mappedValue</i> be <i>kValue</i>.</li>
                <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>targetObj</i>, <i>Pk</i>,
                    <i>mappedValue</i>, <b>true</b>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setStatus</i>).</li>
                <li>Increase <i>k</i> by 1.</li>
              </ol>
            </li>
            <li>Return <i>targetObj</i>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-%typedarray%.of">
        <h4 id="sec-22.2.2.2" title="22.2.2.2">
            %TypedArray%.of ( ...items )</h4><p class="normalbefore">When the <code>of</code> method is called with any number of arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>len</i> be the actual number of arguments passed to this function.</li>
          <li>Let <i>items</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of arguments passed to this
              function.</li>
          <li>Let <i>C</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>C</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>newObj</i> be <a href="#sec-allocatetypedarray">AllocateTypedArray</a>(<i>C</i>, <i>len</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>newObj</i>).</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>kValue</i> be <i>items</i>[<i>k</i>].</li>
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>newObj</i>, <i>Pk</i>, <i>kValue</i>,
                  <b>true</b>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>newObj</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>of</code> method is <b>0</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The <var>items</var> argument is assumed to be a well-formed rest argument value.</p>
        </div>
      </section>

      <section id="sec-%typedarray%.prototype">
        <h4 id="sec-22.2.2.3" title="22.2.2.3"> %TypedArray%.prototype</h4><p>The initial value of %TypedArray%.prototype is the %TypedArrayPrototype% intrinsic object (<a href="#sec-properties-of-the-%typedarrayprototype%-object">22.2.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">false</span> }.</p>
      </section>

      <section id="sec-get-%typedarray%-@@species">
        <h4 id="sec-22.2.2.4" title="22.2.2.4"> get %TypedArray% [ @@species ]</h4><p class="normalbefore">%TypedArray%[@@species] is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Return the <b>this</b> value.</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"get [Symbol.species]"</code>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> %TypedArrayPrototype% methods normally use their <code>this</code> object&rsquo;s
          constructor to create a derived object. However, a subclass constructor may over-ride that default behaviour by
          redefining its @@species property.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-%typedarrayprototype%-object">
      <div class="front">
        <h3 id="sec-22.2.3" title="22.2.3"> Properties of the %TypedArrayPrototype% Object</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        %TypedArrayPrototype% object is the intrinsic object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>). The %TypedArrayPrototype% object is an ordinary object.
        It does not have a [[ViewedArrayBuffer]] or any other of the internal slots that are specific to <i>TypedArray</i>
        instance objects.</p>
      </div>

      <section id="sec-get-%typedarray%.prototype.buffer">
        <h4 id="sec-22.2.3.1" title="22.2.3.1"> get  %TypedArray%.prototype.buffer</h4><p class="normalbefore">%TypedArray%.<code>prototype.buffer</code> is an accessor property whose set accessor function is
        <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>O</i> does not have a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Return <i>buffer</i>.</li>
        </ol>
      </section>

      <section id="sec-get-%typedarray%.prototype.bytelength">
        <h4 id="sec-22.2.3.2" title="22.2.3.2"> get  %TypedArray%.prototype.byteLength</h4><p class="normalbefore">%TypedArray%.<code>prototype.byteLength</code> is an accessor property whose set accessor function
        is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>O</i> does not have a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, return 0.</li>
          <li>Let <i>size</i> be the value of <i>O</i>&rsquo;s [[ByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Return <i>size</i>.</li>
        </ol>
      </section>

      <section id="sec-get-%typedarray%.prototype.byteoffset">
        <h4 id="sec-22.2.3.3" title="22.2.3.3"> get  %TypedArray%.prototype.byteOffset</h4><p class="normalbefore">%TypedArray%.<code>prototype.byteOffset</code> is an accessor property whose set accessor function
        is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>O</i> does not have a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, return 0.</li>
          <li>Let <i>offset</i> be the value of <i>O</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Return <i>offset</i>.</li>
        </ol>
      </section>

      <section id="sec-%typedarray%.prototype.constructor">
        <h4 id="sec-22.2.3.4" title="22.2.3.4"> %TypedArray%.prototype.constructor</h4><p>The initial value of %TypedArray%.prototype.constructor is the %TypedArray% intrinsic object.</p>
      </section>

      <section id="sec-%typedarray%.prototype.copywithin">
        <div class="front">
          <h4 id="sec-22.2.3.5" title="22.2.3.5"> %TypedArray%.prototype.copyWithin (target, start [, end ] )</h4><p>%TypedArray%<code>.prototype.copyWithin</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.copywithin">Array.prototype.copyWithin</a></code> as defined in <a href="#sec-array.prototype.copywithin">22.1.3.3</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
          <code>"length"</code> and the actual copying of values in step 17 must be performed in a manner that preserves the
          bit-level encoding of the source data</p>

          <p>The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value is an object that
          has a fixed length and whose integer indexed properties are not sparse. However, such optimization must not introduce
          any observable changes in the specified behaviour of the algorithm.</p>

          <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
          value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
          completion</a> that exception is thrown instead of evaluating the algorithm.</p>

          <p>The <code>length</code> property of the <code>copyWithin</code> method is <b>2</b>.</p>
        </div>

        <section id="sec-validatetypedarray">
          <h5 id="sec-22.2.3.5.1" title="22.2.3.5.1"> Runtime Semantics:  ValidateTypedArray ( O )</h5><p class="normalbefore">When called with argument <i>O</i> the following steps are taken:</p>

          <ol class="proc">
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>If <i>O</i> does not have a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                slot</a>, throw a <b>TypeError</b> exception.</li>
            <li>If <i>O</i> does not have a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, throw a <b>TypeError</b> exception.</li>
            <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a <b>TypeError</b>
                exception.</li>
            <li>Return <i>buffer</i>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-%typedarray%.prototype.entries">
        <h4 id="sec-22.2.3.6" title="22.2.3.6"> %TypedArray%.prototype.entries ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>Let <i>valid</i> be <a href="#sec-validatetypedarray">ValidateTypedArray</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>valid</i>).</li>
          <li>Return <a href="#sec-createarrayiterator">CreateArrayIterator</a>(<i>O</i>, <code>"key+value"</code>).</li>
        </ol>
      </section>

      <section id="sec-%typedarray%.prototype.every">
        <h4 id="sec-22.2.3.7" title="22.2.3.7"> %TypedArray%.prototype.every ( callbackfn [ , thisArg ] )</h4><p>%TypedArray%<code>.prototype.every</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.every">Array.prototype.every</a></code> as defined in <a href="#sec-array.prototype.every">22.1.3.5</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm and must take into account the
        possibility that calls to <var>callbackfn</var> may cause the <b>this</b> value to become detached.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <p>The <code>length</code> property of the <code>every</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.fill">
        <h4 id="sec-22.2.3.8" title="22.2.3.8"> %TypedArray%.prototype.fill (value [ , start [ , end ] ] )</h4><p>%TypedArray%<code>.prototype.fill</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.fill">Array.prototype.fill</a></code> as defined in <a href="#sec-array.prototype.fill">22.1.3.6</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <p>The <code>length</code> property of the <code>fill</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.filter">
        <h4 id="sec-22.2.3.9" title="22.2.3.9"> %TypedArray%.prototype.filter ( callbackfn [ , thisArg ] )</h4><p>The interpretation and use of the arguments of %TypedArray%<code>.prototype.filter</code> are the same as for  <code><a href="#sec-array.prototype.filter">Array.prototype.filter</a></code> as defined in <a href="#sec-array.prototype.filter">22.1.3.7</a>.</p>

        <p class="normalbefore">When the <code>filter</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>Let <i>valid</i> be <a href="#sec-validatetypedarray">ValidateTypedArray</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>valid</i>).</li>
          <li>Let <i>len</i> be the value of <i>O&rsquo;s</i> [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>defaultConstructor</i> be the intrinsic object listed in column one of <a href="#table-49">Table 49</a> for
              the value of <i>O</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>.</li>
          <li>Let <i>C</i> be <a href="sec-abstract-operations#sec-speciesconstructor">SpeciesConstructor</a>(<i>O</i>, <i>defaultConstructor</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>C</i>).</li>
          <li>Let <i>kept</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Let <i>captured</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
              <li>Let <i>selected</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>,
                  <i>T</i>, &laquo;<i>kValue</i>, <i>k</i>, <i>O</i>&raquo;)).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>selected</i>).</li>
              <li>If <i>selected</i> is <b>true</b>, then
                <ol class="block">
                  <li>Append <i>kValue</i> to the end of <i>kept</i>.</li>
                  <li>Increase <i>captured</i> by 1.</li>
                </ol>
              </li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Let <i>A</i> be <a href="#sec-allocatetypedarray">AllocateTypedArray</a>(<i>C</i>, <i>captured</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
          <li>Let <i>n</i> be 0.</li>
          <li>For each element <i>e</i> of <i>kept</i>
            <ol class="block">
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>n</i>), <i>e</i>, <b>true</b> ).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
              <li>Increment <i>n</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>A</i>.</li>
        </ol>

        <p>This function is not generic. The <b>this</b> value must be an object with a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The <code>length</code> property of the <code>filter</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.find">
        <h4 id="sec-22.2.3.10" title="22.2.3.10"> %TypedArray%.prototype.find (predicate [ , thisArg ] )</h4><p>%TypedArray%<code>.prototype.find</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.find">Array.prototype.find</a></code> as defined in <a href="#sec-array.prototype.find">22.1.3.8</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm and must take into account the
        possibility that calls to <var>predicate</var> may cause the <b>this</b> value to become detached.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <p>The <code>length</code> property of the <code>find</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.findindex">
        <h4 id="sec-22.2.3.11" title="22.2.3.11"> %TypedArray%.prototype.findIndex ( predicate [ , thisArg ] )</h4><p>%TypedArray%<code>.prototype.findIndex</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.findindex">Array.prototype.findIndex</a></code> as defined in <a href="#sec-array.prototype.findindex">22.1.3.9</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm and must take into account the
        possibility that calls to <var>predicate</var> may cause the <b>this</b> value to become detached.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <p>The <code>length</code> property of the <code>findIndex</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.foreach">
        <h4 id="sec-22.2.3.12" title="22.2.3.12"> %TypedArray%.prototype.forEach ( callbackfn [ , thisArg ] )</h4><p>%TypedArray%<code>.prototype.forEach</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.foreach">Array.prototype.forEach</a></code> as defined in <a href="#sec-array.prototype.foreach">22.1.3.10</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm and must take into account the
        possibility that calls to <var>callbackfn</var> may cause the <b>this</b> value to become detached.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <p>The <code>length</code> property of the <code>forEach</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.indexof">
        <h4 id="sec-22.2.3.13" title="22.2.3.13"> %TypedArray%.prototype.indexOf (searchElement [ , fromIndex ] )</h4><p>%TypedArray%<code>.prototype.indexOf</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.indexof">Array.prototype.indexOf</a></code> as defined in <a href="#sec-array.prototype.indexof">22.1.3.11</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <p>The <code>length</code> property of the <code>indexOf</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.join">
        <h4 id="sec-22.2.3.14" title="22.2.3.14"> %TypedArray%.prototype.join ( separator )</h4><p>%TypedArray%<code>.prototype.join</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.join">Array.prototype.join</a></code> as defined in <a href="#sec-array.prototype.join">22.1.3.12</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>
      </section>

      <section id="sec-%typedarray%.prototype.keys">
        <h4 id="sec-22.2.3.15" title="22.2.3.15"> %TypedArray%.prototype.keys ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>Let <i>valid</i> be <a href="#sec-validatetypedarray">ValidateTypedArray</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>valid</i>).</li>
          <li>Return <a href="#sec-createarrayiterator">CreateArrayIterator</a>(<i>O</i>, <code>"key"</code>).</li>
        </ol>
      </section>

      <section id="sec-%typedarray%.prototype.lastindexof">
        <h4 id="sec-22.2.3.16" title="22.2.3.16"> %TypedArray%.prototype.lastIndexOf ( searchElement [ , fromIndex ]
            )</h4><p>%TypedArray%<code>.prototype.lastIndexOf</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.lastindexof">Array.prototype.lastIndexOf</a></code> as defined in <a href="#sec-array.prototype.lastindexof">22.1.3.14</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <p>The <code>length</code> property of the <code>lastIndexOf</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-get-%typedarray%.prototype.length">
        <h4 id="sec-22.2.3.17" title="22.2.3.17"> get  %TypedArray%.prototype.length</h4><p class="normalbefore">%TypedArray%.<code>prototype.length</code> is an accessor property whose set accessor function is
        <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>O</i> does not have a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>O</i> has [[ViewedArrayBuffer]] and [[ArrayLength]] internal
              slots.</li>
          <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, return 0.</li>
          <li>Let <i>length</i> be the value of <i>O</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Return <i>length</i>.</li>
        </ol>

        <p>This function is not generic. The <b>this</b> value must be an object with a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.map">
        <h4 id="sec-22.2.3.18" title="22.2.3.18"> %TypedArray%.prototype.map ( callbackfn [ , thisArg ] )</h4><p>The interpretation and use of the arguments of %TypedArray%<code>.prototype.map</code> are the same as for  <code><a href="#sec-array.prototype.map">Array.prototype.map</a></code> as defined in <a href="#sec-array.prototype.map">22.1.3.15</a>.</p>

        <p class="normalbefore">When the <code>map</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>Let <i>valid</i> be <a href="#sec-validatetypedarray">ValidateTypedArray</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>valid</i>).</li>
          <li>Let <i>len</i> be the value of <i>O&rsquo;s</i> [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>defaultConstructor</i> be the intrinsic object listed in column one of <a href="#table-49">Table 49</a> for
              the value of <i>O</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>.</li>
          <li>Let <i>C</i> be <a href="sec-abstract-operations#sec-speciesconstructor">SpeciesConstructor</a>(<i>O</i>, <i>defaultConstructor</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>C</i>).</li>
          <li>Let <i>A</i> be <a href="#sec-allocatetypedarray">AllocateTypedArray</a>(<i>C</i>, <i>len</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
          <li>Let <i>k</i> be 0.</li>
          <li>Repeat, while <i>k</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
              <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
              <li>Let <i>mappedValue</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>, <i>T</i>, &laquo;<i>kValue</i>,
                  <i>k</i>, <i>O</i>&raquo;).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>mappedValue</i>).</li>
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>A</i>, <i>Pk</i>, <i>mappedValue</i>, <b>true</b>
                  ).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
              <li>Increase <i>k</i> by 1.</li>
            </ol>
          </li>
          <li>Return <i>A</i>.</li>
        </ol>

        <p>This function is not generic. The <b>this</b> value must be an object with a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The <code>length</code> property of the <code>map</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.reduce">
        <h4 id="sec-22.2.3.19" title="22.2.3.19"> %TypedArray%.prototype.reduce ( callbackfn [ , initialValue ] )</h4><p>%TypedArray%<code>.prototype.reduce</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.reduce">Array.prototype.reduce</a></code> as defined in <a href="#sec-array.prototype.reduce">22.1.3.18</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm and must take into account the
        possibility that calls to <var>callbackfn</var> may cause the <b>this</b> value to become detached.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <p>The <code>length</code> property of the <code>reduce</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.reduceright">
        <h4 id="sec-22.2.3.20" title="22.2.3.20"> %TypedArray%.prototype.reduceRight ( callbackfn [ , initialValue ]
            )</h4><p>%TypedArray%<code>.prototype.reduceRight</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.reduceright">Array.prototype.reduceRight</a></code> as defined in <a href="#sec-array.prototype.reduceright">22.1.3.19</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm and must take into account the
        possibility that calls to <var>callbackfn</var> may cause the <b>this</b> value to become detached.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <p>The <code>length</code> property of the <code>reduceRight</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.reverse">
        <h4 id="sec-22.2.3.21" title="22.2.3.21"> %TypedArray%.prototype.reverse ( )</h4><p>%TypedArray%<code>.prototype.reverse</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.reverse">Array.prototype.reverse</a></code> as defined in <a href="#sec-array.prototype.reverse">22.1.3.20</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>
      </section>

      <section id="sec-%typedarray%.prototype.set-overloaded-offset">
        <div class="front">
          <h4 id="sec-22.2.3.22" title="22.2.3.22"> %TypedArray%.prototype.set ( overloaded [ , offset ])</h4><p>%TypedArray%<code>.prototype.set</code> is a single function whose behaviour is overloaded based upon the type of its
          first argument.</p>

          <p>This function is not generic. The <b>this</b> value must be an object with a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

          <p class="normalBullet">The <code>length</code> property of the <code>set</code> method is <b>1</b>.</p>
        </div>

        <section id="sec-%typedarray%.prototype.set-array-offset">
          <h5 id="sec-22.2.3.22.1" title="22.2.3.22.1"> %TypedArray%.prototype.set (array [ , offset ] )</h5><p class="normalbefore">Sets multiple values in this <i>TypedArray</i>, reading the values from the object <i>array</i>.
          The optional <i>offset</i> value indicates the first element index in this <i>TypedArray</i> where values are written.
          If omitted, it is assumed to be 0.</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>array</i> is any <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> other than an Object with a [[TypedArrayName]]
                <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>. If it is such an Object, the
                definition in <a href="#sec-%typedarray%.prototype.set-typedarray-offset">22.2.3.22.2</a> applies.</li>
            <li>Let <i>target</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>If <i>target</i> does not have a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, throw a <b>TypeError</b> exception.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>target</i> has a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>targetOffset</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a> (<i>offset</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetOffset</i>).</li>
            <li>If <i>targetOffset</i> &lt; 0, throw a <b>RangeError</b> exception.</li>
            <li>Let <i>targetBuffer</i> be the value of <i>target</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>targetBuffer</i>) is <b>true</b>, throw a
                <b>TypeError</b> exception.</li>
            <li>Let <i>targetLength</i> be the value of <i>target</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>targetName</i> be the String value of <i>target</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>targetElementSize</i> be the Number value of the Element Size value specified in <a href="#table-49">Table
                49</a> for <i>targetName</i>.</li>
            <li>Let <i>targetType</i> be the String value of the Element Type value in <a href="#table-49">Table 49</a> for
                <i>targetName</i>.</li>
            <li>Let <i>targetByteOffset</i> be the value of <i>target</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>src</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>array</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>src</i>).</li>
            <li>Let <i>srcLength</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>src</i>,
                <code>"length"</code>)).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>srcLength</i>).</li>
            <li>If <i>srcLength</i> + <i>targetOffset</i> &gt; <i>targetLength</i>, throw a <b>RangeError</b> exception.</li>
            <li>Let <i>targetByteIndex</i> be <i>targetOffset</i> &times; <i>targetElementSize</i> + <i>targetByteOffset</i>.</li>
            <li>Let <i>k</i> be 0.</li>
            <li>Let <i>limit</i> be <i>targetByteIndex</i> + <i>targetElementSize</i> &times; <i>srcLength</i>.</li>
            <li>Repeat, while <i>targetByteIndex</i> &lt; <i>limit</i>
              <ol class="block">
                <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
                <li>Let <i>kNumber</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>src</i>,
                    <i>Pk</i>)).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kNumber</i>).</li>
                <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>targetBuffer</i>) is <b>true</b>, throw a
                    <b>TypeError</b> exception.</li>
                <li>Perform <a href="sec-structured-data#sec-setvalueinbuffer">SetValueInBuffer</a>(<i>targetBuffer</i>, <i>targetByteIndex</i>,
                    <i>targetType</i>, <i>kNumber</i>).</li>
                <li>Set <i>k</i> to <i>k</i> + 1.</li>
                <li>Set <i>targetByteIndex</i> to <i>targetByteIndex</i> + <i>targetElementSize</i>.</li>
              </ol>
            </li>
            <li>Return <b>undefined</b>.</li>
          </ol>
        </section>

        <section id="sec-%typedarray%.prototype.set-typedarray-offset">
          <h5 id="sec-22.2.3.22.2" title="22.2.3.22.2"> %TypedArray%.prototype.set(typedArray [, offset ] )</h5><p class="normalbefore">Sets multiple values in this <i>TypedArray</i>, reading the values from the
          <var>typedArray</var> argument object. The optional <i>offset</i> value indicates the first element index in this
          <i>TypedArray</i> where values are written. If omitted, it is assumed to be 0.</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>typedArray</i> has a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>. If it does not, the definition in <a href="#sec-%typedarray%.prototype.set-array-offset">22.2.3.22.1</a> applies.</li>
            <li>Let <i>target</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>If <i>target</i> does not have a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, throw a <b>TypeError</b> exception.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>target</i> has a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>targetOffset</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a> (<i>offset</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetOffset</i>).</li>
            <li>If <i>targetOffset</i> &lt; 0, throw a <b>RangeError</b> exception.</li>
            <li>Let <i>targetBuffer</i> be the value of <i>target</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>targetBuffer</i>) is <b>true</b>, throw a
                <b>TypeError</b> exception.</li>
            <li>Let <i>targetLength</i> be the value of <i>target</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>srcBuffer</i> be the value of <i>typedArray</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>srcBuffer</i>) is <b>true</b>, throw a <b>TypeError</b>
                exception.</li>
            <li>Let <i>targetName</i> be the String value of <i>target</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>targetType</i> be the String value of the Element Type value in <a href="#table-49">Table 49</a> for
                <i>targetName</i>.</li>
            <li>Let <i>targetElementSize</i> be the Number value of the Element Size value specified in <a href="#table-49">Table
                49</a> for <i>targetName</i>.</li>
            <li>Let <i>targetByteOffset</i> be the value of <i>target</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>srcName</i> be the String value of <i>typedArray</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>srcType</i> be the String value of the Element Type value in <a href="#table-49">Table 49</a> for
                <i>srcName</i> .</li>
            <li>Let <i>srcElementSize</i> be the Number value of the Element Size value specified in <a href="#table-49">Table
                49</a> for <i>srcName</i>.</li>
            <li>Let <i>srcLength</i> be the value of <i>typedArray</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>srcByteOffset</i> be the value of <i>typedArray</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <i>srcLength</i> + <i>targetOffset</i> &gt; <i>targetLength</i>, throw a <b>RangeError</b> exception.</li>
            <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>srcBuffer</i>, <i>targetBuffer</i>) is <b>true</b>, then
              <ol class="block">
                <li>Let <i>srcBuffer</i> be <a href="sec-structured-data#sec-clonearraybuffer">CloneArrayBuffer</a>(<i>targetBuffer</i>,
                    <i>srcByteOffset</i>, %ArrayBuffer%).</li>
                <li>NOTE:  <span style="font-family: Times New Roman">%ArrayBuffer%</span> is used to clone <span style="font-family: Times New Roman"><i>targetBuffer</i></span> because is it known to not have any observable
                    side-effects.</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>srcBuffer</i>).</li>
                <li>Let <i>srcByteIndex</i> be 0.</li>
              </ol>
            </li>
            <li>Else, let <i>srcByteIndex</i> be <i>srcByteOffset</i>.</li>
            <li>Let <i>targetByteIndex</i> be <i>targetOffset</i> &times; <i>targetElementSize</i> + <i>targetByteOffset</i>.</li>
            <li>Let <i>limit</i> be <i>targetByteIndex</i> + <i>targetElementSize</i> &times; <i>srcLength</i>.</li>
            <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>srcType</i>, <i>targetType</i>) is <b>false</b>, then
              <ol class="block">
                <li>Repeat, while <i>targetByteIndex</i> &lt; <i>limit</i>
                  <ol class="block">
                    <li>Let <i>value</i> be <a href="sec-structured-data#sec-getvaluefrombuffer">GetValueFromBuffer</a>(<i>srcBuffer</i>,
                        <i>srcByteIndex</i>, <i>srcType</i>).</li>
                    <li>Perform <a href="sec-structured-data#sec-setvalueinbuffer">SetValueInBuffer</a> (<i>targetBuffer</i>, <i>targetByteIndex</i>,
                        <i>targetType</i>, <i>value</i>).</li>
                    <li>Set <i>srcByteIndex</i> to <i>srcByteIndex</i> + <i>srcElementSize</i>.</li>
                    <li>Set <i>targetByteIndex</i> to <i>targetByteIndex</i> + <i>targetElementSize</i>.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>NOTE:  If <var>srcType</var> and <var>targetType</var> are the same the transfer must be performed in a manner
                    that preserves the bit-level encoding of the source data.</li>
                <li>Repeat, while <i>targetByteIndex</i> &lt; <i>limit</i>
                  <ol class="block">
                    <li>Let <i>value</i> be <a href="sec-structured-data#sec-getvaluefrombuffer">GetValueFromBuffer</a>(<i>srcBuffer</i>,
                        <i>srcByteIndex</i>, <code>"Uint8"</code>).</li>
                    <li>Perform <a href="sec-structured-data#sec-setvalueinbuffer">SetValueInBuffer</a> (<i>targetBuffer</i>, <i>targetByteIndex</i>,
                        <code>"Uint8"</code>, <i>value</i>).</li>
                    <li>Set <i>srcByteIndex</i> to <i>srcByteIndex</i> + 1.</li>
                    <li>Set <i>targetByteIndex</i> to <i>targetByteIndex</i> + 1.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Return <b>undefined</b>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-%typedarray%.prototype.slice">
        <h4 id="sec-22.2.3.23" title="22.2.3.23"> %TypedArray%.prototype.slice ( start, end )</h4><p class="normalbefore">The interpretation and use of the arguments of %TypedArray%<code>.prototype.slice</code> are the
        same as for  <code><a href="#sec-array.prototype.slice">Array.prototype.slice</a></code> as defined in <a href="#sec-array.prototype.slice">22.1.3.22</a>. The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>Let <i>valid</i> be <a href="#sec-validatetypedarray">ValidateTypedArray</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>valid</i>).</li>
          <li>Let <i>len</i> be the value of <i>O&rsquo;s</i> [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>relativeStart</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>start</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeStart</i>).</li>
          <li>If <i>relativeStart</i> &lt; 0, let <i>k</i> be max((<i>len</i> + <i>relativeStart</i>),0); else let <i>k</i> be
              min(<i>relativeStart</i>, <i>len</i>).</li>
          <li>If <i>end</i> is <b>undefined</b>, let <i>relativeEnd</i> be <i>len</i>; else let <i>relativeEnd</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>end</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeEnd</i>).</li>
          <li>If <i>relativeEnd</i> &lt; 0, let <i>final</i> be max((<i>len</i> + <i>relativeEnd</i>),0); else let <i>final</i> be
              min(<i>relativeEnd</i>, <i>len</i>).</li>
          <li>Let <i>count</i> be max(<i>final</i> &ndash; <i>k</i>, 0).</li>
          <li>Let <i>defaultConstructor</i> be the intrinsic object listed in column one of <a href="#table-49">Table 49</a> for
              the value of <i>O</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>.</li>
          <li>Let <i>C</i> be <a href="sec-abstract-operations#sec-speciesconstructor">SpeciesConstructor</a>(<i>O</i>, <i>defaultConstructor</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>C</i>).</li>
          <li>Let <i>A</i> be <a href="#sec-allocatetypedarray">AllocateTypedArray</a>(<i>C</i>, <i>count</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>A</i>).</li>
          <li>Let <i>srcName</i> be the String value of <i>O&rsquo;s</i> [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>srcType</i> be the String value of the Element Type value in <a href="#table-49">Table 49</a> for
              <i>srcName</i>.</li>
          <li>Let <i>targetName</i> be the String value of <i>A&rsquo;s</i> [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>targetType</i> be the String value of the Element Type value in <a href="#table-49">Table 49</a> for
              <i>targetName</i>.</li>
          <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>srcType</i>, <i>targetType</i>) is <b>false</b>, then
            <ol class="block">
              <li>Let <i>n</i> be 0.</li>
              <li>Repeat, while <i>k</i> &lt; <i>final</i>
                <ol class="block">
                  <li>Let <i>Pk</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>).</li>
                  <li>Let <i>kValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <i>Pk</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>kValue</i>).</li>
                  <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>A</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>n</i>), <i>kValue</i>, <b>true</b> ).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                  <li>Increase <i>k</i> by 1.</li>
                  <li>Increase <i>n</i> by 1.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Else if <i>count</i> &gt; 0,
            <ol class="block">
              <li>Let <i>srcBuffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
              <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>srcBuffer</i>) is <b>true</b>, throw a
                  <b>TypeError</b> exception.</li>
              <li>Let <i>targetBuffer</i> be the value of <i>A</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
              <li>Let <i>elementSize</i> be the Number value of the Element Size value specified in <a href="#table-49">Table
                  49</a> for <i>srcType</i>.</li>
              <li>NOTE:  If <var>srcType</var> and <var>targetType</var> are the same the transfer must be performed in a manner
                  that preserves the bit-level encoding of the source data.</li>
              <li>Let <i>srcByteOffet</i> be the value of <i>O</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
              <li>Let <i>targetByteIndex</i> be 0.</li>
              <li>Let <i>srcByteIndex</i> be (<i>k</i> &times; <i>elementSize</i>) + <i>srcByteOffet</i>.</li>
              <li>Repeat, while <i>targetByteIndex</i> &lt; <i>count</i> &times; <i>elementSize</i>
                <ol class="block">
                  <li>Let <i>value</i> be <a href="sec-structured-data#sec-getvaluefrombuffer">GetValueFromBuffer</a>(<i>srcBuffer</i>,
                      <i>srcByteIndex</i>, <code>"Uint8"</code>).</li>
                  <li>Perform <a href="sec-structured-data#sec-setvalueinbuffer">SetValueInBuffer</a> (<i>targetBuffer</i>, <i>targetByteIndex</i>,
                      <code>"Uint8"</code>, <i>value</i>).</li>
                  <li>Increase <i>srcByteIndex</i> by 1.</li>
                  <li>Increase <i>targetByteIndex</i> by 1.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <i>A</i>.</li>
        </ol>

        <p>This function is not generic. The <b>this</b> value must be an object with a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The <code>length</code> property of the <code>slice</code> method is <b>2</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.some">
        <h4 id="sec-22.2.3.24" title="22.2.3.24"> %TypedArray%.prototype.some ( callbackfn [ , thisArg ] )</h4><p>%TypedArray%<code>.prototype.some</code> is a distinct function that implements the same algorithm as <code><a href="#sec-array.prototype.some">Array.prototype.some</a></code> as defined in <a href="#sec-array.prototype.some">22.1.3.23</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm and must take into account the
        possibility that calls to <var>callbackfn</var> may cause the <b>this</b> value to become detached.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value  prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <p>The <code>length</code> property of the <code>some</code> method is <b>1</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.sort">
        <h4 id="sec-22.2.3.25" title="22.2.3.25"> %TypedArray%.prototype.sort ( comparefn )</h4><p>%TypedArray%<code>.prototype.sort</code> is a distinct function that, except as described below, implements the same
        requirements as those of  <code><a href="#sec-array.prototype.sort">Array.prototype.sort</a></code> as defined in <a href="#sec-array.prototype.sort">22.1.3.24</a>. The implementation of the %TypedArray%<code>.prototype.sort</code>
        specification may be optimized with the knowledge that the <b>this</b> value is an object that has a fixed length and
        whose integer indexed properties are not sparse. The only internal methods of the <b>this</b> object that the algorithm
        may call are  [[Get]] and [[Set]].</p>

        <p>This function is not generic. The <b>this</b> value must be an object with a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p class="normalbefore">Upon entry, the following steps are performed to initialize evaluation of the <code>sort</code>
        function. These steps are used instead of the entry steps in <a href="#sec-array.prototype.sort">22.1.3.24</a>:</p>

        <ol class="proc">
          <li>Let <i>obj</i> be the <b>this</b> value as the argument.</li>
          <li>Let <i>buffer</i> be <a href="#sec-validatetypedarray">ValidateTypedArray</a>(<i>obj</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>buffer</i>).</li>
          <li>Let <i>len</i> be the value of <i>obj</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
        </ol>

        <p>The implementation defined sort order condition for exotic objects is not applied by
        %TypedArray%<code>.prototype.sort</code>.</p>

        <p>The following version of <a href="#sec-sortcompare">SortCompare</a> is used by
        %TypedArray%<code>.prototype.sort</code>. It performs a numeric comparison rather than the string comparison used in <a href="#sec-array.prototype.sort">22.1.3.24</a>. <a href="#sec-sortcompare">SortCompare</a> has access to the
        <var>comparefn</var> and <var>buffer</var> values of the current invocation of the <code>sort</code> method.</p>

        <p class="normalbefore">When the TypedArray <a href="#sec-sortcompare">SortCompare</a> abstract operation is called with
        two arguments <var>x</var> and <var>y</var>, the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: Both <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>x</i>) and <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>y</i>) is Number.</li>
          <li>If the argument <i>comparefn</i> is not <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>comparefn</i>, <b>undefined</b>, &laquo;<i>x</i>,
                  <i>y</i>&raquo;).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
              <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a <b>TypeError</b>
                  exception.</li>
              <li>If <i>v</i> is <b>NaN</b>, return +0.</li>
              <li>Return <i>v</i>.</li>
            </ol>
          </li>
          <li>If <i>x</i> and <i>y</i> are both <b>NaN</b>, return +0.</li>
          <li>If <i>x</i> is <b>NaN</b>, return 1.</li>
          <li>If <i>y</i> is <b>NaN</b>, return &minus;1.</li>
          <li>If <i>x</i> &lt; <i>y</i>, return &minus;1.</li>
          <li>If <i>x</i> &gt; <i>y</i>, return 1.</li>
          <li>If <i>x</i> is &minus;0 and <i>y</i> is +0, return &minus;1.</li>
          <li>If <i>x</i> is +0 and <i>y</i> is &minus;0, return 1.</li>
          <li>Return +0.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> Because <b>NaN</b> always compares greater than any other value, <b>NaN</b> property
          values always sort to the end of the result when <var>comparefn</var> is not provided.</p>
        </div>
      </section>

      <section id="sec-%typedarray%.prototype.subarray">
        <h4 id="sec-22.2.3.26" title="22.2.3.26"> %TypedArray%.prototype.subarray( [ begin [ , end ] ] )</h4><p>Returns a new <i>TypedArray</i> object whose element type is the same as this <i>TypedArray</i> and whose ArrayBuffer
        is the same as the ArrayBuffer of this <i>TypedArray</i>, referencing the elements at <var>begin</var>, inclusive, up to
        <var>end</var>, exclusive. If either <var>begin</var> or <var>end</var> is negative, it refers to an index from the end of
        the array, as opposed to from the beginning.</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>O</i> does not have a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>O</i> has a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>srcLength</i> be the value of <i>O</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>relativeBegin</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>begin</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeBegin</i>).</li>
          <li>If <i>relativeBegin</i> &lt; 0, let <i>beginIndex</i> be max((<i>srcLength</i> + <i>relativeBegin</i>), 0); else let
              <i>beginIndex</i> be min(<i>relativeBegin</i>, <i>srcLength</i>).</li>
          <li>If <i>end</i> is <b>undefined</b>, let <i>relativeEnd</i> be <i>srcLength</i>; else, let <i>relativeEnd</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>end</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeEnd</i>).</li>
          <li>If <i>relativeEnd</i> &lt; 0, let <i>endIndex</i> be max((<i>srcLength</i> + <i>relativeEnd</i>), 0); else let
              <i>endIndex</i> be min(<i>relativeEnd</i>, <i>srcLength</i>).</li>
          <li>Let <i>newLength</i> be max(<i>endIndex</i> &ndash; <i>beginIndex</i>, 0).</li>
          <li>Let <i>constructorName</i> be the String value of <i>O</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>elementSize</i> be the Number value of the Element Size value specified in <a href="#table-49">Table 49</a>
              for <i>constructorName</i>.</li>
          <li>Let <i>srcByteOffset</i> be the value of <i>O</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>beginByteOffset</i> be <i>srcByteOffset</i> + <i>beginIndex</i> &times; <i>elementSize</i>.</li>
          <li>Let <i>defaultConstructor</i> be the intrinsic object listed in column one of <a href="#table-49">Table 49</a> for
              <i>constructorName</i>.</li>
          <li>Let <i>constructor</i> be <a href="sec-abstract-operations#sec-speciesconstructor">SpeciesConstructor</a>(<i>O</i>,
              <i>defaultConstructor</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>constructor</i>).</li>
          <li>Let <i>argumentsList</i> be &laquo;<i>buffer</i>, <i>beginByteOffset</i>, <i>newLength</i>&raquo;.</li>
          <li>Return <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>constructor</i>, <i>argumentsList</i>).</li>
        </ol>

        <p>This function is not generic. The <b>this</b> value must be an object with a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The <code>length</code> property of the <code>subarray</code> method is <b>2</b>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.tolocalestring">
        <h4 id="sec-22.2.3.27" title="22.2.3.27"> %TypedArray%.prototype.toLocaleString ([ reserved1 [ , reserved2 ]
            ])</h4><p>%TypedArray%<code>.prototype.toLocaleString</code> is a distinct function that implements the same algorithm as
        <code>Array.prototype.</code> <code>toLocaleString</code> as defined in <a href="#sec-array.prototype.tolocalestring">22.1.3.26</a> except that the <b>this</b> object&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is accessed in place of performing a [[Get]] of
        <code>"length"</code>. The implementation of the algorithm may be optimized with the knowledge that the <b>this</b> value
        is an object that has a fixed length and whose integer indexed properties are not sparse. However, such optimization must
        not introduce any observable changes in the specified behaviour of the algorithm.</p>

        <p>This function is not generic. <a href="#sec-validatetypedarray">ValidateTypedArray</a> is applied to the <b>this</b>
        value prior to evaluating the algorithm. If its result is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt
        completion</a> that exception is thrown instead of evaluating the algorithm.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> If the ECMAScript implementation includes the ECMA-402 Internationalization API this
          function is based upon the algorithm for <code><a href="#sec-array.prototype.tolocalestring">Array.prototype.toLocaleString</a></code> that is in the ECMA-402
          specification.</p>
        </div>
      </section>

      <section id="sec-%typedarray%.prototype.tostring">
        <h4 id="sec-22.2.3.28" title="22.2.3.28"> %TypedArray%.prototype.toString ( )</h4><p>The initial value of the %TypedArray%<code>.prototype.toString</code> data property is the same built-in function
        object as the <code><a href="#sec-array.prototype.tostring">Array.prototype.toString</a></code> method defined in <a href="#sec-array.prototype.tostring">22.1.3.27</a>.</p>
      </section>

      <section id="sec-%typedarray%.prototype.values">
        <h4 id="sec-22.2.3.29" title="22.2.3.29"> %TypedArray%.prototype.values ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>Let <i>valid</i> be <a href="#sec-validatetypedarray">ValidateTypedArray</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>valid</i>).</li>
          <li>Return <a href="#sec-createarrayiterator">CreateArrayIterator</a>(<i>O</i>, <code>"value"</code>).</li>
        </ol>
      </section>

      <section id="sec-%typedarray%.prototype-@@iterator">
        <h4 id="sec-22.2.3.30" title="22.2.3.30"> %TypedArray%.prototype [ @@iterator ]  ( )</h4><p>The initial value of the @@iterator property is the same function object as the initial value of the
        %TypedArray%<code>.prototype.values</code> property.</p>
      </section>

      <section id="sec-get-%typedarray%.prototype-@@tostringtag">
        <h4 id="sec-22.2.3.31" title="22.2.3.31"> get %TypedArray%.prototype [ @@toStringTag ]</h4><p class="normalbefore">%TypedArray%.<code>prototype[@@toStringTag]</code> is an accessor property whose set accessor
        function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <b>undefined</b>.</li>
          <li>If <i>O</i> does not have a [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, return <b>undefined</b>.</li>
          <li>Let <i>name</i> be the value of <i>O</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>name</i> is a String value.</li>
          <li>Return <i>name</i>.</li>
        </ol>

        <p>This property has the attributes { [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>

        <p>The initial value of the <code>name</code> property of this function is <code>"get [Symbol.toStringTag]"</code>.</p>
      </section>
    </section>

    <section id="sec-typedarray-constructors">
      <div class="front">
        <h3 id="sec-22.2.4" title="22.2.4"> The </h3><p>Each of the <i>TypedArray</i> constructor objects is an intrinsic object that has the structure described below,
        differing only in the name used as the constructor name instead of <i>TypedArray</i>, in <a href="#table-49">Table
        49</a>.</p>

        <p>The <i>TypedArray</i> constructors are not intended to be called as a function and will throw an exception when called
        in that manner.</p>

        <p>The <i>TypedArray</i> constructors are designed to be subclassable. They may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <i>TypedArray</i> behaviour must include a <code>super</code> call to the <i>TypedArray</i> constructor to create and
        initialize the subclass instance with the internal state necessary to support the %TypedArray<code>%.prototype</code>
        built-in methods.</p>
      </div>

      <section id="sec-typedarray">
        <h4 id="sec-22.2.4.1" title="22.2.4.1">
            </h4><p class="normalbefore">A <i>TypedArray</i> constructor with a list of arguments <i>argumentsList</i> performs the
        following steps:</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>here</i> be the active function.</li>
          <li>Let <i>super</i> be <i>here</i>.[[GetPrototypeOf]]().</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>super</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a> (<i>super</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>argumentsList</i> be the <i>argumentsList</i> argument of the [[Construct]] internal method that invoked the
              active function.</li>
          <li>Return <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>super</i>, <i>argumentsList</i>, NewTarget).</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-typedarray-constructors">
      <div class="front">
        <h3 id="sec-22.2.5" title="22.2.5"> Properties of the </h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of each
        <i>TypedArray</i> constructor is the %TypedArray% intrinsic object (<a href="#sec-%typedarray%-intrinsic-object">22.2.1</a>).</p>

        <p>Each <i>TypedArray</i> constructor has a [[TypedArrayConstructorName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> property whose value is the String value of the
        constructor name specified for it in <a href="#table-49">Table 49</a>.</p>

        <p>Each <i>TypedArray</i> constructor has a <code>name</code> property whose value is the String value of the constructor
        name specified for it in <a href="#table-49">Table 49</a>.</p>

        <p>Besides a <code>length</code> property (whose value is 3), each <i>TypedArray</i> constructor has the following
        properties:</p>
      </div>

      <section id="sec-typedarray.bytes_per_element">
        <h4 id="sec-22.2.5.1" title="22.2.5.1"> </h4><p>The value of <i>TypedArray</i>.BYTES_PER_ELEMENT is the Number value of the Element Size value specified in <a href="#table-49">Table 49</a> for <i>TypedArray</i>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-typedarray.prototype">
        <h4 id="sec-22.2.5.2" title="22.2.5.2"> </h4><p>The initial value of <i>TypedArray</i>.prototype is the corresponding <i>TypedArray</i> prototype intrinsic object (<a href="#sec-properties-of-typedarray-prototype-objects">22.2.6</a>).</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">false</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-typedarray-prototype-objects">
      <div class="front">
        <h3 id="sec-22.2.6" title="22.2.6"> Properties of </h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of a
        <i>TypedArray</i> prototype object is the intrinsic object %TypedArrayPrototype% (<a href="#sec-properties-of-the-%typedarrayprototype%-object">22.2.3</a>). A <i>TypedArray</i> prototype object is an
        ordinary object. It does not have a [[ViewedArrayBuffer]] or any other of the internal slots that are specific to
        <i>TypedArray</i> instance objects.</p>
      </div>

      <section id="sec-typedarray.prototype.bytes_per_element">
        <h4 id="sec-22.2.6.1" title="22.2.6.1"> </h4><p>The value of <i>TypedArray</i><code>.prototype.BYTES_PER_ELEMENT</code> is the Number value of the Element Size value
        specified in <a href="#table-49">Table 49</a> for <i>TypedArray</i>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-typedarray.prototype.constructor">
        <h4 id="sec-22.2.6.2" title="22.2.6.2"> </h4><p>The initial value of a <i>TypedArray</i><code>.prototype.constructor</code> is the corresponding %<i>TypedArray</i>%
        intrinsic object.</p>
      </section>
    </section>

    <section id="sec-properties-of-typedarray-instances">
      <h3 id="sec-22.2.7" title="22.2.7"> Properties of </h3><p><i>TypedArray</i> instances are Integer Indexed exotic objects. Each <i>TypedArray</i> instance inherits properties from
      the corresponding <i>TypedArray</i> prototype object. Each <i>TypedArray</i> instance has the following internal slots:
      [[TypedArrayName]], [[ViewedArrayBuffer]], [[ByteLength]], [[ByteOffset]], and [[ArrayLength]].</p>
    </section>
  </section>
</section>

