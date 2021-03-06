// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A9.1;
 * @section: 15.1.2.2, 15.2.4.7, 12.6.4;
 * @assertion: The length property of parseInt has the attribute DontEnum;
 * @description: Checking use propertyIsEnumerable, for-in;
*/


//CHECK#1
if (parseInt.propertyIsEnumerable('length') !== false) {
  warn('#1: parseInt.propertyIsEnumerable(\'length\') === false. Actual: ' + (parseInt.propertyIsEnumerable('length')));
}

//CHECK#2
var result = true;
for (var p in parseInt){
  if (p === "length") {
    result = false;
  }  
}

if (result !== true) {
  warn('#2: result = true; for (p in parseInt) { if (p === "length") result = false; }  result === true;');
}
