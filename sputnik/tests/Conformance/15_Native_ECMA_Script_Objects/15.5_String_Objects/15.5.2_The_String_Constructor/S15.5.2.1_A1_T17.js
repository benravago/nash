// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.2.1_A1_T17;
* @section: 15.5.2.1;
* @assertion: When "String" is called as part of a new expression, it is a constructor: it initialises the newly created object and
* The [[Value]] property of the newly constructed object is set to ToString(value), or to the empty string if value is not supplied;
* @description: Creating string object with "new String()" initialized with numbers that have more than 1 significant digit following the point;
*/

var __str = new String(1.2345);
//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (typeof __str !== "object") {
  warn('#1: __str = new String(1.2345); typeof __str === "object". Actual: typeof __str ==='+typeof __str ); 
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#1.5
if (__str.constructor !== String) {
  warn('#1.5: __str = new String(1.2345); __str.constructor === String. Actual: __str.constructor ==='+__str.constructor ); 
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (__str !="1.2345") {
  warn('#2: __str = new String(1.2345); __str =="1.2345". Actual: __str =='+__str ); 
}
//
//////////////////////////////////////////////////////////////////////////////

__str = new String(1.234567890);
//////////////////////////////////////////////////////////////////////////////
//CHECK#3
if (typeof __str !== "object") {
  warn('#3: __str = new String(1.234567890); typeof __str === "object". Actual: typeof __str ==='+typeof __str ); 
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3.5
if (__str.constructor !== String) {
  warn('#3.5: __str = new String(1.234567890); __str.constructor === String. Actual: __str.constructor ==='+__str.constructor ); 
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#4
if (__str !="1.23456789") {
  warn('#4: __str = new String(1.234567890); __str =="1.23456789". Actual: __str =='+__str ); 
}
//
//////////////////////////////////////////////////////////////////////////////

__str = new String(1.234500000000000000000000000);
//////////////////////////////////////////////////////////////////////////////
//CHECK#5
if (typeof __str !== "object") {
  warn('#5: __str = new String(1.234500000000000000000000000); typeof __str === "object". Actual: typeof __str ==='+typeof __str ); 
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#5.5
if (__str.constructor !== String) {
  warn('#5.5: __str = new String(1.234500000000000000000000000); __str.constructor === String. Actual: __str.constructor ==='+__str.constructor ); 
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#6
if (__str !="1.2345") {
  warn('#6: __str = new String(1.234500000000000000000000000); __str =="1.2345". Actual: __str =='+__str ); 
}
//
//////////////////////////////////////////////////////////////////////////////
