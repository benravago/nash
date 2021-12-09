<section id="sec-keyed-collection">
  <div class="front">
    <h1 id="sec-23" title="23"> Keyed
        Collection</h1></div>

  <section id="sec-map-objects">
    <div class="front">
      <h2 id="sec-23.1" title="23.1"> Map
          Objects</h2><p>Map objects are collections of key/value pairs where both the keys and values may be arbitrary <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a>. A distinct key value may only occur in one key/value
      pair within the Map&rsquo;s collection. Distinct key values are discriminated using the <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a> comparison algorithm.</p>

      <p>Map object must be implemented using either hash tables or other mechanisms that, on average, provide access times that
      are sublinear on the number of elements in the collection. The data structures used in this Map objects specification is
      only intended to describe the required observable semantics of Map objects. It is not intended to be a viable implementation
      model.</p>
    </div>

    <section id="sec-map-constructor">
      <div class="front">
        <h3 id="sec-23.1.1" title="23.1.1"> The
            Map Constructor</h3><p>The Map constructor is the %Map% intrinsic object and the initial value of the <code>Map</code> property of the global
        object. When called as a constructor it creates and initializes a new Map object. <code>Map</code> is not intended to be
        called as a function and will throw an exception when called in that manner.</p>

        <p>The <code>Map</code> constructor is designed to be subclassable. It may be used as the value in an <code>extends</code>
        clause of a class definition. Subclass constructors that intend to inherit the specified <code>Map</code> behaviour must
        include a <code>super</code> call to the <code>Map</code> constructor to create and initialize the subclass instance with
        the internal state necessary to support the <code>Map.prototype</code> built-in methods.</p>
      </div>

      <section id="sec-map-iterable">
        <h4 id="sec-23.1.1.1" title="23.1.1.1">
            Map ( [ iterable ] )</h4><p class="normalbefore">When the <code>Map</code> function is called with optional argument the following steps are
        taken:</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>map</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
              <code>"%MapPrototype%"</code>, &laquo;&zwj;[[MapData]]&raquo; ).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>map</i>).</li>
          <li>Set <i>map&rsquo;s</i> [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to a
              new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>If <i>iterable</i> is not present, let <i>iterable</i> be <b>undefined</b>.</li>
          <li>If <i>iterable</i> is either <b>undefined</b> or <b>null</b>, let <i>iter</i> be <b>undefined</b>.</li>
          <li>Else,
            <ol class="block">
              <li>Let <i>adder</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>map</i>, <code>"set"</code>)<b>.</b></li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>adder</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>adder</i>) is <b>false</b>, throw a <b>TypeError</b>
                  exception.</li>
              <li>Let <i>iter</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>iterable</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iter</i>).</li>
            </ol>
          </li>
          <li>If <i>iter</i> is <b>undefined</b>, return <i>map</i>.</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iter</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, return <i>map</i>.</li>
              <li>Let <i>nextItem</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextItem</i>).</li>
              <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>nextItem</i>) is not Object,
                <ol class="block">
                  <li>Let <i>error</i> be <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family: sans-serif">throw</span>, [[value]]: a newly created <b>TypeError</b> object,
                      [[target]]:<span style="font-family: sans-serif">empty</span>}.</li>
                  <li>Return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iter</i>, <i>error</i>).</li>
                </ol>
              </li>
              <li>Let <i>k</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>nextItem</i>, <code>"0"</code>).</li>
              <li>If <i>k</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iter</i>, <i>k</i>).</li>
              <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>nextItem</i>, <code>"1"</code>).</li>
              <li>If <i>v</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iter</i>, <i>v</i>).</li>
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>adder</i>, <i>map</i>, &laquo;<i>k</i>.[[value]],
                  <i>v</i>.[[value]]&raquo;).</li>
              <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iter</i>, <i>status</i>).</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> If the parameter <var>iterable</var> is present, it is expected to be an object that
          implements an <span style="font-family: Times New Roman">@@iterator</span> method that returns an iterator object that
          produces a two element array-like object whose first element is a value that will be used as a Map key and whose second
          element is the value to associate with that key.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-map-constructor">
      <div class="front">
        <h3 id="sec-23.1.2" title="23.1.2"> Properties of the Map Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Map
        constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is <b>0</b>), the Map constructor has the following
        properties:</p>
      </div>

      <section id="sec-map.prototype">
        <h4 id="sec-23.1.2.1" title="23.1.2.1">
            Map.prototype</h4><p>The initial value of <code>Map.prototype</code> is the intrinsic object %MapPrototype% (<a href="#sec-properties-of-the-map-prototype-object">23.1.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-get-map-@@species">
        <h4 id="sec-23.1.2.2" title="23.1.2.2"> get Map [ @@species ]</h4><p class="normalbefore"><code>Map[@@species]</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Return the <b>this</b> value.</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"get [Symbol.species]"</code>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Methods that create derived collection objects should call @@species to determine the
          constructor to use to create the derived objects. Subclass constructor may over-ride @@species to change the default
          constructor assignment.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-map-prototype-object">
      <div class="front">
        <h3 id="sec-23.1.3" title="23.1.3"> Properties of the Map Prototype Object</h3><p>The Map prototype object is the intrinsic object %MapPrototype%. The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Map prototype object is the intrinsic
        object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>). The Map prototype object
        is an ordinary object. It does not have a [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
        slot</a>.</p>
      </div>

      <section id="sec-map.prototype.clear">
        <h4 id="sec-23.1.3.1" title="23.1.3.1"> Map.prototype.clear ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each Record {[[key]], [[value]]} <i>p</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>Set <i>p</i>.[[key]] to <span style="font-family: sans-serif">empty</span><i>.</i></li>
              <li>Set <i>p</i>.[[value]] to <span style="font-family: sans-serif">empty</span><i>.</i></li>
            </ol>
          </li>
          <li>Return <b>undefined</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The existing [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> is
          preserved because there may be existing MapIterator objects that are <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">suspended</a>
          midway through iterating over that <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</p>
        </div>
      </section>

      <section id="sec-map.prototype.constructor">
        <h4 id="sec-23.1.3.2" title="23.1.3.2"> Map.prototype.constructor</h4><p>The initial value of <code>Map.prototype.constructor</code> is the intrinsic object %Map%.</p>
      </section>

      <section id="sec-map.prototype.delete">
        <h4 id="sec-23.1.3.3" title="23.1.3.3"> Map.prototype.delete ( key )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each Record {[[key]], [[value]]} <i>p</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>p</i>.[[key]] is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a>(<i>p</i>.[[key]], <i>key</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Set <i>p</i>.[[key]] to <span style="font-family: sans-serif">empty</span><i>.</i></li>
                  <li>Set <i>p</i>.[[value]] to <span style="font-family: sans-serif">empty</span><i>.</i></li>
                  <li>Return <b>true</b>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <b>false</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The value <b>empty</b> is used as a specification device to indicate that an entry has
          been deleted. Actual implementations may take other actions such as physically removing the entry from internal data
          structures.</p>
        </div>
      </section>

      <section id="sec-map.prototype.entries">
        <h4 id="sec-23.1.3.4" title="23.1.3.4"> Map.prototype.entries ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createmapiterator">CreateMapIterator</a>(<i>M</i>, <code>"key+value"</code>).</li>
        </ol>
      </section>

      <section id="sec-map.prototype.foreach">
        <h4 id="sec-23.1.3.5" title="23.1.3.5"> Map.prototype.forEach ( callbackfn [ , thisArg ] )</h4><p class="normalbefore">When the <code>forEach</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each Record {[[key]], [[value]]} <i>e</i> that is an element of <i>entries,</i> in original key insertion
              order
            <ol class="block">
              <li>If <i>e</i>.[[key]] is not <span style="font-family: sans-serif">empty</span>, then
                <ol class="block">
                  <li>Let <i>funcResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>, <i>T</i>,
                      &laquo;<i>e</i>.[[value]], <i>e</i>.[[key]], <i>M</i>&raquo;).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>funcResult</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <b>undefined</b>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>forEach</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> <var>callbackfn</var> should be a function that accepts three arguments.
          <code>forEach</code> calls <var>callbackfn</var> once for each key/value pair present in the map object, in key
          insertion order. <var>callbackfn</var> is called only for keys of the map which actually exist; it is not called for
          keys that have been  deleted from the map.</p>

          <p>If a <var>thisArg</var> parameter is provided, it will be used as the <b>this</b> value for each invocation of
          <var>callbackfn</var>. If it is not provided, <b>undefined</b> is used instead.</p>

          <p><var>callbackfn</var> is called with three arguments: the value of the item, the key of the item, and the Map object
          being traversed.</p>

          <p><code>forEach</code> does not directly mutate the object on which it is called but the object may be mutated by the
          calls to <var>callbackfn</var>. Each entry of a map&rsquo;s [[MapData]] is only visited once. New keys added after the
          call to <code>forEach</code> begins are visited. A key will be revisited if it is deleted after it has been visited and
          then re-added before the <code>forEach</code> call completes. Keys that are deleted after the call to
          <code>forEach</code> begins and before being visited are not visited unless the key is added again before the
          <code>forEach</code> call completes.</p>
        </div>
      </section>

      <section id="sec-map.prototype.get">
        <h4 id="sec-23.1.3.6" title="23.1.3.6"> Map.prototype.get ( key )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each Record {[[key]], [[value]]} <i>p</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>p</i>.[[key]] is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a>(<i>p</i>.[[key]], <i>key</i>) is <b>true</b>, return
                  <i>p</i>.[[value]].</li>
            </ol>
          </li>
          <li>Return <b>undefined</b>.</li>
        </ol>
      </section>

      <section id="sec-map.prototype.has">
        <h4 id="sec-23.1.3.7" title="23.1.3.7"> Map.prototype.has ( key )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each Record {[[key]], [[value]]} <i>p</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>p</i>.[[key]] is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a>(<i>p</i>.[[key]], <i>key</i>) is <b>true</b>, return
                  <b>true</b><i>.</i></li>
            </ol>
          </li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-map.prototype.keys">
        <h4 id="sec-23.1.3.8" title="23.1.3.8"> Map.prototype.keys ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createmapiterator">CreateMapIterator</a>(<i>M</i>, <code>"key"</code>).</li>
        </ol>
      </section>

      <section id="sec-map.prototype.set">
        <h4 id="sec-23.1.3.9" title="23.1.3.9"> Map.prototype.set ( key , value )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each Record {[[key]], [[value]]} <i>p</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>p</i>.[[key]] is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a>(<i>p</i>.[[key]], <i>key</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Set <i>p</i>.[[value]] to <i>value.</i></li>
                  <li>Return <i>M</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>key</i> is &minus;0, let <i>key</i> be +0.</li>
          <li>Let <i>p</i> be the Record {[[key]]: <i>key</i>, [[value]]: <i>value</i>}.</li>
          <li>Append <i>p</i> as the last element of <i>entries</i>.</li>
          <li>Return <i>M</i>.</li>
        </ol>
      </section>

      <section id="sec-get-map.prototype.size">
        <h4 id="sec-23.1.3.10" title="23.1.3.10"> get Map.prototype.size</h4><p class="normalbefore">Map.prototype.size is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>count</i> be 0.</li>
          <li>For each Record {[[key]], [[value]]} <i>p</i> that is an element of <i>entries</i>
            <ol class="block">
              <li>If <i>p</i>.[[key]] is not <span style="font-family: sans-serif">empty</span>, set <i>count</i> to
                  <i>count</i>+1.</li>
            </ol>
          </li>
          <li>Return <i>count</i>.</li>
        </ol>
      </section>

      <section id="sec-map.prototype.values">
        <h4 id="sec-23.1.3.11" title="23.1.3.11"> Map.prototype.values ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createmapiterator">CreateMapIterator</a>(<i>M</i>, <code>"value"</code>).</li>
        </ol>
      </section>

      <section id="sec-map.prototype-@@iterator">
        <h4 id="sec-23.1.3.12" title="23.1.3.12"> Map.prototype [ @@iterator ]( )</h4><p>The initial value of the @@iterator property is the same function object as the initial value of the <b>entries</b>
        property.</p>
      </section>

      <section id="sec-map.prototype-@@tostringtag">
        <h4 id="sec-23.1.3.13" title="23.1.3.13"> Map.prototype [ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"Map"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-map-instances">
      <h3 id="sec-23.1.4" title="23.1.4"> Properties of Map Instances</h3><p>Map instances are ordinary objects that inherit properties from the Map prototype. Map instances also have a [[MapData]]
      <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
    </section>

    <section id="sec-map-iterator-objects">
      <div class="front">
        <h3 id="sec-23.1.5" title="23.1.5"> Map Iterator Objects</h3><p>A Map Iterator is an object, that represents a specific iteration over some specific Map instance object. There is not
        a named constructor for Map Iterator objects. Instead, map iterator objects are created by calling certain methods of Map
        instance objects.</p>
      </div>

      <section id="sec-createmapiterator">
        <h4 id="sec-23.1.5.1" title="23.1.5.1"> CreateMapIterator Abstract Operation</h4><p class="normalbefore">Several methods of Map objects return Iterator objects. The abstract operation CreateMapIterator
        with arguments <var>map</var> and <var>kind</var> is used to create such iterator objects. It performs the following
        steps:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>map</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>map</i> does not have a [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>iterator</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(%MapIteratorPrototype%, &laquo;&zwj;[[Map]],
              [[MapNextIndex]], [[MapIterationKind]]&raquo;).</li>
          <li>Set <i>iterator&rsquo;s</i> [[Map]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <i>map</i>.</li>
          <li>Set <i>iterator&rsquo;s</i> [[MapNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to 0.</li>
          <li>Set <i>iterator&rsquo;s</i> [[MapIterationKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>kind</i>.</li>
          <li>Return <i>iterator</i>.</li>
        </ol>
      </section>

      <section id="sec-%mapiteratorprototype%-object">
        <div class="front">
          <h4 id="sec-23.1.5.2" title="23.1.5.2"> The %MapIteratorPrototype% Object</h4><p>All Map Iterator Objects inherit properties from the %MapIteratorPrototype% intrinsic object. The
          %MapIteratorPrototype% intrinsic object is an ordinary object and its [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is the %IteratorPrototype% intrinsic object (<a href="sec-control-abstraction-objects#sec-%iteratorprototype%-object">25.1.2</a>). In addition, %MapIteratorPrototype% has the following
          properties:</p>
        </div>

        <section id="sec-%mapiteratorprototype%.next">
          <h5 id="sec-23.1.5.2.1" title="23.1.5.2.1"> %MapIteratorPrototype%.next ( )</h5><ol class="proc">
            <li>Let <i>O</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>If <i>O</i> does not have all of the internal slots of a Map Iterator Instance (<a href="#sec-properties-of-map-iterator-instances">23.1.5.3</a>), throw a <b>TypeError</b> exception.</li>
            <li>Let <i>m</i> be the value of the [[Map]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                slot</a> of <i>O</i>.</li>
            <li>Let <i>index</i> be the value of the [[MapNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
            <li>Let <i>itemKind</i> be the value of the [[MapIterationKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
            <li>If <i>m</i> is <b>undefined</b>, return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>true</b>).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>m</i> has a [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of the
                [[MapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>m</i>.</li>
            <li>Repeat while <i>index</i> is less than the total number of elements of <i>entries</i>. The number of elements must
                be redetermined each time this method is evaluated.
              <ol class="block">
                <li>Let <i>e</i> be the Record {[[key]], [[value]]} that is the value of <i>entries</i>[<i>index</i>].</li>
                <li>Set <i>index</i> to <i>index</i>+1.</li>
                <li>Set the [[MapNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                    <i>O</i> to <i>index</i>.</li>
                <li>If <i>e</i>.[[key]] is not <span style="font-family: sans-serif">empty</span>, then
                  <ol class="block">
                    <li>If <i>itemKind</i> is <b>"<code>key</code>"</b>, let <i>result</i> be <i>e</i>.[[key]].</li>
                    <li>Else if <i>itemKind</i> is <b>"<code>value</code>"</b>, let <i>result</i> be <i>e</i>.[[value]].</li>
                    <li>Else,
                      <ol class="block">
                        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>itemKind</i> is <code>"key+value"</code>.</li>
                        <li>Let <i>result</i> be <a href="sec-abstract-operations#sec-createarrayfromlist">CreateArrayFromList</a>(&laquo;<i>e</i>.[[key]],
                            <i>e</i>.[[value]]&raquo;).</li>
                      </ol>
                    </li>
                    <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<i>result</i>, <b>false</b>).</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Set the [[Map]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i> to
                <b>undefined</b>.</li>
            <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>true</b>).</li>
          </ol>
        </section>

        <section id="sec-%mapiteratorprototype%-@@tostringtag">
          <h5 id="sec-23.1.5.2.2" title="23.1.5.2.2"> %MapIteratorPrototype% [ @@toStringTag ]</h5><p>The initial value of the @@toStringTag property is the String value <code>"Map Iterator"</code>.</p>

          <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
        </section>
      </section>

      <section id="sec-properties-of-map-iterator-instances">
        <h4 id="sec-23.1.5.3" title="23.1.5.3"> Properties of Map Iterator Instances</h4><p>Map Iterator instances are ordinary objects that inherit properties from the %MapIteratorPrototype% intrinsic  object.
        Map Iterator instances are initially created with the internal slots described in <a href="#table-50">Table 50</a>.</p>

        <figure>
          <figcaption><span id="table-50">Table 50</span> &mdash; Internal Slots of Map Iterator Instances</figcaption>
          <table class="real-table">
            <tr>
              <th>Internal Slot</th>
              <th>Description</th>
            </tr>
            <tr>
              <td>[[Map]]</td>
              <td>The Map object that is being iterated.</td>
            </tr>
            <tr>
              <td>[[MapNextIndex]]</td>
              <td>The integer index of the next Map data element to be examined by this iterator.</td>
            </tr>
            <tr>
              <td>[[MapIterationKind]]</td>
              <td>A String value that identifies what is to be returned for each element of the iteration. The possible values are: <code>"key"</code>, <code>"value"</code>, <code>"key+value"</code>.</td>
            </tr>
          </table>
        </figure>
      </section>
    </section>
  </section>

  <section id="sec-set-objects">
    <div class="front">
      <h2 id="sec-23.2" title="23.2"> Set
          Objects</h2><p>Set objects are collections of <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a>. A distinct value
      may only occur once as an element of a Set&rsquo;s collection. Distinct values are discriminated using the <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a> comparison algorithm.</p>

      <p>Set objects must be implemented using either hash tables or other mechanisms that, on average, provide access times that
      are sublinear on the number of elements in the collection. The data structures used in this Set objects specification is
      only intended to describe the required observable semantics of Set objects. It is not intended to be a viable implementation
      model.</p>
    </div>

    <section id="sec-set-constructor">
      <div class="front">
        <h3 id="sec-23.2.1" title="23.2.1"> The
            Set Constructor</h3><p>The Set constructor is the %Set% intrinsic object and the initial value of the <code>Set</code> property of the global
        object. When called as a constructor it creates and initializes a new Set object. <code>Set</code> is not intended to be
        called as a function and will throw an exception when called in that manner.</p>

        <p>The <code>Set</code> constructor is designed to be subclassable. It may be used as the value in an <code>extends</code>
        clause of a class definition. Subclass constructors that intend to inherit the specified <code>Set</code> behaviour must
        include a <code>super</code> call to the <code>Set</code> constructor to create and initialize the subclass instance with
        the internal state necessary to support the <code>Set.prototype</code> built-in methods.</p>
      </div>

      <section id="sec-set-iterable">
        <h4 id="sec-23.2.1.1" title="23.2.1.1">
            Set ( [ iterable ] )</h4><p class="normalbefore">When the <code>Set</code> function is called with optional argument <var>iterable</var> the
        following steps are taken:</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>set</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
              <code>"%SetPrototype%"</code>, &laquo;&zwj;[[SetData]]&raquo; ).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>set</i>).</li>
          <li>Set <i>set&rsquo;s</i> [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to a
              new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>If <i>iterable</i> is not present, let <i>iterable</i> be <b>undefined</b>.</li>
          <li>If <i>iterable</i> is either <b>undefined</b> or <b>null</b>, let <i>iter</i> be <b>undefined</b>.</li>
          <li>Else,
            <ol class="block">
              <li>Let <i>adder</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>set</i>, <code>"add"</code>)<b>.</b></li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>adder</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>adder</i>) is <b>false</b>, throw a <b>TypeError</b>
                  exception.</li>
              <li>Let <i>iter</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>iterable</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iter</i>).</li>
            </ol>
          </li>
          <li>If <i>iter</i> is <b>undefined</b>, return <i>set</i>.</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iter</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, return <i>set</i>.</li>
              <li>Let <i>nextValue</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextValue</i>).</li>
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>adder</i>, <i>set</i>,
                  &laquo;<i>nextValue</i>.[[value]]&raquo;).</li>
              <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iter</i>, <i>status</i>).</li>
            </ol>
          </li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-set-constructor">
      <div class="front">
        <h3 id="sec-23.2.2" title="23.2.2"> Properties of the Set Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Set
        constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is <b>0</b>), the Set constructor has the following
        properties:</p>
      </div>

      <section id="sec-set.prototype">
        <h4 id="sec-23.2.2.1" title="23.2.2.1">
            Set.prototype</h4><p>The initial value of <code>Set.prototype</code> is the intrinsic %SetPrototype% object (<a href="#sec-properties-of-the-set-prototype-object">23.2.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-get-set-@@species">
        <h4 id="sec-23.2.2.2" title="23.2.2.2"> get Set [ @@species ]</h4><p class="normalbefore"><code>Set[@@species]</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Return the <b>this</b> value.</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"get [Symbol.species]"</code>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Methods that create derived collection objects should call @@species to determine the
          constructor to use to create the derived objects. Subclass constructor may over-ride @@species to change the default
          constructor assignment.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-set-prototype-object">
      <div class="front">
        <h3 id="sec-23.2.3" title="23.2.3"> Properties of the Set Prototype Object</h3><p>The Set prototype object is the intrinsic object %SetPrototype%. The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Set prototype object is the intrinsic
        object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>). The Set prototype object
        is an ordinary object. It does not have a [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
        slot</a>.</p>
      </div>

      <section id="sec-set.prototype.add">
        <h4 id="sec-23.2.3.1" title="23.2.3.1"> Set.prototype.add ( value )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>S</i> does not have a [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>S</i>&rsquo;s [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each <i>e</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>e</i> is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a>(<i>e</i>, <i>value</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Return <i>S</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>value</i> is &minus;0, let <i>value</i> be +0.</li>
          <li>Append <i>value</i> as the last element of <i>entries</i>.</li>
          <li>Return <i>S</i>.</li>
        </ol>
      </section>

      <section id="sec-set.prototype.clear">
        <h4 id="sec-23.2.3.2" title="23.2.3.2"> Set.prototype.clear ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>S</i> does not have a [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>S</i>&rsquo;s [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each <i>e</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>Replace the element of <i>entries</i> whose value is <i>e</i> with an element whose value is <span style="font-family: sans-serif">empty</span><i>.</i></li>
            </ol>
          </li>
          <li>Return <b>undefined</b>.</li>
        </ol>
      </section>

      <section id="sec-set.prototype.constructor">
        <h4 id="sec-23.2.3.3" title="23.2.3.3"> Set.prototype.constructor</h4><p>The initial value of <code>Set.prototype.constructor</code> is the intrinsic object %Set%.</p>
      </section>

      <section id="sec-set.prototype.delete">
        <h4 id="sec-23.2.3.4" title="23.2.3.4"> Set.prototype.delete ( value )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>S</i> does not have a [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>S</i>&rsquo;s [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each  <i>e</i> that is an element of <i>entries</i>,
            <ol class="block">
              <li>If <i>e</i> is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a>(<i>e</i>, <i>value</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Replace the element of <i>entries</i> whose value is <i>e</i> with an element whose value is <span style="font-family: sans-serif">empty</span><i>.</i></li>
                  <li>Return <b>true</b>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <b>false</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The value <b>empty</b> is used as a specification device to indicate that an entry has
          been deleted. Actual implementations may take other actions such as physically removing the entry from internal data
          structures.</p>
        </div>
      </section>

      <section id="sec-set.prototype.entries">
        <h4 id="sec-23.2.3.5" title="23.2.3.5"> Set.prototype.entries ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createsetiterator">CreateSetIterator</a>(<i>S</i>, <b>"<code>key+value</code>"</b>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> For iteration purposes, a Set appears similar to a Map where each entry has the same
          value for its key and value.</p>
        </div>
      </section>

      <section id="sec-set.prototype.foreach">
        <h4 id="sec-23.2.3.6" title="23.2.3.6"> Set.prototype.forEach ( callbackfn [ , thisArg ] )</h4><p class="normalbefore">When the <code>forEach</code> method is called with one or two arguments, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>S</i> does not have a [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>callbackfn</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>thisArg</i> was supplied, let <i>T</i> be <i>thisArg</i>; else let <i>T</i> be <b>undefined</b>.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>S</i>&rsquo;s [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each <i>e</i> that is an element of <i>entries,</i> in original insertion order
            <ol class="block">
              <li>If <i>e</i> is not <span style="font-family: sans-serif">empty</span>, then
                <ol class="block">
                  <li>Let <i>funcResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>callbackfn</i>, <i>T</i>, &laquo;<i>e</i>,
                      <i>e</i>, <i>S</i>&raquo;).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>funcResult</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <b>undefined</b>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>forEach</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> <var>callbackfn</var> should be a function that accepts three arguments.
          <code>forEach</code> calls <var>callbackfn</var> once for each value present in the set object, in value insertion
          order. <var>callbackfn</var> is called only for values of the Set which actually exist; it is not called for keys that
          have been  deleted from the set.</p>

          <p>If a <var>thisArg</var> parameter is provided, it will be used as the <b>this</b> value for each invocation of
          <var>callbackfn</var>. If it is not provided, <b>undefined</b> is used instead.</p>

          <p><var>callbackfn</var> is called with three arguments: the first two arguments are a value contained in the Set. The
          same value is passed for both arguments. The Set object being traversed is passed as the third argument.</p>

          <p>The <var>callbackfn</var> is called with three arguments to be consistent with the call back functions used by
          <code>forEach</code> methods for Map and Array. For Sets, each item value is considered to be both the key and the
          value.</p>

          <p><code>forEach</code> does not directly mutate the object on which it is called but the object may be mutated by the
          calls to <var>callbackfn</var>.</p>

          <p>Each value is normally visited only once. However, a value will be revisited if it is deleted after it has been
          visited and then re-added before the <code>forEach</code> call completes. Values that are deleted after the call to
          <code>forEach</code> begins and before being visited are not visited unless the value is added again before the
          <code>forEach</code> call completes. New values added after the call to <code>forEach</code> begins are visited.</p>
        </div>
      </section>

      <section id="sec-set.prototype.has">
        <h4 id="sec-23.2.3.7" title="23.2.3.7"> Set.prototype.has ( value )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>S</i> does not have a [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>S</i>&rsquo;s [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each <i>e</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>e</i> is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a>(<i>e</i>, <i>value</i>) is <b>true</b>, return
                  <b>true</b><i>.</i></li>
            </ol>
          </li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-set.prototype.keys">
        <h4 id="sec-23.2.3.8" title="23.2.3.8"> Set.prototype.keys ( )</h4><p>The initial value of the <code>keys</code> property is the same function object as the initial value of the
        <code>values</code> property.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> For iteration purposes, a Set appears similar to a Map where each entry has the same
          value for its key and value.</p>
        </div>
      </section>

      <section id="sec-get-set.prototype.size">
        <h4 id="sec-23.2.3.9" title="23.2.3.9"> get Set.prototype.size</h4><p class="normalbefore"><code>Set.prototype.size</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>S</i> does not have a [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>S</i>&rsquo;s [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>count</i> be 0.</li>
          <li>For each <i>e</i> that is an element of <i>entries</i>
            <ol class="block">
              <li>If <i>e</i> is not <span style="font-family: sans-serif">empty</span>, set <i>count</i> to <i>count</i>+1.</li>
            </ol>
          </li>
          <li>Return <i>count</i>.</li>
        </ol>
      </section>

      <section id="sec-set.prototype.values">
        <h4 id="sec-23.2.3.10" title="23.2.3.10"> Set.prototype.values ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-createsetiterator">CreateSetIterator</a>(<i>S</i>, <b>"<code>value</code>"</b>).</li>
        </ol>
      </section>

      <section id="sec-set.prototype-@@iterator">
        <h4 id="sec-23.2.3.11" title="23.2.3.11"> Set.prototype [ @@iterator ] ( )</h4><p>The initial value of the @@iterator property is the same function object as the initial value of the
        <code>values</code> property.</p>
      </section>

      <section id="sec-set.prototype-@@tostringtag">
        <h4 id="sec-23.2.3.12" title="23.2.3.12"> Set.prototype [ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"Set"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-set-instances">
      <h3 id="sec-23.2.4" title="23.2.4"> Properties of Set Instances</h3><p>Set instances are ordinary objects that inherit properties from the Set prototype. Set instances also have a [[SetData]]
      <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
    </section>

    <section id="sec-set-iterator-objects">
      <div class="front">
        <h3 id="sec-23.2.5" title="23.2.5"> Set Iterator Objects</h3><p>A Set Iterator is an ordinary object, with the structure defined below, that represents a specific iteration over some
        specific Set instance object. There is not a named constructor for Set Iterator objects. Instead, set iterator objects are
        created by calling certain methods of Set instance objects.</p>
      </div>

      <section id="sec-createsetiterator">
        <h4 id="sec-23.2.5.1" title="23.2.5.1"> CreateSetIterator Abstract Operation</h4><p class="normalbefore">Several methods of Set objects return Iterator objects. The abstract operation CreateSetIterator
        with arguments <var>set</var> and <var>kind</var> is used to create such iterator objects. It performs the following
        steps:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>set</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>set</i> does not have a [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>iterator</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(%SetIteratorPrototype%,
              &laquo;&zwj;[[IteratedSet]], [[SetNextIndex]], [[SetIterationKind]]&raquo;).</li>
          <li>Set <i>iterator&rsquo;s</i> [[IteratedSet]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>set</i>.</li>
          <li>Set <i>iterator&rsquo;s</i> [[SetNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to 0.</li>
          <li>Set <i>iterator&rsquo;s</i> [[SetIterationKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>kind</i>.</li>
          <li>Return <i>iterator</i>.</li>
        </ol>
      </section>

      <section id="sec-%setiteratorprototype%-object">
        <div class="front">
          <h4 id="sec-23.2.5.2" title="23.2.5.2"> The %SetIteratorPrototype% Object</h4><p>All Set Iterator Objects inherit properties from the %SetIteratorPrototype% intrinsic object. The
          %SetIteratorPrototype% intrinsic object is an ordinary object and its [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is the %IteratorPrototype% intrinsic object (<a href="sec-control-abstraction-objects#sec-%iteratorprototype%-object">25.1.2</a>). In addition, %SetIteratorPrototype% has the following
          properties:</p>
        </div>

        <section id="sec-%setiteratorprototype%.next">
          <h5 id="sec-23.2.5.2.1" title="23.2.5.2.1"> %SetIteratorPrototype%.next ( )</h5><ol class="proc">
            <li>Let <i>O</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>If <i>O</i> does not have all of the internal slots of a Set Iterator Instance (<a href="#sec-properties-of-set-iterator-instances">23.2.5.3</a>), throw a <b>TypeError</b> exception.</li>
            <li>Let <i>s</i> be the value of the [[IteratedSet]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
            <li>Let <i>index</i> be the value of the [[SetNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
            <li>Let <i>itemKind</i> be the value of the [[SetIterationKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
            <li>If <i>s</i> is <b>undefined</b>, return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>true</b>).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>s</i> has a [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of the
                [[SetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>s</i>.</li>
            <li>Repeat while <i>index</i> is less than the total number of elements of <i>entries</i>. The number of elements must
                be redetermined each time this method is evaluated.
              <ol class="block">
                <li>Let <i>e</i> be <i>entries</i>[<i>index</i>].</li>
                <li>Set <i>index</i> to <i>index</i>+1;</li>
                <li>Set the [[SetNextIndex]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                    <i>O</i> to <i>index</i>.</li>
                <li>If <i>e</i> is not <span style="font-family: sans-serif">empty</span>, then
                  <ol class="block">
                    <li>If <i>itemKind</i> is <b>"<code>key+value</code>"</b>, then
                      <ol class="block">
                        <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<a href="sec-abstract-operations#sec-createarrayfromlist">CreateArrayFromList</a>(&laquo;<i>e</i>, <i>e</i>&raquo;),
                            <b>false</b>).</li>
                      </ol>
                    </li>
                    <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<i>e</i>, <b>false</b>).</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Set the [[IteratedSet]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i> to
                <b>undefined</b>.</li>
            <li>Return <a href="sec-abstract-operations#sec-createiterresultobject">CreateIterResultObject</a>(<b>undefined</b>, <b>true</b>).</li>
          </ol>
        </section>

        <section id="sec-%setiteratorprototype%-@@tostringtag">
          <h5 id="sec-23.2.5.2.2" title="23.2.5.2.2"> %SetIteratorPrototype% [ @@toStringTag ]</h5><p>The initial value of the @@toStringTag property is the String value <code>"Set Iterator"</code>.</p>

          <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
        </section>
      </section>

      <section id="sec-properties-of-set-iterator-instances">
        <h4 id="sec-23.2.5.3" title="23.2.5.3"> Properties of Set Iterator Instances</h4><p>Set Iterator instances are ordinary objects that inherit properties from the %SetIteratorPrototype% intrinsic  object.
        Set Iterator instances are initially created with the internal slots specified in <a href="#table-51">Table 51</a>.</p>

        <figure>
          <figcaption><span id="table-51">Table 51</span> &mdash; Internal Slots of Set Iterator Instances</figcaption>
          <table class="real-table">
            <tr>
              <th style="background-color: #BFBFBF">Internal Slot</th>
              <th style="background-color: #BFBFBF">Description</th>
            </tr>
            <tr>
              <td>[[IteratedSet]]</td>
              <td>The Set object that is being iterated.</td>
            </tr>
            <tr>
              <td>[[SetNextIndex]]</td>
              <td>The integer index of the next Set data element to be examined by this iterator</td>
            </tr>
            <tr>
              <td>[[SetIterationKind]]</td>
              <td>A String value that identifies what is to be returned for each element of the iteration. The possible values are: <code>"key"</code>, <code>"value"</code>, <code>"key+value"</code>. <code>"key"</code> and <code>"value"</code> have the same meaning.</td>
            </tr>
          </table>
        </figure>
      </section>
    </section>
  </section>

  <section id="sec-weakmap-objects">
    <div class="front">
      <h2 id="sec-23.3" title="23.3"> WeakMap
          Objects</h2><p>WeakMap objects are collections of key/value pairs where the keys are objects and values may be arbitrary <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a>. A WeakMap may be queried to see if it contains a
      key/value pair with a specific key, but no mechanism is provided for enumerating the objects it holds as keys. If an object
      that is being used as the key of a WeakMap key/value pair is only reachable by following a chain of references that start
      within that WeakMap, then that key/value pair is inaccessible and is automatically removed from the WeakMap. WeakMap
      implementations must detect and remove such key/value pairs and any associated resources.</p>

      <p>An implementation may impose an arbitrarily determined latency between the time a key/value pair of a WeakMap becomes
      inaccessible and the time when the key/value pair is removed from the WeakMap. If this latency was observable to ECMAScript
      program, it would be a source of indeterminacy that could impact program execution. For that reason, an ECMAScript
      implementation must not provide any means to observe a key of a WeakMap that does not require the observer to present the
      observed key.</p>

      <p>WeakMap objects must be implemented using either hash tables or other mechanisms that, on average, provide access times
      that are sublinear on the number of key/value pairs in the collection. The data structure used in this WeakMap objects
      specification are only intended to describe the required observable semantics of WeakMap objects. It is not intended to be a
      viable implementation model.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> WeakMap and WeakSets are intended to provide mechanisms for dynamically associating state
        with an object in a manner that does not &ldquo;leak&rdquo; memory resources if, in the absence of the WeakMap or WeakSet,
        the object otherwise became inaccessible and subject to resource reclamation by the implementation&rsquo;s garbage
        collection mechanisms. Achieving this characteristic can be achieved by using an inverted per-object mapping of weak map
        instances to keys.  Alternatively each weak map may internally store its key to value mappings but this approach requires
        coordination between the WeakMap or WeakSet implementation and the garbage collector. The following references describe
        mechanism that may be useful to implementations of WeakMap and WeakSets:</p>

        <p>Barry Hayes. 1997. Ephemerons: a new finalization mechanism. In <i>Proceedings of the 12th ACM SIGPLAN conference on
        Object-oriented programming, systems, languages, and applications (OOPSLA '97)</i>, A. Michael Berman (Ed.). ACM, New
        York, NY, USA, 176-183, <a href="http://doi.acm.org/10.1145/263698.263733">http://doi.acm.org/10.1145/263698.263733</a>.</p>

        <p>Alexandra Barros, Roberto Ierusalimschy, Eliminating Cycles in Weak Tables. Journal of Universal Computer Science -
        J.UCS , vol. 14, no. 21, pp. 3481-3497, 2008, <a href="http://www.jucs.org/jucs_14_21/eliminating_cycles_in_weak">http://www.jucs.org/jucs_14_21/eliminating_cycles_in_weak</a></p>
      </div>
    </div>

    <section id="sec-weakmap-constructor">
      <div class="front">
        <h3 id="sec-23.3.1" title="23.3.1">
            The WeakMap Constructor</h3><p>The WeakMap constructor is the %WeakMap% intrinsic object and the initial value of the <code>WeakMap</code> property of
        the global object. When called as a constructor it creates and initializes a new WeakMap object. <code>WeakMap</code> is
        not intended to be called as a function and will throw an exception when called in that manner.</p>

        <p>The <code>WeakMap</code> constructor is designed to be subclassable. It may be used as the value in an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>WeakMap</code> behaviour must include a <code>super</code> call to the <code>WeakMap</code> constructor to create
        and initialize the subclass instance with the internal state necessary to support the <code><a href="#sec-weakmap.prototype">WeakMap.prototype</a></code> built-in methods.</p>
      </div>

      <section id="sec-weakmap-iterable">
        <h4 id="sec-23.3.1.1" title="23.3.1.1"> WeakMap ( [ iterable ] )</h4><p class="normalbefore">When the <code>WeakMap</code> function is called with optional argument <var>iterable</var> the
        following steps are taken:</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>map</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
              <code>"%WeakMapPrototype%"</code>, &laquo;&zwj;[[WeakMapData]]&raquo; ).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>map</i>).</li>
          <li>Set <i>map&rsquo;s</i> [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>
              to a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>If <i>iterable</i> is not present, let <i>iterable</i> be <b>undefined</b>.</li>
          <li>If <i>iterable</i> is either <b>undefined</b> or <b>null</b>, let <i>iter</i> be <b>undefined</b>.</li>
          <li>Else,
            <ol class="block">
              <li>Let <i>adder</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>map</i>, <code>"set"</code>)<b>.</b></li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>adder</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>adder</i>) is <b>false</b>, throw a <b>TypeError</b>
                  exception.</li>
              <li>Let <i>iter</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>iterable</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iter</i>).</li>
            </ol>
          </li>
          <li>If <i>iter</i> is <b>undefined</b>, return <i>map</i>.</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iter</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, return <i>map</i>.</li>
              <li>Let <i>nextItem</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextItem</i>).</li>
              <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>nextItem</i>) is not Object,
                <ol class="block">
                  <li>Let <i>error</i> be <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion</a>{[[type]]: <span style="font-family: sans-serif">throw</span>, [[value]]: a newly created <b>TypeError</b> object,
                      [[target]]:<span style="font-family: sans-serif">empty</span>}.</li>
                  <li>Return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iter</i>, <i>error</i>).</li>
                </ol>
              </li>
              <li>Let <i>k</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>nextItem</i>, <code>"0"</code>).</li>
              <li>If <i>k</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iter</i>, <i>k</i>).</li>
              <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>nextItem</i>, <code>"1"</code>).</li>
              <li>If <i>v</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iter</i>, <i>v</i>).</li>
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>adder</i>, <i>map</i>, &laquo;<i>k</i>.[[value]],
                  <i>v</i>.[[value]]&raquo;).</li>
              <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iter</i>, <i>status</i>).</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> If the parameter <var>iterable</var> is present, it is expected to be an object that
          implements an <span style="font-family: Times New Roman">@@iterator</span> method that returns an iterator object that
          produces a two element array-like object whose first element is a value that will be used as a WeakMap key and whose
          second element is the value to associate with that key.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-weakmap-constructor">
      <div class="front">
        <h3 id="sec-23.3.2" title="23.3.2"> Properties of the WeakMap Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        WeakMap constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is <b>0</b>), the WeakMap constructor has the following
        properties:</p>
      </div>

      <section id="sec-weakmap.prototype">
        <h4 id="sec-23.3.2.1" title="23.3.2.1"> WeakMap.prototype</h4><p>The initial value of <code>WeakMap.prototype</code> is the intrinsic object %WeakMapPrototype% (<a href="#sec-properties-of-the-weakmap-prototype-object">23.3.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-weakmap-prototype-object">
      <div class="front">
        <h3 id="sec-23.3.3" title="23.3.3"> Properties of the WeakMap Prototype Object</h3><p>The WeakMap prototype object is the intrinsic object %WeakMapPrototype%. The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the WeakMap prototype object is the intrinsic
        object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>). The WeakMap prototype
        object is an ordinary object. It does not have a [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
      </div>

      <section id="sec-weakmap.prototype.constructor">
        <h4 id="sec-23.3.3.1" title="23.3.3.1"> WeakMap.prototype.constructor</h4><p>The initial value of <code>WeakMap.prototype.constructor</code> is the intrinsic object %WeakMap%.</p>
      </section>

      <section id="sec-weakmap.prototype.delete">
        <h4 id="sec-23.3.3.2" title="23.3.3.2"> WeakMap.prototype.delete ( key )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>key</i>) is not Object, return <b>false</b>.</li>
          <li>Repeat for each Record {[[key]], [[value]]} <i>p</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>p</i>.[[key]] is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>p</i>.[[key]], <i>key</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Set <i>p</i>.[[key]] to <span style="font-family: sans-serif">empty</span><i>.</i></li>
                  <li>Set <i>p</i>.[[value]] to <span style="font-family: sans-serif">empty</span><i>.</i></li>
                  <li>Return <b>true</b>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <b>false</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The value <b>empty</b> is used as a specification device to indicate that an entry has
          been deleted. Actual implementations may take other actions such as physically removing the entry from internal data
          structures.</p>
        </div>
      </section>

      <section id="sec-weakmap.prototype.get">
        <h4 id="sec-23.3.3.3" title="23.3.3.3"> WeakMap.prototype.get ( key )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>key</i>) is not Object, return
              <b>undefined</b>.</li>
          <li>Repeat for each Record {[[key]], [[value]]} <i>p</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>p</i>.[[key]] is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>p</i>.[[key]], <i>key</i>) is <b>true</b>, return
                  <i>p</i>.[[value]].</li>
            </ol>
          </li>
          <li>Return  <b>undefined</b><i>.</i></li>
        </ol>
      </section>

      <section id="sec-weakmap.prototype.has">
        <h4 id="sec-23.3.3.4" title="23.3.3.4"> WeakMap.prototype.has ( key )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>key</i>) is not Object, return <b>false</b>.</li>
          <li>Repeat for each Record {[[key]], [[value]]} <i>p</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>p</i>.[[key]] is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>p</i>.[[key]], <i>key</i>) is <b>true</b>, return
                  <b>true</b><i>.</i></li>
            </ol>
          </li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-weakmap.prototype.set">
        <h4 id="sec-23.3.3.5" title="23.3.3.5"> WeakMap.prototype.set ( key , value )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>M</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>M</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>M</i> does not have a [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>M</i>&rsquo;s [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>key</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Repeat for each Record {[[key]], [[value]]} <i>p</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>p</i>.[[key]] is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>p</i>.[[key]], <i>key</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Set <i>p</i>.[[value]] to <i>value.</i></li>
                  <li>Return <i>M</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>p</i> be the Record {[[key]]: <i>key</i>, [[value]]: <i>value</i>}.</li>
          <li>Append <i>p</i> as the last element of <i>entries</i>.</li>
          <li>Return <i>M</i>.</li>
        </ol>
      </section>

      <section id="sec-weakmap.prototype-@@tostringtag">
        <h4 id="sec-23.3.3.6" title="23.3.3.6"> WeakMap.prototype [ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"WeakMap"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-weakmap-instances">
      <h3 id="sec-23.3.4" title="23.3.4"> Properties of WeakMap Instances</h3><p>WeakMap instances are ordinary objects that inherit properties from the WeakMap prototype. WeakMap instances also have a
      [[WeakMapData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
    </section>
  </section>

  <section id="sec-weakset-objects">
    <div class="front">
      <h2 id="sec-23.4" title="23.4"> WeakSet
          Objects</h2><p>WeakSet objects are collections of objects. A distinct object may only occur once as an element of a WeakSet&rsquo;s
      collection. A WeakSet may be queried to see if it contains a specific object, but no mechanism is provided for enumerating
      the objects it holds. If an object that is contained by a WeakSet is only reachable by following a chain of references that
      start within that WeakSet, then that object is inaccessible and is automatically removed from the WeakSet. WeakSet
      implementations must detect and remove such objects and any associated resources.</p>

      <p>An implementation may impose an arbitrarily determined latency between the time an object contained in a WeakSet becomes
      inaccessible and the time when the object is removed from the WeakSet. If this latency was observable to ECMAScript program,
      it would be a source of indeterminacy that could impact program execution. For that reason, an ECMAScript implementation
      must not provide any means to determine if a WeakSet contains a particular object that does not require the observer to
      present the observed object.</p>

      <p>WeakSet objects must be implemented using either hash tables or other mechanisms that, on average, provide access times
      that are sublinear on the number of elements in the collection. The data structure used in this WeakSet objects
      specification is only intended to describe the required observable semantics of WeakSet objects. It is not intended to be a
      viable implementation model.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> See the NOTE in <a href="#sec-weakmap-objects">23.3</a>.</p>
      </div>
    </div>

    <section id="sec-weakset-constructor">
      <div class="front">
        <h3 id="sec-23.4.1" title="23.4.1">
            The WeakSet Constructor</h3><p>The WeakSet constructor is the %WeakSet% intrinsic object and the initial value of the <code>WeakSet</code> property of
        the global object. When called as a constructor it creates and initializes a new WeakSet object. <code>WeakSet</code> is
        not intended to be called as a function and will throw an exception when called in that manner.</p>

        <p>The <code>WeakSet</code> constructor is designed to be subclassable. It may be used as the value in an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>WeakSet</code> behaviour must include a <code>super</code> call to the <code>WeakSet</code> constructor to create
        and initialize the subclass instance with the internal state necessary to support the <code><a href="#sec-weakset.prototype">WeakSet.prototype</a></code> built-in methods.</p>
      </div>

      <section id="sec-weakset-iterable">
        <h4 id="sec-23.4.1.1" title="23.4.1.1"> WeakSet ( [ iterable ] )</h4><p class="normalbefore">When the <code>WeakSet</code> function is called with optional argument <var>iterable</var> the
        following steps are taken:</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>set</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
              <code>"%WeakSetPrototype%"</code>, &laquo;&zwj;[[WeakSetData]]&raquo; ).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>set</i>).</li>
          <li>Set <i>set&rsquo;s</i> [[WeakSetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>
              to a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>If <i>iterable</i> is not present, let <i>iterable</i> be <b>undefined</b>.</li>
          <li>If <i>iterable</i> is either <b>undefined</b> or <b>null</b>, let <i>iter</i> be <b>undefined</b>.</li>
          <li>Else,
            <ol class="block">
              <li>Let <i>adder</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>set</i>, <code>"add"</code>)<b>.</b></li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>adder</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>adder</i>) is <b>false</b>, throw a <b>TypeError</b>
                  exception.</li>
              <li>Let <i>iter</i> be <a href="sec-abstract-operations#sec-getiterator">GetIterator</a>(<i>iterable</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>iter</i>).</li>
            </ol>
          </li>
          <li>If <i>iter</i> is <b>undefined</b>, return <i>set</i>.</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>next</i> be <a href="sec-abstract-operations#sec-iteratorstep">IteratorStep</a>(<i>iter</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>next</i>).</li>
              <li>If <i>next</i> is <b>false</b>, return <i>set</i>.</li>
              <li>Let <i>nextValue</i> be <a href="sec-abstract-operations#sec-iteratorvalue">IteratorValue</a>(<i>next</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextValue</i>).</li>
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>adder</i>, <i>set</i>, &laquo;<i>nextValue</i>
                  &raquo;).</li>
              <li>If <i>status</i> is an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>, return <a href="sec-abstract-operations#sec-iteratorclose">IteratorClose</a>(<i>iter</i>, <i>status</i>).</li>
            </ol>
          </li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-weakset-constructor">
      <div class="front">
        <h3 id="sec-23.4.2" title="23.4.2"> Properties of the WeakSet Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        WeakSet constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is <b>0</b>), the WeakSet constructor has the following
        properties:</p>
      </div>

      <section id="sec-weakset.prototype">
        <h4 id="sec-23.4.2.1" title="23.4.2.1"> WeakSet.prototype</h4><p>The initial value of <code>WeakSet.prototype</code> is the intrinsic %WeakSetPrototype% object (<a href="#sec-properties-of-the-weakset-prototype-object">23.4.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-weakset-prototype-object">
      <div class="front">
        <h3 id="sec-23.4.3" title="23.4.3"> Properties of the WeakSet Prototype Object</h3><p>The WeakSet prototype object is the intrinsic object %WeakSetPrototype%. The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the WeakSet prototype object is the intrinsic
        object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>). The WeakSet prototype
        object is an ordinary object. It does not have a [[WeakSetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
      </div>

      <section id="sec-weakset.prototype.add">
        <h4 id="sec-23.4.3.1" title="23.4.3.1"> WeakSet.prototype.add ( value )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>S</i> does not have a [[WeakSetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>S</i>&rsquo;s [[WeakSetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each <i>e</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>e</i> is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>e</i>, <i>value</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Return <i>S</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Append <i>value</i> as the last element of <i>entries</i>.</li>
          <li>Return <i>S</i>.</li>
        </ol>
      </section>

      <section id="sec-weakset.prototype.constructor">
        <h4 id="sec-23.4.3.2" title="23.4.3.2"> WeakSet.prototype.constructor</h4><p>The initial value of <code>WeakSet.prototype.constructor</code> is the %WeakSet% intrinsic object.</p>
      </section>

      <section id="sec-weakset.prototype.delete">
        <h4 id="sec-23.4.3.3" title="23.4.3.3"> WeakSet.prototype.delete ( value )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>S</i> does not have a [[WeakSetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is not Object, return <b>false</b>.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>S</i>&rsquo;s [[WeakSetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Repeat for each  <i>e</i> that is an element of <i>entries</i>,
            <ol class="block">
              <li>If <i>e</i> is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>e</i>, <i>value</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Replace the element of <i>entries</i> whose value is <i>e</i> with an element whose value is <span style="font-family: sans-serif">empty</span><i>.</i></li>
                  <li>Return <b>true</b>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <b>false</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The value <b>empty</b> is used as a specification device to indicate that an entry has
          been deleted. Actual implementations may take other actions such as physically removing the entry from internal data
          structures.</p>
        </div>
      </section>

      <section id="sec-weakset.prototype.has">
        <h4 id="sec-23.4.3.4" title="23.4.3.4"> WeakSet.prototype.has ( value )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>S</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>S</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>S</i> does not have a [[WeakSetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>entries</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is the value of
              <i>S</i>&rsquo;s [[WeakSetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is not Object, return <b>false.</b></li>
          <li>Repeat for each <i>e</i> that is an element of <i>entries,</i>
            <ol class="block">
              <li>If <i>e</i> is not <span style="font-family: sans-serif">empty</span> and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>e</i>, <i>value</i>) is <b>true</b>, return <b>true</b><i>.</i></li>
            </ol>
          </li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-weakset.prototype-@@tostringtag">
        <h4 id="sec-23.4.3.5" title="23.4.3.5"> WeakSet.prototype [ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"WeakSet"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-weakset-instances">
      <h3 id="sec-23.4.4" title="23.4.4"> Properties of WeakSet Instances</h3><p>WeakSet instances are ordinary objects that inherit properties from the WeakSet prototype. WeakSet instances also have a
      [[WeakSetData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
    </section>
  </section>
</section>

