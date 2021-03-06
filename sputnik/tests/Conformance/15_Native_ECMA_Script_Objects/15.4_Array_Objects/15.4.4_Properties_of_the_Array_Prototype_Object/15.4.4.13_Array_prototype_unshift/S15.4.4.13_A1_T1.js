// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.13_A1_T1;
 * @section: 15.4.4.13;
 * @assertion: The arguments are prepended to the start of the array, such that 
 * their order within the array is the same as the order in which they appear in 
 * the argument list;
 * @description: Checking case when unsift is given no arguments or one argument;
*/

//CHECK#1
var x = new Array();
var unshift = x.unshift(1);
if (unshift !== 1) {
  warn('#1: x = new Array(); x.unshift(1) === 1. Actual: ' + (unshift));
}  

//CHECK#2
if (x[0] !== 1) {
  warn('#2: x = new Array(); x.unshift(1); x[0] === 1. Actual: ' + (x[0]));
}

//CHECK#3
var unshift = x.unshift();
if (unshift !== 1) {
  warn('#3: x = new Array(); x.unshift(1); x.unshift() === 1. Actual: ' + (unshift));
}

//CHECK#4
if (x[1] !== undefined) {
  warn('#4: x = new Array(); x.unshift(1); x.unshift(); x[1] === unedfined. Actual: ' + (x[1]));
}

//CHECK#5
var unshift = x.unshift(-1);
if (unshift !== 2) {
  warn('#5: x = new Array(); x.unshift(1); x.unshift(); x.unshift(-1) === 2. Actual: ' + (unshift));
}

//CHECK#6
if (x[0] !== -1) {
  warn('#6: x = new Array(); x.unshift(1); x.unshift(-1); x[0] === -1. Actual: ' + (x[0]));
}

//CHECK#7
if (x[1] !== 1) {
  warn('#7: x = new Array(); x.unshift(1); x.unshift(-1); x[1] === 1. Actual: ' + (x[1]));
}

//CHECK#8
if (x.length !== 2) {
  warn('#8: x = new Array(); x.unshift(1); x.unshift(); x.unshift(-1); x.length === 2. Actual: ' + (x.length));
} 
