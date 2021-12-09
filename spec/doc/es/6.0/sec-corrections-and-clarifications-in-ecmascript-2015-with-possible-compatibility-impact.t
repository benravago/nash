<section id="sec-corrections-and-clarifications-in-ecmascript-2015-with-possible-compatibility-impact">
  <h1 id="sec-D" title="Annex&nbsp;D"> </h1><p><a href="sec-executable-code-and-execution-contexts#sec-candeclareglobalvar">8.1.1.4.15</a>-<a href="sec-executable-code-and-execution-contexts#sec-createglobalfunctionbinding">8.1.1.4.18</a> Edition 5 and <a href="sec-notational-conventions#sec-syntactic-and-lexical-grammars">5.1</a> used a property existence test to determine whether a global object property
  corresponding to a new global declaration already existed. ECMAScript 2015 uses an own property existence test. This corresponds
  to what has been most commonly implemented by web browsers.</p>

  <p><a href="sec-ordinary-and-exotic-objects-behaviours#sec-array-exotic-objects-defineownproperty-p-desc">9.4.2.1</a>: The 5<sup>th</sup> Edition moved the capture of the
  current array length prior to the integer conversion of the array index or new length value. However, the captured length value
  could become invalid if the conversion process has the side-effect of changing the array length. ECMAScript 2015 specifies that
  the current array length must be captured after the possible occurrence of such side-effects.</p>

  <p><a href="sec-numbers-and-dates#sec-timeclip">20.3.1.15</a>: Previous editions permitted the <a href="sec-numbers-and-dates#sec-timeclip">TimeClip</a> abstract
  operation to return either +0 or <b>&minus;</b>0 as the representation of a 0 <a href="sec-numbers-and-dates#sec-time-values-and-time-range">time
  value</a>. ECMAScript 2015 specifies that +0 always returned. This means that for ECMAScript 2015 the <a href="sec-numbers-and-dates#sec-time-values-and-time-range">time value</a> of a Date object is never observably <b>&minus;</b>0 and methods that
  return time values never return <b>&minus;</b>0.</p>

  <p><a href="sec-numbers-and-dates#sec-date-time-string-format">20.3.1.16</a>: If a time zone offset is not present, the local time zone is used.
  Edition 5.1 incorrectly stated that a missing time zone should be interpreted as <code><b>"</b>z<b>"</b></code>.</p>

  <p><a href="sec-numbers-and-dates#sec-date.prototype.toisostring">20.3.4.36</a>: If the year cannot be represented using the Date Time String Format
  specified in <a href="sec-numbers-and-dates#sec-date-time-string-format">20.3.1.16</a> a RangeError exception is thrown. Previous editions did not
  specify the behaviour for that case.</p>

  <p><a href="sec-numbers-and-dates#sec-date.prototype.tostring">20.3.4.41</a>: Previous editions did not specify the value returned by <a href="sec-numbers-and-dates#sec-date.prototype.tostring">Date.prototype.toString</a> when <a href="sec-numbers-and-dates#sec-properties-of-the-date-prototype-object">this
  time value</a> is NaN. ECMAScript 2015 specifies the result to be the String value is <code>"Invalid Date".</code></p>

  <p><a href="sec-text-processing#sec-regexp-pattern-flags">21.2.3.1</a>, <a href="sec-text-processing#sec-escaperegexppattern">21.2.3.2.4</a>: Any LineTerminator code
  points in the value of the <code>source</code> property of an RegExp instance must be expressed using an escape sequence.
  Edition 5.1 only required the escaping of <code>"/"</code>.</p>

  <p><a href="sec-text-processing#sec-regexp.prototype-@@match">21.2.5.6</a>, <a href="sec-text-processing#sec-regexp.prototype-@@replace">21.2.5.8</a>: In previous
  editions, the specifications for <code><a href="sec-text-processing#sec-string.prototype.match">String.prototype.match</a></code> and <code><a href="sec-text-processing#sec-string.prototype.replace">String.prototype.replace</a></code> was incorrect for cases where the pattern argument was
  a RegExp value whose <code>global</code> is flag set. The previous specifications stated that for each attempt to match the
  pattern, if <code>lastIndex</code> did not change it should be incremented by 1.  The correct behaviour is that
  <code>lastIndex</code> should be incremented by one only if the pattern matched the empty string.</p>

  <p><a href="sec-indexed-collections#sec-array.prototype.sort">22.1.3.24</a>, <a href="sec-indexed-collections#sec-sortcompare">22.1.3.24.1</a>: Previous editions did not
  specify how a <b>NaN</b> value returned by a <var>comparefn</var> was interpreted by <code><a href="sec-indexed-collections#sec-array.prototype.sort">Array.prototype.sort</a></code>. ECMAScript 2015 specifies that such as value is treated as if
  +0 was returned from the <var>comparefn</var>. ECMAScript 2015 also specifies that <a href="sec-abstract-operations#sec-tonumber">ToNumber</a> is
  applied to the result  returned by a <span style="font-family: Times New Roman"><i>comparefn</i>.</span> In previous editions,
  the effect of a <var>comparefn</var> result that is not a Number value was implementation dependent. In practice,
  implementations call <a href="sec-abstract-operations#sec-tonumber">ToNumber</a>.</p>
</section>

