// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.2.2_A4_T5;
* @section: 11.2.2;
* @assertion: If NewExpression or MemberExpression does not implement internal [[Construct]] method, throw TypeError;
* @description: Checking Math object case;
*/

//CHECK#1
try {
  new Math;
  warn('#1: new Math throw TypeError');	
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#1: new Math throw TypeError');	
  }
}

//CHECK#2
try {
  new new Math();
  warn('#2: new new Math() throw TypeError');	
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#2: new new Math() throw TypeError');	
  }
}

//CHECK#3
try {
  var x = new Math();
  new x();
  warn('#3: var x = new Math(); new x() throw TypeError'); 
}
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#3: var x = new Math(); new x() throw TypeError'); 
  }
}

