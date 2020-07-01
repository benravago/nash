// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.5_A4.3;
 * @section: 11.9.5, 11.9.6;
 * @assertion: Type(x) and Type(y) are Number-s minus NaN, +0, -0. 
 * Return false, if x is the same number value as y; otherwise, return true;
 * @description: x and y are primitive numbers;
*/

//CHECK#1
if (Number.POSITIVE_INFINITY !== Number.POSITIVE_INFINITY) {
  warn('#1: +Infinity === +Infinity');
}

//CHECK#2
if (Number.NEGATIVE_INFINITY !== Number.NEGATIVE_INFINITY) {
  warn('#2: -Infinity === -Infinity');
}

//CHECK#3
if (13 !== 13) {
  warn('#3: 13 === 13');
}

//CHECK#4
if (-13 !== -13) {
  warn('#4: -13 === -13');
}

//CHECK#5
if (1.3 !== 1.3) {
  warn('#5: 1.3 === 1.3');
}

//CHECK#6
if (-1.3 !== -1.3) {
  warn('#6: -1.3 === -1.3');
}

//CHECK#7
if (Number.POSITIVE_INFINITY !== -Number.NEGATIVE_INFINITY) {
  warn('#7: +Infinity === -(-Infinity)');
}

//CHECK#8
if (!(1 !== 0.999999999999)) {
  warn('#8: 1 !== 0.999999999999');
}

//CHECK#9
if (1.0 !== 1) {
  warn('#9: 1.0 === 1');
}
