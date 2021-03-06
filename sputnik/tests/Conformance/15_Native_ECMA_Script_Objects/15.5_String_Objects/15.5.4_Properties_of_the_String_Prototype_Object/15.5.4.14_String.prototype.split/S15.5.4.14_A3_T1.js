// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.14_A3_T1;
* @section: 15.5.4.14;
* @assertion: String.prototype.split() returns an Array object with:
*  i) length equaled to 1,
* ii) [[Get]](0) equaled to the result of converting this object to a string;
* @description: Instance is String("one,two,three,four,five");
*/

var __string = new String("one,two,three,four,five");

var __split = __string.split();

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (__split.constructor !== Array) {
  warn('#1: var __string = new String("one,two,three,four,five"); __split = __string.split(); __split.constructor === Array. Actual: '+__split.constructor );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (__split.length !== 1) {
  warn('#2: var __string = new String("one,two,three,four,five"); __split = __string.split(); __split.length === 1. Actual: '+__split.length );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
if (__split[0] !== "one,two,three,four,five") {
  warn('#3: var __string = new String("one,two,three,four,five"); __split = __string.split(); __split[0] === "one,two,three,four,five". Actual: '+__split[0] );
}
//
//////////////////////////////////////////////////////////////////////////////
