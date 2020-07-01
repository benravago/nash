// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A1_T5;
 * @section: 15.1.2.2, 9.8;
 * @assertion: Operator use ToString;
 * @description: Checking for Number object;  
*/

//CHECK#1
if (parseInt(new Number(-1)) !== parseInt("-1")) {
  warn('#1: parseInt(new Number(-1)) === parseInt("-1"). Actual: ' + (parseInt(new Number(-1))));
}

//CHECK#2
if (String(parseInt(new Number(Infinity))) !== "NaN") {
  warn('#2: String(parseInt(new Number(Infinity))) === "NaN". Actual: ' + (String(parseInt(new Number(Infinity)))));
}

//CHECK#3
if (String(parseInt(new Number(NaN))) !== "NaN") {
  warn('#3: String(parseInt(new Number(NaN))) === "NaN". Actual: ' + (String(parseInt(new Number(NaN)))));
}
