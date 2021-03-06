// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.22_A2_T1;
 * @section: 15.9.5.22;
 * @assertion: The "length" property of the "getSeconds" is 0;
 * @description: The "length" property of the "getSeconds" is 0;
 */

if(Date.prototype.getSeconds.hasOwnProperty("length") !== true){
  warn('#1: The getSeconds has a "length" property');
}

if(Date.prototype.getSeconds.length !== 0){
  warn('#2: The "length" property of the getSeconds is 0');
}

