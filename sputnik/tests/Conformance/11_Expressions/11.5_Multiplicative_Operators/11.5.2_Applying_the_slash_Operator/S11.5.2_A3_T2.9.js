// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.5.2_A3_T2.9;
 * @section: 11.5.2;
 * @assertion: Operator x / y returns ToNumber(x) / ToNumber(y); 
 * @description: Type(x) is different from Type(y) and both types vary between Boolean (primitive or object) and Null;
 */

//CHECK#1
if (true / null !== Number.POSITIVE_INFINITY) {
  warn('#1: true / null === +Infinity. Actual: ' + (true / null));
}

//CHECK#2
if (null / true !== 0) {
  warn('#2: null / true === 0. Actual: ' + (null / true));
}

//CHECK#3
if (new Boolean(true) / null !== Number.POSITIVE_INFINITY) {
  warn('#3: new Boolean(true) / null === +Infinity. Actual: ' + (new Boolean(true) / null));
}

//CHECK#4
if (null / new Boolean(true) !== 0) {
  warn('#4: null / new Boolean(true) === 0. Actual: ' + (null / new Boolean(true)));
}
