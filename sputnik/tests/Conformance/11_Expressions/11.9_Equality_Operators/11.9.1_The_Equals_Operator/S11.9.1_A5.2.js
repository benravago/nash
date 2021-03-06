// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.1_A5.2;
 * @section: 11.9.1, 11.9.3;
 * @assertion: If Type(x) is Number and Type(y) is String, 
 * return the result of comparison x == ToNumber(y);
 * @description: x is primitive number, y is primitive string;
 */

//CHECK#1
if ((1 == "1") !== true) {
  warn('#1: (1 == "1") === true');
}

//CHECK#2
if ((1.100 == "+1.10") !== true) {
  warn('#2: (1.100 == "+1.10") === true');
}

//CHECK#3
if ((1 == "true") !== false) {
  warn('#3: (1 == "true") === false');
}

//CHECK#4
if ((255 == "0xff") !== true) {
  warn('#4: (255 == "0xff") === true');
}

//CHECK#5
if ((0 == "") !== true) {
  warn('#5: (0 == "") === true');
}
