// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.6_A2_T2;
 * @section: 15.4.4.6;
 * @assertion: The pop function is intentionally generic. 
 * It does not require that its this value be an Array object;
 * @description: If ToUint32(length) equal zero, call the [[Put]] method 
 * of this object with arguments "length" and 0 and return undefined;
*/

var obj = {};
obj.pop = Array.prototype.pop;

//CHECK#1
obj.length = NaN;
var pop = obj.pop();
if (pop !== undefined) {
  warn('#1: var obj = {}; obj.length = NaN; obj.pop = Array.prototype.pop; obj.pop() === undefined. Actual: ' + (pop));
}

//CHECK#2
if (obj.length !== 0) {
  warn('#2: var obj = {}; obj.length = NaN; obj.pop = Array.prototype.pop; obj.pop(); obj.length === 0. Actual: ' + (obj.length));
}

//CHECK#3
obj.length = Number.POSITIVE_INFINITY;
var pop = obj.pop();
if (pop !== undefined) {
  warn('#3: var obj = {}; obj.length = Number.POSITIVE_INFINITY; obj.pop = Array.prototype.pop; obj.pop() === undefined. Actual: ' + (pop));
}

//CHECK#4
if (obj.length !== 0) {
  warn('#4: var obj = {}; obj.length = Number.POSITIVE_INFINITY; obj.pop = Array.prototype.pop; obj.pop(); obj.length === 0. Actual: ' + (obj.length));
}

//CHECK#5
obj.length = Number.NEGATIVE_INFINITY;
var pop = obj.pop();
if (pop !== undefined) {
  warn('#5: var obj = {}; obj.length = Number.NEGATIVE_INFINITY; obj.pop = Array.prototype.pop; obj.pop() === undefined. Actual: ' + (pop));
}

//CHECK#6
if (obj.length !== 0) {
  warn('#6: var obj = {}; obj.length = Number.NEGATIVE_INFINITY; obj.pop = Array.prototype.pop; obj.pop(); obj.length === 0. Actual: ' + (obj.length));
}

//CHECK#7
obj.length = -0;
var pop = obj.pop();
if (pop !== undefined) {
  warn('#7: var obj = {}; obj.length = -0; obj.pop = Array.prototype.pop; obj.pop() === undefined. Actual: ' + (pop));
}    

//CHECK#8
if (obj.length !== 0) {
  warn('#8: var obj = {}; obj.length = -0; obj.pop = Array.prototype.pop; obj.pop(); obj.length === 0. Actual: ' + (obj.length));
} else {
  if (1/obj.length !== Number.POSITIVE_INFINITY) {
    warn('#8: var obj = {}; obj.length = -0; obj.pop = Array.prototype.pop; obj.pop(); obj.length === +0. Actual: ' + (obj.length));
  }  
}   

//CHECK#9
obj.length = 0.5;
var pop = obj.pop();
if (pop !== undefined) {
  warn('#9: var obj = {}; obj.length = 0.5; obj.pop = Array.prototype.pop; obj.pop() === undefined. Actual: ' + (pop));
}

//CHECK#10
if (obj.length !== 0) {
  warn('#10: var obj = {}; obj.length = 0.5; obj.pop = Array.prototype.pop; obj.pop(); obj.length === 0. Actual: ' + (obj.length));
} 

//CHECK#11
obj.length = new Number(0);
var pop = obj.pop();
if (pop !== undefined) {
  warn('#11: var obj = {}; obj.length = new Number(0); obj.pop = Array.prototype.pop; obj.pop() === undefined. Actual: ' + (pop));
}

//CHECK#12
if (obj.length !== 0) {
  warn('#12: var obj = {}; obj.length = new Number(0); obj.pop = Array.prototype.pop; obj.pop(); obj.length === 0. Actual: ' + (obj.length));
}
