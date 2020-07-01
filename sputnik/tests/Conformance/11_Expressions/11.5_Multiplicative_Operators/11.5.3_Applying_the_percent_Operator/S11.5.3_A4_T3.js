// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.5.3_A4_T3;
 * @section: 11.5.3;
 * @assertion: The result of a ECMAScript floating-point remainder operation is determined by the rules of IEEE arithmetics; 
 * @description: If the dividend is an infinity results is NaN;
 */

//CHECK#1
if (isNaN(Number.NEGATIVE_INFINITY % Number.POSITIVE_INFINITY) !== true) {
  warn('#1: -Infinity % Infinity === Not-a-Number. Actual: ' + (-Infinity % Infinity));
}

//CHECK#2
if (isNaN(Number.NEGATIVE_INFINITY % Number.NEGATIVE_INFINITY) !== true) {
  warn('#2: -Infinity % -Infinity === Not-a-Number. Actual: ' + (-Infinity % -Infinity));
}

//CHECK#3
if (isNaN(Number.POSITIVE_INFINITY % Number.POSITIVE_INFINITY) !== true) {
  warn('#3: Infinity % Infinity === Not-a-Number. Actual: ' + (Infinity % Infinity));
}

//CHECK#4
if (isNaN(Number.POSITIVE_INFINITY % Number.NEGATIVE_INFINITY) !== true) {
  warn('#4: Infinity % -Infinity === Not-a-Number. Actual: ' + (Infinity % -Infinity));
}

//CHECK#5
if (isNaN(Number.NEGATIVE_INFINITY % 1) !== true) {
  warn('#5: Infinity % 1 === Not-a-Number. Actual: ' + (Infinity % 1));
}

//CHECK#6
if (isNaN(Number.NEGATIVE_INFINITY % -1) !== true) {
  warn('#6: -Infinity % -1 === Not-a-Number. Actual: ' + (-Infinity % -1));
}

//CHECK#7
if (isNaN(Number.POSITIVE_INFINITY % 1) !== true) {
  warn('#7: Infinity % 1 === Not-a-Number. Actual: ' + (Infinity % 1));
}

//CHECK#8
if (isNaN(Number.POSITIVE_INFINITY % -1) !== true) {
  warn('#8: Infinity % -1 === Not-a-Number. Actual: ' + (Infinity % -1));
}

//CHECK#9
if (isNaN(Number.NEGATIVE_INFINITY % Number.MAX_VALUE) !== true) {
  warn('#9: Infinity % Number.MAX_VALUE === Not-a-Number. Actual: ' + (Infinity % Number.MAX_VALUE));
}

//CHECK#10
if (isNaN(Number.NEGATIVE_INFINITY % -Number.MAX_VALUE) !== true) {
  warn('#10: -Infinity % -Number.MAX_VALUE === Not-a-Number. Actual: ' + (-Infinity % -Number.MAX_VALUE));
}

//CHECK#11
if (isNaN(Number.POSITIVE_INFINITY % Number.MAX_VALUE) !== true) {
  warn('#11: Infinity % Number.MAX_VALUE === Not-a-Number. Actual: ' + (Infinity % Number.MAX_VALUE));
}

//CHECK#12
if (isNaN(Number.POSITIVE_INFINITY % -Number.MAX_VALUE) !== true) {
  warn('#12: Infinity % -Number.MAX_VALUE === Not-a-Number. Actual: ' + (Infinity % -Number.MAX_VALUE));
}
