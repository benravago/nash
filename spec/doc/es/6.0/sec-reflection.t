<section id="sec-reflection">
  <div class="front">
    <h1 id="sec-26" title="26"> Reflection</h1></div>

  <section id="sec-reflect-object">
    <div class="front">
      <h2 id="sec-26.1" title="26.1"> The
          Reflect Object</h2><p>The Reflect object is the %Reflect% intrinsic object and the initial value of the <code>Reflect</code> property of the
      global object.The Reflect object is an ordinary object.</p>

      <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the Reflect
      object is the intrinsic object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>).</p>

      <p>The Reflect object is not a function object. It does not have a [[Construct]] internal method; it is not possible to use
      the Reflect object as a constructor with the <code>new</code> operator. The Reflect object also does not have a [[Call]]
      internal method; it is not possible to invoke the Reflect object as a function.</p>
    </div>

    <section id="sec-reflect.apply">
      <h3 id="sec-26.1.1" title="26.1.1">
          Reflect.apply ( target, thisArgument, argumentsList )</h3><p class="normalbefore">When the <code>apply</code> function is called with arguments <span style="font-family: Times New       Roman"><i>target</i>, <i>thisArgument</i></span>, and <var>argumentsList</var> the following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>target</i>) is <b>false</b>, throw a <b>TypeError</b> exception.</li>
        <li>Let <i>args</i> be <a href="sec-abstract-operations#sec-createlistfromarraylike">CreateListFromArrayLike</a>(<i>argumentsList</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>args</i>).</li>
        <li>Perform <a href="sec-ecmascript-language-functions-and-classes#sec-preparefortailcall">PrepareForTailCall</a>().</li>
        <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>target</i>, <i>thisArgument</i>, <i>args</i>).</li>
      </ol>
    </section>

    <section id="sec-reflect.construct">
      <h3 id="sec-26.1.2" title="26.1.2">
          Reflect.construct ( target, argumentsList [, newTarget] )</h3><p class="normalbefore">When the <code>construct</code> function is called with arguments <var>target</var>,
      <var>argumentsList</var>, and <var>newTarget</var> the following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>target</i>) is <b>false</b>, throw a <b>TypeError</b>
            exception.</li>
        <li>If <i>newTarget</i> is not present, let <i>newTarget</i> be <i>target</i>.</li>
        <li>Else, if <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>newTarget</i>) is <b>false</b>, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>args</i> be <a href="sec-abstract-operations#sec-createlistfromarraylike">CreateListFromArrayLike</a>(<i>argumentsList</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>args</i>).</li>
        <li>Return <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>target</i>, <i>args</i>, <i>newTarget</i>).</li>
      </ol>

      <p>The <code>length</code> property of the <code>construct</code> function is <b>2</b>.</p>
    </section>

    <section id="sec-reflect.defineproperty">
      <h3 id="sec-26.1.3" title="26.1.3"> Reflect.defineProperty ( target, propertyKey, attributes )</h3><p class="normalbefore">When the <code>defineProperty</code> function is called with arguments <span style="font-family:       Times New Roman"><i>target</i>, <i>propertyKey</i></span>, and <var>attributes</var> the following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>key</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>propertyKey</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>key</i>).</li>
        <li>Let <i>desc</i> be <a href="sec-ecmascript-data-types-and-values#sec-topropertydescriptor">ToPropertyDescriptor</a>(<i>attributes</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
        <li>Return <i>target.</i>[[DefineOwnProperty]](<i>key</i>, <i>desc</i>).</li>
      </ol>
    </section>

    <section id="sec-reflect.deleteproperty">
      <h3 id="sec-26.1.4" title="26.1.4"> Reflect.deleteProperty ( target, propertyKey )</h3><p class="normalbefore">When the <code>deleteProperty</code> function is called with arguments <span style="font-family:       Times New Roman"><i>target</i> and <i>propertyKey</i></span>, the following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>key</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>propertyKey</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>key</i>).</li>
        <li>Return <i>target.</i>[[Delete]](<i>key</i>).</li>
      </ol>
    </section>

    <section id="sec-reflect.enumerate">
      <h3 id="sec-26.1.5" title="26.1.5">
          Reflect.enumerate ( target )</h3><p class="normalbefore">When the <code>enumerate</code> function is called with argument <var>target</var> the following
      steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Return <i>target.</i>[[Enumerate]]().</li>
      </ol>
    </section>

    <section id="sec-reflect.get">
      <h3 id="sec-26.1.6" title="26.1.6">
          Reflect.get ( target, propertyKey [ , receiver ])</h3><p class="normalbefore">When the <code>get</code> function is called with arguments <span style="font-family: Times New       Roman"><i>target</i>, <i>propertyKey</i></span>, and <var>receiver</var> the following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>key</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>propertyKey</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>key</i>).</li>
        <li>If <i>receiver</i> is not present, then
          <ol class="block">
            <li>Let <i>receiver</i> be <i>target</i>.</li>
          </ol>
        </li>
        <li>Return <i>target.</i>[[Get]](<i>key</i>, <i>receiver</i>).</li>
      </ol>

      <p>The <code>length</code> property of the <code>get</code> function is <b>2</b>.</p>
    </section>

    <section id="sec-reflect.getownpropertydescriptor">
      <h3 id="sec-26.1.7" title="26.1.7"> Reflect.getOwnPropertyDescriptor ( target, propertyKey )</h3><p class="normalbefore">When the <code>getOwnPropertyDescriptor</code> function is called with arguments <span style="font-family: Times New Roman"><i>target</i> and <i>propertyKey</i></span>, the following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>key</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>propertyKey</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>key</i>).</li>
        <li>Let <i>desc</i> be <i>target.</i>[[GetOwnProperty]](<i>key</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-frompropertydescriptor">FromPropertyDescriptor</a>(<i>desc</i>).</li>
      </ol>
    </section>

    <section id="sec-reflect.getprototypeof">
      <h3 id="sec-26.1.8" title="26.1.8"> Reflect.getPrototypeOf ( target )</h3><p class="normalbefore">When the <code>getPrototypeOf</code> function is called with argument <var>target</var> the
      following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Return <i>target.</i>[[GetPrototypeOf]]().</li>
      </ol>
    </section>

    <section id="sec-reflect.has">
      <h3 id="sec-26.1.9" title="26.1.9">
          Reflect.has ( target, propertyKey )</h3><p class="normalbefore">When the <code>has</code> function is called with arguments <span style="font-family: Times New       Roman"><i>target</i> and <i>propertyKey</i></span>, the following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>key</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>propertyKey</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>key</i>).</li>
        <li>Return <i>target.</i>[[HasProperty]](<i>key</i>).</li>
      </ol>
    </section>

    <section id="sec-reflect.isextensible">
      <h3 id="sec-26.1.10" title="26.1.10"> Reflect.isExtensible (target)</h3><p class="normalbefore">When the <code>isExtensible</code> function is called with argument <var>target</var> the following
      steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Return <i>target.</i>[[IsExtensible]]().</li>
      </ol>
    </section>

    <section id="sec-reflect.ownkeys">
      <h3 id="sec-26.1.11" title="26.1.11">
          Reflect.ownKeys ( target )</h3><p class="normalbefore">When the <code>ownKeys</code> function is called with argument <var>target</var> the following steps
      are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>keys</i> be <i>target.</i>[[OwnPropertyKeys]]().</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keys</i>).</li>
        <li>Return <a href="sec-abstract-operations#sec-createarrayfromlist">CreateArrayFromList</a>(<i>keys</i>).</li>
      </ol>
    </section>

    <section id="sec-reflect.preventextensions">
      <h3 id="sec-26.1.12" title="26.1.12"> Reflect.preventExtensions ( target )</h3><p class="normalbefore">When the <code>preventExtensions</code> function is called with argument <var>target</var>, the
      following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Return <i>target.</i>[[PreventExtensions]]().</li>
      </ol>
    </section>

    <section id="sec-reflect.set">
      <h3 id="sec-26.1.13" title="26.1.13">
          Reflect.set ( target, propertyKey, V [ , receiver ] )</h3><p class="normalbefore">When the <code>set</code> function is called with arguments <span style="font-family: Times New       Roman"><i>target</i>, <i>V</i>, <i>propertyKey</i></span>, and <var>receiver</var> the following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Let <i>key</i> be <a href="sec-abstract-operations#sec-topropertykey">ToPropertyKey</a>(<i>propertyKey</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>key</i>).</li>
        <li>If <i>receiver</i> is not present, then
          <ol class="block">
            <li>Let <i>receiver</i> be <i>target</i>.</li>
          </ol>
        </li>
        <li>Return <i>target.</i>[[Set]](<i>key</i>, <i>V</i>, <i>receiver</i>).</li>
      </ol>

      <p>The <code>length</code> property of the <code>set</code> function is <b>3</b>.</p>
    </section>

    <section id="sec-reflect.setprototypeof">
      <h3 id="sec-26.1.14" title="26.1.14"> Reflect.setPrototypeOf ( target, proto )</h3><p class="normalbefore">When the <code>setPrototypeOf</code> function is called with arguments <span style="font-family:       Times New Roman"><i>target</i> and <i>propertyKey</i></span>, the following steps are taken:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>proto</i>) is not Object and <i>proto</i> is not
            <b>null</b>, throw a <b>TypeError</b> exception</li>
        <li>Return <i>target.</i>[[SetPrototypeOf]](<i>proto</i>).</li>
      </ol>
    </section>
  </section>

  <section id="sec-proxy-objects">
    <div class="front">
      <h2 id="sec-26.2" title="26.2"> Proxy
          Objects</h2></div>

    <section id="sec-proxy-constructor">
      <div class="front">
        <h3 id="sec-26.2.1" title="26.2.1">
            The Proxy Constructor</h3><p>The Proxy constructor is the %Proxy% intrinsic object and the initial value of the <code>Proxy</code> property of the
        global object. When called as a constructor it creates and initializes a new proxy exotic object. <code>Proxy</code> is
        not intended to be called as a function and will throw an exception when called in that manner.</p>
      </div>

      <section id="sec-proxy-target-handler">
        <h4 id="sec-26.2.1.1" title="26.2.1.1"> Proxy ( target, handler )</h4><p class="normalbefore">When <code>Proxy</code> is called with arguments <var>target</var> and <var>handler</var> performs
        the following steps:</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Return <a href="sec-ordinary-and-exotic-objects-behaviours#sec-proxycreate">ProxyCreate</a>(<i>target</i>, <i>handler</i>).</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-proxy-constructor">
      <div class="front">
        <h3 id="sec-26.2.2" title="26.2.2"> Properties of the Proxy Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        <code>Proxy</code> constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>The <code>Proxy</code> constructor does not have a <code>prototype</code> property because proxy exotic objects do not
        have a [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> that requires
        initialization.</p>

        <p>Besides the <code>length</code> property (whose value is <b>2</b>), the <code>Proxy</code> constructor has the
        following properties:</p>
      </div>

      <section id="sec-proxy.revocable">
        <div class="front">
          <h4 id="sec-26.2.2.1" title="26.2.2.1"> Proxy.revocable ( target, handler )</h4><p class="normalbefore">The <code>Proxy.revocable</code> function is used to create a revocable Proxy object. When
          <code>Proxy.revocable</code> is called with arguments <var>target</var> and <var>handler</var> the following steps are
          taken:</p>

          <ol class="proc">
            <li>Let <i>p</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-proxycreate">ProxyCreate</a>(<i>target</i>, <i>handler</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>p</i>).</li>
            <li>Let <i>revoker</i> be a new built-in function object as defined in <a href="#sec-proxy-revocation-functions">26.2.2.1.1</a>.</li>
            <li>Set the [[RevocableProxy]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                <i>revoker</i> to <i>p</i>.</li>
            <li>Let <i>result</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(%ObjectPrototype%).</li>
            <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>result</i>, <code>"proxy"</code>,
                <i>p</i>).</li>
            <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>result</i>, <code>"revoke"</code>,
                <i>revoker</i>).</li>
            <li>Return <i>result</i>.</li>
          </ol>
        </div>

        <section id="sec-proxy-revocation-functions">
          <h5 id="sec-26.2.2.1.1" title="26.2.2.1.1"> Proxy Revocation Functions</h5><p>A Proxy revocation function is an anonymous function that has the ability to invalidate a specific Proxy object.</p>

          <p>Each Proxy revocation function has a [[RevocableProxy]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

          <p class="normalbefore">When a Proxy revocation function, <var>F</var>, is called the following steps are taken:</p>

          <ol class="proc">
            <li>Let <i>p</i> be the value of <i>F</i>&rsquo;s [[RevocableProxy]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>If <i>p</i> is <b>null</b>, return <b>undefined</b>.</li>
            <li>Set the value of <i>F</i>&rsquo;s [[RevocableProxy]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <b>null</b>.</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>p</i> is a Proxy object.</li>
            <li>Set the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>p</i> to
                <b>null</b>.</li>
            <li>Set the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>p</i>
                to <b>null</b>.</li>
            <li>Return <b>undefined</b>.</li>
          </ol>
        </section>
      </section>
    </section>
  </section>

  <section id="sec-module-namespace-objects">
    <div class="front">
      <h2 id="sec-26.3" title="26.3">
          Module Namespace Objects</h2><p>A Module Namespace Object is a module namespace exotic object that provides runtime property-based access to a
      module&rsquo;s exported bindings. There is no constructor function for Module Namespace Objects. Instead, such an object is
      created for each module that is imported by an <span class="nt">ImportDeclaration</span> that includes a <span class="nt">NameSpaceImport</span> (See <a href="sec-ecmascript-language-scripts-and-modules#sec-imports">15.2.2</a>).</p>

      <p>In addition to the properties specified in <a href="sec-ordinary-and-exotic-objects-behaviours#sec-module-namespace-exotic-objects">9.4.6</a> each Module Namespace
      Object has the own following properties:</p>
    </div>

    <section id="sec-@@tostringtag">
      <h3 id="sec-26.3.1" title="26.3.1">
          @@toStringTag</h3><p>The initial value of the @@toStringTag property is the String value <code>"Module"</code>.</p>

      <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
    </section>

    <section id="sec-@@iterator">
      <h3 id="sec-26.3.2" title="26.3.2"> [
          @@iterator ] (   )</h3><p class="normalbefore">When the @@iterator method is called with no arguments, the following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>N</i> be the <b>this</b> value.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>N</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Return <i>N</i>.[[Enumerate]]().</li>
      </ol>

      <p>The value of the <code>name</code> property of this function is <code>"[Symbol.iterator]"</code>.</p>
    </section>
  </section>
</section>

