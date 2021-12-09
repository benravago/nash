<section id="sec-enums"><h1 id="enums-9" title="9"> Enums</h1><section id="user-content-9"><p>An enum type is a distinct subtype of the Number primitive type with an associated set of named constants that define the possible values of the enum type.</p>
  </section><h2 id="enum-declarations-91" title="9.1"> Enum Declarations</h2><section id="user-content-9.1"><p>An enum declaration declares an <em><strong>enum type</strong></em> and an <em><strong>enum object</strong></em>.</p>
  <p>  <em>EnumDeclaration:</em><br />
     <code>const</code><em><sub>opt</sub></em> <code>enum</code> <em>BindingIdentifier</em> <code>{</code> <em>EnumBody<sub>opt</sub></em> <code>}</code></p>
  <p>An <em>EnumDeclaration</em> introduces a named type (the enum type) and a named value (the enum object) in the containing declaration space. The enum type is a distinct subtype of the Number primitive type. The enum object is a value of an anonymous object type containing a set of properties, all of the enum type, corresponding to the values declared for the enum type in the body of the declaration. The enum object's type furthermore includes a numeric index signature with the signature '[x: number]: string'.</p>
  </section><p><section id="user-content-9.1"><em>BindingIdentifier</em> of an enum declaration may not be one of the predefined type names (section </section><a href="sec-types#predefined-types-381">3.8.1</a>).</p>
  <p>When an enum declaration includes a <code>const</code> modifier it is said to be a constant enum declaration. The members of a constant enum declaration must all have constant values that can be computed at compile time. Constant enum declarations are discussed in section <a href="#constant-enum-declarations-94">9.4</a>.</p>
  <p>The example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">enum</span> <span class="pl-smi">Color</span> <span class="pl-kos">{</span> <span class="pl-c1">Red</span><span class="pl-kos">,</span> <span class="pl-c1">Green</span><span class="pl-kos">,</span> <span class="pl-c1">Blue</span> <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>declares a subtype of the Number primitive type called 'Color' and introduces a variable 'Color' with a type that corresponds to the declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-smi">Color</span>: <span class="pl-kos">{</span>  
      <span class="pl-kos">[</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">]</span>: <span class="pl-smi">string</span><span class="pl-kos">;</span>  
      <span class="pl-c1">Red</span>: <span class="pl-smi">Color</span><span class="pl-kos">;</span>  
      <span class="pl-c1">Green</span>: <span class="pl-smi">Color</span><span class="pl-kos">;</span>  
      <span class="pl-c1">Blue</span>: <span class="pl-smi">Color</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The numeric index signature reflects a "reverse mapping" that is automatically generated in every enum object, as described in section <a href="#code-generation-95">9.5</a>. The reverse mapping provides a convenient way to obtain the string representation of an enum value. For example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">c</span> <span class="pl-c1">=</span> <span class="pl-smi">Color</span><span class="pl-kos">.</span><span class="pl-c1">Red</span><span class="pl-kos">;</span>  
  <span class="pl-smi">console</span><span class="pl-kos">.</span><span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-smi">Color</span><span class="pl-kos">[</span><span class="pl-s1">c</span><span class="pl-kos">]</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  <span class="pl-c">// Outputs "Red"</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h2 id="enum-members-92" title="9.2"> Enum Members</h2><section id="user-content-9.2"><p>The body of an enum declaration defines zero or more enum members which are the named values of the enum type. Each enum member has an associated numeric value of the primitive type introduced by the enum declaration.</p>
  <p>  <em>EnumBody:</em><br />
     <em>EnumMemberList</em> <code>,</code><em><sub>opt</sub></em></p>
  <p>  <em>EnumMemberList:</em><br />
     <em>EnumMember</em><br />
     <em>EnumMemberList</em> <code>,</code> <em>EnumMember</em></p>
  <p>  <em>EnumMember:</em><br />
     <em>PropertyName</em><br />
     <em>PropertyName</em> = <em>EnumValue</em></p>
  <p>  <em>EnumValue:</em><br />
     <em>AssignmentExpression</em></p>
  </section><p><section id="user-content-9.2"><em>PropertyName</em> of an enum member cannot be a computed property name (</section><a href="sec-basic-concepts#computed-property-names-223">2.2.3</a>).</p>
  <p>Enum members are either <em><strong>constant members</strong></em> or <em><strong>computed members</strong></em>. Constant members have known constant values that are substituted in place of references to the members in the generated JavaScript code. Computed members have values that are computed at run-time and not known at compile-time. No substitution is performed for references to computed members.</p>
  <p>An enum member is classified as follows:</p>
  <ul>
  <li>If the member declaration specifies no value, the member is considered a constant enum member. If the member is the first member in the enum declaration, it is assigned the value zero. Otherwise, it is assigned the value of the immediately preceding member plus one, and an error occurs if the immediately preceding member is not a constant enum member.</li>
  <li>If the member declaration specifies a value that can be classified as a constant enum expression (as defined below), the member is considered a constant enum member.</li>
  <li>Otherwise, the member is considered a computed enum member.</li>
  </ul>
  <p>Enum value expressions must be of type Any, the Number primitive type, or the enum type itself.</p>
  <p>A <em><strong>constant enum expression</strong></em> is a subset of the expression grammar that can be evaluated fully at compile time. An expression is considered a constant enum expression if it is one of the following:</p>
  <ul>
  <li>A numeric literal.</li>
  <li>An identifier or property access that denotes a previously declared member in the same constant enum declaration.</li>
  <li>A parenthesized constant enum expression.</li>
  <li>A +, –, or ~ unary operator applied to a constant enum expression.</li>
  <li>A +, –, *, /, %, &lt;&lt;, &gt;&gt;, &gt;&gt;&gt;, &amp;, ^, or | operator applied to two constant enum expressions.</li>
  </ul>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">enum</span> <span class="pl-smi">Test</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">A</span><span class="pl-kos">,</span>  
      <span class="pl-c1">B</span><span class="pl-kos">,</span>  
      <span class="pl-c1">C</span> <span class="pl-c1">=</span> <span class="pl-smi">Math</span><span class="pl-kos">.</span><span class="pl-en">floor</span><span class="pl-kos">(</span><span class="pl-smi">Math</span><span class="pl-kos">.</span><span class="pl-en">random</span><span class="pl-kos">(</span><span class="pl-kos">)</span> <span class="pl-c1">*</span> <span class="pl-c1">1000</span><span class="pl-kos">)</span><span class="pl-kos">,</span>  
      <span class="pl-c1">D</span> <span class="pl-c1">=</span> <span class="pl-c1">10</span><span class="pl-kos">,</span>  
      <span class="pl-c1">E</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>'A', 'B', 'D', and 'E' are constant members with values 0, 1, 10, and 11 respectively, and 'C' is a computed member.</p>
  <p>In the example</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">enum</span> <span class="pl-smi">Style</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">None</span> <span class="pl-c1">=</span> <span class="pl-c1">0</span><span class="pl-kos">,</span>  
      <span class="pl-c1">Bold</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">,</span>  
      <span class="pl-c1">Italic</span> <span class="pl-c1">=</span> <span class="pl-c1">2</span><span class="pl-kos">,</span>  
      <span class="pl-c1">Underline</span> <span class="pl-c1">=</span> <span class="pl-c1">4</span><span class="pl-kos">,</span>  
      <span class="pl-c1">Emphasis</span> <span class="pl-c1">=</span> <span class="pl-smi">Bold</span> <span class="pl-c1">|</span> <span class="pl-smi">Italic</span><span class="pl-kos">,</span>  
      <span class="pl-c1">Hyperlink</span> <span class="pl-c1">=</span> <span class="pl-smi">Bold</span> <span class="pl-c1">|</span> <span class="pl-smi">Underline</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>all members are constant members. Note that enum member declarations can reference other enum members without qualification. Also, because enums are subtypes of the Number primitive type, numeric operators, such as the bitwise OR operator, can be used to compute enum values.</p>
  <h2 id="declaration-merging-93" title="9.3"> Declaration Merging</h2>
  <p>Enums are "open-ended" and enum declarations with the same qualified name relative to a common root (as defined in section <a href="sec-basic-concepts#declarations-23">2.3</a>) define a single enum type and contribute to a single enum object.</p>
  <p>It isn't possible for one enum declaration to continue the automatic numbering sequence of another, and when an enum type has multiple declarations, only one declaration is permitted to omit a value for the first member.</p>
  <p>When enum declarations are merged, they must either all specify a <code>const</code> modifier or all specify no <code>const</code> modifier.</p>
  <h2 id="constant-enum-declarations-94" title="9.4"> Constant Enum Declarations</h2><section id="user-content-9.4"><p>An enum declaration that specifies a <code>const</code> modifier is a <em><strong>constant enum declaration</strong></em>. In a constant enum declaration, all members must have constant values and it is an error for a member declaration to specify an expression that isn't classified as a constant enum expression.</p>
  <p>Unlike regular enum declarations, constant enum declarations are completely erased in the emitted JavaScript code. For this reason, it is an error to reference a constant enum object in any other context than a property access that selects one of the enum's members. For example:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">const</span> <span class="pl-k">enum</span> <span class="pl-smi">Comparison</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">LessThan</span> <span class="pl-c1">=</span> <span class="pl-c1">-</span><span class="pl-c1">1</span><span class="pl-kos">,</span>  
      <span class="pl-c1">EqualTo</span> <span class="pl-c1">=</span> <span class="pl-c1">0</span><span class="pl-kos">,</span>  
      <span class="pl-c1">GreaterThan</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">x</span> <span class="pl-c1">=</span> <span class="pl-smi">Comparison</span><span class="pl-kos">.</span><span class="pl-c1">EqualTo</span><span class="pl-kos">;</span>  <span class="pl-c">// Ok, replaced with 0 in emitted code  </span>
  <span class="pl-k">var</span> <span class="pl-s1">y</span> <span class="pl-c1">=</span> <span class="pl-smi">Comparison</span><span class="pl-kos">[</span><span class="pl-smi">Comparison</span><span class="pl-kos">.</span><span class="pl-c1">EqualTo</span><span class="pl-kos">]</span><span class="pl-kos">;</span>  <span class="pl-c">// Error  </span>
  <span class="pl-k">var</span> <span class="pl-s1">z</span> <span class="pl-c1">=</span> <span class="pl-smi">Comparison</span><span class="pl-kos">;</span>  <span class="pl-c">// Error</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The entire const enum declaration is erased in the emitted JavaScript code. Thus, the only permitted references to the enum object are those that are replaced with an enum member value.</p>
  </section><h2 id="code-generation-95" title="9.5"> Code Generation</h2><section id="user-content-9.5"><p>An enum declaration generates JavaScript equivalent to the following:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-c1">&lt;</span><span class="pl-smi">EnumName</span><span class="pl-c1">&gt;</span><span class="pl-kos">;</span>  
  <span class="pl-kos">(</span><span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">EnumName</span><span class="pl-c1">&gt;</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">&lt;</span><span class="pl-smi">EnumMemberAssignments</span><span class="pl-c1">&gt;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">EnumName</span><span class="pl-c1">&gt;</span><span class="pl-c1">||</span><span class="pl-kos">(</span><span class="pl-c1">&lt;</span><span class="pl-smi">EnumName</span><span class="pl-c1">&gt;</span><span class="pl-c1">=</span><span class="pl-kos">{</span><span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p><em>EnumName</em> is the name of the enum.</p>
  <p><em>EnumMemberAssignments</em> is a sequence of assignments, one for each enum member, in order they are declared, of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-kos">&lt;</span><span class="pl-smi">EnumName</span><span class="pl-kos">&gt;</span><span class="pl-kos">[</span><span class="pl-kos">&lt;</span><span class="pl-smi">EnumName</span><span class="pl-kos">&gt;</span><span class="pl-kos">[</span><span class="pl-s">"&lt;MemberName&gt;"</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-kos">&lt;</span><span class="pl-smi">Value</span><span class="pl-kos">&gt;</span><span class="pl-kos">]</span><span class="pl-c1" /> <span class="pl-c1">=</span> <span class="pl-s">"&lt;MemberName&gt;"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>where <em>MemberName</em> is the name of the enum member and <em>Value</em> is the assigned constant value or the code generated for the computed value expression.</p>
  </section><p>For example, the 'Color' enum example from section <a href="#enum-declarations-91">9.1</a> generates the following JavaScript:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-smi">Color</span><span class="pl-kos">;</span>  
  <span class="pl-kos">(</span><span class="pl-k">function</span> <span class="pl-kos">(</span><span class="pl-smi">Color</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-smi">Color</span><span class="pl-kos">[</span><span class="pl-smi">Color</span><span class="pl-kos">[</span><span class="pl-s">"Red"</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-c1">0</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-s">"Red"</span><span class="pl-kos">;</span>  
      <span class="pl-smi">Color</span><span class="pl-kos">[</span><span class="pl-smi">Color</span><span class="pl-kos">[</span><span class="pl-s">"Green"</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-c1">1</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-s">"Green"</span><span class="pl-kos">;</span>  
      <span class="pl-smi">Color</span><span class="pl-kos">[</span><span class="pl-smi">Color</span><span class="pl-kos">[</span><span class="pl-s">"Blue"</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-c1">2</span><span class="pl-kos">]</span> <span class="pl-c1">=</span> <span class="pl-s">"Blue"</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">(</span><span class="pl-smi">Color</span><span class="pl-c1">||</span><span class="pl-kos">(</span><span class="pl-smi">Color</span><span class="pl-c1">=</span><span class="pl-kos">{</span><span class="pl-kos">}</span><span class="pl-kos">)</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <br />
  </section>