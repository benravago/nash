// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.10_A2_T5;
 * @section: 15.4.4.10;
 * @assertion: The slice function is intentionally generic.
 * It does not require that its this value be an Array object;
 * @description: If end is undefined use length;
*/

var obj = {};
obj.slice = Array.prototype.slice;
obj[0] = 0;
obj[1] = 1;
obj[2] = 2;
obj[3] = 3;
obj[4] = 4;
obj.length = 5;
var arr = obj.slice(2);

//CHECK#1
arr.getClass = Object.prototype.toString;
if (arr.getClass() !== "[object " + "Array" + "]") {
  warn('#1: var obj = {}; obj.slice = Array.prototype.slice; obj[0] = 0; obj[1] = 1; obj[2] = 2; obj[3] = 3; obj[4] = 4; obj.length = 5; var arr = obj.slice(2); arr is Array object. Actual: ' + (arr.getClass()));
}

//CHECK#2
if (arr.length !== 3) {
  warn('#2: var obj = {}; obj.slice = Array.prototype.slice; obj[0] = 0; obj[1] = 1; obj[2] = 2; obj[3] = 3; obj[4] = 4; obj.length = 5; var arr = obj.slice(2); arr.length === 3. Actual: ' + (arr.length));
}      

//CHECK#3
if (arr[0] !== 2) {
  warn('#3: var obj = {}; obj.slice = Array.prototype.slice; obj[0] = 0; obj[1] = 1; obj[2] = 2; obj[3] = 3; obj[4] = 4; obj.length = 5; var arr = obj.slice(2); arr[0] === 2. Actual: ' + (arr[0]));
}

//CHECK#4
if (arr[1] !== 3) {
  warn('#4: var obj = {}; obj.slice = Array.prototype.slice; obj[0] = 0; obj[1] = 1; obj[2] = 2; obj[3] = 3; obj[4] = 4; obj.length = 5; var arr = obj.slice(2); arr[1] === 3. Actual: ' + (arr[1]));
}      

//CHECK#5
if (arr[2] !== 4) {
  warn('#5: var obj = {}; obj.slice = Array.prototype.slice; obj[0] = 0; obj[1] = 1; obj[2] = 2; obj[3] = 3; obj[4] = 4; obj.length = 5; var arr = obj.slice(2); arr[2] === 4. Actual: ' + (arr[2]));
}   

//CHECK#6
if (arr[3] !== undefined) {
  warn('#6: var obj = {}; obj.slice = Array.prototype.slice; obj[0] = 0; obj[1] = 1; obj[2] = 2; obj[3] = 3; obj[4] = 4; obj.length = 5; var arr = obj.slice(2); arr[3] === undefined. Actual: ' + (arr[3]));
}   
