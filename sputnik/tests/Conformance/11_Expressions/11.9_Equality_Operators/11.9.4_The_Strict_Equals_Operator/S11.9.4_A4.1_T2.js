// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.4_A4.1_T2;
 * @section: 11.9.4, 11.9.6;
 * @assertion: If x or y is NaN, return false;
 * @description: y is NaN;
*/

//CHECK#1
if (true === Number.NaN) {
  warn('#1: true !== NaN');
}

//CHECK#2
if (-1 === Number.NaN) {
  warn('#2: -1 !== NaN');
}

//CHECK#3
if (Number.NaN === Number.NaN) {
  warn('#3: NaN !== NaN');
}

//CHECK#4
if (Number.POSITIVE_INFINITY === Number.NaN) {
  warn('#4: +Infinity !== NaN');
}

//CHECK#5
if (Number.NEGATIVE_INFINITY === Number.NaN) {
  warn('#5: -Infinity !== NaN');
}

//CHECK#6
if (Number.MAX_VALUE === Number.NaN) {
  warn('#6: Number.MAX_VALUE !== NaN');
}

//CHECK#7
if (Number.MIN_VALUE === Number.NaN) {
  warn('#7: Number.MIN_VALUE !== NaN');
}

//CHECK#8
if ("string" === Number.NaN) {
  warn('#8: "string" !== NaN');
}

//CHECK#9
if (new Object() === Number.NaN) {
  warn('#9: new Object() !== NaN');
}
