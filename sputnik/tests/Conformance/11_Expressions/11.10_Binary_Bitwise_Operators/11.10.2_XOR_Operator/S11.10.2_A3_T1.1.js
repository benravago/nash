// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.10.2_A3_T1.1;
 * @section: 11.10.2;
 * @assertion: Operator x ^ y returns ToNumber(x) ^ ToNumber(y); 
 * @description: Type(x) and Type(y) are primitive boolean and Boolean object;
 */

//CHECK#1
if ((true ^ true) !== 0) {
  warn('#1: (true ^ true) === 0. Actual: ' + ((true ^ true)));
}

//CHECK#2
if ((new Boolean(true) ^ true) !== 0) {
  warn('#2: (new Boolean(true) ^ true) === 0. Actual: ' + ((new Boolean(true) ^ true)));
}

//CHECK#3
if ((true ^ new Boolean(true)) !== 0) {
  warn('#3: (true ^ new Boolean(true)) === 0. Actual: ' + ((true ^ new Boolean(true))));
}

//CHECK#4
if ((new Boolean(true) ^ new Boolean(true)) !== 0) {
  warn('#4: (new Boolean(true) ^ new Boolean(true)) === 0. Actual: ' + ((new Boolean(true) ^ new Boolean(true))));
}
