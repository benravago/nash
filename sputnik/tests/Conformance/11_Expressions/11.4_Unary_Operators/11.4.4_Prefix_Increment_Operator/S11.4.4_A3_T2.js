// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.4.4_A3_T2;
* @section: 11.4.4, 11.6.3;
* @assertion: Operator ++x returns x = ToNumber(x) + 1;
* @description: Type(x) is number primitive or Number object;
*/

//CHECK#1
var x = 0.1; 
++x;
if (x !== 0.1 + 1) {
  warn('#1: var x = 0.1; ++x; x === 0.1 + 1. Actual: ' + (x));
}

//CHECK#2
var x = new Number(-1.1); 
++x;
if (x !== -1.1 + 1) {
  warn('#2: var x = new Number(-1.1); ++x; x === -1.1 + 1. Actual: ' + (x));
}
