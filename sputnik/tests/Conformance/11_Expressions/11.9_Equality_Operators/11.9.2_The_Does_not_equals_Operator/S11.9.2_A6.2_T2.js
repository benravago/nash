// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.2_A6.2_T2;
 * @section: 11.9.2, 11.9.3;
 * @assertion: If one expression is undefined or null and another is not, return false;
 * @description: y is null or undefined, x is not;   
*/

//CHECK#1
if ((false != undefined) !== true) {
  warn('#1: (false != undefined) === true');
}

//CHECK#2
if ((Number.NaN != undefined) !== true) {
  warn('#2: (Number.NaN != undefined) === true');
}

//CHECK#3
if (("undefined" != undefined) !== true) {
  warn('#3: ("undefined" != undefined) === true');
}

//CHECK#4
if (({} != undefined) !== true) {
  warn('#4: ({} != undefined) === true');
}

//CHECK#5
if ((false != null) !== true) {
  warn('#5: (false != null) === true');
}

//CHECK#6
if ((0 != null) !== true) {
  warn('#6: (0 != null) === true');
}

//CHECK#7
if (("null" != null) !== true) {
  warn('#7: ("null" != null) === true');
}

//CHECK#8
if (({} != null) !== true) {
  warn('#8: ({} != null) === true');
}
