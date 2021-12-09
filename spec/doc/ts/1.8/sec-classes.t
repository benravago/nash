<section id="sec-classes"><h1 id="classes-8" title="8"> Classes</h1><section id="user-content-8"><p>TypeScript extends JavaScript classes to include type parameters, implements clauses, accessibility modifiers, member variable declarations, and parameter property declarations in constructors.</p>
  </section><p><section id="user-content-8"><em>TODO: Document </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/3578">abstract classes</a></em>.</p>
  <h2 id="class-declarations-81" title="8.1"> Class Declarations</h2><section id="user-content-8.1"><p>A class declaration declares a <em><strong>class type</strong></em> and a <em><strong>constructor function</strong></em>.</p>
  <p>  <em>ClassDeclaration:</em>  <em>( Modified )</em><br />
     <code>class</code> <em>BindingIdentifier<sub>opt</sub></em> <em>TypeParameters<sub>opt</sub></em> <em>ClassHeritage</em> <code>{</code> <em>ClassBody</em> <code>}</code></p>
  <p>A <em>ClassDeclaration</em> introduces a named type (the class type) and a named value (the constructor function) in the containing declaration space. The class type is formed from the instance members declared in the class body and the instance members inherited from the base class. The constructor function is given an anonymous type formed from the constructor declaration, the static member declarations in the class body, and the static members inherited from the base class. The constructor function initializes and returns an instance of the class type.</p>
  </section><p><section id="user-content-8.1"><em>BindingIdentifier</em> of a class declaration may not be one of the predefined type names (section </section><a href="sec-types#predefined-types-381">3.8.1</a>). The <em>BindingIdentifier</em> is optional only when the class declaration occurs in an export default declaration (section <a href="sec-scripts-and-modules#export-default-declarations-11342">11.3.4.2</a>).</p>
  <p>A class may optionally have type parameters (section <a href="sec-types#type-parameter-lists-361">3.6.1</a>) that serve as placeholders for actual types to be provided when the class is referenced in type references. A class with type parameters is called a <em><strong>generic class</strong></em>. The type parameters of a generic class declaration are in scope in the entire declaration and may be referenced in the <em>ClassHeritage</em> and <em>ClassBody</em>.</p>
  <p>The following example introduces both a named type called 'Point' (the class type) and a named value called 'Point' (the constructor function) in the containing declaration space.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-k">public</span> <span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-k">public</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>  
      <span class="pl-k">public</span> <span class="pl-en">length</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-k">return</span> <span class="pl-smi">Math</span><span class="pl-kos">.</span><span class="pl-en">sqrt</span><span class="pl-kos">(</span><span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">*</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">+</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">y</span> <span class="pl-c1">*</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">y</span><span class="pl-kos">)</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
      <span class="pl-k">static</span> <span class="pl-c1">origin</span> <span class="pl-c1">=</span> <span class="pl-k">new</span> <span class="pl-smi">Point</span><span class="pl-kos">(</span><span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">0</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The named type 'Point' is exactly equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">length</span><span class="pl-kos">(</span><span class="pl-kos">)</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The named value 'Point' is a constructor function whose type corresponds to the declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-smi">Point</span>: <span class="pl-kos">{</span>  
      <span class="pl-k">new</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">Point</span><span class="pl-kos">;</span>  
      <span class="pl-c1">origin</span>: <span class="pl-smi">Point</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The context in which a class is referenced distinguishes between the class type and the constructor function. For example, in the assignment statement</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">p</span>: <span class="pl-smi">Point</span> <span class="pl-c1">=</span> <span class="pl-k">new</span> <span class="pl-smi">Point</span><span class="pl-kos">(</span><span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-c1">20</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the identifier 'Point' in the type annotation refers to the class type, whereas the identifier 'Point' in the <code>new</code> expression refers to the constructor function object.</p>
  <h3 id="class-heritage-specification-811" title="8.1.1"> Class Heritage Specification</h3>
  <p><section id="user-content-8.1.1"><em>TODO: Update this section to reflect </em></section><em><a href="https://github.com/Microsoft/TypeScript/pull/3516">expressions in class extends clauses</a></em>.</p>
  <p>The heritage specification of a class consists of optional <code>extends</code> and <code>implements</code> clauses. The <code>extends</code> clause specifies the base class of the class and the <code>implements</code> clause specifies a set of interfaces for which to validate the class provides an implementation.</p>
  <p>  <em>ClassHeritage:</em>  <em>( Modified )</em><br />
     <em>ClassExtendsClause<sub>opt</sub></em> <em>ImplementsClause<sub>opt</sub></em></p>
  <p>  <em>ClassExtendsClause:</em><br />
     <code>extends</code>  <em>ClassType</em></p>
  <p>  <em>ClassType:</em><br />
     <em>TypeReference</em></p>
  <p>  <em>ImplementsClause:</em><br />
     <code>implements</code> <em>ClassOrInterfaceTypeList</em></p>
  <p>A class that includes an <code>extends</code> clause is called a <em><strong>derived class</strong></em>, and the class specified in the <code>extends</code> clause is called the <em><strong>base class</strong></em> of the derived class. When a class heritage specification omits the <code>extends</code> clause, the class does not have a base class. However, as is the case with every object type, type references (section <a href="sec-types#named-type-references-331">3.3.1</a>) to the class will appear to have the members of the global interface type named 'Object' unless those members are hidden by members with the same name in the class.</p>
  <p>The following constraints must be satisfied by the class heritage specification or otherwise a compile-time error occurs:</p>
  <ul>
  <li>If present, the type reference specified in the <code>extends</code> clause must denote a class type. Furthermore, the <em>TypeName</em> part of the type reference is required to be a reference to the class constructor function when evaluated as an expression.</li>
  <li>A class declaration may not, directly or indirectly, specify a base class that originates in the same declaration. In other words a class cannot, directly or indirectly, be a base class of itself, regardless of type arguments.</li>
  <li>The this-type (section <a href="sec-types#this-types-363">3.6.3</a>) of the declared class must be assignable (section <a href="sec-types#assignment-compatibility-3114">3.11.4</a>) to the base type reference and each of the type references listed in the <code>implements</code> clause.</li>
  <li>The constructor function type created by the class declaration must be assignable to the base class constructor function type, ignoring construct signatures.</li>
  </ul>
  <p>The following example illustrates a situation in which the first rule above would be violated:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span> <span class="pl-c1">a</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>
  
  <span class="pl-k">namespace</span> <span class="pl-smi">Foo</span> <span class="pl-kos">{</span>  
      <span class="pl-k">var</span> <span class="pl-smi">A</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
      <span class="pl-k">class</span> <span class="pl-smi">B</span> <span class="pl-k">extends</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span> <span class="pl-c1">b</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>When evaluated as an expression, the type reference 'A' in the <code>extends</code> clause doesn't reference the class constructor function of 'A' (instead it references the local variable 'A').</p>
  <p>The only situation in which the last two constraints above are violated is when a class overrides one or more base class members with incompatible new members.</p>
  <p>Note that because TypeScript has a structural type system, a class doesn't need to explicitly state that it implements an interface—it suffices for the class to simply contain the appropriate set of instance members. The <code>implements</code> clause of a class provides a mechanism to assert and validate that the class contains the appropriate sets of instance members, but otherwise it has no effect on the class type.</p>
  <h3 id="class-body-812" title="8.1.2"> Class Body</h3><section id="user-content-8.1.2"><p>The class body consists of zero or more constructor or member declarations. Statements are not allowed in the body of a class—they must be placed in the constructor or in members.</p>
  <p>  <em>ClassElement:</em>  <em>( Modified )</em><br />
     <em>ConstructorDeclaration</em><br />
     <em>PropertyMemberDeclaration</em><br />
     <em>IndexMemberDeclaration</em></p>
  </section><p>The body of class may optionally contain a single constructor declaration. Constructor declarations are described in section <a href="#constructor-declarations-83">8.3</a>.</p>
  <p>Member declarations are used to declare instance and static members of the class. Property member declarations are described in section <a href="#property-member-declarations-84">8.4</a> and index member declarations are described in section <a href="#index-member-declarations-85">8.5</a>.</p>
  <h2 id="members-82" title="8.2"> Members</h2><section id="user-content-8.2"><p>The members of a class consist of the members introduced through member declarations in the class body and the members inherited from the base class.</p>
  </section><h3 id="instance-and-static-members-821" title="8.2.1"> Instance and Static Members</h3><section id="user-content-8.2.1"><p>Members are either <em><strong>instance members</strong></em> or <em><strong>static members</strong></em>.</p>
  </section><p>Instance members are members of the class type (section <a href="#class-types-824">8.2.4</a>) and its associated this-type. Within constructors, instance member functions, and instance member accessors, the type of <code>this</code> is the this-type (section <a href="sec-types#this-types-363">3.6.3</a>) of the class.</p>
  <p>Static members are declared using the <code>static</code> modifier and are members of the constructor function type (section <a href="#constructor-function-types-825">8.2.5</a>). Within static member functions and static member accessors, the type of <code>this</code> is the constructor function type.</p>
  <p>Class type parameters cannot be referenced in static member declarations.</p>
  <h3 id="accessibility-822" title="8.2.2"> Accessibility</h3><section id="user-content-8.2.2"><p>Property members have either <em><strong>public</strong></em>, <em><strong>private</strong></em>, or <em><strong>protected</strong></em> accessibility. The default is public accessibility, but property member declarations may include a <code>public</code>, <code>private</code>, or <code>protected</code> modifier to explicitly specify the desired accessibility.</p>
  <p>Public property members can be accessed everywhere without restrictions.</p>
  <p>Private property members can be accessed only within their declaring class. Specifically, a private member <em>M</em> declared in a class <em>C</em> can be accessed only within the class body of <em>C</em>.</p>
  <p>Protected property members can be accessed only within their declaring class and classes derived from their declaring class, and a protected instance property member must be accessed <em>through</em> an instance of the enclosing class or a subclass thereof. Specifically, a protected member <em>M</em> declared in a class <em>C</em> can be accessed only within the class body of <em>C</em> or the class body of a class derived from <em>C</em>. Furthermore, when a protected instance member <em>M</em> is accessed in a property access <em>E</em><code>.</code><em>M</em> within the body of a class <em>D</em>, the type of <em>E</em> is required to be <em>D</em> or a type that directly or indirectly has <em>D</em> as a base type, regardless of type arguments.</p>
  <p>Private and protected accessibility is enforced only at compile-time and serves as no more than an <em>indication of intent</em>. Since JavaScript provides no mechanism to create private and protected properties on an object, it is not possible to enforce the private and protected modifiers in dynamic code at run-time. For example, private and protected accessibility can be defeated by changing an object's static type to Any and accessing the member dynamically.</p>
  <p>The following example demonstrates private and protected accessibility:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-k">private</span> <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-k">protected</span> <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-k">static</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">A</span><span class="pl-kos">,</span> <span class="pl-s1">b</span>: <span class="pl-smi">B</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-s1">a</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok  </span>
          <span class="pl-s1">b</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok  </span>
          <span class="pl-s1">a</span><span class="pl-kos">.</span><span class="pl-c1">y</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok  </span>
          <span class="pl-s1">b</span><span class="pl-kos">.</span><span class="pl-c1">y</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok  </span>
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">B</span> <span class="pl-k">extends</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-k">static</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">A</span><span class="pl-kos">,</span> <span class="pl-s1">b</span>: <span class="pl-smi">B</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-s1">a</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  <span class="pl-c">// Error, x only accessible within A  </span>
          <span class="pl-s1">b</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  <span class="pl-c">// Error, x only accessible within A  </span>
          <span class="pl-s1">a</span><span class="pl-kos">.</span><span class="pl-c1">y</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  <span class="pl-c">// Error, y must be accessed through instance of B  </span>
          <span class="pl-s1">b</span><span class="pl-kos">.</span><span class="pl-c1">y</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok  </span>
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In class 'A', the accesses to 'x' are permitted because 'x' is declared in 'A', and the accesses to 'y' are permitted because both take place through an instance of 'A' or a type derived from 'A'. In class 'B', access to 'x' is not permitted, and the first access to 'y' is an error because it takes place through an instance of 'A', which is not derived from the enclosing class 'B'.</p>
  </section><h3 id="inheritance-and-overriding-823" title="8.2.3"> Inheritance and Overriding</h3><section id="user-content-8.2.3"><p>A derived class <em><strong>inherits</strong></em> all members from its base class it doesn't <em><strong>override</strong></em>. Inheritance means that a derived class implicitly contains all non-overridden members of the base class. Only public and protected property members can be overridden.</p>
  </section><p>A property member in a derived class is said to override a property member in a base class when the derived class property member has the same name and kind (instance or static) as the base class property member. The type of an overriding property member must be assignable (section <a href="sec-types#assignment-compatibility-3114">3.11.4</a>) to the type of the overridden property member, or otherwise a compile-time error occurs.</p>
  <p>Base class instance member functions can be overridden by derived class instance member functions, but not by other kinds of members.</p>
  <p>Base class instance member variables and accessors can be overridden by derived class instance member variables and accessors, but not by other kinds of members.</p>
  <p>Base class static property members can be overridden by derived class static property members of any kind as long as the types are compatible, as described above.</p>
  <p>An index member in a derived class is said to override an index member in a base class when the derived class index member is of the same index kind (string or numeric) as the base class index member. The type of an overriding index member must be assignable (section <a href="sec-types#assignment-compatibility-3114">3.11.4</a>) to the type of the overridden index member, or otherwise a compile-time error occurs.</p>
  <h3 id="class-types-824" title="8.2.4"> Class Types</h3>
  <p>A class declaration declares a new named type (section <a href="sec-types#named-types-37">3.7</a>) called a class type. Within the constructor and instance member functions of a class, the type of <code>this</code> is the this-type (section <a href="sec-types#this-types-363">3.6.3</a>) of that class type. The class type has the following members:</p>
  <ul>
  <li>A property for each instance member variable declaration in the class body.</li>
  <li>A property of a function type for each instance member function declaration in the class body.</li>
  <li>A property for each uniquely named instance member accessor declaration in the class body.</li>
  <li>A property for each constructor parameter declared with a <code>public</code>, <code>private</code>, or <code>protected</code> modifier.</li>
  <li>An index signature for each instance index member declaration in the class body.</li>
  <li>All base class instance property or index members that are not overridden in the class.</li>
  </ul>
  <p>All instance property members (including those that are private or protected) of a class must satisfy the constraints implied by the index members of the class as specified in section <a href="sec-types#index-signatures-394">3.9.4</a>.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-k">public</span> <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>  
      <span class="pl-k">public</span> <span class="pl-en">g</span><span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">any</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-k">return</span> <span class="pl-c1">undefined</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
      <span class="pl-k">static</span> <span class="pl-c1">s</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">B</span> <span class="pl-k">extends</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-k">public</span> <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-en">g</span><span class="pl-kos">(</span><span class="pl-s1">b</span>: <span class="pl-smi">boolean</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-k">return</span> <span class="pl-c1">false</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the class type of 'A' is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">f</span>: <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
      <span class="pl-c1">g</span>: <span class="pl-kos">(</span><span class="pl-s1">a</span>: <span class="pl-smi">any</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">any</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>and the class type of 'B' is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">B</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">f</span>: <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi"><span class="pl-k">void</span></span><span class="pl-kos">;</span>  
      <span class="pl-c1">g</span>: <span class="pl-kos">(</span><span class="pl-s1">b</span>: <span class="pl-smi">boolean</span><span class="pl-kos">)</span> <span class="pl-c1">=&gt;</span> <span class="pl-smi">boolean</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that static declarations in a class do not contribute to the class type—rather, static declarations introduce properties on the constructor function object. Also note that the declaration of 'g' in 'B' overrides the member inherited from 'A'.</p>
  <h3 id="constructor-function-types-825" title="8.2.5"> Constructor Function Types</h3><section id="user-content-8.2.5"><p>The type of the constructor function introduced by a class declaration is called the constructor function type. The constructor function type has the following members:</p>
  <ul>
  <li>If the class contains no constructor declaration and has no base class, a single construct signature with no parameters, having the same type parameters as the class (if any) and returning an instantiation of the class type with those type parameters passed as type arguments.</li>
  <li>If the class contains no constructor declaration and has a base class, a set of construct signatures with the same parameters as those of the base class constructor function type following substitution of type parameters with the type arguments specified in the base class type reference, all having the same type parameters as the class (if any) and returning an instantiation of the class type with those type parameters passed as type arguments.</li>
  <li>If the class contains a constructor declaration with no overloads, a construct signature with the parameter list of the constructor implementation, having the same type parameters as the class (if any) and returning an instantiation of the class type with those type parameters passed as type arguments.</li>
  <li>If the class contains a constructor declaration with overloads, a set of construct signatures with the parameter lists of the overloads, all having the same type parameters as the class (if any) and returning an instantiation of the class type with those type parameters passed as type arguments.</li>
  <li>A property for each static member variable declaration in the class body.</li>
  <li>A property of a function type for each static member function declaration in the class body.</li>
  <li>A property for each uniquely named static member accessor declaration in the class body.</li>
  <li>A property named 'prototype', the type of which is an instantiation of the class type with type Any supplied as a type argument for each type parameter.</li>
  <li>All base class constructor function type properties that are not overridden in the class.</li>
  </ul>
  <p>Every class automatically contains a static property member named 'prototype', the type of which is the containing class with type Any substituted for each type parameter.</p>
  <p>The example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Pair</span><span class="pl-c1">&lt;</span><span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-k">public</span> <span class="pl-s1">item1</span>: <span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-k">public</span> <span class="pl-s1">item2</span>: <span class="pl-smi">T2</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">TwoArrays</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-k">extends</span> <span class="pl-smi">Pair</span><span class="pl-kos">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">&gt;</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>introduces two named types corresponding to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Pair</span><span class="pl-c1">&lt;</span><span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">item1</span>: <span class="pl-smi">T1</span><span class="pl-kos">;</span>  
      <span class="pl-c1">item2</span>: <span class="pl-smi">T2</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">interface</span> <span class="pl-smi">TwoArrays</span><span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">item1</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
      <span class="pl-c1">item2</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>and two constructor functions corresponding to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-smi">Pair</span>: <span class="pl-kos">{</span>  
      <span class="pl-k">new</span> <span class="pl-c1">&lt;</span><span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">item1</span>: <span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-s1">item2</span>: <span class="pl-smi">T2</span><span class="pl-kos">)</span>: <span class="pl-smi">Pair</span><span class="pl-kos">&lt;</span><span class="pl-smi">T1</span><span class="pl-kos">,</span> <span class="pl-smi">T2</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-smi">TwoArrays</span>: <span class="pl-kos">{</span>  
      <span class="pl-k">new</span> <span class="pl-c1">&lt;</span><span class="pl-smi">T</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-s1">item1</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-s1">item2</span>: <span class="pl-smi">T</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">)</span>: <span class="pl-smi">TwoArrays</span><span class="pl-kos">&lt;</span><span class="pl-smi">T</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that each construct signature in the constructor function types has the same type parameters as its class and returns an instantiation of its class with those type parameters passed as type arguments. Also note that when a derived class doesn't declare a constructor, type arguments from the base class reference are substituted before construct signatures are propagated from the base constructor function type to the derived constructor function type.</p>
  </section><h2 id="constructor-declarations-83" title="8.3"> Constructor Declarations</h2><section id="user-content-8.3"><p>A constructor declaration declares the constructor function of a class.</p>
  <p>  <em>ConstructorDeclaration:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>constructor</code> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <code>{</code> <em>FunctionBody</em> <code>}</code><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>constructor</code> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <code>;</code></p>
  <p>Constructor declarations that specify a body are called <em><strong>constructor implementations</strong></em> and constructor declarations without a body are called <em><strong>constructor overloads</strong></em>. It is possible to specify multiple constructor overloads in a class, but a class can have at most one constructor implementation. All constructor declarations in a class must specify the same set of modifiers. Only public constructors are supported and private or protected constructors result in an error.</p>
  </section><p>In a class with no constructor declaration, an automatic constructor is provided, as described in section <a href="#automatic-constructors-833">8.3.3</a>.</p>
  <p>When a class has constructor overloads, the overloads determine the construct signatures of the type given to the constructor function object, and the constructor implementation signature (if any) must be assignable to that type. Otherwise, the constructor implementation itself determines the construct signature. This exactly parallels the way overloads are processed in a function declaration (section <a href="sec-functions#function-overloads-62">6.2</a>).</p>
  <p>When a class has both constructor overloads and a constructor implementation, the overloads must precede the implementation and all of the declarations must be consecutive with no intervening grammatical elements.</p>
  <p>The function body of a constructor is permitted to contain return statements. If return statements specify expressions, those expressions must be of types that are assignable to the this-type (section <a href="sec-types#this-types-363">3.6.3</a>) of the class.</p>
  <p>The type parameters of a generic class are in scope and accessible in a constructor declaration.</p>
  <h3 id="constructor-parameters-831" title="8.3.1"> Constructor Parameters</h3><section id="user-content-8.3.1"><p>Similar to functions, only the constructor implementation (and not constructor overloads) can specify default value expressions for optional parameters. It is a compile-time error for such default value expressions to reference <code>this</code>. When the output target is ECMAScript 3 or 5, for each parameter with a default value, a statement that substitutes the default value for an omitted argument is included in the JavaScript generated for the constructor function.</p>
  <p>A parameter of a <em>ConstructorImplementation</em> may be prefixed with a <code>public</code>, <code>private</code>, or <code>protected</code> modifier. This is called a <em><strong>parameter property declaration</strong></em> and is shorthand for declaring a property with the same name as the parameter and initializing it with the value of the parameter. For example, the declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-k">public</span> <span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-k">public</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-c">// Constructor body  </span>
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is equivalent to writing</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-k">public</span> <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">=</span> <span class="pl-s1">x</span><span class="pl-kos">;</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">y</span> <span class="pl-c1">=</span> <span class="pl-s1">y</span><span class="pl-kos">;</span>  
          <span class="pl-c">// Constructor body  </span>
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p>A parameter property declaration may declare an optional parameter (by including a question mark or a default value), but the property introduced by such a declaration is always considered a required property (section <a href="sec-types#members-336">3.3.6</a>).</p>
  <h3 id="super-calls-832" title="8.3.2"> Super Calls</h3>
  <p>Super calls (section <a href="sec-expressions#super-calls-491">4.9.1</a>) are used to call the constructor of the base class. A super call consists of the keyword <code>super</code> followed by an argument list enclosed in parentheses. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">ColoredPoint</span> <span class="pl-k">extends</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-k">public</span> <span class="pl-s1">color</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">super</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">,</span> <span class="pl-s1">y</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Constructors of classes with no <code>extends</code> clause may not contain super calls, whereas constructors of derived classes must contain at least one super call somewhere in their function body. Super calls are not permitted outside constructors or in local functions inside constructors.</p>
  <p>The first statement in the body of a constructor <em>must</em> be a super call if both of the following are true:</p>
  <ul>
  <li>The containing class is a derived class.</li>
  <li>The constructor declares parameter properties or the containing class declares instance member variables with initializers.</li>
  </ul>
  <p>In such a required super call, it is a compile-time error for argument expressions to reference <code>this</code>.</p>
  <p>Initialization of parameter properties and instance member variables with initializers takes place immediately at the beginning of the constructor body if the class has no base class, or immediately following the super call if the class is a derived class.</p>
  <h3 id="automatic-constructors-833" title="8.3.3"> Automatic Constructors</h3><section id="user-content-8.3.3"><p>If a class omits a constructor declaration, an <em><strong>automatic constructor</strong></em> is provided.</p>
  </section><p><section id="user-content-8.3.3"><code>extends</code> clause, the automatic constructor has no parameters and performs no action other than executing the instance member variable initializers (section </section><a href="#member-variable-declarations-841">8.4.1</a>), if any.</p>
  <p>In a derived class, the automatic constructor has the same parameter list (and possibly overloads) as the base class constructor. The automatically provided constructor first forwards the call to the base class constructor using a call equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-smi">BaseClass</span><span class="pl-kos">.</span><span class="pl-en">apply</span><span class="pl-kos">(</span><span class="pl-smi">this</span><span class="pl-kos">,</span> <span class="pl-smi">arguments</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>and then executes the instance member variable initializers, if any.</p>
  <h2 id="property-member-declarations-84" title="8.4"> Property Member Declarations</h2><section id="user-content-8.4"><p>Property member declarations can be member variable declarations, member function declarations, or member accessor declarations.</p>
  <p>  <em>PropertyMemberDeclaration:</em><br />
     <em>MemberVariableDeclaration</em><br />
     <em>MemberFunctionDeclaration</em><br />
     <em>MemberAccessorDeclaration</em></p>
  </section><p><section id="user-content-8.4"><code>static</code> modifier are called instance member declarations. Instance property member declarations declare properties in the class type (section </section><a href="#class-types-824">8.2.4</a>), and must specify names that are unique among all instance property member and parameter property declarations in the containing class, with the exception that instance get and set accessor declarations may pairwise specify the same name.</p>
  <p>Member declarations with a <code>static</code> modifier are called static member declarations. Static property member declarations declare properties in the constructor function type (section <a href="#constructor-function-types-825">8.2.5</a>), and must specify names that are unique among all static property member declarations in the containing class, with the exception that static get and set accessor declarations may pairwise specify the same name.</p>
  <p>Note that the declaration spaces of instance and static property members are separate. Thus, it is possible to have instance and static property members with the same name.</p>
  <p>Except for overrides, as described in section <a href="#inheritance-and-overriding-823">8.2.3</a>, it is an error for a derived class to declare a property member with the same name and kind (instance or static) as a base class member.</p>
  <p>Every class automatically contains a static property member named 'prototype', the type of which is an instantiation of the class type with type Any supplied as a type argument for each type parameter. It is an error to explicitly declare a static property member with the name 'prototype'.</p>
  <p>Below is an example of a class containing both instance and static property member declarations:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-k">public</span> <span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-k">public</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>  
      <span class="pl-k">public</span> <span class="pl-en">distance</span><span class="pl-kos">(</span><span class="pl-s1">p</span>: <span class="pl-smi">Point</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">var</span> <span class="pl-s1">dx</span> <span class="pl-c1">=</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">-</span> <span class="pl-s1">p</span><span class="pl-kos">.</span><span class="pl-c1">x</span><span class="pl-kos">;</span>  
          <span class="pl-k">var</span> <span class="pl-s1">dy</span> <span class="pl-c1">=</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">y</span> <span class="pl-c1">-</span> <span class="pl-s1">p</span><span class="pl-kos">.</span><span class="pl-c1">y</span><span class="pl-kos">;</span>  
          <span class="pl-k">return</span> <span class="pl-smi">Math</span><span class="pl-kos">.</span><span class="pl-en">sqrt</span><span class="pl-kos">(</span><span class="pl-s1">dx</span> <span class="pl-c1">*</span> <span class="pl-s1">dx</span> <span class="pl-c1">+</span> <span class="pl-s1">dy</span> <span class="pl-c1">*</span> <span class="pl-s1">dy</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-k">static</span> <span class="pl-c1">origin</span> <span class="pl-c1">=</span> <span class="pl-k">new</span> <span class="pl-smi">Point</span><span class="pl-kos">(</span><span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">0</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-k">static</span> <span class="pl-en">distance</span><span class="pl-kos">(</span><span class="pl-s1">p1</span>: <span class="pl-smi">Point</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span>: <span class="pl-smi">Point</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-k">return</span> <span class="pl-s1">p1</span><span class="pl-kos">.</span><span class="pl-en">distance</span><span class="pl-kos">(</span><span class="pl-s1">p2</span><span class="pl-kos">)</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The class type 'Point' has the members:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">distance</span><span class="pl-kos">(</span><span class="pl-s1">p</span>: <span class="pl-smi">Point</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>and the constructor function 'Point' has a type corresponding to the declaration:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-smi">Point</span>: <span class="pl-kos">{</span>  
      <span class="pl-k">new</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">Point</span><span class="pl-kos">;</span>  
      <span class="pl-c1">origin</span>: <span class="pl-smi">Point</span><span class="pl-kos">;</span>  
      <span class="pl-c1">distance</span><span class="pl-kos">(</span><span class="pl-s1">p1</span>: <span class="pl-smi">Point</span><span class="pl-kos">,</span> <span class="pl-s1">p2</span>: <span class="pl-smi">Point</span><span class="pl-kos">)</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="member-variable-declarations-841" title="8.4.1"> Member Variable Declarations</h3><section id="user-content-8.4.1"><p>A member variable declaration declares an instance member variable or a static member variable.</p>
  <p>  <em>MemberVariableDeclaration:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>PropertyName</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer<sub>opt</sub></em> <code>;</code></p>
  </section><p>The type associated with a member variable declaration is determined in the same manner as an ordinary variable declaration (see section <a href="sec-statements#variable-statements-52">5.2</a>).</p>
  <p>An instance member variable declaration introduces a member in the class type and optionally initializes a property on instances of the class. Initializers in instance member variable declarations are executed once for every new instance of the class and are equivalent to assignments to properties of <code>this</code> in the constructor. In an initializer expression for an instance member variable, <code>this</code> is of the this-type (section <a href="sec-types#this-types-363">3.6.3</a>) of the class.</p>
  <p>A static member variable declaration introduces a property in the constructor function type and optionally initializes a property on the constructor function object. Initializers in static member variable declarations are executed once when the containing script or module is loaded.</p>
  <p>Initializer expressions for instance member variables are evaluated in the scope of the class constructor body but are not permitted to reference parameters or local variables of the constructor. This effectively means that entities from outer scopes by the same name as a constructor parameter or local variable are inaccessible in initializer expressions for instance member variables.</p>
  <p>Since instance member variable initializers are equivalent to assignments to properties of <code>this</code> in the constructor, the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Employee</span> <span class="pl-kos">{</span>  
      <span class="pl-k">public</span> <span class="pl-c1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-c1">address</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-c1">retired</span> <span class="pl-c1">=</span> <span class="pl-c1">false</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-c1">manager</span>: <span class="pl-smi">Employee</span> <span class="pl-c1">=</span> <span class="pl-c1">null</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-c1">reports</span>: <span class="pl-smi">Employee</span><span class="pl-kos">[</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Employee</span> <span class="pl-kos">{</span>  
      <span class="pl-k">public</span> <span class="pl-c1">name</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-c1">address</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-c1">retired</span>: <span class="pl-smi">boolean</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-c1">manager</span>: <span class="pl-smi">Employee</span><span class="pl-kos">;</span>  
      <span class="pl-k">public</span> <span class="pl-c1">reports</span>: <span class="pl-smi">Employee</span><span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">retired</span> <span class="pl-c1">=</span> <span class="pl-c1">false</span><span class="pl-kos">;</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">manager</span> <span class="pl-c1">=</span> <span class="pl-c1">null</span><span class="pl-kos">;</span>  
          <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">reports</span> <span class="pl-c1">=</span> <span class="pl-kos">[</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="member-function-declarations-842" title="8.4.2"> Member Function Declarations</h3><section id="user-content-8.4.2"><p>A member function declaration declares an instance member function or a static member function.</p>
  <p>  <em>MemberFunctionDeclaration:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>PropertyName</em> <em>CallSignature</em> <code>{</code> <em>FunctionBody</em> <code>}</code><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>PropertyName</em> <em>CallSignature</em> <code>;</code></p>
  </section><p>A member function declaration is processed in the same manner as an ordinary function declaration (section <a href="sec-functions#functions-6">6</a>), except that in a member function <code>this</code> has a known type.</p>
  <p>All declarations for the same member function must specify the same accessibility (public, private, or protected) and kind (instance or static).</p>
  <p>An instance member function declaration declares a property in the class type and assigns a function object to a property on the prototype object of the class. In the body of an instance member function declaration, <code>this</code> is of the this-type (section <a href="sec-types#this-types-363">3.6.3</a>) of the class.</p>
  <p>A static member function declaration declares a property in the constructor function type and assigns a function object to a property on the constructor function object. In the body of a static member function declaration, the type of <code>this</code> is the constructor function type.</p>
  <p>A member function can access overridden base class members using a super property access (section <a href="sec-expressions#super-property-access-492">4.9.2</a>). For example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-k">public</span> <span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-k">public</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>  
      <span class="pl-k">public</span> <span class="pl-en">toString</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-s">"x="</span> <span class="pl-c1">+</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">x</span> <span class="pl-c1">+</span> <span class="pl-s">" y="</span> <span class="pl-c1">+</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">y</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">ColoredPoint</span> <span class="pl-k">extends</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-k">public</span> <span class="pl-s1">color</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">super</span><span class="pl-kos">(</span><span class="pl-s1">x</span><span class="pl-kos">,</span> <span class="pl-s1">y</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-k">public</span> <span class="pl-en">toString</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-smi">super</span><span class="pl-kos">.</span><span class="pl-en">toString</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">+</span> <span class="pl-s">" color="</span> <span class="pl-c1">+</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">color</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In a static member function, <code>this</code> represents the constructor function object on which the static member function was invoked. Thus, a call to 'new this()' may actually invoke a derived class constructor:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">a</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">;</span>  
      <span class="pl-k">static</span> <span class="pl-en">create</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-k">return</span> <span class="pl-k">new</span> <span class="pl-smi">this</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">B</span> <span class="pl-k">extends</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">b</span> <span class="pl-c1">=</span> <span class="pl-c1">2</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-smi">A</span><span class="pl-kos">.</span><span class="pl-en">create</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// new A()  </span>
  <span class="pl-k">var</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-smi">B</span><span class="pl-kos">.</span><span class="pl-en">create</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// new B()</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that TypeScript doesn't require or verify that derived constructor functions are subtypes of base constructor functions. In other words, changing the declaration of 'B' to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">class</span> <span class="pl-smi">B</span> <span class="pl-k">extends</span> <span class="pl-smi">A</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-k">public</span> <span class="pl-s1">b</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">super</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>does not cause errors in the example, even though the call to the constructor from the 'create' function doesn't specify an argument (thus giving the value 'undefined' to 'b').</p>
  <h3 id="member-accessor-declarations-843" title="8.4.3"> Member Accessor Declarations</h3><section id="user-content-8.4.3"><p>A member accessor declaration declares an instance member accessor or a static member accessor.</p>
  <p>  <em>MemberAccessorDeclaration:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>GetAccessor</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>SetAccessor</em></p>
  </section><p>Get and set accessors are processed in the same manner as in an object literal (section <a href="sec-expressions#object-literals-45">4.5</a>), except that a contextual type is never available in a member accessor declaration.</p>
  <p>Accessors for the same member name must specify the same accessibility.</p>
  <p>An instance member accessor declaration declares a property in the class type and defines a property on the prototype object of the class with a get or set accessor. In the body of an instance member accessor declaration, <code>this</code> is of the this-type (section <a href="sec-types#this-types-363">3.6.3</a>) of the class.</p>
  <p>A static member accessor declaration declares a property in the constructor function type and defines a property on the constructor function object of the class with a get or set accessor. In the body of a static member accessor declaration, the type of <code>this</code> is the constructor function type.</p>
  <p>Get and set accessors are emitted as calls to 'Object.defineProperty' in the generated JavaScript, as described in section <a href="#classes-without-extends-clauses-871">8.7.1</a>.</p>
  <h3 id="dynamic-property-declarations-844" title="8.4.4"> Dynamic Property Declarations</h3>
  <p><section id="user-content-8.4.4"><em>PropertyName</em> of a property member declaration is a computed property name that doesn't denote a well-known symbol (</section><a href="sec-basic-concepts#computed-property-names-223">2.2.3</a>), the construct is considered a <em><strong>dynamic property declaration</strong></em>. The following rules apply to dynamic property declarations:</p>
  <ul>
  <li>A dynamic property declaration does not introduce a property in the class type or constructor function type.</li>
  <li>The property name expression of a dynamic property assignment must be of type Any or the String, Number, or Symbol primitive type.</li>
  <li>The name associated with a dynamic property declarations is considered to be a numeric property name if the property name expression is of type Any or the Number primitive type.</li>
  </ul>
  <h2 id="index-member-declarations-85" title="8.5"> Index Member Declarations</h2>
  <p>An index member declaration introduces an index signature (section <a href="sec-types#index-signatures-394">3.9.4</a>) in the class type.</p>
  <p>  <em>IndexMemberDeclaration:</em><br />
     <em>IndexSignature</em> <code>;</code></p>
  <p>Index member declarations have no body and cannot specify an accessibility modifier.</p>
  <p>A class declaration can have at most one string index member declaration and one numeric index member declaration. All instance property members of a class must satisfy the constraints implied by the index members of the class as specified in section <a href="sec-types#index-signatures-394">3.9.4</a>.</p>
  <p>It is not possible to declare index members for the static side of a class.</p>
  <p>Note that it is seldom meaningful to include a string index signature in a class because it constrains all instance properties of the class. However, numeric index signatures can be useful to control the element type when a class is used in an array-like manner.</p>
  <h2 id="decorators-86" title="8.6"> Decorators</h2>
  <p><section id="user-content-8.6"><em>TODO: Document </em></section><em><a href="https://github.com/Microsoft/TypeScript/issues/2249">decorators</a></em>.</p>
  <h2 id="code-generation-87" title="8.7"> Code Generation</h2><section id="user-content-8.7"><p>When the output target is ECMAScript 2015 or higher, type parameters, implements clauses, accessibility modifiers, and member variable declarations are removed in the emitted code, but otherwise class declarations are emitted as written. When the output target is ECMAScript 3 or 5, more comprehensive rewrites are performed, as described in this section.</p>
  </section><h3 id="classes-without-extends-clauses-871" title="8.7.1"> Classes Without Extends Clauses</h3><section id="user-content-8.7.1"><p>A class with no <code>extends</code> clause generates JavaScript equivalent to the following:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-kos">(</span><span class="pl-s1">function</span> <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">function</span> <span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">ConstructorParameters</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">DefaultValueAssignments</span><span class="pl-c1">&gt;</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">ParameterPropertyAssignments</span><span class="pl-c1">&gt;</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">MemberVariableAssignments</span><span class="pl-c1">&gt;</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">ConstructorStatements</span><span class="pl-c1">&gt;</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-c1">&lt;</span><span class="pl-smi">MemberFunctionStatements</span><span class="pl-c1">&gt;</span>  
      <span class="pl-c1">&lt;</span><span class="pl-smi">StaticVariableAssignments</span><span class="pl-c1">&gt;</span>  
      <span class="pl-k">return</span> <span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p><em>ClassName</em> is the name of the class.</p>
  <p><em>ConstructorParameters</em> is a comma separated list of the constructor's parameter names.</p>
  </section><p><section id="user-content-8.7.1"><em>DefaultValueAssignments</em> is a sequence of default property value assignments corresponding to those generated for a regular function declaration, as described in section </section><a href="sec-functions#code-generation-66">6.6</a>.</p>
  <p><em>ParameterPropertyAssignments</em> is a sequence of assignments, one for each parameter property declaration in the constructor, in order they are declared, of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-kos">&lt;</span><span class="pl-smi">ParameterName</span><span class="pl-kos">&gt;</span> <span class="pl-c1">=</span> <span class="pl-kos">&lt;</span><span class="pl-smi">ParameterName</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>ParameterName</em> is the name of a parameter property.</p>
  <p><em>MemberVariableAssignments</em> is a sequence of assignments, one for each instance member variable declaration with an initializer, in the order they are declared, of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-kos">&lt;</span><span class="pl-smi">MemberName</span><span class="pl-kos">&gt;</span> <span class="pl-c1">=</span> <span class="pl-kos">&lt;</span><span class="pl-smi">InitializerExpression</span><span class="pl-kos">&gt;</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>MemberName</em> is the name of the member variable and <em>InitializerExpression</em> is the code generated for the initializer expression.</p>
  <p><em>ConstructorStatements</em> is the code generated for the statements specified in the constructor body.</p>
  <p><em>MemberFunctionStatements</em> is a sequence of statements, one for each member function declaration or member accessor declaration, in the order they are declared.</p>
  <p>An instance member function declaration generates a statement of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">.</span><span class="pl-s1">prototype</span><span class="pl-kos">.</span><span class="pl-kos">&lt;</span><span class="pl-smi">MemberName</span><span class="pl-kos">&gt;</span> <span class="pl-c1">=</span> <span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">FunctionParameters</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-kos">&lt;</span><span class="pl-smi">DefaultValueAssignments</span><span class="pl-kos">&gt;</span>  
      <span class="pl-c1">&lt;</span><span class="pl-smi">FunctionStatements</span><span class="pl-c1">&gt;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>and static member function declaration generates a statement of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">.</span><span class="pl-c1">&lt;</span><span class="pl-smi">MemberName</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">FunctionParameters</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-kos">&lt;</span><span class="pl-smi">DefaultValueAssignments</span><span class="pl-kos">&gt;</span>  
      <span class="pl-c1">&lt;</span><span class="pl-smi">FunctionStatements</span><span class="pl-c1">&gt;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>MemberName</em> is the name of the member function, and <em>FunctionParameters</em>, <em>DefaultValueAssignments</em>, and <em>FunctionStatements</em> correspond to those generated for a regular function declaration, as described in section <a href="sec-functions#code-generation-66">6.6</a>.</p>
  <p>A get or set instance member accessor declaration, or a pair of get and set instance member accessor declarations with the same name, generates a statement of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-smi">Object</span><span class="pl-kos">.</span><span class="pl-c1">defineProperty</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">.</span><span class="pl-c1">prototype</span><span class="pl-kos">,</span> <span class="pl-s">"&lt;MemberName&gt;"</span><span class="pl-kos">,</span> <span class="pl-kos">{</span>  
      <span class="pl-en">get</span>: <span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">GetAccessorStatements</span><span class="pl-c1">&gt;</span>  
      <span class="pl-kos">}</span><span class="pl-kos">,</span>  
      <span class="pl-c1">set</span>: <span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">ParameterName</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">SetAccessorStatements</span><span class="pl-c1">&gt;</span>  
      <span class="pl-kos">}</span><span class="pl-kos">,</span>  
      <span class="pl-s1">enumerable</span>: <span class="pl-c1">true</span><span class="pl-kos">,</span>  
      <span class="pl-s1">configurable</span>: <span class="pl-c1">true</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>and a get or set static member accessor declaration, or a pair of get and set static member accessor declarations with the same name, generates a statement of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-smi">Object</span><span class="pl-kos">.</span><span class="pl-c1">defineProperty</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">,</span> <span class="pl-s">"&lt;MemberName&gt;"</span><span class="pl-kos">,</span> <span class="pl-kos">{</span>  
      <span class="pl-en">get</span>: <span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">GetAccessorStatements</span><span class="pl-c1">&gt;</span>  
      <span class="pl-kos">}</span><span class="pl-kos">,</span>  
      <span class="pl-c1">set</span>: <span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">ParameterName</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">SetAccessorStatements</span><span class="pl-c1">&gt;</span>  
      <span class="pl-kos">}</span><span class="pl-kos">,</span>  
      <span class="pl-s1">enumerable</span>: <span class="pl-c1">true</span><span class="pl-kos">,</span>  
      <span class="pl-s1">configurable</span>: <span class="pl-c1">true</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>MemberName</em> is the name of the member accessor, <em>GetAccessorStatements</em> is the code generated for the statements in the get acessor's function body, <em>ParameterName</em> is the name of the set accessor parameter, and <em>SetAccessorStatements</em> is the code generated for the statements in the set accessor's function body. The 'get' property is included only if a get accessor is declared and the 'set' property is included only if a set accessor is declared.</p>
  <p><em>StaticVariableAssignments</em> is a sequence of statements, one for each static member variable declaration with an initializer, in the order they are declared, of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">.</span><span class="pl-c1">&lt;</span><span class="pl-smi">MemberName</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-c1">&lt;</span><span class="pl-smi">InitializerExpression</span><span class="pl-c1">&gt;</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>MemberName</em> is the name of the static variable, and <em>InitializerExpression</em> is the code generated for the initializer expression.</p>
  <h3 id="classes-with-extends-clauses-872" title="8.7.2"> Classes With Extends Clauses</h3><section id="user-content-8.7.2"><p>A class with an <code>extends</code> clause generates JavaScript equivalent to the following:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span> <span class="pl-c1">=</span> <span class="pl-kos">(</span><span class="pl-s1">function</span> <span class="pl-kos">(</span><span class="pl-s1">_super</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-en">__extends</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">,</span> <span class="pl-s1">_super</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-k">function</span> <span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">ConstructorParameters</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">DefaultValueAssignments</span><span class="pl-c1">&gt;</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">SuperCallStatement</span><span class="pl-c1">&gt;</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">ParameterPropertyAssignments</span><span class="pl-c1">&gt;</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">MemberVariableAssignments</span><span class="pl-c1">&gt;</span>  
          <span class="pl-c1">&lt;</span><span class="pl-smi">ConstructorStatements</span><span class="pl-c1">&gt;</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-c1">&lt;</span><span class="pl-smi">MemberFunctionStatements</span><span class="pl-c1">&gt;</span>  
      <span class="pl-c1">&lt;</span><span class="pl-smi">StaticVariableAssignments</span><span class="pl-c1">&gt;</span>  
      <span class="pl-k">return</span> <span class="pl-c1">&lt;</span><span class="pl-smi">ClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">BaseClassName</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>In addition, the '__extends' function below is emitted at the beginning of the JavaScript source file. It copies all properties from the base constructor function object to the derived constructor function object (in order to inherit static members), and appropriately establishes the 'prototype' property of the derived constructor function object.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">__extends</span> <span class="pl-c1">=</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">__extends</span> <span class="pl-c1">||</span> <span class="pl-k">function</span><span class="pl-kos">(</span><span class="pl-s1">d</span><span class="pl-kos">,</span> <span class="pl-s1">b</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">for</span> <span class="pl-kos">(</span><span class="pl-k">var</span> <span class="pl-s1">p</span> <span class="pl-k">in</span> <span class="pl-s1">b</span><span class="pl-kos">)</span> <span class="pl-k">if</span> <span class="pl-kos">(</span><span class="pl-s1">b</span><span class="pl-kos">.</span><span class="pl-en">hasOwnProperty</span><span class="pl-kos">(</span><span class="pl-s1">p</span><span class="pl-kos">)</span><span class="pl-kos">)</span> <span class="pl-s1">d</span><span class="pl-kos">[</span><span class="pl-s1">p</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-s1">b</span><span class="pl-kos">[</span><span class="pl-s1">p</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  
      <span class="pl-k">function</span> <span class="pl-en">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-smi">this</span><span class="pl-kos">.</span><span class="pl-c1">constructor</span> <span class="pl-c1">=</span> <span class="pl-s1">d</span><span class="pl-kos">;</span> <span class="pl-kos">}</span>  
      <span class="pl-s1">f</span><span class="pl-kos">.</span><span class="pl-c1">prototype</span> <span class="pl-c1">=</span> <span class="pl-s1">b</span><span class="pl-kos">.</span><span class="pl-c1">prototype</span><span class="pl-kos">;</span>  
      <span class="pl-s1">d</span><span class="pl-kos">.</span><span class="pl-c1">prototype</span> <span class="pl-c1">=</span> <span class="pl-k">new</span> <span class="pl-s1">f</span><span class="pl-kos">(</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p><em>BaseClassName</em> is the class name specified in the <code>extends</code> clause.</p>
  <p>If the class has no explicitly declared constructor, the <em>SuperCallStatement</em> takes the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">_super</span><span class="pl-kos">.</span><span class="pl-en">apply</span><span class="pl-kos">(</span><span class="pl-smi">this</span><span class="pl-kos">,</span> <span class="pl-smi">arguments</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p><section id="user-content-8.7.2"><em>SuperCallStatement</em> is present if the constructor function is required to start with a super call, as discussed in section </section><a href="#super-calls-832">8.3.2</a>, and takes the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">_super</span><span class="pl-kos">.</span><span class="pl-en">call</span><span class="pl-kos">(</span><span class="pl-smi">this</span><span class="pl-kos">,</span> <span class="pl-c1">&lt;</span><span class="pl-smi">SuperCallArguments</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>SuperCallArguments</em> is the argument list specified in the super call. Note that this call precedes the code generated for parameter properties and member variables with initializers. Super calls elsewhere in the constructor generate similar code, but the code generated for such calls will be part of the <em>ConstructorStatements</em> section.</p>
  <p>A super property access in the constructor, an instance member function, or an instance member accessor generates JavaScript equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">_super</span><span class="pl-kos">.</span><span class="pl-c1">prototype</span><span class="pl-kos">.</span><span class="pl-kos">&lt;</span><span class="pl-smi">PropertyName</span><span class="pl-kos">&gt;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>PropertyName</em> is the name of the referenced base class property. When the super property access appears in a function call, the generated JavaScript is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">_super</span><span class="pl-kos">.</span><span class="pl-c1">prototype</span><span class="pl-kos">.</span><span class="pl-kos">&lt;</span><span class="pl-smi">PropertyName</span><span class="pl-kos">&gt;</span><span class="pl-kos">.</span><span class="pl-en">call</span><span class="pl-kos">(</span><span class="pl-smi">this</span><span class="pl-kos">,</span> <span class="pl-c1">&lt;</span><span class="pl-smi">Arguments</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where Arguments is the code generated for the argument list specified in the function call.</p>
  <p>A super property access in a static member function or a static member accessor generates JavaScript equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">_super</span><span class="pl-kos">.</span><span class="pl-kos">&lt;</span><span class="pl-smi">PropertyName</span><span class="pl-kos">&gt;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>PropertyName</em> is the name of the referenced base class property. When the super property access appears in a function call, the generated JavaScript is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">_super</span><span class="pl-kos">.</span><span class="pl-kos">&lt;</span><span class="pl-smi">PropertyName</span><span class="pl-kos">&gt;</span><span class="pl-kos">.</span><span class="pl-en">call</span><span class="pl-kos">(</span><span class="pl-smi">this</span><span class="pl-kos">,</span> <span class="pl-c1">&lt;</span><span class="pl-smi">Arguments</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where Arguments is the code generated for the argument list specified in the function call.</p>
  <br />
  </section>