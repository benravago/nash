// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.6_A2.1_T3;
* @section: 11.8.6;
* @assertion: Operator "instanceof" uses GetValue;
* @description: If GetBase(ShiftExpression) is null, throw ReferenceError;
*/

//CHECK#1
try {
  ({}) instanceof OBJECT;
  warn('#1.1: ({}) instanceof OBJECT throw ReferenceError. Actual: ' + (({}) instanceof OBJECT));  
}
catch (e) {
  if ((e instanceof ReferenceError) !== true) {
    warn('#1.2: ({}) instanceof OBJECT throw ReferenceError. Actual: ' + (e));  
  }
}
