// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.1_A2_T1;
 * @section: 15.9.5.1;
 * @assertion: The "length" property of the "constructor" is 7;
 * @description: The "length" property of the "constructor" is 7;
 */

if(Date.prototype.constructor.hasOwnProperty("length") !== true){
  warn('#1: The constructor has a "length" property');
}

if(Date.prototype.constructor.length !== 7){
  warn('#2: The "length" property of the constructor is 7');
}

