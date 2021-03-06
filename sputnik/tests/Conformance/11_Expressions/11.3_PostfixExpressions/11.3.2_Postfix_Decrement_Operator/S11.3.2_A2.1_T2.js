// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.3.2_A2.1_T2;
* @section: 11.3.2, 11.6.3;
* @assertion: Operator x-- uses GetValue and PutValue;
* @description: If GetBase(x) is null, throw ReferenceError;
*/

//CHECK#1
try {
  x--;
  warn('#1.1: x-- throw ReferenceError. Actual: ' + (x--));  
}
catch (e) {
  if ((e instanceof ReferenceError) !== true) {
    warn('#1.2: x-- throw ReferenceError. Actual: ' + (e));  
  }
}
