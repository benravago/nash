// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S8.1_A2_T1;
 * @section: 8.1;
 * @assertion: Any variable that has not been assigned a value has the value undefined;
 * @description: Check that var x have value and type undefined; 
*/

var x;

///////////////////////////////////////////////////////////////////
// CHECK#1
if (!(x === undefined)) {
  warn('#1: var x; x === undefined. Actual: ' + (x));
}
//
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// CHECK#2
if (!(typeof(x) === "undefined")) {
  warn('#2: var x; typeof(x) === "undefined". Actual: ' + (typeof(x)));
}
//
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// CHECK#3
if (!(x === void 0)) {
  warn('#3: var x; x === void 0. Actual: ' + (x));
}
//
///////////////////////////////////////////////////////////////////
