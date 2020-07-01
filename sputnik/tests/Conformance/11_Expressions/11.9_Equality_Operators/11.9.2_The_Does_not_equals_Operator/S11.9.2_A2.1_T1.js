// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.9.2_A2.1_T1;
 * @section: 11.9.2;
 * @assertion: Operator x != y uses GetValue;
 * @description: Either Type is not Reference or GetBase is not null;
*/

//CHECK#1
if ((1 != 1) !== false) {
  warn('#1: (1 != 1) === false');
}

//CHECK#2
var x = 1;
if ((x != 1) !== false) {
  warn('#2: var x = 1; (x != 1) === false');
}

//CHECK#3
var y = 1;
if ((1 != y) !== false) {
  warn('#3: var y = 1; (1 != y) === false');
}

//CHECK#4
var x = 1;
var y = 1;
if ((x != y) !== false) {
  warn('#4: var x = 1; var y = 1; (x != y) === false');
}

//CHECK#5
var objectx = new Object();
var objecty = new Object();
objectx.prop = 1;
objecty.prop = 1;
if ((objectx.prop != objecty.prop) !== false) {
  warn('#5: var objectx = new Object(); var objecty = new Object(); objectx.prop = 1; objecty.prop = 1; (objectx.prop != objecty.prop) === false');
}
