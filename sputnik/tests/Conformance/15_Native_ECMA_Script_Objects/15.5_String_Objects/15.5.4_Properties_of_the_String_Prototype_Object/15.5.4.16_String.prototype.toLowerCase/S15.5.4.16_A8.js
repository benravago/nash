// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.16_A8;
* @section: 15.5.4.16;
* @assertion: The String.prototype.toLowerCase.length property has the attribute DontEnum;
* @description: Checking if enumerating the String.prototype.toLowerCase.length property fails;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#0
if (!(String.prototype.toLowerCase.hasOwnProperty('length'))) {
  $FAIL('#0: String.prototype.toLowerCase.hasOwnProperty(\'length\') return true. Actual: '+String.prototype.toLowerCase.hasOwnProperty('length'));
}
//
//////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
// CHECK#1
if (String.prototype.toLowerCase.propertyIsEnumerable('length')) {
  warn('#1: String.prototype.toLowerCase.propertyIsEnumerable(\'length\') return false');
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// CHECK#2
var count=0;

for (p in String.prototype.toLowerCase){
  if (p==="length") count++;
}

if (count !== 0) {
  warn('#2: count=0; for (p in String.prototype.toLowerCase){if (p==="length") count++;}; count === 0. Actual: '+count );
}
//
//////////////////////////////////////////////////////////////////////////////
