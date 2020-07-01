// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.3_A3_T3;
 * @section: 15.9.5.3;
 * @assertion: The Date.prototype.toDateString property "length" has { ReadOnly, DontDelete, DontEnum } attributes;
 * @description: Checking DontEnum attribute;
 */

if (Date.prototype.toDateString.propertyIsEnumerable('length')) {
  warn('#1: The Date.prototype.toDateString.length property has the attribute DontEnum');
}

for(x in Date.prototype.toDateString) {
  if(x === "length") {
    warn('#2: The Date.prototype.toDateString.length has the attribute DontEnum');
  }
}

