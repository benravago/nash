// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S8.1_A4;
 * @section: 8.1;
 * @assertion: If property of object not exist, return undefined;
 * @description: Check value of not existed property;
*/

// CHECK#1 
if ((new Object()).newProperty !== undefined) {
  warn('#1: (new Object()).newProperty === undefined. Actual: ' + ((new Object()).newProperty));
} 

