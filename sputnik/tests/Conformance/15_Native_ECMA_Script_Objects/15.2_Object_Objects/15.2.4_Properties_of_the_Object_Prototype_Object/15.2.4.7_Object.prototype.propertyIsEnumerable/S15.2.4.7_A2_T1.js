// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.2.4.7_A2_T1;
* @section: 15.2.4.7;
* @assertion: When the propertyIsEnumerable method is called with argument V, the following steps are taken:
* i) Let O be this object
* ii) Call ToString(V)
* iii) If O doesn't have a property with the name given by Result(ii), return false
* iv) If the property has the DontEnum attribute, return false
* v) Return true;
* @description: Checking the type of Object.prototype.propertyIsEnumerable and the returned result;
*/

//CHECK#1
if (typeof Object.prototype.propertyIsEnumerable !== "function") {
  warn('#1: hasOwnProperty method is defined');
}

//CHECK#2
if (Object.prototype.propertyIsEnumerable("propertyIsEnumerable")) {
  warn('#2: hasOwnProperty method works properly');
}
//
