<section id="sec-interfaces"><h1 id="interfaces-7" title="7"> Interfaces</h1><section id="user-content-7"><p>Interfaces provide the ability to name and parameterize object types and to compose existing named object types into new ones.</p>
  <p>Interfaces have no run-time representation—they are purely a compile-time construct. Interfaces are particularly useful for documenting and validating the required shape of properties, objects passed as parameters, and objects returned from functions.</p>
  </section><p>Because TypeScript has a structural type system, an interface type with a particular set of members is considered identical to, and can be substituted for, another interface type or object type literal with an identical set of members (see section <a href="sec-types#type-and-member-identity-3112">3.11.2</a>).</p>
  <p>Class declarations may reference interfaces in their implements clause to validate that they provide an implementation of the interfaces.</p>
  <h2 id="interface-declarations-71" title="7.1"> Interface Declarations</h2><section id="user-content-7.1"><p>An interface declaration declares an <em><strong>interface type</strong></em>.</p>
  <p>  <em>InterfaceDeclaration:</em><br />
     <code>interface</code> <em>BindingIdentifier</em> <em>TypeParameters<sub>opt</sub></em> <em>InterfaceExtendsClause<sub>opt</sub></em> <em>ObjectType</em></p>
  <p>  <em>InterfaceExtendsClause:</em><br />
     <code>extends</code> <em>ClassOrInterfaceTypeList</em></p>
  <p>  <em>ClassOrInterfaceTypeList:</em><br />
     <em>ClassOrInterfaceType</em><br />
     <em>ClassOrInterfaceTypeList</em> <code>,</code> <em>ClassOrInterfaceType</em></p>
  <p>  <em>ClassOrInterfaceType:</em><br />
     <em>TypeReference</em></p>
  </section><p><section id="user-content-7.1"><em>InterfaceDeclaration</em> introduces a named type (section </section><a href="sec-types#named-types-37">3.7</a>) in the containing declaration space. The <em>BindingIdentifier</em> of an interface declaration may not be one of the predefined type names (section <a href="sec-types#predefined-types-381">3.8.1</a>).</p>
  <p>An interface may optionally have type parameters (section <a href="sec-types#type-parameter-lists-361">3.6.1</a>) that serve as placeholders for actual types to be provided when the interface is referenced in type references. An interface with type parameters is called a <em><strong>generic interface</strong></em>. The type parameters of a generic interface declaration are in scope in the entire declaration and may be referenced in the <em>InterfaceExtendsClause</em> and <em>ObjectType</em> body.</p>
  <p>An interface can inherit from zero or more <em><strong>base types</strong></em> which are specified in the <em>InterfaceExtendsClause</em>. The base types must be type references to class or interface types.</p>
  <p>An interface has the members specified in the <em>ObjectType</em> of its declaration and furthermore inherits all base type members that aren't hidden by declarations in the interface:</p>
  <ul>
  <li>A property declaration hides a public base type property with the same name.</li>
  <li>A string index signature declaration hides a base type string index signature.</li>
  <li>A numeric index signature declaration hides a base type numeric index signature.</li>
  </ul>
  <p>The following constraints must be satisfied by an interface declaration or otherwise a compile-time error occurs:</p>
  <ul>
  <li>An interface declaration may not, directly or indirectly, specify a base type that originates in the same declaration. In other words an interface cannot, directly or indirectly, be a base type of itself, regardless of type arguments.</li>
  <li>An interface cannot declare a property with the same name as an inherited private or protected property.</li>
  <li>Inherited properties with the same name must be identical (section <a href="sec-types#type-and-member-identity-3112">3.11.2</a>).</li>
  <li>All properties of the interface must satisfy the constraints implied by the index signatures of the interface as specified in section <a href="sec-types#index-signatures-394">3.9.4</a>.</li>
  <li>The this-type (section <a href="sec-types#this-types-363">3.6.3</a>) of the declared interface must be assignable (section <a href="sec-types#assignment-compatibility-3114">3.11.4</a>) to each of the base type references.</li>
  </ul>
  <p>An interface is permitted to inherit identical members from multiple base types and will in that case only contain one occurrence of each particular member.</p>
  <p>Below is an example of two interfaces that contain properties with the same name but different types:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Mover</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">move</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
      <span class="pl-c1">getStatus</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-kos">{</span> <span class="pl-c1">speed</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">Shaker</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">shake</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
      <span class="pl-c1">getStatus</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-kos">{</span> <span class="pl-c1">frequency</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>An interface that extends 'Mover' and 'Shaker' must declare a new 'getStatus' property as it would otherwise inherit two 'getStatus' properties with different types. The new 'getStatus' property must be declared such that the resulting 'MoverShaker' is a subtype of both 'Mover' and 'Shaker':</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">MoverShaker</span> <span class="pl-k">extends</span> <span class="pl-smi">Mover</span><span class="pl-kos">,</span> <span class="pl-smi">Shaker</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">getStatus</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-kos">{</span> <span class="pl-c1">speed</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-c1">frequency</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Since function and constructor types are just object types containing call and construct signatures, interfaces can be used to declare named function and constructor types. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">StringComparer</span> <span class="pl-kos">{</span> <span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">string</span><span class="pl-kos">,</span> <span class="pl-s1">b</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>This declares type 'StringComparer' to be a function type taking two strings and returning a number.</p>
  <h2 id="declaration-merging-72" title="7.2"> Declaration Merging</h2>
  <p>Interfaces are "open-ended" and interface declarations with the same qualified name relative to a common root (as defined in section <a href="sec-basic-concepts#declarations-23">2.3</a>) contribute to a single interface.</p>
  <p>When a generic interface has multiple declarations, all declarations must have identical type parameter lists, i.e. identical type parameter names with identical constraints in identical order.</p>
  <p>In an interface with multiple declarations, the <code>extends</code> clauses are merged into a single set of base types and the bodies of the interface declarations are merged into a single object type. Declaration merging produces a declaration order that corresponds to <em>prepending</em> the members of each interface declaration, in the order the members are written, to the combined list of members in the order of the interface declarations. Thus, members declared in the last interface declaration will appear first in the declaration order of the merged type.</p>
  <p>For example, a sequence of declarations in this order:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Document</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-smi">any</span><span class="pl-kos">)</span>: <span class="pl-smi">Element</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">Document</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLElement</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">Document</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-s">"div"</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLDivElement</span><span class="pl-kos">;</span>   
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-s">"span"</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLSpanElement</span><span class="pl-kos">;</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-s">"canvas"</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLCanvasElement</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is equivalent to the following single declaration:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Document</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-s">"div"</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLDivElement</span><span class="pl-kos">;</span>   
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-s">"span"</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLSpanElement</span><span class="pl-kos">;</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-s">"canvas"</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLCanvasElement</span><span class="pl-kos">;</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span>: <span class="pl-smi">HTMLElement</span><span class="pl-kos">;</span>  
      <span class="pl-c1">createElement</span><span class="pl-kos">(</span><span class="pl-s1">tagName</span>: <span class="pl-smi">any</span><span class="pl-kos">)</span>: <span class="pl-smi">Element</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that the members of the last interface declaration appear first in the merged declaration. Also note that the relative order of members declared in the same interface body is preserved.</p>
  <p><em>TODO: Document <a href="https://github.com/Microsoft/TypeScript/pull/3333">class and interface declaration merging</a></em>.</p>
  <h2 id="interfaces-extending-classes-73" title="7.3"> Interfaces Extending Classes</h2><section id="user-content-7.3"><p>When an interface type extends a class type it inherits the members of the class but not their implementations. It is as if the interface had declared all of the members of the class without providing an implementation. Interfaces inherit even the private and protected members of a base class. When a class containing private or protected members is the base type of an interface type, that interface type can only be implemented by that class or a descendant class. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Control</span> <span class="pl-kos">{</span>  
      <span class="pl-k">private</span> <span class="pl-c1">state</span>: <span class="pl-smi">any</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">SelectableControl</span> <span class="pl-k">extends</span> <span class="pl-smi">Control</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">select</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">Button</span> <span class="pl-k">extends</span> <span class="pl-smi">Control</span> <span class="pl-kos">{</span>  
      <span class="pl-en">select</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">TextBox</span> <span class="pl-k">extends</span> <span class="pl-smi">Control</span> <span class="pl-kos">{</span>  
      <span class="pl-en">select</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">Image</span> <span class="pl-k">extends</span> <span class="pl-smi">Control</span> <span class="pl-kos">{</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">Location</span> <span class="pl-kos">{</span>  
      <span class="pl-en">select</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p>In the above example, 'SelectableControl' contains all of the members of 'Control', including the private 'state' property. Since 'state' is a private member it is only possible for descendants of 'Control' to implement 'SelectableControl'. This is because only descendants of 'Control' will have a 'state' private member that originates in the same declaration, which is a requirement for private members to be compatible (section <a href="sec-types#type-relationships-311">3.11</a>).</p>
  <p>Within the 'Control' class it is possible to access the 'state' private member through an instance of 'SelectableControl'. Effectively, a 'SelectableControl' acts like a 'Control' that is known to have a 'select' method. The 'Button' and 'TextBox' classes are subtypes of 'SelectableControl' (because they both inherit from 'Control' and have a 'select' method), but the 'Image' and 'Location' classes are not.</p>
  <h2 id="dynamic-type-checks-74" title="7.4"> Dynamic Type Checks</h2>
  <p>TypeScript does not provide a direct mechanism for dynamically testing whether an object implements a particular interface. Instead, TypeScript code can use the JavaScript technique of checking whether an appropriate set of members are present on the object. For example, given the declarations in section <a href="#interface-declarations-71">7.1</a>, the following is a dynamic check for the 'MoverShaker' interface:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">obj</span>: <span class="pl-smi">any</span> <span class="pl-c1">=</span> <span class="pl-en">getSomeObject</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">obj</span> <span class="pl-c1">&amp;&amp;</span> <span class="pl-s1">obj</span><span class="pl-kos">.</span><span class="pl-c1">move</span> <span class="pl-c1">&amp;&amp;</span> <span class="pl-s1">obj</span><span class="pl-kos">.</span><span class="pl-c1">shake</span> <span class="pl-c1">&amp;&amp;</span> <span class="pl-s1">obj</span><span class="pl-kos">.</span><span class="pl-c1">getStatus</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-s1">moverShaker</span> <span class="pl-c1">=</span> <span class="pl-kos">&lt;</span><span class="pl-smi">MoverShaker</span><span class="pl-kos">&gt;</span> <span class="pl-s1">obj</span><span class="pl-kos">;</span>  
      ...  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>If such a check is used often it can be abstracted into a function:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">asMoverShaker</span><span class="pl-kos">(</span><span class="pl-s1">obj</span>: <span class="pl-smi">any</span><span class="pl-kos">)</span>: <span class="pl-smi">MoverShaker</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-s1">obj</span> <span class="pl-c1">&amp;&amp;</span> <span class="pl-s1">obj</span><span class="pl-kos">.</span><span class="pl-c1">move</span> <span class="pl-c1">&amp;&amp;</span> <span class="pl-s1">obj</span><span class="pl-kos">.</span><span class="pl-c1">shake</span> <span class="pl-c1">&amp;&amp;</span> <span class="pl-s1">obj</span><span class="pl-kos">.</span><span class="pl-c1">getStatus</span> ? <span class="pl-s1">obj</span> : <span class="pl-c1">null</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <br />
  </section>