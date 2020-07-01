// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.3_A3_T1;
 * @section: 15.1.2.3, 9.3.1;
 * @assertion: If neither Result(2) nor any prefix of Result(2) satisfies the syntax of a 
 * StrDecimalLiteral (see 9.3.1), return NaN;
 * @description: parseFloat("some string") return NaN;
*/

//CHECK#1
if (isNaN(parseFloat("str")) !== true) {
  warn('#1: parseFloat("str") === Not-a-Number. Actual: ' + (parseFloat("str")));
}

//CHECK#2
if (isNaN(parseFloat("s1")) !== true) {
  warn('#2: parseFloat("s1") === Not-a-Number. Actual: ' + (parseFloat("s1")));
}

//CHECK#3
if (isNaN(parseFloat("")) !== true) {
  warn('#3: parseFloat("") === Not-a-Number. Actual: ' + (parseFloat("")));
}

//CHECK#4
if (String(parseFloat("str")) !== "NaN") {
  warn('#4: String(parseFloat("str")) === "NaN". Actual: ' + (String(parseFloat("str"))));
}

//CHECK#5
if (String(parseFloat("s1")) !== "NaN") {
  warn('#5: String(parseFloat("s1")) === "NaN". Actual: ' + (String(parseFloat("s1"))));
}

//CHECK#6
if (String(parseFloat("")) !== "NaN") {
  warn('#6: String(parseFloat("")) === "NaN". Actual: ' + (String(parseFloat(""))));
}

//CHECK#7
if (String(parseFloat("+")) !== "NaN") {
  warn('#7: String(parseFloat("+")) === "NaN". Actual: ' + (String(parseFloat("+"))));
}
