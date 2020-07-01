// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.5.2_A4_T9;
 * @section: 11.5.2;
 * @assertion: The result of division is determined by the specification of IEEE 754 arithmetics; 
 * @description: If the magnitude is too large to represent, the result is then an infinity of appropriate sign;
 */

//CHECK#1
if (Number.MAX_VALUE / 0.9 !== Number.POSITIVE_INFINITY) {
  warn('#1: Number.MAX_VALUE / 0.9 === Number.POSITIVE_INFINITY. Actual: ' + (Number.MAX_VALUE / 0.9));
}

//CHECK#2
if (Number.MAX_VALUE / -0.9 !== Number.NEGATIVE_INFINITY) {
  warn('#2: Number.MAX_VALUE / -0.9 === Number.NEGATIVE_INFINITY. Actual: ' + (Number.MAX_VALUE / -0.9));
} 

//CHECK#3
if (Number.MAX_VALUE / 1 !== Number.MAX_VALUE) {
  warn('#3: Number.MAX_VALUE / 1 === Number.MAX_VALUE. Actual: ' + (Number.MAX_VALUE / 1));
}

//CHECK#4
if (Number.MAX_VALUE / -1 !== -Number.MAX_VALUE) {
  warn('#4: Number.MAX_VALUE / -1 === -Number.MAX_VALUE. Actual: ' + (Number.MAX_VALUE / -1));
} 

//CHECK#5
if (Number.MAX_VALUE / (Number.MAX_VALUE / 0.9) === (Number.MAX_VALUE / Number.MAX_VALUE) / 0.9) {
  warn('#5: Number.MAX_VALUE / (Number.MAX_VALUE / 0.9) !== (Number.MAX_VALUE / Number.MAX_VALUE) / 0.9');
}
