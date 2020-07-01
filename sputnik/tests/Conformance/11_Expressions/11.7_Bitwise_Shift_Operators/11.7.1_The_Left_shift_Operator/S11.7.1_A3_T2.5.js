// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.7.1_A3_T2.5;
 * @section: 11.7.1;
 * @assertion: Operator x << y returns ToNumber(x) << ToNumber(y); 
 * @description: Type(x) is different from Type(y) and both types vary between String (primitive or object) or Boolean (primitive and object);
*/

//CHECK#1
if (true << "1" !== 2) {
  warn('#1: true << "1" === 2. Actual: ' + (true << "1"));
}

//CHECK#2
if ("1" << true !== 2) {
  warn('#2: "1" << true === 2. Actual: ' + ("1" << true));
}

//CHECK#3
if (new Boolean(true) << "1" !== 2) {
  warn('#3: new Boolean(true) << "1" === 2. Actual: ' + (new Boolean(true) << "1"));
}

//CHECK#4
if ("1" << new Boolean(true) !== 2) {
  warn('#4: "1" << new Boolean(true) === 2. Actual: ' + ("1" << new Boolean(true)));
}

//CHECK#5
if (true << new String("1") !== 2) {
  warn('#5: true << new String("1") === 2. Actual: ' + (true << new String("1")));
}

//CHECK#6
if (new String("1") << true !== 2) {
  warn('#6: new String("1") << true === 2. Actual: ' + (new String("1") << true));
}

//CHECK#7
if (new Boolean(true) << new String("1") !== 2) {
  warn('#7: new Boolean(true) << new String("1") === 2. Actual: ' + (new Boolean(true) << new String("1")));
}

//CHECK#8
if (new String("1") << new Boolean(true) !== 2) {
  warn('#8: new String("1") << new Boolean(true) === 2. Actual: ' + (new String("1") << new Boolean(true)));
}
