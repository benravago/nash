// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.11.2_A3_T1;
* @section: 11.11.2;
* @assertion: If ToBoolean(x) is false, return y;
* @description: Type(x) and Type(y) vary between primitive boolean and Boolean object;
*/

//CHECK#1
if ((false || true) !== true) {
  warn('#1: (false || true) === true');
}

//CHECK#2
if ((false || false) !== false) {
  warn('#2: (false || false) === false');
}

//CHECK#3
var y = new Boolean(true);
if ((false || y) !== y) {
  warn('#3: (var y = new Boolean(true); false || y) === y');
}

//CHECK#4
var y = new Boolean(false);
if ((false || y) !== y) {
  warn('#4: (var y = new Boolean(false); false || y) === y');
}
