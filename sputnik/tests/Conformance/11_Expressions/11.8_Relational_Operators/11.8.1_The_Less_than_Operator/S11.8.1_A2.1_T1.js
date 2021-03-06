// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.1_A2.1_T1;
* @section: 11.8.1, 11.8.5;
* @assertion: Operator x < y uses GetValue;
* @description: Either Type is not Reference or GetBase is not null;
*/

//CHECK#1
if (1 < 2 !== true) {
  warn('#1: 1 < 2 === true');
}

//CHECK#2
var x = 1;
if (x < 2 !== true) {
  warn('#2: var x = 1; x < 2 === true');
}

//CHECK#3
var y = 2;
if (1 < y !== true) {
  warn('#3: var y = 2; 1 < y === true');
}

//CHECK#4
var x = 1;
var y = 2;
if (x < y !== true) {
  warn('#4: var x = 1; var y = 2; x < y === true');
}

//CHECK#5
var objectx = new Object();
var objecty = new Object();
objectx.prop = 1;
objecty.prop = 2;
if (objectx.prop < objecty.prop !== true) {
  warn('#5: var objectx = new Object(); var objecty = new Object(); objectx.prop = 1; objecty.prop = 2; objectx.prop < objecty.prop === true');
}
