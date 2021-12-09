<section id="sec-fundamental-objects">
  <div class="front">
    <h1 id="sec-19" title="19"> Fundamental
        Objects</h1></div>

  <section id="sec-object-objects">
    <div class="front">
      <h2 id="sec-19.1" title="19.1"> Object
          Objects</h2></div>

    <section id="sec-object-constructor">
      <div class="front">
        <h3 id="sec-19.1.1" title="19.1.1">
            The Object Constructor</h3><p>The Object constructor is the %Object% intrinsic object and the initial value of the <code>Object</code> property of
        the global object. When called as a constructor it creates a new ordinary object. When <code>Object</code> is called as a
        function rather than as a constructor, it performs a type conversion.</p>

        <p>The <code>Object</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition.</p>
      </div>

      <section id="sec-object-value">
        <h4 id="sec-19.1.1.1" title="19.1.1.1">
            Object ( [ value ] )</h4><p class="normalbefore">When <code>Object</code> function is called with optional argument <var>value</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>If NewTarget is neither <b>undefined</b> nor the active function<i>,</i> then
            <ol class="block">
              <li>Return <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
                  <code>"%ObjectPrototype%"</code>).</li>
            </ol>
          </li>
          <li>If <i>value</i> is <b>null</b>, <b>undefined</b> or not supplied, return <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(%ObjectPrototype%).</li>
          <li>Return <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>value</i>).</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-object-constructor">
      <div class="front">
        <h3 id="sec-19.1.2" title="19.1.2"> Properties of the Object Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Object constructor is the intrinsic object %FunctionPrototype%.</p>

        <p>Besides the <code>length</code> property (whose value is <b>1</b>), the Object constructor has the following
        properties:</p>
      </div>

      <section id="sec-object.assign">
        <h4 id="sec-19.1.2.1" title="19.1.2.1">
            Object.assign ( target, ...sources )</h4><p class="normalbefore">The <b>assign</b> function is used to copy the values of all of the enumerable own properties from
        one or more source objects to a <var>target</var> object. When the <b>assign</b> function is called, the following steps
        are taken:</p>

        <ol class="proc">
          <li>Let <i>to</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>target</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>to</i>).</li>
          <li>If only one argument was passed, return <i>to</i>.</li>
          <li>Let <i>sources</i> be the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of argument values starting
              with the second argument.</li>
          <li>For each element <i>nextSource</i> of <i>sources</i>, in ascending index order,
            <ol class="block">
              <li>If <i>nextSource</i> is <b>undefined</b> or <b>null</b>, let <i>keys</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>from</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>nextSource</i>).</li>
                  <li>Let <i>keys</i> be <i>from</i>.[[OwnPropertyKeys]]().</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keys</i>).</li>
                </ol>
              </li>
              <li>Repeat for each element <i>nextKey</i> of <i>keys</i> in <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> order,
                <ol class="block">
                  <li>Let <i>desc</i> be <i>from</i>.[[GetOwnProperty]](<i>nextKey</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
                  <li>if <i>desc</i> is not <b>undefined</b> and <i>desc</i>.[[Enumerable]] is <b>true</b>, then
                    <ol class="block">
                      <li>Let <i>propValue</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>from</i>, <i>nextKey</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propValue</i>).</li>
                      <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>to</i>, <i>nextKey</i>, <i>propValue</i>,
                          <b>true</b>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                    </ol>
                  </li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <i>to</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>assign</code> method is <b>2</b>.</p>
      </section>

      <section id="sec-object.create">
        <h4 id="sec-19.1.2.2" title="19.1.2.2">
            Object.create ( O [ , Properties ] )</h4><p class="normalbefore">The <b>create</b> function creates a new object with a specified prototype. When the <b>create</b>
        function is called, the following steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is neither Object nor Null, throw a
              <b>TypeError</b> exception.</li>
          <li>Let <i>obj</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<i>O</i>).</li>
          <li>If the argument <i>Properties</i> is present and not <b>undefined</b>, then
            <ol class="block">
              <li>Return <a href="#sec-objectdefineproperties">ObjectDefineProperties</a>(<i>obj</i>, <i>Properties</i>).</li>
            </ol>
          </li>
          <li>Return <i>obj</i>.</li>
        </ol>
      </section>

      <section id="sec-object.defineproperties">
        <div class="front">
          <h4 id="sec-19.1.2.3" title="19.1.2.3"> Object.defineProperties ( O, Properties )</h4><p class="normalbefore">The <b>defineProperties</b> function is used to add own properties and/or update the attributes
          of existing own properties of an object. When the <b>defineProperties</b> function is called, the following steps are
          taken:</p>

          <ol class="proc">
            <li>Return <a href="#sec-objectdefineproperties">ObjectDefineProperties</a>(<i>O</i>, <i>Properties</i>).</li>
          </ol>
        </div>

        <section id="sec-objectdefineproperties">
          <h5 id="sec-19.1.2.3.1" title="19.1.2.3.1"> Runtime Semantics: ObjectDefineProperties ( O, Properties )</h5><p class="normalbefore">The abstract operation ObjectDefineProperties with arguments <var>O</var> and <span class="nt">Properties</span> performs the following steps:</p>

          <ol class="proc">
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
                exception.</li>
            <li>Let <i>props</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>Properties</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>props</i>).</li>
            <li>Let <i>keys</i> be <i>props</i>.[[OwnPropertyKeys]]().</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keys</i>).</li>
            <li>Let <i>descriptors</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>Repeat for each element <i>nextKey</i> of <i>keys</i> in <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> order,
              <ol class="block">
                <li>Let <i>propDesc</i> be <i>props</i>.[[GetOwnProperty]](<i>nextKey</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>propDesc</i>).</li>
                <li>If <i>propDesc</i> is not <b>undefined</b> and <i>propDesc</i>.[[Enumerable]] is <b>true</b>, then
                  <ol class="block">
                    <li>Let <i>descObj</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>( <i>props</i>, <i>nextKey</i>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>descObj</i>).</li>
                    <li>Let <i>desc</i> be <a href="sec-ecmascript-data-types-and-values#sec-topropertydescriptor">ToPropertyDescriptor</a>(<i>descObj</i>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
                    <li>Append the pair (a two element <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>) consisting of
                        <i>nextKey</i> and <i>desc</i> to the end of <i>descriptors</i>.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>For each <i>pair</i> from <i>descriptors</i> in list order,
              <ol class="block">
                <li>Let <i>P</i> be the first element of <i>pair</i>.</li>
                <li>Let <i>desc</i> be the second element of <i>pair</i>.</li>
                <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>O</i>,<i>P</i>,
                    <i>desc</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
              </ol>
            </li>
            <li>Return <i>O</i>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-object.defineproperty">
        <h4 id="sec-19.1.2.4" title="19.1.2.4"> Object.defineProperty ( O, P, Attributes )</h4><p class="normalbefore">The <b>defineProperty</b> function is used to add an own property and/or update the attributes of
        an existing own property of an object. When the <b>defineProperty</b> function is called, the following steps are
        taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>key</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>P</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>key</i>).</li>
          <li>Let <i>desc</i> be <a href="sec-ecmascript-data-types-and-values#sec-topropertydescriptor">ToPropertyDescriptor</a>(<i>Attributes</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
          <li>Let <i>success</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>O,key</i>,
              <i>desc</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>success</i>).</li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>

      <section id="sec-object.freeze">
        <h4 id="sec-19.1.2.5" title="19.1.2.5">
            Object.freeze ( O )</h4><p class="normalbefore">When the <b>freeze</b> function is called, the following steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <i>O</i>.</li>
          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-setintegritylevel">SetIntegrityLevel</a>( <i>O</i>, "<code>frozen</code>").</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>If <i>status</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>

      <section id="sec-object.getownpropertydescriptor">
        <h4 id="sec-19.1.2.6" title="19.1.2.6"> Object.getOwnPropertyDescriptor ( O, P )</h4><p class="normalbefore">When the <code>getOwnPropertyDescriptor</code> function is called, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>obj</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>obj</i>).</li>
          <li>Let <i>key</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>P</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>key</i>).</li>
          <li>Let <i>desc</i> be <i>obj.</i>[[GetOwnProperty]](<i>key</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-frompropertydescriptor">FromPropertyDescriptor</a>(<i>desc</i>).</li>
        </ol>
      </section>

      <section id="sec-object.getownpropertynames">
        <h4 id="sec-19.1.2.7" title="19.1.2.7"> Object.getOwnPropertyNames ( O )</h4><p class="normalbefore">When the <b>getOwnPropertyNames</b> function is called, the following steps are taken:</p>

        <ol class="proc">
          <li>Return <a href="#sec-getownpropertykeys">GetOwnPropertyKeys</a>(<i>O</i>, String).</li>
        </ol>
      </section>

      <section id="sec-object.getownpropertysymbols">
        <div class="front">
          <h4 id="sec-19.1.2.8" title="19.1.2.8"> Object.getOwnPropertySymbols ( O )</h4><p class="normalbefore">When the <b>getOwnPropertySymbols</b> function is called with argument <var>O</var>, the
          following steps are taken:</p>

          <ol class="proc">
            <li>Return <a href="#sec-getownpropertykeys">GetOwnPropertyKeys</a>(<i>O</i>, Symbol).</li>
          </ol>
        </div>

        <section id="sec-getownpropertykeys">
          <h5 id="sec-19.1.2.8.1" title="19.1.2.8.1"> Runtime Semantics:  GetOwnPropertyKeys ( O, Type )</h5><p class="normalbefore">The abstract operation GetOwnPropertyKeys is called with arguments <var>O</var> and <span class="nt">Type</span> where <var>O</var> is an Object and <span class="nt">Type</span> is one of the ECMAScript
          specification types String or Symbol. The following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>obj</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>O</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>obj</i>).</li>
            <li>Let <i>keys</i> be <i>obj.</i>[[OwnPropertyKeys]]().</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keys</i>).</li>
            <li>Let <i>nameList</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>Repeat for each element <i>nextKey</i> of <i>keys</i> in <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> order,
              <ol class="block">
                <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>nextKey</i>) is <i>Type</i>, then
                  <ol class="block">
                    <li>Append <i>nextKey</i> as the last element of <i>nameList</i>.</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Return <a href="sec-abstract-operations#sec-createarrayfromlist">CreateArrayFromList</a>(<i>nameList</i>).</li>
          </ol>
        </section>
      </section>

      <section id="sec-object.getprototypeof">
        <h4 id="sec-19.1.2.9" title="19.1.2.9"> Object.getPrototypeOf ( O )</h4><p class="normalbefore">When the <code>getPrototypeOf</code> function is called with argument <var>O</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>obj</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>obj</i>).</li>
          <li>Return <i>obj.</i>[[GetPrototypeOf]]().</li>
        </ol>
      </section>

      <section id="sec-object.is">
        <h4 id="sec-19.1.2.10" title="19.1.2.10">
            Object.is ( value1, value2 )</h4><p class="normalbefore">When the <b>is</b> function is called with arguments <var>value1</var> and <var>value2</var> the
        following steps are taken:</p>

        <ol class="proc">
          <li>Return <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>value1</i>, <i>value2</i>).</li>
        </ol>
      </section>

      <section id="sec-object.isextensible">
        <h4 id="sec-19.1.2.11" title="19.1.2.11"> Object.isExtensible ( O )</h4><p class="normalbefore">When the <b>isExtensible</b> function is called with argument <var>O</var>, the following steps
        are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <b>false</b>.</li>
          <li>Return <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>O</i>).</li>
        </ol>
      </section>

      <section id="sec-object.isfrozen">
        <h4 id="sec-19.1.2.12" title="19.1.2.12"> Object.isFrozen ( O )</h4><p class="normalbefore">When the <b>isFrozen</b> function is called with argument <var>O</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <b>true</b>.</li>
          <li>Return <a href="sec-abstract-operations#sec-testintegritylevel">TestIntegrityLevel</a>(<i>O</i>, "<code>frozen</code>").</li>
        </ol>
      </section>

      <section id="sec-object.issealed">
        <h4 id="sec-19.1.2.13" title="19.1.2.13"> Object.isSealed ( O )</h4><p class="normalbefore">When the <b>isSealed</b> function is called with argument <var>O</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <b>true</b>.</li>
          <li>Return <a href="sec-abstract-operations#sec-testintegritylevel">TestIntegrityLevel</a>(<i>O</i>, "<code>sealed</code>").</li>
        </ol>
      </section>

      <section id="sec-object.keys">
        <h4 id="sec-19.1.2.14" title="19.1.2.14">
            Object.keys ( O )</h4><p class="normalbefore">When the <b>keys</b> function is called with argument <var>O</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>obj</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>obj</i>).</li>
          <li>Let <i>nameList</i> be <a href="sec-abstract-operations#sec-enumerableownnames">EnumerableOwnNames</a>(<i>obj</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nameList</i>).</li>
          <li>Return <a href="sec-abstract-operations#sec-createarrayfromlist">CreateArrayFromList</a>(<i>nameList</i>).</li>
        </ol>

        <p>If an implementation defines a specific order of enumeration for the for-in statement, the same order must be used for
        the elements of the array returned in step 4.</p>
      </section>

      <section id="sec-object.preventextensions">
        <h4 id="sec-19.1.2.15" title="19.1.2.15"> Object.preventExtensions ( O )</h4><p class="normalbefore">When the <b>preventExtensions</b> function is called, the following steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <i>O</i>.</li>
          <li>Let <i>status</i> be <i>O</i>.[[PreventExtensions]]().</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>If <i>status</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>

      <section id="sec-object.prototype">
        <h4 id="sec-19.1.2.16" title="19.1.2.16"> Object.prototype</h4><p>The initial value of <code>Object.prototype</code> is the intrinsic object %ObjectPrototype% (<a href="#sec-properties-of-the-object-prototype-object">19.1.3</a>).</p>

        <p>This property has the attributes {[[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-object.seal">
        <h4 id="sec-19.1.2.17" title="19.1.2.17">
            Object.seal ( O )</h4><p class="normalbefore">When the <b>seal</b> function is called, the following steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <i>O</i>.</li>
          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-setintegritylevel">SetIntegrityLevel</a>( <i>O</i>,  "<code>sealed</code>").</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>If <i>status</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>

      <section id="sec-object.setprototypeof">
        <h4 id="sec-19.1.2.18" title="19.1.2.18"> Object.setPrototypeOf ( O, proto )</h4><p class="normalbefore">When the <code>setPrototypeOf</code> function is called with arguments <span style="font-family:         Times New Roman"><i>O</i> and</span> proto, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-requireobjectcoercible">RequireObjectCoercible</a>(<i>O</i>)<i>.</i></li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>proto</i>) is neither Object nor Null, throw a
              <b>TypeError</b> exception.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, return <i>O</i>.</li>
          <li>Let <i>status</i> be <i>O</i>.[[SetPrototypeOf]](<i>proto</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
          <li>If <i>status</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-object-prototype-object">
      <div class="front">
        <h3 id="sec-19.1.3" title="19.1.3"> Properties of the Object Prototype Object</h3><p>The Object prototype object is the intrinsic object %ObjectPrototype%. The Object prototype object is an ordinary
        object.</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Object prototype object is <span class="value">null</span> and the initial value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is <span class="value">true</span>.</p>
      </div>

      <section id="sec-object.prototype.constructor">
        <h4 id="sec-19.1.3.1" title="19.1.3.1"> Object.prototype.constructor</h4><p>The initial value of <code>Object.prototype.constructor</code> is the intrinsic object %Object%.</p>
      </section>

      <section id="sec-object.prototype.hasownproperty">
        <h4 id="sec-19.1.3.2" title="19.1.3.2"> Object.prototype.hasOwnProperty ( V )</h4><p class="normalbefore">When the <code>hasOwnProperty</code> method is called with argument <var>V</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>P</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>V</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>P</i>).</li>
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Return <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>O</i>, <i>P</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The ordering of steps 1 and 3 is chosen to ensure that any exception that would have
          been thrown by step 1 in previous editions of this specification will continue to be thrown even if the <b>this</b>
          value is <span class="value">undefined</span> or <span class="value">null</span>.</p>
        </div>
      </section>

      <section id="sec-object.prototype.isprototypeof">
        <h4 id="sec-19.1.3.3" title="19.1.3.3"> Object.prototype.isPrototypeOf ( V )</h4><p class="normalbefore">When the <code>isPrototypeOf</code> method is called with argument <var>V</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>V</i>) is not Object, return <b>false</b>.</li>
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Repeat
            <ol class="block">
              <li>Let <i>V</i> be <i>V</i>.[[GetPrototypeOf]]().</li>
              <li>If <i>V</i> is <b>null</b>, return <b>false</b></li>
              <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>O</i>, <i>V</i>) is <b>true</b>, return <b>true</b>.</li>
            </ol>
          </li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The ordering of steps 1 and 2 preserves the behaviour specified by previous editions of
          this specification for the case where <var>V</var> is not an object and the <b>this</b> value is <span class="value">undefined</span> or <span class="value">null</span>.</p>
        </div>
      </section>

      <section id="sec-object.prototype.propertyisenumerable">
        <h4 id="sec-19.1.3.4" title="19.1.3.4"> Object.prototype.propertyIsEnumerable ( V )</h4><p class="normalbefore">When the <code>propertyIsEnumerable</code> method is called with argument <var>V</var>, the
        following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>P</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>V</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>P</i>).</li>
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Let <i>desc</i> be <i>O</i>.[[GetOwnProperty]](<i>P</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
          <li>If <i>desc</i> is <b>undefined</b>, return <b>false</b>.</li>
          <li>Return the value of <i>desc</i>.[[Enumerable]].</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 1</span> This method does not consider objects in the prototype chain.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The ordering of steps 1 and 3 is chosen to ensure that any exception that would have
          been thrown by step 1 in previous editions of this specification will continue to be thrown even if the <b>this</b>
          value is <span class="value">undefined</span> or <span class="value">null</span>.</p>
        </div>
      </section>

      <section id="sec-object.prototype.tolocalestring">
        <h4 id="sec-19.1.3.5" title="19.1.3.5"> Object.prototype.toLocaleString ( [ reserved1 [ , reserved2 ] ]
            )</h4><p class="normalbefore">When the <b>toLocaleString</b> method is called, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>Return <a href="sec-abstract-operations#sec-invoke">Invoke</a>(<i>O</i>, <code>"toString"</code>).</li>
        </ol>

        <p>The optional parameters to this function are not used but are intended to correspond to the parameter pattern used by
        ECMA-402 <code>toLocalString</code> functions. Implementations that do not include ECMA-402 support must not use those
        parameter positions for other purposes.</p>

        <p>The <code>length</code> property of the <code>toLocaleString</code> method is <b>0</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> This function provides a generic <code>toLocaleString</code> implementation for
          objects that have no locale-specific <code>toString</code> behaviour. <code>Array</code>, <code>Number</code>,
          <code>Date</code>, and <code>Typed Arrays</code> provide their own locale-sensitive <code>toLocaleString</code>
          methods.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> ECMA-402 intentionally does not provide an alternative to this default
          implementation.</p>
        </div>
      </section>

      <section id="sec-object.prototype.tostring">
        <h4 id="sec-19.1.3.6" title="19.1.3.6"> Object.prototype.toString ( )</h4><p class="normalbefore">When the <code>toString</code> method is called, the following steps are taken:</p>

        <ol class="proc">
          <li>If the <b>this</b> value is <b>undefined</b>, return <code>"[object Undefined]"</code>.</li>
          <li>If the <b>this</b> value is <b>null</b>, return <code>"[object Null]"</code>.</li>
          <li>Let <i>O</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
          <li>Let <i>isArray</i> be <a href="sec-abstract-operations#sec-isarray">IsArray</a>(<i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>isArray</i>).</li>
          <li>If <i>isArray</i> is <b>true</b>, let <i>builtinTag</i> be <code>"Array"</code>.</li>
          <li>Else, if <i>O</i> is an exotic String object, let <i>builtinTag</i> be <code>"String"</code>.</li>
          <li>Else, if <i>O</i> has an [[ParameterMap]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, let <i>builtinTag</i> be <code>"Arguments"</code>.</li>
          <li>Else, if <i>O</i> has a [[Call]] internal method, let <i>builtinTag</i> be <code>"Function"</code>.</li>
          <li>Else, if <i>O</i> has an [[ErrorData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              let <i>builtinTag</i> be <code>"Error"</code>.</li>
          <li>Else, if <i>O</i> has a [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              let <i>builtinTag</i> be <code>"Boolean"</code>.</li>
          <li>Else, if <i>O</i> has a [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              let <i>builtinTag</i> be <code>"Number"</code>.</li>
          <li>Else, if <i>O</i> has a [[DateValue]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              let <i>builtinTag</i> be <code>"Date"</code>.</li>
          <li>Else, if <i>O</i> has a [[RegExpMatcher]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, let <i>builtinTag</i> be <code>"RegExp"</code>.</li>
          <li>Else, let <i>builtinTag</i> be <code>"Object"</code>.</li>
          <li>Let <i>tag</i> be Get (<i>O</i>, @@toStringTag).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>tag</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>tag</i>) is not String, let <i>tag</i> be
              <i>builtinTag</i>.</li>
          <li>Return the String that is the result of concatenating <code>"[object "</code>, <i>tag</i>, and
              <code>"]"</code>.</li>
        </ol>

        <p>This function is the %ObjProto_toString% intrinsic object.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Historically, this function was occasionally used to access the String value of the
          [[Class]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> that was used in previous editions
          of this specification as a nominal type tag for various built-in objects. The above definition of <code>toString</code>
          preserves compatibility for legacy code that uses <code>toString</code> as a test for those specific kinds of built-in
          objects. It does not provide a reliable type testing mechanism for other kinds of built-in or program defined objects.
          In addition, programs can use @@toStringTag in ways that will invalidate the reliability of such legacy type tests.</p>
        </div>
      </section>

      <section id="sec-object.prototype.valueof">
        <h4 id="sec-19.1.3.7" title="19.1.3.7"> Object.prototype.valueOf ( )</h4><p class="normalbefore">When the <b>valueOf</b> method is called, the following steps are taken:</p>

        <ol class="proc">
          <li>Return <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<b>this</b> value).</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-object-instances">
      <h3 id="sec-19.1.4" title="19.1.4"> Properties of Object Instances</h3><p>Object instances have no special properties beyond those inherited from the Object prototype object.</p>
    </section>
  </section>

  <section id="sec-function-objects">
    <div class="front">
      <h2 id="sec-19.2" title="19.2"> Function
          Objects</h2></div>

    <section id="sec-function-constructor">
      <div class="front">
        <h3 id="sec-19.2.1" title="19.2.1"> The Function Constructor</h3><p>The Function constructor is the %Function% intrinsic object and the initial value of the <code>Function</code> property
        of the global object. When <code>Function</code> is called as a function rather than as a constructor, it creates and
        initializes a new Function object. Thus the function call <code><b>Function(</b>&hellip;<b>)</b></code> is equivalent to
        the object creation expression <code><b>new Function(</b>&hellip;<b>)</b></code> with the same arguments.</p>

        <p>The <code>Function</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>Function</code> behaviour must include a <code>super</code> call to the <code>Function</code> constructor to create
        and initialize a subclass instances with the internal slots necessary for built-in function behaviour. All ECMAScript
        syntactic forms for defining function objects create instances of <code>Function</code>. There is no syntactic means to
        create instances of <code>Function</code> subclasses except for the built-in Generator Function subclass.</p>
      </div>

      <section id="sec-function-p1-p2-pn-body">
        <div class="front">
          <h4 id="sec-19.2.1.1" title="19.2.1.1"> Function ( p1, p2, &hellip; , pn, body )</h4><p>The last argument specifies the body (executable code) of a function; any preceding arguments specify formal
          parameters.</p>

          <p class="normalbefore">When the <code>Function</code> function is called with some arguments <var>p1</var>,
          <var>p2</var>, &hellip; , <var>pn</var>, <var>body</var> (where <var>n</var> might be <span style="font-family: Times           New Roman">0</span>, that is, there are no &ldquo;<var>p</var>&rdquo; arguments, and where <var>body</var> might also
          not be provided), the following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>C</i> be the active function object.</li>
            <li>Let <i>args</i> be the <i>argumentsList</i> that was passed to this function by [[Call]] or [[Construct]].</li>
            <li>Return <a href="#sec-createdynamicfunction">CreateDynamicFunction</a>(<i>C</i>, NewTarget, <code>"normal"</code>,
                <i>args</i>).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> It is permissible but not necessary to have one argument for each formal parameter to
            be specified. For example, all three of the following expressions produce the same result:</p>

            <pre class="NoteCode">new Function("a", "b", "c", "return a+b+c")</pre>
            <pre class="NoteCode">new Function("a, b, c", "return a+b+c")</pre>
            <pre class="NoteCode">new Function("a,b", "c", "return a+b+c")</pre>
          </div>
        </div>

        <section id="sec-createdynamicfunction">
          <h5 id="sec-19.2.1.1.1" title="19.2.1.1.1"> RuntimeSemantics: CreateDynamicFunction(constructor, newTarget,
              kind, args)</h5><p>The abstract operation CreateDynamicFunction is called with arguments <var>constructor</var>, <var>newTarget</var>,
          <var>kind</var>, and <var>args</var>. <var>constructor</var> is the constructor function that is performing this action,
          <var>newTarget</var> is the constructor that <code>new</code> was initially applied to, <var>kind</var> is either
          <code>"normal"</code> or <code>"generator"</code>, and <var>args</var> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the actual argument values that were passed to
          <var>constructor</var>. The following steps are taken:</p>

          <ol class="proc">
            <li>If <i>newTarget</i> is <b>undefined</b><i>,</i> let <i>newTarget</i> be <i>constructor</i>.</li>
            <li>If <i>kind</i> is <code>"normal"</code>, then
              <ol class="block">
                <li>Let <i>goal</i> be the grammar symbol <i>FunctionBody.</i></li>
                <li>Let <i>parameterGoal</i> be the grammar symbol <i>FormalParameters</i>.</li>
                <li>Let <i>fallbackProto</i> be <code>"%FunctionPrototype%"</code>.</li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Let <i>goal</i> be the grammar symbol <i>GeneratorBody</i>.</li>
                <li>Let <i>parameterGoal</i> be the grammar symbol <i>FormalParameters</i><sub>[Yield]</sub>.</li>
                <li>Let <i>fallbackProto</i> be <code>"%Generator%"</code>.</li>
              </ol>
            </li>
            <li>Let <i>argCount</i> be the number of elements in <i>args</i>.</li>
            <li>Let <i>P</i> be the empty String.</li>
            <li>If <i>argCount</i> = 0, let <i>bodyText</i> be the empty String.</li>
            <li>Else if <i>argCount</i> = 1, let <i>bodyText</i> be <i>args</i>[0].</li>
            <li>Else <i>argCount</i> &gt; 1,
              <ol class="block">
                <li>Let <i>firstArg</i> be <i>args</i>[0].</li>
                <li>Let <i>P</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>firstArg</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>P</i>).</li>
                <li>Let <i>k</i> be 1.</li>
                <li>Repeat, while <i>k</i> &lt; <i>argCount</i>-1
                  <ol class="block">
                    <li>Let <i>nextArg</i> be <i>args</i>[<i>k</i>].</li>
                    <li>Let <i>nextArgString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>nextArg</i>).</li>
                    <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>nextArgString</i>).</li>
                    <li>Let <i>P</i> be the result of concatenating the previous value of <i>P</i>, the String <code>","</code> (a
                        comma), and <i>nextArgString</i>.</li>
                    <li>Increase <i>k</i> by 1.</li>
                  </ol>
                </li>
                <li>Let <i>bodyText</i> be <i>args</i>[<i>k</i>].</li>
              </ol>
            </li>
            <li>Let <i>bodyText</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>bodyText</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>bodyText</i>).</li>
            <li>Let <i>body</i> be the result of parsing <i>bodyText</i>, interpreted as UTF-16 encoded Unicode text as described
                in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a><i>,</i> using <i>goal</i> as the goal symbol.
                Throw a <b>SyntaxError</b> exception if the parse fails or if any static semantics errors are detected.</li>
            <li>If <i>bodyText</i> is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> (<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">see
                10.2.1</a>) then let <i>strict</i> be <b>true</b>, else let <i>strict</i> be <b>false</b>.</li>
            <li>Let <i>parameters</i> be the result of parsing <i>P</i>, interpreted as UTF-16 encoded Unicode text as described
                in <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a><i>,</i> using <i>parameterGoal</i> as the goal
                symbol. Throw a <b>SyntaxError</b> exception if the parse fails or if any static semantics errors are detected. If
                <i>strict</i> is <b>true</b>, the Early Error rules for <span class="prod"><span class="nt">StrictFormalParameters</span> <span class="geq">:</span> <span class="nt">FormalParameters</span></span> are applied.</li>
            <li>If any element of the BoundNames of <i>parameters</i> also occurs in the LexicallyDeclaredNames of <i>body</i>,
                throw a <b>SyntaxError</b> exception.</li>
            <li>If <i>body</i> Contains <i>SuperCall</i> is <i><b>true</b>,</i> throw a <b>SyntaxError</b> exception.</li>
            <li>If <i>parameters</i> Contains <i>SuperCall</i> is <i><b>true</b>,</i> throw a <b>SyntaxError</b> exception.</li>
            <li>If <i>body</i> Contains <i>SuperProperty</i> is <i><b>true</b>,</i> throw a <b>SyntaxError</b> exception.</li>
            <li>If <i>parameters</i> Contains <i>SuperProperty</i> is <i><b>true</b>,</i> throw a <b>SyntaxError</b>
                exception.</li>
            <li>If <i>kind</i> is <code>"generator"</code>, then
              <ol class="block">
                <li>If <i>parameters</i> Contains <i>YieldExpression</i> is <i><b>true</b>,</i> throw a <b>SyntaxError</b>
                    exception.</li>
              </ol>
            </li>
            <li>If <i>strict</i> is <b>true</b>, then
              <ol class="block">
                <li>If BoundNames of <i>parameters</i> contains any duplicate elements<i>,</i> throw a <b>SyntaxError</b>
                    exception.</li>
              </ol>
            </li>
            <li>Let <i>proto</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-getprototypefromconstructor">GetPrototypeFromConstructor</a>(<i>newTarget</i>,
                <i>fallbackProto</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>proto</i>).</li>
            <li>Let <i>F</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functionallocate">FunctionAllocate</a>(<i>proto</i>, <i>strict</i>,
                <i>kind</i>).</li>
            <li>Let <i>realmF</i> be the value of <i>F&rsquo;s</i> [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>scope</i> be <i>realmF</i>.[[globalEnv]].</li>
            <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-functioninitialize">FunctionInitialize</a>(<i>F</i>, <span style="font-family:                 sans-serif">Normal</span>, <i>parameters</i>, <i>body, scope</i>).</li>
            <li>If <i>kind</i> is <code>"generator"</code>, then
              <ol class="block">
                <li>Let <i>prototype</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(<span style="font-family:                     sans-serif">%GeneratorPrototype%</span>).</li>
                <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>F</i>, <b>true</b>, <i>prototype</i>).</li>
              </ol>
            </li>
            <li>Else, perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-makeconstructor">MakeConstructor</a>(<i>F</i>).</li>
            <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>F</i>, <code>"<b>anonymous</b>"</code>).</li>
            <li>Return <i>F</i>.</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> A <code>prototype</code> property is automatically created for every function created
            using CreateDynamicFunction , to provide for the possibility that the function will be used as a constructor.</p>
          </div>
        </section>
      </section>
    </section>

    <section id="sec-properties-of-the-function-constructor">
      <div class="front">
        <h3 id="sec-19.2.2" title="19.2.2"> Properties of the Function Constructor</h3><p>The <code>Function</code> constructor is itself a built-in function object. The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the <code>Function</code> constructor is
        %FunctionPrototype%, the intrinsic Function prototype object (<a href="#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>The value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Function constructor is <b>true</b>.</p>

        <p class="normalbefore">The Function constructor has the following properties:</p>
      </div>

      <section id="sec-function.length">
        <h4 id="sec-19.2.2.1" title="19.2.2.1">
            Function.length</h4><p>This is a data property with a value of 1. This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>

      <section id="sec-function.prototype">
        <h4 id="sec-19.2.2.2" title="19.2.2.2"> Function.prototype</h4><p>The value of <code>Function.prototype</code> is %FunctionPrototype%, the intrinsic Function prototype object (<a href="#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">false</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-function-prototype-object">
      <div class="front">
        <h3 id="sec-19.2.3" title="19.2.3"> Properties of the Function Prototype Object</h3><p>The Function prototype object is the intrinsic object %FunctionPrototype%. The Function prototype object is itself a
        built-in function object. When invoked, it accepts any arguments and returns <span class="value">undefined</span>. It does
        not have a [[Construct]] internal method so it is not a constructor.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> The Function prototype object is specified to be a function object to ensure
          compatibility with ECMAScript code that was created prior to the ECMAScript 2015 specification.</p>
        </div>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Function prototype object is the intrinsic object %ObjectPrototype% (<a href="#sec-properties-of-the-object-prototype-object">19.1.3</a>). The initial value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Function prototype object is <span class="value">true</span>.</p>

        <p>The Function prototype object does not have a <code>prototype</code> property.</p>

        <p>The value of the <code>length</code> property of the Function prototype object is <b>0</b>.</p>

        <p>The value of the <code>name</code> property of the Function prototype object is the empty String.</p>
      </div>

      <section id="sec-function.prototype.apply">
        <h4 id="sec-19.2.3.1" title="19.2.3.1"> Function.prototype.apply ( thisArg, argArray )</h4><p class="normalbefore">When the <code>apply</code> method is called on an object <var>func</var> with arguments
        <var>thisArg</var> and <var>argArray</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>func</i>) is <b>false</b>, throw a <b>TypeError</b> exception.</li>
          <li>If <i>argArray</i> is <b>null</b> or <b>undefined</b>, then
            <ol class="block">
              <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>func</i>, <i>thisArg</i>).</li>
            </ol>
          </li>
          <li>Let <i>argList</i> be <a href="sec-abstract-operations#sec-createlistfromarraylike">CreateListFromArrayLike</a>(<i>argArray</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>argList</i> ).</li>
          <li>Perform <a href="sec-ecmascript-language-functions-and-classes#sec-preparefortailcall">PrepareForTailCall</a>().</li>
          <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>func</i>, <i>thisArg</i>, <i>argList</i>).</li>
        </ol>

        <p>The <code>length</code> property of the <code>apply</code> method is <b>2</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The thisArg value is passed without modification as the <b>this</b> value. This is a
          change from Edition 3, where an <b>undefined</b> or <b>null</b> thisArg is replaced with the global object and <a href="sec-abstract-operations#sec-toobject">ToObject</a> is applied to all other values and that result is passed as the <b>this</b> value.
          Even though the thisArg is passed without modification, non-strict functions still perform these transformations upon
          entry to the function.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> If <var>func</var> is an arrow function or a <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">bound function</a> then the <var>thisArg</var> will be ignored by the function
          [[Call]] in step 6.</p>
        </div>
      </section>

      <section id="sec-function.prototype.bind">
        <h4 id="sec-19.2.3.2" title="19.2.3.2"> Function.prototype.bind ( thisArg , ...args)</h4><p class="normalbefore">When the <code>bind</code> method is called with argument <var>thisArg</var> and zero or more
        <var>args</var>, it performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>Target</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>Target</i>) is <b>false</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>args</i> be a new (possibly empty) <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> consisting of
              all of the argument values provided after <i>thisArg</i>  in order.</li>
          <li>Let <i>F</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-boundfunctioncreate">BoundFunctionCreate</a>(<i>Target</i>, <i>thisArg</i>,
              <i>args</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>F</i>).</li>
          <li>Let <i>targetHasLength</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>Target</i>,
              <code>"length"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetHasLength</i>).</li>
          <li>If <i>targetHasLength</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>targetLen</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>Target</i>, <code>"length"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetLen</i>).</li>
              <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>targetLen</i>) is not Number, let <i>L</i> be
                  0.</li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>targetLen</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>targetLen</i>).</li>
                  <li>Let <i>L</i> be the larger of 0 and the result of <i>targetLen</i> minus the number of elements of
                      <i>args</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Else let <i>L</i> be 0.</li>
          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>F</i>, <code>"length"</code>,
              PropertyDescriptor {[[Value]]: <i>L</i>, [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
              <b>true</b>}).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>Let <i>targetName</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>Target</i>, <code>"name"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetName</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>targetName</i>) is not String, let <i>targetName</i>
              be the empty string.</li>
          <li>Perform <a href="sec-ordinary-and-exotic-objects-behaviours#sec-setfunctionname">SetFunctionName</a>(<i>F</i>, <i>targetName</i>, <code>"bound"</code>).</li>
          <li>Return <i>F</i>.</li>
        </ol>

        <p>The <code>length</code> property of the <code>bind</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> Function objects created using <code>Function.prototype.bind</code> are exotic
          objects. They also do not have a <code>prototype</code> property.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> If <span class="nt">Target</span> is an arrow function or a <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">bound function</a> then the <var>thisArg</var> passed to this method will not
          be used by subsequent calls to <var>F</var>.</p>
        </div>
      </section>

      <section id="sec-function.prototype.call">
        <h4 id="sec-19.2.3.3" title="19.2.3.3"> Function.prototype.call (thisArg , ...args)</h4><p class="normalbefore">When the <code>call</code> method is called on an object <var>func</var> with argument,
        <var>thisArg</var> and zero or more <var>args</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>func</i>) is <b>false</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>argList</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>If this method was called with more than one argument then in left to right order, starting with the second
              argument, append each argument as the last element of <i>argList</i>.</li>
          <li>Perform <a href="sec-ecmascript-language-functions-and-classes#sec-preparefortailcall">PrepareForTailCall</a>().</li>
          <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>func</i>, <i>thisArg</i>, <i>argList</i>).</li>
        </ol>

        <p>The <code>length</code> property of the <code>call</code> method is <b>1</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> The thisArg value is passed without modification as the <b>this</b> value. This is a
          change from Edition 3, where an <b>undefined</b> or <b>null</b> thisArg is replaced with the global object and <a href="sec-abstract-operations#sec-toobject">ToObject</a> is applied to all other values and that result is passed as the <b>this</b> value.
          Even though the thisArg is passed without modification, non-strict functions still perform these transformations upon
          entry to the function.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> If <var>func</var> is an arrow function or a <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">bound function</a> then the <var>thisArg</var> will be ignored by the function
          [[Call]] in step 5.</p>
        </div>
      </section>

      <section id="sec-function.prototype.constructor">
        <h4 id="sec-19.2.3.4" title="19.2.3.4"> Function.prototype.constructor</h4><p>The initial value of <code>Function.prototype.constructor</code> is the intrinsic object %Function%.</p>
      </section>

      <section id="sec-function.prototype.tostring">
        <h4 id="sec-19.2.3.5" title="19.2.3.5"> Function.prototype.toString ( )</h4><p class="normalbefore">When the <code>toString</code> method is called on an object <var>func</var> the following steps
        are taken:</p>

        <ol class="proc">
          <li>If <i>func</i> is a <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">Bound Function</a> exotic object, then
            <ol class="block">
              <li>Return an implementation-dependent String source code representation of <i>func</i>. The representation must
                  conform to the rules below. It is implementation dependent whether the representation includes <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">bound function</a> information or information about the target
                  function.</li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>func</i>) is Object and is either a built-in function
              object or  has an [[ECMAScriptCode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>,
              then
            <ol class="block">
              <li>Return an implementation-dependent String source code representation of <i>func</i>. The representation must
                  conform to the rules below.</li>
            </ol>
          </li>
          <li>Throw a <b>TypeError</b> exception.</li>
        </ol>

        <p class="normalbefore"><code>toString</code> Representation Requirements:</p>

        <ul>
          <li>
            <p>The string representation must have the syntax of a <i>FunctionDeclaration</i>, <i>FunctionExpression</i>,
            <i>GeneratorDeclaration, GeneratorExpression, ClassDeclaration</i>, <i>ClassExpression</i>, <i>ArrowFunction</i>,
            <i>MethodDefinition</i>, or <i>GeneratorMethod</i> depending upon the actual characteristics of the object.</p>
          </li>

          <li>
            <p>T<span style="font-family: Times New Roman">he use and placement of white space, line terminators, and semicolons
            within the representation String is implementation-dependent.</span></p>
          </li>

          <li>
            <p>If the object was defined using ECMAScript code and the returned string representation is not in the form of a
            <i>MethodDefinition</i> or <i>GeneratorMethod</i> then the representation must be such that if the string is
            evaluated, using <code>eval</code> in a lexical context that is equivalent to the lexical context used to create the
            original object, it will result in a new functionally equivalent object. In that case the returned source code must
            not mention freely any variables that were not mentioned freely by the original function&rsquo;s source code, even if
            these &ldquo;extra&rdquo; names were originally in scope.</p>
          </li>

          <li>
            <p>If the implementation cannot produce a source code string that meets these criteria then it must return a string
            for which <code>eval</code> will throw a <span style="font-family: sans-serif"><b>SyntaxError</b></span>
            exception.</p>
          </li>
        </ul>
      </section>

      <section id="sec-function.prototype-@@hasinstance">
        <h4 id="sec-19.2.3.6" title="19.2.3.6"> Function.prototype[@@hasInstance] ( V )</h4><p class="normalbefore">When the @@hasInstance method of an object <var>F</var> is called with value <var>V</var>, the
        following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>F</i> be the <b>this</b> value.</li>
          <li>Return <a href="sec-abstract-operations#sec-ordinaryhasinstance">OrdinaryHasInstance</a>(<i>F</i>, <i>V</i>).</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"[Symbol.hasInstance]"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <span class="value">false</span>,
        [[Configurable]]: <span class="value">false</span> }.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> This is the default implementation of <code>@@hasInstance</code> that most functions
          inherit. <code>@@hasInstance</code> is called by the <code>instanceof</code> operator to determine whether a value is an
          instance of a specific constructor. An expression such as</p>

          <p>&nbsp;&nbsp;&nbsp;<code>v instanceof F</code></p>

          <p>evaluates as</p>

          <p>&nbsp;&nbsp;&nbsp;<code>F[@@hasInstance](v)</code></p>

          <p>A constructor function can control which objects are recognized as its instances by <code>instanceof</code> by
          exposing a different <code>@@hasInstance</code> method on the function.</p>
        </div>

        <p>This property is non-writable and non-configurable to prevent tampering that could be used to globally expose the
        target function of a <a href="sec-ordinary-and-exotic-objects-behaviours#sec-bound-function-exotic-objects">bound function</a>.</p>
      </section>
    </section>

    <section id="sec-function-instances">
      <div class="front">
        <h3 id="sec-19.2.4" title="19.2.4">
            Function Instances</h3><p>Every function instance is an <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ecmascript-function-objects">ECMAScript function object</a> and has the
        internal slots listed in <a href="sec-ordinary-and-exotic-objects-behaviours#table-27">Table 27</a>. Function instances created using the <code><a href="#sec-function.prototype.bind">Function.prototype.bind</a></code> method (<a href="#sec-function.prototype.bind">19.2.3.2</a>) have the internal slots listed in <a href="sec-ordinary-and-exotic-objects-behaviours#table-28">Table 28</a>.</p>

        <p>The Function instances have the following properties:</p>
      </div>

      <section id="sec-function-instances-length">
        <h4 id="sec-19.2.4.1" title="19.2.4.1"> length</h4><p>The value of the <code>length</code> property is an integer that indicates the typical number of arguments expected by
        the function. However, the language permits the function to be invoked with some other number of arguments. The behaviour
        of a function when invoked on a number of arguments other than the number specified by its <code>length</code> property
        depends on the function. This property has the attributes {&nbsp;[[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>,
        [[Configurable]]: <b>true</b>&nbsp;}.</p>
      </section>

      <section id="sec-function-instances-name">
        <h4 id="sec-19.2.4.2" title="19.2.4.2"> name</h4><p>The value of the <code>name</code> property is an String that is descriptive of the function. The name has no semantic
        significance but is typically a variable or property name that is used to refer to the function at its point of definition
        in ECMAScript code. This property has the attributes {&nbsp;[[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>,
        [[Configurable]]: <b>true</b>&nbsp;}.</p>

        <p>Anonymous functions objects that do not have a contextual name associated with them by this specification do not have a
        <code>name</code> own property but inherit the <code>name</code> property of %FunctionPrototype%.</p>
      </section>

      <section id="sec-function-instances-prototype">
        <h4 id="sec-19.2.4.3" title="19.2.4.3"> prototype</h4><p>Function instances that can be used as a constructor have a <code>prototype</code> property. Whenever such a function
        instance is created another ordinary object is also created and is the initial value of the function&rsquo;s
        <code>prototype</code> property. Unless otherwise specified, the value of the <code>prototype</code> property is used to
        initialize the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the object
        created when that function is invoked as a constructor.</p>

        <p>This property has the attributes {&nbsp;[[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> Function objects created using <code><a href="#sec-function.prototype.bind">Function.prototype.bind</a></code>, or by evaluating a <span class="nt">MethodDefinition</span> (that are not a <span class="nt">GeneratorMethod</span>) or an <span class="nt">ArrowFunction</span> grammar production do not have a <code>prototype</code> property.</p>
        </div>
      </section>
    </section>
  </section>

  <section id="sec-boolean-objects">
    <div class="front">
      <h2 id="sec-19.3" title="19.3"> Boolean
          Objects</h2></div>

    <section id="sec-boolean-constructor">
      <div class="front">
        <h3 id="sec-19.3.1" title="19.3.1">
            The Boolean Constructor</h3><p>The Boolean constructor is the %Boolean% intrinsic object and the initial value of the <code>Boolean</code> property of
        the global object. When called as a constructor it creates and initializes a new Boolean object. When <code>Boolean</code>
        is called as a function rather than as a constructor, it performs a type conversion.</p>

        <p>The <code>Boolean</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>Boolean</code> behaviour must include a <code>super</code> call to the <code>Boolean</code> constructor to create
        and initialize the subclass instance with a [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
      </div>

      <section id="sec-boolean-constructor-boolean-value">
        <h4 id="sec-19.3.1.1" title="19.3.1.1"> Boolean ( value )</h4><p class="normalbefore">When <code>Boolean</code> is called with argument <var>value</var>, the following steps are
        taken:</p>

        <ol class="proc">
          <li>Let <i>b</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<i>value</i>).</li>
          <li>If NewTarget is <b>undefined</b><i>,</i> return <i>b</i>.</li>
          <li>Let <i>O</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
              <code>"%BooleanPrototype%"</code>, &laquo;[[BooleanData]]&raquo; ).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Set the value of <i>O&rsquo;s</i> [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>b</i>.</li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-boolean-constructor">
      <div class="front">
        <h3 id="sec-19.3.2" title="19.3.2"> Properties of the Boolean Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Boolean constructor is the intrinsic object %FunctionPrototype% (<a href="#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is <b>1</b>), the Boolean constructor has the following
        properties:</p>
      </div>

      <section id="sec-boolean.prototype">
        <h4 id="sec-19.3.2.1" title="19.3.2.1"> Boolean.prototype</h4><p>The initial value of <code>Boolean.prototype</code> is the intrinsic object %BooleanPrototype% (<a href="#sec-properties-of-the-boolean-prototype-object">19.3.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-boolean-prototype-object">
      <div class="front">
        <h3 id="sec-19.3.3" title="19.3.3"> Properties of the Boolean Prototype Object</h3><p>The Boolean prototype object is the intrinsic object %BooleanPrototype%. The Boolean prototype object is an ordinary
        object. It is not a Boolean instance and does not have a [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Boolean prototype object is the intrinsic object %ObjectPrototype% (<a href="#sec-properties-of-the-object-prototype-object">19.1.3</a>).</p>

        <p class="normalbefore">The abstract operation <span style="font-family: Times New         Roman">thisBooleanValue(<i>value</i>)</span> performs the following steps:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Boolean, return <i>value</i>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Object and <i>value</i> has a
              [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, then
            <ol class="block">
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>value</i>&rsquo;s [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is a Boolean value.</li>
              <li>Return the value of <i>value&rsquo;s</i> [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            </ol>
          </li>
          <li>Throw a <b>TypeError</b> exception.</li>
        </ol>
      </div>

      <section id="sec-boolean.prototype.constructor">
        <h4 id="sec-19.3.3.1" title="19.3.3.1"> Boolean.prototype.constructor</h4><p>The initial value of <code>Boolean.prototype.constructor</code> is the intrinsic object %Boolean%.</p>
      </section>

      <section id="sec-boolean.prototype.tostring">
        <h4 id="sec-19.3.3.2" title="19.3.3.2"> Boolean.prototype.toString ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>b</i> be thisBooleanValue(<b>this</b> value).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>b</i>).</li>
          <li>If <i>b</i> is <b>true</b>, return <code>"true"</code>; else return <code>"false"</code>.</li>
        </ol>
      </section>

      <section id="sec-boolean.prototype.valueof">
        <h4 id="sec-19.3.3.3" title="19.3.3.3"> Boolean.prototype.valueOf ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Return thisBooleanValue(<b>this</b> value).</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-boolean-instances">
      <h3 id="sec-19.3.4" title="19.3.4"> Properties of Boolean Instances</h3><p>Boolean instances are ordinary objects that inherit properties from the Boolean prototype object. Boolean instances have
      a [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>. The [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is the Boolean value represented by this Boolean
      object.</p>
    </section>
  </section>

  <section id="sec-symbol-objects">
    <div class="front">
      <h2 id="sec-19.4" title="19.4"> Symbol
          Objects</h2></div>

    <section id="sec-symbol-constructor">
      <div class="front">
        <h3 id="sec-19.4.1" title="19.4.1">
            The Symbol Constructor</h3><p>The Symbol constructor is the %Symbol% intrinsic object and the initial value of the <code>Symbol</code> property of
        the global object. When <code>Symbol</code> is called as a function, it returns a new Symbol value.</p>

        <p>The <code>Symbol</code> constructor is not intended to be used with the <code>new</code> operator or to be subclassed.
        It may be used as the value of an <code>extends</code> clause of a class definition but a <code>super</code> call to the
        <code>Symbol</code> constructor will cause an exception.</p>
      </div>

      <section id="sec-symbol-description">
        <h4 id="sec-19.4.1.1" title="19.4.1.1"> Symbol ( [ description ] )</h4><p class="normalbefore">When <code>Symbol</code> is called with optional argument <var>description</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>If NewTarget is not <b>undefined</b><i>,</i> throw a <b>TypeError</b> exception.</li>
          <li>If <i>description</i> is <b>undefined</b>, let <i>descString</i> be <b>undefined</b>.</li>
          <li>Else, let <i>descString</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>description</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>descString</i>).</li>
          <li>Return a new unique Symbol value whose [[Description]] value is <i>descString</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-symbol-constructor">
      <div class="front">
        <h3 id="sec-19.4.2" title="19.4.2"> Properties of the Symbol Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Symbol constructor is the intrinsic object %FunctionPrototype% (<a href="#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p class="normalbefore">Besides the <code>length</code> property (whose value is <b>0</b>), the Symbol constructor has the
        following properties:</p>
      </div>

      <section id="sec-symbol.for">
        <h4 id="sec-19.4.2.1" title="19.4.2.1">
            Symbol.for ( key )</h4><p class="normalbefore">When <code>Symbol.for</code> is called with argument <var>key</var> it performs the following
        steps:</p>

        <ol class="proc">
          <li>Let <i>stringKey</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>key</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>stringKey</i>).</li>
          <li>For each element <i>e</i> of the GlobalSymbolRegistry <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>,
            <ol class="block">
              <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>e</i>.[[key]], <i>stringKey</i>) is <b>true</b>, return
                  <i>e</i>.[[symbol]].</li>
            </ol>
          </li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: GlobalSymbolRegistry does not currently contain an entry for
              <i>stringKey</i>.</li>
          <li>Let <i>newSymbol</i> be a new unique Symbol value whose [[Description]] value is <i>stringKey</i>.</li>
          <li>Append the record { [[key]]: <i>stringKey</i>, [[symbol]]: <i>newSymbol</i> } to the GlobalSymbolRegistry <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Return <i>newSymbol</i>.</li>
        </ol>

        <p>The GlobalSymbolRegistry is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> that is globally available. It
        is shared by all Code Realms. Prior to the evaluation of any ECMAScript code it is initialized as an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>. Elements of the GlobalSymbolRegistry are Records with the
        structure defined in <a href="#table-44">Table 44</a>.</p>

        <figure>
          <figcaption><span id="table-44">Table 44</span> &mdash; GlobalSymbolRegistry Record Fields</figcaption>
          <table class="real-table">
            <tr>
              <th>Field Name</th>
              <th>Value</th>
              <th>Usage</th>
            </tr>
            <tr>
              <td>[[key]]</td>
              <td>A String</td>
              <td>A string key used to globally identify a Symbol.</td>
            </tr>
            <tr>
              <td>[[symbol]]</td>
              <td>A Symbol</td>
              <td>A symbol that can be retrieved from any <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>.</td>
            </tr>
          </table>
        </figure>
      </section>

      <section id="sec-symbol.hasinstance">
        <h4 id="sec-19.4.2.2" title="19.4.2.2"> Symbol.hasInstance</h4><p>The initial value of <code>Symbol.hasInstance</code> is the well known symbol @@hasInstance (<a href="sec-ecmascript-data-types-and-values#table-1">Table
        1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.isconcatspreadable">
        <h4 id="sec-19.4.2.3" title="19.4.2.3"> Symbol.isConcatSpreadable</h4><p>The initial value of <code>Symbol.isConcatSpreadable</code> is the well known symbol @@isConcatSpreadable (<a href="sec-ecmascript-data-types-and-values#table-1">Table 1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.iterator">
        <h4 id="sec-19.4.2.4" title="19.4.2.4">
            Symbol.iterator</h4><p>The initial value of <code>Symbol.iterator</code> is the well known symbol @@iterator (<a href="sec-ecmascript-data-types-and-values#table-1">Table
        1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.keyfor">
        <h4 id="sec-19.4.2.5" title="19.4.2.5">
            Symbol.keyFor ( sym )</h4><p class="normalbefore">When <code>Symbol.keyFor</code> is called with argument <var>sym</var> it performs the following
        steps:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>sym</i>) is not Symbol, throw a <b>TypeError</b>
              exception.</li>
          <li>For each element <i>e</i> of the GlobalSymbolRegistry <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> (<a href="#sec-symbol.for">see 19.4.2.1</a>),
            <ol class="block">
              <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>e</i>.[[symbol]], <i>sym</i>) is <b>true</b>, return
                  <i>e</i>.[[key]].</li>
            </ol>
          </li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: GlobalSymbolRegistry does not currently contain an entry for
              <i>sym</i>.</li>
          <li>Return <b>undefined</b>.</li>
        </ol>
      </section>

      <section id="sec-symbol.match">
        <h4 id="sec-19.4.2.6" title="19.4.2.6">
            Symbol.match</h4><p>The initial value of <code>Symbol.match</code> is the well known symbol @@match (<a href="sec-ecmascript-data-types-and-values#table-1">Table 1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.prototype">
        <h4 id="sec-19.4.2.7" title="19.4.2.7"> Symbol.prototype</h4><p>The initial value of <code>Symbol.prototype</code> is the intrinsic object %SymbolPrototype% (<a href="#sec-properties-of-the-symbol-prototype-object">19.4.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.replace">
        <h4 id="sec-19.4.2.8" title="19.4.2.8">
            Symbol.replace</h4><p>The initial value of <code>Symbol.replace</code> is the well known symbol @@replace (<a href="sec-ecmascript-data-types-and-values#table-1">Table
        1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.search">
        <h4 id="sec-19.4.2.9" title="19.4.2.9">
            Symbol.search</h4><p>The initial value of <code>Symbol.search</code> is the well known symbol @@search (<a href="sec-ecmascript-data-types-and-values#table-1">Table 1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.species">
        <h4 id="sec-19.4.2.10" title="19.4.2.10"> Symbol.species</h4><p>The initial value of <code>Symbol.species</code> is the well known symbol @@species (<a href="sec-ecmascript-data-types-and-values#table-1">Table
        1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.split">
        <h4 id="sec-19.4.2.11" title="19.4.2.11">
            Symbol.split</h4><p>The initial value of <code>Symbol.split</code> is the well known symbol @@split (<a href="sec-ecmascript-data-types-and-values#table-1">Table 1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.toprimitive">
        <h4 id="sec-19.4.2.12" title="19.4.2.12"> Symbol.toPrimitive</h4><p>The initial value of <code>Symbol.toPrimitive</code> is the well known symbol @@toPrimitive (<a href="sec-ecmascript-data-types-and-values#table-1">Table
        1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.tostringtag">
        <h4 id="sec-19.4.2.13" title="19.4.2.13"> Symbol.toStringTag</h4><p>The initial value of <code>Symbol.toStringTag</code> is the well known symbol @@toStringTag (<a href="sec-ecmascript-data-types-and-values#table-1">Table
        1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-symbol.unscopables">
        <h4 id="sec-19.4.2.14" title="19.4.2.14"> Symbol.unscopables</h4><p>The initial value of <code>Symbol.unscopables</code> is the well known symbol @@unscopables (<a href="sec-ecmascript-data-types-and-values#table-1">Table
        1</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-symbol-prototype-object">
      <div class="front">
        <h3 id="sec-19.4.3" title="19.4.3"> Properties of the Symbol Prototype Object</h3><p>The Symbol prototype object is the intrinsic object %SymbolPrototype%. The Symbol prototype object is an ordinary
        object. It is not a Symbol instance and does not have a [[SymbolData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        Symbol prototype object is the intrinsic object %ObjectPrototype% (<a href="#sec-properties-of-the-object-prototype-object">19.1.3</a>).</p>
      </div>

      <section id="sec-symbol.prototype.constructor">
        <h4 id="sec-19.4.3.1" title="19.4.3.1"> Symbol.prototype.constructor</h4><p>The initial value of <code>Symbol.prototype.constructor</code> is the intrinsic object %Symbol%.</p>
      </section>

      <section id="sec-symbol.prototype.tostring">
        <div class="front">
          <h4 id="sec-19.4.3.2" title="19.4.3.2"> Symbol.prototype.toString ( )</h4><p class="normalbefore">The following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>s</i> be the <b>this</b> value.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>s</i>) is Symbol, let <i>sym</i> be <i>s</i>.</li>
            <li>Else,
              <ol class="block">
                <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>s</i>) is not Object, throw a <b>TypeError</b>
                    exception.</li>
                <li>If <i>s</i> does not have a [[SymbolData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                    slot</a>, throw a <b>TypeError</b> exception.</li>
                <li>Let <i>sym</i> be the value of <i>s&rsquo;s</i> [[SymbolData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
              </ol>
            </li>
            <li>Return <a href="#sec-symboldescriptivestring">SymbolDescriptiveString</a>(<i>sym</i>).</li>
          </ol>
        </div>

        <section id="sec-symboldescriptivestring">
          <h5 id="sec-19.4.3.2.1" title="19.4.3.2.1"> Runtime Semantics:  SymbolDescriptiveString ( sym )</h5><p class="normalbefore">When the abstract operation SymbolDescriptiveString is called with argument <var>sym</var>, the
          following steps are taken:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>sym</i>) is Symbol.</li>
            <li>Let <i>desc</i> be <i>sym&rsquo;s</i> [[Description]] value.</li>
            <li>If <i>desc</i> is <b>undefined</b>, let <i>desc</i> be the empty string.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>desc</i>) is String.</li>
            <li>Return the result of concatenating the strings <code>"Symbol("</code>, <i>desc</i>, and <code>")"</code>.</li>
          </ol>
        </section>
      </section>

      <section id="sec-symbol.prototype.valueof">
        <h4 id="sec-19.4.3.3" title="19.4.3.3"> Symbol.prototype.valueOf ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>s</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>s</i>) is Symbol, return <i>s</i>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>s</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>s</i> does not have a [[SymbolData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Return the value of <i>s&rsquo;s</i> [[SymbolData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
        </ol>
      </section>

      <section id="sec-symbol.prototype-@@toprimitive">
        <h4 id="sec-19.4.3.4" title="19.4.3.4"> Symbol.prototype [ @@toPrimitive ] ( hint )</h4><p>This function is called by ECMAScript language operators to convert a Symbol object to a primitive value. The allowed
        values for <var>hint</var> are <code>"default"</code>,  <code>"number"</code>, and <code>"string"</code>.</p>

        <p class="normalbefore">When the <code>@@toPrimitive</code> method is called with argument <var>hint</var>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>s</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>s</i>) is Symbol, return <i>s</i>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>s</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>s</i> does not have a [[SymbolData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Return the value of <i>s&rsquo;s</i> [[SymbolData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"[Symbol.toPrimitive]"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>

      <section id="sec-symbol.prototype-@@tostringtag">
        <h4 id="sec-19.4.3.5" title="19.4.3.5"> Symbol.prototype [ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"Symbol"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-symbol-instances">
      <h3 id="sec-19.4.4" title="19.4.4"> Properties of Symbol Instances</h3><p>Symbol instances are ordinary objects that inherit properties from the Symbol prototype object. Symbol instances have a
      [[SymbolData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>. The [[SymbolData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is the Symbol value represented by this Symbol
      object.</p>
    </section>
  </section>

  <section id="sec-error-objects">
    <div class="front">
      <h2 id="sec-19.5" title="19.5"> Error
          Objects</h2><p>Instances of Error objects are thrown as exceptions when runtime errors occur. The Error objects may also serve as base
      objects for user-defined exception classes.</p>
    </div>

    <section id="sec-error-constructor">
      <div class="front">
        <h3 id="sec-19.5.1" title="19.5.1">
            The Error Constructor</h3><p>The Error constructor is the %Error% intrinsic object and the initial value of the <code>Error</code> property of the
        global object. When <code>Error</code> is called as a function rather than as a constructor, it creates and initializes a
        new Error object. Thus the function call <code><b>Error(</b>&hellip;<b>)</b></code> is equivalent to the object creation
        expression <code><b>new Error(</b>&hellip;<b>)</b></code> with the same arguments.</p>

        <p>The <code>Error</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>Error</code> behaviour must include a <code>super</code> call to the <code>Error</code> constructor to create and
        initialize subclass instances with a [[ErrorData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
        slot</a>.</p>
      </div>

      <section id="sec-error-message">
        <h4 id="sec-19.5.1.1" title="19.5.1.1">
            Error ( message )</h4><p class="normalbefore">When the <code>Error</code> function is called with argument <i>message</i> the following steps
        are taken:</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b><i>,</i> let <i>newTarget</i> be the active function object, else let
              <i>newTarget</i> be NewTarget.</li>
          <li>Let <i>O</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(<i>newTarget</i>,
              <code>"%ErrorPrototype%"</code>, &laquo;[[ErrorData]]&raquo;).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>If <i>message</i> is not <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>msg</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>message</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>msg</i>).</li>
              <li>Let <i>msgDesc</i> be the PropertyDescriptor{[[Value]]: <i>msg</i>, [[Writable]]: <b>true</b>, [[Enumerable]]:
                  <b>false</b>, [[Configurable]]: <b>true</b>}.</li>
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>O</i>,
                  "<code>message</code>", <i>msgDesc</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
            </ol>
          </li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-error-constructor">
      <div class="front">
        <h3 id="sec-19.5.2" title="19.5.2"> Properties of the Error Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Error
        constructor is the intrinsic object %FunctionPrototype% (<a href="#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p class="normalbefore">Besides the <code>length</code> property (whose value is <b>1</b>), the Error constructor has the
        following properties:</p>
      </div>

      <section id="sec-error.prototype">
        <h4 id="sec-19.5.2.1" title="19.5.2.1">
            Error.prototype</h4><p>The initial value of <code>Error.prototype</code> is the intrinsic object %ErrorPrototype% (<a href="#sec-properties-of-the-error-prototype-object">19.5.3</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-error-prototype-object">
      <div class="front">
        <h3 id="sec-19.5.3" title="19.5.3"> Properties of the Error Prototype Object</h3><p>The Error prototype object is the intrinsic object %ErrorPrototype%. The Error prototype object is an ordinary object.
        It is not an Error instance and does not have an [[ErrorData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

        <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Error
        prototype object is the intrinsic object %ObjectPrototype% (<a href="#sec-properties-of-the-object-prototype-object">19.1.3</a>).</p>
      </div>

      <section id="sec-error.prototype.constructor">
        <h4 id="sec-19.5.3.1" title="19.5.3.1"> Error.prototype.constructor</h4><p>The initial value of <code>Error.prototype.constructor</code> is the intrinsic object %Error%.</p>
      </section>

      <section id="sec-error.prototype.message">
        <h4 id="sec-19.5.3.2" title="19.5.3.2"> Error.prototype.message</h4><p>The initial value of <code>Error.prototype.message</code> is the empty String.</p>
      </section>

      <section id="sec-error.prototype.name">
        <h4 id="sec-19.5.3.3" title="19.5.3.3"> Error.prototype.name</h4><p>The initial value of <code>Error.prototype.name</code> is <code>"<b>Error</b>"</code>.</p>
      </section>

      <section id="sec-error.prototype.tostring">
        <h4 id="sec-19.5.3.4" title="19.5.3.4"> Error.prototype.toString ( )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>name</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <code>"name"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>name</i>).</li>
          <li>If <i>name</i> is <b>undefined</b>, let <i>name</i> be <code>"<b>Error</b>"</code>; otherwise let <i>name</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>name</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>name</i>).</li>
          <li>Let <i>msg</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>O</i>, <code>"message"</code>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>msg</i>).</li>
          <li>If <i>msg</i> is <b>undefined</b>, let <i>msg</i> be the empty String; otherwise let <i>msg</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>msg</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>msg</i>).</li>
          <li>If <i>name</i> is the empty String, return <i>msg</i>.</li>
          <li>If <i>msg</i> is the empty String, return <i>name</i>.</li>
          <li>Return the result of concatenating <i>name</i>, the code unit 0x003A (COLON), the code unit 0x0020 (SPACE), and
              <i>msg</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-error-instances">
      <h3 id="sec-19.5.4" title="19.5.4"> Properties of Error Instances</h3><p>Error instances are ordinary objects that inherit properties from the Error prototype object and have an [[ErrorData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> whose value is <span class="value">undefined</span>. The only specified uses of [[ErrorData]] is to identify Error and <i>NativeError</i>
      instances as Error objects within <code><a href="#sec-object.prototype.tostring">Object.prototype.toString</a></code>.</p>
    </section>

    <section id="sec-native-error-types-used-in-this-standard">
      <div class="front">
        <h3 id="sec-19.5.5" title="19.5.5"> Native Error Types Used in This Standard</h3><p>A new instance of one of the <i>NativeError</i> objects below is thrown when a runtime error is detected. All of these
        objects share the same structure, as described in <a href="#sec-nativeerror-object-structure">19.5.6</a>.</p>
      </div>

      <section id="sec-native-error-types-used-in-this-standard-evalerror">
        <h4 id="sec-19.5.5.1" title="19.5.5.1"> EvalError</h4><p>This exception is not currently used within this specification. This object remains for compatibility with previous
        editions of this specification.</p>
      </section>

      <section id="sec-native-error-types-used-in-this-standard-rangeerror">
        <h4 id="sec-19.5.5.2" title="19.5.5.2"> RangeError</h4><p>Indicates a value that is not in the set or range of allowable values.</p>
      </section>

      <section id="sec-native-error-types-used-in-this-standard-referenceerror">
        <h4 id="sec-19.5.5.3" title="19.5.5.3"> ReferenceError</h4><p>Indicate that an invalid reference value has been detected.</p>
      </section>

      <section id="sec-native-error-types-used-in-this-standard-syntaxerror">
        <h4 id="sec-19.5.5.4" title="19.5.5.4"> SyntaxError</h4><p>Indicates that a parsing error has occurred.</p>
      </section>

      <section id="sec-native-error-types-used-in-this-standard-typeerror">
        <h4 id="sec-19.5.5.5" title="19.5.5.5"> TypeError</h4><p>Indicates the actual type of an operand is different than the expected type.</p>
      </section>

      <section id="sec-native-error-types-used-in-this-standard-urierror">
        <h4 id="sec-19.5.5.6" title="19.5.5.6"> URIError</h4><p>Indicates that one of the global URI handling functions was used in a way that is incompatible with its definition.</p>
      </section>
    </section>

    <section id="sec-nativeerror-object-structure">
      <div class="front">
        <h3 id="sec-19.5.6" title="19.5.6"> </h3><p>When an ECMAScript implementation detects a runtime error, it throws a new instance of one of the <i>NativeError</i>
        objects defined in <a href="#sec-native-error-types-used-in-this-standard">19.5.5</a>. Each of these objects has the
        structure described below, differing only in the name used as the constructor name instead of <i>NativeError</i>, in the
        <b>name</b> property of the prototype object, and in the implementation-defined <code>message</code> property of the
        prototype object.</p>

        <p>For each error object, references to <i>NativeError</i> in the definition should be replaced with the appropriate error
        object name from <a href="#sec-native-error-types-used-in-this-standard">19.5.5</a>.</p>
      </div>

      <section id="sec-nativeerror-constructors">
        <div class="front">
          <h4 id="sec-19.5.6.1" title="19.5.6.1"> </h4><p>When a <i>NativeError</i> constructor is called as a function rather than as a constructor, it creates and
          initializes a new <i>NativeError</i> object. A call of the object as a function is equivalent to calling it as a
          constructor with the same arguments. Thus the function call <i>NativeError</i><code><b>(</b>&hellip;<b>)</b></code> is
          equivalent to the object creation expression <code>new</code> <i>NativeError</i><code><b>(</b>&hellip;<b>)</b></code>
          with the same arguments.</p>

          <p>Each <i>NativeError</i> constructor is designed to be subclassable. It may be used as the value of an
          <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
          <i>NativeError</i> behaviour must include a <code>super</code> call to the <i>NativeError</i> constructor to create and
          initialize subclass instances with a [[ErrorData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
          slot</a>.</p>
        </div>

        <section id="sec-nativeerror">
          <h5 id="sec-19.5.6.1.1" title="19.5.6.1.1"> NativeError ( message )</h5><p class="normalbefore">When a <i>NativeError</i> function is called with argument <i>message</i> the following steps
          are taken:</p>

          <ol class="proc">
            <li>If NewTarget is <b>undefined</b><i>,</i> let <i>newTarget</i> be the active function object, else let
                <i>newTarget</i> be NewTarget.</li>
            <li>Let <i>O</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(<i>newTarget</i>,
                <code>"%<i>NativeError</i>Prototype%"</code>, &laquo;[[ErrorData]]&raquo; ).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
            <li>If <i>message</i> is not <b>undefined</b>, then
              <ol class="block">
                <li>Let <i>msg</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>message</i>).</li>
                <li>Let <i>msgDesc</i> be the PropertyDescriptor{[[Value]]: <i>msg</i>, [[Writable]]: <b>true</b>, [[Enumerable]]:
                    <b>false</b>, [[Configurable]]: <b>true</b>}.</li>
                <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>O</i>,
                    "<code>message</code>", <i>msgDesc</i>).</li>
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              </ol>
            </li>
            <li>Return <i>O</i>.</li>
          </ol>

          <p>The actual value of the string passed in step 2 is either <code>"%EvalErrorPrototype%"</code>,
          <code>"%RangeErrorPrototype%"</code>, <code>"%ReferenceErrorPrototype%"</code>, <code>"%SyntaxErrorPrototype%"</code>,
          <code>"%TypeErrorPrototype%"</code>, or <code>"%URIErrorPrototype%"</code> corresponding to which <i>NativeError</i>
          constructor is being defined.</p>
        </section>
      </section>

      <section id="sec-properties-of-the-nativeerror-constructors">
        <div class="front">
          <h4 id="sec-19.5.6.2" title="19.5.6.2"> Properties of the </h4><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of a
          <i>NativeError</i> constructor is the intrinsic object %Error% (<a href="#sec-error-constructor">19.5.1</a>).</p>

          <p>Besides the <code>length</code> property (whose value is <b>1</b>), each <i>NativeError</i> constructor has the
          following properties:</p>
        </div>

        <section id="sec-nativeerror.prototype">
          <h5 id="sec-19.5.6.2.1" title="19.5.6.2.1"> NativeError.prototype</h5><p>The initial value of <b><i>NativeError</i><code>.prototype</code></b> is a <i>NativeError</i> prototype object (<a href="#sec-properties-of-the-nativeerror-prototype-objects">19.5.6.3</a>). Each <i>NativeError</i> constructor has a
          distinct prototype object.</p>

          <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
          <b>false</b> }.</p>
        </section>
      </section>

      <section id="sec-properties-of-the-nativeerror-prototype-objects">
        <div class="front">
          <h4 id="sec-19.5.6.3" title="19.5.6.3"> Properties of the </h4><p>Each <i>NativeError</i> prototype object is an ordinary object. It is not an Error instance and does not have an
          [[ErrorData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

          <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of each
          <i>NativeError</i> prototype object is the intrinsic object %ErrorPrototype% (<a href="#sec-properties-of-the-error-prototype-object">19.5.3</a>).</p>
        </div>

        <section id="sec-nativeerror.prototype.constructor">
          <h5 id="sec-19.5.6.3.1" title="19.5.6.3.1"> </h5><p>The initial value of the <code>constructor</code> property of the prototype for a given <i>NativeError</i>
          constructor is the corresponding intrinsic object %<i>NativeError</i>% (<a href="#sec-nativeerror-constructors">19.5.6.1</a>).</p>
        </section>

        <section id="sec-nativeerror.prototype.message">
          <h5 id="sec-19.5.6.3.2" title="19.5.6.3.2"> </h5><p>The initial value of the <code>message</code> property of the prototype for a given <i>NativeError</i> constructor is
          the empty String.</p>
        </section>

        <section id="sec-nativeerror.prototype.name">
          <h5 id="sec-19.5.6.3.3" title="19.5.6.3.3"> </h5><p>The initial value of the <code>name</code> property of the prototype for a given <i>NativeError</i> constructor is a
          string consisting of the name of the constructor (the name used instead of <i>NativeError</i>).</p>
        </section>
      </section>

      <section id="sec-properties-of-nativeerror-instances">
        <h4 id="sec-19.5.6.4" title="19.5.6.4"> Properties of </h4><p><i>NativeError</i> instances are ordinary objects that inherit properties from their <i>NativeError</i> prototype
        object and have an [[ErrorData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> whose value
        is <span class="value">undefined</span>. The only specified use of [[ErrorData]] is by <code><a href="#sec-object.prototype.tostring">Object.prototype.toString</a></code> (<a href="#sec-object.prototype.tostring">19.1.3.6</a>) to identify Error or <i>NativeError</i> instances.</p>
      </section>
    </section>
  </section>
</section>

