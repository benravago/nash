// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.2_A3.1;
 * @section: 11.9.2, 11.9.3;
 * @assertion: Return false, if x and y are both true or both false; otherwise, return true;
 * @description: x and y are boolean primitives;
 */

//CHECK#1
if ((true != true) !== false) {
  warn('#1: (true != true) === false');
}

//CHECK#2
if ((false != false) !== false) {
  warn('#2: (false != false) === false');
}

//CHECK#3
if ((true != false) !== true) {
  warn('#3: (true != false) === true');
}

//CHECK#4
if ((false != true) !== true) {
  warn('#4: (false != true) === true');
}
