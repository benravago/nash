// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.19_A1_T4;
* @section: 15.5.4.19;
* @assertion: String.prototype.toLocaleUpperCase();
* @description: Call toLocaleUpperCase() function without arguments of string and from empty string;
*/

var __lowerCase = "".toLocaleUpperCase();
var __expected = ""; 

//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if (__lowerCase.length !== __expected.length) {
  warn('#1: __lowerCase = "".toLocaleUpperCase(); __expected = ""; __lowerCase.length === __expected.length. Actual: '+__lowerCase.length );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if (__lowerCase.index !== __expected.index) {
  warn('#2: __lowerCase = "".toLocaleUpperCase(); __expected = ""; __lowerCase.index === __expected.index. Actual: '+__lowerCase.index );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
if (__lowerCase.input !== __expected.input) {
  warn('#3: __lowerCase = "".toLocaleUpperCase(); __expected = ""; __lowerCase.input === __expected.input. Actual: '+__lowerCase.input );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#4
if (__lowerCase[0]!==__expected[0]) {
  warn('#4: __lowerCase = "".toLocaleUpperCase(); __lowerCase[0]==='+__expected[0]+'. Actual: '+__lowerCase[0]);
}
//
//////////////////////////////////////////////////////////////////////////////
