// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.8.2_A2.1_T1;
* @section: 11.8.2, 11.8.5;
* @assertion: Operator x > y uses GetValue;
* @description: Either Type is not Reference or GetBase is not null;
*/

//CHECK#1
if (2 > 1 !== true) {
  warn('#1: 2 > 1 === true');
}

//CHECK#2
var x = 2;
if (x > 1 !== true) {
  warn('#2: var x = 2; x > 1 === true');
}

//CHECK#3
var y = 1;
if (2 > y !== true) {
  warn('#3: var y = 1; 2 > y === true');
}

//CHECK#4
var x = 2;
var y = 1;
if (x > y !== true) {
  warn('#4: var x = 2; var y = 1; x > y === true');
}

//CHECK#5
var objectx = new Object();
var objecty = new Object();
objectx.prop = 2;
objecty.prop = 1;
if (objectx.prop > objecty.prop !== true) {
  warn('#5: var objectx = new Object(); var objecty = new Object(); objectx.prop = 2; objecty.prop = 1; objectx.prop > objecty.prop === true');
}
