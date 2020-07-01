// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A1_T7;
 * @section: 15.1.2.2, 9.8, 8.6.2.6;
 * @assertion: Operator use ToString;
 * @description: If Type(value) is Object, evaluate ToPrimitive(value, String);  
*/

//CHECK#1
var object = {valueOf: function() {return 1}};
if (isNaN(parseInt(object)) !== true) {
  warn('#1: var object = {valueOf: function() {return 1}}; parseInt(object) === Not-a-Number. Actual: ' + (parseInt(object)));
}

//CHECK#2
var object = {valueOf: function() {return 1}, toString: function() {return 0}};
if (parseInt(object) !== 0) {
  warn('#2: var object = {valueOf: function() {return 1}, toString: function() {return 0}}; parseInt(object) === 0. Actual: ' + (parseInt(object)));
} 

//CHECK#3
var object = {valueOf: function() {return 1}, toString: function() {return {}}};
if (parseInt(object) !== 1) {
  warn('#3: var object = {valueOf: function() {return 1}, toString: function() {return {}}}; parseInt(object) === 1. Actual: ' + (parseInt(object)));
}

//CHECK#4
try {
  var object = {valueOf: function() {throw "error"}, toString: function() {return 1}};
  if (parseInt(object) !== 1) {
    warn('#4.1: var object = {valueOf: function() {throw "error"}, toString: function() {return 1}}; parseInt(object) === 1. Actual: ' + (parseInt(object)));
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.2: var object = {valueOf: function() {throw "error"}, toString: function() {return 1}}; parseInt(object) not throw "error"');
  } else {
    warn('#4.3: var object = {valueOf: function() {throw "error"}, toString: function() {return 1}}; parseInt(object) not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
var object = {toString: function() {return 1}};
if (parseInt(object) !== 1) {
  warn('#5: var object = {toString: function() {return 1}}; parseInt(object) === 1. Actual: ' + (parseInt(object)));
}

//CHECK#6
var object = {valueOf: function() {return {}}, toString: function() {return 1}}
if (parseInt(object) !== 1) {
  warn('#6: var object = {valueOf: function() {return {}}, toString: function() {return 1}}; parseInt(object) === 1. Actual: ' + (parseInt(object)));
}

//CHECK#7
try {
  var object = {valueOf: function() {return 1}, toString: function() {throw "error"}};
  parseInt(object);
  warn('#7.1: var object = {valueOf: function() {return 1}, toString: function() {throw "error"}}; parseInt(object) throw "error". Actual: ' + (parseInt(object)));
}  
catch (e) {
  if (e !== "error") {
    warn('#7.2: var object = {valueOf: function() {return 1}, toString: function() {throw "error"}}; parseInt(object) throw "error". Actual: ' + (e));
  } 
}

//CHECK#8
try {
  var object = {valueOf: function() {return {}}, toString: function() {return {}}};
  parseInt(object);
  warn('#8.1: var object = {valueOf: function() {return {}}, toString: function() {return {}}}; parseInt(object) throw TypeError. Actual: ' + (parseInt(object)));
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8.2: var object = {valueOf: function() {return {}}, toString: function() {return {}}}; parseInt(object) throw TypeError. Actual: ' + (e));
  } 
}
