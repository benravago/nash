// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.1_A4.5;
 * @section: 15.1.2.1, 15.2.4.7, 12.6.4;
 * @assertion: The eval property has the attribute DontEnum;
 * @description: Checking use propertyIsEnumerable, for-in;
*/


//CHECK#1
if (this.propertyIsEnumerable('eval') !== false) {
  warn('#1: this.propertyIsEnumerable(\'eval\') === false. Actual: ' + (this.propertyIsEnumerable('eval')));
}

//CHECK#2
var result = true;
for (var p in this){
  if (p === "eval") {
    result = false;
  }  
}

if (result !== true) {
  warn('#2: result = true; for (p in this) { if (p === "eval") result = false; }  result === true;');
}
