// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.5.2_A4_T6;
 * @section: 11.5.2;
 * @assertion: The result of division is determined by the specification of IEEE 754 arithmetics; 
 * @description: Division of a finite value by an infinity results in zero of appropriate sign;
 */

//CHECK#1
if (1 / Number.NEGATIVE_INFINITY !== -0) {
  warn('#1.1: 1 / -Infinity === 0. Actual: ' + (1 / -Infinity));
} else {
  if (1 / (1 / Number.NEGATIVE_INFINITY) !== Number.NEGATIVE_INFINITY) {
    warn('#1.2: 1 / -Infinity === - 0. Actual: +0');
  }
}

//CHECK#2
if (-1 / Number.NEGATIVE_INFINITY !== +0) {
  warn('#2.1: -1 / -Infinity === 0. Actual: ' + (-1 / -Infinity));
} else {
  if (1 / (-1 / Number.NEGATIVE_INFINITY) !== Number.POSITIVE_INFINITY) {
    warn('#2.2: -1 / -Infinity === + 0. Actual: -0');
  }
}

//CHECK#3
if (1 / Number.POSITIVE_INFINITY !== +0) {
  warn('#3.1: 1 / Infinity === 0. Actual: ' + (1 / Infinity));
} else {
  if (1 / (1 / Number.POSITIVE_INFINITY) !== Number.POSITIVE_INFINITY) {
    warn('#3.2: 1 / Infinity === + 0. Actual: -0');
  }
}

//CHECK#4
if (-1 / Number.POSITIVE_INFINITY !== -0) {
  warn('#4.1: -1 / Infinity === 0. Actual: ' + (-1 / Infinity));
} else {
  if (1 / (-1 / Number.POSITIVE_INFINITY) !== Number.NEGATIVE_INFINITY) {
    warn('#4.2: -1 / Infinity === - 0. Actual: +0');
  }
}
