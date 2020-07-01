// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.3_A1_T3;
 * @section: 15.1.2.3, 9.8;
 * @assertion: Operator use ToString;
 * @description: Checking for undefined and null;  
*/

//CHECK#1
if (!(isNaN(parseFloat(undefined)) && isNaN(parseFloat("NaN")))) {
  warn('#1: parseFloat(undefined) === Not-a-Number; parseFloat("NaN") === Not-a-Number. Actual: ' + (parseFloat("NaN")));
}

//CHECK#2
if (!(isNaN(parseFloat(null)) && isNaN(parseFloat("NaN")))) {
  warn('#2: parseFloat(null) === Not-a-Number; parseFloat("NaN") === Not-a-Number. Actual: ' + (parseFloat("NaN")));
}


//CHECK#3
if (String(parseFloat(undefined)) !== "NaN") {
  warn('#3: String(parseFloat(undefined)) === "NaN". Actual: ' + (String(parseFloat(undefined))));
}

//CHECK#4
if (String(parseFloat(null)) !== "NaN") {
  warn('#4: String(parseFloat(null)) === "NaN". Actual: ' + (String(parseFloat(null))));
}
