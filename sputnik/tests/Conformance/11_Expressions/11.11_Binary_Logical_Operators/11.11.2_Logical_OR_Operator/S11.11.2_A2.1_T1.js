// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.11.2_A2.1_T1;
* @section: 11.11.2, 8.7.1;
* @assertion: Operator x || y uses GetValue;
* @description: Either Type is not Reference or GetBase is not null;
*/

//CHECK#1
if ((true || false) !== true) {
  warn('#1: (true || false) === true');
}

//CHECK#2
if ((false || true) !== true) {
  warn('#2: (false || true) === true');
}

//CHECK#3
var x = new Boolean(false);
if ((x || true) !== x) {
  warn('#3: var x = Boolean(false); (x || true) === x');
}

//CHECK#4
var y = new Boolean(true);
if ((false || y) !== y) {
  warn('#4: var y = Boolean(true); (false || y) === y');
}

//CHECK#5
var x = new Boolean(false);
var y = new Boolean(true);
if ((x || y) !== x) {
  warn('#5: var x = new Boolean(false); var y = new Boolean(true); (x || y) === x');
}

//CHECK#6
var x = false;
var y = new Boolean(true);
if ((x || y) !== y) {
  warn('#6: var x = false; var y = new Boolean(true); (x || y) === y');
}

//CHECK#7
var objectx = new Object();
var objecty = new Object();
objectx.prop = false;
objecty.prop = 1.1;
if ((objectx.prop || objecty.prop) !== objecty.prop) {
  warn('#7: var objectx = new Object(); var objecty = new Object(); objectx.prop = false; objecty.prop = 1; (objectx.prop || objecty.prop) === objecty.prop');
}

//CHECK#8
var objectx = new Object();
var objecty = new Object();
objectx.prop = 1.1;
objecty.prop = false;
if ((objectx.prop || objecty.prop) !== objectx.prop) {
  warn('#8: var objectx = new Object(); var objecty = new Object(); objectx.prop = 1.1; objecty.prop = false; (objectx.prop || objecty.prop) === objectx.prop');
}
