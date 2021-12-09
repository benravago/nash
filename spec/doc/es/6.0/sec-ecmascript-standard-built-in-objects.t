<section id="sec-ecmascript-standard-built-in-objects">
  <h1 id="sec-17" title="17"> ECMAScript Standard Built-in Objects</h1><p>There are certain built-in objects available whenever an ECMAScript <span class="nt">Script</span> or <span class="nt">Module</span> begins execution. One, the global object, is part of the <a href="sec-executable-code-and-execution-contexts#sec-lexical-environments">lexical
  environment</a> of the executing program. Others are accessible as initial properties of the global object or indirectly as
  properties of accessible built-in objects.</p>

  <p>Unless specified otherwise, a built-in object that is callable as a function is a built-in Function object with the
  characteristics described in <a href="sec-ordinary-and-exotic-objects-behaviours#sec-built-in-function-objects">9.3</a>. Unless specified otherwise, the [[Extensible]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> of a built-in object initially has the value
  <b>true</b>. Every built-in Function object has a [[Realm]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal
  slot</a> whose value is the code <a href="sec-executable-code-and-execution-contexts#sec-code-realms">Realm</a> for which the object was initially created.</p>

  <p>Many built-in objects are functions: they can be invoked with arguments. Some of them furthermore are constructors: they are
  functions intended for use with the <code>new</code> operator. For each built-in function, this specification describes the
  arguments required by that function and the properties of that function object. For each built-in constructor, this
  specification furthermore describes properties of the prototype object of that constructor and properties of specific object
  instances returned by a <code>new</code> expression that invokes that constructor.</p>

  <p>Unless otherwise specified in the description of a particular function, if a built-in function or constructor is given fewer
  arguments than the function is specified to require, the function or constructor shall behave exactly as if it had been given
  sufficient additional arguments, each such argument being the <b>undefined</b> value. Such missing arguments are considered to
  be &ldquo;not present&rdquo; and may be identified in that manner by specification algorithms. In the description of a
  particular function, the terms &ldquo;<code>this</code> <span style="font-family: Times New Roman">value</span>&rdquo; and
  &ldquo;<span style="font-family: Times New Roman">NewTarget</span>&rdquo; have the meanings given in <a href="sec-ordinary-and-exotic-objects-behaviours#sec-built-in-function-objects">9.3</a>.</p>

  <p>Unless otherwise specified in the description of a particular function, if a built-in function or constructor described is
  given more arguments than the function is specified to allow, the extra arguments are evaluated by the call and then ignored by
  the function. However, an implementation may define implementation specific behaviour relating to such arguments as long as the
  behaviour is not the throwing of a <b>TypeError</b> exception that is predicated simply on the presence of an extra
  argument.</p>

  <div class="note">
    <p><span class="nh">NOTE 1</span> Implementations that add additional capabilities to the set of built-in functions are
    encouraged to do so by adding new functions rather than adding new parameters to existing functions.</p>
  </div>

  <p>Unless otherwise specified every built-in function and every built-in constructor has the Function prototype object, which is
  the initial value of the expression <code>Function.prototype</code> (<a href="sec-fundamental-objects#sec-properties-of-the-function-prototype-object">19.2.3</a>), as the value of its [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>.</p>

  <p>Unless otherwise specified every built-in prototype object has the Object prototype object, which is the initial value of the
  expression <code>Object.prototype</code> (<a href="sec-fundamental-objects#sec-properties-of-the-object-prototype-object">19.1.3</a>), as the value of
  its [[Prototype]] <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a>, except the Object prototype
  object itself.</p>

  <p>Built-in function objects that are not identified as constructors do not implement the [[Construct]] internal method unless
  otherwise specified in the description of a particular function.</p>

  <p>Unless otherwise specified, each built-in function defined in this specification is created as if by calling the <a href="sec-ordinary-and-exotic-objects-behaviours#sec-createbuiltinfunction">CreateBuiltinFunction</a> abstract operation (<a href="sec-ordinary-and-exotic-objects-behaviours#sec-createbuiltinfunction">9.3.3</a>).</p>

  <p>Every built-in Function object, including constructors, has a <code>length</code> property whose value is an integer. Unless
  otherwise specified, this value is equal to the largest number of named arguments shown in the subclause headings for the
  function description, including optional parameters. However, rest parameters shown using the form &ldquo;...name&rdquo; are not
  included in the default argument count.</p>

  <div class="note">
    <p><span class="nh">NOTE 2</span> For example, the function object that is the initial value of the <code>slice</code>
    property of the String prototype object is described under the subclause heading &ldquo;<a href="sec-text-processing#sec-string.prototype.slice">String.prototype.slice</a> (start, end)&rdquo; which shows the two named arguments start
    and end; therefore the value of the <code>length</code> property of that Function object is <code>2</code>.</p>
  </div>

  <p>Unless otherwise specified, the <code>length</code> property of a built-in Function object has the attributes
  {&nbsp;[[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>true</b> }.</p>

  <p>Every built-in Function object, including constructors, that is not identified as an anonymous function has a
  <code>name</code> property whose value is a String. Unless otherwise specified, this value is the name that is given to the
  function in this specification. For functions that are specified as properties of objects, the name value is the property name
  string used to access the function. Functions that are specified as get or set accessor functions of built-in properties have
  <code>"get "</code> or <code>"set "</code> prepended to the property name string. The value of the <code>name</code> property is
  explicitly specified for each built-in functions whose <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a> is a Symbol value.</p>

  <p>Unless otherwise specified, the <code>name</code> property of a built-in Function object, if it exists,  has the attributes
  {&nbsp;[[Writable]]: <b>false</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>true</b> }.</p>

  <p>Every other data property described in clauses 18 through 26 and in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-additional-built-in-properties">Annex B.2</a> has the attributes {
  [[Writable]]: <b>true</b>, [[Enumerable]]: <b>false</b>, [[Configurable]]: <b>true</b> } unless otherwise specified.</p>

  <p>Every accessor property described in clauses 18 through 26 and in <a href="sec-additional-ecmascript-features-for-web-browsers#sec-additional-built-in-properties">Annex B.2</a> has the attributes
  {[[Enumerable]]: <b>false</b>, [[Configurable]]: <b>true</b> } unless otherwise specified. If only a get accessor function is
  described, the set accessor function is the default value, <b>undefined</b>. If only a set accessor is described the get
  accessor is the default value, <b>undefined</b>.</p>
</section>

