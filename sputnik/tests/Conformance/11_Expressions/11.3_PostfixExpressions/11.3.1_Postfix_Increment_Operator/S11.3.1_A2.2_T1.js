// Copyright 2009 the Sputnik authors.  All rights reserved.
// This code is governed by the BSD license found in the LICENSE file.

/**
 * @name: S11.3.1_A2.2_T1;
 * @section: 11.3.1, 8.6.2.6;
 * @assertion: Operator x++ uses [[Default Value]];
 * @description: If Type(value) is Object, evaluate ToPrimitive(value, Number);
 */

//CHECK#1
var object = {valueOf: function() {return 1}};
var y = object++;
if (y !== 1) {
  warn('#1: var object = {valueOf: function() {return 1}}; var y = object++; y === 1. Actual: ' + (y));
} else {
  if (object !== 1 + 1) {
    warn('#1: var object = {valueOf: function() {return 1}}; object++; object === 1 + 1. Actual: ' + (object));
  }
}

//CHECK#2
var object = {valueOf: function() {return 1}, toString: function() {return 0}};
var y = object++;
if (y !== 1) {
  warn('#2: var object = {valueOf: function() {return 1}, toString: function() {return 0}}; var y = object++; y === 1. Actual: ' + (y));
} else {
  if (object !== 1 + 1) {
    warn('#2: var object = {valueOf: function() {return 1}, toString: function() {return 0}}; object++; object === 1 + 1. Actual: ' + (object));
  }
}

//CHECK#3
var object = {valueOf: function() {return 1}, toString: function() {return {}}};
var y = object++;
if (y !== 1) {
  warn('#3: var object = {valueOf: function() {return 1}, toString: function() {return {}}}; var y = object++; y === 1. Actual: ' + (y));
} else {
  if (object !== 1 + 1) {
    warn('#3: var object = {valueOf: function() {return 1}, toString: function() {return {}}}; object++; object === 1 + 1. Actual: ' + (object));
  }
}

//CHECK#4
try {
  var object = {valueOf: function() {return 1}, toString: function() {throw "error"}};
  var y = object++;
  if (y !== 1) {
    warn('#4.1: var object = {valueOf: function() {return 1}, toString: function() {throw "error"}}; var y = object++; y === 1. Actual: ' + (y));
  } else {
    if (object !== 1 + 1) {
      warn('#4.2: var object = {valueOf: function() {return 1}, toString: function() {throw "error"}}; object++; object === 1 + 1. Actual: ' + (object));
    }
  }
}
catch (e) {
  if (e === "error") {
    warn('#4.3: var object = {valueOf: function() {return 1}, toString: function() {throw "error"}}; var y = object++; y not throw "error"');
  } else {
    warn('#4.4: var object = {valueOf: function() {return 1}, toString: function() {throw "error"}}; var y = object++; y not throw Error. Actual: ' + (e));
  }
}

//CHECK#5
var object = {toString: function() {return 1}};
var y = object++;
if (y !== 1) {
  warn('#5.1: var object = {toString: function() {return 1}}; var y = object++; y === 1. Actual: ' + (y));
}  else {
  if (object !== 1 + 1) {
    warn('#5.2: var object = {toString: function() {return 1}}; object++; object === 1 + 1. Actual: ' + (object));
  }
}


//CHECK#6
var object = {valueOf: function() {return {}}, toString: function() {return 1}}
var y = object++;
if (y !== 1) {
  warn('#6.1: var object = {valueOf: function() {return {}}, toString: function() {return 1}}; var y = object++; y === 1. Actual: ' + (y));
} else {
  if (object !== 1 + 1) {
    warn('#6.2: var object = {valueOf: function() {return {}}, toString: function() {return 1}}; object++; object === 1 + 1. Actual: ' + (object));
  }
}

//CHECK#7
try {
  var object = {valueOf: function() {throw "error"}, toString: function() {return 1}};
  var y = object++;
  warn('#7.1: var object = {valueOf: function() {throw "error"}, toString: function() {return 1}}; object++ throw "error". Actual: ' + (y));
}  
catch (e) {
  if (e !== "error") {
    warn('#7.2: var object = {valueOf: function() {throw "error"}, toString: function() {return 1}}; object++ throw "error". Actual: ' + (e));
  } 
}

//CHECK#8
try {
  var object = {valueOf: function() {return {}}, toString: function() {return {}}};
  var y = object++;
  warn('#8.1: var object = {valueOf: function() {return {}}, toString: function() {return {}}}; object++ throw TypeError. Actual: ' + (y));
}  
catch (e) {
  if ((e instanceof TypeError) !== true) {
    warn('#8.2: var object = {valueOf: function() {return {}}, toString: function() {return {}}}; object++ throw TypeError. Actual: ' + (e));
  } 
}
