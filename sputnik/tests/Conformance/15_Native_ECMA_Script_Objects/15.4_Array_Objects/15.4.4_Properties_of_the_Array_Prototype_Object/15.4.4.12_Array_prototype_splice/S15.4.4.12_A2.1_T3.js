// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.12_A2.1_T3;
 * @section: 15.4.4.12;
 * @assertion: Operator use ToInteger from start;
 * @description: start = Infinity;
*/

var x = [0,1,2,3];
var arr = x.splice(Number.POSITIVE_INFINITY,3);

//CHECK#1
arr.getClass = Object.prototype.toString;
if (arr.getClass() !== "[object " + "Array" + "]") {
  warn('#1: var x = [0,1,2,3]; var arr = x.splice(Number.POSITIVE_INFINITY,3); arr is Array object. Actual: ' + (arr.getClass()));
}

//CHECK#2
if (arr.length !== 0) {
  warn('#2: var x = [0,1,2,3]; var arr = x.splice(Number.POSITIVE_INFINITY,3); arr.length === 0. Actual: ' + (arr.length));
}      

//CHECK#3
if (x[0] !== 0) {
  warn('#3: var x = [0,1,2,3]; var x = x.splice(Number.POSITIVE_INFINITY,3); x[0] === 0. Actual: ' + (x[0]));
}

//CHECK#4
if (x[1] !== 1) {
  warn('#4: var x = [0,1,2,3]; var x = x.splice(Number.POSITIVE_INFINITY,3); x[1] === 1. Actual: ' + (x[1]));
}      

//CHECK#5
if (x[2] !== 2) {
  warn('#5: var x = [0,1,2,3]; var x = x.splice(Number.POSITIVE_INFINITY,3); x[2] === 2. Actual: ' + (x[2]));
}   

//CHECK#6
if (x[3] !== 3) {
  warn('#6: var x = [0,1,2,3]; var x = x.splice(Number.POSITIVE_INFINITY,3); x[3] === 3. Actual: ' + (x[3]));
} 
