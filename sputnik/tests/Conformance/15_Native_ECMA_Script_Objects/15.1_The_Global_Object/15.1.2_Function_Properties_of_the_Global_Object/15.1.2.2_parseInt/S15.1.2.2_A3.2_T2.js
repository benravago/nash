// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A3.2_T2;
 * @section: 15.1.2.2;
 * @assertion: Operator use ToInt32;
 * @description: ToInt32 use floor;  
*/

//CHECK#1
if (parseInt("11", 2.1) !== parseInt("11", 2)) {
  warn('#1: parseInt("11", 2.1) === parseInt("11", 2). Actual: ' + (parseInt("11", 2.1)));
}

//CHECK#2
if (parseInt("11", 2.5) !== parseInt("11", 2)) {
  warn('#2: parseInt("11", 2.5) === parseInt("11", 2). Actual: ' + (parseInt("11", 2.5)));
}

//CHECK#3
if (parseInt("11", 2.9) !== parseInt("11", 2)) {
  warn('#3: parseInt("11", 2.9) === parseInt("11", 2). Actual: ' + (parseInt("11", 2.9)));
}

//CHECK#4
if (parseInt("11", 2.000000000001) !== parseInt("11", 2)) {
  warn('#4: parseInt("11", 2.000000000001) === parseInt("11", 2). Actual: ' + (parseInt("11", 2.000000000001)));
}

//CHECK#5
if (parseInt("11", 2.999999999999) !== parseInt("11", 2)) {
  warn('#5: parseInt("11", 2.999999999999) === parseInt("11", 2). Actual: ' + (parseInt("11", 2.999999999999)));
}
