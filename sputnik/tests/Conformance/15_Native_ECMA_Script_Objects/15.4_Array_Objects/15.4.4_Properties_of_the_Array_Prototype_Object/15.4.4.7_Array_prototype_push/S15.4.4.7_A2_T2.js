// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.7_A2_T2;
 * @section: 15.4.4.7;
 * @assertion: The push function is intentionally generic. 
 * It does not require that its this value be an Array object;
 * @description: The arguments are appended to the end of the array, in 
 * the order in which they appear. The new length of the array is returned 
 * as the result of the call;
*/

var obj = {};
obj.push = Array.prototype.push;

//CHECK#1
obj.length = NaN;
var push = obj.push(-1);
if (push !== 1) {
  warn('#1: var obj = {}; obj.length = NaN; obj.push = Array.prototype.push; obj.push(-1) === 1. Actual: ' + (push));
}

//CHECK#2
if (obj.length !== 1) {
  warn('#2: var obj = {}; obj.length = NaN; obj.push = Array.prototype.push; obj.push(-1); obj.length === 1. Actual: ' + (obj.length));
}

//CHECK#3
if (obj["0"] !== -1) {
  warn('#3: var obj = {}; obj.length = NaN; obj.push = Array.prototype.push; obj.push(-1); obj["0"] === -1. Actual: ' + (obj["0"]));
}

//CHECK#4
obj.length = Number.POSITIVE_INFINITY;
var push = obj.push(-4);
if (push !== 1) {
  warn('#4: var obj = {}; obj.length = Number.POSITIVE_INFINITY; obj.push = Array.prototype.push; obj.push(-4) === 1. Actual: ' + (push));
}

//CHECK#5
if (obj.length !== 1) {
  warn('#6: var obj = {}; obj.length = Number.POSITIVE_INFINITY; obj.push = Array.prototype.push; obj.push(-4); obj.length === 1. Actual: ' + (obj.length));
}

//CHECK#6
if (obj["0"] !== -4) {
  warn('#6: var obj = {}; obj.length = Number.POSITIVE_INFINITY; obj.push = Array.prototype.push; obj.push(-4); obj["0"] === -4. Actual: ' + (obj["0"]));
}

//CHECK#7
obj.length = Number.NEGATIVE_INFINITY;
var push = obj.push(-7);
if (push !== 1) {
  warn('#7: var obj = {}; obj.length = Number.NEGATIVE_INFINITY; obj.push = Array.prototype.push; obj.push(-7) === 1. Actual: ' + (push));
}

//CHECK#8
if (obj.length !== 1) {
  warn('#8: var obj = {}; obj.length = Number.NEGATIVE_INFINITY; obj.push = Array.prototype.push; obj.push(-7); obj.length === 1. Actual: ' + (obj.length));
}

//CHECK#9
if (obj["0"] !== -7) {
  warn('#9: var obj = {}; obj.length = Number.NEGATIVE_INFINITY; obj.push = Array.prototype.push; obj.push(-7); obj["0"] === -7. Actual: ' + (obj["0"]));
}

//CHECK#10
obj.length = 0.5;
var push = obj.push(-10);
if (push !== 1) {
  warn('#10: var obj = {}; obj.length = 0.5; obj.push = Array.prototype.push; obj.push(-10) === 1. Actual: ' + (push));
}

//CHECK#11
if (obj.length !== 1) {
  warn('#11: var obj = {}; obj.length = 0.5; obj.push = Array.prototype.push; obj.push(-10); obj.length === 1. Actual: ' + (obj.length));
} 

//CHECK#12
if (obj["0"] !== -10) {
  warn('#12: var obj = {}; obj.length = 0.5; obj.push = Array.prototype.push; obj.push(-10); obj["0"] === -10. Actual: ' + (obj["0"]));
}

//CHECK#13
obj.length = 1.5;
var push = obj.push(-13);
if (push !== 2) {
  warn('#13: var obj = {}; obj.length = 1.5; obj.push = Array.prototype.push; obj.push(-13) === 2. Actual: ' + (push));
}

//CHECK#14
if (obj.length !== 2) {
  warn('#14: var obj = {}; obj.length = 1.5; obj.push = Array.prototype.push; obj.push(-13); obj.length === 2. Actual: ' + (obj.length));
} 

//CHECK#15
if (obj["1"] !== -13) {
  warn('#15: var obj = {}; obj.length = 1.5; obj.push = Array.prototype.push; obj.push(-13); obj["1"] === -13. Actual: ' + (obj["1"]));
}

//CHECK#16
obj.length = new Number(0);
var push = obj.push(-16);
if (push !== 1) {
  warn('#16: var obj = {}; obj.length = new Number(0); obj.push = Array.prototype.push; obj.push(-16) === 1. Actual: ' + (push));
}

//CHECK#17
if (obj.length !== 1) {
  warn('#17: var obj = {}; obj.length = new Number(0); obj.push = Array.prototype.push; obj.push(-16); obj.length === 1. Actual: ' + (obj.length));
}

//CHECK#18
if (obj["0"] !== -16) {
  warn('#18: var obj = {}; obj.length = new Number(0); obj.push = Array.prototype.push; obj.push(-16); obj["0"] === -16. Actual: ' + (obj["0"]));
}   
