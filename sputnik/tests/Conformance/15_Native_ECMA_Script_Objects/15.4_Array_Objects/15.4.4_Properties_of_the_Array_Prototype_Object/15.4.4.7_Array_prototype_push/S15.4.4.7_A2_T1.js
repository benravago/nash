// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.7_A2_T1;
 * @section: 15.4.4.7;
 * @assertion: The push function is intentionally generic. 
 * It does not require that its this value be an Array object;
 * @description: The arguments are appended to the end of the array, in 
 * the order in which they appear. The new length of the array is returned 
 * as the result of the call;
*/

var obj = {};
obj.push = Array.prototype.push;

if (obj.length !== undefined) {
  warn('#0: var obj = {}; obj.length === undefined. Actual: ' + (obj.length));
} else {
    //CHECK#1  
    var push = obj.push(-1);
if (push !== 1) {
      warn('#1: var obj = {}; obj.push = Array.prototype.push; obj.push(-1) === 1. Actual: ' + (push));
    }
    //CHECK#2
    if (obj.length !== 1) {
      warn('#2: var obj = {}; obj.push = Array.prototype.push; obj.push(-1); obj.length === 1. Actual: ' + (obj.length));
    }
    //CHECK#3
    if (obj["0"] !== -1) {
      warn('#3: var obj = {}; obj.push = Array.prototype.push; obj.push(-1); obj["0"] === -1. Actual: ' + (obj["0"]));
    }
} 

//CHECK#4
obj.length = undefined;
var push = obj.push(-4);
if (push !== 1) {
  warn('#4: var obj = {}; obj.length = undefined; obj.push = Array.prototype.push; obj.push(-4) === 1. Actual: ' + (push));
} 

//CHECK#5
if (obj.length !== 1) {
  warn('#5: var obj = {}; obj.length = undefined; obj.push = Array.prototype.push; obj.push(-4); obj.length === 1. Actual: ' + (obj.length));
}

//CHECK#6
if (obj["0"] !== -4) {
  warn('#6: var obj = {}; obj.length = undefined; obj.push = Array.prototype.push; obj.push(-4); obj["0"] === -4. Actual: ' + (obj["0"]));
}

//CHECK#7
obj.length = null
var push = obj.push(-7);
if (push !== 1) {
  warn('#7: var obj = {}; obj.length = null; obj.push = Array.prototype.push; obj.push(-7) === 1. Actual: ' + (push));
} 

//CHECK#8
if (obj.length !== 1) {
  warn('#8: var obj = {}; obj.length = null; obj.push = Array.prototype.push; obj.push(-7); obj.length === 1. Actual: ' + (obj.length));
}

//CHECK#9
if (obj["0"] !== -7) {
  warn('#9: var obj = {}; obj.length = null; obj.push = Array.prototype.push; obj.push(-7); obj["0"] === -7. Actual: ' + (obj["0"]));
}
