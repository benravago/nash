// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.12_A1.4_T1;
 * @section: 15.4.4.12;
 * @assertion: If start is negative, use max(start + length, 0). 
 * If deleteCount is positive, use min(deleteCount, length - start);
 * @description: length = -start > deleteCount > 0, itemCount = 0;
*/

var x = [0,1,2,3];
var arr = x.splice(-4,3);

//CHECK#1
arr.getClass = Object.prototype.toString;
if (arr.getClass() !== "[object " + "Array" + "]") {
  warn('#1: var x = [0,1,2,3]; var arr = x.splice(-4,3); arr is Array object. Actual: ' + (arr.getClass()));
}

//CHECK#2
if (arr.length !== 3) {
  warn('#2: var x = [0,1,2,3]; var arr = x.splice(-4,3); arr.length === 3. Actual: ' + (arr.length));
}      

//CHECK#3
if (arr[0] !== 0) {
  warn('#3: var x = [0,1,2,3]; var arr = x.splice(-4,3); arr[0] === 0. Actual: ' + (arr[0]));
}

//CHECK#4
if (arr[1] !== 1) {
  warn('#4: var x = [0,1,2,3]; var arr = x.splice(-4,3); arr[1] === 1. Actual: ' + (arr[1]));
}      

//CHECK#5
if (arr[2] !== 2) {
  warn('#5: var x = [0,1,2,3]; var arr = x.splice(-4,3); arr[2] === 2. Actual: ' + (arr[2]));
}   

//CHECK#6
if (x.length !== 1) {
  warn('#6: var x = [0,1,2,3]; var arr = x.splice(-4,3); x.length === 1. Actual: ' + (x.length));
} 

//CHECK#7
if (x[0] !== 3) {
  warn('#7: var x = [0,1,2,3]; var arr = x.splice(-4,3); x[0] === 3. Actual: ' + (x[0]));
} 
