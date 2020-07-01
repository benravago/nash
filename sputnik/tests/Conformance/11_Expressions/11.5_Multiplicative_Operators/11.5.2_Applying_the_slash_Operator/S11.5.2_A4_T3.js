// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.5.2_A4_T3;
 * @section: 11.5.2;
 * @assertion: The result of division is determined by the specification of IEEE 754 arithmetics; 
 * @description: Division of an infinity by a zero results in an infinity of appropriate sign;
 */

//CHECK#1
if (Number.NEGATIVE_INFINITY / 0 !== Number.NEGATIVE_INFINITY) {
  warn('#1: Infinity / 0 === Infinity. Actual: ' + (Infinity / 0));
}

//CHECK#2
if (Number.NEGATIVE_INFINITY / -0 !== Number.POSITIVE_INFINITY) {
  warn('#2: -Infinity / -0 === Infinity. Actual: ' + (-Infinity / -0));
}

//CHECK#3
if (Number.POSITIVE_INFINITY / 0 !== Number.POSITIVE_INFINITY) {
  warn('#3: Infinity / 0 === Infinity. Actual: ' + (Infinity / 0));
}

//CHECK#4
if (Number.POSITIVE_INFINITY / -0 !== Number.NEGATIVE_INFINITY) {
  warn('#4: Infinity / -0 === -Infinity. Actual: ' + (Infinity / -0));
}
