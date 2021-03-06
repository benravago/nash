// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.27_A1_T3;
 * @section: 15.9.5.27;
 * @assertion: The Date.prototype property "setTime" has { DontEnum } attributes;
 * @description: Checking DontEnum attribute;
 */

if (Date.prototype.propertyIsEnumerable('setTime')) {
  warn('#1: The Date.prototype.setTime property has the attribute DontEnum');
}

for(x in Date.prototype) {
  if(x === "setTime") {
    warn('#2: The Date.prototype.setTime has the attribute DontEnum');
  }
}

