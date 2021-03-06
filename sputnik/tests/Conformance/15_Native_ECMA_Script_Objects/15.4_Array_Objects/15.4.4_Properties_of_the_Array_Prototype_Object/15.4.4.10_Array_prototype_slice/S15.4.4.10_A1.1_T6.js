// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.10_A1.1_T6;
 * @section: 15.4.4.10;
 * @assertion: If start is positive, use min(start, length). 
 * If end is positive, use min(end, length);
 * @description: length > end > start > 0;
 * 
*/

var x = [0,1,2,3,4];
var arr = x.slice(2,4);

//CHECK#1
arr.getClass = Object.prototype.toString;
if (arr.getClass() !== "[object " + "Array" + "]") {
  warn('#1: var x = [0,1,2,3,4]; var arr = x.slice(2,4); arr is Array object. Actual: ' + (arr.getClass()));
}

//CHECK#2
if (arr.length !== 2) {
  warn('#2: var x = [0,1,2,3,4]; var arr = x.slice(2,4); arr.length === 2. Actual: ' + (arr.length));
}      

//CHECK#3
if (arr[0] !== 2) {
  warn('#3: var x = [0,1,2,3,4]; var arr = x.slice(2,4); arr[0] === 2. Actual: ' + (arr[0]));
}

//CHECK#4
if (arr[1] !== 3) {
  warn('#4: var x = [0,1,2,3,4]; var arr = x.slice(2,4); arr[1] === 3. Actual: ' + (arr[1]));
}      

//CHECK#5
if (arr[3] !== undefined) {
  warn('#5: var x = [0,1,2,3,4]; var arr = x.slice(2,4); arr[3] === undefined. Actual: ' + (arr[3]));
}   
