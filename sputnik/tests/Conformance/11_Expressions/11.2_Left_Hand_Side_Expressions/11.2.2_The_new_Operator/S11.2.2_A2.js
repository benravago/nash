// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.2_A2;
* @section: 11.2.2;
* @assertion: Operator "new" uses GetValue;
* @description: If GetBase(NewExpression) or GetBase(MemberExpression) is null, throw ReferenceError;
*/

//CHECK#1
try {
  new x;
  warn('#1.1: new x throw ReferenceError. Actual: ' + (new x));  
}
catch (e) {
  if ((e instanceof ReferenceError) !== true) {
    warn('#1.2: new x throw ReferenceError. Actual: ' + (e));  
  }
}

//CHECK#2
try {
  new x();
  warn('#2: new x() throw ReferenceError'); 
}
catch (e) {
  if ((e instanceof ReferenceError) !== true) {
    warn('#2: new x() throw ReferenceError'); 
  }
}
