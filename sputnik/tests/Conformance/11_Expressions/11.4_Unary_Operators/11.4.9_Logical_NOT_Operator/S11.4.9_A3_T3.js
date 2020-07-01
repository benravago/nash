// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.4.9_A3_T3;
* @section: 11.4.9;
* @assertion: Operator !x returns !ToBoolean(x);
* @description: Type(x) is string primitive or String object;
*/

//CHECK#1
if (!"1" !== false) {
  warn('#1: !"1" === false');
}

//CHECK#2
if (!new String("0") !== false) {
  warn('#2: !new String("0") === false');
}

//CHECK#3
if (!"x" !== false) {
  warn('#3: !"x" === false');
}

//CHECK#4
if (!"" !== true) {
  warn('#4: !"" === true');
}

//CHECK#5
if (!new String("") !== false) {
  warn('#5: !new String("") === false');
}
