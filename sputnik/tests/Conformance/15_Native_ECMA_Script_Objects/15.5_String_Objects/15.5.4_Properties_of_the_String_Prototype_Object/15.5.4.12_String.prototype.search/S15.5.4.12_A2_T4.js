// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.12_A2_T4;
* @section: 15.5.4.12;
* @assertion: String.prototype.search (regexp) returns ...;
* @description: Checking case sensitive of search, argument is RegExp with uppercase symbols;
*/

var bString = new String("one two three four five");
var regExp = /Four/;

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (bString.search(regExp)!== -1) {
  warn('#1: var bString = new String("one two three four five"); var regExp = /Four/; bString.search(regExp)=== -1. Actual: '+bString.search(regExp));
}
//
//////////////////////////////////////////////////////////////////////////////
