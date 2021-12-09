<section id="sec-ordinary-and-exotic-objects-behaviours">
  <div class="front">
    <h1 id="sec-9" title="9"> Ordinary and Exotic Objects Behaviours</h1></div>

  <section id="sec-ordinary-object-internal-methods-and-internal-slots">
    <div class="front">
      <h2 id="sec-9.1" title="9.1"> Ordinary Object Internal Methods and Internal Slots</h2><p>All ordinary objects have an <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> called
      [[Prototype]]. The value of this <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is either
      <b>null</b> or an object and is used for implementing inheritance. Data properties of the [[Prototype]] object are inherited
      (are visible as properties of the child object) for the purposes of get access, but not for set access. Accessor properties
      are inherited for both get access and set access.</p>

      <p>Every ordinary object has a Boolean-valued [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> that controls whether or not properties may be
      added to the object. If the value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
      slot</a> is <b>false</b> then additional properties may not be added to the object. In addition, if [[Extensible]] is
      <b>false</b> the value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
      the object may not be modified. Once the value of an object&rsquo;s [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> has been set to <b>false</b> it may not be
      subsequently changed to <b>true</b>.</p>

      <p>In the following algorithm descriptions, assume <var>O</var> is an ordinary object, <var>P</var> is a <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key value</a>, <var>V</var> is any <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript
      language value</a>, and <span class="nt">Desc</span> is a <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property
      Descriptor</a> record.</p>
    </div>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-getprototypeof">
      <h3 id="sec-9.1.1" title="9.1.1"> [[GetPrototypeOf]] ( )</h3><p class="normalbefore">When the [[GetPrototypeOf]] internal method of <var>O</var> is called the following steps are
      taken:</p>

      <ol class="proc">
        <li>Return the value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
            <i>O</i>.</li>
      </ol>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-setprototypeof-v">
      <h3 id="sec-9.1.2" title="9.1.2"> [[SetPrototypeOf]] (V)</h3><p class="normalbefore">When the [[SetPrototypeOf]] internal method of <var>O</var> is called with argument <var>V</var> the
      following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: Either <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>V</i>) is Object or <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>V</i>) is Null.</li>
        <li>Let <i>extensible</i> be the value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>current</i> be the value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>V</i>, <i>current</i>), return <b>true.</b></li>
        <li>If <i>extensible</i> is <b>false</b>, return <b>false</b>.</li>
        <li>Let <i>p</i> be <i>V</i>.</li>
        <li>Let <i>done</i> be <b>false</b>.</li>
        <li>Repeat while <i>done</i> is <b>false</b>,
          <ol class="block">
            <li>If <i>p</i> is <b>null</b>, let <i>done</i> be <b>true</b>.</li>
            <li>Else, if <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>p</i>, <i>O</i>) is <b>true</b>, return <b>false</b>.</li>
            <li>Else,
              <ol class="block">
                <li>If the [[GetPrototypeOf]] internal method of <i>p</i> is not the ordinary object internal method defined in <a href="#sec-ordinary-object-internal-methods-and-internal-slots-getprototypeof">9.1.1</a>, let <i>done</i> be
                    <b>true</b>.</li>
                <li>Else, let <i>p</i> be the value of <i>p</i>&rsquo;s [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Set the value of the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
            <i>O</i> to <i>V</i>.</li>
        <li>Return <b>true</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> The loop in step 8 guarantees that there will be no circularities in any prototype chain
        that only includes objects that use the ordinary object definitions for  [[GetPrototypeOf]] and [[SetPrototypeOf]].</p>
      </div>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-isextensible">
      <h3 id="sec-9.1.3" title="9.1.3"> [[IsExtensible]] ( )</h3><p class="normalbefore">When the [[IsExtensible]] internal method of <var>O</var> is called the following steps are
      taken:</p>

      <ol class="proc">
        <li>Return the value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
            <i>O</i>.</li>
      </ol>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-preventextensions">
      <h3 id="sec-9.1.4" title="9.1.4"> [[PreventExtensions]] ( )</h3><p class="normalbefore">When the [[PreventExtensions]] internal method of <var>O</var> is called the following steps are
      taken:</p>

      <ol class="proc">
        <li>Set the value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
            <i>O</i> to <b>false</b>.</li>
        <li>Return <b>true.</b></li>
      </ol>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-getownproperty-p">
      <div class="front">
        <h3 id="sec-9.1.5" title="9.1.5"> [[GetOwnProperty]] (P)</h3><p class="normalbefore">When the [[GetOwnProperty]] internal method of <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>Return <a href="#sec-ordinarygetownproperty">OrdinaryGetOwnProperty</a>(<i>O</i>, <i>P</i>).</li>
        </ol>
      </div>

      <section id="sec-ordinarygetownproperty">
        <h4 id="sec-9.1.5.1" title="9.1.5.1"> OrdinaryGetOwnProperty (O, P)</h4><p class="normalbefore">When the abstract operation OrdinaryGetOwnProperty is called with Object <var>O</var> and with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
              <b>true</b>.</li>
          <li>If <i>O</i> does not have an own property with key <i>P</i>, return <b>undefined</b>.</li>
          <li>Let <i>D</i> be a newly created <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a> with
              no fields.</li>
          <li>Let <i>X</i> be <i>O</i>&rsquo;s own property whose key is <i>P</i>.</li>
          <li>If <i>X</i> is a data property, then
            <ol class="block">
              <li>Set <i>D</i>.[[Value]] to the value of <i>X</i>&rsquo;s [[Value]] attribute.</li>
              <li>Set <i>D</i>.[[Writable]] to the value of <i>X</i>&rsquo;s [[Writable]] attribute</li>
            </ol>
          </li>
          <li>Else <i>X</i> is an accessor property, so
            <ol class="block">
              <li>Set <i>D</i>.[[Get]] to the value of <i>X</i>&rsquo;s [[Get]] attribute.</li>
              <li>Set <i>D</i>.[[Set]] to the value of <i>X</i>&rsquo;s [[Set]] attribute.</li>
            </ol>
          </li>
          <li>Set <i>D</i>.[[Enumerable]] to the value of <i>X</i>&rsquo;s [[Enumerable]] attribute.</li>
          <li>Set <i>D</i>.[[Configurable]] to the value of <i>X</i>&rsquo;s [[Configurable]] attribute.</li>
          <li>Return <i>D</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-defineownproperty-p-desc">
      <div class="front">
        <h3 id="sec-9.1.6" title="9.1.6"> [[DefineOwnProperty]] (P, Desc)</h3><p class="normalbefore">When the [[DefineOwnProperty]] internal method of <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> and <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property
        Descriptor</a> <span class="nt">Desc</span>, the following steps are taken:</p>

        <ol class="proc">
          <li>Return <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>O</i>, <i>P</i>, <i>Desc</i>).</li>
        </ol>
      </div>

      <section id="sec-ordinarydefineownproperty">
        <h4 id="sec-9.1.6.1" title="9.1.6.1"> OrdinaryDefineOwnProperty (O, P, Desc)</h4><p class="normalbefore">When the abstract operation <span style="font-family: Times New         Roman">OrdinaryDefineOwnProperty</span> is called with Object <var>O</var>, <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>
        <span style="font-family: Times New Roman"><i>P</i>,</span> and <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span> the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>current</i> be <i>O</i>.[[GetOwnProperty]](<i>P</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>current</i>).</li>
          <li>Let <i>extensible</i> be the value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
          <li>Return <a href="#sec-validateandapplypropertydescriptor">ValidateAndApplyPropertyDescriptor</a>(<i>O</i>, <i>P</i>,
              <i>extensible</i>, <i>Desc</i>, <i>current</i>).</li>
        </ol>
      </section>

      <section id="sec-iscompatiblepropertydescriptor">
        <h4 id="sec-9.1.6.2" title="9.1.6.2"> IsCompatiblePropertyDescriptor (Extensible, Desc, Current)</h4><p class="normalbefore">When the abstract operation <span style="font-family: Times New         Roman">IsCompatiblePropertyDescriptor</span> is called with Boolean value <span class="nt">Extensible</span>, and Property
        Descriptors <span class="nt">Desc</span>, and <span class="nt">Current</span> the following steps are taken:</p>

        <ol class="proc">
          <li>Return <a href="#sec-validateandapplypropertydescriptor">ValidateAndApplyPropertyDescriptor</a>(<b>undefined</b>,
              <b>undefined</b>, <i>Extensible</i>, <i>Desc</i>, <i>Current</i>).</li>
        </ol>
      </section>

      <section id="sec-validateandapplypropertydescriptor">
        <h4 id="sec-9.1.6.3" title="9.1.6.3"> ValidateAndApplyPropertyDescriptor (O, P, extensible, Desc,
            current)</h4><p>When the abstract operation <span style="font-family: Times New Roman">ValidateAndApplyPropertyDescriptor</span> is
        called with Object <var>O</var>, <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <span style="font-family: Times New         Roman"><i>P</i>,</span> Boolean value <var>extensible</var>, and Property Descriptors <span class="nt">Desc</span>, and
        <var>current</var> the following steps are taken:</p>

        <p>This algorithm contains steps that test various fields of the <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span> for specific
        values. The fields that are tested in this manner need not actually exist in <span class="nt">Desc</span>. If a field is
        absent then its value is considered to be <b>false</b>.</p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> If <span class="value">undefined</span> is passed as the <var>O</var> argument only
          validation is performed and no object updates are performed.</p>
        </div>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: If <i>O</i> is not <b>undefined</b> then <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is <b>true</b>.</li>
          <li>If <i>current</i> is <b>undefined</b>, then
            <ol class="block">
              <li>If <i>extensible</i> is <b>false</b>, return <b>false</b>.</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>extensible</i> is <b>true</b>.</li>
              <li>If <a href="sec-ecmascript-data-types-and-values#sec-isgenericdescriptor">IsGenericDescriptor</a>(<i>Desc</i>) or <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>Desc</i>) is <b>true</b>, then
                <ol class="block">
                  <li>If <i>O</i> is not <b>undefined</b>, create an own data property named <i>P</i> of object <i>O</i> whose
                      [[Value]], [[Writable]], [[Enumerable]] and [[Configurable]] attribute values are described by <i>Desc</i>.
                      If the value of an attribute field of <i>Desc</i> is absent, the attribute of the newly created property is
                      set to its default value.</li>
                </ol>
              </li>
              <li>Else <i>Desc</i> must be an accessor <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property
                  Descriptor</a>,
                <ol class="block">
                  <li>If <i>O</i> is not <b>undefined</b>, create an own accessor property named <i>P</i> of object <i>O</i> whose
                      [[Get]], [[Set]], [[Enumerable]] and [[Configurable]] attribute values are described by <i>Desc</i>. If the
                      value of an attribute field of <i>Desc</i> is absent, the attribute of the newly created property is set to
                      its default value.</li>
                </ol>
              </li>
              <li>Return <b>true</b>.</li>
            </ol>
          </li>
          <li>Return <b>true</b>, if every field in <i>Desc</i> is absent.</li>
          <li>Return <b>true</b>, if every field in <i>Desc</i> also occurs in <i>current</i> and the value of every field in
              <i>Desc</i> is the same value as the corresponding field in <i>current</i> when compared using <a href="sec-abstract-operations#sec-samevalue">the SameValue algorithm</a>.</li>
          <li>If the [[Configurable]] field of <i>current</i> is <b>false</b>, then
            <ol class="block">
              <li>Return <b>false</b>, if the [[Configurable]] field of <i>Desc</i> is <b>true</b>.</li>
              <li>Return <b>false</b>, if the [[Enumerable]] field of <i>Desc</i> is present and the [[Enumerable]] fields of
                  <i>current</i> and <i>Desc</i> are the Boolean negation of each other.</li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values#sec-isgenericdescriptor">IsGenericDescriptor</a>(<i>Desc</i>) is <b>true</b>, no further validation is
              required.</li>
          <li>Else if <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>current</i>) and <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>Desc</i>) have different results, then
            <ol class="block">
              <li>Return <b>false</b>, if the [[Configurable]] field of <i>current</i> is <b>false</b>.</li>
              <li>If <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>current</i>) is <b>true</b>, then
                <ol class="block">
                  <li>If <i>O</i> is not <b>undefined</b>, convert the property named <i>P</i> of object <i>O</i> from a data
                      property to an accessor property. Preserve the existing values of the converted property&rsquo;s
                      [[Configurable]] and [[Enumerable]] attributes and set the rest of the property&rsquo;s attributes to their
                      default values.</li>
                </ol>
              </li>
              <li>Else,
                <ol class="block">
                  <li>If <i>O</i> is not <b>undefined</b>, convert the property named <i>P</i> of object <i>O</i> from an accessor
                      property to a data property. Preserve the existing values of the converted property&rsquo;s [[Configurable]]
                      and [[Enumerable]] attributes and set the rest of the property&rsquo;s attributes to their default
                      values.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Else if <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>current</i>) and <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>Desc</i>) are both <b>true</b>, then
            <ol class="block">
              <li>If the [[Configurable]] field of <i>current</i> is <b>false</b>, then
                <ol class="block">
                  <li>Return <b>false</b>, if the [[Writable]] field of <i>current</i> is <b>false</b> and the [[Writable]] field
                      of <i>Desc</i> is <b>true</b>.</li>
                  <li>If the [[Writable]] field of <i>current</i> is <b>false</b>, then
                    <ol class="block">
                      <li>Return <b>false</b>, if the [[Value]] field of <i>Desc</i> is present and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>Desc</i>.[[Value]], <i>current</i>.[[Value]]) is
                          <b>false</b>.</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li>Else the [[Configurable]] field of <i>current</i> is <b>true</b>, so any change is acceptable.</li>
            </ol>
          </li>
          <li>Else <a href="sec-ecmascript-data-types-and-values#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>current</i>) and <a href="sec-ecmascript-data-types-and-values#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>Desc</i>) are both <b>true</b>,
            <ol class="block">
              <li>If the [[Configurable]] field of <i>current</i> is <b>false</b>, then
                <ol class="block">
                  <li>Return <b>false</b>, if the [[Set]] field of <i>Desc</i> is present and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>Desc</i>.[[Set]], <i>current</i>.[[Set]]) is <b>false</b>.</li>
                  <li>Return <b>false</b>, if the [[Get]] field of <i>Desc</i> is present and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>Desc</i>.[[Get]], <i>current</i>.[[Get]]) is <b>false</b>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>O</i> is not <b>undefined</b>, then
            <ol class="block">
              <li>For each field of <i>Desc</i> that is present, set the corresponding attribute of the property named <i>P</i> of
                  object <i>O</i> to the value of the field.</li>
            </ol>
          </li>
          <li>Return <b>true</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE 2</span> Step 8.b allows any field of <span style="font-family: Times New Roman">Desc</span> to
          be different from the corresponding field of <span style="font-family: Times New Roman">current</span> if <span style="font-family: Times New Roman">current&rsquo;s</span> [[Configurable]] field is <span class="value">true</span>.
          This even permits changing the [[Value]] of a property whose [[Writable]] attribute is <span class="value">false</span>.
          This is allowed because a <span class="value">true</span> [[Configurable]] attribute would permit an equivalent sequence
          of calls where [[Writable]] is first set to <span class="value">true</span>, a new [[Value]] is set, and then
          [[Writable]] is set to <span class="value">false</span>.</p>
        </div>
      </section>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-hasproperty-p">
      <div class="front">
        <h3 id="sec-9.1.7" title="9.1.7"> [[HasProperty]](P)</h3><p class="normalbefore">When the [[HasProperty]] internal method of <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>Return <a href="#sec-ordinaryhasproperty">OrdinaryHasProperty</a>(<i>O</i>, <i>P</i>).</li>
        </ol>
      </div>

      <section id="sec-ordinaryhasproperty">
        <h4 id="sec-9.1.7.1" title="9.1.7.1"> OrdinaryHasProperty (O, P)</h4><p class="normalbefore">When the abstract operation OrdinaryHasProperty is called with Object <var>O</var> and with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
              <b>true</b>.</li>
          <li>Let <i>hasOwn</i> be <a href="#sec-ordinarygetownproperty">OrdinaryGetOwnProperty</a>(<i>O</i>, <i>P</i>).</li>
          <li>If <i>hasOwn</i> is not <b>undefined</b>, return <b>true</b>.</li>
          <li>Let <i>parent</i> be <i>O</i>.[[GetPrototypeOf]]().</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>parent</i>).</li>
          <li>If <i>parent</i> is not <b>null</b>, then
            <ol class="block">
              <li>Return <i>parent</i>.[[HasProperty]](<i>P</i>).</li>
            </ol>
          </li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-get-p-receiver">
      <h3 id="sec-9.1.8" title="9.1.8"> [[Get]] (P, Receiver)</h3><p class="normalbefore">When the [[Get]] internal method of <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property
      key</a> <var>P</var> and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> <span class="nt">Receiver</span> the following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>desc</i> be <i>O</i>.[[GetOwnProperty]](<i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
        <li>If <i>desc</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Let <i>parent</i> be <i>O</i>.[[GetPrototypeOf]]().</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>parent</i>).</li>
            <li>If <i>parent</i> is <b>null</b>, return <b>undefined.</b></li>
            <li>Return <i>parent</i>.[[Get]](<i>P</i>, <i>Receiver</i>).</li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>desc</i>) is <b>true</b>, return
            <i>desc</i>.[[Value]].</li>
        <li>Otherwise, <a href="sec-ecmascript-data-types-and-values#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>desc</i>) must be <b>true</b> so, let
            <i>getter</i> be <i>desc</i>.[[Get]].</li>
        <li>If <i>getter</i> is <b>undefined</b>, return <b>undefined</b>.</li>
        <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>getter,</i>  <i>Receiver</i>).</li>
      </ol>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-set-p-v-receiver">
      <h3 id="sec-9.1.9" title="9.1.9"> [[Set]] ( P, V, Receiver)</h3><p class="normalbefore">When the [[Set]] internal method of <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property
      key</a> <var>P</var>, value <var>V</var>, and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> <span class="nt">Receiver</span>, the following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>ownDesc</i> be <i>O</i>.[[GetOwnProperty]](<i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>ownDesc</i>).</li>
        <li>If <i>ownDesc</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Let <i>parent</i> be <i>O</i>.[[GetPrototypeOf]]().</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>parent</i>).</li>
            <li>If <i>parent</i> is not <b>null</b>, then
              <ol class="block">
                <li>Return <i>parent</i>.[[Set]](<i>P</i>, <i>V</i>, <i>Receiver</i>).</li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Let <i>ownDesc</i> be the PropertyDescriptor{[[Value]]: <b>undefined</b>, [[Writable]]: <b>true</b>,
                    [[Enumerable]]: <b>true</b>, [[Configurable]]: <b>true</b>}.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>If <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>ownDesc</i>) is <b>true</b>, then
          <ol class="block">
            <li>If <i>ownDesc</i>.[[Writable]] is <b>false</b>, return <b>false</b>.</li>
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>Receiver</i>) is not Object, return
                <b>false</b>.</li>
            <li>Let <i>existingDescriptor</i> be <i>Receiver</i>.[[GetOwnProperty]](<i>P</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>existingDescriptor</i>).</li>
            <li>If <i>existingDescriptor</i> is not <b>undefined</b>, then
              <ol class="block">
                <li>If <a href="sec-ecmascript-data-types-and-values#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>existingDescriptor</i>) is <b>true</b>,
                    return <b>false</b>.</li>
                <li>If <i>existingDescriptor</i>.[[Writable]] is <b>false</b>, return <b>false</b>.</li>
                <li>Let <i>valueDesc</i> be the PropertyDescriptor{[[Value]]: <i>V</i>}.</li>
                <li>Return <i>Receiver</i>.[[DefineOwnProperty]](<i>P</i>, <i>valueDesc</i>).</li>
              </ol>
            </li>
            <li>Else <i>Receiver</i> does not currently have a property <i>P</i>,
              <ol class="block">
                <li>Return <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>Receiver</i>, <i>P</i>, <i>V</i>).</li>
              </ol>
            </li>
          </ol>
        </li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>ownDesc</i>) is <b>true</b>.</li>
        <li>Let <i>setter</i> be <i>ownDesc</i>.[[Set]].</li>
        <li>If <i>setter</i> is <b>undefined</b>, return <b>false</b>.</li>
        <li>Let <i>setterResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>setter</i>, <i>Receiver</i>, &laquo;<i>V</i>&raquo;).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>setterResult</i>).</li>
        <li>Return <b>true</b>.</li>
      </ol>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-delete-p">
      <h3 id="sec-9.1.10" title="9.1.10"> [[Delete]] (P)</h3><p class="normalbefore">When the [[Delete]] internal method of <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> the following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>desc</i> be <i>O</i>.[[GetOwnProperty]](<i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
        <li>If <i>desc</i> is <b>undefined</b>, return <b>true</b>.</li>
        <li>If <i>desc</i>.[[Configurable]] is <b>true</b>, then
          <ol class="block">
            <li>Remove the own property with name <i>P</i> from <i>O</i>.</li>
            <li>Return <b>true</b>.</li>
          </ol>
        </li>
        <li>Return <b>false</b>.</li>
      </ol>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-enumerate">
      <h3 id="sec-9.1.11" title="9.1.11"> [[Enumerate]] ()</h3><p class="normalbefore">When the [[Enumerate]] internal method of <var>O</var> is called the following steps are taken:</p>

      <ol class="proc">
        <li>Return an Iterator object (<a href="sec-control-abstraction-objects#sec-iterator-interface">25.1.1.2</a>) whose <code>next</code> method iterates
            over all the String-valued keys of enumerable properties of <i>O</i>. The Iterator object must inherit from
            %IteratorPrototype% (<a href="sec-control-abstraction-objects#sec-%iteratorprototype%-object">25.1.2</a>). The mechanics and order of enumerating the
            properties is not specified but must conform to the rules specified below.</li>
      </ol>

      <p>The iterator&rsquo;s <code>next</code> method processes object properties to determine whether the <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> should be returned as an iterator value. Returned property keys do not include keys
      that are Symbols. Properties of the target object may be deleted during enumeration. A property that is deleted before it is
      processed by the iterator&rsquo;s <code>next</code> method is ignored. If new properties are added to the target object
      during enumeration, the newly added properties are not guaranteed to be processed in the active enumeration. A property name
      will be returned by the iterator&rsquo;s <code>next</code> method at most once in any enumeration.</p>

      <p>Enumerating the properties of the target object includes enumerating properties of its prototype, and the prototype of
      the prototype, and so on, recursively; but a property of a prototype is not processed if it has the same name as a property
      that has already been processed by the iterator&rsquo;s <code>next</code> method. The values of [[Enumerable]] attributes
      are not considered when determining if a property of a prototype object has already been processed. The enumerable property
      names of prototype objects must be obtained as if by invoking the prototype object&rsquo;s [[Enumerate]] internal method.
      [[Enumerate]] must obtain the own property keys of the target object as if by calling its [[OwnPropertyKeys]] internal
      method. Property attributes of the target object must be obtained as if by calling its [[GetOwnProperty]] internal
      method.</p>

      <div class="note">
        <p><span class="nh">NOTE</span> The following is an informative definition of an ECMAScript generator function that
        conforms to these rules:</p>

        <pre class="NoteCode">function* enumerate(obj) {</pre>
        <pre class="NoteCode">&nbsp;&nbsp;let visited=new Set;</pre>
        <pre class="NoteCode">&nbsp;&nbsp;for (let key of <a href="sec-reflection#sec-reflect.ownkeys">Reflect.ownKeys</a>(obj)) {</pre>
        <pre class="NoteCode">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (typeof key === "string") {</pre>
        <pre class="NoteCode">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;let desc = <a href="sec-reflection#sec-reflect.getownpropertydescriptor">Reflect.getOwnPropertyDescriptor</a>(obj,key);</pre>
        <pre class="NoteCode">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (desc) {</pre>
        <pre class="NoteCode">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;visited.add(key);</pre>
        <pre class="NoteCode">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (desc.enumerable) yield key;</pre>
        <pre class="NoteCode">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}</pre>
        <pre class="NoteCode">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}</pre>
        <pre class="NoteCode">&nbsp;&nbsp;}</pre>
        <pre class="NoteCode">&nbsp;&nbsp;let proto = <a href="sec-reflection#sec-reflect.getprototypeof">Reflect.getPrototypeOf</a>(obj)</pre>
        <pre class="NoteCode">&nbsp;&nbsp;if (proto === null) return;</pre>
        <pre class="NoteCode">&nbsp;&nbsp;for (let protoName of <a href="sec-reflection#sec-reflect.enumerate">Reflect.enumerate</a>(proto)) {</pre>
        <pre class="NoteCode">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (!visited.has(protoName)) yield protoName;</pre>
        <pre class="NoteCode">&nbsp;&nbsp;}</pre>
        <pre class="NoteCode">}</pre>
      </div>
    </section>

    <section id="sec-ordinary-object-internal-methods-and-internal-slots-ownpropertykeys">
      <h3 id="sec-9.1.12" title="9.1.12"> [[OwnPropertyKeys]] ( )</h3><p class="normalbefore">When the [[OwnPropertyKeys]] internal method of <var>O</var> is called the following steps are
      taken:</p>

      <ol class="proc">
        <li>Let <i>keys</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>For each own <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <i>P</i> of <i>O</i> that is an integer index, in ascending
            numeric index order
          <ol class="block">
            <li>Add <i>P</i> as the last element of <i>keys</i>.</li>
          </ol>
        </li>
        <li>For each own <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <i>P</i> of <i>O</i> that is a String but is not an integer
            index, in property creation order
          <ol class="block">
            <li>Add <i>P</i> as the last element of <i>keys</i>.</li>
          </ol>
        </li>
        <li>For each own <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <i>P</i> of <i>O</i> that is a Symbol, in property creation
            order
          <ol class="block">
            <li>Add <i>P</i> as the last element of <i>keys</i>.</li>
          </ol>
        </li>
        <li>Return <i>keys</i>.</li>
      </ol>
    </section>

    <section id="sec-objectcreate">
      <h3 id="sec-9.1.13" title="9.1.13">
          ObjectCreate(proto, internalSlotsList)</h3><p class="normalbefore">The abstract operation ObjectCreate with argument <var>proto</var> (an object or null) is used to
      specify the runtime creation of new ordinary objects. The optional argument <var>internalSlotsList</var> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of the names of additional internal slots that must be defined as
      part of the object. If the list is not provided, an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> is
      used. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li>If <i>internalSlotsList</i> was not provided, let <i>internalSlotsList</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Let <i>obj</i> be a newly created object with an <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
            slot</a> for each name in <i>internalSlotsList</i>.</li>
        <li>Set <i>obj</i>&rsquo;s essential internal methods to the default ordinary object definitions specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>.</li>
        <li>Set the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i> to
            <i>proto</i>.</li>
        <li>Set the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i> to
            <b>true</b>.</li>
        <li>Return <i>obj</i>.</li>
      </ol>
    </section>

    <section id="sec-ordinarycreatefromconstructor">
      <h3 id="sec-9.1.14" title="9.1.14"> OrdinaryCreateFromConstructor ( constructor,  intrinsicDefaultProto,
          internalSlotsList )</h3><p class="normalbefore">The abstract operation OrdinaryCreateFromConstructor creates an ordinary object whose [[Prototype]]
      value is retrieved from a constructor&rsquo;s <code>prototype</code> property, if it exists. Otherwise the intrinsic named
      by <var>intrinsicDefaultProto</var> is used for [[Prototype]]. The optional <var>internalSlotsList</var> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of the names of additional internal slots that must be defined as
      part of the object. If the list is not provided, an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> is
      used. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>intrinsicDefaultProto</i> is a String value that is this
            specification&rsquo;s name of an intrinsic object. The corresponding object must be an intrinsic that is intended to
            be used as the [[Prototype]] value of an object.</li>
        <li>Let <i>proto</i> be <a href="#sec-getprototypefromconstructor">GetPrototypeFromConstructor</a>(<i>constructor</i>,
            <i>intrinsicDefaultProto</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>proto</i>).</li>
        <li>Return <a href="#sec-objectcreate">ObjectCreate</a>(<i>proto</i>, <i>internalSlotsList</i>).</li>
      </ol>
    </section>

    <section id="sec-getprototypefromconstructor">
      <h3 id="sec-9.1.15" title="9.1.15"> GetPrototypeFromConstructor ( constructor, intrinsicDefaultProto )</h3><p class="normalbefore">The abstract operation GetPrototypeFromConstructor determines the [[Prototype]] value that should be
      used to create an object corresponding to a specific constructor. The value is retrieved from the constructor&rsquo;s
      <code>prototype</code> property, if it exists. Otherwise the intrinsic named by <var>intrinsicDefaultProto</var> is used for
      [[Prototype]]. This abstract operation performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>intrinsicDefaultProto</i> is a String value that is this
            specification&rsquo;s name of an intrinsic object. The corresponding object must be an intrinsic that is intended to
            be used as the [[Prototype]] value of an object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a> (<i>constructor</i>)
            is <b>true</b>.</li>
        <li>Let <i>proto</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>constructor</i>, <code>"prototype"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>proto</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>proto</i>) is not Object, then
          <ol class="block">
            <li>Let <i>realm</i> be <a href="sec-abstract-operations#sec-getfunctionrealm">GetFunctionRealm</a>(<i>constructor</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>realm</i>).</li>
            <li>Let <i>proto</i> be <i>realm&rsquo;s</i> intrinsic object named <i>intrinsicDefaultProto</i>.</li>
          </ol>
        </li>
        <li>Return <i>proto</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> If <i>constructor</i> does not supply a [[Prototype]] value, the default value that is
        used is obtained from the <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Code Realm</a> of the <i>constructor</i> function rather than from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</p>
      </div>
    </section>
  </section>

  <section id="sec-ecmascript-function-objects">
    <div class="front">
      <h2 id="sec-9.2" title="9.2">
          ECMAScript Function Objects</h2><p>ECMAScript function objects encapsulate parameterized ECMAScript code closed over a <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">lexical environment</a> and support the dynamic evaluation of that code. An ECMAScript
      function object is an ordinary object and has the same internal slots and the same internal methods as other ordinary
      objects. The code of an ECMAScript function object may be either <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> (<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">10.2.1</a>) or non-<a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a>. An ECMAScript function
      object whose code is <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> is called a <i>strict function</i>. One whose code
      is not <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> is called a <i>non-strict function</i>.</p>

      <p>ECMAScript function objects have the additional internal slots listed in <a href="#table-27">Table 27</a>.</p>

      <figure>
        <figcaption><span id="table-27">Table 27</span> &mdash; Internal Slots of ECMAScript Function Objects</figcaption>
        <table class="real-table">
          <tr>
            <th>Internal Slot</th>
            <th>Type</th>
            <th>Description</th>
          </tr>
          <tr>
            <td>[[Environment]]</td>
            <td><a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a></td>
            <td>The <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a> that the function was closed over. Used as the outer environment when evaluating the code of the function.</td>
          </tr>
          <tr>
            <td>[[FormalParameters]]</td>
            <td>Parse Node</td>
            <td>The root parse node of the source text that defines the function&rsquo;s formal parameter list.</td>
          </tr>
          <tr>
            <td>[[FunctionKind]]</td>
            <td>String</td>
            <td>Either <code>"normal"</code>, <code>"classConstructor"</code> or <code>"generator"</code>.</td>
          </tr>
          <tr>
            <td>[[ECMAScriptCode]]</td>
            <td>Parse Node</td>
            <td>The root parse node of the source text that defines the function&rsquo;s body.</td>
          </tr>
          <tr>
            <td>[[ConstructorKind]]</td>
            <td>String</td>
            <td>Either <code>"base"</code> or <code>"derived"</code>.</td>
          </tr>
          <tr>
            <td>[[Realm]]</td>
            <td><a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> Record</td>
            <td>The <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Code Realm</a> in which the function was created and which provides any intrinsic objects that are accessed when evaluating the function.</td>
          </tr>
          <tr>
            <td>[[ThisMode]]</td>
            <td>(lexical, strict, global)</td>
            <td>Defines how <code>this</code> references are interpreted within the formal parameters and code body of the function. <b>lexical</b> means that <code>this</code> refers to the <b>this</b> value of a lexically enclosing function. <b>strict</b> means that the <b>this</b> value is used exactly as provided by an invocation of the function. <b>global</b> means that a <b>this</b> value of <span class="value">undefined</span> is interpreted as a reference to the global object.</td>
          </tr>
          <tr>
            <td>[[Strict]]</td>
            <td>Boolean</td>
            <td><span class="value">true</span> if this is a strict mode function, <span class="value">false</span> if this is not a strict mode function.</td>
          </tr>
          <tr>
            <td>[[HomeObject]]</td>
            <td>Object</td>
            <td>If the function uses <code>super</code>, this is the object whose [[GetPrototypeOf]] provides the object where <code>super</code> property lookups begin.</td>
          </tr>
        </table>
      </figure>

      <p>All ECMAScript function objects have the [[Call]] internal method defined here. ECMAScript functions that are also
      constructors in addition have the [[Construct]] internal method. ECMAScript function objects whose code is not <a href="sec-ecmascript-language-source-code#sec-strict-mode-code">strict mode code</a> have the [[GetOwnProperty]] internal method defined here.</p>
    </div>

    <section id="sec-ecmascript-function-objects-call-thisargument-argumentslist">
      <div class="front">
        <h3 id="sec-9.2.1" title="9.2.1"> [[Call]] ( thisArgument, argumentsList)</h3><p class="normalbefore">The [[Call]] internal method for an <a href="#sec-ecmascript-function-objects">ECMAScript function
        object</a> <var>F</var> is called with parameters <var>thisArgument</var> and <var>argumentsList</var>, a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language
        values</a>. The following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> is an <a href="#sec-ecmascript-function-objects">ECMAScript function object</a>.</li>
          <li>If <i>F</i>&rsquo;s [[FunctionKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is
              <code>"classConstructor"</code>, throw a <b>TypeError</b> exception.</li>
          <li>Let <i>callerContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li>Let <i>calleeContext</i> be <a href="#sec-prepareforordinarycall">PrepareForOrdinaryCall</a>(<i>F</i>,
              <b>undefined</b>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>calleeContext</i> is now <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the
              running execution context</a>.</li>
          <li>Perform <a href="#sec-ordinarycallbindthis">OrdinaryCallBindThis</a>(<i>F</i>, <i>calleeContext</i>,
              <i>thisArgument</i>).</li>
          <li>Let <i>result</i> be <a href="#sec-ordinarycallevaluatebody">OrdinaryCallEvaluateBody</a>(<i>F</i>,
              <i>argumentsList</i>).</li>
          <li>Remove <i>calleeContext</i> from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> and restore
              <i>callerContext</i> as <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li>If <i>result</i>.[[type]] is <span style="font-family: sans-serif">return</span>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>result</i>.[[value]]).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
          <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> When <var>calleeContext</var> is removed from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the
          execution context stack</a> in step 8 it must not be destroyed if it is <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">suspended</a>
          and retained for later resumption by an accessible generator object<i>.</i></p>
        </div>
      </div>

      <section id="sec-prepareforordinarycall">
        <h4 id="sec-9.2.1.1" title="9.2.1.1"> PrepareForOrdinaryCall( F, newTarget )</h4><p class="normalbefore">When the abstract operation PrepareForOrdinaryCall is called with function object <span style="font-family: Times New Roman"><i>F</i> and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a>
        <i>newTarget</i></span>, the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>newTarget</i>) is Undefined or Object.</li>
          <li>Let <i>callerContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li>Let <i>calleeContext</i> be a new <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">ECMAScript code execution context</a>.</li>
          <li>Set the Function of <i>calleeContext</i> to <i>F</i>.</li>
          <li>Let <i>calleeRealm</i> be the value of <i>F&rsquo;s</i> [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> of <i>calleeContext</i> to <i>calleeRealm</i>.</li>
          <li>Let <i>localEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newfunctionenvironment">NewFunctionEnvironment</a>(<i>F</i>,
              <i>newTarget</i>).</li>
          <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <i>calleeContext</i> to <i>localEnv</i>.</li>
          <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> of <i>calleeContext</i> to <i>localEnv</i>.</li>
          <li>If <i>callerContext</i> is not already <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">suspended</a>, <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <i>callerContext</i>.</li>
          <li>Push <i>calleeContext</i> onto <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>;
              <i>calleeContext</i> is now <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
          <li><span style="font-family: sans-serif">NOTE Any exception objects produced after this point are associated
              with</span> <i>calleeRealm</i>.</li>
          <li>Return <i>calleeContext</i>.</li>
        </ol>
      </section>

      <section id="sec-ordinarycallbindthis">
        <h4 id="sec-9.2.1.2" title="9.2.1.2"> OrdinaryCallBindThis ( F, calleeContext, thisArgument )</h4><p class="normalbefore">When the abstract operation OrdinaryCallBindThis is called with function object <var>F</var>, <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> <var>calleeContext</var>, and ECMAScript value
        <var>thisArgument</var> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>thisMode</i> be the value of <i>F</i>&rsquo;s [[ThisMode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>thisMode</i> is <span style="font-family: sans-serif">lexical</span>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
          <li>Let <i>calleeRealm</i> be the value of <i>F&rsquo;s</i> [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>localEnv</i> be the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <i>calleeContext</i>.</li>
          <li>If <i>thisMode</i> is <span style="font-family: sans-serif">strict</span>, let <i>thisValue</i> be
              <i>thisArgument</i>.</li>
          <li>Else
            <ol class="block">
              <li>if <i>thisArgument</i> is <b>null</b> or <b>undefined</b>, then
                <ol class="block">
                  <li>Let <i>thisValue</i> be <i>calleeRealm</i>.[[globalThis]].</li>
                </ol>
              </li>
              <li>Else
                <ol class="block">
                  <li>Let <i>thisValue</i> be <a href="sec-abstract-operations#sec-toobject">ToObject</a>(<i>thisArgument</i>).</li>
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>thisValue</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                  <li><span style="font-family: sans-serif">NOTE <a href="sec-abstract-operations#sec-toobject">ToObject</a> produces wrapper objects
                      using</span> <i>calleeRealm</i>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Let <i>envRec</i> be <i>localEnv</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The next step never returns an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> because <i>envRec</i>.[[thisBindingStatus]]
              is not <code>"uninitialized"</code>.</li>
          <li>Return <i>envRec</i>.<a href="sec-executable-code-and-execution-contexts#sec-bindthisvalue">BindThisValue</a>(<i>thisValue</i>).</li>
        </ol>
      </section>

      <section id="sec-ordinarycallevaluatebody">
        <h4 id="sec-9.2.1.3" title="9.2.1.3"> OrdinaryCallEvaluateBody ( F, argumentsList )</h4><p class="normalbefore">When the abstract operation OrdinaryCallEvaluateBody is called with function object <var>F</var>
        and <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> <var>argumentsList</var> the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>status</i> be <a href="#sec-functiondeclarationinstantiation">FunctionDeclarationInstantiation</a>(<i>F</i>,
              <i>argumentsList</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>status</i>)</li>
          <li>Return the result of EvaluateBody of the parsed code that is the value of <i>F</i>'s [[ECMAScriptCode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> passing <i>F</i> as the argument.</li>
        </ol>
      </section>
    </section>

    <section id="sec-ecmascript-function-objects-construct-argumentslist-newtarget">
      <h3 id="sec-9.2.2" title="9.2.2"> [[Construct]] ( argumentsList, newTarget)</h3><p class="normalbefore">The [[Construct]] internal method for an <a href="#sec-ecmascript-function-objects">ECMAScript
      Function object</a> <var>F</var> is called with parameters <var>argumentsList</var> and <span style="font-family: Times New       Roman"><i>newTarget</i>. <i>argumentsList</i></span> is a possibly empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language
      values</a>. The following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> is an <a href="#sec-ecmascript-function-objects">ECMAScript
            function object</a>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>newTarget</i>) is Object.</li>
        <li>Let <i>callerContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>kind</i> be <i>F</i>&rsquo;s [[ConstructorKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
        <li>If <i>kind</i> is <code>"base"</code>, then
          <ol class="block">
            <li>Let <i>thisArgument</i> be <a href="#sec-ordinarycreatefromconstructor">OrdinaryCreateFromConstructor</a>(<i>newTarget</i>,
                <code>"%ObjectPrototype%"</code>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>thisArgument</i>).</li>
          </ol>
        </li>
        <li>Let <i>calleeContext</i> be <a href="#sec-prepareforordinarycall">PrepareForOrdinaryCall</a>(<i>F</i>,
            <i>newTarget</i>).</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>calleeContext</i> is now <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the
            running execution context</a>.</li>
        <li>If <i>kind</i> is <code>"base"</code>, perform <a href="#sec-ordinarycallbindthis">OrdinaryCallBindThis</a>(<i>F</i>,
            <i>calleeContext</i>, <i>thisArgument</i>).</li>
        <li>Let <i>constructorEnv</i> be the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of
            <i>calleeContext</i>.</li>
        <li>Let <i>envRec</i> be <i>constructorEnv</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
        <li>Let <i>result</i> be <a href="#sec-ordinarycallevaluatebody">OrdinaryCallEvaluateBody</a>(<i>F</i>,
            <i>argumentsList</i>).</li>
        <li>Remove <i>calleeContext</i> from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> and restore
            <i>callerContext</i> as <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>If <i>result</i>.[[type]] is <span style="font-family: sans-serif">return</span>, then
          <ol class="block">
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>result</i>.[[value]]) is Object, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>result</i>.[[value]]).</li>
            <li>If <i>kind</i> is <code>"base"</code>, return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<i>thisArgument</i>).</li>
            <li>If <i>result</i>.[[value]] is not <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
          </ol>
        </li>
        <li>Else, <a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
        <li>Return <i>envRec</i>.GetThisBinding().</li>
      </ol>
    </section>

    <section id="sec-functionallocate">
      <h3 id="sec-9.2.3" title="9.2.3">
          FunctionAllocate (functionPrototype, strict [,functionKind] )</h3><p class="normalbefore">The abstract operation FunctionAllocate requires the two arguments <span style="font-family: Times       New Roman"><i>functionPrototype</i> and <i>strict</i>.</span> It also accepts one optional argument,
      <var>functionKind</var>. FunctionAllocate performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>functionPrototype</i>) is Object.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: If <i>functionKind</i> is present, its value is either
            <code>"normal"</code>, <code>"non-constructor"</code> or <code>"generator"</code>.</li>
        <li>If <i>functionKind</i> is not present, let <i>functionKind</i> be <code>"normal"</code>.</li>
        <li>If <i>functionKind</i> is <code>"non-constructor"</code>, then
          <ol class="block">
            <li>Let <i>functionKind</i> be <code>"normal"</code>.</li>
            <li>Let <i>needsConstruct</i> be <b>false</b>.</li>
          </ol>
        </li>
        <li>Else let <i>needsConstruct</i> be <b>true</b>.</li>
        <li>Let <i>F</i> be a newly created <a href="#sec-ecmascript-function-objects">ECMAScript function object</a> with the
            internal slots listed in <a href="#table-27">Table 27</a>. All of those internal slots are initialized to
            <b>undefined</b>.</li>
        <li>Set <i>F</i>&rsquo;s essential internal methods to the default ordinary object definitions specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>.</li>
        <li>Set <i>F</i>&rsquo;s [[Call]] internal method to the definition specified in <a href="#sec-ecmascript-function-objects-call-thisargument-argumentslist">9.2.1</a>.</li>
        <li>If <i>needsConstruct</i> is <b>true</b>, then
          <ol class="block">
            <li>Set <i>F</i>&rsquo;s [[Construct]] internal method to the definition specified in <a href="#sec-ecmascript-function-objects-construct-argumentslist-newtarget">9.2.2</a>.</li>
            <li>If <i>functionKind</i> is <code>"generator"</code>, set the [[ConstructorKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to
                <code>"derived"</code>.</li>
            <li>Else, set the [[ConstructorKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
                <i>F</i> to <code>"base"</code>.</li>
            <li>NOTE  Generator functions are tagged as <code>"derived"</code> constructors to prevent [[Construct]] from
                preallocating a generator instance. Generator instance objects are allocated when EvaluateBody is applied to the
                <span class="nt">GeneratorBody</span> of a generator function.</li>
          </ol>
        </li>
        <li>Set the [[Strict]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to
            <i>strict</i>.</li>
        <li>Set the [[FunctionKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to
            <i>functionKind</i>.</li>
        <li>Set the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to
            <i>functionPrototype</i>.</li>
        <li>Set the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to
            <b>true</b>.</li>
        <li>Set the [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>.</li>
        <li>Return <i>F</i>.</li>
      </ol>
    </section>

    <section id="sec-functioninitialize">
      <h3 id="sec-9.2.4" title="9.2.4">
          FunctionInitialize (F, kind, ParameterList, Body, Scope)</h3><p class="normalbefore">The abstract operation FunctionInitialize requires the arguments: a function object <var>F</var>,
      <var>kind</var> which is one of (Normal, Method, Arrow), a parameter list production specified by <span class="nt">ParameterList</span>, a body production specified by <span class="nt">Body</span>, a <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a> specified by <span style="font-family: Times New       Roman"><i>Scope</i>.</span> FunctionInitialize performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> is an extensible object that does not have a
            <code>length</code> own property.</li>
        <li>Let <i>len</i> be the ExpectedArgumentCount of <i>ParameterList</i>.</li>
        <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>F</i>, <code>"length"</code>,
            PropertyDescriptor{[[Value]]: <i>len</i>, [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
            <b>true</b>}).</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
        <li>Let <i>Strict</i> be the value of the [[Strict]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
            slot</a> of <i>F</i>.</li>
        <li>Set the [[Environment]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to the
            value of <i>Scope</i>.</li>
        <li>Set the [[FormalParameters]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i>
            to <i>ParameterList</i> .</li>
        <li>Set the [[ECMAScriptCode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to
            <i>Body</i>.</li>
        <li>If <i>kind</i> is <span style="font-family: sans-serif">Arrow</span>, set the [[ThisMode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to <span style="font-family:             sans-serif">lexical</span>.</li>
        <li>Else if <i>Strict</i> is <b>true</b>, set the [[ThisMode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to <span style="font-family:             sans-serif">strict</span>.</li>
        <li>Else set the [[ThisMode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to
            <span style="font-family: sans-serif">global</span>.</li>
        <li>Return <i>F</i>.</li>
      </ol>
    </section>

    <section id="sec-functioncreate">
      <h3 id="sec-9.2.5" title="9.2.5">
          FunctionCreate (kind, ParameterList, Body, Scope, Strict, prototype)</h3><p class="normalbefore">The abstract operation FunctionCreate requires the arguments: <var>kind</var> which is one of
      (Normal, Method, Arrow), a parameter list production specified by <span class="nt">ParameterList</span>, a body production
      specified by <span class="nt">Body</span>, a <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a> specified by <span class="nt">Scope</span>, a Boolean flag <span class="nt">Strict</span>, and optionally, an object <span style="font-family:       Times New Roman"><i>prototype</i>.</span> FunctionCreate performs the following steps:</p>

      <ol class="proc">
        <li>If the <i>prototype</i> argument was not passed, then
          <ol class="block">
            <li>Let <i>prototype</i> be the intrinsic object %FunctionPrototype%.</li>
          </ol>
        </li>
        <li>If <i>kind</i> is not <span style="font-family: sans-serif">Normal</span>, let <i>allocKind</i> be
            <code>"non-constructor"</code>.</li>
        <li>Else let <i>allocKind</i> be <code>"normal"</code>.</li>
        <li>Let <i>F</i> be <a href="#sec-functionallocate">FunctionAllocate</a>(<i>prototype</i>, <i>Strict</i>,
            <i>allocKind</i>).</li>
        <li>Return <a href="#sec-functioninitialize">FunctionInitialize</a>(<i>F</i>, <i>kind</i>, <i>ParameterList</i>,
            <i>Body</i>, <i>Scope</i>).</li>
      </ol>
    </section>

    <section id="sec-generatorfunctioncreate">
      <h3 id="sec-9.2.6" title="9.2.6">
          GeneratorFunctionCreate (kind, ParameterList, Body, Scope, Strict)</h3><p class="normalbefore">The abstract operation GeneratorFunctionCreate requires the arguments: <var>kind</var> which is one
      of (Normal, Method), a parameter list production specified by <span class="nt">ParameterList</span>, a body production
      specified by <span class="nt">Body</span>, a <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">Lexical Environment</a> specified by <span class="nt">Scope</span>, and a Boolean flag <span class="nt">Strict</span>. GeneratorFunctionCreate performs the following
      steps:</p>

      <ol class="proc">
        <li>Let <i>functionPrototype</i> be the intrinsic object %Generator%.</li>
        <li>Let <i>F</i> be <a href="#sec-functionallocate">FunctionAllocate</a>(<i>functionPrototype</i>, <i>Strict</i>,
            <code>"generator"</code>).</li>
        <li>Return <a href="#sec-functioninitialize">FunctionInitialize</a>(<i>F</i>, <i>kind</i>, <i>ParameterList</i>,
            <i>Body</i>, <i>Scope</i>).</li>
      </ol>
    </section>

    <section id="sec-addrestrictedfunctionproperties">
      <div class="front">
        <h3 id="sec-9.2.7" title="9.2.7"> AddRestrictedFunctionProperties ( F, realm )</h3><p class="normalbefore">The abstract operation AddRestrictedFunctionProperties is called with a function object
        <var>F</var> and <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> Record <var>realm</var> as its argument. It performs the following
        steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>realm</i>.[[intrinsics]].[[<span style="font-family:               sans-serif">%ThrowTypeError%]] exists and has been initialized.</span></li>
          <li>Let <i>thrower</i> be <i>realm</i>.[[intrinsics]].[[<span style="font-family:               sans-serif">%ThrowTypeError%]].</span></li>
          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>F</i>, <code>"caller"</code>,
              PropertyDescriptor {[[Get]]: <i>thrower</i>, [[Set]]: <i>thrower</i>, [[Enumerable]]: <b>false</b>,
              [[Configurable]]: <b>true</b>}).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>Return <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>F</i> , <code>"arguments"</code>,
              PropertyDescriptor {[[Get]]: <i>thrower</i>, [[Set]]: <i>thrower</i>, [[Enumerable]]: <b>false</b>,
              [[Configurable]]: <b>true</b>}).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: The above returned value is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
        </ol>
      </div>

      <section id="sec-%throwtypeerror%">
        <h4 id="sec-9.2.7.1" title="9.2.7.1">
            %ThrowTypeError% ( )</h4><p>The %ThrowTypeError% intrinsic is an anonymous built-in function object that is defined once for each <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>. When %ThrowTypeError% is called it performs the following steps:</p>

        <ol class="proc">
          <li>Throw a <b>TypeError</b> exception.</li>
        </ol>

        <p>The value of the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of a
        %ThrowTypeError% function is <span class="value">false</span>.</p>

        <p>The <code>length</code> property of a %ThrowTypeError% function has the attributes {&nbsp;[[Writable]]: <b>false</b>,
        [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>false</b> }.</p>
      </section>
    </section>

    <section id="sec-makeconstructor">
      <h3 id="sec-9.2.8" title="9.2.8">
          MakeConstructor (F, writablePrototype, prototype)</h3><p class="normalbefore">The abstract operation MakeConstructor requires a Function argument <var>F</var> and optionally, a
      Boolean <var>writablePrototype</var> and an object <var>prototype</var>. If <var>prototype</var> is provided it is assumed
      to already contain, if needed, a <code>"constructor"</code> property whose value is <var>F</var>. This operation converts
      <var>F</var> into a constructor by performing the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> is an <a href="#sec-ecmascript-function-objects">ECMAScript
            function object</a>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> has a [[Construct]] internal method.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> is an extensible object that does not have a
            <code>prototype</code> own property.</li>
        <li>If the <i>writablePrototype</i> argument was not provided, let <i>writablePrototype</i> be <b>true</b>.</li>
        <li>If the <i>prototype</i> argument was not provided, then
          <ol class="block">
            <li>Let <i>prototype</i> be <a href="#sec-objectcreate">ObjectCreate</a>(<span style="font-family:                 sans-serif">%ObjectPrototype%</span>).</li>
            <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>prototype</i>,
                <code>"constructor"</code>, PropertyDescriptor{[[Value]]: <i>F</i>, [[Writable]]: <i>writablePrototype</i>,
                [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>true</b> }).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          </ol>
        </li>
        <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>F</i>,
            <code>"prototype"</code>, PropertyDescriptor{[[Value]]: <i>prototype</i>, [[Writable]]: <i>writablePrototype</i>,
            [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>false</b>}).</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
      </ol>
    </section>

    <section id="sec-makeclassconstructor">
      <h3 id="sec-9.2.9" title="9.2.9">
          MakeClassConstructor ( F)</h3><p>The abstract operation MakeClassConstructor with argument <var>F</var> performs the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> is an <a href="#sec-ecmascript-function-objects">ECMAScript
            function object</a>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i>&rsquo;s [[FunctionKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is <code>"normal"</code>.</li>
        <li>Set <i>F</i>&rsquo;s [[FunctionKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
            <code>"classConstructor"</code>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
      </ol>
    </section>

    <section id="sec-makemethod">
      <h3 id="sec-9.2.10" title="9.2.10"> MakeMethod
          ( F, homeObject)</h3><p class="normalbefore">The abstract operation MakeMethod with arguments <var>F</var> and <var>homeObject</var> configures
      <var>F</var> as a method by performing the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> is an <a href="#sec-ecmascript-function-objects">ECMAScript
            function object</a>.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>homeObject</i> ) is Object.</li>
        <li>Set the [[HomeObject]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>F</i> to
            <i>homeObject</i>.</li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<b>undefined</b>).</li>
      </ol>
    </section>

    <section id="sec-setfunctionname">
      <h3 id="sec-9.2.11" title="9.2.11">
          SetFunctionName (F, name, prefix)</h3><p class="normalbefore">The abstract operation SetFunctionName requires a Function argument <var>F</var>, a String or Symbol
      argument <var>name</var> and optionally a String argument <var>prefix</var>. This operation adds a <code>name</code>
      property to <var>F</var> by performing the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>F</i> is an extensible object that does not have a
            <code>name</code> own property.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>name</i>)
            is either Symbol or String.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: If <i>prefix</i> was passed then <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>prefix</i>) is String.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>name</i>) is Symbol, then
          <ol class="block">
            <li>Let <i>description</i> be <i>name</i>&rsquo;s [[Description]] value.</li>
            <li>If <i>description</i> is <b>undefined</b>, let <i>name</i> be the empty String.</li>
            <li>Else, let <i>name</i> be the concatenation of <code>"["</code>, <i>description</i>, and <code>"]"</code>.</li>
          </ol>
        </li>
        <li>If <i>prefix</i> was passed, then
          <ol class="block">
            <li>Let <i>name</i> be the concatenation of <i>prefix</i>, code unit 0x0020 (SPACE), and <i>name</i>.</li>
          </ol>
        </li>
        <li>Return <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>F</i>, <code>"name"</code>,
            PropertyDescriptor{[[Value]]: <i>name</i>, [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
            <b>true</b>}).</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: the result is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
      </ol>
    </section>

    <section id="sec-functiondeclarationinstantiation">
      <h3 id="sec-9.2.12" title="9.2.12"> FunctionDeclarationInstantiation(func, argumentsList)</h3><div class="note">
        <p><span class="nh">NOTE 1</span> When an <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a> is established for
        evaluating an ECMAScript function a new function <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>  is created and
        bindings for each formal parameter are instantiated in that <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>.
        Each declaration in the function body is also instantiated. If the function&rsquo;s formal parameters do not include any
        default value initializers then the body declarations are instantiated in the same <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> as the parameters. If default value parameter initializers exist, a
        second <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> is created for the body declarations. Formal parameters
        and functions are initialized as part of FunctionDeclarationInstantiation. All other bindings are initialized during
        evaluation of the function body.</p>
      </div>

      <p class="normalbefore">FunctionDeclarationInstantiation is performed as follows using arguments <var>func</var> and
      <var>argumentsList</var>. <var>func</var> is the function object for which the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution
      context</a> is being established.</p>

      <ol class="proc">
        <li>Let <i>calleeContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>env</i> be the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <i>calleeContext</i>.</li>
        <li>Let <i>envRec</i> be <i>env</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
        <li>Let <i>code</i> be the value of the [[ECMAScriptCode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>func</i>.</li>
        <li>Let <i>strict</i> be the value of the [[Strict]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
            slot</a> of <i>func</i>.</li>
        <li>Let <i>formals</i> be the value of the [[FormalParameters]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>func</i>.</li>
        <li>Let <i>parameterNames</i> be the BoundNames of <i>formals</i>.</li>
        <li>If <i>parameterNames</i> has any duplicate entries, let <i>hasDuplicates</i> be <b>true</b>. Otherwise, let
            <i>hasDuplicates</i> be <b>false</b>.</li>
        <li>Let <i>simpleParameterList</i> be IsSimpleParameterList of <i>formals</i>.</li>
        <li>Let <i>hasParameterExpressions</i> be ContainsExpression of <i>formals.</i></li>
        <li>Let <i>varNames</i> be the VarDeclaredNames of <i>code</i>.</li>
        <li>Let <i>varDeclarations</i> be the VarScopedDeclarations of <i>code</i>.</li>
        <li>Let <i>lexicalNames</i> be the LexicallyDeclaredNames of <i>code</i>.</li>
        <li>Let <i>functionNames</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Let <i>functionsToInitialize</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>For each <i>d</i> in <i>varDeclarations</i>, in reverse list order do
          <ol class="block">
            <li>If <i>d</i> is neither a <i>VariableDeclaration</i> or a <i>ForBinding</i>, then
              <ol class="block">
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>d</i> is either a <i>FunctionDeclaration</i> or a
                    <i>GeneratorDeclaration</i>.</li>
                <li>Let <i>fn</i> be the sole element of the BoundNames of <i>d.</i></li>
                <li>If <i>fn</i> is not an element of <i>functionNames</i>, then
                  <ol class="block">
                    <li>Insert <i>fn</i> as the first element of <i>functionNames</i>.</li>
                    <li>NOTE If there are multiple <span style="font-family: Times New Roman"><i>FunctionDeclarations</i> or
                        <i>GeneratorDeclarations</i></span> for the same name, the last declaration is used.</li>
                    <li>Insert <i>d</i> as the first element of <i>functionsToInitialize</i>.</li>
                  </ol>
                </li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Let <i>argumentsObjectNeeded</i> be <b>true</b>.</li>
        <li>If the value of the [[ThisMode]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of
            <i>func</i> is <span style="font-family: sans-serif">lexical</span>, then
          <ol class="block">
            <li>NOTE  Arrow functions never have an arguments objects.</li>
            <li>Let <i>argumentsObjectNeeded</i> be <b>false</b>.</li>
          </ol>
        </li>
        <li>Else if <code>"arguments"</code> is an element of <i>parameterNames</i>, then
          <ol class="block">
            <li>Let <i>argumentsObjectNeeded</i> be <b>false</b>.</li>
          </ol>
        </li>
        <li>Else if <i>hasParameterExpressions</i> is <b>false</b>, then
          <ol class="block">
            <li>If <code>"arguments"</code> is an element of <i>functionNames</i> or if <code>"arguments"</code> is an element of
                <i>lexicalNames</i>, then
              <ol class="block">
                <li>Let <i>argumentsObjectNeeded</i> be <b>false</b>.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>For each String <i>paramName</i> in <i>parameterNames</i>, do
          <ol class="block">
            <li>Let <i>alreadyDeclared</i> be <i>envRec</i>.HasBinding(<i>paramName</i>).</li>
            <li>NOTE  Early errors ensure that duplicate parameter names can only occur in non-strict functions that do not have
                parameter default values or rest parameters.</li>
            <li>If <i>alreadyDeclared</i> is <b>false</b>, then
              <ol class="block">
                <li>Let <i>status</i> be <i>envRec</i>.CreateMutableBinding(<i>paramName</i>).</li>
                <li>If <i>hasDuplicates</i> is <b>true</b>, then
                  <ol class="block">
                    <li>Let <i>status</i> be <i>envRec</i>.InitializeBinding(<i>paramName</i>, <b>undefined</b>).</li>
                  </ol>
                </li>
                <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a> for either of the above
                    operations.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>If <i>argumentsObjectNeeded</i> is <b>true</b>, then
          <ol class="block">
            <li>If <i>strict</i> is <b>true</b> or if <i>simpleParameterList</i> is <b>false</b>, then
              <ol class="block">
                <li>Let <i>ao</i> be <a href="#sec-createunmappedargumentsobject">CreateUnmappedArgumentsObject</a>(<i>argumentsList</i>)<i>.</i></li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>NOTE  mapped argument object is only provided for non-strict functions that don&rsquo;t have a rest parameter,
                    any parameter default value initializers, or any destructured parameters .</li>
                <li>Let <i>ao</i> be <a href="#sec-createmappedargumentsobject">CreateMappedArgumentsObject</a>(<i>func</i>,
                    <i>formals</i>, <i>argumentsList</i>, <i>env</i>).</li>
              </ol>
            </li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>ao</i>).</li>
            <li>If <i>strict</i> is <b>true</b>, then
              <ol class="block">
                <li>Let <i>status</i> be <i>envRec</i>.CreateImmutableBinding(<code>"arguments"</code>).</li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Let <i>status</i> be <i>envRec</i>.CreateMutableBinding(<code>"arguments"</code>).</li>
              </ol>
            </li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
            <li><a href="sec-abstract-operations#sec-call">Call</a> <i>envRec</i>.InitializeBinding(<code>"arguments"</code>, <i>ao</i>).</li>
            <li>Append <code>"arguments"</code> to <i>parameterNames</i>.</li>
          </ol>
        </li>
        <li>Let <i>iteratorRecord</i> be Record {[[iterator]]: <a href="sec-abstract-operations#sec-createlistiterator">CreateListIterator</a>(<i>argumentsList</i>), [[done]]: <b>false</b>}.</li>
        <li>If <i>hasDuplicates</i> is <b>true</b>, then
          <ol class="block">
            <li>Let <i>formalStatus</i> be IteratorBindingInitialization for <i>formals</i> with <i>iteratorRecord</i> and
                <b>undefined</b> as arguments.</li>
          </ol>
        </li>
        <li>Else,
          <ol class="block">
            <li>Let <i>formalStatus</i> be IteratorBindingInitialization for <i>formals</i> with <i>iteratorRecord</i>  and
                <i>env</i> as arguments.</li>
          </ol>
        </li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>formalStatus</i>).</li>
        <li>If <i>hasParameterExpressions</i> is <b>false</b>, then
          <ol class="block">
            <li>NOTE  Only a single <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">lexical environment</a> is needed for the parameters and
                top-level vars.</li>
            <li>Let <i>instantiatedVarNames</i> be a copy of the <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>
                <i>parameterNames</i>.</li>
            <li>For each <i>n</i> in <i>varNames</i>, do
              <ol class="block">
                <li>If <i>n</i> is not an element of <i>instantiatedVarNames</i>, then
                  <ol class="block">
                    <li>Append <i>n</i> to <i>instantiatedVarNames</i>.</li>
                    <li>Let <i>status</i> be <i>envRec</i>.CreateMutableBinding(<i>n</i>).</li>
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                    <li><a href="sec-abstract-operations#sec-call">Call</a> <i>envRec</i>.InitializeBinding(<i>n</i>, <b>undefined</b>).</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li>Let <i>varEnv</i> be <i>env</i>.</li>
            <li>Let <i>varEnvRec</i> be <i>envRec</i>.</li>
          </ol>
        </li>
        <li>Else,
          <ol class="block">
            <li>NOTE  A separate <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> is needed to ensure that closures
                created by expressions in the formal parameter list do not have visibility of declarations in the function
                body.</li>
            <li>Let <i>varEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>env</i>).</li>
            <li>Let <i>varEnvRec</i> be <i>varEnv</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
            <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">VariableEnvironment</a> of <i>calleeContext</i> to <i>varEnv</i>.</li>
            <li>Let <i>instantiatedVarNames</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>For each <i>n</i> in <i>varNames</i>, do
              <ol class="block">
                <li>If <i>n</i> is not an element of <i>instantiatedVarNames</i>, then
                  <ol class="block">
                    <li>Append <i>n</i> to <i>instantiatedVarNames</i>.</li>
                    <li>Let <i>status</i> be <i>varEnvRec</i>.CreateMutableBinding(<i>n</i>).</li>
                    <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                    <li>If <i>n</i> is not an element of <i>parameterNames</i> or if <i>n</i> is an element of
                        <i>functionNames</i>, let <i>initialValue</i> be <b>undefined</b>.</li>
                    <li>else,
                      <ol class="block">
                        <li>Let <i>initialValue</i> be <i>envRec.</i>GetBindingValue(<i>n</i>, <b>false</b>).</li>
                        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>initialValue</i>).</li>
                      </ol>
                    </li>
                    <li><a href="sec-abstract-operations#sec-call">Call</a> <i>varEnvRec</i>.InitializeBinding(<i>n</i>, <i>initialValue</i>).</li>
                    <li>NOTE  vars whose names are the same as a formal parameter, initially have the same value as the
                        corresponding initialized parameter.</li>
                  </ol>
                </li>
              </ol>
            </li>
          </ol>
        </li>
        <li>NOTE:  Annex <a href="sec-additional-ecmascript-features-for-web-browsers#sec-block-level-function-declarations-web-legacy-compatibility-semantics">B.3.3</a> adds
            additional steps at this point.</li>
        <li>If <i>strict</i> is <b>false</b>, then
          <ol class="block">
            <li>Let <i>lexEnv</i> be <a href="sec-executable-code-and-execution-contexts#sec-newdeclarativeenvironment">NewDeclarativeEnvironment</a>(<i>varEnv</i>).</li>
            <li>NOTE:  Non-strict functions use a separate lexical <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> for
                top-level lexical declarations so that a direct <code>eval</code> (<a href="sec-ecmascript-language-expressions#sec-function-calls-runtime-semantics-evaluation">see 12.3.4.1</a>) can determine whether any var scoped
                declarations introduced by the eval code conflict with pre-existing top-level lexically scoped declarations. This
                is not needed for strict functions because a strict direct <code>eval</code> always places all declarations into a
                new <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a>.</li>
          </ol>
        </li>
        <li>Else, let <i>lexEnv</i> be <i>varEnv</i>.</li>
        <li>Let <i>lexEnvRec</i> be <i>lexEnv</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
        <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">LexicalEnvironment</a> of <i>calleeContext</i> to <i>lexEnv</i>.</li>
        <li>Let <i>lexDeclarations</i> be the LexicallyScopedDeclarations of <i>code</i>.</li>
        <li>For each element <i>d</i> in <i>lexDeclarations</i> do
          <ol class="block">
            <li>NOTE  A lexically declared name cannot be the same as a function/generator declaration, formal parameter, or a var
                name. Lexically declared names are only instantiated here but not initialized.</li>
            <li>For each element <i>dn</i> of the BoundNames of <i>d</i> do
              <ol class="block">
                <li>If IsConstantDeclaration of <i>d</i> is <b>true</b>, then
                  <ol class="block">
                    <li>Let <i>status</i> be <i>lexEnvRec</i>.CreateImmutableBinding(<i>dn</i>, <b>true</b>).</li>
                  </ol>
                </li>
                <li>Else,
                  <ol class="block">
                    <li>Let <i>status</i> be <i>lexEnvRec</i>.CreateMutableBinding(<i>dn</i>, <b>false</b>).</li>
                  </ol>
                </li>
              </ol>
            </li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          </ol>
        </li>
        <li>For each parsed grammar phrase <i>f</i> in <i>functionsToInitialize</i>, do
          <ol class="block">
            <li>Let <i>fn</i> be the sole element of the BoundNames of <i>f.</i></li>
            <li>Let <i>fo</i> be the result of performing InstantiateFunctionObject for <i>f</i> with argument <i>lexEnv</i>.</li>
            <li>Let <i>status</i> be <i>varEnvRec</i>.SetMutableBinding(<i>fn</i>, <i>fo</i>, <b>false</b>).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          </ol>
        </li>
        <li>Return <a href="sec-ecmascript-data-types-and-values#sec-normalcompletion">NormalCompletion</a>(<span style="font-family: sans-serif">empty</span>).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 2</span> <a href="sec-additional-ecmascript-features-for-web-browsers#sec-block-level-function-declarations-web-legacy-compatibility-semantics">B.3.3</a> provides an extension to the
        above algorithm that is necessary for backwards compatibility with web browser implementations of ECMAScript that predate
        ECMAScript 2015.</p>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 3</span> Parameter <span class="nt">Initializers</span> may contain direct eval expressions (<a href="sec-ecmascript-language-expressions#sec-function-calls-runtime-semantics-evaluation">12.3.4.1</a>). Any top level declarations of such evals are only
        visible to the eval code (<a href="sec-ecmascript-language-source-code#sec-types-of-source-code">10.2</a>). The creation of the environment for such
        declarations is described in <a href="sec-ecmascript-language-functions-and-classes#sec-function-definitions-runtime-semantics-iteratorbindinginitialization">14.1.18</a>.</p>
      </div>
    </section>
  </section>

  <section id="sec-built-in-function-objects">
    <div class="front">
      <h2 id="sec-9.3" title="9.3">
          Built-in Function Objects</h2><p>The built-in function objects defined in this specification may be implemented as either ECMAScript function objects (<a href="#sec-ecmascript-function-objects">9.2</a>) whose behaviour is provided using ECMAScript code or as implementation
      provided exotic function objects whose behaviour is provided in some other manner. In either case, the effect of calling
      such functions must conform to their specifications. An implementation may also provide additional built-in function objects
      that are not defined in this specification.</p>

      <p>If a built-in function object is implemented as an exotic object it must have the ordinary object behaviour specified in
      <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>. All such exotic function objects also have
      [[Prototype]], [[Extensible]], and [[Realm]] internal slots.</p>

      <p>Unless otherwise specified every built-in function object has the %FunctionPrototype% object (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>) as the initial value of its [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

      <p>The behaviour specified for each built-in function via algorithm steps or other means is the specification of the
      function body behaviour for both [[Call]] and [[Construct]] invocations of the function. However, [[Construct]] invocation
      is not supported by all built-in functions. For each built-in function, when invoked with [[Call]], the [[Call]]
      <var>thisArgument</var> provides the <span class="value">this</span> value, the [[Call]] <var>argumentsList</var> provides
      the named parameters, and the NewTarget value is <span class="value">undefined</span>. When invoked with [[Construct]], the
      <span class="value">this</span> value is uninitialized, the [[Construct]] <var>argumentsList</var> provides the named
      parameters, and the [[Construct]] <var>newTarget</var> parameter provides the NewTarget value. If the built-in function is
      implemented as an <a href="#sec-ecmascript-function-objects">ECMAScript function object</a> then this specified behaviour
      must be implemented by the ECMAScript code that is the body of the function. Built-in functions that are ECMAScript function
      objects must be strict mode functions. If a built-in constructor has any [[Call]] behaviour other than throwing a <span class="value">TypeError</span> exception, an ECMAScript implementation of the function must be done in a manner that does
      not cause the function&rsquo;s [[FunctionKind]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>
      to have the value <code>"classConstructor"</code>.</p>

      <p>Built-in function objects that are not identified as constructors do not implement the [[Construct]] internal method
      unless otherwise specified in the description of a particular function. When a built-in constructor is called as part of a
      <code>new</code> expression the <var>argumentsList</var> parameter of the invoked [[Construct]] internal method provides the
      values for the built-in constructor&rsquo;s named parameters.</p>

      <p>Built-in functions that are not constructors do not have a <code>prototype</code> property unless otherwise specified in
      the description of a particular function.</p>

      <p>If a built-in function object is not implemented as an ECMAScript function it must provide [[Call]] and [[Construct]]
      internal methods that conform to the following definitions:</p>
    </div>

    <section id="sec-built-in-function-objects-call-thisargument-argumentslist">
      <h3 id="sec-9.3.1" title="9.3.1"> [[Call]] ( thisArgument, argumentsList)</h3><p class="normalbefore">The [[Call]] internal method for a built-in function object <var>F</var> is called with parameters
      <var>thisArgument</var> and <var>argumentsList</var>, a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a>. The following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>callerContext</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>If <i>callerContext</i> is not already <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">suspended</a>, <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">Suspend</a> <i>callerContext</i>.</li>
        <li>Let <i>calleeContext</i> be a new <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">ECMAScript code execution context</a>.</li>
        <li>Set the Function of <i>calleeContext</i> to <i>F</i>.</li>
        <li>Let <i>calleeRealm</i> be the value of <i>F&rsquo;s</i> [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
        <li>Set the <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> of <i>calleeContext</i> to <i>calleeRealm</i>.</li>
        <li>Perform any necessary implementation defined initialization of <i>calleeContext</i>.</li>
        <li>Push <i>calleeContext</i> onto <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a>; <i>calleeContext</i>
            is now <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Let <i>result</i> be the <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a> that is the result
            of evaluating <i>F</i> in an implementation defined manner that conforms to the specification of <i>F</i>.
            <i>thisArgument</i> is the <b>this</b> value, <i>argumentsList</i> provides the named parameters, and the NewTarget
            value is <b>undefined</b>.</li>
        <li>Remove <i>calleeContext</i> from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the execution context stack</a> and restore
            <i>callerContext</i> as <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>.</li>
        <li>Return <i>result</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> When <var>calleeContext</var> is removed from <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the
        execution context stack</a> it must not be destroyed if it has been <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">suspended</a> and
        retained by an accessible generator object for later resumption<i>.</i></p>
      </div>
    </section>

    <section id="sec-built-in-function-objects-construct-argumentslist-newtarget">
      <h3 id="sec-9.3.2" title="9.3.2"> [[Construct]] (argumentsList, newTarget)</h3><p class="normalbefore">The [[Construct]] internal method for built-in function object <var>F</var> is called with
      parameters <var>argumentsList</var> and <var>newTarget</var>. The steps performed are the same as [[Call]] (<a href="#sec-built-in-function-objects-call-thisargument-argumentslist">see 9.3.1</a>) except that step 9 is replaced by:</p>

      <p class="special1" style="-ooxml-indentation: 18.0pt">9.&#x9;Let <i>result</i> be the <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">Completion Record</a> that is the result of evaluating <i>F</i> in an
      implementation defined manner that conforms to the specification of <i>F</i>. The <b>this</b> value is uninitialized,
      <i>argumentsList</i> provides the named parameters, and <i>newTarget</i> provides the NewTarget value.</p>
    </section>

    <section id="sec-createbuiltinfunction">
      <h3 id="sec-9.3.3" title="9.3.3">
          CreateBuiltinFunction(realm, steps, prototype, internalSlotsList)</h3><p class="normalbefore">The abstract operation CreateBuiltinFunction takes arguments <span style="font-family: Times New       Roman"><i>realm</i>, <i>prototype</i>,</span> and <var>steps</var>. The optional argument <var>internalSlotsList</var> is a
      <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of the names of additional internal slots that must be defined as
      part of the object. If the list is not provided, an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> is
      used. CreateBuiltinFunction returns a built-in function object created by the following steps:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>realm</i> is a <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> Record.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>steps</i> is either a set of algorithm steps or other definition
            of a functions behaviour provided in this specification.</li>
        <li>Let <i>func</i> be a new built-in function object that when called performs the action described by <i>steps</i>. The
            new function object has internal slots whose names are the elements of <i>internalSlotsList</i>. The initial value of
            each of those internal slots is <b>undefined<i>.</i></b></li>
        <li>Set the [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>func</i> to
            <i>realm</i>.</li>
        <li>Set the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>func</i> to
            <i>prototype</i>.</li>
        <li>Return <i>func</i>.</li>
      </ol>

      <p>Each built-in function defined in this specification is created as if by calling the CreateBuiltinFunction abstract
      operation, unless otherwise specified.</p>
    </section>
  </section>

  <section id="sec-built-in-exotic-object-internal-methods-and-slots">
    <div class="front">
      <h2 id="sec-9.4" title="9.4"> Built-in Exotic Object Internal Methods and Slots</h2><p>This specification defines several kinds of built-in exotic objects. These objects generally behave similar to ordinary
      objects except for a few specific situations. The following exotic objects use the ordinary object internal methods except
      where it is explicitly specified otherwise below:</p>
    </div>

    <section id="sec-bound-function-exotic-objects">
      <div class="front">
        <h3 id="sec-9.4.1" title="9.4.1"> Bound Function Exotic Objects</h3><p>A <i>bound function</i> is an exotic object that wraps another function object. A bound function is callable (it has a
        [[Call]] internal method and may have a [[Construct]] internal method). Calling a bound function generally results in a
        call of its wrapped function.</p>

        <p>Bound function objects do not have the internal slots of ECMAScript function objects defined in <a href="#table-27">Table 27</a>. Instead they have the internal slots defined in <a href="#table-28">Table 28</a>.</p>

        <figure>
          <figcaption><span id="table-28">Table 28</span> &mdash; Internal Slots of Exotic Bound Function Objects</figcaption>
          <table class="real-table">
            <tr>
              <th>Internal Slot</th>
              <th>Type</th>
              <th>Description</th>
            </tr>
            <tr>
              <td>[[BoundTargetFunction]]</td>
              <td>Callable Object</td>
              <td>The wrapped function object.</td>
            </tr>
            <tr>
              <td>[[BoundThis]]</td>
              <td>Any</td>
              <td>The value that is always passed as the <b>this</b> value when calling the wrapped function.</td>
            </tr>
            <tr>
              <td>[[BoundArguments]]</td>
              <td><a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of Any</td>
              <td>A list of values whose elements are used as the first arguments to any call to the wrapped function.</td>
            </tr>
          </table>
        </figure>

        <p>Unlike ECMAScript function objects, bound function objects do not use an alternative definition of the
        [[GetOwnProperty]] internal methods. Bound function objects provide all of the essential internal methods as specified in
        <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>. However, they use the following definitions
        for the essential internal methods of function objects.</p>
      </div>

      <section id="sec-bound-function-exotic-objects-call-thisargument-argumentslist">
        <h4 id="sec-9.4.1.1" title="9.4.1.1"> [[Call]] ( thisArgument, argumentsList)</h4><p class="normalbefore">When the [[Call]] internal method of an exotic <a href="#sec-bound-function-exotic-objects">bound
        function</a> object, <var>F</var>, which was created using the bind function is called with parameters
        <var>thisArgument</var> and <var>argumentsList</var>, a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a>, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>target</i> be the value of <i>F&rsquo;s</i> <a href="#sec-bound-function-exotic-objects">[[BoundTargetFunction]]</a> <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>boundThis</i> be the value of <i>F&rsquo;s</i> <a href="#sec-bound-function-exotic-objects">[[BoundThis]]</a>
              <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>boundArgs</i> be the value of <i>F&rsquo;s</i> <a href="#sec-bound-function-exotic-objects">[[BoundArguments]]</a> <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>args</i> be a new list containing the same values as the list <i>boundArgs</i> in the same order followed by
              the same values as the list <i>argumentsList</i> in the same order.</li>
          <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>target</i>, <i>boundThis</i>, <i>args</i>).</li>
        </ol>
      </section>

      <section id="sec-bound-function-exotic-objects-construct-argumentslist-newtarget">
        <h4 id="sec-9.4.1.2" title="9.4.1.2"> [[Construct]] (argumentsList, newTarget)</h4><p class="normalbefore">When the [[Construct]] internal method of an exotic <a href="#sec-bound-function-exotic-objects">bound function</a> object, <var>F</var> that was created using the bind function
        is called with a list of arguments <span style="font-family: Times New Roman"><i>argumentsList</i> and
        <i>newTarget</i></span>, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>target</i> be the value of <i>F&rsquo;s</i> <a href="#sec-bound-function-exotic-objects">[[BoundTargetFunction]]</a> <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>target</i> has a [[Construct]] internal method.</li>
          <li>Let <i>boundArgs</i> be the value of <i>F&rsquo;s</i> <a href="#sec-bound-function-exotic-objects">[[BoundArguments]]</a> <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>args</i> be a new list containing the same values as the list <i>boundArgs</i> in the same order followed by
              the same values as the list <i>argumentsList</i> in the same order.</li>
          <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>F</i>, <i>newTarget</i>) is <b>true</b>, let <i>newTarget</i> be
              <i>target</i>.</li>
          <li>Return <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>target</i>, <i>args</i>, <i>newTarget</i>).</li>
        </ol>
      </section>

      <section id="sec-boundfunctioncreate">
        <h4 id="sec-9.4.1.3" title="9.4.1.3"> BoundFunctionCreate (targetFunction, boundThis, boundArgs)</h4><p class="normalbefore">The abstract operation BoundFunctionCreate with arguments <var>targetFunction</var>,
        <var>boundThis</var> and <var>boundArgs</var> is used to specify the creation of new <a href="#sec-bound-function-exotic-objects">Bound Function</a> exotic objects. It performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>targetFunction</i>) is Object.</li>
          <li>Let <i>proto</i> be <i>targetFunction</i>.[[GetPrototypeOf]]().</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>proto</i>).</li>
          <li>Let <i>obj</i> be a newly created object.</li>
          <li>Set <i>obj</i>&rsquo;s essential internal methods to the default ordinary object definitions specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>.</li>
          <li>Set the [[Call]] internal method of <i>obj</i> as described in <a href="#sec-bound-function-exotic-objects-call-thisargument-argumentslist">9.4.1.1</a>.</li>
          <li>If <i>targetFunction</i> has a [[Construct]] internal method, then
            <ol class="block">
              <li>Set the [[Construct]] internal method of <i>obj</i> as described in <a href="#sec-bound-function-exotic-objects-construct-argumentslist-newtarget">9.4.1.2</a>.</li>
            </ol>
          </li>
          <li>Set the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i> to
              <i>proto</i>.</li>
          <li>Set the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i> to
              <b>true</b>.</li>
          <li>Set the <a href="#sec-bound-function-exotic-objects">[[BoundTargetFunction]]</a> <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i> to
              <i>targetFunction</i>.</li>
          <li>Set the <a href="#sec-bound-function-exotic-objects">[[BoundThis]]</a> <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i> to the value of
              <i>boundThis</i>.</li>
          <li>Set the <a href="#sec-bound-function-exotic-objects">[[BoundArguments]]</a> <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i> to <i>boundArgs</i>.</li>
          <li>Return <i>obj</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-array-exotic-objects">
      <div class="front">
        <h3 id="sec-9.4.2" title="9.4.2">
            Array Exotic Objects</h3><p>An <i>Array object</i> is an exotic object that gives special treatment to array index property keys (<a href="sec-ecmascript-data-types-and-values#sec-object-type">see 6.1.7</a>). A property whose property name is an array index is also called an <i>element</i>.
        Every Array object has a <code>length</code> property whose value is always a nonnegative integer less than <span style="font-family: Times New Roman">2<sup>32</sup></span>. The value of the <code>length</code> property is numerically
        greater than the name of every own property whose name is an array index; whenever an own property of an Array object is
        created or changed, other properties are adjusted as necessary to maintain this invariant. Specifically, whenever an own
        property is added whose name is an array index, the value of the <code>length</code> property is changed, if necessary, to
        be one more than the numeric value of that array index; and whenever the value of the <code>length</code> property is
        changed, every own property whose name is an array index whose value is not smaller than the new length is deleted. This
        constraint applies only to own properties of an Array object and is unaffected by <code>length</code> or array index
        properties that may be inherited from its prototypes.</p>

        <div class="note">
          <p><span class="nh">NOTE</span> A String property name <var>P</var> is an <i>array index</i> if and only if <span style="font-family: Times New Roman"><a href="sec-abstract-operations#sec-tostring">ToString</a>(<a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>P</i>))</span> is equal to <var>P</var> and <span style="font-family: Times New           Roman"><a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>P</i>)</span> is not equal to <span style="font-family: Times New           Roman">2<sup>32</sup>&minus;1</span>.</p>
        </div>

        <p>Array exotic objects always have a non-configurable property named <code>"length"</code>.</p>

        <p>Array exotic objects provide an alternative definition for the [[DefineOwnProperty]] internal method. Except for that
        internal method, Array exotic objects provide all of the other essential internal methods as specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>.</p>
      </div>

      <section id="sec-array-exotic-objects-defineownproperty-p-desc">
        <h4 id="sec-9.4.2.1" title="9.4.2.1"> [[DefineOwnProperty]] ( P, Desc)</h4><p class="normalbefore">When the [[DefineOwnProperty]] internal method of an <a href="#sec-array-exotic-objects">Array
        exotic object</a> <var>A</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, and <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span> the following
        steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
              <b>true</b>.</li>
          <li>If <i>P</i> is <code>"length"</code>, then
            <ol class="block">
              <li>Return <a href="#sec-arraysetlength">ArraySetLength</a>(<i>A</i>, <i>Desc</i>).</li>
            </ol>
          </li>
          <li>Else if <i>P</i> is an array index, then
            <ol class="block">
              <li>Let <i>oldLenDesc</i> be <a href="#sec-ordinarygetownproperty">OrdinaryGetOwnProperty</a>(<i>A</i>,
                  <code>"length"</code>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>oldLenDesc</i> will never be <b>undefined</b> or an accessor
                  descriptor because Array objects are created with a length data property that cannot be deleted or
                  reconfigured.</li>
              <li>Let <i>oldLen</i> be <i>oldLenDesc</i>.[[Value]].</li>
              <li>Let <i>index</i> be <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>P</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>index</i> will never be an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              <li>If <i>index</i> &ge; <i>oldLen</i> and <i>oldLenDesc</i>.[[Writable]] is <b>false</b>, return <b>false</b>.</li>
              <li>Let <i>succeeded</i> be <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>A</i>,
                  <i>P</i>, <i>Desc</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>succeeded</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              <li>If <i>succeeded</i> is <b>false</b>, return <b>false</b>.</li>
              <li>If <i>index</i> &ge; <i>oldLen</i>
                <ol class="block">
                  <li>Set <i>oldLenDesc</i>.[[Value]] to <i>index</i> + 1.</li>
                  <li>Let <i>succeeded</i> be <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>A</i>,
                      <code>"length"</code>, <i>oldLenDesc</i>).</li>
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>succeeded</i> is <b>true</b>.</li>
                </ol>
              </li>
              <li>Return <b>true</b>.</li>
            </ol>
          </li>
          <li>Return <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>A</i>, <i>P</i>, <i>Desc</i>).</li>
        </ol>
      </section>

      <section id="sec-arraycreate">
        <h4 id="sec-9.4.2.2" title="9.4.2.2">
            ArrayCreate(length, proto)</h4><p class="normalbefore">The abstract operation ArrayCreate with argument <var>length</var> (a positive integer) and
        optional argument <var>proto</var> is used to specify the creation of new Array exotic objects. It performs the following
        steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>length</i> is an integer Number &ge; 0.</li>
          <li>If <i>length</i> is &minus;0, let <i>length</i> be +0.</li>
          <li>If <i>length</i>&gt;2<sup>32</sup>-1, throw a <b>RangeError</b> exception.</li>
          <li>If the <i>proto</i> argument was not passed, let <i>proto</i> be the intrinsic object <span style="font-family:               sans-serif">%ArrayPrototype%</span>.</li>
          <li>Let <i>A</i> be a newly created <a href="#sec-array-exotic-objects">Array exotic object</a>.</li>
          <li>Set <i>A</i>&rsquo;s essential internal methods except for [[DefineOwnProperty]] to the default ordinary object
              definitions specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>.</li>
          <li>Set the [[DefineOwnProperty]] internal method of <i>A</i> as specified in <a href="#sec-array-exotic-objects-defineownproperty-p-desc">9.4.2.1</a>.</li>
          <li>Set the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>A</i> to
              <i>proto</i>.</li>
          <li>Set the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>A</i> to
              <b>true</b>.</li>
          <li>Perform <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>A</i>, <code>"length"</code>,
              PropertyDescriptor{[[Value]]: <i>length</i>, [[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>,
              [[Configurable]]: <b>false</b>}).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: the preceding step never produces an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>Return <i>A</i>.</li>
        </ol>
      </section>

      <section id="sec-arrayspeciescreate">
        <h4 id="sec-9.4.2.3" title="9.4.2.3"> ArraySpeciesCreate(originalArray, length)</h4><p class="normalbefore">The abstract operation ArraySpeciesCreate with arguments <var>originalArray</var> and
        <var>length</var> is used to specify the creation of a new Array object using a constructor function that is derived from
        <var>originalArray</var>. It performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>length</i> is an integer Number &ge; 0.</li>
          <li>If <i>length</i> is &minus;0, let <i>length</i> be +0.</li>
          <li>Let <i>C</i> be <b>undefined</b>.</li>
          <li>Let <i>isArray</i> be <a href="sec-abstract-operations#sec-isarray">IsArray</a>(<i>originalArray</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>isArray</i>).</li>
          <li>If <i>isArray</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>C</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>originalArray</i>, <code>"constructor"</code>).</li>
              <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>C</i>).</li>
              <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>C</i>) is <b>true</b>, then
                <ol class="block">
                  <li>Let <i>thisRealm</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>.</li>
                  <li>Let <i>realmC</i> be <a href="sec-abstract-operations#sec-getfunctionrealm">GetFunctionRealm</a>(<i>C</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>realmC</i>).</li>
                  <li>If <i>thisRealm</i> and <i>realmC</i> are not the same <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> Record, then
                    <ol class="block">
                      <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>C</i>, <i>realmC</i>.[[intrinsics]].[[%Array%]]) is
                          <b>true</b>, let <i>C</i> be <b>undefined</b>.</li>
                    </ol>
                  </li>
                </ol>
              </li>
              <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>C</i>) is Object, then
                <ol class="block">
                  <li>Let <i>C</i> be <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>C</i>, @@species).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>C</i>).</li>
                  <li>If <i>C</i> is <b>null</b>, let <i>C</i> be <b>undefined</b>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>C</i> is <b>undefined</b>, return <a href="#sec-arraycreate">ArrayCreate</a>(<i>length</i>).</li>
          <li>If <a href="sec-abstract-operations#sec-isconstructor">IsConstructor</a>(<i>C</i>) is <b>false</b>, throw a <b>TypeError</b>
              exception<i>.</i></li>
          <li>Return <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>C</i>, &laquo;<i>length</i>&raquo;).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> If <var>originalArray</var> was created using the standard built-in Array constructor
          for a <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> that is not the <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a>  of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>, then a new Array is created using the <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> of <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the running execution context</a>. This maintains
          compatibility with Web browsers that have historically had that behaviour for the Array.prototype methods that now are
          defined using  ArraySpeciesCreate.</p>
        </div>
      </section>

      <section id="sec-arraysetlength">
        <h4 id="sec-9.4.2.4" title="9.4.2.4">
            ArraySetLength(A, Desc)</h4><p class="normalbefore">When the abstract operation ArraySetLength is called with an <a href="#sec-array-exotic-objects">Array exotic object</a> <span style="font-family: Times New Roman"><i>A</i>,</span> and
        <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span> the following
        steps are taken:</p>

        <ol class="proc">
          <li>If the [[Value]] field of <i>Desc</i> is absent, then
            <ol class="block">
              <li>Return <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>A</i>, <code>"length"</code>,
                  <i>Desc</i>).</li>
            </ol>
          </li>
          <li>Let <i>newLenDesc</i> be a copy of <i>Desc</i>.</li>
          <li>Let <i>newLen</i> be <a href="sec-abstract-operations#sec-touint32">ToUint32</a>(<i>Desc</i>.[[Value]]).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>newLen</i>).</li>
          <li>Let <i>numberLen</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>Desc</i>.[[Value]]).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>newLen</i>).</li>
          <li>If <i>newLen</i> &ne; <i>numberLen</i>, throw a <b>RangeError</b> exception.</li>
          <li>Set <i>newLenDesc</i>.[[Value]] to <i>newLen</i>.</li>
          <li>Let <i>oldLenDesc</i> be <a href="#sec-ordinarygetownproperty">OrdinaryGetOwnProperty</a>(<i>A</i>,
              <code>"length"</code>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>oldLenDesc</i> will never be <b>undefined</b> or an accessor
              descriptor because Array objects are created with a length data property that cannot be deleted or
              reconfigured.</li>
          <li>Let <i>oldLen</i> be <i>oldLenDesc</i>.[[Value]].</li>
          <li>If <i>newLen</i> &ge;<i>oldLen</i>, then
            <ol class="block">
              <li>Return <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>A</i>, <code>"length"</code>,
                  <i>newLenDesc</i>).</li>
            </ol>
          </li>
          <li>If <i>oldLenDesc</i>.[[Writable]] is <b>false</b>, return <b>false</b>.</li>
          <li>If <i>newLenDesc</i>.[[Writable]] is absent or has the value <b>true</b>, let <i>newWritable</i> be
              <b>true</b>.</li>
          <li>Else,
            <ol class="block">
              <li>Need to defer setting the [[Writable]] attribute to <b>false</b> in case any elements cannot be deleted.</li>
              <li>Let <i>newWritable</i> be <b>false</b>.</li>
              <li>Set <i>newLenDesc</i>.[[Writable]] to <b>true</b>.</li>
            </ol>
          </li>
          <li>Let <i>succeeded</i> be <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>A</i>,
              <code>"length"</code>, <i>newLenDesc</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>succeeded</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>If <i>succeeded</i> is <b>false</b>, return <b>false</b>.</li>
          <li>While <i>newLen</i> &lt; <i>oldLen</i> repeat,
            <ol class="block">
              <li>Set <i>oldLen</i> to <i>oldLen</i> &ndash; 1.</li>
              <li>Let <i>deleteSucceeded</i> be <i>A</i>.[[Delete]](<a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>oldLen</i>)).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>deleteSucceeded</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              <li>If <i>deleteSucceeded</i> is <b>false</b>, then
                <ol class="block">
                  <li>Set <i>newLenDesc</i>.[[Value]] to <i>oldLen</i> <i>+</i> 1.</li>
                  <li>If <i>newWritable</i> is <b>false</b>, set <i>newLenDesc</i>.[[Writable]] to <b>false</b>.</li>
                  <li>Let <i>succeeded</i> be <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>A</i>,
                      <code>"length"</code>, <i>newLenDesc</i>).</li>
                  <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>succeeded</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
                  <li>Return <b>false</b>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>If <i>newWritable</i> is <b>false</b>, then
            <ol class="block">
              <li>Return <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>A</i>, <code>"length"</code>,
                  PropertyDescriptor{[[Writable]]: <b>false</b>}). This call will always return <b>true</b>.</li>
            </ol>
          </li>
          <li>Return <b>true</b>.</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> In steps 3 and 4, if <span style="font-family: Times New           Roman"><i>Desc</i>.[[Value]]</span> is an object then its <code>valueOf</code> method is called twice. This is legacy
          behaviour that was specified with this effect starting with the 2<sup>nd</sup> Edition of this specification.</p>
        </div>
      </section>
    </section>

    <section id="sec-string-exotic-objects">
      <div class="front">
        <h3 id="sec-9.4.3" title="9.4.3">
            String Exotic Objects</h3><p>A <i>String object</i> is an exotic object that encapsulates a String value and exposes virtual integer indexed data
        properties corresponding to the individual code unit elements of the String value. Exotic String objects always have a
        data property named <code>"length"</code> whose value is the number of code unit elements in the encapsulated String
        value. Both the code unit data properties and the <code>"length"</code> property are non-writable and
        non-configurable.</p>

        <p>Exotic String objects have the same internal slots as ordinary objects. They also have a [[StringData]] internal
        slot.</p>

        <p>Exotic String objects provide alternative definitions for the following internal methods. All of the other exotic
        String object essential internal methods that are not defined below are as specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>.</p>
      </div>

      <section id="sec-string-exotic-objects-getownproperty-p">
        <div class="front">
          <h4 id="sec-9.4.3.1" title="9.4.3.1"> [[GetOwnProperty]] ( P )</h4><p class="normalbefore">When the [[GetOwnProperty]] internal method of an exotic String object <var>S</var> is called
          with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> the following steps are taken:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
                <b>true</b>.</li>
            <li>Let <i>desc</i> be <a href="#sec-ordinarygetownproperty">OrdinaryGetOwnProperty</a>(<i>S</i>, <i>P</i>).</li>
            <li>If <i>desc</i> is not <b>undefined</b> return <i>desc</i>.</li>
            <li>Return <a href="#sec-stringgetindexproperty">StringGetIndexProperty</a>(<i>S</i>, <i>P</i>).</li>
          </ol>
        </div>

        <section id="sec-stringgetindexproperty">
          <h5 id="sec-9.4.3.1.1" title="9.4.3.1.1"> StringGetIndexProperty (S, P)</h5><p class="normalbefore">When the abstract operation StringGetIndexProperty is called with an exotic String object
          <var>S</var> and with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

          <ol class="proc">
            <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is not String, return <b>undefined</b>.</li>
            <li>Let <i>index</i> be <a href="sec-abstract-operations#sec-canonicalnumericindexstring">CanonicalNumericIndexString</a> (<i>P</i>).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>index</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
            <li>If <i>index</i> is <b>undefined</b>, return <b>undefined</b>.</li>
            <li>If <a href="sec-abstract-operations#sec-isinteger">IsInteger</a>(<i>index</i>) is <b>false</b>, return <b>undefined</b>.</li>
            <li>If <i>index</i> = &minus;0, return <b>undefined</b>.</li>
            <li>Let <i>str</i> be the String value of the [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>S</i>.</li>
            <li>Let <i>len</i> be the number of elements in <i>str</i>.</li>
            <li>If <i>index</i> &lt; 0 or <i>len</i> &le; <i>index</i>, return <b>undefined</b>.</li>
            <li>Let <i>resultStr</i> be a String value of length 1, containing one code unit from <i>str</i>, specifically the
                code unit at index <i>index</i>.</li>
            <li>Return a PropertyDescriptor{ [[Value]]: <i>resultStr</i>, [[Enumerable]]: <b>true</b>, [[Writable]]: <b>false</b>,
                [[Configurable]]: <b>false</b> }.</li>
          </ol>
        </section>
      </section>

      <section id="sec-string-exotic-objects-hasproperty-p">
        <h4 id="sec-9.4.3.2" title="9.4.3.2"> [[HasProperty]](P)</h4><p class="normalbefore">When the [[HasProperty]] internal method of an exotic String object <var>S</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>elementDesc</i> be <a href="#sec-stringgetindexproperty">StringGetIndexProperty</a>(<i>S</i>, <i>P</i>).</li>
          <li>If <i>elementDesc</i> is not <b>undefined</b>, return <b>true</b>.</li>
          <li>Return <a href="#sec-ordinaryhasproperty">OrdinaryHasProperty</a>(<i>S</i>, <i>P</i>)..</li>
        </ol>
      </section>

      <section id="sec-string-exotic-objects-ownpropertykeys">
        <h4 id="sec-9.4.3.3" title="9.4.3.3"> [[OwnPropertyKeys]] ( )</h4><p class="normalbefore">When the [[OwnPropertyKeys]] internal method of a <a href="#sec-string-exotic-objects">String
        exotic object</a> <var>O</var> is called the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>keys</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li>Let <i>str</i> be the String value of the [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
          <li>Let <i>len</i> be the number of elements in <i>str</i>.</li>
          <li>For each integer <i>i</i> starting with 0 such that <i>i</i> &lt; <i>len</i>, in ascending order,
            <ol class="block">
              <li>Add <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>i</i>) as the last element of <i>keys</i></li>
            </ol>
          </li>
          <li>For each own <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <i>P</i> of <i>O</i> such that <i>P</i> is an integer index
              and <a href="sec-abstract-operations#sec-tointeger">ToInteger</a>(<i>P</i>) &ge; <i>len</i>, in ascending numeric index order,
            <ol class="block">
              <li>Add <i>P</i> as the last element of <i>keys</i>.</li>
            </ol>
          </li>
          <li>For each own <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <i>P</i> of <i>O</i> such that <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is String and <i>P</i> is not an integer index, in
              property creation order,
            <ol class="block">
              <li>Add <i>P</i> as the last element of <i>keys</i>.</li>
            </ol>
          </li>
          <li>For each own <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <i>P</i> of <i>O</i> such that <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is Symbol, in property creation order,
            <ol class="block">
              <li>Add <i>P</i> as the last element of <i>keys</i>.</li>
            </ol>
          </li>
          <li>Return <i>keys</i>.</li>
        </ol>
      </section>

      <section id="sec-stringcreate">
        <h4 id="sec-9.4.3.4" title="9.4.3.4">
            StringCreate( value, prototype)</h4><p class="normalbefore">The abstract operation StringCreate with arguments <var>value</var> and <var>prototype</var> is
        used to specify the creation of new exotic String objects. It performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>prototype</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>value</i>) is String.</li>
          <li>Let <i>S</i> be a newly created <a href="#sec-string-exotic-objects">String exotic object</a>.</li>
          <li>Set the [[StringData]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>S</i> to
              <i>value</i>.</li>
          <li>Set <i>S</i>&rsquo;s essential internal methods to the default ordinary object definitions specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>.</li>
          <li>Set the [[GetOwnProperty]] internal method of <i>S</i> as specified in <a href="#sec-string-exotic-objects-getownproperty-p">9.4.3.1</a>.</li>
          <li>Set the [[HasProperty]] internal method of <i>S</i> as specified in <a href="#sec-string-exotic-objects-hasproperty-p">9.4.3.2</a>.</li>
          <li>Set the [[OwnPropertyKeys]] internal method of <i>S</i> as specified in <a href="#sec-string-exotic-objects-ownpropertykeys">9.4.3.3</a>.</li>
          <li>Set the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>S</i> to
              <i>prototype</i>.</li>
          <li>Set the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>S</i> to
              <b>true</b>.</li>
          <li>Let <i>length</i> be the number of code unit elements in <i>value.</i></li>
          <li>Let <i>status</i> be <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>S</i>, <code>"length"</code>,
              PropertyDescriptor{[[Value]]: <i>length</i>,  [[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>,
              [[Configurable]]: <b>false</b> }).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>status</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>Return <i>S</i>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-arguments-exotic-objects">
      <div class="front">
        <h3 id="sec-9.4.4" title="9.4.4"> Arguments Exotic Objects</h3><p>Most ECMAScript functions make an arguments objects available to their code. Depending upon the characteristics of the
        function definition, its argument object is either an ordinary object or an <i>arguments exotic object</i>. An arguments
        exotic object is an exotic object whose array index properties map to the formal parameters bindings of an invocation of
        its associated ECMAScript function.</p>

        <p>Arguments exotic objects have the same internal slots as ordinary objects. They also have a [[ParameterMap]] internal
        slot. Ordinary arguments objects also have a [[ParameterMap]] internal slot whose value is always undefined. For ordinary
        argument objects the [[ParameterMap]] internal slot is only used by <code><a href="sec-fundamental-objects#sec-object.prototype.tostring">Object.prototype.toString</a></code> (<a href="sec-fundamental-objects#sec-object.prototype.tostring">19.1.3.6</a>) to identify them as such.</p>

        <p>Arguments exotic objects provide alternative definitions for the following internal methods. All of the other exotic
        arguments object essential internal methods that are not defined below are as specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a></p>

        <div class="note">
          <p><span class="nh">NOTE 1</span> For non-strict functions the integer indexed data properties of an arguments object
          whose numeric name values are less than the number of formal parameters of the corresponding function object initially
          share their values with the corresponding argument bindings in the function&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">execution context</a>. This means that changing the property changes the corresponding
          value of the argument binding and vice-versa. This correspondence is broken if such a property is deleted and then
          redefined or if the property is changed into an accessor property. For strict mode functions, the values of the
          arguments object&rsquo;s properties are simply a copy of the arguments passed to the function and there is no dynamic
          linkage between the property values and the formal parameter values.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 2</span> The ParameterMap object and its property values are used as a device for specifying
          the arguments object correspondence to argument bindings. The ParameterMap object and the objects that are the values of
          its properties are not directly observable from ECMAScript code. An ECMAScript implementation does not need to actually
          create or use such objects to implement the specified semantics.</p>
        </div>

        <div class="note">
          <p><span class="nh">NOTE 3</span> Arguments objects for strict mode functions define non-configurable accessor
          properties named <code>"caller"</code> and <code>"callee"</code> which throw a <b>TypeError</b> exception on access. The
          <code>"callee"</code> property has a more specific meaning for non-strict functions and a <code>"caller"</code> property
          has historically been provided as an implementation-defined extension by some ECMAScript implementations. The strict
          mode definition of these properties exists to ensure that neither of them is defined in any other manner by conforming
          ECMAScript implementations.</p>
        </div>
      </div>

      <section id="sec-arguments-exotic-objects-getownproperty-p">
        <h4 id="sec-9.4.4.1" title="9.4.4.1"> [[GetOwnProperty]] (P)</h4><p>The [[GetOwnProperty]] internal method of an arguments exotic object when called with a <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>args</i> be the arguments object.</li>
          <li>Let <i>desc</i> be <a href="#sec-ordinarygetownproperty">OrdinaryGetOwnProperty</a>(<i>args</i>, <i>P</i>).</li>
          <li>If <i>desc</i> is <b>undefined</b>, return <i>desc</i>.</li>
          <li>Let <i>map</i> be the value of the [[ParameterMap]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the arguments object.</li>
          <li>Let <i>isMapped</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>map</i>, <i>P</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>isMapped</i> is never an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>If the value of <i>isMapped</i> is <b>true</b>, then
            <ol class="block">
              <li>Set <i>desc</i>.[[Value]] to <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>map</i>, <i>P</i>).</li>
            </ol>
          </li>
          <li>If <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>desc</i>) is <b>true</b> and <i>P</i> is
              <code>"caller"</code> and <i>desc</i>.[[Value]] is a strict mode Function object, throw a <b>TypeError</b>
              exception.</li>
          <li>Return <i>desc</i>.</li>
        </ol>

        <p>If an implementation does not provide a built-in <code>caller</code> property for argument exotic objects then step 8
        of this algorithm is must be skipped.</p>
      </section>

      <section id="sec-arguments-exotic-objects-defineownproperty-p-desc">
        <h4 id="sec-9.4.4.2" title="9.4.4.2"> [[DefineOwnProperty]] (P, Desc)</h4><p>The [[DefineOwnProperty]] internal method of an arguments exotic object when called with a <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> and <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property
        Descriptor</a> <span class="nt">Desc</span> performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>args</i> be the arguments object.</li>
          <li>Let <i>map</i> be the value of the [[ParameterMap]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the arguments object.</li>
          <li>Let <i>isMapped</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>map</i>, <i>P</i>).</li>
          <li>Let <i>allowed</i> be <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>args</i>, <i>P</i>,
              <i>Desc</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>allowed</i>).</li>
          <li>If <i>allowed</i> is <b>false</b>, return <b>false</b>.</li>
          <li>If the value of <i>isMapped</i> is <b>true</b>, then
            <ol class="block">
              <li>If <a href="sec-ecmascript-data-types-and-values#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>Desc</i>) is <b>true</b>, then
                <ol class="block">
                  <li><a href="sec-abstract-operations#sec-call">Call</a> <i>map</i>.[[Delete]](<i>P</i>).</li>
                </ol>
              </li>
              <li>Else
                <ol class="block">
                  <li>If <i>Desc</i>.[[Value]] is present, then
                    <ol class="block">
                      <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>map</i>, <i>P</i>,
                          <i>Desc</i>.[[Value]], <b>false</b>).</li>
                      <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>setStatus</i> is <b>true</b> because formal
                          parameters mapped by argument objects are always writable.</li>
                    </ol>
                  </li>
                  <li>If <i>Desc</i>.[[Writable]] is present and its value is <b>false</b>, then
                    <ol class="block">
                      <li><a href="sec-abstract-operations#sec-call">Call</a> <i>map</i>.[[Delete]](<i>P</i>).</li>
                    </ol>
                  </li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-arguments-exotic-objects-get-p-receiver">
        <h4 id="sec-9.4.4.3" title="9.4.4.3"> [[Get]] (P, Receiver)</h4><p>The [[Get]] internal method of an arguments exotic object when called with a <a href="sec-ecmascript-data-types-and-values#sec-object-type">property
        key</a> <var>P</var> and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> <span class="nt">Receiver</span> performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>args</i> be the arguments object.</li>
          <li>Let <i>map</i> be the value of the [[ParameterMap]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the arguments object.</li>
          <li>Let <i>isMapped</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>map</i>, <i>P</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>isMapped</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>If the value of <i>isMapped</i> is <b>false</b>, then
            <ol class="block">
              <li>Return the result of calling the default ordinary object [[Get]] internal method (<a href="#sec-ordinary-object-internal-methods-and-internal-slots-get-p-receiver">9.1.8</a>) on <i>args</i> passing
                  <i>P</i> and <i>Receiver</i> as the arguments.</li>
            </ol>
          </li>
          <li>Else <i>map</i> contains a formal parameter mapping for <i>P</i>,
            <ol class="block">
              <li>Return <a href="sec-abstract-operations#sec-get-o-p">Get</a>(<i>map</i>, <i>P</i>).</li>
            </ol>
          </li>
        </ol>
      </section>

      <section id="sec-arguments-exotic-objects-set-p-v-receiver">
        <h4 id="sec-9.4.4.4" title="9.4.4.4"> [[Set]] ( P, V, Receiver)</h4><p>The [[Set]] internal method of an arguments exotic object when called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a>
        <var>P</var>, value <var>V</var>, and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> <span class="nt">Receiver</span> performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>args</i> be the arguments object.</li>
          <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>args</i>, <i>Receiver</i>) is <b>false</b>, then
            <ol class="block">
              <li>Let <i>isMapped</i> be <b>false</b>.</li>
            </ol>
          </li>
          <li>Else,
            <ol class="block">
              <li>Let <i>map</i> be the value of the [[ParameterMap]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the arguments object.</li>
              <li>Let <i>isMapped</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>map</i>, <i>P</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>isMapped</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
            </ol>
          </li>
          <li>If <i>isMapped</i> is <b>true</b>, then
            <ol class="block">
              <li>Let <i>setStatus</i> be <a href="sec-abstract-operations#sec-set-o-p-v-throw">Set</a>(<i>map</i>, <i>P</i>, <i>V</i>,
                  <b>false</b>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>setStatus</i> is <b>true</b> because formal parameters
                  mapped by argument objects are always writable.</li>
            </ol>
          </li>
          <li>Return the result of calling the default ordinary object [[Set]] internal method (<a href="#sec-ordinary-object-internal-methods-and-internal-slots-set-p-v-receiver">9.1.9</a>) on <i>args</i> passing
              <i>P</i>, <i>V</i> and <i>Receiver</i> as the arguments.</li>
        </ol>
      </section>

      <section id="sec-arguments-exotic-objects-delete-p">
        <h4 id="sec-9.4.4.5" title="9.4.4.5"> [[Delete]] (P)</h4><p>The [[Delete]] internal method of an arguments exotic object when called with a <a href="sec-ecmascript-data-types-and-values#sec-object-type">property
        key</a> <var>P</var> performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>map</i> be the value of the [[ParameterMap]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of the arguments object.</li>
          <li>Let <i>isMapped</i> be <a href="sec-abstract-operations#sec-hasownproperty">HasOwnProperty</a>(<i>map</i>, <i>P</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>isMapped</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>Let <i>result</i> be the result of calling the default [[Delete]] internal method for ordinary objects (<a href="#sec-ordinary-object-internal-methods-and-internal-slots-delete-p">9.1.10</a>) on the arguments object passing
              <i>P</i> as the argument.</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>result</i>).</li>
          <li>If <i>result</i> is <b>true</b> and the value of <i>isMapped</i> is <b>true</b>, then
            <ol class="block">
              <li><a href="sec-abstract-operations#sec-call">Call</a> <i>map</i>.[[Delete]](<i>P</i>).</li>
            </ol>
          </li>
          <li>Return <i>result</i>.</li>
        </ol>
      </section>

      <section id="sec-createunmappedargumentsobject">
        <h4 id="sec-9.4.4.6" title="9.4.4.6"> CreateUnmappedArgumentsObject(argumentsList)</h4><p class="normalbefore">The abstract operation <span style="font-family: Times New         Roman">CreateUnmappedArgumentsObject</span> called with an argument <var>argumentsList</var> performs the following
        steps:</p>

        <ol class="proc">
          <li>Let <i>len</i> be the number of elements in <i>argumentsList</i>.</li>
          <li>Let <i>obj</i> be <a href="#sec-objectcreate">ObjectCreate</a>(%ObjectPrototype%,
              &laquo;&zwj;[[ParameterMap]]&raquo;).</li>
          <li>Set <i>obj</i>&rsquo;s [[ParameterMap]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>
              to <b>undefined</b>.</li>
          <li>Perform <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>obj</i>, <code>"length"</code>,
              PropertyDescriptor{[[Value]]: <i>len</i>, [[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
              <b>true</b>}).</li>
          <li>Let <i>index</i> be 0.</li>
          <li>Repeat while <i>index</i> &lt; <i>len</i>,
            <ol class="block">
              <li>Let <i>val</i> be <i>argumentsList</i>[<i>index</i>].</li>
              <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>obj</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>index</i>), <i>val</i>).</li>
              <li>Let <i>index</i> be <i>index</i> + 1</li>
            </ol>
          </li>
          <li>Perform <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>obj</i>, @@iterator, PropertyDescriptor
              {[[Value]]:%ArrayProto_values%, [[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
              <b>true</b>}).</li>
          <li>Perform <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>obj</i>, <code>"caller"</code>,
              PropertyDescriptor {[[Get]]: <a href="#sec-%throwtypeerror%">%ThrowTypeError%</a>, [[Set]]: <a href="#sec-%throwtypeerror%">%ThrowTypeError%</a>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
              <b>false</b>}).</li>
          <li>Perform <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>obj</i>, <code>"callee"</code>,
              PropertyDescriptor {[[Get]]: <a href="#sec-%throwtypeerror%">%ThrowTypeError%</a>, [[Set]]: <a href="#sec-%throwtypeerror%">%ThrowTypeError%</a>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
              <b>false</b>}).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: the above property definitions will not produce an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
          <li>Return <i>obj</i></li>
        </ol>
      </section>

      <section id="sec-createmappedargumentsobject">
        <div class="front">
          <h4 id="sec-9.4.4.7" title="9.4.4.7"> CreateMappedArgumentsObject ( func, formals, argumentsList, env
              )</h4><p class="normalbefore">The abstract operation <span style="font-family: Times New           Roman">CreateMappedArgumentsObject</span> is called with object <var>func</var>, parsed grammar phrase
          <var>formals</var>, <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> <var>argumentsList</var>, and <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> <span style="font-family: Times New Roman"><i>env</i>.</span> The
          following steps are performed:</p>

          <ol class="proc">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>formals</i> does not contain a rest parameter, any binding
                patterns, or any initializers. It may contain duplicate identifiers.</li>
            <li>Let <i>len</i> be the number of elements in <i>argumentsList</i>.</li>
            <li>Let <i>obj</i> be a newly created arguments exotic object with a [[ParameterMap]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Set the [[GetOwnProperty]] internal method of <i>obj</i> as specified in <a href="#sec-arguments-exotic-objects-getownproperty-p">9.4.4.1</a>.</li>
            <li>Set the [[DefineOwnProperty]] internal method of <i>obj</i> as specified in <a href="#sec-arguments-exotic-objects-defineownproperty-p-desc">9.4.4.2</a>.</li>
            <li>Set the [[Get]] internal method of <i>obj</i> as specified in <a href="#sec-arguments-exotic-objects-get-p-receiver">9.4.4.3</a>.</li>
            <li>Set the [[Set]] internal method of <i>obj</i> as specified in <a href="#sec-arguments-exotic-objects-set-p-v-receiver">9.4.4.4</a>.</li>
            <li>Set the [[Delete]] internal method of <i>obj</i> as specified in <a href="#sec-arguments-exotic-objects-delete-p">9.4.4.5</a>.</li>
            <li>Set the remainder of <i>obj</i>&rsquo;s essential internal methods to the default ordinary object definitions
                specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>.</li>
            <li>Set the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i> to
                %ObjectPrototype%.</li>
            <li>Set the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i>
                to <b>true</b>.</li>
            <li>Let <i>parameterNames</i> be the BoundNames of <i>formals</i>.</li>
            <li>Let <i>numberOfParameters</i> be the number of elements in <i>parameterNames</i></li>
            <li>Let <i>index</i> be 0.</li>
            <li>Repeat while <i>index</i> &lt; <i>len</i> ,
              <ol class="block">
                <li>Let <i>val</i> be <i>argumentsList</i>[<i>index</i>].</li>
                <li>Perform <a href="sec-abstract-operations#sec-createdataproperty">CreateDataProperty</a>(<i>obj</i>, <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>index</i>), <i>val</i>).</li>
                <li>Let <i>index</i> be <i>index</i> + 1</li>
              </ol>
            </li>
            <li>Perform <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>obj</i>, <code>"length"</code>,
                PropertyDescriptor{[[Value]]: <i>len</i>, [[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>,
                [[Configurable]]: <b>true</b>}).</li>
            <li>Let <i>map</i> be <a href="#sec-objectcreate">ObjectCreate</a>(<b>null</b>).</li>
            <li>Let <i>mappedNames</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
            <li>Let <i>index</i> be <i>numberOfParameters</i> &minus; 1.</li>
            <li>Repeat while <i>index</i> &ge; 0 ,
              <ol class="block">
                <li>Let <i>name</i> be <i>parameterNames</i>[<i>index</i>].</li>
                <li>If <i>name</i> is not an element of <i>mappedNames</i>, then
                  <ol class="block">
                    <li>Add <i>name</i> as an element of the list <i>mappedNames</i>.</li>
                    <li>If <i>index</i> &lt; <i>len</i>, then
                      <ol class="block">
                        <li>Let <i>g</i> be <a href="#sec-makearggetter">MakeArgGetter</a>(<i>name</i>, <i>env</i>).</li>
                        <li>Let <i>p</i> be <a href="#sec-makeargsetter">MakeArgSetter</a>(<i>name</i>, <i>env</i>).</li>
                        <li><a href="sec-abstract-operations#sec-call">Call</a> <i>map</i>.[[DefineOwnProperty]](<a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>index</i>), PropertyDescriptor{[[Set]]: <i>p</i>, [[Get]]:
                            <i>g,</i> [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>true</b>}).</li>
                      </ol>
                    </li>
                  </ol>
                </li>
                <li>Let <i>index</i> be <i>index</i> &minus; 1</li>
              </ol>
            </li>
            <li>Set the [[ParameterMap]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>obj</i>
                to <i>map</i>.</li>
            <li>Perform <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>obj</i>, @@iterator, PropertyDescriptor
                {[[Value]]:%ArrayProto_values%, [[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]:
                <b>true</b>}).</li>
            <li>Perform <a href="sec-abstract-operations#sec-definepropertyorthrow">DefinePropertyOrThrow</a>(<i>obj</i>, <code>"callee"</code>,
                PropertyDescriptor {[[Value]]: <i>func</i>, [[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>,
                [[Configurable]]: <b>true</b>}).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: the above property definitions will not produce an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
            <li>Return <i>obj</i></li>
          </ol>
        </div>

        <section id="sec-makearggetter">
          <h5 id="sec-9.4.4.7.1" title="9.4.4.7.1"> MakeArgGetter ( name, env)</h5><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">MakeArgGetter</span> called
          with String <var>name</var> and <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> <var>env</var> creates a
          built-in function object that when executed returns the value bound for <var>name</var> in <var>env</var>. It performs
          the following steps:</p>

          <ol class="proc">
            <li>Let <i>realm</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the current Realm</a>.</li>
            <li>Let <i>steps</i> be the steps of an ArgGetter function as specified below.</li>
            <li>Let <i>getter</i> be <a href="#sec-createbuiltinfunction">CreateBuiltinFunction</a>(<i>realm</i>, <i>steps</i>,
                %FunctionPrototype%, &laquo;&zwj;[[name]], [[env]]&raquo; ).</li>
            <li>Set <i>getter&rsquo;s</i> [[name]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
                <i>name</i>.</li>
            <li>Set <i>getter&rsquo;s</i> [[env]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
                <i>env</i>.</li>
            <li>Return <i>getter</i>.</li>
          </ol>

          <p class="normalbefore">An ArgGetter function is an anonymous built-in function with [[name]] and [[env]] internal
          slots. When an ArgGetter function <var>f</var> that expects no arguments is called it performs the following steps:</p>

          <ol class="proc">
            <li>Let <i>name</i> be the value of <i>f&rsquo;s</i> [[name]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>env</i> be the value of <i>f&rsquo;s</i> [[env]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a></li>
            <li>Return <i>env</i>.GetBindingValue(<i>name</i>, <b>false</b>).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> ArgGetter functions are never directly accessible to ECMAScript code.</p>
          </div>
        </section>

        <section id="sec-makeargsetter">
          <h5 id="sec-9.4.4.7.2" title="9.4.4.7.2"> MakeArgSetter ( name, env)</h5><p class="normalbefore">The abstract operation <span style="font-family: Times New Roman">MakeArgSetter</span> called
          with String <var>name</var> and <a href="sec-executable-code-and-execution-contexts#sec-environment-records">Environment Record</a> <var>env</var> creates a
          built-in function object that when executed sets the value bound for <var>name</var> in <var>env</var>. It performs the
          following steps:</p>

          <ol class="proc">
            <li>Let <i>realm</i> be <a href="sec-executable-code-and-execution-contexts#sec-execution-contexts">the current Realm</a>.</li>
            <li>Let <i>steps</i> be the steps of an ArgSetter function as specified below.</li>
            <li>Let <i>setter</i> be <a href="#sec-createbuiltinfunction">CreateBuiltinFunction</a>(<i>realm</i>, <i>steps</i>,
                %FunctionPrototype%, &laquo;&zwj;[[name]], [[env]]&raquo; ).</li>
            <li>Set <i>setter&rsquo;s</i> [[name]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
                <i>name</i>.</li>
            <li>Set <i>setter&rsquo;s</i> [[env]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
                <i>env</i>.</li>
            <li>Return <i>setter</i>.</li>
          </ol>

          <p>An ArgSetter function is an anonymous built-in function with [[name]] and [[env]] internal slots. When an ArgSetter
          function <var>f</var> is called with argument <var>value</var> it performs the following steps:</p>

          <ol class="proc">
            <li>Let <i>name</i> be the value of <i>f&rsquo;s</i> [[name]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
            <li>Let <i>env</i> be the value of <i>f&rsquo;s</i> [[env]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a></li>
            <li>Return <i>env</i>.SetMutableBinding(<i>name</i>, <i>value</i>, <b>false</b>).</li>
          </ol>

          <div class="note">
            <p><span class="nh">NOTE</span> ArgSetter functions are never directly accessible to ECMAScript code.</p>
          </div>
        </section>
      </section>
    </section>

    <section id="sec-integer-indexed-exotic-objects">
      <div class="front">
        <h3 id="sec-9.4.5" title="9.4.5"> Integer Indexed Exotic Objects</h3><p>An <i>Integer Indexed object</i> is an exotic object that performs special handling of integer index property keys.</p>

        <p>Integer Indexed exotic objects have the same internal slots as ordinary objects additionally [[ViewedArrayBuffer]],
        [[ArrayLength]], [[ByteOffset]], and [[TypedArrayName]] internal slots.</p>

        <p>Integer Indexed Exotic objects provide alternative definitions for the following internal methods. All of the other
        Integer Indexed exotic object essential internal methods that are not defined below are as specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>.</p>
      </div>

      <section id="sec-integer-indexed-exotic-objects-getownproperty-p">
        <h4 id="sec-9.4.5.1" title="9.4.5.1"> [[GetOwnProperty]] ( P )</h4><p class="normalbefore">When the [[GetOwnProperty]] internal method of an Integer Indexed exotic object <var>O</var> is
        called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
              <b>true</b>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>O</i> is an Object that has a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is String, then
            <ol class="block">
              <li>Let <i>numericIndex</i> be <a href="sec-abstract-operations#sec-canonicalnumericindexstring">CanonicalNumericIndexString</a>(<i>P</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numericIndex</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              <li>If <i>numericIndex</i> is not <b>undefined</b>, then
                <ol class="block">
                  <li>Let <i>value</i> be <a href="#sec-integerindexedelementget">IntegerIndexedElementGet</a> (<i>O</i>,
                      <i>numericIndex</i>).</li>
                  <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
                  <li>If <i>value</i> is <b>undefined</b>, return <b>undefined</b>.</li>
                  <li>Return a PropertyDescriptor{ [[Value]]: <i>value</i>, [[Enumerable]]: <b>true</b>, [[Writable]]:
                      <b>true</b>, [[Configurable]]: <b>false</b> }.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <a href="#sec-ordinarygetownproperty">OrdinaryGetOwnProperty</a>(<i>O</i>, <i>P</i>).</li>
        </ol>
      </section>

      <section id="sec-integer-indexed-exotic-objects-hasproperty-p">
        <h4 id="sec-9.4.5.2" title="9.4.5.2"> [[HasProperty]](P)</h4><p class="normalbefore">When the [[HasProperty]] internal method of an Integer Indexed exotic object <var>O</var> is
        called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
              <b>true</b>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>O</i> is an Object that has a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is String, then
            <ol class="block">
              <li>Let <i>numericIndex</i> be <a href="sec-abstract-operations#sec-canonicalnumericindexstring">CanonicalNumericIndexString</a>(<i>P</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numericIndex</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              <li>If <i>numericIndex</i> is not <b>undefined</b>, then
                <ol class="block">
                  <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
                  <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a
                      <b>TypeError</b> exception.</li>
                  <li>If <a href="sec-abstract-operations#sec-isinteger">IsInteger</a>(<i>numericIndex</i>) is <b>false</b>, return <b>false</b></li>
                  <li>If <i>numericIndex</i> = &minus;0, return <b>false</b>.</li>
                  <li>If <i>numericIndex</i> &lt; 0, return <b>false</b>.</li>
                  <li>If <i>numericIndex</i> &ge; the value of <i>O</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, return <b>false</b>.</li>
                  <li>Return <b>true</b>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <a href="#sec-ordinaryhasproperty">OrdinaryHasProperty</a>(<i>O</i>, <i>P</i>).</li>
        </ol>
      </section>

      <section id="sec-integer-indexed-exotic-objects-defineownproperty-p-desc">
        <h4 id="sec-9.4.5.3" title="9.4.5.3"> [[DefineOwnProperty]] ( P, Desc)</h4><p class="normalbefore">When the [[DefineOwnProperty]] internal method of an Integer Indexed exotic object <var>O</var> is
        called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, and <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span> the following
        steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
              <b>true</b>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>O</i> is an Object that has a [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is String, then
            <ol class="block">
              <li>Let <i>numericIndex</i> be <a href="sec-abstract-operations#sec-canonicalnumericindexstring">CanonicalNumericIndexString</a>
                  (<i>P</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numericIndex</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              <li>If <i>numericIndex</i> is not <b>undefined</b>, then
                <ol class="block">
                  <li>If <a href="sec-abstract-operations#sec-isinteger">IsInteger</a>(<i>numericIndex</i>) is <b>false</b>, return <b>false</b></li>
                  <li>Let <i>intIndex</i> be <i>numericIndex</i>.</li>
                  <li>If <i>intIndex</i> = &minus;0, return <b>false</b>.</li>
                  <li>If <i>intIndex</i> &lt; 0, return <b>false</b>.</li>
                  <li>Let <i>length</i> be the value of <i>O</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
                  <li>If <i>intIndex</i> &ge; <i>length</i>, return <b>false</b>.</li>
                  <li>If <a href="sec-ecmascript-data-types-and-values#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>Desc</i>) is <b>true</b>, return
                      <b>false.</b></li>
                  <li>If <i>Desc</i> has a [[Configurable]] field and if <i>Desc</i>.[[Configurable]] is <b>true</b>, return
                      <b>false<i>.</i></b></li>
                  <li>If <i>Desc</i> has an [[Enumerable]] field and if <i>Desc</i>.[[Enumerable]] is <b>false</b>, return
                      <b>false<i>.</i></b></li>
                  <li>If <i>Desc</i> has a [[Writable]] field and if <i>Desc</i>.[[Writable]] is <b>false</b>, return
                      <b>false</b>.</li>
                  <li>If <i>Desc</i> has a [[Value]] field, then
                    <ol class="block">
                      <li>Let <i>value</i> be <i>Desc</i>.[[Value]].</li>
                      <li>Return <a href="#sec-integerindexedelementset">IntegerIndexedElementSet</a> (<i>O</i>, <i>intIndex</i>,
                          <i>value</i>).</li>
                    </ol>
                  </li>
                  <li>Return <b>true</b>.</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return <a href="#sec-ordinarydefineownproperty">OrdinaryDefineOwnProperty</a>(<i>O</i>, <i>P</i>, <i>Desc</i>).</li>
        </ol>
      </section>

      <section id="sec-integer-indexed-exotic-objects-get-p-receiver">
        <h4 id="sec-9.4.5.4" title="9.4.5.4"> [[Get]] (P, Receiver)</h4><p class="normalbefore">When the [[Get]] internal method of an Integer Indexed exotic object <var>O</var> is called with
        <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language
        value</a> <span class="nt">Receiver</span> the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
              <b>true</b>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is String and if <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>O</i>, <i>Receiver</i>) is <b>true</b>, then
            <ol class="block">
              <li>Let <i>numericIndex</i> be <a href="sec-abstract-operations#sec-canonicalnumericindexstring">CanonicalNumericIndexString</a>
                  (<i>P</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numericIndex</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              <li>If <i>numericIndex</i> is not <b>undefined</b>, then
                <ol class="block">
                  <li>Return <a href="#sec-integerindexedelementget">IntegerIndexedElementGet</a> (<i>O</i>,
                      <i>numericIndex</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return the result of calling the default ordinary object [[Get]] internal method (<a href="#sec-ordinary-object-internal-methods-and-internal-slots-get-p-receiver">9.1.8</a>) on <i>O</i> passing
              <i>P</i> and <i>Receiver</i> as arguments.</li>
        </ol>
      </section>

      <section id="sec-integer-indexed-exotic-objects-set-p-v-receiver">
        <h4 id="sec-9.4.5.5" title="9.4.5.5"> [[Set]] ( P, V, Receiver)</h4><p class="normalbefore">When the [[Set]] internal method of an Integer Indexed exotic object <var>O</var> is called with
        <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, value <var>V</var>, and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> <span class="nt">Receiver</span>, the following steps
        are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
              <b>true</b>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is String and if <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>O</i>, <i>Receiver</i>) is <b>true</b>, then
            <ol class="block">
              <li>Let <i>numericIndex</i> be <a href="sec-abstract-operations#sec-canonicalnumericindexstring">CanonicalNumericIndexString</a>
                  (<i>P</i>).</li>
              <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>numericIndex</i> is not an <a href="sec-ecmascript-data-types-and-values#sec-completion-record-specification-type">abrupt completion</a>.</li>
              <li>If <i>numericIndex</i> is not <b>undefined</b>, then
                <ol class="block">
                  <li>Return <a href="#sec-integerindexedelementset">IntegerIndexedElementSet</a> (<i>O</i>, <i>numericIndex</i>,
                      <i>V</i>).</li>
                </ol>
              </li>
            </ol>
          </li>
          <li>Return the result of calling the default ordinary object [[Set]] internal method (<a href="#sec-ordinary-object-internal-methods-and-internal-slots-get-p-receiver">9.1.8</a>) on <i>O</i> passing
              <i>P</i>, <i>V</i>, and <i>Receiver</i> as arguments.</li>
        </ol>
      </section>

      <section id="sec-integer-indexed-exotic-objects-ownpropertykeys">
        <h4 id="sec-9.4.5.6" title="9.4.5.6"> [[OwnPropertyKeys]] ()</h4><p>When the [[OwnPropertyKeys]] internal method of an Integer Indexed exotic object <var>O</var> is called the following
        steps are taken:</p>

        <ol class="proc">
          <li>Let <i>keys</i> be a new empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>O</i> is an Object that has [[ViewedArrayBuffer]],
              [[ArrayLength]], [[ByteOffset]], and [[TypedArrayName]] internal slots.</li>
          <li>Let <i>len</i> be the value of <i>O</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>For each integer <i>i</i> starting with 0 such that <i>i</i> &lt; <i>len</i>, in ascending order,
            <ol class="block">
              <li>Add <a href="sec-abstract-operations#sec-tostring">ToString</a>(<i>i</i>) as the last element of <i>keys</i>.</li>
            </ol>
          </li>
          <li>For each own <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <i>P</i> of <i>O</i> such that <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is String and <i>P</i> is not an integer index, in
              property creation order
            <ol class="block">
              <li>Add <i>P</i> as the last element of <i>keys</i>.</li>
            </ol>
          </li>
          <li>For each own <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <i>P</i> of <i>O</i> such that <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is Symbol, in property creation order
            <ol class="block">
              <li>Add <i>P</i> as the last element of <i>keys</i>.</li>
            </ol>
          </li>
          <li>Return <i>keys</i>.</li>
        </ol>
      </section>

      <section id="sec-integerindexedobjectcreate">
        <h4 id="sec-9.4.5.7" title="9.4.5.7"> IntegerIndexedObjectCreate (prototype, internalSlotsList)</h4><p class="normalbefore">The abstract operation IntegerIndexedObjectCreate with arguments <var>prototype</var> and
        <var>internalSlotsList</var> is used to specify the creation of new Integer Indexed exotic objects. The argument
        <var>internalSlotsList</var> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of the names of additional
        internal slots that must be defined as part of the object. IntegerIndexedObjectCreate performs the following steps:</p>

        <ol class="proc">
          <li>Let <i>A</i> be a newly created object with an <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
              slot</a> for each name in <i>internalSlotsList</i>.</li>
          <li>Set <i>A</i>&rsquo;s essential internal methods to the default ordinary object definitions specified in <a href="#sec-ordinary-object-internal-methods-and-internal-slots">9.1</a>.</li>
          <li>Set the [[GetOwnProperty]] internal method of <i>A</i> as specified in <a href="#sec-integer-indexed-exotic-objects-getownproperty-p">9.4.5.1</a>.</li>
          <li>Set the [[HasProperty]] internal method of <i>A</i> as specified in <a href="#sec-integer-indexed-exotic-objects-hasproperty-p">9.4.5.2</a>.</li>
          <li>Set the [[DefineOwnProperty]] internal method of <i>A</i> as specified in <a href="#sec-integer-indexed-exotic-objects-defineownproperty-p-desc">9.4.5.3</a>.</li>
          <li>Set the [[Get]] internal method of <i>A</i> as specified in <a href="#sec-integer-indexed-exotic-objects-get-p-receiver">9.4.5.4</a>.</li>
          <li>Set the [[Set]] internal method of <i>A</i> as specified in <a href="#sec-integer-indexed-exotic-objects-set-p-v-receiver">9.4.5.5</a>.</li>
          <li>Set the [[OwnPropertyKeys]] internal method of <i>A</i> as specified in <a href="#sec-integer-indexed-exotic-objects-ownpropertykeys">9.4.5.6</a>.</li>
          <li>Set the [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>A</i> to
              <i>prototype</i>.</li>
          <li>Set the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>A</i> to
              <b>true</b>.</li>
          <li>Return <i>A</i>.</li>
        </ol>
      </section>

      <section id="sec-integerindexedelementget">
        <h4 id="sec-9.4.5.8" title="9.4.5.8"> IntegerIndexedElementGet ( O, index )</h4><p class="normalbefore">The abstract operation IntegerIndexedElementGet with arguments <var>O</var> and <var>index</var>
        performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>index</i>) is Number.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>O</i> is an Object that has [[ViewedArrayBuffer]],
              [[ArrayLength]], [[ByteOffset]], and [[TypedArrayName]] internal slots.</li>
          <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <a href="sec-abstract-operations#sec-isinteger">IsInteger</a>(<i>index</i>) is <b>false</b>, return <b>undefined</b></li>
          <li>If <i>index</i> = &minus;0, return <b>undefined</b>.</li>
          <li>Let <i>length</i> be the value of <i>O</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>index</i> &lt; 0 or <i>index</i> &ge; <i>length</i>, return <b>undefined</b>.</li>
          <li>Let <i>offset</i> be the value of <i>O</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>arrayTypeName</i> be the String value of <i>O</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>elementSize</i> be the Number value of the Element Size value specified in <a href="sec-indexed-collections#table-49">Table 49</a>
              for <i>arrayTypeName</i>.</li>
          <li>Let <i>indexedPosition</i> = (<i>index</i> &times; <i>elementSize</i>) + <i>offset</i>.</li>
          <li>Let <i>elementType</i> be the String value of the Element Type value in <a href="sec-indexed-collections#table-49">Table 49</a> for
              <i>arrayTypeName</i>.</li>
          <li>Return <a href="sec-structured-data#sec-getvaluefrombuffer">GetValueFromBuffer</a>(<i>buffer</i>, <i>indexedPosition</i>,
              <i>elementType</i>).</li>
        </ol>
      </section>

      <section id="sec-integerindexedelementset">
        <h4 id="sec-9.4.5.9" title="9.4.5.9"> IntegerIndexedElementSet ( O, index, value )</h4><p class="normalbefore">The abstract operation IntegerIndexedElementSet with arguments <var>O</var>, <var>index</var>, and
        <var>value</var> performs the following steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>index</i>) is Number.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>O</i> is an Object that has [[ViewedArrayBuffer]],
              [[ArrayLength]], [[ByteOffset]], and [[TypedArrayName]] internal slots.</li>
          <li>Let <i>numValue</i> be <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>(<i>value</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>numValue</i>).</li>
          <li>Let <i>buffer</i> be the value of <i>O</i>&rsquo;s [[ViewedArrayBuffer]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <a href="sec-structured-data#sec-isdetachedbuffer">IsDetachedBuffer</a>(<i>buffer</i>) is <b>true</b>, throw a <b>TypeError</b>
              exception.</li>
          <li>If <a href="sec-abstract-operations#sec-isinteger">IsInteger</a>(<i>index</i>) is <b>false</b>, return <b>false</b></li>
          <li>If <i>index</i> = &minus;0, return <b>false</b>.</li>
          <li>Let <i>length</i> be the value of <i>O</i>&rsquo;s [[ArrayLength]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>index</i> &lt; 0 or <i>index</i> &ge; <i>length</i>, return <b>false</b>.</li>
          <li>Let <i>offset</i> be the value of <i>O</i>&rsquo;s [[ByteOffset]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>arrayTypeName</i> be the String value of <i>O</i>&rsquo;s [[TypedArrayName]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>elementSize</i> be the Number value of the Element Size value specified in <a href="sec-indexed-collections#table-49">Table 49</a>
              for <i>arrayTypeName</i>.</li>
          <li>Let <i>indexedPosition</i> = (<i>index</i> &times; <i>elementSize</i>) + <i>offset</i>.</li>
          <li>Let <i>elementType</i> be the String value of the Element Type value in <a href="sec-indexed-collections#table-49">Table 49</a> for
              <i>arrayTypeName</i>.</li>
          <li>Perform <a href="sec-structured-data#sec-setvalueinbuffer">SetValueInBuffer</a>(<i>buffer</i>, <i>indexedPosition</i>,
              <i>elementType</i>, <i>numValue</i>).</li>
          <li>Return <b>true</b>.</li>
        </ol>
      </section>
    </section>

    <section id="sec-module-namespace-exotic-objects">
      <div class="front">
        <h3 id="sec-9.4.6" title="9.4.6"> Module Namespace Exotic Objects</h3><p>A <i>module namespace object</i> is an exotic object that exposes the bindings exported from an ECMAScript <span class="nt">Module</span> <var>(See <a href="sec-ecmascript-language-scripts-and-modules#sec-exports">15.2.3</a>)</var>. There is a one-to-one correspondence between
        the String-keyed own properties of a module namespace exotic object and the binding names exported by the <span class="nt">Module</span>. The exported bindings include any bindings that are indirectly exported using <code>export
        *</code> export items. Each String-valued own <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> is the StringValue of the
        corresponding exported binding name. These are the only String-keyed properties of a module namespace exotic object. Each
        such property has the attributes {[[Configurable]]: <span class="value">false</span>, [[Enumerable]]: <span class="value">true</span>}. Module namespace objects are not extensible.</p>

        <p>Module namespace objects have the internal slots defined in <a href="#table-29">Table 29</a>.</p>

        <figure>
          <figcaption><span id="table-29">Table 29</span> &mdash; Internal Slots of Module Namespace Exotic Objects</figcaption>
          <table class="real-table">
            <tr>
              <th>Internal Slot</th>
              <th>Type</th>
              <th>Description</th>
            </tr>
            <tr>
              <td>[[Module]]</td>
              <td><a href="sec-ecmascript-language-scripts-and-modules#sec-abstract-module-records">Module Record</a></td>
              <td>The <a href="sec-ecmascript-language-scripts-and-modules#sec-abstract-module-records">Module Record</a> whose exports this namespace exposes.</td>
            </tr>
            <tr>
              <td>[[Exports]]</td>
              <td><a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of String</td>
              <td>A <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing the String values of the exported names exposed as own properties of this object. The list is ordered as if an Array of those String values had been sorted using <code><a href="sec-indexed-collections#sec-array.prototype.sort">Array.prototype.sort</a></code> using <a href="sec-indexed-collections#sec-sortcompare">SortCompare</a> as <i><span style="font-family: Times New Roman">comparefn</span>.</i></td>
            </tr>
          </table>
        </figure>

        <p>Module namespace exotic objects provide alternative definitions for all of the internal methods.</p>
      </div>

      <section id="sec-module-namespace-exotic-objects-getprototypeof">
        <h4 id="sec-9.4.6.1" title="9.4.6.1"> [[GetPrototypeOf]] ( )</h4><p class="normalbefore">When the [[GetPrototypeOf]] internal method of a module namespace exotic object <var>O</var> is
        called the following steps are taken:</p>

        <ol class="proc">
          <li>Return <b>null</b>.</li>
        </ol>
      </section>

      <section id="sec-module-namespace-exotic-objects-setprototypeof-v">
        <h4 id="sec-9.4.6.2" title="9.4.6.2"> [[SetPrototypeOf]] (V)</h4><p class="normalbefore">When the [[SetPrototypeOf]] internal method of a module namespace exotic object <var>O</var> is
        called with argument <var>V</var> the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: Either <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>V</i>) is Object or <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>V</i>) is Null.</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-module-namespace-exotic-objects-isextensible">
        <h4 id="sec-9.4.6.3" title="9.4.6.3"> [[IsExtensible]] ( )</h4><p class="normalbefore">When the [[IsExtensible]] internal method of a module namespace exotic object <var>O</var> is
        called the following steps are taken:</p>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-module-namespace-exotic-objects-preventextensions">
        <h4 id="sec-9.4.6.4" title="9.4.6.4"> [[PreventExtensions]] ( )</h4><p class="normalbefore">When the [[PreventExtensions]] internal method of a module namespace exotic object <var>O</var> is
        called the following steps are taken:</p>

        <ol class="proc">
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-module-namespace-exotic-objects-getownproperty-p">
        <h4 id="sec-9.4.6.5" title="9.4.6.5"> [[GetOwnProperty]] (P)</h4><p class="normalbefore">When the [[GetOwnProperty]] internal method of a module namespace exotic object <var>O</var> is
        called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is Symbol, return <a href="#sec-ordinarygetownproperty">OrdinaryGetOwnProperty</a>(<i>O</i>, <i>P</i>).</li>
          <li>Let <i>exports</i> be the value of <i>O</i>&rsquo;s [[Exports]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>P</i> is not an element of <i>exports</i>, return <b>undefined</b>.</li>
          <li>Let <i>value</i> be <i>O</i>.[[Get]](<i>P</i>, <i>O</i>).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>value</i>).</li>
          <li>Return PropertyDescriptor{[[Value]]: <i>value</i>, [[Writable]]: <b>true</b>, [[Enumerable]]: <b>true</b>,
              [[Configurable]]: <b>false</b> }.</li>
        </ol>
      </section>

      <section id="sec-module-namespace-exotic-objects-defineownproperty-p-desc">
        <h4 id="sec-9.4.6.6" title="9.4.6.6"> [[DefineOwnProperty]] (P, Desc)</h4><p class="normalbefore">When the [[DefineOwnProperty]] internal method of a module namespace exotic object <var>O</var> is
        called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> and <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a> <span class="nt">Desc</span>, the following
        steps are taken:</p>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-module-namespace-exotic-objects-hasproperty-p">
        <h4 id="sec-9.4.6.7" title="9.4.6.7"> [[HasProperty]] (P)</h4><p class="normalbefore">When the [[HasProperty]] internal method of a module namespace exotic object <var>O</var> is
        called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

        <ol class="proc">
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is Symbol, return <a href="#sec-ordinaryhasproperty">OrdinaryHasProperty</a>(<i>O</i>, <i>P</i>).</li>
          <li>Let <i>exports</i> be the value of <i>O</i>&rsquo;s [[Exports]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>P</i> is an element of <i>exports</i>, return <b>true</b>.</li>
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-module-namespace-exotic-objects-get-p-receiver">
        <h4 id="sec-9.4.6.8" title="9.4.6.8"> [[Get]] (P, Receiver)</h4><p class="normalbefore">When the [[Get]] internal method of a module namespace exotic object <var>O</var> is called with
        <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language
        value</a> <span class="nt">Receiver</span> the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
              <b>true</b>.</li>
          <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>P</i>) is Symbol, then
            <ol class="block">
              <li>Return the result of calling the default ordinary object [[Get]] internal method (<a href="#sec-ordinary-object-internal-methods-and-internal-slots-get-p-receiver">9.1.8</a>) on <i>O</i> passing
                  <i>P</i> and <i>Receiver</i> as arguments.</li>
            </ol>
          </li>
          <li>Let <i>exports</i> be the value of <i>O</i>&rsquo;s [[Exports]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>P</i> is not an element of <i>exports</i>, return <b>undefined</b>.</li>
          <li>Let <i>m</i> be the value of <i>O</i>&rsquo;s [[Module]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>binding</i> be <i>m</i>.<a href="sec-ecmascript-language-scripts-and-modules#sec-resolveexport">ResolveExport</a>(<i>P</i>, &laquo;&raquo;,
              &laquo;&raquo;).</li>
          <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>binding</i>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>binding</i> is neither <b>null</b> nor
              <code>"ambiguous"</code>.</li>
          <li>Let <i>targetModule</i> be <i>binding</i>.[[module]],</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>targetModule</i> is not <b>undefined</b>.</li>
          <li>Let <i>targetEnv</i> be <i>targetModule</i>.[[Environment]].</li>
          <li>If <i>targetEnv</i> is <b>undefined</b>, throw a <b>ReferenceError</b> exception.</li>
          <li>Let <i>targetEnvRec</i> be <i>targetEnv</i>&rsquo;s <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">EnvironmentRecord</a>.</li>
          <li>Return <i>targetEnvRec</i>.GetBindingValue(<i>binding.</i>[[bindingName]], <b>true</b>).</li>
        </ol>

        <div class="note">
          <p><span class="nh">NOTE</span> <a href="sec-ecmascript-language-scripts-and-modules#sec-resolveexport">ResolveExport</a> is idempotent and side-effect free. An
          implementation might choose to pre-compute or cache the <a href="sec-ecmascript-language-scripts-and-modules#sec-resolveexport">ResolveExport</a> results for the
          [[Exports]] of each module namespace exotic object.</p>
        </div>
      </section>

      <section id="sec-module-namespace-exotic-objects-set-p-v-receiver">
        <h4 id="sec-9.4.6.9" title="9.4.6.9"> [[Set]] ( P, V, Receiver)</h4><p class="normalbefore">When the [[Set]] internal method of <span style="font-family: Times New Roman">a</span> module
        namespace exotic object <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, value
        <var>V</var>, and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> <span class="nt">Receiver</span>,
        the following steps are taken:</p>

        <ol class="proc">
          <li>Return <b>false</b>.</li>
        </ol>
      </section>

      <section id="sec-module-namespace-exotic-objects-delete-p">
        <h4 id="sec-9.4.6.10" title="9.4.6.10"> [[Delete]] (P)</h4><p class="normalbefore">When the [[Delete]] internal method of a module namespace exotic object <var>O</var> is called
        with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> the following steps are taken:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
              <b>true</b>.</li>
          <li>Let <i>exports</i> be the value of <i>O</i>&rsquo;s [[Exports]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>If <i>P</i> is an element of <i>exports</i>, return <b>false</b>.</li>
          <li>Return <b>true</b>.</li>
        </ol>
      </section>

      <section id="sec-module-namespace-exotic-objects-enumerate">
        <h4 id="sec-9.4.6.11" title="9.4.6.11"> [[Enumerate]] ()</h4><p class="normalbefore">When the [[Enumerate]] internal method of a module namespace exotic object <var>O</var> is called
        the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>exports</i> be the value of <i>O</i>&rsquo;s [[Exports]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Return <a href="sec-abstract-operations#sec-createlistiterator">CreateListIterator</a>(<i>exports</i>).</li>
        </ol>
      </section>

      <section id="sec-module-namespace-exotic-objects-ownpropertykeys">
        <h4 id="sec-9.4.6.12" title="9.4.6.12"> [[OwnPropertyKeys]] ( )</h4><p class="normalbefore">When the [[OwnPropertyKeys]] internal method of a module namespace exotic object <var>O</var> is
        called the following steps are taken:</p>

        <ol class="proc">
          <li>Let <i>exports</i> be a copy of the value of <i>O</i>&rsquo;s [[Exports]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</li>
          <li>Let <i>symbolKeys</i> be the result of calling the default ordinary object [[OwnPropertyKeys]] internal method (<a href="#sec-ordinary-object-internal-methods-and-internal-slots-ownpropertykeys">9.1.12</a>) on <i>O</i> passing no
              arguments.</li>
          <li>Append all the entries of <i>symbolKeys</i> to the end of <i>exports</i>.</li>
          <li>Return <i>exports</i>.</li>
        </ol>
      </section>

      <section id="sec-modulenamespacecreate">
        <h4 id="sec-9.4.6.13" title="9.4.6.13"> ModuleNamespaceCreate (module, exports)</h4><p class="normalbefore">The abstract operation ModuleNamespaceCreate with arguments <var>module</var>, and
        <var>exports</var> is used to specify the creation of new module namespace exotic objects. It performs the following
        steps:</p>

        <ol class="proc">
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>module</i> is a <a href="sec-ecmascript-language-scripts-and-modules#sec-abstract-module-records">Module
              Record</a> (<a href="sec-ecmascript-language-scripts-and-modules#sec-abstract-module-records">see 15.2.1.15</a>).</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>module</i>.[[Namespace]] is <b>undefined</b>.</li>
          <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>exports</i> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of String values.</li>
          <li>Let <i>M</i> be a newly created object.</li>
          <li>Set <i>M</i>&rsquo;s essential internal methods to the definitions specified in <a href="#sec-module-namespace-exotic-objects">9.4.6</a>.</li>
          <li>Set <i>M</i>&rsquo;s [[Module]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <i>module</i>.</li>
          <li>Set <i>M</i>&rsquo;s [[Exports]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> to
              <i>exports</i>.</li>
          <li>Create own properties of <i>M</i> corresponding to the definitions in <a href="sec-reflection#sec-module-namespace-objects">26.3</a>.</li>
          <li>Set <i>module</i>.[[Namespace]] to <i>M</i>.</li>
          <li>Return <i>M</i>.</li>
        </ol>
      </section>
    </section>
  </section>

  <section id="sec-proxy-object-internal-methods-and-internal-slots">
    <div class="front">
      <h2 id="sec-9.5" title="9.5"> Proxy Object Internal Methods and Internal Slots</h2><p>A proxy object is an exotic object whose essential internal methods are partially implemented using ECMAScript code.
      Every proxy objects has an <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> called
      [[ProxyHandler]]. The value of [[ProxyHandler]] is an object, called the proxy&rsquo;s <i>handler object</i>, or <span class="value">null</span>. Methods (see <a href="#table-30">Table 30</a>) of a handler object may be used to augment the
      implementation for one or more of the proxy object&rsquo;s internal methods. Every proxy object also has an <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> called [[ProxyTarget]] whose value is either an
      object or the <b>null</b> value. This object is called the proxy&rsquo;s <i>target object</i>.</p>

      <figure>
        <figcaption><span id="table-30">Table 30</span> &mdash; Proxy Handler Methods</figcaption>
        <table class="real-table">
          <tr>
            <th>Internal Method</th>
            <th>Handler Method</th>
          </tr>
          <tr>
            <td>[[GetPrototypeOf]]</td>
            <td><code>getPrototypeOf</code></td>
          </tr>
          <tr>
            <td>[[SetPrototypeOf]]</td>
            <td><code>setPrototypeOf</code></td>
          </tr>
          <tr>
            <td>[[IsExtensible]]</td>
            <td><code>isExtensible</code></td>
          </tr>
          <tr>
            <td>[[PreventExtensions]]</td>
            <td><code>preventExtensions</code></td>
          </tr>
          <tr>
            <td>[[GetOwnProperty]]</td>
            <td><code>getOwnPropertyDescriptor</code></td>
          </tr>
          <tr>
            <td>[[HasProperty]]</td>
            <td><code>has</code></td>
          </tr>
          <tr>
            <td>[[Get]]</td>
            <td><code>get</code></td>
          </tr>
          <tr>
            <td>[[Set]]</td>
            <td><code>set</code></td>
          </tr>
          <tr>
            <td>[[Delete]]</td>
            <td><code>deleteProperty</code></td>
          </tr>
          <tr>
            <td>[[DefineOwnProperty]]</td>
            <td><code>defineProperty</code></td>
          </tr>
          <tr>
            <td>[[Enumerate]]</td>
            <td><code>enumerate</code></td>
          </tr>
          <tr>
            <td>[[OwnPropertyKeys]]</td>
            <td><code>ownKeys</code></td>
          </tr>
          <tr>
            <td>[[Call]]</td>
            <td><code>apply</code></td>
          </tr>
          <tr>
            <td>[[Construct]]</td>
            <td><code>construct</code></td>
          </tr>
        </table>
      </figure>

      <p>When a handler method is called to provide the implementation of a proxy object internal method, the handler method is
      passed the proxy&rsquo;s target object as a parameter. A proxy&rsquo;s handler object does not necessarily have a method
      corresponding to every essential internal method. Invoking an internal method on the proxy results in the invocation of the
      corresponding internal method on the proxy&rsquo;s target object if the handler object does not have a method corresponding
      to the internal trap.</p>

      <p>The [[ProxyHandler]] and [[ProxyTarget]] internal slots of a proxy object are always initialized when the object is
      created and typically may not be modified. Some proxy objects are created in a manner that permits them to be subsequently
      <i>revoked</i>. When a proxy is revoked, its [[ProxyHander]] and [[ProxyTarget]] internal slots are set to <b>null</b>
      causing subsequent invocations of internal methods on that proxy object to throw a <span class="value">TypeError</span>
      exception.</p>

      <p>Because proxy objects permit the implementation of internal methods to be provided by arbitrary ECMAScript code, it is
      possible to define a proxy object whose handler methods violates the invariants defined in <a href="sec-ecmascript-data-types-and-values#sec-invariants-of-the-essential-internal-methods">6.1.7.3</a>. Some of the internal method invariants defined in <a href="sec-ecmascript-data-types-and-values#sec-invariants-of-the-essential-internal-methods">6.1.7.3</a> are essential integrity invariants. These invariants
      are explicitly enforced by the proxy object internal methods specified in this section. An ECMAScript implementation must be
      robust in the presence of all possible invariant violations.</p>

      <p>In the following algorithm descriptions, assume <var>O</var> is an ECMAScript proxy object, <var>P</var> is a <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key value</a>, <var>V</var> is any <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript
      language value</a> and <span style="font-family: Times New Roman">Desc</span> is a <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a> record.</p>
    </div>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-getprototypeof">
      <h3 id="sec-9.5.1" title="9.5.1"> [[GetPrototypeOf]] ( )</h3><p class="normalbefore">When the [[GetPrototypeOf]] internal method of a Proxy exotic object <var>O</var> is called the
      following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"getPrototypeOf"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[GetPrototypeOf]]().</li>
          </ol>
        </li>
        <li>Let <i>handlerProto</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>, <i>handler</i>,
            &laquo;<i>target</i>&raquo;).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>handlerProto</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handlerProto</i>) is neither Object nor Null, throw a
            <b>TypeError</b> exception.</li>
        <li>Let <i>extensibleTarget</i> be <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>target</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>extensibleTarget</i>).</li>
        <li>If <i>extensibleTarget</i> is <b>true</b>, return <i>handlerProto</i>.</li>
        <li>Let <i>targetProto</i> be <i>target</i>.[[GetPrototypeOf]]().</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetProto</i>).</li>
        <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>handlerProto</i>, <i>targetProto</i>) is <b>false</b>, throw a
            <b>TypeError</b> exception.</li>
        <li>Return <i>handlerProto</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[GetPrototypeOf]] for proxy objects enforces the following invariant:</p>

        <ul>
          <li>
            <p>The result of [[GetPrototypeOf]] must be either an Object or <b>null</b>.</p>
          </li>

          <li>
            <p>If the target object is not extensible, [[GetPrototypeOf]] applied to the proxy object must return the same value
            as [[GetPrototypeOf]] applied to the proxy object&rsquo;s target object.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-setprototypeof-v">
      <h3 id="sec-9.5.2" title="9.5.2"> [[SetPrototypeOf]] (V)</h3><p class="normalbefore">When the [[SetPrototypeOf]] internal method of a Proxy exotic object <var>O</var> is called with
      argument <var>V</var> the following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: Either <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>V</i>) is Object or <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>V</i>) is Null.</li>
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"setPrototypeOf"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[SetPrototypeOf]](<i>V</i>).</li>
          </ol>
        </li>
        <li>Let <i>booleanTrapResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>,
            <i>handler</i>, &laquo;<i>target</i>, <i>V</i>&raquo;)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>booleanTrapResult</i>).</li>
        <li>Let <i>extensibleTarget</i> be <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>target</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>extensibleTarget</i>).</li>
        <li>If <i>extensibleTarget</i> is <b>true</b>, return <i>booleanTrapResult</i>.</li>
        <li>Let <i>targetProto</i> be <i>target</i>.[[GetPrototypeOf]]().</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetProto</i>).</li>
        <li>If <i>booleanTrapResult</i> is <b>true</b> and <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>V</i>, <i>targetProto</i>) is
            <b>false</b>, throw a <b>TypeError</b> exception.</li>
        <li>Return <i>booleanTrapResult</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[SetPrototypeOf]] for proxy objects enforces the following invariant:</p>

        <ul>
          <li>
            <p>The result of [[SetPrototypeOf]] is a Boolean value.</p>
          </li>

          <li>
            <p>If the target object is not extensible, the argument value must be the same as the result of [[GetPrototypeOf]]
            applied to target object.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-isextensible">
      <h3 id="sec-9.5.3" title="9.5.3"> [[IsExtensible]] ( )</h3><p class="normalbefore">When the [[IsExtensible]] internal method of a Proxy exotic object <var>O</var> is called the
      following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"isExtensible"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[IsExtensible]]().</li>
          </ol>
        </li>
        <li>Let <i>booleanTrapResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>,
            <i>handler</i>, &laquo;<i>target</i>&raquo;)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>booleanTrapResult</i>).</li>
        <li>Let <i>targetResult</i> be <i>target</i>.[[IsExtensible]]().</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetResult</i>).</li>
        <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>booleanTrapResult</i>, <i>targetResult</i>) is <b>false</b>, throw a
            <b>TypeError</b> exception.</li>
        <li>Return <i>booleanTrapResult</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[IsExtensible]] for proxy objects enforces the following invariant:</p>

        <ul>
          <li>
            <p>The result of [[IsExtensible]] is a Boolean value.</p>
          </li>

          <li>
            <p>[[IsExtensible]] applied to the proxy object must return the same value as [[IsExtensible]] applied to the proxy
            object&rsquo;s target object with the same argument.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-preventextensions">
      <h3 id="sec-9.5.4" title="9.5.4"> [[PreventExtensions]] ( )</h3><p class="normalbefore">When the [[PreventExtensions]] internal method of a Proxy exotic object <var>O</var> is called the
      following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"preventExtensions"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[PreventExtensions]]().</li>
          </ol>
        </li>
        <li>Let <i>booleanTrapResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>,
            <i>handler</i>, &laquo;<i>target</i>&raquo;)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>booleanTrapResult</i>).</li>
        <li>If <i>booleanTrapResult</i> is <b>true</b>, then
          <ol class="block">
            <li>Let <i>targetIsExtensible</i> be <i>target</i>.[[IsExtensible]]().</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetIsExtensible</i>).</li>
            <li>If <i>targetIsExtensible</i> is <b>true</b>, throw a <b>TypeError</b> exception.</li>
          </ol>
        </li>
        <li>Return <i>booleanTrapResult</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[PreventExtensions]] for proxy objects enforces the following invariant:</p>

        <ul>
          <li>
            <p>The result of [[PreventExtensions]] is a Boolean value.</p>
          </li>

          <li>
            <p>[[PreventExtensions]] applied to the proxy object only returns <b>true</b> if [[IsExtensible]] applied to the proxy
            object&rsquo;s target object is <b>false</b>.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-getownproperty-p">
      <h3 id="sec-9.5.5" title="9.5.5"> [[GetOwnProperty]] (P)</h3><p class="normalbefore">When the [[GetOwnProperty]] internal method of a Proxy exotic object <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>,
            <code>"getOwnPropertyDescriptor"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[GetOwnProperty]](<i>P</i>).</li>
          </ol>
        </li>
        <li>Let <i>trapResultObj</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>, <i>handler</i>, &laquo;<i>target</i>,
            <i>P</i>&raquo;).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trapResultObj</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>trapResultObj</i>) is neither Object nor Undefined,
            throw a <b>TypeError</b> exception.</li>
        <li>Let <i>targetDesc</i> be <i>target</i>.[[GetOwnProperty]](<i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetDesc</i>).</li>
        <li>If <i>trapResultObj</i> is <b>undefined</b>, then
          <ol class="block">
            <li>If <i>targetDesc</i> is <b>undefined</b>, return <b>undefined</b>.</li>
            <li>If <i>targetDesc</i>.[[Configurable]] is <b>false</b>, throw a <b>TypeError</b> exception.</li>
            <li>Let <i>extensibleTarget</i> be <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>target</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>extensibleTarget</i>).</li>
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>extensibleTarget</i>) is Boolean.</li>
            <li>If <i>extensibleTarget</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
            <li>Return <b>undefined</b>.</li>
          </ol>
        </li>
        <li>Let <i>extensibleTarget</i> be <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>target</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>extensibleTarget</i>).</li>
        <li>Let <i>resultDesc</i> be <a href="sec-ecmascript-data-types-and-values#sec-topropertydescriptor">ToPropertyDescriptor</a>(<i>trapResultObj</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>resultDesc</i>).</li>
        <li><a href="sec-abstract-operations#sec-call">Call</a> <a href="sec-ecmascript-data-types-and-values#sec-completepropertydescriptor">CompletePropertyDescriptor</a>(<i>resultDesc</i>).</li>
        <li>Let <i>valid</i> be <a href="#sec-iscompatiblepropertydescriptor">IsCompatiblePropertyDescriptor</a>
            (<i>extensibleTarget</i>, <i>resultDesc</i>, <i>targetDesc</i>).</li>
        <li>If <i>valid</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
        <li>If <i>resultDesc</i>.[[Configurable]] is <b>false</b>, then
          <ol class="block">
            <li>If <i>targetDesc</i> is <b>undefined</b> or <i>targetDesc</i>.[[Configurable]] is <b>true</b><i>,</i> then
              <ol class="block">
                <li>Throw a <b>TypeError</b> exception.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Return <i>resultDesc</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[GetOwnProperty]] for proxy objects enforces the following invariants:</p>

        <ul>
          <li>
            <p>The result of [[GetOwnProperty]] must be either an Object or <b>undefined</b>.</p>
          </li>

          <li>
            <p>A property cannot be reported as non-existent, if it exists as a non-configurable own property of the target
            object.</p>
          </li>

          <li>
            <p>A property cannot be reported as non-existent, if it exists as an own property of the target object and the target
            object is not extensible.</p>
          </li>

          <li>
            <p>A property cannot be reported as existent, if it does not exists as an own property of the target object and the
            target object is not extensible.</p>
          </li>

          <li>
            <p>A property cannot be reported as non-configurable, if it does not exists as an own property of the target object or
            if it exists as a configurable own property of the target object.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-defineownproperty-p-desc">
      <h3 id="sec-9.5.6" title="9.5.6"> [[DefineOwnProperty]] (P, Desc)</h3><p class="normalbefore">When the [[DefineOwnProperty]] internal method of a Proxy exotic object <var>O</var> is called with
      <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> and <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property
      Descriptor</a> <span class="nt">Desc</span>, the following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"defineProperty"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[DefineOwnProperty]](<i>P</i>, <i>Desc</i>).</li>
          </ol>
        </li>
        <li>Let <i>descObj</i> be <a href="sec-ecmascript-data-types-and-values#sec-frompropertydescriptor">FromPropertyDescriptor</a>(<i>Desc</i>).</li>
        <li>Let <i>booleanTrapResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>,
            <i>handler</i>, &laquo;<i>target</i>, <i>P</i>, <i>descObj</i>&raquo;)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>booleanTrapResult</i>).</li>
        <li>If <i>booleanTrapResult</i> is <b>false</b>, return <b>false</b>.</li>
        <li>Let <i>targetDesc</i> be <i>target</i>.[[GetOwnProperty]](<i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetDesc</i>).</li>
        <li>Let <i>extensibleTarget</i> be <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>target</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>extensibleTarget</i>).</li>
        <li>If <i>Desc</i> has a [[Configurable]] field and if <i>Desc</i>.[[Configurable]] is <b>false,</b> then
          <ol class="block">
            <li>Let <i>settingConfigFalse</i> be <b>true</b>.</li>
          </ol>
        </li>
        <li>Else let <i>settingConfigFalse</i> be <b>false</b>.</li>
        <li>If <i>targetDesc</i> is <b>undefined</b>, then
          <ol class="block">
            <li>If <i>extensibleTarget</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
            <li>If <i>settingConfigFalse</i> is <b>true</b>, throw a <b>TypeError</b> exception.</li>
          </ol>
        </li>
        <li>Else <i>targetDesc</i> is not <b>undefined<i>,</i></b>
          <ol class="block">
            <li>If <a href="#sec-iscompatiblepropertydescriptor">IsCompatiblePropertyDescriptor</a>(<i>extensibleTarget</i>,
                <i>Desc</i> , <i>targetDesc</i>) is <b>false</b>, throw a <b>TypeError</b> exception.</li>
            <li>If <i>settingConfigFalse</i> is <b>true</b> and <i>targetDesc</i>.[[Configurable]] is <b>true</b>, throw a
                <b>TypeError</b> exception.</li>
          </ol>
        </li>
        <li>Return <b>true</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[DefineOwnProperty]] for proxy objects enforces the following invariants:</p>

        <ul>
          <li>
            <p>The result of [[DefineOwnProperty]] is a Boolean value.</p>
          </li>

          <li>
            <p>A property cannot be added, if the target object is not extensible.</p>
          </li>

          <li>
            <p>A property cannot be non-configurable, unless there exists a corresponding non-configurable own property of the
            target object.</p>
          </li>

          <li>
            <p>If a property has a corresponding target object property then applying the <a href="sec-ecmascript-data-types-and-values#sec-property-descriptor-specification-type">Property Descriptor</a> of the property to the target object using
            [[DefineOwnProperty]] will not throw an exception.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-hasproperty-p">
      <h3 id="sec-9.5.7" title="9.5.7"> [[HasProperty]] (P)</h3><p class="normalbefore">When the [[HasProperty]] internal method of a Proxy exotic object <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, the following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"has"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[HasProperty]](<i>P</i>).</li>
          </ol>
        </li>
        <li>Let <i>booleanTrapResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>,
            <i>handler</i>, &laquo;<i>target</i>, <i>P</i>&raquo;)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>booleanTrapResult</i>).</li>
        <li>If <i>booleanTrapResult</i> is <b>false</b>, then
          <ol class="block">
            <li>Let <i>targetDesc</i> be <i>target</i>.[[GetOwnProperty]](<i>P</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetDesc</i>).</li>
            <li>If <i>targetDesc</i> is not <b>undefined</b>, then
              <ol class="block">
                <li>If <i>targetDesc</i>.[[Configurable]] is <b>false</b>, throw a <b>TypeError</b> exception.</li>
                <li>Let <i>extensibleTarget</i> be <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>target</i>).</li>
                <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>extensibleTarget</i>).</li>
                <li>If <i>extensibleTarget</i> is <b>false</b>, throw a <b>TypeError</b> exception.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Return <i>booleanTrapResult</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[HasProperty]] for proxy objects enforces the following invariants:</p>

        <ul>
          <li>
            <p>The result of [[HasProperty]] is a Boolean value.</p>
          </li>

          <li>
            <p>A property cannot be reported as non-existent, if it exists as a non-configurable own property of the target
            object.</p>
          </li>

          <li>
            <p>A property cannot be reported as non-existent, if it exists as an own property of the target object and the target
            object is not extensible.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-get-p-receiver">
      <h3 id="sec-9.5.8" title="9.5.8"> [[Get]] (P, Receiver)</h3><p class="normalbefore">When the [[Get]] internal method of a Proxy exotic object <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language
      value</a> <span class="nt">Receiver</span> the following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"get"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[Get]](<i>P</i>, <i>Receiver</i>).</li>
          </ol>
        </li>
        <li>Let <i>trapResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>, <i>handler</i>, &laquo;<i>target</i>, <i>P</i>,
            <i>Receiver</i>&raquo;).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trapResult</i>).</li>
        <li>Let <i>targetDesc</i> be <i>target</i>.[[GetOwnProperty]](<i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetDesc</i>).</li>
        <li>If <i>targetDesc</i> is not <b>undefined</b>, then
          <ol class="block">
            <li>If <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>targetDesc</i>) and <i>targetDesc</i>.[[Configurable]]
                is <b>false</b> and <i>targetDesc</i>.[[Writable]] is <b>false</b>, then
              <ol class="block">
                <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>trapResult</i>, <i>targetDesc</i>.[[Value]]) is <b>false</b>,
                    throw a <b>TypeError</b> exception.</li>
              </ol>
            </li>
            <li>If <a href="sec-ecmascript-data-types-and-values#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>targetDesc</i>) and
                <i>targetDesc</i>.[[Configurable]] is <b>false</b> and <i>targetDesc</i>.[[Get]] is <b>undefined</b>, then
              <ol class="block">
                <li>If <i>trapResult</i> is not <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Return <i>trapResult</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[Get]] for proxy objects enforces the following invariants:</p>

        <ul>
          <li>
            <p>The value reported for a property must be the same as the value of the corresponding target object property if the
            target object property is a non-writable, non-configurable own data property.</p>
          </li>

          <li>
            <p>The value reported for a property must be <span class="value">undefined</span> if the corresponding target object
            property is a non-configurable own accessor property that has <span class="value">undefined</span> as its [[Get]]
            attribute.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-set-p-v-receiver">
      <h3 id="sec-9.5.9" title="9.5.9"> [[Set]] ( P, V, Receiver)</h3><p class="normalbefore">When the [[Set]] internal method of a Proxy exotic object <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var>, value <var>V</var>, and <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language value</a> <span class="nt">Receiver</span>, the following steps
      are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"set"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[Set]](<i>P</i>, <i>V</i>, <i>Receiver</i>).</li>
          </ol>
        </li>
        <li>Let <i>booleanTrapResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>,
            <i>handler</i>, &laquo;<i>target</i>, <i>P</i>, <i>V</i>, <i>Receiver</i>&raquo;)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>booleanTrapResult</i>).</li>
        <li>If <i>booleanTrapResult</i> is <b>false</b>, return <b>false</b>.</li>
        <li>Let <i>targetDesc</i> be <i>target</i>.[[GetOwnProperty]](<i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetDesc</i>).</li>
        <li>If <i>targetDesc</i> is not <b>undefined</b>, then
          <ol class="block">
            <li>If <a href="sec-ecmascript-data-types-and-values#sec-isdatadescriptor">IsDataDescriptor</a>(<i>targetDesc</i>) and <i>targetDesc</i>.[[Configurable]]
                is <b>false</b> and <i>targetDesc</i>.[[Writable]] is <b>false</b>, then
              <ol class="block">
                <li>If <a href="sec-abstract-operations#sec-samevalue">SameValue</a>(<i>V</i>, <i>targetDesc</i>.[[Value]]) is <b>false</b>, throw a
                    <b>TypeError</b> exception.</li>
              </ol>
            </li>
            <li>If <a href="sec-ecmascript-data-types-and-values#sec-isaccessordescriptor">IsAccessorDescriptor</a>(<i>targetDesc</i>) and
                <i>targetDesc</i>.[[Configurable]] is <b>false</b>, then
              <ol class="block">
                <li>If <i>targetDesc</i>.[[Set]] is <b>undefined</b>, throw a <b>TypeError</b> exception.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Return <b>true</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[Set]] for proxy objects enforces the following invariants:</p>

        <ul>
          <li>
            <p>The result of [[Set]] is a Boolean value.</p>
          </li>

          <li>
            <p>Cannot change the value of a property to be different from the value of the corresponding target object property if
            the corresponding target object property is a non-writable, non-configurable own data property.</p>
          </li>

          <li>
            <p>Cannot set the value of a property if the corresponding target object property is a non-configurable own accessor
            property that has <span class="value">undefined</span> as its [[Set]] attribute.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-delete-p">
      <h3 id="sec-9.5.10" title="9.5.10"> [[Delete]] (P)</h3><p class="normalbefore">When the [[Delete]] internal method of a Proxy exotic object <var>O</var> is called with <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> <var>P</var> the following steps are taken:</p>

      <ol class="proc">
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-abstract-operations#sec-ispropertykey">IsPropertyKey</a>(<i>P</i>) is
            <b>true</b>.</li>
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"deleteProperty"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[Delete]](<i>P</i>).</li>
          </ol>
        </li>
        <li>Let <i>booleanTrapResult</i> be <a href="sec-abstract-operations#sec-toboolean">ToBoolean</a>(<a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>,
            <i>handler</i>, &laquo;<i>target</i>, <i>P</i>&raquo;)).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>booleanTrapResult</i>).</li>
        <li>If <i>booleanTrapResult</i> is <b>false</b>, return <b>false</b>.</li>
        <li>Let <i>targetDesc</i> be <i>target</i>.[[GetOwnProperty]](<i>P</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetDesc</i>).</li>
        <li>If <i>targetDesc</i> is <b>undefined</b>, return <b>true</b>.</li>
        <li>If <i>targetDesc</i>.[[Configurable]] is <b>false</b>, throw a <b>TypeError</b> exception.</li>
        <li>Return <b>true</b>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[Delete]] for proxy objects enforces the following invariant:</p>

        <ul>
          <li>The result of [[Delete]] is a Boolean value.</li>
          <li>A property cannot be reported as deleted, if it exists as a non-configurable own property of the target object.</li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-enumerate">
      <h3 id="sec-9.5.11" title="9.5.11"> [[Enumerate]] ()</h3><p class="normalbefore">When the [[Enumerate]] internal method of a Proxy exotic object <var>O</var> is called the following
      steps are taken:</p>

      <ol class="proc">
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"enumerate"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[Enumerate]]().</li>
          </ol>
        </li>
        <li>Let <i>trapResult</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>, <i>handler</i>, &laquo;<i>target</i>&raquo;).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trapResult</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>trapResult</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Return <i>trapResult</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[Enumerate]] for proxy objects enforces the following invariants:</p>

        <ul>
          <li>The result of [[Enumerate]] must be an Object.</li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-ownpropertykeys">
      <h3 id="sec-9.5.12" title="9.5.12"> [[OwnPropertyKeys]] ( )</h3><p class="normalbefore">When the [[OwnPropertyKeys]] internal method of a Proxy exotic object <var>O</var> is called the
      following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"ownKeys"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <i>target</i>.[[OwnPropertyKeys]]().</li>
          </ol>
        </li>
        <li>Let <i>trapResultArray</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>, <i>handler</i>,
            &laquo;<i>target</i>&raquo;).</li>
        <li>Let <i>trapResult</i> be <a href="sec-abstract-operations#sec-createlistfromarraylike">CreateListFromArrayLike</a>(<i>trapResultArray</i>,
            &laquo;&zwj;String, Symbol&raquo;).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trapResult</i>).</li>
        <li>Let <i>extensibleTarget</i> be <a href="sec-abstract-operations#sec-isextensible-o">IsExtensible</a>(<i>target</i>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>extensibleTarget</i>).</li>
        <li>Let <i>targetKeys</i> be <i>target</i>.[[OwnPropertyKeys]]().</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>targetKeys</i>).</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>targetKeys</i> is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> containing only String and Symbol values.</li>
        <li>Let <i>targetConfigurableKeys</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Let <i>targetNonconfigurableKeys</i> be an empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</li>
        <li>Repeat, for each element <i>key</i> of <i>targetKeys</i>,
          <ol class="block">
            <li>Let <i>desc</i> be <i>target</i>.[[GetOwnProperty]](<i>key</i>).</li>
            <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>desc</i>).</li>
            <li>If <i>desc</i> is not <b>undefined</b> and <i>desc.</i>[[Configurable]] is <b>false</b>, then
              <ol class="block">
                <li>Append <i>key</i> as an element of <i>targetNonconfigurableKeys</i>.</li>
              </ol>
            </li>
            <li>Else,
              <ol class="block">
                <li>Append <i>key</i> as an element of <i>targetConfigurableKeys</i>.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>If <i>extensibleTarget</i> is <b>true</b> and <i>targetNonconfigurableKeys</i> is empty, then
          <ol class="block">
            <li>Return <i>trapResult</i>.</li>
          </ol>
        </li>
        <li>Let <i>uncheckedResultKeys</i> be a new <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> which is a copy of
            <i>trapResult</i>.</li>
        <li>Repeat, for each <i>key</i> that is an element of <i>targetNonconfigurableKeys</i>,
          <ol class="block">
            <li>If <i>key</i> is not an element of <i>uncheckedResultKeys</i>, throw a <b>TypeError</b> exception.</li>
            <li>Remove <i>key</i> from <i>uncheckedResultKeys</i></li>
          </ol>
        </li>
        <li>If <i>extensibleTarget</i> is <b>true</b>, return <i>trapResult</i>.</li>
        <li>Repeat, for each <i>key</i> that is an element of <i>targetConfigurableKeys</i>,
          <ol class="block">
            <li>If <i>key</i> is not an element of <i>uncheckedResultKeys</i>, throw a <b>TypeError</b> exception.</li>
            <li>Remove <i>key</i> from <i>uncheckedResultKeys</i></li>
          </ol>
        </li>
        <li>If <i>uncheckedResultKeys</i> is not empty, throw a <b>TypeError</b> exception.</li>
        <li>Return <i>trapResult</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> [[OwnPropertyKeys]] for proxy objects enforces the following invariants:</p>

        <ul>
          <li>
            <p>The result of [[OwnPropertyKeys]] is a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>.</p>
          </li>

          <li>
            <p>The Type of each result <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> element is either String or
            Symbol.</p>
          </li>

          <li>
            <p>The result <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> must contain the keys of all non-configurable
            own properties of the target object.</p>
          </li>

          <li>
            <p>If the target object is not extensible, then the result <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a>
            must contain all the keys of the own properties of the target object and no other values.</p>
          </li>
        </ul>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-call-thisargument-argumentslist">
      <h3 id="sec-9.5.13" title="9.5.13"> [[Call]] (thisArgument, argumentsList)</h3><p class="normalbefore">The [[Call]] internal method of a Proxy exotic object <var>O</var> is called with parameters
      <var>thisArgument</var> and <var>argumentsList</var>, a <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a>. The following steps are taken:</p>

      <ol class="proc">
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"apply"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>target</i>, <i>thisArgument</i>, <i>argumentsList</i>).</li>
          </ol>
        </li>
        <li>Let <i>argArray</i> be <a href="sec-abstract-operations#sec-createarrayfromlist">CreateArrayFromList</a>(<i>argumentsList</i>).</li>
        <li>Return <a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>, <i>handler</i>, &laquo;<i>target</i>, <i>thisArgument</i>,
            <i>argArray</i>&raquo;).</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE</span> A Proxy exotic object only has a [[Call]] internal method if the initial value of its
        [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is an object that has a
        [[Call]] internal method.</p>
      </div>
    </section>

    <section id="sec-proxy-object-internal-methods-and-internal-slots-construct-argumentslist-newtarget">
      <h3 id="sec-9.5.14" title="9.5.14"> [[Construct]] ( argumentsList, newTarget)</h3><p class="normalbefore">The [[Construct]] internal method of a Proxy exotic object <var>O</var> is called with parameters
      <var>argumentsList</var> which is a possibly empty <a href="sec-ecmascript-data-types-and-values#sec-list-and-record-specification-type">List</a> of <a href="sec-ecmascript-data-types-and-values#sec-ecmascript-language-types">ECMAScript language values</a> and <var>newTarget</var>. The following steps are
      taken:</p>

      <ol class="proc">
        <li>Let <i>handler</i> be the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>If <i>handler</i> is <b>null</b>, throw a <b>TypeError</b> exception.</li>
        <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is Object.</li>
        <li>Let <i>target</i> be the value of the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>O</i>.</li>
        <li>Let <i>trap</i> be <a href="sec-abstract-operations#sec-getmethod">GetMethod</a>(<i>handler</i>, <code>"construct"</code>).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>trap</i>).</li>
        <li>If <i>trap</i> is <b>undefined</b>, then
          <ol class="block">
            <li><a href="sec-notational-conventions#sec-algorithm-conventions">Assert</a>: <i>target</i> has a [[Construct]] internal method.</li>
            <li>Return <a href="sec-abstract-operations#sec-construct">Construct</a>(<i>target</i>, <i>argumentsList</i>, <i>newTarget</i>).</li>
          </ol>
        </li>
        <li>Let <i>argArray</i> be <a href="sec-abstract-operations#sec-createarrayfromlist">CreateArrayFromList</a>(<i>argumentsList</i>).</li>
        <li>Let <i>newObj</i> be <a href="sec-abstract-operations#sec-call">Call</a>(<i>trap</i>, <i>handler</i>, &laquo;<i>target</i>, <i>argArray</i>,
            <i>newTarget</i> &raquo;).</li>
        <li><a href="sec-ecmascript-data-types-and-values#sec-returnifabrupt">ReturnIfAbrupt</a>(<i>newObj</i>).</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>newObj</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>Return <i>newObj</i>.</li>
      </ol>

      <div class="note">
        <p><span class="nh">NOTE 1</span> A Proxy exotic object only has a [[Construct]] internal method if the initial value of
        its [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> is an object that has a
        [[Construct]] internal method.</p>
      </div>

      <div class="note">
        <p><span class="nh">NOTE 2</span> [[Construct]] for proxy objects enforces the following invariants:</p>

        <ul>
          <li>The result of [[Construct]] must be an Object.</li>
        </ul>
      </div>
    </section>

    <section id="sec-proxycreate">
      <h3 id="sec-9.5.15" title="9.5.15">
          ProxyCreate(target, handler)</h3><p class="normalbefore">The abstract operation ProxyCreate with arguments <var>target</var> and <var>handler</var> is used
      to specify the creation of new Proxy exotic objects. It performs the following steps:</p>

      <ol class="proc">
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>target</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>If <i>target</i> is a Proxy exotic object and the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>target</i> is <b>null</b>, throw a
            <b>TypeError</b> exception.</li>
        <li>If <a href="sec-ecmascript-data-types-and-values">Type</a>(<i>handler</i>) is not Object, throw a <b>TypeError</b>
            exception.</li>
        <li>If <i>handler</i> is a Proxy exotic object and the value of the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>handler</i> is <b>null</b>, throw a
            <b>TypeError</b> exception.</li>
        <li>Let <i>P</i> be a newly created object.</li>
        <li>Set <i>P</i>&rsquo;s essential internal methods (except for [[Call]] and [[Construct]]) to the definitions specified
            in <a href="#sec-proxy-object-internal-methods-and-internal-slots">9.5</a>.</li>
        <li>If <a href="sec-abstract-operations#sec-iscallable">IsCallable</a>(<i>target</i>) is <b>true</b>, then
          <ol class="block">
            <li>Set the [[Call]] internal method of <i>P</i> as specified in <a href="#sec-proxy-object-internal-methods-and-internal-slots-call-thisargument-argumentslist">9.5.13</a>.</li>
            <li>If <i>target</i> has a [[Construct]] internal method, then
              <ol class="block">
                <li>Set the [[Construct]] internal method of <i>P</i> as specified in <a href="#sec-proxy-object-internal-methods-and-internal-slots-construct-argumentslist-newtarget">9.5.14</a>.</li>
              </ol>
            </li>
          </ol>
        </li>
        <li>Set the [[ProxyTarget]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>P</i> to
            <i>target</i>.</li>
        <li>Set the [[ProxyHandler]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of <i>P</i> to
            <i>handler</i>.</li>
        <li>Return <i>P</i>.</li>
      </ol>
    </section>
  </section>
</section>

