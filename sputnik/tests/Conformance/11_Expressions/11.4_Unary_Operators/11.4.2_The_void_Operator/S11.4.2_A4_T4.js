// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.4.2_A4_T4;
* @section: 11.4.2;
* @assertion: Operator "void" evaluates UnaryExpression and returns undefined;
* @description: Type(x) is undefined or null;
*/

//CHECK#1
var x; 
if (isNaN(void x) !== true) {
  warn('#1: var x; void x === undefined. Actual: ' + (void x));
}

//CHECK#2
var x = null;
if (void x !== undefined) {
  warn('#2: var x = null; void x === undefined. Actual: ' + (void x));
}
