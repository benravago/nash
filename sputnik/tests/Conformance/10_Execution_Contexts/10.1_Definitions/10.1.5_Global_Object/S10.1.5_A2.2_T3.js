// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S10.1.5_A2.2_T3;
 * @section: 10.1.5, 15.1;
 * @assertion: Global object properties have attributes { DontEnum };
 * @description: Function execution context - Constructor Properties;
*/

function test() {
  //CHECK#1
  for (var x in this) {
    if ( x === 'Object' ) {
      warn("#1: 'property 'Object' have attribute DontEnum");
    } else if ( x === 'Function') {
      warn("#1: 'Function' have attribute DontEnum");
    } else if ( x === 'String' ) {
      warn("#1: 'String' have attribute DontEnum");
    } else if ( x === 'Number' ) {
      warn("#1: 'Number' have attribute DontEnum");
    } else if ( x === 'Array' ) {
      warn("#1: 'Array' have attribute DontEnum");
    } else if ( x === 'Boolean' ) {
      warn("#1: 'Boolean' have attribute DontEnum");
    } else if ( x === 'Date' ) {
      warn("#1: 'Date' have attribute DontEnum");
    } else if ( x === 'RegExp' ) {
      warn("#1: 'RegExp' have attribute DontEnum");
    } else if ( x === 'Error' ) {
      warn("#1: 'Error' have attribute DontEnum");
    } else if ( x === 'EvalError' ) {
      warn("#1: 'EvalError' have attribute DontEnum");
    } else if ( x === 'RangeError' ) {
      warn("#1: 'RangeError' have attribute DontEnum");
    } else if ( x === 'ReferenceError' ) {
      warn("#1: 'ReferenceError' have attribute DontEnum");
    } else if ( x === 'SyntaxError' ) {
      warn("#1: 'SyntaxError' have attribute DontEnum");
    } else if ( x === 'TypeError' ) {
      warn("#1: 'TypeError' have attribute DontEnum");
    } else if ( x === 'URIError' ) {
      warn("#1: 'URIError' have attribute DontEnum");
    } 
  }
}

test();
