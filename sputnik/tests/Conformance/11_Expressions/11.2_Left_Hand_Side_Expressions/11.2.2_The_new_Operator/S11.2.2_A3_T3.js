// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.2_A3_T3;
* @section: 11.2.2;
* @assertion: If Type(NewExpression) or Type(MemberExpression) is not Object, throw TypeError;
* @description: Checking "string primitive" case;
*/

//CHECK#1
try {
  new 1;
  warn('#1: new "1" throw TypeError');	
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#1: new "1" throw TypeError');	
  }
}

//CHECK#2
try {
  var x = "1";
  new x;
  warn('#2: var x = "1"; new x throw TypeError');	
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#2: var x = "1"; new x throw TypeError');	
  }
}

//CHECK#3
try {
  var x = "1";
  new x();
  warn('#3: var x = "1"; new x() throw TypeError'); 
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#3: var x = "1"; new x() throw TypeError'); 
  }
}
