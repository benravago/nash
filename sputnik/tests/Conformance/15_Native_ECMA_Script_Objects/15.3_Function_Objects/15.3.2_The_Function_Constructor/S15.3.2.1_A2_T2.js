// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.3.2.1_A2_T2;
* @section: 15.3.2.1;
* @assertion: It is permissible but not necessary to have one argument for each formal parameter to be specified;
* @description: Values of the function constructor arguments are "arg1, arg2", "arg3", "return arg1+arg2+arg3;";
*/

//CHECK#1
try {
  var f = Function("arg1, arg2", "arg3", "return arg1+arg2+arg3;");
} catch (e) {
  $FAIL('#1: test failed');
}

//CHECK#2
if (!(f instanceof Function)){
  warn('#2: It is permissible but not necessary to have one argument for each formal parameter to be specified');
}

//CHECK#3
if (f("AB","BA",1) !== "ABBA1") {
  warn('#3: It is permissible but not necessary to have one argument for each formal parameter to be specified');
}
