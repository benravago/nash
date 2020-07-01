// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A3.2_T3;
 * @section: 15.1.2.2;
 * @assertion: Operator use ToInt32;
 * @description: ToInt32 use modulo;  
*/

//CHECK#1
if (parseInt("11", 4294967298) !== parseInt("11", 2)) {
  warn('#1: parseInt("11", 4294967298) === parseInt("11", 2). Actual: ' + (parseInt("11", 4294967298)));
}

//CHECK#2
if (parseInt("11", 4294967296) !== parseInt("11", 10)) {
  warn('#2: parseInt("11", 4294967296) === parseInt("11", 10). Actual: ' + (parseInt("11", 4294967296)));
}

//CHECK#3
if (isNaN(parseInt("11", -2147483650)) !== true) {
  warn('#3: parseInt("11", 2147483650) === Not-a-Number. Actual: ' + (parseInt("11", 2147483650)));
}

//CHECK#4
if (parseInt("11", -4294967294) !== parseInt("11", 2)) {
  warn('#4: parseInt("11", -4294967294) === parseInt("11", 2). Actual: ' + (parseInt("11", -4294967294)));
}
