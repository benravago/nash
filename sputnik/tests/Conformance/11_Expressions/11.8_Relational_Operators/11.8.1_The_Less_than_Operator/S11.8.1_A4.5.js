// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.1_A4.5;
* @section: 11.8.1, 11.8.5;
* @assertion: If x is +Infinity, return false;
* @description: y is number primitive;
*/

//CHECK#1
if ((Number.POSITIVE_INFINITY < 0) !== false) {
  warn('#1: (+Infinity < 0) === false');
}

//CHECK#2
if ((Number.POSITIVE_INFINITY < 1.1) !== false) {
  warn('#2: (+Infinity < 1.1) === false');
}

//CHECK#3
if ((Number.POSITIVE_INFINITY < -1.1) !== false) {
  warn('#3: (+Infinity < -1.1) === false');
}

//CHECK#4
if ((Number.POSITIVE_INFINITY < Number.NEGATIVE_INFINITY) !== false) {
  warn('#4: (+Infinity < -Infinity) === false');
}

//CHECK#5
if ((Number.POSITIVE_INFINITY < Number.MAX_VALUE) !== false) {
  warn('#5: (+Infinity < Number.MAX_VALUE) === false');
}

//CHECK#6
if ((Number.POSITIVE_INFINITY < Number.MIN_VALUE) !== false) {
  warn('#6: (+Infinity < Number.MIN_VALUE) === false');
}

