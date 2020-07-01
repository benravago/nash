// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S9.7_A3.1_T4;
 * @section: 9.7;
 * @assertion: Operator uses ToNumber;
 * @description: Type(x) is Object; 
*/

//CHECK#1
var object = {valueOf: function() {return 1}};
if (String.fromCharCode(object).charCodeAt(0) !== 1) {
  warn('#1: var object = {valueOf: function() {return 1}}; String.fromCharCode(object).charCodeAt(0) === 1. Actual: ' + (String.fromCharCode(object).charCodeAt(0)));
}

//CHECK#2
var object = {valueOf: function() {return 1}, toString: function() {return 0}};
if (String.fromCharCode(object).charCodeAt(0) !== 1) {
  warn('#2: var object = {valueOf: function() {return 1}, toString: function() {return 0}}; String.fromCharCode(object).charCodeAt(0) === 1. Actual: ' + (String.fromCharCode(object).charCodeAt(0)));
} 

//CHECK#3
var object = {valueOf: function() {return 1}, toString: function() {return {}}};
if (String.fromCharCode(object).charCodeAt(0) !== 1) {
  warn('#3: var object = {valueOf: function() {return 1}, toString: function() {return {}}}; String.fromCharCode(object).charCodeAt(0) === 1. Actual: ' + (String.fromCharCode(object).charCodeAt(0)));
}

//CHECK#4
try {
  var object = {valueOf: function() {return 1}, toString: function() {throw "error"}};
  if (String.fromCharCode(object).charCodeAt(0) !== 1) {
    warn('#4.1: var object = {valueOf: function() {return 1}, toString: function() {throw "error"}}; String.fromCharCode(object).charCodeAt(0) === 1. Actual: ' + (String.fromCharCode(object).charCodeAt(0)));
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.2: var object = {valueOf: function() {return 1}, toString: function() {throw "error"}}; object not throw "error"');
  } else {
    warn('#4.3: var object = {valueOf: function() {return 1}, toString: function() {throw "error"}}; object not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
var object = {toString: function() {return 1}};
if (String.fromCharCode(object).charCodeAt(0) !== 1) {
  warn('#5: var object = {toString: function() {return 1}}; String.fromCharCode(object).charCodeAt(0) === 1. Actual: ' + (String.fromCharCode(object).charCodeAt(0)));
}

//CHECK#6
var object = {valueOf: function() {return {}}, toString: function() {return 1}}
if (String.fromCharCode(object).charCodeAt(0) !== 1) {
  warn('#6: var object = {valueOf: function() {return {}}, toString: function() {return 1}}; String.fromCharCode(object).charCodeAt(0) === 1. Actual: ' + (String.fromCharCode(object).charCodeAt(0)));
}

//CHECK#7
try {
  var object = {valueOf: function() {throw "error"}, toString: function() {return 1}};
  object >>> 0;
  warn('#7.1: var object = {valueOf: function() {throw "error"}, toString: function() {return 1}}; object throw "error". Actual: ' + (object >>> 0));
}  
catch (e) {
  if (e !== "error") {
    warn('#7.2: var object = {valueOf: function() {throw "error"}, toString: function() {return 1}}; object throw "error". Actual: ' + (e));
  } 
}

//CHECK#8
try {
  var object = {valueOf: function() {return {}}, toString: function() {return {}}};
  object >>> 0;
  warn('#8.1: var object = {valueOf: function() {return {}}, toString: function() {return {}}}; object throw TypeError. Actual: ' + (object >>> 0));
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8.2: var object = {valueOf: function() {return {}}, toString: function() {return {}}}; object throw TypeError. Actual: ' + (e));
  } 
}
