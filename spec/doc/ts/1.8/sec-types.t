<section id="sec-types"><h1 id="types-3" title="3"> Types</h1><section id="user-content-3"><p>TypeScript adds optional static types to JavaScript. Types are used to place static constraints on program entities such as functions, variables, and properties so that compilers and development tools can offer better verification and assistance during software development. TypeScript's <em>static</em> compile-time type system closely models the <em>dynamic</em> run-time type system of JavaScript, allowing programmers to accurately express the type relationships that are expected to exist when their programs run and have those assumptions pre-validated by the TypeScript compiler. TypeScript's type analysis occurs entirely at compile-time and adds no run-time overhead to program execution.</p>
  <p>All types in TypeScript are subtypes of a single top type called the Any type. The <code>any</code> keyword references this type. The Any type is the one type that can represent <em>any</em> JavaScript value with no constraints. All other types are categorized as <em><strong>primitive types</strong></em>, <em><strong>object types</strong></em>, <em><strong>union types</strong></em>, <em><strong>intersection types</strong></em>, or <em><strong>type parameters</strong></em>. These types introduce various static constraints on their values.</p>
  <p>The primitive types are the Number, Boolean, String, Symbol, Void, Null, and Undefined types along with user defined enum types. The <code>number</code>, <code>boolean</code>, <code>string</code>, <code>symbol</code>, and <code>void</code> keywords reference the Number, Boolean, String, Symbol, and Void primitive types respectively. The Void type exists purely to indicate the absence of a value, such as in a function with no return value. It is not possible to explicitly reference the Null and Undefined types—only <em>values</em> of those types can be referenced, using the <code>null</code> and <code>undefined</code> literals.</p>
  <p>The object types are all class, interface, array, tuple, function, and constructor types. Class and interface types are introduced through class and interface declarations and are referenced by the name given to them in their declarations. Class and interface types may be <em><strong>generic types</strong></em> which have one or more type parameters.</p>
  <p>Union types represent values that have one of multiple types, and intersection types represent values that simultaneously have more than one type.</p>
  <p>Declarations of classes, properties, functions, variables and other language entities associate types with those entities. The mechanism by which a type is formed and associated with a language entity depends on the particular kind of entity. For example, a namespace declaration associates the namespace with an anonymous type containing a set of properties corresponding to the exported variables and functions in the namespace, and a function declaration associates the function with an anonymous type containing a call signature corresponding to the parameters and return type of the function. Types can be associated with variables through explicit <em><strong>type annotations</strong></em>, such as</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>or through implicit <em><strong>type inference</strong></em>, as in</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>which infers the type of 'x' to be the Number primitive type because that is the type of the value used to initialize 'x'.</p>
  </section><h2 id="the-any-type-31" title="3.1"> The Any Type</h2><section id="user-content-3.1"><p>The Any type is used to represent any JavaScript value. A value of the Any type supports the same operations as a value in JavaScript and minimal static type checking is performed for operations on Any values. Specifically, properties of any name can be accessed through an Any value and Any values can be called as functions or constructors with any argument list.</p>
  <p>The <code>any</code> keyword references the Any type. In general, in places where a type is not explicitly provided and TypeScript cannot infer one, the Any type is assumed.</p>
  <p>The Any type is a supertype of all types, and is assignable to and from all types.</p>
  <p>Some examples:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span>: <span class="pl-smi">any</span><span class="pl-kos">;</span>             <span class="pl-c">// Explicitly typed  </span>
  <span class="pl-k">var</span> <span class="pl-s1">y</span><span class="pl-kos">;</span>                  <span class="pl-c">// Same as y: any  </span>
  <span class="pl-k">var</span> <span class="pl-s1">z</span>: <span class="pl-kos">{</span> <span class="pl-c1">a</span><span class="pl-kos">;</span> <span class="pl-c1">b</span><span class="pl-kos">;</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>       <span class="pl-c">// Same as z: { a: any; b: any; }</span>
  
  <span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>         <span class="pl-c">// Same as f(x: any): void  </span>
      <span class="pl-smi">console</span><span class="pl-kos">.</span><span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><h2 id="primitive-types-32" title="3.2"> Primitive Types</h2><section id="user-content-3.2"><p>The primitive types are the Number, Boolean, String, Symbol, Void, Null, and Undefined types and all user defined enum types.</p>
  </section><h3 id="the-number-type-321" title="3.2.1"> The Number Type</h3><section id="user-content-3.2.1"><p>The Number primitive type corresponds to the similarly named JavaScript primitive type and represents double-precision 64-bit format IEEE 754 floating point values.</p>
  <p>The <code>number</code> keyword references the Number primitive type and numeric literals may be used to write values of the Number primitive type.</p>
  </section><p>For purposes of determining type relationships (section <a href="#type-relationships-311">3.11</a>) and accessing properties (section <a href="sec-expressions#property-access-413">4.13</a>), the Number primitive type behaves as an object type with the same properties as the global interface type 'Number'.</p>
  <p>Some examples:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>          <span class="pl-c">// Explicitly typed  </span>
  <span class="pl-k">var</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-c1">0</span><span class="pl-kos">;</span>              <span class="pl-c">// Same as y: number = 0  </span>
  <span class="pl-k">var</span> <span class="pl-s1">z</span> <span class="pl-c1">=</span> <span class="pl-c1">123.456</span><span class="pl-kos">;</span>        <span class="pl-c">// Same as z: number = 123.456  </span>
  <span class="pl-k">var</span> <span class="pl-s1">s</span> <span class="pl-c1">=</span> <span class="pl-s1">z</span><span class="pl-kos">.</span><span class="pl-en">toFixed</span><span class="pl-kos">(</span><span class="pl-c1">2</span><span class="pl-kos">)</span><span class="pl-kos">;</span>   <span class="pl-c">// Property of Number interface</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="the-boolean-type-322" title="3.2.2"> The Boolean Type</h3><section id="user-content-3.2.2"><p>The Boolean primitive type corresponds to the similarly named JavaScript primitive type and represents logical values that are either true or false.</p>
  <p>The <code>boolean</code> keyword references the Boolean primitive type and the <code>true</code> and <code>false</code> literals reference the two Boolean truth values.</p>
  </section><p>For purposes of determining type relationships (section <a href="#type-relationships-311">3.11</a>) and accessing properties (section <a href="sec-expressions#property-access-413">4.13</a>), the Boolean primitive type behaves as an object type with the same properties as the global interface type 'Boolean'.</p>
  <p>Some examples:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">b</span>: <span class="pl-smi">boolean</span><span class="pl-kos">;</span>         <span class="pl-c">// Explicitly typed  </span>
  <span class="pl-k">var</span> <span class="pl-s1">yes</span> <span class="pl-c1">=</span> <span class="pl-c1">true</span><span class="pl-kos">;</span>         <span class="pl-c">// Same as yes: boolean = true  </span>
  <span class="pl-k">var</span> <span class="pl-s1">no</span> <span class="pl-c1">=</span> <span class="pl-c1">false</span><span class="pl-kos">;</span>         <span class="pl-c">// Same as no: boolean = false</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="the-string-type-323" title="3.2.3"> The String Type</h3><section id="user-content-3.2.3"><p>The String primitive type corresponds to the similarly named JavaScript primitive type and represents sequences of characters stored as Unicode UTF-16 code units.</p>
  <p>The <code>string</code> keyword references the String primitive type and string literals may be used to write values of the String primitive type.</p>
  </section><p>For purposes of determining type relationships (section <a href="#type-relationships-311">3.11</a>) and accessing properties (section <a href="sec-expressions#property-access-413">4.13</a>), the String primitive type behaves as an object type with the same properties as the global interface type 'String'.</p>
  <p>Some examples:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">s</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>          <span class="pl-c">// Explicitly typed  </span>
  <span class="pl-k">var</span> <span class="pl-s1">empty</span> <span class="pl-c1">=</span> <span class="pl-s">""</span><span class="pl-kos">;</span>         <span class="pl-c">// Same as empty: string = ""  </span>
  <span class="pl-k">var</span> <span class="pl-s1">abc</span> <span class="pl-c1">=</span> <span class="pl-s">'abc'</span><span class="pl-kos">;</span>        <span class="pl-c">// Same as abc: string = "abc"  </span>
  <span class="pl-k">var</span> <span class="pl-s1">c</span> <span class="pl-c1">=</span> <span class="pl-s1">abc</span><span class="pl-kos">.</span><span class="pl-en">charAt</span><span class="pl-kos">(</span><span class="pl-c1">2</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Property of String interface</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="the-symbol-type-324" title="3.2.4"> The Symbol Type</h3><section id="user-content-3.2.4"><p>The Symbol primitive type corresponds to the similarly named JavaScript primitive type and represents unique tokens that may be used as keys for object properties.</p>
  </section><p><section id="user-content-3.2.4"><code>symbol</code> keyword references the Symbol primitive type. Symbol values are obtained using the global object 'Symbol' which has a number of methods and properties and can be invoked as a function. In particular, the global object 'Symbol' defines a number of well-known symbols (</section><a href="sec-basic-concepts#computed-property-names-223">2.2.3</a>) that can be used in a manner similar to identifiers. Note that the 'Symbol' object is available only in ECMAScript 2015 environments.</p>
  <p>For purposes of determining type relationships (section <a href="#type-relationships-311">3.11</a>) and accessing properties (section <a href="sec-expressions#property-access-413">4.13</a>), the Symbol primitive type behaves as an object type with the same properties as the global interface type 'Symbol'.</p>
  <p>Some examples:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">secretKey</span> <span class="pl-c1">=</span> <span class="pl-smi">Symbol</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">obj</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span><span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-s1">obj</span><span class="pl-kos">[</span><span class="pl-s1">secretKey</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-s">"secret message"</span><span class="pl-kos">;</span>  <span class="pl-c">// Use symbol as property key  </span>
  <span class="pl-s1">obj</span><span class="pl-kos">[</span><span class="pl-smi">Symbol</span><span class="pl-kos">.</span><span class="pl-c1">toStringTag</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-s">"test"</span><span class="pl-kos">;</span>   <span class="pl-c">// Use of well-known symbol</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="the-void-type-325" title="3.2.5"> The Void Type</h3><section id="user-content-3.2.5"><p>The Void type, referenced by the <code>void</code> keyword, represents the absence of a value and is used as the return type of functions with no return value.</p>
  <p>The only possible values for the Void type are <code>null</code> and <code>undefined</code>. The Void type is a subtype of the Any type and a supertype of the Null and Undefined types, but otherwise Void is unrelated to all other types.</p>
  <p><em>NOTE: We might consider disallowing declaring variables of type Void as they serve no useful purpose. However, because Void is permitted as a type argument to a generic type or function it is not feasible to disallow Void properties or parameters</em>.</p>
  </section><h3 id="the-null-type-326" title="3.2.6"> The Null Type</h3><section id="user-content-3.2.6"><p>The Null type corresponds to the similarly named JavaScript primitive type and is the type of the <code>null</code> literal.</p>
  <p>The <code>null</code> literal references the one and only value of the Null type. It is not possible to directly reference the Null type itself.</p>
  <p>The Null type is a subtype of all types, except the Undefined type. This means that <code>null</code> is considered a valid value for all primitive types, object types, union types, intersection types, and type parameters, including even the Number and Boolean primitive types.</p>
  <p>Some examples:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">n</span>: <span class="pl-smi">number</span> <span class="pl-c1">=</span> <span class="pl-c1">null</span><span class="pl-kos">;</span>   <span class="pl-c">// Primitives can be null  </span>
  <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">null</span><span class="pl-kos">;</span>           <span class="pl-c">// Same as x: any = null  </span>
  <span class="pl-k">var</span> <span class="pl-s1">e</span>: <span class="pl-smi">Null</span><span class="pl-kos">;</span>            <span class="pl-c">// Error, can't reference Null type</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><h3 id="the-undefined-type-327" title="3.2.7"> The Undefined Type</h3><section id="user-content-3.2.7"><p>The Undefined type corresponds to the similarly named JavaScript primitive type and is the type of the <code>undefined</code> literal.</p>
  <p>The <code>undefined</code> literal denotes the value given to all uninitialized variables and is the one and only value of the Undefined type. It is not possible to directly reference the Undefined type itself.</p>
  <p>The undefined type is a subtype of all types. This means that <code>undefined</code> is considered a valid value for all primitive types, object types, union types, intersection types, and type parameters.</p>
  <p>Some examples:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">n</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>          <span class="pl-c">// Same as n: number = undefined  </span>
  <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">undefined</span><span class="pl-kos">;</span>      <span class="pl-c">// Same as x: any = undefined  </span>
  <span class="pl-k">var</span> <span class="pl-s1">e</span>: <span class="pl-smi">Undefined</span><span class="pl-kos">;</span>       <span class="pl-c">// Error, can't reference Undefined type</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><h3 id="enum-types-328" title="3.2.8"> Enum Types</h3>
  <p>Enum types are distinct user defined subtypes of the Number primitive type. Enum types are declared using enum declarations (section <a href="sec-enums#enum-declarations-91">9.1</a>) and referenced using type references (section <a href="#type-references-382">3.8.2</a>).</p>
  <p>Enum types are assignable to the Number primitive type, and vice versa, but different enum types are not assignable to each other.</p>
  <h3 id="string-literal-types-329" title="3.2.9"> String Literal Types</h3>
  <p>Specialized signatures (section <a href="#specialized-signatures-3924">3.9.2.4</a>) permit string literals to be used as types in parameter type annotations. String literal types are permitted only in that context and nowhere else.</p>
  <p>All string literal types are subtypes of the String primitive type.</p>
  <p><em>TODO: Update to reflect <a href="https://github.com/Microsoft/TypeScript/pull/5185">expanded support for string literal types</a></em>.</p>
  <h2 id="object-types-33" title="3.3"> Object Types</h2><section id="user-content-3.3"><p>Object types are composed from properties, call signatures, construct signatures, and index signatures, collectively called members.</p>
  <p>Class and interface type references, array types, tuple types, function types, and constructor types are all classified as object types. Multiple constructs in the TypeScript language create object types, including:</p>
  </section><ul>
  <li>Object type literals (section <a href="#object-type-literals-383">3.8.3</a>).</li>
  <li>Array type literals (section <a href="#array-type-literals-384">3.8.4</a>).</li>
  <li>Tuple type literals (section <a href="#tuple-type-literals-385">3.8.5</a>).</li>
  <li>Function type literals (section <a href="#function-type-literals-388">3.8.8</a>).</li>
  <li>Constructor type literals (section <a href="#constructor-type-literals-389">3.8.9</a>).</li>
  <li>Object literals (section <a href="sec-expressions#object-literals-45">4.5</a>).</li>
  <li>Array literals (section <a href="sec-expressions#array-literals-46">4.6</a>).</li>
  <li>Function expressions (section <a href="sec-expressions#function-expressions-410">4.10</a>) and function declarations (<a href="sec-functions#function-declarations-61">6.1</a>).</li>
  <li>Constructor function types created by class declarations (section <a href="sec-classes#constructor-function-types-825">8.2.5</a>).</li>
  <li>Namespace instance types created by namespace declarations (section <a href="sec-namespaces#import-alias-declarations-103">10.3</a>).</li>
  </ul>
  <h3 id="named-type-references-331" title="3.3.1"> Named Type References</h3>
  <p>Type references (section <a href="#type-references-382">3.8.2</a>) to class and interface types are classified as object types. Type references to generic class and interface types include type arguments that are substituted for the type parameters of the class or interface to produce an actual object type.</p>
  <h3 id="array-types-332" title="3.3.2"> Array Types</h3>
  <p><section id="user-content-3.3.2"><em><strong>Array types</strong></em> represent JavaScript arrays with a common element type. Array types are named type references created from the generic interface type 'Array' in the global namespace with the array element type as a type argument. Array type literals (section </section><a href="#array-type-literals-384">3.8.4</a>) provide a shorthand notation for creating such references.</p>
  <p>The declaration of the 'Array' interface includes a property 'length' and a numeric index signature for the element type, along with other members:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Array</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">length</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-kos">[</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">]</span>: <span class="pl-smi">T</span><span class="pl-kos">;</span>  
      <span class="pl-c">// Other members  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Array literals (section <a href="sec-expressions#array-literals-46">4.6</a>) may be used to create values of array types. For example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">a</span>: <span class="pl-smi">string</span><span class="pl-kos">[</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-s">"hello"</span><span class="pl-kos">,</span> <span class="pl-s">"world"</span><span class="pl-kos">]</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>A type is said to be an <em><strong>array-like type</strong></em> if it is assignable (section <a href="#assignment-compatibility-3114">3.11.4</a>) to the type <code>any[]</code>.</p>
  <h3 id="tuple-types-333" title="3.3.3"> Tuple Types</h3>
  <p><section id="user-content-3.3.3"><em><strong>Tuple types</strong></em> represent JavaScript arrays with individually tracked element types. Tuple types are written using tuple type literals (section </section><a href="#tuple-type-literals-385">3.8.5</a>). A tuple type combines a set of numerically named properties with the members of an array type. Specifically, a tuple type</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">[</span> <span class="pl-smi">T0</span><span class="pl-kos">,</span> <span class="pl-smi">T1</span><span class="pl-kos">,</span> ...<span class="pl-kos">,</span> <span class="pl-smi">Tn</span> <span class="pl-kos">]</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>combines the set of properties</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">{</span>  
      <span class="pl-c1">0</span>: <span class="pl-smi">T0</span><span class="pl-kos">;</span>  
      <span class="pl-c1">1</span>: <span class="pl-smi">T1</span><span class="pl-kos">;</span>  
      ...  
      <span class="pl-s1">n</span>: <span class="pl-smi">Tn</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>with the members of an array type whose element type is the union type (section <a href="#union-types-34">3.4</a>) of the tuple element types.</p>
  <p>Array literals (section <a href="sec-expressions#array-literals-46">4.6</a>) may be used to create values of tuple types. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">t</span>: <span class="pl-kos">[</span><span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-smi">string</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">3</span><span class="pl-kos">,</span> <span class="pl-s">"three"</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">n</span> <span class="pl-c1">=</span> <span class="pl-s1">t</span><span class="pl-kos">[</span><span class="pl-c1">0</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  <span class="pl-c">// Type of n is number  </span>
  <span class="pl-k">var</span> <span class="pl-s1">s</span> <span class="pl-c1">=</span> <span class="pl-s1">t</span><span class="pl-kos">[</span><span class="pl-c1">1</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  <span class="pl-c">// Type of s is string  </span>
  <span class="pl-k">var</span> <span class="pl-s1">i</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">t</span><span class="pl-kos">[</span><span class="pl-s1">i</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  <span class="pl-c">// Type of x is number | string</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Named tuple types can be created by declaring interfaces that derive from Array&lt;T&gt; and introduce numerically named properties. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">KeyValuePair</span><span class="pl-c1">&lt;</span><span class="pl-smi">K</span><span class="pl-kos">,</span> <span class="pl-smi">V</span><span class="pl-c1">&gt;</span> <span class="pl-k">extends</span> <span class="pl-smi">Array</span><span class="pl-kos">&lt;</span><span class="pl-smi">K</span> <span class="pl-c1">|</span> <span class="pl-smi">V</span><span class="pl-kos">&gt;</span> <span class="pl-kos">{</span> <span class="pl-c1">0</span>: <span class="pl-smi">K</span><span class="pl-kos">;</span> <span class="pl-c1">1</span>: <span class="pl-smi">V</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">x</span>: <span class="pl-smi">KeyValuePair</span><span class="pl-kos">&lt;</span><span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-smi">string</span><span class="pl-kos">&gt;</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-s">"ten"</span><span class="pl-kos">]</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>A type is said to be a <em><strong>tuple-like type</strong></em> if it has a property with the numeric name '0'.</p>
  <h3 id="function-types-334" title="3.3.4"> Function Types</h3>
  <p><section id="user-content-3.3.4"><em><strong>function type</strong></em>. Function types may be written using function type literals (section </section><a href="#function-type-literals-388">3.8.8</a>) or by including call signatures in object type literals.</p>
  <h3 id="constructor-types-335" title="3.3.5"> Constructor Types</h3>
  <p><section id="user-content-3.3.5"><em><strong>constructor type</strong></em>. Constructor types may be written using constructor type literals (section </section><a href="#constructor-type-literals-389">3.8.9</a>) or by including construct signatures in object type literals.</p>
  <h3 id="members-336" title="3.3.6"> Members</h3><section id="user-content-3.3.6"><p>Every object type is composed from zero or more of the following kinds of members:</p>
  <ul>
  <li><em><strong>Properties</strong></em>, which define the names and types of the properties of objects of the given type. Property names are unique within their type.</li>
  <li><em><strong>Call signatures</strong></em>, which define the possible parameter lists and return types associated with applying call operations to objects of the given type.</li>
  <li><em><strong>Construct signatures</strong></em>, which define the possible parameter lists and return types associated with applying the <code>new</code> operator to objects of the given type.</li>
  <li><em><strong>Index signatures</strong></em>, which define type constraints for properties in the given type. An object type can have at most one string index signature and one numeric index signature.</li>
  </ul>
  <p>Properties are either <em><strong>public</strong></em>, <em><strong>private</strong></em>, or <em><strong>protected</strong></em> and are either <em><strong>required</strong></em> or <em><strong>optional</strong></em>:</p>
  </section><ul>
  <li>Properties in a class declaration may be designated public, private, or protected, while properties declared in other contexts are always considered public. Private members are only accessible within their declaring class, as described in section <a href="sec-classes#accessibility-822">8.2.2</a>, and private properties match only themselves in subtype and assignment compatibility checks, as described in section <a href="#type-relationships-311">3.11</a>. Protected members are only accessible within their declaring class and classes derived from it, as described in section <a href="sec-classes#accessibility-822">8.2.2</a>, and protected properties match only themselves and overrides in subtype and assignment compatibility checks, as described in section <a href="#type-relationships-311">3.11</a>.</li>
  <li>Properties in an object type literal or interface declaration may be designated required or optional, while properties declared in other contexts are always considered required. Properties that are optional in the target type of an assignment may be omitted from source objects, as described in section <a href="#assignment-compatibility-3114">3.11.4</a>.</li>
  </ul>
  <p>Call and construct signatures may be <em><strong>specialized</strong></em> (section <a href="#specialized-signatures-3924">3.9.2.4</a>) by including parameters with string literal types. Specialized signatures are used to express patterns where specific string values for some parameters cause the types of other parameters or the function result to become further specialized.</p>
  <h2 id="union-types-34" title="3.4"> Union Types</h2>
  <p><section id="user-content-3.4"><em><strong>Union types</strong></em> represent values that may have one of several distinct representations. A value of a union type <em>A</em> | <em>B</em> is a value that is <em>either</em> of type <em>A</em> or type <em>B</em>. Union types are written using union type literals (section </section><a href="#union-type-literals-386">3.8.6</a>).</p>
  <p>A union type encompasses an ordered set of constituent types. While it is generally true that <em>A</em> | <em>B</em> is equivalent to <em>B</em> | <em>A</em>, the order of the constituent types may matter when determining the call and construct signatures of the union type.</p>
  <p>Union types have the following subtype relationships:</p>
  <ul>
  <li>A union type <em>U</em> is a subtype of a type <em>T</em> if each type in <em>U</em> is a subtype of <em>T</em>.</li>
  <li>A type <em>T</em> is a subtype of a union type <em>U</em> if <em>T</em> is a subtype of any type in <em>U</em>.</li>
  </ul>
  <p>Similarly, union types have the following assignability relationships:</p>
  <ul>
  <li>A union type <em>U</em> is assignable to a type <em>T</em> if each type in <em>U</em> is assignable to <em>T</em>.</li>
  <li>A type <em>T</em> is assignable to a union type <em>U</em> if <em>T</em> is assignable to any type in <em>U</em>.</li>
  </ul>
  <p>The || and conditional operators (section <a href="sec-expressions#the--operator-4197">4.19.7</a> and <a href="sec-expressions#the-conditional-operator-420">4.20</a>) may produce values of union types, and array literals (section <a href="sec-expressions#array-literals-46">4.6</a>) may produce array values that have union types as their element types.</p>
  <p>Type guards (section <a href="sec-expressions#type-guards-424">4.24</a>) may be used to narrow a union type to a more specific type. In particular, type guards are useful for narrowing union type values to a non-union type values.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span>: <span class="pl-smi">string</span> <span class="pl-c1">|</span> <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">test</span>: <span class="pl-smi">boolean</span><span class="pl-kos">;</span>  
  <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s">"hello"</span><span class="pl-kos">;</span>            <span class="pl-c">// Ok  </span>
  <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">42</span><span class="pl-kos">;</span>                 <span class="pl-c">// Ok  </span>
  <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">test</span><span class="pl-kos">;</span>               <span class="pl-c">// Error, boolean not assignable  </span>
  <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">test</span> ? <span class="pl-c1">5</span> : <span class="pl-s">"five"</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok  </span>
  <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">test</span> ? <span class="pl-c1">0</span> : <span class="pl-c1">false</span><span class="pl-kos">;</span>   <span class="pl-c">// Error, number | boolean not assignable</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>it is possible to assign 'x' a value of type <code>string</code>, <code>number</code>, or the union type <code>string | number</code>, but not any other type. To access a value in 'x', a type guard can be used to first narrow the type of 'x' to either <code>string</code> or <code>number</code>:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">n</span> <span class="pl-c1">=</span> <span class="pl-k">typeof</span> <span class="pl-s1">x</span> <span class="pl-c1">===</span> <span class="pl-s">"string"</span> ? <span class="pl-s1">x</span><span class="pl-kos">.</span><span class="pl-c1">length</span> : <span class="pl-s1">x</span><span class="pl-kos">;</span>  <span class="pl-c">// Type of n is number</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>For purposes of property access and function calls, the apparent members (section <a href="#apparent-members-3111">3.11.1</a>) of a union type are those that are present in every one of its constituent types, with types that are unions of the respective apparent members in the constituent types. The following example illustrates the merging of member types that occurs when union types are created from object types.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">a</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-c1">b</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">B</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">a</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">b</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">c</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">x</span>: <span class="pl-smi">A</span> <span class="pl-c1">|</span> <span class="pl-smi">B</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">a</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span><span class="pl-kos">.</span><span class="pl-c1">a</span><span class="pl-kos">;</span>  <span class="pl-c">// a has type string | number  </span>
  <span class="pl-k">var</span> <span class="pl-s1">b</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span><span class="pl-kos">.</span><span class="pl-c1">b</span><span class="pl-kos">;</span>  <span class="pl-c">// b has type number  </span>
  <span class="pl-k">var</span> <span class="pl-s1">c</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span><span class="pl-kos">.</span><span class="pl-c1">c</span><span class="pl-kos">;</span>  <span class="pl-c">// Error, no property c in union type</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that 'x.a' has a union type because the type of 'a' is different in 'A' and 'B', whereas 'x.b' simply has type number because that is the type of 'b' in both 'A' and 'B'. Also note that there is no property 'x.c' because only 'B' has a property 'c'.</p>
  <p>When used as a contextual type (section <a href="sec-expressions#contextually-typed-expressions-423">4.23</a>), a union type has those members that are present in any of its constituent types, with types that are unions of the respective members in the constituent types. Specifically, a union type used as a contextual type has the apparent members defined in section <a href="#apparent-members-3111">3.11.1</a>, except that a particular member need only be present in one or more constituent types instead of all constituent types.</p>
  <h2 id="intersection-types-35" title="3.5"> Intersection Types</h2>
  <p><section id="user-content-3.5"><em><strong>Intersection types</strong></em> represent values that simultaneously have multiple types. A value of an intersection type <em>A</em> &amp; <em>B</em> is a value that is <em>both</em> of type <em>A</em> and type <em>B</em>. Intersection types are written using intersection type literals (section </section><a href="#intersection-type-literals-387">3.8.7</a>).</p>
  <p>An intersection type encompasses an ordered set of constituent types. While it is generally true that <em>A</em> &amp; <em>B</em> is equivalent to <em>B</em> &amp; <em>A</em>, the order of the constituent types may matter when determining the call and construct signatures of the intersection type.</p>
  <p>Intersection types have the following subtype relationships:</p>
  <ul>
  <li>An intersection type <em>I</em> is a subtype of a type <em>T</em> if any type in <em>I</em> is a subtype of <em>T</em>.</li>
  <li>A type <em>T</em> is a subtype of an intersection type <em>I</em> if <em>T</em> is a subtype of each type in <em>I</em>.</li>
  </ul>
  <p>Similarly, intersection types have the following assignability relationships:</p>
  <ul>
  <li>An intersection type <em>I</em> is assignable to a type <em>T</em> if any type in <em>I</em> is assignable to <em>T</em>.</li>
  <li>A type <em>T</em> is assignable to an intersection type <em>I</em> if <em>T</em> is assignable to each type in <em>I</em>.</li>
  </ul>
  <p>For purposes of property access and function calls, the apparent members (section <a href="#apparent-members-3111">3.11.1</a>) of an intersection type are those that are present in one or more of its constituent types, with types that are intersections of the respective apparent members in the constituent types. The following examples illustrate the merging of member types that occurs when intersection types are created from object types.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span> <span class="pl-c1">a</span>: <span class="pl-smi">number</span> <span class="pl-kos">}</span>  
  <span class="pl-k">interface</span> <span class="pl-smi">B</span> <span class="pl-kos">{</span> <span class="pl-c1">b</span>: <span class="pl-smi">number</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">ab</span>: <span class="pl-smi">A</span> <span class="pl-c1">&amp;</span> <span class="pl-smi">B</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">a</span>: <span class="pl-c1">1</span><span class="pl-kos">,</span> <span class="pl-c1">b</span>: <span class="pl-c1">1</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">a</span>: <span class="pl-smi">A</span> <span class="pl-c1">=</span> <span class="pl-s1">ab</span><span class="pl-kos">;</span>  <span class="pl-c">// A &amp; B assignable to A  </span>
  <span class="pl-k">var</span> <span class="pl-s1">b</span>: <span class="pl-smi">B</span> <span class="pl-c1">=</span> <span class="pl-s1">ab</span><span class="pl-kos">;</span>  <span class="pl-c">// A &amp; B assignable to B</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">X</span> <span class="pl-kos">{</span> <span class="pl-c1">p</span>: <span class="pl-smi">A</span> <span class="pl-kos">}</span>  
  <span class="pl-k">interface</span> <span class="pl-smi">Y</span> <span class="pl-kos">{</span> <span class="pl-c1">p</span>: <span class="pl-smi">B</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">xy</span>: <span class="pl-smi">X</span> <span class="pl-c1">&amp;</span> <span class="pl-smi">Y</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">p</span>: <span class="pl-s1">ab</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  <span class="pl-c">// X &amp; Y has property p of type A &amp; B</span>
  
  <span class="pl-k">type</span> <span class="pl-smi">F1</span> <span class="pl-c1">=</span> <span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-s1">b</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
  <span class="pl-k">type</span> <span class="pl-smi">F2</span> <span class="pl-c1">=</span> <span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">b</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>
  
  <span class="pl-k">var</span> <span class="pl-en">f</span>: <span class="pl-smi">F1</span> <span class="pl-c1">&amp;</span> <span class="pl-smi">F2</span> <span class="pl-c1">=</span> <span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">string</span> <span class="pl-c1">|</span> <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">b</span>: <span class="pl-smi">string</span> <span class="pl-c1">|</span> <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s">"hello"</span><span class="pl-kos">,</span> <span class="pl-s">"world"</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok  </span>
  <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-c1">1</span><span class="pl-kos">,</span> <span class="pl-c1">2</span><span class="pl-kos">)</span><span class="pl-kos">;</span>              <span class="pl-c">// Ok  </span>
  <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-c1">1</span><span class="pl-kos">,</span> <span class="pl-s">"test"</span><span class="pl-kos">)</span><span class="pl-kos">;</span>         <span class="pl-c">// Error</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The union and intersection type operators can be applied to type parameters. This capability can for example be used to model functions that merge objects:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">extend</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-smi">U</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">first</span>: <span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-s1">second</span>: <span class="pl-smi">U</span><span class="pl-kos">)</span>: <span class="pl-smi">T</span> <span class="pl-c1">&amp;</span> <span class="pl-smi">U</span> <span class="pl-kos">{</span>  
      <span class="pl-c">// Extend first with properties of second  </span>
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-en">extend</span><span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">a</span>: <span class="pl-s">"hello"</span> <span class="pl-kos">}</span><span class="pl-kos">,</span> <span class="pl-kos">{</span> <span class="pl-c1">b</span>: <span class="pl-c1">42</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">s</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span><span class="pl-kos">.</span><span class="pl-c1">a</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">n</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span><span class="pl-kos">.</span><span class="pl-c1">b</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>It is possible to create intersection types for which no values other than null or undefined are possible. For example, intersections of primitive types such as <code>string &amp; number</code> fall into this category.</p>
  <h2 id="type-parameters-36" title="3.6"> Type Parameters</h2><section id="user-content-3.6"><p>A type parameter represents an actual type that the parameter is bound to in a generic type reference or a generic function call. Type parameters have constraints that establish upper bounds for their actual type arguments.</p>
  <p>Since a type parameter represents a multitude of different type arguments, type parameters have certain restrictions compared to other types. In particular, a type parameter cannot be used as a base class or interface.</p>
  </section><h3 id="type-parameter-lists-361" title="3.6.1"> Type Parameter Lists</h3><section id="user-content-3.6.1"><p>Class, interface, type alias, and function declarations may optionally include lists of type parameters enclosed in &lt; and &gt; brackets. Type parameters are also permitted in call signatures of object, function, and constructor type literals.</p>
  <p>  <em>TypeParameters:</em><br />
     <code>&lt;</code> <em>TypeParameterList</em> <code>&gt;</code></p>
  <p>  <em>TypeParameterList:</em><br />
     <em>TypeParameter</em><br />
     <em>TypeParameterList</em> <code>,</code> <em>TypeParameter</em></p>
  <p>  <em>TypeParameter:</em><br />
     <em>BindingIdentifier</em> <em>Constraint<sub>opt</sub></em></p>
  <p>  <em>Constraint:</em><br />
     <code>extends</code> <em>Type</em></p>
  <p>Type parameter names must be unique. A compile-time error occurs if two or more type parameters in the same <em>TypeParameterList</em> have the same name.</p>
  <p>The scope of a type parameter extends over the entire declaration with which the type parameter list is associated, with the exception of static member declarations in classes.</p>
  <p>A type parameter may have an associated type parameter <em><strong>constraint</strong></em> that establishes an upper bound for type arguments. Type parameters may be referenced in type parameter constraints within the same type parameter list, including even constraint declarations that occur to the left of the type parameter.</p>
  <p>The <em><strong>base constraint</strong></em> of a type parameter <em>T</em> is defined as follows:</p>
  <ul>
  <li>If <em>T</em> has no declared constraint, <em>T</em>'s base constraint is the empty object type <code>{}</code>.</li>
  <li>If <em>T</em>'s declared constraint is a type parameter, <em>T</em>'s base constraint is that of the type parameter.</li>
  <li>Otherwise, <em>T</em>'s base constraint is <em>T</em>'s declared constraint.</li>
  </ul>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">G</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-smi">U</span> <span class="pl-k">extends</span> <span class="pl-smi">V</span><span class="pl-kos">,</span> <span class="pl-smi">V</span> <span class="pl-k">extends</span> <span class="pl-smi">Function</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the base constraint of 'T' is the empty object type and the base constraint of 'U' and 'V' is 'Function'.</p>
  </section><p>For purposes of determining type relationships (section <a href="#type-relationships-311">3.11</a>), type parameters appear to be subtypes of their base constraint. Likewise, in property accesses (section <a href="sec-expressions#property-access-413">4.13</a>), <code>new</code> operations (section <a href="sec-expressions#the-new-operator-414">4.14</a>), and function calls (section <a href="sec-expressions#function-calls-415">4.15</a>), type parameters appear to have the members of their base constraint, but no other members.</p>
  <p>It is an error for a type parameter to directly or indirectly be a constraint for itself. For example, both of the following declarations are invalid:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">A</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span> <span class="pl-k">extends</span> <span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">B</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span> <span class="pl-k">extends</span> <span class="pl-smi">U</span><span class="pl-kos">,</span> <span class="pl-smi">U</span> <span class="pl-k">extends</span> <span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="type-argument-lists-362" title="3.6.2"> Type Argument Lists</h3>
  <p>A type reference (section <a href="#type-references-382">3.8.2</a>) to a generic type must include a list of type arguments enclosed in angle brackets and separated by commas. Similarly, a call (section <a href="sec-expressions#function-calls-415">4.15</a>) to a generic function may explicitly include a type argument list instead of relying on type inference.</p>
  <p>  <em>TypeArguments:</em><br />
     <code>&lt;</code> <em>TypeArgumentList</em> <code>&gt;</code></p>
  <p>  <em>TypeArgumentList:</em><br />
     <em>TypeArgument</em><br />
     <em>TypeArgumentList</em> <code>,</code> <em>TypeArgument</em></p>
  <p>  <em>TypeArgument:</em><br />
     <em>Type</em></p>
  <p>Type arguments correspond one-to-one with type parameters of the generic type or function being referenced. A type argument list is required to specify exactly one type argument for each corresponding type parameter, and each type argument for a constrained type parameter is required to <em><strong>satisfy</strong></em> the constraint of that type parameter. A type argument satisfies a type parameter constraint if the type argument is assignable to (section <a href="#assignment-compatibility-3114">3.11.4</a>) the constraint type once type arguments are substituted for type parameters.</p>
  <p>Given the declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">G</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-smi">U</span> <span class="pl-k">extends</span> <span class="pl-smi">Function</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>a type reference of the form 'G&lt;A, B&gt;' places no requirements on 'A' but requires 'B' to be assignable to 'Function'.</p>
  <p>The process of substituting type arguments for type parameters in a generic type or generic signature is known as <em><strong>instantiating</strong></em> the generic type or signature. Instantiation of a generic type or signature can fail if the supplied type arguments do not satisfy the constraints of their corresponding type parameters.</p>
  <h3 id="this-types-363" title="3.6.3"> This-types</h3>
  <p><section id="user-content-3.6.3"><em><strong>this-type</strong></em> that represents the actual type of instances of the class or interface within the declaration of the class or interface. The this-type is referenced using the keyword <code>this</code> in a type position. Within instance methods and constructors of a class, the type of the expression <code>this</code> (section </section><a href="sec-expressions#the-this-keyword-42">4.2</a>) is the this-type of the class.</p>
  <p>Classes and interfaces support inheritance and therefore the instance represented by <code>this</code> in a method isn't necessarily an instance of the containing class—it may in fact be an instance of a derived class or interface. To model this relationship, the this-type of a class or interface is classified as a type parameter. Unlike other type parameters, it is not possible to explicitly pass a type argument for a this-type. Instead, in a type reference to a class or interface type, the type reference <em>itself</em> is implicitly passed as a type argument for the this-type. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-en">foo</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-smi">this</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">B</span> <span class="pl-k">extends</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-en">bar</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-smi">this</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">let</span> <span class="pl-s1">b</span>: <span class="pl-smi">B</span><span class="pl-kos">;</span>  
  <span class="pl-k">let</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">b</span><span class="pl-kos">.</span><span class="pl-en">foo</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">.</span><span class="pl-en">bar</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Fluent pattern works, type of x is B</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the declaration of <code>b</code> above, the type reference <code>B</code> is itself passed as a type argument for B's this-type. Thus, the referenced type is an instantiation of class <code>B</code> where all occurrences of the type <code>this</code> are replaced with <code>B</code>, and for that reason the <code>foo</code> method of <code>B</code> actually returns <code>B</code> (as opposed to <code>A</code>).</p>
  <p>The this-type of a given class or interface type <em>C</em> implicitly has a constraint consisting of a type reference to <em>C</em> with <em>C</em>'s own type parameters passed as type arguments and with that type reference passed as the type argument for the this-type.</p>
  <h2 id="named-types-37" title="3.7"> Named Types</h2>
  <p><section id="user-content-3.7"><em><strong>named types</strong></em> that are introduced through class declarations (section </section><a href="sec-classes#class-declarations-81">8.1</a>), interface declarations (section <a href="sec-interfaces#interface-declarations-71">7.1</a>), enum declarations (<a href="sec-enums#enum-declarations-91">9.1</a>), and type alias declarations (section <a href="#type-aliases-310">3.10</a>). Classes, interfaces, and type aliases may have type parameters and are then called <em><strong>generic types</strong></em>. Conversely, named types without type parameters are called <em><strong>non-generic types</strong></em>.</p>
  <p>Interface declarations only introduce named types, whereas class declarations introduce named types <em>and</em> constructor functions that create instances of implementations of those named types. The named types introduced by class and interface declarations have only minor differences (classes can't declare optional members and interfaces can't declare private or protected members) and are in most contexts interchangeable. In particular, class declarations with only public members introduce named types that function exactly like those created by interface declarations.</p>
  <p>Named types are referenced through <em><strong>type references</strong></em> (section <a href="#type-references-382">3.8.2</a>) that specify a type name and, if applicable, the type arguments to be substituted for the type parameters of the named type.</p>
  <p>Named types are technically not types—only <em>references</em> to named types are. This distinction is particularly evident with generic types: Generic types are "templates" from which multiple <em>actual</em> types can be created by writing type references that supply type arguments to substitute in place of the generic type's type parameters. This substitution process is known as <em><strong>instantiating</strong></em> a generic type. Only once a generic type is instantiated does it denote an actual type.</p>
  <p>TypeScript has a structural type system, and therefore an instantiation of a generic type is indistinguishable from an equivalent manually written expansion. For example, given the declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Pair</span><span class="pl-c1">&lt;</span><span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span> <span class="pl-c1">first</span>: <span class="pl-smi">T1</span><span class="pl-kos">;</span> <span class="pl-c1">second</span>: <span class="pl-smi">T2</span><span class="pl-kos">;</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the type reference</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-smi">Pair</span><span class="pl-kos">&lt;</span><span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-smi">Entity</span><span class="pl-kos">&gt;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is indistinguishable from the type</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">{</span> first: <span class="pl-s1">string</span><span class="pl-kos">;</span> second: <span class="pl-smi">Entity</span><span class="pl-kos">;</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h2 id="specifying-types-38" title="3.8"> Specifying Types</h2><section id="user-content-3.8"><p>Types are specified either by referencing their keyword or name, or by writing object type literals, array type literals, tuple type literals, function type literals, constructor type literals, or type queries.</p>
  <p>  <em>Type:</em><br />
     <em>UnionOrIntersectionOrPrimaryType</em><br />
     <em>FunctionType</em><br />
     <em>ConstructorType</em></p>
  <p>  <em>UnionOrIntersectionOrPrimaryType:</em><br />
     <em>UnionType</em><br />
     <em>IntersectionOrPrimaryType</em></p>
  <p>  <em>IntersectionOrPrimaryType:</em><br />
     <em>IntersectionType</em><br />
     <em>PrimaryType</em></p>
  <p>  <em>PrimaryType:</em><br />
     <em>ParenthesizedType</em><br />
     <em>PredefinedType</em><br />
     <em>TypeReference</em><br />
     <em>ObjectType</em><br />
     <em>ArrayType</em><br />
     <em>TupleType</em><br />
     <em>TypeQuery</em><br />
     <em>ThisType</em></p>
  <p>  <em>ParenthesizedType:</em><br />
     <code>(</code> <em>Type</em> <code>)</code></p>
  <p>Parentheses are required around union, intersection, function, or constructor types when they are used as array element types; around union, function, or constructor types in intersection types; and around function or constructor types in union types. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span><span class="pl-s1">string</span> <span class="pl-c1">|</span> <span class="pl-s1">number</span><span class="pl-kos">)</span><span class="pl-kos">[</span><span class="pl-s1" /><span class="pl-kos">]</span>  
  <span class="pl-kos">(</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">string</span><span class="pl-kos">)</span> <span class="pl-c1">|</span> <span class="pl-kos">(</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">number</span><span class="pl-kos">)</span>  
  <span class="pl-kos">(</span><span class="pl-smi">A</span> <span class="pl-c1">|</span> <span class="pl-smi">B</span><span class="pl-kos">)</span> <span class="pl-c1">&amp;</span> <span class="pl-kos">(</span><span class="pl-smi">C</span> <span class="pl-c1">|</span> <span class="pl-smi">D</span><span class="pl-kos">)</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The different forms of type notations are described in the following sections.</p>
  </section><h3 id="predefined-types-381" title="3.8.1"> Predefined Types</h3><section id="user-content-3.8.1"><p>The <code>any</code>, <code>number</code>, <code>boolean</code>, <code>string</code>, <code>symbol</code> and <code>void</code> keywords reference the Any type and the Number, Boolean, String, Symbol, and Void primitive types respectively.</p>
  <p>  <em>PredefinedType:</em><br />
     <code>any</code><br />
     <code>number</code><br />
     <code>boolean</code><br />
     <code>string</code><br />
     <code>symbol</code><br />
     <code>void</code></p>
  <p>The predefined type keywords are reserved and cannot be used as names of user defined types.</p>
  </section><h3 id="type-references-382" title="3.8.2"> Type References</h3><section id="user-content-3.8.2"><p>A type reference references a named type or type parameter through its name and, in the case of a generic type, supplies a type argument list.</p>
  <p>  <em>TypeReference:</em><br />
     <em>TypeName</em> <em>[no LineTerminator here]</em> <em>TypeArguments<sub>opt</sub></em></p>
  <p>  <em>TypeName:</em><br />
     <em>IdentifierReference</em><br />
     <em>NamespaceName</em> <code>.</code> <em>IdentifierReference</em></p>
  <p>  <em>NamespaceName:</em><br />
     <em>IdentifierReference</em><br />
     <em>NamespaceName</em> <code>.</code> <em>IdentifierReference</em></p>
  </section><p><section id="user-content-3.8.2"><em>TypeReference</em> consists of a <em>TypeName</em> that a references a named type or type parameter. A reference to a generic type must be followed by a list of <em>TypeArguments</em> (section </section><a href="#type-argument-lists-362">3.6.2</a>).</p>
  <p>A <em>TypeName</em> is either a single identifier or a sequence of identifiers separated by dots. In a type name, all identifiers but the last one refer to namespaces and the last identifier refers to a named type.</p>
  <p>Resolution of a <em>TypeName</em> consisting of a single identifier is described in section <a href="sec-basic-concepts#scopes-24">2.4</a>.</p>
  <p>Resolution of a <em>TypeName</em> of the form <em>N.X</em>, where <em>N</em> is a <em>NamespaceName</em> and <em>X</em> is an <em>IdentifierReference</em>, proceeds by first resolving the namespace name <em>N</em>. If the resolution of <em>N</em> is successful and the export member set (sections <a href="sec-namespaces#export-declarations-104">10.4</a> and <a href="sec-scripts-and-modules#export-member-set-11344">11.3.4.4</a>) of the resulting namespace contains a named type <em>X</em>, then <em>N.X</em> refers to that member. Otherwise, <em>N.X</em> is undefined.</p>
  <p>Resolution of a <em>NamespaceName</em> consisting of a single identifier is described in section <a href="sec-basic-concepts#scopes-24">2.4</a>. Identifiers declared in namespace declarations (section <a href="sec-namespaces#namespace-declarations-101">10.1</a>) or import declarations (sections <a href="sec-namespaces#import-alias-declarations-103">10.3</a>, <a href="sec-scripts-and-modules#import-declarations-1132">11.3.2</a>, and <a href="sec-scripts-and-modules#import-require-declarations-1133">11.3.3</a>) may be classified as namespaces.</p>
  <p>Resolution of a <em>NamespaceName</em> of the form <em>N.X</em>, where <em>N</em> is a <em>NamespaceName</em> and <em>X</em> is an <em>IdentifierReference</em>, proceeds by first resolving the namespace name <em>N</em>. If the resolution of <em>N</em> is successful and the export member set (sections <a href="sec-namespaces#export-declarations-104">10.4</a> and <a href="sec-scripts-and-modules#export-member-set-11344">11.3.4.4</a>) of the resulting namespace contains an exported namespace member <em>X</em>, then <em>N.X</em> refers to that member. Otherwise, <em>N.X</em> is undefined.</p>
  <p>A type reference to a generic type is required to specify exactly one type argument for each type parameter of the referenced generic type, and each type argument must be assignable to (section <a href="#assignment-compatibility-3114">3.11.4</a>) the constraint of the corresponding type parameter or otherwise an error occurs. An example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span> <span class="pl-c1">a</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">B</span> <span class="pl-k">extends</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span> <span class="pl-c1">b</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">C</span> <span class="pl-k">extends</span> <span class="pl-smi">B</span> <span class="pl-kos">{</span> <span class="pl-c1">c</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">G</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-smi">U</span> <span class="pl-k">extends</span> <span class="pl-smi">B</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">T</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">U</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">v1</span>: <span class="pl-smi">G</span><span class="pl-kos">&lt;</span><span class="pl-smi">A</span><span class="pl-kos">,</span> <span class="pl-smi">C</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>               <span class="pl-c">// Ok  </span>
  <span class="pl-k">var</span> <span class="pl-s1">v2</span>: <span class="pl-smi">G</span><span class="pl-kos">&lt;</span><span class="pl-kos">{</span> <span class="pl-c1">a</span>: <span class="pl-smi">string</span> <span class="pl-kos">}</span><span class="pl-kos">,</span> <span class="pl-smi">C</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>   <span class="pl-c">// Ok, equivalent to G&lt;A, C&gt;  </span>
  <span class="pl-k">var</span> <span class="pl-s1">v3</span>: <span class="pl-smi">G</span><span class="pl-kos">&lt;</span><span class="pl-smi">A</span><span class="pl-kos">,</span> <span class="pl-smi">A</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>               <span class="pl-c">// Error, A not valid argument for U  </span>
  <span class="pl-k">var</span> <span class="pl-s1">v4</span>: <span class="pl-smi">G</span><span class="pl-kos">&lt;</span><span class="pl-smi">G</span><span class="pl-kos">&lt;</span><span class="pl-smi">A</span><span class="pl-kos">,</span> <span class="pl-smi">B</span><span class="pl-kos">&gt;</span><span class="pl-kos">,</span> <span class="pl-smi">C</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>         <span class="pl-c">// Ok  </span>
  <span class="pl-k">var</span> <span class="pl-s1">v5</span>: <span class="pl-smi">G</span><span class="pl-kos">&lt;</span><span class="pl-smi">any</span><span class="pl-kos">,</span> <span class="pl-smi">any</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>           <span class="pl-c">// Ok  </span>
  <span class="pl-k">var</span> <span class="pl-s1">v6</span>: <span class="pl-smi">G</span><span class="pl-kos">&lt;</span><span class="pl-smi">any</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>                <span class="pl-c">// Error, wrong number of arguments  </span>
  <span class="pl-k">var</span> <span class="pl-s1">v7</span>: <span class="pl-smi">G</span><span class="pl-kos">;</span>                     <span class="pl-c">// Error, no arguments</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>A type argument is simply a <em>Type</em> and may itself be a type reference to a generic type, as demonstrated by 'v4' in the example above.</p>
  <p>As described in section <a href="#named-types-37">3.7</a>, a type reference to a generic type <em>G</em> designates a type wherein all occurrences of <em>G</em>'s type parameters have been replaced with the actual type arguments supplied in the type reference. For example, the declaration of 'v1' above is equivalent to:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">v1</span>: <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-kos">{</span> <span class="pl-c1">a</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
      <span class="pl-c1">y</span>: <span class="pl-kos">{</span> <span class="pl-c1">a</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-c1">b</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-c1">c</span>: <span class="pl-smi">string</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="object-type-literals-383" title="3.8.3"> Object Type Literals</h3><section id="user-content-3.8.3"><p>An object type literal defines an object type by specifying the set of members that are statically considered to be present in instances of the type. Object type literals can be given names using interface declarations but are otherwise anonymous.</p>
  <p>  <em>ObjectType:</em><br />
     <code>{</code> <em>TypeBody<sub>opt</sub></em> <code>}</code></p>
  <p>  <em>TypeBody:</em><br />
     <em>TypeMemberList</em> <code>;</code><em><sub>opt</sub></em><br />
     <em>TypeMemberList</em> <code>,</code><em><sub>opt</sub></em></p>
  <p>  <em>TypeMemberList:</em><br />
     <em>TypeMember</em><br />
     <em>TypeMemberList</em> <code>;</code> <em>TypeMember</em><br />
     <em>TypeMemberList</em> <code>,</code> <em>TypeMember</em></p>
  <p>  <em>TypeMember:</em><br />
     <em>PropertySignature</em><br />
     <em>CallSignature</em><br />
     <em>ConstructSignature</em><br />
     <em>IndexSignature</em><br />
     <em>MethodSignature</em></p>
  </section><p>The members of an object type literal are specified as a combination of property, call, construct, index, and method signatures. Object type members are described in section <a href="#specifying-members-39">3.9</a>.</p>
  <h3 id="array-type-literals-384" title="3.8.4"> Array Type Literals</h3><section id="user-content-3.8.4"><p>An array type literal is written as an element type followed by an open and close square bracket.</p>
  <p>  <em>ArrayType:</em><br />
     <em>PrimaryType</em> <em>[no LineTerminator here]</em> <code>[</code> <code>]</code></p>
  </section><p>An array type literal references an array type (section <a href="#array-types-332">3.3.2</a>) with the given element type. An array type literal is simply shorthand notation for a reference to the generic interface type 'Array' in the global namespace with the element type as a type argument.</p>
  <p>When union, intersection, function, or constructor types are used as array element types they must be enclosed in parentheses. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span><span class="pl-s1">string</span> <span class="pl-c1">|</span> <span class="pl-s1">number</span><span class="pl-kos">)</span><span class="pl-kos">[</span><span class="pl-kos">]</span>  
  <span class="pl-kos">(</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">string</span><span class="pl-kos">)</span><span class="pl-kos">[</span><span class="pl-kos">]</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Alternatively, array types can be written using the 'Array&lt;T&gt;' notation. For example, the types above are equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-smi">Array</span><span class="pl-c1">&lt;</span><span class="pl-s1">string</span> <span class="pl-c1">|</span> <span class="pl-s1">number</span><span class="pl-c1">&gt;</span>  
  <span class="pl-smi">Array</span><span class="pl-kos">&lt;</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">string</span><span class="pl-kos">&gt;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="tuple-type-literals-385" title="3.8.5"> Tuple Type Literals</h3><section id="user-content-3.8.5"><p>A tuple type literal is written as a sequence of element types, separated by commas and enclosed in square brackets.</p>
  <p>  <em>TupleType:</em><br />
     <code>[</code> <em>TupleElementTypes</em> <code>]</code></p>
  <p>  <em>TupleElementTypes:</em><br />
     <em>TupleElementType</em><br />
     <em>TupleElementTypes</em> <code>,</code> <em>TupleElementType</em></p>
  <p>  <em>TupleElementType:</em><br />
     <em>Type</em></p>
  </section><p>A tuple type literal references a tuple type (section <a href="#tuple-types-333">3.3.3</a>).</p>
  <h3 id="union-type-literals-386" title="3.8.6"> Union Type Literals</h3><section id="user-content-3.8.6"><p>A union type literal is written as a sequence of types separated by vertical bars.</p>
  <p>  <em>UnionType:</em><br />
     <em>UnionOrIntersectionOrPrimaryType</em> <code>|</code> <em>IntersectionOrPrimaryType</em></p>
  </section><p>A union type literal references a union type (section <a href="#union-types-34">3.4</a>).</p>
  <h3 id="intersection-type-literals-387" title="3.8.7"> Intersection Type Literals</h3><section id="user-content-3.8.7"><p>An intersection type literal is written as a sequence of types separated by ampersands.</p>
  <p>  <em>IntersectionType:</em><br />
     <em>IntersectionOrPrimaryType</em> <code>&amp;</code> <em>PrimaryType</em></p>
  </section><p>An intersection type literal references an intersection type (section <a href="#intersection-types-35">3.5</a>).</p>
  <h3 id="function-type-literals-388" title="3.8.8"> Function Type Literals</h3><section id="user-content-3.8.8"><p>A function type literal specifies the type parameters, regular parameters, and return type of a call signature.</p>
  <p>  <em>FunctionType:</em><br />
     <em>TypeParameters<sub>opt</sub></em> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <code>=&gt;</code> <em>Type</em></p>
  <p>A function type literal is shorthand for an object type containing a single call signature. Specifically, a function type literal of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span> <span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-kos">,</span> ... <span class="pl-c1">&gt;</span> <span class="pl-kos">(</span> <span class="pl-s1">p1</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span><span class="pl-kos">,</span> ... <span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">R</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is exactly equivalent to the object type literal</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">{</span> <span class="pl-c1">&lt;</span> <span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-kos">,</span> ... <span class="pl-c1">&gt;</span> <span class="pl-kos">(</span> <span class="pl-s1">p1</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span><span class="pl-kos">,</span> ... <span class="pl-kos">)</span> : <span class="pl-smi">R</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that function types with multiple call or construct signatures cannot be written as function type literals but must instead be written as object type literals.</p>
  </section><h3 id="constructor-type-literals-389" title="3.8.9"> Constructor Type Literals</h3><section id="user-content-3.8.9"><p>A constructor type literal specifies the type parameters, regular parameters, and return type of a construct signature.</p>
  <p>  <em>ConstructorType:</em><br />
     <code>new</code> <em>TypeParameters<sub>opt</sub></em> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <code>=&gt;</code> <em>Type</em></p>
  <p>A constructor type literal is shorthand for an object type containing a single construct signature. Specifically, a constructor type literal of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">new</span> <span class="pl-c1">&lt;</span> <span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-kos">,</span> ... <span class="pl-c1">&gt;</span> <span class="pl-kos">(</span> <span class="pl-s1">p1</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span><span class="pl-kos">,</span> ... <span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">R</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is exactly equivalent to the object type literal</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">{</span> <span class="pl-k">new</span> <span class="pl-c1">&lt;</span> <span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-kos">,</span> ... <span class="pl-c1">&gt;</span> <span class="pl-kos">(</span> <span class="pl-s1">p1</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span><span class="pl-kos">,</span> ... <span class="pl-kos">)</span> : <span class="pl-smi">R</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that constructor types with multiple construct signatures cannot be written as constructor type literals but must instead be written as object type literals.</p>
  </section><h3 id="type-queries-3810" title="3.8.10"> Type Queries</h3><section id="user-content-3.8.10"><p>A type query obtains the type of an expression.</p>
  <p>  <em>TypeQuery:</em><br />
     <code>typeof</code> <em>TypeQueryExpression</em></p>
  <p>  <em>TypeQueryExpression:</em><br />
     <em>IdentifierReference</em><br />
     <em>TypeQueryExpression</em> <code>.</code> <em>IdentifierName</em></p>
  </section><p><section id="user-content-3.8.10"><code>typeof</code> followed by an expression. The expression is restricted to a single identifier or a sequence of identifiers separated by periods. The expression is processed as an identifier expression (section </section><a href="sec-expressions#identifiers-43">4.3</a>) or property access expression (section <a href="sec-expressions#property-access-413">4.13</a>), the widened type (section <a href="#widened-types-312">3.12</a>) of which becomes the result. Similar to other static typing constructs, type queries are erased from the generated JavaScript code and add no run-time overhead.</p>
  <p>Type queries are useful for capturing anonymous types that are generated by various constructs such as object literals, function declarations, and namespace declarations. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">a</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-c1">20</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">b</span>: <span class="pl-k">typeof</span> <span class="pl-s1">a</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Above, 'b' is given the same type as 'a', namely <code>{ x: number; y: number; }</code>.</p>
  <p>If a declaration includes a type annotation that references the entity being declared through a circular path of type queries or type references containing type queries, the resulting type is the Any type. For example, all of the following variables are given the type Any:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">c</span>: <span class="pl-k">typeof</span> <span class="pl-s1">c</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">d</span>: <span class="pl-k">typeof</span> <span class="pl-s1">e</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">e</span>: <span class="pl-k">typeof</span> <span class="pl-s1">d</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">f</span>: <span class="pl-smi">Array</span><span class="pl-kos">&lt;</span><span class="pl-k">typeof</span> <span class="pl-s1">f</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>However, if a circular path of type queries includes at least one <em>ObjectType</em>, <em>FunctionType</em> or <em>ConstructorType</em>, the construct denotes a recursive type:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">g</span>: <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-k">typeof</span> <span class="pl-s1">g</span><span class="pl-kos">;</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">h</span>: <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-k">typeof</span> <span class="pl-s1">h</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Here, 'g' and 'g.x' have the same recursive type, and likewise 'h' and 'h()' have the same recursive type.</p>
  <h3 id="this-type-references-3811" title="3.8.11"> This-Type References</h3>
  <p><section id="user-content-3.8.11"><code>this</code> keyword is used to reference the this-type (section </section><a href="#this-types-363">3.6.3</a>) of a class or interface.</p>
  <p>  <em>ThisType:</em><br />
     <code>this</code></p>
  <p>The meaning of a <em>ThisType</em> depends on the closest enclosing <em>FunctionDeclaration</em>, <em>FunctionExpression</em>, <em>PropertyDefinition</em>, <em>ClassElement</em>, or <em>TypeMember</em>, known as the root declaration of the <em>ThisType</em>, as follows:</p>
  <ul>
  <li>When the root declaration is an instance member or constructor of a class, the <em>ThisType</em> references the this-type of that class.</li>
  <li>When the root declaration is a member of an interface type, the <em>ThisType</em> references the this-type of that interface.</li>
  <li>Otherwise, the <em>ThisType</em> is an error.</li>
  </ul>
  <p>Note that in order to avoid ambiguities it is not possible to reference the this-type of a class or interface in a nested object type literal. In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">ListItem</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">getHead</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">this</span><span class="pl-kos">;</span>  
      <span class="pl-c1">getTail</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">this</span><span class="pl-kos">;</span>  
      <span class="pl-c1">getHeadAndTail</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-kos">{</span> <span class="pl-c1">head</span>: <span class="pl-smi">this</span><span class="pl-kos">,</span> <span class="pl-c1">tail</span>: <span class="pl-smi">this</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  <span class="pl-c">// Error  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the <code>this</code> references on the last line are in error because their root declarations are not members of a class or interface. The recommended way to reference the this-type of an outer class or interface in an object type literal is to declare an intermediate generic type and pass <code>this</code> as a type argument. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">type</span> <span class="pl-smi">HeadAndTail</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">head</span>: <span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-c1">tail</span>: <span class="pl-smi">T</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">ListItem</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">getHead</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">this</span><span class="pl-kos">;</span>  
      <span class="pl-c1">getTail</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">this</span><span class="pl-kos">;</span>  
      <span class="pl-c1">getHeadAndTail</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">HeadAndTail</span><span class="pl-kos">&lt;</span><span class="pl-smi">this</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h2 id="specifying-members-39" title="3.9"> Specifying Members</h2>
  <p>The members of an object type literal (section <a href="#object-type-literals-383">3.8.3</a>) are specified as a combination of property, call, construct, index, and method signatures.</p>
  <h3 id="property-signatures-391" title="3.9.1"> Property Signatures</h3><section id="user-content-3.9.1"><p>A property signature declares the name and type of a property member.</p>
  <p>  <em>PropertySignature:</em><br />
     <em>PropertyName</em> <code>?</code><em><sub>opt</sub></em> <em>TypeAnnotation<sub>opt</sub></em></p>
  <p>  <em>TypeAnnotation:</em><br />
     <code>:</code> <em>Type</em></p>
  </section><p><section id="user-content-3.9.1"><em>PropertyName</em> (</section><a href="sec-basic-concepts#property-names-222">2.2.2</a>) of a property signature must be unique within its containing type, and must denote a well-known symbol if it is a computed property name (<a href="sec-basic-concepts#computed-property-names-223">2.2.3</a>). If the property name is followed by a question mark, the property is optional. Otherwise, the property is required.</p>
  <p>If a property signature omits a <em>TypeAnnotation</em>, the Any type is assumed.</p>
  <h3 id="call-signatures-392" title="3.9.2"> Call Signatures</h3>
  <p>A call signature defines the type parameters, parameter list, and return type associated with applying a call operation (section <a href="sec-expressions#function-calls-415">4.15</a>) to an instance of the containing type. A type may <em><strong>overload</strong></em> call operations by defining multiple different call signatures.</p>
  <p>  <em>CallSignature:</em><br />
     <em>TypeParameters<sub>opt</sub></em> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <em>TypeAnnotation<sub>opt</sub></em></p>
  <p>A call signature that includes <em>TypeParameters</em> (section <a href="#type-parameter-lists-361">3.6.1</a>) is called a <em><strong>generic call signature</strong></em>. Conversely, a call signature with no <em>TypeParameters</em> is called a non-generic call signature.</p>
  <p>As well as being members of object type literals, call signatures occur in method signatures (section <a href="#method-signatures-395">3.9.5</a>), function expressions (section <a href="sec-expressions#function-expressions-410">4.10</a>), and function declarations (section <a href="sec-functions#function-declarations-61">6.1</a>).</p>
  <p>An object type containing call signatures is said to be a <em><strong>function type</strong></em>.</p>
  <h4 id="type-parameters-3921" title="3.9.2.1"> Type Parameters</h4>
  <p>Type parameters (section <a href="#type-parameter-lists-361">3.6.1</a>) in call signatures provide a mechanism for expressing the relationships of parameter and return types in call operations. For example, a signature might introduce a type parameter and use it as both a parameter type and a return type, in effect describing a function that returns a value of the same type as its argument.</p>
  <p>Type parameters may be referenced in parameter types and return type annotations, but not in type parameter constraints, of the call signature in which they are introduced.</p>
  <p>Type arguments (section <a href="#type-argument-lists-362">3.6.2</a>) for call signature type parameters may be explicitly specified in a call operation or may, when possible, be inferred (section <a href="sec-expressions#type-argument-inference-4152">4.15.2</a>) from the types of the regular arguments in the call. An <em><strong>instantiation</strong></em> of a generic call signature for a particular set of type arguments is the call signature formed by replacing each type parameter with its corresponding type argument.</p>
  <p>Some examples of call signatures with type parameters follow below.</p>
  <p>A function taking an argument of any type, returning a value of that same type:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span>: <span class="pl-smi">T</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>A function taking two values of the same type, returning an array of that type:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>A function taking two arguments of different types, returning an object with properties 'x' and 'y' of those types:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-smi">U</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">U</span><span class="pl-kos">)</span>: <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-smi">T</span><span class="pl-kos">;</span> <span class="pl-c1">y</span>: <span class="pl-smi">U</span><span class="pl-kos">;</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>A function taking an array of one type and a function argument, returning an array of another type, where the function argument takes a value of the first array element type and returns a value of the second array element type:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-smi">U</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-s1">f</span>: <span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">U</span><span class="pl-kos">)</span>: <span class="pl-smi">U</span><span class="pl-kos">[</span><span class="pl-kos">]</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h4 id="parameter-list-3922" title="3.9.2.2"> Parameter List</h4><section id="user-content-3.9.2.2"><p>A signature's parameter list consists of zero or more required parameters, followed by zero or more optional parameters, finally followed by an optional rest parameter.</p>
  <p>  <em>ParameterList:</em><br />
     <em>RequiredParameterList</em><br />
     <em>OptionalParameterList</em><br />
     <em>RestParameter</em><br />
     <em>RequiredParameterList</em> <code>,</code> <em>OptionalParameterList</em><br />
     <em>RequiredParameterList</em> <code>,</code> <em>RestParameter</em><br />
     <em>OptionalParameterList</em> <code>,</code> <em>RestParameter</em><br />
     <em>RequiredParameterList</em> <code>,</code> <em>OptionalParameterList</em> <code>,</code> <em>RestParameter</em></p>
  <p>  <em>RequiredParameterList:</em><br />
     <em>RequiredParameter</em><br />
     <em>RequiredParameterList</em> <code>,</code> <em>RequiredParameter</em></p>
  <p>  <em>RequiredParameter:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <em>BindingIdentifierOrPattern</em> <em>TypeAnnotation<sub>opt</sub></em><br />
     <em>BindingIdentifier</em> <code>:</code> <em>StringLiteral</em></p>
  <p>  <em>AccessibilityModifier:</em><br />
     <code>public</code><br />
     <code>private</code><br />
     <code>protected</code></p>
  <p>  <em>BindingIdentifierOrPattern:</em><br />
     <em>BindingIdentifier</em><br />
     <em>BindingPattern</em></p>
  <p>  <em>OptionalParameterList:</em><br />
     <em>OptionalParameter</em><br />
     <em>OptionalParameterList</em> <code>,</code> <em>OptionalParameter</em></p>
  <p>  <em>OptionalParameter:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <em>BindingIdentifierOrPattern</em> <code>?</code> <em>TypeAnnotation<sub>opt</sub></em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <em>BindingIdentifierOrPattern</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer</em><br />
     <em>BindingIdentifier</em> <code>?</code> <code>:</code> <em>StringLiteral</em></p>
  <p>  <em>RestParameter:</em><br />
     <code>...</code> <em>BindingIdentifier</em> <em>TypeAnnotation<sub>opt</sub></em></p>
  </section><p>A parameter declaration may specify either an identifier or a binding pattern (<a href="sec-statements#destructuring-variable-declarations-522">5.2.2</a>). The identifiers specified in parameter declarations and binding patterns in a parameter list must be unique within that parameter list.</p>
  <p>The type of a parameter in a signature is determined as follows:</p>
  <ul>
  <li>If the declaration includes a type annotation, the parameter is of that type.</li>
  <li>Otherwise, if the declaration includes an initializer expression (which is permitted only when the parameter list occurs in conjunction with a function body), the parameter type is the widened form (section <a href="#widened-types-312">3.12</a>) of the type of the initializer expression.</li>
  <li>Otherwise, if the declaration specifies a binding pattern, the parameter type is the implied type of that binding pattern (section <a href="sec-statements#implied-type-523">5.2.3</a>).</li>
  <li>Otherwise, if the parameter is a rest parameter, the parameter type is <code>any[]</code>.</li>
  <li>Otherwise, the parameter type is <code>any</code>.</li>
  </ul>
  <p>A parameter is permitted to include a <code>public</code>, <code>private</code>, or <code>protected</code> modifier only if it occurs in the parameter list of a <em>ConstructorImplementation</em> (section <a href="sec-classes#constructor-parameters-831">8.3.1</a>) and only if it doesn't specify a <em>BindingPattern</em>.</p>
  <p>A type annotation for a rest parameter must denote an array type.</p>
  <p>When a parameter type annotation specifies a string literal type, the containing signature is a specialized signature (section <a href="#specialized-signatures-3924">3.9.2.4</a>). Specialized signatures are not permitted in conjunction with a function body, i.e. the <em>FunctionExpression</em>, <em>FunctionImplementation</em>, <em>MemberFunctionImplementation</em>, and <em>ConstructorImplementation</em> grammar productions do not permit parameters with string literal types.</p>
  <p>A parameter can be marked optional by following its name or binding pattern with a question mark (<code>?</code>) or by including an initializer. Initializers (including binding property or element initializers) are permitted only when the parameter list occurs in conjunction with a function body, i.e. only in a <em>FunctionExpression</em>, <em>FunctionImplementation</em>, <em>MemberFunctionImplementation</em>, or <em>ConstructorImplementation</em> grammar production.</p>
  <p><em>TODO: Update to reflect <a href="https://github.com/Microsoft/TypeScript/issues/2797">binding parameter cannot be optional in implementation signature</a></em>.</p>
  <p><em>TODO: Update to reflect <a href="https://github.com/Microsoft/TypeScript/pull/4022">required parameters support initializers</a></em>.</p>
  <h4 id="return-type-3923" title="3.9.2.3"> Return Type</h4><section id="user-content-3.9.2.3"><p>If present, a call signature's return type annotation specifies the type of the value computed and returned by a call operation. A <code>void</code> return type annotation is used to indicate that a function has no return value.</p>
  <p>When a call signature with no return type annotation occurs in a context without a function body, the return type is assumed to be the Any type.</p>
  </section><p>When a call signature with no return type annotation occurs in a context that has a function body (specifically, a function implementation, a member function implementation, or a member accessor declaration), the return type is inferred from the function body as described in section <a href="sec-functions#function-implementations-63">6.3</a>.</p>
  <h4 id="specialized-signatures-3924" title="3.9.2.4"> Specialized Signatures</h4>
  <p>When a parameter type annotation specifies a string literal type (section <a href="#string-literal-types-329">3.2.9</a>), the containing signature is considered a specialized signature. Specialized signatures are used to express patterns where specific string values for some parameters cause the types of other parameters or the function result to become further specialized. For example, the declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Document</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-s">"div"</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLDivElement</span><span class="pl-kos">;</span>   
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-s">"span"</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLSpanElement</span><span class="pl-kos">;</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-s">"canvas"</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLCanvasElement</span><span class="pl-kos">;</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLElement</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>states that calls to 'createElement' with the string literals "div", "span", and "canvas" return values of type 'HTMLDivElement', 'HTMLSpanElement', and 'HTMLCanvasElement' respectively, and that calls with all other string expressions return values of type 'HTMLElement'.</p>
  <p>When writing overloaded declarations such as the one above it is important to list the non-specialized signature last. This is because overload resolution (section <a href="sec-expressions#overload-resolution-4151">4.15.1</a>) processes the candidates in declaration order and picks the first one that matches.</p>
  <p>Every specialized call or construct signature in an object type must be assignable to at least one non-specialized call or construct signature in the same object type (where a call signature <em>A</em> is considered assignable to another call signature <em>B</em> if an object type containing only <em>A</em> would be assignable to an object type containing only <em>B</em>). For example, the 'createElement' property in the example above is of a type that contains three specialized signatures, all of which are assignable to the non-specialized signature in the type.</p>
  <h3 id="construct-signatures-393" title="3.9.3"> Construct Signatures</h3>
  <p><section id="user-content-3.9.3"><code>new</code> operator (section </section><a href="sec-expressions#the-new-operator-414">4.14</a>) to an instance of the containing type. A type may overload <code>new</code> operations by defining multiple construct signatures with different parameter lists.</p>
  <p>  <em>ConstructSignature:</em><br />
     <code>new</code> <em>TypeParameters<sub>opt</sub></em> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <em>TypeAnnotation<sub>opt</sub></em></p>
  <p>The type parameters, parameter list, and return type of a construct signature are subject to the same rules as a call signature.</p>
  <p>A type containing construct signatures is said to be a <em><strong>constructor type</strong></em>.</p>
  <h3 id="index-signatures-394" title="3.9.4"> Index Signatures</h3><section id="user-content-3.9.4"><p>An index signature defines a type constraint for properties in the containing type.</p>
  <p>  <em>IndexSignature:</em><br />
     <code>[</code> <em>BindingIdentifier</em> <code>:</code> <code>string</code> <code>]</code> <em>TypeAnnotation</em><br />
     <code>[</code> <em>BindingIdentifier</em> <code>:</code> <code>number</code> <code>]</code> <em>TypeAnnotation</em></p>
  <p>There are two kinds of index signatures:</p>
  <ul>
  <li><em><strong>String index signatures</strong></em>, specified using index type <code>string</code>, define type constraints for all properties and numeric index signatures in the containing type. Specifically, in a type with a string index signature of type <em>T</em>, all properties and numeric index signatures must have types that are assignable to <em>T</em>.</li>
  <li><em><strong>Numeric index signatures</strong></em>, specified using index type <code>number</code>, define type constraints for all numerically named properties in the containing type. Specifically, in a type with a numeric index signature of type <em>T</em>, all numerically named properties must have types that are assignable to <em>T</em>.</li>
  </ul>
  <p>A <em><strong>numerically named property</strong></em> is a property whose name is a valid numeric literal. Specifically, a property with a name <em>N</em> for which ToString(ToNumber(<em>N</em>)) is identical to <em>N</em>, where ToString and ToNumber are the abstract operations defined in ECMAScript specification.</p>
  <p>An object type can contain at most one string index signature and one numeric index signature.</p>
  </section><p>Index signatures affect the determination of the type that results from applying a bracket notation property access to an instance of the containing type, as described in section <a href="sec-expressions#property-access-413">4.13</a>.</p>
  <h3 id="method-signatures-395" title="3.9.5"> Method Signatures</h3><section id="user-content-3.9.5"><p>A method signature is shorthand for declaring a property of a function type.</p>
  <p>  <em>MethodSignature:</em><br />
     <em>PropertyName</em> <code>?</code><em><sub>opt</sub></em> <em>CallSignature</em></p>
  </section><p><section id="user-content-3.9.5"><em>PropertyName</em> is a computed property name (</section><a href="sec-basic-concepts#computed-property-names-223">2.2.3</a>), it must specify a well-known symbol. If the <em>PropertyName</em> is followed by a question mark, the property is optional. Otherwise, the property is required. Only object type literals and interfaces can declare optional properties.</p>
  <p>A method signature of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">f</span> <span class="pl-kos">&lt;</span> <span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-kos">,</span> ... <span class="pl-kos">&gt;</span> <span class="pl-kos">(</span> <span class="pl-s1">p1</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span><span class="pl-kos">,</span> ... <span class="pl-kos">)</span> : <span class="pl-smi">R</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is equivalent to the property declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre>f : <span class="pl-kos">{</span> <span class="pl-c1">&lt;</span> <span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-kos">,</span> ... <span class="pl-c1">&gt;</span> <span class="pl-kos">(</span> <span class="pl-s1">p1</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span><span class="pl-kos">,</span> ... <span class="pl-kos">)</span> : <span class="pl-smi">R</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>A literal type may <em><strong>overload</strong></em> a method by declaring multiple method signatures with the same name but differing parameter lists. Overloads must either all be required (question mark omitted) or all be optional (question mark included). A set of overloaded method signatures correspond to a declaration of a single property with a type composed from an equivalent set of call signatures. Specifically</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-en">f</span> <span class="pl-kos">&lt;</span> <span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-kos">,</span> ... <span class="pl-kos">&gt;</span> <span class="pl-kos">(</span> <span class="pl-s1">p1</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span><span class="pl-kos">,</span> ... <span class="pl-kos">)</span> : <span class="pl-smi">R</span><span class="pl-kos" /> <span class="pl-kos">;</span>  
  <span class="pl-s1">f</span> <span class="pl-kos">&lt;</span> <span class="pl-smi">U1</span><span class="pl-kos">,</span> <span class="pl-smi">U2</span><span class="pl-kos">,</span> ... <span class="pl-kos">&gt;</span> <span class="pl-kos">(</span> <span class="pl-s1">q1</span><span class="pl-kos">,</span> <span class="pl-s1">q2</span><span class="pl-kos">,</span> ... <span class="pl-kos">)</span> : <span class="pl-smi">S</span> <span class="pl-kos">;</span>  
  ...</pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre>f : <span class="pl-kos">{</span>  
      <span class="pl-c1">&lt;</span> <span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-kos">,</span> ... <span class="pl-c1">&gt;</span> <span class="pl-kos">(</span> <span class="pl-s1">p1</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span><span class="pl-kos">,</span> ... <span class="pl-kos">)</span> : <span class="pl-smi">R</span> <span class="pl-kos">;</span>  
      <span class="pl-kos">&lt;</span> <span class="pl-smi">U1</span><span class="pl-kos">,</span> <span class="pl-smi">U2</span><span class="pl-kos">,</span> ... <span class="pl-kos">&gt;</span> <span class="pl-kos">(</span> <span class="pl-s1">q1</span><span class="pl-kos">,</span> <span class="pl-s1">q2</span><span class="pl-kos">,</span> ... <span class="pl-kos">)</span> : <span class="pl-smi">S</span> <span class="pl-kos">;</span>  
      ...  
  <span class="pl-kos">}</span> <span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the following example of an object type</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">{</span>  
      <span class="pl-c1">func1</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>         <span class="pl-c">// Method signature  </span>
      func2: <span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">number</span><span class="pl-kos">;</span>     <span class="pl-c">// Function type literal  </span>
      func3: <span class="pl-kos">{</span> <span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">number</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>   <span class="pl-c">// Object type literal  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the properties 'func1', 'func2', and 'func3' are all of the same type, namely an object type with a single call signature taking a number and returning a number. Likewise, in the object type</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">{</span>  
      <span class="pl-c1">func4</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-en">func4</span><span class="pl-kos">(</span><span class="pl-s1">s</span>: <span class="pl-s1">string</span><span class="pl-kos">)</span>: string<span class="pl-kos">;</span>  
      func5: <span class="pl-kos">{</span>  
          <span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
          <span class="pl-kos">(</span><span class="pl-s1">s</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the properties 'func4' and 'func5' are of the same type, namely an object type with two call signatures taking and returning number and string respectively.</p>
  <h2 id="type-aliases-310" title="3.10"> Type Aliases</h2><section id="user-content-3.10"><p>A type alias declaration introduces a <em><strong>type alias</strong></em> in the containing declaration space.</p>
  <p>  <em>TypeAliasDeclaration:</em><br />
     <code>type</code> <em>BindingIdentifier</em> <em>TypeParameters<sub>opt</sub></em> <code>=</code> <em>Type</em> <code>;</code></p>
  <p>A type alias serves as an alias for the type specified in the type alias declaration. Unlike an interface declaration, which always introduces a named object type, a type alias declaration can introduce a name for any kind of type, including primitive, union, and intersection types.</p>
  </section><p>A type alias may optionally have type parameters (section <a href="#type-parameter-lists-361">3.6.1</a>) that serve as placeholders for actual types to be provided when the type alias is referenced in type references. A type alias with type parameters is called a <em><strong>generic type alias</strong></em>. The type parameters of a generic type alias declaration are in scope and may be referenced in the aliased <em>Type</em>.</p>
  <p>Type aliases are referenced using type references (<a href="#type-references-382">3.8.2</a>). Type references to generic type aliases produce instantiations of the aliased type with the given type arguments. Writing a reference to a non-generic type alias has exactly the same effect as writing the aliased type itself, and writing a reference to a generic type alias has exactly the same effect as writing the resulting instantiation of the aliased type.</p>
  <p>The <em>BindingIdentifier</em> of a type alias declaration may not be one of the predefined type names (section <a href="#predefined-types-381">3.8.1</a>).</p>
  <p>It is an error for the type specified in a type alias to depend on that type alias. Types have the following dependencies:</p>
  <ul>
  <li>A type alias <em>directly depends on</em> the type it aliases.</li>
  <li>A type reference <em>directly depends on</em> the referenced type and each of the type arguments, if any.</li>
  <li>A union or intersection type <em>directly depends on</em> each of the constituent types.</li>
  <li>An array type <em>directly depends on</em> its element type.</li>
  <li>A tuple type <em>directly depends on</em> each of its element types.</li>
  <li>A type query <em>directly depends on</em> the type of the referenced entity.</li>
  </ul>
  <p>Given this definition, the complete set of types upon which a type depends is the transitive closure of the <em>directly depends on</em> relationship. Note that object type literals, function type literals, and constructor type literals do not depend on types referenced within them and are therefore permitted to circularly reference themselves through type aliases.</p>
  <p>Some examples of type alias declarations:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">type</span> <span class="pl-smi">StringOrNumber</span> <span class="pl-c1">=</span> <span class="pl-smi">string</span> <span class="pl-c1">|</span> <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-k">type</span> <span class="pl-smi">Text</span> <span class="pl-c1">=</span> <span class="pl-smi">string</span> <span class="pl-c1">|</span> <span class="pl-kos">{</span> <span class="pl-c1">text</span>: <span class="pl-smi">string</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-k">type</span> <span class="pl-smi">NameLookup</span> <span class="pl-c1">=</span> <span class="pl-smi">Dictionary</span><span class="pl-kos">&lt;</span><span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-smi">Person</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-k">type</span> <span class="pl-smi">ObjectStatics</span> <span class="pl-c1">=</span> <span class="pl-k">typeof</span> <span class="pl-smi">Object</span><span class="pl-kos">;</span>  
  <span class="pl-k">type</span> <span class="pl-smi">Callback</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-kos">(</span><span class="pl-s1">data</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
  <span class="pl-k">type</span> <span class="pl-smi">Pair</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-smi">T</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-k">type</span> <span class="pl-smi">Coordinates</span> <span class="pl-c1">=</span> <span class="pl-smi">Pair</span><span class="pl-kos">&lt;</span><span class="pl-smi">number</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-k">type</span> <span class="pl-smi">Tree</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-smi">T</span> <span class="pl-c1">|</span> <span class="pl-kos">{</span> <span class="pl-c1">left</span>: <span class="pl-smi">Tree</span><span class="pl-kos">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">&gt;</span><span class="pl-kos">,</span> <span class="pl-c1">right</span>: <span class="pl-smi">Tree</span><span class="pl-kos">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">&gt;</span> <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Interface types have many similarities to type aliases for object type literals, but since interface types offer more capabilities they are generally preferred to type aliases. For example, the interface type</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>could be written as the type alias</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">type</span> <span class="pl-smi">Point</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>However, doing so means the following capabilities are lost:</p>
  <ul>
  <li>An interface can be named in an extends or implements clause, but a type alias for an object type literal cannot.</li>
  <li>An interface can have multiple merged declarations, but a type alias for an object type literal cannot.</li>
  </ul>
  <h2 id="type-relationships-311" title="3.11"> Type Relationships</h2><section id="user-content-3.11"><p>Types in TypeScript have identity, subtype, supertype, and assignment compatibility relationships as defined in the following sections.</p>
  </section><h3 id="apparent-members-3111" title="3.11.1"> Apparent Members</h3>
  <p><section id="user-content-3.11.1"><em><strong>apparent members</strong></em> of a type are the members observed in subtype, supertype, and assignment compatibility relationships, as well as in the type checking of property accesses (section </section><a href="sec-expressions#property-access-413">4.13</a>), <code>new</code> operations (section <a href="sec-expressions#the-new-operator-414">4.14</a>), and function calls (section <a href="sec-expressions#function-calls-415">4.15</a>). The apparent members of a type are determined as follows:</p>
  <ul>
  <li>The apparent members of the primitive type Number and all enum types are the apparent members of the global interface type 'Number'.</li>
  <li>The apparent members of the primitive type Boolean are the apparent members of the global interface type 'Boolean'.</li>
  <li>The apparent members of the primitive type String and all string literal types are the apparent members of the global interface type 'String'.</li>
  <li>The apparent members of a type parameter are the apparent members of the constraint (section <a href="#type-parameter-lists-361">3.6.1</a>) of that type parameter.</li>
  <li>The apparent members of an object type <em>T</em> are the combination of the following:
  <ul>
  <li>The declared and/or inherited members of <em>T</em>.</li>
  <li>The properties of the global interface type 'Object' that aren't hidden by properties with the same name in <em>T</em>.</li>
  <li>If <em>T</em> has one or more call or construct signatures, the properties of the global interface type 'Function' that aren't hidden by properties with the same name in <em>T</em>.</li>
  </ul>
  </li>
  <li>The apparent members of a union type <em>U</em> are determined as follows:
  <ul>
  <li>When all constituent types of <em>U</em> have an apparent property named <em>N</em>, <em>U</em> has an apparent property named <em>N</em> of a union type of the respective property types.</li>
  <li>When all constituent types of <em>U</em> have an apparent call signature with a parameter list <em>P</em>, <em>U</em> has an apparent call signature with the parameter list <em>P</em> and a return type that is a union of the respective return types. The call signatures appear in the same order as in the first constituent type.</li>
  <li>When all constituent types of <em>U</em> have an apparent construct signature with a parameter list <em>P</em>, <em>U</em> has an apparent construct signature with the parameter list <em>P</em> and a return type that is a union of the respective return types. The construct signatures appear in the same order as in the first constituent type.</li>
  <li>When all constituent types of <em>U</em> have an apparent string index signature, <em>U</em> has an apparent string index signature of a union type of the respective string index signature types.</li>
  <li>When all constituent types of <em>U</em> have an apparent numeric index signature, <em>U</em> has an apparent numeric index signature of a union type of the respective numeric index signature types.</li>
  </ul>
  </li>
  <li>The apparent members of an intersection type <em>I</em> are determined as follows:
  <ul>
  <li>When one of more constituent types of <em>I</em> have an apparent property named <em>N</em>, <em>I</em> has an apparent property named <em>N</em> of an intersection type of the respective property types.</li>
  <li>When one or more constituent types of <em>I</em> have a call signature <em>S</em>, <em>I</em> has the apparent call signature <em>S</em>. The signatures are ordered as a concatenation of the signatures of each constituent type in the order of the constituent types within <em>I</em>.</li>
  <li>When one or more constituent types of <em>I</em> have a construct signature <em>S</em>, <em>I</em> has the apparent construct signature <em>S</em>. The signatures are ordered as a concatenation of the signatures of each constituent type in the order of the constituent types within <em>I</em>.</li>
  <li>When one or more constituent types of <em>I</em> have an apparent string index signature, <em>I</em> has an apparent string index signature of an intersection type of the respective string index signature types.</li>
  <li>When one or more constituent types of <em>I</em> have an apparent numeric index signature, <em>I</em> has an apparent numeric index signature of an intersection type of the respective numeric index signature types.</li>
  </ul>
  </li>
  </ul>
  <p>If a type is not one of the above, it is considered to have no apparent members.</p>
  <p>In effect, a type's apparent members make it a subtype of the 'Object' or 'Function' interface unless the type defines members that are incompatible with those of the 'Object' or 'Function' interface—which, for example, occurs if the type defines a property with the same name as a property in the 'Object' or 'Function' interface but with a type that isn't a subtype of that in the 'Object' or 'Function' interface.</p>
  <p>Some examples:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">o</span>: <span class="pl-smi">Object</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-c1">20</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>         <span class="pl-c">// Ok  </span>
  <span class="pl-k">var</span> <span class="pl-en">f</span>: <span class="pl-smi">Function</span> <span class="pl-c1">=</span> <span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">x</span> <span class="pl-c1">*</span> <span class="pl-s1">x</span><span class="pl-kos">;</span>   <span class="pl-c">// Ok  </span>
  <span class="pl-k">var</span> <span class="pl-s1">err</span>: <span class="pl-smi">Object</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">toString</span>: <span class="pl-c1">0</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>        <span class="pl-c">// Error</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The last assignment is an error because the object literal has a 'toString' method that isn't compatible with that of 'Object'.</p>
  <h3 id="type-and-member-identity-3112" title="3.11.2"> Type and Member Identity</h3><section id="user-content-3.11.2"><p>Two types are considered <em><strong>identical</strong></em> when</p>
  <ul>
  <li>they are both the Any type,</li>
  <li>they are the same primitive type,</li>
  <li>they are the same type parameter,</li>
  <li>they are union types with identical sets of constituent types, or</li>
  <li>they are intersection types with identical sets of constituent types, or</li>
  <li>they are object types with identical sets of members.</li>
  </ul>
  <p>Two members are considered identical when</p>
  <ul>
  <li>they are public properties with identical names, optionality, and types,</li>
  <li>they are private or protected properties originating in the same declaration and having identical types,</li>
  <li>they are identical call signatures,</li>
  <li>they are identical construct signatures, or</li>
  <li>they are index signatures of identical kind with identical types.</li>
  </ul>
  <p>Two call or construct signatures are considered identical when they have the same number of type parameters with identical type parameter constraints and, after substituting type Any for the type parameters introduced by the signatures, identical number of parameters with identical kind (required, optional or rest) and types, and identical return types.</p>
  <p>Note that, except for primitive types and classes with private or protected members, it is structure, not naming, of types that determines identity. Also, note that parameter names are not significant when determining identity of signatures.</p>
  <p>Private and protected properties match only if they originate in the same declaration and have identical types. Two distinct types might contain properties that originate in the same declaration if the types are separate parameterized references to the same generic class. In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">C</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span> <span class="pl-k">private</span> <span class="pl-c1">x</span>: <span class="pl-smi">T</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">X</span> <span class="pl-kos">{</span> <span class="pl-c1">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">Y</span> <span class="pl-kos">{</span> <span class="pl-c1">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">a</span>: <span class="pl-smi">C</span><span class="pl-kos">&lt;</span><span class="pl-smi">X</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">b</span>: <span class="pl-smi">C</span><span class="pl-kos">&lt;</span><span class="pl-smi">Y</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the variables 'a' and 'b' are of identical types because the two type references to 'C' create types with a private member 'x' that originates in the same declaration, and because the two private 'x' members have types with identical sets of members once the type arguments 'X' and 'Y' are substituted.</p>
  </section><h3 id="subtypes-and-supertypes-3113" title="3.11.3"> Subtypes and Supertypes</h3>
  <p><section id="user-content-3.11.3"><em>S</em> is a <em><strong>subtype</strong></em> of a type <em>T</em>, and <em>T</em> is a <em><strong>supertype</strong></em> of <em>S</em>, if <em>S</em> has no excess properties with respect to <em>T</em> (</section><a href="#excess-properties-3115">3.11.5</a>) and one of the following is true:</p>
  <ul>
  <li><em>S</em> and <em>T</em> are identical types.</li>
  <li><em>T</em> is the Any type.</li>
  <li><em>S</em> is the Undefined type.</li>
  <li><em>S</em> is the Null type and <em>T</em> is not the Undefined type.</li>
  <li><em>S</em> is an enum type and <em>T</em> is the primitive type Number.</li>
  <li><em>S</em> is a string literal type and <em>T</em> is the primitive type String.</li>
  <li><em>S</em> is a union type and each constituent type of <em>S</em> is a subtype of <em>T</em>.</li>
  <li><em>S</em> is an intersection type and at least one constituent type of <em>S</em> is a subtype of <em>T</em>.</li>
  <li><em>T</em> is a union type and <em>S</em> is a subtype of at least one constituent type of <em>T</em>.</li>
  <li><em>T</em> is an intersection type and <em>S</em> is a subtype of each constituent type of <em>T</em>.</li>
  <li><em>S</em> is a type parameter and the constraint of <em>S</em> is a subtype of <em>T</em>.</li>
  <li><em>S</em> is an object type, an intersection type, an enum type, or the Number, Boolean, or String primitive type, <em>T</em> is an object type, and for each member <em>M</em> in <em>T</em>, one of the following is true:
  <ul>
  <li><em>M</em> is a property and <em>S</em> has an apparent property <em>N</em> where
  <ul>
  <li><em>M</em> and <em>N</em> have the same name,</li>
  <li>the type of <em>N</em> is a subtype of that of <em>M</em>,</li>
  <li>if <em>M</em> is a required property, <em>N</em> is also a required property, and</li>
  <li><em>M</em> and <em>N</em> are both public, <em>M</em> and <em>N</em> are both private and originate in the same declaration, <em>M</em> and <em>N</em> are both protected and originate in the same declaration, or <em>M</em> is protected and <em>N</em> is declared in a class derived from the class in which <em>M</em> is declared.</li>
  </ul>
  </li>
  <li><em>M</em> is a non-specialized call or construct signature and <em>S</em> has an apparent call or construct signature <em>N</em> where, when <em>M</em> and <em>N</em> are instantiated using type Any as the type argument for all type parameters declared by <em>M</em> and <em>N</em> (if any),
  <ul>
  <li>the signatures are of the same kind (call or construct),</li>
  <li><em>M</em> has a rest parameter or the number of non-optional parameters in <em>N</em> is less than or equal to the total number of parameters in <em>M</em>,</li>
  <li>for parameter positions that are present in both signatures, each parameter type in <em>N</em> is a subtype or supertype of the corresponding parameter type in <em>M</em>, and</li>
  <li>the result type of <em>M</em> is Void, or the result type of <em>N</em> is a subtype of that of <em>M</em>.</li>
  </ul>
  </li>
  <li><em>M</em> is a string index signature of type <em>U</em>, and <em>U</em> is the Any type or <em>S</em> has an apparent string index signature of a type that is a subtype of <em>U</em>.</li>
  <li><em>M</em> is a numeric index signature of type <em>U</em>, and <em>U</em> is the Any type or <em>S</em> has an apparent string or numeric index signature of a type that is a subtype of <em>U</em>.</li>
  </ul>
  </li>
  </ul>
  <p>When comparing call or construct signatures, parameter names are ignored and rest parameters correspond to an unbounded expansion of optional parameters of the rest parameter element type.</p>
  <p>Note that specialized call and construct signatures (section <a href="#specialized-signatures-3924">3.9.2.4</a>) are not significant when determining subtype and supertype relationships.</p>
  <p>Also note that type parameters are not considered object types. Thus, the only subtypes of a type parameter <em>T</em> are <em>T</em> itself and other type parameters that are directly or indirectly constrained to <em>T</em>.</p>
  <h3 id="assignment-compatibility-3114" title="3.11.4"> Assignment Compatibility</h3><section id="user-content-3.11.4"><p>Types are required to be assignment compatible in certain circumstances, such as expression and variable types in assignment statements and argument and parameter types in function calls.</p>
  </section><p><section id="user-content-3.11.4"><em>S</em> is <em><strong>assignable to</strong></em> a type <em>T</em>, and <em>T</em> is <em><strong>assignable from</strong></em> <em>S</em>, if <em>S</em> has no excess properties with respect to <em>T</em> (</section><a href="#excess-properties-3115">3.11.5</a>) and one of the following is true:</p>
  <ul>
  <li><em>S</em> and <em>T</em> are identical types.</li>
  <li><em>S</em> or <em>T</em> is the Any type.</li>
  <li><em>S</em> is the Undefined type.</li>
  <li><em>S</em> is the Null type and <em>T</em> is not the Undefined type.</li>
  <li><em>S</em> or <em>T</em> is an enum type and the other is the primitive type Number.</li>
  <li><em>S</em> is a string literal type and <em>T</em> is the primitive type String.</li>
  <li><em>S</em> is a union type and each constituent type of <em>S</em> is assignable to <em>T</em>.</li>
  <li><em>S</em> is an intersection type and at least one constituent type of <em>S</em> is assignable to <em>T</em>.</li>
  <li><em>T</em> is a union type and <em>S</em> is assignable to at least one constituent type of <em>T</em>.</li>
  <li><em>T</em> is an intersection type and <em>S</em> is assignable to each constituent type of <em>T</em>.</li>
  <li><em>S</em> is a type parameter and the constraint of <em>S</em> is assignable to <em>T</em>.</li>
  <li><em>S</em> is an object type, an intersection type, an enum type, or the Number, Boolean, or String primitive type, <em>T</em> is an object type, and for each member <em>M</em> in <em>T</em>, one of the following is true:
  <ul>
  <li><em>M</em> is a property and <em>S</em> has an apparent property <em>N</em> where
  <ul>
  <li><em>M</em> and <em>N</em> have the same name,</li>
  <li>the type of <em>N</em> is assignable to that of <em>M</em>,</li>
  <li>if <em>M</em> is a required property, <em>N</em> is also a required property, and</li>
  <li><em>M</em> and <em>N</em> are both public, <em>M</em> and <em>N</em> are both private and originate in the same declaration, <em>M</em> and <em>N</em> are both protected and originate in the same declaration, or <em>M</em> is protected and <em>N</em> is declared in a class derived from the class in which <em>M</em> is declared.</li>
  </ul>
  </li>
  <li><em>M</em> is an optional property and <em>S</em> has no apparent property of the same name as <em>M</em>.</li>
  <li><em>M</em> is a non-specialized call or construct signature and <em>S</em> has an apparent call or construct signature <em>N</em> where, when <em>M</em> and <em>N</em> are instantiated using type Any as the type argument for all type parameters declared by <em>M</em> and <em>N</em> (if any),
  <ul>
  <li>the signatures are of the same kind (call or construct),</li>
  <li><em>M</em> has a rest parameter or the number of non-optional parameters in <em>N</em> is less than or equal to the total number of parameters in <em>M</em>,</li>
  <li>for parameter positions that are present in both signatures, each parameter type in <em>N</em> is assignable to or from the corresponding parameter type in <em>M</em>, and</li>
  <li>the result type of <em>M</em> is Void, or the result type of <em>N</em> is assignable to that of <em>M</em>.</li>
  </ul>
  </li>
  <li><em>M</em> is a string index signature of type <em>U</em>, and <em>U</em> is the Any type or <em>S</em> has an apparent string index signature of a type that is assignable to <em>U</em>.</li>
  <li><em>M</em> is a numeric index signature of type <em>U</em>, and <em>U</em> is the Any type or <em>S</em> has an apparent string or numeric index signature of a type that is assignable to <em>U</em>.</li>
  </ul>
  </li>
  </ul>
  <p>When comparing call or construct signatures, parameter names are ignored and rest parameters correspond to an unbounded expansion of optional parameters of the rest parameter element type.</p>
  <p>Note that specialized call and construct signatures (section <a href="#specialized-signatures-3924">3.9.2.4</a>) are not significant when determining assignment compatibility.</p>
  <p>The assignment compatibility and subtyping rules differ only in that</p>
  <ul>
  <li>the Any type is assignable to, but not a subtype of, all types,</li>
  <li>the primitive type Number is assignable to, but not a subtype of, all enum types, and</li>
  <li>an object type without a particular property is assignable to an object type in which that property is optional.</li>
  </ul>
  <p>The assignment compatibility rules imply that, when assigning values or passing parameters, optional properties must either be present and of a compatible type, or not be present at all. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">foo</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-kos">{</span> <span class="pl-c1">id</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-c1">name</span>?: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-kos">}</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>
  
  <span class="pl-en">foo</span><span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">id</span>: <span class="pl-c1">1234</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>                 <span class="pl-c">// Ok  </span>
  <span class="pl-en">foo</span><span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">id</span>: <span class="pl-c1">1234</span><span class="pl-kos">,</span> <span class="pl-c1">name</span>: <span class="pl-s">"hello"</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok  </span>
  <span class="pl-en">foo</span><span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">id</span>: <span class="pl-c1">1234</span><span class="pl-kos">,</span> <span class="pl-c1">name</span>: <span class="pl-c1">false</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>    <span class="pl-c">// Error, name of wrong type  </span>
  <span class="pl-en">foo</span><span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">name</span>: <span class="pl-s">"hello"</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>            <span class="pl-c">// Error, id required but missing</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="excess-properties-3115" title="3.11.5"> Excess Properties</h3><section id="user-content-3.11.5"><p>The subtype and assignment compatibility relationships require that source types have no excess properties with respect to their target types. The purpose of this check is to detect excess or misspelled properties in object literals.</p>
  <p>A source type <em>S</em> is considered to have excess properties with respect to a target type <em>T</em> if</p>
  <ul>
  <li><em>S</em> is a fresh object literal type, as defined below, and</li>
  <li><em>S</em> has one or more properties that aren't expected in <em>T</em>.</li>
  </ul>
  <p>A property <em>P</em> is said to be expected in a type <em>T</em> if one of the following is true:</p>
  <ul>
  <li><em>T</em> is not an object, union, or intersection type.</li>
  <li><em>T</em> is an object type and
  <ul>
  <li><em>T</em> has a property with the same name as <em>P</em>,</li>
  <li><em>T</em> has a string or numeric index signature,</li>
  <li><em>T</em> has no properties, or</li>
  <li><em>T</em> is the global type 'Object'.</li>
  </ul>
  </li>
  <li><em>T</em> is a union or intersection type and <em>P</em> is expected in at least one of the constituent types of <em>T</em>.</li>
  </ul>
  </section><p>The type inferred for an object literal (as described in section <a href="sec-expressions#object-literals-45">4.5</a>) is considered a <em><strong>fresh object literal type</strong></em>. The freshness disappears when an object literal type is widened (<a href="#widened-types-312">3.12</a>) or is the type of the expression in a type assertion (<a href="sec-expressions#type-assertions-416">4.16</a>).</p>
  <p>Consider the following example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">CompilerOptions</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">strict</span>?: <span class="pl-smi">boolean</span><span class="pl-kos">;</span>  
      <span class="pl-c1">sourcePath</span>?: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-c1">targetPath</span>?: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">options</span>: <span class="pl-smi">CompilerOptions</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">strict</span>: <span class="pl-c1">true</span><span class="pl-kos">,</span>  
      <span class="pl-c1">sourcepath</span>: <span class="pl-s">"./src"</span><span class="pl-kos">,</span>  <span class="pl-c">// Error, excess or misspelled property  </span>
      <span class="pl-c1">targetpath</span>: <span class="pl-s">"./bin"</span>   <span class="pl-c">// Error, excess or misspelled property  </span>
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The 'CompilerOptions' type contains only optional properties, so without the excess property check, <em>any</em> object literal would be assignable to the 'options' variable (because a misspelled property would just be considered an excess property of a different name).</p>
  <p>In cases where excess properties are expected, an index signature can be added to the target type as an indicator of intent:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">InputElement</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-c1">visible</span>?: <span class="pl-smi">boolean</span><span class="pl-kos">;</span>  
      <span class="pl-kos">[</span><span class="pl-s1">x</span>: <span class="pl-smi">string</span><span class="pl-kos">]</span>: <span class="pl-smi">any</span><span class="pl-kos">;</span>            <span class="pl-c">// Allow additional properties of any type  </span>
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">address</span>: <span class="pl-smi">InputElement</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">name</span>: <span class="pl-s">"Address"</span><span class="pl-kos">,</span>  
      <span class="pl-c1">visible</span>: <span class="pl-c1">true</span><span class="pl-kos">,</span>  
      <span class="pl-c1">help</span>: <span class="pl-s">"Enter address here"</span><span class="pl-kos">,</span>  <span class="pl-c">// Allowed because of index signature  </span>
      <span class="pl-c1">shortcut</span>: <span class="pl-s">"Alt-A"</span>            <span class="pl-c">// Allowed because of index signature  </span>
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="contextual-signature-instantiation-3116" title="3.11.6"> Contextual Signature Instantiation</h3>
  <p>During type argument inference in a function call (section <a href="sec-expressions#type-argument-inference-4152">4.15.2</a>) it is in certain circumstances necessary to instantiate a generic call signature of an argument expression in the context of a non-generic call signature of a parameter such that further inferences can be made. A generic call signature <em>A</em> is <em><strong>instantiated in the context of</strong></em> non-generic call signature <em>B</em> as follows:</p>
  <ul>
  <li>Using the process described in <a href="#type-inference-3117">3.11.7</a>, inferences for <em>A</em>'s type parameters are made from each parameter type in <em>B</em> to the corresponding parameter type in <em>A</em> for those parameter positions that are present in both signatures, where rest parameters correspond to an unbounded expansion of optional parameters of the rest parameter element type.</li>
  <li>The inferred type argument for each type parameter is the union type of the set of inferences made for that type parameter. However, if the union type does not satisfy the constraint of the type parameter, the inferred type argument is instead the constraint.</li>
  </ul>
  <h3 id="type-inference-3117" title="3.11.7"> Type Inference</h3><section id="user-content-3.11.7"><p>In certain contexts, inferences for a given set of type parameters are made <em>from</em> a type <em>S</em>, in which those type parameters do not occur, <em>to</em> another type <em>T</em>, in which those type parameters do occur. Inferences consist of a set of candidate type arguments collected for each of the type parameters. The inference process recursively relates <em>S</em> and <em>T</em> to gather as many inferences as possible:</p>
  <ul>
  <li>If <em>T</em> is one of the type parameters for which inferences are being made, <em>S</em> is added to the set of inferences for that type parameter.</li>
  <li>Otherwise, if <em>S</em> and <em>T</em> are references to the same generic type, inferences are made from each type argument in <em>S</em> to each corresponding type argument in <em>T</em>.</li>
  <li>Otherwise, if <em>S</em> and <em>T</em> are tuple types with the same number of elements, inferences are made from each element type in <em>S</em> to each corresponding element type in <em>T</em>.</li>
  <li>Otherwise, if <em>T</em> is a union or intersection type:
  <ul>
  <li>First, inferences are made from <em>S</em> to each constituent type in <em>T</em> that isn't simply one of the type parameters for which inferences are being made.</li>
  <li>If the first step produced no inferences then if T is a union type and exactly one constituent type in <em>T</em> is simply a type parameter for which inferences are being made, inferences are made from <em>S</em> to that type parameter.</li>
  </ul>
  </li>
  <li>Otherwise, if <em>S</em> is a union or intersection type, inferences are made from each constituent type in <em>S</em> to <em>T</em>.</li>
  <li>Otherwise, if <em>S</em> and <em>T</em> are object types, then for each member <em>M</em> in <em>T</em>:
  <ul>
  <li>If <em>M</em> is a property and <em>S</em> contains a property <em>N</em> with the same name as <em>M</em>, inferences are made from the type of <em>N</em> to the type of <em>M</em>.</li>
  <li>If <em>M</em> is a call signature and a corresponding call signature <em>N</em> exists in <em>S</em>, <em>N</em> is instantiated with the Any type as an argument for each type parameter (if any) and inferences are made from parameter types in <em>N</em> to the corresponding parameter types in <em>M</em> for positions that are present in both signatures, and from the return type of <em>N</em> to the return type of <em>M</em>.</li>
  <li>If <em>M</em> is a construct signature and a corresponding construct signature <em>N</em> exists in <em>S</em>, <em>N</em> is instantiated with the Any type as an argument for each type parameter (if any) and inferences are made from parameter types in <em>N</em> to the corresponding parameter types in <em>M</em> for positions that are present in both signatures, and from the return type of <em>N</em> to the return type of <em>M</em>.</li>
  <li>If <em>M</em> is a string index signature and <em>S</em> contains a string index signature <em>N</em>, inferences are made from the type of <em>N</em> to the type of <em>M</em>.</li>
  <li>If <em>M</em> is a numeric index signature and <em>S</em> contains a numeric index signature <em>N</em>, inferences are made from the type of <em>N</em> to the type of <em>M</em>.</li>
  <li>If <em>M</em> is a numeric index signature and <em>S</em> contains a string index signature <em>N</em>, inferences are made from the type of <em>N</em> to the type of <em>M</em>.</li>
  </ul>
  </li>
  </ul>
  <p>When comparing call or construct signatures, signatures in <em>S</em> correspond to signatures of the same kind in <em>T</em> pairwise in declaration order. If <em>S</em> and <em>T</em> have different numbers of a given kind of signature, the excess <em>first</em> signatures in declaration order of the longer list are ignored.</p>
  </section><p><section id="user-content-3.11.7"><em>TODO: Update to reflect </em></section><em><a href="https://github.com/Microsoft/TypeScript/pull/5738">improved union and intersection type inference</a></em>.</p>
  <h3 id="recursive-types-3118" title="3.11.8"> Recursive Types</h3><section id="user-content-3.11.8"><p>Classes and interfaces can reference themselves in their internal structure, in effect creating recursive types with infinite nesting. For example, the type</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span> <span class="pl-c1">next</span>: <span class="pl-smi">A</span><span class="pl-kos">;</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>contains an infinitely nested sequence of 'next' properties. Types such as this are perfectly valid but require special treatment when determining type relationships. Specifically, when comparing types <em>S</em> and <em>T</em> for a given relationship (identity, subtype, or assignability), the relationship in question is assumed to be true for every directly or indirectly nested occurrence of the same <em>S</em> and the same <em>T</em> (where same means originating in the same declaration and, if applicable, having identical type arguments). For example, consider the identity relationship between 'A' above and 'B' below:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">B</span> <span class="pl-kos">{</span> <span class="pl-c1">next</span>: <span class="pl-smi">C</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">C</span> <span class="pl-kos">{</span> <span class="pl-c1">next</span>: <span class="pl-smi">D</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">D</span> <span class="pl-kos">{</span> <span class="pl-c1">next</span>: <span class="pl-smi">B</span><span class="pl-kos">;</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>To determine whether 'A' and 'B' are identical, first the 'next' properties of type 'A' and 'C' are compared. That leads to comparing the 'next' properties of type 'A' and 'D', which leads to comparing the 'next' properties of type 'A' and 'B'. Since 'A' and 'B' are already being compared this relationship is by definition true. That in turn causes the other comparisons to be true, and therefore the final result is true.</p>
  <p>When this same technique is used to compare generic type references, two type references are considered the same when they originate in the same declaration and have identical type arguments.</p>
  <p>In certain circumstances, generic types that directly or indirectly reference themselves in a recursive fashion can lead to infinite series of distinct instantiations. For example, in the type</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">List</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">data</span>: <span class="pl-smi">T</span><span class="pl-kos">;</span>  
      <span class="pl-c1">next</span>: <span class="pl-smi">List</span><span class="pl-kos">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>  
      <span class="pl-c1">owner</span>: <span class="pl-smi">List</span><span class="pl-kos">&lt;</span><span class="pl-smi">List</span><span class="pl-kos">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">&gt;</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>'List&lt;T&gt;' has a member 'owner' of type 'List&lt;List&lt;T&gt;&gt;', which has a member 'owner' of type 'List&lt;List&lt;List&lt;T&gt;&gt;&gt;', which has a member 'owner' of type 'List&lt;List&lt;List&lt;List&lt;T&gt;&gt;&gt;&gt;' and so on, ad infinitum. Since type relationships are determined structurally, possibly exploring the constituent types to their full depth, in order to determine type relationships involving infinitely expanding generic types it may be necessary for the compiler to terminate the recursion at some point with the assumption that no further exploration will change the outcome.</p>
  </section><h2 id="widened-types-312" title="3.12"> Widened Types</h2><section id="user-content-3.12"><p>In several situations TypeScript infers types from context, alleviating the need for the programmer to explicitly specify types that appear obvious. For example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">name</span> <span class="pl-c1">=</span> <span class="pl-s">"Steve"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>infers the type of 'name' to be the String primitive type since that is the type of the value used to initialize it. When inferring the type of a variable, property or function result from an expression, the <em><strong>widened</strong></em> form of the source type is used as the inferred type of the target. The widened form of a type is the type in which all occurrences of the Null and Undefined types have been replaced with the type <code>any</code>.</p>
  <p>The following example shows the results of widening types to produce inferred variable types.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">a</span> <span class="pl-c1">=</span> <span class="pl-c1">null</span><span class="pl-kos">;</span>                 <span class="pl-c">// var a: any  </span>
  <span class="pl-k">var</span> <span class="pl-s1">b</span> <span class="pl-c1">=</span> <span class="pl-c1">undefined</span><span class="pl-kos">;</span>            <span class="pl-c">// var b: any  </span>
  <span class="pl-k">var</span> <span class="pl-s1">c</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-c1">null</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>    <span class="pl-c">// var c: { x: number, y: any }  </span>
  <span class="pl-k">var</span> <span class="pl-s1">d</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span> <span class="pl-c1">null</span><span class="pl-kos">,</span> <span class="pl-c1">undefined</span> <span class="pl-kos">]</span><span class="pl-kos">;</span>  <span class="pl-c">// var d: any[]</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <br />
  </section></section>