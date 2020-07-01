// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.4.4.5_A3.2_T2;
 * @section: 15.4.4.5;
 * @assertion: Operator use ToString from array arguments;
 * @description: If Type(argument) is Object, evaluate ToPrimitive(argument, String); 
*/

//CHECK#1
var object = {valueOf: function() {return "+"}};
var x = new Array(object);
if (x.join() !== "[object Object]") {
  warn('#1: var object = {valueOf: function() {return "+"}} var x = new Array(object); x.join() === "[object Object]". Actual: ' + (x.join()));
}

//CHECK#2
var object = {valueOf: function() {return "+"}, toString: function() {return "*"}};
var x = new Array(object);
if (x.join() !== "*") {
  warn('#2: var object = {valueOf: function() {return "+"}, toString: function() {return "*"}} var x = new Array(object); x.join() === "*". Actual: ' + (x.join()));
} 

//CHECK#3
var object = {valueOf: function() {return "+"}, toString: function() {return {}}};
var x = new Array(object);
if (x.join() !== "+") {
  warn('#3: var object = {valueOf: function() {return "+"}, toString: function() {return {}}} var x = new Array(object); x.join() === "+". Actual: ' + (x.join()));
}

//CHECK#4
try {
  var object = {valueOf: function() {throw "error"}, toString: function() {return "*"}};
  var x = new Array(object);
  if (x.join() !== "*") {
    warn('#4.1: var object = {valueOf: function() {throw "error"}, toString: function() {return "*"}} var x = new Array(object); x.join() === "*". Actual: ' + (x.join()));
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.2: var object = {valueOf: function() {throw "error"}, toString: function() {return "*"}} var x = new Array(object); x.join() not throw "error"');
  } else {
    warn('#4.3: var object = {valueOf: function() {throw "error"}, toString: function() {return "*"}} var x = new Array(object); x.join() not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
var object = {toString: function() {return "*"}};
var x = new Array(object);
if (x.join() !== "*") {
  warn('#5: var object = {toString: function() {return "*"}} var x = new Array(object); x.join() === "*". Actual: ' + (x.join()));
}

//CHECK#6
var object = {valueOf: function() {return {}}, toString: function() {return "*"}}
var x = new Array(object);
if (x.join() !== "*") {
  warn('#6: var object = {valueOf: function() {return {}}, toString: function() {return "*"}} var x = new Array(object); x.join() === "*". Actual: ' + (x.join()));
}

//CHECK#7
try {
  var object = {valueOf: function() {return "+"}, toString: function() {throw "error"}};
  var x = new Array(object);
  x.join();
  warn('#7.1: var object = {valueOf: function() {return "+"}, toString: function() {throw "error"}} var x = new Array(object); x.join() throw "error". Actual: ' + (x.join()));
}  
catch (e) {
  if (e !== "error") {
    warn('#7.2: var object = {valueOf: function() {return "+"}, toString: function() {throw "error"}} var x = new Array(object); x.join() throw "error". Actual: ' + (e));
  } 
}

//CHECK#8
try {
  var object = {valueOf: function() {return {}}, toString: function() {return {}}};
  var x = new Array(object);
  x.join();
  warn('#8.1: var object = {valueOf: function() {return {}}, toString: function() {return {}}} var x = new Array(object); x.join() throw TypeError. Actual: ' + (x.join()));
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8.2: var object = {valueOf: function() {return {}}, toString: function() {return {}}} var x = new Array(object); x.join() throw TypeError. Actual: ' + (e));
  } 
}
