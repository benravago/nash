// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.3_A4.2_T1;
 * @section: 9.3, 15.7.1;
 * @assertion: Result of number conversion from number value equals to the input argument (no conversion);
 * @description: Number.NaN, +0, -0, Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY, 
 * Number.MAX_VALUE and Number.MIN_VALUE convert to Number by explicit transformation;
 */

// CHECK#1
if (isNaN(Number(Number.NaN)) !== true) {
  warn('#1: Number(NaN) === Not-a-Number. Actual: ' + (Number(NaN))); 
}

// CHECK#2
if (Number(+0) !== +0) {
  warn('#2.1: Number(+0) === 0. Actual: ' + (Number(+0))); 
} else {
  if (1/Number(+0) !== Number.POSITIVE_INFINITY) {
    warn('#2.2: Number(+0) === +0. Actual: -0');
  }	
}

// CHECK#3
if (Number(-0) !== -0) {
  warn('#3.1: Number(-0) === 0. Actual: ' + (Number(-0))); 
} else {
  if (1/Number(-0) !== Number.NEGATIVE_INFINITY) {
    warn('#3.2: Number(-0) === -0. Actual: +0');
  }	
}

// CHECK#4
if (Number(Number.POSITIVE_INFINITY) !== Number.POSITIVE_INFINITY) {
  warn('#4: Number(+Infinity) === +Infinity. Actual: ' + (Number(+Infinity))); 
}

// CHECK#5
if (Number(Number.NEGATIVE_INFINITY) !== Number.NEGATIVE_INFINITY) {
  warn('#5: Number(-Infinity) === -Infinity. Actual: ' + (Number(-Infinity))); 
}

// CHECK#6
if (Number(Number.MAX_VALUE) !== Number.MAX_VALUE) {
  warn('#6: Number(Number.MAX_VALUE) === Number.MAX_VALUE. Actual: ' + (Number(Number.MAX_VALUE))); 
}

// CHECK#7
if (Number(Number.MIN_VALUE) !== Number.MIN_VALUE) {
  warn('#7: Number(Number.MIN_VALUE) === Number.MIN_VALUE. Actual: ' + (Number(Number.MIN_VALUE))); 
}
