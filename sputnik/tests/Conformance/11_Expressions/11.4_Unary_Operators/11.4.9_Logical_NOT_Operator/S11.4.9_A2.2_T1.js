// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.4.9_A2.2_T1;
 * @section: 11.4.9, 8.6.2.6;
 * @assertion: Operator !x uses [[Default Value]];
 * @description: If Type(value) is Object, return false;
 */

//CHECK#1
var object = {valueOf: function() {return 1}};
if (!object !== false) {
  warn('#1: var object = {valueOf: function() {return 1}}; !object === false. Actual: ' + (!object));
}

//CHECK#2
var object = {valueOf: function() {return 1}, toString: function() {return 0}};
if (!object !== false) {
  warn('#2: var object = {valueOf: function() {return 1}, toString: function() {return 0}}; !object === false. Actual: ' + (!object));
} 

//CHECK#3
var object = {valueOf: function() {return 1}, toString: function() {return {}}};
if (!object !== false) {
  warn('#3: var object = {valueOf: function() {return 1}, toString: function() {return {}}}; !object === false. Actual: ' + (!object));
}

//CHECK#4
var object = {valueOf: function() {return 1}, toString: function() {throw "error"}};
if (!object !== false) {
  warn('#4: var object = {valueOf: function() {return 1}, toString: function() {throw "error"}}; !object === false. Actual: ' + (!object));
}

//CHECK#5
var object = {toString: function() {return 1}};
if (!object !== false) {
  warn('#5: var object = {toString: function() {return 1}}; !object === false. Actual: ' + (!object));
}

//CHECK#6
var object = {valueOf: function() {return {}}, toString: function() {return 1}}
if (!object !== false) {
  warn('#6: var object = {valueOf: function() {return {}}, toString: function() {return 1}}; !object === false. Actual: ' + (!object));
}

//CHECK#7
var object = {valueOf: function() {throw "error"}, toString: function() {return 1}};
if (!object !== false) {
  warn('#7: var object = {valueOf: function() {throw "error"}, toString: function() {return 1}}; !object === false. Actual: ' + (!object));
}  

//CHECK#8
var object = {valueOf: function() {return {}}, toString: function() {return {}}};
if (!object !== false) {
  warn('#8: var object = {valueOf: function() {return {}}, toString: function() {return {}}}; !object === false. Actual: ' + (!object));
}  
