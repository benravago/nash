// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.1.6_A3_T2;
* @section: 11.1.6;
* @assertion: "This" operator only evaluates Expression;
* @description: Applying grouping operator to Number;
*/

//Check for Number

//CHECK#1
if ((1) !== 1) {
  warn('#1: (1) === 1. Actual: ' + ((1)));
}

//CHECK#2
var x = new Number(1);
if ((x) !== x) {
  warn('#2: var x = new Number(1); (x) === x. Actual: ' + ((x)));
}
