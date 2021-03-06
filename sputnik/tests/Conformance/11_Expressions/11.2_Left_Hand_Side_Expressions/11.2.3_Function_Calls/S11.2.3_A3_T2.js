// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.3_A3_T2;
* @section: 11.2.3;
* @assertion: If MemberExpression is not Object, throw TypeError;
* @description: Checking "number primitive" case;
*/

//CHECK#1
try {
  1();
    warn('#1.1: 1() throw TypeError. Actual: ' + (1()));	
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#1.2: 1() throw TypeError. Actual: ' + (e));	
  }
}

//CHECK#2
try {
  var x = 1;
  x();
    warn('#2.1: var x = 1; x() throw TypeError. Actual: ' + (x()));	
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#2.2: var x = 1; x() throw TypeError. Actual: ' + (e));	
  }
}
