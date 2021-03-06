// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.7.3_A3_T2.8;
 * @section: 11.7.3;
 * @assertion: Operator x >>> y returns ToNumber(x) >>> ToNumber(y); 
 * @description: Type(x) is different from Type(y) and both types vary between Boolean (primitive or object) and Undefined;
 */

//CHECK#1
if (true >>> undefined !== 1) {
  warn('#1: true >>> undefined === 1. Actual: ' + (true >>> undefined));
}

//CHECK#2
if (undefined >>> true !== 0) {
  warn('#2: undefined >>> true === 0. Actual: ' + (undefined >>> true));
}

//CHECK#3
if (new Boolean(true) >>> undefined !== 1) {
  warn('#3: new Boolean(true) >>> undefined === 1. Actual: ' + (new Boolean(true) >>> undefined));
}

//CHECK#4
if (undefined >>> new Boolean(true) !== 0) {
  warn('#4: undefined >>> new Boolean(true) === 0. Actual: ' + (undefined >>> new Boolean(true)));
}
