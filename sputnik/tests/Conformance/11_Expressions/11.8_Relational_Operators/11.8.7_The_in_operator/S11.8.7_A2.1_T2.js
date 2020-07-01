// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.7_A2.1_T2;
* @section: 11.8.7;
* @assertion: Operator "in" uses GetValue;
* @description: If GetBase(RelationalExpression) is null, throw ReferenceError;
*/

//CHECK#1
try {
  MAX_VALUE in Number;
  warn('#1.1: MAX_VALUE in Number throw ReferenceError. Actual: ' + (MAX_VALUE in Number));  
}
catch (e) {
  if ((e instanceof ReferenceError) !== true) {
    warn('#1.2: MAX_VALUE in Number throw ReferenceError. Actual: ' + (e));  
  }
}
