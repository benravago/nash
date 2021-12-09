<section id="sec-namespaces"><h1 id="namespaces-10" title="10"> Namespaces</h1>
  <p>Namespaces provide a mechanism for organizing code and declarations in hierarchies of named containers. Namespaces have named members that each denote a value, a type, or a namespace, or some combination thereof, and those members may be local or exported. The body of a namespace corresponds to a function that is executed once, thereby providing a mechanism for maintaining local state with assured isolation. Namespaces can be thought of as a formalization of the <a href="https://en.wikipedia.org/wiki/Immediately-invoked_function_expression" rel="nofollow">immediately-invoked function expression</a> (IIFE) pattern.</p>
  <h2 id="namespace-declarations-101" title="10.1"> Namespace Declarations</h2><section id="user-content-10.1"><p>A namespace declaration introduces a name with a namespace meaning and, in the case of an instantiated namespace, a value meaning in the containing declaration space.</p>
  <p>  <em>NamespaceDeclaration:</em><br />
     <code>namespace</code> <em>IdentifierPath</em> <code>{</code> <em>NamespaceBody</em> <code>}</code></p>
  <p>  <em>IdentifierPath:</em><br />
     <em>BindingIdentifier</em><br />
     <em>IdentifierPath</em> <code>.</code> <em>BindingIdentifier</em></p>
  <p>Namespaces are declared using the <code>namespace</code> keyword, but for backward compatibility of earlier versions of TypeScript a <code>module</code> keyword can also be used.</p>
  <p>Namespaces are either <em><strong>instantiated</strong></em> or <em><strong>non-instantiated</strong></em>. A non-instantiated namespace is a namespace containing only interface types, type aliases, and other non-instantiated namespace. An instantiated namespace is a namespace that doesn't meet this definition. In intuitive terms, an instantiated namespace is one for which a namespace instance is created, whereas a non-instantiated namespace is one for which no code is generated.</p>
  </section><p><section id="user-content-10.1"><em>NamespaceName</em> (section </section><a href="sec-types#type-references-382">3.8.2</a>) it denotes a container of namespace and type names, and when a namespace identifier is referenced as a <em>PrimaryExpression</em> (section <a href="sec-expressions#identifiers-43">4.3</a>) it denotes the singleton namespace instance. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">namespace</span> <span class="pl-smi">M</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">interface</span> <span class="pl-smi">P</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
      <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-s1">a</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">p</span>: <span class="pl-smi">M</span><span class="pl-kos">.</span><span class="pl-smi">P</span><span class="pl-kos">;</span>             <span class="pl-c">// M used as NamespaceName  </span>
  <span class="pl-k">var</span> <span class="pl-s1">m</span> <span class="pl-c1">=</span> <span class="pl-smi">M</span><span class="pl-kos">;</span>              <span class="pl-c">// M used as PrimaryExpression  </span>
  <span class="pl-k">var</span> <span class="pl-s1">x1</span> <span class="pl-c1">=</span> <span class="pl-smi">M</span><span class="pl-kos">.</span><span class="pl-c1">a</span><span class="pl-kos">;</span>           <span class="pl-c">// M used as PrimaryExpression  </span>
  <span class="pl-k">var</span> <span class="pl-s1">x2</span> <span class="pl-c1">=</span> <span class="pl-s1">m</span><span class="pl-kos">.</span><span class="pl-c1">a</span><span class="pl-kos">;</span>           <span class="pl-c">// Same as M.a  </span>
  <span class="pl-k">var</span> <span class="pl-s1">q</span>: <span class="pl-s1">m</span><span class="pl-kos">.</span><span class="pl-smi">P</span><span class="pl-kos">;</span>             <span class="pl-c">// Error</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Above, when 'M' is used as a <em>PrimaryExpression</em> it denotes an object instance with a single member 'a' and when 'M' is used as a <em>NamespaceName</em> it denotes a container with a single type member 'P'. The final line in the example is an error because 'm' is a variable which cannot be referenced in a type name.</p>
  <p>If the declaration of 'M' above had excluded the exported variable 'a', 'M' would be a non-instantiated namespace and it would be an error to reference 'M' as a <em>PrimaryExpression</em>.</p>
  <p>A namespace declaration that specifies an <em>IdentifierPath</em> with more than one identifier is equivalent to a series of nested single-identifier namespace declarations where all but the outermost are automatically exported. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">namespace</span> <span class="pl-smi">A</span><span class="pl-kos">.</span><span class="pl-smi">B</span><span class="pl-kos">.</span><span class="pl-smi">C</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>corresponds to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">namespace</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">namespace</span> <span class="pl-smi">B</span> <span class="pl-kos">{</span>  
          <span class="pl-k">export</span> <span class="pl-k">namespace</span> <span class="pl-smi">C</span> <span class="pl-kos">{</span>  
              <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
          <span class="pl-kos">}</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The hierarchy formed by namespace and named type names partially mirrors that formed by namespace instances and members. The example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">namespace</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">namespace</span> <span class="pl-smi">B</span> <span class="pl-kos">{</span>  
          <span class="pl-k">export</span> <span class="pl-k">class</span> <span class="pl-smi">C</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>introduces a named type with the qualified name 'A.B.C' and also introduces a constructor function that can be accessed using the expression 'A.B.C'. Thus, in the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">c</span>: <span class="pl-smi">A</span><span class="pl-kos">.</span><span class="pl-smi">B</span><span class="pl-kos">.</span><span class="pl-smi">C</span> <span class="pl-c1">=</span> <span class="pl-k">new</span> <span class="pl-smi">A</span><span class="pl-kos">.</span><span class="pl-c1">B</span><span class="pl-kos">.</span><span class="pl-c1">C</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the two occurrences of 'A.B.C' in fact refer to different entities. It is the context of the occurrences that determines whether 'A.B.C' is processed as a type name or an expression.</p>
  <h2 id="namespace-body-102" title="10.2"> Namespace Body</h2><section id="user-content-10.2"><p>The body of a namespace corresponds to a function that is executed once to initialize the namespace instance.</p>
  <p>  <em>NamespaceBody:</em><br />
     <em>NamespaceElements<sub>opt</sub></em></p>
  <p>  <em>NamespaceElements:</em><br />
     <em>NamespaceElement</em><br />
     <em>NamespaceElements</em> <em>NamespaceElement</em></p>
  <p>  <em>NamespaceElement:</em><br />
     <em>Statement</em><br />
     <em>LexicalDeclaration</em><br />
     <em>FunctionDeclaration</em><br />
     <em>GeneratorDeclaration</em><br />
     <em>ClassDeclaration</em><br />
     <em>InterfaceDeclaration</em><br />
     <em>TypeAliasDeclaration</em><br />
     <em>EnumDeclaration</em><br />
     <em>NamespaceDeclaration<br />
     AmbientDeclaration<br />
     ImportAliasDeclaration<br />
     ExportNamespaceElement</em></p>
  <p>  <em>ExportNamespaceElement:</em><br />
     <code>export</code> <em>VariableStatement</em><br />
     <code>export</code> <em>LexicalDeclaration</em><br />
     <code>export</code> <em>FunctionDeclaration</em><br />
     <code>export</code> <em>GeneratorDeclaration</em><br />
     <code>export</code> <em>ClassDeclaration</em><br />
     <code>export</code> <em>InterfaceDeclaration</em><br />
     <code>export</code> <em>TypeAliasDeclaration</em><br />
     <code>export</code> <em>EnumDeclaration</em><br />
     <code>export</code> <em>NamespaceDeclaration</em><br />
     <code>export</code> <em>AmbientDeclaration</em><br />
     <code>export</code> <em>ImportAliasDeclaration</em></p>
  </section><h2 id="import-alias-declarations-103" title="10.3"> Import Alias Declarations</h2><section id="user-content-10.3"><p>Import alias declarations are used to create local aliases for entities in other namespaces.</p>
  <p>  <em>ImportAliasDeclaration:</em><br />
     <code>import</code> <em>BindingIdentifier</em> <code>=</code> <em>EntityName</em> <code>;</code></p>
  <p>  <em>EntityName:</em><br />
     <em>NamespaceName</em><br />
     <em>NamespaceName</em> <code>.</code> <em>IdentifierReference</em></p>
  <p>An <em>EntityName</em> consisting of a single identifier is resolved as a <em>NamespaceName</em> and is thus required to reference a namespace. The resulting local alias references the given namespace and is itself classified as a namespace.</p>
  <p>An <em>EntityName</em> consisting of more than one identifier is resolved as a <em>NamespaceName</em> followed by an identifier that names an exported entity in the given namespace. The resulting local alias has all the meanings of the referenced entity. (As many as three distinct meanings are possible for an entity name—value, type, and namespace.) In effect, it is as if the imported entity was declared locally with the local alias name.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">namespace</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">interface</span> <span class="pl-smi">X</span> <span class="pl-kos">{</span> <span class="pl-c1">s</span>: <span class="pl-smi">string</span> <span class="pl-kos">}</span>  
      <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-smi">X</span>: <span class="pl-smi">X</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">namespace</span> <span class="pl-smi">B</span> <span class="pl-kos">{</span>  
      <span class="pl-k">interface</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span> <span class="pl-c1">n</span>: <span class="pl-smi">number</span> <span class="pl-kos">}</span>  
      <span class="pl-k">import</span> <span class="pl-smi">Y</span> <span class="pl-c1">=</span> <span class="pl-smi">A</span><span class="pl-kos">;</span>    <span class="pl-c">// Alias for namespace A  </span>
      <span class="pl-k">import</span> <span class="pl-smi">Z</span> <span class="pl-c1">=</span> <span class="pl-smi">A</span><span class="pl-kos">.</span><span class="pl-smi">X</span><span class="pl-kos">;</span>  <span class="pl-c">// Alias for type and value A.X  </span>
      <span class="pl-k">var</span> <span class="pl-s1">v</span>: <span class="pl-smi">Z</span> <span class="pl-c1">=</span> <span class="pl-smi">Z</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>within 'B', 'Y' is an alias only for namespace 'A' and not the local interface 'A', whereas 'Z' is an alias for all exported meanings of 'A.X', thus denoting both an interface type and a variable.</p>
  <p>If the <em>NamespaceName</em> portion of an <em>EntityName</em> references an instantiated namespace, the <em>NamespaceName</em> is required to reference the namespace instance when evaluated as an expression. In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">namespace</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">interface</span> <span class="pl-smi">X</span> <span class="pl-kos">{</span> <span class="pl-c1">s</span>: <span class="pl-smi">string</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">namespace</span> <span class="pl-smi">B</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-smi">A</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
      <span class="pl-k">import</span> <span class="pl-smi">Y</span> <span class="pl-c1">=</span> <span class="pl-smi">A</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>'Y' is a local alias for the non-instantiated namespace 'A'. If the declaration of 'A' is changed such that 'A' becomes an instantiated namespace, for example by including a variable declaration in 'A', the import statement in 'B' above would be an error because the expression 'A' doesn't reference the namespace instance of namespace 'A'.</p>
  <p>When an import statement includes an export modifier, all meanings of the local alias are exported.</p>
  </section><h2 id="export-declarations-104" title="10.4"> Export Declarations</h2><section id="user-content-10.4"><p>An export declaration declares an externally accessible namespace member. An export declaration is simply a regular declaration prefixed with the keyword <code>export</code>.</p>
  </section><p>The members of a namespace's export declaration space (section <a href="sec-basic-concepts#declarations-23">2.3</a>) constitute the namespace's <em><strong>export member set</strong></em>. A namespace's <em><strong>instance type</strong></em> is an object type with a property for each member in the namespace's export member set that denotes a value.</p>
  <p>An exported member depends on a (possibly empty) set of named types (section <a href="sec-types#named-types-37">3.7</a>). Those named types must be at least as accessible as the exported member, or otherwise an error occurs.</p>
  <p>The named types upon which a member depends are the named types occurring in the transitive closure of the <em><strong>directly depends on</strong></em> relationship defined as follows:</p>
  <ul>
  <li>A variable directly depends on the <em>Type</em> specified in its type annotation.</li>
  <li>A function directly depends on each <em>Type</em> specified in a parameter or return type annotation.</li>
  <li>A class directly depends on each <em>Type</em> specified as a type parameter constraint, each <em>TypeReference</em> specified as a base class or implemented interface, and each <em>Type</em> specified in a constructor parameter type annotation, public member variable type annotation, public member function parameter or return type annotation, public member accessor parameter or return type annotation, or index signature type annotation.</li>
  <li>An interface directly depends on each <em>Type</em> specified as a type parameter constraint, each <em>TypeReference</em> specified as a base interface, and the <em>ObjectType</em> specified as its body.</li>
  <li>A namespace directly depends on its exported members.</li>
  <li>A <em>Type</em> or <em>ObjectType</em> directly depends on every <em>TypeReference</em> that occurs within the type at any level of nesting.</li>
  <li>A <em>TypeReference</em> directly depends on the type it references and on each <em>Type</em> specified as a type argument.</li>
  </ul>
  <p>A named type <em>T</em> having a root namespace <em>R</em> (section <a href="sec-basic-concepts#declarations-23">2.3</a>) is said to be <em><strong>at least as accessible as</strong></em> a member <em>M</em> if</p>
  <ul>
  <li><em>R</em> is the global namespace or a module, or</li>
  <li><em>R</em> is a namespace in the parent namespace chain of <em>M</em>.</li>
  </ul>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">namespace</span> <span class="pl-smi">M</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">interface</span> <span class="pl-smi">B</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-smi">A</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
      <span class="pl-k">export</span> <span class="pl-k">interface</span> <span class="pl-smi">C</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-smi">B</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
      <span class="pl-k">export</span> <span class="pl-k">function</span> <span class="pl-en">foo</span><span class="pl-kos">(</span><span class="pl-s1">c</span>: <span class="pl-smi">C</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-s1">…</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the 'foo' function depends upon the named types 'A', 'B', and 'C'. In order to export 'foo' it is necessary to also export 'B' and 'C' as they otherwise would not be at least as accessible as 'foo'. The 'A' interface is already at least as accessible as 'foo' because I t is declared in a parent namespace of foo's namespace.</p>
  <h2 id="declaration-merging-105" title="10.5"> Declaration Merging</h2>
  <p>Namespaces are "open-ended" and namespace declarations with the same qualified name relative to a common root (as defined in section <a href="sec-basic-concepts#declarations-23">2.3</a>) contribute to a single namespace. For example, the following two declarations of a namespace 'outer' might be located in separate source files.</p>
  <p>File a.ts:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">namespace</span> <span class="pl-s1">outer</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">local</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>           <span class="pl-c">// Non-exported local variable  </span>
      <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-s1">a</span> <span class="pl-c1">=</span> <span class="pl-s1">local</span><span class="pl-kos">;</span>    <span class="pl-c">// outer.a  </span>
      <span class="pl-k">export</span> <span class="pl-k">namespace</span> <span class="pl-s1">inner</span> <span class="pl-kos">{</span>  
          <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">10</span><span class="pl-kos">;</span>   <span class="pl-c">// outer.inner.x  </span>
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>File b.ts:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">namespace</span> <span class="pl-s1">outer</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">local</span> <span class="pl-c1">=</span> <span class="pl-c1">2</span><span class="pl-kos">;</span>           <span class="pl-c">// Non-exported local variable  </span>
      <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-s1">b</span> <span class="pl-c1">=</span> <span class="pl-s1">local</span><span class="pl-kos">;</span>    <span class="pl-c">// outer.b  </span>
      <span class="pl-k">export</span> <span class="pl-k">namespace</span> <span class="pl-s1">inner</span> <span class="pl-kos">{</span>  
          <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-c1">20</span><span class="pl-kos">;</span>   <span class="pl-c">// outer.inner.y  </span>
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Assuming the two source files are part of the same program, the two declarations will have the global namespace as their common root and will therefore contribute to the same namespace instance, the instance type of which will be:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">{</span>  
      a: <span class="pl-s1">number</span><span class="pl-kos">;</span>  
      b: <span class="pl-s1">number</span><span class="pl-kos">;</span>  
      inner: <span class="pl-kos">{</span>  
          x: <span class="pl-s1">number</span><span class="pl-kos">;</span>  
          y: <span class="pl-s1">number</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Declaration merging does not apply to local aliases created by import alias declarations. In other words, it is not possible have an import alias declaration and a namespace declaration for the same name within the same namespace body.</p>
  <p><em>TODO: Clarify rules for <a href="https://github.com/Microsoft/TypeScript/issues/3158">alias resolution</a></em>.</p>
  <p>Declaration merging also extends to namespace declarations with the same qualified name relative to a common root as a function, class, or enum declaration:</p>
  <ul>
  <li>When merging a function and a namespace, the type of the function object is merged with the instance type of the namespace. In effect, the overloads or implementation of the function provide the call signatures and the exported members of the namespace provide the properties of the combined type.</li>
  <li>When merging a class and a namespace, the type of the constructor function object is merged with the instance type of the namespace. In effect, the overloads or implementation of the class constructor provide the construct signatures, and the static members of the class and exported members of the namespace provide the properties of the combined type. It is an error to have static class members and exported namespace members with the same name.</li>
  <li>When merging an enum and a namespace, the type of the enum object is merged with the instance type of the namespace. In effect, the members of the enum and the exported members of the namespace provide the properties of the combined type. It is an error to have enum members and exported namespace members with the same name.</li>
  </ul>
  <p>When merging a non-ambient function or class declaration and a non-ambient namespace declaration, the function or class declaration must be located prior to the namespace declaration in the same source file. This ensures that the shared object instance is created as a function object. (While it is possible to add properties to an object after its creation, it is not possible to make an object "callable" after the fact.)</p>
  <p>The example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-en">point</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-s1">x</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-s1">y</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">namespace</span> <span class="pl-s1">point</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-s1">origin</span> <span class="pl-c1">=</span> <span class="pl-en">point</span><span class="pl-kos">(</span><span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">0</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-k">export</span> <span class="pl-k">function</span> <span class="pl-en">equals</span><span class="pl-kos">(</span><span class="pl-s1">p1</span>: <span class="pl-smi">Point</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span>: <span class="pl-smi">Point</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-s1">p1</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">==</span> <span class="pl-s1">p2</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">&amp;&amp;</span> <span class="pl-s1">p1</span><span class="pl-kos">.</span><span class="pl-c1">y</span> <span class="pl-c1">==</span> <span class="pl-s1">p2</span><span class="pl-kos">.</span><span class="pl-c1">y</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">p1</span> <span class="pl-c1">=</span> <span class="pl-en">point</span><span class="pl-kos">(</span><span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">0</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">p2</span> <span class="pl-c1">=</span> <span class="pl-s1">point</span><span class="pl-kos">.</span><span class="pl-c1">origin</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">b</span> <span class="pl-c1">=</span> <span class="pl-s1">point</span><span class="pl-kos">.</span><span class="pl-en">equals</span><span class="pl-kos">(</span><span class="pl-s1">p1</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>declares 'point' as a function object with two properties, 'origin' and 'equals'. Note that the namespace declaration for 'point' is located after the function declaration.</p>
  <h2 id="code-generation-106" title="10.6"> Code Generation</h2><section id="user-content-10.6"><p>A namespace generates JavaScript code that is equivalent to the following:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-c1">&lt;</span><span class="pl-smi">NamespaceName</span><span class="pl-c1">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-kos">(</span><span class="pl-k">function</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">NamespaceName</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">&lt;</span><span class="pl-smi">NamespaceStatements</span><span class="pl-c1">&gt;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">NamespaceName</span><span class="pl-c1">&gt;</span><span class="pl-c1">||</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">NamespaceName</span><span class="pl-c1">&gt;</span><span class="pl-c1">=</span><span class="pl-kos">{</span><span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>NamespaceName</em> is the name of the namespace and <em>NamespaceStatements</em> is the code generated for the statements in the namespace body. The <em>NamespaceName</em> function parameter may be prefixed with one or more underscore characters to ensure the name is unique within the function body. Note that the entire namespace is emitted as an anonymous function that is immediately executed. This ensures that local variables are in their own lexical environment isolated from the surrounding context. Also note that the generated function doesn't create and return a namespace instance, but rather it extends the existing instance (which may have just been created in the function call). This ensures that namespaces can extend each other.</p>
  <p>An import statement generates code of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-c1">&lt;</span><span class="pl-smi">Alias</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-c1">&lt;</span><span class="pl-smi">EntityName</span><span class="pl-c1">&gt;</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This code is emitted only if the imported entity is referenced as a <em>PrimaryExpression</em> somewhere in the body of the importing namespace. If an imported entity is referenced only as a <em>TypeName</em> or <em>NamespaceName</em>, nothing is emitted. This ensures that types declared in one namespace can be referenced through an import alias in another namespace with no run-time overhead.</p>
  <p>When a variable is exported, all references to the variable in the body of the namespace are replaced with</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span><span class="pl-smi">NamespaceName</span><span class="pl-c1">&gt;</span><span class="pl-kos">.</span><span class="pl-c1">&lt;</span><span class="pl-smi">VariableName</span><span class="pl-c1">&gt;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This effectively promotes the variable to be a property on the namespace instance and ensures that all references to the variable become references to the property.</p>
  <p>When a function, class, enum, or namespace is exported, the code generated for the entity is followed by an assignment statement of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span><span class="pl-smi">NamespaceName</span><span class="pl-c1">&gt;</span><span class="pl-kos">.</span><span class="pl-c1">&lt;</span><span class="pl-smi">EntityName</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-c1">&lt;</span><span class="pl-smi">EntityName</span><span class="pl-c1">&gt;</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This copies a reference to the entity into a property on the namespace instance.</p>
  <br />
  </section></section>