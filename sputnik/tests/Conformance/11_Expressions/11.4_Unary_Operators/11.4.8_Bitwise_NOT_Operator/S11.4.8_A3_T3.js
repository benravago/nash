// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.4.8_A3_T3;
* @section: 11.4.8;
* @assertion: Operator ~x returns ~ToInt32(x);
* @description: Type(x) is string primitive or String object;
*/

//CHECK#1
if (~"1" !== -2) {
  warn('#1: ~"1" === -2. Actual: ' + (~"1"));
}

//CHECK#2
if (~new String("0") !== -1) {
  warn('#2: ~new String("0") === -1. Actual: ' + (~new String("0")));
}

//CHECK#3
if (~"x" !== -1) {
  warn('#3: ~"x" === -1. Actual: ' + (~"x"));
}

//CHECK#4
if (~"" !== -1) {
  warn('#4: ~"" === -1. Actual: ' + (~""));
}

//CHECK#5
if (~new String("-2") !== 1) {
  warn('#5: ~new String("-2") === 1. Actual: ' + (~new String("-2")));
}
