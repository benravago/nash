// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.3.1_A6_T1;
 * @section: 9.3.1, 15.7.1;
 * @assertion: The MV of StrUnsignedDecimalLiteral::: Infinity is 10<sup><small>10000</small></sup> 
 * (a value so large that it will round to <b><tt>+&infin;</tt></b>);
 * @description: Compare Number('Infinity') with Number.POSITIVE_INFINITY, 10e10000, 10E10000 and Number("10e10000");
*/

// CHECK#1
if (Number("Infinity") !== Number.POSITIVE_INFINITY) {
  warn('#1: Number("Infinity") === Number.POSITIVE_INFINITY');
}

// CHECK#2
if (Number("Infinity") !== 10e10000) {
  warn('#2: Number("Infinity") === 10e10000');
}

// CHECK#3
if (Number("Infinity") !== 10E10000) {
  warn('#3: Number("Infinity") === 10E10000');
}

// CHECK#4
if (Number("Infinity") !== Number("10e10000")) {
  warn('#4: Number("Infinity") === Number("10e10000")');
}
