// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.3_A2_T1;
 * @section: 15.9.5.3;
 * @assertion: The "length" property of the "toDateString" is 0;
 * @description: The "length" property of the "toDateString" is 0;
 */

if(Date.prototype.toDateString.hasOwnProperty("length") !== true){
  warn('#1: The toDateString has a "length" property');
}

if(Date.prototype.toDateString.length !== 0){
  warn('#2: The "length" property of the toDateString is 0');
}

