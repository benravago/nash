// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.12_A2_T1;
 * @section: 15.9.5.12;
 * @assertion: The "length" property of the "getMonth" is 0;
 * @description: The "length" property of the "getMonth" is 0;
 */

if(Date.prototype.getMonth.hasOwnProperty("length") !== true){
  warn('#1: The getMonth has a "length" property');
}

if(Date.prototype.getMonth.length !== 0){
  warn('#2: The "length" property of the getMonth is 0');
}

