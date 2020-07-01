// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.6_A3_T3;
 * @section: 15.9.5.6;
 * @assertion: The Date.prototype.toLocaleDateString property "length" has { ReadOnly, DontDelete, DontEnum } attributes;
 * @description: Checking DontEnum attribute;
 */

if (Date.prototype.toLocaleDateString.propertyIsEnumerable('length')) {
  warn('#1: The Date.prototype.toLocaleDateString.length property has the attribute DontEnum');
}

for(x in Date.prototype.toLocaleDateString) {
  if(x === "length") {
    warn('#2: The Date.prototype.toLocaleDateString.length has the attribute DontEnum');
  }
}

