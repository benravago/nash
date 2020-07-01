// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.1_A2.1_T1;
 * @section: 15.4.1;
 * @assertion: The length property of the newly constructed object; 
 * is set to the number of arguments;
 * @description: Array constructor is given no arguments or at least two arguments
*/

//CHECK#1
if (Array().length !== 0) {
  warn('#1: (Array().length === 0. Actual: ' + (Array().length));
}

//CHECK#2
if (Array(0,1,0,1).length !== 4) {
  warn('#2: (Array(0,1,0,1).length === 4. Actual: ' + (Array(0,1,0,1).length));
}

//CHECK#3
if (Array(undefined, undefined).length !== 2) {
  warn('#3: (Array(undefined, undefined).length === 2. Actual: ' + (Array(undefined, undefined).length));
}
