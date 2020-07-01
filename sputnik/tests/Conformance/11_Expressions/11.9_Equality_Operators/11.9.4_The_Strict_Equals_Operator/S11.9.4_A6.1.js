// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.4_A6.1;
 * @section: 11.9.4, 11.9.6;
 * @assertion: If Type(x) and Type(y) are Undefined-s, return true;
 * @description: void 0, eval("var x") is undefined;
*/

//CHECK#1
if (!(undefined === undefined)) {
  warn('#1: undefined === undefined');
}

//CHECK#2
if (!(void 0 === undefined)) {
  warn('#2: void 0 === undefined');
}

//CHECK#3
if (!(undefined === eval("var x"))) {
  warn('#3: undefined === eval("var x")');
}
