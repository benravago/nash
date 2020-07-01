// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.13_A3_T2;
 * @section: 15.4.4.13;
 * @assertion: Check ToUint32(length) for non Array objects;
 * @description: length = -4294967295; 
*/

var obj = {};
obj.unshift = Array.prototype.unshift;
obj[0] = "";
obj.length = -4294967295;

//CHECK#1
var unshift = obj.unshift("x", "y", "z");
if (unshift !== 4) {
  warn('#1: var obj = {}; obj.unshift = Array.prototype.unshift; obj[0] = ""; obj.length = -4294967295; obj.unshift("x", "y", "z") === 4. Actual: ' + (unshift));
}

//CHECK#2
if (obj.length !== 4) {
  warn('#2: var obj = {}; obj.unshift = Array.prototype.unshift; obj[0] = ""; obj.length = -4294967295; obj.unshift("x", "y", "z"); obj.length === 4. Actual: ' + (obj.length));
}

//CHECK#3
if (obj[0] !== "x") {
   warn('#3: var obj = {}; obj.unshift = Array.prototype.unshift; obj[0] = ""; obj.length = -4294967295; obj.unshift("x", "y", "z"); obj[0] === "x". Actual: ' + (obj[0]));
}

//CHECK#4
if (obj[1] !== "y") {
   warn('#4: var obj = {}; obj.unshift = Array.prototype.unshift; obj[0] = ""; obj.length = -4294967295; obj.unshift("x", "y", "z"); obj[1] === "y". Actual: ' + (obj[1]));
}  

//CHECK#5
if (obj[2] !== "z") {
   warn('#5: var obj = {}; obj.unshift = Array.prototype.unshift; obj[0] = ""; obj.length = -4294967295; obj.unshift("x", "y", "z"); obj[2] === "z". Actual: ' + (obj[2]));
}

//CHECK#6
if (obj[3] !== "") {
   warn('#6: var obj = {}; obj.unshift = Array.prototype.unshift; obj[0] = ""; obj.length = -4294967295; obj.unshift("x", "y", "z"); obj[3] === "". Actual: ' + (obj[3]));
}        
