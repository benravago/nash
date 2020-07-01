// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.1_A3.1;
 * @section: 11.9.1, 11.9.3;
 * @assertion: Return true, if x and y are both true or both false; otherwise, return false;
 * @description: x and y are boolean primitives;
 */

//CHECK#1
if ((true == true) !== true) {
  warn('#1: (true == true) === true');
}

//CHECK#2
if ((false == false) !== true) {
  warn('#2: (false == false) === true');
}

//CHECK#3
if ((true == false) !== false) {
  warn('#3: (true == false) === false');
}

//CHECK#4
if ((false == true) !== false) {
  warn('#4: (false == true) === false');
}
