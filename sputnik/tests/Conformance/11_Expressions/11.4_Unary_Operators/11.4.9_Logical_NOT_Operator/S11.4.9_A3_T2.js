// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.4.9_A3_T2;
* @section: 11.4.9;
* @assertion: Operator !x returns !ToBoolean(x);
* @description: Type(x) is number primitive or Number object;
*/

//CHECK#1
if (!0.1 !== false) {
  warn('#1: !0.1 === false');
}

//CHECK#2
if (!new Number(-0.1) !== false) {
  warn('#2: !new Number(-0.1) === false');
}

//CHECK#3
if (!NaN !== true) {
  warn('#3: !NaN === true');
}

//CHECK#4
if (!new Number(NaN) !== false) {
  warn('#4: !new Number(NaN) === false');
}

//CHECK#5
if (!0 !== true) {
  warn('#5: !0 === true');
}

//CHECK#6
if (!new Number(0) !== false) {
  warn('#6: !new Number(0) === false');
}

//CHECK#7
if (!Infinity !== false) {
  warn('#7: !Infinity === false');
}
