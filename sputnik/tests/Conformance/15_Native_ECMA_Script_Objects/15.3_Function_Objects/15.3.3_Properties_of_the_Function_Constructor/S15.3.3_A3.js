// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.3.3_A3;
* @section: 15.3.3, 15.3.4;
* @assertion: Function constructor has length property whose value is 1;
* @description: Checking Function.length property;
*/

//CHECK#1
if (!Function.hasOwnProperty("length")){
  warn('#1: Function constructor has length property');
}

//CHECK#2
if (Function.length !== 1) {
  warn('#2: Function constructor length property value is 1');
}
