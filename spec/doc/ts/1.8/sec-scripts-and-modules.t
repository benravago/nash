<section id="sec-scripts-and-modules"><h1 id="scripts-and-modules-11" title="11"> Scripts and Modules</h1><section id="user-content-11"><p>TypeScript implements support for ECMAScript 2015 modules and supports down-level code generation targeting CommonJS, AMD, and other module systems.</p>
  </section><h2 id="programs-and-source-files-111" title="11.1"> Programs and Source Files</h2><section id="user-content-11.1"><p>A TypeScript <em><strong>program</strong></em> consists of one or more source files.</p>
  <p>  <em>SourceFile:</em><br />
     <em>ImplementationSourceFile</em><br />
     <em>DeclarationSourceFile</em></p>
  <p>  <em>ImplementationSourceFile:</em><br />
     <em>ImplementationScript</em><br />
     <em>ImplementationModule</em></p>
  <p>  <em>DeclarationSourceFile:</em><br />
     <em>DeclarationScript</em><br />
     <em>DeclarationModule</em></p>
  <p>Source files with extension '.ts' are <em><strong>implementation source files</strong></em> containing statements and declarations, and source files with extension '.d.ts' are <em><strong>declaration source files</strong></em> containing declarations only.</p>
  <p>Declaration source files are a strict subset of implementation source files and are used to declare the static type information associated with existing JavaScript code in an adjunct manner. They are entirely optional but enable the TypeScript compiler and tools to provide better verification and assistance when integrating existing JavaScript code and libraries in a TypeScript application.</p>
  <p>When a TypeScript program is compiled, all of the program's source files are processed together. Statements and declarations in different source files can depend on each other, possibly in a circular fashion. By default, a JavaScript output file is generated for each implementation source file in a compilation, but no output is generated from declaration source files.</p>
  </section><h3 id="source-files-dependencies-1111" title="11.1.1"> Source Files Dependencies</h3><section id="user-content-11.1.1"><p>The TypeScript compiler automatically determines a source file's dependencies and includes those dependencies in the program being compiled. The determination is made from "reference comments" and module import declarations as follows:</p>
  </section><ul><section id="user-content-11.1.1"><li>A comment of the form /// &lt;reference path="…"/&gt; that occurs before the first token in a source file adds a dependency on the source file specified in the path argument. The path is resolved relative to the directory of the containing source file.</li>
  </section><li>A module import declaration that specifies a relative module name (section <a href="#module-names-1131">11.3.1</a>) resolves the name relative to the directory of the containing source file. If a source file with the resulting path and file extension '.ts' exists, that file is added as a dependency. Otherwise, if a source file with the resulting path and file extension '.d.ts' exists, that file is added as a dependency.</li>
  <li>A module import declaration that specifies a top-level module name (section <a href="#module-names-1131">11.3.1</a>) resolves the name in a host dependent manner (typically by resolving the name relative to a module name space root or searching for the name in a series of directories). If a source file with extension '.ts' or '.d.ts' corresponding to the reference is located, that file is added as a dependency.</li>
  </ul>
  <p>Any files included as dependencies in turn have their references analyzed in a transitive manner until all dependencies have been determined.</p>
  <h2 id="scripts-112" title="11.2"> Scripts</h2><section id="user-content-11.2"><p>Source files that contain no module import or export declarations are classified as <em><strong>scripts</strong></em>. Scripts form the single <em><strong>global namespace</strong></em> and entities declared in scripts are in scope everywhere in a program.</p>
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
  <p>The initialization order of the scripts that make up the global namespace ultimately depends on the order in which the generated JavaScript files are loaded at run-time (which, for example, may be controlled by &lt;script/&gt; tags that reference the generated JavaScript files).</p>
  </section><h2 id="modules-113" title="11.3"> Modules</h2><section id="user-content-11.3"><p>Source files that contain at least one module import or export declaration are considered separate <em><strong>modules</strong></em>. Non-exported entities declared in a module are in scope only in that module, but exported entities can be imported into other modules using import declarations.</p>
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
  <p>Initialization order of modules is determined by the module loader being used and is not specified by the TypeScript language. However, it is generally the case that non-circularly dependent modules are automatically loaded and initialized in the correct order.</p>
  </section><p><section id="user-content-11.3"><em>AmbientModuleDeclarations</em> in declaration scripts that directly specify the module names as string literals. This is described further in section </section><a href="sec-ambients#ambient-module-declarations-122">12.2</a>.</p>
  <p>Below is an example of two modules written in separate source files:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-c">// -------- main.ts --------  </span>
  <span class="pl-k">import</span> <span class="pl-kos">{</span> <span class="pl-s1">message</span> <span class="pl-kos">}</span> <span class="pl-k">from</span> <span class="pl-s">"./log"</span><span class="pl-kos">;</span>  
  <span class="pl-en">message</span><span class="pl-kos">(</span><span class="pl-s">"hello"</span><span class="pl-kos">)</span><span class="pl-kos">;</span>
  
  <span class="pl-c">// -------- log.ts --------  </span>
  <span class="pl-k">export</span> <span class="pl-k">function</span> <span class="pl-en">message</span><span class="pl-kos">(</span><span class="pl-s1">s</span>: <span class="pl-smi">string</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-smi">console</span><span class="pl-kos">.</span><span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-s1">s</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The import declaration in the 'main' module references the 'log' module and compiling the 'main.ts' file causes the 'log.ts' file to also be compiled as part of the program.</p>
  <p>TypeScript supports multiple patterns of JavaScript code generation for modules:</p>
  <ul>
  <li>CommonJS. This format is used by server frameworks such as node.js.</li>
  <li>AMD (Asynchronous Module Definition). This format is used by asynchronous module loaders such as RequireJS.</li>
  <li>UMD (Universal Module Definition). A variation of the AMD format that allows modules to also be loaded by CommonJS loaders.</li>
  <li>System. This format is used to represent ECMAScript 2015 semantics with high fidelity in down-level environments.</li>
  </ul>
  <p>The desired module code generation pattern is selected through a compiler option and does not affect the TypeScript source code. Indeed, it is possible to author modules that can be compiled for use both on the server side (e.g. using node.js) and on the client side (using an AMD compliant loader) with no changes to the TypeScript source code.</p>
  <h3 id="module-names-1131" title="11.3.1"> Module Names</h3>
  <p>Modules are identified and referenced using module names. The following definition is aligned with that provided in the <a href="http://www.commonjs.org/specs/modules/1.0/" rel="nofollow">CommonJS Modules</a> 1.0 specification.</p>
  <ul>
  <li>A module name is a string of terms delimited by forward slashes.</li>
  <li>Module names may not have file-name extensions like ".js".</li>
  <li>Module names may be relative or top-level. A module name is relative if the first term is "." or "..".</li>
  <li>Top-level names are resolved off the conceptual module name space root.</li>
  <li>Relative names are resolved relative to the name of the module in which they occur.</li>
  </ul>
  <p>For purposes of resolving module references, TypeScript associates a file path with every module. The file path is simply the path of the module's source file without the file extension. For example, a module contained in the source file 'C:\src\lib\io.ts' has the file path 'C:/src/lib/io' and a module contained in the source file 'C:\src\ui\editor.d.ts' has the file path 'C:/src/ui/editor'.</p>
  <p>A module name in an import declaration is resolved as follows:</p>
  <ul>
  <li>If the import declaration specifies a relative module name, the name is resolved relative to the directory of the referencing module's file path. The program must contain a module with the resulting file path or otherwise an error occurs. For example, in a module with the file path 'C:/src/ui/main', the module names './editor' and '../lib/io' reference modules with the file paths 'C:/src/ui/editor' and 'C:/src/lib/io'.</li>
  <li>If the import declaration specifies a top-level module name and the program contains an <em>AmbientModuleDeclaration</em> (section <a href="sec-ambients#ambient-module-declarations-122">12.2</a>) with a string literal that specifies that exact name, then the import declaration references that ambient module.</li>
  <li>If the import declaration specifies a top-level module name and the program contains no <em>AmbientModuleDeclaration</em> (section <a href="sec-ambients#ambient-module-declarations-122">12.2</a>) with a string literal that specifies that exact name, the name is resolved in a host dependent manner (for example by considering the name relative to a module name space root). If a matching module cannot be found an error occurs.</li>
  </ul>
  <h3 id="import-declarations-1132" title="11.3.2"> Import Declarations</h3><section id="user-content-11.3.2"><p>Import declarations are used to import entities from other modules and provide bindings for them in the current module.</p>
  <p>An import declaration of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-c1">*</span> <span class="pl-k">as</span> <span class="pl-s1">m</span> <span class="pl-k">from</span> <span class="pl-s">"mod"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>imports the module with the given name and creates a local binding for the module itself. The local binding is classified as a value (representing the module instance) and a namespace (representing a container of types and namespaces).</p>
  <p>An import declaration of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-kos">{</span> <span class="pl-s1">x</span><span class="pl-kos">,</span> <span class="pl-s1">y</span><span class="pl-kos">,</span> <span class="pl-s1">z</span> <span class="pl-kos">}</span> <span class="pl-k">from</span> <span class="pl-s">"mod"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  </section><p>imports a given module and creates local bindings for a specified list of exported members of the module. The specified names must each reference an entity in the export member set (<a href="#export-member-set-11344">11.3.4.4</a>) of the given module. The local bindings have the same names and classifications as the entities they represent unless <code>as</code> clauses are used to that specify different local names:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-kos">{</span> <span class="pl-s1">x</span> <span class="pl-k">as</span> <span class="pl-s1">a</span><span class="pl-kos">,</span> <span class="pl-s1">y</span> <span class="pl-k">as</span> <span class="pl-s1">b</span> <span class="pl-kos">}</span> <span class="pl-k">from</span> <span class="pl-s">"mod"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>An import declaration of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-s1">d</span> <span class="pl-k">from</span> <span class="pl-s">"mod"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is exactly equivalent to the import declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-kos">{</span> <span class="pl-s1">default</span> <span class="pl-k">as</span> <span class="pl-s1">d</span> <span class="pl-kos">}</span> <span class="pl-k">from</span> <span class="pl-s">"mod"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>An import declaration of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-s">"mod"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>imports the given module without creating any local bindings (this is useful only if the imported module has side effects).</p>
  <h3 id="import-require-declarations-1133" title="11.3.3"> Import Require Declarations</h3><section id="user-content-11.3.3"><p>Import require declarations exist for backward compatibility with earlier versions of TypeScript.</p>
  <p>  <em>ImportRequireDeclaration:</em><br />
     <code>import</code> <em>BindingIdentifier</em> <code>=</code> <code>require</code> <code>(</code> <em>StringLiteral</em> <code>)</code> <code>;</code></p>
  </section><p>An import require declaration introduces a local identifier that references a given module. The string literal specified in an import require declaration is interpreted as a module name (section <a href="#module-names-1131">11.3.1</a>). The local identifier introduced by the declaration becomes an alias for, and is classified exactly like, the entity exported from the referenced module. Specifically, if the referenced module contains no export assignment the identifier is classified as a value and a namespace, and if the referenced module contains an export assignment the identifier is classified exactly like the entity named in the export assignment.</p>
  <p>An import require declaration of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-s1">m</span> <span class="pl-c1">=</span> require<span class="pl-kos">(</span><span class="pl-s">"mod"</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>is equivalent to the ECMAScript 2015 import declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-c1">*</span> <span class="pl-k">as</span> <span class="pl-s1">m</span> <span class="pl-k">from</span> <span class="pl-s">"mod"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>provided the referenced module contains no export assignment.</p>
  <h3 id="export-declarations-1134" title="11.3.4"> Export Declarations</h3>
  <p>An export declaration declares one or more exported module members. The exported members of a module can be imported in other modules using import declarations (<a href="#import-declarations-1132">11.3.2</a>).</p>
  <h4 id="export-modifiers-11341" title="11.3.4.1"> Export Modifiers</h4><section id="user-content-11.3.4.1"><p>In the body of a module, a declaration can export the declared entity by including an <code>export</code> modifier.</p>
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
  <p>In addition to introducing a name in the local declaration space of the module, an exported declaration introduces the same name with the same classification in the module's export declaration space. For example, the declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">export</span> <span class="pl-k">function</span> <span class="pl-en">point</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-kos">{</span> x<span class="pl-kos">,</span> y <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>introduces a local name <code>point</code> and an exported name <code>point</code> that both reference the function.</p>
  </section><h4 id="export-default-declarations-11342" title="11.3.4.2"> Export Default Declarations</h4><section id="user-content-11.3.4.2"><p>Export default declarations provide short-hand syntax for exporting an entity named <code>default</code>.</p>
  <p>  <em>ExportDefaultImplementationElement:</em><br />
     <code>export</code> <code>default</code> <em>FunctionDeclaration</em><br />
     <code>export</code> <code>default</code> <em>GeneratorDeclaration</em><br />
     <code>export</code> <code>default</code> <em>ClassDeclaration</em><br />
     <code>export</code> <code>default</code> <em>AssignmentExpression</em> <code>;</code></p>
  <p>  <em>ExportDefaultDeclarationElement:</em><br />
     <code>export</code> <code>default</code> <em>AmbientFunctionDeclaration</em><br />
     <code>export</code> <code>default</code> <em>AmbientClassDeclaration</em><br />
     <code>export</code> <code>default</code> <em>IdentifierReference</em> <code>;</code></p>
  <p>An <em>ExportDefaultImplementationElement</em> or <em>ExportDefaultDeclarationElement</em> for a function, generator, or class introduces a value named <code>default</code>, and in the case of a class, a type named <code>default</code>, in the containing module's export declaration space. The declaration may optionally specify a local name for the exported function, generator, or class. For example, the declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">export</span> <span class="pl-k">default</span> <span class="pl-k">function</span> <span class="pl-en">point</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-kos">{</span> x<span class="pl-kos">,</span> y <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>introduces a local name <code>point</code> and an exported name <code>default</code> that both reference the function. The declaration is effectively equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">point</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-kos">{</span> x<span class="pl-kos">,</span> y <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">export</span> <span class="pl-k">default</span> <span class="pl-s1">point</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>which again is equivalent to</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">point</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-kos">{</span> x<span class="pl-kos">,</span> y <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">export</span> <span class="pl-kos">{</span> <span class="pl-s1">point</span> <span class="pl-k">as</span> <span class="pl-s1">default</span> <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>An <em>ExportDefaultImplementationElement</em> or <em>ExportDefaultDeclarationElement</em> for an expression consisting of a single identifier must name an entity declared in the current module or the global namespace. The declaration introduces an entity named <code>default</code>, with the same classification as the referenced entity, in the containing module's export declaration space. For example, the declarations</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">interface</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
      <span class="pl-c1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">function</span> <span class="pl-smi">Point</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-kos">{</span> x<span class="pl-kos">,</span> y <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>
  
  <span class="pl-k">export</span> <span class="pl-k">default</span> <span class="pl-smi">Point</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>introduce a local name <code>Point</code> and an exported name <code>default</code>, both with a value and a type meaning.</p>
  <p>An <em>ExportDefaultImplementationElement</em> for any expression but a single identifier introduces a value named <code>default</code> in the containing module's export declaration space. For example, the declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">export</span> <span class="pl-k">default</span> <span class="pl-s">"hello"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>introduces an exported value named <code>default</code> of type string.</p>
  </section><h4 id="export-list-declarations-11343" title="11.3.4.3"> Export List Declarations</h4><section id="user-content-11.3.4.3"><p>An export list declaration exports one or more entities from the current module or a specified module.</p>
  <p>  <em>ExportListDeclaration:</em><br />
     <code>export</code> <code>*</code> <em>FromClause</em> <code>;</code><br />
     <code>export</code> <em>ExportClause</em> <em>FromClause</em> <code>;</code><br />
     <code>export</code> <em>ExportClause</em> <code>;</code></p>
  <p>An <em>ExportListDeclaration</em> without a <em>FromClause</em> exports entities from the current module. In a declaration of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">export</span> <span class="pl-kos">{</span> <span class="pl-s1">x</span> <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the name <code>x</code> must reference an entity declared in the current module or the global namespace, and the declaration introduces an entity with the same name and meaning in the containing module's export declaration space.</p>
  <p>An <em>ExportListDeclaration</em> with a <em>FromClause</em> re-exports entities from a specified module. In a declaration of the form</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">export</span> <span class="pl-kos">{</span> <span class="pl-s1">x</span> <span class="pl-kos">}</span> <span class="pl-k">from</span> <span class="pl-s">"mod"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the name <code>x</code> must reference an entity in the export member set of the specified module, and the declaration introduces an entity with the same name and meaning in the containing module's export declaration space. No local bindings are created for <code>x</code>.</p>
  <p>The <em>ExportClause</em> of an <em>ExportListDeclaration</em> can specify multiple entities and may optionally specify different names to be used for the exported entities. For example, the declaration</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">export</span> <span class="pl-kos">{</span> <span class="pl-s1">x</span><span class="pl-kos">,</span> <span class="pl-s1">y</span> <span class="pl-k">as</span> <span class="pl-s1">b</span><span class="pl-kos">,</span> <span class="pl-s1">z</span> <span class="pl-k">as</span> <span class="pl-s1">c</span> <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>introduces entities named <code>x</code>, <code>b</code>, and <code>c</code> in the containing module's export declaration space with the same meaning as the local entities named <code>x</code>, <code>y</code>, and <code>z</code> respectively.</p>
  <p>An <em>ExportListDeclaration</em> that specifies <code>*</code> instead of an <em>ExportClause</em> is called an <em><strong>export star</strong></em> declaration. An export star declaration re-exports all members of a specified module.</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">export</span> <span class="pl-c1">*</span> <span class="pl-k">from</span> <span class="pl-s">"mod"</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Explicitly exported members take precedence over members re-exported using export star declarations, as described in the following section.</p>
  </section><h4 id="export-member-set-11344" title="11.3.4.4"> Export Member Set</h4><section id="user-content-11.3.4.4"><p>The <em><strong>export member set</strong></em> of a particular module is determined by starting with an empty set of members <em>E</em> and an empty set of processed modules <em>P</em>, and then processing the module as described below to form the full set of exported members in <em>E</em>. Processing a module <em>M</em> consists of these steps:</p>
  <ul>
  <li>Add <em>M</em> to <em>P</em>.</li>
  <li>Add to <em>E</em> each member in the export declaration space of <em>M</em> with a name that isn't already in <em>E</em>.</li>
  <li>For each export star declaration in <em>M</em>, in order of declaration, process the referenced module if it is not already in <em>P</em>.</li>
  </ul>
  <p>A module's <em><strong>instance type</strong></em> is an object type with a property for each member in the module's export member set that denotes a value.</p>
  <p>If a module contains an export assignment it is an error for the module to also contain export declarations. The two types of exports are mutually exclusive.</p>
  </section><h3 id="export-assignments-1135" title="11.3.5"> Export Assignments</h3><section id="user-content-11.3.5"><p>Export assignments exist for backward compatibility with earlier versions of TypeScript. An export assignment designates a module member as the entity to be exported in place of the module itself.</p>
  <p>  <em>ExportAssignment:</em><br />
     <code>export</code> <code>=</code> <em>IdentifierReference</em> <code>;</code></p>
  </section><p>A module containing an export assignment can be imported using an import require declaration (<a href="#import-require-declarations-1133">11.3.3</a>), and the local alias introduced by the import require declaration then takes on all meanings of the identifier named in the export assignment.</p>
  <p>A module containing an export assignment can also be imported using a regular import declaration (<a href="#import-declarations-1132">11.3.2</a>) provided the entity referenced in the export assignment is declared as a namespace or as a variable with a type annotation.</p>
  <p>Assume the following example resides in the file 'point.ts':</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">export</span> <span class="pl-c1">=</span> <span class="pl-smi">Point</span><span class="pl-kos">;</span>
  
  <span class="pl-k">class</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-en">constructor</span><span class="pl-kos">(</span><span class="pl-k">public</span> <span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-k">public</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span> <span class="pl-kos">{</span> <span class="pl-kos">}</span>  
      <span class="pl-k">static</span> <span class="pl-c1">origin</span> <span class="pl-c1">=</span> <span class="pl-k">new</span> <span class="pl-smi">Point</span><span class="pl-kos">(</span><span class="pl-c1">0</span><span class="pl-kos">,</span> <span class="pl-c1">0</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>When 'point.ts' is imported in another module, the import alias references the exported class and can be used both as a type and as a constructor function:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-smi">Pt</span> <span class="pl-c1">=</span> require<span class="pl-kos">(</span><span class="pl-s">"./point"</span><span class="pl-kos">)</span><span class="pl-kos">;</span>
  
  <span class="pl-k">var</span> <span class="pl-s1">p1</span> <span class="pl-c1">=</span> <span class="pl-k">new</span> <span class="pl-smi">Pt</span><span class="pl-kos">(</span><span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-c1">20</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">p2</span> <span class="pl-c1">=</span> <span class="pl-smi">Pt</span><span class="pl-kos">.</span><span class="pl-c1">origin</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Note that there is no requirement that the import alias use the same name as the exported entity.</p>
  <h3 id="commonjs-modules-1136" title="11.3.6"> CommonJS Modules</h3>
  <p>The <a href="http://www.commonjs.org/specs/modules/1.0/" rel="nofollow">CommonJS Modules</a> definition specifies a methodology for writing JavaScript modules with implied privacy, the ability to import other modules, and the ability to explicitly export members. A CommonJS compliant system provides a 'require' function that can be used to synchronously load other modules to obtain their singleton module instance, as well as an 'exports' variable to which a module can add properties to define its external API.</p>
  <p>The 'main' and 'log' example from section <a href="#modules-113">11.3</a> above generates the following JavaScript code when compiled for the CommonJS Modules pattern:</p>
  <p>File main.js:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">log_1</span> <span class="pl-c1">=</span> <span class="pl-en">require</span><span class="pl-kos">(</span><span class="pl-s">"./log"</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-s1">log_1</span><span class="pl-kos">.</span><span class="pl-en">message</span><span class="pl-kos">(</span><span class="pl-s">"hello"</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>File log.js:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">function</span> <span class="pl-en">message</span><span class="pl-kos">(</span><span class="pl-s1">s</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-smi">console</span><span class="pl-kos">.</span><span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-s1">s</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span>  
  <span class="pl-s1">exports</span><span class="pl-kos">.</span><span class="pl-c1">message</span> <span class="pl-c1">=</span> <span class="pl-s1">message</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>A module import declaration is represented in the generated JavaScript as a variable initialized by a call to the 'require' function provided by the module system host. A variable declaration and 'require' call is emitted for a particular imported module only if the imported module, or a local alias (section <a href="sec-namespaces#import-alias-declarations-103">10.3</a>) that references the imported module, is referenced as a <em>PrimaryExpression</em> somewhere in the body of the importing module. If an imported module is referenced only as a <em>NamespaceName</em> or <em>TypeQueryExpression</em>, nothing is emitted.</p>
  <p>An example:</p>
  <p>File geometry.ts:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">export</span> <span class="pl-k">interface</span> <span class="pl-smi">Point</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">;</span> <span class="pl-c1">y</span>: <span class="pl-smi">number</span> <span class="pl-kos">}</span><span class="pl-kos">;</span>
  
  <span class="pl-k">export</span> <span class="pl-k">function</span> <span class="pl-en">point</span><span class="pl-kos">(</span><span class="pl-s1">x</span>: <span class="pl-smi">number</span><span class="pl-kos">,</span> <span class="pl-s1">y</span>: <span class="pl-smi">number</span><span class="pl-kos">)</span>: <span class="pl-smi">Point</span> <span class="pl-kos">{</span>  
      <span class="pl-k">return</span> <span class="pl-kos">{</span> x<span class="pl-kos">,</span> y <span class="pl-kos">}</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>File game.ts:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-c1">*</span> <span class="pl-k">as</span> <span class="pl-s1">g</span> <span class="pl-k">from</span> <span class="pl-s">"./geometry"</span><span class="pl-kos">;</span>  
  <span class="pl-k">let</span> <span class="pl-s1">p</span> <span class="pl-c1">=</span> <span class="pl-s1">g</span><span class="pl-kos">.</span><span class="pl-en">point</span><span class="pl-kos">(</span><span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-c1">20</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The 'game' module references the imported 'geometry' module in an expression (through its alias 'g') and a 'require' call is therefore included in the emitted JavaScript:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">g</span> <span class="pl-c1">=</span> <span class="pl-en">require</span><span class="pl-kos">(</span><span class="pl-s">"./geometry"</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-k">var</span> <span class="pl-s1">p</span> <span class="pl-c1">=</span> <span class="pl-s1">g</span><span class="pl-kos">.</span><span class="pl-en">point</span><span class="pl-kos">(</span><span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-c1">20</span><span class="pl-kos">)</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>Had the 'game' module instead been written to only reference 'geometry' in a type position</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">import</span> <span class="pl-c1">*</span> <span class="pl-k">as</span> <span class="pl-s1">g</span> <span class="pl-k">from</span> <span class="pl-s">"./geometry"</span><span class="pl-kos">;</span>  
  <span class="pl-k">let</span> <span class="pl-s1">p</span>: <span class="pl-s1">g</span><span class="pl-kos">.</span><span class="pl-smi">Point</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-c1">20</span> <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>the emitted JavaScript would have no dependency on the 'geometry' module and would simply be</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-k">var</span> <span class="pl-s1">p</span> <span class="pl-c1">=</span> <span class="pl-kos">{</span> <span class="pl-c1">x</span>: <span class="pl-c1">10</span><span class="pl-kos">,</span> <span class="pl-c1">y</span>: <span class="pl-c1">20</span> <span class="pl-kos">}</span><span class="pl-kos">;</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <h3 id="amd-modules-1137" title="11.3.7"> AMD Modules</h3>
  <p>The <a href="https://github.com/amdjs/amdjs-api/wiki/AMD">Asynchronous Module Definition</a> (AMD) specification extends the CommonJS Modules specification with a pattern for authoring asynchronously loadable modules with associated dependencies. Using the AMD pattern, modules are emitted as calls to a global 'define' function taking an array of dependencies, specified as module names, and a callback function containing the module body. The global 'define' function is provided by including an AMD compliant loader in the application. The loader arranges to asynchronously load the module's dependencies and, upon completion, calls the callback function passing resolved module instances as arguments in the order they were listed in the dependency array.</p>
  <p>The "main" and "log" example from above generates the following JavaScript code when compiled for the AMD pattern.</p>
  <p>File main.js:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">define</span><span class="pl-kos">(</span><span class="pl-kos">[</span><span class="pl-s">"require"</span><span class="pl-kos">,</span> <span class="pl-s">"exports"</span><span class="pl-kos">,</span> <span class="pl-s">"./log"</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-k">function</span><span class="pl-kos">(</span><span class="pl-s1">require</span><span class="pl-kos">,</span> <span class="pl-s1">exports</span><span class="pl-kos">,</span> <span class="pl-s1">log_1</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-s1">log_1</span><span class="pl-kos">.</span><span class="pl-en">message</span><span class="pl-kos">(</span><span class="pl-s">"hello"</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>File log.js:</p>
  <div class="highlight highlight-source-ts position-relative overflow-auto"><pre><span class="pl-s1">define</span><span class="pl-kos">(</span><span class="pl-kos">[</span><span class="pl-s">"require"</span><span class="pl-kos">,</span> <span class="pl-s">"exports"</span><span class="pl-kos">]</span><span class="pl-kos">,</span> <span class="pl-k">function</span><span class="pl-kos">(</span><span class="pl-s1">require</span><span class="pl-kos">,</span> <span class="pl-s1">exports</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
      <span class="pl-k">function</span> <span class="pl-en">message</span><span class="pl-kos">(</span><span class="pl-s1">s</span><span class="pl-kos">)</span> <span class="pl-kos">{</span>  
          <span class="pl-smi">console</span><span class="pl-kos">.</span><span class="pl-en">log</span><span class="pl-kos">(</span><span class="pl-s1">s</span><span class="pl-kos">)</span><span class="pl-kos">;</span>  
      <span class="pl-kos">}</span>  
      <span class="pl-s1">exports</span><span class="pl-kos">.</span><span class="pl-c1">message</span> <span class="pl-c1">=</span> <span class="pl-s1">message</span><span class="pl-kos">;</span>  
  <span class="pl-kos">}</span></pre><div class="zeroclipboard-container position-absolute right-0 top-0">
      
    </div></div>
  <p>The special 'require' and 'exports' dependencies are always present. Additional entries are added to the dependencies array and the parameter list as required to represent imported modules. Similar to the code generation for CommonJS Modules, a dependency entry is generated for a particular imported module only if the imported module is referenced as a <em>PrimaryExpression</em> somewhere in the body of the importing module. If an imported module is referenced only as a <em>NamespaceName</em>, no dependency is generated for that module.</p>
  <br />
  </section>