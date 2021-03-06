// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.2_A4.12_T1;
* @section: 11.8.2, 11.8.5;
* @assertion: If neither x, nor y is a prefix of each other, returned result of strings comparison applies a simple lexicographic ordering to the sequences of code point value values;
* @description: x and y are string primitives;
*/

//CHECK#1
if (("xy" > "xx") !== true) {
  warn('#1: ("xy" > "xx") === true');
}

//CHECK#2
if (("xx" > "xy") !== false) {
  warn('#2: ("xx" > "xy") === false');
}

//CHECK#3
if (("y" > "x") !== true) {
  warn('#3: ("y" > "x") === true');
}

//CHECK#4
if (("aba" > "aab") !== true) {
  warn('#4: ("aba" > aab") === true');
}

//CHECK#5
if (("\u0061\u0061\u0061\u0061" > "\u0061\u0061\u0061\u0062") !== false) {
  warn('#5: ("\\u0061\\u0061\\u0061\\u0061" > \\u0061\\u0061\\u0061\\u0062") === false');
}

//CHECK#6
if (("a\u0000b" > "a\u0000a") !== true) {
  warn('#6: ("a\\u0000b" > "a\\u0000a") === true');
}

//CHECK#7
if (("aa" > "aB") !== true) {
  warn('#7: ("aa" > aB") === true');
}
