// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.13_A2_T1;
 * @section: 15.9.5.13;
 * @assertion: The "length" property of the "getUTCMonth" is 0;
 * @description: The "length" property of the "getUTCMonth" is 0;
 */

if(Date.prototype.getUTCMonth.hasOwnProperty("length") !== true){
  warn('#1: The getUTCMonth has a "length" property');
}

if(Date.prototype.getUTCMonth.length !== 0){
  warn('#2: The "length" property of the getUTCMonth is 0');
}

