// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.10_A1.2_T1;
 * @section: 15.4.4.10;
 * @assertion: If start is negative, use max(start + length, 0). 
 * If end is positive, use min(end, length);
 * @description: length > end = abs(start), start < 0;
*/

var x = [0,1,2,3,4];
var arr = x.slice(-3,3);

//CHECK#1
arr.getClass = Object.prototype.toString;
if (arr.getClass() !== "[object " + "Array" + "]") {
  warn('#1: var x = [0,1,2,3,4]; var arr = x.slice(-3,3); arr is Array object. Actual: ' + (arr.getClass()));
}

//CHECK#2
if (arr.length !== 1) {
  warn('#2: var x = [0,1,2,3,4]; var arr = x.slice(-3,3); arr.length === 1. Actual: ' + (arr.length));
}      

//CHECK#3
if (arr[0] !== 2) {
  warn('#3: var x = [0,1,2,3,4]; var arr = x.slice(-3,3); arr[0] === 2. Actual: ' + (arr[0]));
}

//CHECK#4
if (arr[1] !== undefined) {
  warn('#4: var x = [0,1,2,3,4]; var arr = x.slice(-3,3); arr[1] === undefined. Actual: ' + (arr[1]));
}   
