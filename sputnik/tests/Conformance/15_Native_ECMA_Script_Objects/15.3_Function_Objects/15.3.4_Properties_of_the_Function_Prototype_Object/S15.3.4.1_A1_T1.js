// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.3.4.1_A1_T1;
* @section: 15.3.4.1;
* @assertion: The initial value of Function.prototype.constructor is the built-in Function constructor;
* @description: Checking Function.prototype.constructor;
*/

//CHECK#1
if (Function.prototype.constructor !== Function) {
  warn('#1: The initial value of Function.prototype.constructor is the built-in Function constructor');
}
