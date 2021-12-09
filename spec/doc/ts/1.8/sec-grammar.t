<section id="sec-grammar"><h1 id="grammar-a" title="A"> Grammar</h1>
  <p>This appendix contains a summary of the grammar found in the main document. As described in section <a href="sec-basic-concepts#grammar-conventions-21">2.1</a>, the TypeScript grammar is a superset of the grammar defined in the <a href="http://www.ecma-international.org/ecma-262/6.0/" rel="nofollow">ECMAScript 2015 Language Specification</a> (specifically, the ECMA-262 Standard, 6th Edition) and this appendix lists only productions that are new or modified from the ECMAScript grammar.</p>
  <h2 id="types-a1" title="A.1"> Types</h2><section id="user-content-a.1"><p>  <em>TypeParameters:</em><br />
     <code>&lt;</code> <em>TypeParameterList</em> <code>&gt;</code></p>
  <p>  <em>TypeParameterList:</em><br />
     <em>TypeParameter</em><br />
     <em>TypeParameterList</em> <code>,</code> <em>TypeParameter</em></p>
  <p>  <em>TypeParameter:</em><br />
     <em>BindingIdentifier</em> <em>Constraint<sub>opt</sub></em></p>
  <p>  <em>Constraint:</em><br />
     <code>extends</code> <em>Type</em></p>
  <p>  <em>TypeArguments:</em><br />
     <code>&lt;</code> <em>TypeArgumentList</em> <code>&gt;</code></p>
  <p>  <em>TypeArgumentList:</em><br />
     <em>TypeArgument</em><br />
     <em>TypeArgumentList</em> <code>,</code> <em>TypeArgument</em></p>
  <p>  <em>TypeArgument:</em><br />
     <em>Type</em></p>
  <p>  <em>Type:</em><br />
     <em>UnionOrIntersectionOrPrimaryType</em><br />
     <em>FunctionType</em><br />
     <em>ConstructorType</em></p>
  <p>  <em>UnionOrIntersectionOrPrimaryType:</em><br />
     <em>UnionType</em><br />
     <em>IntersectionOrPrimaryType</em></p>
  <p>  <em>IntersectionOrPrimaryType:</em><br />
     <em>IntersectionType</em><br />
     <em>PrimaryType</em></p>
  <p>  <em>PrimaryType:</em><br />
     <em>ParenthesizedType</em><br />
     <em>PredefinedType</em><br />
     <em>TypeReference</em><br />
     <em>ObjectType</em><br />
     <em>ArrayType</em><br />
     <em>TupleType</em><br />
     <em>TypeQuery</em><br />
     <em>ThisType</em></p>
  <p>  <em>ParenthesizedType:</em><br />
     <code>(</code> <em>Type</em> <code>)</code></p>
  <p>  <em>PredefinedType:</em><br />
     <code>any</code><br />
     <code>number</code><br />
     <code>boolean</code><br />
     <code>string</code><br />
     <code>symbol</code><br />
     <code>void</code></p>
  <p>  <em>TypeReference:</em><br />
     <em>TypeName</em> <em>[no LineTerminator here]</em> <em>TypeArguments<sub>opt</sub></em></p>
  <p>  <em>TypeName:</em><br />
     <em>IdentifierReference</em><br />
     <em>NamespaceName</em> <code>.</code> <em>IdentifierReference</em></p>
  <p>  <em>NamespaceName:</em><br />
     <em>IdentifierReference</em><br />
     <em>NamespaceName</em> <code>.</code> <em>IdentifierReference</em></p>
  <p>  <em>ObjectType:</em><br />
     <code>{</code> <em>TypeBody<sub>opt</sub></em> <code>}</code></p>
  <p>  <em>TypeBody:</em><br />
     <em>TypeMemberList</em> <code>;</code><em><sub>opt</sub></em><br />
     <em>TypeMemberList</em> <code>,</code><em><sub>opt</sub></em></p>
  <p>  <em>TypeMemberList:</em><br />
     <em>TypeMember</em><br />
     <em>TypeMemberList</em> <code>;</code> <em>TypeMember</em><br />
     <em>TypeMemberList</em> <code>,</code> <em>TypeMember</em></p>
  <p>  <em>TypeMember:</em><br />
     <em>PropertySignature</em><br />
     <em>CallSignature</em><br />
     <em>ConstructSignature</em><br />
     <em>IndexSignature</em><br />
     <em>MethodSignature</em></p>
  <p>  <em>ArrayType:</em><br />
     <em>PrimaryType</em> <em>[no LineTerminator here]</em> <code>[</code> <code>]</code></p>
  <p>  <em>TupleType:</em><br />
     <code>[</code> <em>TupleElementTypes</em> <code>]</code></p>
  <p>  <em>TupleElementTypes:</em><br />
     <em>TupleElementType</em><br />
     <em>TupleElementTypes</em> <code>,</code> <em>TupleElementType</em></p>
  <p>  <em>TupleElementType:</em><br />
     <em>Type</em></p>
  <p>  <em>UnionType:</em><br />
     <em>UnionOrIntersectionOrPrimaryType</em> <code>|</code> <em>IntersectionOrPrimaryType</em></p>
  <p>  <em>IntersectionType:</em><br />
     <em>IntersectionOrPrimaryType</em> <code>&amp;</code> <em>PrimaryType</em></p>
  <p>  <em>FunctionType:</em><br />
     <em>TypeParameters<sub>opt</sub></em> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <code>=&gt;</code> <em>Type</em></p>
  <p>  <em>ConstructorType:</em><br />
     <code>new</code> <em>TypeParameters<sub>opt</sub></em> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <code>=&gt;</code> <em>Type</em></p>
  <p>  <em>TypeQuery:</em><br />
     <code>typeof</code> <em>TypeQueryExpression</em></p>
  <p>  <em>TypeQueryExpression:</em><br />
     <em>IdentifierReference</em><br />
     <em>TypeQueryExpression</em> <code>.</code> <em>IdentifierName</em></p>
  <p>  <em>ThisType:</em><br />
     <code>this</code></p>
  <p>  <em>PropertySignature:</em><br />
     <em>PropertyName</em> <code>?</code><em><sub>opt</sub></em> <em>TypeAnnotation<sub>opt</sub></em></p>
  <p>  <em>PropertyName:</em><br />
     <em>IdentifierName</em><br />
     <em>StringLiteral</em><br />
     <em>NumericLiteral</em></p>
  <p>  <em>TypeAnnotation:</em><br />
     <code>:</code> <em>Type</em></p>
  <p>  <em>CallSignature:</em><br />
     <em>TypeParameters<sub>opt</sub></em> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <em>TypeAnnotation<sub>opt</sub></em></p>
  <p>  <em>ParameterList:</em><br />
     <em>RequiredParameterList</em><br />
     <em>OptionalParameterList</em><br />
     <em>RestParameter</em><br />
     <em>RequiredParameterList</em> <code>,</code> <em>OptionalParameterList</em><br />
     <em>RequiredParameterList</em> <code>,</code> <em>RestParameter</em><br />
     <em>OptionalParameterList</em> <code>,</code> <em>RestParameter</em><br />
     <em>RequiredParameterList</em> <code>,</code> <em>OptionalParameterList</em> <code>,</code> <em>RestParameter</em></p>
  <p>  <em>RequiredParameterList:</em><br />
     <em>RequiredParameter</em><br />
     <em>RequiredParameterList</em> <code>,</code> <em>RequiredParameter</em></p>
  <p>  <em>RequiredParameter:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <em>BindingIdentifierOrPattern</em> <em>TypeAnnotation<sub>opt</sub></em><br />
     <em>BindingIdentifier</em> <code>:</code> <em>StringLiteral</em></p>
  <p>  <em>AccessibilityModifier:</em><br />
     <code>public</code><br />
     <code>private</code><br />
     <code>protected</code></p>
  <p>  <em>BindingIdentifierOrPattern:</em><br />
     <em>BindingIdentifier</em><br />
     <em>BindingPattern</em></p>
  <p>  <em>OptionalParameterList:</em><br />
     <em>OptionalParameter</em><br />
     <em>OptionalParameterList</em> <code>,</code> <em>OptionalParameter</em></p>
  <p>  <em>OptionalParameter:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <em>BindingIdentifierOrPattern</em> <code>?</code> <em>TypeAnnotation<sub>opt</sub></em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <em>BindingIdentifierOrPattern</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer</em><br />
     <em>BindingIdentifier</em> <code>?</code> <code>:</code> <em>StringLiteral</em></p>
  <p>  <em>RestParameter:</em><br />
     <code>...</code> <em>BindingIdentifier</em> <em>TypeAnnotation<sub>opt</sub></em></p>
  <p>  <em>ConstructSignature:</em><br />
     <code>new</code> <em>TypeParameters<sub>opt</sub></em> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <em>TypeAnnotation<sub>opt</sub></em></p>
  <p>  <em>IndexSignature:</em><br />
     <code>[</code> <em>BindingIdentifier</em> <code>:</code> <code>string</code> <code>]</code> <em>TypeAnnotation</em><br />
     <code>[</code> <em>BindingIdentifier</em> <code>:</code> <code>number</code> <code>]</code> <em>TypeAnnotation</em></p>
  <p>  <em>MethodSignature:</em><br />
     <em>PropertyName</em> <code>?</code><em><sub>opt</sub></em> <em>CallSignature</em></p>
  <p>  <em>TypeAliasDeclaration:</em><br />
     <code>type</code> <em>BindingIdentifier</em> <em>TypeParameters<sub>opt</sub></em> <code>=</code> <em>Type</em> <code>;</code></p>
  </section><h2 id="expressions-a2" title="A.2"> Expressions</h2><section id="user-content-a.2"><p>  <em>PropertyDefinition:</em>  <em>( Modified )</em><br />
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
  <p>  <em>FunctionExpression:</em>  <em>( Modified )</em><br />
     <code>function</code> <em>BindingIdentifier<sub>opt</sub></em> <em>CallSignature</em> <code>{</code> <em>FunctionBody</em> <code>}</code></p>
  <p>  <em>ArrowFormalParameters:</em>  <em>( Modified )</em><br />
     <em>CallSignature</em></p>
  <p>  <em>Arguments:</em>  <em>( Modified )</em><br />
     <em>TypeArguments<sub>opt</sub></em> <code>(</code> <em>ArgumentList<sub>opt</sub></em> <code>)</code></p>
  <p>  <em>UnaryExpression:</em>  <em>( Modified )</em><br />
     …<br />
     <code>&lt;</code> <em>Type</em> <code>&gt;</code> <em>UnaryExpression</em></p>
  </section><h2 id="statements-a3" title="A.3"> Statements</h2><section id="user-content-a.3"><p>  <em>Declaration:</em>  <em>( Modified )</em><br />
     …<br />
     <em>InterfaceDeclaration</em><br />
     <em>TypeAliasDeclaration</em><br />
     <em>EnumDeclaration</em></p>
  <p>  <em>VariableDeclaration:</em>  <em>( Modified )</em><br />
     <em>SimpleVariableDeclaration</em><br />
     <em>DestructuringVariableDeclaration</em></p>
  <p>  <em>SimpleVariableDeclaration:</em><br />
     <em>BindingIdentifier</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer<sub>opt</sub></em></p>
  <p>  <em>DestructuringVariableDeclaration:</em><br />
     <em>BindingPattern</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer</em></p>
  <p>  <em>LexicalBinding:</em>  <em>( Modified )</em><br />
     <em>SimpleLexicalBinding</em><br />
     <em>DestructuringLexicalBinding</em></p>
  <p>  <em>SimpleLexicalBinding:</em><br />
     <em>BindingIdentifier</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer<sub>opt</sub></em></p>
  <p>  <em>DestructuringLexicalBinding:</em><br />
     <em>BindingPattern</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer<sub>opt</sub></em></p>
  </section><h2 id="functions-a4" title="A.4"> Functions</h2><section id="user-content-a.4"><p>  <em>FunctionDeclaration:</em>  <em>( Modified )</em><br />
     <code>function</code> <em>BindingIdentifier<sub>opt</sub></em> <em>CallSignature</em> <code>{</code> <em>FunctionBody</em> <code>}</code><br />
     <code>function</code> <em>BindingIdentifier<sub>opt</sub></em> <em>CallSignature</em> <code>;</code></p>
  </section><h2 id="interfaces-a5" title="A.5"> Interfaces</h2><section id="user-content-a.5"><p>  <em>InterfaceDeclaration:</em><br />
     <code>interface</code> <em>BindingIdentifier</em> <em>TypeParameters<sub>opt</sub></em> <em>InterfaceExtendsClause<sub>opt</sub></em> <em>ObjectType</em></p>
  <p>  <em>InterfaceExtendsClause:</em><br />
     <code>extends</code> <em>ClassOrInterfaceTypeList</em></p>
  <p>  <em>ClassOrInterfaceTypeList:</em><br />
     <em>ClassOrInterfaceType</em><br />
     <em>ClassOrInterfaceTypeList</em> <code>,</code> <em>ClassOrInterfaceType</em></p>
  <p>  <em>ClassOrInterfaceType:</em><br />
     <em>TypeReference</em></p>
  </section><h2 id="classes-a6" title="A.6"> Classes</h2><section id="user-content-a.6"><p>  <em>ClassDeclaration:</em>  <em>( Modified )</em><br />
     <code>class</code> <em>BindingIdentifier<sub>opt</sub></em> <em>TypeParameters<sub>opt</sub></em> <em>ClassHeritage</em> <code>{</code> <em>ClassBody</em> <code>}</code></p>
  <p>  <em>ClassHeritage:</em>  <em>( Modified )</em><br />
     <em>ClassExtendsClause<sub>opt</sub></em> <em>ImplementsClause<sub>opt</sub></em></p>
  <p>  <em>ClassExtendsClause:</em><br />
     <code>extends</code>  <em>ClassType</em></p>
  <p>  <em>ClassType:</em><br />
     <em>TypeReference</em></p>
  <p>  <em>ImplementsClause:</em><br />
     <code>implements</code> <em>ClassOrInterfaceTypeList</em></p>
  <p>  <em>ClassElement:</em>  <em>( Modified )</em><br />
     <em>ConstructorDeclaration</em><br />
     <em>PropertyMemberDeclaration</em><br />
     <em>IndexMemberDeclaration</em></p>
  <p>  <em>ConstructorDeclaration:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>constructor</code> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <code>{</code> <em>FunctionBody</em> <code>}</code><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>constructor</code> <code>(</code> <em>ParameterList<sub>opt</sub></em> <code>)</code> <code>;</code></p>
  <p>  <em>PropertyMemberDeclaration:</em><br />
     <em>MemberVariableDeclaration</em><br />
     <em>MemberFunctionDeclaration</em><br />
     <em>MemberAccessorDeclaration</em></p>
  <p>  <em>MemberVariableDeclaration:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>PropertyName</em> <em>TypeAnnotation<sub>opt</sub></em> <em>Initializer<sub>opt</sub></em> <code>;</code></p>
  <p>  <em>MemberFunctionDeclaration:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>PropertyName</em> <em>CallSignature</em> <code>{</code> <em>FunctionBody</em> <code>}</code><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>PropertyName</em> <em>CallSignature</em> <code>;</code></p>
  <p>  <em>MemberAccessorDeclaration:</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>GetAccessor</em><br />
     <em>AccessibilityModifier<sub>opt</sub></em> <code>static</code><em><sub>opt</sub></em> <em>SetAccessor</em></p>
  <p>  <em>IndexMemberDeclaration:</em><br />
     <em>IndexSignature</em> <code>;</code></p>
  </section><h2 id="enums-a7" title="A.7"> Enums</h2><section id="user-content-a.7"><p>  <em>EnumDeclaration:</em><br />
     <code>const</code><em><sub>opt</sub></em> <code>enum</code> <em>BindingIdentifier</em> <code>{</code> <em>EnumBody<sub>opt</sub></em> <code>}</code></p>
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
  </section><h2 id="namespaces-a8" title="A.8"> Namespaces</h2><section id="user-content-a.8"><p>  <em>NamespaceDeclaration:</em><br />
     <code>namespace</code> <em>IdentifierPath</em> <code>{</code> <em>NamespaceBody</em> <code>}</code></p>
  <p>  <em>IdentifierPath:</em><br />
     <em>BindingIdentifier</em><br />
     <em>IdentifierPath</em> <code>.</code> <em>BindingIdentifier</em></p>
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
  <p>  <em>ImportAliasDeclaration:</em><br />
     <code>import</code> <em>BindingIdentifier</em> <code>=</code> <em>EntityName</em> <code>;</code></p>
  <p>  <em>EntityName:</em><br />
     <em>NamespaceName</em><br />
     <em>NamespaceName</em> <code>.</code> <em>IdentifierReference</em></p>
  </section><h2 id="scripts-and-modules-a9" title="A.9"> Scripts and Modules</h2><section id="user-content-a.9"><p>  <em>SourceFile:</em><br />
     <em>ImplementationSourceFile</em><br />
     <em>DeclarationSourceFile</em></p>
  <p>  <em>ImplementationSourceFile:</em><br />
     <em>ImplementationScript</em><br />
     <em>ImplementationModule</em></p>
  <p>  <em>DeclarationSourceFile:</em><br />
     <em>DeclarationScript</em><br />
     <em>DeclarationModule</em></p>
  <p>  <em>ImplementationScript:</em><br />
     <em>ImplementationScriptElements<sub>opt</sub></em></p>
  <p>  <em>ImplementationScriptElements:</em><br />
     <em>ImplementationScriptElement</em><br />
     <em>ImplementationScriptElements</em> <em>ImplementationScriptElement</em></p>
  <p>  <em>ImplementationScriptElement:</em><br />
     <em>ImplementationElement</em><br />
     <em>AmbientModuleDeclaration</em></p>
  <p>  <em>ImplementationElement:</em><br />
     <em>Statement</em><br />
     <em>LexicalDeclaration</em><br />
     <em>FunctionDeclaration</em><br />
     <em>GeneratorDeclaration</em><br />
     <em>ClassDeclaration</em><br />
     <em>InterfaceDeclaration</em><br />
     <em>TypeAliasDeclaration</em><br />
     <em>EnumDeclaration</em><br />
     <em>NamespaceDeclaration</em><br />
     <em>AmbientDeclaration</em><br />
     <em>ImportAliasDeclaration</em></p>
  <p>  <em>DeclarationScript:</em><br />
     <em>DeclarationScriptElements<sub>opt</sub></em></p>
  <p>  <em>DeclarationScriptElements:</em><br />
     <em>DeclarationScriptElement</em><br />
     <em>DeclarationScriptElements</em> <em>DeclarationScriptElement</em></p>
  <p>  <em>DeclarationScriptElement:</em><br />
     <em>DeclarationElement</em><br />
     <em>AmbientModuleDeclaration</em></p>
  <p>  <em>DeclarationElement:</em><br />
     <em>InterfaceDeclaration</em><br />
     <em>TypeAliasDeclaration</em><br />
     <em>NamespaceDeclaration</em><br />
     <em>AmbientDeclaration</em><br />
     <em>ImportAliasDeclaration</em></p>
  <p>  <em>ImplementationModule:</em><br />
     <em>ImplementationModuleElements<sub>opt</sub></em></p>
  <p>  <em>ImplementationModuleElements:</em><br />
     <em>ImplementationModuleElement</em><br />
     <em>ImplementationModuleElements</em> <em>ImplementationModuleElement</em></p>
  <p>  <em>ImplementationModuleElement:</em><br />
     <em>ImplementationElement</em><br />
     <em>ImportDeclaration</em><br />
     <em>ImportAliasDeclaration</em><br />
     <em>ImportRequireDeclaration</em><br />
     <em>ExportImplementationElement</em><br />
     <em>ExportDefaultImplementationElement</em><br />
     <em>ExportListDeclaration</em><br />
     <em>ExportAssignment</em></p>
  <p>  <em>DeclarationModule:</em><br />
     <em>DeclarationModuleElements<sub>opt</sub></em></p>
  <p>  <em>DeclarationModuleElements:</em><br />
     <em>DeclarationModuleElement</em><br />
     <em>DeclarationModuleElements</em> <em>DeclarationModuleElement</em></p>
  <p>  <em>DeclarationModuleElement:</em><br />
     <em>DeclarationElement</em><br />
     <em>ImportDeclaration</em><br />
     <em>ImportAliasDeclaration</em><br />
     <em>ExportDeclarationElement</em><br />
     <em>ExportDefaultDeclarationElement</em><br />
     <em>ExportListDeclaration</em><br />
     <em>ExportAssignment</em></p>
  <p>  <em>ImportRequireDeclaration:</em><br />
     <code>import</code> <em>BindingIdentifier</em> <code>=</code> <code>require</code> <code>(</code> <em>StringLiteral</em> <code>)</code> <code>;</code></p>
  <p>  <em>ExportImplementationElement:</em><br />
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
  <p>  <em>ExportDeclarationElement:</em><br />
     <code>export</code> <em>InterfaceDeclaration</em><br />
     <code>export</code> <em>TypeAliasDeclaration</em><br />
     <code>export</code> <em>AmbientDeclaration</em><br />
     <code>export</code> <em>ImportAliasDeclaration</em></p>
  <p>  <em>ExportDefaultImplementationElement:</em><br />
     <code>export</code> <code>default</code> <em>FunctionDeclaration</em><br />
     <code>export</code> <code>default</code> <em>GeneratorDeclaration</em><br />
     <code>export</code> <code>default</code> <em>ClassDeclaration</em><br />
     <code>export</code> <code>default</code> <em>AssignmentExpression</em> <code>;</code></p>
  <p>  <em>ExportDefaultDeclarationElement:</em><br />
     <code>export</code> <code>default</code> <em>AmbientFunctionDeclaration</em><br />
     <code>export</code> <code>default</code> <em>AmbientClassDeclaration</em><br />
     <code>export</code> <code>default</code> <em>IdentifierReference</em> <code>;</code></p>
  <p>  <em>ExportListDeclaration:</em><br />
     <code>export</code> <code>*</code> <em>FromClause</em> <code>;</code><br />
     <code>export</code> <em>ExportClause</em> <em>FromClause</em> <code>;</code><br />
     <code>export</code> <em>ExportClause</em> <code>;</code></p>
  <p>  <em>ExportAssignment:</em><br />
     <code>export</code> <code>=</code> <em>IdentifierReference</em> <code>;</code></p>
  </section><h2 id="ambients-a10" title="A.10"> Ambients</h2><section id="user-content-a.10"><p>  <em>AmbientDeclaration:</em><br />
     <code>declare</code> <em>AmbientVariableDeclaration</em><br />
     <code>declare</code> <em>AmbientFunctionDeclaration</em><br />
     <code>declare</code> <em>AmbientClassDeclaration</em><br />
     <code>declare</code> <em>AmbientEnumDeclaration</em><br />
     <code>declare</code> <em>AmbientNamespaceDeclaration</em></p>
  <p>  <em>AmbientVariableDeclaration:</em><br />
     <code>var</code> <em>AmbientBindingList</em> <code>;</code><br />
     <code>let</code> <em>AmbientBindingList</em> <code>;</code><br />
     <code>const</code> <em>AmbientBindingList</em> <code>;</code></p>
  <p>  <em>AmbientBindingList:</em><br />
     <em>AmbientBinding</em><br />
     <em>AmbientBindingList</em> <code>,</code> <em>AmbientBinding</em></p>
  <p>  <em>AmbientBinding:</em><br />
     <em>BindingIdentifier</em> <em>TypeAnnotation<sub>opt</sub></em></p>
  <p>  <em>AmbientFunctionDeclaration:</em><br />
     <code>function</code> <em>BindingIdentifier</em> <em>CallSignature</em> <code>;</code></p>
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
  <p>  <em>AmbientEnumDeclaration:</em><br />
     <em>EnumDeclaration</em></p>
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
  <p>  <em>AmbientModuleDeclaration:</em><br />
     <code>declare</code> <code>module</code> <em>StringLiteral</em> <code>{</code>  <em>DeclarationModule</em> <code>}</code></p>
  </section></section>