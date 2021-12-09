<section id="sec-expressions"><h1 id="expressions-4" title="4"> Expressions</h1><section id="user-content-4"><p>This chapter describes the manner in which TypeScript provides type inference and type checking for JavaScript expressions. TypeScript's type analysis occurs entirely at compile-time and adds no run-time overhead to expression evaluation.</p>
  <p>TypeScript's typing rules define a type for every expression construct. For example, the type of the literal 123 is the Number primitive type, and the type of the object literal { a: 10, b: "hello" } is { a: number; b: string; }. The sections in this chapter describe these rules in detail.</p>
  <p>In addition to type inference and type checking, TypeScript augments JavaScript expressions with the following constructs:</p>
  <ul>
  <li>Optional parameter and return type annotations in function expressions and arrow functions.</li>
  <li>Type arguments in function calls.</li>
  <li>Type assertions.</li>
  </ul>
  <p>Unless otherwise noted in the sections that follow, TypeScript expressions and the JavaScript expressions generated from them are identical.</p>
  </section><h2 id="values-and-references-41" title="4.1"> Values and References</h2>
  <p><section id="user-content-4.1"><em><strong>values</strong></em> or <em><strong>references</strong></em>. References are the subset of expressions that are permitted as the target of an assignment. Specifically, references are combinations of identifiers (section </section><a href="#identifiers-43">4.3</a>), parentheses (section <a href="#parentheses-48">4.8</a>), and property accesses (section <a href="#property-access-413">4.13</a>). All other expression constructs described in this chapter are classified as values.</p>
  <h2 id="the-this-keyword-42" title="4.2"> The this Keyword</h2><section id="user-content-4.2"><p>The type of <code>this</code> in an expression depends on the location in which the reference takes place:</p>
  </section><ul>
  <li><section id="user-content-4.2"><code>this</code> is of the this-type (section </section><a href="sec-types#this-types-363">3.6.3</a>) of the containing class.</li>
  <li>In a static member function or static member accessor, the type of <code>this</code> is the constructor function type of the containing class.</li>
  <li>In a function declaration or a function expression, <code>this</code> is of type Any.</li>
  <li>In the global namespace, <code>this</code> is of type Any.</li>
  </ul>
  <p>In all other contexts it is a compile-time error to reference <code>this</code>.</p>
  <p>Note that an arrow function (section <a href="#arrow-functions-411">4.11</a>) has no <code>this</code> parameter but rather preserves the <code>this</code> of its enclosing context.</p>
  <h2 id="identifiers-43" title="4.3"> Identifiers</h2>
  <p><section id="user-content-4.3"><em>IdentifierReference</em>, the expression refers to the most nested namespace, class, enum, function, variable, or parameter with that name whose scope (section </section><a href="sec-basic-concepts#scopes-24">2.4</a>) includes the location of the reference. The type of such an expression is the type associated with the referenced entity:</p>
  <ul>
  <li>For a namespace, the object type associated with the namespace instance.</li>
  <li>For a class, the constructor type associated with the constructor function object.</li>
  <li>For an enum, the object type associated with the enum object.</li>
  <li>For a function, the function type associated with the function object.</li>
  <li>For a variable, the type of the variable.</li>
  <li>For a parameter, the type of the parameter.</li>
  </ul>
  <p>An identifier expression that references a variable or parameter is classified as a reference. An identifier expression that references any other kind of entity is classified as a value (and therefore cannot be the target of an assignment).</p>
  <h2 id="literals-44" title="4.4"> Literals</h2><section id="user-content-4.4"><p>Literals are typed as follows:</p>
  <ul>
  <li>The type of the <code>null</code> literal is the Null primitive type.</li>
  <li>The type of the literals <code>true</code> and <code>false</code> is the Boolean primitive type.</li>
  <li>The type of numeric literals is the Number primitive type.</li>
  <li>The type of string literals is the String primitive type.</li>
  <li>The type of regular expression literals is the global interface type 'RegExp'.</li>
  </ul>
  </section><h2 id="object-literals-45" title="4.5"> Object Literals</h2><section id="user-content-4.5"><p>Object literals are extended to support type annotations in methods and get and set accessors.</p>
  <p>  <em>PropertyDefinition:</em>  <em>( Modified )</em><br />
     <em>IdentifierReference</em><br />
     <em>CoverInitializedName</em><br />
     <em>PropertyName</em> <code>:</code> <em>AssignmentExpression</em><br />
     <em>PropertyName</em> <em>CallSignature</em> <code>{</code> <em>FunctionBody</em> <code>}</code><br />
     <em>GetAccessor</em><br />
     <em>SetAccessor</em></p>
  <p>  <em>GetAccessor:</em><br />
     <code>get</code> <em>PropertyName</em> <code>(</code> <code>)</code> <em>TypeAnnotation<sub>opt</sub></em> <code>{</code> <em>FunctionBody</em> <code>}</code></p>
  <p>  <em>SetAccessor:</em><br />
     <code>set</code> <em>PropertyName</em> <code>(</code> <em>BindingIdentifierOrPattern</em> <em>TypeAnnotation<sub>opt</sub></em> <code>)</code> <code>{</code> <em>FunctionBody</em> <code>}</code></p>
  <p>The type of an object literal is an object type with the set of properties specified by the property assignments in the object literal. A get and set accessor may specify the same property name, but otherwise it is an error to specify multiple property assignments for the same property.</p>
  <p>A shorthand property assignment of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">prop</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre>prop : <span class="pl-s1">prop</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Likewise, a property assignment of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">f</span> <span class="pl-kos">(</span> ... <span class="pl-kos">)</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">f</span> : <span class="pl-k">function</span> <span class="pl-kos">(</span> ... <span class="pl-kos">)</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Each property assignment in an object literal is processed as follows:</p>
  <ul>
  <li>If the object literal is contextually typed and the contextual type contains a property with a matching name, the property assignment is contextually typed by the type of that property.</li>
  <li>Otherwise, if the object literal is contextually typed, if the contextual type contains a numeric index signature, and if the property assignment specifies a numeric property name, the property assignment is contextually typed by the type of the numeric index signature.</li>
  <li>Otherwise, if the object literal is contextually typed and the contextual type contains a string index signature, the property assignment is contextually typed by the type of the string index signature.</li>
  <li>Otherwise, the property assignment is processed without a contextual type.</li>
  </ul>
  <p>The type of a property introduced by a property assignment of the form <em>Name</em> <code>:</code> <em>Expr</em> is the type of <em>Expr</em>.</p>
  </section><p>A get accessor declaration is processed in the same manner as an ordinary function declaration (section <a href="sec-functions#function-declarations-61">6.1</a>) with no parameters. A set accessor declaration is processed in the same manner as an ordinary function declaration with a single parameter and a Void return type. When both a get and set accessor is declared for a property:</p>
  <ul>
  <li>If both accessors include type annotations, the specified types must be identical.</li>
  <li>If only one accessor includes a type annotation, the other behaves as if it had the same type annotation.</li>
  <li>If neither accessor includes a type annotation, the inferred return type of the get accessor becomes the parameter type of the set accessor.</li>
  </ul>
  <p>If a get accessor is declared for a property, the return type of the get accessor becomes the type of the property. If only a set accessor is declared for a property, the parameter type (which may be type Any if no type annotation is present) of the set accessor becomes the type of the property.</p>
  <p>When an object literal is contextually typed by a type that includes a string index signature, the resulting type of the object literal includes a string index signature with the union type of the types of the properties declared in the object literal, or the Undefined type if the object literal is empty. Likewise, when an object literal is contextually typed by a type that includes a numeric index signature, the resulting type of the object literal includes a numeric index signature with the union type of the types of the numerically named properties (section <a href="sec-types#index-signatures-394">3.9.4</a>) declared in the object literal, or the Undefined type if the object literal declares no numerically named properties.</p>
  <p>If the <em>PropertyName</em> of a property assignment is a computed property name that doesn't denote a well-known symbol (<a href="sec-basic-concepts#computed-property-names-223">2.2.3</a>), the construct is considered a <em><strong>dynamic property assignment</strong></em>. The following rules apply to dynamic property assignments:</p>
  <ul>
  <li>A dynamic property assignment does not introduce a property in the type of the object literal.</li>
  <li>The property name expression of a dynamic property assignment must be of type Any or the String, Number, or Symbol primitive type.</li>
  <li>The name associated with a dynamic property assignment is considered to be a numeric property name if the property name expression is of type Any or the Number primitive type.</li>
  </ul>
  <h2 id="array-literals-46" title="4.6"> Array Literals</h2><section id="user-content-4.6"><p>An array literal</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">[</span> <span class="pl-s1">expr1</span><span class="pl-kos">,</span> <span class="pl-s1">expr2</span><span class="pl-kos">,</span> ...<span class="pl-kos">,</span> <span class="pl-s1">exprN</span> <span class="pl-kos">]</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p>denotes a value of an array type (section <a href="sec-types#array-types-332">3.3.2</a>) or a tuple type (section <a href="sec-types#tuple-types-333">3.3.3</a>) depending on context.</p>
  <p>Each element expression in a non-empty array literal is processed as follows:</p>
  <ul>
  <li>If the array literal contains no spread elements, and if the array literal is contextually typed (section <a href="#contextually-typed-expressions-423">4.23</a>) by a type <em>T</em> and <em>T</em> has a property with the numeric name <em>N</em>, where <em>N</em> is the index of the element expression in the array literal, the element expression is contextually typed by the type of that property.</li>
  <li>Otherwise, if the array literal is contextually typed by a type <em>T</em> with a numeric index signature, the element expression is contextually typed by the type of the numeric index signature.</li>
  <li>Otherwise, the element expression is not contextually typed.</li>
  </ul>
  <p>The resulting type an array literal expression is determined as follows:</p>
  <ul>
  <li>If the array literal is empty, the resulting type is an array type with the element type Undefined.</li>
  <li>Otherwise, if the array literal contains no spread elements and is contextually typed by a tuple-like type (section <a href="sec-types#tuple-types-333">3.3.3</a>), the resulting type is a tuple type constructed from the types of the element expressions.</li>
  <li>Otherwise, if the array literal contains no spread elements and is an array assignment pattern in a destructuring assignment (section <a href="#destructuring-assignment-4211">4.21.1</a>), the resulting type is a tuple type constructed from the types of the element expressions.</li>
  <li>Otherwise, the resulting type is an array type with an element type that is the union of the types of the non-spread element expressions and the numeric index signature types of the spread element expressions.</li>
  </ul>
  <p>A spread element must specify an expression of an array-like type (section <a href="sec-types#array-types-332">3.3.2</a>), or otherwise an error occurs.</p>
  <p><em>TODO: The compiler currently doesn't support applying the spread operator to a string (to spread the individual characters of a string into a string array). This will eventually be allowed, but only when the code generation target is ECMAScript 2015 or later</em>.</p>
  <p><em>TODO: Document spreading an <a href="https://github.com/Microsoft/TypeScript/pull/2498">iterator</a> into an array literal</em>.</p>
  <p>The rules above mean that an array literal is always of an array type, unless it is contextually typed by a tuple-like type. For example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">a</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">1</span><span class="pl-kos">,</span> <span class="pl-c1">2</span><span class="pl-kos">]</span><span class="pl-kos">;</span>                          <span class="pl-c">// number[]  </span>
  <span class="pl-k">var</span> <span class="pl-s1">b</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-s">"hello"</span><span class="pl-kos">,</span> <span class="pl-c1">true</span><span class="pl-kos">]</span><span class="pl-kos">;</span>                 <span class="pl-c">// (string | boolean)[]  </span>
  <span class="pl-k">var</span> <span class="pl-s1">c</span>: <span class="pl-kos">[</span><span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-smi">string</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">3</span><span class="pl-kos">,</span> <span class="pl-s">"three"</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  <span class="pl-c">// [number, string]</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>When the output target is ECMAScript 3 or 5, array literals containing spread elements are rewritten to invocations of the <code>concat</code> method. For example, the assignments</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">a</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">2</span><span class="pl-kos">,</span> <span class="pl-c1">3</span><span class="pl-kos">,</span> <span class="pl-c1">4</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">b</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">1</span><span class="pl-kos">,</span> ...<span class="pl-s1">a</span><span class="pl-kos">,</span> <span class="pl-c1">5</span><span class="pl-kos">,</span> <span class="pl-c1">6</span><span class="pl-kos">]</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>are rewritten to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">a</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">2</span><span class="pl-kos">,</span> <span class="pl-c1">3</span><span class="pl-kos">,</span> <span class="pl-c1">4</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">b</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">1</span><span class="pl-kos">]</span><span class="pl-kos">.</span><span class="pl-en">concat</span><span class="pl-kos">(</span><span class="pl-s1">a</span><span class="pl-kos">,</span> <span class="pl-kos">[</span><span class="pl-c1">5</span><span class="pl-kos">,</span> <span class="pl-c1">6</span><span class="pl-kos">]</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h2 id="template-literals-47" title="4.7"> Template Literals</h2>
  <p><section id="user-content-4.7"><em>TODO: </em></section><em><a href="https://github.com/Microsoft/TypeScript/pull/960">Template literals</a></em>.</p>
  <h2 id="parentheses-48" title="4.8"> Parentheses</h2><section id="user-content-4.8"><p>A parenthesized expression</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span> <span class="pl-s1">expr</span> <span class="pl-kos">)</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>has the same type and classification as the contained expression itself. Specifically, if the contained expression is classified as a reference, so is the parenthesized expression.</p>
  </section><h2 id="the-super-keyword-49" title="4.9"> The super Keyword</h2><section id="user-content-4.9"><p>The <code>super</code> keyword can be used in expressions to reference base class properties and the base class constructor.</p>
  </section><h3 id="super-calls-491" title="4.9.1"> Super Calls</h3>
  <p><section id="user-content-4.9.1"><code>super</code> followed by an argument list enclosed in parentheses. Super calls are only permitted in constructors of derived classes, as described in section </section><a href="sec-classes#super-calls-832">8.3.2</a>.</p>
  <p>A super call invokes the constructor of the base class on the instance referenced by <code>this</code>. A super call is processed as a function call (section <a href="#function-calls-415">4.15</a>) using the construct signatures of the base class constructor function type as the initial set of candidate signatures for overload resolution. Type arguments cannot be explicitly specified in a super call. If the base class is a generic class, the type arguments used to process a super call are always those specified in the <code>extends</code> clause that references the base class.</p>
  <p>The type of a super call expression is Void.</p>
  <p>The JavaScript code generated for a super call is specified in section <a href="sec-classes#classes-with-extends-clauses-872">8.7.2</a>.</p>
  <h3 id="super-property-access-492" title="4.9.2"> Super Property Access</h3>
  <p><section id="user-content-4.9.2"><code>super</code> followed by a dot and an identifier. Super property accesses are used to access base class member functions from derived classes and are permitted in contexts where <code>this</code> (section </section><a href="#the-this-keyword-42">4.2</a>) references a derived class instance or a derived class constructor function. Specifically:</p>
  <ul>
  <li>In a constructor, instance member function, instance member accessor, or instance member variable initializer where <code>this</code> references a derived class instance, a super property access is permitted and must specify a public instance member function of the base class.</li>
  <li>In a static member function or static member accessor where <code>this</code> references the constructor function object of a derived class, a super property access is permitted and must specify a public static member function of the base class.</li>
  </ul>
  <p>Super property accesses are not permitted in other contexts, and it is not possible to access other kinds of base class members in a super property access. Note that super property accesses are not permitted inside function expressions nested in the above constructs because <code>this</code> is of type Any in such function expressions.</p>
  <p>Super property accesses are typically used to access overridden base class member functions from derived class member functions. For an example of this, see section <a href="sec-classes#member-function-declarations-842">8.4.2</a>.</p>
  <p>The JavaScript code generated for a super property access is specified in section <a href="sec-classes#classes-with-extends-clauses-872">8.7.2</a>.</p>
  <p><em>TODO: Update section to include <a href="https://github.com/Microsoft/TypeScript/issues/3970">bracket notation in super property access</a></em>.</p>
  <h2 id="function-expressions-410" title="4.10"> Function Expressions</h2><section id="user-content-4.10"><p>Function expressions are extended from JavaScript to optionally include parameter and return type annotations.</p>
  <p>  <em>FunctionExpression:</em>  <em>( Modified )</em><br />
     <code>function</code> <em>BindingIdentifier<sub>opt</sub></em> <em>CallSignature</em> <code>{</code> <em>FunctionBody</em> <code>}</code></p>
  </section><p>The descriptions of function declarations provided in chapter <a href="sec-functions#functions-6">6</a> apply to function expressions as well, except that function expressions do not support overloading.</p>
  <p>The type of a function expression is an object type containing a single call signature with parameter and return types inferred from the function expression's signature and body.</p>
  <p>When a function expression with no type parameters and no parameter type annotations is contextually typed (section <a href="#contextually-typed-expressions-423">4.23</a>) by a type <em>T</em> and a contextual signature <em>S</em> can be extracted from <em>T</em>, the function expression is processed as if it had explicitly specified parameter type annotations as they exist in <em>S</em>. Parameters are matched by position and need not have matching names. If the function expression has fewer parameters than <em>S</em>, the additional parameters in <em>S</em> are ignored. If the function expression has more parameters than <em>S</em>, the additional parameters are all considered to have type Any.</p>
  <p>Likewise, when a function expression with no return type annotation is contextually typed (section <a href="#contextually-typed-expressions-423">4.23</a>) by a function type <em>T</em> and a contextual signature <em>S</em> can be extracted from <em>T</em>, expressions in contained return statements (section <a href="sec-statements#return-statements-510">5.10</a>) are contextually typed by the return type of <em>S</em>.</p>
  <p>A contextual signature <em>S</em> is extracted from a function type <em>T</em> as follows:</p>
  <ul>
  <li>If <em>T</em> is a function type with exactly one call signature, and if that call signature is non-generic, <em>S</em> is that signature.</li>
  <li>If <em>T</em> is a union type, let <em>U</em> be the set of element types in <em>T</em> that have call signatures. If each type in <em>U</em> has exactly one call signature and that call signature is non-generic, and if all of the signatures are identical ignoring return types, then <em>S</em> is a signature with the same parameters and a union of the return types.</li>
  <li>Otherwise, no contextual signature can be extracted from <em>T</em>.</li>
  </ul>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-en">f</span>: <span class="pl-kos">(</span><span class="pl-s1">s</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">string</span> <span class="pl-c1">=</span> <span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-s1">s</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-s1">s</span><span class="pl-kos">.</span><span class="pl-en">toLowerCase</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the function expression is contextually typed by the type of 'f', and since the function expression has no type parameters or type annotations its parameter type information is extracted from the contextual type, thus inferring the type of 's' to be the String primitive type.</p>
  <h2 id="arrow-functions-411" title="4.11"> Arrow Functions</h2><section id="user-content-4.11"><p>Arrow functions are extended from JavaScript to optionally include parameter and return type annotations.</p>
  <p>  <em>ArrowFormalParameters:</em>  <em>( Modified )</em><br />
     <em>CallSignature</em></p>
  </section><p>The descriptions of function declarations provided in chapter <a href="sec-functions#functions-6">6</a> apply to arrow functions as well, except that arrow functions do not support overloading.</p>
  <p>The type of an arrow function is determined in the same manner as a function expression (section <a href="#function-expressions-410">4.10</a>). Likewise, parameters of an arrow function and return statements in the body of an arrow function are contextually typed in the same manner as for function expressions.</p>
  <p>When an arrow function with an expression body and no return type annotation is contextually typed (section <a href="#contextually-typed-expressions-423">4.23</a>) by a function type <em>T</em> and a contextual signature <em>S</em> can be extracted from <em>T</em>, the expression body is contextually typed by the return type of <em>S</em>.</p>
  <p>An arrow function expression of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span> ... <span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">expr</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is exactly equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span> ... <span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span> <span class="pl-k">return</span> <span class="pl-s1">expr</span> <span class="pl-kos">;</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Furthermore, arrow function expressions of the forms</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">id</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span>  
  <span class="pl-s1">id</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">expr</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>are exactly equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span> <span class="pl-s1">id</span> <span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span>  
  <span class="pl-kos">(</span> <span class="pl-s1">id</span> <span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">expr</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Thus, the following examples are all equivalent:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span> <span class="pl-k">return</span> <span class="pl-smi">Math</span><span class="pl-kos">.</span><span class="pl-en">sin</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">Math</span><span class="pl-kos">.</span><span class="pl-en">sin</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span>  
  <span class="pl-s1">x</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span> <span class="pl-k">return</span> <span class="pl-smi">Math</span><span class="pl-kos">.</span><span class="pl-en">sin</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
  <span class="pl-s1">x</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">Math</span><span class="pl-kos">.</span><span class="pl-en">sin</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>A function expression introduces a new dynamically bound <code>this</code>, whereas an arrow function expression preserves the <code>this</code> of its enclosing context. Arrow function expressions are particularly useful for writing callbacks, which otherwise often have an undefined or unexpected <code>this</code>.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Messenger</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">message</span> <span class="pl-c1">=</span> <span class="pl-s">"Hello World"</span><span class="pl-kos">;</span>  
      <span class="pl-en">start</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-en">setTimeout</span><span class="pl-kos">(</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-en">alert</span><span class="pl-kos">(</span><span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">message</span><span class="pl-kos">)</span><span class="pl-kos">,</span> <span class="pl-c1">3000</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">messenger</span> <span class="pl-c1">=</span> <span class="pl-k">new</span> <span class="pl-smi">Messenger</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-s1">messenger</span><span class="pl-kos">.</span><span class="pl-en">start</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the use of an arrow function expression causes the callback to have the same <code>this</code> as the surrounding 'start' method. Writing the callback as a standard function expression it becomes necessary to manually arrange access to the surrounding <code>this</code>, for example by copying it into a local variable:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Messenger</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">message</span> <span class="pl-c1">=</span> <span class="pl-s">"Hello World"</span><span class="pl-kos">;</span>  
      <span class="pl-en">start</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">var</span> <span class="pl-s1">_this</span> <span class="pl-c1">=</span> <span class="pl-smi">this</span><span class="pl-kos">;</span>  
          <span class="pl-en">setTimeout</span><span class="pl-kos">(</span><span class="pl-k">function</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-en">alert</span><span class="pl-kos">(</span><span class="pl-s1">_this</span><span class="pl-kos">.</span><span class="pl-c1">message</span><span class="pl-kos">)</span><span class="pl-kos">;</span> <span class="pl-kos">}</span><span class="pl-kos">,</span> <span class="pl-c1">3000</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">messenger</span> <span class="pl-c1">=</span> <span class="pl-k">new</span> <span class="pl-smi">Messenger</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-s1">messenger</span><span class="pl-kos">.</span><span class="pl-en">start</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The TypeScript compiler applies this type of transformation to rewrite arrow function expressions into standard function expressions.</p>
  <p>A construct of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span> <span class="pl-smi">T</span> <span class="pl-c1">&gt;</span> <span class="pl-kos">(</span> ... <span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>could be parsed as an arrow function expression with a type parameter or a type assertion applied to an arrow function with no type parameter. It is resolved as the former, but parentheses can be used to select the latter meaning:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">&lt;</span> <span class="pl-smi">T</span> <span class="pl-kos">&gt;</span> <span class="pl-kos">(</span> <span class="pl-kos">(</span> ... <span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span> <span class="pl-kos">)</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h2 id="class-expressions-412" title="4.12"> Class Expressions</h2>
  <p><section id="user-content-4.12"><em>TODO: Document </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/497">class expressions</a></em>.</p>
  <h2 id="property-access-413" title="4.13"> Property Access</h2><section id="user-content-4.13"><p>A property access uses either dot notation or bracket notation. A property access expression is always classified as a reference.</p>
  <p>A dot notation property access of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">object</span> <span class="pl-kos">.</span> <span class="pl-c1">name</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>object</em> is an expression and <em>name</em> is an identifier (including, possibly, a reserved word), is used to access the property with the given name on the given object. A dot notation property access is processed as follows at compile-time:</p>
  </section><ul><section id="user-content-4.13"><li>If <em>object</em> is of type Any, any <em>name</em> is permitted and the property access is of type Any.</li>
  </section><li><section id="user-content-4.13"><em>name</em> denotes an accessible apparent property (section </section><a href="sec-types#apparent-members-3111">3.11.1</a>) in the widened type (section <a href="sec-types#widened-types-312">3.12</a>) of <em>object</em>, the property access is of the type of that property. Public members are always accessible, but private and protected members of a class have restricted accessibility, as described in <a href="sec-classes#accessibility-822">8.2.2</a>.</li>
  <li>Otherwise, the property access is invalid and a compile-time error occurs.</li>
  </ul>
  <p>A bracket notation property access of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">object</span> <span class="pl-kos">[</span> <span class="pl-s1">index</span> <span class="pl-kos">]</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>object</em> and <em>index</em> are expressions, is used to access the property with the name computed by the index expression on the given object. A bracket notation property access is processed as follows at compile-time:</p>
  <ul>
  <li>If <em>index</em> is a string literal or a numeric literal and <em>object</em> has an apparent property (section <a href="sec-types#apparent-members-3111">3.11.1</a>) with the name given by that literal (converted to its string representation in the case of a numeric literal), the property access is of the type of that property.</li>
  <li>Otherwise, if <em>object</em> has an apparent numeric index signature and <em>index</em> is of type Any, the Number primitive type, or an enum type, the property access is of the type of that index signature.</li>
  <li>Otherwise, if <em>object</em> has an apparent string index signature and <em>index</em> is of type Any, the String or Number primitive type, or an enum type, the property access is of the type of that index signature.</li>
  <li>Otherwise, if <em>index</em> is of type Any, the String or Number primitive type, or an enum type, the property access is of type Any.</li>
  <li>Otherwise, the property access is invalid and a compile-time error occurs.</li>
  </ul>
  <p><em>TODO: Indexing with <a href="https://github.com/Microsoft/TypeScript/pull/1978">symbols</a></em>.</p>
  <p>The rules above mean that properties are strongly typed when accessed using bracket notation with the literal representation of their name. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">type</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">name</span>: <span class="pl-s">"boolean"</span><span class="pl-kos">,</span>  
      <span class="pl-c1">primitive</span>: <span class="pl-c1">true</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">s</span> <span class="pl-c1">=</span> <span class="pl-s1">type</span><span class="pl-kos">[</span><span class="pl-s">"name"</span><span class="pl-kos">]</span><span class="pl-kos">;</span>       <span class="pl-c">// string  </span>
  <span class="pl-k">var</span> <span class="pl-s1">b</span> <span class="pl-c1">=</span> <span class="pl-s1">type</span><span class="pl-kos">[</span><span class="pl-s">"primitive"</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  <span class="pl-c">// boolean</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Tuple types assign numeric names to each of their elements and elements are therefore strongly typed when accessed using bracket notation with a numeric literal:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">data</span>: <span class="pl-kos">[</span><span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-smi">number</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-s">"five"</span><span class="pl-kos">,</span> <span class="pl-c1">5</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">s</span> <span class="pl-c1">=</span> <span class="pl-s1">data</span><span class="pl-kos">[</span><span class="pl-c1">0</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  <span class="pl-c">// string  </span>
  <span class="pl-k">var</span> <span class="pl-s1">n</span> <span class="pl-c1">=</span> <span class="pl-s1">data</span><span class="pl-kos">[</span><span class="pl-c1">1</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  <span class="pl-c">// number</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h2 id="the-new-operator-414" title="4.14"> The new Operator</h2><section id="user-content-4.14"><p>A <code>new</code> operation has one of the following forms:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">new</span> <span class="pl-smi">C</span>  
  <span class="pl-k">new</span> <span class="pl-smi">C</span> <span class="pl-kos">(</span> ... <span class="pl-kos">)</span>  
  <span class="pl-k">new</span> <span class="pl-smi">C</span> <span class="pl-c1">&lt;</span> ... <span class="pl-c1">&gt;</span> <span class="pl-kos">(</span> ... <span class="pl-kos">)</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>C</em> is an expression. The first form is equivalent to supplying an empty argument list. <em>C</em> must be of type Any or of an object type with one or more construct or call signatures. The operation is processed as follows at compile-time:</p>
  </section><ul><section id="user-content-4.14"><li>If <em>C</em> is of type Any, any argument list is permitted and the result of the operation is of type Any.</li>
  </section><li><section id="user-content-4.14"><em>C</em> has one or more apparent construct signatures (section </section><a href="sec-types#apparent-members-3111">3.11.1</a>), the expression is processed in the same manner as a function call, but using the construct signatures as the initial set of candidate signatures for overload resolution. The result type of the function call becomes the result type of the operation.</li>
  <li>If <em>C</em> has no apparent construct signatures but one or more apparent call signatures, the expression is processed as a function call. A compile-time error occurs if the result of the function call is not Void. The type of the result of the operation is Any.</li>
  </ul>
  <h2 id="function-calls-415" title="4.15"> Function Calls</h2><section id="user-content-4.15"><p>Function calls are extended from JavaScript to support optional type arguments.</p>
  <p>  <em>Arguments:</em>  <em>( Modified )</em><br />
     <em>TypeArguments<sub>opt</sub></em> <code>(</code> <em>ArgumentList<sub>opt</sub></em> <code>)</code></p>
  <p>A function call takes one of the forms</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">func</span> <span class="pl-kos">(</span> ... <span class="pl-kos">)</span>  
  <span class="pl-s1">func</span> <span class="pl-c1">&lt;</span> ... <span class="pl-c1">&gt;</span> <span class="pl-kos">(</span> ... <span class="pl-kos">)</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p><section id="user-content-4.15"><em>func</em> is an expression of a function type or of type Any. The function expression is followed by an optional type argument list (section </section><a href="sec-types#type-argument-lists-362">3.6.2</a>) and an argument list.</p>
  <p>If <em>func</em> is of type Any, or of an object type that has no call or construct signatures but is a subtype of the Function interface, the call is an <em><strong>untyped function call</strong></em>. In an untyped function call no type arguments are permitted, argument expressions can be of any type and number, no contextual types are provided for the argument expressions, and the result is always of type Any.</p>
  <p>If <em>func</em> has apparent call signatures (section <a href="sec-types#apparent-members-3111">3.11.1</a>) the call is a <em><strong>typed function call</strong></em>. TypeScript employs <em><strong>overload resolution</strong></em> in typed function calls in order to support functions with multiple call signatures. Furthermore, TypeScript may perform <em><strong>type argument inference</strong></em> to automatically determine type arguments in generic function calls.</p>
  <h3 id="overload-resolution-4151" title="4.15.1"> Overload Resolution</h3><section id="user-content-4.15.1"><p>The purpose of overload resolution in a function call is to ensure that at least one signature is applicable, to provide contextual types for the arguments, and to determine the result type of the function call, which could differ between the multiple applicable signatures. Overload resolution has no impact on the run-time behavior of a function call. Since JavaScript doesn't support function overloading, all that matters at run-time is the name of the function.</p>
  </section><p><section id="user-content-4.15.1"><em>TODO: Describe use of </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/3970">wildcard function types</a> in overload resolution</em>.</p>
  <p>The compile-time processing of a typed function call consists of the following steps:</p>
  <ul>
  <li>First, a list of candidate signatures is constructed from the call signatures in the function type in declaration order. For classes and interfaces, inherited signatures are considered to follow explicitly declared signatures in <code>extends</code> clause order.
  <ul>
  <li>A non-generic signature is a candidate when
  <ul>
  <li>the function call has no type arguments, and</li>
  <li>the signature is applicable with respect to the argument list of the function call.</li>
  </ul>
  </li>
  <li>A generic signature is a candidate in a function call without type arguments when
  <ul>
  <li>type inference (section <a href="#type-argument-inference-4152">4.15.2</a>) succeeds for each type parameter,</li>
  <li>once the inferred type arguments are substituted for their associated type parameters, the signature is applicable with respect to the argument list of the function call.</li>
  </ul>
  </li>
  <li>A generic signature is a candidate in a function call with type arguments when
  <ul>
  <li>The signature has the same number of type parameters as were supplied in the type argument list,</li>
  <li>the type arguments satisfy their constraints, and</li>
  <li>once the type arguments are substituted for their associated type parameters, the signature is applicable with respect to the argument list of the function call.</li>
  </ul>
  </li>
  </ul>
  </li>
  <li>If the list of candidate signatures is empty, the function call is an error.</li>
  <li>Otherwise, if the candidate list contains one or more signatures for which the type of each argument expression is a subtype of each corresponding parameter type, the return type of the first of those signatures becomes the return type of the function call.</li>
  <li>Otherwise, the return type of the first signature in the candidate list becomes the return type of the function call.</li>
  </ul>
  <p>A signature is said to be an <em><strong>applicable signature</strong></em> with respect to an argument list when</p>
  <ul>
  <li>the number of arguments is not less than the number of required parameters,</li>
  <li>the number of arguments is not greater than the number of parameters, and</li>
  <li>for each argument expression <em>e</em> and its corresponding parameter <em>P,</em> when <em>e</em> is contextually typed (section <a href="#contextually-typed-expressions-423">4.23</a>) by the type of <em>P</em>, no errors ensue and the type of <em>e</em> is assignable to (section <a href="sec-types#assignment-compatibility-3114">3.11.4</a>) the type of <em>P</em>.</li>
  </ul>
  <p><em>TODO: <a href="https://github.com/Microsoft/TypeScript/pull/1931">Spread operator in function calls</a> and spreading an <a href="https://github.com/Microsoft/TypeScript/pull/2498">iterator</a> into a function call</em>.</p>
  <h3 id="type-argument-inference-4152" title="4.15.2"> Type Argument Inference</h3><section id="user-content-4.15.2"><p>Given a signature &lt; <em>T<sub>1</sub></em> , <em>T<sub>2</sub></em> , … , <em>T<sub>n</sub></em> &gt; ( <em>p<sub>1</sub></em> : <em>P<sub>1</sub></em> , <em>p<sub>2</sub></em> : <em>P<sub>2</sub></em> , … , <em>p<sub>m</sub></em> : <em>P<sub>m</sub></em> ), where each parameter type <em>P</em> references zero or more of the type parameters <em>T</em>, and an argument list ( <em>e<sub>1</sub></em> , <em>e<sub>2</sub></em> , … , <em>e<sub>m</sub></em> ), the task of type argument inference is to find a set of type arguments <em>A<sub>1</sub></em>…<em>A<sub>n</sub></em> to substitute for <em>T<sub>1</sub></em>…<em>T<sub>n</sub></em> such that the argument list becomes an applicable signature.</p>
  </section><p><section id="user-content-4.15.2"><em>TODO: Update </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/1186">type argument inference and overload resolution rules</a></em>.</p>
  <p>Type argument inference produces a set of candidate types for each type parameter. Given a type parameter <em>T</em> and set of candidate types, the actual inferred type argument is determined as follows:</p>
  <ul>
  <li>If the set of candidate argument types is empty, the inferred type argument for <em>T</em> is <em>T</em>'s constraint.</li>
  <li>Otherwise, if at least one of the candidate types is a supertype of all of the other candidate types, let <em>C</em> denote the widened form (section <a href="sec-types#widened-types-312">3.12</a>) of the first such candidate type. If <em>C</em> satisfies <em>T</em>'s constraint, the inferred type argument for <em>T</em> is <em>C</em>. Otherwise, the inferred type argument for <em>T</em> is <em>T</em>'s constraint.</li>
  <li>Otherwise, if no candidate type is a supertype of all of the other candidate types, type inference has fails and no type argument is inferred for <em>T</em>.</li>
  </ul>
  <p>In order to compute candidate types, the argument list is processed as follows:</p>
  <ul>
  <li>Initially all inferred type arguments are considered <em><strong>unfixed</strong></em> with an empty set of candidate types.</li>
  <li>Proceeding from left to right, each argument expression <em>e</em> is <em><strong>inferentially typed</strong></em> by its corresponding parameter type <em>P</em>, possibly causing some inferred type arguments to become <em><strong>fixed</strong></em>, and candidate type inferences (section <a href="sec-types#type-inference-3117">3.11.7</a>) are made for unfixed inferred type arguments from the type computed for <em>e</em> to <em>P</em>.</li>
  </ul>
  <p>The process of inferentially typing an expression <em>e</em> by a type <em>T</em> is the same as that of contextually typing <em>e</em> by <em>T</em>, with the following exceptions:</p>
  <ul>
  <li>Where expressions contained within <em>e</em> would be contextually typed, they are instead inferentially typed.</li>
  <li>When a function expression is inferentially typed (section <a href="#function-expressions-410">4.10</a>) and a type assigned to a parameter in that expression references type parameters for which inferences are being made, the corresponding inferred type arguments to become <em><strong>fixed</strong></em> and no further candidate inferences are made for them.</li>
  <li>If <em>e</em> is an expression of a function type that contains exactly one generic call signature and no other members, and <em>T</em> is a function type with exactly one non-generic call signature and no other members, then any inferences made for type parameters referenced by the parameters of <em>T</em>'s call signature are <em><strong>fixed</strong></em>, and <em>e</em>'s type is changed to a function type with <em>e</em>'s call signature instantiated in the context of <em>T</em>'s call signature (section <a href="sec-types#contextual-signature-instantiation-3116">3.11.6</a>).</li>
  </ul>
  <p>An example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">choose</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span>: <span class="pl-smi">T</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-smi">Math</span><span class="pl-kos">.</span><span class="pl-en">random</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">&lt;</span> <span class="pl-c1">0.5</span> ? <span class="pl-s1">x</span> : <span class="pl-s1">y</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-en">choose</span><span class="pl-kos">(</span><span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-c1">20</span><span class="pl-kos">)</span><span class="pl-kos">;</span>     <span class="pl-c">// Ok, x of type number  </span>
  <span class="pl-k">var</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-en">choose</span><span class="pl-kos">(</span><span class="pl-s">"Five"</span><span class="pl-kos">,</span> <span class="pl-c1">5</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Error</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the first call to 'choose', two inferences are made from 'number' to 'T', one for each parameter. Thus, 'number' is inferred for 'T' and the call is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-en">choose</span><span class="pl-kos">&lt;</span><span class="pl-smi">number</span><span class="pl-kos">&gt;</span><span class="pl-kos">(</span><span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-c1">20</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the second call to 'choose', an inference is made from type 'string' to 'T' for the first parameter and an inference is made from type 'number' to 'T' for the second parameter. Since neither 'string' nor 'number' is a supertype of the other, type inference fails. That in turn means there are no applicable signatures and the function call is an error.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">map</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-smi">U</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-s1">f</span>: <span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">U</span><span class="pl-kos">)</span>: <span class="pl-smi">U</span><span class="pl-kos">[</span><span class="pl-kos">]</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">result</span>: <span class="pl-smi">U</span><span class="pl-kos">[</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
      <span class="pl-k">for</span> <span class="pl-kos">(</span><span class="pl-k">var</span> <span class="pl-s1">i</span> <span class="pl-c1">=</span> <span class="pl-c1">0</span><span class="pl-kos">;</span> <span class="pl-s1">i</span> <span class="pl-c1">&lt;</span> <span class="pl-s1">a</span><span class="pl-kos">.</span><span class="pl-c1">length</span><span class="pl-kos">;</span> <span class="pl-s1">i</span><span class="pl-c1">++</span><span class="pl-kos">)</span> <span class="pl-s1">result</span><span class="pl-kos">.</span><span class="pl-en">push</span><span class="pl-kos">(</span><span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">a</span><span class="pl-kos">[</span><span class="pl-s1">i</span><span class="pl-kos">]</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-k">return</span> <span class="pl-s1">result</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">names</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-s">"Peter"</span><span class="pl-kos">,</span> <span class="pl-s">"Paul"</span><span class="pl-kos">,</span> <span class="pl-s">"Mary"</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">lengths</span> <span class="pl-c1">=</span> <span class="pl-en">map</span><span class="pl-kos">(</span><span class="pl-s1">names</span><span class="pl-kos">,</span> <span class="pl-s1">s</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">s</span><span class="pl-kos">.</span><span class="pl-c1">length</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>inferences for 'T' and 'U' in the call to 'map' are made as follows: For the first parameter, inferences are made from the type 'string[]' (the type of 'names') to the type 'T[]', inferring 'string' for 'T'. For the second parameter, inferential typing of the arrow expression 's =&gt; s.length' causes 'T' to become fixed such that the inferred type 'string' can be used for the parameter 's'. The return type of the arrow expression can then be determined, and inferences are made from the type '(s: string) =&gt; number' to the type '(x: T) =&gt; U', inferring 'number' for 'U'. Thus the call to 'map' is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">lengths</span> <span class="pl-c1">=</span> <span class="pl-en">map</span><span class="pl-kos">&lt;</span><span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-smi">number</span><span class="pl-kos">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">names</span><span class="pl-kos">,</span> <span class="pl-s1">s</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">s</span><span class="pl-kos">.</span><span class="pl-c1">length</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>and the resulting type of 'lengths' is therefore 'number[]'.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">zip</span><span class="pl-c1">&lt;</span><span class="pl-smi">S</span><span class="pl-kos">,</span> <span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-smi">U</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">S</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-s1">combine</span>: <span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">S</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">(</span><span class="pl-s1">y</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">U</span><span class="pl-kos">)</span>: <span class="pl-smi">U</span><span class="pl-kos">[</span><span class="pl-kos">]</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">len</span> <span class="pl-c1">=</span> <span class="pl-smi">Math</span><span class="pl-kos">.</span><span class="pl-en">max</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">.</span><span class="pl-c1">length</span><span class="pl-kos">,</span> <span class="pl-s1">y</span><span class="pl-kos">.</span><span class="pl-c1">length</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-k">var</span> <span class="pl-s1">result</span>: <span class="pl-smi">U</span><span class="pl-kos">[</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
      <span class="pl-k">for</span> <span class="pl-kos">(</span><span class="pl-k">var</span> <span class="pl-s1">i</span> <span class="pl-c1">=</span> <span class="pl-c1">0</span><span class="pl-kos">;</span> <span class="pl-s1">i</span> <span class="pl-c1">&lt;</span> <span class="pl-s1">len</span><span class="pl-kos">;</span> <span class="pl-s1">i</span><span class="pl-c1">++</span><span class="pl-kos">)</span> <span class="pl-s1">result</span><span class="pl-kos">.</span><span class="pl-en">push</span><span class="pl-kos">(</span><span class="pl-en">combine</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">[</span><span class="pl-s1">i</span><span class="pl-kos">]</span><span class="pl-kos">)</span><span class="pl-kos">(</span><span class="pl-s1">y</span><span class="pl-kos">[</span><span class="pl-s1">i</span><span class="pl-kos">]</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-k">return</span> <span class="pl-s1">result</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">names</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-s">"Peter"</span><span class="pl-kos">,</span> <span class="pl-s">"Paul"</span><span class="pl-kos">,</span> <span class="pl-s">"Mary"</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">ages</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">7</span><span class="pl-kos">,</span> <span class="pl-c1">9</span><span class="pl-kos">,</span> <span class="pl-c1">12</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">pairs</span> <span class="pl-c1">=</span> <span class="pl-en">zip</span><span class="pl-kos">(</span><span class="pl-s1">names</span><span class="pl-kos">,</span> <span class="pl-s1">ages</span><span class="pl-kos">,</span> <span class="pl-s1">s</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">n</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">name</span>: <span class="pl-s1">s</span><span class="pl-kos">,</span> <span class="pl-c1">age</span>: <span class="pl-s1">n</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>inferences for 'S', 'T' and 'U' in the call to 'zip' are made as follows: Using the first two parameters, inferences of 'string' for 'S' and 'number' for 'T' are made. For the third parameter, inferential typing of the outer arrow expression causes 'S' to become fixed such that the inferred type 'string' can be used for the parameter 's'. When a function expression is inferentially typed, its return expression(s) are also inferentially typed. Thus, the inner arrow function is inferentially typed, causing 'T' to become fixed such that the inferred type 'number' can be used for the parameter 'n'. The return type of the inner arrow function can then be determined, which in turn determines the return type of the function returned from the outer arrow function, and inferences are made from the type '(s: string) =&gt; (n: number) =&gt; { name: string; age: number }' to the type '(x: S) =&gt; (y: T) =&gt; R', inferring '{ name: string; age: number }' for 'R'. Thus the call to 'zip' is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">pairs</span> <span class="pl-c1">=</span> <span class="pl-en">zip</span><span class="pl-kos">&lt;</span><span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-kos">{</span> <span class="pl-c1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-c1">age</span>: <span class="pl-smi">number</span> <span class="pl-kos">}</span><span class="pl-kos">&gt;</span><span class="pl-kos">(</span>  
      <span class="pl-s1">names</span><span class="pl-kos">,</span> <span class="pl-s1">ages</span><span class="pl-kos">,</span> <span class="pl-s1">s</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">n</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">name</span>: <span class="pl-s1">s</span><span class="pl-kos">,</span> <span class="pl-c1">age</span>: <span class="pl-s1">n</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>and the resulting type of 'pairs' is therefore '{ name: string; age: number }[]'.</p>
  <h3 id="grammar-ambiguities-4153" title="4.15.3"> Grammar Ambiguities</h3>
  <p><section id="user-content-4.15.3"><em>Arguments</em> production (section </section><a href="#function-calls-415">4.15</a>) gives rise to certain ambiguities in the grammar for expressions. For example, the statement</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-en">g</span><span class="pl-kos">&lt;</span><span class="pl-smi">A</span><span class="pl-kos">,</span> <span class="pl-smi">B</span><span class="pl-kos">&gt;</span><span class="pl-kos">(</span><span class="pl-c1">7</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>could be interpreted as  a call to 'f' with two arguments, 'g &lt; A' and 'B &gt; (7)'. Alternatively, it could be interpreted as a call to 'f' with one argument, which is a call to a generic function 'g' with two type arguments and one regular argument.</p>
  <p>The grammar ambiguity is resolved as follows: In a context where one possible interpretation of a sequence of tokens is an <em>Arguments</em> production, if the initial sequence of tokens forms a syntactically correct <em>TypeArguments</em> production and is followed by a '<code>(</code>' token, then the sequence of tokens is processed an <em>Arguments</em> production, and any other possible interpretation is discarded. Otherwise, the sequence of tokens is not considered an <em>Arguments</em> production.</p>
  <p>This rule means that the call to 'f' above is interpreted as a call with one argument, which is a call to a generic function 'g' with two type arguments and one regular argument. However, the statements</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">g</span> <span class="pl-c1">&lt;</span> <span class="pl-smi">A</span><span class="pl-kos">,</span> <span class="pl-smi">B</span> <span class="pl-c1">&gt;</span> <span class="pl-c1">7</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">g</span> <span class="pl-c1">&lt;</span> <span class="pl-smi">A</span><span class="pl-kos">,</span> <span class="pl-smi">B</span> <span class="pl-c1">&gt;</span> <span class="pl-c1">+</span><span class="pl-kos">(</span><span class="pl-c1">7</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>are both interpreted as calls to 'f' with two arguments.</p>
  <h2 id="type-assertions-416" title="4.16"> Type Assertions</h2><section id="user-content-4.16"><p>TypeScript extends the JavaScript expression grammar with the ability to assert a type for an expression:</p>
  <p>  <em>UnaryExpression:</em>  <em>( Modified )</em><br />
     …<br />
     <code>&lt;</code> <em>Type</em> <code>&gt;</code> <em>UnaryExpression</em></p>
  <p>A type assertion expression consists of a type enclosed in <code>&lt;</code> and <code>&gt;</code> followed by a unary expression. Type assertion expressions are purely a compile-time construct. Type assertions are <em>not</em> checked at run-time and have no impact on the emitted JavaScript (and therefore no run-time cost). The type and the enclosing <code>&lt;</code> and <code>&gt;</code> are simply removed from the generated code.</p>
  </section><p><section id="user-content-4.16"><em>T</em> &gt; <em>e</em>, <em>e</em> is contextually typed (section </section><a href="#contextually-typed-expressions-423">4.23</a>) by <em>T</em> and the resulting type of* e* is required to be assignable to <em>T</em>, or <em>T</em> is required to be assignable to the widened form of the resulting type of <em>e</em>, or otherwise a compile-time error occurs. The type of the result is <em>T</em>.</p>
  <p>Type assertions check for assignment compatibility in both directions. Thus, type assertions allow type conversions that <em>might</em> be correct, but aren't <em>known</em> to be correct. In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Shape</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">Circle</span> <span class="pl-k">extends</span> <span class="pl-smi">Shape</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-en">createShape</span><span class="pl-kos">(</span><span class="pl-s1">kind</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">Shape</span> <span class="pl-kos">{</span>  
      <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">kind</span> <span class="pl-c1">===</span> <span class="pl-s">"circle"</span><span class="pl-kos">)</span> <span class="pl-k">return</span> <span class="pl-k">new</span> <span class="pl-smi">Circle</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      ...  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">circle</span> <span class="pl-c1">=</span> <span class="pl-kos">&lt;</span><span class="pl-smi">Circle</span><span class="pl-kos">&gt;</span> <span class="pl-en">createShape</span><span class="pl-kos">(</span><span class="pl-s">"circle"</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the type annotations indicate that the 'createShape' function <em>might</em> return a 'Circle' (because 'Circle' is a subtype of 'Shape'), but isn't <em>known</em> to do so (because its return type is 'Shape'). Therefore, a type assertion is needed to treat the result as a 'Circle'.</p>
  <p>As mentioned above, type assertions are not checked at run-time and it is up to the programmer to guard against errors, for example using the <code>instanceof</code> operator:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">shape</span> <span class="pl-c1">=</span> <span class="pl-en">createShape</span><span class="pl-kos">(</span><span class="pl-s1">shapeKind</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">shape</span> <span class="pl-k">instanceof</span> <span class="pl-smi">Circle</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">circle</span> <span class="pl-c1">=</span> <span class="pl-kos">&lt;</span><span class="pl-smi">Circle</span><span class="pl-kos">&gt;</span> <span class="pl-s1">shape</span><span class="pl-kos">;</span>  
      ...  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p><em>TODO: Document <a href="https://github.com/Microsoft/TypeScript/pull/3564">as operator</a></em>.</p>
  <h2 id="jsx-expressions-417" title="4.17"> JSX Expressions</h2>
  <p><section id="user-content-4.17"><em>TODO: Document </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/3203">JSX expressions</a></em>.</p>
  <h2 id="unary-operators-418" title="4.18"> Unary Operators</h2><section id="user-content-4.18"><p>The subsections that follow specify the compile-time processing rules of the unary operators. In general, if the operand of a unary operator does not meet the stated requirements, a compile-time error occurs and the result of the operation defaults to type Any in further processing.</p>
  </section><h3 id="the--and----operators-4181" title="4.18.1"> The ++ and -- operators</h3>
  <p>These operators, in prefix or postfix form, require their operand to be of type Any, the Number primitive type, or an enum type, and classified as a reference (section <a href="#values-and-references-41">4.1</a>). They produce a result of the Number primitive type.</p>
  <h3 id="the---and--operators-4182" title="4.18.2"> The +, –, and ~ operators</h3><section id="user-content-4.18.2"><p>These operators permit their operand to be of any type and produce a result of the Number primitive type.</p>
  <p>The unary + operator can conveniently be used to convert a value of any type to the Number primitive type:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">getValue</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">n</span> <span class="pl-c1">=</span> <span class="pl-c1">+</span><span class="pl-en">getValue</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The example above converts the result of 'getValue()' to a number if it isn't a number already. The type inferred for 'n' is the Number primitive type regardless of the return type of 'getValue'.</p>
  </section><h3 id="the--operator-4183" title="4.18.3"> The ! operator</h3><section id="user-content-4.18.3"><p>The ! operator permits its operand to be of any type and produces a result of the Boolean primitive type.</p>
  <p>Two unary ! operators in sequence can conveniently be used to convert a value of any type to the Boolean primitive type:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">getValue</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">b</span> <span class="pl-c1">=</span> <span class="pl-c1">!</span><span class="pl-c1">!</span><span class="pl-en">getValue</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The example above converts the result of 'getValue()' to a Boolean if it isn't a Boolean already. The type inferred for 'b' is the Boolean primitive type regardless of the return type of 'getValue'.</p>
  </section><h3 id="the-delete-operator-4184" title="4.18.4"> The delete Operator</h3><section id="user-content-4.18.4"><p>The 'delete' operator takes an operand of any type and produces a result of the Boolean primitive type.</p>
  </section><h3 id="the-void-operator-4185" title="4.18.5"> The void Operator</h3>
  <p>The 'void' operator takes an operand of any type and produces the value 'undefined'. The type of the result is the Undefined type (<a href="sec-types#the-undefined-type-327">3.2.7</a>).</p>
  <h3 id="the-typeof-operator-4186" title="4.18.6"> The typeof Operator</h3>
  <p>The 'typeof' operator takes an operand of any type and produces a value of the String primitive type. In positions where a type is expected, 'typeof' can also be used in a type query (section <a href="sec-types#type-queries-3810">3.8.10</a>) to produce the type of an expression.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">5</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-k">typeof</span> <span class="pl-s1">x</span><span class="pl-kos">;</span>  <span class="pl-c">// Use in an expression  </span>
  <span class="pl-k">var</span> <span class="pl-s1">z</span>: <span class="pl-k">typeof</span> <span class="pl-s1">x</span><span class="pl-kos">;</span>   <span class="pl-c">// Use in a type query</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the example above, 'x' is of type 'number', 'y' is of type 'string' because when used in an expression, 'typeof' produces a value of type string (in this case the string "number"), and 'z' is of type 'number' because when used in a type query, 'typeof' obtains the type of an expression.</p>
  <h2 id="binary-operators-419" title="4.19"> Binary Operators</h2><section id="user-content-4.19"><p>The subsections that follow specify the compile-time processing rules of the binary operators. In general, if the operands of a binary operator do not meet the stated requirements, a compile-time error occurs and the result of the operation defaults to type any in further processing. Tables that summarize the compile-time processing rules for operands of the Any type, the Boolean, Number, and String primitive types, and all other types (the Other column in the tables) are provided.</p>
  </section><h3 id="the----------and--operators-4191" title="4.19.1"> The *, /, %, –, &lt;&lt;, &gt;&gt;, &gt;&gt;&gt;, &amp;, ^, and | operators</h3><section id="user-content-4.19.1"><p>These operators require their operands to be of type Any, the Number primitive type, or an enum type. Operands of an enum type are treated as having the primitive type Number. If one operand is the <code>null</code> or <code>undefined</code> value, it is treated as having the type of the other operand. The result is always of the Number primitive type.</p>
  <table>
  <thead>
  <tr>
  <th align="center" />
  <th align="center">Any</th>
  <th align="center">Boolean</th>
  <th align="center">Number</th>
  <th align="center">String</th>
  <th align="center">Other</th>
  </tr>
  </thead>
  <tbody>
  <tr>
  <td>Any</td>
  <td>Number</td>
  <td />
  <td>Number</td>
  <td />
  <td />
  </tr>
  <tr>
  <td>Boolean</td>
  <td />
  <td />
  <td />
  <td />
  <td />
  </tr>
  <tr>
  <td>Number</td>
  <td>Number</td>
  <td />
  <td>Number</td>
  <td />
  <td />
  </tr>
  <tr>
  <td>String</td>
  <td />
  <td />
  <td />
  <td />
  <td />
  </tr>
  <tr>
  <td>Other</td>
  <td />
  <td />
  <td />
  <td />
  <td />
  </tr>
  </tbody>
  </table>
  </section><p><section id="user-content-4.19.1"><em>TODO: Document the </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/4812">exponentation operator</a></em>.</p>
  <h3 id="the--operator-4192" title="4.19.2"> The + operator</h3><section id="user-content-4.19.2"><p>The binary + operator requires both operands to be of the Number primitive type or an enum type, or at least one of the operands to be of type Any or the String primitive type. Operands of an enum type are treated as having the primitive type Number. If one operand is the <code>null</code> or <code>undefined</code> value, it is treated as having the type of the other operand. If both operands are of the Number primitive type, the result is of the Number primitive type. If one or both operands are of the String primitive type, the result is of the String primitive type. Otherwise, the result is of type Any.</p>
  <table>
  <thead>
  <tr>
  <th align="center" />
  <th align="center">Any</th>
  <th align="center">Boolean</th>
  <th align="center">Number</th>
  <th align="center">String</th>
  <th align="center">Other</th>
  </tr>
  </thead>
  <tbody>
  <tr>
  <td>Any</td>
  <td>Any</td>
  <td>Any</td>
  <td>Any</td>
  <td>String</td>
  <td>Any</td>
  </tr>
  <tr>
  <td>Boolean</td>
  <td>Any</td>
  <td />
  <td />
  <td>String</td>
  <td />
  </tr>
  <tr>
  <td>Number</td>
  <td>Any</td>
  <td />
  <td>Number</td>
  <td>String</td>
  <td />
  </tr>
  <tr>
  <td>String</td>
  <td>String</td>
  <td>String</td>
  <td>String</td>
  <td>String</td>
  <td>String</td>
  </tr>
  <tr>
  <td>Other</td>
  <td>Any</td>
  <td />
  <td />
  <td>String</td>
  <td />
  </tr>
  </tbody>
  </table>
  <p>A value of any type can converted to the String primitive type by adding an empty string:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">getValue</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">s</span> <span class="pl-c1">=</span> <span class="pl-en">getValue</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">+</span> <span class="pl-s">""</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The example above converts the result of 'getValue()' to a string if it isn't a string already. The type inferred for 's' is the String primitive type regardless of the return type of 'getValue'.</p>
  </section><h3 id="the--------and--operators-4193" title="4.19.3"> The &lt;, &gt;, &lt;=, &gt;=, ==, !=, ===, and !== operators</h3><section id="user-content-4.19.3"><p>These operators require one or both of the operand types to be assignable to the other. The result is always of the Boolean primitive type.</p>
  <table>
  <thead>
  <tr>
  <th align="center" />
  <th align="center">Any</th>
  <th align="center">Boolean</th>
  <th align="center">Number</th>
  <th align="center">String</th>
  <th align="center">Other</th>
  </tr>
  </thead>
  <tbody>
  <tr>
  <td>Any</td>
  <td>Boolean</td>
  <td>Boolean</td>
  <td>Boolean</td>
  <td>Boolean</td>
  <td>Boolean</td>
  </tr>
  <tr>
  <td>Boolean</td>
  <td>Boolean</td>
  <td>Boolean</td>
  <td />
  <td />
  <td />
  </tr>
  <tr>
  <td>Number</td>
  <td>Boolean</td>
  <td />
  <td>Boolean</td>
  <td />
  <td />
  </tr>
  <tr>
  <td>String</td>
  <td>Boolean</td>
  <td />
  <td />
  <td>Boolean</td>
  <td />
  </tr>
  <tr>
  <td>Other</td>
  <td>Boolean</td>
  <td />
  <td />
  <td />
  <td>Boolean</td>
  </tr>
  </tbody>
  </table>
  </section><h3 id="the-instanceof-operator-4194" title="4.19.4"> The instanceof operator</h3><section id="user-content-4.19.4"><p>The <code>instanceof</code> operator requires the left operand to be of type Any, an object type, or a type parameter type, and the right operand to be of type Any or a subtype of the 'Function' interface type. The result is always of the Boolean primitive type.</p>
  </section><p>Note that object types containing one or more call or construct signatures are automatically subtypes of the 'Function' interface type, as described in section <a href="sec-types#object-types-33">3.3</a>.</p>
  <h3 id="the-in-operator-4195" title="4.19.5"> The in operator</h3><section id="user-content-4.19.5"><p>The <code>in</code> operator requires the left operand to be of type Any, the String primitive type, or the Number primitive type, and the right operand to be of type Any, an object type, or a type parameter type. The result is always of the Boolean primitive type.</p>
  </section><h3 id="the--operator-4196" title="4.19.6"> The &amp;&amp; operator</h3><section id="user-content-4.19.6"><p>The &amp;&amp; operator permits the operands to be of any type and produces a result of the same type as the second operand.</p>
  <table>
  <thead>
  <tr>
  <th align="center" />
  <th align="center">Any</th>
  <th align="center">Boolean</th>
  <th align="center">Number</th>
  <th align="center">String</th>
  <th align="center">Other</th>
  </tr>
  </thead>
  <tbody>
  <tr>
  <td>Any</td>
  <td>Any</td>
  <td>Boolean</td>
  <td>Number</td>
  <td>String</td>
  <td>Other</td>
  </tr>
  <tr>
  <td>Boolean</td>
  <td>Any</td>
  <td>Boolean</td>
  <td>Number</td>
  <td>String</td>
  <td>Other</td>
  </tr>
  <tr>
  <td>Number</td>
  <td>Any</td>
  <td>Boolean</td>
  <td>Number</td>
  <td>String</td>
  <td>Other</td>
  </tr>
  <tr>
  <td>String</td>
  <td>Any</td>
  <td>Boolean</td>
  <td>Number</td>
  <td>String</td>
  <td>Other</td>
  </tr>
  <tr>
  <td>Other</td>
  <td>Any</td>
  <td>Boolean</td>
  <td>Number</td>
  <td>String</td>
  <td>Other</td>
  </tr>
  </tbody>
  </table>
  </section><h3 id="the--operator-4197" title="4.19.7"> The || operator</h3><section id="user-content-4.19.7"><p>The || operator permits the operands to be of any type.</p>
  </section><p>If the || expression is contextually typed (section <a href="#contextually-typed-expressions-423">4.23</a>), the operands are contextually typed by the same type. Otherwise, the left operand is not contextually typed and the right operand is contextually typed by the type of the left operand.</p>
  <p>The type of the result is the union type of the two operand types.</p>
  <table>
  <thead>
  <tr>
  <th align="center" />
  <th align="center">Any</th>
  <th align="center">Boolean</th>
  <th align="center">Number</th>
  <th align="center">String</th>
  <th align="center">Other</th>
  </tr>
  </thead>
  <tbody>
  <tr>
  <td>Any</td>
  <td>Any</td>
  <td>Any</td>
  <td>Any</td>
  <td>Any</td>
  <td>Any</td>
  </tr>
  <tr>
  <td>Boolean</td>
  <td>Any</td>
  <td>Boolean</td>
  <td>N</td>
  <td>B</td>
  <td>S</td>
  </tr>
  <tr>
  <td>Number</td>
  <td>Any</td>
  <td>N</td>
  <td>B</td>
  <td>Number</td>
  <td>S</td>
  </tr>
  <tr>
  <td>String</td>
  <td>Any</td>
  <td>S</td>
  <td>B</td>
  <td>S</td>
  <td>N</td>
  </tr>
  <tr>
  <td>Other</td>
  <td>Any</td>
  <td>B</td>
  <td>O</td>
  <td>N</td>
  <td>O</td>
  </tr>
  </tbody>
  </table>
  <h2 id="the-conditional-operator-420" title="4.20"> The Conditional Operator</h2><section id="user-content-4.20"><p>In a conditional expression of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">test</span> ? <span class="pl-s1">expr1</span> : <span class="pl-s1">expr2</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the <em>test</em> expression may be of any type.</p>
  </section><p>If the conditional expression is contextually typed (section <a href="#contextually-typed-expressions-423">4.23</a>), <em>expr1</em> and <em>expr2</em> are contextually typed by the same type. Otherwise, <em>expr1</em> and <em>expr2</em> are not contextually typed.</p>
  <p>The type of the result is the union type of the types of <em>expr1</em> and <em>expr2</em>.</p>
  <h2 id="assignment-operators-421" title="4.21"> Assignment Operators</h2><section id="user-content-4.21"><p>An assignment of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">v</span> <span class="pl-c1">=</span> <span class="pl-s1">expr</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p><section id="user-content-4.21"><em>v</em> to be classified as a reference (section </section><a href="#values-and-references-41">4.1</a>) or as an assignment pattern (section <a href="#destructuring-assignment-4211">4.21.1</a>). The <em>expr</em> expression is contextually typed (section <a href="#contextually-typed-expressions-423">4.23</a>) by the type of <em>v</em>, and the type of <em>expr</em> must be assignable to (section <a href="sec-types#assignment-compatibility-3114">3.11.4</a>) the type of <em>v</em>, or otherwise a compile-time error occurs. The result is a value with the type of <em>expr</em>.</p>
  <p>A compound assignment of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">v</span> <span class="pl-c1">??=</span> <span class="pl-s1">expr</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where ??= is one of the compound assignment operators</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">*=</span>   <span class="pl-c1">/</span>=   %=   <span class="pl-c1">+</span>=   -=   &lt;&lt;=   &gt;&gt;=   &gt;&gt;&gt;=   &amp;=   <span class="pl-cce">^</span>=   <span class="pl-c1">|</span>=</pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is subject to the same requirements, and produces a value of the same type, as the corresponding non-compound operation. A compound assignment furthermore requires <em>v</em> to be classified as a reference (section <a href="#values-and-references-41">4.1</a>) and the type of the non-compound operation to be assignable to the type of <em>v</em>. Note that <em>v</em> is not permitted to be an assignment pattern in a compound assignment.</p>
  <h3 id="destructuring-assignment-4211" title="4.21.1"> Destructuring Assignment</h3><section id="user-content-4.21.1"><p>A <em><strong>destructuring assignment</strong></em> is an assignment operation in which the left hand operand is a destructuring assignment pattern as defined by the <em>AssignmentPattern</em> production in the ECMAScript 2015 specification.</p>
  <p>In a destructuring assignment expression, the type of the expression on the right must be assignable to the assignment target on the left. An expression of type <em>S</em> is considered assignable to an assignment target <em>V</em> if one of the following is true:</p>
  </section><ul><section id="user-content-4.21.1"><li><em>V</em> is variable and <em>S</em> is assignable to the type of <em>V</em>.</li>
  <li><em>V</em> is an object assignment pattern and, for each assignment property <em>P</em> in <em>V</em>,
  <ul>
  <li><em>S</em> is the type Any, or</li>
  <li><em>S</em> has an apparent property with the property name specified in <em>P</em> of a type that is assignable to the target given in <em>P</em>, or</li>
  <li><em>P</em> specifies a numeric property name and <em>S</em> has a numeric index signature of a type that is assignable to the target given in <em>P</em>, or</li>
  <li><em>S</em> has a string index signature of a type that is assignable to the target given in <em>P</em>.</li>
  </ul>
  </li>
  </section><li><section id="user-content-4.21.1"><em>V</em> is an array assignment pattern, <em>S</em> is the type Any or an array-like type (section </section><a href="sec-types#array-types-332">3.3.2</a>), and, for each assignment element <em>E</em> in <em>V</em>,
  <ul>
  <li><em>S</em> is the type Any, or</li>
  <li><em>S</em> is a tuple-like type (section <a href="sec-types#tuple-types-333">3.3.3</a>) with a property named <em>N</em> of a type that is assignable to the target given in <em>E</em>, where <em>N</em> is the numeric index of <em>E</em> in the array assignment pattern, or</li>
  <li><em>S</em> is not a tuple-like type and the numeric index signature type of <em>S</em> is assignable to the target given in <em>E</em>.</li>
  </ul>
  </li>
  </ul>
  <p><em>TODO: <a href="https://github.com/Microsoft/TypeScript/issues/2713">Update to specify behavior when assignment element E is a rest element</a></em>.</p>
  <p>In an assignment property or element that includes a default value, the type of the default value must be assignable to the target given in the assignment property or element.</p>
  <p>When the output target is ECMAScript 2015 or higher, destructuring variable assignments remain unchanged in the emitted JavaScript code. When the output target is ECMAScript 3 or 5, destructuring variable assignments are rewritten to series of simple assignments. For example, the destructuring assignment</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-c1">2</span><span class="pl-kos">;</span>  
  <span class="pl-kos">[</span><span class="pl-s1">x</span><span class="pl-kos">,</span> <span class="pl-s1">y</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-s1">y</span><span class="pl-kos">,</span> <span class="pl-s1">x</span><span class="pl-kos">]</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is rewritten to the simple variable assignments</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-c1">2</span><span class="pl-kos">;</span>  
  <span class="pl-s1">_a</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-s1">y</span><span class="pl-kos">,</span> <span class="pl-s1">x</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">[</span><span class="pl-c1">0</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">[</span><span class="pl-c1">1</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">_a</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h2 id="the-comma-operator-422" title="4.22"> The Comma Operator</h2><section id="user-content-4.22"><p>The comma operator permits the operands to be of any type and produces a result that is of the same type as the second operand.</p>
  </section><h2 id="contextually-typed-expressions-423" title="4.23"> Contextually Typed Expressions</h2><section id="user-content-4.23"><p>Type checking of an expression is improved in several contexts by factoring in the type of the destination of the value computed by the expression. In such situations, the expression is said to be <em><strong>contextually typed</strong></em> by the type of the destination. An expression is contextually typed in the following circumstances:</p>
  </section><ul>
  <li>In a variable, parameter, binding property, binding element, or member declaration, an initializer expression is contextually typed by
  <ul><section id="user-content-4.23"><li>the type given in the declaration's type annotation, if any, or otherwise</li>
  </section><li>for a parameter, the type provided by a contextual signature (section <a href="#function-expressions-410">4.10</a>), if any, or otherwise</li>
  <li>the type implied by the binding pattern in the declaration (section <a href="sec-statements#implied-type-523">5.2.3</a>), if any.</li>
  </ul>
  </li>
  <li>In the body of a function declaration, function expression, arrow function, method declaration, or get accessor declaration that has a return type annotation, return expressions are contextually typed by the type given in the return type annotation.</li>
  <li>In the body of a function expression or arrow function that has no return type annotation, if the function expression or arrow function is contextually typed by a function type with exactly one call signature, and if that call signature is non-generic, return expressions are contextually typed by the return type of that call signature.</li>
  <li>In the body of a constructor declaration, return expressions are contextually typed by the containing class type.</li>
  <li>In the body of a get accessor with no return type annotation, if a matching set accessor exists and that set accessor has a parameter type annotation, return expressions are contextually typed by the type given in the set accessor's parameter type annotation.</li>
  <li>In a typed function call, argument expressions are contextually typed by their corresponding parameter types.</li>
  <li>In a contextually typed object literal, each property value expression is contextually typed by
  <ul>
  <li>the type of the property with a matching name in the contextual type, if any, or otherwise</li>
  <li>for a numerically named property, the numeric index type of the contextual type, if any, or otherwise</li>
  <li>the string index type of the contextual type, if any.</li>
  </ul>
  </li>
  <li>In a contextually typed array literal expression containing no spread elements, an element expression at index <em>N</em> is contextually typed by
  <ul>
  <li>the type of the property with the numeric name <em>N</em> in the contextual type, if any, or otherwise</li>
  <li>the numeric index type of the contextual type, if any.</li>
  </ul>
  </li>
  <li>In a contextually typed array literal expression containing one or more spread elements, an element expression at index <em>N</em> is contextually typed by the numeric index type of the contextual type, if any.</li>
  <li>In a contextually typed parenthesized expression, the contained expression is contextually typed by the same type.</li>
  <li>In a type assertion, the expression is contextually typed by the indicated type.</li>
  <li>In a || operator expression, if the expression is contextually typed, the operands are contextually typed by the same type. Otherwise, the right expression is contextually typed by the type of the left expression.</li>
  <li>In a contextually typed conditional operator expression, the operands are contextually typed by the same type.</li>
  <li>In an assignment expression, the right hand expression is contextually typed by the type of the left hand expression.</li>
  </ul>
  <p>In the following example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">EventObject</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">EventHandlers</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">mousedown</span>?: <span class="pl-kos">(</span><span class="pl-s1">event</span>: <span class="pl-smi">EventObject</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
      <span class="pl-c1">mouseup</span>?: <span class="pl-kos">(</span><span class="pl-s1">event</span>: <span class="pl-smi">EventObject</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
      <span class="pl-c1">mousemove</span>?: <span class="pl-kos">(</span><span class="pl-s1">event</span>: <span class="pl-smi">EventObject</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-en">setEventHandlers</span><span class="pl-kos">(</span><span class="pl-s1">handlers</span>: <span class="pl-smi">EventHandlers</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span>
  
  <span class="pl-en">setEventHandlers</span><span class="pl-kos">(</span><span class="pl-kos">{</span>  
      <span class="pl-en">mousedown</span>: <span class="pl-s1">e</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span> <span class="pl-en">startTracking</span><span class="pl-kos">(</span><span class="pl-s1">e</span><span class="pl-kos">.</span><span class="pl-c1">x</span><span class="pl-kos">,</span> <span class="pl-s1">e</span><span class="pl-kos">.</span><span class="pl-c1">y</span><span class="pl-kos">)</span><span class="pl-kos">;</span> <span class="pl-kos">}</span><span class="pl-kos">,</span>  
      <span class="pl-en">mouseup</span>: <span class="pl-s1">e</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span> <span class="pl-en">endTracking</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the object literal passed to 'setEventHandlers' is contextually typed to the 'EventHandlers' type. This causes the two property assignments to be contextually typed to the unnamed function type '(event: EventObject) =&gt; void', which in turn causes the 'e' parameters in the arrow function expressions to automatically be typed as 'EventObject'.</p>
  <h2 id="type-guards-424" title="4.24"> Type Guards</h2><section id="user-content-4.24"><p>Type guards are particular expression patterns involving the 'typeof' and 'instanceof' operators that cause the types of variables or parameters to be <em><strong>narrowed</strong></em> to more specific types. For example, in the code below, knowledge of the static type of 'x' in combination with a 'typeof' check makes it safe to narrow the type of 'x' to string in the first branch of the 'if' statement and number in the second branch of the 'if' statement.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">foo</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span> <span class="pl-c1">|</span> <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-k">typeof</span> <span class="pl-s1">x</span> <span class="pl-c1">===</span> <span class="pl-s">"string"</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-s1">x</span><span class="pl-kos">.</span><span class="pl-c1">length</span><span class="pl-kos">;</span>  <span class="pl-c">// x has type string here  </span>
      <span class="pl-kos">}</span>  
      <span class="pl-k">else</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-s1">x</span> <span class="pl-c1">+</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>     <span class="pl-c">// x has type number here  </span>
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The type of a variable or parameter is narrowed in the following situations:</p>
  <ul>
  <li>In the true branch statement of an 'if' statement, the type of a variable or parameter is <em>narrowed</em> by a type guard in the 'if' condition <em>when true</em>, provided no part of the 'if' statement contains assignments to the variable or parameter.</li>
  <li>In the false branch statement of an 'if' statement, the type of a variable or parameter is <em>narrowed</em> by a type guard in the 'if' condition <em>when false</em>, provided no part of the 'if' statement contains assignments to the variable or parameter.</li>
  <li>In the true expression of a conditional expression, the type of a variable or parameter is <em>narrowed</em> by a type guard in the condition <em>when true</em>, provided no part of the conditional expression contains assignments to the variable or parameter.</li>
  <li>In the false expression of a conditional expression, the type of a variable or parameter is <em>narrowed</em> by a type guard in the condition <em>when false</em>, provided no part of the conditional expression contains assignments to the variable or parameter.</li>
  <li>In the right operand of a &amp;&amp; operation, the type of a variable or parameter is <em>narrowed</em> by a type guard in the left operand <em>when true</em>, provided neither operand contains assignments to the variable or parameter.</li>
  <li>In the right operand of a || operation, the type of a variable or parameter is <em>narrowed</em> by a type guard in the left operand <em>when false</em>, provided neither operand contains assignments to the variable or parameter.</li>
  </ul>
  <p>A type guard is simply an expression that follows a particular pattern. The process of narrowing the type of a variable <em>x</em> by a type guard <em>when true</em> or <em>when false</em> depends on the type guard as follows:</p>
  <ul>
  <li>A type guard of the form <code>x instanceof C</code>, where <em>x</em> is not of type Any, <em>C</em> is of a subtype of the global type 'Function', and <em>C</em> has a property named 'prototype'
  <ul>
  <li><em>when true</em>, narrows the type of <em>x</em> to the type of the 'prototype' property in <em>C</em> provided it is a subtype of the type of <em>x</em>, or, if the type of <em>x</em> is a union type, removes from the type of <em>x</em> all constituent types that aren't subtypes of the type of the 'prototype' property in <em>C</em>, or</li>
  <li><em>when false</em>, has no effect on the type of <em>x</em>.</li>
  </ul>
  </li>
  <li>A type guard of the form <code>typeof x === s</code>, where <em>s</em> is a string literal with the value 'string', 'number', or 'boolean',
  <ul>
  <li><em>when true</em>, narrows the type of <em>x</em> to the given primitive type provided it is a subtype of the type of <em>x</em>, or, if the type of <em>x</em> is a union type, removes from the type of <em>x</em> all constituent types that aren't subtypes of the given primitive type, or</li>
  <li><em>when false</em>, removes the primitive type from the type of <em>x</em>.</li>
  </ul>
  </li>
  <li>A type guard of the form <code>typeof x === s</code>, where <em>s</em> is a string literal with any value but 'string', 'number', or 'boolean',
  <ul>
  <li><em>when true</em>, if <em>x</em> is a union type, removes from the type of <em>x</em> all constituent types that are subtypes of the string, number, or boolean primitive type, or</li>
  <li><em>when false</em>, has no effect on the type of <em>x</em>.</li>
  </ul>
  </li>
  <li>A type guard of the form <code>typeof x !== s</code>, where <em>s</em> is a string literal,
  <ul>
  <li><em>when true</em>, narrows the type of x by <code>typeof x === s</code> <em>when false</em>, or</li>
  <li><em>when false</em>, narrows the type of x by <code>typeof x === s</code> <em>when true</em>.</li>
  </ul>
  </li>
  <li>A type guard of the form <code>!expr</code>
  <ul>
  <li><em>when true</em>, narrows the type of <em>x</em> by <em>expr</em> <em>when false</em>, or</li>
  <li><em>when false</em>, narrows the type of <em>x</em> by <em>expr</em> <em>when true</em>.</li>
  </ul>
  </li>
  <li>A type guard of the form <code>expr1 &amp;&amp; expr2</code>
  <ul>
  <li><em>when true</em>, narrows the type of <em>x</em> by <em>expr<sub>1</sub></em> <em>when true</em> and then by <em>expr<sub>2</sub></em> <em>when true</em>, or</li>
  <li><em>when false</em>, narrows the type of <em>x</em> to <em>T<sub>1</sub></em> | <em>T<sub>2</sub></em>, where <em>T<sub>1</sub></em> is the type of <em>x</em> narrowed by <em>expr<sub>1</sub></em> <em>when false</em>, and <em>T<sub>2</sub></em> is the type of <em>x</em> narrowed by <em>expr<sub>1</sub></em> <em>when true</em> and then by <em>expr<sub>2</sub></em> <em>when false</em>.</li>
  </ul>
  </li>
  <li>A type guard of the form <code>expr1 || expr2</code>
  <ul>
  <li><em>when true</em>, narrows the type of <em>x</em> to <em>T<sub>1</sub></em> | <em>T<sub>2</sub></em>, where <em>T<sub>1</sub></em> is the type of <em>x</em> narrowed by <em>expr<sub>1</sub></em> <em>when true</em>, and <em>T<sub>2</sub></em> is the type of <em>x</em> narrowed by <em>expr<sub>1</sub></em> <em>when false</em> and then by <em>expr<sub>2</sub></em> <em>when true</em>, or</li>
  <li><em>when false</em>, narrows the type of <em>x</em> by <em>expr<sub>1</sub></em> <em>when false</em> and then by <em>expr<sub>2</sub></em> <em>when false</em>.</li>
  </ul>
  </li>
  <li>A type guard of any other form has no effect on the type of <em>x</em>.</li>
  </ul>
  <p>In the rules above, when a narrowing operation would remove all constituent types from a union type, the operation has no effect on the union type.</p>
  <p>Note that type guards affect types of variables and parameters only and have no effect on members of objects such as properties. Also note that it is possible to defeat a type guard by calling a function that changes the type of the guarded variable.</p>
  </section><p><section id="user-content-4.24"><em>TODO: Document </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/1007">user defined type guard functions</a></em>.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">isLongString</span><span class="pl-kos">(</span><span class="pl-s1">obj</span>: <span class="pl-smi">any</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-k">typeof</span> <span class="pl-s1">obj</span> <span class="pl-c1">===</span> <span class="pl-s">"string"</span> <span class="pl-c1">&amp;&amp;</span> <span class="pl-s1">obj</span><span class="pl-kos">.</span><span class="pl-c1">length</span> <span class="pl-c1">&gt;</span> <span class="pl-c1">100</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the <code>obj</code> parameter has type <code>string</code> in the right operand of the &amp;&amp; operator.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">processValue</span><span class="pl-kos">(</span><span class="pl-s1">value</span>: <span class="pl-smi">number</span> <span class="pl-c1">|</span> <span class="pl-kos">(</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">number</span><span class="pl-kos">)</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-k">typeof</span> <span class="pl-s1">value</span> <span class="pl-c1">!==</span> <span class="pl-s">"number"</span> ? <span class="pl-en">value</span><span class="pl-kos">(</span><span class="pl-kos">)</span> : <span class="pl-s1">value</span><span class="pl-kos">;</span>  
      <span class="pl-c">// Process number in x  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the value parameter has type <code>() =&gt; number</code> in the first conditional expression and type <code>number</code> in the second conditional expression, and the inferred type of x is <code>number</code>.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">string</span> <span class="pl-c1">|</span> <span class="pl-smi">number</span> <span class="pl-c1">|</span> <span class="pl-smi">boolean</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-k">typeof</span> <span class="pl-s1">x</span> <span class="pl-c1">===</span> <span class="pl-s">"string"</span> <span class="pl-c1">||</span> <span class="pl-k">typeof</span> <span class="pl-s1">x</span> <span class="pl-c1">===</span> <span class="pl-s">"number"</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">var</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span><span class="pl-kos">;</span>  <span class="pl-c">// Type of y is string | number  </span>
      <span class="pl-kos">}</span>  
      <span class="pl-k">else</span> <span class="pl-kos">{</span>  
          <span class="pl-k">var</span> <span class="pl-s1">z</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span><span class="pl-kos">;</span>  <span class="pl-c">// Type of z is boolean  </span>
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the type of x is <code>string | number | boolean</code> in the left operand of the || operator, <code>number | boolean</code> in the right operand of the || operator, <code>string | number</code> in the first branch of the if statement, and <code>boolean</code> in the second branch of the if statement.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">C</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">data</span>: <span class="pl-smi">string</span> <span class="pl-c1">|</span> <span class="pl-smi">string</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
      <span class="pl-en">getData</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">var</span> <span class="pl-s1">data</span> <span class="pl-c1">=</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">data</span><span class="pl-kos">;</span>  
          <span class="pl-k">return</span> <span class="pl-k">typeof</span> <span class="pl-s1">data</span> <span class="pl-c1">===</span> <span class="pl-s">"string"</span> ? <span class="pl-s1">data</span> : <span class="pl-s1">data</span><span class="pl-kos">.</span><span class="pl-en">join</span><span class="pl-kos">(</span><span class="pl-s">" "</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the type of the <code>data</code> variable is <code>string</code> in the first conditional expression and <code>string[]</code> in the second conditional expression, and the inferred type of <code>getData</code> is <code>string</code>. Note that the <code>data</code> property must be copied to a local variable for the type guard to have an effect.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">NamedItem</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-en">getName</span><span class="pl-kos">(</span><span class="pl-s1">obj</span>: <span class="pl-smi">Object</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-s1">obj</span> <span class="pl-k">instanceof</span> <span class="pl-smi">NamedItem</span> ? <span class="pl-s1">obj</span><span class="pl-kos">.</span><span class="pl-c1">name</span> : <span class="pl-s">"unknown"</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the type of <code>obj</code> is narrowed to <code>NamedItem</code> in the first conditional expression, and the inferred type of the <code>getName</code> function is <code>string</code>.</p>
  <br />
  </section>