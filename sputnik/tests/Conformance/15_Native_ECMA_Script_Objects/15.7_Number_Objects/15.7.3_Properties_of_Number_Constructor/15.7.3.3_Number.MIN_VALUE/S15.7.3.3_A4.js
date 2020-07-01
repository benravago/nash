// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.7.3.3_A4;
 * @section: 15.7.3.3;
 * @assertion: Number.MIN_VALUE has the attribute DontEnum;
 * @description: Checking if enumerating Number.MIN_VALUE fails;
*/

//CHECK#1
for(var x in Number) {
  if(x === "MIN_VALUE") {
    warn('#1: Number.MIN_VALUE has the attribute DontEnum');
  }
}

if (Number.propertyIsEnumerable('MIN_VALUE')) {
  warn('#2: Number.MIN_VALUE has the attribute DontEnum');
}
