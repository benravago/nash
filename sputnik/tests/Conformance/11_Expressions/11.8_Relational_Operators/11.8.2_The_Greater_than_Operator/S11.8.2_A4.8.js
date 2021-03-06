// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.2_A4.8;
* @section: 11.8.2, 11.8.5;
* @assertion: If y is -Infinity and x !== y, return true;
* @description: x is number primitive;
*/

//CHECK#1
if ((0 > Number.NEGATIVE_INFINITY) !== true) {
  warn('#1: (0 > -Infinity) === true');
}

//CHECK#2
if ((1.1 > Number.NEGATIVE_INFINITY) !== true) {
  warn('#2: (1.1 > -Infinity) === true');
}

//CHECK#3
if ((-1.1 > Number.NEGATIVE_INFINITY) !== true) {
  warn('#3: (-1.1 > -Infinity) === true');
}

//CHECK#4
if ((Number.POSITIVE_INFINITY > Number.NEGATIVE_INFINITY) !== true) {
  warn('#4: (+Infinity > -Infinity) === true');
}

//CHECK#5
if ((Number.MAX_VALUE > Number.NEGATIVE_INFINITY) !== true) {
  warn('#5: (Number.MAX_VALUE > -Infinity) === true');
}

//CHECK#6
if ((Number.MIN_VALUE > Number.NEGATIVE_INFINITY) !== true) {
  warn('#6: (Number.MIN_VALUE > -Infinity) === true');
}

