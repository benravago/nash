// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.5.3_A2.4_T1;
 * @section: 11.5.3;
 * @assertion: First expression is evaluated first, and then second expression;
 * @description: Checking with "=";
*/

//CHECK#1
var x = 0; 
if ((x = 1) % x !== 0) {
  warn('#1: var x = 0; (x = 1) % x === 0. Actual: ' + ((x = 1) % x));
}

//CHECK#2
var x = 1; 
if (x % (x = 2) !== 1) {
  warn('#2: var x = 1; x % (x = 2) === 1. Actual: ' + (x % (x = 2)));
}

