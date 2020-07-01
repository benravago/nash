// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.6_A2_T1;
 * @section: 15.4.4.6;
 * @assertion: The pop function is intentionally generic. 
 * It does not require that its this value be an Array object;
 * @description: If ToUint32(length) equal zero, call the [[Put]] method 
 * of this object with arguments "length" and 0 and return undefined;
*/

var obj = {};
obj.pop = Array.prototype.pop;

if (obj.length !== undefined) {
  warn('#0: var obj = {}; obj.length === undefined. Actual: ' + (obj.length));
} else {
    //CHECK#1  
    var pop = obj.pop();
if (pop !== undefined) {
      warn('#1: var obj = {}; obj.pop = Array.prototype.pop; obj.pop() === undefined. Actual: ' + (pop));
    }
    //CHECK#2
    if (obj.length !== 0) {
      warn('#2: var obj = {}; obj.pop = Array.prototype.pop; obj.pop(); obj.length === 0. Actual: ' + (obj.length));
    }
}    

//CHECK#3
obj.length = undefined;
var pop = obj.pop();
if (pop !== undefined) {
  warn('#3: var obj = {}; obj.length = undefined; obj.pop = Array.prototype.pop; obj.pop() === undefined. Actual: ' + (pop));
} 

//CHECK#4
if (obj.length !== 0) {
  warn('#4: var obj = {}; obj.length = undefined; obj.pop = Array.prototype.pop; obj.pop(); obj.length === 0. Actual: ' + (obj.length));
}

//CHECK#5
obj.length = null
var pop = obj.pop();
if (pop !== undefined) {
  warn('#5: var obj = {}; obj.length = null; obj.pop = Array.prototype.pop; obj.pop() === undefined. Actual: ' + (pop));
} 

//CHECK#6
if (obj.length !== 0) {
  warn('#6: var obj = {}; obj.length = null; obj.pop = Array.prototype.pop; obj.pop(); obj.length === 0. Actual: ' + (obj.length));
}
