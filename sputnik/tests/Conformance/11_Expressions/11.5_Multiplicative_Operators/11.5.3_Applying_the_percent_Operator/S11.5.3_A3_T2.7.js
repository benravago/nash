// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.5.3_A3_T2.7;
 * @section: 11.5.3;
 * @assertion: Operator x % y returns ToNumber(x) % ToNumber(y); 
 * @description: Type(x) is different from Type(y) and both types vary between String (primitive or object) and Null;
 */

//CHECK#1
if (isNaN("1" % null) !== true) {
  warn('#1: "1" % null === Not-a-Number. Actual: ' + ("1" % null));
}

//CHECK#2
if (null % "1" !== 0) {
  warn('#2: null % "1" === 0. Actual: ' + (null % "1"));
}

//CHECK#3
if (isNaN(new String("1") % null) !== true) {
  warn('#3: new String("1") % null === Not-a-Number. Actual: ' + (new String("1") % null));
}

//CHECK#4
if (null % new String("1") !== 0) {
  warn('#4: null % new String("1") === 0. Actual: ' + (null % new String("1")));
}
