// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A3.1_T5;
 * @section: 15.1.2.2, 9.3;
 * @assertion: Operator use ToNumber;
 * @description: Checking for Number object;  
*/

//CHECK#1
if (parseInt("11", new Number(2)) !== parseInt("11", 2)) {
  warn('#1: parseInt("11", new Number(2)) === parseInt("11", 2). Actual: ' + (parseInt("11", new Number(2))));
}

//CHECK#2
if (parseInt("11", new Number(Infinity)) !== parseInt("11", Infinity)) {
  warn('#2: parseInt("11", new Number(Infinity)) === parseInt("11", Infinity). Actual: ' + (parseInt("11", new Number(Infinity))));
}
