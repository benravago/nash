// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.6.3.1_A4;
 * @section: 15.6.3.1;
 * @assertion: Boolean.prototype has the attribute DontEnum;
 * @description: Checking if enumerating the Boolean.prototype property fails;
 */

//CHECK#1
for(x in Boolean) {
  if(x === "prototype") {
    warn('#1: Boolean.prototype has the attribute DontEnum');
  }
}

if (Boolean.propertyIsEnumerable('prototype')) {
  warn('#2: Boolean.prototype has the attribute DontEnum');
}
