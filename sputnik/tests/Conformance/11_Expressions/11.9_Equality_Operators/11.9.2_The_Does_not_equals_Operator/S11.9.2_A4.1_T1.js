// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.2_A4.1_T1;
 * @section: 11.9.2, 11.9.3;
 * @assertion: If x or y is NaN, return true;
 * @description: x is NaN;
*/

//CHECK#1
if ((Number.NaN != true) !== true) {
  warn('#1: (NaN != true) === true');
}

//CHECK#2
if ((Number.NaN != 1) !== true) {
  warn('#2: (NaN != 1) === true');
}

//CHECK#3
if ((Number.NaN != Number.NaN) !== true) {
  warn('#3: (NaN != NaN) === true');
}

//CHECK#4
if ((Number.NaN != Number.POSITIVE_INFINITY) !== true) {
  warn('#4: (NaN != +Infinity) === true');
}

//CHECK#5
if ((Number.NaN != Number.NEGATIVE_INFINITY) !== true) {
  warn('#5: (NaN != -Infinity) === true');
}

//CHECK#6
if ((Number.NaN != Number.MAX_VALUE) !== true) {
  warn('#6: (NaN != Number.MAX_VALUE) === true');
}

//CHECK#7
if ((Number.NaN != Number.MIN_VALUE) !== true) {
  warn('#7: (NaN != Number.MIN_VALUE) === true');
}

//CHECK#8
if ((Number.NaN != "string") !== true) {
  warn('#8: (NaN != "string") === true');
}

//CHECK#9
if ((Number.NaN != new Object()) !== true) {
  warn('#9: (NaN != new Object()) === true');
}

