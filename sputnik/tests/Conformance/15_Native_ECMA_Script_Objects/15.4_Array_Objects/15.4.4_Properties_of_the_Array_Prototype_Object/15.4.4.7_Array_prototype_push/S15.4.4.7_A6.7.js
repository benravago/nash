// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.4.4.7_A6.7;
* @section: 15.4.4.7, 11.2.2;
* @assertion: The push property of Array can't be used as constructor;
* @description: If property does not implement the internal [[Construct]] method, throw a TypeError exception;
*/

//CHECK#1

try {
  new Array.prototype.push();
  warn('#1.1: new Array.prototype.push() throw TypeError. Actual: ' + (new Array.prototype.push()));
} catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#1.2: new Array.prototype.push() throw TypeError. Actual: ' + (e));
  }
}
