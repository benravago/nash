// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.1_A4.12_T1;
* @section: 11.8.1, 11.8.5;
* @assertion: If neither x, nor y is a prefix of each other, returned result of strings comparison applies a simple lexicographic ordering to the sequences of code point value values;
* @description: x and y are string primitives;
*/

//CHECK#1
if (("xx" < "xy") !== true) {
  warn('#1: ("xx" < "xy") === true');
}

//CHECK#2
if (("xy" < "xx") !== false) {
  warn('#2: ("xy" < "xx") === false');
}

//CHECK#3
if (("x" < "y") !== true) {
  warn('#3: ("x" < y") === true');
}

//CHECK#4
if (("aab" < "aba") !== true) {
  warn('#4: ("aab" < aba") === true');
}

//CHECK#5
if (("\u0061\u0061\u0061\u0062" < "\u0061\u0061\u0061\u0061") !== false) {
  warn('#5: ("\\u0061\\u0061\\u0061\\u0062" < \\u0061\\u0061\\u0061\\u0061") === false');
}

//CHECK#6
if (("a\u0000a" < "a\u0000b") !== true) {
  warn('#6: ("a\\u0000a" < "a\\u0000b") === true');
}

//CHECK#7
if (("aB" < "aa") !== true) {
  warn('#7: ("aB" < aa") === true');
}
