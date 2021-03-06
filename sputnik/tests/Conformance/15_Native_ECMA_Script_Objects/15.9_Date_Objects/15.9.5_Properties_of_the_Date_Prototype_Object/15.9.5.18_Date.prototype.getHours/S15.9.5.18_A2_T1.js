// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.18_A2_T1;
 * @section: 15.9.5.18;
 * @assertion: The "length" property of the "getHours" is 0;
 * @description: The "length" property of the "getHours" is 0;
 */

if(Date.prototype.getHours.hasOwnProperty("length") !== true){
  warn('#1: The getHours has a "length" property');
}

if(Date.prototype.getHours.length !== 0){
  warn('#2: The "length" property of the getHours is 0');
}

