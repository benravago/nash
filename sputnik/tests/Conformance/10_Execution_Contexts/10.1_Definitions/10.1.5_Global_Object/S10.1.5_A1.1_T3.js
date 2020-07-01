// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.5_A1.1_T3;
 * @section: 10.1.5, 15.1;
 * @assertion: Global object has properties such as built-in objects such as 
 * Math, String, Date, parseInt, etc;
 * @description: Global execution context - Constructor Properties;
*/

//CHECK#13
if ( Object === null ) {
  warn("#13: Object === null");
}

//CHECK#14
if ( Function === null ) {
  warn("#14: Function === null");
}

//CHECK#15
if ( String === null ) {
  warn("#15: String === null");
}

//CHECK#16
if ( Number === null ) {
  warn("#16: Number === null");
}

//CHECK#17
if ( Array === null ) {
  warn("#17: Array === null");
}

//CHECK#18
if ( Boolean === null ) {
  warn("#20: Boolean === null");
}

//CHECK#18
if ( Date === null ) {
  warn("#18: Date === null");
}

//CHECK#19
if ( RegExp === null ) {
  warn("#19: RegExp === null");
}

//CHECK#20
if ( Error === null ) {
  warn("#20: Error === null");
}

//CHECK#21
if ( EvalError === null ) {
  warn("#21: EvalError === null");
}

//CHECK#22
if ( RangeError === null ) {
  warn("#22: RangeError === null");
}

//CHECK#23
if ( ReferenceError === null ) {
  warn("#23: ReferenceError === null");
}

//CHECK#24
if ( SyntaxError === null ) {
  warn("#24: SyntaxError === null");
}

//CHECK#25
if ( TypeError === null ) {
  warn("#25: TypeError === null");
}

//CHECK#26
if ( URIError === null ) {
  warn("#26: URIError === null");
}

