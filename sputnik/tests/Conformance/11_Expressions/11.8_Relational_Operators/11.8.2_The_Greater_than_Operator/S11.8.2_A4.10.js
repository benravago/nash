// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.2_A4.10;
* @section: 11.8.2, 11.8.5;
* @assertion: If x is a prefix of y, return false;
* @description: x and y are string primitives;
*/

//CHECK#1
if (("x" > "x") !== false) {
  warn('#1: ("x" > "x") === false');
}

//CHECK#2
if (("" > "x") !== false) {
  warn('#2: ("" > "x") === false');
}

//CHECK#3
if (("ab" > "abcd") !== false) {
  warn('#3: ("ab" > abcd") === false');
}

//CHECK#4
if (("abcd" > "abc\u0064") !== false) {
  warn('#4: ("abcd" > abc\\u0064") === false');
}

//CHECK#5
if (("x" > "x" + "y") !== false) {
  warn('#5: ("x" > "x" + "y") === false');
}

//CHECK#6
var x = "x";
if ((x > x + "y") !== false) {
  warn('#6: var x = "x"; (x > x + "y") === false');
}
