// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.2_A4.3;
* @section: 11.8.2, 11.8.5;
* @assertion: If x and y are the same number value, return false;
* @description: x and y are number primitives;
*/

//CHECK#1
if ((1 > 1) !== false) {
  warn('#1: (1 > 1) === false');
}

//CHECK#2
if ((1.1 > 1.1) !== false) {
  warn('#2: (1.1 > 1.1) === false');
}

//CHECK#3
if ((-1.1 > -1.1) !== false) {
  warn('#3: (-1.1 > -1.1) === false');
}

//CHECK#4
if ((Number.NEGATIVE_INFINITY > Number.NEGATIVE_INFINITY) !== false) {
  warn('#4: (-Infinity > -Infinity) === false');
}

//CHECK#5
if ((Number.POSITIVE_INFINITY > Number.POSITIVE_INFINITY) !== false) {
  warn('#5: (+Infinity > +Infinity) === false');
}

//CHECK#6
if ((Number.MAX_VALUE > Number.MAX_VALUE) !== false) {
  warn('#6: (Number.MAX_VALUE > Number.MAX_VALUE) === false');
}

//CHECK#7
if ((Number.MIN_VALUE > Number.MIN_VALUE) !== false) {
  warn('#7: (Number.MIN_VALUE > Number.MIN_VALUE) === false');
}


