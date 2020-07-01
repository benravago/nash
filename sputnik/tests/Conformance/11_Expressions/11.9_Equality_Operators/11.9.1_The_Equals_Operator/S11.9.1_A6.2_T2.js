// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.1_A6.2_T2;
 * @section: 11.9.1, 11.9.3;
* @assertion: If one expression is undefined or null and another is not, return false;
 * @description: y is null or undefined, x is not;   
*/

//CHECK#1
if ((false == undefined) !== false) {
  warn('#1: (false == undefined) === false');
}

//CHECK#2
if ((Number.NaN == undefined) !== false) {
  warn('#2: (Number.NaN == undefined) === false');
}

//CHECK#3
if (("undefined" == undefined) !== false) {
  warn('#3: ("undefined" == undefined) === false');
}

//CHECK#4
if (({} == undefined) !== false) {
  warn('#4: ({} == undefined) === false');
}

//CHECK#5
if ((false == null) !== false) {
  warn('#5: (false == null) === false');
}

//CHECK#6
if ((0 == null) !== false) {
  warn('#6: (0 == null) === false');
}

//CHECK#7
if (("null" == null) !== false) {
  warn('#7: ("null" == null) === false');
}

//CHECK#8
if (({} == null) !== false) {
  warn('#8: ({} == null) === false');
}
