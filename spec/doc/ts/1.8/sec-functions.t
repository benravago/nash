<section id="sec-functions"><h1 id="functions-6" title="6"> Functions</h1><section id="user-content-6"><p>TypeScript extends JavaScript functions to include type parameters, parameter and return type annotations, overloads, default parameter values, and rest parameters.</p>
  </section><h2 id="function-declarations-61" title="6.1"> Function Declarations</h2><section id="user-content-6.1"><p>Function declarations are extended to permit the function body to be omitted in overload declarations.</p>
  <p>  <em>FunctionDeclaration:</em>  <em>( Modified )</em><br />
     <code>function</code> <em>BindingIdentifier<sub>opt</sub></em> <em>CallSignature</em> <code>{</code> <em>FunctionBody</em> <code>}</code><br />
     <code>function</code> <em>BindingIdentifier<sub>opt</sub></em> <em>CallSignature</em> <code>;</code></p>
  </section><p><section id="user-content-6.1"><em>FunctionDeclaration</em> introduces a named value of a function type in the containing declaration space. The <em>BindingIdentifier</em> is optional only when the function declaration occurs in an export default declaration (section </section><a href="sec-scripts-and-modules#export-default-declarations-11342">11.3.4.2</a>).</p>
  <p>Function declarations that specify a body are called <em><strong>function implementations</strong></em> and function declarations without a body are called <em><strong>function overloads</strong></em>. It is possible to specify multiple overloads for the same function (i.e. for the same name in the same declaration space), but a function can have at most one implementation. All declarations for the same function must specify the same set of modifiers (i.e. the same combination of <code>declare</code>, <code>export</code>, and <code>default</code>).</p>
  <p>When a function has overload declarations, the overloads determine the call signatures of the type given to the function object and the function implementation signature (if any) must be assignable to that type. Otherwise, the function implementation itself determines the call signature.</p>
  <p>When a function has both overloads and an implementation, the overloads must precede the implementation and all of the declarations must be consecutive with no intervening grammatical elements.</p>
  <h2 id="function-overloads-62" title="6.2"> Function Overloads</h2>
  <p>Function overloads allow a more accurate specification of the patterns of invocation supported by a function than is possible with a single signature. The compile-time processing of a call to an overloaded function chooses the best candidate overload for the particular arguments and the return type of that overload becomes the result type the function call expression. Thus, using overloads it is possible to statically describe the manner in which a function's return type varies based on its arguments. Overload resolution in function calls is described further in section <a href="sec-expressions#function-calls-415">4.15</a>.</p>
  <p>Function overloads are purely a compile-time construct. They have no impact on the emitted JavaScript and thus no run-time cost.</p>
  <p>The parameter list of a function overload cannot specify default values for parameters. In other words, an overload may use only the <code>?</code> form when specifying optional parameters.</p>
  <p>The following is an example of a function with overloads.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-s1">attr</span><span class="pl-kos">(</span><span class="pl-s1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-k">function</span> <span class="pl-s1">attr</span><span class="pl-kos">(</span><span class="pl-s1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-s1">value</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">Accessor</span><span class="pl-kos">;</span>  
  <span class="pl-k">function</span> <span class="pl-s1">attr</span><span class="pl-kos">(</span><span class="pl-s1">map</span>: <span class="pl-smi">any</span><span class="pl-kos">)</span>: <span class="pl-smi">Accessor</span><span class="pl-kos">;</span>  
  <span class="pl-k">function</span> <span class="pl-en">attr</span><span class="pl-kos">(</span><span class="pl-s1">nameOrMap</span>: <span class="pl-smi">any</span><span class="pl-kos">,</span> <span class="pl-s1">value</span>?: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">any</span> <span class="pl-kos">{</span>  
      <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">nameOrMap</span> <span class="pl-c1">&amp;&amp;</span> <span class="pl-k">typeof</span> <span class="pl-s1">nameOrMap</span> <span class="pl-c1">===</span> <span class="pl-s">"string"</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-c">// handle string case  </span>
      <span class="pl-kos">}</span>  
      <span class="pl-k">else</span> <span class="pl-kos">{</span>  
          <span class="pl-c">// handle map case  </span>
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that each overload and the final implementation specify the same identifier. The type of the local variable 'attr' introduced by this declaration is</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">attr</span>: <span class="pl-kos">{</span>  
      <span class="pl-kos">(</span><span class="pl-s1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-kos">(</span><span class="pl-s1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-s1">value</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">Accessor</span><span class="pl-kos">;</span>  
      <span class="pl-kos">(</span><span class="pl-s1">map</span>: <span class="pl-smi">any</span><span class="pl-kos">)</span>: <span class="pl-smi">Accessor</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that the signature of the actual function implementation is not included in the type.</p>
  <h2 id="function-implementations-63" title="6.3"> Function Implementations</h2><section id="user-content-6.3"><p>A function implementation without a return type annotation is said to be an <em><strong>implicitly typed function</strong></em>. The return type of an implicitly typed function <em>f</em> is inferred from its function body as follows:</p>
  </section><ul><section id="user-content-6.3"><li>If there are no return statements with expressions in <em>f</em>'s function body, the inferred return type is Void.</li>
  <li>Otherwise, if <em>f</em>'s function body directly references <em>f</em> or references any implicitly typed functions that through this same analysis reference <em>f</em>, the inferred return type is Any.</li>
  </section><li><section id="user-content-6.3"><em>f</em> is a contextually typed function expression (section </section><a href="sec-expressions#function-expressions-410">4.10</a>), the inferred return type is the union type (section <a href="sec-types#union-types-34">3.4</a>) of the types of the return statement expressions in the function body, ignoring return statements with no expressions.</li>
  <li>Otherwise, the inferred return type is the first of the types of the return statement expressions in the function body that is a supertype (section <a href="sec-types#subtypes-and-supertypes-3113">3.11.3</a>) of each of the others, ignoring return statements with no expressions. A compile-time error occurs if no return statement expression has a type that is a supertype of each of the others.</li>
  </ul>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">x</span> <span class="pl-c1">&lt;=</span> <span class="pl-c1">0</span><span class="pl-kos">)</span> <span class="pl-k">return</span> <span class="pl-s1">x</span><span class="pl-kos">;</span>  
      <span class="pl-k">return</span> <span class="pl-en">g</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-en">g</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">x</span> <span class="pl-c1">-</span> <span class="pl-c1">1</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the inferred return type for 'f' and 'g' is Any because the functions reference themselves through a cycle with no return type annotations. Adding an explicit return type 'number' to either breaks the cycle and causes the return type 'number' to be inferred for the other.</p>
  <p>An explicitly typed function whose return type isn't the Void type, the Any type, or a union type containing the Void or Any type as a constituent must have at least one return statement somewhere in its body. An exception to this rule is if the function implementation consists of a single 'throw' statement.</p>
  <p>The type of 'this' in a function implementation is the Any type.</p>
  <p>In the signature of a function implementation, a parameter can be marked optional by following it with an initializer. When a parameter declaration includes both a type annotation and an initializer, the initializer expression is contextually typed (section <a href="sec-expressions#contextually-typed-expressions-423">4.23</a>) by the stated type and must be assignable to the stated type, or otherwise a compile-time error occurs. When a parameter declaration has no type annotation but includes an initializer, the type of the parameter is the widened form (section <a href="sec-types#widened-types-312">3.12</a>) of the type of the initializer expression.</p>
  <p>Initializer expressions are evaluated in the scope of the function body but are not permitted to reference local variables and are only permitted to access parameters that are declared to the left of the parameter they initialize, unless the parameter reference occurs in a nested function expression.</p>
  <p>When the output target is ECMAScript 3 or 5, for each parameter with an initializer, a statement that substitutes the default value for an omitted argument is included in the generated JavaScript, as described in section <a href="#code-generation-66">6.6</a>. The example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">strange</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span> <span class="pl-c1">*</span> <span class="pl-c1">2</span><span class="pl-kos">,</span> <span class="pl-s1">z</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span> <span class="pl-c1">+</span> <span class="pl-s1">y</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-s1">z</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>generates JavaScript that is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">strange</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">,</span> <span class="pl-s1">y</span><span class="pl-kos">,</span> <span class="pl-s1">z</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">y</span> <span class="pl-c1">===</span> <span class="pl-k">void</span> <span class="pl-c1">0</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span> <span class="pl-c1">*</span> <span class="pl-c1">2</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
      <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">z</span> <span class="pl-c1">===</span> <span class="pl-k">void</span> <span class="pl-c1">0</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-s1">z</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span> <span class="pl-c1">+</span> <span class="pl-s1">y</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
      <span class="pl-k">return</span> <span class="pl-s1">z</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
  <span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">a</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s">"hello"</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the local variable 'x' is in scope in the parameter initializer (thus hiding the outer 'x'), but it is an error to reference it because it will always be uninitialized at the time the parameter initializer is evaluated.</p>
  <h2 id="destructuring-parameter-declarations-64" title="6.4"> Destructuring Parameter Declarations</h2>
  <p>Parameter declarations can specify binding patterns (section <a href="sec-types#parameter-list-3922">3.9.2.2</a>) and are then called <em><strong>destructuring parameter declarations</strong></em>. Similar to a destructuring variable declaration (section <a href="sec-statements#destructuring-variable-declarations-522">5.2.2</a>), a destructuring parameter declaration introduces zero or more named locals and initializes them with values extracted from properties or elements of the object or array passed as an argument for the parameter.</p>
  <p>The type of local introduced in a destructuring parameter declaration is determined in the same manner as a local introduced by a destructuring variable declaration, except the type <em>T</em> associated with a destructuring parameter declaration is determined as follows:</p>
  <ul>
  <li>If the declaration includes a type annotation, <em>T</em> is that type.</li>
  <li>If the declaration occurs in a function expression for which a contextual signature is available (section <a href="sec-expressions#function-expressions-410">4.10</a>), <em>T</em> is the type obtained from the contextual signature.</li>
  <li>Otherwise, if the declaration includes an initializer expression, <em>T</em> is the widened form (section <a href="sec-types#widened-types-312">3.12</a>) of the type of the initializer expression.</li>
  <li>Otherwise, if the declaration specifies a binding pattern, <em>T</em> is the implied type of that binding pattern (section <a href="sec-statements#implied-type-523">5.2.3</a>).</li>
  <li>Otherwise, if the parameter is a rest parameter, <em>T</em> is <code>any[]</code>.</li>
  <li>Otherwise, <em>T</em> is <code>any</code>.</li>
  </ul>
  <p>When the output target is ECMAScript 2015 or higher, except for removing the optional type annotation, destructuring parameter declarations remain unchanged in the emitted JavaScript code. When the output target is ECMAScript 3 or 5, destructuring parameter declarations are rewritten to local variable declarations.</p>
  <p>The example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">drawText</span><span class="pl-kos">(</span><span class="pl-kos">{</span> text <span class="pl-c1">=</span> <span class="pl-s">""</span><span class="pl-kos">,</span> <span class="pl-c1">location</span>: <span class="pl-kos">[</span><span class="pl-s1">x</span><span class="pl-kos">,</span> <span class="pl-s1">y</span><span class="pl-kos">]</span><span class="pl-kos" /> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">0</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-s1">bold</span> <span class="pl-c1">=</span> <span class="pl-c1">false</span> <span class="pl-kos">}</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-c">// Draw text  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>declares a function <code>drawText</code> that takes a single parameter of the type</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">{</span> <span class="pl-c1">text</span>?: <span class="pl-s1">string</span><span class="pl-kos">;</span> <span class="pl-s1">location</span>?<span class="pl-s1" />: <span class="pl-kos">[</span><span class="pl-s1">number</span><span class="pl-kos">,</span> <span class="pl-s1">number</span><span class="pl-kos">]</span><span class="pl-kos">;</span> <span class="pl-s1">bold</span>?<span class="pl-s1" />: <span class="pl-s1">boolean</span><span class="pl-kos">;</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>When the output target is ECMAScript 3 or 5, the function is rewritten to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">drawText</span><span class="pl-kos">(</span><span class="pl-s1">_a</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">_b</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">.</span><span class="pl-c1">text</span><span class="pl-kos">,</span>  
          <span class="pl-s1">text</span> <span class="pl-c1">=</span> <span class="pl-s1">_b</span> <span class="pl-c1">===</span> <span class="pl-k">void</span> <span class="pl-c1">0</span> ? <span class="pl-s">""</span> : <span class="pl-s1">_b</span><span class="pl-kos">,</span>  
          <span class="pl-s1">_c</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">.</span><span class="pl-c1">location</span><span class="pl-kos">,</span>  
          <span class="pl-s1">_d</span> <span class="pl-c1">=</span> <span class="pl-s1">_c</span> <span class="pl-c1">===</span> <span class="pl-k">void</span> <span class="pl-c1">0</span> ? <span class="pl-kos">[</span><span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">0</span><span class="pl-kos">]</span> : <span class="pl-s1">_c</span><span class="pl-kos">,</span>  
          <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">_d</span><span class="pl-kos">[</span><span class="pl-c1">0</span><span class="pl-kos">]</span><span class="pl-kos">,</span>  
          <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-s1">_d</span><span class="pl-kos">[</span><span class="pl-c1">1</span><span class="pl-kos">]</span><span class="pl-kos">,</span>  
          <span class="pl-s1">_e</span> <span class="pl-c1">=</span> <span class="pl-s1">_a</span><span class="pl-kos">.</span><span class="pl-c1">bold</span><span class="pl-kos">,</span>  
          <span class="pl-s1">bold</span> <span class="pl-c1">=</span> <span class="pl-s1">_e</span> <span class="pl-c1">===</span> <span class="pl-k">void</span> <span class="pl-c1">0</span> ? <span class="pl-c1">false</span> : <span class="pl-s1">_e</span><span class="pl-kos">;</span>  
      <span class="pl-c">// Draw text  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Destructuring parameter declarations do not permit type annotations on the individual binding patterns, as such annotations would conflict with the already established meaning of colons in object literals. Type annotations must instead be written on the top-level parameter declaration. For example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">DrawTextInfo</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">text</span>?: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-c1">location</span>?: <span class="pl-kos">[</span><span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-smi">number</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
      <span class="pl-c1">bold</span>?: <span class="pl-smi">boolean</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-en">drawText</span><span class="pl-kos">(</span><span class="pl-kos">{</span> text<span class="pl-kos">,</span> <span class="pl-c1">location</span>: <span class="pl-kos">[</span><span class="pl-s1">x</span><span class="pl-kos">,</span> <span class="pl-s1">y</span><span class="pl-kos">]</span><span class="pl-kos">,</span> bold <span class="pl-kos">}</span>: <span class="pl-smi">DrawTextInfo</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-c">// Draw text  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h2 id="generic-functions-65" title="6.5"> Generic Functions</h2>
  <p>A function implementation may include type parameters in its signature (section <a href="sec-types#type-parameters-3921">3.9.2.1</a>) and is then called a <em><strong>generic function</strong></em>. Type parameters provide a mechanism for expressing relationships between parameter and return types in call operations. Type parameters have no run-time representation—they are purely a compile-time construct.</p>
  <p>Type parameters declared in the signature of a function implementation are in scope in the signature and body of that function implementation.</p>
  <p>The following is an example of a generic function:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Comparable</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">localeCompare</span><span class="pl-kos">(</span><span class="pl-s1">other</span>: <span class="pl-smi">any</span><span class="pl-kos">)</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-en">compare</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span> <span class="pl-k">extends</span> <span class="pl-smi">Comparable</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span>: <span class="pl-smi">number</span> <span class="pl-kos">{</span>  
      <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">x</span> <span class="pl-c1">==</span> <span class="pl-c1">null</span><span class="pl-kos">)</span> <span class="pl-k">return</span> <span class="pl-s1">y</span> <span class="pl-c1">==</span> <span class="pl-c1">null</span> ? <span class="pl-c1">0</span> : <span class="pl-c1">-</span><span class="pl-c1">1</span><span class="pl-kos">;</span>  
      <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">y</span> <span class="pl-c1">==</span> <span class="pl-c1">null</span><span class="pl-kos">)</span> <span class="pl-k">return</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
      <span class="pl-k">return</span> <span class="pl-s1">x</span><span class="pl-kos">.</span><span class="pl-en">localeCompare</span><span class="pl-kos">(</span><span class="pl-s1">y</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that the 'x' and 'y' parameters are known to be subtypes of the constraint 'Comparable' and therefore have a 'compareTo' member. This is described further in section <a href="sec-types#type-parameter-lists-361">3.6.1</a>.</p>
  <p>The type arguments of a call to a generic function may be explicitly specified in a call operation or may, when possible, be inferred (section <a href="sec-expressions#type-argument-inference-4152">4.15.2</a>) from the types of the regular arguments in the call. In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Person</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-en">localeCompare</span><span class="pl-kos">(</span><span class="pl-s1">other</span>: <span class="pl-smi">Person</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-en">compare</span><span class="pl-kos">(</span><span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">name</span><span class="pl-kos">,</span> <span class="pl-s1">other</span><span class="pl-kos">.</span><span class="pl-c1">name</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the type argument to 'compare' is automatically inferred to be the String type because the two arguments are strings.</p>
  <h2 id="code-generation-66" title="6.6"> Code Generation</h2><section id="user-content-6.6"><p>A function declaration generates JavaScript code that is equivalent to:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-c1">&lt;</span><span class="pl-smi">FunctionName</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">FunctionParameters</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">&lt;</span><span class="pl-smi">DefaultValueAssignments</span><span class="pl-c1">&gt;</span>  
      <span class="pl-c1">&lt;</span><span class="pl-smi">FunctionStatements</span><span class="pl-c1">&gt;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p><em>FunctionName</em> is the name of the function (or nothing in the case of a function expression).</p>
  <p><em>FunctionParameters</em> is a comma separated list of the function's parameter names.</p>
  <p><em>DefaultValueAssignments</em> is a sequence of default property value assignments, one for each parameter with a default value, in the order they are declared, of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">Parameter</span><span class="pl-c1">&gt;</span> <span class="pl-c1">===</span> <span class="pl-k">void</span> <span class="pl-c1">0</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-c1">&lt;</span><span class="pl-smi">Parameter</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-c1">&lt;</span><span class="pl-smi">Default</span><span class="pl-c1">&gt;</span><span class="pl-kos">;</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>Parameter</em> is the parameter name and <em>Default</em> is the default value expression.</p>
  <p><em>FunctionStatements</em> is the code generated for the statements specified in the function body.</p>
  </section><h2 id="generator-functions-67" title="6.7"> Generator Functions</h2>
  <p><section id="user-content-6.7"><em>TODO: Document </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/2873">generator functions</a></em>.</p>
  <h2 id="asynchronous-functions-68" title="6.8"> Asynchronous Functions</h2>
  <p><section id="user-content-6.8"><em>TODO: Document </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/1664">asynchronous functions</a></em>.</p>
  <h2 id="type-guard-functions-69" title="6.9"> Type Guard Functions</h2>
  <p><section id="user-content-6.9"><em>TODO: Document </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/1007">type guard functions</a>, including <a href="https://github.com/Microsoft/TypeScript/pull/5906">this type predicates</a></em>.</p>
  <br />
  </section>