// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.3_A1_T3;
 * @section: 15.9.5.3;
 * @assertion: The Date.prototype property "toDateString" has { DontEnum } attributes;
 * @description: Checking DontEnum attribute;
 */

if (Date.prototype.propertyIsEnumerable('toDateString')) {
  warn('#1: The Date.prototype.toDateString property has the attribute DontEnum');
}

for(x in Date.prototype) {
  if(x === "toDateString") {
    warn('#2: The Date.prototype.toDateString has the attribute DontEnum');
  }
}

