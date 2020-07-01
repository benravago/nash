// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.2_A1.1;
* @section: 11.2.2, 7.2, 7.3;
* @assertion: White Space and Line Terminator between "new" and NewExpression are allowed;
* @description: Checking by using eval;
*/

//CHECK#1
if (eval("new\u0009Number") != 0) {
  warn('#1: new\\u0009Number == 0');
}

//CHECK#2
if (eval("new\u000BNumber") != 0) {
  warn('#2: new\\u000BNumber == 0');  
}

//CHECK#3
if (eval("new\u000CNumber") != 0) {
  warn('#3: new\\u000CNumber == 0');
}

//CHECK#4
if (eval("new\u0020Number") != 0) {
  warn('#4: new\\u0020Number == 0');
}

//CHECK#5
if (eval("new\u00A0Number") != 0) {
  warn('#5: new\\u00A0Number == 0');
}

//CHECK#6
if (eval("new\u000ANumber") != 0) {
  warn('#6: new\\u000ANumber == 0');  
}

//CHECK#7
if (eval("new\u000DNumber") != 0) {
  warn('#7: new\\u000DNumber == 0');
}

//CHECK#8
if (eval("new\u2028Number") != 0) {
  warn('#8: new\\u2028Number == 0');
}

//CHECK#9
if (eval("new\u2029Number") != 0) {
  warn('#9: new\\u2029Number == 0');
}

//CHECK#10
if (eval("new\u0009\u000B\u000C\u0020\u00A0\u000A\u000D\u2028\u2029Number") != 0) {
  warn('#10: new\\u0009\\u000B\\u000C\\u0020\\u00A0\\u000A\\u000D\\u2028\\u2029Number == 0');
}
