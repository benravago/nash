<section id="sec-introduction"><h1 id="introduction-1" title="1"> Introduction</h1><section id="user-content-1"><p>JavaScript applications such as web e-mail, maps, document editing, and collaboration tools are becoming an increasingly important part of the everyday computing. We designed TypeScript to meet the needs of the JavaScript programming teams that build and maintain large JavaScript programs. TypeScript helps programming teams to define interfaces between software components and to gain insight into the behavior of existing JavaScript libraries. TypeScript also enables teams to reduce naming conflicts by organizing their code into dynamically-loadable modules. TypeScript's optional type system enables JavaScript programmers to use highly-productive development tools and practices: static checking, symbol-based navigation, statement completion, and code refactoring.</p>
  <p>TypeScript is a syntactic sugar for JavaScript. TypeScript syntax is a superset of ECMAScript 2015 (ES2015) syntax. Every JavaScript program is also a TypeScript program. The TypeScript compiler performs only file-local transformations on TypeScript programs and does not re-order variables declared in TypeScript. This leads to JavaScript output that closely matches the TypeScript input. TypeScript does not transform variable names, making tractable the direct debugging of emitted JavaScript. TypeScript optionally provides source maps, enabling source-level debugging. TypeScript tools typically emit JavaScript upon file save, preserving the test, edit, refresh cycle commonly used in JavaScript development.</p>
  <p>TypeScript syntax includes all features of ECMAScript 2015, including classes and modules, and provides the ability to translate these features into ECMAScript 3 or 5 compliant code.</p>
  <p>Classes enable programmers to express common object-oriented patterns in a standard way, making features like inheritance more readable and interoperable. Modules enable programmers to organize their code into components while avoiding naming conflicts. The TypeScript compiler provides module code generation options that support either static or dynamic loading of module contents.</p>
  <p>TypeScript also provides to JavaScript programmers a system of optional type annotations. These type annotations are like the JSDoc comments found in the Closure system, but in TypeScript they are integrated directly into the language syntax. This integration makes the code more readable and reduces the maintenance cost of synchronizing type annotations with their corresponding variables.</p>
  <p>The TypeScript type system enables programmers to express limits on the capabilities of JavaScript objects, and to use tools that enforce these limits. To minimize the number of annotations needed for tools to become useful, the TypeScript type system makes extensive use of type inference. For example, from the following statement, TypeScript will infer that the variable 'i' has the type number.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">i</span> <span class="pl-c1">=</span> <span class="pl-c1">0</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>TypeScript will infer from the following function definition that the function f has return type string.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-s">"hello"</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>To benefit from this inference, a programmer can use the TypeScript language service. For example, a code editor can incorporate the TypeScript language service and use the service to find the members of a string object as in the following screenshot.</p>
  <p>  <img src="./img/image1.png" alt="" style="max-width: 100%;" /></p>
  <p>In this example, the programmer benefits from type inference without providing type annotations. Some beneficial tools, however, do require the programmer to provide type annotations. In TypeScript, we can express a parameter requirement as in the following code fragment.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">s</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-s1">s</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-kos">{</span><span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>       <span class="pl-c">// Error  </span>
  <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s">"hello"</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This optional type annotation on the parameter 's' lets the TypeScript type checker know that the programmer expects parameter 's' to be of type 'string'. Within the body of function 'f', tools can assume 's' is of type 'string' and provide operator type checking and member completion consistent with this assumption. Tools can also signal an error on the first call to 'f', because 'f' expects a string, not an object, as its parameter. For the function 'f', the TypeScript compiler will emit the following JavaScript code:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">s</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-s1">s</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the JavaScript output, all type annotations have been erased. In general, TypeScript erases all type information before emitting JavaScript.</p>
  </section><h2 id="ambient-declarations-11" title="1.1"> Ambient Declarations</h2><section id="user-content-1.1"><p>An ambient declaration introduces a variable into a TypeScript scope, but has zero impact on the emitted JavaScript program. Programmers can use ambient declarations to tell the TypeScript compiler that some other component will supply a variable. For example, by default the TypeScript compiler will print an error for uses of undefined variables. To add some of the common variables defined by browsers, a TypeScript programmer can use ambient declarations. The following example declares the 'document' object supplied by browsers. Because the declaration does not specify a type, the type 'any' is inferred. The type 'any' means that a tool can assume nothing about the shape or behavior of the document object. Some of the examples below will illustrate how programmers can use types to further characterize the expected behavior of an object.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">declare</span> <span class="pl-k">var</span> <span class="pl-smi">document</span><span class="pl-kos">;</span>  
  <span class="pl-smi">document</span><span class="pl-kos">.</span><span class="pl-c1">title</span> <span class="pl-c1">=</span> <span class="pl-s">"Hello"</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok because document has been declared</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the case of 'document', the TypeScript compiler automatically supplies a declaration, because TypeScript by default includes a file 'lib.d.ts' that provides interface declarations for the built-in JavaScript library as well as the Document Object Model.</p>
  <p>The TypeScript compiler does not include by default an interface for jQuery, so to use jQuery, a programmer could supply a declaration such as:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">declare</span> <span class="pl-k">var</span> <span class="pl-s1">$</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p>Section <a href="#object-types-13">1.3</a> provides a more extensive example of how a programmer can add type information for jQuery and other libraries.</p>
  <h2 id="function-types-12" title="1.2"> Function Types</h2><section id="user-content-1.2"><p>Function expressions are a powerful feature of JavaScript. They enable function definitions to create closures: functions that capture information from the lexical scope surrounding the function's definition. Closures are currently JavaScript's only way of enforcing data encapsulation. By capturing and using environment variables, a closure can retain information that cannot be accessed from outside the closure. JavaScript programmers often use closures to express event handlers and other asynchronous callbacks, in which another software component, such as the DOM, will call back into JavaScript through a handler function.</p>
  <p>TypeScript function types make it possible for programmers to express the expected <em>signature</em> of a function. A function signature is a sequence of parameter types plus a return type. The following example uses function types to express the callback signature requirements of an asynchronous voting mechanism.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">vote</span><span class="pl-kos">(</span><span class="pl-s1">candidate</span>: <span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-s1">callback</span>: <span class="pl-kos">(</span><span class="pl-s1">result</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">any</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
     <span class="pl-c">// ...  </span>
  <span class="pl-kos">}</span>
  
  <span class="pl-en">vote</span><span class="pl-kos">(</span><span class="pl-s">"BigPig"</span><span class="pl-kos">,</span>  
       <span class="pl-k">function</span><span class="pl-kos">(</span><span class="pl-s1">result</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
           <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">result</span> <span class="pl-c1">===</span> <span class="pl-s">"BigPig"</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
              <span class="pl-c">// ...  </span>
           <span class="pl-kos">}</span>  
       <span class="pl-kos">}</span>  
  <span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In this example, the second parameter to 'vote' has the function type</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span><span class="pl-s1">result</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">any</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>which means the second parameter is a function returning type 'any' that has a single parameter of type 'string' named 'result'.</p>
  </section><p>Section <a href="sec-types#call-signatures-392">3.9.2</a> provides additional information about function types.</p>
  <h2 id="object-types-13" title="1.3"> Object Types</h2><section id="user-content-1.3"><p>TypeScript programmers use <em>object types</em> to declare their expectations of object behavior. The following code uses an <em>object type literal</em> to specify the return type of the 'MakePoint' function.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-smi">MakePoint</span>: <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Programmers can give names to object types; we call named object types <em>interfaces</em>. For example, in the following code, an interface declares one required field (name) and one optional field (favoriteColor).</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Friend</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-c1">favoriteColor</span>?: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-en">add</span><span class="pl-kos">(</span><span class="pl-s1">friend</span>: <span class="pl-smi">Friend</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">name</span> <span class="pl-c1">=</span> <span class="pl-s1">friend</span><span class="pl-kos">.</span><span class="pl-c1">name</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-en">add</span><span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">name</span>: <span class="pl-s">"Fred"</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok  </span>
  <span class="pl-en">add</span><span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">favoriteColor</span>: <span class="pl-s">"blue"</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Error, name required  </span>
  <span class="pl-en">add</span><span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">name</span>: <span class="pl-s">"Jill"</span><span class="pl-kos">,</span> <span class="pl-c1">favoriteColor</span>: <span class="pl-s">"green"</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>TypeScript object types model the diversity of behaviors that a JavaScript object can exhibit. For example, the jQuery library defines an object, '$', that has methods, such as 'get' (which sends an Ajax message), and fields, such as 'browser' (which gives browser vendor information). However, jQuery clients can also call '$' as a function. The behavior of this function depends on the type of parameters passed to the function.</p>
  <p>The following code fragment captures a small subset of jQuery behavior, just enough to use jQuery in a simple way.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">JQuery</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">text</span><span class="pl-kos">(</span><span class="pl-s1">content</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>  
    
  <span class="pl-k">interface</span> <span class="pl-smi">JQueryStatic</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">get</span><span class="pl-kos">(</span><span class="pl-s1">url</span>: <span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-s1">callback</span>: <span class="pl-kos">(</span><span class="pl-s1">data</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">any</span><span class="pl-kos">)</span><span class="pl-kos">;</span>     
      <span class="pl-kos">(</span><span class="pl-s1">query</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">JQuery</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">declare</span> <span class="pl-k">var</span> <span class="pl-s1">$</span>: <span class="pl-smi">JQueryStatic</span><span class="pl-kos">;</span>
  
  <span class="pl-s1">$</span><span class="pl-kos">.</span><span class="pl-en">get</span><span class="pl-kos">(</span><span class="pl-s">"http://mysite.org/divContent"</span><span class="pl-kos">,</span>  
        <span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-s1">data</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
            <span class="pl-en">$</span><span class="pl-kos">(</span><span class="pl-s">"div"</span><span class="pl-kos">)</span><span class="pl-kos">.</span><span class="pl-en">text</span><span class="pl-kos">(</span><span class="pl-s1">data</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
        <span class="pl-kos">}</span>  
  <span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The 'JQueryStatic' interface references another interface: 'JQuery'. This interface represents a collection of one or more DOM elements. The jQuery library can perform many operations on such a collection, but in this example the jQuery client only needs to know that it can set the text content of each jQuery element in a collection by passing a string to the 'text' method. The 'JQueryStatic' interface also contains a method, 'get', that performs an Ajax get operation on the provided URL and arranges to invoke the provided callback upon receipt of a response.</p>
  <p>Finally, the 'JQueryStatic' interface contains a bare function signature</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span><span class="pl-s1">query</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">JQuery</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The bare signature indicates that instances of the interface are callable. This example illustrates that TypeScript function types are just special cases of TypeScript object types. Specifically, function types are object types that contain one or more call signatures. For this reason we can write any function type as an object type literal. The following example uses both forms to describe the same type.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">f</span>: <span class="pl-kos">{</span> <span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">sameType</span>: <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">string</span> <span class="pl-c1">=</span> <span class="pl-s1">f</span><span class="pl-kos">;</span>     <span class="pl-c">// Ok  </span>
  <span class="pl-k">var</span> <span class="pl-s1">nope</span>: <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">number</span> <span class="pl-c1">=</span> <span class="pl-s1">sameType</span><span class="pl-kos">;</span>  <span class="pl-c">// Error: type mismatch</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>We mentioned above that the '$' function behaves differently depending on the type of its parameter. So far, our jQuery typing only captures one of these behaviors: return an object of type 'JQuery' when passed a string. To specify multiple behaviors, TypeScript supports <em>overloading</em> of function signatures in object types. For example, we can add an additional call signature to the 'JQueryStatic' interface.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span><span class="pl-s1">ready</span>: <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">any</span><span class="pl-kos">)</span>: <span class="pl-smi">any</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This signature denotes that a function may be passed as the parameter of the '$' function. When a function is passed to '$', the jQuery library will invoke that function when a DOM document is ready. Because TypeScript supports overloading, tools can use TypeScript to show all available function signatures with their documentation tips and to give the correct documentation once a function has been called with a particular signature.</p>
  <p>A typical client would not need to add any additional typing but could just use a community-supplied typing to discover (through statement completion with documentation tips) and verify (through static checking) correct use of the library, as in the following screenshot.</p>
  <p>  <img src="./img/image2.png" alt="" style="max-width: 100%;" /></p>
  </section><p>Section <a href="sec-types#object-types-33">3.3</a> provides additional information about object types.</p>
  <h2 id="structural-subtyping-14" title="1.4"> Structural Subtyping</h2><section id="user-content-1.4"><p>Object types are compared <em>structurally</em>. For example, in the code fragment below, class 'CPoint' matches interface 'Point' because 'CPoint' has all of the required members of 'Point'. A class may optionally declare that it implements an interface, so that the compiler will check the declaration for structural compatibility. The example also illustrates that an object type can match the type inferred from an object literal, as long as the object literal supplies all of the required members.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-en">getX</span><span class="pl-kos">(</span><span class="pl-s1">p</span>: <span class="pl-smi">Point</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-s1">p</span><span class="pl-kos">.</span><span class="pl-c1">x</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">CPoint</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span>  <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span><span class="pl-kos">;</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">y</span> <span class="pl-c1">=</span> <span class="pl-s1">y</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-en">getX</span><span class="pl-kos">(</span><span class="pl-k">new</span> <span class="pl-smi">CPoint</span><span class="pl-kos">(</span><span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">0</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok, fields match</span>
  
  <span class="pl-en">getX</span><span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">color</span>: <span class="pl-s">"red"</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Extra fields Ok</span>
  
  <span class="pl-en">getX</span><span class="pl-kos">(</span><span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">0</span> <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Error: supplied parameter does not match</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p>See section <a href="sec-types#type-relationships-311">3.11</a> for more information about type comparisons.</p>
  <h2 id="contextual-typing-15" title="1.5"> Contextual Typing</h2><section id="user-content-1.5"><p>Ordinarily, TypeScript type inference proceeds "bottom-up": from the leaves of an expression tree to its root. In the following example, TypeScript infers 'number' as the return type of the function 'mul' by flowing type information bottom up in the return expression.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">mul</span><span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">b</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-s1">a</span> <span class="pl-c1">*</span> <span class="pl-s1">b</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>For variables and parameters without a type annotation or a default value, TypeScript infers type 'any', ensuring that compilers do not need non-local information about a function's call sites to infer the function's return type. Generally, this bottom-up approach provides programmers with a clear intuition about the flow of type information.</p>
  <p>However, in some limited contexts, inference proceeds "top-down" from the context of an expression. Where this happens, it is called contextual typing. Contextual typing helps tools provide excellent information when a programmer is using a type but may not know all of the details of the type. For example, in the jQuery example, above, the programmer supplies a function expression as the second parameter to the 'get' method. During typing of that expression, tools can assume that the type of the function expression is as given in the 'get' signature and can provide a template that includes parameter names and types.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">$</span><span class="pl-kos">.</span><span class="pl-en">get</span><span class="pl-kos">(</span><span class="pl-s">"http://mysite.org/divContent"</span><span class="pl-kos">,</span>  
        <span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-s1">data</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
            <span class="pl-en">$</span><span class="pl-kos">(</span><span class="pl-s">"div"</span><span class="pl-kos">)</span><span class="pl-kos">.</span><span class="pl-en">text</span><span class="pl-kos">(</span><span class="pl-s1">data</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// TypeScript infers data is a string  </span>
        <span class="pl-kos">}</span>  
  <span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Contextual typing is also useful for writing out object literals. As the programmer types the object literal, the contextual type provides information that enables tools to provide completion for object member names.</p>
  </section><p>Section <a href="sec-expressions#contextually-typed-expressions-423">4.23</a> provides additional information about contextually typed expressions.</p>
  <h2 id="classes-16" title="1.6"> Classes</h2><section id="user-content-1.6"><p>JavaScript practice has two very common design patterns: the module pattern and the class pattern. Roughly speaking, the module pattern uses closures to hide names and to encapsulate private data, while the class pattern uses prototype chains to implement many variations on object-oriented inheritance mechanisms. Libraries such as 'prototype.js' are typical of this practice. TypeScript's namespaces are a formalization of the module pattern. (The term "module pattern" is somewhat unfortunate now that ECMAScript 2015 formally supports modules in a manner different from what the module pattern prescribes. For this reason, TypeScript uses the term "namespace" for its formalization of the module pattern.)</p>
  <p>This section and the namespace section below will show how TypeScript emits consistent, idiomatic JavaScript when emitting ECMAScript 3 or 5 compliant code for classes and namespaces. The goal of TypeScript's translation is to emit exactly what a programmer would type when implementing a class or namespace unaided by a tool. This section will also describe how TypeScript infers a type for each class declaration. We'll start with a simple BankAccount class.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">BankAccount</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">balance</span> <span class="pl-c1">=</span> <span class="pl-c1">0</span><span class="pl-kos">;</span>  
      <span class="pl-en">deposit</span><span class="pl-kos">(</span><span class="pl-s1">credit</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span> <span class="pl-c1">+=</span> <span class="pl-s1">credit</span><span class="pl-kos">;</span>  
          <span class="pl-k">return</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>  </pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This class generates the following JavaScript code.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-smi">BankAccount</span> <span class="pl-c1">=</span> <span class="pl-kos">(</span><span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">function</span> <span class="pl-smi">BankAccount</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span> <span class="pl-c1">=</span> <span class="pl-c1">0</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-smi">BankAccount</span><span class="pl-kos">.</span><span class="pl-c1">prototype</span><span class="pl-kos">.</span><span class="pl-en">deposit</span> <span class="pl-c1">=</span> <span class="pl-k">function</span><span class="pl-kos">(</span><span class="pl-s1">credit</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span> <span class="pl-c1">+=</span> <span class="pl-s1">credit</span><span class="pl-kos">;</span>  
          <span class="pl-k">return</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span><span class="pl-kos">;</span>  
      <span class="pl-k">return</span> <span class="pl-smi">BankAccount</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This TypeScript class declaration creates a variable named 'BankAccount' whose value is the constructor function for 'BankAccount' instances. This declaration also creates an instance type of the same name. If we were to write this type as an interface it would look like the following.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">BankAccount</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">balance</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">deposit</span><span class="pl-kos">(</span><span class="pl-s1">credit</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>If we were to write out the function type declaration for the 'BankAccount' constructor variable, it would have the following form.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-smi">BankAccount</span>: <span class="pl-k">new</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">BankAccount</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The function signature is prefixed with the keyword 'new' indicating that the 'BankAccount' function must be called as a constructor. It is possible for a function's type to have both call and constructor signatures. For example, the type of the built-in JavaScript Date object includes both kinds of signatures.</p>
  <p>If we want to start our bank account with an initial balance, we can add to the 'BankAccount' class a constructor declaration.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">BankAccount</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">balance</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-s1">initially</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span> <span class="pl-c1">=</span> <span class="pl-s1">initially</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-en">deposit</span><span class="pl-kos">(</span><span class="pl-s1">credit</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span> <span class="pl-c1">+=</span> <span class="pl-s1">credit</span><span class="pl-kos">;</span>  
          <span class="pl-k">return</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This version of the 'BankAccount' class requires us to introduce a constructor parameter and then assign it to the 'balance' field. To simplify this common case, TypeScript accepts the following shorthand syntax.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">BankAccount</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-k">public</span> <span class="pl-s1">balance</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-en">deposit</span><span class="pl-kos">(</span><span class="pl-s1">credit</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span> <span class="pl-c1">+=</span> <span class="pl-s1">credit</span><span class="pl-kos">;</span>  
          <span class="pl-k">return</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The 'public' keyword denotes that the constructor parameter is to be retained as a field. Public is the default accessibility for class members, but a programmer can also specify private or protected accessibility for a class member. Accessibility is a design-time construct; it is enforced during static type checking but does not imply any runtime enforcement.</p>
  <p>TypeScript classes also support inheritance, as in the following example.* *</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">CheckingAccount</span> <span class="pl-k">extends</span> <span class="pl-smi">BankAccount</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-s1">balance</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">super</span><span class="pl-kos">(</span><span class="pl-s1">balance</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-en">writeCheck</span><span class="pl-kos">(</span><span class="pl-s1">debit</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">balance</span> <span class="pl-c1">-=</span> <span class="pl-s1">debit</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In this example, the class 'CheckingAccount' <em>derives</em> from class 'BankAccount'. The constructor for 'CheckingAccount' calls the constructor for class 'BankAccount' using the 'super' keyword. In the emitted JavaScript code, the prototype of 'CheckingAccount' will chain to the prototype of 'BankAccount'.</p>
  <p>TypeScript classes may also specify static members. Static class members become properties of the class constructor.</p>
  </section><p>Section <a href="sec-classes#classes-8">8</a> provides additional information about classes.</p>
  <h2 id="enum-types-17" title="1.7"> Enum Types</h2><section id="user-content-1.7"><p>TypeScript enables programmers to summarize a set of numeric constants as an <em>enum type</em>. The example below creates an enum type to represent operators in a calculator application.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">const</span> <span class="pl-k">enum</span> <span class="pl-smi">Operator</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">ADD</span><span class="pl-kos">,</span>  
      <span class="pl-c1">DIV</span><span class="pl-kos">,</span>  
      <span class="pl-c1">MUL</span><span class="pl-kos">,</span>  
      <span class="pl-c1">SUB</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-en">compute</span><span class="pl-kos">(</span><span class="pl-s1">op</span>: <span class="pl-smi">Operator</span><span class="pl-kos">,</span> <span class="pl-s1">a</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">b</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-smi">console</span><span class="pl-kos">.</span><span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-s">"the operator is"</span> <span class="pl-c1">+</span> <span class="pl-smi">Operator</span><span class="pl-kos">[</span><span class="pl-s1">op</span><span class="pl-kos">]</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-c">// ...  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p>In this example, the compute function logs the operator 'op' using a feature of enum types: reverse mapping from the enum value ('op') to the string corresponding to that value. For example, the declaration of 'Operator' automatically assigns integers, starting from zero, to the listed enum members. Section <a href="sec-enums#enums-9">9</a> describes how programmers can also explicitly assign integers to enum members, and can use any string to name an enum member.</p>
  <p>When enums are declared with the <code>const</code> modifier, the TypeScript compiler will emit for an enum member a JavaScript constant corresponding to that member's assigned value (annotated with a comment). This improves performance on many JavaScript engines.</p>
  <p>For example, the 'compute' function could contain a switch statement like the following.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">switch</span> <span class="pl-kos">(</span><span class="pl-s1">op</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">case</span> <span class="pl-smi">Operator</span><span class="pl-kos">.</span><span class="pl-c1">ADD</span>:  
          <span class="pl-c">// execute add  </span>
          <span class="pl-k">break</span><span class="pl-kos">;</span>  
      <span class="pl-k">case</span> <span class="pl-smi">Operator</span><span class="pl-kos">.</span><span class="pl-c1">DIV</span>:  
          <span class="pl-c">// execute div  </span>
          <span class="pl-k">break</span><span class="pl-kos">;</span>  
      <span class="pl-c">// ...  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>For this switch statement, the compiler will generate the following code.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">switch</span> <span class="pl-kos">(</span><span class="pl-s1">op</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">case</span> <span class="pl-c1">0</span> <span class="pl-c">/* Operator.ADD */</span>:  
          <span class="pl-c">// execute add  </span>
          <span class="pl-k">break</span><span class="pl-kos">;</span>  
      <span class="pl-k">case</span> <span class="pl-c1">1</span> <span class="pl-c">/* Operator.DIV */</span>:  
          <span class="pl-c">// execute div  </span>
          <span class="pl-k">break</span><span class="pl-kos">;</span>  
      <span class="pl-c">// ...  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>JavaScript implementations can use these explicit constants to generate efficient code for this switch statement, for example by building a jump table indexed by case value.</p>
  <h2 id="overloading-on-string-parameters-18" title="1.8"> Overloading on String Parameters</h2><section id="user-content-1.8"><p>An important goal of TypeScript is to provide accurate and straightforward types for existing JavaScript programming patterns. To that end, TypeScript includes generic types, discussed in the next section, and <em>overloading on string parameters</em>, the topic of this section.</p>
  <p>JavaScript programming interfaces often include functions whose behavior is discriminated by a string constant passed to the function. The Document Object Model makes heavy use of this pattern. For example, the following screenshot shows that the 'createElement' method of the 'document' object has multiple signatures, some of which identify the types returned when specific strings are passed into the method.</p>
  <p>  <img src="./img/image3.png" alt="" style="max-width: 100%;" /></p>
  <p>The following code fragment uses this feature. Because the 'span' variable is inferred to have the type 'HTMLSpanElement', the code can reference without static error the 'isMultiline' property of 'span'.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">span</span> <span class="pl-c1">=</span> <span class="pl-smi">document</span><span class="pl-kos">.</span><span class="pl-en">createElement</span><span class="pl-kos">(</span><span class="pl-s">"span"</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-s1">span</span><span class="pl-kos">.</span><span class="pl-c1">isMultiLine</span> <span class="pl-c1">=</span> <span class="pl-c1">false</span><span class="pl-kos">;</span>  <span class="pl-c">// OK: HTMLSpanElement has isMultiline property</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the following screenshot, a programming tool combines information from overloading on string parameters with contextual typing to infer that the type of the variable 'e' is 'MouseEvent' and that therefore 'e' has a 'clientX' property.</p>
  <p>  <img src="./img/image4.png" alt="" style="max-width: 100%;" /></p>
  </section><p>Section <a href="sec-types#specialized-signatures-3924">3.9.2.4</a> provides details on how to use string literals in function signatures.</p>
  <h2 id="generic-types-and-functions-19" title="1.9"> Generic Types and Functions</h2><section id="user-content-1.9"><p>Like overloading on string parameters, <em>generic types</em> make it easier for TypeScript to accurately capture the behavior of JavaScript libraries. Because they enable type information to flow from client code, through library code, and back into client code, generic types may do more than any other TypeScript feature to support detailed API descriptions.</p>
  <p>To illustrate this, let's take a look at part of the TypeScript interface for the built-in JavaScript array type. You can find this interface in the 'lib.d.ts' file that accompanies a TypeScript distribution.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Array</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">reverse</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
      <span class="pl-c1">sort</span><span class="pl-kos">(</span><span class="pl-s1">compareFn</span>?: <span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-s1">b</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
      <span class="pl-c">// ...   </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Interface definitions, like the one above, can have one or more <em>type parameters</em>. In this case the 'Array' interface has a single parameter, 'T', that defines the element type for the array. The 'reverse' method returns an array with the same element type. The sort method takes an optional parameter, 'compareFn', whose type is a function that takes two parameters of type 'T' and returns a number. Finally, sort returns an array with element type 'T'.</p>
  <p>Functions can also have generic parameters. For example, the array interface contains a 'map' method, defined as follows:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">map</span><span class="pl-c1">&lt;</span><span class="pl-smi">U</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">func</span>: <span class="pl-kos">(</span><span class="pl-s1">value</span>: <span class="pl-smi">T</span><span class="pl-kos">,</span> <span class="pl-s1">index</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">array</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">U</span><span class="pl-kos">,</span> <span class="pl-s1">thisArg</span>?: <span class="pl-smi">any</span><span class="pl-kos">)</span>: <span class="pl-smi">U</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The map method, invoked on an array 'a' with element type 'T', will apply function 'func' to each element of 'a', returning a value of type 'U'.</p>
  <p>The TypeScript compiler can often infer generic method parameters, making it unnecessary for the programmer to explicitly provide them. In the following example, the compiler infers that parameter 'U' of the map method has type 'string', because the function passed to map returns a string.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">numberToString</span><span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">number</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">stringArray</span> <span class="pl-c1">=</span> <span class="pl-s1">a</span><span class="pl-kos">.</span><span class="pl-en">map</span><span class="pl-kos">(</span><span class="pl-s1">v</span> <span class="pl-c1">=&gt;</span> <span class="pl-s1">v</span><span class="pl-kos">.</span><span class="pl-en">toString</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-k">return</span> <span class="pl-s1">stringArray</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The compiler infers in this example that the 'numberToString' function returns an array of strings.</p>
  <p>In TypeScript, classes can also have type parameters. The following code declares a class that implements a linked list of items of type 'T'. This code illustrates how programmers can <em>constrain</em> type parameters to extend a specific type. In this case, the items on the list must extend the type 'NamedItem'. This enables the programmer to implement the 'log' function, which logs the name of the item.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">NamedItem</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">List</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span> <span class="pl-k">extends</span> <span class="pl-smi">NamedItem</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">next</span>: <span class="pl-smi">List</span><span class="pl-kos">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">&gt;</span> <span class="pl-c1">=</span> <span class="pl-c1">null</span><span class="pl-kos">;</span>
  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-k">public</span> <span class="pl-s1">item</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-kos">}</span>
  
      <span class="pl-en">insertAfter</span><span class="pl-kos">(</span><span class="pl-s1">item</span>: <span class="pl-smi">T</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">var</span> <span class="pl-s1">temp</span> <span class="pl-c1">=</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">next</span><span class="pl-kos">;</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">next</span> <span class="pl-c1">=</span> <span class="pl-k">new</span> <span class="pl-smi">List</span><span class="pl-kos">(</span><span class="pl-s1">item</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">next</span><span class="pl-kos">.</span><span class="pl-c1">next</span> <span class="pl-c1">=</span> <span class="pl-s1">temp</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>
  
      <span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">console</span><span class="pl-kos">.</span><span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">item</span><span class="pl-kos">.</span><span class="pl-c1">name</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>
  
      <span class="pl-c">// ...  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p>Section <a href="sec-types#named-types-37">3.7</a> provides further information about generic types.</p>
  <h2 id="namespaces-110" title="1.10"> Namespaces</h2><section id="user-content-1.10"><p>Classes and interfaces support large-scale JavaScript development by providing a mechanism for describing how to use a software component that can be separated from that component's implementation. TypeScript enforces <em>encapsulation</em> of implementation in classes at design time (by restricting use of private and protected members), but cannot enforce encapsulation at runtime because all object properties are accessible at runtime. Future versions of JavaScript may provide <em>private names</em> which would enable runtime enforcement of private and protected members.</p>
  <p>In JavaScript, a very common way to enforce encapsulation at runtime is to use the module pattern: encapsulate private fields and methods using closure variables. The module pattern is a natural way to provide organizational structure and dynamic loading options by drawing a boundary around a software component. The module pattern can also provide the ability to introduce namespaces, avoiding use of the global namespace for most software components.</p>
  <p>The following example illustrates the JavaScript module pattern.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">(</span><span class="pl-k">function</span><span class="pl-kos">(</span><span class="pl-s1">exports</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">key</span> <span class="pl-c1">=</span> <span class="pl-en">generateSecretKey</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-k">function</span> <span class="pl-en">sendMessage</span><span class="pl-kos">(</span><span class="pl-s1">message</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-en">sendSecureMessage</span><span class="pl-kos">(</span><span class="pl-s1">message</span><span class="pl-kos">,</span> <span class="pl-s1">key</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-s1">exports</span><span class="pl-kos">.</span><span class="pl-c1">sendMessage</span> <span class="pl-c1">=</span> <span class="pl-s1">sendMessage</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">(</span><span class="pl-smi">MessageModule</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This example illustrates the two essential elements of the module pattern: a <em>module closure</em> and a <em>module</em> <em>object</em>. The module closure is a function that encapsulates the module's implementation, in this case the variable 'key' and the function 'sendMessage'. The module object contains the exported variables and functions of the module. Simple modules may create and return the module object. The module above takes the module object as a parameter, 'exports', and adds the 'sendMessage' property to the module object. This <em>augmentation</em> approach simplifies dynamic loading of modules and also supports separation of module code into multiple files.</p>
  <p>The example assumes that an outer lexical scope defines the functions 'generateSecretKey' and 'sendSecureMessage'; it also assumes that the outer scope has assigned the module object to the variable 'MessageModule'.</p>
  <p>TypeScript namespaces provide a mechanism for succinctly expressing the module pattern. In TypeScript, programmers can combine the module pattern with the class pattern by nesting namespaces and classes within an outer namespace.</p>
  <p>The following example shows the definition and use of a simple namespace.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">namespace</span> <span class="pl-smi">M</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">s</span> <span class="pl-c1">=</span> <span class="pl-s">"hello"</span><span class="pl-kos">;</span>  
      <span class="pl-k">export</span> <span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-s1">s</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-smi">M</span><span class="pl-kos">.</span><span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-smi">M</span><span class="pl-kos">.</span><span class="pl-c1">s</span><span class="pl-kos">;</span>  <span class="pl-c">// Error, s is not exported</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In this example, variable 's' is a private feature of the namespace, but function 'f' is exported from the namespace and accessible to code outside of the namespace. If we were to describe the effect of namespace 'M' in terms of interfaces and variables, we would write</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">M</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-smi">M</span>: <span class="pl-smi">M</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p>The interface 'M' summarizes the externally visible behavior of namespace 'M'. In this example, we can use the same name for the interface as for the initialized variable because in TypeScript type names and variable names do not conflict: each lexical scope contains a variable declaration space and type declaration space (see section <a href="sec-basic-concepts#declarations-23">2.3</a> for more details).</p>
  <p>The TypeScript compiler emits the following JavaScript code for the namespace:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-smi">M</span><span class="pl-kos">;</span>  
  <span class="pl-kos">(</span><span class="pl-k">function</span><span class="pl-kos">(</span><span class="pl-smi">M</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">s</span> <span class="pl-c1">=</span> <span class="pl-s">"hello"</span><span class="pl-kos">;</span>  
      <span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-s1">s</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-smi">M</span><span class="pl-kos">.</span><span class="pl-c1">f</span> <span class="pl-c1">=</span> <span class="pl-s1">f</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">(</span><span class="pl-smi">M</span> <span class="pl-c1">||</span> <span class="pl-kos">(</span><span class="pl-smi">M</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span><span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In this case, the compiler assumes that the namespace object resides in global variable 'M', which may or may not have been initialized to the desired namespace object.</p>
  <h2 id="modules-111" title="1.11"> Modules</h2><section id="user-content-1.11"><p>TypeScript also supports ECMAScript 2015 modules, which are files that contain top-level <em>export</em> and <em>import</em> directives. For this type of module the TypeScript compiler can emit both ECMAScript 2015 compliant code and down-level ECMAScript 3 or 5 compliant code for a variety of module loading systems, including CommonJS, Asynchronous Module Definition (AMD), and Universal Module Definition (UMD).</p>
  <br />
  </section></section>