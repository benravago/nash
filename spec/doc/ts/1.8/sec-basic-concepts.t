<section id="sec-basic-concepts"><h1 id="basic-concepts-2" title="2"> Basic Concepts</h1>
  <p>The remainder of this document is the formal specification of the TypeScript programming language and is intended to be read as an adjunct to the <a href="http://www.ecma-international.org/ecma-262/6.0/" rel="nofollow">ECMAScript 2015 Language Specification</a> (specifically, the ECMA-262 Standard, 6th Edition). This document describes the syntactic grammar added by TypeScript along with the compile-time processing and type checking performed by the TypeScript compiler, but it only minimally discusses the run-time behavior of programs since that is covered by the ECMAScript specification.</p>
  <h2 id="grammar-conventions-21" title="2.1"> Grammar Conventions</h2><section id="user-content-2.1"><p>The syntactic grammar added by TypeScript language is specified throughout this document using the existing conventions and production names of the ECMAScript grammar. In places where TypeScript augments an existing grammar production it is so noted. For example:</p>
  <p>  <em>Declaration:</em>  <em>( Modified )</em><br />
     …<br />
     <em>InterfaceDeclaration</em><br />
     <em>TypeAliasDeclaration</em><br />
     <em>EnumDeclaration</em></p>
  <p>The '<em>( Modified )</em>' annotation indicates that an existing grammar production is being replaced, and the '…' references the contents of the original grammar production.</p>
  <p>Similar to the ECMAScript grammar, if the phrase "<em>[no LineTerminator here]</em>" appears in the right-hand side of a production of the syntactic grammar, it indicates that the production is not a match if a <em>LineTerminator</em> occurs in the input stream at the indicated position.</p>
  </section><h2 id="names-22" title="2.2"> Names</h2><section id="user-content-2.2"><p>A core purpose of the TypeScript compiler is to track the named entities in a program and validate that they are used according to their designated meaning. Names in TypeScript can be written in several ways, depending on context. Specifically, a name can be written as</p>
  </section><ul><section id="user-content-2.2"><li>an <em>IdentifierName</em>,</li>
  <li>a <em>StringLiteral</em> in a property name,</li>
  <li>a <em>NumericLiteral</em> in a property name, or</li>
  </section><li><section id="user-content-2.2"><em>ComputedPropertyName</em> that denotes a well-known symbol (</section><a href="#computed-property-names-223">2.2.3</a>).</li>
  </ul>
  <p>Most commonly, names are written to conform with the <em>Identifier</em> production, which is any <em>IdentifierName</em> that isn't a reserved word.</p>
  <h3 id="reserved-words-221" title="2.2.1"> Reserved Words</h3><section id="user-content-2.2.1"><p>The following keywords are reserved and cannot be used as an <em>Identifier</em>:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">break</span>             <span class="pl-s1">case</span>              <span class="pl-k">catch</span>             <span class="pl-k">class</span>  
  <span class="pl-k">const</span>             <span class="pl-s1">continue</span>          <span class="pl-k">debugger</span><span class="pl-kos" />          <span class="pl-s1">default</span>  
  <span class="pl-k">delete</span>            <span class="pl-s1">do</span>                <span class="pl-k">else</span>              <span class="pl-k">enum</span>  
  <span class="pl-s1">export</span>            <span class="pl-k">extends</span>           <span class="pl-c1">false</span><span class="pl-kos" />             <span class="pl-s1">finally</span>  
  <span class="pl-k">for</span>               <span class="pl-k">function</span>          <span class="pl-s1">if</span>                <span class="pl-k">import</span>  
  <span class="pl-k">in</span>                <span class="pl-s1">instanceof</span><span class="pl-kos" />        <span class="pl-k">new</span>               <span class="pl-c1">null</span>  
  <span class="pl-k">return</span>            <span class="pl-smi">super</span>             <span class="pl-k">switch</span>            <span class="pl-smi">this</span>  
  <span class="pl-k">throw</span>             <span class="pl-c1">true</span>              <span class="pl-k">try</span>               <span class="pl-k">typeof</span>  
  <span class="pl-s1">var</span>               <span class="pl-k">void</span>              <span class="pl-s1">while</span>             <span class="pl-k">with</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The following keywords cannot be used as identifiers in strict mode code, but are otherwise not restricted:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">implements</span>        <span class="pl-k">interface</span>         <span class="pl-k">let</span>               <span class="pl-s1">package</span>  
  <span class="pl-k">private</span>           <span class="pl-k">protected</span>         <span class="pl-k">public</span>            <span class="pl-s1">static</span>  
  <span class="pl-k">yield</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The following keywords cannot be used as user defined type names, but are otherwise not restricted:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre>any               boolean           number            <span class="pl-s1">string</span>  
  <span class="pl-s1">symbol</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The following keywords have special meaning in certain contexts, but are valid identifiers:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">abstract</span>          <span class="pl-k">as</span>                <span class="pl-s1">async</span>             <span class="pl-s1">await</span>  
  <span class="pl-s1">constructor</span>       <span class="pl-k">declare</span>           <span class="pl-k">from</span>              <span class="pl-s1">get</span>  
  <span class="pl-s1">is</span><span class="pl-kos" />                module            <span class="pl-s1">namespace</span>         <span class="pl-s1">of</span>  
  <span class="pl-en">require</span>           <span class="pl-k">set</span>               <span class="pl-s1">type</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><h3 id="property-names-222" title="2.2.2"> Property Names</h3><section id="user-content-2.2.2"><p>The <em>PropertyName</em> production from the ECMAScript grammar is reproduced below:</p>
  <p>  <em>PropertyName:</em><br />
     <em>LiteralPropertyName</em><br />
     <em>ComputedPropertyName</em></p>
  <p>  <em>LiteralPropertyName:</em><br />
     <em>IdentifierName</em><br />
     <em>StringLiteral</em><br />
     <em>NumericLiteral</em></p>
  <p>  <em>ComputedPropertyName:</em><br />
     <code>[</code> <em>AssignmentExpression</em> <code>]</code></p>
  <p>A property name can be any identifier (including a reserved word), a string literal, a numeric literal, or a computed property name. String literals may be used to give properties names that are not valid identifiers, such as names containing blanks. Numeric literal property names are equivalent to string literal property names with the string representation of the numeric literal, as defined in the ECMAScript specification.</p>
  </section><h3 id="computed-property-names-223" title="2.2.3"> Computed Property Names</h3><section id="user-content-2.2.3"><p>ECMAScript 2015 permits object literals and classes to declare members with computed property names. A computed property name specifies an expression that computes the actual property name at run-time. Because the final property name isn't known at compile-time, TypeScript can only perform limited checks for entities declared with computed property names. However, a subset of computed property names known as <em><strong>well-known symbols</strong></em> can be used anywhere a <em>PropertyName</em> is expected, including property names within types. A computed property name is a well-known symbol if it is of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">[</span> <span class="pl-smi">Symbol</span> <span class="pl-kos">.</span> <span class="pl-c1">xxx</span> <span class="pl-kos">]</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In a well-known symbol, the identifier to the right of the dot must denote a property of the primitive type <code>symbol</code> in the type of the global variable 'Symbol', or otherwise an error occurs.</p>
  </section><p><section id="user-content-2.2.3"><em>PropertyName</em> that specifies a <em>ComputedPropertyName</em>, the computed property name is required to denote a well-known symbol unless the property name occurs in a property assignment of an object literal (</section><a href="sec-expressions#object-literals-45">4.5</a>) or a property member declaration in a non-ambient class (<a href="sec-classes#property-member-declarations-84">8.4</a>).</p>
  <p>Below is an example of an interface that declares a property with a well-known symbol name:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Iterable</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span>  
      <span class="pl-kos">[</span><span class="pl-smi">Symbol</span><span class="pl-kos">.</span><span class="pl-c1">iterator</span><span class="pl-kos">]</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">Iterator</span><span class="pl-kos">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p><em>TODO: Update to reflect treatment of <a href="https://github.com/Microsoft/TypeScript/pull/5535">computed property names with literal expressions</a></em>.</p>
  <h2 id="declarations-23" title="2.3"> Declarations</h2><section id="user-content-2.3"><p>Declarations introduce names in their associated <em><strong>declaration spaces</strong></em>. A name must be unique in its declaration space and can denote a <em><strong>value</strong></em>, a <em><strong>type</strong></em>, or a <em><strong>namespace</strong></em>, or some combination thereof. Effectively, a single name can have as many as three distinct meanings. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-smi">X</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>    <span class="pl-c">// Value named X</span>
  
  <span class="pl-k">type</span> <span class="pl-smi">X</span> <span class="pl-c1">=</span> <span class="pl-smi">number</span><span class="pl-kos">;</span>  <span class="pl-c">// Type named X</span>
  
  <span class="pl-k">namespace</span> <span class="pl-smi">X</span> <span class="pl-kos">{</span>     <span class="pl-c">// Namespace named X  </span>
      <span class="pl-k">type</span> <span class="pl-smi">Y</span> <span class="pl-c1">=</span> <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p>A name that denotes a value has an associated type (section <a href="sec-types#types-3">3</a>) and can be referenced in expressions (section <a href="sec-expressions#identifiers-43">4.3</a>). A name that denotes a type can be used by itself in a type reference or on the right hand side of a dot in a type reference (<a href="sec-types#type-references-382">3.8.2</a>). A name that denotes a namespace can be used on the left hand side of a dot in a type reference.</p>
  <p>When a name with multiple meanings is referenced, the context in which the reference occurs determines the meaning. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">n</span>: <span class="pl-smi">X</span><span class="pl-kos">;</span>        <span class="pl-c">// X references type  </span>
  <span class="pl-k">var</span> <span class="pl-s1">s</span>: <span class="pl-smi">X</span><span class="pl-kos">.</span><span class="pl-smi">Y</span> <span class="pl-c1">=</span> <span class="pl-smi">X</span><span class="pl-kos">;</span>  <span class="pl-c">// First X references namespace, second X references value</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In the first line, X references the type X because it occurs in a type position. In the second line, the first X references the namespace X because it occurs before a dot in a type name, and the second X references the variable X because it occurs in an expression.</p>
  <p>Declarations introduce the following meanings for the name they declare:</p>
  <ul>
  <li>A variable, parameter, function, generator, member variable, member function, member accessor, or enum member declaration introduces a value meaning.</li>
  <li>An interface, type alias, or type parameter declaration introduces a type meaning.</li>
  <li>A class declaration introduces a value meaning (the constructor function) and a type meaning (the class type).</li>
  <li>An enum declaration introduces a value meaning (the enum instance) and a type meaning (the enum type).</li>
  <li>A namespace declaration introduces a namespace meaning (the type and namespace container) and, if the namespace is instantiated (section <a href="sec-namespaces#namespace-declarations-101">10.1</a>), a value meaning (the namespace instance).</li>
  <li>An import or export declaration introduces the meaning(s) of the imported or exported entity.</li>
  </ul>
  <p>Below are some examples of declarations that introduce multiple meanings for a name:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">C</span> <span class="pl-kos">{</span>      <span class="pl-c">// Value and type named C  </span>
      <span class="pl-c1">x</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">namespace</span> <span class="pl-smi">N</span> <span class="pl-kos">{</span>  <span class="pl-c">// Value and namespace named N  </span>
      <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-s1">x</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Declaration spaces exist as follows:</p>
  <ul>
  <li>The global namespace, each module, and each declared namespace has a declaration space for its contained entities (whether local or exported).</li>
  <li>Each module has a declaration space for its exported entities. All export declarations in the module contribute to this declaration space.</li>
  <li>Each declared namespace has a declaration space for its exported entities. All export declarations in the namespace contribute to this declaration space. A declared namespace’s declaration space is shared with other declared namespaces that have the same root container and the same qualified name starting from that root container.</li>
  <li>Each class declaration has a declaration space for instance members and type parameters, and a declaration space for static members.</li>
  <li>Each interface declaration has a declaration space for members and type parameters. An interface's declaration space is shared with other interfaces that have the same root container and the same qualified name starting from that root container.</li>
  <li>Each enum declaration has a declaration space for its enum members. An enum's declaration space is shared with other enums that have the same root container and the same qualified name starting from that root container.</li>
  <li>Each type alias declaration has a declaration space for its type parameters.</li>
  <li>Each function-like declaration (including function declarations, constructor declarations, member function declarations, member accessor declarations, function expressions, and arrow functions) has a declaration space for locals and type parameters. This declaration space includes parameter declarations, all local var and function declarations, and local let, const, class, interface, type alias, and enum declarations that occur immediately within the function body and are not further nested in blocks.</li>
  <li>Each statement block has a declaration space for local let, const, class, interface, type alias, and enum declarations that occur immediately within that block.</li>
  <li>Each object literal has a declaration space for its properties.</li>
  <li>Each object type literal has a declaration space for its members.</li>
  </ul>
  <p>Top-level declarations in a source file with no top-level import or export declarations belong to the <em><strong>global namespace</strong></em>. Top-level declarations in a source file with one or more top-level import or export declarations belong to the <em><strong>module</strong></em> represented by that source file.</p>
  <p>The <em><strong>container</strong></em> of an entity is defined as follows:</p>
  <ul>
  <li>The container of an entity declared in a namespace declaration is that namespace declaration.</li>
  <li>The container of an entity declared in a module is that module.</li>
  <li>The container of an entity declared in the global namespace is the global namespace.</li>
  <li>The container of a module is the global namespace.</li>
  </ul>
  <p>The <em><strong>root container</strong></em> of an entity is defined as follows:</p>
  <ul>
  <li>The root container of a non-exported entity is the entity’s container.</li>
  <li>The root container of an exported entity is the root container of the entity's container.</li>
  </ul>
  <p>Intuitively, the root container of an entity is the outermost module or namespace body from within which the entity is reachable.</p>
  <p>Interfaces, enums, and namespaces are "open ended," meaning that interface, enum, and namespace declarations with the same qualified name relative to a common root are automatically merged. For further details, see sections <a href="sec-interfaces#declaration-merging-72">7.2</a>, <a href="sec-enums#declaration-merging-93">9.3</a>, and <a href="sec-namespaces#declaration-merging-105">10.5</a>.</p>
  <p>Instance and static members in a class are in separate declaration spaces. Thus the following is permitted:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">C</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>          <span class="pl-c">// Instance member  </span>
      <span class="pl-k">static</span> <span class="pl-c1">x</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>   <span class="pl-c">// Static member  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h2 id="scopes-24" title="2.4"> Scopes</h2><section id="user-content-2.4"><p>The <em><strong>scope</strong></em> of a name is the region of program text within which it is possible to refer to the entity declared by that name without qualification of the name. The scope of a name depends on the context in which the name is declared. The contexts are listed below in order from outermost to innermost:</p>
  <ul>
  <li>The scope of a name declared in the global namespace is the entire program text.</li>
  <li>The scope of a name declared in a module is the source file of that module.</li>
  <li>The scope of an exported name declared within a namespace declaration is the body of that namespace declaration and every namespace declaration with the same root and the same qualified name relative to that root.</li>
  <li>The scope of a non-exported name declared within a namespace declaration is the body of that namespace declaration.</li>
  <li>The scope of a type parameter name declared in a class or interface declaration is that entire declaration, including constraints, extends clause, implements clause, and declaration body, but not including static member declarations.</li>
  <li>The scope of a type parameter name declared in a type alias declaration is that entire type alias declaration.</li>
  <li>The scope of a member name declared in an enum declaration is the body of that declaration and every enum declaration with the same root and the same qualified name relative to that root.</li>
  <li>The scope of a type parameter name declared in a call or construct signature is that entire signature declaration, including constraints, parameter list, and return type. If the signature is part of a function implementation, the scope includes the function body.</li>
  <li>The scope of a parameter name declared in a call or construct signature is the remainder of the signature declaration. If the signature is part of a function-like declaration with a body (including a function declaration, constructor declaration, member function declaration, member accessor declaration, function expression, or arrow function), the scope includes the body of that function-like declaration.</li>
  <li>The scope of a local var or function name declared anywhere in the body of a function-like declaration is the body of that function-like declaration.</li>
  <li>The scope of a local let, const, class, interface, type alias, or enum declaration declared immediately within the body of a function-like declaration is the body of that function-like declaration.</li>
  <li>The scope of a local let, const, class, interface, type alias, or enum declaration declared immediately within a statement block is the body of that statement block.</li>
  </ul>
  <p>Scopes may overlap, for example through nesting of namespaces and functions. When the scopes of two names overlap, the name with the innermost declaration takes precedence and access to the outer name is either not possible or only possible by qualification.</p>
  </section><p><section id="user-content-2.4"><em>PrimaryExpression</em> (section </section><a href="sec-expressions#identifiers-43">4.3</a>), only names in scope with a value meaning are considered and other names are ignored.</p>
  <p>When an identifier is resolved as a <em>TypeName</em> (section <a href="sec-types#type-references-382">3.8.2</a>), only names in scope with a type meaning are considered and other names are ignored.</p>
  <p>When an identifier is resolved as a <em>NamespaceName</em> (section <a href="sec-types#type-references-382">3.8.2</a>), only names in scope with a namespace meaning are considered and other names are ignored.</p>
  <p><em>TODO: <a href="https://github.com/Microsoft/TypeScript/issues/3158">Include specific rules for alias resolution</a></em>.</p>
  <p>Note that class and interface members are never directly in scope—they can only be accessed by applying the dot ('.') operator to a class or interface instance. This even includes members of the current instance in a constructor or member function, which are accessed by applying the dot operator to <code>this</code>.</p>
  <p>As the rules above imply, locally declared entities in a namespace are closer in scope than exported entities declared in other namespace declarations for the same namespace. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
  <span class="pl-k">namespace</span> <span class="pl-smi">M</span> <span class="pl-kos">{</span>  
      <span class="pl-k">export</span> <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">2</span><span class="pl-kos">;</span>  
      <span class="pl-smi">console</span><span class="pl-kos">.</span><span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span><span class="pl-kos">;</span>     <span class="pl-c">// 2  </span>
  <span class="pl-kos">}</span>  
  <span class="pl-k">namespace</span> <span class="pl-smi">M</span> <span class="pl-kos">{</span>  
      <span class="pl-smi">console</span><span class="pl-kos">.</span><span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span><span class="pl-kos">;</span>     <span class="pl-c">// 2  </span>
  <span class="pl-kos">}</span>  
  <span class="pl-k">namespace</span> <span class="pl-smi">M</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">3</span><span class="pl-kos">;</span>  
      <span class="pl-smi">console</span><span class="pl-kos">.</span><span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">)</span><span class="pl-kos">;</span>     <span class="pl-c">// 3  </span>
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <br />
  </section>