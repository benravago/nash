// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.8_A1_T7;
* @section: 15.5.4.8;
* @assertion: String.prototype.lastIndexOf(searchString, position);
* @description: Call lastIndexOf(searchString, position) function with undefined argument of string object;
*/

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
//since ToString(undefined) evaluates to "undefined" lastIndexOf(undefined) evaluates to lastIndexOf("undefined",0)
if (String("undefined").lastIndexOf(undefined) !== 0) {
  warn('#1: String("undefined").lastIndexOf(undefined) === 0. Actual: '+String("undefined").lastIndexOf(undefined) );
}
//
//////////////////////////////////////////////////////////////////////////////
