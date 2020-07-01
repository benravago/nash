// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.4.4.7_A6.1;
* @section: 15.4.4.7, 15.2.4.7, 12.6.4;
* @assertion: The length property of push has the attribute DontEnum;
* @description: Checking use propertyIsEnumerable, for-in;
*/


//CHECK#1
if (Array.prototype.push.propertyIsEnumerable('length') !== false) {
  warn('#1: Array.prototype.push.propertyIsEnumerable(\'length\') === false. Actual: ' + (Array.prototype.push.propertyIsEnumerable('length')));
}

//CHECK#2
var result = true;
for (var p in Array.push){
  if (p === "length") {
    result = false;
  }  
}

if (result !== true) {
  warn('#2: result = true; for (p in Array.push) { if (p === "length") result = false; }  result === true;');
}

