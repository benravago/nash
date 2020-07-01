// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.3_A4_T2;
 * @section: 15.1.2.3, 9.3.1;
 * @assertion: Compute the longest prefix of Result(2), which might be Result(2) itself, 
 * which satisfies the syntax of a StrDecimalLiteral;
 * @description: With ExponentIndicator;
*/

//CHECK#1
if (parseFloat("1ex") !== 1) {
  warn('#1: parseFloat("1ex") === 1. Actual: ' + (parseFloat("1ex")));
}

//CHECK#2
if (parseFloat("1e-x") !== 1) {
  warn('#2: parseFloat("1e-x") === 1. Actual: ' + (parseFloat("1e-x")));
}

//CHECK#3
if (parseFloat("1e1x") !== 10) {
  warn('#3: parseFloat("1e1x") === 10. Actual: ' + (parseFloat("1e1x")));
}

//CHECK#4
if (parseFloat("1e-1x") !== 0.1) {
  warn('#4: parseFloat("1e-1x") === 0.1. Actual: ' + (parseFloat("1e-1x")));
}

//CHECK#5
if (parseFloat("0.1e-1x") !== 0.01) {
  warn('#5: parseFloat("0.1e-1x") === 0.01. Actual: ' + (parseFloat("0.1e-1x")));
}
