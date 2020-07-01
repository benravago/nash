// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.5_A1.2_T1;
 * @section: 15.4.4.5;
 * @assertion: If separator is undefined, a single comma is used as the separator;
 * @description: Checking this use new Array() and [];
*/

//CHECK#1
var x = new Array(0,1,2,3);
if (x.join() !== "0,1,2,3") {
  warn('#1: x = new Array(0,1,2,3); x.join() === "0,1,2,3". Actual: ' + (x.join()));
}

//CHECK#2
x = [];
x[0] = 0;
x[3] = 3;
if (x.join() !== "0,,,3") {
  warn('#2: x = []; x[0] = 0; x[3] = 3; x.join() === "0,,,3". Actual: ' + (x.join()));
}

//CHECK#3
x = [];
x[0] = 0;
if (x.join() !== "0") {
  warn('#3: x = []; x[0] = 0; x.join() === "0". Actual: ' + (x.join()));
}
