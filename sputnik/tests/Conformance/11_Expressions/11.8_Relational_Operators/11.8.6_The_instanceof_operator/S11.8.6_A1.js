// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.6_A1;
* @section: 11.8.6, 7.2, 7.3;
* @assertion: White Space and Line Terminator between RelationalExpression and "instanceof" and between "instanceof" and ShiftExpression are allowed;
* @description: Checking by using eval;
*/

//CHECK#1
if (eval("({})\u0009instanceof\u0009Object") !== true) {
  warn('#1: ({})\\u0009instanceof\\u0009Object === true');
}

//CHECK#2
if (eval("({})\u000Binstanceof\u000BObject") !== true) {
  warn('#2: ({})\\u000Binstanceof\\u000BObject === true');  
}

//CHECK#3
if (eval("({})\u000Cinstanceof\u000CObject") !== true) {
  warn('#3: ({})\\u000Cinstanceof\\u000CObject === true');
}

//CHECK#4
if (eval("({})\u0020instanceof\u0020Object") !== true) {
  warn('#4: ({})\\u0020instanceof\\u0020Object === true');
}

//CHECK#5
if (eval("({})\u00A0instanceof\u00A0Object") !== true) {
  warn('#5: ({})\\u00A0instanceof\\u00A0Object === true');
}

//CHECK#6
if (eval("({})\u000Ainstanceof\u000AObject") !== true) {
  warn('#6: ({})\\u000Ainstanceof\\u000AObject === true');  
}

//CHECK#7
if (eval("({})\u000Dinstanceof\u000DObject") !== true) {
  warn('#7: ({})\\u000Dinstanceof\\u000DObject === true');
}

//CHECK#8
if (eval("({})\u2028instanceof\u2028Object") !== true) {
  warn('#8: ({})\\u2028instanceof\\u2028Object === true');
}

//CHECK#9
if (eval("({})\u2029instanceof\u2029Object") !== true) {
  warn('#9: ({})\\u2029instanceof\\u2029Object === true');
}

//CHECK#10
if (eval("({})\u0009\u000B\u000C\u0020\u00A0\u000A\u000D\u2028\u2029instanceof\u0009\u000B\u000C\u0020\u00A0\u000A\u000D\u2028\u2029Object") !== true) {
  warn('#10: ({})\\u0009\\u000B\\u000C\\u0020\\u00A0\\u000A\\u000D\\u2028\\u2029instanceof\\u0009\\u000B\\u000C\\u0020\\u00A0\\u000A\\u000D\\u2028\\u2029Object === true');
}
