// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.2_A6.1;
 * @section: 11.9.2, 11.9.3;
 * @assertion: If Type(x) as well as Type(y) is Undefined or Null, return true;
 * @description: Checking all combinations;
*/

//CHECK#1
if ((undefined != undefined) !== false) {
  warn('#1: (undefined != undefined) === false');
}

//CHECK#2
if ((void 0 != undefined) !== false) {
  warn('#2: (void 0 != undefined) === false');
}

//CHECK#3
if ((undefined != eval("var x")) !== false) {
  warn('#3: (undefined != eval("var x")) === false');
}

//CHECK#4
if ((undefined != null) !== false) {
  warn('#4: (undefined != null) === false');
}

//CHECK#5
if ((null != void 0) !== false) {
  warn('#5: (null != void 0) === false');
}

//CHECK#6
if ((null != null) !== false) {
  warn('#6: (null != null) === false');
}
