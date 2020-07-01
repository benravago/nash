// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.11.1_A2.1_T1;
* @section: 11.11.1, 8.7.1;
* @assertion: Operator x && y uses GetValue;
* @description: Either Type is not Reference or GetBase is not null;
*/

//CHECK#1
if ((false && true) !== false) {
  warn('#1: (false && true) === false');
}

//CHECK#2
if ((true && false) !== false) {
  warn('#2: (true && false) === false');
}

//CHECK#3
var x = false;
if ((x && true) !== false) {
  warn('#3: var x = false; (x && true) === false');
}

//CHECK#4
var y = new Boolean(false);
if ((true && y) !== y) {
  warn('#4: var y = new Boolean(false); (true && y) === y');
}

//CHECK#5
var x = false;
var y = true;
if ((x && y) !== false) {
  warn('#5: var x = false; var y = true; (x && y) === false');
}

//CHECK#6
var x = true;
var y = new Boolean(false);
if ((x && y) !== y) {
  warn('#6: var x = true; var y = new Boolean(false); (x && y) === y');
}

//CHECK#7
var objectx = new Object();
var objecty = new Object();
objectx.prop = true;
objecty.prop = 1.1;
if ((objectx.prop && objecty.prop) !== objecty.prop) {
  warn('#7: var objectx = new Object(); var objecty = new Object(); objectx.prop = true; objecty.prop = 1; (objectx.prop && objecty.prop) === objecty.prop');
}

//CHECK#8
var objectx = new Object();
var objecty = new Object();
objectx.prop = 0;
objecty.prop = true;
if ((objectx.prop && objecty.prop) !== objectx.prop) {
  warn('#8: var objectx = new Object(); var objecty = new Object(); objectx.prop = 0; objecty.prop = true; (objectx.prop && objecty.prop) === objectx.prop');
}
