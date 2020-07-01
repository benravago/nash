// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.4.3_A1;
* @section: 11.4.3;
* @assertion: White Space and Line Terminator between "typeof" and UnaryExpression are allowed;
* @description: Checking by using eval;
*/

//CHECK#1
if (eval("var x = 0; typeof\u0009x") !== "number") {
  warn('#1: var x = 0; typeof\\u0009x; x === "number". Actual: ' + (x));
}

//CHECK#2
if (eval("var x = 0; typeof\u000Bx") !== "number") {
  warn('#2: var x = 0; typeof\\u000Bx; x === "number". Actual: ' + (x));  
}

//CHECK#3
if (eval("var x = 0; typeof\u000Cx") !== "number") {
  warn('#3: var x = 0; typeof\\u000Cx; x === "number". Actual: ' + (x));
}

//CHECK#4
if (eval("var x = 0; typeof\u0020x") !== "number") {
  warn('#4: var x = 0; typeof\\u0020x; x === "number". Actual: ' + (x));
}

//CHECK#5
if (eval("var x = 0; typeof\u00A0x") !== "number") {
  warn('#5: var x = 0; typeof\\u00A0x; x === "number". Actual: ' + (x));
}

//CHECK#6
if (eval("var x = 0; typeof\u000Ax") !== "number") {
  warn('#6: var x = 0; typeof\\u000Ax; x === "number". Actual: ' + (x));  
}

//CHECK#7
if (eval("var x = 0; typeof\u000Dx") !== "number") {
  warn('#7: var x = 0; typeof\\u000Dx; x === "number". Actual: ' + (x));
}

//CHECK#8
if (eval("var x = 0; typeof\u2028x") !== "number") {
  warn('#8: var x = 0; typeof\\u2028x; x === "number". Actual: ' + (x));
}

//CHECK#9
if (eval("var x = 0; typeof\u2029x") !== "number") {
  warn('#9: var x = 0; typeof\\u2029x; x === "number". Actual: ' + (x));
}

//CHECK#10
if (eval("var x = 0; typeof\u0009\u000B\u000C\u0020\u00A0\u000A\u000D\u2028\u2029x") !== "number") {
  warn('#10: var x = 0; typeof\\u0009\\u000B\\u000C\\u0020\\u00A0\\u000A\\u000D\\u2028\\u2029x; x === "number". Actual: ' + (x));
}
