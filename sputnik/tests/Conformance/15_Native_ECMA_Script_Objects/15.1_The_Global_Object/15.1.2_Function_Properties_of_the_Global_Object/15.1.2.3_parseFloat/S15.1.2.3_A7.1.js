// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.3_A7.1;
 * @section: 15.1.2.3, 15.2.4.7, 12.6.4;
 * @assertion: The length property of parseFloat has the attribute DontEnum;
 * @description: Checking use propertyIsEnumerable, for-in;
*/


//CHECK#1
if (parseFloat.propertyIsEnumerable('length') !== false) {
  warn('#1: parseFloat.propertyIsEnumerable(\'length\') === false. Actual: ' + (parseFloat.propertyIsEnumerable('length')));
}

//CHECK#2
var result = true;
for (var p in parseFloat){
  if (p === "length") {
    result = false;
  }  
}

if (result !== true) {
  warn('#2: result = true; for (p in parseFloat) { if (p === "length") result = false; }  result === true;');
}
