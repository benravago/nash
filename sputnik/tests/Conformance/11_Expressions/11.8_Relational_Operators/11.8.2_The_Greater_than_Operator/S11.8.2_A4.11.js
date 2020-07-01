// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.2_A4.11;
* @section: 11.8.2, 11.8.5;
* @assertion: If y is a prefix of x and x !== y, return true;
* @description: x and y are string primitives;
*/

//CHECK#1
if (("x " > "x") !== true) {
  warn('#1: ("x " > "x") === true');
}

//CHECK#2
if (("x" > "") !== true) {
  warn('#2: ("x" > "") === true');
}

//CHECK#3
if (("abcd" > "ab") !== true) {
  warn('#3: ("abcd" > ab") === true');
}

//CHECK#4
if (("abc\u0064" > "abcd") !== false) {
  warn('#4: ("abc\\u0064" > abc") === false');
}

//CHECK#5
if (("x" + "y" > "x") !== true) {
  warn('#5: ("x" + "y" > "x") === true');
}

//CHECK#6
var x = "x";
if ((x + 'y' > x) !== true) {
  warn('#6: var x = "x"; (x + "y" > x) === true');
}

//CHECK#7
if (("a\u0000a" > "a\u0000") !== true) {
  warn('#7: ("a\\u0000a" > "a\\u0000") === true');
}

//CHECK#8
if ((" x" > "x") !== false) {
  warn('#8: (" x" > "x") === false');
}

