// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.14_A4_T4;
* @section: 15.5.4.14;
* @assertion: String.prototype.split (separator, limit) returns an Array object into which substrings of the result of converting this object to a string have
* been stored. If separator is a regular expression then 
* inside of SplitMatch helper the [[Match]] method of R is called giving it the arguments corresponding;
* @description: Arguments are regexp /l/ and 2, and instance is String("hello");
*/

var __string = new String("hello");

var __re = /l/;

var __split = __string.split(__re,2);

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (__split.constructor !== Array) {
  warn('#1: var __string = new String("hello"); var __re = /l/; __split = __string.split(__re,2); __split.constructor === Array. Actual: '+__split.constructor );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (__split.length !== 2) {
  warn('#2: var __string = new String("hello"); var __re = /l/; __split = __string.split(__re,2); __split.length === 2. Actual: '+__split.length );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
if (__split[0] !== "he") {
  warn('#3: var __string = new String("hello"); var __re = /l/; __split = __string.split(__re,2); __split[0] === "he". Actual: '+__split[0]);
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#4
if (__split[1] !== "") {
  warn('#4: var __string = new String("hello"); var __re = /l/; __split = __string.split(__re,2); __split[1] === "". Actual: '+__split[1] );
}
//
//////////////////////////////////////////////////////////////////////////////
