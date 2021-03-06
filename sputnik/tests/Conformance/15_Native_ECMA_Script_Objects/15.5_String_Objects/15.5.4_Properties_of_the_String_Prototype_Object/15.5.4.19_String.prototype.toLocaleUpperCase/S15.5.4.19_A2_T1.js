// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.5.4.19_A2_T1;
* @section: 15.5.4.19;
* @assertion: String.prototype.toLocaleUpperCase() return a string, but not a String object;
* @description: Checking returned result;
*/


//////////////////////////////////////////////////////////////////////////////
//CHECK#1
if ("Hello, WoRlD!".toLocaleUpperCase() !== "HELLO, WORLD!") {
  warn('#1: "Hello, WoRlD!".toLocaleUpperCase() === "HELLO, WORLD!". Actual: '+("Hello, WoRlD!".toLocaleUpperCase()) );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#2
if ("Hello, WoRlD!".toLocaleUpperCase() !== String("HELLO, WORLD!")) {
  warn('#2: "Hello, WoRlD!".toLocaleUpperCase() === String("HELLO, WORLD!"). Actual: '+("Hello, WoRlD!".toLocaleUpperCase()) );
}
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
//CHECK#3
if ("Hello, WoRlD!".toLocaleUpperCase() ===new String("HELLO, WORLD!")) {
  warn('#3: "Hello, WoRlD!".toLocaleUpperCase() !== new String("HELLO, WORLD!"');
}
//
//////////////////////////////////////////////////////////////////////////////
