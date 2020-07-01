// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.10.3_A3_T2.7;
 * @section: 11.10.3;
 * @assertion: Operator x | y returns ToNumber(x) | ToNumber(y); 
 * @description: Type(x) is different from Type(y) and both types vary between String (primitive or object) and Null;
 */

//CHECK#1
if (("1" | null) !== 1) {
  warn('#1: ("1" | null) === 1. Actual: ' + (("1" | null)));
}

//CHECK#2
if ((null | "1") !== 1) {
  warn('#2: (null | "1") === 1. Actual: ' + ((null | "1")));
}

//CHECK#3
if ((new String("1") | null) !== 1) {
  warn('#3: (new String("1") | null) === 1. Actual: ' + ((new String("1") | null)));
}

//CHECK#4
if ((null | new String("1")) !== 1) {
  warn('#4: (null | new String("1")) === 1. Actual: ' + ((null | new String("1"))));
}
