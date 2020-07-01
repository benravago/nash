// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.5.2_A4_T10;
 * @section: 11.5.2;
 * @assertion: The result of division is determined by the specification of IEEE 754 arithmetics; 
 * @description: If both operands are finite and nonzero, the quotient is computed and rounded using IEEE 754 round-to-nearest mode.
 * If the magnitude is too small to represent, the result is then a zero of appropriate sign;
 */

//CHECK#1
if (Number.MIN_VALUE / 2.1 !== 0) {
  warn('#1: Number.MIN_VALUE / 2.1 === 0. Actual: ' + (Number.MIN_VALUE / 2.1));
}

//CHECK#2
if (Number.MIN_VALUE / -2.1 !== -0) {
  warn('#2.1: Number.MIN_VALUE / -2.1 === 0. Actual: ' + (Number.MIN_VALUE / -2.1));
} else {
  if (1 / (Number.MIN_VALUE / -2.1) !== Number.NEGATIVE_INFINITY) {
    warn('#2.2: Number.MIN_VALUE / -2.1 === -0. Actual: +0');
  }
}

//CHECK#3
if (Number.MIN_VALUE / 2.0 !== 0) {
  warn('#3: Number.MIN_VALUE / 2.0 === 0. Actual: ' + (Number.MIN_VALUE / 2.0));
}

//CHECK#4
if (Number.MIN_VALUE / -2.0 !== -0) {
  warn('#4.1: Number.MIN_VALUE / -2.0 === -0. Actual: ' + (Number.MIN_VALUE / -2.0));
} else {
  if (1 / (Number.MIN_VALUE / -2.0) !== Number.NEGATIVE_INFINITY) {
    warn('#4.2: Number.MIN_VALUE / -2.0 === -0. Actual: +0');
  }
}

//CHECK#5
if (Number.MIN_VALUE / 1.9 !== Number.MIN_VALUE) {
  warn('#5: Number.MIN_VALUE / 1.9 === Number.MIN_VALUE. Actual: ' + (Number.MIN_VALUE / 1.9));
}

//CHECK#6
if (Number.MIN_VALUE / -1.9 !== -Number.MIN_VALUE) {
  warn('#6: Number.MIN_VALUE / -1.9 === -Number.MIN_VALUE. Actual: ' + (Number.MIN_VALUE / -1.9));
}

//CHECK#7
if (Number.MIN_VALUE / 1.1 !== Number.MIN_VALUE) {
  warn('#7: Number.MIN_VALUE / 1.1 === Number.MIN_VALUE. Actual: ' + (Number.MIN_VALUE / 1.1));
}

//CHECK#8
if (Number.MIN_VALUE / -1.1 !== -Number.MIN_VALUE) {
  warn('#8: Number.MIN_VALUE / -1.1 === -Number.MIN_VALUE. Actual: ' + (Number.MIN_VALUE / -1.1));
} 
