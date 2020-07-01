// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.10.1_A3_T2.2;
 * @section: 11.10.1;
 * @assertion: Operator x & y returns ToNumber(x) & ToNumber(y); 
 * @description: Type(x) is different from Type(y) and both types vary between Number (primitive or object) and String (primitive and object);
*/

//CHECK#1
if (("1" & 1) !== 1) {
  warn('#1: ("1" & 1) === 1. Actual: ' + (("1" & 1)));
}

//CHECK#2
if ((1 & "1") !== 1) {
  warn('#2: (1 & "1") === 1. Actual: ' + ((1 & "1")));
}

//CHECK#3
if ((new String("1") & 1) !== 1) {
  warn('#3: (new String("1") & 1) === 1. Actual: ' + ((new String("1") & 1)));
}

//CHECK#4
if ((1 & new String("1")) !== 1) {
  warn('#4: (1 & new String("1")) === 1. Actual: ' + ((1 & new String("1"))));
}

//CHECK#5
if (("1" & new Number(1)) !== 1) {
  warn('#5: ("1" & new Number(1)) === 1. Actual: ' + (("1" & new Number(1))));
}

//CHECK#6
if ((new Number(1) & "1") !== 1) {
  warn('#6: (new Number(1) & "1") === 1. Actual: ' + ((new Number(1) & "1")));
}

//CHECK#7
if ((new String("1") & new Number(1)) !== 1) {
  warn('#7: (new String("1") & new Number(1)) === 1. Actual: ' + ((new String("1") & new Number(1))));
}

//CHECK#8
if ((new Number(1) & new String("1")) !== 1) {
  warn('#8: (new Number(1) & new String("1")) === 1. Actual: ' + ((new Number(1) & new String("1"))));
}

//CHECK#9
if (("x" & 1) !== 0) {
  warn('#9: ("x" & 1) === 0. Actual: ' + (("x" & 1)));
}

//CHECK#10
if ((1 & "x") !== 0) {
  warn('#10: (1 & "x") === 0. Actual: ' + ((1 & "x")));
}
