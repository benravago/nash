<section id="sec-overview">
  <div class="front">
    <h1 id="sec-4" title="4"> Overview</h1><p>This section contains a non-normative overview of the ECMAScript language.</p>

    <p>ECMAScript is an object-oriented programming language for performing computations and manipulating computational objects
    within a host environment. ECMAScript as defined here is not intended to be computationally self-sufficient; indeed, there are
    no provisions in this specification for input of external data or output of computed results. Instead, it is expected that the
    computational environment of an ECMAScript program will provide not only the objects and other facilities described in this
    specification but also certain environment-specific objects, whose description and behaviour are beyond the scope of this
    specification except to indicate that they may provide certain properties that can be accessed and certain functions that can
    be called from an ECMAScript program.</p>

    <p>ECMAScript was originally designed to be used as a scripting language, but has become widely used as a general purpose
    programming language. A <b><i>scripting language</i></b> is a programming language that is used to manipulate, customize, and
    automate the facilities of an existing system. In such systems, useful functionality is already available through a user
    interface, and the scripting language is a mechanism for exposing that functionality to program control. In this way, the
    existing system is said to provide a host environment of objects and facilities, which completes the capabilities of the
    scripting language. A scripting language is intended for use by both professional and non-professional programmers.</p>

    <p>ECMAScript was originally designed to be a <b><i>Web scripting language</i></b>, providing a mechanism to enliven Web pages
    in browsers and to perform server computation as part of a Web-based client-server architecture. ECMAScript is now used to
    provide core scripting capabilities for a variety of host environments. Therefore the core language is specified in this
    document apart from any particular host environment.</p>

    <p>ECMAScript usage has moved beyond simple scripting and it is now used for the full spectrum of programming tasks in many
    different environments and scales. As the usage of ECMAScript has expanded, so has the features and facilities it provides.
    ECMAScript is now a fully featured general propose programming language.</p>

    <p>Some of the facilities of ECMAScript are similar to those used in other programming languages; in particular C,
    Java&trade;, Self, and Scheme as described in:</p>

    <p>ISO/IEC&nbsp;9899:1996, <i>Programming Languages &ndash; C</i>.</p>

    <p>Gosling, James, Bill Joy and Guy Steele. <i>The Java<sup>&trade;</sup> Language Specification</i>. Addison Wesley
    Publishing Co., 1996.</p>

    <p>Ungar, David, and Smith, Randall B. Self: The Power of Simplicity. <i>OOPSLA '87 Conference Proceedings</i>, pp.
    227&ndash;241, Orlando, FL, October 1987.</p>

    <p><i>IEEE Standard for the Scheme Programming Language</i>. IEEE Std 1178-1990.</p>
  </div>

  <section id="sec-web-scripting">
    <h2 id="sec-4.1" title="4.1"> Web
        Scripting</h2><p>A web browser provides an ECMAScript host environment for client-side computation including, for instance, objects that
    represent windows, menus, pop-ups, dialog boxes, text areas, anchors, frames, history, cookies, and input/output. Further, the
    host environment provides a means to attach scripting code to events such as change of focus, page and image loading,
    unloading, error and abort, selection, form submission, and mouse actions. Scripting code appears within the HTML and the
    displayed page is a combination of user interface elements and fixed and computed text and images. The scripting code is
    reactive to user interaction and there is no need for a main program.</p>

    <p>A web server provides a different host environment for server-side computation including objects representing requests,
    clients, and files; and mechanisms to lock and share data. By using browser-side and server-side scripting together, it is
    possible to distribute computation between the client and server while providing a customized user interface for a Web-based
    application.</p>

    <p>Each Web browser and server that supports ECMAScript supplies its own host environment, completing the ECMAScript execution
    environment.</p>
  </section>

  <section id="sec-ecmascript-overview">
    <div class="front">
      <h2 id="sec-4.2" title="4.2">
          ECMAScript Overview</h2><p>The following is an informal overview of ECMAScript&mdash;not all parts of the language are described. This overview is
      not part of the standard proper.</p>

      <p>ECMAScript is object-based: basic language and host facilities are provided by objects, and an ECMAScript program is a
      cluster of communicating objects. In ECMAScript, an <b><i>object</i></b> is a collection of zero or more
      <b><i>properties</i></b> each with <b><i>attributes</i></b> that determine how each property can be used&mdash;for example,
      when the Writable attribute for a property is set to <b>false</b>, any attempt by executed ECMAScript code to assign a
      different value to the property fails. Properties are containers that hold other objects, <b><i>primitive values</i></b>, or
      <b><i>functions</i></b>. A primitive value is a member of one of the following built-in types: <b>Undefined</b>,
      <b>Null</b>, <b>Boolean</b>, <b>Number</b>, <b>String,</b> and <b>Symbol;</b> an object is a member of the built-in type
      <b>Object</b>; and a function is a callable object. A function that is associated with an object via a property is called a
      <b><i>method</i></b>.</p>

      <p>ECMAScript defines a collection of <b><i>built-in objects</i></b> that round out the definition of ECMAScript entities.
      These built-in objects include the global object; objects that are fundamental to the runtime semantics of the language
      including <b>Object</b>, <b>Function</b>, <b>Boolean</b>, <b>Symbol</b>, and various <b>Error</b> objects; objects that
      represent and manipulate numeric values including <b>Math</b>, <b>Number</b>, and <b>Date</b>; the text processing objects
      <b>String</b> and <b>RegExp</b>; objects that are indexed collections of values including <b>Array</b> and nine different
      kinds of Typed Arrays whose elements all have a specific numeric data representation; keyed collections including <b>Map</b>
      and <b>Set</b> objects; objects supporting structured data including the <b>JSON</b> object, <b>ArrayBuffer</b>, and
      <b>DataView</b>; objects supporting control abstractions including generator functions and <b>Promise</b> objects;
      and<b>,</b> reflection objects including <b>Proxy</b> and <b>Reflect</b>.</p>

      <p>ECMAScript also defines a set of built-in <b><i>operators</i></b>. ECMAScript operators include various unary operations,
      multiplicative operators, additive operators, bitwise shift operators, relational operators, equality operators, binary
      bitwise operators, binary logical operators, assignment operators, and the comma operator.</p>

      <p>Large ECMAScript programs are supported by <b><i>modules</i></b> which allow a program to be divided into multiple
      sequences of statements and declarations. Each module explicitly identifies declarations it uses that need to be provided by
      other modules and which of its declarations are available for use by other modules.</p>

      <p>ECMAScript syntax intentionally resembles Java syntax. ECMAScript syntax is relaxed to enable it to serve as an
      easy-to-use scripting language. For example, a variable is not required to have its type declared nor are types associated
      with properties, and defined functions are not required to have their declarations appear textually before calls to
      them.</p>
    </div>

    <section id="sec-objects">
      <h3 id="sec-4.2.1" title="4.2.1"> Objects</h3><p>Even though ECMAScript includes syntax for class definitions, ECMAScript objects are not fundamentally class-based such
      as those in C++, Smalltalk, or Java. Instead objects may be created in various ways including via a literal notation or via
      <b><i>constructors</i></b> which create objects and then execute code that initializes all or part of them by assigning
      initial values to their properties.  Each constructor is a function that has a property named <code>"prototype"</code> that
      is used to implement <b><i>prototype-based inheritance</i></b> and <b><i>shared properties</i></b>. Objects are created by
      using constructors in <b>new</b> expressions; for example, <code>new Date(2009,11)</code> creates a new Date object.
      Invoking a constructor without using <b>new</b> has consequences that depend on the constructor. For example,
      <code>Date()</code> produces a string representation of the current date and time rather than an object.</p>

      <p>Every object created by a constructor has an implicit reference (called the object&rsquo;s <i>prototype</i>) to the value
      of its constructor&rsquo;s <code>"prototype"</code> property. Furthermore, a prototype may have a non-null implicit
      reference to its prototype, and so on; this is called the <i>prototype chain</i>. When a reference is made to a property in
      an object, that reference is to the property of that name in the first object in the prototype chain that contains a
      property of that name. In other words, first the object mentioned directly is examined for such a property; if that object
      contains the named property, that is the property to which the reference refers; if that object does not contain the named
      property, the prototype for that object is examined next; and so on.</p>

      <figure>
        <object data="figure-1.svg" height="354" type="image/svg+xml" width="719">
          <img alt="An image of lots of boxes and arrows." height="354" src="figure-1.png" width="719" />
        </object>
        <figcaption>Figure 1 &mdash; Object/Prototype Relationships</figcaption>
      </figure>

      <p>In a class-based object-oriented language, in general, state is carried by instances, methods are carried by classes, and
      inheritance is only of structure and behaviour. In ECMAScript, the state and methods are carried by objects, while
      structure, behaviour, and state are all inherited.</p>

      <p>All objects that do not directly contain a particular property that their prototype contains share that property and its
      value. Figure 1 illustrates this:</p>

      <p><b>CF</b> is a constructor (and also an object). Five objects have been created by using <code>new</code> expressions:
      <b>cf<sub>1</sub></b>, <b>cf<sub>2</sub></b>, <b>cf<sub>3</sub></b>, <b>cf<sub>4</sub></b>, and <b>cf<sub>5</sub></b>. Each
      of these objects contains properties named <code>q1</code> and <code>q2</code>. The dashed lines represent the implicit
      prototype relationship; so, for example, <b>cf<sub>3</sub></b>&rsquo;s prototype is <b>CF<sub>p</sub></b>. The constructor,
      <b>CF</b>, has two properties itself, named <code>P1</code> and <code>P2</code>, which are not visible to
      <b>CF<sub>p</sub></b>, <b>cf<sub>1</sub></b>, <b>cf<sub>2</sub></b>, <b>cf<sub>3</sub></b>, <b>cf<sub>4</sub></b>, or
      <b>cf<sub>5</sub></b>. The property named <code>CFP1</code> in <b>CF<sub>p</sub></b> is shared by <b>cf<sub>1</sub></b>,
      <b>cf<sub>2</sub></b>, <b>cf<sub>3</sub></b>, <b>cf<sub>4</sub></b>, and <b>cf<sub>5</sub></b> (but not by <b>CF</b>), as
      are any properties found in <b>CF<sub>p</sub></b>&rsquo;s implicit prototype chain that are not named <code>q1</code>,
      <code>q2</code>, or <code>CFP1</code>. Notice that there is no implicit prototype link between <b>CF</b> and
      <b>CF<sub>p</sub></b>.</p>

      <p>Unlike most class-based object languages, properties can be added to objects dynamically by assigning values to them.
      That is, constructors are not required to name or assign values to all or any of the constructed object&rsquo;s properties.
      In the above diagram, one could add a new shared property for <b>cf<sub>1</sub></b>, <b>cf<sub>2</sub></b>,
      <b>cf<sub>3</sub></b>, <b>cf<sub>4</sub></b>, and <b>cf<sub>5</sub></b> by assigning a new value to the property in
      <b>CF<sub>p</sub></b>.</p>

      <p>Although ECMAScript objects are not inherently class-based, it is often convenient to define class-like abstractions
      based upon a common pattern of constructor functions, prototype objects, and methods. The ECMAScript built-in objects
      themselves follow such a class-like pattern. Beginning with ECMAScript 2015, the ECMAScript language includes syntactic
      class definitions that permit programmers to concisely define objects that conform to the same class-like abstraction
      pattern used by the built-in objects.</p>
    </section>

    <section id="sec-strict-variant-of-ecmascript">
      <h3 id="sec-4.2.2" title="4.2.2"> The Strict Variant of ECMAScript</h3><p>The ECMAScript Language recognizes the possibility that some users of the language may wish to restrict their usage of
      some features available in the language. They might do so in the interests of security, to avoid what they consider to be
      error-prone features, to get enhanced error checking, or for other reasons of their choosing. In support of this
      possibility, ECMAScript defines a strict variant of the language. The strict variant of the language excludes some specific
      syntactic and semantic features of the regular ECMAScript language and modifies the detailed semantics of some features. The
      strict variant also specifies additional error conditions that must be reported by throwing error exceptions in situations
      that are not specified as errors by the non-strict form of the language.</p>

      <p>The strict variant of ECMAScript is commonly referred to as the <i>strict mode</i> of the language. Strict mode selection
      and use of the strict mode syntax and semantics of ECMAScript is explicitly made at the level of individual ECMAScript
      source text units. Because strict mode is selected at the level of a syntactic source text unit, strict mode only imposes
      restrictions that have local effect within such a source text unit. Strict mode does not restrict or modify any aspect of
      the ECMAScript semantics that must operate consistently across multiple source text units. A complete ECMAScript program may
      be composed of both strict mode and non-strict mode ECMAScript source text units. In this case, strict mode only applies
      when actually executing code that is defined within a strict mode source text unit.</p>

      <p>In order to conform to this specification, an ECMAScript implementation must implement both the full unrestricted
      ECMAScript language and the strict variant of the ECMAScript language as defined by this specification. In addition, an
      implementation must support the combination of unrestricted and strict mode source text units into a single composite
      program.</p>
    </section>
  </section>

  <section id="sec-terms-and-definitions">
    <div class="front">
      <h2 id="sec-4.3" title="4.3"> Terms
          and definitions</h2><p>For the purposes of this document, the following terms and definitions apply.</p>
    </div>

    <section id="sec-type">
      <h3 id="sec-4.3.1" title="4.3.1"> type</h3><p>set of data values as defined in <a href="sec-ecmascript-data-types-and-values">clause 6</a> of this specification</p>
    </section>

    <section id="sec-primitive-value">
      <h3 id="sec-4.3.2" title="4.3.2">
          primitive value</h3><p>member of one of the types Undefined, Null, Boolean, Number, Symbol, or String as defined in <a href="sec-ecmascript-data-types-and-values">clause 6</a></p>

      <div class="note">
        <p><span class="nh">NOTE</span> A primitive value is a datum that is represented directly at the lowest level of the
        language implementation.</p>
      </div>
    </section>

    <section id="sec-terms-and-definitions-object">
      <h3 id="sec-4.3.3" title="4.3.3"> object</h3><p>member of the type Object</p>

      <div class="note">
        <p><span class="nh">NOTE</span> An object is a collection of properties and has a single prototype object. The prototype
        may be the null value.</p>
      </div>
    </section>

    <section id="sec-constructor">
      <h3 id="sec-4.3.4" title="4.3.4">
          constructor</h3><p>function object that creates and initializes objects</p>

      <div class="note">
        <p><span class="nh">NOTE</span> The value of a constructor&rsquo;s <code>prototype</code> property is a prototype object
        that is used to implement inheritance and shared properties.</p>
      </div>
    </section>

    <section id="sec-terms-and-definitions-prototype">
      <h3 id="sec-4.3.5" title="4.3.5"> prototype</h3><p>object that provides shared properties for other objects</p>

      <div class="note">
        <p><span class="nh">NOTE</span> When a constructor creates an object, that object implicitly references the
        constructor&rsquo;s <code>prototype</code> property for the purpose of resolving property references. The
        constructor&rsquo;s <code>prototype</code> property can be referenced by the program expression
        <code><i>constructor</i><b>.prototype</b></code>, and properties added to an object&rsquo;s prototype are shared, through
        inheritance, by all objects sharing the prototype. Alternatively, a new object may be created with an explicitly specified
        prototype by using the <code><a href="sec-fundamental-objects#sec-object.create">Object.create</a></code> built-in function.</p>
      </div>
    </section>

    <section id="sec-ordinary-object">
      <h3 id="sec-4.3.6" title="4.3.6">
          ordinary object</h3><p>object that has the default behaviour for the essential internal methods that must be supported by all objects</p>
    </section>

    <section id="sec-exotic-object">
      <h3 id="sec-4.3.7" title="4.3.7"> exotic
          object</h3><p>object that does not have the default behaviour for one or more of the essential internal methods that must be supported
      by all objects</p>

      <div class="note">
        <p><span class="nh">NOTE</span> Any object that is not an ordinary object is an exotic object.</p>
      </div>
    </section>

    <section id="sec-standard-object">
      <h3 id="sec-4.3.8" title="4.3.8">
          standard object</h3><p>object whose semantics are defined by this specification</p>
    </section>

    <section id="sec-built-in-object">
      <h3 id="sec-4.3.9" title="4.3.9">
          built-in object</h3><p>object specified and supplied by an ECMAScript implementation</p>

      <div class="note">
        <p><span class="nh">NOTE</span> Standard built-in objects are defined in this specification. An ECMAScript implementation
        may specify and supply additional kinds of built-in objects. A <i>built-in constructor</i> is a built-in object that is
        also a constructor.</p>
      </div>
    </section>

    <section id="sec-undefined-value">
      <h3 id="sec-4.3.10" title="4.3.10">
          undefined value</h3><p>primitive value used when a variable has not been assigned a value</p>
    </section>

    <section id="sec-terms-and-definitions-undefined-type">
      <h3 id="sec-4.3.11" title="4.3.11"> Undefined type</h3><p>type whose sole value is the <b>undefined</b> value</p>
    </section>

    <section id="sec-null-value">
      <h3 id="sec-4.3.12" title="4.3.12"> null
          value</h3><p>primitive value that represents the intentional absence of any object value</p>
    </section>

    <section id="sec-terms-and-definitions-null-type">
      <h3 id="sec-4.3.13" title="4.3.13"> Null type</h3><p>type whose sole value is the <b>null</b> value</p>
    </section>

    <section id="sec-terms-and-definitions-boolean-value">
      <h3 id="sec-4.3.14" title="4.3.14"> Boolean value</h3><p>member of the Boolean type</p>

      <div class="note">
        <p><span class="nh">NOTE</span> There are only two Boolean values, <b>true</b> and <b>false</b></p>
      </div>
    </section>

    <section id="sec-terms-and-definitions-boolean-type">
      <h3 id="sec-4.3.15" title="4.3.15"> Boolean type</h3><p>type consisting of the primitive values <b>true</b> and <b>false</b></p>
    </section>

    <section id="sec-boolean-object">
      <h3 id="sec-4.3.16" title="4.3.16">
          Boolean object</h3><p>member of the Object type that is an instance of the standard built-in <code>Boolean</code> constructor</p>

      <div class="note">
        <p><span class="nh">NOTE</span> A Boolean object is created by using the <code>Boolean</code> constructor in a
        <code>new</code> expression, supplying a Boolean value as an argument. The resulting object has an <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> whose value is the Boolean value. A Boolean
        object can be coerced to a Boolean value.</p>
      </div>
    </section>

    <section id="sec-terms-and-definitions-string-value">
      <h3 id="sec-4.3.17" title="4.3.17"> String value</h3><p>primitive value that is a finite ordered sequence of zero or more 16-bit unsigned integer</p>

      <div class="note">
        <p><span class="nh">NOTE</span> A String value is a member of the String type. Each integer value in the sequence usually
        represents a single 16-bit unit of UTF-16 text. However, ECMAScript does not place any restrictions or requirements on the
        values except that they must be 16-bit unsigned integers.</p>
      </div>
    </section>

    <section id="sec-terms-and-definitions-string-type">
      <h3 id="sec-4.3.18" title="4.3.18"> String type</h3><p>set of all possible String values</p>
    </section>

    <section id="sec-string-object">
      <h3 id="sec-4.3.19" title="4.3.19"> String
          object</h3><p>member of the Object type that is an instance of the standard built-in <code>String</code> constructor</p>

      <div class="note">
        <p><span class="nh">NOTE</span> A String object is created by using the <code>String</code> constructor in a
        <code>new</code> expression, supplying a String value as an argument. The resulting object has an <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> whose value is the String value. A String object
        can be coerced to a String value by calling the <code>String</code> constructor as a function (<a href="sec-text-processing#sec-string-constructor-string-value">21.1.1.1</a>).</p>
      </div>
    </section>

    <section id="sec-terms-and-definitions-number-value">
      <h3 id="sec-4.3.20" title="4.3.20"> Number value</h3><p>primitive value corresponding to a double-precision 64-bit binary format IEEE 754-2008 value</p>

      <div class="note">
        <p><span class="nh">NOTE</span> A Number value is a member of the Number type and is a direct representation of a
        number.</p>
      </div>
    </section>

    <section id="sec-terms-and-definitions-number-type">
      <h3 id="sec-4.3.21" title="4.3.21"> Number type</h3><p>set of all possible Number values including the special &ldquo;Not-a-Number&rdquo; (NaN) value, positive infinity, and
      negative infinity</p>
    </section>

    <section id="sec-number-object">
      <h3 id="sec-4.3.22" title="4.3.22"> Number
          object</h3><p>member of the Object type that is an instance of the standard built-in <code>Number</code> constructor</p>

      <div class="note">
        <p><span class="nh">NOTE</span> A Number object is created by using the <code>Number</code> constructor in a
        <code>new</code> expression, supplying a number value as an argument. The resulting object has an <a href="sec-ecmascript-data-types-and-values#sec-object-internal-methods-and-internal-slots">internal slot</a> whose value is the number value. A Number object
        can be coerced to a number value by calling the <code>Number</code> constructor as a function (<a href="sec-numbers-and-dates#sec-number-constructor-number-value">20.1.1.1</a>).</p>
      </div>
    </section>

    <section id="sec-terms-and-definitions-infinity">
      <h3 id="sec-4.3.23" title="4.3.23"> Infinity</h3><p>number value that is the positive infinite number value</p>
    </section>

    <section id="sec-terms-and-definitions-nan">
      <h3 id="sec-4.3.24" title="4.3.24"> NaN</h3><p>number value that is an IEEE 754-2008 &ldquo;Not-a-Number&rdquo; value</p>
    </section>

    <section id="sec-symbol-value">
      <h3 id="sec-4.3.25" title="4.3.25"> Symbol
          value</h3><p>primitive value that represents a unique, non-String Object <a href="sec-ecmascript-data-types-and-values#sec-object-type">property key</a></p>
    </section>

    <section id="sec-terms-and-definitions-symbol-type">
      <h3 id="sec-4.3.26" title="4.3.26"> Symbol type</h3><p>set of all possible Symbol values</p>
    </section>

    <section id="sec-symbol-object">
      <h3 id="sec-4.3.27" title="4.3.27"> Symbol
          object</h3><p>member of the Object type that is an instance of the standard built-in <code>Symbol</code> constructor</p>
    </section>

    <section id="sec-terms-and-definitions-function">
      <h3 id="sec-4.3.28" title="4.3.28"> function</h3><p>member of the Object type that may be invoked as a subroutine</p>

      <div class="note">
        <p><span class="nh">NOTE</span> In addition to its properties, a function contains executable code and state that
        determine how it behaves when invoked. A function&rsquo;s code may or may not be written in ECMAScript.</p>
      </div>
    </section>

    <section id="sec-built-in-function">
      <h3 id="sec-4.3.29" title="4.3.29">
          built-in function</h3><p>built-in object that is a function</p>

      <div class="note">
        <p><span class="nh">NOTE</span> Examples of built-in functions include <code>parseInt</code> and <code><a href="sec-numbers-and-dates#sec-math.exp">Math.exp</a></code>. An implementation may provide implementation-dependent built-in functions that
        are not described in this specification.</p>
      </div>
    </section>

    <section id="sec-property">
      <h3 id="sec-4.3.30" title="4.3.30">
          property</h3><p>part of an object that associates a key (either a String value or a Symbol value) and a value</p>

      <div class="note">
        <p><span class="nh">NOTE</span> Depending upon the form of the property the value may be represented either directly as a
        data value (a primitive value, an object, or a function object) or indirectly by a pair of accessor functions.</p>
      </div>
    </section>

    <section id="sec-method">
      <h3 id="sec-4.3.31" title="4.3.31"> method</h3><p>function that is the value of a property</p>

      <div class="note">
        <p><span class="nh">NOTE</span> When a function is called as a method of an object, the object is passed to the function
        as its <b>this</b> value.</p>
      </div>
    </section>

    <section id="sec-built-in-method">
      <h3 id="sec-4.3.32" title="4.3.32">
          built-in method</h3><p>method that is a built-in function</p>

      <div class="note">
        <p><span class="nh">NOTE</span> Standard built-in methods are defined in this specification, and an ECMAScript
        implementation may specify and provide other additional built-in methods.</p>
      </div>
    </section>

    <section id="sec-attribute">
      <h3 id="sec-4.3.33" title="4.3.33">
          attribute</h3><p>internal value that defines some characteristic of a property</p>
    </section>

    <section id="sec-own-property">
      <h3 id="sec-4.3.34" title="4.3.34"> own
          property</h3><p>property that is directly contained by its object</p>
    </section>

    <section id="sec-inherited-property">
      <h3 id="sec-4.3.35" title="4.3.35">
          inherited property</h3><p>property of an object that is not an own property but is a property (either own or inherited) of the object&rsquo;s
      prototype</p>
    </section>
  </section>

  <section id="sec-organization-of-this-specification">
    <h2 id="sec-4.4" title="4.4"> Organization of This Specification</h2><p>The remainder of this specification is organized as follows:</p>

    <p>Clause 5 defines the notational conventions used throughout the specification.</p>

    <p>Clauses 6&minus;9 define the execution environment within which ECMAScript programs operate.</p>

    <p>Clauses 10&minus;16 define the actual ECMAScript programming language including its syntactic encoding and the execution
    semantics of all language features.</p>

    <p>Clauses 17&minus;26 define the ECMAScript standard library. It includes the definitions of all of the standard objects that
    are available for use by ECMAScript programs as they execute.</p>
  </section>
</section>

