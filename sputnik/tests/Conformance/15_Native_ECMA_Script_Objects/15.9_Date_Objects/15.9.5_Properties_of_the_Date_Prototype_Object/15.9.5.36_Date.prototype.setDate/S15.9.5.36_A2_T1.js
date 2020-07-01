// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.36_A2_T1;
 * @section: 15.9.5.36;
 * @assertion: The "length" property of the "setDate" is 1;
 * @description: The "length" property of the "setDate" is 1;
 */

if(Date.prototype.setDate.hasOwnProperty("length") !== true){
  warn('#1: The setDate has a "length" property');
}

if(Date.prototype.setDate.length !== 1){
  warn('#2: The "length" property of the setDate is 1');
}

