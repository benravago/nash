<section id="sec-ambients"><h1 id="ambients-12" title="12"> Ambients</h1><section id="user-content-12"><p>Ambient declarations are used to provide static typing over existing JavaScript code. Ambient declarations differ from regular declarations in that no JavaScript code is emitted for them. Instead of introducing new variables, functions, classes, enums, or namespaces, ambient declarations provide type information for entities that exist "ambiently" and are included in a program by external means, for example by referencing a JavaScript library in a &lt;script/&gt; tag.</p>
  </section><h2 id="ambient-declarations-121" title="12.1"> Ambient Declarations</h2><section id="user-content-12.1"><p>Ambient declarations are written using the <code>declare</code> keyword and can declare variables, functions, classes, enums, namespaces, or modules.</p>
  <p>  <em>AmbientDeclaration:</em><br />
     <code>declare</code> <em>AmbientVariableDeclaration</em><br />
     <code>declare</code> <em>AmbientFunctionDeclaration</em><br />
     <code>declare</code> <em>AmbientClassDeclaration</em><br />
     <code>declare</code> <em>AmbientEnumDeclaration</em><br />
     <code>declare</code> <em>AmbientNamespaceDeclaration</em></p>
  </section><h3 id="ambient-variable-declarations-1211" title="12.1.1"> Ambient Variable Declarations</h3><section id="user-content-12.1.1"><p>An ambient variable declaration introduces a variable in the containing declaration space.</p>
  <p>  <em>AmbientVariableDeclaration:</em><br />
     <code>var</code> <em>AmbientBindingList</em> <code>;</code><br />
     <code>let</code> <em>AmbientBindingList</em> <code>;</code><br />
     <code>const</code> <em>AmbientBindingList</em> <code>;</code></p>
  <p>  <em>AmbientBindingList:</em><br />
     <em>AmbientBinding</em><br />
     <em>AmbientBindingList</em> <code>,</code> <em>AmbientBinding</em></p>
  <p>  <em>AmbientBinding:</em><br />
     <em>BindingIdentifier</em> <em>TypeAnnotation<sub>opt</sub></em></p>
  <p>An ambient variable declaration may optionally include a type annotation. If no type annotation is present, the variable is assumed to have type Any.</p>
  <p>An ambient variable declaration does not permit an initializer expression to be present.</p>
  </section><h3 id="ambient-function-declarations-1212" title="12.1.2"> Ambient Function Declarations</h3><section id="user-content-12.1.2"><p>An ambient function declaration introduces a function in the containing declaration space.</p>
  <p>  <em>AmbientFunctionDeclaration:</em><br />
     <code>function</code> <em>BindingIdentifier</em> <em>CallSignature</em> <code>;</code></p>
  </section><p>Ambient functions may be overloaded by specifying multiple ambient function declarations with the same name, but it is an error to declare multiple overloads that are considered identical (section <a href="sec-types#type-and-member-identity-3112">3.11.2</a>) or differ only in their return types.</p>
  <p>Ambient function declarations cannot specify a function bodies and do not permit default parameter values.</p>
  <h3 id="ambient-class-declarations-1213" title="12.1.3"> Ambient Class Declarations</h3><section id="user-content-12.1.3"><p>An ambient class declaration declares a class type and a constructor function in the containing declaration space.</p>
  <p>  <em>AmbientClassDeclaration:</em><br />
     <code>class</code> <em>BindingIdentifier</em> <em>TypeParameters<sub>opt</sub></em> <em>ClassHeritage</em> <code>{</code> <em>AmbientClassBody</em> <code>}</code></p>
  <p>  <em>AmbientClassBody:</em><br />
     <em>AmbientClassBodyElements<sub>opt</sub></em></p>
  <p>  <em>AmbientClassBodyElements:</em><br />
     <em>AmbientClassBodyElement</em><br />
     <em>AmbientClassBodyElements</em> <em>AmbientClassBodyElement</em></p>
  <p>  <em>AmbientClassBodyElement:</em><br />
     <em>AmbientConstructorDeclaration</em><br />
     <em>AmbientPropertyMemberDeclaration</em><br />
     <em>IndexSignature</em></p>
  <p>  <em>AmbientConstructorDeclaration:</em><br />
     <code>constructor</code> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <code>;</code></p>
  <p>  <em>AmbientPropertyMemberDeclaration:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>PropertyName</em> <em>TypeAnnotation<sub>opt</sub></em> <code>;</code><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>PropertyName</em> <em>CallSignature</em> <code>;</code></p>
  </section><h3 id="ambient-enum-declarations-1214" title="12.1.4"> Ambient Enum Declarations</h3><section id="user-content-12.1.4"><p>An ambient enum is grammatically equivalent to a non-ambient enum declaration.</p>
  <p>  <em>AmbientEnumDeclaration:</em><br />
     <em>EnumDeclaration</em></p>
  <p>Ambient enum declarations differ from non-ambient enum declarations in two ways:</p>
  <ul>
  <li>In ambient enum declarations, all values specified in enum member declarations must be classified as constant enum expressions.</li>
  <li>In ambient enum declarations that specify no <code>const</code> modifier, enum member declarations that omit a value are considered computed members (as opposed to having auto-incremented values assigned).</li>
  </ul>
  <p>Ambient enum declarations are otherwise processed in the same manner as non-ambient enum declarations.</p>
  </section><h3 id="ambient-namespace-declarations-1215" title="12.1.5"> Ambient Namespace Declarations</h3><section id="user-content-12.1.5"><p>An ambient namespace declaration declares a namespace.</p>
  <p>  <em>AmbientNamespaceDeclaration:</em><br />
     <code>namespace</code> <em>IdentifierPath</em> <code>{</code> <em>AmbientNamespaceBody</em> <code>}</code></p>
  <p>  <em>AmbientNamespaceBody:</em><br />
     <em>AmbientNamespaceElements<sub>opt</sub></em></p>
  <p>  <em>AmbientNamespaceElements:</em><br />
     <em>AmbientNamespaceElement</em><br />
     <em>AmbientNamespaceElements</em> <em>AmbientNamespaceElement</em></p>
  <p>  <em>AmbientNamespaceElement:</em><br />
     <code>export</code><em><sub>opt</sub></em> <em>AmbientVariableDeclaration</em><br />
     <code>export</code><em><sub>opt</sub></em> <em>AmbientLexicalDeclaration</em><br />
     <code>export</code><em><sub>opt</sub></em> <em>AmbientFunctionDeclaration</em><br />
     <code>export</code><em><sub>opt</sub></em> <em>AmbientClassDeclaration</em><br />
     <code>export</code><em><sub>opt</sub></em> <em>InterfaceDeclaration</em><br />
     <code>export</code><em><sub>opt</sub></em> <em>AmbientEnumDeclaration</em><br />
     <code>export</code><em><sub>opt</sub></em> <em>AmbientNamespaceDeclaration</em><br />
     <code>export</code><em><sub>opt</sub></em> <em>ImportAliasDeclaration</em></p>
  <p>Except for <em>ImportAliasDeclarations</em>, <em>AmbientNamespaceElements</em> always declare exported entities regardless of whether they include the optional <code>export</code> modifier.</p>
  </section><h2 id="ambient-module-declarations-122" title="12.2"> Ambient Module Declarations</h2>
  <p><section id="user-content-12.2"><em>AmbientModuleDeclaration</em> declares a module. This type of declaration is permitted only at the top level in a source file that contributes to the global namespace (section </section><a href="sec-scripts-and-modules#programs-and-source-files-111">11.1</a>). The <em>StringLiteral</em> must specify a top-level module name. Relative module names are not permitted.</p>
  <p>  <em>AmbientModuleDeclaration:</em><br />
     <code>declare</code> <code>module</code> <em>StringLiteral</em> <code>{</code>  <em>DeclarationModule</em> <code>}</code></p>
  <p>An <em>ImportRequireDeclaration</em> in an <em>AmbientModuleDeclaration</em> may reference other modules only through top-level module names. Relative module names are not permitted.</p>
  <p>If an ambient module declaration includes an export assignment, it is an error for any of the declarations within the module to specify an <code>export</code> modifier. If an ambient module declaration contains no export assignment, entities declared in the module are exported regardless of whether their declarations include the optional <code>export</code> modifier.</p>
  <p>Ambient modules are "open-ended" and ambient module declarations with the same string literal name contribute to a single module. For example, the following two declarations of a module 'io' might be located in separate source files.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">declare</span> module <span class="pl-s">"io"</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">function</span> <span class="pl-s1">readFile</span><span class="pl-kos">(</span><span class="pl-s1">filename</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">declare</span> module <span class="pl-s">"io"</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">function</span> <span class="pl-s1">writeFile</span><span class="pl-kos">(</span><span class="pl-s1">filename</span>: <span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-s1">data</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This has the same effect as a single combined declaration:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">declare</span> module <span class="pl-s">"io"</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">function</span> <span class="pl-s1">readFile</span><span class="pl-kos">(</span><span class="pl-s1">filename</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-k">export</span> <span class="pl-k">function</span> <span class="pl-s1">writeFile</span><span class="pl-kos">(</span><span class="pl-s1">filename</span>: <span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-s1">data</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <br />
  </section>