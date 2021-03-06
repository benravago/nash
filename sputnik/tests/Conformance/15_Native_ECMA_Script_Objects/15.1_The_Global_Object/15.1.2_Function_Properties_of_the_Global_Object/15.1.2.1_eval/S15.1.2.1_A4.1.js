// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.1_A4.1;
 * @section: 15.1.2.1, 15.2.4.7, 12.6.4;
 * @assertion: The length property of eval has the attribute DontEnum;
 * @description: Checking use propertyIsEnumerable, for-in;
*/


//CHECK#1
if (eval.propertyIsEnumerable('length') !== false) {
  warn('#1: eval.propertyIsEnumerable(\'length\') === false. Actual: ' + (eval.propertyIsEnumerable('length')));
}

//CHECK#2
var result = true;
for (p in eval){
  if (p === "length") {
    result = false;
  }  
}

if (result !== true) {
  warn('#2: result = true; for (p in eval) { if (p === "length") result = false; };  result === true;');
}
