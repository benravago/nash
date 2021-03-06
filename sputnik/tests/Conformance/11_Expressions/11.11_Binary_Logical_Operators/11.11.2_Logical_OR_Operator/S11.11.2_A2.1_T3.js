// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.11.2_A2.1_T3;
* @section: 11.11.2, 8.7.1;
* @assertion: Operator x || y uses GetValue;
* @description: If ToBoolean(x) is false and GetBase(y) is null, throw ReferenceError;
*/

//CHECK#1
try {
  false || y;
  warn('#1.1: false || y throw ReferenceError. Actual: ' + (false || y));  
}
catch (e) {
  if ((e instanceof ReferenceError) !== true) {
    warn('#1.2: false || y throw ReferenceError. Actual: ' + (e));  
  }
}
