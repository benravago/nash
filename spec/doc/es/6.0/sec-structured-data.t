<section id="sec-structured-data">
  <div class="front">
    <h1 id="sec-24" title="24"> Structured
        Data</h1></div>

  <section id="sec-arraybuffer-objects">
    <div class="front">
      <h2 id="sec-24.1" title="24.1">
          ArrayBuffer Objects</h2></div>

    <section id="sec-abstract-operations-for-arraybuffer-objects">
      <div class="front">
        <h3 id="sec-24.1.1" title="24.1.1"> Abstract Operations For ArrayBuffer Objects</h3></div>

      <section id="sec-allocatearraybuffer">
        <h4 id="sec-24.1.1.1" title="24.1.1.1"> AllocateArrayBuffer( constructor, byteLength )</h4><p class="normalbefore">The abstract operation AllocateArrayBuffer with arguments <var>constructor</var> and
        <var>byteLength</var> is used to create an ArrayBuffer object. It performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>obj</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(<i>constructor</i>,
              <code>"%ArrayBufferPrototype%"</code>, &laquo;&zwj;[[ArrayBufferData]], [[ArrayBufferByteLength]]&raquo; ).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>obj</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>byteLength</i> is a positive integer.</li>
          <li>Let <i>block</i> be <a href="sec-ecmascript-data-types-and-values#sec-createbytedatablock">CreateByteDataBlock</a>(<i>byteLength</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>block</i>).</li>
          <li>Set <i>obj&rsquo;s</i> [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>block</i>.</li>
          <li>Set <i>obj</i>&rsquo;s [[ArrayBufferByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>byteLength</i>.</li>
          <li>Return <i>obj</i>.</li>
        </ol>
      </section>

      <section id="sec-isdetachedbuffer">
        <h4 id="sec-24.1.1.2" title="24.1.1.2"> IsDetachedBuffer( arrayBuffer )</h4><p class="normalbefore">The abstract operation IsDetachedBuffer with argument  <var>arrayBuffer</var> performs the
        following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>arrayBuffer</i>) is Object and it has an
              [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>arrayBuffer&rsquo;s</i> [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> is <b>null</b>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-detacharraybuffer">
        <h4 id="sec-24.1.1.3" title="24.1.1.3"> DetachArrayBuffer( arrayBuffer )</h4><p class="normalbefore">The abstract operation DetachArrayBuffer with argument  <var>arrayBuffer</var> performs the
        following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>arrayBuffer</i>) is Object and it has [[ArrayBufferData]]
              and [[ArrayBufferByteLength]] internal slots.</li>
          <li>Set <i>arrayBuffer&rsquo;s</i> [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to <b>null</b>.</li>
          <li>Set <i>arrayBuffer</i>&rsquo;s [[ArrayBufferByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to 0.</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>null</b>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> Detaching an ArrayBuffer instance disassociates the <a href="sec-ecmascript-data-types-and-values#sec-data-blocks">Data
          Block</a> used as its backing store from the instance and sets the byte length of the buffer to 0. No operations defined
          by this specification use the DetachArrayBuffer abstract operation. However, an ECMAScript implementation or host
          environment may define such operations.</p>
        </div>
      </section>

      <section id="sec-clonearraybuffer">
        <h4 id="sec-24.1.1.4" title="24.1.1.4"> CloneArrayBuffer( srcBuffer, srcByteOffset [, cloneConstructor]
            )</h4><p class="normalbefore">The abstract operation CloneArrayBuffer takes three parameters, an ArrayBuffer
        <var>srcBuffer</var>, an integer <var>srcByteOffset</var> and optionally a constructor function
        <var>cloneConstructor</var>. It creates a new ArrayBuffer whose data is a copy of <var>srcBuffer&rsquo;s</var> data
        starting at <var>srcByteOffset</var>. This operation performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>srcBuffer</i>) is Object and it has an [[ArrayBufferData]]
              <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>cloneConstructor</i> is not present, then
            <ol class="block">
              <li>Let <i>cloneConstructor</i> be <a href="sec-abstract-operations#sec-speciesconstructor">SpeciesConstructor</a>(<i>srcBuffer</i>,
                  %ArrayBuffer%).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>cloneConstructor</i>).</li>
              <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>srcBuffer</i>) is <b>true</b>, throw a
                  <b>TypeError</b> exception.</li>
            </ol>
          </li>
          <li>Else, <a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>cloneConstructor</i>) is <b>true</b>.</li>
          <li>Let <i>srcLength</i> be the value of <i>srcBuffer</i>&rsquo;s [[ArrayBufferByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>srcByteOffset</i> &le; <i>srcLength</i>.</li>
          <li>Let <i>cloneLength</i> be <i>srcLength</i> &ndash; <i>srcByteOffset.</i></li>
          <li>Let <i>srcBlock</i> be the value of <i>srcBuffer&rsquo;s</i> [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>targetBuffer</i> be <a href="#sec-allocatearraybuffer">AllocateArrayBuffer</a>(<i>cloneConstructor</i>,
              <i>cloneLength</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetBuffer</i>).</li>
          <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>srcBuffer</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>targetBlock</i> be the value of <i>targetBuffer&rsquo;s</i> [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Perform <a href="sec-ecmascript-data-types-and-values#sec-copydatablockbytes">CopyDataBlockBytes</a>(<i>targetBlock</i>, 0, <i>srcBlock</i>,
              <i>srcByteOffset</i>, <i>cloneLength</i>).</li>
          <li>Return <i>targetBuffer</i>.</li>
        </ol>
      </section>

      <section id="sec-getvaluefrombuffer">
        <h4 id="sec-24.1.1.5" title="24.1.1.5"> GetValueFromBuffer ( arrayBuffer, byteIndex, type, isLittleEndian
            )</h4><p class="normalbefore">The abstract operation GetValueFromBuffer takes four parameters, an ArrayBuffer
        <var>arrayBuffer</var>, an integer <var>byteIndex</var>, a String <var>type</var>, and optionally a Boolean
        <var>isLittleEndian</var>. This operation performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>arrayBuffer</i>) is <b>false</b>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: There are sufficient bytes in <i>arrayBuffer</i> starting at
              <i>byteIndex</i> to represent a value of <i>type</i>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>byteIndex</i> is a positive integer.</li>
          <li>Let <i>block</i> be <i>arrayBuffer&rsquo;s</i> [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>elementSize</i> be the Number value of the Element Size value specified in <a href="sec-indexed-collections#table-49">Table 49</a>
              for Element Type <i>type</i>.</li>
          <li>Let <i>rawValue</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <i>elementSize</i>
              containing, in order<i>,</i> the <i>elementSize</i> sequence of bytes starting with
              <i>block</i>[<i>byteIndex</i>].</li>
          <li>If <i>isLittleEndian</i> is not present, set <i>isLittleEndian</i> to either <b>true</b> or <b>false</b>. The choice
              is implementation dependent and should be the alternative that is most efficient for the implementation. An
              implementation must use the same value each time this step is executed and the same value must be used for the
              corresponding step in the <a href="#sec-setvalueinbuffer">SetValueInBuffer</a> abstract operation.</li>
          <li>If <i>isLittleEndian</i> is <b>false</b>, reverse the order of the elements of <i>rawValue</i>.</li>
          <li>If <i>type</i> is <code>"Float32"</code>, then
            <ol class="block">
              <li>Let <i>value</i> be the byte elements of <i>rawValue</i> concatenated and interpreted as a little-endian bit
                  string encoding of an IEEE 754-2008 binary32 value.</li>
              <li>If <i>value</i> is an IEEE 754-2008 binary32 NaN value, return the <b>NaN</b> Number value.</li>
              <li>Return the Number value that corresponds to <i>value</i>.</li>
            </ol>
          </li>
          <li>If <i>type</i> is <code>"Float64"</code>, then
            <ol class="block">
              <li>Let <i>value</i> be the byte elements of <i>rawValue</i> concatenated and interpreted as a little-endian bit
                  string encoding of an IEEE 754-2008 binary64 value.</li>
              <li>If <i>value</i> is an IEEE 754-2008 binary64 NaN value, return the <b>NaN</b> Number value.</li>
              <li>Return the Number value that corresponds to <i>value</i>.</li>
            </ol>
          </li>
          <li>If the first code unit of <i>type</i> is <code>"U"</code>, then
            <ol class="block">
              <li>Let <i>intValue</i> be the byte elements of <i>rawValue</i> concatenated and interpreted as a bit string
                  encoding of an unsigned little-endian binary number.</li>
            </ol>
          </li>
          <li>Else
            <ol class="block">
              <li>Let <i>intValue</i> be the byte elements of <i>rawValue</i> concatenated and interpreted as a bit string
                  encoding of a binary little-endian 2&rsquo;s complement number of bit length <i>elementSize</i> &times; 8.</li>
            </ol>
          </li>
          <li>Return the Number value that corresponds to <i>intValue</i>.</li>
        </ol>
      </section>

      <section id="sec-setvalueinbuffer">
        <h4 id="sec-24.1.1.6" title="24.1.1.6"> SetValueInBuffer ( arrayBuffer, byteIndex, type, value,
            isLittleEndian )</h4><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">SetValueInBuffer</span> takes
        five parameters, an ArrayBuffer <var>arrayBuffer</var>, an integer <var>byteIndex</var>, a String <var>type</var>, a
        Number <var>value</var>, and optionally a Boolean <var>isLittleEndian</var>. This operation performs the following
        steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>arrayBuffer</i>) is <b>false</b>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: There are sufficient bytes in <i>arrayBuffer</i> starting at
              <i>byteIndex</i> to represent a value of <i>type</i>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>byteIndex</i> is a positive integer.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Number.</li>
          <li>Let <i>block</i> be <i>arrayBuffer&rsquo;s</i> [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>:  <i>block</i> is not <b>undefined</b>.</li>
          <li>Let <i>elementSize</i> be the Number value of the Element Size value specified in <a href="sec-indexed-collections#table-49">Table 49</a>
              for Element Type <i>type</i>.</li>
          <li>If <i>isLittleEndian</i> is not present, set <i>isLittleEndian</i> to either <b>true</b> or <b>false</b>. The choice
              is implementation dependent and should be the alternative that is most efficient for the implementation. An
              implementation must use the same value each time this step is executed and the same value must be used for the
              corresponding step in the <a href="#sec-getvaluefrombuffer">GetValueFromBuffer</a> abstract operation.</li>
          <li>If <i>type</i> is <code>"Float32"</code>, then
            <ol class="block">
              <li>Set <i>rawBytes</i> to a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the 4 bytes that
                  are the result of converting <i>value</i> to IEEE 754-2008 binary32 format using &ldquo;Round to nearest, ties
                  to even&rdquo; rounding mode. If <i>isLittleEndian</i> is <b>false</b>, the bytes are arranged in big endian
                  order. Otherwise, the bytes are arranged in little endian order. If <i>value</i> is <b>NaN</b>, <i>rawValue</i>
                  may be set to any implementation chosen IEEE 754-2008 binary64 format Not-a-Number encoding. An implementation
                  must always choose the same encoding for each implementation distinguishable <b>NaN</b> value.</li>
            </ol>
          </li>
          <li>Else, if <i>type</i> is <code>"Float64"</code>, then
            <ol class="block">
              <li>Set <i>rawBytes</i> to a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the 8 bytes that
                  are the IEEE 754-2008 binary64 format encoding of <i>value</i>. If <i>isLittleEndian</i> is <b>false</b>, the
                  bytes are arranged in big endian order. Otherwise, the bytes are arranged in little endian order. If
                  <i>value</i> is <b>NaN</b>, <i>rawValue</i> may be set to any implementation chosen IEEE 754-2008 binary32
                  format Not-a-Number encoding. An implementation must always choose the same encoding for each implementation
                  distinguishable <b>NaN</b> value.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>n</i> be the Number value of the Element Size specified in <a href="sec-indexed-collections#table-49">Table 49</a> for Element
                  Type <i>type</i>.</li>
              <li>Let <i>convOp</i> be the abstract operation named in the Conversion Operation column in <a href="sec-indexed-collections#table-49">Table 49</a> for Element Type <i>type</i>.</li>
              <li>Let <i>intValue</i> be <i>convOp</i>(<i>value</i>).</li>
              <li>If <i>intValue</i> &ge; 0, then
                <ol class="block">
                  <li>Let <i>rawBytes</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the
                      <i>n</i>-byte binary encoding of <i>intValue</i>. If <i>isLittleEndian</i> is <b>false</b>, the bytes are
                      ordered in big endian order. Otherwise, the bytes are ordered in little endian order.</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>rawBytes</i> be a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the
                      <i>n</i>-byte binary 2&rsquo;s complement encoding of <i>intValue</i>. If <i>isLittleEndian</i> is
                      <b>false</b>, the bytes are ordered in big endian order. Otherwise, the bytes are ordered in little endian
                      order.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Store the individual bytes of <i>rawBytes</i> into <i>block</i>, in order, starting at
              <i>block</i>[<i>byteIndex</i>].</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
        </ol>
      </section>
    </section>

    <section id="sec-arraybuffer-constructor">
      <div class="front">
        <h3 id="sec-24.1.2" title="24.1.2"> The ArrayBuffer Constructor</h3><p>The ArrayBuffer constructor is the %ArrayBuffer% intrinsic object and the initial value of the <code>ArrayBuffer</code>
        property of the global object. When called as a constructor it creates and initializes a new ArrayBuffer object.
        <code>ArrayBuffer</code> is not intended to be called as a function and will throw an exception when called in that
        manner.</p>

        <p>The <code>ArrayBuffer</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>ArrayBuffer</code> behaviour must include a <code>super</code> call to the <code>ArrayBuffer</code> constructor to
        create and initialize subclass instances with the internal state necessary to support the <code><a href="#sec-arraybuffer.prototype">ArrayBuffer.prototype</a></code> built-in methods.</p>
      </div>

      <section id="sec-arraybuffer-length">
        <h4 id="sec-24.1.2.1" title="24.1.2.1"> ArrayBuffer( length )</h4><p class="normalbefore">ArrayBuffer called with argument <var>length</var> performs the following steps:</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>numberLength</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>length</i>).</li>
          <li>Let <i>byteLength</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<i>numberLength</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>byteLength</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-samevaluezero">SameValueZero</a>(<i>numberLength</i>, <i>byteLength</i>) is <b>false</b>, throw a
              <b>RangeError</b> exception.</li>
          <li>Return <a href="#sec-allocatearraybuffer">AllocateArrayBuffer</a>(NewTarget, <i>byteLength</i>).</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-arraybuffer-constructor">
      <div class="front">
        <h3 id="sec-24.1.3" title="24.1.3"> Properties of the ArrayBuffer Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        ArrayBuffer constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides its <code>length</code> property (whose value is 1), the ArrayBuffer constructor has the following
        properties:</p>
      </div>

      <section id="sec-arraybuffer.isview">
        <h4 id="sec-24.1.3.1" title="24.1.3.1"> ArrayBuffer.isView ( arg )</h4><p class="normalbefore">The isView function takes one argument <var>arg</var>, and performs the following steps are
        taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>arg</i>) is not Object, return <b>false</b>.</li>
          <li>If <i>arg</i> has a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-arraybuffer.prototype">
        <h4 id="sec-24.1.3.2" title="24.1.3.2"> ArrayBuffer.prototype</h4><p>The initial value of ArrayBuffer.prototype is the intrinsic object %ArrayBufferPrototype% (<a href="#sec-properties-of-the-arraybuffer-prototype-object">24.1.4</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>

      <section id="sec-get-arraybuffer-@@species">
        <h4 id="sec-24.1.3.3" title="24.1.3.3"> get ArrayBuffer [ @@species ]</h4><p class="normalbefore"><code>ArrayBuffer[@@species]</code> is an accessor property whose set accessor function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Return the <b>this</b> value.</li>
        </ol>

        <p>The value of the <code>name</code> property of this function is <code>"get [Symbol.species]"</code>.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> ArrayBuffer prototype methods normally use their <code>this</code> object&rsquo;s
          constructor to create a derived object. However, a subclass constructor may over-ride that default behaviour by
          redefining its @@species property.</p>
        </div>
      </section>
    </section>

    <section id="sec-properties-of-the-arraybuffer-prototype-object">
      <div class="front">
        <h3 id="sec-24.1.4" title="24.1.4"> Properties of the ArrayBuffer Prototype Object</h3><p>The ArrayBuffer prototype object is the intrinsic object %ArrayBufferPrototype%. The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the ArrayBuffer prototype object is the
        intrinsic object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>). The ArrayBuffer
        prototype object is an ordinary object. It does not have an [[ArrayBufferData]] or [[ArrayBufferByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
      </div>

      <section id="sec-get-arraybuffer.prototype.bytelength">
        <h4 id="sec-24.1.4.1" title="24.1.4.1"> get ArrayBuffer.prototype.byteLength</h4><p class="normalbefore"><code>ArrayBuffer.prototype.byteLength</code> is an accessor property whose set accessor function
        is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>O</i> does not have an [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>O</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>length</i> be the value of <i>O</i>&rsquo;s [[ArrayBufferByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Return <i>length</i>.</li>
        </ol>
      </section>

      <section id="sec-arraybuffer.prototype.constructor">
        <h4 id="sec-24.1.4.2" title="24.1.4.2"> ArrayBuffer.prototype.constructor</h4><p>The initial value of <code>ArrayBuffer.prototype.constructor</code> is the intrinsic object %ArrayBuffer%.</p>
      </section>

      <section id="sec-arraybuffer.prototype.slice">
        <h4 id="sec-24.1.4.3" title="24.1.4.3"> ArrayBuffer.prototype.slice ( start, end )</h4><p class="normalbefore">The following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>O</i> does not have an [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>O</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>len</i> be the value of <i>O</i>&rsquo;s [[ArrayBufferByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>relativeStart</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>start</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeStart</i>).</li>
          <li>If <i>relativeStart</i> &lt; 0, let <i>first</i> be max((<i>len</i> + <i>relativeStart</i>),0); else let
              <i>first</i> be min(<i>relativeStart</i>, <i>len</i>).</li>
          <li>If <i>end</i> is <b>undefined</b>, let <i>relativeEnd</i> be <i>len</i>; else let <i>relativeEnd</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>end</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>relativeEnd</i>).</li>
          <li>If <i>relativeEnd</i> &lt; 0, let <i>final</i> be max((<i>len</i> + <i>relativeEnd</i>),0); else let <i>final</i> be
              min(<i>relativeEnd</i>, <i>len</i>).</li>
          <li>Let <i>newLen</i> be max(<i>final</i>-<i>first</i>,0).</li>
          <li>Let <i>ctor</i> be <a href="sec-abstract-operations#sec-speciesconstructor">SpeciesConstructor</a>(<i>O</i>, %ArrayBuffer%).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>ctor</i>).</li>
          <li>Let <i>new</i> be <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>ctor</i>, &laquo;<i>newLen</i>&raquo;).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>new</i>).</li>
          <li>If <i>new</i> does not have an [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>new</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>new</i>, <i>O</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If the value of <i>new</i>&rsquo;s [[ArrayBufferByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> &lt; <i>newLen</i>, throw a
              <b>TypeError</b> exception.</li>
          <li>NOTE: Side-effects of the above steps may have <span style="font-family: Times New Roman">detached</span>
              <i>O</i>.</li>
          <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>O</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>fromBuf</i> be the value of <i>O</i>&rsquo;s [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>toBuf</i> be the value of <i>new</i>&rsquo;s [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Perform <a href="sec-ecmascript-data-types-and-values#sec-copydatablockbytes">CopyDataBlockBytes</a>(<i>toBuf</i>, 0, <i>fromBuf</i>, <i>first</i>,
              <i>newLen</i>).</li>
          <li>Return <i>new</i>.</li>
        </ol>
      </section>

      <section id="sec-arraybuffer.prototype-@@tostringtag">
        <h4 id="sec-24.1.4.4" title="24.1.4.4"> ArrayBuffer.prototype [ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"ArrayBuffer"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-arraybuffer-instances">
      <h3 id="sec-24.1.5" title="24.1.5"> Properties of the ArrayBuffer Instances</h3><p>ArrayBuffer instances inherit properties from the ArrayBuffer prototype object. ArrayBuffer instances each have an
      [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> and an
      [[ArrayBufferByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

      <p>ArrayBuffer instances whose [[ArrayBufferData]] is <b>null</b> are considered to be detached and all operators to access
      or modify data contained in the ArrayBuffer instance will fail.</p>
    </section>
  </section>

  <section id="sec-dataview-objects">
    <div class="front">
      <h2 id="sec-24.2" title="24.2"> DataView
          Objects</h2></div>

    <section id="sec-abstract-operations-for-dataview-objects">
      <div class="front">
        <h3 id="sec-24.2.1" title="24.2.1"> Abstract Operations For DataView Objects</h3></div>

      <section id="sec-getviewvalue">
        <h4 id="sec-24.2.1.1" title="24.2.1.1">
            GetViewValue ( view, requestIndex, isLittleEndian, type )</h4><p class="normalbefore">The abstract operation GetViewValue with arguments <var>view</var>, <var>requestIndex</var>,
        <var>isLittleEndian</var>, and <var>type</var> is used by functions on DataView instances is to retrieve values from the
        view&rsquo;s buffer. It performs the following steps:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>view</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>view</i> does not have a [[DataView]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>numberIndex</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>requestIndex</i>).</li>
          <li>Let <i>getIndex</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>numberIndex</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>getIndex</i>).</li>
          <li>If <i>numberIndex</i> &ne; <i>getIndex</i> or <i>getIndex</i> &lt; 0, throw a <b>RangeError</b> exception.</li>
          <li>Let <i>isLittleEndian</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<i>isLittleEndian</i>).</li>
          <li>Let <i>buffer</i> be the value of <i>view&rsquo;s</i> [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>viewOffset</i> be the value of <i>view&rsquo;s</i> [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>viewSize</i> be the value of <i>view&rsquo;s</i> [[ByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>elementSize</i> be the Number value of the Element Size value specified in <a href="sec-indexed-collections#table-49">Table 49</a>
              for Element Type <i>type</i>.</li>
          <li>If <i>getIndex</i> +<i>elementSize</i> &gt; <i>viewSize</i>, throw a <b>RangeError</b> exception.</li>
          <li>Let <i>bufferIndex</i> be <i>getIndex</i> + <i>viewOffset</i>.</li>
          <li>Return <a href="#sec-getvaluefrombuffer">GetValueFromBuffer</a>(<i>buffer</i>, <i>bufferIndex</i>, <i>type</i>,
              <i>isLittleEndian</i>).</li>
        </ol>
      </section>

      <section id="sec-setviewvalue">
        <h4 id="sec-24.2.1.2" title="24.2.1.2">
            SetViewValue ( view, requestIndex, isLittleEndian, type, value )</h4><p class="normalbefore">The abstract operation SetViewValue with arguments <var>view</var>, <var>requestIndex</var>,
        <var>isLittleEndian</var>, <var>type</var>, and <var>value</var> is used by functions on DataView instances to store
        values into the view&rsquo;s buffer. It performs the following steps:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>view</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>view</i> does not have a [[DataView]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>numberIndex</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>requestIndex</i>).</li>
          <li>Let <i>getIndex</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>numberIndex</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>getIndex</i>).</li>
          <li>If <i>numberIndex</i> &ne; <i>getIndex</i> or <i>getIndex</i> &lt; 0, throw a <b>RangeError</b> exception.</li>
          <li>Let <i>isLittleEndian</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<i>isLittleEndian</i>).</li>
          <li>Let <i>buffer</i> be the value of <i>view&rsquo;s</i> [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>viewOffset</i> be the value of <i>view&rsquo;s</i> [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>viewSize</i> be the value of <i>view&rsquo;s</i> [[ByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>elementSize</i> be the Number value of the Element Size value specified in <a href="sec-indexed-collections#table-49">Table 49</a>
              for Element Type <i>type</i>.</li>
          <li>If <i>getIndex</i> +<i>elementSize</i> &gt; <i>viewSize</i>, throw a <b>RangeError</b> exception.</li>
          <li>Let <i>bufferIndex</i> be <i>getIndex</i> + <i>viewOffset</i>.</li>
          <li>Return <a href="#sec-setvalueinbuffer">SetValueInBuffer</a>(<i>buffer</i>, <i>bufferIndex</i>, <i>type</i>,
              <i>value</i>, <i>isLittleEndian</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The algorithms for <a href="#sec-getviewvalue">GetViewValue</a> and SetViewValue are
          identical except for their final steps.</p>
        </div>
      </section>
    </section>

    <section id="sec-dataview-constructor">
      <div class="front">
        <h3 id="sec-24.2.2" title="24.2.2"> The DataView Constructor</h3><p>The DataView constructor is the %DataView% intrinsic object and the initial value of the <code>DataView</code> property
        of the global object. When called as a constructor it creates and initializes a new DataView object. <code>DataView</code>
        is not intended to be called as a function and will throw an exception when called in that manner.</p>

        <p>The <code>DataView</code> constructor is designed to be subclassable. It may be used as the value of an
        <code>extends</code> clause of a class definition. Subclass constructors that intend to inherit the specified
        <code>DataView</code> behaviour must include a <code>super</code> call to the <code>DataView</code> constructor to create
        and initialize subclass instances with the internal state necessary to support the <code><a href="#sec-dataview.prototype">DataView.prototype</a></code> built-in methods.</p>
      </div>

      <section id="sec-dataview-buffer-byteoffset-bytelength">
        <h4 id="sec-24.2.2.1" title="24.2.2.1"> DataView (buffer [ , byteOffset [ , byteLength ] ] )</h4><p class="normalbefore"><code>DataView</code> called with arguments <span style="font-family: Times New         Roman"><i>buffer</i>, <i>byteOffset</i>, and <i>length</i></span> performs the following steps:</p>

        <ol class="proc">
          <li>If NewTarget is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>buffer</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>buffer</i> does not have an [[ArrayBufferData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>numberOffset</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>byteOffset</i>).</li>
          <li>Let <i>offset</i> be <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>numberOffset</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>offset</i>).</li>
          <li>If <i>numberOffset</i> &ne; <i>offset</i> or <i>offset</i> &lt; 0, throw a <b>RangeError</b> exception.</li>
          <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>bufferByteLength</i> be the value of <i>buffer&rsquo;s</i> [[ArrayBufferByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>offset</i> &gt; <i>bufferByteLength</i>, throw a <b>RangeError</b> exception.</li>
          <li>If <i>byteLength</i> is <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>viewByteLength</i> be <i>bufferByteLength</i> &ndash; <i>offset</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>viewByteLength</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<i>byteLength</i>)<i>.</i></li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>viewByteLength</i>).</li>
              <li>If <i>offset</i>+<i>viewByteLength</i> &gt; <i>bufferByteLength</i>, throw a <b>RangeError</b> exception.</li>
            </ol>
          </li>
          <li>Let <i>O</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(NewTarget,
              <code>"%DataViewPrototype%"</code>, &laquo;&zwj;[[DataView]], [[ViewedArrayBuffer]], [[ByteLength]],
              [[ByteOffset]]&raquo; ).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>O</i>).</li>
          <li>Set <i>O&rsquo;s</i> [[DataView]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <b>true</b>.</li>
          <li>Set <i>O&rsquo;s</i> [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> to <i>buffer</i>.</li>
          <li>Set <i>O</i>&rsquo;s [[ByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <i>viewByteLength</i>.</li>
          <li>Set <i>O</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <i>offset</i>.</li>
          <li>Return <i>O</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-properties-of-the-dataview-constructor">
      <div class="front">
        <h3 id="sec-24.2.3" title="24.2.3"> Properties of the DataView Constructor</h3><p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the
        <code>DataView</code> constructor is the intrinsic object %FunctionPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>).</p>

        <p>Besides the <code>length</code> property (whose value is 3), the DataView constructor has the following properties:</p>
      </div>

      <section id="sec-dataview.prototype">
        <h4 id="sec-24.2.3.1" title="24.2.3.1"> DataView.prototype</h4><p>The initial value of <code>DataView.prototype</code> is the intrinsic object %DataViewPrototype% (<a href="#sec-properties-of-the-dataview-prototype-object">24.2.4</a>).</p>

        <p>This property has the attributes { [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
        <b>false</b> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-the-dataview-prototype-object">
      <div class="front">
        <h3 id="sec-24.2.4" title="24.2.4"> Properties of the DataView Prototype Object</h3><p>The DataView prototype object is the intrinsic object %DataViewPrototype%. The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the DataView prototype object is the intrinsic
        object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>). The DataView prototype
        object is an ordinary object. It does not have a [[DataView]], [[ViewedArrayBuffer]], [[ByteLength]], or [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>
      </div>

      <section id="sec-get-dataview.prototype.buffer">
        <h4 id="sec-24.2.4.1" title="24.2.4.1"> get DataView.prototype.buffer</h4><p class="normalbefore"><code>DataView.prototype.buffer</code> is an accessor property whose set accessor function is
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

      <section id="sec-get-dataview.prototype.bytelength">
        <h4 id="sec-24.2.4.2" title="24.2.4.2"> get DataView.prototype.byteLength</h4><p class="normalbefore"><code>DataView</code>.<code>prototype.byteLength</code> is an accessor property whose set accessor
        function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>O</i> does not have a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>size</i> be the value of <i>O</i>&rsquo;s [[ByteLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Return <i>size</i>.</li>
        </ol>
      </section>

      <section id="sec-get-dataview.prototype.byteoffset">
        <h4 id="sec-24.2.4.3" title="24.2.4.3"> get DataView.prototype.byteOffset</h4><p class="normalbefore"><code>DataView</code>.<code>prototype.byteOffset</code> is an accessor property whose set accessor
        function is <span class="value">undefined</span>. Its get accessor function performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>O</i> be the <b>this</b> value.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>O</i>) is not Object, throw a <b>TypeError</b>
              exception.</li>
          <li>If <i>O</i> does not have a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>Let <i>offset</i> be the value of <i>O</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Return <i>offset</i>.</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.constructor">
        <h4 id="sec-24.2.4.4" title="24.2.4.4"> DataView.prototype.constructor</h4><p>The initial value of <code>DataView.prototype.constructor</code> is the intrinsic object %DataView%.</p>
      </section>

      <section id="sec-dataview.prototype.getfloat32">
        <h4 id="sec-24.2.4.5" title="24.2.4.5"> DataView.prototype.getFloat32 ( byteOffset [ , littleEndian ] )</h4><p class="normalbefore">When the <code>getFloat32</code> method is called with argument <var>byteOffset</var> and optional
        argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-getviewvalue">GetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Float32"</code>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.getfloat64">
        <h4 id="sec-24.2.4.6" title="24.2.4.6"> DataView.prototype.getFloat64 ( byteOffset [ , littleEndian ] )</h4><p class="normalbefore">When the <code>getFloat64</code> method is called with argument <var>byteOffset</var> and optional
        argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-getviewvalue">GetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Float64"</code>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.getint8">
        <h4 id="sec-24.2.4.7" title="24.2.4.7"> DataView.prototype.getInt8 ( byteOffset )</h4><p class="normalbefore">When the <code>getInt8</code> method is called with argument <var>byteOffset</var> the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-getviewvalue">GetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <b>true</b>,
              <code>"Int8"</code>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.getint16">
        <h4 id="sec-24.2.4.8" title="24.2.4.8"> DataView.prototype.getInt16 ( byteOffset [ , littleEndian ] )</h4><p class="normalbefore">When the <code>getInt16</code> method is called with argument <var>byteOffset</var> and optional
        argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-getviewvalue">GetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Int16"</code>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.getint32">
        <h4 id="sec-24.2.4.9" title="24.2.4.9"> DataView.prototype.getInt32 ( byteOffset [ , littleEndian ] )</h4><p class="normalbefore">When the <code>getInt32</code> method is called with argument <var>byteOffset</var> and optional
        argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>undefined</b>.</li>
          <li>Return <a href="#sec-getviewvalue">GetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Int32"</code>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.getuint8">
        <h4 id="sec-24.2.4.10" title="24.2.4.10"> DataView.prototype.getUint8 ( byteOffset )</h4><p class="normalbefore">When the <code>getUint8</code> method is called with argument <var>byteOffset</var> the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-getviewvalue">GetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <b>true</b>,
              <code>"Uint8"</code>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.getuint16">
        <h4 id="sec-24.2.4.11" title="24.2.4.11"> DataView.prototype.getUint16 ( byteOffset [ , littleEndian ] )</h4><p class="normalbefore">When the <code>getUint16</code> method is called with argument <var>byteOffset</var> and optional
        argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-getviewvalue">GetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Uint16"</code>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.getuint32">
        <h4 id="sec-24.2.4.12" title="24.2.4.12"> DataView.prototype.getUint32 ( byteOffset [ , littleEndian ] )</h4><p class="normalbefore">When the <code>getUint32</code> method is called with argument <var>byteOffset</var> and optional
        argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-getviewvalue">GetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Uint32"</code>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.setfloat32">
        <h4 id="sec-24.2.4.13" title="24.2.4.13"> DataView.prototype.setFloat32 ( byteOffset, value [ , littleEndian ]
            )</h4><p class="normalbefore">When the <code>setFloat32</code> method is called with arguments <var>byteOffset</var> and
        <var>value</var> and optional argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-setviewvalue">SetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Float32"</code>, <i>value</i>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.setfloat64">
        <h4 id="sec-24.2.4.14" title="24.2.4.14"> DataView.prototype.setFloat64 ( byteOffset, value [ , littleEndian ]
            )</h4><p class="normalbefore">When the <code>setFloat64</code> method is called with arguments <var>byteOffset</var> and
        <var>value</var> and optional argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-setviewvalue">SetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Float64"</code>, <i>value</i>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.setint8">
        <h4 id="sec-24.2.4.15" title="24.2.4.15"> DataView.prototype.setInt8 ( byteOffset, value )</h4><p class="normalbefore">When the <code>setInt8</code> method is called with arguments <var>byteOffset</var> and
        <var>value</var> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-setviewvalue">SetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <b>true</b>, <code>"Int8"</code>,
              <i>value</i>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.setint16">
        <h4 id="sec-24.2.4.16" title="24.2.4.16"> DataView.prototype.setInt16 ( byteOffset, value [ , littleEndian ]
            )</h4><p class="normalbefore">When the <code>setInt16</code> method is called with arguments <var>byteOffset</var> and
        <var>value</var> and optional argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-setviewvalue">SetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Int16"</code>, <i>value</i>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.setint32">
        <h4 id="sec-24.2.4.17" title="24.2.4.17"> DataView.prototype.setInt32 ( byteOffset, value [ , littleEndian ]
            )</h4><p class="normalbefore">When the <code>setInt32</code> method is called with arguments <var>byteOffset</var> and
        <var>value</var> and optional argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-setviewvalue">SetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Int32"</code>, <i>value</i>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.setuint8">
        <h4 id="sec-24.2.4.18" title="24.2.4.18"> DataView.prototype.setUint8 ( byteOffset, value )</h4><p class="normalbefore">When the <code>setUint8</code> method is called with arguments <var>byteOffset</var> and
        <var>value</var> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>Return <a href="#sec-setviewvalue">SetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <b>true</b>, <code>"Uint8"</code>,
              <i>value</i>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.setuint16">
        <h4 id="sec-24.2.4.19" title="24.2.4.19"> DataView.prototype.setUint16 ( byteOffset, value [ , littleEndian ]
            )</h4><p class="normalbefore">When the <code>setUint16</code> method is called with arguments <var>byteOffset</var> and
        <var>value</var> and optional argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-setviewvalue">SetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Uint16"</code>, <i>value</i>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype.setuint32">
        <h4 id="sec-24.2.4.20" title="24.2.4.20"> DataView.prototype.setUint32 ( byteOffset, value [ , littleEndian ]
            )</h4><p class="normalbefore">When the <code>setUint32</code> method is called with arguments <var>byteOffset</var> and
        <var>value</var> and optional argument <i>littleEndian</i> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>v</i> be the <b>this</b> value.</li>
          <li>If <i>littleEndian</i> is not present, let <i>littleEndian</i> be <b>false</b>.</li>
          <li>Return <a href="#sec-setviewvalue">SetViewValue</a>(<i>v</i>, <i>byteOffset</i>, <i>littleEndian</i>,
              <code>"Uint32"</code>, <i>value</i>).</li>
        </ol>
      </section>

      <section id="sec-dataview.prototype-@@tostringtag">
        <h4 id="sec-24.2.4.21" title="24.2.4.21"> DataView.prototype[ @@toStringTag ]</h4><p>The initial value of the @@toStringTag property is the String value <code>"DataView"</code>.</p>

        <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
      </section>
    </section>

    <section id="sec-properties-of-dataview-instances">
      <h3 id="sec-24.2.5" title="24.2.5"> Properties of DataView Instances</h3><p>DataView instances are ordinary objects that inherit properties from the DataView prototype object. DataView instances
      each have [[DataView]], [[ViewedArrayBuffer]], [[ByteLength]], and [[ByteOffset]] internal slots.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> The value of the [[DataView]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is not used within this specification. The simple
        presence of that <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is used within the
        specification to identify objects created using the <code>DataView</code> constructor.</p>
      </div>
    </section>
  </section>

  <section id="sec-json-object">
    <div class="front">
      <h2 id="sec-24.3" title="24.3"> The JSON
          Object</h2><p>The JSON object is the %JSON% intrinsic object and the initial value of the <code>JSON</code> property of the global
      object. The JSON object is a single ordinary object that contains two functions, <b>parse</b> and <b>stringify</b>, that are
      used to parse and construct JSON texts. The JSON Data Interchange Format is defined in ECMA-404. The JSON interchange format
      used in this specification is exactly that described by ECMA-404.</p>

      <p>Conforming implementations of <code><a href="#sec-json.parse">JSON.parse</a></code> and <code><a href="#sec-json.stringify">JSON.stringify</a></code> must support the exact interchange format described in the ECMA-404
      specification without any deletions or extensions to the format.</p>

      <p>The value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the JSON
      object is the intrinsic object %ObjectPrototype% (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>). The
      value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the JSON object
      is set to <b>true</b>.</p>

      <p>The JSON object does not have a [[Construct]] internal method; it is not possible to use the JSON object as a constructor
      with the <code>new</code> operator.</p>

      <p>The JSON object does not have a [[Call]] internal method; it is not possible to invoke the JSON object as a function.</p>
    </div>

    <section id="sec-json.parse">
      <div class="front">
        <h3 id="sec-24.3.1" title="24.3.1">
            JSON.parse ( text [ , reviver ] )</h3><p>The <code>parse</code> function parses a JSON text (a JSON-formatted String) and produces an ECMAScript value. The JSON
        format is a subset of the syntax for ECMAScript literals, Array Initializers and Object Initializers. After parsing, JSON
        objects are realized as ECMAScript objects. JSON arrays are realized as ECMAScript Array instances. JSON strings, numbers,
        booleans, and null are realized as ECMAScript Strings, Numbers, Booleans, and <b>null</b>.</p>

        <p class="normalbefore">The optional <i>reviver</i> parameter is a function that takes two parameters, <i>key</i> and
        <i>value</i>. It can filter and transform the results. It is called with each of the <i>key</i>/<i>value</i> pairs
        produced by the parse, and its return value is used instead of the original value. If it returns what it received, the
        structure is not modified. If it returns <b>undefined</b> then the property is deleted from the result.</p>

        <ol class="proc">
          <li>Let <i>JText</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>text</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>JText</i>).</li>
          <li>Parse <i>JText</i> interpreted as UTF-16 encoded Unicode points (<a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types-string-type">6.1.4</a>) as a JSON text as specified in <br />ECMA-404. Throw a
              <b>SyntaxError</b> exception if <i>JText</i> is not a valid JSON text as defined in that specification.</li>
          <li>Let <i>scriptText</i> be the result of concatenating <code>"("</code>, <i>JText</i>, and <code>");"</code>.</li>
          <li>Let <i>completion</i> be the result of parsing and evaluating <i>scriptText</i> as if it was the source text of an
              ECMAScript <i>Script</i>. but using the alternative definition of <i>DoubleStringCharacter</i> provided below. The
              extended PropertyDefinitionEvaluation semantics defined in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-__proto__-property-names-in-object-initializers">B.3.1</a> must not be used during the evaluation.</li>
          <li>Let <i>unfiltered</i> be <i>completion</i>.[[value]].</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>unfiltered</i> will be either a primitive value or an object
              that is defined by either an <i>ArrayLiteral</i> or an <i>ObjectLiteral</i>.</li>
          <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>reviver</i>) is <b>true</b>, then
            <ol class="block">
              <li>Let <i>root</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(%ObjectPrototype%).</li>
              <li>Let <i>rootName</i> be the empty String.</li>
              <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>root</i>, <i>rootName</i>,
                  <i>unfiltered</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is <b>true</b>.</li>
              <li>Return <a href="#sec-internalizejsonproperty">InternalizeJSONProperty</a>(<i>root</i>, <i>rootName</i>).</li>
            </ol>
          </li>
          <li>Else
            <ol class="block">
              <li>Return <i>unfiltered</i>.</li>
            </ol>
          </li>
        </ol>

        <p>JSON allows Unicode code units 0x2028 (LINE SEPARATOR) and 0x2029 (PARAGRAPH SEPARATOR) to directly appear in <span class="nt">String</span> literals without using an escape sequence. This is enabled by using the following alternative
        definition of <span class="nt">DoubleStringCharacter</span> when parsing <var>scriptText</var> in step 5:</p>

        <div class="gp">
          <div class="lhs"><span class="nt">DoubleStringCharacter</span> <span class="geq">::</span></div>
          <div class="rhs"><span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">"</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span> <span class="gprose">U+0000 through U+001F</span></div>
          <div class="rhs"><code class="t">\</code> <span class="nt">EscapeSequence</span></div>
        </div>

        <ul>
          <li>
            <p>The SV of <span class="prod"><span class="nt">DoubleStringCharacter</span> <span class="geq">::</span> <span class="nt">SourceCharacter</span> <span class="grhsmod">but not one of</span> <code class="t">"</code> <span class="grhsmod">or</span> <code class="t">\</code> <span class="grhsmod">or</span></span> U+0000 <b>through</b> U+001F
            is the <a href="sec-ecmascript-language-source-code#sec-utf16encoding">UTF16Encoding</a> (<a href="sec-ecmascript-language-source-code#sec-utf16encoding">10.1.1</a>) of the code point
            value of <i>SourceCharacter</i>.</p>
          </li>
        </ul>

        <div class="note">
          <p><span class="nh">NOTE</span> The syntax of a valid JSON text is a subset of the ECMAScript <span class="nt">PrimaryExpression</span> syntax. Hence a valid JSON text is also a valid <span class="nt">PrimaryExpression</span>. Step 3 above verifies that <span class="nt">JText</span> conforms to that subset.
          When <var>scriptText</var> is parsed and evaluated as a <span class="nt">Script</span> the result will be either a
          String, Number, Boolean, or Null primitive value or an Object defined as if by an <span class="nt">ArrayLiteral</span>
          or <span class="nt">ObjectLiteral</span>.</p>
        </div>
      </div>

      <section id="sec-internalizejsonproperty">
        <h4 id="sec-24.3.1.1" title="24.3.1.1"> Runtime Semantics: InternalizeJSONProperty( holder, name)</h4><p class="normalbefore">The abstract operation InternalizeJSONProperty is a recursive abstract operation that takes two
        parameters: a <var>holder</var> object and the String <var>name</var> of a property in that object.
        InternalizeJSONProperty uses the value of <var>reviver</var> that was originally passed to the above parse function.</p>

        <ol class="proc">
          <li>Let <i>val</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>holder</i>, <i>name</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>val</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>val</i>) is Object, then
            <ol class="block">
              <li>Let <i>isArray</i> be <a href="sec-abstract-operations#sec-isarray">IsArray</a>(<i>val</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>isArray</i>).</li>
              <li>If <i>isArray</i> is <b>true</b>,  then
                <ol class="block">
                  <li>Set <i>I</i> to 0.</li>
                  <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>val</i>,
                      <code>"length"</code>)).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
                  <li>Repeat while <i>I</i> &lt; <i>len</i>,
                    <ol class="block">
                      <li>Let <i>newElement</i> be InternalizeJSONProperty(<i>val</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>I</i>)).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>newElement</i>).</li>
                      <li>If <i>newElement</i> is <b>undefined</b>, then
                        <ol class="block">
                          <li>Let <i>status</i> be <i>val</i>.[[Delete]](<a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>I</i>)).</li>
                        </ol>
                      </li>
                      <li>Else
                        <ol class="block">
                          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>val</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>I</i>), <i>newElement</i>).</li>
                          <li>NOTE This algorithm intentionally does not throw an exception if status is <b>false</b>.</li>
                        </ol>
                      </li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                      <li>Add 1 to <i>I</i>.</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li>Else
                <ol class="block">
                  <li>Let <i>keys</i> be <a href="sec-abstract-operations#sec-enumerableownnames">EnumerableOwnNames</a>(<i>val</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>keys</i>).</li>
                  <li>For each String <i>P</i> in <i>keys</i> do,
                    <ol class="block">
                      <li>Let <i>newElement</i> be InternalizeJSONProperty(<i>val</i>, <i>P</i>).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>newElement</i>).</li>
                      <li>If <i>newElement</i> is <b>undefined</b>, then
                        <ol class="block">
                          <li>Let <i>status</i> be <i>val</i>.[[Delete]](<i>P</i>).</li>
                        </ol>
                      </li>
                      <li>Else
                        <ol class="block">
                          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>val</i>, <i>P</i>,
                              <i>newElement</i>).</li>
                          <li>NOTE This algorithm intentionally does not throw an exception if status is <b>false</b>.</li>
                        </ol>
                      </li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>).</li>
                    </ol>
                  </li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>reviver</i>, <i>holder</i>, &laquo;<i>name</i>, <i>val</i>&raquo;).</li>
        </ol>

        <p>It is not permitted for a conforming implementation of <code><a href="#sec-json.parse">JSON.parse</a></code> to extend
        the JSON grammars. If an implementation wishes to support a modified or extended JSON interchange format it must do so by
        defining a different parse function.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> In the case where there are duplicate name Strings within an object, lexically preceding
          values for the same key shall be overwritten.</p>
        </div>
      </section>
    </section>

    <section id="sec-json.stringify">
      <div class="front">
        <h3 id="sec-24.3.2" title="24.3.2">
            JSON.stringify ( value [ , replacer [ , space ] ] )</h3><p>The <code>stringify</code> function returns a String in UTF-16 encoded JSON format representing an ECMAScript value. It
        can take three parameters. The <var>value</var> parameter is an ECMAScript value, which is usually an object or array,
        although it can also be a String, Boolean, Number or <b>null</b>. The optional <var>replacer</var> parameter is either a
        function that alters the way objects and arrays are stringified, or an array of Strings and Numbers that acts as a white
        list for selecting the object properties that will be stringified. The optional <var>space</var> parameter is a String or
        Number that allows the result to have white space injected into it to improve human readability.</p>

        <p class="normalbefore">These are the steps in stringifying an object:</p>

        <ol class="proc">
          <li>Let <i>stack</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>indent</i> be the empty String.</li>
          <li>Let <i>PropertyList</i> and <i>ReplacerFunction</i> be <b>undefined</b>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>replacer</i>) is Object, then
            <ol class="block">
              <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>replacer</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>ReplacerFunction</i> be <i>replacer</i>.</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>isArray</i> be <a href="sec-abstract-operations#sec-isarray">IsArray</a>(<i>replacer</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>isArray</i>).</li>
                  <li>If <i>isArray</i> is <b>true</b>, then
                    <ol class="block">
                      <li>Let <i>PropertyList</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a></li>
                      <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>replacer</i>,
                          <code>"length"</code>)).</li>
                      <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
                      <li>Let <i>k</i> be 0.</li>
                      <li>Repeat while <i>k</i>&lt;<i>len</i>.
                        <ol class="block">
                          <li>Let <i>v</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>replacer</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>k</i>)).</li>
                          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>v</i>).</li>
                          <li>Let <i>item</i> be <b>undefined</b>.</li>
                          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>v</i>) is String, let <i>item</i> be
                              <i>v.</i></li>
                          <li>Else if <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>v</i>) is Number, let
                              <i>item</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>v</i>).</li>
                          <li>Else if <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>v</i>) is Object, then
                            <ol class="block">
                              <li>If <i>v</i> has a [[StringData]] or [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, let <i>item</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>v</i>).</li>
                              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>item</i>).</li>
                            </ol>
                          </li>
                          <li>If <i>item</i> is not <b>undefined</b> and <i>item</i> is not currently an element of
                              <i>PropertyList</i>, then
                            <ol class="block">
                              <li>Append <i>item</i> to the end of <i>PropertyList</i>.</li>
                            </ol>
                          </li>
                          <li>Let <i>k</i> be <i>k</i>+1.</li>
                        </ol>
                      </li>
                    </ol>
                  </li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>space</i>) is Object, then
            <ol class="block">
              <li>If <i>space</i> has a [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                  slot</a>, then
                <ol class="block">
                  <li>Let <i>space</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>space</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>space</i>).</li>
                </ol>
              </li>
              <li>Else if <i>space</i> has a [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                  slot</a>, then
                <ol class="block">
                  <li>Let <i>space</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>space</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>space</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>space</i>) is Number, then
            <ol class="block">
              <li>Let <i>space</i> be min(10, <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>space</i>)).</li>
              <li>Set <i>gap</i> to a String containing <i>space</i> occurrences of code unit 0x0020 (SPACE). This will be the
                  empty String if <i>space</i> is less than 1.</li>
            </ol>
          </li>
          <li>Else if <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>space</i>) is String, then
            <ol class="block">
              <li>If the number of elements in <i>space</i> is 10 or less, set <i>gap</i> to <i>space</i> otherwise set <i>gap</i>
                  to a String consisting of the first 10 elements of <i>space</i>.</li>
            </ol>
          </li>
          <li>Else
            <ol class="block">
              <li>Set <i>gap</i> to the empty String.</li>
            </ol>
          </li>
          <li>Let <i>wrapper</i> be <a href="sec-ordinary-and-exotic-objects-behaviours#sec-objectcreate">ObjectCreate</a>(%ObjectPrototype%).</li>
          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>wrapper</i>, the empty String,
              <i>value</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is <b>true</b>.</li>
          <li>Return <a href="#sec-serializejsonproperty">SerializeJSONProperty</a>(the empty String, <i>wrapper</i>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 1</span> JSON structures are allowed to be nested to any depth, but they must be acyclic. If
          <var>value</var> is or contains a cyclic structure, then the stringify function must throw a <b>TypeError</b> exception.
          This is an example of a value that cannot be stringified:</p>

          <pre class="NoteCode">a = [];</pre>
          <pre class="NoteCode">a[0] = a;</pre>
          <pre class="NoteCode">my_text = JSON.stringify(a); // This must throw a TypeError.</pre>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> Symbolic primitive values are rendered as follows:</p>

          <ul>
            <li>The <span class="value">null</span> value is rendered in JSON text as the String <code>null</code>.</li>
            <li>The <span class="value">undefined</span> value is not rendered.</li>
            <li>The <span class="value">true</span> value is rendered in JSON text as the String <code>true</code>.</li>
            <li>The <span class="value">false</span> value is rendered in JSON text as the String <code>false</code>.</li>
          </ul>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> String values are wrapped in QUOTATION MARK (<code>"</code>) code units. The code
          units <code>"</code> and <code>\</code> are escaped with <code>\</code> prefixes. Control characters code units are
          replaced with escape sequences <code>\u</code>HHHH, or with the shorter forms, <code>\b</code> (BACKSPACE),
          <code>\f</code> (FORM FEED), <code>\n</code> (LINE FEED), <code>\r</code> (CARRIAGE RETURN), <code>\t</code> (CHARACTER
          TABULATION).</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 4</span> Finite numbers are stringified as if by calling <span style="font-family: Times New           Roman"><a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>number</i>)</span>. <b>NaN</b> and Infinity regardless of sign are
          represented as the String <code>null</code>.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 5</span> Values that do not have a JSON representation (such as <b>undefined</b> and functions)
          do not produce a String. Instead they produce the <span class="value">undefined</span> value. In arrays these values are
          represented as the String <code>null</code>. In objects an unrepresentable value causes the property to be excluded from
          stringification.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 6</span> An object is rendered as U+007B (LEFT CURLY BRACKET) followed by zero or more
          properties, separated with a U+002C (COMMA), closed with a U+007D (RIGHT CURLY BRACKET). A property is a quoted String
          representing the key or property name, a U+003A (COLON), and then the stringified property value. An array is rendered
          as an opening U+005B (LEFT SQUARE BRACKET followed by zero or more values, separated with a U+002C (COMMA), closed with
          a U+005D (RIGHT SQUARE BRACKET).</p>
        </div>
      </div>

      <section id="sec-serializejsonproperty">
        <h4 id="sec-24.3.2.1" title="24.3.2.1"> Runtime Semantics: SerializeJSONProperty ( key, holder )</h4><p class="normalbefore">The abstract operation SerializeJSONProperty with arguments <var>key</var>, <span style="font-family: Times New Roman">and</span> <var>holder</var> has access to <span class="nt">ReplacerFunction</span>
        from the invocation of the <code>stringify</code> method. Its algorithm is as follows:</p>

        <ol class="proc">
          <li>Let <i>value</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>holder</i>, <i>key</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Object, then
            <ol class="block">
              <li>Let <i>toJSON</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>value</i>, <code>"toJSON"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>toJSON</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>toJSON</i>) is <b>true</b>
                <ol class="block">
                  <li>Let <i>value</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>toJSON</i>, <i>value</i>,
                      &laquo;<i>key</i>&raquo;).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>ReplacerFunction</i> is not <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>value</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>ReplacerFunction</i>, <i>holder</i>, &laquo;<i>key</i>,
                  <i>value</i>&raquo;).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Object, then
            <ol class="block">
              <li>If <i>value</i> has a [[NumberData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                  slot</a>, then
                <ol class="block">
                  <li>Let <i>value</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>value</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
                </ol>
              </li>
              <li>Else if <i>value</i> has a [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                  slot</a>, then
                <ol class="block">
                  <li>Let <i>value</i> be <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>value</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
                </ol>
              </li>
              <li>Else if <i>value</i> has a [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
                  slot</a>, then
                <ol class="block">
                  <li>Let <i>value</i> be the value of the [[BooleanData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>value</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>value</i> is <b>null</b>, return <code>"null"</code>.</li>
          <li>If <i>value</i> is <b>true</b>, return <code>"true"</code>.</li>
          <li>If <i>value</i> is <b>false</b>, return <code>"false"</code>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is String, return <a href="#sec-quotejsonstring">QuoteJSONString</a>(<i>value</i>).</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Number, then
            <ol class="block">
              <li>If <i>value</i> is finite, return <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>value</i>).</li>
              <li>Else, return <code>"null"</code>.</li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is Object, and <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>value</i>) is <b>false</b>, then
            <ol class="block">
              <li>Let <i>isArray</i> be <a href="sec-abstract-operations#sec-isarray">IsArray</a>(<i>value</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>isArray</i>).</li>
              <li>If <i>isArray</i> is <b>true</b>, return <a href="#sec-serializejsonarray">SerializeJSONArray</a>(<i>value</i>).</li>
              <li>Else, return <a href="#sec-serializejsonobject">SerializeJSONObject</a>(<i>value</i>).</li>
            </ol>
          </li>
          <li>Return <b>undefined</b>.</li>
        </ol>
      </section>

      <section id="sec-quotejsonstring">
        <h4 id="sec-24.3.2.2" title="24.3.2.2">
            Runtime Semantics: QuoteJSONString ( value )</h4><p class="normalbefore">The abstract operation QuoteJSONString with argument <var>value</var> wraps a String value in
        QUOTATION MARK code units and escapes certain other code units within it.</p>

        <ol class="proc">
          <li>Let <i>product</i> be code unit 0x0022 (QUOTATION MARK).</li>
          <li>For each code unit <i>C</i> in <i>value</i>
            <ol class="block">
              <li>If <i>C</i> is 0x0022 (QUOTATION MARK) or 0x005C (REVERSE SOLIDUS), then
                <ol class="block">
                  <li>Let <i>product</i> be the concatenation of <i>product</i> and code unit 0x005C (REVERSE SOLIDUS).</li>
                  <li>Let <i>product</i> be the concatenation of <i>product</i> and <i>C</i>.</li>
                </ol>
              </li>
              <li>Else if <i>C</i> is 0x0008 (BACKSPACE), 0x000C (FORM FEED), 0x000A (LINE FEED), 0x000D (CARRIAGE RETURN), or
                  0x000B (LINE TABULATION), then
                <ol class="block">
                  <li>Let <i>product</i> be the concatenation of <i>product</i> and code unit 0x005C (REVERSE SOLIDUS).</li>
                  <li>Let <i>abbrev</i> be the String value corresponding to the value of <i>C</i> as follows:
                    <table class="lightweight">
                      <tr>
                        <td>BACKSPACE</td>
                        <td><span class="string value">"b"</span></td>
                      </tr>
                      <tr>
                        <td>FORM FEED (FF)</td>
                        <td><span class="string value">"f"</span></td>
                      </tr>
                      <tr>
                        <td>LINE FEED (LF)</td>
                        <td><span class="string value">"n"</span></td>
                      </tr>
                      <tr>
                        <td>CARRIAGE RETURN (CR)</td>
                        <td><span class="string value">"r"</span></td>
                      </tr>
                      <tr>
                        <td>LINE TABULATION</td>
                        <td><span class="string value">"t"</span></td>
                      </tr>
                    </table>
                  </li>
                  <li>Let <i>product</i> be the concatenation of <i>product</i> and <i>abbrev</i>.</li>
                </ol>
              </li>
              <li>Else if <i>C</i> has a code unit value less than 0x0020 (SPACE), then
                <ol class="block">
                  <li>Let <i>product</i> be the concatenation of <i>product</i> and code unit 0x005C (REVERSE SOLIDUS).</li>
                  <li>Let <i>product</i> be the concatenation of <i>product</i> and <code>"u"</code>.</li>
                  <li>Let <i>hex</i> be the string result of converting the numeric code unit value of <i>C</i> to a String of
                      four hexadecimal digits. Alphabetic hexadecimal digits are presented as lowercase Latin letters.</li>
                  <li>Let <i>product</i> be the concatenation of <i>product</i> and <i>hex</i>.</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>product</i> be the concatenation of <i>product</i> and <i>C</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>product</i> be the concatenation of <i>product</i> and code unit 0x0022 (QUOTATION MARK).</li>
          <li>Return <i>product</i>.</li>
        </ol>
      </section>

      <section id="sec-serializejsonobject">
        <h4 id="sec-24.3.2.3" title="24.3.2.3"> Runtime Semantics: SerializeJSONObject ( value )</h4><p class="normalbefore">The abstract operation SerializeJSONObject with argument <var>value</var> serializes an object. It
        has access to the <var>stack</var>, <var>indent</var>, <var>gap</var>, and <span class="nt">PropertyList</span> values of
        the current invocation of the <code>stringify</code> method.</p>

        <ol class="proc">
          <li>If <i>stack</i> contains <i>value</i>, throw a <b>TypeError</b> exception because the structure is cyclical.</li>
          <li>Append <i>value</i> to <i>stack</i>.</li>
          <li>Let <i>stepback</i> be <i>indent</i>.</li>
          <li>Let <i>indent</i> be the concatenation of <i>indent</i> and <i>gap</i>.</li>
          <li>If <i>PropertyList</i> is not <b>undefined</b>, then
            <ol class="block">
              <li>Let <i>K</i> be <i>PropertyList</i>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>K</i> be <a href="sec-abstract-operations#sec-enumerableownnames">EnumerableOwnNames</a>(<i>value</i>).</li>
            </ol>
          </li>
          <li>Let <i>partial</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>For each element <i>P</i> of <i>K</i>,
            <ol class="block">
              <li>Let <i>strP</i> be <a href="#sec-serializejsonproperty">SerializeJSONProperty</a>(<i>P</i>, <i>value</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>strP</i>).</li>
              <li>If <i>strP</i> is not <b>undefined</b>, then
                <ol class="block">
                  <li>Let <i>member</i> be <a href="#sec-quotejsonstring">QuoteJSONString</a>(<i>P</i>).</li>
                  <li>Let <i>member</i> be the concatenation of <i>member</i> and the string <code>":"</code>.</li>
                  <li>If <i>gap</i> is not the empty String, then
                    <ol class="block">
                      <li>Let <i>member</i> be the concatenation of <i>member</i> and code unit 0x0020 (SPACE).</li>
                    </ol>
                  </li>
                  <li>Let <i>member</i> be the concatenation of <i>member</i> and <i>strP</i>.</li>
                  <li>Append <i>member</i> to <i>partial</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>partial</i> is empty, then
            <ol class="block">
              <li>Let <i>final</i> be <code>"{}"</code>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>If <i>gap</i> is the empty String, then
                <ol class="block">
                  <li>Let <i>properties</i> be a String formed by concatenating all the element Strings of <i>partial</i> with
                      each adjacent pair of Strings separated with code unit 0x002C (COMMA). A comma is not inserted either before
                      the first String or after the last String.</li>
                  <li>Let <i>final</i> be the result of concatenating <b><code>"{"</code>,</b> <i>properties</i>, and
                      <code>"}"</code>.</li>
                </ol>
              </li>
              <li>Else <i>gap</i> is not the empty String
                <ol class="block">
                  <li>Let <i>separator</i> be the result of concatenating code unit 0x002C (COMMA), code unit 0x000A (LINE FEED),
                      and <i>indent</i>.</li>
                  <li>Let <i>properties</i> be a String formed by concatenating all the element Strings of <i>partial</i> with
                      each adjacent pair of Strings separated with <i>separator</i>. The <i>separator</i> String is not inserted
                      either before the first String or after the last String.</li>
                  <li>Let <i>final</i> be the result of concatenating <code>"{"</code>, code unit 0x000A (LINE FEED),
                      <i>indent</i>, <i>properties</i>, code unit 0x000A, <i>stepback</i>, and <code>"}"</code>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Remove the last element of <i>stack</i>.</li>
          <li>Let <i>indent</i> be <i>stepback</i>.</li>
          <li>Return <i>final</i>.</li>
        </ol>
      </section>

      <section id="sec-serializejsonarray">
        <h4 id="sec-24.3.2.4" title="24.3.2.4"> Runtime Semantics: SerializeJSONArray ( value )</h4><p class="normalbefore">The abstract operation SerializeJSONArray with argument <var>value</var> serializes an array. It
        has access to the <var>stack</var>, <var>indent</var>, and <var>gap</var> values of the current invocation of the
        <code>stringify</code> method.</p>

        <ol class="proc">
          <li>If <i>stack</i> contains <i>value</i>, throw a <b>TypeError</b> exception because the structure is cyclical.</li>
          <li>Append <i>value</i> to <i>stack</i>.</li>
          <li>Let <i>stepback</i> be <i>indent</i>.</li>
          <li>Let <i>indent</i> be the concatenation of <i>indent</i> and <i>gap</i>.</li>
          <li>Let <i>partial</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>len</i> be <a href="sec-abstract-operations#sec-tolength">ToLength</a>(<a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>value</i>,
              <code>"length"</code>)).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>len</i>).</li>
          <li>Let <i>index</i> be 0.</li>
          <li>Repeat while <i>index</i> &lt; <i>len</i>
            <ol class="block">
              <li>Let <i>strP</i> be <a href="#sec-serializejsonproperty">SerializeJSONProperty</a>(<a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>index</i>), <i>value</i>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>strP</i>).</li>
              <li>If <i>strP</i> is <b>undefined</b>, then
                <ol class="block">
                  <li>Append <code>"null"</code> to <i>partial</i>.</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Append <i>strP</i> to <i>partial</i>.</li>
                </ol>
              </li>
              <li>Increment <i>index</i> by 1.</li>
            </ol>
          </li>
          <li>If <i>partial</i> is empty, then
            <ol class="block">
              <li>Let <i>final</i> be <code>"[]"</code>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>If <i>gap</i> is the empty String, then
                <ol class="block">
                  <li>Let <i>properties</i> be a String formed by concatenating all the element Strings of <i>partial</i> with
                      each adjacent pair of Strings separated with code unit 0x002C (COMMA). A comma is not inserted either before
                      the first String or after the last String.</li>
                  <li>Let <i>final</i> be the result of concatenating <b><code>"["</code>,</b> <i>properties</i>, and
                      <code>"]"</code>.</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>Let <i>separator</i> be the result of concatenating code unit 0x002C (COMMA), code unit 0x000A (LINE FEED),
                      and <i>indent</i>.</li>
                  <li>Let <i>properties</i> be a String formed by concatenating all the element Strings of <i>partial</i> with
                      each adjacent pair of Strings separated with <i>separator</i>. The <i>separator</i> String is not inserted
                      either before the first String or after the last String.</li>
                  <li>Let <i>final</i> be the result of concatenating <code>"["</code>, code unit 0x000A (LINE FEED),
                      <i>indent</i>, <i>properties</i>, code unit 0x000A, <i>stepback</i>, and <code>"]"</code>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Remove the last element of <i>stack</i>.</li>
          <li>Let <i>indent</i> be <i>stepback</i>.</li>
          <li>Return <i>final</i>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> The representation of arrays includes only the elements between zero and
          <code>array.length</code> <span style="font-family: Times New Roman">&ndash; 1</span> inclusive. Properties whose keys
          are not array indexes are excluded from the stringification. An array is stringified as an opening LEFT SQUARE BRACKET,
          elements separated by COMMA, and a closing RIGHT SQUARE BRACKET.</p>
        </div>
      </section>
    </section>

    <section id="sec-json-@@tostringtag">
      <h3 id="sec-24.3.3" title="24.3.3">
          JSON [ @@toStringTag ]</h3><p>The initial value of the @@toStringTag property is the String value <code>"JSON"</code>.</p>

      <p>This property has the attributes { [[Writable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">false</span>, [[Configurable]]: <span class="value">true</span> }.</p>
    </section>
  </section>
</section>

