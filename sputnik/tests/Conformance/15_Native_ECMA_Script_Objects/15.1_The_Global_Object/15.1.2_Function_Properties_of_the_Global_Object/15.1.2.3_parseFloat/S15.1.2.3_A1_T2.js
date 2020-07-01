// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.3_A1_T2;
 * @section: 15.1.2.3, 9.8;
 * @assertion: Operator use ToString;
 * @description: Checking for number primitive;  
*/

//CHECK#1
if (parseFloat(-1.1) !== parseFloat("-1.1")) {
  warn('#1: parseFloat(-1.1) === parseFloat("-1.1"). Actual: ' + (parseFloat(-1.1)));
}

//CHECK#2
if (parseFloat(Infinity) !== parseFloat("Infinity")) {
  warn('#2: parseFloat(Infinity) === parseFloat("Infinity"). Actual: ' + (parseFloat(Infinity)));
}

//CHECK#3
if (String(parseFloat(NaN)) !== "NaN") {
  warn('#3: String(parseFloat(NaN)) === "NaN". Actual: ' + (String(parseFloat(NaN))));
}

//CHECK#4
if (parseFloat(.01e+2) !== parseFloat(".01e+2")) {
  warn('#4: parseFloat(.01e+2) === parseFloat(".01e+2"). Actual: ' + (parseFloat(.01e+2)));
}

//CHECK#5
if (parseFloat(-0) !== 0) {
  warn('#5: parseFloat(-0) === 0. Actual: ' + (parseFloat(-0)));
} else {
  if (1 / parseFloat(-0) !== Number.POSITIVE_INFINITY) {
    warn('#5: parseFloat(-0) === +0. Actual: ' + (parseFloat(-0)));
  }
}    
