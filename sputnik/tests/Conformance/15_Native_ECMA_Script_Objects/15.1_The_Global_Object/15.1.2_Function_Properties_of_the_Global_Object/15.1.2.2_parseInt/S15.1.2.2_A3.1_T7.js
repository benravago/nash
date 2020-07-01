// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S15.1.2.2_A3.1_T7;
 * @section: 15.1.2.2, 9.3, 8.6.2.6;
 * @assertion: Operator use ToNumber;
 * @description: If Type(value) is Object, evaluate ToPrimitive(value, Number);  
*/

//CHECK#1
var object = {valueOf: function() {return 2}};
if (parseInt("11", object) !== parseInt("11", 2)) {
  warn('#1: var object = {valueOf: function() {return 2}}; parseInt("11", object) === parseInt("11", 2). Actual: ' + (parseInt("11", object)));
}

//CHECK#2
var object = {valueOf: function() {return 2}, toString: function() {return 1}};
if (parseInt("11", object) !== parseInt("11", 2)) {
  warn('#2: var object = {valueOf: function() {return 2}, toString: function() {return 1}}; parseInt("11", object) === parseInt("11", 2). Actual: ' + (parseInt("11", object)));
} 

//CHECK#3
var object = {valueOf: function() {return 2}, toString: function() {return {}}};
if (parseInt("11", object) !== parseInt("11", 2)) {
  warn('#3: var object = {valueOf: function() {return 2}, toString: function() {return {}}}; parseInt("11", object) === parseInt("11", 2). Actual: ' + (parseInt("11", object)));
}

//CHECK#4
try {
  var object = {valueOf: function() {return 2}, toString: function() {throw "error"}};
  if (parseInt("11", object) !== parseInt("11", 2)) {
    warn('#4.1: var object = {valueOf: function() {return 2}, toString: function() {throw "error"}}; parseInt("11", object) === parseInt("11", 2). Actual: ' + (parseInt("11", object)));
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.2: var object = {valueOf: function() {return 2}, toString: function() {throw "error"}}; parseInt("11", object) not throw "error"');
  } else {
    warn('#4.3: var object = {valueOf: function() {return 2}, toString: function() {throw "error"}}; parseInt("11", object) not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
var object = {toString: function() {return 2}};
if (parseInt("11", object) !== parseInt("11", 2)) {
  warn('#5: var object = {toString: function() {return 2}}; parseInt("11", object) === parseInt("11", 2). Actual: ' + (parseInt("11", object)));
}

//CHECK#6
var object = {valueOf: function() {return {}}, toString: function() {return 2}}
if (parseInt("11", object) !== parseInt("11", 2)) {
  warn('#6: var object = {valueOf: function() {return {}}, toString: function() {return 2}}; parseInt("11", object) === parseInt("11", 2). Actual: ' + (parseInt("11", object)));
}

//CHECK#7
try {
  var object = {valueOf: function() {throw "error"}, toString: function() {return 2}};
  parseInt("11", object);
  warn('#7.1: var object = {valueOf: function() {throw "error"}, toString: function() {return 2}}; parseInt("11", object) throw "error". Actual: ' + (parseInt("11", object)));
}  
catch (e) {
  if (e !== "error") {
    warn('#7.2: var object = {valueOf: function() {throw "error"}, toString: function() {return 2}}; parseInt("11", object) throw "error". Actual: ' + (e));
  } 
}

//CHECK#8
try {
  var object = {valueOf: function() {return {}}, toString: function() {return {}}};
  parseInt("11", object);
  warn('#8.1: var object = {valueOf: function() {return {}}, toString: function() {return {}}}; parseInt("11", object) throw TypeError. Actual: ' + (parseInt("11", object)));
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8.2: var object = {valueOf: function() {return {}}, toString: function() {return {}}}; parseInt("11", object) throw TypeError. Actual: ' + (e));
  } 
}
