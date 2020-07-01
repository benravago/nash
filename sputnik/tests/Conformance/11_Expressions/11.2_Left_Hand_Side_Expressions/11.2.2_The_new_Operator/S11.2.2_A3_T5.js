// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.2_A3_T5;
* @section: 11.2.2;
* @assertion: If Type(NewExpression) or Type(MemberExpression) is not Object, throw TypeError;
* @description: Checking "null primitive" case;
*/

//CHECK#1
try {
  new null;
  warn('#1: new null throw TypeError');	
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#1: new null throw TypeError');	
  }
}

//CHECK#2
try {
  var x = null;
  new x;
  warn('#2: var x = null; new x throw TypeError');	
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#2: var x = null; new x throw TypeError');	
  }
}

//CHECK#3
try {
  var x = null;
  new x();
  warn('#3: var x = null; new x() throw TypeError'); 
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#3: var x = null; new x() throw TypeError'); 
  }
}
