// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.3.4.3_A8_T4;
* @section: 15.3.4.3;
* @assertion: Function.prototype.apply can`t be used as [[create]] caller;
* @description: Checking if creating "new (Function("this.p1=1").apply)" fails;
*/

try {
  obj = new (Function("this.p1=1").apply);
  warn('#1: Function.prototype.apply can\'t be used as [[create]] caller');
} catch (e) {
  if (!(e instanceof TypeError)) {
  	warn('#1.1: Function.prototype.apply can\'t be used as [[create]] caller');
  }
}
