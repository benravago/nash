// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
* @name: S11.12_A2.1_T1;
* @section: 11.12, 8.7.1;
* @assertion: Operator x ? y : z uses GetValue;
* @description: Either Type is not Reference or GetBase is not null;
*/

//CHECK#1
if ((true ? false : true) !== false) {
  warn('#1: (true ? false : true) === false');
}

//CHECK#2
if ((false ? false : true) !== true) {
  warn('#2: (false ? false : true) === true');
}

//CHECK#3
var x = new Boolean(true);
var y = new Boolean(false);
if ((x ? y : true) !== y) {
  warn('#3: var x = new Boolean(true); var y = new Boolean(false); (x ? y : true) === y');
}

//CHECK#4
var z = new Boolean(true);
if ((false ? false : z) !== z) {
  warn('#4: var z = new Boolean(true); (false ? false : z) === z');
}

//CHECK#5
var x = new Boolean(true);
var y = new Boolean(false);
var z = new Boolean(true);
if ((x ? y : z) !== y) {
  warn('#5: var x = new Boolean(true); var y = new Boolean(false); var z = new Boolean(true); (x ? y : z) === y');
}

//CHECK#6
var x = false;
var y = new Boolean(false);
var z = new Boolean(true);
if ((x ? y : z) !== z) {
  warn('#6: var x = false; var y = new Boolean(false); var z = new Boolean(true); (x ? y : z) === z');
}
