// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S15.3.1_A1_T1;
* @section: 15.3.1;
* @assertion: The function call Function(…) is equivalent to the object creation expression 
* new Function(…) with the same arguments.
* @description: Create simple functions and check returned values;
*/

var f = Function("return arguments[0];");

//CHECK#1
if (!(f instanceof Function)){
  warn('#1: f instanceof Function');
}

//CHECK#2
if (f(1) !== 1) {
  warn('#2: f(1) !== 1');
}

var g = new Function("return arguments[0];");


//CHECK#3
if (!(g instanceof Function)) {
  warn('#3: g instanceof Function');
}

//CHECK#4
if (g("A") !== "A") {
  warn('#4: g("A") !== "A"');
}

//CHECK#5
if (g("A") !== f("A")) {
  warn('#5: g("A") !== f("A")');
}
