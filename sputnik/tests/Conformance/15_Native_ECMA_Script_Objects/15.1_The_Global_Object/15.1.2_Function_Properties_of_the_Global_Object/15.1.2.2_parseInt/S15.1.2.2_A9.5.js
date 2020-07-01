// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A9.5;
 * @section: 15.1.2.2, 15.2.4.7, 12.6.4;
 * @assertion: The parseInt property has the attribute DontEnum;
 * @description: Checking use propertyIsEnumerable, for-in;
*/


//CHECK#1
if (this.propertyIsEnumerable('parseInt') !== false) {
  warn('#1: this.propertyIsEnumerable(\'parseInt\') === false. Actual: ' + (this.propertyIsEnumerable('parseInt')));
}

//CHECK#2
var result = true;
for (var p in this){
  if (p === "parseInt") {
    result = false;
  }  
}

if (result !== true) {
  warn('#2: result = true; for (p in this) { if (p === "parseInt") result = false; }  result === true;');
}
