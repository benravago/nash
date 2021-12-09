<section id="sec-statements"><h1 id="statements-5" title="5"> Statements</h1><section id="user-content-5"><p>This chapter describes the static type checking TypeScript provides for JavaScript statements. TypeScript itself does not introduce any new statement constructs, but it does extend the grammar for local declarations to include interface, type alias, and enum declarations.</p>
  </section><h2 id="blocks-51" title="5.1"> Blocks</h2><section id="user-content-5.1"><p>Blocks are extended to include local interface, type alias, and enum declarations (classes are already included by the ECMAScript 2015 grammar).</p>
  <p>  <em>Declaration:</em>  <em>( Modified )</em><br />
     …<br />
     <em>InterfaceDeclaration</em><br />
     <em>TypeAliasDeclaration</em><br />
     <em>EnumDeclaration</em></p>
  <p>Local class, interface, type alias, and enum declarations are block scoped, similar to let and const declarations.</p>
  </section><h2 id="variable-statements-52" title="5.2"> Variable Statements</h2><section id="user-content-5.2"><p>Variable statements are extended to include optional type annotations.</p>
  <p>  <em>VariableDeclaration:</em>  <em>( Modified )</em><br />
     <em>SimpleVariableDeclaration</em><br />
     <em>DestructuringVariableDeclaration</em></p>
  <p>A variable declaration is either a simple variable declaration or a destructuring variable declaration.</p>
  </section><h3 id="simple-variable-declarations-521" title="5.2.1"> Simple Variable Declarations</h3><section id="user-content-5.2.1"><p>A <em><strong>simple variable declaration</strong></em> introduces a single named variable and optionally assigns it an initial value.</p>
  <p>  <em>SimpleVariableDeclaration:</em><br />
     <em>BindingIdentifier</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer<sub>opt</sub></em></p>
  <p>The type <em>T</em> of a variable introduced by a simple variable declaration is determined as follows:</p>
  </section><ul><section id="user-content-5.2.1"><li>If the declaration includes a type annotation, <em>T</em> is that type.</li>
  </section><li><section id="user-content-5.2.1"><em>T</em> is the widened form (section </section><a href="sec-types#widened-types-312">3.12</a>) of the type of the initializer expression.</li>
  <li>Otherwise, <em>T</em> is the Any type.</li>
  </ul>
  <p>When a variable declaration specifies both a type annotation and an initializer expression, the type of the initializer expression is required to be assignable to (section <a href="sec-types#assignment-compatibility-3114">3.11.4</a>) the type given in the type annotation.</p>
  <p>Multiple declarations for the same variable name in the same declaration space are permitted, provided that each declaration associates the same type with the variable.</p>
  <p>When a variable declaration has a type annotation, it is an error for that type annotation to use the <code>typeof</code> operator to reference the variable being declared.</p>
  <p>Below are some examples of simple variable declarations and their associated types.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">a</span><span class="pl-kos">;</span>                          <span class="pl-c">// any  </span>
  <span class="pl-k">var</span> <span class="pl-s1">b</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>                  <span class="pl-c">// number  </span>
  <span class="pl-k">var</span> <span class="pl-s1">c</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>                      <span class="pl-c">// number  </span>
  <span class="pl-k">var</span> <span class="pl-s1">d</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">1</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-s">"hello"</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>   <span class="pl-c">// { x: number; y: string; }  </span>
  <span class="pl-k">var</span> <span class="pl-s1">e</span>: <span class="pl-smi">any</span> <span class="pl-c1">=</span> <span class="pl-s">"test"</span><span class="pl-kos">;</span>            <span class="pl-c">// any</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The following is permitted because all declarations of the single variable 'x' associate the same type (Number) with 'x'.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">x</span> <span class="pl-c1">==</span> <span class="pl-c1">1</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">2</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the following example, all five variables are of the same type, '{ x: number; y: number; }'.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">a</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-kos">&lt;</span><span class="pl-smi">number</span><span class="pl-kos">&gt;</span> <span class="pl-c1">undefined</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">b</span>: <span class="pl-smi">Point</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-c1">undefined</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">c</span> <span class="pl-c1">=</span> <span class="pl-kos">&lt;</span><span class="pl-smi">Point</span><span class="pl-kos">&gt;</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-c1">undefined</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">d</span>: <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-kos">}</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-c1">undefined</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">e</span> <span class="pl-c1">=</span> <span class="pl-kos">&lt;</span><span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-kos">}</span><span class="pl-kos">&gt;</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-c1">undefined</span> <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="destructuring-variable-declarations-522" title="5.2.2"> Destructuring Variable Declarations</h3><section id="user-content-5.2.2"><p>A <em><strong>destructuring variable declaration</strong></em> introduces zero or more named variables and initializes them with values extracted from properties of an object or elements of an array.</p>
  <p>  <em>DestructuringVariableDeclaration:</em><br />
     <em>BindingPattern</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer</em></p>
  </section><p>Each binding property or element that specifies an identifier introduces a variable by that name. The type of the variable is the widened form (section <a href="sec-types#widened-types-312">3.12</a>) of the type associated with the binding property or element, as defined in the following.</p>
  <p><em>TODO: Document destructuring an <a href="https://github.com/Microsoft/TypeScript/pull/2498">iterator</a> into an array</em>.</p>
  <p>The type <em>T</em> associated with a destructuring variable declaration is determined as follows:</p>
  <ul>
  <li>If the declaration includes a type annotation, <em>T</em> is that type.</li>
  <li>Otherwise, if the declaration includes an initializer expression, <em>T</em> is the type of that initializer expression.</li>
  <li>Otherwise, <em>T</em> is the Any type.</li>
  </ul>
  <p>The type <em>T</em> associated with a binding property is determined as follows:</p>
  <ul>
  <li>Let <em>S</em> be the type associated with the immediately containing destructuring variable declaration, binding property, or binding element.</li>
  <li>If <em>S</em> is the Any type:
  <ul>
  <li>If the binding property specifies an initializer expression, <em>T</em> is the type of that initializer expression.</li>
  <li>Otherwise, <em>T</em> is the Any type.</li>
  </ul>
  </li>
  <li>Let <em>P</em> be the property name specified in the binding property.</li>
  <li>If <em>S</em> has an apparent property with the name <em>P</em>, <em>T</em> is the type of that property.</li>
  <li>Otherwise, if <em>S</em> has a numeric index signature and <em>P</em> is a numerical name, <em>T</em> is the type of the numeric index signature.</li>
  <li>Otherwise, if <em>S</em> has a string index signature, <em>T</em> is the type of the string index signature.</li>
  <li>Otherwise, no type is associated with the binding property and an error occurs.</li>
  </ul>
  <p>The type <em>T</em> associated with a binding element is determined as follows:</p>
  <ul>
  <li>Let <em>S</em> be the type associated with the immediately containing destructuring variable declaration, binding property, or binding element.</li>
  <li>If <em>S</em> is the Any type:
  <ul>
  <li>If the binding element specifies an initializer expression, <em>T</em> is the type of that initializer expression.</li>
  <li>Otherwise, <em>T</em> is the Any type.</li>
  </ul>
  </li>
  <li>If <em>S</em> is not an array-like type (section <a href="sec-types#array-types-332">3.3.2</a>), no type is associated with the binding property and an error occurs.</li>
  <li>If the binding element is a rest element, <em>T</em> is an array type with an element type <em>E</em>, where <em>E</em> is the type of the numeric index signature of <em>S</em>.</li>
  <li>Otherwise, if <em>S</em> is a tuple-like type (section <a href="sec-types#tuple-types-333">3.3.3</a>):
  <ul>
  <li>Let <em>N</em> be the zero-based index of the binding element in the array binding pattern.</li>
  <li>If <em>S</em> has a property with the numerical name <em>N</em>, <em>T</em> is the type of that property.</li>
  <li>Otherwise, no type is associated with the binding element and an error occurs.</li>
  </ul>
  </li>
  <li>Otherwise, if <em>S</em> has a numeric index signature, <em>T</em> is the type of the numeric index signature.</li>
  <li>Otherwise, no type is associated with the binding element and an error occurs.</li>
  </ul>
  <p>When a destructuring variable declaration, binding property, or binding element specifies an initializer expression, the type of the initializer expression is required to be assignable to the widened form of the type associated with the destructuring variable declaration, binding property, or binding element.</p>
  <p><em>TODO: Update rules to reflect <a href="https://github.com/Microsoft/TypeScript/pull/4598">improved checking of destructuring with literal initializers</a></em>.</p>
  <p>When the output target is ECMAScript 2015 or higher, except for removing the optional type annotation, destructuring variable declarations remain unchanged in the emitted JavaScript code.</p>
  <p>When the output target is ECMAScript 3 or 5, destructuring variable declarations are rewritten to simple variable declarations. For example, an object destructuring declaration of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-kos">{</span> x<span class="pl-kos">,</span> <span class="pl-c1">p</span>: <span class="pl-s1">y</span><span class="pl-kos">,</span> <span class="pl-c1">q</span>: <span class="pl-s1">z</span><span class="pl-kos" /> <span class="pl-c1">=</span> <span class="pl-c1">false</span> <span class="pl-kos">}</span> <span class="pl-c1">=</span> <span class="pl-en">getSomeObject</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is rewritten to the simple variable declarations</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">_a</span> <span class="pl-c1">=</span> <span class="pl-en">getSomeObject</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">,</span>  
      <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">.</span><span class="pl-c1">x</span><span class="pl-kos">,</span>  
      <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">.</span><span class="pl-c1">p</span><span class="pl-kos">,</span>  
      <span class="pl-s1">_b</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">.</span><span class="pl-c1">q</span><span class="pl-kos">,</span>  
      <span class="pl-s1">z</span> <span class="pl-c1">=</span> <span class="pl-s1">_b</span> <span class="pl-c1">===</span> <span class="pl-k">void</span> <span class="pl-c1">0</span> ? <span class="pl-c1">false</span> : <span class="pl-s1">_b</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The '_a' and '_b' temporary variables exist to ensure the assigned expression is evaluated only once, and the expression 'void 0' simply denotes the JavaScript value 'undefined'.</p>
  <p>Similarly, an array destructuring declaration of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-kos">[</span><span class="pl-s1">x</span><span class="pl-kos">,</span> <span class="pl-s1">y</span><span class="pl-kos">,</span> <span class="pl-s1">z</span> <span class="pl-c1">=</span> <span class="pl-c1">10</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-en">getSomeArray</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is rewritten to the simple variable declarations</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">_a</span> <span class="pl-c1">=</span> <span class="pl-en">getSomeArray</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">,</span>  
      <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">[</span><span class="pl-c1">0</span><span class="pl-kos">]</span><span class="pl-kos">,</span>  
      <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">[</span><span class="pl-c1">1</span><span class="pl-kos">]</span><span class="pl-kos">,</span>  
      <span class="pl-s1">_b</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">[</span><span class="pl-c1">2</span><span class="pl-kos">]</span><span class="pl-kos">,</span>  
      <span class="pl-s1">z</span> <span class="pl-c1">=</span> <span class="pl-s1">_b</span> <span class="pl-c1">===</span> <span class="pl-k">void</span> <span class="pl-c1">0</span> ? <span class="pl-c1">10</span> : <span class="pl-s1">_b</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Combining both forms of destructuring, the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-kos">{</span> x<span class="pl-kos">,</span> <span class="pl-c1">p</span>: <span class="pl-kos">[</span><span class="pl-s1">y</span><span class="pl-kos">,</span> <span class="pl-s1">z</span> <span class="pl-c1">=</span> <span class="pl-c1">10</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-en">getSomeArray</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">}</span> <span class="pl-c1">=</span> <span class="pl-en">getSomeObject</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is rewritten to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">_a</span> <span class="pl-c1">=</span> <span class="pl-en">getSomeObject</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">,</span>  
      <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">.</span><span class="pl-c1">x</span><span class="pl-kos">,</span>  
      <span class="pl-s1">_b</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">.</span><span class="pl-c1">p</span><span class="pl-kos">,</span>  
      <span class="pl-s1">_c</span> <span class="pl-c1">=</span> <span class="pl-s1">_b</span> <span class="pl-c1">===</span> <span class="pl-k">void</span> <span class="pl-c1">0</span> ? <span class="pl-en">getSomeArray</span><span class="pl-kos">(</span><span class="pl-kos">)</span> : <span class="pl-s1">_b</span><span class="pl-kos">,</span>  
      <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-s1">_c</span><span class="pl-kos">[</span><span class="pl-c1">0</span><span class="pl-kos">]</span><span class="pl-kos">,</span>  
      <span class="pl-s1">_d</span> <span class="pl-c1">=</span> <span class="pl-s1">_c</span><span class="pl-kos">[</span><span class="pl-c1">1</span><span class="pl-kos">]</span><span class="pl-kos">,</span>  
      <span class="pl-s1">z</span> <span class="pl-c1">=</span> <span class="pl-s1">_d</span> <span class="pl-c1">===</span> <span class="pl-k">void</span> <span class="pl-c1">0</span> ? <span class="pl-c1">10</span> : <span class="pl-s1">_d</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="implied-type-523" title="5.2.3"> Implied Type</h3><section id="user-content-5.2.3"><p>A variable, parameter, binding property, or binding element declaration that specifies a binding pattern has an <em><strong>implied type</strong></em> which is determined as follows:</p>
  <ul>
  <li>If the declaration specifies an object binding pattern, the implied type is an object type with a set of properties corresponding to the specified binding property declarations. The type of each property is the type implied by its binding property declaration, and a property is optional when its binding property declaration specifies an initializer expression.</li>
  <li>If the declaration specifies an array binding pattern without a rest element, the implied type is a tuple type with elements corresponding to the specified binding element declarations. The type of each element is the type implied by its binding element declaration.</li>
  <li>If the declaration specifies an array binding pattern with a rest element, the implied type is an array type with an element type of Any.</li>
  </ul>
  <p>The implied type of a binding property or binding element declaration is</p>
  <ul>
  <li>the type of the declaration's initializer expression, if any, or otherwise</li>
  <li>the implied type of the binding pattern specified in the declaration, if any, or otherwise</li>
  <li>the type Any.</li>
  </ul>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-kos">{</span> a<span class="pl-kos">,</span> b <span class="pl-c1">=</span> <span class="pl-s">"hello"</span><span class="pl-kos">,</span> c <span class="pl-c1">=</span> <span class="pl-c1">1</span> <span class="pl-kos">}</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> ... <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the implied type of the binding pattern in the function's parameter is '{ a: any; b?: string; c?: number; }'. Since the parameter has no type annotation, this becomes the type of the parameter.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-kos">[</span><span class="pl-s1">a</span><span class="pl-kos">,</span> <span class="pl-s1">b</span><span class="pl-kos">,</span> <span class="pl-s1">c</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">1</span><span class="pl-kos">,</span> <span class="pl-s">"hello"</span><span class="pl-kos">,</span> <span class="pl-c1">true</span><span class="pl-kos">]</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the array literal initializer expression is contextually typed by the implied type of the binding pattern, specifically the tuple type '[any, any, any]'. Because the contextual type is a tuple type, the resulting type of the array literal is the tuple type '[number, string, boolean]', and the destructuring declaration thus gives the types number, string, and boolean to a, b, and c respectively.</p>
  </section><h2 id="let-and-const-declarations-53" title="5.3"> Let and Const Declarations</h2><section id="user-content-5.3"><p>Let and const declarations are extended to include optional type annotations.</p>
  <p>  <em>LexicalBinding:</em>  <em>( Modified )</em><br />
     <em>SimpleLexicalBinding</em><br />
     <em>DestructuringLexicalBinding</em></p>
  <p>  <em>SimpleLexicalBinding:</em><br />
     <em>BindingIdentifier</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer<sub>opt</sub></em></p>
  <p>  <em>DestructuringLexicalBinding:</em><br />
     <em>BindingPattern</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer<sub>opt</sub></em></p>
  </section><p><section id="user-content-5.3"><em>TODO: Document scoping and types of </em></section><em><a href="https://github.com/Microsoft/TypeScript/pull/904">let and const declarations</a></em>.</p>
  <h2 id="if-do-and-while-statements-54" title="5.4"> If, Do, and While Statements</h2><section id="user-content-5.4"><p>Expressions controlling 'if', 'do', and 'while' statements can be of any type (and not just type Boolean).</p>
  </section><h2 id="for-statements-55" title="5.5"> For Statements</h2>
  <p>Variable declarations in 'for' statements are extended in the same manner as variable declarations in variable statements (section <a href="#variable-statements-52">5.2</a>).</p>
  <h2 id="for-in-statements-56" title="5.6"> For-In Statements</h2><section id="user-content-5.6"><p>In a 'for-in' statement of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">for</span> <span class="pl-kos">(</span><span class="pl-s1">v</span> <span class="pl-k">in</span> <span class="pl-s1">expr</span><span class="pl-kos">)</span> <span class="pl-s1">statement</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p><em>v</em> must be an expression classified as a reference of type Any or the String primitive type, and <em>expr</em> must be an expression of type Any, an object type, or a type parameter type.</p>
  <p>In a 'for-in' statement of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">for</span> <span class="pl-kos">(</span><span class="pl-k">var</span> <span class="pl-s1">v</span> <span class="pl-k">in</span> <span class="pl-s1">expr</span><span class="pl-kos">)</span> <span class="pl-s1">statement</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p><em>v</em> must be a variable declaration without a type annotation that declares a variable of type Any, and <em>expr</em> must be an expression of type Any, an object type, or a type parameter type.</p>
  </section><h2 id="for-of-statements-57" title="5.7"> For-Of Statements</h2>
  <p><section id="user-content-5.7"><em>TODO: Document </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/7">for-of statements</a></em>.</p>
  <h2 id="continue-statements-58" title="5.8"> Continue Statements</h2><section id="user-content-5.8"><p>A 'continue' statement is required to be nested, directly or indirectly (but not crossing function boundaries), within an iteration ('do', 'while', 'for', or 'for-in') statement. When a 'continue' statement includes a target label, that target label must appear in the label set of an enclosing (but not crossing function boundaries) iteration statement.</p>
  </section><h2 id="break-statements-59" title="5.9"> Break Statements</h2><section id="user-content-5.9"><p>A 'break' statement is required to be nested, directly or indirectly (but not crossing function boundaries), within an iteration ('do', 'while', 'for', or 'for-in') or 'switch' statement. When a 'break' statement includes a target label, that target label must appear in the label set of an enclosing (but not crossing function boundaries) statement.</p>
  </section><h2 id="return-statements-510" title="5.10"> Return Statements</h2><section id="user-content-5.10"><p>It is an error for a 'return' statement to occur outside a function body. Specifically, 'return' statements are not permitted at the global level or in namespace bodies.</p>
  <p>A 'return' statement without an expression returns the value 'undefined' and is permitted in the body of any function, regardless of the return type of the function.</p>
  </section><p>When a 'return' statement includes an expression, if the containing function includes a return type annotation, the return expression is contextually typed (section <a href="sec-expressions#contextually-typed-expressions-423">4.23</a>) by that return type and must be of a type that is assignable to the return type. Otherwise, if the containing function is contextually typed by a type <em>T</em>, <em>Expr</em> is contextually typed by <em>T</em>'s return type.</p>
  <p>In a function implementation without a return type annotation, the return type is inferred from the 'return' statements in the function body, as described in section <a href="sec-functions#function-implementations-63">6.3</a>.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">number</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-s1">s</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">s</span><span class="pl-kos">.</span><span class="pl-c1">length</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the arrow expression in the 'return' statement is contextually typed by the return type of 'f', thus giving type 'string' to 's'.</p>
  <h2 id="with-statements-511" title="5.11"> With Statements</h2>
  <p>Use of the 'with' statement in TypeScript is an error, as is the case in ECMAScript 5's strict mode. Furthermore, within the body of a 'with' statement, TypeScript considers every identifier occurring in an expression (section <a href="sec-expressions#identifiers-43">4.3</a>) to be of the Any type regardless of its declared type. Because the 'with' statement puts a statically unknown set of identifiers in scope in front of those that are statically known, it is not possible to meaningfully assign a static type to any identifier.</p>
  <h2 id="switch-statements-512" title="5.12"> Switch Statements</h2>
  <p>In a 'switch' statement, each 'case' expression must be of a type that is assignable to or from (section <a href="sec-types#assignment-compatibility-3114">3.11.4</a>) the type of the 'switch' expression.</p>
  <h2 id="throw-statements-513" title="5.13"> Throw Statements</h2><section id="user-content-5.13"><p>The expression specified in a 'throw' statement can be of any type.</p>
  </section><h2 id="try-statements-514" title="5.14"> Try Statements</h2><section id="user-content-5.14"><p>The variable introduced by a 'catch' clause of a 'try' statement is always of type Any. It is not possible to include a type annotation in a 'catch' clause.</p>
  <br />
  </section></section>