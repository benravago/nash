// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.2_A6.2_T1;
 * @section: 11.9.2, 11.9.3;
 * @assertion: If one expression is undefined or null and another is not, return false;
 * @description: x is null or undefined, y is not;   
*/

//CHECK#1
if ((undefined != true) !== true) {
  warn('#1: (undefined != true) === true');
}

//CHECK#2
if ((undefined != 0) !== true) {
  warn('#2: (undefined != 0) === true');
}

//CHECK#3
if ((undefined != "undefined") !== true) {
  warn('#3: (undefined != "undefined") === true');
}

//CHECK#4
if ((undefined != {}) !== true) {
  warn('#4: (undefined != {}) === true');
}

//CHECK#5
if ((null != false) !== true) {
  warn('#5: (null != false) === true');
}

//CHECK#6
if ((null != 0) !== true) {
  warn('#6: (null != 0) === true');
}

//CHECK#7
if ((null != "null") !== true) {
  warn('#7: (null != "null") === true');
}

//CHECK#8
if ((null != {}) !== true) {
  warn('#8: (null != {}) === true');
}
