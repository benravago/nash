// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.3_A3_T2;
 * @section: 15.1.2.3, 9.3.1;
 * @assertion: If neither Result(2) nor any prefix of Result(2) satisfies the syntax of a 
 * StrDecimalLiteral (see 9.3.1), return NaN;
 * @description: parseFloat("wrong number format with ExponentIndicator") return NaN;
*/

//CHECK#1
if (isNaN(parseFloat("e1")) !== true) {
  warn('#1: parseFloat("e1") === Not-a-Number. Actual: ' + (parseFloat("e1")));
}

//CHECK#2
if (isNaN(parseFloat("e-1")) !== true) {
  warn('#2: parseFloat("e-1") === Not-a-Number. Actual: ' + (parseFloat("e-1")));
}

//CHECK#3
if (isNaN(parseFloat("E+1")) !== true) {
  warn('#3: parseFloat("E+1") === Not-a-Number. Actual: ' + (parseFloat("E+1")));
}

//CHECK#4
if (isNaN(parseFloat("E0")) !== true) {
  warn('#4: parseFloat("E0") === Not-a-Number. Actual: ' + (parseFloat("E0")));
}

//CHECK#5
if (String(parseFloat("e1")) !== "NaN") {
  warn('#5: String(parseFloat("e1")) === "NaN". Actual: ' + (String(parseFloat("e1"))));
}

//CHECK#6
if (String(parseFloat("e-1")) !== "NaN") {
  warn('#6: String(parseFloat("e-1")) === "NaN". Actual: ' + (String(parseFloat("e-1"))));
}

//CHECK#7
if (String(parseFloat("E+1")) !== "NaN") {
  warn('#73: String(parseFloat("E+1")) === "NaN". Actual: ' + (String(parseFloat("E+1"))));
}

//CHECK#8
if (String(parseFloat("E0")) !== "NaN") {
  warn('#8: String(parseFloat("E0")) === "NaN". Actual: ' + (String(parseFloat("E0"))));
}

//CHECK#9
if (isNaN(parseFloat("-.e-1")) !== true) {
  warn('#9: parseFloat("-.e-1") === Not-a-Number. Actual: ' + (parseFloat("-.e-1")));
}

//CHECK#10
if (isNaN(parseFloat(".e1")) !== true) {
  warn('#10: parseFloat(".e1") === Not-a-Number. Actual: ' + (parseFloat(".e1")));
}
