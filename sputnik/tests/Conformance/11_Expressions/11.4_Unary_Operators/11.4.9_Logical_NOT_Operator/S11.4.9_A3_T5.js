// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.4.9_A3_T5;
* @section: 11.4.9;
* @assertion: Operator !x returns !ToBoolean(x);
* @description: Type(x) is Object object or Function object;
*/

//CHECK#1
if ((!{}) !== false) {
  warn('#1: !({}) === false');
}

//CHECK#2  
if (!(function(){return 1}) !== false) {
  warn('#2: !(function(){return 1}) === false');
}
