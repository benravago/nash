// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.10.1_A3_T1.4;
 * @section: 11.10.1;
 * @assertion: Operator x & y returns ToNumber(x) & ToNumber(y); 
 * @description: Type(x) and Type(y) are null and undefined;
*/

//CHECK#1
if ((null & undefined) !== 0) {
  warn('#1: (null & undefined) === 0. Actual: ' + ((null & undefined)));
}

//CHECK#2
if ((undefined & null) !== 0) {
  warn('#2: (undefined & null) === 0. Actual: ' + ((undefined & null)));
}

//CHECK#3
if ((undefined & undefined) !== 0) {
  warn('#3: (undefined & undefined) === 0. Actual: ' + ((undefined & undefined)));
}

//CHECK#4
if ((null & null) !== 0) {
  warn('#4: (null & null) === 0. Actual: ' + ((null & null)));
}
