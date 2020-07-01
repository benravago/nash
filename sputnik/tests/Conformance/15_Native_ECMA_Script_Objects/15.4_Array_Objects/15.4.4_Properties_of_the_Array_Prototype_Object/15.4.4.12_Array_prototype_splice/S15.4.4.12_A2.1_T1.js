// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.12_A2.1_T1;
 * @section: 15.4.4.12;
 * @assertion: Operator use ToInteger from start;
 * @description: start is not integer;
*/

var x = [0,1,2,3];
var arr = x.splice(1.5,3);

//CHECK#1
arr.getClass = Object.prototype.toString;
if (arr.getClass() !== "[object " + "Array" + "]") {
  warn('#1: var x = [0,1,2,3]; var arr = x.splice(1.5,3); arr is Array object. Actual: ' + (arr.getClass()));
}

//CHECK#2
if (arr.length !== 3) {
  warn('#2: var x = [0,1,2,3]; var arr = x.splice(1.5,3); arr.length === 3. Actual: ' + (arr.length));
}      

//CHECK#3
if (arr[0] !== 1) {
  warn('#3: var x = [0,1,2,3]; var arr = x.splice(1.5,3); arr[0] === 1. Actual: ' + (arr[0]));
}

//CHECK#4
if (arr[1] !== 2) {
  warn('#4: var x = [0,1,2,3]; var arr = x.splice(1.5,3); arr[1] === 2. Actual: ' + (arr[1]));
}      

//CHECK#5
if (arr[2] !== 3) {
  warn('#5: var x = [0,1,2,3]; var arr = x.splice(1.5,3); arr[2] === 3. Actual: ' + (arr[2]));
}   

//CHECK#6
if (x.length !== 1) {
  warn('#6: var x = [0,1,2,3]; var arr = x.splice(1.5,3); x.length === 1. Actual: ' + (x.length));
} 

//CHECK#7
if (x[0] !== 0) {
  warn('#7: var x = [0,1,2,3]; var arr = x.splice(1.5,3); x[0] === 0. Actual: ' + (x[0]));
}   
