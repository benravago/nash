// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.3_A1_T6;
 * @section: 15.1.2.3, 9.8;
 * @assertion: Operator use ToString;
 * @description: Checking for String object;  
*/

//CHECK#1
if (parseFloat(new String("-1.1")) !== parseFloat("-1.1")) {
  warn('#1: parseFloat(new String("-1.1")) === parseFloat("-1.1"). Actual: ' + (parseFloat(new String("-1.1"))));
}

//CHECK#2
if (parseFloat(new String("Infinity")) !== parseFloat("Infinity")) {
  warn('#2: parseFloat(new String("Infinity")) === parseFloat("Infinity"). Actual: ' + (parseFloat(new String("Infinity"))));
}

//CHECK#3
if (String(parseFloat(new String("NaN"))) !== "NaN") {
  warn('#3: String(parseFloat(new String("NaN"))) === "NaN". Actual: ' + (String(parseFloat(new String("NaN")))));
}

//CHECK#4
if (parseFloat(new String(".01e+2")) !== parseFloat(".01e+2")) {
  warn('#4: parseFloat(new String(".01e+2")) === parseFloat(".01e+2"). Actual: ' + (parseFloat(new String(".01e+2"))));
}

//CHECK#5
if (String(parseFloat(new String("false"))) !== "NaN") {
  warn('#5: String(parseFloat(new String("false"))) === "NaN". Actual: ' + (String(parseFloat(new String("false")))));
}
