// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.2_A3_T1;
* @section: 11.2.2;
* @assertion: If Type(NewExpression) or Type(MemberExpression) is not Object, throw TypeError;
* @description: Checking boolean primitive case;
*/

//CHECK#1
try {
  new true;
  warn('#1: new true throw TypeError');	
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#1: new true throw TypeError');	
  }
}

//CHECK#2
try {
  var x = true;
  new x;
  warn('#2: var x = true; new x throw TypeError');	
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#2: var x = true; new x throw TypeError');	
  }
}

//CHECK#3
try {
  var x = true;
  new x();
  warn('#3: var x = true; new x() throw TypeError');  
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#3: var x = true; new x() throw TypeError');  
  }
}

