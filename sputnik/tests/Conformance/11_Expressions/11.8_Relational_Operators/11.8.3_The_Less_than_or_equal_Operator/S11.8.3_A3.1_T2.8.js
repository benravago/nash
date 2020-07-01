// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
  * @name: S11.8.3_A3.1_T2.8;
  * @section: 11.8.3;
  * @assertion: Operator x <= y returns ToNumber(x) <= ToNumber(y), if Type(Primitive(x)) is not String or Type(Primitive(y)) is not String;
  * @description: Type(Primitive(x)) is different from Type(Primitive(y)) and both types vary between Boolean (primitive or object) and Undefined;
 */

//CHECK#1
if (true <= undefined !== false) {
  warn('#1: true <= undefined === false');
}

//CHECK#2
if (undefined <= true !== false) {
  warn('#2: undefined <= true === false');
}

//CHECK#3
if (new Boolean(true) <= undefined !== false) {
  warn('#3: new Boolean(true) <= undefined === false');
}

//CHECK#4
if (undefined <= new Boolean(true) !== false) {
  warn('#4: undefined <= new Boolean(true) === false');
}
