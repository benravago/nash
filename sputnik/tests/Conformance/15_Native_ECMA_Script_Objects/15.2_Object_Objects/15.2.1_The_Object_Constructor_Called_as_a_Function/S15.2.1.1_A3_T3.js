// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.2.1.1_A3_T3;
* @section: 15.2.1.1;
* @assertion: Since calling Object as a function is identical to calling a function, list of arguments bracketing is allowed;
* @description: Creating an object with "Object((null,2,3),1,2)";
*/

var obj = Object((null,2,3),1,2);

//CHECK#1
if (obj.constructor !== Number) {
  warn('#1: Since Object as a function calling is the same as function calling list of arguments can appears in braces;');
}

//CHECK#2
if (typeof obj !== "object") {
  warn('#2: Since Object as a function calling is the same as function calling list of arguments can appears in braces;');
}

//CHECK#3
if ((obj != 3)||(obj === 3)) {
  warn('3#: Since Object as a function calling is the same as function calling list of arguments can appears in braces;');
}
