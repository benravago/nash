// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.14_A2_T14;
* @section: 15.5.4.14;
* @assertion: String.prototype.split (separator, limit) returns an Array object into which substrings of the result of converting this object to a string have
* been stored. The substrings are determined by searching from left to right for occurrences of
* separator; these occurrences are not part of any substring in the returned array, but serve to divide up
* the string value. The value of separator may be a string of any length or it may be a RegExp object;
* @description: Call split("on"), instance is String("one-1 two-2 four-4");
*/

var __string = new String("one-1 two-2 four-4");

var __split = __string.split("on");

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (__split.constructor !== Array) {
  warn('#1: var __string = new String("one-1 two-2 four-4"); __split = __string.split("on"); __split.constructor === Array. Actual: '+__split.constructor );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (__split.length !== 2) {
  warn('#2: var __string = new String("one-1 two-2 four-4"); __split = __string.split("on"); __split.length === 2. Actual: '+__split.length );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
if (__split[0] !== "") {
  warn('#3: var __string = new String("one-1 two-2 four-4"); __split = __string.split("on"); __split[0] === "". Actual: '+__split[0]);
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#4
if (__split[1] !== "e-1 two-2 four-4") {
  warn('#4: var __string = new String("one-1 two-2 four-4"); __split = __string.split("on"); __split[1] === "e-1 two-2 four-4". Actual: '+__split[1] );
}
//
//////////////////////////////////////////////////////////////////////////////
