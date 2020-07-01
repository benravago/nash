// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S8.4_A2;
 * @section: 8.4, 7.8.4;
 * @assertion: Empty string has type string;
 * @description: Create empty string and check it type;
*/

/////////////////////////////////////////////////////////
// CHECK#1
var str = '';
if (typeof(str) !== 'string'){
  warn('#1: var str = \'\'; typeof(str) === \'string\'. Actual: ' + (typeof(str)));
}
//
////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
// CHECK#2
var str = "";
if (typeof(str) !== "string"){
  warn('#2: var str = ""; typeof(str) === "string". Actual: ' + (str));
}
//
////////////////////////////////////////////////////////
