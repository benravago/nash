// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.9.5.28_A1_T3;
 * @section: 15.9.5.28;
 * @assertion: The Date.prototype property "setMilliseconds" has { DontEnum } attributes;
 * @description: Checking DontEnum attribute;
 */

if (Date.prototype.propertyIsEnumerable('setMilliseconds')) {
  warn('#1: The Date.prototype.setMilliseconds property has the attribute DontEnum');
}

for(x in Date.prototype) {
  if(x === "setMilliseconds") {
    warn('#2: The Date.prototype.setMilliseconds has the attribute DontEnum');
  }
}

