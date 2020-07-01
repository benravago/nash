// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
  * @name: S11.8.4_A3.1_T2.9;
  * @section: 11.8.4;
  * @assertion: If Type(Primitive(x)) is not String or Type(Primitive(y)) is not String, then operator x >= y returns ToNumber(x) >= ToNumber(y); 
  * @description: Type(Primitive(x)) is different from Type(Primitive(y)) and both types vary between Boolean (primitive or object) and Null;
 */

//CHECK#1
if (true >= null !== true) {
  warn('#1: true >= null === true');
}

//CHECK#2
if (null >= true !== false) {
  warn('#2: null >= true === false');
}

//CHECK#3
if (new Boolean(true) >= null !== true) {
  warn('#3: new Boolean(true) >= null === true');
}

//CHECK#4
if (null >= new Boolean(true) !== false) {
  warn('#4: null >= new Boolean(true) === false');
}
