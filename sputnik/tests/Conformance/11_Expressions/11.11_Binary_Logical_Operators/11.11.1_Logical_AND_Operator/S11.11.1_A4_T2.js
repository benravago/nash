// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.11.1_A4_T2;
* @section: 11.11.1;
* @assertion: If ToBoolean(x) is true, return y;
* @description: Type(x) and Type(y) vary between primitive number and Number object;
*/

//CHECK#1
if ((-1 && -0) !== 0) {
  warn('#1.1: (-1 && -0) === 0');
} else {
  if ((1 / (-1 && -0)) !== Number.NEGATIVE_INFINITY) {
    warn('#1.2: (-1 && -0) === -0');
  }
}

//CHECK#2
if ((-1 && 0) !== 0) {
  warn('#2.1: (-1 && 0) === 0');
} else {
  if ((1 / (-1 && 0)) !== Number.POSITIVE_INFINITY) {
    warn('#2.2: (-1 && 0) === +0');
  }
}

//CHECK#3
if ((isNaN(0.1 && NaN)) !== true) {
  warn('#3: (0.1 && NaN) === Not-a-Number');
}

//CHECK#4
var y = new Number(0);
if ((new Number(-1) && y) !== y) {
  warn('#4: (var y = new Number(0); (new Number(-1) && y) === y');
}

//CHECK#5
var y = new Number(NaN);
if ((new Number(0) && y) !== y) {
  warn('#5: (var y = new Number(NaN); (new Number(0) && y) === y');
}

//CHECK#6
var y = new Number(-1);
if ((new Number(NaN) && y) !== y) {
  warn('#6: (var y = new Number(-1); (new Number(NaN) && y) === y');
}
