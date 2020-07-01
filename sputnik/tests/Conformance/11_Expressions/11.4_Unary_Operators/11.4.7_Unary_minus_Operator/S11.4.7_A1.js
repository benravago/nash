// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.4.7_A1;
* @section: 11.4.7, 7.2, 7.3;
* @assertion: White Space and Line Terminator between "-" and UnaryExpression are allowed;
* @description: Checking by using eval;
*/

//CHECK#1
if (eval("-\u00091") !== -1) {
  warn('#1: -\\u00091 === -1');
}

//CHECK#2
if (eval("-\u000B1") !== -1) {
  warn('#2: -\\u000B1 === -1');  
}

//CHECK#3
if (eval("-\u000C1") !== -1) {
  warn('#3: -\\u000C1 === -1');
}

//CHECK#4
if (eval("-\u00201") !== -1) {
  warn('#4: -\\u0020 === -1');
}

//CHECK#5
if (eval("-\u00A01") !== -1) {
  warn('#5: -\\u00A01 === -1');
}

//CHECK#6
if (eval("-\u000A1") !== -1) {
  warn('#6: -\\u000A1 === -1');  
}

//CHECK#7
if (eval("-\u000D1") !== -1) {
  warn('#7: -\\u000D1 === -1');
}

//CHECK#8
if (eval("-\u20281") !== -1) {
  warn('#8: -\\u20281 === -1');
}

//CHECK#9
if (eval("-\u20291") !== -1) {
  warn('#9: -\\u20291 === -1');
}

//CHECK#10
if (eval("-\u0009\u000B\u000C\u0020\u00A0\u000A\u000D\u2028\u20291") !== -1) {
  warn('#10: -\\u0009\\u000B\\u000C\\u0020\\u00A0\\u000A\\u000D\\u2028\\u20291 === -1');
}
