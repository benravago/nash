// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.9.4_A5;
* @section: 15.9.4;
* @assertion: Date constructor has length property whose value is 7;
* @description: Checking Date.length property;
*/

//CHECK#1
if (!Date.hasOwnProperty("length")){
  warn('#1: Date constructor has length property');
}

//CHECK#2
if (Date.length !== 7) {
  warn('#2: Date constructor length property value should be 7');
}
