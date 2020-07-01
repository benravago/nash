// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.24_A3_T3;
 * @section: 15.9.5.24;
 * @assertion: The Date.prototype.getMilliseconds property "length" has { ReadOnly, DontDelete, DontEnum } attributes;
 * @description: Checking DontEnum attribute;
 */

if (Date.prototype.getMilliseconds.propertyIsEnumerable('length')) {
  warn('#1: The Date.prototype.getMilliseconds.length property has the attribute DontEnum');
}

for(x in Date.prototype.getMilliseconds) {
  if(x === "length") {
    warn('#2: The Date.prototype.getMilliseconds.length has the attribute DontEnum');
  }
}

