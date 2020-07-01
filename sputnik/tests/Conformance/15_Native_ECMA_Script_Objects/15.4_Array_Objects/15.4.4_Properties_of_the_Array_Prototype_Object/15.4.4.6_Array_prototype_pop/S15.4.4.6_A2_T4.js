// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.6_A2_T4;
 * @section: 15.4.4.6;
 * @assertion: The pop function is intentionally generic. 
 * It does not require that its this value be an Array object;
 * @description: Operator use ToNumber from length.
 * If Type(value) is Object, evaluate ToPrimitive(value, Number); 
*/

var obj = {};
obj.pop = Array.prototype.pop;

//CHECK#1
obj[0] = -1;
obj.length = {valueOf: function() {return 1}};
var pop = obj.pop();
if (pop !== -1) {
  warn('#1: obj[0] = -1; obj.length = {valueOf: function() {return 1}}  obj.pop() === -1. Actual: ' + (pop));
}

//CHECK#2
obj[0] = -1;
obj.length = {valueOf: function() {return 1}, toString: function() {return 0}};
var pop = obj.pop();
if (pop !== -1) {
  warn('#0: obj[0] = -1; obj.length = {valueOf: function() {return 1}, toString: function() {return 0}}  obj.pop() === -1. Actual: ' + (pop));
} 

//CHECK#3
obj[0] = -1;
obj.length = {valueOf: function() {return 1}, toString: function() {return {}}};
var pop = obj.pop();
if (pop !== -1) {
  warn('#3: obj[0] = -1; obj.length = {valueOf: function() {return 1}, toString: function() {return {}}}  obj.pop() === -1. Actual: ' + (pop));
}

//CHECK#4
try {  
  obj[0] = -1;
  obj.length = {valueOf: function() {return 1}, toString: function() {throw "error"}};  
  var pop = obj.pop();
if (pop !== -1) {
    warn('#4.1: obj[0] = -1; obj.length = {valueOf: function() {return 1}, toString: function() {throw "error"}}; obj.pop() === ",". Actual: ' + (pop));
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.2: obj[0] = -1; obj.length = {valueOf: function() {return 1}, toString: function() {throw "error"}}; obj.pop() not throw "error"');
  } else {
    warn('#4.3: obj[0] = -1; obj.length = {valueOf: function() {return 1}, toString: function() {throw "error"}}; obj.pop() not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
obj[0] = -1;
obj.length = {toString: function() {return 0}};
var pop = obj.pop();
if (pop !== undefined) {
  warn('#5: obj[0] = -1; obj.length = {toString: function() {return 0}}  obj.pop() === undefined. Actual: ' + (pop));
}

//CHECK#6
obj[0] = -1;
obj.length = {valueOf: function() {return {}}, toString: function() {return 0}}
var pop = obj.pop();
if (pop !== undefined) {
  warn('#6: obj[0] = -1; obj.length = {valueOf: function() {return {}}, toString: function() {return 0}}  obj.pop() === undefined. Actual: ' + (pop));
}

//CHECK#7
try {
  obj[0] = -1;
  obj.length = {valueOf: function() {throw "error"}, toString: function() {return 0}};  
  var pop = obj.pop();
  warn('#7.1: obj[0] = -1; obj.length = {valueOf: function() {throw "error"}, toString: function() {return 0}}; obj.pop() throw "error". Actual: ' + (pop));
}  
catch (e) {
  if (e !== "error") {
    warn('#7.2: obj[0] = -1; obj.length = {valueOf: function() {throw "error"}, toString: function() {return 0}}; obj.pop() throw "error". Actual: ' + (e));
  } 
}

//CHECK#8
try {
  obj[0] = -1;
  obj.length = {valueOf: function() {return {}}, toString: function() {return {}}};
  var pop = obj.pop();
  warn('#8.1: obj[0] = -1; obj.length = {valueOf: function() {return {}}, toString: function() {return {}}}  obj.pop() throw TypeError. Actual: ' + (pop));
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8.2: obj[0] = -1; obj.length = {valueOf: function() {return {}}, toString: function() {return {}}}  obj.pop() throw TypeError. Actual: ' + (e));
  } 
}
