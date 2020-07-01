// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.1_A4.10;
* @section: 11.8.1, 11.8.5;
* @assertion: If y is a prefix of x, return false;
* @description: x and y are string primitives;
*/

//CHECK#1
if (("x" < "x") !== false) {
  warn('#1: ("x" < "x") === false');
}

//CHECK#2
if (("x" < "") !== false) {
  warn('#2: ("x" < "") === false');
}

//CHECK#3
if (("abcd" < "ab") !== false) {
  warn('#3: ("abcd" < ab") === false');
}

//CHECK#4
if (("abc\u0064" < "abcd") !== false) {
  warn('#4: ("abc\\u0064" < abcd") === false');
}

//CHECK#5
if (("x" + "y" < "x") !== false) {
  warn('#5: ("x" + "y" < "x") === false');
}

//CHECK#6
var x = "x";
if ((x + "y" < x) !== false) {
  warn('#6: var x = "x"; (x + "y" < x) === false');
}

