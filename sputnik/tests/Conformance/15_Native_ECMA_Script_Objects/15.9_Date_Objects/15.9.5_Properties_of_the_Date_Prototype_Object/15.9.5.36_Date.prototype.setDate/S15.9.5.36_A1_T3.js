// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.36_A1_T3;
 * @section: 15.9.5.36;
 * @assertion: The Date.prototype property "setDate" has { DontEnum } attributes;
 * @description: Checking DontEnum attribute;
 */

if (Date.prototype.propertyIsEnumerable('setDate')) {
  warn('#1: The Date.prototype.setDate property has the attribute DontEnum');
}

for(x in Date.prototype) {
  if(x === "setDate") {
    warn('#2: The Date.prototype.setDate has the attribute DontEnum');
  }
}

