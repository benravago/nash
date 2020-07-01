// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.3_A4_T5;
 * @section: 15.1.2.3, 9.3.1;
 * @assertion: Compute the longest prefix of Result(2), which might be Result(2) itself, 
 * which satisfies the syntax of a StrDecimalLiteral;
 * @description: Checking DecimalDigits . DecimalDigits_opt ExponentPart_opt; 
*/

//CHECK#1
if (parseFloat("-11.string") !== -11) {
  warn('#1: parseFloat("-11.string") === -11. Actual: ' + (parseFloat("-11.string")));
}

//CHECK#2
if (parseFloat("01.string") !== 1) {
  warn('#2: parseFloat("01.string") === 1. Actual: ' + (parseFloat("01.string")));
}

//CHECK#3
if (parseFloat("+11.1string") !== 11.1) {
  warn('#3: parseFloat("+11.1string") === 11.1. Actual: ' + (parseFloat("+11.1string")));
}

//CHECK#4
if (parseFloat("01.1string") !== 1.1) {
  warn('#4: parseFloat("01.1string") === 1.1. Actual: ' + (parseFloat("01.1string")));
}

//CHECK#5
if (parseFloat("-11.e-1string") !== -1.1) {
  warn('#5: parseFloat("-11.e-1string") === -1.1. Actual: ' + (parseFloat("-11.e-1string")));
}

//CHECK#6
if (parseFloat("01.e1string") !== 10) {
  warn('#6: parseFloat("01.e1string") === 10. Actual: ' + (parseFloat("01.e1string")));
}

//CHECK#7
if (parseFloat("+11.22e-1string") !== 1.122) {
  warn('#7: parseFloat("+11.22e-1string") === 1.122. Actual: ' + (parseFloat("+11.22e-1string")));
}

//CHECK#8
if (parseFloat("01.01e1string") !== 10.1) {
  warn('#8: parseFloat("01.01e1string") === 10.1. Actual: ' + (parseFloat("01.01e1string")));
}

//CHECK#9
if (parseFloat("001.string") !== 1) {
  warn('#9: parseFloat("001.string") === 1. Actual: ' + (parseFloat("001.string")));
}

//CHECK#10
if (parseFloat("010.string") !== 10) {
  warn('#10: parseFloat("010.string") === 10. Actual: ' + (parseFloat("010.string")));
}
