// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.2.4.3_A1;
* @section: 15.2.4.3;
* @assertion: toLocaleString function returns the result of calling toString();
* @description: Checking the type of Object.prototype.toLocaleString and the returned result;
*/

//CHECK#1
if (typeof Object.prototype.toLocaleString !== "function") {
  warn('#1: toLocaleString method defined');
}

//CHECK#2
if (Object.prototype.toLocaleString() !== Object.prototype.toString()) {
  warn('#1: toLocaleString function returns the result of calling toString()');
}

//CHECK#2
if ({}.toLocaleString()!=={}.toString()) {
  warn('#2: toLocaleString function returns the result of calling toString()');
}
