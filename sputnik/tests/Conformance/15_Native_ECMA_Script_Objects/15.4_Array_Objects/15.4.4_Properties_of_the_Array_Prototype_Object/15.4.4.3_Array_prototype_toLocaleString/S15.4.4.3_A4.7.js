// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.4.4.3_A4.7;
* @section: 15.4.4.3, 11.2.2;
* @assertion: The toLocaleString property of Array can't be used as constructor;
* @description: If property does not implement the internal [[Construct]] method, throw a TypeError exception;
*/

//CHECK#1

try {
  new Array.prototype.toLocaleString();
  warn('#1.1: new Array.prototype.toLocaleString() throw TypeError. Actual: ' + (new Array.prototype.toLocaleString()));
} catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#1.2: new Array.prototype.toLocaleString() throw TypeError. Actual: ' + (e));
  }
}
