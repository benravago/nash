// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.10.2.11_A1_T4;
 * @section: 15.10.2.11, 15.10.2.9;
 * @assertion: DecimalEscape :: DecimalIntegerLiteral [lookahead not in DecimalDigit];
 * @description: DecimalIntegerLiteral is not 0;
*/

var arr = /(A)\1/.exec("AA");

//CHECK#1
if ((arr === null) || (arr[0] !== "AA")) {
  warn('#1: var arr = (/(A)\\1/.exec("AA")); arr[0] === "AA". Actual. ' + (arr && arr[0]));
}

//CHECK#2
if ((arr === null) || (arr[1] !== "A")) {
  warn('#2: var arr = (/(A)\\1/.exec("AA")); arr[1] === "A". Actual. ' + (arr && arr[1]));
}    
